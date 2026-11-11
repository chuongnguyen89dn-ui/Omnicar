#!/usr/bin/env python3
"""HL22 source invariants, not a device or runtime test. Run from repository root."""
from pathlib import Path
import hashlib

root = Path(__file__).resolve().parents[1]
project = root / "project"
src = root / "src"

def read(path):
    return path.read_text(encoding="utf-8")

def git_blob_sha(content):
    body = content.encode("utf-8")
    return hashlib.sha1(b"blob " + str(len(body)).encode() + b"\0" + body).hexdigest()

keyboard_p = read(project / "OmniCarAppBridge/ABInApp.m")
keyboard_s = read(src / "AppBridgeB/ABInApp.m")
assert keyboard_p == keyboard_s, "HL11 keyboard project/src differ"
assert "ABNativeKbObserveLayout(" in keyboard_p, "HL24 read-only keyplane observation missing"
assert "[hl24-keyplane]" in keyboard_p and "policy=read-only" in keyboard_p
assert "ABNativeKbRestoreLayout" not in keyboard_p, "Legacy keyplane mutation rollback still present"
assert "ABNativeKbLayoutOriginalTransform" not in keyboard_p, "Legacy keyplane transform state still present"
assert "ABNativeKbFitLayout" not in keyboard_p, "Mutating keyplane fit must not run"
assert "reloadInputViews]" not in keyboard_p, "Do not force keyboard reload after a missing keyplane"
assert 'ABNativeKbFit(@"host-frame-settled"' in keyboard_p
assert 'ABNativeKbFit(@"keyboard-frame"' in keyboard_p
assert "keyboard.frame = target" in keyboard_p, "Native keyboard window frame fit removed"
assert "[hl11kb]" in keyboard_p and "ABNativeKbFit" in keyboard_p

touch_p = read(project / "OmniCarSplitScreen/SCPTouchProbe.m")
touch_s = read(src / "SplitScreenA/SCPTouchProbe.m")
assert touch_p == touch_s and "bwHostedPinchFallbackEnabled" in touch_p
assert "SCPHostPinchPopupBusy" in touch_p and "SCPHostPinchObserve" in touch_p
bridge_p = read(project / "OmniCarSplitScreen/SCPCarSplit+BridgeWake.m")
bridge_s = read(src / "SplitScreenA/SCPCarSplit+BridgeWake.m")
assert "bwHostedPinchFallbackEnabled" in bridge_p and "bwHostedPinchFallbackEnabled" in bridge_s
assert "pinchMode" in bridge_p and "pinchMode" in bridge_s

for a, b in [
    (project / "OmniCarSplitScreen/SCPCarSplit+Picker.m", src / "SplitScreenB/SCPCarSplit+Picker.m"),
    (project / "OmniCarSplitScreen/SCPCarSplit+Chrome.m", src / "SplitScreenB/SCPCarSplit+Chrome.m"),
]:
    assert read(a) == read(b), f"project/src parity failed: {a.name}"

picker = read(project / "OmniCarSplitScreen/SCPCarSplit+Picker.m")
chrome = read(project / "OmniCarSplitScreen/SCPCarSplit+Chrome.m")
assert "trayWindowForParent:self.container" in picker
assert "faceClear = hostedUnderSheet > 0" not in picker
assert "BOOL faceClear = NO;" in picker
assert "[hl21-legacy-picker] ev=opaque-tray-face" in picker
assert "[hl22-original] picker-pane-opacity=1.0" in picker
assert "picker.backgroundColor = hasContent" not in picker
assert '[UIColor clearColor]' not in picker.split('picker.backgroundColor = ', 1)[1].split(';',1)[0]
assert "ev=picker-host mode=" not in picker
assert "[hl10surface] ev=shield-host" not in chrome

home = read(project / "OmniCarSplitScreen/SCPCarSplit.m")
home_src = read(src / "SplitScreenA/SCPCarSplit.m")
for version in (home, home_src):
    block = version.split("- (void)refreshHomeButton {", 1)[1].split("// [gpt-home-grid-only]", 1)[0]
    assert block.count("if (SCPHomeLauncherEnabled())") == 1
    assert "[hl21-floating] removed extra on-app launcher" in block
    assert "[self removeHomeButton];" in block
    assert "[self installIconLongPress];" in block

assert "Version: 1.0.3-hl21restored" in read(project / "control")
print("HL22 SOURCE-INVARIANT PASS (not DEVICE PASS)")
