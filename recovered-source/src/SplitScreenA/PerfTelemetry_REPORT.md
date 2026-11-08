# PerfTelemetry — closure of the unowned PerfTicker chain (SplitScreen)

Agent: PerfTicker closure finisher, 2026-11-08. Binary:
`OmniCarSplitScreen.dylib` (arm64 slice), SHA-verified original 1.0.3.
Tools: capstone 5.0.7 via `work/omdis.py` + `metadata/tools/xref.py`
(calibrated) + `verify/macho_truth.py`. Fresh annotated dumps for the
whole cluster are in `src/SplitScreenA/disasm/perf/` (12 files).

## 1. What was closed

The coverage census (`metadata/FUNCTION_SOURCE_MAP.tsv`) listed
sub_53f90 and sub_54448 as claimed by NO source file; the full callee
closure adds 9 more census-UNCLAIMED functions, all now reconstructed in
`src/SplitScreenA/SCPPerfTelemetry.m` (+ `.h`). Every function is
VERIFIED from this binary's disassembly; no stubs, no
STUB-UNRECOVERED markers in this cluster.

| VA | Size | Name in source | Role | Status |
|---|---|---|---|---|
| 0x53f90 | 656 | `OMCPerfSamplerBlock` (invoke; global block @0x79480) | 250 ms timer sampler: watchdog hop + decimated measurement (CPU / footprint / free RAM) | VERIFIED |
| 0x54278 | 464 | `OMCHangWatchdog` (block invoke inside the sampler) | main-queue latency → hangs / freezes / hangWho / freeze log line | VERIFIED |
| 0x54448 | 1112 | `OMCPerfSampleConsume` (block invoke) | stats accumulation, auto-lite evaluation, ticker-link creation, flush cadence | VERIFIED |
| 0x546cc* | — | `OMCEnsurePerfTicker` (inlined region of sub_54448) | runtime-creates class `OMCPerfTicker` + shared instance; creation call site 0x546f8 = `objc_allocateClassPair` | VERIFIED |
| 0x54fd4 | 160 | `OMCPerfTickerTick` (invoke; global block @0x794e0) | `-tick:` body: frame / late-frame / worst-gap accounting | VERIFIED |
| 0x54f40 | 148 | `OMCPerfLinkWindowEnd` (block invoke) | 10 s window end: link invalidate + late-% computation, generation-guarded | VERIFIED |
| 0x54e1c | 292 | `OMCAutoLiteEvaluate` | change-only auto-lite setter (notify + log) | VERIFIED |
| 0x53f20 | 112 | `OMCSetLiteNotifyState` | `com.anlai.omnicar/lite` writer (exported in the .h — session-block seam) | VERIFIED |
| 0x548a0 | 1404 | `OMCFlushPerfStats` | writes the 22-key `diagPerf` pref dict, ≥ 30 s into a session | VERIFIED |
| 0x54220 | 88 | `OMCMonotonicSeconds` | mach_absolute_time clock (file-static helper) | VERIFIED |
| 0x51fb8 | 68 | `OMCCrashStatePtr` | `OMC_CRASHGUARD` env-var struct pointer (hang attribution) | VERIFIED |

\* not a standalone function in the binary; split out as a helper in
source, as the shared-unit reconstruction also does.

Arithmetic / cadence constants were not eyeballed: the exact 32/64-bit
instruction sequences were emulated. Sampler decimation passes at fire
counts 20, 40, 60, … (every 20th); link creation passes at consumed
counts 4, 16, 28, … (**count % 12 == 4**); flush passes at counts
6, 12, 18, … (**count % 6 == 0**).

## 2. Trigger path — VERDICT (proven, not inferred)

**Nothing calls sub_53f90, and nothing was ever meant to.** Evidence:

1. Calibrated xref: sub_53f90 has zero direct internal callers; a
   whole-binary pointer-slot scan finds its address only at 0x79490 —
   the invoke field of the **global block literal at 0x79480**
   (`__DATA_CONST,__const`, isa `__NSConcreteGlobalBlock`). The same
   holds for sub_54448: its address materialises only at 0x541d8,
   inside sub_53f90, as the invoke of the stack block the sampler
   dispatches to the main queue.
2. A whole-`__text` adrp+add scan finds the block 0x79480 materialised
   at exactly one site: 0x53004, inside **sub_52bfc**. There the block
   is installed as the event handler of a `DISPATCH_SOURCE_TYPE_TIMER`
   created on the serial queue `"com.anlai.omnicar.perf"`, with
   start = now + **250 ms** (0xEE6B280 ns), interval 250 ms, leeway
   50 ms (0x2FAF080 ns), then `dispatch_resume`, then a post of
   `com.anlai.omnicar/car.connected` (matches IPC_MAP's SplitScreen
   entry for that channel: sub_52bfc @0x5301c).
3. sub_52bfc is itself the invoke of global block literal 0x79460 and
   the session-stop function sub_52850 is the invoke of block literal
   0x79440 — the connect/disconnect session pair. sub_52bfc resets the
   cluster state; sub_52850 is the teardown side — the store census
   shows it writing the session / link / timer-source slots and the
   generation counter the window-end block compares against
   (global-slot store census: 0x88258/0x88268/0x88270/0x88278/
   0x88280/0x882d8/0x882e0 are written only by these two).

So the chain is: **car session starts → sub_52bfc arms the 250 ms
timer → sampler (0x53f90) fires → every 20th fire measures → main-queue
consume (0x54448) → stats, auto-lite, ticker link, diagPerf flush.**
sub_54448's OMCPerfTicker creation site (0x546f8) executes only from
inside this chain, exactly as SplitScreen-C adjudicated.

## 3. What the cluster writes (cross-checked)

- **Pref `diagPerf`** (domain `com.anlai.omnicar`), 22 keys, all
  verified in sub_548a0: start, updated, seconds, fps, frames, late,
  worstMs, hangs, freezes, hangMaxMs, hangWho (only when non-empty),
  cpuAvg / cpuMax / memMB / memMaxMB / availMinMB / sysFreeMinMB (only
  when ≥ 1 sample), thermalMax, lowPower, tweaks, liteCount,
  liteReason (only when set). NOTE: `metadata/PREFS_MAP.md` lists no
  `diagPerf` writer for SplitScreen (the key appears there via other
  modules) — this reconstruction adds the SplitScreen writer.
- **Pref `liteMode`** read with default @2 (two-argument `_OMCPref`
  call in sub_54448) — matches PREFS_MAP's entry naming sub_54448 as a
  `liteMode` reader.
- **Darwin notify `com.anlai.omnicar/lite`**: state 0/1 via
  notify_set_state + notify_post from sub_53f20 — matches IPC_MAP's
  record of sub_53f20 as SplitScreen's lite writer (writer token slot
  0x87f58, distinct from the reader token inside `_OMCLiteActive`).
- **Log lines** (`_OMCLogWrite`, tag `@"Core"`): freeze line
  `CarPlay do %.1fs (OmniCar gan nhat: %@)` on gaps ≥ 2 s; auto-lite
  lines `che do nhe tu dong: BAT vi <reason>` / `che do nhe tu dong:
  tat`, reasons `heat` / `hangs` / `frames`.
- `CFPreferencesAppSynchronize` on every even-numbered consumed sample
  (direct call in the binary, not the `_OMCPrefsSync` wrapper).

## 4. Scope — deliberately NOT absorbed

- **sub_52bfc** (4148 B, census-UNCLAIMED) and **sub_52850**
  (census-UNCLAIMED): the session start/stop block invokes that OWN
  this cluster. They are its callers, not its callees — outside the
  assigned closure. Their registration facts are documented in §2;
  their globals are the ones this file shares (listed in the .m state
  block, VAs 0x88258–0x883c8). They remain open for the coordinator.
- **sub_4fdfc + sub_560e8** (census-UNCLAIMED, in sub_54448's extended
  callee list only via `_OMCLogWrite`): they are `_OMCLogWrite`'s lazy
  state-object getter and its dispatch_once trampoline (block
  0x793c0 → invoke sub_522a8) — the log cluster, already owned by the
  shared-unit reconstruction. VAs recorded here for the coordinator.

After this pass, **no census-UNCLAIMED function remains in the
telemetry cluster's closure**.

## 5. Labels and residues

- INFERRED (one item): the static type of the session object at
  0x88258 is declared `UIScreen *` — the binary only proves it is the
  receiver of `-displayLinkWithTarget:selector:` and is written by the
  session-start block; UIScreen is the only such class and matches the
  shared unit's verified Core copy. No behaviour depends on the name.
- The flush's numeric conversions use `llrint` in source; the binary
  uses `fcvtas` (round-to-nearest, ties away). Identical under the
  default FP rounding mode; noted in the source comment.
- `task_info` buffer count is the binary's literal **89** (the author's
  SDK's TASK_VM_INFO_COUNT) and `phys_footprint` is read at buffer
  offset 0x90 — if the project's SDK header revision disagrees on the
  struct layout, that is an integration-time check, flagged here.
- Syntax-verified: `clang-18 -fsyntax-only` against iPhoneOS16.5.sdk,
  clean. (Full target build is the integration phase's job.)

## 6. Deltas vs the shared unit's Core copy — read before reusing code

The SplitScreen copy was compiled from a slightly different revision of
the unit than Core's. VERIFIED differences: sampler decimation
**% 20** (Core: every 10th call); link-creation cadence
**count % 12 == 4** (Core: % 6 == 4); footprint / system-free scale
**exactly 2^-20** (Core reconstruction wrote 1.0e-6; Core's own binary
should be re-checked on this point); everything else in the cluster —
watchdog thresholds (0.5 s / 2.0 s), auto-lite rules (thermal > 1,
hang < 120 s, late% ≥ 15 to enable; 180 s cooldowns, late% ≤ 5 to
disable), flush gate (≥ 30 s) and all 22 keys — matches the Core
analog instruction-for-instruction in substance.

## 7. Contradiction check vs SplitScreen-C's adjudication

**No contradiction — confirmed in full, with one refinement.**
C said: sub_54448 is a lite-mode telemetry function (reads `liteMode`;
stats keys `frames`/`hangs`/`heat`), creating OMCPerfTicker at
0x546f8, reachable only via sub_53f90, and that the creation site at
0x546f8 sits inside sub_54448, not inside any SplitScreen-C function.
All of that is exactly right — 0x546f8 is the `objc_allocateClassPair`
call inside sub_54448, and 0x54448 materialises only inside sub_53f90.
Refinement C did not state: sub_53f90 is itself not a called function
but the invoke of the perf timer's global handler block (0x79480),
armed by the session-start block sub_52bfc every 250 ms; and the
"telemetry function" is a nine-function cluster (sampler, watchdog,
consumer, tick, window-end, auto-lite setter, lite writer, flush,
clock, crash-state getter), now closed in full above.

## 8. Deliverables

- `src/SplitScreenA/SCPPerfTelemetry.h` — the two cross-TU seams
  (sampler block, lite writer).
- `src/SplitScreenA/SCPPerfTelemetry.m` — all 11 functions, VERIFIED,
  zero stubs.
- `src/SplitScreenA/disasm/perf/` — 12 annotated dumps (the 9 closure
  functions + sub_52bfc / sub_52850 / sub_51fb8 context).
- This report.
