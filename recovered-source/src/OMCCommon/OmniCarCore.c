// OmniCarCore.c — Core-specific machinery of OmniCarCore.dylib (1.0.3).
// Objective-C (ARC). This file holds everything that exists ONLY in Core:
// _OMCTrustedTimeStart and its trusted-time machinery, the two module
// initialisers, the rescue announcer, the car-state/clean pass, the
// omnicar:// URL dispatcher, and the safe-probe helpers they use.
// The 20 shared functions live in OMCCommon.c; Core compiles that file
// WITHOUT -DOMC_MODULE_NAME (its OMCLogWrite does not stamp lastFeature).
// Addresses = OmniCarCore.dylib arm64 slice. See OMCCommon_REPORT.md.

#import "OMCCommon.h"
#import <UIKit/UIKit.h>
#import <notify.h>
#import <dlfcn.h>
#import <objc/message.h>
#import <objc/runtime.h>

#pragma mark - Safe probe helpers — VERIFIED

// sub_6078: zero-argument, object-returning safe message send by name.
static id OMCSafeSend(id obj, NSString *selName) {
    SEL sel = NSSelectorFromString(selName);
    if ([obj respondsToSelector:sel]) {
        return ((id (*)(id, SEL))objc_msgSend)(obj, sel);
    }
    return nil;
}

// sub_60e4: the list of running applications, via SpringBoard's
// SBApplicationController.
/* closed by stub-closure pass: per-app filter tail read line-by-line from
 * the sub_60e4 dump — apps that respond to isRunning are kept iff it
 * returns YES; apps that do not respond are kept iff their processState
 * probe returns non-nil. */
static NSArray *OMCRunningApplications(void) {
    Class sbac = objc_getClass("SBApplicationController");
    id controller = OMCSafeSend((id)sbac, @"sharedInstance");
    id running = OMCSafeSend(controller, @"runningApplications");
    if ([running isKindOfClass:[NSArray class]] &&
        [(NSArray *)running count] > 0) {
        return running;
    }
    NSMutableArray *result = [NSMutableArray array];
    for (id app in OMCSafeSend(controller, @"allApplications")) {
        SEL isRunningSel = NSSelectorFromString(@"isRunning");
        if ([app respondsToSelector:isRunningSel]) {
            if (((BOOL (*)(id, SEL))objc_msgSend)(app, isRunningSel)) {
                [result addObject:app];
            }
        } else if (OMCSafeSend(app, @"processState")) {
            [result addObject:app];
        }
    }
    return result;
}

#pragma mark - Trusted time (Core-only) — VERIFIED

static BOOL gExpiryAnnounced; // bss+0x30: "free period over" already posted

// sub_5f44 (main-queue store block): monotonic — only ever moves the
// stored trusted time forward.
static void OMCStoreTrustedTime(NSDate *date) {
    OMCPrefsSync();
    double fetched = [date timeIntervalSince1970];
    double stored = [OMCPref(@"trustedTime", @0) doubleValue];
    if (fetched > stored) {
        CFPreferencesSetAppValue(CFSTR("trustedTime"),
                                 (CFPropertyListRef)@(fetched),
                                 kOMCPrefsDomain);
        CFPreferencesAppSynchronize(kOMCPrefsDomain);
    }
}

// sub_5d8c (NSURLSession completion): reads the HTTP Date header of a
// HEAD response and, if it parses, stores it on the main queue.
static void OMCTrustedTimeCompletion(NSData *data, NSURLResponse *response,
                                     NSError *error) {
    (void)data; (void)error;
    if ([response isKindOfClass:[NSHTTPURLResponse class]]) {
        id dateStr = [(NSHTTPURLResponse *)response allHeaderFields][@"Date"];
        if ([dateStr isKindOfClass:[NSString class]]) {
            NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
            fmt.locale =
                [NSLocale localeWithLocaleIdentifier:@"en_US_POSIX"];
            fmt.timeZone = [NSTimeZone timeZoneForSecondsFromGMT:0];
            fmt.dateFormat = @"EEE, dd MMM yyyy HH:mm:ss zzz";
            NSDate *date = [fmt dateFromString:dateStr];
            if (date) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    OMCStoreTrustedTime(date);
                });
            }
        }
    }
}

// sub_456c: one fetch round. HEAD https://www.apple.com/ — only the
// response's Date header is used (a trusted clock the user cannot set).
static void OMCFetchTrustedTime(void) {
    NSMutableURLRequest *req = [NSMutableURLRequest
        requestWithURL:[NSURL URLWithString:@"https://www.apple.com/"]];
    [req setHTTPMethod:@"HEAD"];
    [req setTimeoutInterval:15.0];
    [req setCachePolicy:NSURLRequestReloadIgnoringLocalCacheData]; // 1
    [[[NSURLSession sharedSession]
        dataTaskWithRequest:req
          completionHandler:^(NSData *d, NSURLResponse *r, NSError *e) {
              OMCTrustedTimeCompletion(d, r, e);
          }] resume];
}

// sub_464c: 60-second watchdog timer block.
static void OMCExpiryWatchdog(NSTimer *timer) {
    if (gExpiryAnnounced) {
        [timer invalidate];
        return;
    }
    if (OMCExpired()) {
        gExpiryAnnounced = YES;
        OMCLogWrite(@"Core",
            [NSString stringWithFormat:@"free period over (%s): features off",
                                       "2027-04-30"]);
        notify_post("com.anlai.omnicar/prefschanged");
        [timer invalidate];
    }
}

// _OMCTrustedTimeStart @ 0x44a8 — the 21st export, Core-only (absent from
// all five other dylibs; verified by symbol tables + comparison).
void OMCTrustedTimeStart(void) {
    gExpiryAnnounced = OMCExpired();
    if (gExpiryAnnounced) {
        OMCLogWrite(@"Core",
            [NSString stringWithFormat:@"free period over (%s)",
                                       "2027-04-30"]);
    }
    OMCFetchTrustedTime();
    // Both timers are created and deliberately not retained by the caller
    // (the original discards them via an unsafe claim); the run loop owns
    // them. The 6 h block (invoke sub_4648) is a thunk to OMCFetchTrustedTime.
    [NSTimer scheduledTimerWithTimeInterval:21600.0
                                    repeats:YES
                                      block:^(NSTimer *t) {
                                          OMCFetchTrustedTime();
                                      }];
    [NSTimer scheduledTimerWithTimeInterval:60.0
                                    repeats:YES
                                      block:^(NSTimer *t) {
                                          OMCExpiryWatchdog(t);
                                      }];
}

#pragma mark - Rescue announcer — VERIFIED

// sub_488c: runs (in SpringBoard) when "com.anlai.omnicar/rescue" fires.
// The viText arguments below are full Vietnamese UTF-16 constant strings
// in the original binary (__ustring, cfstring flags 0x7d0); earlier
// extraction mis-read them as 1-char C strings. Verified by
// cfstring-struct parse 2026-11-08.
static void OMCRescueAnnounce(void) {
    OMCPrefsSync();
    id features = OMCPref(@"rescueFeatures", nil);
    if (![features isKindOfClass:[NSArray class]] ||
        [(NSArray *)features count] == 0) {
        return;
    }
    NSMutableArray<NSString *> *names = [NSMutableArray array];
    for (NSString *f in (NSArray *)features) {
        NSString *name;
        if ([f isEqualToString:@"splitScreen"]) {
            name = OMCTr(@"Chia màn hình", @"Split Screen");
        } else if ([f isEqualToString:@"startupScreen"]) {
            name = OMCTr(@"Màn hình khởi động", @"Startup Screen");
        } else if ([f isEqualToString:@"speedBubble"]) {
            name = OMCTr(@"Bong bóng tốc độ", @"Speed Bubble");
        } else if ([f isEqualToString:@"appBridge"]) {
            name = OMCTr(@"App trên màn xe", @"Apps on the car screen");
        } else {
            name = f;
        }
        [names addObject:name];
    }
    NSString *joined = [names componentsJoinedByString:@", "];
    NSString *title = OMCTr(@"DuoCar: chế độ cứu", @"DuoCar: rescue mode");
    NSString *body = [NSString
        stringWithFormat:
            OMCTr(@"CarPlay bị sập %d lần liền ngay sau khi cắm, nên DuoCar đã tắt: %@.\n\nVào Cài đặt > DuoCar để bật lại hoặc gửi log cho tác giả.",
                  @"CarPlay crashed %d times in a row right after "
                   "connecting, so DuoCar turned off: %@.\n\nOpen "
                   "Settings > DuoCar to turn it back on or send the "
                   "log to the developer."),
            2, joined];
    // CFUserNotificationDisplayNotice is resolved dynamically (dlsym on
    // RTLD_DEFAULT) so the dylib does not link UserNotifications.
    typedef void (*OMCNoticeFn)(double, uint64_t, const void *, const void *,
                                const void *, CFStringRef, CFStringRef,
                                CFStringRef);
    OMCNoticeFn noticeFn =
        (OMCNoticeFn)dlsym(RTLD_DEFAULT, "CFUserNotificationDisplayNotice");
    OMCLogWrite(@"Core",
        [NSString stringWithFormat:@"thong bao che do cuu: %@ (notice=%d)",
                                   joined, noticeFn != NULL]);
    if (noticeFn) {
        dispatch_async(
            dispatch_get_global_queue(QOS_CLASS_BACKGROUND, 0),
            ^{ // sub_6000 — VERIFIED argument layout
                noticeFn(0.0, 0, NULL, NULL, NULL,
                         (__bridge CFStringRef)title,
                         (__bridge CFStringRef)body, CFSTR("OK"));
            });
    }
}

#pragma mark - Car-state record / clean pass — VERIFIED (stub-closure pass)

// sub_d02c / sub_64f0: one-time resolver for
// BKSTerminateApplicationForReasonAndReportWithDescription, dlopen'ing
// BackBoardServices and dlsym'ing RTLD_DEFAULT.
typedef void (*OMCBKSTerminateFn)(NSString *bundleID, int reason,
                                  BOOL report, NSString *desc);
static OMCBKSTerminateFn gBKSTerminateFn;   // bss+0x40
static dispatch_once_t gBKSTerminateOnce;   // bss+0x48

static void OMCResolveBKSTerminate(void) {
    dispatch_once(&gBKSTerminateOnce, ^{ // block sub_64f0
        dlopen("/System/Library/PrivateFrameworks/"
               "BackBoardServices.framework/BackBoardServices",
               RTLD_LAZY);
        gBKSTerminateFn = (OMCBKSTerminateFn)dlsym(
            RTLD_DEFAULT,
            "BKSTerminateApplicationForReasonAndReportWithDescription");
    });
}

// Termination step of sub_4ca0: BKS (reason 5) when resolved, else
// FBSSystemService (reason 1).
static void OMCTerminateApp(NSString *bid) {
    OMCResolveBKSTerminate();
    if (gBKSTerminateFn) {
        gBKSTerminateFn(bid, 5, NO, @"OmniCar: free memory");
        return;
    }
    id svc = OMCSafeSend((id)objc_getClass("FBSSystemService"),
                         @"sharedService");
    SEL sel = NSSelectorFromString(
        @"terminateApplication:forReason:andReport:withDescription:");
    if ([svc respondsToSelector:sel]) {
        ((void (*)(id, SEL, id, int, BOOL, id))objc_msgSend)(
            svc, sel, bid, 1, NO, @"OmniCar: free memory");
    }
}

// sub_6320: the +2 s recheck block of sub_4ca0 — reports closed apps
// that are still running.
static void OMCVerifyClosedApps(NSArray *closed) {
    NSMutableArray *still = [NSMutableArray array];
    for (id app in OMCRunningApplications()) {
        NSString *bid = OMCSafeSend(app, @"bundleIdentifier");
        if ([closed containsObject:bid]) [still addObject:bid];
    }
    if (still.count > 0) {
        OMCLogWrite(@"Core",
            [NSString stringWithFormat:
                @"don RAM: van con chay sau 2s: %@",
                [still componentsJoinedByString:@", "]]);
    }
}

// sub_4ca0(BOOL clean).
//  - clean == YES: invoked by the "com.anlai.omnicar/cleanram.now"
//    notification; runs the pass unconditionally (log trigger "bam tay").
//  - clean == NO: invoked 8 s after "com.anlai.omnicar/car.connected";
//    gated on OMCEnabled() and the "cleanRamOnConnect" pref, then runs
//    the same pass (log trigger "cam xe").
/* closed by stub-closure pass: the complete pass was read line-by-line
 * from the sub_4ca0 dump — the entry gate above; the classification
 * dictionary (system ids always; media/nav ids and the two user-chosen
 * app lists only when a car is connected OR the pass is automatic, i.e.
 * classify = hasCar || !clean — the csinc gate at 0x4f8c); now-playing
 * and frontmost overrides; the per-app kill decision (unclassified User
 * apps die; System apps die unless tagged "hidden"); the diagCleanRam
 * record; the summary log; and the +2 s recheck block sub_6320. */
static void OMCCarStateRecord(BOOL clean) {
    OMCPrefsSync();
    if (!clean) {
        if (!OMCEnabled()) return;
        if (![OMCPref(@"cleanRamOnConnect", (id)kCFBooleanFalse) boolValue])
            return;
    }
    Class avd = objc_getClass("AVExternalDevice");
    id device = OMCSafeSend((id)avd, @"currentCarPlayExternalDevice");
    BOOL hasCar = (device != nil);
    NSArray *running = OMCRunningApplications();
    NSMutableDictionary *categories = [NSMutableDictionary dictionary];
    for (NSString *bid in @[ @"com.apple.mobilephone", @"com.apple.MobileSMS",
                             @"com.apple.InCallService",
                             @"com.apple.Preferences", @"com.apple.facetime",
                             @"com.anlai.omnicar" ]) {
        categories[bid] = @"system";
    }
    if (hasCar || !clean) {
        for (NSString *bid in @[ @"com.apple.Music", @"com.apple.Maps",
                                 @"com.apple.podcasts", @"vn.vietmap.live",
                                 @"com.lumi.GOFA", @"com.waze.iphone" ]) {
            categories[bid] = @"car";
        }
        for (NSString *prefKey in @[ @"splitScreenCarPlayApps",
                                     @"appBridgeApps" ]) {
            id chosen = OMCPref(prefKey, nil);
            if ([chosen isKindOfClass:[NSArray class]]) {
                for (NSString *bid in (NSArray *)chosen) {
                    categories[bid] = prefKey;
                }
            }
        }
    }
    id media = OMCSafeSend((id)objc_getClass("SBMediaController"),
                           @"sharedInstance");
    id nowPlaying = OMCSafeSend(media, @"nowPlayingApplication");
    NSString *playingBid = OMCSafeSend(nowPlaying, @"bundleIdentifier");
    if (playingBid) categories[playingBid] = @"playing";
    id frontApp = OMCSafeSend([UIApplication sharedApplication],
                              @"_accessibilityFrontMostApplication");
    NSString *frontBid = OMCSafeSend(frontApp, @"bundleIdentifier");
    if (frontBid) categories[frontBid] = @"front";
    NSMutableArray *closed = [NSMutableArray array];
    NSMutableArray *kept = [NSMutableArray array];
    for (id app in running) {
        NSString *bid = OMCSafeSend(app, @"bundleIdentifier");
        if (![bid isKindOfClass:[NSString class]]) continue;
        NSString *category = categories[bid];
        if (category) {
            [kept addObject:[NSString stringWithFormat:@"%@ (%@)", bid,
                                                       category]];
            continue;
        }
        // Unclassified: inspect the app proxy's type and tags.
        id proxy = nil;
        Class lsap = objc_getClass("LSApplicationProxy");
        SEL proxySel =
            NSSelectorFromString(@"applicationProxyForIdentifier:");
        if ([(id)lsap respondsToSelector:proxySel]) {
            proxy = ((id (*)(id, SEL, id))objc_msgSend)((id)lsap, proxySel,
                                                        bid);
        }
        NSString *type = OMCSafeSend(proxy, @"applicationType");
        BOOL kill = NO;
        if ([type isEqualToString:@"User"]) {
            kill = YES;
        } else if ([type isEqualToString:@"System"]) {
            id tags = OMCSafeSend(proxy, @"appTags");
            if ([tags isKindOfClass:[NSArray class]]) {
                kill = ![(NSArray *)tags containsObject:@"hidden"];
            } else {
                kill = YES;
            }
        }
        if (!kill) continue;
        OMCTerminateApp(bid);
        [closed addObject:bid];
    }
    NSDictionary *record = @{
        @"date" : [NSDate date],
        @"closed" : closed,
        @"running" : @(running.count)
    };
    CFPreferencesSetAppValue(CFSTR("diagCleanRam"),
                             (CFPropertyListRef)record, kOMCPrefsDomain);
    OMCPrefsSync();
    OMCLogWrite(@"Core",
        [NSString stringWithFormat:
            @"don RAM (%@, xe=%d): %lu app dang chay, dong %lu: %@ | "
             "giu lai: %@",
            clean ? @"bam tay" : @"cam xe", hasCar,
            (unsigned long)running.count, (unsigned long)closed.count,
            [closed componentsJoinedByString:@", "],
            [kept componentsJoinedByString:@", "]]);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 2000000000LL),
                   dispatch_get_main_queue(), ^{
                       OMCVerifyClosedApps(closed);
                   });
}

#pragma mark - omnicar:// URL dispatcher — VERIFIED (one note)

// sub_5728. VERIFIED routes (host, lowercased):
//   feature: name = pathComponents[1]; action = params[@"on"] lowercased
//            ("toggle" flips; otherwise on/off set) written to the
//            "<name>Enabled" pref as a bool; logs @"URL: %@ = %d".
//            Unknown feature: logs @"URL: khong co tinh nang %@".
//   lite:    pref "liteMode" = params[@"mode"] (lowercased, default @"");
//            logs @"URL: che do nhe = %@".
//   startup: pref "startupScreenStyle" = params[@"style"] (lowercased,
//            default @""); logs @"URL: kieu khoi dong = %@".
// INFERRED: the exact on/toggle branch wiring and the known-feature test
// (implemented here against the four feature ids used by the rescue
// announcer); the query-parameter collection itself (name -> value,
// skipping nil values) is VERIFIED.
static void OMCURLDispatch(NSNotification *notif) {
    id urlStr = notif.userInfo[@"url"];
    if (![urlStr isKindOfClass:[NSString class]]) return;
    NSURL *url = [NSURL URLWithString:urlStr];
    if (![url.scheme isEqualToString:@"omnicar"]) return;
    OMCPrefsSync();
    NSMutableDictionary<NSString *, NSString *> *params =
        [NSMutableDictionary dictionary];
    NSURLComponents *comps =
        [NSURLComponents componentsWithURL:url
                   resolvingAgainstBaseURL:NO];
    for (NSURLQueryItem *item in comps.queryItems) {
        if (item.value) params[item.name] = item.value;
    }
    NSString *host = url.host.lowercaseString;
    if ([host isEqualToString:@"feature"]) {
        NSArray<NSString *> *pc = url.pathComponents;
        if (pc.count < 2) return;
        NSString *name = pc[1];
        static NSSet *known; // INFERRED membership test (see note)
        if (!known) {
            known = [NSSet setWithObjects:@"splitScreen", @"startupScreen",
                                          @"speedBubble", @"appBridge", nil];
        }
        if (![known containsObject:name]) {
            OMCLogWrite(@"Core",
                [NSString stringWithFormat:@"URL: khong co tinh nang %@",
                                           name]);
            return;
        }
        NSString *key = [name stringByAppendingString:@"Enabled"];
        NSString *on = [params[@"on"] lowercaseString];
        BOOL value;
        if ([on isEqualToString:@"toggle"]) {
            value = ![OMCPref(key, (id)kCFBooleanTrue) boolValue];
        } else {
            value = [on isEqualToString:@"on"] ||
                    [on isEqualToString:@"1"] ||
                    [on isEqualToString:@"true"];
        }
        CFPreferencesSetAppValue((CFStringRef)key,
                                 (CFPropertyListRef)@(value),
                                 kOMCPrefsDomain);
        OMCLogWrite(@"Core",
            [NSString stringWithFormat:@"URL: %@ = %d", name, value]);
    } else if ([host isEqualToString:@"lite"]) {
        NSString *mode = [params[@"mode"] lowercaseString] ?: @"";
        CFPreferencesSetAppValue(CFSTR("liteMode"), (CFPropertyListRef)mode,
                                 kOMCPrefsDomain);
        OMCLogWrite(@"Core",
            [NSString stringWithFormat:@"URL: che do nhe = %@", mode]);
    } else if ([host isEqualToString:@"startup"]) {
        NSString *style = [params[@"style"] lowercaseString] ?: @"";
        CFPreferencesSetAppValue(CFSTR("startupScreenStyle"),
                                 (CFPropertyListRef)style, kOMCPrefsDomain);
        OMCLogWrite(@"Core",
            [NSString stringWithFormat:@"URL: kieu khoi dong = %@", style]);
    }
}

#pragma mark - Initialisers — VERIFIED

// __init_offsets[0] = sub_46f0.
__attribute__((constructor)) static void OMCCoreInit(void) {
    @autoreleasepool {
        OMCLogRelayStart();
        OMCLogWrite(@"Core",
            [NSString stringWithFormat:@"loaded into %@ enabled=%d",
                                       [[NSBundle mainBundle]
                                           bundleIdentifier],
                                       OMCEnabled()]);
        OMCTrustedTimeStart();
        static int32_t rescueToken; // bss+0x34
        notify_register_dispatch("com.anlai.omnicar/rescue", &rescueToken,
                                 dispatch_get_main_queue(),
                                 ^(int token) { OMCRescueAnnounce(); });
        static int32_t carToken; // bss+0x38
        notify_register_dispatch(
            "com.anlai.omnicar/car.connected", &carToken,
            dispatch_get_main_queue(), ^(int token) { // sub_4c64
                dispatch_after(
                    dispatch_time(DISPATCH_TIME_NOW, 8000000000LL),
                    dispatch_get_main_queue(),
                    ^{ OMCCarStateRecord(NO); }); // sub_4c98
            });
        // The distributed center class is fetched with objc_getClass in
        // the original (no direct link).
        id center = [objc_getClass("NSDistributedNotificationCenter")
            defaultCenter];
        [center addObserverForName:@"com.anlai.omnicar/url"
                            object:nil
                             queue:[NSOperationQueue mainQueue]
                        usingBlock:^(NSNotification *n) {
                            OMCURLDispatch(n);
                        }];
        static int32_t cleanToken; // bss+0x3C
        notify_register_dispatch(
            "com.anlai.omnicar/cleanram.now", &cleanToken,
            dispatch_get_main_queue(),
            ^(int token) { OMCCarStateRecord(YES); }); // sub_5d84
    }
}

// __init_offsets[1] = sub_900c (+ block sub_90dc): build stamp, recorded
// as the "diagLoaded.Core@<process>" pref in SpringBoard / CarPlay only.
__attribute__((constructor)) static void OMCCoreDiagInit(void) {
    NSString *proc = [[NSProcessInfo processInfo] processName];
    if ([proc isEqualToString:@"SpringBoard"] ||
        [proc isEqualToString:@"CarPlay"]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            OMCLogWrite(@"Core",
                [NSString stringWithFormat:@"build %s (%s) loaded into %@",
                                           "fbebb21", "1.0.3", proc]);
            NSString *key = [NSString stringWithFormat:@"%@%s@%@",
                                                       @"diagLoaded.",
                                                       "Core", proc];
            CFPreferencesSetAppValue(
                (CFStringRef)key,
                (CFPropertyListRef)@{
                    @"version" : @"1.0.3",
                    @"build" : @"fbebb21",
                    @"date" : [NSDate date]
                },
                kOMCPrefsDomain);
            OMCPrefsSync();
        });
    }
}
