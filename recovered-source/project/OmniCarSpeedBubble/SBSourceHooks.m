// SBSourceHooks.m — SpeedBubble SOURCE-APP side (agent B, wave 2.5)
// The source-app constructor and the hook replacements it installs.
// OmniCarSpeedBubble.dylib (arm64). VERIFIED from disassembly unless
// marked. PREMISE CORRECTION (proven by xref): the CLLocationManager
// hooks use MSHookMessageEx, NOT MSHookFunction; MSHookFunction is used
// only for UIAccessibilityIsSwitchControlRunning, which is resolved with
// dlsym(RTLD_DEFAULT, ...) — not dlopen.

#import "SBSourceGlobals.h"
#import "SPPSpeedGPS.h"
#import <CoreLocation/CoreLocation.h>
#import <UIKit/UIKit.h>
#import <dispatch/dispatch.h>
#import <dlfcn.h>
#import <objc/runtime.h>
#import <substrate.h>

// SBFlutter.m
extern id SPPWrapHandler(id channel, id handler); // sub_67e0
// SBScan.m
extern void SPPStartScan(void);                   // sub_600c (block body)
// SBPublish.m
extern void SPPPublishSpeed(int speed, int limit); // sub_5498
extern BOOL SPPSourceIsActive(void);               // sub_65a8

#pragma mark - CLLocationManager hooks (sub_63f0 / sub_64d8)

// sub_64d8 — VERIFIED: block body. Ignores the dylib's OWN manager; a
// "start" from the app is only honoured while this host is the chosen
// speed source (SPPSourceIsActive).
static void SPPHandleAppManager(CLLocationManager *manager, BOOL running) {
    SPPSpeedGPS *gps = [SPPSpeedGPS shared];
    if (manager == gps.mgr) {
        return;
    }
    if (running && !SPPSourceIsActive()) {
        return;
    }
    [gps appManager:manager running:running];
}

// sub_63f0 — VERIFIED: run SPPHandleAppManager on the main queue
// (inline when already on the main thread).
static void SPPRouteAppManager(CLLocationManager *manager, BOOL running) {
    if ([NSThread isMainThread]) {
        SPPHandleAppManager(manager, running);
    } else {
        dispatch_async(dispatch_get_main_queue(), ^{
            SPPHandleAppManager(manager, running);
        });
    }
}

// sub_5fac — VERIFIED: replacement for -[CLLocationManager
// startUpdatingLocation]. Original IMP runs FIRST, then the routing.
static void SPPCLStartUpdatingLocation(CLLocationManager *self, SEL _cmd) {
    ((void (*)(id, SEL))SPPOrigCLStartUpdatingLocation)(self, _cmd);
    SPPRouteAppManager(self, YES);
}

// sub_5fdc — VERIFIED: replacement for -[CLLocationManager
// stopUpdatingLocation]. Same shape.
static void SPPCLStopUpdatingLocation(CLLocationManager *self, SEL _cmd) {
    ((void (*)(id, SEL))SPPOrigCLStopUpdatingLocation)(self, _cmd);
    SPPRouteAppManager(self, NO);
}

#pragma mark - FlutterEngine hooks

// Binary message handler type used by FlutterEngine (dynamic class; the
// dylib links no Flutter headers).
typedef void (^SPPFlutterBinaryMessageHandler)(NSData *message,
                                               void (^reply)(NSData *));

// sub_6638 — VERIFIED: replacement for
// -[FlutterEngine setMessageHandlerOnChannel:binaryMessageHandler:taskQueue:]
static void SPPFlutterSetHandlerTaskQueue(id self, SEL _cmd, id channel,
                                          id handler, id taskQueue) {
    handler = SPPWrapHandler(channel, handler);
    ((void (*)(id, SEL, id, id, id))SPPOrigFlutterTaskQueue)(
        self, _cmd, channel, handler, taskQueue);
}

// sub_671c — VERIFIED: replacement for
// -[FlutterEngine setMessageHandlerOnChannel:binaryMessageHandler:]
static void SPPFlutterSetHandlerPlain(id self, SEL _cmd, id channel,
                                      id handler) {
    handler = SPPWrapHandler(channel, handler);
    ((void (*)(id, SEL, id, id))SPPOrigFlutterPlain)(self, _cmd, channel,
                                                     handler);
}

#pragma mark - UIAccessibility hook

// sub_79ac — VERIFIED: 8-byte replacement, the original is never called.
// Purpose (INFERRED from the surrounding machinery): reporting Switch
// Control as running makes the host app expose its interface text to the
// accessibility tree, which the screen scan (SBScan.m) then reads.
static BOOL SPPSwitchControlRunningHook(void) {
    return YES;
}

// sub_79b4 — VERIFIED: kick block fired at +2 s, +6 s and +12 s after the
// hook lands (the [2.0, 6.0, 12.0] constant array x 1e9 ns in
// dispatch_time — that multiplication is seconds -> nanoseconds).
static void SPPSwitchControlKick(void) {
    [[NSNotificationCenter defaultCenter]
        postNotificationName:UIAccessibilitySwitchControlStatusDidChangeNotification
                      object:nil];
}

#pragma mark - Scene-change republish

// sub_7a10 — VERIFIED: global block body; republishes the last values.
static void SPPRepublishLast(void) {
    SPPPublishSpeed(SPPLastPublishedSpeed, SPPLastPublishedLimit);
}

// sub_7a24 — VERIFIED: observer block body for the four UIScene
// notifications below: republish immediately (async on main) and again
// after 0.5 s (0x1dcd6500 ns).
static void SPPSceneChangeObserver(NSNotification *note) {
    dispatch_async(dispatch_get_main_queue(), ^{
        SPPRepublishLast();
    });
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 500000000LL),
                   dispatch_get_main_queue(), ^{
        SPPRepublishLast();
    });
}

#pragma mark - Constructor (__init_1 @0x5950)

// VERIFIED, step by step from the disassembly:
//  1. Host detection = index of the process bundle id in the constant
//     array [vn.vietmap.live, com.lumi.GOFA, com.waze.iphone,
//     com.wynauto.wyn]. NSNotFound -> return immediately: the dylib
//     installs NOTHING in SpringBoard/CarPlayApp/any other process, and
//     SPPHostIndex keeps its default 0. There is no feature gate and no
//     crash-guard call on this constructor (contrast __init_0).
//  2. CLLocationManager hooks — identical for all four hosts.
//  3. FlutterEngine hooks — only when a FlutterEngine class exists at
//     runtime (Vietmap in practice); the taskQueue variant is preferred
//     when the class implements it.
//  4. UIAccessibilityIsSwitchControlRunning MSHookFunction + kicks.
//  5. UIScene lifecycle observers -> republish.
//  6. Scan timer starts 4 s later (dispatch_after).
__attribute__((constructor))
static void SPPInit1(void) {
    NSArray *bundleIDs = @[ @"vn.vietmap.live", @"com.lumi.GOFA",
                            @"com.waze.iphone", @"com.wynauto.wyn" ];
    NSArray *names = @[ @"Vietmap", @"GOFA", @"Waze", @"Wyn" ];

    NSString *ownID = [[NSBundle mainBundle] bundleIdentifier];
    NSUInteger index = [bundleIDs indexOfObject:ownID];
    if (index == NSNotFound) {
        return;
    }
    SPPHostIndex = (int)index;
    SPPLog(@"loaded into %@ (%@)", names[index], bundleIDs[index]);

    MSHookMessageEx([CLLocationManager class],
                    @selector(startUpdatingLocation),
                    (IMP)SPPCLStartUpdatingLocation,
                    &SPPOrigCLStartUpdatingLocation);
    MSHookMessageEx([CLLocationManager class],
                    @selector(stopUpdatingLocation),
                    (IMP)SPPCLStopUpdatingLocation,
                    &SPPOrigCLStopUpdatingLocation);

    Class flutterEngine = objc_getClass("FlutterEngine");
    if (!flutterEngine) {
        SPPLog(@"kenh: app khong dung Flutter");
    } else if (class_getInstanceMethod(
                   flutterEngine,
                   @selector(setMessageHandlerOnChannel:
                                 binaryMessageHandler:taskQueue:))) {
        MSHookMessageEx(
            flutterEngine,
            @selector(setMessageHandlerOnChannel:
                          binaryMessageHandler:taskQueue:),
            (IMP)SPPFlutterSetHandlerTaskQueue, &SPPOrigFlutterTaskQueue);
        SPPLog(@"kenh: da hook FlutterEngine (taskQueue)");
    } else {
        MSHookMessageEx(flutterEngine,
                        @selector(setMessageHandlerOnChannel:
                                      binaryMessageHandler:),
                        (IMP)SPPFlutterSetHandlerPlain, &SPPOrigFlutterPlain);
        SPPLog(@"kenh: da hook FlutterEngine");
    }

    void *switchControlFn =
        dlsym(RTLD_DEFAULT, "UIAccessibilityIsSwitchControlRunning");
    if (switchControlFn) {
        MSHookFunction(switchControlFn, (void *)SPPSwitchControlRunningHook,
                       (void **)&SPPOrigSwitchControlRunning);
        static const double delays[] = {2.0, 6.0, 12.0};
        for (int i = 0; i < 3; i++) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW,
                                          (int64_t)(delays[i] * 1e9)),
                           dispatch_get_main_queue(), ^{
                               SPPSwitchControlKick();
                           });
        }
    } else {
        SPPLog(@"speed scan: khong tim thay UIAccessibilityIsSwitchControlRunning");
    }

    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    NSOperationQueue *mainQueue = [NSOperationQueue mainQueue];
    for (NSString *name in @[
             UISceneDidActivateNotification, UISceneWillDeactivateNotification,
             UISceneDidEnterBackgroundNotification,
             UISceneWillEnterForegroundNotification
         ]) {
        [center addObserverForName:name
                            object:nil
                             queue:mainQueue
                        usingBlock:^(NSNotification *note) {
                            SPPSceneChangeObserver(note);
                        }];
    }

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 4000000000LL),
                   dispatch_get_main_queue(), ^{
                       SPPStartScan();
                   });
}
