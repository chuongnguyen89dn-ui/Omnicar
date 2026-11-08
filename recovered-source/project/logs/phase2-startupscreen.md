# Phase 2 — OmniCarStartupScreen real-module integration + build

Date: 2026-11-08. Owner scope: `project/OmniCarStartupScreen/` only. `src/` was
NOT edited; every substitution below happened in the PROJECT copies and is
logged here. Build log: `project/logs/phase2-startupscreen-build.log`.

## 0. OMCCommon sync (task start step)

Copied `src/OMCCommon/{OMCCommon.c, OMCCommon.h}` → `project/OMCCommon/`
(re-copy; project copy was already byte-identical at first check, then the
src file changed under parallel phase-2 work and was re-synced).

| File | md5 (src == project, after copy) |
|---|---|
| OMCCommon.c | `cb8afa107945c29cc2bce1befb999feb` |
| OMCCommon.h | `951b0e341f3ba79ff0d6f0802525d79e` |

Note: at task start both were `1f8a90b2b5cbc946853337bfd6e4883a` (OMCCommon.c);
the src copy changed to `cb8afa…` during this session (another agent's
phase-2 work). The final copy above is the current src state.

## 1. Sync list (src/StartupScreen → project/OmniCarStartupScreen)

| File | md5 at sync | Changed after sync? |
|---|---|---|
| SSSplash.m | `b93187d3ca0cbe0f71aab99943d1935f` | no — byte-identical to src |
| SSStartupScreen.h | `5aff5bf4e07026ac75a6cfd77ba2feab` | yes — header nits (§5) |
| SSStartupScreen.m | `85d2840f2a616b47573587474b035d29` | yes — leapMonth mechanical fix + OMCRealPath shim (§6) |
| SSStartupView.m | `e74a35b876148d5c7b2533c4f31ce0e7` | yes — supersede/D10/applyEngine (§§2–4) |
| SSStartupViewBuilders.m | `6c1d3a7e284216b633d3c0efff67a452` | no — byte-identical to src |
| SSStartupViewScenesB.m | `9ac10fbb2bf892fb46be5b89b4a3fa79` | yes — _stackMaxWidth store + ScenesBInternals decl (§§5–6) |

Makefile: `OmniCarStartupScreen_FILES` was
`OmniCarStartupScreen.m` → now the 5 real `.m` files
(`SSSplash.m SSStartupScreen.m SSStartupView.m SSStartupViewBuilders.m
SSStartupViewScenesB.m`); OMCCommon.mk still appends `../OMCCommon/OMCCommon.c`
on top, as designed. The placeholder `OmniCarStartupScreen.m`
(`OmniCarStartupScreen_ScaffoldAnchor`, obsolete) was **deleted from
_FILES**; the file itself remains on disk, unbuilt. Plist kept unchanged.
`-DOMC_MODULE_NAME='"StartupScreen"'` kept.

Fingerprint check on the built dylib: all **8 classes** present as ObjC
class symbols (SSLocationOnce, SSSplashWindow, SSSplash, SSFade, SSGauge,
SSLinkTarget, SSCanvasView, SSStartupView — target 8/8) plus the
(ScenesB) and (Builders) categories on SSStartupView. Explicit method
implementations in the 5 sources: 103 (signature-line count); the
remainder of the original 173-method fingerprint is the
compiler-synthesised accessors / dealloc / .cxx_destruct generated from
the 31 `@property` declarations in the header (the original report §10
counts 120 such synthesised rows), which are not hand-written in either
the src reconstruction or this integration. Key selectors verified
present in the built dylib via strings: all `ss_build*`, `ss_sceneColors`,
`ss_applyEngine`, `ss_setGauge:value:`, `buildWeatherWithPeriod:`,
`buildGreetingWithDate:period:`, and the D10 selector
`ss_addMote:layer:to:`; the wrong selector `ss_addMote:to:` is absent.

## 2. Superseded functions (SSStartupView.m structural bodies removed)

Each removal replaced the body in the PROJECT copy of SSStartupView.m
with a comment naming the superseding implementation. The
class-extension declarations were retained (internal callers in
SSStartupView.m — e.g. `ss_buildScene`, `reload` — dispatch through
them; the category implementations satisfy them at runtime).

Superseded by **SSStartupViewBuilders.m** — `SSStartupView (Builders)`:

| # | Removed structural body (src SSStartupView.m lines) |
|---|---|
| 1 | `-[SSStartupView ss_buildSky]` (556–578) |
| 2 | `-[SSStartupView ss_buildParticles]` (748–761) |
| 3 | `-[SSStartupView ss_buildHud]` (784–803) |
| 4 | `-[SSStartupView ss_buildBriefing]` (820–845) |
| 5 | `-[SSStartupView ss_buildLiquid]` (853–878) |
| 6 | `-[SSStartupView ss_buildFestive]` (888–908) |

Superseded by **SSStartupViewScenesB.m** — `SSStartupView (ScenesB)`
(the task brief named only Builders; ScenesB is the second superseding
file in the sync set and leaving its six duplicates in place would have
duplicated the same methods — same treatment, listed separately so both
texts are accounted for):

| # | Removed structural body (src SSStartupView.m lines) |
|---|---|
| 7 | `-[SSStartupView ss_sceneColors]` (193–200) |
| 8 | `-[SSStartupView buildGreetingWithDate:period:]` (221–244) |
| 9 | `-[SSStartupView buildWeatherWithPeriod:]` (262–307) |
| 10 | `-[SSStartupView ss_gaugeAt:radius:label:unit:max:red:in:]` (603–647) |
| 11 | `-[SSStartupView ss_buildEngine]` (649–669) |
| 12 | `-[SSStartupView ss_buildWelcome]` (710–734) |

Kept ONLY in SSStartupView.m (no Builders/ScenesB counterpart — verified
by grep over both files): `ss_applySky:`, `ss_applyWelcome:`,
`ss_applyHud:`, `ss_applyMotes:`, `ss_drawParticles:t:`,
`ss_drawFireworks:t:`, `ss_drawCanvas:size:`, `ss_setGauge:value:`
(verifier-#6-corrected version, untouched), `ss_buildScene`,
`ss_clearScene`, `ss_host`, `ss_addCanvas`, `ss_label:…`, `ss_fade:…`,
plus lifecycle (`initWithFrame:`, `dealloc`, `clearContent`, `reload`,
`layoutSubviews`, `applyUnit:`, `playIntro`, `didMoveToWindow`) and the
link/step/applyTime engine. The file-static helpers `SSGreetingLine` /
`SSWeatherSymbolName` lost their last in-TU callers with removals
8/9/12; they were **kept** (not deleted) and the resulting
unused-function warning is demoted in the Makefile (§6).

Process note: the first removal pass used a naive matcher that hit the
class-extension declarations instead of the implementations and corrupted
the project copy; the copy was restored from src and the pass redone
with an implementation-only matcher. All 12 spans above were verified
against src line numbers after the redo.

## 3. ss_applyEngine verdict

**The structural body in SSStartupView.m was the wrong side** (closure
addendum adjudication, confirmed against
`src/StartupScreen/disasm/builders/applyEngine.txt`, 0x14158–0x14384).
Neither SSStartupViewScenesB.m nor SSStartupViewBuilders.m carries an
`ss_applyEngine:` body (grep: no hits), so the wrong body in the project
copy of SSStartupView.m was **replaced in place** with the corrected
one — SSStartupView.m owns the canonical body.

Corrected shape (now in project SSStartupView.m):

- `sweep` ∈ [0,1]: 0 outside [0.4, 2.3]; rising
  `easeInOutCubic((t−0.4)/0.9)` on [0.4, 1.3]; falling
  `1 − easeInOutCubic((t−1.3)/1.0)` on [1.3, 2.3]; x clamped to [0,1];
  cubic = `4x³` below 0.5, `1 − (−2x+2)³/2` above.
- `wobble = 0.08 + 0.004·sin(9t)` — see discrepancy note below.
- `gauges[0] ← max(sweep, wobble)` (fcmp/fcsel @0x14208–0x1420c);
  `gauges[1] ← sweep`.
- **No** `* max` scaling, **no** 0.62 / 0.71 factors, and the invented
  `pow(min(1, t/2.5), 2) · (1 − 0.15·sin…)` sweep is gone. Values are
  pure fractions, composing with the verified `ss_setGauge:` semantics
  (needle = 3π/4 + raw·3π/2, hot = raw > red, number = round(raw·max),
  strokeEnd = clamped raw). `ss_setGauge:` itself was NOT touched.

Discrepancy flagged: the closure addendum's prose says wobble applies
"for t ≤ 2.3, else 0", but the instruction stream contradicts it — at
0x141c4 `fcmp t, 2.3; b.le` **skips** the wobble computation
(0x141d0–0x141ec), so wobble is computed only when **t > 2.3** (the
post-sweep idle: gauge 0 sits at ≈0.08, gauge 1 at 0 — physically an
idle-RPM reading). The implementation follows the dump; the comment in
the substituted body records this explicitly.

## 4. D10 — ss_addMote record-by-value signature

Proven form applied:
`- (void)ss_addMote:(SSMoteRecord)record layer:(CALayer *)layer to:(CALayer *)container;`
with `typedef struct { int64_t kind; double f1, f2, f3, f4, f5, f6; }
SSMoteRecord;` (8 + 6×8 = **56 bytes**, stride 0x38, type encoding
`{?=qdddddd}`).

Applied where:

| Location | State |
|---|---|
| SSStartupViewBuilders.m (BuildersInternals decl + all 10 call sites) | already correct in src — verified, untouched |
| SSStartupView.m class-extension declaration (was `(CALayer *)layer to:(UIView *)container`, INFERRED) | **replaced**; SSMoteRecord typedef added above the extension |
| SSStartupView.m implementation (0x10c60; was the same wrong 2-arg form, inventing mote fields with arc4random) | **replaced**: appends the caller-built 56-byte record verbatim to `_motes`, registers the layer in `_moteLayers`, `addSublayer:` on the CALayer container. Field generation now lives in the verified builders, where the binary does it — no functional code dropped. |
| SSStartupViewScenesB.m | declares/calls no ss_addMote — nothing to apply (checked by grep) |

Built-dylib check: selector `ss_addMote:layer:to:` present,
`ss_addMote:to:` absent.

## 5. Header nits (SSStartupScreen.h project copy)

- **(a) Forward @class**: added `@class SSStartupView;` right after the
  imports, before its first use in `SSApplySampleData(SSStartupView *)`
  (was line 73, before the `@interface` at ~95). The redundant local
  `@class SSStartupView;` lines already present at the tops of
  ScenesB/Builders were left as-is (harmless).
- **(b) _stackMaxWidth slot**: retyped from `NSLayoutConstraint *` to
  `NSArray<NSLayoutConstraint *> *`, with a comment recording that slot
  0x3ad00 stores the NSArray of the 4 card constraints from
  buildWeatherWithPeriod:. Name kept. Consequential fix in the project
  copy of SSStartupViewScenesB.m: its buildWeatherWithPeriod: now
  actually performs that store (`_stackMaxWidth = @[…4 constraints…];
  [NSLayoutConstraint activateConstraints:_stackMaxWidth];`) — src
  stated the store in its comment (§6(b) of B's report) but activated an
  anonymous literal instead. `clearContent`'s `_stackMaxWidth = nil;`
  remains valid under the new type.

## 6. Mechanical build fixes (all in project copies, logged)

1. **Makefile warning demotions** (one CFLAGS line, commented):
   `-Wno-error=incomplete-implementation` (the 12 superseded methods
   are declared in SSStartupView.m's extension, implemented by
   categories in other TUs — per-TU noise),
   `-Wno-error=deprecated-declarations` (binary-faithful
   `UIWindow.setScreen:`, `+[CLLocationManager authorizationStatus]`),
   `-Wno-error=unused-function` (kept helpers of §2 + duplicated
   TU-static helpers in ScenesB that its superseding bodies don't all
   use: SSWeatherCategory / SSRoundedFont / SSPathGlowLayer / SSHSLToRGB
   in that TU).
2. **SSStartupScreen.m — NSCalendarUnitLeapMonth**: src named a
   calendar unit that does not exist in the iPhoneOS16.5 SDK (hard
   error). The only reads are `c.leapMonth / c.month / c.day`, so the
   nonexistent flag was dropped from the `components:` request; no
   logic change.
3. **SSStartupViewScenesB.m — ScenesBInternals declaration**: private
   selectors `ss_host`, `ss_label:at:size:weight:color:left:in:maxWidth:`,
   `ss_fade:from:to:alpha:` (defined in SSStartupView.m) are now
   declared in a category interface in ScenesB's project copy. B's
   standalone gate saw these as warnings; under Theos/ARC they are hard
   errors. Same pattern Builders already uses.
4. **SSStartupScreen.m — OMCRealPath shim**: link failed with
   `undefined symbol: OMCRealPath`. SSStartupScreen.h declares it
   extern (sub_4118), but the shared OMCCommon unit keeps its libroot
   path layer static (`OMCJBRootPath`), and project/OMCCommon is
   outside this task's ownership. A definition was added in
   SSStartupScreen.m's project copy with the core's verified semantics
   (dlopen `@rpath/libroot.dylib` → `libroot_jbrootpath`; fallback
   `"/var/jb"` prefix for absolute paths; static 1024-byte buffer —
   both call sites, SSRealPath and Builders' ss_buildLiquid, consume
   the result immediately). This is the one genuinely new function body
   in the integration; it is marked `[integration phase 2 mechanical
   shim]` in source.

## 7. Verifier-#6 fixes — presence verified during sync

All five confirmed present in the synced project copies (grep + read):

1. startCountdown publishes style+1: SSSplash.m:271
   `notify_set_state(token, (uint64_t)(_style + 1))`; consumer
   SSStartupScreen.m:449 recovers `styleState - 1`, state 0 = unset →
   pref fallback. ✔
2. Style-0 non-loop countdown = constant 60.0: SSSplash.m:265
   `duration = 60.0;` (no frameCount/fps derivation). ✔
3. numberOfLoops = playFull − 1: SSStartupScreen.m:510
   `player.numberOfLoops = playFull - 1;` (YES→0 once, NO→−1 loop). ✔
4. ss_setGauge raw semantics: SSStartupView.m (kept body) — only
   `arc.strokeEnd` takes the clamped fraction; needle/hot/number use
   the raw value; number = `round(value * gauge.max)`; hot is strict
   `value > gauge.red`; fill top 0xFF5C54 iff hot else 0xFFFFFF,
   bottom 0x7FD3FF; no value/max division. ✔ (And §3 removes the
   off-scale caller that verifier #6 flagged.)
5. Constants: `kSSWindowLevelOffset = 1000.0` (SSSplash.m:28),
   `kSSDismissFadeDuration = 0.4` (SSSplash.m:33); soundtrack stop-fade
   also 0.4 (SSStartupScreen.m:435–436). ✔

## 8. Build result

`umask 022; export THEOS=~/theos; cd project/OmniCarStartupScreen &&
make clean; make` → **PASS (exit 0)**: all 5 module TUs + OMCCommon.c
compile, tweak links, and is signed by ldid.

Output: `.theos/obj/debug/arm64/OmniCarStartupScreen.dylib` —
Mach-O 64-bit arm64, 493,680 bytes. (arm64-only per the standing
Makefile note: this VM's clang-18 silently emits arm64 for arm64e.)
Remaining build output is warnings only (demoted classes of §6 plus
the lld `-multiply_defined` obsolescence notice and an auto-linked
CoreAudioTypes framework notice, both pre-existing Theos noise).
Full log: `project/logs/phase2-startupscreen-build.log`.

## 9. Remaining issues

1. **ss_applyMotes stride residue (flagged in source)**: writers now
   append the proven 56-byte SSMoteRecord (D10), but the structural
   `ss_applyMotes:` kept from SSStartupView.m still decodes its legacy
   48-byte `SSMote` shape. The binary's real per-kind updater is the
   sub_10d50 island whose parent-method boundary was never recovered
   (StartupScreenB_REPORT.md §3), so no verified replacement exists;
   the mismatch is annotated at the typedef in SSStartupView.m rather
   than silently papered over. Mote animation fidelity is therefore
   structural, as in src.
2. **Wobble-condition prose vs dump** (§3): closure addendum says
   t ≤ 2.3; the dump says t > 2.3. Implemented per dump; a verifier
   should adjudicate the report text.
3. **OMCRealPath duplication**: the shim in SSStartupScreen.m
   duplicates (with verified semantics) the path layer that OMCCommon
   keeps static. If the core ever exports its copy, delete the shim.
   Its static return buffer is not re-entrant across simultaneous
   calls; both current call sites consume immediately on the main
   thread.
4. **D11 (inherited, untouched)**: three `ss_label:` call sites in
   Builders pass `size: 3.0` amid 26–120 siblings — transcribed as-is
   from the binary per B's report; flagged there for the verifier.
5. Cosmetic constants of the scene builders remain exactly as faithful
   as the src reconstructions are (Builders/ScenesB line-level;
   SSStartupView.m's kept apply/draw bodies structural) — no fidelity
   was added or removed by this integration beyond §§2–4.

## 10. FIX — SSSplash missing synthesised accessors (phase 2 follow-up)

Date: 2026-11-08. Scope: `project/OmniCarStartupScreen/` only (one file
changed: `SSStartupScreen.h`, project copy). `src/` was NOT edited — the
identical `@property` completion is **still owed in
`src/StartupScreen/`** (integration-level fix only, per the task brief).
No other subproject, the root Makefile, or `project/packages/` was touched.
Build log: `project/logs/phase2-startupscreen-accessors-build.log`.

### 10.0 Count correction to the brief (measured, not assumed)

The brief said "38 accessor method keys". Measured with the project's own
fingerprint tooling (`project/tools/diff_payload.py` approach:
`metadata/tools/macho_scan.py` + `macho_objc.py`, arm64 slice,
(owner, kind, selector) keys) **before** the fix:

- original total **173** keys, pre-fix built total **135** keys — net Δ 38,
  which is where "38" comes from; it is the *net* total delta, not the
  SSSplash accessor count.
- Gross diff pre-fix: 52 keys only in original = **40 SSSplash accessors**
  (20 properties × getter+setter) + 12 plain-owner `SSStartupView` keys
  (the known category-placement set, §10.3); 14 keys only in built =
  the same 12 selectors under category owners + 2 Builders helper extras.
  52 − 14 = 38 net.
- SSSplash pre-fix: 11 keys (10 explicit methods + `.cxx_destruct`) vs
  original 51 keys. 51 − 11 = **40 missing accessor keys**, listed in §10.1.

### 10.1 Property declarations added (verbatim) + source

Source of truth: `metadata/raw/OmniCarStartupScreen/objc.json`, arm64
slice (`slices[0]`, cpu `arm64`), class `SSSplash`, `properties[]`
(20 entries; attributes quoted in the right column). Cross-checked
against `objc_dump.txt` (same 20 `@property` lines) and against the
ivars already declared in the project header — **every property's
metadata type matches the existing `_name` ivar's declared type; no
conflicts, nothing stopped**:

| # | Declaration added | Metadata attributes |
|---|---|---|
| 1 | `@property (nonatomic, strong) UIWindow *window;` | `T@"UIWindow",&,N,V_window` |
| 2 | `@property (nonatomic) NSInteger style;` | `Tq,N,V_style` |
| 3 | `@property (nonatomic, strong) UIImageView *imageView;` | `T@"UIImageView",&,N,V_imageView` |
| 4 | `@property (nonatomic, strong) SSStartupView *startView;` | `T@"SSStartupView",&,N,V_startView` |
| 5 | `@property (nonatomic, weak) UIScreen *screen;` | `T@"UIScreen",W,N,V_screen` |
| 6 | `@property (nonatomic, copy) NSString *framesDir;` | `T@"NSString",C,N,V_framesDir` |
| 7 | `@property (nonatomic) NSUInteger frameCount;` | `TQ,N,V_frameCount` |
| 8 | `@property (nonatomic) double fps;` | `Td,N,V_fps` |
| 9 | `@property (nonatomic) BOOL loop;` | `TB,N,V_loop` |
| 10 | `@property (nonatomic, strong) NSMutableArray *buffer;` | `T@"NSMutableArray",&,N,V_buffer` |
| 11 | `@property (nonatomic, strong) dispatch_queue_t decodeQueue;` | `T@"NSObject<OS_dispatch_queue>",&,N,V_decodeQueue` |
| 12 | `@property (nonatomic) BOOL decoding;` | `TB,N,V_decoding` |
| 13 | `@property (nonatomic) NSUInteger queuedFrames;` | `TQ,N,V_queuedFrames` |
| 14 | `@property (nonatomic) NSUInteger shownFrames;` | `TQ,N,V_shownFrames` |
| 15 | `@property (nonatomic) NSUInteger failedFrames;` | `TQ,N,V_failedFrames` |
| 16 | `@property (nonatomic) double startTime;` | `Td,N,V_startTime` |
| 17 | `@property (nonatomic, strong) CADisplayLink *displayLink;` | `T@"CADisplayLink",&,N,V_displayLink` |
| 18 | `@property (nonatomic) BOOL finished;` | `TB,N,V_finished` |
| 19 | `@property (nonatomic, copy) NSString *endReason;` | `T@"NSString",C,N,V_endReason` |
| 20 | `@property (nonatomic) double shownAt;` | `Td,N,V_shownAt` |

Attribute decoding: `&` = strong, `C` = copy, `W` = weak, `N` = nonatomic,
no `R` = readwrite (getter + setter both synthesised, matching the
original method list). The one type that needed proof, `decodeQueue`:
`dispatch_queue_t` is `NSObject<OS_dispatch_queue> *` under
`OS_OBJECT_USE_OBJC` (`os/object.h`: `OS_OBJECT_DECL_IMPL` typedef), i.e.
exactly the metadata encoding — and §10.3 confirms the built binary's
property attribute string and ivar type for `decodeQueue` are
byte-identical to the original's, so the declaration above reproduces
the metadata exactly rather than approximating it. `screen`'s existing
ivar is already `__weak UIScreen *`, matching `W`.

### 10.2 Placement choice

Declarations were placed in **SSSplash's main `@interface`** in the
project copy of `SSStartupScreen.h`, immediately after its ivar block —
the same placement this header already uses for `SSStartupView`,
`SSLocationOnce`, `SSFade`, `SSGauge`, etc., and the placement the
original class RO records (the properties live on the class itself, not
on a category/extension). With the properties in the main interface,
clang auto-synthesises the accessors in `SSSplash.m`'s `@implementation`
bound to the **existing** `_name` ivars: no ivar was added, renamed or
retyped, and no `@synthesize`/`@dynamic` was needed. Verified
concretely in §10.3: the built class's ivar list (names, type encodings,
offsets, sizes, `instance_size` 152) is identical to the original's, so
synthesis bound to the pre-existing ivars rather than creating new ones.

### 10.3 Build result

`cd project/OmniCarStartupScreen && umask 022; export THEOS=~/theos;
make clean; make` → **PASS (exit 0)**: all 5 module TUs + OMCCommon.c
compile, tweak links (lld) and is signed by ldid. Only pre-existing
warning classes remain (deprecated `setScreen:`/`authorizationStatus`,
demoted incomplete-implementation, unused-function). Output:
`.theos/obj/debug/arm64/OmniCarStartupScreen.dylib` — Mach-O 64-bit
arm64, 497,592 bytes (was 493,680 pre-fix). Full log:
`project/logs/phase2-startupscreen-accessors-build.log`.

### 10.4 Verification (method-key comparison, arm64, same tooling as §10.0)

Original: `payload/var/jb/Library/MobileSubstrate/DynamicLibraries/OmniCarStartupScreen.dylib`.
Built: the newly built `.theos` dylib above.

- **(a) SSSplash accessors: 40/40 present.** All 20 getters + 20 setters
  from §10.1 are in the built class; SSSplash key set is now **equal**
  to the original's (51 = 51, set-identical). Stronger metadata check,
  parsing the built dylib itself: SSSplash `properties[]` — name set
  equal to the original's and **every attribute string byte-identical**
  (incl. `decodeQueue`); `ivars[]` — (type, offset, size) identical for
  all 20, `instance_size` 152 = 152; accessor method type encodings —
  **no differences** vs the original's 40.
- **(b) Totals: built 175 vs original 173 (Δ +2, fully accounted).**
  Remaining gross diff is exactly the known non-SSSplash residue and
  nothing else:
  - 12 keys only in original, all `(SSStartupView, inst, …)` plain-owner:
    `buildGreetingWithDate:period:`, `buildWeatherWithPeriod:`,
    `ss_buildBriefing`, `ss_buildEngine`, `ss_buildFestive`,
    `ss_buildHud`, `ss_buildLiquid`, `ss_buildParticles`, `ss_buildSky`,
    `ss_buildWelcome`, `ss_gaugeAt:radius:label:unit:max:red:in:`,
    `ss_sceneColors` — the 12 known category-placement pairs.
  - 14 keys only in built: those same 12 selectors under the category
    owners `SSStartupView (Builders)` (6) and `SSStartupView (ScenesB)`
    (6), **plus the 2 Builders helper extras** `ss_festiveIcon:` and
    `ss_festiveLabelsWithTitle:subtitle:titleColor:subtitleColor:titleY:titleSize:subtitleY:subtitleSize:`.
  - Selector-level check with category owners normalised to their
    target class: original 173, built 175, **0 original selectors
    missing**, only extras are the 2 Builders helpers. Hence
    173 − 12 + 14 = 175; the +2 net is exactly the 2 helper extras.
- **(c) No regression:** pre-fix built (135 keys, measured in §10.0 with
  the same tooling before the edit) is a strict subset of the new built
  set — the only-original count fell 52 → 12 (all 40 recovered keys are
  SSSplash accessors; none of the 12 remaining is SSSplash) and the
  only-built set is unchanged at the same 14 keys, so no
  previously-present key disappeared.
