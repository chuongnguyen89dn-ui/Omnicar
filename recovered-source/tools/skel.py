#!/usr/bin/env python3
"""skel.py <disasm.txt> - print only semantically loaded lines of a function:
calls, string/class/got annotations, block literals, and branch targets."""
import re, sys
for path in sys.argv[1:]:
    print(f"######## {path}")
    for line in open(path):
        line = line.rstrip("\n")
        if ";" in line and ("->" in line or "block_lit" in line or "@\"" in line
                            or ' "' in line or "class(" in line or "got(" in line
                            or "selref(" in line):
            print(line)
        elif re.search(r":\s+(b\.|cbz|cbnz|tbz|tbnz|blr|br)\s", line):
            print(line)
