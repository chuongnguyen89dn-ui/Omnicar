# SplitScreen-C REPORT — the Home / app-icon injection family

Module agent C (wave 2.5, gap closure), OmniCar 1.0.3 reconstruction.
Target binary: `OmniCarSplitScreen.dylib` (1,229,920 B), arm64 slice
disassembled with capstone 5.0.7 via SplitScreen-A's calibrated annotator
(`work/omdis.py`); all class/selector/string names cross-checked against
`metadata/xref/OmniCarSplitScreen.json` + `metadata/ANNOTATION_AUDIT.md`
(wave-1 `objc.json` name fields are off-by-one-shifted and were NOT used).

Deliverables: source in `src/SplitScreenC/` (9 files), one annotated
disassembly per function in `src/SplitScreenC/disasm/` (98 files).
Scratch data (call graph, closure computation) in `work-C/`.

---

## 1. What this family is

The code that puts **user-chosen phone apps onto the CarPlay home grid**
and customizes that grid. Four sub-systems:

1. **Injection core** (`SCPAppIcons.m`) — reads the `appBridgeApps`
   preference, grafts a synthetic `CRCarPlayAppDeclaration` onto chosen
   apps' `DBApplicationInfo` objects, adds their
   `LSApplicationProxy`s to the dashboard application library, keeps the
   live library in sync when the choice changes, and runs a crash-guard
   state machine so a build that crashes CarPlay during injection
   disables itself until the app list changes.
2. **Grid hooks** (`SCPHomeHooks.m`) — the replacement bodies for the
   icon-grid hooks whose installers live in SplitScreen-A's `__init_0`:
   icon scale, column/row overrides, label hiding, and
   `isIconVisible:` filtering.
3. **Visibility + settings + apply** (`SCPHomeVisibility.m`,
   `SCPHomeSettings.m`, `SCPHomeApply.m`) — the hidden/shown app lists,
   the 8-key home-settings dictionary, the wallpaper wall view
   management, and the delayed sync that publishes `homeScreenCarApps`
   for the Settings UI.
4. **Picker builders + grid readers** (`SCPCarApps.m`) — the
   `{id, name}` app lists the split picker sheets are built from, plus
   an uncalled cluster that reads the live grid (see §4).

## 2. How the family was enumerated

1. **Symbol scan** of the arm64 slice: 28 `_SCP*` symbols; 27 belong to
   this family (the 28th, `_SCPMissingSelector` 0x4f330, is shared
   infrastructure with 60+ callers across all domains — boundary, §5).
2. **Call-graph closure**: direct-branch graph (`bl` + unconditional `b`)
   over all 886 LC_FUNCTION_STARTS starts, closed from the family seeds;
   plus a block-literal scan (invoke pointers in `__DATA_CONST,__const`)
   and a data-slot pointer scan over all non-`__TEXT` sections to catch
   functions referenced only as block bodies or through tables.
3. **Exclusions**: ObjC IMPs (A/B partition), A-covered functions (from
   A's report §6 list), the OMC core symbol set.
4. Manual addition: **sub_55f4** — the closure missed it because the four
   grid hooks *tail-branch* to it and my first pass counted only `bl`;
   found by reading the hook bodies. It is in LC_FUNCTION_STARTS.

**Result: 98 functions** (table in §7). One false positive was removed:
sub_89c0 (a `splitscreen.ack` observer block invoke — SplitScreen-A's,
SpringBoard group). The libroot fallback bodies (0x42b8/0x42c4/0x42d0/
0x4384) were dumped in addition to the closure's 0x42ac: they are
installed by this family's bootstrap (sub_4170) as a set.

## 3. Mechanism summary (all VERIFIED unless noted)

### 3.1 Injection

- Entry (A-covered hooks): `+[DashBoard _newApplicationLibrary]` body
  (0x4af0) calls `SCPAppIconsBeginInjection()`; if it returns YES it adds
  chosen apps and stores the home VC via the
  `-[DBDashboardHomeViewController initWithEnvironment:]` hook (0x4c70 →
  `SCPSetHomeViewController`, a bare `objc_storeWeak`).
- `SCPChosenPhoneApps()` (0x9a60): feature gate `appBridge`; reads pref
  `appBridgeApps` → NSSet.
- `SCPAddChosenAppsToLibrary()` (0xa500): for each chosen bid, if the
  library already has an info, it does nothing (the declaration is
  grafted when the system loads it); otherwise it adds a validated
  `LSApplicationProxy` (`appState.isValid`, sub_a860). Logs
  `AppIcons: them %lu / %lu app da chon vao thu vien %@`.
- `SCPInjectDeclarationIfChosen()` (0x9b34, called from A's
  `-[DBApplicationInfo _loadFromProxy:]` hook 0x4bcc): builds a
  `CRCarPlayAppDeclaration` with `setSupportsTemplates:NO`,
  `setSupportsMaps:YES`, bundle id and bundle path; KVC-sets
  `_carPlayDeclaration` and prepends the tag `OmniCarAppBridge` to
  `_tags`; forces `_valid` to true when the info wasn't valid; records
  the bid in the injected set (global 0x880c0, `@synchronized`). If a
  real declaration already exists it refuses (unless its tags already
  contain `OmniCarAppBridge`, i.e. it's ours).
- Crash guard: begin-injection arms pref `splitScreenIconsPending`;
  A's dashboard path calls `SCPAppIconsCarScreenOK()` (0xc570) once the
  car screen is healthy, which disarms it. If a run starts with pending
  still armed, the previous run died mid-injection →
  `splitScreenIconsCrashed = "1.0.3"` is written and injection stays off
  until the chosen list changes (`SCPAppIconsRetry`, 0xb044, clears the
  flag; called by the debounced refresh when the set changes).
- Refresh: `SCPRefreshAppIconsSoon()` (0xaa10, called from A's
  prefschanged block 0x54bc) debounces 0.8 s with a counter token; on a
  real change it removes proxies for un-chosen apps from the library,
  re-adds, and 1 s later posts the global block at 0x78980 (invoke
  0xb0e8) that calls `-[homeVC _handleAppLibraryRefresh]`.

### 3.2 Grid customization

- Settings dict (sub_4b640): exactly 8 keys — `on`, `size` (60–130,
  def 100), `cols` (def 0, clamp 0–8, whitelist {0,3,4,5,6,7,8}),
  `rows` (def 0, clamp 0–4, whitelist {0,1,2,3,4}), `names` (def YES),
  `style` (def 7, 1–8, forced 0 unless wallpaper pref on), `blur`
  (0–30, def 0), `dim` (0–70, def 25). Clamp helper sub_4d99c. Cached
  (0x881d8); rebuilt by `SCPHomeRefresh` (0x4b598).
- `iconImageInfo` hook (0x5104): scales size + corner radius by
  `size/100` when it differs from 1 by > 0.001 (ε decoded from
  0x6eff0); the `scale` field is *not* scaled.
- Column/row hooks (0x51a0/0x51d8/0x5210/0x5248) → helper sub_55f4:
  returns the configured override when sane (re-queries the
  configuration under a re-entrancy guard; requires cols ≥ 2, rows > 1);
  logs each change once per unique key.
- Label hooks: `-[SBIconView setLabelHidden:]` (0x5280) forces hidden
  when names are off; `+maxLabelSizeForIconImageSize:` (0x5438, on
  CARIconView else DBIconView) returns `CGSizeZero` when names are off.
- `isIconVisible:` hook (0x5338): NO if `SCPIconHiddenOnCar(icon)`;
  otherwise the original result, upgraded to YES when
  `SCPIconForcedOnCar(icon)`. Exceptions are logged via
  `SCPLogException("isIconVisible", e)` and the flow continues/falls
  back (two nested try regions).
- Visibility predicates (0xb5ec/0xbb20): bundle id via
  `applicationBundleID`/`leafIdentifier` (sub_b82c); hidden/shown sets
  from prefs `homeScreenHiddenApps`/`homeScreenShownApps` (cached,
  sub_b78c/sub_bc44, lock sub_c338). Protections: the constant list
  {com.apple.mobilephone, com.apple.Music, com.apple.Maps,
  com.apple.MobileSMS, com.apple.InCallService}, prefix
  `com.apple.CarPlay`, substring `NowPlaying`, OmniCar-injected apps,
  and (for hiding) the app must be installed (cached LSApplicationProxy
  state check, sub_b310). A "shown" entry loses to a "hidden" entry.
  Changes are applied by `SCPRefreshHiddenAppsSoon` (0xc008, 0.8 s
  debounce) → `SCPHomeIconModelLayout(reason)` (0xbce4: `[iconModel
  layout]`, falling back to `_handleAppLibraryRefresh`).

### 3.3 Apply pass + Settings sync

- `SCPHomeApply(homeVC)` (0x4a6d8), called from A's home-VC lifecycle
  hooks: stores a *second* weak home-VC global (0x881e0); manages B's
  `SCPHomeWallView` (tag 0x4857) — wallpaper file
  `<jbroot>/var/mobile/Library/OmniCar/HomeScreen/wallpaper.jpg`, or
  `video.mp4` for style 8, with a 30 s repeating timer (block sub_4bd7c)
  re-applying while style stays 8; calls `[wall applySettings:settings
  source:@{path, video}]` (B's method). On disable it logs, stops the
  video and removes the view. Then: icon-size changes re-layout every
  *IconListView* (sub_4b1d0: recursive setNeedsLayout + `layoutIconsNow`);
  grid-key changes (`"%ldx%ld"`) trigger `SCPHomeIconModelLayout`;
  label-visibility changes walk *IconView*s (sub_4c16c). A one-shot
  diagnostic view-tree dump (sub_4b0e0/sub_4bae8) fires on the first
  apply that changes anything.
- Delayed sync (block invoke sub_4c438, scheduled 1 s after every apply
  with a generation counter at 0x881f8): walks the live icon model,
  builds `@{id, name}` entries, preserves the previous
  `homeScreenCarApps` ordering, sorts new entries by name, and writes
  the pref back — this is the list the Prefs module presents. Log:
  `HomeScreen: %lu app tren man chinh cho Cai dat: %@`.

### 3.4 Picker builders (used by A and B)

- `SCPCarPlayAppInfos()` (sub_21d4c = A's placeholder of the same name):
  library `allInstalledApplications` filtered by A's
  `SCPAppHasCarPlayUI` (sub_ffb4), plus a merge of the live-grid reader;
  `{id, name}` sorted by name.
- `SCPChosenPhoneAppInfos()` (sub_22210): feature-gated; chosen ∩
  installed via `SCPBridgedChosenApps()`; names from the proxies'
  `localizedName`/`displayName`.
- `SCPBridgedChosenApps()` (sub_48864 = A's placeholder): pref set
  intersected with `LSApplicationWorkspace allInstalledApplications`,
  cached 60 s (timestamp 0x881c0); a `prefschanged` Darwin notification
  handler (sub_48cb0, registered once by sub_48c8c) resets the
  timestamp.

## 4. The uncalled cluster (honest finding)

`_SCPCarAppIcon` (0xdeac), `_SCPCarAppName` (0xe0c0), `_SCPCarLaunchApp`
(0xe410) and `_SCPHomeAppRemovable` (0xb1f8) have **no caller anywhere**:
checked the direct-branch call graph of *both* slices (arm64 + arm64e),
adrp+add materialization, GOT/data-slot pointers, block literals, and
the undefined-symbol sets of the other seven binaries. They are
reconstructed and dumped like everything else, but in this build they
are dead code — apparently an earlier design in which SplitScreen
itself read/launched home apps, superseded by (a) declaration injection
(the icons become real stock icons; taps take the stock launch path
through A's `+launchInfoForApplication:` hooks) and (b) sub_4c438's
model walk (which replaced `_SCPCarHomeBundles`' view-tree walk for
the Settings sync; `_SCPCarHomeBundles` itself survives with exactly
one caller, sub_21d4c).

Launch routing, for the record: **an injected icon's tap does not use
`appbridge.open`.** It launches through the dashboard's own machinery;
A's launch-info hooks detect the injected app (via
`SCPIsInjectedPhoneApp`) and hand it to SCPCarSplit's open pipeline.
The uncalled `SCPCarLaunchApp` shows the fallback the author kept:
`-[SCPCarSplit launchPhoneAppIfNeeded:]` first, then
`-[DBDashboard _launchAppWithInfo:forURL:]` with an info built by A's
sub_e324 and a dashboard obtained from
`[UIApplication sharedApplication _currentDashboard]` (sub_e5b4).

## 5. Boundaries vs A and B (explicit)

**Owned by A, called by this family (extern, not duplicated):**
`SCPAppInfoForBundle` (sub_e324), `SCPAppHasCarPlayUI` (sub_ffb4).
**A-covered entry points that call INTO this family:** hooks 0x4af0
(begin-injection, chosen apps, add-to-library, log-exception),
0x4bcc (inject declaration), 0x4c70 (set home VC), 0x4cb4/0x4d24/0x4d90
(`SCPHomeApply`, `SCPHomeSetVisible`), 0x4dfc/0x4f30
(`SCPIsInjectedPhoneApp`), prefschanged block 0x54bc
(`SCPRefreshAppIconsSoon`, `SCPRefreshHiddenAppsSoon`, `SCPHomeRefresh`,
`SCPLogException`).
**Reconciliations with A's placeholders:** A's extern
`SCPBridgedChosenApps` = sub_48864 ✓ (owned here); `SCPCarPlayAppInfos`
= sub_21d4c ✓ (owned here); `SCPChosenPhoneAppCount` = sub_22210 —
**the name is wrong**: the body returns the sorted `[{id, name}]`
array, not a count (callers presumably take `.count`); renamed
`SCPChosenPhoneAppInfos` here and flagged for the coordinator.
`SCPRealBundleForInfos` = sub_d950 ✓ owned here, called from 9 sites in
A/B territory. A's guess that sub_5520 was "SCPHomeKick" is wrong: the
body is the shared exception logger `SCPLogException` (owned here; A
calls it). A referenced an extern `OMCPrefSet` (Core) for SCPPrefs;
sub_c4f4 is a SplitScreen-local function with byte-equivalent
semantics — likely the same source helper compiled into this dylib;
flagged, not merged.
**Owned by B, only messaged here:** `SCPHomeWallView` (+ its
`applySettings:source:`, `stopVideo`, `updatePlayback` methods),
`SCPCarSplit` (`shared`, `launchPhoneAppIfNeeded:`), the layout state
behind the grid hooks. B's source/disasm contain no implementation of
any family function (checked: only a comment mention in B's
SCPCommon.h). The picker builders above are called *by* B's
`-[SCPCarSplit buildPickerSheetForPane:]` (0x334cc) but owned here per
A's §1 flag.
**Shared infra (not owned):** `_SCPMissingSelector` (0x4f330), the OMC
core (`_OMCPref` 0x4f544, `_OMCPrefsSync` 0x4f538, `_OMCEnabled`
0x4f5ac, `_OMCFeatureEnabled` 0x4f608, `_OMCLogWrite` 0x4fbf4).
**OMCPerfTicker adjudication (asked for explicitly):** the creation
site at 0x546f8 lies inside **sub_54448** (0x54448–0x548a0), a lite-mode
telemetry function (reads pref `liteMode`; builds a stats dictionary
with keys `frames`/`hangs`/`heat` in domain `com.anlai.omnicar`). Its
only referrer is sub_53f90, and neither function calls, or is called
by, anything in this family (direct-branch graph) — they merely sit at
addresses adjacent to the `isIconVisible:` hook. **Not this family**;
left to the OMC/Core agent per A's assignment. Their disassembly was
kept out of `src/SplitScreenC/disasm/` (scratch copies in
`work-C/adjud/`).

## 6. Unresolved items (no silent stubs)

1. **sub_d324 (SCPDiagWalkIcons) — NOT-RECOVERED body.** A recursive
   DIAG tree walker; only its send/string profile was recovered. The
   source carries an explicit `// STUB-UNRECOVERED` marker (the only
   one in this module). It is diagnostic-only.
2. **Function pointer at slot 0x87f60 — RESOLVED (verifier #5).**
   The slot is not an installed function pointer at all: it lies in
   `__DATA,__thread_vars` and is a thread-local variable descriptor
   whose first word binds to `__tlv_bootstrap` (raw bind
   0x8000000000000124, import ordinal 0x124). sub_55f4's call through
   it (@0x5624–0x5634 — load first word, `blr`, then `ldrb`/`strb` on
   the result) is the standard `__thread` access sequence and returns
   a pointer to the per-thread re-entrancy byte (a `__thread BOOL`
   guard), which the helper tests and sets around its re-query of
   `_SCPHomeGridColumns` / `_SCPHomeGridRows`. Nobody installs the
   pointer; dyld's TLV machinery owns it. The original
   "identity NOT-RECOVERED" framing was over-cautious — the mechanism
   description ("calls it to obtain a pointer to its re-entrancy
   byte") was already correct. See the verifier-#5 fix addendum.
3. **sub_cde0 description truncation limit — RESOLVED (verifier #5).**
   The limit is a plain immediate: @0xce50–0xce5c, `cmp x0, #0x5dd;
   b.lo …; mov w2, #0x5dc; substringToIndex:` — descriptions longer
   than 1500 chars are truncated to **1500 (0x5dc)** before the
   `DIAG %@ description: %@` log. The truncation is now implemented in
   `SCPDiagDescribe` (it was previously only a NOTE comment, so the
   body's VERIFIED label overstated it). See the verifier-#5 fix
   addendum.
4. **sub_48da0 ownership — INFERRED.** Body VERIFIED (UIColor white for
   `userInterfaceStyle == 2`, else black). No resolvable reference to
   its block literal exists in either slice; most likely a dynamic
   color-provider block belonging to B's picker sheet UI. Flagged for
   coordinator reconciliation; dumped here so the body is not lost.
5. **Block helpers 0x487e4/0x48824 — pairing INFERRED.** Compiler
   copy/dispose helpers (retain/release of five captured objects) for
   a block in the builder cluster; the descriptor uses auth-signed
   pointers the annotator could not fully resolve, so the exact invoke
   they serve is unconfirmed. Bodies VERIFIED (pure retain/release).
6. **INFERRED glue** (structure and call sequence VERIFIED; minor
   connective detail reconstructed): sub_21d4c name resolution for
   grid-only entries, sub_22210 enumeration glue, sub_4c438 merge
   ordering, sub_db30 cache/log tail, sub_dec8 icon fetch path,
   sub_46198/0x46584/0x44b5c walker glue, sub_cfa4 formatter line
   composition. Each is marked INFERRED at its source site.

## 7. Function table (98)

Status key: **V** = VERIFIED (body read instruction-by-instruction),
**I** = INFERRED (structure/call-sequence verified, glue inferred),
**N** = NOT-RECOVERED. Source file abbreviations: AI = SCPAppIcons.m,
HK = SCPHomeHooks.m, VS = SCPHomeVisibility.m, ST = SCPHomeSettings.m,
AP = SCPHomeApply.m, CA = SCPCarApps.m, LR = SCPLibRoot.m, DG =
SCPDiagDump.m, HD = SCPHomeCommon.h.

| Addr | Function | Src | Status |
|---|---|---|---|
| 0x4118 | SCPJBRootPath trampoline | LR | V |
| 0x4170 | libroot bootstrap (once body) | LR | V |
| 0x42ac | fallback get_root_prefix → "" | LR | V |
| 0x42b8 | fallback get_jbroot_prefix → "/var/jb" | LR | V |
| 0x42c4 | fallback get_boot_uuid → zero UUID | LR | V |
| 0x42d0 | fallback jbrootpath | LR | V |
| 0x4384 | fallback rootfspath | LR | V |
| 0x5104 | hook iconImageInfo | HK | V |
| 0x51a0 | hook numberOfPortraitColumns | HK | V |
| 0x51d8 | hook numberOfPortraitRows | HK | V |
| 0x5210 | hook numberOfLandscapeColumns | HK | V |
| 0x5248 | hook numberOfLandscapeRows | HK | V |
| 0x5280 | hook SBIconView setLabelHidden: | HK | V |
| 0x5338 | hook iconModel isIconVisible: | HK | V |
| 0x5438 | hook +maxLabelSizeForIconImageSize: | HK | V |
| 0x5520 | SCPLogException | HK | V |
| 0x55f4 | SCPGridDimension helper | HK | V (see §6.2) |
| 0x9980 | _SCPIsInjectedPhoneApp | AI | V |
| 0x9a1c | injected-set accessor | AI | V |
| 0x9a60 | _SCPChosenPhoneApps | AI | V |
| 0x9b34 | _SCPInjectDeclarationIfChosen | AI | V |
| 0xa26c | SCPHomeSafeGet | AI | V |
| 0xa32c | SCPHomeSafeKVCGet | AI | V |
| 0xa3c4 | SCPHomeSafeSet | AI | V |
| 0xa500 | _SCPAddChosenAppsToLibrary | AI | V |
| 0xa860 | SCPValidProxyForBundle | AI | V |
| 0xaa00 | _SCPSetHomeViewController | AI | V |
| 0xaa10 | _SCPRefreshAppIconsSoon | AI | V |
| 0xaa90 | refresh block invoke | AI | V |
| 0xb044 | _SCPAppIconsRetry | AI | V |
| 0xb0e8 | library-refresh block invoke (0x78980) | AI | V |
| 0xb1f8 | _SCPHomeAppRemovable — uncalled | VS | V |
| 0xb310 | SCPAppIsInstalled (cached) | VS | V |
| 0xb5ec | _SCPIconHiddenOnCar | VS | V |
| 0xb78c | hidden-set cached getter | VS | V |
| 0xb82c | SCPIconBundleID | VS | V |
| 0xb9ac | SCPHomeLogOnce | VS | V |
| 0xbb20 | _SCPIconForcedOnCar | VS | V |
| 0xbc44 | shown-set cached getter | VS | V |
| 0xbce4 | _SCPHomeIconModelLayout | VS | V |
| 0xc008 | _SCPRefreshHiddenAppsSoon | VS | V |
| 0xc088 | hidden-refresh block invoke | VS | V |
| 0xc268 | SCPPrefBundleSet | VS | V |
| 0xc338 | visibility lock getter | VS | V |
| 0xc37c | _SCPAppIconsBeginInjection | AI | V |
| 0xc4f4 | SCPHomePrefSet | AI | V |
| 0xc570 | _SCPAppIconsCarScreenOK | AI | V |
| 0xc624 | _SCPDumpAppLibraryOnce | DG | V |
| 0xcde0 | SCPDiagDescribe | DG | V (see §6.3) |
| 0xcfa4 | SCPDiagDumpClass | DG | I |
| 0xd324 | SCPDiagWalkIcons | DG | N |
| 0xd68c | once-block: create injected set | AI | V |
| 0xd6c0 | once-block: create visibility lock | VS | V |
| 0xd6ec | SCPDiagIvarList | DG | I |
| 0xd830 | SCPDiagMethodList | DG | I |
| 0xd950 | _SCPRealBundleForInfos | CA | V |
| 0xdb2c | _SCPCarHomeBundles (entry) | CA | V |
| 0xdb30 | SCPCarHomeBundles body | CA | I (tail) |
| 0xdeac | _SCPCarAppIcon — uncalled | CA | V |
| 0xdec8 | SCPDiagIconForBundle | CA | I |
| 0xe0c0 | _SCPCarAppName — uncalled | CA | V |
| 0xe410 | _SCPCarLaunchApp — uncalled | CA | V |
| 0xe5b4 | SCPCurrentDashboard | CA | V |
| 0x21d4c | SCPCarPlayAppInfos | CA | I |
| 0x22210 | SCPChosenPhoneAppInfos | CA | I |
| 0x44a54 | SCPWalkerSafeGet | CA | V |
| 0x44b5c | SCPWalkerIconBundleID | CA | I |
| 0x46198 | SCPWalkerWalkView | CA | I |
| 0x46584 | SCPWalkerCollectIcons | CA | I |
| 0x4672c | SCPSharedApplicationLibrary | CA | V |
| 0x487e4 | block copy helper (5 captures) | CA | V body / I pairing |
| 0x48824 | block dispose helper | CA | V body / I pairing |
| 0x48864 | SCPBridgedChosenApps | CA | V |
| 0x48c8c | once body: register invalidation | CA | V |
| 0x48cb0 | prefschanged block invoke | CA | V |
| 0x48da0 | dynamic label color block invoke | CA | V body / I owner |
| 0x48e24 | _SCPHomeIconScale | ST | V |
| 0x48ef8 | SCPHomeSettings (cached accessor) | ST | V |
| 0x48f48 | _SCPHomeGridColumns | ST | V |
| 0x49014 | _SCPHomeGridRows | ST | V |
| 0x490e0 | _SCPHomeShowNames | ST | V |
| 0x4a6d8 | _SCPHomeApply | AP | V |
| 0x4b0e0 | SCPDiagHomeTreeOnce | AP | V |
| 0x4b1d0 | SCPReLayoutIconLists | AP | V |
| 0x4b4bc | _SCPHomeSetVisible | ST | V |
| 0x4b598 | _SCPHomeRefresh | ST | V |
| 0x4b640 | SCPBuildHomeSettings | ST | V |
| 0x4bae8 | SCPDumpViewTree | AP | V |
| 0x4bd7c | video timer block invoke | ST | V |
| 0x4be40 | SCPCollectIconListViews | AP | V |
| 0x4c00c | SCPSetNeedsLayoutRecursive | AP | V |
| 0x4c16c | SCPApplyLabelHidden | AP | V |
| 0x4c438 | SCPPublishCarAppsBlock | AP | I |
| 0x4d8dc | SCPHomeSafePerform | AI | V |
| 0x4d99c | SCPClampedPrefInt | ST | V |
| 0x56068 | dispatch_once trampoline (injected set) | AI | V |
| 0x5607c | dispatch_once trampoline (lock) | VS | V |
| 0x560a4 | dispatch_once trampoline (bridged cache) | CA | V |

Counts: 98 functions — 83 VERIFIED outright, 14 with an INFERRED
aspect (glue/ownership/tail), 1 NOT-RECOVERED body (sub_d324,
diagnostic-only), plus 2 NOT-RECOVERED data points (§6.2, §6.3) inside
otherwise-VERIFIED functions. The only stub in the source is sub_d324,
explicitly marked `// STUB-UNRECOVERED` at its site. The three
dispatch_once trampolines are compiler thunks; in source they appear
as the `dispatch_once` calls at their use sites.

---

## Verifier-#5 fix addendum

Applied after independent verification #5 (`VERIFY_SplitScreenC.md`,
counts: wrong 1, downgraded 2, undeclared stubs 0). Each item was
checked against the verifier's evidence — and spot-checked against
this module's calibrated disassembly dumps — before editing; no
contradiction with the verifier was found on any item.

1. **`tags` reads in `SCPInjectDeclarationIfChosen` (was WRONG) —
   fixed in `SCPAppIcons.m`.** The source read the already-ours tag
   list as `SCPHomeSafeGet(decl, @"tags")` and the pre-prepend list as
   `SCPHomeSafeKVCGet(info, @"_tags")`. The binary does neither: at
   **0x9bc0–0x9bcc** and again at **0x9e54–0x9e60** it calls
   **sub_a26c (`SCPHomeSafeGet`) on info (x19) with the cfstring
   `@"tags"`** (dump: `x1 = 0x7a3e0 @"tags"; x0 = x19; bl #0xa26c` at
   both sites). Both reads are now `SCPHomeSafeGet(info, @"tags")`,
   with evidence comments at the sites. The `_tags` KVC **write**
   (sub_a3c4 @0x9eb0) was correct and is unchanged. Behavioural delta
   of the old error was small (repeat-load refusal path), but the
   function is labelled VERIFIED and the reads were misattributed.

2. **sub_cde0 truncation (was a missing operation) — implemented in
   `SCPDiagDump.m`.** The binary truncates the description before
   logging: **@0xce50 `cmp x0, #0x5dd`; `b.lo` skip; @0xce5c
   `mov w2, #0x5dc`; `substringToIndex:`** — descriptions longer than
   1500 chars are cut to **1500 (0x5dc)**. `SCPDiagDescribe` now
   contains `if (desc.length > 1500) desc = [desc
   substringToIndex:1500];` in place of the old NOTE comment, so its
   VERIFIED label is now accurate. §6 item 3 updated to RESOLVED.

3. **Data gap §6.2 (slot 0x87f60) — CLOSED.** The slot lies in
   `__DATA,__thread_vars` and is a **thread-local variable
   descriptor** whose first word binds to **`__tlv_bootstrap`**
   (raw 0x8000000000000124, import ordinal 0x124). sub_55f4
   (@0x5624–0x5634: load first word, `blr` with the descriptor
   address, `ldrb`/`strb` on the result) performs the standard
   `__thread` access sequence and obtains a pointer to the
   per-thread re-entrancy byte — a `__thread BOOL` guard, owned by
   dyld's TLV machinery, not installed by anyone. §6 item 2 updated
   to RESOLVED and the annotation above `SCPGridDimension` in
   `SCPHomeHooks.m` rewritten to the `__thread` explanation (the
   body already modelled exactly this call shape and is unchanged).

**Effect on the closing counts above:** the "2 NOT-RECOVERED data
points (§6.2, §6.3) inside otherwise-VERIFIED functions" are both
resolved by this addendum. The module's only remaining NOT-RECOVERED
item is the sub_d324 body (§6 item 1); §6 items 4–6 (INFERRED) are
unchanged. `project/` was not touched — the integration agent
re-syncs from `src/`.
