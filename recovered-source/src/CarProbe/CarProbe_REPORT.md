# OmniCarCarProbe — Reconstruction Report

**Binary:** `OmniCarCarProbe.dylib`, 242,784 B fat (arm64 slice 111,712 B at
fat offset 16384, UUID `60EABE81-28C1-328C-8B03-53AAC26BC7E0`; arm64e slice
at 131072). Substrate filter: **CarPlayApp only**. **0 ObjC classes, 20
exported C functions, no `MSHook*` imports.**
**Deliverables:** `OmniCarCarProbe.h`, `OmniCarCarProbe.m` (1,650 lines, no
stubs), `disasm/` (per-function annotated disassembly).

## 1. Role — derived from the code, not the name

This dylib is **not** a CarPlay-specific probe with its own feature logic.
It is the shared **OMCCommon** translation unit — prefs, hard-expiry,
localisation, logging + cross-process log relay, crash guard, CarPlay
runtime-introspection helpers — that is statically embedded in *every*
OmniCar module, here linked into a dylib filtered to CarPlayApp. All 20
exports are the OMCCommon API; nothing in the export list is CarProbe-only.

What this binary itself does at load:

- Its constructor checks `processName ∈ {SpringBoard, CarPlay}` (the
  SpringBoard branch is dead under this dylib's filter — CarPlayApp's
  process name is `CarPlay`) and on the main queue stamps the diagnostic
  pref `diagLoaded.CarProbe<ProcessName>` = {version 1.0.3, build
  `fbebb21`, date} and logs `build fbebb21 (1.0.3) loaded into …`.
- The heavy machinery in the unit — the **crash guard**, the **CarPlay
  connect/performance probe** (250 ms sampler, display-link frame
  counting, main-queue watchdog, `diagCar`/`diagPerf` prefs), **per-car
  profiles**, and the **auto lite mode** — is armed from `OMCCrashGuard`,
  which has **no caller inside this binary** (verified against the
  calibrated call graph: zero in-binary call sites). In the real
  CarPlayApp process, several OmniCar dylibs are loaded together; the
  first sibling module whose constructor calls its own embedded
  `OMCCrashGuard(feature)` creates the shared crash session, and that
  session's struct pointer is shared with all other copies (including
  this one) through the `OMC_CRASHGUARD` environment variable. This
  binary therefore carries a full, redundant copy of the probe machinery
  that activates only if this copy wins that race (or is the only copy
  present — in which case it never fires, because nothing calls it).

## 2. Inherited vs redone

Inherited from the previous combined (StartupScreen+CarProbe) agent:
`disasm/` (annotated disassembly files + `_index.json` +
`_skeletons_all.txt`) and `HANDOVER_NOTE.md`, which documents the
disassembly tooling/segmentation and states explicitly that **source
reconstruction was not yet written**; its semantic findings stop at
`sub_7308`'s head. No source and no report existed. All semantic
decoding (this report and the `.m`) is this agent's own reading of the
full dumps plus targeted re-reads of the raw binary for constants. The
inherited annotations were **not** trusted blindly — see §3.

## 3. Method and the import-name calibration

Disassembly: inherited capstone dumps (arm64 slice; VA == file offset in
slice). Constants (CFString arrays, doubles, the signal table) were
extracted by direct struct reads of the slice with a purpose-written
Python reader (chained-fixup pointers masked to their low 43 bits).

**Calibration cross-check (coordinator broadcast + closed adjudication).**
Wave-1 metadata decoded chained-fixup import ordinals off by one
(`imports[ordinal-1]`; ordinals are 0-based). The independent verifier
confirmed this; per the adjudication, import/callee names for CarProbe's
C functions are taken from the calibrated decode
(`metadata/xref/OmniCarCarProbe.json`, LC_DYSYMTAB calibration delta = 1,
125/125 votes). I cross-checked every name my reconstruction relies on
against that file:

| Check | Result |
|---|---|
| Import call sites: annotation vs calibrated target | **891/891 agree, 0 corrections** |
| ObjC selector sites: annotation vs calibrated `sel` | **398/399 agree**; the one annotation failure (next row) resolved by calibrated data |
| Site `0xacc4` in `sub_ac84` | Dumper printed `objc_msgSend(?)`; calibrated selector is **`CGContext`** — used in the source as `rendererCtx.CGContext`. (The audit's "2 sites" are this one site counted in both `00ac84_sub_ac84.txt` and `_skeletons_all.txt`.) No unknown selectors remain. |
| Class receivers (calibrated `args.x0.t == "class"`) | All names present in annotations agree. Annotation-only names are argument-position class loads (e.g. `NSArray`/`NSObject` passed to `objc_opt_isKindOfClass:` / `objc_allocateClassPair`), plus one dumper false positive at `0x7b14` ("class(NSCharacterSet)" is actually the session struct's `+0x400` field). 3 calibrated receivers have no annotation (`NSDistributedNotificationCenter` via `NSClassFromString` in `sub_4ff8`, `NSDictionary` in `sub_7b6c`, `NSString` in `sub_8ba0`) — all consistent with the manual decode. |
| CFString constants (6 arrays resolved manually) | All values identical to the calibrated `cfstrings` table (190 entries): profile keys (14), supported languages (14), vehicle name keys (5), vehicle ID keys (6), deep-find outers `[configuration, session]`, wireless outers `[session, configuration]`, property skip-list `[description, debugDescription, hash, superclass]` |

Conclusion: for this binary the inherited disassembly's names were
already correct everywhere they matter; the off-by-one affected wave-1
metadata fields, not these dumps. Where the dumps were silent (`0xacc4`),
the calibrated data supplied the name. Addresses and instructions were
never in question.

**Function-list reconciliation.** Calibrated list: 82 function starts.
My inherited index: 79 entries. Differences are pure segmentation:
calibrated splits `0x4040`, `0x4080` (inside the 192 B `sub_4000` file),
`0x42b8`, `0x42c4` (inside `sub_42ac`'s file), `0x5194` (block invoke
inside `sub_50b8`'s file) and `0x7568` (signal handler, inside the file
named `sub_7478`); the index additionally lists `0x5458` (body
continuation of `OMCCheckHooks` — one function in the source), `0x7478`
(tail of the exception handler `sub_7308`) and `0x705c` (a 44 B region
the calibrated sweep folds into the constructor region — rem4: it is
the constructor's own `__dispatch_main_q` load, not a helper). All are
accounted for in the table in §6.

## 4. Gating and lifecycle (what turns the machinery on)

- **Constructor:** ungated except the process-name check above.
- **`OMCEnabled()`** = `!OMCExpired() && pref enabled (default YES)`.
  `OMCExpired()` compares `max(now, pref trustedTime)` against a
  compiled-in expiry: `"2027-04-30"` parsed as GMT+7 midnight **+ 86400
  s** → the whole tweak family stops from **2027-05-01 00:00 +07**.
- **`OMCCrashGuard(feature)`** (the probe's only arming path): returns
  YES immediately unless the process is CarPlayApp
  (`bundleIdentifier == com.apple.CarPlayApp`) and `feature` is
  non-empty. Fresh-session path (first copy in the process): create the
  session struct, publish its pointer via `setenv("OMC_CRASHGUARD",
  "%llx", ptr)`, process any leftover crash report (rescue logic below),
  install `NSSetUncaughtExceptionHandler` + `sigaction` for
  {SIGSEGV 11, SIGBUS 10, SIGABRT 6, SIGILL 4, SIGTRAP 5, SIGFPE 8}
  (table @0xd070), register `UIScreenDidConnect/DisconnectNotification`
  observers on the main queue, and schedule the probe (+4 s). Every
  call (any copy) then runs phase 2: register `feature` in the guard
  plist's `features` list and return the rescue verdict (NO if the
  feature is in pref `rescueFeatures` and its `<feature>Enabled` pref is
  still NO).
- **Rescue rule (from leftover `OmniCar-CarPlay-crash.txt`):** each
  handler appends `omc-crash age=<s> suspect=<OmniCar dylib middle name>
  last=<last logging module> how=<exception|signal-N>`. On the next
  launch, if the youngest crash age `< 60` s: the suspect is recorded;
  if this is at least the 2nd consecutive early crash (`early >= 1`),
  the suspected features are disabled (`<feature>Enabled = NO`,
  `rescueFeatures`, `rescueDate` prefs; Darwin posts
  `com.anlai.omnicar/rescue` and `com.anlai.omnicar/prefschanged`; log
  `CHE DO CUU: …`). Otherwise `early` is incremented (log
  `CarPlay sap som %ld/2 …`). Every crash also writes pref
  `diagLastCrash` {date, age, suspect}.
- **Probe run** (`sub_7b6c`): once per external screen (disconnect
  resets). Snapshots CarKit `CARSessionStatus.currentSession` and its
  `configuration` by runtime property introspection → pref `diagCar`;
  starts the 250 ms perf sampler; posts
  `com.anlai.omnicar/car.connected`. Per-car profiles only run when
  pref `carProfilesEnabled` is YES (default NO).
- **Auto lite:** sampler evaluates only when `OMCEnabled()` and pref
  `liteMode == 2`; turns lite on for thermal ≥ serious (`heat`), ≥3
  hangs within 120 s (`hangs`), or ≥15 % late frames in a 10 s window
  (`frames`); turns it off after 180 s quiet with late < 5 %.
  `OMCLiteActive()` additionally reads the Darwin state of
  `com.anlai.omnicar/lite` (posted by the sampler side via a second
  notify token).

## 5. External surface (this binary's code)

**Darwin notifications:** posts `com.anlai.omnicar/lite` (with state
0/1), `com.anlai.omnicar/car.connected`, `com.anlai.omnicar/rescue`,
`com.anlai.omnicar/prefschanged`; reads state of
`com.anlai.omnicar/lite`.
**Distributed notifications:** posts and (in SpringBoard) observes
`com.anlai.omnicar/log` with `userInfo = {line}` — the log relay.
**Prefs (domain `com.anlai.omnicar`) read:** `enabled`,
`<feature>Enabled`, `liteMode`, `language`, `trustedTime`,
`rescueFeatures`, `rescueDate`, `carProfilesEnabled`, `carProfiles`,
`carProfileCurrent`, `diagCar`, plus the 14 profile keys.
**Prefs written:** `diagLoaded.CarProbe<ProcessName>`,
`diagHooks.<module>@<processName>`, `diagCar`, `diagPerf`,
`diagLastCrash`, `carProfiles`, `carProfileCurrent`, `rescueFeatures`,
`rescueDate`, `<feature>Enabled` (rescue), the 14 profile keys
(profile apply).
**Files:** `/var/mobile/Documents/OmniCar.log` (append; rotated to
`.log.1` at ≥ 2 MiB, SpringBoard side), `$TMPDIR/OmniCar-CarPlay-crash.txt`,
`$TMPDIR/OmniCar-crashguard.plist` {early, suspects, features}.
**Environment:** `OMC_CRASHGUARD` read/written (session struct pointer,
hex). **dlopen:** `@rpath/libroot.dylib` (with built-in rootless
fallbacks), `/System/Library/PrivateFrameworks/CarKit.framework/CarKit`.
**No** Substrate hooking, RocketBootstrap, or XPC anywhere in this
binary. Log language is Vietnamese (unaccented) + fixed English tokens;
user-facing strings route through `OMCTr` (vi/en + `Car.strings`).

## 6. Per-function table

Evidence basis for all rows: the annotated disassembly in `disasm/`
(addresses/instructions) with names per §3. "VERIFIED" = control flow,
constants, strings and call targets all read directly. INFERRED items
are listed per row and consolidated in §7. **No function is
NOT-RECOVERED; there are no stub bodies.**

| VA | Function | Role | Status |
|---|---|---|---|
| 0x4000 | sub_4000 | libroot trampoline: `libroot_get_root_prefix` via once + function pointer 0x14440 | VERIFIED |
| 0x4040 | sub_4040 | libroot trampoline: `libroot_get_jbroot_prefix` (ptr 0x14448) | VERIFIED |
| 0x4080 | sub_4080 | libroot trampoline: `libroot_get_boot_uuid` (ptr 0x14450) | VERIFIED |
| 0x40c0 | sub_40c0 | libroot forwarder: `libroot_rootfspath(path, out)` (ptr 0x14458) | VERIFIED |
| 0x4118 | sub_4118 | libroot forwarder: `libroot_jbrootpath(path, out)` (ptr 0x14460); used by OMCTr | VERIFIED |
| 0x4170 | sub_4170 | dispatch_once block: dlopen `@rpath/libroot.dylib`, dlsym the 5 libroot symbols, install fallbacks for any missing | VERIFIED |
| 0x42ac | sub_42ac | Fallback root prefix: returns `""` | VERIFIED |
| 0x42b8 | sub_42b8 | Fallback jbroot prefix: returns `"/var/jb"` | VERIFIED |
| 0x42c4 | sub_42c4 | Fallback boot UUID: all-zero UUID string | VERIFIED |
| 0x42d0 | sub_42d0 | Fallback jbrootpath: absolute path → jbroot prefix + path into 0x400 buffer (mallocs if out is NULL) | VERIFIED |
| 0x4384 | sub_4384 | Fallback rootfspath: like jbrootpath, but strips an existing jbroot prefix instead of prepending | VERIFIED |
| 0x44a8 | OMCPrefsSync | `CFPreferencesAppSynchronize(com.anlai.omnicar)` | VERIFIED |
| 0x44b4 | OMCPref | `CFPreferencesCopyAppValue(key, domain) ?: fallback` | VERIFIED |
| 0x451c | OMCEnabled | `!OMCExpired() && pref enabled` | VERIFIED |
| 0x4578 | OMCFeatureEnabled | `OMCEnabled() && pref (feature+"Enabled")` | VERIFIED |
| 0x4608 | OMCLiteActive | Lite state, 3 s cache; modes 0/1/2; auto reads thermal + Darwin state of `com.anlai.omnicar/lite` (reader token 0x14430) | VERIFIED; default `@2` INFERRED (see §7) |
| 0x4764 | OMCCarWireless | Scans `diagCar` session/configuration dicts for wireless/wired/transport keys → −1/0/1 | VERIFIED |
| 0x4b64 | OMCLogWrite | Stamps session lastModule="CarProbe"; NSLog; formats `%@ [%@:%d] %@: %@\n` (formatter `yyyy-MM-dd HH:mm:ss.SSS`); async append via log queue | VERIFIED |
| 0x4d28 | sub_4d28 | Once block: create the shared NSDateFormatter | VERIFIED |
| 0x4d6c | sub_4d6c | Log-queue getter (once via 0xafec) | VERIFIED |
| 0x4db0 | sub_4db0 | Write-line block: rotate (SpringBoard), append; on failure non-SpringBoard relays via distributed `com.anlai.omnicar/log` | VERIFIED |
| 0x4ec8 | sub_4ec8 | Log rotation at ≥ 0x200000 bytes → `OmniCar.log.1` | VERIFIED; selector names INFERRED from arity |
| 0x4f88 | sub_4f88 | Append one line: fopen("a")/fputs/fclose on `/var/mobile/Documents/OmniCar.log` | VERIFIED |
| 0x4ff8 | sub_4ff8 | `NSClassFromString(@"NSDistributedNotificationCenter").defaultCenter` | VERIFIED |
| 0x5024 | sub_5024 | Block copy helper (retain capture +0x20) for the relay block | VERIFIED |
| 0x502c | sub_502c | Block dispose helper (release capture +0x20) | VERIFIED |
| 0x5034 | OMCLogRelayStart | SpringBoard only: observe distributed `com.anlai.omnicar/log` | VERIFIED |
| 0x50b8 | sub_50b8 | Relay observer block invoke: take `userInfo[@"line"]`, dispatch append to log queue | VERIFIED |
| 0x5194 | sub_5194 | Relay append block invoke: rotate + `sub_4f88` | VERIFIED |
| 0x51b8 | OMCHasMethod | Class (after OMCCarClass mapping) implements selector; `+` prefix → class method | VERIFIED |
| 0x526c | OMCCarClass | objc_getClass + CarPlay mapping: `DashBoard`→`CARApplication`, `DB…`→`CAR…`/`_CAR…` | VERIFIED |
| 0x53b4 (+0x5458) | OMCCheckHooks | Verifies "Class selector" specs; writes `diagHooks.<module>@<process>` pref; logs renames/missing per iOS version | VERIFIED (the 0x5458 split is a sweep artifact) |
| 0x5aa4 | OMCMissingSelector | Once-per-(class, selector) log `THIEU METHOD (iOS %@): %@ -> bo qua` (dedupe set @0x14498) | VERIFIED |
| 0x5c50 | sub_5c50 | Once block: create the dedupe NSMutableSet | VERIFIED |
| 0x5c84 | OMCCarLaunchInfo | `[DBApplicationLaunchInfo launchInfoForApplication:]` (or the `withActivationSettings:` variant) via runtime lookup; logs when absent | VERIFIED |
| 0x5d94 | OMCCrashGuard | Crash-loop rescue gate + session creator + handler/observer installer + probe scheduler; phase-2 feature registration & rescue verdict | VERIFIED; handler-install brace placement & `age=` token parse mechanics INFERRED (§7) |
| 0x6f28 | sub_6f28 | Session getter: adopt struct pointer from `OMC_CRASHGUARD` env (strtoull hex) | VERIFIED |
| 0x6f6c | sub_6f6c | Guard state path: `$TMPDIR/OmniCar-crashguard.plist` | VERIFIED |
| 0x6fb8 | sub_6fb8 (__init_0) | Constructor: process-name gate {SpringBoard, CarPlay} → dispatch main-queue block | VERIFIED |
| 0x705c | sub_705c | Not a function (rem4): the `__dispatch_main_q` GOT load inside the constructor sub_6fb8; +0x1c0 is the GOT slot offset | VERIFIED (see §7.6) |
| 0x7088 | sub_7088 | Constructor block: `OMCLogWrite` build line + write `diagLoaded.CarProbe<Proc>` pref + synchronize | VERIFIED |
| 0x7218 | sub_7218 | Once block: create serial queue `com.anlai.omnicar.log` | VERIFIED |
| 0x7248 | sub_7248 | Once block: `gIsSpringBoard = (bundleID == com.apple.springboard)` | VERIFIED |
| 0x72a8 | sub_72a8 | Once block: `gIsCarPlayApp = (bundleID == com.apple.CarPlayApp)` | VERIFIED |
| 0x7308 (+0x7478) | sub_7308 | NSException handler: open crash file (O_WRONLY\|O_CREAT\|O_APPEND, 0644), ≤64 return addresses → crash line, then `uncaught %@: %@\n%@\n`, close, chain previous handler | VERIFIED |
| 0x7568 | sub_7568 | Signal handler (sigaction entry): backtrace → crash line `signal-%d`, `signal %d (code %d) addr %p pid %d`, `backtrace_symbols_fd`, dumps any `__DATA[/__DATA_DIRTY],__crash_info` payloads, close, `signal(sig, SIG_DFL)` + `raise(sig)` | VERIFIED; open flags & frame-buffer size INFERRED |
| 0x778c | sub_778c | 4-byte trampoline → sub_7790 (connect-notification block invoke) | VERIFIED |
| 0x7790 | sub_7790 | `dispatch_after(4 s, main, probe run)` | VERIFIED |
| 0x77c0 | sub_77c0 | Disconnect block: cancel timer, invalidate display link, final diagPerf write + summary log, lite off, mark `diagCar` disconnected | VERIFIED |
| 0x7a00 | sub_7a00 | Crash-line writer: first `OmniCar*.dylib` frame via dladdr → suspect; `omc-crash age=%ld suspect=%s last=%s how=%s\n` | VERIFIED |
| 0x7b6c | sub_7b6c | Probe run: screen capture, other-tweak inventory, stats reset, perf timer start, `car.connected` post, CarKit snapshot → `diagCar`, per-car profile apply/create, summary log | VERIFIED; CARSessionStatus creation call & profile branch order partly INFERRED |
| 0x8ba0 | sub_8ba0 | CarKit snapshotter: property introspection over the class hierarchy (skip `_`-names, skip-list, `^`/`@?` types, 80-key cap, descriptions truncated to 160 chars) | VERIFIED |
| 0x8e90 | sub_8e90 | Post lite state: lazy notify token (0x14434), set_state + post `com.anlai.omnicar/lite` | VERIFIED |
| 0x8f00 | sub_8f00 | 250 ms perf-timer handler: watchdog arming (busy-flag protocol), per-thread CPU sum (skip idle), resident MiB, host free MiB, `os_proc_available_memory`; hand-off to main queue | VERIFIED |
| 0x9190 | sub_9190 | `OMCNowSeconds`: mach_absolute_time × timebase / 1e9 | VERIFIED |
| 0x91e8 | sub_91e8 | Watchdog block: main-queue delay ≥0.5 s = hang, ≥2 s = freeze; attribution via session lastModule; 3-slot timestamp ring | VERIFIED; hangMaxMs update placement INFERRED |
| 0x93b8 | sub_93b8 | Record sample + auto-lite evaluation + display-link lifecycle + periodic diagPerf | VERIFIED; sync/eval cadence phases & lite-off predicate composition partly INFERRED |
| 0x9810 | sub_9810 | Build & write `diagPerf` pref (no-op < 30 s after connect) | VERIFIED |
| 0x9d8c | sub_9d8c | Set lite on/off with reason; posts state; logs `che do nhe tu dong: BAT vi %@` / `… tat` | VERIFIED |
| 0x9eb0 | sub_9eb0 | 10 s display-link stopper; computes window late-% when ≥100 frames | VERIFIED |
| 0x9f44 | sub_9f44 | `-[OMCPerfTicker tick:]` IMP block: frame/late counting from link cadence vs `maximumFramesPerSecond` interval | VERIFIED |
| 0x9fe4 | sub_9fe4 | Deep-find: first plausible string at `configuration|session` → inner key | VERIFIED |
| 0xa268 | sub_a268 | Snapshot current values of the 14 profile keys | VERIFIED |
| 0xa3ac | sub_a3ac | Once trampoline → IsSpringBoard block (token 0x144f8) | VERIFIED |
| 0xa3c0 | OMCExpired | Expiry check vs max(now, trustedTime); latching | VERIFIED |
| 0xa4bc | OMCProfileKeys | Returns the 14-key constant array @0x120c0 | VERIFIED |
| 0xa4c8 | OMCSupportedLanguages | Returns the 14-language constant array @0x120d8 | VERIFIED |
| 0xa4d4 | OMCCurrentLanguage | Pref `language` if supported; else preferredLanguages matching (exact / `sup-` prefix / base, zh excluded from base matching); else `en` | VERIFIED |
| 0xa86c | OMCTr | vi → arg 1; en/nil → arg 2; else lookup English key in Prefs bundle `<lang>.lproj/Car.strings` (per-language cache @0x14658) | VERIFIED |
| 0xaae4 | OMCLogoMeshImage | Per-variant (0/1) once-rendered 96×96 mesh image, cached @0x14628 | VERIFIED |
| 0xab78 | sub_ab78 | Render once block: renderer format (scale 1, opaque = variant), factor 0.95 (variant 0) / 1.0 (variant 1), store into cache | VERIFIED |
| 0xac84 | sub_ac84 | Draw block: fill 96×96 background (variant RGBA constants), 4 radial gradients at the corners, end radius 95.035151391472, locations {0, 1}; context via `CGContext` (calibrated) | VERIFIED; gradient component packing INFERRED |
| 0xaea4 | sub_aea4 | Expiry once block: parse `2027-04-30` (en_US_POSIX, GMT+7) + 86400 s → 0x14648 | VERIFIED |
| 0xafa4 | sub_afa4 | Once block: create OMCTr's cache dictionary | VERIFIED |
| 0xafd8 | sub_afd8 | Once trampoline → log-formatter block (token 0x14488) | VERIFIED |
| 0xafec | sub_afec | Once trampoline → log-queue block (token 0x144e8) | VERIFIED |
| 0xb000 | sub_b000 | 4 B veneer → sub_a3ac | VERIFIED |
| 0xb004 | sub_b004 | 4 B veneer → sub_a3ac | VERIFIED |
| 0xb008 | sub_b008 | 4 B veneer → sub_a3ac | VERIFIED |
| 0xb00c | sub_b00c | Once trampoline → missing-set block (token 0x144a0) | VERIFIED |
| 0xb020 | sub_b020 | Once trampoline → IsCarPlayApp block (token 0x14508) | VERIFIED |
| 0xb034 | sub_b034 | Once trampoline → expiry block (token 0x14650) | VERIFIED |
| 0xb048 | sub_b048 | Once trampoline → Tr-cache block (token 0x14660) | VERIFIED |

## 7. Former INFERRED items — all adjudicated in rem4

Each item below was re-read end-to-end in the original
`OmniCarCarProbe.dylib` (dumps `disasm/rem4_*.txt`, length-checked).
No item remains inferred.

1. **`liteMode` default = @2 — CONFIRMED.** The default object
   @0x11ea0 is an `__NSConstantIntegerNumber`; payload at +16 reads
   exactly 2 (raw struct read, rem4). The same object is the one
   passed as the `_OMCPref` default in sub_93b8 @0x94f8.
2. **CrashGuard handler-install placement — CONFIRMED.** In
   `OMCCrashGuard` (0x5d94) the installs — `NSSetUncaughtException
   Handler` @0x6a80, the 6-signal `sigaction` loop @0x6aa8–0x6ac0,
   two `addObserverForName:` @0x6b18/0x6b80, probe scheduling
   (sub_7790) @0x6b9c — sit on the unconditional fall-through of the
   fresh-session path, immediately after the fresh session record is
   written (@0x6a60). A full branch scan of the report-parse and
   decision region (0x5f10–0x6a6c) found no branch that skips them;
   the only entries past them are the once/report-mode shortcuts at
   the function head, which are entry-mode dispatch, not a gate on
   the leftover report's content (an absent leftover file flows
   through an empty dictionary at 0x5efc and still reaches the
   installs).
3. **CrashGuard `age=` parse mechanics — CONFIRMED in full.** Lines
   split on `@"\n"` (@0x60b8), lines gated by prefix `@"omc-crash "`,
   tokens split on `@" "` (@0x6164), token prefixes extracted with
   `substringFromIndex:` at their literal lengths — `age=` (4),
   `suspect=` (8), `last=` (5) — and the age minimum tracked with a
   `csel` against an INT64_MAX seed (@0x61f0). Thresholds 59/60 s
   and count 2 literal as before.
4. **Signal handler (sub_7568) open flags / buffer — CONFIRMED from
   its own body** (not by analogy): `open(path, 0x209, 0644)` —
   0x209 = O_WRONLY|O_CREAT|O_APPEND, mode immediate 0x1a4;
   `backtrace(buf, 0x40)` — the 64-frame cap is in this handler
   itself (@0x75c4). The verified format string
   `signal %d (code %d) addr %p pid %d` is fed from
   `siginfo->si_code` (+8) and `si_addr` (+0x18).
5. **sigaction flags word — CONFIRMED literally.** The 8-byte
   `__const` template @0xd048 copied into the struct is
   sa_mask = 0x00000000, **sa_flags = 0x00000040 = SA_SIGINFO**;
   handler = 0x7568; the signal table @0xd070 is
   {11, 10, 6, 4, 5, 8} (SIGSEGV, SIGBUS, SIGABRT, SIGILL, SIGTRAP,
   SIGFPE).
6. **sub_705c provenance — CORRECTED.** 0x705c is not a function or
   block helper: it is the address of the `adrp`/`ldr
   __dispatch_main_q` inside the constructor function sub_6fb8
   itself (the +0x1c0 is the GOT slot offset within the 0x10000
   page). The constructor gates on processName `@"SpringBoard"` /
   `@"CarPlay"` and dispatch_async's a block capturing the name to
   the main queue; the block invoke is the next function start,
   0x7088. Source comment corrected.
7. **sub_4ec8 — selectors CONFIRMED, suffix CORRECTED.** The four
   selector names are the binary's own selrefs (dump
   rem4_sub_4ec8.txt). The 2 MiB threshold is `cmp #0x200000`. The
   appended suffix is **`@".old"`** (cfstring @0x10e78), not `.1`;
   source corrected.
8. **sub_7b6c details — CONFIRMED with one correction.** Creation
   is **`_objc_opt_new`** (@0x820c, i.e. `[cls new]`) on the
   `CARSessionStatus` class obtained via NSClassFromString after
   dlopen'ing CarKit — not `[[cls alloc] init]`; source corrected.
   Snapshot order is `session` (valueForKey `currentSession`,
   stored under `session`) then `configuration` (same string as
   KVC key and storage key), the dict written to pref `diagCar`.
   Profile flow order is stash-current (outgoing profile's
   `values` ← live snapshot @0x8608–0x864c) → apply-existing
   (per-key CFPreferencesSetAppValue) or create-new
   (`{values: snapshot}`, `name`, `lastSeen`). In BOTH log lines —
   `nap ho so xe %@ (%@)` and `ho so xe moi: %@ (%@)` — the first
   `%@` is the vehicle descriptor (the same string stored as the
   profile's `name`, fallback `OMCTr(@"Xe", @"Car")`) and the
   second is the profileKey (`"%@|%@"` of descriptor and `pixels`).
9. **sub_93b8 cadences — CONFIRMED except the link cadence,
   CORRECTED.** Prefs-sync runs on even sample counts (low-bit
   test @0x94c8) = every 2nd sample ✓; diagPerf flush (sub_9810)
   passes at counts 6, 12, 18 … (emulated ror-1 test) = every 6th
   ✓; the lite-off predicate is exactly late < 5 ∧ lite-on ∧
   > 180 s since change ∧ newest hang-ring slot quiet > 180 s
   (constants 5.0 / 180.0 @0xd068 literal) ✓. The display-link
   creation gate is the same 0xAAAB ror-2 test as the shared unit:
   passes at counts 4, 16, 28 … = **count % 12 == 4**, not
   ≡ 1 (mod 3); source corrected.
10. **sub_91e8 `hangMaxMs` placement — CORRECTED.** In the binary
    (@0x927c–0x9298) the update `max(0x14558, delay × 1000.0)`
    (scale constant @0xd058 = 1000.0) sits after and outside the
    ≥ 2 s branch; inside that branch only the freeze counter
    (@0x14560) increments, and a second ≥ 2 s test gates only the
    log line. Source corrected (the update now runs for every
    recorded sample, delay ≥ 0.5 s).
11. **sub_ac84 gradient packing — CORRECTED.** Colours @0xd0f0,
    centres {(96,96), (0,96), (96,0), (0,0)}, locations {0.0, 1.0}
    (@0xd100) and end radius 95.035151391472 (@0xd0d8) all literal
    as reported. The component mapping is now exact: the NEON
    shift vector @0xd0d0 is (−16, −8), extracting (byte2, byte1);
    with the scalar byte0 the stops are **(R, G, B)** of the
    0x00RRGGBB colour — stop 0 alpha = the block's `factor`
    (context +0x20), stop 1 alpha = 0.0 (colour → transparent).
    The source previously wrote the components in a permuted
    order with a mostly-zero second stop; corrected.

## 8. Coverage statement

82/82 calibrated functions reconstructed with real bodies in
`OmniCarCarProbe.m` (plus the 3 index-only regions accounted for:
0x5458 merged into OMCCheckHooks, 0x7478 as the exception-handler tail,
0x705c — rem4: not a helper at all, just the `__dispatch_main_q` GOT
load inside the constructor at 0x6fb8). 20/20 exports present. No stub
bodies, no placeholder returns. The 11 former INFERRED items of §7
were all adjudicated against the binary in rem4 (see §7): items 1–5
confirmed exactly as written; items 6–11 each contained at least one
error that is now corrected in the source (the other sub-points of
items 7, 8, 9 and 11 were confirmed). No item remains inferred.
