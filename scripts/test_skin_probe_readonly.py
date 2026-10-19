#!/usr/bin/env python3
from pathlib import Path
s=Path("probe/OmniCarSkinProbe.xm").read_text()
for key in ["%hook SCPCarSplit","showRatioMenuForDivider:","layoutBarForPane:",
"native.ratioMenu","native.ratioKnob","native.pane%d.handle",
"addon.zoomButton","GRADIENT colors=","SHAPE fill=","windowRect=",
"OmniCarSkinProbe.txt","%orig"]:
 assert key in s,key
assert s.count("%hook")==1 and s.count("%orig")==2
for excluded in ["%hook UIView","%hook UIWindow","%hook UIColor",
"OMTSurface","OMCRescueAction","setBackgroundColor:","setCornerRadius:",
"setBorderWidth:","setColors:","appBridgeZoom",
"DBStatusBarWindow","CARStatusBarWindow"]:
 assert excluded not in s,excluded
print("PASS: Native OmniCar metadata-only control probe source")
