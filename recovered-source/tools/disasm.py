#!/usr/bin/env python3
"""disasm.py - annotated ARM64 disassembly for OmniCar reconstruction.

Builds on metadata/tools/macho_objc.py (Slice, chained-fixup decoding).
Usage: disasm.py <ModuleName> <outdir>
Reads payload dylib for the module, writes one .txt per function into outdir
plus _index.json (function starts, names, sizes, call edges).
"""
import json
import os
import re
import struct
import sys

sys.path.insert(0, os.path.join(os.path.dirname(__file__), "..", "metadata", "tools"))
from macho_scan import split_fat, parse_slice  # noqa: E402
from macho_objc import Slice  # noqa: E402
from capstone import Cs, CS_ARCH_ARM64, CS_MODE_LITTLE_ENDIAN  # noqa: E402

ROOT = os.path.join(os.path.dirname(__file__), "..")


def load_slice(module):
    path = os.path.join(
        ROOT, "payload/var/jb/Library/MobileSubstrate/DynamicLibraries",
        f"{module}.dylib")
    data = open(path, "rb").read()
    for cpu, off, size in split_fat(data):
        if cpu == "arm64":
            scan = parse_slice(data, off)
            sl = Slice(data[off:off + size], scan)
            # FIX: macho_objc._import_name maps ordinal -> imports[ordinal-1],
            # which is off by one for these lld-built fmt-6 images. Proof: all
            # 498 (StartupScreen) + 109 (CarProbe) __objc_stubs tails decode to
            # _objc_msgSend only under imports[ordinal]; classref[0] of CarProbe
            # becomes NSProcessInfo, matching [NSProcessInfo processInfo] usage.
            def _import_name_fixed(ordinal, _sl=sl):
                if 0 <= ordinal < len(_sl.imports):
                    return _sl.imports[ordinal]
                return f"<ordinal {ordinal}>"
            sl._import_name = _import_name_fixed
            return sl, scan
    raise RuntimeError("no arm64 slice")


class Annotator:
    def __init__(self, sl):
        self.sl = sl
        self.stub_names = {}       # stub VA -> import name
        self.objc_stubs = {}       # stub VA -> (selector, tail-target name)
        self.cfstrings = {}        # VA -> str
        self.selrefs = {}          # VA -> selector str
        self.classrefs = {}        # VA -> class name
        self.got_names = {}        # GOT VA -> name/ptr desc
        self.cstrings = {}         # VA -> str (cstring/methname sections)
        self.func_names = {}       # VA -> display name
        self._build_maps()

    # ---------------- symbol / section maps ----------------
    def _build_maps(self):
        sl = self.sl
        # __stubs -> GOT slot -> bind name
        s, b = sl.section_bytes("__TEXT", "__stubs")
        if b:
            base = s["addr"]
            for i in range(len(b) // 12):
                va = base + i * 12
                insns = list(self._md().disasm(b[i * 12:i * 12 + 12], va))
                got = None
                for ins in insns:
                    if ins.mnemonic == "ldr" and "," in ins.op_str:
                        m = re.search(r"#(0x[0-9a-f]+|\d+)\]", ins.op_str)
                        # target computed from preceding adrp in same stub
                        pass
                got = self._stub_got_target(b[i * 12:i * 12 + 12], va)
                if got is not None:
                    k, v = sl.ptr_at(got)
                    self.stub_names[va] = v if k == "bind" else f"got@{got:#x}"
                    self.got_names[got] = self.stub_names[va]
        # __objc_stubs -> selector + tail name
        s, b = sl.section_bytes("__TEXT", "__objc_stubs")
        if b:
            base = s["addr"]
            entry = 32
            for i in range(len(b) // entry):
                va = base + i * entry
                chunk = b[i * entry:(i + 1) * entry]
                sel = None
                tail = None
                regs = {}
                for ins in self._md().disasm(chunk, va):
                    if ins.mnemonic == "adrp":
                        parts = ins.op_str.split(", ")
                        regs[parts[0]] = int(parts[1].lstrip("#"), 16)
                    elif ins.mnemonic == "ldr":
                        m = re.match(r"(x\d+), \[(x\d+), #(0x[0-9a-f]+|\d+)\]", ins.op_str)
                        if m and m.group(2) in regs:
                            tgt = regs[m.group(2)] + int(m.group(3), 16)
                            if ins.op_str.startswith("x1,"):
                                k, v = sl.ptr_at(tgt)
                                if k == "ptr":
                                    sel = sl.read_cstr(v)
                            else:
                                k, v = sl.ptr_at(tgt)
                                if k == "bind":
                                    tail = v
                self.objc_stubs[va] = (sel, tail or "_objc_msgSend")
        # cfstrings
        for seg in ("__DATA_CONST", "__DATA"):
            s, b = sl.section_bytes(seg, "__cfstring")
            if b:
                for i in range(len(b) // 32):
                    va = s["addr"] + i * 32
                    raw = sl.read(va + 16, 8)
                    if not raw:
                        continue
                    k, v = sl.decode_ptr(struct.unpack("<Q", raw)[0], va + 16)
                    if k == "ptr":
                        ln = sl.read_u64(va + 24)
                        bs = sl.read(v, ln if ln and ln < 4096 else 0) or b""
                        try:
                            self.cfstrings[va] = bs.decode("utf-8")
                        except UnicodeDecodeError:
                            self.cfstrings[va] = repr(bs)
        # selrefs / classrefs
        for seg in ("__DATA", "__DATA_CONST"):
            s, b = sl.section_bytes(seg, "__objc_selrefs")
            if b:
                for i in range(len(b) // 8):
                    va = s["addr"] + i * 8
                    k, v = sl.ptr_at(va)
                    if k == "ptr":
                        sel = sl.read_cstr(v)
                        if sel:
                            self.selrefs[va] = sel
            s, b = sl.section_bytes(seg, "__objc_classrefs")
            if b:
                for i in range(len(b) // 8):
                    va = s["addr"] + i * 8
                    k, v = sl.ptr_at(va)
                    if k == "bind":
                        self.classrefs[va] = str(v).replace("_OBJC_CLASS_$_", "")
                    elif k == "ptr" and v:
                        nm = sl.class_name_at(v)
                        if nm:
                            self.classrefs[va] = nm
            s, b = sl.section_bytes(seg, "__objc_superrefs")
            if b:
                for i in range(len(b) // 8):
                    va = s["addr"] + i * 8
                    k, v = sl.ptr_at(va)
                    if k == "bind":
                        self.classrefs[va] = "super:" + str(v).replace(
                            "_OBJC_METACLASS_$_", "").replace("_OBJC_CLASS_$_", "")
        # cstrings
        for sec in ("__cstring", "__objc_methname", "__objc_classname"):
            s, b = sl.section_bytes("__TEXT", sec)
            if b:
                start = None
                for i, byte in enumerate(b):
                    if byte == 0:
                        if start is not None:
                            try:
                                self.cstrings[s["addr"] + start] = \
                                    b[start:i].decode("utf-8")
                            except UnicodeDecodeError:
                                pass
                            start = None
                    elif start is None:
                        start = i
        # block literals in __DATA_CONST,__const (isa == __NSConcreteGlobalBlock)
        self.block_lits = {}
        s, b = sl.section_bytes("__DATA_CONST", "__const")
        if b:
            for i in range(0, len(b) - 31, 8):
                va = s["addr"] + i
                k, v = sl.ptr_at(va)
                if k == "bind" and v == "__NSConcreteGlobalBlock":
                    k2, inv = sl.ptr_at(va + 16)
                    k3, desc = sl.ptr_at(va + 24)
                    sig = None
                    if k3 == "ptr" and desc:
                        flags = sl.read_u64(va + 8) or 0
                        sig_off = 32 if (flags & 0x02000000) else 16
                        k4, sigva = sl.ptr_at(desc + sig_off)
                        if k4 == "ptr":
                            sig = sl.read_cstr(sigva)
                    if k2 == "ptr":
                        self.block_lits[va] = (inv, sig)
        # got entries
        s, b = sl.section_bytes("__DATA_CONST", "__got")
        if b:
            for i in range(len(b) // 8):
                va = s["addr"] + i * 8
                k, v = sl.ptr_at(va)
                if k == "bind":
                    self.got_names[va] = v
                elif k == "ptr":
                    self.got_names[va] = f"->{v:#x}"

    _md_inst = None

    def _md(self):
        if Annotator._md_inst is None:
            md = Cs(CS_ARCH_ARM64, CS_MODE_LITTLE_ENDIAN)
            md.detail = True
            Annotator._md_inst = md
        return Annotator._md_inst

    def _stub_got_target(self, chunk, va):
        regs = {}
        for ins in self._md().disasm(chunk, va):
            if ins.mnemonic == "adrp":
                parts = ins.op_str.split(", ")
                if len(parts) == 2:
                    try:
                        regs[parts[0]] = int(parts[1].lstrip("#"), 16)
                    except ValueError:
                        pass
            elif ins.mnemonic == "ldr":
                m = re.match(r"(x\d+), \[(x\d+), #(0x[0-9a-f]+|\d+)\]", ins.op_str)
                if m and m.group(2) in regs:
                    return regs[m.group(2)] + int(m.group(3), 16)
        return None

    def describe_addr(self, va):
        if va in self.block_lits:
            inv, sig = self.block_lits[va]
            return f"block_lit(invoke={inv:#x} {self.func_names.get(inv, '')}, sig={sig})"
        if va in self.cfstrings:
            return f'@"{self.cfstrings[va]}"'
        if va in self.selrefs:
            return f"selref({self.selrefs[va]})"
        if va in self.classrefs:
            return f"class({self.classrefs[va]})"
        if va in self.got_names:
            return f"got({self.got_names[va]})"
        if va in self.cstrings:
            return f'"{self.cstrings[va]}"'
        if va in self.func_names:
            return f"func {self.func_names[va]}"
        return None


def unwind_function_starts(sl, ground_truth):
    """Function starts from __unwind_info, decoded empirically.

    These lld-built images do not match the textbook header layout offsets,
    so the index location and page-entry decoding are chosen by scoring
    candidate decodings against ground-truth starts (IMPs/exports): the
    winner must cover all ground truth, stay inside __text, and be strictly
    ascending per page.  (Validated decode on OmniCarCarProbe: index entries
    of 12B {functionOffset, secondLevelPagesSectionOffset,
    lsdaIndexSectionOffset}; compressed page {u32 kind=3, u16
    encodingsPageOffset, u16 functionCount} with entries beginning at
    page+encodingsPageOffset and VA = index.functionOffset + entry&0xFFFFFF.)
    """
    s, b = sl.section_bytes("__TEXT", "__unwind_info")
    ts, _tb = sl.section_bytes("__TEXT", "__text")
    if not b or not ts:
        return set()
    text_lo, text_hi = ts["addr"], ts["addr"] + ts["size"]
    hdr = struct.unpack_from("<7I", b, 0)
    cand_index_offs = {hdr[1], hdr[3], hdr[5]} | set(range(0x1C, 0x90, 4))

    def decode_page(sl_off, base):
        kind = struct.unpack_from("<I", b, sl_off)[0]
        if kind == 3:
            enc_off, count = struct.unpack_from("<HH", b, sl_off + 4)
            outs = []
            for estart in {sl_off + 8, sl_off + enc_off, sl_off + 12}:
                vals, ok = [], True
                for j in range(count):
                    eo = estart + j * 4
                    if eo + 4 > len(b):
                        ok = False
                        break
                    vals.append(base + (struct.unpack_from("<I", b, eo)[0] & 0xFFFFFF))
                if ok and vals and all(text_lo <= v < text_hi for v in vals) \
                        and all(vals[i] < vals[i + 1] for i in range(len(vals) - 1)):
                    outs.append(vals)
            return outs
        if kind == 2:
            vals, j = [], sl_off + 4
            while j + 8 <= len(b):
                fo = struct.unpack_from("<I", b, j)[0]
                if fo == 0 or (vals and fo <= vals[-1]):
                    break
                vals.append(fo)
                j += 8
            return [vals] if vals else []
        return []

    best, best_score = set(), -1
    for ioff in sorted(cand_index_offs):
        starts, prev_fo, ok = set(), -1, True
        for i in range(64):
            eoff = ioff + i * 12
            if eoff + 12 > len(b):
                break
            fo, sl_off, _lsda = struct.unpack_from("<3I", b, eoff)
            if fo == 0 or fo < prev_fo or fo > text_hi:
                if i == 0:
                    ok = False
                break
            prev_fo = fo
            if sl_off and sl_off + 8 <= len(b):
                for vals in decode_page(sl_off, fo):
                    starts.update(vals)
            if fo >= text_hi:
                break
        if not ok or not starts:
            continue
        score = len(ground_truth & starts) * 1000 - len(starts - ground_truth)
        if ground_truth <= starts:
            score += 100000
        if score > best_score:
            best, best_score = starts, score
    return best


def collect_functions(sl, ann, objc):
    """Return sorted list of (va, name) function starts inside __TEXT,__text."""
    s, _b = sl.section_bytes("__TEXT", "__text")
    text_lo, text_hi = s["addr"], s["addr"] + s["size"]
    starts = {}

    def add(va, name):
        if text_lo <= va < text_hi:
            if va not in starts or starts[va].startswith("sub_"):
                starts[va] = name

    # defined symbols in __text
    for sym in sl.symbols:
        if sym["kind"] == "defined_sect" and sym["value"]:
            add(sym["value"], sym["name"].lstrip("_"))
    # method IMPs
    for cls in objc.get("classes", []):
        for kind, mlist in (("-", cls.get("methods") or []),
                            ("+", cls.get("class_methods") or [])):
            for m in mlist:
                if m.get("imp"):
                    add(m["imp"], f"{kind}[{cls['name']} {m['name']}]")
    for cat in objc.get("categories", []):
        for kind, mlist in (("-", cat.get("instance_methods") or []),
                            ("+", cat.get("class_methods") or [])):
            for m in mlist:
                if m.get("imp"):
                    add(m["imp"], f"{kind}[{cat.get('target')}({cat.get('name')}) {m['name']}]")
    # __init_offsets (u32 offsets from image base 0)
    s2, b2 = sl.section_bytes("__TEXT", "__init_offsets")
    if b2:
        for i in range(len(b2) // 4):
            va = struct.unpack_from("<I", b2, i * 4)[0]
            add(va, f"__init_{i}")
    # pointers into __text stored in data sections (block invokes, fn ptrs)
    for (seg, sec), ssec in sl.sections.items():
        if seg == "__TEXT":
            continue
        b = sl.data[ssec["offset"]:ssec["offset"] + ssec["size"]]
        for i in range(0, len(b) - 7, 4):
            k, v = sl.decode_ptr(struct.unpack_from("<Q", b, i)[0],
                                 ssec["addr"] + i)
            if k == "ptr" and isinstance(v, int):
                add(v, f"sub_{v:x}")
    # __unwind_info function starts, scored against the ground truth above
    for va in unwind_function_starts(sl, set(starts)):
        starts.setdefault(va, f"sub_{va:x}")
    # direct BL targets inside __text are function entries by definition
    _s, tb = sl.section_bytes("__TEXT", "__text")
    for off in range(0, len(tb) - 3, 4):
        w = struct.unpack_from("<I", tb, off)[0]
        if w & 0xFC000000 == 0x94000000:
            imm = w & 0x3FFFFFF
            if imm & 0x2000000:
                imm -= 0x4000000
            tgt = text_lo + off + imm * 4
            if text_lo <= tgt < text_hi:
                starts.setdefault(tgt, f"sub_{tgt:x}")
    return sorted(starts.items()), (text_lo, text_hi)


def disasm_function(sl, ann, start, end, name):
    code = sl.read(start, end - start)
    if not code:
        return [], []
    md = ann._md()
    lines = []
    calls = []
    regs = {}
    for ins in md.disasm(code, start):
        anns = []
        op = ins.op_str
        if ins.mnemonic == "adrp":
            parts = op.split(", ")
            if len(parts) == 2:
                try:
                    regs[parts[0]] = int(parts[1].lstrip("#"), 16)
                except ValueError:
                    pass
        elif ins.mnemonic in ("ldr", "ldrb", "ldrh", "ldrsw", "add", "str",
                              "strb", "strh", "ldr", "ldur"):
            m = re.search(r"\[(x\d+), #(0x[0-9a-f]+|\d+)\]", op)
            m2 = re.match(r"(x\d+), (x\d+), #(0x[0-9a-f]+|\d+)$", op)
            tgt = None
            if m and m.group(1) in regs:
                tgt = regs[m.group(1)] + int(m.group(2), 16)
            elif m2 and m2.group(2) in regs:
                tgt = regs[m2.group(2)] + int(m2.group(3), 16)
                # add with pageoff: destination reg now holds address
                if ins.mnemonic == "add":
                    regs[m2.group(1)] = tgt
            if tgt is not None:
                d = ann.describe_addr(tgt)
                if d:
                    anns.append(d)
                elif tgt in ann.stub_names:
                    anns.append(f"stub {ann.stub_names[tgt]}")
        if ins.mnemonic in ("bl", "b") and op.startswith("#"):
            try:
                tgt = int(op[1:].lstrip("#"), 16)
            except ValueError:
                tgt = None
            if tgt is not None:
                if tgt in ann.stub_names:
                    anns.append(f"-> {ann.stub_names[tgt]}")
                    calls.append(ann.stub_names[tgt])
                elif tgt in ann.objc_stubs:
                    sel, tail = ann.objc_stubs[tgt]
                    anns.append(f"-> {tail}({sel})" if sel else f"-> {tail}(?)")
                    calls.append(f"{tail}({sel})")
                elif tgt in ann.func_names:
                    anns.append(f"-> {ann.func_names[tgt]}")
                    calls.append(ann.func_names[tgt])
                elif tgt != ins.address + 4:
                    anns.append(f"-> sub_{tgt:x}")
                    calls.append(f"sub_{tgt:x}")
        if ins.mnemonic in ("b", "ret", "br", "blr", "bl"):
            if ins.mnemonic in ("bl", "blr", "ret", "br"):
                regs = {}
        lines.append(f"{ins.address:#010x}:  {ins.mnemonic:8s} {op}"
                     + (f"    ; {'; '.join(anns)}" if anns else ""))
    return lines, calls


def main():
    module, outdir = sys.argv[1], sys.argv[2]
    os.makedirs(outdir, exist_ok=True)
    sl, _scan = load_slice(module)
    ann = Annotator(sl)
    objc = sl.parse_objc()
    starts, (lo, hi) = collect_functions(sl, ann, objc)
    ann.func_names = dict(starts)
    index = []
    used_names = {}
    for idx, (va, name) in enumerate(starts):
        end = starts[idx + 1][0] if idx + 1 < len(starts) else hi
        lines, calls = disasm_function(sl, ann, va, end, name)
        safe = re.sub(r"[^A-Za-z0-9_.-]+", "_", name).strip("_")[:120]
        fname = f"{va:06x}_{safe}.txt"
        if fname in used_names:
            fname = f"{va:06x}_{safe}_{used_names[fname]}.txt"
        used_names[fname] = used_names.get(fname, 0) + 1
        with open(os.path.join(outdir, fname), "w") as f:
            f.write(f"; {name}\n; VA {va:#x}  size {end - va}\n\n")
            f.write("\n".join(lines) + "\n")
        index.append({"va": va, "name": name, "size": end - va,
                      "file": fname, "calls": sorted(set(calls))})
    with open(os.path.join(outdir, "_index.json"), "w") as f:
        json.dump(index, f, indent=1)
    print(f"{module}: {len(starts)} functions, "
          f"{len(ann.objc_stubs)} objc stubs, {len(ann.stub_names)} stubs, "
          f"{len(ann.cfstrings)} cfstrings")


if __name__ == "__main__":
    main()
