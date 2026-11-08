// ABChannels.m — process bootstraps, hook installers, and the complete
// appbridge.* channel surface of OmniCarAppBridge.dylib.
// Agent A scope (channel contracts + launch routing). Handler bodies that
// belong to hosting/keyboard internals are marked [B] and only registered
// here, exactly as the original constructors do.
//
// Channel transport (PROVEN by disassembly):
//  * NSDistributedNotificationCenter — payload channels (userInfo dicts).
//  * Darwin notify (notify_register_dispatch / notify_get_state /
//    notify_post / notify_set_state) — payload-less signals whose 64-bit
//    state packs small integers (hash + codes), e.g. apporient/keyboard.
//  * NSNotificationCenter (local) — "CarPlayIsConnectedDidChange".

#import <Foundation/Foundation.h>
#import <notify.h>
#import <substrate.h>
#import <dlfcn.h>
#import "ABHost.h"
#import "OMCCore.h"

static NSString *const kPrefix = @"com.anlai.omnicar/appbridge.";

// ===========================================================================
// 1. Host-process bootstrap — __mod_init_2 @ 0x20184 (VERIFIED)
//    Runs in EVERY process, but only acts when the process name is
//    "SpringBoard" or "CarPlay" (CarPlayApp): async on the main queue it
//    logs the build and stamps the diag pref
//    "diagLoaded.AppBridge@<processName>" = {version, build, date}.
// ===========================================================================
__attribute__((constructor))
static void ABHostProcessInit(void) {
    NSString *process = [NSProcessInfo processInfo].processName;
    if (![process isEqualToString:@"SpringBoard"] &&
        ![process isEqualToString:@"CarPlay"]) return;
    dispatch_async(dispatch_get_main_queue(), ^{
        OMCLogWrite(@"AppBridge", [NSString stringWithFormat:
            @"build %s (%s) loaded into %@", "1.0.3", "fbebb21", process]);
        NSString *key = [NSString stringWithFormat:@"%@%s@%@",
                         @"diagLoaded.", "AppBridge", process];
        NSDictionary *value = @{@"version": @"1.0.3",
                                @"build":   @"fbebb21",
                                @"date":    [NSDate date]};
        CFPreferencesSetAppValue((__bridge CFStringRef)key,
                                 (__bridge CFPropertyListRef)value,
                                 CFSTR("com.anlai.omnicar"));
        CFPreferencesAppSynchronize(CFSTR("com.anlai.omnicar"));
    });
}

// ===========================================================================
// 2. SpringBoard bootstrap — __mod_init_1 @ 0x6e08 (VERIFIED)
//    Gate: main bundle id == "com.apple.springboard".
//    Installs 4 MSHookMessageEx hooks + 1 MSHookFunction hook, then verifies
//    them with OMCCheckHooks. The applicationDidFinishLaunching: replacement
//    (§3) registers all host channels once SpringBoard is up.
//    NOTE (hotfix): this file's installer (ABSpringBoardInit, below) is
//    NEUTRALISED — it duplicates the same ctor 0x6e08 reconstructed in
//    src/AppBridgeB/AppBridgeEntry.m, which is the single active
//    installer. See the DUPLICATE INSTALLER note above ABSpringBoardInit.
// ===========================================================================

static void (*orig_SB_applicationDidFinishLaunching)(id, SEL, id);
static BOOL (*orig_shouldBeBackgroundUnderLock)(id, SEL, id, id);
static void (*orig_FBScene_updateSettings)(id, SEL, id, id, id);
static void (*orig_SBSceneView_updateReferenceSize)(id, SEL, CGSize, long long);
static void (*orig_BKSDisplayServicesSetScreenBlanked)(BOOL);

// Replacement @ 0x777c — VERIFIED: when the screen is blanked (arg YES)
// while apps are hosted, pass the blank through, then dispatch_after 1 s
// (the delayed block presumably un-blanks / re-evaluates); when nothing is
// hosted, or the arg is NO, tail-call the original.
static void repl_BKSDisplayServicesSetScreenBlanked(BOOL blanked) {
    if (!blanked || [ABHost shared].count == 0) {
        orig_BKSDisplayServicesSetScreenBlanked(blanked);
        return;
    }
    orig_BKSDisplayServicesSetScreenBlanked(YES);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 1000000000LL),
                   dispatch_get_main_queue(), ^{
        // Block @ literal 0x347d0 — body not isolated in this pass
        // (NOT-RECOVERED detail; the 1 s re-check is INFERRED).
    });
}

// Replacement @ 0x7764 — VERIFIED trampoline: clamps the orientation
// argument to <= 3 before calling the original
// -[SBSceneView _updateReferenceSize:andOrientation:].
static void repl_SBSceneView_updateReferenceSize(id self, SEL _cmd,
                                                 CGSize size,
                                                 long long orientation) {
    if (orientation > 3) orientation = 3;
    orig_SBSceneView_updateReferenceSize(self, _cmd, size, orientation);
}

// Replacement @ 0x72bc — VERIFIED: hosted apps' scenes are NOT put in the
// background under lock. Calls the original; if it says YES, resolves
// scene.clientProcess.bundleIdentifier (dynamic selectors, with
// ABMissingSelector diagnostics) and flips the result to NO when
// [ABHost.shared hostsApp:bundleID].
static BOOL repl_shouldBeBackgroundUnderLock(id self, SEL _cmd,
                                             id scene, id settings) {
    BOOL result = orig_shouldBeBackgroundUnderLock(self, _cmd, scene, settings);
    if (!result) return result;
    id process = nil;
    SEL cpSel = NSSelectorFromString(@"clientProcess");
    if ([scene respondsToSelector:cpSel]) {
        id (*fn)(id, SEL) = (void *)objc_msgSend;
        process = fn(scene, cpSel);
    } else {
        ABMissingSelector(scene, @"clientProcess");
    }
    NSString *bundleID = nil;
    SEL biSel = NSSelectorFromString(@"bundleIdentifier");
    if ([process respondsToSelector:biSel]) {
        id (*fn)(id, SEL) = (void *)objc_msgSend;
        bundleID = fn(process, biSel);
    } else if (process) {
        ABMissingSelector(process, @"bundleIdentifier");
    }
    if (bundleID && [[ABHost shared] hostsApp:bundleID])
        return result ^ 1;
    return result;
}

// Replacement @ 0x74b4 — VERIFIED: for a hosted app's scene that is NOT
// foreground, -[FBScene updateSettings:withTransitionContext:completion:]
// is swallowed (the original is not called); in all other cases the
// original runs. (Keeps hosted scenes from being reconfigured while the
// dashboard owns the visible app.)
static void repl_FBScene_updateSettings(id self, SEL _cmd, id settings,
                                        id context, id completion) {
    if ([ABHost shared].count > 0) {
        id process = nil;
        SEL cpSel = NSSelectorFromString(@"clientProcess");
        if ([self respondsToSelector:cpSel]) {
            id (*fn)(id, SEL) = (void *)objc_msgSend;
            process = fn(self, cpSel);
        } else {
            ABMissingSelector(self, @"clientProcess");
        }
        NSString *bundleID = nil;
        SEL biSel = NSSelectorFromString(@"bundleIdentifier");
        if ([process respondsToSelector:biSel]) {
            id (*fn)(id, SEL) = (void *)objc_msgSend;
            bundleID = fn(process, biSel);
        } else if (process) {
            ABMissingSelector(process, @"bundleIdentifier");
        }
        if (bundleID && [[ABHost shared] hostsApp:bundleID]) {
            BOOL foreground = NO;
            SEL fgSel = NSSelectorFromString(@"isForeground");
            if ([self respondsToSelector:fgSel]) {
                BOOL (*fn)(id, SEL) = (void *)objc_msgSend;
                foreground = fn(self, fgSel);
            } else {
                ABMissingSelector(self, @"isForeground");
            }
            if (!foreground) return; // swallow
        }
    }
    orig_FBScene_updateSettings(self, _cmd, settings, context, completion);
}

// ===========================================================================
// 3. Host channel registration — replacement @ 0x7004 of
//    -[SpringBoard applicationDidFinishLaunching:] (VERIFIED).
//    Calls the original, logs "SpringBoard ready", then registers:
//      distributed (object nil, main queue): open, frame, shield, close,
//        closeall, knobs
//      Darwin notify on main queue: apporient, keyboard
//      local NSNotificationCenter: CarPlayIsConnectedDidChange
// ===========================================================================
static void repl_SB_applicationDidFinishLaunching(id self, SEL _cmd, id app) {
    orig_SB_applicationDidFinishLaunching(self, _cmd, app);
    OMCLogWrite(@"AppBridge", @"SpringBoard ready");

    NSDistributedNotificationCenter *dc =
        [NSClassFromString(@"NSDistributedNotificationCenter") defaultCenter];
    NSOperationQueue *mq = [NSOperationQueue mainQueue];

    // --- appbridge.open (handler block @ 0x783c) — VERIFIED key-by-key.
    // userInfo (all optional except identifier):
    //   identifier : bundle id (NSString)
    //   x, y, w, h : frame (NSNumber, doubleValue)
    //   pt,pl,pb,pr: pass insets -> setPassInsets:forApp:
    //   bar (bool), pop (int), popDim (bool), single (bool)
    //              -> setBarVisible:pop:dim:single:forApp:
    //   ox,oy,ow,oh: hole rect -> setHole:forApp:
    //   r (double), corners (unsignedLongLong) -> setCornerRadius:corners:forApp:
    //   hx (double) -> setHandleOffset:forApp:
    //   front (bool) -> setFront:forApp:
    //   ax,ay,aw,ah: -> setCarAppArea:
    // The open itself calls [ABHost openApp:frame:] FIRST; every other key
    // group is applied afterwards, in the order above.
    [dc addObserverForName:@"com.anlai.omnicar/appbridge.open"
                    object:nil queue:mq
                usingBlock:^(NSNotification *note) {
        NSDictionary *ui = note.userInfo;
        NSString *app = ui[@"identifier"];
        CGRect frame = CGRectMake([ui[@"x"] doubleValue], [ui[@"y"] doubleValue],
                                  [ui[@"w"] doubleValue], [ui[@"h"] doubleValue]);
        [[ABHost shared] openApp:app frame:frame];
        ABHost *host = [ABHost shared];
        if (ui[@"pt"] || ui[@"pl"] || ui[@"pb"] || ui[@"pr"])
            [host setPassInsets:UIEdgeInsetsMake([ui[@"pt"] doubleValue],
                                                 [ui[@"pl"] doubleValue],
                                                 [ui[@"pb"] doubleValue],
                                                 [ui[@"pr"] doubleValue])
                         forApp:app];
        if (ui[@"bar"])
            [host setBarVisible:[ui[@"bar"] boolValue]
                            pop:[ui[@"pop"] intValue]
                            dim:[ui[@"popDim"] boolValue]
                         single:[ui[@"single"] boolValue]
                         forApp:app];
        if (ui[@"ox"] || ui[@"oy"] || ui[@"ow"] || ui[@"oh"])
            [host setHole:CGRectMake([ui[@"ox"] doubleValue], [ui[@"oy"] doubleValue],
                                     [ui[@"ow"] doubleValue], [ui[@"oh"] doubleValue])
                   forApp:app];
        if (ui[@"r"])
            [host setCornerRadius:[ui[@"r"] doubleValue]
                          corners:[ui[@"corners"] unsignedLongLongValue]
                           forApp:app];
        if (ui[@"hx"])
            [host setHandleOffset:[ui[@"hx"] doubleValue] forApp:app];
        if (ui[@"front"])
            [host setFront:[ui[@"front"] boolValue] forApp:app];
        if (ui[@"ax"] || ui[@"ay"] || ui[@"aw"] || ui[@"ah"])
            host.carAppArea = CGRectMake([ui[@"ax"] doubleValue], [ui[@"ay"] doubleValue],
                                         [ui[@"aw"] doubleValue], [ui[@"ah"] doubleValue]);
    }];

    // --- appbridge.frame (handler @ 0x8274) — VERIFIED:
    // {identifier, x,y,w,h, live(bool), handle(bool), pt,pl,pb,pr}
    //   -> setFrame:forApp:live:handle:passInsets:
    [dc addObserverForName:@"com.anlai.omnicar/appbridge.frame"
                    object:nil queue:mq
                usingBlock:^(NSNotification *note) {
        NSDictionary *ui = note.userInfo;
        CGRect frame = CGRectMake([ui[@"x"] doubleValue], [ui[@"y"] doubleValue],
                                  [ui[@"w"] doubleValue], [ui[@"h"] doubleValue]);
        UIEdgeInsets insets = UIEdgeInsetsMake([ui[@"pt"] doubleValue],
                                               [ui[@"pl"] doubleValue],
                                               [ui[@"pb"] doubleValue],
                                               [ui[@"pr"] doubleValue]);
        [[ABHost shared] setFrame:frame forApp:ui[@"identifier"]
                             live:[ui[@"live"] boolValue]
                           handle:[ui[@"handle"] boolValue]
                       passInsets:insets];
    }];

    // --- appbridge.shield (handler @ 0x8c7c) — VERIFIED:
    // {on: bool} -> setShieldAll:  (errors logged "shield loi %@")
    [dc addObserverForName:@"com.anlai.omnicar/appbridge.shield"
                    object:nil queue:mq
                usingBlock:^(NSNotification *note) {
        [[ABHost shared] setShieldAll:[note.userInfo[@"on"] boolValue]];
    }];

    // --- appbridge.close (handler @ 0x8df0) — VERIFIED:
    // {identifier, terminate: bool} -> closeApp:terminate:
    [dc addObserverForName:@"com.anlai.omnicar/appbridge.close"
                    object:nil queue:mq
                usingBlock:^(NSNotification *note) {
        NSDictionary *ui = note.userInfo;
        [[ABHost shared] closeApp:ui[@"identifier"]
                        terminate:[ui[@"terminate"] boolValue]];
    }];

    // --- appbridge.closeall (handler @ 0x8fd4) — VERIFIED:
    // {except: bundleID or nil} -> closeAllExcept:
    [dc addObserverForName:@"com.anlai.omnicar/appbridge.closeall"
                    object:nil queue:mq
                usingBlock:^(NSNotification *note) {
        [[ABHost shared] closeAllExcept:note.userInfo[@"except"]];
    }];

    // --- appbridge.knobs (handler @ 0x9144) — VERIFIED:
    // {knobs: NSArray} -> setKnobs:
    [dc addObserverForName:@"com.anlai.omnicar/appbridge.knobs"
                    object:nil queue:mq
                usingBlock:^(NSNotification *note) {
        [[ABHost shared] setKnobs:note.userInfo[@"knobs"]];
    }];

    // --- Darwin: appbridge.apporient (handler @ 0x92b4) — VERIFIED:
    // state is a packed uint64: the handler reads it with
    // notify_get_state and calls
    // [ABHost appWithHash:changedOrientation:supportedMask:].
    // Packing (from the sender side in the app process, ctor 0x44a8 unit /
    // ABHost appWithHash consumer): hash = FNV-1a(bundleID); the exact bit
    // layout of orientation/mask inside the uint64 is INFERRED — the
    // consumer extracts two small integers in addition to the 32-bit hash.
    static int apporientToken;
    notify_register_dispatch("com.anlai.omnicar/appbridge.apporient",
                             &apporientToken, dispatch_get_main_queue(),
                             ^(int token) {
        uint64_t state = 0;
        notify_get_state(token, &state);
        // INFERRED unpacking: low 32 bits = bundle hash.
        [[ABHost shared] appWithHash:(uint32_t)state
                changedOrientation:(int)(state >> 32)
                   supportedMask:(state >> 40)];
    });

    // --- Darwin: appbridge.keyboard (handler @ 0x93b0) — VERIFIED shape:
    // state carries a bundle hash; host resolves it via bundleForHash:
    // and calls [ABKeyboard.shared hideForApp:] (B class). This is the
    // "dismiss the bridge keyboard for this app" signal.
    static int keyboardToken;
    notify_register_dispatch("com.anlai.omnicar/appbridge.keyboard",
                             &keyboardToken, dispatch_get_main_queue(),
                             ^(int token) {
        uint64_t state = 0;
        notify_get_state(token, &state);
        NSString *bundleID = [[ABHost shared] bundleForHash:(uint32_t)state];
        if (bundleID) {
            id kb = [NSClassFromString(@"ABKeyboard") shared];
            [kb performSelector:@selector(hideForApp:) withObject:bundleID];
        }
    });

    // --- Local: CarPlayIsConnectedDidChange (handler @ 0x958c) —
    // VERIFIED head: resolves AVExternalDevice.currentCarPlayExternalDevice
    // via dynamic selectors; on disconnect it drives
    // [ABHost carDisconnected]. (Tail of the block not fully traced.)
    [[NSNotificationCenter defaultCenter]
        addObserverForName:@"CarPlayIsConnectedDidChange"
                    object:nil queue:mq
                usingBlock:^(NSNotification *note) {
        Class av = NSClassFromString(@"AVExternalDevice");
        SEL sel = NSSelectorFromString(@"currentCarPlayExternalDevice");
        id device = nil;
        if ([(id)av respondsToSelector:sel]) {
            id (*fn)(id, SEL) = (void *)objc_msgSend;
            device = fn((id)av, sel);
        }
        if (!device) [[ABHost shared] carDisconnected];
    }];
}

// ===========================================================================
// DUPLICATE INSTALLER — NEUTRALISED (hotfix, do not re-enable).
// This constructor and ABHostCtor in src/AppBridgeB/AppBridgeEntry.m are
// two reconstructions of the SAME original constructor, __mod_init_1 @
// 0x6e08. The original installs each of the five hooks below exactly
// ONCE: disasm/ctor_host_6e08.txt (in src/AppBridgeB/disasm/) contains
// exactly 4 _MSHookMessageEx calls (0x6ec0/0x6ee8/0x6f10/0x6f38) and 1
// _MSHookFunction call (0x6f80). With both constructors live, the built
// product installed all five hooks twice (chained) and ran the
// applicationDidFinishLaunching: registrar twice. The single active
// installer is AppBridgeEntry.m's ABHostCtor: its handler set
// (ABHostGeometry.m) is the dump-verified one — e.g. sub_7764 clamps
// orientation >4 to 3 (cmp x2,#4 in hook_SBSceneView_refsize_7764.txt),
// while repl_SBSceneView_updateReferenceSize below clamps >3. This
// function is retained, marked `used` but NOT a constructor, because
// its repl_* bodies are the reference reconstruction of the registrar
// blocks sub_783C/8DF0/8FD4/9144 (open/close/closeall/knobs), which
// were ported into ABHostGeometry.m's ABSpringBoardReady when this
// installer was neutralised.
// ===========================================================================
__attribute__((used))
static void ABSpringBoardInit(void) {
    if (![[[NSBundle mainBundle] bundleIdentifier]
            isEqualToString:@"com.apple.springboard"]) return;
    OMCLogWrite(@"AppBridge", @"loaded into SpringBoard");

    MSHookMessageEx(objc_getClass("SpringBoard"),
                    @selector(applicationDidFinishLaunching:),
                    (IMP)repl_SB_applicationDidFinishLaunching,
                    (IMP *)&orig_SB_applicationDidFinishLaunching);
    MSHookMessageEx(objc_getClass("SBSuspendedUnderLockManager"),
                    @selector(_shouldBeBackgroundUnderLockForScene:withSettings:),
                    (IMP)repl_shouldBeBackgroundUnderLock,
                    (IMP *)&orig_shouldBeBackgroundUnderLock);
    MSHookMessageEx(objc_getClass("FBScene"),
                    @selector(updateSettings:withTransitionContext:completion:),
                    (IMP)repl_FBScene_updateSettings,
                    (IMP *)&orig_FBScene_updateSettings);
    MSHookMessageEx(objc_getClass("SBSceneView"),
                    @selector(_updateReferenceSize:andOrientation:),
                    (IMP)repl_SBSceneView_updateReferenceSize,
                    (IMP *)&orig_SBSceneView_updateReferenceSize);

    OMCCheckHooks(@"AppBridge", @[
        @"SBSuspendedUnderLockManager -_shouldBeBackgroundUnderLockForScene:withSettings:",
        @"FBScene -updateSettings:withTransitionContext:completion:",
        @"SBSceneView -_updateReferenceSize:andOrientation:",
    ]);

    void *fn = dlsym(RTLD_DEFAULT, "BKSDisplayServicesSetScreenBlanked");
    if (fn) {
        MSHookFunction(fn, (void *)repl_BKSDisplayServicesSetScreenBlanked,
                       (void **)&orig_BKSDisplayServicesSetScreenBlanked);
    } else {
        OMCLogWrite(@"AppBridge",
            @"khong tim thay BKSDisplayServicesSetScreenBlanked");
    }
}

// ===========================================================================
// 4. App-process bootstrap — __mod_init_0 @ 0x44a8 (VERIFIED head;
//    handler bodies and the in-app hooks belong to agent B).
//    Gate: bundle id non-empty, bundle path contains ".app", and the
//    bundle id is NOT one of the system/CarPlay processes:
//      com.apple.springboard, com.apple.CarPlayApp,
//      com.apple.CarPlayTemplateUIHost, com.apple.CarPlaySettings,
//      com.apple.InCallService, com.apple.Preferences
//    Then, scoped with object = the app's OWN bundle id, it observes:
//      appbridge.orientation (block @ 0x4728)  [B handler]
//      appbridge.key         (block @ 0x5908)  [B handler]
//    and installs the in-app MSHookMessageEx hooks (all [B]):
//      CADisplayLink +displayLinkWithTarget:selector:,
//        -setPreferredFramesPerSecond:, -setPreferredFrameRateRange:
//      UIWindow -_setRotatableViewOrientation:duration:force:
//      UIDevice -beginGeneratingDeviceOrientationNotifications,
//        -setOrientation:animated:, -orientation
//      UITextField / UITextView -becomeFirstResponder, -resignFirstResponder
//      UIWindowScene -requestGeometryUpdateWithPreferences:errorHandler:
//        (only when OMCHasMethod says it exists)
//      UIViewController -setNeedsUpdateOfSupportedInterfaceOrientations,
//        +attemptRotationToDeviceOrientation
//    and logs "%@: dua len xe, cai hook" with the bundle id.
// ===========================================================================
