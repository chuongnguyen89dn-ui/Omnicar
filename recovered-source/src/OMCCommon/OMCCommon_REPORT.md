# OMCCommon + OmniCarCore — reconstruction report

Module: the 20-function OMC* shared core embedded in every OmniCar 1.0.3
dylib, plus OmniCarCore.dylib's Core-only machinery (21st export
`_OMCTrustedTimeStart`, initialisers, handlers).
Source: `OMCCommon.h`, `OMCCommon.c`, `OmniCarCore.c` (Objective-C, ARC).
Evidence: per-function annotated disassembly in `disasm/` (103 functions of
OmniCarCore's arm64 slice, `INDEX.txt` included), produced with capstone
5.0.7 + the custom resolver in `tools/omc_disasm.py`.

## Method and name attribution (coordinator adjudication)

- Chained-fixup bind ordinals are **0-based** (dyld semantics). The wave-1
  parser decoded them as `imports[ordinal-1]`; the independent verifier
  confirmed the off-by-one and the calibrated data in `metadata/xref/` is
  ground truth. My resolver (`tools/omc_disasm.py`, written independently
  of the wave-1 parser) already used 0-based indexing, anchored on
  semantically forced sites (`_OMCPrefsSync`'s tail-call must be
  `CFPreferencesAppSynchronize`, etc.).
- **Cross-check against the calibrated xref for OmniCarCore, run before
  finalising: import call sites agree 1192/1192; class-receiver sites
  agree 121/121 directly, plus 7 sites where a nearest-load heuristic
  differed but the calibrated name matches the semantic reading already
  used in the source (NSMutableURLRequest, NSString ×4,
  NSDistributedNotificationCenter, NSMutableOrderedSet). Corrections
  required: NONE.**
- The independent audit (`metadata/ANNOTATION_AUDIT.md`) scores this
  module's dumps: 2,006/2,006 call annotations exact, 0 wrong.
- OmniCarCore defines **0 ObjC classes**, so superclass names (the other
  wave-1 casualty) do not arise in this module.
- Selector names were taken from the CFString arguments at call sites and
  from selref slots; annotations on fast-enumeration state loads are
  unreliable in the dumper (they can print a garbage class name) and were
  never used as evidence.

## The 21 exports — per-function status

All addresses/sizes are the arm64 slice of OmniCarCore.dylib.
Status key: **VERIFIED** = body follows the machine code instruction by
instruction; **INFERRED** items inside a verified body are listed in the
register at the bottom.

| Function | Addr | Size | Status | Evidence summary |
|---|---|---|---|---|
| `OMCPrefsSync` | 0x6528 | 12 | VERIFIED | Single tail-branch to `CFPreferencesAppSynchronize(CFSTR("com.anlai.omnicar"))`. |
| `OMCPref` | 0x6534 | 104 | VERIFIED | `CFPreferencesCopyAppValue(key, domain)`; non-nil → return, nil → return `def`. No caching. |
| `OMCEnabled` | 0x659c | 92 | VERIFIED | `OMCExpired()` gate, then `OMCPref(@"enabled", kCFBooleanTrue)` boolValue. Default ON. |
| `OMCFeatureEnabled` | 0x65f8 | 144 | VERIFIED | Master gate; key = feature + `@"Enabled"`, default `@YES`. |
| `OMCExpired` | 0xc414 | 252 | VERIFIED | dispatch_once deadline (below); effective now = max(wall clock, `trustedTime` pref if NSNumber); sticky latch at bss+0x200; fail-open when deadline ≤ 0. |
| — deadline block (sub_cef8) | 0xcef8 | — | VERIFIED | `NSDateFormatter` en_US_POSIX, `yyyy-MM-dd`, TZ GMT+7 (25200 s) parses `@"2027-04-30"`; deadline = epoch + 86400 = **1809104400**. |
| `OMCTrustedTimeStart` | 0x44a8 | 196 | VERIFIED | Core-only. Announces expiry once (flag bss+0x30), starts a trusted-time fetch, arms 21600 s refetch + 60 s watchdog timers. Machinery fully decoded (see helpers). |
| `OMCLiteActive` | 0x6688 | 348 | VERIFIED | 3.0 s throttle cache; `liteMode` pref default 2; mode 2 = enabled && (thermal ≥ Serious ‖ notify state of `com.anlai.omnicar/lite` ≠ 0); notify token in `__data`, initial −1. |
| `OMCCarWireless` | 0x67e4 | 1024 | VERIFIED | Tri-state −1/1/0 from `diagCar` pref sections `session`, `configuration`; key/value substring rules (wireless/wired/transport × 1/0/wifi/usb) exactly as written in source. |
| `OMCLogWrite` | 0x6be4 | 424 (Core) / 452 (others) | VERIFIED + variant | NSLog echo (ungated); line `"<ts> [<proc>:<pid>] <tag>: <msg>\n"`; serial queue `com.anlai.omnicar.log`; append `/var/mobile/Documents/OmniCar.log`; SpringBoard rotates at 2 MiB; non-SpringBoard falls back to the `com.anlai.omnicar/log` distributed notification. **Only divergent shared function — see comparison section.** |
| `OMCLogRelayStart` | 0x7088 | 132 | VERIFIED | SpringBoard-only subscription to the log relay; observer token intentionally leaked. |
| `OMCHasMethod` | 0x720c | 180 | VERIFIED | `+` prefix → class method (stripped), else instance method, on `OMCCarClass(name)`. |
| `OMCCarClass` | 0x72c0 | 328 | VERIFIED | `objc_getClass`, else `DashBoard`→`CARApplication`, `DB<X>`→`CAR<X>`→`_CAR<X>`. |
| `OMCCheckHooks` | 0x7408 | 1776 | VERIFIED | Parses `"<Class> <-/+sel>"` specs; records renames (ordered set) and misses; cumulative pref `diagHooks.<tag>@<proc>` {total, missing, ios}; three log lines (renamed / missing / all-present) verbatim in source. |
| `OMCMissingSelector` | 0x7af8 | 428 | VERIFIED | Once-per-(class, selector) log `THIEU METHOD (iOS %@): %@ -> bo qua`, NSMutableSet + @synchronized. |
| `OMCCarLaunchInfo` | 0x7cd8 | 272 | VERIFIED | `DBApplicationLaunchInfo` factory, two selector fallbacks, failure logged via `OMCLogWrite(@"Core", …)`. |
| `OMCCrashGuard` | 0x7de8 | 4500 | VERIFIED | Full state machine reconstructed: env-pointer state (0x448 B struct), crash-marker parsing, early-crash counting (60 s window, threshold 2), rescue mode (disable + `rescueFeatures`/`rescueDate` prefs + 2 notify posts), un-rescue on manual re-enable, exception + signal handlers, screen observers. Signal table {11,10,6,4,5,8}, SA_SIGINFO. |
| `OMCProfileKeys` | 0xc510 | 12 | VERIFIED | Returns the constant 14-key array (contents in source). |
| `OMCSupportedLanguages` | 0xc51c | 12 | VERIFIED | Constant 14-language array. |
| `OMCCurrentLanguage` | 0xc528 | 920 | VERIFIED | `language` pref if supported; else preferredLanguages exact → prefix → base-language matching (zh special-cased); fallback `en`. |
| `OMCTr` | 0xc8c0 | 632 | VERIFIED | vi/en short-circuits; other languages load `<jbroot>/Library/PreferenceBundles/OmniCarPrefs.bundle/<lang>.lproj/Car.strings` (path confirmed against the DEB payload), keyed by the English string; per-language cache. |
| `OMCLogoMeshImage` | 0xcb38 | 148 | VERIFIED | 88×88 renderer, per-style dispatch_once cache (no bounds check), draw block fully decoded: fill + 4 corner radial gradients, packed stop colours {0x00A0F1D9, 0x00FEC4D8, 0x00A6DDFD, 0x00C9BAFC}, end radius literal 95.035151391472. |

## Core-specific helpers — status

| Helper | Role | Status |
|---|---|---|
| sub_4118 / sub_4170 + fallbacks | libroot loader + jbrootpath dispatcher | VERIFIED behaviour; libroot API-name correspondence INFERRED |
| sub_456c / sub_5d8c / sub_5f44 | trusted-time fetch (HEAD apple.com, HTTP `Date` header, RFC-1123 parse GMT+0) + monotonic store | VERIFIED |
| sub_4648 / sub_464c | 6 h refetch thunk / 60 s expiry watchdog | VERIFIED |
| sub_46f0 | constructor: log relay, load log, trusted-time start, rescue + car.connected + cleanram.now notify registrations, `omnicar/url` distributed observer | VERIFIED |
| sub_488c | rescue announcer (feature display names, `CFUserNotificationDisplayNotice` via dlsym) | VERIFIED (incl. the single-letter vi-string anomaly, preserved) |
| sub_6000 | notice call block | VERIFIED: `noticeFn(0.0, 0, NULL, NULL, NULL, title, body, @"OK")` on a background queue |
| sub_4c64 / sub_4c98 / sub_5d84 | car.connected (+8 s) and cleanram thunks into sub_4ca0 | VERIFIED |
| sub_4ca0 | car-state record / clean+classify pass | PARTIALLY RECOVERED — entry + ingredients VERIFIED (AVExternalDevice probe, running apps, bundle-id lists, pref keys); classification/record tails are `/* STUB-UNRECOVERED */` in source |
| sub_5728 | `omnicar://` dispatcher (feature / lite / startup) | VERIFIED routes, keys, log lines; on/toggle wiring + known-feature test INFERRED |
| sub_6078 | safe zero-arg msgSend by selector name | VERIFIED |
| sub_60e4 | running-applications collector (SBApplicationController) | PARTIALLY RECOVERED — head VERIFIED, filter tail stubbed |
| sub_900c / sub_90dc | build-stamp initialiser (`diagLoaded.Core@<proc>`, build `fbebb21`, version `1.0.3`) | VERIFIED |
| sub_8f7c / sub_8fc0 | crash-state env getter / state-file path | VERIFIED |
| sub_9a54 | crash-marker writer (`omc-crash age=%ld suspect=%s last=%s how=%s`) | VERIFIED |
| sub_935c / sub_95bc | exception / signal crash handlers (incl. `__crash_info` section scan) | VERIFIED |
| sub_97e4 / sub_9814 | screen connect (+4 s recorder) / disconnect (perf summary + diagCar update) | connect VERIFIED; disconnect VERIFIED structure, stat-field meanings INFERRED |
| sub_9bc0 | connect-time car recorder (diagCar, carProfiles, perf start) | PARTIALLY RECOVERED — elements + all log formats VERIFIED, probing order stubbed |
| sub_b864 | perf flush to `diagPerf` pref | NOT RECOVERED beyond the VERIFIED 22-key list — stubbed |
| sub_bde0 | auto-lite evaluator (drives the `lite` notify state) | NOT RECOVERED beyond VERIFIED log format — stubbed |

## Cross-binary comparison (all 6 dylibs)

Method: `tools/omc_compare.py` compares **normalised instruction
streams** (mnemonics + registers; address formation replaced by semantic
descriptions — CFString literals, constant arrays, block-invoke targets,
classref slots; per-binary layout offsets abstracted). Raw bytes are
never identical between binaries (relocation/layout), so byte-identity
is not the right criterion; the mission question "same source compiled
in" is answered by the normalised streams + identical sizes.

Result, Core vs each of AppBridge, SplitScreen, SpeedBubble, CarProbe,
StartupScreen:

- **19 of the 20 shared functions: identical** normalised streams and
  identical sizes in all six binaries → same source, VERIFIED.
- **`_OMCLogWrite`: genuinely divergent.** Core = 424 B, calls the
  crash-state getter and discards the result. All five others = 452 B:
  when the state exists they first stamp `state->lastFeature` with their
  own module name via `__strlcpy_chk(state+0x400, name, 0x40, 0x40)` —
  names read directly from the binaries: "AppBridge", "SplitScreen",
  "SpeedBubble", "CarProbe", "StartupScreen". This is the writer of the
  `last=` field in crash markers. The reconstruction reproduces both
  variants from one source via `-DOMC_MODULE_NAME='"<Name>"'` (Core
  builds without it). (Comparator note: its token stream did not
  discriminate the embedded name literal, so the variant was confirmed
  by direct reading in all five binaries.)
- **`_OMCTrustedTimeStart`: present only in Core** — absent from the
  other five symbol tables (wave-1 fact, re-verified).

## Build verification

Both translation units compile clean with the project toolchain
(clang-18, iPhoneOS16.5 SDK, `-fobjc-arc -fblocks`, target
arm64-apple-ios15.0), including the `-DOMC_MODULE_NAME` variant:

```
clang-18 -target arm64-apple-ios15.0 -isysroot ~/theos/sdks/iPhoneOS16.5.sdk \
  -fobjc-arc -fblocks -x objective-c -c OMCCommon.c    # 0 errors
clang-18 ... -c OmniCarCore.c                          # 0 errors
```

The resulting objects define exactly the 21 expected `_OMC*` text
symbols (20 in OMCCommon.o + `_OMCTrustedTimeStart` in OmniCarCore.o).

## Unfinished (explicit stubs in source, `/* STUB-UNRECOVERED */`)

1. `sub_9bc0` probing sequence (diagCar session/configuration assembly,
   carProfiles bookkeeping order, perf-sampler setup).
2. `sub_b864` diagPerf value assembly (22 keys known).
3. `sub_bde0` auto-lite decision logic (log format known).
4. `sub_4ca0` classification body + `!clean` record tail.
5. `sub_60e4` per-app filter tail.
Finishing any of these needs one careful line-by-line read of the
corresponding dump in `disasm/` — no new tooling required.

## INFERRED register (everything not proven by the machine code)

- libroot dlsym symbol names / API correspondence (fallback behaviour
  itself is VERIFIED).
- Log rotation: the `.old` path as log-path + `@".old"` (threshold,
  remove+move VERIFIED).
- Crash-marker file read encoding = UTF-8 (content checks VERIFIED).
- URL dispatcher: on/toggle wiring, the known-feature membership test,
  and the current-value default (`kCFBooleanTrue`).
- Perf statics field meanings (+0x120…+0x180), from the disconnect
  summary format + diagPerf key names.
- Logo gradient end radius 95.035151391472 treated as a plain literal.
- `OMCTr`: the `@synchronized(gTrCache)` scope (load inside, return
  outside) — cache + once structure VERIFIED.
- `OMCCarClass` in the original returns its Class through an ARC
  retain/autorelease pattern (id-typed declaration in the original);
  semantics identical, source declares `Class`.

## Anomalies preserved, not "fixed"

- The rescue announcer passes single letters as the Vietnamese strings
  to `OMCTr` (`@"C"`, `@"M"`, `@"B"`, `@"A"`, title `@"O"`, body key
  `@"C"`). As compiled, vi-locale users see those letters. Reproduced
  verbatim and flagged in `OmniCarCore.c`.
- `OMCLogoMeshImage` indexes its 2-slot cache with an unchecked `style`.
- `OMCExpired`'s deadline block silently does nothing for an empty date
  string (fail-open) — the string is a non-empty constant, so this is a
  latent path only.

## Tooling caveats (for the next agent)

- `tools/omc_disasm.py` resolves chained fixups with 0-based ordinals
  (adjudicated correct). Block-literal invoke decode can be off by 0x10
  when the raw pointer carries the stride bit (bits 52–59) — verify
  invoke targets against the function-start set.
- Section-offset annotations in the dumps can be off by 0x18; trust
  adrp+add arithmetic over annotation offsets.
- `__objc_intobj` constant NSNumbers are 24-byte entries {isa, tag,
  int64 at +16} (e.g. the `@2` default in `OMCLiteActive`).

## Stub-closure addendum

All five stubs listed under "Unfinished" above are now **CLOSED**. Each
was reconstructed by a line-by-line read of its annotated dump in
`disasm/` (cross-checked against the calibrated names in
`metadata/xref/OmniCarCore.json`); no sequence had to be left open and
nothing was guessed. The `/* STUB-UNRECOVERED */` markers are gone from
both source files; each closed site carries a
`/* closed by stub-closure pass: … */` note instead.

1. **sub_9bc0 probing sequence — CLOSED.** For every non-main screen,
   and only while no session is active, the connect recorder initialises
   the perf session once: it stamps the session start, counts other
   tweaks by scanning dyld image names for `/DynamicLibraries/` or
   `/TweakInject/` (excluding `OmniCar*`), resets every perf static
   (frame interval = 1/max(fps,1), the two min trackers to DBL_MAX, the
   late-percent tracker to a −8.5 sentinel, lite state forced off via
   sub_aee4), creates the 250 ms dispatch-source sampler on the
   `com.anlai.omnicar.perf` queue (sub_af54 handler, decoded in full:
   atomic-coalesced main-queue hang watchdog sub_b23c; every 10th fire
   samples per-thread CPU via `task_threads`/`thread_info`, memory via
   `TASK_VM_INFO.phys_footprint`, system free via `host_statistics64`,
   and `os_proc_available_memory`, consumed on the main queue by
   sub_b40c, which also drives auto-lite and lazily creates the
   OMCPerfTicker display link measured by sub_bf98/sub_bf04), and posts
   `com.anlai.omnicar/car.connected`. Per screen it then writes the
   `diagCar` record (date/connected/iOS version/points/pixels/scale/
   maxFPS) plus a session + configuration snapshot produced by
   sub_abf4, a generic property snapshotter (class-hierarchy walk to
   NSObject, object-typed non-pointer non-block properties only, KVC
   reads, descriptions flattened to one line, 160-char cap, 80-entry
   cap), and — when `carProfilesEnabled` — the per-car profile flow:
   the outgoing car's live values are snapshotted (sub_c2bc), the
   current car's stored profile values are applied key-by-key, profiles
   are keyed by the first vehicle identifier found by sub_c038
   (configuration section before session) or by `<name>|<pixels>`, and
   `carProfileCurrent` + `lastSeen` are updated with a
   `prefschanged` post.

2. **sub_b864 diagPerf assembly — CLOSED.** The flush is gated on a
   session existing and being at least 30 s old. All 22 verified keys
   are written with their exact sources: every counter is rounded with
   the binary's float→int conversion (llrint) and boxed; `fps` is
   1/frameInterval; `hangWho` is a copy of the culprit dictionary,
   included only when non-empty; the whole CPU/memory block
   (`cpuAvg`/`cpuMax`/`memMB`/`memMaxMB`/`availMinMB`/`sysFreeMinMB`)
   is emitted only when the sample count is non-zero, with the two min
   trackers reporting 0 while still at their DBL_MAX sentinel;
   `thermalMax` and `lowPower`, `tweaks` (empty array when nil),
   `liteCount`, and `liteReason` (only when set) follow unconditionally;
   the dictionary is stored to the `diagPerf` pref and synchronised.

3. **sub_bde0 auto-lite logic — CLOSED.** sub_bde0 is only the state
   setter; the decision logic lives in the perf consumer sub_b40c
   (reconstructed under stub 1). The setter no-ops when the state byte
   is unchanged; otherwise it records the change time (monotonic clock
   sub_b1e4), and on enable increments the lite counter, stores the
   reason string, and drives the `com.anlai.omnicar/lite` notify state
   through sub_aee4, logging `che do nhe tu dong: BAT vi <reason>` (the
   ` vi ` suffix exists only on enable; disable logs `…: tat`). Two
   corrections to the earlier stub: the second parameter is an
   `NSString *reason`, not an `int` (prototype and the disconnect call
   site fixed), and the enable conditions in sub_b40c are thermal
   state > 1, a hang within the last 120 s, or late-percent ≥ 15,
   with turn-off requiring no hang in 180 s, late-percent ≤ 5, and
   180 s since the last change.

4. **sub_4ca0 tails — CLOSED.** The manual entry (`clean == YES`, from
   `cleanram.now`) runs unconditionally; the automatic entry
   (`clean == NO`, 8 s after connect) first requires `OMCEnabled()` and
   the `cleanRamOnConnect` pref. Both run one pass: the classification
   dictionary always maps the six system ids to `system`, and — only
   when a car is connected OR the pass is automatic (the `csinc` gate
   `classify = hasCar || !clean`, pinned by verifying ARM64 csinc
   false-operand semantics against the max(fps,1) site in sub_9bc0) —
   also the media/nav ids to `car` and every member of the
   `splitScreenCarPlayApps` / `appBridgeApps` prefs to the pref key
   itself; now-playing and frontmost bundle ids are then stamped
   `playing` / `front`. Unclassified running apps are killed when their
   `LSApplicationProxy` type is `User`, or `System` without the
   `hidden` tag, via `BKSTerminateApplicationForReasonAndReportWith…`
   (reason 5, resolved once by sub_d02c/sub_64f0) with an
   `FBSSystemService` fallback (reason 1). The pass stores
   `diagCleanRam` {date, closed, running-count}, logs the
   `don RAM (bam tay|cam xe, xe=%d)…` summary with kept apps rendered
   as `bid (category)`, and schedules the sub_6320 recheck that logs
   any closed app still running after 2 s.

5. **sub_60e4 filter tail — CLOSED.** When `runningApplications` is
   empty, the fallback enumerates `allApplications`: an app that
   responds to `isRunning` is kept iff it returns YES; an app that
   does not respond is kept iff its `processState` probe returns
   non-nil (a responding-but-not-running app is dropped without the
   processState probe being consulted).

### Corrections and notable findings from this pass

- The bss+0x90 slot long declared as `NSTimer *gPerfTimer` is in fact
  a **CADisplayLink** (created by sub_b40c via
  `-[UIScreen displayLinkWithTarget:selector:]` on the session screen,
  invalidated by sub_9814 and sub_bf04). Renamed `gPerfDisplayLink`.
- bss+0x148 is the **hang counter** (gaps ≥ 0.5 s; diagPerf `hangs`;
  disconnect summary "do %.0f lan") and bss+0x140 the **freeze
  counter** (gaps ≥ 2 s; diagPerf `freezes`); the source variables are
  now named `gStatHangs` / `gStatFreezes` accordingly. bss+0x150 is
  the **peak** memory (`memMaxMB`), bss+0x158 the latest sample
  (`memMB`). bss+0x180 (sample count) is an integer in the binary,
  now declared `long`. bss+0x108 increments on connect as well as
  disconnect — it is a session-generation counter.
- The lite notify state uses **two distinct registration tokens** for
  the same name: the reader (`OMCLiteActive`) holds `__data+0x0`, the
  writer (sub_aee4) lazily registers its own at `__data+0x4`.
  Reproduced as-is.
- The INFERRED-register entry "Perf statics field meanings
  (+0x120…+0x180)" is superseded: every field in +0x88…+0x1F8 is now
  pinned by the dumps (see the statics block in OMCCommon.c).

### Compile check (re-run after closure)

Same commands as "Build verification" above, outputs redirected to
/tmp: `OMCCommon.c`, `OmniCarCore.c`, and the
`-DOMC_MODULE_NAME='"SplitScreen"'` variant of `OMCCommon.c` all
compile with **0 errors and 0 warnings**. Symbol check with
`llvm-nm-18 --defined-only`: OMCCommon.o defines exactly the 20
expected `_OMC*` text symbols, OmniCarCore.o defines
`_OMCTrustedTimeStart` — 21 in total, unchanged from before closure;
every new helper introduced by this pass is file-static (local `t`/`b`
symbols only, no new exports).
