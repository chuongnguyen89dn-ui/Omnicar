#!/usr/bin/env python3
"""Annotated ARM64 disassembler for OmniCarSpeedBubble (arm64 slice).
Resolves: function boundaries (LC_FUNCTION_STARTS + ObjC IMPs + symbols),
__stubs -> import names, __objc_stubs -> selector, adrp/ldr/add targets ->
cfstring contents, selrefs, classrefs, cstrings, __const doubles/floats,
selref/classref slots, global symbols. Output: one .txt per function + index.json.
"""
import sys, os, json, struct, re
sys.path.insert(0, os.path.expanduser("~/workspace/omnicar-re/metadata/tools"))
from macho_scan import split_fat, parse_slice, cstr
from macho_objc import Slice as ObjCSlice
from capstone import Cs, CS_ARCH_ARM64, CS_MODE_LITTLE_ENDIAN
from capstone.arm64_const import (ARM64_OP_IMM, ARM64_OP_MEM, ARM64_OP_REG)

BIN = os.path.expanduser("~/workspace/omnicar-re/payload/var/jb/Library/MobileSubstrate/DynamicLibraries/OmniCarSpeedBubble.dylib")
RAW = os.path.expanduser("~/workspace/omnicar-re/metadata/raw/OmniCarSpeedBubble")
OUT = os.path.expanduser("~/workspace/omnicar-re/src/SpeedBubble/disasm")

data = open(BIN, "rb").read()
slices = split_fat(data)
cpu, off, size = [s for s in slices if s[0] == "arm64"][0]
sdata = data[off:off + size]
scan = parse_slice(data, off)
S = ObjCSlice(sdata, scan)
objc = json.load(open(os.path.join(RAW, "objc.json")))["slices"][0]["objc"]

sections = {}
for s in scan["sections"]:
    sections.setdefault(s["name"], s)
def sec_of(va):
    for s in scan["sections"]:
        if s["addr"] <= va < s["addr"] + s["size"]:
            return s
    return None

def read_cstr_at(va, maxlen=4096):
    return S.read_cstr(va, maxlen)

# ---------- function starts ----------
def function_starts():
    # parse LC_FUNCTION_STARTS (0x26) manually
    ncmds = struct.unpack_from("<I", sdata, 16)[0]
    o = 32
    fs_off = fs_size = None
    for _ in range(ncmds):
        cmd, cmdsize = struct.unpack_from("<II", sdata, o)
        if cmd == 0x26:
            fs_off, fs_size = struct.unpack_from("<II", sdata, o + 8)
        o += cmdsize
    starts = []
    if fs_off:
        addr = 0  # LC_FUNCTION_STARTS deltas are image-base relative
        p = fs_off
        end = fs_off + fs_size
        while p < end:
            # uleb128
            val = 0; shift = 0
            while True:
                b = sdata[p]; p += 1
                val |= (b & 0x7f) << shift; shift += 7
                if not (b & 0x80): break
            if val == 0: break
            addr += val
            starts.append(addr)
    return starts

# ---------- name maps ----------
addr_name = {}   # va -> best name
def add_name(va, name, overwrite=False):
    if va is None: return
    if overwrite or va not in addr_name:
        addr_name[va] = name

# symbols (defined)
sym_by_addr = {}
for sym in S.symbols:
    if sym["kind"] in ("defined_sect", "absolute") and sym["value"]:
        sym_by_addr[sym["value"]] = sym["name"]
        add_name(sym["value"], sym["name"])

# ObjC methods
method_names = {}
for cls in objc["classes"]:
    cname = cls["name"]
    for m in cls.get("methods") or []:
        method_names[m["imp"]] = f"-[{cname} {m['name']}]"
        add_name(m["imp"], method_names[m["imp"]], overwrite=True)
    for m in cls.get("class_methods") or []:
        method_names[m["imp"]] = f"+[{cname} {m['name']}]"
        add_name(m["imp"], method_names[m["imp"]], overwrite=True)

# init offsets (constructors)
init_addrs = []
io = sections.get("__init_offsets")
if io:
    for i in range(io["size"] // 4):
        v = struct.unpack_from("<I", sdata, io["offset"] + i * 4)[0]
        init_addrs.append(v)
        add_name(v, f"__init_{i}")

# ---------- selrefs / classrefs / cfstrings ----------
selref_name = {}   # selref va -> selector
for va_s, sel in (objc.get("selrefs") or {}).items() if isinstance(objc.get("selrefs"), dict) else []:
    selref_name[int(va_s)] = sel
# selrefs in json may be list; fallback: decode section directly
if not selref_name:
    ss = sections["__objc_selrefs"]
    for i in range(ss["size"] // 8):
        va = ss["addr"] + i * 8
        kind, val = S.ptr_at(va)
        if kind == "ptr":
            nm = read_cstr_at(val)
            if nm: selref_name[va] = nm
        elif kind == "bind":
            selref_name[va] = val

classref_name = {}
cr = objc.get("classrefs")
if isinstance(cr, dict):
    for va_s, nm in cr.items():
        classref_name[int(va_s)] = nm
if not classref_name:
    cs = sections["__objc_classrefs"]
    for i in range(cs["size"] // 8):
        va = cs["addr"] + i * 8
        kind, val = S.ptr_at(va)
        if kind == "bind":
            # chained-fixup ordinal decode is shifted by one import:
            # the true name of slot va is the name decoded at va+8
            k2, v2 = S.ptr_at(va + 8)
            classref_name[va] = (v2 if k2 == "bind" else val).replace("_OBJC_CLASS_$_", "")
        elif kind == "ptr":
            try: classref_name[va] = S.class_name_at(val)
            except Exception: pass

cfstring_val = {}
cfs = sections["__cfstring"]
for i in range(cfs["size"] // 32):
    va = cfs["addr"] + i * 32
    kind, val = S.ptr_at(va + 16)
    if kind == "ptr":
        txt = read_cstr_at(val)
        if txt is not None: cfstring_val[va] = txt

def describe_va(va):
    """Human description of what lives at va."""
    if va in cfstring_val:
        t = cfstring_val[va]
        return f'@"{t}"' if len(t) <= 80 else f'@"{t[:77]}..."'
    if va in selref_name:
        return f"selref -> @{selref_name[va]}"
    if va in classref_name:
        return f"classref -> {classref_name[va]}"
    if va in addr_name:
        return addr_name[va]
    s = sec_of(va)
    if s:
        if s["name"] in ("__cstring", "__objc_methname", "__objc_classname", "__ustring"):
            if s["name"] == "__ustring":
                raw = S.read(va, 64)
                try: return 'u"' + raw.decode("utf-16-le").split("\x00")[0] + '"'
                except Exception: pass
            t = read_cstr_at(va)
            if t: return f'"{t}"' if len(t) <= 80 else f'"{t[:77]}..."'
        if s["name"] in ("__const",) :
            raw = S.read(va, 8)
            if raw and len(raw) == 8:
                d = struct.unpack("<d", raw)[0]
                f = struct.unpack("<f", raw[:4])[0]
                return f"__const[{va:#x}] double={d!r} float={f!r}"
        return f"{s['seg']},{s['name']}+{va - s['addr']:#x}"
    return None

# ---------- stubs ----------
stub_target = {}   # stub va -> import name
st = sections["__stubs"]
md0 = Cs(CS_ARCH_ARM64, CS_MODE_LITTLE_ENDIAN); md0.detail = True
for i in range(st["size"] // 12):
    va = st["addr"] + i * 12
    code = S.read(va, 12)
    tgt = None
    for insn in md0.disasm(code, va):
        if insn.mnemonic == "ldr" and len(insn.operands) == 2 and insn.operands[1].type == ARM64_OP_MEM:
            got = insn.operands[1].mem.base
            # adrp value tracked crudely: previous insn
            tgt = insn.operands[1].mem.disp
    # simpler: first insn adrp x16, page; second ldr x16,[x16,#disp]
    insns = list(md0.disasm(code, va))
    if len(insns) >= 2 and insns[0].mnemonic == "adrp" and insns[1].mnemonic == "ldr":
        page = insns[0].operands[1].imm
        disp = insns[1].operands[1].mem.disp
        kind, val = S.ptr_at(page + disp)
        if kind == "bind":
            stub_target[va] = val
        elif kind == "ptr":
            stub_target[va] = addr_name.get(val, f"sub_{val:x}")

# OVERRIDE: LC_DYSYMTAB indirect symbols are authoritative for __stubs names
# (chained-fixup ordinal decode in ptr_at proved off-by-one vs call sites:
#  0x27bfc is MSHookMessageEx (4 args), 0x27d70 is dispatch_once, 0x27f74 objc_getClass)
def _dysym_stub_names():
    d = S.data
    ncmds = struct.unpack_from("<I", d, 16)[0]
    p = 32; dysym = None; secmap = {}
    for _ in range(ncmds):
        cmd, cs = struct.unpack_from("<II", d, p)
        if cmd == 0xB:
            dysym = struct.unpack_from("<18I", d, p + 8)
        if cmd == 0x19:
            nsec = struct.unpack_from("<I", d, p + 64)[0]
            for i in range(nsec):
                sp = p + 72 + i * 80
                nm = d[sp:sp + 16].rstrip(b"\0").decode()
                secmap[nm] = struct.unpack_from("<I", d, sp + 68)[0]
        p += cs
    stt = scan["symtab"]
    def name_at(n):
        e = d.index(b"\0", stt["stroff"] + n)
        return d[stt["stroff"] + n:e].decode("utf-8", "replace")
    syms = []
    for i in range(stt["nsyms"]):
        n = struct.unpack_from("<I", d, stt["symoff"] + i * 16)[0]
        syms.append(name_at(n) if n else "")
    ioff = dysym[12]
    ind = [struct.unpack_from("<I", d, ioff + i * 4)[0] for i in range(dysym[13])]
    out = {}
    r1 = secmap["__stubs"]
    for i in range(st["size"] // 12):
        out[st["addr"] + i * 12] = syms[ind[r1 + i]]
    return out

stub_target.update(_dysym_stub_names())

objc_stub_sel = {}  # objc stub va -> selector
ost = sections["__objc_stubs"]
# entries are variable; walk by finding adrp+ldr selref pairs every 20 bytes typical for lld: adrp x1; ldr x1,[x1]; adrp x16; ldr x16; br x16 = 20 bytes
esz = 32  # arm64 objc stubs: 5 insns + 3x brk padding = 32 bytes
for base in range(ost["addr"], ost["addr"] + ost["size"], esz):
    code = S.read(base, esz)
    sel = None
    for insn in md0.disasm(code, base):
        if insn.mnemonic in ("adrp",) and insn.operands[1].imm is not None:
            page = insn.operands[1].imm
            # look ahead handled below via pairs
    insns = list(md0.disasm(code, base))
    for j, insn in enumerate(insns):
        if insn.mnemonic == "ldr" and len(insn.operands) == 2 and insn.operands[1].type == ARM64_OP_MEM:
            # find preceding adrp for same reg
            reg = insn.operands[1].mem.base
            for k in range(j - 1, -1, -1):
                if insns[k].mnemonic == "adrp" and insns[k].operands[0].reg == reg:
                    tva = insns[k].operands[1].imm + insn.operands[1].mem.disp
                    if tva in selref_name:
                        sel = selref_name[tva]
                    break
    if sel:
        objc_stub_sel[base] = sel

def call_name(va):
    if va in stub_target: return stub_target[va]
    if va in objc_stub_sel: return f"objc_msgSend${objc_stub_sel[va]}"
    if va in addr_name: return addr_name[va]
    return f"sub_{va:x}"

# ---------- disassembly ----------
md = Cs(CS_ARCH_ARM64, CS_MODE_LITTLE_ENDIAN); md.detail = True

def annotate(insns):
    """Track adrp per register linearly; produce comment strings per insn index."""
    comments = {}
    adrp_val = {}
    for idx, insn in enumerate(insns):
        ops = insn.operands
        if insn.mnemonic == "adrp" and len(ops) == 2:
            adrp_val[ops[0].reg] = ops[1].imm
        elif insn.mnemonic == "add" and len(ops) == 3 and ops[1].type == ARM64_OP_REG and ops[2].type == ARM64_OP_IMM:
            base = adrp_val.get(ops[1].reg)
            if base is not None:
                va = base + ops[2].imm
                d = describe_va(va)
                if d: comments[idx] = f"; {d}"
                adrp_val[ops[0].reg] = va
        elif insn.mnemonic == "ldr" and len(ops) == 2 and ops[1].type == ARM64_OP_MEM:
            base = adrp_val.get(ops[1].mem.base)
            if base is not None:
                va = base + ops[1].mem.disp
                d = describe_va(va)
                extra = ""
                kind, val = S.ptr_at(va)
                if kind == "bind":
                    k2, v2 = S.ptr_at(va + 8)  # ordinal decode shifted by one import
                    extra = f" (= import {v2 if k2 == 'bind' else val})"
                elif kind == "ptr" and va in selref_name: extra = ""
                elif kind == "ptr" and sec_of(va) and sec_of(va)["name"] in ("__got",):
                    extra = f" (= {addr_name.get(val, val)})" if isinstance(val, int) else ""
                if d: comments[idx] = f"; [{va:#x}] {d}{extra}"
                elif extra: comments[idx] = f"; [{va:#x}]{extra}"
        elif insn.mnemonic in ("bl", "b") and ops and ops[0].type == ARM64_OP_IMM:
            comments[idx] = f"; {call_name(ops[0].imm)}"
        elif insn.mnemonic in ("blr",):
            pass
        # reset adrp tracking on labels/branches roughly: keep (linear ok)
    return comments

def disasm_func(start, end):
    code = S.read(start, end - start)
    insns = list(md.disasm(code, start))
    comments = annotate(insns)
    lines = []
    for i, insn in enumerate(insns):
        c = comments.get(i, "")
        lines.append(f"{insn.address:08x}  {insn.mnemonic:8s} {insn.op_str:44s}{c}")
    return lines

def safe_name(n):
    return re.sub(r"[^A-Za-z0-9_+\-\[\]]", "_", n)

def main():
    starts = sorted(set(function_starts()) | set(method_names.keys()) |
                    {v for v in sym_by_addr if sections["__text"]["addr"] <= v < sections["__text"]["addr"] + sections["__text"]["size"]} |
                    set(init_addrs))
    text = sections["__text"]
    tend = text["addr"] + text["size"]
    starts = [s for s in starts if text["addr"] <= s < tend]
    index = {}
    os.makedirs(OUT, exist_ok=True)
    for i, st_addr in enumerate(starts):
        end = starts[i + 1] if i + 1 < len(starts) else tend
        name = addr_name.get(st_addr, f"sub_{st_addr:x}")
        lines = disasm_func(st_addr, end)
        fname = f"{st_addr:08x}_{safe_name(name)}.txt"
        with open(os.path.join(OUT, fname), "w") as f:
            f.write(f"# {name}\n# addr {st_addr:#x} .. {end:#x}  ({end - st_addr} bytes)\n\n")
            f.write("\n".join(lines) + "\n")
        index[f"{st_addr:#x}"] = {"name": name, "end": end, "size": end - st_addr, "file": fname}
    json.dump(index, open(os.path.join(OUT, "index.json"), "w"), indent=1)
    print(f"functions: {len(index)}")
    print(f"objc stubs resolved: {len(objc_stub_sel)}, stubs: {len(stub_target)}, selrefs: {len(selref_name)}, classrefs: {len(classref_name)}, cfstrings: {len(cfstring_val)}")

if __name__ == "__main__":
    main()
