# SessionCore closure report — SplitScreen session start/stop pair

Scope: the coverage census listed **sub_52bfc** (session start) and
**sub_52850** (session stop) of OmniCarSplitScreen.dylib as UNCLAIMED —
the two owner functions the perf-telemetry cluster (SCPPerfTelemetry.m)
hangs off — plus the `_OMCLogWrite` lazy-state chain (sub_4fdfc /
sub_560e8). This pass closes all of them and every census-unclaimed
function in their call closure.

Deliverables: `SCPSessionCore.h`, `SCPSessionCore.m`; dumps in
`disasm/session/` (11 files). All functions VERIFIED from this binary's
disassembly unless a line below says otherwise. No STUB-UNRECOVERED
markers were needed — the closure is fully recovered.

## 1. Functions closed (SplitScreen arm64 VAs)

| Address | Size | Source name (SCPSessionCore.m) | Role |
|---|---|---|---|
| 0x52bfc | 4,148 B | `OMCDiagCarRecordConnect` (static) | Session start; invoke of global block 0x79460 |
| 0x52850 | 576 B | `OMCOnScreenDisconnected` | Session stop; invoke of disconnect block 0x79440 |
| 0x52820 | ~28 B | `OMCOnScreenConnected` | Arming helper: dispatch_after 4.0 s → session start |
| 0x5281c | 4 B | (thunk, no source function) | Connect block 0x79420's invoke: `b sub_52820` |
| 0x53c30 | 752 B | `OMCProbeObject` (static) | CarKit object → flat string-property snapshot |
| 0x55074 | 644 B | `OMCFirstProbeValue` (static) | Nested first-valid-string lookup in the diag dict |
| 0x552f8 | 324 B | `OMCProfileValuesSnapshot` (static) | Snapshot of live values for all `OMCProfileKeys()` |
| 0x4fdfc | 68 B | `OMCLogQueue` | Lazy log-queue getter (fast path on once token) |
| 0x560e8 | 20 B | (same function, outlined) | Tail-call forwarder: `dispatch_once(&0x88298, block 0x793c0)` |
| 0x522a8 | 48 B | (block invoke inside `OMCLogQueue`) | Creates queue `"com.anlai.omnicar.log"` → global 0x88290 |

Call-closure audit (counted from the dumps): sub_52bfc calls only
shared-unit functions (`_OMCLogWrite` ×5, `_OMCPref` ×3, `_OMCTr`,
`_OMCProfileKeys`), perf-cluster functions (`OMCSetLiteNotifyState`
sub_53f20, sampler block 0x79480), the three helpers above, and
libc/runtime/libdispatch. sub_52850 calls `OMCFlushPerfStats`
(sub_548a0), `OMCAutoLiteEvaluate` (sub_54e1c), `_OMCPref`,
`_OMCLogWrite`. No other unclaimed function is reachable from the pair.

## 2. Trigger chain — VERDICT (proven)

Root = **`_OMCCrashGuard` (0x50e24, 4,500 B, shared unit)**. In its
first-call path (after the crash-state processing), its tail section
(dump `disasm/session/crashguard_arming_region.txt`, 0x51a80–0x51e00):

1. saves the previous uncaught-exception handler → global 0x882c8 and
   installs `sub_52398` via `NSSetUncaughtExceptionHandler`;
2. installs signal handler `sub_525f8` via sigaction for the 6 signals
   in the table @0x6f420 = {11, 10, 6, 4, 5, 8};
3. registers on `[NSNotificationCenter defaultCenter]`, queue =
   mainQueue, object = nil:
   - `UIScreenDidConnectNotification` → global block **0x79420**
     (fields decoded per-slot through the calibrated resolver:
     isa `__NSConcreteGlobalBlock`, flags 0x50000000, **invoke =
     0x5281c**, descriptor 0x78740);
   - `UIScreenDidDisconnectNotification` → global block **0x79440**
     (invoke = **0x52850**, decoded the same way);
4. **calls `sub_52820()` directly** (0x51c2c) — the already-connected
   case;
5. then does its rescue bookkeeping (crash-state file write-back,
   `CFPreferencesAppSynchronize`, rescueFeatures restore).

From there:

- `sub_5281c` is a 4-byte thunk `b sub_52820`.
- `sub_52820`: `dispatch_after(dispatch_time(NOW, 0xEE6B2800 =
  4,000,000,000 ns), main queue, block 0x79460)`; block 0x79460's
  invoke **is** sub_52bfc (the sampler block 0x79480 is materialised
  only inside sub_52bfc at 0x53004).
- Caller census over the whole `__text`: sub_52bfc and sub_52850 have
  **zero direct callers** (block invokes only); sub_52820 is called
  from `_OMCCrashGuard` @0x51c2c and branched to from sub_5281c.

So: **connect → (observer) → +4.0 s → session start; disconnect →
(observer) → session stop.** The 4 s delay and the immediate arm-time
call are both in the helper, exactly as in the Core copy.

## 3. What the pair does (summary; full transcription in the source)

**Session start (sub_52bfc)** — for each non-main screen of
`[UIScreen screens]` (pointer-compared against `[UIScreen
mainScreen]`):

- If no session is active: adopt the screen as `gPerfSessionObject`
  (0x88258 — this also settles the PerfTelemetry report's INFERRED
  label: the session object **is** a `UIScreen`, an element of
  `[UIScreen screens]` receiving `maximumFramesPerSecond`);
  `gDisconnectCount++` (generation bumps on start too); stamp
  `gSessionStart`; scan dyld images for other tweaks
  (`/DynamicLibraries/` or `/TweakInject/`, basename minus extension,
  `OmniCar`-prefixed skipped) → `gSessionTweaks`; reset all perf
  stats (incl. DBL_MAX min trackers and the −8.5 late-percent
  sentinel); clear lite state (`OMCSetLiteNotifyState(0)`, reason
  nil, auto-lite byte 0, sampler latch store-release 0); create the
  250 ms timer source (250 ms start/interval, 50 ms leeway) on queue
  `"com.anlai.omnicar.perf"` with the sampler block;
  `notify_post("com.anlai.omnicar/car.connected")`; start log line.
- Always (per non-main screen): build the `diagCar` record (date,
  connected=true, iOS version, points/pixels formats, scale as
  double, maxFPS as integer); CarKit probe under @try — dlopen
  CarKit (RTLD_LAZY), `CARSessionStatus` singleton cached at global
  **0x882d0** (new global, not in PerfTelemetry's state list),
  `currentSession`/`configuration` snapshotted via `OMCProbeObject`;
  @catch logs `@"CarKit loi: %@"`; write `diagCar` pref + **two**
  `CFPreferencesAppSynchronize` calls (VERIFIED, ARC retain between).
- If pref `carProfilesEnabled`: extract name/id components with
  `OMCFirstProbeValue` over constant key chains (name:
  modelName/name/vehicleName/accessoryName/model @0x805f0; id:
  vehicleIdentifier/identifier/uniqueIdentifier/accessoryID/
  deviceID/serialNumber @0x80608); profile key = id, else
  `"<name>|<pixels>"`; refresh the outgoing car's stored values;
  load-or-create the profile (apply = one
  `CFPreferencesSetAppValue` per `OMCProfileKeys()` key, NULL deletes);
  stamp name (fallback `OMCTr(@"Xe", @"Car")`) + lastSeen; write
  `carProfiles` + `carProfileCurrent`; synchronise;
  `notify_post("com.anlai.omnicar/prefschanged")`.
- Final log: `@"man xe %@ pt, %@ px, %@ fps, session=%d"`.

**Session stop (sub_52850)** — notification's object is the screen;
main screen → return. If a session object exists: cancel + release
the perf source, invalidate + release the display link,
`gDisconnectCount++`, `OMCFlushPerfStats()`, summary log
(`"do hieu nang: %.0fs, tre %.0f/%.0f khung, …"`), 
`OMCAutoLiteEvaluate(0, nil)`, release the session object. On both
paths: `diagCar` mutable copy gets `connected=false`,
`disconnected=[NSDate date]`, written back + synchronised (only if
the stored value is an NSMutableDictionary).

**Log-queue chain**: global 0x88290 = serial queue
`"com.anlai.omnicar.log"`, once token 0x88298. `_OMCLogWrite`
(0x4fbf4, +0x124) is the getter's in-package caller of record along
with the log-relay handler.

## 4. Delta list vs the OmniCarCore copy (src/OMCCommon/OMCCommon.c)

The pair is the same source-level machinery as Core's sub_9bc0 /
sub_9814 / sub_97e4 / sub_6dd0 and the sub_9bc0-cluster helpers
(sub_abf4 / sub_c038 / sub_c2bc). Verified IDENTICAL: the CrashGuard
arming (observer names, main queue, nil object, immediate arm call,
signal table {11,10,6,4,5,8}, previous-handler save), the 4.0 s
delay constant, tweak scan filters, stats reset (incl. −8.5 sentinel,
DBL_MAX mins), 250/250/50 ms timer on `"com.anlai.omnicar.perf"`,
notify names, diagCar fields and formats, CarKit probe + singleton,
double synchronise, profiles key chains (byte-identical contents and
order), helper caps (80 entries per snapshot, 160 chars + @"...",
skip list {description, debugDescription, hash, superclass},
section order configuration→session, "nil"/"(null)"/empty rejected),
stop's diagCar update.

**Deltas found (both on the SplitScreen side, verified here):**

1. **Session-stop teardown guard.** SplitScreen wraps the whole
   teardown (cancel, invalidate, generation++, flush, summary log,
   `OMCAutoLiteEvaluate`, session release) in
   `if (gPerfSessionObject != nil)` (branch at 0x52884). Core's
   reconstruction of sub_9814 has no such guard — only the source
   cancel is conditional. Either the two binaries genuinely differ,
   or the Core transcription dropped the guard. FLAG for the
   integration pass: re-check Core sub_9814's entry branch.
2. **Profile-apply skip.** SplitScreen skips the apply loop (and
   its `nap ho so xe` log) when the stored `carProfileCurrent`
   value `isEqual:` the new profile key (0x53708; note: `isEqual:`
   on the raw pref value, no kind check — the outgoing-car refresh
   just above uses `isEqualToString:` after an NSString check).
   Core's reconstruction applies whenever an entry exists. FLAG:
   re-check Core sub_9bc0's apply branch.

**Cluster-adjacent deltas already established by the PerfTelemetry
pass** (in the sampler/consumer this pair arms; recorded here so the
list is complete): sampler decimation every 20th fire here vs every
10th written for Core; display-link cadence `count % 12 == 4` here
vs `% 6 == 4`; footprint/sysfree scale exactly 2^-20 here vs the
1.0e-6 written in Core's reconstruction (Core's own binary flagged
for recheck there).

**Emission-shape differences (not behavioural):** the log-queue
getter is a 3-piece chain here (getter + outlined once-forwarder +
block invoke) vs Core's single function; the session-start block's
invoke is the function itself (global block) and the connect block
invokes a 4-byte thunk, vs Core's named-function + block-literal
shape. Same semantics.

## 5. Remaining unclaimed items in the closure

**None.** Every function reachable from the pair is now claimed:
the three helpers and the log-queue chain by this pass; the sampler/
flush/auto-lite functions by the PerfTelemetry pass; the rest by the
shared unit.

Explicitly **out of closure** (checked, with reasons):

- `sub_50148` (220 B) + its block invoke `sub_50224`: a sibling
  consumer of `OMCLogQueue` — the distributed-notification log-relay
  handler (takes the notification's `userInfo[@"line"]`, forwards
  it onto the log queue via a stack block). It has no direct
  callers (callback registration; the exact registration site —
  presumably in the log-relay machinery around `_OMCLogRelayStart`,
  0x500c4 — was not traced in this pass) and nothing in the session
  pair references it. Documented here so the census can mark it
  adjacent-to, not part of, this cluster.
- `sub_52a90` (364 B, between the pair): no call from either
  function (grep-verified over both dumps: 0 references). It is a
  neighbour, not a callee.

New globals established by this pass: 0x88290 (log queue), 0x88298
(log once token), 0x882c8 (previous uncaught-exception handler,
written by `_OMCCrashGuard`), 0x882d0 (CARSessionStatus singleton).

Integration seams to honour when merging: (a) the perf state
statics are declared `static` in SCPPerfTelemetry.m — in the
original single TU they are shared with this file; SCPSessionCore.m
declares them `extern` and the integration must hoist them into one
place; (b) `OMCFlushPerfStats` / `OMCAutoLiteEvaluate` are likewise
`static` in SCPPerfTelemetry.m today.

## 6. Syntax check

**PASS.** `clang-18 -fsyntax-only -target arm64-apple-ios15.0
-isysroot ~/theos/sdks/iPhoneOS16.5.sdk -fobjc-arc -fblocks
src/SplitScreenA/SCPSessionCore.m` → exit 0, no diagnostics; the
same command with `-Wall` added → also exit 0, no diagnostics.

Toolchain note (for the record): mid-pass, a VM /usr rollback plus
the host os-intent replay (still running, apt lists lock held by
its `apt-get update`) left `clang-18` absent. The compiler was
restored from the local apt archive cache
(`/var/cache/apt/archives`, ubuntu1 18.1.3 set: libllvm18,
libclang-cpp18, libclang1-18, libclang-common-18-dev,
libclang-rt-18-dev, clang-18 + llvm-18 family) via `dpkg -i`;
`clang-18 --version` reports 18.1.3 (1ubuntu1). A few llvm-18
packaging configure errors remain outstanding in dpkg (unrelated
tools packages) — they do not affect this check, and the host
replay will reconcile package state on its own schedule.
