# OmniCarPrefs — Reconstruction Report (Agent A scope)

Module: `OmniCarPrefs` (1,303,344 B fat DYLIB, arm64 slice analysed),
principal class `OMCRootListController`, 29 classes / 743 methods total.

**Partition:** this report covers ONLY Agent A's claim (see `PARTITION_A.txt`):
the shared C core (`OMCCommon`, 42 C functions), 7 classes / 100 methods
(OMCCardPage, OMCRootListController, OMCFeatureListController, OMCHeaderCard,
OMCFeatureStatusCell, OMCAppBridgeAppsLinkCell, OMCSplitScreenAppLinkCell),
and the shared infrastructure (full disassembly of all 809 functions in
`disasm/`, tools in `tools/`). The other 22 classes / 637 methods are Agent
B's (`PARTITION_B.txt`); B files its own report. Preference keys below are
only those proved from A's classes/C functions; the coordinator merges with
B's table.

Evidence labels: **[VERIFIED]** = read directly from the annotated
disassembly (`disasm/`, capstone + chained-fixup-aware parser written for
this project). **[INFERRED]** = name/structure reconstructed from call
sites. No silent stubs anywhere: cosmetic drawing code is reconstructed at
call level with constants, and the two diagnostics builders are graded
honestly in §4.

---

## 1. CRITICAL TOOLING FINDING — shared metadata parser bind off-by-one

`metadata/tools/macho_objc.py` (`_import_name`) subtracts 1 from bind
ordinals. For this image (chained-fixups format 6) the correct mapping is
`imports[ordinal]` (0-based). Verified semantically on independent slots
(0x55874=CFPreferencesSetAppValue, 0x55850=CFPreferencesAppSynchronize,
0x55c70=notify_post, 0x55cb8=objc_autoreleaseReturnValue).

**Consequence for ALL modules:** every bind-resolved name produced by the
shared metadata parser is shifted by one import, and the "surprising
superclasses" in `metadata/*.md` are wrong. Corrected Prefs superclasses
(from `disasm/classes.json`, produced by A's corrected local decoder):
OMCCardPage→PSViewController, OMCFeatureListController→PSListController,
OMCRootListController→PSListController, OMCAppBridgeAppsController→
PSViewController, OMCHomeScreenController→OMCAppBridgeAppsController,
OMCSpeedBubbleController→OMCCardPage, OMCSplitScreenController→OMCCardPage,
OMCStartupScreenController→OMCFeatureListController, cells→PSTableCell,
views→UIView, OMCOnboardingController/OMCWhatsNewController→UIViewController.
**Other module agents must apply the same correction before trusting any
superclass or imported-symbol name in the metadata markdown files.**

## 2. Class → plist / specifier-source map

| Class | Specifier source | Notes |
|---|---|---|
| OMCRootListController | `Root.plist` (static, 15 items) **+ code-inserted feature rows** | `-specifiers` = load Root → `insertFeatureSpecifiers` → `OMCLocalizeSpecifiers` → `applySupportState` [VERIFIED instruction-level] |
| OMCFeatureListController | plist named by the **`plist` property** of the pushing specifier | generic loader; used directly by Startup Screen |
| OMCStartupScreenController (B) | `FeatureStartupScreen.plist` (44 items, statically declared) | via the same `plist` property mechanism |
| OMCSpeedBubbleController (B) | code-built (OMCCardPage) | its Feature plist carries only group + enable switch |
| OMCSplitScreenController (B) | code-built (OMCCardPage) | same |
| OMCCardPage subclasses | no plists — rows assembled in code | base class provides pref-bound control factory |

**Root.plist static items (15):** rescue group (`omcGroup=rescue`,
id `rescueGroup`) + `rescueRestore` button; conflicts group
(`omcGroup=conflicts`, id `conflictsGroup`) + `conflictsRow` static text;
APPS group + link → OMCAppBridgeAppsController (cellClass
`OMCAppBridgeAppsLinkCell`) + link → OMCHomeScreenController; empty
FEATURES group (id `features`); PROFILES link → OMCCarProfilesController;
SUPPORT group + `showGuide` / `showWhatsNew` buttons; DEV group +
`sendLog` button.

**Code-built feature rows** (`insertFeatureSpecifiers`, [VERIFIED]):
scans bundle `Feature*.plist`s, sorts by `featureOrder`
(StartupScreen 10, SpeedBubble 20, SplitScreen 30), inserts one
`PSLinkCell` per feature after the `features` group with properties
`plist`, `cellClass=OMCFeatureStatusCell`, `icon`, `symbol`, `featureKey`
(the feature's PSSwitchCell key), `featureDefault`.

**Dynamic Root groups** (`currentSupportState`/`applySupportState`,
[VERIFIED]): change token `"<rescue names, comma-joined>|<active conflict
names, ', '-joined>"`; rescue/conflicts specifiers are removed when their
state part is empty, footers/row text refilled otherwise.
`viewWillAppear:` reloads specifiers only when the token changed.

**Custom cells:** OMCFeatureStatusCell (feature on/off from
`featureKey`/`featureDefault`), OMCAppBridgeAppsLinkCell (count of
`appBridgeApps`), OMCSplitScreenAppLinkCell (app name for a bundle id in
the pref named by the specifier's `key` property, via LSApplicationProxy).

## 3. Non-UI logic found in this binary

- **Expiry / licensing [VERIFIED]:** `OMCExpired()` — deadline parsed once
  from the literal date string `@"2027-04-30"` with an `en_US_POSIX`
  `yyyy-MM-dd` formatter pinned to GMT+7, **+ 86400 s ⇒ expiry instant =
  2027-05-01 00:00:00 GMT+7**. Expired iff
  `max(now, pref "trustedTime") >= deadline` (anti-clock-rollback); result
  cached in a static. `OMCEnabled()` = `!expired && pref "enabled" (def YES)`.
  The Prefs side only *displays* this (header status STATUS_EXPIRED,
  toggle disabled); enforcement lives in the tweak dylibs' own copies of
  the same OMCCommon core.
- **Vendored mini-libroot [VERIFIED]:** helper at 0x4118/0x4170 dlopens
  `@rpath/libroot.dylib`, dlsyms `libroot_get_root_prefix`,
  `libroot_get_jbroot_prefix`, `libroot_get_boot_uuid`,
  `libroot_jbrootpath`, `libroot_rootfspath`; fallbacks: root prefix "",
  jbroot "/var/jb". Used for the bundle path (`OMCTr`), tweak-dir scans
  and cache paths.
- **Rescue mechanism [VERIFIED]:** pref `rescueFeatures` (array of feature
  names) is written by the tweak side when a feature breaks; Settings
  shows the rescue group only for listed features that are currently
  disabled. `OMCRescueRestore()` sets each `<feature>Enabled` =
  `kCFBooleanTrue`, deletes `rescueFeatures` and `rescueDate`, syncs and
  posts `com.anlai.omnicar/prefschanged`.
- **Conflicting tweaks [VERIFIED]:** rule table decoded from constant
  arrays — CarBridge/`carbridge`, DuoDash/`duodash`, TrueDash/`truedash`,
  CarPlayEnable/`carplayenable`. "Active" = matching `.dylib` present in
  (jbroot) `/Library/MobileSubstrate/DynamicLibraries` or
  `/usr/lib/TweakInject`; versions parsed from `/var/lib/dpkg/status`.
- **Diagnostics engine [VERIFIED data model]:** `OMCDiagSections()` /
  `OMCDiagChecks()` / `OMCDiagSummary()` / `OMCShareReport()` consume
  state the dylibs publish into the same prefs domain: `diagCar`
  (name/transport/pixels/points/scale/maxFPS/connected/date…), `diagPerf`
  (cpuAvg/cpuMax/memMB/memMaxMB/hangs/hangMaxMs/freezes/worstMs/thermalMax/
  fps/sysFreeMinMB/availMinMB…), `diagHooks.<module>`, `diagLoaded.<module>`
  (bools), `diagLastCrash` (date/suspect). Checks vocabulary: ~40
  `CHK_*` title/fix keys, statuses `ok|warn|bad`, optional `fix` and
  `action` (`respring`). Share report writes
  `NSTemporaryDirectory()/OmniCar-log-<yyyyMMdd-HHmm>.txt`, appends
  `/var/mobile/Documents/OmniCar.log` (+ `.old`), and presents a
  UIActivityViewController.
- **Respring [VERIFIED]:** primary = dlopened FrontBoardServices/
  SpringBoardServices, `SBSRelaunchAction actionWithReason:
  @"RestartRenderServer" options:4`, sent via `FBSSystemService`;
  fallback = `posix_spawn(killall -9 SpringBoard)` with the first
  executable of `@["/var/jb/usr/bin/killall", "/usr/bin/killall"]`.
- **Language system [VERIFIED]:** 14 locales; `language` pref wins if
  supported, else NSLocale matching (exact → "code-" prefix → base
  language; base pass skipped for `zh`); fallback `en`. `_L()` reads a
  merged dict of all `.strings` tables of the active locale (en fallback
  merged first; `Car.strings` excluded — it is `OMCTr`'s table).
  `OMCTr(vi, en)`: vi→vi text, en→en text, other locale→
  `Car.strings[en] ?: en` with a per-locale cache. **Note:**
  `-[OMCRootListController setLanguage:]` writes + syncs but does **not**
  post `prefschanged` (unlike every other write path).
- **Speed-bubble voice [VERIFIED]:** modes 3..7 are "fun" lines
  (`SPPVoiceIsFun`); `SPPVoiceTemplate` holds 8 verbatim vi/en line pairs;
  `SPPSpeak` uses AVSpeechSynthesizer with a language→BCP47 map and an
  unaccented-Vietnamese NSLog fallback; `SPPPlayTone` synthesises a WAV
  alert (`omc-speedbubble-tone-<n>.wav`) and plays it via AVAudioPlayer.
- **Startup weather [VERIFIED]:** Open-Meteo JSON → `{temp, code, isDay,
  high, low, rain, date}`; cache at (jbroot)
  `/var/mobile/Library/OmniCar/StartupScreen/weather.plist`, fallback
  `NSTemporaryDirectory()/OmniCarStartupWeather.plist`, 1-hour staleness.
- **URL handling:** no `omnicar://` (or any custom-scheme) handling exists
  in OmniCarPrefs — no openURL/URL-scheme code paths in this binary
  (the scheme belongs to the app binary's OMCAppDelegate).

## 4. Per-class coverage (A's classes)

| Class | Methods | Reconstructed | Fidelity | Evidence |
|---|---|---|---|---|
| OMCCardPage | 28 | 28 | VERIFIED (pref accessors + slider/switch handlers instruction-level; toast/box geometry call-level) | disasm/OMCCardPage.asm |
| OMCRootListController | 30 | 30 | VERIFIED (specifiers, insertFeatureSpecifiers, currentSupportState, masterToggled, setLanguage instruction-level; applySupportState call-graph level) | disasm/OMCRootListController.asm |
| OMCFeatureListController | 8 | 8 | VERIFIED | disasm/OMCFeatureListController.asm |
| OMCHeaderCard | 28 | 28 | Call-level (presentational; 24 of 28 are accessors) | disasm/OMCHeaderCard.asm |
| OMCFeatureStatusCell | 2 | 2 | VERIFIED | disasm/OMCFeatureStatusCell.asm |
| OMCAppBridgeAppsLinkCell | 2 | 2 | VERIFIED | disasm/OMCAppBridgeAppsLinkCell.asm |
| OMCSplitScreenAppLinkCell | 2 | 2 | VERIFIED | disasm/OMCSplitScreenAppLinkCell.asm |
| C functions (OMCCommon) | 42 | 42 | VERIFIED for all logic functions (language, strings, expiry, rescue, respring, conflicts, voice, weather, profile keys); call-graph level for _OMCDiagSections/_OMCDiagChecks (22 KB combined — data model, keys, formats and check inventory fully recovered; individual threshold branches not all re-derived), _OMCStyle*/_OMCLogoMeshImage (cosmetic drawing), _OMCIcon hue-bucket boundaries approximated | disasm/_CFunctions.asm |
| Block/callback subs | 24 | 24 | Referenced from their call sites (sort comparator, dynamic-colour providers, once-blocks decoded incl. the expiry-date block at 0x55694) | disasm/_Blocks.asm |

Grouping rule used (per task): accessors/synthesised getters-setters and
`dealloc`/`.cxx_destruct` are listed by selector in `disasm/index.json`
and in the generated headers (`OMCPrefs/generated/`) rather than written
out longhand; every non-trivial method has a hand-written reconstruction.

**Open caveats (explicit, not stubs):**
- `OMCCardColor()`'s two colours are baked into a static block object
  (0x748a0) and were not recoverable as hex constants; the reconstruction
  uses system background colours and says so in-source.
- `OMCDiagChecks` perf-family sub-checks (CHK_PERF_*) are implemented for
  the families whose inputs are fully proved; the original's exact
  per-family threshold ladder is only partially re-derived (the full
  22 KB disassembly is retained as ground truth).

## 5. Preference key table (proved from A's classes + C functions)

Domain for ALL keys: **`com.anlai.omnicar`** (CFPreferences). Every write
through the standard path syncs and posts
**`com.anlai.omnicar/prefschanged`** (notify_post + Darwin
CFNotificationCenter in PS machinery), except `setLanguage:` (no post —
see §3) and slider drags (raw set, post only on touch-up via storeValue).

| Key | Type | Default | Read sites (A) | Write sites (A) |
|---|---|---|---|---|
| `enabled` | BOOL | YES | _OMCEnabled, Root header | `masterToggled:` |
| `language` | NSString (14 codes) | NSLocale-derived, else `en` | _OMCCurrentLanguage | `setLanguage:` |
| `trustedTime` | NSNumber (epoch) | — | _OMCExpired | (tweak side only) |
| `rescueFeatures` | NSArray\<NSString\> (feature names) | — | _OMCRescueFeatures, Diag | deleted by _OMCRescueRestore |
| `rescueDate` | NSDate | — | DiagSections (string xref in _OMCDiagSections; the calibrated PREFS_MAP does not attribute this read — see §8), _OMCDiagChecks, _OMCRescueRestore | deleted by _OMCRescueRestore |
| `splitScreenEnabled` | BOOL | true (plist) | FeatureStatusCell (via featureKey), Diag | RescueRestore (kCFBooleanTrue), PS switch |
| `speedBubbleEnabled` | BOOL | true (plist) | same pattern | same |
| `startupScreenEnabled` | BOOL | true (plist) | same pattern | same |
| `appBridgeApps` | NSArray (bundle ids; element encoding proved by B's controller) | empty | OMCAppBridgeAppsLinkCell (count), DiagChecks (install check) | (B's controller) |
| `diagCar` | NSDictionary (name/modelName/vehicleName/accessoryName, transport, pixels, points, scale, maxFPS, connected, date) | — | DiagSections/DiagChecks | (dylibs only) |
| `diagPerf` | NSDictionary (cpuAvg, cpuMax, memMB, memMaxMB, hangs, hangMaxMs, freezes, worstMs, thermalMax, fps, sysFreeMinMB, availMinMB, tweaks, seconds, total, updated) | — | DiagChecks | (dylibs only) |
| `diagHooks.<module>` | NSString (`active`/…) | — | DiagSections (via CFPreferencesCopyKeyList) | (dylibs only) |
| `diagLoaded.<module>` | BOOL | — | DiagChecks | (dylibs only) |
| `diagLastCrash` | NSDictionary (date, suspect) | — | DiagChecks | (dylibs only) |

**Per-car profile keys** (constant list returned by `_OMCProfileKeys`,
[VERIFIED] decoded from `__objc_arraydata`): `splitScreenLastLeft`,
`splitScreenLastRight`, `splitScreenSplitRatio`,
`splitScreenSplitDirection`, `splitScreenPaneOrientation`,
`splitScreenAutoLaunch`, `splitScreenPinnedApp`, `speedBubbleSizeCar`,
`speedBubbleLook`, `startupScreenVideoName`, `startupScreenStyle`,
`startupScreenCarName`, `startupScreenTempo`, `appBridgeZoom`.
Semantics (how profiles are stored/switched) belong to B's
OMCCarProfilesController; the list itself is A-side C evidence.

**Reconciliation vs plist-declared keys:** the bundle plists declare
exactly **16** keys, matching the brief: `splitScreenEnabled`,
`speedBubbleEnabled` (Feature plists) + 14 in FeatureStartupScreen.plist:
`startupScreenVideoName` (string), `startupScreenScaleMode` (int, 0),
`startupScreenPlayFull` (bool, false), `startupScreenSound` (bool,
false), `startupScreenLogoEffect` (int, 0), `startupScreenGreetingName`
(string), `startupScreenCarName` (string), `startupScreenTempo` (int, 1),
`startupScreenDuration` (double 1–30, 5), `startupScreenTapToSkip`
(bool, true), `startupScreenSoundVolume` (double 0–100, 100),
`startupScreenSoundSkipCall` (bool, true), `startupScreenOccasions`
(bool, true), and `startupScreenEnabled`. Root.plist declares **no**
keys. **Code-only keys proved from A:** `enabled`, `language`,
`trustedTime`, `rescueFeatures`, `rescueDate`, `appBridgeApps`,
`diagCar`, `diagPerf`, `diagHooks.*`, `diagLoaded.*`, `diagLastCrash`,
plus the 14 profile keys above (of which `startupScreenVideoName`,
`startupScreenCarName`, `startupScreenTempo` are also plist-declared).

## 6. Cross-module evidence handed to B / coordinator

Decoded constant arrays in this binary (in `__objc_arraydata`, useful to
B's controllers and to the AppBridge/SplitScreen module agents):
- Car-name fallback keys: `[modelName, name, vehicleName, accessoryName,
  model]`; manufacturer keys: `[model, manufacturerName, manufacturer,
  vehicleManufacturer, accessoryManufacturer]`.
- Loader package ids: `ellekit`, `mobilesubstrate`,
  `com.opa334.libhooker`, `org.coolstar.libhooker`, `com.ex.substitute`.
- Known nav apps (name/bundle id): Vietmap Live/`vn.vietmap.live`,
  GOFA/`com.lumi.GOFA`, Waze/`com.waze.iphone`, Wyn/`com.wynauto.wyn`.
- Build fingerprint shown in diagnostics: version `1.0.3`, build
  `fbebb21`.

## 7. A-side deliverables

- Source: `OMCPrefs/` — OMCCommon.h/.m (42 C functions + SPPSoundDelegate
  forward declaration), OMCCardPage, OMCFeatureListController,
  OMCRootListController, OMCHeaderCard, OMCCells (3 cells).
- `OMCPrefs/generated/` — machine-generated interface skeletons for all
  29 classes (ivars/protocols evidence; method lists in disasm/index.json).
- `disasm/` — annotated disassembly of all 809 functions + `index.json`
  (per-function selectors/strings/calls) + `classes.json` (corrected
  superclasses/ivars/properties).
- `tools/` — disasm.py (corrected chained-fixup parser), condense.py,
  dump_consts.py, gen_headers.py.

## 8. Calibration cross-check (coordinator broadcast, 2026-11-08 09:23)

The App/IPC agent's LC_DYSYMTAB-calibrated xref (`metadata/xref/
OmniCarPrefs.json`, calibration delta +1 vs wave-1, 212/212 votes) was
diffed programmatically against this report's disassembly:

- **Import + objc_msgSend call targets: 18,642 compared, 18,642 identical,
  0 conflicts.** Every import name and selector attribution used in A's
  source is confirmed. (5 calibrated call sites at 0x4038–0x4168 have no
  counterpart line in A's asm: the tiny `dispatch_once` thunk functions at
  the start of `__text` — a function-boundary artifact in A's renderer,
  not a naming disagreement.)
- **Superclasses:** the calibrated JSON carries no superclass table, but
  its delta is exactly the correction A's decoder applied independently
  before the broadcast (§1: wave-1 subtracted 1 from the ordinal; correct
  is 0-based). A's superclasses therefore stand unchanged; they are also
  semantically forced (e.g. OMCRootListController uses
  PSListController-only APIs; OMCCardPage implements its own table data
  source on PSViewController).
- **PREFS_MAP spot-agreement:** the calibrated package-wide key map
  confirms A's reconstruction exactly where they overlap — `enabled` is
  written only by `-[OMCRootListController masterToggled:]`, `language`
  only by `-[OMCRootListController setLanguage:]`, and
  `rescueFeatures`/`rescueDate` are removed (NULL writes) by
  `_OMCRescueRestore`. It counts 53 distinct keys package-wide
  (16 plist-declared + 37 code-only) for the coordinator's merged table.
- **Attribution gaps in the calibrated map (A's evidence is primary):**
  PREFS_MAP attributes no OmniCarPrefs reader for `diagLastCrash` or
  `rescueDate`; both strings are directly xref'd inside
  `_OMCDiagChecks`/`_OMCDiagSections` in A's per-function disassembly
  (their key-argument tracking does not cover every raw
  CFPreferencesCopyAppValue site in this binary), so A's read sites stand.
- **Corrections to A's source/report from this cross-check: none** — no
  name taken from wave-1 metadata survived into A's deliverables
  uncorrected, because A's disassembly pipeline had already applied the
  fix; the cross-check is recorded here as independent confirmation. If
  the verifier's adjudication reverses the calibration, the affected
  surface would be import/superclass *names* only (addresses,
  instructions and selector names are unaffected, per the broadcast).

## Verifier-fix addendum (wave 3, verifier #2 findings in VERIFY_Prefs.md)

Each fix below was re-verified independently against the payload before
editing (fix agent, 2026-11-08); no contradiction with the verifier was
found on any point.

1. **W1 — FeatureStartupScreen.plist item count (§2 table).** Was
   "40 items", corrected to **44 items**. Evidence: `plistlib` parse of
   the payload plist
   (`payload/.../OmniCarPrefs.bundle/FeatureStartupScreen.plist`),
   `len(items) == 44`. The wrong count appeared only at that one place
   in `src/Prefs/`; no other file carried it.
2. **W2 — `_OMCSwitchColor` (OMCCommon.m, was lines 296–297).** Was:
   address `0x1806c`, body `return OMCAccentColor();` ("accent colour
   path"). Corrected to address **0x17fd8** and body
   `return [UIColor systemGreenColor];`. Evidence (independent capstone
   pass on the arm64 slice + `verify/macho_truth.py` resolver):
   `metadata/xref/OmniCarPrefs.json` lists `_OMCSwitchColor` at
   98264 = 0x17fd8; 0x17fd8 is present in LC_FUNCTION_STARTS while
   0x1806c is not (it is a `bl` to the `colorWithWhite:alpha:` objc
   stub @0x56f00 inside the function at 0x1800c); the 12 bytes at
   0x17fd8 are `adrp x8, #0x8e000; ldr x0, [x8, #0x910]; b #0x5d800`,
   where classref slot 0x8e910 resolves to class **UIColor** and stub
   0x5d800 resolves to selector **systemGreenColor**. The matching
   declaration comment in OMCCommon.h (line 115, "accent colour
   (12-byte thunk)") was corrected to match. Blast-radius check: all
   other purple/accent uses in the Prefs sources were inspected —
   `OMCAccentColor()` (0x17e8c, constants 0x7B6CF6/0xA89BFF, separately
   verified), the hue-band gradient pair `#B7A6FF`/`#8B7CFF`
   (OMCCommon.m), and the literal `[UIColor systemPurpleColor]`
   gradient in OMCAppBridgeAppsController.m are independent of this
   error and were left unchanged; every `OMCSwitchColor()` call site
   (switch `onTintColor` assignments in OMCCardPage.m,
   OMCFeatureListController.m, OMCRootListController.m,
   OMCHeaderCard.m, OMCAppBridgeAppsController.m) calls the function
   itself and inherits the corrected body, exactly as in the binary
   (switches are tinted system green, not the purple accent).
3. **Minor — `rescueDate` read sites (key table).** Added
   `_OMCDiagChecks` (and `_OMCRescueRestore`, which the verifier's xref
   also lists as a reader) to the `rescueDate` row's read column; the
   table previously listed only the _OMCDiagSections read. Per
   VERIFY_Prefs.md §4, derived from the verifier's own cfstring-xref
   scan of the binary.
