# App_REPORT — OmniCar.app (com.anlai.omnicar.app 1.0.3), reconstruction report

Scope: the `OmniCar` executable inside `OmniCar.app` (168,880 B fat file;
arm64 slice analysed, arm64e slice has an identical ObjC surface per
wave-1 metadata). Evidence: full annotated disassembly in
`src/App/disasm/OmniCar_app_annotated.txt`, produced by
`metadata/tools/xref_run.py`. Every statement below marked **proven** was
read directly from that disassembly; statements marked **inference** are
source-shape reconstructions that produce the identical call sequence.

## Trust basis for the disassembly

These lld-built images store chained-fixup bind ordinals 0-based while
the wave-1 parser decoded them 1-based, which silently shifted every
import/class name by one (e.g. the app's first classref decoded as
`__CFConstantStringClassReference` instead of `UIWindow`). Before any
analysis, the xref engine was calibrated against LC_DYSYMTAB indirect
symbols — ground truth independent of chained fixups. The correction
(delta +1) is unanimous on **1,478 checked slots across all 8 binaries**
(20/20 in this app). All names in the disassembly and in the three maps
come from the calibrated decode, with DYSYMTAB names overriding wherever
they exist. This also means wave-1 per-binary metadata name fields
(classrefs/superclass decodes) may be shifted by one import in places;
the wave-2 maps supersede them.

## What the app is

A thin **command receiver / trampoline** for Shortcuts and Siri. It has:

- One class, `OMCAppDelegate : UIResponder <UIApplicationDelegate>`,
  one ivar (`_window`), 6 methods (4 real + synthesized `window` /
  `setWindow:` + `.cxx_destruct`). ARC-compiled (**proven**: objc_retain /
  objc_retainAutoreleasedReturnValue / objc_storeStrong patterns).
- `_main` = textbook `UIApplicationMain(argc, argv, nil,
  NSStringFromClass([OMCAppDelegate class]))` inside an autorelease pool
  (**proven**, 0x100004688).
- **No nib, no storyboard, no scene lifecycle** (**proven**: Info.plist
  has no `UIMainStoryboardFile`, no `UIApplicationSceneManifest`; the
  class implements no scene-session methods). Window-based lifecycle.
- Info.plist (**proven**, copied verbatim to `src/App/Info.plist`):
  bundle `com.anlai.omnicar.app`, version 1.0.3 (build 1), URL scheme
  `omnicar` (single `CFBundleURLTypes` entry), portrait only,
  `UIRequiresFullScreen`, `UIUserInterfaceStyle = Dark`, iPhone only
  (`UIDeviceFamily = [1]`), min iOS 15.0, no background modes.

## What the UI does (didFinishLaunchingWithOptions:, 0x100004000) — all proven

Built entirely in code, in this exact order:

1. `self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds]`
2. Root `UIViewController` (plain, via `+new`); its view's background is
   `colorWithRed:0.05 green:0.07 blue:0.15 alpha:1.0` (dark navy;
   constants in `__TEXT,__const` @ 0x100005058…).
3. Language pick: `[[[NSLocale preferredLanguages] firstObject]
   hasPrefix:@"vi"]` — a single BOOL selecting between a Vietnamese and
   an English string for each of the four UI strings below (csel pairs).
4. A `UILabel`: frame = `CGRectInset(rootView.bounds, 24, 0)`,
   `numberOfLines = 0`, white text, `systemFontOfSize:15`,
   `textAlignment = center`, `autoresizingMask = 0x12`
   (flexible width | flexible height). Text =
   `[NSString stringWithFormat:]` of the constant template
   `@"OmniCar\n\n%@\n\n%@\n\nomnicar://splitscreen/open?left=com.apple.Maps&right=com.spotify.client\n\nomnicar://splitscreen/fav?n=1\n\nomnicar://splitscreen/close\n\n%@"`
   with the three localized sentences (vi/en):
   - "App này nhận lệnh từ Shortcuts / Siri." / "This app receives commands from Shortcuts / Siri."
   - "Tạo Shortcut với hành động \"Mở URL\":" / "Create a Shortcut with the \"Open URL\" action:"
   - "Cài đặt chi tiết: Cài đặt > OmniCar" / "Settings: Settings > OmniCar"

   The Vietnamese constants are stored as UTF-16LE `__NSConstantString`s
   (flags 0x7d0); an ASCII-only read truncates them to one character —
   the wave-2 reader decodes them in full (verified byte-by-byte).
5. A system `UIButton` (`buttonWithType:1`) titled "Mở Cài đặt OmniCar" /
   "Open OmniCar Settings", frame `(0, viewHeight − 90, viewWidth, 44)`,
   `autoresizingMask = 0xA` (flexible width | flexible top margin),
   target = the delegate, action = `@selector(openSettings)`,
   control events `0x40` (touchUpInside).
6. `window.rootViewController = vc`, `[window makeKeyAndVisible]`,
   returns `YES`.

## Settings deep link (openSettings, 0x1000043F4) — proven

```objc
[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"prefs:root=OmniCar"]
                                   options:@{}        // ___NSDictionary0__ shared empty dict
                         completionHandler:nil];
```

i.e. the button opens Settings at the OmniCar (PreferenceLoader) page.

## URL handling (application:openURL:options:, 0x100004468) — proven

The app is the receiving end of the `omnicar://` scheme, and it does
**not** parse routes:

1. If `[[url scheme] isEqualToString:@"omnicar"]` is false → return `NO`
   (nothing else happens except step 4).
2. `NSClassFromString(@"NSDistributedNotificationCenter")` — resolved
   dynamically; the app links **no** notification API itself (its import
   list contains no notify/CFNotificationCenter symbols at all). If the
   class is missing → return `NO`.
3. Otherwise it posts through that center:
   - name: `com.anlai.omnicar/url`
   - object: `nil`
   - userInfo: `@{ @"url": [url absoluteString] }` (built with
     `dictionaryWithObjects:forKeys:count:`, count 1)
   and returns `YES`. The full URL string is forwarded **verbatim** —
   routing (`/splitscreen/open?left=…&right=…`, `/splitscreen/fav?n=1`,
   `/splitscreen/close`, as shown in the label text) is the job of the
   observing processes: IPC_MAP §3 proves block-based observers of this
   exact name in OmniCarCore (handler sub_5728) and OmniCarSplitScreen
   (handler sub_8f6c), both registered through
   `addObserverForName:object:queue:usingBlock:` on the distributed
   center.
4. **Unconditionally** — on both the handled and unhandled paths — it
   schedules `dispatch_after(dispatch_time(NOW, 300,000,000 ns),
   main_queue, block)`; the block (global block @ 0x1000080C0, invoke
   function 0x1000045E4) performs
   `[[UIApplication sharedApplication] performSelector:@selector(suspend)]`.
   So 0.3 s after any `omnicar://` open, the app backgrounds itself via
   the private `suspend` selector — a Shortcut lands back where it
   started.

Reconstruction (`src/App/OMCAppDelegate.m`) preserves this control flow,
including the detail that the return flag is set to YES immediately after
the center is obtained, before the userInfo dictionary is built
(w20 = 1 at 0x100004520, prior to `dictionaryWithObjects:forKeys:count:`).

## IPC summary for the app

Exactly one IPC act: the distributed notification above. No Darwin
`notify_*` calls, no CFPreferences access, no hooks, no XPC (consistent
with its 38 undefined symbols, all accounted for in the disassembly's
stub tables). Rows: IPC_MAP §3 (`com.anlai.omnicar/url`), zero rows for
the app in PREFS_MAP and HOOK_MAP — that absence is itself xref-proven
(no call sites to those APIs exist in the binary).

## Verified vs inferred

- **Verified from disassembly**: every API call, argument constant,
  string (incl. the UTF-16 Vietnamese set), color/frame constants,
  control flow, the suspend-after-0.3 s behaviour, the verbatim-URL
  forwarding, the empty-options Settings link.
- **Inferred (source shape only)**: local variable names, whether the
  language choice was written as ternaries (the csel pattern proves the
  selection, not the spelling), the exact expression grouping of the
  button frame (two `view.bounds` reads in the binary; the source writes
  it as one CGRectMake), and ARC surface syntax (the binary is
  ARC-compiled; the source is written in ARC style, memory calls
  omitted as the compiler emits them).
- **Not present / not claimed**: no other classes, categories, C
  functions (the only non-method functions are `_main` and the one block
  invoke, both reconstructed), no `%ctor`, no settings/plist reads.

## Files

- `src/App/main.m`, `src/App/OMCAppDelegate.h`, `src/App/OMCAppDelegate.m` — reconstructed source (complete for this binary; no stubs).
- `src/App/Info.plist` — verbatim copy of the shipped bundle Info.plist.
- `src/App/disasm/OmniCar_app_annotated.txt` — full annotated disassembly of the arm64 slice (all 9 functions, __objc_stubs and __stubs tables).
- Machine data: `metadata/xref/OmniCar.json` (120 call records including 4 tail calls; functions, cfstrings, block map).
