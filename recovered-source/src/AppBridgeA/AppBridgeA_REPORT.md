# OmniCarAppBridge.dylib — Module Report A (catalog / picker / launch)

Binary: `OmniCarAppBridge.dylib`, arm64 slice, UUID `81EF5920-BB7A-37E8-B953-D88453F2EA89`,
613,376 B fat; filter `com.apple.UIKit` (loads into every UIKit process).
Evidence: annotated capstone disassembly of all 383 LC_FUNCTION_STARTS functions
+ 31 global-block invokes + 3 constructors in `disasm/` (419 files +
`summary.json` / `blocks_summary.json`), produced with `tools/abdis.py`,
`tools/dumpall.py`, `tools/dumpblocks.py`, `tools/show.py`.
Source reconstruction: `src/OMCCore.{h,m}`, `src/ABHost.h`,
`src/ABHostLaunch.m`, `src/ABChannels.m`.

---

## 0. Headline answers (the three questions this half was assigned)

1. **There are NO dashboard-library / catalog hooks and NO picker UI in
   OmniCarAppBridge.dylib.** Proven by exhaustive inventory: 8 classes (none
   is a picker or library class), all 3 constructors read end-to-end, every
   `MSHookMessageEx`/`MSHookFunction` call site enumerated (5 in SpringBoard
   ctor, 14 in the app-process ctor, 0 elsewhere). Nothing references
   `_newApplicationLibrary`, an application-library class, icon/badge
   classes, or any `DBApplication*`/`CARApplication*` method besides the
   launch-info factory below. The app picker and the chosen-apps list live
   in a **different module** (the car-side controller that *posts*
   `appbridge.open`); AppBridge is the host endpoint only.
2. **Eligibility to be hosted is decided in exactly one place:**
   `-[ABHost openApp:frame:]` (0xb8a0) refuses when (a) the bundle id is
   empty, (b) `OMCFeatureEnabled(@"appBridge")` is false → log
   `tat trong Cai dat -> khong host %@`, or (c) `ensureWindow` fails because
   there is no CarPlay display → log `xe chua ket noi -> khong host %@`.
   There is **no chosen-apps check, no entitlement check, and no
   bundle-property check in the host**: any bundle id the controller sends
   in `appbridge.open` is hosted. Feedback goes back as
   `appbridge.state {identifier, state: "failed"|"ready"}`.
3. **The metadata candidate key `appBridgeApps` does not exist** — the
   string appears nowhere in the binary (checked against the full string
   table). The user's chosen-apps list is therefore **not stored by, nor
   read by, AppBridge at all**. The prefs AppBridge actually reads are
   proven in §3.

Launch path (end to end): car-side controller posts distributed
notification `appbridge.open` → SpringBoard handler (registered by the
`SpringBoard -applicationDidFinishLaunching:` hook) →
`-[ABHost openApp:frame:]` → pane + `ABBoxView` created →
`setupLiveAppViewForPane:` (B) resolves the `SBApplication` via
`SBApplicationController sharedInstance applicationWithBundleIdentifier:`,
builds a scene through `SBSceneManagerCoordinator → mainDisplaySceneManager
→ layoutStateManager → sceneIdentityForApplication:… →
SBApplicationSceneHandleRequest → fetchOrCreateApplicationSceneHandle… →
SBAppViewController → SBApplicationSceneUpdateTransaction
(_processLaunchTransaction)`. Separately, the shared core exports
`OMCCarLaunchInfo()` which builds a `DBApplicationLaunchInfo` via
`launchInfoForApplication:` / `launchInfoForApplication:withActivationSettings:`
on the class resolved by `OMCCarClass("DBApplicationLaunchInfo")` — the
DashBoard-side launch-request object; it has **no caller inside this
dylib** (it is part of the core copy linked into every module; the caller
is expected in the sibling module that owns the picker).

---

## 1. Partition (from objc.json: 8 classes / 193 methods)

**Agent A (this report)** — everything catalog/launch/channel/prefs-facing:

| Area | Items |
|---|---|
| Constructors | `__mod_init_0` 0x44a8 (registration head only; handlers → B), `__mod_init_1` 0x6e08 (SpringBoard hooks), `__mod_init_2` 0x20184 (host-process diag) |
| Shared core (C) | `_OMCPref` 0x1d680, `_OMCPrefsSync` 0x1d674, `_OMCEnabled` 0x1d6e8, `_OMCFeatureEnabled` 0x1d744, `_OMCExpired` 0x2358c, `_OMCLiteActive` 0x1d7d4, `_OMCCarWireless` 0x1d930, `_OMCCarClass` 0x1e438, `_OMCHasMethod` 0x1e384, `_OMCCheckHooks` 0x1e580, `_OMCMissingSelector` 0x1ec70, `_ABMissingSelector` 0x9698, `_OMCCarLaunchInfo` 0x1ee50, `_OMCCrashGuard` unit 0x1ef60–0x205c8, `_OMCLogWrite` unit 0x1d9cc, `_OMCTr`/`_OMCCurrentLanguage`/`_OMCProfileKeys` (0x22f60 unit, mapped), car-profile unit 0x213ac–0x21930 (mapped), lite/perf units 0x21f7c–0x22e50 (mapped) |
| ABHost [A methods] | `+shared` 0xa9e8, `count` 0xaaa0, `hostsApp:` 0xaaf0, `paneFor:` 0xac84, `zoom` 0xae20, `openApp:frame:` 0xb8a0, `bundleForHash:` 0xf40c, `frameOfApp:` 0xf5ec, `appWithHash:changedOrientation:supportedMask:` 0xf6b0, `postBarAction:from:` 0x13148, `barReplace:` 0x13378, `barPop:` 0x13388, `barFull:` 0x13398, `barBackground:` 0x133a8, `barClose:` 0x133b8, `closeApp:terminate:` 0x15ca0, `closeAll` 0x160ec, `closeAllExcept:` 0x160f4, `carDisconnected` 0x163e8, helper `ABPostAppState` (sub_bed4) 0xbed4, FNV-1a hash inlined at 0xf40c/0xf6b0 |
| Channel handlers | distributed blocks: open 0x783c, frame 0x8274, shield 0x8c7c, close 0x8df0, closeall 0x8fd4, knobs 0x9144; Darwin blocks: apporient 0x92b4, keyboard 0x93b0; local block: CarPlayIsConnectedDidChange 0x958c |
| SpringBoard hook replacements | `applicationDidFinishLaunching:` repl 0x7004, `SBSuspendedUnderLockManager` repl 0x72bc, `FBScene updateSettings:` repl 0x74b4, `SBSceneView` trampoline 0x7764, `BKSDisplayServicesSetScreenBlanked` repl 0x777c |
| Handle menu (data) | menu titles via `_OMCTr(hm_*)` in `buildBarForPane:` region (sub_102bc); glyph path builders 0x16ce4/0x16e08/0x16f78 mapped (drawing code → B) |

**Agent B (not covered here, except where A calls them)** — ABPane (all
35 methods), ABBoxView (12), ABShieldView (1), ABKnobView (12),
ABBarButton (2), ABKeyboard (48 + `+shared`), ABKey (20), `_ABTelexApply`;
ABHost hosting internals: `ensureWindow` 0xaea8 (+ helper sub_b004),
`dropWindowIfEmpty`, `setupLiveAppViewForPane:` 0xc2bc, `layoutPane:`,
`revealPane:`, `sceneMonitor:sceneWasDestroyed:`, `effectiveOrientation:`,
`carWindow`, `buildBarForPane:`/`layoutBarForPane:`/`hideBarForPane:`,
`setFrame:forApp:live:handle:passInsets:` and the other command appliers'
bodies (`setPassInsets:`, `setCornerRadius:`, `setBarVisible:…`,
`setHole:`, `setShieldAll:`/`setShield:forPane:`, `setHandleOffset:`,
`setFront:`, `setKnobs:`, `setHandleVisible:`, `setupHandleForPane:`,
`handlePanned:`/`handleTapped:`, `raiseKnobs`, `outsideTouched`,
`paneOfBarButton:`, `nudgePane:`, `teardownPane:`, and the
app-process hook replacements registered by ctor 0x44a8 (CADisplayLink /
UIWindow / UIDevice / UITextField / UITextView / UIWindowScene /
UIViewController orientation & keyboard hooks) plus the `appbridge.orientation`
and `appbridge.key` handler blocks (0x4728, 0x5908).
<!-- RESTORED 2026-11-08 (remediation): the original continuation
of §1 was lost to a truncation marker (~20,887 chars) in the first
publication of this report. The segment below was re-derived from
src/AppBridgeB/AppBridgeB_REPORT.md (§§1–2, 8–10), the B sources
in src/AppBridgeB/, and the calibrated method inventory in
metadata/raw/OmniCarAppBridge/objc.json (arm64 slice). It
reconstructs the lost B-side inventory material; it is not the
original wording. The sentence above was split by the damage as
"`teardown" + "Pane:`" and is rejoined as `teardownPane:`
(@0x155b0, present in the class list below). -->

### 1.1 B-side inventory (restored)

For completeness, the full B scope as enumerated by B's own
report (§1) and the binary's class lists. B owns: everything that
happens inside a hosted app process (the in-app machinery of
ctor 0x44a8), plus the host-side geometry/orientation/lifecycle
machinery that serves it. The SpringBoard-side endpoints of the
in-app channels also sit with B: registrar `sub_7004`, the Darwin
consumers `sub_92B4` (apporient) and `sub_93B0` (keyboard), the
frame/shield consumer blocks, and the C helpers `sub_E6B8`
(orientation post) and `sub_BED4` (state post, = `ABPostAppState`
in A's table above). Ctor 0x44a8 bails unless the bundle id is
non-empty, the bundle path contains `.app`, and the bundle id is
outside the exclusion array @0x393D8 (verbatim:
`com.apple.springboard, com.apple.CarPlayApp,
com.apple.CarPlayTemplateUIHost, com.apple.CarPlaySettings,
com.apple.InCallService, com.apple.Preferences`); it registers
the `appbridge.orientation` (block 0x4728) and `appbridge.key`
(block 0x5908) observers with object = own bundle id. Block
0x4728 lazily installs the 13 in-app hooks (§5); the two Darwin
publishers are debounced at 0.25 s (`sub_6750`).

Per-class method inventory (names + IMPs from `objc.json`;
193 methods total — 191 instance + `+shared` on ABHost and
ABKeyboard):

**ABBoxView** (12): `pointInside:withEvent:` @0x98a0, `setHole:` @0x9b2c, `applyHole` @0x9c10, `layoutSubviews` @0x9e50, `passInsets` @0x9ea8, `setPassInsets:` @0x9ec0, `handleHit` @0x9ed8, `setHandleHit:` @0x9ef8, `bar` @0x9f0c, `setBar:` @0x9f2c, `hole` @0x9f40, `.cxx_destruct` @0x9f58.

**ABBarButton** (2): `pointInside:withEvent:` @0x9f90, `setHighlighted:` @0xa02c.

**ABPane** (35): `bundleID` @0xa180, `setBundleID:` @0xa188, `box` @0xa190, `setBox:` @0xa198, `application` @0xa1c8, `setApplication:` @0xa1d0, `appViewController` @0xa200, `setAppViewController:` @0xa208, `sceneMonitor` @0xa238, `setSceneMonitor:` @0xa240, `orientation` @0xa270, `setOrientation:` @0xa278, `requestedOrientation` @0xa280, `setRequestedOrientation:` @0xa288, `frame` @0xa290, `setFrame:` @0xa29c, `sceneBox` @0xa2a8, `setSceneBox:` @0xa2b0, `ready` @0xa2b8, `setReady:` @0xa2c0, `handle` @0xa2c8, `setHandle:` @0xa2d0, `handleHit` @0xa300, `setHandleHit:` @0xa308, `bar` @0xa338, `setBar:` @0xa340, `popButton` @0xa370, `setPopButton:` @0xa378, `soloButton` @0xa3a8, `setSoloButton:` @0xa3b0, `handleOffset` @0xa3e0, `setHandleOffset:` @0xa3e8, `shield` @0xa3f0, `setShield:` @0xa3f8, `.cxx_destruct` @0xa428.

**ABShieldView** (1): `touchesBegan:withEvent:` @0xa4c4.

**ABKnobView** (12): `relay:touches:` @0xa58c, `touchesBegan:withEvent:` @0xa90c, `touchesMoved:withEvent:` @0xa918, `touchesEnded:withEvent:` @0xa924, `touchesCancelled:withEvent:` @0xa930, `index` @0xa93c, `setIndex:` @0xa94c, `lastSent` @0xa95c, `setLastSent:` @0xa970, `dot` @0xa984, `setDot:` @0xa994, `.cxx_destruct` @0xa9d4.

**ABHost** (62): `count` @0xaaa0, `hostsApp:` @0xaaf0, `paneFor:` @0xac84, `zoom` @0xae20, `ensureWindow` @0xaea8, `dropWindowIfEmpty` @0xb89c, `openApp:frame:` @0xb8a0, `revealPane:` @0xc178, `setupLiveAppViewForPane:` @0xc2bc, `sceneMonitor:sceneWasDestroyed:` @0xe9e8, `layoutPane:` @0xec80, `effectiveOrientation:` @0xf364, `carWindow` @0xf3d0, `bundleForHash:` @0xf40c, `frameOfApp:` @0xf5ec, `appWithHash:changedOrientation:supportedMask:` @0xf6b0, `nudgePane:` @0xf9ac, `setFrame:forApp:live:handle:passInsets:` @0xfe68, `setPassInsets:forApp:` @0x1038c, `setCornerRadius:corners:forApp:` @0x10438, `buildBarForPane:` @0x105b8, `layoutBarForPane:` @0x11690, `setBarVisible:pop:dim:single:forApp:` @0x11868, `hideBarForPane:` @0x12610, `setShieldAll:` @0x128a4, `setShield:forPane:` @0x129d8, `setHole:forApp:` @0x12ce4, `outsideTouched` @0x12e08, `paneOfBarButton:` @0x12f78, `postBarAction:from:` @0x13148, `barReplace:` @0x13378, `barPop:` @0x13388, `barFull:` @0x13398, `barBackground:` @0x133a8, `barClose:` @0x133b8, `setupHandleForPane:` @0x133c8, `setHandleVisible:forPane:` @0x137cc, `raiseKnobs` @0x13918, `setKnobs:` @0x13abc, `setHandleOffset:forApp:` @0x14c7c, `handlePanned:` @0x14d34, `setFront:forApp:` @0x151a8, `handleTapped:` @0x152d4, `teardownPane:` @0x155b0, `closeApp:terminate:` @0x15ca0, `closeAll` @0x160ec, `closeAllExcept:` @0x160f4, `carDisconnected` @0x163e8, `carAppArea` @0x166b4, `setCarAppArea:` @0x166c0, `window` @0x166cc, `setWindow:` @0x166d4, `shieldOn` @0x16704, `setShieldOn:` @0x1670c, `displayID` @0x16714, `setDisplayID:` @0x1671c, `panes` @0x16724, `setPanes:` @0x1672c, `knobViews` @0x1675c, `setKnobViews:` @0x16764, `.cxx_destruct` @0x16794, `+shared` @0xa9e8.

**ABKey** (20): `paint:` @0x181dc, `setHighlighted:` @0x187d4, `layoutSubviews` @0x189c8, `value` @0x18afc, `setValue:` @0x18b0c, `command` @0x18b18, `setCommand:` @0x18b28, `weight` @0x18b34, `setWeight:` @0x18b44, `lit` @0x18b54, `setLit:` @0x18b64, `restColor` @0x18b74, `setRestColor:` @0x18b84, `restTint` @0x18bc4, `setRestTint:` @0x18bd4, `hint` @0x18c14, `setHint:` @0x18c24, `accent` @0x18c64, `setAccent:` @0x18c74, `.cxx_destruct` @0x18cb4.

**ABKeyboard** (49): `showForApp:keyboardType:returnType:` @0x18db4, `hideForApp:` @0x1935c, `layoutPanelIn:` @0x196d0, `key:pressed:` @0x199cc, `buildPanel` @0x1a200, `key:symbol:value:command:weight:` @0x1abb0, `key:value:command:weight:` @0x1b408, `rebuildKeys` @0x1b430, `layoutKeys` @0x1bf5c, `updatePreview` @0x1c5c8, `langTapped` @0x1c7b8, `send:del:text:` @0x1c81c, `typeCharacter:` @0x1ca2c, `keyTapped:` @0x1cdd4, `hideTapped` @0x1d244, `app` @0x1d27c, `setApp:` @0x1d284, `panel` @0x1d28c, `setPanel:` @0x1d294, `glass` @0x1d2c4, `setGlass:` @0x1d2cc, `bubble` @0x1d2fc, `setBubble:` @0x1d304, `field` @0x1d334, `setField:` @0x1d33c, `preview` @0x1d36c, `setPreview:` @0x1d374, `langButton` @0x1d3a4, `setLangButton:` @0x1d3ac, `hideButton` @0x1d3dc, `setHideButton:` @0x1d3e4, `keysView` @0x1d414, `setKeysView:` @0x1d41c, `rows` @0x1d44c, `setRows:` @0x1d454, `numbers` @0x1d484, `setNumbers:` @0x1d48c, `shift` @0x1d494, `setShift:` @0x1d49c, `vietnamese` @0x1d4a4, `setVietnamese:` @0x1d4ac, `returnType` @0x1d4b4, `setReturnType:` @0x1d4bc, `word` @0x1d4c4, `setWord:` @0x1d4cc, `typed` @0x1d4fc, `setTyped:` @0x1d504, `.cxx_destruct` @0x1d534, `+shared` @0x18d44.



Attribution seam, recorded for the coordinator: this report's
§1 list assigns `ensureWindow`, `setupLiveAppViewForPane:`,
`teardownPane:` and `revealPane:` to B; REPORT_B §1 assigns the
same four to A. Integration resolved ownership by file, not by
report: `ABHostLaunch.m` (A) carries the launch/teardown
bodies, `ABHostBMethods.m` (B) the geometry/lifecycle set, and
the five overlap helpers B depends on (`shared`, `count`,
`hostsApp:`, `paneFor:`, `bundleForHash:`) were reconstructed
by both halves and deduped to single definitions in phase 3
(each ABHost selector has exactly one definition in the
canonical source; A defines 16 ABHost methods, B defines 33,
intersection ∅). Statuses for every B body are in REPORT_B §8;
the condensed areas are declared in REPORT_B §9.


---

## 2. Tooling correction that affects the whole project (please propagate)

The wave-1 parser `Slice.decode_ptr` (`metadata/tools/macho_objc.py`,
`_import_name`) resolves chained-fixup bind ordinals as `imports[ordinal-1]`.
For this binary (pointer format 6) that is **off by one**; the correct
resolution is `imports[ordinal]`. Proven by three independent semantic
anchors:

1. `__cfstring` isa slots carry ordinal 180 and must be
   `___CFConstantStringClassReference` = `imports[180]`.
2. Global-block isa slots carry ordinal 179 and must be
   `__NSConcreteGlobalBlock` = `imports[179]`.
3. Stub 0x242c0 is called by `_OMCPref` with two arguments
   (key, domain) = `CFPreferencesCopyAppValue` = `imports[181]` direct;
   the shifted label says `CFPreferencesAppSynchronize` (1 argument).

Consequences for the wave-1 metadata of this binary (and likely all
OmniCar binaries, same format): every bind-derived name is shifted —
GOT/stub targets, classrefs, and **superclasses**. Corrected superclasses:
ABBoxView : **UIView**, ABShieldView : **UIView**, ABKnobView : **UIView**,
ABBarButton : **UIButton**, ABKey : **UIButton**, ABPane : **NSObject**,
ABHost : **NSObject**, ABKeyboard : **NSObject** (metadata printed
UIWindowScene / NSNull / NSRunLoop). My harness (`tools/abdis.py`,
`decode2`) uses the corrected mapping; all 419 disassembly files were
regenerated with it. Also, with the corrected mapping, **both**
`_MSHookMessageEx` (stub 0x243ec) and `_MSHookFunction` (stub 0x243e0)
have ordinary call sites (in the constructors) — the earlier "no direct
callers" observation was an artifact of the shift.

---

## 3. Preferences — PROVEN domain and keys (xref, not string guessing)

Domain for every access: **`com.anlai.omnicar`**, via
`CFPreferencesCopyAppValue` / `CFPreferencesSetAppValue` /
`CFPreferencesAppSynchronize` (`_OMCPref` 0x1d680, `_OMCPrefsSync` 0x1d674,
verified at the instruction level). Feature gating:
`OMCEnabled()` = !expired && `enabled`; `OMCFeatureEnabled(name)` =
`OMCEnabled()` && pref `"<name>Enabled"`. So the AppBridge feature is
controlled by keys **`enabled`** + **`appBridgeEnabled`**.

Keys actually read/written by A-scope code (function → key):

| Key | Type seen | Where |
|---|---|---|
| `enabled` | bool (default NO) | `_OMCEnabled` |
| `appBridgeEnabled` (built as `appBridge`+`Enabled`) | bool | `_OMCFeatureEnabled` ← `openApp:frame:` |
| `appBridgeOrientation` | integer (default object at 0x395b8 = **@1**, decoded byte-exact rem4) | `openApp:frame:`; values 3,4 mapped to 0 |
| `appBridgeZoom` | percent → /100, clamp [0.6, 1.0] | `-[ABHost zoom]` |
| `appBridgeFps` | — | ctor-0x44a8 unit (B) |
| `appBridgeKeyboardLang` | — | ABKeyboard unit (B) / 0x1cdb4 |
| `liteMode` | integer | `_OMCLiteActive`, perf ticker |
| `trustedTime` | number | `_OMCExpired` (anti-rollback floor) |
| `diagLoaded.AppBridge@<proc>` | dict {version, build, date} — **written** | ctor 0x20184 block |
| `diagHooks.AppBridge` | dict {ios, total, missing[]} — **written** (key construction INFERRED) | `_OMCCheckHooks` |
| `diagCar` | dict — read by `_OMCCarWireless`, written by 0x214cc | car session watcher |
| `diagPerf` | dict — **written** | 0x22e50 |
| `carProfiles`, `carProfileCurrent` | — | profile unit 0x21930 (posts `prefschanged`) |
| `features`, `rescueFeatures`, `rescueDate` | dict / list / date | rescue unit 0x1f6b8+ (feature set computation) |
| `splitScreen*`, `speedBubble*`, `startupScreen*` strings | — | **not referenced by AppBridge A code** (other modules' keys that happen to share the domain) |

**`appBridgeApps`: NOT PRESENT in the binary.** No chosen-apps storage is
read by AppBridge; selection state lives upstream (see §0.1).

---

## 4. Channel map (every `appbridge.*` name, proven by registration/posting xref)

Transports: **DNC** = NSDistributedNotificationCenter (userInfo payload),
**Darwin** = notify_* (uint64 state only), **Local** = NSNotificationCenter.

| Name | Transport | Direction (from AppBridge) | Payload / state | Handler → effect | Evidence |
|---|---|---|---|---|---|
| `…/appbridge.open` | DNC | in (SpringBoard) | {identifier, x,y,w,h, pt,pl,pb,pr, bar,pop,popDim,single, ox,oy,ow,oh, r,corners, hx, front, ax,ay,aw,ah} | block 0x783c → `openApp:frame:` then per-group appliers (order in ABChannels.m) | ctor 0x6e08 repl 0x7004; blk_00783c |
| `…/appbridge.frame` | DNC | in | {identifier, x,y,w,h, live, handle, pt,pl,pb,pr} | block 0x8274 → `setFrame:forApp:live:handle:passInsets:` | 0x8274–0x8c7c read |
| `…/appbridge.shield` | DNC | in | {on} | block 0x8c7c → `setShieldAll:` | blk summary + strings |
| `…/appbridge.close` | DNC | in | {identifier, terminate} | block 0x8df0 → `closeApp:terminate:` | blk summary |
| `…/appbridge.closeall` | DNC | in | {except} | block 0x8fd4 → `closeAllExcept:` | blk summary |
| `…/appbridge.knobs` | DNC | in | {knobs} | block 0x9144 → `setKnobs:` | blk summary |
| `…/appbridge.apporient` | Darwin | in | uint64 state (bundle hash + orientation + mask; packing INFERRED) | block 0x92b4 → `notify_get_state` → `appWithHash:changedOrientation:supportedMask:` | ctor 0x6e08 @0x719c; blk summary |
| `…/appbridge.keyboard` | Darwin | in | uint64 state (bundle hash) | block 0x93b0 → `bundleForHash:` → `ABKeyboard hideForApp:` [B] | ctor 0x6e08 @0x71c0; blk summary |
| `…/appbridge.state` | DNC | **out** (SpringBoard) | {identifier, state} object nil | posted by `ABPostAppState` (failed / ready) | sub_bed4 @0xbed4–0xbf7c |
| `…/appbridge.baraction` | DNC | **out** | {identifier, action ∈ replace/pop/full/bg/close} object nil | posted by `postBarAction:from:` | 0x13148–0x13288 |
| `…/appbridge.bardismiss` | DNC | out | — | posted in `setBarVisible:…` region (sub_a498) [B body] | xref only |
| `…/appbridge.handledrag` | DNC | out | — | posted in handle-drag code (sub_145b8) [B] | xref only |
| `…/appbridge.handletap` | DNC | out | — | posted in `handleTapped:` region (sub_152b0) [B] | xref only |
| `…/appbridge.knobtouch` | DNC | out | {index, phase} (strings) | posted in ABKnobView relay (sub_a750) [B] | xref only |
| `…/appbridge.orientation` | DNC | in (app process, object = own bundle id) | {orientation, device} (strings in handler) | block 0x4728 [B] | ctor 0x44a8 @0x45ac |
| `…/appbridge.key` | DNC | in (app process, object = own bundle id) | {action, type, text, del, return, dismiss, …} | block 0x5908 [B] | ctor 0x44a8 @0x4630 |
| `CarPlayIsConnectedDidChange` | Local | in (SpringBoard) | — | block 0x958c → AVExternalDevice check → `carDisconnected` | ctor repl @0x7208 |
| `com.anlai.omnicar/car.connected` | Darwin | out | — | posted by perf/session unit 0x20dd4 | xref |
| `com.anlai.omnicar/lite` | Darwin | both | uint64 | `_OMCLiteActive` reads; 0x21f7c sets; 0x22094 registers/posts | xref |
| `com.anlai.omnicar/log` | Darwin | out | — | log relay (`_OMCLogRelayStart` 0x1e200) | xref |
| `com.anlai.omnicar/perf` | DNC-ish | out | — | perf unit 0x20dd4 | xref (name only) |
| `com.anlai.omnicar/prefschanged` | Darwin | out | — | posted by profile unit 0x21930 (`notify_post`) | xref |
| `com.anlai.omnicar/rescue` | — | — | — | referenced in prefs/rescue unit 0x1f430 region | xref (name only) |

Who posts `open/frame/close/…`? **Nobody in this dylib** (no matching
`postNotificationName:` sites) — the sender is the car-side controller in a
sibling module. AppBridge is purely the host endpoint for those channels.

---

## 5. Hook inventory (complete for this binary)

Installed by ctor 0x6e08 (SpringBoard only), orig IMP slots
0x3e9f0–0x3ea10 in `__DATA`:

| Target | Replacement | Orig slot | Status |
|---|---|---|---|
| `SpringBoard -applicationDidFinishLaunching:` | 0x7004 (registers §4 host channels) | 0x3e9f0 | VERIFIED |
| `SBSuspendedUnderLockManager -_shouldBeBackgroundUnderLockForScene:withSettings:` | 0x72bc (hosted ⇒ not background-under-lock) | 0x3e9f8 | VERIFIED |
| `FBScene -updateSettings:withTransitionContext:completion:` | 0x74b4 (swallow for hosted, non-foreground scenes) | 0x3ea00 | VERIFIED |
| `SBSceneView -_updateReferenceSize:andOrientation:` | 0x7764 (clamp orientation ≤ 3, tail-call orig) | 0x3ea08 | VERIFIED |
| `BKSDisplayServicesSetScreenBlanked` (dlsym, MSHookFunction) | 0x777c (blank pass-through + 1 s delayed block when hosted) | 0x3ea10 | VERIFIED (block body NOT-RECOVERED) |

Installed by ctor 0x44a8 (every non-excluded app process) — bodies are B's;
listed for completeness: CADisplayLink (`+displayLinkWithTarget:selector:`,
`-setPreferredFramesPerSecond:`, `-setPreferredFrameRateRange:`), UIWindow
`-_setRotatableViewOrientation:duration:force:`, UIDevice
(`-beginGeneratingDeviceOrientationNotifications`, `-setOrientation:animated:`,
`-orientation`), UITextField & UITextView (`-becomeFirstResponder`,
`-resignFirstResponder`), UIWindowScene
`-requestGeometryUpdateWithPreferences:errorHandler:` (only if
`_OMCHasMethod` confirms it), UIViewController
(`-setNeedsUpdateOfSupportedInterfaceOrientations`,
`+attemptRotationToDeviceOrientation`).

`OMCCheckHooks(@"AppBridge", …)` verifies exactly the 3 scene hooks above
(the constant spec array at 0x39408 was decoded in full).

---

## 6. Per-function table (A scope)

Status: **VERIFIED** = body read instruction-level and reconstructed;
**INFERRED** = structure/ingredients proven, some detail not traced;
**MAPPED** = role identified from strings/xrefs, body not reconstructed by A.

| Function | VA | Evidence (disasm) | Status |
|---|---|---|---|
| `__mod_init_0` (app-process ctor) | 0x44a8 | ctor_0044a8.s (7040 B) | VERIFIED (registration + hook list); handler bodies → B |
| `__mod_init_1` (SpringBoard ctor) | 0x6e08 | ctor_006e08.s | VERIFIED |
| `__mod_init_2` (host-process ctor) | 0x20184 | ctor_020184.s | VERIFIED |
| `_OMCPrefsSync` | 0x1d674 | 00…/01d664 region | VERIFIED |
| `_OMCPref` | 0x1d680 | idem | VERIFIED |
| `_OMCEnabled` | 0x1d6e8 | idem | VERIFIED |
| `_OMCFeatureEnabled` | 0x1d744 | idem | VERIFIED |
| `_OMCExpired` | 0x2358c | show 0x2358c–0x23688 | VERIFIED (rem4: effNow = max(now, trustedTime); deadline + latch, fail-open — dump `disasm/rem4_OMCExpired.txt`) |
| `_OMCLiteActive` | 0x1d7d4 | show 0x1d7d4–0x1d930 | VERIFIED (rem4: 3 s cache; mode 1 → enabled, mode 2 → enabled∧(thermal ≥ 2 ∨ Darwin lite state), else NO — dump `disasm/rem4_OMCLiteActive.txt`) |
| `_OMCCarWireless` | 0x1d930 | show 0x1d930–0x1d9cc | VERIFIED (rem4: diagCar → `session` then `configuration` sections; wireless/wired/transport key rules in binary order — dump `disasm/rem4_OMCCarWireless.txt`) |
| `_OMCHasMethod` | 0x1e384 | show 0x1e384–0x1e438 | VERIFIED |
| `_OMCCarClass` | 0x1e438 | show 0x1e438–0x1e580 | VERIFIED |
| `_OMCCheckHooks` | 0x1e580 | show 0x1e580–0x1ec70 (3 reads) | VERIFIED (diag key construction INFERRED) |
| `_ABMissingSelector` | 0x9698 | show 0x9698–0x9800 | VERIFIED head; log tail INFERRED |
| `_OMCMissingSelector` | 0x1ec70 | not separately read | MAPPED (core twin of ABMissingSelector) |
| `_OMCCarLaunchInfo` | 0x1ee50 | show 0x1ee50–0x1ef60 | VERIFIED; **no in-binary caller** |
| `_OMCCrashGuard` unit | 0x1ef60–0x205c8 | head reads + string/xref map | INFERRED (state machine not fully traced) |
| `_OMCLogWrite` / log unit | 0x1d9cc, `_OMCLogRelayStart` 0x1e200 | summary strings/calls | MAPPED |
| `_OMCTr`, `_OMCCurrentLanguage`, `_OMCSupportedLanguages`, `_OMCProfileKeys`, `_OMCLogoMeshImage` | 0x23a38, 0x236a0, 0x23694, 0x23688, 0x23cb0 (unit 0x22f60) | summary | MAPPED (i18n used by menu titles; logo image used by bar builder [B]) |
| Car-profile unit (`sub_213ac` CarKit dlopen, `sub_214cc` diagCar writer, `sub_217d4`, `sub_21930`) | 0x213ac–0x21f7c | summary strings/calls | MAPPED |
| Lite/perf units (`sub_21f7c`, `sub_22094`, `sub_22284`, `sub_22580` OMCPerfTicker, `sub_22e50`) | 0x21f7c–0x22f60 | summary | MAPPED |
| `ABHost +shared` | 0xa9e8 | show | VERIFIED |
| `ABHost count` | 0xaaa0 | show | VERIFIED |
| `ABHost hostsApp:` | 0xaaf0 | show | VERIFIED |
| `ABHost paneFor:` | 0xac84 | show | VERIFIED |
| `ABHost zoom` | 0xae20 | show + const @0x2b210 = 0.6 | VERIFIED (default object undecoded) |
| `ABHost openApp:frame:` | 0xb8a0 | 00b83c file, lines 40–450 | VERIFIED (2.5 s block: posts `ready` @0xc0d0) |
| `ABPostAppState` (sub_bed4) | 0xbed4 | 00b83c lines 440–520 | VERIFIED |
| `ABHost bundleForHash:` | 0xf40c | show (FNV-1a: basis 0x811C9DC5, prime 0x01000193 @0xf47c) | VERIFIED |
| `ABHost frameOfApp:` | 0xf5ec | show | VERIFIED |
| `ABHost appWithHash:changedOrientation:supportedMask:` | 0xf6b0 | skeleton read | VERIFIED core; scene push → B |
| `ABHost postBarAction:from:` | 0x13148 | show 0x13148–0x133c8 | VERIFIED |
| `barReplace:/barPop:/barFull:/barBackground:/barClose:` | 0x13378–0x133b8 | show | VERIFIED (actions replace/pop/full/bg/close) |
| `ABHost closeApp:terminate:` | 0x15ca0 | skeleton read | VERIFIED to dropWindowIfEmpty; terminate tail INFERRED |
| `ABHost closeAll` / `closeAllExcept:` | 0x160ec / 0x160f4 | summary + pattern | VERIFIED pattern |
| `ABHost carDisconnected` | 0x163e8 | full body read (rem4) | VERIFIED — B's surviving text (`ABHostBMethods.m`) matches instruction-for-instruction, incl. count→window short-circuit and the re-read count in the log call; the earlier A-side skeleton and its verifier downgrade are superseded (dump: AppBridgeB `disasm/rem4_carDisconnected.txt`) |
| Host channel blocks (open/frame/shield/close/closeall/knobs/apporient/keyboard/CarPlayConn) | 0x783c, 0x8274, 0x8c7c, 0x8df0, 0x8fd4, 0x9144, 0x92b4, 0x93b0, 0x958c | blk_*.s + targeted reads | VERIFIED (open, frame fully; others via call-sequence + strings); CarPlayConn tail INFERRED |
| SB hook replacements | 0x7004, 0x72bc, 0x74b4, 0x7764, 0x777c | ctor_006e08.s | VERIFIED (0x777c's delayed block NOT-RECOVERED) |

## 7. Open items / NOT-RECOVERED (explicit)

1. The picker UI, chosen-apps storage, and any CarPlay-library injection:
   **not in this binary** (proven absence, §0.1) — sibling module's scope.
2. `apporient` Darwin uint64 packing (hash/orientation/mask bit layout):
   INFERRED from the consumer's extraction; the sender lives in B's
   app-process code (and the SplitScreen module).
3. `closeApp:terminate:` termination tail (0x15db4–0x160ec): skeleton only.
4. `BKSDisplayServicesSetScreenBlanked` replacement's 1 s delayed block
   (literal 0x347d0): not isolated.
5. `_OMCCrashGuard` full state machine and the rescue-feature evaluator
   (0x1f430 region): structure INFERRED, not line-traced.
6. Default-value constant object at 0x395b8 (`appBridgeOrientation`
   default): **decoded byte-exact in rem4 — it is @1**
   (`__objc_intobj`, int64 payload at +16 = 1); source corrected
   (the default was previously passed as nil). The 0x39598 object
   (`appBridgeZoom` default) remains undecoded.
7. `OMCCarLaunchInfo` has no caller inside AppBridge — cross-module call
   graph must be confirmed by the coordinator from sibling modules.
