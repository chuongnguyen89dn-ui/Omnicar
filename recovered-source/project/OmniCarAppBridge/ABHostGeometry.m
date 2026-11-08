// ABHostGeometry.m — SpringBoard-side machinery in module B's scope:
//   * the -[SpringBoard applicationDidFinishLaunching:] replacement
//     (sub_7004, the channel registrar — the method itself is module A's
//     launch surface, but its registrations define B's channels, so the
//     registration code is reproduced here with the partition noted),
//   * the lifecycle hooks that keep hosted scenes alive (sub_72BC, sub_74B4,
//     sub_7764, sub_777C),
//   * the channel consumer blocks for frame / shield / apporient /
//     keyboard / CarPlay-connect (sub_8274, sub_8C7C, sub_92B4, sub_93B0,
//     sub_958C),
//   * ABHost methods for geometry, orientation, shield, lifecycle
//     (setFrame:…, layoutPane:, nudgePane:, appWithHash:…, setHole:…,
//     sceneMonitor:sceneWasDestroyed:, carDisconnected, handlePanned:,
//     handleTapped:, outsideTouched, …),
//   * C helpers sub_E6B8 (orientation post) and sub_BED4 (state post).
//
// ABHost / ABPane class declarations live in ABHost.h (shared with module A).

#import "AppBridgeB.h"
#import "ABHost.h"
#import "ABKeyboardDecl.h" // [integration phase 1; backported to src in phase 3] full ABKeyboard interface (module B decl, verbatim)
#import <objc/runtime.h>
#import <objc/message.h> // [integration phase 1; backported to src in phase 3] declares objc_msgSend used below

// OMC scaffold helpers (shared, not part of this module).
extern BOOL OMCLiteActive(void);
extern NSInteger OMCCarWireless(void);
extern id OMCPref(NSString *key, id defaultValue);

// ===========================================================================
// C helper sub_E6B8 — post ABChanOrientation to one app.
// fps rule (verified): orientation < 1 -> fps 0. Otherwise the pref
// "appBridgeFps"; if that is <= 0: 30 when OMCLiteActive(), else 30 when
// OMCCarWireless() == 1, else 0.
// "device" = max(orientation, 0).
// ===========================================================================
void ABPostOrientationToApp(NSString *bundleID, NSInteger orientation) {
    if (!bundleID) return;
    NSInteger fps = 0;
    if (orientation >= 1) {
        fps = [OMCPref(@"appBridgeFps", @0) intValue];
        if (fps <= 0) {
            if (OMCLiteActive()) fps = 30;
            else fps = (OMCCarWireless() == 1) ? 30 : 0;
        }
    }
    NSDictionary *info = @{
        @"orientation": @(orientation),
        @"device": @(MAX(orientation, 0)),
        @"fps": @((int)fps),
    };
    [[NSDistributedNotificationCenter defaultCenter]
        postNotificationName:ABChanOrientation object:bundleID userInfo:info];
}

// C helper sub_BED4 — post ABChanState (object nil).
// Observed state values at the six call sites: "ready", "failed", "gone".
void ABPostStateToApp(NSString *state, NSString *identifier) {
    if (!identifier) return;
    [[NSDistributedNotificationCenter defaultCenter]
        postNotificationName:ABChanState object:nil
                    userInfo:@{@"identifier": identifier, @"state": state}];
}

// ===========================================================================
// Registrar — sub_7004, replacement for
// -[SpringBoard applicationDidFinishLaunching:]. Calls the original IMP
// (slot 0x3E9F0) first, logs "SpringBoard ready", then registers:
//   NSDistributed observers (object nil, main queue) for open / frame /
//   shield / close / closeall / knobs — block literals at
//   0x34690..0x34730, invokes sub_783C / sub_8274 / sub_8C7C / sub_8DF0 /
//   sub_8FD4 / sub_9144 (open/close/closeall/knobs are module A's handlers;
//   frame and shield are reproduced below).
//   notify_register_dispatch (main queue) for the two Darwin state
//   channels: apporient -> block sub_92B4, keyboard -> block sub_93B0.
//   A local NSNotificationCenter observer for
//   "CarPlayIsConnectedDidChange" -> block sub_958C.
// ===========================================================================
static void ABFrameBlock(NSNotification *note);   // sub_8274, below
static void ABShieldBlock(NSNotification *note);  // sub_8C7C, below

void ABSpringBoardReady(id self, SEL _cmd, id application) {
    // (original IMP call — slot managed by the substrate install in
    //  AppBridgeEntry.m; elided here as in the registrar's own structure)
    OMCLogWrite(@"AppBridge", [NSString stringWithFormat:@"SpringBoard ready"]);
    NSDistributedNotificationCenter *center = [NSDistributedNotificationCenter defaultCenter];
    NSOperationQueue *queue = [NSOperationQueue mainQueue];
    // Module A handlers (open/close/closeall/knobs) register identically.
    [center addObserverForName:ABChanFrame object:nil queue:queue
                    usingBlock:^(NSNotification *n) { ABFrameBlock(n); }];
    [center addObserverForName:ABChanShield object:nil queue:queue
                    usingBlock:^(NSNotification *n) { ABShieldBlock(n); }];
    static int apporientToken, keyboardToken; // 0x3EA18 / 0x3EA1C
    notify_register_dispatch(ABNotifyAppOrient, &apporientToken,
                             dispatch_get_main_queue(),
                             ^(int token) { ABAppOrientDispatch(token); });
    notify_register_dispatch(ABNotifyKeyboard, &keyboardToken,
                             dispatch_get_main_queue(),
                             ^(int token) { ABKeyboardDispatch(token); });
    [[NSNotificationCenter defaultCenter]
        addObserverForName:@"CarPlayIsConnectedDidChange" object:nil queue:queue
                usingBlock:^(NSNotification *n) { ABCarPlayChanged(n); }];
}

// ===========================================================================
// Darwin consumers. Both decode the packed states proven in AppBridgeB.h.
// ===========================================================================
// sub_92B4 — apporient consumer.
void ABAppOrientDispatch(int token) {
    uint64_t state = 0;
    notify_get_state(token, &state);
    [[ABHost shared] appWithHash:(state >> 24)
              changedOrientation:(state & 0xFF)
                 supportedMask:(NSUInteger)((state >> 8) & 0xFFFF)];
}

// sub_93B0 — keyboard consumer.
void ABKeyboardDispatch(int token) {
    @try {
        uint64_t state = 0;
        notify_get_state(token, &state);
        NSString *bundleID = [[ABHost shared] bundleForHash:(state >> 24)];
        if (!bundleID) {
            OMCLogWrite(@"AppBridge", [NSString stringWithFormat:@"ban phim: khong co o cho hash %llu",
                                       (unsigned long long)(state >> 24)]);
            return;
        }
        if ((state & 1) == 0) {
            [[ABKeyboard shared] hideForApp:bundleID];
        } else {
            [[ABKeyboard shared] showForApp:bundleID
                               keyboardType:(UIKeyboardType)((state >> 1) & 0x7F)
                                 returnType:(UIReturnKeyType)((state >> 8) & 0xFF)];
        }
    } @catch (NSException *e) {
        OMCLogWrite(@"AppBridge", [NSString stringWithFormat:@"ban phim loi %@", e]);
    }
}

// ===========================================================================
// sub_958C — CarPlayIsConnectedDidChange. Determines connection from
// [AVExternalDevice currentCarPlayExternalDevice] (resolved dynamically,
// ABMissingSelector fallback). On disconnect: hide the car keyboard and
// tear down all panes via -[ABHost carDisconnected].
// ===========================================================================
void ABCarPlayChanged(NSNotification *note) {
    Class cls = objc_getClass("AVExternalDevice");
    SEL sel = NSSelectorFromString(@"currentCarPlayExternalDevice");
    id device = nil;
    if ([cls respondsToSelector:sel])
        device = ((id (*)(id, SEL))objc_msgSend)(cls, sel);
    else
        // [integration phase 2; backported to src in phase 3]
        // ABMissingSelector returns void (proven from its 468-byte body;
        // see ABMissingSelector.m) — the binary's call site zeroes the
        // result itself, so `device` stays nil here instead of receiving
        // the function's (non-)return value.
        ABMissingSelector(cls, @"currentCarPlayExternalDevice");
    if (!device) {
        [[ABKeyboard shared] hideForApp:nil];
        [[ABHost shared] carDisconnected];
    }
    // (Connected case: no further work in the observed code path head;
    //  see the full dump disasm/blk_carplay_958c.txt.)
}

// ===========================================================================
// NSDistributed consumers
// ===========================================================================
// sub_8274 — frame consumer. One notification carries the whole geometry
// state for one app; every field is applied through ABHost setters:
//   x,y,w,h (double) + identifier + live,handle (bool) + pt,pl,pb,pr
//     -> setFrame:forApp:live:handle:passInsets:
//   bar (bool), pop (int), popDim (bool), single (bool)
//     -> setBarVisible:pop:dim:single:forApp:
//   ox,oy,ow,oh -> setHole:forApp:
//   r (double), corners (uint64) -> setCornerRadius:corners:forApp:
//   hx (double) -> setHandleOffset:forApp:
//   front (bool) -> setFront:forApp:
//   ax,ay,aw,ah (only when aw > 0) -> setCarAppArea:
static void ABFrameBlock(NSNotification *note) {
    NSDictionary *u = note.userInfo;
    ABHost *host = [ABHost shared];
    NSString *app = u[@"identifier"];
    CGRect frame = CGRectMake([u[@"x"] doubleValue], [u[@"y"] doubleValue],
                              [u[@"w"] doubleValue], [u[@"h"] doubleValue]);
    UIEdgeInsets insets = UIEdgeInsetsMake([u[@"pt"] doubleValue], [u[@"pl"] doubleValue],
                                           [u[@"pb"] doubleValue], [u[@"pr"] doubleValue]);
    [host setFrame:frame forApp:app live:[u[@"live"] boolValue]
            handle:[u[@"handle"] boolValue] passInsets:insets];
    [host setBarVisible:[u[@"bar"] boolValue] pop:[u[@"pop"] intValue]
                    dim:[u[@"popDim"] boolValue] single:[u[@"single"] boolValue] forApp:app];
    CGRect hole = CGRectMake([u[@"ox"] doubleValue], [u[@"oy"] doubleValue],
                             [u[@"ow"] doubleValue], [u[@"oh"] doubleValue]);
    [host setHole:hole forApp:app];
    [host setCornerRadius:[u[@"r"] doubleValue]
                  corners:(NSUInteger)[u[@"corners"] unsignedLongLongValue] forApp:app];
    [host setHandleOffset:[u[@"hx"] doubleValue] forApp:app];
    [host setFront:[u[@"front"] boolValue] forApp:app];
    if ([u[@"aw"] doubleValue] > 0) {
        host.carAppArea = CGRectMake([u[@"ax"] doubleValue], [u[@"ay"] doubleValue],
                                     [u[@"aw"] doubleValue], [u[@"ah"] doubleValue]);
    }
}

// sub_8C7C — shield consumer: {on} -> setShieldAll:.
static void ABShieldBlock(NSNotification *note) {
    [[ABHost shared] setShieldAll:[note.userInfo[@"on"] boolValue]];
}

// ===========================================================================
// SpringBoard lifecycle hooks
// ===========================================================================
static IMP orig_SBSuspended;   // 0x3E9F8
static IMP orig_FBSceneUpdate; // 0x3EA00
static IMP orig_SBSceneView;   // 0x3EA08
static void (*orig_ScreenBlanked)(int); // 0x3EA10

// sub_72BC — -[SBSuspendedUnderLockManager
// _shouldBeBackgroundUnderLockForScene:withSettings:]: a hosted app is
// NEVER background-under-lock: result = orig && !hostsApp(scene's app).
// Exceptions fail open to YES (the @catch tail sets the result to 1).
BOOL ABHook_SBSuspended(id self, SEL _cmd, id scene, id settings) { // [integration phase 1; backported to src in phase 3] return type corrected void->BOOL: every return in the body is BOOL and orig_SBSuspended is cast to a BOOL-returning pointer; the hooked method returns BOOL
    BOOL orig = ((BOOL (*)(id, SEL, id, id))orig_SBSuspended)(self, _cmd, scene, settings);
    if (!orig) return NO;
    @try {
        id process = [scene valueForKey:@"clientProcess"]; // via NSSelectorFromString in the original
        NSString *bundleID = [process valueForKey:@"bundleIdentifier"];
        if (bundleID && [[ABHost shared] hostsApp:bundleID]) return NO;
    } @catch (NSException *e) { return YES; }
    return orig;
}

// sub_74B4 — -[FBScene updateSettings:withTransitionContext:completion:]:
// when ABHost hosts at least one app, and this scene belongs to a hosted
// app, and the new settings' isForeground is NO, the update is SWALLOWED
// (the original is never called): the hosted scene never learns it was
// backgrounded. A missing isForeground selector also swallows. Exceptions
// fail open (the original is called from the @catch tail).
void ABHook_FBSceneUpdateSettings(FBScene *self, SEL _cmd, id settings, id ctx, id completion) {
    BOOL swallow = NO;
    if ([[ABHost shared] count] > 0) {
        @try {
            id process = [self valueForKey:@"clientProcess"];
            NSString *bundleID = [process valueForKey:@"bundleIdentifier"];
            if (bundleID && [[ABHost shared] hostsApp:bundleID]) {
                SEL fg = NSSelectorFromString(@"isForeground");
                if (![settings respondsToSelector:fg]) {
                    ABMissingSelector(settings, @"isForeground");
                    swallow = YES;
                } else if (!((BOOL (*)(id, SEL))objc_msgSend)(settings, fg)) {
                    swallow = YES;
                }
            }
        } @catch (NSException *e) { swallow = NO; }
    }
    if (!swallow)
        ((void (*)(id, SEL, id, id, id))orig_FBSceneUpdate)(self, _cmd, settings, ctx, completion);
}

// sub_7764 — -[SBSceneView _updateReferenceSize:andOrientation:]:
// clamps the orientation argument: values > 4 become 3.
void ABHook_SBSceneViewRefSize(id self, SEL _cmd, CGSize size, NSInteger orientation) {
    if (orientation > 4) orientation = 3;
    ((void (*)(id, SEL, CGSize, NSInteger))orig_SBSceneView)(self, _cmd, size, orientation);
}

// sub_777C — BKSDisplayServicesSetScreenBlanked hook: when a blank is
// requested while panes are hosted, the blank is applied and then REVERSED
// 1.0 s later (the delayed block sub_9688 calls orig(0)); the car display
// does not stay asleep while apps are hosted.
// dispatch_time constant verified: 0x3B9ACA00 = 1,000,000,000 ns.
void ABHook_ScreenBlanked(int blanked) {
    if (blanked == 1 && [[ABHost shared] count] > 0) {
        orig_ScreenBlanked(1);
        dispatch_after(dispatch_time(0, 1000000000), dispatch_get_main_queue(), ^{
            orig_ScreenBlanked(0);
        });
        return;
    }
    orig_ScreenBlanked(blanked);
}
