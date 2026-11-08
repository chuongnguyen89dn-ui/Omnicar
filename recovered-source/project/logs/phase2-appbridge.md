# PHASE 2 — OmniCarAppBridge integration (sync + seams + build)

Date: 2026-11-08. Scope: `project/OmniCarAppBridge/` only (+ the mandated
`src/OMCCommon` → `project/OMCCommon/` copy at start). No `src/` edits:
the one authorised src-level correction (zoom, item 3 below) turned out
to be unnecessary — src already carries the corrected body. Root
Makefile and other subprojects untouched.

Build rules honoured: `umask 022`, `THEOS=~/theos`,
`cd project/OmniCarAppBridge && make clean; make`.

## 0. OMCCommon copy (start of sync)

Copied `src/OMCCommon/{OMCCommon.c,OMCCommon.h}` → `project/OMCCommon/`
before any AppBridge work. md5sums after the copy (src == project):

- `OMCCommon.c`: `cb8afa107945c29cc2bce1befb999feb`
- `OMCCommon.h`: `951b0e341f3ba79ff0d6f0802525d79e`

Note: `OMCCommon.c` changed under us during this session (an earlier
read in the same session showed `1f8a90b2b5cbc946853337bfd6e4883a`) —
another agent owns OMCCommon corrections; the coordinator re-verifies
at aggregate time. The `.h` md5 was stable across both reads.

## 1. Sync list (flat merge, fresh copies from src)

From `src/AppBridgeA/src/`:
- `ABChannels.m` (A's handlers/bootstrap TU — keeps the basename)
- `ABHostLaunch.m`
- `ABHost.h` → NOT copied over the project header; the project
  `ABHost.h` was rebuilt from B's current header + the phase-1 union
  additions (see §5/fix F1)
- `OMCCore.h`, `OMCCore.m` (OMCCore.m stays EXCLUDED from `_FILES`, §4)

From `src/AppBridgeB/`:
- `ABChromeViews.m`, `ABHostBMethods.m`, `ABHostGeometry.m`,
  `ABInApp.m`, `ABKeyboard.m` (completed 755-line version),
  `ABTelex.m`, `AppBridgeEntry.m`, `AppBridgeB.h`, `ABPane.m` (new),
  `ABMissingSelector.m` (new)
- `ABChannels.m` → copied as `ABChannelNames.m` (rename, §2)

Project-only files kept from phase 1: `ABIntegrationShims.h`,
`ABChromeViews.h`, `ABKeyboardDecl.h`, `Makefile`,
`OmniCarAppBridge.plist`.

## 2. Basename clash — rename

Two `ABChannels.m` exist: A's (handlers/bootstrap, string literals
throughout) and B's (constants TU, byte-verified channel strings).
**B's project copy is renamed `ABChannelNames.m`**; A's keeps the name.
Makefile `_FILES` updated accordingly. Verified in the built dylib:
all 14 `ABChan*` globals (`S` symbols) and both `ABNotify*` (`D`)
are defined.

## 3. Zoom verdict

**Src already says 0.6 — no src correction was needed or made.**
`src/AppBridgeB/ABHostBMethods.m` carries the full phase-2 body:
`OMCPrefsSync(); v = [OMCPref(@"appBridgeZoom", @80) doubleValue] /
100.0; return MIN(MAX(v, 0.6), 1.0);` with the floor-correction comment
(raw bytes @0x2B210 = `33 33 33 33 33 33 E3 3F` = 0.6, two independent
decodes; the old 0.3 came from a truncated-hex annotation). B's
`ABHost.h` zoom comment also already reads 0.6. The stale 0.3 orphan
fragment existed only in the phase-1 PROJECT copy and was overwritten
by this sync. (Module A's own `-[ABHost zoom]` in ABHostLaunch.m also
clamps at 0.6 but reads the pref with a nil default — see §8 overlap.)

## 4. ABMissingSelector verification + OMCCore exclusion

`src/AppBridgeB/ABMissingSelector.m` verified against the evidence in
its own header (disasm `f_ABMissingSelector.txt`, 468 B @ 0x9698):
- Signature: `void ABMissingSelector(id object, NSString *selectorName)`
  — void return confirmed (body never sets a return value; the binary
  call site zeroes the result register itself). ✓ matches.
- Log format: `@"THIEU METHOD: %@ khong co %@ -> bo qua"` formatted
  with `(NSStringFromClass([object class]), selectorName)`. ✓ matches.
- Added to `_FILES`. Built dylib defines `_ABMissingSelector` (`T`).

`OMCCore.m` stays EXCLUDED from `_FILES` (coordinator ruling: shared
unit wins; A's defaults NO / deadline 1809216000 in that file are
wrong). Makefile comment updated to record that ABMissingSelector is
now built from its own extracted TU instead of A's OMCCore.m.

AppBridgeA's `carDisconnected` body keeps its INFERRED labelling: A's
closeApp tail is commented "INFERRED (addresses 0x15db4-0x160ec)" in
ABHostLaunch.m and remains so in the project copy. (Note both halves
implement `carDisconnected`; see §8.)

## 5. Header visibility (ABChromeViews.h)

Phase-1 symptom: ABHostBMethods.m errors at lines ≥129 because
ABBoxView/ABShieldView @interfaces live inside ABChromeViews.m.
With the new sources the phase-1 arrangement **suffices — no further
header extraction was needed**:
- Project `ABChromeViews.h` (phase-1 verbatim copies) was checked
  against the fresh `ABChromeViews.m` in-file @interfaces: identical
  (ABBoxView handleHit/bar/passInsets/hole + applyHole; ABShieldView
  empty; ABKnobView index/dot/lastSent + relay:touches:; ABBarButton
  empty). ABChromeViews.m keeps its in-file copies and does not import
  the header, so no TU sees a duplicate interface.
- Re-applying phase-1 fix 15 (ABHostLaunch.m / ABHostBMethods.m import
  `ABChromeViews.h`) makes every chrome-view use in BMethods compile:
  `pane.box.passInsets`, `pane.box.hole`, `[[ABShieldView alloc] …]`
  produced NO errors.
- The only remaining errors in ABHostBMethods.m were the separate
  phase-1 BLOCKER-AB-ZOOM tail item: 3 dot-on-`id` accesses
  `pane.appViewController.view.center = …` (appViewController is typed
  `id` in ABHost.h) at setFrame lines 153/162/173 — fixed as F8 below.

Project `ABHost.h` (fix F1): rebuilt from B's current ABHost.h
(superclass-corrected, zoom comment already 0.6) + phase-1 item 12
union re-applied: A's five bar-action declarations
(barReplace:/barPop:/barFull:/barBackground:/barClose:) in the
`(ModuleA)` category and A's C helpers `ABPostAppState` /
`ABBundleIDHash` at file scope (params `_Nonnull`-annotated).

`ABKeyboardDecl.h` (phase-1 item 9) re-checked against the completed
ABKeyboard.m in-file @interface: types still match (app copy NSString,
panel UIView, glass UIView, bubble UILabel, field id, preview UILabel,
rows NSArray, word/typed NSMutableString, returnType NSInteger,
numbers/shift/vietnamese BOOL, langButton/hideButton UIButton,
keysView UIView) — kept unchanged.

## 6. _FILES changes

Added: `ABChannelNames.m`, `ABPane.m`, `ABMissingSelector.m`
(ABKeyboard.m was already listed; its completed body now links).
Full list: ABChannels.m ABChannelNames.m ABHostLaunch.m
ABChromeViews.m ABHostBMethods.m ABHostGeometry.m ABInApp.m
ABKeyboard.m ABTelex.m AppBridgeEntry.m ABPane.m ABMissingSelector.m
(+ shared unit via OMCCommon.mk). OMCCore.m excluded (§4).

## 7. @property census (ABKeyboard / ABKey)

**No compile or link error exposed a missing @property — no
integration-side declarations were added.** The completed
ABKeyboard.m declares all 16 ABKeyboard properties and all 8 ABKey
properties in-file; auto-synthesis generates the accessors (verified
in the built dylib, e.g. `-[ABKeyboard setRows:]`,
`-[ABKey setHint:]`, 121 ABKeyboard/ABKey symbols total). The
COVERAGE_GAPS "ABKeyboard 7 / ABKey 4" unclaimed entries were the
then-missing method bodies (buildPanel, rebuildKeys, layoutKeys,
layoutPanelIn:, key:pressed:, key:symbol:value:command:weight:,
ABKey paint:/setHighlighted:/layoutSubviews) — the keyboard bodies
are now present in src; ABKey's three remain body-less (see §9).
Metadata discrepancies noted, NOT "fixed" (module's own phase-2
choices): objc.json types `ABKey._accent` as CAGradientLayer* where
the reconstruction declares `BOOL accent` (its paint: comment treats
it as a flag), and `_glass` UIVisualEffectView / `_field` UIView /
`_rows` NSMutableArray where the reconstruction uses the supertypes
UIView* / id / NSArray*. All uses in the TU type-check as written.

## 8. The two @implementation ABHost blocks — category seam

Two plain `@implementation ABHost` blocks CANNOT link: proven on this
toolchain before syncing (toy two-TU build → `ld64.lld: error:
duplicate symbol: OBJC_CLASS_$_Foo / OBJC_METACLASS_$_Foo /
OBJC_IVAR_$_Foo._panes`). Mechanical arrangement in the PROJECT copy
of ABHostBMethods.m only: its block is
**`@implementation ABHost (ModuleB)`** (category), with an explanatory
comment at the @implementation line; **every method body is verbatim**.
ABHostLaunch.m keeps the class @implementation (emits the class,
ivars and property accessors). Both blocks coexist in the built dylib
(e.g. `-[ABHost zoom]` and `-[ABHost(ModuleB) zoom]` are both present).
Makefile gained `-Wno-error=objc-protocol-method-implementation`
(20 such warnings, all from this coexistence).

Eight selectors are implemented by BOTH halves: `+shared`, `-count`,
`-hostsApp:`, `-paneFor:`, `-bundleForHash:`, `-zoom`,
`-appWithHash:changedOrientation:supportedMask:`, `-carDisconnected`.
Under category precedence B's bodies are the effective ones. For zoom
that is the evidence-backed outcome (@80 default + 0.6 floor, §3).
A's bodies remain compiled in the class. **Flagged for coordinator
adjudication (not silently resolved):** the pairs are not identical —
notably `+shared` (A's body also initialises `panes` to an empty
NSMutableArray; B's "standard shape" body does not) and
`carDisconnected` (A closes each pane via closeApp:terminate:NO and
logs after; B logs first, teardownPane:s each pane, clears the
registry and hides/releases the window). A's appWithHash: body is
self-described as truncated where B's is complete.

## Fixes applied (project copies only; src/ untouched)

- F1 ABHost.h — rebuilt as B header + phase-1 union (bar actions +
  ABPostAppState/ABBundleIDHash), §5.
- F2 ABChromeViews.m — `#import "ABHost.h"` (phase-1 item 14).
- F3 ABHostLaunch.m — `#import "ABChromeViews.h"`,
  `#import <objc/message.h>` (item 15).
- F4 ABHostBMethods.m — same two imports (item 15); category seam (§8).
- F5 ABHostGeometry.m — `#import "ABKeyboardDecl.h"`,
  `#import <objc/message.h>` (item 16a).
- F6 ABHostGeometry.m — `void` → `BOOL ABHook_SBSuspended` (item 16b;
  every return is BOOL, orig cast to BOOL-returning pointer).
- F7 ABHostGeometry.m — ABCarPlayChanged: the
  `device = ABMissingSelector(...)` assignment replaced by a statement
  call (function is void, §4; `device` stays nil, matching the binary
  call site zeroing the result). Comment added at the site.
- F8 ABHostBMethods.m — 3× `pane.appViewController.view.center` →
  `((UIViewController *)pane.appViewController).view.center`
  (dot-on-`id`; same -view send; the file's own layoutPane: uses a
  UIViewController* local for the same object). Comment at first site.
- F9 ABInApp.m — 14 static-hook forward declarations added +
  ABDisplayLinks forward-decl return type NSMutableSet* → NSHashTable*
  to match the file's own definition (item 17).
- F10 AppBridgeEntry.m — `#import <dlfcn.h>` (item 18).
- F11 AppBridgeB.h — ABMissingSelector declaration corrected
  `id` → `void` (evidence in §4; OMCCore.h:88 already void). Without
  this, TUs importing AppBridgeB.h saw a declaration contradicting
  the definition.
- F12 Makefile — _FILES per §6 + ABChannelNames rename note +
  OMCCore comment update + the category warning demotion (§8).

Phase-1 items 7/8/9 (ABIntegrationShims.h / ABChromeViews.h /
ABKeyboardDecl.h) are project-only files, kept as-is (9 re-verified).

## Build result

`make clean; make` → **PASS** (exit 0). Full log:
`project/logs/phase2-appbridge-build.log`. All 12 TUs + shared unit
compile; link and signing complete; product
`.theos/obj/debug/arm64/OmniCarAppBridge.dylib` (402,552 B, arm64 —
arm64e impossible on this VM, as documented in phase 1).
44 warnings, all in demoted classes: 20 objc-protocol-method-
implementation (the §8 coexistence), 12 incomplete-implementation
(ABHost methods split across the two blocks by design), 4 nonnull,
3 format, 2 mismatched-parameter-types (A spells int/unsigned long
long where B's header spells NSInteger/NSUInteger), 1
incompatible-pointer-types (ABHostLaunch.m:179 `pane.box = box`,
UIView* → ABBoxView* — pre-existing reconstruction style), 1
unused-variable.

Phase-1 AppBridge blockers status: AB-CHANNELS **resolved**
(ABChannelNames.m), AB-PANE **resolved** (ABPane.m; `-[ABPane frame]` /
`-[ABPane setFrame:]` etc. in dylib), AB-KEYBOARD **resolved**
(completed ABKeyboard.m compiles+links), AB-ZOOM **resolved** (§3),
CORE-APPBRIDGE **arranged** (OMCCore.m excluded; ABMissingSelector
extracted; §4).

## Remaining issues (not fixed, per rules)

1. **ABHost duplicate-selector adjudication** (§8): 8 overlapping
   selectors, 3 with materially different bodies (+shared panes init,
   carDisconnected strategy, appWithHash completeness). Needs a
   coordinator/verifier ruling on which reconstruction of each IMP is
   authoritative; both are preserved and compiled meanwhile.
2. **ABKey cosmetic methods have no bodies in src**: ABKey's
   @implementation contains only comments for -paint:, -setHighlighted:
   and -layoutSubviews (module B condensed them); the key factory
   calls `[key paint:NO]`, which would raise unrecognized-selector at
   runtime. Nothing was authored here.
3. **18 ABHost methods are DECL_ONLY** (declared in ABHost.h /
   (ModuleA) category, implemented in NEITHER half — per
   metadata/COVERAGE_GAPS.md): ensureWindow, dropWindowIfEmpty,
   setupLiveAppViewForPane:, teardownPane:, revealPane:, carWindow,
   buildBarForPane:, layoutBarForPane:, hideBarForPane:,
   setBarVisible:pop:dim:single:forApp:, setKnobs:, setFront:forApp:,
   setHandleOffset:forApp:, setCornerRadius:corners:forApp:,
   setHandleVisible:forPane:, setupHandleForPane:, raiseKnobs,
   paneOfBarButton:. They link (ObjC sends need no symbols) but would
   fail at runtime; reconstruction is module work, not integration.
4. ABKeyboard/ABKey property-type divergences from objc.json (§7) —
   module B's phase-2 choices, left as delivered.

## Closure — ABKey ×3 + ABHost ×18 DECL_ONLY bodies (post-phase-2)

Reconstructed from the original binary's disassembly
(`src/AppBridgeB/disasm/m_ABKey_*.txt`, `m_ABHost_*.txt`, `full_arm64.txt`),
following the evidence-before-code pattern. Every selector was first
confirmed present in the original (`metadata/raw/OmniCarAppBridge/objc.json`
IMP + `metadata/xref/OmniCarAppBridge.json`), and all of `src/AppBridgeA` +
`src/AppBridgeB` was searched first — **none of the 21 had an existing body
under any spelling/category** (declarations and call sites only). None is
among the 8 duplicate-selector pairs (§8) — untouched, as ordered.

**Placement rule:** the 3 ABKey bodies went into `ABKeyboard.m`'s ABKey
`@implementation` (moved below ABKeyboard's `@interface` in the same TU —
a forward category declaration is not legal ObjC; noted in the file). All
18 ABHost bodies went into module B's `ABHostBMethods.m`: in the binary
their IMPs interleave with B's already-reconstructed ABHost methods,
`src/AppBridgeA/src/ABHost.h` itself annotates them "[B]", and B's existing
bodies already call `teardownPane:`/`layoutBarForPane:`/`hideBarForPane:`/
`setHandleVisible:forPane:` internally. Nothing was added to module A.

### Per-selector verdicts

| Selector | IMP (arm64) | In original? | Body written | Status |
|---|---|---|---|---|
| ABKey -paint: | 0x181DC | yes | src/AppBridgeB/ABKeyboard.m | VERIFIED |
| ABKey -setHighlighted: | 0x187D4 | yes | src/AppBridgeB/ABKeyboard.m | VERIFIED |
| ABKey -layoutSubviews | 0x189C8 | yes | src/AppBridgeB/ABKeyboard.m | VERIFIED |
| ABHost -ensureWindow | 0xAEA8 | yes | src/AppBridgeB/ABHostBMethods.m | VERIFIED (windowLevel base INFERRED, see below) |
| ABHost -dropWindowIfEmpty | 0xB89C | yes | src/AppBridgeB/ABHostBMethods.m | VERIFIED no-op (IMP is a single `ret`) |
| ABHost -setupLiveAppViewForPane: | 0xC2BC | yes | src/AppBridgeB/ABHostBMethods.m | VERIFIED, 2 flagged exceptions (see below) |
| ABHost -teardownPane: | 0x155B0 | yes | src/AppBridgeB/ABHostBMethods.m | VERIFIED |
| ABHost -revealPane: | 0xC178 | yes | src/AppBridgeB/ABHostBMethods.m | VERIFIED |
| ABHost -carWindow | 0xF3D0 | yes | src/AppBridgeB/ABHostBMethods.m | VERIFIED |
| ABHost -buildBarForPane: | 0x105B8 | yes | src/AppBridgeB/ABHostBMethods.m | VERIFIED (blur style 11 name INFERRED) |
| ABHost -layoutBarForPane: | 0x11690 | yes | src/AppBridgeB/ABHostBMethods.m | VERIFIED |
| ABHost -hideBarForPane: | 0x12610 | yes | src/AppBridgeB/ABHostBMethods.m | VERIFIED (option 0x10000 name INFERRED) |
| ABHost -setBarVisible:pop:dim:single:forApp: | 0x11868 | yes | src/AppBridgeB/ABHostBMethods.m | VERIFIED (option 2 name INFERRED) |
| ABHost -paneOfBarButton: | 0x12F78 | yes | src/AppBridgeB/ABHostBMethods.m | VERIFIED |
| ABHost -setupHandleForPane: | 0x133C8 | yes | src/AppBridgeB/ABHostBMethods.m | VERIFIED |
| ABHost -setHandleVisible:forPane: | 0x137CC | yes | src/AppBridgeB/ABHostBMethods.m | VERIFIED |
| ABHost -raiseKnobs | 0x13918 | yes | src/AppBridgeB/ABHostBMethods.m | VERIFIED |
| ABHost -setKnobs: | 0x13ABC | yes | src/AppBridgeB/ABHostBMethods.m | VERIFIED (blur style 11 name INFERRED) |
| ABHost -setHandleOffset:forApp: | 0x14C7C | yes | src/AppBridgeB/ABHostBMethods.m | VERIFIED |
| ABHost -setFront:forApp: | 0x151A8 | yes | src/AppBridgeB/ABHostBMethods.m | VERIFIED |
| ABHost -setCornerRadius:corners:forApp: | 0x10438 | yes | src/AppBridgeB/ABHostBMethods.m | VERIFIED |

### Helpers reconstructed with them (all in ABHostBMethods.m)

| Helper | Address | Status |
|---|---|---|
| ABCarDisplay (sub_B4E4) | 0xB4E4 | VERIFIED |
| ABPassThroughHitTestIMP (sub_167DC) | 0x167DC | VERIFIED |
| ABApplyAccent (sub_11F58) | 0x11F58 | VERIFIED |
| ABMakeBarButton (sub_112B0) | 0x112B0 | VERIFIED |
| ABSetBarButtonContent (sub_11CD8) | 0x11CD8 | VERIFIED shell; glyph block STUB-UNRECOVERED |
| ABResolveSelectorName (sub_D9B0) | 0xD9B0 | VERIFIED flow; candidate arrays STUB-UNRECOVERED |
| ABInvokeIdentityGetter (sub_DEF0) | 0xDEF0 | VERIFIED |
| ABCheckCast (inlined ×12 in setupLive) | — | VERIFIED (nil-passthrough VERIFIED at the sceneIdentity site, INFERRED for the other 11) |

### STUB-UNRECOVERED items (explicit, in-code)

1. **Glyph-drawing block @0x168B0 (2356 B)** inside ABSetBarButtonContent:
   draws the UIBezierPath vector glyphs per icon name; per-glyph path
   geometry was not transcribed, so bar icons render blank. Everything
   around it (cache, 22/20 pt sizes, tag 7302, labels) is VERIFIED.
2. **sub_D9B0 candidate arrays** at __DATA 0x39420/0x39438/0x39450:
   chained-fixup NSArray constants, elements not recovered. Call sites
   pass the needle itself as the only candidate; the resolver's
   class-hierarchy scan (VERIFIED) covers the remaining cases.
3. **`_currentMode` value in setupLiveAppViewForPane:**: the original
   passes the global object at __DATA 0x395D0 to
   `setValue:forKey:@"_currentMode"`; the chained-fixup target was not
   resolved, so the single assignment is omitted and marked in code
   rather than guessed. Also in setupLive: one call position
   (ABPostOrientationToApp between the orientation read and layoutPane:
   in main-queue block @0xE57C) is INFERRED, and -ensureWindow's
   `UIWindowLevelStatusBar + 60.0` has the constant 60.0 VERIFIED with
   the status-bar base INFERRED.

### Divergences resolved from evidence

- **ABKey.accent: BOOL → CAGradientLayer\*** (src/AppBridgeB/ABKeyboard.m,
  synced to project). Evidence: objc.json property
  `T@"CAGradientLayer",&,N,V_accent`; `-setAccent:` @0x18C74 is a 64-byte
  retain/store object setter (a BOOL setter would be a plain store);
  paint: assigns `[CAGradientLayer layer]` to it and sends it layer
  messages. The BOOL typing was a transcription error; changed with an
  in-code evidence note, not silently.
- **-buildBarForPane: return type void → UIView\*** (`src/AppBridgeB/ABHost.h`
  and the project merged `ABHost.h`, both edited + logged here). Evidence:
  objc.json type `@24@0:8@16`; the 0x105B8 body ends in an autoreleased
  return of the bar; callers (setBarVisible:) use the result.

### Project sync + build

Synced: `ABKeyboard.m` (verbatim), `ABHost.h` (return-type line only,
union additions preserved), `ABHostBMethods.m` (new content merged with
the project seams preserved: F4 `ABChromeViews.h`/`objc/message.h`
imports — the src-local ABBarButton/ABKnobView/ABBoxView mini-interfaces
were dropped in the project copy in favour of ABChromeViews.h — the
`@implementation ABHost (ModuleB)` seam comment + category, and the three
F8 `((UIViewController *)pane.appViewController).view.center` casts).
One compile fix applied identically to both copies: teardownPane:'s
`[vc.view removeFromSuperview]` → `[[vc view] removeFromSuperview]`
(dot-syntax on `id` is an error on this toolchain).

Build: `make clean; make` in project/OmniCarAppBridge → **PASS**
(link + sign; log `project/logs/phase2-appbridge-closure-build.log`).
Dylib grew 402,552 B → **494,456 B** (arm64). All 21 selectors verified
present in the built dylib's method-name table. New warnings are limited
to -Wnonnull notes on ABMissingSelector call sites (same class as the
pre-existing phase-2 warnings) and the known category-precedence warnings
for the 8 duplicate pairs (adjudication still pending, untouched).
