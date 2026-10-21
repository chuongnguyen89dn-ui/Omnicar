#!/usr/bin/env python3
"""Original OmniCar native Solo restore + cosmetic 4s timer: fail-closed source gate."""
from pathlib import Path
import hashlib
import re
import json
root=Path(__file__).resolve().parent.parent
source=(root/"native-solo-timer/src/OmniCarNativeSoloTimer.xm").read_text()
make=(root/"native-solo-timer/Makefile").read_text()
plist=(root/"native-solo-timer/OmniCarNativeSoloTimer.plist").read_text()
original=json.loads((root/"audit/OmniCar_live_regressions_native_abi_20261020.json").read_text())
assert original["original_sha256"]=="d9297b010cdc08e401439b7332413f79cb1a056a05159a5deb673e218d76d9fd"
owner={(i["class"],i["selector"]):i["pc"] for i in original["related_selectors"]}
for item in [
    ("SCPCarPane","handle"),
    ("SCPCarSplit","dividerTapped:"),
    ("SCPCarSplit","handleTapped:"),
    ("SCPCarSplit","dividers"),
    ("SCPCarSplit","allPanes"),
    ("SCPCarSplit","soloBundle:"),
    ("SCPCarSplit","hostSolo:"),
]:
    assert item in owner, item
assert "kOMCNativeIdleSeconds=4.0" in source
assert source.count("%hook SCPCarSplit")==1
assert source.count("%hook ")==1
assert source.count("%orig;")==5
assert "OMCNativePaint(OMCNativeGet(pane,@selector(handle)),s,s.visible)" in source
assert "OMCNativePaint(divider,s,s.visible)" in source
assert "OMCNativeStop((SCPCarSplit *)self)" in source
assert "OMCNativeApply" in source
assert "self.nativeSplit" in source and "gesture.nativeSplit=split" in source
assert "gesture.cancelsTouchesInView=NO" in source
assert "gesture.delaysTouchesBegan=NO" in source
assert "UIGestureRecognizerStateFailed" in source
assert "scheduledTimerWithTimeInterval:kOMCNativeIdleSeconds" in source
assert "repeats:NO" in source
assert "v.layer.opacity=0.0f" in source
assert "s.timer=[NSTimer" in source
assert source.count("OMCNativePaint(")>=4
assert not re.search(r"@property\s*\([^)]*\)\s*\w+\s*\*owner\b",source)
for blocked in [
    "%hook UIWindow", "%hook UIView", "%hook SCPCarDividerView",
    "%hook SBSceneView", "%hook ABHost", "%hook SCPCarPane",
    "hostedPanes", "@selector(hostHandle)",
    "soloBundle:", "hostSolo:", "closeGoingHome:",
    "closeSlot:", "openSetupLayout:", "soloReturnedVC", "soloHostedBundle",
    "OMCSoloState", "OmniCarSoloThreeDots", "OmniCarDoubleTapFullscreen",
    "OmniCarGraphiteTitanium", "OMCIdlePaintPaneHandles",
    "_isGestureOwningType:", "setUserInteractionEnabled:",
    "setHidden:", "userInteractionEnabled=", "layer.borderWidth",
    "setFrame:", "UIPanGestureRecognizer", "toggleZoomForPane:",
    "CBBridgedSplitApp", "trustedTime", "OMCExpired",
]:
    assert blocked not in source, f"Risky/legacy coupling: {blocked}"
for method in (
  "- (void)rootDidLayout",
  "- (void)setActive:(BOOL)active",
  "- (void)layoutBarForPane:(id)pane",
  "- (void)handleTapped:(id)handle",
  "- (void)dividerTapped:(id)divider",
):
    assert method in source, method
assert "TWEAK_NAME := OmniCarNativeSoloTimer" in make
assert "OmniCarNativeSoloTimer_FILES := src/OmniCarNativeSoloTimer.xm" in make
assert "THEOS_PACKAGE_SCHEME := rootless" in make
assert "com.apple.CarPlayApp" in plist and "com.apple.springboard" in plist
print("ORIGINAL_SOLO_OWNER_NATIVE_UNMODIFIED__ONLY_4S_TWO_MENUS_DIVIDER_VISUAL_TIMER_SCOPE_PASS")
print("VERIFIED_ABI",owner[("SCPCarSplit","soloBundle:")],owner[("SCPCarSplit","hostSolo:")])
print("NO_QA7_QA8_QA9_SOLO_ZOOM_STYLE_OR_MULTI_IDLE_HOOKS_PASS")
