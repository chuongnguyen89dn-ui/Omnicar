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
