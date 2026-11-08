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
