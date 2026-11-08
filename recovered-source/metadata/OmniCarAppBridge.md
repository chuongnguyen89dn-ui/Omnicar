# OmniCarAppBridge — binary metadata (OmniCar 1.0.3)

- Payload path: `var/jb/Library/MobileSubstrate/DynamicLibraries/OmniCarAppBridge.dylib`
- Kind: dylib; filetype: DYLIB; fat size: 613376 bytes
- Parser warnings (arm64 slice): none
- arm64/arm64e ObjC surfaces identical: True (verified: names, method counts, superclasses, ivars, categories, protocols, selrefs, classrefs compared programmatically)

## Load commands

| slice | size | UUID | min iOS | SDK |
|---|---|---|---|---|
| arm64 | 285488 | 81EF5920-BB7A-37E8-B953-D88453F2EA89 | 15.0.0 | 16.4.0 |
| arm64e | 302080 | 3DB82CC6-F966-3256-AA0B-A390C1F13F8E | 15.0.0 | 16.4.0 |

- Install name (LC_ID_DYLIB): `@rpath/OmniCarAppBridge.dylib` (current 0.0.0, compat 0.0.0)
- Encryption (LC_ENCRYPTION_INFO_64): cryptid=0 cryptoff=16384 cryptsize=196608 → not encrypted
- Code signature (LC_CODE_SIGNATURE): present, dataoff=281328 datasize=4160
- Chained fixups: True; classic dyld info: False
- Linked libraries (LC_LOAD_DYLIB, arm64 slice; identical in arm64e unless noted):
  - `/usr/lib/libobjc.A.dylib` (current 228.0.0, compat 1.0.0)
  - `/System/Library/Frameworks/Foundation.framework/Foundation` (current 1971.0.0, compat 300.0.0)
  - `/System/Library/Frameworks/CoreFoundation.framework/CoreFoundation` (current 1971.0.0, compat 150.0.0)
  - `/System/Library/Frameworks/UIKit.framework/UIKit` (current 6441.1.101, compat 1.0.0)
  - `/usr/lib/libc++.1.dylib` (current 1500.65.0, compat 1.0.0)
  - `/usr/lib/libSystem.B.dylib` (current 1319.100.3, compat 1.0.0)
  - `/System/Library/Frameworks/CoreGraphics.framework/CoreGraphics` (current 1690.5.4, compat 64.0.0)
  - `/System/Library/Frameworks/QuartzCore.framework/QuartzCore` (current 1.11.0, compat 1.2.0)
  - `@rpath/CydiaSubstrate.framework/CydiaSubstrate` (current 0.0.0, compat 0.0.0)
- Rpaths (LC_RPATH):
  - `/var/jb/Library/Frameworks`
  - `/var/jb/usr/lib`
  - `@loader_path/.jbroot/Library/Frameworks`
  - `@loader_path/.jbroot/usr/lib`
- Substrate filter: `{"Bundles": ["com.apple.UIKit"]}` (verbatim plist copy in raw/)

## Objective-C surface (arm64 slice; arm64e identical)

Classes: 8; methods on classes: 193; categories: 0; protocols defined: 3; classrefs: 60; selrefs (unique): 529

Full class/ivar/property/method listing: see `objc_dump.txt` in this binary's raw/ folder. Class summary:

- `ABBoxView` : `UIWindowScene` (ivars 4, properties 4, instance methods 12, class methods 0)
- `ABBarButton` : `NSNull` (ivars 0, properties 0, instance methods 2, class methods 0)
- `ABPane` : `NSRunLoop` (ivars 17, properties 17, instance methods 35, class methods 0)
- `ABShieldView` : `UIWindowScene` (ivars 0, properties 0, instance methods 1, class methods 0)
- `ABKnobView` : `UIWindowScene` (ivars 3, properties 3, instance methods 12, class methods 0)
- `ABHost` : `NSRunLoop` (ivars 6, properties 6, instance methods 61, class methods 1)
- `ABKey` : `NSNull` (ivars 8, properties 8, instance methods 20, class methods 0)
- `ABKeyboard` : `NSRunLoop` (ivars 16, properties 16, instance methods 48, class methods 1)
- protocol `NSObject` (instance methods 19, class methods 0)
- protocol `UITextInputTraits` (instance methods 0, class methods 0)
- protocol `UIKeyInput` (instance methods 3, class methods 0)

## Symbols

Defined (external): 38; defined (local): 0; stab entries: 1; undefined (imports): 241; exports (trie): 38

Defined symbols:
- `_ABMissingSelector`
- `_ABTelexApply`
- `_OBJC_CLASS_$_ABBarButton`
- `_OBJC_CLASS_$_ABBoxView`
- `_OBJC_CLASS_$_ABHost`
- `_OBJC_CLASS_$_ABKey`
- `_OBJC_CLASS_$_ABKeyboard`
- `_OBJC_CLASS_$_ABKnobView`
- `_OBJC_CLASS_$_ABPane`
- `_OBJC_CLASS_$_ABShieldView`
- `_OBJC_METACLASS_$_ABBarButton`
- `_OBJC_METACLASS_$_ABBoxView`
- `_OBJC_METACLASS_$_ABHost`
- `_OBJC_METACLASS_$_ABKey`
- `_OBJC_METACLASS_$_ABKeyboard`
- `_OBJC_METACLASS_$_ABKnobView`
- `_OBJC_METACLASS_$_ABPane`
- `_OBJC_METACLASS_$_ABShieldView`
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

Stab (debug) entries: ['radr://5614542']

Infrastructure / hook / IPC imports check (against undefined symbols):
- `MSHookMessageEx`: PRESENT
- `MSHookFunction`: PRESENT
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
- `_CAFrameRateRangeMake`
- `_CFAbsoluteTimeGetCurrent`
- `_CFPreferencesAppSynchronize`
- `_CFPreferencesCopyAppValue`
- `_CFPreferencesSetAppValue`
- `_CGAffineTransformConcat`
- `_CGAffineTransformIdentity`
- `_CGAffineTransformMakeScale`
- `_CGAffineTransformMakeTranslation`
- `_CGAffineTransformScale`
- `_CGColorSpaceCreateDeviceRGB`
- `_CGColorSpaceRelease`
- `_CGContextDrawRadialGradient`
- `_CGContextFillRect`
- `_CGContextScaleCTM`
- `_CGGradientCreateWithColorComponents`
- `_CGGradientRelease`
- `_CGPointZero`
- `_CGRectContainsPoint`
- `_CGRectEqualToRect`
- `_CGRectGetMaxY`
- `_CGRectGetMidX`
- `_CGRectGetMidY`
- `_CGRectGetMinX`
- `_CGRectGetMinY`
- `_CGRectInset`
- `_CGRectIntersection`
- `_CGRectIsEmpty`
- `_CGRectNull`
- `_CGRectOffset`
- `_CGRectZero`
- `_MSHookFunction`
- `_MSHookMessageEx`
- `_NSClassFromString`
- `_NSGetUncaughtExceptionHandler`
- `_NSLog`
- `_NSRunLoopCommonModes`
- `_NSSelectorFromString`
- `_NSSetUncaughtExceptionHandler`
- `_NSStringFromCGPoint`
- `_NSStringFromCGRect`
- `_NSStringFromClass`
- `_NSStringFromSelector`
- `_NSTemporaryDirectory`
- `_OBJC_CLASS_$_CAGradientLayer`
- `_OBJC_CLASS_$_CALayer`
- `_OBJC_CLASS_$_CAShapeLayer`
- `_OBJC_CLASS_$_CATransaction`
- `_OBJC_CLASS_$_NSArray`
- `_OBJC_CLASS_$_NSBundle`
- `_OBJC_CLASS_$_NSCharacterSet`
- `_OBJC_CLASS_$_NSConstantArray`
- `_OBJC_CLASS_$_NSConstantDictionary`
- `_OBJC_CLASS_$_NSConstantDoubleNumber`
- `_OBJC_CLASS_$_NSConstantIntegerNumber`
- `_OBJC_CLASS_$_NSDate`
- `_OBJC_CLASS_$_NSDateFormatter`
- `_OBJC_CLASS_$_NSDictionary`
- `_OBJC_CLASS_$_NSException`
- `_OBJC_CLASS_$_NSFileManager`
- `_OBJC_CLASS_$_NSHashTable`
- `_OBJC_CLASS_$_NSInvocation`
- `_OBJC_CLASS_$_NSLocale`
- `_OBJC_CLASS_$_NSMutableArray`
- `_OBJC_CLASS_$_NSMutableDictionary`
- `_OBJC_CLASS_$_NSMutableOrderedSet`
- `_OBJC_CLASS_$_NSMutableSet`
- `_OBJC_CLASS_$_NSMutableString`
- `_OBJC_CLASS_$_NSNotificationCenter`
- `_OBJC_CLASS_$_NSNull`
- `_OBJC_CLASS_$_NSNumber`
- `_OBJC_CLASS_$_NSObject`
- `_OBJC_CLASS_$_NSOperationQueue`
- `_OBJC_CLASS_$_NSProcessInfo`
- `_OBJC_CLASS_$_NSRunLoop`
- `_OBJC_CLASS_$_NSString`
- `_OBJC_CLASS_$_NSTimeZone`
- `_OBJC_CLASS_$_UIApplication`
- `_OBJC_CLASS_$_UIBezierPath`
- `_OBJC_CLASS_$_UIBlurEffect`
- `_OBJC_CLASS_$_UIButton`
- `_OBJC_CLASS_$_UIColor`
- `_OBJC_CLASS_$_UICubicTimingParameters`
- `_OBJC_CLASS_$_UIDevice`
- `_OBJC_CLASS_$_UIFont`
- `_OBJC_CLASS_$_UIGraphicsImageRenderer`
- `_OBJC_CLASS_$_UIGraphicsImageRendererFormat`
- `_OBJC_CLASS_$_UIImage`
- `_OBJC_CLASS_$_UIImageSymbolConfiguration`
- `_OBJC_CLASS_$_UIImageView`
- `_OBJC_CLASS_$_UILabel`
- `_OBJC_CLASS_$_UIPanGestureRecognizer`
- `_OBJC_CLASS_$_UIScreen`
- `_OBJC_CLASS_$_UITapGestureRecognizer`
- `_OBJC_CLASS_$_UITextField`
- `_OBJC_CLASS_$_UIView`
- `_OBJC_CLASS_$_UIViewPropertyAnimator`
- `_OBJC_CLASS_$_UIVisualEffectView`
- `_OBJC_CLASS_$_UIWindow`
- `_OBJC_CLASS_$_UIWindowScene`
- `_OBJC_EHTYPE_$_NSException`
- `_OBJC_METACLASS_$_NSObject`
- `_OBJC_METACLASS_$_UIButton`
- `_OBJC_METACLASS_$_UIView`
- `_UIDeviceOrientationDidChangeNotification`
- `_UIFontWeightMedium`
- `_UIFontWeightSemibold`
- `_UIScreenDidConnectNotification`
- `_UIScreenDidDisconnectNotification`
- `_UIWindowLevelStatusBar`
- `_UIWindowSceneSessionRoleApplication`
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
- `___tolower`
- `__dispatch_main_q`
- `__dispatch_source_type_timer`
- `__dyld_get_image_header`
- `__dyld_get_image_name`
- `__dyld_image_count`
- `__objc_empty_cache`
- `_backtrace`
- `_backtrace_symbols_fd`
- `_calloc`
- `_class_addMethod`
- `_class_copyMethodList`
- `_class_copyPropertyList`
- `_class_getClassMethod`
- `_class_getInstanceMethod`
- `_class_getSuperclass`
- `_close`
- `_dispatch_after`
- `_dispatch_async`
- `_dispatch_block_cancel`
- `_dispatch_block_create`
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
- `_hypot`
- `_imp_implementationWithBlock`
- `_kCACornerCurveContinuous`
- `_kCAFillRuleEvenOdd`
- `_mach_absolute_time`
- `_mach_host_self`
- `_mach_port_deallocate`
- `_mach_task_self_`
- `_mach_timebase_info`
- `_malloc`
- `_method_getName`
- `_method_getTypeEncoding`
- `_notify_get_state`
- `_notify_post`
- `_notify_register_check`
- `_notify_register_dispatch`
- `_notify_set_state`
- `_objc_alloc`
- `_objc_allocateClassPair`
- `_objc_autoreleaseReturnValue`
- `_objc_begin_catch`
- `_objc_copyWeak`
- `_objc_destroyWeak`
- `_objc_end_catch`
- `_objc_enumerationMutation`
- `_objc_getAssociatedObject`
- `_objc_getClass`
- `_objc_initWeak`
- `_objc_loadWeakRetained`
- `_objc_msgSend`
- `_objc_msgSendSuper`
- `_objc_msgSendSuper2`
- `_objc_opt_class`
- `_objc_opt_isKindOfClass`
- `_objc_opt_new`
- `_objc_opt_respondsToSelector`
- `_objc_registerClassPair`
- `_objc_release`
- `_objc_retain`
- `_objc_retainAutorelease`
- `_objc_retainAutoreleasedReturnValue`
- `_objc_retainBlock`
- `_objc_setAssociatedObject`
- `_objc_setProperty_nonatomic_copy`
- `_objc_storeStrong`
- `_objc_storeWeak`
- `_objc_sync_enter`
- `_objc_sync_exit`
- `_objc_unsafeClaimAutoreleasedReturnValue`
- `_object_getClass`
- `_object_setClass`
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

Total string lines: 3760; unique: 1621

### com.anlai.* identifiers (3)
- `com.anlai.omnicar`
- `com.anlai.omnicar.log`
- `com.anlai.omnicar.perf`

### Other reverse-DNS identifiers (6) — heuristic, may include bundle IDs / notification names
- `com.apple.CarPlayApp`
- `com.apple.CarPlaySettings`
- `com.apple.CarPlayTemplateUIHost`
- `com.apple.InCallService`
- `com.apple.Preferences`
- `com.apple.springboard`

### Preference domain / keys
- Declared prefs domain(s) in OmniCarPrefs bundle plists: ['com.anlai.omnicar']
- Domain strings present in this binary: ['com.anlai.omnicar']
- Strings matching keys declared in the prefs bundle plists (3 of 16 declared): ['startupScreenCarName', 'startupScreenTempo', 'startupScreenVideoName']
- Key-shaped candidate strings (pattern guess, NOT corroborated): ['accessoryName', 'autocapitalizationType', 'autocorrectionType', 'carProfilesEnabled', 'isLowPowerModeEnabled', 'keyboardType', 'liteMode', 'modelName', 'processName', 'returnKeyType', 'returnType', 'smartDashesType', 'smartInsertDeleteType', 'smartQuotesType', 'spellCheckingType', 'startupScreenStyle', 'textContentType', 'vehicleName']

### URLs / schemes (1)
- `radr://5614542`

### Log tags (0 unique; 0 format strings carry a tag)

### File paths (17)
- `/DynamicLibraries/`
- `/Library/PreferenceBundles/OmniCarPrefs.bundle`
- `/System/Library/Frameworks/CoreFoundation.framework/CoreFoundation`
- `/System/Library/Frameworks/CoreGraphics.framework/CoreGraphics`
- `/System/Library/Frameworks/Foundation.framework/Foundation`
- `/System/Library/Frameworks/QuartzCore.framework/QuartzCore`
- `/System/Library/Frameworks/UIKit.framework/UIKit`
- `/System/Library/PrivateFrameworks/CarKit.framework/CarKit`
- `/TweakInject/`
- `/usr/lib/libSystem.B.dylib`
- `/usr/lib/libc++.1.dylib`
- `/usr/lib/libobjc.A.dylib`
- `/var/jb`
- `/var/jb/Library/Frameworks`
- `/var/jb/usr/lib`
- `/var/mobile/Documents/OmniCar.log`
- `/|/d`

## Counts

- classes 8; class methods total 193; categories 0; protocols 3; defined symbols 38 (external 38 + local 0); undefined 241; strings 3760 lines / 1621 unique
