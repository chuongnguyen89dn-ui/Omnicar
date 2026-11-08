#!/usr/bin/env python3
"""dump_consts.py - decode constant ObjC objects in OmniCarPrefs:
__objc_arrayobj / __objc_dictobj / __objc_intobj / __objc_doubleobj entries,
plus __cfstring entries that decode to non-ASCII or long strings (skipped here).
Layout (arm64, lld): arrayobj = {isa, count, objs[]}; dictobj = {isa, count, keys[], values[]}?
Actual layout verified empirically against known arrays (OMCProfileKeys).
"""
import json
import sys
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parents[3] / "metadata" / "tools"))
sys.path.insert(0, str(Path(__file__).resolve().parent))
from disasm import Image, sec_range, DEFAULT_BIN  # noqa: E402


def obj_desc(img, va, depth=0):
    sl = img.slice
    if va in img.cfstrings:
        return img.cfstrings[va]
    kind, isa = img.decode(va)
    # intobj: {isa, value} where isa binds to NSConstantIntegerNumber classref target
    raw = sl.read(va, 32)
    if raw is None:
        return f"<{va:#x}>"
    return None


def main():
    img = Image(str(DEFAULT_BIN))
    sl = img.slice
    out = {}
    # arrays: scan __objc_arrayobj region: entries are variable-size; walk by
    # finding isa pointers to NSArray class. Simpler: parse sequentially:
    # header {isa(8), count(8)} then count pointers.
    for seg, nm, kindname in (("__DATA_CONST", "__objc_arrayobj", "array"),
                              ("__DATA_CONST", "__objc_dictobj", "dict")):
        r = sec_range(sl, seg, nm)
        if not r:
            continue
        va = r[0]
        items = []
        while va < r[1]:
            k, isa = img.decode(va)
            count = sl.read_u64(va + 8)
            if count is None or count > 4096:
                break
            if kindname == "array":
                vals = []
                ok = True
                for i in range(count):
                    kk, vv = img.decode(va + 16 + i * 8)
                    if kk == "ptr" and vv in img.cfstrings:
                        vals.append(img.cfstrings[vv])
                    elif kk == "ptr":
                        vals.append(f"<obj {vv:#x}>")
                    else:
                        vals.append(f"<{kk}:{vv}>")
                items.append({"va": va, "count": count, "values": vals})
                va += 16 + count * 8
            else:
                # dictobj layout in this image: {isa, count, key0..keyN-1, val0..valN-1}?
                # dump raw first count*2 pointers for manual reading
                ptrs = []
                for i in range(2 * count):
                    kk, vv = img.decode(va + 16 + i * 8)
                    if kk == "ptr" and vv in img.cfstrings:
                        ptrs.append(img.cfstrings[vv])
                    else:
                        ptrs.append(f"<{kk}:{vv}>")
                items.append({"va": va, "count": count, "raw": ptrs})
                va += 16 + 2 * count * 8
        out[nm] = items
    # intobj / doubleobj: fixed 16-byte entries {isa, value}
    for seg, nm, fmt in (("__DATA_CONST", "__objc_intobj", "int"),
                         ("__DATA_CONST", "__objc_doubleobj", "double")):
        r = sec_range(sl, seg, nm)
        if not r:
            continue
        import struct as st
        vals = []
        va = r[0]
        while va < r[1]:
            if fmt == "int":
                v = sl.read_u64(va + 8)
                vals.append({"va": va, "value": v})
                va += 16
            else:
                b = sl.read(va + 8, 8)
                v = st.unpack("<d", b)[0] if b else None
                vals.append({"va": va, "value": v})
                va += 16
        out[nm] = vals
    print(json.dumps(out, indent=1, ensure_ascii=False))


if __name__ == "__main__":
    main()
