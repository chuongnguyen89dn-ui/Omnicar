# PHASE 2 — OmniCarPrefs: sync + build

Date: 2026-11-08. Subproject: `project/OmniCarPrefs/` only. `src/` untouched.
Toolchain verified before building: clang-18 present (dpkg ii), ldid shim
present, `/usr/bin/ld.lld` → ld.lld-18, SDK iPhoneOS16.5. Builds under
`umask 022`, `THEOS=~/theos`, `make clean; make` in the subproject.
Arrangement kept as instructed: the shared OMCCommon unit is NOT included;
Prefs' own `OMCCommon.m` (Prefs core copy + Prefs-only helpers, 7 colliding
symbols by design) is the bundle's core. Bundle via bundle.mk,
INSTALL_PATH `/Library/PreferenceBundles` (unchanged).

## 1. Sync

Copied `src/Prefs/OMCPrefs/*.h` + `*.m` (NOT `generated/`) over
`project/OmniCarPrefs/`, overwriting the phase-1 copies. Post-sync
`diff -rq` (excluding project-only files) = identical. 56 files synced:

OMCAppBridgeAppsController.h/.m, OMCCarProfilesController.h/.m,
OMCCardPage.h/.m, OMCCells.h/.m, OMCCommon.h/.m,
OMCFeatureListController.h/.m, OMCHSPreview.h/.m, OMCHeaderCard.h/.m,
OMCHomeScreenController.h/.m, OMCOnboardingController.h/.m,
OMCRootListController.h/.m, OMCSSStyleTileCell.h/.m,
OMCSpeedBubbleController.h/.m, OMCSplitPreview.h/.m,
OMCSplitScreenAppPickerController.h/.m, OMCSplitScreenController.h/.m,
OMCStartupScreenController.h/.m, OMCWhatsNewController.h/.m,
SPPBubbleView.h/.m, SPPGlassView.h/.m, SPPIconView.h/.m, SPPSignView.h/.m,
SPPSoundDelegate.h/.m, SSCanvasView.h/.m, SSFade.h/.m, SSGauge.h/.m,
SSLinkTarget.h/.m, SSStartupView.h/.m

Kept project-only: `PrefsIntegrationShims.h`, `Makefile`, `Resources/`.

Notable improvements that arrived WITH the sync (src-side, no re-apply
needed): the BLOCKER-PREFS-HUD adjudication in OMCCommon.m (see §2a);
`SSSampleHudItems` defined in SSStartupView.m (§2b); the ss_buildHud
fallback (§2c); the corrected `_OMCSwitchColor` (§2d); the 3 syntax-typo
repairs (§3); and the PrefsB seam fix in
OMCSplitScreenAppPickerController.m (the invented second SSPickSetPref
write after 250 ms is gone — the delayed block now only pops, matching
PrefsB_REPORT).

## 2. Verification of adjudicated items (in the synced sources)

(a) **hud = NSArray — PASS.** `OMCCommon.m`: the `(OMCSampleData)`
category (line 1133) declares `@property (nonatomic, copy) NSArray *hud;`
and the fill (line 1150) is exactly
`if (!view.hud) view.hud = SSSampleHudItems(view.carName);`, preceded by
the binary-evidence comment (0x545e4–0x54628) and the extern declaration
of SSSampleHudItems (line 1127). B's declaration in `SSStartupView.h:24`
agrees (`copy NSArray *hud`). The old `view.hud = YES;` is gone.
BLOCKER-PREFS-HUD is resolved in src.

(b) **SSSampleHudItems DEFINED — PASS.** `SSStartupView.m:191`,
file scope (after SSDateLine, before the class extension), full 5-item
body with the double-trim quirk mirrored.

(c) **ss_buildHud fallback line — PASS.** `SSStartupView.m:1130`:
`NSArray *items = self.hud.count ? self.hud : SSSampleHudItems(self.carName);`
with the micro-fix evidence comment (0x4fc98–0x4fcdc) above it.

(d) **_OMCSwitchColor — PASS.** `OMCCommon.m:296-298`: comment cites
0x17fd8, and the body is the 12-byte tail-call equivalent
`UIColor *OMCSwitchColor(void) { return [UIColor systemGreenColor]; }`.
Header comment at `OMCCommon.h:115` corrected to match.

(e) **FeatureStartupScreen specifier set = 44 items — PASS.**
`project/OmniCarPrefs/Resources/FeatureStartupScreen.plist` (project
resource, kept): `items` count = **44** via plistlib; the file is
byte-identical (SHA-256 `368e27c2…f71fbb9c`) to the payload original
`payload/.../OmniCarPrefs.bundle/FeatureStartupScreen.plist`, which also
parses to 44 items.

## 3. Phase-1 fixes: present in src, or re-applied to the project copy

**3 syntax typos in OMCStartupScreenController.m — FIXED IN SRC,
verified, nothing re-applied.** Line 636 now opens `[[[SSReal(` (three
brackets); the two dispatch_async closers are `});` at lines 684 and 699
(the neighbouring `}];` message-send closers correctly untouched). This
matches the PrefsB_REPORT phase-2 fix note.

**Still missing in src → re-applied to the project copy (still owed in
src):**

- Fix 21 — `#import <Preferences/PSSpecifier.h>` re-added to
  OMCCarProfilesController.m, OMCAppBridgeAppsController.m,
  OMCSplitScreenAppPickerController.m, OMCSplitScreenController.m,
  OMCStartupScreenController.m (absent in all 5 src files).
- Fix 22 — `#import <objc/message.h>` re-added to
  OMCAppBridgeAppsController.m.
- Fix 23 — OMCAppBridgeAppsController.h protocol list completed:
  `<UITableViewDataSource, UITableViewDelegate,
  UINavigationControllerDelegate, UIImagePickerControllerDelegate>`
  (src header has no protocol list).
- Fix 24 — OMCStartupScreenController.h protocol list completed:
  `<UICollectionViewDataSource, UICollectionViewDelegate,
  UINavigationControllerDelegate, UIImagePickerControllerDelegate,
  UIDocumentPickerDelegate>` (src header has none).
- Fix 25 — OMCCardPage.m: `[sender selectionChanged]` →
  `[(id)sender selectionChanged]` (src still has the uncast send).
- Fix 26 — OMCCommon.m: `#import "SSStartupView.h"` re-added (absent in
  src — only the header's @class forward is there), AND the local
  `@interface SPPSoundDelegate` completed with
  `<AVAudioPlayerDelegate, AVSpeechSynthesizerDelegate>` (src still
  declares it as plain NSObject).
- Fix 27 — SSStartupView.m: `NSArray *_cardInsets` →
  `NSArray<NSLayoutConstraint *> *_cardInsets` (src still unspecialised;
  the new SSSampleHudItems block shifted the line, the ivar is otherwise
  unchanged).

Fixes 3/4/11 (Makefile USE_MODULES=0, framework completion,
PrefsIntegrationShims.h) live in project-only files and were kept as-is
(§5 extends fix 4).

## 4. BLOCKER-PREFS-OMCICON — assumption re-applied, still flagged

Current src carries NO resolution: OMCAppBridgeAppsController.m still
calls `OMCIcon(symbol)` with one argument at lines 562, 624, 674, while
`OMCIcon` is declared 2-arg (`OMCCommon.h`, defined `OMCCommon.m`).
Re-applied the phase-1 completion `, nil` at all 3 project-copy sites,
each commented as an ASSUMPTION citing BLOCKER-PREFS-OMCICON. Unchanged
risk from phase 1: with nil, `[color getHue:…]` is a no-op → h=0 → the
pink-pair branch is taken deterministically; if the original calls
passed a real color, the rendered icons differ. Still needs binary
verification by the coordinator/verifier.

## 5. New phase-2 completions (project copies only, all logged)

Build 1 (sync + §3/§4 fixes) compiled every file and failed ONLY at
link, 8 undefined symbols in 3 groups (`logs/phase2-prefs-build1.log`):

1. **Makefile frameworks (mechanical, extends phase-1 fix 4):**
   `kCGImageDestinationLossyCompressionQuality`, `kCVPixelBufferPixelFormatTypeKey`,
   `_OBJC_CLASS_$_CIContext`, `_OBJC_CLASS_$_CIImage` — the synced
   OMCStartupScreenController.m imports `<ImageIO/...>` and
   `<CoreImage/...>` directly (frame extraction). Added
   `OmniCarPrefs_FRAMEWORKS += ImageIO CoreImage CoreVideo` to the
   project Makefile with a comment.
2. **`SSPrefsTrimmedString` definition (SSStartupView.m project copy).**
   src declares it `extern` (SSStartupView.m, sub_4da60 comment) and
   defines it NOWHERE in the repo (grep-verified); SSSampleHudItems
   calls it twice. Completed the definition in the project copy with
   EXACTLY the semantics documented as VERIFIED in that same src
   comment: NSString input → trimmed by
   whitespaceAndNewlineCharacterSet; any other input incl. nil → `""`.
   No behaviour invented; flagged in-code as still owed in src.
3. **SPP audio-state storage (OMCCommon.m project copy).**
   `SPPSavedAudioCategory`, `SPPSavedAudioOptions`, `SPPActiveSoundCount`
   are declared extern in SPPSoundDelegate.m and defined NOWHERE in src.
   Per SPPSoundDelegate.m's own header comment, the binary keeps this
   state in globals at 0x900a0/0x900a8/0x900b0 in the SPP TU (the
   SPPSpeak/SPPPlayTone TU = OMCCommon.m). Added plain zero-initialised
   storage definitions with the externs' exact types at the top of
   OMCCommon.m's Speed Bubble voice section; no logic. Flagged in-code
   as still owed in src.

No functional code was stubbed or deleted anywhere in this phase.

## 6. Build result

`make clean; make` (build 2, `logs/phase2-prefs-build2.log`):
**PASS — exit 0, 0 errors, 11 warnings** (demoted classes from phase 1).
Link and signing both ran (`Linking bundle OmniCarPrefs (arm64)…`,
`Signing OmniCarPrefs…`). Product:
`.theos/obj/debug/arm64/OmniCarPrefs.bundle/OmniCarPrefs` (1,173,456 B).

**Fingerprint vs original (tools/diff_payload.py `fingerprint()`):**

| | archs | classes | methods |
|---|---|---|---|
| original | arm64+arm64e | 29 | 743 |
| built | arm64 | **29** | **743** |

Class-name sets are IDENTICAL (no class only in either side). Target
29/743 met exactly. The arch difference is the documented VM limit
(clang-18 silently degrades arm64e→arm64), not a source gap.

## 7. Remaining issues

1. **BLOCKER-PREFS-OMCICON still an assumption** (§4) — the 3 `, nil`
   completions are unverified against the binary.
2. **Two definition gaps still owed in src** (§5 items 2–3):
   `SSPrefsTrimmedString` (extern-only in src) and the 3 SPP audio
   globals (extern-only in src). Project copies carry completions built
   strictly from the modules' own documented evidence; the module
   should adopt them (or their own equivalents) at source.
3. **Phase-1 mechanical fixes 21–27 still owed in src** (§3) — they
   exist only in the project copies; a future re-sync must re-apply
   them again unless src adopts them.
4. arm64e slice absent (VM toolchain limit, expected fleet-wide).
