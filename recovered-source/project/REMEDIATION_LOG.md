# REMEDIATION LOG — OmniCar 1.0.3 reconstruction (2026-11-08)

This log covers the remediation round that followed the first
publication of the reconstruction (repo commit 3608d63). An external
review of that publication raised four points: (1) the handover
report `handover/RECOVERY_STATUS.md` was cut short in its published
form; (2) the coverage census carried 675 UNCLAIMED rows, 301
multi-claimed rows and 8 stub flags without adjudication; (3)
important SplitScreen logic still carried INFERRED labels; (4) the
fresh-checkout build claim was unproven and the verification tools
hardcoded the analysis workspace. Every point was worked; this log
records what was done and the final numbers.

## 1. Document repairs

Four published files carried cut-off damage from the production
rounds. Repairs (all verified after writing: byte size, tail,
marker count 0):

- `handover/RECOVERY_STATUS.md`: 7,323 B (ending mid-section-2.6)
  -> 22,423 B restored. The surviving head was kept verbatim; the
  lost remainder was re-derived from the phase-2/phase-3 build logs,
  the final census and the module reports, and the document's own
  integrity note (end of its section 6) records that the
  pre-phase-3 draft (24,206 B) no longer exists and that the
  original wording of the lost sections is NOT recoverable — the
  restored text is a re-derivation, not a facsimile. The
  remediation addendum appended by this round is its section 7;
  final size after the addendum: 28,400 B.
- `src/AppBridgeA/AppBridgeA_REPORT.md`: 21,115 B -> 28,768 B. The
  mid-file hole (~20,887 chars) was repaired with a clearly marked
  restored segment (the complete 193-method AppBridge inventory
  regenerated mechanically from the objc metadata). The lost
  original wording is stated as unrecoverable in the segment.
- `project/logs/phase2-splitscreen.md` (9,273 B -> 11,388 B) and
  `project/BUILD_PHASE3_LOG.md` (11,709 B -> 12,403 B): historical
  logs. Their lost tails were NOT fabricated; each received an
  honest damage note recording what was lost and where the
  surviving conclusions are recorded.

## 2. Census adjudication

`metadata/CENSUS_ADJUDICATION.md` (26,870 B incl. the CLOSURE-2
addendum) reconciles `metadata/FUNCTION_SOURCE_MAP.tsv` row by row:

- 675 UNCLAIMED = 664 bookkeeping + 11 genuinely missing.
  Bookkeeping groups: compiler-synthesised `.cxx_destruct` (51),
  block-typed and multi-declarator `@property` accessors the census
  parser cannot credit (20), BLOCK_INVOKE global/stack block
  helpers (266), block copy/dispose helpers (78), libroot and
  protection shims (94), shared-twin statics claimed in a sibling
  binary (92), src-grep-verified helpers (14), individually
  adjudicated rows (21), veneer thunks (19), misc aliases (9).
- 301 CLAIMED_MULTIPLE: benign — the parallel A/B duplicate source
  trees plus cross-module declaration mentions; 54
  EXPECTED_MULTIPLE are shared OMCCommon copies by design.
- 8 CLAIMED_STUB: all false positives — real bodies preceded by
  `CLOSED (was STUB-UNRECOVERED)` provenance comments.

## 3. Source closures (genuinely missing: 11 -> 0)

- INFERRED-closure pass (SplitScreen): ~50 placeholder/INFERRED
  bodies in `src/SplitScreenA/SCPCarSplit.m` corrected from the
  binary, including the four helpers C3–C6 (SCPFindHomeGlyph,
  SCPScanStatusBarBaseline, SCPLauncherGlyphImage,
  SCPDumpDockTree) and the home/dock cluster the census corollary
  had flagged (refreshHomeButton, dockClusterInParent:,
  launcherCenterInParent:size:shift:, dockHostForRect:inParent:,
  installIconLongPress, ...). Several header signatures were
  corrected to the binary's ABI (dockClusterInParent: returns
  CGRect; launcherCenter takes out-pointers; paneSolo:/
  paneBackground:/paneClose: take the tapped view;
  bridgeHandleTapped: takes the bundle string).
- CLOSURE-2 pass (7 bodies): M1/M2 Prefs
  `tableView:willDisplay{Header,Footer}View:forSection:` shims;
  C1/C2 SpeedBubble `__init_3` diagnostic stamp + block (in
  `SPPDisplayBoot.m`); C7 SplitScreen loader-timeout block invoke
  with the whole parent `hostApp:inPane:` re-read and corrected;
  C8/C9 Prefs share-report formatter + tweak-name normaliser (in
  `OMCCommon.m`). Link fix: `static` dropped from
  SCPWalkerSafeGet / SCPWalkerIconBundleID in
  `src/SplitScreenC/SCPCarApps.m` (SplitScreenA declares them
  extern; the binary carries one shared copy).
- The four areas the review named are re-read and corrected in
  `SCPCarSplit.m`: `repairPresentedViewController:` (no adoption
  call exists; it un-hides a leftover view tree), `pushSceneSizes`
  (never calls `pushHostFramesLive:`; +0.4 s / +0.9 s fix-ups),
  slot selection (`slotOccupied:` / `autoSlot`), and the app-reopen
  predicate (`currentBase && !suppressReopen &&
  isAdoptableViewController:`, csinc at 0x15de0).
- SplitScreenB behavioural marks adjudicated the same pass
  (masks, fades, reading-order comparator, tray level
  UIWindowLevelStatusBar + 65, panel glyph geometry) — see the
  CLOSURE-2 addendum in the census document.
- Residuals deliberately left, documented in RECOVERY_STATUS
  section 7.4: the panel placeholder's layer/label construction
  (condensed), the tray window's dynamic class-pair + object_setClass
  step (omitted; plain UIWindow used), and SplitScreenB's cosmetic
  INFERRED list (invented helper names, log-wording guesses,
  dash-pattern contents, "style-11" naming, one call-target name).

## 4. Integration fixes by this pass

The closure agents could not compile-check (the VM toolchain had
rolled back again; clang-18 was absent and was restored with
`~/bin/fix-toolchain.sh` before this build). Three integration
defects surfaced at the first build attempt and were fixed:

1. Picker sheet constant: `gridH + 18.0 + extra` -> `gridH + 14.0 +
   extra` in `src/SplitScreenB/SCPCarSplit+Picker.m`. Evidence: the
   binary's fadd chain at 0x33afc computes gridH + 8.0, then
   + extra, then + 6.0 (dump `rem2_buildPickerSheetForPane.txt`).
2. Missing full-class declaration: the new home/dock helper bodies
   in `SCPCarSplit.m` use `SCPCButton` as a full class; the file
   only forward-declared it. Fixed by importing `SCPCButton.h` at
   the head of `src/SplitScreenA/SCPCarSplit.m` (a first attempt
   placed the import at the forward-declaration site, which sits
   inside the `@implementation` block and was rejected; the import
   now sits with the file's other imports).
3. Stale call sites in `SCPHooks.m`: the two bridge blocks passed
   `note.userInfo` (NSDictionary) to the corrected
   `bridgeHandleTapped:` (bundle string). Proven from the binary
   with `verify/macho_truth.py`: the only `bridgeHandleTapped:`
   call site in the binary (0x770c, block at 0x76a0) passes
   `userInfo[@"identifier"]` (stub-resolved selectors `userInfo` /
   `objectForKeyedSubscript:`, cfstring key bytes "identifier").
   Both call sites corrected; evidence saved as
   `src/SplitScreenA/disasm/rem3_bridgeTapBlock_76a0.txt`.

No reconstructed body was stubbed, deleted or weakened to reach a
passing build.

## 5. Final build and verification

- Clean build (`make clean` + `make package FINALPACKAGE=1`,
  THEOS=~/theos, umask 022): **exit 0, 0 errors**, all 8 components
  (`project/logs/remediation-build.log`).
- `diff_payload.py` on the build (`project/logs/remediation-diff.txt`):
  file set 176 = 176; non-Mach-O resources **168/168
  byte-identical**; classes exact on all 8 binaries; **0 original
  defined symbols missing** in any binary. Method totals
  orig -> built: App 6 -> 6, AppBridge 193 -> 193, CarProbe 0 -> 0,
  Core 0 -> 0, SpeedBubble 277 -> 278, SplitScreen 480 -> 480,
  StartupScreen 173 -> 175, Prefs 743 -> 745 (the +2 is exactly the
  restored M1/M2 shims).
- Per-class method comparison, all 66 classes, original vs built
  (selectors grouped by class incl. categories;
  `project/logs/remediation-perclass.txt`): **62/66 classes have
  identical method sets**. The 4 exceptions are built-side additive
  ONLY — no class is missing any selector:
  - `SPPBubble` (SpeedBubble) 103 -> 104:
    `-hideIfShownWithReason:now:state:` (documented since phase 2).
  - `SSStartupView` (StartupScreen) 71 -> 73: `-ss_festiveIcon:`,
    `-ss_festiveLabelsWithTitle:subtitle:titleColor:subtitleColor:titleY:titleSize:subtitleY:subtitleSize:`
    — helpers the original inlines (documented phase 3).
  - `OMCSplitScreenController` (Prefs) 37 -> 38:
    `-gestureSwitchChanged:` — additive; named for the first time
    here (the phase-3 aggregate 743 = 743 had masked it together
    with the two below and the missing M1/M2: -2 +1 +1 = 0).
  - `SSStartupView` (Prefs) 71 -> 72: `-gradientLayer` — additive;
    same masking note.
  - `OMCAppBridgeAppsController` (Prefs): **105 = 105, exact** —
    the M1/M2 gap is closed.
- Fresh-checkout proof (independent pass): a standalone clone of
  the published repo built clean (exit 0) outside the analysis
  workspace and reproduced the phase-3 structural profile
  (`project/logs/fresh-checkout-build.log`,
  `project/logs/fresh-checkout-diff.txt`). Portability fixes from
  that pass — `project/tools/diff_payload.py`, `verify/audit_calls.py`,
  `verify/audit_data.py`, `metadata/tools/build_maps.py`,
  `metadata/tools/coverage_census.py` (roots derived from
  `__file__`), and `handover/BUILD_GUIDE.md` path corrections —
  were copied back into this workspace so it is canonical.

## 6. Packaging (parity restage)

As phase 3: the Theos payload was re-staged with per-path modes
copied from the original, ownership set to the original's numeric
**uid 501 : gid 20**, control taken from the original with
`Installed-Size` set to the computed payload value (3540 =
`du -sk` of the payload tree, the dm.pl convention), and repacked
with `dpkg-deb -Zxz`.

- Final DEB: `project/packages/com.anlai.omnicar_1.0.3_iphoneos-arm64-rebuilt.deb`
  — **947,168 bytes**, SHA-256
  `c7ce84830778b49e4ca5733c59e10da99293ef07bbaccfb1ff6d273bd1c33ef9`
  (phase-3 DEB was 933,260 B / 9a593ed2...; the growth is the
  restored and corrected bodies, above all in SplitScreen).
- Parity audit (mode + uid + gid + entry type, per path): **data
  tar 202/202 entries, 0 differences**. Control tar: modes match
  (755/644); ownership is 0:0 in the rebuilt file vs 501:20 in the
  original — dpkg-deb normalises control-archive ownership to
  root. This is inherent to the dpkg-deb route used since phase 3
  and is recorded here as an accepted deviation.

## 7. Status after remediation

- Genuinely missing bodies: **0**. True stub count: 0.
- Per-class parity: 62/66 exact; 4 named additive-only deltas.
- Verification remains structural/static only — no device run has
  been performed. The build remains arm64-only (RECOVERY_STATUS
  G1 unchanged); the same source built with Xcode on macOS
  produces the FAT arm64+arm64e layout of the original.
