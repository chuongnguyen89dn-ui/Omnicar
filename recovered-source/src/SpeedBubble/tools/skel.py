#!/usr/bin/env python3
"""Print the semantic skeleton of disasm files: calls, string refs, fp/int constants."""
import re
import sys
import glob
import os

pat = re.compile(
    r"(bl\s+#0x[0-9a-f]+.*|@\"[^\"]*\"|; \"[^\"]*\"|fmov\s+d\d+, #|mov\s+[wx]\d+, #0x[0-9a-f]{3,}|"
    r"ldr\s+d\d+, \[x\d+, #0x[0-9a-f]+\].*double=[^ ]*|cmp\s+[wx]\d+, #|cmn\s|tbnz|tbz)")

for path in sys.argv[1:]:
    files = sorted(glob.glob(path))
    for f in files:
        print(f"\n===== {os.path.basename(f)}")
        for line in open(f):
            if line.startswith("#"):
                print(line.rstrip())
                continue
            m = pat.search(line)
            if m:
                print("  " + line.strip()[:160])
