# OmniCarCore — binary metadata (OmniCar 1.0.3)

- Payload path: `var/jb/Library/MobileSubstrate/DynamicLibraries/OmniCarCore.dylib`
- Kind: dylib; filetype: DYLIB; fat size: 276832 bytes
- Parser warnings (arm64 slice): none
- arm64/arm64e ObjC surfaces identical: True (verified: names, method counts, superclasses, ivars, categories, protocols, selrefs, classrefs compared programmatically)

## Load commands

| slice | size | UUID | min iOS | SDK |
|---|---|---|---|---|
| arm64 | 129376 | F4217823-CC6D-336B-BCEB-972852A3C095 | 15.0.0 | 16.4.0 |
| arm64e | 129376 | 4A33CA9C-62CB-3106-A711-B916B57566EC | 15.0.0 | 16.4.0 |

- Install name (LC_ID_DYLIB): `@rpath/OmniCarCore.dylib` (current 0.0.0, compat 0.0.0)
- Encryption (LC_ENCRYPTION_INFO_64): cryptid=0 cryptoff=16384 cryptsize=65536 → not encrypted
- Code signature (LC_CODE_SIGNATURE): present, dataoff=127152 datasize=2224
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
- Substrate filter: `{"Bundles": ["com.apple.springboard"]}` (verbatim plist copy in raw/)

## Objective-C surface (arm64 slice; arm64e identical)

Classes: 0; methods on classes: 0; categories: 0; protocols defined: 0; classrefs: 32; selrefs (unique): 126

Full class/ivar/property/method listing: see `objc_dump.txt` in this binary's raw/ folder. Class summary:


## Symbols

Defined (external): 21; defined (local): 0; stab entries: 1; undefined (imports): 165; exports (trie): 21

Defined symbols:
- `_OMCCarClass`
- `_OMCCarLaunchInfo`
- `_OMCCarWireless`
- `_OMCCheckHooks`
- `_OMCCrashGuard`
- `_OMCCurrentLanguage`
- `_OMCEnabled`
- `_OMCExpired`
- `_OMCFeatureEnabled`
- `_OMCHasMethod`
- `_OMCLiteActive`
- `_OMCLogRelayStart`
- `_OMCLogWrite`
- `_OMCLogoMeshImage`
- `_OMCMissingSelector`
- `_OMCPref`
- `_OMCPrefsSync`
- `_OMCProfileKeys`
- `_OMCSupportedLanguages`
- `_OMCTr`
- `_OMCTrustedTimeStart`

Stab (debug) entries: ['radr://5614542']

Infrastructure / hook / IPC imports check (against undefined symbols):
- `MSHookMessageEx`: absent
- `MSHookFunction`: absent
- `MSHookClassPair`: absent
- `MSFindSymbol`: absent
- `MSGetMessageEx`: absent
- `notify_register_dispatch`: PRESENT
- `notify_post`: PRESENT
- `notify_get_state`: PRESENT
- `notify_set_state`: PRESENT
- `notify_register_check`: PRESENT
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
- `_CFAbsoluteTimeGetCurrent`
- `_CFPreferencesAppSynchronize`
- `_CFPreferencesCopyAppValue`
- `_CFPreferencesSetAppValue`
- `_CGColorSpaceCreateDeviceRGB`
- `_CGColorSpaceRelease`
- `_CGContextDrawRadialGradient`
- `_CGContextFillRect`
- `_CGGradientCreateWithColorComponents`
- `_CGGradientRelease`
- `_NSClassFromString`
- `_NSGetUncaughtExceptionHandler`
- `_NSLog`
- `_NSRunLoopCommonModes`
- `_NSSelectorFromString`
- `_NSSetUncaughtExceptionHandler`
- `_NSStringFromClass`
- `_NSTemporaryDirectory`
- `_OBJC_CLASS_$_NSArray`
- `_OBJC_CLASS_$_NSBundle`
- `_OBJC_CLASS_$_NSCharacterSet`
- `_OBJC_CLASS_$_NSConstantArray`
- `_OBJC_CLASS_$_NSConstantDictionary`
- `_OBJC_CLASS_$_NSConstantIntegerNumber`
- `_OBJC_CLASS_$_NSDate`
- `_OBJC_CLASS_$_NSDateFormatter`
- `_OBJC_CLASS_$_NSDictionary`
- `_OBJC_CLASS_$_NSFileManager`
- `_OBJC_CLASS_$_NSHTTPURLResponse`
- `_OBJC_CLASS_$_NSLocale`
- `_OBJC_CLASS_$_NSMutableArray`
- `_OBJC_CLASS_$_NSMutableDictionary`
- `_OBJC_CLASS_$_NSMutableOrderedSet`
- `_OBJC_CLASS_$_NSMutableSet`
- `_OBJC_CLASS_$_NSMutableURLRequest`
- `_OBJC_CLASS_$_NSNotificationCenter`
- `_OBJC_CLASS_$_NSNumber`
- `_OBJC_CLASS_$_NSObject`
- `_OBJC_CLASS_$_NSOperationQueue`
- `_OBJC_CLASS_$_NSProcessInfo`
- `_OBJC_CLASS_$_NSRunLoop`
- `_OBJC_CLASS_$_NSString`
- `_OBJC_CLASS_$_NSTimeZone`
- `_OBJC_CLASS_$_NSTimer`
- `_OBJC_CLASS_$_NSURL`
- `_OBJC_CLASS_$_NSURLComponents`
- `_OBJC_CLASS_$_NSURLSession`
- `_OBJC_CLASS_$_UIApplication`
- `_OBJC_CLASS_$_UIColor`
- `_OBJC_CLASS_$_UIDevice`
- `_OBJC_CLASS_$_UIGraphicsImageRenderer`
- `_OBJC_CLASS_$_UIGraphicsImageRendererFormat`
- `_OBJC_CLASS_$_UIScreen`
- `_OBJC_EHTYPE_$_NSException`
- `_UIScreenDidConnectNotification`
- `_UIScreenDidDisconnectNotification`
- `__NSConcreteGlobalBlock`
- `__NSConcreteStackBlock`
- `__Unwind_Resume`
- `___CFConstantStringClassReference`
- `___NSArray0__struct`
- `___NSDictionary0__struct`
- `___kCFBooleanFalse`
- `___kCFBooleanTrue`
- `___memcpy_chk`
- `___objc_personality_v0`
- `___stack_chk_fail`
- `___stack_chk_guard`
- `___strlcpy_chk`
- `__dispatch_main_q`
- `__dispatch_source_type_timer`
- `__dyld_get_image_header`
- `__dyld_get_image_name`
- `__dyld_image_count`
- `_backtrace`
- `_backtrace_symbols_fd`
- `_calloc`
- `_class_addMethod`
- `_class_copyPropertyList`
- `_class_getClassMethod`
- `_class_getInstanceMethod`
- `_class_getSuperclass`
- `_close`
- `_dispatch_after`
- `_dispatch_async`
- `_dispatch_get_global_queue`
- `_dispatch_once`
- `_dispatch_queue_create`
- `_dispatch_resume`
- `_dispatch_source_cancel`
- `_dispatch_source_create`
- `_dispatch_source_set_event_handler`
- `_dispatch_source_set_timer`
- `_dispatch_time`
- `_dladdr`
- `_dlopen`
- `_dlsym`
- `_dprintf`
- `_fclose`
- `_fopen`
- `_fputs`
- `_free`
- `_getenv`
- `_getpid`
- `_getsectiondata`
- `_host_page_size`
- `_host_statistics64`
- `_imp_implementationWithBlock`
- `_mach_absolute_time`
- `_mach_host_self`
- `_mach_port_deallocate`
- `_mach_task_self_`
- `_mach_timebase_info`
- `_malloc`
- `_notify_get_state`
- `_notify_post`
- `_notify_register_check`
- `_notify_register_dispatch`
- `_notify_set_state`
- `_objc_alloc`
- `_objc_allocateClassPair`
- `_objc_autoreleasePoolPop`
- `_objc_autoreleasePoolPush`
- `_objc_autoreleaseReturnValue`
- `_objc_begin_catch`
- `_objc_end_catch`
- `_objc_enumerationMutation`
- `_objc_getClass`
- `_objc_msgSend`
- `_objc_opt_class`
- `_objc_opt_isKindOfClass`
- `_objc_opt_new`
- `_objc_opt_respondsToSelector`
- `_objc_registerClassPair`
- `_objc_release`
- `_objc_retain`
- `_objc_retainAutorelease`
- `_objc_retainAutoreleasedReturnValue`
- `_objc_sync_enter`
- `_objc_sync_exit`
- `_objc_unsafeClaimAutoreleasedReturnValue`
- `_open`
- `_os_proc_available_memory`
- `_property_getAttributes`
- `_property_getName`
- `_raise`
- `_sel_registerName`
- `_setenv`
- `_sigaction`
- `_signal`
- `_snprintf`
- `_strcmp`
- `_strlcat`
- `_strlcpy`
- `_strlen`
- `_strncmp`
- `_strrchr`
- `_strstr`
- `_strtoull`
- `_task_info`
- `_task_threads`
- `_thread_info`
- `_time`
- `_unlink`
- `_vm_deallocate`

## Strings triage (pattern-based; raw dump in raw/strings.txt)

Total string lines: 1759; unique: 711

### com.anlai.* identifiers (3)
- `com.anlai.omnicar`
- `com.anlai.omnicar.log`
- `com.anlai.omnicar.perf`

### Other reverse-DNS identifiers (13) — heuristic, may include bundle IDs / notification names
- `com.apple.CarPlayApp`
- `com.apple.InCallService`
- `com.apple.Maps`
- `com.apple.MobileSMS`
- `com.apple.Music`
- `com.apple.Preferences`
- `com.apple.facetime`
- `com.apple.mobilephone`
- `com.apple.podcasts`
- `com.apple.springboard`
- `com.lumi.GOFA`
- `com.waze.iphone`
- `vn.vietmap.live`

### Preference domain / keys
- Declared prefs domain(s) in OmniCarPrefs bundle plists: ['com.anlai.omnicar']
- Domain strings present in this binary: ['com.anlai.omnicar']
- Strings matching keys declared in the prefs bundle plists (6 of 16 declared): ['speedBubbleEnabled', 'splitScreenEnabled', 'startupScreenCarName', 'startupScreenEnabled', 'startupScreenTempo', 'startupScreenVideoName']
- Key-shaped candidate strings (pattern guess, NOT corroborated): ['accessoryName', 'appBridgeEnabled', 'applicationType', 'carProfilesEnabled', 'isLowPowerModeEnabled', 'liteMode', 'modelName', 'processName', 'startupScreenStyle', 'vehicleName']

### URLs / schemes (2)
- `https://www.apple.com/`
- `radr://5614542`

### Log tags (0 unique; 0 format strings carry a tag)

### File paths (15)
- `/DynamicLibraries/`
- `/Library/PreferenceBundles/OmniCarPrefs.bundle`
- `/System/Library/Frameworks/CoreFoundation.framework/CoreFoundation`
- `/System/Library/Frameworks/CoreGraphics.framework/CoreGraphics`
- `/System/Library/Frameworks/Foundation.framework/Foundation`
- `/System/Library/Frameworks/UIKit.framework/UIKit`
- `/System/Library/PrivateFrameworks/BackBoardServices.framework/BackBoardServices`
- `/System/Library/PrivateFrameworks/CarKit.framework/CarKit`
- `/TweakInject/`
- `/usr/lib/libSystem.B.dylib`
- `/usr/lib/libobjc.A.dylib`
- `/var/jb`
- `/var/jb/Library/Frameworks`
- `/var/jb/usr/lib`
- `/var/mobile/Documents/OmniCar.log`

## Counts

- classes 0; class methods total 0; categories 0; protocols 0; defined symbols 21 (external 21 + local 0); undefined 165; strings 1759 lines / 711 unique
