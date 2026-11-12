#!/usr/bin/env python3
"""Read-only compact on-car log triage. Never print typed text or audio."""
from collections import Counter
from pathlib import Path
import re,sys
file=Path(sys.argv[1])
lines=file.read_text(encoding="utf-8",errors="replace").splitlines()
print("HL34_LOG_TRIAGE file_bytes=%d total_lines=%d" % (file.stat().st_size,len(lines)))
if lines:
    print("FIRST",lines[0][:180])
    print("LAST ",lines[-1][:180])
groups={
"hl33_input_traits":r"\\[hl32-kbtraits\\]|\\[hl33-kb-owner\\]|\\[hl34-keyboard\\]",
"keyboard_focus":r"focus-became|focus-resigned|keyboard-frame-notify|UIKeyboardDidShow",
"keyboard_window":r"UIRemoteKeyboardWindow|UIKeyboardLayoutStar|keyplane|UIInputSet",
"host_packet":r"kbPhysicalW|kbLogicalW|kbLogicalH|frame-settled|scene-unsettled|host-geometry",
"keyboard_mode":r"native-locked|native KHOA CUNG|drawnKeyboard=0|publish-blocked",
"voice_permission":r"event=permission|springboard-tcc-denied",
"voice_capture":r"event=voice-session|event=voice-format|event=capture-started|event=voice-energy|event=voice-verdict|no-input-energy|weak-input-energy|event=stt-error|event=stt-partial",
"bubble":r"\\[hl33-bubble-window\\]",
}
for name,pattern in groups.items():
    rx=re.compile(pattern,re.I)
    matched=[(i,line) for i,line in enumerate(lines,1) if rx.search(line)]
    print("GROUP",name,"count",len(matched))
    for index,line in matched[:7]+([] if len(matched)<=14 else [(0,"...")])+matched[-7:]:
        if index: print("%d %s"%(index,line[:300]))
        else: print("...")
# Version/PID discrimination: never mix generations from unrelated lines.
pids=Counter()
for line in lines:
    m=re.search(r"^\\S+ \\S+ \\[([^\\]]+):([0-9]+)\\]",line)
    if m: pids[(m.group(1),m.group(2))]+=1
print("PIDS",pids.most_common(16))
print("HL34_LOG_TRIAGE_END: BLIND is not ABSENT; a logger may not observe UIKit.")
