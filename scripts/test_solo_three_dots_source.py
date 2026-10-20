#!/usr/bin/env python3
from pathlib import Path
s=Path("solo/src/OmniCarSoloThreeDots.xm").read_text()
for x in ["%hook SCPCarSplit","closeSlot:(int)slot background:(BOOL)background",
"closeGoingHome:(BOOL)background","openSetupLayout:(int)layout apps:(NSArray *)apps",
"OMCSnapshotBeforeClose","OMCSoloMount","OMCRestoreSplit",
"nativeDots","renderInContext:","layoutID","fractions",
"soloHostedBundle","soloReturnedVC","tabParent","appAreaInParent:",
"OMCSoloDelay=4.0","UIGestureRecognizerStateFailed",
"panesInReadingOrder","allPanes","paneAtSlot:",
"capture-fallback: original-handle-unavailable","confirmedEdgeSolo","cancelsTouchesInView=NO",
"slot==0?right:(slot==1?left:right)","capturedCarPlayWindow",
"capturedAppRectInWindow","OMCNativeSoloOwner","OMCSoloPassthroughView",
"captured-native-host-window","native-solo-cover","returned-vc",
"window.windowScene!=nil","event=host-window-mounted",
"touchOwner=parent.window","window.alpha>.05",
"event=clear-on-home","event=clear-on-native-solo-end",
"OMCVisibleSoloAppRect","endHostedSolo","homeButtonTapped",
"mountSequence","owner-unavailable",
"Khôi phục chia màn hình"]:
 assert x in s,x
for x in ["%hook UIWindow","%hook UIView","%hook UIApplication",
"windowLevel","keyWindow","setHidden:","setZoomedSlot:","toggleZoomForPane:",
"OMCRescueAction","CARStatusBarWindow","DBStatusBarWindow"]:
 assert x not in s,x
assert s.count("%orig;")==5
for x in ["pendingEdgeClose", "OMCClearVisual(s);s.apps=nil;", "restore layout unconfirmed"]:
 assert x in s,x
assert Path("solo/README.md").is_file()
print("PASS static SOLO 3dots original reopen source, not compiled")
