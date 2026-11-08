# OmniCar — binary metadata (OmniCar 1.0.3)

- Payload path: `var/jb/Applications/OmniCar.app/OmniCar`
- Kind: app; filetype: EXECUTE; fat size: 168880 bytes
- Parser warnings (arm64 slice): none
- arm64/arm64e ObjC surfaces identical: True (verified: names, method counts, superclasses, ivars, categories, protocols, selrefs, classrefs compared programmatically)

## Load commands

| slice | size | UUID | min iOS | SDK |
|---|---|---|---|---|
| arm64 | 70576 | DAF904BE-27FB-3A55-B76A-5DAE329F6A3A | 15.0.0 | 16.4.0 |
| arm64e | 70576 | DAFE2BC8-3E59-3424-AED0-0C2AAECF907B | 15.0.0 | 16.4.0 |

- Encryption (LC_ENCRYPTION_INFO_64): cryptid=0 cryptoff=16384 cryptsize=16384 → not encrypted
- Code signature (LC_CODE_SIGNATURE): present, dataoff=68512 datasize=2064
- Chained fixups: True; classic dyld info: False
- Linked libraries (LC_LOAD_DYLIB, arm64 slice; identical in arm64e unless noted):
  - `/usr/lib/libobjc.A.dylib` (current 228.0.0, compat 1.0.0)
  - `/System/Library/Frameworks/Foundation.framework/Foundation` (current 1971.0.0, compat 300.0.0)
  - `/System/Library/Frameworks/CoreFoundation.framework/CoreFoundation` (current 1971.0.0, compat 150.0.0)
  - `/System/Library/Frameworks/UIKit.framework/UIKit` (current 6441.1.101, compat 1.0.0)
  - `/usr/lib/libSystem.B.dylib` (current 1319.100.3, compat 1.0.0)
  - `/System/Library/Frameworks/CoreGraphics.framework/CoreGraphics` (current 1690.5.4, compat 64.0.0)
- Rpaths (LC_RPATH):
  - `/var/jb/Library/Frameworks`
  - `/var/jb/usr/lib`
  - `@loader_path/.jbroot/Library/Frameworks`
  - `@loader_path/.jbroot/usr/lib`
- Info.plist (selected keys; full JSON in raw/):
  - CFBundleIdentifier: `"com.anlai.omnicar.app"`
  - CFBundleExecutable: `"OmniCar"`
  - CFBundleShortVersionString: `"1.0.3"`
  - CFBundleVersion: `"1"`
  - MinimumOSVersion: `"15.0"`
  - CFBundleURLTypes: `[{"CFBundleURLName": "com.anlai.omnicar", "CFBundleURLSchemes": ["omnicar"]}]`

## Objective-C surface (arm64 slice; arm64e identical)

Classes: 1; methods on classes: 6; categories: 0; protocols defined: 2; classrefs: 13; selrefs (unique): 112

Full class/ivar/property/method listing: see `objc_dump.txt` in this binary's raw/ folder. Class summary:

- `OMCAppDelegate` : `_OBJC_METACLASS_$_NSObject` (ivars 1, properties 5, instance methods 6, class methods 0, protocols <UIApplicationDelegate>)
- protocol `NSObject` (instance methods 19, class methods 0)
- protocol `UIApplicationDelegate` (instance methods 0, class methods 0)

## Symbols

Defined (external): 4; defined (local): 0; stab entries: 1; undefined (imports): 38; exports (trie): 4

Defined symbols:
- `_OBJC_CLASS_$_OMCAppDelegate`
- `_OBJC_METACLASS_$_OMCAppDelegate`
- `__mh_execute_header`
- `_main`

Stab (debug) entries: ['radr://5614542']

Infrastructure / hook / IPC imports check (against undefined symbols):
- `MSHookMessageEx`: absent
- `MSHookFunction`: absent
- `MSHookClassPair`: absent
- `MSFindSymbol`: absent
- `MSGetMessageEx`: absent
- `notify_register_dispatch`: absent
- `notify_post`: absent
- `notify_get_state`: absent
- `notify_set_state`: absent
- `notify_register_check`: absent
- `notify_cancel`: absent
- `CFNotificationCenterAddObserver`: absent
- `CFNotificationCenterPostNotification`: absent
- `CFNotificationCenterGetDarwinNotifyCenter`: absent
- `CFNotificationCenterGetLocalNotifyCenter`: absent
- `xpc_connection_create`: absent
- `xpc_connection_create_mach_service`: absent
- `rocketbootstrap_distributedmessagingcenter_apply`: absent
- Logos-generated symbols (name contains 'logos'): none found
- Swift sections: none

Undefined symbols (full list):
- `_CGRectInset`
- `_NSClassFromString`
- `_NSStringFromClass`
- `_OBJC_CLASS_$_NSDictionary`
- `_OBJC_CLASS_$_NSLocale`
- `_OBJC_CLASS_$_NSString`
- `_OBJC_CLASS_$_NSURL`
- `_OBJC_CLASS_$_UIApplication`
- `_OBJC_CLASS_$_UIButton`
- `_OBJC_CLASS_$_UIColor`
- `_OBJC_CLASS_$_UIFont`
- `_OBJC_CLASS_$_UILabel`
- `_OBJC_CLASS_$_UIResponder`
- `_OBJC_CLASS_$_UIScreen`
- `_OBJC_CLASS_$_UIViewController`
- `_OBJC_CLASS_$_UIWindow`
- `_OBJC_METACLASS_$_NSObject`
- `_OBJC_METACLASS_$_UIResponder`
- `_UIApplicationMain`
- `__NSConcreteGlobalBlock`
- `___CFConstantStringClassReference`
- `___NSDictionary0__struct`
- `___stack_chk_fail`
- `___stack_chk_guard`
- `__dispatch_main_q`
- `__objc_empty_cache`
- `_dispatch_after`
- `_dispatch_time`
- `_objc_alloc`
- `_objc_autoreleasePoolPop`
- `_objc_autoreleasePoolPush`
- `_objc_msgSend`
- `_objc_opt_class`
- `_objc_opt_new`
- `_objc_release`
- `_objc_retain`
- `_objc_retainAutoreleasedReturnValue`
- `_objc_storeStrong`

## Strings triage (pattern-based; raw dump in raw/strings.txt)

Total string lines: 748; unique: 320

### com.anlai.* identifiers (0)

### Other reverse-DNS identifiers (0) — heuristic, may include bundle IDs / notification names

### Preference domain / keys
- Declared prefs domain(s) in OmniCarPrefs bundle plists: ['com.anlai.omnicar']
- Domain strings present in this binary: none
- Strings matching keys declared in the prefs bundle plists (0 of 16 declared): none
- Key-shaped candidate strings (pattern guess, NOT corroborated): none

### URLs / schemes (4)
- `omnicar://splitscreen/close`
- `omnicar://splitscreen/fav?n=1`
- `omnicar://splitscreen/open?left=com.apple.Maps&right=com.spotify.client`
- `radr://5614542`

### Log tags (0 unique; 0 format strings carry a tag)

### File paths (9)
- `/System/Library/Frameworks/CoreFoundation.framework/CoreFoundation`
- `/System/Library/Frameworks/CoreGraphics.framework/CoreGraphics`
- `/System/Library/Frameworks/Foundation.framework/Foundation`
- `/System/Library/Frameworks/UIKit.framework/UIKit`
- `/usr/lib/dyld`
- `/usr/lib/libSystem.B.dylib`
- `/usr/lib/libobjc.A.dylib`
- `/var/jb/Library/Frameworks`
- `/var/jb/usr/lib`

## Counts

- classes 1; class methods total 6; categories 0; protocols 2; defined symbols 4 (external 4 + local 0); undefined 38; strings 748 lines / 320 unique
