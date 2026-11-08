# CarProbe — HANDOVER NOTE (from StartupScreen+CarProbe agent, 2026-11-08)

State: **disassembly COMPLETE and validated; source reconstruction NOT yet written.**
Everything below is from the disassembly in `src/CarProbe/disasm/` (one `.txt`
per function + `_index.json`). A pre-filtered "skeleton" view of all functions
(calls/strings/branches only) is saved as
`src/CarProbe/disasm/_skeletons_all.txt` — read that first, it is ~90% of the
semantic content. I had read skeletons up to ~line 1270 of the old dump
(through `sub_7308`'s head) when the module was reassigned; the rest (from
`sub_7478` on) is in that file but unread by me.

**ADDENDUM (same day, after handoff was requested):** `tools/disasm.py`
gained one more segmentation pass — direct BL targets inside `__text` are
function entries by definition, and two real functions in StartupScreen
(0x4118, 0x9afc) were being merged into neighbours without it. CarProbe's
disasm was regenerated with the improved segmenter: **79 functions** now
(was 67; the extra 12 are BL-target entries previously merged into larger
bodies — all findings below were re-checked to still hold at function
granularity; addresses/exports cited are unchanged). `_skeletons_all.txt`
was regenerated to match.

## Tooling (inherited, working)
- `~/workspace/omnicar-re/tools/disasm.py` — annotated disassembler (capstone,
  system python3). Regenerates `disasm/` per module:
  `python3 tools/disasm.py OmniCarCarProbe src/CarProbe/disasm`.
  `tools/skel.py <file.txt>` prints the skeleton of one function.
- **Function segmentation is SOLVED and validated**: starts = union of defined
  symbols, data-section pointers (block invokes), `__init_offsets`, and
  `__unwind_info` compressed-page entries. The unwind decode is non-textbook
  for these lld images and was brute-force scored against ground truth:
  index entries are 12 B `{functionOffset, secondLevelPagesSectionOffset,
  lsdaIndexSectionOffset}` located at header field [5] (0x44 here, NOT at
  `indexSectionOffset`); compressed page = `{u32 kind=3, u16
  encodingsPageOffset, u16 functionCount}`, entries start at
  page+encodingsPageOffset, `VA = index.functionOffset + (entry & 0xFFFFFF)`.
  CarProbe result: 67 functions covering 100% of known starts; StartupScreen:
  331. Do not re-derive this.
- **⚠️ BUG in shared metadata tooling** (`metadata/tools/macho_objc.py`):
  `_import_name` maps bind ordinal → `imports[ordinal-1]` — off by one for
  these fmt-6 lld images. Proof: with `imports[ordinal]`, all 109 CarProbe
  __objc_stubs decode to `_objc_msgSend` (with the shipped mapping they decode
  to `_objc_getClass` etc. — impossible), and classref[0] = NSProcessInfo,
  matching code usage. Consequences: **superclass names in the wave-1
  metadata .md files are wrong** (artifacts of the misread classref table).
  `tools/disasm.py` monkeypatches the corrected mapping at load; the shared
  tool itself was NOT edited. CarProbe has 0 ObjC classes so it is unaffected;
  StartupScreen's corrected superclasses: SSSplashWindow→UIWindow,
  SSCanvasView/SSStartupView→UIView, all others→NSObject.

## CarProbe structure (VERIFIED from disasm)
- Fat binary, arm64 slice 111,712 B, UUID 60EABE81-…, filter = **CarPlayApp
  only**, **0 ObjC classes, no MSHook imports**. It is ~entirely the **shared
  "OMC core"** statically linked into every OmniCar dylib (20 exported C
  symbols: OMCPrefsSync, OMCPref, OMCEnabled, OMCFeatureEnabled, OMCLiteActive,
  OMCCarWireless, OMCCarClass, OMCCarLaunchInfo, OMCLogWrite, OMCLogRelayStart,
  OMCHasMethod, OMCCheckHooks, OMCMissingSelector, OMCCrashGuard, OMCExpired,
  OMCProfileKeys, OMCSupportedLanguages, OMCCurrentLanguage, OMCTr,
  OMCLogoMeshImage) plus ONE module-specific constructor. Its unique job in
  CarPlayApp = run the core's diagnostics/probe duties there (below).
- **No `__mod_init_func`**; the single `__TEXT,__init_offsets` entry is the
  constructor at **0x6fb8** (`__init_0`; my splitter cut a spurious boundary at
  0x705c — 0x6fb8–0x7088 is one function; the block invoke is at 0x7088).
- Global block literals live in `__DATA_CONST,__const` 0x103e8–0x106d8 (all
  flags 0x50000000). Map (literal → invoke): 0x10408→sub_4170 (dispatch_once
  libroot resolver), 0x10448→sub_4d28 (log date-formatter getter),
  0x104b8→sub_50b8 (log-relay notification handler, sig takes NSNotification),
  0x104d8→sub_5c50 (NSMutableSet lazy getter for OMCMissingSelector),
  0x104f8→sub_7218 (creates serial queue "com.anlai.omnicar.log"),
  0x10518→sub_7248 (bundle-id == com.apple.springboard check),
  0x10538→sub_72a8 (bundle-id == com.apple.CarPlayApp check),
  0x10558→sub_778c (UIScreenDidConnect handler), 0x10578→sub_77c0
  (UIScreenDidDisconnect handler, 940 B), 0x10598→sub_7b6c (5012 B, screen
  enumeration — see below), 0x105b8→sub_8f00 (4164 B, unread),
  0x10638→sub_9f44 (sig `v24@?0@8@16`, unread), 0x10698→sub_aea4 (unread),
  0x106b8→sub_afa4 (unread). Literal 0x10468 has copy/dispose = sub_5024/
  sub_502c (trivial retain/release).

## Per-function findings so far (all VERIFIED at skeleton level unless noted)
- `__init_0` @0x6fb8: reads `[[NSProcessInfo processInfo] processName]`; ONLY
  if it equals @"SpringBoard" or @"CarPlay" it dispatch_async's to the main
  queue the block @0x7088. (Filter only injects CarPlayApp; the SpringBoard
  arm is shared-core code compiled into every dylib.)
- Block @0x7088 (module-specific!): `OMCLogWrite("CarProbe", [NSString
  stringWithFormat:@"build %s (%s) loaded into %@", "fbebb21", "1.0.3",
  processName])` — note format order: build string first. Then writes prefs
  key `[NSString stringWithFormat:@"%@%s@%@", @"diagLoaded.", "CarProbe",
  processName]` = `{version: @"1.0.3", build: @"fbebb21", date: [NSDate date]}`
  via CFPreferencesSetAppValue + CFPreferencesAppSynchronize on domain
  `com.anlai.omnicar`. **Every dylib announces its load this way**
  (`diagLoaded.<Module>@<Process>`).
- `sub_4170` + `sub_4000/4018/4058/4098/40c0/40e4/413c/42ac/42d0/4384` cluster:
  **libroot loader / jailbreak path resolution** (shared core). dlopen
  "@rpath/libroot.dylib", dlsym libroot_get_root_prefix /
  libroot_get_jbroot_prefix / libroot_get_boot_uuid / libroot_jbrootpath /
  libroot_rootfspath; fallbacks "/var/jb" and
  "00000000-0000-0000-0000-000000000000"; path building with
  malloc/strlcpy/strlcat/strlen/strncmp. sub_4000 & sub_40c0 are
  dispatch_once thunk groups (br x0/x2 jump-table style).
- `OMCPrefsSync` @0x44a8: tail-call CFPreferencesAppSynchronize(
  @"com.anlai.omnicar").
- `OMCPref(key, default)` @0x44b4: CFPreferencesCopyAppValue(key,
  @"com.anlai.omnicar") ?: defaultValue, returned autoreleased.
- `OMCEnabled` @0x451c: if OMCExpired() → NO; else [OMCPref(@"enabled",
  @YES) boolValue].
- `OMCFeatureEnabled(name)` @0x4578: OMCEnabled() && [OMCPref(name +
  @"Enabled", @YES) boolValue].
- `OMCLiteActive` @0x4608: reads pref @"liteMode" (integerValue), throttled
  re-check via CFAbsoluteTimeGetCurrent + CFPreferencesAppSynchronize;
  also NSProcessInfo thermalState and Darwin notify_register_check /
  notify_get_state on **"com.anlai.omnicar/lite"** can force lite mode.
- `OMCCarWireless` @0x4764 (1024 B): reads `OMCPref(@"diagCar", nil)`; if it
  is an NSDictionary, fast-enumerates it: for each value that is a dict,
  enumerates its keys; for each string value, lowercases key and value
  description and applies: key contains "wireless" → value "1"⇒wireless /
  "0"⇒wired; key contains "wired" → inverse; key contains "transport" →
  value contains "wifi"/"wireless"/"wi-fi" ⇒ wireless, contains
  "usb"/"wired" ⇒ wired. **So `diagCar` is the car-probe results dictionary;
  WHO WRITES it is still open** — no CFPreferencesSetAppValue(@"diagCar")
  seen in the functions I read; check sub_7b6c/sub_8f00/sub_9f44 and the
  other modules (writer may live in Core/AppBridge, where CarKit is
  reachable; CarProbe's strings DO include a CarKit private-framework path).
- `OMCLogWrite(module, fmt, ...)` @0x4b64: gate sub_6f28 (crashguard-env
  check, below); NSLog(@"[OmniCar/%@] %@", module, msg); builds line
  `"%@ [%@:%d] %@: %@\n"` (timestamp from sub_4d28's shared NSDateFormatter
  "yyyy-MM-dd HH:mm:ss.SSS", processName, getpid(), module, msg); then on the
  serial queue from sub_4d6c/sub_7218 ("com.anlai.omnicar.log") dispatch_async
  → sub_4db0. Tail calls sub_afd8 (queue getter variant).
- `sub_4db0`: try local append — sub_4ec8 (rotate: if
  /var/mobile/Documents/OmniCar.log fileSize too big, remove ".old", move
  current → +".old") then sub_4f88 (fopen(path,"a")/fputs/fclose); if local
  write not possible, post **distributed notification**
  `@"com.anlai.omnicar/log"` with userInfo `{line: <line>}` via
  NSDistributedNotificationCenter (looked up by NSClassFromString, sub_4ff8).
- `OMCLogRelayStart` @0x5034: registers addObserverForName
  @"com.anlai.omnicar/log" on the distributed center with block sub_50b8,
  which takes userInfo[@"line"], NSString-checks it, and on the log queue
  appends it to the file (sub_4ec8+sub_4f88). **This is the log relay: app
  processes post lines; a listener process (SpringBoard instance of the
  core) writes the file.** Product log = /var/mobile/Documents/OmniCar.log.
- `OMCHasMethod(className, spec)` @0x51b8: resolves class via OMCCarClass;
  spec prefix "+" → class method (strips prefix), else instance method;
  returns class_get{Class,Instance}Method != NULL.
- `OMCCarClass(name)` @0x526c: CarPlay dashboard class-name resolution:
  the argument is an NSString built from a C string; special case
  @"DashBoard" → objc_getClass("CARApplication"); names with prefix "DB" →
  strip 2 chars, prepend @"CAR", objc_getClass; fallback appends @"_CAR"
  variants — **read the full text to pin the exact fallback order** before
  writing source.
- `OMCCheckHooks(specs)` @0x53b4 + `sub_5458` (1612 B, its worker): parses
  space-separated hook requirement specs, resolves each class via
  OMCCarClass, each selector via OMCHasMethod ("-"/"+" prefixes), collects
  missing ones, writes prefs key `diagHooks.<...>@<processName>` =
  `{ios: [UIDevice systemVersion], total: N, missing: [...]}` and logs in
  Vietnamese via OMCLogWrite: "iOS %@: lop CarPlay %@", "iOS %@: %lu/%lu hook
  KHONG co tren iOS nay (tinh nang lien quan se khong chay): %@", or
  "iOS %@: du %lu hook".
- `OMCMissingSelector(cls, sel, ...)` @0x5aa4: dedupes via an NSMutableSet
  (lazy getter sub_5c50) under @synchronized, logs once per pair:
  "THIEU METHOD (iOS %@): %@ -> bo qua" (NSStringFromClass + selector).
- `OMCCarLaunchInfo(bundleId)` @0x5c84: class = OMCCarClass(
  "DBApplicationLaunchInfo"); tries selector
  "launchInfoForApplication:withActivationSettings:" then
  "launchInfoForApplication:" via objc_opt_respondsToSelector + objc_msgSend;
  on absence logs (module tag "Core") "THIEU METHOD: %@ khong tao duoc
  launchInfo" and returns nil.
- `OMCCrashGuard(feature)` @0x5d94 (4644 B — the big one): crash-loop
  protection state machine. Elements seen: setenv("OMC_CRASHGUARD",
  snprintf("%llx", time())); state file
  NSTemporaryDirectory()/OmniCar-CarPlay-crash.txt with lines
  "omc-crash age=<n> suspect=<name> last=<...>" parsed token-wise;
  a plist (path via sub_6f6c = NSTemporaryDirectory()/
  "OmniCar-crashguard.plist", lazy getter sub_6f28 returns it after
  checking getenv("OMC_CRASHGUARD")) with keys "early" (count) and
  "suspects" (array); writes prefs @"diagLastCrash" = {date, age, suspect};
  NSDictionary "features" list in the plist; **rescue mode**: when crashes
  repeat (log: "CHE DO CUU: CarPlay sap %d lan lien trong %ds dau -> tat %@",
  "CarPlay sap som %ld/%d lan lien (nghi: %@)"), it sets
  `<feature>Enabled` = @NO in prefs for features in pref @"rescueFeatures",
  stamps @"rescueDate", posts Darwin **notify_post(
  "com.anlai.omnicar/rescue")** and **notify_post(
  "com.anlai.omnicar/prefschanged")**; a feature found in rescueFeatures
  with its Enabled pref back on is removed from the rescue list ("%@ bat lai
  sau che do cuu"), otherwise hook installation is refused with log
  "%@ dang tat boi che do cuu (tu %@): khong cai hook trong CarPlay".
  Tail of the function also: NSSetUncaughtExceptionHandler + sigaction
  install, and registers the UIScreenDidConnect/Disconnect observers
  (blocks sub_778c/sub_77c0) on NSNotificationCenter mainQueue, then calls
  sub_7790. **This tail suggests OMCCrashGuard doubles as the core's
  one-time "arm" entry — read the full 4644 B text carefully and split
  state-machine phases in the report; thresholds (counts/seconds) are in
  the immediate operands, get them exactly.**
- `sub_7308` (unread beyond head): opens (open()) something, enumerates
  [NSThread callStackReturnAddresses] — part of the exception/signal crash
  handler writing the "omc-crash" record. Read fully.
- `sub_7790` + `sub_7b6c` (5012 B): screen handling. sub_7b6c head:
  fast-enumerates [UIScreen screens], skips [UIScreen mainScreen], records
  first non-main screen into a global @0x144a8, increments counter @0x14528,
  timestamps with NSDate — INFERRED: car-screen capture used by the shared
  core (this is as far as I read; finish it — it may be where display
  metrics / the `diagCar` dict get built).

## Still unread (in `_skeletons_all.txt` from ~line 1270 on, plus full texts)
sub_7478 (788 B), sub_7b6c (rest), sub_8f00 (4164 B), sub_8ba0, sub_9190,
sub_91e8, sub_93b8, sub_9810, sub_9d8c, sub_9f44 (two-object block invoke),
sub_9fe4, sub_a268, sub_a3ac, sub_a3c0 (OMCExpired is in this region — check
_index.json), OMCProfileKeys, OMCSupportedLanguages, OMCCurrentLanguage,
OMCTr, OMCLogoMeshImage @0xaae4, sub_ab78, sub_ac84, sub_aea4, sub_afa4,
sub_afd8, sub_afec, and the tiny epilogue-thunks (sub_b000…sub_b020 are
unwind/personality thunks, not real functions). Also still open: exact
OMCCarClass fallback order; OMCCrashGuard numeric thresholds; who writes
the `diagCar` pref; what sub_8f00/sub_9f44 register (dispatch/notify) —
grep their full texts for `block_lit` annotations to find registrants.

## Role conclusion so far (for the report; VERIFIED basis above)
CarProbe.dylib is not an independent feature: it is the shared OMC core
compiled for CarPlayApp, whose constructor announces the load
(`diagLoaded.CarProbe@CarPlay`, log line "build fbebb21 (1.0.3) loaded into
CarPlay") and whose core services provide: prefs access, feature gating,
CarPlay class/launch-info resolution, hook self-checks (diagHooks.*),
missing-method logging, crash-guard/rescue mode, the unified log + relay,
lite-mode, expiry, localization (OMCTr), and car wireless/wired
classification from the `diagCar` probe dictionary. The actual *probing*
of the head unit (populating `diagCar`) was NOT found in the functions read
— it is either in the unread block cluster (sub_7b6c/sub_8f00/sub_9f44) or
in another module; the report must state which, from code.
