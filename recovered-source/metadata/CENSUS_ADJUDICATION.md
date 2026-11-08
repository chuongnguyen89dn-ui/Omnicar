# Census Adjudication — FUNCTION_SOURCE_MAP.tsv

Date: 2026-11-08. Scope: every UNCLAIMED, multi-claimed and CLAIMED_STUB row of
`metadata/FUNCTION_SOURCE_MAP.tsv` (3,280 rows: 1,872 ObjC methods + 1,408 C
functions, 8 binaries), adjudicated row-by-row against `src/` and against the
original binaries via `verify/macho_truth.py` + `metadata/xref/*.json`.
The TSV and the census script were NOT modified.

## Verdict in one paragraph

Of the 675 UNCLAIMED rows, **664 are bookkeeping artefacts of the heuristic
census** (compiler-generated functions, block machinery, statically-linked
library copies, and shared-unit helpers whose bodies exist in `src/` but carry
no per-binary address annotation for the census to credit). **11 rows are
genuinely missing bodies** — listed exhaustively in §6. All 8 CLAIMED_STUB
rows are false positives (§4). The 301 CLAIMED_MULTIPLE and 54
EXPECTED_MULTIPLE rows are explained by three structural causes (§5).
Separately, §7 documents a census blind spot the review did not count:
methods the census marks CLAIMED whose `src/` bodies are one-line INFERRED
placeholders — the parents of five of the missing helpers among them.

## 1. Count verification (recounted from the TSV, not copied)

| status | rows |
|---|---|
| CLAIMED | 2,242 |
| UNCLAIMED | **675** |
| CLAIMED_MULTIPLE | **301** |
| EXPECTED_MULTIPLE | 54 |
| CLAIMED_STUB | **8** |
| total | 3,280 |

The review's numbers (675 / 301 / 8) are confirmed exactly. Note the review's
"301 multi-claimed" is the CLAIMED_MULTIPLE set only; EXPECTED_MULTIPLE (54)
is a separate, intentional status and is adjudicated alongside it in §5.

UNCLAIMED per binary: App 3, Core 27, AppBridge 91, CarProbe 10,
SpeedBubble 114, SplitScreen 160, StartupScreen 104, Prefs 166 (= 675).
Composition: 73 ObjC methods + 602 C functions.

## 2. Unclaimed methods — 73 rows, 4 groups

| group | n | rule / evidence |
|---|---|---|
| `.cxx_destruct` | 51 | Compiler-synthesized under ARC; no source body exists by construction. |
| Block-typed `@property` accessors | 14 | The `@property` EXISTS in src for every row; the census parser cannot parse block declarators `(^name)(...)`. E.g. SPPBubbleView `log`/`setLog:` (SPPBubbleView.m:49, SPPBubble.m:61, OMCPrefs/SPPBubbleView.h:19); SCPCTouchWatch `exempt`/`outside` + setters (SplitScreenB/SCPCTouchWatch.h:22,26); SCPCarSplitView `touched` (SplitScreenB/SCPCarSplitView.h:21); SSLocationOnce `done` (StartupScreen header, line 84); OMCOnboardingController `completion` (OMCPrefs/OMCOnboardingController.h:17). |
| Multi-declarator `@property` accessors | 6 | The parser credits only the LAST declarator of a multi-name `@property` line — proven experimentally: `double inA, inB;` → inB CLAIMED, inA not; `double max, red;` (SSStartupScreen.h:262) → red CLAIMED, max not. Rows: SSFade `inA`/`setInA:`/`outA`/`setOutA:`, SSGauge `max`/`setMax:`. |
| **Genuinely missing** | **2** | §6, items M1–M2. |

Direct proof for the missing pair: the rebuilt Prefs binary's
`OMCAppBridgeAppsController` has 103 methods vs the original's 105, and the
set difference is exactly these two selectors — so the phase-3 aggregate
"Prefs 743/743" masked a real class-level gap.

## 3. Unclaimed C functions — 602 rows, 12 groups

Adjudication instruments: (a) block-literal/descriptor structure resolved
through chained fixups in the original binaries; (b) call-graph position
(BL callers / address-taken parents) from `metadata/xref`; (c) exact
(size, string-set, call-set) fingerprint twins against CLAIMED rows in other
binaries; (d) distinctive-string grep over `src/`; (e) manual disassembly
review of the residue. Matching against the REBUILT binaries was attempted
and abandoned: the rebuilt code calls plain `_objc_msgSend` (no per-selector
stubs), so selector fingerprints do not exist on that side — this is also
why the phase-3 verifier could only compare counts/symbols, not bodies.

| # | group | n | adjudication rule |
|---|---|---|---|
| 1 | BLOCK_INVOKE (global) | 77 | Invoke pointer of a block literal whose isa resolves to `__NSConcreteGlobalBlock` (via xref blocks ∪ literal scan of `__DATA_CONST,__const`). The literal sits inside a claimed body or data of a claimed unit. |
| 2 | BLOCK_INVOKE_STACK | 189 | Address-taken in exactly one parent function; a `__const` descriptor load and/or `_NSConcreteStackBlock` GOT load sits within ±14 insns of the address computation in that parent → stack-block invoke of a block literal written in the parent's src body. |
| 3 | BLOCK_COPY_DISPOSE | 78 | Referenced from a block descriptor's copy (+16) or dispose (+24) slot; slot accepted only if the descriptor passes the structural test (reserved==0, plausible size, sibling slot is a func start). |
| 4 | LIBROOT + PROTECTION-GENERATED | 94 | The 0x4000–0x44a4 cluster repeated identically in every binary is the statically linked libroot shim (opa334 libroot): bodies reconstructed VERIFIED with address annotations in `src/CarProbe/OmniCarCarProbe.m` (line 64ff) — trampolines 0x4000/0x4040/0x4080/0x40c0, fallbacks 0x42ac/0x42b8/0x42c4/0x42d0/0x4384. Other binaries' copies are unclaimed only because their module sources did not repeat the annotations. Plus generated registration stubs (20-byte two-pointer tail-call stubs into a common resolver, e.g. Core sub_d050 → resolver 0xd284), lazy dispatchers and const getters produced by the protection/codegen layer. |
| 5 | VENEER_THUNK | 19 | Single 4-byte `b #target` branch veneers (e.g. CarProbe sub_b000 → `b #0xa3ac`), each BL-called from exactly one site; the target body is the claimed function. |
| 6 | SIZE0_ALIAS | 7 | Zero-length duplicate func-starts; the aliased address carries the code. No separate body exists. |
| 7 | MH_HEADER | 1 | OmniCar 0x0 `__mh_execute_header` — the Mach-O header, not a function. |
| 8 | SHARED-TWIN helpers | 92 | No symtab name and no address annotation, but an identical (size, strings, calls) fingerprint twin is CLAIMED in another binary — overwhelmingly the OMCCommon file-static helpers statically embedded per binary (dict builder 324 B: AppBridge 0x23434 = SpeedBubble 0x26c50 = StartupScreen 0x20d14; log rotation 192 B; perf snapshot 1,404 B with `availMinMB`/`cpuAvg`; hook check 364 B; crashguard 68/76 B …). The census binds shared-unit annotations only to one binary's addresses, so the other copies go uncredited although the body is in `src/OMCCommon/`. |
| 9 | SRC-GREP helpers | 14 | No claimed twin, but a distinctive string (≥9 chars with a space, or ≥16 chars) from the function's own string set is found inside a src body file. |
| 10 | INDIVIDUAL — covered | 21 | Residue adjudicated one-by-one in §3.1. |
| 11 | App global block invoke | 1 | OmniCar 0x45e4 (VA 0x1000045e4): literal at 0x1000080c0, isa binds to `__NSConcreteGlobalBlock`, invoke slot at 0x1000080d0. (The App binary's offset-vs-VA keying hid it from automated passes; `_main` @0x100004688 is a separate, claimed row.) |
| 12 | **GENUINELY MISSING** | **9** | §6, items C1–C9. |

Sum: 77+189+78+94+19+7+1+92+14+21+1+9 = **602** ✓

### Spot checks (≥5 per major group, re-run for this report)

- Group 1: SplitScreen 0x56034 (literal 0x79560), Core 0x7ca4 (0x146a8),
  SplitScreen 0x50148 (0x79380), AppBridge 0x1e284 (0x34bd0), AppBridge
  0x23110 (0x34d30) — all five literals' isa → `__NSConcreteGlobalBlock`.
- Group 2: sampled parents are claimed methods whose src bodies contain the
  block literals — `-[SCPCarSplit refreshPickerSheetSoon]` (Picker.m; 16
  animate/dispatch block sites in that file), `-[OMCSpeedBubbleController
  layoutSourcesIn:width:]`, `-[SSStartupView playIntro]`,
  `-[SCPCarSplit ensureContainer]`.
- Group 3: StartupScreen 0x8efc ← descriptor 0x30a18 slot +16; Prefs 0x16efc
  ← descriptor 0x747f0 slot +16 with its pair 0x16f2c at slot +24 of the
  SAME descriptor; StartupScreen 0xa58c ← 0x30b08 +16; Prefs 0x17640 ←
  0x74820 +16.
- Group 8: SpeedBubble 0x26c50 (324 B) twin = Core 0xc2bc CLAIMED by
  OMCCommon/OMCCommon.c; StartupScreen 0x1fc3c (88 B) twin = Core 0x4118 /
  0xb1e4 (OMCCommon.c); Prefs 0x2d620 (156 B) twin = SpeedBubble 0xe27c
  (SPPBubbleView.m); Core 0x42d0 twin = CarProbe 0x42d0 (annotated) —
  confirming the libroot reading of group 4.
- Group 9: StartupScreen 0x79d0 (`com.anlai.omnicar/startupscreen.audio.play`
  in SSStartupScreen.h); StartupScreen 0x8bf0 (`weather: SpringBoard did not
  answer in 10s` in SSSplash.m); Prefs 0xf260 (`/Library/MobileSubstrate/
  DynamicLibraries` in OMCPrefs/OMCCommon.m); Prefs 0x1c620 (`LSApplicationProxy`
  in OMCCommon/OmniCarCore.c).

### 3.1 The 28-row residue (no twin, no grep hit) — individual verdicts

Covered (21):
- AppBridge 0x560c, 0x5694 — hook IMPs for `becomeFirstResponder`
  (UITextField/UITextView FR hook set 0x560C–0x56F8, tabled VERIFIED in
  AppBridgeB_REPORT.md); registered by address from the claimed installer
  sub_4728; bodies in `src/AppBridgeB/ABInApp.m` (MSHookMessageEx at
  lines 109/113, hook IMPs documented in-file).
- AppBridge 0x180c0 — Telex string-transform static called from the claimed
  `_ABTelexApply`; statics live in `src/AppBridgeB/ABTelex.m`.
- SpeedBubble 0x1c544, 0x1c5d8 — block invokes inside the claimed
  `-[SPPBubble menuTapped:]` (SPPBubble.m:1078ff, animateWithDuration blocks;
  calls baseTransform/clampCard/setTransform + applyCrispScale/
  saveCardPosition match the src block bodies).
- StartupScreen 0x702c — 8-byte completion-block invoke in the claimed
  `-[SSSplash dismissBecause:]`: SSSplash.m:301-304 is literally
  `completion:^(BOOL finished) { [self tearDown]; }`. (The module report's
  INFERRED tag for this row was over-cautious.)
- Prefs diag family 0x9664, 0x9488, 0x9ea0, 0xf6c0, 0xf0f0, 0xf76c, 0x9da8,
  0x93b8, 0x95f8 — static helpers of the claimed `_OMCDiagSections` /
  `_OMCDiagChecks`, bodies in `src/Prefs/OMCPrefs/OMCCommon.m`. Spot proof:
  0x93b8 ↔ the `@{@"label":…, @"value":…}` row builder at line 618;
  0xf0f0 ↔ the `OMCCheck` builder (status/fix/action keys) at ~line 793;
  0x95f8 ↔ thermal-state code at line 899; 0x9ea0/0xf6c0 ↔
  `localizedStringFromDate:` formatter at line 658.
- Prefs 0x28448, 0x54848 — the two image-renderer statics of
  `src/Prefs/OMCPrefs/OMCSpeedBubbleController.m` (`SPPAppIconForSource`,
  annotated "sub_2642c", and `SPPMapImage`); call signature
  imageWithActions:/initWithSize:format:/preferredFormat/setOpaque: matches.
  (Src uses initWithSize: in one of the two — an API-form simplification,
  not a missing body.)
- Prefs 0x257e4, 0x259ec — gradient statics called only from stack-block
  invoke sub_25150, itself created inside CLAIMED sub_22df0
  (OMCHSPreview.m) — the HSPreview rendering cluster; bodies in that unit.
- Prefs 0x43ce0, 0x43338 — alert-action handler block invokes in the claimed
  `-[OMCStartupScreenController chooseLogo]` / `-[addVideo]`:
  OMCStartupScreenController.m:940 `handler:^(UIAlertAction *a) {
  [self logoFromFiles]; }`, :889 the same for `importFromFiles`.
- Prefs 0x13d9c — 8-byte completion-block invoke in the claimed
  `-[OMCOnboardingController finish]`: OMCOnboardingController.m:331-333
  `completion:^{ [self runCompletion]; }`.

Missing (7): SplitScreen 0x41358, 0x41898, 0x431c0, 0x42564, 0x3eb24;
Prefs 0x10bf4, 0x73a8 → §6.

## 4. CLAIMED_STUB — 8 rows, all FALSE POSITIVES

All 8 are in OmniCarSplitScreen, claimed by SplitScreenB/SCPCarSplit+Picker.m
or +Panel.m. Every one has a real, substantial body in src. Each definition
is preceded by a `// CLOSED (was STUB-UNRECOVERED): …` provenance comment;
the literal word STUB in that comment trips the census stub heuristic.

| row (method) | src location | body |
|---|---|---|
| `-[SCPCarSplit buildPickerSheetForPane:]` | +Picker.m:254 | ~299 lines |
| `-[SCPCarSplit pickerMapForPane:height:]` | +Picker.m:604 | ~67 lines |
| `-[SCPCarSplit showLoaderInPane:bundle:]` | +Picker.m:900 | ~108 lines |
| `-[SCPCarSplit toast:duration:]` | +Picker.m:1033 | real body (1-arg sibling `toast:` at :1024) |
| `-[SCPCarSplit showBackgroundToastFor:slot:]` | +Picker.m:1084 | ~70 lines |
| `-[SCPCarSplit showLayoutPanelForApp:]` | +Panel.m:173 | ~259 lines |
| `-[SCPCarSplit panelSections]` | +Panel.m:442 | ~51 lines |
| `-[SCPCarSplit panelChoiceTappedUnsafe:]` | +Panel.m:509 | ~20 lines |

Verdict: 0 of 8 are stubs. Recommended census fix (not applied): exclude
`CLOSED (was STUB…)` provenance comments from the stub detector.

## 5. Multi-claimed rows — 301 CLAIMED_MULTIPLE + 54 EXPECTED_MULTIPLE

Grouped by claiming-file pattern (counted from the TSV):

CLAIMED_MULTIPLE (301 = 222 methods + 79 cfuncs):
- **266 — parallel A/B duplicate tree.** The reconstruction keeps two
  parallel source trees (AppBridgeA + AppBridgeB, SplitScreenA +
  SplitScreenB); both trees' headers/impls legitimately define or declare
  the same rows (e.g. ABHost/ABPane @property rows in both ABHost.h copies;
  SCPCarPane/SCPCarSplit rows in SplitScreenA/*.h and SplitScreenB/*.h;
  SCPCarSplit methods in SplitScreenA/SCPCarSplit.m and SplitScreenB/
  handoff/SCPCarSplit+Layout_A-owned.m). The build uses one of them; the
  census credits both.
- **33 — cross-module mention.** An extra file declares, logs or annotates
  the symbol (e.g. a module umbrella header such as AppBridgeB.h also
  declaring an OMC symbol), so a row with exactly one definition gains a
  second "claim".
- **2 — shared OMCCommon unit + module copy.**

EXPECTED_MULTIPLE (54, all cfuncs — by design, not an anomaly):
- 39 shared OMCCommon unit + module copy (the ~20-function OMC core is
  statically embedded in every binary and declared in both the shared unit
  and the module copy), 8 parallel A/B tree, 7 header+impl of the same unit.

No multi-claimed row indicates a missing or duplicated *definition*; the
counts are an artefact of the two-tree layout plus the shared-unit design.

## 6. BOTTOM LINE — genuinely missing bodies: 11

Present in the original binaries; no body anywhere in `src/`.

Methods (2), both OmniCarPrefs, class OMCAppBridgeAppsController — 12-byte
tail-call shims (`mov x0, x3; mov w1, #1/#0; b _OMCStyleHeaderFooter`).
Sibling controllers implement their own one-liners against the 1-arg src
wrapper `OMCStyleHeaderFooter(view)` (OMCPrefs/OMCCommon.h:109), but this
controller's two delegate methods were never written:
- M1 `-[OMCAppBridgeAppsController tableView:willDisplayHeaderView:forSection:]` (orig IMP 0x20084)
- M2 `-[OMCAppBridgeAppsController tableView:willDisplayFooterView:forSection:]` (orig IMP 0x200f8)

C functions (9):
- C1 OmniCarSpeedBubble 0x239a0 — `__init_3`, the 4th `__init_offsets`
  entry (208 B; the other 16 initializers across all binaries are claimed).
  Decoded: compares `[NSProcessInfo processInfo].processName` against
  `@"SpringBoard"` / `@"CarPlay"` and dispatch_async's a block to the main
  queue on match. `grep processName` finds no occurrence in src/SpeedBubble.
- C2 OmniCarSpeedBubble 0x23a70 — the dispatch block invoke created by C1;
  missing because its only parent is C1.
- C3 OmniCarSplitScreen 0x41358 (1,344 B) — recursive view-tree walker
  called from the original `-[SCPCarSplit launcherCenterInParent:size:shift:]`.
- C4 OmniCarSplitScreen 0x41898 (844 B) — status-bar/battery view finder
  (`_UIBattery`/`_UIStatusBar` class-name search), same parent as C3.
  Neither string appears in any src .m file.
- C5 OmniCarSplitScreen 0x431c0 (744 B) — recursive tree-dump logger
  (` hidden` / ` noTouch` annotations) called from the original
  `-[SCPCarSplit dockHostForRect:inParent:]`.
- C6 OmniCarSplitScreen 0x42564 (404 B) — home-button glyph renderer
  (UIGraphicsImageRenderer) called from the original
  `-[SCPCarSplit refreshHomeButton]`.
- C7 OmniCarSplitScreen 0x3eb24 (172 B) — block invoke created inside the
  original `-[SCPCarSplit hostApp:inPane:]` (bundleID compare +
  removeLoaderFromPane:animated: — a loader-timeout block). The src body of
  hostApp:inPane: is otherwise complete but contains no such block.
- C8 OmniCarPrefs 0x10bf4 (272 B) — share-report log-section formatter
  called from `_OMCShareReport`: formats `\n==== %@ (%@) ====\n%@\n` and
  reads file data with an `(empty / not found)` fallback. Src's
  OMCShareReport folds a variant inline (`\n== … ==\n`, different format,
  no fallback string) — the discrete body does not exist.
- C9 OmniCarPrefs 0x73a8 (196 B) — conflicting-tweaks name normalizer
  called from `_OMCConflictingTweaks` (alphanumericCharacterSet +
  invertedSet + componentsSeparatedByCharactersInSet: + lowercaseString).
  Src's OMCConflictingTweaks normalizes with plain `lowercaseString` only;
  `alphanumericCharacterSet` appears nowhere in src/Prefs.

Total: 664 of 675 unclaimed rows adjudicated as bookkeeping;
**11 genuinely missing** (2 methods + 9 C functions).

## 7. Corollary — CLAIMED-but-placeholder bodies (outside the 675)

The census credits a method if a definition exists; it cannot see that the
definition is a placeholder. In `src/SplitScreenA/SCPCarSplit.m`
(~lines 1630–1660, under the file's own comment "reconstructed at
call-sequence fidelity … only had their signatures verified"), the following
CLAIMED methods are INFERRED one-line stubs: `refreshHomeButton` (`{}`),
`dockClusterInParent:` (returns nil), `launcherCenterInParent:size:shift:`
(returns CGPointZero), `setDockShift:` (ignores its argument),
`dockHostForRect:inParent:` (returns nil), `installIconLongPress` (`{}`),
`installLongPressIn:depth:`, `iconLongPressed:`, `iconLongPressedUnsafe:`.
C3–C6 above are precisely the helpers of the first, third and fifth of
these. SplitScreenB contains call sites but no alternative implementations
of them. This is the same INFERRED pocket the external review flagged from
the other side (repairPresentedViewController:, pushSceneSizes, …): those
rows pass the census while carrying no recovered logic. Any future
"completeness" figure must therefore be quoted as: census rows resolved
3,269/3,280 (11 missing) MINUS the INFERRED-placeholder pockets, which this
adjudication did not exhaustively enumerate beyond the SplitScreenA cluster
found here.

## 8. Residual uncertainties (stated, not hidden)

- Group 4's REG_STUB20 semantics (20-byte stubs into a common resolver) are
  inferred from shape and call pattern; the libroot portion (incl. the ten
  0x42d0/0x4384 rows) is VERIFIED via CarProbe's annotated reconstruction
  and cross-binary twins, but the registration-stub sub-family has no
  ground-truth name source.
- Group 2's test is structural (±14-insn window). A stack-block invoke
  whose parent builds the literal further away would fall out of the group;
  the residue pipeline (§3.1) caught the observed cases of that shape
  (0x43ce0, 0x43338, 0x13d9c, 0x702c pattern), and one genuine miss of the
  same shape (C7) was found by hand — the group count should be read as
  "189 ± a small number, with all exceptions individually listed in §3.1/§6".
- Fingerprint twins (group 8) prove an identical-shape body is claimed
  somewhere; they do not prove the claiming file's body is byte-faithful —
  that is the reconstruction's own VERIFIED/INFERRED labelling question,
  outside this census adjudication.

Scratch instruments (not deliverables): ~/workspace/census-scratch/
(pipeline.py, fingerprint.py, twinmatch.py, evidence*.json).

---

## Addendum — CLOSURE-2 (2026-11-08): the 11 genuinely missing bodies are now 0

Appended by the CLOSURE-2 pass. Every body below was reconstructed from
the ORIGINAL binary only (payload extraction), ground truth via
verify/macho_truth.py + capstone dumps WITH skipdata, decoded length
checked against LC_FUNCTION_STARTS. Dumps are saved as
src/<Module>/disasm/rem2_*.txt and cited per item.

### C3–C6 (SplitScreen helpers) — closed earlier by the INFERRED-closure agent
Reconstructed as helpers inside src/SplitScreenA/SCPCarSplit.m:
C3 sub_41358 → SCPFindHomeGlyph; C4 sub_41898 → SCPScanStatusBarBaseline;
C5 sub_42564 → SCPLauncherGlyphImage; C6 sub_431c0 → SCPDumpDockTree.
(That agent's SCPWalkerSafeGet / SCPWalkerIconBundleID extern
declarations in the same file are matched by the link fix below.)

### The seven CLOSURE-2 closures
- M1 — -[OMCAppBridgeAppsController tableView:willDisplayHeaderView:forSection:],
  IMP 0x20084 (OmniCarPrefs): 12-byte tail-call shim
  (mov x0,x3; mov w1,#1; b _OMCStyleHeaderFooter). Body added to
  src/Prefs/OMCPrefs/OMCAppBridgeAppsController.m.
  Dump: src/Prefs/disasm/rem2_M1M2_willDisplayShims.txt.
- M2 — -[OMCAppBridgeAppsController tableView:willDisplayFooterView:forSection:],
  IMP 0x200f8: same shim with w1 = #0. Same file, same dump.
  (M1+M2 restore the class to 105/105 methods vs the original.)
- C1 — SpeedBubble __init_3 @0x239a0: gates on
  [NSProcessInfo processInfo].processName being @"SpringBoard" or
  @"CarPlay"; on match, dispatch_async to the main queue.
- C2 — C1's block invoke @0x23a70: OMCLogWrite build stamp
  ("fbebb21"/"1.0.3"), then CFPreferencesSetAppValue of
  {version, build, date} under key "diagLoaded.SpeedBubble.<process>"
  in app domain com.anlai.omnicar + CFPreferencesAppSynchronize.
  C1+C2 live in src/SpeedBubble/SPPDisplayBoot.m as SPPDisplayInitDiagStamp
  (name INFERRED). Dumps: rem2_C1_init3.txt, rem2_C2_init3_block.txt.
- C7 — SplitScreen loader-timeout block invoke @0x3eb24, inside
  -hostApp:inPane: (parent IMP 0x3e490). Whole parent method re-read and
  corrected in src/SplitScreenA/SCPCarSplit.m: the binary schedules TWO
  __weak blocks via SCPDispatchAfter (helper @0x12efc) — +0.05 s
  (post-open frame report) and +8.0 s = C7 (weak pane nil or bundleID
  mismatch → return; else removeLoaderFromPane:animated:YES). Other
  corrections from the same line-read: detach uses background:YES;
  hosted view frame = pane.host.bounds, autoresizingMask 0x12, added to
  pane.host; pane.sceneSize = CGSizeZero, pane.hostFrame = CGRectNull,
  hostHandle = NO; focusedSlot skipped for slot 9; no synchronous
  sendHostFrameForPane: call exists in the binary.
  Dumps: rem2_C7_hostAppInPane_parent.txt, rem2_C7_block1_3e8f4.txt,
  rem2_C7_block_3eb24.txt, rem2_delay_helper_12efc.txt (SplitScreenB/disasm).
- C8 — Prefs sub_10bf4 @0x10bf4, share-report section formatter: reads
  the file as UTF-8, falls back to ISO Latin-1 data decoding, appends
  "\n==== <title> (<path>) ====\n<content or (empty / not found)>".
  Reconstructed as static OMCShareAppendLogSection in
  src/Prefs/OMCPrefs/OMCCommon.m; _OMCShareReport's inline variant
  replaced by the binary's two calls, .old first (@0x107e4), then the
  live log (@0x10800). Dumps: rem2_C8_shareSection.txt,
  rem2_C8_caller_ShareReport.txt.
- C9 — Prefs sub_73a8 @0x73a8, conflicting-tweaks normalizer:
  lowercaseString, then strip every character outside
  alphanumericCharacterSet. Reconstructed as static
  OMCNormalizeTweakName in the same OMCCommon.m and wired at the proven
  call sites in _OMCConflictingTweaks: dylib stems are normalized
  before scanning, and the active test is a substring scan
  (any stem containsString: OMCNormalizeTweakName(rule[@"id"])) at
  @0x70f0–0x71b8 — NOT containsObject: on the raw id. Sites 2/3 build
  "<normID> <normName>" signature strings from the dpkg-status parser
  (sub_746c) for the caller's second matching phase; src's version map
  deliberately keeps raw package keys (shape divergence, same
  normalized id space) — documented in the helper's comment.
  Dumps: rem2_C9_normalizer.txt, rem2_C9_caller_ConflictingTweaks.txt,
  rem2_C9_sub746c.txt.

### Link fix
src/SplitScreenC/SCPCarApps.m: `static` dropped from SCPWalkerSafeGet
(~line 50) and SCPWalkerIconBundleID (~line 60) — the binary carries a
single shared copy; src/SplitScreenA/SCPCarSplit.m declares them extern
and calls them. Target links again.

### SplitScreenB behavioural INFERRED marks adjudicated in the same pass
Dumps in src/SplitScreenB/disasm/rem2_*.txt.
- Picker icon autoresizingMask 0x3f → CORRECTED to 0x2d (parent
  -addCoverToPane: IMP 0x2a2e8 sets w2 = 0x2d @0x2a488).
- Cover fade blocks (removeCoverFromPane: IMP 0x2a668) CONFIRMED:
  animations invoke @0x2a7a4 = [cover setAlpha:0]; completion invoke
  @0x2a7b0 = [cover removeFromSuperview]; duration 0.22.
- Picker fade blocks (removePickerFromPane: IMP 0x313ac) CONFIRMED:
  invokes @0x3151c / @0x31528, duration 0.15.
- Loader fade (removeLoaderFromPane:animated: IMP 0x2bbb4) CORRECTED:
  options = UIViewAnimationOptionCurveEaseOut (0x20000), animations
  block @0x2bd9c also scales the loader's tag-78 card to 1.25, and the
  card's "pulse" layer animation is removed first; pane.loader is
  cleared before the nil check.
- Reading-order comparator CORRECTED wholesale (parent IMP 0x31ba0,
  block invoke @0x31c38 — the cited 0x30218 was another function's
  landing pads): float pane sorts last; frames come from
  frameForSlot:, X axis first (1.0 tolerance), then Y, then slot.
- buildPickerSheetForPane: branch polarity CONFIRMED: extra =
  (pages > 1) ? 16.0 : 0.0 (fcsel gt @0x33ad8).
- Tray window level CORRECTED: UIWindowLevelStatusBar + 65.0
  (@0x37c08/@0x37c14) — never parent.window.windowLevel + 65.
- restartTrayTimer block body CONFIRMED: invoke @0x3bd38 =
  [weakSelf collapseAppTray]; 4.0 s, non-repeating.
- Panel glyph helper (inlined in showLayoutPanelForApp: IMP 0x37e8c):
  total (vertical 40 / horizontal 73) CONFIRMED; the "cross swap"
  CONFIRMED (canvas is fixed 73x40, renderer @0x38ebc); the 13/31 base
  rects CORRECTED to the binary's literal valueWithCGRect: arguments;
  the generic enumeration's fixed extent corrected total → cross; the
  layout-31 mirror corrected to subtract from `total` in both
  orientations; outW/outH axis assignment corrected (73 x 40 always).
- Panel empty-state placeholder frame CORRECTED: CGRectMake(48,
  runningY + 8, 73, 40) @0x391ac — the old (8, …, frameW, 48) had
  scrambled the constants.
- Layout appAreaInParent: (IMP 0x11dfc) tail CORRECTED: result is the
  content frame R inset by the status-bar insets; the intersection
  only gates validity (null / <= 1), picks landscape vs portrait, and
  supplies dock-overlap amounts that replace one inset when larger
  (landscape: bottom or top; portrait: right or left); a half-size
  sanity check on either dimension falls back to plain insets.

### Bottom line after CLOSURE-2
Genuinely missing bodies: **0** (11 found by the census — 4 closed by
the INFERRED-closure agent, 7 by CLOSURE-2). The 8 CLAIMED_STUB flags
were already adjudicated as false positives in §5 of this document.
Remaining INFERRED marks in SplitScreenB are cosmetic only (invented
helper names, log-wording guesses, dash-pattern contents, "style-11"
naming, one call-target name in refreshPickerSheet) and are
deliberately left labelled INFERRED.
