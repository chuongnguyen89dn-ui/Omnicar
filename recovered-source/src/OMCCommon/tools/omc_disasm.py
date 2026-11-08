#!/usr/bin/env python3
"""omc_disasm.py — annotated arm64 disassembly driver for OmniCar RE.

Builds on the wave-1 parsers (metadata/tools/macho_scan.py, macho_objc.py)
and capstone 5.0.7. Produces per-function annotated disassembly dumps and
resolution maps (stubs->imports, __cfstring->literal, selrefs, classrefs).

Usage:
  omc_disasm.py <dylib> --dumpdir <dir>     # dump every function in __text
  omc_disasm.py <dylib> --overview          # symbols/functions overview JSON
  omc_disasm.py <dylib> --funcbytes <name>  # hex bytes of one exported function
"""
import json
import struct
import sys
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parents[3] / "metadata" / "tools"))
from macho_scan import split_fat, parse_slice  # noqa: E402
from macho_objc import Slice  # noqa: E402
from capstone import Cs, CS_ARCH_ARM64, CS_MODE_LITTLE_ENDIAN  # noqa: E402
from capstone.arm64 import (  # noqa: E402
    ARM64_INS_ADRP, ARM64_INS_ADD, ARM64_INS_LDR, ARM64_INS_BL, ARM64_INS_B,
    ARM64_INS_BR, ARM64_OP_IMM, ARM64_OP_MEM, ARM64_OP_REG,
)

LC_FUNCTION_STARTS = 0x26


class Image:
    def __init__(self, path, cpu="arm64"):
        self.path = path
        data = Path(path).read_bytes()
        self.slices = {}
        for c, off, size in split_fat(data):
            scan = parse_slice(data, off)
            self.slices[c] = (Slice(data[off:off + size], scan), scan, data[off:off + size])
        if cpu not in self.slices:
            raise SystemExit(f"no {cpu} slice in {path}; have {list(self.slices)}")
        self.sl, self.scan, self.raw = self.slices[cpu]
        self.cpu = cpu
        self._build_maps()

    # ---------- basics ----------
    def section(self, seg, name):
        return self.sl.sections.get((seg, name))

    def sec_name_of(self, va):
        for (seg, name), s in self.sl.sections.items():
            if s["addr"] <= va < s["addr"] + s["size"]:
                return f"{seg},{name}+{va - s['addr']:#x}"
        for vmaddr, vmsize, _fo, _fs, nm in self.sl.segments:
            if vmaddr <= va < vmaddr + vmsize:
                return f"{nm}+{va - vmaddr:#x}"
        return None

    def function_starts(self):
        # find LC_FUNCTION_STARTS dataoff/datasize from raw load commands
        d = self.raw
        ncmds = struct.unpack_from("<I", d, 16)[0]
        off = 32
        fs = None
        for _ in range(ncmds):
            cmd, cmdsize = struct.unpack_from("<II", d, off)
            if cmd == LC_FUNCTION_STARTS:
                doff, dsize = struct.unpack_from("<II", d, off + 8)
                fs = (doff, dsize)
            off += cmdsize
        if fs is None:
            return []
        doff, dsize = fs
        blob = d[doff:doff + dsize]
        starts = []
        addr = 0  # deltas accumulate from the __TEXT segment vmaddr (0 here)
        i = 0
        while i < len(blob):
            # uleb128 delta
            result = 0
            shift = 0
            while True:
                b = blob[i]
                i += 1
                result |= (b & 0x7F) << shift
                shift += 7
                if not (b & 0x80):
                    break
            if result == 0:
                break
            addr += result
            starts.append(addr)
        return sorted(starts)

    def decode_ptr2(self, raw, storage_va):
        """Own chained-fixup decode (arm64 slices, fmt 6).

        NOTE: the wave-1 parser's _import_name treats bind ordinals as
        1-based; empirically (anchors: stubs called by OMCPrefsSync /
        OMCPref resolve to CFPreferencesAppSynchronize/CopyAppValue/
        SetAppValue) the stored ordinal is the 0-based imports index.
        """
        sl = self.sl
        fmt = sl.seg_ptr_format.get(sl.seg_index_of(storage_va))
        if fmt is None:
            fmt = sl.default_fmt if sl.default_fmt is not None else 6
        if fmt == 6:  # DYLD_CHAINED_PTR_64_OFFSET
            if (raw >> 63) & 1:
                ordinal = raw & 0xFFFF
                if 0 <= ordinal < len(sl.imports):
                    return ("bind", sl.imports[ordinal])
                return ("bind", f"<ordinal {ordinal}>")
            return ("ptr", sl.base + (raw & ((1 << 36) - 1)))
        # fall back to the wave-1 decoder for other formats
        return sl.decode_ptr(raw, storage_va)

    def ptr_at2(self, va):
        raw = self.sl.read_u64(va)
        if raw is None:
            return ("null", 0)
        return self.decode_ptr2(raw, va)

    def _build_maps(self):
        sl = self.sl
        # defined/undefined symbols
        self.def_syms = {}   # name -> va
        self.sym_at = {}     # va -> name
        for s in sl.symbols:
            if s["kind"] == "defined_sect":
                self.def_syms[s["name"]] = s["value"]
                self.sym_at.setdefault(s["value"], s["name"])
        # function boundaries
        self.fstarts = self.function_starts()
        self.fstart_set = set(self.fstarts)
        # stubs -> import names
        self.stub_names = {}
        st = self.section("__TEXT", "__stubs")
        if st:
            base, size = st["addr"], st["size"]
            for a in range(base, base + size, 12):
                code = sl.read(a, 12)
                if not code or len(code) < 12:
                    continue
                w0, w1, _w2 = struct.unpack("<III", code)
                # adrp x16, page ; ldr x16, [x16, #off] ; br x16
                if (w0 & 0x9F00001F) == 0x90000010 and (w1 & 0xFFC003FF) == 0xF9400210:
                    page = (a & ~0xFFF) + ((((w0 >> 29) & 3) | (((w0 >> 5) & 0x7FFFF) << 2)) << 12)
                    # sign extend 21-bit page offset
                    pg = (((w0 >> 29) & 3) | (((w0 >> 5) & 0x7FFFF) << 2))
                    if pg & (1 << 20):
                        pg -= (1 << 21)
                    page = (a & ~0xFFF) + (pg << 12)
                    goff = ((w1 >> 10) & 0xFFF) * 8
                    got_va = page + goff
                    kind, val = self.ptr_at2(got_va)
                    if kind == "bind":
                        self.stub_names[a] = val
        # objc stubs -> selector names (decode each 32-byte entry w/ capstone)
        self.objc_stub_sel = {}
        ost = self.section("__TEXT", "__objc_stubs")
        if ost:
            md = Cs(CS_ARCH_ARM64, CS_MODE_LITTLE_ENDIAN)
            md.detail = True
            base, size = ost["addr"], ost["size"]
            ent = 32
            for a in range(base, base + size, ent):
                code = sl.read(a, ent)
                if not code:
                    continue
                pages = {}
                for insn in md.disasm(code, a):
                    ops = insn.operands
                    if insn.id == ARM64_INS_ADRP and len(ops) == 2 and ops[1].type == ARM64_OP_IMM:
                        pages[insn.reg_name(ops[0].reg)] = ops[1].imm
                    elif insn.id == ARM64_INS_LDR and len(ops) == 2 and ops[1].type == ARM64_OP_MEM:
                        rn = insn.reg_name(ops[1].mem.base)
                        if rn in pages:
                            tgt = pages[rn] + ops[1].mem.disp
                            nm = self.selref_name(tgt)
                            if nm:
                                self.objc_stub_sel[a] = nm
                                break
        # cfstrings
        self.cfstrings = {}
        cf = self.section("__DATA_CONST", "__cfstring")
        if cf:
            base, size = cf["addr"], cf["size"]
            for a in range(base, base + size, 32):
                _isa, flags, p, ln = struct.unpack("<QQQQ", sl.read(a, 32))
                kind, val = sl.decode_ptr(p, a + 16)
                s = None
                if kind == "ptr":
                    if flags & 0x800:  # UTF-16 in __ustring: chars are 2 bytes
                        rawb = sl.read(val, ln * 2)
                        if rawb:
                            try:
                                s = rawb.decode("utf-16-le")
                            except Exception:
                                s = None
                    if s is None:
                        s = sl.read_cstr(val)
                self.cfstrings[a] = (s, flags, ln)

    def selref_name(self, va):
        kind, val = self.sl.ptr_at(va)
        if kind == "ptr":
            return self.sl.read_cstr(val)
        return None

    def classref_name(self, va):
        kind, val = self.ptr_at2(va)
        if kind == "bind":
            return val.replace("_OBJC_CLASS_$_", "")
        if kind == "ptr":
            # pointer to class struct: name ptr at +16 (after isa, superclass... ro at +32)
            ro = self.ptr_at2(val + 32)
            if ro[0] == "ptr":
                nm = self.ptr_at2(ro[1] + 24)
                if nm[0] == "ptr":
                    return self.sl.read_cstr(nm[1])
        return None

    def resolve_va(self, va):
        """Human description of a data address."""
        if va in self.cfstrings:
            s, _f, _l = self.cfstrings[va]
            return f'CFSTR("{s}")' if s is not None else "CFSTR(?)"
        sn = self.sec_name_of(va)
        if sn and "__objc_selrefs" in sn:
            nm = self.selref_name(va)
            return f"selref({nm})" if nm else sn
        if sn and "__objc_classrefs" in sn:
            nm = self.classref_name(va)
            return f"classref({nm})" if nm else sn
        if sn and "__cstring" in sn:
            s = self.sl.read_cstr(va)
            return f'"{s}"' if s is not None else sn
        if sn and "__ustring" in sn:
            return sn + " (utf16)"
        if va in self.sym_at:
            return self.sym_at[va]
        if sn and "__got" in sn:
            kind, val = self.ptr_at2(va)
            if kind == "bind":
                return f"got({val})"
            return sn
        if sn and "__const" in sn:
            raw = self.sl.read(va, 8)
            if raw and len(raw) == 8:
                dbl = struct.unpack("<d", raw)[0]
                u = struct.unpack("<Q", raw)[0]
                return f"{sn} [u64={u:#x} f64={dbl!r}]"
            return sn
        if sn and "__objc_intobj" in sn:
            # constant NSNumber layout: {isa, tag, int64 value}, 24-byte entries
            sec = self.section("__DATA_CONST", "__objc_intobj")
            if sec and (va - sec["addr"]) % 24 == 0:
                raw = self.sl.read(va + 16, 8)
                if raw and len(raw) == 8:
                    v = struct.unpack("<q", raw)[0]
                    return f"{sn} [NSNumber int={v}]"
            return sn
        if sn and ("__objc_arrayobj" in sn or "__objc_dictobj" in sn or "__objc_arraydata" in sn):
            return sn + " (const collection)"
        return sn if sn else f"{va:#x}"

    def func_name(self, va):
        if va in self.sym_at:
            return self.sym_at[va]
        if va in self.stub_names:
            return "stub:" + self.stub_names[va]
        if va in self.objc_stub_sel:
            return f"objc_stub[{self.objc_stub_sel[va]}]"
        if va in self.fstart_set:
            return f"sub_{va:x}"
        return None

    def func_size(self, va):
        starts = self.fstarts
        i = starts.index(va)
        end = starts[i + 1] if i + 1 < len(starts) else self.section("__TEXT", "__text")["addr"] + self.section("__TEXT", "__text")["size"]
        return end - va

    # ---------- disassembly ----------
    def disasm_func(self, va):
        size = self.func_size(va)
        code = self.sl.read(va, size)
        md = Cs(CS_ARCH_ARM64, CS_MODE_LITTLE_ENDIAN)
        md.detail = True
        lines = []
        pages = {}  # reg -> page base va (adrp tracking, linear approximation)
        name = self.func_name(va) or f"sub_{va:x}"
        lines.append(f"; === {name} @ {va:#x} size={size} ===")
        for insn in md.disasm(code, va):
            ops = insn.operands
            note = ""
            if insn.id == ARM64_INS_ADRP and len(ops) == 2 and ops[1].type == ARM64_OP_IMM:
                pages[insn.reg_name(ops[0].reg)] = ops[1].imm
            elif insn.id == ARM64_INS_ADD and len(ops) == 3 and ops[2].type == ARM64_OP_IMM:
                rn = insn.reg_name(ops[1].reg)
                if rn in pages:
                    tgt = pages[rn] + ops[2].imm
                    note = f" ; -> {self.resolve_va(tgt)}"
                    pages[insn.reg_name(ops[0].reg)] = tgt  # now absolute
            elif insn.id == ARM64_INS_LDR and len(ops) == 2 and ops[1].type == ARM64_OP_MEM:
                rn = insn.reg_name(ops[1].mem.base)
                if rn in pages:
                    tgt = pages[rn] + ops[1].mem.disp
                    note = f" ; -> [{self.resolve_va(tgt)}]"
            if insn.id in (ARM64_INS_BL, ARM64_INS_B) and ops and ops[0].type == ARM64_OP_IMM:
                tgt = ops[0].imm
                nm = self.func_name(tgt)
                if nm:
                    note = f" ; call {nm}"
            lines.append(f"{insn.address:#010x}  {insn.mnemonic:<8} {insn.op_str}{note}")
        return "\n".join(lines) + "\n"

    def func_bytes(self, va):
        return self.sl.read(va, self.func_size(va))


def main():
    import argparse
    ap = argparse.ArgumentParser()
    ap.add_argument("path")
    ap.add_argument("--cpu", default="arm64")
    ap.add_argument("--dumpdir")
    ap.add_argument("--overview", action="store_true")
    ap.add_argument("--funcbytes")
    args = ap.parse_args()
    img = Image(args.path, args.cpu)
    if args.overview:
        out = {"defined": {}, "functions": []}
        for nm, va in sorted(img.def_syms.items(), key=lambda kv: kv[1]):
            is_func = va in img.fstart_set
            out["defined"][nm] = {
                "va": hex(va), "section": img.sec_name_of(va),
                "is_function_start": is_func,
                "size": img.func_size(va) if is_func else None,
            }
        out["n_function_starts"] = len(img.fstarts)
        out["local_functions"] = [hex(a) for a in img.fstarts if a not in img.sym_at]
        print(json.dumps(out, indent=1))
        return
    if args.funcbytes:
        va = img.def_syms[args.funcbytes]
        sys.stdout.write(img.func_bytes(va).hex())
        return
    if args.dumpdir:
        dd = Path(args.dumpdir)
        dd.mkdir(parents=True, exist_ok=True)
        idx = []
        for a in img.fstarts:
            nm = img.func_name(a) or f"sub_{a:x}"
            fn = dd / (nm.replace("/", "_") + ".asm")
            fn.write_text(img.disasm_func(a))
            idx.append(f"{a:#x} {img.func_size(a):6d} {nm}")
        (dd / "INDEX.txt").write_text("\n".join(idx) + "\n")
        print(f"dumped {len(idx)} functions to {dd}")
        return


if __name__ == "__main__":
    main()
