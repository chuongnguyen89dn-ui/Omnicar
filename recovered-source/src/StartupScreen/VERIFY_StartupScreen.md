# VERIFY — OmniCarStartupScreen (non-scene core) — Verifier #6

Independent verification. All disassembly is my own (python3 + capstone
5.0.7), names resolved only through `verify/macho_truth.py` and
`metadata/xref/OmniCarStartupScreen.json`. No agent dump was used as
evidence. Scope: everything EXCEPT the `ss_build*`/`ss_apply*` scene
bodies (closure agent's territory).

**Counts: confirmed 25 claim-groups | downgraded 1 (C5, with 3 detail
errors) | wrong 5 | undeclared stubs 0** (within the disassembled scope;
the two placeholder constants in SSSplash.m are declared NOT-RECOVERED
in-source, and I resolved both — see §4).

## 1. Constructor / hook layer / IPC / presentation — CONFIRMED (1 wrong sub-item)

- `__init_0` @0x74a8 branches on bundle id. **SpringBoard branch**:
  Darwin-center observers `startupscreen.audio.play` → cb sub_79d0
  (@0x754c, flags w5=4), `…audio.stop` → cb sub_79d0 (@0x756c),
  `…weather.request` → cb sub_7a44 (@0x7590) — exact IPC_MAP sites;
  plus `notify_register_dispatch` on `com.anlai.omnicar/location`
  (token @0x3b15c, block @0x30868 → invoke sub_7a58, resolver-confirmed).
- **CarPlayApp branch**: `OMCCrashGuard(@"startupScreen")` gate (@0x7648),
  armed byte @0x3b168 set, then the module's **only** MSHookMessageEx
  @0x7684: `UIWindow` / `setHidden:` → replacement sub_8054, orig slot
  0x3b170 — row-for-row identical to HOOK_MAP. Then existing-screen
  logging and exactly five NSNotificationCenter block observers:
  UISceneWillConnect / UISceneDidActivate / UIScreenDidConnect /
  UIScreenDidDisconnect / UISceneDidDisconnect (GOT name symbols read
  directly @0x78e8–0x79a4).
- Hook replacement sub_8054: orig IMP called first through slot 0x3b170;
  gates in order: hidden==NO (tbnz @0x808c), armed byte, not
  SSSplashWindow (objc_opt_isKindOfClass). Classifier sub_a61c:
  `userInterfaceIdiom` cmp #3 (CarPlay) else `screen != mainScreen`
  — as reported. Block invoke sub_84a8 calls sub_84b8 with reason
  `@"sceneConnect"` (report's sceneActivate path also exists).
- Audio callback sub_79d0: CFStringCompare against the audio.play name
  → play flag → dispatch_async main → sub_8f0c. Stop takes the
  play=NO path. Confirmed.
- Weather flow: `-[SSSplash refreshWeather]` registers
  `weather.ready` via notify_register_dispatch @0x650c (block @0x309a8
  → invoke sub_8aa4, resolver-confirmed) and posts `weather.request`
  (notify_post @0x657c); SpringBoard side: sub_7a44 thunk → block
  @0x30a68 → invoke sub_9b78, which is literally `b sub_7d10`.
  10 s constant (0x2540BE400 ns) present in the timeout arm.
- **Duration default @5 CONFIRMED**: sub_5a04 =
  `MAX(OMCPref(@"startupScreenDuration", @5), 1.0)`; the default is an
  NSConstantIntegerNumber @0x34e10 whose value field (+16) is exactly 5.
- Presentation: window factory sub_5458 builds SSSplashWindow via
  `initWithWindowScene:` and sets `windowLevel = UIWindowLevelAlert +
  1000.0` (const double @0x28dc8 — see §4). Dismissal:
  `dismissBecause:` posts `…audio.stop` @0x6f64 (exact IPC_MAP site),
  endReason format `"%@ after %.1fs"`, fade via
  animateWithDuration: (duration §4).
- Superclasses (decoded from class structs via the resolver):
  SSSplash→NSObject, SSLocationOnce→NSObject, SSSplashWindow→UIWindow,
  SSStartupView→UIView, SSCanvasView→UIView — the report's corrected
  table is right.

### WRONG (in a [VERIFIED]-labelled body): the style notify state is style+1, not style
`-[SSSplash startCountdown]` (SSSplash.m, tagged [VERIFIED]) publishes
`notify_set_state(token, (uint64_t)_style)`. The binary @0x6ca8 does
`add x1, x20, #1` before `_notify_set_state` — the published state is
**style + 1**, and the consumer sub_8f0c recovers the style with
`sub x0, x8, #1` @0x8f74 (state 0 = "unset" sentinel → pref fallback).
The report §6 table ("state = style (NSInteger)") is likewise wrong.
Material: as reconstructed, style 0 would publish 0 (consumer's
no-state sentinel) and every other style would be decoded one lower.

## 2. SSSplash INFERRED items — labels appropriate; 2 operand contents refuted

Spot-checked 11 INFERRED functions from the §10 table: sub_601c,
sub_6028 (block copy/dispose helpers: objc_copyWeak/objc_destroyWeak
thunks), sub_63b4, sub_640c (block dispose helpers releasing captured
objects), sub_62a0 (decode-completion block invoke: setDecoding:,
buffer append / failedFrames++ / "cannot decode %@" / tail-call
decodeMore), sub_68ec (block invoke, captured-self retain), sub_702c
(block invoke → tearDown), sub_84a8 (block invoke → SSSceneLogAndHandle
@"sceneConnect"), sub_8efc (_Block_object_assign helper), sub_1ad00
(block invoke → drawInRect:), sub_1ae44 (CG drawing helper:
translate/rotate CTM + ellipse fills). All are exactly the block
machinery / helper roles the INFERRED labels claim. **Labels
appropriate for all 11.**

Two INFERRED *operands* in the prose/source are refuted in content
(honest labels, wrong guesses — the source bodies must change):

- **Style-0 non-loop countdown duration is the constant 60.0, not
  frameCount/fps.** startCountdown @0x6c38–0x6c44: style!=0 → pref
  duration; loop==YES → pref duration; style==0 && !loop → cold block
  @0x6d94 sets `d8 = 60.0` (0x404E000000000000). SSSplash.m's
  `duration = _frameCount / _fps; // [INFERRED …]` is wrong. (The
  frame-end dismissal in tick is separate and unaffected.)
- **numberOfLoops mapping is inverted.** sub_8f0c @0x91ac–0x91b0:
  `x20 = [OMCPref(@"startupScreenPlayFull", @NO) boolValue] - 1`, and
  no instruction writes x20 between there and `setNumberOfLoops:`
  @0x95ec on the play path. So PlayFull **YES → 0 loops, NO → −1**
  (infinite). SSSplash.m's/§4's `playFull ? -1 : 0` is backwards.

## 3. StartupScreen-B's five corrections

- **C1 (Rounded descriptor in SSRoundedFont, sub_f6ac) — CONFIRMED.**
  systemFontOfSize:weight: → fontDescriptor →
  fontDescriptorWithDesign: with the argument loaded from GOT
  @0x30240 = `_UIFontDescriptorSystemDesignRounded`; nil result falls
  back to the plain font (cbz @0xf710). The original's SSFont omits
  this step, as B says.
- **C2 (greeting = exactly 3 period cases) — CONFIRMED.** sub_155c8
  takes one integer, compares ==1 / ==0 / else, and calls OMCTr with
  en strings "Good afternoon" / "Good morning" / "Good evening"
  (period 1 = the "Good afternoon" branch, whose vi pair B decoded
  from the UTF-16 cfstring as "Chào buổi chiều"). No occasion
  parameter exists. The original's 4-case + occasion table is not in
  the binary.
- **C3 (weather symbols, sub_eb68) — CONFIRMED in full.** Night-clear
  = `moon.stars.fill` (day `sun.max.fill`); heavy-rain set is exactly
  {65, 67, 82}: cmp #0x52 (82) plus the merged test
  `(code & ~1) == 0x41` covering {65, 67}, both branching to the
  `cloud.heavyrain.fill` block; thunderstorm = `cloud.bolt.rain.fill`
  for code ≥ 95 (cmp #0x5f). The rest of B's table also reproduces
  exactly from my decode: rain bitmask 0x38007F over (code−61) with
  heavy taking priority → effective {61,62,63,64,66,80,81}; snow
  bitmask 0x0301FC00 over (code−61) → effective {71–77, 85, 86};
  drizzle 51–57; fog {45,48}; partly {1,2}; cloudy {3} + default.
- **C4 (sceneColors full table) — CONFIRMED.** All 11 pairs extracted
  from ss_sceneColors @0xd580 match B's table byte-for-byte:
  styles 4 (05070C,000000), 5 (020308,06070D), 6 (020309,070A18),
  7 (01050C,04121E), 8 (0C1A33,1F3A66), 9 (EEF0FB,F4F5FB);
  occasions 1 (5A0006,A3000F), 2 (1B0B3A,3B1A78), 3 (04121F,0B2A3D),
  4 (0A0A24,1D1446); default (020A24,0B1D4A) — including the
  compiler's shared-constant arithmetic (style 6 = 0x020308|1,
  occ-3 second = 0x0B1D4A+0xCF3, default first = 0x020308+0x71C).
  The original's two-blacks body is refuted.
- **C5 (gauge red-fraction semantics, ss_setGauge:value: @0x13f60) —
  DOWNGRADED: core correction right, three details wrong.**
  Right: the input is a fraction-scale value; `red` is compared
  against it as a fraction threshold (engine 0.8/0.9 consistent);
  `arc.strokeEnd` = the value clamped to [0,1] (fcsel pair
  @0x13f88–0x13f9c, setStrokeEnd: on the object returned by
  `gauge.arc` @0x13fb8); needle sweep constants are exactly
  3π/4 (@0x29050 = 2.356194490192345) and 3π/2 (@0x29068 =
  4.71238898038469); fill bottom stays 0x7FD3FF.
  Wrong/imprecise in B's adjudication:
  (a) needle rotation, hot, and the number all consume the **raw**
  value, not the clamped fraction — fmadd @0x13fd4 reads d8 (raw),
  fcmp @0x1403c reads d8, fmul @0x140c4 reads d8. (In-range inputs
  make this moot; out-of-range inputs diverge.)
  (b) the number is `fcvtas(raw * max)` — round-to-nearest of the
  raw product — not `(NSInteger)(frac * max)` (no truncation, no
  clamped operand).
  (c) B report §3's "fill gradient top becomes 0xFF5C54 only when
  the unclamped value > 1" is **refuted**: @0x14038 loads red into
  d9, @0x14054 compares raw vs red, and the csel @0x14068 picks
  0xFF5C54 iff **raw > red** (else 0xFFFFFF).
  Related: the original agent's own ss_setGauge body
  (SSStartupView.m:671, "[VERIFIED shape]") additionally invents a
  `value / gauge.max` division (no fdiv exists in the function),
  sets shown from the raw value without the ×max, sends strokeEnd
  to `gauge.fill.mask` instead of `gauge.arc`, and uses `>=` where
  the binary uses strict `>`. B did not rewrite this body; it still
  needs the fix at integration.
  Observation for the coordinator: the original's ss_applyEngine
  call sites pass `sweep * max * 0.62` into ss_setGauge:, which is
  inconsistent with the binary ss_setGauge expecting fraction-scale
  input — ss_applyEngine is an apply* body outside this scope, but
  one of the two reconstructions must be rechecked at integration.

## 4. Constants the agents left NOT-RECOVERED — resolved here

Both are honestly labelled placeholders in SSSplash.m; the values are
plain __const doubles and are now pinned for the integration fix:
- `kSSWindowLevelOffset`: source placeholder 10.0 → **truth 1000.0**
  (double @0x28dc8, added to UIWindowLevelAlert in sub_5458).
- `kSSDismissFadeDuration`: source placeholder 0.35 → **truth 0.4**
  (double @0x28df0, loaded @0x6fc0 into animateWithDuration: — the
  same constant the soundtrack stop-fade uses in sub_8f0c).
