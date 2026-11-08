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
