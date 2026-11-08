// SPPDisplayBoot.m — reconstructed from OmniCarSpeedBubble.dylib (arm64).
// Agent A (display side). Process entry points and Darwin-notification
// CONSUME side for SpringBoard and CarPlayApp:
//   __init_0 (0x44a8)  — CarPlayApp only: registers the "opencar" handler
//                        (tap-to-reopen on the car dashboard)
//   __init_2 (0xcb30)  — SpringBoard: hooks SpringBoard's
//                        applicationDidFinishLaunching: and, from the
//                        replacement (sub_cc34), registers every channel
//                        the display side consumes.
//   __init_3 (0x239a0) — SpringBoard/CarPlay processes: main-queue
//                        diag stamp (log line + diagLoaded preference).
//                        Restored in CLOSURE-2 (census items C1/C2).
// The SOURCE-APP side (what runs inside Vietmap/GOFA/Waze/Wyn, __init_1)
// belongs to agent B. Status: VERIFIED from disassembly except where a
// comment says INFERRED.

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <notify.h>
#import <substrate.h>

extern BOOL _OMCCrashGuard(NSString *module);
extern void _OMCLogWrite(NSString *module, NSString *message);
// VERIFIED arity (phase-2 pass, from sub_45b4's call sites @0x46f4 /
// 0x47c0 / 0x48dc / 0x48f4): _OMCMissingSelector takes the module, the
// OBJECT that lacks the selector, and the selector NAME — three
// arguments, not two.
extern void _OMCMissingSelector(NSString *module, id object,
                                NSString *selectorName);

// SPPBubble / SPPOverspeed / SPPPrefs (other A files)
@interface SPPBubble : NSObject
+ (instancetype)shared;
- (void)updateSpeed:(NSInteger)speed limit:(NSInteger)limit
    appForeground:(BOOL)fg app:(NSInteger)app;
- (void)refresh;
- (void)runDemo;
- (void)resetLayout;
- (void)setCarBusy:(BOOL)busy;
@end
@interface SPPOverspeed : NSObject
+ (instancetype)shared;
- (void)reloadPrefs;
- (void)carChanged;
@end
@interface SPPPrefs : NSObject
+ (BOOL)enabled;
+ (NSInteger)source;
+ (BOOL)appEnabled:(NSInteger)app;
@end

#pragma mark - Consume: speedbubble.speed (sub_cec4 @0xcec4)

// VERIFIED state format of "com.anlai.omnicar/speedbubble.speed".
// The publisher (source-app side, agent B) packs one reading into the
// 64-bit Darwin notify state; the consumer decodes:
//   bits  0..7   limit byte (km/h)
//   bits  8..15  speed byte (km/h)
//   bit  16      speed valid  (clear -> speed = -1)
//   bit  17      limit valid  (clear -> limit = -1)
//   bit  18      source app is foreground (on the phone)
//   bits 19..21  source app index 0..7 (0 Vietmap, 1 GOFA, 2 Waze, 3 Wyn)
// Readings from an app that is not the user-selected source are dropped
// ([SPPPrefs appEnabled:] == (source == app)).
static void SPPConsumeSpeedNotification(int token) {
    uint64_t state = 0;
    notify_get_state(token, &state);
    int limit = (int)(state & 0xFF);
    int speed = (int)((state >> 8) & 0xFF);
    if (!(state & 0x10000)) speed = -1;
    if (!(state & 0x20000)) limit = -1;
    BOOL fg = (state & 0x40000) != 0;
    NSInteger app = (NSInteger)((state >> 19) & 0x7);
    if (![SPPPrefs appEnabled:app]) return;
    [[SPPBubble shared] updateSpeed:speed limit:limit appForeground:fg app:app];
}

#pragma mark - Publish: selected source (sub_d088 @0xd088)

// Display side tells the source apps which one is selected: state of
// "com.anlai.omnicar/speedbubble.source" = enabled ? source index : 0xFF.
// Called once from the SpringBoard launch replacement.
static void SPPPublishSelectedSource(void) {
    static int token;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        if (notify_register_check("com.anlai.omnicar/speedbubble.source",
                                  &token) != NOTIFY_STATUS_OK) {
            token = 0;
        }
    });
    if (!token) return;
    uint64_t state = [SPPPrefs enabled] ? (uint64_t)[SPPPrefs source] : 0xFF;
    notify_set_state(token, state);
    notify_post("com.anlai.omnicar/speedbubble.source");
}

#pragma mark - CarPlayApp: opencar handler (sub_45b4 @0x45b4)

// CANONICAL COPY of __init_0 + sub_45b4 (phase-2 dedupe). Two drafts
// existed — agent A's in this file and agent B's SBOpenCar.m. In the
// phase-2 pass both were diffed element-by-element against a fresh
// disassembly of the binary (capstone, names via verify/macho_truth.py
// only); NEITHER matched outright, so this text follows the BINARY on
// every point (the points where each draft was wrong are tabulated in
// REPORT_A.md, "Phase-2 compile fix" section). SBOpenCar.m now holds
// only a pointer note. Verified flow:
//   state = notify state of "com.anlai.omnicar/speedbubble.opencar"
//   bundleId: any bit of state outside 0..3 -> @"vn.vietmap.live"
//             (the cfstring is loaded directly @0x45ec); otherwise the
//             constant table @[Vietmap, GOFA, Waze, Wyn][state & 3]
//             (objectAtIndexedSubscript: @0x4604).
//   app = [UIApplication sharedApplication]
//   PRE-CHECK: if the APPLICATION does not respond to BOTH
//   _currentDashboard and sharedApplicationLibrary, one combined line
//   is logged ("CarPlay: khong co _currentDashboard /
//   sharedApplicationLibrary" @0x46b0) and the handler stops. The
//   library is obtained from the APP, not from the dashboard.
//   dashboard  = [app _currentDashboard]            (guarded)
//   library    = [app sharedApplicationLibrary]     (guarded)
//   info       = [library applicationInfoForBundleIdentifier:bundleId]
//                                                     (guarded)
//   launchInfo = _OMCCarLaunchInfo(info)   (called unconditionally)
//   if (!dashboard || !launchInfo): log
//       "CarPlay: khong mo duoc %@ (dashboard=%@ info=%@)"
//       and stop (@0x4890).
//   eventClass = _OMCCarClass("DBEvent")  (helper, NOT objc_getClass)
//   event = [eventClass eventWithType:4 context:launchInfo]
//       — the type is the literal 4 (@0x4830: mov w2, #4), guarded.
//   if (event): [dashboard handleEvent:event]       (guarded)
//   log "CarPlay: mo %@" — UNCONDITIONALLY at the end of the gated
//   path (@0x4910), even when the event/handleEvent step was missing
//   (those steps report themselves via _OMCMissingSelector).
// Every guard failure reports _OMCMissingSelector(@"SpeedBubble",
// object, @"<selector name>") — three arguments (@0x46f4 et al.).
extern id _OMCCarLaunchInfo(id applicationInfo);   // OMC core helper
extern id _OMCCarClass(const char *name);          // OMC core helper
// The binary's table is an NSConstantArray in __objc_const, indexed
// with objectAtIndexedSubscript: (@0x4604). Written here as a C array
// of the same constant strings (clang does not accept an @[] literal
// as a static initializer in plain ObjC).
static NSString *const SPPOpenCarBundleIds[4] = {
    @"vn.vietmap.live", @"com.lumi.GOFA", @"com.waze.iphone",
    @"com.wynauto.wyn"
};
static void SPPHandleOpenCarNotification(int token) {
    uint64_t state = 0;
    notify_get_state(token, &state);
    NSString *bundleId;
    if (state & ~3ULL) {
        bundleId = @"vn.vietmap.live";
    } else {
        bundleId = SPPOpenCarBundleIds[state & 3];
    }
    UIApplication *app = [UIApplication sharedApplication];
    SEL dashSel = NSSelectorFromString(@"_currentDashboard");
    SEL libSel = NSSelectorFromString(@"sharedApplicationLibrary");
    if (![app respondsToSelector:dashSel] ||
        ![app respondsToSelector:libSel]) {
        _OMCLogWrite(@"SpeedBubble",
            @"CarPlay: khong co _currentDashboard / sharedApplicationLibrary");
        return;
    }
    id dashboard = nil;
    if ([app respondsToSelector:dashSel]) {
        dashboard = ((id (*)(id, SEL))objc_msgSend)(app, dashSel);
    } else {
        _OMCMissingSelector(@"SpeedBubble", app, @"_currentDashboard");
    }
    id library = nil;
    if ([app respondsToSelector:libSel]) {
        library = ((id (*)(id, SEL))objc_msgSend)(app, libSel);
    } else {
        _OMCMissingSelector(@"SpeedBubble", app, @"sharedApplicationLibrary");
    }
    SEL infoSel = NSSelectorFromString(@"applicationInfoForBundleIdentifier:");
    id info = nil;
    if ([library respondsToSelector:infoSel]) {
        info = ((id (*)(id, SEL, id))objc_msgSend)(library, infoSel, bundleId);
    } else {
        _OMCMissingSelector(@"SpeedBubble", library,
                            @"applicationInfoForBundleIdentifier:");
    }
    id launchInfo = _OMCCarLaunchInfo(info);
    if (!dashboard || !launchInfo) {
        _OMCLogWrite(@"SpeedBubble",
            [NSString stringWithFormat:
                @"CarPlay: khong mo duoc %@ (dashboard=%@ info=%@)",
                bundleId, dashboard, info]);
        return;
    }
    id eventClass = _OMCCarClass("DBEvent");
    SEL eventSel = NSSelectorFromString(@"eventWithType:context:");
    id event = nil;
    if ([eventClass respondsToSelector:eventSel]) {
        event = ((id (*)(id, SEL, NSInteger, id))objc_msgSend)(
            eventClass, eventSel, 4, launchInfo);
    } else {
        _OMCMissingSelector(@"SpeedBubble", eventClass,
                            @"eventWithType:context:");
    }
    if (event) {
        SEL handleSel = NSSelectorFromString(@"handleEvent:");
        if ([dashboard respondsToSelector:handleSel]) {
            ((void (*)(id, SEL, id))objc_msgSend)(dashboard, handleSel,
                                                  event);
        } else {
            _OMCMissingSelector(@"SpeedBubble", dashboard, @"handleEvent:");
        }
    }
    _OMCLogWrite(@"SpeedBubble",
        [NSString stringWithFormat:@"CarPlay: mo %@", bundleId]);
}

// __init_0 @0x44a8 — VERIFIED: in every process except CarPlayApp this
// constructor does nothing at all. The binary passes a REAL out_token
// to notify_register_dispatch: a zero-initialised stack local
// (@0x4550 str wzr,[sp,#0xc]; @0x456c add x1,sp,#0xc). The value is
// never read back — the handler receives its token as the block's
// argument. (Agent B's draft had the pointer but as a static; agent
// A's draft omitted the argument entirely — that was the arity error.)
__attribute__((constructor))
static void SPPDisplayInitCarPlay(void) {
    if (![[NSBundle mainBundle].bundleIdentifier
             isEqualToString:@"com.apple.CarPlayApp"]) {
        return;
    }
    if (!_OMCCrashGuard(@"speedBubble")) return;
    _OMCLogWrite(@"SpeedBubble",
                 [NSString stringWithFormat:@"loaded into CarPlay"]);
    int token = 0;
    notify_register_dispatch("com.anlai.omnicar/speedbubble.opencar",
        &token, dispatch_get_main_queue(), ^(int t) {
            SPPHandleOpenCarNotification(t);
        });
}

#pragma mark - SpringBoard bootstrap (__init_2 @0xcb30, sub_cc34 @0xcc34)

// sub_d308 @0xd308 — VERIFIED one-liner used by three blocks below.
static void SPPOverspeedCarChanged(void) {
    [[SPPOverspeed shared] carChanged];
}

// sub_d1cc @0xd1cc — VERIFIED: carChanged now, and again after each of
// the constant delays @[ @10, @30 ] seconds (the car display can come
// up late after connect).
static void SPPHandleCarConnected(void) {
    SPPOverspeedCarChanged();
    for (NSNumber *delay in @[ @10, @30 ]) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW,
                                     (int64_t)(delay.doubleValue * 1e9)),
                       dispatch_get_main_queue(), ^{
            SPPOverspeedCarChanged();
        });
    }
}

// The replacement for -[SpringBoard applicationDidFinishLaunching:].
// VERIFIED channel registrations (all handlers on the main queue):
//   speedbubble.speed      -> SPPConsumeSpeedNotification (sub_cec4)
//   speedbubble.demo       -> [[SPPBubble shared] runDemo]      (sub_cf78)
//   speedbubble.resetlayout-> [[SPPBubble shared] resetLayout]  (sub_cfc4)
//   prefschanged           -> [[SPPBubble shared] refresh] +
//                             [[SPPOverspeed shared] reloadPrefs] (sub_d010)
//   car.busy               -> notify_get_state ->
//                             [[SPPBubble shared] setCarBusy:(state != 0)]
//                                                                 (sub_d108)
//   car.connected          -> SPPHandleCarConnected             (sub_d1cc)
//   CarPlayIsConnectedDidChange (NSNotification, main queue)
//                          -> [[SPPBubble shared] refresh]      (sub_d17c)
// plus: SPPPublishSelectedSource() once at launch (sub_d088), and one
// dispatch_after of 3.0 s -> SPPOverspeedCarChanged (sub_d304 -> sub_d308).
// Token storage, exactly as the binary lays it out (phase-2 pass,
// sub_cc34): the car.busy / car.connected out_tokens live in two
// adjacent __bss globals (@0x438a8 / @0x438ac); the four earlier
// registrations use frame locals of SPPAppDidFinishLaunching. No
// token value is ever read back — each handler receives its token as
// the block argument.
static int SPPBusyToken;        // @0x438a8
static int SPPConnectedToken;   // @0x438ac

static void (*SPPOrigAppDidFinishLaunching)(id, SEL, id);
static void SPPAppDidFinishLaunching(id self, SEL _cmd, id application) {
    SPPOrigAppDidFinishLaunching(self, _cmd, application);
    _OMCLogWrite(@"SpeedBubble", @"SpringBoard ready");
    int speedToken = 0, demoToken = 0, resetToken = 0, prefsToken = 0;
    notify_register_dispatch("com.anlai.omnicar/speedbubble.speed",
        &speedToken, dispatch_get_main_queue(), ^(int token) {
            SPPConsumeSpeedNotification(token);
        });
    notify_register_dispatch("com.anlai.omnicar/speedbubble.demo",
        &demoToken, dispatch_get_main_queue(), ^(int token) {
            [[SPPBubble shared] runDemo];
        });
    notify_register_dispatch("com.anlai.omnicar/speedbubble.resetlayout",
        &resetToken, dispatch_get_main_queue(), ^(int token) {
            [[SPPBubble shared] resetLayout];
        });
    notify_register_dispatch("com.anlai.omnicar/prefschanged",
        &prefsToken, dispatch_get_main_queue(), ^(int token) {
            [[SPPBubble shared] refresh];
            [[SPPOverspeed shared] reloadPrefs];
        });
    SPPPublishSelectedSource();
    notify_register_dispatch("com.anlai.omnicar/car.busy",
        &SPPBusyToken, dispatch_get_main_queue(), ^(int token) {
            uint64_t state = 0;
            notify_get_state(token, &state);
            [[SPPBubble shared] setCarBusy:(state != 0)];
        });
    [[NSNotificationCenter defaultCenter]
        addObserverForName:@"CarPlayIsConnectedDidChange"
                    object:nil
                     queue:[NSOperationQueue mainQueue]
                usingBlock:^(NSNotification *note) {
                    [[SPPBubble shared] refresh];
                }];
    notify_register_dispatch("com.anlai.omnicar/car.connected",
        &SPPConnectedToken, dispatch_get_main_queue(), ^(int token) {
            SPPHandleCarConnected();
        });
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 3000000000LL),
                   dispatch_get_main_queue(), ^{
        SPPOverspeedCarChanged();
    });
}

// __init_2 @0xcb30 — VERIFIED (bundle-id gated, no crash guard here).
__attribute__((constructor))
static void SPPDisplayInitSpringBoard(void) {
    if (![[NSBundle mainBundle].bundleIdentifier
             isEqualToString:@"com.apple.springboard"]) {
        return;
    }
    _OMCLogWrite(@"SpeedBubble",
                 [NSString stringWithFormat:@"loaded into SpringBoard"]);
    MSHookMessageEx(objc_getClass("SpringBoard"),
                    @selector(applicationDidFinishLaunching:),
                    (IMP)SPPAppDidFinishLaunching,
                    (IMP *)&SPPOrigAppDidFinishLaunching);
}

#pragma mark - Diag stamp (__init_3 @0x239a0, block invoke @0x23a70)

// __init_3 @0x239a0 — VERIFIED (CLOSURE-2; census items C1/C2; dumps
// disasm/rem2_C1_init3.txt + disasm/rem2_C2_init3_block.txt). The gate
// is the PROCESS NAME (the only processName use in the module): in
// SpringBoard and CarPlay processes the constructor dispatches one
// block to the main queue; everywhere else it does nothing. The block
// (@0x23a70, 400 B) logs the build string and writes the
// diagLoaded.SpeedBubble@<processName> preference (domain
// com.anlai.omnicar) with version/build/date — the same diag-stamp
// pattern CarProbe uses. Constructor name INFERRED.
__attribute__((constructor))
static void SPPDisplayInitDiagStamp(void) {
    NSString *processName = [NSProcessInfo processInfo].processName;
    if (![processName isEqualToString:@"SpringBoard"] &&
        ![processName isEqualToString:@"CarPlay"]) {
        return;
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        _OMCLogWrite(@"SpeedBubble",
            [NSString stringWithFormat:@"build %s (%s) loaded into %@",
                 "fbebb21", "1.0.3", processName]);
        NSString *key = [NSString stringWithFormat:@"%@%s@%@",
                            @"diagLoaded.", "SpeedBubble", processName];
        NSDictionary *info = @{ @"version": @"1.0.3",
                                @"build":   @"fbebb21",
                                @"date":    [NSDate date] };
        CFPreferencesSetAppValue((__bridge CFStringRef)key,
                                 (__bridge CFPropertyListRef)info,
                                 CFSTR("com.anlai.omnicar"));
        CFPreferencesAppSynchronize(CFSTR("com.anlai.omnicar"));
    });
}
