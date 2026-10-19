# REAL ORIGINAL OmniCar skin forensic: control colors, sizes and layer ownership
Date: 2026-10-19. THIS IS AN AUDIT, NOT A SKIN PATCH.

## Verified user correction
Before changing any control, inspect its original UIView/CALayer/subviews, exact paint owner, all border and gradient layers, state-dependent colors, font and size in UIKit points, and preserve actions. The Zoom addon must inherit measured size and border of the original three-choice panel / circular native handle, NOT hardcoded approximate dimensions. No change to system Apple CarPlay dock or original Home/logo, and no added rescue button.

## Original real CarPlay PHOTO measurement — ratios only
Source attached in conversation: IMG_6FB7ED73-9E1D-4000-89C8-C7E9480B875E.jpeg. Actual rotated photo 1571x1178 px (original photo intentionally not published to public GitHub). Photo rectangles are approximate due to perspective/glare:
- 3-choice original native menu (684,335)-(902,418): ~218x83 photographed pixels
- original native small circular divider knob (774,428)-(819,472): ~45x44 photographed pixels
- large pale aqua circle (750,505)-(845,600): ~95x95 photographed pixels, probably custom Zoom but runtime ownership not proven
- original native 3-dot pill (541,230)-(606,255): ~65x25 photographed pixels
- right pane's toolbar (794,219)-(1227,304): ~433x85 photographed pixels
- Apple dock (252,222)-(351,689): OUT OF SCOPE, MUST NEVER STYLE.
The suspicious circle looks ~2.11x native knob diameter. **These are NOT UIKit points** and cannot be pasted into Objective-C CGRect. Need native screen scale / window coordinates and original layer view geometry from a running CarPlay session.

## ORIGINAL binary data — 55 native double-constant loads across 7 methods
Original package: com.anlai.omnicar_1.0.3_iphoneos-arm64.deb; SHA256 d9297b010cdc08e401439b7332413f79cb1a056a05159a5deb673e218d76d9fd.
The actual ARM64 OmniCarSplitScreen.dylib __TEXT,__const literal double sequence at 0x6f168, 0x6f170, 0x6f178 = 0.43137254901960786, 0.39215686274509803, 0.7843137254901961 = RGB 110,100,200; loaded by d0/d1/d2 at original SCPCarSplit newDividerAt: offsets 0x2c5b0,0x2c5b8,0x2c5c0.
Further original d0/d1/d2 sequences, NOT YET linked to exact visible layer:
- newDividerAt: 0x2ccc8/0x2ccd0/0x2ccd8 = RGB 74,79,128.
- showRatioMenuForDivider: 0x30388/0x30390/0x30398 = RGB 74,79,128.
- showRatioMenuForDivider: 0x306a8/0x306b0/0x306b8 = RGB 94,221,182.
- showRatioMenuForDivider: 0x306ec/0x306f4/0x306fc = RGB 245,154,192.
- showRatioMenuForDivider: 0x3097c/0x30984/0x3098c = RGB 155,135,248.
- buildPickerSheetForPane: 0x33c08/0x33c10/0x33c18 = RGB 110,100,200.
In code windows for newDividerAt:, showRatioMenuForDivider:, setupBarForPane:, layoutBarForPane:, refreshHomeButton, refreshPickerSheet, buildPickerSheetForPane: a Python disassembly scan found **55 loads of double literals between 0 and 1** (some may be alpha or geometry, not RGB). The original native bar/selected appearance can also be computed dynamically. This source does NOT prove all controls share one color or which of these bytes paints a particular pixel.
Original machine code and full 55-row CSV are on current workspace:
 /mnt/data/omnicar103/OmniCarSplitScreen-arm64.dylib
 /mnt/data/omnicar103/arm64-disasm.txt
 /mnt/data/omnicar103/methods-full.txt
 /mnt/data/omnicar_forensic/native_double_constants.csv
 /mnt/data/omnicar_static_control_audit.py
Original user photo annotated screenshot is TEMPORARY at /mnt/data/omnicar_forensic/real_photo_measurement_overlay.png, not pushed publicly.

## Why Titanium 0.1/0.2 visually failed
Reviewed actual titanium/src/OmniCarGraphiteTitanium.xm. Generic OMTSurface() modifies the parent view and inserts a CAGradientLayer at index 0 (UNDER all existing native sublayers). It recurses labels/buttons but never identifies which native layer is truly visible, current state-dependent palette, blur owner, actual matching control dimensions, mask/clipping/overdraw. The additional Zoom control lives in a DIFFERENT addon src/OmniCarDoubleTapFullscreen.xm v0.7, still hardcoded light lilac/cyan colors and visible size 29-36pt in source. New parent gradients and palette constants alone cannot guarantee final screen colors. Titanium 0.1 also accidentally recolored native Home/logo; 0.2 removed that fault.

DO NOT issue another cosmetic/color replacement based on this static inventory alone. First collect original real-time metadata, including border, gradient colors/stops, UIVisualEffectView blur, layer order, frames in points and control state for EACH widget; temporarily disable Titanium while doing this to avoid measuring our own layer. Then style individual original render owners; verify screenshot and live gestures with device QA.

## Read-only runtime measuring approach
Probe must hook ONLY OmniCar SCPCarSplit view lifecycle; after native menu/layout calls, inspect the native panel + nested children, divider knob, pane bars/handles, picker and independent Zoom button where accessible. It must NEVER alter appearance, parent UIView, host scene, system dock, app UI or original Home button. Save only classes, dimensions, RGBA, gradients, stroke/width/blur and selected state, not personal app contents or screenshots.
