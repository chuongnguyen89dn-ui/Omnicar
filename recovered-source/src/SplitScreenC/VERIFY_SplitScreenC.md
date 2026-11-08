# VERIFY — SplitScreen-C (Home / app-icon injection family)

Verifier #5, independent pass. All disassembly is my own (capstone 5.0.7),
names resolved only through `verify/macho_truth.py` (chained fixups +
LC_DYSYMTAB) and `metadata/xref/OmniCarSplitScreen.json`. The module
agent's dumps were never used as evidence. Target:
`OmniCarSplitScreen.dylib`, arm64 slice (arm64e where stated).

**COUNTS: claimed 98 functions (83 VERIFIED / 14 INFERRED-aspect /
1 NOT-RECOVERED) | confirmed: all 5 priority areas, incl. every
priority-1 function body | downgraded 2 | wrong 1 | undeclared stubs 0.**
Table arithmetic re-counted from the report's §7: 98 rows =
81 pure-V + 2 V-with-data-note + 3 V-body/I-aspect + 11 I + 1 N, i.e.
83 V-outright / 14 with an INFERRED aspect / 1 N — consistent with the
report's own summary.

---

## P1 — Injection mechanism: CONFIRMED (one wrong detail, see below)

- **`_SCPInjectDeclarationIfChosen` (0x9b34)** — body read in full.
  bid via `SCPHomeSafeGet(info, "bundleIdentifier")`; membership test
  against `_SCPChosenPhoneApps()`; existing-declaration refusal with
  the log `AppIcons: %@ da co declaration that (app CarPlay) -> khong
  chen`; `objc_getClass("CRCarPlayAppDeclaration")` (cstring at
  0x5f701 verified); guarded setters in order
  `setSupportsTemplates:` with **w2 = #0 (NO)** @0x9c68,
  `setSupportsMaps:` with **w2 = #1 (YES)** @0x9cf0,
  `setBundleIdentifier:` = bid, `setBundlePath:` from
  `bundleURL` (NSURL→path / NSString passthrough); KVC set of
  `_carPlayDeclaration` via sub_a3c4 with early return on failure;
  tag array built as the constant `@[@"OmniCarAppBridge"]`
  `arrayByAddingObjectsFromArray:` (prepend ✓) and KVC-set to `_tags`;
  `isValid` probe → if NO, KVC set `_valid` = `kCFBooleanTrue`
  (GOT `___kCFBooleanTrue` @0x9f40); injected set obtained from
  sub_9a1c, `objc_sync_enter/exit`, the set object loaded from the
  global slot **0x880c0** exactly as claimed, contains/add, first-time
  log with isHidden/isInstalled/presentsFullScreen probes. ✔
- **`_SCPChosenPhoneApps` (0x9a60)** — `_OMCFeatureEnabled(@"appBridge")`
  gate, `_OMCPrefsSync`, `_OMCPref(@"appBridgeApps", nil)`, NSArray →
  `[NSSet setWithArray:]`, else empty set. ✔
- **`_SCPAddChosenAppsToLibrary` (0xa500)** — per chosen bid:
  `applicationInfoForBundleIdentifier:` lookup, skip if an info exists;
  else `SCPValidProxyForBundle` (0xa860: `objc_getClass` cstring
  "LSApplicationProxy" verified, `applicationProxyForIdentifier:`,
  `appState` → `isValid` guard ✔); nil proxy → skip log; else
  `addApplicationProxy:withOverrideURL:` with nil override; final log
  `AppIcons: them %lu / %lu app da chon vao thu vien %@`. ✔
- **Crash guard** — `_SCPAppIconsBeginInjection` (0xc37c): sync; if
  `splitScreenIconsPending` boolValue → log, `SCPHomePrefSet(
  "splitScreenIconsCrashed", @"1.0.3")` (cfstring "1.0.3" @0x7a840 in
  both writes), clear pending; then `isEqual:@"1.0.3"` on the crashed
  pref → return NO (`eor w0, w20, #1`); else arm pending with
  `kCFBooleanTrue` and return YES. ✔ `_SCPAppIconsCarScreenOK`
  (0xc570): if pending set → clear + log. ✔ `_SCPAppIconsRetry`
  (0xb044): if crashed pref non-nil → clear + log. ✔
- **Debounced resync** — `_SCPRefreshAppIconsSoon` (0xaa10): counter
  global at **0x880d8** incremented and captured as token;
  `dispatch_time(0, 0x2faf0800)` = **800,000,000 ns = 0.8 s** ✔;
  `dispatch_after` on `__dispatch_main_q` with invoke 0xaa90.
  Block 0xaa90: re-reads chosen set, calls `_SCPAppIconsRetry`
  @0xab34 on change, fetches library via `"library"` /
  `"sharedApplicationLibrary"`, removes proxies for un-chosen bids
  (`removeApplicationProxy:`), re-adds via 0xa500, and posts the
  library-refresh block after `dispatch_time(0, 0x3b9aca00)` =
  **1 s** ✔. All as reconstructed.

### WRONG (1) — the two `tags` reads in sub_9b34
`SCPAppIcons.m` reconstructs (a) the already-ours check as
`SCPHomeSafeGet(decl, @"tags")` and (b) the pre-prepend read as
`SCPHomeSafeKVCGet(info, @"_tags")`.
The binary does neither: at **0x9bc0–0x9bcc** and again at
**0x9e54–0x9e60** it calls **sub_a26c (SCPHomeSafeGet) on info
(x19) with the cfstring `"tags"`** in both places. (The `_tags` KVC
*write* at 0x9eb0 via sub_a3c4 is correct as written.) Behavioural
delta is small — a repeat load of an app whose info already carries a
real declaration is refused via the log path instead of returning
silently as "already ours" — but the function is labelled VERIFIED
and both reads are misattributed. Fix: read `tags` from `info` via
`SCPHomeSafeGet` at both sites. Cosmetic nits in the same function,
not counted: the source adds an `isKindOfClass:[NSString class]` test
on the bid that the binary does not make (it sends `length` directly).

## P2 — Visibility filter: CONFIRMED

- **Protected array @0x80380** (`__objc_arrayobj`, count 5, element
  buffer in `__objc_arraydata` @0x7feb8) decodes, in order, to exactly
  `com.apple.mobilephone`, `com.apple.Music`, `com.apple.Maps`,
  `com.apple.MobileSMS`, `com.apple.InCallService` (cfstrings
  0x7aca0/0x7acc0/0x7ace0/0x7ad00/0x7ad20). ✔
- **`_SCPIconHiddenOnCar` (0xb5ec)**: hidden set (sub_b78c); nil icon
  or empty set → NO; bid via sub_b82c (key list @0x80398 =
  `applicationBundleID`, `leafIdentifier` — verified against
  `__objc_arraydata` @0x7fee0); not in hidden set → NO; then, for a
  non-empty NSString bid: protected-array `containsObject:` →
  NO, `hasPrefix:@"com.apple.CarPlay"` → NO, `rangeOfString:
  @"NowPlaying"` found → NO; `_SCPIsInjectedPhoneApp` → NO;
  sub_b310 installed check → NO if not installed; else LogOnce +
  YES. ✔ (Order in the binary: list/prefix/substring, then injected,
  then installed — same as source.)
- **`_SCPIconForcedOnCar` (0xbb20)**: shown set (sub_bc44); bid in
  shown set; then hidden set (sub_b78c) `containsObject:` — if present
  the YES path is skipped: **an explicit "shown" entry loses to a
  "hidden" entry**, exactly as claimed. ✔ (Cosmetic nit: the binary's
  LogOnce prefix is `hien lai (iOS da bo trong Tuy chinh,
  isIconVisible: YES):`, the source paraphrases it; log text only.)
- **Hook 0x5338 (`isIconVisible:`)**: `_SCPIconHiddenOnCar` true →
  return NO; else orig IMP loaded from slot **0x88020** and called;
  if orig result is NO, `_SCPIconForcedOnCar` upgrades it to YES
  (`csel` @0x53c8); two nested catch regions call sub_5520 with the
  cstring tag `"isIconVisible"` (@0x5ebf7 verified). Source body in
  `SCPHomeHooks.m` matches this flow exactly. ✔

## P3 — The two renames: BOTH CONFIRMED

- **sub_22210 = `SCPChosenPhoneAppInfos`, not a count.** The body
  (1,300 B) builds an `NSMutableArray` (`array` @0x22248), gates on
  `_OMCFeatureEnabled(@"appBridge")`, intersects via sub_48864
  (`SCPBridgedChosenApps`), and per app builds an `NSDictionary` via
  `dictionaryWithObjects:forKeys:count:` with cfstring keys **`id`**
  and **`name`** (@0x224c0/0x224cc), `addObject:`s it, then sorts with
  `NSSortDescriptor sortDescriptorWithKey:@"name"` +
  `sortUsingDescriptors:` and returns the array through
  `objc_autoreleaseReturnValue`. It returns the sorted
  `[{id, name}]` array; A's placeholder `SCPChosenPhoneAppCount` is
  refuted. ✔
- **sub_5520 = `SCPLogException`, not "SCPHomeKick".** The body takes
  (const char *tag, exception), sends `callStackSymbols`, formats
  `LOI trong %s: %@\n%@`, and writes it via `_OMCLogWrite(
  @"SplitScreen", …)`. It is a pure exception logger; nothing in it
  kicks/refreshes anything. A's guess is refuted. ✔ The source body in
  `SCPHomeHooks.m` reproduces it faithfully.

## P4 — Dead-code claim: CONFIRMED

Re-derived with my own scan (both slices of SplitScreen + all seven
other payload binaries):

- Direct-branch targets over the whole `__text`, adrp+add/ldr
  materialization (10-instruction window), and a fixup-decoded scan of
  every pointer slot in every non-`__TEXT` section (covers GOT, data
  tables and block literals in `__DATA_CONST,__const`): **zero**
  references to any of the four, in either slice (arm64 VAs
  0xb1f8/0xdeac/0xe0c0/0xe410; arm64e VAs 0xb84c/0xe6d0/0xe90c/0xec84 —
  note the slices have different layouts and were scanned with their
  own addresses).
- The only raw LE64 occurrence of each VA in each slice is the
  function's own `nlist` record inside LC_SYMTAB (arm64 fileoffs
  0x8abb8/0x8abc8/0x8abe8/0x8ac18 ∈ [0x8a8c0, 0x8bf80); arm64e fileoffs
  0x8ebc8/0x8ebd8/0x8ebf8/0x8ec28 ∈ [0x8e8d0, 0x8ff90)) — its
  definition, not a reference.
- The other seven binaries contain **no** undefined symbol, definition,
  or name string (`_SCPCarAppIcon` etc., with or without the leading
  underscore — the dlsym route) for any of the four.
- All four are defined symbols and LC_FUNCTION_STARTS entries, as
  claimed. `_SCPHomeAppRemovable`'s reconstructed body is consistent
  with the NSString branch of sub_b5ec (protected → injected →
  installed), matching its "VERIFIED body" label.

Dead code: **no caller anywhere. Confirmed.**

## P5 — Stub honesty: CONFIRMED, with two downgrades of declared gaps

- Exactly **one** `// STUB-UNRECOVERED` exists in the module's source:
  `SCPDiagWalkIcons` (sub_d324) in `SCPDiagDump.m`, with an honest
  explanation and a send/string profile. ✔ A trivial-body sweep of
  all nine source files found no other unmarked stubs — every short
  body is a real accessor/wrapper (safe getters with @try/@catch,
  the `objc_storeWeak` one-liner at 0xaa00, the libroot fallbacks
  returning `""` / `"/var/jb"` / zero UUID at 0x42ac/0x42b8/0x42c4,
  the dispatch_once accessors). **Undeclared stubs: 0.** ✔
- **§6.2 (slot 0x87f60) — DOWNGRADED: the gap closes.** The slot is
  not an anonymous function pointer awaiting an installer: 0x87f60
  lies in `__DATA,__thread_vars` and is a **thread-local variable
  descriptor** whose first word binds to **`__tlv_bootstrap`**
  (raw 0x8000000000000124, import ordinal 0x124). sub_55f4 @0x5624–
  0x5634 loads that word and `blr`s it — the standard `__thread`
  access sequence — receiving a pointer to the per-thread
  re-entrancy byte, which it tests (`ldrb` @0x5634) and sets
  (`strb` @0x569c) around its re-query of `_SCPHomeGridColumns` /
  `_SCPHomeGridRows`. Nobody in the family or in B installs the
  pointer; dyld's TLV machinery owns it. The agent's mechanism
  description ("calls it to obtain a pointer to its re-entrancy
  byte") is exactly right — only the "identity NOT-RECOVERED"
  framing is over-cautious. Identity: `__tlv_bootstrap` / a
  `__thread BOOL` guard.
- **§6.3 (sub_cde0 truncation) — DOWNGRADED: datum is recoverable,
  and the source body omits the operation.** At 0xce50–0xce5c the
  stream is `cmp x0, #0x5dd; b.lo …; mov w2, #0x5dc; substringToIndex:`
  — descriptions longer than 1500 are truncated to
  **1500 (0x5dc)** characters before the `DIAG %@ description: %@`
  log. The limit was declared "not decoded", which is honest, but it
  is a plain immediate in the instruction stream, and
  `SCPDiagDescribe`'s reconstruction in `SCPDiagDump.m` logs the
  untruncated description (flagged only by a NOTE comment). A
  VERIFIED label on this body overstates it; the fix is one line:
  `if (desc.length > 1500) desc = [desc substringToIndex:1500];`

## Minor notes (not counted)

- `SCPDiagDump.m` header comments call 0xd6ec/0xd830 "VERIFIED" while
  the report table marks both I; the report is the conservative and
  correct label.
- `SCPHomeHooks.m`'s header repeats A's "17 MSHookMessageEx" figure
  for `__init_0`; verifier #3 established the count is 16 (A's error,
  parroted in C's comment — the hook bodies themselves are unaffected).

## Bottom line

The family's core claims survive independent re-derivation: the
declaration-injection mechanism, the crash-guard state machine, the
0.8 s resync, the visibility protections with shown-loses-to-hidden,
both renames, and the dead-code finding are all **confirmed** against
the binary. One real (small) error: the two `tags` reads in
`SCPInjectDeclarationIfChosen` are taken from `info` via
`SCPHomeSafeGet`, not from the declaration / via KVC as written.
Both declared data gaps are smaller than stated — the 0x87f60 pointer
is `__tlv_bootstrap` of a `__thread` guard, and the sub_cde0
truncation limit is 1500.
