# OmniCarStartupScreen — binary metadata (OmniCar 1.0.3)

- Payload path: `var/jb/Library/MobileSubstrate/DynamicLibraries/OmniCarStartupScreen.dylib`
- Kind: dylib; filetype: DYLIB; fat size: 567792 bytes
- Parser warnings (arm64 slice): none
- arm64/arm64e ObjC surfaces identical: True (verified: names, method counts, superclasses, ivars, categories, protocols, selrefs, classrefs compared programmatically)

## Load commands

| slice | size | UUID | min iOS | SDK |
|---|---|---|---|---|
| arm64 | 272864 | 3C073435-22DF-3EE2-ACFA-D109A37EF1B7 | 15.0.0 | 16.4.0 |
| arm64e | 272880 | 96533A0C-E0E2-3882-89BA-410DF8F36A80 | 15.0.0 | 16.4.0 |

- Install name (LC_ID_DYLIB): `@rpath/OmniCarStartupScreen.dylib` (current 0.0.0, compat 0.0.0)
- Encryption (LC_ENCRYPTION_INFO_64): cryptid=0 cryptoff=16384 cryptsize=180224 → not encrypted
- Code signature (LC_CODE_SIGNATURE): present, dataoff=268848 datasize=4016
- Chained fixups: True; classic dyld info: False
- Linked libraries (LC_LOAD_DYLIB, arm64 slice; identical in arm64e unless noted):
  - `/usr/lib/libobjc.A.dylib` (current 228.0.0, compat 1.0.0)
  - `/System/Library/Frameworks/Foundation.framework/Foundation` (current 1971.0.0, compat 300.0.0)
  - `/System/Library/Frameworks/CoreFoundation.framework/CoreFoundation` (current 1971.0.0, compat 150.0.0)
  - `/System/Library/Frameworks/UIKit.framework/UIKit` (current 6441.1.101, compat 1.0.0)
  - `/System/Library/Frameworks/AVFoundation.framework/AVFoundation` (current 2.0.0, compat 1.0.0)
  - `/System/Library/Frameworks/ImageIO.framework/ImageIO` (current 1.0.0, compat 1.0.0)
  - `/System/Library/Frameworks/QuartzCore.framework/QuartzCore` (current 1.11.0, compat 1.2.0)
  - `/System/Library/Frameworks/CoreLocation.framework/CoreLocation` (current 2785.1.32, compat 1.0.0)
  - `/System/Library/Frameworks/CallKit.framework/CallKit` (current 1.0.0, compat 1.0.0)
  - `/System/Library/Frameworks/EventKit.framework/EventKit` (current 1833.4.5, compat 1.0.0)
  - `/usr/lib/libSystem.B.dylib` (current 1319.100.3, compat 1.0.0)
  - `/System/Library/Frameworks/AVFAudio.framework/AVFAudio` (current 1.0.0, compat 1.0.0)
  - `/System/Library/Frameworks/CoreGraphics.framework/CoreGraphics` (current 1690.5.4, compat 64.0.0)
  - `@rpath/CydiaSubstrate.framework/CydiaSubstrate` (current 0.0.0, compat 0.0.0)
- Rpaths (LC_RPATH):
  - `/var/jb/Library/Frameworks`
  - `/var/jb/usr/lib`
  - `@loader_path/.jbroot/Library/Frameworks`
  - `@loader_path/.jbroot/usr/lib`
- Substrate filter: `{"Bundles": ["com.apple.CarPlayApp", "com.apple.springboard"]}` (verbatim plist copy in raw/)

## Objective-C surface (arm64 slice; arm64e identical)

Classes: 8; methods on classes: 173; categories: 0; protocols defined: 2; classrefs: 71; selrefs (unique): 559

Full class/ivar/property/method listing: see `objc_dump.txt` in this binary's raw/ folder. Class summary:

- `SSLocationOnce` : `NSMutableSet` (ivars 2, properties 6, instance methods 8, class methods 0, protocols <CLLocationManagerDelegate>)
- `SSSplashWindow` : `_OBJC_METACLASS_$_UIWindow` (ivars 0, properties 0, instance methods 0, class methods 0)
- `SSSplash` : `NSMutableSet` (ivars 20, properties 20, instance methods 51, class methods 0)
- `SSFade` : `NSMutableSet` (ivars 8, properties 8, instance methods 18, class methods 0)
- `SSGauge` : `NSMutableSet` (ivars 8, properties 8, instance methods 17, class methods 0)
- `SSLinkTarget` : `NSMutableSet` (ivars 1, properties 1, instance methods 4, class methods 0)
- `SSCanvasView` : `NSRunLoop` (ivars 1, properties 1, instance methods 4, class methods 0)
- `SSStartupView` : `NSRunLoop` (ivars 72, properties 14, instance methods 70, class methods 1)
- protocol `NSObject` (instance methods 19, class methods 0)
- protocol `CLLocationManagerDelegate` (instance methods 0, class methods 0)

## Symbols

Defined (external): 41; defined (local): 0; stab entries: 1; undefined (imports): 287; exports (trie): 41

Defined symbols:
- `_OBJC_CLASS_$_SSCanvasView`
- `_OBJC_CLASS_$_SSFade`
- `_OBJC_CLASS_$_SSGauge`
- `_OBJC_CLASS_$_SSLinkTarget`
- `_OBJC_CLASS_$_SSLocationOnce`
- `_OBJC_CLASS_$_SSSplash`
- `_OBJC_CLASS_$_SSSplashWindow`
- `_OBJC_CLASS_$_SSStartupView`
- `_OBJC_METACLASS_$_SSCanvasView`
- `_OBJC_METACLASS_$_SSFade`
- `_OBJC_METACLASS_$_SSGauge`
- `_OBJC_METACLASS_$_SSLinkTarget`
- `_OBJC_METACLASS_$_SSLocationOnce`
- `_OBJC_METACLASS_$_SSSplash`
- `_OBJC_METACLASS_$_SSSplashWindow`
- `_OBJC_METACLASS_$_SSStartupView`
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
- `_SSApplySampleData`
- `_SSPeriodForDate`
- `_SSWeatherLoadCache`
- `_SSWeatherParse`
- `_SSWeatherSaveCache`

Stab (debug) entries: ['radr://5614542']

Infrastructure / hook / IPC imports check (against undefined symbols):
- `MSHookMessageEx`: PRESENT
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
- `CFNotificationCenterAddObserver`: PRESENT
- `CFNotificationCenterPostNotification`: PRESENT
- `CFNotificationCenterGetDarwinNotifyCenter`: PRESENT
- `CFNotificationCenterGetLocalNotifyCenter`: absent
- `xpc_connection_create`: absent
- `xpc_connection_create_mach_service`: absent
- `rocketbootstrap_distributedmessagingcenter_apply`: absent
- Logos-generated symbols (name contains 'logos'): none found
- Swift sections: none

Undefined symbols (full list):
- `_AVAudioSessionCategoryPlayback`
- `_CACurrentMediaTime`
- `_CAFrameRateRangeMake`
- `_CATransform3DMakeRotation`
- `_CATransform3DScale`
- `_CFAbsoluteTimeGetCurrent`
- `_CFNotificationCenterAddObserver`
- `_CFNotificationCenterGetDarwinNotifyCenter`
- `_CFNotificationCenterPostNotification`
- `_CFPreferencesAppSynchronize`
- `_CFPreferencesCopyAppValue`
- `_CFPreferencesSetAppValue`
- `_CFRelease`
- `_CFStringCompare`
- `_CGAffineTransformIdentity`
- `_CGAffineTransformMakeScale`
- `_CGAffineTransformMakeTranslation`
- `_CGAffineTransformScale`
- `_CGBitmapContextCreate`
- `_CGBitmapContextGetBytesPerRow`
- `_CGBitmapContextGetData`
- `_CGColorSpaceCreateDeviceRGB`
- `_CGColorSpaceRelease`
- `_CGContextAddEllipseInRect`
- `_CGContextClip`
- `_CGContextDrawRadialGradient`
- `_CGContextFillEllipseInRect`
- `_CGContextFillRect`
- `_CGContextRelease`
- `_CGContextRotateCTM`
- `_CGContextScaleCTM`
- `_CGContextSetBlendMode`
- `_CGContextSetFillColorWithColor`
- `_CGContextSetRGBFillColor`
- `_CGContextTranslateCTM`
- `_CGGradientCreateWithColorComponents`
- `_CGGradientRelease`
- `_CGImageRelease`
- `_CGImageSourceCreateImageAtIndex`
- `_CGImageSourceCreateWithURL`
- `_CGPathAddArc`
- `_CGPathAddRect`
- `_CGPathCloseSubpath`
- `_CGPathCreateMutable`
- `_CGPathMoveToPoint`
- `_CGPathRelease`
- `_CGPointZero`
- `_CGRectZero`
- `_CGSizeZero`
- `_MSHookMessageEx`
- `_NSCalendarIdentifierChinese`
- `_NSCalendarIdentifierGregorian`
- `_NSClassFromString`
- `_NSFilePosixPermissions`
- `_NSFontAttributeName`
- `_NSForegroundColorAttributeName`
- `_NSGetUncaughtExceptionHandler`
- `_NSLog`
- `_NSRunLoopCommonModes`
- `_NSSelectorFromString`
- `_NSSetUncaughtExceptionHandler`
- `_NSStringFromCGRect`
- `_NSStringFromClass`
- `_NSTemporaryDirectory`
- `_OBJC_CLASS_$_AVAudioPlayer`
- `_OBJC_CLASS_$_AVAudioSession`
- `_OBJC_CLASS_$_CABasicAnimation`
- `_OBJC_CLASS_$_CADisplayLink`
- `_OBJC_CLASS_$_CAGradientLayer`
- `_OBJC_CLASS_$_CALayer`
- `_OBJC_CLASS_$_CAMediaTimingFunction`
- `_OBJC_CLASS_$_CAShapeLayer`
- `_OBJC_CLASS_$_CATransaction`
- `_OBJC_CLASS_$_CLLocationManager`
- `_OBJC_CLASS_$_CXCallObserver`
- `_OBJC_CLASS_$_EKEventStore`
- `_OBJC_CLASS_$_NSArray`
- `_OBJC_CLASS_$_NSBundle`
- `_OBJC_CLASS_$_NSCalendar`
- `_OBJC_CLASS_$_NSCharacterSet`
- `_OBJC_CLASS_$_NSConstantArray`
- `_OBJC_CLASS_$_NSConstantDoubleNumber`
- `_OBJC_CLASS_$_NSConstantIntegerNumber`
- `_OBJC_CLASS_$_NSDate`
- `_OBJC_CLASS_$_NSDateFormatter`
- `_OBJC_CLASS_$_NSDictionary`
- `_OBJC_CLASS_$_NSFileManager`
- `_OBJC_CLASS_$_NSHTTPURLResponse`
- `_OBJC_CLASS_$_NSJSONSerialization`
- `_OBJC_CLASS_$_NSLayoutConstraint`
- `_OBJC_CLASS_$_NSLocale`
- `_OBJC_CLASS_$_NSMeasurement`
- `_OBJC_CLASS_$_NSMeasurementFormatter`
- `_OBJC_CLASS_$_NSMutableArray`
- `_OBJC_CLASS_$_NSMutableData`
- `_OBJC_CLASS_$_NSMutableDictionary`
- `_OBJC_CLASS_$_NSMutableOrderedSet`
- `_OBJC_CLASS_$_NSMutableSet`
- `_OBJC_CLASS_$_NSNotificationCenter`
- `_OBJC_CLASS_$_NSNumber`
- `_OBJC_CLASS_$_NSNumberFormatter`
- `_OBJC_CLASS_$_NSObject`
- `_OBJC_CLASS_$_NSOperationQueue`
- `_OBJC_CLASS_$_NSProcessInfo`
- `_OBJC_CLASS_$_NSRunLoop`
- `_OBJC_CLASS_$_NSString`
- `_OBJC_CLASS_$_NSTimeZone`
- `_OBJC_CLASS_$_NSURL`
- `_OBJC_CLASS_$_NSURLSession`
- `_OBJC_CLASS_$_NSURLSessionConfiguration`
- `_OBJC_CLASS_$_NSUnitTemperature`
- `_OBJC_CLASS_$_NSValue`
- `_OBJC_CLASS_$_UIBezierPath`
- `_OBJC_CLASS_$_UIBlurEffect`
- `_OBJC_CLASS_$_UIColor`
- `_OBJC_CLASS_$_UIDevice`
- `_OBJC_CLASS_$_UIFont`
- `_OBJC_CLASS_$_UIGraphicsImageRenderer`
- `_OBJC_CLASS_$_UIGraphicsImageRendererFormat`
- `_OBJC_CLASS_$_UIImage`
- `_OBJC_CLASS_$_UIImageSymbolConfiguration`
- `_OBJC_CLASS_$_UIImageView`
- `_OBJC_CLASS_$_UILabel`
- `_OBJC_CLASS_$_UIScreen`
- `_OBJC_CLASS_$_UIStackView`
- `_OBJC_CLASS_$_UITapGestureRecognizer`
- `_OBJC_CLASS_$_UIView`
- `_OBJC_CLASS_$_UIViewController`
- `_OBJC_CLASS_$_UIVisualEffectView`
- `_OBJC_CLASS_$_UIWindow`
- `_OBJC_CLASS_$_UIWindowScene`
- `_OBJC_EHTYPE_$_NSException`
- `_OBJC_METACLASS_$_NSObject`
- `_OBJC_METACLASS_$_UIView`
- `_OBJC_METACLASS_$_UIWindow`
- `_UIFontDescriptorSystemDesignRounded`
- `_UIFontWeightBold`
- `_UIFontWeightHeavy`
- `_UIFontWeightLight`
- `_UIFontWeightMedium`
- `_UIFontWeightRegular`
- `_UIFontWeightSemibold`
- `_UIGraphicsGetCurrentContext`
- `_UIGraphicsPopContext`
- `_UIGraphicsPushContext`
- `_UISceneDidActivateNotification`
- `_UISceneDidDisconnectNotification`
- `_UISceneWillConnectNotification`
- `_UIScreenDidConnectNotification`
- `_UIScreenDidDisconnectNotification`
- `_UIWindowLevelAlert`
- `__Block_object_assign`
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
- `_arc4random_uniform`
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
- `_imp_implementationWithBlock`
- `_kCACornerCurveContinuous`
- `_kCAFillRuleEvenOdd`
- `_kCAGradientLayerAxial`
- `_kCAGradientLayerConic`
- `_kCAGradientLayerRadial`
- `_kCAGravityResizeAspect`
- `_kCALineCapRound`
- `_kCALineJoinRound`
- `_kCAMediaTimingFunctionEaseInEaseOut`
- `_kCGImageSourceShouldCacheImmediately`
- `_kCLLocationAccuracyKilometer`
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
- `_objc_copyWeak`
- `_objc_destroyWeak`
- `_objc_end_catch`
- `_objc_enumerationMutation`
- `_objc_getAssociatedObject`
- `_objc_getClass`
- `_objc_initWeak`
- `_objc_loadWeakRetained`
- `_objc_msgSend`
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

Total string lines: 4168; unique: 1789

### com.anlai.* identifiers (4)
- `com.anlai.omnicar`
- `com.anlai.omnicar.log`
- `com.anlai.omnicar.perf`
- `com.anlai.omnicar.startupscreen.decode`

### Other reverse-DNS identifiers (2) — heuristic, may include bundle IDs / notification names
- `com.apple.CarPlayApp`
- `com.apple.springboard`

### Preference domain / keys
- Declared prefs domain(s) in OmniCarPrefs bundle plists: ['com.anlai.omnicar']
- Domain strings present in this binary: ['com.anlai.omnicar']
- Strings matching keys declared in the prefs bundle plists (13 of 16 declared): ['startupScreenCarName', 'startupScreenDuration', 'startupScreenGreetingName', 'startupScreenLogoEffect', 'startupScreenOccasions', 'startupScreenPlayFull', 'startupScreenScaleMode', 'startupScreenSound', 'startupScreenSoundSkipCall', 'startupScreenSoundVolume', 'startupScreenTapToSkip', 'startupScreenTempo', 'startupScreenVideoName']
- Key-shaped candidate strings (pattern guess, NOT corroborated): ['accessoryName', 'carName', 'carProfilesEnabled', 'contentMode', 'displayScale', 'isBatteryMonitoringEnabled', 'isLowPowerModeEnabled', 'liteMode', 'logoEffect', 'modelName', 'portType', 'processName', 'startupScreenStyle', 'vehicleName']

### URLs / schemes (3)
- `https://api.open-meteo.com/v1/forecast?latitude=%.2f&longitude=%.2f&current=temperature_2m,weather_code,is_day&daily=temperature_2m_max,temperature_2m_min,precipitation_probability_max&timezone=auto&forecast_days=1`
- `https://ipapi.co/json/`
- `radr://5614542`

### Log tags (0 unique; 0 format strings carry a tag)

### File paths (28)
- `/DynamicLibraries/`
- `/Library/PreferenceBundles/OmniCarPrefs.bundle`
- `/Library/PreferenceBundles/OmniCarPrefs.bundle/PackageIcon.png`
- `/Library/PreferenceBundles/OmniCarPrefs.bundle/logo@3x.png`
- `/System/Library/Frameworks/AVFAudio.framework/AVFAudio`
- `/System/Library/Frameworks/AVFoundation.framework/AVFoundation`
- `/System/Library/Frameworks/CallKit.framework/CallKit`
- `/System/Library/Frameworks/CoreFoundation.framework/CoreFoundation`
- `/System/Library/Frameworks/CoreGraphics.framework/CoreGraphics`
- `/System/Library/Frameworks/CoreLocation.framework/CoreLocation`
- `/System/Library/Frameworks/EventKit.framework/EventKit`
- `/System/Library/Frameworks/Foundation.framework/Foundation`
- `/System/Library/Frameworks/ImageIO.framework/ImageIO`
- `/System/Library/Frameworks/QuartzCore.framework/QuartzCore`
- `/System/Library/Frameworks/UIKit.framework/UIKit`
- `/System/Library/PrivateFrameworks/CarKit.framework/CarKit`
- `/TweakInject/`
- `/usr/lib/libSystem.B.dylib`
- `/usr/lib/libobjc.A.dylib`
- `/var/jb`
- `/var/jb/Library/Frameworks`
- `/var/jb/usr/lib`
- `/var/mobile/Documents/OmniCar.log`
- `/var/mobile/Library/OmniCar/StartupScreen/Logo/logo.png`
- `/var/mobile/Library/OmniCar/StartupScreen/Sounds`
- `/var/mobile/Library/OmniCar/StartupScreen/Videos`
- `/var/mobile/Library/OmniCar/StartupScreen/location.plist`
- `/var/mobile/Library/OmniCar/StartupScreen/weather.plist`

## Counts

- classes 8; class methods total 173; categories 0; protocols 2; defined symbols 41 (external 41 + local 0); undefined 287; strings 4168 lines / 1789 unique
