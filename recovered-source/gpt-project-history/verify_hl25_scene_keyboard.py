#!/usr/bin/env python3
"""HL25 source regression checks (not a private-API ABI or on-car test).

The independent evidence for this patch is the DuoNavi 1.0.4 IMP report
ORIGINAL_DUONAVI_VS_DUODASH_REPACK_IMP.json, selectors at 0xacb24,
0xacb5c, 0xad428, 0xad468; and HL24 YouTube PID 48841 at 15:28.
The binary report does not establish which selector is executable on 16.7.16.
"""
from pathlib import Path

root = Path(__file__).resolve().parents[1]
p = root / "project/OmniCarAppBridge"
s = root / "src/AppBridgeB"

def paired(name):
    a = (p / name).read_text()
    b = (s / name).read_text()
    assert a == b, f"{name}: project/src mismatch"
    return a

host = paired("ABHostBMethods.m")
app = paired("ABInApp.m")
geometry = paired("ABHostGeometry.m")
assert "AB24AdvanceFrameRevision(app)" in geometry
assert "AB24FrameRevision(bundle) == revision" in geometry
assert "CGRectEqualToRect(current.frame, expected)" in geometry
assert "[hl25-host-surface]" in geometry
assert "AB25HostSurface(current, bundle, revision)" in geometry
assert "CGRectEqualToRect(current.frame, expected)" in geometry[
    geometry.index("static void ABFrameBlock("):]

# Correct receiver is the settings object delivered to the EXISTING
# updateSettingsWithBlock transaction, not arbitrary scene or UIKeyboard.
start = host.index("static NSString *AB25SceneReferenceApply(")
end = host.index("static void ABSceneSettingsApply", start)
scene = host[start:end]
for sel in (
    "setContentReferenceSize:withInterfaceOrientation:",
    "setContentReferenceSize:withContentOrientation:andContainerOrientation:",
):
    assert sel in scene
assert "AB25SceneRefABI(settings, two, 4)" in scene
assert "AB25SceneRefABI(settings, three, 5)" in scene
assert "skip-abi-mismatch" in scene and "unavailable" in scene
assert "probe-interface-abi-matches-NOT-CALLED" in scene
assert "probe-3arg-abi-matches-container-unverified-NOT-CALLED" in scene
assert "settings, three, size, orientation, orientation" not in scene
assert "orientation != 1 && orientation != 3 && orientation != 4" in scene
assert "objc_msgSend" not in scene, "Private scene setter must stay disabled before runtime proof"
block = host[host.index("static void ABSceneSettingsApply"):host.index("static id ABSceneOfPane")]
assert "AB25SceneReferenceApply(settings, logicalSize, orientation)" in block
assert "SEL setFrame = NSSelectorFromString(@\"setFrame:\")" in block
assert "setInterfaceOrientation:" in block

# No second keyboard engine and no mutation of UIKit key subtree.
assert "ABNativeKbFitLayout(" not in app
assert "ABNativeKbLayoutOriginalTransform" not in app
assert "layout.transform =" not in app
assert "layout.center =" not in app
assert "[ABCurrentResponder reloadInputViews]" not in app
assert "ABNativeKbRestore(@\"will-hide\")" in app
assert "ABNativeKbRestore(@\"host-release\")" in app
probe_start = app.index("static void AB25ProbeKeyboardSurface(")
probe_end = app.index("static void ABNativeKbRestore(", probe_start)
probe = app[probe_start:probe_end]
for token in ("windowLevel", "windowScene", "clipsToBounds",
              "masksToBounds", "CGRectIntersection", "rightInsideWindow",
              "convertRect:v.bounds toView:keyboard", "hl25-kb-surface",
              "hl25-kb-ancestors", "hl25-kb-windows"):
    assert token in probe, f"missing compositor diagnostic {token}"
for forbidden in ("setFrame:", "layoutIfNeeded", "reloadInputViews",
                  "transform =", "center =", "setNeedsLayout"):
    assert forbidden not in probe, f"unexpected mutation in probe: {forbidden}"
assert "[keyboard hitTest:" not in probe, "Diagnostic must not dispatch custom touch handlers"
assert "keycapRaster=UNKNOWN keycapTouch=UNKNOWN" in probe
assert "(now - lastAt) < 0.25" in probe
assert "lastEpoch == ABNativeKbEpoch" in probe
assert 'NSStringFromCGAffineTransform(appView.transform)' in geometry
assert 'boxWindowSame=%d' in geometry
assert "AB25ProbeKeyboardSurface(keyboard, key, windows, when)" in app
assert "ABNativeKbObserveLayout(keyboard, &starVisualWidth)" in app

# Independent historical geometry: all are one host-side zoom factor.
for physical, logical in ((297,371), (310,388), (396,495), (406,508)):
    assert abs(round(physical / 0.8) - logical) <= 1
    assert abs(logical * 0.8 - physical) <= 1
# No modifier to known functional modules (verified in git compare too).
for fragment in ("[hl24-stable]", "[hl24-keyplane]", "[hl24-geometry]",
                 "policy=read-only", "keyboard.frame = target"):
    assert fragment in (host + app + geometry)

print("HL25 SOURCE/PARITY/STATIC regressions PASS; BUILD/ABI/DEVICE NOT TESTED")
