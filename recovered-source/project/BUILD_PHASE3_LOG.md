# BUILD PHASE 3 LOG — canonicalisation, final build, handover finalisation

Date: 2026-11-08. Scope per brief: reconcile `src/` ⇄ `project/` into
ONE canonical source (src alone sufficient), rebuild all clean,
re-diff, repackage, finalise handover. Result: **all steps complete;
no component was stubbed or cut to force the build.**

## Step 0 — toolchain
Verified healthy, fix script not needed: clang-18 18.1.3 (`dpkg -l`
shows `ii`), `/usr/local/bin/ldid` present, `/usr/bin/ld.lld` →
ld.lld-18, SDK iPhoneOS16.5 present. All builds run with
`umask 022`, `THEOS=~/theos`, `FINALPACKAGE=1`.

## Step 1 — pre-sync src corrections
(a) Restored the four divider declarations, well-formed, in
`src/SplitScreenB/SCPCarSplit.h` (Divider category), signatures from
`SCPCarSplit+Divider.m`: `dividerDoubleTapped:` @0x2e6e8,
`dividerDoubleTapOn:` @0x2e73c, `dividerTapped:` @0x2eb64,
`dividerTapOn:at:` @0x2ebf0. The phase-2 removal premise is refuted
by the binary's method list (SplitScreenA_REPORT micro-closure
addendum, item 3). They are also restored in the canonical merged
`SCPCarSplit.h` (step 3).
(b) `src/SplitScreenB/SCPCarSplit+Divider.m:32`:
`@[ @1.0/3.0, …]` → `@[ @(1.0 / 3.0), @0.5, @(2.0 / 3.0)]`.

## Step 2 — backport of project-only fixes into src/ (the item-17 debt)

Method: file-by-file `diff -u src project` for every mapped pair
(156 pairs; initial census 94 identical / 58 differing / 0 missing).
Direction rule: phase-2 `[phase2]`-tagged project text backports
into src; closure-round VERIFIED src text wins where the two
conflict. Every backport carries a provenance comment in src.

**CarProbe** — project copy taken into src wholesale (phase-1 fix
13: NSDistributedNotificationCenter interface + two dot→bracket
fixes); tags retagged.

**Prefs** (phase-1 fixes 21–27) — protocol lists (23/24);
PSSpecifier imports in 5 files (21); `<objc/message.h>` (22);
`(id)` cast in OMCCardPage (25); OMCCommon.m SSStartupView.h import
+ SPPSoundDelegate protocol conformance (26) + **storage
definitions for the 3 audio globals** (SPPSavedAudioCategory,
SPPSavedAudioOptions, SPPActiveSoundCount); SSStartupView.m
**SSSPrefsTrimmedString definition** + `_cardInsets` element type
(27). Conflict resolved for src: OMCIcon is a VERIFIED 2-argument
call `OMCIcon(entry[1], OMCColorFromHex(entry[2]))` at 3 sites in
OMCAppBridgeAppsController.m — the project's `, nil` third argument
was the superseded assumption (phase-2 gap 16 RESOLVED).

**AppBridge** — imports (fixes 14/15/16/18); ABInApp forward
declarations + NSHashTable fix (17); `ABMissingSelector` return
id→void; merged ABHost.h union (12); ABHostGeometry
`ABMissingSelector` void call-site + `ABHook_SBSuspended`
void→BOOL; the **ABHost (ModuleB) category arrangement** into
ABHostBMethods.m + 3 `appViewController` casts. Phase-3 fix: src's
partial in-file chrome @interface re-declarations (ABBoxView lacked
passInsets/hole; ABShieldView absent) replaced by
`#import "ABChromeViews.h"`, and ABChromeViews.h + ABKeyboardDecl.h
backported into src/AppBridgeB/ (the decl header verified still
verbatim against ABKeyboard.m). `src/AppBridgeB/ABChannels.m`
renamed to **ABChannelNames.m** in src (A's handlers TU keeps
ABChannels.m). Duplicate rulings verified per-selector: A defines
16 ABHost methods, B defines 33, intersection ∅.

**SpeedBubble** — SPPPrefs `_OMCPref` 2-arg; SPPOverspeed
18-@property census + ivar retypes (displayID NSString*,
speed/limit int); SPPBubble extern/call `_OMCLogoMeshImage(int)` /
`(0)`, @class line, SPPBubbleView +10 properties, SPPBubble
31-@property census; SPPViews SPPGlassView fill/sheen + SPPIconView
tileCorner/tileMask (closure's VERIFIED setCorner:/layoutSubviews
kept → gap 15 resolved); SBIntegrationTables.m +
SBIntegrationShims.h backported. Src closure wins wholesale for
SPPWindowFactory.m, SPPBubbleView.m, SPPBubble runDemo.

**StartupScreen** — SSStartupScreen.h @class SSStartupView +
`_stackMaxWidth` NSArray retype + SSSplash 20-@property completion;
SSStartupScreen.m OMCRealPath definition (libroot dlopen shim) +
NSCalendarUnitLeapMonth removal; ScenesBInternals category +
`_stackMaxWidth` store fix. SSStartupView.m merge: 12 structural
bodies neutralised with the project's SUPERSEDED comment blocks
(6 Builders + 6 ScenesB); `ss_applyEngine` substituted from project
(pure fractions, easeInOutCubic, wobble only t>2.3 — src's
max×0.62/0.71 body was wrong); src's mote closure KEPT
(ss_addMote:/ss_applyMotes:, 56-byte SSMoteRecord VERIFIED).
  ⚠ Incident (recovered, no loss): the first scripted multi-region
  replacement on SSStartupView.m mis-anchored on class-extension
  declarations and mangled the file. It was recovered **byte-exact**
  by reverse-applying the pre-edit saved diff onto the project copy
  (hunks verified identical), then redone with signature/region
  anchors + span asserts, from a backup. Lesson recorded: always
  back up before scripted multi-region replacement.

**SplitScreen** — SCPPerfTelemetry.m ← project copy (hoisted
statics out of shared state + OMCFlushPerfStats /
OMCAutoLiteEvaluate; ARC adaptation of literal retain/release);
SCPSessionCore.m `gStatMemPeakMB`→`gStatMemMB` (3 sites);
Layout.m comment-swallowed signature restored; Drag.m / Divider.m /
Chrome.m / Picker.m / Panel.m + SCPCommon.h / SCPCButton.h imports;
SCPKnobFaceView return type → UIVisualEffectView* (SCPCommon.h +
SCPCarDividerView.m); name unifications into src
(SCPBlurEffectView→SCPKnobFaceView incl. the RatioMenu call site,
SCPProxyForBundle→SCPApplicationInfoForBundle,
SCPProxyIsValid→SCPAppHasCarPlayUI, SCPAppInfoForBundle→
SCPApplicationInfoForBundle, _OMCFeatureEnabled→OMCFeatureEnabled,
OMCPrefSet→SCPHomePrefSet in SCPPrefs.m + SCPCarSplit.m,
SCPChosenPhoneAppCount→SCPChosenPhoneAppInfos); Chrome.m duplicate
SCPBlurEffectView definition removed (unification), popupsClosedAt
double fix, 2 popupShield casts; Picker.m NSNumber cast +
viewIsRaised:/raiseView: receiver fix (tabParent→self); Panel.m
`panelSections:` out-pointer (NSString**)→(NSArray**); Zoom.m
SCPSmallClasses.h import + 3 (SCPHostedAppVC *) casts; Divider.m
`((NSNumber *)other[i])` cast; SCPHomeCommon.h rename; SCPHomeHooks.m
typedef move + OrigIconImageInfo retype (phase-1 fix 20);
**SCPShared.m**: SCPGuardedSend de-static'd (fix 19) + the whole
phase-2 closure section appended (SCPMissingSelector @0x4f330,
SCPInfoBool, SCPAppHasCarPlayUI, SCPLayoutElementKey predicate,
SCPResetDetachedView, SCPAppIconForBundle) + the 5 declarations in
SCPShared.h; **SCPCarSplit.m**: isCarPlayApp appInfo fix,
SCPResetDetachedView extern ABI, paneSize `[self frameForSlot:]`,
insertPaneAt returns the pane, closeFloat:background call,
afterPaneRemoved:(id), A's duplicate anyBarVisible removed
(Chrome's is the binary's), publishBusy/publishCarPlayApps
renames, the 3 exit-method transcriptions (exitKeepBundle /
exitTapped / atHomeScreen), and an **empty `@implementation
SCPCarPane`** (phase 2 had added it project-only; accessors
auto-synthesise); SCPHooks.m: the closure's static
SCPLayoutElementKey copy removed in favour of the single global
(it followed the new global declaration — the one compile error of
the reconciliation, fixed by dedupe, not by stubbing).

## Step 3 — closure sync into project/
All module closures (AppBridge glyph/candidates/_currentMode +
duplicate rulings; SplitScreen scene walkers, sub_d324 + tail,
soloBundle:, hostPassInsetsForPane:, hostFrameInfo composition,
layout dedupe, favorite reader + SCPPrefs favorite: rewrite;
SpeedBubble numberColor/applyColor:, both constant arrays,
SPPHeavyFont/SPPRoundedFont, SPPAnimateViewWidth, SPPGaugePoint
(radius, angle) order, runDemo, SPPMakeCarWindow metrics;
StartupScreen mote writer/consumer; Prefs OMCIcon 2-arg calls)
were already in src and flowed into project/ through the sync.
Canonical `SCPCarSplit.h` assembled in src: A's main interface
(closure-corrected hostFrameInfo:/hostPassInsetsForPane: signatures
KEPT over phase 2's readings) + merge imports, UIScrollViewDelegate
conformance, dividers element type, insertPaneAt / afterPaneRemoved
binary signatures, exit-method declarations, and B's pruned
categories with the four divider declarations restored.
SCPCarPane.h: merged B copy adopted in both src locations (property
sets script-verified identical in phase 2).
Sync mechanics: per-file copy src→project with two deliberate
exceptions — (1) `SCPHomeApply.m`'s import is rewritten
`../SplitScreenB/SCPHomeWallView.h` → `SCPHomeWallView.h` only in
the project copy (flat layout; src keeps the path correct for its
own tree); (2) `SplitScreenB/SCPCarSplit.h` and
`SplitScreenB/SCPPrefs.h` are NOT synced — in the flat tree their
content lives in the canonical merged headers from A (syncing them
would clobber the merged header; this bit once during the phase —
first build attempt — and was corrected). Project-only files
preserved: SCPIntegrationShims.h, ABIntegrationShims.h,
SCPCarSplit+Relayout.m (the relayoutAnimated: extraction).

## Step 4 — final clean build + verification
- `make clean` + `make package FINALPACKAGE=1`: **exit 0, 0
  errors** (log `logs/phase3-build-final2.log`). Intermediate
  attempts are preserved as `logs/phase3-build.log` …
  `phase3-build6.log` (header-clobber, static/global dedupe,
  RatioMenu call-site rename, SCPCarPane link closure — each fixed
  at the cause).
- `diff_payload.py` on the final DEB: file set 176 = 176;
  non-Mach-O **168/168 byte-identical**; **0 original defined
  symbols missing in all 8 binaries**. Method counts orig → built:
  App 6→6, AppBridge **193→193**, CarProbe 0→0, Core 0→0,
  SpeedBubble 277→278 (+1: built-only
  `SPPBubble hideIfShownWithReason:now:state:`, additive),
  SplitScreen **480→480**, StartupScreen 173→175 (+2:
  `ss_festiveIcon:`, `ss_festiveLabels…` — helpers the original
  inlines; the 12 builder selectors match modulo category-owner
  naming), Prefs **743→743**. AppBridge's 33 ModuleB selectors
  match modulo category-owner naming (original: main class list).
  ABBarButton `setHighlighted:` — the one genuinely missing method
  found by this diff — was restored from
  `m_ABBarButton_setHighlighted.txt` + block invoke @0xa104 before
  the final build.
- Packaging: Theos' deb mixes ownership (0/root, 0/65534), so the
  payload was re-staged explicitly: modes copied per-path from the
  original, ownership set to the original's **uid 501 : gid 20**
  (numeric tar values; name rendering on this VM is misleading),
  `Installed-Size` set to the computed 3071, repacked with
  `dpkg-deb -Zxz`. Final parity audit: **202/202 entries, 0 diffs**
  (mode + uid + gid + type). Control otherwise identical.
- **Final DEB**: `project/packages/com.anlai.omnicar_1.0.3_iphoneos-arm64-rebuilt.deb`
  — SHA-256 `9a593ed2649c2da95e703c81fa121e01116911cea6efea65b6a9d99b93537170`,
  **933,260 bytes**. (Phase-2 DEB was
  `4ea9ca78…`, 928,320 B — superseded.)

## Step 5 — census + handover
- `metadata/tools/coverage_census.py` re-run on the final src:
  FUNCTION_SOURCE_MAP.tsv (3,280 universe rows) +
  COVERAGE_GAPS.md regenerated. Stub counts: AppBridge 0 (was 2),
  SplitScreen 8 flags — all false positives on "CLOSED (was
  STUB-UNRECOVERED)" provenance text; true stub count is 0 in
  every module. Per-binary table reproduced in
  `handover/RECOVERY_STATUS.md` §3.
- `handover/RECOVERY_STATUS.md` rewritten FINAL (draft replaced):
  per-module status, definitive remaining gaps G1–G8, acceptance
  criteria, verification-scope statement (structural/static only;
  **no device run**).
- `handover/BUILD_GUIDE.md`: every [PENDING FINAL BU

  — DAMAGE NOTE (2026-11-08, remediation): this log's first
  publication ended at a truncation marker mid-word in the
  bullet above; ~49 chars (the tail of this final step-5
  bullet) are lost and are not recoverable. The bullet's
  conclusion, as executed and recorded in
  `handover/BUILD_GUIDE.md` §8 (which survives intact): every
  [PENDING FINAL BUILD] marker was resolved by phase 3 and
  the confirmation checklist is fully ticked, with one
  recorded deviation — control `Installed-Size` was set to
  the computed value (3071) instead of being dropped. No
  further step-5 content followed this bullet. Discovered
  during the coordinator's handover review, 2026-11-08;
  repaired by this note only.
