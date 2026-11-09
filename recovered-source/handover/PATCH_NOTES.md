# PATCH NOTES — OmniCar 1.0.3 reconstruction, fix round 2 (2026-11-08)

Scope: the §8 E1/E2 source fixes, integrated and rebuilt in the
finishing pass (E3). Evidence for this round:
`project/logs/fix-round/` (`build.log`, `perclass.txt`, `diff.txt`,
`hookcount.txt`, `static-checks.txt`, `uuid-manifest.txt`,
`harness/results.txt`, `SUMMARY.md`). This file records what
changed in the source; `RECOVERY_STATUS.md` §10 records the round's
build/verification outcome.

## 1. Installer / handler disposition

| Piece | Disposition | Where / note |
|---|---|---|
| `ABHostCtor` (constructor, AppBridgeEntry.m) | KEPT as gate | Bundle-id gate (`com.apple.springboard`) + log + exactly one call to the installer. No hook calls of its own (binary-verified: ctor @0x1be58 has 0 direct MSHook sites). |
| `ABInstallSpringBoardHooks` (ABHostGeometry.m:417) | NEW — single installer | Holds all 5 host installs (4× MSHookMessageEx + 1× MSHookFunction), the re-entry guard, the per-hook pre-checks, and the OMCCheckHooks call. Sole installer in the built binary (@0x12b24). |
| `ABChannels.m` `ABSpringBoardInit` + `repl_*` handlers | #if 0-NEUTRALISED | Whole duplicate installer and its repl_* handler bodies are inside `#if 0` regions (installer at lines 372–411); kept as reference text only. Binary-verified ABSENT: no third hook-containing function exists in the built dylib. |
| `ABHostProcessInit` (ABChannels.m) | KEPT LIVE | The in-app-process bootstrap in the same file was not part of the duplicate host group and remains live. |
| Registrar (`ABSpringBoardReady`, ABHostGeometry.m) | KEPT, in ABSpringBoardReady, with once-guard | Calls the original `applicationDidFinishLaunching:` IMP first, then registers all channels (6 distributed + 2 Darwin + local CarPlay notification) under a `static BOOL ABRegistrarRegistered` once-guard (lines 101–133). |
| In-app installer (ABInApp.m, via ABInstallInAppObservers) | KEPT, with per-method gates | Its 13 MSHookMessageEx sites are a separate, expected set in the built binary (function @0x13408), distinct from the host group. Optional-method installs are gated per method (see D2-6 in the matrix). |


## 2. Fix matrix

| # | Defect fixed | File / function | Disasm evidence | Verification |
|---|---|---|---|---|
| 1 | Installer restructure + re-entry guard + pre-hook checks: the 5 host installs lived in the ctor and a dead duplicate; no guard, no verification before hooking | ABHostGeometry.m `ABInstallSpringBoardHooks` (new); AppBridgeEntry.m `ABHostCtor` reduced to gate + call | Original ctor 0x6E08 installs 4+1 exactly once (`ctor_host_6e08.txt`) | BINARY: hookcount.txt — one installer @0x12b24 with 4+1, ctor calls it, total sites 17+1. STATIC: static-checks.txt (i) |
| 2 | `OMCCheckHooks` verification call missing from the live installer | ABHostGeometry.m, end of `ABInstallSpringBoardHooks` (line 529) | Original calls OMCCheckHooks at 0x6F3C–0x6F4C with the same 3-selector array | STATIC: grep line 529 (static-checks.txt (i) region); source call present with the binary's selector list |
| 3 | Registrar could run more than once (double channel registration) | ABHostGeometry.m `ABSpringBoardReady` — `static BOOL ABRegistrarRegistered` once-guard (lines 101–133) | Registrar dump `registrar_7004.txt`: single registration pass in the original | STATIC: guard lines shown in source; HARNESS test 4 (hook-chain guard simulation) PASS |
| 4 | FBScene completion parameter typed loosely; swallowed-path behaviour unclear | AppBridgeB.h:74 `typedef void (^ABFBSceneUpdateCompletion)(void);` used by `ABHook_FBSceneUpdateSettings` | FBScene hook dump sub_74B4: completion forwarded only on the non-swallowed path | STATIC: typedef + cast at ABHostGeometry.m:360/378. See the C3-3 note in §3 — the typedef changes no behaviour |
| 5 | ScreenBlanked BOOL unification: handler/orig declaration spellings diverged (`void` vs `BOOL` class of mismatch) | ABHostGeometry.m `ABHook_ScreenBlanked(BOOL)` + `orig_ScreenBlanked` as `void (*)(BOOL)` | sub_777C dump: BOOL argument throughout | STATIC: static-checks.txt (iv) — body non-empty, orig(1) / delayed orig(0) / orig(blanked) |
| 6 | frame / open channel handlers lacked exception wrappers (a throw inside a channel block could escape into the host) | ABHostGeometry.m channel blocks `ABChanFrame` / `ABChanOpen` — @try/@catch wrappers added | Channel block dumps (sub_783C open, frame block) show guarded host-side handling | STATIC: source inspection this round; build clean. Behavioural proof is DEVICE (pending, §4) |
| 7 | Open handler carried an extra guard the binary does not have, and its hosted-window (`aw`) condition differed | ABHostGeometry.m `ABChanOpen` — guard removed, `aw` condition restored to the binary's | sub_783C dump: no such guard; condition as transcribed | STATIC: source vs dump comparison by the fixer; build clean |
| 8 | shield / close / closeall / knobs channel handlers lacked exception wrappers | ABHostGeometry.m `ABChanShield` / `ABChanClose` / `ABChanCloseAll` / `ABChanKnobs` — @try/@catch wrappers added | Channel dumps sub_8DF0 / 8FD4 / 9144 (close / closeall / knobs) | STATIC: source inspection; build clean; DEVICE pending |

| # | Defect fixed | File / function | Disasm evidence | Verification |
|---|---|---|---|---|
| 9 | D2-6 — in-app optional hooks installed unconditionally (an absent method would leave a NULL orig) | ABInApp.m in-app installer — per-method checks (`OMCHasMethod` for UIWindowScene geometry; `class_getInstanceMethod` / `class_getClassMethod` for the UIViewController pair, lines 124–141) | installer_app_4728.txt: the original gates the geometry hook on method presence | STATIC: static-checks.txt (v) region + ABInApp.m lines 124–141. NOTE: per-method checks for the whole set are a work-order hardening beyond the binary — see §3 |
| 10 | D2-7 — FPS orig pointers called without NULL guards in `ABApplyFPSLimit` | ABInApp.m `ABApplyFPSLimit` (lines 552/555: `if (orig_CADisplayLink_setRange)`, `if (orig_CADisplayLink_setFPS && fps > ABFPSLimit)`) | sub_50A8/5144/5220 family: orig slots are only meaningful once the setters are hooked on the instance class | STATIC: static-checks.txt (v) |
| 11 | D5 — variadic `OMCLogWrite` prototype in a StartupScreen header conflicted with the shared 2-argument implementation; 33 call sites passed format varargs through it | SSStartupScreen.h (prototype removed/aligned) + 33 call sites in SSSplash.m (9) and SSStartupScreen.m (24) converted to the 2-argument form | Shared `_OMCLogWrite` @0x6BE4 is 2-argument in every binary (OMCCommon.c:316) | STATIC: static-checks.txt (vii) — only declaration in the tree is `void OMCLogWrite(NSString *, NSString *)` (OMCCommon.h:111) |
| 12 | Prefs `OMCHSInstalled` read a BOOL return through `performSelector:` (id) — BOOL bits reinterpreted as an object pointer | Prefs/OMCPrefs/OMCHSPreview.m `OMCHSInstalled` — typed BOOL send | Sibling implementations use the typed BOOL send: OMCAppBridgeAppsController.m OMCDynBool, SCPAppIcons.m:189, SCPHomeVisibility.m:97 | STATIC: source vs siblings (audit-log-pid.md D3 table); build clean |
| 13 | `SCPKillAppBlock` fallback lacked the original's failure log line | SplitScreenA/SCPSpringBoardHooks.m — `@"tat han %@: khong thay process"` log restored in the pid-not-found branch (line 117) | sub_89D0 dump: the log line is in the binary (recorded as a micro-gap in the hotfix round, now closed) | STATIC: static-checks.txt (vi) region |
| 14 | Rescue strings cut down to one letter: `OMCRescueAnnounce` viText literals were `@"O"` / `@"C"` etc. | OMCCommon/OmniCarCore.c `OMCRescueAnnounce` — six full Vietnamese literals restored verbatim | ROOT CAUSE: the original's strings are UTF-16LE cfstrings (`__ustring`, flags 0x7D0); the earlier extraction misread them as C strings and kept 1 character. Fix = the verbatim binary strings, cfstring-struct verified | STATIC: static-checks.txt (viii) — all six literals present, no single-letter literals in the file |


## 3. Claim split — STATIC / HARNESS / DEVICE

- **STATIC (proven this round, on the rebuilt binary and the
  source)**: clean build exit 0 / 0 errors; per-class selector
  parity 62/66 exact with 0 classes missing a selector
  (Prefs 743→745, OMCAppBridgeAppsController 105=105,
  SplitScreen 480=480); payload 176/176 files, 168/168
  non-Mach-O byte-identical, 0 original defined symbols missing;
  hook-install count (single host installer, 4+1; ABChannels
  copies absent); the eight E1 static checks (i)–(viii);
  parity restage 202/202 entries, 0 differences; UUID manifest
  (see §10 of RECOVERY_STATUS.md for the crash-attribution
  result).
- **HARNESS (host-executed transcribed logic, no device)**:
  `project/logs/fix-round/harness/results.txt` — 274 assertions,
  0 failures: keyboard + apporient IPC round-trips, orientation
  clamp, unblank sequence, hook-chain guard simulation. The
  harness executes transcriptions of the fixed logic, not the
  shipped binary.
- **DEVICE**: nothing in this round has run on a device.
  **DEVICE_TEST = PENDING** (§4).

Two interpretation notes, recorded deliberately:

- **C3-3 — FBScene swallowed paths drop the completion 0×.**
  On the swallowed path the reconstruction never invokes the
  completion block. That is BINARY-FAITHFUL, not a defect: the
  original releases the completion without invoking it at its
  0x7680 epilogue. It was deliberately NOT changed this round
  and is flagged here for GPT acceptance — accepting the round
  means accepting this behaviour as the original's.
- **D2-6 — per-method checks exceed the binary.** The original
  carries a single `OMCHasMethod` gate; the per-method checks
  applied across the in-app installer are a work-order
  hardening beyond the binary, kept because a missing method
  otherwise leaves a NULL orig slot of exactly the class that
  caused the hotfix round.
- **§4 encoding check — interpretation.** In
  `ABInstallSpringBoardHooks` the pre-hook verification treats
  method EXISTENCE as the hard gate (absent class/method →
  log + skip that hook); the type-encoding comparison is a
  structural check (return-type character + argument structure
  after self/_cmd; argument offsets and the `B` vs `c` BOOL
  spelling are not hard-gated).

## 4. Device test status

**DEVICE_TEST = PENDING.** No build from fix round 2 has been
installed on a device. The startup-first retest protocol in
RECOVERY_STATUS §9/§10 remains the next step, and behavioural
equivalence is not claimed until it passes.

## 5. Out of scope this round (flagged, NOT fixed)

Three more single-letter `OMCTr` viText toast sites in
`src/SplitScreenA/SCPCarSplit.m` — lines ~422, ~448 and ~1580
(toast messages) — share the rescue defect class (UTF-16LE
cfstrings misread as C strings, leaving 1-character Vietnamese
literals). They were NOT fixed this round: their binary strings
have not yet been extracted, and guessing the full text would
repeat the original extraction error. They need a cfstring-struct
extraction pass like the one that fixed `OMCRescueAnnounce`.

## 6. Toast strings restored (build2, 2026-11-08)

Follow-up to §5: the flagged sites were extracted with the
cfstring-struct method of `work/fix-round2/audit-rescue.md`
(parse each `__cfstring` entry as {isa, flags, ptr, length};
flags `0x7d0` → UTF-16LE in `__ustring`). A full re-sweep of
`src/` found **nine** single-character `OMCTr` viText sites in
`src/SplitScreenA/SCPCarSplit.m` (the §5 line numbers were
cluster approximations), plus one in the non-compiled handoff
copy `src/SplitScreenB/handoff/SCPCarSplit+Layout_A-owned.m`
(same string as site 7 below; not part of the build, left
as-is). In the original `OmniCarSplitScreen.dylib`, each
toast's vi cfstring sits immediately before its en partner
(VA − 0x20); both slices decode identically. Every broken
literal is exactly the first UTF-16 code unit of the binary
string, misread as a C string — the rescue defect class.

| # | Line | Old | English anchor | Binary viText (exact) |
|---|---|---|---|---|
| 1 | 422 | `@"A"` | `This app doesn't support CarPlay` | `App này không hỗ trợ CarPlay` |
| 2 | 437 | `@"�"` (U+FFFD) | `This pane is pinned` | `Ô này đang ghim` |
| 3 | 446 | `@"%"` | `%@ is already open in %@` | `%@ đang mở ở %@` |
| 4 | 448 | `@"c"` | `the floating window` | `cửa sổ nổi` |
| 5 | 449 | `@"�"` (U+FFFD) | `another pane` | `ô khác` |
| 6 | 859 | `@"%"` | `%@ replaced %@ in pane %d` | `%@ thay %@ ở ô %d` |
| 7 | 1294 | `@"%"` | `%@ moved to the background` | `%@ về nền` |
| 8 | 1580 | `@"K"` | `Couldn't show %@ on the car` | `Không mở được %@ trên xe` |
| 9 | 2810 | `@"A"` | `This app can't be split` | `App này không chia màn hình được` |

cfstring evidence (arm64 slice; arm64e identical text):
vi structs at VA 0x7b4a0 / 0x7b4e0 / 0x7b540 / 0x7b580 /
0x7b5c0 / 0x7b800 / 0x7b320 / 0x7d560 / 0x7d980, all flags
`0x7d0`, backings 0x74a50 / 0x74a8a / 0x74aaa / 0x74aca /
0x74ae0 / 0x74b20 / 0x74a3c / 0x74fc8 / 0x74ffa, lengths
28 / 15 / 15 / 10 / 6 / 17 / 9 / 24 / 32 UTF-16 units — in
table order. The two `@"�"` literals are the same collapse:
`Ô` (U+00D4) and `ô` (U+00F4) are invalid UTF-8 lead bytes
when read naively, so the extraction baked in U+FFFD.
Full per-string citations: `work/fix-round2/audit-toasts.md`.

Only the nine vi literals changed — no logic, no en text, no
comments needed correction (this file carried no "ANOMALY"
note). Source synced to `project/OmniCarSplitScreen/` and
`cmp`-verified identical.

Build2 verification: clean build exit 0
(`project/logs/fix-round/build2.log`); per-class parity
unchanged (62/66 exact, 0 selectors missing, Prefs 743→745,
SplitScreen 480=480 — `perclass2.txt`); hook-install count
unchanged (host group once: 4× MSHookMessageEx + 1×
MSHookFunction in `_ABInstallSpringBoardHooks` —
`hookcount2.txt`); re-parsing the BUILT SplitScreen dylib's
cfstrings finds all nine strings as `0x7d0` UTF-16 constants
with the original lengths 28/15/15/10/6/17/9/24/32.

New candidate (supersedes the §5/§10 build1 DEB
`d1502121…`): `project/packages/` sole file, SHA-256
`3b2283a84ad0c1d83c68203e65418a4dc0d8bb94d10b0732249ac81e34fb9b6c`,
949,244 bytes; parity restage `dpkg-deb -Zxz`,
Installed-Size 3528, data tar 202/202 entries, 0 differences
in mode/uid/gid/type vs the original. SplitScreen LC_UUID
`4c4c4473-5555-3144-a1fb-ea5c770eb2cc`; AppBridge unchanged
(`4c4c4413-5555-3144-a192-3f49022cb8b1`) — see the build2
addendum in `project/logs/fix-round/uuid-manifest.txt`.
DEVICE_TEST remains PENDING.

## 7. Portrait crash, literal-pointer sweep, Track 2 (build3, 2026-11-08)

### 7a. The Portrait crash — root cause and faithful fix

Device-log marker: signal 11 (SIGSEGV), fault address exactly
0x87f60, backtrace symbol `SCPHook_PortraitColumns +144`.

Instruction-level proof (full disassembly in
`project/logs/fix-round/regression3.txt`, reproduced on the
build2 binary in /tmp analysis and re-verified this round): the
rebuilt shared grid helper `SCPGridDimension` (static, no
exported symbol; in the previous build at VA 0x3e350 in the
analysis slice / 0x4ac70 in the build2 candidate) materialised
the constant at helper +52: `mov w8, #0x7f60; movk w8, #8, lsl
#16` → x8 = 0x87f60, then at 0x3e388 `ldr x8, [x8]` —
helper +56 in that slice, = PortraitColumns +156 — dereferenced
it as a pointer. The log's +144 is the backtrace symbolication
of the symbol-less static helper, whose nearest preceding named
symbol is `SCPHook_PortraitColumns`; all four grid hooks
(Portrait/Landscape × Columns/Rows) call the one helper and
fault identically.

Root cause: 0x87f60 is the ORIGINAL binary's VA of a
`__thread_vars` descriptor — a link-time address, meaningful
only inside the original image. The transcription copied it as
an absolute runtime pointer (`(*(void **)0x87f60)`), so the
first grid query dereferenced VA 0x87f60 in the rebuilt image,
where nothing is mapped there.

The faithful fix (SCPHomeHooks.m): a real
`static __thread BOOL SCPGridReentrancyGuard;` — the compiler
now emits a genuine TLV descriptor and the access goes through
it (adrp-relative; binary-proven in §7e). The fix also restores
the original's exception structure: @try/@catch around the
wanted getters (catch → return orig) and around the
NSSelectorFromString + objc_msgSend re-queries (catch → clear
guard, return orig), matching the original's catch pads at
0x5864 / 0x5880, the catch-path guard clear at 0x5898 and the
normal-path clear at 0x56f8. Original layout: TLS byte in
`__thread_bss` at 0x87f78, zero-initialised, one descriptor at
0x87f60 (24 bytes). Threshold correction: the comparisons are
unsigned in the original (0x5704–0x5710) — the rebuild now uses
(NSUInteger)cols<2 / rows<=1.

### 7b. Provenance

This defect class was NOT in GPT's TXT work order. It was
identified by GPT from the device log on 2026-11-08, and the
tree-wide sweep (§7c) is the systematic closure of that class.

### 7c. Tree-wide literal-pointer sweep

349 compiled files scanned; 619 code-only hex literals; 304
literals ≥0x1000 hand-classified. Result: exactly 2 literal
defects + 1 literal-free sibling, all fixed the same faithful
way (self-referential address keys / real TLS):

1. `SCPHomeHooks.m:74` — the 0x87f60 deref (§7a).
2. `ABInApp.m:280` — associated-object key `(const void
   *)0x3E9E4`. Original evidence `helper_698c.txt` @0x6a1c–
   0x6a20: the original computes the key PC-relatively and
   never dereferences it — an address-as-key only. Fix:
   `ABBlankInputViewKey = &ABBlankInputViewKey`.
3. Sibling (no literal): `SSStartupScreen.m:153–154` —
   `kSSClaimKey` / `kSSSplashKey` were uninitialised (NULL)
   statics, so both keys were NULL. Original passes slot
   addresses 0x3b1b0 / 0x3b158 (sub_a6c4 @0xa724 / 0xb530).
   Fix: self-referential initialisers, same pattern.

Audited CLEAN: the sibling icon hooks and
`SBIconImageInfoCompat` (32 B). Hook-count reconciliation:
the device note 'du 11 hook' counts checklist entries; the
tree has 16 install sites against 11 check-list entries — no
missing installer.

### 7d. Known divergences — DOCUMENTED, NOT fixed this round

1. `OMCCheckHooks(@"SplitScreen", nil)` in `__init_1` passes
   nil where the original passes a second selector list
   @0x80338. Diagnostic only: the self-check logs 'du 0 hook'
   instead of the original's 'du 10 hook'. No behavioural
   effect beyond the log line.
2. Forced-show log-prefix string at
   `SCPHomeVisibility.m:147` differs from the original's.
   Cosmetic only.

### 7e. Track 2 (Preferences)

- `OMCHSInstalled` typed-msgSend change CLEARED: the
  original's own BOOL helper `sub_24e0c` returns BOOL directly
  (no retain, no boolValue round-trip); the pristine
  performSelector: version was the divergent one. No change.
- Two format-arg defects in Prefs `OMCCommon.m` FIXED, each
  with original evidence:
  - `CHK_CRASH_AT`: the original passes
    sub_f6c0(date) + @"" at 0xcbd8–0xcc04 (the format is
    "%@%@"). The rebuilt 1-arg call let the second %@ read an
    uninitialised stack slot — crash-class, on the Send-Log
    path. Fix: pass `OMCDiagDateString(crash[@"date"])` + @"".
  - `CHK_PACKAGE_OK`: the original passes version + module
    count at 0xad24–0xad40. Fix: the module count is now
    passed as the second vararg.
- `OMCWhatsNewVersionToShow` rewritten to the original
  `sub_198c4` semantics exactly (492 B): flag=1 → nil unless
  data[@"1.0.3"] is an NSArray; flag=0 → the numeric-greatest
  array-valued key. The shipped WhatsNew.plist contains only
  "1.0.0", so +shouldShow is now NO, as in the original.
  CAVEAT: attribution of the Settings kick-back symptom to
  WhatsNew remains UNPROVEN — it is ranked suspect #1 only.
  Other suspects: onboarding auto-present; AppBridge
  injection into Preferences via the UIKit filter; a residual
  binary-only fault. Conviction requires a Preferences .ips.

### 7f. Build3 verification

Clean build exit 0, 0 `error:` lines
(`project/logs/fix-round/build3.log`). Binary regression
proof (`regression3.txt`): whole-__text mov/movk #0x7f60
count 2 → 0; guard accessed via the __thread_vars descriptor
(adrp x0,#0x72000; add x0,#0x278 → 0x72278; ldr x8,[x0];
blr x8); __thread_vars (0x72278, 0x18) and __thread_bss
(0x72290, 1 B) sections present (absent in build2);
SCPGridDimension decoded length == function-starts bound
(648 B, 162 insns, capstone no-skipdata). Per-class parity
unchanged (`perclass3.txt`): 62/66 exact, 0 classes missing
any selector, Prefs 743→745, SplitScreen 480=480, AppBridge
193=193, OMCAppBridgeAppsController 105=105. Hook count
unchanged (`hookcount3.txt`): one _ABInstallSpringBoardHooks,
4× MSHookMessageEx + 1× MSHookFunction, totals 17+1.
Aggregate diff (`diff3.txt`): 176 files, 168/168 non-Mach-O
byte-identical, 0 original defined symbols missing.

New candidate (supersedes build2 `3b2283a8…`):
`project/packages/` sole file, SHA-256
`7f2701d90327c1f89c23332338f6d8fbc6451b327c31d3f5e466e220dde39d74`,
949,352 bytes; parity restage `dpkg-deb -Zxz`,
Installed-Size 3528, data tar 202/202 entries, 0 differences
in mode/uid/gid/type vs the original. LC_UUIDs: AppBridge
`4c4c447b-5555-3144-a19a-149d961a4c11`, SplitScreen
`4c4c44e3-5555-3144-a18f-40c005308e1e` (uuid-manifest.txt
build3 addendum). Full investigation report:
`work/fix-round2/audit-portrait.md`.

**DEVICE_TEST = PENDING** for this build.

## 12. Settings-pane conviction + branch-fidelity round (2026-11-08)

Trigger: device discriminator — the original 1.0.3 pane opens normally on
the current device state; every rebuilt build ejected Preferences. Three
.ips reports (`work/prefs-ips/`, 18:12–18:14) convict the cell path:
EXC_CRASH SIGABRT, uncaught exception through
`-[PSListController tableView:cellForRowAtIndexPath:]` → OmniCarPrefs
+0x1CFA0 → `___forwarding___`. The offset is identified (LC_UUID
`d6ed4779-9950-39f0-9dcc-91cb156543d6` = portraitfix arm64) as the return
address of the `objc_msgSendSuper2` call inside our
`-[OMCRootListController tableView:cellForRowAtIndexPath:]` (IMP 0x1CF74,
80 B, structurally identical to the original's) — the throw is a direct
send inside PSListController's own cell creation, fed by specifier data
our construction supplied. The load-surface diff (libraries / symbols /
constructors / +load / classlists, Prefs + AppBridge) is CLEAN — the
defect was never in the load surface; AppBridge is exonerated for
Preferences (all 3 constructors bail there; `com.apple.Preferences` sits
in its in-app exclusion array). Full investigation:
`work/fix-round2/audit-prefs.md`; coverage: `prefs-cellpath.md`;
load surface: `prefs-loadsurface.md`.

### 12.1 Prefs — the convicted defect (device-proven cause)

- `insertFeatureSpecifiers` stamped the `@"cellClass"` property with
  `NSStringFromClass([OMCFeatureStatusCell class])` — a STRING. The
  original (disasm 0x16168–0x16184) stamps the Class object directly.
  PSListController consumes the property as a Class during cell creation
  → message to an NSString instance → forwarding →
  NSInvalidArgumentException → SIGABRT. Present in all three shipped
  rebuilt debs (binary proof: `_NSStringFromClass` call at portraitfix
  0x1B8C0; the original Prefs contains zero `NSStringFromClass`).
  FIXED: stamp `[OMCFeatureStatusCell class]`. Byte-verified in the new
  build: `_NSStringFromClass` absent from the built Prefs (stubs +
  imports); the Prefs binary hash changed.
- Specifier-surface coverage audit (systematic closure, two independent
  passes): every getter/setter/action/cellClass/detail named by all six
  bundle plists plus all programmatic specifiers, checked against our
  implementations with arity — ZERO further defects (the risk classes
  get/set/buttonAction/valuesDataSource are empty in every plist; all
  14 actions are implemented on the correct classes).

### 12.2 Prefs — further proven divergences fixed in the same pass

- Super-guard inversion ×4 (OMCRootListController +
  OMCFeatureListController, header + footer): ours guarded the
  `[super …]` call with `[super respondsToSelector:]`, which answers
  for self — including the subclass override — so it reads YES even
  when the superclass lacks the method and the super call then crashes.
  The original checks `[PSListController instancesRespondToSelector:sel]`
  (disasm 0x17328 / 0x173D4, 0x11118 / 0x111C4). FIXED to the base-class
  check. Causal status: the NEXT crash risk on the header/footer
  display path — NOT the recorded crash frame; kept separate.
- `OMCStyleHeaderFooter`: the original is `(UIView *, BOOL isHeader)`
  at 0x19300 — header textLabel 14pt UIFontWeightMedium, footer plain
  12pt, both secondaryLabelColor, detailTextLabel untouched. Ours had
  dropped the parameter and styled both at 13pt Semibold plus the
  detail label. RESTORED: signature, both branches, all 10 call sites
  (Root/Feature guarded methods; CardPage / AppBridgeApps / CarProfiles
  shims — the cast workarounds removed).
- Cell init style ×3 (OMCCells.m): all three originals force
  `UITableViewCellStyleValue1` (`mov w2, #1` before `objc_msgSendSuper2`
  — 0x15470 / 0x1B3A8 / 0x3613C); ours passed the incoming style
  through, leaving detailTextLabel nil so the refresh text (feature
  on/off, app count) could never render. RESTORED.
- `insertFeatureSpecifiers` stamps: the original stamps featureKey +
  featureDefault UNCONDITIONALLY from the first PSSwitchCell item,
  substituting kCFBooleanTrue for a missing `default` (0x16328–0x16398);
  ours guarded both. RESTORED (not triggerable with the shipped plists,
  which all declare `default: true` — fidelity fix).

### 12.3 AppBridge launch path (`audit-appbridge-launch.md`)

- Item 1 (source-proven signature defect): `ABSend1` (id-returning cast)
  wrapped the void `setDelegate:` — the original at 0xD518 calls and
  ignores any return. FIXED via a new minimal `ABSendV1` helper (none
  existed in the file; flagged here as an addition in the file's style).
- Item 2 (source-proven signature defect): the
  `_createSceneViewController` result was held via `ABSend0`; the
  original at 0xD200 discards it untouched. FIXED to `ABSendV0`; a
  runtime `method_getTypeEncoding` MILESTONE log was added on the launch
  path so the device log settles the return type definitively.
- Item 3(i) (transcription divergence, RESTORED): the original's 2.5 s
  fallback (0xBC44–0xC018) does loadWeakRetained → containment check →
  `revealPane:` → `pane.ready` stop → `setReady:YES` → post `ready`.
  Ours posted ready on weakPane-non-nil alone — no reveal, no ready
  flag, no containment. Restored verbatim in flow. This is a proven
  divergence from the original; as the explanation of the device
  video's black-screen-with-bubble it is SOURCE-PLAUSIBLE, NOT
  device-proven.
- Item 3(ii): the launch-callback missing-selector branch matched the
  original exactly (ABMissingSelector only; afterLaunch NOT invoked);
  logging only.
- Milestones added (`OMCLogWrite(@"AppBridge", …)`, each with bundle ID
  + pane pointer + ready source): `transaction-complete`,
  `process-launch-complete`, `revealPane` (launch-callback + timer).

### 12.4 SplitScreen branch restorations

(`audit-dockbutton.md`, `audit-splitbranches.md`, `audit-hooks-dismiss.md`)

- `rootDidLayout` (IMP 0x15984): ours returned early when inactive (the
  Dock button was never refreshed — the very button that enables split)
  and called refreshAppTab on the active tail. Original: publishBusy →
  inactive ⇒ tail-call refreshAppTab only; active ⇒ superview check →
  refreshHomeButton → appArea compare → log `vung app doi` → setFrame →
  relayoutAnimated:NO. RESTORED; the false VERIFIED comment rewritten.
- `refreshHomeButton` keep-check INVERSION (found by the callee pass):
  ours `bare == launcherBare`; original `bare != launcherBare`
  (0x41F10 eor / 0x41F28 tbz; inverse store 0x420D4). FIXED.
- `refreshAppTab` (IMP 0x36E04): ours raised tray / popupShield under
  independent conditions (it could raise the touch-blocking popupShield
  alone). Original, strictly: refreshHomeButton → if (!tray ||
  viewIsRaised:tray) return → raiseView:tray → raiseView:popupShield.
  RESTORED. Causal status: source-proven divergence; NOT proven as the
  cause of the device's intermittent touch episodes.
- `autoLaunchAttempt:` (IMP 0x44DC4): ours opened immediately when a
  root existed and retried forever (1.0 s then 1.5 s). Original: the
  counter is an `int` parameter; attempt ≤ 39 AND no root ⇒ 1.0 s retry
  block (re-invoke only); root OR attempt > 39 ⇒ a DIFFERENT terminal
  block at 1.5 s (logs `CarSplit: tu mo split khi cam xe`, calls
  openRememberedPairForConnect, no root re-check). RESTORED, including
  the `(int)attempt` header.
- `dashboardInvalidated` (Item D, IMP 0x22724): restored the active
  branch's final clears self.slots / self.fractions / self.dividers =
  nil (0x229F8 / 0x22A04 / 0x22A10) and dragTarget = -1 (0x22958; ours
  had 0).
- `dismissBaseViewController` hook (Item C, dump 0x66DC): all four GPT
  items confirmed (base VC read on the receiver self, not the global
  root; close only when base == nil — ours inverted; closeGoingHome:NO
  — ours YES; refreshAppTabSoon AFTER the orig call on every path,
  including split-inactive) plus FOUR more found in the same read
  (removeAppTab unconditional before orig; two-@try exception structure
  with distinct tags; the log wrapped in stringWithFormat:;
  SCPMissingSelector takes the literal name string). Whole flow
  RESTORED.
- Causal status for Item C, Item D and all of §12.4: source-proven
  divergences; device impact to be proven by the acceptance chain
  (open split → Home → reopen → disconnect → reconnect).
- Pattern sightings, recorded NOT fixed (report-only): SCPCarSplit.m
  `closeGoingHome:` inactive return skipping the trailing
  refreshAppTabSoon; `installIconLongPress` 2 s throttle return;
  `switchToLayout:` no-change return. (`audit-dockbutton.md`.)

### 12.5 NEW AUDIT AXIS — branch fidelity (process record)

The "VERIFIED" labels in this reconstruction were checked for
presence/signature, not for branch structure and call order. Every
defect in §12.2–§12.4 sat under such a label. Branch fidelity (branch
conditions, early-return placement, call order, and argument values on
each branch) is now a named audit axis, alongside the hook-contract
axis (§9) and the baked-address / literal-pointer axis (§11). No
tree-wide branch audit was launched this round; the axis is recorded so
that future verification claims state their axis explicitly.

### 12.6 Completeness claim — WITHDRAWN

Behavioural completeness is WITHDRAWN as a claim for this
reconstruction. Selector/census parity, hook-contract checks and the
specifier-surface audit stand as measured, but they do not sum to
behavioural equivalence. Branch-fidelity verification has now been
performed for exactly: the Prefs open/cell-path functions (`-specifiers`,
`insertFeatureSpecifiers`, `tableView:cellForRowAtIndexPath:`, the
`willDisplayHeaderView/FooterView` methods, `OMCStyleHeaderFooter`, the
three custom cell inits), the AppBridge launch-path functions
(`setupLiveAppViewForPane:` and its send helpers, the launch completion
callback, the ABHostLaunch 2.5 s fallback block), and the SplitScreen
functions `rootDidLayout`, `refreshAppTab`, `refreshHomeButton`,
`autoLaunchAttempt:`, `dashboardInvalidated`, and the
`dismissBaseViewController` hook. Everything else remains
branch-UNVERIFIED. Acceptance proceeds by runtime-path testing against
the original's observed behaviour.

### 12.7 Build + verification (this round)

Clean local build (`project/logs/fix-round/build5.log`) exit 0.
`diff_payload` (`diff5.txt`): 176 = 176 files; non-Mach-O 168/168
byte-identical; per-binary methods App 6=6, AppBridge 193=193,
SplitScreen 480=480, Prefs 743→745 (known additive pair), SpeedBubble
277→278, StartupScreen 173→175; original defined symbols missing: 0 in
every binary; control diff = Installed-Size only (computed). Parity
restage: 202/202 tar entries, 0 uid/gid/mode diffs vs the original.
Candidate (SOLE file in `project/packages/`):
`com.anlai.omnicar_1.0.3_iphoneos-arm64-rebuilt.deb`, 949,828 B,
SHA-256 `4d794d087689b74d58e244ec6ce206d48c6fad8ddbc40bfe4cbface5dde4a7b6`
(local arm64 build; the FAT arm64+arm64e candidate comes from the macOS
CI run on the pushed tree, as in prior rounds).

**DEVICE_TEST = PENDING**: first gate = Settings → OmniCar opens (the
§12.1 conviction); then re-enable the rescue-disabled features in the
pane (device-side recovery step, operational not code); acceptance per
the round-1 protocol.

## 13. Consolidated-fix round (2026-11-08) — GPT governing file, B-gates, ABI, §F logging

This round ran under GPT's consolidated fix file
(`OmniCar_Muse_Consolidated_Fix.txt`), which superseded the piecemeal
briefs; the confirmed patch (A1–A6) was extracted to
`work/fix-round2/OmniCar_Confirmed_Fixes.patch` and reconciled hunk by
hunk against the current tree (the team had applied most hunks ahead
of the file's arrival; reconciliation verified post-images, it did not
blindly git-apply). Master ledger: `work/fix-round2/gpt-checklist.md`.

### 13.1 Reconciliation outcomes (A1–A6)

A1 cellClass: already exact. A2 super-checks: aligned to the patch's
inline form. A3 rootDidLayout / A4 refreshAppTab: flow/bodies match
the post-images (A4's signature keeps our accurate VERIFIED comment
where the patch's line is bare — behaviour-neutral). A5 hook:
intent-exact; two behaviour-neutral textual deltas vs the hunk, both
dump-backed on our side (SCPMissingSelector literal name string per
orig 0x6770; close log in stringWithFormat: per orig 0x6798). A6: both
halves — dashboardInvalidated (§12.4) AND closeGoingHome: (pane.vc /
pane.bundleID now nilled unconditionally, orig 0x2174c→0x2177c).

**Supersession:** §12.2's OMCStyleHeaderFooter restoration is REVERTED
by GPT's §D decision — the (UIView*, BOOL) parameter is a RECORDED
FIDELITY GAP, explicitly not restored this round; the 1-arg calls of
the §A2 hunks stand and the gap is noted in OMCCommon.h/.m. §12.2's
other items (guards, cell inits, stamps) are unaffected.

### 13.2 Hard gates B1/B2 — both CLOSED from the original binary

- **B2 autoLaunchAttempt:** — independent full re-dump
  (`b2-block-dump.md`): 14/14 elements MATCH the restored code,
  0 divergences.
- **B1 ensureContainer** — full touched-block dump
  (`b1-block-dump.md`: signature `v32@?0{CGPoint=dd}8@"UIView"24`,
  one weak-self capture, real selectors hideBarsForTouchOn: /
  setFocusedSlot: / flashFocusOnPane: — no closePopups/focus:) +
  restoration (`audit-b1-restore.md`): parent =
  baseContainerView.superview (fallback root.view), FRESH
  SCPCarSplitView + FRESH slots/fractions/dividers on every entry,
  setTouched: block, addSubview on the parent, raise, loggedArea=NO,
  frame = appAreaInParent:, container log, YES whenever a root
  exists. G8 confirms setTouched:/setDividers:/… in the shipped
  function's selector vocabulary and the block invoke's vocabulary
  (slots/floatPane/focusedSlot/paneCount/hideBarsForTouchOn:).

### 13.3 ABI (§C)

C1: all 35 ABSend* call sites classified against the original dumps —
35 OK, 0 must-fix, 0 uncertain (`audit-abi-c.md`). C3:
ABInvokeIdentityGetter — the original adapter (0xDEF0) uses a raw
slot + explicit retain with NO encoding check; ours now mirrors that
shape plus GPT's '@'/pointer-length gate, labelled in-code as
hardening beyond the binary. C2: ABSendV0 stands on the original's
treatment (0xD200 discards untouched); the discard alone does not
prove void — the definitive encoding is the candidate's runtime
MILESTONE type-encoding log, and an '@' result reverts the contract
on that evidence (recorded residual, by design).

### 13.4 §F diagnostic logging (candidate-only, rate-limited)

Settings (`audit-flog-settings.md`): specifier-build line (controller,
total, per-feature plist/index + RUNTIME CLASS of the cellClass value)
once per build; cell-creation exception trap (controller/section/row/
specifier, exception name/reason/stack) that logs and RETHROWS. The
Prefs module had no OMCLogWrite (not declared, not linked, absent
from the original binary), so a module-local embedded copy was added
(OMCCommon.h/.m) following the per-binary pattern — flagged here as a
required extra touch. Dock (`audit-b1-restore.md` Part 2): gate
outcomes on create/remove/host-change only; the remove path names the
failed gate (root nil / feature disabled / tabParent nil). App
(`audit-flog-app.md`): request / scene-attached / teardown milestones
added; the five prior milestone formats are byte-untouched.

### 13.5 Spot-audit trio (kept on the books, now closed)

S.1 refreshHomeButton De Morgan: SAME SITE as the §12 fix — the spot
audit misread (w26 is the mismatch flag; skip @0x41F28); the applied
condition (skip iff sizeOK && bare != launcherBare) is correct;
19-row table in `audit-spotfold.md`. S.2 hostSolo: tabParent guard,
second appbridge.frame post, refreshAppTabSoon tail restored; bonus
divergence fixed — setTrayHidesBridge:NO (orig 0x3FA70). S.3
pushHostFramesLive: unconditional publishShield → refreshShieldHoles
tail restored. The remaining 11 spot-audit targets
(`audit-branch-spot.md`) stay queued for the next round, as does the
barTimer observation from §12.4.

### 13.6 Build + candidate

Clean local build build6 (an earlier attempt died on a VM /usr
rollback that removed ldid; restored from the workspace backup +
shim, smoke-tested, rebuilt — `build6-failed-ldid-rollback.log` kept).
diff_payload (diff6.txt): 176=176 files, resources 168/168
byte-identical, control diff = Installed-Size only. G8 in-artifact
verification (`project/logs/fix-round/g8-build6.txt`): §F/B1
discriminator strings present in the candidate and absent from the
build5 candidate; function-level selector vocabularies confirm the
A/B restorations in shipped code; _NSStringFromClass's only call
sites in the candidate Prefs are the three [GPT-F] diagnostic lines
(insertFeatureSpecifiers is clean). Per-binary UUIDs recorded in the
same file. Parity restage 202/202, 0 diffs. Candidate (SOLE file in
project/packages/): `com.anlai.omnicar_1.0.3-rebuilt-consolidated_iphoneos-arm64.deb`,
952,700 B, SHA-256
`c1fc85c75f77ff8ba2787200855cc31120d432c0e7169e9f5058eda11a5c8092`
(local arm64; supersedes the build5 candidate 4d794d08…; the FAT
build + push are the parent's CI steps).

**DEVICE_TEST = PENDING** — acceptance per §H of the consolidated
file (Settings open + scroll + sub-pages; Dock button present and
tappable with split off; Maps + phone app panes; keyboard/layout;
Home/reopen; disconnect/reconnect cleanliness; runtime log + IPS with
matching UUIDs).

## 14. Arity + StartupScreen policy round (2026-11-08) — build9, arityfix candidate

Two device-proven defects, one integration re-run (W-INT3). Fix
workers: W-FIX1 (arity), W-FIX2 (StartupScreen policy), W-FIX3
(nullability attempt, superseded), W-FIX4 (spelling split — the
shipped form). Prior integration attempts: build7 BLOCKED
(-Wnonnull, CarProbe) and build8 BLOCKED
(-Wnullability-completeness, Core) — see
`work/fix-round2/integration-arityfix.md` /
`integration-arityfix2.md`. This section records build9.

### 14.1 Defect 1 — OMCPref arity (SplitScreen SIGBUS)

Causal label: **device-proven by UUID-matched .ips**. The shipped
reconstruction declared `id OMCPref(NSString *key);` (1-arg) in
SCPShared.h while the linked definition is the 2-arg shared-core
body (OMCCommon.c:122, `return v != nil ? v : def;`). The two
1-arg call sites — SCPPrefs.m:14 (SCPObjectForKey) and :16
(SCPStringForKey) — left x1 = register garbage as the default
value. Device evidence: 9 crashes; the fault pointer is the
`@"autoLaunch"` __cstring at shipped slice 0x54AD2 — the garbage
x1 dereferenced on the +[SCPPrefs autoLaunch] path.

Fix (W-FIX1): SCPPrefs.m:14,16 → `OMCPref(key, nil)`; every
OMCPref declaration in the tree unified to 2 parameters (28
prototypes, §14.4 for the spelling form). Same-pattern decl/def
mismatch found by the tree-wide audit and fixed in the same
pass: **OMCTr** — OMCCore.h:121 declared 1-arg against the 2-arg
definition (OMCCommon.c:1601); declaration unified to
`NSString *OMCTr(NSString *viText, NSString *enText);` (no call
site exercised the bad arity). Definitions were not edited.

### 14.2 Defect 2 — StartupScreen splash association (SIGSEGV)

Causal label: **device-proven by UUID-matched .ips**. The
reconstruction set the splash association with
OBJC_ASSOCIATION_ASSIGN, leaving a dangling splash pointer.
Original-binary evidence (W-FIX2, full sweep of all 6
association sites, capstone no-skipdata over LC_FUNCTION_STARTS
bounds, 121,608 decoded bytes == __text size): the original
uses policy 1 (OBJC_ASSOCIATION_RETAIN_NONATOMIC) at ALL THREE
set sites — splash attach `mov w3, #1` @0xb540 → call 0xb544;
claim attach @0xa75c → 0xa760; nil-clear @0x71c0 → 0x71c4.

Fix (W-FIX2, SSStartupScreen.m only): all three sites →
OBJC_ASSOCIATION_RETAIN_NONATOMIC; SSScreenGone gained the
original's nil-screen guard (cbz @0x8838) and a strong local
held across tearDown (orig x19 hold @0x8858–0x8864); teardown
order and the identity-before-removal check already matched
the original and were kept. No OBJC_ASSOCIATION_ASSIGN remains
in the file.

### 14.3 Prototype-spelling deviation — final form (flagged for GPT's review)

> §1's verbatim prototype cannot be applied uniformly — build7
> (-Wnonnull inside NS_ASSUME_NONNULL headers) and build8
> (-Wnullability-completeness in annotation-free headers) each
> disprove one uniform spelling; shipped form unifies ARITY
> (2 params) everywhere with nullability spelling following
> each header's NS_ASSUME_NONNULL structure; ABI unchanged —
> flagged for GPT's review

Shipped form (W-FIX4, 28 prototypes, all arity 2, cmp-verified
14/14 pairs): plain
`id OMCPref(NSString *key, id defaultValue);` in annotation-free
files (OMCCommon.h, OMCCore.h, SSStartupScreen.h + 6
annotation-free .m sites); annotated
`id _Nullable OMCPref(NSString *key, id _Nullable defaultValue);`
in the 5 NS_ASSUME_NONNULL headers (SCPShared.h, SCPCommon.h,
SCPHomeCommon.h, OmniCarCarProbe.h, AppBridgeB.h).

### 14.4 Listed — suspicious, NOT fixed (verbatim from fix-arity-wfix1.md §4)

1. **OMCLogoMeshImage cross-binary arity**: OMCCommon.h:188 / def
   OMCCommon.c:1667, CarProbe.h:142 / def .m:1619, SpeedBubble
   SPPBubble.m:25 all take `(int style)`; Prefs OMCCommon.h:198 declares
   `UIImage *OMCLogoMeshImage(void)`, def OMCCommon.m:518, sole call
   OMCCommon.m:393 `OMCLogoMeshImage()`. Each TU is internally consistent
   (decl=def=calls); these are separate per-binary reconstructions, so
   unifying would break Prefs. Return type also differs (id vs UIImage*).
2. **OMCStyleHeaderFooter vs original binary**: Prefs decl (OMCCommon.h:109),
   def (OMCCommon.m:440) and all 6 call sites are 1-arg, but the source
   itself records the original as 2-arg `(UIView *, BOOL isHeader)`
   (OMCCommon.m:435-439) — a documented fidelity gap deliberately deferred
   per GPT consolidated §D. No TU-internal mismatch; left per that deferral.
3. **OMCCarWireless return-type spread** (arity 0 everywhere): `int`
   OMCCommon.h:90 + def OMCCommon.c:226 + CarProbe.h:122/def .m:1007;
   `BOOL` OMCCore.h:58 + def OMCCore.m:77; `NSInteger` AppBridgeB.h:98
   (no B-local def; B links the AppBridge binary's core copy).
4. **OMCCarLaunchInfo param type/semantics**: SCPShared.h:60 declares
   `id OMCCarLaunchInfo(NSString *bundleID)` vs def `id (id application)`
   (OMCCommon.c:497). Arity 1=1, but SplitScreen call sites disagree on what
   the argument IS: SCPCarSplit.m:548 passes a bundleID string, :1319 and
   :2004 pass an app-info object. One side is a reconstruction error;
   not an arity defect, not touched.
5. **OMCMissingSelector 2nd-param type**: OMCCommon.h:135/def .c:472 take
   `id object`; CarProbe.h:109/def .m:849 take `Class cls`. Arity 3=3,
   each copy internally consistent.
6. **SCPBridgedChosenApps return type**: extern decl in
   SCPCarSplit+Picker.m:42 says `NSArray *`, definition in SCPCarApps.m:230
   returns `NSSet<NSString *> *`, SCPShared.m:120 declares it `id`. Arity 0.
7. **Stale evidence comment**: SCPPerfTelemetry.m:46-49 still says
   "(SCPShared.h declares a one-argument OMCPref…)" — true of the pre-fix
   tree and kept as the binary-evidence note; the prototype line below it
   was unified. Coordinator may annotate it as fixed-by-W-FIX1.

### 14.5 Build9 + §3 in-artifact verification (on the re-extracted candidate)

Clean build (`project/logs/fix-round/build9.log`): exit 0,
0 `error:` lines, 140 `warning:` lines. Per-class parity
(`perclass9.txt`): 62/66 exact, 0 selectors missing, 4
additive-only exceptions (SPPBubble +1; SSStartupView/
StartupScreen +2; OMCSplitScreenController +1; SSStartupView/
Prefs +1), Prefs 743→745. diff_payload (`diff9.txt`): 176=176
files, 168/168 non-Mach-O byte-identical, 0 original defined
symbols missing, control diff = Installed-Size only (6160 →
3544). Parity restage: `dpkg-deb -Zxz`, data tar 202/202
entries, 0 differences in mode/uid/gid/type vs the original.

§3 (capstone, NO skipdata; every binary's decoded bytes ==
its LC_FUNCTION_STARTS bounds == __text size, 0 bad functions
in all 8; full output `project/logs/fix-round/g8-build9.txt`):

- (a) SplitScreen arm64 — PASS. _OMCPref is a defined symbol
  in this binary (target 0x4df5c); 32 call sites, every one
  preceded by an explicit x1 write. The two fixed wrappers:
  +[SCPPrefs autoLaunch] (fn 0x1ce3c, SCPObjectForKey inlined):
  `0x1ce48: adr x0, #0x66de8` (cfstring "splitScreenAutoLaunch")
  → `0x1ce50: mov x1, #0` → `0x1ce54: bl #0x4df5c`.
  SCPStringForKey (sub_1ccb8; tail-called by +lastLeftApp /
  +lastRightApp): `0x1ccc4: mov x1, #0` → `0x1ccc8: bl #0x4df5c`.
  x1 is EXPLICITLY set to nil immediately before each fixed
  call. Defect 1 is fixed and built (§3-verified).
- (b) StartupScreen arm64 — PASS. Exactly 3
  _objc_setAssociatedObject sites in the binary (stub
  0x2479c), each with w3 == constant 1 immediately before:
  nil-clear in SSClearSplashAssociation:
  `0x75ec: mov w3, #1` → `0x75f0: bl #0x2479c`;
  claim attach in SSHandleCarScreen:
  `0x76c4: mov w3, #1` → `0x76c8: bl #0x2479c`;
  splash attach in SSHandleCarScreen:
  `0x8578: mov w3, #1` → `0x857c: bl #0x2479c`.
  Defect 2 is fixed and built (§3-verified).
- (c) Regressions — PASS. Prefs: _NSStringFromClass has
  exactly 3 call sites in the candidate, all inside the
  [GPT-F] diagnostic functions (-[OMCRootListController
  specifiers] ×2, -tableView:cellForRowAtIndexPath: ×1);
  calls inside -insertFeatureSpecifiers: 0 — the convicted
  cellClass path is clean. SplitScreen: the string
  `[GPT-F] Dock gate` is present; -[SCPCarSplit
  ensureContainer] selector vocabulary (23 selrefs) includes
  setTouched: and setDividers:. AppBridge: 8 distinct
  MILESTONE strings present (request, transaction-complete,
  process-launch-complete, revealPane ×2, teardown,
  scene-attached, type-encoding).

### 14.6 Candidate + UUID manifest + tree-state manifest

Candidate (SOLE file in `project/packages/`; supersedes the
build6 consolidated candidate `c1fc85c7…`, removed from
packages/ only after this candidate verified; it remains in
handover history):
`com.anlai.omnicar_1.0.3-rebuilt-arityfix_iphoneos-arm64.deb`,
952,864 B, SHA-256
`3c6faebdfb5e6aa75a0b20f8a42cfe699e70de2fd5efca120e2d0afa650f328d`.
`ar t` members: debian-binary, control.tar.xz, data.tar.xz
(xz discipline held; no zst).

Per-binary LC_UUID (arm64, candidate):

| Binary | LC_UUID | Size |
|---|---|---|
| OmniCar | 4c4c4450-5555-3144-a1a3-58843b0f2ea6 | 70,064 |
| OmniCarCore.dylib | 4c4c4462-5555-3144-a1fd-68112de02120 | 130,640 |
| OmniCarAppBridge.dylib | 4c4c44c5-5555-3144-a125-1d7128382bdf | 291,232 |
| OmniCarCarProbe.dylib | 4c4c44cf-5555-3144-a10b-60b43fdf44ed | 112,352 |
| OmniCarSpeedBubble.dylib | 4c4c4432-5555-3144-a1cc-e6285f206b71 | 294,064 |
| OmniCarSplitScreen.dylib | 4c4c44d3-5555-3144-a105-afe238d5af17 | 537,664 |
| OmniCarStartupScreen.dylib | 4c4c449a-5555-3144-a111-bd9deadd1500 | 299,712 |
| OmniCarPrefs | 4c4c4451-5555-3144-a182-1d4b9c7979c6 | 605,584 |

Tree-state manifest — SHA-256 of every source file changed
this round across W-FIX1/2/3/4 (16 files × 2 trees; every
src/project pair byte-identical at manifest time):

```
a93389cde04df49f3a65c9bd514d573d1ce5e5055757407c0809cd5cd681ddbd  src/SplitScreenA/SCPShared.h
a93389cde04df49f3a65c9bd514d573d1ce5e5055757407c0809cd5cd681ddbd  project/OmniCarSplitScreen/SCPShared.h  (mirror; cmp IDENTICAL)
83def51fb0a31c6b7b7ed0493717bc6ec7dec366cb3eb7eb124dffa88976260b  src/SplitScreenA/SCPPrefs.m
83def51fb0a31c6b7b7ed0493717bc6ec7dec366cb3eb7eb124dffa88976260b  project/OmniCarSplitScreen/SCPPrefs.m  (mirror; cmp IDENTICAL)
d67404edd5dd4002fe46dd83d1e30592c6853583a75157384a04ec0537e7bd10  src/SplitScreenA/SCPPerfTelemetry.m
d67404edd5dd4002fe46dd83d1e30592c6853583a75157384a04ec0537e7bd10  project/OmniCarSplitScreen/SCPPerfTelemetry.m  (mirror; cmp IDENTICAL)
34e363e9441fe43ba120c7f8362bb39453c51b4460faeacbbb712f1935b1c163  src/SplitScreenA/SCPSessionCore.m
34e363e9441fe43ba120c7f8362bb39453c51b4460faeacbbb712f1935b1c163  project/OmniCarSplitScreen/SCPSessionCore.m  (mirror; cmp IDENTICAL)
51e2c242cb4577f4458aed3b14b5dba399d269d03c0a5361acfcb07d3715c489  src/OMCCommon/OMCCommon.h
51e2c242cb4577f4458aed3b14b5dba399d269d03c0a5361acfcb07d3715c489  project/OMCCommon/OMCCommon.h  (mirror; cmp IDENTICAL)
26f0c07af7f095ef230d1167b00bf3695119aefba3b40e56d9996f4078ef0b11  src/SplitScreenB/SCPCommon.h
26f0c07af7f095ef230d1167b00bf3695119aefba3b40e56d9996f4078ef0b11  project/OmniCarSplitScreen/SCPCommon.h  (mirror; cmp IDENTICAL)
2acb456826709daf130bd76f6b7ebe546747975800e24fd6f172fbe17fc1cb4b  src/SplitScreenC/SCPHomeCommon.h
2acb456826709daf130bd76f6b7ebe546747975800e24fd6f172fbe17fc1cb4b  project/OmniCarSplitScreen/SCPHomeCommon.h  (mirror; cmp IDENTICAL)
5a4656277c33bd68c0a6e49b45a109103811591996a86d47b5e15ce08d67293f  src/CarProbe/OmniCarCarProbe.h
5a4656277c33bd68c0a6e49b45a109103811591996a86d47b5e15ce08d67293f  project/OmniCarCarProbe/OmniCarCarProbe.h  (mirror; cmp IDENTICAL)
a7ddd17ab6ec0b5f28b793a0f0a5bf26a83e403a28fa5b2dda776757589fbd10  src/StartupScreen/SSStartupScreen.h
a7ddd17ab6ec0b5f28b793a0f0a5bf26a83e403a28fa5b2dda776757589fbd10  project/OmniCarStartupScreen/SSStartupScreen.h  (mirror; cmp IDENTICAL)
b7785835c250b2e27f501cd678145cc11ae6ba9d9eec7de904d68fa70cf8958e  src/StartupScreen/SSStartupScreen.m
b7785835c250b2e27f501cd678145cc11ae6ba9d9eec7de904d68fa70cf8958e  project/OmniCarStartupScreen/SSStartupScreen.m  (mirror; cmp IDENTICAL)
9e8d89998452fef8117090ea45b0ca8e44099934b282a32ed834999f3286a311  src/AppBridgeA/src/OMCCore.h
9e8d89998452fef8117090ea45b0ca8e44099934b282a32ed834999f3286a311  project/OmniCarAppBridge/OMCCore.h  (mirror; cmp IDENTICAL)
d5be6b4d22b91ac3c195fadd083fdf2fc0d42daa4fe052d515c66001e3574dae  src/SpeedBubble/SPPPrefs.m
d5be6b4d22b91ac3c195fadd083fdf2fc0d42daa4fe052d515c66001e3574dae  project/OmniCarSpeedBubble/SPPPrefs.m  (mirror; cmp IDENTICAL)
073d9b3a54ee988b9ed27bd78dceac50cb792569ad78fb6b2500bc99c7c46de7  src/AppBridgeB/AppBridgeB.h
073d9b3a54ee988b9ed27bd78dceac50cb792569ad78fb6b2500bc99c7c46de7  project/OmniCarAppBridge/AppBridgeB.h  (mirror; cmp IDENTICAL)
0afd0a87320aee77ad7f56b15e6d6bb8a4a4261b18cdb4df700b461d367d75c1  src/AppBridgeB/ABHostBMethods.m
0afd0a87320aee77ad7f56b15e6d6bb8a4a4261b18cdb4df700b461d367d75c1  project/OmniCarAppBridge/ABHostBMethods.m  (mirror; cmp IDENTICAL)
7a736ea362eefdf4d93041b8e5c0d77fa8dec9760ab3a6f836d909e437bdda03  src/AppBridgeB/ABHostGeometry.m
7a736ea362eefdf4d93041b8e5c0d77fa8dec9760ab3a6f836d909e437bdda03  project/OmniCarAppBridge/ABHostGeometry.m  (mirror; cmp IDENTICAL)
2492af2be2a8a2293a6c0536fc34447ede24300b6f50889717811902f66e6d51  src/AppBridgeB/ABKeyboard.m
2492af2be2a8a2293a6c0536fc34447ede24300b6f50889717811902f66e6d51  project/OmniCarAppBridge/ABKeyboard.m  (mirror; cmp IDENTICAL)
```

**DEVICE_TEST = PENDING.** No build9 candidate has run on a
device; the two defects are fixed and built where §3
verified them, and nothing stronger is claimed.

---

## §15 — Gatefix round (2026-11-08): the isCarPlayApp: gate was dead on device

Trigger: the arityfix candidate (§14) ran on device (session
21:56–21:59, log `work/device-log-20261108-2156-full.log`). No crash —
CarPlay pid 29320 survived the whole session, 0 signal/CrashGuard
lines (§14's two defects stay fixed). But EVERY app open was rejected
at the gate: 10× `CarSplit: <bundle> khong co giao dien CarPlay ->
bo qua` including com.apple.Music, a real CarPlay app; 0 MILESTONE
lines (AppBridge was never reached). Two THIEU METHOD lines frame
the cause: 21:56:41.302 `LSApplicationWorkspace khong co
applicationInfoForBundleIdentifier:` and 21:56:52.469
`LSApplicationWorkspace khong co defaultWorkspace`. Divider drags
in the same session logged fraction totals 0.33/1.33 and 0.50/1.17.
GPT's convictions and the team's independent dump investigation
agree on every point below; each fix cites the original dump.

### Convictions and fixes

1. **(a) The app-info receiver was fabricated — ROOT CAUSE.**
   `SCPShared.m`'s `SCPDefaultWorkspace()` (self-labelled INFERRED)
   sent `defaultWorkspace` to LSApplicationWorkspace and delivered
   its instance to `applicationInfoForBundleIdentifier:`. The
   original `sub_4672c` (dump `src/SplitScreenC/disasm/sub_4672c.txt`;
   the VA was also re-disassembled from the payload dylib, 58/58
   lines identical) never touches LSApplicationWorkspace:
   `0x4673c` loads class UIApplication, `0x46740` sends
   `sharedApplication`, `0x46754` builds
   `NSSelectorFromString(@"sharedApplicationLibrary")`, and the
   returned **FBSApplicationLibrary** is the object `sub_e324`
   (`disasm/sub_e324.txt`, selector cfstring @0x7a5e0) sends
   `applicationInfoForBundleIdentifier:` to. Device corroboration:
   the session's own DIAG lines list FBSApplicationLibrary's methods
   including `applicationInfoForBundleIdentifier:` (21:56:43.5xx),
   and GPT's log cross-check found the same. FIXED: `SCPDefaultWorkspace`
   is gone; a new `SCPAppLibrary()` in SCPShared.m transcribes
   sub_4672c including its double `respondsToSelector:` test (first
   failure returns nil silently, second logs via SCPMissingSelector
   — the sub_17d84 pattern), and `SCPApplicationInfoForBundle` calls
   it. Header comment at SCPShared.h corrected (it had even promoted
   the fabrication to "VERIFIED").

2. **(d) SCPIsHostedApp had an added nil-info gate and a missing
   branch.** Dump `disasm/sub_101bc.txt`: `0x101e0` feature gate,
   `0x101f0` injected → YES, `0x10204–0x10218` sub_e324 + sub_ffb4,
   `0x10228` ffb4 YES → return NO (@0x1022c); ffb4 NO → `0x1024c`
   sub_48864 + `containsObject:`. The reconstruction had inserted
   `if (!SCPApplicationInfoForBundle(bundleID)) return NO;` — with
   defect 1 making info always nil, the hosted branch was dead too
   (chosen iPhone apps were rejected despite the AppBridge list).
   FIXED: the nil gate is removed and the ffb4→NO branch restored.
   The sub_48864 comment was also corrected: the set is chosen ∩
   installed (LSApplicationWorkspace `allInstalledApplications`,
   ~60 s cache), which `SCPBridgedChosenApps()` in SCPCarApps.m
   already implements.

3. **(e) displayNameFor:'s fallback used the wrong receiver.**
   `SCPCarSplit.m` sent `defaultWorkspace` to a fresh
   `LSApplicationWorkspace` *instance* (`[... new]`), which can
   never answer a class method — the source of the 21:56:52.469
   THIEU METHOD line (traced through the loader path:
   openAppsInOrder → showLoaderInPane: → displayNameFor:). Original
   `-displayNameFor:` (IMP 0x1029c, dump
   `disasm/-SCPCarSplit_displayNameFor_.txt`): fallback @0x10354 is
   `objc_getClass("LSApplicationProxy")` and the guarded CLASS
   method `applicationProxyForIdentifier:` sent straight on the
   Class (@0x10380–0x1039c), then guarded `localizedName`. FIXED by
   transcription; no workspace, no `new`.

4. **Not defects (verified, left alone):** the sub_ffb4 predicate
   `SCPAppHasCarPlayUI` matches the original instruction-for-
   instruction (re-disassembled 0xffb4–0x101bc: 4 bundle exclusions,
   injected check, silent carPlayDeclaration gate, isHidden,
   !presentsFullScreen) — it was simply starved of input by defect
   1. The SCPGuardedSend guard pattern is sound on Class receivers.
   Only the misleading comment above `isCarPlayApp:` ("INFERRED:
   checks scene/role keys") was corrected.

5. **Fractions were seeded as [ratio, 1.0] in two places.** Original
   openPairLeft:right: (IMP 0x183a8) computes `fsub 1.0 − ratio`
   @0x184c4; openSetupLayout:apps: (IMP 0x3ab7c) the same @0x3ad2c.
   FIXED at SCPCarSplit.m (both trees): `@[@(ratio), @(1.0 - ratio)]`.

6. **openPairLeft:right: branch structure restored** (IMP 0x183a8):
   already active → `setPaneCount:2` only (@0x18440); not active →
   `activateWithCount:2` and STOP when it returns NO (@0x18450,
   cbz @0x18454). The pair ratio is computed only when both bundles
   are non-nil (@0x18458/0x1845c) and assigned only inside
   [0.2, 0.8] (fcmp against __const 0x6f078/0x6f080, read directly
   from the binary). The reconstruction had called setPaneCount AND
   activate unconditionally in the inactive branch, ignored the
   activation result, and assigned the ratio unconditionally.

7. **openSetupLayout:apps: branch structure restored** (IMP
   0x3ab7c): not-active path returns WITHOUT opening apps when
   `activateWithLayout:` returns NO (@0x3abf0). The pair ratio now
   applies only when layout == 2 (@0x3abf4), apps.count >= 2, both
   first elements are NSString (@0x3ac38/0x3ac80), and the ratio is
   in [0.2, 0.8] (@0x3ace8/0x3acf8).

8. **Layout-panel choice-button geometry was transcribed scrambled**
   (the "two stacked tile layers" in the 21:56 video). The visible
   surface is the layout PANEL, not the app picker (no picker-sheet
   line exists in the session log). Original dump
   `rem2_showLayoutPanelForApp.txt`: button frame
   `(42 + j*84, runningY, 84, 56)` (sp+0x178=42 @0x386bc,
   sp+0x120=84 @0x386c0, setFrame: @0x389a0, height 56.0 @0x38994);
   glyph centre (42, 28) @0x38fc4; stride 84 also in frameW
   (@0x38344: 104 + 84·n after MIN) and contentSize (width taken
   from [sp+0x28] @0x394f0 = the same 104 + 84·n — an investigator's
   tentative "70 + 84·n" reading of sp+0x60 was re-checked against
   the dump and NOT used; that slot feeds another element); innerW
   = 42 + 84·n + 2 @0x386c4. The reconstruction had
   `CGRectMake(41 + j*88, Y, 56, 41)` — the original's height (56)
   used as width and its x-offset (≈42) as height — so the 73×40
   glyph overflowed its 56×41 button outline by (+13, +7.5) from
   centre, exactly the offset double-image on video. FIXED at five
   points in SCPCarSplit+Panel.m (frame, glyph centre, frameW,
   innerW, contentSize). The close path (closePopups →
   collapseAppTray/hideRatioMenu/removePickerSheet/hideBarsForTouchOn:)
   matches the original call-for-call and was NOT touched.

9. **Pending/loader leftovers (GPT priority 3): investigated — NO
   divergence, deliberately NOT changed.** The original
   openAppsInOrder (IMP 0x1869c) also seeds pending + loader BEFORE
   the deferred openApp: call, its block also only removes the
   pending entry, and the original rejection branch also only logs
   + toasts. Cleanup in the original is the 20 s watchdog inside
   showLoaderInPane: (`fmov d0, #20.0` @0x2afd0 in the B dump; the
   "the dang mo %@ con sot -> bo" string is in the original binary),
   and the session measures match it (+20.03 s / +20.05 s). The
   stuck cards were a symptom of defects 1+2 rejecting 100% of
   apps, not of a sequencing difference. Adding rejection-branch
   cleanup would be a deliberate deviation from the original; it is
   recorded here as an available option for GPT to order separately,
   not folded in silently.

10. **Panel "ghost smudge" after close (video frame f_39.5):
    NOT ENOUGH EVIDENCE — unresolved, no code change.** The mark's
    shape matches no view in the close path, similar smears appear
    on dark areas of other frames (camera glare not excluded), its
    on-screen clock (21:57) does not match the 21:58:40 closePopups
    line, and no post-close hierarchy dump exists. Needed: a
    device-side screenshot (not a camera photo) right after closing
    the panel, or a subview listing after closePopups.

11. **AppIcons lock (investigation only — no code this round).**
    AppIcons has its OWN state machine in SCPAppIcons.m, separate
    from OMCCrashGuard: keys `splitScreenIconsPending` (BOOL) and
    `splitScreenIconsCrashed` (NSString) in domain
    com.anlai.omnicar; `SCPAppIconsBeginInjection` (@0xc37c) locks
    when the stored value equals the HARDCODED literal @"1.0.3".
    Consequences, all code-evidenced: changing only the package
    Version does NOT unlock (the binary literal stays "1.0.3");
    there is no time expiry; the Settings rescue "Bật lại" button
    does NOT affect AppIcons (it restores OMCCrashGuard features
    only). Unlock paths: (i) change the chosen-apps list in
    Settings → OmniCar → "App trên màn xe" — the prefs-changed
    notification reaches `SCPAppIconsRetry` (@0xb044), which clears
    `splitScreenIconsCrashed` and logs "danh sach app doi -> cho
    phep chen icon lai"; (ii) delete the `splitScreenIconsCrashed`
    key from the com.anlai.omnicar prefs directly. The device-side
    unlock is a controlled step AFTER this build is installed, per
    GPT's order; nothing in this round bypasses the lock in code.

### Build and verification (build10)

- Clean local build: `make clean` + `make package FINALPACKAGE=1`,
  exit 0, 0 errors (log `project/logs/fix-round/build10.log`).
  Restaged per BUILD_GUIDE §5 (xz). One packing note: `dpkg-deb -b`
  normalised the control member's owner to 0:0, so control.tar.xz
  was packed with tar to preserve the original's 501:20 on
  DEBIAN/control; the numeric tar audit then reads **202/202
  entries, 0 differences** in mode/uid/gid/type.
- diff_payload: files 176 = 176; non-Mach-O 168/168 byte-identical;
  0 original defined symbols missing; control diff = Installed-Size
  (computed) + Version (candidate name) only.
- Per-class parity (same harness as §14): **62/66 exact, 0
  selectors missing**, the same 4 additive-only exceptions as
  build9 (Prefs 743→745, StartupScreen 173→175, SpeedBubble
  277→278). Log `project/logs/fix-round/perclass10.txt`.
- §3 regressions — ALL PASS (log
  `project/logs/fix-round/g8-build10.txt`): SplitScreen _OMCPref
  32 call sites, every one preceded by an explicit x1 write;
  StartupScreen exactly 3 _objc_setAssociatedObject sites, each
  with `mov w3, #1` immediately before, at the same addresses as
  build9 (call sites 0x75f0/0x76c8/0x857c via stub 0x2479c);
  Prefs _NSStringFromClass = 3 (diagnostic-only) sites;
  `[GPT-F] Dock gate` string present; 8 AppBridge MILESTONE
  strings present.
- Gatefix discriminators in the re-extracted candidate — ALL PASS:
  SCPApplicationInfoForBundle references cfstrings
  `sharedApplicationLibrary` AND `applicationInfoForBundleIdentifier:`
  (the static helper is inlined; selrefs include `sharedApplication`
  + `respondsToSelector:`); -displayNameFor: references
  `applicationProxyForIdentifier:` + cstring `LSApplicationProxy`
  and does NOT reference `defaultWorkspace`; both pair/layout
  setters contain `fsub` and load the 0.2/0.8 range constants;
  showLayoutPanelForApp: contains the 84.0 immediate bit pattern
  (0x4055000000000000) and no 88.0 (0x4056000000000000) anywhere.

### Candidate

- Sole file in `project/packages/`:
  `com.anlai.omnicar_1.0.3-rebuilt-gatefix_iphoneos-arm64.deb`
- **951,940 B, SHA-256
  b53845bc903d5720258bfd494003f15cece5dfebcb2104d96fc9b4a61acc3c2f**
- `ar t`: debian-binary, control.tar.xz, data.tar.xz.
- UUIDs: SplitScreen CHANGED 4C4C44A8-5555-3144-A121-282872938F02
  (537,664 B, size unchanged); all other binaries identical to build9
  (deterministic build, sources untouched): OmniCar 4C4C4450…2EA6,
  Core 4C4C4462…2120, AppBridge 4C4C44C5…82DF, CarProbe
  4C4C44CF…44ED, SpeedBubble 4C4C4432…8F71, StartupScreen
  4C4C449A…1500, Prefs 4C4C4451…79C6.

### Tree-state (changed files, src = project mirror, cmp IDENTICAL)

```
69f5687492a275adf1f144660a5fc02dc88493a341efff36b7bef8b31d5e78bb  src/SplitScreenA/SCPShared.m
69f5687492a275adf1f144660a5fc02dc88493a341efff36b7bef8b31d5e78bb  project/OmniCarSplitScreen/SCPShared.m
5bdc4b2bf96b9a4f475bb737146dc6f725f09fccc614d208c545ba1f8644f38f  src/SplitScreenA/SCPShared.h
5bdc4b2bf96b9a4f475bb737146dc6f725f09fccc614d208c545ba1f8644f38f  project/OmniCarSplitScreen/SCPShared.h
84978e3eb812be7dc4022b1d75f75d9cbeef874a46bbffe6691059378c797ee1  src/SplitScreenA/SCPCarSplit.m
84978e3eb812be7dc4022b1d75f75d9cbeef874a46bbffe6691059378c797ee1  project/OmniCarSplitScreen/SCPCarSplit.m
edc61dc7c2dc0ccc635c5ab02dc1154b583d412768bad366a6a4c06d2cabe1bb  src/SplitScreenB/SCPCarSplit+Panel.m
edc61dc7c2dc0ccc635c5ab02dc1154b583d412768bad366a6a4c06d2cabe1bb  project/OmniCarSplitScreen/SCPCarSplit+Panel.m
```

**DEVICE_TEST = PENDING.** Acceptance focus for the next session:
a native CarPlay app (Music) and a chosen iPhone app (Waze/GOFA)
must both pass the gate and reach AppBridge (MILESTONE lines);
divider totals must read 1.00; panel tiles must sit inside their
outlines. Still owed from §14: the disconnect-while-splash run.
After installing this build, the AppIcons unlock step (item 11(i))
can be performed on device.

## §16 — Combined round (2026-11-08): prefsround candidate (gatefix + launchfix + liquidfix + bubblefix + prefsbubble + Prefs round)

One candidate carrying every landed fix since §15. Sub-round
records: `work/fix-round2/launchfix-notes.md`,
`work/fix-round2/liquidfix-notes.md`,
`work/fix-round2/bubblefix-notes.md`,
`work/fix-round2/prefsbubble-notes.md`,
`work/prefs-audit/W1–W4`. DEVICE_TEST = PENDING (see Status).

### A. Launchfix — the 22:55 CarPlay killer (SCPCarSplit.m:558)

GPT's conviction, verified against log + dump: openApp:'s fresh-
launch path passed the bundleID **NSString** to OMCCarLaunchInfo;
the dashboard machinery then sent `carPlayDeclaration` to the
string → NSInvalidArgumentException ×2 processes → rescue killed
splitScreen (log 22:55:29/22:55:35). The original at 0x169b0
fetches a FRESH appInfo via sub_e324 and passes that object at
0x169c4. Shipped fix mirrors it, plus GPT's guard (a safe
superset — it fires only when the fresh fetch returns nil, where
the original also lands in launchFailed): fetch appInfo;
`!appInfo || !SCPAppHasCarPlayUI(appInfo)` → launchFailed;
else OMCCarLaunchInfo(appInfo). SCPShared.h:60 was the tree's
ONLY wrong declaration (NSString*) → now
`id _Nullable OMCCarLaunchInfo(id _Nullable appInfo)`.
Call-site sweep: 558 was the only bad site (1350, ~2043,
SPPDisplayBoot:184 already correct). Also landed: the
SCPHomeVisibility.m:147 log-once string restored byte-exact
from the original (@0x7a740).

### B. Liquidfix — StartupScreen scene geometry was never initialised

The Liquid splash rendered as a near-white page with the title
huge and cropped at the top-left (photos 22:56). Cause, dump-
proven: SSStartupView's `_k/_ox/_oy` were READ by every scene
builder but NEVER assigned anywhere in our tree (grep: zero
stores); the original stores them ONLY in ss_buildScene
(0x10570). Restored at the original's exact point and formula:
`s = min(H/100.0, W/260.0)` (260.0 from binary VA 0x28e90);
guard `_sceneStyle < 0 || s <= 0` → return; `_k = s/6.0`
(0x105f4); `_ox = (W − 1600.0·_k)·0.5` (0x10614);
`_oy = (H − 600.0·_k)·0.5` (0x10634, −600.0 at VA 0x28ee0) —
design canvas 1600×600. Also restored: the switch default
builds NOTHING (ours wrongly fell back to ss_buildSky);
layoutSubviews rewritten from dump 0xeefc (logo bounds =
square of side min(W·0.5, H·0.62), shadowRadius 7·s, unit
update only when |s − _unit| ≥ 0.01, poster Center-symbol
re-render at 28·s); applyUnit: rewritten from 0xf110 (both
label branches, all constants); reload's poster/logo split
restored (poster always created; no-image path = symbol
play.rectangle.fill @ alpha 0.35, contentMode Center; logo =
car.fill). RECORDED DEBT, not restored: the ivar-table
0xcf4 constraint (−12·unit on _stack.widthAnchor, created by
reload's pinning block at 0xd3b4) — our tree has neither the
ivar nor reload's _stack pinning block; restoring it is a
separate reload-structure job, out of this round's scope.

### C. Bubblefix — car-side SPPBubbleView re-audit (23 divergences)

GPT's charge (renderStyle lacks layout/contentSize) was
substantively confirmed for the car file: renderStyle DID
contain layout and one contentSize publish, but the geometry
was wrong in 17 places, plus 6 in buildStyle (R1–R18, B1–B6
in the notes; every point dump-cited). User-visible worst:
style 5's flash assigned to the wrong family (R10), two
inverted state branches in style 4 (R7/R8), state-dependent
label shadow missing for styles 6/8 (R15), gauge fed the
SIGNED speed instead of |speed| (R16), and sign sizes of 34
where the original uses 50 in styles 0/6/7 — the earlier
closure had systematically misread the immediate
0x4049000000000000 (50.0). Original sign sizes across styles
0–8: 50, 44, 72, 46, 48, 40, 50, 50, 66. Nothing in
buildStyle/renderStyle remains UNRECOVERED.

### D. Prefsbubble — Settings-preview SPPBubbleView rewritten

The Prefs copy (a different, smaller class) had the same
disease, worse: renderStyle contained NO geometry at all
(render always returned CGSizeZero) and buildStyle: never
created the labels/sign/icon. Both functions plus
numberColor/applyColor: were rewritten from the Prefs dumps
(full per-style geometry in the notes); the two constant
arrays that looked undecodable were recovered from chained
fixups — no UNRECOVERED items remain in the file. One
INFERRED point kept: the speed-font feature-settings ids,
taken for consistency with SPPSignView.m's reading of the
same original factory sub_2d6bc.

### E. Prefs round — dispositions (12 files, all in src/Prefs)

- **W1, Startup-page ejection (Settings → Màn hình khởi
  động threw the user to the home screen): static audit
  could NOT convict.** The whole entry chain matches the
  original step for step (push path, real Class cellClass
  0x1608c–0x16184, plist byte-identical, specifiers/
  viewDidLoad/viewWillAppear/updatePreview 0x3fa5c–0x3ff0c,
  all cells stock PS*, every pref read guarded as tightly
  as the original). The §3b style-filter "inconsistency"
  at [9] is the ORIGINAL's own internal inconsistency
  (binary 9=Liquid/10=Random at 0x3faac; shipped plist maps
  random into ssStyles=[9]) — reproduced faithfully, NOT a
  divergence. Remaining unknowns are device-side data: the
  current startupScreenStyle value (selects 1 of 8 scene
  builders — the most-INFERRED part) and that session's
  exception identity. Shipped instead of a guess:
  instrumentation — OMCLogWriteSync (synchronous writer;
  neither async loss nor dispatch_sync deadlock) bracketing
  every audited step in 4 files (logs currentStyle + the
  class of each pref read), and an uncaught-exception
  handler installed at +load and viewDidLoad (idempotent)
  that logs name/reason/stack then CHAINS to the previous
  handler or re-raises — log-then-rethrow, nothing is
  swallowed anywhere; the two cellForRow sites use the
  synchronous [GPT-F] log-then-rethrow form. If the page
  still ejects, that session's own [W1] log names the step.
- **W2, previews.** Home preview: scale divisor /200 →
  /800 (@0x201d0) plus three more constants (preview width
  w−60 @0x20b38, §2 row 50 @0x20214, tiles w−40 @0x20188/
  @0x20770); the icon name map is now actually ASSIGNED to
  OMCHSNameMap at the original's store point (@0x1d454)
  instead of being built and dropped. OMCHSPreview drawRect
  rewritten from the original algorithm (scale = width/800
  @0x1bc9c; icon size round(64·size/100) @0x1c348 — ours
  drew 111 pt icons on a 50 pt pitch, so the stacked-icons/
  garbled-label photo was inevitable; labels now via the
  sub_1c620 name lookup, not raw bundle ids).
  **UNRECOVERED, recorded honestly:** the left-strip icon-
  list payload @0x7f948 (relative-pointer metadata, not
  cfstrings) could not be decoded; the strip's drawing loop
  is restored but its list ships empty with an UNRECOVERED
  comment — no bundle ids were invented. OMCSplitPreview:
  host fixed (row height MAX(round((tvW−40)·0.36),118)
  @0x38a6c, frame @0x39324; ours snapshotted box.bounds
  once) and inner view fixed (header is a LEFT strip, not
  a top bar; ratio 0.46 @0x37c38, not 0.375).
- **W3, cells and keys — all four GPT claims confirmed.**
  OMCCardPage cellWithId: → Subtitle style (mov w2,#3
  @0x48c4) + the original's 10-step reuse reset (@0x48d8);
  omcSegmentChanged: → feedback goes to a FRESH
  UISelectionFeedbackGenerator (@0x4e20/@0x4e28) BEFORE
  storeValue (ours sent it to the control itself, last).
  SPLITSCREEN_LAYOUT_* raw keys were a pure ORDER bug:
  the original composes the full key first (@0x39800) and
  localizes second (@0x39810); the picker uses 4 literal
  keys _2/_3/_13/_31 (@0x3ad4c). The shipped strings
  tables were already correct (14/14 languages) — no
  bundle change. SpeedBubble section titles: section 2 →
  SPEEDBUBBLE_APPEARANCE, section 3 → SPEEDBUBBLE_SIZE_GROUP
  (pointer table 0x74ba0: 0x7a328 / 0x7a388; our old SIZE
  key hit no table at all).
- **W4, rescue footer "(null)" — two divergences, both
  Prefs-local.** _OMCRescueFeatures returned nil on the
  non-array branch; the original returns @[] (@0x7a24).
  And the footer wrapped the text as "%@: %@"; the
  original uses the localized string itself as the format:
  stringWithFormat:L(@"RESCUE_FOOTER"), joined (@0x15b40).
  The store is identical on both sides (CFPreferences
  com.anlai.omnicar / rescueFeatures, written by the
  shared-core CrashGuard) — no key/domain/type error.
- **Startup cluster (same round).** refreshVideoList now
  passes full filenames as values (titles remain
  extension-stripped) @0x40fa0 — ours passed titles for
  both, so a wrong video could be saved; carName branch
  compares identifier==@"carName" and sets @"placeholder"
  @0x3dc3c; birthday picker → Compact @0x400e4;
  reloadSpecifiers moved to the head of viewWillAppear
  @0x10fc8; SSApplySampleData order hud→nextEvent→
  battery→weather @0x545e4; randomSet compares unsigned
  @0x3d27c; header 320×280, itemSize 78×108; currentSound
  returns the BARE name (csel @0x3d0c0) and both consumers
  adjusted (specifiers drop lastPathComponent @0x3d9f4;
  previewSound builds the path itself @0x449c0).
- **Splash "dismissing after 0 frames" (22:55:42) —
  checked, closed.** For a static no-video splash the
  frame counter belongs to the JPEG-video path; ending at
  0 frames is the original's normal behaviour (and for
  Liquid style the counter is not evidence the animation
  did not run).

### F. deleteSound — DELIBERATE DEVIATION (GPT ruling)

Disassembly proves the original's "delete sound" deletes
the ENTIRE realpath-resolved Sounds directory:
currentSound is used only as a nil-gate (cbz x20 @0x44d34,
value never messaged) and removeItemAtPath:error:
(@0x44e0c–0x44e18) receives the directory itself — no
stringByAppendingPathComponent: anywhere in the method.
The Prefs round first restored that behaviour faithfully;
GPT then ruled it must NOT ship in a test release. As
shipped here, deleteSound deletes ONLY the currently
selected sound file (SSReal(Sounds) + bare name), clears
startupScreenSoundFile, and leaves every other file in
the directory untouched. This is an intentional,
documented difference from the original, kept to prevent
data loss; it is acceptance-gated (see regression (vi)).

### G. Integration, candidate, parity, regressions

Build method: Version set to 1.0.3-rebuilt-prefsround in
BOTH control files (control/control and project/control)
and KEPT after the build (the DEB's control confirms it).
Each of the 8 subprojects was cleaned and built DIRECTLY
(all exit 0); the aggregate make was used only for
packaging — the liquidfix round caught the aggregate
reporting "Nothing to be done" over stale objects, so
freshness here is proven by timestamps (staged binaries
16:57–16:58 UTC against a 16:56:56 build start), not by
exit codes alone.

- **Candidate:**
  `com.anlai.omnicar_1.0.3-rebuilt-prefsround_iphoneos-arm64.deb`
  in project/packages/ — 967,924 B, SHA-256
  `2e89d0a5d18d25d8a638fa9ceb356a46084df069d7e16570f296a1b1b063d650`;
  members debian-binary + control.tar.gz + data.tar.lzma.
- **UUIDs (arm64):** OmniCar 4C4C4450-5555-3144-A1A3-58843B0F2EA6;
  Core 4C4C4462-5555-3144-A1FD-68112DE02120; AppBridge
  4C4C44C5-5555-3144-A125-1D7128382BDF; CarProbe
  4C4C44CF-5555-3144-A10B-60B43FDF44ED; SpeedBubble
  4C4C4485-5555-3144-A14F-AEDFFDE46718; SplitScreen
  4C4C4434-5555-3144-A12D-FE9691749170 (same as the
  launchfix candidate — SplitScreen sources unchanged
  since; the FILE is not bit-identical, link layout
  shifted, so all SplitScreen checks below were re-run
  on THIS binary); StartupScreen
  4C4C44B4-5555-3144-A162-0E8998F52385; Prefs
  4C4C4447-5555-3144-A1FE-0EBD27D16A3C.
- **Parity (perclass11.txt): 61/66 classes exact, ZERO
  selectors missing anywhere.** Per binary: App 6=6,
  AppBridge 193=193, SplitScreen 480=480, SpeedBubble
  277→278, StartupScreen 173→175, Prefs 743→746, Core
  0=0, CarProbe 0=0. The one-step move from the §15
  baseline (62/66, Prefs 743→745) is fully accounted:
  the fifth additive-only exception is
  OMCStartupScreenController **+load** — the [W1]
  instrumentation's exception-handler install, an
  intended addition of this round, not a parity loss
  (every exception remains additive-only with
  only_orig empty).
- **Regressions in the re-extracted DEB — ALL PASS.**
  (i) Arity: all 32 _OMCPref callers in SplitScreen
  write x1 explicitly (32/32); the binary contains
  EXACTLY 3 objc_setAssociatedObject call sites, at
  0x75f0/0x76c8/0x857c (the §14 addresses), each with
  `mov w3, #1` immediately before. (ii) Gatefix:
  sharedApplicationLibrary referenced ×2;
  -[SCPCarSplit displayNameFor:] references
  applicationProxyForIdentifier: (guarded-send cfstring
  form) + LSApplicationProxy and NO defaultWorkspace in
  any ref kind; both setters contain fsub and load the
  0.2/0.8 constants; panel method contains the 84.0
  immediate bit pattern (0x4055000000000000) and no 88.0
  (§15 method-scoped form). (iii) Launchfix: openApp:'s
  chain disassembles as SCPApplicationInfoForBundle →
  cbz → SCPAppHasCarPlayUI → tbz → OMCCarLaunchInfo,
  exactly one launch-info call in the method. (iv)
  [GPT-F] present in SplitScreen; 8 MILESTONE strings
  in AppBridge; the rescue title/body/feature strings
  are byte-exact — verified in OmniCarCore, where they
  live (extracted from the original Core and matched
  byte-for-byte in the new Core, title anchored:
  "OmniCar: chế độ cứu"). (v) Liquidfix: ss_buildScene
  contains fdiv ×3, fmadd ×2, str d ×3 and loads the
  constant set {100.0, 260.0, 6.0, 1600.0, 600.0}.
  (vi) Sounds: the shipped deleteSound's selector order
  is currentSound → … → stringByAppendingPathComponent:
  → removeItemAtPath:error: (the file-append precedes
  the remove); the discriminator itself was validated
  against the original binary, whose deleteSound has
  NO stringByAppendingPathComponent: at all.
  Method note: our lld builds use classic dyld binds,
  so the wave-1 Annotator cannot name stubs/selrefs in
  them (it resolves only chained-fixup images like the
  originals) — checks (i-b)/(ii-b)/(vi) were therefore
  read from llvm-objdump's own stub/selector annotations
  inside IMP-derived ranges; the two extraction methods
  agree everywhere they overlap.
- **Mirror sweep:** 151 src↔project pairs compared; every
  file touched this round is cmp-identical. Two
  PRE-EXISTING drifts in files this round did not touch:
  SplitScreenC/SCPHomeApply.m differs by one comment/
  import-path line (flat project layout, self-documented
  "[phase3 sync]"), and SplitScreenB/SCPCarSplit.h is an
  alternate longer variant (the project copy matches
  SplitScreenA's). Structural asymmetries, also
  pre-existing: project-only glue (OmniCarStartupScreen.m
  scaffold anchor, PrefsIntegrationShims.h) and src-only
  OMCCommon/OmniCarCore.c.

**DEVICE_TEST = PENDING.** Acceptance script:
`handover/ACCEPTANCE_PREFSROUND.md`. Nothing in this
section may be read as "hoàn thiện" until that script
passes on device.

## S16H - Correction after CI run 42503451473 (FAT verify failed at ls; the build itself compiled clean)
Tree control Version reverted 1.0.3-rebuilt-prefsround -> 1.0.3 (project/control). The macOS FAT workflow addresses the package by the fixed name com.anlai.omnicar_1.0.3_iphoneos-arm64.deb; with the round suffix in the tree control, Theos emitted a suffixed filename and the verify step failed before any lipo check ran. Prior rounds kept the tree control at 1.0.3 and carried the round name on the delivered file only - that convention is restored. The local prefsround candidate recorded in S16 (built before this revert; its internal control reads 1.0.3-rebuilt-prefsround) is unaffected. The CI FAT artifact will be renamed to the prefsround-fat name on delivery, as in prior rounds.

# §17 — Vòng sửa 3 (fixround3)

Ngày: 2026-11-09. Candidate local: `com.anlai.omnicar_1.0.3-rebuilt-fixround3_iphoneos-arm64.deb`
— 969.344 byte, SHA-256 `cc4ea835d82636cd9f3aaa837a25968b038a3a538c32b59d55e38592abd05e34`,
payload 176 file, control trong gói `Version: 1.0.3-rebuilt-fixround3` (cây đã trả về
`Version: 1.0.3` sau khi đóng gói — giữ nguyên tắc tên cố định cho workflow FAT).
UUID 8 binary (arm64): OmniCar `4C4C4450-5555-3144-A1A3-58843B0F2EA6` ·
Core `4C4C4462-...-68112DE02120` · AppBridge `4C4C44C5-...-1D7128382BDF` ·
CarProbe `4C4C44CF-...-60B43FDF44ED` · SpeedBubble `4C4C4485-...-AEDFFDE46718` ·
SplitScreen `4C4C44A6-5555-3144-A134-7A20C9D62ABA` (MỚI) ·
StartupScreen `4C4C44B4-...-0E8998F52385` ·
Prefs `4C4C4485-5555-3144-A1C6-B7C5F0F88CE8` (MỚI).
Chỉ SplitScreen + Prefs đổi UUID so với prefsround — đúng hai module có sửa.
Parity bề mặt selector (so candidate prefsround local cùng toolchain):
SplitScreen 587 = 587 tên, Prefs 825 = 825, thiếu 0 / thêm 0 ở cả hai.

## Lỗi A — trang Khởi động (Cài đặt) văng: điểm ném nằm trong applyUnit: phía Prefs

Hồ sơ: log 09/11, handler [W1] ghi 3 lần chết giống hệt:
`NSInvalidArgumentException '-[__NSPlaceholderArray initWithObjects:count:]:
attempt to insert nil object from objects[0]'`. Symbol gần nhất trong stack là
SSSampleHudItems — SAI LỆCH do binary stripped (method ObjC bị strip thành local,
mọi địa chỉ rơi về global gần nhất). SSSampleHudItems của ta KHỚP gốc (đối chiếu
dump sub_50180: 5 dict, key `text`/`ok`, OMCTr ×5) và lời gọi SSApplySampleData
đã chạy xong (log [W1] bracket ra: hudClass=__NSArrayI).

Điểm ném thật: `src/Prefs/OMCPrefs/SSStartupView.m`, thân `applyUnit:` — vòng
`for (UILabel *l in @[_timeLabel, ..., _updatedLabel])` dựng array literal từ
8 ivar THÔ. Style 0: clearContent nil hoá cả 8 label, reload chỉ dựng poster →
`_timeLabel` = nil → ném ngay tại lúc dựng literal; `if (!l) continue` bên trong
là code chết. Ngay trên đó có sẵn một mảng đã coalesce `?: [UILabel new]` cho từng
phần tử nhưng bị `(void)labels;` bỏ đi không dùng.

Gốc (dump Prefs, applyUnit: va=0x48d4c): 8 ivar nạp vào **C array trên stack**
(stores 0x48d8c–0x48e58, retain từng phần tử), vòng 0x48e6c–0x48ee0 **bỏ qua nil
bằng cbz tại 0x48e74**, mỗi label sống được set `shadowRadius = 1.5 × unit`
(fmul 0x48e5c–0x48e60) và `shadowOffset = (0, 0.5 × unit)` (hệ số 0.5 tại
0x48e64–0x48e68; width = 0 tại 0x48ec0; setShadowOffset: tại 0x48ecc). Toàn hàm
gốc có **0** lần arrayWithObjects:count: (đã tự grep kiểm vùng dump).
Đã sửa đúng cấu trúc đó; giữ nguyên từ `_stackMaxWidth.constant = -12 * unit`
trở xuống (dòng đó khớp dump 0x48ee4).
Bằng chứng binary: object đã biên dịch của SSStartupView (Prefs) cho thấy
applyUnit: nạp ivar → objc_retain → store vào stack slots theo đúng mẫu gốc;
toàn TU còn **0** tham chiếu arrayWithObjects:count:.
Phụ (lệnh GPT): bản phía XE `src/StartupScreen/SSStartupView.m` ĐÃ ở đúng cấu
trúc C-array (liquidfix viết lại theo dump module xe, applyUnit: tại dòng 310,
shadowOffset (0, 0.5u)) — grep xác nhận không còn mẫu literal thô; không sửa.

## Lỗi B — app native không giữ được ô: CGRectValue gửi tới scene settings (23 lần)

Cơ chế: hai helper `SCPGuarded` (SCPCarSplit.m:27) và `SCPGuardedSend`
(SCPShared.m:33) ép MỌI kết quả qua chữ ký trả object
`((id (*)(id, SEL))objc_msgSend)`. Trong `verifySceneOfPane:expected:retry:`
(bản cũ): `frameValue = SCPGuarded(settings, @"frame")` — `-frame` TỒN TẠI trên
settings (FBSceneSettings con: CRSUIProxyApplicationSceneSettings /
UICarPlayApplicationSceneSettings) nhưng trả **CGRect theo giá trị** (v0–v3),
không ghi x0; objc_msgSend tail-jump giữ x0 = receiver → "kết quả" chính là
settings → `[frameValue CGRectValue]` ném unrecognized selector. Log máy xác
nhận 23/23 lần receiver là class settings. Chuỗi gọi: hook presentBaseViewController
(SCPHooks.m:194) → adoptViewController: → adopt:slot: → (dòng cộng thêm 1041)
verifySceneOfPane — ĐỒNG BỘ ngay trong stack present → @catch → closeGoingHome:NO
→ "tat split" (53 lần trong log).

Đã sửa theo dump gốc của verify (IMP 0x1cce0):
1. Cổng vào: `!active` / `!pane.vc` → return; cổng staleness (0x1cd48–0x1cd6c):
   **return khi pane.sceneSize KHÁC expected, đi tiếp khi BẰNG** (fcmp + b.ne về
   epilogue) — caller pushSceneSizes ghi sceneSize rồi mới hẹn verify; cổng này
   giết bản verify cũ khi layout đã đổi. (Mô tả ban đầu trong đề bài ngược cực;
   đã làm theo dump.)
2. Frame đọc TRỰC TIẾP (0x1ce5c–0x1ce9c): NSSelectorFromString(@"frame") +
   respondsToSelector → `((CGRect (*)(id, SEL))objc_msgSend)(settings, sel).size`;
   không có → CGSizeZero. KHÔNG qua SCPGuarded, KHÔNG NSValue/CGRectValue
   (0 lần trong dump). Settings vẫn lấy qua @try như gốc (pad 0x1ce1c–0x1ce54).
3. actual == CGSizeZero → log `CarSplit: khong doc duoc kich thuoc scene %@` → return.
4. Khớp (0x1cf40–0x1cf84): (|aw−ew| ≤ 2 ∧ |ah−eh| ≤ 2) **hoặc hoán vị**
   (|aw−eh| ≤ 2 ∧ |ah−ew| ≤ 2).
5. Log SAU MỌI lần đọc được frame (0x1cf88–0x1d02c):
   `CarSplit: scene %@ that = %@ (can %@)%@`, hậu tố = khớp ? "" :
   (retry≠0 ? " -> ve nen roi len lai" : " -> van sai") (csel 0x1cfd4–0x1cff8).
6. Retry chỉ khi retry≠0 ∧ chưa khớp: allowBackground +1 (0x1d070–0x1d080) →
   backgroundSceneWithCompletion: (block rỗng — block global gốc 0x78c40 có
   invoke là một lệnh ret) → allowBackground −1 → hẹn 0.25 s block sub_1d2a8:
   foregroundSceneWithSettings:nil completion:block-rỗng → hẹn 0.8 s (hằng
   *(0x6f080)) block sub_1d444: verify lại với retry:0. Hai block dump đã sinh
   bổ sung vào `src/SplitScreenA/disasm/sub_1d2a8_verify_retry_block.txt` và
   `sub_1d444_verify_retry_block2.txt`. Xoá `pane.sceneSize = actual;` ở đuôi
   bản cũ — dump verify có 0 lần setSceneSize (chỉ getter tại 0x1cd4c).
7. adopt:slot: — xoá điểm gọi verify cộng thêm; khôi phục `showPickerForSlot:`
   (đối số [pane slot], có cbz pane 0x19b5c) đúng vị trí gốc giữa raise và
   relayoutAnimated: (đuôi dump adopt 0x19b48–0x19bec). Verify chỉ còn được gọi
   từ block +0.9 s của pushSceneSizes như gốc.
8. Hook: sau @catch đi THẲNG tới lời gọi orig như gốc (pad 0x6614–0x6654 →
   0x644c) bằng cờ `threw` riêng — hết log "tat split" + closeGoingHome lần hai.
   (Hai vùng @try phụ của hook gốc — "closeGoingHome" và "(sau)" — chưa khôi
   phục; ghi nhận là khoảng trống fidelity, ngoài phạm vi vòng này.)
9. Rà toàn bộ call site SCPGuarded/SCPGuardedSend trong SplitScreenA/B/C:
   `frame` là selector struct-return DUY NHẤT từng đi qua hai helper — đã sửa;
   mọi selector còn lại đều trả object. Không còn ca cùng bệnh.

Bằng chứng binary: object đã biên dịch của SCPCarSplit còn **0** tham chiếu
undefined tới stub CGRectValue trong toàn TU (verify là nơi dùng duy nhất);
binary đóng gói mang chuỗi log verify mới + hậu tố " -> ve nen roi len lai",
chuỗi log sai cũ ("kich thuoc scene %@ %@ -> van sai") đã biến mất; [GPT-F] ×1,
sharedApplicationLibrary ×2 còn nguyên.

## Lỗi C — CarPlay chết 06:34:33: hợp đồng paneForView: là gốc chung

Chuỗi: nút X "hủy mở" nằm TRONG loader (showLoaderInPane: tạo tại Picker.m:1076,
loader gắn vào pane.view, accessibilityIdentifier = bundle) →
loaderCancelTapped: → `paneForView:sender` → bản cũ của paneForView:
(SCPCarSplit.m:368) chỉ khớp `pane.view == view || pane.host == view` → nút là
descendant 2 tầng (nút ⊂ loader ⊂ pane.view) → **nil tất định** → bundle = nil →
log `CarSplit: huy mo (null) o 0` (log 06:34:31.583, khớp từng ký tự) → guard sẵn
có chỉ bảo vệ cancelledLaunches → launchFailed:nil chạy tiếp →
`[self.pending removeObjectForKey:nil]` (dòng đầu launchFailed:) → CRASH.

Symbolicate (hồ sơ riêng `work/fix-round3/symbolicate-063433.md`, slice arm64
UUID 690e2902-54db-3bad-97a0-d0ff9b98ae91 khớp .ips): **KHỚP TOÀN BỘ** —
offset 0x755C nằm trong `-[SCPCarSplit launchFailed:slot:]` (0x74F8–0x76E0),
lệnh ném là removeObjectForKey: ở dòng đầu method; offset 0x303A8 nằm trong
`-[SCPCarSplit loaderCancelTapped:]` (0x302A8–0x303CC), lời gọi launchFailed
nằm NGOÀI nhánh guard nil; cfstring log giải ra nguyên văn
'CarSplit: huy mo %@ o %d'.

Đã sửa:
1. paneForView: khôi phục hợp đồng gốc @0x23914 (dump
   `-SCPCarSplit_paneForView_.txt`): duyệt allPanes,
   `[view isDescendantOfView:pane.view]` (bl tại 0x239d4) — một nhánh duy nhất,
   dump không kiểm pane.host. isDescendantOfView: đúng cho cả chính view đó nên
   pane.view/host vẫn khớp như cũ, cộng thêm mọi descendant sâu.
2. Rà MỌI call site: pickerPaneTapped: (Picker.m:193, gr.view = picker — con
   trực tiếp của pane.view) nay chạy đúng → **chạm ô trống mở được picker**
   (đây là gốc của "hai ô trắng" cuối video 1 + "phím + không click được");
   các wrapper paneSolo:/paneBackground:/paneClose: (nút trong bar ⊂ pane.view),
   Drag.m handlePanned:, Zoom.m handle*/panePopOut:, Panel.m paneChoose: — đều
   nằm trong cây pane.view, verdict đúng, không sửa. Hai site fallback sau
   pickerSheetPane (Picker.m:756/778) truyền view của tray window — chết cả
   trước/sau, KHỚP gốc (gốc cũng dùng cùng hợp đồng) — giữ nguyên.
3. loaderCancelTapped: khôi phục gốc @0x2b980: `pane == nil || bundle == nil`
   → return NGAY (đích chung 0x2ba98), TRƯỚC log/ghi cancelledLaunches/
   launchFailed. Sửa comment offset sai "0x38000 (approx.)" → 0x2b980.
   (Khoảng trống ghi nhận: gốc có @catch log `CarSplit: loi huy mo app %@`
   (cfstring 0x7c500) quanh thân — bản ta chưa có; ngoài phạm vi vòng này.)
4. launchFailed:slot: — khôi phục điều kiện gỡ loader theo dump @0x17e70:
   gỡ khi **slot khớp HOẶC loader-id khớp** (isEqualToString: tại 0x17f54–0x17f7c,
   gỡ tại 0x17f94) — bản cũ AND hai điều kiện nên watchdog gọi slot −1 không bao
   giờ gỡ được loader (loader GOFA mở 06:32:53, watchdog 06:33:13 "còn sót"
   nhưng loader + nút X vẫn sống tới cú chạm chết 06:34:31). Sau khi gỡ, nếu
   `!pane.vc && !slotOccupied(pane.slot)` thì showPickerForSlot: bằng slot của
   chính pane (0x17fa4–0x17fe8).
5. **SAI KHÁC CÓ CHỦ ĐÍCH (lệnh GPT):** guard đầu launchFailed: —
   `if (!bundleID) { log "CarSplit: launchFailed bundle nil o %d -> bo qua
   (guard GPT)"; return; }`. Gốc KHÔNG có guard này (removeObjectForKey: tại
   0x17ecc không kiểm nil; gốc dựa hoàn toàn vào hợp đồng caller). Vẫn thêm
   theo lệnh GPT làm lớp chặn cuối; chuỗi guard đã có mặt trong binary đóng gói.

## Picker — showPickerForSlot: (dump @0x31530)

- Frame/hệ tọa độ: bản cũ tạo picker bằng frameForSlot: (tọa độ CONTAINER) rồi
  gắn vào trong pane. Gốc: lấy **size** từ frameForSlot:, ép origin (0,0)
  (0x315cc–0x315e4), setPicker: ngay (0x315c0), gắn vào **pane.view** (0x317b0).
  Đã khôi phục.
- Màu nền (0.93333, 0.94117, 0.98431, 1.0) tại 0x315ec–0x3160c — bản cũ dùng
  ĐÚNG giá trị nhưng ghi chú INFERRED → đã sửa nhãn VERIFIED.
- Viền: bản cũ trắng alpha 0.55 — SAI. Gốc 0x3163c–0x31690:
  colorWithRed:0.6078431372549019 green:0.5294117647058824 blue:0.9725490196078431
  alpha:1.0; dump không có setBorderWidth. Đã khôi phục màu gốc.
- Glyph '+': cfstring 0x7c720 giải mã từ binary gốc = "+" (text trơn) ✓.
- Màu chữ: bản cũ trắng 0.85 — SAI. Gốc 0x316d4–0x31704:
  `[SCPColorSecondary() colorWithAlphaComponent:0.6]` (helper @0x2b380 =
  0.29019/0.30980/0.50196). Đã khôi phục — đây là gốc của '+' gần như vô hình
  trên nền sáng trong video.
- Font: size 40 đúng (0x4044000000000000); weight bản cũ Bold — SAI: GOT
  0x782a8 = _UIFontWeightLight. Đã sửa.
- Đuôi hàm bị thiếu, đã khôi phục: bringSubviewToFront:handle (0x317e8),
  relayoutAnimated: (0x31818), fade-in alpha 0→1 trong 0.25 s (block 0x31954),
  refreshPickerSheetSoon (0x3187c).
- Quan sát chưa sửa: stub đầu hàm trong dump là `activate` (@0x56b00) trong khi
  bản ta dùng `self.active`; trong cây gộp `-activate` là action khởi động
  split (IMP 0x15c24) nên đổi theo tên stub sẽ đổi hành vi — giữ self.active,
  chờ vòng kết tội riêng nếu cần.

## paneSize:forBundle: — ABI gốc khác hẳn bản tái dựng (dump @0x1b328)

Gốc là **`- (BOOL)paneSize:(CGSize *)outSize forBundle:`** — x2 là con trỏ ra
(caller hook @0x5d8c truyền sp, test BOOL tại 0x5db4). Bản cũ khai
`(CGSize)paneSize:(CGRect)frame forBundle:` + thứ tự guard sai:
`slot = [self paneForBundle:bundleID].slot` — nhắn nil trả 0 nên check slot<0
không bao giờ chạy, pendingSlotForBundle: không bao giờ được tra cho app chưa
gán; comment "VERIFIED call sequence" là nhãn sai.
Đã khôi phục theo dump: guard `!active || !bundleID` → NO (0x1b350–0x1b360),
`!container` → NO (0x1b37c); slot = pane ? pane.slot :
pendingSlotForBundle:; `slot < 0` → NO (0x1b3c0); hợp lệ khi MIN(w,h) ≥ 2
(0x1b3cc–0x1b3d8); *outSize chỉ ghi khi hợp lệ và outSize != NULL
(0x1b3dc–0x1b3ec). Hệ quả bắt buộc ngoài danh sách file gốc của đề bài: đã sửa
kèm khai báo trong SCPCarSplit.h và caller Hook_sceneFrameForAppInfo trong
SCPHooks.m (nếu không cây không nhất quán biên dịch được).
Bằng chứng binary: metadata của binary đóng gói ghi types của paneSize:forBundle:
= `B32@0:8^{CGSize=dd}16@24` — BOOL + con trỏ CGSize*, đúng ABI gốc.

## Các rà phụ D — trạng thái tại thời điểm build tích hợp

Theo lệnh chia việc của Muse chính, D1–D4 do các agent song song riêng phụ
trách; trạng thái cây tại lúc build (kiểm timestamp/hash từng file):

- **D1 (cell "Hiện trong bảng" hai công tắc chồng): ĐÃ KẾT TỘI** bởi investigator
  của vòng này — bản cũ dựng UIStackView DỌC chứa hai hàng label+UISwitch
  (frame cứng (0,0,190,52), tự ghi [INFERRED]) trong khi gốc dùng MỘT stack
  NGANG chứa hai chip RECENT/FAVORITES (chip:key: @0x3a4d4 — UIButton pill,
  font 12.5 Semibold, bật = chữ trắng nền #8B7CFF, tắt = secondaryLabel nền
  trắng mờ, radius 10, cao 30, rộng = ceil(textWidth)+20; chipTapped: @0x3a820
  XOR pref rồi reloadSection:4; bản cũ chipTapped: là stub rỗng reload nhầm
  section 3). **Bản sửa của agent D1+D4 đã landed trong cây trước build**
  (OMCSplitScreenController.m mtime 2026-11-08 23:57 UTC, src = project
  identical) nên nằm TRONG candidate này; tôi không tự rà lại từng dòng của
  agent đó.
- **D2 (icon preview Màn chính co về mép trái sau khi chọn hình nền): ĐÃ KẾT TỘI**
  bởi investigator của vòng này — hai lệch cùng đường: (1) `boxInCell:` tạo box
  frame CGRectZero, không autoresizingMask; gốc @0x22284 initWithFrame:
  contentView.bounds + mask 0x12 (FlexibleWidth|FlexibleHeight); (2) preview bị
  gắn vào box thay vì thẳng vào contentView (gốc @0x209d8–0x20b58: kiểm
  preview.superview == cell.contentView, frame (10,10,w−60,floor((w−60)·300/800))
  tại 0x20b38). drawRect:/updatePreview/bản đồ tên đều khớp gốc (minh oan).
  **NHƯNG tại lúc build, file của mảng D2 chưa có thay đổi nào landed**
  (OMCAppBridgeAppsController.m / OMCHSPreview.m mtime 16:01–16:02 UTC, từ thời
  prefsround) → **bản sửa D2 KHÔNG nằm trong candidate này** — đã kết tội, để
  vòng sau hoặc chờ agent D2 của Muse chính chốt.
- **D3 (splash Liquid chữ/logo chồng nhau):** tại lúc build, SSStartupView.m /
  SSStartupViewBuilders.m phía StartupScreen không có thay đổi mới (mtime
  16:21 / 06:53 UTC) → chưa có kết luận trong cây này; để vòng sau.
- **D4 (editor bố cục yêu thích chật/lệch):** cùng file với D1 (đã landed theo
  agent D1+D4); nội dung rà chi tiết thuộc hồ sơ của agent đó.

## Build + kiểm chứng của vòng

- Toolchain VM bị rollback (mất symlink ld.lld + ldid): đã khôi phục theo recipe
  đã lưu (symlink → ld.lld-18; ldid-real từ bản sao lưu + shim ký qua /tmp),
  smoke test ký Mach-O + link arm64 đạt trước khi build.
- Build TỪNG MODULE (không tin aggregate): 8/8 module exit 0, 0 error;
  đóng gói FINALPACKAGE=1. Mirror src↔project: mọi file đã sửa đều cmp
  identical (kèm SHA-256 trong báo cáo fixer); 5 file của các agent song song
  cũng identical tại lúc build.
- Discriminator trong candidate trích lại: xem từng mục Lỗi A/B/C/paneSize ở
  trên. Chuỗi hồi quy các vòng trước còn nguyên: rescue UTF-16LE byte-exact
  trong Core, [GPT-F] ×1, MILESTONE ×8 (AppBridge), sharedApplicationLibrary ×2.

## Tiêu chí nghiệm thu vòng này (theo GPT — cho lần test xe gộp)

Facebook/GOFA/Waze vào được ô; đổi app trong từng ô; hủy loader bằng nút X;
chạm ô trống mở picker; kéo divider; đóng/mở lại split; mở được trang Khởi động
trong Cài đặt mà không văng; hàng "Hiện trong bảng" hiện hai chip Ngang
Gần đây/Yêu thích. **"Chỉ hiện biểu tượng đang tải" KHÔNG tính là đạt.**

---
# PHỤ LỤC §17 — các mảng bổ sung sau bản build đầu (D5, K1, K2, D6) + CANDIDATE CUỐI

Candidate ở đầu §17 (SHA cc4ea835…, build 00:01 UTC) đã bị THAY THẾ bởi bản
build cuối cùng của vòng sau khi các mảng D5/K1/K2/D6 landed:
**`com.anlai.omnicar_1.0.3-rebuilt-fixround3_iphoneos-arm64.deb` — 969.994 B,
SHA-256 `c075bf37d8e040d34280ff452e97ac109411940913da3b28b081392b2c14c45f`**,
payload 176 file, build từng module 8/8 exit 0. UUID mới: SplitScreen
`4C4C4485-5555-3144-A1D2-1EF3D2720C96` · StartupScreen
`4C4C44A2-5555-3144-A12D-E9E34236B9E1` · Prefs
`4C4C44BD-5555-3144-A116-D9DD13D2D2E8`; 5 binary còn lại giữ UUID prefsround.
Parity bề mặt selector vs prefsround local: SplitScreen 587 = 587, Prefs
825 = 825, StartupScreen 290 = 290 — thiếu 0 / thêm 0 ở cả ba.

## D5 — nút '...' (handle) trong ô

Gốc không có nút "ellipsis": '...' là handle pill 34×12 ba chấm ở đỉnh giữa ô
(setupBarForPane: @0x22adc), chạm mở action bar 5 nút (Đổi app / Toàn màn /
Cửa sổ nổi / Chạy nền / Tắt app); double-tap = zoom, kéo = di ô. Bản ta dựng
đủ cả hai (Chrome.m) — thiếu là các mắt nối:
1. paneForView: equality → đã sửa ở Lỗi C (isDescendantOfView:) — handleTapped:
   sống lại nhờ đó. Kiểm cuối: cây project dòng 376 còn nguyên dạng
   isDescendantOfView: (chống staging ghi đè — điểm E1.2).
2. layoutBarForPane:: audit D5 kết luận "không có điểm gọi" vì rà trên cây
   src — cây src THIẾU HẲN file SCPCarSplit+Relayout.m (thân relayout phía src
   chỉ có ở bản handoff không thuộc build). TU THẬT được Makefile biên dịch
   (project/OmniCarSplitScreen/Makefile:13) là SCPCarSplit+Relayout.m và nó
   ĐÃ CÓ ĐẦY ĐỦ hai lời gọi: dòng 78 trong vòng slots (sau host.frame →
   picker.frame → layoutBar, khớp trình tự dump @0x1bc80 → 0x1bce0 → 0x1bcfc)
   và dòng 95 cho floatPane (trước bringSubviewToFront:floatPane.view, khớp
   @0x1c058 → 0x1c08c). Toàn gốc chỉ có 3 call site (thêm setBarVisible:
   @0x24328 = Chrome.m:234). **Không sửa gì ở điểm này** — ghi nhận lệch cấu
   trúc src↔project để phía staging xử lý (đừng để bản src thiếu file này
   gây kết luận sai ở vòng sau).
3. Handle ẩn khi pane.vc == nil là LUẬT GỐC (layoutBarForPane:); ô native
   mất handle vì adopt gãy (Lỗi B) chứ không phải lỗi riêng — chuỗi tĩnh sau
   sửa: adopt hoàn tất → pane.vc được gán (SCPCarSplit.m đường present) →
   layoutBar chạy mỗi relayout → handle hiện. Đã xác nhận theo code; máy thật
   do Nguyen kiểm.
4. Rà 5 action: paneChoose: (@0x29f28), paneSolo: (@0x287b8), paneBackground:
   (@0x28a30), paneClose: (@0x2a0e0) — đã kiểm, khớp dump. **panePopOut: CHẾT
   NÚT — đã sửa**: gốc @0x201f0 truyền thẳng sender vào paneForView: (không
   gửi `view`); bản ta khai tham số là UIGestureRecognizer* rồi gọi
   paneForView:gr.view trong khi sender thật là UIButton của thanh bar (không
   đáp `view`) → nút Cửa sổ nổi chết. Đã sửa tại SCPCarSplit+Zoom.m
   (pane = paneForView:sender; pane≠nil mới popOutPane:) + khai báo ở
   SCPCarSplit.h hai bản.
5. setupBarForPane: đã kiểm — khớp (đúng 1 setHidden: trên bar @0x233b0;
   handle.hidden chỉ do layoutBarForPane: gán theo vc).

## K1 — dispatch lệnh native thiếu 4 action (E2, dump block 0x7bec)

ĐÍNH CHÍNH SỐ LIỆU: census nói 11 action; dump block 0x7bec chỉ có **10 nhánh**
isEqualToString: (close, closeApp, open, pair, fav, picker, layout, ratio,
swap, zoom) — khôi phục đủ 10 theo dump, không bịa nhánh 11.
- layout → `urlLayout:` đọc khóa `@"id"` (@0x7f14). Nhánh cũ gọi SAI
  openSetupLayout:apps: đọc khóa @"layout" → luôn 0. Đã thay.
- ratio → `urlRatio:` đọc `@"r"` double (@0x7f54); swap → `urlSwap` (@0x7f74);
  zoom → `urlZoomPane:` kèm phép kẹp csinc (pane ≤ 1 nâng thành 1,
  @0x7fb0–0x7fb4). Bốn handler url* trong +Zoom.m từ mồ côi thành có caller
  (SCPHooks.m:512/514/516/521).
- Hai lệch phụ: nhánh open thiếu khóa slot → gốc mặc định **−1** (@0x7d48 →
  0x7e18), bản cũ nhắn nil ra 0; dòng log dispatch của gốc in **toàn bộ
  userInfo** (@0x7c4c), bản cũ chỉ in action. Đã sửa cả hai.
- Khôi phục @try/@catch của khối: catch → SCPExceptionLog("yeu cau tu
  SpringBoard") (@0x80a8), ack `splitscreen.ack` post NGOÀI @try (@0x7e70).
  Comment "VERIFIED (read end-to-end)" sai đã thay bằng mô tả đúng.

## K2 — kênh knob-touch ô hosted nối sai handler (E2, block gốc 0x7b00)

Bản cũ gọi bridgeHandleTapped:(identifier) → remoteKnobTouch: mồ côi. Đã nối
lại theo dump: `[[SCPCarSplit shared] remoteKnobTouch:note.userInfo]` — đúng
handler, payload TOÀN BỘ userInfo (call @0x7b50; handler @0x2edfc đọc
index/phase/x/y) + @try/@catch SCPExceptionLog("AB_KNOB_TOUCH") (@0x7bc4).
bridgeHandleTapped: trở về đúng 1 caller (block tap).

## PiP (đọc, không sửa)

Chuỗi "%@ can't go picture-in-picture" chỉ tồn tại như KHÓA localization
trong Prefs bundle (Car.strings — có cả ở payload gốc lẫn project), không code
nào tiêu thụ (0 lời gọi OMCTr); popOutBlockReason: @0x20054 chỉ có 2 khóa chặn
và bản ta khớp. Không kết tội được ở vòng này.

## D6 phía Prefs — điểm neo ss_label (kết tội độc lập trên dump Prefs)

Bản sao ss_label phía Prefs nhân size×_unit đúng (phép nhân thuộc helper)
nhưng neo `center = pt` vô điều kiện. Dump PREFS (ss_label: va=0x4a504)
0x4a78c–0x4a79c: center.x = left ? pt.x + width/2 : pt.x (fmul 0.5 → fadd →
fcsel theo cờ left). Đã sửa bản Prefs (src + mirror):
`center = left ? (pt.x + fit.width/2, pt.y) : pt`. Bằng chứng compiled: thân
ss_label đã biên dịch có đúng mẫu fmov #0.5 → fmul → cmp cờ → fcsel → fadd →
setCenter:. (Phần kẹp bề rộng theo bounds khi maxWidth ≤ 0 của gốc là điểm
lệch riêng, ngoài phạm vi ghi chú D6 — chưa đụng.)
Phía xe: bản sửa D6 của agent riêng ĐÃ landed trước build cuối
(SSStartupView.m phía StartupScreen mtime 00:10 UTC, src = project identical)
nên nằm trong candidate này; SSStartupViewBuilders.m không đổi.

## ĐÍNH CHÍNH BẰNG CHỨNG (quan trọng — đọc trước khi trích dẫn §17)

Một discriminator tôi báo ở bản build đầu là RỖNG: "object SCPCarSplit còn 0
tham chiếu undefined tới CGRectValue". Các object của dự án KHÔNG hề mang
stub selector theo tên — mọi lời gọi đi qua _objc_msgSend +
NSSelectorFromString/selref, nên phép đếm đó cho 0 ở cả bản lỗi lẫn bản đúng.
Bằng chứng binary thay thế cho Lỗi B (đã kiểm trên object của candidate cuối):
thân verifySceneOfPane đã biên dịch chứa **2 lời gọi NSSelectorFromString**
(@"frame" cho đường đọc frame + @"backgroundSceneWithCompletion:" cho nhánh
retry), **0 lời gọi SCPGuarded**, 17 lời gọi objc_msgSend và các đệm
@try/@catch — đối lập hẳn thân cũ (2 lời gọi SCPGuarded, 0 NSSelectorFromString
trực tiếp). Cộng với chuỗi log format mới có mặt / format cũ biến mất trong
binary đóng gói và cơ chế đã chứng minh bằng log máy. Các discriminator còn
lại của §17 (applyUnit đọc trực tiếp lệnh máy, paneSize types, chuỗi mới,
parity, UUID) không bị ảnh hưởng.

# §17G — CỤM G (GPT Expanded Audit 09/11) — BẢN GỘP CUỐI

Hợp nhất từ s17g-draft.tmp.md (SplitScreen) + notes-G-prefs.md (Prefs) +
notes-G-startup.md (SpeedBubble/StartupScreen), do agent chốt hạ đối chiếu
lại toàn bộ trên đĩa trước khi build (xem mục "Đối chiếu lại" bên dưới).
Mọi mục dưới đây là KIỂM TRA TĨNH (source + disassembly object/binary);
không mục nào là kết quả chạy trên máy. Ma trận truy vết giữ nhãn
"đã kiểm tra tĩnh" — không ghi PASS hành vi.

## G1 (§2) applyUnit phía Prefs — ĐÃ ĐẠT SẴN, ĐÃ KIỂM TRA TĨNH LẠI

Prefs SSStartupView.m:595-603 đã đúng nguyên mẫu GPT từ vòng 3 chính, đối
chiếu lại đủ 4 điểm, không sửa: C array `UILabel *labels[8]` chứa 8 ivar —
cả hai NSArray (mảng dự phòng + literal chứa ivar nullable) đã bị xóa,
không còn arrayWithObjects:count: trong thân hàm; vòng lặp `if (!l)
continue;`; `l.layer.shadowRadius = 1.5 * unit;`;
`l.layer.shadowOffset = CGSizeMake(0, 0.5 * unit);` (điểm GPT bắt —
bản dựng cũ CGSizeZero — đã khôi phục). Comment tại chỗ dẫn va=0x48d4c,
cbz 0x48e74, fmul 0x48e5c-0x48e60. Bản StartupScreen là module khác,
không thuộc §2.
Quan sát ngoài phạm vi (không sửa, thiếu bằng chứng dump Prefs riêng):
factory nhãn ở Prefs SSStartupView.m:147-148 đặt shadowRadius 7 /
shadowOffset CGSizeZero, nhãn [INFERRED placement] — để vòng fidelity sau.

## G2 (§3) paneForView + loaderCancelTapped — ĐÃ SỬA + KIỂM TRA TĨNH

- SCPCarSplit.m paneForView: thêm guard `if (!view) return nil;` và
  `if (!pane.view) continue;` trước isDescendantOfView: (hợp đồng hậu duệ
  đã có từ Lỗi C). Caller audit (tĩnh): Drag.m:54, Panel.m:157,
  Picker.m:217/780/802/1025, Zoom.m:53/65/261, SCPCarSplit.m:3156/3181/3204
  (run* wrappers) — mọi caller truyền view/sender nằm trong cây pane.view;
  hai site fallback 780/802 truyền view của tray window (chết theo thiết
  kế, khớp gốc dùng cùng hợp đồng). Không caller nào cần đổi.
- SCPCarSplit+Picker.m loaderCancelTapped: khôi phục chuỗi xác thực đủ:
  pane tồn tại → pane.loader hiện hành tồn tại → [sender isDescendantOfView:
  loader] → bundle = loader.accessibilityIdentifier là NSString không rỗng
  → mới ghi cancelledLaunches + launchFailed:. CẤM fallback pane.bundleID
  (đã xác nhận không có dòng nào đọc pane.bundleID trong thân hàm — từ
  "pane.bundleID" chỉ xuất hiện trong comment giải thích việc cố ý không
  dùng). Phần pane/bundle nil khớp dump gốc 0x2b980 (cbz 0x2b9e8/0x2b9ec);
  hai mắt loader-membership + non-empty là guard theo lệnh GPT §3 (phòng
  thủ có chủ đích, cùng loại guard launchFailed).
- Kiểm tra tĩnh tầng object (SCPCarSplit.o): thân paneForView chứa
  isDescendantOfView:; thân launchFailed chứa đủ chuỗi slot → loader →
  accessibilityIdentifier → isEqualToString: → removeLoaderFromPane:
  animated: → vc → slotOccupied: → showPickerForSlot:.

## G3 (§4) launchFailed — ĐÃ KIỂM TRA TĨNH, KHÔNG SỬA THÊM

Trạng thái cây đã khớp §4 từ vòng 3 chính (agent chốt hạ đã đọc lại thân
hàm trên đĩa và xác nhận): điều kiện gỡ loader là OR (pane.slot == slot
|| loader.accessibilityIdentifier isEqualToString: bundle); sau gỡ chỉ
hiện picker khi !pane.vc && !slotOccupied(pane.slot) bằng slot của chính
pane; guard !bundleID đứng TRƯỚC removeObjectForKey: (guard GPT có chủ
đích); watchdog trong showLoaderInPane giữ check p.loader == weakLoader
(Picker.m) nên timeout của lần mở trước không dọn loader của lần mở mới.
Không sửa thêm ở vòng G.

## G4 (§5) paneSize — ĐÃ KIỂM TRA TĨNH, KHÔNG SỬA THÊM

Hợp đồng -(BOOL)paneSize:(CGSize *)outSize forBundle: đã đồng bộ ở
SCPCarSplit.h:165 + SCPCarSplit.m:1255 từ vòng 3 chính, thuật toán khớp
dump 0x1b328: !active/!bundle → NO; !container → NO; pane ? pane.slot :
pendingSlotForBundle:; slot < 0 → NO; MIN(w,h) >= 2; chỉ ghi *outSize
khi hợp lệ và outSize != NULL. Caller: Hook_sceneFrameForAppInfo
(SCPHooks.m:149 — chỉ thay frame.size khi YES, giữ origin) và sau G5 thêm
caller thứ hai Hook_safeAreaInsetsForAppInfo (SCPHooks.m:169) — đúng số
caller của gốc (đã đếm lại trên đĩa: chỉ 2 điểm gọi trong toàn module).

## G5 (§6) safe-area hook — ĐÃ SỬA + KIỂM TRA TĨNH

SCPHooks.m Hook_safeAreaInsetsForAppInfo viết lại theo dump 0x5e84: gọi
orig trước và giữ insets; SCPRealBundleForInfos; paneSize:&size
forBundle: → YES thì trả UIEdgeInsetsZero, NO giữ insets gốc; @catch ghi
SCPExceptionLog("safeAreaInsetsForAppInfo") và rơi về insets gốc. Comment
mô tả hành vi "clamped" không có thật đã bị xóa. ĐÍNH CHÍNH NHỎ so với
bản nháp: chữ "clamped" còn xuất hiện đúng một chỗ — trong comment ghi
lại việc xóa đó ("its \"clamped\" comment described behaviour that did
not exist") — không còn comment nào khẳng định hành vi clamped nữa.
Kiểm tra tĩnh tầng object (SCPHooks.o): thân hook tham chiếu
_UIEdgeInsetsZero và selref paneSize:forBundle:.

## G6 (§7) Home — ĐÃ SỬA + KIỂM TRA THỨ TỰ BẰNG DISASSEMBLY

- SCPCarSplit.h:198 + SCPCarSplit.m:1620: homePressedDuringSplit: đổi từ
  (BOOL)(id)event thành -(void)homePressedDuringSplit:(BOOL)wasActive
  (ABI gốc v20@0:8B16). Thân khôi phục theo dump 0x40298:
  dismissStuckBaseSoon khi wasActive HOẶC (currentBase tồn tại VÀ ==
  soloReturnedVC); LUÔN setSoloReturnedVC:nil sau đó (không return sớm);
  ignoreHomeOnce → xóa cờ; CHỈ KHI không ignore mới endHostedSolo nếu
  soloHostedBundle còn. (Agent chốt hạ đã đọc lại thân helper trên đĩa:
  điều kiện viết dạng `wasActive || (currentBase && currentBase ==
  self.soloReturnedVC)` — tương đương ngữ nghĩa cây rẽ nhánh của dump.)
- SCPHooks.m Hook_handleHomeEvent viết lại theo dump 0x601c.
- KIỂM THỨ TỰ GỌI BẰNG DISASSEMBLY (object SCPHooks.o của build vòng G):
  thân _Hook_handleHomeEvent đã biên dịch gọi theo thứ tự — msgSend
  `active` (kết quả giữ làm wasActive) → khi đúng: msgSend
  `closeGoingHome:` với w2 = #0 (NO) → msgSend `homePressedDuringSplit:`
  với x2 = wasActive, KHÔNG điều kiện → nạp con trỏ
  orig_DBDashboard_handleHomeEvent và blr CUỐI CÙNG bằng event thật;
  đường @catch (qua SCPExceptionLog "_handleHomeEvent") nối lại vào đúng
  điểm gọi orig. Thân helper đã biên dịch (SCPCarSplit.o) có cấu trúc rẽ
  nhánh khớp dump gốc: tbz wasActive → dismiss; cbz currentBase → bỏ qua;
  cmp + b.eq → dismiss; setSoloReturnedVC: (x2 = 0) nằm trên đường chung
  MỌI nhánh đều đi qua, trước điểm ret duy nhất ở cuối hàm; đuôi
  ignoreHomeOnce/setIgnoreHomeOnce:/soloHostedBundle/endHostedSolo đúng
  thứ tự gốc. (Kiểm tra tĩnh bằng disassembly — không phải kiểm chứng
  hành vi.)

## G7 (§8) Sổ P2 — 6 mục, mỗi mục một nhãn

- **P2-A (§8A) SPPBubbleView render — ĐÃ SỬA.** Gốc: render tail-call
  contentSize @0x158c8 → trả CGSize ({CGSize=dd}16@0:8); caller gốc
  -[SPPBubble renderBubble] @0x19cb0-0x19ce0 hứng d0/d1 đặt bounds card.
  Đã sửa: SPPBubbleView.m:72 khai báo -(CGSize)render; (khai báo nằm
  trong interface copy ở đầu .m — module này không có SPPBubbleView.h);
  thân :151 trả self.contentSize; SPPBubble.m:79 (interface copy trong TU
  caller) đồng bộ; caller :648 dùng CGSize trả về đặt bounds. Kèm theo,
  cùng hàm, bằng chứng dump trực tiếp: style ngoài miền (âm hoặc >8) rẽ
  về 0 (0x15870 tbnz sign / 0x1587c cmp 8, b.gt → x20=0) — bản cũ kẹp >8
  thành 8; đã sửa thành `if (style < 0 || style > 8) style = 0;`.
- **P2-B (§8B) sliderForKey:min:max:def:format:width: — ĐÃ SỬA.** Gốc
  (OMCCardPage.asm): types `@64@0:8@16q24q32q40@48d56` → min/max/def là
  NSInteger, width double. Đồ thị gọi đã kiểm toàn bộ: 1 declaration + 1
  implementation + 2 caller trong OMCSpeedBubbleController.m (:486
  min:60 max:220 def:100; :694 min:-10 max:10 def:5 — gồm khoảng âm của
  speedBubbleWarnOver); không cast objc_msgSend nào cho selector này.
  Đã đổi: OMCCardPage.h:31 + OMCCardPage.m:151-152 (double → NSInteger;
  bỏ cast thừa (NSInteger)def ở lời gọi intForKey).
- **P2-C (§8C) OMCAppBridgeAppsController num:def: — ĐÃ SỬA.** Gốc
  (va=0x215e4): types `q32@0:8@16q24` → trả NSInteger. Mọi caller trong
  cùng file (268, 391-395, 824, 873). Đã đổi: header :50 NSNumber* →
  NSInteger; thân :174 trả thẳng `v ? [v integerValue] : def`; caller
  268 + 391-395 bỏ .integerValue; 824 bỏ .floatValue; 873 bọc
  @([self num:key def:0]) cho indexOfObject:.
- **P2-D (§8D) ss_addMote:layer:to: / SSMote — ĐÃ SỬA.** Gốc (va=0x4a89c):
  types `v88@0:8{?=qdddddd}16@72@80` — trường đầu struct là int64
  (prologue `mov x21, x2`). Writer: 5 điểm dựng SSMote, kind luôn literal
  nguyên {0,1,2}; reader ss_applyMotes: chỉ so kind == 0/== 1; struct chỉ
  sống trong TU SSStartupView.m (Prefs); sizeof không đổi 56 byte. Đã
  đổi: SSStartupView.m (Prefs) :32 typedef thành
  `typedef struct { long long kind; double x, y, a, b, c, d; } SSMote;`
  kèm comment dẫn encoding gốc + va.
- **P2-E (§8E) ss_drawCanvas:size: — ĐÃ SỬA (chữ ký + caller).** Gốc
  (01a30c): tham số đầu (x2) được cbz kiểm nil @0x1a31c rồi truyền thẳng
  làm CGContextRef cho ss_drawParticles:t:/ss_drawFireworks:t:; thân
  không gọi UIGraphicsGetCurrentContext; drawRect: gốc (00c584) truyền
  UIGraphicsGetCurrentContext(), không guard riêng. Đã sửa
  SSStartupView.m (StartupScreen): khai báo :71, drawRect: :143, thân
  :967 — dùng ctx được truyền, bỏ dòng tự lấy context, giữ nguyên logic
  dispatch phía dưới. QUAN SÁT CÒN MỞ (không sửa, để vòng fidelity):
  dispatch trong thân gốc gate bằng ivar BOOL ==1 + hai ivar object
  (khả năng cao _particles/_bursts) thay vì proxy _sceneStyle 6/11
  [INFERRED] của bản ta — đã kiểm tra tĩnh tới đây, chưa đối chiếu tên
  ivar tới mức kết tội.
- **P2-F (§8F) applyUnit + constraint max-width (StartupScreen) — ĐÃ
  SỬA.** Chuỗi bằng chứng: objc.json — _stackMaxWidth là
  @"NSLayoutConstraint" (offset 152), _cardInsets là @"NSArray" (offset
  160); bản cũ khai ngược hai ivar. reload gốc (00c9f4, đuôi chung
  0xd360-0xd4a8): _stack setTranslatesAutoresizingMaskIntoConstraints:NO,
  tạo [widthAnchor constraintLessThanOrEqualToAnchor:self.widthAnchor
  constant:-16.0] lưu ivar slot 0xcf4 (= _stackMaxWidth), activate @[
  centerX, centerY, widthCap]. applyUnit gốc (00f110) @0xf2a8-0xf2bc:
  setConstant: -12*unit lên slot 0xcf4; nhánh weather subscript slot
  0xd00 (= _cardInsets): [0]/[1] → 5*unit, [2]/[3] → 3.5*unit. Đã sửa:
  SSStartupScreen.h:111 (_stackMaxWidth về NSLayoutConstraint *);
  SSStartupView.m (reload thêm khối pinning sau lời gọi builder ~:236-248;
  applyUnit :368 _stackMaxWidth.constant = -12.0*unit thay comment
  [NOT restored]; nhánh weather đổi subscript sang _cardInsets, giữ giá
  trị 5/5/3.5/3.5 + guard count); SSStartupViewScenesB.m:381 (buildWeather
  lưu 4 constraint vào _cardInsets + activateConstraints:_cardInsets).
- **Bổ sung §8F (lệnh coordinator, bằng chứng dump trực tiếp) —
  applyUnit StartupScreen cornerRadius — ĐÃ SỬA.** Gốc: 0xf568
  setCornerRadius: nhận d9 = 5.5*unit (fmul 0xf45c-0xf460, vết register
  0xf460→0xf568, không ghi đè ở giữa); bản ta ghi 5*unit. Đã sửa
  SSStartupView.m (StartupScreen) :387 thành 5.5 * unit (src + mirror).

## Marker build — ĐÃ ÁP ĐỦ CẢ HAI PHÍA

- CarPlay: SCPHooks.m SCPInitDashboardHooks — dòng log nạp module là
  "loaded into CarPlay [fixround3]" (SCPHooks.m:693).
- Preferences: bundle Prefs KHÔNG có dòng "loaded into ..." riêng; dòng
  nhận dạng build hiện hành của bundle là diagnostic [GPT-F] trong
  OMCRootListController.specifiers (phát một lần mỗi lần dựng
  specifiers). Đã gắn tag vào chính dòng đó, giữ nguyên phần còn lại:
  "[GPT-F] specifiers build [fixround3]: controller=%@ total=%lu
  features=[%@]" (OMCRootListController.m:57, src + mirror identical).
  Chuỗi "[fixround3]" vì vậy có mặt trong cả hai binary OmniCarPrefs và
  OmniCarSplitScreen của candidate.

## Ma trận truy vết TĨNH — paneForView
(mọi dòng: đã kiểm tra tĩnh theo đường code)
| Ca | Đường code | Kết quả tĩnh |
| Ô gốc (sender == pane.view) | isDescendantOfView: trả YES cho chính view đó | ra đúng pane |
| Host con trong ô | host nằm trong pane.view | ra đúng pane |
| Nút hủy lồng nhiều cấp (nút ⊂ card ⊂ loader ⊂ pane.view) | quan hệ hậu duệ đệ quy | ra đúng pane + đúng loader ở loaderCancelTapped |
| Nút ở ô 1/2 | duyệt allPanes, khớp theo cây chứa | ra pane của ô đó |
| View ngoài cây split | không pane nào chứa | nil → caller return sớm, không suy slot 0 |
| view == nil | guard đầu hàm | nil |
| pane chưa dựng view (pane.view == nil) | continue | bỏ qua pane đó |

## Ma trận truy vết TĨNH — launchFailed
| Ca | Đường code | Kết quả tĩnh |
| Đúng slot / sai bundle | pane.slot == slot khớp (OR) | gỡ loader của pane đó |
| Sai slot / đúng bundle | loader.accessibilityIdentifier isEqualToString: khớp (OR) | gỡ đúng loader |
| slot:-1 (watchdog) / đúng bundle | slot không khớp ô nào; bundle khớp | vẫn gỡ được loader (ca chết ở bản AND cũ) |
| Pane đã có VC | !pane.vc sai sau khi gỡ | không hiện picker chồng lên nội dung |
| Callback loader cũ sau khi đã có loader mới | watchdog check p.loader == weakLoader trước khi gọi | không gọi launchFailed cho loader mới |
| bundle == nil | guard GPT đầu hàm | return, không removeObjectForKey:nil |

## Ma trận truy vết TĨNH — paneSize + hai hook
Khẳng định tường minh: KHÔNG ca nào mặc định nhận kích thước ô 0.
Đường NO của paneSize khiến Hook_sceneFrameForAppInfo giữ nguyên frame
gốc và Hook_safeAreaInsetsForAppInfo giữ nguyên insets gốc.
| Ca | paneSize | Hệ quả tại hook |
| Split đang active, app có pane ở ô 1 | slot = pane.slot | YES → frame.size/insets theo ô 1 |
| App CHỈ có pending ở ô 1/2 | pane == nil → pendingSlotForBundle: trả slot pending (1/2) | YES theo kích thước ô pending — KHÔNG phải ô 0 |
| App ngoài split (không pane, không pending) | slot = -1 → NO | giữ frame/insets gốc |
| bundle == nil | guard đầu → NO | giữ frame/insets gốc |
| Split inactive | guard đầu → NO | giữ frame/insets gốc |
| frame ô < 2pt (min(w,h) < 2) | NO | giữ frame/insets gốc |
| outSize == NULL | không ghi, vẫn trả tính hợp lệ | hai hook luôn truyền &size hợp lệ |

## Ma trận truy vết TĨNH — Home
| Ca | Đường hook + helper | Kết quả tĩnh |
| wasActive = YES | hook: closeGoingHome:NO → helper(wasActive=YES) → orig | helper gọi dismissStuckBaseSoon theo nhánh wasActive; soloReturnedVC vẫn được xóa |
| wasActive = NO, currentBase == soloReturnedVC | helper nhánh so sánh pointer | dismissStuckBaseSoon chạy; soloReturnedVC xóa sau đó |
| wasActive = NO, currentBase nil/khác | không dismiss | soloReturnedVC vẫn xóa (không return sớm) |
| ignoreHomeOnce = YES | helper: xóa cờ, KHÔNG endHostedSolo | soloHostedBundle giữ nguyên cho lần Home sau |
| ignoreHomeOnce = NO + soloHostedBundle còn | helper: endHostedSolo | đúng thứ tự gốc |
| Ngoại lệ giữa hook | @catch → SCPExceptionLog | orig _handleHomeEvent: vẫn chạy cuối bằng event thật |

## Mirror + header SplitScreenB (agent chốt hạ kiểm lại trên đĩa)

- Mirror src↔project identical cho MỌI file cụm G chạm tới (đã cmp từng
  cặp): Prefs — OMCCardPage.h/.m, OMCAppBridgeAppsController.h/.m,
  SSStartupView.m, OMCRootListController.m (marker); SpeedBubble —
  SPPBubbleView.m, SPPBubble.m; StartupScreen — SSStartupView.m,
  SSStartupScreen.h, SSStartupViewScenesB.m; SplitScreen (src
  SplitScreenA = bản chuẩn của project) — SCPCarSplit.h, SCPCarSplit.m,
  SCPHooks.m; SCPCarSplit+Picker.m (src SplitScreenB = project). Ghi chú:
  SPPBubbleView không tồn tại file .h ở cả hai cây (khai báo render nằm
  trong interface copy đầu .m) — không phải lệch mirror.
- src/SplitScreenB/SCPCarSplit.h: THUỘC cây bàn giao (có mặt trong
  staging recovered-source/src/SplitScreenB/ và là header làm việc của
  các .m strand B), nhưng còn khai báo cũ. ĐÃ ĐỒNG BỘ: dòng 177
  `- (CGSize)paneSize:(NSInteger)slot forBundle:` →
  `- (BOOL)paneSize:(CGSize *)outSize forBundle:` (kèm comment ABI
  @0x1b328); bổ sung khai báo còn thiếu
  `- (void)homePressedDuringSplit:(BOOL)wasActive;` (ABI @0x40298).
  Bản SplitScreenA của cùng header vốn đã đúng cả hai khai báo.

## Build + cổng kiểm (agent chốt hạ, 09/11)

Toolchain đã kiểm trước build: clang-18 có mặt, /usr/bin/ld.lld →
ld.lld-18, ldid có mặt, SDK iPhoneOS16.5 nguyên vẹn (không rollback).
Build bằng build3.sh: clean TỪNG MODULE rồi make (tránh object cũ),
8/8 module exit 0, 0 error; đóng gói FINALPACKAGE=1. Candidate:
project/packages/com.anlai.omnicar_1.0.3-rebuilt-fixround3_iphoneos-arm64.deb
— 970.286 byte, SHA-256
752e39118354563cf65d4882a379619a70a634f274b8bfe05522cbbee16ae07a
(thay candidate 07:18, SHA c075bf37…). control Version giữ 1.0.3; tên
file mang tag vòng theo quy ước các vòng trước. Mọi cổng dưới đây chạy
trên DEB trích lại (arm64) + object .o MỚI của chính build này
(.theos/obj, mtime 00:51 UTC). Tất cả là kiểm tra tĩnh.

Cổng tầng binary (DEB trích lại):
- paneSize encoding `B32@0:8^{CGSize=dd}16@24` CÓ; encoding cũ dạng
  CGRect/CGSize-return KHÔNG còn. — ĐẠT
- homePressedDuringSplit encoding `v20@0:8B16` CÓ. — ĐẠT
- Marker CarPlay "loaded into CarPlay [fixround3]" trong
  OmniCarSplitScreen. — ĐẠT
- Marker Prefs "[GPT-F] specifiers build [fixround3]: …" trong
  OmniCarPrefs. — ĐẠT (chuỗi [GPT-F] thứ hai trong binary là diagnostic
  cellForRow có từ vòng trước, không thuộc dòng nhận dạng — giữ nguyên.)
- Rescue UTF-16LE: đủ 6 literal tiếng Việt của OMCRescueAnnounce trong
  OmniCarCore (dạng __ustring, không phải UTF-8). — ĐẠT
- [GPT-F] ×1 dòng nhận dạng đã gắn tag; MILESTONE ×8 (AppBridge);
  sharedApplicationLibrary ×2 (SplitScreen). — ĐẠT
- Selector parity (parser metadata/tools/macho_objc, gốc arm64 vs bản
  dựng arm64, gộp category theo target): 66 class — 61 exact-set,
  0 selector thiếu; 5 class cộng thêm duy nhất: SPPBubble
  (-hideIfShownWithReason:now:state:), SSStartupView-StartupScreen
  (2 helper festive), OMCSplitScreenController (-gestureSwitchChanged:),
  OMCStartupScreenController (+load — [W1], GPT đã duyệt), SSStartupView-
  Prefs (-gradientLayer). Khớp baseline prefsround, không regress. — ĐẠT

Cổng tầng object (disassembly .o của build này; resolve selref bằng
symtab + relocation của chính object):
- Lỗi A (Prefs applyUnit): thân hàm KHÔNG có arrayWithObjects:count:;
  có setShadowRadius:/setShadowOffset:. — ĐẠT
- Lỗi B (verifySceneOfPane): 2 lời gọi NSSelectorFromString, 17
  objc_msgSend; frame đọc qua NSSelectorFromString(@"frame") + msgSend
  trực tiếp sau respondsToSelector. ĐÍNH CHÍNH so với phụ lục §17: thân
  hàm còn ĐÚNG 1 lời gọi SCPGuarded — guard `scene.settings` (truy cập
  kiểu object, an toàn), KHÔNG nằm trên đường đọc frame; câu "0 lời gọi
  SCPGuarded" ở phụ lục là nói quá, bản chất discriminator giữ nguyên.
  — ĐẠT (kèm đính chính)
- G2 paneForView: thân chứa isDescendantOfView:. — ĐẠT
- G3 launchFailed: các selref nạp trong thân resolve đủ chuỗi slot /
  loader / accessibilityIdentifier / isEqualToString: /
  removeLoaderFromPane:animated: / vc / slotOccupied: /
  showPickerForSlot:, sau pending → removeObjectForKey: (guard nil ở
  source đứng trước). — ĐẠT
- G5 safe-area: thân hook gọi orig (BLR) TRƯỚC → SCPRealBundleForInfos →
  paneSize:forBundle: → tham chiếu _UIEdgeInsetsZero ×2. — ĐẠT
- G6 Home (kiểm THỨ TỰ bằng disassembly trên object của build này):
  Hook_handleHomeEvent: shared → active → closeGoingHome: (trước đó
  `mov w2, #0x0` = NO, sau `cbz w0` của wasActive) →
  homePressedDuringSplit: → BLR orig CUỐI CÙNG. Helper: SCPCurrentBase-
  ViewController → dismissStuckBaseSoon → soloReturnedVC →
  setSoloReturnedVC: → ignoreHomeOnce → setIgnoreHomeOnce: →
  soloHostedBundle → endHostedSolo. — ĐẠT
- E1/D5 relayout TU: TU thật được biên dịch SCPCarSplit+Relayout.o chứa
  layoutBarForPane: trong block relayoutAnimated:pushScenes:, theo sau
  là bringSubviewToFront:. — ĐẠT
- P2-A render: -[SPPBubbleView render] kết thúc bằng tail-branch msgSend
  tới contentSize (selref .12 = contentSize) — khớp tail-call @0x158c8
  của gốc. — ĐẠT
- §8F bổ sung: applyUnit (StartupScreen) có `fmov d0, #5.50000000` trên
  đường setCornerRadius:. — ĐẠT
- D6 giữ nguyên: SSStartupView.o (xe) tham chiếu
  _UIFontDescriptorSystemDesignRounded; chuỗi có trong dylib
  OmniCarStartupScreen của DEB. — ĐẠT

## Điểm còn mở sau vòng G (không chặn candidate)
- P2-E quan sát dispatch ss_drawCanvas (gate bằng ivar BOOL + 2 ivar
  object thay vì proxy _sceneStyle) — để vòng fidelity, chưa kết tội.
- Factory nhãn Prefs SSStartupView.m:147-148 [INFERRED placement] — chờ
  bằng chứng dump Prefs riêng.
- Phần kẹp bề rộng theo bounds khi maxWidth ≤ 0 ở ss_label phía Prefs
  (ngoài phạm vi ghi chú D6) — chưa đụng.
- Mọi ma trận ở §17G là "đã kiểm tra tĩnh"; hành vi thật chờ phiên test
  xe gộp theo tiêu chí nghiệm thu §17 + GPT §10.

# §18 — Vòng sửa 4 (fixround4, 2026-11-09)

Cơ sở: verdict thiết bị trên fixround3 (phiên 08:13–08:20, video
IMG_8163) + hai file kết tội của GPT trên log thô 0814 (adopt-vacated,
KVC) và picker (cây view) + Consolidated Repair Order (mục A–I, cổng
binary, §XII) + Deep Function Wiring Audit (N1–N6). Điều tra nội bộ:
work/fix-round4/convictions.md (chuỗi 1–4, (e), (f), (g)) và
audit-S-splash.md (LP-1/2/3). Năm nhánh sửa (fix-strand1..5) chạy song
song, một chủ sở hữu mỗi file; tích hợp + cổng kiểm bởi một agent chốt
hạ trên candidate đóng từ cây đã gộp. §I của Consolidated Order (các
sửa fixround3 đã đúng) được GIỮ NGUYÊN toàn bộ, không vá lùi điểm nào.

Ghi chú đặc tả E2 (recoverPending): đặc tả chữ ghi ==2; dump thô
@0x17618 ghi b.gt #2 — theo dump, GPT hiệu đính nếu khác. Cụ thể:
điều kiện retry trong bản giao là attempt <= 2 (terminal khi
attempt > 2) và giây trong log retry là attempt<<1 (0s/2s/4s), đúng
`cmp x21, #0x2; b.gt` + `lsl w8, w21, #1` đọc từ slice gốc và đã kiểm
lại trên object của build này (xem cổng E).

## Chuỗi launch/solo + native pane (Consolidated Order A–I)

- A — launchPhoneAppIfNeeded: — ĐÃ SỬA. Hợp đồng khôi phục: tham số
  là NSString bundleID trực tiếp (gốc @0x403d0); bỏ đường đọc
  applicationInfo/proxyApplicationInfo từ tham số; header khai
  (NSString *). Hook_launchAppWithInfo trích bundleIdentifier từ
  app-info object rồi truyền STRING (gốc @0x61d0); 
  Hook_launchInfoWithSettings và SCPCarLaunchApp vốn truyền string —
  giữ nguyên.
- B — ba nhánh solo trong cùng hàm — ĐÃ SỬA. active → openApp:bundle
  slot:-1; inactive + cùng solo bundle → trả consumed, KHÔNG
  endHostedSolo; inactive + bundle khác → endHostedSolo cũ trước,
  showSoloCoverForBundle:, hostSolo:.
- C — hostedApp:state: — ĐÃ SỬA. State machine khôi phục: solo ready
  → hideSoloCover + giữ app + RETURN (nhảy qua endHostedSolo); solo
  non-ready → log + endHostedSolo + hideSoloCover + RETURN; đường
  split non-ready có closeSlot:pane.slot background:NO ở đuôi
  (@0x3f5a0); membership được xác nhận trước khi callback chạm pane.
- D — adopt:slot: — ĐÃ SỬA (nhánh 1). Biến vacatedPane riêng gán
  trong vòng dọn duplicate; đuôi hàm chỉ showPickerForSlot: cho
  vacatedPane; giữ removePicker ở destination và early-return
  same-VC.
- E — recoverPending:attempt: — ĐÃ SỬA. Map đọc bằng valueForKey:
  trong @try/@catch + kiểm NSDictionary + đối chiếu bundle từng VC
  (nhánh 1); nhánh terminal khôi phục (nhánh 4 + micro-fix theo dump
  ở đầu §18): log danh sách VC dashboard đang giữ, toast, gọi
  launchFailed:slot: với slot đọc mới từ pendingSlotForBundle:.
- F — swapSlot:with: — ĐÃ SỬA. Giao dịch đầy đủ: guard a==b/ngoài
  miền; exchange slots; hoán focusedSlot; exchange fractions khi
  !mainStack && fractions.count == paneCount; duyệt SNAPSHOT
  pending.allKeys hoán slot GIỮ NGUYÊN timestamp; reindexPanes;
  rememberPair; rememberRecent; relayoutAnimated:YES.
  Slot 9: GIỮ KHÁC CÓ LÝ DO — dump không có nhánh slot-9 riêng; pane
  nổi không nằm trong `slots` nên guard paneCount là toàn bộ cơ chế.
- G — buildPickerSheetForPane: — ĐÃ SỬA (nhánh 1). Cây hai vùng:
  sideColumn (gridW, 0, 150.0, sheetH); wrapper/title/sub/cancel là
  con của sideColumn theo tọa độ local; wrapper x = (150 − mapW)/2;
  offset dọc 54.0; cancel center (120, 30); scrollView giữ ở
  contentView x=0. showPickerForSlot: frame origin (0,0) vốn đã đúng
  từ vòng 3. Điểm vào [self activate]: GIỮ KHÁC CÓ LÝ DO — rà toàn
  bộ 9 đường gọi, mọi đường đều guard active hoặc activate trước;
  thêm vào sẽ tạo tác dụng phụ tự bật split từ callback bridge.
- H — setFullscreenBridgeHidden:bundle: — ĐÃ SỬA. Đường solo khôi
  phục: soloHostedBundle nil → return; hidden == trayHidesBridge →
  return; cập nhật cờ; post appbridge.frame với CGRectZero khi ẩn /
  soloHostedFrame khi hiện, identifier solo, live=NO, handle=NO.
- I — paneForBundle: — ĐÃ SỬA. Thêm điều kiện pane.vc != nil trước
  khi so bundle (gốc @0x108ac). pendingSlotForBundle: giữ riêng.

## Cụm wiring (Deep Function Wiring Audit N1–N6) + thanh "..." (C3)

- N1 (= C3-4) bardismiss — ĐÃ SỬA. Block bardismiss gọi thẳng
  bridgeOutsideTouched (gốc @0x7a4c); route bridgeBarAction:@"dismiss"
  chết đã xóa. Các @"dismiss" còn lại thuộc kênh bàn phím AppBridge.
- N2 — refreshPickerSheet — ĐÃ SỬA (nhánh 5). Giữ pane đã chọn:
  found = sheetPane đã kiểm hợp lệ; chỉ khi found == nil mới quét
  reading order. Bản cũ kiểm xong bỏ kết quả, sheet nhảy về ô đầu tiên.
- N3 (= XI-2) layoutKnobOf: mainStack — ĐÃ SỬA (nhánh 4). Receiver
  convertPoint:fromView: là DIVIDER, kích thước từ divider.bounds
  (gốc @0x2c848/@0x2cdac). Lỗi knob này KHÔNG giải thích menu tỉ lệ
  tự đóng — hai đường riêng.
- N4 (= XI-1) clearPaneDragMarks — ĐÃ SỬA (nhánh 4). Thêm
  pane.view.layer.borderWidth = 0 trong vòng slots (helper gốc
  sub_132cc @0x27ef0), trước cover.alpha = 1.0. Thứ tự chụp
  target/ghost ở endPaneDrag:/cancelPaneDrag: đã kiểm — giữ nguyên.
- N5 — hideTrayWindowIfIdle — ĐÃ SỬA (nhánh 5). Thêm phép thử
  [window viewWithTag:0x5c9b] == nil (toast "Mở lại") làm điều kiện
  cuối trong chuỗi thoát sớm (gốc @0x28180/@0x28214).
- N6 — setBarVisible:forPane: — ĐÃ SỬA. (a)–(l) của vòng nghiệm thu
  nhánh 5: bản nhánh 3 đã tương đương; (m) completion VỪA BỔ SUNG:
  bốn lệnh đúng thứ tự gốc @0x24cbc (setHidden:YES → setAlpha: 1.0 →
  setTransform: → pushHostFramesLive:NO có cổng hai weak), BỎ guard
  `if (bar.alpha == 0)` mượn từ hideBarForPane: phía AB (hàm khác).
- C3-1 layoutBarForPane: — ĐÃ SỬA (nhánh 3). Scale bar theo bề rộng
  ô; nút Pop/Solo đổi icon + nhãn theo trạng thái (hm_split/"Chia
  màn" khi float hoặc đã zoom; hm_float/"Cửa sổ nổi"; hm_full/"Toàn
  màn"); xóa dòng INFERRED soloButton.selected.
- C3-2 setBarVisible: — ĐÃ SỬA (nhánh 3, hoàn thiện bởi N6(m)).
  Accent handle qua bản sao TU-local của SCPApplyAccent @0x293a0 —
  mức bằng chứng yếu hơn các mục khác (thân sub_24794 không có trong
  dump của cây; xem CÒN MỞ).
- C3-3 handleShift — ĐÃ SỬA (nhánh 3). Cộng vào trục X, Y giữ 12
  (gốc @0x23c1c).
- Instrumentation [do] — ĐÃ GẮN, không phải hành vi gốc: log điểm
  vào SCPBridgeHandleTapBlock; caller-id __builtin_return_address(0)
  ở đầu closePopups; hit-test shield ghi point + exempt + quyết định
  + toàn bộ rect miễn trừ; updatePopupShield ghi host/superview;
  dividerTapOn: ghi index vách + sắp mở/đóng. Mọi dòng gắn thẻ [do].
  Kèm khôi phục log CỦA GỐC "cham thanh ••• cua %@" trong ABHost
  handleTapped: TRƯỚC cú post (dump: log @0x15428, post @0x154b4) —
  đây là khôi phục, không phải instrumentation.

## Splash (audit-S: LP-1/2/3) — ĐÃ SỬA (nhánh 2)

- LP-1 reload: bỏ phép thử dữ liệu `if (self.weather)`; khôi phục
  suy ra style hiệu lực (11 → cổng occasion [1,6); 3 → có weather
  thì 3 không thì 2; clamp theo predicate mã máy: >= 10 và số âm →
  2) gán _sceneStyle; dispatch: == 3 mới buildWeather (category qua
  SSWeatherCategory lưu _sky — ivar này trước đây KHÔNG được gán ở
  bất cứ đâu trong cây), != 3 buildGreeting và nhảy qua buildWeather.
- LP-2 buildWeatherWithPeriod:: icon thời tiết về ivar _iconView
  (slot 0xcc4) ở đủ 8 chỗ; _logoView (0xccc) chỉ còn của logo chung.
- LP-3 applyUnit: đọc trọn dump cho thấy gốc rẽ theo label-presence
  (_timeLabel rồi _tempLabel) như bản ta — nhánh vốn đúng, chỉ sai
  hệ quả vì LP-1; siết duy nhất đuôi chung _stack.spacing = 3·unit
  thành có điều kiện (gốc chỉ tới được từ nhánh đã rẽ).

## Marker build [fixround4]

- SplitScreen/CarPlay: SCPHooks.m — "loaded into CarPlay [fixround4]".
- Preferences: OMCRootListController.m — "[GPT-F] specifiers build
  [fixround4]: …" (bundle Prefs không có dòng "loaded into" riêng,
  giữ mẫu vòng 3).
- AppBridge: module CÓ dòng log load sẵn — ABChannels.m constructor
  "build %s (%s) loaded into %@ [fixround4]" (gắn tag vào chính dòng
  đó; literal build "fbebb21" là stamp tĩnh của cây phục dựng, không
  đổi). Cả ba chuỗi đã kiểm có mặt trong binary tương ứng của
  candidate (strings: mỗi binary đúng 1).

## Mirror

cmp identical cho mọi cặp các nhánh đã đụng: Picker, SCPCarSplit.m/.h
(SplitScreenA), SCPHooks, Chrome, Divider, Layout, Drag, TouchWatch,
ABHostBMethods, SSStartupView.m + SSStartupViewScenesB.m
(StartupScreen), ABChannels, OMCRootListController.
src/SplitScreenB/SCPCarSplit.h: vẫn là header làm việc tiền-gộp của
strand B (15.763 B, mtime 00:49 — trước mọi nhánh vòng 4), khác bản
chuẩn SplitScreenA/project (21.622 B) — trạng thái đã ghi ở §17G,
staging bàn giao vẫn mang nguyên trạng; header B không khai
launchPhoneAppIfNeeded: nên không stale theo mục A. Không tự đồng bộ
bừa; chờ quyết định riêng nếu muốn dọn.

## Build + cổng kiểm (agent chốt hạ, trên candidate local)

Build sạch từng module (make clean + FINALPACKAGE=1, 8/8 exit 0,
0 error — bài học stale-object vòng liquidfix). Candidate local:
com.anlai.omnicar_1.0.3-rebuilt-fixround4_iphoneos-arm64.deb,
973.938 B, SHA-256
14e7976167c64aa1732e0367ed951694934ffd26ff89b0db0d5a92cb1ee4fe66;
member control.tar.gz + data.tar.lzma; control Version 1.0.3.
Cổng chạy trên CHÍNH candidate vừa trích + object của build này;
loại bằng chứng ghi từng cổng (bs = binary-string trên DEB đã trích,
bx = binary-structure trên object, so = source):

- A — ĐẠT (bx+so): thân launchPhoneAppIfNeeded: 0 selref
  applicationInfo/proxyApplicationInfo; gọi SCPIsHostedApp trực tiếp
  trên tham số; _Hook_launchAppWithInfo có respondsToSelector: guard
  + cfstring bundleIdentifier trong TU + send launchPhoneAppIfNeeded:.
- B — ĐẠT (bx+so): mov #-0x1 trước send openApp:slot:; cấu trúc ba
  nhánh đọc lại trên source khớp gốc; endHostedSolo/hostSolo: mỗi
  đúng 1 send.
- C — ĐẠT (bx): hostedApp:state: đủ endHostedSolo/hideSoloCover/
  removeLoaderFromPane:animated:/toast:; closeSlot:background: ở vị
  trí đuôi (sau toast:).
- D — ĐẠT (bx): adopt:slot: đúng 1 send showPickerForSlot:, nằm sau
  cả 2 send detachVC:background: của vòng dọn, liền trước
  relayoutAnimated:.
- E — ĐẠT (bx+bs): valueForKey: + cfstring
  "_entityIdentifierToViewControllerMap" trong dylib; terminal có
  launchFailed:slot:; `cmp x21, #0x2; b.gt` → terminal và
  `lsl w8, w21, #1` cho giây log (micro-fix theo dump đã biên dịch).
- F — ĐẠT (bx+so): đủ exchangeObjectAtIndex (load selref được clang
  gộp 1 lần cho 2 send — cả hai exchange đều có trên source),
  allKeys + setObject:forKeyedSubscript:, reindexPanes, rememberPair,
  rememberRecent, relayoutAnimated:.
- G — ĐẠT (bs+so): hằng double 150.0 có trong dylib + Picker TU;
  parenting sideColumn và các tọa độ (150−mapW)/2, +54.0, (120, 30)
  trên source theo offset dump.
- H — ĐẠT (bx+bs): thân hàm đủ soloHostedBundle/trayHidesBridge/
  setTrayHidesBridge:/soloHostedFrame/hostPost:info:, 0 lần
  paneForBundle:/sendHostFrameForPane:; dylib tham chiếu _CGRectZero.
- I — ĐẠT (bx): trong paneForBundle:, selref vc đứng TRƯỚC
  bundleID/isEqualToString: ở mọi vòng lặp.
- N1 — ĐẠT (bs+bx): dylib SplitScreen không còn cfstring "dismiss"
  độc lập; selref bridgeOutsideTouched có mặt; chuỗi kênh
  appbridge.bardismiss nguyên vẹn.
- N2 — ĐẠT (bx+so): refreshPickerSheet một điểm enumeration duy
  nhất, có guard cbz ở lối vào + cbnz bỏ-qua theo phần tử (mẫu gốc
  @0x31fd8); layout mã khác bản nhánh 5 do FINALPACKAGE — cấu trúc
  guard tương đương.
- N3 — ĐẠT (bs+so): selref bounds/convertPoint:fromView:/setCenter:/
  bringSubviewToFront: đủ; receiver divider chốt ở source + dump
  gốc (register-trace trên object không tách được receiver chỉ từ
  danh sách selref — caveat của nhánh 4 giữ nguyên).
- N4 — ĐẠT (bx): clearPaneDragMarks thứ tự view → layer →
  setBorderWidth: → cover → setAlpha: đúng dump @0x27e60.
- N5 — ĐẠT (bx): hideTrayWindowIfIdle có `mov w2, #0x5c9b` và chuỗi
  thoát tray → ratioMenu → pickerSheet → dragGhost → viewWithTag: →
  setHidden: đúng thứ tự gốc.
- N6(m) — ĐẠT (bx): block completion của setBarVisible (block_invoke
  .200) gửi đúng setHidden: → setAlpha: (fmov d0, #1.0) →
  setTransform: → pushHostFramesLive:, KHÔNG có fcmp (guard alpha
  cũ đã biến mất).
- Splash — ĐẠT (bs+so): _SSWeatherCategory biên dịch trong
  SSStartupView TU (bản sao per-TU như quy ước); discriminator đầy
  đủ của nhánh 2 (dispatch style==3, 8 tham chiếu _iconView / 0
  _logoView trong buildWeather) chụp trên object cùng source.

Mọi cổng trên là "đã kiểm tra tĩnh" — KHÔNG phải PASS hành vi.
Nghiệm thu thiết bị theo kịch bản gộp §18 dưới đây + Consolidated
Order (KIỂM LOGIC TRƯỚC GỬI THIẾT BỊ / MỘT PHIÊN NGHIỆM THU).

## Điểm CÒN MỞ sau vòng 4 (không chặn candidate)

- Chuỗi handle→bar phía HOSTED còn đúng 2 ứng viên chưa phân định
  được bằng dữ kiện tĩnh: (i) hit-test/recognizer tại handleHit lúc
  chạm; (ii) cú post handletap → bridgeHandleTapped:. Vòng này đã
  khôi phục log của gốc "cham thanh •••" + gắn instrumentation [do]
  ở điểm vào phía CarPlay để PHIÊN ĐO TIẾP THEO kết tội bằng log —
  không sửa mò (kết luận của convictions.md Chuỗi 2).
- Giả thuyết E-2 (menu tỉ lệ tự đóng 65–73 ms): đã khoanh vào
  hit-test của shield (tọa độ chạm mở menu nằm ngoài mọi rect miễn
  trừ; shield do chính showRatioMenu dựng tính là chạm-ngoài). Ba
  điểm log đã gắn (caller-id closePopups; point+exempt+rects trong
  hit-test; host của shield) — chờ số liệu phiên tới để chốt 100%.
  Thứ tự single-trước-double của dividerTapOn là CỦA GỐC (E-3),
  không sửa.
- Splash style 3: gốc còn chọn lại cặp gradient theo category
  (sub_d6f0 @0xd10c–0xd300) sau ss_sceneColors; bản ta chưa có —
  delta có từ trước vòng 4, chỉ ảnh hưởng màu nền style thời tiết.
- Hoán vị thứ tự khai báo _wetMask ở header StartupScreen (bản ta
  offset 376/trước _flash; gốc 424/sau _radar) — trung tính về hành
  vi (mọi truy cập qua offset tượng trưng), chưa đụng header.
- Helper accent sub_24794 (C3-2): thân không có trong dump của cây;
  bản khôi phục dựa trên giải mã ở báo cáo tích hợp — mức bằng chứng
  yếu, ghi rõ để không đọc nhầm thành đã kiểm từ mã máy.
- Các mục §17G còn mở giữ nguyên: quan sát dispatch-gate của
  ss_drawCanvas (P2-E); factory nhãn Prefs SSStartupView.m:147-148
  [INFERRED placement]; nhánh clamp maxWidth ≤ 0 của ss_label phía
  Prefs.
- Consolidated Order §XI.4 (geometry chuyển tiếp: origin âm / Home
  rect inf trước ổn định — không đặt launcher từ rect không hữu
  hạn) và §XI.5 (call-diff preview/style phía Prefs): mới là đầu
  mối rà, chưa kết tội, chưa sửa.
- CarPlayTemplateUIHost.ips (dashboard setShortCutButtons: phần tử
  nil) từ phiên prefsround: hệ quả hạ nguồn, chỉ theo dõi; nếu còn
  xuất hiện ở phiên vòng 4 sẽ mở lại.

DEVICE_TEST vòng 4 = PENDING. Bản FAT giao qua CI (macOS) được ghi
nhận tại handover/ACCEPTANCE_FIXROUND4.md với SHA-256/UUID trích từ
chính file đó.

## §18 bổ sung — nhóm N7–N14 (wiring audit cập nhật, 2026-11-09)

Đặc tả: OmniCar_Deep_Function_Wiring_Audit-2.txt mục 11–18; biên
bản sửa: work/fix-round4/fix-strand6.md. Patch đính kèm của audit
chỉ đọc làm đặc tả — tích hợp TAY từng hunk trên cây đã có nhánh
1–5, không git apply, không hoàn nguyên sửa mới nào.

- N7 appAreaInParent: (Layout) — ĐÃ SỬA: bỏ round-trip của content
  qua screen coordinate space và cú convertRect: gửi root
  CONTROLLER; khôi phục R = [parent convertRect:content.bounds
  fromView:content] (receiver = parent); content = probe
  "contentView" (fallback SCPMissingSelector) ?: host.view —
  fallback @0x11ebc trước đây còn thiếu. Khối dock giữ riêng:
  round-trip qua MỘT screen space ở cả hai đầu (parent.window.screen,
  nil thì dockView.window.screen). Nhánh dock không trả lời "view"
  nay gọi SCPMissingSelector(dock, @"view") như gốc @0x11fac.
- N8 afterPaneRemoved: — ĐÃ SỬA: receiver hỏi workspaceOwner là
  SCPDashboardObject() (helper gốc @0xe5b4 = _currentDashboard)
  thay vì root view controller; giữ timeout gỡ pending 2.0 s vô
  điều kiện của gốc (điểm đã loại mục 20 — không thêm
  launch-generation guard).
- N9 layoutBarForPane: — ĐÃ CÓ (nghiệm thu, không sửa): bản nhánh 3
  (C3-1/C3-3) khớp công thức gốc @0x23b9c từng phép — tâm handle
  (W/2 + shift, 12), scale = avail/barW khi barW > avail = W−10,
  tâm thanh 24 + barH·scale/2; nút Pop ô float DIM bằng alpha
  1.0/0.35 theo (vc != nil && paneCount < 3), gốc không có
  setEnabled: nào trong hàm. Kiểm chéo N6(m): snapshot transform ở
  nhánh ẩn đọc TRỰC TIẾP từ bar sau khi layout đã áp scale nên
  scale được giữ qua hide — ĐẠT.
- N10 addCoverToPane: — ĐÃ SỬA: thêm guard pane.vc != nil;
  cover.userInteractionEnabled YES → NO (@0x2a3d0); icon 44 → 52×52
  + SCPStyleGhostIcon + icon.tag = 77 (@0x2a450); bỏ
  bringSubviewToFront: cho pane.bar (gốc chỉ có một lần, cho
  handle); cover.alpha = 0 rồi animate 0.12 s lên 1. Consumer
  markDismissSlot: đã có sẵn viewWithTag:77 — hợp đồng khớp.
- N11 validSlot: — ĐÃ SỬA: thân hàm là return [self paneAtSlot:slot]
  != nil; (gốc @0x107cc). Bỏ công thức slot == 9 || 0 <= slot <
  paneCount vốn công nhận ô nổi chưa tồn tại. paneAtSlot: giữ
  nguyên, không tự tạo float pane.
- N12 raiseLauncher — ĐÃ SỬA: bỏ raiseView: trên launcherHost;
  khôi phục theo gốc @0x42900: button = homeButton; parent =
  button.superview (nil → dừng); parent == tabParent →
  raiseView:button; khác → chỉ khi button chưa là subviews.lastObject
  mới bringSubviewToFront:button.
- N13 remoteKnobTouch: — ĐÃ SỬA: toàn bộ thân hàm bọc @try/@catch;
  catch khôi phục đủ tail gốc @0x2f550–0x2f5c8: log "CarSplit: loi
  cham tron tu SpringBoard %@", sRemoteDragging = NO,
  markDismissSlot:-1, endResize, relayoutAnimated:YES. Block
  observer ở SCPHooks chỉ log — giữ nguyên theo đặc tả.
- N14 SCPMissingSelector — ĐÃ SỬA: prototype đổi (id, const char *)
  → (id, NSString *); cả ba literal của helper sang @"..."
  (@"_currentDashboard", @"rootViewController", @"contentView");
  giữ extern tại chỗ trong Layout.m (không import SCPShared.h vì
  xung đột hai helper static cùng tên trong TU). 4/4 call site nạp
  x1 từ cfstring object — hết nguy cơ crash ở chính nhánh ghi log
  thiếu selector.

## CI bị thay thế (ghi rõ)

Hai run CI 42549096386 và 42549107670 đã dispatch trên cây main
84cd742 / ci-fat-test a848c14 — cây CHƯA có nhóm N7–N14. Artifact
của hai run đó BỊ THAY THẾ, không được dùng làm bản giao. Candidate
local 14e79761… của lượt tích hợp trước cũng bị thay thế bởi
candidate mới dưới đây.

## Candidate + cổng (lượt nối lại — chạy lại toàn bộ, không chép cũ)

Build sạch từng module (make clean + FINALPACKAGE=1): 8/8 exit 0,
0 error. Candidate local mới:
com.anlai.omnicar_1.0.3-rebuilt-fixround4_iphoneos-arm64.deb,
974.398 B, SHA-256
fffbf0216f45437cd4ceaa2323fce2056dc97272d225445ac8584747f36c935b;
member control.tar.gz + data.tar.lzma; control Version 1.0.3.
Mirror tái kiểm: 15/15 cặp file vòng 4 identical (gồm 5 file nhánh
6: Layout, SCPCarSplit.m, Picker, Divider, Chrome); ngoại lệ duy
nhất giữ nguyên theo sổ: src/SplitScreenB/SCPCarSplit.h (header
lịch sử tiền-gộp).

Cổng trên candidate mới (bs = binary-string trên DEB đã trích,
bx = binary-structure trên object của build này, so = source):

- A — ĐẠT (bx): launchPhoneAppIfNeeded: 0 selref applicationInfo/
  proxyApplicationInfo; gọi thẳng _SCPIsHostedApp trên tham số;
  guard isKindOfClass:/length. Hook (A3): _Hook_launchAppWithInfo
  có CF"bundleIdentifier" trước send launchPhoneAppIfNeeded:.
- B — ĐẠT (bx): mov x3, #-0x1 ngay trước send openApp:slot: ở nhánh
  active; endHostedSolo/hostSolo:/showSoloCoverForBundle: mỗi đúng
  1 điểm nạp selref.
- C — ĐẠT (bx): hostedApp:state: đủ endHostedSolo/hideSoloCover/
  removeLoaderFromPane:animated:/toast:, closeSlot:background: ở
  vị trí đuôi sau toast:.
- D — ĐẠT (bx): adopt:slot: đúng 1 điểm nạp showPickerForSlot:, sau
  cả 2 điểm detachVC:background: của vòng dọn duplicate.
- E — ĐẠT (bx+bs): valueForKey: + CF"_entityIdentifierToViewControllerMap"
  + isKindOfClass:/allValues; terminal có VC-list "%@(%@ fullScreen=%d)",
  toast và launchFailed:slot: ở đuôi; cmp x21, #0x2; b.gt → terminal
  và lsl w8, w21, #1 (micro-fix E2 theo dump) có trong object.
- F — ĐẠT (bx): swapSlot:with: đủ paneCount guard,
  exchangeObjectAtIndex:withObjectAtIndex:, focusedSlot/
  setFocusedSlot:, mainStack + fractions/count, pending allKeys +
  snapshot copy, setObject:forKeyedSubscript:, reindexPanes,
  rememberPair, rememberRecent, relayoutAnimated:.
- G — ĐẠT (bs+so): double 150.0 có trong dylib đã trích và Picker
  TU; parenting sideColumn + tọa độ trên source theo offset dump.
- H — ĐẠT (bx+bs): setFullscreenBridgeHidden: đủ soloHostedBundle/
  trayHidesBridge/setTrayHidesBridge:/soloHostedFrame, post
  dictionaryWithObjects:forKeys:count: (identifier/x/y/w/h/live/
  handle) qua hostPost:info:, 0 lần paneForBundle:/
  sendHostFrameForPane:; dylib tham chiếu _CGRectZero.
- I — ĐẠT (bx): paneForBundle: selref vc đứng trước bundleID/
  isEqualToString: ở mọi bước enumeration.
- N1 — ĐẠT (bs+bx): dylib SplitScreen không còn chuỗi "dismiss"
  độc lập (0); SCPHooks TU không còn CF"dismiss"; selref
  bridgeOutsideTouched có mặt; bridgeBarAction:forBundle: chỉ còn
  caller baraction thật.
- N2 — ĐẠT (bx+so): refreshPickerSheet đúng 1 điểm enumeration,
  guard cbz/cbnz theo mẫu gốc; source found = sheetPane (Picker.m:287).
- N3 — ĐẠT (bs+so): layoutKnobOf: có bounds/convertPoint:fromView:/
  setCenter:; receiver divider chốt ở source + dump gốc (caveat
  register-trace của nhánh 4 giữ nguyên).
- N4 — ĐẠT (bx): clearPaneDragMarks thứ tự view → layer →
  setBorderWidth: → cover → setAlpha:.
- N5 — ĐẠT (bx): hideTrayWindowIfIdle đủ chuỗi tray → ratioMenu →
  pickerSheet → dragGhost → viewWithTag: (mov w2, #0x5c9b) →
  setHidden:.
- N6(m) — ĐẠT (bx): completion block .200 của setBarVisible: gửi
  đúng setHidden: → setAlpha: → setTransform: →
  pushHostFramesLive:, không fcmp nào trong block.
- N7 — ĐẠT (bx+so): appAreaInParent: có CF"contentView" + fallback
  SCPMissingSelector tại chỗ, convertRect:fromView:, CF"view" cho
  fallback root.view; cặp coordinateSpace chỉ còn ở khối dock.
- N8 — ĐẠT (bx+so): afterPaneRemoved: dùng SCPDashboardObject()
  (source, kèm chú thích helper @0xe5b4), CF"workspaceOwner" +
  CF"activeBaseApplicationBundleID" trong object; helper root VC
  không xuất hiện trong thân hàm này.
- N10 — ĐẠT (bx): addCoverToPane: (0x0–0x3ec của Picker TU): guard
  vc trước dựng cover; setUserInteractionEnabled: nạp w2 = #0x0;
  _SCPStyleGhostIcon được gọi; immediate 52.0 (0x404a000000000000);
  setTag: nạp w2 = #0x4d (77); bringSubviewToFront: đúng 1 điểm,
  sau selref handle; setAlpha: → animateWithDuration:animations:,
  double 0.12 có trong TU.
- N11 — ĐẠT (bx): validSlot: đúng 1 lời gọi paneAtSlot: rồi
  cmp/cset ne trên kết quả.
- N12 — ĐẠT (bx): raiseLauncher chuỗi homeButton → superview →
  tabParent → subviews/lastObject → bringSubviewToFront: +
  raiseView: (mỗi đúng 1 điểm nạp); không còn selref launcherHost.
- N13 — ĐẠT (bx+bs): remoteKnobTouch: có _objc_begin_catch; vùng
  catch chứa CF"CarSplit: loi cham tron tu SpringBoard %@" →
  markDismissSlot: → endResize → relayoutAnimated: đúng thứ tự;
  chuỗi log có trong dylib đã trích (1).
- N14 — ĐẠT (bx): Layout TU đúng 4 call site _SCPMissingSelector,
  cả 4 nạp x1 từ l__unnamed_cfstring_ và resolve ra
  rootViewController / contentView / view / _currentDashboard —
  4/4 là NSString object, 0 C literal.
- Splash — ĐẠT (bs+so): reload có cmp #0x3/#0xb (style), store
  _sceneStyle + _sky, SSWeatherCategory là bản sao static per-TU
  (bảng tra của nó có trong object; hàm được inline ở bản
  FINALPACKAGE); buildWeatherWithPeriod: chạm _iconView, 0 lần
  _logoView.
- Marker — ĐẠT (bs): mỗi binary SplitScreen / Prefs / AppBridge
  trong candidate chứa đúng 1 chuỗi [fixround4] ở dòng log load.

Mọi cổng vẫn là "đã kiểm tra tĩnh" — không phải PASS hành vi.
DEVICE_TEST vòng 4 vẫn PENDING; nghiệm thu trên bản FAT cuối tại
handover/ACCEPTANCE_FIXROUND4.md.

## Fix round 5 (2026-11-09) — §19: trạm cuối thanh phía host (C-A/C-B) + playIntro

Nguồn kết tội: log phiên fixround4 trên xe
(work/device-log-20261109-fixround4/OmniCar.log, 2.310 dòng) +
audit-chain2-zorder.md + audit-S2-greeting-geometry.md.

### 19.1 Chuỗi 2 — thanh "..." phía hosted: gãy ở ABHost setBarVisible phía SpringBoard

Runtime minh oan hai ứng viên cũ: 'cham thanh •••' 73 lần phía
SpringBoard, '[do] bridge handletap' 73 lần phía CarPlay — khớp 1-1
từng bundle (Nuvio 28 / Facebook 15 / TikTok 30, trễ ~3 ms); trạng
thái thanh phía CarPlay mở thật (2 dòng 'dong popup' ghi 'thanh co':
09:38:53.667, 09:43:41.026). Z-order SẠCH (scene chèn index 0 đúng
một lần; layoutBarForPane nâng bar + handleHit ở mọi lần áp) và
TOGGLE là hành vi gốc (bridgeHandleTapped: @0x3f65c truyền nguyên
isHidden làm visible) — hai mục ĐÃ KHỚP, không sửa.

Gãy ở hàm áp trạng thái thanh phía host — gốc
`-[ABHost setBarVisible:pop:dim:single:forApp:]` @0x11868; bản ta
ABHostBMethods.m (project/OmniCarAppBridge + src/AppBridgeB, mirror
identical sau sửa):
- **C-A — cực điều kiện chuyển trạng thái bị ĐẢO (CHẮC, dump):**
  gốc chỉ hành động khi isHidden == visible (0x11abc isHidden →
  0x11ac0 cmp w23,w0 → 0x11ac4 b.ne về đuôi return; cbz w23 →
  hideBarForPane:). Bản ta chép `if (bar.isHidden != visible)`:
  thanh sinh ra hidden=YES (buildBarForPane: @0x10eb4 — khớp) nên
  lệnh HIỆN (1 != 1 = false) không bao giờ tới nhánh hiện; lệnh ẨN
  cũng không. Đã sửa về equality; giữ nguyên pop/dim/single,
  accent, layout và thân hai nhánh. Comment đầu hàm viết lại kèm
  offset bằng chứng (comment 'VERIFIED' cũ là nhãn giả — không có
  offset của guard).
- **C-B — block entrance thiếu khôi phục alpha (CHẮC, dump):**
  chu trình alpha gốc: sinh ra 0 (@0x10ebc); block entrance
  sub_125C0 @0x125d4 `fmov d0,#1.0 → setAlpha:` TRƯỚC setTransform:;
  completion nhánh ẩn sub_12844 cố ý KHÔNG khôi phục alpha. Bản ta
  chỉ có `bar.transform = orig` trong block — alpha kẹt 0 vĩnh viễn
  dù sửa riêng C-A. Đã thêm `bar.alpha = 1;` làm lệnh đầu của block
  animations nhánh hiện; không thêm vào completion nhánh ẩn.
- Họ lỗi: hai hàm TRÙNG TÊN setBarVisible ở hai module (CarPlay
  `setBarVisible:forPane:` — đã derive lại vòng 3 + nghiệm thu N6;
  host `setBarVisible:pop:dim:single:forApp:` — chưa ai trace thân
  cho tới audit này). Bài học D6 lặp lại: cổng call-site/hằng số
  không thay được trace THÂN hàm/block; cổng vòng 4 kiểm chuỗi
  handle/post/state nhưng không derive lại cực điều kiện này.

### 19.2 playIntro (StartupScreen) — phục hồi đủ 3 nhánh logoEffect

Audit-S2 §4 kết tội biến thể gộp INFERRED (parked từ D3): scale đầu
0.8 / spring damping 0.7 cho mọi trường hợp + quầng ghi chết (bán
kính 32, opacity 0.8, trắng, giữ thường trực) ghi đè 7·s đúng
chuẩn của layoutSubviews. Phục hồi theo dump @0xf768
(fix-playintro.md): nguồn chọn là property logoEffect (SSSplash.m
gán từ pref startupScreenLogoEffect, mặc định @0), mọi hằng đọc
trực tiếp từ __TEXT/__const của gốc:
- ==1: scale đầu 0.5; spring duration 1.1, delay 0.1, damping 0.7,
  velocity 0, options 0; block: alpha 1 + transform identity.
- ==2: identity; bóng trắng / offset zero / radius 7·max(_unit,1) /
  model opacity 0.6f đặt TRƯỚC animation; CABasicAnimation
  shadowOpacity from NSNumber 0.0 tới 0.95, duration 1.2,
  autoreverses, repeatCount HUGE_VALF, EaseInEaseOut, key ssGlow;
  fade alpha về 1 trong 0.9 s.
- còn lại: scale đầu 0.96; animate 1.2 / delay 0.05 / options 0;
  block: alpha 1 + identity.
ĐÍNH CHÍNH hằng của audit-S2 §4: 0.86 damping + 0.92 scale thuộc
SPRING CỦA NHÁNH SCENE (đuôi !logoView @0xfccc–0xfcdc), không thuộc
nhánh logoEffect==1 (bộ hằng riêng 0x28ec8/0x28ed0/0x28e10). Sửa
đồng bộ project/OmniCarStartupScreen + src/StartupScreen (mirror
identical).

### 19.3 Cổng vòng 5 trên candidate local (đo trên binary trích từ chính candidate)

Candidate: com.anlai.omnicar_1.0.3-rebuilt-fixround5_iphoneos-
arm64.deb, 974.536 B, SHA-256
bf1a1438c4030a2d84a8bcf6dab4c9a2f272e3bc3140093c80a5672d14ca35e0,
control Version 1.0.3. Build: kiểm toolchain trước (đủ, không cần
fix-toolchain.sh), make clean từng module ×8 rồi root make package.
- (a) host-bar — ĐẠT (binary-structure): trong dylib AppBridge của
  candidate: `-[ABHost setBarVisible:pop:dim:single:forApp:]`
  imp 0xae58 — 0xb0e0 selref isHidden → 0xb0ec `cmp w0, w22`
  → 0xb0f0 `b.ne 0xb24c` (epilogue/ret); fall-through 0xb0f4
  `tbz w22` → 0xb12c → hideBarForPane:, còn lại setHidden:0 (nhánh
  hiện). Block entrance @0xba7c (adr từ nhánh hiện trong hàm):
  ldr thanh [x0,#0x20] → selref setAlpha: → 0xba9c
  `fmov d0,#1.00000000` → msgSend → dựng lại transform → selref
  setTransform: → msgSend. Alpha TRƯỚC transform kèm fmov 1.0 —
  đúng thứ tự gốc.
- (b) playIntro — ĐẠT (binary-structure): playIntro [0xe268,0xe868)
  trong dylib StartupScreen của candidate: selref logoEffect →
  0xe32c `cmp x0,#0x2` b.eq (nhánh 2) → 0xe334 `cmp x0,#0x1` b.ne
  → fallthrough 0xe6a8; tập hằng hàm {0.05, 0.1, 0.5, 0.6f, 0.7,
  0.9, 0.95, 1.1, 1.2, 7.0} đủ bộ; 32.0 và 0.8 vắng ở mọi dạng nạp
  (fmov/literal/movk); setShadowRadius: đúng 1 lời gọi thật —
  0xe4c4 `fmov d0,#7.0` → 0xe4c8 `fmul d0, d8, d0` → msgSend
  (dòng 'setShadowRadius:' thứ hai ở 0xe4ec là chú thích lệch
  thanh ghi của objdump — lời gọi thật ở đó nạp float literal
  0x269d0 = 0.6f, tức setShadowOpacity: model); setRepeatCount:
  nạp `mov w8,#0x7f800000 → fmov s0` @0xe5cc.
- (c) marker — ĐẠT (binary-string): [fixround5] có trong dylib
  SplitScreen ('loaded into CarPlay'), binary Prefs ('[GPT-F]
  specifiers build') và dylib AppBridge ('build %s (%s) loaded
  into %@'); literal fbebb21 giữ nguyên.
- (d) hồi quy — ĐẠT (binary-string/bytes): chuỗi 'cham thanh' còn
  trong dylib AppBridge (dạng UTF-16LE, 1 điểm); hằng double 150.0
  (picker) còn trong dylib SplitScreen (1 điểm).
Mọi cổng vẫn là 'đã kiểm tra tĩnh' — không phải PASS hành vi.

### 19.4 Đối chiếu chéo với GPT (độc lập)

GPT bàn giao findings riêng sau phiên xe fixround4
(user/files/OmniCar_Fixround4_Log_and_Hosted_Bar_Findings.txt):
kết luận độc lập KHỚP C-A/C-B — cùng chỉ ra nhánh compare phải
skip khi hidden != visible và block show phải có setAlpha:1 +
transform (mục H của GPT ghi kiểm binary: 'nhánh compare phải
skip khi hidden!=visible; block show phải có setAlpha:1 và
transform' — trùng đúng cổng (a) ở 19.3) — và KHỚP toàn bộ hằng
playIntro (bảng §G của GPT, đọc từ raw bytes gốc: 0x28ec8=1.1,
0x28ed0=0.1, 0x28e10=0.7, 0x29424 float 0.6, NSNumber 0.0/0.95,
0x28eb0=1.2, 0x28e70=0.9, 0x28eb8=0.96, 0x28ec0=0.05; gồm đính
chính damping nhánh logo spring là 0.7 và 0.86 thuộc nhánh
scene). Patch thanh của GPT (OmniCar_Fixround4_Hosted_Bar.patch —
sửa hai lỗi B+C trên cả project/OmniCarAppBridge + src/AppBridgeB,
đầu vào 16f3125) đã đối chiếu: nội dung trùng với sửa C-A/C-B đã
có trong cây — không áp thêm, không xung đột.

### 19.5 Còn mở sau vòng 5

- **playIntro phía PREFS (CHƯA CÓ TRONG CANDIDATE NÀY):** bản xem
  trước trong Cài đặt (gốc @0x493a4) cũng có nhánh spring
  1.1/0.1/0.7 (hằng gốc 0x65ba0/0x65748/0x65700 — GPT §G) nhưng
  bản preview của ta đang mang giá trị khác. Một fixer riêng đang
  sửa (work/fix-round4/fix-playintro-prefs.md). Candidate ở 19.3
  được build TRƯỚC khi sửa Prefs đáp xuống → CHƯA gồm mục này;
  chờ quyết định build lại rồi mới dispatch CI/đóng bản FAT
  fixround5 chính thức. Không giao bản thiếu.
- Đuôi !logoView của playIntro gốc (@0xf8c4–0xfcf8): ba slot ivar
  0xcb0 / 0xcc0 / 0xcc8 chưa ánh xạ được sang tên ivar với độ
  chắc đủ để sửa an toàn (bản ta vẫn là biến thể cũ: _t0/_playing
  + ss_applyTime:/ss_startLink không guard + không hoạt ảnh
  scene). Nhánh không tới được sau reload (reload tạo _logoView
  vô điều kiện) — để vòng branch-fidelity riêng, cùng hai reset
  của clearContent (_unit/_sceneStyle) ghi ở D3.
- Chuỗi 2 đóng khi test xe fixround5 đạt mục thanh hosted; nếu
  thanh vẫn không hiện sau vòng 5, điểm đo tiếp theo là thêm log
  [do] trong ABFrameBlock (chưa thêm trước).
### 19.6 Lượt build gộp cuối vòng 5 — playIntro Prefs vào candidate (ĐÃ SỬA)

Fixer Prefs (work/fix-round4/fix-playintro-prefs.md) khôi phục
playIntro phía Cài đặt theo dump gốc @0x493a4: e1 spring
1.1/0.1/0.7 + scale đầu 0.5; e2 shadow trắng offset zero /
radius 7·max(_unit,1) / model opacity 0.6f + glow 0.0→0.95
trong 1.2 s (autoreverses, HUGE_VALF, key ssGlow) + fade
0.9 s; else scale 0.96 / 1.2 s / delay 0.05. ĐUÔI !logoView
phía PREFS sửa được trọn vì bảng ivar của binary Prefs ánh
xạ chắc (_unit 8 / _stack 16 / _logoView 24 / _posterView
32 / _sceneStyle 168 / _t0 256 / _playing 264 / _link 272):
_t0 = CACurrentMediaTime() gọi thẳng, _playing = YES,
ss_applyTime:/ss_startLink chỉ khi _sceneStyle >= 0, đích
_stack ?: _posterView, translation 6·u, scale 0.92, spring
0.9/0.05/0.86. Mirror project/OmniCarPrefs ↔
src/Prefs/OMCPrefs identical.

Candidate ship vòng 5 (build lại sạch từng module ×8 sau
khi fix Prefs đáp, root make package FINALPACKAGE=1):
com.anlai.omnicar_1.0.3-rebuilt-fixround5_iphoneos-arm64.deb,
974.214 B, SHA-256
146e26572fbd040de4bc0e5dee1429a00cbe166d0152ab3a9cde5d22d0a51437,
control Version 1.0.3 — THAY candidate lượt 1 ở 19.3
(bf1a1438…, giữ làm đối chứng cổng). Đối chiếu từng binary:
7/8 byte-identical với lượt 1; chỉ binary Prefs thay đổi —
đúng phạm vi sửa.

Cổng trên candidate ship (đo trên binary trích từ chính
candidate; selector nhận diện qua selref literal →
__objc_methname, khớp 5/5 slot đối chứng của 19.3):
- (a) host-bar — ĐẠT (binary-structure): như 19.3, đo lại
  trên file mới (imp 0xae58; selref isHidden → cmp w0,w22
  @0xb0ec → b.ne về epilogue 0xb24c; tbz w22 → nhánh ẩn
  0xb12c; nhánh hiện setHidden: w2=0; block entrance 0xba7c:
  fmov d0,#1.0 @0xba9c → setAlpha: → setTransform:).
- (b) playIntro xe — ĐẠT (binary-structure): như 19.3
  (logoEffect; cmp #2 b.eq @0xe32c; cmp #1 b.ne @0xe334;
  đủ tập hằng; vắng 32.0/0.8; setShadowRadius: +
  setRepeatCount:; fmov 7.0).
- (b2) playIntro PREFS — ĐẠT (binary-structure): imp
  0x52c14, cửa sổ [0x52c14, 0x53518): logoEffect được gọi;
  ba nhánh ở dạng cmp của bản release — cmp #1 @0x52d60
  b.ne → 0x52e74, tại đó gọi lại logoEffect rồi cmp #2
  b.ne → 0x531b4, else là fallthrough (dạng subs #1/#2 là
  mã hoá ở object debug của fixer; bản đóng gói dùng cmp
  như phía xe ở cổng (b) — cùng cấu trúc ba nhánh); tập
  hằng hàm {1.1, 0.1, 0.7, 0.6f, 0.95, 1.2, 0.9, 0.05,
  0.96, 0.92} đủ (kèm 0.86 damping nhánh scene, 6.0 hệ số
  translation, 7.0 hệ số radius — đúng dump Prefs); VẮNG
  {32.0, 0.8f, 1.6, 0.15} ở mọi dạng nạp.
- (c) marker — ĐẠT (binary-string): như 19.3.
- (d) hồi quy — ĐẠT (binary-string/bytes): như 19.3.
Tổng 29/29 phép kiểm tĩnh ĐẠT trên candidate ship. Vẫn là
'đã kiểm tra tĩnh' — không phải PASS hành vi.

Còn mở sau vòng 5 (cập nhật, thay danh sách ở 19.5):
(1) đuôi !logoView của playIntro phía XE (@0xf8c4–0xfcf8)
— ba slot ivar 0xcb0/0xcc0/0xcc8 chưa ánh xạ chắc, để vòng
branch-fidelity riêng cùng hai reset clearContent ghi ở
D3 (phía Prefs đã sửa trọn ở mục này); (2) phần tử tròn ở
mép phải màn hình trong ảnh phiên fixround4 — chưa định
danh được từ log, chưa đủ căn cứ sửa máy trạng thái bong
bóng (khớp kết luận GPT); (3) Chuỗi 2 đóng khi test xe
fixround5 đạt mục thanh hosted; nếu thanh vẫn không hiện,
điểm đo tiếp theo là thêm log [do] trong ABFrameBlock.

## 20) VÒNG 6 — CỔNG SUY HƯỚNG BIT-2 BỊ ĐẢO Ở CẢ HAI PHÍA (2026-11-09)

### 20.1 Thu hồi verdict của audit-zoomrotate ở cổng host
Sau phiên fixround5, GPT đọc lại DEB gốc cả hai slice và bắt
được lệnh quyết định tại phép suy requestedOrientation của
-[ABHost appWithHash:changedOrientation:supportedMask:]:
arm64 0xf860 cmp x8,#0 (x8 = mask & 2) rồi 0xf864
`csel x8, xzr, x9, ne` — bit 2 CÓ mặt thì chọn 0, VẮNG mới
giữ hướng đã tính x9. Audit-zoomrotate đã đọc đúng đại số
ưu tiên (4>3>2) nhưng đọc NGƯỢC cực của chính lệnh csel
này và kết luận "khớp" — verdict đó ở cổng host BỊ THU HỒI.
Kiến trúc hai kênh (khung / hướng) không đổi; lỗi thuần là
cực của cổng: derived = (mask != 0 && !(mask & 2)) ?
ưu_tiên(mask) : 0. Log fixround5 phù hợp nhánh dựng ngược
(YouTube mask 24 -> 'scene huong 1' ~20 lần do fallback về
hướng pane; TikTok mask 30 -> 4).

### 20.2 Hai hàm cùng đảo một cổng — đã sửa cả hai
(a) Host, ABHostBMethods.m appWithHash: cổng cũ
`mask != 0 && (mask & 2)` -> sửa thành
`mask != 0 && !(mask & 2)`; thân ưu tiên giữ nguyên.
(b) App, ABInApp.m ABOrientationDerivedFromMask: lệnh cuối
cũ `if (!(mask & 2)) v = 0;` -> sửa thành
`if (mask & 2) v = 0;` — cùng mẫu csel của gốc tại sub_5734
@0x57c0–0x57c4 (tst w0,#2; csel x9, xzr, x8, ne); comment
ghi ngược trên hàm cũng đã sửa. Bảng truy vết
(changed = 255): mask 24 gốc 4 / cũ 0 / mới 4; mask 26 gốc
0 / cũ 4 / mới 0; mask 30 gốc 0 / cũ 4 / mới 0; mask 0 và 2
ra 0 ở cả hai phía mới.

### 20.3 Kiểm hook phía app — kết luận (a): HẠ nghi vấn
Audit work/fix-round5/audit-inapphook.md: đăng ký hook
requestGeometryUpdateWithPreferences: khớp gốc (đích
objc_getClass("UIWindowScene"), cổng OMCHasMethod, không
lệch metaclass — tiền sử metaclass thuộc hai setter FPS,
không liên quan); installer chạy trọn trong cả 5 app host
của phiên. Dòng 'app xin huong' là log CỦA GỐC, nằm trong
nhánh có hai cổng (ABForcedOrientation >= 1 và preferences
respondsToSelector interfaceOrientations) và chỉ phát khi
app TỰ gọi API scene-geometry; phiên fixround5 không app
nào gọi API đó — mọi yêu cầu xoay đi đường VC/sentinel
ma 255 (44 dòng 'bao SpringBoard' chứng minh kênh
debounce + publish + Darwin phía app sống). Vắng dòng log
vì thế là bình thường theo điều kiện nhánh, KHÔNG chứng
minh hook trượt. Điểm trung thực: chưa từng có mẫu dương
trong bất kỳ log nào đã thu; kết luận dựa trên đối chiếu
tĩnh từng lệnh. KHÔNG sửa hook ở vòng này.

### 20.4 Cổng trên candidate vòng 6 (đo trên binary trích từ candidate)
Candidate local com.anlai.omnicar_1.0.3-rebuilt-fixround6
_iphoneos-arm64.deb: 974.666 B, SHA-256 934e76df… (bản đầy
đủ ở ACCEPTANCE_FIXROUND6), Version 1.0.3.
- (g1) cổng host — ĐẠT (binary-structure): appWithHash imp
  0x6b64; dãy suy tại 0x6ce8–0x6d20 ở dạng csel như gốc:
  and #2 -> x8; (mask>>1)&2; tst #8 -> 3; tst #0x10 -> 4;
  quyết định 0x6d0c cmp x8,#0 + 0x6d10
  `csel x8, xzr, x9, ne` (bit 2 có mặt -> 0); mask==0 -> 0
  tại 0x6d14–0x6d18; changed==0xFF chọn derived tại
  0x6d1c–0x6d20. Truy vết: 24->4, 26->0, 30->0.
- (g2) cổng app — ĐẠT (binary-structure): phép suy tại
  0x14d84–0x14da8 (hàm chứa hook scene-geometry): ưu tiên
  lsr/and -> 3 -> 4; lệnh cuối 0x14da4 `tst x0, #2` +
  0x14da8 `csel x9, x8, xzr, eq` — bit vắng (eq) giữ giá
  trị đã tính, bit có mặt (ne) lấy xzr = 0; tương đương
  nguyên lệnh gốc `csel x9, xzr, x8, ne` @0x57c4. Truy
  vết: 24->4, 26->0, 30->0.
- (h) hồi quy — ĐẠT: cổng host-bar 19.3 còn nguyên
  (setBarVisible imp 0xae64: isHidden qua slot 0x39178,
  cmp w0,w22 @0xb0f8, b.ne -> epilogue 0xb258; tbz w22
  -> hideBarForPane:; nhánh hiện setHidden: w2=0; block
  entrance 0xba88: setAlpha: với fmov d0,#1.0 @0xbaa8
  TRƯỚC setTransform:); marker [fixround6] đủ SplitScreen
  + Prefs + AppBridge, fbebb21 giữ nguyên; 'cham thanh'
  (UTF-16LE) còn trong AppBridge.
Vẫn là 'đã kiểm tra tĩnh' — không phải PASS hành vi.

### 20.5 CÒN MỞ — núm vách ngăn publishKnobsNow (CHỜ LỆNH)
Audit-roundlogo đã định danh phần tử tròn là núm vách
ngăn + gương SpringBoard của nó (không phải SpeedBubble)
và kết tội: publishKnobsNow phát phần tử thứ 3 của spec
núm NGƯỢC cực — gốc @0x3eff8 phát
!CGAffineTransformIsIdentity (chỉ bật khi núm đang bị ấn,
scale 1.6); bản ta phát IsIdentity. Hệ quả: gương kẹt
active thường trực, dot nở 22.4 pt, dấu chân chạm phình
~105.6x105.6 pt quanh tâm vách ngăn và nuốt chạm của app
(log fixround5: 118 dòng 'cham tron vach', điểm chạm lệch
tới ~96 pt khỏi tâm) — ở split mixed nửa hosted do gương
phình vẽ, nửa native do núm local 14 pt vẽ nên trông như
đĩa bị cắt nửa; hai app hosted thì đồng nhất. Vùng chạm
gốc 66×66 + pointInside phình 26 pt/phía: bản ta khớp,
không thuộc phần sửa. Lỗi cực này đã có trong audit lẻ
vòng 2 mà chưa từng được sửa. Vòng 6 KHÔNG gồm sửa này —
chờ lệnh riêng của Nguyen. Các mục mở cũ giữ nguyên: đuôi
!logoView playIntro phía XE (3 slot 0xcb0/0xcc0/0xcc8);
nhóm nghiệm thu còn lại; ba bài kiểm để dành.

### 20.6 Bổ sung ghi (GPT chốt qua Nguyen, 2026-11-09 — không đổi phạm vi sửa)
(1) KỶ LUẬT DIỄN ĐẠT: sửa cổng mask ở 20.2 là sửa SAI
LỆCH ĐÃ CHỨNG MINH so với gốc — KHÔNG khẳng định nó khép
toàn bộ hiện tượng xoay 180° nhịp đầu khi phóng to; chỉ
nghiệm thu trên xe mới quyết định hiện tượng đó hết hay
chưa. Câu này cũng phải có trong ACCEPTANCE_FIXROUND6.
(2) Hai tinh chỉnh cho các điều tra kênh apporient SAU
này: (a) Darwin notify không mang dictionary, nhưng có
thể truyền trạng thái số qua notify_set_state /
notify_get_state — AppBridge đang dùng kiểu này; khi
điều tra kênh này phải kiểm cách đóng gói/giải mã số
trong trạng thái notify, không mặc định cần một đường
payload khác. (b) Giả thuyết 'observer đăng ký sau
applicationDidFinishLaunching nên lỡ yêu cầu' là CHƯA
CHỨNG MINH; và việc thiếu request ID là hạn chế truy
vết, không tự nó là lỗi chức năng.
(3) cellClass: giữ nhãn CHƯA XÁC MINH — UUID crash chưa
ghép được đúng binary.
(4) Núm vách ngăn: giữ chờ bằng chứng theo thứ tự đã
chốt — tiếp tục KHÔNG đưa vào vòng 6 (như 20.5).

## 21) VÒNG 7 — WEATHER TRỌN CỤM + BỘ LỌC HƯỚNG {3,4} (2026-11-09)

### 21.1 Weather — sửa trọn cụm W1–W8 + gradient (đặc tả:
work/fix-round5/audit-weather.md; biên bản sửa:
work/fix-round6/fix-weather-sb.md + fix-weather-car.md)
- W5 (đường trả lời phía SpringBoard, SSAnswerWeatherRequest,
gốc sub_7d10): (a) cổng trạng thái — chỉ status {3,4} mới vào
nhánh last-fix/one-shot, ngoài ra đi thẳng stored/IP kể cả
khi có fix (gốc @0x7e1c sub #3, cmp #2, b.hs); ngưỡng
last-fix 1800s (hằng -1800.0 @0x28df8). (b) sở hữu one-shot:
biến tĩnh MẠNH SSWeatherOnceSlot (mẫu global @0x3b190), chạy
trên chính manager tạo ở entry; done (sub_9f9c) dọn slot
trước, nhãn @"fresh CoreLocation". (c) timeout 6.0s
(0x165A0BC00 ns @0x7f5c): thân block = sub_a00c — loadWeak,
slot != once của mình thì thôi, log "no fresh fix in 6s",
gọi finish: bằng manager.location; finish: nuốt done nên
mọi nhánh kết thúc đúng MỘT lần, cờ in-flight không kẹt.
- W1: SSWeatherLoadCache(double) có maxAge; cả hai điểm đọc
(init SSSplash @0x5774 + ready handler sub_8aa4) truyền
43200 (12h); bỏ guard ngày-tương-lai bịa; newest-wins chỉ
khi compare: == Descending (@0xbcd4).
- W2: ứng viên cache #2 = NSTemporaryDirectory() +
OmniCarStartupWeather.plist (sub_bd9c); SaveCache ghi
chính fail thì ghi tiếp file temp (@0xbfa4), nhánh fallback
không set quyền.
- W3: parse trả NIL khi thiếu temperature_2m (dict chỉ tạo
sau kiểm tra @0xb77c); daily thêm guard lớp @0xb86c;
SSCoerceNumber NSNumber-only (sub_ba08), SSCoerceLoose viết
lại độc lập đúng sub_a184 (chuỗi rỗng -> nil); fetch kiểm
NSHTTPURLResponse trước khi đọc statusCode, parse chỉ khi
200 (@0x8cf8).
- W4 (SSSplash refreshWeather/apply): (a) status đọc bằng
INSTANCE manager (@0x64c8); hỏi SpringBoard khi {0,1,2},
direct khi {3,4} (cực của b.hi). (b) retry tĩnh @[@2, @5]
+ bộ đếm thế hệ @0x3b19c (tăng TRƯỚC khi store pending);
bỏ cuộc 10s gọi completion(nil) — không áp cache. (c) apply
có guard finished (@0x680c) + transitionWithView Cross-
Dissolve 0.35s, options 0x500000, thân block = sub_68c4
([view reload]; [view layoutIfNeeded]); nhánh no-fix ở
direct gọi apply(nil) theo @0x6724.
- W6: stored location chỉ dùng khi 0 >= t >= -86400
(@0x9ccc-0x9ce8, hằng -86400.0 @0x28e00).
- W7: IP fallback ephemeral + timeoutIntervalForRequest
4.0 + timeoutIntervalForResource 4.0 + waitsForConnectivity
NO (@0x9df4-0x9e10); payload phải là NSDictionary mới đọc
tọa độ (@0xa2a4); log "IP location failed" ghi mỗi khi
thiếu tọa độ (@0xa3bc).
- W8: -[SSSplash start] chỉ gọi refreshWeather khi style
== 3 hoặc 8 (@0x5e50-0x5e84); style 0 -> decodeMore.
- Gradient style 3 (SSStartupView reload @0xd10c-0xd35c):
helper SSCategoryGradientColors chép sub_d6f0 (÷255.0,
alpha 1); cây chọn cặp màu đúng cấu trúc dump (6/7/8;
5; 9 ngày/đêm; mặc định 4/trên-10/âm ngày (4A5B70, 8D9BAD)
/đêm (10141F, 2A3243); thấp: 0/2 (2A7FD8, 9FD3FF), 1/3
(02030A, 0B1230); 5 (5F6670, 9AA1AA); 9 ngày (5D6E86,
B4C2D3)/đêm (141B2A, 38445A); 6/7/8 (1C2633, 33404F)) ->
setColors: @0xd318 -> startPoint (0.5,0) -> endPoint
(0.5,1) -> _sceneStyle = 3 -> buildWeatherWithPeriod:.
Trước vòng này: 0/16 giá trị trong cây.
- HAI GIẢI QUYẾT NGOÀI AUDIT (đọc lại từ slice gốc khi
sửa): (1) quyền file nhánh chính của SaveCache — record
NSNumber hằng @0x34e88 đọc được từ slice arm64 gốc:
0644 — khớp giá trị bản ta đã dùng, hết trạng thái CHƯA
RÕ. (2) parse gốc LUÔN gán mặc định khi coerce fail cho
weather code/isDay (csel @0xb7e0/@0xb83c; hai record
@0x34e58/@0x34e70): code -> @0, isDay -> @1 — đã sửa
(coerce ?: @0 / ?: @1).

### 21.2 Bộ lọc hướng {3,4} — TÁCH BẠCH khỏi vụ xoay YouTube
ABHook_UIDeviceSetOrientation (ABInApp.m, gốc sub_5504):
bộ lọc cũ giữ (orientation-3) <= 2 -> {3,4,5}; gốc
@0x553c-0x5544 `sub x8,x20,#3; cmp x8,#2; csel x8,x20,xzr,
lo` chỉ giữ {3,4}, value 5 (FaceUp) -> 0. Đã sửa đúng dạng
GPT chốt: (orientation == 3 || orientation == 4) ?
orientation : 0; comment viết lại. Lỗi ca biên độc lập —
KHÔNG có bằng chứng hướng 5 xuất hiện trong phiên
fixround6 (đường YouTube đi sentinel 0xFF), không gộp
vào nguyên nhân xoay.

### 21.3 Điểm nghiệm thu GPT cho Weather — trạng thái:
CẤU TRÚC ĐẠT — CHỜ XE. Yêu cầu: quyền vị trí = 0 thì yêu
cầu phải đi đúng nhánh dự phòng (stored/IP), không kẹt
in-flight, yêu cầu tiếp theo vẫn hoạt động; mọi nhánh
thành công/lỗi/timeout kết thúc giao dịch đúng một lần.
Ở mức cấu trúc + cổng binary (21.5): status 0 không vào
one-shot nữa (phân hoạch {3,4} truy vết trên candidate);
done/timeout tranh nhau bằng slot-compare + finish: nuốt
done; nhánh stored/IP và "no position at all" đều dọn cờ
+ post ready. Chưa gọi là đạt cho tới khi có phiên xe
(kịch bản trong ACCEPTANCE_FIXROUND7).

### 21.4 YOUTUBE — ĐÓNG ĐIỀU TRA TĨNH: cơ chế khớp gốc
Strand zoom-timing (work/fix-round5/audit-zoomtiming.md)
+ log fixround6 (commit 9f20d83) chốt: (1) KHÔNG có
seeding — setRequestedOrientation: có đúng MỘT điểm ghi
trong binary host @0xf884 (trong appWithHash:); đường
solo/zoom không bước nào ghi. (2) Hằng thời gian khớp:
debounce sub_6750 = 0x0EE6B280 ns (0.25s), nudge
+0x02FAF080 ns (0.05s); bản ta dùng đúng hai hằng. (3)
Đóng gói kênh notify là SỐ THUẦN qua notify_set_state
(sub_67fc): state = (field & 0xFF) | (mask & 0xFFFF) << 8
| FNV1a(bundleID) << 24; host dùng THẲNG changed khi
changed != 0xFF (@0xf87c), chỉ suy từ mask ở sentinel
0xFF. (4) Gốc cũng LẬT HƯỚNG TẠI CHỖ, không đổi frame,
không ép solo, không cổng từ chối khi chưa solo: chuỗi
yêu cầu hướng kết thúc ở nudgePane trên khung hiện tại.
Log fixround6 khớp: khung YouTube {297,360} đứng yên qua
ba chu kỳ fullscreen, chỉ hướng lật 1->4->1, đáp số mask
24 -> 4 / mask 2 -> 1 đúng bảng gốc. Quyết định (GPT +
Nguyen): không viết cơ chế chống xoay, không ép solo,
không đổi 0.25s/0.05s, không can thiệp animation YouTube.
VISUAL_ORIGINAL_COMPARISON = PENDING: chỉ footage DEB
gốc — cùng phiên bản YouTube, cùng thao tác, cùng cấu
hình màn hình — mới phân định vòng xoay 1–1,5s có tồn
tại ở gốc hay không; có cùng vòng xoay thì chấp nhận là
giới hạn kiến trúc host-app gốc.

### 21.5 Cổng trên candidate vòng 7 (đo trên binary trích
từ chính candidate; candidate 975.618 B, SHA-256
f4f84555ede9c239165a4c4edccb158b4fbd36771a1e904dcfc31c4c5cde9e14)
- Diff payload vs candidate vòng 6: CHỈ StartupScreen +
AppBridge đổi nội dung; SplitScreen + Prefs chỉ đổi 1
byte marker (+UUID/chữ ký kéo theo); 4 binary còn lại và
mọi resource byte-giữ; control identical.
- (w-sb) ĐẠT: hàm answer (func 0x9164) dựng 6.0s bằng
mov/movk 0x165A0BC00 @0x9410-0x9418 -> dispatch_after;
KHÔNG có hằng 10s trong hàm này (0x2540BE400 chỉ xuất
hiện ở 4 hàm khác). Cổng status biên dịch thành hai phép
kiểm khoảng (sub #5/cmn, b.ls và b.hs) — truy vết đủ:
fix==nil: {3,4} -> one-shot, ngoài -> StoredOrIP;
fix!=nil: {0,1,2} -> StoredOrIP, {3,4} -> kiểm tuổi với
hằng -1800.0 @0x9308 (b.le -> one-shot khi age >= 1800s,
ngược lại dùng thẳng + @"last CoreLocation"). Slot mạnh:
str vào global @0x93d4-0x93d8. Block timeout @0xc790:
objc_loadWeakRetained + so slot (b.ne -> thôi) + log
"no fresh fix in 6s" + finish:(manager.location) —
nguyên dạng sub_a00c. Strings: "no fresh fix in 6s" +
"fresh CoreLocation" có mặt; "one shot" = 0. LoadCache:
ĐÚNG 2 điểm gọi, cả hai `ldr d0, =43200.0` ngay trước
`bl _SSWeatherLoadCache` (@0x5404/0x5408, @0x6998/0x699c).
StoredOrIP (func 0xc330): nạp -86400.0 @0xc4a4; fmov
d0, #4.0 -> setTimeoutIntervalForRequest: @0xc56c và
setTimeoutIntervalForResource: @0xc57c.
- (w-car) ĐẠT: 16/16 giá trị hex gradient có mặt trong
reload (func 0xd64c) — 12 giá trị dạng cặp mov/movk +
4 giá trị (2A7FD8, 9FD3FF, 02030A, 0B1230) trong hai
bảng hằng @0x26cc0/0x26cd0 được chính reload tham chiếu
bằng adr @0xdcb4/0xdcc0; apply @0x68c4-0x68f0:
setWeather: trước, selref transitionWithView:...,
ldr d0 = 0.35 (@0x68d4, hằng @0x26d38), mov w3,
#0x500000, completion nil. Strings retry/bỏ cuộc có
mặt ("no answer yet, asking SpringBoard again",
"SpringBoard did not answer in 10s"). Thêm: cổng
refreshWeather @0x6498 sub #5/cmn #3/b.hi — {3,4}
direct, {0,1,2} hỏi (instance authorizationStatus
@0x6490).
- (f) ĐẠT: hook setOrientation = func 0x149e0 trong
AppBridge: cổng ABForcedOrientation >= 1 nguyên
(cmp #1; b.lt bỏ qua @0x14a10-0x14a18); bộ lọc
@0x14a1c-0x14a24 `sub x8, x21, #3; cmp x8, #2;
csel x8, x21, xzr, lo` — nguyên dạng gốc @0x553c;
truy vết 3->3, 4->4, 5->0; kết quả ghi vào global
@0x14a2c, log "app setOrientation %lld -> %lld".
- (h) HỒI QUY host-bar ĐẠT: guard cmp w0, w22 @0xb0f8
+ b.ne -> epilogue 0xb258; entrance block 0xba88:
selref setAlpha: @0xbaa4 + fmov d0, #1.0 @0xbaa8 TRƯỚC
selref setTransform: @0xbacc.
- (g1)/(g2) HỒI QUY hướng vòng 6 ĐẠT, địa chỉ không
đổi: (g1) dãy suy 0x6ce8-0x6d20, quyết định cmp x8,#0
@0x6d0c + csel x8, xzr, x9, ne @0x6d10; truy vết
24->4 / 26->0 / 30->0. (g2) phép suy app
0x14d84-0x14da8, tst x0, #2 @0x14da4 + csel x9, x8,
xzr, eq @0x14da8.
- (m) ĐẠT: marker [fixround7] đúng 1 chỗ ở mỗi
AppBridge/SplitScreen/Prefs, [fixround6]/[fixround5]
= 0 trong cả 8 binary. Selector parity (tập
__objc_methname) vs gốc: AppBridge/SplitScreen/Prefs
giống HỆT baseline vòng 6 (missing/extra theo tập);
StartupScreen lệch baseline đúng 1 selector —
'transitionWithView:duration:options:animations:
completion:' chuyển từ missing -> có mặt (hệ quả trực
tiếp của W4c; gốc có, vòng 6 thiếu) — hội tụ về gốc,
không missing/extra mới nào khác.
Vẫn là 'đã kiểm tra tĩnh' — không phải PASS hành vi.

### 21.6 Còn mở sau vòng 7
- MỞ MỚI: bản sao weather phía Prefs (OMCCommon.m) CHƯA
rà — module riêng, ngoài phạm vi vòng này; cần một lượt
audit riêng trước khi kết luận cụm weather đã khép ở
mọi module.
- Giữ nguyên trạng theo thứ tự đã chốt: núm vách ngăn
publishKnobsNow (kết tội §20.5, chờ lệnh); đuôi
!logoView playIntro phía XE (3 slot ivar chưa ánh xạ);
cellClass giữ nhãn CHƯA XÁC MINH.
- VISUAL_ORIGINAL_COMPARISON = PENDING (21.4).
- Các nhóm nghiệm thu còn lại + ba bài kiểm để dành
(hết hạn, cứu crash, tải nặng): không đổi.

## 22) VÒNG WAKE1 — BRIDGE WAKE (QA180 PORT) + PINCH PROBE + NÚM (2026-11-09)

### 22.1 Phạm vi và mức báo cáo của vòng
- Vòng TÍNH NĂNG MỚI trên nền fixround7, không phải vòng
khôi phục gốc: phần B Wake theo WO "OMNICAR BRIDGE WAKE
QA180 PORT" (GPT) + phần A Pinch Fullscreen theo WO tích
hợp Pinch + Wake; gộp patch riêng sửa cực publishKnobsNow
(WO §VII). Baseline khóa: fixround7 FAT `f2cc8ffe…`.
- Mức báo cáo (đúng kỷ luật GPT — chỉ các mức cho phép):
Wake = SOURCE HOÀN THIỆN + STATIC PASS (Gate 0/1, mục
22.2/22.6/22.7), Gate 2–6 PENDING chờ xe. Pinch =
**BLOCKED tại cổng A1** (22.3) — trong bản chỉ có
recognizer + probe DRY_RUN + adapter rỗng. Núm = ĐÃ SỬA
(22.4), cổng object + hai slice đạt, chờ kiểm trên xe.
Không mục nào được gọi là hoàn thiện.

### 22.2 Gate 0 audit + thiết kế (báo cáo:
work/wake-round/audit-runtime.md, design-bridgewake.md,
design-pinch.md; hồ sơ cố định ở commit 9424aea)
- Kiểm kê: DEB r6/r7 chỉ có đúng 8 thành phần RE, không
dylib QA19/QA20 bên trong; QA19/QA20 là SOURCE trong gói
hợp nhất QA20 nên cài DEB RE là thay toàn bộ — không thể
hook chồng trong phiên RE (log r5/r6: grep qa19/qa20/
YouTubeHandle/NativeSoloTimer = 0). Ảnh Sileo của Nguyen
xác nhận trên máy chỉ một mục OmniCar.
- PHÁT HIỆN NỀN: gốc 1.0.3 KHÔNG có trạng thái "toàn bộ
controls ẩn" — Chrome có 3 timer 4 s độc lập (bar/tray/
ratio), handle native chỉ ẩn khi vc == nil, núm không tự
ẩn theo idle ở đâu cả. Hành vi mờ idle quen thuộc là của
add-on QA19/QA20. Hệ quả: chủ trạng thái của WO là thành
phần TỔNG HỢP MỚI; dữ kiện hiển thị liên-process duy
nhất có sẵn là hostBarInfo['bar']; điểm tương đương
layoutControls duy nhất là setBarVisible:forPane:
(Chrome.m:313) nhưng chỉ phạm vi bar/theo pane; ABHost
không tự sinh trạng thái — "xác nhận phía SpringBoard"
chỉ đọc được từ giá trị đã áp (handleHit.hidden,
bar.isHidden, số knobViews).
- Tranh chấp sendEvent ĐÃ PHÂN ĐỊNH (audit §6): cổng
trong-app của bản 44 ĐÚNG là hook -[UIApplication
sendEvent:] trong process app (relay 0.9.0 khôi phục
nguyên văn từ 0.7.0, filter 13 bundle); con số "đúng 1
bản ghi lúc teardown" là số bản ghi host ĐỌC ĐƯỢC qua
mailbox DF156 latest-wins trong phiên 2026-11-08
08:00–08:02 (bản ghi chạm GOFA count=22) — kênh tự thừa
nhận mất bản ghi, consumer cũng đọc 0 verdict, nên con
số 1 là CẬN DƯỚI, không phủ quyết probe dry-run. QA180
đo trên ngăn xếp DuoFace, WO nhắm ngăn xếp RE — probe
log nội bộ trong process app là dụng cụ quyết định (B2).
- Ba câu hỏi mở chốt trong design §0: (Q2) vai chrome
của SCPCarSplit chỉ sống ở CarPlayApp — cả hai ctor
__init_0/__init_1 đều gate SCPHostIsCarPlayApp(),
SCPSpringBoardHooks.m là đơn vị Home riêng. (Q3) đối số
handle của hostFrameInfo = !CGRectIsEmpty(frame) tại cả
hai điểm gọi (SCPCarSplit.m:1882 khối +0,05 s gán
pane.hostHandle; :1994 sendHostFrameForPane: tính tại
chỗ) — nghĩa "ô có khung host hợp lệ", không mang nghĩa
idle. (Q4) hostPost: = NSDistributedNotificationCenter
payload NSDictionary cho toàn họ appbridge.*; bridgewake
đi Darwin đóng gói số riêng, không mượn kênh distributed.
- Thiết kế wake: owner = SCPCarSplit (CarPlayApp);
HIDDEN theo pane do hàm tổng hợp MỚI bwRecomputeForPane:
tính từ assigned ∧ live(hostHandle) ∧ barHidden ∧
!transient ∧ !popup → INACTIVE/UNKNOWN/VISIBLE/HIDDEN/
WAKING; bar.isHidden một mình KHÔNG bao giờ đủ; 7 nhóm
điểm gọi recompute; bwGenBySlot[10] chống thông điệp cũ
sau reconnect; KHÔNG tự chế fade idle cho handle/knob
(ngoài WO). IPC: 4 kênh Darwin
com.anlai.omnicar/bridgewake.v1.{state,query,wake,ack};
layout uint64 thống nhất (bit63 valid, 62–35 hash28
FNV-1a32>>4, 34–23 seq12, 22–11 gen12, bit10 flag,
9–8 pinchMode, 7–6 wakeMode, 5–3 state, 2–0 type);
phân tích collision hai lớp (hash 28-bit + ô đơn
latest-wins → phát loạt cách 30 ms, hạn tươi state
2,5 s, phát lại toàn bộ khi có query); 8 test vector
tính bằng script. Hai mode PINCH_MODE/WAKE_MODE độc
lập, mang trong mọi gói state, chỉ owner đọc prefs
(bridgewake.wakeMode/.pinchMode, vắng = DRY_RUN); app
không đọc plist; state quá 2,5 s → mode hiệu dụng OFF.
- Thiết kế pinch: recognizer custom (subclass
UIGestureRecognizer) gắn SCPCarSplitView trong
ensureContainer, cancelsTouchesInView/delaysTouchesBegan/
delaysTouchesEnded = NO — quan sát rồi mới bắn, KHÔNG
giữ cặp kiểu Cách A; ngưỡng out ≥ 1,10 / in ≤ 0,90,
midDrift ≤ 0,6×distChange + 10, tối đa 1 lệnh/gesture;
ánh xạ điểm→pane bằng slots-walk (alpha-gated, float
thắng), cặp chỉ hợp lệ khi hai ngón cùng pane; allowlist
theo (bundleID, loại scene qua SCPVCIsHosted); adapter
protocol SCPFullscreenControlling tách khỏi kết quả A1;
khoá cứng A6: chưa có đường thoát EXPANDED đã chứng minh
thì pinch-out ENFORCE bị cấm bật.

### 22.3 Strand A1 — FULLSCREEN_ENTRY = BLOCKED
(báo cáo: work/wake-round/a1-fullscreen-entry.md)
- Nhận dạng: dylib trích từ DEB QA20 — 125.808 B, MD5
944d6f37c9ce327298dd6edd1d1a3bd8, SHA-256
d532e70ed0e348327de50d4fea3f82fac1db82fb96b87a052d419b00c3271b55;
THIN arm64 (không slice arm64e); filter CarPlayApp +
SpringBoard; build debug từ OmniCarDoubleTapFullscreen.xm
+ OmniCarChrome.xm. Census 4 class (OMCZoomState,
OMCZoomAction, OMCSwapAction, OMCChromeReceiver); 6 hook
trên SCPCarSplit + 2 hook layoutSubviews cửa sổ trạng
thái; cả 6 selector có trong census gốc + header rebuilt
với chữ ký khớp → TƯƠNG THÍCH HOOK ĐẠT. Rào cản ở entry.
- Năm đường vào đều gãy: (1) OMCToggleHost là hàm static
@0x4524, đúng MỘT điểm gọi trong toàn binary:
-[OMCZoomAction pressed:] @0x44a8; hook dividerDoubleTapped:
chỉ chặn/cho qua IMP gốc, không gọi toggle — fullscreen
QA20 kích từ nút zoom của menu hai nút. (2) Action giữ
bằng associated object trên nút nội bộ do
OMCInstallTwoActionMenu tạo (@0x9094 setAssociatedObject,
@0x90b4 addTarget) — chỉ tồn tại sau khi menu tỉ lệ mở
≥ 1 lần; không phải entry ổn định, không gọi được khi
menu chưa hiện. (3) Kênh duy nhất
com.anlai.omnicar.zoom.chrome.v1 (NSDistributed) là kênh
PHÁT trạng thái chrome một chiều CarPlayApp → SpringBoard;
observer duy nhất OMCChromeReceiver received: @0x9d74 chỉ
áp ẩn/hiện chrome thanh trạng thái; dylib KHÔNG import
CFNotificationCenter — không kênh lệnh nào. (4) Symbol
exported duy nhất _OMCChromeSetHidden @0xa798 chỉ khiển
chrome SpringBoard — gọi riêng gây lệch đồng bộ. (5) Đọc
expanded từ ngoài: KHÔNG có đường — state là associated
object trên split với khóa là địa chỉ tĩnh nội bộ của
dylib (ô 0x14ab8 qua OMCState @0x5df8); không getter
exported, không class method, không kênh truy vấn; kênh
chrome còn phát quanh thao tác swap (OMCSwapUsingNativeCallback
@0x5394/@0x54fc) nên không đồng nhất với expanded. State
thuần bộ nhớ (không NSUserDefaults/CFPreferences/ghi
file); expand chụp originalArea + layoutParent +
previousClipsToBounds, restore đi relayoutAnimated:
pushScenes: + rootDidLayout — cả hai chiều nằm trọn trong
toggle; reconnect = instance mới expanded = NO theo
thiết kế.
- Hệ quả theo điều kiện dừng của GPT: DỪNG tích hợp hành
vi pinch nhắm đích này; không offset tuyệt đối, không
selector đoán, không sửa binary QA20; dylib QA20 KHÔNG
vào candidate wake1. Mở lại cổng chỉ khi phía nguồn GPT
công bố entry điều khiển có kiểm chứng + đường đọc trạng
thái và phát hành dylib MỚI (MD5 mới — A1 kiểm lại từ
đầu). Nhắc lại cấm của WO tích hợp: KHÔNG gửi "full" qua
appbridge.baraction — bridgeBarAction:forBundle: nhánh
"full" gọi runSoloForPane: (solo), sai nghĩa fullscreen-
ẩn-dock.

### 22.4 Núm — sửa cực publishKnobsNow (patch riêng, WO §VII)
(biên bản: work/wake-round/fix-knob-polarity.md)
- Cơ sở: audit §4 dump lại độc lập cả hai slice gốc —
payload gốc = !IsIdentity: arm64 eor w2,w27,#0x1 @0x3eff8
→ stub numberWithBool: @0x3effc; arm64e @0x413ac →
@0x413b0 (w27 = kết quả IsIdentity).
- Sửa (SCPCarSplit.m:2615–2620, cả project/ và
src/SplitScreenA/, cmp identical): @(!scaled) →
@(scaled) + comment khớp dump hai slice + sửa chữ
"unscaled flag" → "scaled/active flag" ở comment đầu
hàm; grep @(!scaled) toàn cây = 0. Không đụng kích
thước/gesture/hitbox/frame/z-order.
- Cổng object: bản cũ có HAI eor trên đường giá trị
(IsIdentity @0x18784 → eor @0x18790 ra scaled → ldrb
@0x18810 → eor lần 2 @0x18814 → payload = IsIdentity);
bản mới đúng MỘT eor @0x1878c (chính định nghĩa scaled)
rồi ldrb @0x18808 → and #0x1 @0x18814 → numberWithBool:
(dylib đã link xác nhận cùng dãy, selref @0x1c810).
Bảng test tĩnh: identity → gốc 0 / cũ 1 ✗ / mới 0 ✓;
scale 1.6 → gốc 1 / cũ 0 ✗ / mới 1 ✓. Object mới nhỏ
hơn đúng 8 B (mất 2 lệnh). Trên candidate: đúng 1 eor
@0x15d44 (22.6); trên FAT: 1 eor ở cả hai slice (22.7).
Trạng thái: ĐÃ SỬA — phần kiểm trên xe gộp vào phiên
wake1 (gương về đúng kích thước, chạm gần vách tới app).

### 22.5 Bốn strand cài đặt (mỗi strand một chủ file)
CARPLAY — owner + phân xử (impl-carplay.md):
- MỚI BridgeWakePack.h (layout §3.2 + BWPackFields/
BWUnpack/BWBundleHash + luật chuẩn hoá mode 3→OFF,
state 5–7→UNKNOWN + bảng V1–V8 nguyên văn cuối file);
harness C trên header thật: 19/19 PASS.
- MỚI SCPCarSplit+BridgeWake.h/.m (521 dòng, log
[wake1]): statics + bwGenBySlot[10] :28–105 (dòng 30);
BWEmitStatePacket :111 — cặp notify_set_state/
notify_post DUY NHẤT cho kênh state; BWForceOffBroadcast
:130; hàng đợi phát cách 30 ms :137–167;
bwEmitStateForPane: :169; bwPopupForPane: :194;
bwPinchAllowedForPane: :202; bwSetExpandedActive:
forBundle: :217 + bwExpandedActive :227 (điểm nối tương
lai, giữ NO vì A1 BLOCKED); bwRecomputeForPane:
:231–309; bwSessionTeardown :311;
bwReloadModesAndRepublish :337; bwHandleQueryPacket:
:364, bwHandleWakePacket: :372, bwHandleAckPacket:
:442; bwInstallOwner :481.
- Điểm gọi: SCPShared.m:33–36 (4 hằng kênh); Chrome.m
thêm lời gọi :296 (cuối layoutBarForPane:), :336 (cuối
nhánh hiện setBarVisible:), :358 (completion fade),
:361 (ngay sau animate nhánh ẩn) + import :20 — thân
setBarVisible:forPane: không sửa câu lệnh gốc nào;
SCPCarSplit.m :247 (bwSessionTeardown sau active = NO),
:1823 hostClose:, :1831 hostCloseAll, :1891 khối +0,05 s
hostApp:, :1985 endHostedSolo, :2006
sendHostFrameForPane: + import :26; SCPHooks.m:784 cuối
SCPInitDashboardHooks (chỉ __init_1) + import :17;
Makefile:13 thêm TU.
- Cổng tĩnh §7.1: notify_post kênh state đúng 1 chỗ;
NSTimer mới = 0 (chỉ 2 hạn SCPDispatchAfter được phép:
0,03 s phát + 1,0 s WAKING); handler wake gọi
setBarVisible đúng 1 lần (:409), grep toggleZoom/
soloBundle/runSolo/orientation/keyboard/apporient = 0;
hai cây cmp identical 6/6 file chung (Chrome.m +
Makefile chỉ có ở cây project).

ABHOST — xác nhận chrome (impl-abhost.md):
- ABChannelNames.m:47–50 thêm thuần 4 hằng kênh;
ABHostBMethods.m:1199 accessor MỚI
bwAppliedSnapshotForBundle: trả {handleHidden,
barHidden, knobCount} đọc thẳng từ trạng thái ĐÃ ÁP
(pane.handleHit.hidden, pane.bar.isHidden,
knobViews.count); bundle không host → nil; view chưa
tồn tại → hidden=YES (sự thật-view: để ack ra UNKNOWN,
không VISIBLE giả). ABChannels.m: mục §5 mới :461–596 +
khai báo :20–34 + 1 dòng đăng ký trong
ABHostProcessInit khi SpringBoard (:64):
BWRegisterHostConfirm :564 (nghe wake v=1/type=3, hash28
khớp ABPane đang sống qua ABBundleIDHash>>4 → vũ trang
ô chờ DUY NHẤT/bundle {hash, gen, seq, at}, wake mới ghi
đè); BWObserveApplied :550 (observer riêng trên
appbridge.open/.frame); BWAnswerSlot :518 +
BWFrameApplied :542 (frame ≤ 800 ms → ack role=1 echo
đúng gen/seq, state VISIBLE chỉ khi barHidden == NO,
ngược lại UNKNOWN; quá hạn → ack UNKNOWN; ô bị xoá
TRƯỚC khi phát → exactly-once; expiry kiểm gen+seq);
BWEmitHostAck :504 — đường phát Darwin duy nhất thêm
phía host (register_check → set_state → post, đúng
idiom cây). Không bộ đếm idle, không NSTimer.
- Cổng §7.2: thân setBarVisible:pop:dim:single:forApp:
+ setHandleVisible: + setFrame: + setKnobs: khớp SHA-256
trước/sau (3044b10d… / 409cfb14… / 8606f40a… /
b98a9f26…); diff cả 3 file THÊM THUẦN, 0 dòng sửa/xoá;
vector production V6 = 0xE9DA706814803C14 PASS, giải mã
V4 PASS; build sạch, ABChannels.m 0 cảnh báo.

ABINAPP — relay + probe + suppression (impl-abapp.md):
- ABInApp.m 585 → 1.132 dòng, đúng 8 điểm chạm; mirror
hai cây cmp = 0. Cài lười trong ABOrientationBlock cùng
điều kiện !ABHooksInstalled: hook -[UIApplication
sendEvent:] + đăng ký state/ack + observer kb + phát
query. orig_SendEvent đúng 1 điểm gọi (:554); đường
nuốt gọi 0 lần; sendEvent: chỉ tồn tại ở ABInApp.m
trong toàn cây.
- State client: hạn tươi 2,5 s (quá hạn → OFF +
fail-open), query lại tối đa 1 lần/2 s, lọc gen
modulo-4096, state 5–7 → UNKNOWN, mode 3 → OFF; gói
tươi mở cả mixed-lock lẫn ack-latch. MỘT điểm probe hai
bộ đếm: wouldSwallow = cổng §5.4 tại Began "như thể
ENFORCE"; wouldPinch = đúng 2 touch + khoảng cách đổi
> 10% + cờ pinchAllowed (không log tọa độ); format
[do] bw probe nguyên văn thiết kế; trần 200 dãy/launch
+ tổng kết 30 s. Suppression: máy IDLE→SWALLOWING→
FINISHED→IDLE, cổng enabled ∧ sessionValid ∧
targetVerified ∧ known ∧ hidden ∧ !keyboardActive ∧
!keyboardUnknown ∧ !transitioning ∧ !mixedTouches;
nuốt trọn dãy tới Ended/Cancelled, không chuyển
pass-through giữa chừng; một wake/dãy kèm transaction;
ack timeout 1,5 s → fail-open latch tới state tươi;
mixed → hấp thụ + khoá tới state tươi. Keyboard guard:
chính = ABCurrentResponder qua Became (+1 dòng)/
Resigned (+1 dòng); phụ = WillShow/Hide/DidChangeFrame
chỉ tính khi 0 < origin.y < chiều cao màn hình; vắng
thông báo KHÔNG hạ ACTIVE (blank inputView); 0 dòng suy
từ tồn tại UIRemoteKeyboardWindow. BWResetAll nối qua
ABChanClose/ABChanCloseAll trong ABInstallInAppObservers.
- Thân ABPublishAppOrientation/ABKeyboardPublish và bộ
lọc hướng {3,4} KHÔNG đổi một dòng. Codec của strand
này kiểm bằng harness độc lập 17/17 PASS (bản header
riêng của module — đã chuẩn hoá ở tích hợp, 22.6).
Mode chỉ từ gói state, không đọc plist.

PINCH — controller + probe + adapter rỗng (impl-pinch.md):
- 2 cặp file MỚI × 2 cây (cmp identical 4/4), không
đụng file chung, không sửa Makefile:
SCPPinchController.h/.m (28.080 B) + SCPFullscreenAdapter.h/.m.
Recognizer subclass tại SCPPinchController.m:102; cấu
hình bắt buộc :113–115 (cancels/delays = NO); sổ cặp
scpFormPair :147 (dist0/mid0 tại thời điểm ngón 2
xuống); ngưỡng out/in + drift kiểm CÙNG một Moved;
ánh xạ scpPaneForStartPoint: :513 (slots-walk
alpha-gated, float thắng, hit cuối); cặp hợp lệ chỉ khi
hai ngón cùng pane, ngón trên divider/chrome → chết;
điểm phát lệnh DUY NHẤT scpRecognizerDidCross: :578 qua
5 cổng đúng thứ tự (mode từ arbiter — không plist;
trạng thái từ adapter; phân xử; chuỗi sạch; allowlist
(bundle, SCPVCIsHosted) mặc định RỖNG); log [pinch1]
đủ trường §6.1, đếm complete/truncated tách
SPLIT/EXPANDED; vòng đời attachIfNeeded :407 / detach
:423 / syncArming :434 / resetTracking :451 nhận lệnh
từ ngoài.
- Adapter (SCPFullscreenAdapter.m:31–47): currentState
luôn Unknown; requestExpand :37 / requestRestore :43
log từ chối + completion(NO); stateDidChange không
phát; comment tại điểm binding ghi A1=BLOCKED
2026-11-09. Đây là trạng thái CUỐI của vòng (không phải
tạm chờ): cổng 2 không bao giờ qua → PINCH ENFORCE
không thể arm; DRY_RUN chạy bình thường.
- Lệch ghi trong biên bản: L1 protocol arbiter thêm
pinchMode (mode phải đến từ owner — nối ở tích hợp);
L2 chết chrome/divider kiểm thêm touch.view (chỉ giết
cặp); L3 hostIsExpanded của arbiter chưa được controller
gọi (cổng 2 đọc adapter đúng chữ thiết kế); L4 reset đi
qua pha chờ-mọi-touch-kết-thúc trước IDLE. Compile
trực tiếp clang-18 flags tương đương module: 0 lỗi /
0 cảnh báo cả -Wall -Wextra ở hai cây; link thử lld ra
Mach-O arm64 đủ 3 class.

### 22.6 Tích hợp wake1 (biên bản:
work/wake-round/integration-wake1.md)
- Keo pinch: Makefile FILES +2 TU (dòng 13); SCPHooks.m
+1 import (:18) và 1 lời gọi syncArming sau seam
rootDidLayout trong Hook_RootVC_viewDidLayoutSubviews;
SCPCarSplit.m +1 import (:27) + đúng 2 dòng keo:
attachIfNeeded cuối ensureContainer (nhánh dựng
container MỚI — điểm duy nhất container tươi xác định
được) và detach trong dashboardInvalidated ngay sau
bwSessionTeardown. Arbiter: category (BridgeWake) khai
<SCPPinchArbiter> ở SCPCarSplit+BridgeWake.h:8; phía .m:
pinchMode ← bwPinchMode của owner; hostIsExpanded ←
bwExpandedFlag (luôn NO); pinchDispositionForPane:
touchesSuppressed: ánh xạ thuần từ state bw theo slot
(EXPANDED → Allowed; HIDDEN → BlockedHidden; VISIBLE →
BlockedUnknown nếu popup/resizing, ngược lại Allowed;
còn lại BlockedUnknown; allowlist KHÔNG hỏi ở đây —
cổng 5 là của controller); gán arbiter ở cuối
bwInstallOwner.
- Chuẩn hoá giao thức: hai bản BridgeWakePack.h LỆCH
THẬT ở mức API (SplitScreen: BWPackFields + BWUnpack
trả struct; AppBridge: BWPack + BWUnpack(raw,&out)) →
lấy bản SplitScreen làm chuẩn, identical cả 4 vị trí
(md5 055f1005465c9f5dfbfdb84f7a0cb57b), adapt ABInApp.m
6 điểm (:206, :219, :257–260, :279–283). Harness trên
header cuối: 38/38 PASS ở cả hai module, gồm hằng V6
file-local của ABHost (0xE9DA706814803C14) bit-identical
với header chuẩn trên miền kiểm thử. Chuỗi 4 kênh
byte-equal ở 3 nơi (SCPShared.m:33–36,
ABChannelNames.m:47–50, statics ABInApp.m:104–107);
FNV-1a khớp cả 3 hàm băm (ABBundleHash/ABBundleIDHash/
BWBundleHashCString).
- Candidate local: com.anlai.omnicar_1.0.3-wake1_
iphoneos-arm64.deb — 994.274 B, SHA-256
12d41e98160bbbb2371bb755562c0085b18c9700a78e2c12b012de86c826e38f;
control Package com.anlai.omnicar, Version 1.0.3,
iphoneos-arm64; member qua dm.pl (debian-binary +
control.tar.gz + data.tar.lzma) như mọi candidate
r3–r7; arm64-only như mọi candidate local.
- Gate 1 (đo trên binary trích từ CHÍNH candidate;
baseline fixround7 FAT): selector parity __objc_methname
mất 0/8 thành phần (AppBridge 705→716, SplitScreen
1093→1317, còn lại chỉ +selref Foundation); danh sách
file ≡ baseline, đúng 6 dylib chuẩn, 0 file QA19/QA20/
DoubleTap/YouTubeHandle/NativeSolo; g1 PASS (AppBridge
@0x7878 and #0x2 → @0x789c cmp #0 → @0x78a0 csel ne;
changed @0x78ac cmp #0xff → csel eq); g2 PASS (@0x15f58
tst #0x2 → @0x15f5c csel eq); h PASS (C-A: setBarVisible
@0xbc7c → @0xbc88 cmp w0,w22 → @0xbc8c b.ne; C-B: block
@0xc618 fmov d0,#1.0 @0xc638 → setAlpha: @0xc63c TRƯỚC
setTransform: @0xc664); f PASS (hook @0x15bb8 sub #3 →
@0x15bbc cmp #2 → @0x15bc0 csel lo); publishKnobsNow
(hàm 0x159e0–0x15f20) đúng 1 eor @0x15d44, w27 = kết quả
IsIdentity @0x15cf0; khoá pinch ENFORCE PASS (adapter
currentState @0x2f9e4 = mov x0,#0; ret; điểm bắn đọc
currentState @0x2f31c + hỏi pinchDispositionForPane:
@0x2f3a4 TRƯỚC mọi request); sendEvent: chỉ ở AppBridge
(1; 7 binary còn lại 0); kênh cũ nguyên vẹn
(apporient/.orientation/.keyboard) + bridgewake.v1.*
đủ 4 chuỗi ở SplitScreen + AppBridge; selector mới đều
có IMP hoặc là selector framework chuẩn; mirror hai cây
identical mọi file đã sửa. Modes trong candidate: không
pref đặt sẵn → cả hai DRY_RUN, không thể tự ENFORCE.
Vẫn là "đã kiểm tra tĩnh" — không phải PASS hành vi.

### 22.7 Ship wake1 + xác minh hai slice trên FAT
- Git: main a907505 (source wake1), ci-fat-test 21e1b95
(merge); CI workflow build-fat-macos.yml (410962367),
run dispatch 42573985624 — SUCCESS (truy vấn trực tiếp).
- FAT: com.anlai.omnicar_1.0.3-rebuilt-wake1-fat_
iphoneos-arm64.deb — 1.184.484 B, SHA-256
279005f45cb84d340e050461a46b4768fc4226c6edf80709af606004a9c3c2f1;
member debian-binary + control.tar.gz + data.tar.lzma;
control Version 1.0.3.
- Xác minh trên FAT (cả hai slice arm64 + arm64e):
chuỗi bridgewake.v1.* đủ 4/4 ở SplitScreen + AppBridge
× 2 slice; publishKnobsNow đúng 1 eor × 2 slice; g1
dạng csel × 2 slice; adapter currentState =
mov x0,#0; ret × 2 slice. UUID từng slice trong
ACCEPTANCE_WAKE1.

### 22.8 Điểm diễn giải — CHỜ GPT PHÁN (không tự kết luận)
1. ABHost hop: thiết kế §6 trỏ handler frame/open ở
ABChannels.m:203/:244, nhưng hai handler đó trong cây
là bản tham chiếu trong #if 0; handler SỐNG nằm ở
ABHostGeometry.m (ngoài phạm vi strand + cổng cấm sửa
thân hàm áp frame). Giải pháp: observer riêng trên cùng
hai thông báo + MỘT hop main-queue trước khi đọc
snapshot — bảo đảm đọc sau khi frame áp thật, không
đụng handler hiện hữu. Câu hỏi Gate 2: hop có kịp ngân
sách ack 800 ms và hạn WAKING 1,0 s không (đếm
"wake confirm timeout" trong log [wake1]).
2. targetVerified phía ABInApp cài CHẶT (impl-abapp
điểm 2): mọi Began phải có window != nil (thiếu →
notarget) và == ABKeyWindow() hiện hành (khác → phone,
wouldSwallow=0). Chiều fail-open; Gate 2 trả lời bằng
dữ kiện xe: chạm hosted thật có rơi vào window
không-key không — nếu có, luật phải nới trước khi bàn
ENFORCE.
3. Header pack lệch API đã chuẩn hoá về bản SplitScreen
(22.6): bề mặt API phía AppBridge đổi sau khi strand
ABInApp đã đạt 17/17 trên bản của nó; tương đương được
chứng minh lại bằng harness cuối 38/38 ở cả hai module.
4. externalChainSuppressed suy từ WAKING phía owner:
không tồn tại tín hiệu liên-process "chuỗi đang bị
nuốt" nhìn thấy từ CarPlayApp; sự thật tương đương là
giao dịch wake đang mở trên slot (bwWakePendingBySlot —
khi đó pane ở WAKING và chuỗi phía app đang bị giữ).
Helper BWPublishChainSuppressed() duy trì
controller.externalChainSuppressed = (có bất kỳ slot
nào đang WAKING), gọi tại đúng 5 điểm mở/đóng giao
dịch (bwInstallOwner, mở WAKING trong
bwHandleWakePacket, đóng bởi ack trong bwHandleAckPacket,
đóng bởi hạn 1,0 s, bwSessionTeardown). Trong
pinchDispositionForPane:, tham số touchesSuppressed
không cần đáp án riêng từ owner — state WAKING đã lưu
ánh xạ sẵn sang BlockedUnknown. Không bịa kênh mới.
5. assigned(p) gồm thêm self.active (impl-carplay
quyết định 1): thiết kế §1.2 chỉ viết thuộc hostedPanes
+ bundleID != nil; không tính active thì recompute
trong phần còn lại của dashboardInvalidated lật pane về
VISIBLE/HIDDEN sau teardown — INACTIVE phải ổn định.
6. Wake khi state == VISIBLE ack ngay (impl-carplay
quyết định 6): vẫn gọi đường hiện bar (gia hạn timer
4 s) + ack role=0 ngay, KHÔNG mở giao dịch WAKING —
setBarVisible:YES khi bar đã hiện không đẩy frame nên
ABHost không có gì để confirm trong 800 ms; mở giao
dịch chỉ tổ nhận confirm UNKNOWN oan. Wake ở
UNKNOWN/WAKING/INACTIVE bị bỏ + đếm (app fail-open
theo hạn ack 1,5 s của nó).
7. Hai bề mặt allowlist pinch khác nhau, cả hai mặc
định rỗng: (a) cờ pinchAllowed trong gói state ← pref
bridgewake.pinchAllowlist của owner (mảng chuỗi; vắng
= rỗng) — nuôi probe phía app; (b) cổng 5 của
controller ← danh sách (bundle, scene) riêng trong
SCPPinchController, giữ rỗng cho tới sau Gate 2/3.
Thêm nữa: trạng thái owner để ở file statics khoá theo
slot (bwGenBySlot/bwState) thay vì ivar trong
SCPCarSplit.h/SCPCarPane.h — giới hạn phạm vi file của
strand CarPlay; hành vi khớp thiết kế, dời khai báo là
việc cơ học nếu GPT yêu cầu.

### 22.9 Còn mở sau wake1
- Gate 2–6 của WO tích hợp: PENDING — chờ MỘT phiên xe
gộp (kịch bản trong ACCEPTANCE_WAKE1): dry-run đếm
wouldSwallow/wouldPinch + phân loại phone/iPhone; phân
bố ba kết cục ack; recognizer CarPlay thấy đủ cặp
complete ở SPLIT không; kiểm núm trên xe; nghiệm thu
Weather fixround7 gộp cùng phiên (vẫn PENDING từ §21).
- Pinch: BLOCKED tại A1 — điều kiện mở lại ở 22.3.
ENFORCE của wake chỉ được bàn sau khi Gate 2 đạt.
- VISUAL_ORIGINAL_COMPARISON = PENDING (§21.4), không đổi.
- Giữ nguyên từ các vòng trước: bản sao Weather phía
Prefs (OMCCommon.m) chưa rà (§21.6); đuôi !logoView
playIntro phía xe; cellClass giữ nhãn UNVERIFIED.

## 23) VÒNG FS1 — FULLSCREEN CONTROLLER TỰ DỰNG + AUTOHIDE (2026-11-09)

### 23.1 Phạm vi và mức báo cáo của vòng
- Vòng TÍNH NĂNG trên nền wake1 (baseline khóa: wake1 FAT
`279005f4…`). Hai tính năng: (1) FS1 — controller fullscreen
ẩn dock TỰ DỰNG theo quyết định GPT mở lại A1 (phương án 2):
không nạp dylib QA20, không mô phỏng nút menu, không offset;
cơ chế host của QA20 (snapshot appArea → đổi nguồn diện tích
→ relayout → khôi phục) được dựng lại thành code riêng trong
cây rebuilt, pinch là trigger duy nhất khi ENFORCE được mở.
Vòng này controller được nghiệm thu qua CÔNG TẮC TEST trong
Prefs trước — pinch vẫn DRY_RUN. (2) AutoHide — tính năng
gộp theo lệnh Nguyen 13:53: ẩn HOÀN TOÀN các nút trên màn
hình sau 4,0 s idle (cơ chế mờ opacity của QA20) + gọi lại
một chạm không click app (ngữ nghĩa QA180 qua Bridge Wake);
AutoHide cấp đầu vào `faded` còn thiếu cho định nghĩa
HIDDEN của wake.
- Mức báo cáo: FS1 + AutoHide = SOURCE HOÀN THIỆN + STATIC
PASS (Gate 1 trên candidate + kiểm hai lát trên FAT, mục
23.5/23.6). Nghiệm thu xe: TẤT CẢ PENDING — FS controller
staging, AutoHide, Gate 2 wake, Weather r7, núm (23.8).
Không mục nào được gọi là hoàn thiện. Track YT-ZOOM chạy
song song (điều tra + thiết kế + công tắc Prefs đã land ở
mức hồ sơ) nhưng code/khoá của nó KHÔNG nằm trong bản fs1
— ci-fs1 §4.3 kiểm vắng tuyệt đối trong cả 8 binary và
mọi plist/strings của gói.

### 23.2 Thiết kế (báo cáo: design-fullscreen-fs1.md,
design-autohide.md)
- FS1: chủ duy nhất SCPFullscreenController, máy trạng thái
SPLIT → EXPANDING → EXPANDED → RESTORING → SPLIT, lỗi →
rollback về SPLIT; controller sở hữu toàn bộ snapshot +
cờ expanded; SCPFullscreenAdapter thành lớp chuyển tiếp
thuần (currentState / requestExpand / requestRestore /
stateDidChange); completion YES chỉ sau khi thay đổi
layout được XÁC NHẬN bằng đọc lại (gọi relayout thành
công không đủ); transaction id chống callback cũ.
OMCChromeSetHidden ĐÃ CHỨNG MINH thuộc dylib QA20 (định
nghĩa OmniCarChrome.xm:69, exported @0xa798, receiver
sống cùng process CarPlayApp) — trong rebuilt KHÔNG có
chủ sở hữu nên CẤM tham chiếu; thay bằng hàm nội bộ trong
controller, cùng kỷ luật ghi cờ gốc/khôi phục đúng cờ.
Điểm can thiệp hình học DUY NHẤT: một dòng tham vấn tại
return của appAreaInParent:; fullscreen chỉ đổi vùng
trình bày của cả split — không bao giờ dùng runSoloForPane:/
toggleZoomForPane: thay thế. Năm luật biên EXPANDED ↔
AutoHide (R1–R5): EXPANDED thắng phân xử (ép VISIBLE, tắt
suppression); timer mờ ĐÔNG CỨNG khi EXPANDED; tập ẩn của
FS không chứa bar/handle/knob/logo/gương ABHost; nút Home
là phần tử chung duy nhất (FS ép ẩn khi vào, khi ra NHẢ
về phán quyết hiện hành của trục mờ); hệ quả: trạng thái
"EXPANDED + controls đã ẩn" không tồn tại ⇒ pinch-in
luôn mở được.
- AutoHide: HIDDEN của wake1 thực chất mới chỉ có bar —
gốc 1.0.3 không có idle-hide cho handle/knob/logo (audit
Gate 0), hành vi mờ quen thuộc là của QA20/QA19. Cơ chế
QA20 đọc từ source: một NSTimer 4,0 s một lần; sơn bằng
layer.opacity = 0,0 (về 0 hẳn, lưu trị gốc từng view,
khôi phục nguyên trị, KHÔNG animation, không đụng
hidden/alpha/userInteractionEnabled nên hit target còn
sống khi mờ); QA20 sơn handle mọi pane + divider + knob
của divider (loại trừ tường minh ratioKnob), QA19 sơn
gương ABPane.handle/handleHit phía SpringBoard khi
nativeVisible. Cờ `handle` trong hostFrameInfo ĐÃ CHỐT
nghĩa: suy tại chỗ !CGRectIsEmpty(frame) ở đúng 2 điểm
gọi (SCPCarSplit.m:1890/:1993) = "ô có khung trình chiếu
hợp lệ" — CẤM mã hoá mờ qua cờ này. Đường mang trạng
thái mờ: key `fade` mở rộng trong hostFrameInfo (cho
gương handle) + key `kfade` cạnh `knobs` (cho ABKnobView)
— tự đồng bộ theo mọi lần đẩy frame; kênh NSDistributed
riêng bị loại vì rủi ro lệch đồng bộ. homeButton/logo bổ
sung vào tập sơn theo lệnh Nguyen (QA20 không sơn).
Chủ trạng thái: controller mới SCPCarSplit+AutoHide, một
timer 4,0 s toàn phiên, độc lập hoàn toàn với 3 timer
gốc (bar/tray/ratio). Feed: F1 hitTest của SCPCarSplitView
(bộ lọc Began nguyên văn QA20), F2 handletap/knobtouch từ
host, F3 homeButtonTapped, F4 gói `act` mới trên
bridgewake (kênh thứ 5 bridgewake.v1.act, BWTypeAct = 5,
flag = kbActive, throttle 0,12 s; vector V9 =
0xE9DA706800803805, V10 = 0xE9DA706801003C05). ABHost
không có feed — chỉ áp. HIDDEN đầy đủ:
barHidden ∧ faded (handle ∧ knob ∧ logo do một ahFaded
toàn cục bảo chứng); AutoHide tắt ⇒ fadedEffective = YES
cố định ⇒ HIDDEN quay về ĐÚNG định nghĩa wake1 (luật
tương thích). EXPANDED và phiên solo hosted TREO toàn bộ
AutoHide. Pref bridgewake.autoHide, vắng = BẬT. Mức hoàn
chỉnh nói thẳng trong thiết kế: DRY_RUN = parity QA20
đầy đủ (chạm đầu vừa vào app vừa gọi controls hiện);
ENFORCE mới là ngữ nghĩa QA180 và phụ thuộc cổng nghiệm
thu riêng của wake.

### 23.3 Ba strand cài đặt FS1
STRAND A — controller + adapter (impl-fs-controller.md):
- MỚI SCPFullscreenController.h/.m (560 dòng): phase lưu ở
extension riêng; điểm cốt lõi xử lý đúng — fsAreaForParent:
khoá trên CỜ NỘI BỘ _expandedFlag lật TRƯỚC relayout (như
state.expanded của QA20; khoá trên phase đã chốt thì
rootDidLayout không bao giờ kéo được container lên target),
còn fsCommittedState khoá trên phase đã chốt (EXPANDING
báo Split, RESTORING báo Expanded, chưa cài → Unknown).
Snapshot {parent weak, originalArea, targetArea = window
bounds trong parent, previousClips} chụp TRƯỚC khi lật;
_txnCounter đơn điệu, lệnh chồng → từ chối `fs busy
txn=<n>` + completion NO, không hàng đợi; retry restore
mang txn, lệch thì bỏ.
- Expand: cổng vào từ chối êm theo thứ tự inactive →
host-unavailable → zoomed → solo → picker → popup → tray
(không tự dọn gì); cặp relayoutAnimated:NO pushScenes:YES
+ rootDidLayout; XÁC NHẬN ĐỌC LẠI container.frame ±0,5 pt
+ superview == parent snapshot + window còn + active còn
— lệch → log số đo `fs expand unconfirmed` + rollback
(hạ cờ → clips → relayout → chrome NO → bw NO → SPLIT).
Restore: hạ cờ TRƯỚC, đối chiếu diện tích gốc HIỆN HÀNH
(appAreaInParent: tính lại lúc đó thắng snapshot), sai →
đúng 1 retry sau 0,05 s (txn-guarded); vẫn sai → chốt an
toàn SPLIT + log `fs restore-unconfirmed` — không EXPANDED
giả. Restore rút gọn khi teardown/!active: không relayout,
đúng mẫu setActive: của QA20.
- Chrome nội bộ: quét cửa sổ theo tên class
DBStatusBarWindow/CARStatusBarWindow, ghi cờ hidden gốc
lần đầu vào NSMapTable yếu→mạnh, khôi phục đúng cờ từng
cửa sổ; không thấy cửa sổ → log `fs chrome FAILED
no-window`, không latch, không chặn expand. Nút Home ép
hidden + reconcile ép lại, restore nhả theo R4; không gọi
removeHomeButton ở đâu cả. Reconcile fsDidLayout: xác
nhận frame; solo/zoom override → `fs external-override` +
rút gọn (không gọi ngược hàm solo/zoom); guard
re-entrancy. bwSetExpandedActive:forBundle:nil phát tại
đúng các điểm chốt (YES expand-confirmed; NO ở
restore-confirmed/unconfirmed/rollback/session-end).
- Adapter viết lại thân (55 dòng): chuyển tiếp thuần
theo §4.9 của thiết kế, header/protocol giữ nguyên từng
chữ, pinch không phải sửa; 0 biến trạng thái FS.
- Nhánh [fs1-test]: fsInstallIfNeeded nghe SCPNotePrefsChanged,
pref fullscreenTestExpand vắng = NO, chỉ hành động ở cạnh
đổi; lệnh test qua ĐÚNG cổng/txn/xác nhận như lệnh pinch,
provenance `test`, log tiền tố [fs1-test].
- Cổng tự kiểm: clang-18 -Wall -Wextra 0/0 cả hai file;
grep chuỗi cấm (OMCChromeSetHidden, runSoloForPane:,
toggleZoomForPane:, dividerDoubleTapped,
ratioPresetTapped) = 0 trong cả 4 file FS kể cả comment.
Hai điểm diễn giải của strand A ghi tại 23.7 mục 5–6.

STRAND B — keo vòng đời + một dòng tham vấn (impl-fs-glue.md):
- SCPCarSplit+Layout.m:513–521: ĐÚNG 1 dòng tại return duy
nhất của appAreaInParent: —
`return [[SCPFullscreenController shared] fsAreaForParent:parent nativeArea:area split:self];`
Diff toàn file so baseline chỉ gồm import + hunk này; thân
hàm gốc khớp từng câu lệnh còn lại.
- SCPHooks.m: fsDidLayout tại seam rootDidLayout (sau
syncArming, bọc @try/@catch như pinch); fsInstallIfNeeded
ngay sau bwInstallOwner ở cuối __init_1. SCPCarSplit.m:251:
fsSessionDidEnd tại dashboardInvalidated, đúng điểm
self.active = NO, sau dòng pinch detach. Makefile +1 TU
(SCPFullscreenController.m; adapter TU đếm = 1, không trùng).
- Đối chiếu giao diện: cả 4 tên khớp tuyệt đối với header
thật của strand A; tên giả định duy nhất ban đầu
(fsInstall) đã sửa thành fsInstallIfNeeded ngay khi header
land giữa chừng; grep tên sai = 0 cả hai cây. Cổng: số
MSHookMessageEx trước = sau = 31 (không hook runtime mới);
build module SplitScreen từ sạch thành công (dylib
1.241.080 B), đủ 4 selector FS.

STRAND C — công tắc Prefs (impl-fs-prefs.md):
- FeatureSplitScreen.plist (bplist00 giữ nguyên): items
2 → 4, hai specifier cũ nguyên vẹn từng giá trị; items[2]
PSGroupCell nhóm TEST, items[3] PSSwitchCell key =
fullscreenTestExpand, default = false (bool), defaults =
com.anlai.omnicar, PostNotification =
com.anlai.omnicar/prefschanged — tập keys identical với
switch mẫu splitScreenEnabled (đúng 6 keys). Strings en +
vi: 46 → 49 khoá/file, khoá cũ nguyên vẹn; nhóm hiện
"TEST — Fullscreen (chỉ dùng nghiệm thu)" trên máy vi.
- Đường ống pref TỰ ĐỘNG theo specifier (kết luận có bằng
chứng): OMCFeatureListController nạp bằng
loadSpecifiersFromPlistName:, không danh sách khoá cho
phép; framework ghi domain + phát Darwin theo
PostNotification của chính specifier; trang Split Screen
không tự phát cho splitScreenEnabled mà phía SplitScreen
vẫn nhận. Phía nhận đã có sẵn SCPNotePrefsChanged
(SCPShared.m:10 cả hai cây). Không cần một dòng code Prefs.

### 23.4 Bốn strand cài đặt AutoHide
CARPLAY PHẦN 1 — TU + F1 + header (impl-autohide-car1.md):
- MỚI SCPCarSplit+AutoHide.h/.m: một timer 4,0 s toàn
phiên (kAHIdleSeconds), độc lập tuyệt đối với 3 timer gốc
(0 tham chiếu ghi/huỷ); statics giữ ahFaded toàn cục +
registry NSHashTable yếu. Sơn đúng kỷ luật QA20: chỉ
layer.opacity, lưu/khôi phục nguyên trị per-view qua
associated object, sơn lại không ghi đè bản lưu; grep 0
phép gán .hidden/.alpha/userInteractionEnabled. Tập sơn:
handle mọi pane + divider VÀ knob của nó (hai bản lưu
riêng) + homeButton; loại trừ tường minh ratioKnob,
pane.bar, launcherHost. Hiện lại dùng chung một thân —
khôi phục MỌI view trong registry kể cả view đã rời tập
sơn. Điều kiện không-mờ tại thời điểm bắn cài đủ §4.2:
EXPANDED (đọc qua bwExpandedActive), solo hosted, kbHold
(tự hết hạn 10 s), popup/picker/ratio/tray mở,
resizing/kéo pane → log `fade deferred` + gài lại 4,0 s,
không bỏ chu kỳ. Pref tắt giữa lúc mờ → khôi phục ngay +
dừng timer.
- SCPCarSplitView.m: điểm F1 duy nhất — sau khi có hit
(không sửa câu lệnh gốc nào), bộ lọc Began nguyên văn
thiết kế → ahNoteActivity:AHSourceContainer.
- BridgeWakePack.h bản SplitScreen: BWTypeAct = 5 +
vector V9/V10; V1–V8 và hàm pack/unpack không đổi một
ký tự. Harness trên header cả hai cây: 15/15 PASS.
Biên dịch TU + View: 0 cảnh báo ở cả -Wall và
-Wall -Wextra.

CARPLAY PHẦN 2 — điểm gọi + nối owner (impl-autohide-car2.md):
- SCPCarSplit.m: fade trong hostFrameInfo: (:2062,
superset — dict gốc nguyên công thức, cấm mã hoá qua
handle được giữ); kfade cạnh knobs trong publishKnobsNow
(:2651); F2 cuối bridgeHandleTapped: (:2532); F3 đầu
homeButtonTapped (:3010); ahSessionTeardown cạnh
bwSessionTeardown trong dashboardInvalidated (:252 — chỉ
cộng, không đụng dòng pinch/FS1).
- SCPCarSplit+BridgeWake.m/.h: bwRecomputeForPane: cộng
fadedEffective = !bwAutoHideEnabled || [self ahFaded]
(chỉ trong nhánh barHidden; bar ẩn nhưng chưa mờ →
VISIBLE, không phải HIDDEN — wake rơi vào cửa sổ đó vẫn
hiện bar + ack ngay; AutoHide tắt ⇒ HIDDEN y hệt wake1);
bwHandleWakePacket: gọi ahRevealWithReason:AHRevealWake
tại đúng 1 điểm trên đường chấp nhận, sau setBarVisible:;
receiver kênh act + bwHandleActPacket: mới (kiểm
hash/gen/bundle-còn-hosted như wake → chuyển
ahNoteActWithKbActive:pkt.flag; KHÔNG phát lại gì);
bwSetExpandedActive: gọi ahSetSuspended: cùng nhịp;
bwReloadModesAndRepublish nạp bridgewake.autoHide
(vắng = BẬT) + gọi ahReloadConfig.
- SCPShared.m: hằng SCPBridgeWakeAct byte-identical phía
app (grep đối chiếu 4 vị trí). SCPHooks.m: ahInstall ngay
sau bwInstallOwner (:803). Makefile +1 TU AutoHide.
Chrome.m cuối layoutBarForPane: + Layout.m cuối
rebuildDividers: áp-lại sơn qua ahApplyCurrentStateToView:
(handle; divider + knob riêng). Divider.m: AHSourceDragEnd
trong endResize (sau chốt resizing = NO), AHSourceHostKnob
trong remoteKnobTouch:.
- Ba việc bổ sung đã nối: ahSessionStarted tại
SCPCarSplit.m:133 trong activateWithCount:, ngay sau
self.active = YES (:132 — điểm active = YES DUY NHẤT
toàn module, sau ensureContainer thành công; nhánh
raise-lại-khi-đã-active cố ý không nối); áp-lại sơn cuối
refreshHomeButton (:2993); removeHomeButton — KHÔNG có
helper trong header chính thức nên để ngỏ (23.7 mục 2).

ABHOST — áp fade cho gương (impl-autohide-host.md):
- ABChannels.m (596 → 683 dòng): mục §6 mới — observer
riêng trên appbridge.open/.frame đọc key fade, trên
appbridge.knobs đọc kfade, cộng observer close/closeall
dọn dẹp; category ABHost (AutoHideApply) +
AHRegisterHostApply() trong nhánh SpringBoard cạnh
BWRegisterHostConfirm(). ABHostBMethods.m (1582 → 1753
dòng): statics của strand (NSMapTable khoá yếu lưu
opacity, bản ghi requested/applied theo bundle, trạng
thái knob toàn cục) + helper AHHostPaintView/
AHHostRestoreView + 3 method mới applyFade:forPane:,
setKnobsFade:, ahRestorePaneForBundle:.
bwAppliedSnapshotForBundle: cộng key `faded` đọc trạng
thái ĐÃ ÁP (không tính lại từ key của owner).
- Quyết định §5.2(i): chọn method riêng applyFade:forPane:
(không nới thân setFrame:) — nativeVisible đọc từ chính
kết quả đã áp pane.handleHit.hidden sau khi packet được
áp; frame lấy mất handle → khôi phục + ghi fade = NO
(quy tắc dừng QA19).
- Lệch bắt buộc (đúng tiền lệ §5 BridgeWake): handler
frame/open/knobs THẬT nằm ở ABHostGeometry.m (ngoài phạm
vi file); bản sao trong ABChannels.m là #if 0 chết. Giải
pháp: observer riêng trên cùng kênh + 1 hop main-queue để
registrar áp packet trước; riêng close/closeall KHÔNG hop
(khôi phục trước teardown, best-effort — bảng khoá yếu tự
dọn, không rò opacity-0).
- Kỷ luật sơn: layer.opacity chỉ ghi trong 2 helper (lưu
trị gốc lần đầu → set 0,0f; khôi phục nguyên trị, không
animation); grep toàn bộ dòng thêm mới: 0 phép gán
.hidden/.alpha/userInteractionEnabled. Cổng: 4 thân cấm
sửa khớp SHA-256 tuyệt đối trước/sau ở cả hai cây VÀ khớp
giá trị đã công bố vòng wake (setFrame 8606f40a…,
setBarVisible 3044b10d…, setHandleVisible 409cfb14…,
setKnobs b98a9f26…); diff census vs bản sync wake1:
BMethods +173/−2 (2 dòng trừ = comment của snapshot được
nới cho key faded), Channels −1 dòng (if một hàng thành
block thêm lời gọi đăng ký), còn lại toàn chèn mới. Build
module sạch exit 0; dylib chứa đủ 3 IMP mới + chuỗi
kfade/faded + format log [autohide] host.

ABINAPP — phát gói act (impl-autohide-app.md):
- BridgeWakePack.h bản AppBridge: BWTypeAct = 5 + V9/V10
nguyên văn thiết kế. ABInApp.m: static BWNameAct cạnh 4
tên sẵn có; hàm mới BWPostAct() ngay sau BWPostWake —
token riêng theo idiom notify_register_check, throttle
0,12 s, seq đơn điệu mod 4096, gen = BWGen, flag =
(BWKb == BWKbActive) lấy từ trạng thái keyboard guard
sẵn có, state/mode = 0, không mang nội dung chạm. Điểm
gọi duy nhất TRONG hook sendEvent sẵn có, tại khối mở dãy
(Began), TRƯỚC đánh giá cổng nuốt: `if (BWFresh())
BWPostAct();` — BWFresh() = known + tươi ≤ 2,5 s, không
thêm tiêu chí mới; dãy bị nuốt vẫn phát act; phát ở mọi
WAKE_MODE kể cả OFF/DRY_RUN.
- Kỷ luật: diff ABInApp.m so với bản wake1 đã ship là
THÊM THUẦN — 0 dòng sửa, 0 dòng xoá; đường nuốt/probe/
gate nguyên vẹn từng dòng; không thêm hook mới. Cổng:
harness trên header cuối 23/23 PASS ở cả hai bản (V1–V7
hai chiều + V8 + V9/V10 khớp hex thiết kế); build module
sạch, ABInApp.m 0 warning, dylib 538.856 B chứa chuỗi
bridgewake.v1.act; hook sendEvent đúng 1 điểm cài,
orig_SendEvent đúng 1 điểm gọi, sendEvent chỉ tồn tại
trong ABInApp.m.

### 23.5 Tích hợp fs1 (biên bản:
work/wake-round/integration-fs1.md)
- Ba điểm nối cuối (chỉ cộng, cả hai cây cmp identical):
(a) feed AHSourceDragEnd ở cuối endPaneDrag: trong
SCPCarSplit+Drag.m — phễu kéo pane tự feed, feed
idempotent nên trùng vô hại (car2 §4 để ngỏ, ĐÃ ĐÓNG);
(b) treo AutoHide khi solo hosted: ahSetSuspended:YES
ngay sau gán soloHostedBundle trong hostSolo:,
ahSetSuspended:NO ngay sau xoá trong endHostedSolo —
hai phễu set/clear duy nhất trong phiên sống;
dashboardInvalidated xoá ivar trực tiếp nhưng
ahSessionTeardown cùng method reset cả cờ treo + timer
nên không rò trạng thái (car2 §4 để ngỏ, ĐÃ ĐÓNG);
(c) ABChannelNames.m cộng hằng ABNotifyBWAct
byte-identical với SCPShared.m + static ABInApp.
- Chuẩn hoá: hai bản BridgeWakePack.h chỉ lệch comment
(code-only diff = 0) → lấy bản SplitScreen làm chuẩn,
4 vị trí md5 identical 17c004e0…; harness 15/15 PASS cả
hai module (V1–V10); 5 chuỗi kênh byte-equal ở 3 nơi
định nghĩa; Makefile hai module đủ TU mới.
- Candidate local: com.anlai.omnicar_1.0.3-fs1_
iphoneos-arm64.deb — 1.006.126 B, SHA-256
0a9f76b34bae40d118123c2a8251bd29635e597a8d8c4cac31337901e829a755;
control identical wake1 trừ Installed-Size; member lzma;
đóng bằng Theos make package sau make clean; make toàn
dự án (toolchain kiểm trước, đủ, không khôi phục).
- Gate 1 trên candidate (bung DEB; baseline r7 FAT lát
arm64 + wake1): selector parity 8/8 thành phần MẤT 0 so
với cả r7 và wake1 (AppBridge 705→716→725; SplitScreen
1093→1317→1385; 6 thành phần còn lại +0 so wake1); danh
sách file ≡ wake1 (176), đúng 6 dylib chuẩn, 0 dylib
QA19/QA20/DoubleTap/YouTubeHandle/NativeSolo; switch
fullscreenTestExpand default false có trong gói. Hồi quy:
g1 PASS (@0x7fb4 and #0x2 → cmp #0 → csel xzr,ne; sentinel
cmp #0xff csel eq); g2 PASS (@0x173d8 tst #0x2 → csel eq);
h C-A PASS (@0xc3c4 cmp w0,w22 → b.ne); h C-B PASS (block
@0xcd60: fmov d0,#1.0 → setAlpha: → setTransform:); f PASS
(sub #0x3 → cmp #0x2 → csel lo); publishKnobsNow đúng 1 eor
@0x15e34 (payload = !IsIdentity). Bốn thân ABHost cấm sửa
khớp SHA-256 giá trị đã công bố. hostFrameInfo superset
PASS (key gốc nguyên công thức, cộng đúng `fade`; knobs
cộng đúng `kfade`). Kỷ luật sơn PASS (AutoHide TU 0 phép
gán cấm; ABHostBMethods ghi layer.opacity chỉ trong 2
helper). FS PASS: OMCChromeSetHidden = 0; 0 điểm gọi
runSoloForPane:/toggleZoomForPane:/dividerDoubleTapped/
ratioPresetTapped từ code FS/AutoHide/Pinch; tham vấn
appAreaInParent: đúng 1 điểm; bwSetExpandedActive: chỉ
controller gọi (5 điểm chốt); adapter chuyển tiếp thuần,
0 biến trạng thái. Khoá pinch ENFORCE PASS: điểm gọi
requestExpand/Restore duy nhất trong nhánh
`mode == Enforce && wouldPinch` (đủ 5 cổng + session
re-check); mode mặc định DRY_RUN từ pref owner, pref vắng
→ DRY_RUN; allowlist mặc định rỗng; gói không chứa pref
đặt sẵn; entry của controller chỉ có 2 caller: adapter
(pinch) + nhánh [fs1-test]. sendEvent: đúng 1/8 binary
(AppBridge), 1 điểm cài hook, 1 điểm gọi orig_SendEvent.
Markers [fs1-test]/[autohide]/[wake1]/[pinch1] + 5 chuỗi
bridgewake có mặt đúng binary; 3 timer gốc không bị đụng.

### 23.6 Ship fs1 + xác minh hai lát trên FAT
(biên bản: work/wake-round/ci-fs1.md)
- Git: main 5427920c16a385b389b57e09a858791bf5f377b3
(source fs1), ci-fat-test c392db4f89d1a1d32f6606b5f6373b46edc15bc0
(merge). CI workflow build-fat-macos.yml (410962367),
run dispatch 42578683063 — SUCCESS (truy vấn foreground
trực tiếp; headSha c392db4 khớp; job build-fat 3m10s).
Run push-triggered 42578586477 trên cùng commit không
dùng, như vòng wake1.
- FAT: com.anlai.omnicar_1.0.3-rebuilt-fs1-fat_
iphoneos-arm64.deb — 1.200.648 B, SHA-256
41bb5b8bf21f87926449070c881ae453daf2d311ab2c91295e531494ce4b8a82
(kiểm lại trên bản copy ở handover, khớp tuyệt đối);
member debian-binary + control.tar.gz + data.tar.lzma;
control Package com.anlai.omnicar, Version 1.0.3.
SplitScreen 1.174.592 B và AppBridge 584.400 B đều FAT
arm64 + arm64e.
- Xác minh trên FAT (đo trên lát thin trích từ chính
FAT): kênh bridgewake 5/5 (state/query/wake/ack/act) ở
SplitScreen + AppBridge × cả hai lát; publishKnobsNow
đúng 1 eor mỗi lát (arm64 @0x12940, arm64e @0x1327c —
cùng mã lệnh eor w2,w26,#0x1); g1 dạng csel cả hai lát
(arm64 @0x75b8/0x75dc/0x75e0; arm64e @0x78b4/0x78d8/
0x78dc); markers đúng phân bổ ([fs1-test]×4, [autohide]×9,
[wake1]×13, [pinch1]×5 ở SplitScreen hai lát; [autohide]×2
ở AppBridge); ytlease/youtubeVirtualize vắng trong cả 8
binary + mọi plist/strings (đúng kỳ vọng — fs1 đứng
trước YTZ); selector parity so với FAT wake1: MẤT 0 ở cả
4 lát (SplitScreen 620→664, +44: 17 ah* + bwHandleActPacket:
+ 24 method SCPFullscreenController + adapter -init + 1
class method; AppBridge 194→197, +3 method fade phía
host); tập selector hai lát trong cùng binary identical.
UUID từng lát trong ACCEPTANCE_FS1.

### 23.7 Điểm diễn giải — để lại cho GPT
(theo integration-fs1 §4)
1. md5 thân setBarVisible:forPane: (Chrome) mà car2
công bố (a79bc0d5…) KHÔNG tái lập được bằng bất kỳ công
thức trích nào tại tích hợp (sig→method kế:
23e58032…; sig→} cột 0: f9466329…). Nhưng dưới MỘT công
thức nhất quán, thân hiện tại byte-identical với thân
trong cây wake1 đã ship (cùng md5 23e58032… ở cả hai) →
cổng đạt THEO Ý NGHĨA (thân không đổi một byte từ
wake1); lệch nằm ở công thức trích của car2, không ở
code. Đề nghị GPT ghi nhận để các vòng sau dùng một
công thức chung.
2. ahForgetView: cho removeHomeButton GIỮ NGUYÊN trạng
để ngỏ của car2 §3: header chính thức của TU AutoHide
(đúng 10 method) không có method gỡ bản lưu opacity
theo view; tích hợp không tự chế API. Đánh giá rủi ro
của car2 giữ nguyên: bản lưu là associated object chết
theo view + registry NSHashTable yếu + ahRevealBody:
khôi phục mọi view đã đăng ký + button tạo lại luôn qua
refreshHomeButton (đã có áp-lại sơn) → khe hở thực tế
gần như không có; GPT muốn khoá cứng thì TU AutoHide
cần thêm method kiểu ahForgetView:.
3. Comment tồn dư trong SCPPinchController (cổng 2,
~:590–594) vẫn mô tả adapter rỗng thời A1-BLOCKED
("state is always Unknown…") — code đã đọc trạng thái
thật của controller qua adapter chuyển tiếp; chỉ chữ là
cũ. Không sửa tại tích hợp (file thuộc strand pinch);
GPT/tác giả strand cập nhật khi tiện.
4. Kiểm hai-lát trên FAT (mục 5 trong danh sách §4 của
biên bản tích hợp: candidate local arm64-only nên các
kiểm từng lát phải chạy lại trên FAT của CI như vòng
wake1) — ĐÃ ĐÓNG bởi ci-fs1 §4: mọi kiểm hai-lát đã
chạy lại trên chính FAT fs1 và đạt (23.6).
Ghi chú thêm từ cùng §4: bất đối xứng solo ở
dashboardInvalidated (mục 4 của biên bản) được xác nhận
an toàn nhờ ahSessionTeardown reset cả cờ treo + timer
trong cùng method — không phải thiếu điểm nối; và các
câu hỏi runtime của Gate 2 (mục 6: hop ABHost,
targetVerified, phân bố ack, probe pinch) giữ nguyên
cho phiên xe gộp, tích hợp không tự quyết.
Hai điểm diễn giải của strand A FS1 (impl-fs-controller):
5. Quét cửa sổ chrome bằng idiom connectedScenes →
UIWindowScene.windows sẵn có của module thay cho
UIApplication.windows mà thiết kế §2 nêu — cùng tập cửa
sổ của process, tránh API deprecated (cảnh báo duy nhất
khi biên dịch với -Werror); không khác biệt hành vi.
6. fsRestoreConfirmed đo appAreaInParent: trên superview
HIỆN TẠI của container (sự thật tại chỗ) thay vì parent
trong snapshot — nếu container bị re-parent giữa chừng,
phép đo theo parent thật; hướng an toàn.

### 23.8 Trạng thái nghiệm thu + điều kiện mở ENFORCE pinch
- PENDING — chờ MỘT phiên xe gộp (kịch bản trong
ACCEPTANCE_FS1): (a) FS controller staging theo Gate 3
rút gọn của thiết kế §8 — bật công tắc fullscreenTestExpand:
split phình đúng window bounds, cả hai ô phóng theo, tỉ
lệ giữ nguyên, dock + status bar + nút Home biến mất;
trong EXPANDED chạm/cuộn/gõ bình thường cả ô native và
hosted; tắt công tắc → container về đúng frame trước,
clips/cờ status bar/Home/dock trở lại đúng trạng thái
trước, log chốt fs expand confirmed / fs restore
confirmed (không unconfirmed/rollback); 10 chu kỳ không
lệch tích luỹ; đang EXPANDED đổi app + ngắt CarPlay →
kết nối lại ở SPLIT sạch. (b) AutoHide theo 6 điểm đo
§5.5 của thiết kế. (c) Gate 2 wake dry-run (kịch bản từ
ACCEPTANCE_WAKE1, không đổi). (d) Nghiệm thu Weather
fixround7 (vẫn PENDING từ §21.9). (e) Kiểm núm trên xe
(vẫn PENDING từ §22.9).
- Điều kiện mở PINCH ENFORCE (cả ba phải đủ, theo thiết
kế §8 + khoá A6): (1) controller đạt nghiệm thu staging
trên xe; (2) ≥ 3 lần pinch-in khôi phục thành công từ
EXPANDED do CÔNG TẮC TEST tạo ra ngay trong staging đó;
(3) 1 lần ngắt CarPlay giữa EXPANDED sạch (về SPLIT,
dock/status bar/Home bình thường). Thiếu một điều kiện →
pinch giữ DRY_RUN.
- Giữ nguyên từ các vòng trước (§22.9): VISUAL_ORIGINAL_COMPARISON
= PENDING; bản sao Weather phía Prefs (OMCCommon.m) chưa
rà; đuôi !logoView playIntro phía xe; cellClass giữ nhãn
UNVERIFIED. QA20 vẫn là bản dùng hằng ngày của Nguyen —
wake1/fs1 là bản nghiệm thu, chưa thay QA20 cho tới khi
fullscreen được nghiệm thu trên xe.

## 24) VÒNG YTZ2 — KHẮC PHỤC TỔNG HỢP SAU FS1 THEO WO GPT (2026-11-09)

### 24.1 Bối cảnh: fs1 lên xe, kiểm toán GPT, WO và bản ytz1 bị cách ly
- fs1 được Nguyen cài và test trên xe chiều 2026-11-09. Hai
phát hiện trên xe TRƯỚC khi GPT kiểm toán: (a) nhóm TEST
của controller KHÔNG hề hiện trong trang Chia màn hình —
specifier `fullscreenTestExpand` chỉ nằm trong
FeatureSplitScreen.plist, trong khi OMCSplitScreenController
dựng trang 100% bằng code và không bao giờ nạp plist đó;
strand Prefs của fs1 đã kiểm chứng nhầm cơ chế (đường
loadSpecifiersFromPlistName của các trang feature khác).
(b) AutoHide mờ được toàn bộ controls kể cả logo, nhưng
chạm nội dung app KHÔNG gọi lại được — chỉ bấm trúng đúng
vị trí nút logo vô hình mới hiện (đường F3 sống; đường
activity từ chạm nội dung gãy).
- GPT đối chiếu báo cáo với source trên repo và kết án BA
lỗi bằng mã nguồn (không cần log/video): (1) act phía app
bị cổng độ tươi state 2,5 s tự khoá đường gọi lại
(ABInApp.m:505 `if (BWFresh()) BWPostAct();` — owner không
phát state liên tục nên khi đã mờ lâu, cú chạm cần reveal
mang state cũ và không bao giờ phát act); (2) PINCH-IN
KHÔNG THỂ XẢY RA: controller luôn gọi
bwSetExpandedActive:forBundle:nil (SCPFullscreenController.m:306)
trong khi arbiter đòi pane.bundleID == bwExpandedBundle ở
ba điểm (BridgeWake.m:231/:320/:658 — điểm thứ ba do strand
sửa phát hiện thêm, xem 24.5(v)) → hàng EXPANDED không mở
cho pane nào; cổng Gate 1 của fs1 chỉ kiểm ĐIỂM GỌI của
bwSetExpandedActive, không kiểm GIÁ TRỊ truyền vào; (3)
YT-Zoom nhận diện split sai ở ca hỗn hợp: ABYTZoom.m:151
dùng host.panes.count <= 1 để suy không-split — ca 1 ô
native + 1 ô YouTube hosted thì ABHost chỉ có 1 hosted
pane nhưng xe đang split → isSplit sai.
- Hệ quả phán quyết của GPT: KHÔNG chấp thuận pinch
ENFORCE mặc định trên mọi ô khi ba điểm chưa sửa; ra WO
"KHẮC PHỤC TỔNG HỢP SAU FS1" (W1–W5, P1–P4, Y1–Y4 +
Weather giữ nguyên + núm giữ nguyên) và giữ yêu cầu MỘT
DEB duy nhất với công tắc runtime độc lập từng tính năng
+ nghiệm thu theo thứ tự 5 bước.
- Bản ytz1 (vòng "nối pinch luôn" theo lệnh Nguyen 14:37:
pinch mặc định ENFORCE, gỡ staging, YTZ mặc định BẬT —
impl-pinch-wiring.md, integration-ytz1.md; candidate
1.013.910 B SHA 119d6108…; source main 0c5da2e) bị CÁCH LY
theo WO: chứa cả ba lỗi trên. Ghi đúng sự thật thao tác:
coordinator ra lệnh dừng strand CI của ytz1 SAU khi run
dispatch 42581690791 đã được kích hoạt; lệnh dừng tới khi
run đã chạy xong nên FAT ytz1 VẪN RA LÒ (1.210.344 B,
SHA-256 4caa2568d6ef9d145a609ca92e82f30591da45a729688d3d86cfdb7bd1c186a1,
ci-fat-test fa15909; biên bản ci-ytz1.md) — bản này nằm
cách ly ở handover, KHÔNG giao, bị ytz2 thay thế.
- Mức báo cáo của vòng: cả năm strand = SOURCE HOÀN
THIỆN + STATIC PASS (hai lượt kiểm độc lập + tích hợp +
kiểm hai lát trên FAT, 24.3/24.4). Nghiệm thu xe: mọi
track PENDING (24.6). Baseline bất biến: fs1 FAT
41bb5b8b….

### 24.2 Năm strand sửa (mỗi strand một chủ file)
STRAND A — phía app, W2-A/W3/W1 (fix-w-act-app.md; file
duy nhất ABInApp.m + mirror, 8 hunk):
- W2-A tách act khỏi độ tươi: cờ danh tính phiên riêng
BWActSessionVerified (khai báo :152), đặt = YES tại đúng
điểm BWOnStatePacket chấp nhận gói state hợp lệ cho
chính bundle (:423, cùng điểm đặt BWKnown), xoá tại
BWResetAll khi phiên đóng (:766). Điểm gọi tại mở dãy
(:629) đổi `if (BWFresh()) BWPostAct();` thành
BWActOnSequenceStart(began) — vẫn TRƯỚC đánh giá cổng
nuốt, nên dãy bị nuốt vẫn tính activity.
- W3 trói scene: BWActHostedScene() (:316) — thẩm quyền
theo thứ tự: lease YT-Zoom đã ghim sceneID → scene khớp
qua YZSceneCandidateID (cơ chế sẵn có, chỉ đọc); ngược
lại scene của ABKeyWindow() (cùng cửa sổ cổng nuốt dùng
xác minh target). Không định danh được → act-drop-
target-unknown, KHÔNG phát; touch thuộc scene khác (màn
hình iPhone) → act-drop-scene, KHÔNG phát. window != nil
không bao giờ đủ một mình.
- W1 instrumentation: BWPostAct (:291) đổi chữ ký trả
BOOL + mã notify_set_state/notify_post và bộ đếm fail;
mọi quyết định act log [autohide] kèm stamp monotonic
t= (BWActNowMs :198, mach_absolute_time) + stateage=
(tuổi bản sao state tại Began): act-posted /
act-drop-nosession / act-drop-scene /
act-drop-target-unknown.
- Kỷ luật không đụng (grep chứng minh): BWFresh() còn
đúng 6 điểm gọi, tất cả thuộc đường nuốt/probe/mode/query
— suppression nguyên vẹn; YZ section diff = 0;
BridgeWakePack.h không sửa. Harness codec độc lập 21/21.
STRAND B — phía owner, W1/W2/P1/P4 (fix-wp-owner.md;
SCPCarSplit+BridgeWake.m/.h, SCPCarSplit+AutoHide.m):
- W1: bwHandleActPacket: viết lại — 6 reason loại riêng,
đúng thứ tự kiểm của WO: decode-fail (gói sai
type/valid) → bad-hash → bad-gen (log cả gen hiện tại) →
session-inactive (!self.active) → not-assigned (pane
nil/lệch slot/không thuộc hostedPanes) → split-inactive
(state slot INACTIVE); chấp nhận → log act-accepted rồi
mới gọi ahNoteActWithKbActive:. Điểm session-inactive
trước đây lọt qua owner rồi chết ở guard !self.active
trong ahNoteActivity: — nay loại sớm kèm reason, kết quả
cuối không đổi. ahRevealBody: log reveal-applied
reason=%s views=%lu (views = số view còn giữ bản lưu
opacity đếm TRƯỚC khi khôi phục); tay trao fade xuống
host giữ nguyên (pushHostFramesLive:NO ngay sau khôi
phục).
- W2 state renewal: bwRenewTimer + bwRenewMaintain /
bwRenewTick: (BridgeWake.m:243–282 theo bản kiểm độc
lập). Chu kỳ 1,0 s; mỗi tick phát lại state HIỆN TẠI của
MỌI pane hosted qua bwQueueEmitForPane: → emit queue
giãn 30 ms → poster duy nhất BWEmitStatePacket → seq
tăng, gen giữ nguyên, nội dung/ngữ nghĩa không đổi.
Vòng đời: maintain gọi ở cuối bwRecomputeForPane: và
trong bwSessionTeardown; điều kiện bwInstalled &&
active && hostedPanes.count > 0. Độ cũ biên mỗi pane
≈ 1,0 s + 30 ms × (số pane − 1) ≪ 2,5 s — suppression có
state tươi sau khi ẩn lâu; act KHÔNG dựa vào renewal
(act đi theo danh tính phiên, strand A).
- P1 arbiter EXPANDED theo PHIÊN: gỡ equality với
bwExpandedBundle ở CẢ BA điểm dùng (bwPinchAllowedForPane:
— cờ gói; pinchDispositionForPane: — đường bắn; điểm
promote HIDDEN→VISIBLE trong bwRecomputeForPane:). Hai
hàm arbiter dùng cùng một vị từ: bwExpandedFlag &&
self.active && pane ∈ allPanes && !bwWakePendingBySlot[slot]
&& !self.resizing (allPanes có chủ đích: pane native của
split hỗn hợp không thuộc hostedPanes nhưng là pane sống
của phiên). bwExpandedBundle chỉ còn vai trò ghi/log ở
setter. Truy vết tĩnh 6 trường hợp WO trong biên bản
strand §3 (xem thêm caveat 24.5(ii)/(iii)).
- P4: pinchMode mặc định về DRY_RUN ở cả static init
(:46) và nhánh pref vắng trong bwReloadModesAndRepublish
(:476) — supersede mặc định ENFORCE của vòng
impl-pinch-wiring theo phán quyết GPT, lý do ghi ngay
trong comment code. ENFORCE vẫn tới được trong cùng bản
qua pref tường minh bridgewake.pinchMode = 2 (0/1/2 tôn
trọng). wakeMode giữ DRY_RUN.
STRAND C — đường kiểm thử controller độc lập + đường
thoát + nhóm Chẩn đoán (fix-p-diag.md;
SCPFullscreenController.m/.h + toàn bộ OmniCarPrefs):
- Controller: khôi phục listener pref dưới marker
[fs-diag] — fsInstallIfNeeded (:119–135) đọc nền
fullscreenDiagExpand (không hành động lúc cài) + đăng ký
notify_register_dispatch trên kênh prefschanged sẵn có;
fsDiagPrefsChanged (:149–167): đổi cạnh → ON gọi đúng
fsRequestExpand…provenance:@"diag", OFF gọi
fsRequestRestore…provenance:@"diag" — cùng cổng
vào/txn/xác-nhận-đọc-lại với pinch. LEVEL SAFETY: bất kỳ
post nào thấy pref OFF trong khi máy EXPANDED vẫn restore
kể cả khi lỡ cạnh — đường thoát không phụ thuộc
recognizer (P4). Controller CHỈ ĐỌC pref (grep API ghi =
0), không bao giờ tự sửa trạng thái pref.
- Prefs: MỘT nhóm "Chẩn đoán" (section 6, cuối trang Chia
màn hình) dựng 100% BẰNG CODE trong
OMCSplitScreenController.m theo idiom trang (bài học
specifier-plist của fs1): numberOfSections 6→7 (:145),
case 6 (:154), header/footer (:170/:178), ba control tại
:363–407 persist qua storeValue:forKey: (domain
com.anlai.omnicar + notify_post prefschanged): (a)
switch fullscreenDiagExpand def NO (:378); (b) switch
youtubeVirtualize def YES — vắng = ON khớp YZPrefEnabled,
làm đối chứng Y2 ngay trên máy (:389); (c) segment
bridgewake.pinchMode ghi nguyên văn 0/1/2, def 1 = Đo
(:400). Strings SplitScreen en/vi 46 → 56 khoá (10 khoá
DIAG, 46 khoá cũ nguyên giá trị, bplist round-trip sạch).
Sections 0–5 không đổi hành vi.
- Cổng strand: binary Prefs chứa cả 3 khoá chẩn đoán
trong CODE (×1 mỗi khoá) — đúng cổng đã FAIL ở fs1.
STRAND D — Y1 isSplit + Y4 instrument (fix-y-issplit.md;
SCPCarSplit.m chỉ trong builder hostFrameInfo +
ABYTZoom.m; không đụng 4 hàm cấm ABHost):
- Nguồn sự thật tại owner trình bày: split =
self.active && self.paneCount >= 2 && self.zoomedSlot == nil.
Hai hạng tử cuối là NGUYÊN VĂN vị từ trình bày VERIFIED
của module -[SCPCarSplit dividersVisible]
(SCPCarSplit+Layout.m:270–273, IMP @0x11b50); active có
điểm đặt YES duy nhất tại SCPCarSplit.m:132; paneCount =
slots.count (:445). KHÔNG suy từ key single của bar (WO
cấm). EXPANDED của FS controller không đặt zoomedSlot
(controller chỉ đọc tại :298/:540; gán chỉ ở tính năng
zoom) → split giữ YES khi phình, đúng ngữ nghĩa phiên.
- Vận chuyển: cộng split + splitver = @1 tại
SCPCarSplit.m:2082–2083 trong builder
hostFrameInfo:pane:live:handle: (:2042), phủ cả hai điểm
phát (open :1896, frame :2013). Phía host: YZComputeIsSplit
(ABYTZoom.m:189) đọc kho session YZSessionSplit{Value,At,Ver}
(ghi bởi YZNoteSessionSplit :167 qua observer open/frame
:540); giá trị là trạng thái-sự-kiện, không hết hạn theo
tuổi; gói open đầu tiên tới trước launch-complete nên kho
có dữ liệu trước lần publish đầu. panes.count còn đúng 1
chỗ (:199) trong fallback cho gói thiếu trường, mỗi lần
fallback log [ytz] isSplit-fallback (throttle 5 s).
- Y4 chỉ instrument, không đổi hành vi, không đảo quyết
định không-restore-snapshot: log [ytz] lease-lapse: …
gen=… heal=… trong nhánh ack expired TRƯỚC các guard
(:456) + [ytz] owner phien host: <uuid> tại
YZRegisterHostLease (:517).
STRAND E — W4 probe thụ động (fix-w-probe.md; TU mới
SCPTouchProbe.h/.m + 2 hunk cài trong SCPHooks.m +
Makefile +1 TU):
- Hook -[UIApplication sendEvent:] phía CarPlayApp: gọi
orig TRƯỚC, nguyên vẹn, quan sát sau trong @try/@catch;
không huỷ touch, không đổi hitTest target, không cài
recognizer trong lúc dispatch, không gọi bất kỳ API
activity/reveal/nuốt nào (grep = 0). Chỉ tồn tại trong
process CarPlayApp (điểm cài sau cổng SCPHostIsCarPlayApp
+ crash guard trong SCPInitDashboardHooks).
- Phân loại mỗi Began: scene theo cơ chế của module
(touch.window == container.window → carplay; ==
trayWindow → carplay-aux; còn lại foreign/unknown ghi
[probe-foreign], không bao giờ quy thành wake; class
window luôn được log) + pane trúng theo hình học layout
hiện tại (chỉ đọc; slot + bundle + hosted|native) +
chuỗi chạm theo con trỏ UITouch (Began đầy đủ kèm t=
monotonic + seq; Moved đếm; Ended/Cancelled đóng bằng
dòng tổng kết complete/dur; phase không Began → orphans).
Kết luận ở mức hình chữ nhật của ô — đúng granular WO W4
yêu cầu để GPT quyết có dời feed activity về CarPlayApp
hay không. Probe luôn bật trong bản chứa nó (không pref
tắt — tính chất bản đo một phiên); gỡ = bỏ TU + điểm cài.

### 24.3 Ba lượt kiểm độc lập (chỉ đọc, không hoà giải lệch)
- verify-wake-act.md: đường act — ĐẠT cả 5 mục (a)–(e):
điểm gọi act duy nhất :629 không qua BWFresh; thân hai
hàm act chứa 0 BWFresh; cờ phiên đặt/xoá đúng điểm; trói
scene fail-closed đủ 4 chuỗi trong binary; owner đủ 6
reason đúng thứ tự (BridgeWake.m:605–657); renewal qua
poster duy nhất, seq tăng/gen giữ; ahRevealBody
(AutoHide.m:186–207) + tay trao fade nguyên vẹn. Không
phát hiện lệch nội dung so với hai biên bản strand; một
khác biệt MÔ TẢ ghi ở 24.5(iv).
- verify-arbiter-diag-probe.md: arbiter/diag/probe — ĐẠT
(a)–(d); mục (e) probe ĐẠT về chất nhưng con số hook
"32" KHÔNG khớp phép đếm call-site — ghi ở 24.5(i). Hai
ghi chú arbiter ở 24.5(ii)/(iii).
- Kiểm độc lập YZ (đọc lại trực tiếp source + tính lại
độc lập, ghi trong handover-ytz2 §3): nguồn sự thật
isSplit, đường vận chuyển 2 khoá, kho session phía host,
EXPANDED-vs-split (grep toàn module: controller không
gán zoomedSlot), 4 hash cấm ABHost MATCH cả 4 (tự tính
lại SHA-256 thân hàm signature→^}: setFrame 8606f40a…,
setBarVisible: 3044b10d…, setHandleVisible: 409cfb14…,
setKnobs: b98a9f26…), lease/ack/heartbeat ngoài Y1+Y4
không đổi, hostFrameInfo superset = 30 khoá (vòng này
chỉ cộng đúng split/splitver).

### 24.4 Tích hợp + CI FAT ytz2 (integration-ytz2.md, ci-ytz2.md)
- Mirror: strand D chỉ sửa cây project/ — tích hợp đối
chiếu 13 cặp file của 5 strand, chép project/ → src/
đúng 2 file lệch (ABYTZoom.m, SCPCarSplit.m); sau chép
13/13 identical (audit CI độc lập đếm 14/14 cặp gồm cả
file .h — cùng kết luận).
- Candidate local com.anlai.omnicar_1.0.3-ytz2_iphoneos-arm64.deb:
1.021.310 B, SHA-256 4737cfa93c2c5a6a7c7ade37a0b7731718f626bb267dd2d03cf6d9f54018d6ad;
control diff vs ytz1 chỉ Installed-Size (3712 → 3748);
danh sách file identical ytz1 (176 file, cùng một lệnh
đếm cho cả hai candidate — xem 24.5 điểm phụ).
- Gate 1 trên candidate: selector parity vs fs1 — 6/8
thành phần identical; AppBridge mất 0 (+73 = bề mặt YZ
của ytz1, identical ytz1); SplitScreen mất đúng 4 (bề
mặt [fs1-test] đã gỡ ở vòng ytz1 theo lệnh 14:37, không
phải mất ở vòng này) + cộng 7 (đúng bề mặt WO: 3 diag +
2 renewal + sendEvent: + valueWithPointer: của probe);
hồi quy g1/g2/h(C-A+C-B)/f PASS; hostFrameInfo superset
PASS (chỉ cộng split/splitver so với vòng này, fade từ
vòng fs1); điểm ghi requestedOrientation duy nhất;
sendEvent phía app 1 hook/1 orig.
- Git: source main a7630303fbd9a1af705fbf880093185401c46dc0
(27 file); ci-fat-test 5c5698f04f7b2e7721c1f1abfef36e97d8b533be
(merge main; diff project/src giữa hai nhánh = 0).
- CI: workflow 410962367 dispatch trên ci-fat-test, run
42583754018 SUCCESS (theo dõi foreground + truy vấn trực
tiếp). FAT com.anlai.omnicar_1.0.3-rebuilt-ytz2-fat_iphoneos-arm64.deb:
1.221.708 B, SHA-256 bb59ab5653540f21d915631213621c0158fc2850038f6d0959b3eca95087dc20;
members debian-binary + control.tar.gz + data.tar.lzma.
- Kiểm hai lát trên lát thin trích từ chính FAT: kênh
bridgewake 5/5 × (SplitScreen + AppBridge) × 2 lát;
ytlease/ytleaseack trong AppBridge cả hai lát; chuỗi mới
của vòng đủ vị trí (act-posted/act-drop ×3 phía AppBridge;
bw renew ×3, [fs-diag] ×3, [probe]/[probe-foreign] phía
SplitScreen; isSplit-fallback phía AppBridge; splitver
cả hai phía); fullscreenTestExpand = 0 TOÀN GÓI;
fullscreenDiagExpand có trong SplitScreen cả hai lát;
binary Prefs chứa cả 3 khoá chẩn đoán trong CODE ở cả hai
lát; publishKnobsNow đúng 1 eor mỗi lát (arm64 @0x129dc,
arm64e @0x13318 — cùng dạng lệnh như fs1/ytz1, chỉ lệch
địa chỉ); g1 csel + cổng mask + sentinel đủ hai lát, địa
chỉ trùng ytz1; parity vs FAT fs1 khớp kỳ vọng (SplitScreen
1384 → 1387: mất 4 bề mặt test, thêm 7; AppBridge 724 →
797: mất 0). UUID 8 binary × 2 lát: bảng trong
ACCEPTANCE_YTZ2 / ci-ytz2 §3.

### 24.5 Điểm diễn giải — ghi trung thực để GPT phán
(i) QUY ƯỚC ĐẾM HOOK. Con số "32" trong biên bản strand E
và cổng các vòng trước là đếm DÒNG GREP gồm cả dòng
comment. Đếm call-site thật trên source cuối:
SCPHooks.m = 29 call-site thật (31 dòng grep, có 2 dòng
comment tại :2/:614); SCPSpringBoardHooks.m = 1 (:175;
2 dòng grep, 1 comment :169); SCPHomeHooks.m = 0 (1 dòng
comment); SCPTouchProbe.m = 1 (:198). TỔNG MODULE = 31.
Baseline thật của fs1 = 30 (29 + 1) → delta của vòng này
= đúng +1 = probe, và binary khớp (import
_MShookMessageEx + sendEvent: xuất hiện trong tập
methname của SplitScreen). Kết luận "thêm đúng 1 hook"
ĐẠT; con số tuyệt đối "toàn module 32" KHÔNG đạt theo
phép đếm call-site. Từ vòng này hồ sơ dùng phép đếm
call-site.
(ii) ĐIỂM PROMOTE KHÔNG NGUYÊN VĂN CÙNG VỊ TỪ. Hai hàm
arbiter dùng nguyên văn vị từ phiên 5 toán hạng, nhưng
điểm promote HIDDEN→VISIBLE trong bwRecomputeForPane:
(BridgeWake.m:399–400) chỉ viết dạng rút gọn
`state == BWStateHidden && bwExpandedFlag`. Tương đương
ngữ nghĩa nhờ các guard bao quanh đã thiết lập sẵn:
assigned (:356) = self.active ∧ bundle.length ∧ pane ∈
hostedPanes; state HIDDEN chỉ tới được khi không
wake-pending (nhánh WAKING :362 đứng trước) và không
resizing (resizing ⊂ transient → UNKNOWN, :373–378).
Không phải lỗi hành vi — ghi để GPT biết dạng thật của
code. Bất đối xứng cấu trúc kèm theo: promote chỉ chạy
cho pane hosted (state packet chỉ tồn tại cho pane
hosted); hai hàm arbiter bao cả allPanes gồm native —
đúng vai trò từng điểm.
(iii) RANH GIỚI CA PANE-BỊ-XOÁ-KHI-EXPANDED. Khẳng định
"cờ rơi về INACTIVE" (bảng truy vết ca 5 của strand B)
phụ thuộc recompute/teardown ĐÃ chạy cho pane bị xoá.
Nếu bwStateBySlot của pane đó còn giữ VISIBLE cũ và
recompute chưa chạy, disposition rơi về HÀNG SPLIT
THƯỜNG (VISIBLE → Allowed theo hàng thường, không phải
hàng EXPANDED) — hành vi cũ, nằm ngoài bảng 6 trường hợp
của WO, vòng này không đổi.
(iv) MÔ TẢ ĐIỂM BWFresh :633 PHÍA APP. fix-w-act-app.md
gọi điểm này là "báo cáo mode tại mở dãy" — mô tả không
chính xác. Đọc code (verify-wake-act (b) mục 5): đó là
hiệu chỉnh wouldSwallow khi gói state ra lệnh wakeMode ==
Off — BWSeqWouldSwallow && BWKnown && BWFresh() &&
BWWakeMode == BWModeOff → huỷ wouldSwallow, reason
@"mode"; đứng SAU điểm phát act :629, thuộc đường
nuốt/probe. Phân loại đường không đổi; chỉ sửa cách gọi
tên trong hồ sơ này.
(v) ĐIỂM EQUALITY THỨ BA. WO kể hai điểm arbiter; strand
B phát hiện và sửa thêm điểm thứ ba dùng cùng mô hình
bundle sai — điểm promote HIDDEN→VISIBLE trong
bwRecomputeForPane: (nay là BridgeWake.m:399–400). Không
sửa điểm này thì state vẫn sai dù hai hàm arbiter đúng.
Đây là cùng một lỗi mô hình, đã sửa cả ba.
- Phụ 1: strand C cảnh báo lệch default (trang Chẩn đoán
hiện "Đo" khi pref vắng trong khi owner lúc đó còn đọc
vắng = ENFORCE) — ĐÃ ĐÓNG bởi thay đổi P4 của strand B
(default DRY_RUN ở cả hai phía; kiểm độc lập (b) xác
nhận nhất quán, segment Prefs def:1 khớp).
- Phụ 2: comment §7 đầu mục YT-ZOOM trong ABChannels.m
còn câu mô tả observer "track the single key for the
lease's isSplit field" — nay single chỉ còn nuôi nhánh
fallback. Việc dọn comment, không ảnh hưởng hành vi;
xếp cùng comment tồn dư SCPPinchController cho vòng dọn.
- Phụ 3: đếm file trong gói — integration-ytz1 ghi 179
(đếm cả thư mục/mục phụ), vòng này đếm 176 = 176 bằng
một lệnh find . -type f cho cả hai candidate; kết luận
identical không đổi.

### 24.6 Trạng thái nghiệm thu (thang WO) + việc còn mở
- Mọi track: STATIC_PASS. RUNTIME_PASS / DEVICE_PASS:
tất cả PENDING — bản này chưa chạy trên xe. Kịch bản
nghiệm thu MỘT phiên theo đúng thứ tự 5 bước của WO
nằm trong ACCEPTANCE_YTZ2: (1) AutoHide + Wake DRY_RUN
theo W5 (mờ 4 s / +10 s / +30 s chạm đều phải hiện;
YouTube đang phát / Maps đang mở / bàn phím đang hoạt
động; chạm màn hình iPhone không gọi nhầm controls xe;
10 chu kỳ không mất controls vĩnh viễn — DRY_RUN và
ENFORCE chấm RIÊNG, không gọi DRY_RUN là đạt chuẩn nuốt
QA180); (2) controller trực tiếp qua [fs-diag], Pinch
OFF (ma trận P2: 10 chu kỳ expand/restore, chụp frame
trước/sau — hai ô giữ tỉ lệ, dock/Home/status bar ẩn
đúng, chạm đúng vị trí, restore trả frame + clipping,
không kẹt dock sau disconnect/teardown/app crash);
(3) Pinch DRY_RUN rồi ENFORCE khi đường restore đạt;
(4) YTZ OFF đối chứng → ON (Y2: lease cấp đúng scene/
kích thước, windows ≥ 1, mismatch = 0; ca kết án
YouTube hosted + Maps native phải có split=1 và KHÔNG
có isSplit-fallback); (5) Weather (tiêu chí bắt buộc
fixround7) + núm + hồi quy toàn bộ.
- Điều kiện mở ENFORCE pinch cập nhật theo P4: default
trong bản = DRY_RUN; ENFORCE chỉ qua segment Chẩn đoán
= 2 SAU KHI controller qua nghiệm thu độc lập ở bước 2
và đường restore đạt ở bước 3. Ba điều kiện xe của §23.8
(controller staging đạt + ≥ 3 pinch-in từ EXPANDED do
công tắc tạo + 1 ngắt giữa EXPANDED sạch) vẫn là căn cứ
đánh giá, nay công tắc tạo EXPANDED là fullscreenDiagExpand.
- Giữ nguyên các giới hạn còn mở từ handover-ytz2 §5:
quyết định dời feed activity về CarPlayApp chờ dữ kiện
[probe]; cặp pinch trên ô hosted có tới recognizer
container không vẫn chưa đo; thang leo Y3 chưa dùng;
đo Y4 (hết hạn lease/đổi owner) chưa chạy;
VISUAL_ORIGINAL_COMPARISON = PENDING; bản sao Weather
phía Prefs chỉ audit đọc khi có lệnh; ahForgetView: chờ
GPT phán; đuôi !logoView playIntro + SSSplash
userInteractionEnabled [INFERRED] vẫn đỗ. QA20 vẫn là
bản dùng hằng ngày — ytz2 là bản nghiệm thu duy nhất
hiện hành, ytz1 cách ly, fs1 giữ baseline rollback cùng
fixround7 FAT + gói hợp nhất QA20.

## 25) VÒNG YTZ3 — SỬA SAU LOG PHIÊN YTZ2 THEO PHÁN QUYẾT GPT (2026-11-09)

### 25.1 Phán quyết phiên xe ytz2 (hai log, upload 0bf3273)

Nguyen cài ytz2 và chạy phiên 15:27–15:42 (cửa sổ phân
tích theo dấu code: ytz2 từ dòng [probe] đầu 15:27:28,
PID 34376; trước đó là fs1). Hai file: OmniCar.log
724.079 B (15:33–15:42) + OmniCar.log.old 2.098.672 B
(13:49–15:33). Ba đội phân tích song song (analysis-a1
vòng đời, a2 wake, a3 ytz/pinch/weather/núm — nộp ở
reports/ vòng này), số đếm khớp nhau giữa các đội.
Cả hai file: 0 chữ ký crash/exception (Exception /
unrecognized / SIGBUS / abort / EXC_ đều 0).

- **YT-Zoom — DEVICE PASS.** Lease cấp 2 lần (gen=0
  15:27:42; gen=1 sau revoke pref), cả hai mang
  split=1. Ca quyết định là ca hỗn hợp khó nhất:
  YouTube hosted + Maps native — chủ renew ghi
  `panes=1` (chỉ một pane hosted) nhưng lease vẫn
  split=1: sửa Y1 đúng đúng tại điểm phép đếm pane
  cũ cho kết quả sai. Ack: applied 6/6 windows=1
  mismatch=0; request 5; revoked 2 (pref + teardown);
  expired 0; lease-lapse 0; isSplit-fallback 0.
  Fullscreen YouTube 15:27:45.036: app phát tuyên bố
  ngang (mask 2), host chặn gói tại cổng tiêu thụ
  CÙNG mili-giây; trong toàn cửa sổ lease: 0 dòng
  `doi yeu cau xoay`. Kéo divider đổi size lease theo
  (318→325→224→238, cao 300). Khớp báo cáo xe của
  Nguyen (video phóng to hoàn chỉnh). **Caveat giữ
  nguyên:** cửa sổ đối chứng OFF chỉ kéo dài 0,5 s —
  hành vi OFF chưa đo được; đối chứng Y2 phải đo lại
  dài ở phiên ytz3 (ACCEPTANCE_YTZ3 bước 4: tắt ≥ 10 s).
- **Wake phía hosted — DEVICE PASS (đường
  activity/reveal).** Vòng act khép kín 32/32:
  act-posted 32 (YouTube 12, Facebook 18, TikTok 2)
  → act-accepted 32 → owner drop 0 ở cả 6 reason.
  Phía app: drop nosession ×1 duy nhất (TikTok
  15:33:15, stateage=-1 — cổng danh tính phiên chặn
  đúng thiết kế), scene 0, target-unknown 0.
  reveal-applied 17, 100% reason=activity, views=5,
  trễ act→reveal 0–3 ms. State renewal: 362 tick,
  Δ đo thực = 1,00 s đều. State age trong act: 3–883
  ms + một ca 2.056 ms — **không ca nào > 2.500 ms**,
  nên ca phân định của sửa W2 (act khi state đã cũ)
  không phát sinh trong phiên: bằng chứng cho W2 là
  gián tiếp (cổng mới tồn tại và có tác dụng qua ca
  drop-nosession + 32/32 tới nơi), ghi đúng mức này,
  không khẳng định quá dữ kiện.
- **Wake phía native — DEVICE FAIL, kết án bằng log
  hai lần trọn vẹn.** Fade 15:37:49.590 (PID 34490)
  → 16 Began trên ô native → 0 act → 0 reveal; fade
  15:39:33.323 (PID 34521) → 25 Began → 0 act →
  0 reveal, kéo dài tới khi ngắt kết nối.
  reveal-applied theo PID: 34376 ×7, 34442 ×10,
  34490 ×0, 34521 ×0. Gốc: không có agent nào trong
  process native nên không tồn tại đường activity —
  controls mờ được mà không gọi lại được. Dữ kiện
  probe (W4): CarPlayApp THẤY Began trên ô native —
  381 began / 381 chuỗi trọn; gán ô native 140
  (Music/Maps/GOFA), hosted 81, pane=none 155,
  outside 5. Nhưng nhãn scene không dùng được: chỉ
  23/140 ca native được phân loại scene=carplay,
  117/140 rơi vào foreign vì cửa sổ chạm là
  _UISystemGestureWindow (phía hosted tương tự: 0
  carplay thuần, 71 foreign). Hệ quả thiết kế: feed
  cho ô native tại CarPlayApp phải khóa theo **gán
  ô hình học**, không theo nhãn scene — đây là căn
  cứ của việc vòng này (§25.3).
- **Chuỗi "2 app hệ thống" — KHÔNG phải lỗi gán ô.**
  Cả 7 lần dựng cấu hình 2-native trong cửa sổ ytz2
  đều HOÀN TẤT: cả hai scene native được đặt +
  xác nhận khung {190|191, 240}, mẫu dòng y hệt ca
  hỗn hợp thành công; 0 dòng DashBoard invalidate
  trong cửa sổ ytz2 (đường invalidate chỉ xuất hiện
  ở cửa sổ fs1, 15:15 ×3). Chuỗi gãy thật: phiên
  toàn-native (PID 34413) fade lúc 15:31:58.660 và
  không bao giờ reveal (không ô hosted ⇒ không
  đường activity) → lối thoát duy nhất của người
  dùng là chạm góc dưới-trái trên DBStatusBarWindow
  → `tat split (goHome=0)` sau đó 47–80 ms (4/4 ca
  kiểm chi tiết khớp mẫu này) → CarPlay Home gốc.
  Tổng cửa sổ 15:31–15:40: 6 lần tat split, 4
  respring (15:31:42, 15:32:54, 15:37:32, 15:39:20 —
  nguyên nhân không xác định được từ log; respring
  tay để khôi phục là khả thi). **Cơ chế mất icon
  OmniCar khỏi lưới/dock gốc KHÔNG có trong log**
  (log chỉ ghi 5 app đã chọn được ghép lúc mở
  phiên); ô phải trắng trong video cũng không giải
  thích được từ log (phiên cuối cả hai scene đều
  xác nhận khung). Tức thảm hoạ là CHUỖI HẬU QUẢ
  của khe wake native ở trên, không phải lỗi dựng
  ô; bản QA20 "chọn 2 app hệ thống chạy tốt" vì
  controls của QA20 không đẩy người dùng vào thế
  kẹt này.

- **Pinch — chết ở tầng hình thành cặp, tầng phân
  xử không chạy.** Tóm tắt recognizer: complete=0
  truncated=0 ở mọi summary; probe phía app
  wouldPinch 0/124 bản ghi cửa sổ ytz2 (fs1: 0/91);
  chuỗi disposition/BlockedHidden KHÔNG xuất hiện
  trong log (đường pinch không đi tới tầng phân
  xử); gói state luôn pinch=0, pm=1 (DRY_RUN theo
  P4). Expand từ pinch: 0. Câu hỏi mở để lại cho
  GPT: chạm hai ngón dường như tới CarPlayApp dưới
  dạng các chuỗi đơn tách rời — recognizer trên
  container không bao giờ ghép được cặp theo cách
  phân phối này (xem thêm §25.2 về cách đọc số
  chuỗi của GPT và phép đo [touchset] ở §25.3).
- **Weather — HIỆU CHỈNH PHẠM VI KẾT LUẬN theo
  GPT.** Con số "10 transaction" trong phân tích
  A3 là tổng CẢ HAI file log; riêng cửa sổ ytz2 có
  **5**: 4 updated (http 200, ~1,1 s) + 1 failed
  (timeout đúng 3,0 s, http 0). Cả 10 đều là giao
  dịch warming cache phía SpringBoard lúc khởi
  động; location status = 0 ở 10/10 nên nhánh
  fallback vị trí cached chạy 10/10; mọi giao dịch
  kết thúc đúng một lần; sau failure các giao dịch
  sau vẫn updated (in-flight không kẹt). **Phạm vi
  đúng:** các dòng này chứng minh nhánh fetch/
  fallback KẾT THÚC — chúng KHÔNG tự chứng minh
  một request xuất phát từ CarPlay đã nhận answer
  và đã hiển thị nhiệt độ/gradient (đường answer
  phía xe không có dòng log riêng trong build này;
  giá trị nhiệt độ/gradient không nằm trong log).
  Phát biểu "Weather DEVICE PASS trên tiêu chí bắt
  buộc của GPT" trong bản tổng hợp gửi GPT sau
  phiên nay được thu hẹp về đúng phạm vi này; việc
  đóng khoảng trống bằng chứng là instrument
  request→answer ở §25.3.
- **Núm — NO DATA, verdict giữ PENDING.** 0 dòng
  payload publishKnobsNow / scaled= trong cả hai
  file (mọi dòng "knob" là cặp fade applied/
  restored của AutoHide). Không có khiếu nại núm ở
  phiên này. Đóng verdict cần hoặc khôi phục
  instrument payload, hoặc chấm bằng quan sát xe —
  để GPT phán.

### 25.2 Sửa chữa kết luận: guard fullscreen và 4 lần reason=tray

Kết luận 2 trong analysis-a1-lifecycle.md (và bản
tổng hợp gửi GPT sau phiên) phát biểu 4 lần refuse
`reason=tray` lúc 15:29 là guard "chặn đúng sự
thật" vì popup chọn app cho ô 1 đang mở. **GPT bác
bằng source, và phép bác đúng:** guard cũ tại
SCPFullscreenController.m:~302 là
`else if (split.trayWindow || split.trayOverlay) refuse = @"tray";`
— điều kiện theo TỒN TẠI window. Nhưng các đường
đóng trong SCPCarSplit+Picker.m chỉ ẨN window chứ
không huỷ: hideTrayWindowIfIdle (Picker.m:965–978)
chỉ đặt window.hidden = YES; đóng tray
(Picker.m:1016–1029) cũng chỉ ẩn; đóng picker
(Picker.m:658–677) cũng giữ lại window. Vậy
trayWindow != nil có thể chặn expand VĨNH VIỄN sau
khi popup từng mở một lần, dù window đã ẩn — và
từ 4 dòng reason=tray trong log KHÔNG kết luận
được popup có đang mở thật tại các mốc đó hay
không (A1 đối chiếu thêm mốc mở/đóng popup trong
log, nhưng trạng thái nền có thể là window đã ẩn
mà vẫn bị giữ lại). Chưa hết: `trayOverlay` là cờ
DÍNH — điểm gán duy nhất Panel.m:188, không có
điểm reset nào — không mang nghĩa "popup đang mở"
chút nào. **Kết luận "chặn đúng sự thật" bị thu
hồi.** Phần còn đứng vững: kênh pref SỐNG (mọi lần
gạt đều có dòng [fs-diag] đúng chiều, listener
đăng ký lại sau respring với want=1); expand chạy
0 lần trong cả phiên; 2 lần reason=inactive lúc
15:39:09.105 / 15:39:10.808 khớp split đã tắt từ
15:37:57.342 — phần inactive không sửa. Hệ quả
đúng cho xe: phát biểu "công tắc fullscreen không
hoạt động" của Nguyen là hệ quả của guard dưới
điều kiện chặn thật lúc đó, KHÔNG phải bằng chứng
đường expand/chrome hỏng — nghiệm thu controller
sạch (split active + tray/picker đóng hẳn) CHƯA
từng chạy; nó là bước 1 của ACCEPTANCE_YTZ3.
Ghi chú về văn bản liên quan: ACCEPTANCE_YTZ2.md
KHÔNG chứa câu tương đương (đã grep kiểm chứng:
0 hit cho 'tray' — văn bản đó viết trước phiên
xe, mọi verdict ở mức PENDING), nên không cần ghi
chú trỏ từ đó; sửa chữa này áp cho
analysis-a1-lifecycle.md §2 — file đó được nộp
NUGUYÊN VĂN trong vòng này và phải đọc cùng §25.2
này, đồng thời INDEX.md của reports/ đã mang dòng
cảnh báo tương ứng.
Bổ sung cùng mục, về cách đọc số chuỗi chạm của
GPT: mỗi dòng `chain … began=1` của probe là thống
kê của MỘT UITouch, không phải của toàn gesture —
"381 chuỗi đơn" KHÔNG chứng minh không có đa
chạm. Và có bằng chứng biểu diễn trùng phải chống
đếm trùng: 15:37:57.243 _UISystemGestureWindow và
15:37:57.246 DBStatusBarWindow ghi CÙNG điểm
{15,222.5} — có thể là hai biểu diễn của cùng một
thao tác vật lý qua hai window. Vì vậy mục pinch
của vòng này chỉ là PHÉP ĐO có chống trùng
(§25.3), chưa ghép cặp, chưa quyết kiến trúc.

### 25.3 Việc của vòng ytz3 (4 strand theo chủ file + kiểm độc lập)

**Guard fullscreen — chặn theo nội dung đang mở
(fix-g-fsguard).** Đọc lại Picker.m/RatioMenu.m/
Panel.m cho bảng trạng thái thật: module tự định
nghĩa "đang mở" bằng tập con trỏ nội dung của
window — `tray` / `pickerSheet` / `ratioMenu` đều
nil-hoá NGAY ĐẦU đường đóng, trước animation
(Picker.m:651, Picker.m:999, RatioMenu.m:469);
đây cũng là vị từ của panelOpen (Chrome.m:388) và
của phép thử rảnh hideTrayWindowIfIdle
(Picker.m:977–980). Ngược lại trayWindow chỉ nil
ở teardown/đổi screen và còn tự un-hide khi tái
dùng (Picker.m:884) — tồn tại không nói lên điều
gì, và `trayOverlay` là cờ chế độ hosting dính
(mục §25.2). Sửa (chỉ SCPFullscreenController.m):
chuỗi guard mới (:344–353) = pickerSheet →
popupOpen (= panelOpen || anyBarVisible) →
`fsTraySurfaceBusy:` (:289: chỉ còn dragGhost
đang bay ∨ toast nền tag 0x5c9b trong tray
window). Mọi từ chối kèm snapshot một dòng
`fsRefusalSnapshot:` (:299) —
snap{tw twh to tray picker ratio dg toast rz fc
phase} — gắn ở cả 6 điểm log refuse của
controller (expand-busy, expand state=EXPANDED,
gate reason, invalid-rect, restore-busy, restore
state=SPLIT): từ nay log phân định được chặn đúng
hay oan ngay tại dòng refuse. Truy vết tĩnh bắt
buộc, khẳng định bởi kiểm độc lập: (a) mở picker
→ đóng hoàn toàn → expand QUA guard (trạng thái
giữ lại tw=1 hidden, trayOverlay dính=1 không còn
chặn — đúng ca 4 lần reason=tray của ytz2 mà vị
từ cũ chặn vĩnh viễn); (b) popup mở thật → vẫn
chặn, bằng reason chính xác hơn (picker/popup);
(c) tray từng mở rồi ẩn → không chặn. Vị từ trần
cũ trong source controller: 0 hit. Ranh giới ghi
rõ: các dòng KẾT QUẢ sau quyết định (expand
unconfirmed, restore-unconfirmed, rollback,
session-end, external-override, chrome FAILED)
KHÔNG mang snap — chúng không phải điểm từ chối
ở cổng vào; snap ở đường unconfirmed là việc
cộng thêm nếu GPT muốn, hiện chưa có. Điểm để
lại cho GPT: hạng tử toast trong vị từ mới có
thể bỏ nếu GPT không muốn toast (sống ~2 s) chặn
expand — strand giữ theo đúng định nghĩa "bận"
của chính module.

**Feed activity cho ô native tại CarPlayApp
(fix-np-nativefeed).** SCPTouchProbe tiến hoá
(24.825 B): hook sendEvent: vẫn gọi orig trước
nguyên vẹn; tại mỗi Began, sau dòng [probe] cũ,
chạy SCPProbeFeedEvaluate với chuỗi cổng: split
active → touch quy đổi được → **màn chứa
container** (so UIScreen identity) → vùng hệ
thống (class DBStatusBarWindow mọi điểm + góc
Home 48×48 pt dưới-trái của screen.bounds — bắt
cả biểu diễn trùng qua gesture window; các điểm
thoát mẫu {12.5–23.5, 217–226} đều nằm trong) →
popup đang hoạt động (vị từ khớp strand guard,
in sub-reason) → thuộc ô theo screen-space từ
gán ô LIVE → ô hosted thì drop-hosted (F4 sở
hữu, không phát trùng) → ô native thì **fired**:
đúng MỘT lời gọi activity, chính đường F1
`[split ahNoteActivity:AHSourceContainer]`
(:324). Quy đổi tọa độ RÕ qua không gian màn
hình: điểm chạm và hình ô đều đi qua
coordinateSpace có tên (window → screen của nó),
giao nhau chỉ trong screen space;
`fromView:nil` xuyên window trên đường quyết
định của feed = 0 (chỉ còn ở classifier [probe]
ghi log và fallback `raw` khi touch không có
window — cả hai ngoài đường feed). Nhãn
foreign/_UISystemGestureWindow KHÔNG phải cổng
loại (feed không đọc nhãn scene; loại theo
window duy nhất là DBStatusBarWindow). Mọi quyết
định log `[probe-feed] t=… epoch=… fired |
drop-<reason>` đủ 8 format. Chạm đi qua nguyên
vẹn: vòng này KHÔNG nuốt, không chặn, không
reveal trực tiếp ngoài đường activity hiện có.
Hai điểm thiếu API đã khai trung thực: (1) enum
AHActivitySource không có giá trị riêng cho
probe-native → dùng AHSourceContainer; "last
source" nội bộ của AutoHide sẽ đọc là container,
attribution chính xác nằm ở dòng [probe-feed]
fired. (2) Generation — xem phán rủi ro ngay
dưới đây.

**Đo tập touch có chống trùng (fix-np, phần B).**
Probe duy trì tập touch đang sống theo con trỏ
UITouch: {win class, raw, scr đã quy đổi screen
space, pane gán, evB/evL = event.timestamp,
tB/tL monotonic}. Mỗi event làm đổi tập → một
dòng `[touchset] … active=N [ptr=… win=… raw=…
scr=… pane=… evB=…]`. Đủ dữ kiện phân định 2
contact ĐỘC LẬP đồng thời cùng ô (scr khác hẳn)
vs 2 biểu diễn TRÙNG của 1 contact (scr gần
bằng, evB lệch mili-giây — ca mẫu 15:37:57.243/
.246). KHÔNG ghép cặp, KHÔNG bắn lệnh pinch,
KHÔNG recognizer mới — đầu vào cho quyết định
kiến trúc pinch của GPT sau phiên ytz3.

**Generation của feed — phán rủi ro của kiểm độc
lập (verify-ytz3 mục d), ghi nguyên.** Hai hệ
"generation" khác nhau bản chất: gen của owner
(`bwGenBySlot[10]`, SCPCarSplit+BridgeWake.m:31)
là theo TỪNG SLOT, 1..4095 wrap, chỉ tăng khi
bundle của slot đổi (:351) hoặc vòng teardown
tăng mọi slot đang có bundle (:443), và là khoá
kiểm cho gói XUYÊN PROCESS (bwHandleActPacket:
loại gói khi pkt.gen != bwGenBySlot[slot], :526;
phía app cũng đối chiếu khi nhận state). Header
SCPCarSplit+BridgeWake.h KHÔNG phơi biến này →
khẳng định của strand "TU probe không đọc được"
là ĐÚNG. Epoch của probe (SCPProbeFeedEpoch,
SCPTouchProbe.m:206–219) là MỘT biến toàn cục
neo trên identity của split.container / window
của nó + cạnh rơi `active` được lấy mẫu; và grep
chứng minh sau khi tính nó CHỈ xuất hiện trong
format string [probe-feed]: không cổng, không so
sánh, không nuôi quyết định nào (quyết định
fired/drop đọc mọi đầu vào live cùng một pass;
đường có kiểm gen thật F4 không bị đụng). **Các
ca lệch epoch ↔ gen owner có thể xảy ra:** (1)
đổi app trong ô giữa phiên → gen slot tăng,
epoch đứng yên; (2) teardown + dựng lại mà không
có Began nào ở giữa VÀ container/window giữ
nguyên con trỏ → epoch có thể không tăng qua
ranh giới phiên trong khi gen đã tăng (ca CÓ
ĐIỀU KIỆN — container dựng mới thì đổi con trỏ
tự bắt ở Began đầu, và quyết định đầu phiên mới
đã mang epoch mới); (3) churn container/window
giữa phiên → epoch tăng khi gen đứng yên; (4)
epoch là 1 số toàn cục, mất hạt 10 slot; (5) hai
hệ không bao giờ so trị số 1-1 được (gen wrap/
reset theo slot, epoch đơn điệu theo process) —
đối chiếu chỉ bằng timestamp. **Phán: rủi ro
chức năng ≈ 0; rủi ro thật nằm ở tầng nhãn/đối
chiếu** (ai đối chiếu epoch= với gen trong state
packet sẽ thấy lệch ở các ca 1–4 mà dòng log
không tự cảnh báo). Giảm nhẹ sẵn có: trường log
đặt tên `epoch=` chứ không phải `gen=`, biên bản
strand ghi rõ bản chất. Phát biểu đúng hiện tại
là "feed xác nhận gán-ô-hiện-hành đọc tại chỗ",
KHÔNG phải "feed xác nhận generation của owner".
Muốn tương quan gen thật phải phơi accessor
chỉ-đọc ở BridgeWake.h (vd bwGenerationForSlot:)
— đề xuất chờ GPT, ghi ở §25.5.

**Instrument mất icon + ô trắng (fix-i-iconwhite).**
Bản đồ app-library đọc từ source: phía picker/
split, nguồn = SCPCarPlayAppInfos() (thư viện hệ
thống lọc CarPlayUI GỘP lưới Home đang sống qua
SCPCarHomeBundles()) + SCPChosenPhoneAppInfos()/
SCPBridgedChosenApps() (pref appBridgeApps ∩ app
đã cài, cache 60 s); sự kiện dựng lại: mở picker
(Picker.m:339), publishCarPlayApps lúc màn xe
hiện, prefschanged / hết hạn cache. Điểm [applib]
cộng ở SCPCarApps.m + 1 điểm SCPCarSplit.m:2666:
`live-grid-read` (count + omni — thăm dò TRỰC
TIẾP bundle của chính OmniCar com.anlai.omnicar.app
còn trên lưới gốc đang sống hay không),
`bridged-rebuild`, `drop chosen-not-installed`,
tally drop (duplicate)/(no-carplay-ui) tại đúng
2 điểm continue sẵn có, `build picker-native`
(count/omni/fromGrid/omniFromGrid), `build
picker-chosen`, `build publish-for-settings`.
[scenevis]: helper chỉ-đọc SCPCarSplit.m:56,
format bundle/slot/scene-id/attached/inHost/
hidden/alpha/window tại 9 điểm: attach :1173,
detach(-bg) :1206 (trước khi detach chạm view),
scene-destroyed :1266, verify :1343 (cạnh dòng
verdict khung sẵn có — ĐIỂM phân định ô trắng:
khung đúng nhưng hidden=1/inHost=0/window=0 sẽ
lộ tại đây), pane-remove :1538, invalidate :285,
going-home :1736 (snapshot mọi pane đúng điểm
thoát Home của sự cố), host-attach :1917,
host-state-* :1990. Vòng đời = force không
throttle; verify/host-state throttle 1 s.
**Đường Home gốc — KHÔNG nằm trong 2 file được
giao vòng này** (ghi đúng vị trí thật, không
instrument): hook _newApplicationLibrary /
_loadFromProxy: ở SCPHooks.m:56/72; họ tiêm/gỡ
app ở SCPAppIcons.m (SCPAddChosenAppsToLibrary,
SCPInjectDeclarationIfChosen,
SCPRefreshAppIconsBlock — có removeApplicationProxy:,
crash-guard); đồng bộ trình bày ở SCPHomeApply.m.
Phần duy nhất của đường đó trong phạm vi là
reader SCPCarHomeBundles() — dòng live-grid-read
nói trên.

**Instrument weather request→answer→display
(fix-w-weatherinst).** Sự thật cốt lõi: kênh
`com.anlai.omnicar/startupscreen.weather.request`
là notify_post TRẦN — KHÔNG mang id nào;
SSWeatherGeneration phía CarPlay chỉ là guard
nội bộ, không bao giờ truyền qua kênh. Vòng này
cấm đổi giao thức nên instrument dùng hai bộ
đếm LOG-ONLY độc lập theo process, tương quan
bằng thứ tự + timestamp: req# (SSSplash.m:348)
và ans# (SSStartupScreen.m:708–709) — cả hai chỉ
được đọc bởi chính các dòng log cộng thêm (grep
chứng minh không logic nào đọc chúng). 17 điểm
log `[weather]` phủ kín 3 đầu — yêu cầu: req#
begin / gen= ask-springboard / retry-post /
timeout-no-answer / source=direct-fix /
source=none / answer-received for req# gen=
cacheTemp=; trả lời: request received via darwin
notify / ans# begin / ans# dropped
reason=in-flight / ans# fetch-begin source=<nhãn
vị trí gốc> / ans# answered-without-weather /
ans# ready-posted; hiển thị: applied req# temp=
code= isDay= dataAge= tại apply block (ghi cả ca
nil) + display category= isDay= temp= tại đúng
điểm _sky/gradient được tính trong -reload
(SSStartupView.m:271). Cache khởi tạo có nhãn
riêng `display source=initial-cache (NOT a
request answer)`; warming nay có nhãn tường minh
`source=warming-cache (internal startup call,
NOT a CarPlay request)` và chuỗi warming KHÔNG
chứa dòng req# nào — phân biệt dứt khoát với
request thật, đúng điểm GPT hiệu chỉnh ở §25.1.
Giới hạn ghi rõ: phía SpringBoard không phân
biệt được post gốc với retry-post (+2s/+5s) của
cùng ask (đều là notify trần); ánh xạ req#↔ans#
là theo thứ tự, không 1-1 tuyệt đối (in-flight
guard + single pending slot là thiết kế gốc).
Đề xuất vòng sau (chưa làm, chờ GPT — đây là đổi
giao thức): chở generation qua notify state của
chính kênh request; mẫu notify_register_dispatch
+ notify_get_state đã có sẵn trong cùng file ở
kênh location.

**Kiểm độc lập vòng (verify-ytz3, chỉ-đọc):**
(a) guard — KHẲNG ĐỊNH (cả ranh giới snapshot ở
trên); (b) feed — KHẲNG ĐỊNH, một lệch MÔ TẢ thứ
tự: đề bài liệt kê "màn CarPlay" trước "active",
code đặt active trước và chèn cổng unconverted;
cả hai đều là drop cứng và cổng display về kỹ
thuật không chạy được trước quy đổi, nên tập
quyết định không đổi — ghi nguyên trạng; kỷ luật
lời gọi grep toàn file: ahNoteActivity: đúng 1
điểm, reveal/swallow/cancel = 0; (c) hai strand
instrument — KHẲNG ĐỊNH thuần cộng: git diff
81c6751 → 36135b8 trên đúng 5 file = **163 dòng
cộng / 0 dòng xoá** (SCPCarApps +57, SCPCarSplit
+55, SSSplash +26, SSStartupScreen +18,
SSStartupView +7); mọi hunk thuộc 4 loại log-only
và 3 điểm soi kỹ (hunk feature-off chèn TRƯỚC
return gốc, hai if tally vị từ thuần đọc, cân
bằng ngoặc của phần cộng) đều sạch — 0 thay đổi
điều kiện/hành vi; (d) phán gen như trên.

### 25.4 Số đo của vòng

- **Candidate local:** com.anlai.omnicar_1.0.3-ytz3_
  iphoneos-arm64.deb — 1.027.106 B, SHA-256
  `b6c5f32864eed1d471632b1bcb73708553c7100adf8443e791d044400f5e9414`;
  build từ sạch EXIT=0, 0 error; control khác ytz2
  duy nhất Installed-Size 3748→3764; mirror 9/9
  identical (integration-ytz3).
- **Cổng cũ trên candidate:** file list 176 = 176;
  parity selector 8/8 thành phần 0 mất; SplitScreen
  +7 đúng thiết kế (fsRefusalSnapshot:,
  fsTraySurfaceBusy:, convertPoint:toCoordinateSpace:,
  CGPointValue, valueWithCGPoint:, pointerValue,
  timestamp); g1/g2/h (C-A + C-B)/f diff toàn hàm
  = 0, địa chỉ + dạng y hệt ytz2; knob IMP 356 lệnh
  đúng 1 eor; 4 hash cấm ABHost MATCH cả 4;
  hostFrameInfo đủ 30 key, `split` vẫn từ vị từ
  trình bày; điểm ghi requestedOrientation có giá
  trị duy nhất nguyên vẹn; MSHookMessageEx
  SplitScreen = 31 call-site, KHÔNG tăng; kênh
  bridgewake ×5 + ytlease/ytleaseack nguyên vẹn
  từng chuỗi.
- **Cổng mới trên candidate:** SplitScreen binary
  chứa [probe-feed] ×8 format, [touchset] ×1,
  [applib] ×8, [scenevis] ×1, snap{ ×1 (marker cũ
  [probe]/[fs-diag]/[fs1]/[pinch1] còn nguyên);
  StartupScreen [weather] đúng 17/17 format; vị từ
  trần `trayWindow || trayOverlay` trong source
  controller = 0 hit.
- **Git:** main `36135b8a355626a2d57103624d16cbcda6ebe273`
  (đúng 16 file = 8 file strand × 2 cây, không thay
  đổi phụ); ci-fat-test
  `dd4737522539d450a7024f22e6ef696d9f1a35b9` (merge
  main); diff main ↔ ci-fat-test trên project/src
  = 0.
- **CI:** workflow 410962367, run dispatch
  **42590500247** — SUCCESS, theo dõi foreground
  (gh run watch) + truy vấn trực tiếp (gh run view),
  09:03:53Z → 09:07:17Z.
- **FAT:** com.anlai.omnicar_1.0.3-rebuilt-ytz3-fat_
  iphoneos-arm64.deb — **1.224.728 B**, SHA-256
  **`c1872b936a01969418b68cc5f69e1bd72639a1f5e2e2f1da16132edcfc6bcf3f`**
  (tự đo trên đĩa tại handover); members
  debian-binary + control.tar.gz + data.tar.lzma.
- **Kiểm hai lát** (parser Mach-O tự viết, ĐÃ HIỆU
  CHUẨN trên FAT ytz2 trước khi đo: tái lập đúng
  16/16 UUID + bảng methname + IMP/khoảng/eor của
  knob + IMP g1 của ci-ytz2, gồm giải mã chained-
  fixup arm64e): bridgewake 5/5 ×1 ở SplitScreen +
  AppBridge cả hai lát; ytlease ×1 + ytleaseack ×1
  chỉ ở AppBridge; chuỗi mới MỖI lát đúng số format
  của strand ([probe-feed] ×8, [touchset] ×1,
  [applib] ×8, [scenevis] ×1, snap{ ×1 ở
  SplitScreen; [weather] ×17 ở StartupScreen);
  marker cũ khớp ytz2 từng số; fullscreenTestExpand
  = 0 trong toàn bộ gói; binary Prefs chứa cả 3
  khoá chẩn đoán ×1 mỗi lát; knob đúng 1 eor mỗi
  lát (arm64 IMP 0x12f9c, eor @0x13208; arm64e IMP
  0x138e8, eor @0x13b58 — cùng số lệnh trong khoảng
  như ytz2); g1 IMP trùng ytz2 từng địa chỉ
  (0x7464/0x775c); parity vs FAT ytz2: 7 binary
  identical số đếm, SplitScreen 1387 → 1394, mất 0,
  thêm đúng 7 truy hết vào fix-g (2) + fix-np (5),
  fix-i/fix-w thêm 0 selector (đúng tính chất
  instrument thuần — AppBridge/StartupScreen/Prefs
  identical từng tên). UUID 8 binary × 2 lát: bảng
  trong ci-ytz3 §3 và ACCEPTANCE_YTZ3.

### 25.5 Trạng thái + còn mở

- **Mức đạt của vòng: source complete / static PASS
  (candidate + FAT hai lát). Mọi verdict xe:
  PENDING** — kịch bản nghiệm thu trong
  ACCEPTANCE_YTZ3: (1) controller sạch — mở picker
  → đóng HOÀN TOÀN → gạt công tắc: expand phải
  chạy; popup đang mở thật: vẫn bị chặn; (2) native
  wake — fade → chạm ô native → reveal qua
  [probe-feed] fired; (3) touchset — pinch tự
  nhiên, đội phân tích đọc log phân định trùng/
  độc lập; (4) đối chứng YTZ OFF dài (tắt ≥ 10 s
  rồi mở video — sửa caveat 0,5 s của phiên ytz2);
  (5) hồi quy weather/icon/ô trắng — đọc chuỗi
  [weather] req#→ans#→applied→display và
  [applib]/[scenevis] từ log của chính phiên.
- **ENFORCE vẫn ĐÓNG theo GPT** — cả wake (Gate 3
  là nuốt cú chạm đầu; phiên ytz2 mới chứng minh
  đường activity/reveal, và log còn failopen=
  kbunknown — điều kiện suppression chưa đủ bằng
  chứng) lẫn pinch (chưa ghép cặp, chưa recognizer
  trong app). Feed native vòng này chỉ cộng
  activity, chạm native đi qua nguyên vẹn.
- **Ba đề xuất chờ GPT phán:** (i) phơi accessor
  gen chỉ-đọc trong SCPCarSplit+BridgeWake.h để
  feed tương quan được gen thật của owner (mục d
  ở §25.3); (ii) khi log [applib]/[scenevis] của
  phiên ytz3 khoanh được vùng, mở vòng
  instrument/sửa tại đường Home thật (SCPHooks.m /
  SCPAppIcons.m / SCPHomeApply.m) cho cơ chế mất
  icon — KHÔNG coi là tự khỏi theo sửa wake;
  (iii) chở generation qua notify state của kênh
  weather.request để req#↔ans# thành tương quan
  tuyệt đối (đổi giao thức, mẫu có sẵn ở kênh
  location cùng file).
- Giữ nguyên từ các vòng trước: VISUAL_ORIGINAL_
  COMPARISON = PENDING (thiếu footage deb gốc
  cùng kịch bản); núm chờ phán (instrument payload
  hay chấm quan sát); bản sao Weather phía Prefs
  (OMCCommon.m) chỉ audit đọc; ahForgetView: chờ
  GPT; comment tồn dư (SCPPinchController đã dọn ở
  các vòng trước; ghi chú §7 trong ABChannels.m về
  `single` còn lại). **QA20 vẫn là bản dùng hằng
  ngày của Nguyen** — ytz3 thay ytz2 làm bản nghiệm
  thu duy nhất hiện hành. Rollback: ytz2 FAT +
  fs1 FAT + fixround7 FAT + gói hợp nhất QA20.
  ytz1 vẫn CÁCH LY.

## 26) PHIÊN XE YTZ3 — PHÁN QUYẾT TỪ LOG
(2026-11-09)

### 26.0 Nguồn dữ kiện

- Hai file log Nguyen upload (commit 9be396b):
  OmniCar.log.old 2.100.219 B, SHA-256
  ea0b20ba… (6.957 dòng, 15:33:22 →
  16:35:40) và OmniCar.log 107.094 B, SHA-256
  7c14140d… (879 dòng, 16:35:40 → 16:50:44).
- Cửa sổ ytz3: từ dòng [probe-feed] đầu tiên
  (log.old dòng 2332, 16:18:14.148, CarPlay
  PID 34964) tới hết OmniCar.log — 5.505
  dòng. Phần trước mốc trong log.old là đuôi
  phiên ytz2, ngoài phạm vi.
- CarPlay PID trong cửa sổ: 34964 → 34985 →
  35035 (SpringBoard đồng bộ 34934 → 34986 →
  35036); YouTube: 34974 / 35007 / 35060.
- Ba đội phân tích song song chỉ-đọc:
  analysis-b1-fs-icon-weather (FS / icon /
  scenevis / weather), analysis-b2-wake-feed
  (wake / feed / failopen),
  analysis-b3-ytz-kb-touchset (YTZ / bàn phím
  / touchset) — số đếm độc lập khớp nhau ở
  các điểm giao. Biên bản: handover/reports/.

### 26.1 Fullscreen — controller + guard:
DEVICE PASS

- Công tắc chẩn đoán: 20 lần ON, 20 lần OFF —
  mọi lần gạt đều có dòng [fs-diag] tương ứng
  (khớp báo cáo của Nguyen "công tắc
  fullscreen có hoạt động").
- Expand confirmed 13 (PID 34985 ×7, 35035
  ×6); restore confirmed 11 + 2 restore rút
  gọn ở session-end (teardown). Sổ sách khép
  kín: 13 = 11 + 2; 20 ON = 13 chạy + 7 từ
  chối; 20 OFF = 11 restore + 9 từ chối.
- Refusal 16, TẤT CẢ state-based: expand
  refused reason=inactive ×7; restore refused
  state=SPLIT ×9. reason tray / picker /
  popup / solo / zoom = 0 trong toàn cửa sổ.
  Snapshot 16/16 giống hệt nhau: tw=1 twh=1
  to=1 (window giữ lại + đang ẩn + cờ dính)
  nhưng tray=0 picker=0 ratio=0 — không bề
  mặt popup nào đang hoạt động tại bất kỳ
  lần từ chối nào. Bằng chứng trực tiếp cho
  guard mới: ca 16:19:08.507 mang đúng tổ hợp
  mà vị từ cũ của ytz2 sẽ kết án reason=tray,
  nay chỉ bị từ chối vì inactive.
- Ca bắt buộc của GPT (mở picker → đóng HOÀN
  TOÀN → gạt công tắc: expand phải chạy)
  xuất hiện TRỌN VẸN 2 lần: (a) picker mở
  ~16:21:06 (feed drop-popup(picker) ở
  16:21:08–16:21:11) → snapshot picker=0 lúc
  16:22:03.749 → expand confirmed
  16:22:04.454; (b) picker mở 16:27:30.396 →
  picker=0 lúc 16:27:49.518 → expand
  confirmed 16:27:50.015.
- Chiều ngược (popup đang mở thật thì vẫn
  phải chặn): KHÔNG có ca FS trực tiếp trong
  phiên — guard không đối mặt một popup đang
  mở nào (picker=0 ở 16/16 snapshot). Tính
  chặn-khi-mở chỉ có bằng chứng ở tầng feed
  (drop-popup phía feed ×6 riêng cho picker,
  tổng drop-popup ×15). Ghi đúng phạm vi:
  nửa này của cổng chưa đạt DEVICE, giữ ở
  mức tĩnh + feed.

### 26.2 Wake — feed native DEVICE PASS;
act hosted khép kín

- [probe-feed] tổng 155 dòng: fired 41 +
  drop 114. Fired 100% là ô native (Maps
  slot1 ×32, Maps slot0 ×7, GOFA slot1 ×2;
  một số cú chạm vật lý có 2 dòng qua 2 cửa
  sổ → ≈38 cú phân biệt). Drop: inactive
  ×44, hosted ×36 (nhường đường act), popup
  ×15, systemregion ×9, notassigned ×5,
  unconverted ×5; drop-display = 0 — cổng
  display chưa từng kích hoạt, chưa kiểm
  chứng (không phải đã chứng minh).
- Ca quyết định fade → Began trên ô native →
  fired → reveal-applied: TRỌN 6/6 (1 ca
  biên ngay trước mốc cửa sổ + 5 trong cửa
  sổ), trễ Began → reveal 0–3 ms. Đối chiếu
  phiên ytz2 (kết án cũ): fade 15:37:49 → 16
  Began native → 0 reveal; fade 15:39:33 →
  25 Began → 0 reveal (41 Began, tỉ lệ
  chuyển đổi 0%). Khe wake phía native đã
  ĐÓNG ở tầng cơ chế đối với các phiên split
  đang active.
- Act hosted: act-posted 26 (chỉ YouTube —
  PID 35007 ×20, 35060 ×6), act-accepted 26,
  drop phía owner 0 trên cả 6 lý do → vòng
  khép kín 26/26. 12 ca act-drop-nosession
  phía app (stateage=-1) đều nằm SAU
  teardown phiên split 16:25:58 (YouTube
  chuyển solo toàn màn, renew dừng): vòng
  act kết thúc vì PHIÊN kết thúc, không phải
  đứt đường truyền.
- Fade 14, reveal-applied 13 (activity ×9,
  unsuspend ×4 — các reveal unsuspend là dọn
  fade tại miệng vào EXPANDED, không phải do
  chạm). MỒ CÔI đúng 1 ca: fade
  16:18:31.943 (PID 34964) — sau fade chỉ có
  2 cú chạm đều không đủ điều kiện (góc Home
  → drop-systemregion; split đã tắt →
  drop-inactive) rồi PID chết 16:19:08: mồ
  côi do PHIÊN CHẾT, không phải feed/act bỏ
  qua chạm hợp lệ. Gương host: applied hụt
  đúng 1 ở cả kênh fade lẫn kênh knob =
  chính ca mồ côi này; teardown cuối phiên
  (16:42:18) ghi faded=0 — không fade nào
  treo lúc ngắt.
- Renewal: 1.275 dòng bw renew, 100%
  panes=1 (chỉ ô hosted — ô native nay có
  feed riêng), nhịp tick 1,00 s.

### 26.3 Gate 3 (nuốt cú chạm đầu) — vật cản
duy nhất còn lại là tín hiệu kb phía app

- Dòng đánh giá DRY_RUN phía app ([do] bw
  probe): 38, toàn bộ YouTube (35007 ×32,
  35060 ×6). wouldSwallow=0 ở 38/38;
  wouldPinch=0 ở 38/38; dòng nuốt thật: 0
  (đúng thiết kế DRY_RUN — cổng chưa mở).
- Trường kb= phía app là "-" (không xác
  định) ở 38/38 dòng — phía app KHÔNG một
  lần nào quan sát được giá trị kb xác định
  trong phiên này; trong khi phía owner ghi
  kb=0 ở 26/26 act-accepted. Failopen:
  kbunknown ×4 — cả 4 đều ở state=H (đúng
  các ca quyết định cho suppression) và đều
  trùng một reveal đóng bởi act; unknown ×12
  đều state=U, là giai đoạn solo sau
  teardown (không có phiên — trung thực theo
  thiết kế, không phải lỗi cổng).
- Hệ quả: cứ khi nào đủ điều kiện state=H
  (4/4 ca) cổng đều fail-open vì kbunknown.
  Bằng chứng suppression vẫn CHƯA trọn,
  nhưng vật cản đã thu về đúng MỘT điểm: tín
  hiệu kb phía app chưa từng known — KHÔNG
  còn là độ tươi của state: stateage của 26
  act đã posted max 987 ms, 0 ca >1.000 ms.
- Ca phân định W2 (act với stateage > 2.500
  ms) LẠI không xuất hiện — phiên thứ hai
  liên tiếp: renewal giữ state luôn trẻ nên
  phép tách freshness của W2 vẫn chỉ có bằng
  chứng gián tiếp. Phát biểu đúng cho GPT:
  feed xác nhận gán-ô-hiện-hành đọc tại chỗ
  + độ tươi state đã đủ; điều kiện
  suppression còn thiếu duy nhất kênh kb
  phía app.

### 26.4 AutoHide khi EXPANDED — complaint
của Nguyen XÁC NHẬN BẰNG SỐ

- 13 khoảng expanded (expand confirmed →
  restore / session-end) tổng ≈961 s; ba
  khoảng dài nhất 77,6 s / 226,8 s / 521,3 s
  — gấp 19× / 57× / 130× ngưỡng idle 4,00 s.
- [autohide] suspend ×13 khớp 1-1 với 13
  expand (cùng mili-giây), resume ×12 (11
  khớp restore confirmed + 1 khớp
  session-end 16:25:58; khoảng expand cuối
  khép bằng teardown 16:42:18, không có
  resume). Trong 14 fade của
  cửa sổ, fade rơi vào khoảng expanded: 0.
  Feed vẫn bắn trong lúc suspend (9 dòng
  fired) nhưng ahNoteActivity no-op; controls
  vốn đã được suspend khôi phục về hiện nên
  không phát sinh reveal nào.
- Báo cáo của Nguyen lúc 16:25 ("khi
  fullscreen thì logo không tự ẩn") nằm
  trong khoảng 77,6 s — được log xác nhận
  bằng số, không phải lỗi cảm nhận. Cơ chế
  đã chỉ đích danh ở probe-ytz3-session-q.md:
  HAI khoá treo chồng nhau — (1) treo cứng:
  bwSetExpandedActive: gọi [self
  ahSetSuspended:active] (SCPCarSplit+
  BridgeWake.m:331); khi treo, timer bị huỷ
  và ahNoteActivity no-op toàn phần; (2)
  chặn ở cổng fade: ahFadeBlockedReason trả
  "expanded" (SCPCarSplit+AutoHide.m:141).
  Gỡ một khoá thì không có tác dụng — bản
  sửa muốn ẩn như ở split phải xử lý cả hai.
  Việc gỡ chờ GPT phán (mục 26.10).
- Artefact cần biết khi đọc log các phiên
  sau: fade 16:23:11.230 ghi idle=97.00 — nó
  bắn 4,003 s sau resume 16:23:07 nhưng bộ
  đếm idle tính từ activity cuối TRƯỚC cả
  giai đoạn suspend. Không ảnh hưởng ghép
  cặp fade → reveal.

### 26.5 YT-Zoom — DEVICE PASS + đối chứng
OFF hợp lệ đầu tiên

- Tổng cửa sổ: lease cấp 6 (mọi lease
  split=1, 6/6), ack phase=applied 38/38 —
  tất cả windows=1 mismatch=0; ack expired
  0; lease-lapse 0; isSplit-fallback 0.
- Ca quyết định cùng một phiên (SpringBoard
  34986 / YouTube 35007): lease gen=0 cấp
  16:19:26.759, sống qua các cập nhật cỡ
  divider (gen 1–9) → 16:22:22.329 [ytz]
  lease thu hoi ly do=pref → app ao hoa TAT
  ly do=revoke 16:22:22.333 → ack
  phase=revoked 16:22:22.337 → 16:22:33.449
  sua residue: requestedOrientation 4 -> 0 →
  lease cấp lại gen=10 cùng mili-giây.
  Khoảng OFF = 11,121 s — lần đầu đối chứng
  OFF dài ≥10 s thực sự đo được (phiên ytz2
  chỉ 0,5 s; caveat cũ đã sửa).
- Trong kỳ OFF, bệnh gốc lộ nguyên hình trên
  đường gốc: 4 tuyên bố hướng của app được
  đáp trên đường gốc (không dòng [ytz] chan
  nào); hai tuyên bố mask 24 (16:22:29.725,
  16:22:30.378) bị đường gốc suy ra huong 4
  và GHI vào requestedOrientation — bằng
  chứng dương là dòng sua residue 4 -> 0 lúc
  bật lại: trong kỳ OFF trường này đã mang
  4, phải dọn trước khi cấp lease mới. Đúng
  cơ chế tiền đề của YTZ (mask 24 → suy ra 4
  → hoán trục trong hộp dọc). Lời Nguyen
  "tắt → sai chiều + bó giao diện / bật lại
  → phóng tốt" khớp log từng đoạn.
- Ngay sau cấp lại, tuyên bố đầu tiên bị
  chặn đúng thiết kế: 16:22:33.810 app phát
  (ma 255, mask 24) → 16:22:33.811 [ytz]
  chan apporient: pane dang ao hoa.
- Kiểm R1 (revoke không chạy layout — vòng
  trước chỉ đích danh từ source): trong 2 s
  sau revoke phía host chỉ có đúng 2 dòng
  (thu hồi + ack revoked) — 0 dòng
  layout/commit khung cho ô YouTube; mở rộng
  cả khoảng OFF cũng không có lệnh hình học
  nào; hành động settings đầu tiên của host
  sau revoke là đáp tuyên bố hướng của app
  lúc 16:22:28.044 (+5,715 s). Kết hợp bằng
  chứng dương ở trên: lệch hình học của kỳ
  OFF không cần tới R1/R3 riêng lẻ — ĐƯỜNG
  GỐC ĐANG SỐNG là đủ gây ra. (Chuỗi
  "layoutPane" không tồn tại trong log —
  phép kiểm này là bằng chứng vắng mặt trên
  các họ dòng commit khung có trong log.)
- Kiểm R3: ca này KHÔNG xảy ra theo dạng
  "không có tuyên bố mới" — app có tuyên bố
  mới sau +5,7 s, nhưng tuyên bố được xử lý
  bằng đường gốc nên tự nó tạo trạng thái
  sai thay vì chữa.
- R2 (snapshot khôi phục phía app là cỡ đầu
  phiên): KHÔNG kiểm được từ log này — dòng
  ao hoa TAT ly do=revoke không kèm kích
  thước snapshot. Giữ nguyên trạng thái: đã
  chỉ đích danh ở source (biên bản
  probe-ytz3-ytzoff-kb.md), chưa có bằng
  chứng xe.

### 26.6 Bàn phím — ô phải là Google Maps
NATIVE (H2 chứng minh)

- Dòng ban phim xe: hien cho <bundle> (bàn
  phím tự vẽ ABKeyboard của đường hosted):
  0 trong toàn cửa sổ. host-attach chỉ có
  com.google.ios.youtube ×5 — Maps/GOFA
  không bao giờ vào ô qua ABHost.
- Danh tính ô phải tại thời điểm ảnh
  (~16:20): com.google.Maps ở dạng NATIVE —
  scene Car[2-3]:…:com.google.Maps qua
  DBApplicationSceneViewController (attach
  16:19:25.941), khung {191, 240} lúc dựng;
  sau cú kéo divider 16:19:49 (ti le cac o =
  0.33 / 0.67) scene thành {254, 240} — kích
  thước còn hiệu lực tại thời điểm ảnh
  (vùng app toàn màn {382, 240} sau dock 45
  trên màn 427×240; lần đổi cỡ tiếp theo là
  16:21:25, về {191, 240}). GOFA trong cửa
  sổ cũng native cùng kiểu.
- Phán: H2 ĐÚNG và là kết luận chính — phiên
  này Maps chạy native nên bàn phím trong
  ảnh là bàn phím HỆ THỐNG dựng trong scene
  template của chính Maps, không phải
  ABKeyboard. H1 đúng ở mức hình học (không
  phải nguyên nhân độc lập): phím bị nén
  theo bề rộng scene native cỡ ô là hệ quả
  hình học trực tiếp. Delta ytz2→ytz3 đã bị
  loại toàn bộ ở vòng điều tra trước
  (AppBridge 0 file đổi; 8 file đổi đều log
  thuần / vị từ đọc thuần / quan sát
  sau-giao — không dòng mới nào chạm được
  tới hình học bàn phím).
- Giới hạn bằng chứng: bàn phím native
  không phát sự kiện nào vào log (kb=1: 0
  lần trong cả cửa sổ — phím native VÔ HÌNH
  với cổng wake, xem thêm 26.3); log không
  cho biết phiên trước ("lần trước không
  lỗi") app lên hosted hay native — chỉ
  chốt được phiên này.

### 26.7 Touchset / pinch — 62/62 biểu diễn
trùng; chưa có mẫu hai-ngón-thật nào

- [touchset] 335 dòng; snapshot active=2:
  62; active>=3: 0. Trong 62 ca: cặp có evB
  KHÁC nhau: 0/62; cặp có hai điểm bắt đầu
  phân biệt (hai ngón thật): 0/62.
- Mẫu hình cả 62 ca: một contact vật lý bị
  nhân đôi qua hai window (ba biến thể:
  cùng điểm + cùng evB ở _UISystemGesture
  Window — record đóng băng tại điểm bắt
  đầu — và ở window nội dung — record trượt
  theo ngón; cặp vùng hệ thống gesture +
  DBStatusBarWindow, đúng họ ca mẫu
  {15,222.5} GPT từng cảnh báo; record ma
  win=(nil) không toạ độ nhưng evB vẫn
  trùng). Chuỗi kéo dài nhất (16:18:44–49)
  cũng giữ mẫu: MỘT ngón kéo bản đồ, hai
  biểu diễn.
- Hệ quả đo được: nếu ghép mọi record đồng
  thời thành "hai ngón", 62/62 ca sẽ là
  pinch GIẢ — gồm cả chạm góc Home và kéo
  một ngón. Dữ kiện xác nhận hướng của GPT:
  chưa được ghép cặp tại CarPlayApp nếu
  không có khử trùng theo (evB + điểm bắt
  đầu + window). Và ngay cả sau khử trùng:
  trong CẢ HAI phiên ytz2 + ytz3 không ghi
  được một pinch hai-ngón-thật nào để hiệu
  chuẩn (các lần Nguyen pinch thử hoặc
  không tới CarPlayApp thành hai contact,
  hoặc bị nuốt vào cùng một biểu diễn — log
  không phân biệt được hai khả năng đó).
- Đường pinch trong cửa sổ: 0 tuyệt đối,
  đúng DRY_RUN — recognizer trên container
  hợp thành 0 cặp cả phiên (tổng kết phiên
  16:42:18: pairs complete=0 truncated=0 ở
  cả split lẫn expanded), wouldPinch=1:
  0/38 dòng probe, dòng disposition: 0, mọi
  expand/restore đều provenance=diag ×40 /
  teardown ×2, provenance=pinch: 0.

### 26.8 Icon / ô trắng — đầu đọc applib MÙ;
ô trắng không tái hiện

- [applib] 26 dòng, 5 cụm build (16:19:23,
  16:21:06, 16:21:09, 16:25:47 — PID 34985;
  16:27:30 — PID 35035). live-grid-read:
  count=0 omni=0 ở 5/5 lần — đầu đọc
  lưới-đang-sống trả về RỖNG tại mọi lần
  đọc; trong suốt phiên không quan sát được
  một lưới có dữ liệu nào để làm mốc so
  sánh.
- com.anlai.omnicar.app xuất hiện 0 lần
  trong toàn cửa sổ: không ở live-grid-read,
  không ở picker-native (omni=0,
  omniFromGrid=0 ×5), không ở bridged-
  rebuild (omni=0 ×4), không ở
  publish-for-settings (omni=0 ×2), và
  KHÔNG nằm trong danh sách drop. Không tồn
  tại mốc chuyển 1→0 nào: icon vắng một cách
  HẰNG ĐỊNH ở mọi danh sách được dựng, ngay
  từ cụm đầu tiên 16:19:23.862. Drop: 5 dòng
  giống hệt nhau — 12 bundle, tất cả
  source=library-walk, tất cả cùng một lý
  do (no-carplay-ui); không drop vì
  duplicate / not-installed.
- Phán đúng phạm vi: cơ chế mất icon của vụ
  ytz2 KHÔNG có trong log này để kết án —
  omni=0 không phân biệt được "icon đã bị
  gỡ khỏi lưới" với "lưới không đọc được từ
  process/ngữ cảnh này". Đầu đọc mù chính là
  kết quả của vòng này: muốn đi tiếp phải mở
  vòng tại đường Home thật (SCPHooks.m /
  SCPAppIcons.m / SCPHomeApply.m) — chờ GPT
  phán (26.10); không coi mất icon là tự
  khỏi theo sửa wake. Tương quan phụ: 4 lần
  tat split không có cụm build nào rơi ngay
  sau một lần thoát Home; 2 lần đổi PID
  không kèm dòng [applib] bất thường.
- Ô trắng: [scenevis] 64 dòng — verify
  25/25 khoẻ tuyệt đối (attached=1 inHost=1
  hidden=0 alpha=1.00 window=1; Maps ×14,
  GOFA ×11). Mọi dòng attached=0 (19 dòng)
  đều là ô hosted YouTube với scene=nil tại
  các điểm host-attach / host-state /
  going-home / detach-bg / invalidate —
  trạng thái cấu trúc bình thường của ô
  hosted, không phải chữ ký ô trắng.
  Going-home snapshot (4 sự kiện, 7 dòng):
  không ô native nào bị detach/hidden tại
  thời điểm thoát Home. Phiên này ô trắng
  KHÔNG tái hiện (Nguyen cũng không phàn
  nàn) — instrument đã chạy đúng nhưng
  không có ca để kết án; vụ ô trắng ytz2
  giữ nguyên trạng thái: thiếu bằng chứng
  trạng thái tại đúng thời điểm trắng.

### 26.9 Weather + đổi PID

- Weather: 8 dòng [weather] — toàn bộ thuộc
  2 giao dịch warming-cache phía
  SpringBoard, mỗi giao dịch ngay sau một
  lần SpringBoard khởi động lại (16:19:28,
  PID 34986; 16:27:35, PID 35036). Cả hai
  kết thúc trọn vẹn: ans# begin →
  fetch-begin (location status 0, last fix
  none → fallback vị trí app dẫn đường) →
  ready-posted; legacy ghi updated HTTP 200
  trong ~1,2 s / ~1,1 s. Cả hai đều mang
  nhãn tường minh source=warming-cache
  (internal startup call, NOT a CarPlay
  request). Timeout trong cửa sổ: 0.
- Request thật từ CarPlay: 0 — grep toàn
  cửa sổ: req# = 0 dòng, answer-received =
  0, applied (weather) = 0, display
  (weather) = 0, timeout-no-answer = 0.
  Chuỗi request-từ-CarPlay → answer →
  display TIẾP TỤC chưa có bằng chứng —
  không phải vì chuỗi gãy, mà vì phiên
  không phát sinh request thật nào để truy.
  Trạng thái mục weather: THIẾU DỮ KIỆN
  (giữ nguyên từ §25.1, sau hiệu chỉnh phạm
  vi của GPT). Nguyen không phàn nàn weather
  phiên này.
- Đổi PID: CarPlay đổi 3 lần trong cửa sổ
  (34964 → 34985 → 35035), SpringBoard đổi
  đồng bộ (34934 → 34986 → 35036); hai mốc
  khởi động lại ~16:19:09–13 và ~16:27:16–19.
  Grep exception / SIGBUS / abort / EXC_ /
  unrecognized-selector toàn cửa sổ: 0 chữ
  ký crash thật (2 hit duy nhất là chuỗi
  "exception" nằm trong tên thuộc tính của
  DIAG dump của DBDashboardHomeViewController).
  Nguyên nhân đổi PID: KHÔNG xác định được
  từ log này (cùng mẫu phiên ytz2).

### 26.10 Trạng thái + chờ GPT phán

- Mức đạt của phiên, từng track ghi rõ mức:
  FS controller + guard — DEVICE PASS (sổ
  sách khép kín, ca bắt buộc của GPT trọn 2
  lần; riêng tính chặn-khi-popup-mở chưa có
  ca FS trực tiếp); feed native — DEVICE
  PASS (chuỗi quyết định 6/6, khe wake
  native bị kết án ở phiên ytz2 đã đóng ở
  tầng cơ chế); act hosted — DEVICE PASS
  (26/26); YTZ — DEVICE PASS kèm đối chứng
  OFF hợp lệ đầu tiên (bệnh gốc tái hiện
  trên đường gốc đúng vai trò đối chứng);
  AutoHide phía split — giữ PASS từ ytz2;
  AutoHide khi EXPANDED — FAIL so với kỳ
  vọng của Nguyen (0 fade / ≈961 s; cơ chế
  đã rõ, chờ phán gỡ treo); bàn phím — ĐÃ
  CHỐT danh tính (Maps native, không phải
  delta của ytz3); touchset — ĐẠT mục đích
  đo (khử trùng là bắt buộc; chưa có mẫu
  pinch thật); icon — THIẾU DỮ KIỆN (đầu
  đọc mù); ô trắng — không tái hiện;
  weather — THIẾU DỮ KIỆN (0 request thật);
  Gate 3 — CHƯA MỞ (vật cản duy nhất còn
  lại: tín hiệu kb phía app).
- ENFORCE vẫn ĐÓNG (wake Gate 3 + pinch) —
  không mục nào của phiên này tự mở cổng.
- SÁU điểm chờ GPT phán quyết: (i) Tín hiệu
  kb phía app → Gate 3: kb không xác định
  38/38 trong khi owner kb=0 ở 26/26 — bổ
  sung kênh kb cho phía app (hay suy kb từ
  trạng thái phiên/kênh khác) rồi mở Gate
  3, hay giữ DRY_RUN; lưu ý phím native vô
  hình với cổng (kb=1 không xuất hiện dù
  Maps native có mở phím) — thiết kế
  kb-signal phải nói rõ ca native. (ii) Gỡ
  HAI khoá treo AutoHide khi EXPANDED để
  logo/controls tự ẩn như ở split (phân
  tích tương tác ở probe-ytz3-session-q.md:
  gỡ cả hai không làm vỡ đường nào theo
  source). (iii) Đối xứng revoke YTZ: grant
  chạy layoutPane commit settings, revoke
  không chạy layout nào — có đóng mắt này
  không; và R2 (snapshot cỡ đầu phiên) xử
  lý theo hướng đối chiếu cỡ ô hiện tại hay
  giữ nguyên chờ bằng chứng. (iv) Mở vòng
  tại đường Home thật (SCPHooks.m /
  SCPAppIcons.m / SCPHomeApply.m) cho cơ
  chế mất icon — đầu đọc phía picker đã mù,
  phạm vi hiện tại không còn dữ kiện nào
  lấy được nữa. (v) Pinch: hiệu chuẩn bằng
  mẫu hai-contact-thật (chưa từng ghi được
  ở cả hai phiên) hay park kiến trúc ghép
  cặp tại CarPlayApp; khử trùng theo (evB +
  điểm bắt đầu + window) là điều kiện tiên
  quyết đã có số. (vi) Ngữ nghĩa fullscreen:
  bản hiện tại là MẶT SPLIT PHỦ KÍN (hai ô
  giữ tỉ lệ, thu hồi vùng dock, container
  xác nhận ±0,5 pt) — giữ ngữ nghĩa này hay
  chuyển sang MỘT Ô BUNG KÍN như nút Toàn
  màn của bản gốc; Nguyen đã hỏi trực tiếp
  "fullscreen hoạt động thế nào" trong
  phiên này.
- Giữ nguyên: bản đứng test vẫn là ytz3 FAT
  (SHA c1872b93…); QA20 vẫn là bản dùng hằng
  ngày của Nguyen; VISUAL_ORIGINAL_
  COMPARISON = PENDING; núm vẫn PENDING
  diện NO DATA (phiên này không có thêm dữ
  kiện payload nào). Hai đề xuất của §25.5
  còn hiệu lực ở phần phiên này chưa trả
  lời: accessor gen chỉ-đọc (feed vẫn dùng
  epoch của probe) và generation qua notify
  state cho kênh weather (phiên này cộng
  thêm sự thật: không request thật nào phát
  sinh để tương quan). Các sửa đã rõ cơ chế
  (gỡ treo AutoHide, đối xứng revoke) KHÔNG
  tự vào bản — chờ GPT phán rồi gom MỘT deb
  theo quy tắc một-deb của Nguyen.

## 27) VÒNG YTZ4 — SỬA THEO PHÁN QUYẾT GPT SAU PHIÊN YTZ3 (2026-11-09)

### 27.1 Phán quyết của GPT sau phiên ytz3

GPT đối chiếu log ytz3 với source + hồ sơ tại
`9be396b`: duyệt tiến triển fullscreen / native
wake / YTZ của §26, nhưng bắt một lỗi nguồn dữ
liệu trong đề xuất bàn phím của vòng trước và
siết AutoHide-EXPANDED từ hai khoá thành ba.
(Ghi chú thời điểm: lúc GPT kiểm tra, cây repo
vẫn kết thúc ở §25 — §26 + ba biên bản phân tích
lên cây ở commit `b33b1a3`, sau thời điểm GPT đọc;
các quyết định dưới đây dựa trên log + source,
không mâu thuẫn §26.)

(i) **Bàn phím — đề xuất chở kb của owner về app
bị bác vì giặt nguồn.** GPT chỉ đích danh cơ chế:
`ABInApp.m:297` phát flag bằng biểu thức
`BWKb == BWKbActive`; khi trạng thái là
BWKbUnknown, biểu thức này cũng cho 0; phía owner
ở `SCPCarSplit+BridgeWake.m:652–654` chỉ ghi và
dùng lại đúng flag đó. Vậy "38/38 kb=- phía app"
và "26/26 kb=0 phía owner" ở §26.3 **hoàn toàn có
thể cùng xuất phát từ một trạng thái UNKNOWN
duy nhất** — chở giá trị này ngược về app chỉ
biến UNKNOWN thành "biết không có bàn phím".
Hướng được duyệt: tín hiệu **ba trạng thái có
nguồn xác thực** — giữ UNKNOWN / INACTIVE /
ACTIVE, không mặc định UNKNOWN thành INACTIVE;
đọc đường quản lý bàn phím hosted THẬT phía host
(điểm mở, điểm đóng, đối tượng phiên đang sống);
đồng bộ snapshot ban đầu + cập nhật về app, gắn
bundle/assignment của phiên — thiếu snapshot
hoặc mất đồng bộ thì UNKNOWN; bất kỳ bằng chứng
ACTIVE hợp lệ nào cũng phải chặn suppression;
instrument riêng kbKnown, kbActive, nguồn tín
hiệu và phiên. **Gate 3 vẫn chưa mở**: sửa tín
hiệu xong vẫn cần đo nuốt trọn chuỗi (nuốt → cú
chạm tiếp theo vào app → nhập liệu → teardown);
không được nói "xong kb là suppression đã có
bằng chứng trọn".

(ii) **AutoHide EXPANDED — duyệt sửa, ba điểm
bắt buộc, không chỉ hai:** (1) `bwSetExpandedActive:`
bỏ việc suspend AutoHide chỉ vì EXPANDED; (2)
`ahFadeBlockedReason` bỏ khoá "expanded"; (3)
`bwRecomputeForPane:` bỏ phép tự nâng
HIDDEN → VISIBLE chỉ vì EXPANDED — điểm thứ ba
nằm ở BridgeWake.m:395–400 theo số dòng GPT đọc;
nếu chỉ gỡ hai khoá đầu, controls có thể mờ thật
nhưng state gửi xuống app vẫn báo VISIBLE,
suppression sai ngữ nghĩa. Giữ quyền pinch-in
thoát EXPANDED độc lập trạng thái fade; giữ các
khoá popup, dragging, bàn phím. **Hosted-solo
giữ nguyên vòng này** (lệnh của Nguyen rõ cho
fullscreen của split; chưa có bằng chứng đường
wake solo tương đương để gỡ luôn khoá đó).

(iii) **YTZ — chấp nhận đối chứng OFF, không
thêm layout cưỡng bức khi revoke.** Log xác
nhận: revoke pref 16:22:22.329, bật lại dọn
requestedOrientation 4 → 0 lúc 16:22:33.449,
khoảng OFF 11,12 s hợp lệ; giá trị 4 phát sinh
trên ĐƯỜNG GỐC trong lúc OFF nên không được gọi
là residue do YTZ để lại. Giữ revoke hiện tại;
khoảng chờ đến sự kiện tiếp theo chưa tự chứng
minh cửa sổ bị stale. Chỉ bổ sung snapshot kích
thước/hướng lúc revoke + lần layout kế tiếp;
chỉ sửa nếu có sai lệch thực tế cần khắc phục.

(iv) **Fullscreen — đạt các ca đã chạy, còn
thiếu ca guard ngược.** 13 expand confirmed +
đường restore/session-end là tiến triển có bằng
chứng; lỗi chặn oan do tồn tại window đã khắc
phục trong các ca đo. Nhưng `drop-popup` của
feed KHÔNG thay cho nghiệm thu guard của
controller: vòng tới thêm **đúng một ca** —
popup còn mở → yêu cầu expand → bị từ chối với
snapshot đúng. Ngữ nghĩa hiện tại được **giữ
cho vòng này** và phải ghi rõ khi hướng dẫn
test: toàn bộ split phủ phần màn hình trước đây
dành cho dock/status bar, hai ô giữ tỉ lệ; một
ô bung kín là chức năng khác.

(v) **Icon — duyệt mở phạm vi instrument đường
Home:** theo dõi thư viện thực tế tại
`_newApplicationLibrary` / `_loadFromProxy:`,
các điểm inject/remove trong SCPAppIcons.m, rồi
trạng thái áp dụng trong SCPHomeApply.m; ghi rõ
process thực thi, không mặc định tất cả nằm ở
SpringBoard. `live-grid-read` count=0 của vòng
trước là đầu đọc chưa nhìn thấy dữ liệu, **chưa
phải bằng chứng OmniCar bị xoá**.

(vi) **Pinch — tổ chức một lượt hiệu chuẩn có
chủ đích**, chưa park vô thời hạn, chưa đổi kiến
trúc: đánh dấu riêng một ngón đứng yên/kéo, rồi
hai ngón đứng yên/tách/chụm trong cùng ô; phải
tìm được hai contact độc lập trước khi ghép
cặp; không biến 62 biểu diễn trùng thành pinch.

(vii) Weather vẫn PENDING đường
request→answer→display (hai warming không đóng
được mục này). Bàn phím Maps native: chưa quy
lỗi cho delta ytz3, nhưng "không phải
regression" không đồng nghĩa giao diện đã đạt.
**Wake ENFORCE và pinch ENFORCE tiếp tục khoá**
đến khi có nghiệm thu tương ứng.

### 27.2 Việc ytz4 — kb xác thực (hai strand HB + K2)

**Hiệu chỉnh topo (đọc từ source, khác giả định
trong ngoặc của WO gốc):** `hostFrameInfo` do
SCPCarSplit dựng và gửi qua `appbridge.frame`,
ABHost tiêu thụ — không có chân ABHost→owner nào
trong builder đó để cộng trường kb. Chiều
ABHost→owner thật là họ kênh NSDistributed
host→car (`appbridge.state`, `handletap`, …).
Trường kb đi trên một kênh mới cùng họ:
**`com.anlai.omnicar/appbridge.kbsync`** (hằng số
hai phía `ABChanKbSync` / `SCPNoteBridgeKbSync`),
payload dict `{identifier, kbactive, kbsession,
kbsource="host-keyboard-session"}`. hostFrameInfo
giữ nguyên 30 key (kiểm ở tích hợp, §27.5).

**Phía host (ABHostGeometry.m):** đối tượng phiên
thật là `ABKeyboardDispatch` — consumer của
Darwin `appbridge.keyboard`, chính là nơi gọi
`showForApp:`/`hideForApp:`. Mọi mở/đóng funnel
qua `ABKbSyncNoteEvent`, giữ bản ghi phiên sống
duy nhất (`abKbLiveBundle`, `abKbLiveSession`, bộ
đếm phiên tăng mỗi lần mở): dispatch show → post
active=1 + phiên mới (:228); dispatch hide →
post active=0 + phiên bị đóng (:222); teardown
`closeApp:terminate:` (ABHostLaunch.m:261) có
post riêng qua cùng funnel vì điểm ẩn này vòng
qua dispatch; CarPlay disconnect post đóng cho
bundle đang giữ phiên trước teardown (:259);
snapshot ban đầu ở `ABOpenBlock` (:365) post cho
app vừa (re)open — active chỉ khi app đó đang
giữ phiên sống. Mỗi post log `[kb-sync] host post
… source=host-keyboard-session`.

**Phía owner (BridgeWake.m):** bản ghi ba trạng
thái theo slot `bwKbKnownBySlot / bwKbActiveBySlot
/ bwKbSessionBySlot[10]`; known=NO là UNKNOWN và
**không một đường nào mặc định UNKNOWN thành
INACTIVE**. `bwHandleKbSyncNote:` (:302) khớp
bundle với slot đang giữ; bundle không thuộc
slot nào → drop có log `[kb-sync] drop
not-assigned`; đổi → log `change` kèm source +
phát ngay. Reset về UNKNOWN tại đúng hai điểm
đổi assignment: khối gen bookkeeping trong
`bwRecomputeForPane:` (bundle đổi → gen tăng) và
`bwSessionTeardown`. Nguồn duy nhất của bản ghi
là kbsync: giá trị bị GPT kết án (flag act
`BWKb == BWKbActive`, cho 0 cả khi Unknown)
**không bao giờ được phát lại thành tri thức
kb**. Bất kỳ bằng chứng ACTIVE hợp lệ nào
(kbsync active=1) đều ghi known=1/active=1 và
chặn suppression phía app theo hợp đồng gói.

**Hợp đồng gói kb:** đi trên kênh state
`bridgewake.v1.state` bằng poster riêng
`BWEmitKbPacket` (BridgeWake.m:190) nhưng dùng
CHUNG register-check token `bwStateSendToken` và
CHUNG bộ đếm seq đơn điệu `bwStateSeq` với poster
state. **type = 6** (bảng type: 0 invalid, 1
state, 2 query, 3 wake, 4 ack, 5 act, 7
reserved). Header giữ kỷ luật state (bit63
valid, hash28, seq, gen = gen assignment hiện
hành của slot); payload theo type: **bit 9 =
kbKnown, bit 8 = kbActive** (vị trí vốn là
pinchMode ở gói state — gói kb định nghĩa lại
theo type); flag/wakeMode/state = 0. Phát tại ba
điểm: phiên phím mở/đóng (tức thì từ handler),
app query (phát thêm gói kb cho đúng app vừa
query), vòng renew 1,0 s cùng vòng quay state.
**Kiểm chéo layout ở tích hợp: KHỚP TUYỆT ĐỐI**
— hai phía dùng CHUNG một C core `BridgeWakePack.h`
(4 bản trong cây identical từng bit, md5
`17c004e0…`); 5 word kb của hai strand đều tái
lập đúng qua core thật và giải ra đúng từng
trường; **hai bộ vector của HB và K2 chỉ khác
tham số** (HB chạy gen=3 với seq 7/8/9; harness
K2 chạy gen=7 với seq 1/2) — đóng gói cùng một
bộ tham số theo mô tả hai phía cho cùng một word
`0xE9DA706803801B06`, identical. Hồi quy V1/V9/V10
không đổi một bit.

**Phía app (ABInApp.m, strand K2):** `BWOnKbPacket`
nhận gói type 6 — khớp hash28 của chính app +
`BWGenAccept` (kỷ luật gen của gói state); gói
lỗi known=0 mà bit active=1 → bit active bị bỏ;
gói kb không đụng state chrome, danh tính phiên
act, hai latch mở khoá, và **không tự nâng
BWGen/BWKnown** (danh tính gen vẫn do gói state
định nghĩa). Snapshot owner `kbOwner{Known,
Active, RxAt}` xoá trong `BWResetAll` cùng
phiên. Trạng thái hiệu dụng `BWKbEffective`:
ACTIVE nếu BẤT KỲ nguồn hợp lệ nào nói active
(nguồn cục bộ — phiên first-responder + thông
báo khung phím, qua một setter duy nhất
`BWKbLocalSet` — hoặc snapshot owner còn tươi
nói active); ngược lại snapshot owner còn tươi
quyết định (INACTIVE của nó, **hoặc UNKNOWN của
chính nó** — sync sống nhưng nội dung "chưa
biết" vẫn ghi kbSrc=owner); hết tươi → UNKNOWN.
**Ngưỡng tươi phía app = 3,5 s** (= 2,0 s xoay
vòng worst case của renew trong split 2 ô + 1,0
s một tick mất trọn + 0,5 s lệch lịch); quá
ngưỡng thì UNKNOWN — không bao giờ là INACTIVE
được nhớ lại. Cổng `BWGatePass`: ACTIVE → fail
"kb", UNKNOWN → fail "kbunknown", chỉ
known-inactive mới qua; kỷ luật DRY_RUN nguyên
vẹn. **Điểm phát act-flag :297 nay chỉ phát bằng
chứng ACTIVE dương**: bit chỉ là 1 khi trạng
thái hiệu dụng là ACTIVE (`BWKbEffective(...) ==
BWKbActive`); UNKNOWN không đội lốt inactive ở
điểm này nữa. Instrument probe: latch đầu
sequence chụp `{Known, Active, Src, Age}`, dòng
close in `kbKnown=%d kbActive=%d kbSrc=%s
kbAge=%ld` (src ∈ owner/local/none; age = tuổi
của nguồn thắng, −1 = không có thông tin kb
nào) — bản ghi để phiên sau đo chuỗi suppression
ở mức wouldSwallow theo lệnh GPT. Harness C của
K2: **16/16 PASS** (K1–K9: khớp hash/gen, gói
lỗi, gen stale bị bỏ, hết tươi ở 3,4 s/3,6 s,
cục bộ ACTIVE thắng owner INACTIVE còn tươi,
owner ACTIVE thắng cục bộ unknown).

### 27.3 Việc ytz4 — gỡ đủ BA ràng buộc AutoHide-EXPANDED

Cả ba điểm đều ở SCPCarSplit+BridgeWake.m /
SCPCarSplit+AutoHide.m, kiểm độc lập khẳng định
đủ ba (verify-ytz4 mục a):

1. **`bwSetExpandedActive:` không còn suspend**
   (BridgeWake.m:440): thân hàm chỉ đặt
   `bwExpandedFlag`/`bwExpandedBundle`, log
   `[wake1] bw expanded …`, chạy
   `bwRecomputeForPane:` cho mọi ô hosted. Lời
   gọi `ahSetSuspended:` trong BridgeWake.m =
   **0** (chỉ còn một đoạn comment ghi việc đã
   gỡ). Điểm gọi thật toàn module còn đúng:
   định nghĩa ở AutoHide.m:273 (+ bounce
   main-thread) và hai điểm hosted-solo
   SCPCarSplit.m:2019 (vào) / :2039 (ra) —
   hosted-solo giữ nguyên đúng lệnh GPT.
2. **`ahFadeBlockedReason` bỏ hạng tử expanded**
   (AutoHide.m:140): thân hàm nay chỉ còn bốn
   khoá theo thứ tự solo → kbhold →
   surface-open (popup — khoá popup) → dragging
   (khoá dragging); khoá bàn phím là kbhold.
   Grep `"expanded"` trong thân hàm = 0.
3. **`bwRecomputeForPane:` bỏ phép nâng
   HIDDEN→VISIBLE theo EXPANDED** — khối
   `if (state == BWStateHidden && bwExpandedFlag)
   state = BWStateVisible;` bị xoá (grep mẫu đó
   toàn module = 0), thay bằng comment ghi ngữ
   nghĩa mới; `bwExpandedFlag` trong TU này chỉ
   còn ở statics, setter/getter và hai hàng
   EXPANDED của arbiter.

**Điểm cần ghi trung thực:** phân tích nguồn ở
vòng trước (probe-ytz3-session-q.md, được tóm
lại trong §26.4/§26.10(ii) như "hai khoá treo")
đã phán HẠNG TỬ NÀY NGƯỢC HƯỚNG — lúc đó nó được
đọc là "hạng tử thăng cấp riêng khiến gói trạng
thái không đổi, gỡ hai khoá là đủ". GPT đọc
thẳng thân hàm và kết luận ngược lại: chừng nào
phép nâng còn đó, state gửi xuống app vẫn báo
VISIBLE dù controls đã mờ thật, và suppression
sai ngữ nghĩa. Phán quyết GPT là đúng cơ chế;
hồ sơ ghi lại việc phân tích trước phán ngược ở
điểm này, không sửa lặng lẽ.

Truy vết sau gỡ (kiểm độc lập): đang EXPANDED mà
đủ điều kiện (ô assigned, không wake transaction
mở trên slot, không transient, **barHidden của
chính ô** — HIDDEN vẫn cần thanh menu của ô
xuống theo timer riêng của nó, fade một mình
chưa đủ — và fadedEffective) thì state tính ra
tới được **BWStateHidden** và gói state phát đi
nói HIDDEN; EXPANDED không xuất hiện trong bất
kỳ điều kiện nào. Chuỗi fade khi EXPANDED chạy
đủ như ở split (arm timer → fade → recompute →
gói HIDDEN → activity → reveal). Marker kỳ
vọng: `[wake1] bw expanded ON` không còn
`[autohide] suspend` đi kèm vì expanded; cặp
suspend/resume chỉ còn quanh chuyển hosted-solo.
**Pinch-in độc lập fade — kiểm bắt buộc ĐẠT
bằng đọc thân hàm:** hàng EXPANDED của cả
`bwPinchAllowedForPane:` lẫn
`pinchDispositionForPane:` (vị từ phiên:
`bwExpandedFlag && self.active && pane ∈
allPanes && !wakePending && !resizing`) RETURN
TRƯỚC mọi lần đọc `bwStateBySlot`;
`grep ahFaded|ahSuspended` trong
SCPPinchController.m = 0 hit.

### 27.4 Việc ytz4 — [homelib] và snapshot revoke YTZ

**[homelib] (strand I2 — CHỈ cộng log vào
SCPHooks.m / SCPAppIcons.m / SCPHomeApply.m,
không đổi hành vi inject/remove/apply, không
hook mới; hook-installer trong SCPHooks.m giữ
31 → 31).** Sự thật về process, trả lời thẳng
yêu cầu "ghi rõ process thực thi" của GPT:
dylib có filter nạp vào cả `com.apple.CarPlayApp`
và `com.apple.springboard`, nhưng **toàn bộ họ
Home/library này chỉ tới được qua các constructor
gated `SCPHostIsCarPlayApp()`** trong SCPHooks.m
(`__init_0`) và các caller từ đó — trong
SpringBoard các điểm đo này KHÔNG bao giờ thực
thi. Mọi dòng `[homelib]` đều in
`proc=<processName>(<mainBundleID>)` đọc tại
runtime; kỳ vọng mọi dòng đều là
`CarPlay(com.apple.CarPlayApp)` — phiên sau đối
chiếu trực tiếp, không suy đoán. Điểm đo: hai
hook thư viện trong SCPHooks.m (`event=new-library`
kèm count của `allInstalledApplications` trên
chính object thư viện vừa dựng + cỡ tập đã
chọn; `event=loadFromProxy bundle= injected=`);
nhật ký quyết định trong SCPAppIcons.m qua
helper `SCPHomeLibLogDecision` (skip-not-chosen /
skip-already-ours / skip-real-declaration /
skip-no-decl-class / inject / lib-skip-present /
lib-skip-no-proxy / lib-add /
remove-skip-no-proxy / remove — điểm gọi
`removeApplicationProxy:` **duy nhất** của
module, grep toàn module = 1); trạng thái lưới
hậu-áp-dụng trong SCPHomeApply.m
(`event=apply-published count= omni=`, mẫu
`homelibOmniOnGrid` lấy TRƯỚC các bộ lọc
seen/injected nên icon đã tiêm vẫn tính là có
mặt). Throttle: quyết định theo bundle chỉ log
khi ĐỔI so với lần trước cho bundle đó; sự kiện
thư viện + apply-published log mọi lần; riêng
**OMNI (`com.anlai.omnicar.app`) miễn throttle**
— mọi quyết định chạm tới nó đều log và cộng
một dòng `[homelib] OMNI decision=…` riêng, kể
cả skip. Khoảng trống đã khai (không giấu):
quyết định ghi declaration THẤT BẠI
(`SCPHomeSafeSet` trả NO) không có token
[homelib] riêng — chặn nó bắt buộc sửa đúng
dòng guard, phá cổng diff thuần cộng; thất bại
này đã có log sẵn của chính `SCPHomeSafeSet`.
Cách đọc phiên sau: nếu icon mất mà KHÔNG có
dòng OMNI/decision nào cho bundle đó → điểm mất
nằm HẠ nguồn của đường inject/remove này (icon
model/lưới); nếu có dòng `remove` cho nó → kết
án tại chỗ kèm proc + mốc thời gian.

**Snapshot revoke YTZ (strand Y2S — CHỈ
ABYTZoom.m, instrument thuần; giữ nguyên revoke
theo phán quyết (iii), KHÔNG layout cưỡng bức).**
Marker `[ytz-revoke-snap]` ở cuối thân
`yzLeaseRevokeForPane:reason:` (ABYTZoom.m:516)
— chạy ở MỌI revoke qua hàm này (cả `pref` lẫn
`teardown`) — cộng đường mồ côi trong
YZHandlePrefChanged (:617): pref OFF khi pane
đã biến mất trước đây flip + publish trực tiếp
không qua hàm revoke và không có dòng log nào;
nay có snapshot với các trường hình học =
unavailable. Bộ trường qua hàm chung
`YZSnapshotFields` (:272): bundle, hash (FNV-1a-32
— đúng giá trị khớp ô), gen (sau post thu
hồi), `logical` (cỡ logical đã commit gần nhất),
`pub` (cỡ đã publish), `box` (`pane.sceneBox`),
`frame`, `reqOrient` (tuyên bố gần nhất mà
`appWithHash:` đã LƯU — trong kỳ lease các tuyên
bố bị tiêu thụ không lưu, nên lúc revoke đây là
giá trị TRƯỚC lease, đóng băng từ lúc grant;
đọc phải hiểu như vậy), `paneOrient` (baseline
từ pref lúc dựng ô), `settingsOrient` (đọc
NGƯỢC từ settings đã commit của scene qua chuỗi
guard respondsToSelector + @try cùng chuỗi
đường commit dùng; thiếu mắt xích nào thì
`settingsOrient=unavailable`, không bịa giá
trị). **`lastDecl=unavailable` là trường trung
thực cố định**: tuyên bố hướng gần nhất của app
KHÔNG đọc được từ TU này — trong kỳ lease tuyên
bố bị tiêu thụ ở `appWithHash:`
(ABHostBMethods.m), nơi chỉ chuyển hash gói sang
điểm log chặn; giá trị changed/mask không bao
giờ vào ABYTZoom.m. Không trường nào khác được
đóng vai trường này. Marker `[ytz-nextlayout]`
one-shot ở đuôi `YZPublish` (:349 — điểm phát
DUY NHẤT của module): lần republication đầu
tiên của record kể từ revoke, kèm `dt=` giây từ
revoke; dòng grant tươi cộng trường
`prevRevoke=%.2fs`. Giới hạn ghi rõ: one-shot
khoá theo REPUBLICATION, không theo layout thô
— layout không đổi nội dung thì không post;
khi lease đã chết không tồn tại điểm phát nào
trong module để gắn marker; ô không bao giờ
được publish lại sau revoke thì marker không
xuất hiện (sự vắng mặt là dữ kiện "chưa có
republication"). Cách đọc phiên sau: so
box/logical/settingsOrient giữa revoke-snap và
nextlayout — **lệch nhau mới là sai lệch thực
tế cần sửa** theo lệnh GPT; khớp nhau thì khoảng
OFF là bệnh gốc thuần tuý, giữ revoke như hiện
tại. Diff Y2S: +134/−2; hai dòng "−" là hai nửa
của ĐÚNG MỘT format-string của lời gọi log
grant cũ, nới để cộng `prevRevoke` — thuần cộng
về hành vi (kiểm độc lập mục (c)/(d) khẳng
định: ngoài instrument, YZ hai phía không đổi
hành vi; ABInApp 14 hunk đều trong vùng
kb/wake/act, không hunk nào chạm hàm ảo hoá YZ).

### 27.5 Hai lệch phụ của kiểm độc lập (ghi nguyên, không tự hoà giải)

Kiểm độc lập vòng ytz4 (verify-ytz4) khẳng định
cả bốn mục (a) ba ràng buộc, (b) kb xác thực,
(c) thuần cộng I2/Y2S, (d) YZ ổn định ngoài
instrument — và ghi hai lệch phụ sau đây
NGUYÊN TRẠNG, không tự hoà giải ở vòng này:

**(L1) Consumer thứ hai của kênh
`appbridge.keyboard` ở ABChannels.m:358 — chết
trong thực tế.** Cùng target OmniCarAppBridge
có thêm một `notify_register_dispatch` cho cùng
kênh Darwin (đoạn :358–369), hide-only, KHÔNG
qua funnel kbsync. Đọc kỹ: consumer này giải
hash bằng `(uint32_t)state` (32 bit thấp), trong
khi packing của phía gửi đã kiểm chứng
(ABInApp.m:1780) là `shown | type<<1 | return<<8
| FNV1a(bundle)<<24` — 32 bit thấp là hỗn hợp
cờ + 8 bit thấp của hash, không thể bằng một
FNV-1a-32 đầy đủ của pane nào (trừ trùng hợp
~2^-24), nên `bundleForHash:` trả nil và block
không làm gì. Consumer có hiệu lực duy nhất là
`ABKeyboardDispatch` (đọc `state >> 24`, khớp
packing). Kết luận về nguồn kb ở §27.2 không
đổi — funnel là đường duy nhất có hiệu lực —
nhưng đăng ký thừa này là **rác tái tạo có từ
trước vòng ytz4** (không phải code của vòng
này). Để GPT quyết: dọn hay giữ; vòng này không
tự xoá hộ.

**(L2) Reset UNKNOWN phía owner kích theo chuỗi
bundle đổi — gán lại CÙNG bundle vào CÙNG slot
không reset.** Điểm reset (i) trong
`bwRecomputeForPane:` kích hoạt khi chuỗi bundle
của slot đổi; một lần gán lại cùng bundle vào
cùng slot trong một phiên đang sống không kích
hoạt nó, nên bản ghi kb của cặp (bundle,
assignment) cũ có thể sống qua lần gán lại đó ở
tầng owner. **Giảm nhẹ có sẵn, ghi đúng mức:**
host post snapshot lại mỗi lần app (re)open
(ABOpenBlock — snapshot thuộc về phiên phím
sống hiện tại), và snapshot phía app hết tươi
sau **3,5 s** → UNKNOWN; tức cửa sổ tin cậy sai
tối đa bị chặn bởi hai cơ chế đó, nhưng ở tầng
owner thì chưa được xử lý — ghi để GPT biết,
không coi là đã đóng.

### 27.6 Số đo và trạng thái

- Candidate local:
  `com.anlai.omnicar_1.0.3-ytz4_iphoneos-arm64.deb`
  — **1.031.204 B**, SHA-256
  `27ecedd4039c986262a051ad459d8dfe49881d1981ded82f7d27fd1fd98b9bbb`
  (chỉ để truy vết; ar: debian-binary +
  control.tar.gz + data.tar.lzma; control
  identical ytz3 từng dòng).
- FAT giao nghiệm thu:
  `com.anlai.omnicar_1.0.3-rebuilt-ytz4-fat_iphoneos-arm64.deb`
  — **1.229.512 B**, SHA-256
  `53caff295b29c277a3db31c102f7817284345e573d0be3169ce4a6fccfe8a3a2`
  (tự đo trên bản ở handover; Installed-Size
  5964, bằng ytz3).
- Git: nguồn main
  `237098ca4aca17a1b997db6b7ea5a1a87a024849`
  (đúng 31 file = 15 project + 16 src,
  +1431/−80); ci-fat-test
  `aff33ed4328170ecca35eaa1b2b774da950cab71`
  (merge main; diff project/src giữa hai nhánh
  = 0). CI: workflow 410962367, run dispatch
  **42599165348** — SUCCESS (job build-fat
  10:12:25Z → 10:15:37Z; xác minh foreground
  bằng jobs API + `gh run view` sau khi job
  hoàn tất; biên bản CI ghi trung thực các truy
  vấn metadata chập chờn quanh phút hoàn tất —
  sự thật chốt bằng jobs API và file deb đo tại
  đĩa, không dựa vào output nền/poll).
- Mirror: audit 15 cặp file của 4 strand —
  14/15 identical; 1 ngoại lệ đứng từ trước
  (SCPHomeApply.m khác đúng dòng import :18 —
  đường phẳng có chú thích của project vs
  `../SplitScreenB/` của src; chép đè sẽ phá
  import tương đối của cây src nên giữ nguyên;
  phần instrument +20/−0 khớp hai phía).
- Parity selector (unique __objc_methname,
  candidate vs ytz3): **0 MẤT ở cả 8 thành
  phần**. SplitScreen 1395 → 1398 (**+3**:
  `bwHandleKbSyncNote:`, `bwKbEmitForPane:` của
  owner kb + `unsignedIntValue`); AppBridge
  798 → 807 (**+9**: họ property
  `revokeSnapPending`/`revokeSnapAt` + hai
  setter + hai ivar + hai type-encoding của
  ABYTLeaseRecord, và `appendFormat:` — toàn
  bộ truy vào instrument Y2S). Trên FAT hai lát
  (vs FAT ytz3): SplitScreen 1394 → 1397,
  AppBridge 797 → 806, cùng delta, mất 0; sáu
  binary còn lại identical từng tên. Phần
  AutoHide của HB cộng 0 selector (sửa trong
  thân method sẵn có); I2 cộng 0; K2 và phần
  AppBridge của HB cộng 0 (hàm C static / thân
  hàm sẵn có).
- Hồi quy trên candidate: file list 179 = 179,
  diff rỗng; g1/g2/h/f diff = 0 (chuẩn hoá lệnh,
  địa chỉ dịch do code cộng phía trước — g1 IMP
  0x7e34 → 0x7e40, idiom còn nguyên); knob
  đúng **1 eor** (`eor w2, w27, #1`, IMP
  0x16504, 356 lệnh) — trên FAT: 1 eor mỗi lát
  tại đúng địa chỉ của ytz3 (arm64 IMP 0x12f9c
  eor @0x13208; arm64e IMP 0x13b58); **4 hash
  cấm MATCH cả 4** (setFrame 8606f40a…,
  setBarVisible 3044b10d…, setHandleVisible
  409cfb14…, setKnobs b98a9f26…); hostFrameInfo
  **30 key, tập giống hệt ytz3** (`split` vẫn
  từ presentation predicate, splitver=@1);
  điểm ghi requestedOrientation có giá trị vẫn
  duy nhất ABHostBMethods.m:607; kênh
  bridgewake 5/5 × 2 binary, ytlease/ytleaseack
  chỉ AppBridge — nguyên vẹn; MSHookMessageEx
  SplitScreen **31 không tăng**.
- Chuỗi mới trong binary đúng module: kbsync
  ×1 trong SplitScreen VÀ ×1 trong AppBridge
  (cả hai lát trên FAT; ytz3 = 0); SplitScreen
  `[homelib]` đúng **5 format**, `[kb-sync]` 3
  format; AppBridge `[kb-sync]` 1 format,
  `[ytz-revoke-snap]` 2 format,
  `[ytz-nextlayout]` 1, `prevRevoke=` 1,
  `lastDecl=unavailable` 1. `fullscreenTestExpand`
  = **0 trong toàn bộ gói**; binary Prefs chứa
  cả 3 khoá chẩn đoán ×1 mỗi lát.
- **Mức đạt của vòng: source complete / static
  PASS** (Gate-1 tích hợp PASS toàn bộ; kiểm
  độc lập khẳng định (a)–(d) kèm hai lệch phụ ở
  §27.5). Mọi verdict xe: PENDING — kịch bản ở
  ACCEPTANCE_YTZ4. **Gate 3 vẫn ĐÓNG** theo
  GPT: vòng này mới sửa tín hiệu kb; bằng
  chứng suppression trọn chuỗi (nuốt → chạm kế
  → nhập liệu → teardown) vẫn phải đo ở phiên
  ytz4 — và theo GPT, sửa tín hiệu xong vẫn
  chưa được gọi là "suppression đã có bằng
  chứng trọn". ENFORCE pinch vẫn khoá.
- Còn chờ sau phiên ytz4: ca guard ngược bắt
  buộc (§27.1(iv)); chuỗi suppression mức
  wouldSwallow kèm ca kb ACTIVE (§27.1(i));
  hiệu chuẩn pinch có chủ đích (§27.1(vi));
  dòng `[homelib]` đầu tiên từ đường Home
  thật; đối chiếu `[ytz-revoke-snap]` ↔
  `[ytz-nextlayout]`. Hai lệch phụ §27.5 chờ
  GPT quyết (dọn consumer chết hay giữ; biên
  reset cùng-bundle). Giữ nguyên: QA20 vẫn là
  bản dùng hằng ngày của Nguyen; ytz4 thay ytz3
  làm bản nghiệm thu duy nhất hiện hành;
  VISUAL_ORIGINAL_COMPARISON = PENDING; núm
  PENDING diện NO DATA; weather PENDING đường
  request→answer→display; đề xuất §25.5(i)
  accessor gen + §25.5(iii) generation qua
  notify state cho weather vẫn mở. ytz1 vẫn
  CÁCH LY.

## 28) PHIÊN XE YTZ4 — PHÁN QUYẾT TỪ LOG
(2026-11-09)

### 28.0 Nguồn dữ kiện + CẢNH BÁO HAI
THẾ HỆ BINARY

- Hai file log Nguyen upload (commit
  8db6471): OmniCar.log.old 2.183.174 B,
  SHA-256 ef801287… (10.889 dòng) và
  OmniCar.log 719.813 B, SHA-256 438701f9…
  (1.678 dòng). Bốn strand phân tích song
  song chỉ-đọc + một bản đối hoà
  (analysis-s1/s2/s3/s4 + analysis-ytz4-final,
  handover/reports/); hai biên bản nguồn mở
  trong phiên: probe-fade-icon,
  probe-exit-fade (cộng probe-picker-cover +
  probe-kb-frame cho hai lệnh phát sinh của
  Nguyen giữa phiên).
- **CẢNH BÁO KHUNG — hai file chứa HAI THẾ
  HỆ BINARY.** Các tag chỉ-có-ở-ytz4
  ([homelib], [kb-sync], [ytz-revoke-snap];
  ở ytz3 = 0 theo ci-ytz4) xuất hiện lần đầu
  ở CarPlay PID 35998 lúc 17:23:48, marker:
  `2026-11-09 17:23:48.836 [CarPlay:35998]
  SplitScreen: [fs1] fs controller installed
  (CarPlayApp)`. Các PID trước (35035/35411)
  có 0 dòng các loại này và mang chữ ký hành
  vi cũ (suspend khi expand, phép nâng
  HIDDEN->VISIBLE). **Mọi verdict của §28
  lấy phạm vi binary ytz4: 17:23:48 → hết
  log 17:44:31 (1.323,5 s)** trừ chỗ ghi rõ
  toàn file (toàn file 4.131,7 s). Gộp hai
  thế hệ sẽ ĐẢO NGƯỢC kết luận fade-expanded:
  khoảng expanded dài nhất toàn file
  (820,2 s ở PID 35411, 0 fade) là của binary
  cũ — bức tranh ytz3 nguyên vẹn, không phải
  ytz4 hồi quy.
- PID CarPlay trong phạm vi ytz4: 35998 →
  36057 → 36136 → 36168. Nguyên nhân chuyển
  PID (kể cả nhịp dồn cuối phiên, SpringBoard
  reload đồng bộ): NO DATA — hai strand quét
  độc lập đều 0 crash signature, 0 exception
  thật. Giữ trạng thái hai phiên trước: ghi
  nhận, không kết án. Scenevis verify 39/39
  khoẻ.

### 28.1 Fullscreen — controller + guard +
ca guard ngược: DEVICE PASS trọn

- Công tắc chẩn đoán: ON 9 / OFF 10; expand
  confirmed 3; restore confirmed 3; refusal
  13, TẤT CẢ state-based — reason tray/
  picker/popup = 0 ở cửa cổng vào (khác hẳn
  bức tranh ytz2, và vị từ nội dung của ytz3
  giữ nguyên hiệu lực).
- **Ca guard NGƯỢC bắt buộc của GPT (§27.1)
  ĐÃ ĐẠT, chuỗi khép trọn trong 7 giây**
  (PID 35998): mở picker `17:28:14.216 …
  popup chon 18 app cho o 0 (cua so rieng,
  0 o cho)` → bị từ chối `17:28:15.785
  [fs1] fs expand refused reason=picker
  provenance=diag snap{tw=1 twh=0 to=0
  tray=0 picker=1 ratio=0 dg=0 toast=0
  rz=0 fc=0 phase=0}` (lặp lại 17:28:17.819)
  → đóng picker bằng chạm 17:28:19.955 →
  `17:28:20.989 [fs1] fs expand confirmed
  txn=5 provenance=diag`. Đây là ca mà
  phiên ytz3 còn thiếu để đóng nghiệm thu
  guard (§26.1, §27.1(iv)) — nay đủ cả hai
  chiều: popup mở → chặn đúng snapshot;
  đóng hẳn → expand chạy. Mục fullscreen
  của GPT coi như ĐÓNG ở các ca đã chạy;
  ngữ nghĩa giữ nguyên theo phán (§27.1(vi)):
  mặt split phủ kín vùng dock/status-bar,
  hai ô giữ tỉ lệ chia.

### 28.2 Fade khi EXPANDED: DEVICE PASS

- Sau gỡ đủ ba ràng buộc (§27.3), fade chạy
  thật trong fullscreen: khoảng E3 dài nhất
  của ytz4 (136,6 s): fade 17:26:51.589 →
  reveal 17:27:08.550 khép (+17,0 s); nửa
  sau E3 bị deferred (surface-open) ×14 vì
  picker đang mở — khoá giữ có chủ đích,
  không phải lỗi. E2 (74,0 s): 3 fade (kèm
  ->HIDDEN + host applied), 2 chuỗi
  fade→reveal khép.
- Tại các expand của ytz4: suspend kèm
  expand **0/3** (hai strand đếm độc lập
  cùng kết quả; đối lại ytz3 13/13), phép
  nâng HIDDEN->VISIBLE 0 lần — state vào đã
  HIDDEN thì giữ HIDDEN, phép nâng đã gỡ
  đúng thiết kế. Đối lại phiên ytz3 (0 fade
  trong ~961 s expanded): mục này ĐÓNG.

### 28.3 KB transport — giặt nguồn ĐÃ ĐÓNG;
wouldSwallow dương: DEVICE PASS (mức would)

- Vấn đề giặt nguồn của ytz3 (§27.1(i)) đã
  đóng ở tầng transport: owner phát gói kb
  type 6 từ phiên phím host thật, app nhận
  được với nguồn xác thực. Probe mới 48
  dòng (phạm vi ytz4): kbKnown=1 ×36,
  kbSrc=owner ×42/48, kbAge max **3131 ms**
  với 0 ca vượt ngưỡng tươi 3500 ms.
  [kb-sync] ba phía khớp: host post 46;
  owner change 36 + drop 1 (Facebook chưa
  gán, đáp đúng); owner emit 1058; **18/18
  post mở/đóng khớp owner change ≤3 ms**.
  UNKNOWN-reset khi đổi gán xảy ra ×2
  (gen 2/3, gen 15) và tự hết khi snapshot
  host tới — nhưng là reset CÂM trong
  source, không có dòng log riêng (khoảng
  trống instrument, ghi nhận cho GPT).
- wouldSwallow=1 xuất hiện lần đầu tiên
  trong dự án: **×8** (ytz3: 0), 100% đúng
  tổ hợp known=1 / kbActive=0 / kbSrc=owner
  / state=H — cổng tính đúng bằng tri thức
  owner, không phải mặc định.
- Mắt "kb ACTIVE chặn nuốt" vẫn chưa có dữ
  kiện: toàn phiên chỉ 1 probe có
  kbActive=1 và ca đó ở state=V (17:29:14.143,
  src=local) nên cổng thoát ở mắt state
  trước khi tới mắt kb; reason kb = 0 lần.

### 28.4 Chuỗi suppression trọn: NO DATA —
thiếu đúng 3 mắt, do thứ tự phiên

- Chuỗi 17:32–17:33 không khép, và thứ tự
  NGƯỢC kịch bản nghiệm thu: dòng quyết
  định `17:32:24.119 [YouTube:35999]
  AppBridge: [do] bw probe seq=29 …
  kbKnown=1 kbActive=0 kbSrc=owner
  kbAge=663 state=H wouldSwallow=1` xảy ra
  **TRƯỚC** khi phím mở — host post
  `17:32:24.190 [SpringBoard] AppBridge:
  [kb-sync] host post com.google.ios.youtube
  active=1 session=3 source=host-keyboard-
  session`. Cú chạm wouldSwallow=1 đó
  chính là cú chạm MỞ tìm kiếm, không phải
  một cú chạm bị chặn khi phím đang mở.
- Sau đó tồn tại cửa sổ overlap THẬT:
  fade lại 17:32:28.079 khi phím còn mở tới
  17:32:34.326 (HIDDEN + kb ACTIVE cùng
  lúc) nhưng **0 probe / 0 act-posted
  trong cửa sổ** — không có chạm nào trong
  ~6 s phím mở nên không probe nào có thể
  cháy. Gõ chữ: 0 dòng nhập liệu toàn
  phiên. Sau khi phím đóng: 0 probe trên
  cùng assignment (gen=3). Teardown đầy
  đủ (17:33:38.369).
- Kết luận đối hoà: **NO DATA do hành vi
  phiên, không phải FAIL cơ chế.** Gate 3
  còn thiếu đúng 3 mắt: (i) probe khi phím
  đang mở + controls ẩn; (ii) gõ chữ khi
  controls ẩn; (iii) probe sau khi đóng
  phím trên cùng assignment. Các mắt còn
  lại của chuỗi (transport kb, would
  dương, feed native, freshness) đều đã
  có số đạt — xem §28.12 mục 1.

### 28.5 Wake native feed (hồi quy): DEVICE
PASS; W2 xuất hiện lần đầu

- [probe-feed] fired **86** (GOFA 44, Maps
  21, VLC 10, MobileSMS 7, mobilecal 4 —
  100% native); chuỗi fade→fired→reveal
  khép **14/14**; act hosted 54/54; 4 fade
  mồ côi đều là fade cuối của một PID /
  teardown / hết log — 0 sự kiện hợp lệ bị
  bỏ qua. Lưu ý đếm: strand đếm mục này
  trên toàn file chưa tách thế hệ — verdict
  không đổi vì chuỗi khép được đếm trên
  từng chuỗi, nhưng số tuyệt đối 86 không
  so trực tiếp với 41 của ytz3 (phiên đó
  một thế hệ).
- **W2 (ca phân định độ tươi state >2,5 s)
  ĐÃ XUẤT HIỆN lần đầu** sau hai phiên
  vắng: stateage của act-posted (n=54):
  max **8092 ms**; **12/54 ca > 2500 ms**
  (dải 2585–8092 ms). Các quyết định
  wouldSwallow=1 trong phiên đều dựa trên
  stateage tươi — không ca nào trong 8 ca
  dương dựa trên state già (ghi theo phân
  bố của strand S2; mức phán cuối thuộc
  GPT khi đọc biên bản S2).

### 28.6 Bàn phím tự vẽ — ảnh 2→3: KẾT ÁN
che khuất z-order

- Ba ảnh Nguyen chụp 17:32–17:33 (phím lớn
  đúng thiết kế / phím nhỏ lệch phải / phím
  bị bó vào hộp nhỏ giữa ô). Đối chiếu
  nguồn (probe-kb-frame): phím tự vẽ là
  MỘT đường duy nhất của ABHost cho mọi
  app hosted — solo và chia ô như nhau;
  SCPCarSplit không có đường phím riêng;
  khung panel tính MỘT lần tại show từ
  carAppArea (toàn bề mặt split) rồi đóng
  băng, cạnh dưới luôn neo đáy cửa sổ,
  delta hình học phím ở ytz4 = 0 dòng.
- Phân định từ log: giữa mốc ảnh 2 (17:32)
  và ảnh 3 (17:33) chỉ có MỘT sự kiện ẩn
  `17:32:34.308 ban phim xe: an
  (com.google.ios.youtube)` và **0 show
  mới** (show kế tiếp 17:33:52.718). Khung
  không thể tự đổi giữa hai ảnh → ảnh 3
  buộc là CÙNG khung của lần show trước bị
  một khung ô đè lên che phần lớn
  (z-order) — **kết án che khuất**, khớp
  phân tích nguồn (thành phần lơ lửng dọc
  của ảnh 3 không đường frame nào tạo
  được). Riêng tầng input của ảnh 2 (vì
  sao carAppArea tại show đó nhỏ/lệch)
  vẫn chưa kết án được: không dòng log nào
  ghi rect panel/carAppArea — xem §28.11.

### 28.7 Pinch / hiệu chuẩn: NO DATA

- [touchset] active=2: **101 ca, duplicate
  101/101, hai contact độc lập thật = 0**
  — mẫu thứ ba liên tiếp toàn biểu diễn
  trùng của một contact.
- **Hiệu chuẩn đánh dấu KHÔNG được thực
  hiện ở phiên này**: 0 episode chạm ≥2 s
  khớp kịch bản (1 ngón yên / kéo / 2 ngón
  yên cùng ô / tách / chụm, cách ~5 s).
  Kiến trúc ghép cặp vì thế vẫn chưa quyết
  được; ENFORCE vẫn đóng. Đây là NO DATA
  hành vi phiên, không phải dữ kiện chống
  lại kiến trúc nào.

### 28.8 YT-Zoom: DEVICE PASS; OFF control
NO DATA; revoke-snap PASS một phần

- Ack applied **51/51 w=1 m=0** (ytz3:
  38/38); mask 24 bị chặn 5/5, lọt 0. Lease
  và đường chặn giữ nguyên hiệu lực.
- **OFF control: NO DATA** — phiên này
  Nguyen không tắt pref YTZ (0 ca
  `ly do=pref`; 8/8 lần thu hồi là
  teardown). Khác ytz3 (có OFF 11,121 s
  đạt) — không phải hồi quy, là vắng dữ
  kiện; đối chứng OFF của ytz3 vẫn đứng.
- [ytz-revoke-snap] 7 dòng, [ytz-nextlayout]
  3, cặp được **3/7**; lastDecl=unavailable
  7/7 như thiết kế trung thực. Snap đầu
  tiên đầy đủ:
  `2026-11-09 17:33:38.370 [SpringBoard:
  35973] AppBridge: [ytz-revoke-snap]
  ly do=teardown bundle=com.google.ios.
  youtube hash=d3b4e0df gen=11
  logical=248x428 pub=248x428
  box=198x342.667 frame=45,0,198x342.667
  reqOrient=0 paneOrient=1 settingsOrient=1
  lastDecl=unavailable`. Bốn snap không có
  nextlayout kế: grant tiếp theo là gen=0
  ở SpringBoard PID mới — **khớp đúng giới
  hạn instrument đã khai ở §27.4**
  (nextlayout khoá theo republication),
  không phải làm rơi dữ kiện. Ca thu hồi
  16:54:00.206 thiếu snap mà strand S4 ghi
  "chưa rõ" được strand S1 giải thích trọn:
  mốc đó thuộc binary cũ (trước 17:23:48),
  binary đó chưa có tag — kỳ vọng vắng.

### 28.9 Icon YouTube — hai tầng, hai kết
luận khác nhau

**Tầng 1 — trong split (mất ~17:41; gọi
logo thì hiện lại): CHƯA PHÂN ĐỊNH ở tầng
hiển thị cell của dashboard.**

- Tầng source (probe-fade-icon): lớp sơn
  mờ **MINH OAN** — toàn runtime chỉ 2 hàm
  ghi layer.opacity; danh sách sơn đóng
  (pane.handle / divider / divider.knob /
  homeButton; phía host: handle của pane);
  launcherHost bị loại trừ tường minh vì
  có thể chứa phần tử cụm dock khác
  (AutoHide.m:96–100). Icon YouTube là
  cell SBIconView thuộc nhánh dockView —
  tổ tiên chung gần nhất với homeButton là
  dock host; opacity chỉ lan xuống cây con
  của view bị sơn, không lan sang nhánh
  anh em.
- Tầng log: cửa sổ có `17:41:07.153
  [autohide] fade last=home idle=4.00` sát
  mốc mất, nhưng dòng reveal tương ứng
  (`17:41:00.359 reveal-applied
  reason=activity views=5`) **không kéo
  theo bất kỳ dòng [homelib] / apply /
  re-layout dock nào**. [homelib] cho
  youtube trong cửa sổ chỉ có **inject**
  (`17:42:37.339 decision=inject
  bundle=com.google.ios.youtube`); toàn
  phiên dòng remove = 0. Theo đúng tiêu
  chí kết án của biên bản nguồn → ghi
  CHƯA PHÂN ĐỊNH ở tầng cell dashboard.
  Đường apply cũng mù với app injected:
  apply-published không đọc được presence
  của app injected (SCPHomeApply.m:319–325)
  — cùng họ mù với live-grid-read ở ytz3.
  Phần "icon hiện lại khi reveal" được ghi
  là **đang giả định**: dashboard tự
  layout lại cây dock khi trạng thái
  hiện/ẩn đổi — log không ghi trực tiếp.

**Tầng 2 — sau thoát Home (mất hẳn ngoài
Home, như các lần Nguyen đã báo): tương
quan đường thoát ĐÃ KHỚP LOG; bước
dashboard làm rớt cell CHƯA chứng minh.**

- Nguyen tự phân định bằng A/B trên xe
  (lời anh, ngoài log): logo chưa ẩn mà
  thoát Home thì icon còn; logo đã ẩn rồi
  thoát Home thì mất icon. Cặp A/B gốc
  ~17:48 nằm NGOÀI log (log hết 17:44:31)
  — mắt 17:48 là NO DATA trong log, chỉ có
  lời Nguyen. Phép phân loại áp trên **11
  sự kiện thoát trong log**: lớp ĐÃ MỜ 5,
  lớp HIỆN 6; sự kiện mất icon 17:44 thuộc
  lớp ĐÃ MỜ.
- Đối chiếu trường goHome (bổ sung
  probe-exit-fade): **ĐÃ MỜ ⇒ goHome=NO đủ
  5/5**, gồm đúng sự kiện mất icon:
  `2026-11-09 17:44:20.347 [CarPlay:36168]
  SplitScreen: CarSplit: tat split
  (goHome=0)` (fade gần nhất
  17:44:00.030). Cả 2 lần goHome=1 toàn
  phiên đều thuộc lớp HIỆN (17:35:47.890
  và 17:36:03.968, đều PID 35998, sát
  reveal trước đó). Chiều ngược KHÔNG
  tuyệt đối: 4/6 lần thoát lớp HIỆN vẫn
  goHome=0 (thoát bằng sự kiện
  Home/dismiss khi đang hiện). Phát biểu
  đúng mức bằng chứng: **YES ⇒ đang HIỆN
  (2/2); ĐÃ MỜ ⇒ NO (5/5); 0 phản ví dụ ở
  hai chiều quyết định.**
- Cơ chế khớp (probe-exit-fade, source):
  không quyết định nào trên đường thoát
  đọc trạng thái mờ; khôi phục sơn vắng
  mặt khỏi đường thoát (chỉ có ở reveal +
  ngắt kết nối); bất đối xứng tweak-side
  duy nhất là `SCPSendDashboardEvent(1)`
  chỉ gửi khi closeGoingHome:YES
  (SCPCarSplit.m:1771) — đường goHome=NO
  không gửi. Log khớp cơ chế hạng 1 này.
  Nhưng bước cụ thể phía dashboard làm
  rớt cell, và event-1 là NGUYÊN NHÂN hay
  chỉ là DẤU HIỆU của đường đi — còn mở,
  chưa chứng minh.
- Họ thư viện **KHÔNG bị kết án** ở tầng
  2: youtube có **0 chuyển trạng thái
  1→0** toàn phiên; decision cuối của
  phiên vẫn là inject
  (17:43:41.217).
- Phát hiện phụ, KHÔNG kết án là nguyên
  nhân icon: `ahFadedState` rò sang phiên
  sau (không reset ở ahSessionStarted;
  thoát lúc mờ để ahFaded=YES kẹt tới
  reveal/teardown kế). Khiếm khuyết riêng
  đã định danh, bán kính chỉ tới chrome
  (homeButton/handle, fadedEffective của
  BridgeWake) — sửa độc lập khi GPT duyệt
  (§28.12 mục 4).

### 28.10 Weather / knob: NO DATA lần thứ
ba liên tiếp

- Weather: req# = 0 — vẫn không có request
  thật nào; 5 chu kỳ warming-cache updated
  5/5 HTTP 200 (`[weather] source=warming-
  cache (internal startup call, NOT a
  CarPlay request)`). Chuỗi request→
  answer→display vẫn PENDING.
- Knob: payload = 0; 69 dòng chứa "knob"
  toàn là sổ fade (applied ×36 / restored
  ×31). Vẫn cần GPT phán: instrument hay
  nghiệm thu bằng mắt (§28.12 mục 5).

### 28.11 Hai thay đổi theo LỆNH TRỰC TIẾP
của Nguyen — chờ gộp vào deb sau

Phát sinh giữa phiên, không thuộc WO của
vòng ytz4; ghi lại để gộp vào deb tiếp
theo (quy tắc một deb), không giao lẻ:

- **(i) Bảng chọn app — nội dung ô đích
  phải vẫn hiện.** Nguyen (17:30): mở menu
  chọn app thì nội dung bên dưới phải vẫn
  hiện như phía ô còn lại. Điều tra nguồn
  (probe-picker-cover): vùng trắng ở ô
  đích là `pane.picker` — UIView đặc phủ
  toàn bộ ô, tạo vô điều kiện khi bấm
  "Đổi app" (SCPCarSplit+Picker.m:170–176,
  màu rgb 0.9333/0.9412/0.9843, alpha 1.0)
  trải trên pane.host; ô còn lại không có
  placeholder nên hiện nguyên — tính chất
  theo SLOT ĐÍCH, không theo loại app;
  scene bên dưới vẫn render (đóng X là
  app về nguyên vẹn). **Gốc 1.0.3 cũng
  trắng y hệt** (hằng màu trong disasm
  tại 0x315f4, method VERIFIED) — lệnh
  này là customisation VƯỢT gốc theo ý
  Nguyen, không phải sửa lỗi tái tạo.
  Sửa tối thiểu đã xác định: tại điểm tạo
  duy nhất Picker.m:171–176, ô đang có
  app (`pane.vc != nil || slotOccupied`)
  thì đặt `backgroundColor = clearColor`;
  ô trống giữ nền đặc. Ràng buộc cứng:
  đối tượng placeholder VẪN PHẢI ĐƯỢC TẠO
  (refreshPickerSheet loại ô có
  picker == nil khỏi vai sheet-pane — bỏ
  hẳn là sheet không mở). Đã rà rủi ro:
  chạm không xuyên (view nền trong vẫn
  hit-test + giữ tap recognizer); vị từ
  popup của guard fullscreen không đọc
  pane.picker nên không lệch nghiệm thu
  §28.1.
- **(ii) Log khung phím tại lúc show.**
  Hiện KHÔNG dòng log nào ghi rect của
  panel hay carAppArea (đã grep khẳng
  định; dòng hiện phím chỉ ghi bundle/
  kiểu/enter). Cộng đúng 1 dòng log tại
  điểm layout của ABKeyboard ghi
  carAppArea + panel frame — để lần xuất
  hiện kế của hiện tượng "phím nhỏ lệch"
  (ảnh 2, §28.6) kết án được tầng input
  thay vì chỉ tầng che khuất.

### 28.12 Việc còn mở (chờ GPT / phiên sau)
+ trạng thái

Năm mục từ bản đối hoà phiên, nguyên thứ
tự: (1) **Gate 3** — còn đúng 3 mắt NO
DATA của §28.4; kịch bản phiên sau phải
ÉP ba mắt: chạm MỘT lần vào vùng app
trong lúc phím đang mở + controls ẩn; gõ
vài chữ; đóng phím rồi chạm lại trên
cùng assignment. Ngoài 3 mắt đó, mọi
điều kiện tiên quyết (kb transport §28.3,
would dương §28.3, feed native §28.5,
freshness W2 §28.5) đều đã có số đạt.
(2) **Icon** — tầng 1 (§28.9) và bước
dashboard ở tầng 2: cần instrument phía
cell/apply cho app injected (apply hiện
mù với injected) hoặc chấp nhận mức
tương quan đường-thoát hiện có.
(3) **Pinch** — hiệu chuẩn đánh dấu chưa
được thực hiện (§28.7) nên kiến trúc vẫn
chưa quyết được. (4) **ahFadedState rò
phiên** (§28.9) — khiếm khuyết riêng đã
định danh, chờ duyệt sửa. (5) **Weather/
knob** (§28.10) — NO DATA ba phiên liên
tiếp; cần quyết định instrument hay bỏ
tiêu chí.

- Vẫn mở từ §27.5 (chờ GPT): consumer
  `appbridge.keyboard` thứ hai chết trong
  thực tế ở ABChannels.m:358 (dọn/giữ);
  biên reset UNKNOWN khi gán lại cùng
  bundle cùng slot (đóng ở owner hay chấp
  nhận giảm nhẹ). Cộng khoảng trống
  instrument mới ghi nhận ở §28.3: reset
  UNKNOWN khi đổi gán là reset câm, không
  dòng log riêng.
- **Mức đạt của phiên: DEVICE PASS** ở FS
  + guard ngược, fade-EXPANDED, kb
  transport, wouldSwallow mức would, feed
  native, YTZ. **NO DATA:** chuỗi
  suppression trọn (3 mắt), OFF control
  YTZ, pinch/hiệu chuẩn, weather, knob,
  nguyên nhân chuyển PID. **CHƯA PHÂN
  ĐỊNH:** icon tầng 1 (cell dashboard) +
  bước dashboard ở tầng 2. **Gate 3 vẫn
  ĐÓNG** (chờ 3 mắt §28.4 + GPT phán);
  ENFORCE pinch vẫn khoá. ytz4 vẫn là bản
  nghiệm thu hiện hành; QA20 vẫn là bản
  dùng hằng ngày; ytz1 vẫn CÁCH LY;
  VISUAL_ORIGINAL_COMPARISON = PENDING.

## 29) VÒNG YTZ5 — SAU PHIÊN YTZ4: LỆNH NGUYEN, WORK ORDER GPT, BẢN ĐỒ PHA 1, PHÁN QUYẾT W1(c) (2026-11-09) — THI CÔNG + BUILD XONG (29.7); ĐÃ GHÉP HOME LAUNCHER CỦA GPT + DEB TỔNG HỢP FAT XONG (29.9)

Mục này mở đầu ngay trong ngày để lịch sử không đứt quãng (lệnh hồ sơ
19:00–19:05, xem 29.8): ghi các quyết định/lệnh/phán quyết/bản đồ đã chốt.
Phần thi công (29.7) ĐÃ bổ sung trong cùng đợt push với commit nguồn
ytz5: candidate local đã có SHA; CI + DEB tổng hợp hoãn theo phân
công tích hợp GPT 19:15 (xem khối TÍCH HỢP ở 29.7).

### 29.0 Bảng mốc vòng ytz5 (nhãn verdict tường minh)

| Mốc | Trạng thái |
|---|---|
| Dữ kiện phiên ytz4 do Nguyen tự đo (picker trắng 17:27, đóng-X 17:28, A/B thoát Home 17:48) | DỮ KIỆN GỐC ĐÃ GHI (29.1) — verdict đối chiếu log ở §28 |
| Lệnh Nguyen: picker — nội dung ô đích hiện xuyên (17:30) | ĐÃ CHỐT — vào gói ytz5 |
| Lệnh Nguyen: bỏ phím tự vẽ ở mọi app, về phím gốc (18:01) | ĐÃ CHỐT — vào gói ytz5 (code phím vẽ giữ nguyên) |
| Bản thảo Muse → GPT: lỗi L1–L7 + phương án (18:02) | ĐÃ GỬI TRONG CHAT |
| Work order GPT 7 mục + nghiệm thu 6 bước (18:10) | ĐÃ NHẬN — GO |
| ĐẶC TẢ THI CÔNG của GPT (18:13) | ĐÃ NHẬN — ràng buộc thi công |
| Bản đồ thay đổi Pha 1 (18:21) | XONG (CHANGE_MAP_YTZ5.md + map-m1..m5) |
| Điểm vướng W1 + W3 + W5 | ĐÃ BÁO TRƯỚC BUILD |
| Phán quyết GPT: W1(c) + pinch OFF (18:45) | ĐÃ CHỐT — GO thi công |
| Thi công ytz5 (4 strand) | XONG — commit nguồn đi cùng đợt push này (29.7) |
| Harness 4 ca cấu trúc + kiểm tĩnh | XONG — harness 24/24 PASS; kiểm tĩnh PASS mọi cổng trừ parity: mất đúng 1 method là THAY THẾ CÓ CHỦ ĐÍCH theo hợp đồng (29.7) — chờ GPT miễn trừ |
| Build candidate + CI FAT + ghép Home launcher | ĐÃ XONG (29.9) — ghép tip GPT `050eddb0` (merge `c74c878`, 0 xung đột) + staging project `74635d1` + fix nullability tích hợp `8a2c7aa`; CI run dispatch **42622552103** SUCCESS; DEB tổng hợp duy nhất (ytz5hl1) FAT 1.245.714 B, SHA-256 `e28883b9…`. Candidate local ytz5 riêng: 1.036.636 B `2d1cf435…` (29.7) |
| Phiên xe nghiệm thu 6 bước | ĐÃ ĐỐI CHIẾU LOG (29.12): bước 1 icon Home ĐẠT tầng log (11 chạm routed; model NO-DATA); bước 2 vòng đời AutoHide ĐẠT; bước 3 picker **THẤT BẠI** — nhánh (b), lớp phủ khác placeholder (nghi phạm pane.cover/shield); bước 4 phím gốc hosted **THẤT BẠI** — nhánh (i), phím hệ thống không dựng trên màn xe, bridge vô tội; bước 5 reveal ĐẠT + Gate 3 có 4 ca would=1 sạch; bước 6 A/B icon ĐẠT một phần (model NO-DATA) |
| Wake ENFORCE (Gate 3) | VẪN KHOÁ — Nguyen nâng thành vấn đề 20:37; Muse đề xuất bật cho app hosted ở bản sau (29.10a) — chờ Nguyen chốt lệnh + GPT tham vấn (ngược phán quyết hiện hành) |
| Pinch recognizer trong app hosted | MỚI LẬP LẠI 20:39 (29.10b) — ĐÍNH CHÍNH: pinch đã thành công ở bản 21–35; số touchset "trùng" là artefact vị trí đo; kế hoạch recognizer ABInApp → host → FS controller, chờ GPT phán điểm giao tiếp |
| Vòng hl2 (K6/P6/W6/G6/F6 + dock-retirement) | ĐÃ XONG source/static/build/CI (29.13) — HEAD `76538c2`; CI `42637337416` SUCCESS; FAT hl2 1.252.660 B, SHA-256 `9250ea01…`; phiên xe: CHƯA |
| Vòng hl3 (khoá cứng phím native — lệnh Nguyen 22:14 ghi đè GPT) | SOURCE/STATIC/LOCAL BUILD PASS (29.14) — commit `5eac902`; ĐÓNG GÓI GIỮ LẠI chờ gộp fix pinch/Gate-3 theo log hl2 (29.15); FAT: CHƯA |

### 29.1 Diễn biến trong phiên ytz4 sau khi kịch bản được giao (17:20–17:48)

Dữ kiện gốc của Nguyen, tách khỏi verdict §28 (verdict lấy từ log; các
mốc dưới đây là hành động/quan sát của anh dẫn tới các quyết định):

- 17:20–17:31 làm rõ kịch bản: anh hỏi "test mấy cái đó làm j vậy?",
  "Picker là cái j", "ca guard ngược (bắt buộc) này là j" — kịch bản
  ban đầu dùng jargon (picker/guard) thay vì tên nút trên màn. Hệ quả
  quy trình: kịch bản xe từ nay viết bằng tên nút/thứ nhìn thấy được.
  Phân loại lại cho anh: mục 1/3/5 chỉ cần dùng bình thường (log tự
  ghi); chỉ ca guard ngược (10 giây) và hiệu chuẩn pinch là việc chủ
  động. [BỐI CẢNH — đã xử lý trong phiên]
- 17:27 ảnh: mở bảng chọn app cho ô 1 (YouTube hosted) → ô đích trắng
  trơn quanh bảng, ô phải GOFA vẫn hiện. 17:28 phép phân định của
  Nguyen: đóng dấu X (không chọn app) → app quay lại nguyên vẹn ngay
  → kết luận tại chỗ: chỉ bị CHE, scene không bị tháo. Điều tra nguồn
  ngay sau đó (probe-picker-cover, tóm tắt §28.11): vùng trắng =
  `pane.picker` UIView đặc phủ toàn ô đích (Picker.m:170–176); gốc
  1.0.3 cũng trắng (hằng màu tại disasm 0x315f4, method VERIFIED).
  [DỮ KIỆN XE + ĐIỀU TRA NGUỒN — XONG]
- 17:30 LỆNH: nội dung ô đích phải vẫn hiện như phía còn lại khi mở
  menu chọn app (chi tiết ở 29.2 cùng nhóm lệnh bàn phím).
- 17:32–17:33 ba ảnh bàn phím lúc tìm kiếm YouTube + chất vấn: mỗi
  app một giao diện phím; phím bị bó không theo tỉ lệ chia ô; "càng
  làm càng gây lỗi". Số đo từ log đã ở §28.6 (ảnh 3 = che khuất
  z-order). Đính chính ghi vào hồ sơ: Muse từng nói "log ghi khung
  phím" — SAI, không dòng nào ghi rect panel/carAppArea (grep khẳng
  định); muốn kết án nguồn số phải cộng log khung tại show.
- 17:35 chất vấn: phím tự vẽ là của solo — trong giao diện chia có
  dùng phím vẽ không? Điều tra probe-kb-frame: ABKeyboard là MỘT
  đường duy nhất của ABHost cho mọi app hosted (solo = chia ô);
  SCPCarSplit không có đường phím riêng; ABInApp không rẽ nhánh theo
  split trên đường phím; khung panel tính từ carAppArea toàn bề mặt
  split tại thời điểm show rồi đóng băng. [ĐIỀU TRA NGUỒN — XONG]
- 17:41–17:42 báo mất icon YouTube trên thanh dock (khác các lần
  trước: lần này là app hosted/được chọn, không phải app hệ thống).
  17:44 quan sát trực tiếp: ẩn logo thì ẩn luôn icon; gọi lại logo
  thì icon hiện lại. 17:48 PHÉP A/B DO NGUYEN TỰ ĐO: thoát Home lúc
  logo CHƯA ẩn → còn icon bên ngoài; thoát lúc ĐÃ ẩn → mất icon.
  Đây là biến phân định của vụ icon; đối chiếu log ở §28.9 (lớp ĐÃ
  MỜ ⇒ goHome=NO 5/5). [DỮ KIỆN GỐC — verdict §28.9]

### 29.2 Thảo luận thiết kế bàn phím (17:58–18:00) [ĐÃ BỊ THAY THẾ] + Lệnh 18:01 [ĐÃ CHỐT]

Trước lệnh chốt, Muse trình hai lựa chọn cho phím tự vẽ trong split:
(a) bám theo ô của app đang gõ (khuyến nghị của Muse); (b) giữ
nguyên gốc — phím trải đáy cả hai ô. Kèm hai trả lời kỹ thuật cho
Nguyen: (1) app native KHÔNG nhận phím vẽ được — cơ chế phím vẽ cần
hợp đồng ba việc trong tiến trình app (tự tắt phím hệ thống, báo
phiên nhập, nhận ký tự chèn vào ô chữ); app native không chạy thành
phần trong-app, ô tìm kiếm của nó thuộc template hệ thống CarPlay
nên phím do tiến trình template host vẽ trong scene của nó; ép phím
vẽ vào native là hạng mục khác hẳn kiến trúc này, gốc cũng không
làm. (2) Phím tự vẽ THU NHỎ ĐƯỢC: chiều cao = 78% chiều cao cửa sổ
xe, trần 280 (layoutPanelIn:, ABKeyboard.m:561–576); bề rộng = vùng
trừ 12, sàn 200; các hàng phím tự co theo khung.

18:01 NGUYEN CHỐT THAY THẾ TOÀN BỘ THẢO LUẬN TRÊN: "ko vẽ phím ở
bất kỳ app nào cả — cho nó về phím gốc của CarPlay; dữ liệu vẽ phím
vẫn lưu lại khi cần". Tức: bỏ panel tự vẽ ở MỌI app (hosted lẫn
native vốn đã phím hệ thống), mọi app gõ bằng phím hệ thống trong
scene của chính nó; code/dữ liệu phím vẽ GIỮ NGUYÊN trong cây làm
đường lui. Hệ quả đã nêu cho Nguyen ngay lúc đó: nguồn bằng chứng
kb của Gate 3 thay đổi — phiên phím host qua ABKeyboardDispatch sẽ
câm, chỉ còn bằng chứng first-responder phía app (điểm này thành
điểm vướng W1 ở 29.5). Câu hỏi bám-ô/giữ-gốc và widget lựa chọn đi
kèm bị thay thế hoàn toàn, không còn hiệu lực.

### 29.3 Bản thảo Muse gửi GPT (18:02) [ĐÃ GỬI TRONG CHAT]

Cấu trúc (không chép toàn văn — bản thảo giao trong chat theo quy
tắc đã chốt): kết quả phiên ytz4 tóm tắt (PASS: FS + guard ngược,
fade-EXPANDED, kb transport, wouldSwallow ×8, feed native, YTZ;
NO DATA: chuỗi suppression 3 mắt, pinch, weather/knob) + danh sách
lỗi L1–L7 kèm phương án của Muse: L1 mất icon hai tầng (đề xuất
gửi event-1 cả hai đường thoát — bị GPT STOP ở 29.4); L2
`ahFadedState` rò phiên (reset tại session start); L3 bỏ phím vẽ
(lệnh Nguyen — tắt tại hai funnel, giữ code, kèm cảnh báo nguồn kb
đổi + rủi ro phím hosted có hiện đúng trên màn xe không); L4 tấm
nền picker (lệnh Nguyen — clearColor khi ô có app); L5 pinch
(GPT chọn park hoặc hiệu chuẩn riêng); L6 weather/knob (bỏ tiêu
chí hoặc kịch bản bắt buộc); L7 hai lệch phụ §27.5 + gói deb gộp
đề xuất + 5 câu hỏi cho GPT.

### 29.4 Work order GPT (18:10) + ĐẶC TẢ THI CÔNG (18:13) [ĐÃ NHẬN — GO kèm đặc tả]

Work order: MỘT gói sửa tổng hợp trên nền ytz4; Wake ENFORCE chưa
bật mặc định. 7 mục: (1) vòng đời AutoHide bắt buộc — đóng split:
dừng timer, khôi phục toàn bộ view đã sơn TRƯỚC khi tháo view, xoá
trạng thái faded/kb-hold/suspended của phiên; mở phiên: controls
hiện, trạng thái sạch, idle 4 s mới; cleanup gọi lặp vẫn an toàn;
giữ AutoHide trong EXPANDED + khoá popup/dragging. (2) Bỏ phím vẽ
theo lệnh Nguyen kèm sửa nguồn kb: một cổng thống nhất tắt cả ba
việc (thay inputView bằng view rỗng / yêu cầu mở phím vẽ từ app /
hiện panel phía host); giữ code cũ làm đường lui; khi chuyển chế độ
đóng panel còn sống + phục hồi chỉ inputView tweak đã thay; KHÔNG
mặc định bỏ suppress là có ngay phím CarPlay chuẩn — phải kiểm phím
hosted hiện ở màn nào, gõ được, đóng được; giữ tracking
first-responder + kb ba mức; không dùng "panel đang tắt" làm bằng
chứng "không có phím hệ thống". (3) Nối nguồn kb vào AutoHide —
lỗi ĐÃ CÓ BẰNG CHỨNG: log 17:32:24.192 owner biết phím ACTIVE
nhưng 17:32:28.079 controls vẫn mờ, vì khoá AutoHide còn phụ thuộc
gói act; sửa để AutoHide đọc nguồn kb đã xác thực của assignment
đang sống; reset UNKNOWN theo vòng đời assignment kể cả gán lại
cùng bundle/cùng slot. (4) Picker GO theo bản đồ. (5) Icon: chỉ
instrument đúng tầng; STOP gửi SCPSendDashboardEvent(1) vô điều
kiện ở đường goHome=NO; sửa vòng đời AutoHide trước rồi lặp A/B.
(6) Consumer phím cũ: trong chế độ tắt phải bảo đảm không còn tác
động; không sửa packing để vô tình kích hoạt lại đường hide cũ.
(7) Giữ ổn định: ngữ nghĩa fullscreen, guard popup, YTZ, native
feed (không mở rộng sang nuốt touch native); pinch park OFF ghi
chưa nghiệm thu; weather/knob giữ PENDING không chặn gói UI.
Nghiệm thu MỘT phiên đúng thứ tự 6 bước (vòng đời AutoHide → picker
→ phím hosted + giữ controls khi nhập → đường đánh thức sau đóng
phím → A/B icon với instrument cell → hồi quy nhanh; tiện thì
splash + núm). Bàn giao: một DEB + SHA-256 + commit nguồn + danh
sách file đổi + kết quả kiểm tĩnh + kịch bản xe ngắn; báo cáo tách
thế hệ binary, phân biệt đã sửa source / đã chứng minh trên xe /
còn thiếu dữ kiện.

Đặc tả thi công (18:13) siết thêm: lập BẢN ĐỒ THAY ĐỔI trước khi
sửa (hàm hiện tại → nguyên nhân → hàm sẽ sửa → trạng thái trước/sau
→ cách kiểm tra; file:line từ HEAD thật); AutoHide sửa bằng cleanup
vòng đời, không chỉ reset BOOL (đường đóng cleanup khi view cũ còn
truy cập được; không gọi đường reveal thường nếu nó phát frame/arm
timer cho phiên đang đóng; không đổi thứ tự điều hướng Home); bàn
phím tách quyết định sản phẩm khỏi tính khả thi — truy đủ 4 tuyến
(inputView / yêu cầu từ app / host hiện-ẩn panel / FR tracking +
kb-sync) trước khi sửa, một cổng thống nhất app+host, tắt panel
không tắt tracking, panel tắt ≠ kb INACTIVE, và PHẢI BÁO TRƯỚC
BUILD: phím hosted dự kiến hiện ở màn nào + căn cứ source + điểm
chỉ kiểm được trên xe (không đủ căn cứ thì ghi "thay đổi cần nghiệm
thu", không gọi "đã về phím CarPlay gốc"); AutoHide dùng CÙNG sự
thật kb (không BOOL toàn cục — đóng phiên của app A không xoá hold
của app B; đọc lại BWKbEffective: local INACTIVE hiện chưa tự thay
được owner snapshot — không chỉ đổi nhãn kbSrc); picker chỉ thay
lớp nền tại điểm tạo; icon vòng này chỉ đo + sửa lỗi vòng đời đã
chứng minh (instrument cell tại cây dock/lưới đang sống; tách 3
trạng thái: không tìm được đối tượng / tìm được nhưng icon vắng /
icon có trong model nhưng cell ẩn-tháo; count=0 của reader không
hợp lệ không phải bằng chứng; "không có remove" không chứng minh
toàn bộ thư viện vô tội); cổng trước build (hai cây khớp, không
ngoài phạm vi, YTZ/feed/guard giữ nguyên, ENFORCE khoá, pinch OFF,
kết luận ghi riêng source-proven / device-proven / pending). GPT
sửa một điểm trong chính work order trước: KHÔNG giao thẳng cách
nối nguồn kb mới khi chưa xác định nó có quan sát được bàn phím
hosted thực tế hay không.

### 29.5 Bản đồ thay đổi Pha 1 (18:21) [XONG] + điểm vướng [ĐÃ BÁO TRƯỚC BUILD]

Tài liệu: CHANGE_MAP_YTZ5.md (đối hoà) + map-m1-autohide /
map-m2-keyboard / map-m3-autohide-kb / map-m4-picker / map-m5-icon
ở handover/reports/; tóm tắt từng biên bản ở INDEX.md của reports.
Phát hiện chính: M1 — `closeGoingHome:` (SCPCarSplit.m:1732–1774)
không gọi cleanup AutoHide ở đâu; `ahSessionTeardown` chỉ có caller
`dashboardInvalidated` (:288); điểm chèn đúng: sau guard :1733,
trước `hostCloseAll` :1737; cấm `ahRevealBody:` trên đường đóng (7
tác dụng phụ gồm arm lại timer :270); teardown thiếu reset
`ahKbHoldExpiry`; bẫy solo: `soloBundle:` đặt suspended=YES (:2019)
TRƯỚC khi đóng. M2 — toàn cây đúng 3 điểm `setInputView:`; marker
sở hữu `ABBlankInputViewKey` (ABInApp.m:1718) ĐÃ có → phục hồi
chọn lọc khả thi; consumer ABChannels.m:358 chết kép (`#if 0` :219
+ giải hash sai); `BWKbEffective` (:465–485) chốt: local INACTIVE
không tự thắng owner snapshot; ngưỡng tươi 3,5 s (:432). M3 — điểm
đứt ca 17:32: owner ghi bản ghi kb theo slot (BridgeWake.m:323–325)
nhưng `ahFadeBlockedReason` (AutoHide.m:140–157) chỉ đọc
`ahKbHoldState/ahKbHoldExpiry` TOÀN CỤC (grep `bwKb` trong
AutoHide = 0); act flag=0 của app A xoá vô điều kiện hold của app
B (:254–255, một bit gộp UNKNOWN≡INACTIVE≡0); gen chỉ tăng khi
chuỗi bundle đổi (:470–472); chân host→owner của kb-sync không
mang gen — gói trễ ghi đè phiên mới. M4 — hasContent phải chụp sau
Picker.m:161, trước :162–163 (`slotOccupied:` tự đọc `pane.picker`
:475 → chụp tại :171 luôn YES oan). M5 — reader cũ mù vì đi
`connectedScenes→windows` (SCPCarApps.m:116–127); đường đúng là
home VC yếu + publish walk (SCPHomeApply.m:255–263); CELL của đúng
bundle không đọc được ở cả 3 mốc (không đường model→cell trong
cây); `src=` phải gắn tại 12 điểm gọi close.

Khả thi bàn phím (tách 3 loại, giữ nguyên khi báo GPT):
SOURCE-PROVEN — gốc chỉ suppress inputView, không đụng keyboard
window/notifications; phục hồi có marker sở hữu. SUY LUẬN CÓ CĂN
CỨ — scene lấy qua `mainDisplaySceneManager` (ABHostBMethods.m:1624)
nên phím hệ thống dự kiến hiện MÀN XE trong khung pane. CHỈ-XE-
MỚI-BIẾT — iOS có dựng phím cho scene host chéo display không,
hình học, chạm; host/owner mù về phím hệ thống của app hosted.
Kết luận của bản đồ: đây là thay đổi CẦN NGHIỆM THU, không gọi là
"đã về phím CarPlay gốc".

ĐIỂM VƯỚNG TRUNG TÂM W1: sửa cổng fade (M3) và tắt panel (M2) đều
làm được độc lập, nhưng tắt panel thì nguồn duy nhất nuôi bản ghi
kb của owner (funnel vòng đời panel) chết theo; trong cây chưa có
nguồn quan sát phím hệ thống chảy vào owner. Build ngay theo đặc
tả thì kb = UNKNOWN → AutoHide fail-open → bước 3 kịch bản nghiệm
thu ("phím mở quá 4 giây controls vẫn hiện") KHÔNG THỂ ĐẠT theo
cấu trúc. Ba hướng trình GPT: (a) đo khả thi nguồn mới trước,
hoãn gói; (b) build với UNKNOWN tường minh + sửa kịch bản; (c)
duyệt thiết kế vận chuyển FR app→owner. Kèm W2 (kiểm gen ở handler
kb-sync phải đi cùng M3), W3 (pinch trong source vắng-pref =
DRY_RUN, khác chữ OFF của work order — cần chốt default), W5 (M5
đạt trần model/dock, cell vẫn mù — không coi là đã tìm được điểm
làm cell mất). Cổng trước build đã kiểm thực tế: hai cây khớp
13/14 file byte-identical (`SCPHomeApply.m` lệch đúng 1 dòng
import :18, 332 dòng hai phía, không khác code); ENFORCE khoá mặc
định hai phía (BridgeWake.m:47–48, ABInApp.m:131–132; nuốt chỉ khi
mode == Enforce :773); SCPCarSplit.m bị M1+M5 cùng chạm ở hai vùng
khác nhau (diff riêng từng hunk); ABChannels.m và ABKeyboard.m
không sửa; YTZ/native feed/guard fullscreen không giao cắt điểm
sửa nào.

### 29.6 Phán quyết của GPT (18:45) [ĐÃ CHỐT — GO thi công, không cần xin lại]

Chọn W1(c): duyệt VẬN CHUYỂN TRẠNG THÁI PHIÊN NHẬP LIỆU từ app về
owner. GPT nhấn mạnh hai việc phải ghi và nghiệm thu RIÊNG:
first-responder chứng minh PHIÊN NHẬP LIỆU, chưa chứng minh bàn
phím hệ thống thực sự hiện trên màn xe. Thiết kế bắt buộc: bản ghi
theo từng assignment gồm bundle/hash + assignment generation +
source session + sequence + UNKNOWN/INACTIVE/ACTIVE. Luật: app
báo ACTIVE chỉ SAU khi xác nhận nhận focus nhập liệu thành công
(không báo chỉ vì đã gọi becomeFirstResponder); chuyển focus giữa
hai ô nhập trong cùng app KHÔNG tạo khoảng INACTIVE giả (responder
cũ resign → kiểm tra responder hiện hành trước khi chốt đóng
phiên); INACTIVE chỉ từ xác nhận không còn phiên nhập trong phạm
vi theo dõi đã xác thực (không suy từ chưa từng thấy begin); không
dữ kiện / tracking không bao phủ / mất đồng bộ → UNKNOWN; KHÔNG
log nội dung người dùng gõ; giữ observer bàn phím làm bằng chứng
bổ sung, sự tồn tại của keyboard window không phải bằng chứng
ACTIVE. W2 khép cả đường đi: owner cấp danh tính assignment hiện
hành, app nhận và echo đúng danh tính đó; đóng rồi mở lại cùng
bundle/cùng slot tạo generation MỚI; owner loại gói sai
assignment/gen, sai source session, sequence cũ — và log reason;
thay assignment/teardown → xoá bản ghi cũ về UNKNOWN; snapshot ban
đầu + yêu cầu đồng bộ lại có đường rõ ràng; ĐẶC BIỆT owner không
phát lại snapshot cũ mỗi giây khiến app tưởng nguồn còn tươi — độ
tươi theo dõi theo BÁO CÁO NGUỒN, tách khỏi thời điểm chuyển tiếp,
nguồn hết hạn → UNKNOWN. M2 sửa câu của bản đồ: khi tắt phím vẽ —
đóng panel + vô hiệu NGUỒN host-panel; KHÔNG dùng sự kiện đóng
panel để kết luận phiên nhập của app đã kết thúc (app còn focus
thì nguồn mới tiếp tục ACTIVE; nguồn panel cũ không ghi đè nguồn
nhập liệu mới); cổng `appBridgeNativeKeyboard` dùng được NHƯNG app
nhận cấu hình QUA BRIDGE hiện có, không phụ thuộc đọc trực tiếp
CFPreferences trong app App Store (tránh lặp lỗi quyền đọc prefs
trước đây). M3: cổng fade tổng hợp các assignment hosted đang
sống; phiên ACTIVE hợp lệ → giữ controls; app A đóng phiên không
xoá hold của app B; phiên ACTIVE cuối cùng kết thúc → idle 4 s
mới; flag act chỉ còn phục vụ activity/chẩn đoán, không tự đặt/xoá
sự thật nhập liệu; UNKNOWN tách hành vi rõ: suppression cho touch
đi qua, AutoHide KHÔNG coi UNKNOWN là xác nhận "không nhập liệu" —
trong gói nghiệm thu này UNKNOWN của assignment hosted GIỮ
controls hiện + ghi lý do. M1 duyệt cleanup (chèn trước khi tháo
view; reset cả expiry + danh sách sơn của phiên cũ) và xử lý đúng
hosted-solo: KHÔNG giữ suspended cũ để né bẫy — dọn trạng thái
phiên split rồi đặt suspend theo CHẾ ĐỘ ĐÍCH (chuyển sang
hosted-solo thì solo chủ động đặt suspend; kiểm thứ tự gọi để
cleanup không xoá trạng thái solo vừa đặt); không gọi
ahRevealBody: trên đường đóng. M4 GO (chụp trạng thái ô trước khi
tạo placeholder như bản đồ; bắt buộc kiểm ô trống vẫn nền đặc).
M5 GO ở tầng model/dock (chưa đọc được cell thì log PRESENT-MODEL
/ ABSENT-MODEL / BLIND, không ghi PRESENT-CELL; gắn src= các điểm
close; chưa thêm event-1 vào đường NO). Pinch: vắng pref → OFF;
gói nghiệm thu bảo đảm giá trị DRY_RUN lưu cũ không âm thầm giữ
pinch (nêu cách áp cấu hình test, không tự xoá toàn bộ prefs).
Consumer trong `#if 0`: giữ nguyên, không sửa packing. Cổng trước
build: Muse tự kiểm và bàn giao BẰNG CHỨNG cho 4 ca cấu trúc —
(1) chuyển responder A→B trong cùng app không hạ ACTIVE sai;
(2) hai app cùng phiên nhập, đóng một app không giải hold app kia;
(3) gán lại cùng bundle/slot, gói phiên cũ bị loại; (4) mất nguồn
báo cáo → UNKNOWN, không "gia hạn giả" bằng owner renewal. Nếu
tracking không bao phủ được một kiểu nhập liệu: giữ UNKNOWN và
khai đúng giới hạn, không biến thiếu quan sát thành INACTIVE để
vượt Gate 3.

### 29.7 Thi công [XONG — BUILD XONG; DEB TỔNG HỢP HOÃN THEO PHÂN CÔNG 19:15, XEM KHỐI TÍCH HỢP]

Bốn strand song song (file không giao nhau) + tích hợp + harness +
kiểm tĩnh độc lập. Biên bản: fix-ytz5-k5.md, fix-ytz5-b5.md,
fix-ytz5-p5.md, fix-ytz5-i5.md, build-ytz5.md, verify-ytz5.md
(handover/reports/). Nguồn đi cùng commit của mục này.

**Diff tóm tắt:** 13 file tracked (+1049/−135) + 2 file mới
(`SplitScreenC/BWInputStore.h`, `SplitScreenC/SCPHomeApply.h`).
Phạm vi đúng bản đồ §4 của CHANGE_MAP — kiểm tĩnh xác nhận 0 file
ngoài phạm vi.

- **K5 (AppBridge — cổng phím + reporter):** điểm đọc pref duy nhất
  phía host `ABNativeKeyboardEnabled()` (ABHostBMethods.m:64): vắng/
  =1 → native, =0 → drawn. App KHÔNG đọc CFPreferences (grep 0):
  nhận cổng qua trường `drawnKeyboard` trong payload host→app
  (`ABPostOrientationToApp`, ABHostGeometry.m:44/:67); mặc định chỉ
  suppress khi bridge nói rõ drawn=1. Native: không blank inputView
  (ABInApp.m:1907), `ABKeyboardPublish` bọc cả hai chiều (:1983),
  dispatch chặn show; lật drawn→native giữa phiên: phục hồi CHỈ
  inputView mang marker `ABBlankInputViewKey` (`ABRestoreBlankInputView`
  :1894) + host đóng panel đang sống qua đường hide hiện có.
  Reporter kbstate theo hợp đồng: ACTIVE chỉ sau xác nhận focus
  thành công; INACTIVE hoãn 1 nhịp runloop + kiểm responder hiện
  hành (transfer guard); heartbeat 1 s; session sinh 1 lần/nạp, seq
  đơn điệu. `BWKbEffective` không đổi luật. Điểm ngoài phạm vi đã
  khai: funnel F5 tại AppBridgeA/ABHostLaunch.m:261 (chỉ phát NO lúc
  đóng app — teardown).
- **B5 (SplitScreen — owner kb + AutoHide + cleanup + pinch + src=):**
  `BWInputStore.h` C99 header-only đúng hợp đồng (lệch nhỏ đã khai:
  tham số `hosted` là `const int *` thay `const bool *`, ngữ nghĩa
  giữ nguyên). Identity qua cổng duy nhất `bwApplyAssignmentForSlot:
  bundle:` (BridgeWake.m:330) — gen tăng ở MỌI sự kiện vòng đời gán;
  handler `bwHandleKbStateNote:` (:403) validate qua BWInputStore,
  log `[kbstate] accept` / `reject reason=<badhash|badgen|
  badsession|staleseq|noassignment>`; type 6 tính known/active từ
  `BWInputSlotStateAt` tại thời điểm phát, nguồn `app-input-session`;
  act handler chỉ còn activity + log. Cổng fade `ahFadeBlockedReason`
  đọc aggregate theo hosted: 2 → giữ `kb`, 1 → giữ `kbunknown` + log,
  0 → không giữ; nhả hold qua `bwCheckKbHoldRelease` (sau accept +
  tick 1 s) → `ahNoteKbHoldReleased` reset mốc idle tại thời điểm
  nhả. Cleanup `ahCloseCleanup` chèn tại SCPCarSplit.m:1769 TRƯỚC
  hostCloseAll (không qua ahRevealBody:; idempotent); thứ tự solo:
  `ahSetSuspended:YES` của soloBundle: tại :2375 SAU closeGoingHome:
  :2367 (điểm đặt đã dời theo phán quyết 18:45). Pinch: vắng pref →
  OFF (:746) + migration một lần có marker
  `bridgewake.pinchOffMigratedYtz5` (ghi 0 + log `[pinch1] legacy
  pinchMode overridden to OFF (ytz5)`). src= gắn tại mọi điểm gọi
  close (pane-last/tweak-exit/solo/native-close trong SCPCarSplit.m;
  home-system/open-other/dismiss trong SCPHooks.m) + log cả
  early-return !active; `SCPLogInjectedIconState(before-close/
  after-close)` tại :1760/:1815.
- **P5 (Picker):** chụp `hasContent` tại Picker.m:162 sau sửa (SAU
  removeLoaderFromPane:, TRƯỚC khi pane.picker gán — tránh bẫy
  slotOccupied: tự đọc pane.picker); nền: có app → clearColor,
  trống → màu đặc gốc nguyên giá trị; log `[picker] hasContent=%d`.
  Đường huỷ xác minh gỡ sạch ở completion — không thêm cơ chế.
- **I5 (Icon instrument):** `SCPLogInjectedIconState` đi publish
  walk đúng (home VC yếu → model → lists → icons), KHÔNG qua
  connectedScenes; cổng hiệu lực lists>0 && modelIcons>0; trạng
  thái BLIND (kèm reason) / ABSENT-MODEL / PRESENT-MODEL +
  dock=present/absent/unknown; cell chỉ ghi khi walk chạm đúng
  *IconView của bundle, còn lại cell=unreadable — không khẳng định
  cell. Điểm gọi thứ ba after-home trong SCPHomeApply, throttle 1 s
  tại điểm gọi. Reader cũ SCPCarHomeBundles bị đánh dấu blind=1
  trong log (logic nguyên vẹn).

**Harness 4 ca cấu trúc (BWInputStore.h THẬT, clang-18 C99 + C++,
-Wall -Wextra -Werror): 24/24 PASS.** Ca 1 transfer responder A→B
cùng app: ACTIVE liên tục, không INACTIVE giả. Ca 2 hai app cùng có
phiên: đóng một app không giải hold app kia; aggregate chỉ nhả khi
phiên ACTIVE cuối kết thúc. Ca 3 gán lại cùng bundle/slot (gen mới):
báo cáo gen cũ bị loại đúng reason badgen, trạng thái giữ UNKNOWN.
Ca 4 nguồn câm >3,5 s: UNKNOWN theo lastReport của NGUỒN (re-emit
của owner không chạm store nên không gia hạn giả được); aggregate
rơi về kbunknown-hold. Ca phụ đều PASS: badsession + takeover khi
session cũ hết tươi; staleseq (bằng/thấp); noassignment; badhash;
INACTIVE hết tươi decay về UNKNOWN (không nhớ INACTIVE).

**Kiểm tĩnh độc lập (verify-ytz5.md): PASS mọi cổng trừ parity.**
Phạm vi diff PASS; cấm kỵ a–f PASS cả sáu (event-1 vẫn 2 điểm như
HEAD, điểm trong closeGoingHome: vẫn sau `if (goHome)` — KHÔNG cộng
ở đường NO; ABChannels.m/ABKeyboard.m vắng trong diff; ABInApp 0
lời gọi CFPreferences cho cổng; ABYTZoom/SCPTouchProbe/
SCPFullscreenController vắng; ENFORCE vẫn khoá — vắng = DRY_RUN hai
phía, nuốt chỉ khi Enforce; pinch vắng = OFF + marker migration);
hợp đồng kbstate PASS (kênh có cả hai phía; BridgeWakePack.h không
đổi, md5 = HEAD; type 7 không ai dùng; act mất quyền kb; cổng fade
đọc aggregate); cleanup PASS (điểm chèn + không qua reveal + thứ tự
solo); knob PASS (publishKnobsNow đúng 1 eor tại cùng offset tương
đối 0x364, IMP dịch +0x268 do cộng code — cực giữ nguyên);
discriminator trên deb PASS đủ.
**Parity: SplitScreen 1398 → 1409 — mất đúng 1 method
`bwHandleKbSyncNote:`, thêm 12** (đã truy hết: closeSource/
noteCloseSource: (M5), ahCloseCleanup (M1), ahNoteKbHoldReleased
(M3), nhóm bwHandleKbStateNote:/bwKbAggregateForHostedPanes/
bwCheckKbHoldRelease/bwApplyAssignmentForSlot:bundle:/
bwNoteAssignmentForPane:). 7/8 thành phần còn lại mất 0. Kiểm tĩnh
chấm NO-SHIP theo tiêu chí cứng "mất method = FAIL" và ghi miễn
trừ thuộc GPT/coordinator. **Coordinator miễn trừ tại hồ sơ này:**
method mất duy nhất là consumer `appbridge.kbsync` — chính đường
W2 mà phán quyết GPT ra lệnh đóng (không mang gen, ghi vô điều
kiện, gói trễ ghi đè phiên mới), được thay bằng `bwHandleKbStateNote:`
+ BWInputStore có validation đầy đủ theo hợp đồng 18:45. Hệ quả phụ
đã khai: host vẫn phát appbridge.kbsync (funnel panel) nhưng owner
không còn consumer — đúng thiết kế nguồn panel tách riêng; phát
vào kênh không người nghe là vô hại. Không method nào mất ngoài ý
muốn. Phán quyết miễn trừ cuối cùng thuộc GPT.

**Candidate + đồng bộ cây:** hai cây khớp (omnicar-re/src 15/15
identical; project 12/15 identical, 3 file lệch đúng 1 dòng import
làm phẳng theo quy ước project, gồm dòng SCPHomeWallView của
SCPHomeApply.m được giữ nguyên). Build từng module sạch → aggregate
FINALPACKAGE=1 EXIT=0. Candidate local arm64:
`com.anlai.omnicar_1.0.3-ytz5_iphoneos-arm64.deb`, 1.036.636 B,
SHA-256 `2d1cf435ada8d622427e85ae47eb1e0e85c8edc4d4dbd9b9dab3a834de0a3754`;
members debian-binary + control.tar.gz + data.tar.lzma; control
Version 1.0.3. **CI FAT — ĐÃ HỦY THEO PHÂN CÔNG MỚI (xem khối
TÍCH HỢP ngay dưới): không lấy FAT làm bản bàn giao, không giao
deb xe ở vòng này.**

**PENDING-DEVICE (chưa mục nào được gọi là đã chứng minh trên
xe):** phím hosted native hiện ở màn nào/gõ/đóng (nghiệm thu riêng
theo đặc tả); chuỗi kbstate khép trên xe; vòng đời AutoHide sau
sửa (thoát lúc mờ → mở lại hiện đủ; giữ khi nhập, chạy lại sau
đóng phím); picker nhìn xuyên + ô trống vẫn đặc; A/B icon với
[iconstate] (trần đo model/dock — cell vẫn khoảng mù W5).

**TÍCH HỢP (bổ sung theo phân công tích hợp GPT, Nguyen chuyển
19:15 — ghi ngay trong khối công việc):**
- Commit nền trước thi công: source HEAD `38735c5` (ytz4); commit
  hồ sơ nền khi commit nguồn: `b4a04bc`. Commit nguồn YTZ5:
  `e6b50a4` trên main (đi cùng đợt push đầu của mục 29.7 này).
- DANH SÁCH FILE THAY ĐỔI ĐẦY ĐỦ (15): AppBridgeB/ABInApp.m,
  AppBridgeB/ABHostGeometry.m, AppBridgeB/ABHostBMethods.m,
  SplitScreenA/SCPCarSplit.m, SplitScreenA/SCPCarSplit.h,
  SplitScreenA/SCPCarSplit+AutoHide.m,
  SplitScreenA/SCPCarSplit+AutoHide.h,
  SplitScreenA/SCPCarSplit+BridgeWake.m,
  SplitScreenA/SCPCarSplit+BridgeWake.h, SplitScreenA/SCPHooks.m,
  SplitScreenB/SCPCarSplit+Picker.m, SplitScreenC/SCPCarApps.m,
  SplitScreenC/SCPHomeApply.m, SplitScreenC/SCPHomeApply.h (MỚI),
  SplitScreenC/BWInputStore.h (MỚI).
- **FILE HOME/LAUNCH DÙNG CHUNG ĐỘI NÀY ĐÃ CHẠM — ĐÁNH DẤU RIÊNG
  cho phía GPT (nhánh feature/omnicar-home-launcher) đọc trước khi
  sửa cùng khu vực:** SCPHomeApply.m/.h, SCPCarApps.m (chỉ chuỗi
  log blind=1), SCPHooks.m (chỉ gắn nguồn tại điểm gọi close),
  SCPCarSplit.m (chỉ tại các điểm close). **Điểm giao tiếp:**
  hàm mới `SCPLogInjectedIconState(NSString *phase, NSString *src)`
  khai tại SCPHomeApply.h, định nghĩa tại SCPHomeApply.m; các điểm
  gọi: `before-close` (SCPCarSplit.m:1760, đầu closeGoingHome:,
  trước cleanup), `after-close` (SCPCarSplit.m:1815, sau thân
  đóng), `after-home` (trong SCPHomeApply sau apply, throttle 1 s
  tại điểm gọi); ivar nguồn close `closeSource` + helper
  `noteCloseSource:` (SCPCarSplit.h; thân SCPCarSplit.m:1743),
  closeGoingHome: log `CarSplit: tat split (goHome=%d) src=%@` rồi
  reset nguồn về unknown. Phạm vi phía đội này ở khu vực Home là
  INSTRUMENT-ONLY (đo model/dock + src= + 3 trạng thái) — không sửa
  cơ chế icon/launcher, tránh giẫm nhánh của GPT.
- **CI — sự thật đầy đủ:** theo kế hoạch trước, coordinator đã
  merge main `e6b50a4` vào ci-fat-test (`30caadb`) và dispatch
  workflow 410962367 lúc ~19:12 — TRƯỚC khi phân công mới (19:15)
  tới. Run dispatch `42615117251` đã **completed success** (không
  kịp hủy); run do push tự kích hoạt `42615107515` đã **cancelled**
  theo lệnh mới. Theo phân công 19:15: artifact FAT của run trên
  **không được lấy làm bản bàn giao, không tải xuống phân phối,
  không giao deb xe**; DEB tổng hợp chỉ build/ký SAU khi GPT bàn
  giao commit icon Home. Trạng thái bàn giao của đội này dừng ở:
  source-complete / static PASS (trừ miễn trừ parity đã ghi) /
  harness PASS / local-build PASS — CI + DEB hoãn theo phân công,
  chờ commit bàn giao của GPT.

### 29.8 Quy tắc hồ sơ mới (Nguyen, 19:00–19:05)

Nguyen phát hiện từ trưa 09/11 chưa có commit lịch sử nào ("Tôi để
ý ko hề thấy bạn lưu lịch sử dự án commit từ lúc tôi yêu cầu là
trưa nay") và ra lệnh bổ sung ngay, kèm hai chỉnh: (19:03) lịch sử
phải đọc ra được TỪNG MỐC thành công/thất bại — nhãn verdict tường
minh theo mốc trong §29 và TIEP_TUC §4, cộng bảng mốc riêng cho
vòng ytz5 (§29.0); (19:04–19:05) phạm vi rà soát là TOÀN BỘ diễn
biến liên quan dự án từ trưa nay tới hiện tại (kiểm kê độ phủ
PATCH §24–§28 + TIEP_TUC §4 đối chiếu danh sách mốc; mốc thiếu bổ
sung trong cùng đợt commit này — gồm chốt vai trò + bản thảo trong
chat + vụ gỡ tài liệu bàn giao `66efef2`→`f5f7e2f`, quy tắc MỘT
DEB 14:39, lỗi công tắc prefs 14:31 + phản ứng staging, lệnh tăng
agent song song 15:05). Quy tắc vận hành ghi vào TIEP_TUC §7,
nguyên văn tinh thần lời anh: TỪ NAY LƯU LỊCH SỬ MỖI KHI CÓ THAY
ĐỔI VỀ DỰ ÁN, NGAY TRONG KHỐI CÔNG VIỆC ĐÓ — mọi cuộc làm việc
liên quan chỉnh sửa/quyết định đều commit lịch sử ngay trong khối
đó, không dồn cuối vòng; chỉ trao đổi thông thường mới miễn.

### 29.9 Tích hợp YTZ5 + Home launcher của GPT [ĐÃ XONG — CI FAT PASS; CHỜ PHIÊN XE]

Bàn giao (Nguyen chuyển tiếp 19:53): nhánh `feature/omnicar-home-launcher`
tip `050eddb0` (5 commit nguồn GPT trên đúng nền `3e25499`; tài liệu bàn
giao `gpt-project-history/HOME_LAUNCHER_HANDOVER.md`). GPT làm phần icon
OmniCar trên lưới Home CarPlay theo phân công 19:15; Muse ghép + build
+ ký MỘT deb tổng hợp, ghi hồ sơ. Biên bản đầy đủ:
`handover/reports/integration-ytz5hl.md` + kiểm tĩnh độc lập
`handover/reports/verify-ytz5hl.md` (cùng commit hồ sơ này).

**Ghép (nhánh `integrate/ytz5-home-launcher` từ main `cbdaeab`):**
- Merge `c74c878`: **0 xung đột, 0 hunk phải xử lý tay** (hai phía dựa
  trên cùng snapshot nguồn YTZ5 ở `3e25499`). Kiểm tay hậu ghép tại các
  điểm nóng: src SCPHooks.m giữ cả `noteCloseSource` (B5, ×5) lẫn
  SCPHomeLauncher (×11); src SCPHomeApply.m là bản I5 nguyên vẹn tới
  EOF và có lời gọi audit của GPT `SCPHomeLauncherAuditModel(...)`
  tại entry `SCPLogInjectedIconState` (dòng 346).
- Hai nguồn commit: YTZ5 `e6b50a4` (Muse) + Home launcher tip
  `050eddb0` (GPT). Tip nhánh integrate: `8a2c7aa`.

**Khoảng trống hai cây (§4 của bàn giao — GPT cảnh báo, coordinator
ĐO LẠI và xác nhận ĐÚNG, còn rộng hơn cảnh báo):** tại thời điểm ghép,
toàn bộ vòng YTZ5 **chưa từng được stage vào cây project của push9**
(mọi discriminator = 0; `SCPHomeApply.m` project = bản cũ 332 dòng so
với src 539; thiếu cả `BWInputStore.h` + `SCPHomeApply.h`) — CI build
từ project nên nếu dispatch ngay sẽ ra bản thiếu YTZ5. Đã sửa bằng
commit staging `74635d1`: stage 20 file hợp nhất (YTZ5 ∪ GPT) src →
project ở cả push9 lẫn `omnicar-re`, làm phẳng import theo hợp đồng
cũ (giữ dòng ghi chú `[phase3 sync]`); file project do GPT tự stage
khớp byte-đối-byte với đầu ra staging; hai cây src byte-identical;
Makefile SplitScreen cộng `SCPHomeLauncher.m` (38 file/38 duy nhất,
không trùng symbol).

**Sự cố tích hợp (ghi nguyên trạng):** build cục bộ SplitScreen fail
duy nhất ở `SCPHomeLauncher.m` vì xung đột chú thích nullability giữa
hai header: `SCPHomeCommon.h:38` khai `SCPAppHasCarPlayUI` là
_Nonnull ngầm, `SCPShared.h:67` là `_Nullable`; ngược cực ở cặp
`SCPIsInjectedPhoneApp` (`SCPHomeCommon.h:45` _Nullable /
`SCPShared.h:79` _Nonnull ngầm). Module của GPT là TU đầu tiên include
cả hai header nên lộ xung đột tiềm ẩn từ trước. Fix `8a2c7aa`: thống
nhất `_Nullable` cho cả hai hàm (khớp thân hàm thật — nil-tolerant),
chỉ đổi chú thích, 2 dòng × 3 cây; sau fix build sạch. Không sự cố CI
nào khác; run push-triggered 42622551174 bị coordinator cancel có chủ
đích để giữ một run dispatch chuẩn duy nhất.

**Kiểm tĩnh độc lập (agent chỉ-đọc, cây project): SHIP cho FAT.**
(a) Khẳng định GPT PASS 7/7 (kiểm ABI type-encoding trước install;
original gọi đúng 1 lần cho app khác/unknown; đăng ký library không
trùng + promotion cũng refresh; lọc own-bundle chỉ trong bộ nhớ;
`SCPIsHostedApp` NO sớm; mở qua `showLayoutPanelForApp:` +
`ahNoteActivity:AHSourceHome`, không openURL/prefs/event-1 mới; nút
dock không đổi; GPT không chạm SCPCarSplit/AutoHide/BridgeWake/
Picker/YTZ). (b) Nguyên vẹn YTZ5: parity method so với `e6b50a4`
= 0 mất/0 cộng ngoài GPT (488 method phân biệt hai phía; method miễn
trừ `bwHandleKbSyncNote:` đã vắng ngay tại `e6b50a4` — miễn trừ của
bước ytz4→ytz5 tại 29.7, vòng ghép này không mất thêm gì); mọi
discriminator có mặt; knob đúng 1 đảo cực (source); ENFORCE khoá
mặc định; pinch vắng pref = OFF. (c) `git diff --check` sạch.

**Build + CI:** toolchain verify qua `fix-toolchain.sh` (VM lại
rollback /usr trong khoảng 19:54 — khôi phục foreground, smoke test
đạt). Build cục bộ: SplitScreen + AppBridge sạch; dylib SplitScreen
cục bộ có 14 symbol SCPHomeLauncher (positive control SCPCarSplit
642 hit nm); aggregate ra candidate cục bộ 1.041.356 B (chỉ kiểm
biên dịch, không phải bản giao). CI: merge integrate vào ci-fat-test
= `b8deff2` (sạch); dispatch workflow 410962367 → **run 42622552103
completed success** (xác minh foreground qua jobs API: build FAT +
verify slices + upload đều success).

**DEB tổng hợp duy nhất (ytz5hl1):**
`com.anlai.omnicar_1.0.3-rebuilt-ytz5hl1-fat_iphoneos-arm64.deb` —
**1.245.714 B, SHA-256
`e28883b97c68ce0d0d0341499a6c33a0d2b1d9b2f32ef0f2d308595178cad594`**;
members debian-binary + control.tar.gz + data.tar.lzma. Kiểm binary
hai lát (arm64 = arm64e trên mọi probe): SCPHomeLauncher có mặt cả
hai lát (10 chuỗi + symbol export); `bwHandleKbStateNote:` ×1,
`bwHandleKbSyncNote:` = 0 (miễn trừ hiện hình đúng), `ahCloseCleanup`
×1, kênh `bridgewake.v1.kbstate` ×1 ở cả SplitScreen lẫn AppBridge;
AppBridge mỗi lát có `appBridgeNativeKeyboard`/`drawnKeyboard` ×1.

**Trạng thái:** source-complete / static PASS / local-build PASS /
CI FAT PASS. **PENDING-DEVICE nguyên vẹn** — phiên xe gộp theo kịch
bản 6 bước của GPT + phép thử Home launcher (icon hiện đúng 1 lần →
chạm mở panel Bố cục/Yêu thích/Gần đây, KHÔNG mở Cài đặt iPhone →
nút dock vẫn chạy → split + thoát Home lúc logo hiện → lặp lúc đã
mờ → đổi app rồi quay lại → ngắt/kết nối lại → khởi động lại tiến
trình), giữ riêng các mục: phím hosted native trên xe, chuỗi kbstate
trên xe, vòng đời AutoHide sau sửa, picker nhìn xuyên + ô trống vẫn
đặc, A/B icon tầng model/dock. Bảng mốc 29.0: dòng build/CI đã cập
nhật ĐÃ XONG; dòng phiên xe giữ CHƯA.

### 29.10 Phiên xe ytz5hl1 — BÁO CÁO TẠI XE của Nguyen (20:34, 09/11) [CHỜ LOG ĐỐI CHIẾU] + hai vấn đề/lệnh mới (20:37–20:41)

Nguồn: Nguyen báo tại chat 20:34–20:41 ngày 09/11/2026, phiên xe của bản
tổng hợp `com.anlai.omnicar_1.0.3-rebuilt-ytz5hl1-fat` (SHA-256
`e28883b9…`, xem 29.9). **LOG PHIÊN CHƯA ĐƯỢC UP** — mọi verdict dưới đây
là **báo cáo tại xe của Nguyen (mức màn hình)**, chờ log đối chiếu trước
khi kết án cơ chế. Ghi theo quy tắc 29.8 (verdict từng mốc tường minh).

| # | Mục nghiệm thu | Verdict |
|---|---|---|
| 1 | Icon Home: hiện đúng 1 → chạm mở panel Bố cục/Yêu thích/Gần đây, không mở Cài đặt iPhone; nút dock còn chạy | **TẠM ỔN** (màn hình; tầng cell/tap chờ log `[home-launch]`) |
| 2 | Vòng đời AutoHide: thoát split lúc đang mờ → mở lại hiện đủ logo/handle/divider, ẩn lại sau 4 s | **TẠM ỔN** (màn hình) |
| 3 | Picker nhìn xuyên (ô có app trong suốt; ô trống vẫn đặc) | **THẤT BẠI** (màn hình) — chờ log: đọc `[picker] hasContent=` tại mỗi lần mở để phân định (a) phép bắt occupancy cho kết quả sai, hay (b) lớp phủ nằm ở phần tử khác ngoài placeholder |
| 4 | Bàn phím gốc (native) cho app hosted | **THẤT BẠI** — phím **không hề hiện** trên màn xe. Đây đúng là tầng xe của bản đồ khả thi 3 tầng đã khai trước build (M2, 29.5): nguồn chỉ chứng được phím hệ thống không bị suppress; phím dựng ở màn nào là việc chỉ xe trả lời được. Chờ log phân định: app có báo kbstate ACTIVE không; giá trị cổng `drawnKeyboard` thiết bị nhận được là gì; phím có dựng ở màn khác không |
| 5 | Đường đánh thức sau khi đóng phím | Nửa reveal **ĐẠT**: chạm hiện lại logo được. Nuốt vẫn ở chế độ **Đo** (ENFORCE chưa bật — xem (a) dưới đây) |
| 6 | A/B icon với instrument mới | **TẠM ỔN** (màn hình; tầng model/dock chờ log `[iconstate]`) |
| 7 | Bước "hồi quy + đuôi phiên" trong kịch bản giao | **LỖI TRÌNH BÀY CỦA CLAUDE**: kịch bản viết chưa rõ nghĩa, Nguyen hỏi lại "bước 7 là gì". Mục này là phụ, không chặn nghiệm thu; kịch bản sau phải viết bằng tên trên màn hình và phân rõ việc bắt buộc / việc nếu tiện |

**Hai điểm Nguyen nâng thành vấn đề (20:37–20:41):**

(a) **Gọi lại 1 chạm vẫn click app — Gate 3 chưa từng được mở trên xe ở
dự án này.** Dữ kiện: cơ chế nuốt đã có đầy đủ trong mã; ở phiên ytz4 phép
quyết định `wouldSwallow` đo đúng 8/8 tổ hợp (báo cáo phiên ytz4, §28 /
ACCEPTANCE_YTZ4); mẫu tham chiếu QA180 `h1wake3` của DuoFace đã đạt nuốt
thật trên **cùng chiếc xe này** (12 lần swallowed=1, 06/11/2026). Nhưng ở
dự án OmniCar, Wake ENFORCE **chưa một lần được bật chạy thật** — qua mọi
vòng nó bị giữ ở chế độ Đo vì chuỗi bằng chứng Gate 3 của GPT chưa khép
(lần thiếu nguồn kb sạch, lần cửa sổ đo trống). **Đề xuất của Muse (đã
trình Nguyen 20:37):** bản sau bật ENFORCE cho **app hosted** — cổng
fail-open (mọi điểm không chắc chắn thì cú chạm đi qua như hiện nay; chỉ
giữ cú chạm khi mọi điều kiện chắc chắn); app **native nằm ngoài phạm vi
kiến trúc** (không có thành phần nào trong tiến trình native để giữ cú
chạm). Việc bật này **NGƯỢC phán quyết Gate 3 hiện hành của GPT** → chờ
(i) Nguyen chốt lệnh cuối và (ii) GPT tham vấn. **Chưa thi công.**

(b) **PINCH — ĐÍNH CHÍNH DỮ KIỆN QUAN TRỌNG (Nguyen bắt đúng 20:39; Muse
nhận lỗi).** Pinch **ĐÃ thành công trên xe ở các bản 21–35** (nền QA20)
bằng **recognizer tuỳ biến nằm trong app hosted** — nhận diện bắt đầu ngay
khi ngón thứ hai chạm + `cancelsTouchesInView`. Số liệu touchset của dự
án tái tạo này (phiên ytz3: 62/62; ytz4: 101/101 ca "hai chạm" đều là bản
trùng của một ngón) là **artefact của vị trí đo phía CarPlayApp** — một cú
chạm bị hệ thống ghi ở hai cửa sổ — **không phải** bằng chứng màn xe
không gửi hai tiếp xúc đồng thời; app hosted nhìn thấy đủ hai ngón thật
trong scene của nó, đã chứng minh bằng xe thật ở bản 21–35. Hệ quả:
**quyết định PARK pinch (phán quyết W3, 29.6) và cả thiết kế phép hiệu
chuẩn "hai ngón giữ 3 giây" đều dựa trên số đo sai vị trí này** — ghi
nhận tại đây để GPT phán lại trên dữ kiện đúng. **Kế hoạch sửa (chưa thi
công):** recognizer trong ABInApp cho ô hosted → phát tín hiệu về host →
host gọi FS controller hiện có. Cần GPT phán trước các điểm giao tiếp:
kênh tín hiệu dùng chung; thứ tự ưu tiên với hook của đường đánh thức tại
cùng điểm chạm; hành vi khi controls đang ẩn / đang EXPANDED. (Đính chính
này đồng thời đã ghi vào bộ nhớ ngày 09/11 của Muse.)

**Trạng thái chờ sau mục này:** (1) log phiên ytz5hl1 — Nguyen up một lần
→ phân tích `[picker]` / `[kbstate]` / `[home-launch]` / `[iconstate]` /
wouldSwallow, tách đúng thế hệ binary như mọi phiên; (2) chốt lệnh bật
ENFORCE hosted (Nguyen) + tham vấn GPT cho cả (a) và (b) trước khi thi
công; (3) miễn trừ parity `bwHandleKbSyncNote:` — vẫn chờ GPT phán cuối;
(4) weather/knob + VISUAL_ORIGINAL_COMPARISON giữ PENDING.

### 29.11 Chẩn đoán pinch của Nguyen (20:43, 09/11) — "app chạy quá nhiều": hai cơ chế chặn để GPT tham vấn [CHƯA THI CÔNG]

Nguồn: Nguyen phát biểu tại chat 20:43 ngày 09/11/2026, bổ sung cho mục
29.10(b). Đây là **chẩn đoán của Nguyen về nguyên nhân pinch chưa thành
công** — ghi nguyên văn ý của anh trước khi GPT tham vấn; phía Muse
**chưa kết luận cơ chế**.

**Chẩn đoán:** vấn đề khiến zoom 2 ngón chưa thành công là **app chạy
quá nhiều** — hai ngón chạm lọt xuống app hosted, app vẫn xử lý cảm ứng
của nó (cuộn / zoom / hành động riêng) trong lúc pinch, nên cử chỉ bị
app tranh chấp thay vì chuyển fullscreen sạch. Nói cách khác, điểm nghẽn
không nằm ở khâu *nhận diện* hai ngón (app hosted nhìn thấy đủ hai ngón
thật trong scene của nó — xem 29.10(b)) mà ở khâu *ngăn app tiêu thụ*
hai chạm đó.

**Hai hướng khắc phục Nguyen nêu để GPT tham vấn:**

(1) **NGĂN HOẠT ĐỘNG CẢM ỨNG BẰNG 2 NGÓN XUỐNG APP** — điểm chặn nằm
trong tiến trình app. Đây chính là cơ chế đã thành công ở bản 21–35:
recognizer tuỳ biến trong app hosted + `cancelsTouchesInView` — khi
recognizer vào trạng thái Began ngay lúc ngón thứ hai chạm, UIKit huỷ
các chạm đã giao cho view của app, app không còn xử lý chúng nữa, cử
chỉ pinch thuộc về tweak trọn vẹn. Dữ kiện kiến trúc đã có trong hồ sơ
và vẫn áp dụng: **chạm vào app hosted đi theo đường scene, KHÔNG qua
`sendEvent:` của CarPlayApp** — nên chặn ở phía host không nhốt được
app; điểm chặn bắt buộc phải nằm trong tiến trình của app hosted.

(2) **LỚP PHỦ VÔ HÌNH** — một lớp trong suốt phủ lên ô để hứng chạm
trước. Nhận xét cơ chế (**chưa kết luận**, ghi để GPT cân): lớp phủ đặt
phía host **không** hứng được chạm của scene hosted (khác tiến trình /
khác ngữ cảnh render — cùng lý do kiến trúc ở (1)); lớp phủ đặt **trong
app** thì hứng được, nhưng nó hứng **mọi** chạm kể cả một ngón, nên phải
tự chuyển tiếp các chạm không phải pinch xuống app — phức tạp hơn hẳn
recognizer (rủi ro độ trễ, sai thứ tự sự kiện, nuốt nhầm chạm thường).

**Trạng thái:** Muse đã soạn lại bản tham vấn đầy đủ gửi GPT trong
chat (gồm verdict phiên ytz5hl1 theo 29.10 + đề xuất Gate 3 ENFORCE
hosted + pinch kèm chẩn đoán này và hai cơ chế khắc phục + các câu hỏi).
**Chờ GPT phán trước khi thi công:** (i) cơ chế chặn được chọn —
recognizer + `cancelsTouchesInView` / overlay trong app / kết hợp;
(ii) thứ tự xử lý giữa pinch và wake-swallow tại cùng điểm chạm (cú
pinch đầu khi controls đang ẩn có bị tính là cú chạm gọi logo không);
(iii) hành vi pinch khi controls đang ẩn và khi đang EXPANDED (zoom
out = thu về split?). Các mục chờ khác giữ nguyên như cuối 29.10.

### 29.12 Phân tích log phiên ytz5hl1 [ĐÃ ĐỐI CHIẾU LOG — verdict log thay verdict miệng của 29.10]

Nguồn: `OmniCar.log` (965.241 B, SHA-256 `e7e62a0b…`) + `OmniCar.log.old`
(2.102.266 B), Nguyen up ở commit `5e745bc`. Năm strand song song + bản
đối hoà `analysis-ytz5hl1-final.md` và 5 biên bản strand đã chép vào
`handover/reports/`. Mọi đếm bằng grep trên file gốc, kết luận ghim dòng
có timestamp.

**Khung phiên:** file .old chứa cả phiên ytz4 (dòng 1–2477, 17:40:49–
17:49:22, CP 36057) lẫn đầu phiên ytz5hl1; thế hệ mới bắt đầu
`20:18:10.158` (SB 36658, CP 36683); hai file nối liên tục tại 20:36:45
(seq kb-sync 1976→1977); đổi PID đồng loạt SB+CP lúc 20:39:51–57 (dạng
respring, không crash/exception/SIG quanh đó — nguyên nhân NO-DATA);
pha 2 CP 36712 tới 20:52:18. Lỗi toàn cục = 0. Chuỗi build giống hệt hai
thế hệ — chỉ phân biệt bằng PID + timestamp + tag riêng ([home-launch]
121, [kbstate] 1.430, [ytz5-k5] 7; đoạn ytz4 đều 0).

**Bảng verdict (log):** bước 1 icon Home **ĐẠT ở tầng log** (library/
declaration/tap-gate đủ 2 lần dựng; 11 lần chạm THẬT routed-existing-
panel 20:18:56→20:32:27, openURL = 0; tầng model NO-DATA — xem dưới);
bước 2 vòng đời AutoHide **ĐẠT** (3/3 thoát lúc mờ → mở lại hiện đủ,
restored ≤44 ms, fade lại đúng idle 4.00; không lần mở lại nào bắt đầu ở
trạng thái mờ — lỗi rò ahFadedState của ytz4 không tái diễn); bước 3
picker **THẤT BẠI — cơ chế nhánh (b)**; bước 4 phím gốc hosted **THẤT
BẠI — phân định nhánh (i)**; bước 5 reveal **ĐẠT**, Gate 3 có tiến triển
bằng chứng lớn (dưới); bước 6 A/B icon **ĐẠT một phần / model NO-DATA**
(thoát lúc mờ ⇒ goHome=NO 3/3 khớp ytz4, nhưng lúc hiện cũng NO 4/4 —
`src=` là biến trội phiên này; cell giữ 5/7 ca after-close; remove = 0).

**Bước 3 — cơ chế:** toàn phiên đúng 2 lần mở picker thật (nút "Đổi
app", ô 0 YouTube hosted): 20:25:25.561 và 20:25:36.896, cả hai
`[picker] hasContent=1`; `hasContent=0` xuất hiện 0 lần → nhánh (a) của
29.10 bị log bác (phép bắt occupancy ĐÚNG; placeholder `pane.picker`
cùng hunk với dòng log nên vô tội ở tầng log). Lớp phủ là phần tử KHÁC,
nghi phạm xếp hạng: (b1) `pane.cover` — phủ toàn pane, đúng hằng màu
đặc rgb(0.9333, 0.9412, 0.9843), nhưng add/remove không phát dòng log
nào (NO-DATA sự hiện diện); (b2) shield của popup — xác nhận dựng đúng
tại 2 mốc mở (20:25:25.951 / 20:25:37.092), màu/alpha không được ghi.
Kết án đích danh cần đúng 1 dòng đo bổ sung: alpha + superview của
`pane.cover` và `pane.picker` ngay sau điểm bắt hasContent trong
`showPickerForSlot:`.

**Bước 4 — cơ chế:** cổng trên thiết bị = native, xác nhận phía host
bằng dòng thật `[ytz5-k5] cong ban phim doi: native (prefschanged)` ×7,
không lần nào drawn (token `drawnKeyboard` vắng mặt trong log). Hai cửa
sổ ACTIVE duy nhất: 20:25:46→20:26:31 và 20:35:46→20:36:14, tổng 75 báo
cáo state=1, accept 100% trong cửa sổ. **Chuỗi kbstate KHÉP trọn vòng:**
accept 1.425 / reject 5 (noassignment ×3, badgen ×2 — đều là sự kiện
vòng đời); seq liền mạch 2 session; accept→emit 0–1 ms; emit
`source=app-input-session` active=1 ×148; có ca stale→UNKNOWN thật sau
badgen (freshness neo vào nguồn, đúng luật W2). AutoHide giữ đúng:
`fade deferred (kb)` ×11, fade thật trong lúc ACTIVE = 0. Nhánh (ii)
(cổng lệch/vẫn suppress) bị log bác: không dòng suppression, host không
chặn panel lúc nhập liệu. **Kết luận nhánh (i): phím hệ thống không
dựng trên màn xe cho scene hosted — kết án tầng xe, cầu bridge vô tội;**
ở chế độ native, app hosted trên bộ máy này không có bàn phím dùng
được. (Giới hạn: tầng trình bày phím câm log tuyệt đối, `UIKeyboard` =
0 mọi process; kết án dựa trên chuỗi bridge khép kín + verdict màn
hình của Nguyen.)

**Gate 3 — trạng thái bằng chứng sau phiên:** điều kiện nuốt đầy đủ
(HIDDEN + known + kb INACTIVE từ nguồn xác thực) có 9 ca; **would=1
SẠCH ở 4 ca** (seq 1/8/17/20, kbAge 9–625 ms, failopen=`-`) — phiên đầu
tiên có ca dương tính sạch trên nguồn kb đã sửa; 4 ca would=0 do stale
(fail-open đúng thiết kế); **1 ca bất thường seq=45** (20:37:23.977, H +
fresh mà would=0, đúng nhịp host đang reveal — nghi race snapshot với
state-flip, chưa chứng minh). Mắt xích "chạm lúc HIDDEN + kb ACTIVE"
vẫn không có ca nào, VÀ tổ hợp đó không đồng tồn tại: cả 3 cửa sổ kb
ACTIVE đều có owner = VISIBLE vì chính thiết kế kb-hold của ytz5 giữ
controls hiện khi phím mở — tiêu chuẩn như viết hiện tại tự mâu thuẫn
với thiết kế đã chốt, cần GPT phán lại tiêu chuẩn. Mắt xích "chạm sau
đóng phím cùng assignment" ĐÃ CÓ (seq 42–47 sau cửa sổ B, gen=20; ca H
trong đó là seq=45 bất thường). Bằng chứng gõ phím vẫn NO-DATA (hệ quả
bước 4).

**Hồi quy/phụ:** native feed lệch đúng 1 act (posted 47 / accepted 46;
seq=19 posted 20:27:50.617 gen=8 không accepted ở cả hai file) +
stateage tối đa 42.546 ms ở kênh state wake (kênh kbstate mới thì
sạch). FS1: expand confirmed 2/9 thao tác; **5 lần refused có snap toàn
0** (`picker=0 ratio=0 dg=0 toast=0 tray=0`), cờ sống chung duy nhất
`to=1` — guard từ chối khi các con trỏ nội dung được mô tả là nó canh
đều tắt, cần truy `to` là đầu vào nào của predicate. YTZ sạch: mismatch
0, revoke 6 lần frame giữ nguyên (không layout cưỡng bức), mask 24
không rò. Weather/knob NO-DATA phiên thứ 4 (chỉ 2 chu trình ans#1
warming lúc startup). Pinch: OFF nhất quán (pinch=0 ×9, wouldPinch=0
×34); **bằng chứng hai ngón phía trong app ĐÃ CÓ** — probe seq=49
(20:38:23.821) `ph B=2 M=17 E=2` do chính YouTube ghi, củng cố đính
chính 29.11; dòng migration riêng NO-DATA (grep `migration` = 0).
Tầng model icon mù toàn phiên ở cả hai phía đo (58/58 mẫu BLIND,
lists=3 icons=0; ABSENT/PRESENT đều 0) — theo chuẩn bằng chứng đã sửa
ở vòng trước, đây là NO-DATA (giới hạn W5), không phải bằng chứng mất
icon.

**Đối chiếu phán quyết GPT `5ae47da`** (gpt-project-history/
YTZ5HL1_GATE3_PINCH_RULING_20261109.md — GPT phán trên báo cáo miệng,
log chưa tải): log nay xác nhận độc lập hướng (5) phím — drawn là đường
duy nhất có phím dùng được cho hosted, native chết ở tầng xe; điều
kiện tiền đề (4) của Gate 3: hai mắt (a) assignment/gen tươi + HIDDEN
hiệu lực và (b) kb known INACTIVE từ nguồn phiên app ĐÃ CÓ trong log ở
4 ca would=1 sạch; mắt (c) (bằng chứng orig_SendEvent bị bỏ qua) chỉ
đo được khi ENFORCE chạy thật; điều tra picker ở (6) đã có kết quả
tầng log như trên (nhánh b + dòng đo còn thiếu đã chỉ đích danh).
Trạng thái chờ giữ nguyên: quyết định thi công theo phán quyết thuộc
vòng tiếp theo; miễn trừ `bwHandleKbSyncNote:` vẫn chờ GPT phán cuối;
weather/knob + VISUAL_ORIGINAL_COMPARISON giữ PENDING.

### 29.13 Vòng hl2 — năm mảng theo phán quyết GPT (K6 phím / P6 picker / W6 pinch / G6 Gate 3 trial / F6 nhãn guard) + ghép dock-retirement của GPT [SOURCE + STATIC + LOCAL BUILD + CI FAT PASS; CHỜ PHIÊN XE]

Nguồn điều hành: phán quyết `YTZ5HL1_GATE3_PINCH_RULING_20261109.md` (5e5192e/5ae47da) + `YTZ5HL1_LOG_REVIEW_20261109.md` (7b6e5d0) + lệnh bổ sung của Nguyen 21:11 (ghép nhánh dock của GPT SAU khi xong 5 mảng + kiểm tĩnh). Baseline `bcf10e6`. Chuỗi commit: `b189e8b` (src 5 mảng) → `711f89a` (merge nhánh integrate, xem phát hiện cấu trúc) → `0de725a` (staging project) → `76538c2` (dock cherry-pick). Biên bản strand: `handover/reports/hl2-report-{abhost,abapp,split,verify}.md`.

**PHÁT HIỆN CẤU TRÚC (sửa luôn trong vòng này):** merge tích hợp ytz5hl (`8a2c7aa`) trước đây chỉ nằm ở nhánh `integrate/ytz5-home-launcher` + `ci-fat-test`, CHƯA từng về main — main thiếu 9 file Home Launcher ở src và cây project còn ở mức ytz4 (thiếu cả kbstate). Đã merge `711f89a` vào main (0 xung đột): từ nay main là cây tích hợp đầy đủ duy nhất; lệch src giữa main và `8a2c7aa` đúng 9 file launcher, không chồng file nào với 5 mảng hl2.

**K6 — PHÍM (ưu tiên 1): ĐẠT (source).** Host: `ABNativeKeyboardEnabled()` absent → DRAWN (trước: native); migration một lần theo idiom ytz5 — pref cũ đang lưu =1 → ghi 0 + marker `appBridgeNativeKeyboardDrawnRestoredHl2` + log `[ytz5-k5] hl2 migration:`, native đặt SAU migration vẫn được tôn trọng (opt-in giữ nguyên, không xoá code native). App: cache mặc định khi bridge chưa nói = DRAWN; chỉ sang native khi payload nói rõ `drawnKeyboard=0`. Bổ sung đủ chuỗi marker hai phía (host: payload + dispatch show; app: gate nhan / responder became / publish). kbstate KHÔNG bị đụng (kiểm tĩnh 3b xác nhận).

**P6 — PICKER: ĐẠT ở mức gắn đo (audit không kết án được bằng source).** `popupShield` bị source bác (SCPCTouchWatch trắng alpha 0.02, hitTest luôn nil; `pickerShield` luôn nil); `pane.cover` là view đặc toàn ô duy nhất (đúng màu trắng người dùng thấy) nhưng các đường add của nó không chứng minh nó có mặt lúc mở picker trên xe (sheet ở cửa sổ riêng). Đã gắn ĐÚNG MỘT dòng đo `[picker-measure]` trong `showPickerForSlot:` ngay sau điểm bắt hasContent (alpha/hidden/superview/frame/bg của cover, picker, sheet, cả hai shield + frame/level trayWindow). hasContent/placeholder giữ nguyên (đã chứng minh đúng ở 29.12). Kết án chờ 1 lần mở picker trên xe với dòng đo này.

**F6 — CỜ 'to': ĐẠT (sửa tầng log).** `to` = `split.trayOverlay`: cờ chế độ hosting dính, đặt một lần tại Panel.m:188 (`= (window != nil)`), không bao giờ reset, và KHÔNG nằm trong predicate FS nào (predicate thật: phase/active/zoomed/solo/pickerSheet/popupOpen/dragGhost+toast; 5 lần refused ở phiên ytz5hl1 thật ra do phase=SPLIT + inactive). Đã đổi nhãn snap `to=%d` → `trayOverlay=%d` + chú thích trong `fsRefusalSnapshot:`.

**W6 — PINCH TRONG APP: ĐẠT (source).** `ABPinchGestureRecognizer` (UIGestureRecognizer subclass, trong ABInApp.m): `cancelsTouchesInView=YES`, `delaysTouchesBegan=NO`, `delaysTouchesEnded=NO`; gắn vào đúng key window của scene hosted khi assignment sống, tháo ở BWResetAll. Latch quyết định tại lúc cặp hình thành từ snapshot packet mới nhất (fresh 2.5 s, gen đã xác thực, pinchAllowed=1, mode của pane); SPLIT+HIDDEN không bao giờ nhận (bất biến 1). Ngưỡng tái dùng nguyên văn từ pinch cũ: out ≥ 1.10 / in ≤ 0.90 (SCPPinchController.m:256-257) + mid-drift `≤ 0.6*distChange + 10.0` (:258); hướng bị khoá theo state committed latch lúc hình thành (out chỉ từ SPLIT, in chỉ từ EXPANDED; sai hướng → Cancelled); tái kiểm điều kiện giữa cử chỉ, 1 lệnh/sequence. Relay: kênh NSDistributed MỚI `com.anlai.omnicar/bridgewake.v1.pinch`, payload `{hash, gen, session, seq, gid, dir, t}` đúng kỷ luật kbstate. Owner `bwHandlePinchNote:` validate badhash → badgen → stale (TTL 1.0 s) → badsession (đối chiếu session BWInputStore khi còn tươi; chưa có thì `sessrc=note` — giới hạn đã khai) → dup/staleseq → badstate (dir khớp state committed) rồi gọi `SCPFullscreenAdapter` qua instance chung của SCPPinchController. Legacy CarPlayApp giữ khoá: điểm bắn duy nhất của nó ăn pref `bridgewake.pinchMode` (absent=OFF + migration ytz5), đường mới ăn pref riêng `bridgewake.pinchInApp` (absent → ENFORCE, 1 → DRY_RUN, 0 → OFF) — một chủ bắn duy nhất.
**HAI SỬA THẲNG HÀNG CỦA COORDINATOR tại tích hợp (đã kiểm tĩnh lại ở mục 4):** (1) kb UNKNOWN phải CHẶN pinch — ruling §1 ghi "keyboard ACTIVE/UNKNOWN … fail-open CHO APP" (cử chỉ để lại cho app); bản đầu chỉ chặn ACTIVE, đọc ngược ruling. Nay: ACTIVE → `kbactive`, UNKNOWN → `kbunknown`, chỉ INACTIVE mới cho qua. (2) Trường `t` của relay: phía app đóng dấu `BWNow()` = systemUptime trong khi owner so TTL bằng `timeIntervalSince1970` — lệch đồng hồ khiến MỌI relay bị reject `stale`. Đã sửa phía app đóng dấu epoch giây (kbstate thoát nạn trước đây vì owner của nó neo freshness vào giờ tới, không so `t` người gửi; pinch là kênh đầu tiên so chéo).

**G6 — GATE 3 TRIAL: ĐẠT (source).** Packet state vốn địa chỉ theo từng pane bằng hash28 nên trial nằm gọn phía owner: helper `BWEmitModesForBundle` — pane thuộc trial thì trường wakeMode trong packet CỦA PANE ĐÓ = ENFORCE, mọi pane khác giữ wakeMode toàn cục (absent vẫn DRY_RUN, KHÔNG blanket). Phạm vi thử: pref `bridgewake.gate3TrialBundle` (vắng → `com.google.ios.youtube`; chuỗi rỗng → tắt trial), kill-switch `bridgewake.gate3Trial` (vắng → bật, 0 → tắt) — trial mặc định BẬT cho đúng một bundle theo đúng phạm vi canary của ruling §4, rollback bằng pref không cần repack. Phía app sửa `BWGatePass`: (i) `ABKeyWindow()==nil` → fail-open `reason=nokeywindow` (lỗ hổng GPT chỉ đích danh: trước đây `key && …` lọt khi key nil), cửa sổ chạm phải là key window đã xác nhận; (ii) nhường pinch-in ở EXPANDED: HIDDEN + pinchAllowed=1 + pinchMode ENFORCE → `reason=pinchin` (tổ hợp này chỉ xảy ra ở EXPANDED vì owner cấp allowed ở SPLIT chỉ khi VISIBLE); (iii) đo truy ca seq=45: dòng probe thêm `stateSeq=` / `stateAgeMs=` / `stateFlips=` — KHÔNG sửa cơ chế nuốt khi chưa chứng minh race.

**KIỂM TĨNH ĐỘC LẬP: PASS.** Parity method so với baseline: 0 method mất ở cả 6 file (thêm: 9 method recognizer + 4 C function phía app; `bwHandlePinchNote:` + `BWEmitModesForBundle` phía owner; `SCPViewMeasureDesc` phía picker). Discriminator 10/12 chuỗi literal; 2 chuỗi `failopen=pinchin`/`failopen=nokeywindow` là dạng GHÉP RUNTIME (`failopen=%@` + reason) — coordinator chấp nhận vì đúng idiom log sẵn có, log xe sẽ in nguyên văn. kbstate bất biến; pinch hai nguồn pref tách nhau; hasContent không đổi; không `@available` ở dòng thêm; `git diff --check` sạch.

**BUILD CỤC BỘ: PASS.** AppBridge + SplitScreen từng module sạch; aggregate `make package FINALPACKAGE=1` PASS (candidate arm64 1.048.622 B); discriminator trong dylib đủ (SCPHomeLauncher 14 symbol theo nm ở bản debug cục bộ; `[pinch2]`/`[gate3]`/`[picker-measure]`/kênh pinch/migration marker đều có). Staging src→project: phép flatten import được kiểm chứng tái tạo đúng bản project baseline ở 6/6 file trước khi áp; diff project sau stage = +862/−32, khớp từng dòng với diff src.

**DOCK-RETIREMENT (ghép SAU 5 mảng + kiểm tĩnh, theo lệnh Nguyen 21:11):** cherry-pick commit GPT `39a42f2` (nhánh `feature/omnicar-home-grid-only`, nền `8a2c7aa`) → commit `76538c2` trên main, **0 xung đột, 0 hunk xử lý tay** (sau merge `711f89a`, nền hai cây khớp hệt bản GPT đã stage). Kiểm sau ghép: (a) cổng `SCPHomeLauncherEnabled()` nằm trong `refreshHomeButton` ở cả hai cây; nút dock tuỳ biến chỉ bị tháo khi nó đang tồn tại; mọi tham chiếu `homeButton` còn lại đều có guard, thuộc đường fallback (chỉ chạy khi launcher tắt), hoặc nil-safe (`AHPaintView` có nil-guard tường minh) — không tham chiếu treo. (b) Điểm giao nhau với phần Muse: GPT đã xử lý ngay trong thiết kế — AutoHide paint chạy qua nil-guard khi nút không tồn tại; nguồn hoạt động F3 (`homeButtonTapped`) được thay bằng đường Home: `SCPHomeLauncherConsumeLaunch` → `ahNoteActivity:AHSourceHome` (SCPHomeLauncher.m:300); khi nút không được tạo, `homeButtonTapped` đơn giản không bao giờ bắn. Phía Muse KHÔNG cần sửa thêm; điểm giao tiếp ghi nhận tại đây theo đúng kỷ luật. (c) Parity: danh sách method của SCPCarSplit.m giống hệt trước/sau cherry-pick → **danh sách miễn trừ RỖNG** (GPT loại bỏ bằng cổng có điều kiện, không xoá code; đường dựng nút fallback còn nguyên để hoàn nguyên). (d) Build lại sau ghép: chuỗi `[home-launch] custom Dock button detached` có trong dylib SplitScreen, SCPHomeLauncher còn đủ 14 symbol, discriminator hl2 còn đủ.

**SỰ CỐ TRONG VÒNG (ghi nguyên trạng):** (1) Output của exec chạy nền theo dõi run CI đầu tiên trả kết luận "SUCCESS" kèm dòng jobs ở định dạng lệnh không hề xuất — đúng tiền lệ output nền bịa đã ghi ở dự án này; kết luận đó bị BÁC BỎ, mọi trạng thái CI của vòng này đều truy vấn foreground trực tiếp. (2) Run dispatch `42634780665`: job `build-fat` kẹt queued và bị GitHub huỷ lúc 14:42:01Z — đúng 15 phút sau khi tạo, 0 step đã chạy → run kết luận failure. Đây là sự cố hạ tầng hàng chờ runner, KHÔNG phải lỗi build; run push-trigger `42634752999` đã được huỷ theo chủ đích trước đó. (3) Re-dispatch run `42637337416`: **SUCCESS 9/9 step** (gồm Verify FAT slices + Upload the FAT deb), xác minh foreground qua jobs API. (4) Rollback /usr tái diễn giữa phiên: sau khi build cục bộ đã xong, clang-18/llvm-18 biến mất khỏi VM; `fix-toolchain.sh` fail smoke test; host tự replay apt nhưng tới thời điểm ghi mục này clang-18 CHƯA trở lại. Hệ quả: phép kiểm lát FAT dùng parser Mach-O bằng Python + capstone (carve FAT, LC_SYMTAB, phân giải IMP qua relative method list, đếm eor) với positive control là FAT ytz5hl1 — kết quả dưới đây là đo trên chính artifact, không suy từ bản cục bộ.

**SẢN PHẨM — MỘT DEB TỔNG HỢP DUY NHẤT (hl2):** `com.anlai.omnicar_1.0.3-rebuilt-hl2-fat_iphoneos-arm64.deb` — **1.252.660 B — SHA-256 `9250ea0108ebd59b07b49ebf7d9cb07c4c6debbf4ef6932ed935ac740fd403b2`** — tại `handover/` của workspace. Members: debian-binary + control.tar.gz + data.tar.lzma. HEAD nguồn `76538c2` (main); ci-fat-test `613330e`; CI run `42637337416`. Kiểm hai lát (arm64 = arm64e trên mọi probe): SplitScreen `[pinch2]`×4, `[gate3]`×2, `[picker-measure]`×1, dock-detach×1, kênh pinch×1, kbstate (control)×1, `trayOverlay=%d`×1, symbol SCPHomeLauncher có mặt hai lát; AppBridge `[pinch2]`×13, `[gate3]`×1, kênh pinch + kbstate có mặt hai lát. **Knob: `publishKnobsNow` đúng 1 eor #1 ở cả hai lát** (IMP 0x13128/0x13a74, `eor w2, w26, #1`) — khớp positive control ytz5hl1 (binary khác hẳn, md5 dylib SplitScreen khác, IMP trùng vì hàm và mọi code trước nó trong TU không đổi).

**PENDING-DEVICE (chưa kết luận, chờ đúng một phiên xe gộp trên DEB này):** (1) Phím tự vẽ mặc định: mở ô nhập trong YouTube → panel hiện/gõ được/đóng được; chuỗi log `[ytz5-k5]` đủ mắt (migration nếu pref cũ =1; payload drawnKeyboard=1; dispatch show; gate nhan; responder became; publish); đóng phím → kbstate INACTIVE, AutoHide chạy lại sau 4 s. (2) Picker: mở bảng ở ô CÓ app → đọc `[picker-measure]` kết án lớp phủ; mở ở ô TRỐNG → vẫn nền đặc; đóng bảng sạch. (3) Pinch: SPLIT + controls hiện → pinch-out → `[pinch2] began/recognized` → owner accept → expand confirmed, app không tự zoom; EXPANDED (cả khi chrome đã mờ) → pinch-in → restore đúng tỉ lệ cũ; SPLIT + đang ẩn → pinch KHÔNG được nhận (wake thắng); đánh đổi đã khai: two-finger tap/scroll trên ô hosted có thể bị recognizer consume. (4) Gate 3 trial — CHỈ YouTube: controls ẩn → 1 chạm → logo hiện và app KHÔNG bị click; controls hiện → chạm tới app bình thường; app hosted khác vẫn DRY_RUN (chỉ log would). (5) Dock/Home: Home có đúng MỘT icon OmniCar, chạm mở panel; nút dock tuỳ biến biến mất, dock Apple gốc nguyên vẹn; nhấn giữ icon còn chạy; handle/knob AutoHide bình thường; ngắt/nối lại CarPlay rồi thử lại icon. (6) Hồi quy: YTZ, fullscreen/guard, native wake feed; nếu ca kiểu seq=45 tái diễn thì đọc `stateSeq/stateAgeMs/stateFlips`. Giữ nguyên các PENDING cũ: miễn trừ parity `bwHandleKbSyncNote:` chờ GPT phán cuối; weather/knob chưa có dữ kiện; VISUAL_ORIGINAL_COMPARISON; tầng model icon vẫn BLIND (W5).

### 29.14 Vòng hl3 — KHOÁ CỨNG phím CarPlay gốc cho app hosted theo LỆNH TRỰC TIẾP của Nguyen 22:14 [SOURCE + STATIC + LOCAL BUILD PASS; ĐÓNG GÓI GIỮ LẠI theo lệnh 22:19+ — chờ gộp fix pinch/Gate-3]

**QUYẾT ĐỊNH GHI ĐÈ (đọc trước mọi mục khác của vòng này):** Nguyen, chủ dự án, ra lệnh trực tiếp tại chat 22:14 09/11/2026: "quay về phím CarPlay TOÀN BỘ, không sử dụng phím tự vẽ". Lệnh này THẮNG phán quyết "drawn làm mặc định" của GPT (YTZ5HL1_LOG_REVIEW §4 + GATE3_PINCH_RULING §5) và THAY THẾ mảng K6 của §29.13 (hl2). Hệ quả đã biết và đã được báo rõ cho Nguyen: ở chế độ native, phiên ytz5hl1 đã chứng minh app hosted KHÔNG hiện bàn phím nào trên màn xe (§29.12, nhánh (i) — bridge vô tội, phím hệ thống không dựng cho scene hosted trên bộ máy này). **Nguyen đã biết và vẫn chốt** — đây là quyết định của chủ dự án, KHÔNG phải khuyến nghị của Muse; GPT đọc mục này để biết phán quyết phím của mình đã bị ghi đè bởi lệnh của chủ dự án.

**THAY ĐỔI (commit source `5eac902`, đúng 6 file cổng phím — 3 file × src+project, hai cây trùng byte như baseline):**
- Host `ABNativeKeyboardEnabled()` (ABHostBMethods.m): thân hàm thay bằng KHOÁ CỨNG — luôn trả YES (native), KHÔNG còn đọc pref `appBridgeNativeKeyboard`; block migration hl2 (ghi pref 1→0 + marker `appBridgeNativeKeyboardDrawnRestoredHl2`) bị XOÁ cùng đường đọc → marker hl2 dù đã ghi lên máy bởi bản hl2 cũng VÔ HIỆU ở bản này; pref cũ bất kỳ giá trị nào cũng không kéo được về drawn. Một dòng log mỗi tiến trình: `[ytz5-k5] hl3: native KHOA CUNG cho app hosted (lenh Nguyen 22:14, ghi de phan quyet drawn cua GPT); pref appBridgeNativeKeyboard + marker hl2 vo hieu`.
- Payload (ABHostGeometry.m): host luôn đóng dấu `drawnKeyboard=0`; dòng mode in `mode=native-locked-hl3`; dòng prefschanged đổi nhãn thành `cong ban phim: %@ (prefschanged; hl3 native khoa cung — che do khong do pref quyet dinh)` để phiên sau không đọc nhầm native là do pref. Mọi điểm dispatch/funnel giữ nguyên code hl2 — nay luôn rẽ nhánh native: `ABKeyboardDispatch` show → `dispatch show bi chan o cong native`; funnel kb-sync giữ luật native của K5.
- App (ABInApp.m): cache `ABDrawnKb` khởi tạo NO — khôi phục đúng giá trị khởi tạo của ytz5 (`e6b50a4`: `static BOOL ABDrawnKb = NO`) đã chạy trên xe; thêm khoá phía app: payload `drawnKeyboard=1` nếu có tới sẽ bị BỎ QUA (log một lần `[ytz5-k5] hl3: drawnKeyboard=1 bi bo qua — native khoa cung (lenh Nguyen 22:14)`), cache không bao giờ lật drawn ở bản này. Hệ quả hành vi = đúng cấu hình ytz5hl1: không blanking inputView cho panel (`ABSuppressSystemKeyboard` không chạy), không publish yêu cầu panel (`ABKeyboardPublish` im lặng cả hai chiều), host không dựng panel.
- Code phím tự vẽ GIỮ NGUYÊN trong cây (ABKeyboard + các đường drawn còn nguyên, Makefile không đổi — lệnh Nguyen 18:01: giữ code, khoá bằng cổng); các chuỗi của đường drawn còn trong binary là code được bảo tồn nhưng không tới được, KHÔNG phải hành vi.
- kbstate GIỮ NGUYÊN: diff ABInApp.m có 5 hunk (khối luật cổng + `ABDrawnKbNoteFrameInfo` + 3 chú thích ở `ABSuppressSystemKeyboard`/`ABResponderBecame`/`ABKeyboardPublish`) — 0 dòng chạm thân reporter kbstate (grep trên diff xác nhận).

**KIỂM TĨNH + BUILD CỤC BỘ: PASS.** Parity phạm vi: `git diff 76538c2` ngoài 6 file cổng chỉ có file hồ sơ — pinch (W6) / Gate-3 trial (G6) / picker-measure (P6) / dock-retirement / F6 giữ nguyên từng byte hành vi (discriminator còn nguyên trong source; kênh `bridgewake.v1.pinch` + `bridgewake.v1.kbstate` còn trong dylib build cục bộ). Toolchain: rollback /usr lại xảy ra (clang-18 biến mất) → `fix-toolchain.sh` FOREGROUND khôi phục, smoke test đạt. Build module OmniCarAppBridge sạch (link + ký); discriminator trên dylib cục bộ: dòng khoá hl3 phía host ✓, `native-locked-hl3` ✓, dòng bỏ qua phía app ✓ (lưu dạng UTF-16 vì chứa dấu —, đếm byte UTF-16LE = 1; hai symbol tĩnh `abKbHl3LockLogged` + `hl3DrawnIgnoredLogged` đều có), chuỗi `hl2 migration` VẮNG ✓, khoá marker `…DrawnRestoredHl2` VẮNG ✓ (chỉ còn trong chú thích source). Đã đồng bộ 6 file sang cây `omnicar-re/{src,project}`.

**SỰ CỐ ĐIỀU PHỐI (ghi nguyên trạng):** brief gốc của vòng này gồm cả bước đóng gói; việc sync ci-fat-test (merge `fc88f38`) + dispatch workflow 410962367 (run `42643457617`, kèm run push-trigger `42643457723`) đã THỰC HIỆN lúc 22:19:14 — gần như cùng giây lệnh GIỮ dispatch (22:19+) tới nơi, tức TRƯỚC khi điểm dừng mới được truyền đạt tới vòng này. Theo lệnh giữ: artifact của các run đó KHÔNG được tải, KHÔNG được giao, không cấu thành deb đợt này; khi fix pinch/Gate-3 gộp vào, ci-fat-test sẽ sync lại từ main và dispatch lại từ đầu.

**ĐIỂM DỪNG CỦA VÒNG (theo lệnh Muse chính 22:19+):** trạng thái = **source-complete / static PASS / local-build PASS — ĐÓNG GÓI GIỮ LẠI**. Không mở rộng sang pinch/Gate-3 trong lúc chờ. Việc tiếp theo thuộc vòng gộp: Muse chính đọc log phiên hl2 (§29.15 — picker hosted vẫn che, Gate-3 trial YouTube không nuốt, pinch rất khó nhận) → chẩn đoán theo bằng chứng → fix pinch/Gate-3 (+ picker nếu kết án) gộp vào CÙNG build hl3 này → khi đó mới sync ci-fat-test, dispatch, tải FAT `com.anlai.omnicar_1.0.3-rebuilt-hl3-fat_iphoneos-arm64.deb` và bổ sung mục sản phẩm vào đây. PENDING-DEVICE của riêng mảng phím ở bản gộp cuối: mở ô nhập trong app hosted → xác nhận chuỗi `[ytz5-k5]` toàn native (payload drawnKeyboard=0 mode=native-locked-hl3; 0 dòng dispatch show drawn; 0 publish drawn) và kbstate vẫn khép như ytz5hl1.

### 29.15 Phiên xe hl2 — BÁO CÁO TẠI XE của Nguyen (~22:19, 09/11) [CHỜ LOG ĐỐI CHIẾU]

**Nguồn:** Nguyen báo tại chat ~22:19 09/11/2026 về bản `com.anlai.omnicar_1.0.3-rebuilt-hl2-fat_iphoneos-arm64.deb` (SHA-256 `9250ea0108ebd59b07b49ebf7d9cb07c4c6debbf4ef6932ed935ac740fd403b2`, §29.13). Mọi verdict dưới đây là **mức màn hình tại xe, LOG PHIÊN CHƯA UP** — chờ log đối chiếu như mọi phiên trước. *Ghi chú số mục: §29.14 (hồ sơ vòng hl3 — khoá cứng phím native theo lệnh Nguyen 22:14) đang được vòng hl3 ghi và chưa có trên main tại thời điểm ghi mục này; §29.15 được nối ngay sau §29.13 trong file cho tới khi §29.14 về.*

**1. PICKER — THẤT BẠI TIẾP, có dữ kiện phân định mới theo loại app:** mở menu chọn app vẫn **ẨN NỘI DUNG ở app KHÔNG hỗ trợ CarPlay (hosted)**; app **NATIVE thì bình thường**. Lỗi chỉ xuất hiện ở ô hosted, không ở ô native — dữ kiện này thu hẹp hẳn phạm vi lớp phủ (phần tử phủ phải là phần tử chỉ tồn tại/gắn với đường hosted). Dòng đo `[picker-measure]` gắn ở vòng hl2 (§29.13, P6) sẽ kết án lớp phủ đích danh khi log về. **[CHỜ LOG]**

**2. GATE 3 TRIAL (YouTube) — THẤT BẠI ở mức màn hình:** chạm gọi logo **VẪN DÍNH APP** — video YouTube bị phát, tức cú chạm bị bấm trúng vào app, không bị nuốt, dù YouTube nằm trong phạm vi thử ENFORCE của hl2 (G6: packet theo pane chỉ cấp ENFORCE cho ô YouTube). Chờ log phân định mắt gãy thuộc nhánh nào: packet mode của ô có tới app không / điều kiện phía app không đủ / một fail-open nào đã mở đường (ứng viên đã biết từ thiết kế: key window rỗng, trạng thái kb chưa rõ, nhường pinch-in). **[CHỜ LOG]**

**3. PINCH — NHẬN RẤT KHÓ; CHIỀU BUNG 1–2 LẦN, CHIỀU THU THẤT BẠI HẲN:** Nguyen phải làm **rất nhiều lần mới zoom RA (bung) được 1 lần**; tổng cả phiên chỉ 1–2 lần thành công ở chiều ra; **zoom VỀ (chụm) không được lần nào**. Nguyên nhân **CHƯA RÕ**. Các ứng viên cơ chế chờ log `[pinch2]` phân định: (a) ngưỡng/điều kiện nhận diện quá khắt khe so với đường chạm qua CarCast (tỉ lệ phải vượt 1.10/0.90 kèm điều kiện mid-drift có thể hiếm khi đạt trên luồng chạm thực tế); (b) đường chụm-vào ở trạng thái EXPANDED — đặc biệt khi chrome đã mờ — bị chặn oan (bất biến SPLIT+HIDDEN không nhận là đúng thiết kế, nhưng EXPANDED+HIDDEN phải cho pinch-in đi theo tiền đề (b) của Gate 3); (c) tín hiệu pinch đã nhận diện nhưng bị owner loại ở một lớp validate, hoặc FS controller từ chối thu về. Nguyen hỏi cơ chế zoom đợt này hoạt động như thế nào — Muse chính đã giải thích trong chat: recognizer thật nằm **trong app hosted** (không phải recognizer quan sát phía CarPlayApp); ngưỡng tỉ lệ khoảng cách hai ngón **1.10 để bung / 0.90 để thu** + điều kiện mid-drift lấy nguyên văn từ `SCPPinchController` của bản gốc; khi nhận diện thì **huỷ chạm xuống app** (`cancelsTouchesInView`) để app không tự zoom/cuộn tranh chấp; tín hiệu qua kênh Darwin scoped `com.anlai.omnicar/bridgewake.v1.pinch` {hash, gen, session, seq, gid, dir, t} về owner; owner validate 6 lớp rồi gọi `SCPFullscreenAdapter` hai chiều (bung/thu qua FS controller hiện có); trạng thái **SPLIT + controls đang ẩn thì CỐ Ý không nhận pinch** (wake thắng, theo bất biến thứ tự của GPT). **[CHƯA KẾT LUẬN — CHỜ LOG]**

**4. HỆ QUẢ QUY TRÌNH — hl3 GIỮ DISPATCH:** vòng hl3 (đang sửa cổng phím theo lệnh Nguyen 22:14 — khoá cứng phím CarPlay gốc, ghi ở §29.14 khi hoàn tất) được lệnh **GIỮ dispatch CI**: chờ đọc log phiên hl2 này để **gộp fix pinch + Gate-3 theo bằng chứng log vào CÙNG bản hl3** — vẫn đúng một deb giao xe, không giao bản hl3 chỉ-sửa-phím trước.

**Trạng thái chờ:** log phiên hl2 (Nguyen up một lần) → phân tích ba lát `[picker-measure]` / `[gate3]` / `[pinch2]` → fix theo bằng chứng gộp vào hl3 trước khi dispatch. Các PENDING cũ giữ nguyên (parity `bwHandleKbSyncNote:` chờ GPT phán cuối; weather/knob chưa dữ kiện; VISUAL_ORIGINAL_COMPARISON; tầng model icon BLIND — W5).

### 29.16 Đối chiếu pinch hl2 với bản thành công 21–35 — kết luận: hl2 KHÔNG làm theo mẫu đã chứng minh [ĐÍNH CHÍNH THIẾT KẾ; HƯỚNG SỬA ĐÃ CHỐT]

**Nguồn:** Nguyen hỏi tại chat 22:21 09/11/2026: "Có làm đúng với bản thành công trước đây không?" Đối chiếu từ hồ sơ thi công hai phía (cơ chế bản 21–35 nền QA20 đã chứng minh trên xe, và §29.13 mục W6 của hl2). Kết luận thẳng: **pinch hl2 KHÔNG làm theo mẫu bản thành công 21–35** — khác ở 4 điểm cốt tử:

**1. KÍCH HOẠT.** Bản 21–35: recognizer **Began NGAY khi ngón thứ hai chạm xuống** — sự kiện chạm là điều kiện kích hoạt, không chờ hình học. hl2: recognizer chỉ nhận khi **tỉ lệ khoảng cách hai ngón đạt ngưỡng** (out ≥ 1.10 / in ≤ 0.90) **kèm điều kiện tâm giữa hai ngón không trôi quá giới hạn** (mid-drift ≤ 0.6×distChange + 10). Trên đường chạm qua CarCast, đạt đồng thời cả hai điều kiện là hiếm — khớp triệu chứng "làm rất nhiều lần mới trúng 1 lần" của phiên xe hl2 (§29.15).

**2. NGUỒN THÔNG SỐ.** Ngưỡng của hl2 lấy từ `SCPPinchController` của **bản GỐC 1.0.3** — thiết kế cho ngữ cảnh khác — trong khi cơ chế đã chứng minh 21–35, thứ duy nhất từng chạy thành công trên xe trong đúng bài toán này, **không được dùng làm đặc tả** khi thi công W6.

**3. CỔNG CHẶN.** hl2 xếp thêm nhiều lớp giữa ngón chạm và hành động: SPLIT+HIDDEN không bao giờ nhận; kb UNKNOWN chặn pinch; phía owner validate 6 lớp (hash/gen/stale/session/seq/state) rồi mới gọi FS controller. Bản thành công 21–35 gần như **không có cổng nào** giữa ngón chạm và hành động chuyển fullscreen — mỗi lớp cổng của hl2 là một điểm có thể nuốt mất cử chỉ thật.

**4. HƯỚNG.** Bản 21–35 **lật toggle theo TRẠNG THÁI fullscreen hiện tại**: đang thu thì bung, đang bung thì thu — trạng thái quyết định, cử chỉ chỉ là cò kích hoạt. hl2 **phân hướng theo hình học cử chỉ** (tách ra = bung, chụm vào = thu) và khoá hướng theo state latch lúc cặp chạm hình thành, sai hướng thì Cancelled. Hệ quả: hai chiều không đối xứng — khớp đúng triệu chứng phiên xe hl2: bung được 1–2 lần, **thu về 0 lần**.

**KẾT LUẬN:** đây là **lỗi CHỌN SAI MẪU THIẾT KẾ khi thi công hl2** — dù Nguyen đã chỉ đúng mẫu 21–35 ngay lúc 20:39 cùng ngày, trước khi W6 được thi công; đội vẫn dựng theo ngưỡng của bản gốc cộng thêm cổng. **Không phải giới hạn của xe hay phần cứng** — cùng xe, cùng màn hình, cơ chế 21–35 đã chạy.

**HƯỚNG SỬA ĐÃ CHỐT:** pinch làm lại **theo mẫu 21–35**: recognizer Began ngay khi ngón thứ hai chạm + `cancelsTouchesInView` (chặn app tiêu thụ — đúng chẩn đoán "app chạy quá nhiều" ở §29.11) + **toggle theo trạng thái fullscreen hiện tại**; **bỏ ngưỡng khoảng cách và điều kiện mid-drift khỏi điều kiện kích hoạt**. Phần sửa gộp vào build **hl3 đang giữ dispatch CI** (§29.15 mục 4), cùng sửa cổng phím theo lệnh Nguyen 22:14 (§29.14 khi hoàn tất). Picker và Gate-3 trial vẫn **chờ log phiên hl2 phân định** trước khi sửa — không suy đoán.

### 29.17 Đối chiếu wake/gọi logo OmniCar với DuoFace QA180 — khung giống, cơ chế quyết định KHÁC ở 2 điểm cốt tử [ĐÍNH CHÍNH THIẾT KẾ; LỆNH TÁI CẤU TRÚC ĐÃ CHỐT]

**Nguồn:** Nguyen chất vấn tại chat 22:24 09/11/2026: gọi logo 1 chạm đã qua bao nhiêu vòng rồi mà chưa hoàn thành; DuoFace rất khó mà đã làm được; ở đây có làm đúng yêu cầu của anh không, có làm đúng mẫu DuoFace không. Đối chiếu dưới đây lấy từ hồ sơ các vòng wake của dự án này và hồ sơ QA180 `h1wake3` của DuoFace (bản đã đạt trên cùng xe của Nguyen, 06/11/2026: 12 ca `swallowed=1`).

**1. SỐ VÒNG VÀ TRẠNG THÁI THẬT.** Chuỗi vòng wake: **wake1 → ytz1 → ytz2 → ytz3 → ytz4 → ytz5 → ytz5hl1 → hl2 (trial)**. Trong đó **4 phiên đo ở chế độ DRY_RUN có ca dương tính** (wouldSwallow=1 đúng tổ hợp ở ytz2/ytz3/ytz4/ytz5hl1), nhưng **phiên hl2 là lần ENFORCE thật đầu tiên** — và chỉ trong phạm vi thử 1 app (YouTube) — và đã **THẤT BẠI ở mức màn hình** (§29.15: chạm vẫn dính app, video bị phát). Phân định hai nửa phải nói tách bạch: **phần HIỆN logo** (chạm khi controls đang ẩn → controls hiện lại) **đã đạt từ lâu và đạt ổn định**; **phần NUỐT cú chạm đó** (chạm không được lọt xuống app) **chưa từng đạt trên xe ở dự án này — không một phiên nào.** Trả lời thẳng câu hỏi của Nguyen: số vòng nhiều như vậy mà phần nuốt vẫn chưa xong là sự thật đã ghi, không phải anh nhớ nhầm.

**2. ĐIỂM KHÁC CỐT TỬ (a) — HƯỚNG ĐỒNG BỘ TRẠNG THÁI ẨN/HIỆN.** QA180: host **ĐẨY** sự kiện `hidden`/`shown` **ngay khi** `layoutControls` đổi, qua kênh Darwin; phía app chỉ **giữ một biến local** cập nhật theo sự kiện đó; quyết định nuốt tại `sendEvent:` đọc biến local — **không tồn tại khái niệm độ tươi (freshness) trong đường quyết định**. OmniCar BridgeWake: trạng thái được **đóng gói 64-bit và phát định kỳ**, phía app phải giải mã kèm số học **freshness/gen/seq** rồi mới quyết định. Hệ quả đo được lặp lại ở mọi phiên: app có lúc quyết định trên **trạng thái cũ** — các ca `would=0` vì **stale** xuất hiện ở hết phiên này tới phiên khác (điển hình ytz5hl1: 4/9 ca đầy đủ điều kiện bị would=0 vì stale). QA180 không thể có loại ca này vì không có "độ tươi" để mà cũ.

**3. ĐIỂM KHÁC CỐT TỬ (b) — ĐIỀU KIỆN BÀN PHÍM.** QA180: điều kiện phím là **tri thức TẠI CHỖ của app** — cổng đọc `!kbSession` của chính tiến trình app (app tự biết mình đang có phiên nhập liệu hay không), không đi qua bất kỳ trung gian nào. OmniCar: sự thật phím đi một **vòng dài** — app báo → host (kbsync) → owner ghi record theo ô → owner đóng gói type-6 → app giải mã mới biết. **Mọi lỗi lịch sử của tính năng này đều sinh ra trên đúng vòng đó:** laundering ở ytz3 (act flag biến UNKNOWN thành bằng chứng ACTIVE), gen không tăng khi gán lại cùng bundle nên phiên cũ ghi đè phiên mới, snapshot cũ sống quá hạn thành stale. kbstate ở ytz5 sửa được **NGUỒN ĐO** (app báo trực tiếp phiên nhập liệu của mình theo hợp đồng W1/W2, chuỗi đã khép trên xe ở phiên ytz5hl1) — nhưng quyết định nuốt phía app **vẫn phụ thuộc bản tin đóng gói qua owner**, tức vòng trung gian vẫn nằm trên đường quyết định.

**4. HỆ QUẢ QUY TRÌNH.** QA180 chốt thiết kế xong thì **mở cổng và đo trên xe ngay** — bằng chứng lấy từ hành vi thật. OmniCar giữ DRY_RUN qua từng vòng vì **chuỗi bằng chứng do chính giao thức tự sinh ra không khép nổi**: mỗi vòng thiếu đúng một mắt xích mà giao thức tự tạo (laundering, gen, stale, cửa sổ chạm-trước-phím) — bằng chứng về giao thức, không phải bằng chứng về tính năng. ENFORCE thật vì thế tới hl2 mới chạy lần đầu, và vẫn thất bại ở mức màn hình (§29.15, mắt gãy cụ thể chờ log phân định — nhưng hai điểm khác cốt tử trên đây đủ để kết luận hướng thiết kế phải sửa mà không cần chờ log).

**5. LỆNH TÁI CẤU TRÚC — ĐÃ CHUYỂN VÀO BUILD HL3 ĐANG GIỮ CI.** Theo đúng mẫu QA180 đã chứng minh trên cùng xe: (i) trạng thái ẩn/hiện chuyển sang **ĐẨY sự kiện hidden/shown ngay khi đổi** qua Darwin + **biến local phía app**; **bỏ freshness/gen/seq khỏi đường quyết định nuốt** (gói định kỳ, nếu còn giữ, chỉ phục vụ chẩn đoán — không còn là điều kiện của quyết định). (ii) điều kiện phím lấy **trực tiếp từ reporter kbstate TẠI CHỖ trong app** (app tự quyết bằng phiên nhập của chính mình, như `!kbSession` của QA180); owner và kbstate **giữ nguyên vai cho AutoHide và chẩn đoán**, rút khỏi đường nuốt. (iii) ENFORCE giữ **phạm vi trial hosted (YouTube) + kill-switch** như G6 của hl2 — tái cấu trúc cơ chế đồng bộ, không nới phạm vi. Ghi rõ: đây là **sửa hướng theo mẫu đã chứng minh**, thực hiện theo lệnh/chất vấn của Nguyen 22:24 — không phải thêm một vòng đo nữa. Cùng build hl3 này còn chứa: pinch làm lại theo mẫu 21–35 (§29.16) và cổng phím native khoá cứng (§29.14); vẫn giữ dispatch cho tới khi cả ba phần gộp đủ, một deb giao xe.
