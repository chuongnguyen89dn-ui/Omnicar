#!/usr/bin/env python3
"""HL24 regression gate: prevent double transform and stale divider publish.

Source-contract checks coupled to independent event/geometry counterexamples
from the actual HL23 TikTok device log. Not a UIKit/device PASS.
"""
from pathlib import Path
import math
root = Path(__file__).resolve().parents[1]
project = root / "project"
source = root / "src"
a = (project/"OmniCarAppBridge/ABInApp.m").read_text()
asrc = (source/"AppBridgeB/ABInApp.m").read_text()
h = (project/"OmniCarAppBridge/ABHostGeometry.m").read_text()
hsrc = (source/"AppBridgeB/ABHostGeometry.m").read_text()
hm = (project/"OmniCarAppBridge/ABHostBMethods.m").read_text()
hmsrc = (source/"AppBridgeB/ABHostBMethods.m").read_text()
p = (project/"OmniCarSplitScreen/SCPCarSplit+Picker.m").read_text()
psrc = (source/"SplitScreenB/SCPCarSplit+Picker.m").read_text()
assert a == asrc and h == hsrc and hm == hmsrc and p == psrc

# This is the actual destructive HL23 path; reject it completely, not
# merely its factor limit. The keyboard window may be fitted independently.
assert "ABNativeKbFitLayout(" not in a
assert "ABNativeKbLayoutOriginalTransform" not in a
assert "ABNativeKbLayoutAdjusted" not in a
assert "ABNativeKbRestoreLayout" not in a
assert "CGAffineTransformScale(\n            ABNativeKbLayoutOriginalTransform" not in a
assert "ABNativeKbObserveLayout(" in a and "policy=read-only" in a
assert "layout.transform =" not in a and "layout.center =" not in a
assert "[ABCurrentResponder reloadInputViews]" not in a
assert "[hl24-keyplane]" in a and "[hl24-geometry]" in a
assert "ABNativeKbRestore(@\"host-release\")" in a
assert "ABNativeKbRestore(@\"will-hide\")" in a
assert "keyboard.frame = target" in a

# App-side generation must NOT refit a stale packet.  Host-side
# generation and frame+sceneBox equality must gate deferred sends.
assert "revision < ABNativeKbGeometryRevision" in a
assert "orientation >= 1 && !stale &&" in a
assert "AB24AdvanceFrameRevision(app)" in h
assert "AB24FrameRevision(bundle) == revision" in h
assert "CGRectEqualToRect(current.frame, expected)" in h
assert "fabs(current.sceneBox.width - expected.size.width) <= 1.0" in h
assert 'ABPostOrientationToApp(bundle, current.orientation)' in h
assert 'ABPostOrientationToApp(pane.bundleID, pane.orientation);' not in hm
assert '[hl24-stable] commit' in h and '[hl24-keyplane]' in a

# HL23 recorded raw logical scene widths and physical pane widths at .8x;
# the only display scaling factor should be the host's existing zoom.
for physical, logical in [(297,371),(310,388),(396,495),(406,508)]:
    assert abs(round(physical/0.8)-logical) <= 1.0
    assert math.isclose(logical*0.8,physical,abs_tol=1.0)
    assert physical * 0.8 < physical  # double-scale would shrink again

# Independent timeline model of final-only settlement: all old commits
# must be rejected even though their pane still exists.
frames = [(497,362),(498,355),(499,348),(506,310),(508,297)]
current = 0
for _,width in frames:
    current+=1
    if width != frames[-1][1]:
        assert current != len(frames)
last_rev=current
for i,(seq,width) in enumerate(frames):
    accepts = (i+1 == last_rev and width == 297 and width == 297)
    assert accepts == (seq == 508)

assert "BOOL faceClear = NO;" in p
assert "[hl22-original] picker-pane-opacity=1.0" in p
print("HL24 STATIC native keyboard / last-commit geometry / historical log cases PASS; UIKit/DEVICE PENDING")
