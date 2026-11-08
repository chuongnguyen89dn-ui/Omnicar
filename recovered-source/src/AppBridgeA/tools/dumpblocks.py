#!/usr/bin/env python3
import sys, os, json, struct
sys.path.insert(0, '.')
from abdis import *
OUT = os.path.expanduser("~/workspace/omnicar-re/src/AppBridgeA/disasm")
os.makedirs(OUT, exist_ok=True)

# enumerate block literals in __DATA_CONST __const + __DATA __const
invokes = {}
for seg in ("__DATA_CONST", "__DATA"):
    b, base = sect_bytes(seg, "__const")
    for i in range(0, len(b) - 31, 8):
        va = base + i
        raw0 = sl.read_u64(va)
        if raw0 is None: continue
        k0, v0 = decode2(raw0)
        if not (k0 == "bind" and v0 == "__NSConcreteGlobalBlock"): continue
        flags = sl.read_u32(va + 8)
        if flags is None or (flags & 0xFFFF0000) not in (0x50000000, 0x40000000, 0x10000000, 0x30000000, 0x20000000, 0x60000000, 0x70000000, 0xC0000000, 0xD0000000):
            # accept common global-block flag words
            if flags not in (0x50000000, 0xD0000000, 0xC0000000, 0x30000000):
                continue
        k2, invoke = decode2(sl.read_u64(va + 16))
        k3, desc = decode2(sl.read_u64(va + 24))
        if k2 != "ptr" or k3 != "ptr": continue
        if not (TEXT_ADDR <= invoke < TEXT_ADDR + TEXT_SIZE): continue
        sig = None
        if desc:
            dk, dv = decode2(sl.read_u64(desc + 16)) if sl.read_u64(desc + 16) else (None, None)
            # descriptor: [reserved][size][copy?][dispose?][signature]; signature offset varies
            for off in (16, 24, 32):
                kk, vv = decode2(sl.read_u64(desc + off) or 0)
                if kk == "ptr":
                    s = sl.read_cstr(vv)
                    if s and "@" in s and len(s) < 80:
                        sig = s; break
        invokes[invoke] = {"literal": va, "desc": desc, "sig": sig, "flags": flags}
print(f"{len(invokes)} block invokes from __const literals")

allstarts = sorted(set(FUNC_STARTS) | set(invokes) | set(INITFUNCS) |
                   {v for v in LABELS if TEXT_ADDR <= v < TEXT_ADDR + TEXT_SIZE})
def end_of(start):
    nxt = [x for x in allstarts if x > start]
    return nxt[0] if nxt else start + 4

summary = {}
for inv, meta in sorted(invokes.items()):
    end = end_of(inv)
    txt, refs = disasm_func(inv, end)
    fn = os.path.join(OUT, f"blk_{inv:06x}.s")
    with open(fn, "w") as f:
        f.write(f"; block literal @{meta['literal']:#x} desc @{meta['desc']:#x} sig={meta['sig']} flags={meta['flags']:#x}\n")
        f.write(txt + "\n")
    summary[hex(inv)] = {"literal": hex(meta["literal"]), "sig": meta["sig"], **refs}
for c in INITFUNCS:
    end = end_of(c)
    txt, refs = disasm_func(c, end)
    fn = os.path.join(OUT, f"ctor_{c:06x}.s")
    with open(fn, "w") as f:
        f.write(txt + "\n")
    summary[hex(c)] = {"ctor": True, **refs}
json.dump(summary, open(os.path.join(OUT, "blocks_summary.json"), "w"), indent=1)
print("wrote", len(invokes) + len(INITFUNCS), "files")
