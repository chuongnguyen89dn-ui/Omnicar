# StartupScreen-B Report — takeover of the unwritten remainder (2026-11-08)

Agent B (takeover) for module `OmniCarStartupScreen.dylib`. Protocol followed:
disk inventoried first, claim written to `CLAIM_B.txt` before any source,
disk re-checked before writing (unchanged — the original agent had written
nothing new since its 02:31–02:38 UTC files), no original-agent file was
overwritten or edited.

## 1. What was already written when B arrived

The original agent had already produced, at structural fidelity:

- `SSStartupScreen.h` (241 lines), `SSStartupScreen.m` (38,991 B),
  `SSSplash.m` (19,525 B), `SSStartupView.m` (42,670 B),
  `StartupScreen_REPORT.md` (32,492 B)
- `disasm/` — 347 annotated dumps + `_index.json` + `_skeletons_all.txt`

So the "unwritten remainder" was **not** whole files: it was the line-level
detail behind the original report's §9/§10 INFERRED / NOT-RECOVERED items,
concentrated in the SSStartupView scene/text-builder family. B claimed
exactly that seam (see `CLAIM_B.txt`).

## 2. What B delivered

- **`SSStartupViewScenesB.m`** (new file; a `SSStartupView (ScenesB)`
  category + file-static helpers, explicitly marked to supersede the
  corresponding structural bodies in `SSStartupView.m` at integration).
  Passes `clang-18 -fsyntax-only` against iPhoneOS16.5 SDK with 0 errors
  (only "method not found" warnings for the private `ss_host` / `ss_label:`
  / `ss_fade:` helpers that live in the original agent's class extension).
- **`disasm/B/`** — copies of the 61 dumps covering every claimed address.
- This report.

## 3. Per-item status (claimed items)

### Fully reconstructed at line level — VERIFIED from machine code
| Item | VA | Notes |
|---|---|---|
| sub_d6f0 `SSPairColors` | 0xd6f0 | packed RGB pair → CGColor array, /255.0 |
| sub_d4f0 `SSWeatherCategory` | 0xd4f0 | incl. 26-entry jump table @0x295f0 + mask 0x0339FC7F |
| sub_da28 `SSSceneLabel` | 0xda28 | label factory; shadowOpacity 0.22, minScale 0.45, resistance 250/H |
| sub_f6ac `SSRoundedFont` | 0xf6ac | Rounded descriptor — see contradiction C1 |
| sub_13e24 `SSTrimmed` | 0x13e24 | nil-safe trim |
| sub_155c8 `SSPeriodGreetingText` | 0x155c8 | exactly 3 cases — see C2 |
| sub_db60 `SSGreetingWithName` | 0xdb60 | |
| sub_dc18 `SSDateLineText` | 0xdc18 | template `EEEEdMMMM`, locale `OMCCurrentLanguage()` |
| sub_13eb8 `SSNameFormatted` | 0x13eb8 | format-if-name-nonempty |
| sub_eb68 `SSWeatherSymbolAndText` | 0xeb68 | full WMO table — see C3 |
| sub_edf0 `SSTemperatureText` | 0xedf0 | NSMeasurementFormatter, medium, 0 fraction digits |
| sub_12554 `SSRadialGlowLayer` | 0x12554 | radial gradient, start (0.5,0.5) end (1,1) |
| sub_149cc `SSPathGlowLayer` | 0x149cc | welcome's block invoke; glow shadow 0.95 / radius 15u |
| sub_159a8 `SSHSLToRGB` | 0x159a8 | pure math; h wrap via floor(h/360) |
| `ss_sceneColors` | 0xd580 | full style+occasion pair table — see C4 |
| `buildGreetingWithDate:period:` | 0xd824 | time/title/date labels into `_stack` |
| `buildWeatherWithPeriod:` | 0xdcdc | full tree transcribed (§4) |
| `ss_gaugeAt:radius:label:unit:max:red:in:` | 0x12a98 | full; tick-parity assignment INFERRED (marked) |
| `ss_buildEngine` | 0x134b8 | gauges + lamp table (§4) + title/ready; label-anchor ivar pairing INFERRED (marked) |
| `ss_buildWelcome` | 0x14384 | structure + constants VERIFIED; wave point table @0x294b0 not transcribed (marked PARTIAL inline) |

### Bonus adjudication (not claimed, needed to close the engine decode)
- `ss_setGauge:value:` @0x13f60 read in full: the value is a **fraction**;
  only `arc.strokeEnd` consumes it clamped to [0,1]. The needle rotation,
  the hot test and the number consume the **raw** value: needle rotation =
  `raw * 3π/2 + 3π/4` (Z axis; fmadd @0x13fd4 reads raw); `hot = raw >
  gauge.red` (strict) — so `red` IS a fraction threshold and engine's
  0.8 / 0.9 are consistent; fill gradient top becomes 0xFF5C54 iff
  **raw > red** (else 0xFFFFFF), bottom stays 0x7FD3FF; number text =
  `fcvtas(raw * max)` (round-to-nearest) via `"%ld"`. [**Corrected by
  verifier #6** — the first version of this note wrongly fed the clamped
  fraction to the needle, the hot test and the number, and tied 0xFF5C54
  to raw > 1.] This resolves the apparent contradiction between the
  engine call sites and the original agent's structural `ss_setGauge:`
  description (its "value >= red" phrasing, invented value/max division
  and fill-mask strokeEnd are all refuted; semantics now pinned).

### PARTIAL — verified skeleton, body deliberately not written
`ss_buildSky` 0x11124, `ss_buildParticles` 0x14d50, `ss_buildHud` 0x15ad0,
`ss_buildBriefing` 0x16af8, `ss_buildLiquid` 0x17bb4, `ss_buildFestive`
0x18af0. B extracted and verified each one's call order, literal strings
and data flow (§5) but did not transcribe ~5,900 lines of layout code;
writing plausible bodies would violate the no-fake-completion rule. These
six remain the module's only scene-builder residue.

### Claim corrections discovered while working (wave-1 function list)
- `sub_12af8` is **not a separate function** — the address lies inside
  `ss_gaugeAt:`'s body (0x12a98 + 2,592 B).
- `sub_c8c8 / sub_cbb4 / sub_cc60 / sub_ccf0` are **basic-block islands of
  `-[SSStartupView reload]` itself** (0xc9f4…0xd4f0), not helpers: they are
  reload's clear-state tail and its per-style tempo-scale switch (fragments
  recovered: base tempo factor 3.6; style 3 → 3.0; style 5 → ×4 then ×3.6;
  style 9 → 2.7 / 2.2; default → 2.5; style 0 → black/black backdrop pair).
  No separate reconstruction is owed for them.
- The "helper" addresses inside the big builders' spans (sky 115c8,
  11628, 119a8, 11ad0, 12544; briefing 16c0c…17ae0 range; liquid 17c64…
  18840; festive 199d4…19db4; hud 16974) are likewise **islands of their
  parent builders**, not separate functions.
- `sub_109cc` is the **tail island of `ss_label:at:size:weight:color:left:in:maxWidth:`**;
  it adds exact constants to that VERIFIED method: label shadowOpacity
  0.4 (float @0x29428), shadowRadius max(unit*7, 1), shadowOffset zero,
  layer shouldRasterize YES with rasterizationScale = traitCollection
  displayScale (2 if 0), sizeThatFits with unbounded width, bounds height
  clamped to ≥ 10, left-aligned labels shifted −6u / −12u.
- `sub_10d50` is the **mote-animation core** (per-frame updater over the
  packed mote records in `_motes`, stride 0x38: kind + 5 doubles): kinds
  0–7 verified at formula level (wrap-around drift via floor-div fmod,
  sine opacity for kind 1, sine wobble ×10/×20 for kinds 4/6, rotation
  transforms for kinds 5/6, bottom-up wrap for kind 7). Its parent method
  boundary (prologue) was not recovered — it is an island of the scene
  tick function, not a standalone C function.
- `-[SSStartupView .cxx_destruct]` @0x1a5b0: standard ivar release sweep;
  the original agent's class file already covers the class — nothing owed.

## 4. Headline decoded data

**buildWeatherWithPeriod: layout tree** — `_stack` (vertical, alignment
center) = [title, `_row`, updated]; `_row` (horizontal, center) =
[symbol image view (ivar slot 0x3acc4, the header's `_logoView`), temp,
card]; card = UIVisualEffectView blur style **16**, border white α0.22 /
0.5 pt, content bg black α0.18, cornerCurve continuous; `_cardStack`
(vertical, alignment leading) = [cond, range, rain] with insets
12 / 12 / 8 / 8; the three card labels get `textAlignment = 4` (natural);
symbol config = pointSize 44, weight 4, multicolor preferred, fallback
symbol `cloud.fill`; icon pinned 30×30 (`_iconW`/`_iconH`); range line =
`↑ <hi>` / `↓ <lo>` joined by 3 spaces, hidden when both absent; rain line
= `"%@ %ld%%"` with OMCTr("Khả năng mưa", "Chance of rain"), hidden when
absent, α0.9; title α0.92; updated line α0.65, text
OMCTr("Cập nhật lúc %@", "Updated %@") with dateStyle = NOT isDateInToday,
hidden unless the stored `date` is an NSDate that formats non-nil.

**Engine warning-lamp table** (static @0x355c0, decoded from the constant
object graph in `__data`; each entry = [candidate symbols, packed RGB]):

| # | Color | Candidate SF Symbols |
|---|---|---|
| 0 | 0xFFB400 | fuelpump.fill |
| 1 | 0xFF5C54 | minus.plus.batteryblock.fill, minus.plus.batteryblock, bolt.fill |
| 2 | 0xFFB400 | exclamationmark.triangle.fill |
| 3 | 0xFFB400 | *(none — always the @"ABS" text fallback)* |
| 4 | 0xFFB400 | engine.combustion.fill, exclamationmark.circle.fill |
| 5 | 0x50C8FF | headlight.high.beam.fill, light.max |

Lamp fade: outA = 1.4 + 0.12·i, outB = 1.7 + 0.12·i; symbol config
pointSize max(30u, 6), weight 7; icon shadowOpacity 0.7, radius 5u.
Title fade 2.2 → 2.9 with rise −10u; ready line fade 2.6 → 3.3.
Gauges: RPM center (_ox+330u, _oy+320u) label OMCTr("VÒNG TUA","RPM"),
unit "x1000 rpm", max 8, red 0.8; SPEED center (_ox+1270u, _oy+320u)
label OMCTr("TỐC ĐỘ","SPEED"), unit km/h|mph by `usesMetricSystem`,
max 220|140, red 0.9; backdrop radial glow rgb(0.15686, 0.23529,
0.43137, α0.35) → clear.

## 5. PARTIAL builders — verified skeletons (strings decoded from the binary)

### ss_buildSky @0x11124 (style backdrop for day/night scenes)
Reads `weather[@"isDay"]`. Builds, in order: host background from
`ss_sceneColors`; a radial glow (sub_12554); a CAGradientLayer sky
(setType, setColors/setLocations from `SSWeatherCategory`-style palette,
start/end points); a sun/moon image (`systemImageNamed:withConfiguration:`
+ `imageWithTintColor:renderingMode:`, layer contents = CGImage,
contentsGravity set); a `cloud.fill` image layer; silhouette layers with
bezier-path masks (fillRule set, black fill); two skyline stroke paths;
dozens of motes via `ss_addMote:layer:to:`. Calls sub_1ac0c (not B's
claim — SSSplash-side residue, §6).

### ss_buildParticles @0x14d50
Renders the greeting text into a bitmap: attributes dictionaries via
`sub_f6ac` font, `sizeWithAttributes:`, `drawAtPoint:withAttributes:`
into an `NSMutableData` pixel buffer, then samples points into the
packed particle records (`_particles`) and registers an `SSCanvasView`
via `ss_addCanvas`. Text = trimmed `carName` or `@"OmniCar"`. Also the
period greeting label (sub_155c8 + SSPeriodForDate(self.date)) with
`ss_label:` + `ss_fade:` whose outA/outB are scaled by `duration`.

### ss_buildHud @0x15ad0
Dashed arc (bezierPathWithArcCenter, lineDashPattern @[n, n]), a linear
gradient bar, then iterates `self.hud` (array of dicts): per item reads
`@"text"` and `@"ok"` (boolValue) → status labels colored by ok, with
`ss_fade:` envelopes; fixed labels `@"100%"`, `@"0%"`, glyphs `@"✓"` /
`@"!"`, and the final OMCTr(@"SẴN SÀNG", @"READY") label. One row's text
goes through `setText:` after creation (a counter/label pair).

### ss_buildBriefing @0x16af8
Builds a rows array of [icon, title, detail] triples, then lays out up
to 3 visible rows in a rounded card (cornerRadius, continuous curve,
border) with per-row `ss_fade:` + setOutEase + setRise. Verified row
content (all OMCTr vi/en pairs decoded):
- greeting row: icon `👋`, title = `"%@ · %@"` (greeting-with-name,
  date line via sub_dc18).
- weather row: icon = symbol from sub_eb68; detail combines
  `"↑ %@  ↓ %@"` (sub_edf0 hi/lo) and `"%ld%% khả năng mưa"` /
  `"%ld%% chance of rain"` when rain present; header
  OMCTr("Thời tiết hôm nay", "Today's weather").
- battery row: `batteryPercent` → OMCTr("Pin iPhone %ld%%",
  "iPhone battery %ld%%"); low → icon `🪫` + OMCTr("Nhớ cắm sạc trên xe",
  "Plug it in on the way"); ok → icon `🔋` + OMCTr("Đủ pin cho chuyến đi",
  "Enough for the trip").
- calendar row (from `nextEvent`): header OMCTr("Lịch hẹn kế tiếp",
  "Next on your calendar"), icon `📅`, title `"%@ %@"` (time + title);
  relative detail: OMCTr("Còn %ld phút", "In %ld min") /
  OMCTr("Còn %ld giờ %ld phút", "In %ld h %ld min") /
  OMCTr("Đang diễn ra", "Happening now"); `location` appended when
  non-empty.
- closing row: icon `🛡`, OMCTr("Thắt dây an toàn", "Buckle up"),
  OMCTr("Chúc bạn thượng lộ bình an", "Have a safe trip").

### ss_buildLiquid @0x17bb4
Iterates a palette array of [packedRGB, x, y, scale] quadruples →
radial-glow blobs (sub_12554) each with a `position` CABasicAnimation
(key `@"ssDrift"`, autoreverses, infinite repeat, timeOffset per blob,
CAMediaTimingFunction). Loads the app logo from the literal paths
`/Library/PreferenceBundles/OmniCarPrefs.bundle/PackageIcon.png` and
`/Library/PreferenceBundles/OmniCarPrefs.bundle/logo@3x.png` (via
sub_4118 path resolution), shows it in a shadowed UIImageView with a
`transform.translation.y` breathing animation (key `@"ssBreathe"`); a
title label made with sub_da28 + sub_f6ac font (not ss_label:) masked by
a two-color gradient layer; tagline OMCTr("Sức mạnh của CarPlay",
"The power of CarPlay"); a pill whose gradient sweeps via
`transform.translation.x` animation (key `@"ssSweep"`,
functionWithControlPoints).

### ss_buildFestive @0x18af0
Occasion-driven (self.occasion): colored backdrop glow, an SSCanvasView
particle field (ss_addCanvas + mutable data buffer), falling/celebration
motes per occasion (petal/moon/snow shapes via oval bezier paths and
image contents), HSL-generated colors via sub_159a8, and two label
lines with fades. Verified OMCTr pairs:
- birthday: ("Chúc mừng sinh nhật, %@!", "Happy birthday, %@!") /
  ("Chúc mừng sinh nhật!", "Happy birthday!") + ("Hôm nay lại…",
  "Enjoy the drive today") — vi strings partially garbled in the dump
  annotations; en side exact.
- Mid-Autumn: ("Trung Thu", "Happy Mid-Autumn Festival"),
  ("Trăng tròn, đường thông…, %@", "Full moon and clear roads, %@").
- Christmas: ("Giáng Sinh", "Merry Christmas"), "Merry Christmas, %@",
  "Happy holidays, %@", "Happy holidays".
- New Year: "Happy New Year %ld" (year taken from the date via
  NSCalendar component), ("Thượng lộ bình an, %@", "Safe travels, %@").
- Tết: ("Chúc Mừng Năm Mới", "Happy Lunar New Year"),
  ("An khang thịnh vượng · thượng lộ bình an, %@",
   "Health, luck and safe travels, %@") — decoded exactly from cfstrings.

## 6. What the original agent still owes (by elimination — NOT claimed by B)

- SSSplash block invokes and helpers listed INFERRED in its report:
  sub_601c, sub_6028, sub_62a0, sub_6384, sub_63b4, sub_63e4, sub_640c,
  sub_67d0, sub_68c4, sub_68ec, sub_68f4, sub_6be4, sub_6ff4, sub_702c,
  sub_7478, sub_84a8, sub_8eb8, sub_8ec8, sub_8efc, sub_a00c, sub_a504,
  sub_a58c, sub_a5d0, sub_1ac0c, sub_1ad00, sub_1ad18, sub_1ad48,
  sub_1ae44 (frame-decode / audio / weather-fetch internals).
- SSFade / SSGauge / SSCanvasView / SSLinkTarget bodies beyond what its
  report already verifies.
- The six PARTIAL builders in §5 remain open for whoever takes the next
  pass (B's skeletons + strings are the starting point; the dumps are in
  `disasm/B/`).
- Two header nits for integration: (a) `SSStartupScreen.h:73` uses
  `SSStartupView *` before the `@interface` — needs a forward `@class`
  (B added one locally in its file); (b) the ivar the header names
  `_stackMaxWidth` (slot 0x3ad00) actually stores the **NSArray of the 4
  card constraints** in buildWeatherWithPeriod: — name or type should be
  reconciled at integration.

## 7. Contradictions found

Against the original agent's source (all adjudicated from the binary):
- **C1 — SSFont**: the original's font helper omits the Rounded design;
  sub_f6ac applies `fontDescriptorWithDesign: UIFontDescriptorSystemDesignRounded`
  with fallback to the plain font.
- **C2 — greeting table**: the original's SSGreetingLine has 4 period
  cases (incl. "Chào buổi trưa") + occasion cases; sub_155c8 has exactly
  3 cases, no occasion input, and period 1 = "Chào buổi chiều" /
  "Good afternoon".
- **C3 — weather symbols**: night-clear = `moon.stars.fill` (not
  `moon.fill`); heavy-rain set is exactly {65, 67, 82}; thunderstorm =
  `cloud.bolt.rain.fill` (not `cloud.bolt.fill`).
- **C4 — sceneColors**: the original's body returns two black colors;
  the binary returns the full style (4–9) / occasion (0–4) pair table in
  B's `ss_sceneColors`.
- **C5 — gauge `red` semantics** (observation, now resolved): engine
  passes red as a fraction (0.8 / 0.9); `ss_setGauge:` compares the
  RAW value against it (strict >, §3 as corrected by verifier #6) — the
  original's prose "value >= red" is corrected to the raw-value semantics.

Against the maps: **none.** B's decodes agree with `metadata/IPC_MAP.md`
(the audio/weather CFNotification names and the `com.anlai.omnicar/location`
consumption are untouched by this seam) and with `metadata/HOOK_MAP.md`
(the module's single `-[UIWindow setHidden:]` hook is outside B's claim
and nothing here contradicts it).

## 8. Tools / method

python3 + struct for constant-table extraction (fat slice offset 0x4000,
VA == slice file offset; chained-fixup pointers masked to 36 bits;
constant NSArray graph walked by hand for the lamp table); the original
agent's capstone dumps in `disasm/` read line-by-line for every VERIFIED
item; `clang-18 -fsyntax-only` (iPhoneOS16.5 SDK) as a syntax gate for
B's source. No original binary was executed.

## Verifier-#6 fix note

Verifier #6 (VERIFY_StartupScreen.md §3 C5) confirmed the core of the
C5 adjudication (fraction-scale input, `red` as a fraction threshold,
`arc.strokeEnd`, sweep constants 3π/4 / 3π/2, fill bottom 0x7FD3FF) but
refuted three details. Corrected in place: the §3 bonus-adjudication
bullet and the §7 C5 bullet now state that the needle rotation, the hot
test and the number consume the **raw** value (only `arc.strokeEnd`
takes the clamped fraction); the number is `fcvtas(raw * max)`
(round-to-nearest), not `(NSInteger)(frac * max)`; and the fill
gradient top becomes 0xFF5C54 iff **raw > red** (strict; else
0xFFFFFF) — not "only when the unclamped value > 1". The matching
comment in SSStartupViewScenesB.m (ss_buildEngine header) was corrected
the same way. The original agent's `ss_setGauge:` body in
SSStartupView.m (invented value/max division, strokeEnd on the fill
mask, `>=`) was rewritten in the same pass — see the "Verifier-#6 fix
addendum" in StartupScreen_REPORT.md.

## CLOSURE addendum — the six PARTIAL builders, reconstructed at line level

Delivered by the closure finisher (same day): `SSStartupViewBuilders.m`
(category `SSStartupView (Builders)`, 1,224 lines), superseding the
structural bodies in `SSStartupView.m` for the six builders of §5, plus
`sub_16544` (default HUD items) and the `sub_1ac0c` render helper with its
rain-droplet and Tết-flower drawing blocks. Own dumps (capstone 5.0.7 +
`verify/macho_truth.py` ground truth) in `disasm/builders/`
(`sky.txt`, `particles.txt`, `hud.txt`, `briefing.txt`, `liquid.txt`,
`festive.txt`, `applyEngine.txt`).

Syntax gate: `SSStartupViewBuilders.m` passes
`clang-18 -fsyntax-only -isysroot iPhoneOS16.5.sdk -target
arm64-apple-ios15.0 -fobjc-arc -fblocks` with **0 errors, 0 warnings**,
standalone (it declares the private selectors it uses itself). Toolchain
note: the VM's system clang-18 had been wiped by a `/usr` rollback and
`fix-toolchain.sh` could not restore it (apt index absent), so the gate
ran on clang 18.1.3 extracted from the local apt archive cache into
/tmp — same compiler version B's gate used.

### Per-builder status

- **ss_buildSky @0x11124 — CLOSED.** Two dispatches on `_sky` (backdrop on
  `_sky & ~2`: day = rays + sun glow, night = 110 star motes + moon glow;
  weather on full `_sky`: clouds ×3/×5, fog ×6 kind-2 bands, rain 70/120
  kind-0 droplet motes on a glass pane with `_wetMask` + wiper arm/blade,
  `_sky == 8` adds the `_lightning` flash plane and falls into rain,
  `_sky == 9` = clouds then 100 kind-4 snow motes). Every color, count,
  record field and the cloud-opacity shape `0.35 + rand/4/1e6`
  (`ucvtf …, #2` in the stream) is transcribed from instructions.
  Structural liberty, flagged: the `_sky == 9` arm reuses the cloud block
  in machine code; the source writes it out a second time.
- **ss_buildParticles @0x14d50 — CLOSED (bound settled rem4).** Text
  rasterised into an alpha-only bitmap (bitmapInfo 7), on-pixel count,
  `step = max(sqrt(onCount/800), 1)`, grid sampling at byte ≥ 0x81,
  records capped at 900 with even resampling, `_dot = max(step*0.55,
  1.5)`, greeting label + duration-based out-window. The bitmap
  dimension guard (rem4 dump `disasm/rem4_buildParticles.txt`
  @0x15020-0x15040): each dimension is converted with `fcvtpu`
  (ceil) and tested as `(dim - 0x1001) + 0xFFF` unsigned — the
  bitmap is built only when **2 ≤ dim ≤ 0x1000 (4096)**, width
  first, then height. The source previously wrote `w, h ≤ 0x2000`
  tagged INFERRED; corrected to the exact expression in rem4.
  No non-exact constant remains in the file.
- **ss_buildHud @0x15ad0 — CLOSED**, including `sub_16544`
  (SSDefaultHudItems, 5 entries, all `ok = @YES`; the binary calls
  SSTrimmed twice — transcribed). Rings table [210, 170, 130] @0x29560,
  conic disc locations @[@0, @0.88, @1] @0x355d8, percent label built as
  "100%" then immediately reset to "0%", ≤ 5 checklist rows (glyph +
  text, fades 0.5+0.38i → 0.8+0.38i), READY caption.
- **ss_buildBriefing @0x16af8 — CLOSED.** Row assembly and the 2-column
  card layout (700×210k cards, orphan-third-row centring at x=450k,
  two-row case at y=195k, card fades 0.3+0.45i → 0.9+0.45i with
  outEase + rise 40k) fully transcribed; see contradictions D4–D7 for
  the four places where this corrects §5 / the structural body.
- **ss_buildLiquid @0x17bb4 — CLOSED.** Palette table @0x35650 decoded
  as an NSArray of [packedRGB, x, y, scale] quadruples
  ([0xB7A9FF, 260, 120, 700], [0x8FD7FF, 1350, 170, 650],
  [0x9DF668, 1250, 560, 600], [0xFFC966, 320, 540, 560]); logo from
  `OMCRealPath(...)` with the `logo@3x.png` fallback; gradient-masked
  title; sweeping pill. No residue.
- **ss_buildFestive @0x18af0 — CLOSED.** Occasion dispatch (1 Tết,
  2 birthday, 3 Christmas, 4 Mid-Autumn, 5/default New Year), shared
  preamble for occasions 1/5 (glow + canvas + 7 `_bursts` records, hues
  [0, 45, 55, 330, 20, 200, 120] @0x29578), 36 kind-5 flower motes
  (Tết), 100 kind-6 HSL confetti (birthday), 120 kind-4 snow
  (Christmas), 7 kind-7 moon motes (Mid-Autumn). Structural liberty,
  flagged: the shared title/subtitle tail (0x19d6c–0x19f00) and the
  birthday/Christmas icon line (0x197c4) are factored into the private
  methods `ss_festiveLabelsWithTitle:…` / `ss_festiveIcon:`; every
  parameter (positions 250/270/300/330/340 title-Y, sizes, colors,
  occasion-1 fade windows 0.8→1.6 and 1.4→2.1 vs 0.8→1.5 and 1.3→2.0)
  is the binary's.

No `STUB-UNRECOVERED` fragments remain in any of the six builders.

### Contradictions with the structural bodies / §5 skeletons

- **D1 (sky):** the structural body built only rays/wetMask/wiper/flash
  stubs. The binary builds the full day/night backdrop dispatch, five
  weather arms, five mote kinds and the complete wiper assembly. The
  structural body is superseded wholesale.
- **D2 (particles):** the structural body's "90 particles" is wrong —
  the count is data-driven (`min(sampledPoints, 900)`), and there is no
  "OmniCar label": the name is rasterised into particle records, and the
  only label is the period greeting.
- **D3 (hud):** the structural body used the English literal `@"READY"`;
  the binary uses `OMCTr(@"SẴN SÀNG", @"READY")`. Also new: the percent
  label is created with text "100%" and immediately reset to "0%".
- **D4 (briefing, vs §5):** row triples are **[title, detail, icon]**,
  not §5's "[icon, title, detail]" — proven by the layout code (row[2]
  feeds the 70-pt icon label, row[0] the title, row[1] the detail).
- **D5 (briefing, vs §5):** the high/low format is `@"↑ %@  ↓ %@"` with
  **two** spaces before ↓ (cfstring @0x32ac8, byte-exact); §5's skeleton
  had one space.
- **D6 (briefing, vs §5):** in the weather row, the symbol returned by
  `SSWeatherSymbolAndText` (sub_eb68) is **not** used as the row icon —
  only its out-text is consumed; the icon is `emoji[SSWeatherCategory]`
  from the static table @0x30c98 ([☀️ 🌙 ⛅ ☁️ ☁️ 🌫 🌦 🌧 ⛈ 🌨]).
- **D7 (briefing, vs §5):** the battery row is **mutually exclusive**
  with the weather row — it is built only in the `weather == nil`
  branch (and only when `batteryPercent >= 0`). §5 listed the rows as
  independent. Also in the dated calendar path the binary computes the
  "Lịch hẹn kế tiếp" header and discards it (dead store, transcribed
  with a comment).
- **D8 (liquid, vs structural body):** animation key/path assignment —
  the binary confirms §5's reading and refutes the structural body:
  `ssDrift` is `position` on the glow blobs, `ssBreathe` is
  `transform.translation.y` on the logo, `ssSweep` is
  `transform.translation.x` on the pill's gradient.
- **D9 (festive strings, vs §5):** three of §5's OMCTr transcriptions
  were garbled by the annotation tooling and are corrected from the
  cfstring structs (UTF-16-aware decode): Mid-Autumn title VI is
  **"Trung Thu Vui Vẻ"** (not "Trung Thu"); Christmas title VI is
  **"Giáng Sinh An Lành"** (not "Giáng Sinh"); the Christmas with-name
  subtitle's VI slot is literally **"Merry Christmas, %@"** (the author
  passed the English string as the first OMCTr argument). Birthday
  subtitle VI is "Hôm nay lái xe vui nhé", Mid-Autumn with-name VI is
  "Trăng tròn, đường thông, %@ nhé".
- **D10 (shared, integration):** `ss_addMote:`'s real signature is
  `ss_addMote:(SSMoteRecord)layer:to:` — a 56-byte record
  `{int64 kind; double f1..f6}` by value, then the layer, then the
  container **CALayer**. The class extension in `SSStartupView.m`
  declares an inferred `(CALayer *)layer to:(UIView *)container` form
  (different selector); it must be replaced at integration.
  `SSStartupViewBuilders.m` declares the true form itself.
- **D11 (cross-check item):** three `ss_label:` call sites pass
  `size: 3.0` while sibling sites pass 26–120 (particles greeting;
  festive Tết and New Year subtitles). The immediates are unambiguous
  (0x4040000000000000), so they are transcribed as-is; either
  `ss_label:` treats sub-~4 sizes as scale factors or the original
  source genuinely mixes units. Flagged for the verifier; not silently
  "fixed".

### Adjudication (coordinator request): ss_applyEngine: → ss_setGauge: value scale

Question raised by verifier #6: the structural body of
`ss_applyEngine:` in `SSStartupView.m` (line ~701) passes
`sweep * max * 0.62` (and `* 0.71` for the second gauge) into
`ss_setGauge:value:` — if true, one side is off-scale against the
fraction semantics verifier #6 confirmed for `ss_setGauge:`.

Evidence: own dump of the real `ss_applyEngine:` @0x14158
(`disasm/builders/applyEngine.txt`, 0x14158–0x14384). The function
computes exactly two values from its time argument `t`:

- `sweep` — a phase value in **[0, 1]**: 0 outside [0.4, 2.3]; rising
  `easeInOutCubic((t − 0.4)/0.9)` on [0.4, 1.3] (4x³ below x = 0.5,
  1 − (−2x + 2)³/2 above); falling `1 − easeInOutCubic((t − 1.3)/1.0)`
  on [1.3, 2.3].
- `wobble` — `0.08 + 0.004 * sin(9t)` for `t ≤ 2.3`, else 0.

Call sites: `gauges[0]` receives **max(sweep, wobble)** (`fcmp`/`fcsel`
at 0x14208–0x1420c), `gauges[1]` receives **sweep**. There is **no
multiplication by `max` (8 / 220) and no 0.62 / 0.71 factor anywhere in
the instruction stream**; the structural body's sweep formula
(`pow(min(1, t/2.5), 2) * …`) also does not exist in the binary.

**Verdict: the structural body in `SSStartupView.m` is the wrong side.**
`ss_applyEngine:` emits pure fraction-scale values in [0, 1], which
compose consistently with the verified `ss_setGauge:` semantics
(needle = 3π/4 + raw·3π/2, hot = raw > red, number = round(raw·max),
strokeEnd = clamped raw). Per the coordinator's instruction,
`ss_setGauge:` was NOT touched and `SSStartupView.m` was NOT edited by
this finisher; the integration owner should replace the structural
`ss_applyEngine:` body (SSStartupView.m ~lines 698–703) with the shape
above.

---

## Final closure addendum (2026-11-08) — ss_applyMotes consumer core CLOSED

Closes BUILD_PHASE2_LOG gaps item 8. The consumer core `sub_10d50` is
an island inside `-[SSStartupView ss_applyMotes:]` @0x10cf0 (the loop
proper starts at 0x10d50 with the record walk); it was line-read in
full from `disasm/010cf0_-_SSStartupView_ss_applyMotes.txt` and every
constant/ivar resolved independently via `verify/macho_truth.py`.
`SSStartupView.m` was rewritten accordingly:

- **Record**: 56-byte stride (`x25 += 0x38`), layout int64 kind @+0x00
  and six doubles f1..f6 @+0x08..+0x30. (B's earlier "kind + 5 doubles"
  phrasing was wrong; the walk loads d9/d10, d12/d13, d14/d15 = six
  doubles, matching the D10 writer encoding `{?=qdddddd}`.)
- **Loop frame**: count = `_moteLayers.count` (ivar 320; early return
  when 0), bytes = `_motes.bytes` (ivar 312), layers fetched in lockstep
  via `objectAtIndexedSubscript:`; `_k` (ivar 208) is the unit `u`,
  `_sceneSize` (ivar 184) gives W/H.
- **Writer** @0x10c60 (also rewritten in SSStartupView.m; it replaces
  the legacy arc4random body and the wrong inferred signature):
  `[_motes appendBytes:&record length:0x38]`, `[_moteLayers
  addObject:layer]`, `[container addSublayer:layer]`.
- **Per-kind consumer formulas** (t = time argument; constants decoded
  raw: 600.0 @0x28ee8, -300.0 @0x28ef0, 0.6 @0x28ef8, 0.4 @0x28df0):
  - kind 0 rain: y = f2 + 60·t·f3·u, true fmod over H (guard H > 0);
    position (f1, y). f4 (streak length) unused.
  - kind 1 stars: opacity = 0.4 + 0.6·|sin(2t + f6)| only.
  - kind 2 fog: x = f1 + t·f3; if (W + 600u > 0) x += (W − 600u)·
    floor(x / (W + 600u)); x −= 300u; position (x, f2).
  - kind 3 cloud: x = f1 + t·f3; period = W + f5; if (period > 0)
    x −= period·floor(x / period); x −= f5/2; position (x, f2).
  - kind 4 snow: y = f2 + t·f3; period = H + 4·f4; true fmod;
    y −= 2·f4; x = f1 + 10u·sin(t + f6); position (x, y).
  - kind 5 petals: y = f2 + t·f3; if (H + 40u > 0) y += (H − 40u)·
    floor(y / (H + 40u)); y −= 20u; x = f1 + 30u·sin(t·f5 + f6);
    position + transform = rotation(t + f6, z).
  - kind 6 confetti: y as kind 5 but period H + 30u / rest −15u;
    x = f1 + 20u·sin(2t + f6); transform = rotation(3t + f6, z).
  - kind 7 moons: v = 50·t·u + f6; if (H + 120u > 0) v += (H − 120u)·
    floor(v / (H + 120u)); position (f1, H − v + 60u).
  - kinds outside 0–7: layer untouched.
- The "+" floor terms in kinds 2/5/6/7 are transcribed exactly (they
  are not fmod): with the builders' spawn ranges each mote makes a
  single pass over the scene within the splash lifetime.

**Syntax check** (clang-18 18.1.3, `-fsyntax-only -target
arm64-apple-ios15.0 -isysroot ~/theos/sdks/iPhoneOS16.5.sdk -fobjc-arc
-fblocks`): the rewritten mote region is diagnostic-free. Remaining
diagnostics in the file are pre-existing and outside this item: the
SSStartupScreen.h:73 forward-`@class` nit (disappears with the same
workaround SSStartupViewBuilders.m uses) and the two
property-on-`id` errors in the superseded structural `ss_applyEngine:`
body, whose replacement shape is specified in the gauge-scale
adjudication above.
