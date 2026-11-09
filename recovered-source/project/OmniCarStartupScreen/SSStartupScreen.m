// SSStartupScreen.m
// OmniCar 1.0.3 — OmniCarStartupScreen.dylib — reconstructed C layer:
// process constructors, the UIWindow setHidden: trigger hook, the splash
// factory (SSHandleCarScreen), the SpringBoard soundtrack engine, and the
// weather/location services. SSSplash is in SSSplash.m; SSStartupView and the
// small classes are in SSStartupView.m.
//
// IMPORTANT correction to the feature's common description: this module has
// NO AVPlayer/AVPlayerLayer/AVURLAsset usage anywhere (0 hits across all 347
// functions). The "video" style is a JPEG frame sequence decoded with ImageIO
// (see SSSplash), produced earlier by the Settings app; the soundtrack is a
// separate AVAudioPlayer file played by the SpringBoard instance.
//
// Fidelity tags: [VERIFIED] / [INFERRED] / [NOT-RECOVERED] — see the header.

#import "SSStartupScreen.h"
#import <AVFoundation/AVFoundation.h>
#import <CallKit/CallKit.h>
#import <ImageIO/ImageIO.h>
#import <objc/runtime.h>
#import <notify.h>
#import <substrate.h>
#include <dlfcn.h>
#include <string.h>

// ===========================================================================
// Paths [VERIFIED]
// ===========================================================================

// [integration phase 2; backported to src in phase 3] mechanical shim] OMCRealPath (sub_4118 in this binary)
// is declared extern in SSStartupScreen.h, but the shared OMCCommon unit
// keeps its copy of the libroot path layer static (OMCJBRootPath), so the
// symbol is undefined at link time in this subproject. This definition
// supplies it with the core's VERIFIED semantics (OMCCommon.c sub_4118 /
// sub_4170): lazily dlopen "@rpath/libroot.dylib" and tail-call
// libroot_jbrootpath; when the library or the symbol is missing, fall back
// to stock libroot behaviour (jbroot prefix "/var/jb" prepended to absolute
// paths). The result lives in a static 1024-byte buffer; both call sites in
// this module (SSRealPath below, -ss_buildLiquid in SSStartupViewBuilders.m)
// consume it immediately. Returns NULL only for a NULL input.
const char *OMCRealPath(const char *logicalPath) {
    if (!logicalPath) return NULL;
    static char buffer[1024];
    static char *(*jbrootpathFn)(const char *path, char *out);
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        void *h = dlopen("@rpath/libroot.dylib", RTLD_LAZY);
        if (h) jbrootpathFn = (char *(*)(const char *, char *))dlsym(h, "libroot_jbrootpath");
    });
    if (jbrootpathFn) return jbrootpathFn(logicalPath, buffer);
    if (logicalPath[0] == '/') {
        strlcpy(buffer, "/var/jb", sizeof(buffer));
        strlcat(buffer, logicalPath, sizeof(buffer));
    } else {
        strlcpy(buffer, logicalPath, sizeof(buffer));
    }
    return buffer;
}

static NSString *SSRealPath(NSString *logicalPath) {
    const char *real = OMCRealPath(logicalPath.fileSystemRepresentation);
    return real ? [NSString stringWithUTF8String:real] : logicalPath;
}

NSString *SSStartupDir(void) { return SSRealPath(@"/var/mobile/Library/OmniCar/StartupScreen"); }
NSString *SSVideosDir(void)  { return [SSStartupDir() stringByAppendingPathComponent:@"Videos"]; }
NSString *SSSoundsDir(void)  { return [SSStartupDir() stringByAppendingPathComponent:@"Sounds"]; }
NSString *SSLogoPath(void)   { return [SSStartupDir() stringByAppendingPathComponent:@"Logo/logo.png"]; }
static NSString *SSWeatherPlistPath(void)  { return [SSStartupDir() stringByAppendingPathComponent:@"weather.plist"]; }
static NSString *SSLocationPlistPath(void) { return [SSStartupDir() stringByAppendingPathComponent:@"location.plist"]; }

// ===========================================================================
// Small helpers [VERIFIED]
// ===========================================================================

NSInteger SSStyleSetting(void) { // sub_9afc
    NSInteger style = [OMCPref(@"startupScreenStyle", @0) integerValue];
    return (style < 0 || style >= 11) ? 0 : style;   // clamp: >10 (and <0) -> 0
}

NSTimeInterval SSPlaybackSeconds(void) { // sub_5a04
    return MAX([OMCPref(@"startupScreenDuration", @5) doubleValue], 1.0);
}

UIImage *SSLoadImageAtPath(NSString *path) { // sub_5a5c — ImageIO one-shot decode
    CGImageSourceRef source = CGImageSourceCreateWithURL((__bridge CFURLRef)[NSURL fileURLWithPath:path], NULL);
    if (!source) return nil;
    NSDictionary *opts = @{ (id)kCGImageSourceShouldCacheImmediately: @YES };
    CGImageRef image = CGImageSourceCreateImageAtIndex(source, 0, (__bridge CFDictionaryRef)opts);
    CFRelease(source);
    if (!image) return nil;
    UIImage *result = [UIImage imageWithCGImage:image];
    CGImageRelease(image);
    return result;
}

NSInteger SSBatteryPercent(BOOL *outCharging) { // sub_5b68
    UIDevice *device = UIDevice.currentDevice;
    BOOL wasEnabled = device.batteryMonitoringEnabled;
    if (!wasEnabled) device.batteryMonitoringEnabled = YES;
    float level = device.batteryLevel;
    UIDeviceBatteryState state = device.batteryState;
    if (!wasEnabled) device.batteryMonitoringEnabled = NO;
    if (outCharging) *outCharging = ((state & ~1) == 2);   // Charging(2) or Full(3)
    return level < 0 ? -1 : (NSInteger)lrintf(level * 100.0f);
}

NSString *SSScreenDescription(UIScreen *screen) { // sub_8308
    if (!screen) return @"(nil)";
    return [NSString stringWithFormat:@"<%@ %p main=%d idiom=%ld bounds=%@>",
            NSStringFromClass(screen.class), screen,
            screen == UIScreen.mainScreen, (long)screen.traitCollection.userInterfaceIdiom,
            NSStringFromCGRect(screen.bounds)];
}

BOOL SSIsCarScreen(UIScreen *screen) { // sub_a61c
    if (!screen) return NO;
    if (screen.traitCollection.userInterfaceIdiom == UIUserInterfaceIdiomCarPlay) return YES;
    return screen != UIScreen.mainScreen;
}

// First video in the Videos folder: the explicitly chosen one when it still
// exists, else the first non-hidden entry of the sorted directory listing.
NSString *SSChosenVideoName(void) { // sub_9764
    NSString *chosen = OMCPref(@"startupScreenVideoName", nil);
    NSFileManager *fm = NSFileManager.defaultManager;
    if ([chosen isKindOfClass:NSString.class] && chosen.length &&
        [fm fileExistsAtPath:[SSVideosDir() stringByAppendingPathComponent:chosen]])
        return chosen;
    NSError *error = nil;
    NSArray<NSString *> *entries = [[fm contentsOfDirectoryAtPath:SSVideosDir() error:&error]
                                    sortedArrayUsingSelector:@selector(compare:)];
    if (!entries) {
        OMCLogWrite(@"StartupScreen", [NSString stringWithFormat:@"cannot list %@: %@", SSVideosDir(), error]);
        return nil;
    }
    for (NSString *entry in entries)
        if (![entry hasPrefix:@"."]) return entry;
    return nil;
}

// ===========================================================================
// The trigger: -[UIWindow setHidden:] hook (CarPlayApp only) [VERIFIED]
// ===========================================================================

static void (*SSOrigUIWindowSetHidden)(UIWindow *self, SEL _cmd, BOOL hidden);
static BOOL SSArmed;                       // global @0x3b168
static int  SSWindowLogCount;              // global @0x3b1ac (log throttle)

// Associated-object keys [VERIFIED]: the claim is set before any check and is
// never cleared (a UIScreen instance gets at most one splash per connection);
// the splash key is cleared by -[SSSplash tearDown].
// [W-FIX2, verified in the original over LC_FUNCTION_STARTS bounds] EVERY
// objc_setAssociatedObject site in the original passes policy 1
// (OBJC_ASSOCIATION_RETAIN_NONATOMIC) in w3: claim @0xa75c->call 0xa760,
// splash @0xb540->call 0xb544, nil-clear in tearDown @0x71c0->call 0x71c4.
// There is no objc_removeAssociatedObjects anywhere in the original.
static const void *kSSClaimKey  = &kSSClaimKey;  // original: address of global @0x3b1b0 passed as key
static const void *kSSSplashKey = &kSSSplashKey; // original: address of global @0x3b158 passed as key
// [fix-round-3] The original passes the ADDRESSES of these two distinct
// slots as the associated-object keys (@0xa724–0xa728 / @0xb530–0xb534);
// the uninitialised declarations made both keys NULL and identical in
// the rebuild (claim ≡ splash). The self-referential initialisers make
// each key's value its own distinct in-image address, as in the
// original; the keys are never dereferenced.

SSSplash *SSSplashForScreen(UIScreen *screen) {
    return objc_getAssociatedObject(screen, kSSSplashKey);
}

void SSClearSplashAssociation(UIScreen *screen, SSSplash *splash) {
    if (SSSplashForScreen(screen) == splash)
        objc_setAssociatedObject(screen, kSSSplashKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

static void SSWindowShown(UIWindow *window, SEL _cmd, BOOL hidden) { // sub_8054 — the hook replacement
    SSOrigUIWindowSetHidden(window, _cmd, hidden);   // original implementation runs first
    if (hidden) return;                              // only a window being SHOWN can trigger
    if (!SSArmed) return;
    if ([window isKindOfClass:SSSplashWindow.class]) return;
    UIScreen *screen = window.screen;
    if (SSWindowLogCount < 40) {                  // [INFERRED boundary: counter compared to 0x27/0x28]
        SSWindowLogCount++;
        OMCLogWrite(@"StartupScreen", [NSString stringWithFormat:@"window shown: %@ level=%.0f scene=%@ %p %@ screen=%@",
                    NSStringFromClass(window.class), window.windowLevel,
                    NSStringFromClass(window.windowScene.class), window.windowScene,
                    window.windowScene.session.persistentIdentifier,
                    SSScreenDescription(screen)]);
    }
    if (SSIsCarScreen(screen)) {
        UIWindowScene *scene = window.windowScene;
        dispatch_async(dispatch_get_main_queue(), ^{
            SSHandleCarScreen(screen, scene, @"window");
        });
    }
}

static void SSSceneLogAndHandle(UIWindowScene *scene, NSString *reason) { // sub_84b8
    OMCLogWrite(@"StartupScreen", [NSString stringWithFormat:@"%@: %@ role=%@", reason,
                NSStringFromClass(scene.class), scene.session.role]);
    if ([scene isKindOfClass:UIWindowScene.class]) {
        OMCLogWrite(@"StartupScreen", [NSString stringWithFormat:@"%@: idiom=%ld screen=%@", reason,
                    (long)scene.screen.traitCollection.userInterfaceIdiom,
                    SSScreenDescription(scene.screen)]);
        SSHandleCarScreen(scene.screen, scene, reason);
    }
}

static void SSScreenGone(UIScreen *screen) { // sub_8838
    if (!screen) return;   // original: cbz x0 at 0x8838
    // [W-FIX2] Strong local for the WHOLE teardown, as in the original:
    // 0x8850 get, 0x8858 objc_retainAutoreleasedReturnValue held in x19
    // across the tearDown call (0x8860), released only after it (0x8864).
    // The previous form messaged the get's return value directly, so
    // nothing in this frame owned the splash while tearDown cleared the
    // (then ASSIGN) association. Idempotent: after a first tearDown the
    // association is gone, so a repeated call fetches nil and no-ops;
    // clearing the association never calls back into tearDown.
    SSSplash *splash = SSSplashForScreen(screen);
    [splash tearDown];
}

// ===========================================================================
// Splash factory — SSHandleCarScreen (sub_a6c4, 3,848 bytes) [VERIFIED]
// ===========================================================================

static NSString *SSDateKey(NSDate *date) { // sub_b5cc
    static NSDateFormatter *formatter;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        formatter = [NSDateFormatter new];
        formatter.locale = [NSLocale localeWithLocaleIdentifier:@"en_US_POSIX"];
        formatter.calendar = [NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian];
        formatter.dateFormat = @"yyyy-MM-dd";
    });
    return [formatter stringFromDate:date];
}

// Occasion codes: 1 = Tet (lunar new year), 2 = birthday, 3 = Christmas,
// 4 = Mid-Autumn, 5 = New Year, 0 = none. Shown at most 3 times per day;
// the per-day counts live in the startupScreenOccasionLog pref (7-day prune).
static NSInteger SSDetectOccasion(void) {
    if (![OMCPref(@"startupScreenOccasions", @YES) boolValue]) return 0;
    NSDate *now = NSDate.date;
    NSCalendar *gregorian = [NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian];
    NSCalendar *chinese = [NSCalendar calendarWithIdentifier:NSCalendarIdentifierChinese];
    NSDateComponents *g = [gregorian components:NSCalendarUnitMonth | NSCalendarUnitDay fromDate:now];
    NSDateComponents *c = [chinese components:NSCalendarUnitMonth | NSCalendarUnitDay fromDate:now];   // [integration phase 2; backported to src in phase 3] mechanical fix] src named NSCalendarUnitLeapMonth, which does not exist in the iPhoneOS16.5 SDK (no such NSCalendarUnit); the code only reads c.leapMonth / c.month / c.day, so the nonexistent unit flag is dropped — no logic change.
    NSInteger occasion = 0;
    NSString *birthday = OMCPref(@"startupScreenBirthday", nil);
    if ([birthday isKindOfClass:NSString.class]) {
        NSArray<NSString *> *parts = [birthday componentsSeparatedByString:@"-"];
        if (parts.count >= 2 && parts[0].integerValue == g.month && parts[1].integerValue == g.day)
            occasion = 2;
    }
    if (!occasion && !c.leapMonth && c.month == 1 && c.day >= 1 && c.day <= 3) occasion = 1;
    if (!occasion && !c.leapMonth && c.month == 8 && c.day == 15) occasion = 4;
    if (!occasion && g.month == 1 && g.day == 1) occasion = 5;
    if (!occasion && g.month == 12 && (g.day == 24 || g.day == 25)) occasion = 3;
    if (!occasion) return 0;

    NSString *key = SSDateKey(now);
    NSMutableDictionary *log = [OMCPref(@"startupScreenOccasionLog", nil) mutableCopy] ?: [NSMutableDictionary dictionary];
    NSInteger shown = [log[key] integerValue];
    if (shown >= 3) {
        OMCLogWrite(@"StartupScreen", [NSString stringWithFormat:@"occasion %ld already shown %ld times today", (long)occasion, (long)shown]);
        return 0;
    }
    // prune: keep today and the previous 7 days only
    NSMutableDictionary *pruned = [NSMutableDictionary dictionary];
    for (NSInteger i = 0; i <= 7; i++) {
        NSDate *day = [gregorian dateByAddingUnit:NSCalendarUnitDay value:-i toDate:now options:0];
        NSString *dayKey = SSDateKey(day);
        if (log[dayKey]) pruned[dayKey] = log[dayKey];
    }
    pruned[key] = @(shown + 1);
    CFPreferencesSetAppValue((__bridge CFStringRef)@"startupScreenOccasionLog",
                             (__bridge CFPropertyListRef)pruned,
                             (__bridge CFStringRef)@"com.anlai.omnicar");
    CFPreferencesAppSynchronize((__bridge CFStringRef)@"com.anlai.omnicar");
    return occasion;
}

void SSHandleCarScreen(UIScreen *screen, UIWindowScene *scene, NSString *reason) {
    if (!SSIsCarScreen(screen)) return;
    if (objc_getAssociatedObject(screen, kSSClaimKey)) return;    // one splash per screen
    objc_setAssociatedObject(screen, kSSClaimKey, @YES, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    OMCLogWrite(@"StartupScreen", [NSString stringWithFormat:@"car display detected via %@: screen=%@ scene=%@",
                reason, SSScreenDescription(screen), NSStringFromClass(scene.class)]);
    OMCPrefsSync();
    if (!OMCFeatureEnabled(@"startupScreen")) {
        OMCLogWrite(@"StartupScreen", @"disabled in settings");
        return;
    }
    NSInteger occasion = SSDetectOccasion();
    NSInteger setting = SSStyleSetting();
    NSInteger style;
    NSString *framesDir = nil;
    NSUInteger frameCount = 0;
    double fps = 0;

    if (occasion) {
        style = 11;   // occasion scene overrides the configured style
    } else if (setting == 10) {
        // random: deduped candidate set from the pref, all of 0-9 when unset;
        // candidates whose assets are missing are removed before the draw.
        NSMutableArray<NSNumber *> *set = [NSMutableArray array];
        id prefSet = OMCPref(@"startupScreenRandomSet", nil);
        if ([prefSet isKindOfClass:NSArray.class])
            for (id v in (NSArray *)prefSet)
                if ([v isKindOfClass:NSNumber.class] && ![set containsObject:v]) [set addObject:v];
        if (!set.count) for (NSInteger i = 0; i <= 9; i++) [set addObject:@(i)];
        if ([set containsObject:@0] && !SSChosenVideoName()) [set removeObject:@0];
        if ([set containsObject:@1] &&
            ![NSFileManager.defaultManager fileExistsAtPath:SSLogoPath()]) [set removeObject:@1];
        style = set.count ? set[arc4random_uniform((uint32_t)set.count)].integerValue : 2;
    } else {
        style = setting;
    }

    if (!occasion && style == 0) {
        // video style: play the converted frame sequence, else fall back to liquid (9)
        NSString *name = SSChosenVideoName();
        NSDictionary *info = nil;
        if (name) {
            framesDir = [[SSVideosDir() stringByAppendingPathComponent:@".frames"]
                         stringByAppendingPathComponent:name];
            info = [NSDictionary dictionaryWithContentsOfFile:
                    [framesDir stringByAppendingPathComponent:@"info.plist"]];
            frameCount = [info[@"count"] unsignedIntegerValue];
            fps = [info[@"fps"] doubleValue];
        }
        if (name && frameCount > 0 && fps > 0) {
            OMCLogWrite(@"StartupScreen", [NSString stringWithFormat:@"playing %@ (%lu frames @ %.0ffps)",
                        name, (unsigned long)frameCount, fps]);
        } else {
            if (name) OMCLogWrite(@"StartupScreen", [NSString stringWithFormat:@"no frames for %@ (open Settings > OmniCar > Startup Screen to convert it) -> liquid style", name]);
            else      OMCLogWrite(@"StartupScreen", [NSString stringWithFormat:@"no video found in %@ -> liquid style", SSVideosDir()]);
            style = 9;
            framesDir = nil; frameCount = 0; fps = 0;
        }
    }
    if (style != setting)
        OMCLogWrite(@"StartupScreen", [NSString stringWithFormat:@"style %ld this time (setting %ld, occasion %ld)",
                    (long)style, (long)setting, (long)occasion]);
    if (style != 0 && framesDir == nil)
        OMCLogWrite(@"StartupScreen", [NSString stringWithFormat:@"showing style %ld", (long)style]);

    SSSplash *splash = [[SSSplash alloc] initWithScreen:screen scene:scene style:style
                                               occasion:occasion framesDir:framesDir
                                             frameCount:frameCount fps:fps];
    objc_setAssociatedObject(screen, kSSSplashKey, splash, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [splash start];
}

// ===========================================================================
// Constructor (sub_74a8, via __init_offsets) [VERIFIED]
// Two processes, two roles:
//   SpringBoard — background services: soundtrack playback (AVAudioPlayer),
//                 weather fetching, location persistence.
//   CarPlayApp  — the trigger hook + scene/screen observers (above).
// The shared core has its own constructor in this binary at 0x1da64
// (__init_1: processName SpringBoard/CarPlay -> diagLoaded announcement);
// it is part of the core deliverable and not duplicated here.
// ===========================================================================

static void SSAudioDarwinCallback(CFNotificationCenterRef center, void *observer,
                                  CFStringRef name, const void *object, CFDictionaryRef userInfo);
static void SSWeatherRequestDarwinCallback(CFNotificationCenterRef center, void *observer,
                                           CFStringRef name, const void *object, CFDictionaryRef userInfo);
static void SSPlayStopSoundtrack(BOOL play);   // sub_8f0c (SpringBoard)
static void SSAnswerWeatherRequest(void);      // sub_7d10 (SpringBoard)
static void SSLocationStateChanged(uint64_t state); // sub_7a60 (SpringBoard)

__attribute__((constructor)) static void SSStartupScreenInit(void) {
    NSString *bundleId = NSBundle.mainBundle.bundleIdentifier;
    CFNotificationCenterRef darwin = CFNotificationCenterGetDarwinNotifyCenter();

    if ([bundleId isEqualToString:@"com.apple.springboard"]) {
        CFNotificationCenterAddObserver(darwin, NULL, SSAudioDarwinCallback,
            CFSTR("com.anlai.omnicar/startupscreen.audio.play"), NULL,
            CFNotificationSuspensionBehaviorDeliverImmediately);
        CFNotificationCenterAddObserver(darwin, NULL, SSAudioDarwinCallback,
            CFSTR("com.anlai.omnicar/startupscreen.audio.stop"), NULL,
            CFNotificationSuspensionBehaviorDeliverImmediately);
        CFNotificationCenterAddObserver(darwin, NULL, SSWeatherRequestDarwinCallback,
            CFSTR("com.anlai.omnicar/startupscreen.weather.request"), NULL,
            CFNotificationSuspensionBehaviorDeliverImmediately);
        // The nav app's position arrives as notify state on com.anlai.omnicar/location.
        static int locationToken;   // global @0x3b15c
        notify_register_dispatch("com.anlai.omnicar/location", &locationToken,
                                 dispatch_get_main_queue(), ^(int token) {
            uint64_t state = 0;
            notify_get_state(token, &state);
            SSLocationStateChanged(state);
        });
        // Warm the weather cache shortly after launch, and pre-create the
        // call observer so the first skip-on-call check is cheap.
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(15.0 * NSEC_PER_SEC)),
                       dispatch_get_main_queue(), ^{   // sub_7cc0
            OMCLogWrite(@"StartupScreen", @"weather: warming the cache at startup");
            SSAnswerWeatherRequest();
        });
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(10.0 * NSEC_PER_SEC)),
                       dispatch_get_main_queue(), ^{   // sub_800c
            extern CXCallObserver *SSSharedCallObserver(void);
            SSSharedCallObserver();
        });
        return;
    }

    if (![bundleId isEqualToString:@"com.apple.CarPlayApp"]) return;
    if (!OMCCrashGuard(@"startupScreen")) return;   // rescue mode: stay out
    SSArmed = YES;
    MSHookMessageEx(UIWindow.class, @selector(setHidden:),
                    (IMP)SSWindowShown, (IMP *)&SSOrigUIWindowSetHidden);
    for (UIScreen *screen in UIScreen.screens)
        OMCLogWrite(@"StartupScreen", [NSString stringWithFormat:@"existing screen: %@", SSScreenDescription(screen)]);
    OMCLogWrite(@"StartupScreen", [NSString stringWithFormat:@"videos dir %@ readable=%d", SSVideosDir(),
                [NSFileManager.defaultManager isReadableFileAtPath:SSVideosDir()]]);
    NSNotificationCenter *nc = NSNotificationCenter.defaultCenter;
    NSOperationQueue *main = NSOperationQueue.mainQueue;
    [nc addObserverForName:UISceneWillConnectNotification object:nil queue:main
                usingBlock:^(NSNotification *note) {   // sub_8420 [INFERRED body: async hand-off]
        dispatch_async(dispatch_get_main_queue(), ^{
            SSSceneLogAndHandle((UIWindowScene *)note.object, @"sceneConnect");
        });
    }];
    [nc addObserverForName:UISceneDidActivateNotification object:nil queue:main
                usingBlock:^(NSNotification *note) {   // sub_8694
        SSSceneLogAndHandle((UIWindowScene *)note.object, @"sceneActivate");
    }];
    [nc addObserverForName:UIScreenDidConnectNotification object:nil queue:main
                usingBlock:^(NSNotification *note) {   // sub_86d0
        OMCLogWrite(@"StartupScreen", [NSString stringWithFormat:@"screen connected: %@",
                    SSScreenDescription((UIScreen *)note.object)]);
    }];
    [nc addObserverForName:UIScreenDidDisconnectNotification object:nil queue:main
                usingBlock:^(NSNotification *note) {   // sub_8768
        UIScreen *screen = (UIScreen *)note.object;
        OMCLogWrite(@"StartupScreen", [NSString stringWithFormat:@"screen disconnected: %@", SSScreenDescription(screen)]);
        SSScreenGone(screen);
    }];
    [nc addObserverForName:UISceneDidDisconnectNotification object:nil queue:main
                usingBlock:^(NSNotification *note) {   // sub_8878
        if ([note.object isKindOfClass:UIWindowScene.class])
            SSScreenGone(((UIWindowScene *)note.object).screen);
    }];
}

// ===========================================================================
// Soundtrack engine — SpringBoard (sub_8f0c) [VERIFIED]
// The soundtrack accompanies the VIDEO style only (style 0). Playback uses
// AVAudioSessionCategoryPlayback + MixWithOthers; there is no explicit output
// port override — "routing to the car" is whatever route the CarPlay
// connection already provides (the log line dumps currentRoute to prove it).
// ===========================================================================

static AVAudioPlayer *SSCurrentPlayer;             // global @0x3b178
static NSString *SSSavedCategory;                  // global @0x3b180
static NSNumber *SSSavedCategoryOptions;           // global @0x3b1a0
static CXCallObserver *SSCallObserverShared;       // global @0x3b160

CXCallObserver *SSSharedCallObserver(void) {
    if (!SSCallObserverShared) SSCallObserverShared = [CXCallObserver new];
    return SSCallObserverShared;
}

static void SSRestoreAudioSession(void) { // sub_9a84
    if (!SSSavedCategory) return;
    AVAudioSession *session = AVAudioSession.sharedInstance;
    [session setCategory:SSSavedCategory
             withOptions:SSSavedCategoryOptions.unsignedIntegerValue error:nil];
    SSSavedCategory = nil;
    SSSavedCategoryOptions = nil;
}

static void SSAudioDarwinCallback(CFNotificationCenterRef center, void *observer,
                                  CFStringRef name, const void *object, CFDictionaryRef userInfo) {
    BOOL play = CFStringCompare(name, CFSTR("com.anlai.omnicar/startupscreen.audio.play"), 0) == kCFCompareEqualTo;
    dispatch_async(dispatch_get_main_queue(), ^{ SSPlayStopSoundtrack(play); });
}

static void SSPlayStopSoundtrack(BOOL play) { // sub_8f0c
    if (!play) {
        AVAudioPlayer *player = SSCurrentPlayer;
        SSCurrentPlayer = nil;
        [player setVolume:0.0 fadeDuration:0.4];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.4 * NSEC_PER_SEC)),
                       dispatch_get_main_queue(), ^{   // sub_9b4c
            [player stop];
            SSRestoreAudioSession();
        });
        return;
    }
    OMCPrefsSync();
    // Which style is on screen? The CarPlayApp side published it as notify state.
    int styleToken = 0;
    uint64_t styleState = 0;
    NSInteger style = (notify_register_check("com.anlai.omnicar/startupscreen.style", &styleToken) == 0 &&
                       notify_get_state(styleToken, &styleState) == 0 && styleState != 0)
                      ? (NSInteger)styleState - 1 : SSStyleSetting();
                      // [VERIFIED: the publisher sends style+1; the binary
                      // recovers the style with state-1 (sub @0x8f74) and
                      // state 0 is the "unset" sentinel -> pref fallback]
    if (style != 0) return;   // soundtrack is for the video style only

    NSString *path = nil;
    BOOL playFull = [OMCPref(@"startupScreenPlayFull", @NO) boolValue];
    if ([OMCPref(@"startupScreenSound", @NO) boolValue]) {
        NSString *name = SSChosenVideoName();
        if (name) {
            path = [[SSVideosDir() stringByAppendingPathComponent:@".frames"]
                    stringByAppendingPathComponent:[name stringByAppendingPathComponent:@"audio.m4a"]];
            if (![NSFileManager.defaultManager fileExistsAtPath:path]) {
                OMCLogWrite(@"StartupScreen", [NSString stringWithFormat:@"audio: no soundtrack for %@", name]);
                path = nil;
            }
        }
    }
    if (!path) {
        NSString *file = OMCPref(@"startupScreenSoundFile", nil);
        if ([file isKindOfClass:NSString.class] && file.length) {
            path = [SSSoundsDir() stringByAppendingPathComponent:file.lastPathComponent];
            if (![NSFileManager.defaultManager fileExistsAtPath:path]) {
                OMCLogWrite(@"StartupScreen", [NSString stringWithFormat:@"audio: startup sound %@ is missing", file.lastPathComponent]);
                return;
            }
        }
    }
    if (!path) return;

    if ([OMCPref(@"startupScreenSoundSkipCall", @YES) boolValue]) {
        for (CXCall *call in SSSharedCallObserver().calls) {
            if (!call.hasEnded) {
                OMCLogWrite(@"StartupScreen", @"audio: skipped, a phone call is in progress");
                return;
            }
        }
    }
    double percent = [OMCPref(@"startupScreenSoundVolume", @100) doubleValue];
    float volume = (float)(MIN(MAX(percent, 0.0), 100.0) / 100.0);
    if (volume <= 0) return;

    [SSCurrentPlayer stop];
    AVAudioSession *session = AVAudioSession.sharedInstance;
    if (!SSSavedCategory) {
        SSSavedCategory = session.category;
        SSSavedCategoryOptions = @(session.categoryOptions);
    }
    [session setCategory:AVAudioSessionCategoryPlayback
             withOptions:AVAudioSessionCategoryOptionMixWithOthers error:nil];
    [session setActive:YES error:nil];
    NSError *error = nil;
    AVAudioPlayer *player = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:path]
                                                                   error:&error];
    if (!player) {
        OMCLogWrite(@"StartupScreen", [NSString stringWithFormat:@"audio: cannot open %@: %@", path, error]);
        SSRestoreAudioSession();
        return;
    }
    SSCurrentPlayer = player;
    player.numberOfLoops = playFull - 1;   // [VERIFIED: the binary computes
                      // boolValue(startupScreenPlayFull) - 1 @0x91ac-0x91b0, so
                      // YES -> 0 (play once), NO -> -1 (loop forever) — an
                      // earlier draft had this mapping inverted]
    player.volume = volume;
    BOOL ok = [player play];
    OMCLogWrite(@"StartupScreen", [NSString stringWithFormat:@"audio: playing %@ ok=%d volume=%.2f route=%@", path, ok,
                volume, session.currentRoute.outputs.firstObject.portType]);
}

// ===========================================================================
// Weather + location services
// ===========================================================================

static NSNumber *SSCoerceNumber(id value) { // sub_ba08 [VERIFIED: NSNumber-only,
    // csel value/nil on the class test @0xba38-0xba3c — no NSString branch]
    return [value isKindOfClass:NSNumber.class] ? value : nil;
}

static NSNumber *SSFirstNumber(id value) { // sub_ba60: arrays contribute their first element
    if ([value isKindOfClass:NSArray.class]) value = [(NSArray *)value firstObject];
    return SSCoerceNumber(value);
}

NSDictionary *SSWeatherParse(NSDictionary *json) { // SSWeatherParse @0xb6b0 [VERIFIED]
    if (![json isKindOfClass:NSDictionary.class]) return nil;
    NSDictionary *current = json[@"current"];
    NSDictionary *daily = json[@"daily"];
    if (![current isKindOfClass:NSDictionary.class]) return nil;   // @0xb744 -> nil
    // The result dict is created only AFTER temperature_2m coerces (@0xb77c:
    // cbz -> return nil) — a temp-less payload must not overwrite a good cache.
    NSNumber *temp = SSCoerceNumber(current[@"temperature_2m"]);
    if (!temp) return nil;
    NSMutableDictionary *weather = [NSMutableDictionary dictionary];
    NSNumber *n;
    weather[@"temp"] = temp;
    // code/isDay are ALWAYS set: on a failed coerce the original substitutes
    // constant NSNumbers (@0xb7e0/@0xb83c csel). Byte-verified from the
    // original slice (constant-number records @0x34e58/@0x34e70, int64 value
    // at +16): the defaults are @0 (code) and @1 (isDay).
    weather[@"code"]  = SSCoerceNumber(current[@"weather_code"]) ?: @0;
    weather[@"isDay"] = SSCoerceNumber(current[@"is_day"]) ?: @1;
    if ([daily isKindOfClass:NSDictionary.class]) {   // @0xb86c guard; else skip to date
        if ((n = SSFirstNumber(daily[@"temperature_2m_max"])))          weather[@"high"] = n;
        if ((n = SSFirstNumber(daily[@"temperature_2m_min"])))          weather[@"low"] = n;
        if ((n = SSFirstNumber(daily[@"precipitation_probability_max"]))) weather[@"rain"] = n;
    }
    weather[@"date"] = NSDate.date;
    return weather;
}

static NSString *SSWeatherTempCachePath(void) { // sub_bd9c [VERIFIED]
    return [NSTemporaryDirectory() stringByAppendingPathComponent:@"OmniCarStartupWeather.plist"];
}

static NSArray<NSString *> *SSWeatherCachePaths(void) { // SSWeatherLoadCache @0xbaf0
    return @[ SSWeatherPlistPath(), SSWeatherTempCachePath() ];
}

NSDictionary *SSWeatherLoadCache(double maxAgeSeconds) { // SSWeatherLoadCache @0xbaf0 [VERIFIED]
    NSDictionary *best = nil;
    NSDate *bestDate = nil;
    for (NSString *path in SSWeatherCachePaths()) {
        NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:path];
        NSDate *date = dict[@"date"];
        if (![date isKindOfClass:NSDate.class]) continue;
        if (!SSCoerceNumber(dict[@"temp"])) continue;
        // Age gate (@0xbc9c-0xbcb4): only when maxAgeSeconds > 0, and a
        // candidate is rejected when its age reaches maxAgeSeconds. There is
        // NO future-date guard in the original — a future date has negative
        // age and passes.
        if (maxAgeSeconds > 0 && -date.timeIntervalSinceNow >= maxAgeSeconds) continue;
        // Newest wins, strictly: an equal date keeps the earlier candidate
        // (@0xbcd4: replace only when compare: == NSOrderedDescending).
        if (!best || [date compare:bestDate] == NSOrderedDescending) {
            best = dict;
            bestDate = date;
        }
    }
    return best;
}

void SSWeatherSaveCache(NSDictionary *weather) { // SSWeatherSaveCache @0xbde8 [VERIFIED]
    if (!weather) return;
    NSFileManager *fm = NSFileManager.defaultManager;
    [fm createDirectoryAtPath:SSStartupDir() withIntermediateDirectories:YES attributes:nil error:nil];
    NSURL *url = [NSURL fileURLWithPath:SSWeatherPlistPath()];
    if ([weather writeToURL:url error:nil]) {
        // Permissions value byte-verified: constant NSNumber @0x34e88 == 420.
        [fm setAttributes:@{ NSFilePosixPermissions: @0644 }
             ofItemAtPath:SSWeatherPlistPath() error:nil];
    } else {
        // Primary write failed -> fall back to the temp-dir cache file
        // (@0xbfa4: writeToURL:fileURLWithPath(sub_bd9c())).
        [weather writeToURL:[NSURL fileURLWithPath:SSWeatherTempCachePath()] error:nil];
    }
}

void SSWeatherFetch(double lat, double lon, void (^completion)(NSDictionary *)) { // sub_88e4 [VERIFIED]
    NSString *urlString = [NSString stringWithFormat:
        @"https://api.open-meteo.com/v1/forecast?latitude=%.2f&longitude=%.2f"
         "&current=temperature_2m,weather_code,is_day"
         "&daily=temperature_2m_max,temperature_2m_min,precipitation_probability_max"
         "&timezone=auto&forecast_days=1", lat, lon];
    NSURL *url = [NSURL URLWithString:urlString];
    if (!url) { if (completion) completion(nil); return; }
    NSURLSessionConfiguration *config = NSURLSessionConfiguration.ephemeralSessionConfiguration;
    config.timeoutIntervalForRequest = 3.0;
    config.timeoutIntervalForResource = 3.0;
    config.waitsForConnectivity = NO;
    config.requestCachePolicy = NSURLRequestReloadIgnoringLocalCacheData;
    NSURLSession *session = [NSURLSession sessionWithConfiguration:config];
    CFTimeInterval started = CACurrentMediaTime();
    [[session dataTaskWithURL:url completionHandler:
      ^(NSData *data, NSURLResponse *response, NSError *error) {   // sub_8c94 [VERIFIED]
        NSDictionary *weather = nil;
        // The original checks the response class before reading the status
        // (sub_8c94 @0x8cf8): a non-HTTP response counts as status 0 and is
        // never parsed.
        NSInteger status = [response isKindOfClass:NSHTTPURLResponse.class]
            ? [(NSHTTPURLResponse *)response statusCode] : 0;
        if (data && !error && status == 200) {
            NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            weather = SSWeatherParse(json);
            if (weather) SSWeatherSaveCache(weather);
        }
        OMCLogWrite(@"StartupScreen", [NSString stringWithFormat:@"weather: %@ in %.1fs (http %ld, %@)",
                    weather ? @"updated" : @"failed", CACurrentMediaTime() - started,
                    (long)status, error.localizedDescription ?: @"no error"]);
        dispatch_async(dispatch_get_main_queue(), ^{ if (completion) completion(weather); });
    }] resume];
    [session finishTasksAndInvalidate];
}

// --- SpringBoard side: answering a weather request ---------------------------

static BOOL SSWeatherAnswerInFlight;   // reentrancy guard [VERIFIED log line]

// The in-flight one-shot lives in a global STRONG slot (original @0x3b190,
// stored at 0x7f6c): CLLocationManager does not retain its delegate, so the
// slot is what keeps the SSLocationOnce alive until it finishes. The done
// block (sub_9f9c) clears the slot first thing; the 6s timeout block
// (sub_a00c) only fires while the slot still holds ITS one-shot.
static SSLocationOnce *SSWeatherOnceSlot;

static void SSNotifyWeatherReady(void) { // sub_a608
    notify_post("com.anlai.omnicar/startupscreen.weather.ready");
}

static void SSFetchAndAnswer(double lat, double lon, NSString *source) { // sub_9f1c [VERIFIED]
    OMCLogWrite(@"StartupScreen", [NSString stringWithFormat:@"weather: SpringBoard fetching with the %@ position", source]);
    SSWeatherFetch(lat, lon, ^(NSDictionary *weather) {
        SSWeatherAnswerInFlight = NO;
        SSNotifyWeatherReady();
    });
}

static NSNumber *SSCoerceLoose(id value) { // sub_a184 [VERIFIED]: NSNumber passes
    // through; a NON-EMPTY NSString converts via doubleValue; else nil.
    // (Separate from sub_ba08/SSCoerceNumber, which is NSNumber-only.)
    if ([value isKindOfClass:NSNumber.class]) return value;
    if ([value isKindOfClass:NSString.class] && [(NSString *)value length])
        return @([(NSString *)value doubleValue]);
    return nil;
}

static void SSAnswerWithStoredOrIP(void);   // sub_9b7c, below

static void SSAnswerWeatherRequest(void) { // sub_7d10 [VERIFIED branch-for-branch]
    if (SSWeatherAnswerInFlight) {
        OMCLogWrite(@"StartupScreen", @"weather: request while another is being answered, ignored");
        return;
    }
    SSWeatherAnswerInFlight = YES;
    CLLocationManager *manager = [CLLocationManager new];
    CLAuthorizationStatus status = CLLocationManager.authorizationStatus;
    CLLocation *fix = manager.location;
    OMCLogWrite(@"StartupScreen", [NSString stringWithFormat:@"weather: SpringBoard location status %d, last fix %@",
                (int)status,
                fix ? [NSString stringWithFormat:@"%.0fs old", -fix.timestamp.timeIntervalSinceNow]
                    : @"none"]);
    // W5a: the authorized branch (last-fix shortcut AND one-shot) is entered
    // ONLY for status in {3,4} — original: sub w25,w0,#3; cmp #2; b.hs ->
    // stored/IP (@0x7e1c/@0x7e6c/@0x7ed0). Status 0/1/2 go straight to
    // SSAnswerWithStoredOrIP() even when a fix exists.
    if ((NSUInteger)(status - 3) > 1) {
        SSAnswerWithStoredOrIP();
        return;
    }
    // A last fix younger than 1800s is used directly (constant @0x28df8 =
    // -1800.0; fcmp/b.le @0x7ea0-0x7ea4 sends age >= 1800s to the one-shot).
    if (fix && -fix.timestamp.timeIntervalSinceNow < 1800) {
        SSFetchAndAnswer(fix.coordinate.latitude, fix.coordinate.longitude, @"last CoreLocation");
        return;
    }
    // One-shot fix at kilometre accuracy — weather does not need better.
    // W5b: it runs on the SAME manager created at entry (@0x7ef4-0x7f10) and
    // the SSLocationOnce is held by the global strong slot, not a local.
    SSLocationOnce *once = [SSLocationOnce new];
    manager.desiredAccuracy = kCLLocationAccuracyKilometer;
    manager.delegate = once;
    once.manager = manager;
    once.done = ^(CLLocation *location) {   // sub_9f9c [VERIFIED]
        SSWeatherOnceSlot = nil;   // the block clears the slot first (@0x9fbc)
        if (location) SSFetchAndAnswer(location.coordinate.latitude,
                                       location.coordinate.longitude, @"fresh CoreLocation");
        else SSAnswerWithStoredOrIP();
    };
    SSWeatherOnceSlot = once;
    [manager startUpdatingLocation];
    // W5c: 6s timeout (0x165A0BC00 ns @0x7f5c). Whichever of done/timeout runs
    // first ends the transaction exactly once: finish: consumes `done`, and
    // this block (sub_a00c) no-ops unless the slot still holds THIS one-shot.
    __weak SSLocationOnce *weakOnce = once;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)6000000000),
                   dispatch_get_main_queue(), ^{   // sub_a00c [VERIFIED]
        SSLocationOnce *strongOnce = weakOnce;
        if (!strongOnce || SSWeatherOnceSlot != strongOnce) return;
        OMCLogWrite(@"StartupScreen", @"weather: no fresh fix in 6s, using the last one");
        [strongOnce finish:strongOnce.manager.location];
    });
}

static void SSAnswerWithStoredOrIP(void) { // sub_9b7c [VERIFIED branch-for-branch]
    NSDictionary *stored = [NSDictionary dictionaryWithContentsOfFile:SSLocationPlistPath()];
    NSDate *date = stored[@"date"];
    NSNumber *lat = SSCoerceLoose(stored[@"lat"]);
    NSNumber *lon = SSCoerceLoose(stored[@"lon"]);
    BOOL usable = [date isKindOfClass:NSDate.class] && lat && lon;
    if (usable) {
        // W6: the stored position counts only inside a 24h window and never
        // from the future (@0x9ccc-0x9ce8: timeIntervalSinceNow > 0 -> out;
        // constant @0x28e00 = -86400.0, older than that -> out).
        NSTimeInterval t = date.timeIntervalSinceNow;
        if (t > 0 || t < -86400) usable = NO;
    }
    if (usable) {
        NSString *label = [NSString stringWithFormat:@"nav app's (%.0f min old)",
                           -date.timeIntervalSinceNow / 60.0];
        SSFetchAndAnswer(lat.doubleValue, lon.doubleValue, label);
        return;
    }
    OMCLogWrite(@"StartupScreen", @"weather: no position from the nav app yet, trying the IP");
    // IP geolocation fallback via https://ipapi.co/json/ — the fetch is the
    // tail of sub_9b7c; its completion is sub_a22c -> sub_a0c8. [VERIFIED flow]
    // W7: the original's ephemeral config sets 4.0s request/resource
    // timeouts and waitsForConnectivity = NO (@0x9df4-0x9e10).
    NSURLSessionConfiguration *ipConfig = NSURLSessionConfiguration.ephemeralSessionConfiguration;
    ipConfig.timeoutIntervalForRequest = 4.0;
    ipConfig.timeoutIntervalForResource = 4.0;
    ipConfig.waitsForConnectivity = NO;
    NSURLSession *session = [NSURLSession sessionWithConfiguration:ipConfig];
    [[session dataTaskWithURL:[NSURL URLWithString:@"https://ipapi.co/json/"]
            completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSDictionary *json = data ? [NSJSONSerialization JSONObjectWithData:data options:0 error:nil] : nil;
        // sub_a22c reads the keys only when the payload is a dictionary.
        BOOL isDict = [json isKindOfClass:NSDictionary.class];
        NSNumber *ipLat = isDict ? SSCoerceLoose(json[@"latitude"]) : nil;
        NSNumber *ipLon = isDict ? SSCoerceLoose(json[@"longitude"]) : nil;
        NSString *city = isDict && [json[@"city"] isKindOfClass:NSString.class] ? json[@"city"] : nil;
        if (!ipLat || !ipLon)   // sub_a22c @0xa3bc: logged whenever coords are missing
            OMCLogWrite(@"StartupScreen", [NSString stringWithFormat:@"weather: IP location failed (%@)",
                        error.localizedDescription ?: @"no coordinates in the answer"]);
        dispatch_async(dispatch_get_main_queue(), ^{   // sub_a0c8
            if (ipLat && ipLon) {
                SSFetchAndAnswer(ipLat.doubleValue, ipLon.doubleValue,
                                 [NSString stringWithFormat:@"IP (%@)", city]);
            } else {
                OMCLogWrite(@"StartupScreen", @"weather: SpringBoard has no position at all, answering without weather");
                SSWeatherAnswerInFlight = NO;
                SSNotifyWeatherReady();
            }
        });
    }] resume];
    [session finishTasksAndInvalidate];
}

static void SSWeatherRequestDarwinCallback(CFNotificationCenterRef center, void *observer,
                                           CFStringRef name, const void *object, CFDictionaryRef userInfo) {
    dispatch_async(dispatch_get_main_queue(), ^{ SSAnswerWeatherRequest(); });   // sub_9b78 -> sub_7d10
}

// The nav app's position, persisted: notify state packs centidegrees —
// state = (int64)(lat*100) << 32 | (uint32)(int64)(lon*100). [VERIFIED]
static void SSLocationStateChanged(uint64_t state) { // sub_7a60
    if (!state) return;
    double lat = (double)(int32_t)(state >> 32) / 100.0;
    double lon = (double)(int32_t)(state & 0xFFFFFFFF) / 100.0;
    NSDictionary *stored = @{ @"lat": @(lat), @"lon": @(lon), @"date": NSDate.date };
    [NSFileManager.defaultManager createDirectoryAtPath:SSStartupDir()
                            withIntermediateDirectories:YES attributes:nil error:nil];
    [stored writeToURL:[NSURL fileURLWithPath:SSLocationPlistPath()] error:nil];
}

// ===========================================================================
// SSLocationOnce [VERIFIED]
// ===========================================================================

@implementation SSLocationOnce
- (void)locationManager:(CLLocationManager *)manager
     didUpdateLocations:(NSArray<CLLocation *> *)locations {
    [self finish:locations.lastObject];
}
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    OMCLogWrite(@"StartupScreen", [NSString stringWithFormat:@"weather: location failed: %@", error.localizedDescription]);
    [self finish:manager.location];
}
- (void)finish:(CLLocation *)location { // -[SSLocationOnce finish:]
    [self.manager stopUpdatingLocation];
    void (^done)(CLLocation *) = self.done;
    self.done = nil;
    if (done) done(location);
}
@end

// ===========================================================================
// Calendar period + preview sample data
// ===========================================================================

NSInteger SSPeriodForDate(NSDate *date) { // SSPeriodForDate @0xc054 [VERIFIED]
    NSInteger hour = [[NSCalendar currentCalendar] component:NSCalendarUnitHour
                                                     fromDate:date ?: NSDate.date];
    if (hour >= 5 && hour < 11) return 0;    // morning
    if (hour >= 11 && hour < 17) return 1;   // day
    if (hour >= 17 && hour < 21) return 2;   // evening
    return 3;                                // night
}

static NSArray *SSSampleHUD(NSString *carName) { // sub_16544 [INFERRED contents from ss_buildHud shape]
    return @[ @{ @"text": OMCTr(@"Đã kết nối CarPlay", @"CarPlay connected"), @"ok": @YES },
              @{ @"text": carName.length ? carName : @"OmniCar", @"ok": @YES } ];
}

void SSApplySampleData(SSStartupView *view) { // SSApplySampleData @0x1a974 [VERIFIED shape]
    if (!view) return;
    if (!view.hud.count) view.hud = SSSampleHUD(view.carName);
    if (!view.nextEvent)
        view.nextEvent = @{ @"title": OMCTr(@"Họp nhóm", @"Team meeting"),
                            @"date": [NSDate dateWithTimeIntervalSinceNow:3600] };  // [INFERRED interval]
    if (view.batteryPercent < 0) view.batteryPercent = 86;   // [INFERRED sample value]
    if (!view.weather)
        view.weather = @{ @"temp": @27, @"code": @0, @"isDay": @YES,
                          @"high": @31, @"low": @24, @"rain": @10 };   // [INFERRED sample values]
}
