# VERIFY — CarProbe (verifier #3, wave 3)

Counts: claimed 82/82 functions, 20/20 exports, 0 stubs / confirmed:
zero-caller claim (own call graph), constructor's single action +
diag stamp contents, env-var sharing (both ends), struct offsets at
every access site, 5 of 11 §7 INFERRED items spot-checked — contents
correct in all 5 / downgraded: 0 / wrong: 0 / undeclared stubs: 0.

Method: verifier's own capstone disassembly of the original
`OmniCarCarProbe.dylib` (arm64) + `verify/macho_truth.py` resolution;
the inherited `disasm/` dumps were not used as evidence.

## OMCCrashGuard has zero in-binary callers — CONFIRMED

Verifier's own call graph over all LC_FUNCTION_STARTS functions of the
arm64 slice: 1,627 direct `bl`/`b` edges collected. **No edge from any
function targets 0x5D94 (`_OMCCrashGuard`, confirmed as the defined
symbol at that address), and OMCCrashGuard does not call itself.** The
function is reachable only as an export — exactly the report's claim,
and the basis for its "redundant embedded copy" role analysis.
(Reconciliation note: my function-start walk yields 85 starts vs the
report's 82 calibrated functions; the delta is formatting/segmentation
— `_OMCCheckHooks` and `_sub_7308` rows carry "(+0x…)" merged cells in
§6, and 0x705C is an index-only label with no LC_FUNCTION_STARTS entry
— consistent with the report's own §3 reconciliation. It does not
affect the call-graph result.)

## Constructor's single action — CONFIRMED

`sub_6FB8` in full: `processInfo`/`processName`, two
`isEqualToString:` comparisons (the SpringBoard/CarPlay gate), then a
single `_dispatch_async` — nothing else. The dispatched block
`sub_7088` does exactly the claimed stamp:
- `stringWithFormat:` → `_OMCLogWrite` (build line);
- `stringWithFormat:` + `[NSDate date]` +
  `dictionaryWithObjects:forKeys:count:` →
  `_CFPreferencesSetAppValue` → `_CFPreferencesAppSynchronize`;
- the literals are in the block: C strings `1.0.3` (0xC76E) and
  `fbebb21` (0xC766), module name `CarProbe` (0xC740), and the
  `diagLoaded.` prefix CFString (0x10D98) — i.e. key
  `diagLoaded.CarProbe<ProcessName>` = {version 1.0.3, build fbebb21,
  date}, as reported (and the same pattern SplitScreenA found for its
  own `diagLoaded.SplitScreen@…` stamp).

## OMC_CRASHGUARD env sharing — CONFIRMED

- Publisher side: `OMCCrashGuard` calls `_setenv`; the strings
  `OMC_CRASHGUARD` and `%llx` are both referenced in the function —
  the pointer is published as hex.
- Adopter side: `sub_6F28` (session getter) calls `_getenv` on the
  `OMC_CRASHGUARD` string and `_strtoull` with `mov w2, #0x10`
  (base 16) at 0x6F54.
- Struct offsets, checked at every access site in the stamped/read
  paths against the source layout
  {+0x000 crashPath[0x400], +0x400 lastModule[0x40], +0x440 sessionStart}:
  - `OMCLogWrite` 0x4BA4: `add x0, x0, #0x400` — the lastModule stamp
    destination.
  - Crash-line writer `sub_7A00`: `ldr x9, [x8, #0x440]` (sessionStart,
    for `age=`) at 0x7B0C and `add x8, x8, #0x400` (lastModule, for
    `last=%s`) at 0x7B14 — the very site §3 flags as the inherited
    dumper's "class(NSCharacterSet)" false positive; it is the +0x400
    field, as the report says.
  - `OMCCrashGuard` 0x5E28: `str x0, [x8, #0x440]` — sessionStart is
    written at session creation.
  No access at any other large offset appears in these paths; the
  layout is consistent everywhere.

## §7 INFERRED spot-checks (5 of 11) — contents all correct

| # | Item | Verifier result | Label judgement |
|---|---|---|---|
| 1 | `liteMode` default = @2 | Constant object @0x11EA0 decodes (macho_truth) to `_OBJC_CLASS_$_NSConstantIntegerNumber` with value field at +16 = **2**, literal. | INFERRED appropriate — the inferred step is associating this object with the `liteMode` default, not the value. |
| 4 | Signal-handler open flags / 64-frame buffer "assumed equal" to exception handler | **Literal in both handlers**: `mov w1, #0x209` (O_WRONLY\|O_CREAT\|O_APPEND) at 0x75B0 / 0x7350; mode `mov w8, #0x1a4` (0644) passed on the stack at 0x75A8 / 0x7348; backtrace count `mov w1, #0x40` at 0x75C4 in the signal handler itself. | INFERRED is over-cautious — this could have been VERIFIED — but the contents are exactly right; erring toward honesty is not a defect. |
| 5 | sigaction flags word = SA_SIGINFO | The handler provably consumes `siginfo_t`: `ldr w19, [x22, #8]` (si_code) and `ldr x22, [x22, #0x18]` (si_addr) from the saved second argument; the format C string `signal %d (code %d) addr %p pid %d\n` exists verbatim (VA 0xC9B2) and `_dprintf`/`_getpid` are called. One `_sigaction` install site in the guard (0x6AB4), consistent with the signal-table loop. | INFERRED appropriate — siginfo consumption is proven; naming the copied flags word SA_SIGINFO remains an (unavoidable) interpretation. |
| 7 | sub_4EC8 selector names "inferred from arity" | All four names resolve **exactly** via the ObjC stubs: `attributesOfItemAtPath:error:`, `fileSize`, `removeItemAtPath:error:`, `moveItemAtPath:toPath:error:`; the threshold is literal `cmp x21, #0x200, lsl #12` = 0x200000 (2 MiB) at 0x4F1C; `.1` suffix via `stringByAppendingString:`. | INFERRED conservative; contents exactly right. |
| 11 | Gradient component packing | The four uint32s at 0xD0F0 are byte-exact: `0x00a0f1d9, 0x00fec4d8, 0x00a6ddfd, 0x00c9bafc`. | INFERRED appropriate — the constants are literal; only the byte→RGBA component order is reconstructed, as the item states. |

## Stub honesty — CONFIRMED

`OmniCarCarProbe.m` is 1,650 lines as claimed, contains **zero** STUB
markers and **zero** single-statement trivial return bodies
(source-wide scan), with 20 INFERRED markers in-source matching the
§7 disclosure practice. The "no stub bodies, no placeholder returns"
claim holds.

## Verdict

CarProbe's report is accurate on every priority claim, including the
strong zero-caller statement, which the verifier re-derived from a
full independent call graph. Two of the five spot-checked INFERRED
items (#4, #7) are in fact provable from the binary and could carry
VERIFIED; their contents are correct as written, so this is excess
caution, not error.
