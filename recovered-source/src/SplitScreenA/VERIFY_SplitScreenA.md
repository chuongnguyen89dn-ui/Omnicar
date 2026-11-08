# VERIFY — SplitScreenA (verifier #3, wave 3)

Counts: claimed 251 methods + 4 initializers + 30 hook installs / confirmed:
partition arithmetic, 30/30 hook rows, present-gate chain, adopt correction
(3/3 sub-claims), timing rules (3/3), stub count / downgraded: 0 /
wrong: 1 (prose count only) / undeclared stubs: 0.

Method: verifier's own capstone disassembly of the original
`OmniCarSplitScreen.dylib` (arm64) with resolution solely via
`verify/macho_truth.py`; method census from wave-1 `objc.json` method
lists (rebase-derived, unaffected by the off-by-one) cross-checked
against the report's own table.

## Partition arithmetic — CONFIRMED

- Metadata ground truth: 480 methods over 11 classes (SCPCarSplit = 368
  instance + 1 class method = 369; SCPPrefs = 21 class methods).
- The report's §6 table parses to exactly 251 rows, all distinct, and
  every row's (class, ±, selector, IMP) matches the metadata entry
  exactly (0 mismatches). Per class: SCPCarSplit 183, SCPCarPane 37,
  SCPPrefs 21, SCPHostedAppVC 9, SCPNoopLayoutAssertion 1.
- Complement within the metadata set = 229 → A 251 + B 229 = 480. ✓

## Hook installers vs HOOK_MAP — CONFIRMED (30/30 rows), one prose error

Verifier's own abstract-interpretation pass over the three installers
extracted every MSHookMessageEx call site's class argument, selector
(selref resolved via macho_truth), replacement IMP and orig slot:

- `__init_0` @0x44a8: **16 sites** (0x4550–0x4888), repl IMPs
  0x4af0/0x4bcc/0x4c70/0x4cb4/0x4d24/0x4d90/0x4dfc/0x4f30/0x5104/0x51a0/
  0x51d8/0x5210/0x5248/0x5280/0x5338/0x5438, orig slots 0x87fb0–0x88028 —
  identical to HOOK_MAP and to the report's §3 table, row for row,
  including `DashBoard` metaclass for `+_newApplicationLibrary`, the
  `sub_52e8()`-result class for `isIconVisible:`, and
  `object_getClass(OMCCarClass("DBIconView"))` for
  `+maxLabelSizeForIconImageSize:` (the report's "CARIconView else
  DBIconView" phrasing is the OMCCarClass runtime mapping of that same
  literal — consistent).
- `__init_1` @0x58b4: **13 sites**, all rows identical to HOOK_MAP
  (DBDashboard ×5, DBDashboardRootViewController ×4,
  DBApplicationSceneViewController ×3, FBSDisplayLayoutPublisher ×1).
- `__init_2` @0x843c: **1 site** (SpringBoard
  `applicationDidFinishLaunching:` → 0x8540, orig 0x880b0). ✓
- Total 16+13+1 = 30 = HOOK_MAP's SplitScreen call-site count. ✓

**WRONG (prose only):** §3's lead-in says "`__init_0` … 17
MSHookMessageEx hooks". The binary has 16 call sites in that installer
and the report's own table lists 16 rows. The table data is fully
correct; only the prose numeral is off by one.

**FBSDisplayLayoutPublisher quirk — CONFIRMED:** at 0x5b00–0x5b08 the
installer calls `objc_getClass("DBDashboard")` and `cbnz x0, #0x5b34`
skips the `addElement:` MSHookMessageEx (site 0x5b30) when the class
exists — the hook installs only when DBDashboard resolves nil, exactly
as reported.

## Present-gate hook chain (sub_636c) — CONFIRMED

Own disassembly of the `presentBaseViewController:` replacement:

- `[SCPCarSplit shared]` → `active` → `wantsViewController:`; the
  result is tested at 0x63e0 (`cbz w0` → passthrough at 0x6404).
- Adopt path: `adoptViewController:` (0x63ec); the only indirect call
  afterwards (0x63fc) loads `[x20, #0x10]` — the **completion block's
  invoke pointer** — and calls it. The original IMP is never called on
  this path: presentation is swallowed, completion still delivered.
- Passthrough path: the orig IMP slot 0x88068 is loaded at 0x6450 and
  called at 0x646c with the full original argument set
  (self, _cmd, vc, animated, launchSource, completion), followed by
  the close-going-home log, `baseViewControllerPresented`,
  `refreshAppTabSoon`, and the deferred repair `dispatch_after` —
  matching §4's description.

## adopt: containment correction — CONFIRMED (3/3)

Own disassembly of `-[SCPCarSplit adopt:slot:]` (0x1942c):

- **Parent = dashboard root VC via sub_12658:** the receiver of
  `addChildViewController:` (stub call 0x198d4) is the retained result
  of the function's single call to sub_12658 (0x19864), and the same
  value is the argument to `didMoveToParentViewController:` (0x19a68),
  gated by an equality test against `parentViewController`. SCPCarSplit
  itself is never the containment parent. ✓ (matches the corrected
  NSObject superclass picture in SUPERCLASS_SWEEP/ANNOTATION_AUDIT)
- **sceneSize = CGSizeZero at adopt:** both `setSceneSize:` calls
  (0x1971c, 0x19aac) load d0/d1 through GOT slot 0x786b0, which
  macho_truth resolves as a bind to **`_CGSizeZero`**. ✓
- **additionalSafeAreaInsets = _UIEdgeInsetsZero:** the
  `setAdditionalSafeAreaInsets:` call (0x19a80) loads d0–d3 through
  GOT slot 0x78298, resolved as a bind to **`_UIEdgeInsetsZero`**. ✓

## Pending-bookkeeping timing — CONFIRMED (3/3)

- `purgePending` (0x109d8): `fmov d8, #12.00000000` at 0x10a88, `fcmp`
  at 0x10af8 → 12 s stale rule. ✓
- `pendingSlotForBundle:` (0x10c88): `fmov d0, #12.00000000` at 0x10d34,
  `fcmp` at 0x10d38. ✓
- `adoptViewController:` (0x18d20): `fmov d1, #30.00000000` at 0x18fd4,
  `fcmp` at 0x18fd8 → 30 s cancelled-launch memory. ✓

## Stub honesty — CONFIRMED

- Exactly one `STUB-UNRECOVERED` marker in the module source
  (SCPShared.m:132, `SCPSceneOfVC` / sub_1ab70), matching the declared
  count of 1. sub_1ab70 is a real 122-instruction function in the
  binary — the stub declaration is honest, not a cover for a missing
  read.
- Source-wide scan for single-statement trivial bodies found only
  `-[SCPHostedAppVC applicationInfo]`, `proxyApplicationInfo` and
  `sceneHostView` returning nil — all three IMPs (0xfdac/0xfdb4/0xfdbc)
  are literally `mov x0, #0; ret` in the binary, i.e. the true bodies.
- The §5 extern placeholders (SCPAppHasCarPlayUI → sub_ffb4,
  SCPInfoBool → sub_17d84, SCPResetDetachedView → sub_1a1b8,
  SCPSyntheticLaunchInfo, SCPLayoutElementKey → sub_8350, …) are
  declared `extern` inline at the call sites with the original
  addresses noted — disclosed, not disguised as reconstructions.

## Verdict

SplitScreenA's reconstruction is accurate on every priority item
checked. Sole defect: the §3 prose count "17 hooks" for `__init_0`
should read 16 (its own table and the binary agree on 16).
