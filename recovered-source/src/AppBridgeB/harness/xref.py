#!/usr/bin/env python3
"""Xref queries over the annotated disassembly model.
Tracks simple register constants (adrp+add -> literal addr; ldr -> slot) per
function so call sites of notify_* / MSHook* can be paired with their
string/class/selector arguments."""
import struct, sys
from capstone import Cs, CS_ARCH_ARM64, CS_MODE_LITTLE_ENDIAN
import macho
import disasm as DZ

S = DZ.S
md = Cs(CS_ARCH_ARM64, CS_MODE_LITTLE_ENDIAN); md.detail = True

REGN = {}
def rn(i, r): return i.reg_name(r)

def func_insns(start):
    end = DZ.func_end(start)
    return list(md.disasm(S.read(start, end-start), start))

def track(start):
    """Return list of events: (addr, kind, payload). kinds: call, setreg."""
    evts = []
    regs = {}   # reg -> ('lit', addr) | ('slot', addr) | ('cfstr', str) etc.
    for ins in func_insns(start):
        m = ins.mnemonic; ops = ins.operands
        if m == "adrp":
            regs[ops[0].reg] = ("lit", ops[1].imm)
        elif m == "add" and len(ops) == 3 and ops[1].type == 1 and ops[2].type == 2:
            b = regs.get(ops[1].reg)
            if b and b[0] == "lit":
                regs[ops[0].reg] = ("lit", b[1] + ops[2].imm)
        elif m == "mov" and len(ops) == 2 and ops[1].type == 1:
            if ops[1].reg in regs: regs[ops[0].reg] = regs[ops[1].reg]
            else: regs.pop(ops[0].reg, None)
        elif m == "ldr" and len(ops) == 2 and ops[1].type == 3:
            b = regs.get(ops[1].mem.base)
            if b and b[0] == "lit":
                slot = b[1] + ops[1].mem.disp
                regs[ops[0].reg] = ("slot", slot)
        elif m in ("bl", "b") and ops and ops[0].type == 2:
            t = ops[0].imm
            name = DZ.stub_name.get(t) or (("objc:" + str(DZ.objc_stub_sel.get(t))) if t in DZ.objc_stub_sel else None) or DZ.imp_owner.get(t) or ("sub_%x" % t)
            snap = {}
            for r in range(19):  # x0..x18 by capstone reg id mapping below
                pass
            # snapshot x0..x7 by name
            snap = {}
            for regname in ("x0","x1","x2","x3","x4","x5","x6","x7"):
                # find reg id via a probe instruction is messy; regs dict is keyed by id.
                snap[regname] = None
            evts.append((ins.address, "call", (name, t, dict(regs))))
            if m == "b":
                regs.clear()
        elif m == "ret":
            regs.clear()
    return evts

# capstone reg ids for x0..x7: use ARM64_REG_X0 + i
from capstone.arm64 import *
XREGS = [globals()["ARM64_REG_X%d" % i] for i in range(8)]
WREGS = [globals()["ARM64_REG_W%d" % i] for i in range(8)]

def track2(start):
    evts = []
    regs = {}
    for ins in func_insns(start):
        m = ins.mnemonic; ops = ins.operands
        if m == "adrp":
            regs[ops[0].reg] = ("lit", ops[1].imm)
        elif m == "add" and len(ops) == 3 and ops[1].type == 1 and ops[2].type == 2:
            b = regs.get(ops[1].reg)
            if b and b[0] == "lit": regs[ops[0].reg] = ("lit", b[1] + ops[2].imm)
            else: regs.pop(ops[0].reg, None)
        elif m == "mov" and len(ops) == 2 and ops[1].type == 1:
            if ops[1].reg in regs: regs[ops[0].reg] = regs[ops[1].reg]
            else: regs.pop(ops[0].reg, None)
        elif m == "ldr" and len(ops) == 2 and ops[1].type == 3:
            b = regs.get(ops[1].mem.base)
            if b and b[0] == "lit": regs[ops[0].reg] = ("slot", b[1] + ops[1].mem.disp)
            else: regs.pop(ops[0].reg, None)
        elif m in ("bl", "b") and ops and ops[0].type == 2:
            t = ops[0].imm
            name = DZ.stub_name.get(t) or (("objc:" + str(DZ.objc_stub_sel.get(t))) if t in DZ.objc_stub_sel else None) or DZ.imp_owner.get(t) or ("sub_%x" % t)
            snap = {}
            for i, xr in enumerate(XREGS):
                v = regs.get(xr)
                if v: snap["x%d" % i] = v
            evts.append((ins.address, name, snap, regs))
            if m == "b": break
    return evts

def resolve(v):
    if v is None: return None
    kind, addr = v
    if kind == "lit":
        if addr in DZ.cfstr: return '@"%s"' % DZ.cfstr[addr]
        sc = S.section_of(addr)
        if sc and sc[1] in ("__cstring", "__objc_methname"): return '"%s"' % S.cstrv(addr)
        if addr in DZ.FUNCS or addr in DZ.imp_owner: return DZ.imp_owner.get(addr, "sub_%x" % addr)
        return hex(addr)
    if kind == "slot":
        if addr in DZ.got_name: return "got:" + DZ.got_name[addr]
        if addr in DZ.selref_name: return "sel:" + DZ.selref_name[addr]
        if addr in DZ.classref_name: return "class:" + str(DZ.classref_name[addr])
        return "slot:" + hex(addr)
    return str(v)

TARGETS = ["_notify_set_state", "_notify_get_state", "_notify_post", "_notify_register_dispatch",
           "_notify_register_check", "_MSHookMessageEx", "_MSHookFunction", "_dispatch_after",
           "_class_addMethod", "_objc_allocateClassPair"]

if __name__ == "__main__":
    mode = sys.argv[1] if len(sys.argv) > 1 else "notify"
    for fn in DZ.FUNCS:
        owner = DZ.imp_owner.get(fn, "sub_%x" % fn)
        for addr, name, snap, regs in track2(fn):
            base = name.lstrip("_") if name else ""
            if any(name == t or name == t.lstrip("_") for t in TARGETS):
                args = {k: resolve(v) for k, v in snap.items()}
                print("%s @%s in %s : %s %s" % (hex(addr), "", owner, name, args))
