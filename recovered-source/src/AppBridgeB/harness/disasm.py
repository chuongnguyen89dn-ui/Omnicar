#!/usr/bin/env python3
"""Annotated disassembly + xref for OmniCarAppBridge arm64 slice.

Builds:
 - stub_name:  __stubs addr -> import name (indirect symbol table)
 - got_name:   __got addr -> import name (indirect syms, cross-checked w/ chained binds)
 - objc_stub:  __objc_stubs addr -> selector name (via selref chained rebase -> methname)
 - cfstring:   __cfstring addr -> literal
 - classref:   __objc_classrefs slot addr -> class name
 - selref:     __objc_selrefs slot addr -> selector name
 - class_name: class struct addr -> name
Then capstone-disassembles every function (LC_FUNCTION_STARTS), annotating:
 - bl/b targets (internal fn, stub import, objc stub selector, msgSend)
 - adrp+ldr/add literal resolution (cfstring, classref, selref, got, cstring)
"""
import json, struct, sys
from capstone import Cs, CS_ARCH_ARM64, CS_MODE_LITTLE_ENDIAN
import macho

S = macho.load()
D, B = S.d, S.base

def u32(o): return struct.unpack_from("<I", D, o)[0]
def u64(o): return struct.unpack_from("<Q", D, o)[0]

# ---------- indirect symbols ----------
ncmds = u32(B+16); off = B+32
symtab = dysym = None
for _ in range(ncmds):
    cmd, size = u32(off) & 0x7fffffff, u32(off+4)
    if cmd == 0x2: symtab = struct.unpack_from("<4I", D, off+8)
    elif cmd == 0xb: dysym = struct.unpack_from("<18I", D, off+8)
    off += size
symoff, nsyms, stroff, _ = symtab
sym_names = []
for i in range(nsyms):
    o = B + symoff + i*16
    n_strx = u32(o)
    sym_names.append(macho.cstr(D, B+stroff+n_strx) if n_strx else "")
indirect = []
ind_off, ind_n = dysym[12], dysym[13]
for i in range(ind_n):
    indirect.append(u32(B + ind_off + i*4))

def sec(seg, name): return S.sections[(seg, name)]

stub_name = {}
st = sec("__TEXT", "__stubs"); stub_sz = 12
for i in range(st["size"]//stub_sz):
    idx = indirect[0 + i]  # __stubs reserved1 = 0
    stub_name[st["addr"] + i*stub_sz] = sym_names[idx]

got_name = {}
gt = sec("__DATA_CONST", "__got")
for i in range(gt["size"]//8):
    idx = indirect[154 + i]  # __got reserved1 = 154
    name = sym_names[idx]
    got_name[gt["addr"] + i*8] = name
    kind, val = S.chained(gt["addr"] + i*8)
    if kind == "bind" and val != name:
        print("WARN got mismatch", hex(gt["addr"]+i*8), name, "vs chained", val, file=sys.stderr)

# ---------- selrefs / classrefs ----------
selref_name = {}
sr = sec("__DATA", "__objc_selrefs")
for i in range(sr["size"]//8):
    va = sr["addr"] + i*8
    kind, val = S.chained(va)
    if kind == "rebase":
        selref_name[va] = S.cstrv(val)

def class_name_at(class_va):
    if class_va == 0: return None
    try:
        data = S.u64v(class_va + 32) & 0xfffffffff  # class_ro_t ptr (chained rebase raw)
        name_ptr = S.u64v(data + 24) & 0xfffffffff
        return S.cstrv(name_ptr)
    except Exception:
        return None

classref_name = {}
cr = sec("__DATA", "__objc_classrefs")
for i in range(cr["size"]//8):
    va = cr["addr"] + i*8
    kind, val = S.chained(va)
    if kind == "rebase":
        classref_name[va] = class_name_at(val)

# ---------- cfstrings ----------
cfstr = {}
cf = sec("__DATA_CONST", "__cfstring")
for i in range(cf["size"]//32):
    va = cf["addr"] + i*32
    sptr = S.u64v(va + 16) & 0xfffffffff
    slen = S.u64v(va + 24)
    try:
        cfstr[va] = S.read(sptr, slen).decode("utf-8", "replace")
    except Exception:
        pass

# ---------- objc stubs ----------
objc_stub_sel = {}
ob = sec("__TEXT", "__objc_stubs")
md0 = Cs(CS_ARCH_ARM64, CS_MODE_LITTLE_ENDIAN); md0.detail = True
for i in range(ob["size"]//32):
    va = ob["addr"] + i*32
    code = S.read(va, 32)
    sel = None
    for ins in md0.disasm(code, va):
        if ins.mnemonic == "ldr" and len(ins.operands) == 2 and ins.operands[1].type == 3:  # mem
            slot = ins.operands[1].mem.base and (ins.reg_name(ins.operands[1].mem.base))
            # resolve via previously seen adrp is overkill: stub layout is fixed:
            break
    # fixed layout: [0]=adrp x1, [4]=ldr x1,[x1,#off] -> selref slot
    w0, w1 = struct.unpack_from("<II", code, 0)
    if (w0 & 0x9f000000) == 0x90000000 and (w1 & 0xffc00000) == 0xf9400000:
        page = (va & ~0xfff) + (((w0 >> 5) & 0x7ffff) - (0x80000 if (w0 >> 5) & 0x40000 else 0)) * 4096 if False else None
        # adrp imm: signed 21-bit from bits [30:29] and [23:5]
        immlo = (w0 >> 29) & 0x3; immhi = (w0 >> 5) & 0x7ffff
        imm = (immhi << 2) | immlo
        if imm & 0x100000: imm -= 0x200000
        page = (va & ~0xfff) + (imm << 12)
        off12 = ((w1 >> 10) & 0xfff) * 8
        slot = page + off12
        if slot in selref_name: sel = selref_name[slot]
    objc_stub_sel[va] = sel

# ---------- function table ----------
objc = json.load(open("/home/hatch/workspace/omnicar-re/metadata/raw/OmniCarAppBridge/objc.json"))
imp_owner = {}
def collect_methods(node):
    pass
# objc.json structure probe happens in main; fallback: parse objc_dump.txt
import re
dump = open("/home/hatch/workspace/omnicar-re/metadata/raw/OmniCarAppBridge/objc_dump.txt").read()
arm64_part = dump.split("// slice: arm64e")[0]
cur_cls = None; cur_meta = False
for line in arm64_part.splitlines():
    m = re.match(r"@interface (\w+)", line)
    if m: cur_cls = m.group(1); cur_meta = False; continue
    m = re.search(r"// imp (\d+)\s*$", line)
    if m and cur_cls:
        sel = line.split(";")[0]
        sel = sel[sel.index(") ")+2:] if ") " in sel else sel
        imp_owner[int(m.group(1))] = ("+" if line.strip().startswith("+") else "-") + "[%s %s]" % (cur_cls, sel.strip())
for name, val in S.symbols.items():
    imp_owner.setdefault(val, "sym:" + name)

FUNCS = sorted(S.func_starts)
def func_end(start):
    i = FUNCS.index(start)
    return FUNCS[i+1] if i+1 < len(FUNCS) else sec("__TEXT", "__text")["addr"] + sec("__TEXT", "__text")["size"]

# ---------- disassembly ----------
md = Cs(CS_ARCH_ARM64, CS_MODE_LITTLE_ENDIAN); md.detail = True

def annotate(insns):
    """Yield (insn, note) resolving adrp chains and call targets."""
    regs = {}
    out = []
    for ins in insns:
        note = ""
        m = ins.mnemonic
        if m == "adrp":
            regs[ins.operands[0].reg] = ins.operands[1].imm
        elif m == "add" and len(ins.operands) == 3 and ins.operands[1].type == 1 and ins.operands[2].type == 2:
            base = regs.get(ins.operands[1].reg)
            if isinstance(base, int):
                tgt = base + ins.operands[2].imm
                regs[ins.operands[0].reg] = tgt
                note = literal_note(tgt)
        elif m == "ldr" and len(ins.operands) == 2 and ins.operands[1].type == 3:
            base = regs.get(ins.operands[1].mem.base)
            if isinstance(base, int):
                slot = base + ins.operands[1].mem.disp
                note = slot_note(slot)
                if ins.operands[0].reg:
                    regs[ins.operands[0].reg] = ("slot", slot)
        elif m in ("bl", "b") and ins.operands and ins.operands[0].type == 2:
            t = ins.operands[0].imm
            note = call_note(t, m)
        elif m == "blr":
            pass
        out.append((ins, note))
    return out

def literal_note(tgt):
    segname = S.section_of(tgt)
    if tgt in cfstr: return ' = @"%s"' % cfstr[tgt][:80]
    if segname and segname[1] == "__cstring":
        return ' ; "%s"' % S.cstrv(tgt)[:100]
    if segname and segname[1] == "__objc_methname":
        return ' ; sel "%s"' % S.cstrv(tgt)[:80]
    return ""

def slot_note(slot):
    if slot in got_name: return " ; -> %s" % got_name[slot]
    kind, val = S.chained(slot) if S.section_of(slot) else (None, None)
    if slot in selref_name: return " ; selref @%s" % selref_name[slot]
    if slot in classref_name: return " ; class %s" % classref_name[slot]
    if kind == "bind": return " ; bind %s" % val
    if kind == "rebase":
        nm = class_name_at(val)
        if nm: return " ; -> class %s" % nm
        sc = S.section_of(val)
        if sc and sc[1] in ("__cstring", "__objc_methname"): return ' ; -> "%s"' % S.cstrv(val)[:80]
        return " ; -> %s" % hex(val)
    return ""

def call_note(t, m):
    if t in stub_name: return " ; call %s" % stub_name[t]
    if t in objc_stub_sel: return " ; objc_msgSend sel=%s" % objc_stub_sel[t]
    if t in imp_owner: return " ; call %s" % imp_owner[t]
    sc = S.section_of(t)
    if sc and sc[1] == "__text": return " ; call sub_%x" % t
    return ""

def disasm_func(start):
    end = func_end(start)
    code = S.read(start, end - start)
    insns = list(md.disasm(code, start))
    lines = []
    owner = imp_owner.get(start, "sub_%x" % start)
    lines.append("=== %s @ %s (size %d) ===" % (owner, hex(start), end-start))
    for ins, note in annotate(insns):
        lines.append("%08x  %-8s %s%s" % (ins.address, ins.mnemonic, ins.op_str, note))
    return "\n".join(lines)

if __name__ == "__main__":
    print("stubs resolved:", len(stub_name), "got:", len(got_name), "objc stubs:", len(objc_stub_sel),
          "selrefs:", len(selref_name), "cfstrings:", len(cfstr), "classrefs:", len(classref_name))
    print("sample objc stubs:", list(objc_stub_sel.items())[:5])
    print("sample classrefs:", list(classref_name.items())[:5])
    print("funcs:", len(FUNCS), "imps mapped:", len(imp_owner))
    if len(sys.argv) > 1 and sys.argv[1] == "dump":
        with open("/home/hatch/workspace/omnicar-re/src/AppBridgeB/disasm/full_arm64.txt", "w") as f:
            for fn in FUNCS:
                f.write(disasm_func(fn) + "\n\n")
        print("wrote full_arm64.txt")
