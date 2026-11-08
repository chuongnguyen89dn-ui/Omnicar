# VERIFY_OMCCommon — independent verification of OMCCommon_REPORT.md

Verifier #2 (wave 3), 2026-11-08. Method: my own capstone disassembly of
the original binaries + the 0-based resolver (`verify/macho_truth.py`);
sizes from LC_FUNCTION_STARTS + symtab in each binary independently.
The agent's normalized-stream comparator was NOT reused — my comparator
is stricter (keeps immediates, resolves references per binary).

**COUNTS: claimed-verified = 21 Core exports (20 shared + Core-only
_OMCTrustedTimeStart) | confirmed = 21/21 addresses+sizes, 19/20
cross-binary identity, all deep-checked semantics | downgraded = 1
sub-claim (CrashGuard cross-binary stream identity — see below) |
wrong = 0 | undeclared stubs = 0 (5 declared stubs, 5 markers in
source, exact 1:1).**

## Sizes / presence — all exact

My per-binary table (Core, AppBridge, CarProbe, SpeedBubble,
SplitScreen, StartupScreen, Prefs): all 20 shared functions have
**identical sizes in all six dylibs** — PrefsSync 12, Pref 104, Enabled
92, FeatureEnabled 144, Expired 252, LiteActive 348, CarWireless 1024,
LogRelayStart 132, HasMethod 180, CarClass 328, CheckHooks 1776,
MissingSelector 428, CarLaunchInfo 272, CrashGuard 4500, ProfileKeys
12, SupportedLanguages 12, CurrentLanguage 920, Tr 632, LogoMeshImage
148 — each matching the report's table to the byte.
**_OMCLogWrite is the sole size divergence: Core 424 vs 452 in the
other five**, as claimed. **_OMCTrustedTimeStart (196 B) exists only in
Core's symbol table** — absent from the other five dylibs and from
Prefs, as claimed.

(Note: the Prefs binary exports only 7 of the 20 names; several helpers
are inlined/local there — e.g. Prefs `_OMCEnabled` is a 100 B variant
calling CFPreferencesCopyAppValue directly, which I verified separately
in VERIFY_Prefs.md. Not a contradiction of this report, whose subject
is the dylib copies.)

## Semantics deep-checked firsthand

- `_OMCExpired` (Core stream vs AppBridge): token streams differ ONLY in
  the latch-byte bss offset (0x700 vs 0xc40) — same code. Deadline epoch
  claim **1809104400** = 2027-05-01 00:00:00 GMT+7 exactly (verified
  arithmetically; the parse block itself verified instruction-level in
  the Prefs copy, VERIFY_Prefs.md §1).
- `_OMCPrefsSync` @0x6528: `adrp/add @"com.anlai.omnicar"; b
  CFPreferencesAppSynchronize` — the claimed 12-byte tail branch, exact.
- `_OMCLiteActive` (Core vs SpeedBubble): every differing token traced
  to raw instructions — all are BSS/struct layout offsets (0x558 vs
  0xa18, …); the instruction streams are otherwise identical, including
  at the three sites where my annotator's per-binary labels disagreed.
- `_OMCLogWrite` variant mechanism: in AppBridge @0x1dd6c and
  SpeedBubble @0x21598 the copy loads its own module-name C string
  ("AppBridge" / "SpeedBubble") and calls `___strlcpy_chk` — the
  claimed `lastFeature` stamp with per-module names read from the
  binaries, confirmed in 2 of 5 firsthand (the other three share the
  452 B size and stream shape).
- `_OMCProfileKeys` content independently confirmed via the Prefs
  binary's constant array (14/14 keys, VERIFY_Prefs.md §5).

## Cross-binary identity verdict

- 8 functions: byte-stream identical (modulo address formation) in all
  five other dylibs under my strict comparator.
- 10 more (incl. Expired, LiteActive, CarWireless, CheckHooks, Tr,
  CurrentLanguage): identical instruction streams; all token diffs
  resolve to per-binary layout offsets or my annotator's label noise.
- LogWrite: genuinely divergent (confirmed above).
- **_OMCCrashGuard — downgraded sub-claim:** sizes identical (4500 B
  everywhere) and the token multiset matches, but the cleanup/exception
  regions appear in permuted basic-block order between binaries, so my
  stricter comparator cannot reproduce the report's "identical
  normalised stream" wording for this one function. Consistent with
  same-source/different-layout; recorded as *consistent, not
  independently reproduced* rather than confirmed. This does not affect
  the Core-side reconstruction itself (its call annotations were scored
  2006/2006 by ANNOTATION_AUDIT).

## Stub honesty

`grep STUB-UNRECOVERED`: OMCCommon.c ×3 (sub_b864, sub_bde0, sub_9bc0),
OmniCarCore.c ×2 (sub_60e4 tail, sub_4ca0 tails) — exactly the five
areas the report's "Unfinished" list declares, no more, no fewer.
0 undeclared stubs.
