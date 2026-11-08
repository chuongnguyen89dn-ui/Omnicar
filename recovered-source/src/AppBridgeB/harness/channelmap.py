#!/usr/bin/env python3
"""Per-function summary: cfstrings referenced, imports called, objc selectors
sent (via objc stubs), internal calls. Used to map Darwin channels to
producer/consumer functions and to find installers."""
import sys
from capstone import Cs, CS_ARCH_ARM64, CS_MODE_LITTLE_ENDIAN
import macho
import disasm as DZ
import xref as XR

S = DZ.S
md = Cs(CS_ARCH_ARM64, CS_MODE_LITTLE_ENDIAN); md.detail = True

def summarize(start):
    cf = set(); imports = set(); sels = set(); calls = set()
    regs = {}
    for ins in XR.func_insns(start):
        m = ins.mnemonic; ops = ins.operands
        if m == "adrp":
            regs[ops[0].reg] = ops[1].imm
        elif m == "add" and len(ops) == 3 and ops[1].type == 1 and ops[2].type == 2:
            b = regs.get(ops[1].reg)
            if isinstance(b, int):
                t = b + ops[2].imm
                regs[ops[0].reg] = t
                if t in DZ.cfstr: cf.add(DZ.cfstr[t])
                else:
                    sc = S.section_of(t)
                    if sc and sc[1] == "__cstring": cf.add("cstr:" + S.cstrv(t))
            else:
                regs.pop(ops[0].reg, None)
        elif m == "ldr" and len(ops) == 2 and ops[1].type == 3:
            b = regs.get(ops[1].mem.base)
            if isinstance(b, int):
                regs[ops[0].reg] = ("slot", b + ops[1].mem.disp)
            else:
                regs.pop(ops[0].reg, None)
        elif m == "mov" and len(ops) == 2 and ops[1].type == 1:
            if ops[1].reg in regs: regs[ops[0].reg] = regs[ops[1].reg]
            else: regs.pop(ops[0].reg, None)
        elif m in ("bl", "b") and ops and ops[0].type == 2:
            t = ops[0].imm
            if t in DZ.stub_name: imports.add(DZ.stub_name[t])
            elif t in DZ.objc_stub_sel: sels.add(DZ.objc_stub_sel[t])
            elif t in DZ.FUNCS or t in DZ.imp_owner: calls.add(DZ.imp_owner.get(t, "sub_%x" % t))
    return cf, imports, sels, calls

if __name__ == "__main__":
    mode = sys.argv[1] if len(sys.argv) > 1 else "channels"
    rows = {}
    for fn in DZ.FUNCS:
        rows[fn] = summarize(fn)
    if mode == "channels":
        chans = {}
        for fn, (cf, im, se, ca) in rows.items():
            for c in cf:
                if "appbridge" in c or "com.anlai" in c:
                    chans.setdefault(c, []).append((fn, im))
        for c in sorted(chans):
            print("###", c)
            for fn, im in chans[c]:
                rel = sorted(x for x in im if "notify" in x or "MSHook" in x or "dispatch_after" in x)
                print("   %-28s %s" % (DZ.imp_owner.get(fn, "sub_%x" % fn), rel))
    elif mode == "func":
        for fn in DZ.FUNCS:
            cf, im, se, ca = rows[fn]
            print("%-28s cf=%s" % (DZ.imp_owner.get(fn, "sub_%x" % fn), sorted(cf)))
