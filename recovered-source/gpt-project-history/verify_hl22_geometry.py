#!/usr/bin/env python3
"""HL22 finite-geometry and original-picker regression fixtures.

These checks are SOURCE/FORMULA tests and are not a substitute for UIKit
runtime evidence or an on-car device test.
"""
from pathlib import Path
import math
root = Path(__file__).resolve().parents[1]
project = root / "project"
src = root / "src"
a = (project/"OmniCarAppBridge/ABInApp.m").read_text()
b = (src/"AppBridgeB/ABInApp.m").read_text()
p = (project/"OmniCarSplitScreen/SCPCarSplit+Picker.m").read_text()
q = (src/"SplitScreenB/SCPCarSplit+Picker.m").read_text()
assert a == b and p == q, "Project/src build twins mismatch"
assert "CGAffineTransformScale(" in a and "ABNativeKbRestoreLayout" in a
assert 'ABNativeKbFit(@"host-frame-settled"' in a
assert 'ABNativeKbFit(@"keyboard-frame"' in a
assert 'containsString:@"UIKeyboardLayoutStar"' in a
assert "picker.backgroundColor = hasContent" not in p
assert "[hl22-original] picker-pane-opacity=1.0" in p

def calc(source_width: float, visible_width: float, left=0.0):
    assert all(math.isfinite(n) for n in (source_width,visible_width,left))
    available=visible_width-max(0,left)-2
    ratio=available/source_width if source_width > available+2 else 1.0
    if ratio < 0.40 or ratio > 1.0: return None
    right=max(0,left)+source_width*ratio
    return ratio,right

for source,visible,left in [(414,238,0),(414,371,0),(414,414,0),(414,371,12),(414,495,0),(238,238,0)]:
    result=calc(source,visible,left)
    assert result is not None,(source,visible,left)
    ratio,right=result
    assert 0.40 <= ratio <= 1.0
    assert right <= visible+2,(source,visible,left,ratio,right)
for source,visible in [(414,100),(400,120),(414,0)]:
    assert calc(source,visible) is None,(source,visible)
print("HL22 STATIC-AND-GEOMETRY-FORMULA PASS; UIKit/DEVICE NOT PROVEN")
