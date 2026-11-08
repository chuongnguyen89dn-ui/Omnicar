# VERIFY_SpeedBubble — independent verification (verifier #4, wave 3)

All disassembly below is my own (capstone 5.0.7 over the arm64 slice of
`payload/.../OmniCarSpeedBubble.dylib`), with names resolved only through
`verify/macho_truth.py` (0-based resolver). No agent dump was used as
evidence.

**Counts: packing sub-items checked 7 | confirmed 6 | wrong 1 (agent B's
bit-17 producer term) — display-side items checked 2 | confirmed 1
(palette) | wrong 1 (setSpeed: sentinel constant) | downgraded 0 |
undeclared stubs 0.**

---

## 1. BIT-17 ADJUDICATION (priority item — stated first, per brief)

**Verdict: agent A (display) is CORRECT. Agent B (source-app) is WRONG.**
State bit 17 (meta bit 1) is a limit-**valid** flag: it is SET iff the
published limit is >= 0, exactly symmetric with bit 16 for speed. The
binary producer and the binary consumer agree with each other and with
A's decode; only B's write-up of the producer inverts the condition.

### Producer — sub_5498 (`SPPPublishSpeed`), state assembly @0x5634–0x5694

Arguments confirmed at both call sites (0x5220 in the GPS-fix handler
sub_50c0, 0x6224 in sub_6098): x0 = speed, x1 = limit (the limit comes
from the current-limit getter sub_5734, which returns -1 when no limit
is known). The packing:

- bits 0..7 (limit byte): `bic w11, w20, w20, asr #31` (negative -> 0),
  then `csel w9, w11, #0xff, lt` -> clamp(limit, 0, 255). Negative limit
  becomes 0 **in this field**.
- bits 8..15 (speed byte): `csel` min 255, `lsl #8`, zeroed if speed < 0
  -> clamp(speed, 0, 255).
- meta bit 0 (state bit 16): `mvn w12, w19; lsr w12, w12, #0x1f` ->
  **1 iff speed >= 0** (speed-valid).
- meta bit 1 (state bit 17): @0x5660 `cmp w20, #0` (limit);
  @0x5664 `mov w11, #2`; @0x5668 **`csel x11, xzr, x11, lt`** ->
  x11 = **0 when limit < 0, 2 when limit >= 0**. So the term added to
  meta is `(limit >= 0 ? 2 : 0)` — SET means **valid**, the opposite of
  B's published formula `(limit < 0 ? 2 : 0)`. (B evidently read the
  csel's operand order backwards; the same file's other csels, e.g.
  `csel w10, wzr, w10, lt` after `cmp w19, #0`, zero-on-negative, follow
  the standard first-operand-on-true convention.)
- meta bit 2 (state bit 18): sceneCode in x13 = 4 iff on the main
  thread some foreground-active scene's session role does NOT contain
  the cfstring "InstrumentCluster" (@0x39238, resolved), else 0.
- meta bits 3..5 (state bits 19..21): `ubfiz x8, x8, #3, #3` over the
  host-index global @0x43800.
- `orr x1, x9, x8, lsl #16`; token lazily registered
  (`notify_register_check` on "com.anlai.omnicar/speedbubble.speed",
  cstring @0x2dd79, resolved) into @0x43818; `notify_set_state` then
  `notify_post`. Matches B's mechanics.

### Consumer — sub_cec4 @0xcec4

- w21 = low 32 bits of the notify state (`ldr w21, [sp, #8]`).
- app = `ubfx w21, #0x13, #3` (bits 19..21); gate
  `[SPPPrefs appEnabled:app]` first, early return if disabled.
- limit byte w22 = `and w21, #0xff`; speed byte w23 = `ubfx w21, #8, #8`.
- @0xcf28 `tst w21, #0x10000`; @0xcf2c `csinv w2, w23, wzr, ne` ->
  speed arg = byte if bit 16 set, else -1.
- @0xcf30 `tst w21, #0x20000`; @0xcf34 `csinv w3, w22, wzr, ne` ->
  limit arg = byte if bit 17 set, else -1.
- fg = `ubfx w21, #0x12, #1` (bit 18) -> `updateSpeed:limit:
  appForeground:app:` @0xcf40.

So the binary consumer treats bit 17 exactly as A documents ("bit 17
limit-valid, clear -> -1"), and the binary producer sets it exactly
when the limit is valid. **The pair is self-consistent; A's decode in
REPORT_A.md and SPPDisplayBoot.m is right in every field.**

### Exactly what must change (agent B's side only)

1. `SpeedBubbleB_REPORT.md` §3 (line ~121): the meta formula
   `+ (limit < 0 ? 2 : 0)` -> `+ (limit >= 0 ? 2 : 0)`.
2. `SBPublish.m` line ~98 (header comment formula) and line ~121 (code):
   `(limit < 0 ? 2 : 0)` -> `(limit >= 0 ? 2 : 0)`.
3. `SBPublish.m` header comment (~line 94): "no limit is signalled only
   through meta bit 1" is misleading as written — a negative limit is
   signalled by meta bit 1 being **clear** (and the limit byte clamped
   to 0). Suggest: "meta bit 1 is the limit-valid flag (set iff
   limit >= 0); a negative limit clears it".
Nothing on A's side changes: REPORT_A.md's channel table and
SPPDisplayBoot.m's `SPPConsumeSpeedNotification` match the binary
instruction-for-instruction (A decodes before the appEnabled: gate
where the binary gates first — semantically identical, decode has no
side effects).

### Rest of the packing — re-verified both ends

| Field | Producer (sub_5498) | Consumer (sub_cec4) | A | B |
|---|---|---|---|---|
| bits 0..7 limit byte, clamp 0..255, neg->0 | ✓ | ✓ | ✓ | ✓ |
| bits 8..15 speed byte, clamp 0..255, neg->0 | ✓ | ✓ | ✓ | ✓ |
| bit 16 speed-valid (set iff speed>=0; clear->-1) | ✓ | ✓ | ✓ | ✓ |
| bit 17 limit-valid (set iff limit>=0; clear->-1) | ✓ | ✓ | ✓ | **✗ inverted** |
| bit 18 sceneCode/foreground (4 iff FG scene role lacks "InstrumentCluster") | ✓ | ✓ | ✓ | ✓ |
| bits 19..21 host/app index (global @0x43800, ubfiz #3,#3 / ubfx #0x13,#3) | ✓ | ✓ | ✓ | ✓ |
| channel name + lazy token + set_state/post mechanics | ✓ | n/a | ✓ | ✓ |

## 2. Display-side spot-checks (REPORT_A)

### applyColor: palette table @0x32C30 — CONFIRMED byte-exact

Read the table myself from `__const` (uint32 0xRRGGBB, indexed by the
colour index as in `-[SPPBubbleView applyColor:]` @0x118f4):

```
[0] 0x000000 (unused)   [4] 0x2F8FE0 = (47,143,224)  blue
[1] 0xFFFFFF = (255,255,255) white   [5] 0x16A87F = (22,168,127)  teal
[2] 0x16182A = (22,24,42) near-black [6] 0xE8558C = (232,85,140)  pink
[3] 0x7C5CF0 = (124,92,240) violet
```

All six entries match REPORT_A.md and the table embedded in
SPPBubbleView.m exactly.

### SPPBubble -setSpeed: publish — mechanism CONFIRMED, sentinel WRONG

My disassembly of `-[SPPBubble setSpeed:]` @0x17d64:

- stores the **raw** argument at ivar +0x10 (unclamped) ✓ as A writes;
- returns early if `demoTimer` is non-nil (demo suppression) ✓;
- clamp: @0x17d94 `cmp w19, #0xff; csel w8, w19, #0xff, lo`
  (min(v,255)), @0x17da0 `cmn w19, #1`, @0x17da8
  `csel w19, w8, w9, gt` with w9 loaded @0x17da4 by the raw encoding
  0x529FFFE9 = **MOVZ w9, #0xFFFF** (verified at the byte level — not
  MOVN). So: speed >= 0 -> min(speed, 255); **speed < 0 -> 65535
  (0xFFFF)**, NOT -1;
- dedup against the static @0x43790 (`cmp x8, x19; b.ne`) ✓;
- lazy `notify_register_check` token @0x439dc on
  "com.anlai.omnicar/speed" (cstring @0x2edd4) ✓; `notify_set_state`
  then tail `notify_post` ✓.

**Fix required** in `SPPBubble.m` (~line 134 comment and ~line 137):
`(speed < 0) ? -1 : MIN(speed, 255)` -> `(speed < 0) ? 0xFFFF :
MIN(speed, 255)`, and the comment "negative -> -1" -> "negative ->
0xFFFF (65535)". (Note for the coordinator: `metadata/
SPEED_CHANNEL_TRACE.md` repeats A's -1 sentinel for this channel and
needs the same correction; its "no consumer in package" conclusion is
unaffected.)
