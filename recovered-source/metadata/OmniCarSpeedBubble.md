# OmniCarSpeedBubble — binary metadata (OmniCar 1.0.3)

- Payload path: `var/jb/Library/MobileSubstrate/DynamicLibraries/OmniCarSpeedBubble.dylib`
- Kind: dylib; filetype: DYLIB; fat size: 649808 bytes
- Parser warnings (arm64 slice): none
- arm64/arm64e ObjC surfaces identical: True (verified: names, method counts, superclasses, ivars, categories, protocols, selrefs, classrefs compared programmatically)

## Load commands

| slice | size | UUID | min iOS | SDK |
|---|---|---|---|---|
| arm64 | 305520 | 75F5A408-8444-300B-B96E-68DA8AF9BFA5 | 15.0.0 | 16.4.0 |
| arm64e | 322128 | D13410EC-7083-320D-8649-7D16EB0E44C2 | 15.0.0 | 16.4.0 |

- Install name (LC_ID_DYLIB): `@rpath/OmniCarSpeedBubble.dylib` (current 0.0.0, compat 0.0.0)
- Encryption (LC_ENCRYPTION_INFO_64): cryptid=0 cryptoff=16384 cryptsize=212992 → not encrypted
- Code signature (LC_CODE_SIGNATURE): present, dataoff=301104 datasize=4416
- Chained fixups: True; classic dyld info: False
- Linked libraries (LC_LOAD_DYLIB, arm64 slice; identical in arm64e unless noted):
  - `/usr/lib/libobjc.A.dylib` (current 228.0.0, compat 1.0.0)
  - `/System/Library/Frameworks/Foundation.framework/Foundation` (current 1971.0.0, compat 300.0.0)
  - `/System/Library/Frameworks/CoreFoundation.framework/CoreFoundation` (current 1971.0.0, compat 150.0.0)
  - `/System/Library/Frameworks/UIKit.framework/UIKit` (current 6441.1.101, compat 1.0.0)
  - `/System/Library/Frameworks/QuartzCore.framework/QuartzCore` (current 1.11.0, compat 1.2.0)
  - `/System/Library/Frameworks/CoreLocation.framework/CoreLocation` (current 2785.1.32, compat 1.0.0)
  - `/System/Library/Frameworks/AudioToolbox.framework/AudioToolbox` (current 1000.0.0, compat 1.0.0)
  - `/System/Library/Frameworks/AVFoundation.framework/AVFoundation` (current 2.0.0, compat 1.0.0)
  - `/usr/lib/libc++.1.dylib` (current 1500.65.0, compat 1.0.0)
  - `/usr/lib/libSystem.B.dylib` (current 1319.100.3, compat 1.0.0)
  - `/System/Library/Frameworks/AVFAudio.framework/AVFAudio` (current 1.0.0, compat 1.0.0)
  - `/System/Library/Frameworks/CoreGraphics.framework/CoreGraphics` (current 1690.5.4, compat 64.0.0)
  - `@rpath/CydiaSubstrate.framework/CydiaSubstrate` (current 0.0.0, compat 0.0.0)
- Rpaths (LC_RPATH):
  - `/var/jb/Library/Frameworks`
  - `/var/jb/usr/lib`
  - `@loader_path/.jbroot/Library/Frameworks`
  - `@loader_path/.jbroot/usr/lib`
- Substrate filter: `{"Bundles": ["com.apple.springboard", "com.apple.CarPlayApp", "vn.vietmap.live", "com.lumi.GOFA", "com.waze.iphone", "com.wynauto.wyn"]}` (verbatim plist copy in raw/)

## Objective-C surface (arm64 slice; arm64e identical)

Classes: 9; methods on classes: 277; categories: 0; protocols defined: 4; classrefs: 74; selrefs (unique): 643

Full class/ivar/property/method listing: see `objc_dump.txt` in this binary's raw/ folder. Class summary:

- `SPPSpeedGPS` : `NSRunLoop` (ivars 6, properties 10, instance methods 19, class methods 1, protocols <CLLocationManagerDelegate>)
- `SPPGlassView` : `NSValue` (ivars 3, properties 3, instance methods 10, class methods 0)
- `SPPIconView` : `NSValue` (ivars 4, properties 4, instance methods 11, class methods 0)
- `SPPSignView` : `NSValue` (ivars 2, properties 2, instance methods 8, class methods 0)
- `SPPBubbleView` : `NSValue` (ivars 21, properties 21, instance methods 59, class methods 0)
- `SPPSoundDelegate` : `NSRunLoop` (ivars 0, properties 4, instance methods 4, class methods 0, protocols <AVAudioPlayerDelegate, AVSpeechSynthesizerDelegate>)
- `SPPBubble` : `NSRunLoop` (ivars 31, properties 31, instance methods 102, class methods 1)
- `SPPPrefs` : `NSRunLoop` (ivars 0, properties 0, instance methods 0, class methods 16)
- `SPPOverspeed` : `NSRunLoop` (ivars 18, properties 18, instance methods 45, class methods 1)
- protocol `NSObject` (instance methods 19, class methods 0)
- protocol `CLLocationManagerDelegate` (instance methods 0, class methods 0)
- protocol `AVAudioPlayerDelegate` (instance methods 0, class methods 0)
- protocol `AVSpeechSynthesizerDelegate` (instance methods 0, class methods 0)

## Symbols

Defined (external): 46; defined (local): 0; stab entries: 1; undefined (imports): 274; exports (trie): 46

Defined symbols:
- `_OBJC_CLASS_$_SPPBubble`
- `_OBJC_CLASS_$_SPPBubbleView`
- `_OBJC_CLASS_$_SPPGlassView`
- `_OBJC_CLASS_$_SPPIconView`
- `_OBJC_CLASS_$_SPPOverspeed`
- `_OBJC_CLASS_$_SPPPrefs`
- `_OBJC_CLASS_$_SPPSignView`
- `_OBJC_CLASS_$_SPPSoundDelegate`
- `_OBJC_CLASS_$_SPPSpeedGPS`
- `_OBJC_METACLASS_$_SPPBubble`
- `_OBJC_METACLASS_$_SPPBubbleView`
- `_OBJC_METACLASS_$_SPPGlassView`
- `_OBJC_METACLASS_$_SPPIconView`
- `_OBJC_METACLASS_$_SPPOverspeed`
- `_OBJC_METACLASS_$_SPPPrefs`
- `_OBJC_METACLASS_$_SPPSignView`
- `_OBJC_METACLASS_$_SPPSoundDelegate`
- `_OBJC_METACLASS_$_SPPSpeedGPS`
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
- `_SPPGetCarPlayCADisplay`
- `_SPPMakeCarWindow`
- `_SPPMakeWindowPassThrough`
- `_SPPPlayTone`
- `_SPPSpeak`
- `_SPPVoiceIsFun`
- `_SPPVoiceLine`
- `_SPPVoiceTemplate`

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
- `_AVAudioSessionCategoryPlayback`
- `_AVFileTypeWAVE`
- `_AudioServicesCreateSystemSoundID`
- `_AudioServicesPlaySystemSound`
- `_CATransform3DIdentity`
- `_CATransform3DMakeRotation`
- `_CATransform3DMakeScale`
- `_CATransform3DRotate`
- `_CFAbsoluteTimeGetCurrent`
- `_CFPreferencesAppSynchronize`
- `_CFPreferencesCopyAppValue`
- `_CFPreferencesSetAppValue`
- `_CGAffineTransformConcat`
- `_CGAffineTransformIdentity`
- `_CGAffineTransformMakeRotation`
- `_CGAffineTransformMakeScale`
- `_CGAffineTransformMakeTranslation`
- `_CGColorSpaceCreateDeviceRGB`
- `_CGColorSpaceRelease`
- `_CGContextDrawRadialGradient`
- `_CGContextFillRect`
- `_CGContextRestoreGState`
- `_CGContextSaveGState`
- `_CGContextSetShadowWithColor`
- `_CGGradientCreateWithColorComponents`
- `_CGGradientRelease`
- `_CGPointZero`
- `_CGRectGetMaxX`
- `_CGRectGetMaxY`
- `_CGRectGetMidX`
- `_CGRectGetMidY`
- `_CGRectGetMinY`
- `_CGRectInset`
- `_CGRectIntersectsRect`
- `_CGRectZero`
- `_CGSizeZero`
- `_MSHookFunction`
- `_MSHookMessageEx`
- `_NSClassFromString`
- `_NSFontAttributeName`
- `_NSForegroundColorAttributeName`
- `_NSGetUncaughtExceptionHandler`
- `_NSLog`
- `_NSRunLoopCommonModes`
- `_NSSelectorFromString`
- `_NSSetUncaughtExceptionHandler`
- `_NSStringFromClass`
- `_NSTemporaryDirectory`
- `_OBJC_CLASS_$_AVAudioPlayer`
- `_OBJC_CLASS_$_AVAudioSession`
- `_OBJC_CLASS_$_AVSpeechSynthesisVoice`
- `_OBJC_CLASS_$_AVSpeechSynthesizer`
- `_OBJC_CLASS_$_AVSpeechUtterance`
- `_OBJC_CLASS_$_CABasicAnimation`
- `_OBJC_CLASS_$_CAGradientLayer`
- `_OBJC_CLASS_$_CAKeyframeAnimation`
- `_OBJC_CLASS_$_CAMediaTimingFunction`
- `_OBJC_CLASS_$_CAShapeLayer`
- `_OBJC_CLASS_$_CATransaction`
- `_OBJC_CLASS_$_CLLocationManager`
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
- `_OBJC_CLASS_$_NSFileManager`
- `_OBJC_CLASS_$_NSHashTable`
- `_OBJC_CLASS_$_NSJSONSerialization`
- `_OBJC_CLASS_$_NSLocale`
- `_OBJC_CLASS_$_NSMutableArray`
- `_OBJC_CLASS_$_NSMutableData`
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
- `_OBJC_CLASS_$_NSScanner`
- `_OBJC_CLASS_$_NSSet`
- `_OBJC_CLASS_$_NSString`
- `_OBJC_CLASS_$_NSThread`
- `_OBJC_CLASS_$_NSTimeZone`
- `_OBJC_CLASS_$_NSTimer`
- `_OBJC_CLASS_$_NSURL`
- `_OBJC_CLASS_$_NSValue`
- `_OBJC_CLASS_$_UIApplication`
- `_OBJC_CLASS_$_UIBezierPath`
- `_OBJC_CLASS_$_UIButton`
- `_OBJC_CLASS_$_UIColor`
- `_OBJC_CLASS_$_UIDevice`
- `_OBJC_CLASS_$_UIFont`
- `_OBJC_CLASS_$_UIGraphicsImageRenderer`
- `_OBJC_CLASS_$_UIGraphicsImageRendererFormat`
- `_OBJC_CLASS_$_UIImage`
- `_OBJC_CLASS_$_UIImageSymbolConfiguration`
- `_OBJC_CLASS_$_UIImageView`
- `_OBJC_CLASS_$_UIImpactFeedbackGenerator`
- `_OBJC_CLASS_$_UILabel`
- `_OBJC_CLASS_$_UILongPressGestureRecognizer`
- `_OBJC_CLASS_$_UINotificationFeedbackGenerator`
- `_OBJC_CLASS_$_UIPanGestureRecognizer`
- `_OBJC_CLASS_$_UIPinchGestureRecognizer`
- `_OBJC_CLASS_$_UIScreen`
- `_OBJC_CLASS_$_UITapGestureRecognizer`
- `_OBJC_CLASS_$_UIView`
- `_OBJC_CLASS_$_UIWindow`
- `_OBJC_CLASS_$_UIWindowScene`
- `_OBJC_EHTYPE_$_NSException`
- `_OBJC_METACLASS_$_NSObject`
- `_OBJC_METACLASS_$_UIView`
- `_UIAccessibilitySwitchControlStatusDidChangeNotification`
- `_UIDeviceOrientationDidChangeNotification`
- `_UIFontDescriptorFeatureSettingsAttribute`
- `_UIFontDescriptorSystemDesignRounded`
- `_UIFontWeightBold`
- `_UIFontWeightHeavy`
- `_UIFontWeightSemibold`
- `_UIRectFill`
- `_UISceneDidActivateNotification`
- `_UISceneDidEnterBackgroundNotification`
- `_UISceneWillDeactivateNotification`
- `_UISceneWillEnterForegroundNotification`
- `_UIScreenDidConnectNotification`
- `_UIScreenDidDisconnectNotification`
- `_UIWindowLevelStatusBar`
- `__Block_object_assign`
- `__Block_object_dispose`
- `__NSConcreteGlobalBlock`
- `__NSConcreteStackBlock`
- `__Unwind_Resume`
- `___CFConstantStringClassReference`
- `___NSArray0__struct`
- `___NSDictionary0__struct`
- `___gxx_personality_v0`
- `___kCFBooleanFalse`
- `___kCFBooleanTrue`
- `___memcpy_chk`
- `___objc_personality_v0`
- `___sincos_stret`
- `___stack_chk_fail`
- `___stack_chk_guard`
- `___strlcpy_chk`
- `__dispatch_main_q`
- `__dispatch_source_type_timer`
- `__dyld_get_image_header`
- `__dyld_get_image_name`
- `__dyld_image_count`
- `__objc_empty_cache`
- `_asin`
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
- `_kCAFilterTrilinear`
- `_kCAGradientLayerConic`
- `_kCAGradientLayerRadial`
- `_kCALineCapButt`
- `_kCALineCapRound`
- `_kCAMediaTimingFunctionEaseInEaseOut`
- `_kCFBooleanTrue`
- `_kCLDistanceFilterNone`
- `_kCLLocationAccuracyBestForNavigation`
- `_mach_absolute_time`
- `_mach_host_self`
- `_mach_port_deallocate`
- `_mach_task_self_`
- `_mach_timebase_info`
- `_malloc`
- `_method_getTypeEncoding`
- `_notify_get_state`
- `_notify_post`
- `_notify_register_check`
- `_notify_register_dispatch`
- `_notify_set_state`
- `_objc_alloc`
- `_objc_alloc_init`
- `_objc_allocateClassPair`
- `_objc_autoreleaseReturnValue`
- `_objc_begin_catch`
- `_objc_copyWeak`
- `_objc_destroyWeak`
- `_objc_end_catch`
- `_objc_enumerationMutation`
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
- `_pow`
- `_property_getAttributes`
- `_property_getName`
- `_raise`
- `_sel_registerName`
- `_setenv`
- `_sigaction`
- `_signal`
- `_sin`
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

Total string lines: 4360; unique: 1900

### com.anlai.* identifiers (3)
- `com.anlai.omnicar`
- `com.anlai.omnicar.log`
- `com.anlai.omnicar.perf`

### Other reverse-DNS identifiers (6) — heuristic, may include bundle IDs / notification names
- `com.apple.CarPlayApp`
- `com.apple.springboard`
- `com.lumi.GOFA`
- `com.waze.iphone`
- `com.wynauto.wyn`
- `vn.vietmap.live`

### Preference domain / keys
- Declared prefs domain(s) in OmniCarPrefs bundle plists: ['com.anlai.omnicar']
- Domain strings present in this binary: ['com.anlai.omnicar']
- Strings matching keys declared in the prefs bundle plists (3 of 16 declared): ['startupScreenCarName', 'startupScreenTempo', 'startupScreenVideoName']
- Key-shaped candidate strings (pattern guess, NOT corroborated): ['accessoryName', 'applyCrispScale', 'applySavedScale', 'builtStyle', 'carProfilesEnabled', 'contentsScale', 'currentMode', 'displayScale', 'isLowPowerModeEnabled', 'liteMode', 'modelName', 'pointScale', 'portType', 'processName', 'renderStyle', 'savedScale', 'speedBubbleWarnMode', 'speedBubbleWarnSound', 'startupScreenStyle', 'vehicleName', 'warnMode']

### URLs / schemes (1)
- `radr://5614542`

### Log tags (1 unique; 1 format strings carry a tag)
- `[XFV]`

### File paths (20)
- `/DynamicLibraries/`
- `/Library/PreferenceBundles/OmniCarPrefs.bundle`
- `/System/Library/Frameworks/AVFAudio.framework/AVFAudio`
- `/System/Library/Frameworks/AVFoundation.framework/AVFoundation`
- `/System/Library/Frameworks/AudioToolbox.framework/AudioToolbox`
- `/System/Library/Frameworks/CoreFoundation.framework/CoreFoundation`
- `/System/Library/Frameworks/CoreGraphics.framework/CoreGraphics`
- `/System/Library/Frameworks/CoreLocation.framework/CoreLocation`
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

## Counts

- classes 9; class methods total 277; categories 0; protocols 4; defined symbols 46 (external 46 + local 0); undefined 274; strings 4360 lines / 1900 unique
