#!/usr/bin/env python3
"""Static regression guard for approved 2-action replacement of OmniCar ratio panel.

SOURCE ONLY: does not assert UI rendering, original callback semantics, or device success.
"""
from pathlib import Path
s=Path("src/OmniCarDoubleTapFullscreen.xm").read_text()
native=Path("src/OmniCarChrome.xm").read_text()
required=[
"OMCInstallTwoActionMenu","UIView *menu=[split ratioMenu]",
"OMCHideMenuControls","state.oldSubviewHidden","state.oldMenuGestures",
"sub.hidden=YES","recognizer.enabled=NO",
"[state.menuCover removeFromSuperview]",
"zoom.frame=CGRectMake(0,0,width*.5,height)",
"swap.frame=CGRectMake(width*.5,0,width-width*.5,height)",
"OmniCar.menu.two-actions","OmniCar.menu.zoom","OmniCar.menu.swap",
"OMCZoomGlyph(BOOL expanded)","OMCSwapGlyph(void)",
"OMCToggleHost(self.split)","OMCSwapUsingNativeCallback",
"@selector(dividerDoubleTapOn:)","[split dividerDoubleTapOn:divider]",
"Class cls=NSClassFromString(@\"SCPCarDividerView\")",
"internal.numberOfArguments==3",
"internal-swap-unavailable; fallback-to-original-recognizer",
"NSMethodSignature *sig","native-doubletap-missing",
"OMCButtonOriginatedSwap=YES","OMCButtonOriginatedSwap=NO",
"OMCInNativeSwap=YES","OMCInNativeSwap=NO",
"ratioPresetTapped:(id)sender","blocked-original-three-ratio-preset",
"OMCChromeSetHidden(YES);","event=swap-ended-inactive",
"zoom.exclusiveTouch=YES","swap.exclusiveTouch=YES",
"- (void)dividerDoubleTapped:(id)recognizer",
"legacy-doubletap-swapping-blocked",
"- (void)showRatioMenuForDivider:(id)divider",
"- (void)hideRatioMenu",
"OMCChromeSetHidden(YES)","OMCChromeSetHidden(NO)",
"appAreaInParent:","relayoutAnimated:NO pushScenes:YES",
]
for item in required: assert item in s, item
for banned in [
"OMCShowButton","OMCHideButton","circleBottom+8.0",
"CGFloat diameter=44.0","OMCRescueAction","OMCScheduleRescue",
"setZoomedSlot:","closeFloat:","endHostedSolo","panePopOut:",
"newDividerAt:","dividerPan:state:location:translation:"
]:
    assert banned not in s, "retired below-knob UI/rescue/ratio gesture hook: "+banned
assert "%hook SCPCarSplit" in s
assert s.count("%hook SCPCarSplit")==1
assert "UIWindow *parent=menu.window" not in s, "No floating sibling Zoom"
assert "DBStatusBarWindow" in native and "CARStatusBarWindow" in native
assert "com.anlai.omnicar.zoom.chrome.v1" in native
# Preserve the menu as owner; DO NOT set bounds/frame on native ratioMenu.
assert "menu.frame=" not in s and "menu.bounds=" not in s
assert "[menu addSubview:cover]" in s
print("STATIC_TWO_ACTION_SOURCE_PASS__ORIGINAL_MENU_GEOMETRY_PRESERVED__DEVICE_UNTESTED")
