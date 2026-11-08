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
