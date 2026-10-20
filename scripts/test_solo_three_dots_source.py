#!/usr/bin/env python3
from pathlib import Path
s=Path("solo/src/OmniCarSoloThreeDots.xm").read_text()
for x in ["%hook SCPCarSplit","closeSlot:(int)slot background:(BOOL)background",
"closeGoingHome:(BOOL)background","openSetupLayout:(int)layout apps:(NSArray *)apps",
"OMCSnapshotBeforeClose","OMCSoloMount","OMCRestoreSplit",
"nativeDots","renderInContext:","layoutID","fractions",
"soloHostedBundle","soloReturnedVC","tabParent","appAreaInParent:",
"OMCSoloDelay=4.0","UIGestureRecognizerStateFailed","cancelsTouchesInView=NO",
"Khôi phục chia màn hình"]:
 assert x in s,x
for x in ["%hook UIWindow","%hook UIView","%hook UIApplication",
"windowLevel","keyWindow","setHidden:","setZoomedSlot:","toggleZoomForPane:",
"OMCRescueAction","CARStatusBarWindow","DBStatusBarWindow"]:
 assert x not in s,x
assert s.count("%orig;")==3
assert Path("solo/README.md").is_file()
print("PASS static SOLO 3dots original reopen source, not compiled")
