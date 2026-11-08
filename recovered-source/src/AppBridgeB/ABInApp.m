// ABInApp.m — everything that runs INSIDE a hosted app process.
// Reconstructed from: ctor sub_44A8, orientation block sub_4728, hooks
// sub_50A8..sub_58C0, helpers sub_5C64..sub_6D50, publishers sub_67FC /
// sub_6AD4, key receiver block sub_5908, deferred blocks sub_5FF0/sub_6028.
//
// Data flow (all proven from this binary):
//   * Host (CarPlay-side) posts NSDistributed "appbridge.orientation"
//     {orientation, device, fps} addressed to this app's bundleID.
//   * The block sub_4728 installs the in-app hooks LAZILY on first receipt,
//     stores the forced orientation, forces the key window's rotatable view
//     if the app's supported mask allows it, arms the fake-orientation
//     machinery, and schedules fake UIDeviceOrientationDidChange re-posts
//     at +0.3s / +1.5s / +4.0s (constant array at 0x393F0, __objc_doubleobj
//     values read verbatim: 0.3, 1.5, 4.0).
//   * The app reports its OWN orientation wishes back to SpringBoard over
//     the Darwin channel "appbridge.apporient" (debounced 0.25 s), and its
//     keyboard focus over "appbridge.keyboard".
//   * While hosted, the system keyboard is suppressed by giving the first
//     responder a zero-size blank inputView; the car keyboard (ABKeyboard,
//     SpringBoard side) sends key actions back over the NSDistributed
//     "appbridge.key" channel, applied here to the tracked responder.

#import "AppBridgeB.h"
#import <objc/runtime.h>
#import <substrate.h>

// [integration phase 1; backported to src in phase 3] forward
// declarations: the in-app hook replacements below are installed near
// the top of this file but defined (static) further down it; signatures
// copied verbatim from their definitions.
static void ABHook_UIWindowSetRotatable(UIWindow *self, SEL _cmd, NSInteger orientation, double duration, BOOL force);
static CADisplayLink *ABHook_CADisplayLinkNew(id self, SEL _cmd, id target, SEL selector);
static void ABHook_CADisplayLinkSetFPS(CADisplayLink *self, SEL _cmd, NSInteger fps);
static void ABHook_CADisplayLinkSetRange(CADisplayLink *self, SEL _cmd, CAFrameRateRange range);
static BOOL ABHook_TFBecome(UITextField *self, SEL _cmd);
static BOOL ABHook_TFResign(UITextField *self, SEL _cmd);
static BOOL ABHook_TVBecome(UITextView *self, SEL _cmd);
static BOOL ABHook_TVResign(UITextView *self, SEL _cmd);
static void ABHook_UIDeviceSetOrientation(UIDevice *self, SEL _cmd, NSInteger orientation, BOOL animated);
static NSInteger ABHook_UIDeviceOrientation(UIDevice *self, SEL _cmd);
static void ABHook_UIDeviceBeginGen(UIDevice *self, SEL _cmd);
static void ABHook_SceneRequestGeometry(UIWindowScene *self, SEL _cmd, id preferences, id errorHandler);
static void ABHook_VCSetNeedsUpdate(UIViewController *self, SEL _cmd);
static void ABHook_VCAttemptRotation(id self, SEL _cmd);

NSInteger ABForcedOrientation = -1;  // 0x3E7D0 (stored as int32 in the original)
int64_t   ABAppOrientation    = 0;   // 0x3E9C8
NSInteger ABDeviceFake       = 0;   // 0x3E9D0 (int32)
NSInteger ABFPSLimit         = 0;   // 0x3E9B0 (int32)
__weak id ABCurrentResponder = nil; // 0x3E930

static BOOL ABHooksInstalled = NO;  // 0x3E938 (byte)
static int ABKeyboardToken = 0;     // 0x3E9E8
static int ABAppOrientToken = 0;    // 0x3E9E0
static id ABPendingPublishBlock = nil; // 0x3E9D8 (dispatch_block_t, retained)

// Original IMP slots (0x3E940..0x3E9A8), in install order.
static IMP orig_CADisplayLink_new, orig_CADisplayLink_setFPS, orig_CADisplayLink_setRange;
static IMP orig_UIWindow_setRotatable;
static IMP orig_UIDevice_beginGen, orig_UIDevice_setOrientation, orig_UIDevice_orientation;
static IMP orig_TF_become, orig_TF_resign, orig_TV_become, orig_TV_resign;
static IMP orig_Scene_reqGeometry, orig_VC_setNeedsUpdate, orig_VC_attemptRotation;

// ---------------------------------------------------------------------------
// Forward declarations
// ---------------------------------------------------------------------------
static void ABPublishAppOrientation(int64_t orientationField); // sub_67FC
static void ABScheduleAppOrientationPublish(int64_t field);    // sub_6750
static void ABKeyboardPublish(BOOL shown, id traits);          // sub_6AD4
static NSUInteger ABSupportedOrientationMask(void);            // sub_612C
static UIWindow *ABKeyWindow(void);                            // sub_61D0
static NSUInteger ABMaskFromViewController(UIViewController *vc, NSInteger depth); // sub_6498
static NSUInteger ABMaskFromWindow(UIWindow *window);          // sub_5EC0
static void ABAfterDelay(NSTimeInterval seconds);              // sub_5FF0 (+ block sub_6028)
static void ABApplyFPSLimit(id displayLink);                   // sub_5CBC
static NSHashTable *ABDisplayLinks(void);                      // sub_5C64 (weak hash table in the original) — // [integration phase 1; backported to src in phase 3] forward-decl return type corrected NSMutableSet*->NSHashTable* to match this file's own definition/body below

// ===========================================================================
// Orientation block — sub_4728. Registered by the ctor for
// ABChanOrientation; runs on the main queue. x0 = block, x1 = notification.
// The one-time hook installation and the per-notification work are in the
// SAME function in the original.
// ===========================================================================
static void ABOrientationBlock(NSNotification *note) {
    if (!ABHooksInstalled) {
        ABHooksInstalled = YES;
        // CADisplayLink hooks: the class method is hooked on the
        // METACLASS; the two FPS setters are instance methods and are
        // hooked on the class itself. (Original sub_4728 keeps the
        // objc_getClass result in x21, applies object_getClass ONLY
        // for +displayLinkWithTarget:selector:, and passes x21
        // directly for both setters — installer_app_4728.txt
        // @0x4780-0x47ec.) [hotfix: setters were on the metaclass, so
        // the hooks never landed and their orig slots stayed NULL
        // while ABApplyFPSLimit calls them.]
        MSHookMessageEx(object_getClass(objc_getClass("CADisplayLink")),
                        @selector(displayLinkWithTarget:selector:),
                        (IMP)ABHook_CADisplayLinkNew, &orig_CADisplayLink_new);
        MSHookMessageEx(objc_getClass("CADisplayLink"),
                        @selector(setPreferredFramesPerSecond:),
                        (IMP)ABHook_CADisplayLinkSetFPS, &orig_CADisplayLink_setFPS);
        MSHookMessageEx(objc_getClass("CADisplayLink"),
                        @selector(setPreferredFrameRateRange:),
                        (IMP)ABHook_CADisplayLinkSetRange, &orig_CADisplayLink_setRange);
        MSHookMessageEx(objc_getClass("UIWindow"),
                        NSSelectorFromString(@"_setRotatableViewOrientation:duration:force:"),
                        (IMP)ABHook_UIWindowSetRotatable, &orig_UIWindow_setRotatable);
        MSHookMessageEx(objc_getClass("UIDevice"),
                        @selector(beginGeneratingDeviceOrientationNotifications),
                        (IMP)ABHook_UIDeviceBeginGen, &orig_UIDevice_beginGen);
        MSHookMessageEx(objc_getClass("UIDevice"),
                        NSSelectorFromString(@"setOrientation:animated:"),
                        (IMP)ABHook_UIDeviceSetOrientation, &orig_UIDevice_setOrientation);
        MSHookMessageEx(objc_getClass("UIDevice"), @selector(orientation),
                        (IMP)ABHook_UIDeviceOrientation, &orig_UIDevice_orientation);
        MSHookMessageEx(objc_getClass("UITextField"), @selector(becomeFirstResponder),
                        (IMP)ABHook_TFBecome, &orig_TF_become);
        MSHookMessageEx(objc_getClass("UITextField"), @selector(resignFirstResponder),
                        (IMP)ABHook_TFResign, &orig_TF_resign);
        MSHookMessageEx(objc_getClass("UITextView"), @selector(becomeFirstResponder),
                        (IMP)ABHook_TVBecome, &orig_TV_become);
        MSHookMessageEx(objc_getClass("UITextView"), @selector(resignFirstResponder),
                        (IMP)ABHook_TVResign, &orig_TV_resign);
        BOOL hasScene = OMCHasMethod("UIWindowScene", @"requestGeometryUpdateWithPreferences:errorHandler:"); // [hotfix] 2nd arg was a C string; the impl treats it as NSString* (original passes the cfstring — installer_app_4728.txt @0x491c-0x492c)
        BOOL hasVCUpdate = class_getInstanceMethod(objc_getClass("UIViewController"), @selector(setNeedsUpdateOfSupportedInterfaceOrientations)) != NULL;
        BOOL hasAttempt = class_getClassMethod(objc_getClass("UIViewController"), @selector(attemptRotationToDeviceOrientation)) != NULL;
        if (hasScene) {
            MSHookMessageEx(objc_getClass("UIWindowScene"),
                            @selector(requestGeometryUpdateWithPreferences:errorHandler:),
                            (IMP)ABHook_SceneRequestGeometry, &orig_Scene_reqGeometry);
        }
        if (hasVCUpdate) {
            MSHookMessageEx(objc_getClass("UIViewController"),
                            @selector(setNeedsUpdateOfSupportedInterfaceOrientations),
                            (IMP)ABHook_VCSetNeedsUpdate, &orig_VC_setNeedsUpdate);
        }
        if (!hasVCUpdate && hasAttempt) {
            // Pre-iOS-16 fallback: hook the class method on the metaclass.
            MSHookMessageEx(object_getClass(objc_getClass("UIViewController")),
                            @selector(attemptRotationToDeviceOrientation),
                            (IMP)ABHook_VCAttemptRotation, &orig_VC_attemptRotation);
        }
        OMCLogWrite(@"AppBridge", [NSString stringWithFormat:@"%@: dua len xe, cai hook",
                                   [NSBundle mainBundle].bundleIdentifier]);
    }

    NSDictionary *info = note.userInfo;
    NSInteger orientation = [info[@"orientation"] intValue];
    NSInteger old = ABForcedOrientation;
    if (orientation > 0) {
        ABForcedOrientation = orientation;
        ABAppOrientation = 0;
        ABDeviceFake = [info[@"device"] intValue];
    } else {
        // Host released the app: drop the car keyboard first.
        if (ABCurrentResponder) [ABCurrentResponder resignFirstResponder];
        ABForcedOrientation = orientation;
        ABAppOrientation = 0;
        ABDeviceFake = 0;
    }
    OMCLogWrite(@"AppBridge", [NSString stringWithFormat:@"huong o %d, thiet bi gia %d (doi=%d)",
                               (int)orientation, (int)ABDeviceFake, orientation != old]);

    if (orientation != old) {
        if (ABDeviceFake >= 1) {
            // Constant array at 0x393F0: @[@0.3, @1.5, @4.0] (verbatim).
            for (NSNumber *delay in @[@0.3, @1.5, @4.0]) ABAfterDelay(delay.doubleValue);
        }
        // Decide the orientation the app should believe in, and force the
        // rotatable view if the supported mask admits it.
        NSInteger target = ABForcedOrientation;
        if (target == -1) {
            NSInteger o = [UIDevice currentDevice].orientation; // (hooked getter)
            target = o > 1 ? o : 1;
        }
        NSUInteger mask = ABSupportedOrientationMask();
        if (target >= 1 && (mask & (1u << target)) == 0) {
            OMCLogWrite(@"AppBridge", [NSString stringWithFormat:@"bo qua ep xoay %d: app chi cho mask %lu",
                                       (int)target, (unsigned long)mask]);
        } else {
            id view = ABKeyWindow(); // sub_61D0 result (window; the original
                                     // passes it through an intermediate that
                                     // yields the rotatable target — see report)
            SEL sel = NSSelectorFromString(@"_setRotatableViewOrientation:duration:force:");
            if (view && [view respondsToSelector:sel]) {
                // objc_msgSend(view, sel, target, 0.0, YES)
                ((void (*)(id, SEL, NSInteger, double, BOOL))objc_msgSend)(view, sel, target, 0.0, YES);
            }
        }
    }

    // FPS limit carried by the same notification.
    NSInteger orient2 = [note.userInfo[@"orientation"] intValue];
    NSInteger fps = orient2 >= 1 ? [note.userInfo[@"fps"] intValue] : 0;
    if (fps != ABFPSLimit) {
        ABFPSLimit = fps;
        for (id link in [ABDisplayLinks() allObjects]) ABApplyFPSLimit(link);
        OMCLogWrite(@"AppBridge", [NSString stringWithFormat:@"gioi han khung hinh: %d", (int)fps]);
    }
}

// ===========================================================================
// Key receiver block — sub_5908. Registered by the ctor for ABChanKey.
// Applies one car-keyboard action to the tracked first responder.
// ===========================================================================
static void ABKeyBlock(NSNotification *note) {
    @try {
        NSDictionary *info = note.userInfo;
        id responder = ABCurrentResponder;
        if (!responder || ![responder isFirstResponder]) return;
        if (![responder conformsToProtocol:@protocol(UITextInput)]) return;
        NSString *action = info[@"action"];
        if ([action isEqualToString:@"type"]) {
            NSInteger del = [info[@"del"] intValue];
            for (NSInteger i = 0; i < del; i++) [responder deleteBackward];
            NSString *text = info[@"text"];
            if ([text isKindOfClass:NSString.class] && text.length > 0)
                [responder insertText:text];
        } else if ([action isEqualToString:@"return"]) {
            if ([responder isKindOfClass:UITextField.class]) {
                id<UITextFieldDelegate> delegate = [(UITextField *)responder delegate];
                BOOL proceed = YES;
                if ([delegate respondsToSelector:@selector(textFieldShouldReturn:)])
                    proceed = [delegate textFieldShouldReturn:(UITextField *)responder];
                if (proceed)
                    [(UIControl *)responder sendActionsForControlEvents:UIControlEventEditingDidEndOnExit]; // 0x80000
            } else {
                [responder insertText:@"\n"];
            }
        } else if ([action isEqualToString:@"dismiss"]) {
            [responder resignFirstResponder];
        }
    } @catch (NSException *e) {
        OMCLogWrite(@"AppBridge", [NSString stringWithFormat:@"%@: phim loi %@",
                                   [NSBundle mainBundle].bundleIdentifier, e]);
    }
}

void ABInstallInAppObservers(NSString *bundleID) {
    NSDistributedNotificationCenter *center = [NSDistributedNotificationCenter defaultCenter];
    NSOperationQueue *queue = [NSOperationQueue mainQueue];
    [center addObserverForName:ABChanOrientation object:bundleID queue:queue
                    usingBlock:^(NSNotification *n) { ABOrientationBlock(n); }];
    [center addObserverForName:ABChanKey object:bundleID queue:queue
                    usingBlock:^(NSNotification *n) { ABKeyBlock(n); }];
}

// ===========================================================================
// Deferred fake-orientation re-post — sub_5FF0 + block sub_6028.
// sub_5FF0 is a generic helper: dispatch_after(dispatch_time(0, seconds*1e9),
// main, <the one global block 0x34630 whose invoke is sub_6028>).
// The block re-posts UIDeviceOrientationDidChangeNotification (object =
// [UIDevice currentDevice]) if a fake device orientation is active and the
// supported mask has bit 1 set; otherwise it logs the skip.
// ===========================================================================
static void ABFakeOrientationEvent(void) {
    if (ABDeviceFake < 1) return;
    NSUInteger mask = ABSupportedOrientationMask();
    if ((mask & 0x2) == 0) {
        OMCLogWrite(@"AppBridge", [NSString stringWithFormat:@"bo qua su kien xoay gia: app dang chi cho mask %lu",
                                   (unsigned long)mask]);
        return;
    }
    [[NSNotificationCenter defaultCenter]
        postNotificationName:UIDeviceOrientationDidChangeNotification
                      object:[UIDevice currentDevice]];
}

static void ABAfterDelay(NSTimeInterval seconds) {
    dispatch_after(dispatch_time(0, (int64_t)(seconds * 1e9)),
                   dispatch_get_main_queue(), ^{ ABFakeOrientationEvent(); });
}

// ===========================================================================
// First-responder hooks (keyboard suppression + channel publish)
// ===========================================================================
// sub_698C — before becomeFirstResponder: while hosted, give the responder a
// blank zero-size inputView so the system keyboard never appears in the app.
// The marker associated object lives at a unique static address used as
// the key (the original materialises its own in-image slot, VA 0x3E9E4,
// PC-relative @0x6a1c–0x6a20, and never dereferences it). [fix-round-3]
// The absolute VA must not be used as the pointer value in the rebuild;
// the self-referential form gives the same semantics (a stable,
// distinct, in-image address, never dereferenced by the runtime).
static const void *ABBlankInputViewKey = &ABBlankInputViewKey;

static void ABSuppressSystemKeyboard(id responder) {
    if (ABForcedOrientation < 1) return;
    if (![responder respondsToSelector:@selector(setInputView:)]) return;
    if ([responder inputView] != nil) return;
    UIView *blank = [[UIView alloc] initWithFrame:CGRectZero];
    [responder setInputView:blank];
    objc_setAssociatedObject(responder, ABBlankInputViewKey, (id)kCFBooleanTrue,
                             OBJC_ASSOCIATION_ASSIGN); // policy 1 in the original
}

// sub_6A70 — after a successful becomeFirstResponder while hosted.
static void ABResponderBecame(id responder) {
    if (ABForcedOrientation < 1) return;
    ABCurrentResponder = responder;
    ABKeyboardPublish(YES, responder);
}

// sub_6D50 — after a successful resignFirstResponder.
static void ABResponderResigned(id responder) {
    if (objc_getAssociatedObject(responder, ABBlankInputViewKey)) {
        objc_setAssociatedObject(responder, ABBlankInputViewKey, nil, OBJC_ASSOCIATION_ASSIGN);
        [responder setInputView:nil]; // restore the real input view
    }
    if (ABCurrentResponder == responder) {
        ABCurrentResponder = nil;
        ABKeyboardPublish(NO, nil);
    }
}

static BOOL ABHook_TFBecome(UITextField *self, SEL _cmd) {
    ABSuppressSystemKeyboard(self);
    BOOL ok = ((BOOL (*)(id, SEL))orig_TF_become)(self, _cmd);
    if (ok) ABResponderBecame(self);
    return ok;
}
static BOOL ABHook_TFResign(UITextField *self, SEL _cmd) {
    BOOL ok = ((BOOL (*)(id, SEL))orig_TF_resign)(self, _cmd);
    if (ok) ABResponderResigned(self);
    return ok;
}
static BOOL ABHook_TVBecome(UITextView *self, SEL _cmd) {
    if (self.isEditable) ABSuppressSystemKeyboard(self);
    BOOL ok = ((BOOL (*)(id, SEL))orig_TV_become)(self, _cmd);
    if (ok && self.isEditable) ABResponderBecame(self);
    return ok;
}
static BOOL ABHook_TVResign(UITextView *self, SEL _cmd) {
    BOOL ok = ((BOOL (*)(id, SEL))orig_TV_resign)(self, _cmd);
    if (ok) ABResponderResigned(self);
    return ok;
}

// ===========================================================================
// Keyboard channel publisher — sub_6AD4. PROVEN packed format:
//   state = shown | keyboardType<<1 | returnKeyType<<8 | FNV1a(bundleID)<<24
// ===========================================================================
static void ABKeyboardPublish(BOOL shown, id traits) {
    if (!ABKeyboardToken)
        notify_register_check(ABNotifyKeyboard, &ABKeyboardToken);
    uint64_t state = 0;
    if (shown) {
        state = 1;
        if ([traits respondsToSelector:@selector(keyboardType)])
            state |= (uint64_t)([traits keyboardType] & 0x7F) << 1;
        if ([traits respondsToSelector:@selector(returnKeyType)])
            state |= (uint64_t)([traits returnKeyType] & 0xFF) << 8;
    }
    state |= (uint64_t)ABBundleHash([NSBundle mainBundle].bundleIdentifier) << 24;
    notify_set_state(ABKeyboardToken, state);
    notify_post(ABNotifyKeyboard);
    OMCLogWrite(@"AppBridge", [NSString stringWithFormat:@"ban phim xe: %@ (%@)",
                               shown ? @"hien" : @"an",
                               traits ? NSStringFromClass([traits class]) : @"-"]);
}

// ===========================================================================
// Orientation machinery hooks
// ===========================================================================
// -[UIDevice setOrientation:animated:] (sub_5504): while hosted, remember the
// app's own landscape choice (values 3,4,5 kept, others zeroed), log it, and
// schedule a (debounced) report to SpringBoard; always calls the original.
static void ABHook_UIDeviceSetOrientation(UIDevice *self, SEL _cmd, NSInteger orientation, BOOL animated) {
    if (ABForcedOrientation >= 1) {
        NSInteger v = orientation - 3;
        ABAppOrientation = ((NSUInteger)v <= 2) ? orientation : 0;
        OMCLogWrite(@"AppBridge", [NSString stringWithFormat:@"app setOrientation %lld -> %lld",
                                   (long long)orientation, (long long)ABAppOrientation]);
        ABScheduleAppOrientationPublish(ABAppOrientation);
    }
    ((void (*)(id, SEL, NSInteger, BOOL))orig_UIDevice_setOrientation)(self, _cmd, orientation, animated);
}

// -[UIDevice orientation] (sub_55D8): the app's own choice wins; else the
// host's fake device orientation; else the real one.
static NSInteger ABHook_UIDeviceOrientation(UIDevice *self, SEL _cmd) {
    if (ABAppOrientation > 0) return ABAppOrientation;
    if (ABDeviceFake >= 1) return ABDeviceFake;
    return ((NSInteger (*)(id, SEL))orig_UIDevice_orientation)(self, _cmd);
}

// -[UIDevice beginGeneratingDeviceOrientationNotifications] (sub_54C8):
// original, then one fake-orientation re-post at +0.2 s (constant at 0x2B1D8).
static void ABHook_UIDeviceBeginGen(UIDevice *self, SEL _cmd) {
    ((void (*)(id, SEL))orig_UIDevice_beginGen)(self, _cmd);
    if (ABDeviceFake >= 1) ABAfterDelay(0.2);
}

// -[UIWindow _setRotatableViewOrientation:duration:force:] (sub_543C):
// while hosted, substitutes the effective orientation (app's own if set,
// else the host-forced one) for the requested argument. (The original also
// computes the window mask via sub_5EC0; its comparison only gates a branch
// that cannot change the outcome when hosted — see report §4.3.)
static void ABHook_UIWindowSetRotatable(UIWindow *self, SEL _cmd, NSInteger orientation, double duration, BOOL force) {
    NSInteger effective = ABAppOrientation > 0 ? ABAppOrientation : ABForcedOrientation;
    NSInteger use = effective >= 1 ? effective : orientation;
    ((void (*)(id, SEL, NSInteger, double, BOOL))orig_UIWindow_setRotatable)(self, _cmd, use, duration, force);
}

// -[UIWindowScene requestGeometryUpdateWithPreferences:errorHandler:]
// (sub_5734, iOS 16+): while hosted, derives ABAppOrientation from the
// requested preferences' interfaceOrientations mask and schedules a report.
// Derivation (csel chain, verified): if the mask has the portrait bit (2),
// prefer LandscapeLeft (bit 16 -> 4), then LandscapeRight (bit 8 -> 3),
// then PortraitUpsideDown (bit 4 -> value 2 via (mask>>1)&2); if the
// portrait bit is absent the derived value is 0.
static NSInteger ABOrientationDerivedFromMask(NSUInteger mask) {
    NSInteger v = (mask & 8) ? 3 : (NSInteger)((mask >> 1) & 2);
    if (mask & 16) v = 4;
    if (!(mask & 2)) v = 0;
    return v;
}

static void ABHook_SceneRequestGeometry(UIWindowScene *self, SEL _cmd, id preferences, id errorHandler) {
    if (ABForcedOrientation >= 1 &&
        [preferences respondsToSelector:@selector(interfaceOrientations)]) {
        NSUInteger mask = [preferences interfaceOrientations];
        ABAppOrientation = ABOrientationDerivedFromMask(mask);
        OMCLogWrite(@"AppBridge", [NSString stringWithFormat:@"app xin huong mask=%lu -> %lld",
                                   (unsigned long)mask, (long long)ABAppOrientation]);
        ABScheduleAppOrientationPublish(ABAppOrientation);
    }
    ((void (*)(id, SEL, id, id))orig_Scene_reqGeometry)(self, _cmd, preferences, errorHandler);
}

// -[UIViewController setNeedsUpdateOfSupportedInterfaceOrientations]
// (sub_5888) and +[UIViewController attemptRotationToDeviceOrientation]
// (sub_58C0, fallback): original, then schedule a report with the sentinel
// field 0xFF ("recompute from mask" — consumed by ABHost, see report).
static void ABHook_VCSetNeedsUpdate(UIViewController *self, SEL _cmd) {
    ((void (*)(id, SEL))orig_VC_setNeedsUpdate)(self, _cmd);
    if (ABForcedOrientation >= 1) ABScheduleAppOrientationPublish(0xFF);
}
static void ABHook_VCAttemptRotation(id self, SEL _cmd) {
    ((void (*)(id, SEL))orig_VC_attemptRotation)(self, _cmd);
    if (ABForcedOrientation >= 1) ABScheduleAppOrientationPublish(0xFF);
}

// ===========================================================================
// App-orientation publisher — sub_67FC + debounce sub_6750 (0.25 s).
// PROVEN packed format:
//   state = (orientationField & 0xFF) | (mask & 0xFFFF) << 8 | FNV1a << 24
// The 0xFF sentinel passes through as the low byte; ABHost resolves it.
// ===========================================================================
static void ABPublishAppOrientation(int64_t orientationField) {
    ABPendingPublishBlock = nil; // the original releases the stored block here
    if (!ABAppOrientToken)
        notify_register_check(ABNotifyAppOrient, &ABAppOrientToken);
    NSUInteger mask = ABSupportedOrientationMask();
    uint64_t state = ((uint64_t)orientationField & 0xFF)
                   | ((uint64_t)(mask & 0xFFFF) << 8)
                   | ((uint64_t)ABBundleHash([NSBundle mainBundle].bundleIdentifier) << 24);
    notify_set_state(ABAppOrientToken, state);
    notify_post(ABNotifyAppOrient);
    OMCLogWrite(@"AppBridge", [NSString stringWithFormat:@"bao SpringBoard: ma %lld, mask %lu",
                               (long long)orientationField, (unsigned long)mask]);
}

static void ABScheduleAppOrientationPublish(int64_t field) {
    if (ABPendingPublishBlock) dispatch_block_cancel((dispatch_block_t)ABPendingPublishBlock);
    dispatch_block_t block = dispatch_block_create(0, ^{ ABPublishAppOrientation(field); });
    ABPendingPublishBlock = block;
    dispatch_after(dispatch_time(0, 250000000 /* 0.25 s, immediate constant in sub_6750 */),
                   dispatch_get_main_queue(), block);
}

// ===========================================================================
// Supported-mask computation — sub_612C / sub_6498 / sub_5EC0 / sub_61D0
// ===========================================================================
// sub_6498: recursive search (depth cap 12) for a visible view controller
// whose supported mask contains a landscape bit (8 or 16) and does NOT
// contain the portrait bit (2); presented controllers are tried before
// children (skipped when nil or being dismissed). Returns that mask, or 0.
// (Full body line-read in remediation round 2 — 696/696 B, 174 insns,
// disasm/rem4_tail_6498.txt: the return rule is `(m & 0x18) != 0 &&
// (m & 0x2) == 0` at 0x6558/0x6560, and the presented recursion is gated
// on `!presentedViewController.isBeingDismissed`. An earlier draft had
// the portrait condition inverted and the presented step ungated; both
// corrected.)
static NSUInteger ABMaskFromViewController(UIViewController *vc, NSInteger depth) {
    if (!vc || depth > 12) return 0;
    if (vc.isViewLoaded && vc.view.window && !vc.view.isHidden) {
        NSUInteger m = vc.supportedInterfaceOrientations;
        if ((m & 0x18) != 0 && (m & 0x2) == 0) return m;
    }
    UIViewController *presented = vc.presentedViewController;
    if (presented && !presented.isBeingDismissed) {
        NSUInteger m = ABMaskFromViewController(presented, depth + 1);
        if (m) return m;
    }
    for (UIViewController *child in vc.childViewControllers) {
        NSUInteger m = ABMaskFromViewController(child, depth + 1);
        if (m) return m;
    }
    return 0;
}

// sub_5EC0: mask of a window's root/presented chain (used by the rotatable
// hook and as layoutPane-independent fallback).
static NSUInteger ABMaskFromWindow(UIWindow *window) {
    UIViewController *vc = window.rootViewController;
    while (vc.presentedViewController && !vc.presentedViewController.isBeingDismissed)
        vc = vc.presentedViewController;
    return vc ? vc.supportedInterfaceOrientations : 0;
}

// sub_61D0: first key, non-hidden window across connected scenes.
static UIWindow *ABKeyWindow(void) {
    for (UIScene *scene in [UIApplication sharedApplication].connectedScenes) {
        if (![scene isKindOfClass:UIWindowScene.class]) continue;
        for (UIWindow *w in ((UIWindowScene *)scene).windows)
            if (w.isKeyWindow && !w.isHidden) return w;
    }
    return nil;
}

// sub_612C: mask entry point — 0x1E (all four orientations) when there is
// no window at all.
static NSUInteger ABSupportedOrientationMask(void) {
    UIWindow *window = ABKeyWindow();
    if (!window) return 0x1E;
    NSUInteger m = ABMaskFromViewController(window.rootViewController, 0);
    if (m == 0) m = ABMaskFromWindow(window);
    return m;
}

// ===========================================================================
// FPS limiting — sub_5C64 (weak set of links), sub_5CBC (apply), hooks
// sub_50A8 / sub_5144 / sub_5220. While ABFPSLimit > 0 every CADisplayLink
// the app creates or reconfigures is re-clamped by calling the ORIGINAL
// setters directly (no recursion). The requested range's components are
// read back as floats and clamped to the limit; when the app only used the
// integer setter, the clamped integer is re-applied.
// (Field-level detail is in disasm/apply_fps_5cbc.txt.)
// ===========================================================================
static NSHashTable *ABDisplayLinks(void) {
    static NSHashTable *table;
    static dispatch_once_t once;
    dispatch_once(&once, ^{ table = [NSHashTable weakObjectsHashTable]; });
    return table;
}

static void ABApplyFPSLimit(CADisplayLink *link) {
    if (ABFPSLimit <= 0) return;
    // Original reads the link's current preferred range components and
    // re-applies them clamped; see evidence file. Simplified faithful form:
    CAFrameRateRange range = link.preferredFrameRateRange;
    float lim = (float)ABFPSLimit;
    range.maximum = MIN(range.maximum, lim);
    range.preferred = MIN(range.preferred, lim);
    if (range.minimum > range.maximum) range.minimum = range.maximum;
    if (orig_CADisplayLink_setRange)
        ((void (*)(id, SEL, CAFrameRateRange))orig_CADisplayLink_setRange)(link, @selector(setPreferredFrameRateRange:), range);
    NSInteger fps = link.preferredFramesPerSecond;
    if (orig_CADisplayLink_setFPS && fps > ABFPSLimit)
        ((void (*)(id, SEL, NSInteger))orig_CADisplayLink_setFPS)(link, @selector(setPreferredFramesPerSecond:), ABFPSLimit);
}

static CADisplayLink *ABHook_CADisplayLinkNew(id self, SEL _cmd, id target, SEL selector) {
    CADisplayLink *link = ((CADisplayLink *(*)(id, SEL, id, SEL))orig_CADisplayLink_new)(self, _cmd, target, selector);
    if (link) {
        [ABDisplayLinks() addObject:link];
        ABApplyFPSLimit(link);
    }
    return link;
}
static void ABHook_CADisplayLinkSetFPS(CADisplayLink *self, SEL _cmd, NSInteger fps) {
    if (orig_CADisplayLink_setFPS)
        ((void (*)(id, SEL, NSInteger))orig_CADisplayLink_setFPS)(self, _cmd, fps);
    ABApplyFPSLimit(self);
}
static void ABHook_CADisplayLinkSetRange(CADisplayLink *self, SEL _cmd, CAFrameRateRange range) {
    if (orig_CADisplayLink_setRange)
        ((void (*)(id, SEL, CAFrameRateRange))orig_CADisplayLink_setRange)(self, _cmd, range);
    ABApplyFPSLimit(self);
}
