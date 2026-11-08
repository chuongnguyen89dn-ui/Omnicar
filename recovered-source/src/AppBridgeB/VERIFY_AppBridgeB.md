# VERIFY — AppBridgeB (verifier #3, wave 3)

Counts: claimed module-B scope (§8 table: ~60 C-function groups + ABPane
35 methods + ABHost B set + ABKeyboard/ABKey sets, statuses V with C for
keyboard cosmetics and the Telex branch tree) / confirmed: keyboard
packed format at BOTH ends (7/7 bit fields + FNV constants), apporient
packing (3/3 fields), 0.25 s debounce constant + cancel, delay array
byte-check (3/3 doubles), zoom default @80 (binary + final source),
FBScene swallow branch structure / downgraded: 0 / wrong: 0 /
undeclared stubs: 0.

Method: verifier's own capstone disassembly of the original
`OmniCarAppBridge.dylib` (arm64), slots/constants resolved via
`verify/macho_truth.py` only — never the agent's dumps.

## appbridge.keyboard packed uint64 — CONFIRMED at both ends

Producer `sub_6AD4` (own disassembly):
- `mov w24, w20` (shown arg) on the shown path, `mov x24, #0` on the
  hidden path → **bit 0 = shown**.
- `bfi x24, x0, #1, #7` (0x6b4c) after `keyboardType` → **bits 1..7**.
- `bfi x24, x0, #8, #8` (0x6b7c) after `returnKeyType` → **bits 8..15**.
- FNV-1a-32 over bundleID UTF8String: basis built as
  `mov w9, #0x9dc5; movk w9, #0x811c, lsl #16` = **0x811C9DC5**; prime
  `mov w11, #0x193; movk w11, #0x100, lsl #16` = **0x01000193**; loop
  `eor` then `mul` per byte.
- `ubfiz x25, x9, #0x18, #0x20` (0x6bf8) → **hash << 24, bits 24..55**;
  `orr x1, x25, x24` → `_notify_set_state`.

Consumer `sub_93B0` (own disassembly):
- `lsr x2, x8, #0x18` → `bundleForHash:(state >> 24)`.
- `tbnz w8, #0, #0x947c` → bit-0 branch.
- `ubfx x3, x8, #1, #7` = keyboardType; `ubfx x4, x8, #8, #8` =
  returnKeyType; selectors present: `hideForApp:`,
  `showForApp:keyboardType:returnType:`. State read via
  `_notify_get_state`. Every field of §3.1 matches.

## apporient packing + debounce — CONFIRMED

Producer `sub_67FC`: `and x25, x22, #0xff` (orientation, bits 0..7);
`bfi x25, x20, #8, #0x10` (supported-mask, bits 8..23); FNV-1a with the
same two constants; `ubfiz x24, x9, #0x18, #0x20` (hash << 24);
`orr` → `_notify_set_state`.
Debounce `sub_6750`: calls `_dispatch_block_cancel` (previous block),
`_dispatch_block_create`, `_dispatch_time`, `_dispatch_after`; the
delay is built as `mov w1, #0xb280; movk w1, #0xee6, lsl #16` =
**0x0EE6B280 = 250,000,000 ns = 0.25 s**. ✓

## Delay array @[0.3, 1.5, 4.0] — CONFIRMED byte-for-byte

`__objc_doubleobj` (0x39570, 0x30 bytes) = 3 entries of 16 bytes
{isa fixup, double}: entry values at +8 are **0.3** (0x39578),
**1.5** (0x39588), **4.0** (0x39598) — the only occurrences of the 1.5
and 4.0 bit patterns in the slice. §5's verdict (deferred
fake-orientation event scheduled at all three delays) rests on a true
constant array.

## Zoom default @80 — CONFIRMED (binary and final source)

`__objc_intobj` entry at 0x395A0 with the 24-byte layout
{isa, flags, value}: isa decodes (macho_truth) to a bind for
`_OBJC_CLASS_$_NSConstantIntegerNumber`, value field at +16 = **80**.
The `appBridgeFps` default entry at 0x395E8 reads value **0**, also as
reported. Final source `ABHostBMethods.m` (-zoom, 0xAE20) uses
`OMCPref(@"appBridgeZoom", @80)` and documents the earlier @100
mis-decode and its correction in place — the claimed self-correction
is real, and the final text agrees with the binary.

## FBScene backgrounded-update swallow — CONFIRMED

Own disassembly of `sub_74B4` (`updateSettings:withTransitionContext:
completion:` replacement, orig slot 0x3EA00):
- `-[ABHost shared] hostsApp:` at 0x75F0; `tbz w0, #0, #0x7650` — not
  hosted → fall through to the orig call.
- Hosted: selector built by `_NSSelectorFromString` from the CFString
  at 0x35950, whose character pointer decodes to **`isForeground`**;
  invoked via plain `_objc_msgSend` (0x7628), result in w26.
- `tbnz w26, #0, #0x7660` — foreground → orig path. When the value is
  false (isForeground == NO), control branches at 0x764c directly to
  the release/return epilogue at 0x7680, **skipping the only orig-IMP
  call** (loaded 0x7664, `blr` 0x767c). `_objc_begin_catch`/
  `_objc_end_catch` are present (fail-open), as reported.
This is the maintain mechanism exactly as §4 describes.

## Stub / condensed honesty vs §9 — CONFIRMED

- No `STUB`/`UNRECOVERED` markers anywhere in the module source —
  consistent with §8/§9, where NR items are exclusively other modules'
  bodies (A's blocks, Core scaffold), declared as such.
- The condensed areas are declared **in-source at the site**, not only
  in the report: `ABTelex.m` header ("the one knowingly condensed area
  of module B", dispatch-level reconstruction, verbatim tables) and
  `ABKeyboard.m` ("cosmetic detail condensed", "cosmetic; condensed")
  — matching §9 items 1–2.
- Source-wide scan for single-statement trivial bodies found exactly
  one: a `@catch` clause returning YES (fail-open exception handler,
  consistent with the binary's begin/end-catch pattern in sub_74B4).
  No undeclared trivial method bodies.

## Verdict

AppBridgeB's priority claims are all accurate: the keyboard channel
format is proven at both ends bit-for-bit, the timing constants are
byte-exact, the @80 zoom correction is genuine, and the FBScene
swallow works as reconstructed. Nothing downgraded.
