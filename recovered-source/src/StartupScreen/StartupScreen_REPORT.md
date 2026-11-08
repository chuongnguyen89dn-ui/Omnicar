# OmniCarStartupScreen.dylib — Reconstruction Report

OmniCar 1.0.3 (`com.anlai.omnicar`), module agent report, wave 2.
Binary: 567,792 B fat; arm64 slice 272,864 B, UUID `3C073435-22DF-3EE2-ACFA-D109A37EF1B7`;
filter: `com.apple.CarPlayApp` + `com.apple.springboard`; 8 classes / 173 methods;
347 functions disassembled (`disasm/`, one file per function + `_index.json`).

Deliverables: `SSStartupScreen.h`, `SSStartupScreen.m` (C layer: constructors,
hook, factory, soundtrack, weather/location), `SSSplash.m` (splash session),
`SSStartupView.m` (animated scene engine + SSFade/SSGauge/SSLinkTarget/SSCanvasView).

## Two corrections to the task brief's assumptions (proven from the binary)

1. **There is no AVPlayer in this module.** Zero AVPlayer/AVPlayerLayer/AVURLAsset
   references across all 347 functions. The "video" startup screen is a **JPEG
   frame sequence**: the Settings side converts a chosen clip into
   `<Videos>/.frames/<name>/%05lu.jpg` files plus an `info.plist` `{count, fps}`;
   SSSplash decodes frames ahead with **ImageIO** (`CGImageSourceCreateImageAtIndex`
   with `kCGImageSourceShouldCacheImmediately`) on a serial queue and displays
   them from a CADisplayLink tick. The soundtrack is separate: an **AVAudioPlayer**
   in SpringBoard playing `.frames/<name>/audio.m4a` or a file from `Sounds/`.
   There are no Photos/Files pickers in this dylib — media selection is a
   preference (`startupScreenVideoName`) over the folder
   `/var/mobile/Library/OmniCar/StartupScreen/Videos`.
2. **Wave-1 metadata superclasses were wrong** (off-by-one bind-ordinal bug in
   the shared parser; independently confirmed by the annotation audit and by my
   own cross-check — §6). Corrected: SSLocationOnce/SSSplash/SSFade/SSGauge/
   SSLinkTarget → **NSObject**; SSSplashWindow → **UIWindow**;
   SSCanvasView/SSStartupView → **UIView** (wave-1 said NSMutableSet / NSRunLoop /
   `_OBJC_METACLASS_$_UIWindow`).

## 1. What the module does

A CarPlay welcome splash: when the car display appears, a full-screen window on
the car screen plays a short branded scene (logo animation, greeting, live
weather card, dashboard gauges, checklist, briefing, particles, festive
occasion scene — or a converted video), with an optional soundtrack, then fades
out and hands the screen back to the normal CarPlay UI.

The two host processes have opposite roles:

| Process | Role |
|---|---|
| **CarPlayApp** | Owns the splash: trigger hook, scene/screen observers, SSSplash sessions, weather *display* (asks SpringBoard when it has no location permission). |
| **SpringBoard** | Owns services: soundtrack playback (`AVAudioPlayer`), weather fetching (open-meteo + ipapi fallback), persisting the nav app's GPS position to `location.plist`. |

## 2. Trigger chain (all VERIFIED)

1. Constructor `__init_0` @0x74a8 (CarPlayApp branch): returns early unless
   `OMCCrashGuard(@"startupScreen")` passes; sets an *armed* flag; installs the
   module's **only hook** (see §5); logs existing screens; registers
   NSNotificationCenter block observers for `UISceneWillConnectNotification`,
   `UISceneDidActivateNotification`, `UIScreenDidConnectNotification`,
   `UIScreenDidDisconnectNotification`, `UISceneDidDisconnectNotification`.
2. The hook is `-[UIWindow setHidden:]` → sub_8054: the original runs first;
   the trigger fires only when a window is being **shown** (`hidden == NO`),
   the module is armed, and the window is **not** an SSSplashWindow (which is
   what keeps the splash's own `setHidden:NO` from recursing). The screen is
   classified by sub_a61c: `traitCollection.userInterfaceIdiom == CarPlay (3)`
   **or** `screen != mainScreen`. On a car screen it dispatches
   `SSHandleCarScreen(screen, scene, @"window")` to the main queue.
   `UISceneDidActivate` reaches the same factory via sub_84b8
   (`SSSceneLogAndHandle`, reason `@"sceneActivate"`).
3. Factory sub_a6c4 (3,848 B): claims the screen with an associated object
   **before** any check (claim key @0x3b1b0, policy ASSIGN, never cleared — one
   splash per UIScreen instance). Syncs prefs; bails if the feature is off.
   Computes the **occasion** (birthday from `startupScreenBirthday` "M-D";
   Chinese-calendar Tết (month 1, days 1–3, non-leap) and Mid-Autumn (8/15);
   Jan 1; Dec 24/25) with a **3-per-day cap** persisted in
   `startupScreenOccasionLog` (7-day prune, `yyyy-MM-dd` keys). Resolves the
   **style** (occasion ⇒ 11; setting 10 ⇒ random from `startupScreenRandomSet`,
   dropping video if no clip exists and logo if no logo.png, empty ⇒ 2;
   otherwise the setting clamped to 0–10). Style 0 resolves the frame
   directory and falls back to **style 9 (liquid)** with an explanatory log
   when no converted frames exist. Creates the SSSplash, stores it as an
   associated object (key @0x3b158), and calls `start`.

Style names (VERIFIED from the Settings bundle, `FeatureStartupScreen.plist`):
0 Video, 1 Logo, 2 Greeting, 3 Weather, 4 Engine, 5 Welcome, 6 Particles,
7 HUD, 8 Briefing, 9 Liquid, 10 Random, 11 Occasion. Also from Settings:
`startupScreenScaleMode` 0 = Fill / 1 = Fit; `startupScreenLogoEffect`
0 = Fade / 1 = Zoom / 2 = Glow; `startupScreenTempo` 0 Slow / 1 Normal / 2 Fast.

## 3. The splash session (SSSplash, VERIFIED)

- **Window**: `SSSplashWindow` with the scene (`initWithWindowScene:`) or the
  screen frame; `windowLevel = UIWindowLevelAlert + 1000.0` (const @0x28dc8,
  resolved by verifier #6); black background;
  a plain `UIViewController` whose view is the content view (frame image view
  for style 0, SSStartupView otherwise). A `UITapGestureRecognizer` is added
  when `startupScreenTapToSkip` (default YES).
- **Style 0 playback**: `start` → CADisplayLink `tick`. The decoder keeps a
  small window of frames in flight (a count compared against **3**), decoding
  `%05lu.jpg` via ImageIO on queue `com.anlai.omnicar.startupscreen.decode`.
  First frame starts the countdown; frames pop from the buffer in order;
  at `shownFrames == frameCount` (non-loop) the link stops and the splash
  dismisses after one frame interval. Loop mode (`startupScreenPlayFull`)
  wraps. A **10 s watchdog** dismisses with reason `@"no frame after 10s"` if
  nothing was ever shown.
- **Styles 1–11**: first tick invalidates the splash's own link, calls
  `[startView playIntro]`, starts the countdown, and (from `start`) kicks
  `refreshWeather`.
- **Countdown** (`startCountdown`): duration = `MAX(pref startupScreenDuration
  (default 5), 1)` seconds — except style 0 non-loop, where it is the
  constant **60.0** (cold block @0x6d94; corrected by verifier #6 — an
  earlier draft had INFERRED `frameCount/fps`). It publishes **style + 1**
  as notify state on `com.anlai.omnicar/startupscreen.style` (state 0 is
  the consumer's "unset" sentinel; the soundtrack gate subtracts 1),
  posts Darwin `…/startupscreen.audio.play`, and schedules
  `dismissBecause: @"<duration>s timer"`.
- **Dismissal**: reasons are `@"skip"` (programmatic), `@"tap"`,
  `@"press (knob / button)"` (tap recognizer with zero touches — a car
  knob/button press), the timer, or the watchdog. `dismissBecause:` is
  finished-guarded, records `endReason = "<reason> after <elapsed>s"`, posts
  Darwin `…/startupscreen.audio.stop`, and fades the window's alpha to 0,
  then `tearDown`. `tearDown` (also called on screen/scene disconnect via
  sub_8838) invalidates the link, clears the buffer, hides and releases the
  window, and clears the screen's splash association. Nothing re-shows or
  reorders CarPlay UI — handoff is simply the window going away.
- **Init data assembly** (VERIFIED): greeting name, car name (pref, else first
  usable string inside the nested `diagCar` pref dictionaries), tempo, logo
  image (`Logo/logo.png`, else an SF Symbol glyph — `play.rectangle.fill` for
  video style, `car.fill` otherwise), the 5-line status HUD (CarPlay
  connected; iPhone battery % from UIDevice with monitoring toggled on/off
  around the read; thermal state OK/hot/very hot; Lite mode on/off/auto;
  optional car-profile name), the next non-all-day EventKit event (in an
  @try/@catch; "calendar: no access (status %ld), no event card" otherwise),
  and the cached weather dictionary.

## 4. Soundtrack engine (SpringBoard, sub_8f0c, VERIFIED)

- Driven by Darwin notifications `…/startupscreen.audio.play` / `.stop`
  (callback sub_79d0). On **play**: reads the current style from the
  `com.anlai.omnicar/startupscreen.style` notify state (fallback: the pref);
  **style ≠ 0 ⇒ no soundtrack**. Source A: if `startupScreenSound`, the
  clip's `.frames/<name>/audio.m4a`. Source B: `startupScreenSoundFile` in
  `Sounds/` (last path component). Skips when a phone call is in progress
  (`CXCallObserver`, any call with `hasEnded == NO`) if
  `startupScreenSoundSkipCall` (default YES). Volume =
  `startupScreenSoundVolume` percent (default 100) clamped 0–100, ≤ 0 ⇒ no
  playback. Saves the audio session's category/options, sets
  **AVAudioSessionCategoryPlayback + MixWithOthers**, activates, plays.
- **"Audio routing to car speakers"**: there is **no explicit output-port
  override anywhere**. Playback uses the system route; the play log line dumps
  `session.currentRoute.outputs.firstObject.portType` as evidence of where
  audio actually went. On **stop**: volume fades to 0 over **0.4 s**, then the
  player stops and the saved session category is restored (sub_9a84).
- The `AVAudioPlayer.numberOfLoops` operand is
  `boolValue(startupScreenPlayFull) − 1` (VERIFIED @0x91ac–0x91b0,
  verifier #6): play-full YES ⇒ 0 (play once), NO ⇒ −1 (loop forever).
  (An earlier draft had this mapping inverted.)

## 5. Hook table

| Installer | Class | Selector | Replacement | Original |
|---|---|---|---|---|
| `__init_0` @0x74a8 (CarPlayApp only) | `UIWindow` | `setHidden:` | sub_8054 @0x8054 | global @0x3b170 |

`MSHookMessageEx` ×1 in this binary (matches HOOK_MAP). No other hooks; scene
and screen events come from NSNotificationCenter observers.

## 6. IPC map (VERIFIED; agrees with metadata/IPC_MAP.md)

| Channel | Kind | Producer | Consumer | Payload |
|---|---|---|---|---|
| `com.anlai.omnicar/startupscreen.audio.play` | Darwin | SSSplash `startCountdown` (CarPlayApp) | SpringBoard sub_79d0 → sub_8f0c | — |
| `com.anlai.omnicar/startupscreen.audio.stop` | Darwin | SSSplash `dismissBecause:` / `tearDown` | SpringBoard sub_79d0 → sub_8f0c | — |
| `com.anlai.omnicar/startupscreen.weather.request` | Darwin | SSSplash `refreshWeather` | SpringBoard sub_7a44 → sub_7d10 | — |
| `com.anlai.omnicar/startupscreen.weather.ready` | notify post | SpringBoard (sub_a608, sub_a0c8) | SSSplash `refreshWeather` block sub_8aa4 | — (cache file is the payload) |
| `com.anlai.omnicar/startupscreen.style` | notify state | SSSplash `startCountdown` | SpringBoard sub_8f0c | state = style + 1 (0 = unset sentinel; consumer subtracts 1) |
| `com.anlai.omnicar/location` | notify state | SpeedBubble `SPPSpeedGPS` (other module) | SpringBoard sub_7a60 | state = `(int64)(lat*100) << 32 \| (uint32)(int64)(lon*100)` (centidegrees) |

Weather flow: CarPlayApp without location access posts `weather.request` and
waits for `weather.ready`, then reads the shared `weather.plist` (10 s timeout
with one re-ask). SpringBoard answers (sub_7d10, reentrancy-guarded) from, in
order: a fresh `CLLocationManager` last fix; a one-shot `SSLocationOnce` fix
at `kCLLocationAccuracyKilometer`; the persisted nav-app position in
`location.plist` ("nav app's (%.0f min old)"); or IP geolocation via
`https://ipapi.co/json/`. Fetch (sub_88e4):
`https://api.open-meteo.com/v1/forecast?latitude=%.2f&longitude=%.2f&current=temperature_2m,weather_code,is_day&daily=temperature_2m_max,temperature_2m_min,precipitation_probability_max&timezone=auto&forecast_days=1`
on an ephemeral session (timeouts 3 s/3 s, no connectivity wait, cache
ignored); success requires HTTP **200**; the parsed dictionary
`{temp, code, isDay, high, low, rain, date}` is saved to `weather.plist`
with permissions **0644** (the file crosses the SpringBoard→CarPlayApp
boundary). `SSWeatherLoadCache` returns the newest non-future-dated cache
among the candidate paths that has a coercible `temp`.

## 7. Preferences (domain `com.anlai.omnicar`; defaults VERIFIED via PREFS_MAP + code)

`startupScreenEnabled` (via OMCFeatureEnabled), `startupScreenStyle` (@0),
`startupScreenVideoName`, `startupScreenDuration` (@5 s), `startupScreenScaleMode`
(@0 = Fill), `startupScreenSound` (@NO), `startupScreenSoundFile`,
`startupScreenSoundVolume` (@100, percent), `startupScreenSoundSkipCall` (@YES),
`startupScreenPlayFull` (@NO), `startupScreenTapToSkip` (@YES),
`startupScreenGreetingName`, `startupScreenCarName`, `startupScreenLogoEffect`
(@0), `startupScreenTempo` (@1), `startupScreenRandomSet`,
`startupScreenOccasions` (@YES), `startupScreenOccasionLog` (written),
`startupScreenBirthday` ("M-D" string). Read-only inputs from other modules:
`diagCar` (car name + probe data), `liteMode`, `carProfilesEnabled`,
`carProfiles`, `carProfileCurrent`.

## 8. Verification of names (coordinator action item)

Every import/class/superclass name used above was cross-checked against the
calibrated xref (`metadata/xref/OmniCarStartupScreen.json`, LC_DYSYMTAB
calibration delta +1, 215/215 votes): **5,275 import call sites compared,
5,275 agree, 0 disagreements**; the independent annotation audit likewise
found 0 wrong callee names in this module's dumps (only cosmetic missing
leading underscores on defined C symbols, and 10 explicit `objc_msgSend(?)`
unknowns — all the `processName` selector, e.g. in `__init_1` @0x1da8c; my
source uses `processName` there and cites none as unknown). The audit's
corrected-superclass table did not enumerate StartupScreen; the superclasses
here come from the same confirmed +1 mapping and are semantically forced
(SSSplashWindow is used with `initWithWindowScene:`/`windowLevel`;
SSStartupView's backing layer is driven as a CAGradientLayer).

## 9. What is NOT recovered (explicit unfinished list)

- **Cosmetic geometry/colour/physics constants** of the eight scene builders
  (ss_buildSky 5,168 B, ss_buildFestive 5,212 B, ss_buildBriefing 4,284 B,
  ss_buildLiquid 3,900 B, buildWeatherWithPeriod: 3,724 B, reload's colour
  branch table, ss_gaugeAt 2,592 B, ss_buildEngine 2,412 B, ss_buildParticles
  2,168 B): structure, elements, strings, symbols and animations are
  reconstructed; exact frames, RGB tables and curve constants are not
  transcribed. The per-function disassembly is the ground truth.
- `-[SSStartupView ss_host]` (0x10570-region accessor): purpose not
  determined; reconstructed as returning the scene container, flagged.
- Exact operands marked INFERRED in source: decode batch arithmetic
  (structure + the constant 3 are VERIFIED);
  `SSWeatherLoadCache` future-date guard form; weather-retry delay (the 10 s
  total and both log lines are VERIFIED); one-shot location timeout delay;
  `SSLocationOnce` one-shot fallback timing; greeting/condition text tables
  (helpers at 0xda28/0xdb60/0xdc18/0xd4f0/0xd6f0/0xf6ac — roles VERIFIED,
  tables not transcribed); `SSApplySampleData` sample values (shape VERIFIED:
  fills hud/nextEvent/batteryPercent/weather only when empty).
- The shared OMC core (75 functions in this binary, incl. `__init_1`
  @0x1da64) is reconstructed in the core deliverable, not duplicated here.

## 10. Function table (module-specific; 272 of 347)

Status: **VERIFIED** = body read at full/skeleton level with operands, or a
synthesized accessor (120 of the VERIFIED rows are accessors/dealloc/
.cxx_destruct). **INFERRED** = role/structure established from call sites,
strings and callers; body not read line-level (includes the big cosmetic
builders — structure VERIFIED, constants NOT-RECOVERED per §9).

| VA | Size | Function | Status |
|---|---|---|---|
| 0x44a8 | 64 | `-[SSLocationOnce locationManager:didUpdateLocations:]` | VERIFIED |
| 0x44e8 | 196 | `-[SSLocationOnce locationManager:didFailWithError:]` | VERIFIED |
| 0x45ac | 144 | `-[SSLocationOnce finish:]` | VERIFIED |
| 0x463c | 8 | `-[SSLocationOnce manager]` | VERIFIED |
| 0x4644 | 48 | `-[SSLocationOnce setManager:]` | VERIFIED |
| 0x4674 | 8 | `-[SSLocationOnce done]` | VERIFIED |
| 0x467c | 8 | `-[SSLocationOnce setDone:]` | VERIFIED |
| 0x4684 | 48 | `-[SSLocationOnce .cxx_destruct]` | VERIFIED |
| 0x46b4 | 3492 | `-[SSSplash initWithScreen:scene:style:occasion:framesDir:frameCount:fps:]` | VERIFIED |
| 0x5458 | 1452 | `sub_5458` | VERIFIED |
| 0x5a04 | 88 | `sub_5a04` | VERIFIED |
| 0x5a5c | 268 | `sub_5a5c` | VERIFIED |
| 0x5b68 | 188 | `sub_5b68` | VERIFIED |
| 0x5c24 | 780 | `-[SSSplash start]` | VERIFIED |
| 0x5f30 | 236 | `sub_5f30` | VERIFIED |
| 0x601c | 12 | `sub_601c` | INFERRED |
| 0x6028 | 8 | `sub_6028` | INFERRED |
| 0x6030 | 456 | `-[SSSplash decodeMore]` | VERIFIED |
| 0x61f8 | 168 | `sub_61f8` | VERIFIED |
| 0x62a0 | 228 | `sub_62a0` | INFERRED |
| 0x6384 | 48 | `sub_6384` | INFERRED |
| 0x63b4 | 48 | `sub_63b4` | INFERRED |
| 0x63e4 | 40 | `sub_63e4` | INFERRED |
| 0x640c | 40 | `sub_640c` | INFERRED |
| 0x6434 | 924 | `-[SSSplash refreshWeather]` | VERIFIED |
| 0x67d0 | 244 | `sub_67d0` | INFERRED |
| 0x68c4 | 40 | `sub_68c4` | INFERRED |
| 0x68ec | 8 | `sub_68ec` | INFERRED |
| 0x68f4 | 8 | `sub_68f4` | INFERRED |
| 0x68fc | 744 | `-[SSSplash tick]` | VERIFIED |
| 0x6be4 | 52 | `sub_6be4` | INFERRED |
| 0x6c18 | 400 | `-[SSSplash startCountdown]` | VERIFIED |
| 0x6da8 | 112 | `sub_6da8` | VERIFIED |
| 0x6e18 | 64 | `-[SSSplash tapped:]` | VERIFIED |
| 0x6e58 | 12 | `-[SSSplash dismiss]` | VERIFIED |
| 0x6e64 | 400 | `-[SSSplash dismissBecause:]` | VERIFIED |
| 0x6ff4 | 56 | `sub_6ff4` | INFERRED |
| 0x702c | 8 | `sub_702c` | INFERRED |
| 0x7034 | 432 | `-[SSSplash tearDown]` | VERIFIED |
| 0x71e4 | 8 | `-[SSSplash window]` | VERIFIED |
| 0x71ec | 48 | `-[SSSplash setWindow:]` | VERIFIED |
| 0x721c | 8 | `-[SSSplash style]` | VERIFIED |
| 0x7224 | 8 | `-[SSSplash setStyle:]` | VERIFIED |
| 0x722c | 8 | `-[SSSplash imageView]` | VERIFIED |
| 0x7234 | 48 | `-[SSSplash setImageView:]` | VERIFIED |
| 0x7264 | 8 | `-[SSSplash startView]` | VERIFIED |
| 0x726c | 48 | `-[SSSplash setStartView:]` | VERIFIED |
| 0x729c | 24 | `-[SSSplash screen]` | VERIFIED |
| 0x72b4 | 12 | `-[SSSplash setScreen:]` | VERIFIED |
| 0x72c0 | 8 | `-[SSSplash framesDir]` | VERIFIED |
| 0x72c8 | 8 | `-[SSSplash setFramesDir:]` | VERIFIED |
| 0x72d0 | 8 | `-[SSSplash frameCount]` | VERIFIED |
| 0x72d8 | 8 | `-[SSSplash setFrameCount:]` | VERIFIED |
| 0x72e0 | 8 | `-[SSSplash fps]` | VERIFIED |
| 0x72e8 | 8 | `-[SSSplash setFps:]` | VERIFIED |
| 0x72f0 | 8 | `-[SSSplash loop]` | VERIFIED |
| 0x72f8 | 8 | `-[SSSplash setLoop:]` | VERIFIED |
| 0x7300 | 8 | `-[SSSplash buffer]` | VERIFIED |
| 0x7308 | 48 | `-[SSSplash setBuffer:]` | VERIFIED |
| 0x7338 | 8 | `-[SSSplash decodeQueue]` | VERIFIED |
| 0x7340 | 48 | `-[SSSplash setDecodeQueue:]` | VERIFIED |
| 0x7370 | 8 | `-[SSSplash decoding]` | VERIFIED |
| 0x7378 | 8 | `-[SSSplash setDecoding:]` | VERIFIED |
| 0x7380 | 8 | `-[SSSplash queuedFrames]` | VERIFIED |
| 0x7388 | 8 | `-[SSSplash setQueuedFrames:]` | VERIFIED |
| 0x7390 | 8 | `-[SSSplash shownFrames]` | VERIFIED |
| 0x7398 | 8 | `-[SSSplash setShownFrames:]` | VERIFIED |
| 0x73a0 | 8 | `-[SSSplash failedFrames]` | VERIFIED |
| 0x73a8 | 8 | `-[SSSplash setFailedFrames:]` | VERIFIED |
| 0x73b0 | 8 | `-[SSSplash startTime]` | VERIFIED |
| 0x73b8 | 8 | `-[SSSplash setStartTime:]` | VERIFIED |
| 0x73c0 | 8 | `-[SSSplash displayLink]` | VERIFIED |
| 0x73c8 | 48 | `-[SSSplash setDisplayLink:]` | VERIFIED |
| 0x73f8 | 8 | `-[SSSplash finished]` | VERIFIED |
| 0x7400 | 8 | `-[SSSplash setFinished:]` | VERIFIED |
| 0x7408 | 8 | `-[SSSplash endReason]` | VERIFIED |
| 0x7410 | 8 | `-[SSSplash setEndReason:]` | VERIFIED |
| 0x7418 | 8 | `-[SSSplash shownAt]` | VERIFIED |
| 0x7420 | 8 | `-[SSSplash setShownAt:]` | VERIFIED |
| 0x7428 | 80 | `-[SSSplash .cxx_destruct]` | VERIFIED |
| 0x7478 | 48 | `sub_7478` | INFERRED |
| 0x74a8 | 1320 | `__init_0` | VERIFIED |
| 0x79d0 | 116 | `sub_79d0` | VERIFIED |
| 0x7a44 | 20 | `sub_7a44` | VERIFIED |
| 0x7a58 | 8 | `sub_7a58` | VERIFIED |
| 0x7a60 | 608 | `sub_7a60` | VERIFIED |
| 0x7cc0 | 80 | `sub_7cc0` | VERIFIED |
| 0x7d10 | 764 | `sub_7d10` | VERIFIED |
| 0x800c | 72 | `sub_800c` | VERIFIED |
| 0x8054 | 692 | `sub_8054` | VERIFIED |
| 0x8308 | 280 | `sub_8308` | VERIFIED |
| 0x8420 | 136 | `sub_8420` | VERIFIED |
| 0x84a8 | 16 | `sub_84a8` | INFERRED |
| 0x84b8 | 476 | `sub_84b8` | VERIFIED |
| 0x8694 | 60 | `sub_8694` | VERIFIED |
| 0x86d0 | 152 | `sub_86d0` | VERIFIED |
| 0x8768 | 208 | `sub_8768` | VERIFIED |
| 0x8838 | 64 | `sub_8838` | VERIFIED |
| 0x8878 | 108 | `sub_8878` | VERIFIED |
| 0x88e4 | 448 | `sub_88e4` | VERIFIED |
| 0x8aa4 | 208 | `sub_8aa4` | VERIFIED |
| 0x8b74 | 288 | `sub_8b74` | VERIFIED |
| 0x8c94 | 548 | `sub_8c94` | VERIFIED |
| 0x8eb8 | 16 | `sub_8eb8` | INFERRED |
| 0x8ec8 | 52 | `sub_8ec8` | INFERRED |
| 0x8efc | 16 | `sub_8efc` | INFERRED |
| 0x8f0c | 2136 | `sub_8f0c` | VERIFIED |
| 0x9764 | 800 | `sub_9764` | VERIFIED |
| 0x9a84 | 120 | `sub_9a84` | VERIFIED |
| 0x9afc | 80 | `sub_9afc` | VERIFIED |
| 0x9b4c | 44 | `sub_9b4c` | VERIFIED |
| 0x9b78 | 4 | `sub_9b78` | VERIFIED |
| 0x9b7c | 928 | `sub_9b7c` | VERIFIED |
| 0x9f1c | 128 | `sub_9f1c` | VERIFIED |
| 0x9f9c | 112 | `sub_9f9c` | VERIFIED |
| 0xa00c | 188 | `sub_a00c` | INFERRED |
| 0xa0c8 | 188 | `sub_a0c8` | VERIFIED |
| 0xa184 | 168 | `sub_a184` | VERIFIED |
| 0xa22c | 728 | `sub_a22c` | VERIFIED |
| 0xa504 | 136 | `sub_a504` | INFERRED |
| 0xa58c | 68 | `sub_a58c` | INFERRED |
| 0xa5d0 | 56 | `sub_a5d0` | INFERRED |
| 0xa608 | 20 | `sub_a608` | VERIFIED |
| 0xa61c | 148 | `sub_a61c` | VERIFIED |
| 0xa6b0 | 20 | `sub_a6b0` | VERIFIED |
| 0xa6c4 | 3848 | `sub_a6c4` | VERIFIED |
| 0xb5cc | 228 | `sub_b5cc` | VERIFIED |
| 0xb6b0 | 856 | `SSWeatherParse` | VERIFIED |
| 0xba08 | 88 | `sub_ba08` | INFERRED |
| 0xba60 | 144 | `sub_ba60` | INFERRED |
| 0xbaf0 | 684 | `SSWeatherLoadCache` | VERIFIED |
| 0xbd9c | 76 | `sub_bd9c` | INFERRED |
| 0xbde8 | 620 | `SSWeatherSaveCache` | VERIFIED |
| 0xc054 | 220 | `SSPeriodForDate` | VERIFIED |
| 0xc130 | 428 | `-[SSFade applyTime:]` | VERIFIED |
| 0xc2dc | 8 | `-[SSFade view]` | VERIFIED |
| 0xc2e4 | 48 | `-[SSFade setView:]` | VERIFIED |
| 0xc314 | 8 | `-[SSFade inA]` | VERIFIED |
| 0xc31c | 8 | `-[SSFade setInA:]` | VERIFIED |
| 0xc324 | 8 | `-[SSFade inB]` | VERIFIED |
| 0xc32c | 8 | `-[SSFade setInB:]` | VERIFIED |
| 0xc334 | 8 | `-[SSFade outA]` | VERIFIED |
| 0xc33c | 8 | `-[SSFade setOutA:]` | VERIFIED |
| 0xc344 | 8 | `-[SSFade outB]` | VERIFIED |
| 0xc34c | 8 | `-[SSFade setOutB:]` | VERIFIED |
| 0xc354 | 8 | `-[SSFade alpha]` | VERIFIED |
| 0xc35c | 8 | `-[SSFade setAlpha:]` | VERIFIED |
| 0xc364 | 8 | `-[SSFade rise]` | VERIFIED |
| 0xc36c | 8 | `-[SSFade setRise:]` | VERIFIED |
| 0xc374 | 8 | `-[SSFade outEase]` | VERIFIED |
| 0xc37c | 8 | `-[SSFade setOutEase:]` | VERIFIED |
| 0xc384 | 12 | `-[SSFade .cxx_destruct]` | VERIFIED |
| 0xc390 | 8 | `-[SSGauge arc]` | VERIFIED |
| 0xc398 | 48 | `-[SSGauge setArc:]` | VERIFIED |
| 0xc3c8 | 8 | `-[SSGauge fill]` | VERIFIED |
| 0xc3d0 | 48 | `-[SSGauge setFill:]` | VERIFIED |
| 0xc400 | 8 | `-[SSGauge needle]` | VERIFIED |
| 0xc408 | 48 | `-[SSGauge setNeedle:]` | VERIFIED |
| 0xc438 | 8 | `-[SSGauge number]` | VERIFIED |
| 0xc440 | 48 | `-[SSGauge setNumber:]` | VERIFIED |
| 0xc470 | 8 | `-[SSGauge max]` | VERIFIED |
| 0xc478 | 8 | `-[SSGauge setMax:]` | VERIFIED |
| 0xc480 | 8 | `-[SSGauge red]` | VERIFIED |
| 0xc488 | 8 | `-[SSGauge setRed:]` | VERIFIED |
| 0xc490 | 8 | `-[SSGauge shown]` | VERIFIED |
| 0xc498 | 8 | `-[SSGauge setShown:]` | VERIFIED |
| 0xc4a0 | 8 | `-[SSGauge hot]` | VERIFIED |
| 0xc4a8 | 8 | `-[SSGauge setHot:]` | VERIFIED |
| 0xc4b0 | 72 | `-[SSGauge .cxx_destruct]` | VERIFIED |
| 0xc4f8 | 96 | `-[SSLinkTarget step:]` | VERIFIED |
| 0xc558 | 24 | `-[SSLinkTarget owner]` | VERIFIED |
| 0xc570 | 12 | `-[SSLinkTarget setOwner:]` | VERIFIED |
| 0xc57c | 8 | `-[SSLinkTarget .cxx_destruct]` | VERIFIED |
| 0xc584 | 92 | `-[SSCanvasView drawRect:]` | VERIFIED |
| 0xc5e0 | 32 | `-[SSCanvasView owner]` | VERIFIED |
| 0xc600 | 20 | `-[SSCanvasView setOwner:]` | VERIFIED |
| 0xc614 | 16 | `-[SSCanvasView .cxx_destruct]` | VERIFIED |
| 0xc624 | 12 | `+[SSStartupView layerClass]` | VERIFIED |
| 0xc630 | 180 | `-[SSStartupView initWithFrame:]` | VERIFIED |
| 0xc6e4 | 80 | `-[SSStartupView dealloc]` | VERIFIED |
| 0xc734 | 704 | `-[SSStartupView clearContent]` | VERIFIED |
| 0xc9f4 | 2812 | `-[SSStartupView reload]` | VERIFIED |
| 0xd4f0 | 144 | `sub_d4f0` | INFERRED |
| 0xd580 | 368 | `-[SSStartupView ss_sceneColors]` | INFERRED |
| 0xd6f0 | 308 | `sub_d6f0` | INFERRED |
| 0xd824 | 516 | `-[SSStartupView buildGreetingWithDate:period:]` | INFERRED |
| 0xda28 | 312 | `sub_da28` | INFERRED |
| 0xdb60 | 184 | `sub_db60` | INFERRED |
| 0xdc18 | 196 | `sub_dc18` | INFERRED |
| 0xdcdc | 3724 | `-[SSStartupView buildWeatherWithPeriod:]` | INFERRED |
| 0xeb68 | 648 | `sub_eb68` | INFERRED |
| 0xedf0 | 268 | `sub_edf0` | INFERRED |
| 0xeefc | 532 | `-[SSStartupView layoutSubviews]` | VERIFIED |
| 0xf110 | 1436 | `-[SSStartupView applyUnit:]` | VERIFIED |
| 0xf6ac | 188 | `sub_f6ac` | INFERRED |
| 0xf768 | 1476 | `-[SSStartupView playIntro]` | VERIFIED |
| 0xfd2c | 84 | `sub_fd2c` | INFERRED |
| 0xfd80 | 12 | `sub_fd80` | INFERRED |
| 0xfd8c | 168 | `sub_fd8c` | INFERRED |
| 0xfe34 | 84 | `-[SSStartupView ss_now]` | VERIFIED |
| 0xfe88 | 108 | `-[SSStartupView didMoveToWindow]` | VERIFIED |
| 0xfef4 | 392 | `-[SSStartupView ss_startLink]` | VERIFIED |
| 0x1007c | 52 | `-[SSStartupView ss_stopLink]` | VERIFIED |
| 0x100b0 | 140 | `-[SSStartupView ss_step]` | VERIFIED |
| 0x1013c | 468 | `-[SSStartupView ss_applyTime:]` | VERIFIED |
| 0x10310 | 608 | `-[SSStartupView ss_clearScene]` | VERIFIED |
| 0x10570 | 540 | `-[SSStartupView ss_buildScene]` | VERIFIED |
| 0x1078c | 104 | `-[SSStartupView ss_host]` | VERIFIED |
| 0x107f4 | 212 | `-[SSStartupView ss_addCanvas]` | VERIFIED |
| 0x108c8 | 748 | `-[SSStartupView ss_label:at:size:weight:color:left:in:maxWidth:]` | VERIFIED |
| 0x10bb4 | 172 | `-[SSStartupView ss_fade:from:to:alpha:]` | VERIFIED |
| 0x10c60 | 144 | `-[SSStartupView ss_addMote:layer:to:]` | VERIFIED |
| 0x10cf0 | 1076 | `-[SSStartupView ss_applyMotes:]` | VERIFIED |
| 0x11124 | 5168 | `-[SSStartupView ss_buildSky]` | INFERRED |
| 0x12554 | 348 | `sub_12554` | INFERRED |
| 0x126b0 | 1000 | `-[SSStartupView ss_applySky:]` | VERIFIED |
| 0x12a98 | 2592 | `-[SSStartupView ss_gaugeAt:radius:label:unit:max:red:in:]` | INFERRED |
| 0x134b8 | 2412 | `-[SSStartupView ss_buildEngine]` | INFERRED |
| 0x13e24 | 148 | `sub_13e24` | INFERRED |
| 0x13eb8 | 168 | `sub_13eb8` | INFERRED |
| 0x13f60 | 504 | `-[SSStartupView ss_setGauge:value:]` | VERIFIED |
| 0x14158 | 556 | `-[SSStartupView ss_applyEngine:]` | VERIFIED |
| 0x14384 | 1608 | `-[SSStartupView ss_buildWelcome]` | INFERRED |
| 0x149cc | 428 | `sub_149cc` | INFERRED |
| 0x14b78 | 472 | `-[SSStartupView ss_applyWelcome:]` | VERIFIED |
| 0x14d50 | 2168 | `-[SSStartupView ss_buildParticles]` | INFERRED |
| 0x155c8 | 96 | `sub_155c8` | INFERRED |
| 0x15628 | 896 | `-[SSStartupView ss_drawParticles:t:]` | VERIFIED |
| 0x159a8 | 296 | `sub_159a8` | INFERRED |
| 0x15ad0 | 2676 | `-[SSStartupView ss_buildHud]` | INFERRED |
| 0x16544 | 796 | `sub_16544` | INFERRED |
| 0x16860 | 664 | `-[SSStartupView ss_applyHud:]` | VERIFIED |
| 0x16af8 | 4284 | `-[SSStartupView ss_buildBriefing]` | INFERRED |
| 0x17bb4 | 3900 | `-[SSStartupView ss_buildLiquid]` | INFERRED |
| 0x18af0 | 5212 | `-[SSStartupView ss_buildFestive]` | INFERRED |
| 0x19f4c | 960 | `-[SSStartupView ss_drawFireworks:t:]` | VERIFIED |
| 0x1a30c | 152 | `-[SSStartupView ss_drawCanvas:size:]` | VERIFIED |
| 0x1a3a4 | 16 | `-[SSStartupView style]` | VERIFIED |
| 0x1a3b4 | 16 | `-[SSStartupView setStyle:]` | VERIFIED |
| 0x1a3c4 | 16 | `-[SSStartupView image]` | VERIFIED |
| 0x1a3d4 | 64 | `-[SSStartupView setImage:]` | VERIFIED |
| 0x1a414 | 16 | `-[SSStartupView imageFits]` | VERIFIED |
| 0x1a424 | 16 | `-[SSStartupView setImageFits:]` | VERIFIED |
| 0x1a434 | 16 | `-[SSStartupView logoEffect]` | VERIFIED |
| 0x1a444 | 16 | `-[SSStartupView setLogoEffect:]` | VERIFIED |
| 0x1a454 | 16 | `-[SSStartupView name]` | VERIFIED |
| 0x1a464 | 12 | `-[SSStartupView setName:]` | VERIFIED |
| 0x1a470 | 16 | `-[SSStartupView weather]` | VERIFIED |
| 0x1a480 | 12 | `-[SSStartupView setWeather:]` | VERIFIED |
| 0x1a48c | 16 | `-[SSStartupView date]` | VERIFIED |
| 0x1a49c | 64 | `-[SSStartupView setDate:]` | VERIFIED |
| 0x1a4dc | 16 | `-[SSStartupView carName]` | VERIFIED |
| 0x1a4ec | 12 | `-[SSStartupView setCarName:]` | VERIFIED |
| 0x1a4f8 | 16 | `-[SSStartupView tempo]` | VERIFIED |
| 0x1a508 | 16 | `-[SSStartupView setTempo:]` | VERIFIED |
| 0x1a518 | 16 | `-[SSStartupView occasion]` | VERIFIED |
| 0x1a528 | 16 | `-[SSStartupView setOccasion:]` | VERIFIED |
| 0x1a538 | 16 | `-[SSStartupView hud]` | VERIFIED |
| 0x1a548 | 12 | `-[SSStartupView setHud:]` | VERIFIED |
| 0x1a554 | 16 | `-[SSStartupView nextEvent]` | VERIFIED |
| 0x1a564 | 12 | `-[SSStartupView setNextEvent:]` | VERIFIED |
| 0x1a570 | 16 | `-[SSStartupView batteryPercent]` | VERIFIED |
| 0x1a580 | 16 | `-[SSStartupView setBatteryPercent:]` | VERIFIED |
| 0x1a590 | 16 | `-[SSStartupView duration]` | VERIFIED |
| 0x1a5a0 | 16 | `-[SSStartupView setDuration:]` | VERIFIED |
| 0x1a5b0 | 964 | `-[SSStartupView .cxx_destruct]` | INFERRED |
| 0x1a974 | 664 | `SSApplySampleData` | VERIFIED |
| 0x1ac0c | 244 | `sub_1ac0c` | INFERRED |
| 0x1ad00 | 24 | `sub_1ad00` | INFERRED |
| 0x1ad18 | 48 | `sub_1ad18` | INFERRED |
| 0x1ad48 | 252 | `sub_1ad48` | INFERRED |
| 0x1ae44 | 288 | `sub_1ae44` | INFERRED |

## 11. Shared core functions present in this binary (75 of 347)

Reconstructed in the core deliverable (see the CarProbe handover note and the core module report); listed here for coverage completeness. Includes the core constructor `__init_1` @0x1da64 and the libroot/real-path cluster at 0x4000–0x44a8.

| VA | Size | Function |
|---|---|---|
| 0x4000 | 192 | `sub_4000` |
| 0x40c0 | 88 | `sub_40c0` |
| 0x4118 | 88 | `sub_4118` |
| 0x4170 | 316 | `sub_4170` |
| 0x42ac | 36 | `sub_42ac` |
| 0x42d0 | 180 | `sub_42d0` |
| 0x4384 | 292 | `sub_4384` |
| 0x1af64 | 12 | `OMCPrefsSync` |
| 0x1af70 | 104 | `OMCPref` |
| 0x1afd8 | 92 | `OMCEnabled` |
| 0x1b034 | 144 | `OMCFeatureEnabled` |
| 0x1b0c4 | 348 | `OMCLiteActive` |
| 0x1b220 | 1024 | `OMCCarWireless` |
| 0x1b620 | 452 | `OMCLogWrite` |
| 0x1b7e4 | 68 | `sub_1b7e4` |
| 0x1b828 | 68 | `sub_1b828` |
| 0x1b86c | 280 | `sub_1b86c` |
| 0x1b984 | 192 | `sub_1b984` |
| 0x1ba44 | 112 | `sub_1ba44` |
| 0x1bab4 | 44 | `sub_1bab4` |
| 0x1bae0 | 132 | `OMCLogRelayStart` |
| 0x1bb64 | 256 | `sub_1bb64` |
| 0x1bc64 | 180 | `OMCHasMethod` |
| 0x1bd18 | 328 | `OMCCarClass` |
| 0x1be60 | 1776 | `OMCCheckHooks` |
| 0x1c550 | 428 | `OMCMissingSelector` |
| 0x1c6fc | 52 | `sub_1c6fc` |
| 0x1c730 | 272 | `OMCCarLaunchInfo` |
| 0x1c840 | 4500 | `OMCCrashGuard` |
| 0x1d9d4 | 68 | `sub_1d9d4` |
| 0x1da18 | 76 | `sub_1da18` |
| 0x1da64 | 164 | `__init_1` |
| 0x1db08 | 44 | `sub_1db08` |
| 0x1db34 | 400 | `sub_1db34` |
| 0x1dcc4 | 48 | `sub_1dcc4` |
| 0x1dcf4 | 96 | `sub_1dcf4` |
| 0x1dd54 | 96 | `sub_1dd54` |
| 0x1ddb4 | 1156 | `sub_1ddb4` |
| 0x1e238 | 4 | `sub_1e238` |
| 0x1e23c | 48 | `sub_1e23c` |
| 0x1e26c | 576 | `sub_1e26c` |
| 0x1e4ac | 364 | `sub_1e4ac` |
| 0x1e618 | 4148 | `sub_1e618` |
| 0x1f64c | 752 | `sub_1f64c` |
| 0x1f93c | 112 | `sub_1f93c` |
| 0x1f9ac | 656 | `sub_1f9ac` |
| 0x1fc3c | 88 | `sub_1fc3c` |
| 0x1fc94 | 464 | `sub_1fc94` |
| 0x1fe64 | 1112 | `sub_1fe64` |
| 0x202bc | 1404 | `sub_202bc` |
| 0x20838 | 292 | `sub_20838` |
| 0x2095c | 148 | `sub_2095c` |
| 0x209f0 | 160 | `sub_209f0` |
| 0x20a90 | 644 | `sub_20a90` |
| 0x20d14 | 324 | `sub_20d14` |
| 0x20e58 | 20 | `sub_20e58` |
| 0x20e6c | 252 | `OMCExpired` |
| 0x20f68 | 12 | `OMCProfileKeys` |
| 0x20f74 | 12 | `OMCSupportedLanguages` |
| 0x20f80 | 920 | `OMCCurrentLanguage` |
| 0x21318 | 632 | `OMCTr` |
| 0x21590 | 148 | `OMCLogoMeshImage` |
| 0x21624 | 268 | `sub_21624` |
| 0x21730 | 544 | `sub_21730` |
| 0x21950 | 256 | `sub_21950` |
| 0x21a50 | 52 | `sub_21a50` |
| 0x21a84 | 20 | `sub_21a84` |
| 0x21a98 | 20 | `sub_21a98` |
| 0x21aac | 4 | `sub_21aac` |
| 0x21ab0 | 4 | `sub_21ab0` |
| 0x21ab4 | 4 | `sub_21ab4` |
| 0x21ab8 | 20 | `sub_21ab8` |
| 0x21acc | 20 | `sub_21acc` |
| 0x21ae0 | 20 | `sub_21ae0` |
| 0x21af4 | 20 | `sub_21af4` |

## Verifier-#6 fix addendum

Applied after independent verification (VERIFY_StartupScreen.md; the
verifier's own capstone disassembly via `verify/macho_truth.py`). Each
item was re-checked against that evidence before editing; no
contradiction was found. `ss_build*` scene builders were NOT touched
(closure agent's territory).

1. **startCountdown notify state = style + 1** (was: raw style).
   SSSplash.m `startCountdown` now publishes `(uint64_t)(_style + 1)`
   (`add x1, x20, #1` @0x6ca8); the consumer in SSStartupScreen.m
   (`SSPlayStopSoundtrack`, sub_8f0c) now recovers the style with
   `state - 1` and treats state 0 as the "unset" sentinel → pref
   fallback (`sub x0, x8, #1` @0x8f74). §3 countdown prose, the §6 IPC
   table row, and the SSStartupScreen.h channel comment updated to
   match. Materiality: as previously reconstructed, style 0 would have
   published the consumer's no-state sentinel and every other style
   would have decoded one lower.
2. **Style-0 non-loop countdown duration = 60.0** (was: INFERRED
   `frameCount / _fps`). SSSplash.m now uses the constant (cold block
   @0x6d94 sets `d8 = 60.0`, 0x404E000000000000); the spurious
   `_fps > 0` guard on that branch is gone. §3 prose updated.
3. **numberOfLoops mapping un-inverted** (was: `playFull ? -1 : 0`).
   SSStartupScreen.m now computes `playFull - 1`, exactly as the
   binary (`boolValue(startupScreenPlayFull) - 1` @0x91ac–0x91b0, no
   intervening write before `setNumberOfLoops:` @0x95ec): YES → 0
   (play once), NO → −1 (loop forever). §4 text updated and upgraded
   from INFERRED to VERIFIED.
4. **ss_setGauge:value: semantics** (SSStartupView.m body rewritten;
   comment in SSStartupViewScenesB.m's ss_buildEngine header and B's
   report notes corrected — see the note in StartupScreenB_REPORT.md):
   (a) needle rotation, the hot test and the number consume the RAW
   value; only `arc.strokeEnd` consumes the fraction clamped to [0,1]
   (fcsel pair @0x13f88–0x13f9c, `setStrokeEnd:` on `gauge.arc`
   @0x13fb8); (b) the number is `fcvtas(raw * max)` — round-to-nearest
   of the raw product (@0x140c4) — rendered as `round(value * max)`;
   (c) hot is `raw > red` (strict), and the fill gradient top becomes
   0xFF5C54 iff raw > red, else 0xFFFFFF (red loaded @0x14038, compare
   @0x14054, csel @0x14068), bottom stays 0x7FD3FF; (d) the invented
   `value / gauge.max` division is removed (no fdiv exists in the
   function); (e) strokeEnd now goes to `gauge.arc`, not
   `gauge.fill.mask`; (f) `>=` corrected to `>`. Needle sweep
   constants 3π/4 (@0x29050) and 3π/2 (@0x29068) were already right.
   NOT addressed here: the verifier's observation that ss_applyEngine's
   call sites pass `sweep * max * 0.62` into a fraction-scale
   ss_setGauge: — ss_applyEngine is an ss_apply* body (closure agent /
   integration recheck), left untouched by this fix pass.
5. **Placeholder constants resolved** (SSSplash.m): `kSSWindowLevelOffset`
   10.0 → **1000.0** (__const double @0x28dc8, added to
   UIWindowLevelAlert in sub_5458); `kSSDismissFadeDuration` 0.35 →
   **0.4** (__const double @0x28df0, loaded @0x6fc0 into
   animateWithDuration:; same constant as sub_8f0c's stop-fade). The
   NOT-RECOVERED labels are removed in source, in §3's window bullet,
   and from §9's INFERRED-operands list.
