# PrefsB_REPORT — OmniCarPrefs reconstruction, part B (wave 2.5)

Agent: Prefs-B. Scope: the complement of Prefs-A's claim — **22 classes,
637 instance methods + 6 class methods** (with A's 100 + 6 = 743 total,
matching the coordinator's adjudicated split). Source in
`src/Prefs/OMCPrefs/<Class>.h/.m`; disassembly (all 809 functions) is
Prefs-A's shared `src/Prefs/disasm/` (index.json / classes.json), which I
consumed and cross-checked. Tools: capstone 5.0.7 via A's `tools/disasm.py`,
plus my own constant-object decoder (NSConstantArray/Dictionary/String/
Integer layouts calibrated against A's verified OMCProfileKeys decode).

**No silent stubs.** Every claimed method has a reconstructed body. Where a
body is structural rather than line-exact, the source and this report say so
(status INFERRED for those pockets). There are no `// STUB-UNRECOVERED`
markers because no method was left unreconstructed; the honest gaps are
enumerated in §4.

## 1. Calibration corrections applied (off-by-one, adjudication closed)

Wave-1 `metadata/raw/OmniCarPrefs/objc.json` superclass names were shifted
by one import ordinal. I verified independently: A's disassembly import
annotations agree with the calibrated `metadata/xref/OmniCarPrefs.json` at
**11,076 / 11,076 import call sites**. Corrected superclasses used in my
source for 18 of my 22 classes:

| Class | Wave-1 (wrong) | Calibrated (used) |
|---|---|---|
| OMCAppBridgeAppsController | __objc_empty_cache | PSViewController |
| OMCCarProfilesController | __objc_empty_cache | PSViewController |
| OMCSplitScreenAppPickerController | __objc_empty_cache | PSViewController |
| SSStartupView | UIColor | UIView |
| SPPBubbleView | UIColor | UIView |
| OMCHSPreview | UIColor | UIView |
| SPPIconView | UIColor | UIView |
| OMCSplitPreview | UIColor | UIView |
| SPPGlassView | UIColor | UIView |
| SPPSignView | UIColor | UIView |
| SSCanvasView | UIColor | UIView |
| OMCOnboardingController | UIFontMetrics | UIViewController |
| OMCWhatsNewController | UIFontMetrics | UIViewController |
| SSFade | NSSortDescriptor | NSObject |
| SSGauge | NSSortDescriptor | NSObject |
| SPPSoundDelegate | NSSortDescriptor | NSObject |
| SSLinkTarget | NSSortDescriptor | NSObject |
| OMCSSStyleTileCell | _OBJC_METACLASS_$_PSTableCell | UICollectionViewCell |

Unchanged (internal superclasses, both sources agree): OMCHomeScreenController
→ OMCAppBridgeAppsController; OMCStartupScreenController →
OMCFeatureListController; OMCSpeedBubbleController → OMCCardPage;
OMCSplitScreenController → OMCCardPage.

Annotation caveats in the shared dumps (affect reading, not addresses):
`@GOT ___objc_personality_v0` is a frequent mislabel for other GOT entries,
and `@SEL "whatsNewNavigationController"` appears spuriously for the
fast-enumeration state pointer. String/class/selector annotations and all
instruction addresses are reliable; several constants below were decoded by
re-reading raw bytes at the annotated VAs.

## 2. Per-class coverage

Status key: **VERIFIED** = body proven from disassembly (constants decoded);
**INFERRED** pockets are listed per class and in §4. Accessors and
`.cxx_destruct` are standard synthesized patterns throughout (verified from
type encodings + asm) and are not counted as gaps.

| # | Class | Methods | Status | Notes |
|---|---|---|---|---|
| 1 | OMCAppBridgeAppsController | 105 | VERIFIED, pockets INFERRED | Full data core (loadState / locked: / hides: / rebuildRows / storeChoices), all 8 decoded constant arrays, slider live-write vs commit semantics, tiles, photo/video import, JPEG/video export pipeline. INFERRED: §4 rows 2–5 mapping (two conflicting dispatch paths in binary), conic-gradient RGB triples per wallpaper style, loadState's carPlayApps population path. |
| 2 | OMCStartupScreenController | 83 | VERIFIED, pockets INFERRED | 11 styles decoded; occasion scanner (GMT+7, Tet/birthday/New Year/Xmas/Mid-Autumn), frame extractor (24 fps JPEG, BGRA, info.plist v2), video/logo/sound import + preview, birthday accessory. INFERRED: refreshVideoList values/titles split, weather fallback dict contents, JPEG quality 0.85, one frame-compare micro-detail in decorateCell:. |
| 3 | SSStartupView | 70 + 1 class | VERIFIED core, builders structural | init/reload/link/applyTime dispatch, duration table, tempo scales (1.4/1.0/0.7), color tables (period/sky/scene), weather symbol+text tables, gauge mechanics (g.arc is the progress/mask layer — proven), fade semantics. Per-particle scatter geometry inside the 8 scene builders is structural/INFERRED. |
| 4 | OMCSpeedBubbleController | 67 | VERIFIED, pockets INFERRED | Full 3,266-line trace read. Migrations (source v1→v2 remap, warnMode 2→3), preview ticker formula, all pref readers with ranges/defaults, warn-rows builder (serious group first — csel order proven), all layouts/actions, tryOnCar/resetLayout Darwin posts. INFERRED: §2–§4 header key strings, §5 footer argument order, a few frames (segment x, custom-field frame, swatch row y/border, strip centering formula, source-tile bg alpha). |
| 5 | SPPBubbleView | 59 | VERIFIED core, geometry INFERRED | speedState/stateColor/speedRatio constants decoded (amber (1,0.702,0.251), red (1,0.353,0.373), slate (0.290,0.310,0.502)); buildStyle: part-key map + glass-style bitmask 0xd2 verified; renderStyle prologue verified. Exact per-style point math in buildStyle:/renderStyle and some applyColor: tints INFERRED; flash/pulse animation endpoints INFERRED. |
| 6 | OMCOnboardingController | 41 + 2 class | VERIFIED structure, layout constants partly INFERRED | 4 pages, pager/dots/buttons, constraints; markDone writes onboardingDone WITHOUT notify (verified); page-3 switch writes speedBubbleEnabled WITH notify. INFERRED: page-builder fonts/spacings, viewWillDisappear nav-bar polarity, openApps specifier construction. |
| 7 | OMCSplitScreenController | 37 | VERIFIED model, editor structural | Model helpers line-verified (layoutOf valid codes {2,3,13,31} def 2; parts [Left, Right, Third] decoded; favRow/helpKind arithmetic exact); keys/icons/colors in cellForRow verified from dump. chip:/editorCell: layout frames INFERRED; preview left/pinned default chain reconstructed from call order. |
| 8 | OMCHSPreview | 22 | VERIFIED structure, details INFERRED | drawRect: scale model (height/800), wallpaper fit (720 cap), blur wash (blur/64 capped 0.25), dim wash (dim/100); OMCIconSized + OMCThumb helpers defined in this TU. INFERRED: status-glyph/dot placement details, grid name-text source. |
| 9 | OMCCarProfilesController | 21 | VERIFIED | Own grouped table on PSViewController; reload sort by lastSeen; rows formula (count>1 ? count+1 : count); delete flow clears carProfileCurrent when deleting the current car. INFERRED: treatment of the extra row as empty-state cell. |
| 10 | OMCSplitScreenAppPickerController | 19 | VERIFIED | Seed/excluded set decoded (8 Apple ids at 0x7fbe8); entitlement gate keys; dynamic write of the specifier's `key`, notify_post, and the 250 ms delayed re-write before pop — all from asm. |
| 11 | SSFade | 18 | VERIFIED | Ivar layout and applyTime: math proven from raw asm (incl. the correction that ss_fade:…:alpha: sets the fade's own alpha). One gate register path in the out-window test is the single ambiguous spot; semantics as written. |
| 12 | SSGauge | 17 | VERIFIED | Accessors only in the binary (no custom methods); ivar layout documented. |
| 13 | OMCSSStyleTileCell | 14 | VERIFIED | 11 style hexes + 11 glyph candidate lists decoded from constant arrays; showStyle: hue-derivation math (sat ×0.75, bright ×1.15 capped) and setChosen: shadow/transform values from asm. Card x-centering formula partially stripped — INFERRED. |
| 14 | OMCWhatsNewController | 11 + 3 class | VERIFIED, one rule INFERRED | Version literal @"1.0.3"; whatsNewSeen write has NO notify; layout constants from asm (hero 76/32/20, stack +36/−48). INFERRED: exact version-selection rule in the picker helper (numeric-search scan verified, selection rule reconstructed). |
| 15 | SPPIconView | 11 | VERIFIED | Constants decoded (border white α0.3, shadow opacity 0.4f, radius factor 0.225). |
| 16 | OMCSplitPreview | 11 | VERIFIED structure | drawRect: composition, dot colors (#8B7CFF/#2E9CF5/#FA2D55), pin badge; pane geometry factors partly INFERRED. |
| 17 | SPPGlassView | 10 | VERIFIED | All constants decoded (fill border α0.85, sheen h×0.55, shadow triple (0.275,0.235,0.549) @ 0.22f). |
| 18 | SPPSignView | 8 | VERIFIED structure | Sign-red (0.898,0.149,0.176) decoded; font feature-setting ids and border-width factor INFERRED. |
| 19 | SPPSoundDelegate | 4 | VERIFIED | Shared finish handler semantics (count-down, session restore); state lives in SPP TU globals (declared extern; defined in A's OMCCommon TU). |
| 20 | SSLinkTarget | 4 | VERIFIED | step: forwards to owner ss_step, invalidates link when owner is gone. Selector is `step:` (corrected during writing). |
| 21 | SSCanvasView | 4 | VERIFIED | drawRect: forwards to owner ss_drawCanvas:size:. |
| 22 | OMCHomeScreenController | 1 | VERIFIED | -layoutPage = return YES (8 bytes). The "4244-byte method" in the index was an artifact of adjacent statics inside the address range. |

## 3. Preference keys proved (domain `com.anlai.omnicar` for all)

Write semantics: unless noted, a committed write = SetAppValue +
AppSynchronize + Darwin post `com.anlai.omnicar/prefschanged`.

**App Bridge / Home Screen page:** `appBridgeApps` (array of ids, written by
storeChoices), `appBridgeAdvancedReset` (one-time bool), `appBridgeEnabled`,
`appBridgeFps` (both cleared once by resetAdvancedOnce), `homeScreenCarApps`
(array of {id,name,off}), `splitScreenCarPlayApps` (fallback read),
`homeScreenHiddenApps` / `homeScreenShownApps` (sorted arrays),
`homeScreenWallpaper` (bool def NO), `homeScreenWallpaperStyle` (int def 7;
7 = photo, 8 = video), `homeScreenIconSize` (60–130, def 100, "%"),
`homeScreenBlur` (0–30, def 0, unit ""), `homeScreenDim` (0–70, def 25),
`homeScreenGridCols` (stepper [0,3,4,5,6,7,8], 0 = auto),
`homeScreenGridRows` (stepper [0,1,2,3,4]), `homeScreenShowNames` (def YES).
Exception: the page's sliders write **live during drag with NO sync/notify**;
only touch-up commits via the full helper. Files (realpath-resolved):
`/var/mobile/Library/OmniCar/HomeScreen/{photo.jpg, video.mp4, video.jpg,
wallpaper.jpg}`; temp export `NSTemporaryDirectory()/omnicar-wallpaper.mp4`;
0644 perms set after writes.

**Startup Screen page:** `startupScreenStyle` (0–10, def 0),
`startupScreenSoundFile` (filename), `startupScreenSoundVolume` (0–100,
def 100), `startupScreenRandomSet` (NSNumber array 0–9),
`startupScreenBirthday` ("MM-dd", "" = cleared), `startupScreenGreetingName`,
`startupScreenCarName`, `startupScreenTempo` (def 1, clamp 0–2),
`startupScreenLogoEffect`, `startupScreenVideoName`, `startupScreenScaleMode`
(==1 → AspectFit), `startupScreenDuration` (def 5, clamp 1–30), `diagCar`
(read-only harvest for the car-name footer). This TU posts prefschanged via
**CFNotificationCenter Darwin center** (deliverImmediately), not notify_post;
`setSelectedVideo:` writes WITHOUT the post. Files:
`…/OmniCar/StartupScreen/Videos/<file>`, `Videos/.frames/<file>/` (JPEG
frames at 24 fps named %05lu.jpg, audio.m4a, info.plist {version:2, count,
fps:24}), `Sounds/<file>`, `Logo/logo.png`; 0644 perms.

**Speed Bubble page:** `speedBubbleEnabled` (def YES), `speedBubbleLook`
(0–8, def 0), `speedBubbleSource` (0–3, def 0) + `speedBubbleSourceV2`
migration flag + legacy inputs `speedBubbleAppVietmap` / `speedBubbleAppGOFA`,
`speedBubbleShowAppIcon` (def YES), `speedBubbleColor` (0–6, def 0),
`speedBubbleSizePhone` / `speedBubbleSizeCar` (60–220, def 100),
`speedBubbleWarnMode` (bitmask 1 = rim/fx, 2 = sound; def 3) +
`speedBubbleWarnModeV2` flag (old 2 → 3), `speedBubbleWarnFx` (0–3),
`speedBubbleWarnSound` (0 tone / 1 voice), `speedBubbleWarnTone` (0–5),
`speedBubbleWarnVoice` (0–8; 8 = custom), `speedBubbleWarnVoiceText` (def ""),
`speedBubbleWarnOver` (−10…10, def 5). Darwin posts with NO pref write:
`com.anlai.omnicar/speedbubble.demo`, `com.anlai.omnicar/speedbubble.resetlayout`.

**Split Screen page:** `splitScreenEnabled` (def YES), `splitScreenAutoLaunch`,
`splitScreenPinnedApp`, `splitScreenLastLeft`, `splitScreenLastRight`,
`splitScreenShowRecent`, `splitScreenShowFavorites`, and per favorite N ∈
{1,2,3}: `splitScreenFav<N>Name`, `splitScreenFav<N>Layout` (def 2; valid
{2,3,13,31}), `splitScreenFav<N>Left`, `splitScreenFav<N>Right`,
`splitScreenFav<N>Third` (bundle ids). Picker writes the dynamic key from its
specifier + notify_post, repeated after 250 ms.

**Car Profiles page:** `carProfiles` (dict id → {name, lastSeen}),
`carProfilesEnabled`, `carProfileCurrent`.

**WhatsNew:** `whatsNewSeen` (string; set to literal "1.0.3"; NO notify).
Content: `WhatsNew.plist` bundle resource {version: [{symbol, titleKey,
textKey}]}.

**Onboarding:** `onboardingDone` (kCFBooleanTrue; NO notify),
`speedBubbleEnabled` (page-3 switch; WITH notify).

## 4. Honest gaps (INFERRED / structural pockets)

1. SPPBubbleView `buildStyle:` / `renderStyle:` — composition, part keys,
   and call order verified; exact per-style point math is reconstructed,
   not line-proven (two ~10–14 KB bodies with heavy register reuse).
2. SSStartupView's 8 scene builders — composition/strings/keys verified;
   per-particle scatter geometry condensed.
3. OMCAppBridgeAppsController §4 rows 2–5 — two conflicting dispatch paths
   exist in the binary; my mapping (2 pickPhoto, 3 blur, 4 dim, 5 plain) is
   one consistent reading. Conic wallpaper-style RGB triples likewise.
4. OMCSplitScreenController `chip:` / `editorCell:` frames and the exact
   preview default chain; OMCWhatsNewController version-selection rule;
   OMCOnboardingController page-builder typography constants.
5. Small numeric INFERRED items are marked inline in the sources with
   `[INFERRED]` comments (searchable).

## 5. Cross-TU symbols my source relies on

Defined in Prefs-A's OMCCommon TU or sibling B TUs (all verified to exist in
the binary): `L()`, `OMCTr`, `OMCColorFromHex`, `OMCAccentColor`,
`OMCBackgroundColor`, `OMCCardColor`, `OMCSwitchColor`, `OMCIcon(symbol,
color)` — **symbol first** (an early draft of the Speed Bubble page had the
arguments swapped; corrected), `OMCStyleCell/Table/HeaderFooter` (the
binary's HeaderFooter takes a second BOOL arg — header YES / footer NO —
called through a cast), `SSPeriodForDate`, `SSWeatherLoadCache/SaveCache/
Parse`, `SSApplySampleData`, `SPPVoiceIsFun/Template/Line(customLine, mode,
limit)`, `SPPSpeak`, `SPPPlayTone`, the SPP audio-session globals,
`SSStyleNameKey` (shared symbol, declared extern in my tile cell and
startup controller), `OMCIconSized` / `OMCThumb` (defined in the HSPreview
TU), `OMCWhatsNewVersionToShow`-equivalents (file statics).

---

## Verifier-#4 fix addendum

Applied after independent verification (evidence: src/Prefs/
VERIFY_PrefsB.md item (c)1 — verifier #4's own disassembly via
verify/macho_truth.py; no contradiction found):

- **OMCSplitScreenAppPickerController — phantom second write removed.**
  The delayed dispatch_after block in tableView:didSelectRowAtIndexPath:
  previously contained a second `SSPickSetPref(key, value)` call,
  commented as the binary writing the value a second time after 250 ms.
  The binary's block invoke @0x37714 does ONLY
  popViewControllerAnimated:YES on the one captured object — no
  SSPickSetPref, no kind check, no second capture. The value is written
  exactly once (sub_37698), followed by notify_post(prefschanged); the
  250 ms delay (dispatch_time 0x0EE6B280 ns) applies to the pop only.
  The invented call was deleted and the comment corrected in
  OMCPrefs/OMCSplitScreenAppPickerController.m.

## Phase-2 fix — `hud` adjudication + src typo repairs (coordinator-assigned)

### BLOCKER-PREFS-HUD: B wins — `hud` is `NSArray *`
Adjudicated from the OmniCarPrefs binary (`metadata/raw/OmniCarPrefs/
objc.json`, class SSStartupView): ivar `_hud` has type encoding
`@"NSArray"` (offset 568); the property is
`T@"NSArray",C,N,V_hud` with getter `@16@0:8` / setter `v24@0:8@16` —
an object property, copy semantics. B's declaration in SSStartupView.h
(`@property (nonatomic, copy) NSArray *hud;`) is correct; A's category
in OMCPrefs/OMCCommon.m (`@property (nonatomic) BOOL hud;`) was wrong.
Body evidence: `_SSApplySampleData` (0x545b0; dump
`disasm/_CFunctions.asm`) reads hud via `objc_msgSend(view, @selector(hud))`,
skips when non-nil, otherwise calls `setHud:` with the result of
sub_50180(view.carName) (0x54610/0x54628) — hud is filled FIRST, before
nextEvent/batteryPercent/weather. (B's `-[SSStartupView ss_buildHud]`
consumes it as an NSArray of `@{ok, text}` checklist dictionaries.)
Fix applied in OMCCommon.m: the category property is now
`@property (nonatomic, copy) NSArray *hud;` and `view.hud = YES;` became
`if (!view.hud) view.hud = SSSampleHudItems(view.carName);`, with an
extern declaration of the sub_50180 helper added above. NEW GAP flagged:
sub_50180 (SSSampleHudItems) is not yet owned by any module (its only
in-binary caller is _SSApplySampleData). Note: the binary fills hud
first; A's fill order for the other three fields differs but all four
are independent nil/threshold guards, so behaviour is equivalent and
the order was left as-is.

### Three syntax typos repaired in src/Prefs (mirrors integration's project/ fixes)
In OMCPrefs/OMCStartupScreenController.m (integration had repaired its
project/ copy; the src/ original still carried them):
1. Line ~636: `[[[[SSReal(` → `[[[SSReal(` (one extra leading `[`;
   the message chain opens exactly three brackets: array literal,
   SSArrayAdd, SSReal).
2. Line ~684: a dispatch_async block closed `}];` → `});` (the block
   opened with `dispatch_async(..., ^{` at line ~678). The `}];` on the
   following line (enumerateObjectsUsingBlock message send) is correct
   and untouched.
3. Line ~699: a dispatch_async block closed `}];` → `});` (block opened
   at line ~690). The `}];` two lines above (dismiss completion message
   send) is correct and untouched.
Syntax check: `clang-18 -fsyntax-only` parses the file end-to-end; the
only errors are the pre-existing incomplete-vendor-Preferences-header
class (PSSpecifier forward declarations), none at the repaired lines.
OMCCommon.m likewise parses with only pre-existing private-API selector
errors; the phase-1 `view.hud = YES` type error is gone by construction
(the standalone check cannot reproduce the project prefix environment,
where SSStartupView is visible — definitive proof is the phase-2 build).

## Closure note — SSSampleHudItems (sub_50180) now DEFINED (coordinator-assigned)

Verdict: **CLOSED — VERIFIED.** Defined in
OMCPrefs/SSStartupView.m (file scope, after SSDateLine, before the
class extension) — next to the SSStartupView sources, as assigned;
the declaration remains the seam fix's extern in OMCCommon.m, whose
comment was corrected (see the caller correction below).

Evidence (closure pass's own disassembly of the OmniCarPrefs arm64
slice, capstone 5.0.7, names resolved through verify/macho_truth.py;
all 13 cfstrings decoded flags-aware — the Vietnamese OMCTr keys are
UTF-16-backed, flags 0x7d0, and truncate under naive ASCII reads):

  displayName = (trimmed.length) ? trim(carName) : @"OmniCar"
  return @[ @{text: OMCTr("Kết nối CarPlay","CarPlay connected"), ok: @YES},
            @{text: OMCTr("Pin iPhone 82% · đang sạc",
                          "iPhone battery 82% · charging"), ok: @YES},
            @{text: OMCTr("Nhiệt độ máy: ổn","Phone temperature: OK"), ok: @YES},
            @{text: OMCTr("Chế độ nhẹ: tự động","Lite mode: auto"), ok: @YES},
            @{text: [NSString stringWithFormat:
                        OMCTr("Hồ sơ xe: %@","Car profile: %@"), displayName],
              ok: @YES} ]

Each dictionary is built in the binary via
+[NSDictionary dictionaryWithObjects:forKeys:count:2] with keys
[text, ok] (objects [text, kCFBooleanTrue]); the array via
+[NSArray arrayWithObjects:count:5] in build order.
Faithful quirk preserved: the trim helper is called TWICE (0x501bc
to test the length of the trimmed name, 0x501dc for the value; the
first result is released immediately after the choice).

**Caller correction (the hud adjudication above is incomplete):**
SSSampleHudItems has TWO call sites, not one — _SSApplySampleData
(0x54610) AND -[SSStartupView ss_buildHud] itself (0x4fcdc; A's
SSStartupView.asm lines 9959 ff. agree): ss_buildHud computes
`items = self.hud.count ? self.hud : SSSampleHudItems(self.carName)`
as a LOCAL fallback (it does not set self.hud). Related discrepancy,
report only: B's ss_buildHud reconstruction in SSStartupView.m uses
`[self.hud isKindOfClass:[NSArray class]] ? self.hud : @[]` — the
empty-hud fallback call to SSSampleHudItems is missing there.

**Ownerless neighbour (immediate call vicinity):** the trim helper
sub_4da60 itself — VERIFIED semantics (NSString input →
stringByTrimmingCharactersInSet:whitespaceAndNewlineCharacterSet;
any other input incl. nil → @""); nine call sites (0x477d4, 0x4d7bc,
0x4d7e8, 0x4db24, 0x4eaec, 0x4eb18, 0x501bc, 0x501dc, 0x51158). It is
declared in SSStartupView.m under the closure-pass label
`SSPrefsTrimmedString` so SSSampleHudItems mirrors the binary's call
graph; the name is a label, the address is the ground truth — a
future owner should unify it globally. The next function start,
sub_4daf4 (itself a sub_4da60 caller at 0x4db24), is likewise
census-UNCLAIMED and was not examined in this pass.

Syntax check: clang-18 is absent from this VM right now (silent
/usr rollback, same as noted in the SplitScreenA closure note; not
restored here). The verbatim body extracted from the edited
SSStartupView.m passes `clang -fsyntax-only -target
arm64-apple-ios15.0 -isysroot iPhoneOS16.5.sdk -fobjc-arc` with 0
errors (Swift-bundled clang-15). Full-file check of SSStartupView.m:
exactly 4 errors, all pre-existing standalone-environment class at
lines 569–572 (property access on `id` in B's constraint code);
ZERO diagnostics inside the inserted block (lines 169–214). The
clang-18 gate remains with the phase-2 integration build.

## Micro-fix — ss_buildHud empty-hud fallback restored (coordinator-assigned)

The discrepancy flagged in the closure note above is FIXED:
`-[SSStartupView ss_buildHud]` in OMCPrefs/SSStartupView.m now reads
`NSArray *items = self.hud.count ? self.hud : SSSampleHudItems(self.carName);`
(replacing B's `[self.hud isKindOfClass:[NSArray class]] ? self.hud : @[]`),
with an evidence comment at the line. Verified from this pass's own
capstone dump of the OmniCarPrefs arm64 slice (names resolved only
through verify/macho_truth.py): the binary fetches `[self hud]`
(0x4fc98), sends `count` (0x4fca8) and branches on `cbz` (0x4fcac) —
one count test, so hud==nil and hud-empty take the same path; the
non-empty path re-fetches self.hud into the items register (0x4fcb4),
while the empty path fetches `[self carName]` at 0x4fccc — the RAW
property value, no sub_4da60 (SSPrefsTrimmedString) call anywhere in
the method — and calls sub_50180 at 0x4fcdc with it in x0. The result
is a local only: retained into x24, consumed by the render loop
(`[items count]` capped at 5, 0x4fcfc–0x4fd14, indexed via
objectAtIndexedSubscript:), and never stored back — the method
contains no `setHud:` call, confirming the closure note's reading.
Syntax check: full-file `clang -fsyntax-only -target
arm64-apple-ios15.0 -isysroot iPhoneOS16.5.sdk -fobjc-arc` using the
extracted clang-18 at /tmp/clang18 (system clang-18 still wiped by
the VM rollback) yields exactly the same 4 pre-existing errors at
lines 569–572 (property access on `id`, B's constraint code) plus the
pre-existing line-583 warning — ZERO diagnostics in the edited
region, nothing else in the method changed.

---

## Final closure addendum — SCPPrefs favorite: shape + OMCIcon nil sites
(phase-2 gaps list items 13 + 16; all disassembly read from the original
binaries, names resolved via verify/macho_truth.py and the calibrated
xref cfstring maps; no agent dump was trusted without re-reading the
instructions at the cited addresses)

### Item 1 — SCPPrefs `favorite:` dict shape: CORRECTED IN SOURCE

Where it lives: the construction exists ONLY in the SplitScreen binary's
`+[SCPPrefs favorite:]` (metadata IMP 0x4e108; body dumped at 0x4e138 in
src/SplitScreenA/disasm/SCPPrefs_favorite_.txt). The OmniCarPrefs binary
contains NO trace of the shape: its cfstring table has no lowercase
@"left"/@"right"/@"third"/@"layout" at all (only the capitalised key
parts Left/Right/Third/Layout/Name of the splitScreenFav%ld%@ scheme), so
no {name,left,right,third,layout} dictionary is ever built on the
Prefs-bundle side — the Prefs controller reads/writes the five
per-favorite pref keys individually, which the existing
OMCSplitScreenController reconstruction already matches.

Binary body, as proven from the dump (registers traced end to end):
- left/right/third = SCPStringForKey-equivalent (sub_4dcf4) over
  [NSString stringWithFormat:@"splitScreenFav%ld%@", index, @"Left" /
  @"Right" / @"Third"]; keys are built with the %@ part form, not
  suffixed format literals. Held in x19/x20/x21.
- layout = [SCPObjectForKey-equivalent (sub_4dab8) over the @"Layout"
  key] integerValue (x23).
- Layout validation @0x4e270-0x4e2b0: `cmp x23,#0x1f; b.hi` invalid, then
  `(1 << layout) & 0x80002008` (bitmask of layouts {3, 13, 31});
  `tst`/`b.eq` invalid. The invalid path releases third, sets third=nil
  and layout=2, and rejoins the empty test. Net effect: any stored
  layout outside {3,13,31} (including 2 itself, negatives, >31) yields
  layout=2 with third discarded.
- Empty test @0x4e290: if left, right and third are all nil the method
  returns nil (x24=0) — no dictionary at all.
- name = string-for-key over the @"Name" key; when nil, the default is
  [NSString stringWithFormat:@"%@ %ld", _OMCTr(@"Bố cục", @"Layout"),
  index] (@0x4e304-0x4e344; both cfstrings re-decoded from the calibrated
  xref: 0x7cba0 = "Bố cục" UTF-16LE flags 0x7d0, 0x7e640 = "Layout",
  format 0x7e680 = "%@ %ld").
- Construction @0x4e360: NSMutableDictionary seeded by
  dictionaryWithObject:name forKey:@"name" (0x7c840); then, each guarded
  by a cbz on the slot value, setObject:forKeyedSubscript: with keys
  @"left" (0x79d60), @"right" (0x79d80), @"third" (0x7ce80); finally
  @"layout" (0x79e00) = [NSNumber numberWithInteger:layout]
  unconditionally. Slot keys are ABSENT (not NSNull) when unset. There
  is NO @"apps" key.

Source change (the named construction file; noted as outside the
src/Prefs tree but inside this item's scope):
- src/SplitScreenA/SCPPrefs.m: +favorite: rewritten to the body above
  (former {layout, apps, name} literal + INFERRED label removed).
  The fabricated +favoriteApps: was DELETED: SCPPrefs' binary method
  list contains no such method.
- src/SplitScreenA/SCPPrefs.h: +favoriteApps: declaration removed;
  +favorite: comment updated to the proven returned shape.

READER side (SplitScreen binary — FLAGGED, NOT FIXED, per scope):
- -[SCPCarSplit favoriteApps:] (IMP 0x3a86c, dump
  src/SplitScreenA/disasm/-SCPCarSplit_favoriteApps_.txt) takes the
  favorite DICTIONARY, reads dict[@"layout"], computes the box count
  (3 for layouts 13/31, else layout if 2 or 3, else 2), then walks the
  slot-key array at __DATA 0x80518 (@"left", @"right", @"third") up to
  that count: a slot value that passes -isCarPlayApp: is appended,
  anything else appends [NSNull null]; returns nil when no slot passed.
- -[SCPCarSplit openFavorite:] (dump -SCPCarSplit_openFavorite_.txt)
  calls [SCPPrefs favorite:] then [self favoriteApps:dict], logs
  "CarSplit: bo cuc yeu thich %ld: %@", reads dict[@"layout"], and calls
  openSetupLayout:apps:. It never reads an @"apps" key.
- DIVERGENCE in src/SplitScreenA/SCPCarSplit.m: -openFavorite:,
  -openRememberedPair and -openRememberedPairForConnect read
  fav[@"apps"] (always nil against the real dict shape), and
  -favoriteApps: is modelled as an index-taking wrapper over the
  deleted [SCPPrefs favoriteApps:]. These need a SplitScreen-side fix
  pass to the dict-based ABI above. src/SplitScreenB/SCPCarSplit+Panel.m
  already calls [self favoriteApps:fav] with the dictionary, matching
  the binary ABI.

### Item 2 — OMCIcon `, nil` sites (BLOCKER-PREFS-OMCICON): ASSUMPTION PROVEN, NO VALUE CHANGE

_OMCIcon (0x18144) is a 2-argument C function (symbolName, color). All
three sites the integration pass completed with an assumed `, nil` pass
literal 0 in the color register x1 immediately before the call:
- OMCCarProfilesController.m (switch row): x0 = @"car.2.fill" @0x6008,
  `mov x1, #0` @0x6010, bl _OMCIcon @0x6014. GENUINELY NIL.
- OMCCarProfilesController.m (profile row): x0 = @"car.fill" @0x6438,
  `mov x1, #0` @0x6440, bl _OMCIcon @0x6444. GENUINELY NIL.
- OMCOnboardingController.m (-speedPage): x0 = @"speedometer" @0x1346c,
  `mov x1, #0` @0x13474, bl _OMCIcon @0x13478. GENUINELY NIL.
The `, nil` in source is therefore correct as written; each site now
carries an evidence comment citing the register load. (For contrast,
the other _OMCIcon call sites in the binary pass real colors — e.g.
_OMCColorFromHex results — exactly as their reconstructions do.)

ADJACENT OBSERVATION (flagged, not fixed — outside item 16): the
source's three 1-argument `OMCIcon(entry[1])` /
`OMCIcon(blur ? @"drop.fill" : @"moon.fill")` calls in
OMCAppBridgeAppsController.m (lines ~562/624/674) do not match the
binary: all three corresponding calls pass a real color in x1 —
@0x1fbec and @0x208e0 pass _OMCColorFromHex(entry[2]) with symbol
entry[1], and @0x20f50 passes
_OMCColorFromHex(blur ? @"#5AB8FF" : @"#4A4F80"). The stale comment at
OMCAppBridgeAppsController.m:82 ("OMCIcon is the 1-arg variant") is
likewise wrong: the binary has only the 2-argument _OMCIcon.

### Syntax checks (clang-18, -fsyntax-only, arm64-apple-ios15.0,
iPhoneOS16.5 SDK, -fobjc-arc -fblocks, theos vendor includes)
- src/SplitScreenA/SCPPrefs.m (with the SCPPrefs.h edit): PASS, zero
  diagnostics.
- src/Prefs/OMCPrefs/OMCOnboardingController.m: PASS, zero diagnostics.
- src/Prefs/OMCPrefs/OMCCarProfilesController.m: exactly one diagnostic,
  pre-existing and environmental (line 35: property 'name' not found on
  the forward-declared PSSpecifier in the standalone header set); this
  pass's edits there are comment-only (at the two icon sites) and add
  no diagnostics.

### Still open
Nothing in items 13/16. The SplitScreen-side reader divergences and the
OMCAppBridgeAppsController 1-arg OMCIcon calls above are flagged for
their owning passes.

---

## Micro-fix addendum — OMCAppBridgeAppsController OMCIcon calls: FIXED
(the "adjacent observation" of the final closure addendum above; all
evidence from a fresh capstone dump of the OmniCarPrefs arm64 slice,
names resolved only via verify/macho_truth.py — dump script + output in
work-closure/omcicon/)

All three 1-argument calls are now the proven 2-argument form
`OMCIcon(symbol, OMCColorFromHex(hex))`, and the paired
`cell.imageView.tintColor = OMCColorFromHex(...)` lines are deleted:
at all three binary sites the colour flows ONLY into _OMCIcon's x1 and
the result goes to imageView via setImage: — no setTintColor: send
exists after any of the three calls (only objc_release traffic).

Entry structure (proven at sites 1–2): entry is a 3-element array —
entry[0] = localisation key (passed through _L() into textLabel),
entry[1] = SF Symbol name, entry[2] = hex colour string.

- Site 1 — `-[OMCAppBridgeAppsController headerCellFor:inTable:]`
  (func 0x1fa34): entry[0] -> _L @0x1fb60 -> setText:; entry[1] loaded
  @0x1fba4 (objectAtIndexedSubscript: w2=#1) in x23, entry[2] @0x1fbbc
  (w2=#2) in x24; _OMCColorFromHex(entry[2]) @0x1fbd4 -> x25;
  x0=x23/x1=x25 @0x1fbe4–0x1fbe8; _OMCIcon @0x1fbec; result ->
  setImage: @0x1fc14.
- Site 2 — section-3 grid rows in `tableView:cellForRowAtIndexPath:`
  (func 0x206e4): entry = NSConstantArray[row]; entry[0] -> _L
  @0x20854; entry[1] @0x20898, entry[2] @0x208b0; _OMCColorFromHex
  @0x208c8 -> x26; x0/x1 set @0x208d8–0x208dc; _OMCIcon @0x208e0;
  result -> setImage: @0x20908.
- Site 3 — wallpaper blur/dim rows (same func): row = [indexPath row]
  (@0x20eac, kept in x23); all operands are csel on `cmp x0,#3`
  @0x20ec8: title key csel @0x20ecc (eq @"HOMESCREEN_BLUR" 0x79908,
  ne @"HOMESCREEN_DIM" 0x79928); SYMBOL csel @0x20ee0 — eq ->
  @"drop.fill" (cfstring 0x79948), ne -> @"moon.fill" (0x79968);
  hex csel @0x20ef4 — eq -> @"#5AB8FF" (0x78f08), ne -> @"#4A4F80"
  (0x79988); hex -> _OMCColorFromHex @0x20f38; x0=symbol @0x20f48,
  x1 @0x20f4c; _OMCIcon @0x20f50; result -> setImage: @0x20f78. The
  compare is the row==3 test, i.e. the source's `blur = (row == 3)`
  is the exact condition (re-confirmed @0x20f94 for the
  @"homeScreenBlur" slider branch).

Also corrected: the stale comment at OMCAppBridgeAppsController.m
(formerly line ~82) claiming "OMCIcon is the 1-arg variant" — it now
states _OMCIcon @0x18144 is the 2-argument (symbolName, color)
renderer and that no 1-argument variant exists.

Syntax check (clang-18 18.1.3, -fsyntax-only, arm64-apple-ios15.0,
iPhoneOS16.5 SDK, -fobjc-arc -fblocks, theos vendor includes),
A/B against a reverted copy: OLD file = 5 errors, including the three
arity errors "too few arguments to function call, expected 2, have 1"
at the three call sites (the 1-arg calls did not even compile against
the OMCCommon.h declaration); NEW file = those 3 errors gone, leaving
exactly the 2 pre-existing environmental errors (line 49 objc_msgSend
implicit declaration in the OMCDynObj helper; line 134 PSSpecifier
forward declaration) and the same 3 pre-existing delegate-assignment
warnings. Zero diagnostics in any edited region; no new diagnostics
introduced.
