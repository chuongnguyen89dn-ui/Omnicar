# SplitScreen B — Reconstruction Report

**Module:** `OmniCarSplitScreen.dylib` (1,229,920 B fat; arm64 slice at fat
offset 16384, VA == slice file offset), OmniCar 1.0.3
(SHA256 `d9297b010cdc08e401439b7332413f79cb1a056a05159a5deb673e218d76d9fd`).
**Agent B scope (adjudicated partition, `work/partition.py` /
`work/partition_result.json`):** 229 of the binary's 480 methods —
layout geometry, zoom/floating pane, divider drag + ratio menu, pane
drag-swap, chrome (handles/bars), popup shield, picker-sheet flow,
app tray, and the classes SCPCarSplitView, SCPCarDividerView,
SCPCarTabView, SCPCButton, SCPCTouchWatch, SCPHomeWallView.
**Agent A scope:** 251 methods (SCPCarPane, SCPHostedAppVC, SCPPrefs,
SCPNoopLayoutAssertion, and the SCPCarSplit lifecycle half).
**Evidence:** 295 per-function disassembly files in `disasm/`
(capstone 5.0.7, chained-fixup-aware annotations).

## Status summary

| Status | Count | Meaning |
|---|---|---|
| VERIFIED | 92 | Body reconstructed from the disassembly; constants read from code/data. |
| SYNTHESIZED | 99 | Compiler-synthesized accessor / `.cxx_destruct`; pattern verified against sampled disassembly (object getter = ivar load; setter = retain/store/release; BOOL = `ldrb`; CGRect = two `ldp`/`stp`). Represented by the `@property` declarations in the headers, as in agent A's files. |
| INFERRED | 19 | Control flow verified; a named constant, string or branch direction is inferred (each is marked `// INFERRED` at the use site). |
| PARTIAL | 8 | Skeleton and key constants verified; interior composition unresolved. |
| STUB-UNRECOVERED | 11 | Placeholder body marked `// STUB-UNRECOVERED`; disassembly preserved in `disasm/` for wave 3. Listed in §6. |

## Finding 1 — There are NO OMCZoom classes in OmniCar 1.0.3

The tasking assumed `OMCZoomAction` / `OMCZoomState` live in this
binary. **They do not exist in 1.0.3** — zero hits in the strings and
ObjC metadata of all eight payload binaries (grep-verified). Those
classes exist only in the later QA20 repack's separate fullscreen
dylib. In 1.0.3, zoom state is `SCPCarSplit._zoomedSlot` (ivar offset
80) plus frame recomputation in `relayoutAnimated:pushScenes:`; the
"two-action menu" of the tasking is the per-pane handle/bar chrome
(double-tap = zoom toggle, tap = bar with close/float/layout buttons)
reconstructed in `SCPCarSplit+Zoom.m` / `SCPCarSplit+Chrome.m`.

## Finding 2 — Wave-1 metadata bind-ordinal off-by-one (ADJUDICATED)

The wave-1 parser decoded chained-fixup bind ordinals **1-based**;
dyld ordinals are **0-based**, so every bind-derived name in the
wave-1 metadata was shifted by one import. Consequences for this
module: the "surprising superclasses" in the original tasking
(SCPCarSplitView→NSMutableArray, SCPCButton→NSSortDescriptor) were
parser artifacts. The coordinator broadcast the correction, an
independent verifier confirmed it, and this module's disassembly
annotations were certified **5,485/5,485 call sites exact**. The
original instruction to "report the superclasses as-is" was
explicitly overridden by the coordinator.

Corrected superclasses used in every `@interface` of this module:

| Class | Wave-1 (wrong) | Corrected |
|---|---|---|
| SCPCarSplit | — | NSObject |
| SCPCarPane | — | NSObject |
| SCPHostedAppVC | — | UIViewController |
| SCPCarSplitView | NSMutableArray | **UIView** |
| SCPCarDividerView | — | UIView |
| SCPCarTabView | — | UIView |
| SCPCButton | NSSortDescriptor | **UIButton** |
| SCPCTouchWatch | — | UIView |
| SCPHomeWallView | — | UIView |
| SCPNoopLayoutAssertion | — | NSObject |
| SCPPrefs | — | NSObject |

(Full 28-class table: `metadata/ANNOTATION_AUDIT.md`, addendum.)

Also corrected during the cross-check: several header signatures that
wave-1 type encodings had wrong — `urlLayout:(NSInteger)`,
`urlRatio:(double)`, `ensureFloatPane` → `SCPCarPane *`,
`floatSizeLarge:(BOOL)` → `CGSize`, `closeFloat:(BOOL)`,
`panePopOut:(UIGestureRecognizer *)`.

## Key semantics (all VERIFIED unless noted)

- **Layout kinds:** 0 = linear, 1 = stack-left (layoutID 13),
  2 = stack-right (layoutID 31). `mainStack` = kind ∈ {1,2} &&
  paneCount == 3; `mainRight` = mainStack && kind == 2.
- **Geometry:** 1 pt divider gaps; pane sizes `floor(usable × f)`,
  remainder to the last pane; stack sub-frames
  `floor((cross − 1) × f)`; main-right mirrors frames across the area
  centre (`x' = minX + maxX − x − w`, same for y).
- **Zoom:** zooming hides all other panes (alpha 0 via relayout),
  `clipsToBounds` untouched at this layer; restore = `zoomedSlot = -1`
  + relayout. No baseline-rect storage exists — frames are always
  recomputed from `fractions`.
- **Floating pane (slot 9):** small = clamp(W×0.30, 160, 240) ×
  clamp(H×0.45, 96, 170); large = clamp(W×0.45, 220, 360) ×
  clamp(H×0.62, 130, 260); 8 pt margins; open/close = 0.2 s fade +
  scale 0.6↔identity (open) / →0.8 (close, dock-back).
- **Divider drag:** linear clamp [0.04, pair−0.04]; squeeze-out below
  0.12 encodes the dismissed slot (negative encoding for the second
  pane); snap candidates {1/3, 1/2, 2/3} (2-pane) or 1/12 grid;
  main-stack clamps 0.75 (main) / 0.96 (sub), knob grabs classified by
  hypot > 12 with 1.5× axis dominance; snap caps fraction[0] at 0.67.
- **Ratio presets (constant tables decoded):** mainStack
  [[1/3,.5],[.5,.5],[2/3,.5]]; 2-pane [[1/3,2/3],[.5,.5],[2/3,1/3]];
  3-pane [[1/3,1/3,1/3],[.25,.5,.25],[.5,.25,.25],[.25,.25,.5]];
  match tolerance 0.03; persisted as `%.2f` pairs joined `" / "`.
- **Chrome idle behaviour in 1.0.3:** there is no global idle timer in
  this binary's B-half; bars auto-hide 4.0 s after being shown
  (`setBarVisible:forPane:`), the app tray auto-collapses after 4.0 s,
  the ratio menu auto-hides after 4.0 s. The popup shield
  (SCPCTouchWatch) passes touches only inside computed exempt rects.
- **OMCTr keys are opaque codes, not English.** Two anomalies are
  transcribed literally: the popOutBlockReason "no app" key is the
  single byte **0xD4** (invalid UTF-8); the floatDockBack "already 3
  panes" toast key (cfstring @0x7b220) is a 28-byte blob starting
  `10 01 E3` with embedded NULs — the exact key is **NOT-RECOVERED**
  (placeholder in source, marked). Two @catch logs use the 1-character
  format string `"C"`, transcribed as-is.

## Partition reconciliation

- A = 251 methods, B = 229 methods (total 480 ✓), split from
  `work/partition_result.json`, which is also the source of the IMP
  addresses in the table below (a few in-source IMP comments written
  before the final partition differ by a few bytes — the table wins).
- **Handoff to A** (`handoff/`): methods owned by A that B had already
  decoded under the earlier working split — `layoutID`,
  `relayoutAnimated:`, `relayoutAnimated:pushScenes:`,
  `setPaneCount:`, `switchToLayout:`, `swapSlot:with:`,
  `rootDidLayout`, `paneSize:forBundle:`, `openSetupLayout:apps:`,
  `activateWithLayout:`, `layoutChosenID:` (PARTIAL) — plus the whole
  class `SCPNoopLayoutAssertion` (A-owned; B's copies were moved to
  `handoff/`, not deleted).
- **Shared helpers** (declared in A's `SCPShared.h`, B agrees):
  `SCPDispatchAfter` @0x12efc, `SCPDashboardObject` @0xe5b4,
  `SCPDashboardRootViewController` @0x12658, `OMCLogWrite` @0x4fbf4,
  `OMCLiteActive` @0x4f698, `OMCTr` @0x558fc, `OMCPref` @0x4f544,
  `SCPMissingSelector` @0x4f330, `SCPCarLaunchApp` @0xe410,
  `SCPAppIconForBundle` @0xdec8 (name INFERRED).

## Per-function table (B partition, 229 methods)

| Class | Selector | IMP | Source | Evidence | Status |
|---|---|---|---|---|---|
| SCPCButton | `pointInside:withEvent:` | 0xe69c | SCPCButton.m | disasm/SCPCButton__pointInside_withEvent_.txt | VERIFIED |
| SCPCButton | `setHighlighted:` | 0xe738 | SCPCButton.m | disasm/SCPCButton__setHighlighted_.txt | VERIFIED |
| SCPCarSplitView | `hitTest:withEvent:` | 0xe88c | SCPCarSplitView.m | disasm/SCPCarSplitView__hitTest_withEvent_.txt | VERIFIED |
| SCPCarSplitView | `touched` | 0xe9c4 | SCPCarSplitView.m | disasm/SCPCarSplitView__touched.txt | SYNTHESIZED |
| SCPCarSplitView | `setTouched:` | 0xe9d4 | SCPCarSplitView.m | disasm/SCPCarSplitView__setTouched_.txt | SYNTHESIZED |
| SCPCarSplitView | `.cxx_destruct` | 0xe9e0 | SCPCarSplitView.m | disasm/SCPCarSplitView__.cxx_destruct.txt | SYNTHESIZED |
| SCPCarDividerView | `touchesBegan:withEvent:` | 0xe9f4 | SCPCarDividerView.m | disasm/SCPCarDividerView__touchesBegan_withEvent_.txt | VERIFIED |
| SCPCarDividerView | `touchesEnded:withEvent:` | 0xefa4 | SCPCarDividerView.m | disasm/SCPCarDividerView__touchesEnded_withEvent_.txt | VERIFIED |
| SCPCarDividerView | `touchesCancelled:withEvent:` | 0xf08c | SCPCarDividerView.m | disasm/SCPCarDividerView__touchesCancelled_withEvent_.txt | VERIFIED |
| SCPCarDividerView | `pointInside:withEvent:` | 0xf174 | SCPCarDividerView.m | disasm/SCPCarDividerView__pointInside_withEvent_.txt | VERIFIED |
| SCPCarDividerView | `index` | 0xf2b0 | SCPCarDividerView.m | disasm/SCPCarDividerView__index.txt | SYNTHESIZED |
| SCPCarDividerView | `setIndex:` | 0xf2c0 | SCPCarDividerView.m | disasm/SCPCarDividerView__setIndex_.txt | SYNTHESIZED |
| SCPCarDividerView | `knob` | 0xf2d0 | SCPCarDividerView.m | disasm/SCPCarDividerView__knob.txt | SYNTHESIZED |
| SCPCarDividerView | `setKnob:` | 0xf2e0 | SCPCarDividerView.m | disasm/SCPCarDividerView__setKnob_.txt | SYNTHESIZED |
| SCPCarDividerView | `.cxx_destruct` | 0xf320 | SCPCarDividerView.m | disasm/SCPCarDividerView__.cxx_destruct.txt | SYNTHESIZED |
| SCPCarTabView | `pointInside:withEvent:` | 0xf334 | SCPCarTabView.m | disasm/SCPCarTabView__pointInside_withEvent_.txt | VERIFIED |
| SCPCTouchWatch | `hitTest:withEvent:` | 0xf36c | SCPCTouchWatch.m | disasm/SCPCTouchWatch__hitTest_withEvent_.txt | VERIFIED |
| SCPCTouchWatch | `setHoles:` | 0xf4d4 | SCPCTouchWatch.m | disasm/SCPCTouchWatch__setHoles_.txt | VERIFIED |
| SCPCTouchWatch | `exempt` | 0xf850 | SCPCTouchWatch.m | disasm/SCPCTouchWatch__exempt.txt | SYNTHESIZED |
| SCPCTouchWatch | `setExempt:` | 0xf860 | SCPCTouchWatch.m | disasm/SCPCTouchWatch__setExempt_.txt | SYNTHESIZED |
| SCPCTouchWatch | `outside` | 0xf86c | SCPCTouchWatch.m | disasm/SCPCTouchWatch__outside.txt | SYNTHESIZED |
| SCPCTouchWatch | `setOutside:` | 0xf87c | SCPCTouchWatch.m | disasm/SCPCTouchWatch__setOutside_.txt | SYNTHESIZED |
| SCPCTouchWatch | `.cxx_destruct` | 0xf888 | SCPCTouchWatch.m | disasm/SCPCTouchWatch__.cxx_destruct.txt | SYNTHESIZED |
| SCPCarSplit | `vertical` | 0x10504 | SCPCarSplit+Layout.m | disasm/SCPCarSplit__vertical.txt | VERIFIED |
| SCPCarSplit | `mainStack` | 0x10ffc | SCPCarSplit+Layout.m | disasm/SCPCarSplit__mainStack.txt | VERIFIED |
| SCPCarSplit | `mainRight` | 0x1104c | SCPCarSplit+Layout.m | disasm/SCPCarSplit__mainRight.txt | VERIFIED |
| SCPCarSplit | `dividerRunsHorizontally:` | 0x110cc | SCPCarSplit+Layout.m | disasm/SCPCarSplit__dividerRunsHorizontally_.txt | VERIFIED |
| SCPCarSplit | `mainStackFrameForSlot:inArea:` | 0x11110 | SCPCarSplit+Layout.m | disasm/SCPCarSplit__mainStackFrameForSlot_inArea_.txt | VERIFIED |
| SCPCarSplit | `leftMainStackFrameForSlot:inArea:` | 0x1122c | SCPCarSplit+Layout.m | disasm/SCPCarSplit__leftMainStackFrameForSlot_inArea_.txt | VERIFIED |
| SCPCarSplit | `fractionAt:` | 0x11374 | SCPCarSplit+Layout.m | disasm/SCPCarSplit__fractionAt_.txt | VERIFIED |
| SCPCarSplit | `slotIsPinned:` | 0x11478 | SCPCarSplit+Layout.m | disasm/SCPCarSplit__slotIsPinned_.txt | VERIFIED |
| SCPCarSplit | `frameForSlot:` | 0x11674 | SCPCarSplit+Layout.m | disasm/SCPCarSplit__frameForSlot_.txt | VERIFIED |
| SCPCarSplit | `innerCornersForSlot:` | 0x118d8 | SCPCarSplit+Layout.m | disasm/SCPCarSplit__innerCornersForSlot_.txt | VERIFIED |
| SCPCarSplit | `neighbourCornersForSlot:` | 0x11a04 | SCPCarSplit+Layout.m | disasm/SCPCarSplit__neighbourCornersForSlot_.txt | VERIFIED |
| SCPCarSplit | `dividersVisible` | 0x11b50 | SCPCarSplit+Layout.m | disasm/SCPCarSplit__dividersVisible.txt | VERIFIED |
| SCPCarSplit | `dividerFrameAt:` | 0x11ba0 | SCPCarSplit+Layout.m | disasm/SCPCarSplit__dividerFrameAt_.txt | VERIFIED |
| SCPCarSplit | `appAreaInParent:` | 0x11dfc | SCPCarSplit+Layout.m | disasm/SCPCarSplit__appAreaInParent_.txt | INFERRED |
| SCPCarSplit | `flashFocusOnPane:` | 0x13314 | SCPCarSplit+Layout.m | disasm/SCPCarSplit__flashFocusOnPane_.txt | VERIFIED |
| SCPCarSplit | `floatDockBack` | 0x139dc | SCPCarSplit+Zoom.m | disasm/SCPCarSplit__floatDockBack.txt | VERIFIED |
| SCPCarSplit | `resetFractions` | 0x14200 | SCPCarSplit+Layout.m | disasm/SCPCarSplit__resetFractions.txt | VERIFIED |
| SCPCarSplit | `normalizeFractions` | 0x1437c | SCPCarSplit+Layout.m | disasm/SCPCarSplit__normalizeFractions.txt | VERIFIED |
| SCPCarSplit | `rebuildDividers` | 0x14600 | SCPCarSplit+Layout.m | disasm/SCPCarSplit__rebuildDividers.txt | VERIFIED |
| SCPCarSplit | `showPickersForEmptySlots` | 0x15648 | SCPCarSplit+Picker.m | disasm/SCPCarSplit__showPickersForEmptySlots.txt | VERIFIED |
| SCPCarSplit | `ensureFloatPane` | 0x1f040 | SCPCarSplit+Zoom.m | disasm/SCPCarSplit__ensureFloatPane.txt | VERIFIED |
| SCPCarSplit | `floatSizeLarge:` | 0x1f5a4 | SCPCarSplit+Zoom.m | disasm/SCPCarSplit__floatSizeLarge_.txt | VERIFIED |
| SCPCarSplit | `floatHandleDoubleTapped:` | 0x1f678 | SCPCarSplit+Zoom.m | disasm/SCPCarSplit__floatHandleDoubleTapped_.txt | VERIFIED |
| SCPCarSplit | `toggleFloatSize` | 0x1f67c | SCPCarSplit+Zoom.m | disasm/SCPCarSplit__toggleFloatSize.txt | VERIFIED |
| SCPCarSplit | `fitFloatFrame` | 0x1f9d8 | SCPCarSplit+Zoom.m | disasm/SCPCarSplit__fitFloatFrame.txt | VERIFIED |
| SCPCarSplit | `closeFloat:` | 0x1fb1c | SCPCarSplit+Zoom.m | disasm/SCPCarSplit__closeFloat_.txt | VERIFIED |
| SCPCarSplit | `popOutBlockReason:` | 0x20054 | SCPCarSplit+Zoom.m | disasm/SCPCarSplit__popOutBlockReason_.txt | VERIFIED |
| SCPCarSplit | `canPopOutPane:` | 0x201bc | SCPCarSplit+Zoom.m | disasm/SCPCarSplit__canPopOutPane_.txt | VERIFIED |
| SCPCarSplit | `panePopOut:` | 0x201f0 | SCPCarSplit+Zoom.m | disasm/SCPCarSplit__panePopOut_.txt | VERIFIED |
| SCPCarSplit | `popOutPane:` | 0x20244 | SCPCarSplit+Zoom.m | disasm/SCPCarSplit__popOutPane_.txt | VERIFIED |
| SCPCarSplit | `floatPanned:` | 0x20a30 | SCPCarSplit+Zoom.m | disasm/SCPCarSplit__floatPanned_.txt | VERIFIED |
| SCPCarSplit | `setupBarForPane:` | 0x22adc | SCPCarSplit+Chrome.m | disasm/SCPCarSplit__setupBarForPane_.txt | PARTIAL |
| SCPCarSplit | `handleShiftForPane:` | 0x23ab4 | SCPCarSplit+Chrome.m | disasm/SCPCarSplit__handleShiftForPane_.txt | VERIFIED |
| SCPCarSplit | `layoutBarForPane:` | 0x23b9c | SCPCarSplit+Chrome.m | disasm/SCPCarSplit__layoutBarForPane_.txt | INFERRED |
| SCPCarSplit | `setBarVisible:forPane:` | 0x241fc | SCPCarSplit+Chrome.m | disasm/SCPCarSplit__setBarVisible_forPane_.txt | INFERRED |
| SCPCarSplit | `urlLayout:` | 0x24dc8 | SCPCarSplit+Zoom.m | disasm/SCPCarSplit__urlLayout_.txt | VERIFIED |
| SCPCarSplit | `urlRatio:` | 0x24e44 | SCPCarSplit+Zoom.m | disasm/SCPCarSplit__urlRatio_.txt | VERIFIED |
| SCPCarSplit | `urlSwap` | 0x24f98 | SCPCarSplit+Zoom.m | disasm/SCPCarSplit__urlSwap.txt | VERIFIED |
| SCPCarSplit | `urlZoomPane:` | 0x24ff0 | SCPCarSplit+Zoom.m | disasm/SCPCarSplit__urlZoomPane_.txt | VERIFIED |
| SCPCarSplit | `handleDoubleTapped:` | 0x25048 | SCPCarSplit+Zoom.m | disasm/SCPCarSplit__handleDoubleTapped_.txt | VERIFIED |
| SCPCarSplit | `toggleZoomForPane:` | 0x251b0 | SCPCarSplit+Zoom.m | disasm/SCPCarSplit__toggleZoomForPane_.txt | VERIFIED |
| SCPCarSplit | `handleTapped:` | 0x253e4 | SCPCarSplit+Zoom.m | disasm/SCPCarSplit__handleTapped_.txt | VERIFIED |
| SCPCarSplit | `hideBarsForTouchOn:` | 0x25558 | SCPCarSplit+Chrome.m | disasm/SCPCarSplit__hideBarsForTouchOn_.txt | INFERRED |
| SCPCarSplit | `popupOpen` | 0x257ec | SCPCarSplit+Chrome.m | disasm/SCPCarSplit__popupOpen.txt | VERIFIED |
| SCPCarSplit | `closePopups` | 0x25894 | SCPCarSplit+Chrome.m | disasm/SCPCarSplit__closePopups.txt | INFERRED |
| SCPCarSplit | `shieldExemptRects` | 0x25a4c | SCPCarSplit+Chrome.m | disasm/SCPCarSplit__shieldExemptRects.txt | VERIFIED |
| SCPCarSplit | `shieldExemptPoint:` | 0x26070 | SCPCarSplit+Chrome.m | disasm/SCPCarSplit__shieldExemptPoint_.txt | VERIFIED |
| SCPCarSplit | `refreshShieldHoles` | 0x261b0 | SCPCarSplit+Chrome.m | disasm/SCPCarSplit__refreshShieldHoles.txt | VERIFIED |
| SCPCarSplit | `panelOpen` | 0x26394 | SCPCarSplit+Chrome.m | disasm/SCPCarSplit__panelOpen.txt | VERIFIED |
| SCPCarSplit | `updatePopupShield` | 0x26424 | SCPCarSplit+Chrome.m | disasm/SCPCarSplit__updatePopupShield.txt | VERIFIED |
| SCPCarSplit | `handlePanned:` | 0x26834 | SCPCarSplit+Drag.m | disasm/SCPCarSplit__handlePanned_.txt | VERIFIED |
| SCPCarSplit | `beginPaneDrag:at:` | 0x26a98 | SCPCarSplit+Drag.m | disasm/SCPCarSplit__beginPaneDrag_at_.txt | VERIFIED |
| SCPCarSplit | `movePaneDragTo:from:` | 0x27494 | SCPCarSplit+Drag.m | disasm/SCPCarSplit__movePaneDragTo_from_.txt | INFERRED |
| SCPCarSplit | `endPaneDrag:` | 0x27a18 | SCPCarSplit+Drag.m | disasm/SCPCarSplit__endPaneDrag_.txt | VERIFIED |
| SCPCarSplit | `clearPaneDragMarks` | 0x27e34 | SCPCarSplit+Drag.m | disasm/SCPCarSplit__clearPaneDragMarks.txt | VERIFIED |
| SCPCarSplit | `cancelPaneDrag` | 0x27fcc | SCPCarSplit+Drag.m | disasm/SCPCarSplit__cancelPaneDrag.txt | VERIFIED |
| SCPCarSplit | `hideTrayWindowIfIdle` | 0x28180 | SCPCarSplit+Picker.m | disasm/SCPCarSplit__hideTrayWindowIfIdle.txt | VERIFIED |
| SCPCarSplit | `floatDragPhase:at:` | 0x284e8 | SCPCarSplit+Zoom.m | disasm/SCPCarSplit__floatDragPhase_at_.txt | VERIFIED |
| SCPCarSplit | `showBackgroundToastFor:slot:` | 0x28c48 | SCPCarSplit+Picker.m | disasm/SCPCarSplit__showBackgroundToastFor_slot_.txt | STUB-UNRECOVERED |
| SCPCarSplit | `paneChoose:` | 0x29f28 | SCPCarSplit+Panel.m | disasm/SCPCarSplit__paneChoose_.txt | INFERRED |
| SCPCarSplit | `addCoverToPane:` | 0x2a2e8 | SCPCarSplit+Picker.m | disasm/SCPCarSplit__addCoverToPane_.txt | VERIFIED |
| SCPCarSplit | `removeCoverFromPane:` | 0x2a668 | SCPCarSplit+Picker.m | disasm/SCPCarSplit__removeCoverFromPane_.txt | VERIFIED |
| SCPCarSplit | `showLoaderInPane:bundle:` | 0x2a7b8 | SCPCarSplit+Picker.m | disasm/SCPCarSplit__showLoaderInPane_bundle_.txt | STUB-UNRECOVERED |
| SCPCarSplit | `loaderCancelTapped:` | 0x2b980 | SCPCarSplit+Picker.m | disasm/SCPCarSplit__loaderCancelTapped_.txt | INFERRED |
| SCPCarSplit | `removeLoaderFromPane:animated:` | 0x2bbb4 | SCPCarSplit+Picker.m | disasm/SCPCarSplit__removeLoaderFromPane_animated_.txt | INFERRED |
| SCPCarSplit | `beginResize` | 0x2c128 | SCPCarSplit+Divider.m | disasm/SCPCarSplit__beginResize.txt | VERIFIED |
| SCPCarSplit | `endResize` | 0x2c25c | SCPCarSplit+Divider.m | disasm/SCPCarSplit__endResize.txt | VERIFIED |
| SCPCarSplit | `newDividerAt:` | 0x2c4c0 | SCPCarSplit+Layout.m | disasm/SCPCarSplit__newDividerAt_.txt | VERIFIED |
| SCPCarSplit | `layoutKnobOf:` | 0x2c848 | SCPCarSplit+Layout.m | disasm/SCPCarSplit__layoutKnobOf_.txt | VERIFIED |
| SCPCarSplit | `dividerPanned:` | 0x2d05c | SCPCarSplit+Divider.m | disasm/SCPCarSplit__dividerPanned_.txt | VERIFIED |
| SCPCarSplit | `dividerPan:state:location:translation:` | 0x2d210 | SCPCarSplit+Divider.m | disasm/SCPCarSplit__dividerPan_state_location_translation_.txt | VERIFIED |
| SCPCarSplit | `mainStackDividerPan:state:location:translation:ended:` | 0x2db68 | SCPCarSplit+Divider.m | disasm/SCPCarSplit__mainStackDividerPan_state_location_translation_ended_.txt | VERIFIED |
| SCPCarSplit | `saveRatio` | 0x2e360 | SCPCarSplit+Divider.m | disasm/SCPCarSplit__saveRatio.txt | VERIFIED |
| SCPCarSplit | `dividerDoubleTapped:` | 0x2e6e8 | SCPCarSplit+Divider.m | disasm/SCPCarSplit__dividerDoubleTapped_.txt | VERIFIED |
| SCPCarSplit | `dividerDoubleTapOn:` | 0x2e73c | SCPCarSplit+Divider.m | disasm/SCPCarSplit__dividerDoubleTapOn_.txt | VERIFIED |
| SCPCarSplit | `ratioPresets` | 0x2e9a0 | SCPCarSplit+Divider.m | disasm/SCPCarSplit__ratioPresets.txt | VERIFIED |
| SCPCarSplit | `fractionsMatch:` | 0x2e9f0 | SCPCarSplit+Divider.m | disasm/SCPCarSplit__fractionsMatch_.txt | VERIFIED |
| SCPCarSplit | `dividerTapped:` | 0x2eb64 | SCPCarSplit+Divider.m | disasm/SCPCarSplit__dividerTapped_.txt | VERIFIED |
| SCPCarSplit | `dividerTapOn:at:` | 0x2ebf0 | SCPCarSplit+Divider.m | disasm/SCPCarSplit__dividerTapOn_at_.txt | VERIFIED |
| SCPCarSplit | `remoteKnobTouch:` | 0x2edfc | SCPCarSplit+Divider.m | disasm/SCPCarSplit__remoteKnobTouch_.txt | VERIFIED |
| SCPCarSplit | `showRatioMenuForDivider:` | 0x2f614 | SCPCarSplit+RatioMenu.m | disasm/SCPCarSplit__showRatioMenuForDivider_.txt | INFERRED |
| SCPCarSplit | `hideRatioMenu` | 0x30ce0 | SCPCarSplit+RatioMenu.m | disasm/SCPCarSplit__hideRatioMenu.txt | INFERRED |
| SCPCarSplit | `ratioPresetTapped:` | 0x31194 | SCPCarSplit+Divider.m | disasm/SCPCarSplit__ratioPresetTapped_.txt | VERIFIED |
| SCPCarSplit | `removePickerFromPane:` | 0x313ac | SCPCarSplit+Picker.m | disasm/SCPCarSplit__removePickerFromPane_.txt | VERIFIED |
| SCPCarSplit | `showPickerForSlot:` | 0x31530 | SCPCarSplit+Picker.m | disasm/SCPCarSplit__showPickerForSlot_.txt | INFERRED |
| SCPCarSplit | `pickerPaneTapped:` | 0x31960 | SCPCarSplit+Picker.m | disasm/SCPCarSplit__pickerPaneTapped_.txt | VERIFIED |
| SCPCarSplit | `refreshPickerSheetSoon` | 0x31a0c | SCPCarSplit+Picker.m | disasm/SCPCarSplit__refreshPickerSheetSoon.txt | VERIFIED |
| SCPCarSplit | `panesInReadingOrder` | 0x31ba0 | SCPCarSplit+Picker.m | disasm/SCPCarSplit__panesInReadingOrder.txt | INFERRED |
| SCPCarSplit | `refreshPickerSheet` | 0x31eac | SCPCarSplit+Picker.m | disasm/SCPCarSplit__refreshPickerSheet.txt | PARTIAL |
| SCPCarSplit | `markPickerPanes` | 0x322cc | SCPCarSplit+Picker.m | disasm/SCPCarSplit__markPickerPanes.txt | STUB-UNRECOVERED |
| SCPCarSplit | `removePickerSheet` | 0x32498 | SCPCarSplit+Picker.m | disasm/SCPCarSplit__removePickerSheet.txt | PARTIAL |
| SCPCarSplit | `pickerMapForPane:height:` | 0x329a0 | SCPCarSplit+Picker.m | disasm/SCPCarSplit__pickerMapForPane_height_.txt | STUB-UNRECOVERED |
| SCPCarSplit | `pickerMapTapped:` | 0x33420 | SCPCarSplit+Picker.m | disasm/SCPCarSplit__pickerMapTapped_.txt | VERIFIED |
| SCPCarSplit | `buildPickerSheetForPane:` | 0x334cc | SCPCarSplit+Picker.m | disasm/SCPCarSplit__buildPickerSheetForPane_.txt | STUB-UNRECOVERED |
| SCPCarSplit | `pickerAppTapped:` | 0x362a0 | SCPCarSplit+Picker.m | disasm/SCPCarSplit__pickerAppTapped_.txt | STUB-UNRECOVERED |
| SCPCarSplit | `pickerCancel:` | 0x364d0 | SCPCarSplit+Picker.m | disasm/SCPCarSplit__pickerCancel_.txt | PARTIAL |
| SCPCarSplit | `refreshAppTabSoon` | 0x36d3c | SCPCarSplit+Picker.m | disasm/SCPCarSplit__refreshAppTabSoon.txt | VERIFIED |
| SCPCarSplit | `refreshAppTab` | 0x36e04 | SCPCarSplit+Picker.m | disasm/SCPCarSplit__refreshAppTab.txt | VERIFIED |
| SCPCarSplit | `removeAppTab` | 0x36f04 | SCPCarSplit+Picker.m | disasm/SCPCarSplit__removeAppTab.txt | VERIFIED |
| SCPCarSplit | `panelSections:` | 0x36f08 | SCPCarSplit+Panel.m | disasm/SCPCarSplit__panelSections_.txt | STUB-UNRECOVERED |
| SCPCarSplit | `trayWindowForParent:` | 0x3782c | SCPCarSplit+Picker.m | disasm/rem4_trayWindowForParent.txt + disasm/rem4_tray_hitTest_481c8.txt | VERIFIED (rem4: UIRootSceneWindow from FBSDisplayConfiguration + SCPCPass_ runtime subclass with super-forwarding hitTest IMP @0x481c8; the earlier condensed plain-UIWindow body was wrong) |
| SCPCarSplit | `showLayoutPanelForApp:` | 0x37e8c | SCPCarSplit+Panel.m | disasm/SCPCarSplit__showLayoutPanelForApp_.txt | STUB-UNRECOVERED |
| SCPCarSplit | `panelChoiceTapped:` | 0x3a4d0 | SCPCarSplit+Panel.m | disasm/SCPCarSplit__panelChoiceTapped_.txt | PARTIAL |
| SCPCarSplit | `panelChoiceTappedUnsafe:` | 0x3a5e8 | SCPCarSplit+Panel.m | disasm/SCPCarSplit__panelChoiceTappedUnsafe_.txt | STUB-UNRECOVERED |
| SCPCarSplit | `showPickerForFocusedPane` | 0x3b04c | SCPCarSplit+Picker.m | disasm/SCPCarSplit__showPickerForFocusedPane.txt | INFERRED |
| SCPCarSplit | `showTipSoon` | 0x3b374 | SCPCarSplit+Picker.m | disasm/SCPCarSplit__showTipSoon.txt | PARTIAL |
| SCPCarSplit | `layoutPickerDotsForPage:` | 0x3b630 | SCPCarSplit+Picker.m | disasm/SCPCarSplit__layoutPickerDotsForPage_.txt | STUB-UNRECOVERED |
| SCPCarSplit | `scrollViewDidScroll:` | 0x3b920 | SCPCarSplit+Picker.m | disasm/SCPCarSplit__scrollViewDidScroll_.txt | INFERRED |
| SCPCarSplit | `scrollViewWillBeginDragging:` | 0x3bb58 | SCPCarSplit+Picker.m | disasm/SCPCarSplit__scrollViewWillBeginDragging_.txt | VERIFIED |
| SCPCarSplit | `restartTrayTimer` | 0x3bc20 | SCPCarSplit+Picker.m | disasm/SCPCarSplit__restartTrayTimer.txt | VERIFIED |
| SCPCarSplit | `collapseAppTray` | 0x3bd78 | SCPCarSplit+Picker.m | disasm/SCPCarSplit__collapseAppTray.txt | PARTIAL |
| SCPCarSplit | `toast:` | 0x44fd4 | SCPCarSplit+Picker.m | disasm/SCPCarSplit__toast_.txt | VERIFIED |
| SCPCarSplit | `toast:duration:` | 0x44fe0 | SCPCarSplit+Picker.m | disasm/SCPCarSplit__toast_duration_.txt | STUB-UNRECOVERED |
| SCPCarSplit | `trayCover` | 0x4588c | SCPCarSplit.h (@property) | disasm/SCPCarSplit__trayCover.txt | SYNTHESIZED |
| SCPCarSplit | `setTrayCover:` | 0x45894 | SCPCarSplit.h (@property) | disasm/SCPCarSplit__setTrayCover_.txt | SYNTHESIZED |
| SCPCarSplit | `trayWindow` | 0x458c4 | SCPCarSplit.h (@property) | disasm/SCPCarSplit__trayWindow.txt | SYNTHESIZED |
| SCPCarSplit | `setTrayWindow:` | 0x458cc | SCPCarSplit.h (@property) | disasm/SCPCarSplit__setTrayWindow.txt | SYNTHESIZED |
| SCPCarSplit | `trayOverlay` | 0x458fc | SCPCarSplit.h (@property) | disasm/SCPCarSplit__trayOverlay.txt | SYNTHESIZED |
| SCPCarSplit | `setTrayOverlay:` | 0x45904 | SCPCarSplit.h (@property) | disasm/SCPCarSplit__setTrayOverlay.txt | SYNTHESIZED |
| SCPCarSplit | `zoomedSlot` | 0x4590c | SCPCarSplit.h (@property) | disasm/SCPCarSplit__zoomedSlot.txt | SYNTHESIZED |
| SCPCarSplit | `setZoomedSlot:` | 0x45914 | SCPCarSplit.h (@property) | disasm/SCPCarSplit__setZoomedSlot_.txt | SYNTHESIZED |
| SCPCarSplit | `pickerSheet` | 0x45964 | SCPCarSplit.h (@property) | disasm/SCPCarSplit__pickerSheet.txt | SYNTHESIZED |
| SCPCarSplit | `setPickerSheet:` | 0x4596c | SCPCarSplit.h (@property) | disasm/SCPCarSplit__setPickerSheet.txt | SYNTHESIZED |
| SCPCarSplit | `pickerShield` | 0x4599c | SCPCarSplit.h (@property) | disasm/SCPCarSplit__pickerShield.txt | SYNTHESIZED |
| SCPCarSplit | `setPickerShield:` | 0x459a4 | SCPCarSplit.h (@property) | disasm/SCPCarSplit__setPickerShield.txt | SYNTHESIZED |
| SCPCarSplit | `pickerSheetPane` | 0x459d4 | SCPCarSplit.h (@property) | disasm/SCPCarSplit__pickerSheetPane.txt | SYNTHESIZED |
| SCPCarSplit | `setPickerSheetPane:` | 0x459ec | SCPCarSplit.h (@property) | disasm/SCPCarSplit__setPickerSheetPane.txt | SYNTHESIZED |
| SCPCarSplit | `pickerSheetKey` | 0x459f8 | SCPCarSplit.h (@property) | disasm/SCPCarSplit__pickerSheetKey.txt | SYNTHESIZED |
| SCPCarSplit | `setPickerSheetKey:` | 0x45a00 | SCPCarSplit.h (@property) | disasm/SCPCarSplit__setPickerSheetKey.txt | SYNTHESIZED |
| SCPCarSplit | `pickerSheetOverlay` | 0x45a08 | SCPCarSplit.h (@property) | disasm/SCPCarSplit__pickerSheetOverlay.txt | SYNTHESIZED |
| SCPCarSplit | `setPickerSheetOverlay:` | 0x45a10 | SCPCarSplit.h (@property) | disasm/SCPCarSplit__setPickerSheetOverlay.txt | SYNTHESIZED |
| SCPCarSplit | `pickerSheetQueued` | 0x45a18 | SCPCarSplit.h (@property) | disasm/SCPCarSplit__pickerSheetQueued.txt | SYNTHESIZED |
| SCPCarSplit | `setPickerSheetQueued:` | 0x45a20 | SCPCarSplit.h (@property) | disasm/SCPCarSplit__setPickerSheetQueued.txt | SYNTHESIZED |
| SCPCarSplit | `pickerDots` | 0x45a28 | SCPCarSplit.h (@property) | disasm/SCPCarSplit__pickerDots.txt | SYNTHESIZED |
| SCPCarSplit | `setPickerDots:` | 0x45a40 | SCPCarSplit.h (@property) | disasm/SCPCarSplit__setPickerDots.txt | SYNTHESIZED |
| SCPCarSplit | `fractions` | 0x45abc | SCPCarSplit.h (@property) | disasm/SCPCarSplit__fractions.txt | SYNTHESIZED |
| SCPCarSplit | `setFractions:` | 0x45ac4 | SCPCarSplit.h (@property) | disasm/SCPCarSplit__setFractions_.txt | SYNTHESIZED |
| SCPCarSplit | `dividers` | 0x45b5c | SCPCarSplit.h (@property) | disasm/SCPCarSplit__dividers.txt | SYNTHESIZED |
| SCPCarSplit | `setDividers:` | 0x45b64 | SCPCarSplit.h (@property) | disasm/SCPCarSplit__setDividers.txt | SYNTHESIZED |
| SCPCarSplit | `loggedArea` | 0x45b94 | SCPCarSplit.h (@property) | disasm/SCPCarSplit__loggedArea.txt | SYNTHESIZED |
| SCPCarSplit | `setLoggedArea:` | 0x45b9c | SCPCarSplit.h (@property) | disasm/SCPCarSplit__setLoggedArea.txt | SYNTHESIZED |
| SCPCarSplit | `resizing` | 0x45c20 | SCPCarSplit.h (@property) | disasm/SCPCarSplit__resizing.txt | SYNTHESIZED |
| SCPCarSplit | `setResizing:` | 0x45c28 | SCPCarSplit.h (@property) | disasm/SCPCarSplit__setResizing_.txt | SYNTHESIZED |
| SCPCarSplit | `dragGhost` | 0x45c30 | SCPCarSplit.h (@property) | disasm/SCPCarSplit__dragGhost.txt | SYNTHESIZED |
| SCPCarSplit | `setDragGhost:` | 0x45c38 | SCPCarSplit.h (@property) | disasm/SCPCarSplit__setDragGhost.txt | SYNTHESIZED |
| SCPCarSplit | `dragTarget` | 0x45c68 | SCPCarSplit.h (@property) | disasm/SCPCarSplit__dragTarget.txt | SYNTHESIZED |
| SCPCarSplit | `setDragTarget:` | 0x45c70 | SCPCarSplit.h (@property) | disasm/SCPCarSplit__setDragTarget.txt | SYNTHESIZED |
| SCPCarSplit | `ratioMenu` | 0x45c78 | SCPCarSplit.h (@property) | disasm/SCPCarSplit__ratioMenu.txt | SYNTHESIZED |
| SCPCarSplit | `setRatioMenu:` | 0x45c80 | SCPCarSplit.h (@property) | disasm/SCPCarSplit__setRatioMenu.txt | SYNTHESIZED |
| SCPCarSplit | `ratioKnob` | 0x45cb0 | SCPCarSplit.h (@property) | disasm/SCPCarSplit__ratioKnob.txt | SYNTHESIZED |
| SCPCarSplit | `setRatioKnob:` | 0x45cc8 | SCPCarSplit.h (@property) | disasm/SCPCarSplit__setRatioKnob.txt | SYNTHESIZED |
| SCPCarSplit | `ratioTimer` | 0x45cd4 | SCPCarSplit.h (@property) | disasm/SCPCarSplit__ratioTimer.txt | SYNTHESIZED |
| SCPCarSplit | `setRatioTimer:` | 0x45cdc | SCPCarSplit.h (@property) | disasm/SCPCarSplit__setRatioTimer.txt | SYNTHESIZED |
| SCPCarSplit | `ratioOverlay` | 0x45d0c | SCPCarSplit.h (@property) | disasm/SCPCarSplit__ratioOverlay.txt | SYNTHESIZED |
| SCPCarSplit | `setRatioOverlay:` | 0x45d14 | SCPCarSplit.h (@property) | disasm/SCPCarSplit__setRatioOverlay.txt | SYNTHESIZED |
| SCPCarSplit | `ratioHidesBridge` | 0x45d1c | SCPCarSplit.h (@property) | disasm/SCPCarSplit__ratioHidesBridge.txt | SYNTHESIZED |
| SCPCarSplit | `setRatioHidesBridge:` | 0x45d24 | SCPCarSplit.h (@property) | disasm/SCPCarSplit__setRatioHidesBridge.txt | SYNTHESIZED |
| SCPCarSplit | `floatPane` | 0x45d2c | SCPCarSplit.h (@property) | disasm/SCPCarSplit__floatPane.txt | SYNTHESIZED |
| SCPCarSplit | `setFloatPane:` | 0x45d34 | SCPCarSplit.h (@property) | disasm/SCPCarSplit__setFloatPane.txt | SYNTHESIZED |
| SCPCarSplit | `floatFrame` | 0x45d64 | SCPCarSplit.h (@property) | disasm/SCPCarSplit__floatFrame.txt | SYNTHESIZED |
| SCPCarSplit | `setFloatFrame:` | 0x45d70 | SCPCarSplit.h (@property) | disasm/SCPCarSplit__setFloatFrame_.txt | SYNTHESIZED |
| SCPCarSplit | `floatClosing` | 0x45d7c | SCPCarSplit.h (@property) | disasm/SCPCarSplit__floatClosing.txt | SYNTHESIZED |
| SCPCarSplit | `setFloatClosing:` | 0x45d84 | SCPCarSplit.h (@property) | disasm/SCPCarSplit__setFloatClosing.txt | SYNTHESIZED |
| SCPCarSplit | `floatLarge` | 0x45d8c | SCPCarSplit.h (@property) | disasm/SCPCarSplit__floatLarge.txt | SYNTHESIZED |
| SCPCarSplit | `setFloatLarge:` | 0x45d94 | SCPCarSplit.h (@property) | disasm/SCPCarSplit__setFloatLarge.txt | SYNTHESIZED |
| SCPCarSplit | `floatReturnLayout` | 0x45d9c | SCPCarSplit.h (@property) | disasm/SCPCarSplit__floatReturnLayout.txt | SYNTHESIZED |
| SCPCarSplit | `setFloatReturnLayout:` | 0x45da4 | SCPCarSplit.h (@property) | disasm/SCPCarSplit__setFloatReturnLayout.txt | SYNTHESIZED |
| SCPCarSplit | `floatReturnSlot` | 0x45dac | SCPCarSplit.h (@property) | disasm/SCPCarSplit__floatReturnSlot.txt | SYNTHESIZED |
| SCPCarSplit | `setFloatReturnSlot:` | 0x45db4 | SCPCarSplit.h (@property) | disasm/SCPCarSplit__setFloatReturnSlot.txt | SYNTHESIZED |
| SCPCarSplit | `floatReturnFractions` | 0x45dbc | SCPCarSplit.h (@property) | disasm/SCPCarSplit__floatReturnFractions.txt | SYNTHESIZED |
| SCPCarSplit | `setFloatReturnFractions:` | 0x45dc4 | SCPCarSplit.h (@property) | disasm/SCPCarSplit__setFloatReturnFractions.txt | SYNTHESIZED |
| SCPCarSplit | `tray` | 0x45dcc | SCPCarSplit.h (@property) | disasm/SCPCarSplit__tray.txt | SYNTHESIZED |
| SCPCarSplit | `setTray:` | 0x45dd4 | SCPCarSplit.h (@property) | disasm/SCPCarSplit__setTray.txt | SYNTHESIZED |
| SCPCarSplit | `popupShield` | 0x45e04 | SCPCarSplit.h (@property) | disasm/SCPCarSplit__popupShield.txt | SYNTHESIZED |
| SCPCarSplit | `setPopupShield:` | 0x45e0c | SCPCarSplit.h (@property) | disasm/SCPCarSplit__setPopupShield.txt | SYNTHESIZED |
| SCPCarSplit | `shieldPosted` | 0x45e3c | SCPCarSplit.h (@property) | disasm/SCPCarSplit__shieldPosted.txt | SYNTHESIZED |
| SCPCarSplit | `setShieldPosted:` | 0x45e44 | SCPCarSplit.h (@property) | disasm/SCPCarSplit__setShieldPosted.txt | SYNTHESIZED |
| SCPCarSplit | `popupsClosedAt` | 0x45e4c | SCPCarSplit.h (@property) | disasm/SCPCarSplit__popupsClosedAt.txt | SYNTHESIZED |
| SCPCarSplit | `setPopupsClosedAt:` | 0x45e54 | SCPCarSplit.h (@property) | disasm/SCPCarSplit__setPopupsClosedAt.txt | SYNTHESIZED |
| SCPCarSplit | `trayHidesBridge` | 0x45e5c | SCPCarSplit.h (@property) | disasm/SCPCarSplit__trayHidesBridge.txt | SYNTHESIZED |
| SCPCarSplit | `setTrayHidesBridge:` | 0x45e64 | SCPCarSplit.h (@property) | disasm/SCPCarSplit__setTrayHidesBridge.txt | SYNTHESIZED |
| SCPCarSplit | `trayTimer` | 0x45e6c | SCPCarSplit.h (@property) | disasm/SCPCarSplit__trayTimer.txt | SYNTHESIZED |
| SCPCarSplit | `setTrayTimer:` | 0x45e74 | SCPCarSplit.h (@property) | disasm/SCPCarSplit__setTrayTimer.txt | SYNTHESIZED |
| SCPCarSplit | `panelChoices` | 0x45eb4 | SCPCarSplit.h (@property) | disasm/SCPCarSplit__panelChoices.txt | SYNTHESIZED |
| SCPCarSplit | `setPanelChoices:` | 0x45ebc | SCPCarSplit.h (@property) | disasm/SCPCarSplit__setPanelChoices.txt | SYNTHESIZED |
| SCPCarSplit | `.cxx_destruct` | 0x46008 | SCPCarSplit.h (@property) | disasm/SCPCarSplit__.cxx_destruct.txt | SYNTHESIZED |
| SCPHomeWallView | `initWithFrame:` | 0x491ac | SCPHomeWallView.m | disasm/SCPHomeWallView__initWithFrame_.txt | INFERRED |
| SCPHomeWallView | `layoutSubviews` | 0x49350 | SCPHomeWallView.m | disasm/SCPHomeWallView__layoutSubviews.txt | VERIFIED |
| SCPHomeWallView | `stopVideo` | 0x4941c | SCPHomeWallView.m | disasm/SCPHomeWallView__stopVideo.txt | VERIFIED |
| SCPHomeWallView | `startVideo:` | 0x494d0 | SCPHomeWallView.m | disasm/SCPHomeWallView__startVideo_.txt | INFERRED |
| SCPHomeWallView | `updatePlayback` | 0x498bc | SCPHomeWallView.m | disasm/SCPHomeWallView__updatePlayback.txt | INFERRED |
| SCPHomeWallView | `didMoveToWindow` | 0x49ae4 | SCPHomeWallView.m | disasm/SCPHomeWallView__didMoveToWindow.txt | VERIFIED |
| SCPHomeWallView | `applySettings:source:` | 0x49b2c | SCPHomeWallView.m | disasm/SCPHomeWallView__applySettings_source_.txt | PARTIAL |
| SCPHomeWallView | `image` | 0x4a49c | SCPHomeWallView.m | disasm/SCPHomeWallView__image.txt | SYNTHESIZED |
| SCPHomeWallView | `setImage:` | 0x4a4ac | SCPHomeWallView.m | disasm/SCPHomeWallView__setImage_.txt | SYNTHESIZED |
| SCPHomeWallView | `dim` | 0x4a4ec | SCPHomeWallView.m | disasm/SCPHomeWallView__dim.txt | SYNTHESIZED |
| SCPHomeWallView | `setDim:` | 0x4a4fc | SCPHomeWallView.m | disasm/SCPHomeWallView__setDim.txt | SYNTHESIZED |
| SCPHomeWallView | `player` | 0x4a53c | SCPHomeWallView.m | disasm/SCPHomeWallView__player.txt | SYNTHESIZED |
| SCPHomeWallView | `setPlayer:` | 0x4a54c | SCPHomeWallView.m | disasm/SCPHomeWallView__setPlayer.txt | SYNTHESIZED |
| SCPHomeWallView | `looper` | 0x4a58c | SCPHomeWallView.m | disasm/SCPHomeWallView__looper.txt | SYNTHESIZED |
| SCPHomeWallView | `setLooper:` | 0x4a59c | SCPHomeWallView.m | disasm/SCPHomeWallView__setLooper.txt | SYNTHESIZED |
| SCPHomeWallView | `videoLayer` | 0x4a5dc | SCPHomeWallView.m | disasm/SCPHomeWallView__videoLayer.txt | SYNTHESIZED |
| SCPHomeWallView | `setVideoLayer:` | 0x4a5ec | SCPHomeWallView.m | disasm/SCPHomeWallView__setVideoLayer.txt | SYNTHESIZED |
| SCPHomeWallView | `loadedKey` | 0x4a62c | SCPHomeWallView.m | disasm/SCPHomeWallView__loadedKey.txt | SYNTHESIZED |
| SCPHomeWallView | `setLoadedKey:` | 0x4a63c | SCPHomeWallView.m | disasm/SCPHomeWallView__setLoadedKey.txt | SYNTHESIZED |
| SCPHomeWallView | `.cxx_destruct` | 0x4a648 | SCPHomeWallView.m | disasm/SCPHomeWallView__.cxx_destruct.txt | SYNTHESIZED |
## §6 — STUB-UNRECOVERED and PARTIAL inventory (wave-3 work list)

Method-level stubs (bodies are data-shaped; selector-level wiring,
callers and constants around them are documented in the sources):

- `buildPickerSheetForPane:` — 2,539-line disassembly
  (`disasm/SCPCarSplit__buildPickerSheetForPane_.txt`).
- `pickerMapForPane:height:` — 673 lines.
- `pickerAppTapped:` — sender → app mapping unresolved.
- `showLoaderInPane:bundle:` — 755 lines; selectors around it
  (spinner, "loading" label, 44×44 cancel button) are documented.
- `toast:duration:` — styling constants verified at grep level
  (navy text RGB(0.2902, 0.3098, 0.5020), font 14, white α0.94
  background, sizeThatFits + 18/19 padding); composition is a stub.
- `showBackgroundToastFor:slot:` — 471 lines.
- `showLayoutPanelForApp:` / `panelSections:` /
  `panelChoiceTappedUnsafe:` — panel composition verified at selector
  level only (4 layout choices; recent section from `recentLayouts`
  gated by `showRecent`; favorites from `favoriteApps:` gated by
  `showFavorites`); dispatch flow of the unsafe variant verified
  (setLayoutApp: + collapse, openSetupLayout:apps:,
  layoutChosenID:), kind values/key names not isolated.
- `markPickerPanes` — pass structure unresolved.

PARTIAL: `collapseAppTray`, `refreshPickerSheet`, `removePickerSheet`,
`pickerCancel:`, `panelChoiceTapped:` (@try wrapper VERIFIED),
`applySettings:source:` (SCPHomeWallView; tail unresolved),
`showTipSoon`, `setupBarForPane:` (handle VERIFIED; bar button row
PARTIAL via the factored helper `barButtonForPane:action:`, which is
INFERRED as a factoring — it is not a binary method).

Static-helper stubs (disassembly preserved; called from VERIFIED code):

- `SCPMakeRatioChipPreview` @0x46a64 (+ block @0x47e00)
- `SCPWrapRatioChip` @0x302f8
- `SCPMarkRatioChipSelected` @0x30450
- `SCPStyleRatioMenu` @0x29b10
- `SCPPrepareRatioMenu` @0x24a34
- `SCPStyleDragGhost` @0x271e4 — declaration only in Drag.m
- `SCPStyleGhostIcon` @0x21158 — declaration only in Drag.m

## §7 — Flags and open questions

1. **dismiss == 0 ambiguity (dividerPan:):** the binary encodes "no
   squeeze-out" and "close slot 0" with the same value 0; the
   reconstruction transcribes this literally — closing slot 0 by
   squeezing may therefore also fire on plain drags that end with
   fraction[0] ≥ 0.12 in the original if the caller
   (`markDismissSlot:`, A's side) distinguishes them. Flagged for A.
2. **endPaneDrag:'s trailing cancelPaneDrag** is a no-op in the
   binary (state already cleared) — transcribed and noted, not
   "fixed".
3. **popOutPane: fresh path** calls `afterPaneRemoved:nil` (not the
   popped bundle) — transcribed literally.
4. **appAreaInParent: tail:** the front (area computation, divider
   identification) is VERIFIED; the trailing inset arithmetic is
   INFERRED — the disassembly is ground truth for wave 3.
5. **OMCTr key @0x7b220** (floatDockBack toast) is NOT-RECOVERED
   byte-exact (28-byte blob with embedded NULs); the source uses the
   placeholder `@"\u0010\u0001"` plus the English fallback string,
   which is what the user sees.
6. **SCPHomeWallView:** `image` is the init-created UIImageView
   (VERIFIED); contentMode, videoGravity, `muted`, layer placement,
   the thermal ceiling in updatePlayback, and the settings key names
   in applySettings:source: are INFERRED.
7. Wave-3 merge notes: B's files call A-owned methods through the
   shared `SCPCarSplit.h`; two factored helpers are reconstruction
   conveniences, not binary methods — `barButtonForPane:action:`
   (Chrome) and `SCPAppIconForBundle` @0xdec8 (name INFERRED, the
   function itself is real). `SCPKnobFaceView()` @0x35c74 and
   `SCPSetKnobActive` @0xeb20 in SCPCarDividerView.m are real C
   functions of the binary.

---

## Closure addendum (wave 3, finisher — 2026-11-08)

Every §6 stub and §-PARTIAL item was re-read line-by-line from fresh
annotated dumps (capstone 5.0.7 + `verify/macho_truth.py` ground truth +
a full `__cfstring` decode of all 832 entries, 44 of them UTF-16).
Verdicts per item:

### Task item 1 — the 11 STUB-UNRECOVERED: ALL CLOSED

| Item | Verdict | Notes |
|---|---|---|
| `buildPickerSheetForPane:` @0x334e4 | CLOSED | Full decode incl. grid math (cols CSINC clamp, rowsPerPage, pages), sheet frame (width = cols×62+20, +150 map column), entrance springs, cell stagger, empty state, final log line. |
| `pickerMapForPane:height:` @0x329a0 | CLOSED | Full decode; only the TARGET pane's button gets `SCPApplyAccent`; buttons enabled iff `picker != nil && pane != target`. |
| `pickerAppTapped:` @0x362a0 | CLOSED | @try/@catch with exact log formats @0x7c8e0/@0x7c900. |
| `showLoaderInPane:bundle:` @0x2a7e8 | CLOSED | Full decode incl. card, spinning ring (2π over 0.9 s), pulse completion block, 20 s watchdog block @0x2b610 (fires only when `pendingSlotForBundle:` < 0). |
| `toast:duration:` @0x44f80 | CLOSED | Full decode; fade-out duration is 0.3 (constant @0x6f010), delay = the duration argument; re-centring rule over the first visible non-bridged pane decoded. |
| `showBackgroundToastFor:slot:` @0x28c68 | CLOSED | Full decode incl. Reopen UIAction block @0x29a08 and the 5 s auto-dismiss block @0x29db4. |
| `showLayoutPanelForApp:` @0x37e8c | CLOSED (2 INFERRED details) | Full decode incl. glyph rect enumeration + draw block @0x4829c, section-0 divider/exit chip, empty-section placeholder, covers, stagger, final log. INFERRED remainders: (a) axis assignment of the glyph totals / 13-31 base rects; (b) empty-section placeholder size (binary reuses stale glyph-total registers). |
| `panelSections:` @0x36ef8 | CLOSED + SIGNATURE FIX | See contradiction (ii). |
| `panelChoiceTappedUnsafe:` @0x3a5e8 | CLOSED | Exact log format @0x7ce40. |
| `markPickerPanes` @0x322cc | CLOSED | borderWidth 3.0 for the sheet pane, 0.0 otherwise. |
| 5 static ratio helpers | CLOSED | See below; one name/type correction (vii). |
| 2 drag-ghost stylers | CLOSED | `SCPStyleDragGhost` @0x271e4, `SCPStyleGhostIcon` @0x21158 — bodies in Drag.m, now exported (Picker/Panel/RatioMenu call them). |

Ratio helpers: `SCPWrapRatioChip` @0x302f8 CLOSED; `SCPMarkRatioChipSelected`
@0x30450 CLOSED (conic-gradient `omcRing` + mask); `SCPStyleRatioMenu`
@0x29b10 CLOSED; `SCPPrepareRatioMenu` @0x24a34 CLOSED (entrance prep);
@0x46a64 CLOSED as `SCPRenderTemplateImage` (returns UIImage*) + symbol
draw block @0x46b90 (all 18 icons transcribed) + `SCPSymbolImage` @0x2b474
+ `SCPMakeIconButton` @0x2b404.
**PARTIAL-remaining (one):** the preset-preview draw block @0x47e00 used by
`showRatioMenuForDivider:` — structure and constants VERIFIED (lineWidth
1.5, grid insets, 0.2 gap, 1-decimal rounding, mainStack branch), but its
inner segment block @0x48140 was not line-read, so exact segment endpoints
in `SCPDrawPresetGlyph` are INFERRED.

### Task item 2 — the 8 PARTIALs

- `setupBarForPane:` — CLOSED (see contradiction vi).
- `refreshPickerSheet` — CLOSED; B's draft superseded (key format
  `'%p/%d/%lu/%d/%@'`, container-window gate, no `updatePopupShield` call).
- `removePickerSheet` — CLOSED incl. both blocks; B's draft WRONGLY also
  cleared `pickerSheetPane` — the binary does not.
- `pickerCancel:` — CLOSED; B's body (bare `removePickerSheet`) was WRONG
  (see iv).
- `collapseAppTray` — CLOSED incl. all four blocks; B's draft omitted the
  `setFullscreenBridgeHidden:NO` / `pushHostFramesLive:NO` / trayCover
  steps.
- `showTipSoon` — CLOSED; tip counter is `[SCPPrefs tipCount]` (B's draft
  used a nonexistent `self.tipCount` property); tip strings corrected to
  the exact UTF-16 texts ('Mẹo: …').
- `applySettings:source:` (SCPHomeWallView) — CLOSED except one
  PARTIAL-remaining: the main-queue completion block @0x4a294 was not
  line-read; it is transcribed with a precise `// STUB-UNRECOVERED`
  note (captures: key/image/path/weak self; applies the image when
  `loadedKey` still matches). Also see contradiction (xi).
- `panelChoiceTapped:` — CLOSED (exact @catch format @0x7ce20).

### Task item 3 — the "opaque" OMCTr keys: FULLY RECOVERED (UTF-16 misread)

B's dumper read UTF-16LE cfstring bytes as UTF-8 text. All anomalies are
ordinary Vietnamese strings (full 44-entry UTF-16 table decoded):
- floatDockBack key @0x7b220 = `@"Đã đủ 3 ô, không đưa về được"` (28
  UTF-16 chars; the "28 bytes with embedded NULs" were its first 14
  chars). No byte-array construction needed — plain literal.
- popOutBlockReason "no app" key @0x7bcc0 = `@"Ô chưa có app"` (first
  code unit U+00D4 = "Ô"; B read its first byte 0xD4).
- popOutBlockReason "needs 2 panes" key @0x7bd00 = `@"Cần ít nhất 2 ô"`
  (first byte 0x43 = "C", likewise misread).

### Task item 4 — sanity-check flags

- **Flag (1) dividerPan: — TRANSCRIPTION ERROR (report-only; Divider.m
  behaviour NOT changed, a `// CLOSURE-FLAG:` comment marks the site).**
  Dump @0x2d52c–0x2d538 (`fcmp`/`csinv`/`csel`, CSINV semantics verified):
  the binary computes
  `dismiss = (newF0 < 0.12) ? idx : ((newF1 < 0.12) ? idx + 1 : -1)`.
  B's Divider.m has `dismiss = 0; if (newF1 < 0.12) dismiss = ~(idx + 1);
  if (newF0 < 0.12) dismiss = idx;` — wrong twice: the newF1 branch is
  POSITIVE `idx + 1`, and "no squeeze" is **−1**, not 0. Consequences:
  the feared dismiss==0 double-meaning does NOT exist in the binary
  (0 arises only as idx==0 via the newF0 branch); and B's terminal path
  (dismiss < 0 → snap) diverges from the binary on a newF1 squeeze,
  where the binary's positive dismiss reaches `closeSlot:`. One-line
  correction for the coordinator:
  `NSInteger dismiss = (newF0 < 0.12) ? idx : ((newF1 < 0.12) ? idx + 1 : -1);`
- **Flag (2) popOutPane: — CONFIRMED CORRECT.** Dump
  `SCPCarSplit__popOutPane_.txt` @0x207f4: `mov x2, #0` before
  `afterPaneRemoved:` on the fresh path — the nil is literal in the
  binary (same pattern in `pickerCancel:`).

### Contradictions with B's verified claims (flagged, not silently overridden)

(i) **UTF-16 misread family** — Zoom.m @catch formats ×2 were single
characters "C"; real strings: 'CarSplit: loi cham dup thanh ••• %@'
@0x7c080 and 'CarSplit: loi cham thanh ••• %@' @0x7c100. Plus the three
OMCTr keys in item 3. All previously presented as VERIFIED/structural.
Fixed in place.
(ii) **panelSections: signature** — declared `(NSString *)bundleID`;
binary takes an out-pointer for the kinds array. Sections are plain
choice ARRAYS (not `{title, choices}` dicts); recent names join with
`@" + "` (B's comment said `@", "`). Fixed in Panel.m + SCPCarSplit.h.
(iii) **paneChoose:** — B wrote `setBarVisible:YES`, key `@"C"`, fallback
"this app is pinned", plus an INFERRED trailing log line. Binary:
`setBarVisible:NO`, key `@"Ô này đang ghim"`, fallback "This pane is
pinned", NO log call. Real address 0x29f28 (B: "0x3a000 approx."). Fixed.
(iv) **pickerCancel:** — B's body was only `[self removePickerSheet]`;
the binary removes the picker from the pane and branches
(relayout / closeFloat: / removePaneAt: + afterPaneRemoved:nil) inside
@try/@catch. Fixed.
(v) **refreshPickerSheet / removePickerSheet / collapseAppTray** —
superseded details as listed under item 2.
(vi) **setupBarForPane:** — B: handle 44×12, ONE dot at (6,6), factored
`barButtonForPane:action:` (bare UIButton), actions `paneSoloTapped:` /
`panePopOut:`. Binary: handle 34×12, THREE dots (x = 9/17/25), factory
@0x23710 (`SCPBarButton` + `SCPSetBarButtonContent` @0x24104), actions
`paneChoose:`/`paneSolo:`/`panePopOut:`/`paneBackground:`/`paneClose:`,
buttons array with NSNull spacer, bar 52 pt via `SCPStyleRatioMenu`.
The factored helper is deleted; the real factory replaces it. Fixed.
(vii) **@0x46a64** — B's `SCPMakeRatioChipPreview` returning UIView* is
wrong: it is the template-image renderer returning UIImage*, also called
by `SCPSymbolImage`. Fixed (declaration types only at call sites).
(viii) **Classref slot 0x87000+0x7a0 = SCPCButton** in picker cells,
picker map, wrap chip and bar factory — B's dumps left it unannotated.
(ix) **Picker.m `addCoverToPane:` comment** cited "0x24a34+" — 0x24a34
is `SCPPrepareRatioMenu`. Comment fixed.
(x) **SCPCommon.h `SCPKnobFaceView` @0x35c74 vs `SCPBlurEffectView`** —
same address; the finisher's line-read shows a UIVisualEffectView
factory used as sheet/panel/menu backdrop. If the knob face uses the
same frosted view both names denote one function; integration must
pick ONE name (finisher used SCPBlurEffectView).
(xi) **applySettings:source:** — B read path/video from `settings` with
key format `'%@|%@'` and no dim scaling. Binary: path/video from
`source`, key `'%@|%@|%@|%d'` (path, mtime, blur object, video), dim is
a percentage (÷100). Fixed.
(xii) **pickerDots.tag** — buildPickerSheet sets `dotsView.tag = 1`
literally; B's `scrollViewDidScroll:` treats pickerDots.tag as the
current page. Both transcribed as-is; flagged as an inconsistency in
the original (or in B's scroll handler) for integration review.
(xiii) Extra decodes for integration: `SCPApplyAccent` @0x293a0 has a
THIRD caller (sub_24794) besides Picker.m's two — dedupe when merging;
`SCPIsBridgedPhoneApp` @0x101bc (Picker.m static) is called from 8
sites across the module — hoisting candidate. Block sub_48da0 (C's
handoff) is unrelated to B's closure items.

### Still open after this pass

1. applySettings main-queue block @0x4a294 — not line-read (precise
   stub note in SCPHomeWallView.m).
2. Preset draw block @0x47e00 segment endpoints — inner block @0x48140
   not line-read; SCPDrawPresetGlyph segment geometry INFERRED.
3. Panel glyph totals axis assignment + empty-section placeholder
   size — INFERRED (register-level ambiguity), marked inline.
4. `toast:` single-arg default duration (2.6 in B's Picker.m) — the
   12-byte tail @0x44f74 was not re-verified in this pass.

## Final micro-closure (wave 3, coordinator-ruled — 2026-11-08)

The three items left open by the Closure addendum (its "Still open"
1 and 2, plus the Divider correction it deferred to the coordinator)
were closed by fresh line-reads (capstone + `verify/macho_truth.py`;
dumps saved as `disasm/SCPHomeWallView_block_4a294.txt`,
`disasm/SCPHomeWallView_block_4a450.txt`,
`disasm/SCPCarSplit_block_47e00_preset_glyph.txt`,
`disasm/SCPCarSplit_block_48140_preset_segment.txt`). This closes
"Still open" items 1 and 2 above; items 3 and 4 remain as recorded.

### Item 1 — Divider dismiss correction: APPLIED (VERIFIED)

`SCPCarSplit+Divider.m` now computes, exactly as proven at
@0x2d52c–0x2d538:
`NSInteger dismiss = (newF0 < 0.12) ? idx : ((newF1 < 0.12) ? idx + 1 : -1);`
The `// CLOSURE-FLAG:` comment is replaced by an evidence comment.
Downstream flow is consistent with the correction: the terminal
path's `dismiss < 0` → snap branch now matches the binary's
no-squeeze case, and a newF1 squeeze yields the positive slot index
that reaches `closeSlot:background:`.

### Item 2 — applySettings: main-queue block @0x4a294: CLOSED (VERIFIED)

Line-read in full (444 B). The block is richer than the finisher's
capture-layout guess — the guessed body (direct `image` assignment)
was wrong in mechanism. Actual body, now in `SCPHomeWallView.m`:
`strongSelf = objc_loadWeakRetained(weak self @+0x38)`; nil → return;
guard `[strongSelf.loadedKey isEqualToString:key]` (receiver is
loadedKey, argument the captured key @+0x20); then
`[UIView transitionWithView:strongSelf.image duration:0.4
options:0x500000 (TransitionCrossDissolve) animations:<block
@0x4a450> completion:nil]`; finally, iff the captured image @+0x28
is nil, `_OMCLogWrite(@"SplitScreen", [NSString
stringWithFormat:@"HomeScreen: khong doc duoc hinh nen %@", path])`
(format cfstring @0x7dfe0, callee resolved as `_OMCLogWrite`
@0x4fbf4 via xref). The animations block @0x4a450 (76 B) is exactly
`^{ strongSelf.image.image = image; }` (captures strongSelf @+0x20,
image @+0x28). The `// STUB-UNRECOVERED` note is gone — the module
now has NO live stub marker. One consequential edit: the file now
imports `SCPCommon.h` for the `OMCLogWrite` declaration (the
module's own convention — cf. SCPCarSplit+Layout.m).

### Item 3 — preset glyph segment block @0x48140: CLOSED (VERIFIED, mechanism corrected)

Both blocks line-read (@0x47e00, 832 B; @0x48140, 136 B).
`SCPDrawPresetGlyph` in `SCPCarSplit+RatioMenu.m` was rewritten;
every INFERRED marking in it is gone. Two mechanism corrections to
the finisher's verified-structure summary: (a) the glyph appends
**rounded-rect cell outlines**, not divider lines — the segment
block takes a CGRect and appends
`bezierPathWithRoundedRect:cornerRadius:` to the captured stroke
path, radius = MIN(MIN(w,h) * 0.5, 2.0) computed from the UNCLAMPED
size, rect dims clamped to ≥ 1.0 via fmaxnm; (b) the inter-cell gap
is **1.6**, not the addendum's "0.2 gap". Verified geometry: grid
x:[3,21], y = 5, height 14 (24×24 canvas); linear branch — width
budget total = 18 − (count−1)·1.6, cell i (1-based) width =
round1(total · preset[i−1]), last cell = 21 − cursor, cursor
advances w + 1.6; mainStack branch — mainW = round1(preset[0] ·
16.4), stack column x = mainRight ? 3 : mainW + 3 + 1.6, width
18 − mainW − 1.6, top height round1(preset[1] · 12.4), bottom cell
at y = 5 + topH + 1.6 with height 14 − topH − 1.6; main cell x =
mainRight ? 21 − mainW : 3. Rounding is frinta (ties away) at 1
decimal, matching C `round()`.

### Syntax check

`clang-18 -fsyntax-only` (arm64-apple-ios15.0, iPhoneOS16.5 SDK,
ARC + blocks) run on all three touched files in a scratch copy (the
shared header carries a pre-existing defect, below, neutralised in
the copy only; an SCPPrefs shim stood in for A's interface, as at
integration). Result: **SCPHomeWallView.m — 0 errors.**
Divider.m / RatioMenu.m error sets are class-for-class identical
before and after these edits (A/B reconstruction): all remaining
errors are pre-existing cross-module merge matters (A-owned
selectors not declared in B's header subset, imports resolved at
integration) — none touches an edited line. **No new errors were
introduced.**

### Flagged for integration (pre-existing, outside this pass's items)

- `SCPCarSplit.h:237–242` — four malformed declarations
  (`dividerDoubleTapped:`, `dividerDoubleTapOn:`, `dividerTapped:`,
  `dividerTapOn:at:`): the `(void` return type is missing its `)`.
  They block every standalone compile of B files and name QA20-era
  selectors that do not exist in 1.0.3 — integration should fix the
  parens or drop the declarations.
- `SCPCarSplit+Divider.m:32` — `@[ @1.0 / 3.0, … ]` in
  `SCPSnapFraction` is NSNumber-pointer arithmetic; needs
  `@(1.0 / 3.0)` / `@(2.0 / 3.0)` to compile.
