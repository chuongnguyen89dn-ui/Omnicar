#!/usr/bin/env python3
"""disasm.py - annotated ARM64 disassembly for OmniCarPrefs (arm64 slice).

Built on metadata/tools/macho_objc.Slice (chained-fixups aware) + capstone.
Annotations resolved from the binary itself:
  - __objc_stubs entries  -> objc_msgSend$<selector> (stub decoded to its selref)
  - __stubs entries       -> imported C symbol (via __got bind)
  - adrp+add / adrp+ldr computed addresses:
      __objc_selrefs   -> SEL "name"
      __objc_classrefs -> CLASS Name / bind _OBJC_CLASS_$_Name
      __cfstring       -> STR "..." (utf8 or utf16)
      __cstring / __objc_methname / __ustring -> CSTR "..."
      __got            -> GOT import name
  - bl/b targets that are known function starts -> function name

Outputs (into src/Prefs/disasm/):
  <ClassName>.asm  per ObjC class (instance + class methods, IMP order)
  _CFunctions.asm  defined C symbols in __text
  _Blocks.asm      extra __text starts referenced by data pointers (block invokes etc.)
  index.json       per-function summary {name, va, size, selectors, strings, calls}
Usage: disasm.py [prefs-binary]
"""
import json
import struct
import sys
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parents[3] / "metadata" / "tools"))
from macho_scan import split_fat, parse_slice  # noqa: E402
from macho_objc import Slice  # noqa: E402
from capstone import Cs, CS_ARCH_ARM64, CS_MODE_LITTLE_ENDIAN  # noqa: E402

ROOT = Path(__file__).resolve().parents[3]
DEFAULT_BIN = ROOT / "payload/var/jb/Library/PreferenceBundles/OmniCarPrefs.bundle/OmniCarPrefs"
OUTDIR = ROOT / "src/Prefs/disasm"


def sec_range(sl, seg, name):
    s = sl.sections.get((seg, name))
    if not s:
        return None
    return s["addr"], s["addr"] + s["size"]


class Image:
    def __init__(self, path):
        data = open(path, "rb").read()
        self.slice = None
        for cpu, off, size in split_fat(data):
            if cpu == "arm64":
                scan = parse_slice(data, off)
                self.slice = Slice(data[off:off + size], scan)
                break
        assert self.slice is not None, "no arm64 slice"
        sl = self.slice
        # VERIFIED on this image (fmt 6, DYLD_CHAINED_PTR_64_OFFSET): bind
        # ordinal indexes sl.imports 0-based. macho_objc._import_name subtracts
        # 1, which mislabels every bind by one import (this also explains the
        # "surprising superclasses" in the metadata report). Use local decode.
        assert sl.default_fmt == 6, f"unexpected ptr format {sl.default_fmt}"
        self.text = sec_range(sl, "__TEXT", "__text")

        self.selrefs = {}      # va -> selector name
        r = sec_range(sl, "__DATA", "__objc_selrefs")
        if r:
            va = r[0]
            while va < r[1]:
                kind, val = self.decode(va)
                if kind == "ptr":
                    nm = sl.read_cstr(val)
                    if nm:
                        self.selrefs[va] = nm
                va += 8
        self.classrefs = {}    # va -> class name
        r = sec_range(sl, "__DATA", "__objc_classrefs")
        if r:
            va = r[0]
            while va < r[1]:
                kind, val = self.decode(va)
                if kind == "bind":
                    self.classrefs[va] = val.replace("_OBJC_CLASS_$_", "")
                elif kind == "ptr":
                    nm = sl.class_name_at(val)
                    if nm:
                        self.classrefs[va] = nm
                va += 8
        self.superrefs = {}
        r = sec_range(sl, "__DATA", "__objc_superrefs")
        if r:
            va = r[0]
            while va < r[1]:
                kind, val = self.decode(va)
                if kind == "bind":
                    self.superrefs[va] = val.replace("_OBJC_CLASS_$_", "")
                elif kind == "ptr":
                    nm = sl.class_name_at(val)
                    if nm:
                        self.superrefs[va] = nm
                va += 8
        self.cfstrings = {}    # va -> python str
        r = sec_range(sl, "__DATA_CONST", "__cfstring")
        if r:
            va = r[0]
            while va < r[1]:
                flags = sl.read_u64(va + 8)
                kind, dataptr = self.decode(va + 16)
                length = sl.read_u64(va + 24)
                s = None
                if kind == "ptr" and length is not None and length < 100000:
                    raw = sl.read(dataptr, length * 2 if (flags and flags & 0x7c8 == 0x7c8 and dataptr >= 0x70eb4 and dataptr < 0x71a58) else length)
                    # decide encoding by section of dataptr
                    if self._in(dataptr, "__TEXT", "__ustring"):
                        b = sl.read(dataptr, length * 2)
                        if b:
                            s = b.decode("utf-16-le", "replace")
                    else:
                        b = sl.read(dataptr, length)
                        if b:
                            s = b.decode("utf-8", "replace")
                if s is not None:
                    self.cfstrings[va] = s
                va += 32
        self.got = {}          # va -> import symbol name
        for seg, nm in (("__DATA_CONST", "__got"), ("__DATA", "__la_symbol_ptr"),
                        ("__DATA_CONST", "__auth_got")):
            r = sec_range(sl, seg, nm)
            if r:
                va = r[0]
                while va < r[1]:
                    kind, val = self.decode(va)
                    if kind == "bind":
                        self.got[va] = val
                    va += 8
        self.md = Cs(CS_ARCH_ARM64, CS_MODE_LITTLE_ENDIAN)
        self.md.detail = True
        self.stubs = {}        # va -> display name
        self._build_stubs()

    def decode(self, va):
        """Local chained-fixup decode (fmt 6): ('bind', name) | ('ptr', va) | ('null', 0)."""
        sl = self.slice
        raw = sl.read_u64(va)
        if raw is None or raw == 0:
            return ("null", 0)
        if (raw >> 63) & 1:
            ordinal = raw & 0xFFFF
            if ordinal < len(sl.imports):
                return ("bind", sl.imports[ordinal])
            return ("bind", f"<ordinal {ordinal}>")
        return ("ptr", sl.base + (raw & ((1 << 36) - 1)))

    def _in(self, va, seg, name):
        r = sec_range(self.slice, seg, name)
        return bool(r) and r[0] <= va < r[1]

    def _stub_target_va(self, va, size):
        """Disassemble a stub; return the memory VA it loads its pointer from."""
        code = self.slice.read(va, size)
        regs = {}
        for insn in self.md.disasm(code, va):
            if insn.mnemonic == "adrp":
                regs[insn.operands[0].reg] = insn.operands[1].imm
            elif insn.mnemonic in ("ldr", "add") and len(insn.operands) >= 2:
                op = insn.operands[1]
                if op.type == 3 and op.mem.base in regs:  # MEM operand
                    return regs[op.mem.base] + op.mem.disp
        return None

    def _build_stubs(self):
        sl = self.slice
        r = sec_range(sl, "__TEXT", "__stubs")
        if r:
            va = r[0]
            while va < r[1]:
                tgt = self._stub_target_va(va, 12)
                if tgt in self.got:
                    self.stubs[va] = self.got[tgt]
                va += 12
        r = sec_range(sl, "__TEXT", "__objc_stubs")
        if r:
            va = r[0]
            while va < r[1]:
                tgt = self._stub_target_va(va, 32)
                if tgt in self.selrefs:
                    self.stubs[va] = "objc_msgSend$" + self.selrefs[tgt]
                va += 32

    # ---------- annotation ----------
    def resolve_va(self, va):
        """Human annotation for a data VA, or None."""
        if va in self.selrefs:
            return f'SEL "{self.selrefs[va]}"'
        if va in self.classrefs:
            return f'CLASS {self.classrefs[va]}'
        if va in self.superrefs:
            return f'SUPER {self.superrefs[va]}'
        if va in self.cfstrings:
            s = self.cfstrings[va]
            return 'STR "' + s.replace("\\", "\\\\").replace('"', '\\"').replace("\n", "\\n")[:120] + '"'
        if va in self.got:
            return f"GOT {self.got[va]}"
        for seg, nm in (("__TEXT", "__cstring"), ("__TEXT", "__objc_methname"),
                        ("__TEXT", "__objc_classname")):
            if self._in(va, seg, nm):
                s = self.slice.read_cstr(va)
                if s:
                    return f'CSTR "{s[:120]}"'
        if self._in(va, "__TEXT", "__ustring"):
            b = self.slice.read(va, 200)
            if b:
                try:
                    return 'USTR "' + b.decode("utf-16-le").split("\x00")[0][:80] + '"'
                except Exception:
                    pass
        return None


def collect_functions(img):
    sl = img.slice
    objc = sl.parse_objc()
    funcs = {}   # va -> {name, kind, class}
    for cls in objc["classes"]:
        cname = cls["name"]
        for m in cls.get("methods") or []:
            funcs[m["imp"]] = {"name": f"-[{cname} {m['name']}]", "kind": "method",
                               "class": cname, "sel": m["name"], "types": m.get("types", "")}
        for m in cls.get("class_methods") or []:
            funcs[m["imp"]] = {"name": f"+[{cname} {m['name']}]", "kind": "cmethod",
                               "class": cname, "sel": m["name"], "types": m.get("types", "")}
    text_sect_idx = None
    for i, s in enumerate(sl.scan["sections"], start=1):
        if s["seg"] == "__TEXT" and s["name"] == "__text":
            text_sect_idx = i
    for sym in sl.symbols:
        if sym["kind"] == "defined_sect" and sym["sect"] == text_sect_idx and sym["value"]:
            va = sym["value"]
            if va not in funcs:
                funcs[va] = {"name": sym["name"], "kind": "cfunc", "class": None,
                             "sel": None, "types": ""}
    # extra starts: data pointers into __text (block invokes, C callbacks)
    t0, t1 = img.text
    known = set(funcs)
    extras = {}
    for seg, nm in (("__DATA_CONST", "__const"), ("__DATA_CONST", "__cfstring"),
                    ("__DATA", "__data"), ("__DATA", "__objc_const"),
                    ("__TEXT", "__const"), ("__DATA_CONST", "__objc_arraydata")):
        r = sec_range(sl, seg, nm)
        if not r:
            continue
        va = r[0]
        while va < r[1]:
            kind, val = img.decode(va)
            if kind == "ptr" and t0 <= val < t1 and val not in known and val % 4 == 0:
                extras.setdefault(val, []).append(f"{seg},{nm}@{va:#x}")
            va += 8
    for va, refs in extras.items():
        funcs[va] = {"name": f"sub_{va:x}", "kind": "block_or_cb", "class": None,
                     "sel": None, "types": "", "refs": refs}
    return funcs


def disasm_function(img, start, end, name_by_va):
    sl = img.slice
    code = sl.read(start, end - start)
    lines = []
    summary = {"selectors": [], "strings": [], "calls": []}
    regs = {}   # reg number -> computed VA
    for insn in img.md.disasm(code, start):
        ann = []
        ops = insn.operands
        if insn.mnemonic == "adrp" and len(ops) == 2:
            regs[ops[0].reg] = ops[1].imm
        elif insn.mnemonic == "add" and len(ops) == 3 and ops[1].type == 1 and ops[2].type == 2:
            # add rd, rn, #imm  (capstone: imm operand type==2 IMM)
            if ops[1].reg in regs:
                va = regs[ops[1].reg] + ops[2].imm
                regs[ops[0].reg] = va
                a = img.resolve_va(va)
                if a:
                    ann.append(a)
                    if a.startswith('STR "'):
                        summary["strings"].append(a[5:-1])
        elif insn.mnemonic in ("ldr", "ldrb", "ldrh", "ldrsw") and len(ops) >= 2 and ops[1].type == 3:
            mem = ops[1].mem
            if mem.base in regs:
                va = regs[mem.base] + mem.disp
                a = img.resolve_va(va)
                if a:
                    ann.append("@" + a)
                    if a.startswith('SEL "'):
                        summary["selectors"].append(a[5:-1])
                # register now holds pointer-to / loaded pointer value
                kind, val = img.decode(va)
                if kind == "ptr":
                    regs[ops[0].reg] = val
        elif insn.mnemonic in ("bl", "b") and ops and ops[0].type == 2:
            tgt = ops[0].imm
            if tgt in img.stubs:
                ann.append("CALL " + img.stubs[tgt])
                summary["calls"].append(img.stubs[tgt])
                nm = img.stubs[tgt]
                if nm.startswith("objc_msgSend$"):
                    summary["selectors"].append(nm[len("objc_msgSend$"):])
            elif tgt in name_by_va:
                ann.append("CALL " + name_by_va[tgt])
                summary["calls"].append(name_by_va[tgt])
        lines.append(f"{insn.address:#010x}  {insn.mnemonic:<8} {insn.op_str}" +
                     (("   ; " + " ".join(ann)) if ann else ""))
    return lines, summary


def main():
    path = sys.argv[1] if len(sys.argv) > 1 else str(DEFAULT_BIN)
    img = Image(path)
    funcs = collect_functions(img)
    starts = sorted(funcs)
    t0, t1 = img.text
    name_by_va = {va: f["name"] for va, f in funcs.items()}
    OUTDIR.mkdir(parents=True, exist_ok=True)
    index = {}
    by_class = {}
    for i, va in enumerate(starts):
        end = starts[i + 1] if i + 1 < len(starts) else t1
        f = funcs[va]
        lines, summ = disasm_function(img, va, end, name_by_va)
        header = [f"=== {f['name']}  va={va:#x} size={end - va} types={f.get('types','')}"]
        if f.get("refs"):
            header.append("; data refs: " + ", ".join(f["refs"]))
        entry = header + lines + [""]
        key = f["class"] or ("_CFunctions" if f["kind"] == "cfunc" else "_Blocks")
        by_class.setdefault(key, []).extend(entry)
        index[f["name"]] = {"va": va, "size": end - va, "kind": f["kind"],
                            "class": f["class"], "selectors": sorted(set(summ["selectors"])),
                            "strings": sorted(set(summ["strings"])),
                            "calls": sorted(set(summ["calls"]))}
    for key, lines in by_class.items():
        (OUTDIR / f"{key}.asm").write_text("\n".join(lines))
    (OUTDIR / "index.json").write_text(json.dumps(index, indent=1, ensure_ascii=False))
    # corrected class table: superclass decoded locally (metadata's is shifted)
    objc = img.slice.parse_objc()
    classes_info = {}
    for cls in objc["classes"]:
        kind, val = img.decode(cls["va"] + 8)
        if kind == "bind":
            sup = val.replace("_OBJC_CLASS_$_", "")
        elif kind == "ptr":
            sup = img.slice.class_name_at(val)
        else:
            sup = None
        classes_info[cls["name"]] = {
            "superclass": sup,
            "ivars": [{"name": i["name"], "type": i["type"]} for i in (cls.get("ivars") or [])],
            "properties": [{"name": p["name"], "attributes": p["attributes"]}
                           for p in (cls.get("properties") or [])],
            "protocols": cls.get("protocols") or [],
        }
    (OUTDIR / "classes.json").write_text(json.dumps(classes_info, indent=1, ensure_ascii=False))
    print("superclasses:", {k: v["superclass"] for k, v in classes_info.items()})
    print(f"functions: {len(funcs)}  files: {len(by_class)}")
    kinds = {}
    for f in funcs.values():
        kinds[f["kind"]] = kinds.get(f["kind"], 0) + 1
    print(kinds)


if __name__ == "__main__":
    main()
