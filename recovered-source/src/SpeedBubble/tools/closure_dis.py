#!/usr/bin/env python3
"""closure_dis.py — fresh annotated disassembler for the SpeedBubble scan
helpers (0xa0b8..0xc018 range), written for the wave-3 closure pass.
All name resolution goes through verify/macho_truth.py (LC_DYSYMTAB /
chained-fixups ground truth); no other agent's annotation is consulted.

Output: one .txt per function into ../disasm/closure/.
"""
import os, sys, struct
sys.path.insert(0, os.path.expanduser("~/workspace/omnicar-re/verify"))
sys.path.insert(0, os.path.expanduser("~/workspace/omnicar-re/metadata/tools"))
from macho_truth import MachO
from capstone import Cs, CS_ARCH_ARM64, CS_MODE_LITTLE_ENDIAN
from capstone.arm64_const import ARM64_OP_IMM, ARM64_OP_MEM, ARM64_OP_REG

BIN = os.path.expanduser(
    "~/workspace/omnicar-re/payload/var/jb/Library/MobileSubstrate/"
    "DynamicLibraries/OmniCarSpeedBubble.dylib")
OUT = os.path.expanduser("~/workspace/omnicar-re/src/SpeedBubble/disasm/closure")
os.makedirs(OUT, exist_ok=True)

m = MachO(BIN)
md = Cs(CS_ARCH_ARM64, CS_MODE_LITTLE_ENDIAN)
md.detail = True

# Known globals (SBSourceGlobals.h, wave-2.5 verified addresses)
GLOBALS = {
    0x436a8: "SPPLastPublishedSpeed", 0x436ac: "SPPLastPublishedLimit",
    0x436b0: "SPPFlutterLimit", 0x436b4: "SPPScanLimit",
    0x436b8: "SPPScanWasActive", 0x436bc: "SPPScanSpeed",
    0x437d0: "SPPFlutterLimitKey", 0x437d8: "SPPSpeedGPSSharedInstance",
    0x437e8: "SPPCachedSpeedView(weak)", 0x437f0: "SPPCachedLimitView",
    0x437f8: "SPPCachedAuxView(weak)",
    0x43800: "SPPHostIndex", 0x43808: "SPPOrigCLStart",
    0x43810: "SPPOrigCLStop", 0x43818: "SPPSpeedNotifyToken",
    0x43820: "SPPFlutterLimitTime", 0x43828: "SPPScanLimitTime",
    0x43830: "SPPLocationNotifyToken", 0x43838: "SPPLastLocationPubTime",
    0x43840: "SPPSourceNotifyToken", 0x43848: "SPPOrigFlutterTaskQueue",
    0x43850: "SPPOrigFlutterPlain", 0x43858: "SPPWatchedChannelExclusions",
    0x43868: "SPPSeenChannelMethods", 0x43870: "SPPOrigSwitchControlRunning",
    0x43878: "SPPLastFullScanTime", 0x43880: "SPPScanSpeedTime",
    0x43888: "SPPAXDeadline", 0x43890: "SPPAXOverran",
    0x43898: "SPPAXLastBudgetLogTime",
}

CFSTR_SEC = m.sec("__cfstring")
CSTR_SECS = [s for s in m.sections if s["name"] in ("__cstring", "__objc_methname",
                                                    "__objc_classname", "__objc_methtype")]
CONST_SEC = m.sec("__const")
FUNC_STARTS = set(m.func_starts)


def in_sec(va, s):
    return s is not None and s["addr"] <= va < s["addr"] + s["size"]


def describe_va(va):
    """Human description of a code/data address, or None."""
    if va in GLOBALS:
        return "global " + GLOBALS[va]
    kind, name = m.slot_truth(va)
    if kind == "sel" and name:
        return "selref @%s" % name
    if kind == "class" and name:
        return "classref %s" % name
    if kind == "got-sym" and name:
        return "got %s" % name
    if in_sec(va, CFSTR_SEC):
        try:
            raw = m.read_u64(va + 16)
            k, v = m.decode_ptr(raw)
            if k == "rebase":
                return '@"%s"' % m.cstr(v)
        except Exception:
            pass
        return "__cfstring"
    for s in CSTR_SECS:
        if in_sec(va, s):
            try:
                return '"%s"' % m.cstr(va)
            except Exception:
                return None
    if in_sec(va, CONST_SEC):
        try:
            off = m.va_off(va)
            dbl = struct.unpack_from("<d", m.data, off)[0]
            flt = struct.unpack_from("<f", m.data, off)[0]
            return "__const double=%r float=%r" % (dbl, flt)
        except Exception:
            return "__const"
    sec = None
    for s in m.sections:
        if s["addr"] <= va < s["addr"] + s["size"]:
            sec = s
            break
    if va in FUNC_STARTS:
        return "sub_%x (function start)" % va
    if sec is not None and sec["name"] == "__text":
        return "sub_%x?" % va
    return None


def dump(start, end, name):
    path = os.path.join(OUT, "%08x_%s.txt" % (start, name))
    code_off = m.va_off(start)
    code = m.data[code_off:code_off + (end - start)]
    lines = ["; ==== %s @0x%x..0x%x (%d bytes) — closure pass dump ===="
             % (name, start, end, end - start)]
    adrp_val = {}   # reg -> page base
    for ins in md.disasm(code, start):
        note = ""
        ops = ins.operands
        if ins.mnemonic == "adrp" and len(ops) == 2 and ops[1].type == ARM64_OP_IMM:
            adrp_val[ins.reg_name(ops[0].reg)] = ops[1].imm
        elif ins.mnemonic in ("add", "ldr", "str", "ldrb", "strb", "ldur", "stur") and ops:
            base = None
            imm = None
            dst = None
            if ins.mnemonic == "add" and len(ops) == 3 and ops[2].type == ARM64_OP_IMM:
                rn = ins.reg_name(ops[1].reg)
                if rn in adrp_val:
                    base = adrp_val[rn]
                    imm = ops[2].imm
                    dst = ins.reg_name(ops[0].reg)
            elif ops[-1].type == ARM64_OP_MEM:
                rn = ins.reg_name(ops[-1].mem.base)
                if rn in adrp_val:
                    base = adrp_val[rn]
                    imm = ops[-1].mem.disp
            if base is not None and imm is not None:
                va = base + imm
                d = describe_va(va)
                if d:
                    note = "; [0x%x] %s" % (va, d)
                if dst:
                    adrp_val[dst] = va
        if ins.mnemonic in ("bl", "b") and ops and ops[0].type == ARM64_OP_IMM:
            t = ops[0].imm
            if start <= t < end and ins.mnemonic == "b":
                note = "; -> loc_%x" % t
            else:
                kind, nm = m.call_truth(t)
                if kind == "stub":
                    note = "; call %s" % nm
                elif kind == "selstub":
                    note = "; objc_msgSend$%s" % nm
                elif kind == "defined":
                    note = "; call %s" % nm
                elif t in FUNC_STARTS:
                    note = "; call sub_%x" % t
                else:
                    note = "; -> 0x%x" % t
        if ins.mnemonic in ("b.eq", "b.ne", "b.gt", "b.lt", "b.ge", "b.le",
                            "b.hi", "b.lo", "b.hs", "b.ls", "cbz", "cbnz",
                            "tbz", "tbnz") and ops and ops[-1].type == ARM64_OP_IMM:
            note = "; -> loc_%x" % ops[-1].imm
        lines.append("%08x  %-8s %-46s %s" % (ins.address, ins.mnemonic,
                                              ins.op_str, note))
    open(path, "w").write("\n".join(lines) + "\n")
    return path, len(lines) - 1


FUNCS = [
    (0xa0b8, 0xa2c4, "sub_a0b8_SPPCollectViews"),
    (0xa2c4, 0xa530, "sub_a2c4_SPPCandidatesSummary"),
    (0xa530, 0xa938, "sub_a530_SPPScanPostCommit"),
    (0xa938, 0xaa4c, "sub_a938_SPPFindSignContainer"),
    (0xaa4c, 0xae3c, "sub_aa4c_SPPColorView"),
    (0xae3c, 0xafb4, "sub_ae3c_block"),
    (0xafb4, 0xb0ec, "sub_afb4_SPPExtractFromCachedRoot"),
    (0xb0ec, 0xb214, "sub_b0ec_SPPExtractFromCachedView"),
    (0xb214, 0xb4f0, "sub_b214_block"),
    (0xb4f0, 0xb720, "sub_b4f0_block"),
    (0xb720, 0xb878, "sub_b720_block"),
    (0xb878, 0xbf50, "sub_b878_SPPCollectAXElements"),
    (0xbf50, 0xc018, "sub_bf50_SPPAXTextIsCandidate"),
]

if __name__ == "__main__":
    for s, e, n in FUNCS:
        p, nlines = dump(s, e, n)
        print("%s: %d insns" % (os.path.basename(p), nlines))
