# AppBridge B — Reconstruction Report

Binary: `OmniCarAppBridge.dylib` (fat 613,376 B; arm64 slice 285,488 B,
UUID `81EF5920-BB7A-37E8-B953-D88453F2EA89`; arm64e slice surface verified
identical). Filter: `com.apple.UIKit` — loads into every UIKit process.
8 classes / 193 methods; 383 functions in the arm64 slice (LC_FUNCTION_STARTS).
Method: python3 + capstone 5.0.7 with a purpose-built Mach-O harness
(`harness/macho.py`, `disasm.py`, `xref.py` — indirect-symbol (LC_DYSYMTAB)
resolution cross-checked against chained-fixup binds). Full annotated
disassembly: `disasm/full_arm64.txt` plus ~199 per-function dumps in
`disasm/`. Statuses used below: **V** = verified from machine code,
**I** = inferred (basis stated), **C** = condensed (structure verified,
cosmetic/branch detail left to the cited dump), **NR** = not recovered
(out of scope / other owner, stated).

---

## 1. Partition (B vs A)

**Module B (this deliverable)** — everything that happens INSIDE a hosted
app process, plus the host-side machinery that serves it:

- All C-function in-app machinery in every process: the three
  constructors, the lazy hook installer, all 13 in-app hooks, the
  orientation/key notification blocks, both Darwin-state publishers and
  the debounce, the CADisplayLink FPS hooks, mask/window helpers.
- SpringBoard-side endpoints of the in-app channels: registrar
  `sub_7004`, Darwin consumers `sub_92B4` (apporient) and `sub_93B0`
  (keyboard), the frame/shield NSDistributed consumer blocks, the four
  SpringBoard lifecycle hooks, C helpers `sub_E6B8` (orientation post)
  and `sub_BED4` (state post).
- Classes: ABPane (all 35 methods — accessors only, pure data holder),
  ABBoxView, ABShieldView, ABKnobView, ABBarButton (touch routing),
  ABKeyboard + ABKey (the whole keyboard channel endpoint), `ABTelexApply`.
- ABHost methods concerned with geometry/orientation/lifecycle/touch:
  `zoom`, `effectiveOrientation:`, `appWithHash:changedOrientation:supportedMask:`,
  `setFrame:forApp:live:handle:passInsets:`, `layoutPane:`, `nudgePane:`,
  `setHole:forApp:`, `setPassInsets:forApp:`, `setShieldAll:`,
  `setShield:forPane:`, `outsideTouched`, `handlePanned:`, `handleTapped:`,
  `sceneMonitor:sceneWasDestroyed:`, `carDisconnected`.

**Module A (not mine)**: ABHost catalog/picker/launch surface —
`openApp:frame:`, `setupLiveAppViewForPane:`, `ensureWindow`,
`teardownPane:`, `revealPane:`, bar construction and actions
(`buildBarForPane`, `layoutBarForPane:`, `hideBarForPane:`,
`postBarAction:from:`), `closeApp:terminate:`, `closeAllExcept:`,
`setKnobs:`, `setBarVisible:…`, `setFront:forApp:`,
`setCornerRadius:corners:forApp:`, `setHandleOffset:forApp:`,
`setCarAppArea:`, the open/close/closeall/knobs consumer blocks.

**Declared overlap**: B's consumer blocks call `shared`, `count`,
`hostsApp:`, `paneFor:`, `bundleForHash:` — I reconstructed those five
ABHost helpers in `ABHostBMethods.m` because B's code paths depend on
them; A owns everything launch/catalog/bar-facing. Constructor
`sub_20184` is the shared OMC scaffold ctor (all dylibs) — assigned to
the Core module, not reconstructed by B (see §9).

## 2. Process roles (all V)

| Ctor | Process | Behavior |
|---|---|---|
| `sub_44A8` | hosted apps | Bails unless bundleID non-empty, bundlePath contains `.app`, and bundleID ∉ exclusion array @0x393D8 (verbatim: `com.apple.springboard, com.apple.CarPlayApp, com.apple.CarPlayTemplateUIHost, com.apple.CarPlaySettings, com.apple.InCallService, com.apple.Preferences`). Registers NSDistributed observers with **object = own bundleID**: `appbridge.orientation` → block `sub_4728`, `appbridge.key` → block `sub_5908`. |
| `sub_6E08` | SpringBoard only | Logs "loaded into SpringBoard"; MSHookMessageEx ×4 (SpringBoard `applicationDidFinishLaunching:` → `sub_7004`; SBSuspendedUnderLockManager `_shouldBeBackgroundUnderLockForScene:withSettings:` → `sub_72BC`; FBScene `updateSettings:withTransitionContext:completion:` → `sub_74B4`; SBSceneView `_updateReferenceSize:andOrientation:` → `sub_7764`); `OMCCheckHooks` self-check; dlsym `BKSDisplayServicesSetScreenBlanked` → MSHookFunction → `sub_777C` (logs "khong tim thay…" if missing). Hook table independently confirmed by calibrated `HOOK_MAP.md` (18 MSHookMessageEx + 1 MSHookFunction sites, exact match). |
| `sub_20184` | all | Shared OMC scaffold ctor — Core module (NR for B). |

Registrar `sub_7004` (V): calls orig, logs "SpringBoard ready", registers
NSDistributed observers (object nil): open→`sub_783C` (A), frame→`sub_8274`,
shield→`sub_8C7C`, close→`sub_8DF0` (A), closeall→`sub_8FD4` (A),
knobs→`sub_9144` (A); `notify_register_dispatch`: apporient→`sub_92B4`,
keyboard→`sub_93B0`; local NSNotificationCenter `CarPlayIsConnectedDidChange`
→ `sub_958C`.

## 3. IPC channel map — payload formats PROVEN from producer+consumer code

### 3.1 Darwin notify state channels (packed uint64 — the wave-1 hypothesis, now verified bit-by-bit against THIS binary)

**`com.anlai.omnicar/appbridge.keyboard`** — producer `sub_6AD4` (in-app),
consumer `sub_93B0` (SpringBoard):
```
bit  0      keyboard shown
bits 1..7   UIKeyboardType        = (state >> 1)  & 0x7F
bits 8..15  UIReturnKeyType       = (state >> 8)  & 0xFF
bits 24..55 FNV-1a-32(bundleID)   = state >> 24   (ubfiz hash << 24)
bits 16..23, 56..63 = 0
```
Producer packs `shown | (kbType & 0x7F) << 1 | (retType & 0xFF) << 8 |
FNV1a32 << 24`; consumer resolves the app via
`[[ABHost shared] bundleForHash:(state >> 24)]`, then
`hideForApp:` (bit0=0) or `showForApp:keyboardType:returnType:` (bit0=1).
FNV-1a-32: offset `0x811C9DC5`, prime `0x01000193`, over bundleID UTF-8.
Publish triggers: `sub_6A70` (post-becomeFirstResponder) / `sub_6D50`
(post-resign), gated on `ABForcedOrientation >= 1`.

**`com.anlai.omnicar/appbridge.apporient`** — producer `sub_67FC` (in-app
dispatch block), consumer `sub_92B4`:
```
bits 0..7   orientation code (0xFF = "recompute from mask" sentinel)
bits 8..23  supportedInterfaceOrientations mask = (state >> 8) & 0xFFFF
bits 24..55 FNV-1a-32(bundleID) << 24
```
Consumer → `appWithHash:changedOrientation:supportedMask:`. Producer is
debounced by `sub_6750`: previous pending block cancelled, re-post after
**250,000,000 ns (0.25 s)**.

### 3.2 NSDistributedNotificationCenter channels (name `com.anlai.omnicar/appbridge.*`)

| Channel | Dir | Producer → consumer | Payload (all V) |
|---|---|---|---|
| orientation | host→app | `sub_E6B8` → block `sub_4728` | object = bundleID; `{orientation: @(ll), device: @(max(orientation,0)), fps: @(int)}`; fps: 0 if orientation < 1; else pref `appBridgeFps` (default @0); if ≤ 0 → 30 when `OMCLiteActive()`, else 30 when `OMCCarWireless()==1`, else 0 |
| key | host→app | `-[ABKeyboard send:del:text:]` → block `sub_5908` | object = bundleID; `{action, del: @(NSUInteger), text?}`; actions: `type` (deleteBackward × del, then insertText:), `return` (delegate-gated EditingDidEndOnExit for fields, else insert "\n"), `dismiss` (resign) |
| frame | car→host | external → block `sub_8274` | full geometry set: x/y/w/h + identifier + live/handle + pt/pl/pb/pr → `setFrame:…`; bar/pop/popDim/single → `setBarVisible:…`; ox/oy/ow/oh → `setHole:`; r/corners → `setCornerRadius:corners:`; hx → `setHandleOffset:`; front → `setFront:`; ax/ay/aw/ah → `setCarAppArea:` only if aw > 0 |
| shield | car→host | external → block `sub_8C7C` | `{on}` → `setShieldAll:` |
| open / close / closeall / knobs | car→host | external → blocks `sub_783C/8DF0/8FD4/9144` | module A handlers (registered in `sub_7004`, V) |
| state | host→car | `sub_BED4` → external (SplitScreen per calibrated IPC_MAP) | object nil; `{identifier, state}`; observed values at all 6 call sites: `"failed"`, `"ready"`, `"gone"` |
| knobtouch | host→car | `-[ABKnobView relay:touches:]` → external | object nil; `{index, phase, x, y}` (window coords) |
| handledrag / handletap | host→car | `-[ABHost handlePanned:]` / `handleTapped:` → external | `{identifier, phase, x, y}` / `{identifier}` |
| bardismiss | host→car | `-[ABShieldView touchesBegan:]` → external | object nil, empty userInfo; also fires local `outsideTouched` |
| baraction | host→car | `-[ABHost postBarAction:from:]` (A) | — |

Local: `CarPlayIsConnectedDidChange` (NSNotificationCenter) → block
`sub_958C`: on disconnect → `[[ABKeyboard shared] hideForApp:nil]` +
`[[ABHost shared] carDisconnected]`.

## 4. In-app machinery (all V unless noted)

- **Orientation block + lazy installer `sub_4728`** (609 lines): one-time
  (guard byte 0x3E938) install of 13 MSHookMessageEx hooks:
  CADisplayLink ×3 (FPS), UIWindow `_setRotatableViewOrientation:duration:force:`,
  UIDevice ×3 (`beginGenerating…`, `setOrientation:animated:`, `orientation`),
  UITextField/UITextView become/resign FirstResponder ×4, and — when
  `requestGeometryUpdateWithPreferences:errorHandler:` exists —
  UIWindowScene + UIViewController `setNeedsUpdateOfSupportedInterfaceOrientations`,
  else UIViewController `attemptRotationToDeviceOrientation` (metaclass).
  Per notification: forced orientation/device fake applied; first responder
  resigned on release (≤ 0); rotation enforced via
  `_setRotatableViewOrientation:(target, 0.0, YES)` unless the app's mask
  forbids it (log "bo qua ep xoay %d: app chi cho mask %lu"); FPS limit
  re-read and applied to tracked display links.
- **Globals**: `ABForcedOrientation` (0x3E7D0, init −1), `ABAppOrientation`
  (0x3E9C8; only 3/4/5 kept), `ABDeviceFake` (0x3E9D0), `ABFPSLimit`
  (0x3E9B0), weak current responder (0x3E930), pending publish block
  (0x3E9D8), notify tokens (0x3E9E0/0x3E9E8), blank-inputView marker
  associated-object key (0x3E9E4, value kCFBooleanTrue, ASSIGN).
- **Keyboard suppression `sub_698C`**: when hosted and the responder has
  `setInputView:` and `inputView == nil`, installs a blank
  `UIView(CGRectZero)` as inputView + marker. `sub_6D50` restores
  (`setInputView:nil`, marker cleared) on resign.
- **Orientation hooks**: `setOrientation:` records 3/4/5 into
  ABAppOrientation and schedules an apporient publish; `orientation`
  getter returns ABAppOrientation, else ABDeviceFake, else orig;
  scene `requestGeometryUpdate` derives orientation from the requested
  mask (rule: only when portrait bit 2 set — prefer mask&16 → 4, else
  mask&8 → 3, else (mask>>1)&2 → 2; else 0); VC hooks publish the 0xFF
  sentinel. Mask→orientation rule is byte-identical in-app and in
  `appWithHash:` host-side.
- **Mask helpers**: `sub_612C` (key window → VC-chain mask `sub_6498`,
  depth cap 12, landscape-capable visible VCs; fallback `sub_5EC0`;
  no window → **0x1E**), `sub_61D0` (first key, non-hidden window across
  connected scenes).
- **FPS hooks**: created links tracked in a weak NSHashTable (`sub_5C64`);
  `sub_5CBC` re-applies requested rate clamped to ABFPSLimit via the
  ORIGINAL setters.
- **Host lifecycle hooks**: `sub_72BC` — hosted app under lock: orig YES →
  NO (never background-under-lock). `sub_74B4` — FBScene settings update
  with `isForeground == NO` for a hosted scene is **swallowed** (orig
  never called; fail-open on exception): the hosted scene never learns
  it was backgrounded. `sub_7764` — reference orientation > 4 clamped to
  3. `sub_777C` — screen blanked=1 while apps hosted: orig(1) now +
  forced orig(0) after **1.0 s** (block `sub_9688`).

## 5. Geometry & the timing question (all V)

- **Zoom**: `zoom = MIN(MAX(pref("appBridgeZoom", @80)/100.0, 0.3), 1.0)`
  — default zoom **0.8** (see §7 for the @100→@80 correction).
- **`layoutPane:`** (the scene-layout core): appView.frame =
  `{0, 0, roundHalfAway(boxW/z), roundHalfAway(boxH/z)}`, transform =
  scale(z, z), center = box center; private chain
  `_deviceAppViewController → sceneView → _sceneContentContainerView`
  transform reset to identity; scene `updateSettingsWithBlock:` (block
  `sub_F210`): **settings.frame = {0,0,logicalSize} (transposed when
  effective orientation ∈ {3,4,5}), interfaceOrientation = effective,
  backgrounded = NO, foreground = YES** — this is the maintain mechanism.
- **`nudgePane:`**: scene frame first set to logical size with one
  component at MAX(1, size − 1.0) (the "−1 pt nudge"; axis mapping after
  transpose labelled I in source), then `layoutPane:` re-run after
  **0.05 s** (`dispatch_after` 50,000,000 ns).
- **`setFrame:…`**: collapsed when MIN(w,h) < 2 (box hidden, handle off);
  non-live frame changes animate over **0.25 s** (0 when old frame empty).
- **The "0.3 s deferred geometry" — VERDICT: PROVEN, with a correction.**
  The constant array @0x393F0 holds exactly three doubles, byte-verified
  in `__objc_doubleobj` @0x39570/0x39580/0x39590: **0.3, 1.5, 4.0**. On an
  orientation change with `ABDeviceFake >= 1`, the deferred fake-
  orientation event (`sub_6028`: re-posts
  `UIDeviceOrientationDidChangeNotification`, gated on mask & 0x2) is
  scheduled at **all three** delays — 0.3 s is only the first retry.
  Related proven delays: 0.25 s apporient debounce, 0.25 s frame-change
  animation, 0.05 s nudge follow-up, 1.0 s forced unblank, 0.2 s
  beginGenerating re-post (constant @0x2B1D8), keyboard animators
  0.35 s in / 0.25 s out.

## 6. Touch path (all V)

Host side (SpringBoard), decision order in
`-[ABBoxView pointInside:withEvent:]` (0x98A0): outside bounds → NO;
inside visible handle → YES; inside visible bar → YES; inside the hole
→ **NO** (touch falls through to the hosted scene — this is how pane
touches reach the app); else YES only within bounds shrunk by
passInsets. The hole is rendered via `applyHole` (0x9C10): CAShapeLayer
mask, even-odd fill, bounds rect + hole as rounded rect (radius 12).
`ABShieldView touchesBegan:` swallows the touch, posts bardismiss, calls
`outsideTouched`. `ABKnobView` touch methods are 12-byte thunks into
`relay:touches:` (phases 0–3; moved events throttled to ≥ 1.0 pt from
lastSent via hypot). `ABBarButton pointInside:` caps the hit area to a
centered 44×44 (inset MAX(0, (size−44)/2)).
Inside the app there is **no touch hook**: touches arrive through normal
scene delivery once the host's hit-testing lets them through; the only
in-app touch-adjacent machinery is the first-responder/key channel
(§3.1, §4).

## 7. Calibration corrections (coordinator broadcast + verifier adjudication)

Wave-1 metadata decoded chained-fixup ordinals off by one (verifier:
parser used `imports[ordinal-1]`). Cross-checks run for this binary:

1. **Superclasses — all 8 wave-1 values WRONG; corrected values are the
   declared ones in the final source** (re-decoded from each class
   struct's superclass bind slot; the decode scheme was validated
   180/180 against LC_DYSYMTAB on `__got` slots; verifier confirmed;
   full table in `metadata/ANNOTATION_AUDIT.md`):

   | Class | Wave-1 (artifact) | Corrected (proven) |
   |---|---|---|
   | ABPane | NSRunLoop | **NSObject** |
   | ABHost | NSRunLoop | **NSObject** |
   | ABKeyboard | NSRunLoop | **NSObject** |
   | ABBoxView | UIWindowScene | **UIView** |
   | ABShieldView | UIWindowScene | **UIView** |
   | ABKnobView | UIWindowScene | **UIView** |
   | ABBarButton | NSNull | **UIButton** |
   | ABKey | NSNull | **UIButton** |

2. **Import names in my disassembly: zero conflicts** with the calibrated
   xref (`metadata/xref/OmniCarAppBridge.json`): per-function import
   target sets agree wherever both resolve a site (the xref resolves
   additional tail-call sites my annotation pass didn't capture; no name
   differs). `HOOK_MAP.md` and `IPC_MAP.md` agree with §2/§3 exactly.
   Verifier sampled this module's data annotations 200/200 clean.
3. **`__objc_intobj` stride is 24 bytes** ({isa, flags, value}), not 16:
   the zoom default object @0x395A0 is **@80** (not @100 — an earlier
   draft of `ABHostBMethods.m` said @100; corrected; calibrated
   `PREFS_MAP.md` agrees @80), and the `appBridgeFps` default @0x395E8
   is **@0** (an earlier draft passed nil; corrected — behaviorally
   identical for `intValue`, now factually exact).
4. Class/ivar/method NAMES were never affected (they are cstring data
   reached by rebase, not ordinal binds) — verified: class_ro names
   match, ivar lists spot-checked against accessor offsets.

## 8. Per-function evidence / status table (module B scope)

Evidence files are in `disasm/` (prefixes: `sub_`/`blk_`/`hook_`/`f_` =
top-level dumps in `full_arm64.txt` set; `m_<Class>_<sel>.txt` = method
dumps; `ctor_*` = constructor dumps).

| Addr | Function | Evidence | Status |
|---|---|---|---|
| 0x44A8 | ctor (hosted-app role) | ctor_app_44a8.txt | V |
| 0x4728 | orientation block + hook installer | installer_app_4728.txt | V |
| 0x50A8/0x5144/0x5220 | CADisplayLink FPS hooks | hook_* dumps | V |
| 0x543C | UIWindow _setRotatable hook | hook dump | V (one flag-gated branch vestigial — flagged in source) |
| 0x54C8/0x5504/0x55D8 | UIDevice hooks ×3 | hook dumps | V |
| 0x560C/0x5658/0x5694/0x56F8 | UITextField/View FR hooks ×4 | hook dumps | V |
| 0x5734 | UIWindowScene requestGeometry hook | hook dump | V |
| 0x5888/0x58C0 | VC rotation hooks ×2 | hook dumps | V |
| 0x5908 | key receiver block | key_block_5908.txt | V |
| 0x5C64/0x5CBC | link tracking / FPS clamp | full_arm64.txt | V |
| 0x5EC0/0x612C/0x61D0/0x6498 | mask & window helpers | mask_612c.txt, sub_*.txt | V (sub_6498 tail follows its verified head pattern — noted in source) |
| 0x5FF0/0x6028 | deferred fake-orientation event | blk_deferred_6028.txt | V (delays @[0.3, 1.5, 4.0] byte-verified) |
| 0x6750/0x67FC | apporient debounce + publisher | apporient_publish_67fc.txt, sub_6750.txt | V (packed format §3.1) |
| 0x698C/0x6A70/0x6D50 | keyboard suppression + FR posts | helper_698c.txt, helper_6a70.txt | V |
| 0x6AD4 | keyboard state publisher | kb_publish_6ad4.txt | V (packed format §3.1) |
| 0x6E08 | ctor (SpringBoard role) | ctor_host_6e08.txt | V |
| 0x7004 | registrar | registrar_7004.txt | V |
| 0x72BC/0x74B4/0x7764/0x777C (+0x9688) | host lifecycle hooks ×4 + unblank block | hook dumps, blk_9688.txt | V |
| 0x783C/0x8DF0/0x8FD4/0x9144 | open/close/closeall/knobs blocks | blk_*.txt | A (registered in B's registrar; bodies = A) |
| 0x8274/0x8C7C | frame / shield consumer blocks | blk_frame_8274.txt, blk_shield_8c7c.txt | V |
| 0x92B4/0x93B0 | apporient / keyboard Darwin consumers | blk_apporient_92b4.txt, blk_keyboard_93b0.txt | V |
| 0x958C | CarPlay connect/disconnect block | blk_carplay_958c.txt | V (disconnect path; connected-case tail C — dump preserved) |
| 0xBED4/0xE6B8 | state / orientation post helpers | sub_bed4_state.txt, sub_e6b8_orientation.txt | V |
| 0x17538 | ABTelexApply | f_ABTelexApply.txt | V tables + entry; C per-key branch fidelity (§9) |
| 0x17ECC | Telex vowel classifier | full_arm64.txt | V |
| ABPane | 35 methods (17 ivars) | m_ABPane_*.txt | V (synthesized accessors; frame/sceneBox spot-verified as raw ivar load/store) |
| ABBoxView | pointInside/applyHole/setHole:/layoutSubviews + accessors | m_ABBoxView_*.txt | V (accessors synthesized) |
| ABShieldView | touchesBegan: | m_ABShieldView_*.txt | V |
| ABKnobView | relay:touches: + 4 touch thunks + accessors | m_ABKnobView_*.txt | V |
| ABBarButton | pointInside: / setHighlighted: | m_ABBarButton_*.txt | V (setHighlighted: visual-only) |
| ABHost (B set) | shared/count/hostsApp:/paneFor:/bundleForHash: | m_ABHost_*.txt | V (overlap declared §1) |
| ABHost (B set) | zoom / effectiveOrientation: / appWithHash: / setFrame: / layoutPane: / nudgePane: / setHole: / setPassInsets: / setShieldAll: / setShield:forPane: / outsideTouched / handlePanned: / handleTapped: / sceneMonitor:sceneWasDestroyed: / carDisconnected | m_ABHost_*.txt, blk_layoutPane_settings_f210.txt, blk_nudge1_fd98.txt, blk_nudge2_fdf8.txt | V (nudge axis mapping after transpose: I) |
| ABKeyboard | shared / showForApp: / hideForApp: / send:del:text: / typeCharacter: / keyTapped: / hideTapped / langTapped / updatePreview | m_ABKeyboard_*.txt | V |
| ABKeyboard | buildPanel / rebuildKeys / layoutKeys / layoutPanelIn: / key:pressed: / key factories ×2 | m_ABKeyboard_*.txt | C (structure + all strings/commands V; cosmetic geometry condensed) |
| ABKey | paint / setHighlighted: / layoutSubviews + accessors | m_ABKey_*.txt | C (cosmetic) |
| 0x20184 | scaffold ctor | ctor_20184.txt | NR for B (Core module) |
| — | OMC scaffold helpers (OMCLogWrite, OMCPref, OMCHasMethod, …) | declared in AppBridgeB.h | NR for B (Core module; declared, not implemented) |

## 9. Not recovered / condensed — declared list

1. **ABTelexApply per-key branch fidelity**: tables, classifier, entry
   search and q/g exceptions are V; the full 2,452-byte branch tree is
   reconstructed at dispatch level (standard Telex semantics) in
   `ABTelex.m` — the one knowingly condensed functional area.
2. **Cosmetic layout code**: ABKeyboard buildPanel/rebuildKeys/
   layoutKeys/layoutPanelIn:/key:pressed: and ABKey paint — structure,
   strings, commands, symbols and targets are V; exact frame/color
   constants are C (dumps cited per method are the byte-level record).
3. **`sub_958C` connected-case tail** (disconnect path is V).
4. **`sub_6498` tail**: recursion pattern verified at head; tail follows
   the same presented→children pattern (noted in source).
5. **Module A bodies** (open/close/closeall/knobs blocks, bar, launch):
   registrations and call contracts are V here; bodies are A's.
6. **Scaffold** (`sub_20184`, OMC* helpers): Core module's scope.

## 10. Source index (`src/AppBridgeB/`)

| File | Contents |
|---|---|
| `AppBridgeB.h` | Channel constants, proven packed formats, FNV-1a, globals, scaffold declarations |
| `AppBridgeEntry.m` | Constructors / role dispatch (0x44A8, 0x6E08; 0x20184 flagged Core) |
| `ABInApp.m` | Installer + all in-app hooks, publishers, mask/FPS helpers, key receiver |
| `ABHostGeometry.m` | Registrar, Darwin consumers, frame/shield blocks, lifecycle hooks, post helpers |
| `ABHost.h` | ABPane + ABHost interfaces (corrected superclasses, §7) |
| `ABHostBMethods.m` | ABHost geometry/orientation/lifecycle/touch methods (§1 set) |
| `ABChromeViews.m` | ABBoxView, ABShieldView, ABKnobView, ABBarButton |
| `ABKeyboard.m` | ABKeyboard + ABKey (keyboard channel endpoint) |
| `ABTelex.m` | ABTelexApply (verbatim tables; status §9.1) |
| `harness/` | macho.py / disasm.py / xref.py / channelmap.py (analysis tooling) |
| `disasm/` | full_arm64.txt (383 functions) + ~199 per-function dumps |

## 11. Phase-2 fix (2026-11-08) — AppBridge completion

Closes the AppBridge items from project/BUILD_PHASE1_LOG.md
(BLOCKER-AB-ZOOM, BLOCKER-AB-KEYBOARD, BLOCKER-AB-PANE,
BLOCKER-AB-CHANNELS, and the ABMissingSelector half of
BLOCKER-CORE-APPBRIDGE). All work is in src/AppBridgeB/. Every
constant below was read numerically from the binary
(verify/macho_truth.py), never trusted from truncated disassembly
annotations — two of the corrections in this section exist precisely
because an annotation fragment was previously read as a value.

### 11.1 -[ABHost zoom] (BLOCKER-AB-ZOOM) — ABHostBMethods.m

Full body written in place of the spec comment + orphan fragment:
OMCPrefsSync(); v = [OMCPref(@"appBridgeZoom", @80) doubleValue] /
100.0 (fdiv by the immediate 100.0 @0xAE58); return MIN(MAX(v, 0.6),
1.0) — fmaxnm against 0x2B210 @0xAE70, fcmp/fcsel against 1.0
@0xAE78. IMP 0xAE20, 136 B, disasm/m_ABHost_zoom.txt — VERIFIED.
**Correction: the floor is 0.6, not 0.3.** The bytes at 0x2B210 are
33 33 33 33 33 33 E3 3F = 0.6, confirmed by two independent decodes
in phase 2 (macho_truth and a hand-rolled fat/Mach-O parser). 0.3
and 0.6 share the truncated hex tail "33333333333…" that the
annotation printer showed for the slot; B's comment, ABHost.h's
comment, the phase-1 log and the phase-2 task brief all inherited
0.3 from it. ABHost.h's comment is corrected in the same pass. The
@80 default (constant int-object at 0x395A0) was verifier-confirmed
earlier and stands.

### 11.2 ABKeyboard six methods (BLOCKER-AB-KEYBOARD) — ABKeyboard.m

All six formerly-condensed items are now full bodies, VERIFIED
instruction-level against fresh reads of the dumps, constants read
numerically from __const:

- **buildPanel** (0x1A200, 2480 B): panel/glass/mesh/field/preview/
  langButton/hideButton/keysView exactly per dump; self.panel stored
  last (@0x1A9D8); blur style 11; OMCLogoMeshImage(0).
- **layoutPanelIn:** (0x196D0, 764 B): intersection only when
  area.width > 100, empty -> bounds; panelH = MIN(floor(boundsH *
  0.78), 280); note the x clamp's upper bound is the CONTAINER width
  minus panelW (fsub @0x1981C reads the bounds register, not the
  intersection's width).
- **rebuildKeys** (0x1B430, 2860 B): row-string arrays resolved from
  the constant pool — numbers @0x39468 = ["1234567890",
  "[]{}#%^*+=", "-/:;()$&@\"", ".,?!'"]; letters @0x39480 =
  ["1234567890", "qwertyuiop", "asdfghjkl", "zxcvbnm"]. The "plain"
  flag is (rowIndex == 0) || numbers (csinc @0x1B628) and suppresses
  both shift-casing and the hint label — row 0 is the digit row in
  both modes. Last-row specials (# / shift inserted at 0, del
  appended, weight 1.5). Bottom-row weights read numerically: mode
  1.4 (0x2B368), lang 1.1 (0x2B3D0), space 4.2 (0x2B3D8), ret 1.8
  (0x2B2F8); space label @"Tiếng Việt" when vietnamese.
- **layoutKeys** (0x1BF5C, 1644 B): header chrome framed from panel
  bounds (hide 34x24, lang 26x16, field, preview inset 10/0);
  keysView (5, 33, W-10, H-38) (y at 0x2B2E8, height addend -33 at
  0x2B3E0); unit = avail/totalWeight, capped at (keysW - 45)/10
  (0x2B3E8) except the last two rows and rows of 10+ keys; row font
  MAX(floor(rowH * 0.56), 14) (factor at 0x2B3F0), applied only to
  keys with nil command.
- **key:pressed:** (0x199CC, 1964 B): guard order pressed ->
  superview -> panel, all failures take the 0.12 s bubble fade
  (0x2B1F8; block sub_1A178 touches only bubble.alpha). Bubble
  geometry: bw = round(kw * 1.3) (0x2B3B8), bh = round(kh * 1.45)
  (0x2B3C0), font round(kh * 0.85) (0x2B258), spring 0.18 / damping
  0.62 / velocity 0.5 / options 4 (0x2B2B8 / 0x2B3C8).
- **key:symbol:value:command:weight:** (0x1ABB0, 2136 B): flag
  algebra documented in the source (special = nil-command || space
  || ret; punct only probed on the nil-command path @0x1ACCC);
  restColor alpha 0.9 (0x2B208) vs 0.5 by (special && !punct);
  borderWidth (!special || punct) ? 1 : 0 under !lit only;
  adjustsFontSizeToFitWidth is set on ALL paths (the dump's branch
  flags only steer ARC releases; every path converges @0x1B224).

Supporting changes in the same file:

- **Hint tables**: the two dictionaries are CONSTANT dicts in the
  binary (@0x39630 VI, @0x39658 EN), bound once into slots
  0x3EA70/0x3EA78 by the dispatch_once block @0x1D638 (helper
  sub_241E0). Contents resolved entry-by-entry from the
  constant-string pool (keys @0x39020/values @0x39070; keys
  @0x390C0/values @0x39190): VI has 10 entries (Telex tone/modifier
  producers: a->â, d->đ, e->ê, f->`, j->., o->ô, r->?, s->´ (U+00B4),
  w->ư, x->~); EN has 26 (letter -> symbol partner). Reconstructed
  as ABKeyHintTable() in ABKeyboard.m.
- **ABKey.hint re-typed** NSString* (copy) -> UILabel* (strong):
  rebuildKeys stores the UILabel it creates via setHint: (@0x1B804),
  and -setHint: @0x18C24 is a retain/store setter, not the copy
  setter an NSString property produces. B's typing was a
  transcription error.
- A class extension declares ABKeyboard's internal methods, and
  paint: is declared in a category for the factory's call
  (OMCLogoMeshImage declared from OMCCommon.h:188). This mirrors
  how the phase-1 failure manifested: with the methods as comments,
  the remaining cross-calls were undeclared-selector warnings, which
  the project's -Werror turns into errors.

### 11.3 @implementation ABPane — src/AppBridgeB/ABPane.m (new)

All 35 IMPs batch-checked against disasm/m_ABPane_*.txt: textbook
synthesized accessors for the 17 ABHost.h properties plus
.cxx_destruct; instance_size 176. The file is the @synthesize block
with an ivar/offset evidence table (setBundleID: @0xA188 tail-calls
_objc_setProperty_nonatomic_copy with offset 0x10; -frame @0xA290
loads +0x90/+0xA0; -ready @0xA2B8 ldrb +8). No hand-written logic
exists in this class in the binary — VERIFIED for all 35 IMPs.

### 11.4 Channel constants — src/AppBridgeB/ABChannels.m (new)

Defines the 14 NSString *const ABChan* + 2 const char *ABNotify*
declared in AppBridgeB.h, values from metadata/IPC_MAP.md. Every
string was verified byte-for-byte against the binary's __cstring
table in phase 2 (all 16 present verbatim). Note for the
integration agent (also in the file header): module A's
src/AppBridgeA/src/ABChannels.m is a different TU (handlers/
bootstrap, string literals only, defines none of the constants) —
the same basename in two subproject directories is yours to settle
in the build file list.

### 11.5 ABMissingSelector — src/AppBridgeB/ABMissingSelector.m (new)

Extracted from A's src/AppBridgeA/src/OMCCore.m:180-196 into its
own TU, with a provenance header. Two VERIFIED corrections to A's
copy (A had traced only the head of the 468-byte body @0x9698,
disasm/f_ABMissingSelector.txt, and said so):

1. The log line is "THIEU METHOD: %@ khong co %@ -> bo qua",
   formatted with (NSStringFromClass([object class]), selectorName)
   — A's @"THIEU METHOD: %@" was self-labelled INFERRED and is
   wrong.
2. The return type is void (A's OMCCore.h:88 agrees). AppBridgeB.h's
   id-returning declaration is a mis-read: the body ends in a
   tail-call to objc_release without setting a meaningful result,
   and the call site in sub_958C (disasm/blk_carplay_958c.txt)
   zeroes the result register itself right after the call
   (mov x20, #0). The new TU therefore deliberately does not import
   AppBridgeB.h. Relatedly, ABHostGeometry.m assigns the "return
   value" in one place — B's prose layer disagreeing with the
   binary; left untouched (outside this item's scope).

**BLOCKER-CORE-APPBRIDGE — conflict + ruling (documented as
instructed):** A's OMCCore.m conflicts with the shared unit
src/OMCCommon/ on (a) the feature-enabled default — NO
(OMCCore.m:29, kCFBooleanFalse) vs @YES — and (b) the expiry
deadline — 1809216000 (OMCCore.m:48, self-labelled INFERRED) vs
1809104400. Verifier #2 confirmed the shared unit's values
instruction-level (VERIFY_OMCCommon.md:41: 1809104400 =
2027-05-01 00:00:00 GMT+7 exactly). Per the coordinator ruling,
A's OMCCore.m is EXCLUDED from the build in favour of
src/OMCCommon/; A's file is NOT deleted — the integration agent
manages the exclusion.

### 11.6 Observations flagged, not changed (outside the items' scope)

- updatePreview (ABKeyboard.m, B's body) builds its text colour
  from components (0.16, 0.24, 0.0625) citing slots
  0x2B218/0x2B220/0x2B228 — those slots hold the slate (0.2902,
  0.3098, 0.5020) = (74, 79, 128)/255, as now used consistently by
  buildPanel, rebuildKeys, key:pressed: and the factory. Whether
  updatePreview's own IMP (0x1C5C8) really uses other constants
  needs its dump (m_ABKeyboard_updatePreview.txt) re-read before
  anyone "fixes" the numbers; left exactly as B wrote it.
- §9 item 2 of this report ("cosmetic layout code … constants are
  C") is superseded for the six keyboard methods by §11.2: they are
  now V at instruction level.

### 11.7 Syntax checks (clang-18 -fsyntax-only, iPhoneOS16.5 SDK)

Toolchain note: clang-18 had been wiped by a VM rollback; it was
restored via the project's recipe (~/bin/fix-toolchain.sh + an
apt --fix-broken pass; clang 18.1.3). Checks were run the way the
integration build compiles the subproject: -fobjc-arc, target
arm64-apple-ios14.0, and the project's force-included
project/OmniCarAppBridge/ABIntegrationShims.h (which declares
NSDistributedNotificationCenter, absent from the iOS SDK headers).

| File | Result |
|---|---|
| ABPane.m (new) | PASS — no diagnostics |
| ABChannels.m (new) | PASS — no diagnostics |
| ABMissingSelector.m (new) | PASS — no diagnostics |
| ABKeyboard.m | PASS — no diagnostics (all six bodies + factory + supporting changes) |
| ABHostBMethods.m | The reconstructed -zoom (lines 48-72) is diagnostic-free. The file still emits errors at lines >= 129, ALL in B's pre-existing bodies (setFrame:forApp:…, setShield:forPane:, …): they dereference ABBoxView/ABShieldView properties through the @class forward declarations in ABHost.h, while the @interfaces live inside ABChromeViews.m. This predates phase 2 (same constructs, untouched lines) and is a header-visibility/scaffolding matter for the integration build, not a defect in the reconstructed zoom body. |
| ABHost.h (comment-only edit) | Checked transitively via ABPane.m / ABKeyboard.m — PASS |

## 12. Final closure (2026-11-08) — the four remaining AppBridge items

Closes phase-2 gaps #4, #5, #6, #9 and #10 (AppBridge half) from
`project/BUILD_PHASE2_LOG.md`. All evidence re-derived from the binary
with the calibrated resolver (`verify/macho_truth.py`, chained-fixup
format 6) plus fresh annotated dumps saved as
`src/AppBridgeB/disasm/fin_*.txt` (capstone 5.0.7, skipdata mode —
the first pass without it silently truncated setupLiveAppViewForPane:
at 1,536 of 5,908 bytes; noted because the same failure mode could
hide in older dumps).

### Item 1 — glyph block @0x168B0: CLOSED, VERIFIED

The whole 2,356-byte renderer block was line-read
(`fin_glyph_168b0.txt`, 589 instructions) and transcribed into
`ABSetBarButtonContent` in ABHostBMethods.m. Shape: the block captures
`name` ([block+0x20]) and `size` ([block+0x28]); it scales the context
by size/24.0, sets black, then builds a stroke path (lineWidth 1.8
from __const @0x2B2F8, cap/join = 1/round) and a fill path in
parallel; dispatch is `isEqualToString:` in binary order —
fullscreen, replace, close, float, dock — then a `hasPrefix:@"hm_"`
gate that first drops the line width to 1.5, then hm_apps, hm_full,
hm_split, hm_float, hm_min, hm_close. Branches routed through the
shared tail @0x16B7C append one final `addLineToPoint:` before the
stroke/fill tail @0x16B8C; branches routed via @0x16D14 release their
last subpath and skip that line. Every constant was re-read from the
__const pool and verified byte-exact (1.8, 2.4, 16.75, 1.6, 2.2,
19.5, 5.6/6.6/4.6/10.8/1.4, 18.5, 17.5, 16.5, pi @0x2B318, -pi/2
@0x2B320, +pi/2 @0x2B330). Notable geometry: "replace" = three
rounded rects (r 2.4) plus an open corner arrow; "hm_full" = a
four-corner rounded-square outline drawn as line/arc segments
(arcs r 3.5, all clockwise=YES); "float" vs "hm_float" differ in the
fill rect (11,6.0 high vs 11.5,5.5 high). The @catch landing pads at
0x17154+ are ARC cleanup, not drawing logic. Bar-button icons no
longer render blank.

### Item 2 — ABResolveSelectorName candidate arrays: CLOSED, VERIFIED

Root cause of the earlier failure: 0x39420/0x39438/0x39450 are not
pointer slots — they ARE the NSConstantArray objects, inside
`__objc_arrayobj` (0x393D8–0x39570). Word 0 at each address decodes
as the isa bind `_OBJC_CLASS_$_NSConstantArray` (that bind is what
slot resolution kept returning). Layout proven across all 17 arrays
in the section: {isa, count, ptr-to-element-buffer}; buffers live in
`__objc_arraydata` and the counts tile the buffer exactly
(0x38ED0+6*8=0x38F00, ...). Decoding each element slot through the
fixup chain lands on __cfstring objects (flags 0x7C8). Recovered:

- @0x39420 (count 2, buffer 0x38F30): `layoutStateManager`,
  `_layoutStateManager`
- @0x39438 (count 3, buffer 0x38F40):
  `sceneIdentityForApplication:createPrimaryIfRequired:sceneSessionRole:`,
  `sceneIdentityForApplication:createPrimaryIfRequired:`,
  `_sceneIdentityForApplication:createPrimaryIfRequired:`
- @0x39450 (count 2, buffer 0x38F58):
  `primarySceneIdentifierForBundleIdentifier:sceneSessionRole:displayIdentity:`,
  `primarySceneIdentifierForBundleIdentifier:`

Call-site mapping proven in setupLiveAppViewForPane:
(`fin_setupLive_c2bc.txt`): @0xC600 loads array 0x39420 into x1 with
needle `layoutStateManager` in x2; @0xC7C8 loads 0x39438 with needle
`sceneIdentityForApplication`; @0xD3D8 loads 0x39450 with needle
`primarySceneIdentifierForBundleIdentifier` and the layoutState
object from [sp,#0x58]. All three call sites in ABHostBMethods.m now
pass the real arrays; the STUB-UNRECOVERED note is replaced by the
recovery note at the function.

### Item 3 — `_currentMode` value @0x395D0: CLOSED, VERIFIED = @2

Same misreading as item 2: 0x395D0 is not a pointer slot but the
object itself, in `__objc_intobj` (0x395A0–0x39630): word 0 = isa
bind `_OBJC_CLASS_$_NSConstantIntegerNumber`, word 1 = chained
pointer to the type string `"i"` @0x297A6, word 2 (@0x395E0) = **2**.
(Sibling entries in the section: @80, @1, @2, @0, @2, @0 — the @80 at
0x395A0 is the zoom default.) Instruction stream
(`fin_setupLive_c2bc.txt` @0xCED0–0xCEE4): `adrp/add x2, 0x395D0`,
`adrp/add x3, @"_currentMode"` (@0x35E10), receiver x22 (= vc, the
same register the preceding setIgnoresOcclusions: probe used), call
selstub `setValue:forKey:`. The omitted assignment is restored in
ABHostBMethods.m as `[vc setValue:@2 forKey:@"_currentMode"];`.

### Item 4 — ABHost duplicate-selector pairs (8): ADJUDICATED

Each pair was compared against the binary's single arm64 IMP
(fresh dumps `fin_imp_<selector>.txt`). Rulings:

| Selector | IMP | Winner | Loser → pointer note | Evidence |
|---|---|---|---|---|
| +shared | 0xA9E8 | **A** (ABHostLaunch.m) | B | Once-block invoke @0xAA2C: `objc_opt_new` on ABHost + `setPanes:[NSMutableArray array]` (@0xAA78). B's body omitted the panes initialisation. |
| -count | 0xAAA0 | **A** | B | Tie: both bodies identical to the IMP (`return self.panes.count`). Kept A's for registry-family consistency. |
| -hostsApp: | 0xAAF0 | **A** | B | IMP branches on nil first (`cbz x19 @0xAB2C` → NO). A carries the explicit guard; B omitted it (behaviour converged via isEqualToString:nil, structure did not). B's old comment also cited 0xAB00, mid-body. |
| -paneFor: | 0xAC84 | **A** | B | Tie: IMP has no nil guard; both bodies are the same unguarded scan. B's old comment cited 0xAC9C, mid-body. |
| -bundleForHash: | 0xF40C | **A** (corrected) | B | Tie on structure (scan + inline FNV-1a-32, basis 0x811C9DC5 / prime 0x01000193 proven in the IMP loop). Shared deviation fixed in the kept body: IMP compares the zero-extended hash against the FULL 64-bit argument (`cmp x27, x20 @0xF510`); both texts formerly cast the argument to uint32_t. |
| -zoom | 0xAE20 | **B** (ABHostBMethods.m) | A | IMP: `_OMCPrefsSync` first (@0xAE30), then `OMCPref(@"appBridgeZoom", @80)` (@80 = intobj @0x395A0), /100.0, fmaxnm 0.6 (@0x2B210), fcsel 1.0. A's body (nil default, no sync) contradicts both points. |
| -appWithHash:changedOrientation:supportedMask: | 0xF6B0 | **B** (corrected) | A | IMP derives orientation from the mask when the change code is 0xFF (bit algebra @0xF83C–0xF87C — B's algebra matches exactly), logs, then calls `nudgePane:` @0xF8F8. A's body stored the raw value and had no nudge — truncated. Same full-width compare fix as bundleForHash: applied (`cmp x22, x23 @0xF7C0`). |
| -carDisconnected | 0x163E8 | **B, corrected from the IMP** | A (was INFERRED) | See below. |

carDisconnected detail (this also settles phase-2 gap #9 — the body
is now VERIFIED, no INFERRED label remains): A's strategy is absent
from the IMP — there is **no `closeApp:` call** anywhere in
0x163E8–0x166B4, no per-pane log, no dropWindowIfEmpty. The IMP's
actual sequence: (1) knobViews `makeObjectsPerformSelector:
removeFromSuperview` @0x1642C; (2) knobViews `removeAllObjects`
@0x1644C; (3) early return iff panes.count == 0 AND window == nil
(count probe @0x1646C, window probe @0x16484, `cbz @0x164A0`,
short-circuit in that order); (4) log `xe ngat -> bo %lu o` with the
count re-read @0x164C0; (5) `teardownPane:` on every pane of a copy
@0x16580; (6) panes `removeAllObjects` @0x165C8; (7) window
`setHidden:YES` @0x165EC and `setWindow:nil` @0x16600. B's earlier
body had the right mechanism (teardownPane:, registry clear, window
hide+release) but knob clearing last and no guard; it was reordered
and guarded to the IMP's shape and is the sole definition.

Consequence for the rebuild: each of the 8 selectors now has exactly
ONE definition across src/AppBridgeA + src/AppBridgeB; the
(ModuleB)-category duplicate definitions that phase 2 counted
(193→200 methods) should disappear on the next sync.

### Syntax check

`clang-18 -fsyntax-only -target arm64-apple-ios15.0 -isysroot
~/theos/sdks/iPhoneOS16.5.sdk -fobjc-arc -fblocks`, with the project
shims force-included (ABIntegrationShims.h; ABChromeViews.h checked
both ways):

- ABHostBMethods.m: parses end-to-end. Zero diagnostics in every
  region touched by this closure (glyph block, ABResolveSelectorName
  note/arrays, the three call sites, _currentMode, appWithHash:,
  carDisconnected, the five pointer notes). Remaining diagnostics are
  all pre-existing and outside scope: the 3 known F8 dot-on-`id`
  sites in setFrame: (fixed in project copies by casts), the
  ABBoxView/ABShieldView header-visibility class (fixed in project
  copies by the ABChromeViews.h import arrangement), and the
  EXPECTED `-Wincomplete-implementation` notes for +shared/count/
  hostsApp:/paneFor:/bundleForHash: — those five are now defined
  solely in module A, which is the point of the adjudication.
- ABHostLaunch.m: only pre-existing diagnostic is the missing
  `<objc/message.h>` import at the openApp: body (project fix F3
  territory); the pointer-note edits and the bundleForHash: width
  correction are diagnostic-free.

### src/ changes made (complete list, for the rebuild agent's sync)

- `src/AppBridgeB/ABHostBMethods.m` — glyph block implemented in
  ABSetBarButtonContent (stub removed); ABResolveSelectorName stub
  note replaced with the recovery note; 3 candidate arrays restored
  at the call sites; `[vc setValue:@2 forKey:@"_currentMode"]`
  restored; +shared/-count/-hostsApp:/-paneFor:/-bundleForHash:
  bodies removed → adjudication pointer notes; appWithHash: kept +
  full-width hash compare; carDisconnected kept + reordered/guarded
  to the IMP.
- `src/AppBridgeA/src/ABHostLaunch.m` — +shared/-hostsApp: comments
  carry the adjudication evidence; bundleForHash: kept +
  full-width compare; -zoom / -appWithHash:… / -carDisconnected
  bodies removed → pointer notes (the INFERRED carDisconnected
  skeleton is gone).
- New evidence dumps: `src/AppBridgeB/disasm/fin_glyph_168b0.txt`,
  `fin_setupLive_c2bc.txt`, `fin_resolve_d9b0.txt`,
  `fin_shared_trampoline.txt`, `fin_imp_{shared,count,hostsApp,
  paneFor,zoom,bundleForHash,appWithHash,carDisconnected}.txt`.

### Still open

Nothing from this task's four items. (Out-of-scope pre-existing
INFERRED labels elsewhere in the file — ABCheckCast's eleven
non-sceneIdentity sites, the ABResolveSelectorName nil-object tail
@0xDD88, -ensureWindow's status-bar base, blur-style/easing names —
were not part of this brief and are unchanged.)
