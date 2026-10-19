#!/usr/bin/env python3
"""Prove candidate contains native selectors and actual color constants."""
from pathlib import Path
s=Path("titanium/src/OmniCarGraphiteTitanium.xm").read_text()
m=Path("titanium/Makefile").read_text()
p=Path("titanium/OmniCarGraphiteTitanium.plist").read_text()
control=Path("titanium/control").read_text()
for required in ["%hook SCPCarSplit","showRatioMenuForDivider:","newDividerAt:","setupBarForPane:","layoutBarForPane:","setBarVisible:","refreshHomeButton","refreshPickerSheet","rootDidLayout","%orig","OMTSurface","OMTUpdate","OMTGraphite","OMTGunmetal","OMTTitanium","OMTIce","OMTText","kOMTLayerKey"]:
    assert required in s, required
for channels in ["23,27,34","53,61,70","181,189,197","120,185,200","243,245,245"]:
    assert channels in s,channels
for forbidden in ["homeButton", "refreshHomeButton", "OMTGet(s,@selector(homeButton))","%hook UIView","%hook UIColor","%hook UIWindow","DBStatusBarWindow","CARStatusBarWindow","SBSceneView","appBridgeZoom","OMCRescueAction"]:
    assert forbidden not in s, forbidden
assert "OmniCarGraphiteTitanium_FILES :=" in m
assert "com.apple.UIKit" not in p
assert "com.apple.CarPlayApp" in p and "com.apple.springboard" in p
assert "com.anlai.omnicar.graphitetitanium" in control
print("PASS native OmniCar scoped UI methods, exact RGB palette, system exclusions")
