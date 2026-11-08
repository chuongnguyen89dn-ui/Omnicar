#!/usr/bin/env python3
"""condense.py <file.asm> <funcname-substr> — print one function's disasm with
ARC/stack noise stripped (retain/release/autorelease, frame setup, canary)."""
import re
import sys

NOISE = re.compile(
    r"CALL _objc_(retain|release|autorelease|autoreleaseReturnValue|retainAutoreleasedReturnValue|retainAutorelease|storeStrong|objc_retainBlock)$"
    r"|mov\s+x29, x29"
    r"|stack_chk"
    r"|stp\s+x29, x30|add\s+x29, sp|ldp\s+x29, x30"
)


def main():
    path, pat = sys.argv[1], sys.argv[2]
    out = []
    on = False
    for line in open(path):
        if line.startswith("=== "):
            on = pat in line
            if on:
                out.append(line.rstrip())
            continue
        if on:
            if line.strip() == "":
                break
            if NOISE.search(line):
                continue
            out.append(line.rstrip())
    print("\n".join(out))


if __name__ == "__main__":
    main()
