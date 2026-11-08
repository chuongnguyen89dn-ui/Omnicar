# Phase 2 — SplitScreen merge (A+B+C) + seams + build

Date: 2026-11-08. Owner: integration subagent. Scope: `project/OmniCarSplitScreen/`
only (src/ read-only). Final build: **PASS** (link + ldid sign, exit 0).

Artifact: `project/OmniCarSplitScreen/.theos/obj/debug/arm64/OmniCarSplitScreen.dylib`
— Mach-O arm64, 969,344 bytes. Final build log:
`project/logs/phase2-splitscreen-build10.log` (rounds 1–10 kept alongside).

## 0. OMCCommon copy (done first, per task)

Copied `src/OMCCommon/{OMCCommon.c, OMCCommon.h}` → `project/OMCCommon/`.

| file | md5 at copy time | md5 now (src == project) |
|---|---|---|
| OMCCommon.c | `cb8afa107945c29cc2bce1befb999feb` | same |
| OMCCommon.h | `951b0e341f3ba79ff0d6f0802525d79e` | same |

Note: during the session the src OMCCommon.c changed under another agent
(first probe read `1f8a90b2…`, the copy took `cb8afa10…`); the project copy
matches current src byte-for-byte at delivery time.

Toolchain verified before building (per AGENTS.md rule): clang-18 present
(dpkg `ii 1:18.1.3-1ubuntu1`), `/usr/bin/ld.lld -> ld.lld-18`, ldid at
`/usr/local/bin/ldid`. `fix-toolchain.sh` not needed. All builds run with
`umask 022`, `THEOS=~/theos`, `make clean; make`.

## 1. Merge account

Fresh copies from current src (phase-1 project copies were stale in 9
files), flat into `project/OmniCarSplitScreen/`:

- **A (8 .m + headers):** SCPCarSplit.m, SCPHooks.{h,m}, SCPPrefs.{h,m},
  SCPShared.{h,m}, SCPSmallClasses.{h,m}, SCPSpringBoardHooks.m,
  SCPCarPane.h, SCPPerfTelemetry.{h,m}, SCPSessionCore.{h,m}.
  A's phase-2 seam fixes were already in src (13 underscore renames,
  signature adjudications, SCPHomeKick/SCPSyntheticLaunchInfo removed,
  2-arg SCPMissingSelector) — the re-copy includes them.
- **B (14 .m + headers):** SCPCButton.{h,m}, SCPCTouchWatch.{h,m},
  SCPCarDividerView.{h,m}, SCPCarSplit+{Chrome,Divider,Drag,Layout,Panel,
  Picker,RatioMenu,Zoom}.m, SCPCarSplitView.{h,m}, SCPCarTabView.{h,m},
  SCPCommon.h, SCPHomeWallView.{h,m} — post-finisher versions (Divider
  dismiss correction, SCPHomeWallView applySettings block, RatioMenu glyph
  rewrite) confirmed present in the copied files.
- **C (8 .m + 1 header):** SCPAppIcons.m, SCPCarApps.m, SCPDiagDump.m,
  SCPHomeApply.m, SCPHomeCommon.h, SCPHomeHooks.m, SCPHomeSettings.m,
  SCPHomeVisibility.m, SCPLibRoot.m. C's de-static'd hook bodies + unified
  Orig slots confirmed in src; SCPHomeApply declared in SCPShared.h:82;
  SCPIconModelClass definition confirmed in src SCPHooks.m (~line 424).
- Kept from phase 1: `SCPIntegrationShims.h`, Makefile, tweak plist.

### Header merges (name collisions A vs B)

**SCPCarSplit.h** — one merged header. Base = A's main interface
(script-verified: A's and B's property sets are identical, 65 properties);
imports extended with `SCPCarSplitView.h`/`SCPCarDividerView.h`;
`dividers` typed `NSMutableArray<SCPCarDividerView *>` (B's spelling).
B's category declarations pruned where they conflicted with A's
implementations (A's bodies are canonical; B header types were looser):
layoutChosenID: (A BOOL), paneSize:forBundle: (A CGRect),
soloBundle:/hostSolo:/hostPassInsetsForPane: (see §5). Picker/Panel/
RatioMenu categories added from B's headers.
**SCPCarPane.h** — B's copy kept (property sets script-verified identical,
18 properties; B's copy adds the ivar-offset table), merge note prepended.

### Handoff verdict (`src/SplitScreenB/handoff/`)

NOT compiled — its own header marks it cross-check material, not a build
unit; 9 of its methods duplicate A's `SCPCarSplit.m`, and
SCPNoopLayoutAssertion duplicates `SCPSmallClasses.m`. **Exception:**
`SCPCarSplit+Relayout.m` was created in the project, extracting ONLY
`-relayoutAnimated:` and `-relayoutAnimated:pushScenes:` verbatim from the
handoff — no A/B/C source implements them (A only calls them; A's header
assigned them to B). Category `(Layout)`.

### Duplicate adjudicated by binary dump

`-anyBarVisible`: two bodies existed (A: reads `pane.hostBar`; B Chrome:
sends `bar`+`isHidden`). A's own dump `SCPCarSplit__anyBarVisible.txt`
@0x3d058 iterates panes sending `bar` then `isHidden` = B's body. A's copy
removed from project SCPCarSplit.m (evidence comment left in place).

## 2. Perf-cluster hoist (task item 2)

In project `SCPPerfTelemetry.m`, `static` removed from the 32 shared state
variables named by the SessionCore seam note (gPerfSessionObject,
gPerfDisplayLink, gPerfSource, gSessionStart, gSessionTweaks, gStatHangWho,
gLiteReason, gDisconnectCount, gStatFrameInterval, gStatWorstMs,
gStatLateFrames, gStatFrames, gStatLastTick, gStatHangMaxMs, gStatFreezes,
gStatHangs, gStatMemMB, gStatMemLastMB, gStatCPUMax, gStatCPUSum,
gStatSysFreeMinMB, gStatAvailMinMB, gStatCPUCount, gStatThermalMax,
gStatLowPower, gLateAtLinkStart, gFramesAtLinkStart, gStatLatePct,
gHangTimes, gLiteCount, gAutoLiteOn, gSamplerMainBusy) and from functions
**OMCFlushPerfStats** and **OMCAutoLiteEvaluate**, so SCPSessionCore.m's
externs link. Perf-internal statics stayed static (gCrashState,
gSampleDivider, sTimebase, gHostPort, gHostPageSize, gLiteStateChangedAt,
gPerfTicker, gLiteNotifySetToken). Also in `SCPSessionCore.m`:
`gStatMemPeakMB` → `gStatMemMB` ×3 (canonical name per OMCCommon.c slot
0x88320).

Structural note: OMCCommon.c keeps its own perf/session machinery
`static`, so there is no link collision — but the merged dylib therefore
contains two copies, and `_OMCCrashGuard` (inside OMCCommon.c) binds to
the static ones. Dedupe is a coordinator-level decision (same pattern as
the earlier BLOCKER-CORE-PREFS), out of this task's scope.

## 3. Name choice: SCPKnobFaceView (task item 5)

**Winner: `SCPKnobFaceView`.** Factory @0x35c74 had two candidate names:
`SCPKnobFaceView` (declared in SCPCommon.h; body in SCPCarDividerView.m)
vs `SCPBlurEffectView` (duplicate definition in SCPCarSplit+Chrome.m).
Binary arbiter: disassembly @0x35cec loads `mov w2, #0xb` = style **11** =
`UIBlurEffectStyleSystemUltraThinMaterialLight` (SDK enum order verified
against the iPhoneOS16.5 SDK header) — exactly the Divider body. Chrome's
body used `UIBlurEffectStyleSystemMaterialLight` = 13, contradicting the
binary. Callers of 0x35c74 in the binary: layoutKnobOf, buildPickerSheet,
showLayoutPanel, SCPStyleRatioMenu. Actions: Divider definition kept
(return type respelled `UIVisualEffectView *`, body byte-identical),
Chrome's duplicate definition deleted, all references in Panel/Picker/
RatioMenu unified to `SCPKnobFaceView`, single declaration in SCPCommon.h.
Zero code references to `SCPBlurEffectView` remain (one historical comment
mentions the old name).

## 4. Mechanical fixes applied in project copies (build rounds 1–10)

Task-named items:
1. `SCPCarSplit+Divider.m:32` — `@[ @1.0/3.0, @0.5, @2.0/3.0 ]` →
   `@[ @(1.0/3.0), @0.5, @(2.0/3.0) ]` (NSNumber-pointer arithmetic).
2. Merged `SCPCarSplit.h` — the 4 malformed QA20-era declarations at B
   header lines 237–242 removed per task item 3 (dividerDoubleTapped:,
   dividerDoubleTapOn:, dividerTapped:, dividerTapOn:at: — absent from
   1.0.3; B's Divider.m implements the real ones with correct signatures).
3. Phase-1 fixes re-applied: `SCPGuardedSend` de-static'd (SCPShared.m);
   in C's SCPHomeHooks.m, `SBIconImageInfoCompat` typedef moved above the
   Orig slots and the slot return type spelled with the compat type.
4. `SCPHomeApply.m` import flattened (`../SplitScreenB/…` → flat).
5. `SCPCarSplit.m` closeSlot: `[self closeFloat]` → `[self closeFloat:background]`
   (objc.json proves only `closeFloat:` exists).
6. ARC adaptation in `SCPPerfTelemetry.m` (OMCAutoLiteEvaluate): 6 explicit
   retain/release sends converted to strong assignment, mirroring the
   shared unit's ARC-compiled twin in OMCCommon.c.
7. Imports added: `SCPCommon.h` → Chrome/Divider/Drag/Panel/Picker/
   RatioMenu/Zoom .m; `SCPCButton.h` → Chrome/Panel/Picker/RatioMenu;
   `SCPPrefs.h` imported at top of `SCPCommon.h` (its category needs the
   primary interface); `SCPDispatchAfter` extern added to
   `SCPIntegrationShims.h` (importing SCPShared.h into B TUs would clash
   with SCPCommon.h spellings); `SCPSmallClasses.h` imported by Zoom.m;
   `SCPCarPane.h` imported by SCPSmallClasses.m.
8. Header/impl type corrections against objc.json encodings:
   `handleShiftForPane:` returns double (@0x23ab4); Drag
   `movePaneDragTo:from:` 2nd arg and `endPaneDrag:` arg are `SCPCarPane *`;
   Picker decls showPickerForSlot:(int), showBackgroundToastFor:(NSString *)
   slot:(int), pickerCancel:(UIView *); added decls `trayWindowForParent:`,
   `hideTrayWindowIfIdle`, `restartTrayTimer`; Divider fractionsMatch cast;
   merged `@interface SCPCarSplit` gained `<UIScrollViewDelegate>`
   (B TUs assign `scroll.delegate = self`).
9. `SCPCarSplit+Layout.m`: newline restored — src had
   `- (BOOL)dividerRunsHorizontally:` swallowed inside a `//` comment.
10. Chrome: `popupsClosedAt` assigned via
    `[[NSDate date] timeIntervalSince1970]` (property is double per
    objc.json + both headers); two `(SCPCTouchWatch *)self.popupShield`
    casts.
11. Makefile: `_FILES` extended to all 31 merged .m (+ OMCCommon.c via
    OMCCommon.mk); frameworks UIKit/Foundation/QuartzCore/AVFoundation/
    CoreG

---

## Damage note (added 2026-11-08, remediation — not part of the original log)

- **What happened**: in its first publication this log ended at a
  truncation marker; everything after the cut is lost (~7,370
  chars). The file breaks off mid-word in §4 item 11 above
  ("…AVFoundation/ CoreG"), inside the mechanical-fix list for
  build rounds 1–10.
- **What was lost**: the remainder of §4's fix list and any
  closing sections the log carried (per-round build outcomes
  and SplitScreen-specific diff detail). The lost text is NOT
  reconstructed here — this is a historical log, no surviving
  copy of its tail exists, and no line of it has been rewritten
  or invented.
- **The module's conclusions**, as recorded in the aggregate
  `project/BUILD_PHASE2_LOG.md` §4 (which survives intact):
  A+B+C merged flat and the component built PASS in the phase-2
  aggregate (exit 0, zero errors); the perf-cluster hoist was
  done with the `gStatMemPeakMB`→`gStatMemMB` rename;
  `SCPKnobFaceView` is the binary's name (factory @0x35cec,
  style 11) and Chrome's `SCPBlurEffectView` was deleted with
  all call sites unified; 6 extern link-closure bodies were
  transcribed into SCPShared.m (SCPMissingSelector @0x4f330,
  SCPInfoBool, SCPAppHasCarPlayUI, SCPAppIconForBundle,
  SCPResetDetachedView, SCPLayoutElementKey); 3 census-unclaimed
  Panel-called methods were transcribed (exitKeepBundle /
  exitTapped / atHomeScreen); an empty `@implementation
  SCPCarPane` was added (accessors auto-synthesise, verified in
  the dylib); phase-2 fingerprint: 11→11 classes, 480→481
  methods (+1 = category counting), 0 original defined symbols
  missing.
- **Later corrections to this log's §4**, recorded so the
  surviving text is not misread: the four divider declarations
  whose removal §4 item 2 describes were RESTORED in phase 3
  (the removal premise was refuted by the binary's method
  list — `project/BUILD_PHASE3_LOG.md` step 1), and the final
  SplitScreen method count is 480 = 480 exact.
- **Discovered**: 2026-11-08, during the coordinator's
  handover review; repaired the same day by this note only.
