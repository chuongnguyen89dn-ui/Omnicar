# BUILD PHASE 1 LOG — OmniCar 1.0.3 reconstruction, integration

Date: 2026-11-08. Scope: populate `project/` with the reconstructed sources
and get them COMPILING. Mechanical fixes only (imports, declaration
completions, file arrangement, Makefile warning-class demotions). No logic
was authored; every logic disagreement found is listed as a BLOCKER with
both versions cited. SpeedBubble sources were copied byte-for-byte and NOT
edited (verifier #4 adjudication pending). SplitScreenB sources were NOT
copied (closure agent editing them live). StartupScreen subproject remains
the scaffold placeholder (module not yet delivered).

## Toolchain check (before any build)

- `which clang-18` → /usr/bin/clang-18; dpkg: clang-18 1:18.1.3-1ubuntu1 (ii).
- `which ldid` → /usr/local/bin/ldid (present, shim intact).
- `readlink /usr/bin/ld.lld` → ld.lld-18 ✓.
- Verdict: toolchain HEALTHY, `~/bin/fix-toolchain.sh` NOT run.
- All builds run under `umask 022` with `THEOS=$HOME/theos`.
- Known VM limits respected: ARCHS arm64-only (clang-18 silently degrades
  arm64e→arm64); the original binaries are FAT arm64+arm64e, so every
  rebuilt binary differs from the original in arch set (expected, recorded
  in the diff output).

## Project-level change

- `project/control`: the `Installed-Size: 6160` line was REMOVED (dm.pl
  regenerates it; keeping it duplicated the field). All other control
  fields byte-identical to the original.

## Copy map (what came from where)

- `project/OMCCommon/OMCCommon.c/.h` ← `src/OMCCommon/` (shared unit,
  replaces the scaffold placeholder).
- `OmniCarApp/` ← `src/App/` (main.m, OMCAppDelegate.h/.m).
- `OmniCarCore/` ← `src/OMCCommon/OmniCarCore.c` (scaffold placeholder.m
  removed; the shared unit is appended via OMCCommon.mk).
- `OmniCarCarProbe/` ← `src/CarProbe/` (OmniCarCarProbe.m). OMCCommon.mk
  NOT included here — see BLOCKER-CORE-CARPROBE.
- `OmniCarAppBridge/` ← flat merge of `src/AppBridgeA/src/` (ABChannels.m,
  ABHostLaunch.m, OMCCore.h, OMCCore.m) + `src/AppBridgeB/` (ABChromeViews.m,
  ABHostBMethods.m, ABHostGeometry.m, ABInApp.m, ABKeyboard.m, ABTelex.m,
  AppBridgeEntry.m, AppBridgeB.h) + the merged `ABHost.h` (see fixes).
  OMCCore.m is present but deliberately EXCLUDED from `_FILES` — see
  BLOCKER-CORE-APPBRIDGE.
- `OmniCarPrefs/` ← ALL of `src/Prefs/OMCPrefs/*.h/.m` (A's 7 classes +
  B's 22 classes + Prefs' own OMCCommon.m). `src/Prefs/OMCPrefs/generated/`
  deliberately NOT copied (nothing imports it). The shared unit is NOT
  appended — see BLOCKER-CORE-PREFS.
- `OmniCarSpeedBubble/` ← `src/SpeedBubble/*.h/*.m` AS-IS (15 .m files).
- `OmniCarSplitScreen/` ← SplitScreenA (`SCPCarSplit.m` + 5 more .m,
  SCPShared.h, SCPCarSplit.h) + SplitScreenC (8 .m + SCPHomeCommon.h)
  only. NO SplitScreenB files (phase 2).
- `OmniCarStartupScreen/` ← unchanged scaffold placeholder.
- New integration-only files (no reconstructed logic): 
  `OmniCarAppBridge/ABIntegrationShims.h`, `ABChromeViews.h`,
  `ABKeyboardDecl.h`; `OmniCarPrefs/PrefsIntegrationShims.h`;
  `OmniCarSplitScreen/SCPIntegrationShims.h`;
  `OmniCarSpeedBubble/SBIntegrationShims.h` (from scaffold prep).
- `OMCCommon.mk`: added `-x objective-c` for the target that includes it
  (OMCCommon.c / OmniCarCore.c are Objective-C despite the .c extension).

## Per-subproject build results

| Subproject | Result | Notes |
|---|---|---|
| OmniCarCore | **PASS** (links + signs) | Shared unit + OmniCarCore.c. |
| OmniCarApp | **PASS** | Fingerprint matches original: 1 class / 6 methods. |
| OmniCarCarProbe | **PASS** | After 4 mechanical fixes (below). |
| OmniCarStartupScreen | **PASS (placeholder)** | Scaffold body only; real module not integrated. Anchor call updated to `OMCEnabled()?1:0` (the scaffold's `OMCCommonPlaceholderVersion()` no longer exists). |
| OmniCarAppBridge | **FAILS — 2 files** | All other 7 .m compile. ABHostBMethods.m + ABKeyboard.m blocked (BLOCKER-AB-ZOOM / BLOCKER-AB-KEYBOARD). Diagnostic build without them reaches LINK; undefined: `_OBJC_CLASS_$_ABPane` (BLOCKER-AB-PANE), `_OBJC_CLASS_$_ABKeyboard` (excluded file), `ABMissingSelector` (lives in the excluded OMCCore.m), 7× `ABChan*` + 2× `ABNotify*` constants (BLOCKER-AB-CHANNELS). Untested: whether the two `@implementation ABHost` blocks (A in ABHostLaunch.m, B in ABHostBMethods.m) coexist at link — methods are partitioned, no duplicate-method clash expected. |
| OmniCarSplitScreen | **FAILS — 2 files + link seam** | SCPCarSplit.m + SCPHomeApply.m need SplitScreenB (BLOCKER-SPLIT-B). All other 12 .m compile. Diagnostic build without them reaches LINK; 19 undefined symbols, all at the A↔C seam (BLOCKER-SPLIT-SEAM). |
| OmniCarPrefs | **FAILS — 1 line** | Every file compiles except OMCCommon.m:1142 `view.hud = YES;` (BLOCKER-PREFS-HUD). Diagnostic build without OMCCommon.m reaches LINK; every undefined symbol is one of OMCCommon.m's own ~40 C functions/classes (linker caps the list at 20: L, OMCAccentColor, OMCBackgroundColor, OMCCardColor, OMCColorFromHex, OMCConflictingTweaks, OMCEnabled, OMCExpired, OMCFeatureDisplayName, OMCIcon, OMCLanguage, OMCLanguageName, OMCLanguages, OMCLoadStrings, OMCLocalizeSpecifiers, OMCRescueFeatures, OMCStyleCell, OMCStyleHeaderFooter, OMCStyleTable, OMCSwitchColor, …) — i.e. no other link gaps. Framework list completed (below). |
| OmniCarSpeedBubble | **NOT BUILT (embargo)** | Copied as-is, zero edits. Attempted build for the record: 12 errors in 4 files (7× SPPDisplayBoot.m notify-arg, 3× SPPBubble.m, 1× SPPOverspeed.m, 1× SPPPrefs.m); remaining 11 files unreached. See BLOCKER-SB-NOTIFYARGS + PENDING-VERIFIER duplicate `__init_0`. |

## Aggregate build + diff_payload

Root `Makefile` SUBPROJECTS temporarily trimmed to the four linking
subprojects (App, Core, CarProbe, StartupScreen-placeholder), then
RESTORED to all 8 (verified). `make package` exit 0 →
`packages/com.anlai.omnicar_1.0.3-1+debug_iphoneos-arm64.deb` (159,304 B).
Full output: `logs/phase1-diff.txt` (diff cmd: `tools/diff_payload.py
--orig-deb ../input/com.anlai.omnicar_1.0.3_iphoneos-arm64.deb <built>`).

- Control fields: all SAME except Version (`1.0.3` → `1.0.3-1+debug`,
  non-final build suffix) and Installed-Size (6160 → 668, reflects the
  trimmed payload).
- Common non-Mach-O files: **7 of 7 byte-identical**.
- Mach-O structural fingerprints vs original:
  - OmniCar (App): archs arm64+arm64e → arm64; classes **1→1**, methods
    **6→6** (exact); defined symbols 4→86, **0 original symbols missing**
    (theirs is stripped; ours is a debug build — count gap expected).
  - OmniCarCarProbe.dylib: classes 0→0, methods 0→0; defsyms 20→327,
    **0 original symbols missing**.
  - OmniCarCore.dylib: classes 0→0, methods 0→0; defsyms 21→437,
    **0 original symbols missing**.
  - OmniCarStartupScreen.dylib: 8→0 classes, 173→0 methods (placeholder,
    expected).
- Missing in built (expected): the 4 unlinked binaries + all Prefs bundle
  resources (resources stage only when their subproject builds).

## Mechanical fixes applied (file + change)

Project / Makefiles:
1. `project/control` — removed the `Installed-Size:` line (dm.pl
   duplicates it).
2. `project/OMCCommon.mk` — append `-x objective-c` to each consumer's
   CFLAGS (the shared unit's .c files are Objective-C).
3. `OmniCarPrefs/Makefile` — `OmniCarPrefs_USE_MODULES = 0` (Theos vendor
   Preferences headers are modular; `self.specifier` users failed).
4. `OmniCarPrefs/Makefile` — FRAMEWORKS += AVFoundation CoreMedia
   QuartzCore CoreGraphics AVKit UniformTypeIdentifiers (sources use them;
   scaffold listed UIKit only).
5. Warning-class demotions (`-Wno-error=...`) in subproject Makefiles —
   the reconstructions deliberately use these patterns under @try; no code
   changed: AppBridge: format, nonnull, incompatible-pointer-types,
   incomplete-implementation (ABHost methods split across two
   @implementation blocks by design), mismatched-parameter-types (A spells
   int/unsigned long long where B's header spells NSInteger/NSUInteger),
   unused-variable. CarProbe: arc-performSelector-leaks, unused-function.
   SplitScreen: nonnull, arc-performSelector-leaks, unused-variable,
   unused-function. Prefs: arc-performSelector-leaks,
   incompatible-pointer-types, unused-getter-return-value.
6. `OmniCarStartupScreen` placeholder .m — anchor now returns
   `OMCEnabled()?1:0` instead of the removed scaffold symbol.

Declaration completions / shim headers (no logic):
7. `OmniCarAppBridge/ABIntegrationShims.h` (new, force-included via
   -include): minimal `@interface NSDistributedNotificationCenter` (class
   absent from SDK headers; resolved dynamically in the code); forward
   declarations `ABAppOrientDispatch(int)`, `ABKeyboardDispatch(int)`,
   `ABCarPlayChanged(NSNotification*)` (called from registration blocks
   before their definitions in ABHostGeometry.m); minimal
   `@interface FBScene : NSObject` (ABHostGeometry.m's hook takes
   FBScene* and only sends NSObject/KVC messages).
8. `OmniCarAppBridge/ABChromeViews.h` (new): the four chrome-view
   @interface blocks (ABBoxView/ABShieldView/ABKnobView/ABBarButton)
   copied VERBATIM from ABChromeViews.m (which keeps its in-file copies
   and does not import the header) so ABHostLaunch.m / ABHostBMethods.m
   see full interfaces instead of forward classes.
9. `OmniCarAppBridge/ABKeyboardDecl.h` (new): ABKeyboard's @interface
   copied VERBATIM from ABKeyboard.m lines 63-84 (kept in-file there) for
   ABHostGeometry.m, which messages +shared/showForApp:/hideForApp:.
10. `OmniCarSplitScreen/SCPIntegrationShims.h` (new, force-included):
    NSDistributedNotificationCenter interface (as above);
    `id SCPGuardedSend(id, NSString*)` extern (A's helper, defined in
    SCPShared.m, called cross-TU from SCPSpringBoardHooks.m, undeclared
    in SCPShared.h); `NSObject (SCPBWallViewSelectors)` category
    declaring `-updatePlayback` (SplitScreenB's SCPHomeWallView method,
    sent to an `id` by SCPHomeSettings.m).
11. `OmniCarPrefs/PrefsIntegrationShims.h` (new, force-included):
    minimal interfaces for SBSRelaunchAction, FBSSystemService,
    LSApplicationWorkspace, LSApplicationProxy (signatures from call
    sites; classes resolved dynamically in the code); UIKit import;
    `<Preferences/PSSpecifier.h>` import + `PSSpecifier (OMCVendorGap)`
    category declaring `-setValues:titles:` (real Preferences method the
    Theos-vendored header omits); `UIImage (OMCPrivateIconAPI)` category
    declaring `+_applicationIconImageForBundleIdentifier:format:scale:`
    (call in OMCSpeedBubbleController.m is respondsToSelector:-guarded).
12. `OmniCarAppBridge/ABHost.h` (project copy) — merged header: B's
    version + A's 5 bar-action declarations (barReplace:/barPop:/barFull:/
    barBackground:/barClose:) in the `(ModuleA)` category + A's C helpers
    `ABPostAppState`/`ABBundleIDHash` at file scope; params later
    annotated `_Nonnull` (nullability-completeness errors). Per the A/B
    partition notes this union is the intended shared header.

Per-file fixes (project copies only; src/ untouched everywhere):
13. `OmniCarCarProbe/OmniCarCarProbe.m` — NSDistributedNotificationCenter
    interface added after imports (same as shim item 7, done in-file for
    this subproject); `value.description` → `[value description]`;
    `sub[key].description.lowercaseString` →
    `[[sub[key] description] lowercaseString]` (dot-syntax on `id` has no
    `.description` property in this SDK).
14. `OmniCarAppBridge/ABChromeViews.m` — added `#import "ABHost.h"`
    (uses +[ABHost shared] / outsideTouched).
15. `OmniCarAppBridge/ABHostLaunch.m`, `ABHostBMethods.m` — added
    `#import "ABChromeViews.h"` and `#import <objc/message.h>`.
16. `OmniCarAppBridge/ABHostGeometry.m` — added `#import "ABKeyboardDecl.h"`
    and `#import <objc/message.h>`; hook signature correction
    `void ABHook_SBSuspended(...)` → `BOOL ABHook_SBSuspended(...)`:
    every return in the body is BOOL and `orig_SBSuspended` is cast to a
    BOOL-returning pointer in the same function — the `void` was a
    transcription slip, provable entirely within the file.
17. `OmniCarAppBridge/ABInApp.m` — forward declarations added for the 14
    static hook functions installed near the top but defined further down
    the same file (signatures copied verbatim from their definitions:
    ABHook_UIWindowSetRotatable, ABHook_CADisplayLinkNew/SetFPS/SetRange,
    ABHook_TFBecome/TFResign, ABHook_TVBecome/TVResign,
    ABHook_UIDeviceBeginGen/SetOrientation/Orientation,
    ABHook_SceneRequestGeometry, ABHook_VCSetNeedsUpdate,
    ABHook_VCAttemptRotation); forward declaration of ABDisplayLinks
    corrected `NSMutableSet*` → `NSHashTable*` to match the file's own
    definition/body ("weak hash table" per its comment).
18. `OmniCarAppBridge/AppBridgeEntry.m` — added `#import <dlfcn.h>`
    (dlsym used in-file).
19. `OmniCarSplitScreen/SCPShared.m` — dropped `static` from
    `SCPGuardedSend` (A's own helper, called cross-TU; body unchanged).
20. `OmniCarSplitScreen/SCPHomeHooks.m` — the file's own
    SBIconImageInfoCompat typedef moved above the Orig-IMP slots and the
    first slot's element type spelled `SBIconImageInfoCompat` (it was
    written as the undeclared private name `SBIconImageInfo`).
21. `OmniCarPrefs/OMCCarProfilesController.m`,
    `OMCAppBridgeAppsController.m`, `OMCSplitScreenAppPickerController.m`,
    `OMCSplitScreenController.m`, `OMCStartupScreenController.m` — added
    `#import <Preferences/PSSpecifier.h>` (files use PSSpecifier without
    importing its header).
22. `OmniCarPrefs/OMCAppBridgeAppsController.m` — added
    `#import <objc/message.h>`.
23. `OmniCarPrefs/OMCAppBridgeAppsController.h` — @interface protocol
    list completed: `<UITableViewDataSource, UITableViewDelegate,
    UINavigationControllerDelegate, UIImagePickerControllerDelegate>`
    (the .m implements them and assigns self as delegate/dataSource).
24. `OmniCarPrefs/OMCStartupScreenController.h` — protocol list
    completed: `<UICollectionViewDataSource, UICollectionViewDelegate,
    UINavigationControllerDelegate, UIImagePickerControllerDelegate,
    UIDocumentPickerDelegate>` (same reason).
25. `OmniCarPrefs/OMCCardPage.m` — `[sender selectionChanged]` →
    `[(id)sender selectionChanged]` (message send unchanged;
    UISegmentedControl declares no such selector).
26. `OmniCarPrefs/OMCCommon.m` — added `#import "SSStartupView.h"` (the
    weather/nextEvent/batteryPercent property types AGREE between A's
    category use and B's header); its local
    `@interface SPPSoundDelegate` completed in place with
    `<AVAudioPlayerDelegate, AVSpeechSynthesizerDelegate>` (an earlier
    attempt to import SPPSoundDelegate.h instead was reverted — it
    duplicated the interface).
27. `OmniCarPrefs/SSStartupView.m` — ivar element type spelled out:
    `NSArray *_cardInsets` → `NSArray<NSLayoutConstraint *> *_cardInsets`
    (it is assigned an array of constraints; the `.constant` accesses
    need the element type). No body change.

Source syntax-typo repairs (defects present identically in src/; each has
exactly one reading consistent with the surrounding code):
28. `OmniCarPrefs/OMCStartupScreenController.m` (~line 637) —
    `hasFramesForVideo:`: removed ONE extra leading `[` from
    `[[[[SSReal(...)` (four opens vs three chained sends/three closes;
    the flat chain style matches lines 491-494 of the same file). NOTE:
    a first attempt added a trailing `]` instead — count-balanced but
    ungrammatical; replaced by this fix.
29. `OmniCarPrefs/OMCStartupScreenController.m` (lines ~685, ~700) —
    two block arguments to `dispatch_async` (a C function) were closed
    `}];` instead of `});`; corrected both.


## BLOCKERS (logic disagreements / missing content — NOT fixed, per rules)

### BLOCKER-CORE-APPBRIDGE — two disagreeing core copies (AppBridge)
A's local core copy `OmniCarAppBridge/OMCCore.m` disagrees with the shared
unit (`project/OMCCommon/OMCCommon.c`, = CarProbe's and Prefs' readings):
- `OMCEnabled` / `OMCFeatureEnabled` defaults: A returns `kCFBooleanFalse`
  (NO); shared unit @YES.
- `OMCExpired` deadline: A uses an INFERRED constant 1809216000; shared
  unit's verified value is 1809104400 (2027-05-01 00:00 GMT+7).
- `OMCLiteActive` branch structure differs.
- `OMCCarWireless` spelled BOOL (A) vs int (shared) vs NSInteger
  (AppBridgeB.h); `OMCHasMethod` 2nd param NSString* (A, shared) vs
  `const char*` (B's header).
Arrangement chosen (compiling-neutral): OMCCore.m copied but EXCLUDED from
`_FILES` (Makefile comment cites this blocker); the shared unit builds.
Side effect: `ABMissingSelector(id, NSString*)` — an AppBridge-specific
helper A parked inside OMCCore.m (def. line 183, decl. OMCCore.h:88) — is
missing at link. Phase 2 must either extract it (and audit OMCCore.m for
other AppBridge-specific helpers) or resolve the core conflict and include
the file.

### BLOCKER-CORE-CARPROBE — CarProbe's TU cannot take the shared unit
`OmniCarCarProbe.m` inseparably embeds its own core copy (the file IS the
OMCCommon translation unit; it also `#define`s `OMC_MODULE_NAME
"CarProbe"` itself, line 51). Appending the shared unit would duplicate
~21 symbols, so OMCCommon.mk was REMOVED from this subproject's Makefile
(deviation, documented there). Its defaults AGREE with the shared unit
(@YES/@YES). Phase 2: split the TU or accept the per-module core copies
as the project's structure.

### BLOCKER-CORE-PREFS — Prefs core copy collides with the shared unit
The shared unit is NOT appended to OmniCarPrefs: Prefs-A's `OMCCommon.m`
carries the Prefs binary's core copy PLUS ~25 Prefs-only helpers in the
same file, and 7 symbols collide with the shared unit:
OMCSupportedLanguages, OMCCurrentLanguage, OMCTr, OMCExpired, OMCEnabled,
OMCProfileKeys, OMCLogoMeshImage — the last with a DIFFERENT signature
(Prefs: `UIImage *OMCLogoMeshImage(void)`; shared: `id
OMCLogoMeshImage(int style)`). Prefs' OMCEnabled/OMCExpired logic AGREES
with the shared unit (no default/deadline conflict here). Apart from the
already-fixed `_OMCSwitchColor`, no further logic differences between
Prefs' copy and the shared unit were asserted in phase 1 — a line-level
diff of the overlapping functions is still owed (phase 2). Dedupe is a
phase-2 decision.

### BLOCKER-AB-ZOOM — `-[ABHost zoom]` body fragment (ABHostBMethods.m)
The method's signature line and prologue are MISSING in B's source. What
survives (lines 55-63): the spec comment — "OMCPrefsSync(); v =
[OMCPref(@"appBridgeZoom", @80) doubleValue]; return MIN(MAX(v / 100.0,
0.3), 1.0)" (default @80 verified by verifier #3) — and the orphan
fragment `return MIN(MAX(v, 0.3), 1.0); }`. The fragment's return omits
the `/100.0` the comment's version has, so where the division sat (lost
line vs return expression) is ambiguous. NOT authored. The same file has
3 dot-on-`id` errors (`pane.appViewController.view`, lines ~127/136/147;
ABPane's appViewController is typed `id` in ABHost.h).

### BLOCKER-AB-KEYBOARD — six ABKeyboard methods exist only as comments
ABKeyboard.m (364 lines): buildPanel, rebuildKeys, layoutPanelIn:,
layoutKeys, key:pressed:, key:symbol:value:command:weight: appear ONLY as
comment summaries (~lines 318-364; B's report §9 item 2, "condensed
cosmetic layout"); they are CALLED at lines 144-271 but declared/defined
nowhere. 9 compile errors. NOT authored. Disassembly dumps exist in
`src/AppBridgeB/disasm/` for a phase-2 reconstruction.

### BLOCKER-AB-PANE — no `@implementation ABPane` exists
Neither half implements ABPane (interface in ABHost.h: 17 ivars; B counts
35 synthesized accessors). `_OBJC_CLASS_$_ABPane` undefined at link.
Phase 2 must supply the implementation (accessors are mechanical once a
decision is taken to synthesize them in one TU).

### BLOCKER-AB-CHANNELS — channel-name constants declared, never defined
`ABChanState, ABChanFrame, ABChanKey, ABChanKnobTouch, ABChanOrientation,
ABChanShield, ABChanBarDismiss` and `ABNotifyAppOrient, ABNotifyKeyboard`
are declared `extern` in AppBridgeB.h and used across the subproject but
defined in NO file of either A or B. Their string values are documented
in AppBridgeB.h's comments and `metadata/IPC_MAP.md`. Phase 2 writes the
definitions TU (not authored in phase 1: a wrong string breaks IPC
silently).

### BLOCKER-SPLIT-B — SplitScreenB not yet integrated
Phase-1 scope (B sources being edited by the closure agent). Consequences
measured: SCPCarSplit.m fails on the B-owned `SCPCarSplitView` class
(only an @class forward in SCPShared.h; ~15 forward-class errors) and on
the `(SplitScreenB)` category implementations living in B's files;
SCPHomeApply.m imports `"../SplitScreenB/SCPHomeWallView.h"` (missing).

### BLOCKER-SPLIT-SEAM — A↔C naming/linkage/signature mismatch (19 symbols)
The diagnostic link (A+C only) reports 19 undefined symbols in 3 classes:
1. Underscore-in-source names: A's SCPShared.h/SCPHooks.m declare and
   call 8 C functions with a literal leading underscore in the identifier
   (`_SCPAppIconsBeginInjection`, `_SCPHomeSetVisible`, `_SCPHomeRefresh`,
   `_SCPSetHomeViewController`, `_SCPChosenPhoneApps`,
   `_SCPIsInjectedPhoneApp`, `_SCPInjectDeclarationIfChosen`,
   `_SCPAddChosenAppsToLibrary`) — producing `__SCP*` symbols that exist
   nowhere. C defines the same functions WITHOUT the underscore, matching
   the original binary's symtab (`_SCP*` single-underscore). On naming,
   C is provably right and A is provably wrong (symbol-table arithmetic),
   but applying the rename is a phase-2 edit of A's headers.
2. Signature disagreements (logic — adjudication required):
   - BeginInjection: A `void (void)` vs C `BOOL (void)` (C read the body).
   - HomeSetVisible: A `void (id vc, BOOL visible)` — self-labelled
     "arg order INFERRED", called as `_SCPHomeSetVisible(self, YES)` —
     vs C `void (BOOL visible)` (VERIFIED from the body at 0x4b4bc).
   The remaining 6 functions' signatures must be compared pair-wise in
   phase 2 against the same standard.
3. Hook-name mismatch: A's installer (SCPHooks.m:452-455) expects
   `SCPHook_Grid_iconImageInfo`, `SCPHook_Grid_portraitColumns/Rows`,
   `SCPHook_Grid_landscapeColumns/Rows`, `SCPHook_IconView_setLabelHidden`,
   `SCPHook_IconModel_isIconVisible`, `SCPHook_IconView_maxLabelSize`,
   `SCPIconModelClass`, `SCPHomeKick`, `SCPMissingSelector`,
   `SCPSyntheticLaunchInfo`. C defines the bodies as STATIC functions
   named `SCPHook_IconImageInfo`, `SCPHook_PortraitColumns/Rows`,
   `SCPHook_LandscapeColumns/Rows`, `SCPHook_SetLabelHidden`,
   `SCPHook_IsIconVisible`, `SCPHook_MaxLabelSize` — different names AND
   file-local linkage. C additionally PROVED sub_5520 is `SCPLogException`
   (a pure logger), not A's guessed "SCPHomeKick". Arbiter for the
   original names/linkage: the binary symtab via `metadata/`.

### BLOCKER-PREFS-HUD — `SSStartupView.hud` type war
Prefs-A's `(OMCSampleData)` category inside OMCCommon.m declares
`hud: BOOL`; B's SSStartupView.h declares `hud: NSArray*`. With B's
header imported (fix 26 — needed for the agreeing properties),
OMCCommon.m fails ONLY at line 1142, `view.hud = YES;` (BOOL→NSArray*
conversion disallowed under ARC). No compiling arrangement keeps both
declarations. A coordinator/verifier decision is required (which type
does the binary's SSStartupView actually store?). Consequence: Prefs
cannot link in phase 1 — OMCCommon.m carries ~40 C functions used
everywhere in the bundle.

### BLOCKER-PREFS-OMCICON — one-argument `OMCIcon` calls (assumption flagged)
OMCAppBridgeAppsController.m had 3 call sites passing ONE argument to
`OMCIcon(symbol, color)` (declared 2-arg in Prefs' OMCCommon.h:175,
defined OMCCommon.m:475). Completed mechanically with `, nil` plus an
integration comment at each site (lines 562, 624, 674). This is an
ASSUMPTION needing verification: with nil, `[color getHue:…]` is a no-op
→ h=0 → the implementation's pink-pair branch is taken deterministically.
If the original call sites passed a real color, the rendered icons
differ.

### BLOCKER-SB-NOTIFYARGS — SpeedBubble notify call arity (embargoed files)
SPPDisplayBoot.m calls `notify_register_dispatch(name, queue, block)`
with 3 arguments at 7 sites, omitting the SDK's `int *out_token` second
parameter (same dropped-argument family as BLOCKER-PREFS-OMCICON).
SPPBubble.m lacks `<objc/runtime.h>`/`<objc/message.h>` imports
(objc_getClass/objc_msgSend undeclared) and has 1 unused variable
(`weakSelf`); SPPPrefs.m calls notify_post without importing <notify.h>;
SPPOverspeed.m has 1 objc_msgSend error. Resolution DEFERRED until
verifier #4 reports: SPPDisplayBoot.m is inside the bit-17 adjudication
set, and the task forbids editing SpeedBubble sources this phase.

### PENDING-VERIFIER — SpeedBubble duplicate `__init_0`
A's SPPDisplayBoot.m and B's SBOpenCar.m both define `__init_0`. Left in
place per instructions; the expected duplicate-symbol link conflict is
PENDING verifier #4's report (evidence so far favours the display side).
Not yet reached (compile stops earlier).

### Carried notes (not blockers)
- AppBridgeA's `carDisconnected` body was downgraded to INFERRED by
  verifier #1 (fix at integration was promised by the module; the
  project copy is as delivered).
- SplitScreenA's report prose says "init_0 = 17 hooks"; the true count
  is 16 (its own table is correct) — prose fix owed by the module, noted
  here so phase 2 does not propagate it.
- `SCPDynamicLabelColor` (SCPCarApps.m) is an unused static function in
  C's source; demoted, not deleted.

## What phase 2 still needs (precise list)

1. **SplitScreenB sources** — copy in when the closure agent finishes;
   then: SCPCarSplitView/SCPCarSplit/SCPHomeWallView interfaces become
   real, the `(SplitScreenB)` categories link, SCPHomeApply.m's header
   import resolves.
2. **StartupScreen module** — replace the placeholder subproject with
   the real sources (8 classes / 173 methods per the original
   fingerprint) when the module agent delivers.
3. **BLOCKER-SPLIT-SEAM resolution** — rename A's underscore-prefixed
   declarations to C's symtab-true names; adjudicate the 2 signature
   conflicts (+ compare the other 6) against the binary; unify hook
   names/linkage between A's installer and C's bodies using `metadata/`
   as arbiter; supply SCPIconModelClass / SCPMissingSelector /
   SCPSyntheticLaunchInfo owners.
4. **BLOCKER-CORE-* decisions** — one core per binary vs one shared unit:
   resolve AppBridge's default/deadline conflicts against the verified
   shared readings (@YES, 1809104400); extract `ABMissingSelector` from
   OMCCore.m if the file stays excluded; split or formalize CarProbe's
   embedded TU; dedupe Prefs' 7 colliding symbols incl. the
   OMCLogoMeshImage signature conflict; line-diff Prefs' core copy vs
   the shared unit.
5. **BLOCKER-AB-ZOOM** — reconstruct `-[ABHost zoom]`'s missing
   signature/prologue from disassembly (decide where `/100.0` sits);
   fix the 3 dot-on-`id` pane accesses in ABHostBMethods.m.
6. **BLOCKER-AB-KEYBOARD** — reconstruct the 6 comment-only ABKeyboard
   layout methods from `src/AppBridgeB/disasm/`.
7. **BLOCKER-AB-PANE** — supply `@implementation ABPane` (35 accessors).
8. **BLOCKER-AB-CHANNELS** — write the ABChan*/ABNotify* definitions TU
   from AppBridgeB.h comments + `metadata/IPC_MAP.md`.
9. **BLOCKER-PREFS-HUD** — adjudicate `SSStartupView.hud` (BOOL vs
   NSArray*) against the binary; then Prefs links (its only gap).
10. **BLOCKER-PREFS-OMCICON** — verify the 3 `, nil` completions against
    the binary (were the original calls 1-arg with an implicit color?).
11. **SpeedBubble, after verifier #4 reports** — dedupe `__init_0`
    (SPPDisplayBoot.m vs SBOpenCar.m); fix the notify_register_dispatch
    arity (BLOCKER-SB-NOTIFYARGS) and SPPBubble.m imports; apply
    SBScan.m's 3 contract edits (sub_a2c4 returns int; sub_a530 is a
    diagnostic logger; sub_aa4c returns UIColor*); settle the bit-17
    polarity in whichever file the verifier rules against.
12. **Prefs syntax defects** — the 3 transcription typos fixed in the
    project copy of OMCStartupScreenController.m (items 28-29) also
    exist in `src/Prefs/OMCPrefs/OMCStartupScreenController.m`; the
    module should fix them at the source so future copies are clean.
13. **Final packaging pass** — build all 8 subprojects from the restored
    root Makefile; ownership/mode parity vs the original (root:wheel
    0:20, modes) verified via `dpkg-deb -c`; FINALPACKAGE build so the
    Version field is exactly `1.0.3`; re-run `tools/diff_payload.py`
    (targets: AppBridge 8/193, SplitScreen 11/480, SpeedBubble 9/277,
    StartupScreen 8/173, Prefs 29/743 classes/methods); arm64e remains
    impossible on this VM (documented functional difference).

## Logs (project/logs/)

- `phase1-<name>.log` per subproject (first full builds + fixes rounds).
- `phase1-diag-appbridge.log`, `phase1-diag-splitscreen.log`,
  `phase1-diag-prefs.log` — exclusion diagnostics cited above.
- `phase1-speedbubble.log` — as-is build attempt (embargo record).
- `phase1-final-OmniCarAppBridge.log`, `phase1-final-OmniCarSplitScreen.log`,
  `phase1-final-OmniCarPrefs.log` — final phase-1 states.
- `phase1-aggregate.log`, `phase1-diff.txt` — aggregate build + diff.
