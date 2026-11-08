# OmniCarSplitScreen — Agent A (scene hosting & lifecycle) — Reconstruction Report

Binary: `OmniCarSplitScreen.dylib`, arm64 slice (590,720 B of the fat file),
UUID 751B5625-5F29-3D7A-BD16-71EB08F1D521, min iOS 15.0 / SDK 16.4.
Injected into `com.apple.CarPlayApp` + `com.apple.springboard`
(filter verified). 11 ObjC classes / 480 methods total; **A = 251 methods,
B = 229 methods** (computed partition, `work/partition_result.json`).
Reconstruction method: LC_FUNCTION_STARTS (886 exact function starts,
decoded manually) + capstone disassembly with a chained-fixup-aware,
calibration-corrected annotator (`work/omdis.py`). Source files are under
`src/SplitScreenA/`; per-function dumps under `src/SplitScreenA/disasm/`
(~300 files).

## 1. Partition used

**A takes in full:** `SCPNoopLayoutAssertion` (1 method), `SCPCarPane`
(37 — all synthesized accessors), `SCPHostedAppVC` (9), `SCPPrefs` (21),
and the **lifecycle/scene half of `SCPCarSplit`** (183 of its 369 methods):
activation, container creation, app open/launch/adopt/detach, pending
bookkeeping, pairs/recent/favorites restore, close paths, disconnect
cleanup, the AppBridge host protocol methods, state publishing, and the
singleton/init. Also ALL C-level initializers (`__init_0..3`), all hook
replacements installed by them, the distributed-notification blocks, and
the shared C helpers.

**B takes in full:** `SCPCarSplitView` (4 listed methods + its C helpers),
`SCPCarDividerView` (9), `SCPCarTabView` (1), `SCPCButton` (2),
`SCPCTouchWatch` (7), `SCPHomeWallView` (20), the `OMCZoom*` classes
(separate class list in the view cluster), and **186 SCPCarSplit methods**
in the view domain: layout/relayout, zoom, divider/drag/gesture, picker UI,
loader/cover views, bar/tab/tray/popup/shield UI, ratio menu, toasts, tips,
home button, float pane. The exact split is `A_SELS` in
`work/partition.py`; B's SCPCarSplit set is the complement of A_SELS within
the class. In `SCPCarSplit.h` the B-domain methods are declared in the
`SplitScreenB` category so A's file links conceptually; B implements them.

**Unassigned families flagged for the coordinator** (neither A's lifecycle
domain nor B's view cluster — home-screen icon injection C family):
`_SCPChosenPhoneApps` 0x9a60, `_SCPIsInjectedPhoneApp` 0x9980,
`_SCPInjectDeclarationIfChosen` 0x9b34, `_SCPAddChosenAppsToLibrary` 0xa500,
`_SCPAppIconsBeginInjection` 0xc37c, `_SCPAppIconsRetry` 0xb044,
`_SCPAppIconsCarScreenOK` 0xc570, `_SCPDumpAppLibraryOnce` 0xc624,
`_SCPSetHomeViewController` 0xaa00, `_SCPHomeSetVisible` 0x4b4bc,
`_SCPHomeRefresh` 0x4b598, `_SCPHomeApply` 0x4a6d8, `_SCPRealBundleForInfos`
0xd950 (used by A, declared extern), `_SCPRefreshAppIconsSoon` 0xaa10,
`_SCPRefreshHiddenAppsSoon` 0xc008, `_SCPCarAppIcon` 0xdeac,
`_SCPCarAppName` 0xe0c0, `_SCPCarHomeBundles` 0xdb2c, `_SCPCarLaunchApp`
0xe410, `_SCPHomeAppRemovable` 0xb1f8, `_SCPHomeGridColumns` 0x48f48,
`_SCPHomeGridRows` 0x49014, `_SCPHomeIconModelLayout` 0xbce4,
`_SCPHomeIconScale` 0x48e24, `_SCPHomeShowNames` 0x490e0,
`_SCPIconForcedOnCar` 0xbb20, `_SCPIconHiddenOnCar` 0xb5ec, `sub_5520`
(SCPHomeKick), `sub_21d4c`/`sub_22210` (app-list builders used by
publishCarPlayApps), and the icon-grid hook replacement bodies (installed
by `__init_0`, targets/IMPs verified in §3; bodies belong with the home
family). Also observed outside A's scope in the 0x52048 region: the
lite-mode check at 0x53f5c and the runtime creation of an `OMCPerfTicker`
class at 0x546f8 (objc_allocateClassPair + class_addMethod with
imp_implementationWithBlock, type `v@:@`) — OMC infra territory (Core).

## 2. Calibration corrections applied (coordinator broadcast)

Wave-1 metadata decoded chained-fixup ordinals as 1-based; they are
0-based. Independently proven before the broadcast from call sites (the
stub at 0x56344 is called with the exact MSHookMessageEx signature and its
ordinal resolves to `_MSHookMessageEx` only with the +1 shift; block isa
slots resolve to `__NSConcreteGlobalBlock`; classref 0x87670 resolves to
NSBundle where `[NSBundle mainBundle]` is sent) and confirmed by the
calibrated xref (delta = 1, 216/216 votes). My disassembler applied the
correction from the start, so addresses/instructions/selref names were
never affected. Names I had taken from wave-1 metadata and corrected:

| Item | Wave-1 (wrong) | Calibrated (used) | Evidence |
|---|---|---|---|
| SCPCarSplit superclass | UIViewController | **NSObject** | superclass slot re-decoded with corrected ordinal; consistent with behavior (containment is done by the dashboard root VC — §4) |
| SCPCarPane superclass | UIViewController | **NSObject** | same; consistent with its own strong `view` property |
| SCPHostedAppVC superclass | NSOperationQueue | **UIViewController** | same; consistent with viewDidLoad and storage in `SCPCarPane.vc` |
| SCPNoopLayoutAssertion superclass | UIViewController | **NSObject** | same |
| SCPPrefs superclass | UIViewController | **NSObject** | same (my source already used NSObject) |
| (B classes, FYI) SCPCarSplitView / SCPCarDividerView / SCPCarTabView / SCPCTouchWatch / SCPHomeWallView superclass | NSMutableArray | **UIView** | same |
| (B class, FYI) SCPCButton superclass | NSSortDescriptor | **UIButton** | same |

Classref name sets cross-checked against `metadata/xref/
OmniCarSplitScreen.json`: 76 names identical; the 15 names only in xref
are classes resolved via `objc_getClass("…")` cstrings at call sites
(CARApplication, SpringBoard, SBIconView, …), not classref slots; the one
name only in mine (NSURLComponents) is a classref slot not exercised as a
call-site class arg in xref. No name disagrees. The calibrated PREFS_MAP
additionally pinned `sub_48864` (used in SCPIsHostedApp) to the OMC pref
key `appBridgeApps`; noted in SCPShared.m.

**Behavioral correction found while validating the calibration:**
`-[SCPCarSplit adopt:slot:]` does NOT make SCPCarSplit the parent VC. The
parent is the dashboard root view controller (`sub_12658` result):
containment calls are skipped when the VC is already the root's child,
`[root addChildViewController:vc]` / `[vc didMoveToParentViewController:
root]` otherwise; `pane.sceneSize` is set to `CGSizeZero` at adopt (the
real size arrives via verifySceneOfPane:), and
`additionalSafeAreaInsets` is exactly `_UIEdgeInsetsZero` (GOT-verified).
Fixed in SCPCarSplit.m.

## 3. Hook installers (all VERIFIED end-to-end)

`__init_offsets` lists exactly 4 initializers.

**`__init_0` @0x44a8 — CarPlayApp, home/app-library group.** Guards:
bundleId == `com.apple.CarPlayApp` and `OMCCrashGuard(@"splitScreen")`
non-zero. 17 MSHookMessageEx hooks:

| Target | Selector | Replacement | Orig storage |
|---|---|---|---|
| DashBoard (meta) | +_newApplicationLibrary | 0x4af0 | 0x87fb0 |
| DBApplicationInfo | -_loadFromProxy: | 0x4bcc | 0x87fb8 |
| DBDashboardHomeViewController | -initWithEnvironment: | 0x4c70 | 0x87fc0 |
| DBDashboardHomeViewController | -viewDidLayoutSubviews | 0x4cb4 | 0x87fc8 |
| DBDashboardHomeViewController | -viewDidAppear: | 0x4d24 | 0x87fd0 |
| DBDashboardHomeViewController | -viewDidDisappear: | 0x4d90 | 0x87fd8 |
| DBApplicationLaunchInfo (meta) | +launchInfoForApplication: | 0x4dfc | 0x87fe0 |
| DBApplicationLaunchInfo (meta) | +launchInfoForApplication:withActivationSettings: | 0x4f30 | 0x87fe8 |
| SBIconListGridLayoutConfiguration | -iconImageInfo | 0x5104 | 0x87ff0 |
| SBIconListGridLayoutConfiguration | -numberOfPortraitColumns | 0x51a0 | 0x87ff8 |
| SBIconListGridLayoutConfiguration | -numberOfPortraitRows | 0x51d8 | 0x88000 |
| SBIconListGridLayoutConfiguration | -numberOfLandscapeColumns | 0x5210 | 0x88008 |
| SBIconListGridLayoutConfiguration | -numberOfLandscapeRows | 0x5248 | 0x88010 |
| SBIconView | -setLabelHidden: | 0x5280 | 0x88018 |
| icon-model class (sub_52e8: first of DBIconModel/SBHIconModel/SBIconModel) | -isIconVisible: | 0x5338 | 0x88020 |
| CARIconView else DBIconView (meta, only if the class responds) | +maxLabelSizeForIconImageSize: | 0x5438 | 0x88028 |

Then `_OMCCheckHooks(@"SplitScreen", [11 names])`, missing-class warnings,
and `notify_register_dispatch("com.anlai.omnicar/prefschanged",
&token@0x88030, main queue, block 0x78720 -> invoke 0x54bc)`.

**`__init_1` @0x58b4 — CarPlayApp, dashboard/scene group** ("loaded into
CarPlay"). 13 hooks:

| Target | Selector | Replacement | Orig storage |
|---|---|---|---|
| DBDashboard | -sceneFrameForAppInfo:proxyAppInfo: | 0x5cf0 | 0x88040 |
| DBDashboard | -safeAreaInsetsForAppInfo:proxyAppInfo: | 0x5e84 | 0x88048 |
| DBDashboard | -_handleHomeEvent: | 0x601c | 0x88050 |
| DBDashboard | -invalidate | 0x611c | 0x88058 |
| DBDashboard | -_launchAppWithInfo:forURL: | 0x61d0 | 0x88060 |
| DBDashboardRootViewController | -presentBaseViewController:animated:launchSource:completion: | 0x636c | 0x88068 |
| DBDashboardRootViewController | -dismissBaseViewControllerAnimated:completion: | 0x66dc | 0x88070 |
| DBDashboardRootViewController | -viewDidLayoutSubviews | 0x68e8 | 0x88078 |
| DBDashboardRootViewController | -viewDidAppear: | 0x6988 | 0x88080 |
| DBApplicationSceneViewController | -backgroundSceneWithCompletion: | 0x69fc | 0x88088 |
| DBApplicationSceneViewController | -deactivateSceneWithReasonMask: | 0x6b44 | 0x88090 |
| DBApplicationSceneViewController | -sceneManager:didDestroyScene: | 0x6c78 | 0x88098 |
| FBSDisplayLayoutPublisher | -addElement: | 0x6e10 | 0x880a0 |

**VERIFIED QUIRK (probable original bug):** the FBSDisplayLayoutPublisher
hook is installed only when `objc_getClass("DBDashboard")` returns nil
(the installer re-tests a leftover cstring register). DBDashboard resolves
in CarPlayApp, so this hook is effectively never installed; reproduced
faithfully in SCPHooks.m.

Then `_OMCCheckHooks` (second list @0x80338) and 7 NSDistributedNotification
Center observers (main queue, global blocks): `appbridge.state`
(0x78760→0x7434), `appbridge.handletap` (0x78780→0x76a0),
`appbridge.handledrag` (0x787a0→0x77c8), `appbridge.baraction`
(0x787c0→0x78b4), `appbridge.bardismiss` (0x787e0→0x7a4c),
`appbridge.knobtouch` (0x78800→0x7b00), `splitscreen.native`
(0x78820→0x7bec). Full names carry the `com.anlai.omnicar/` prefix.

**`__init_2` @0x843c — SpringBoard only.** One hook, installed by tail
call: `-[SpringBoard applicationDidFinishLaunching:]` → sub_8540,
orig @0x880b0. sub_8540 calls orig, logs `SpringBoard ready, dang ky
notification`, registers observers for `splitscreen.ack` (0x788d0→0x874c,
~4-insn no-op), `splitscreen.ready` (0x788f0→0x875c, replays the stored
last native request: `man xe san sang -> gui lai yeu cau %@`),
`splitscreen.kill` (0x78940→0x89d0), `com.anlai.omnicar/url`
(0x78960→0x8f6c, omnicar://splitscreen/<action>?… → native command).

**`__init_3` @0x52048 — diag/bootstrap.** If processName is "SpringBoard"
or "CarPlay": dispatch_async(main, block 0x52118) which logs
`build %s (%s) loaded into %@` with **version `1.0.3`, build `fbebb21`**
and writes `{version, build, date}` via CFPreferencesSetAppValue to key
`diagLoaded.SplitScreen@<process>` in suite `com.anlai.omnicar` +
CFPreferencesAppSynchronize (all VERIFIED from the block body).

## 4. Core mechanisms (how the feature works)

- **Presentation gate:** the `presentBaseViewController:` hook is the
  single decision point. While split is active and the incoming VC is
  adoptable (a `DBApplicationSceneViewController` whose appInfo doesn't
  declare `presentsFullScreen` and whose real bundle resolves), the hook
  adopts it into a pane and never calls the original. Otherwise it closes
  the split (`… toan man -> tat split`) and passes through; after any
  fullscreen presentation it schedules a **799,268,864 ns** repair re-check
  and `refreshAppTabSoon`.
- **Scene protection:** `backgroundSceneWithCompletion:` and
  `deactivateSceneWithReasonMask:` hooks swallow the calls for VCs that
  live in panes (unless `allowBackground`, an NSInteger counter ivar,
  is > 0 for deliberate detaches). `sceneManager:didDestroyScene:`
  captures the pane's scene before orig, then SCPCarSplit closes the pane
  if the destroyed scene is really its own (identifier comparison), else
  logs and keeps the pane.
- **Geometry decision:** `sceneFrameForAppInfo:proxyAppInfo:` replaces the
  frame size with `-[SCPCarSplit paneSize:forBundle:]` (container's
  frameForSlot: for the pane owning / pending the bundle).

- **Open pipeline:** `openApp:slot:` → hosted check (AppBridge) → pending
  entry `@[ @(slot), [NSDate date] ]` → loader → throttled
  `SCPSendDashboardEvent(4, launchInfo)` (a `+[DBEvent
  eventWithType:context:]` sent to the dashboard object;
  `nextLaunchAt` spaced by an INFERRED 0.35 s) → adoption via the
  presentation gate, or `recoverPending:` steals an already-existing VC
  from the dashboard's `_entityIdentifierToViewControllerMap`. Pending
  entries go stale after **12.0 s** (`purgePending` /
  `pendingSlotForBundle:`); cancelled launches are remembered **30.0 s**
  in `adoptViewController:` and backgrounded if they still arrive.
- **Attach:** `adopt:slot:` evicts a same-bundle VC from other panes,
  host-closes or detaches an occupant, then (via the root VC's
  containment) reparents the view into `pane.host`, frame = host bounds,
  flexible W/H, `additionalSafeAreaInsets = UIEdgeInsetsZero`,
  `sceneSize = CGSizeZero` (verified later against the scene settings
  frame with **2.0 pt** tolerance by verifySceneOfPane:).
- **Restore on connect:** RootVC `viewDidAppear:` hook → after **~3.0 s**
  (2,996,068,352 ns) publishCarPlayApps + carScreenAppeared → after
  **7.0 s** dump the app library once. carScreenAppeared posts
  `splitscreen.ready` (once) and, if prefs autoLaunch is on, retries
  `autoLaunchAttempt:` (delays 1.0 s then 1.5 s, both in-body constants)
  until the root exists, then opens the most recent layout whose apps all
  support CarPlay, else favorite #1. `openSetupLayout:apps:` on an
  inactive split suppresses reopen, activates with the layout, restores
  the saved pair ratio, and opens apps in order; AppBridge apps are seeded
  as pending + loader and opened deferred.
- **Disconnect cleanup:** DBDashboard `-invalidate` hook →
  `dashboardInvalidated`: clears app tab/home button/auto-launch flag,
  solo-hosted state, picker sheet, tray window, popup shield; if active:
  logs `CarSplit: DashBoard invalidate -> bo split`, deactivates, clears
  pending, unpublishes busy, invalidates bar timers, drops float pane,
  drag ghost, ratio menu/timer, and removes the container.
- **Hosted (AppBridge) protocol:** all names VERIFIED by string xref.
  Outbound (hostPost:info: = NSDistributedNotificationCenter post):
  `appbridge.open` {identifier, x, y, w, h}, `appbridge.frame` (host frame
  info dict), `appbridge.close` {identifier, terminate},
  `appbridge.closeall` {except}, `appbridge.shield` {on}.
  Inbound: `appbridge.state` {identifier, state} drives loader removal /
  pane close / failure toast (`Couldn't show %@ on the car`); solo
  (fullscreen hosted) apps use `showSoloCoverForBundle:` + `hostSolo:`
  and end via `endHostedSolo`. Commands into CarPlayApp arrive as
  `splitscreen.native` userInfo actions: close / closeApp / open (slot) /
  pair / fav / picker / layout; every command ends with a
  `splitscreen.ack` post. From SpringBoard, `sub_88d0` posts native
  commands and remembers them for the ready-replay; `splitscreen.kill`
  terminates via FBSSystemService (reason 1, report NO, description
  `OmniCar Split Screen close`) with an SBApplicationController → pid →
  `kill(pid, 9)` fallback.

## 5. Statuses, stubs, externs

Status convention: **VERIFIED** = body read end-to-end or (for accessors)
pattern + sampled bodies proven; **VERIFIED (call-sequence)** = every call,
string and constant in the body identified from the skeleton/disasm, minor
branch glue inferred; **INFERRED** = shape modelled from call sites/roles,
body not fully decoded; **NOT-RECOVERED** = marked stub.

- **Stubs (`// STUB-UNRECOVERED`): exactly one** — `SCPSceneOfVC` in
  SCPShared.m (sub_1ab70): the exact ivar/key path from a scene VC to its
  FBScene was not decoded; modelled as a guarded `scene` send.
  `SCPSceneIdentifierOfVC` (sub_1b13c) is INFERRED on top of it.
- **Extern placeholders the coordinator must reconcile** (name used in my
  source → original): `SCPSyntheticLaunchInfo` → the tail of the
  launchInfo hooks (0x4dfc/0x4f30); `SCPLayoutElementKey` → sub_8350;
  `SCPAppHasCarPlayUI` → sub_ffb4; `SCPInfoBool` → sub_17d84;
  `SCPResetDetachedView` → sub_1a1b8; `SCPFrameForSlot` →
  `-[SCPCarSplitView frameForSlot:]` (B); `SCPCarPlayAppInfos` →
  sub_21d4c; `SCPChosenPhoneAppCount` → sub_22210; `SCPBridgedChosenApps`
  → sub_48864 (= `appBridgeApps` pref); `OMCPrefSet` → the OMC pref
  setters used by SCPPrefs.m (Core); icon-grid IMPs `SCPHook_Grid_*`,
  `SCPHook_IconView_setLabelHidden`, `SCPHook_IconModel_isIconVisible`,
  `SCPHook_IconView_maxLabelSize` → replacement bodies 0x5104/0x51a0/
  0x51d8/0x5210/0x5248/0x5280/0x5338/0x5438 (home family, §1).
- Notable INFERRED items (labelled in-source): safeAreaInsets hook body
  (passthrough), `_launchAppWithInfo:`/HomeEvent branch glue, activation
  animation constants (0.35/0.85/0), layout fractions handling in
  openPairLeft:right:, several one-key SCPPrefs accessors (key names
  INFERRED; the four read/write statics and all string-verified keys are
  VERIFIED), home-button cluster bodies, bridge* handler bodies,
  hostFrameInfo: composition, killAppSoon delay (1.0 s).

## 6. Per-function table (agent A, 251 methods)

Evidence for every row: `disasm/<label>.txt` in this folder (annotated
arm64 disassembly) + `work/all_methods.txt` (IMP map). Status column:
ACC = accessor (VERIFIED by pattern + samples); FULL = read end-to-end
(VERIFIED); SEQ = VERIFIED (call-sequence); INF = INFERRED as noted in
§5 / in-source comments. SCPCarSplit rows not marked ACC/FULL are SEQ
unless INF is named in the in-source comment.

| Class | ± | Selector | IMP |
|---|---|---|---|
| SCPNoopLayoutAssertion | - | invalidate | 0x58b0 |
| SCPCarPane | - | slot | 0xf8c8 |
| SCPCarPane | - | setSlot: | 0xf8d0 |
| SCPCarPane | - | bundleID | 0xf8d8 |
| SCPCarPane | - | setBundleID: | 0xf8e0 |
| SCPCarPane | - | vc | 0xf8e8 |
| SCPCarPane | - | setVc: | 0xf8f0 |
| SCPCarPane | - | view | 0xf920 |
| SCPCarPane | - | setView: | 0xf928 |
| SCPCarPane | - | host | 0xf958 |
| SCPCarPane | - | setHost: | 0xf960 |
| SCPCarPane | - | handle | 0xf990 |
| SCPCarPane | - | setHandle: | 0xf998 |
| SCPCarPane | - | bar | 0xf9c8 |
| SCPCarPane | - | setBar: | 0xf9d0 |
| SCPCarPane | - | cover | 0xfa00 |
| SCPCarPane | - | setCover: | 0xfa08 |
| SCPCarPane | - | loader | 0xfa38 |
| SCPCarPane | - | setLoader: | 0xfa40 |
| SCPCarPane | - | popButton | 0xfa70 |
| SCPCarPane | - | setPopButton: | 0xfa78 |
| SCPCarPane | - | soloButton | 0xfaa8 |
| SCPCarPane | - | setSoloButton: | 0xfab0 |
| SCPCarPane | - | barTimer | 0xfae0 |
| SCPCarPane | - | setBarTimer: | 0xfae8 |
| SCPCarPane | - | picker | 0xfb18 |
| SCPCarPane | - | setPicker: | 0xfb20 |
| SCPCarPane | - | hostFrame | 0xfb50 |
| SCPCarPane | - | setHostFrame: | 0xfb5c |
| SCPCarPane | - | hostHandle | 0xfb68 |
| SCPCarPane | - | setHostHandle: | 0xfb70 |
| SCPCarPane | - | hostBar | 0xfb78 |
| SCPCarPane | - | setHostBar: | 0xfb80 |
| SCPCarPane | - | hostHole | 0xfb88 |
| SCPCarPane | - | setHostHole: | 0xfb94 |
| SCPCarPane | - | sceneSize | 0xfba0 |
| SCPCarPane | - | setSceneSize: | 0xfba8 |
| SCPCarPane | - | .cxx_destruct | 0xfbb0 |
| SCPHostedAppVC | - | viewDidLoad | 0xfc58 |
| SCPHostedAppVC | - | backgroundSceneWithCompletion: | 0xfd14 |
| SCPHostedAppVC | - | foregroundSceneWithSettings:completion: | 0xfd60 |
| SCPHostedAppVC | - | applicationInfo | 0xfdac |
| SCPHostedAppVC | - | proxyApplicationInfo | 0xfdb4 |
| SCPHostedAppVC | - | sceneHostView | 0xfdbc |
| SCPHostedAppVC | - | bundleID | 0xfdc4 |
| SCPHostedAppVC | - | setBundleID: | 0xfdd4 |
| SCPHostedAppVC | - | .cxx_destruct | 0xfde0 |
| SCPCarSplit | + | shared | 0xfdf4 |
| SCPCarSplit | - | init | 0xfe64 |
| SCPCarSplit | - | isCarPlayApp: | 0xff20 |
| SCPCarSplit | - | displayNameFor: | 0x1029c |
| SCPCarSplit | - | allPanes | 0x10604 |
| SCPCarSplit | - | paneAtSlot: | 0x106f0 |
| SCPCarSplit | - | validSlot: | 0x107cc |
| SCPCarSplit | - | paneForBundle: | 0x10800 |
| SCPCarSplit | - | purgePending | 0x109d8 |
| SCPCarSplit | - | pendingSlotForBundle: | 0x10c88 |
| SCPCarSplit | - | slotOccupied: | 0x10df4 |
| SCPCarSplit | - | paneCount | 0x10fac |
| SCPCarSplit | - | layoutID | 0x11080 |
| SCPCarSplit | - | autoSlot | 0x115a0 |
| SCPCarSplit | - | ensureContainer | 0x12718 |
| SCPCarSplit | - | newPane | 0x13040 |
| SCPCarSplit | - | insertPaneAt: | 0x135e4 |
| SCPCarSplit | - | reindexPanes | 0x14154 |
| SCPCarSplit | - | setPaneCount: | 0x147e0 |
| SCPCarSplit | - | removePaneAt:background: | 0x149a8 |
| SCPCarSplit | - | switchToLayout: | 0x15000 |
| SCPCarSplit | - | raise | 0x156a4 |
| SCPCarSplit | - | publishBusy | 0x15834 |
| SCPCarSplit | - | rootDidLayout | 0x15984 |
| SCPCarSplit | - | activate | 0x15c24 |
| SCPCarSplit | - | activateWithLayout: | 0x15c2c |
| SCPCarSplit | - | activateWithCount: | 0x15cdc |
| SCPCarSplit | - | openApp:slot: | 0x164d4 |
| SCPCarSplit | - | sendLaunch:bundle:tries: | 0x16e04 |
| SCPCarSplit | - | recoverPending:attempt: | 0x1734c |
| SCPCarSplit | - | launchFailed:slot: | 0x17e70 |
| SCPCarSplit | - | killAppSoon: | 0x180dc |
| SCPCarSplit | - | openPairLeft:right: | 0x183a8 |
| SCPCarSplit | - | openAppsInOrder: | 0x1869c |
| SCPCarSplit | - | wantsViewController: | 0x18af0 |
| SCPCarSplit | - | isAdoptableViewController: | 0x18b5c |
| SCPCarSplit | - | adoptViewController: | 0x18d20 |
| SCPCarSplit | - | adopt:slot: | 0x1942c |
| SCPCarSplit | - | repairPresentedViewController: | 0x19e04 |
| SCPCarSplit | - | rememberRecent | 0x1a3d0 |
| SCPCarSplit | - | rememberPair | 0x1a624 |
| SCPCarSplit | - | detachVC:background: | 0x1a77c |
| SCPCarSplit | - | protectsViewController: | 0x1a960 |
| SCPCarSplit | - | sceneOfViewController: | 0x1aaf4 |
| SCPCarSplit | - | scene:destroyedForViewController:ownScene: | 0x1ad58 |
| SCPCarSplit | - | paneSize:forBundle: | 0x1b328 |
| SCPCarSplit | - | relayoutAnimated: | 0x1b444 |
| SCPCarSplit | - | relayoutAnimated:pushScenes: | 0x1b44c |
| SCPCarSplit | - | pushSceneSizes | 0x1c550 |
| SCPCarSplit | - | verifySceneOfPane:expected:retry: | 0x1cce0 |
| SCPCarSplit | - | swapSlot:with: | 0x1d494 |
| SCPCarSplit | - | closeSlot:background: | 0x1d9b8 |
| SCPCarSplit | - | afterPaneRemoved: | 0x1db48 |
| SCPCarSplit | - | soloBundle: | 0x1e33c |
| SCPCarSplit | - | showSoloCoverForBundle: | 0x20d8c |
| SCPCarSplit | - | hideSoloCover | 0x21390 |
| SCPCarSplit | - | baseViewControllerPresented | 0x214b8 |
| SCPCarSplit | - | closeApp: | 0x215a4 |
| SCPCarSplit | - | closeGoingHome: | 0x21618 |
| SCPCarSplit | - | publishCarPlayApps | 0x21b1c |
| SCPCarSplit | - | dashboardInvalidated | 0x22724 |
| SCPCarSplit | - | paneForView: | 0x23914 |
| SCPCarSplit | - | bridgeOutsideTouched | 0x257e8 |
| SCPCarSplit | - | bridgeHandleDrag: | 0x28260 |
| SCPCarSplit | - | paneSolo: | 0x287b8 |
| SCPCarSplit | - | runSoloForPane: | 0x288c0 |
| SCPCarSplit | - | paneBackground: | 0x28a30 |
| SCPCarSplit | - | runBackgroundForPane: | 0x28b38 |
| SCPCarSplit | - | paneClose: | 0x2a0e0 |
| SCPCarSplit | - | runCloseForPane: | 0x2a1e8 |
| SCPCarSplit | - | markDismissSlot: | 0x2be00 |
| SCPCarSplit | - | tabParent | 0x366dc |
| SCPCarSplit | - | fullscreenAppBundle | 0x367f0 |
| SCPCarSplit | - | viewIsRaised: | 0x36a18 |
| SCPCarSplit | - | raiseView: | 0x36bd8 |
| SCPCarSplit | - | favoriteApps: | 0x3a86c |
| SCPCarSplit | - | openFavorite: | 0x3aa60 |
| SCPCarSplit | - | openSetupLayout:apps: | 0x3ab7c |
| SCPCarSplit | - | exitKeepBundle | 0x3ae10 |
| SCPCarSplit | - | exitTapped | 0x3b138 |
| SCPCarSplit | - | setFullscreenBridgeHidden:bundle: | 0x3c33c |
| SCPCarSplit | - | layoutChosenID: | 0x3c61c |
| SCPCarSplit | - | hostedPanes | 0x3c778 |
| SCPCarSplit | - | bridgedPane | 0x3c910 |
| SCPCarSplit | - | hostPost:info: | 0x3c968 |
| SCPCarSplit | - | hostFrameForPane: | 0x3ca0c |
| SCPCarSplit | - | hostBarInfoForPane: | 0x3cd60 |
| SCPCarSplit | - | anyBarVisible | 0x3d058 |
| SCPCarSplit | - | hostPassInsetsForPane: | 0x3d1e4 |
| SCPCarSplit | - | hostFrameInfo:pane:live:handle: | 0x3d39c |
| SCPCarSplit | - | holeForPane: | 0x3dca8 |
| SCPCarSplit | - | sendHostFrameForPane:live: | 0x3dfac |
| SCPCarSplit | - | pushHostFramesLive: | 0x3e238 |
| SCPCarSplit | - | publishShield | 0x3e374 |
| SCPCarSplit | - | hostApp:inPane: | 0x3e490 |
| SCPCarSplit | - | hostClose:terminate: | 0x3ebd0 |
| SCPCarSplit | - | publishKnobsSoon | 0x3ed08 |
| SCPCarSplit | - | publishKnobsNow | 0x3ed84 |
| SCPCarSplit | - | hostCloseAll | 0x3f25c |
| SCPCarSplit | - | hostedApp:state: | 0x3f35c |
| SCPCarSplit | - | bridgeHandleTapped: | 0x3f65c |
| SCPCarSplit | - | bridgeBarAction:forBundle: | 0x3f7f4 |
| SCPCarSplit | - | hostSolo: | 0x3f9c0 |
| SCPCarSplit | - | endHostedSolo | 0x3fe5c |
| SCPCarSplit | - | dismissStuckBaseSoon | 0x3ff28 |
| SCPCarSplit | - | homePressedDuringSplit: | 0x40298 |
| SCPCarSplit | - | launchPhoneAppIfNeeded: | 0x403d0 |
| SCPCarSplit | - | atHomeScreen | 0x404fc |
| SCPCarSplit | - | dockClusterInParent: | 0x405fc |
| SCPCarSplit | - | launcherCenterInParent:size:shift: | 0x409b0 |
| SCPCarSplit | - | refreshHomeButton | 0x41be4 |
| SCPCarSplit | - | setDockShift: | 0x426f8 |
| SCPCarSplit | - | raiseLauncher | 0x42900 |
| SCPCarSplit | - | dockHostForRect:inParent: | 0x42a64 |
| SCPCarSplit | - | removeHomeButton | 0x434a8 |
| SCPCarSplit | - | homeButtonTapped | 0x43514 |
| SCPCarSplit | - | homeButtonTappedUnsafe | 0x4360c |
| SCPCarSplit | - | openRememberedPairForConnect | 0x43720 |
| SCPCarSplit | - | openRememberedPair | 0x43cdc |
| SCPCarSplit | - | installIconLongPress | 0x440e0 |
| SCPCarSplit | - | installLongPressIn:depth: | 0x44344 |
| SCPCarSplit | - | iconLongPressed: | 0x44620 |
| SCPCarSplit | - | iconLongPressedUnsafe: | 0x44738 |
| SCPCarSplit | - | carScreenAppeared | 0x44cdc |
| SCPCarSplit | - | autoLaunchAttempt: | 0x44dc4 |
| SCPCarSplit | - | active | 0x4580c |
| SCPCarSplit | - | setActive: | 0x45814 |
| SCPCarSplit | - | cancelledLaunches | 0x4581c |
| SCPCarSplit | - | setCancelledLaunches: | 0x45824 |
| SCPCarSplit | - | soloCover | 0x45854 |
| SCPCarSplit | - | setSoloCover: | 0x4585c |
| SCPCarSplit | - | lastBridgeTapBundle | 0x45944 |
| SCPCarSplit | - | setLastBridgeTapBundle: | 0x4594c |
| SCPCarSplit | - | lastBridgeTapAt | 0x45954 |
| SCPCarSplit | - | setLastBridgeTapAt: | 0x4595c |
| SCPCarSplit | - | container | 0x45a4c |
| SCPCarSplit | - | setContainer: | 0x45a54 |
| SCPCarSplit | - | slots | 0x45a84 |
| SCPCarSplit | - | setSlots: | 0x45a8c |
| SCPCarSplit | - | layoutKind | 0x45af4 |
| SCPCarSplit | - | setLayoutKind: | 0x45afc |
| SCPCarSplit | - | pending | 0x45b04 |
| SCPCarSplit | - | setPending: | 0x45b0c |
| SCPCarSplit | - | focusedSlot | 0x45b3c |
| SCPCarSplit | - | setFocusedSlot: | 0x45b44 |
| SCPCarSplit | - | allowBackground | 0x45b4c |
| SCPCarSplit | - | setAllowBackground: | 0x45b54 |
| SCPCarSplit | - | nextLaunchAt | 0x45ba4 |
| SCPCarSplit | - | setNextLaunchAt: | 0x45bac |
| SCPCarSplit | - | soloHostedBundle | 0x45bb4 |
| SCPCarSplit | - | setSoloHostedBundle: | 0x45bbc |
| SCPCarSplit | - | soloHostedFrame | 0x45bc4 |
| SCPCarSplit | - | setSoloHostedFrame: | 0x45bd0 |
| SCPCarSplit | - | ignoreHomeOnce | 0x45bdc |
| SCPCarSplit | - | setIgnoreHomeOnce: | 0x45be4 |
| SCPCarSplit | - | soloReturnedVC | 0x45bec |
| SCPCarSplit | - | setSoloReturnedVC: | 0x45c04 |
| SCPCarSplit | - | dismissStuckPending | 0x45c10 |
| SCPCarSplit | - | setDismissStuckPending: | 0x45c18 |
| SCPCarSplit | - | layoutApp | 0x45ea4 |
| SCPCarSplit | - | setLayoutApp: | 0x45eac |
| SCPCarSplit | - | suppressReopen | 0x45eec |
| SCPCarSplit | - | setSuppressReopen: | 0x45ef4 |
| SCPCarSplit | - | homeButton | 0x45efc |
| SCPCarSplit | - | setHomeButton: | 0x45f04 |
| SCPCarSplit | - | launcherHost | 0x45f34 |
| SCPCarSplit | - | setLauncherHost: | 0x45f4c |
| SCPCarSplit | - | dockTreeLogged | 0x45f58 |
| SCPCarSplit | - | setDockTreeLogged: | 0x45f60 |
| SCPCarSplit | - | launcherWhere | 0x45f68 |
| SCPCarSplit | - | setLauncherWhere: | 0x45f70 |
| SCPCarSplit | - | homeInk | 0x45f78 |
| SCPCarSplit | - | setHomeInk: | 0x45f80 |
| SCPCarSplit | - | homeGlyph | 0x45fb0 |
| SCPCarSplit | - | setHomeGlyph: | 0x45fbc |
| SCPCarSplit | - | launcherBare | 0x45fc8 |
| SCPCarSplit | - | setLauncherBare: | 0x45fd0 |
| SCPCarSplit | - | lastLauncherCalc | 0x45fd8 |
| SCPCarSplit | - | setLastLauncherCalc: | 0x45fe0 |
| SCPCarSplit | - | lastIconScan | 0x45fe8 |
| SCPCarSplit | - | setLastIconScan: | 0x45ff0 |
| SCPCarSplit | - | autoLaunchDone | 0x45ff8 |
| SCPCarSplit | - | setAutoLaunchDone: | 0x46000 |
| SCPPrefs | + | enabled | 0x4da2c |
| SCPPrefs | + | tipCount | 0x4da60 |
| SCPPrefs | + | setTipCount: | 0x4db2c |
| SCPPrefs | + | english | 0x4dc00 |
| SCPPrefs | + | lastLeftApp | 0x4dd78 |
| SCPPrefs | + | lastRightApp | 0x4dd84 |
| SCPPrefs | + | autoLaunch | 0x4dd90 |
| SCPPrefs | + | showRecent | 0x4ddf8 |
| SCPPrefs | + | showFavorites | 0x4de60 |
| SCPPrefs | + | paneOrientation | 0x4dec8 |
| SCPPrefs | + | splitRatio | 0x4df3c |
| SCPPrefs | + | splitDirection | 0x4dfc4 |
| SCPPrefs | + | carPlayApps | 0x4e02c |
| SCPPrefs | + | setCarPlayApps: | 0x4e0a4 |
| SCPPrefs | + | favorite: | 0x4e138 |
| SCPPrefs | + | recentLayouts | 0x4e504 |
| SCPPrefs | + | addRecentLayout:apps: | 0x4e750 |
| SCPPrefs | + | ratioForPairLeft:right: | 0x4eb34 |
| SCPPrefs | + | setRatio:forPairLeft:right: | 0x4ecc4 |
| SCPPrefs | + | setSplitRatio: | 0x4ee4c |
| SCPPrefs | + | setLastPairLeft:right: | 0x4eea4 |
Plus the C-level functions (all in disasm/): initializers __init_0 0x44a8,
__init_1 0x58b4, __init_2 0x843c, __init_3 0x52048 (FULL); hook replacements
0x4af0, 0x4bcc, 0x4c70, 0x4cb4, 0x4d24, 0x4d90, 0x4dfc, 0x4f30 (home group,
SEQ), 0x5cf0, 0x601c, 0x611c, 0x61d0, 0x636c, 0x66dc, 0x68e8, 0x6988,
0x69fc, 0x6b44, 0x6c78 (dashboard group, FULL/SEQ as noted in SCPHooks.m),
0x6e10 (addElement: dedupe, SEQ), 0x8540 (SpringBoard, FULL); blocks
0x54bc (prefschanged, FULL), 0x7434/0x76a0/0x77c8/0x78b4/0x7a4c/0x7b00
(appbridge handlers, SEQ), 0x7bec (native command, FULL), 0x828c/0x834c
(root-appear, FULL), 0x874c/0x875c/0x89d0/0x8f6c (SpringBoard blocks, FULL),
0x52118 (diag block, FULL); helpers 0x52e8, 0x75cc, 0x88d0, 0x101bc, 0xe324,
0x12efc, 0x12658, 0x162ac, 0x14fa4 (FULL), 0x1ab70/0x1b13c
(NOT-RECOVERED/INFERRED — see §5).

## Phase-2 seam fix (post-integration, coordinator-assigned)

Resolves BLOCKER-SPLIT-SEAM from `project/BUILD_PHASE1_LOG.md`. Ruling
applied: on spellings SplitScreen-C wins (its names match the binary
symtab `_SCP*` = single-underscore Mach-O symbol; the C identifier has
no leading underscore). All evidence below is from the calibrated dumps
(`src/SplitScreenA/disasm/`, `src/SplitScreenC/disasm/`) and
`metadata/xref/OmniCarSplitScreen.json`. Edits are in `src/` only;
`project/` picks them up at the next integration sync.

### 1. Underscore renames (13 identifiers, SCPShared.h + all call sites)
`_SCPChosenPhoneApps`→`SCPChosenPhoneApps`, `_SCPIsInjectedPhoneApp`→
`SCPIsInjectedPhoneApp`, `_SCPAppIconsBeginInjection`→
`SCPAppIconsBeginInjection`, `_SCPAddChosenAppsToLibrary`→
`SCPAddChosenAppsToLibrary`, `_SCPInjectDeclarationIfChosen`→
`SCPInjectDeclarationIfChosen`, `_SCPSetHomeViewController`→
`SCPSetHomeViewController`, `_SCPHomeSetVisible`→`SCPHomeSetVisible`,
`_SCPHomeRefresh`→`SCPHomeRefresh`, `_SCPRefreshAppIconsSoon`→
`SCPRefreshAppIconsSoon`, `_SCPRefreshHiddenAppsSoon`→
`SCPRefreshHiddenAppsSoon`, `_SCPAppIconsCarScreenOK`→
`SCPAppIconsCarScreenOK`, `_SCPDumpAppLibraryOnce`→`SCPDumpAppLibraryOnce`,
`_SCPRealBundleForInfos`→`SCPRealBundleForInfos` (7 call sites in
SCPCarSplit.m, 1 in SCPHooks.m). The log named 8; the sweep found 13 —
the extra 5 (IsInjectedPhoneApp, InjectDeclarationIfChosen,
SetHomeViewController, HomeRefresh, RealBundleForInfos) had the same
defect. (Disassembly dumps keep the old spellings: they are evidence
artifacts, not source.)

### 2. Signature conflicts — adjudicated from the instruction streams
(a) **SCPAppIconsBeginInjection (0xc37c) returns BOOL — C wins.** A
declared `void`. Proof: the caller in `+newApplicationLibrary` (sub_4af0)
does `bl 0xc37c; mov x21, x0; cbz w21, #0x4b58` (0x4b30–0x4b40) and only
then calls AddChosenAppsToLibrary — the BOOL is the crash-guard attempt
verdict, used as a gate. Fixed: declaration in SCPShared.h and the call
site in SCPHooks.m (`if (SCPAppIconsBeginInjection()) ...`).
(b) **SCPHomeSetVisible (0x4b4bc) takes ONE argument, `BOOL` — C wins.**
A's `(id vc, BOOL visible)` was self-labelled INFERRED. Proof: both call
sites set only w0 — sub_4d24 `mov w0, #1; bl 0x4b4bc`, sub_4d90
`mov w0, #0; bl 0x4b4bc` — and the body uses the flag to pick the
shown/hidden Darwin pair and never touches x1 (its first ObjC send's
receiver is the constant `@"SCPHomeSetVisible"` where-string). Fixed:
declaration + both SCPHooks.m call sites.
(c) Two further conflicts found during adjudication, also C wins:
**SCPChosenPhoneApps (0x9a60) returns `NSSet<NSString *>*`** (body builds
`[NSSet setWithArray:]`; A declared `NSArray *`) and
**SCPAppIconsCarScreenOK (0xc570) returns void** (the body never sets
w0; the real call site, block sub_828c, calls publishCarPlayApps and
carScreenAppeared UNCONDITIONALLY and CarScreenOK LAST at 0x82dc — A
had invented an `if (CarScreenOK)` gate in Hook_RootVC_viewDidAppear;
the hook body and its comment were restructured to the binary order).
Remaining family signatures (IsInjectedPhoneApp, AddChosenAppsToLibrary,
InjectDeclarationIfChosen, SetHomeViewController, HomeRefresh) matched
on both sides.

### 3. Installer ↔ body alignment (SCPHooks.m ↔ SplitScreen-C)
- Hook bodies: A's externs `SCPHook_Grid_iconImageInfo`,
  `SCPHook_Grid_portraitColumns/Rows`, `SCPHook_Grid_landscapeColumns/Rows`,
  `SCPHook_IconView_setLabelHidden`, `SCPHook_IconModel_isIconVisible`,
  `SCPHook_IconView_maxLabelSize` existed nowhere. They now name C's real
  bodies: `SCPHook_IconImageInfo` (0x5104), `SCPHook_PortraitColumns`
  (0x51a0), `SCPHook_PortraitRows` (0x51d8), `SCPHook_LandscapeColumns`
  (0x5210), `SCPHook_LandscapeRows` (0x5248), `SCPHook_SetLabelHidden`
  (0x5280), `SCPHook_IsIconVisible` (0x5338), `SCPHook_MaxLabelSize`
  (0x5438). In C's SCPHomeHooks.m the 8 bodies and their 8 Orig-IMP
  slots dropped `static` (extern linkage, matching the binary's single
  slot set); the internal helper SCPGridDimension stays static.
- Orig-IMP slots unified to C's typed set (OrigIconImageInfo …
  OrigMaxLabelSize, slots 0x87ff0–0x88028): A's installer rows write
  them; A's own 8 `void *` definitions (SCPHooks.m) and their SCPHooks.h
  externs were deleted (nothing else referenced them).
- **SCPHomeKick removed (6 sites).** Sub_5520 is called ONLY from the
  @catch landing pads of sub_4af0/4bcc/4cb4/4d24/4d90/54bc, always with
  (where-string, exception) — it is C's proven `SCPLogException`
  logger; no unconditional zero-arg call exists anywhere. Per site:
  newApplicationLibrary / loadFromProxy / viewDidAppear /
  viewDidDisappear / SCPHandlePrefsChanged — kick lines deleted (catch
  behaviour noted in comments); viewDidLayoutSubviews — the binary's
  real second call is `SCPHomeApply(self)` (0x4a6d8, bl at 0x4cd4), now
  called, with the declaration added to SCPShared.h.
- **SCPSyntheticLaunchInfo removed (2 sites) — phantom.** sub_4dfc at
  0x4e88–0x4e94: injected path sets x20 = 0 → returns nil. sub_4f30 at
  0x4fd8–0x4ff8: injected path calls
  `[[SCPCarSplit shared] launchPhoneAppIfNeeded:bundleID]` (x21 is the
  bundle-id string) then returns nil. Both hooks rewritten accordingly.
- **SCPMissingSelector adjudicated: `(id obj, NSString *selectorName)` —
  C's SCPHomeCommon.h wins; A's `(id, SEL)` was wrong.** Proof: call
  site sub_4dfc at 0x4e68–0x4e74 loads the `@"bundleIdentifier"` cfstring
  into x1. (Distinct from the shared core's 3-arg
  `OMCMissingSelector(tag, object, selectorName)`; SplitScreen's
  embedded copy is the 2-arg variant.) Declaration fixed in SCPShared.h;
  all 14 A call sites converted (NSStringFromSelector wraps; the two
  guarded-send helpers pass their existing selName NSString).
- **SCPExceptionLog receiver fixed** (same family): sub_75cc at
  0x75f8–0x75fc sends `callStackSymbols` to x19 = x1 = the exception,
  not to NSThread. (0x5520 and 0x75cc are instruction-identical twin
  logger bodies; both names legitimately coexist.)
- **SCPIconModelClass (sub_52e8) is still OWNERLESS**: A's installer
  declares it extern and C's notes corroborate the function, but no
  module defines it. Left declared; flagged here for the coordinator —
  NOT authored in this pass.

### 4. Syntax verification
`clang-18 -fsyntax-only -target arm64-apple-ios15.0` vs the iPhoneOS16.5
SDK: SCPShared.m (+SCPShared.h) fully clean; SCPHooks.m / SCPCarSplit.m /
SCPSpringBoardHooks.m / SCPHomeHooks.m parse end-to-end with only
pre-existing standalone-environment errors (NSDistributedNotificationCenter
not surfaced by this SDK invocation, forward-class property access,
the private SBIconImageInfo struct type absent from SDK headers — the
identical errors occur on the pre-edit files). Definitive proof is the
phase-2 integration build.

## Closure note — SCPIconModelClass (sub_52e8) now DEFINED (coordinator-assigned)

Verdict: **CLOSED — VERIFIED.** The ownerless function flagged in §3
above is now defined in SCPHooks.m (file scope, immediately before the
Installers pragma — the same file that carried the extern declaration
inside SCPInitHomeHooks; the stale "still ownerless" comment at the
declaration site was corrected).

Evidence (closure pass's own disassembly of OmniCarSplitScreen.dylib
arm64, capstone 5.0.7, every name resolved through
verify/macho_truth.py; A's disasm/sub_52e8.txt agrees instruction for
instruction): the 80-byte body at 0x52e8–0x5338 is exactly:

  cls = OMCCarClass("DBIconModel")          ; bl 0x502fc (_OMCCarClass)
  if (!cls) cls = objc_getClass("SBHIconModel")
  if (!cls) cls = objc_getClass("SBIconModel")
  return cls;                                ; via objc_retain +
                                             ; objc_autoreleaseReturnValue

Two details worth recording: (1) the asymmetry is real — the
DashBoard-side candidate goes through OMCCarClass (the car-context
resolver, 0x502fc, declared SCPShared.h:51), the two SpringBoard-side
fallbacks through plain objc_getClass; (2) callers confirmed by a
whole-__text branch scan: exactly two call sites, both in __init_0
(0x472c — the MSHookMessageEx install on -isIconVisible:; 0x479c —
the class_getName() entry in the OMCCheckHooks list), matching the
installer reconstruction.

Syntax check: clang-18 is absent from this VM right now (another
silent /usr rollback — /usr/bin/clang-18 and the dpkg entry are gone;
NOT restored in this pass, that is the integration build's toolchain
step). The verbatim body was extracted from the edited SCPHooks.m and
checked with the Swift-bundled clang-15:
`clang -fsyntax-only -target arm64-apple-ios15.0 -isysroot
iPhoneOS16.5.sdk -fobjc-arc` → 0 errors. A full-file SCPHooks.m check
in this standalone environment stops at substrate.h's
`CydiaSubstrate/CydiaSubstrate.h` include (the project supplies those
headers) before reaching any reconstructed code — same
standalone-environment class as §4; the clang-18 gate remains with
the phase-2 integration build.

Ownerless neighbours in the immediate call vicinity: **none.**
sub_52e8's only non-import callee is OMCCarClass (owned). The census
(FUNCTION_SOURCE_MAP.tsv) still lists heuristic UNCLAIMED rows for
this binary (synthesized accessors, .cxx_destruct, block thunks at
0x4000–0x40c0) — none is in sub_52e8's call graph; not examined here.

---

## Final closure addendum — phase-2 gaps items 1, 2, 3, 11, 12 + item 6 (favorites reader)

All bodies below were line-read from OmniCarSplitScreen.dylib (arm64)
with tools/disasm.py (capstone 5.0.7); data objects decoded with
verify/macho_truth.py. New dumps saved in src/SplitScreenA/disasm/:
sub_1ab70.txt, sub_1e33c.txt, sub_1ea0c.txt, sub_1ebb4.txt,
sub_1ee70.txt, sub_8350.txt, sub_3a86c.txt, sub_3aa60.txt,
sub_43720.txt, sub_43cdc.txt (sub_d324.txt already in
src/SplitScreenC/disasm/). Syntax: clang-18 -fsyntax-only, target
arm64-apple-ios15.0, iPhoneOS16.5 SDK, project-equivalent flags
(-include SCPIntegrationShims.h) — SCPShared.m, SCPHooks.m,
SCPDiagDump.m clean; SCPCarSplit.m 0 errors once B's
SCPCarSplitView.h interface is visible (its 18 standalone errors are
all the pre-existing forward-class arrangement, none in edited
regions; the one warning, line 919 `[self paneForBundle:nil]`, is
pre-existing code outside this closure).

### Item 1 — SCPSceneOfVC (sub_1ab70, 488 B): CLOSED, VERIFIED
The module's oldest stub was not an ivar walk. The VC is KVC-probed
with the constant key array @[@"scene", @"_scene"] (NSConstantArray
@__DATA 0x80530; buffer @0x80048 decoded element-wise: "scene" len 5,
"_scene" len 6); first non-nil valueForKey: wins. Fallback:
valueForKey:@"sceneHandle", then the handle's valueForKey:@"scene".
LSDA pads @0x1ac2c (in-loop catch: swallow, next key) and @0x1ad00
(fallback catch: return nil) pin the exception discipline written in
the source. SCPShared.m body replaced; SCPShared.h comment upgraded
INFERRED -> VERIFIED; stale "STUB-UNRECOVERED path" wording at the
SCPCarSplit.m call site removed.

### Item 2 — sub_d324 (SCPDiagWalkIcons): CLOSED, VERIFIED
True signature returns id (the stub's void was wrong). Body @0xd324:
nil/depth guards (depth > 14, cmp #0xe); class-name suffix
"IconListView" branch resolves model -> folder -> lists via
SCPHomeSafeGet (sub_a26c); non-empty NSArray lists -> icons of
lists.firstObject, else the model's own "icons"; non-empty icons ->
SCPDiagDescribe(@"icon list view", node) + (@"icon model", model) and
return icons.firstObject; otherwise falls through to subview recursion
(depth + 1, first non-nil wins). ALSO FIXED: the caller tail in
SCPDumpAppLibraryOnce (sub_c624) — the binary enumerates
connectedScenes, skips non-UIWindowScene scenes, walks each scene's
WINDOWS (msgSend windows @0xca18), stops both loops at the first icon,
then describes @"icon man chinh", @"icon.application"
(SCPHomeSafeGet(icon, @"application")) and @"dashboard"
(SCPHomeSafeGet(sharedApplication, @"_currentDashboard") @0xcb3c). The
old tail looped the walker over the scenes and discarded the result.
SCPDiagDump.m updated (walker + tail).

### Item 3 — soloBundle: (IMP 0x1e33c, 1,744 B): CLOSED, VERIFIED
TRUE ABI: - (void)soloBundle:(NSString *)bundleID. A's
(NSString *)soloBundle:(BOOL) body and B's header guess
(NSString *(SCPCarPane *)) were both wrong; both headers + A's body
corrected. Flow: inactive -> return; nil bundle -> closeGoingHome:YES,
return; SCPIsHostedApp (sub_101bc) -> log "chi giu %@ (app iPhone) ->
App Bridge toan man", hostSolo:, ignoreHomeOnce YES/closeGoingHome:YES/
ignoreHomeOnce NO sandwich; else log "chi giu %@ -> mo toan man", scan
allPanes for the LAST pane whose vc is non-nil, whose bundleID matches
and whose vc is not SCPVCIsHosted (sub_14fa4) — if vc + dashboard root
VC (sub_12658) + respondsToSelector presentBaseViewController:
animated:launchSource:completion: (selref string @0x7bb00): clear the
pane's vc/bundleID, detachVC:vc background:NO, closeGoingHome:NO,
present (animated YES), soloReturnedVC = vc, log "tra %@ cho DashBoard
trinh bay toan man", SCPDispatchAfter (sub_12efc) 0.15 -> block
sub_1ea0c (foregroundSceneWithSettings:nil completion:^{} via
NSSelectorFromString inside @try; log "scene %@ -> toan man %@" with
NSStringFromCGSize, catch logs "foregroundScene toan man loi %@") and
0.6 -> block sub_1ebb4 (catch-all swallow: guarded sceneHostView via
sub_4f330/SCPMissingSelector 2-arg form; stretch hostView.frame to
vc.view.bounds when hosted directly and frame differs, log
"sceneHostView %@ -> %@ (toan man)"). Fallback (no live pane): info =
SCPApplicationInfoForBundle (sub_e324); launchInfo = OMCCarLaunchInfo
(sub_50d14 — takes the INFO OBJECT, despite SCPShared.h's loose
NSString* spelling); if launchInfo: showSoloCoverForBundle:, then
closeGoingHome:YES always, then 0.8 -> block sub_1ee70 (weak self;
no-op when self gone or split active again; log "mo lai %@ toan man
(dashboard=%d, info=%d)"; dashboard -_launchAppWithInfo:forURL: when
info + dashboard + DBDashboard class + respondsTo all hold, else
SCPSendDashboardEvent(4, launchInfo) — sub_162ac, type 4 = launch);
if no launchInfo: toast with OMCTr format — VI string @0x7bba0
decoded UTF-16LE (flags 0x7d0, len 20) = "Không mở lại được %@",
EN "Couldn't reopen %@", argument [self displayNameFor:bundleID].
Note: block sub_1ee70 double-probes the launch selector and would log
SCPMissingSelector only in the unreachable second-probe race; the
source uses the single probe (behaviourally identical) and says so.

### Item 11 — hostPassInsetsForPane: (IMP 0x3d1e4, 440 B): B WINS
ADJUDICATED: returns UIEdgeInsets. Evidence: no x8/sret traffic, no
object creation; four doubles returned in v0-v3. A's NSDictionary*
declaration (SCPCarSplit.h) and placeholder body replaced; B's header
declaration was already correct. Body: frame = pane.view.frame, host =
pane.view.superview.bounds (view fetched twice, as written); top =
minY > 1 ? 10 : 0; left = minX > 1 ? 10 : 0; bottom = maxY <
host.height - 1 ? 10 : 0; right = maxX < host.width - 1 ? 10 : 0
(register return order v10/v9/v8/v11 = top/left/bottom/right). NOT
changed (flagged only): A's hostFrameInfo:pane:live:handle:
composition is still INFERRED and does not yet embed these insets,
though the binary caller (call site @0x3d414) consumes them — a
separate composition item, outside this closure's scope.

### Item 12 — SCPLayoutElementKey (sub_8350, 236 B) + dedupe: CLOSED, VERIFIED
Predicate body: respondsToSelector(identifier) -> identifier ->
isKindOfClass NSString -> isEqualToString:candidate. The dedupe logic
lives in the CALLER, the -[FBSDisplayLayoutPublisher addElement:]
hook sub_6e10 — line-read end to end; A's model (process-wide static
NSMutableSet fed by a key-returning helper) is REFUTED: the binary
keeps NO persistent set. Real logic, now in SCPHooks.m: key =
element.identifier when it is an NSString; the hook scans the
PUBLISHER's own storage on every call — superclass chain of [self
class] stopping before NSObject, every '@'-typed ivar read off self
via object_getIvar; per stored object: NSDictionary/NSMapTable ->
objectForKey: hit = duplicate, miss -> keyEnumerator deep scan
(NSString keys: hasSuffix @":" + key; non-string keys: predicate on
the key object, then on its stored value); other NSFastEnumeration
conformers (protocol resolved @0x87668 = NSFastEnumeration) that are
not NSString -> predicate over elements. Duplicate -> log "CarSplit:
bo khai bao trung %@ (tranh assert cua iOS 15)" and return
[SCPNoopLayoutAssertion new] WITHOUT calling the original; otherwise
forward to the original and return ITS result (A's hook also had the
wrong void signature — fixed to id). The scan is factored into a
static helper SCPLayoutIdentifierAlreadyDeclared in source (inline in
the binary); SCPHooks.m gained #import "SCPSmallClasses.h" and
<objc/runtime.h>. No branch remains indeterminable.

### Item 6 — SCPCarSplit favorite reader divergence: CLOSED, VERIFIED
Prefs closure proved +[SCPPrefs favorite:] returns {name, left?,
right?, third?, layout} with NO @"apps" key (see
src/Prefs/PrefsB_REPORT.md addendum; SCPPrefs.m already rewritten
there). Reader side verified against my own dumps:
- -favoriteApps: (IMP 0x3a86c, type @24@0:8@16 — object in, object
  out): nil dict -> nil; box count from dict[@"layout"] intValue —
  csel chain @0x3a8c8-0x3a8e4: (layout & ~1) == 2 -> layout else 2,
  overridden to 3 when layout == 31 or layout == 13 (net: 3 for
  13/31 and for 3, 2 for 2, else 2); slot keys = constant array
  @__DATA 0x80518 decoded = [@"left", @"right", @"third"]; a value
  passing -isCarPlayApp: (IMP 0xff20) is kept, anything else pads
  [NSNull null]; nil when none passed.
- -openFavorite: (IMP 0x3aa60): fav = [SCPPrefs favorite:index];
  apps = [self favoriteApps:fav]; UNCONDITIONAL log "CarSplit: bo cuc
  yeu thich %ld: %@" (index, fav); if apps: openSetupLayout:
  [fav[@"layout"] intValue] apps:apps. Never reads @"apps".
- -openRememberedPairForConnect (IMP 0x43720): A's body diverged in
  five places, all corrected — validity is entry[@"apps"].count > 1
  (cmp #1, cset hi) with a per-element NSString class check
  (objc_opt_isKindOfClass) AND isCarPlayApp:, first qualifying entry
  wins; fallback is favorite:1 (mov w2, #1 @0x43938) via favoriteApps:
  with layout intValue and the 0 -> 2 default (this path only); the
  chosen list is REBUILT into a fresh NSMutableArray substituting
  NSNull for non-NSString elements; fullscreen merge: full replaces
  slot 0 only when absent from the list AND the list is non-empty
  (no addObject-on-empty in the binary); the log's second %@ is the
  app ARRAY itself (no componentsJoinedByString: in the IMP) and the
  third is (fullscreenAppBundle ?: @"-").
- -openRememberedPair (IMP 0x43cdc): same validity scan (A took
  firstObject — wrong); a valid recent opens with its own apps array
  verbatim after logging the entry; fallback favorite:1 via
  favoriteApps:, the "-> Bo cuc yeu thich 1" log fires only when apps
  is non-nil, layout = raw intValue (NO 0 -> 2 default here).
B's SCPCarSplit+Panel.m already called [self favoriteApps:fav] with
the dictionary (i = 1..3 loop) — left as-is; it now type-checks
against A's corrected declaration.

### Src changes in this closure (project sync is a separate step)
- src/SplitScreenA/SCPShared.m — SCPSceneOfVC body (item 1).
- src/SplitScreenA/SCPShared.h — sub_1ab70 comment -> VERIFIED.
- src/SplitScreenC/SCPDiagDump.m — walker body + signature, caller
  tail (item 2).
- src/SplitScreenA/SCPCarSplit.h — favoriteApps:, hostPassInsetsForPane:,
  soloBundle: declarations (items 3, 4, 6).
- src/SplitScreenB/SCPCarSplit.h — soloBundle: declaration (item 3).
- src/SplitScreenA/SCPCarSplit.m — openRememberedPairForConnect,
  openRememberedPair, openFavorite:, favoriteApps: (item 6);
  hostPassInsetsForPane: body (item 4); soloBundle: body (item 3);
  stale stub wording at sceneOfViewController: (item 1).
- src/SplitScreenA/SCPHooks.m — SCPLayoutElementKey predicate,
  SCPLayoutIdentifierAlreadyDeclared scan, Hook_addElement rewrite,
  2 imports (item 5).
- src/SplitScreenA/disasm/ — 10 new dumps (listed above).

### Still open (outside this closure, unchanged)
- A's hostFrameInfo:pane:live:handle: composition remains INFERRED
  and does not embed the item-11 insets (see above).
- B's SCPCarSplit.h lines 237-242 malformed QA20-era declarations
  (pre-existing; removal is integration-owned per phase 2) — they
  block a standalone syntax check of B TUs against the src B header;
  B's soloBundle: line itself is byte-identical in form to A's, which
  compiles clean.
- SCPSceneIdentifierOfVC (sub_1b13c) remains INFERRED (not in scope).

## Micro-closure addendum — last SplitScreen INFERRED items

### Item 1 — SCPSceneIdentifierOfVC (sub_1b13c): CLOSED, VERIFIED
Line-read sub_1b13c end to end (252 B, 0x1b13c–0x1b238; new dump
`src/SplitScreenA/disasm/sub_1b13c.txt`). The historical name is
misleading: the binary's only direct call sites are in
`-[SCPCarSplit scene:destroyedForViewController:ownScene:]` at
0x1ae4c and 0x1ae64, and they pass the destroyed scene and the
ownScene object respectively — never a VC and never the result of
SCPSceneOfVC. The IMP is a direct double-probe of the argument's
`identifier` selector: the first `objc_opt_respondsToSelector` miss
(@0x1b154–0x1b16c) returns nil silently; inside the exception-guarded
second probe (@0x1b178–0x1b1a0), a miss calls
`SCPMissingSelector(scene, @"identifier")` (@0x1b1b4–0x1b1c0), while a
hit sends `-identifier` and returns the resulting object unchanged.
There is no string conversion, no `scene`/`_scene` KVC walk, and no
sceneHandle fallback. SCPShared.h/.m now state and implement that
semantics (parameter renamed to `scene`), and the sole reconstructed
caller in SCPCarSplit.m now gates on `pane.vc == vc`, calls the helper
on `scene` and `ownScene`, and accepts either pointer equality
(`ownScene == scene`) or identifier equality — the match predicate at
0x1ae74–0x1ae94.

### Item 2 — hostFrameInfo:pane:live:handle: (IMP 0x3d39c): CLOSED, VERIFIED
Line-read the full IMP (dump
`disasm/-SCPCarSplit_hostFrameInfo_pane_live_handle_.txt`). The ObjC
type encoding settles the ABI:
`@64@0:8{CGRect={CGPoint=dd}{CGSize=dd}}16@48B56B60`. The first
argument is therefore the CGRect passed by
`-sendHostFrameForPane:live:` (@0x3e05c–0x3e184, the frame returned by
`-hostFrameForPane:`), not a bundle ID and not `pane.hostFrame`. The
caller derives `handle` as `!CGRectIsEmpty(frame)` (@0x3e06c and
@0x3e164); inside hostFrameInfo: that BOOL is only copied to the
`handle` key and does not alter geometry.
Composition now reconstructed in SCPCarSplit.m: the IMP calls
`-hostPassInsetsForPane:` before building the base dictionary
(@0x3d40c–0x3d424; nil pane substitutes UIEdgeInsetsZero
@0x3d42c–0x3d438) and embeds the insets as `pt`/`pl`/`pb`/`pr`.
The 11-key base is identifier (from `pane.bundleID`, nil -> @"",
@0x3d44c–0x3d470), x/y/w/h from the argument frame, live, handle, and
the four inset values. A nil pane returns only that base. For a
non-nil pane (@0x3d69c onward), it merges `-hostBarInfoForPane:`,
adds `r` = pane.view.layer.cornerRadius, `corners` =
pane.view.layer.maskedCorners as unsigned long long, `hx` =
`-handleShiftForPane:`, `front` = (pane == `-floatPane`), and
`ox`/`oy`/`ow`/`oh` from `-holeForPane:`. Only when `-tabParent` is
non-nil does it add `ax`/`ay`/`aw`/`ah`, from
`[tabParent convertRect:[self appAreaInParent:tabParent] toView:nil]`
(@0x3d918–0x3da1c). SCPCarSplit.h's signature is corrected to
`(CGRect)`, the caller passes the computed frame, and the A header
now declares the binary's double-returning handleShiftForPane:.

### Item 3 — B header declarations: EDIT DONE AS TASKED; ABSENCE PREMISE REFUTED
The four malformed declarations were removed from
`src/SplitScreenB/SCPCarSplit.h`; a grep of that header now returns
no matches for `dividerDoubleTapped:`, `dividerDoubleTapOn:`,
`dividerTapped:`, or `dividerTapOn:at:`. However, the brief's stated
reason — that these selectors are absent from 1.0.3 and unreferenced
in src — is contradicted by direct evidence, so this item is NOT
evidence-closed as framed. The arm64 ObjC method list for
SCPCarSplit contains all four: dividerDoubleTapped: @0x2e6e8,
dividerDoubleTapOn: @0x2e73c, dividerTapped: @0x2eb64, and
dividerTapOn:at: @0x2ebf0. A grep over src code (`.h`/`.m`) still
finds their implementations in `src/SplitScreenB/SCPCarSplit+Divider.m`
and `@selector(dividerDoubleTapped:)` / `@selector(dividerTapped:)`
in `src/SplitScreenB/SCPCarSplit+Layout.m`. No evidence is missing;
the available evidence proves the selectors exist in the 1.0.3
binary and are referenced by src. The coordinator should therefore
treat the header removal as a mechanical alignment with the phase-2
project copy, not as a verified absence finding.

### Syntax checks (micro-closure)
- `src/SplitScreenA/SCPShared.m`: clang-18 `-fsyntax-only`
  (arm64-apple-ios15.0, iPhoneOS16.5 SDK, ARC + blocks) — PASS,
  0 diagnostics.
- `src/SplitScreenA/SCPCarSplit.m`: same flags plus the project's
  SCPIntegrationShims.h force-include and B's SCPCarSplitView.h (the
  integration environment for this TU) — PASS; 1 pre-existing
  -Wnonnull warning at the keep-case log's `[self paneForBundle:nil]`
  line, unrelated to the edited regions.
- `src/SplitScreenB/SCPCarSplit.h`: a minimal import TU — PASS,
  0 diagnostics after the removal. A full standalone check of
  `src/SplitScreenB/SCPCarSplit+Divider.m` still does NOT pass for
  pre-existing reasons outside this item: the NSNumber-pointer
  arithmetic at line 32 (`@[ @1.0 / 3.0, … ]`) and cross-module
  declarations that the src B header does not supply standalone.
  Those failures are reported honestly rather than attributed to
  the header edit.
