# PHASE 2 — CORE re-check + Core/App/CarProbe sync & build

Date: 2026-11-08. Owner scope: `src/OMCCommon/`, `project/OMCCommon/`,
`project/OmniCarCore/`, `project/OmniCarApp/`, `project/OmniCarCarProbe/`.
Toolchain verified healthy before building (clang-18 1:18.1.3-1ubuntu1,
ldid shim present, `/usr/bin/ld.lld` → `ld.lld-18`); all builds under
`umask 022`, `THEOS=~/theos`, per-subproject `make clean; make`.

## 1. CORE RE-CHECK — verdicts (evidence: ORIGINAL binary, not just dumps)

Method: capstone disassembly of the arm64 slice of the original
`payload/var/jb/Library/MobileSubstrate/DynamicLibraries/OmniCarCore.dylib`
directly (VAs below are arm64-slice VAs; `__text` addr == file offset),
cross-checked against the existing annotated dumps
`src/OMCCommon/disasm/sub_9814.asm` / `sub_9bc0.asm` — byte-identical.

### (a) sub_9814 ENTRY branch — session-stop teardown guard → **CORE HAS IT. src was WRONG; FIXED.**

- `0x985c cmp x19, x20; 0x9860 b.eq 0x9910` — early return when the
  disconnecting screen is `[UIScreen mainScreen]` (as reconstructed).
- `0x9868 ldr x8, [x20, #0x588]` — loads `__bss+0x88` = `gPerfSessionObject`.
- `0x986c cbz x8, #0x9988` — when nil, branches PAST the entire teardown
  block (`0x9870–0x9984`: source cancel, display-link invalidate,
  `gDisconnectCount++`, `sub_b864` = OMCFlushPerfStats, summary log,
  `sub_bde0` = OMCAutoLiteEvaluate, session-object release) directly to
  `0x9988`, the `diagCar` tail (`_OMCPref(@"diagCar")` …).
- This is exactly the guard the SplitScreen copy has @0x52884
  (SessionCore_REPORT.md delta 1). NOT a per-binary variant — the Core
  transcription had dropped it.
- Inside the guard, only the source-cancel is conditional
  (`0x9874 ldr gPerfSource; 0x9878 cbz → skip cancel`), as before.

### (b) sub_9bc0 APPLY branch — profile-apply skip → **CORE HAS IT. src was WRONG; FIXED.**

- `0xa6a4–0xa6b8`: `entry = profiles[profileKey]` → `[sp,#0x60]`.
- `0xa6c0 cbz x8, #0xa82c` — entry nil → create-new-profile branch.
- `0xa6c4 ldr x0, [sp,#0x40]` (the RAW `carProfileCurrent` pref value,
  loaded at `0xa5ec` via `_OMCPref`, no kind check), `0xa6c8 ldr x2,
  [sp,#0x58]` (the new profile key), `0xa6cc bl 0xdc60` = `isEqual:`,
  `0xa6d0 tbnz w0, #0, #0xa8e4` — when equal, branches to `0xa8e4`, the
  name/lastSeen stamping section, SKIPPING the apply loop
  (`0xa6d4–0xa7cc`, one `CFPreferencesSetAppValue` per `OMCProfileKeys()`
  key) and the `nap ho so xe` log (`0xa7d4–0xa828`).
- Contrast verified in the same function: the outgoing-car refresh just
  above uses stub `0xdc80` = `isEqualToString:` at `0xa648`, after an
  NSString kind check at `0xa608–0xa620` — the apply skip uses plain
  `isEqual:` on the raw value, exactly as SessionCore_REPORT.md delta 2
  describes for SplitScreen @0x53708. NOT a per-binary variant.

## 2. src/OMCCommon edits (authorised source-level corrections)

File: `src/OMCCommon/OMCCommon.c` (only file edited in `src/`).

1. `OMCOnScreenDisconnected` (sub_9814): wrapped the teardown sequence
   (`gPerfSource` cancel → display-link invalidate → `gDisconnectCount++`
   → `OMCFlushPerfStats()` → summary log → `OMCAutoLiteEvaluate(0, nil)`
   → `gPerfSessionObject = nil`) in `if (gPerfSessionObject) { … }`.
   The `diagCar` tail stays outside the guard, on both paths. Added a
   comment citing the re-check addresses (0x9868/0x986c → 0x9988).
2. `OMCDiagCarRecordConnect` (sub_9bc0) profile flow: the existing-entry
   branch changed from `else { apply… }` to
   `else if (![currentKey isEqual:profileKey]) { apply… }`, where
   `currentKey` is the raw `carProfileCurrent` pref value already in
   scope. Create-new branch unchanged. Added a comment citing
   0xa6c4–0xa6d0 → 0xa8e4 and the `isEqual:` vs `isEqualToString:`
   distinction.

No other src changes. No functional code stubbed or deleted anywhere.

## 3. SYNC — md5sums after sync (src == project unless noted)

| File | md5 | Notes |
|---|---|---|
| OMCCommon.c (src + project/OMCCommon) | `cb8afa107945c29cc2bce1befb999feb` | includes the 2 corrections above |
| OMCCommon.h (src + project/OMCCommon) | `951b0e341f3ba79ff0d6f0802525d79e` | unchanged since phase 1 |
| OmniCarCore.c (src/OMCCommon + project/OmniCarCore) | `0745df2dd618343d559895fb90b33509` | unchanged since phase 1 |
| App main.m | `84f014d7eb041c45f60263347e117f01` | identical src/project |
| App OMCAppDelegate.h | `7d103dce3d96b6baa7b60a353acceaa7` | identical |
| App OMCAppDelegate.m | `fae6477c22dc05b9ae95b46d77aa1186` | identical |
| CarProbe OmniCarCarProbe.h | `a1b96dca76b9202b86f4c7cf633a6f19` | identical |
| CarProbe OmniCarCarProbe.m (src) | `9d6c80016c6d9d39f2bf0fb73ab407b5` | — |
| CarProbe OmniCarCarProbe.m (project) | `13732a3859684833710661537cdd0abb` | src + 3 re-applied phase-1 fixes (below) |

Copy map honoured: `project/OMCCommon/` holds OMCCommon.c/.h;
`OmniCarCore.c` in `project/OmniCarCore/`; App sources copied keeping
project Makefile/Resources/plist; CarProbe copied keeping Makefile/plist;
OMCCommon.mk NOT added to CarProbe (its .m is the core TU —
BLOCKER-CORE-CARPROBE structure unchanged).

## 4. Build results — ALL PASS (compile + link + sign)

| Subproject | Result | Output |
|---|---|---|
| OmniCarCore | **PASS** (exit 0, 0 errors) | `.theos/obj/debug/arm64/OmniCarCore.dylib` (185,440 B) |
| OmniCarApp | **PASS** (exit 0, 0 errors) | `.theos/obj/debug/arm64/OmniCar.app/OmniCar` (77,576 B) |
| OmniCarCarProbe | **PASS** (exit 0, 0 errors, 6 warnings) | `.theos/obj/debug/arm64/OmniCarCarProbe.dylib` (154,656 B) |

Logs: `project/logs/phase2-OmniCarCore.log`, `phase2-OmniCarApp.log`,
`phase2-OmniCarCarProbe.log`. The only warnings are the pre-existing
demoted classes (CarProbe: arc-performSelector-leaks note + unused
libroot-fallback functions, per its Makefile demotions) and the
`ld64.lld: -multiply_defined is obsolete` linker notice in all three.

## 5. Mechanical fixes applied this phase

Project copies only (src/ untouched except §2):

1. `project/OmniCarCarProbe/OmniCarCarProbe.m` — re-applied phase-1 log
   item 13 verbatim (fresh src copy still lacks equivalents; verified by
   diff before copying):
   - `NSDistributedNotificationCenter` minimal `@interface` block added
     after the imports (comment now also marks "re-applied phase 2").
   - `value.description` → `[value description]`.
   - `sub[key].description.lowercaseString` →
     `[[sub[key] description] lowercaseString]`.
   Post-fix diff src↔project for this file = exactly these 3 items.
2. No Makefile changes were needed in any of the three subprojects; no
   regressions vs phase 1 appeared (the corrected OMCCommon.c compiled
   clean in OmniCarCore on the first attempt).

## 6. Remaining issues

- None within this phase's scope. The two corrected behaviours change
  OmniCarCore runtime semantics vs the phase-1 build (teardown now
  skipped when no session is active; profile apply now skipped when
  reconnecting to the current car) — both now match the original binary.
- Out of scope, noted for the coordinator only: SessionCore_REPORT.md
  also flags Core-side sampler/footprint constants for recheck
  (decimation %10 vs %20, 1.0e-6 vs 2^-20) — those belong to the
  SplitScreen/perf owners' adjudication, not this task; not touched.
- BLOCKER-CORE-CARPROBE (CarProbe embeds its own core copy; no
  OMCCommon.mk) remains as documented in phase 1 — structure kept.
