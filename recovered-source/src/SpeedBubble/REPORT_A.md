# SpeedBubble — REPORT A (DISPLAY side)

Module: `OmniCarSpeedBubble.dylib` (649,808 B fat; arm64 slice 305,520 B,
UUID `75F5A408-8444-300B-B96E-68DA8AF9BFA5`). Filter: SpringBoard +
CarPlayApp + the four source apps. This report covers ONLY the display
side (SpringBoard / CarPlayApp processes): bubble window/HUD, 9 styles,
drag/pinch-resize, over-speed warning presentation, tap-to-reopen,
phone vs car rendering, and the CONSUME side of the inter-process
channels. The source-app side is agent B's report
(`SpeedBubbleB_REPORT.md`).

Sources written by A (all in `src/SpeedBubble/`):

| File | Contents |
|---|---|
| `SPPDisplayBoot.m` | `__init_0` (CarPlayApp opencar), `__init_2` + SpringBoard launch replacement, all notify handlers, speed consume decoder, source publish |
| `SPPBubble.m` | SPPBubble: intake/arbitration, refresh/hide lifecycle, renderBubble, gestures, long-press menu, window/geometry |
| `SPPBubbleView.m` | SPPBubbleView: state math, buildStyle:/renderStyle, over-limit flash, numberColor, applyColor: palette |
| `SPPViews.m` | SPPGlassView, SPPIconView, SPPSignView |
| `SPPPrefs.m` | SPPPrefs (all accessors) |
| `SPPOverspeed.m` | SPPOverspeed: evaluate/showFx/ensureWindow/dropWindow + glow renders |
| `SPPWarningSound.m` | Voice templates/lines, SPPSpeak, audio-session pair, SPPSoundDelegate, tone engine (all 6 WAV segment tables) |
| `SPPWindowFactory.m` | SPPGetCarPlayCADisplay, SPPMakeCarWindow, SPPMakeWindowPassThrough |

Disassembly: `src/SpeedBubble/disasm/` (495 functions, regenerated —
see Calibration). Tools: `src/SpeedBubble/tools/`.

## Partition overlap — ACTION FOR COORDINATOR

`__init_0` @0x44a8 and its opencar block sub_45b4 are claimed in BOTH
PARTITION_A.txt and PARTITION_B.txt (B: "constructors/control plane";
B also shipped an `SBOpenCar.m`). Evidence: `__init_0` is a no-op in
every process except `com.apple.CarPlayApp`, where it only registers
the `speedbubble.opencar` handler that opens an app on the car
dashboard — display-side behaviour under B's own tie-break rule
(source-app-process behaviour = B, SpringBoard/CarPlayApp HUD
behaviour = A). A reconstructed it in `SPPDisplayBoot.m`; the
coordinator should pick one copy and delete the other. No other
overlap: B does not claim any display class; A does not claim
`__init_1` @0x5950, the 0x5950–0xcb30 cluster, or SPPSpeedGPS's body.

## Calibration (verifier adjudication, 2026-11-08)

- The wave-1 parser's chained-fixup ordinal decoding is **off by one**
  (1-based vs dyld's 0-based); CONFIRMED by the independent verifier.
  Ground truth: `metadata/xref/OmniCarSpeedBubble.json` (calibration
  delta = 1, 201/201 votes) and `verify/macho_truth.py`.
- My first disassembly generation inherited the mislabelling and was
  **regenerated** (dumps' mtimes 2026-11-08 02:16–02:18 UTC). The
  verifier's audit of the CURRENT dumps: call annotations pass
  **8,476/8,476**. **All evidence cited in this report and in A's
  sources postdates the regeneration; anything from the
  pre-regeneration dumps is void.**
- 10 data slots were still wrong in the regenerated dumps. I patched
  all of them in `disasm/*.txt` (50 lines, exactly the audit's
  41 classref + 9 got occurrences), each tagged
  `[slot name corrected per ANNOTATION_AUDIT ground truth]`:

| Slot | Dump claimed | Ground truth | Where it matters |
|---|---|---|---|
| 0x43068 | UIBezierPath | **NSMutableDictionary** | buildStyle: parts/bits dicts; renderBubble icon cache |
| 0x43118 | UINotificationFeedbackGenerator | **UIScreen** | renderBubble icon scale |
| 0x43078 | NSMutableDictionary | **UIFont** | buildStyle: label fonts |
| 0x42f60 | NSString | **UIApplication** | sub_45b4, SPPBubble tapped:/ensureWindow |
| 0x43030 | UIColor | **CAShapeLayer** | shapePart:…, setMenuButton:off: slash |
| 0x430d0 | AVAudioSession | **NSMutableData** | _SPPPlayTone WAV assembly |
| 0x43198 | UIGraphicsImageRendererFormat | **NSTimeZone** | OMC shared region only (sub_2788c) — not A code |
| 0x392d8 / 0x398d8 | __NSConcreteGlobalBlock | **___CFConstantStringClassReference** | cfstring isa fields (cosmetic) |
| 0x43440 | _OBJC_CLASS_$_NSTimeZone | **__objc_empty_cache** | SPPSignView metaclass cache field, not a classref |
| 0x436b0 | ___objc_personality_v0 | raw 0xFFFFFFFFFFFFFFFF | not a pointer (×2) |

- Corrected superclasses (verifier addendum; independently reproduced
  with macho_truth): SPPPrefs, SPPOverspeed, SPPBubble,
  SPPSoundDelegate, SPPSpeedGPS → **NSObject** (wave-1 said NSRunLoop);
  SPPGlassView, SPPIconView, SPPSignView, SPPBubbleView → **UIView**
  (wave-1 said NSValue). A's sources use the corrected classes
  throughout; no A source file contained any of the wrong names
  (SPPWarningSound.m's SPPSoundDelegate superclass and protocol list
  came from the in-binary ObjC structs, which are reliable).
- Every `_OMC*` helper name used by A (_OMCPref, _OMCPrefsSync,
  _OMCFeatureEnabled, _OMCTr, _OMCCurrentLanguage, _OMCLogWrite,
  _OMCCrashGuard, _OMCMissingSelector, _OMCCarLaunchInfo,
  _OMCCheckHooks, _OMCProfileKeys, _OMCLiteActive, _OMCLogoMeshImage)
  is present in the calibrated xref function list. Channel names and
  the SPPPrefs keys `speedBubbleSource`, `speedBubbleSourceV2`,
  `speedBubbleWarnMode`, `speedBubbleWarnModeV2` were cross-checked
  against `metadata/IPC_MAP.md` and `metadata/PREFS_MAP.md` — no
  conflicts (PREFS_MAP independently attributes
  `+[SPPPrefs setWarnMode:]` as writer of WarnMode/WarnModeV2, matching
  the reconstruction).

## Channels — display side

### Consumed (all Darwin notify, handlers on the main queue)

| Channel | Handler | Payload / behaviour |
|---|---|---|
| `com.anlai.omnicar/speedbubble.speed` | sub_cec4 → `SPPConsumeSpeedNotification` | **Packed 64-bit state**: bits 0–7 limit byte, bits 8–15 speed byte, bit 16 speed-valid (clear → −1), bit 17 limit-valid (clear → −1), bit 18 source-app-foreground, bits 19–21 app index (0 Vietmap, 1 GOFA, 2 Waze, 3 Wyn). Dropped unless `[SPPPrefs appEnabled:app]` (selected source). Forwarded to `-[SPPBubble updateSpeed:limit:appForeground:app:]` |
| `com.anlai.omnicar/speedbubble.demo` | sub_cf78 | `-[SPPBubble runDemo]` (10 s synthetic demo) |
| `com.anlai.omnicar/speedbubble.resetlayout` | sub_cfc4 | `-[SPPBubble resetLayout]` |
| `com.anlai.omnicar/prefschanged` | sub_d010 | `-[SPPBubble refresh]` + `-[SPPOverspeed reloadPrefs]` |
| `com.anlai.omnicar/car.busy` | sub_d108 | state ≠ 0 → `-[SPPBubble setCarBusy:]` (car screen busy with Split Screen → bubble suppressed on car) |
| `com.anlai.omnicar/car.connected` | sub_d1cc | `-[SPPOverspeed carChanged]` now, and again after **+10 s** and **+30 s** (constant array @[@10, @30]) |
| `CarPlayIsConnectedDidChange` (NSNotification) | sub_d17c | `-[SPPBubble refresh]` |
| `com.anlai.omnicar/speedbubble.opencar` | sub_45b4 (**in CarPlayApp**) | state = app index → open that app on the CarPlay dashboard via `_currentDashboard` → `sharedApplicationLibrary` → `applicationInfoForBundleIdentifier:` → `DBEvent eventWithType:context:` (_OMCCarLaunchInfo) → `handleEvent:`; logs `CarPlay: mo %@` / `CarPlay: khong mo duoc %@ (dashboard=%@ info=%@)` |

Registrations happen in the SpringBoard
`applicationDidFinishLaunching:` replacement (sub_cc34), which also
publishes the selected source (below) and schedules one
`carChanged` at **+3.0 s**.

### Published by the display side

| Channel | Publisher | Payload |
|---|---|---|
| `com.anlai.omnicar/speedbubble.source` | sub_d088 (once, at SpringBoard launch) | state = `enabled ? [SPPPrefs source] : 0xFF` — tells source apps which one is selected |
| `com.anlai.omnicar/speed` | `-[SPPBubble setSpeed:]` (custom setter) | state = clamped current speed (−1 invalid, else min(v, 255)); deduplicated; suppressed during demo. **Consumer unknown to A** — flagging for the coordinator (not in B's partition either) |
| `com.anlai.omnicar/speedbubble.opencar` | `-[SPPBubble tapped:]` (car mode) | state = current app index; consumed by CarPlayApp (above) |

## Phone mode vs car mode (VERIFIED differences)

| Aspect | Phone | Car |
|---|---|---|
| Window | plain UIWindow on the main screen's UIWindowScene, frame = mainScreen.bounds | SPPMakeCarWindow: FBSDisplayConfiguration from the CarPlay CADisplay → UIRootSceneWindow; pass-through subclass (`SPPPassThrough_<Class>`, hitTest returns nil when the hit is the window itself) |
| Display chosen | no CarPlay CADisplay | CADisplay whose uniqueId matches AVExternalDevice.currentCarPlayExternalDevice.screenIDs[0] |
| Mode switch | fallback from car only after the display has been missing **3.0 s** (carLostAt debounce) | immediate when a display appears |
| Scale prefs key | `speedBubbleSizePhone` | `speedBubbleSizeCar` |
| Saved position | `_phoneFraction` | `_carFraction` |
| Orientation | window rotated to device orientation (0 / ±π/2), logs `bubble: iPhone xoay %.0f do` | none |
| Tap on bubble | opens the app on the phone (private `launchApplicationWithIdentifier:suspended:`) | posts `speedbubble.opencar`; CarPlayApp opens it on the dashboard |
| Overspeed FX window | never (SPPOverspeed requires a car CADisplay) | glow/flash window at UIWindowLevelStatusBar + 65, non-interactive |
| Default card centre constants | (52, 70) | (86, 170) (formula INFERRED) |

## Cadence / throttling summary (all VERIFIED)

- Refresh timer while shown: **0.5 s** (1.0 s in lite mode).
- Value staleness: speed/limit expire at **5 s** (refresh); keep-alive
  through invalid readings: **3 s** (updateSpeed); feedWarning
  freshness window **5 s**, stale timer **1 s**.
- Source arbitration: foreground "opened" debounce **1.5 s**;
  source-switch quiet period **2 s**; yield window **5 s**; state
  recency grace **90 s**.
- Overspeed re-arm: **5.0 s** continuously below threshold.
- Car-loss debounce **3 s**; car.connected re-checks at **+10 s/+30 s**;
  post-launch overspeed check **+3 s**.
- Menu auto-hide **4.0 s**; demo **0.5 s × 21 ticks ≈ 10 s**.
- Animations: show spring 0.45 s damping 0.5 (from scale 0.7); hide
  0.18 s (to scale 0.8); menu spring 0.3 s damping 0.85, out 0.18 s;
  warn shake 0.7 s; sign/flash pulse 0.5 s; glow pulses 0.7/1.6/0.45 s
  by fx; tap bounce 0.1 s.

## Math (display side, VERIFIED)

- Overspeed: `over ⟺ speed > limit + marginKmh` (strict), margin from
  prefs: default 5, rounded, clamped [−10, 10]. No smoothing/averaging
  anywhere on the display side; speeds are integer km/h end to end.
- Bubble scale: `savedScale = percent/100 × 0.9`; pinch clamps scale
  [0.54, 1.98] ≡ percent [60, 220]; prefs clamp percent [3, 220] but
  the pinch floor is 60.
- speedState: near-limit at ≥ 0.9 × limit (style 7: over at ≥ limit).
- speedRatio: speed/limit clamped [0, 1], default denominator 40.
- Tone engine: 22050 Hz, attack 0.012 s, exponential decay to 0.0008,
  peak-normalize 0.8, 16-bit PCM WAV.

## Per-function evidence table

Status key: **V** VERIFIED from the regenerated dumps · **I** INFERRED
(marked in source) · **N** NOT-RECOVERED (listed, not fabricated).

### Bootstrap (SPPDisplayBoot.m)

| Function | Addr | Status | Notes |
|---|---|---|---|
| __init_0 | 0x44a8 | V | CarPlayApp gate + crash guard + opencar registration; no-op elsewhere |
| sub_45b4 (opencar) | 0x45b4 | V | dashboard chain + both log lines; DBEvent type arg I |
| __init_2 | 0xcb30 | V | bundle gate com.apple.springboard, log, one MSHookMessageEx |
| sub_cc34 (launch repl.) | 0xcc34 | V | all registrations + source publish + 3 s dispatch_after |
| sub_cec4 (speed consume) | 0xcec4 | V | packed-state decode documented above |
| sub_cf78 / sub_cfc4 | 0xcf78 / 0xcfc4 | V | demo / resetlayout one-liners |
| sub_d010 (prefschanged) | 0xd010 | V | refresh + reloadPrefs |
| sub_d088 (source publish) | 0xd088 | V | state = enabled ? source : 0xFF |
| sub_d108 (car.busy) | 0xd108 | V | setCarBusy:(state != 0) |
| sub_d17c (CarPlayIsConnected block) | 0xd17c | V | refresh |
| sub_d1cc (car.connected) | 0xd1cc | V | carChanged + @[@10, @30] re-checks |
| sub_d300 / sub_d304 / sub_d354 | — | V | 4-byte thunks → sub_d308 |
| sub_d308 | 0xd308 | V | `[[SPPOverspeed shared] carChanged]` |

### SPPPrefs (SPPPrefs.m) — all V

enabled (feature flag), style 0–8 default 0 (`speedBubbleLook`),
showAppIcon default YES, size percent default 100 clamp [3, 220]
(round on write; setSizePercent does NOT post prefschanged — real
asymmetry), warnMode default 3 with V2-key migration (stored 2 →
V2 bool ? 2 : 3), setWarnMode writes both keys + posts prefschanged,
warnFx 0–3, warnVoice == 1 of 0–1, warnTone 0–5, warnVoiceLine 0–8,
warnVoiceText, color 0–6, warnMarginKmh default 5 clamp [−10, 10],
source with legacy remap (s<2 → s; 4 → 2; 2/3 → 0) and legacy per-app
bool fallback in which **Waze/Wyn keys are never consulted** (quirk
transcribed), appEnabled: == (source == app). Helpers sub_1edb0 /
sub_1f108 V.

### SPPOverspeed (SPPOverspeed.m) — all V except noted

| Function | Status | Notes |
|---|---|---|
| +shared / loadPrefs / reloadPrefs | V | speed=limit=−1, armed=YES at birth |
| updateSpeed:limit: | V | store + evaluate |
| carChanged | V | no car display → dropWindow; evaluate |
| evaluate @0x1f680 | V | clock = CFAbsoluteTimeGetCurrent; threshold strict >; 5 s re-arm; warnMode bits: 1 = visual, 2 = sound; fx 3 = bubble shake instead of window FX; no car display → no warning at all |
| showFx: @0x20198 | V | fx 0 red glow pulse 0.7 s, fx 1 orange 1.6 s, fx 2 full flash 0.45 s; hide animates 0.25 s |
| ensureWindow @0x1fab8 | V | level StatusBar+65; glow (1,0.23,0.19,α0.32 flash view); metrics struct field positions I |
| dropWindow @0x20050 | V | |
| glow image renders | V | red 122×122 loop (α = 0.6·t², lw 1.2, radius max(30−0.5i, 2)); orange 74×74 (lw 6, shadow blur 20, lw 2 highlight (1,0.55,0.55,0.9)) |
| red-glow getter wrapper | I | placement inside SPPOverspeed.m inferred |

### Warning sound/voice (SPPWarningSound.m) — all V except noted

Voice templates 0–7 (vi/en via _OMCTr), fun lines 3–7, line 8 =
custom text; `{L}` substitution, comma trim. SPPSpeak: synthesizer
singleton, stop-at-boundary 0 when speaking, volume 1.0, locale map
14 entries default en-US. Audio session prepare/release pair (the
refcount + saved-category restore structure I; log lines and calls V).
SPPSoundDelegate: three empty delegate methods + decode-error log —
V. _SPPPlayTone: all six segment tables V (freq/start/dur/wave/gain);
renderer math V; WAV cache per tone; AVAudioPlayer playback;
system-sound fallback writing `omc-speedbubble-tone-%ld.wav` to
NSTemporaryDirectory — V.

### Window factory (SPPWindowFactory.m)

| Function | Status | Notes |
|---|---|---|
| SPPGetCarPlayCADisplay @0x16ebc | V | AVExternalDevice → screenIDs[0] → CADisplay uniqueId match; every step guarded |
| SPPMakeCarWindow @0x172a8 | V flow | FBSDisplayConfiguration + UIRootSceneWindow; scale clamp [0.25, 4]; metrics field positions I; isMainDisplay arg I (NO) |
| SPPMakeWindowPassThrough @0x1789c + sub_179e0 | V | runtime subclass SPPPassThrough_<Class>; hitTest: self-hit → nil |

### SPPBubble (SPPBubble.m)

| Function | Addr | Status | Notes |
|---|---|---|---|
| +shared | 0x17ab4 | V | singleton via OMC once helper (written as dispatch_once) |
| setSpeed: (custom) | 0x17d64 | V | publishes `com.anlai.omnicar/speed`, dedup, clamp [−1, 255] |
| updateSpeed:limit:(appForeground:) | 0x18254/0x1825c | V | forwards |
| updateSpeed:limit:appForeground:app: | 0x18304 | V | full arbitration decoded (1.5 s opened, 2 s quiet, 3 s keep-alive, 5 s yield) |
| anyAppForeground | 0x182a4 | V | fg flag fresh < 5 s |
| sourceStopped: | 0x18100 | V | |
| sourceAppState | 0x1874c | V | returns −1/0/1 (−1 unknown, 0 dead-but-fg-fresh, 1 running); processState→isRunning tail I (0x18a34/0x18a74 exits) |
| feedWarning | 0x17e1c | V | 5 s freshness, 1 s stale timer |
| setCarBusy: | 0x19580 | V | |
| refresh | 0x18b24 | V | decision table in source; relative order of the state==0 dead-path vs the foreground gate I (actions V) |
| hide | 0x19630 | V | 0.18 s, blocks @0x19810/@0x19884 V (alpha→0, baseScaled:0.8; completion hides when alpha < 0.01) |
| speedState | 0x198cc | V | forwards to view |
| renderBubble | 0x1991c | V | icon chain incl. fallback tile; renderer `format:` arg I |
| SPPDrawIconTile (sub_1ea60) | 0x1ea60 | V outline | 3 colour branches (red components I), white 26 pt name |
| baseTransform / baseScaled: / savedScale / applySavedScale | — | V | 0.9 factor |
| setWarnShake: | 0x19e2c | V | 5 keyframes ±0.05235987755982988 rad, 0.7 s; shadow radius/opacity split from packed const I |
| runDemo | 0x1a448 | V | 0.5 s × 21 ticks; synthetic speed curve (helper sub_1a710) **N** — pattern in source marked I |
| resetLayout | 0x1a304 | V | |
| tapped: | 0x1ccfc | V behaviour | bounce depth + exact guard wiring of the two open mechanisms I |
| panned: | 0x1cb44 | V outline | start-center storage I (no spare ivar in the binary — likely a local/static) |
| pinched: | 0x1c910 | V | clamp [0.54, 1.98]; base-scale storage I |
| longPressed: | 0x1a7dc | V | 12 pt drag threshold; release → menu |
| showMenu | 0x1ac84 | V outline | shield α 0.02; panel shadow/radius 12/offset (0,6); logo item; composition I in part |
| menuButton: | 0x1b758 | V outline | 48×48, radius 18, symbols [minus, plus, exclamationmark.triangle, speaker.wave.2, xmark] @17 pt; symbol weight I; kind-5 → tag 104 I |
| setMenuButton:off: | 0x1b41c | V | "slash" CAShapeLayer + indigo tint 0.45 |
| menuTapped: | 0x1c0a8 | V | warn toggles (mask from tag), size ±10 clamp 220, tag 104 → quit; which of tags 0/1 is minus I |
| armMenuTimer / hideMenu / placeMenuAnimated: | — | V / V / V outline | 4.0 s; 0.18 s out; anchor math I |
| quitSourceApp | 0x1c600 | V | FBSSystemService terminate, description `OmniCar: user closed`; feedback type + reason args I |
| ensureWindow | 0x1d170 | V outline | 3 s car-loss debounce V; gesture wiring tail I; setLog: block V |
| startOrientationTracking | 0x1d94c | V outline | block → applyPhoneOrientationForce:NO |
| phoneRotation | 0x1db38 | V angles | sign assignment I |
| applyPhoneOrientationForce: | 0x1dbe0 | V | 0.01 rad deadband |
| defaultCardCenter | 0x1deb8 | V consts | formula I |
| save/restoreCardPosition | 0x1df64/0x1e098 | V | fractions clamped [0,1], <0 = unset |
| clampCard | 0x1e168 | V outline | margin = 1/displayScale I |
| applyCrispScale + sub_1e418 | 0x1e2f8 | V | recursive layer-tree contentsScale/rasterizationScale alignment, 0.001 tolerance |
| sub_19270 (strip shadows) | 0x19270 | V | lite mode |
| setLimit: and remaining accessors | — | V | synthesized (small accessor cluster) |

### SPPBubbleView + small views (SPPBubbleView.m / SPPViews.m)

| Function | Status | Notes |
|---|---|---|
| speedState @0xe91c | V | 0.9 near-limit rule; style 7 ≥ rule |
| stateColor @0xe9d4 | V | (255,179,64) / (255,90,95) / (74,79,128) |
| speedRatio @0xea58 | V | default denominator 40 |
| render @0x1585c / rebuild @0x158cc | V | style clamp 0–8 |
| buildStyle: @0xed04 | V framework, **PARTIAL** per style | teardown, dicts, flash scaffold, glass hidden for 5/8, indigo gradient, part-key inventory (20 keys) V; nearRing V; per-style frames/paths **N** in full — source assembles verified parts and marks the rest I |
| renderStyle @0x120c8 | V pipeline, **PARTIAL** layout | label/sign/icon updates, CATransaction, setOverLimitWarning:(state==2) (arg I), glass (4,4) + 76/38 consts, sign at (35,33) via sub_15268, ring 68.5/radius 34.25/arc start −1.5; helpers sub_152d8/153bc/15534/155f8/157dc/15814 roles **N** individually |
| setOverLimitWarning: @0x1148c | V | sppFlash/sppPulse 0.5 s pulses; from/to values I |
| numberColor @0x117a4 | **PARTIAL** | styles 2/4/5/6/8 special-cased; all literal colours V; full style×state matrix **N** |
| applyColor: @0x118f4 | V mechanism + palette | palette table @0x32C30 extracted byte-exact (6 accents); application-branch discriminators **PARTIAL** |
| shapePart:/addBit:to:/bit: | V outline | |
| sub_11150 gradient factory | V points | start (0.5,·) end (1,0.5) |
| sub_10fc8, sub_112a0, sub_1138c | **N** | small helpers in the view's range; roles not pinned |
| SPPGlassView init/setTop:bottom:/setCorner:/layoutSubviews | V outline | border/shadow/gradient constants V; bodies I |
| SPPIconView init/setShape:/layoutSubviews | V outline | bodies I |
| SPPSignView init/applyColors/setMuted:/layoutSubviews | V outline | bodies I |
| SPPBubbleView initWithFrame: | V outline | setUserInteractionEnabled: argument I |

## NOT-RECOVERED (explicit, not stubbed over)

1. Per-style (0–8) complete layout geometry in buildStyle:/renderStyle
   — part inventory, scaffolds and many constants are VERIFIED; the
   full coordinate sets are not line-transcribed.
2. numberColor's full style×state matrix.
3. applyColor:'s per-branch discriminator wiring (builtStyle vs
   speedState in the tail branches).
4. The demo's synthetic speed curve (helper sub_1a710).
5. SPPPassThrough metrics-struct field layout beyond the leading
   scale (positions INFERRED from use).
6. Consumer of `com.anlai.omnicar/speed` (published by SPPBubble) —
   outside A's partition; coordinator to assign.
7. Small helpers sub_10fc8 / sub_112a0 / sub_1138c / sub_152d8 /
   sub_153bc / sub_15534 / sub_155f8 / sub_157dc / sub_15814 —
   individually unpinned (their call sites are documented).

## Cross-side notes for the coordinator

- Consume format (above) is the contract B's publish side must match;
  B documents the publish format in `SpeedBubbleB_REPORT.md`.
- SPPPrefs is reconstructed once, in A's `SPPPrefs.m`; B's gating uses
  `+appEnabled:`/`+source` from the same class (single source).
- SPPSpeedGPS's body is B's; the display side only consumes the
  notify channel — no display-side instantiation of SPPSpeedGPS was
  found in A's ranges.


## Style-geometry closure addendum (wave 3, closure finisher)

Closes NOT-RECOVERED item 1 above (per-style layout geometry) and
most of item 7 (small helpers). Method: full line-by-line read of the
calibrated dumps for `buildStyle:` (0xed04) and `renderStyle`
(0x120c8) plus every helper they call; constants taken from
immediates and `__const` doubles in the instruction stream, with
three values re-extracted raw from the arm64 slice (file offset
16384 in the fat binary, vmaddr == in-slice offset): the style-8
tick-radii pair @0x32c20 = (57.0, 53.0), the gauge block's captured
divisor = 160.0 (immediate 0x4064000000000000 stored at 0x12858), and
the epilogue content sizes for styles 0/2/3. Evidence set copied to
`disasm/styles/` (17 dumps + README). The reconstruction now lives
in `SPPBubbleView.m`; `SPPBubble.m` needed no changes (it already
consumes contentSize/outlineRect/outlineCorner at lines 560–565).
No per-style display names exist — SPPPrefs and
FeatureSpeedBubble.plist expose the style as a bare number 0–8.

### Helpers resolved (item 7, mostly closed)

- sub_10fc8 = gradient-ring factory (CAGradientLayer + round-cap
  shape mask; conic vs linear colour sets) — was N, now VERIFIED.
- sub_11150 = SPPGradientColors3 (returns a CGColor array) — see
  contradiction 6 below.
- sub_112a0 = rounded Semibold font; sub_e318 = rounded Heavy font
  (+ feature settings, stubbed — see Residues); sub_e27c = label
  factory; sub_1138c = label shadow. All VERIFIED.
- sub_15268 = place-square (bounds + centre + setNeedsLayout);
  sub_152d8 = frame layer + set mask path; sub_153bc = unit label
  right-of-anchor (x/width/height VERIFIED, y INFERRED); sub_15534 =
  animated width change (>= 0.25 pt, 0x20004 options); sub_155f8 =
  5-colour gradient set. All VERIFIED.
- sub_157dc / sub_15814 are not functions: they are the invoke
  pointers of renderStyle's two style-8 stack blocks — angle(v) =
  150 + 240·min(max(v,0)/160, 1.04) degrees, and the polar point
  around centre (70,70).

### Per-style status

- **Style 0 — CLOSED.** Glass (4,16,100,100) corner 34; conic ring
  (line width 3) masked by oval (1.5,1.5,97,97); shine wedge
  (16,9,46,26) r13; number stack centred (52, 68) width 84; icon
  (11,107,22); sign (95,25,34); contentSize (120,118); fonts 34/10.
- **Style 1 — PARTIAL.** Strip layout closed: pad 41 (icon) / 24
  (no icon), number width max(ceil(fit), 52), bar at
  (leftPad+fitW+10, 14, 1.5, 32), sign centre (barRight+22, 30)
  size 44, glass height 60 corner 30, fonts 32/10. Residues: the
  status dot's frame was not isolated (written INFERRED, centred on
  the icon spot at 8×8); content height taken from the glass frame.
- **Style 2 — CLOSED.** Glass (4,4,76,76) corner 38 with state-2
  red / otherwise white@0.9 top-bottom; nearRing (0,0,76,76), oval
  (1.5,1.5,73,73), hidden unless state==1; stack centred (41,41)
  width 64; icon (10,10,20); sign (124,41,72) beside the disc;
  contentSize (160,80); fonts 30/10.
- **Style 3 — CLOSED.** Glass (0,0,104,104) corner 52; arc centre
  (52,52) r46 from 135° to 405° for track + gradient fill,
  fill.mask.strokeEnd = ratio animated over 0.6 s; stack centred
  (52,46) width 80; icon (10,12,20); sign (52,99,46); contentSize
  (104,122); fonts 33/10.
- **Style 4 — PARTIAL.** Card closed: glass (0,0,124,124) corner
  28, mesh gradient under the fill, state-tinted glass (state 1
  amber pair; state 0 lavender/mint @0.97), sheen/mesh hidden
  unless state==0, icon (23,23,22), sign (88,34,48), speed label
  (12,59,fitW,48) with unit right-of, track (12,106,100,6), fill
  white-on-cruise and width-animated, contentSize (124,124),
  fonts 40/10. Residues: mesh `locations` array STUB-UNRECOVERED
  (constant array @0x3ce30 not decoded); fillGrad.hidden condition
  and the state-2 glass bottom pairing are INFERRED from branch
  layout.
- **Style 5 — PARTIAL.** Bare digits closed: optional icon
  (10,10,20) pushing content down 24, speed label (0,topOff,fitW,52)
  at font 48, unit right-of, bar (0,topOff+55,92,5) with 3-colour /
  state-tinted gradient fill width-animated, sign centre
  (contentW+28, trackY−23) size 40, outline (0,0,W,H) corner 16,
  fonts 48/12. Residue: contentSize height not isolated (width
  contentW+40 VERIFIED).
- **Style 6 — PARTIAL.** Pill closed: sign (35,33,34), stack at
  (35,66) width 70, optional icon below (+26), glass (0,0,70,H)
  corner 35, ring masked by rounded rect (0.75,0.75,68.5,H−1.5)
  r34.25, glow outline sharing that path (violet at cruise, state
  colour otherwise), dark-navy glass from buildStyle, fonts 30/10.
  Residue: contentSize not isolated as immediates (written = glass
  size, INFERRED).
- **Style 7 — PARTIAL.** Strip closed: pad 34/10, icon (17,29,22),
  stack centred (pad+fitW/2, 29), ticks strip (contentW,17,61,24)
  whose mask is a loop of rounded bars (step 8, w5, h =
  14.88·(1−(x+2.5)/61), r1.5), gradient fill width-animated to
  ratio·61 over 0.9 s, sign centre (contentW+94, 29) size 34,
  glass height 59 corner 29, fonts 30/10. Residue: the total-width
  add chain (+69, +34, +4) is transcribed literally but its
  grouping is PARTIAL.
- **Style 8 — PARTIAL (minor residue).** Analogue gauge closed:
  140×140 radial face on the deco plate, conic ring r67, inner
  circle r64, ticks 0–150 step 10 (radii 57/53 → 61, labels at
  r43, 8 of 9 labels used), zone arc r63 from angle(limit) to
  angle(160) + limit tick r52→65 (hidden when limit<1 or ≥160),
  progress arc r49 150°→390° with strokeEnd =
  min((angle(speed)−150)/240, 1), needle triangle
  (59,67.8)/(117,70)/(59,72.2) rotated by angle(speed), hub r7,
  labels (30,86,80,28)/(40,112,60,11), icon (14,14,24), sign
  (131,125,66), contentSize (164,158), fonts 24/9. Residue: the
  alpha of the re-applied speed-label shadow colour is carried in
  a register whose per-state value was not isolated (0.7 written,
  matching buildStyle). The zone/limTick/needle red is written as
  (1, 0.2118, 0.45) per the dump annotations.

Cross-style epilogue (all styles): applyColor: is called with the
speed STATE; the flash view is framed in two families — styles
0/2/3/8 inset the plate frame by −6 with cornerRadius
min(content)/2, styles 1/4/5/6/7 use glass.bounds + glass.corner
(style 5's glass is hidden/unframed, so its flash frame is
degenerate — PARTIAL); outlineRect/outlineCorner = glass frame /
glass corner, except style 5 ((0,0,W,H), 16) and style 8 (deco
frame, width/2); then commit, contentSize, and finally
setOverLimitWarning:(state == 2).

### Contradictions with agent A's scaffolds (flagged, not silent)

1. **addBit:to: signature swapped.** A wrote `addBit:(id)bit
   to:(NSString *)key` storing into _bits. Truth (0xeb40):
   `addBit:(NSString *)key to:(UIView *)parent` — it CREATES a
   plain UIView, adds it to the parent, registers and returns it.
2. **shapePart:in:stroke:width: semantics.** A took a UIBezierPath
   as arg 2, set the path at build time and added the layer to
   self.layer. Truth (0xebe0): arg 2 is the parent CALayer
   (glass.layer / self.layer / deco.layer depending on style), and
   NO path is set at build — all paths are assigned in renderStyle.
3. **flashView colour permuted.** A's scaffold had (0.353, 0.373,
   0.373) with the third component "not pinned". Truth: (1,
   0.353, 0.373) — full red first component. Stacking also differs:
   flash goes INTO the glass for styles {1,4,6,7} and under it for
   {0,2,3,5,8}; A added both to self unconditionally.
4. **nearRing style and colour.** A placed nearRing in style 7
   with stroke (0.702, 0.251, 0.251). Truth: it belongs to style 2,
   stroke amber (1, 0.702, 0.251), width 3.
5. **Style 0 has no "face" part.** A's style-0 scaffold registered
   a "face" gradient bit; the binary builds a conic ring + shine
   layer in the glass's layer. ("face" exists only in style 8.)
6. **sub_11150 is not a gradient factory.** A described it as
   building a gradient layer with start (0.5,·), end (1,0.5).
   Truth: it returns the 3-colour CGColor array used as gradient
   colours; the horizontal (0,0.5)→(1,0.5) gradients in styles
   4/5/7 are built inline in buildStyle:.
7. **A's renderStyle constants conflated three styles.** The
   (4,4,76,76) glass is style 2 only; the 68.5×68.5 / r34.25
   rounded rect is style 6's ring mask, not a general ring; the
   "arc from −1.5 rad" matches nothing — style 3's arc runs
   2.356→7.069 rad (135°→405°). Style 0's glass is (4,16,100,100)
   corner 34, style 4's is 124×124 corner 28.
8. **buildStyle does not tint the glass indigo.** A's scaffold
   called [glass setTop:indigo bottom:indigo@0.55] for every
   style. In the decoded flow the indigo pair colours the LABELS;
   the glass keeps SPPGlassView's init gradient at build except
   style 6's dark-navy override. Glass tinting happens in
   renderStyle (styles 2/4) and applyColor:.
9. **setOverLimitWarning placement.** A's scaffold called it in
   the transaction prologue with an "INFERRED" argument. Truth:
   it is the final call of renderStyle, after commit and
   setContentSize, with argument (state == 2); the transaction
   prologue does not call it.
10. **applyColor:'s render-time argument.** A's applyColor:
    analysis covers the prefs-colour call path; the renderStyle
    epilogue passes the speed STATE (0/1/2) through the same slot
    (VERIFIED at 0x14de0/0x14f84), so palette indices 1/2 double as
    render-time tints. Source now notes this at both call sites.
11. **sub_15268 is generic.** A's SPPPlaceSign hard-coded (35,33)
    — those are style 6's sign coordinates only; the helper places
    both iconView and sign in every style.

### Still open after closure

- Two constant arrays in __objc_arrayobj did not decode with the
  tools at hand (their element layout is a repeating 24-byte
  constant-object pattern): the style-4 mesh `locations` (@0x3ce30)
  and the heavy font's feature-settings array (@0x3ce60). Both are
  marked STUB-UNRECOVERED in source; neither blocks the geometry.
- The small PARTIAL residues listed per style above (style 1 dot
  frame, style 4 fillGrad.hidden + state-2 bottom, style 5 content
  height, style 6 contentSize immediates, style 7 total-width
  grouping, style 8 shadow alpha, SPPPlaceUnitRightOf's exact y
  chain).
- Items 2–6 of the original NOT-RECOVERED list (numberColor
  matrix, applyColor: discriminators, demo curve, SPPPassThrough
  layout, `com.anlai.omnicar/speed` consumer) are untouched by
  this pass, as briefed.

---

## Phase-2 compile fix (wave 3, integration un-block)

Written by the phase-2 fix agent, 2026-11-08. All binary statements
below come from a FRESH capstone disassembly of
OmniCarSpeedBubble.dylib (own tooling; every name resolved through
verify/macho_truth.py only). This pass fixed the 12 errors recorded
in project/BUILD_PHASE1_LOG.md (BLOCKER-SB-NOTIFYARGS +
PENDING-VERIFIER) after verifier #4 lifted the embargo.

### 1. notify_register_dispatch arity — the binary's true tokens

All 7 calls in SPPDisplayBoot.m omitted `int *out_token`. The binary
passes a real pointer at every site; no site passes NULL:

| site | channel | out_token in binary |
|---|---|---|
| __init_0 @0x4570 | speedbubble.opencar | stack local, zeroed @0x4550 (`str wzr,[sp,#0xc]`), `add x1,sp,#0xc` @0x456c |
| sub_cc34 @0xcccc | speedbubble.speed | stack local sp+0xc |
| sub_cc34 @0xccec | speedbubble.demo | stack local sp+8 |
| sub_cc34 @0xcd18 | speedbubble.resetlayout | stack local sp+0 |
| sub_cc34 @0xcd3c | prefschanged | stack local sp+4 |
| sub_cc34 @0xcd70 | car.busy | **global @0x438a8** (`adrp x1,#0x43000; add #0x8a8`) |
| sub_cc34 @0xce08 | car.connected | **global @0x438ac** |

Source now mirrors this: four frame locals in
SPPAppDidFinishLaunching, `static int SPPBusyToken / SPPConnectedToken`
for the two __bss globals, a zero-initialised local in
SPPDisplayInitCarPlay. No token value is ever read back (handlers get
the token as the block argument) — matching the binary.

### 2. __init_0 / sub_45b4 dedupe — A vs B vs binary

| element | A (SPPDisplayBoot draft) | B (SBOpenCar draft) | BINARY (truth) |
|---|---|---|---|
| out_token | omitted | &static int | &stack-local int |
| index fallback | range check -> ids[0] | `(state & ~3) ? 0 : state` | `tst state,#~3` -> direct cfstring `@"vn.vietmap.live"`; else constant table `[state & 3]` via objectAtIndexedSubscript: @0x4604 |
| pre-check | none | none | responds(_currentDashboard) **and** responds(sharedApplicationLibrary) on the APP first; else ONE combined log `CarPlay: khong co _currentDashboard / sharedApplicationLibrary` @0x46b0, stop |
| library receiver | dashboard | **app** | **app** (`sharedApplicationLibrary` sent to UIApplication @0x4738) |
| info step | guarded | unguarded | guarded (MissingSelector @0x47b0) |
| _OMCMissingSelector | (module, name) | (object, SEL) | **(module, object, name)** — 3 args @0x46f4/0x47c0/0x48dc/0x48f4 |
| event class | objc_getClass("DBEvent") | objc_getClass("DBEvent") | **_OMCCarClass("DBEvent")** @0x47f8 |
| event type | 1 (INFERRED) | **4** | **4** (`mov w2,#4` @0x4830) |
| failure gate | per-step `opened` flag | `!dashboard \|\| !info` early | after unconditional `_OMCCarLaunchInfo(info)`: `!dashboard \|\| !launchInfo` -> `CarPlay: khong mo duoc %@ (dashboard=%@ info=%@)` @0x4890 |
| success log | only if handleEvent sent | after handleEvent | **unconditional** at end of gated path @0x4910 (`CarPlay: mo %@`) |

Verdict: neither draft matched; B held more of the load-bearing
semantics, A the guard structure and log strings. Canonical copy =
SPPDisplayBoot.m (display side owns the constructor per both
partitions), body rewritten to the binary on every point above.
SBOpenCar.m is reduced to a pointer note defining nothing; the
integration Makefile should drop it from the file list. Its
classref correction (slot 0x42f60 = UIApplication) is confirmed by
this pass's own decode and is reflected in the canonical text.

Side effect recorded for the coordinator: SPPDisplayBoot.m's extern
for _OMCMissingSelector is now the true 3-argument form. SPPBubble.m
and SPPOverspeed.m still declare the old 2-argument form — they
compile (their call sites match their own declarations) but the
declarations do not match the binary's function; left untouched by
this pass (outside its file scope), flagged here.

### 3. Import / unused-variable fixes

- SPPBubble.m: added `<objc/runtime.h>` (objc_getClass @284) and
  `<objc/message.h>` (objc_msgSend @288). The unused `weakSelf` in
  -ensureWindow was DELETED, not silenced: the binary's
  -ensureWindow @0x1d170 contains no objc_storeWeak/objc_destroyWeak
  at all (500-line dump checked), so the declaration was spurious.
- SPPPrefs.m: added `<notify.h>` (notify_post @109).
- SPPOverspeed.m: added `<objc/message.h>` (objc_msgSend @223).
  Fixing that surfaced two further errors the phase-1 log could not
  reach: SPPGlowImageOrange / SPPGlowImageRed were declared static
  but never defined (-Wundefined-internal). Bodies were written from
  agent A's own VERIFIED render transcription in this file's comment
  block, spot-verified against the binary in this pass: orange
  getter sub_1ff2c builds a UIGraphicsImageRenderer, applies
  resizableImageWithCapInsets:resizingMode: with all insets = 36.0
  and mode 1 (tile), caches into global @0x439f8; orange block
  sub_20b50 shows inset 3, radius 18, lineWidth 6 and 2, shadow blur
  20; red block sub_20d48 shows radius base 30, slope 0.5, floor 2.

### 4. Syntax-check results (this pass)

clang-18 -fsyntax-only, -target arm64-apple-ios15.0, iPhoneOS16.5
SDK, -fobjc-arc -fblocks -Wall -Werror (with the build's own
-Wno-error=arc-performSelector-leaks demotion and SBIntegrationShims.h
force-include): **all 15 module .m files pass with 0 errors** —
SPPDisplayBoot, SBOpenCar, SBScan, SBScanHelpers, SPPBubble,
SPPBubbleView, SPPOverspeed, SPPPrefs, SPPViews, SPPWarningSound,
SPPWindowFactory, SBFlutter, SBPublish, SBSourceHooks, SPPSpeedGPS.
The only remaining diagnostic in the module is SBScan.m:276's
-Warc-performSelector-leaks warning, demoted in the real build.

### 5. Micro-fix (follow-up): _OMCMissingSelector 3-arg form everywhere

The side effect flagged in §2 is now closed. The remaining 2-argument
declarations and call sites were corrected to the 3-argument form,
with the object argument taken from the binary at each site
(independently re-disassembled with capstone + verify/macho_truth.py;
the callee itself is DEFINED in the binary @0x2248c — LC_SYMTAB
_OMCMissingSelector — and retains all three arguments, logging
NSStringFromClass(object) + name via "THIEU METHOD (iOS %@): %@ ->
bo qua"):

- SPPBubble.m — extern updated; -sourceAppState @0x1874c sites:
  @0x187d0 passes controllerClass (x21, the SBApplicationController
  class from objc_getClass), @0x18854 passes controller (x19).
- SPPOverspeed.m — in-function extern updated; -ensureWindow @0x1fab8
  site @0x1fb7c passes display (x19, the _SPPGetCarPlayCADisplay
  result).
- SPPWindowFactory.m — extern updated; SPPDynSend passes its target
  (the binary inlines the idiom and passes the guarded receiver at
  all eight sites: GetCarPlayCADisplay @0x16f54/@0x16fcc/@0x17080/
  @0x17134, MakeCarWindow @0x174fc/@0x17588/@0x175ec/@0x1764c). The
  two direct sites pass cfgClass (@0x17358) and winClass (@0x17408):
  the binary there passes the alloc'd instance it probed (x21 =
  [FBSDisplayConfiguration alloc], x23 = [UIRootSceneWindow alloc]);
  the source probes the class via instancesRespondToSelector: and
  holds no alloc'd instance, so it passes the class — the callee's
  logged class name is identical either way. This mapping is noted
  in evidence comments at both sites.

Syntax check re-run on the three touched files with the §4 flag set:
SPPBubble.m, SPPOverspeed.m, SPPWindowFactory.m all pass with
0 errors.

Two observations left for the coordinator (NOT changed by this
micro-fix): (a) the binary's -sourceAppState has three further
_OMCMissingSelector sites with no source counterpart — @0x18978
(sbApp, @"isRunning"), @0x189a0 (sbApp, @"processState"), @0x18a88
(processState, @"isRunning") — the source models those guard
failures as silent branches; adding the log calls would change the
method's reconstructed flow, so it is flagged rather than folded
into a signature fix. (b) SBSourceGlobals.h:75 still declares
`extern void OMCMissingSelector(id object, SEL selector);` — agent
B's header; that symbol has no definition and no call site anywhere
in the module (the binary's function is _OMCMissingSelector).

### 6. Micro-fix 2 (follow-up): the three -sourceAppState log calls + the stale SBSourceGlobals.h declaration

Both §5 observations are now closed. Evidence is a fresh capstone
disassembly of -[SPPBubble sourceAppState] @0x1874c–0x18b24 (own
tooling; every name resolved through verify/macho_truth.py only).

The binary uses a double-probe idiom at three steps of
-sourceAppState: a first objc_opt_respondsToSelector decides the
path, then — after retaining the receiver and rebuilding the
selector string — a second respondsToSelector guards the actual
msgSend, and ITS failure logs _OMCMissingSelector and takes the
freshness tail (@0x18a1c: `return SPPAppFG[idx] ? 0 : -1`). The
source modelled only the first probe and stayed silent at all
three re-probe failures. The log calls are now added as nested
re-probes at exactly those branches (sends and returns unchanged):

| call site | reached from | arguments (registers at the call) | source tail |
|---|---|---|---|
| @0x18978 | 2nd probe @0x188d4 NO (1st @0x188ac YES) | x0 = @"SpeedBubble" (@0x38f78), x1 = x20 = sbApp, x2 = @"isRunning" (@0x3abb8) | FG tail @0x18a1c |
| @0x189a0 | 2nd probe @0x18938 NO (1st @0x18910 YES; its NO is the silent `return -1` @0x1895c) | x0 = @"SpeedBubble", x1 = x20 = sbApp, x2 = @"processState" (@0x3abd8) | x21 = 0 → nil-processState merge @0x189a8 → FG tail |
| @0x18a88 | 2nd probe @0x189f0 NO (1st @0x189c8 YES) | x0 = @"SpeedBubble", x1 = x21 = processState, x2 = @"isRunning" | FG tail @0x18a1c |

All three callees resolve to the defined _OMCMissingSelector
@0x2248c, same as the two sites already present (@0x187d0, @0x18854).

SBSourceGlobals.h: the stale line declared
`OMCMissingSelector(id, SEL)` — a symbol with no definition and no
call site anywhere. Includer check: SBFlutter.m, SBPublish.m,
SBScan.m, SBScanHelpers.m/.h, SBSourceHooks.m, SPPSpeedGPS.m —
none of them calls _OMCMissingSelector in either form (its real
callers — SPPBubble.m, SPPDisplayBoot.m, SPPOverspeed.m,
SPPWindowFactory.m — declare it per-file and do not include this
header). The header block's stated purpose is to declare the
OMCCommon interface this module was observed calling, and its
sibling entries (OMCCrashGuard, OMCCarLaunchInfo) are likewise
kept despite having no includer call sites; so the line was
CORRECTED, not removed: it now reads
`extern void _OMCMissingSelector(NSString *module, id object, NSString *selectorName);`
— the proven 3-arg form of the binary's real symbol @0x2248c.

Syntax check (the §4 flag set: clang-18 -fsyntax-only, -target
arm64-apple-ios15.0, iPhoneOS16.5 SDK, -fobjc-arc -fblocks -Wall
-Werror with the arc-performSelector-leaks demotion and
SBIntegrationShims.h force-include): SPPBubble.m and every
SBSourceGlobals.h includer (SBPublish, SBScan, SBScanHelpers,
SBFlutter, SBSourceHooks, SPPSpeedGPS) pass with 0 errors.
Tooling note: /usr/bin/clang-18 is currently absent on this VM
(a /usr rollback; the host's apt replay held the lists lock, so
fix-toolchain.sh could not reinstall) — the check ran on clang
18.1.3 extracted with dpkg-deb -x from the local apt archive cache
into /tmp/clang18, the identical upstream build; SBSourceHooks.m
additionally needed the theos vendor include/framework paths
(-I theos/vendor/include -F theos/vendor/lib), an include-path
matter unrelated to these edits.

---

## Final closure addendum (2026-11-08) — items 2, 3(a)–(d), 4 CLOSED

Closes phase-2 gaps 7, 8 and 14 (BUILD_PHASE2_LOG) and the SPPGlassView
half of gap 15. All statements from fresh line-reads of the calibrated
dumps in `disasm/` + raw `__DATA_CONST` storage decoded against the
arm64 slice; touched files pass `clang-18 -fsyntax-only`
(arm64-apple-ios15.0, iPhoneOS16.5 SDK, ARC): SPPViews.m, SPPBubbleView.m,
SPPBubble.m, SPPWindowFactory.m — all clean.

### Item 2 — the two "undecodable" constant arrays: RECOVERED IN FULL

The objects live in `__DATA_CONST,__objc_arrayobj` (section @0x3cd40).
Constant-object layouts, decoded empirically and consistent across
every object read: NSConstantArray = {isa, count @+0x08, element
buffer ptr @+0x10}; NSConstantDictionary = {isa, nominal 1 @+0x08,
entry count @+0x10, keys buffer @+0x18, values buffer @+0x20};
NSConstantIntegerNumber value @+0x10; NSConstantDoubleNumber value
@+0x08; CFConstantString = {isa, flags, cstr @+0x10, len @+0x18}.
Element buffers sit at 0x3c9e8+; the compiler dedupes identical
constant numbers across arrays. Nothing here was opaque — the earlier
"repeating 24-byte pattern" was the objects' own headers being misread
as elements.

- **Mesh locations @0x3ce30 = `[@0, @0.5, @0.5, @1]`** (IntegerNumber 0
  @0x3d098, DoubleNumber 0.5 @0x3cfc8 ×2, IntegerNumber 1 @0x3d0b0).
  Use site: `-[SPPBubbleView buildStyle:]` sends `setLocations:` to the
  mesh gradient @0xf6c8; the mesh has exactly 4 colours in source.
  `SPPBubbleView.m` style-4 block now sets the literal (STUB removed).
- **Font feature settings @0x3ce60 = `[ { CTFeatureTypeIdentifier: 6,
  CTFeatureSelectorIdentifier: 0 } ]`** (dict @0x3d140; keys are the
  CFStrings @0x3a238/@0x3a258, values IntegerNumbers @0x3d0c8/@0x3d098).
  Use site: SPPHeavyFont (sub_e318) loads the array @0xe3e0 as the
  value for the GOT-resolved import
  `_UIFontDescriptorFeatureSettingsAttribute` in a one-pair
  `dictionaryWithObjects:forKeys:count:` (@0xe3ec), then
  `fontDescriptorByAddingAttributes:` on the Rounded-design
  descriptor, falling back to the base descriptor when nil (@0xe398),
  then `fontWithDescriptor:size:`. Semantics cross-checked against
  the SDK header `CoreText/SFNTLayoutTypes.h`: type 6 =
  kNumberSpacingType, selector 0 = kMonospacedNumbersSelector —
  tabular digits, as previously inferred from purpose. `SPPHeavyFont`
  rewritten to the full verified body (STUB removed).

### Item 3(a) — numberColor @0x117a4: full matrix CLOSED

Transcribed from the dispatch @0x117c4–0x11854. Rows (builtStyle;
states 0/1/2): styles 0,1,3,5,7/default → indigo (74,79,128) / orange
(217,138,**0**) / red (240,50,58); style 2 → indigo / orange / white;
style 4 → indigo / white / white; styles 6,8 → white / amber
(255,213,138) / pink (255,138,141). Two errors in the old draft
corrected: its "muted red (217,138,141)" mixed components from two
different cells (binary blue = 0 via `fmov d2, xzr` @0x118a4), and its
{2,4,5,6,8} grouping was wrong. Method rewritten wholesale.

### Item 3(b) — applyColor: @0x118f4: all discriminators CLOSED

The decisive fact: the GATE and both tables index **self.color**
(fetched by `bl color` at entry), NOT the argument. Argument outside
the picture, style dispatch on builtStyle:

- self.color ∉ 1..6 → return, nothing changes (jump @0x11940).
- accent = palette[self.color] @0x32c30; accentDim = accent @
  alphaTable[self.color] @0x32c50 = [0, 0.94, 0.88, 0.92, 0.92, 0.92,
  0.92] — a table the old draft did not know existed (it used the
  accent at 0.55 for the glass/unit).
- builtStyle 8: colour 1 → nothing at all; else only
  `_parts[@"face"].colors = [accent, accent]`.
- builtStyle 5: argument 0 → speedLabel.textColor = accent and
  shadow = black (colour 1) / white (else); argument ≠ 0 → only
  shadow = white.
- default: tint = argument 1 → (255,179,64), argument 2 → (255,90,95),
  else accentDim; `[glass setTop:tint bottom:tint]` (both stops);
  `_parts[@"mesh"].hidden = YES` unconditionally (w2=#1 @0x11bb4);
  then argument ≤ 0 && colour == 1 → speed/unit labels indigo (unit
  @0.55) and stop; else speed = white, unit = white (argument ≥ 1) or
  white@0.75 (argument ≤ 0); if colour ≠ 1, enumerate the constant
  array @0x3ce48 = @[@"bar", @"ticks"] (same decoding technique as
  item 2) setting each bit's backgroundColor to white@0.28.
Method rewritten wholesale under ARC.

### Item 3(c) — demo curve: CLOSED (there is no curve helper)

sub_1a710 is not a helper; it is the release epilogue island of the
tick block sub_1a5e8 (block body 0x1a5e8–0x1a710). The full demo,
from `-[SPPBubble runDemo]` @0x1a448 and its block: 0.5 s timer;
tick pre-increments; ticks 1..20 send the OWNER ITSELF
`updateSpeed:(40 + 2·tick) limit:60` (speeds 42…80, crossing the
limit at tick 11); tick ≥ 21 invalidates the timer (the block's own
argument, before loading the owner), then in order setDemoTimer:nil,
setSpeed:−1, setLimit:−1, setSpeedAt:0, setLimitAt:0, setLastUpdate:0,
refresh. `-[SPPBubble runDemo]` rewritten (the old draft's
30 + (tick·7) % 90 curve, poked `_limit = 50` and SPPOverspeed routing
were wrong on every point), and the SPPBubble accessors the block
uses (limit/setLimit:, speedAt/setSpeedAt:, limitAt/setLimitAt:,
lastUpdate/setLastUpdate:, demoTimer/setDemoTimer: — all present in
the binary's class method list) are now declared in SPPBubble.m.

### Item 3(d) — SPPPassThrough metrics layout: CLOSED

`_SPPMakeCarWindow` @0x172a8 touches the metrics pointer exactly
once: `str d8, [x22]` @0x17720 — one double store at offset 0, on the
success path only. No loads, no other offsets. The layout is a
single in/out double at offset 0; the callers' 2.0 preset is never
read, and all further caller-side fields are dead padding.
`SPPWindowMetrics` in SPPWindowFactory.m reduced to the one live
field with the evidence recorded; SPPBubble.m's caller comment
corrected. While line-reading the callee, its scale derivation was
also closed and SPPMakeCarWindow rewritten: pointScale probe
(double) → if < 1.0, pixel path round-to-quarter (max currentMode
edge / max bounds edge, `frinta`) → if outside [1, 4], screen-scale
fallback (2.0 when screen scale < 1); the old draft's [0.25, 4.0]
clamp, its `window.screen.scale` log argument (the binary logs the
computed scale) and its `config` log argument on the window-failure
path (the binary passes the window) are corrected; isMainDisplay:NO
is VERIFIED (`mov w3, #0` @0x17324).

### Item 4 — SPPGlassView corner: CLOSED

Binary ivars: `_fill` @8, `_sheen` @16, `_corner` (double) @24.
`-setCorner:` @0xd7b8 (16 bytes) stores d0 to `_corner` and tail-calls
setNeedsLayout — it does NOT touch layer.cornerRadius (the old
INFERRED body did, and never wrote the ivar the synthesized getter
reads). `-layoutSubviews` @0xd7c8 transcribed: CATransaction with
actions disabled; `_fill.frame = bounds`, `_fill.cornerRadius =
self.corner`; `_sheen.frame = (0, 0, W, H·0.55)` (0.55 @0x327b8);
`self.layer.shadowPath` = rounded-rect bezier at self.corner.
SPPViews.m corrected (explicit `-corner` getter, ivar block,
verified setCorner:/layoutSubviews).

### Still open after this pass

Nothing from items 2–5 or 7 of the original NOT-RECOVERED list.
Item 1 (style geometry) was closed by the wave-3 addendum; item 6
(the `com.anlai.omnicar/speed` consumer) was closed by the channel
tracer — no consumer exists in the package. Item 7 (small helpers
sub_10fc8 … sub_15814) was not part of this closure task and keeps
its documented status.

---

## Item-7 micro-closure addendum (2026-11-08) — item 7 CLOSED

The module's last documented residue. Method: FRESH capstone
line-reads of all nine addresses (own tooling on
`verify/macho_truth.py` only; no prior dump consulted). Every
dump's decoded byte count equals its LC_FUNCTION_STARTS bound
exactly — 392 / 236 / 256 / 228 / 376 / 196 / 484 / 56 / 72 bytes,
no skipdata truncation. Call sites from an own `__text` bl-scan.
All nine helpers live in `SPPBubbleView.m`; that is the only file
touched, and it passes `clang-18 -fsyntax-only` under the §4 flag
set (arm64-apple-ios15.0, iPhoneOS16.5 SDK, ARC, -Wall -Werror,
SBIntegrationShims.h force-include) with 0 errors, 0 warnings.

### Per-helper verdicts

| addr | size | role (from the line-read) | verdict | source status |
|---|---|---|---|---|
| sub_10fc8 | 392 B | Gradient-ring factory: `[CAGradientLayer layer]`; flag (w0) ≠ 0 → type = kCAGradientLayerConic, start (0.5,0.5), end (0.5,0), colours = sub_155f8(); flag = 0 → start (0,0), end (1,1), colours = sub_11150(). Mask = CAShapeLayer, fill clear, stroke black, lineWidth = the d0 argument, lineCap = kCALineCapRound; `g.mask = mask`. Called ×5 from buildStyle: | VERIFIED | `SPPGradientRing` — faithful, unchanged |
| sub_112a0 | 236 B | Rounded Semibold font: systemFontOfSize:weight:Semibold → fontDescriptorWithDesign:Rounded → fontWithDescriptor:size:. **On nil design descriptor it falls back to the base fontDescriptor** (cbz @0x1130c → refetch @0x11320 — the SPPHeavyFont @0xe398 idiom). Called ×2 from buildStyle: | VERIFIED | `SPPRoundedFont` — **the nil fallback was missing; added** |
| sub_1138c | 256 B | Label shadow on (view, colour, radius): layer.shadowColor = colour.CGColor, shadowOffset = CGSizeZero, shadowRadius = radius, shadowOpacity = 1.0. Called ×2 from buildStyle: | VERIFIED | `SPPApplyLabelShadow` — exact, unchanged |
| sub_152d8 | 228 B | (layer, path, rect): layer.frame = rect; mask.frame = layer.bounds (fetched AFTER setFrame:); mask.path = path.CGPath. Nil-mask safe by nil-messaging. Called ×5 from renderStyle | VERIFIED | `SPPFrameMask` — exact, unchanged |
| sub_153bc | 376 B | Unit label right of anchor: w = ceil(sizeThatFits:(200,40).width) (frintp @0x15478); x = anchor maxX + 4; h = unit lineHeight; **y = baseline − unit ascender, baseline = anchor.minY + anchor.ascender + (anchor.height − anchor.lineHeight)/2** (@0x153f8 minY, @0x15418 +ascender, @0x15440–0x1544c +(h−lh)·0.5). Called ×2 from renderStyle | VERIFIED — **y upgraded from INFERRED** | `SPPPlaceUnitRightOf` — rewritten in the binary's literal term chain (the old INFERRED form midY + ascender − lh/2 is algebraically the same value; it had never been transcribed) |
| sub_15534 | 196 B | Animated width change: returns early when \|frame.width − width\| < 0.25 (fcmp/b.mi @0x15560–0x1556c); else animateWithDuration:duration delay:0 options:0x20004 (CurveEaseOut\|BeginFromCurrentState), completion nil. **Its block (invoke @0x15eb0, captures view + width) sets frame = (0, 0, width, view.superview.bounds.height)** — x/y zeroed @0x15ee4–0x15ee8, height = the superview-bounds height left in d3 by the bounds call @0x15edc. Called ×3 from renderStyle (the three fill bars) | VERIFIED | `SPPAnimateViewWidth` — **block body corrected**: the old draft kept the view's own origin/height, which the binary never reads |
| sub_155f8 | 484 B | 5-colour CGColor array — (0.6549, 0.5451, 0.9804), (0.3765, 0.7725, 0.9804), (0.3686, 0.8667, 0.7137), (0.9608, 0.6039, 0.7529), (0.6549, 0.5451, 0.9804), all alpha 1, via arrayWithObjects:count:5. Called from sub_10fc8 + ×2 from renderStyle | VERIFIED | `SPPGradientColors5` — exact element-for-element, unchanged |
| sub_157dc | 56 B | NOT a standalone function — invoke of renderStyle's style-8 angle stack block (built @0x12820–0x12864; signature `d16@?0d8`). Captures the divisor 160.0 (@0x12858). Computes 150 + 240·min(max(v,0)/160, 1.04): fmaxnm with 0, fdiv by the capture, fcsel cap 1.04 (@0x32be0), fmadd with 240.0 / 150.0 (@0x32be8) | VERIFIED | `SPPGaugeAngle` — exact, unchanged |
| sub_15814 | 72 B | NOT a standalone function — invoke of renderStyle's style-8 polar-point stack block (built @0x1286c–0x1289c; signature `{CGPoint=dd}24@?0d8d16`). Captures the centre 70.0 (@0x12888); takes **(radius, angleDeg) in that order**; θ = angle·π/180 (@0x32a78/@0x32a80), __sincos_stret @0x15840, returns (70 + r·cosθ, 70 + r·sinθ) | VERIFIED | `SPPGaugePoint` — semantics were exact; **parameter order swapped to the block's proven (radius, angleDeg)** and its 5 call sites updated |
| sub_11150 (sibling, rides with sub_10fc8) | 336 B | Independent 3-colour CGColor array — the same first three values as the 5-set (same __const slots @0x32930+), built by its own arrayWithObjects:count:3; never calls sub_155f8 | VERIFIED | `SPPGradientColors3` — **rewritten standalone** (was `[SPPGradientColors5() subarrayWithRange:(0,3)]`: equal values, wrong mechanism) |

Notes: (a) For sub_10fc8 the register evidence (flag in w0, width
in d0) cannot distinguish the declared parameter order of a static
(BOOL, double) helper — recorded as observed, no change made.
(b) sub_153bc's binary fetches anchor.frame three times and each
font twice; the source fetches once — pure getters, equivalent.
(c) No INFERRED marker remains anywhere in item 7; no helper's
body contradicted any previously closed item, so nothing outside
this item was touched.

**Item 7 is CLOSED. With this addendum, every item of the
original NOT-RECOVERED list (1–7) is closed.**
