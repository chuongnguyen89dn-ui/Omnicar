# RECOVERY STATUS — OmniCar 1.0.3 reconstruction (FINAL)

Finalised by Integration Phase 3, 2026-11-08. This replaces the draft
of the same name; every number below is from the phase-3 clean build,
the final `diff_payload.py` run, the numeric tar parity audit, and
the final coverage-census re-run on the canonical source.

**Canonical source**: `src/` is now the single source of truth.
`project/` is a build tree generated from it (flat layout); phase 3
backported every project-only fix into `src/` with provenance
comments and synced the closure round back, so `src/` alone
reproduces the build (see `project/BUILD_PHASE3_LOG.md` for the full
backport list).

**Labels**: **VERIFIED** = body read from the machine code
(instruction-level or call-sequence level as noted); **INFERRED** =
structure/role proven, some detail modelled and marked in-source;
**NOT-RECOVERED** = known to exist, body/constants not reconstructed,
explicitly listed — never silently stubbed over.

**Tools actually used**: python3 with two custom stdlib Mach-O
parsers (`metadata/tools/macho_scan.py`, `macho_objc.py`) + macholib
cross-check; capstone 5.0.7 for all disassembly; the calibrated xref
engine (`metadata/tools/xref.py`) and the verifier resolver
(`verify/macho_truth.py`). No ghidra/radare2/otool/class-dump exists
on this VM. All evidence comes from the one verified input DEB,
SHA-256 `d9297b010cdc08e401439b7332413f79cb1a056a05159a5deb673e218d76d9fd`.

**Tooling incident, adjudicated**: the wave-1 parser decoded
chained-fixup bind ordinals 1-based instead of 0-based, shifting
every bind-derived *name* by one. Class/method/ivar surfaces were
unaffected. The correction was broadcast to all agents and
independently adjudicated CONFIRMED (three semantic anchors + full
re-decodes). Final superclass sweep: 79 `@interface` declarations in
`src/` — 71 MATCH, **0 WRONG**, 8 EXTERNAL
(`metadata/SUPERCLASS_SWEEP.md`). Caveat carried forward in §4-G6:
some older per-function dumps were produced under capstone skipdata
settings that can truncate a function at a data island; where a later
closure pass re-read a function end-to-end from a clean dump, the
later reading governs.

---

## 1. Final build results (phase 3)

- Full clean build: `make clean` + `make package FINALPACKAGE=1`,
  exit 0, 0 errors, all 8 components (log:
  `project/logs/phase3-build-final2.log`).
- Final DEB: `project/packages/com.anlai.omnicar_1.0.3_iphoneos-arm64-rebuilt.deb`
  — SHA-256 `9a593ed2649c2da95e703c81fa121e01116911cea6efea65b6a9d99b93537170`,
  933,260 bytes, packed with `dpkg-deb -Zxz` after an explicit
  re-stage (Theos' own pack mixes ownership).
- Payload parity (numeric tar comparison vs the original):
  **202/202 entries, 0 diffs** — every entry's mode, uid 501 and
  gid 20 match the original exactly. Control file identical to the
  original except `Installed-Size` (6160 → 3071, the computed size
  of the arm64-only payload).
- `diff_payload.py` vs the original: file set **176 = 176**; all
  **168 non-Mach-O files byte-identical**; **0 original defined
  symbols missing in every one of the 8 binaries**.
- Method counts (original → rebuilt), from the same tool:

| Binary | Classes | Methods | Note |
|---|---:|---:|---|
| OmniCar (app) | 1 → 1 | 6 → 6 | exact |
| OmniCarCore | 0 → 0 | 0 → 0 | exact (21 → 22 defined symbols: the extra is a compiler-emitted helper) |
| OmniCarCarProbe | 0 → 0 | 0 → 0 | exact |
| OmniCarAppBridge | 8 → 8 | 193 → 193 | exact — see §4-G4 for the category-placement note |
| OmniCarSpeedBubble | 9 → 9 | 277 → 278 | +1 additive method, §4-G3 |
| OmniCarSplitScreen | 11 → 11 | 480 → 480 | exact |
| OmniCarStartupScreen | 8 → 8 | 173 → 175 | +2 helper methods the original inlines, §4-G5 |
| OmniCarPrefs | 29 → 29 | 743 → 743 | exact |

## 2. Per-module status (final)

### 2.1 App — `src/App/` — COMPLETE
Thin Shortcuts/Siri trampoline; UI 100% in code. Verified 8/8
instruction-for-instruction (verifier #1). NOT-RECOVERED: none.

### 2.2 OMCCommon + OmniCarCore — `src/OMCCommon/` — COMPLETE
21 exports (20 shared + Core-only `_OMCTrustedTimeStart`), all
VERIFIED. Expiry pinned to epoch **1809104400** (2027-05-01 GMT+7)
via the `@"2027-04-30"` literal + 86400 s, with HTTP-Date trusted
time kept monotonic. All 5 originally declared stubs CLOSED by the
stub-closure pass. The one divergent shared function,
`_OMCLogWrite`, is reproduced from the single source via
`-DOMC_MODULE_NAME` wiring (confirmed in every consumer Makefile,
phase 3).

### 2.3 CarProbe — `src/CarProbe/` — COMPLETE
82/82 functions reconstructed, zero stub bodies. 11 INFERRED items
consolidated in the report §7 (spot-checked by verifier #3).

### 2.4 AppBridge — `src/AppBridgeA/` + `src/AppBridgeB/` — COMPLETE with §4 residues
8 classes / 193 methods, rebuilt count exact. All closure items
landed: the keyboard glyph block @0x168B0 transcribed; the zoom
candidate arrays @0x39420/0x39438/0x39450 recovered;
`-[ABHost _currentMode]` @0x395D0 assignment closed; the ABHost
duplicate-pair rulings leave exactly one definition per selector;
`-[ABBarButton setHighlighted:]` (the last missing method) restored
in phase 3 from the dump + its animation-block invoke (@0xa02c /
@0xa104: super-forward, spring transform 0.9 ↔ identity, 0.12 s /
0.3 s, damping 0.7). Verifier #1 downgrade stands as labelled:
`-[ABHost carDisconnected]` is INFERRED (skeleton confirmed).
Condensed areas are listed in §4-G7 — they are fidelity limits, not
missing bodies.

### 2.5 SplitScreen — `src/SplitScreenA/` + `B/` + `C/` — COMPLETE with §4 residues
11 classes / 480 methods, rebuilt count exact. Every phase-2 census
gap is closed: `SCPSceneOfVC` (sub_1ab70, KVC probe order
`scene`/`_scene` then `sceneHandle`) and `SCPSceneIdentifierOfVC`
(sub_1b13c, direct scene probe) are VERIFIED; the diagnostic walker
sub_d324 + its window-walking caller tail are VERIFIED;
`+[SCPPrefs favorite:]` rewritten to the binary's
{name, left?, right?, third?, layout} shape (no fabricated `apps`
key; slot extraction lives in `-[SCPCarSplit favoriteApps:]`, also
VERIFIED); `soloBundle:` VERIFIED end-to-end; `hostFrameInfo:`
composition VERIFIED (CGRect first argument per the type encoding);
`hostPassInsetsForPane:` returns UIEdgeInsets (IMP 0x3d1e4); the
layout dedupe scan (`SCPLayoutIdentifierAlreadyDeclared`) is in;
the three Panel-called methods (exitKeepBundle / exitTapped /
atHomeScreen) are transcribed; the perf-telemetry seams
sub_54448 / sub_53f90 / sub_48da0 are claimed and reconstructed in
`SCPPerfTelemetry` / `SCPCarApps.m`; the OMCTr toast key @0x7b220 is
decoded (UTF-16 'Ô này đang ghim'). The 8 wave-3 picker/panel
bodies the census flags as CLAIMED_STUB are false positives — the
matcher trips on the provenance text "CLOSED (was
STUB-UNRECOVERED)"; the bodies are fully written (§3).

### 2.6 SpeedBubble — `src/SpeedBubble/` — COMPLETE with §4 residues
9 classes / 277 methods (+1 additive, §4-G3). All closure items
landed: `numberColor` / `applyColor:` VERIFIED rewrites with the
palette byte-exact (verifier #4); BOTH formerly undecoded constant
arrays decoded (@0x3ce30 style-4 mesh locations, @0x3ce60 heavy-font
feature settings); `SPPHeavyFont` / `SPPRoundedFont` (with fallback)
rewritten to the full verified bodies; `-[SPPBubble runDemo]`
rewritten to the proven tick schedule (ticks 1..20 send
`updateSpeed:(40 + 2·tick) limit:60`; tick ≥ 21 tears the demo
down); `SPPMakeCarWindow` rewritten (the metrics struct is touched
exactly once — one double at offset 0; scale = pointScale probe →
pixel path with `frinta` quarter-snap → screen-scale fallback with
a 2.0 floor); `SPPGlassView`'s corner is a stored double ivar
driving `layoutSubviews`, never `layer.cornerRadius` directly;
the nine item-7 layout helpers are VERIFIED (item-7 micro-closure),
which closes the last entry of REPORT_A's original NOT-RECOVERED
list (items 1–7 all closed). The scan engine (sub_7a84) is fully
read and the `__init_0` dedupe is settled: the canonical
constructor is `SPPDisplayBoot.m`; `SBOpenCar.m` is a pointer
note, excluded from the build. The channel tracer's verdict
stands: no consumer of `com.anlai.omnicar/speed` exists in this
package (publisher only, in `-[SPPBubble setSpeed:]`), and the
negative-speed sentinel is 0xFFFF. NOT-RECOVERED: none. Remaining
residues are the fidelity items in §4-G4/G7.

### 2.7 StartupScreen — `src/StartupScreen/` — COMPLETE with §4 residues
8 classes / 173 methods (+2 factored helpers, §4-G3). All six
scene builders (Sky / Particles / Hud / Briefing / Liquid /
Festive) are reconstructed at line level in
`SSStartupViewBuilders.m` (1,224 lines), with the D1–D11
contradiction list against the structural bodies resolved in the
binary's favour throughout. The structural `ss_applyEngine:`
body was substituted at integration with the proven body (pure
fraction-scale sweep via easeInOutCubic, wobble only for
t > 2.3 — the structural body's `*max` and 0.62/0.71 factors do
not exist in the binary). The mote consumer core sub_10d50 is
VERIFIED: 56-byte record (int64 kind + six doubles), writer
@0x10c60 to match. Verifier #6's five corrections are in:
startCountdown publishes style+1 (consumer to match); style-0
non-loop duration is 60.0; `numberOfLoops` = `boolValue` − 1;
`ss_setGauge:` consumes the raw value (hot = raw > red,
strictly; strokeEnd → gauge.arc); window-level offset 1000.0,
dismiss fade 0.4 s. SSSplash's 20 `@property` declarations are
restored (accessor key set identical to the original, 51 = 51;
instance_size 152 = 152). `OMCRealPath` is defined in the
StartupScreen TU because the shared unit keeps its path layer
static. NOT-RECOVERED: none. Residues: §4-G2 (the D11
cross-check) and §4-G3.

### 2.8 Prefs — `src/Prefs/` — COMPLETE
29 classes / 743 methods, rebuilt count exact. The `hud`
property is NSArray with fill-once semantics (fallback
`SSSampleHudItems` — 5 sample dictionaries, vi/en — defined in
Prefs' `SSStartupView.m`); `_OMCSwitchColor` is a tail-call to
`systemGreenColor`; `FeatureStartupScreen.plist` carries 44
items and the shipped plist is SHA-256-identical to the payload
original. The `+favorite:` dictionary shape is proven
{name, left?, right?, third?, layout} — no `@"apps"` key;
layout validity `(1 << layout) & 0x80002008` admits only
{3, 13, 31} — and the SplitScreen-side reader was rewritten to
the same dict semantics (the fabricated `+favoriteApps:` was
deleted; the binary has no such method). The three `OMCIcon`
calls the phase-2 integration completed with an assumed
`, nil` are PROVEN (literal 0 in the x1 register at all three
sites), and `OMCAppBridgeAppsController`'s three calls were
corrected to the binary's 2-argument form with
`_OMCColorFromHex(entry[2])`. `SSPrefsTrimmedString` and the
three SPP audio globals (SPPSavedAudioCategory /
SPPSavedAudioOptions / SPPActiveSoundCount), extern-only in
the delivered sources, are defined — the string helper per its
own verified header-comment semantics. Phase-1 fixes 21–27 and
the SSSplash property completion, applied project-only in
phase 2, were backported into `src/` in phase 3 (§2 of the
phase-3 log). NOT-RECOVERED: none.

## 3. Coverage census (final, on the canonical source)

`metadata/tools/coverage_census.py` re-run after the phase-3
sync; universe 3,280 functions (1,872 ObjC methods + 1,408 C
functions). Full output: `metadata/FUNCTION_SOURCE_MAP.tsv` +
`metadata/COVERAGE_GAPS.md`. "Claimed" is the census's textual
matching (definition, address annotation, or `sub_<hex>`
mention in the claiming file) — see §4-G8 for what the counts
do and do not prove.

| Binary | Total | Claimed once | Claimed stub | Expected multiple | Multiple | Unclaimed |
|---|---:|---:|---:|---:|---:|---:|
| OmniCar | 9 | 6 | 0 | 0 | 0 | 3 |
| OmniCarCore | 103 | 76 | 0 | 0 | 0 | 27 |
| OmniCarAppBridge | 383 | 209 | 0 | 8 | 75 | 91 |
| OmniCarCarProbe | 82 | 52 | 0 | 20 | 0 | 10 |
| OmniCarSpeedBubble | 495 | 377 | 0 | 4 | 0 | 114 |
| OmniCarSplitScreen | 880 | 479 | 8 | 7 | 226 | 160 |
| OmniCarStartupScreen | 352 | 240 | 0 | 8 | 0 | 104 |
| OmniCarPrefs | 976 | 803 | 0 | 7 | 0 | 166 |

**True stub count is 0 in every module.** SplitScreen's 8
CLAIMED_STUB flags are false positives: the matcher trips on
the provenance text "CLOSED (was STUB-UNRECOVERED)" inside
fully written bodies. The 675 UNCLAIMED rows are dominated by
the documented bookkeeping classes — compiler-synthesised
`.cxx_destruct` methods, `__mh_execute_header`, block-invoke
functions claimed through their host function's file, and C
helpers whose behaviour is reconstructed inside a host file
without an address annotation binding them — not by missing
bodies; the link build (§1) and the per-binary fingerprints
are the functional evidence.

## 4. Definitive remaining gaps (G1–G8)

Numbering note: two cross-references in §§1–2 predate this
section's final numbering — §1's table cites "§4-G5" for the
StartupScreen helper methods and §2.4 cites "§4-G7" for the
AppBridge condensed areas. Both topics are treated here under
G3 (additive deltas) and G4 (condensed fidelity)
respectively; G7 covers the remaining INFERRED pockets.

**G1 — arm64e absence (toolchain limit).** Every rebuilt
binary is arm64-only; the originals are FAT arm64+arm64e
(PAC00). This VM's Ubuntu clang-18 accepts the arm64e target
but silently emits arm64 (proven by the lipo failure when
merging slices), so the Makefiles set `ARCHS = arm64`. This
is an environment limit, not a source defect: the same source
built with a toolchain that truly emits arm64e (Apple clang
under Xcode, e.g. a macOS CI runner) produces the universal
form (BUILD_GUIDE §7.1). The iPhone X device target is arm64,
so the device-verification programme (§6) is unaffected. All
behavioural statements in this document cover the arm64
slice.

**G2 — StartupScreen D11 `size: 3.0` label sites (open
cross-check).** Three `ss_label:` call sites pass
`size: 3.0` — the particles greeting and the festive Tết and
New Year subtitles — while sibling sites pass 26–120. The
immediates are unambiguous (0x4040000000000000) and are
transcribed as-is: either `ss_label:` treats sub-~4 sizes as
scale factors, or the original source genuinely mixes units.
Flagged for a verifier/device cross-check (StartupScreenB
report, item D11); deliberately NOT silently "fixed".

**G3 — Additive-method and category-placement deltas.**
Nothing in this item is a missing original selector; all are
places where the rebuilt method *lists* differ in form.
(a) SpeedBubble +1: `-[SPPBubble
hideIfShownWithReason:now:state:]` exists in the source as
delivered and is additive — no original selector is missing.
(b) StartupScreen +2: `ss_festiveIcon:` and
`ss_festiveLabelsWithTitle:…` are private factorisations of
machine-code tails the original shares inline (the shared
title/subtitle tail 0x19d6c–0x19f00 and the icon line
0x197c4); every parameter passed is the binary's.
(c) Category placement: AppBridge's ABHost is built as a main
implementation (A's 16 methods) plus an `(ModuleB)` category
(B's 33 methods) — two plain implementations collide on the
class symbols (proven on a toy build in phase 2) — so the 33
ModuleB selectors match the original modulo category-owner
naming (original: main class list). SplitScreen's category
selectors carry the same caveat. (d) Defined-symbol surpluses
in the rebuilt binaries (e.g. Core 21→22, the extra a
compiler-emitted helper) are strip-level artefacts of the
originals being stripped; they are not behavioural claims.

**G4 — Condensed-fidelity areas.** Bodies whose structure,
strings, commands and targets are VERIFIED but which are not
transcribed instruction-for-instruction; the cited dumps are
the byte-level record. (a) `ABTelexApply`'s per-key branch
tree (2,452 B) in `ABTelex.m`: tables, classifier, entry
search and the q/g exceptions are VERIFIED; the branch tree
itself is reconstructed at dispatch level (standard Telex
semantics) — the one knowingly condensed functional area
(AppBridgeB report §9.1). (b) Two C tails verified by pattern:
the connected-case tail of `sub_958C` and the tail of
`sub_6498` (recursion pattern verified at the head; the tail
follows the same presented→children pattern) — AppBridgeB
report §9.3–9.4. The ABKeyboard/ABKey cosmetic geometry that
§9.2 of the same report originally listed as condensed was
written out in full in the phase-2 fix pass (report §11.2),
so it no longer belongs to this item.

**G5 — Perf-machinery modelling choice.** The perf/session
machinery is modelled twice, as the evidence dictates, not
unified: the shared unit's static copy (the one
`_OMCCrashGuard` binds to) and the hoisted `SCPPerfTelemetry`
TU coexist in the rebuilt SplitScreen binary without symbol
collision. The two embedded PerfTicker copies are NOT
textually shared, because the binaries' copies provably
differ — SplitScreen's footprint scale is exactly 2^-20
where Core's is 1.0e-6, with decimated measurement on the
same 250 ms dispatch timer (serial queue
`com.anlai.omnicar.perf`). Whether the original SplitScreen
binary itself carries both copies, or the hoist introduced
the duplication, is not proven either way (BUILD_PHASE2_LOG
gap 19); the reconstruction keeps both, matching the
observable symbol surface. The sampler mechanics themselves
are VERIFIED (PerfTelemetry report).

**G6 — Capstone no-skipdata truncation caveat.** Some
per-function dumps used during reconstruction were produced
with capstone settings under which a data island inside a
function can end the decode early, silently truncating the
function. Mitigation applied in the closure passes: every
re-read function's decoded byte count was checked against
its LC_FUNCTION_STARTS bound (e.g. all nine SpeedBubble
item-7 helpers match exactly), and later end-to-end readings
govern over earlier partial ones. Functions only ever read
from a single early dump carry this residual risk; the two
known annotation-era errors it contributed to (the 0.3 zoom
floor, superseded ABHost defaults) were caught and corrected
by numeric re-reads, and no case is currently known where it
changed a surviving conclusion.

**G7 — Remaining INFERRED pockets.** Structure/role proven,
detail modelled and marked in-source: (a) `-[ABHost
carDisconnected]` — INFERRED (skeleton confirmed; verifier
#1's downgrade stands, §2.4). (b) The `ss_buildParticles`
bitmap dimension bound: the binary emits `cmn 0x1001` range
checks; the source writes `w, h ≤ 0x2000` and tags the bound
[INFERRED from the idiom] inline — the only non-exact
constant in `SSStartupViewBuilders.m`. (c) CarProbe's 11
INFERRED items, consolidated in its report §7 and
spot-checked by verifier #3. (d) Three shared-core functions
as labelled in AppBridgeA's §6 table: `_OMCExpired`
(trustedTime combination), `_OMCLiteActive` (branch detail),
`_OMCCarWireless` (diagCar key path). (e) The
`appBridgeOrientation` default object @0x395b8 is not decoded
byte-exact (AppBridgeA report §7.6); the neighbouring zoom
default was later confirmed as @80. (f) Two flagged
structural liberties in the StartupScreen builders: the
`_sky == 9` arm reuses the cloud block in machine code and
the source writes it out a second time; the festive shared
tail is factored (see G3b).

**G8 — Census heuristic limits.** The census (§3) matches
claims textually, so its counts bound — but do not prove —
completeness: "unclaimed" is dominated by bookkeeping
(§3), CLAIMED_MULTIPLE for the shared OMC* set is by design
(EXPECTED_MULTIPLE), and the AppBridge (75) / SplitScreen
(226) multiple-claim rows are duplicate-definition artefacts
of the multi-agent partition, resolved to single definitions
at integration. The census proves presence or absence of a
claim for every function in the universe; body correctness
rests on the per-module reports, the independent verifier
passes, and the link-level fingerprints of §1.

## 5. Acceptance criteria (against the reconstruction brief)

1. **No original executable is kept as a runtime component**
   — MET. All 8 Mach-O files are compiled from `src/`; the
   only byte-copied files are the 168 non-executable
   resources, catalogued in `project/RESOURCE_PROVENANCE.md`.
2. **No functional stubs remain** — MET. True stub count 0
   in every module (final census, §3); every former stub is
   either reconstructed or listed in §4.
3. **The project builds clean from the canonical source** —
   MET. Phase-3 clean build, exit 0, 0 errors
   (`project/logs/phase3-build-final2.log`); `src/` alone
   reproduces `project/` (BUILD_PHASE3_LOG step 2/3).
4. **Verification scope stated** — §6, below.

NOT claimed: byte-identical binaries (not required and not
achieved — layout and codegen differ); behavioural
equivalence (no device run, §6); arm64e (G1).

## 6. Verification scope

All verification behind this document is structural and
static: payload/file-set comparison, per-binary
class/method/defined-symbol fingerprints, tar-level
ownership/mode parity, and instruction-level re-reads of the
original arm64 slices by independent verifier passes. **No
build from this project has been run on a device.**
Behavioural equivalence with the original — on the car
display or anywhere else — is therefore NOT established by
this document; the on-device programme is
`handover/DEVICE_VERIFY_PLAN.md`, and until it is executed
the correct description of the deliverable is: a complete,
clean-building source reconstruction whose static structure
matches the original on every measure listed in §1, with the
residual gaps of §4.

**Document integrity**: the first publication of this FINAL
edition (Integration Phase 3, 2026-11-08) was itself damaged
in production — the file ended mid-sentence in §2.6, losing
the tail of §2.6 and §§2.7–6, including the §4 gaps list the
README cites. This is the restored complete edition: the
surviving head (through mid-§2.6) is the phase-3 text
verbatim; the remainder was re-derived on 2026-11-08
(remediation) from `project/BUILD_PHASE3_LOG.md`,
`project/BUILD_PHASE2_LOG.md`, the final census
(`metadata/COVERAGE_GAPS.md`) and the module reports, and is
recorded here as restored rather than silently replaced.
The pre-phase-3 draft of this document (24,206 B) no longer
exists anywhere and was not used.

## 7. Remediation addendum (2026-11-08) — external review round

An external review (audit of the published repo at commit 3608d63)
found this document cut short in its published form (restored; see
the integrity note at the end of section 6) and raised four
substantive points: unadjudicated census rows, INFERRED pockets in
SplitScreen presentation logic, count-based (not body-based)
verification, and unproven fresh-checkout buildability. All four
were worked this round; results below. Full evidence:
`metadata/CENSUS_ADJUDICATION.md` (incl. its CLOSURE-2 addendum) and
the `rem_*.txt` / `rem2_*.txt` dumps under `src/*/disasm/`.

### 7.1 Census adjudication (FUNCTION_SOURCE_MAP, 3,280 rows)

- 675 UNCLAIMED rows = 664 bookkeeping (compiler-synthesised
  `.cxx_destruct`, block invoke/copy/dispose helpers, libroot and
  protection shims, shared-twin statics claimed in a sibling binary,
  veneer thunks, census-parser artefacts on block-typed and
  multi-declarator properties) + 11 genuinely missing bodies.
- 301 CLAIMED_MULTIPLE rows are benign: the parallel A/B duplicate
  source trees plus shared-unit definitions; 54 EXPECTED_MULTIPLE
  rows are shared OMCCommon copies by design.
- All 8 CLAIMED_STUB flags are false positives — real bodies whose
  provenance comments contain the detector's trigger phrase.

### 7.2 The 11 genuinely missing bodies — closed; now 0

- 4 by the INFERRED-closure pass (SplitScreen helpers inside
  `src/SplitScreenA/SCPCarSplit.m`): SCPFindHomeGlyph,
  SCPScanStatusBarBaseline, SCPLauncherGlyphImage, SCPDumpDockTree.
- 7 by CLOSURE-2: M1/M2, the two Prefs
  `tableView:willDisplay{Header,Footer}View:forSection:` tail-call
  shims (restoring OMCAppBridgeAppsController to 105/105 methods —
  the phase-3 aggregate 743/743 had masked this per-class gap);
  C1/C2, the SpeedBubble `__init_3` diagnostic stamp and its block;
  C7, the SplitScreen loader-timeout block invoke (the whole parent
  `hostApp:inPane:` was re-read and corrected); C8/C9, the Prefs
  share-report section formatter and conflicting-tweaks name
  normaliser in `OMCCommon.m`.
- Link fix: `static` dropped from SCPWalkerSafeGet /
  SCPWalkerIconBundleID in `src/SplitScreenC/SCPCarApps.m` — the
  binary carries one shared copy and SplitScreenA declares them
  extern.

### 7.3 Four named areas re-read from the binary and corrected

All in `src/SplitScreenA/SCPCarSplit.m` (IMP addresses are the
original binary's):

- `repairPresentedViewController:` (0x19e04) — the INFERRED one-liner
  was replaced. The binary contains NO `wantsViewController:` /
  adopt call: if no pane owns the presented VC, it un-hides the
  leftover view tree (SCPResetDetachedView) and logs. It adopts
  nothing.
- `pushSceneSizes` (0x1c550) — one-liner replaced. The binary never
  calls `pushHostFramesLive:`; it records changed scene sizes for
  non-hosted panes (>= 2x2), foregrounds each scene at that size,
  and schedules +0.4 s / +0.9 s fix-ups. No `self.active` check
  exists in the body.
- Cell/slot selection — `slotOccupied:` (0x10df4) corrected (a slot
  is occupied by a VC, by the picker, or by any pending launch
  targeting it — the old body missed the picker test);
  `autoSlot` (0x115a0) rewritten: first unoccupied slot, else the
  focused slot clamped when unpinned, else the first unpinned slot.
  There is no float-slot/9 fallback in the binary.
- App-reopen conditions — the predicate in `activateWithCount:`
  (0x15cdc) was verified instruction-level (csinc at
  0x15de0-0x15e00): reopen resolution runs iff `currentBase &&
  !suppressReopen && isAdoptableViewController:`; the solo-hosted
  fallback bundle is likewise gated on `!suppressReopen`.

### 7.4 Condensed-fidelity residuals (documented, left open)

- Picker sheet grid constant corrected this round: 18.0 -> 14.0 in
  `src/SplitScreenB/SCPCarSplit+Picker.m` (the binary's chain at
  0x33afc is gridH + 8.0 + extra + 6.0).
- Panel empty-state placeholder: its frame is verified and was
  corrected (CGRectMake(48, runningY + 8, 73, 40)), but the
  placeholder's layer/label construction remains a condensed
  rendering of the binary's, not a 1:1 reproduction.
- Tray window: the binary builds a dynamic class pair
  (`objc_allocateClassPair`, a copied `hitTest:withEvent:` IMP,
  `objc_registerClassPair`, then `object_setClass` on the window —
  0x37ba4-0x37bec in `trayWindowForParent:`). The reconstruction
  uses a plain `UIWindow` and omits the dynamic subclass; the
  omission is recorded here rather than hidden.
- SplitScreenB cosmetic INFERRED residue, deliberately left
  labelled: invented helper names, log-wording guesses, the
  dash-pattern contents (@[@4, @3]), the "style-11" naming, and one
  call-target name in `refreshPickerSheet`.

### 7.5 Fresh-checkout build proof and portability fixes

- A standalone clone of the published repo (outside both working
  trees) built clean: exit 0, all 8 components (log:
  `project/logs/fresh-checkout-build.log`). The diff from that build
  (`project/logs/fresh-checkout-diff.txt`) reproduces the phase-3
  structural profile: 176 files, 168/168 non-Mach-O resources
  byte-identical, classes exact on all 8 binaries, method counts
  exact except the documented additives (SpeedBubble +1,
  StartupScreen +2), 0 original defined symbols missing.
- Portability: `project/tools/diff_payload.py`, `verify/audit_*.py`,
  and `metadata/tools/{build_maps,coverage_census}.py` now derive
  their roots from `__file__` instead of the analysis workspace, and
  `handover/BUILD_GUIDE.md` paths were corrected to the published
  layout. The published tools no longer reference
  `~/workspace/omnicar-re`.

### 7.6 Status after remediation

Genuinely missing bodies: 0. Per-class method parity is re-verified
in the remediation build (see `project/REMEDIATION_LOG.md`).
Verification remains structural/static only — no device run has
been performed (section 6 unchanged), and the build remains
arm64-only (G1 unchanged).

## 8. Remediation addendum 2 (2026-11-08) — second external review round

A second external audit of the published tree (commit b4d652e)
confirmed round 1's repairs but raised three further points:
(1) the tray window's touch mechanism had been omitted
altogether, not merely condensed; (2) gaps G4–G7 still
contained unverified material beyond the round-1 summary;
(3) the fresh-checkout evidence in the tree predated the
final round-1 build numbers. All three were worked in this
round; results below. Evidence: `project/REMEDIATION2_LOG.md`,
`project/logs/remediation2-*.txt`, and the `rem4_*.txt`
dumps under `src/*/disasm/`.

### 8.1 Tray window touch mechanism — RESTORED

`trayWindowForParent:` (SCPCarSplit+Picker.m) previously
created a plain UIWindow. The original (IMP
@0x3782c..0x37e8c, read end-to-end; dumps
`disasm/rem4_trayWindowForParent.txt` and
`disasm/rem4_tray_hitTest_481c8.txt`) does materially more,
and the function is now rewritten to match it in full:

- The window is a `UIRootSceneWindow` created from the
  parent screen's `FBSDisplayConfiguration`, not
  `[[UIWindow alloc] initWithFrame:]`.
- It is re-classed (`object_setClass`) into a
  runtime-registered subclass named
  `SCPCPass_<the window's own class>` whose only added
  method is a `hitTest:withEvent:` override (IMP
  @0x481c8): the override forwards to super via
  `objc_msgSendSuper` and returns **nil when the hit view
  is the window itself** — touches landing on the tray
  window's empty areas fall through to whatever is
  underneath; subview hits are returned unchanged.
- Window level is `UIWindowLevelStatusBar + 65.0` (the
  parent window's level is never read; CLOSURE-2);
  background clear.

The earlier condensed body was wrong, not cosmetic; the
module report row is now VERIFIED (rem4).

### 8.2 G4 — CLOSED

- **ABTelexApply branch tree**: the full 2,452-byte per-key
  branch tree is transcribed in `ABTelex.m` (capstone
  skipdata, 2452/2452 B, 613 insns, 0 data islands;
  classifier 500/500 B, generator 284/284 B).
  Cross-verification: an ARM64 interpreter executing the
  original IMP (Foundation modelled) was diffed against
  the transcribed structured model over **253,908
  (word, key) cases — 0 mismatches**, including every
  case where the binary raises NSRangeException. The
  transcription surfaced eight divergences from standard
  Telex, flagged [DIVERGENCE 1-8] in `ABTelex.m`
  (AppBridgeB_REPORT §9.1).
- **sub_958C connected-case tail**: full body line-read
  (252/252 B): when the device is non-nil the tail is
  only the release of the device and the return (plus
  the unwind landing pad) — the connected case is a
  genuine no-op (AppBridgeB_REPORT §9.3).
- **sub_6498 tail**: full body line-read (696/696 B) with
  two source corrections: (a) the mask return rule was
  INVERTED in the draft — the binary returns the mask
  when a landscape bit is set AND the portrait bit is
  CLEAR (`(m & 0x18) != 0 && (m & 0x2) == 0`); (b) the
  presented-view-controller recursion is gated on
  `!isBeingDismissed`; the draft recursed
  unconditionally. Both fixed in `ABInApp.m`
  (AppBridgeB_REPORT §9.4).

Nothing in G4 remains condensed except the declared
cosmetic layout code (AppBridgeB_REPORT §9 item 2),
unchanged.

### 8.3 G5 — CLOSED (verdict ii); build fix applied

Face-value close of G5: the original SplitScreen binary
carries ONE perf/session cluster — queue creation
sub_52bfc ×1, sampler sub_53f90, consumer sub_54448, flush
sub_548a0 — instruction-identical to Core's single cluster
modulo layout. The reconstruction carried a second full
copy inside its shared OMCCommon unit; the Core and
AppBridge re-reads showed the duplication was introduced
by the reconstruction, not by the original (verdict ii).
The duplicate copy's four apparent differences were
misreads and are corrected in `src/OMCCommon/OMCCommon.c`:
decimation is %20, the link decision is count %12==4, the
scales are exactly 2^-20, and availability is `ucvtf #0x14`.

Build fix (this round): `src/OMCCommon/OMCCommon.c` now
wraps the perf/session cluster (perf statics, sampler,
car-probing and session helpers) in
`#ifndef OMC_NO_PERF_CLUSTER`; the only declarations
visible under the guard are OMCCrashGuard's two entry
points (`OMCOnScreenConnected` /
`OMCOnScreenDisconnected`), which resolve to
SCPSessionCore.m. The SplitScreen target compiles the
shared unit with `-DOMC_NO_PERF_CLUSTER`
(`project/OmniCarSplitScreen/Makefile`), and
SCPPerfTelemetry.m + SCPSessionCore.m are that target's
single cluster instance. All other consumers keep the
full section. Verification on the built binary (arm64
code sites referencing the cluster's strings, capstone
site count): queue label `com.anlai.omnicar.perf` —
original 1 site (@0x52f8c), round-1 build 2 sites, this
build **1 site**; `diagPerf` __cfstring — original 1
(@0x54de4), round-1 build 2, this build **1**. Built
OmniCarSplitScreen.dylib is 520,832 B vs the round-1
build's 537,264 B (−16,432 B of duplicated cluster code).

### 8.4 G7 — CLOSED

Every remaining INFERRED pocket was line-read in the
original binaries in this round; none remains inferred:

- (a) `-[ABHost carDisconnected]` @0x163e8 — CONFIRMED
  VERIFIED: B's surviving text (`ABHostBMethods.m`)
  matches instruction-for-instruction, incl. the
  count→window short-circuit and the re-read count in
  the log call; the earlier verifier downgrade applied
  to a since-removed A-side skeleton and is superseded.
- (b) CarProbe's 11 items — all adjudicated end-to-end
  in OmniCarCarProbe.dylib (CarProbe_REPORT §7, dumps
  `disasm/rem4_*`): items 1–5 confirmed exactly
  (liteMode default @2 from the constant object
  @0x11ea0; CrashGuard installs unconditional on the
  fresh-session path; `age=`/`suspect=`/`last=` parse
  mechanics literal; signal handler
  `open(path, 0x209, 0644)` with a 64-frame backtrace in
  its own body; sigaction template @0xd048 = mask 0,
  flags SA_SIGINFO, signals {11,10,6,4,5,8}); items 6–11
  corrected in source (0x705c is not a function but the
  constructor's `__dispatch_main_q` load; log-rotation
  suffix is ".old", not ".1"; CARSessionStatus created
  with `objc_opt_new`; display-link cadence
  `count % 12 == 4`; the `hangMaxMs` update sits outside
  the ≥2 s branch; logo-mesh gradient stops are
  (R, G, B, factor) → (R, G, B, 0)).
- (c) `_OMCExpired` (effNow = max(now, trustedTime)),
  `_OMCLiteActive` (3 s cache; mode 1/2 branch
  structure) and `_OMCCarWireless` (diagCar
  session→configuration key path) — all CONFIRMED
  against the AppBridge copies; the shared OMCCommon
  texts are exact (AppBridgeA_REPORT §6).
- (d) `ss_buildParticles` bitmap guard is exact:
  dimensions converted with `fcvtpu` (ceil); the bitmap
  is built only when 2 ≤ dim ≤ 0x1000, width then
  height; source corrected from the inferred ≤ 0x2000
  form (StartupScreenB_REPORT, dump
  `disasm/rem4_buildParticles.txt`).
- (e) The `appBridgeOrientation` default object
  @0x395b8 is decoded byte-exact as @1 (`__objc_intobj`,
  payload at +16); `ABHostLaunch.m` corrected from nil.

Remaining INFERRED labels in the tree are the declared
cosmetic set (SplitScreenB colour/log-wording/name
items; AppBridgeB_REPORT §9 item 2 cosmetic layout) and
G2's open cross-check — unchanged.

### 8.5 Panel placeholder + dash pattern — CLOSED

In `showLayoutPanelForApp:`'s placeholder block: the
dash layer is now a separate `[CAShapeLayer layer]`
added as a sublayer of the placeholder's layer (the
draft cast `placeholder.layer`); the labels are the
binary's strings (Vietnamese "Chia màn xong sẽ hiện ở
đây", English "Your splits will show up here"); the
dash pattern constant is **@[@3, @3]**, read from the
constant array @0x80500 (both slots the same
NSConstantIntegerNumber @0x807e0 = 3) — the draft's
@[@4, @3] was wrong (dump
`disasm/rem4_panel_placeholder.txt`).

### 8.6 Round-2 build + verification

Fresh clean build of the integrated round-2 tree: exit
0, 0 errors, all 8 components
(`project/logs/remediation2-build.log`). Per-class
selector comparison, 66 classes
(`project/logs/remediation2-perclass.txt`): **62/66
exact, zero classes missing any original selector**;
the 4 exceptions are the same built-side additive-only
deltas as round 1 (SPPBubble +1; SSStartupView in
StartupScreen +2 festive helpers; OMCSplitScreen-
Controller +`gestureSwitchChanged:`; SSStartupView in
Prefs +`gradientLayer`). OMCAppBridgeAppsController is
105 = 105 exact. Aggregate
(`project/logs/remediation2-diff.txt`): 176 = 176
files, 168/168 non-Mach-O byte-identical, 0 original
defined symbols missing in any binary; the Prefs total
743 → 745 built is exactly the round-1 additive pair
(M1/M2 are inside the original's 743). Parity restage
as before (per-path modes, uid 501 : gid 20,
Installed-Size 3524, `dpkg-deb -Zxz`): data tar 202/202
entries, 0 differences; control modes match, control
ownership normalised to 0:0 by dpkg-deb (accepted
deviation, see §7). Rebuilt DEB: **947,056 B,
SHA-256
93cdcad934ea5b363665c69051c1368c40143c163e0919b1310a36e503a162bd**.

G1 (arm64-only local build; FAT untested) and §6 (no
device run; behavioural equivalence not established)
are unchanged. A macOS CI workflow for the FAT
arm64+arm64e build is provided at `ci/build-fat-macos.yml`
in this tree for placement under `.github/workflows/`
by the coordinator. Fresh-checkout verification of this
round's final commit is the coordinator's closing step
(the round-1 in-tree evidence described pre-remediation
numbers and is superseded by this addendum).

## 9. Hotfix addendum (2026-11-08) — device crash, hook-contract defect class

Acceptance round 1 put the round-2 rebuilt DEB (`93cdcad9…`)
on the test device (iPhone X, iOS 16.7.16, palera1n rootless).
SpringBoard crash-looped: four SIGABRT crash reports in about
a minute, one signature — an uncaught exception inside
`-[SBApplicationRestrictionController initWithDataSource:]`
during lazy `SBApplicationController` creation, reached from
an `os_state` capture roughly two seconds after launch. No
OmniCar frame appears in any backtrace. An external review of
the source then found the defect class below; every item was
re-verified against the source and the original's dumps
before fixing.

**Defect 1 — five unwired hook originals (AppBridge host).**
All five installers in `AppBridgeEntry.m` passed NULL as the
MSHookMessageEx / MSHookFunction original-IMP out-pointer
(original slots 0x3E9F0–0x3EA10), while the handlers in
`ABHostGeometry.m` call those orig variables — NULL-IMP calls
on the suspended-under-lock, scene-update, reference-size and
screen-blanked paths. Worst, `ABSpringBoardReady` never
called the original `applicationDidFinishLaunching:` IMP at
all (the call site held only an "elided here" comment),
severing SpringBoard's launch chain; the original `sub_7004`
calls its orig FIRST, before logging and registering
(`disasm/registrar_7004.txt` @0x7028–0x703C). All five
originals are now wired, `ABSpringBoardReady` calls
`orig_SBDidFinishLaunching` first, exactly once, and the
`ABHook_SBSuspended` extern declaration was corrected from
`void` to the implemented `BOOL`.

**Defect 2 — the same host group was installed twice.**
The parallel A/B reconstructions both claimed ctor 0x6E08:
`ABChannels.m` (tree A) and `AppBridgeEntry.m` (tree B) each
installed the same five host hooks, so the built product
chained every one of them twice and ran the registrar twice.
The original installs each exactly once (`ctor_host_6e08.txt`:
4× MSHookMessageEx + 1× MSHookFunction, the latter a tail
call @0x6f80). Resolution: tree A's constructor is disabled
(kept in-tree as reference), tree B is the sole installer,
and the four channel blocks B lacked (open / close /
closeall / knobs — sub_783C / 8DF0 / 8FD4 / 9144) were ported
from tree A's verified bodies into `ABHostGeometry.m`, so
the registrar registers all six channels in the dump's
order. Built-binary proof (`logs/hotfix-hookcount.txt`,
capstone count over ctor extents): original 4+1, installed
once; pre-hotfix built 4+1 in EACH of two ctors (twice);
hotfix built 4+1 in one ctor (once).

**Review round 2 — further items, dispositions.** (1)
`OMCHasMethod` signature — FIXED: the header declared the
selector argument `const char *`, the implementation takes
`NSString *`, and one call site passed a C string the impl
would message as an object; declaration and call site now
pass the NSString the original passes (cfstring at
`installer_app_4728.txt` @0x491c–0x492c). (2) CADisplayLink
hook targets — FIXED: the two FPS setters were hooked on the
metaclass although they are instance methods; the original
uses the metaclass only for `+displayLinkWithTarget:selector:`
and the instance class for the setters, so `ABApplyFPSLimit`'s
orig pointers are now genuinely assigned. (3) PID read —
FIXED: `SCPKillAppBlock`'s fallback obtained a pid through an
`id`-returning helper (an object round-trip for an integer);
restored to the original's typed inline guarded send. One
micro-gap is recorded, not fixed: the fallback lacks the
original's failure log line `@"tat han %@: khong thay
process"` — log-only, no behavioural effect. (4)
`closeApp:terminate:` — RESTORED: the reconstructed tail
stopped at pane teardown; the original's remainder
(frontmost-on-phone guard, then `FBSSystemService
terminateApplication:forReason:andReport:withDescription:`)
was transcribed from the full method dump. (5) Screen
unblank — VERIFIED already correct: tree B's
`ABHook_ScreenBlanked` matches sub_777C point-for-point.
(6) Tree A's Darwin consumers — VERIFIED dead code: they
were registered only from tree A's now-disabled registrar
and have zero live callers; tree B's consumers decode the
packed state correctly (bundle hash at bits 24+) and handle
keyboard show and hide. (7) Tree B scene semantics —
VERIFIED correct: its FBScene handler tests foreground
state on the settings argument, and its reference-size
orientation clamp (>4 → 3) is the dump-proven one.

**Tree-wide hook-contract audit.** Every MSHookMessageEx /
MSHookFunction site in all eight components was checked for
(a) a real orig out-pointer, (b) the handler chaining to its
orig where the original does, (c) no orig variable assigned
anywhere but its own installer, (d) declaration/implementation
signature agreement. The defect class is confined to the
AppBridgeB host group above: all 56 other install sites are
clean, and the hook census reconciles with `HOOK_MAP.md`
(54 + 2) once the duplicate group is counted once (source
previously carried 58 + 3 including the duplicate).

**Verification-gap admission.** Rounds 1–2 verified selector
parity per class, the coverage census, payload identity and
the FAT build — none of which audits orig wiring or
installer uniqueness. A hook can present a perfect selector
profile while breaking the very chain it hooks, and the
swallowed `applicationDidFinishLaunching:` original did
exactly that. The hook-contract audit is now a standing
verification axis alongside selector parity.

**Rebuild evidence.** Clean build exit 0; per-class 62/66
exact, zero classes missing selectors, Prefs 743→745,
OMCAppBridgeAppsController 105=105; payload 176/176 files,
168/168 non-Mach-O byte-identical, zero original symbols
missing; parity restage 202/202 entries, 0 differences. New
rebuilt DEB: 949,028 bytes, SHA-256
`ff4c9e7e7901e071b1897d0e8572f0f2c56d986888018219d2704fe327666798`
(supersedes `93cdcad9…`).

**Status.** The source defects are confirmed and fixed. That
they caused the four device crashes is the leading
explanation — the severed launch chain and the double
registration sit exactly on SpringBoard's startup path, and
the crashes are startup crashes — but it is NOT proven: no
OmniCar frame exists in the crash backtraces. Proof is the
device retest, ordered startup-first (install, respring,
SpringBoard stability), then the acceptance groups. Until
that retest passes, behavioural equivalence remains
unproven.

## 10. Fix round 2 addendum (2026-11-08) — §8 E1/E2 fixes, E3 integration

The audits behind §8's remaining items (installer invariants,
registrar completeness, lifecycle/FPS, log/pid scalars, rescue
strings) were worked as source fixes (E1), verified by a host
harness (E2), and integrated in a finishing pass (E3). Full
change record: `handover/PATCH_NOTES.md`. Evidence:
`project/logs/fix-round/` (`build.log`, `perclass.txt`,
`diff.txt`, `hookcount.txt`, `static-checks.txt`,
`uuid-manifest.txt`, `harness/results.txt`, `SUMMARY.md`).

**What changed** (see PATCH_NOTES §1–§2 for the full matrix):
the five host installs now live in a single new installer,
`ABInstallSpringBoardHooks` in ABHostGeometry.m, with a
re-entry guard (set before installing), per-hook class/method/
encoding pre-checks (existence = hard gate, encoding =
structural check), and the original's OMCCheckHooks call; the
ctor is reduced to its bundle gate plus one call. The
ABChannels duplicate installer and its repl_* handlers are now
`#if 0`-neutralised (previously merely disabled and still
compiled). The registrar gained a once-guard. Also fixed:
FBScene completion typedef, ScreenBlanked BOOL unification,
@try wrappers on the frame/open/shield/close/closeall/knobs
channel handlers, the open handler's stray guard and `aw`
condition, D2-6 per-method gates and D2-7 FPS NULL guards in
the in-app installer, the D5 variadic OMCLogWrite prototype
and its 33 call sites, Prefs' OMCHSInstalled BOOL read,
SCPKillAppBlock's missing failure log line, and the rescue
announcer's six Vietnamese literals (root cause: UTF-16LE
cfstrings misread as C strings at extraction, leaving
1-character literals; the fix is the verbatim binary strings).

**Rebuild evidence.** Clean build exit 0, 0 errors. Per-class
62/66 exact, zero classes missing selectors, Prefs 743→745,
OMCAppBridgeAppsController 105=105, SplitScreen 480=480.
Payload 176/176 files, 168/168 non-Mach-O byte-identical, 0
original defined symbols missing. Hook count on the built
AppBridge dylib: exactly one host installer (4×
MSHookMessageEx + 1× MSHookFunction), the in-app installer
separate at 13×, total __text sites down from the hotfix
build's 21+2 to 17+1 — the ABChannels copies are absent from
the binary, not merely unregistered. Harness: 274 assertions,
0 failures. Parity restage 202/202 entries, 0 differences.
New rebuilt DEB: 948,844 bytes, SHA-256
`d1502121ffe13a7b49c275db841d9b586a5458dfc53d86ab30f9703724ebe4ef`
(supersedes the hotfix `ff4c9e7e…`).

**UUID attribution — the crash question is settled by the
bytes.** A full LC_UUID manifest for the original, the
preserved FAT hotfix DEB, and this build is in
`logs/fix-round/uuid-manifest.txt`. Headlines: the original's
AppBridge arm64 UUID is
`81ef5920-bb7a-37e8-b953-d88453f2ea89`; the FAT hotfix build's
is `c1d34cc2-62c6-3b11-97e4-9317a7951558`, which does NOT
match the crash-log (.ips) UUID
`4c4c4461-5555-3144-a17f-f759d99c2ab7`. The round-2 DEB
(`93cdcad9…`, no longer in the canonical packages slot but
found SHA-verified in four clone checkouts under the
workspace) has AppBridge arm64 UUID
`4c4c4461-5555-3144-a17f-f759d99c2ab7` — an exact MATCH.
The .ips files therefore belong to the round-2 build that
was installed for acceptance round 1, not to the FAT hotfix
build (which was produced later and was never the crashed
install). This build's AppBridge UUID is
`4c4c4413-5555-3144-a192-3f49022cb8b1`.

**Flags carried forward** (PATCH_NOTES §3/§5): the FBScene
swallowed path drops the completion 0× — binary-faithful
(the original releases it uninvoked at 0x7680), deliberately
unchanged, flagged for GPT acceptance; the D2-6 per-method
checks are a work-order hardening beyond the binary's single
OMCHasMethod gate; three single-letter OMCTr toast sites in
SCPCarSplit.m (~422/448/1580) share the rescue defect class
and were NOT fixed — their binary strings are not yet
extracted.

**Status.** DEVICE_TEST = PENDING: no fix-round-2 build has
run on a device, and §6's scope statement is unchanged —
verification remains structural/static plus the host harness.
The startup-first device retest is still the proof step.

**§10 addendum — build2 (2026-11-08), toast strings.** The
three flagged toast clusters above have since been resolved:
a full sweep found nine single-character `OMCTr` viText sites
in `SCPCarSplit.m` (lines 422, 437, 446, 448, 449, 859, 1294,
1580, 2810), and all nine binary strings were extracted by
cfstring-struct parse of the original `OmniCarSplitScreen`
(both slices identical) and restored verbatim — see
PATCH_NOTES §6 and `work/fix-round2/audit-toasts.md`. The
build1 candidate `d1502121…` is superseded by build2:
SHA-256
`3b2283a84ad0c1d83c68203e65418a4dc0d8bb94d10b0732249ac81e34fb9b6c`,
949,244 B, parity restage 202/202 entries, 0 differences;
per-class parity and the hook-install count are unchanged.
DEVICE_TEST = PENDING, unchanged.

## 11. Fix round build3 (2026-11-08) — Portrait crash, literal sweep, Track 2

GPT identified a new defect class from the device log (it was
not in the TXT work order): reconstructed code transcribing
original-binary VAs as absolute runtime pointers. The instance
that crashed: `SCPGridDimension` in SCPHomeHooks.m dereferenced
0x87f60 — the original's `__thread_vars` descriptor VA — on the
first grid query (device log: signal 11, fault addr 0x87f60,
`SCPHook_PortraitColumns +144`; instruction proof in
PATCH_NOTES §7a and `project/logs/fix-round/regression3.txt`).

Fixes, all faithful-pattern (real TLS / self-referential keys):
the grid helper now uses a real `static __thread BOOL` guard
with the original's @try/@catch structure and unsigned
thresholds; ABInApp.m's associated-object key 0x3E9E4 (an
address-as-key in the original, never dereferenced) is
self-referential; SSStartupScreen.m's two NULL associated-
object keys are self-referential. A tree-wide sweep (349 files,
619 code literals, 304 ≥0x1000 hand-classified) found exactly
those 2 literal defects + 1 sibling; sibling icon hooks and
SBIconImageInfoCompat audited clean. Track 2 (Preferences):
two format-arg defects in OMCCommon.m fixed with original
evidence (CHK_CRASH_AT's missing second %@ argument was
crash-class on the Send-Log path; CHK_PACKAGE_OK now passes
the module count); OMCWhatsNewVersionToShow rewritten to
sub_198c4 — +shouldShow is now NO with the shipped plist, as in
the original — with the recorded caveat that WhatsNew's
responsibility for the Settings kick-back remains UNPROVEN
(suspect #1; conviction needs a Preferences .ips). The
OMCHSInstalled typed-msgSend change was cleared against the
original's sub_24e0c. Two divergences are documented, not
fixed: the SplitScreen OMCCheckHooks nil second list
(diagnostic log only) and a cosmetic log prefix in
SCPHomeVisibility.m:147. Full report:
`work/fix-round2/audit-portrait.md`; change record:
PATCH_NOTES §7.

**Rebuild evidence.** Clean build exit 0, 0 errors
(`logs/fix-round/build3.log`). Binary regression proof
(`regression3.txt`): #0x7f60 materialisations in __text
2 → 0; TLV descriptor access present; __thread_vars /
__thread_bss sections present. Per-class 62/66 exact, zero
classes missing selectors, Prefs 743→745, SplitScreen
480=480, AppBridge 193=193 (`perclass3.txt`); hook count
17+1, single host installer (`hookcount3.txt`); payload
176/176 files, 168/168 non-Mach-O byte-identical, 0 original
symbols missing (`diff3.txt`); parity restage 202/202
entries, 0 differences. New rebuilt DEB: 949,352 bytes,
SHA-256
`7f2701d90327c1f89c23332338f6d8fbc6451b327c31d3f5e466e220dde39d74`
(supersedes the build2 candidate `3b2283a8…`).

**Status.** DEVICE_TEST = PENDING: no build3 has run on a
device, and §6's scope statement is unchanged — verification
remains structural/static. The device still carries the
CrashGuard rescue state from the crash-loop (only the speed
bubble shows); that state is evidence, not a fault of this
build, and clearing it is a separate, deliberate step.

## 12. Settings conviction + branch-fidelity round (2026-11-08)

**Device verdict that opened the round.** On the user's device, with
the current prefs/rescue state untouched, the ORIGINAL 1.0.3 Settings
pane opens normally while every rebuilt build ejected Preferences.
Three Preferences .ips reports (18:12–18:14) convicted the cell path:
an uncaught unrecognized-selector exception inside
`-[PSListController tableView:cellForRowAtIndexPath:]`, called from our
`-[OMCRootListController tableView:cellForRowAtIndexPath:]` (Prefs
+0x1CFA0, UUID-verified against the portraitfix build).

**Root cause (device-proven).** `insertFeatureSpecifiers` stamped the
specifier `cellClass` property with an NSString
(`NSStringFromClass(...)`); the original stamps the Class object.
PSListController consumes the property as a Class during cell creation,
so the first feature row's cell creation threw. FIXED. The
load-surface diff and the AppBridge-in-Preferences surface are CLEAN —
recorded in PATCH_NOTES §12.1 and
`work/fix-round2/audit-prefs.md`. A full specifier-surface coverage
audit (two independent passes) found no further defect on that surface.

**Also fixed this round** (all disasm-verified against the original;
details + causal separations in PATCH_NOTES §12.2–§12.4): the ×4
super-guard inversion and the `OMCStyleHeaderFooter` parameter
restoration in Prefs; the forced `UITableViewCellStyleValue1` cell
inits; the unconditional featureKey/featureDefault stamps; the
AppBridge `setDelegate:` / `_createSceneViewController` send-signature
defects, the restored 2.5 s reveal-then-ready fallback, and launch
milestone logging; and the SplitScreen branch restorations
(`rootDidLayout`, `refreshHomeButton` keep-check, `refreshAppTab`,
`autoLaunchAttempt:`, `dashboardInvalidated`, the
`dismissBaseViewController` hook).

**Completeness claim — WITHDRAWN.** Earlier sections of this document
(in particular the §6 verification-scope framing) could be read as
claiming behavioural completeness for the reconstruction on the basis
of census/selector parity. That reading is now SUPERSEDED: parity
stands as measured, but the "VERIFIED" labels never covered branch
structure or call order, and every defect found this round sat under
one. Branch fidelity is recorded as a separate audit axis in
PATCH_NOTES §12.5, with the exact list of branch-verified functions in
§12.6; everything outside that list remains branch-UNVERIFIED, and
acceptance proceeds by runtime-path testing against the original.

**Build.** Clean local build (build5) exit 0; payload diff 176 = 176
files, resources 168/168 byte-identical, 0 original defined symbols
missing in any binary, Prefs methods 743→745 (known additive pair);
parity restage 202/202 entries, 0 differences. New rebuilt DEB:
949,828 bytes, SHA-256
`4d794d087689b74d58e244ec6ce206d48c6fad8ddbc40bfe4cbface5dde4a7b6`
(supersedes the build3 candidate `7f2701d90…`).

**Status.** DEVICE_TEST = PENDING. First gate: Settings → OmniCar
opens. The device still carries the CrashGuard rescue state from the
earlier crash-loop (splitScreen + startupScreen disabled by rescue);
re-enabling those features in the pane is the designed device-side
recovery step once the pane opens, not a code change.

## 13. Consolidated-fix round (2026-11-08) — governing file applied, B-gates closed

The round was re-scoped by GPT's consolidated fix file, which
superseded the piecemeal briefs and §12 where they conflict. The
confirmed patch (A1–A6) was reconciled hunk by hunk (PATCH_NOTES §13);
notably, §12.2's OMCStyleHeaderFooter parameter restoration is
REVERTED — per §D of the file it is a recorded fidelity gap, not
restored this round. The §12.6 withdrawal of the behavioural-
completeness claim stands and is unchanged.

**Hard gates closed from the original binary:** B2
(autoLaunchAttempt:) — independent block dumps, 14/14 match. B1
(ensureContainer) — the touched block at 0x12b78 was dumped in full
from the original dylib (signature void (^)(CGPoint, UIView*), one
weak capture; hideBarsForTouchOn:/setFocusedSlot:/flashFocusOnPane:)
and the function restored to the verified 14-step sequence (correct
parent, fresh view + fresh slots/fractions/dividers per entry,
raise, loggedArea, app-area frame, container log).

**ABI:** C1 send-helper sweep 35/35 OK; C3 ABInvokeIdentityGetter
aligned to the original adapter's raw-slot pattern plus a labelled
hardening gate; C2's residual (definitive _createSceneViewController
encoding) is settled by the candidate's own runtime MILESTONE log by
design. **§F diagnostics** added for Settings (incl. the cellClass
runtime-class line + log-and-rethrow trap; a module-local OMCLogWrite
embedding was required and is recorded), Dock (gate outcomes on
transitions; remove path names the failed gate), and App
(request/attach/teardown milestones). **Spot-audit trio closed**
(refreshHomeButton same-site adjudication; hostSolo + a bonus
setTrayHidesBridge polarity fix; pushHostFramesLive tail).

**Build.** Clean local build (build6) exit 0 after restoring ldid
from the workspace backup (VM /usr rollback). Payload diff 176=176,
resources 168/168 byte-identical, 0 missing defined symbols; G8
disassembly confirms the A/B branches in the shipped binaries;
parity restage 202/202, 0 differences. New rebuilt DEB: 952,700
bytes, `com.anlai.omnicar_1.0.3-rebuilt-consolidated_iphoneos-arm64.deb`,
SHA-256
`c1fc85c75f77ff8ba2787200855cc31120d432c0e7169e9f5058eda11a5c8092`
(supersedes the §12 candidate `4d794d08…`). Per-binary UUIDs:
`project/logs/fix-round/g8-build6.txt`.

**Status.** DEVICE_TEST = PENDING (acceptance session per §H of the
consolidated file). The macOS-CI FAT build and the GitHub push are
the parent agent's steps; this tree + staging are the hand-off.

## 14. Arity + StartupScreen policy round (2026-11-08) — build9, arityfix candidate

Full change record: `handover/PATCH_NOTES.md` §14. Fix reports:
`work/fix-round2/fix-arity-wfix1.md` (W-FIX1),
`fix-startup-wfix2.md` (W-FIX2), `fix-splitspelling-wfix4.md`
(W-FIX4, the shipped spelling). Integration attempts build7
(-Wnonnull, CarProbe) and build8 (-Wnullability-completeness,
Core) were BLOCKED and are recorded in
`integration-arityfix.md` / `integration-arityfix2.md`; this
section is the build9 re-run (W-INT3).

**Defect 1 — OMCPref arity (SplitScreen SIGBUS).** Causal
label: **device-proven by UUID-matched .ips** — 9 crashes,
fault pointer = the `@"autoLaunch"` __cstring at shipped slice
0x54AD2. SCPShared.h declared OMCPref 1-arg while the linked
shared-core definition is 2-arg (OMCCommon.c:122); the two
1-arg calls (SCPPrefs.m:14,16, feeding every SCPPrefs getter
incl. +autoLaunch) left x1 = register garbage as the default.
Fixed: both calls → `OMCPref(key, nil)`; all 28 OMCPref
prototypes unified to arity 2. The audit's same-pattern find,
**OMCTr** (OMCCore.h:121 declared 1-arg vs the 2-arg
definition OMCCommon.c:1601), was unified in the same pass;
no call site exercised its bad arity.

**Defect 2 — StartupScreen splash association (SIGSEGV).**
Causal label: **device-proven by UUID-matched .ips**. The
reconstruction used OBJC_ASSOCIATION_ASSIGN for the splash,
leaving it dangling. The original uses policy 1
(OBJC_ASSOCIATION_RETAIN_NONATOMIC) at all 3 set sites
(splash @0xb540, claim @0xa75c, nil-clear @0x71c0 — each
`mov w3, #1` before the call; W-FIX2 sweep, no-skipdata,
121,608 decoded bytes == __text). Fixed: all 3 sites →
RETAIN_NONATOMIC; SSScreenGone gained the original's
nil-screen guard and strong-local hold across tearDown;
teardown order / identity check already matched and stand.

**Prototype-spelling deviation — final form (flagged for
GPT's review):**

> §1's verbatim prototype cannot be applied uniformly — build7
> (-Wnonnull inside NS_ASSUME_NONNULL headers) and build8
> (-Wnullability-completeness in annotation-free headers) each
> disprove one uniform spelling; shipped form unifies ARITY
> (2 params) everywhere with nullability spelling following
> each header's NS_ASSUME_NONNULL structure; ABI unchanged —
> flagged for GPT's review

Shipped: plain `id OMCPref(NSString *key, id defaultValue);`
in annotation-free files (OMCCommon.h, OMCCore.h,
SSStartupScreen.h + 6 annotation-free .m sites); annotated
`id _Nullable OMCPref(NSString *key, id _Nullable defaultValue);`
in the 5 NS_ASSUME_NONNULL headers.

**Listed — suspicious, NOT fixed (verbatim from
fix-arity-wfix1.md §4):**

1. **OMCLogoMeshImage cross-binary arity**: OMCCommon.h:188 / def
   OMCCommon.c:1667, CarProbe.h:142 / def .m:1619, SpeedBubble
   SPPBubble.m:25 all take `(int style)`; Prefs OMCCommon.h:198 declares
   `UIImage *OMCLogoMeshImage(void)`, def OMCCommon.m:518, sole call
   OMCCommon.m:393 `OMCLogoMeshImage()`. Each TU is internally consistent
   (decl=def=calls); these are separate per-binary reconstructions, so
   unifying would break Prefs. Return type also differs (id vs UIImage*).
2. **OMCStyleHeaderFooter vs original binary**: Prefs decl (OMCCommon.h:109),
   def (OMCCommon.m:440) and all 6 call sites are 1-arg, but the source
   itself records the original as 2-arg `(UIView *, BOOL isHeader)`
   (OMCCommon.m:435-439) — a documented fidelity gap deliberately deferred
   per GPT consolidated §D. No TU-internal mismatch; left per that deferral.
3. **OMCCarWireless return-type spread** (arity 0 everywhere): `int`
   OMCCommon.h:90 + def OMCCommon.c:226 + CarProbe.h:122/def .m:1007;
   `BOOL` OMCCore.h:58 + def OMCCore.m:77; `NSInteger` AppBridgeB.h:98
   (no B-local def; B links the AppBridge binary's core copy).
4. **OMCCarLaunchInfo param type/semantics**: SCPShared.h:60 declares
   `id OMCCarLaunchInfo(NSString *bundleID)` vs def `id (id application)`
   (OMCCommon.c:497). Arity 1=1, but SplitScreen call sites disagree on what
   the argument IS: SCPCarSplit.m:548 passes a bundleID string, :1319 and
   :2004 pass an app-info object. One side is a reconstruction error;
   not an arity defect, not touched.
5. **OMCMissingSelector 2nd-param type**: OMCCommon.h:135/def .c:472 take
   `id object`; CarProbe.h:109/def .m:849 take `Class cls`. Arity 3=3,
   each copy internally consistent.
6. **SCPBridgedChosenApps return type**: extern decl in
   SCPCarSplit+Picker.m:42 says `NSArray *`, definition in SCPCarApps.m:230
   returns `NSSet<NSString *> *`, SCPShared.m:120 declares it `id`. Arity 0.
7. **Stale evidence comment**: SCPPerfTelemetry.m:46-49 still says
   "(SCPShared.h declares a one-argument OMCPref…)" — true of the pre-fix
   tree and kept as the binary-evidence note; the prototype line below it
   was unified. Coordinator may annotate it as fixed-by-W-FIX1.

**Build + verification.** Clean build build9
(`project/logs/fix-round/build9.log`): exit 0, 0 errors, 140
warnings. Per-class parity (`perclass9.txt`): 62/66 exact, 0
selectors missing, 4 additive-only exceptions, Prefs 743→745.
diff_payload (`diff9.txt`): 176=176 files, 168/168 non-Mach-O
byte-identical, 0 original defined symbols missing, control
diff = Installed-Size only (6160 → 3544). Parity restage
`dpkg-deb -Zxz`: data tar 202/202 entries, 0 mode/uid/gid/type
differences vs the original.

**§3 in-artifact verification** (candidate re-extracted;
capstone NO skipdata; decoded bytes == LC_FUNCTION_STARTS
bounds == __text size in all 8 binaries, 0 bad; full output
`project/logs/fix-round/g8-build9.txt`):
(a) SplitScreen — PASS: +[SCPPrefs autoLaunch]
`0x1ce50: mov x1, #0` → `0x1ce54: bl _OMCPref` (target
0x4df5c); SCPStringForKey `0x1ccc4: mov x1, #0` →
`0x1ccc8: bl _OMCPref`; all 32 _OMCPref sites carry an
explicit x1 write. Defect 1 fixed and built (§3-verified).
(b) StartupScreen — PASS: exactly 3 setAssociatedObject
sites, each `mov w3, #1` immediately before the call —
nil-clear `0x75ec→0x75f0` (SSClearSplashAssociation), claim
`0x76c4→0x76c8` and splash `0x8578→0x857c`
(SSHandleCarScreen). Defect 2 fixed and built (§3-verified).
(c) Regressions — PASS: Prefs _NSStringFromClass = 3 calls,
all in the [GPT-F] diagnostic functions, 0 inside
insertFeatureSpecifiers; SplitScreen `[GPT-F] Dock gate`
string present and ensureContainer vocabulary includes
setTouched:/setDividers:; AppBridge carries 8 distinct
MILESTONE strings.

**Candidate** (SOLE file in `project/packages/`; supersedes
the build6 consolidated candidate `c1fc85c7…`, removed from
packages/ only after this candidate verified; it remains in
handover history):
`com.anlai.omnicar_1.0.3-rebuilt-arityfix_iphoneos-arm64.deb`,
952,864 B, SHA-256
`3c6faebdfb5e6aa75a0b20f8a42cfe699e70de2fd5efca120e2d0afa650f328d`.
`ar t`: debian-binary, control.tar.xz, data.tar.xz (xz held).

**UUID manifest (candidate, arm64 LC_UUID):** OmniCar
`4c4c4450-5555-3144-a1a3-58843b0f2ea6`; OmniCarCore.dylib
`4c4c4462-5555-3144-a1fd-68112de02120`; OmniCarAppBridge.dylib
`4c4c44c5-5555-3144-a125-1d7128382bdf`; OmniCarCarProbe.dylib
`4c4c44cf-5555-3144-a10b-60b43fdf44ed`; OmniCarSpeedBubble.dylib
`4c4c4432-5555-3144-a1cc-e6285f206b71`; OmniCarSplitScreen.dylib
`4c4c44d3-5555-3144-a105-afe238d5af17`; OmniCarStartupScreen.dylib
`4c4c449a-5555-3144-a111-bd9deadd1500`; OmniCarPrefs
`4c4c4451-5555-3144-a182-1d4b9c7979c6`.

**Tree-state manifest** — SHA-256 of every source file
changed this round across W-FIX1/2/3/4 (16 files × 2 trees;
every src/project pair byte-identical at manifest time):

```
a93389cde04df49f3a65c9bd514d573d1ce5e5055757407c0809cd5cd681ddbd  src/SplitScreenA/SCPShared.h
a93389cde04df49f3a65c9bd514d573d1ce5e5055757407c0809cd5cd681ddbd  project/OmniCarSplitScreen/SCPShared.h  (mirror; cmp IDENTICAL)
83def51fb0a31c6b7b7ed0493717bc6ec7dec366cb3eb7eb124dffa88976260b  src/SplitScreenA/SCPPrefs.m
83def51fb0a31c6b7b7ed0493717bc6ec7dec366cb3eb7eb124dffa88976260b  project/OmniCarSplitScreen/SCPPrefs.m  (mirror; cmp IDENTICAL)
d67404edd5dd4002fe46dd83d1e30592c6853583a75157384a04ec0537e7bd10  src/SplitScreenA/SCPPerfTelemetry.m
d67404edd5dd4002fe46dd83d1e30592c6853583a75157384a04ec0537e7bd10  project/OmniCarSplitScreen/SCPPerfTelemetry.m  (mirror; cmp IDENTICAL)
34e363e9441fe43ba120c7f8362bb39453c51b4460faeacbbb712f1935b1c163  src/SplitScreenA/SCPSessionCore.m
34e363e9441fe43ba120c7f8362bb39453c51b4460faeacbbb712f1935b1c163  project/OmniCarSplitScreen/SCPSessionCore.m  (mirror; cmp IDENTICAL)
51e2c242cb4577f4458aed3b14b5dba399d269d03c0a5361acfcb07d3715c489  src/OMCCommon/OMCCommon.h
51e2c242cb4577f4458aed3b14b5dba399d269d03c0a5361acfcb07d3715c489  project/OMCCommon/OMCCommon.h  (mirror; cmp IDENTICAL)
26f0c07af7f095ef230d1167b00bf3695119aefba3b40e56d9996f4078ef0b11  src/SplitScreenB/SCPCommon.h
26f0c07af7f095ef230d1167b00bf3695119aefba3b40e56d9996f4078ef0b11  project/OmniCarSplitScreen/SCPCommon.h  (mirror; cmp IDENTICAL)
2acb456826709daf130bd76f6b7ebe546747975800e24fd6f172fbe17fc1cb4b  src/SplitScreenC/SCPHomeCommon.h
2acb456826709daf130bd76f6b7ebe546747975800e24fd6f172fbe17fc1cb4b  project/OmniCarSplitScreen/SCPHomeCommon.h  (mirror; cmp IDENTICAL)
5a4656277c33bd68c0a6e49b45a109103811591996a86d47b5e15ce08d67293f  src/CarProbe/OmniCarCarProbe.h
5a4656277c33bd68c0a6e49b45a109103811591996a86d47b5e15ce08d67293f  project/OmniCarCarProbe/OmniCarCarProbe.h  (mirror; cmp IDENTICAL)
a7ddd17ab6ec0b5f28b793a0f0a5bf26a83e403a28fa5b2dda776757589fbd10  src/StartupScreen/SSStartupScreen.h
a7ddd17ab6ec0b5f28b793a0f0a5bf26a83e403a28fa5b2dda776757589fbd10  project/OmniCarStartupScreen/SSStartupScreen.h  (mirror; cmp IDENTICAL)
b7785835c250b2e27f501cd678145cc11ae6ba9d9eec7de904d68fa70cf8958e  src/StartupScreen/SSStartupScreen.m
b7785835c250b2e27f501cd678145cc11ae6ba9d9eec7de904d68fa70cf8958e  project/OmniCarStartupScreen/SSStartupScreen.m  (mirror; cmp IDENTICAL)
9e8d89998452fef8117090ea45b0ca8e44099934b282a32ed834999f3286a311  src/AppBridgeA/src/OMCCore.h
9e8d89998452fef8117090ea45b0ca8e44099934b282a32ed834999f3286a311  project/OmniCarAppBridge/OMCCore.h  (mirror; cmp IDENTICAL)
d5be6b4d22b91ac3c195fadd083fdf2fc0d42daa4fe052d515c66001e3574dae  src/SpeedBubble/SPPPrefs.m
d5be6b4d22b91ac3c195fadd083fdf2fc0d42daa4fe052d515c66001e3574dae  project/OmniCarSpeedBubble/SPPPrefs.m  (mirror; cmp IDENTICAL)
073d9b3a54ee988b9ed27bd78dceac50cb792569ad78fb6b2500bc99c7c46de7  src/AppBridgeB/AppBridgeB.h
073d9b3a54ee988b9ed27bd78dceac50cb792569ad78fb6b2500bc99c7c46de7  project/OmniCarAppBridge/AppBridgeB.h  (mirror; cmp IDENTICAL)
0afd0a87320aee77ad7f56b15e6d6bb8a4a4261b18cdb4df700b461d367d75c1  src/AppBridgeB/ABHostBMethods.m
0afd0a87320aee77ad7f56b15e6d6bb8a4a4261b18cdb4df700b461d367d75c1  project/OmniCarAppBridge/ABHostBMethods.m  (mirror; cmp IDENTICAL)
7a736ea362eefdf4d93041b8e5c0d77fa8dec9760ab3a6f836d909e437bdda03  src/AppBridgeB/ABHostGeometry.m
7a736ea362eefdf4d93041b8e5c0d77fa8dec9760ab3a6f836d909e437bdda03  project/OmniCarAppBridge/ABHostGeometry.m  (mirror; cmp IDENTICAL)
2492af2be2a8a2293a6c0536fc34447ede24300b6f50889717811902f66e6d51  src/AppBridgeB/ABKeyboard.m
2492af2be2a8a2293a6c0536fc34447ede24300b6f50889717811902f66e6d51  project/OmniCarAppBridge/ABKeyboard.m  (mirror; cmp IDENTICAL)
```

**Status.** DEVICE_TEST = PENDING. The two defects are
fixed and built where §3 verified them; no device run has
been made on this candidate and nothing stronger is claimed.
