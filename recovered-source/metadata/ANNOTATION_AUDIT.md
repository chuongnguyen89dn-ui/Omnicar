# ANNOTATION_AUDIT — fidelity of the wave-2 disassembly dumps

Produced by the rolling verifier (wave 2.5), 2026-11-08 ~02:20–02:35 UTC.
Question answered: **can the reconstruction reports trust the callee/data
annotations printed in `src/*/disasm/`?**

## Method (independent of every module agent)

Ground truth was resolved from the original binaries by a verifier-written
resolver (`verify/macho_truth.py`), never from an agent's own output:

- `bl`/`b` target in `__stubs` → import name via the **LC_DYSYMTAB indirect
  symbol table** (no fixup decoding involved).
- Target in `__objc_stubs` → selector obtained by hand-decoding the stub
  (adrp/ldr → selref slot → dyld chained-fixups format-6 decode → string in
  `__objc_methname`).
- Target = plain `_objc_msgSend` stub with a claimed selector → the selector
  was recovered by the verifier's **own capstone pass** over the enclosing
  function (boundaries from LC_FUNCTION_STARTS), tracking the selref load
  into x1.
- Data slots (classref/selref/got) → slot resolution by the same fixup
  decoder, class names read out of the class struct's ro-data.
- The decoder itself was adjudicated on three disputed SpeedBubble slots
  (see below) and is semantically certain in all three.

Extractors: `verify/audit_calls.py`, `verify/audit_data.py`; raw results in
`verify/audit_calls.json`, `verify/audit_data.json`.

## Call annotations — FULL population, all modules

| Module (binary) | Files | Annotated bl/b | Calls checked | Exact correct | Cosmetic¹ | Wrong | Imprecise | Unresolvable |
|---|---|---|---|---|---|---|---|---|
| OMCCommon (Core) | 104 | 2,014 | 2,006 | 2,006 | 0 | 0 | 0 | 0 |
| App | 1 | 117 | 117 | 117 | 0 | 0 | 0 | 0 |
| AppBridgeA | 419 | 9,754 | 8,074 | 8,074 | 0 | 0 | 0 | 0 |
| AppBridgeB | 249 | 16,233 | 13,201 | 13,201 | 0 | 0 | 0 | 0 |
| CarProbe | 81 | 3,248 | 3,040 | 2,946 | 92 | 2² | 0 | 0 |
| Prefs | 33 | 19,868 | 19,868 | 19,868 | 0 | 0 | 0 | 0 |
| SpeedBubble | 496 | 9,750 | 8,476 | 8,476 | 0 | 0 | 0 | 0 |
| SplitScreenA | 312 | 6,876 | 6,870 | 6,870 | 0 | 0 | 0 | 0 |
| SplitScreenB | 138 | 5,485 | 5,485 | 5,485 | 0 | 0 | 0 | 0 |
| StartupScreen | 513 | 20,674 | 19,572 | 18,990 | 572 | 10² | 0 | 0 |
| **Total** | | | **86,709** | **86,033** | **664** | **12²** | **0** | **0** |

¹ Cosmetic = the callee name is right but written without its leading
underscore (`OMCLogWrite` for `_OMCLogWrite`, StartupScreen + CarProbe only).

² The only 12 non-cosmetic misses in 86,709 are **not mislabels**: the dumper
itself printed `_objc_msgSend(?)` — an explicit "unknown" — at selector-stub
call sites whose selector was in fact recoverable from the stub
(StartupScreen ×10 → stub 0x240e0 = `processName`; CarProbe ×2 → stub
0xb5a0 = `CGContext`). Counted separately from wrong names.

Internal-branch `sub_XXXX` labels (not callees): 7,310 checked, **0 wrong**.

Adjudication note: a first pass of this audit flagged AppBridgeB (333) and
SplitScreenA (22) as wrong; inspection showed those were the *verifier's own*
extractor gaps (the `call sym:_X` tag prefix; trailing `(sel=<enclosing
method>)` commentary), not agent errors. The final pass normalizes all four
annotation dialects found in the dumps (`call stub:_X`, `call sym:_X`,
`CALL objc_msgSend$sel`, `objc_stub[sel]`, `objc_msgSend: sel`,
`-> _objc_msgSend(sel)`, `msgSend "sel"`, `objc_msgSend sel=sel`,
`objc_msgSend [sel]`, `objc_msgSend$sel (sel=host)`).

## Data annotations (ldr-line classref / selref / got claims)

| Module | Kind | Found | Checked | Correct | Wrong |
|---|---|---|---|---|---|
| SpeedBubble | selref | 78 | 78 | 78 | 0 |
| SpeedBubble | classref | 688 | 688 | 647 | **41** |
| SpeedBubble | got `(= import …)` | 413 | 413 | 404 | **9** |
| SplitScreenA | class | 345 | 345 | 345 | 0 |
| SplitScreenA | sel | 124 | 124 | 124 | 0 |
| Prefs | `@CLASS` | 1,652 | 200 (sample) | 200 | 0 |
| Prefs | `@GOT` | 632 | 200 (sample) | 200 | 0 |
| AppBridgeB | `bind _OBJC_CLASS_$_…` | 706 | 200 (sample) | 200 | 0 |
| AppBridgeB | got | 6 | 6 | 4 | 0 (2 unresolvable) |

OMCCommon and StartupScreen annotate data refs **without a slot address**
(`-> [selref(NAME)]`, `got(NAME)`); those claims cannot be re-checked from
the dump text alone and were not counted either way.

### SpeedBubble's CURRENT dumper still mislabels 10 distinct data slots

Classref (claim → truth), occurrences in parentheses:
- 0x43068 `UIBezierPath` → `NSMutableDictionary` (×14)
- 0x43118 `UINotificationFeedbackGenerator` → `UIScreen` (×9)
- 0x43078 `NSMutableDictionary` → `UIFont` (×6)
- 0x42f60 `NSString` → `UIApplication` (×5)
- 0x43030 `UIColor` → `CAShapeLayer` (×5)
- 0x430d0 `AVAudioSession` → `NSMutableData` (×1)
- 0x43198 `UIGraphicsImageRendererFormat` → `NSTimeZone` (×1)

Got/import (claim → truth):
- 0x392d8, 0x398d8 `__NSConcreteGlobalBlock` → `___CFConstantStringClassReference`
  (×3 each — these slots are the isa word of `__cfstring` literals)
- 0x43440 `_OBJC_CLASS_$_NSTimeZone` → `__objc_empty_cache` (×1 — the slot is
  the *cache* field of SPPSignView's metaclass struct at 0x43430; verified by
  resolving the whole struct: isa `_OBJC_METACLASS_$_NSObject`, superclass
  `_OBJC_METACLASS_$_UIView`, ro name `SPPSignView`)
- 0x436b0 `___objc_personality_v0` → not a pointer at all (×2 — raw value is
  `0xFFFFFFFFFFFFFFFF`, loaded with `ldr w0`; a plain data word annotated as
  an import)

Pattern: off-by-one-style extraction slips plus field-type confusion,
confined to SpeedBubble's data-slot resolver. Its **call** annotations are
clean (below); any SpeedBubble source statement that rests on a classref/got
annotation — e.g. "this code touches class X" — must be re-checked against
the binary at these slots.

## SpeedBubble dump history — read this before citing its dumps

An earlier generation of SpeedBubble's dumps, observed in a live progress
read at ~02:05 UTC, **systematically mislabeled stub targets**, e.g.:

| Site (old dump) | Labelled | Truth (indirect symtab) |
|---|---|---|
| bl #0x27ff8 | `_objc_registerClassPair` | `_objc_release` |
| bl #0x27d58 | `_close` | `_dispatch_after` |
| bl #0x27dc4 | `_dispatch_source_set_timer` | `_dispatch_time` |
| bl #0x27c80 | `__NSConcreteStackBlock` | `__Unwind_Resume` |
| bl #0x27de8 | `_dlopen` | `_dlsym` |
| bl #0x27f74 | `_objc_enumerationMutation` | `_objc_getClass` |
| bl #0x28004 | `_objc_release` | `_objc_retain` |
| bl #0x2801c | `_objc_retainAutorelease` | `_objc_retainAutoreleasedReturnValue` |

The agent regenerated its dumps (file mtimes 02:16–02:18 UTC) with a
corrected annotator; **the regenerated files are the ones audited above and
they pass 8,476/8,476 on call targets.** Consequences:

- This audit certifies the dumps **as they stood at audit time**. Any
  SpeedBubble reasoning or evidence quoted from the pre-regeneration dumps
  is void and must be re-derived from the current files.
- Wave-3 verifiers should confirm the SpeedBubble report was written
  against the regenerated dumps (timestamps on/after 02:16 UTC).

## Bottom line per module (for the reconstruction reports)

- **OMCCommon, App, AppBridgeA, AppBridgeB, Prefs, SplitScreenA,
  SplitScreenB** — annotations fully trustworthy (calls and, where sampled,
  data).
- **CarProbe, StartupScreen** — calls trustworthy; remember the cosmetic
  missing-underscore habit and the 12 declared-`?` sites.
- **SpeedBubble** — call annotations trustworthy in the *current* dumps;
  data-slot annotations are **not** (10 distinct slots wrong, listed above);
  pre-regeneration dump evidence is void.

## Addendum (same day): the wave-1 bind-ordinal bug — this audit is NOT affected

The App module's report disclosed that the wave-1 parser
(`metadata/tools/macho_objc.py`) decodes chained-fixup bind ordinals
**1-based** — its `_import_name` returns `imports[ordinal - 1]` — while dyld
ordinals are 0-based. The verifier confirms this from the parser's own code
and from the binaries:

- This audit's resolver is 0-based and was validated independently of any
  list: the App's first classrefs decode to UIWindow, UIScreen,
  UIViewController, UIColor, NSLocale, UILabel (exactly the classes
  `didFinishLaunching` uses, in order); SPPSignView's metaclass struct
  resolves coherently (isa `_OBJC_METACLASS_$_NSObject`, superclass
  `_OBJC_METACLASS_$_UIView`, cache `__objc_empty_cache`, ro name
  `SPPSignView`); a `__cfstring` isa slot resolves to
  `___CFConstantStringClassReference`.
- **Every "surprising superclass" in wave-1 metadata is an artifact of the
  bug.** Corrected superclass for every class in the three affected
  binaries (verifier decode, struct+8):
  - SpeedBubble: SPPSpeedGPS/SPPSoundDelegate/SPPBubble/SPPPrefs/SPPOverspeed
    → NSObject (was NSRunLoop); SPPGlassView/SPPIconView/SPPSignView/
    SPPBubbleView → UIView (was NSValue).
  - SplitScreen: SCPCButton → UIButton (was NSSortDescriptor);
    SCPCarSplitView/SCPCarDividerView/SCPCarTabView/SCPCTouchWatch/
    SCPHomeWallView → UIView (was NSMutableArray); SCPHostedAppVC →
    UIViewController (was NSOperationQueue); SCPCarSplit/SCPCarPane/
    SCPNoopLayoutAssertion/SCPPrefs → NSObject (was UIViewController).
  - AppBridge: ABPane/ABHost/ABKeyboard → NSObject (was NSRunLoop);
    ABBoxView/ABShieldView/ABKnobView → UIView (was UIWindowScene);
    ABBarButton/ABKey → UIButton (was NSNull).
- Wave-1 fields derived from **rebases** (class names, method/selector
  lists, ivars) are unaffected. Only bind-derived names (superclasses,
  bind classrefs) are shifted. Wave-2 module source that declares a
  superclass taken from wave-1 metadata must be corrected to the values
  above.
