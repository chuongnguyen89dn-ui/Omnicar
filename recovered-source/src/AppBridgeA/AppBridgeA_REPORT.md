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
`paneOfBarButton:`, `nudgePane:`, `teardown
...[truncated 20887 chars]Pane:`, and the
app-process hook replacements registered by ctor 0x44a8 (CADisplayLink /
UIWindow / UIDevice / UITextField / UITextView / UIWindowScene /
UIViewController orientation & keyboard hooks) plus the `appbridge.orientation`
and `appbridge.key` handler blocks (0x4728, 0x5908).

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
| `appBridgeOrientation` | integer (default object at 0x395b8, not decoded) | `openApp:frame:`; values 3,4 mapped to 0 |
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
| `_OMCExpired` | 0x2358c | show 0x2358c–0x23688 | INFERRED (trustedTime combination) |
| `_OMCLiteActive` | 0x1d7d4 | show 0x1d7d4–0x1d930 | INFERRED (branch detail) |
| `_OMCCarWireless` | 0x1d930 | show 0x1d930–0x1d9cc | INFERRED (diagCar key path) |
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
| `ABHost carDisconnected` | 0x163e8 | skeleton read | VERIFIED skeleton |
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
6. Default-value constant objects at 0x395b8 (`appBridgeOrientation`
   default) and 0x39598 (`appBridgeZoom` default): not decoded byte-exact.
7. `OMCCarLaunchInfo` has no caller inside AppBridge — cross-module call
   graph must be confirmed by the coordinator from sibling modules.
