# DEVICE VERIFICATION PLAN — rebuilt OmniCar 1.0.3

**This is a PLAN. Nothing in this document is a device result.** No
rebuilt package has been installed on a device yet. Every item below
states what to do and what evidence would prove the behaviour; the
result column is to be filled in when the run happens.

Test device profile (from the project record): iPhone X (arm64),
palera1n rootless, iOS 16.7.16 — the VM-built package is arm64-only,
which matches this device; do **not** use an arm64e device for the
VM-built package. CarPlay surface: the user's car head unit or the
desk CarPlay emulator.

Protocol note (user's standing rule): run this as **one combined test
session** covering all sections in one pass, then upload the one log —
not piecemeal per-feature tests.

## Evidence kit (collect for every section)

- **Device log**: `/var/mobile/Documents/OmniCar.log` — written by
  `_OMCLogWrite`, line format `"<ts> [<proc>:<pid>] <tag>: <msg>"`;
  SpringBoard rotates it at 2 MiB (`OmniCar.log.old`). Pull the whole
  file after the session.
- **Preferences**: domain `com.anlai.omnicar` (mobile
  `Library/Preferences` plist). Snapshot it before install, after
  install+respring, and after the session; most acceptance evidence
  below is a specific key appearing/changing.
- **UI outcome on the car display** — recorded separately from the log.
  A log PASS is never a screen PASS: for each item, note both.
- **Notify/IPC references**: `metadata/IPC_MAP.md` (17 Darwin notify
  names, 4 CFNotificationCenter-Darwin names, 20
  NSDistributedNotificationCenter names) and `metadata/PREFS_MAP.md`
  (53 keys) are the ground truth for what should fire.

---

## A. STATIC CHECKS — already provable without a device

These are established from the reconstruction evidence and do **not**
need a device run. (They verify the *reconstruction*, not behaviour.)

| # | Check | Evidence |
|---|---|---|
| A1 | The input DEB is the genuine 1.0.3 | SHA-256 `d9297b01…` matches the reference; inventory verified file-for-file vs `dpkg-deb -c` (202 entries). `inventory/` |
| A2 | No original executable ships in the rebuilt project | Only 168 non-executable resources were copied (SHA-256 list in `project/RESOURCE_PROVENANCE.md`); all 8 Mach-O are rebuilt from `src/`. |
| A3 | Diff harness is trustworthy | Self-test on the original: 176/176 files, 13/13 control fields, 8/8 binaries BYTES EQUAL. `project/BUILD_PREP_REPORT.md` §3 |
| A4 | Scaffold packaging end-to-end works | Scaffold DEB built, file set 176 = 176, resources 168/168 byte-identical. `project/logs/diff-scaffold-final.txt` |
| A5 | Name-resolution tooling is calibrated | Off-by-one in the wave-1 parser found, broadcast, and independently adjudicated CLOSED; annotation audit: 86,709 call annotations, 0 true mislabels after regeneration. `metadata/ANNOTATION_AUDIT.md` |
| A6 | No bogus superclass survives in source | Sweep of 79 `@interface` declarations: 71 MATCH, 0 WRONG, 8 EXTERNAL (framework forward-declarations). `metadata/SUPERCLASS_SWEEP.md` |
| A7 | Cross-module maps are accurate | Independent spot-check 15/15 rows across IPC/PREFS/HOOK maps. `metadata/VERIFY_MAPS_SPOTCHECK.md` |
| A8 | Shared core compiles to the right surface | OMCCommon objects define exactly the 21 expected `_OMC*` symbols, 0 errors/warnings. `src/OMCCommon/OMCCommon_REPORT.md` |
| A9 | Modules independently verified (static scope) | Per-module VERIFY files — see `handover/RECOVERY_STATUS.md` for the list and verdicts. |
| A10 | `com.anlai.omnicar/speed` has no consumer in this package | Exhaustive trace: the string exists only in SpeedBubble; both references are inside the publisher. It is an outward-facing surface, not a missing link. `metadata/SPEED_CHANNEL_TRACE.md` |

**To be added after the final build (still static, no device):** final
`diff_payload.py` fingerprints vs the COVERAGE target table, and the
`dpkg-deb -c` owner/mode parity comparison (see `BUILD_GUIDE.md` §5–6).

---

## B. REQUIRES A REAL RUN — per module/feature

### B0. Install & load

- **Do**: install the rebuilt DEB, respring once (the original's own
  instructions say changes apply on next CarPlay connect; respring
  after install).
- **Prove it**: after respring + one CarPlay connect, the prefs domain
  contains `diagLoaded.*` stamps written by the modules' own
  constructors — `diagLoaded.Core@<proc>` (Core), the diag block of
  SplitScreen, and (after CarPlayApp runs) `diagLoaded.CarProbe<Process
  Name>` — each an NSDictionary {version `1.0.3`, build `fbebb21`,
  date}. `OmniCar.log` exists and accumulates lines from several
  processes (SpringBoard, CarPlayApp, source apps).
- **Fail looks like**: a `diagLoaded.*` key missing → that dylib did
  not load/run; log file absent → the shared core's log path is broken.

### B1. Shared core (OMCCommon / OmniCarCore) — SpringBoard

- **Connect bookkeeping**: on CarPlay connect, Core's recorder writes
  the `diagCar` pref (date/connected/iOS version/points/pixels/scale/
  maxFPS + session/configuration snapshot) and posts
  `com.anlai.omnicar/car.connected`. Evidence: `diagCar` populated in
  the post-session prefs snapshot; `car.connected` consumers in other
  modules react (B3/B8 session starts).
- **Clean-RAM pass**: with pref `cleanRamOnConnect` = YES, ~8 s after
  connect Core classifies running apps and kills unclassified
  user apps. Evidence: pref `diagCleanRam` {date, closed,
  running-count} written; log summary line `don RAM (…)` with kept
  apps rendered as `bid (category)`. (Manual trigger:
  `com.anlai.omnicar/cleanram.now` notify.)
- **Trusted time**: Core fetches the HTTP `Date` header of a HEAD
  request to apple.com (15 s timeout, 6 h refetch) and maintains the
  `trustedTime` pref monotonically. Evidence: after a connect with
  network access, `trustedTime` exists and never decreases across
  reconnects.
- **Expiry drill** (the licence deadline is epoch **1809104400** =
  2027-05-01 00:00 GMT+7; expired iff max(wall clock, `trustedTime`)
  ≥ deadline): write a `trustedTime` value ≥ 1809104400 into the
  prefs, wait ≤ 60 s — the Core watchdog must post
  `com.anlai.omnicar/prefschanged` and all feature gates
  (`OMCEnabled`/`OMCFeatureEnabled`) must turn off (features stop
  while the master `enabled` pref is untouched). Then restore a normal
  `trustedTime` and respring (the latch is in-process) → features
  return. Also confirm the fail-open direction: with no `trustedTime`
  and a normal clock, nothing is expired.
- **Lite mode**: `liteMode` pref default is 2 (auto). Under thermal
  state > Serious, or a hang within 120 s, or late-frame % ≥ 15, the
  auto-lite setter drives the `com.anlai.omnicar/lite` notify state
  and logs `che do nhe tu dong: BAT vi <reason>`. This may not trigger
  naturally in a short session — record as PASS only if observed;
  otherwise mark NOT EXERCISED, do not fake the condition.
- **Log relay**: lines written by non-SpringBoard processes reach
  `/var/mobile/Documents/OmniCar.log` via the
  `com.anlai.omnicar/log` distributed relay. Evidence: log contains
  lines tagged from CarPlayApp and from a source app process, not only
  SpringBoard.

### B2. CarProbe (inside CarPlayApp)

- **Do**: nothing user-visible — by design this dylib is the shared
  core linked into CarPlayApp plus a constructor stamp; its
  crash-guard machinery has zero in-binary callers (verified
  statically).
- **Prove it**: after CarPlayApp has run, `diagLoaded.CarProbe<Process
  Name>` exists in prefs with version `1.0.3` / build `fbebb21`.
  That stamp is the module's entire expected device footprint.

### B3. The app (OmniCar.app trampoline)

- **Open the app**: dark-navy UI, centred label, one button. Button tap
  opens Settings at `prefs:root=OmniCar`.
- **URL forwarding**: open an `omnicar://…` URL (e.g. from Shortcuts).
  The app must forward the URL **verbatim** via the distributed
  notification `com.anlai.omnicar/url` (userInfo `@{@"url":
  absoluteString}`) — evidence: Core's dispatcher (sub_5728) and
  SplitScreen's handler (sub_8f6c) react to the routed feature/lite/
  startup URL — and the app must suspend itself ~0.3 s after the open,
  every time.

### B4. Preferences (OmniCarPrefs)

- **Pages render**: Settings → OmniCar root page (15 static items +
  code-inserted feature rows ordered 10/20/30) and every feature page
  (App Bridge, Split Screen, Speed Bubble, Startup Screen, Home
  Screen, Car Profiles, diagnostics, onboarding/what's-new).
- **Master toggle**: toggling the master switch is the ONLY writer of
  the `enabled` key; it must sync and post
  `com.anlai.omnicar/prefschanged`. Evidence: `enabled` flips in the
  prefs snapshot; with it off, features are inert at next connect.
- **Language**: `setLanguage:` writes `language` and deliberately does
  **not** post `prefschanged` — UI strings change via the `OMCTr`
  lookup (which loads `<lang>.lproj/Car.strings` from the prefs
  bundle). Evidence: switch language → strings change; no
  prefschanged-driven reload is expected for this key.
- **App picker**: in the App Bridge page, choose phone apps → the
  `appBridgeApps` pref is written as an NSArray of bundle ids
  (Prefs-B's controller is the writer). Evidence: prefs snapshot +
  B6 (the chosen apps appear on the car grid).
- **Car profiles**: after a connect, the profiles page lists the car
  (`carProfiles` keyed by vehicle identifier or `<name>|<pixels>`,
  `carProfileCurrent` + `lastSeen` updated).
- **Diagnostics page**: shows data sourced from `diagCar`, `diagPerf`,
  `diagHooks.<module>`, `diagLoaded.*` — non-empty after a real
  session (B0/B1 evidence feeds this).

### B5. Split Screen (OmniCarSplitScreen — CarPlayApp + SpringBoard)

- **Enable + open a split**: with `splitScreenEnabled` on, open two
  CarPlay apps → both render in panes of the split view. Layouts:
  linear (0), stack-left (layout ID 13), stack-right (layout ID 31);
  divider gap 1 pt; sizing floors with remainder to the last pane.
- **Divider drag**: drag the divider → pane fractions clamp to
  [0.04, pair−0.04]; snapping to {1/3, 1/2, 2/3} (or the 1/12 grid);
  squeeze a pane below 0.12 → it is dismissed (negative slot encoding).
- **Zoom**: double-tap the divider/handle → the pane zooms (in 1.0.3
  zoom is `SCPCarSplit._zoomedSlot` + frame recomputation — there is
  no separate zoom class); double-tap again → back.
- **Float pane**: pop a pane out → floating window with the decoded
  clamps (small: clamp(W×0.30,160,240) × clamp(H×0.45,96,170); large:
  clamp(W×0.45,220,360) × clamp(H×0.62,130,260)); drag, dock back
  (fade = alpha 0 + scale 0.8).
- **Presentation gate**: opening an app full-screen while split is
  active must be adopted into the slot, not cover the split (the
  `presentBaseViewController:` hook adopts adoptable scene VCs and
  swallows full-screen presentation).
- **Restore on reconnect**: disconnect and reconnect → RootVC appear
  publishes after 3.0 s, `com.anlai.omnicar/splitscreen.ready` fires,
  and the last layout auto-launches (`splitScreenLastLeft` /
  `splitScreenLastRight` prefs reflect it). Pending bookkeeping:
  entries go stale at 12 s, cancelled at 30 s.
- **Disconnect cleanup**: on dashboard invalidate, panes/scenes are
  torn down cleanly (no orphan windows on the car display).

### B6. Car home grid + declaration injection (SplitScreen C family)

This is the mechanism behind the user's map-app requirement — test it
exactly as specified:

- **Setup**: pick a phone app in the Prefs app picker (`appBridgeApps`)
  and make sure it is **OFF in stock iPhone Settings → CarPlay**
  (OmniCar's design needs no stock toggle).
- **Prove it**: the app appears on the **car grid** — SplitScreen
  grafts a synthetic `CRCarPlayAppDeclaration` (maps YES, templates
  NO, tag `OmniCarAppBridge`) onto the chosen app's info and adds
  missing apps to the dashboard library as validated
  `LSApplicationProxy`s. Tapping the icon launches via the dashboard,
  intercepted by the `+launchInfoForApplication:` hooks (it does NOT
  use the `appbridge.open` channel).
- **Crash-guard**: prefs `splitScreenIconsPending` /
  `splitScreenIconsCrashed` — a run that dies mid-injection records
  `splitScreenIconsCrashed = "1.0.3"` and disables injection for this
  version until the chosen list changes (debounced 0.8 s resync).
  Evidence: after a normal session both keys are in their healthy
  states (pending cleared on car-screen OK).
- **Visibility rules**: protected apps can never be hidden
  (mobilephone, Music, Maps, MobileSMS, InCallService, the
  `com.apple.CarPlay` prefix, "NowPlaying", injected apps,
  not-installed apps); an explicit "shown" loses to "hidden"; icon
  scale and label hiding apply per the Home settings
  (`homeScreenCarApps` is written for the Settings UI).
- **Wallpaper**: with Home Screen wallpaper configured, the car home
  shows `HomeScreen/wallpaper.jpg` (photo, style 7) or `video.mp4`
  (video, style 8), re-applied on a 30 s timer.

### B7. App Bridge (OmniCarAppBridge — every UIKit process + SpringBoard)

- **Host a phone app**: open a chosen phone-only app (e.g. YouTube)
  into a split pane. Host gate is only: non-empty bundle id,
  `appBridge` feature on, a CarPlay display present. Success log line
  shape: `host %@ tai %@ (huong %lld, zoom %.2f)`; refusal lines:
  `tat trong Cai dat -> khong host %@` (feature off) / `xe chua ket
  noi -> khong host %@` (no car display). Check `OmniCar.log` for the
  matching line.
- **Scene stays alive**: switch the hosted app to the background and
  back — the hosted FBScene's backgrounded update is swallowed, so
  the app never learns it was backgrounded (no reload/reset of the
  hosted UI).
- **Keyboard**: tap a text field in the hosted app → the in-car
  keyboard appears. The channel is a packed uint64 on
  `com.anlai.omnicar/appbridge.keyboard` (bit0 shown, bits1–7
  UIKeyboardType, bits8–15 UIReturnKeyType, bits24–55 FNV-1a-32 of
  the bundle id). Type Vietnamese text → the ABTelex engine composes
  it correctly inside the app. Hide/show follows the app.
- **Orientation/zoom**: `appBridgeZoom` pref (default 80 → scale 0.8,
  clamped 0.3–1.0) sizes the hosted scene; orientation changes ride
  `com.anlai.omnicar/appbridge.apporient` (0.25 s debounce; the fake-
  rotation delays are the constant set 0.3 / 1.5 / 4.0 s).
- **Chrome interactions**: pane bar buttons act (44×44 hit area),
  shield tap dismisses the bar (`appbridge.bardismiss`), knob drag
  relays at 1.0 pt throttle (`appbridge.knobtouch`), bar actions post
  `appbridge.baraction`. All of these are NSDistributed notifications
  observed by SplitScreen — evidence is the UI effect on the car
  display plus the absence of errors in `OmniCar.log`.

### B8. Speed Bubble (OmniCarSpeedBubble)

- **Publish path**: run a supported source app (Vietmap Live
  `vn.vietmap.live`, GOFA `com.lumi.GOFA`, Waze `com.waze.iphone`,
  Wyn `com.wynauto.wyn`). The source-side engine publishes
  `com.anlai.omnicar/speedbubble.speed` as a packed uint32 state:
  bits0–7 limit, bits8–15 speed, bit16 speed-valid, bit17
  limit-valid, bit18 foreground, bits19–21 host index. The bubble in
  SpringBoard/CarPlayApp consumes it (gated by
  `[SPPPrefs appEnabled:]`).
- **Arbitration**: Waze/Wyn (host indices 2/3) publish only while the
  `com.anlai.omnicar/speedbubble.source` state equals their index;
  Vietmap/GOFA always publish. Display side sets `speedbubble.source`
  at launch (enabled ? source : 0xFF). Evidence: with two source
  apps installed, the bubble follows only the selected source.
- **Reading quality**: drive (or use the app's own display) — the
  scan engine reads the limit sign (commit gates: speed ≤ 300, limit
  5–200; AX fallback under a 40 ms deadline). The bubble shows the
  current speed and the posted limit.
- **Overspeed**: exceed the limit → state 2: the bubble flashes
  (flash colour (1, 0.353, 0.373)) and the configured warning fires
  (tone or voice per `speedBubbleWarnMode`/`WarnFx`/`WarnSound`
  prefs); `setOverLimitWarning:` is the final call of the render.
- **Styles 0–8**: switch `speedBubbleLook` in Prefs → the bubble
  re-renders in that style. Spot-check the decoded signatures:
  style 0 glass ring (content 120×118), style 2 disc (160×80),
  style 3 arc 135°→405°, style 8 analogue gauge (ticks 0–150, zone
  arc from angle(limit) to angle(**160**) — hidden when limit < 1 or
  ≥ 160; needle rotation `150 + 240·min(speed/160, 1.04)`).
- **Gestures**: drag moves the bubble, pinch resizes, long-press opens
  the menu, tap re-opens the source app (posts
  `com.anlai.omnicar/speedbubble.opencar`).
- **Own GPS**: with no source app active, SPPSpeedGPS supplies speed;
  position is also published on `com.anlai.omnicar/location`
  (`(llround(lat·100)<<32) | (uint32)llround(lon·100)`, accuracy
  ≤ 5000 m, ≥ 3 s throttle) for StartupScreen's weather.
- **Prefs-driven checks**: "try on car" in Prefs posts
  `com.anlai.omnicar/speedbubble.demo` → demo bubble appears;
  "reset layout" posts `…/speedbubble.resetlayout` → bubble position
  resets.

### B9. Startup Screen (OmniCarStartupScreen)

- **On connect**: the splash plays on the car display for
  `startupScreenDuration` (default 5 s) in the chosen style; tap
  skips. The style is published as the notify state of
  `com.anlai.omnicar/startupscreen.style`.
- **Sound**: soundtrack plays through the car speakers — SSSplash
  posts CFNotificationCenter-Darwin `…/startupscreen.audio.play` at
  countdown start and `…/startupscreen.audio.stop` on dismiss/
  teardown; the SpringBoard-side engine (sub_8f0c) performs it.
  Evidence: audible sound + stop on skip.
- **Weather**: SSSplash posts `…/startupscreen.weather.request`;
  the location side answers from the cached position (fed by B8's
  `com.anlai.omnicar/location` channel) and
  `…/startupscreen.weather.ready` triggers the refresh — the splash
  shows the weather card when a position is available.
- **Content**: greeting/occasion variants (incl. the birthday flow
  keyed by the `startupScreenBirthday` "MM-dd" pref — set it to
  today in Prefs for the drill), HUD lines (CarPlay status,
  calendar event card when access exists), logo effect. Note: the
  eight scene builders' cosmetic constants are the module's known
  not-recovered area (see `RECOVERY_STATUS.md`) — judge this section
  by overall appearance vs the original, and record any visual
  difference explicitly.

### B10. Crash guard / rescue (OPTIONAL — destructive, skip by default)

- Only if explicitly wanted: the shared `OMCCrashGuard` (armed by the
  first sibling module that calls its copy) counts early crashes
  (60 s window, threshold 2) and enters rescue mode: features
  disabled, prefs `rescueFeatures` + `rescueDate` written, posts
  `com.anlai.omnicar/rescue` + `prefschanged`; Core's announcer shows
  a user notice; crash markers land in the session struct shared via
  the `OMC_CRASHGUARD` environment variable (last-logging module is
  the `last=` field of crash lines). Manual re-enable un-rescues.
- Evidence if exercised: the two prefs + the notice + features off.
  Do **not** induce crashes on the user's only test phone without an
  explicit go-ahead.

---

## C. Recording results

For each B item record: **PASS / FAIL / NOT EXERCISED**, the UI
observation, and the exact evidence (log excerpt lines, pref key
values before/after). One session, one log upload (`OmniCar.log` +
prefs snapshots). Any FAIL should cite the module and the mechanism
name from `metadata/HOOK_MAP.md` / `IPC_MAP.md` so the fix goes to
the right reconstructed function.
