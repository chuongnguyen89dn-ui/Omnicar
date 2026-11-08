#!/usr/bin/env python3
"""xref.py - wave-2 cross-reference engine for the OmniCar 1.0.3 reconstruction.

Builds on the wave-1 parsers (macho_scan / macho_objc) and capstone 5.0.7.
For one Mach-O (arm64 slice) it produces:

  - function inventory: LC_FUNCTION_STARTS + ObjC method IMPs + defined
    symbols + LC_MAIN entry, each named where a name is known;
  - stub maps: __stubs entry -> imported symbol; __objc_stubs entry ->
    (selector, tail-call target import);
  - data maps: __objc_selrefs slot -> selector, __objc_classrefs /
    __objc_superrefs slot -> class name, __DATA_CONST __cfstring entry ->
    string value, __got/__la_symbol_ptr slot -> imported symbol;
  - a linear abstract-interpretation pass over __text that records every
    call site (bl / blr) with the caller's containing function and the
    traced values of x0..x3 at the call.

Value model (JSON-serialisable dicts):
  {"t":"cfstr","v":s}   address/value is the CFString constant s
  {"t":"cstr","v":s}    pointer to C string s
  {"t":"sel","v":s}     a SEL for selector s (loaded from a selref slot,
                        or the selector-pointer value itself)
  {"t":"class","v":s}   a Class object for class s
  {"t":"addr","v":va}   a concrete virtual address (see "what" when the
                        address is further identified: func/cfstring/...)
  {"t":"imm","v":n}     a small immediate integer
  {"t":"importptr","v":name}  pointer to imported function `name`
                        (GOT/la slot content, or a stub address value)
  {"t":"loadfrom","v":va}    value loaded from data address va (content
                        not statically known - e.g. a notify token slot)
  {"t":"callret","v":desc}   return value of the described call
  {"t":"unknown"}

Precision rule: anything the tracer cannot prove is recorded as the raw
trace ("unknown" / "loadfrom" / unresolved call target), never guessed.
"""
import json
import struct
import sys

sys.path.insert(0, __file__.rsplit("/", 1)[0])
from macho_scan import split_fat, parse_slice  # noqa: E402
from macho_objc import Slice  # noqa: E402

from capstone import Cs, CS_ARCH_ARM64, CS_MODE_LITTLE_ENDIAN  # noqa: E402
from capstone.arm64 import (  # noqa: E402
    ARM64_OP_REG, ARM64_OP_IMM, ARM64_OP_MEM,
    ARM64_REG_X0, ARM64_REG_X30, ARM64_REG_SP,
)

REG_ALIASES = {}
for _i in range(31):
    REG_ALIASES[f"x{_i}"] = f"x{_i}"
    REG_ALIASES[f"w{_i}"] = f"x{_i}"
REG_ALIASES["sp"] = "sp"
REG_ALIASES["lr"] = "x30"
REG_ALIASES["fp"] = "x29"
REG_ALIASES["xzr"] = "xzr"
REG_ALIASES["wzr"] = "xzr"


def reg_name(r):
    return REG_ALIASES.get(r, r)


class Bin:
    def __init__(self, path, name):
        self.path = path
        self.name = name
        data = open(path, "rb").read()
        self.scan = None
        for cpu, off, size in split_fat(data):
            if cpu == "arm64":
                self.scan = parse_slice(data, off)
                self.sl = Slice(data[off:off + size], self.scan)
                self.slice_bytes = data[off:off + size]
                break
        if self.scan is None:
            raise RuntimeError(f"{path}: no arm64 slice")
        self.base = self.sl.base or 0
        self.sections = {}
        for s in self.scan["sections"]:
            self.sections[(s["seg"], s["name"])] = s
        self._parse_section_headers()
        self._parse_dysymtab()
        self.calibration = self._calibrate_ordinals()
        self._build_data_maps()
        self._build_stubs()
        self._build_functions()
        self._build_objc_names()

    # ---------------- section headers / dysymtab ----------------
    def _parse_section_headers(self):
        """Full section_64 headers (flags / reserved1 / reserved2), which
        macho_scan does not retain."""
        self.sec_full = {}
        d = self.slice_bytes
        for cmd, raw in self._iter_load_commands_full():
            if cmd != 0x19:  # LC_SEGMENT_64
                continue
            nsects = struct.unpack_from("<I", raw, 64)[0]
            for i in range(nsects):
                so = 72 + i * 80
                name = raw[so:so + 16].split(b"\x00")[0].decode()
                seg = raw[so + 16:so + 32].split(b"\x00")[0].decode()
                addr, size = struct.unpack_from("<QQ", raw, so + 32)
                flags, r1, r2 = struct.unpack_from("<III", raw, so + 64)
                self.sec_full[(seg, name)] = {
                    "addr": addr, "size": size, "flags": flags,
                    "reserved1": r1, "reserved2": r2}

    def _iter_load_commands_full(self):
        d = self.slice_bytes
        ncmds = struct.unpack_from("<I", d, 16)[0]
        off = 32
        for _ in range(ncmds):
            cmd, cmdsize = struct.unpack_from("<II", d, off)
            yield cmd & ~0x80000000, d[off:off + cmdsize]
            off += cmdsize

    def _parse_dysymtab(self):
        """indirect symbol table -> {address: symbol name} for __stubs,
        __la_symbol_ptr, __got, __nl_symbol_ptr sections."""
        self.indirect_names = {}
        ind = None
        for cmd, raw in self._iter_load_commands_full():
            if cmd == 0xB:  # LC_DYSYMTAB
                indirectsymoff, nindirectsyms = struct.unpack_from("<II", raw, 56)
                ind = [struct.unpack_from("<I", self.slice_bytes,
                                           indirectsymoff + 4 * i)[0]
                       for i in range(nindirectsyms)]
                break
        if ind is None:
            return
        syms = self.sl.symbols
        for (seg, name), s in self.sec_full.items():
            if name not in ("__stubs", "__la_symbol_ptr", "__got",
                            "__nl_symbol_ptr"):
                continue
            r1 = s["reserved1"]
            if name == "__stubs":
                esz = s["reserved2"] or 12
            else:
                esz = 8
            if esz == 0:
                continue
            n = s["size"] // esz
            for i in range(n):
                if r1 + i >= len(ind):
                    break
                si = ind[r1 + i]
                if si < len(syms) and syms[si]["name"]:
                    self.indirect_names[s["addr"] + i * esz] = syms[si]["name"]

    def _calibrate_ordinals(self):
        """Compare chained-fixup bind decodes against DYSYMTAB truth on
        every covered slot; if they disagree by a constant import-index
        delta, patch Slice._import_name so ALL bind decodes in this
        binary shift by that delta. Returns a calibration report dict."""
        sl = self.sl
        imports = sl.imports

        def idx_of(name):
            if name is None:
                return None
            if isinstance(name, str) and name.startswith("<ordinal "):
                try:
                    return int(name.split()[1].rstrip(">")) - 1
                except Exception:
                    return None
            try:
                return imports.index(name)
            except ValueError:
                return None

        # provisional got decode (uncalibrated)
        prov = {}
        for seg, name in (("__DATA_CONST", "__got"), ("__DATA", "__got"),
                          ("__DATA", "__la_symbol_ptr"),
                          ("__DATA", "__nl_symbol_ptr"),
                          ("__DATA_CONST", "__la_symbol_ptr")):
            s, b = self._sec_bytes(seg, name)
            if not b:
                continue
            for i in range(len(b) // 8):
                va = s["addr"] + i * 8
                k, v = sl.ptr_at(va)
                if k == "bind":
                    prov[va] = v
        votes = {}
        checked = 0
        for va, truth in self.indirect_names.items():
            dec = prov.get(va)
            if dec is None:
                continue
            ti, di = idx_of(truth), idx_of(dec)
            if ti is None or di is None:
                continue
            checked += 1
            votes[ti - di] = votes.get(ti - di, 0) + 1
        delta = 0
        if votes:
            delta = max(votes.items(), key=lambda kv: kv[1])[0]
        report = {"delta": delta, "votes": votes, "checked": checked,
                  "indirect_entries": len(self.indirect_names)}
        if delta != 0:
            orig = sl._import_name

            def corrected(ordinal, _orig=orig, _delta=delta, _sl=sl):
                j = ordinal - 1 + _delta
                if 0 <= j < len(_sl.imports):
                    return _sl.imports[j]
                return _orig(ordinal)

            sl._import_name = corrected
        return report

    # ---------------- raw load-command extras ----------------
    def _iter_load_commands(self):
        d = self.slice_bytes
        ncmds = struct.unpack_from("<I", d, 16)[0]
        off = 32
        for _ in range(ncmds):
            cmd, cmdsize = struct.unpack_from("<II", d, off)
            yield cmd & ~0x80000000, d[off:off + cmdsize]
            off += cmdsize

    def _function_starts(self):
        starts = []
        for cmd, raw in self._iter_load_commands():
            if cmd == 0x26:  # LC_FUNCTION_STARTS
                dataoff, datasize = struct.unpack_from("<II", raw, 8)
                blob = self.slice_bytes[dataoff:dataoff + datasize]
                addr = self.base
                i = 0
                while i < len(blob):
                    shift = 0
                    delta = 0
                    while True:
                        byte = blob[i]
                        i += 1
                        delta |= (byte & 0x7F) << shift
                        shift += 7
                        if not (byte & 0x80):
                            break
                    if delta == 0:
                        break
                    addr += delta
                    starts.append(addr)
                break
        return starts

    def _main_entry(self):
        for cmd, raw in self._iter_load_commands():
            if cmd == 0x28:  # LC_MAIN
                entryoff = struct.unpack_from("<Q", raw, 8)[0]
                return self.base + entryoff
        return None

    # ---------------- data maps ----------------
    def _sec(self, seg, name):
        return self.sections.get((seg, name))

    def _sec_bytes(self, seg, name):
        s = self._sec(seg, name)
        if not s:
            return None, None
        return s, self.slice_bytes[s["offset"]:s["offset"] + s["size"]]

    def _build_data_maps(self):
        sl = self.sl
        # GOT-style slots -> imported symbol name
        self.got = {}
        for seg, name in (("__DATA_CONST", "__got"), ("__DATA", "__got"),
                          ("__DATA", "__la_symbol_ptr"),
                          ("__DATA", "__nl_symbol_ptr"),
                          ("__DATA_CONST", "__la_symbol_ptr")):
            s, b = self._sec_bytes(seg, name)
            if not b:
                continue
            for i in range(len(b) // 8):
                va = s["addr"] + i * 8
                k, v = sl.ptr_at(va)
                if k == "bind":
                    self.got[va] = v
        # selrefs -> selector string
        self.selrefs = {}
        for seg in ("__DATA", "__DATA_CONST"):
            s, b = self._sec_bytes(seg, "__objc_selrefs")
            if not b:
                continue
            for i in range(len(b) // 8):
                va = s["addr"] + i * 8
                k, v = sl.ptr_at(va)
                if k == "ptr" and v:
                    sel = sl.read_cstr(v)
                    if sel:
                        self.selrefs[va] = sel
                elif k == "bind" and isinstance(v, str):
                    self.selrefs[va] = v
            break
        # classrefs / superrefs -> class name
        self.classrefs = {}
        for secname in ("__objc_classrefs", "__objc_superrefs"):
            for seg in ("__DATA", "__DATA_CONST"):
                s, b = self._sec_bytes(seg, secname)
                if not b:
                    continue
                for i in range(len(b) // 8):
                    va = s["addr"] + i * 8
                    k, v = sl.ptr_at(va)
                    if k == "bind" and isinstance(v, str):
                        self.classrefs[va] = v.replace("_OBJC_CLASS_$_", "")
                    elif k == "ptr" and v:
                        nm = sl.class_name_at(v)
                        if nm:
                            self.classrefs[va] = nm
                break
        # cfstring constants -> value. Entry layout {isa, flags, cstr
        # ptr, length}; flags 0x7d0 (bit 0x10 set, 0x8 clear) marks
        # UTF-16LE storage with the length in UTF-16 code units, flags
        # 0x7c8 marks plain ASCII/UTF-8 bytes.
        self.cfstrings = {}
        for segname in ("__DATA_CONST", "__DATA"):
            s, b = self._sec_bytes(segname, "__cfstring")
            if not b:
                continue
            for i in range(len(b) // 32):
                va = s["addr"] + i * 32
                flags = struct.unpack_from("<Q", b, i * 32 + 8)[0]
                k, v = sl.ptr_at(va + 16)
                if k != "ptr" or not v:
                    continue
                if (flags & 0x18) == 0x10:
                    ln = struct.unpack_from("<Q", b, i * 32 + 24)[0]
                    raw = sl.read(v, ln * 2) or b""
                    try:
                        self.cfstrings[va] = raw.decode("utf-16-le")
                    except UnicodeDecodeError:
                        pass
                else:
                    txt = sl.read_cstr(v)
                    if txt is not None:
                        self.cfstrings[va] = txt
        # cstring + methname ranges for address description
        self._ranges = []
        for (seg, name), s in self.sections.items():
            self._ranges.append((s["addr"], s["addr"] + s["size"], seg, name))
        # DYSYMTAB ground truth overrides chained-fixup decodes.
        for va, nm in self.indirect_names.items():
            sec = self.section_of(va)
            if sec and sec[1] in ("__got", "__la_symbol_ptr", "__nl_symbol_ptr"):
                self.got[va] = nm

    def section_of(self, va):
        for lo, hi, seg, name in self._ranges:
            if lo <= va < hi:
                return seg, name
        return None

    def describe_addr(self, va):
        """Best static identification of a concrete address."""
        if va in self.cfstrings:
            return {"t": "cfstr", "v": self.cfstrings[va]}
        sec = self.section_of(va)
        if sec and sec[1] in ("__objc_intobj", "__objc_doubleobj",
                              "__objc_floatobj"):
            raw = self.sl.read(va, 24)
            if raw and len(raw) >= 24:
                if sec[1] == "__objc_intobj":
                    return {"t": "intobj",
                            "v": struct.unpack_from("<q", raw, 16)[0]}
                if sec[1] == "__objc_doubleobj":
                    return {"t": "doubleobj",
                            "v": struct.unpack_from("<d", raw, 16)[0]}
                return {"t": "doubleobj",
                        "v": struct.unpack_from("<f", raw, 16)[0]}
        if sec and sec[1] in ("__cstring", "__objc_methname", "__objc_classname"):
            txt = self.sl.read_cstr(va)
            if txt is not None:
                return {"t": "cstr", "v": txt}
        if sec and sec[1] == "__ustring":
            raw = self.sl.read(va, 256) or b""
            try:
                txt = raw.split(b"\x00\x00")[0].decode("utf-16-le", "replace")
                return {"t": "ustr", "v": txt}
            except Exception:
                pass
        return {"t": "addr", "v": va}

    # ---------------- stubs ----------------
    def _stub_target_slot(self, insns):
        """From a stub's instruction list, find the data slot it branches
        through (last ldr of x16 from an adrp-based address)."""
        state = {}
        slot = None
        for ins in insns:
            ops = ins.operands
            if ins.mnemonic == "adrp" and len(ops) == 2 and ops[1].type == ARM64_OP_IMM:
                state[reg_name(ins.reg_name(ops[0].reg))] = ops[1].imm
            elif ins.mnemonic == "ldr" and len(ops) == 2 and ops[1].type == ARM64_OP_MEM:
                base = reg_name(ins.reg_name(ops[1].mem.base))
                if base in state:
                    slot = state[base] + ops[1].mem.disp
        return slot

    def _build_stubs(self):
        md = Cs(CS_ARCH_ARM64, CS_MODE_LITTLE_ENDIAN)
        md.detail = True
        # __stubs: DYSYMTAB names are authoritative where present.
        self.stubs = {}
        s, b = self._sec_bytes("__TEXT", "__stubs")
        if b:
            for va, nm in self.indirect_names.items():
                if s["addr"] <= va < s["addr"] + s["size"]:
                    self.stubs[va] = nm
            if not self.stubs:
                seq = []
                seq_start = None
                for ins in md.disasm(b, s["addr"]):
                    if seq_start is None:
                        seq_start = ins.address
                    seq.append(ins)
                    if ins.mnemonic in ("br", "braa", "brab"):
                        slot = self._stub_target_slot(seq)
                        if slot is not None and slot in self.got:
                            self.stubs[seq_start] = self.got[slot]
                        seq = []
                        seq_start = None
        # __objc_stubs: group into br-terminated sequences; lld pads each
        # stub with brk #1 fillers, which must not start a new group.
        self.objc_stubs = {}  # stub addr -> {"sel":..., "target":...}
        s, b = self._sec_bytes("__TEXT", "__objc_stubs")
        if b:
            seq = []
            seq_start = None
            for ins in md.disasm(b, s["addr"]):
                if ins.mnemonic in ("brk", "nop") and seq_start is None:
                    continue
                if seq_start is None:
                    seq_start = ins.address
                seq.append(ins)
                if ins.mnemonic in ("br", "braa", "brab"):
                    sel = None
                    state = {}
                    for i2 in seq:
                        ops = i2.operands
                        if i2.mnemonic == "adrp" and len(ops) == 2 and ops[1].type == ARM64_OP_IMM:
                            state[reg_name(i2.reg_name(ops[0].reg))] = ops[1].imm
                        elif i2.mnemonic in ("ldr", "ldur") and len(ops) == 2 and ops[1].type == ARM64_OP_MEM:
                            base = reg_name(i2.reg_name(ops[1].mem.base))
                            if base in state:
                                addr = state[base] + ops[1].mem.disp
                                if addr in self.selrefs:
                                    sel = self.selrefs[addr]
                    slot = self._stub_target_slot(seq)
                    tgt = self.got.get(slot) if slot is not None else None
                    self.objc_stubs[seq_start] = {"sel": sel, "target": tgt}
                    seq = []
                    seq_start = None

    # ---------------- functions / names ----------------
    def _build_functions(self):
        starts = set(self._function_starts())
        entry = self._main_entry()
        if entry:
            starts.add(entry)
        self.defined_syms = {}
        for sym in self.sl.symbols:
            if sym["kind"] in ("defined_sect", "absolute") and sym["value"]:
                self.defined_syms[sym["name"]] = sym["value"]
                if sym["name"] and not sym["name"].startswith("_OBJC"):
                    starts.add(sym["value"])
        self.func_starts = sorted(s for s in starts if s)
        self.func_set = set(self.func_starts)
        self.func_names = {}
        for name, va in self.defined_syms.items():
            if va in self.func_set and name:
                self.func_names.setdefault(va, name)

    def _build_objc_names(self):
        self.method_names = {}  # imp addr -> "Class -[sel]" style label
        try:
            objc = self.sl.parse_objc()
        except Exception:
            objc = {"classes": [], "categories": []}
        self.objc = objc
        for cls in objc.get("classes", []):
            cname = cls.get("name") or "?"
            for kind in ("methods", "class_methods"):
                for m in cls.get(kind) or []:
                    imp = m.get("imp")
                    if imp:
                        sign = "+" if kind == "class_methods" else "-"
                        self.method_names[imp] = f"{cname} {sign}[{m.get('name')}]"
                        if imp in self.func_set:
                            self.func_names.setdefault(imp, self.method_names[imp])
        for cat in objc.get("categories", []):
            for kind in ("instance_methods", "class_methods"):
                for m in cat.get(kind) or []:
                    imp = m.get("imp")
                    if imp:
                        sign = "+" if kind == "class_methods" else "-"
                        label = f"{cat.get('target')}({cat.get('name')}) {sign}[{m.get('name')}]"
                        self.method_names[imp] = label
                        if imp in self.func_set:
                            self.func_names.setdefault(imp, label)

    def func_name(self, va):
        if va in self.func_names:
            return self.func_names[va]
        return f"sub_{va:x}"

    def func_containing(self, va):
        import bisect
        i = bisect.bisect_right(self.func_starts, va) - 1
        if i < 0:
            return None
        return self.func_starts[i]

    # ---------------- value resolution helpers ----------------
    def load_value(self, addr):
        """Value obtained by loading a pointer from static address `addr`."""
        if addr in self.classrefs:
            return {"t": "class", "v": self.classrefs[addr]}
        if addr in self.selrefs:
            return {"t": "sel", "v": self.selrefs[addr]}
        if addr in self.got:
            return {"t": "importptr", "v": self.got[addr]}
        k, v = self.sl.ptr_at(addr)
        if k == "bind":
            if isinstance(v, str) and v.startswith("_OBJC_CLASS_$_"):
                return {"t": "class", "v": v.replace("_OBJC_CLASS_$_", "")}
            if isinstance(v, str) and v.startswith("_OBJC_METACLASS_$_"):
                return {"t": "class", "v": v.replace("_OBJC_METACLASS_$_", "") + " (metaclass)"}
            return {"t": "importptr", "v": v}
        if k == "ptr" and v:
            if v in self.func_set:
                return {"t": "addr", "v": v, "what": "func:" + self.func_name(v)}
            if self.section_of(v):
                return self.describe_addr(v)
            # Content does not point inside this image (sentinel such as a
            # -1-initialised token slot, small stored integer, ...): the
            # honest description is "loaded from `addr`", value opaque.
            return {"t": "loadfrom", "v": addr}
        return {"t": "loadfrom", "v": addr}

    def addr_value(self, va):
        """Value of a register known to hold concrete address `va`."""
        if va in self.stubs:
            return {"t": "importptr", "v": self.stubs[va], "via": "stub"}
        if va in self.objc_stubs:
            return {"t": "addr", "v": va, "what": "objc_stub"}
        d = self.describe_addr(va)
        if d["t"] == "addr" and va in self.func_set:
            d = {"t": "addr", "v": va, "what": "func:" + self.func_name(va)}
        return d

    # ---------------- block literal ----------------
    def block_invoke(self, va):
        """If va addresses a block literal, return its invoke IMP address."""
        k, v = self.sl.ptr_at(va + 16)
        if k == "ptr" and v:
            return v
        return None
