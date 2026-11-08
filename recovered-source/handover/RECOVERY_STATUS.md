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
```
...[truncated 8182 chars]