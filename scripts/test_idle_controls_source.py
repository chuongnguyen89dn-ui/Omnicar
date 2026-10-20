#!/usr/bin/env python3
"""Static source-only QA, NOT a compilation or device test."""
from pathlib import Path
source=Path("idle/src/OmniCarIdleControls.xm").read_text()
for required in [
    "kOMCIdleSeconds = 4.0", "%hook SCPCarSplit", "%hook SCPCarDividerView",
    "newDividerAt:", "rootDidLayout", "layoutBarForPane:",
    "showRatioMenuForDivider:", "hideRatioMenu", "setBarVisible:",
    "setActive:", "touchesBegan:", "touchesEnded:", "touchesCancelled:",
    "OMCIdleWake", "OMCIdleHideWithNativeMenu",
    "scheduledTimerWithTimeInterval:kOMCIdleSeconds", "s.visible=NO",
    "OMCIdleLinkDividers", "OMCIdlePaintControl", "layer.opacity=0.0f",
    "kOMCSavedOpacityKey", "removeGestureRecognizer:",
    "gesture.cancelsTouchesInView=NO", "gesture.delaysTouchesBegan=NO",
    "gesture.delaysTouchesEnded=NO", "UIGestureRecognizerStateFailed",
    "activeDividerTouches", "OMCIdleApply"
]: assert required in source, required
assert source.count("%orig;")==10, "unexpected native orig call count"
for forbidden in [
    "%hook UIView", "%hook UIWindow", "%hook UIColor",
    "setHidden:", "setAlpha:", "userInteractionEnabled=", "setUserInteractionEnabled:",
    "layer.cornerRadius=", "layer.borderWidth=", "setFrame:", ".frame=",
    "OMCChromeSetHidden", "insertSublayer:", "ratioKnob]", "SSSplashWindow",
    "OMCRescueAction", "com.anlai.omnicar/prefschanged",
    "OMCTrustedTime", "license", "DBStatusBarWindow", "CARStatusBarWindow"
]: assert forbidden not in source, forbidden
assert Path("idle/README.md").is_file()
print("PASS: 4s native-menu synchronized idle controls, touch wake, geometry/host safety guards")
