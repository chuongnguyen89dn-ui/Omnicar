# Phase 2 — OmniCarSpeedBubble integration (sync + @property census + build)

Result: **BUILD PASS** (`make clean; make`, exit 0, link + sign) —
`.theos/obj/debug/arm64/OmniCarSpeedBubble.dylib` (511,136 B, arm64).
Build logs: `logs/phase2-speedbubble-build1.log` (pre-fix link errors),
`logs/phase2-speedbubble-build2.log` (property-ivar error),
`logs/phase2-speedbubble-build3.log` (first PASS),
`logs/phase2-speedbubble-build-final.log` (final PASS, see OMCCommon note),
`logs/phase2-speedbubble-fingerprint.txt` (structural diff vs original).

## OMCCommon copy (done first, per task)

`cp src/OMCCommon/{OMCCommon.c,OMCCommon.h} → project/OMCCommon/` at start of session.
md5sums at copy time (src == project):

- `OMCCommon.c` — `1f8a90b2b5cbc946853337bfd6e4883a` (72,406 B)
- `OMCCommon.h` — `951b0e341f3ba79ff0d6f0802525d79e`

NOTE: during this session `src/OMCCommon/OMCCommon.c` was updated by parallel
phase-2 work (mtime 04:00:31 UTC, now 73,461 B) and the project copy was
refreshed to match (mtime 04:03:39 UTC). At deliverable time src == project:

- `OMCCommon.c` — `cb8afa107945c29cc2bce1befb999feb`
- `OMCCommon.h` — `951b0e341f3ba79ff0d6f0802525d79e` (unchanged)

The final build (build-final.log) was re-run against the refreshed copy and
also PASSes. No edits were made to OMCCommon by this agent.

## Sync list (src/SpeedBubble → project/OmniCarSpeedBubble)

All 18 `*.h`/`*.m` files copied over the phase-1 project copies. Byte-changed
by the sync (9): `SBSourceGlobals.h`, `SBOpenCar.m`, `SBPublish.m`, `SBScan.m`,
`SPPBubble.m`, `SPPDisplayBoot.m`, `SPPOverspeed.m`, `SPPPrefs.m`,
`SPPWindowFactory.m`. Already identical (9): `SBScanHelpers.h`, `SPPSpeedGPS.h`,
`SBFlutter.m`, `SBScanHelpers.m`, `SBSourceHooks.m`, `SPPBubbleView.m`,
`SPPSpeedGPS.m`, `SPPViews.m`, `SPPWarningSound.m`.

Phase-2 src content thereby brought in (per REPORT_A.md phase-2 + micro-fix
§§5–6 and SpeedBubbleB_REPORT.md verifier-#4 + phase-2 sections, verified
present after sync): notify_register_dispatch token globals/locals in
SPPDisplayBoot.m; 3-arg `_OMCMissingSelector` everywhere plus the 3 added log
calls in `-[SPPBubble sourceAppState]`; SBScan contract edits
(SPPCandidatesSummary→SPPFindAuxImageValue int, SPPColorView returns UIColor*,
SPPScanPostCommit = diagnostic logger); SPPGlowImageOrange/Red getters defined
in SPPOverspeed.m; bit-17 polarity `limit>=0 ? 2 : 0` in SBPublish.m;
`0xFFFF` sentinel in `-[SPPBubble setSpeed:]`.

Project-only files kept untouched by the sync: `SBIntegrationShims.h`
(edited, see Fixes), `Makefile` (edited, see Fixes), `OmniCarSpeedBubble.plist`.

## SBOpenCar exclusion

`SBOpenCar.m` is now a pointer note defining nothing (canonical constructor =
`SPPDisplayBoot.m`: `SPPDisplayInitCarPlay` + `SPPHandleOpenCarNotification`).
It was removed from `OmniCarSpeedBubble_FILES` in the project Makefile, with a
comment there stating why. The file stays on disk, synced with src. This also
retires the phase-1 PENDING-VERIFIER duplicate `__init_0` (no duplicate-symbol
error at link; the build links clean).

## @property census (work item 3)

Source: `metadata/raw/OmniCarSpeedBubble/objc.json` (binary property lists:
name + type encoding per ivar, with attributes) cross-checked against the
UNCLAIMED accessor lists in `metadata/COVERAGE_GAPS.md`. Method: for every
class, the full binary property list was generated from the JSON and compared
with the declarations in the `@implementation` TU's interface; missing
declarations were added there (project copies only, each block comment-tagged
`[phase-2 integration]`). **54 declarations added:**

| Class (TU) | Added | Source counts |
|---|---|---|
| SPPBubble (SPPBubble.m) | **31** — window, card, bubbleView, timer, timerInterval, builtLite, speed, limit, lastUpdate, speedAt, limitAt, carLostAt, onPhone, carBusy, scale, pinching, app, iconApp, menu, menuShield, menuTimer, holdStart, holdDragging, outlineRect, outlineCorner, demoTimer, staleTimer, appliedRotation, displayScale, phoneFraction, carFraction | binary: 31 properties / 31 ivars; gaps were 59 UNCLAIMED (29 getters + 29 setters + .cxx_destruct; `speed` and `carBusy` accessors are custom-implemented in src and were not re-synthesized) |
| SPPOverspeed (SPPOverspeed.m) | **18** — window, glow, flash, shownFx, displayID (copy), speed, limit, enabled, mode, marginKmh, fx, voice, tone, voiceLine, voiceText (copy), over, armed, belowSince | binary: 18 properties / 18 ivars; gaps were 37 UNCLAIMED (18+18+.cxx_destruct) |
| SPPGlassView (SPPViews.m) | **3** — fill, sheen, corner (+ `double _corner;` added to the @implementation ivar block; binary ivar `_corner`, d @ offset 24, had no counterpart) | binary: 3 properties; `-setCorner:` is custom in src, not re-synthesized |
| SPPIconView (SPPViews.m) | **2** — tileCorner (double), tileMask (NSUInteger); ivars already existed in the @implementation block | binary: 4 properties; 5 UNCLAIMED incl. .cxx_destruct |
| SPPBubbleView interface copy (SPPBubble.m) | **10** declaration completions — speedLabel, glass, iconView, sign, unitLabel, deco, parts, bits, tickLabels, flashView (declaration-only TU; synthesis happens in SPPBubbleView.m, whose own interface already declares all 21) + `@class SPPGlassView, SPPIconView, SPPSignView;` forward line | binary: 21 properties |

Already complete, no action: SPPBubbleView (own TU, 21/21), SPPSignView (2/2),
SPPSpeedGPS (6/6, in SPPSpeedGPS.h), SPPSoundDelegate (no own properties),
SPPPrefs (no properties; class methods only).

Supporting ivar type alignments in SPPOverspeed.m's @implementation block
(binary ivar encodings win): `_speed`/`_limit` NSInteger→`int` (encoding `i`),
`_displayID` `id`→`NSString *` (encoding `@"NSString"`).

## Every other fix (all project copies / project files only; src/ untouched)

1. **Makefile** — `SBOpenCar.m` removed from `_FILES` + explanatory comment
   (above); `SBIntegrationTables.m` added to `_FILES`;
   `-Wno-error=unused-property-ivar` added (SPPGlassView's custom `-setCorner:`
   — reconstructed INFERRED body writes `layer.cornerRadius`, not `_corner`;
   demoted per build rules instead of rewriting the body).
2. **SBIntegrationShims.h** — 12 `#define` aliases mapping the A-side sources'
   Mach-O-spelled C identifiers (`_OMCLogWrite`, `_OMCMissingSelector`,
   `_OMCLiteActive`, `_OMCLogoMeshImage`, `_OMCCrashGuard`, `_OMCCarClass`,
   `_OMCCarLaunchInfo`, `_OMCFeatureEnabled`, `_OMCPrefsSync`, `_OMCPref`,
   `_OMCTr`, `_OMCCurrentLanguage`) onto the real C names defined in
   OMCCommon.c/.h. First build failed at link with exactly these 12 as
   undefined symbols (`__OMC*`); B-side sources already use the plain names.
3. **SBIntegrationTables.m (new, project-only)** — definitions for
   `SPPAppNames[4]`, `SPPAppBundleIds[4]`, `SPPAppShortNames[3]`, declared
   extern in SPPBubble.m but defined in no src TU (in the binary they are
   `__objc_arrayobj` constants, not named symbols — no SPPApp* symbol exists
   in objc.json). Values are exactly those documented at the declaration site
   (SPPBubble.m:75–78) and in SBSourceGlobals.h's VERIFIED host table:
   names Vietmap/GOFA/Waze/Wyn; bundle IDs vn.vietmap.live, com.lumi.GOFA,
   com.waze.iphone, com.wynauto.wyn; short names VM/GO/WZ (3 entries only,
   accesses guarded idx<=2). First build's remaining 3 undefined symbols.
4. **SPPPrefs.m** — `_OMCPref` signature completion: declared
   `id _OMCPref(NSString *key, id def)` and call site `_OMCPref(key, nil)`.
   Binary evidence: sub_1edb0 @0x1edd0 sets `x1 = #0` before calling
   `_OMCPref`; matches OMCCommon.h `id OMCPref(id, id)`. (Same dropped-arg
   family as phase-1 BLOCKER-PREFS-OMCICON.)
5. **SPPBubble.m** — `_OMCLogoMeshImage` signature completion: declaration
   `UIImage *_OMCLogoMeshImage(int style)` and call site `_OMCLogoMeshImage(0)`.
   Binary evidence: showMenu disasm @0x1b590 `mov w0, #0` immediately before
   `bl _OMCLogoMeshImage`; matches OMCCommon.h `id OMCLogoMeshImage(int)`.

No functional code was stubbed or deleted anywhere in this phase.

## Build result

- `umask 022`, `THEOS=~/theos`, `cd project/OmniCarSpeedBubble && make clean; make`
  → **exit 0, Linking + Signing steps reached**, dylib 511,136 B (arm64 only;
  arm64e impossible on this VM, as in phase 1).
- Remaining warnings (non-error): 5× `-Warc-performSelector-leaks`
  (SBFlutter.m ×4, SBScan.m ×1 — demoted since phase 1) and 1×
  `-Wunused-property-ivar` (SPPViews.m corner, demoted this phase).
- Structural fingerprint vs original (project/tools/diff_payload.py parser;
  full table in `logs/phase2-speedbubble-fingerprint.txt`):
  **classes 9/9 exact; methods: built 278 vs original 277; ZERO missing
  methods in every class** (SPPBubble 103→104, SPPBubbleView 59→59,
  SPPOverspeed 46→46, SPPGlassView 10→10, SPPIconView 11→11, SPPSignView 8→8,
  SPPSoundDelegate 4→4, SPPSpeedGPS 20→20, SPPPrefs 16→16). Defined symbols
  1365 vs 46 is the known debug-build/stripped-original gap (phase-1 pattern).

## Retained residues (kept as-is, per task item 4)

From REPORT_A.md NOT-RECOVERED items 2–6, untouched:

1. **Item 2** — `numberColor` full style×state matrix (PARTIAL in SPPBubbleView.m).
2. **Item 3** — `applyColor:` tail per-branch discriminators (builtStyle vs
   speedState) PARTIAL.
3. **Item 4** — demo synthetic speed curve helper sub_1a710 (pattern in
   SPPBubble.m marked INFERRED).
4. **Item 5** — small layout helpers / per-style PARTIAL residues from the
   style-geometry closure (style 1 dot frame, style 4 fillGrad.hidden +
   state-2 bottom pairing, style 5 content height, style 6 contentSize
   immediates, style 7 total-width grouping, style 8 shadow alpha,
   SPPPlaceUnitRightOf exact y chain; SPPGlassView/SPPIconView/SPPSignView
   bodies INFERRED in SPPViews.m).
5. **Item 6** — SPPPassThrough metrics-struct field layout beyond the leading
   scale (positions INFERRED, SPPWindowFactory.m); plus its sibling residue,
   the unknown consumer of `com.anlai.omnicar/speed` (outside the module).
6. **Two undecodable constant arrays, marked STUB-UNRECOVERED in
   SPPBubbleView.m**: style-4 mesh `locations` @0x3ce30 and the heavy font's
   feature-settings array @0x3ce60 (24-byte constant-object pattern in
   `__objc_arrayobj`, not decoded with the tools at hand).

## Remaining issues

- **One extra method vs original**: SPPBubble `hideIfShownWithReason:now:state:`
  exists in the built binary but not in the original's method list (in the
  binary that logic is presumably not a standalone method). It comes from the
  src reconstruction as delivered; removing/folding it is a src-side decision,
  out of this phase's scope (no functional code deleted).
- **SPPGlassView `-corner` getter** now synthesizes against `_corner`, but the
  custom `-setCorner:` (INFERRED body) never writes `_corner`, so the getter
  returns 0 unless the ivar is written elsewhere. Whether the binary's
  `-setCorner:` stores the ivar is unverified — flagged, not guessed.
- arm64e slice absent (VM toolchain limit, documented in the Makefile header).
- Root-level aggregate `make package` was not run: the root Makefile and other
  subprojects are outside this agent's ownership.
