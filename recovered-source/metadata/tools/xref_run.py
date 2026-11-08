#!/usr/bin/env python3
"""xref_run.py - run the xref analysis over one binary.

Usage:
  xref_run.py <Name> <path-to-binary> <out.json> [--disasm <annotated.txt>]

The analysis is a linear abstract-interpretation sweep of __text:
registers carry abstract values (concrete address / immediate / resolved
semantic value / call-return / unknown). At every bl/blr the argument
registers x0..x3 are snapshotted (converted to the JSON value model of
xref.py) and the call target is classified: imported stub, ObjC message
stub (selector recovered), internal function, indirect, or unresolved.
"""
import json
import sys

sys.path.insert(0, __file__.rsplit("/", 1)[0])
from xref import Bin, reg_name  # noqa: E402
from capstone import Cs, CS_ARCH_ARM64, CS_MODE_LITTLE_ENDIAN  # noqa: E402
from capstone.arm64 import ARM64_OP_REG, ARM64_OP_IMM, ARM64_OP_MEM  # noqa: E402

UNKNOWN = ("unknown", None)
CALLER_SAVED = [f"x{i}" for i in range(19)] + ["x30"]


def to_json(bin_, val):
    """Convert an internal abstract value to the JSON value model."""
    if val is None or val[0] == "unknown":
        return {"t": "unknown"}
    kind, v = val
    if kind == "addr":
        return bin_.addr_value(v)
    if kind == "imm":
        return {"t": "imm", "v": v}
    if kind == "val":
        return v
    if kind == "callret":
        return {"t": "callret", "v": v}
    return {"t": "unknown"}


class FuncScan:
    def __init__(self, bin_):
        self.b = bin_
        self.calls = []
        self.insns = {}  # addr -> insn (whole __text)

    def load_text(self):
        md = Cs(CS_ARCH_ARM64, CS_MODE_LITTLE_ENDIAN)
        md.detail = True
        s, b = self.b._sec_bytes("__TEXT", "__text")
        self.text_range = (s["addr"], s["addr"] + s["size"])
        for ins in md.disasm(b, s["addr"]):
            self.insns[ins.address] = ins

    # ---------- one function ----------
    def scan_function(self, start, end):
        regs = {r: UNKNOWN for r in
                [f"x{i}" for i in range(31)] + ["sp"]}
        addr = start
        while addr < end:
            ins = self.insns.get(addr)
            if ins is None:
                addr += 4
                continue
            self.step(ins, regs, start, end)
            if ins.mnemonic == "ret":
                break
            addr += ins.size

    def _rd(self, ins):
        if ins.operands and ins.operands[0].type == ARM64_OP_REG:
            return reg_name(ins.reg_name(ins.operands[0].reg))
        return None

    def _set(self, regs, rd, val):
        if rd and rd != "xzr":
            regs[rd] = val

    def step(self, ins, regs, func_start, func_end):
        m = ins.mnemonic
        ops = ins.operands
        rd = self._rd(ins)

        if m == "adrp" and len(ops) == 2 and ops[1].type == ARM64_OP_IMM:
            self._set(regs, rd, ("addr", ops[1].imm))
            return
        if m == "adr" and len(ops) == 2 and ops[1].type == ARM64_OP_IMM:
            self._set(regs, rd, ("addr", ops[1].imm))
            return
        if m in ("add", "sub") and len(ops) == 3:
            rn = reg_name(ins.reg_name(ops[1].reg)) if ops[1].type == ARM64_OP_REG else None
            base = regs.get(rn, UNKNOWN) if rn else UNKNOWN
            if ops[2].type == ARM64_OP_IMM:
                delta = ops[2].imm if m == "add" else -ops[2].imm
                if base[0] == "addr":
                    self._set(regs, rd, ("addr", base[1] + delta))
                    return
                if base[0] == "imm":
                    self._set(regs, rd, ("imm", base[1] + delta))
                    return
            elif ops[2].type == ARM64_OP_REG:
                other = regs.get(reg_name(ins.reg_name(ops[2].reg)), UNKNOWN)
                if base[0] == "imm" and other[0] == "imm":
                    v = base[1] + other[1] if m == "add" else base[1] - other[1]
                    self._set(regs, rd, ("imm", v))
                    return
            self._set(regs, rd, UNKNOWN)
            return
        if m == "mov" and len(ops) == 2:
            if ops[1].type == ARM64_OP_REG:
                self._set(regs, rd, regs.get(reg_name(ins.reg_name(ops[1].reg)), UNKNOWN))
            elif ops[1].type == ARM64_OP_IMM:
                self._set(regs, rd, ("imm", ops[1].imm))
            return
        if m in ("movz", "movk", "movn") and len(ops) == 2 and ops[1].type == ARM64_OP_IMM:
            shift = getattr(ops[1], "shift", None)
            sh = shift.value if shift is not None and shift.type else 0
            if m == "movz":
                self._set(regs, rd, ("imm", (ops[1].imm << sh) & (1 << 64) - 1))
            elif m == "movn":
                self._set(regs, rd, ("imm", (~(ops[1].imm << sh)) & (1 << 64) - 1))
            else:
                cur = regs.get(rd, UNKNOWN)
                if cur[0] == "imm":
                    v = (cur[1] & ~(0xFFFF << sh)) | ((ops[1].imm & 0xFFFF) << sh)
                    self._set(regs, rd, ("imm", v))
                else:
                    self._set(regs, rd, UNKNOWN)
            return
        if m in ("ldr", "ldur") and len(ops) == 2:
            self._set(regs, rd, self._load(ins, regs))
            return
        if m == "ldp" and len(ops) == 3:
            v = self._load(ins, regs)
            self._set(regs, rd, v)
            rd2 = reg_name(ins.reg_name(ops[1].reg))
            self._set(regs, rd2, UNKNOWN)
            return
        if m == "bl" and len(ops) == 1 and ops[0].type == ARM64_OP_IMM:
            self._call_direct(ins, regs, func_start, ops[0].imm)
            return
        if m == "b" and len(ops) == 1 and ops[0].type == ARM64_OP_IMM:
            # Unconditional branch: a tail call when the target is a stub
            # or another function outside this function's extent.
            t = ops[0].imm
            if not (func_start <= t < func_end) and (
                    t in self.b.stubs or t in self.b.objc_stubs
                    or t in self.b.func_set):
                self._call_direct(ins, regs, func_start, t, tail=True)
            return
        if m == "blr" and len(ops) == 1 and ops[0].type == ARM64_OP_REG:
            rn = reg_name(ins.reg_name(ops[0].reg))
            self._call_indirect(ins, regs, func_start, regs.get(rn, UNKNOWN))
            return
        if m in ("ret", "br", "cbz", "cbnz", "tbz", "tbnz") or m.startswith("b."):
            return
        # stores / compares / anything else: if it writes a register we do
        # not model, mark it unknown (conservative).
        if ops and ops[0].type == ARM64_OP_REG and m not in (
                "str", "stp", "stur", "cmp", "cmn", "tst", "ccmp", "ccmn",
                "strb", "strh", "sturb", "sturh"):
            if not m.startswith("st"):
                self._set(regs, rd, UNKNOWN)

    def _load(self, ins, regs):
        """Abstract value produced by a load instruction."""
        b = self.b
        ops = ins.operands
        if ops[1].type == ARM64_OP_IMM:  # literal load
            return ("val", b.load_value(ops[1].imm))
        if ops[1].type == ARM64_OP_MEM:
            mem = ops[1].mem
            base_reg = reg_name(ins.reg_name(mem.base))
            base = regs.get(base_reg, UNKNOWN)
            if base[0] == "addr":
                return ("val", b.load_value(base[1] + mem.disp))
            return UNKNOWN
        return UNKNOWN

    # ---------- calls ----------
    def _snapshot_args(self, regs):
        return {f"x{i}": to_json(self.b, regs.get(f"x{i}", UNKNOWN))
                for i in range(6)}

    def _clobber_after_call(self, regs, x0val):
        for r in CALLER_SAVED:
            regs[r] = UNKNOWN
        regs["x0"] = x0val

    def _call_direct(self, ins, regs, func_start, target, tail=False):
        b = self.b
        args = self._snapshot_args(regs)
        rec = {"site": ins.address, "func": func_start,
               "func_name": b.func_name(func_start), "args": args}
        if tail:
            rec["tail"] = True
        x0ret = ("callret", f"sub_{target:x}")
        if target in b.stubs:
            name = b.stubs[target]
            rec.update({"kind": "import", "target": name})
            x0ret = self._producer_value(name, args)
        elif target in b.objc_stubs:
            info = b.objc_stubs[target]
            rec.update({"kind": "objc_msgsend", "target": info["target"],
                        "sel": info["sel"]})
            x0ret = ("callret", f"[{info['sel']}]")
        elif target in b.func_set:
            rec.update({"kind": "internal", "target": b.func_name(target),
                        "target_addr": target})
            x0ret = ("callret", b.func_name(target))
        else:
            rec.update({"kind": "unresolved", "target_addr": target})
        self.calls.append(rec)
        self._clobber_after_call(regs, x0ret)

    def _call_indirect(self, ins, regs, func_start, val):
        b = self.b
        args = self._snapshot_args(regs)
        rec = {"site": ins.address, "func": func_start,
               "func_name": b.func_name(func_start), "args": args}
        desc = to_json(b, val)
        if desc.get("t") == "importptr":
            rec.update({"kind": "import_indirect", "target": desc["v"]})
        elif desc.get("t") == "addr" and desc.get("v") in b.func_set:
            rec.update({"kind": "internal_indirect",
                        "target": b.func_name(desc["v"]),
                        "target_addr": desc["v"]})
        else:
            rec.update({"kind": "indirect_unresolved", "via": desc})
        self.calls.append(rec)
        self._clobber_after_call(regs, ("callret", "indirect"))

    def _producer_value(self, name, args):
        """Special-case call results whose value we can name."""
        if name in ("_objc_getClass", "_NSClassFromString", "_objc_getMetaClass"):
            a0 = args.get("x0") or {}
            if a0.get("t") in ("cstr", "cfstr") and a0.get("v"):
                cls = a0["v"]
                if name == "_objc_getMetaClass":
                    cls += " (metaclass)"
                return ("val", {"t": "class", "v": cls})
        return ("callret", name)


def analyze(path, name):
    b = Bin(path, name)
    fs = FuncScan(b)
    fs.load_text()
    lo, hi = fs.text_range
    starts = [s for s in b.func_starts if lo <= s < hi]
    for i, s in enumerate(starts):
        end = starts[i + 1] if i + 1 < len(starts) else hi
        fs.scan_function(s, end)
    addrs = set()
    for c in fs.calls:
        for v in c["args"].values():
            if isinstance(v, dict) and v.get("t") == "addr":
                addrs.add(v["v"])
    blocks = {}
    for a in sorted(addrs):
        inv = b.block_invoke(a)
        if inv is not None and inv in b.func_set:
            blocks[a] = inv
    out = {
        "binary": name,
        "path": path,
        "functions": [{"addr": s, "name": b.func_name(s)} for s in b.func_starts],
        "cfstrings": {str(k): v for k, v in sorted(b.cfstrings.items())},
        "blocks": blocks,
        "calls": fs.calls,
        "stats": {
            "func_starts": len(b.func_starts),
            "stubs": len(b.stubs),
            "objc_stubs": len(b.objc_stubs),
            "selrefs": len(b.selrefs),
            "classrefs": len(b.classrefs),
            "cfstrings": len(b.cfstrings),
            "calls": len(fs.calls),
            "calibration": b.calibration,
            "pointer_formats": {str(k): v for k, v in b.sl.seg_ptr_format.items()},
        },
    }
    return b, out


def write_disasm(b, outpath):
    """Annotated full __text disassembly (used for the app)."""
    md = Cs(CS_ARCH_ARM64, CS_MODE_LITTLE_ENDIAN)
    md.detail = True
    s, data = b._sec_bytes("__TEXT", "__text")
    starts = set(b.func_starts)
    with open(outpath, "w") as f:
        for ins in md.disasm(data, s["addr"]):
            if ins.address in starts:
                f.write(f"\n; ===== {b.func_name(ins.address)} @ {ins.address:#x} =====\n")
            note = ""
            if ins.mnemonic == "bl" and ins.operands and ins.operands[0].type == ARM64_OP_IMM:
                t = ins.operands[0].imm
                if t in b.stubs:
                    note = f" ; -> import {b.stubs[t]}"
                elif t in b.objc_stubs:
                    info = b.objc_stubs[t]
                    note = f" ; -> objc_msgSend [{info['sel']}]"
                elif t in b.func_set:
                    note = f" ; -> {b.func_name(t)}"
            elif ins.mnemonic == "adrp":
                note = f" ; page {ins.operands[1].imm:#x}"
            f.write(f"{ins.address:#010x}: {ins.mnemonic:8s} {ins.op_str}{note}\n")
        f.write("\n; ===== __objc_stubs =====\n")
        for a in sorted(b.objc_stubs):
            f.write(f"{a:#x}: sel={b.objc_stubs[a]['sel']} target={b.objc_stubs[a]['target']}\n")
        f.write("\n; ===== __stubs =====\n")
        for a in sorted(b.stubs):
            f.write(f"{a:#x}: {b.stubs[a]}\n")


def main():
    name, path, outpath = sys.argv[1], sys.argv[2], sys.argv[3]
    disasm_path = None
    if "--disasm" in sys.argv:
        disasm_path = sys.argv[sys.argv.index("--disasm") + 1]
    b, out = analyze(path, name)
    with open(outpath, "w") as f:
        json.dump(out, f)
    print(f"{name}: {out['stats']}")
    if disasm_path:
        write_disasm(b, disasm_path)


if __name__ == "__main__":
    main()
