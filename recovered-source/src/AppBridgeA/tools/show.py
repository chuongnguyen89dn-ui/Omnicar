#!/usr/bin/env python3
import sys
sys.path.insert(0, '.')
from abdis import disasm_func, FUNC_STARTS
def show(start, end=None):
    if end is None:
        nxt = [x for x in FUNC_STARTS if x > start]
        end = nxt[0] if nxt else start + 0x100
    txt, refs = disasm_func(start, end)
    print(txt)
    print("; REFS calls:", refs["calls"])
    print("; REFS strs:", refs["strings"])
    print("; REFS cfstrs:", [])
    print("; REFS sels:", refs["sels"])
    print("; REFS classes:", refs["classes"])
if __name__ == "__main__":
    for a in sys.argv[1:]:
        if '-' in a:
            s, e = a.split('-'); show(int(s, 16), int(e, 16))
        else:
            show(int(a, 16))
