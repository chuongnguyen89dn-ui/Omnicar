#!/usr/bin/env python3
"""abdis.py - annotated capstone disassembly harness for OmniCarAppBridge (arm64 slice).
Reuses the wave-1 chained-fixups parsers in metadata/tools."""
import json, struct, sys, os
sys.path.insert(0, os.path.expanduser("~/workspace/omnicar-re/metadata/tools"))
from macho_scan import split_fat, parse_slice
from macho_objc import Slice
from capstone import Cs, CS_ARCH_ARM64, CS_MODE_LITTLE_ENDIAN
from capstone.arm64 import *

BIN = os.path.expanduser("~/workspace/omnicar-re/payload/var/jb/Library/MobileSubstrate/DynamicLibraries/OmniCarAppBridge.dylib")
RAW = os.path.expanduser("~/workspace/omnicar-re/metadata/raw/OmniCarAppBridge")

data = open(BIN, "rb").read()
scan = json.load(open(os.path.join(RAW, "scan.json")))["slices"][0]
objcj = json.load(open(os.path.join(RAW, "objc.json")))["slices"][0]
sl = Slice(data[scan["slice_offset"]:scan["slice_offset"]+scan["slice_size"]], scan)

# CORRECTED decode (verified 2026-11-08): wave-1 Slice.decode_ptr maps bind
# ordinals via imports[ordinal-1] -- OFF BY ONE for this binary (fmt 6).
# Anchors: __cfstring isa ordinal 180 == imports[180]
# ___CFConstantStringClassReference; block isa ordinal 179 ==
# __NSConcreteGlobalBlock; stub 0x242c0 called by _OMCPref as
# CFPreferencesCopyAppValue(key, domain) == imports[181] direct.
def decode2(raw, va=None):
    if raw == 0:
        return ("null", 0)
    if (raw >> 63) & 1:
        ordinal = raw & 0xFFFF
        if 0 <= ordinal < len(sl.imports):
            return ("bind", sl.imports[ordinal])
        return ("bind", f"<ordinal {ordinal}>")
    return ("ptr", raw & ((1 << 36) - 1))

SECT = {(s["seg"], s["name"]): s for s in scan["sections"]}
def sect_bytes(seg, name):
    s = SECT.get((seg, name));
    if not s: return b"", 0
    off = s["offset"]; return data[scan["slice_offset"]+off: scan["slice_offset"]+off+s["size"]], s["addr"]

TEXT_ADDR = SECT[("__TEXT","__text")]["addr"]; TEXT_SIZE = SECT[("__TEXT","__text")]["size"]

# ---- symbols
SYMS = {}      # va -> name (defined)
for sym in objcj["symbols"]:
    if not sym["external"] and sym.get("value"):
        SYMS[sym["value"]] = sym["name"]
    elif sym.get("value"):
        SYMS.setdefault(sym["value"], sym["name"])

# ---- function starts (LC_FUNCTION_STARTS)
def parse_function_starts():
    raw = data
    off = scan["slice_offset"] + 32
    starts = []
    for _ in range(scan["ncmds"]):
        cmd, cmdsize = struct.unpack_from("<II", raw, off)
        if (cmd & ~0x80000000) == 0x26:  # LC_FUNCTION_STARTS
            doff, dsize = struct.unpack_from("<II", raw, off+8)
            p = scan["slice_offset"] + doff; end = p + dsize; addr = TEXT_ADDR
            while p < end:
                # uleb128
                shift = 0; val = 0
                while True:
                    b = raw[p]; p += 1
                    val |= (b & 0x7f) << shift; shift += 7
                    if not (b & 0x80): break
                if val == 0: break
                addr += val; starts.append(addr)
        off += cmdsize
    return sorted(starts)
FUNC_STARTS = parse_function_starts()
FUNC_END = {}
for i, a in enumerate(FUNC_STARTS):
    FUNC_END[a] = FUNC_STARTS[i+1] if i+1 < len(FUNC_STARTS) else TEXT_ADDR + TEXT_SIZE

# ---- pointer resolution helpers
def describe_ptr(va):
    """Decode the pointer stored at va; return human description or None."""
    try:
        kind, val = decode2(sl.read_u64(va), va)
    except Exception:
        return None
    if kind == "bind":
        return f"import:{val}"
    if kind == "authbind":
        return f"import:{val}"
    if kind in ("rebase", "authrebase"):
        return ("va", val)
    return None

# ---- cstring maps
CSTR = {}
for seg, name in [("__TEXT","__cstring"),("__TEXT","__objc_methname"),("__TEXT","__objc_classname"),
                  ("__TEXT","__objc_methtype"),("__TEXT","__ustring")]:
    b, base = sect_bytes(seg, name)
    i = 0
    while i < len(b):
        j = b.find(b"\x00", i)
        if j < 0: break
        if j > i:
            try: CSTR[base+i] = b[i:j].decode("utf-8", "replace")
            except Exception: pass
        i = j + 1

# ---- cfstring map
CFSTR = {}
b, base = sect_bytes("__DATA", "__cfstring")
if not b: b, base = sect_bytes("__DATA_CONST", "__cfstring")
for i in range(0, len(b) - 31, 32):
    ent = base + i
    strptr_raw = struct.unpack_from("<Q", b, i+16)[0]
    try:
        kind, val = decode2(strptr_raw, ent+16)
    except Exception:
        continue
    if isinstance(val, int):
        try: CFSTR[ent] = sl.read_cstr(val)
        except Exception: pass

# ---- selrefs
SELREF = {}
for seg in ("__DATA", "__DATA_CONST"):
    b, base = sect_bytes(seg, "__objc_selrefs")
    if not b: continue
    for i in range(0, len(b)-7, 8):
        va = base + i
        raw = struct.unpack_from("<Q", b, i)[0]
        try: kind, val = decode2(raw, va)
        except Exception: continue
        if isinstance(val, int):
            try: SELREF[va] = sl.read_cstr(val)
            except Exception: pass

# ---- classrefs
CLASSREF = {}
for seg in ("__DATA", "__DATA_CONST"):
    b, base = sect_bytes(seg, "__objc_classrefs")
    if not b: continue
    for i in range(0, len(b)-7, 8):
        va = base + i
        raw = struct.unpack_from("<Q", b, i)[0]
        try: kind, val = decode2(raw, va)
        except Exception: continue
        if kind in ("bind", "authbind"):
            nm = val
            if nm.startswith("_OBJC_CLASS_$_"): nm = nm[len("_OBJC_CLASS_$_"):]
            elif nm.startswith("_OBJC_METACLASS_$_"): nm = "meta:" + nm[len("_OBJC_METACLASS_$_"):]
            CLASSREF[va] = nm
        elif isinstance(val, int):
            try: CLASSREF[va] = sl.class_name_at(val) or hex(val)
            except Exception: CLASSREF[va] = hex(val)

# ---- GOT / la_symbol_ptr entries
GOT = {}
for seg, name in [("__DATA","__got"),("__DATA","__la_symbol_ptr"),("__DATA_CONST","__got"),("__AUTH","__auth_got")]:
    b, base = sect_bytes(seg, name)
    if not b: continue
    for i in range(0, len(b)-7, 8):
        va = base + i
        raw = struct.unpack_from("<Q", b, i)[0]
        try: kind, val = decode2(raw, va)
        except Exception: continue
        if kind in ("bind", "authbind"):
            GOT[va] = val
        elif isinstance(val, int):
            GOT[va] = SYMS.get(val, hex(val))

# ---- stubs
STUB = {}   # va -> import name
b, base = sect_bytes("__TEXT", "__stubs")
md = Cs(CS_ARCH_ARM64, CS_MODE_LITTLE_ENDIAN); md.detail = True
for i in range(0, len(b)-11, 12):
    va = base + i
    insns = list(md.disasm(b[i:i+12], va))
    got = None
    for ins in insns:
        if ins.mnemonic == "ldr" and len(ins.operands) >= 2 and ins.operands[1].type == ARM64_OP_MEM:
            got = ins.operands[1].mem.base and (ins.address)  # placeholder
    # simpler: second insn ldr x16,[x16,#imm] after adrp x16
    if len(insns) >= 2 and insns[0].mnemonic == "adrp" and insns[1].mnemonic == "ldr":
        page = insns[0].operands[1].imm
        disp = insns[1].operands[1].mem.disp
        target = page + disp
        if target in GOT: STUB[va] = GOT[target]

# objc stubs: stub -> selector
OBJCSTUB = {}
b, base = sect_bytes("__TEXT", "__objc_stubs")
if b:
    insns = list(md.disasm(b, base))
    cur = None; sel = None
    for ins in insns:
        if ins.mnemonic == "adrp" and ins.operands[0].reg == ARM64_REG_X1:
            cur = ins.operands[1].imm; sel = None
        elif ins.mnemonic == "ldr" and cur is not None and ins.operands[0].reg == ARM64_REG_X1 and ins.operands[1].type == ARM64_OP_MEM:
            t = cur + ins.operands[1].mem.disp
            if t in SELREF: sel = SELREF[t]
        elif ins.mnemonic in ("br",) and sel:
            # stub starts 0x10 or 0x14 before? stub entry = address of first adrp of group; approximate: record by br addr-? handled by caller ranges
            pass
    # robust approach: iterate 32-byte windows? objc stubs are 24 bytes on lld arm64 (adrp/ldr/adrp/ldr/br + nop?) -> detect per-stub by scanning for adrp x1 groups
    starts = [ins.address for ins in insns if ins.mnemonic == "adrp" and ins.operands[0].reg == ARM64_REG_X1]
    for saddr in starts:
        page = None; selname = None
        for ins in insns:
            if ins.address < saddr: continue
            if ins.address > saddr + 24: break
            if ins.mnemonic == "adrp" and ins.operands[0].reg == ARM64_REG_X1: page = ins.operands[1].imm
            elif ins.mnemonic == "ldr" and ins.operands[0].reg == ARM64_REG_X1 and ins.operands[1].type == ARM64_OP_MEM and page is not None:
                t = page + ins.operands[1].mem.disp
                if t in SELREF: selname = SELREF[t]
        if selname: OBJCSTUB[saddr] = selname

# ---- method imps
METHODS = []  # (va, class, name, types, meta)
for c in objcj["objc"]["classes"]:
    for m in c.get("methods") or []:
        METHODS.append((m["imp"], c["name"], "-"+m["name"], m["types"], False))
    for m in c.get("class_methods") or []:
        METHODS.append((m["imp"], c["name"], "+"+m["name"], m["types"], True))
IMP2NAME = {va: f"{cls} {nm}" for va, cls, nm, t, meta in METHODS}

# ---- init funcs (__init_offsets: u32 offsets from image base)
INITFUNCS = []
b, base = sect_bytes("__TEXT", "__init_offsets")
for i in range(0, len(b)-3, 4):
    INITFUNCS.append(struct.unpack_from("<I", b, i)[0])

LABELS = {}
for va, nm in SYMS.items(): LABELS[va] = nm
for va, nm in IMP2NAME.items(): LABELS.setdefault(va, nm.replace(" ", "_").replace("-", "m_").replace("+", "c_").replace(":", "_"))
for i, va in enumerate(INITFUNCS): LABELS.setdefault(va, f"__mod_init_{i}")

def va_bytes(va, size):
    off = sl.va_to_off(va)
    return sl.data[off:off+size]

def annotate_target(va):
    if va in CFSTR: return f'@"{CFSTR[va]}"'
    if va in CSTR: return f'"{CSTR[va]}"'
    if va in SELREF: return f"@selector({SELREF[va]})"
    if va in CLASSREF: return f"class({CLASSREF[va]})"
    if va in GOT: return f"got:{GOT[va]}"
    if va in LABELS: return LABELS[va]
    return None

def disasm_func(start, end=None, out=None):
    if end is None: end = FUNC_END.get(start, start+0x1000)
    code = va_bytes(start, end-start)
    insns = list(md.disasm(code, start))
    lines = []
    name = LABELS.get(start, f"sub_{start:x}")
    lines.append(f"; ==== {name} @ {start:#x}..{end:#x} ({end-start} bytes) ====")
    pages = {}   # reg -> page base from adrp
    refs = {"calls": [], "strings": [], "sels": [], "classes": []}
    for ins in insns:
        ann = ""
        ops = ins.operands
        if ins.mnemonic == "adrp" and len(ops) == 2:
            pages[ops[0].reg] = ops[1].imm
        elif ins.mnemonic == "add" and len(ops) == 3 and ops[1].type == ARM64_OP_REG and ops[1].reg in pages and ops[2].type == ARM64_OP_IMM:
            t = pages[ops[1].reg] + ops[2].imm
            d = annotate_target(t)
            if d: ann = f"; -> {d}"
            if t in CFSTR: refs["strings"].append(CFSTR[t])
            elif t in CSTR: refs["strings"].append(CSTR[t])
            if t in SELREF: refs["sels"].append(SELREF[t])
            if t in CLASSREF: refs["classes"].append(CLASSREF[t])
        elif ins.mnemonic == "ldr" and len(ops) == 2 and ops[1].type == ARM64_OP_MEM and ops[1].mem.base in pages:
            t = pages[ops[1].mem.base] + ops[1].mem.disp
            d = annotate_target(t)
            if d: ann = f"; -> [{d}]"
            if t in SELREF: refs["sels"].append(SELREF[t])
            if t in CLASSREF: refs["classes"].append(CLASSREF[t])
        elif ins.mnemonic in ("bl", "b") and len(ops) == 1 and ops[0].type == ARM64_OP_IMM:
            t = ops[0].imm
            if t in STUB:
                ann = f"; call {STUB[t]}"; refs["calls"].append(STUB[t])
            elif t in OBJCSTUB:
                ann = f"; objc_msgSend: {OBJCSTUB[t]}"; refs["sels"].append(OBJCSTUB[t]); refs["calls"].append("objc_msgSend:"+OBJCSTUB[t])
            elif t in LABELS:
                ann = f"; call {LABELS[t]}"; refs["calls"].append(LABELS[t])
            else:
                ann = f"; call sub_{t:x}"; refs["calls"].append(f"sub_{t:x}")
        elif ins.mnemonic == "blr":
            ann = "; indirect call"
        lines.append(f"{ins.address:#010x}  {ins.mnemonic:8s} {ins.op_str}{('   ' + ann) if ann else ''}")
    txt = "\n".join(lines) + "\n"
    if out:
        with open(out, "w") as f: f.write(txt)
    return txt, refs

if __name__ == "__main__":
    print(f"funcs={len(FUNC_STARTS)} syms={len(SYMS)} stubs={len(STUB)} objcstubs={len(OBJCSTUB)} selrefs={len(SELREF)} classrefs={len(CLASSREF)} cfstr={len(CFSTR)} init={INITFUNCS}")
    print("inits:", [hex(x) for x in INITFUNCS])
    print("defined syms:", {hex(k): v for k, v in sorted(SYMS.items()) if v.startswith('_OMC') or v.startswith('_AB')})

