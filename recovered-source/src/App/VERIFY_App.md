# VERIFY_App — independent verification of the App module reconstruction

Verifier: rolling verifier #1 (wave 2.5), 2026-11-08. Method: the verifier's
own capstone disassembly of `OmniCar.app/OmniCar` (arm64 slice) with
ground truth resolved by `verify/macho_truth.py` (LC_DYSYMTAB indirect
symbols for stubs; hand-decoded `__objc_stubs`; chained-fixups format-6,
0-based ordinals). The agent's annotated dump was never used as evidence.

## The off-by-one claim in App_REPORT §"Trust basis" — CONFIRMED

The report states the wave-1 parser decoded chained-fixup bind ordinals
1-based, shifting every bind-derived name by one import. This is **true**,
and the bug is visible in the parser's own code
(`metadata/tools/macho_objc.py::_import_name` returns
`imports[ordinal - 1]`; dyld ordinals are 0-based). Independent proof:

- My 0-based decode of the app's first classrefs gives UIWindow, UIScreen,
  UIViewController, UIColor, NSLocale, UILabel, UIFont, NSString, UIButton,
  UIApplication, NSURL, NSDictionary, OMCAppDelegate — exactly the classes
  the code uses, in use order. The 1-based decode gives the nonsense the
  report describes.
- The same correction turns every "surprising superclass" in wave-1
  metadata into the obvious one (full corrected table in
  `metadata/ANNOTATION_AUDIT.md`, addendum). E.g. SCPCButton → UIButton,
  SCPCarSplitView → UIView, ABPane → NSObject.
- The agent's calibrated names agree with my independent decode at every
  point checked (all call annotations in the app dump: 117/117, see
  ANNOTATION_AUDIT; all classrefs above).

## Per-function verdicts (all functions in the binary)

| Function | VA | Report claim | Verdict |
|---|---|---|---|
| `-[OMCAppDelegate application:didFinishLaunchingWithOptions:]` | 0x100004000 | proven, step-by-step | **CONFIRMED** — every step re-traced: UIWindow alloc/initWithFrame(mainScreen.bounds) → setWindow:; root VC via `_objc_opt_new`; color constants at 0x100005058 = **0.05 / 0.07 / 0.15**, alpha 1.0; `preferredLanguages→firstObject→hasPrefix:@"vi"`; label frame = CGRectInset(view.bounds, **24, 0**); numberOfLines 0; whiteColor; systemFontOfSize **15**; textAlignment **1**; autoresizing **0x12**; format template and all six localized strings read byte-exact from the cfstrings (table below); button `buttonWithType:1`, frame (0, H−90, W, 44) — constant at 0x100005070 = **−90.0**, height **44.0**, and the binary does read `view.bounds` twice as the report notes; autoresizing **0xA**; addTarget action selref = `openSettings`, events **0x40**; setRootViewController:; makeKeyAndVisible; returns 1 |
| `-[OMCAppDelegate openSettings]` | 0x1000043F4 | proven | **CONFIRMED** — `openURL:options:completionHandler:` with URL string `prefs:root=OmniCar`, options = `___NSDictionary0__` shared empty dict, completion = nil |
| `-[OMCAppDelegate application:openURL:options:]` | 0x100004468 | proven | **CONFIRMED** — scheme `isEqualToString:@"omnicar"` gate; `NSClassFromString(@"NSDistributedNotificationCenter")`; nil-class → NO; `defaultCenter` sent to the class object; **w20 = 1 at 0x100004520, before `dictionaryWithObjects:forKeys:count:`** (the report's flagged detail is real); userInfo = `@{@"url": absoluteString}` count 1; posts `com.anlai.omnicar/url`, object nil; both paths converge at 0x100004578 → `dispatch_time(0, 0x11E1A300 = 300,000,000 ns)` + `dispatch_after` on `__dispatch_main_q` — unconditional self-suspend scheduling exactly as claimed |
| block invoke (suspend) | 0x1000045E4 | proven | **CONFIRMED** — sharedApplication → `performSelector:` with selref `suspend`; block literal is the global block at 0x1000080C0 |
| `window` getter | 0x100004624 | synthesized | **CONFIRMED** — ivar load via the offset at 0x10000C7E0 |
| `setWindow:` | 0x100004634 | synthesized | **CONFIRMED** — retain-new / store / release-old pattern |
| `.cxx_destruct` | 0x100004674 | synthesized | **CONFIRMED** — `_objc_storeStrong` on the `_window` ivar |
| `_main` | 0x100004688 | proven | **CONFIRMED** — autoreleasePoolPush/Pop around `UIApplicationMain(argc, argv, nil, NSStringFromClass([OMCAppDelegate class]))`; classref at 0x10000C7D0 = OMCAppDelegate |
| class declaration (header) | — | UIResponder <UIApplicationDelegate>, ivar `_window` | **CONFIRMED** — my decode of the class struct's superclass slot = `_OBJC_CLASS_$_UIResponder`; ivar list = `_window` |

## Strings — all 15 read directly from the binary's cfstrings, all match

`@"vi"`; format template `OmniCar\n\n%@\n\n%@\n\nomnicar://splitscreen/open?left=com.apple.Maps&right=com.spotify.client\n\nomnicar://splitscreen/fav?n=1\n\nomnicar://splitscreen/close\n\n%@`;
vi/en pairs: "App này nhận lệnh từ Shortcuts / Siri." / "This app receives commands from Shortcuts / Siri.";
"Tạo Shortcut với hành động \"Mở URL\":" / "Create a Shortcut with the \"Open URL\" action:";
"Cài đặt chi tiết: Cài đặt > OmniCar" / "Settings: Settings > OmniCar";
"Mở Cài đặt OmniCar" / "Open OmniCar Settings";
`prefs:root=OmniCar`; `omnicar`; `NSDistributedNotificationCenter`;
`com.anlai.omnicar/url`; `url`. The csel selection picks the 0x…120/160/1A0/1E0
(UTF-16, flags 0x7D0) strings when the language test is true — i.e. the
Vietnamese set is the `vi` branch, as the source has it.

## Cross-module claim (IPC_MAP §3) — CONFIRMED

The report states `com.anlai.omnicar/url` is observed in OmniCarCore
(handler sub_5728) and OmniCarSplitScreen (handler sub_8f6c) via
`addObserverForName:object:queue:usingBlock:`. Verified independently:
Core ctor function 0x46F0 references the name cfstring (0x14928) at 0x4818
and calls the `addObserverForName:` selector stub at 0x4830; the block
literal it registers (0x14568, `__NSConcreteGlobalBlock`) has invoke =
**0x5728**. SplitScreen function 0x8540 references the name cfstring
(0x7A0A0) at 0x86B8 among its observer registrations; its block literal
(0x78960) has invoke = **0x8F6C**. Both handler addresses exact.

## Stub honesty

`grep` for STUB/TODO/FIXME over `main.m`, `OMCAppDelegate.h/.m`: none.
No empty or trivial bodies; the report claims no stubs and none exist.
`src/App/Info.plist` is **byte-identical** (`cmp`) to the payload's
Info.plist, as claimed.

## Summary

claimed-verified **8/8 functions + 15/15 strings + plist** /
confirmed **all** / downgraded **0** / wrong **0** / undeclared-stubs **0**.
The module is small and the reconstruction is exact; the source's declared
"inferred" residue (local variable names, ternary spelling) is honestly
labelled and behaviour-neutral.
