# OmniCar 1.0.3 — Coverage Map v1 (metadata wave)

Project: reconstruct a complete, compilable source project for OmniCar 1.0.3
(package `com.anlai.omnicar`, rootless `iphoneos-arm64`) from the original DEB.
Reference DEB SHA256: `d9297b010cdc08e401439b7332413f79cb1a056a05159a5deb673e218d76d9fd`
(verified by the coordinator before extraction; all evidence below comes from
that one payload — no other binary was mixed in).

This file is the shared coverage skeleton: one row per executable component.
Per-binary detail lives in `metadata/<BinaryName>.md` with raw dumps in
`metadata/raw/<BinaryName>/` (scan.json, objc.json, objc_dump.txt, strings.txt,
filter.plist / Info.plist.json).

## Tool census (what exists on this VM, what was actually used)

| Tool | Status |
|---|---|
| llvm-objdump / llvm-nm / llvm-readobj / llvm-dwarfdump (any version) | NOT installed |
| otool, class-dump, ghidra, radare2/r2 | NOT installed |
| python3 3.12.3 | present — **used** (custom parsers, below) |
| /usr/bin/strings, /usr/bin/file | present — **used** (strings dumps; file-type sanity) |
| capstone 5.0.7 (python) | present — not needed in this wave (reserved for disassembly wave) |
| macholib 1.16.4 (venv at `metadata/tools/venv/`) | installed this wave — **used as independent cross-check** (UUIDs: 16/16 slices agree with the custom parser) |
| lief | not installed |

Because no Mach-O ObjC tooling exists on this VM, two pure-stdlib Python
parsers were written and are reusable by all module agents:

- `metadata/tools/macho_scan.py` — fat split, load commands, sections, symtab counts.
- `metadata/tools/macho_objc.py` — chained-fixups-aware ObjC extraction
  (classes/ivars/properties/methods+type encodings/categories/protocols/
  classrefs/selrefs), LC_SYMTAB symbols, exports trie, fixup imports.
- `metadata/tools/build_metadata.py` — stages raw dumps and generates the
  per-binary reports (rerunnable end-to-end).

### Extraction validation (evidence the metadata is trustworthy)

- Chained-fixups import set == LC_SYMTAB undefined-symbol set, exactly, in
  every slice of every binary (165/165 in OmniCarCore, etc.).
- arm64 vs arm64e ObjC surfaces are **identical** in all 8 binaries
  (class names, per-class method counts, superclasses, ivar names+types,
  categories, protocols, selrefs, classrefs compared programmatically).
- macholib agrees with the custom parser on all 16 slice UUIDs.
- All 8 binaries: cryptid = 0 (not encrypted), code signature present,
  min iOS 15.0, SDK 16.4, no `__DWARF` sections, no Swift sections.

## Coverage table

Role = **guess from evidence only** (substrate filter + class/symbol names);
each row names its evidence. "Methods" = instance+class methods defined on the
binary's own classes. Status columns are the project tracker — update in place.

| Binary | Role (GUESS, evidence in per-binary .md) | Size (fat) | Classes | Methods | Categories | Notable IPC channels (evidence) | Reconstruction | Verification |
|---|---|---:|---:|---:|---:|---|---|---|
| OmniCar (app) | Settings-app executable; single class `OMCAppDelegate`; bundle `com.anlai.omnicar.app`, URL scheme `omnicar` (deep links incl. `omnicar://splitscreen/open?left=…&right=…` seen in strings) | 168,880 | 1 | 6 | 0 | none of the probed IPC imports present (38 undefined symbols total) | not started | — |
| OmniCarCore.dylib | SpringBoard-side core (filter: `com.apple.springboard` only). Defines the shared OMC* C core + Core-only `_OMCTrustedTimeStart`; classrefs show NSURLSession/NSURL networking | 276,832 | 0 | 0 | 0 | Darwin notify full set (`notify_register_dispatch/post/get_state/set_state/register_check`); identifiers `com.anlai.omnicar`, `com.anlai.omnicar.log`, `com.anlai.omnicar.perf` (roles unproven — likely log subsystems) | not started | — |
| OmniCarCarProbe.dylib | Minimal probe inside CarPlayApp (filter: `com.apple.CarPlayApp`); 0 classes, 0 own C functions beyond the shared core set, no MSHook imports | 242,784 | 0 | 0 | 0 | `notify_post/get_state/set_state/register_check` (state reporting; no hook imports — guess: reports CarPlay/process state via notify state) | not started | — |
| OmniCarAppBridge.dylib | App hosting + keyboard (filter: `com.apple.UIKit` — loads in EVERY UIKit process). Classes `ABPane/ABHost/ABBoxView/ABShieldView/ABKnobView/ABKeyboard/ABKey`; C fn `_ABTelexApply` (Vietnamese Telex input — guess from name) | 613,376 | 8 | 193 | 0 | `MSHookMessageEx` + `MSHookFunction` (only AppBridge and SpeedBubble import MSHookFunction); Darwin notify full set | not started | — |
| OmniCarSplitScreen.dylib | Split-screen panes + custom CarPlay home/icons (filter: CarPlayApp + SpringBoard). Classes `SCPCarSplit/SCPCarSplitView/SCPCarPane/SCPCarDividerView/SCPHostedAppVC/SCPHomeWallView/…`; C fns `SCPHome*/SCPIcon*/SCPLaunch*` | 1,229,920 | 11 | 480 | 0 | `MSHookMessageEx`; Darwin notify full set | not started | — |
| OmniCarSpeedBubble.dylib | Speed bubble overlay (filter: SpringBoard + CarPlayApp + Vietmap `vn.vietmap.live`, GOFA `com.lumi.GOFA`, Waze `com.waze.iphone`, Wyn `com.wynauto.wyn`). Classes `SPPSpeedGPS/SPPOverspeed/SPPBubble/SPPBubbleView/SPPSpeak`-family C fns | 649,808 | 9 | 277 | 0 | `MSHookMessageEx` + `MSHookFunction`; Darwin notify full set | not started | — |
| OmniCarStartupScreen.dylib | Startup splash on CarPlay connect (filter: CarPlayApp + SpringBoard). Classes `SSSplash/SSSplashWindow/SSStartupView/SSGauge/…`; C fns `SSWeather*`; prefs keys `startupScreen*` (13 of 16 declared keys appear in its strings) | 567,792 | 8 | 173 | 0 | `MSHookMessageEx`; Darwin notify full set; CFNotificationCenter (Darwin) observe+post; identifier `com.anlai.omnicar.startupscreen.decode` (role unproven) | not started | — |
| OmniCarPrefs (bundle) | PreferenceLoader settings UI (install name inside `OmniCarPrefs.bundle`; `NSPrincipalClass = OMCRootListController`). 29 controllers/cells incl. `OMC*Controller`, `SPP*`/`SS*` preview views | 1,303,344 | 29 | 743 | 0 | `notify_post`; CFNotificationCenter Darwin post. Declares the prefs domain `com.anlai.omnicar` + 16 keys in its plists | not started | — |

Totals: 8 binaries, 66 classes, 1,872 methods on own classes, **0 categories
anywhere** (consistent with Logos/MSHook-style hooking rather than category
swizzles), 29 defined protocols, 2,130 symtab symbols across the arm64
slices (defined + undefined).

## Cross-cutting findings (evidence, not guesses)

1. **Shared core is statically embedded in every dylib.** The same 20 C
   functions — `_OMCPref, _OMCEnabled, _OMCFeatureEnabled, _OMCExpired,
   _OMCCheckHooks, _OMCCrashGuard, _OMCLogWrite, _OMCLogRelayStart, _OMCTr,
   _OMCCurrentLanguage, _OMCSupportedLanguages, _OMCProfileKeys, _OMCPrefsSync,
   _OMCCarClass, _OMCCarLaunchInfo, _OMCCarWireless, _OMCHasMethod,
   _OMCMissingSelector, _OMCLiteActive, _OMCLogoMeshImage` — are defined in
   Core, CarProbe, AppBridge, SplitScreen, SpeedBubble and StartupScreen
   alike. OmniCarCore.dylib adds exactly one more: `_OMCTrustedTimeStart`.
   Reconstruction should model this as one shared "OMCCommon" unit compiled
   into each module, not six independent implementations.
2. **Prefs surface**: domain `com.anlai.omnicar` (declared in the Prefs
   bundle plists, `defaults` key). 16 keys are declared there:
   `speedBubbleEnabled`, `splitScreenEnabled`, and 14 `startupScreen*` keys.
   App-bridge/split app-selection keys are NOT in the plists; they must be
   read in code (key-shaped string candidates are listed, labelled as
   guesses, in each per-binary report).
3. **Hooking**: `MSHookMessageEx` is imported by AppBridge, SplitScreen,
   SpeedBubble, StartupScreen. Core and CarProbe import **no** MSHook
   symbols. No RocketBootstrap and no XPC imports anywhere. No Logos-named
   symbols survive in any symtab (binaries are stripped; only exported +
   imported names remain).
4. **Sibling-module loading**: strings `%@/OmniCar%@.dylib` / `%@/OmniCar%@.plist`
   in the dylibs indicate modules locate/load sibling modules by path at
   runtime (mechanism — dlopen vs. substrate — is wave-2 work).
5. **Files on device** (from strings): `/var/mobile/Documents/OmniCar.log`
   (+ `OmniCar.log.old`, `OmniCar-log-%@.txt`, `OmniCar-CarPlay-crash.txt`,
   `OmniCar-crashguard.plist`), `/var/mobile/Library/OmniCar/StartupScreen/…`
   (Videos/Sounds/Logo/logo.png, location.plist, weather.plist).
6. **Oddity, reported as-is**: several classes bind semantically surprising
   superclasses (e.g. `SCPCButton → NSSortDescriptor`,
   `SCPCarSplitView → NSMutableArray`, `ABPane → NSRunLoop`). The encoding is
   a direct `_OBJC_CLASS_$_…` bind and is **identical in both slices**, so it
   is what the binary declares — not a parser artifact. Module agents should
   treat superclass bindings as data to explain, not silently "fix" them.
7. Code-signing identity strings in every dylib name the unsigned build
   artifact (e.g. `OmniCarCore.dylib.1e69ddd5.unsigned`) — same build hash
   `1e69ddd5` across modules (the app shows `76b690a6`), consistent with one
   lld link pass per module from a single build.

## Limits of this wave (honest)

- This wave recovers **metadata only**: no function bodies, no hook targets,
  no disassembly. IMP addresses are recorded in objc.json/objc_dump.txt as
  the starting index for the disassembly wave.
- Notification **names** for the Darwin notify traffic are not yet proven:
  the notify_* APIs are imported (proven), and `com.anlai.*` identifier
  strings exist (listed per binary), but which strings are notify names vs.
  log subsystems vs. queue labels must be settled by xref in wave 2.
- Strings triage is pattern-based; categories say so where they appear.
- No `[OmniCar…]`-style bracket log tags exist in the payload strings
  (all 8 dumps searched; the only bracket token found is the artifact
  `[XFV]`). Log messages are plain strings, largely Vietnamese — module
  agents should not hunt for bracket-tag prefixes in this version.
- No DWARF exists, so no original file/line/variable names are recoverable
  from debug info; reconstruction naming will be new but behaviour-anchored.
