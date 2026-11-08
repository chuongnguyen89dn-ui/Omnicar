// SCPHooks.m — OmniCarSplitScreen, agent A domain.
// The MSHookMessageEx installers (__init_0/__init_1, the Logos %ctor
// equivalents) and the hook replacements for the scene/session lifecycle.
// Home-grid/icon replacements that only forward into the SCPHome*/SCPAppIcons*
// C family are included with their proven call sequences; that family was
// reconstructed by SplitScreen-C (names/linkage aligned in the phase-2
// seam fix — see the note appended to SplitScreenA_REPORT.md).
//
// Reconstructed from disassembly. All hooks are installed only when the
// host bundle is com.apple.CarPlayApp and OMCCrashGuard(@"splitScreen")
// passes (VERIFIED guard in both initializers).

#import "SCPHooks.h"
#import "SCPShared.h"
#import "SCPCarSplit.h"
#import "SCPSmallClasses.h"   // SCPNoopLayoutAssertion (final closure: addElement hook)
#import <objc/message.h>
#import <objc/runtime.h>      // class_copyIvarList / object_getIvar (final closure)
#import <notify.h>
#import <substrate.h>

void *orig_DashBoard_newApplicationLibrary;
void *orig_DBApplicationInfo_loadFromProxy;
void *orig_HomeVC_initWithEnvironment;
void *orig_HomeVC_viewDidLayoutSubviews;
void *orig_HomeVC_viewDidAppear;
void *orig_HomeVC_viewDidDisappear;
void *orig_LaunchInfo_launchInfoForApplication;
void *orig_LaunchInfo_launchInfoWithSettings;
// (No icon-grid orig slots here: the single surviving set is
// SplitScreen-C's typed slots in SCPHomeHooks.m — see SCPHooks.h.)
int scpPrefsChangedToken;
void *orig_DBDashboard_sceneFrameForAppInfo;
void *orig_DBDashboard_safeAreaInsetsForAppInfo;
void *orig_DBDashboard_handleHomeEvent;
void *orig_DBDashboard_invalidate;
void *orig_DBDashboard_launchAppWithInfo;
void *orig_RootVC_presentBaseViewController;
void *orig_RootVC_dismissBaseViewController;
void *orig_RootVC_viewDidLayoutSubviews;
void *orig_RootVC_viewDidAppear;
void *orig_SceneVC_backgroundSceneWithCompletion;
void *orig_SceneVC_deactivateSceneWithReasonMask;
void *orig_SceneVC_sceneManagerDidDestroyScene;
void *orig_FBSDisplayLayoutPublisher_addElement;

#pragma mark - Replacements: home / app-library group (init_0)

// sub_4af0 VERIFIED: after the original builds the application library,
// inject the user-chosen phone apps (AppBridge) into it.
static id Hook_newApplicationLibrary(id self, SEL _cmd) {
    id library = ((id (*)(id, SEL))orig_DashBoard_newApplicationLibrary)(self, _cmd);
    if ([SCPChosenPhoneApps() count]) {
        // 0xc37c returns the crash-guard verdict in w0: the binary tests
        // it at 0x4b40 and calls AddChosenAppsToLibrary only when nonzero.
        if (SCPAppIconsBeginInjection())
            SCPAddChosenAppsToLibrary(library);
    }
    // (The binary's @catch pad calls SCPLogException("_newApplicationLibrary",
    // e) at 0x5520; there is no unconditional "kick" call — A's earlier
    // SCPHomeKick placeholder was a misreading, removed in the seam fix.)
    return library;
}

// sub_4bcc VERIFIED: after loading from the proxy, mark chosen phone apps
// with an injected declaration so the dashboard treats them as CarPlay apps.
static void Hook_loadFromProxy(id self, SEL _cmd, id proxy) {
    ((void (*)(id, SEL, id))orig_DBApplicationInfo_loadFromProxy)(self, _cmd, proxy);
    SCPInjectDeclarationIfChosen(self);
}

// sub_4c70 VERIFIED: remember the home view controller.
static id Hook_HomeVC_initWithEnvironment(id self, SEL _cmd, id environment) {
    id result = ((id (*)(id, SEL, id))orig_HomeVC_initWithEnvironment)(self, _cmd, environment);
    SCPSetHomeViewController(result ?: self);
    return result;
}

// sub_4cb4 / sub_4d24 / sub_4d90 VERIFIED pattern: orig + home visibility
// bookkeeping (SCPHomeSetVisible) + refresh kick.
static void Hook_HomeVC_viewDidLayoutSubviews(id self, SEL _cmd) {
    ((void (*)(id, SEL))orig_HomeVC_viewDidLayoutSubviews)(self, _cmd);
    SCPHomeApply(self);   // 0x4a6d8 — the binary's second call (0x4cd4)
}
static void Hook_HomeVC_viewDidAppear(id self, SEL _cmd, BOOL animated) {
    ((void (*)(id, SEL, BOOL))orig_HomeVC_viewDidAppear)(self, _cmd, animated);
    SCPHomeSetVisible(YES);   // one BOOL arg (0x4d3c: mov w0, #1)
    // @catch pad in the binary calls SCPLogException("SCPHomeSetVisible", e).
}
static void Hook_HomeVC_viewDidDisappear(id self, SEL _cmd, BOOL animated) {
    ((void (*)(id, SEL, BOOL))orig_HomeVC_viewDidDisappear)(self, _cmd, animated);
    SCPHomeSetVisible(NO);    // one BOOL arg (0x4da8: mov w0, #0)
}

// sub_4dfc / sub_4f30 VERIFIED: for an injected phone app the answer is
// nil — NO synthetic launch-info object is built (the earlier
// "SCPSyntheticLaunchInfo" was a phantom; no such function exists in the
// binary). The settings variant first kicks the AppBridge launch with the
// bundle id. For native apps the original answers. (Phase-2 seam fix,
// from the instruction streams at 0x4e88-0x4e94 and 0x4fc8-0x4ff8.)
static id Hook_launchInfoForApplication(id self, SEL _cmd, id app) {
    NSString *bundle = nil;
    SEL bundleSel = NSSelectorFromString(@"bundleIdentifier");
    if ([app respondsToSelector:bundleSel])
        bundle = ((id (*)(id, SEL))objc_msgSend)(app, bundleSel);
    else
        SCPMissingSelector(app, NSStringFromSelector(bundleSel));
    if (SCPIsInjectedPhoneApp(bundle)) {
        return nil;   // 0x4e90: mov x20, #0
    }
    return ((id (*)(id, SEL, id))orig_LaunchInfo_launchInfoForApplication)(self, _cmd, app);
}
static id Hook_launchInfoWithSettings(id self, SEL _cmd, id app, id settings) {
    NSString *bundle = nil;
    SEL bundleSel = NSSelectorFromString(@"bundleIdentifier");
    if ([app respondsToSelector:bundleSel])
        bundle = ((id (*)(id, SEL))objc_msgSend)(app, bundleSel);
    else
        SCPMissingSelector(app, NSStringFromSelector(bundleSel));
    if (SCPIsInjectedPhoneApp(bundle)) {
        // 0x4fd8-0x4ff8: [[SCPCarSplit shared] launchPhoneAppIfNeeded:bundle]
        // (the argument is the bundle-id string in x21), then return nil.
        [[SCPCarSplit shared] launchPhoneAppIfNeeded:bundle];
        return nil;
    }
    return ((id (*)(id, SEL, id, id))orig_LaunchInfo_launchInfoWithSettings)(self, _cmd, app, settings);
}

// Icon-grid geometry hooks (sub_5104, sub_51a0, sub_51d8, sub_5210,
// sub_5248, sub_5280, sub_5338, sub_5438): these rescale the stock home
// grid so injected icons fit. The replacement BODIES are SplitScreen-C's
// (SCPHomeHooks.m, VERIFIED there, driven by SCPHomeIconScale()/
// SCPHomeGridColumns()/SCPHomeGridRows()/SCPHomeShowNames()); only the
// installers live here (see SCPInitHomeHooks below).

#pragma mark - Replacements: dashboard / scene group (init_1)

// sub_5cf0 VERIFIED (decision): while the split is active, the scene frame
// for an app in a pane is the pane's frame — this is what makes the FBScene
// be created at pane size. Falls back to the original frame otherwise.
static CGRect Hook_sceneFrameForAppInfo(id self, SEL _cmd, id appInfo, id proxyInfo) {
    CGRect frame = ((CGRect (*)(id, SEL, id, id))orig_DBDashboard_sceneFrameForAppInfo)(self, _cmd, appInfo, proxyInfo);
    @try {
        NSString *bundle = SCPRealBundleForInfos(appInfo, proxyInfo);
        CGSize size = [[SCPCarSplit shared] paneSize:frame forBundle:bundle];
        if (size.width > 0 && size.height > 0) frame.size = size;
    } @catch (NSException *ex) { SCPExceptionLog("sceneFrameForAppInfo", ex); }
    return frame;
}

// sub_5e84 INFERRED companion: safe-area insets for a pane app are the
// original insets clamped to the pane (body not individually read).
static UIEdgeInsets Hook_safeAreaInsetsForAppInfo(id self, SEL _cmd, id appInfo, id proxyInfo) {
    return ((UIEdgeInsets (*)(id, SEL, id, id))orig_DBDashboard_safeAreaInsetsForAppInfo)(self, _cmd, appInfo, proxyInfo);
}

// sub_601c VERIFIED (call order): when the split is active, the split gets
// first say on the home event; if it does not consume it, the split closes
// as "going home". The original implementation still runs afterwards.
static void Hook_handleHomeEvent(id self, SEL _cmd, id event) {
    @try {
        SCPCarSplit *split = [SCPCarSplit shared];
        if ([split active]) {
            if (![split homePressedDuringSplit:event])
                [split closeGoingHome:YES];
        }
    } @catch (NSException *ex) { SCPExceptionLog("_handleHomeEvent", ex); }
    ((void (*)(id, SEL, id))orig_DBDashboard_handleHomeEvent)(self, _cmd, event);
}

// sub_611c VERIFIED: dashboard invalidate == car display/session gone.
static void Hook_invalidate(id self, SEL _cmd) {
    @try { [[SCPCarSplit shared] dashboardInvalidated]; }
    @catch (NSException *ex) { SCPExceptionLog("DBDashboard invalidate", ex); }
    ((void (*)(id, SEL))orig_DBDashboard_invalidate)(self, _cmd);
}

// sub_61d0 VERIFIED: phone-app launches from the dashboard are consumed by
// AppBridge (launchPhoneAppIfNeeded:), native launches pass through.
static void Hook_launchAppWithInfo(id self, SEL _cmd, id info, id url) {
    BOOL handled = NO;
    @try { handled = [[SCPCarSplit shared] launchPhoneAppIfNeeded:info]; }
    @catch (NSException *ex) { SCPExceptionLog("_launchAppWithInfo", ex); }
    if (!handled)
        ((void (*)(id, SEL, id, id))orig_DBDashboard_launchAppWithInfo)(self, _cmd, info, url);
}

// sub_636c VERIFIED (read end-to-end): THE presentation gate. While the
// split is active, a base-VC presentation is either adopted into a pane
// (and the original presentation is skipped entirely) or it tears the
// split down (closeGoingHome:) and proceeds fullscreen. After a real
// fullscreen presentation, a delayed repair check runs at ~0.8 s
// (VERIFIED constant 0x2faf0800 ns = 799,268,864 ns).
static void Hook_presentBaseViewController(id self, SEL _cmd, UIViewController *vc,
                                           BOOL animated, unsigned long long launchSource,
                                           void (^completion)(void)) {
    SCPCarSplit *split = [SCPCarSplit shared];
    BOOL adopted = NO;
    if ([split active]) {
        @try {
            if ([split wantsViewController:vc]) {
                [split adoptViewController:vc];
                adopted = YES;
            }
        } @catch (NSException *ex) {
            SCPExceptionLog("presentBaseViewController (adopt)", ex);
            [split closeGoingHome:NO];
        }
        if (adopted) {
            if (completion) completion();
            return;   // original NOT called
        }
        OMCLogWrite(@"SplitScreen", [NSString stringWithFormat:
            @"CarSplit: DashBoard mo %@ toan man -> tat split", vc]);
        [split closeGoingHome:NO];
    }
    ((void (*)(id, SEL, id, BOOL, unsigned long long, id))orig_RootVC_presentBaseViewController)
        (self, _cmd, vc, animated, launchSource, completion);
    OMCLogWrite(@"SplitScreen", [NSString stringWithFormat:
        @"CarSplit: DashBoard trinh bay %@ toan man (nguon %llu)", vc, launchSource]);
    [split baseViewControllerPresented];
    [split refreshAppTabSoon];
    __weak UIViewController *weakVC = vc;
    __weak id weakSelf = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 799268864), dispatch_get_main_queue(), ^{
        // block sub_80c4: re-check/repair the presented VC (VERIFIED timing
        // and captures; interior calls repairPresentedViewController:).
        (void)weakSelf;
        [[SCPCarSplit shared] repairPresentedViewController:weakVC];
    });
}

// sub_66dc VERIFIED (call sequence): dismissing the base VC back to the
// dashboard home tears the split down first.
static void Hook_dismissBaseViewController(id self, SEL _cmd, BOOL animated, void (^completion)(void)) {
    @try {
        SCPCarSplit *split = [SCPCarSplit shared];
        if ([split active]) {
            id root = SCPDashboardRootViewController();
            SEL baseSel = NSSelectorFromString(@"currentBaseViewController");
            id base = nil;
            if ([root respondsToSelector:baseSel])
                base = ((id (*)(id, SEL))objc_msgSend)(root, baseSel);
            else
                SCPMissingSelector(root, NSStringFromSelector(baseSel));
            if (base) {
                OMCLogWrite(@"SplitScreen", @"CarSplit: DashBoard ve man chinh -> tat split");
                [split closeGoingHome:YES];
                [split removeAppTab];
                [split refreshAppTabSoon];
            }
        }
    } @catch (NSException *ex) { SCPExceptionLog("dismissBaseViewController", ex); }
    ((void (*)(id, SEL, BOOL, id))orig_RootVC_dismissBaseViewController)(self, _cmd, animated, completion);
}

// sub_68e8 VERIFIED: orig + rootDidLayout.
static void Hook_RootVC_viewDidLayoutSubviews(id self, SEL _cmd) {
    ((void (*)(id, SEL))orig_RootVC_viewDidLayoutSubviews)(self, _cmd);
    @try { [[SCPCarSplit shared] rootDidLayout]; }
    @catch (NSException *ex) { SCPExceptionLog("RootVC viewDidLayoutSubviews", ex); }
}

// sub_6988 VERIFIED: orig, then two delayed main-queue blocks:
// +2,996,068,352 ns (~3.0 s): publishCarPlayApps + carScreenAppeared, then
// SCPAppIconsCarScreenOK() (block sub_828c — all three unconditional, in
// that order; the earlier "if (CarScreenOK)" gating was a misreading:
// 0xc570 is void and is called LAST, at 0x82dc);
// +7,000,000,000 ns (7.0 s): SCPDumpAppLibraryOnce() (block sub_834c).
static void Hook_RootVC_viewDidAppear(id self, SEL _cmd, BOOL animated) {
    ((void (*)(id, SEL, BOOL))orig_RootVC_viewDidAppear)(self, _cmd, animated);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 2996068352LL), dispatch_get_main_queue(), ^{
        @try {
            [[SCPCarSplit shared] publishCarPlayApps];
            [[SCPCarSplit shared] carScreenAppeared];
            SCPAppIconsCarScreenOK();
        } @catch (NSException *ex) { SCPExceptionLog("RootVC viewDidAppear +3s", ex); }
    });
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 7000000000LL), dispatch_get_main_queue(), ^{
        SCPDumpAppLibraryOnce();
    });
}

// sub_69fc VERIFIED: a pane app's scene must not background — swallow the
// call (but honour the completion) while the split protects the VC.
static void Hook_backgroundSceneWithCompletion(id self, SEL _cmd, void (^completion)(void)) {
    BOOL protected = NO;
    @try { protected = [[SCPCarSplit shared] protectsViewController:self]; }
    @catch (NSException *ex) { SCPExceptionLog("backgroundScene", ex); }
    if (protected) {
        OMCLogWrite(@"SplitScreen", @"CarSplit: chan background scene cua app trong ngan");
        if (completion) completion();
        return;
    }
    ((void (*)(id, SEL, id))orig_SceneVC_backgroundSceneWithCompletion)(self, _cmd, completion);
}

// sub_6b44 VERIFIED: same protection for scene deactivation (fully swallowed).
static void Hook_deactivateSceneWithReasonMask(id self, SEL _cmd, unsigned long long mask) {
    BOOL protected = NO;
    @try { protected = [[SCPCarSplit shared] protectsViewController:self]; }
    @catch (NSException *ex) { SCPExceptionLog("deactivateScene", ex); }
    if (protected) {
        OMCLogWrite(@"SplitScreen", [NSString stringWithFormat:
            @"CarSplit: chan deactivate scene (mask=%llu) cua app trong ngan", mask]);
        return;
    }
    ((void (*)(id, SEL, unsigned long long))orig_SceneVC_deactivateSceneWithReasonMask)(self, _cmd, mask);
}

// sub_6c78 VERIFIED: capture the VC's scene BEFORE the original destroys
// it, then let the split reconcile its panes.
static void Hook_sceneManagerDidDestroyScene(id self, SEL _cmd, id manager, id scene) {
    SCPCarSplit *split = [SCPCarSplit shared];
    id ownScene = nil;
    @try { ownScene = [split sceneOfViewController:self]; }
    @catch (NSException *ex) { SCPExceptionLog("didDestroyScene", ex); }
    ((void (*)(id, SEL, id, id))orig_SceneVC_sceneManagerDidDestroyScene)(self, _cmd, manager, scene);
    @try { [split scene:scene destroyedForViewController:self ownScene:ownScene]; }
    @catch (NSException *ex) { SCPExceptionLog("didDestroyScene", ex); }
}

// sub_8350 VERIFIED (final closure — line-read, dump
// src/SplitScreenA/disasm/sub_8350.txt): the layout-element predicate.
// TRUE ABI is a BOOL predicate over (element, candidate) — A's old
// declaration (NSString *SCPLayoutElementKey(id)) was the wrong shape.
// [phase3] The body lives ONCE in SCPShared.m (global, declared in
// SCPShared.h — the phase-2 closure transcription of the same dump);
// this file's static duplicate was removed at canonicalisation because
// it followed the now-global declaration.

// The duplicate scan inside sub_6e10 (factored into a helper here; in
// the binary it is inline in the hook). Walks the superclass chain of
// the publisher's class, stopping BEFORE NSObject (and at a nil class),
// reads every object-typed ivar (type encoding starting with '@') off
// the publisher itself, and tests each stored object for the key:
//   - NSDictionary / NSMapTable: a direct objectForKey: hit is a
//     duplicate; on a miss, entries are deep-scanned — an NSString key
//     ending in ":<key>" is a duplicate, and for non-string keys the
//     key object itself or its stored value matches when its own
//     -identifier equals the key (SCPLayoutElementKey);
//   - any other NSFastEnumeration conformer that is not an NSString:
//     any element whose -identifier equals the key is a duplicate.
static BOOL SCPLayoutIdentifierAlreadyDeclared(id publisher, NSString *key) {
    Class cls = object_getClass(publisher);
    while (cls && cls != [NSObject class]) {
        unsigned int count = 0;
        Ivar *ivars = class_copyIvarList(cls, &count);
        BOOL found = NO;
        for (unsigned int i = 0; i < count && !found; i++) {
            const char *type = ivar_getTypeEncoding(ivars[i]);
            if (!type || type[0] != '@') continue;
            id stored = object_getIvar(publisher, ivars[i]);
            if ([stored isKindOfClass:[NSDictionary class]] ||
                [stored isKindOfClass:[NSMapTable class]]) {
                if ([stored objectForKey:key]) { found = YES; break; }
                for (id k in [stored keyEnumerator]) {
                    if ([k isKindOfClass:[NSString class]]) {
                        if ([k hasSuffix:[@":" stringByAppendingString:key]]) { found = YES; break; }
                    } else {
                        if (SCPLayoutElementKey(k, key)) { found = YES; break; }
                        if (SCPLayoutElementKey([stored objectForKey:k], key)) { found = YES; break; }
                    }
                }
            } else if ([stored conformsToProtocol:@protocol(NSFastEnumeration)] &&
                       ![stored isKindOfClass:[NSString class]]) {
                for (id el in stored)
                    if (SCPLayoutElementKey(el, key)) { found = YES; break; }
            }
        }
        free(ivars);
        if (found) return YES;
        cls = class_getSuperclass(cls);
    }
    return NO;
}

// sub_6e10 VERIFIED (final closure — line-read end to end, dump
// src/SplitScreenA/disasm/hook_FBSDisplayLayoutPublisher_addElement_0x6e10.txt):
// FBSDisplayLayoutPublisher -addElement: replacement. iOS 15 asserts on
// duplicate element identifiers, so when the new element's identifier
// is an NSString that the publisher already stores (scan above), the
// hook logs the skip and returns a fresh SCPNoopLayoutAssertion
// INSTEAD of calling the original; every other case (including a
// missing or non-string identifier) forwards to the original and
// returns its result. A's old model — a process-wide static
// NSMutableSet fed by a key-returning SCPLayoutElementKey — was
// INFERRED and wrong: the binary keeps NO persistent set; the scan is
// over the publisher's own ivars on every call.
static id Hook_addElement(id self, SEL _cmd, id element) {
    @try {
        NSString *key = nil;
        if ([element respondsToSelector:@selector(identifier)])
            key = [element identifier];
        if ([key isKindOfClass:[NSString class]] &&
            SCPLayoutIdentifierAlreadyDeclared(self, key)) {
            OMCLogWrite(@"SplitScreen", [NSString stringWithFormat:
                @"CarSplit: bo khai bao trung %@ (tranh assert cua iOS 15)", key]);
            return [SCPNoopLayoutAssertion new];
        }
    } @catch (NSException *ex) { SCPExceptionLog("addElement", ex); }
    return ((id (*)(id, SEL, id))orig_FBSDisplayLayoutPublisher_addElement)(self, _cmd, element);
}

#pragma mark - Distributed-notification blocks (CarPlayApp, init_1)

// block 0x7434 VERIFIED: appbridge.state -> hostedApp:state:.
static void SCPBridgeStateBlock(NSNotification *note) {
    @try {
        [[SCPCarSplit shared] hostedApp:note.userInfo[@"identifier"]
                                  state:note.userInfo[@"state"]];
    } @catch (NSException *ex) { SCPExceptionLog("appbridge.state", ex); }
}
// blocks 0x76a0 / 0x77c8 / 0x78b4 / 0x7a4c / 0x7b00: the remaining bridge
// input channels forward their userInfo into SCPCarSplit's bridge*
// handlers (identification VERIFIED by registration order in __init_1;
// interiors at call-sequence fidelity).
static void SCPBridgeHandleTapBlock(NSNotification *note) {
    // VERIFIED (integration, disasm/rem3_bridgeTapBlock_76a0.txt): the
    // binary's block @0x76a0 passes userInfo[@"identifier"] — the
    // method takes the bundle string, not the dictionary.
    [[SCPCarSplit shared] bridgeHandleTapped:note.userInfo[@"identifier"]];
}
static void SCPBridgeHandleDragBlock(NSNotification *note) {
    [[SCPCarSplit shared] bridgeHandleDrag:note.userInfo];
}
static void SCPBridgeBarActionBlock(NSNotification *note) {
    [[SCPCarSplit shared] bridgeBarAction:note.userInfo[@"action"]
                               forBundle:note.userInfo[@"identifier"]];
}
static void SCPBridgeBarDismissBlock(NSNotification *note) {
    [[SCPCarSplit shared] bridgeBarAction:@"dismiss" forBundle:note.userInfo[@"identifier"]];
}
static void SCPBridgeKnobTouchBlock(NSNotification *note) {
    // Same bundle-string argument as the tap block (integration note:
    // a full-text scan finds exactly ONE bridgeHandleTapped: call site
    // in the binary, @0x770c, passing userInfo[@"identifier"]).
    [[SCPCarSplit shared] bridgeHandleTapped:note.userInfo[@"identifier"]];
}

// block 0x7bec VERIFIED (read end-to-end): the splitscreen.native command
// channel. userInfo[@"action"] dispatches into SCPCarSplit; every command
// is answered with a splitscreen.ack post.
static void SCPNativeCommandBlock(NSNotification *note) {
    NSDictionary *info = note.userInfo;
    NSString *action = info[@"action"];
    OMCLogWrite(@"SplitScreen", [NSString stringWithFormat:@"CarSplit: yeu cau %@", action]);
    SCPCarSplit *split = [SCPCarSplit shared];
    if ([action isEqualToString:@"close"]) {
        [split closeGoingHome:YES];
    } else if ([action isEqualToString:@"closeApp"]) {
        [split closeApp:info[@"identifier"]];
    } else if ([action isEqualToString:@"open"]) {
        [split openApp:info[@"identifier"] slot:[info[@"slot"] intValue]];
    } else if ([action isEqualToString:@"pair"]) {
        [split openPairLeft:info[@"left"] right:info[@"right"]];
    } else if ([action isEqualToString:@"fav"]) {
        [split openFavorite:[info[@"index"] integerValue]];
    } else if ([action isEqualToString:@"picker"]) {
        [split showPickerForFocusedPane];
    } else if ([action isEqualToString:@"layout"]) {
        [split openSetupLayout:[info[@"layout"] integerValue] apps:info[@"apps"]];
    }
    [[NSDistributedNotificationCenter defaultCenter]
        postNotificationName:SCPNoteNativeAck object:nil userInfo:nil];
}

// block 0x54bc VERIFIED: prefschanged (Darwin) -> refresh the home/app-icon
// state and kick the split.
static void SCPHandlePrefsChanged(void) {
    SCPRefreshAppIconsSoon();
    SCPRefreshHiddenAppsSoon();
    SCPHomeRefresh();
    // (Binary 0x54bc: exactly these three calls; its @catch pad calls
    // SCPLogException("SCPHomeRefresh", e). No fourth "kick" call exists.)
}

#pragma mark - Installers

static BOOL SCPHostIsCarPlayApp(void) {
    return [[[NSBundle mainBundle] bundleIdentifier] isEqualToString:@"com.apple.CarPlayApp"];
}

// sub_52e8 VERIFIED (closure pass — own disassembly resolved through
// verify/macho_truth.py; A's dump sub_52e8.txt agrees instruction for
// instruction): the icon-model class whose -isIconVisible: the grid
// group hooks — the first of the three candidate classes that exists.
// Note the asymmetry in the binary: the DashBoard-side name is resolved
// through OMCCarClass (0x502fc, declared in SCPShared.h), the two
// SpringBoard-side fallbacks through plain objc_getClass. The binary
// returns the class through the standard ARC retain +
// autoreleaseReturnValue pair, i.e. plain source below. Both call
// sites are in SCPInitHomeHooks (0x472c: the MSHookMessageEx install;
// 0x479c: the class_getName() entry in the OMCCheckHooks list).
Class SCPIconModelClass(void) {
    Class cls = OMCCarClass("DBIconModel");
    if (cls == nil) cls = objc_getClass("SBHIconModel");
    if (cls == nil) cls = objc_getClass("SBIconModel");
    return cls;
}

// __init_0 (0x44a8) VERIFIED end-to-end. Runs in CarPlayApp only.
__attribute__((constructor))
static void SCPInitHomeHooks(void) {
    if (!SCPHostIsCarPlayApp()) return;
    if (!OMCCrashGuard(@"splitScreen")) return;

    Class dashBoardMeta = object_getClass(OMCCarClass("DashBoard"));
    MSHookMessageEx(dashBoardMeta, @selector(_newApplicationLibrary),
                    (IMP)Hook_newApplicationLibrary, (IMP *)&orig_DashBoard_newApplicationLibrary);
    MSHookMessageEx(OMCCarClass("DBApplicationInfo"), @selector(_loadFromProxy:),
                    (IMP)Hook_loadFromProxy, (IMP *)&orig_DBApplicationInfo_loadFromProxy);

    Class homeVC = OMCCarClass("DBDashboardHomeViewController");
    MSHookMessageEx(homeVC, @selector(initWithEnvironment:),
                    (IMP)Hook_HomeVC_initWithEnvironment, (IMP *)&orig_HomeVC_initWithEnvironment);
    MSHookMessageEx(homeVC, @selector(viewDidLayoutSubviews),
                    (IMP)Hook_HomeVC_viewDidLayoutSubviews, (IMP *)&orig_HomeVC_viewDidLayoutSubviews);
    MSHookMessageEx(homeVC, @selector(viewDidAppear:),
                    (IMP)Hook_HomeVC_viewDidAppear, (IMP *)&orig_HomeVC_viewDidAppear);
    MSHookMessageEx(homeVC, @selector(viewDidDisappear:),
                    (IMP)Hook_HomeVC_viewDidDisappear, (IMP *)&orig_HomeVC_viewDidDisappear);

    Class launchInfoMeta = object_getClass(OMCCarClass("DBApplicationLaunchInfo"));
    MSHookMessageEx(launchInfoMeta, @selector(launchInfoForApplication:),
                    (IMP)Hook_launchInfoForApplication, (IMP *)&orig_LaunchInfo_launchInfoForApplication);
    MSHookMessageEx(launchInfoMeta, @selector(launchInfoForApplication:withActivationSettings:),
                    (IMP)Hook_launchInfoWithSettings, (IMP *)&orig_LaunchInfo_launchInfoWithSettings);

    // Icon-grid group (replacement bodies: SplitScreen-C, SCPHomeHooks.m;
    // installer rows VERIFIED. Phase-2 seam fix: body names and orig-IMP
    // slots are C's — the bodies are extern there, and the typed slot
    // definitions below are the ONLY set; A's SCPHook_Grid_*/orig_GridCfg_*
    // duplicates were removed. True body signatures are in SCPHomeHooks.m;
    // the (void) declarations here are signature-agnostic IMP sources.)
    extern void SCPHook_IconImageInfo(void), SCPHook_PortraitColumns(void),
                SCPHook_PortraitRows(void), SCPHook_LandscapeColumns(void),
                SCPHook_LandscapeRows(void), SCPHook_SetLabelHidden(void),
                SCPHook_IsIconVisible(void), SCPHook_MaxLabelSize(void);
    extern IMP OrigIconImageInfo, OrigPortraitColumns, OrigPortraitRows,
               OrigLandscapeColumns, OrigLandscapeRows, OrigSetLabelHidden,
               OrigIsIconVisible, OrigMaxLabelSize;
    Class gridCfg = objc_getClass("SBIconListGridLayoutConfiguration");
    MSHookMessageEx(gridCfg, @selector(iconImageInfo),
                    (IMP)SCPHook_IconImageInfo, (IMP *)&OrigIconImageInfo);
    MSHookMessageEx(gridCfg, @selector(numberOfPortraitColumns),
                    (IMP)SCPHook_PortraitColumns, (IMP *)&OrigPortraitColumns);
    MSHookMessageEx(gridCfg, @selector(numberOfPortraitRows),
                    (IMP)SCPHook_PortraitRows, (IMP *)&OrigPortraitRows);
    MSHookMessageEx(gridCfg, @selector(numberOfLandscapeColumns),
                    (IMP)SCPHook_LandscapeColumns, (IMP *)&OrigLandscapeColumns);
    MSHookMessageEx(gridCfg, @selector(numberOfLandscapeRows),
                    (IMP)SCPHook_LandscapeRows, (IMP *)&OrigLandscapeRows);
    MSHookMessageEx(objc_getClass("SBIconView"), @selector(setLabelHidden:),
                    (IMP)SCPHook_SetLabelHidden, (IMP *)&OrigSetLabelHidden);
    // sub_52e8 VERIFIED: icon-model class = first of DBIconModel /
    // SBHIconModel / SBIconModel that exists. (Ownerless until the
    // closure pass — now DEFINED above in this file; this extern is
    // the installer's local declaration.)
    extern Class SCPIconModelClass(void);
    MSHookMessageEx(SCPIconModelClass(), @selector(isIconVisible:),
                    (IMP)SCPHook_IsIconVisible, (IMP *)&OrigIsIconVisible);

    OMCCheckHooks(@"SplitScreen", @[
        @"DashBoard +_newApplicationLibrary",
        @"DBApplicationInfo -_loadFromProxy:",
        @"DBDashboardHomeViewController -initWithEnvironment:",
        @"DBDashboardHomeViewController -viewDidLayoutSubviews",
        @"DBApplicationLaunchInfo +launchInfoForApplication:",
        @"DBApplicationLaunchInfo +launchInfoForApplication:withActivationSettings:",
        @"SBIconListGridLayoutConfiguration -iconImageInfo",
        [NSString stringWithFormat:@"%s -isIconVisible:", class_getName(SCPIconModelClass())],
        @"SBIconListGridLayoutConfiguration -numberOfLandscapeColumns",
        @"SBIconListGridLayoutConfiguration -numberOfLandscapeRows",
        @"SBIconView -setLabelHidden:",
    ]);

    // +maxLabelSizeForIconImageSize: on CARIconView (objc_getClass) or,
    // failing that, DBIconView (OMCCarClass) — only when the class responds
    // (VERIFIED, with Vietnamese fallback log lines in the original).
    Class iconViewClass = objc_getClass("CARIconView");
    if (!iconViewClass) iconViewClass = OMCCarClass("DBIconView");
    if (iconViewClass &&
        [iconViewClass respondsToSelector:NSSelectorFromString(@"maxLabelSizeForIconImageSize:")]) {
        MSHookMessageEx(object_getClass(iconViewClass),
                        @selector(maxLabelSizeForIconImageSize:),
                        (IMP)SCPHook_MaxLabelSize,
                        (IMP *)&OrigMaxLabelSize);
        OMCLogWrite(@"SplitScreen", [NSString stringWithFormat:
            @"HomeScreen: ten app du phong qua +[%@ maxLabelSizeForIconImageSize:]",
            NSStringFromClass(iconViewClass)]);
    } else {
        OMCLogWrite(@"SplitScreen", [NSString stringWithFormat:
            @"HomeScreen: khong co +maxLabelSizeForIconImageSize: (%@), ten app chi qua setLabelHidden:",
            iconViewClass ? NSStringFromClass(iconViewClass) : @"khong co lop icon"]);
    }
    if (!OMCCarClass("DashBoard"))
        OMCLogWrite(@"SplitScreen", @"AppIcons: khong co lop DashBoard, icon app iPhone khong chen duoc");
    if (!objc_getClass("SBIconListGridLayoutConfiguration"))
        OMCLogWrite(@"SplitScreen", @"HomeScreen: khong co SBIconListGridLayoutConfiguration, Co icon khong doi duoc tren iOS nay");

    notify_register_dispatch("com.anlai.omnicar/prefschanged", &scpPrefsChangedToken,
                             dispatch_get_main_queue(),
                             ^(int token) { SCPHandlePrefsChanged(); });
}

// __init_1 (0x58b4) VERIFIED end-to-end. Runs in CarPlayApp only.
__attribute__((constructor))
static void SCPInitDashboardHooks(void) {
    if (!SCPHostIsCarPlayApp()) return;
    if (!OMCCrashGuard(@"splitScreen")) return;
    OMCLogWrite(@"SplitScreen", @"loaded into CarPlay");

    Class dashboard = OMCCarClass("DBDashboard");
    MSHookMessageEx(dashboard, @selector(sceneFrameForAppInfo:proxyAppInfo:),
                    (IMP)Hook_sceneFrameForAppInfo, (IMP *)&orig_DBDashboard_sceneFrameForAppInfo);
    MSHookMessageEx(dashboard, @selector(safeAreaInsetsForAppInfo:proxyAppInfo:),
                    (IMP)Hook_safeAreaInsetsForAppInfo, (IMP *)&orig_DBDashboard_safeAreaInsetsForAppInfo);
    MSHookMessageEx(dashboard, @selector(_handleHomeEvent:),
                    (IMP)Hook_handleHomeEvent, (IMP *)&orig_DBDashboard_handleHomeEvent);
    MSHookMessageEx(dashboard, @selector(invalidate),
                    (IMP)Hook_invalidate, (IMP *)&orig_DBDashboard_invalidate);
    MSHookMessageEx(dashboard, @selector(_launchAppWithInfo:forURL:),
                    (IMP)Hook_launchAppWithInfo, (IMP *)&orig_DBDashboard_launchAppWithInfo);

    Class rootVC = OMCCarClass("DBDashboardRootViewController");
    MSHookMessageEx(rootVC, @selector(presentBaseViewController:animated:launchSource:completion:),
                    (IMP)Hook_presentBaseViewController, (IMP *)&orig_RootVC_presentBaseViewController);
    MSHookMessageEx(rootVC, @selector(dismissBaseViewControllerAnimated:completion:),
                    (IMP)Hook_dismissBaseViewController, (IMP *)&orig_RootVC_dismissBaseViewController);
    MSHookMessageEx(rootVC, @selector(viewDidLayoutSubviews),
                    (IMP)Hook_RootVC_viewDidLayoutSubviews, (IMP *)&orig_RootVC_viewDidLayoutSubviews);
    MSHookMessageEx(rootVC, @selector(viewDidAppear:),
                    (IMP)Hook_RootVC_viewDidAppear, (IMP *)&orig_RootVC_viewDidAppear);

    Class sceneVC = OMCCarClass("DBApplicationSceneViewController");
    MSHookMessageEx(sceneVC, @selector(backgroundSceneWithCompletion:),
                    (IMP)Hook_backgroundSceneWithCompletion, (IMP *)&orig_SceneVC_backgroundSceneWithCompletion);
    MSHookMessageEx(sceneVC, @selector(deactivateSceneWithReasonMask:),
                    (IMP)Hook_deactivateSceneWithReasonMask, (IMP *)&orig_SceneVC_deactivateSceneWithReasonMask);
    MSHookMessageEx(sceneVC, @selector(sceneManager:didDestroyScene:),
                    (IMP)Hook_sceneManagerDidDestroyScene, (IMP *)&orig_SceneVC_sceneManagerDidDestroyScene);

    // VERIFIED QUIRK (probable original bug): the original tests
    // objc_getClass("DBDashboard") — the cstring left in the register from
    // the first OMCCarClass call — and only installs the
    // FBSDisplayLayoutPublisher hook when that returns nil. Since
    // DBDashboard IS resolvable inside CarPlayApp (it was just hooked
    // above), the addElement: hook is effectively never installed.
    if (!objc_getClass("DBDashboard")) {
        MSHookMessageEx(objc_getClass("FBSDisplayLayoutPublisher"), @selector(addElement:),
                        (IMP)Hook_addElement, (IMP *)&orig_FBSDisplayLayoutPublisher_addElement);
    }

    OMCCheckHooks(@"SplitScreen", nil);   // second name list at 0x80338 in the original

    NSDistributedNotificationCenter *center = [NSDistributedNotificationCenter defaultCenter];
    NSOperationQueue *mainQueue = [NSOperationQueue mainQueue];
    [center addObserverForName:SCPNoteBridgeState object:nil queue:mainQueue
                    usingBlock:^(NSNotification *n) { SCPBridgeStateBlock(n); }];
    [center addObserverForName:SCPNoteBridgeHandleTap object:nil queue:mainQueue
                    usingBlock:^(NSNotification *n) { SCPBridgeHandleTapBlock(n); }];
    [center addObserverForName:SCPNoteBridgeHandleDrag object:nil queue:mainQueue
                    usingBlock:^(NSNotification *n) { SCPBridgeHandleDragBlock(n); }];
    [center addObserverForName:SCPNoteBridgeBarAction object:nil queue:mainQueue
                    usingBlock:^(NSNotification *n) { SCPBridgeBarActionBlock(n); }];
    [center addObserverForName:SCPNoteBridgeBarDismiss object:nil queue:mainQueue
                    usingBlock:^(NSNotification *n) { SCPBridgeBarDismissBlock(n); }];
    [center addObserverForName:SCPNoteBridgeKnobTouch object:nil queue:mainQueue
                    usingBlock:^(NSNotification *n) { SCPBridgeKnobTouchBlock(n); }];
    [center addObserverForName:SCPNoteNativeCommand object:nil queue:mainQueue
                    usingBlock:^(NSNotification *n) { SCPNativeCommandBlock(n); }];
}
