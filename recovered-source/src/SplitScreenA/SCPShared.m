// SCPShared.m — reconstructed from disassembly (agent A).
// The module's file-static helpers. Each carries its original address and
// status; full evidence in SplitScreenA_REPORT.md.

#import "SCPShared.h"
#import "SCPSmallClasses.h"
#import <objc/message.h>

// Distributed-notification names (VERIFIED string xrefs).
NSString * const SCPNotePrefsChanged     = @"com.anlai.omnicar/prefschanged";
NSString * const SCPNoteNativeCommand    = @"com.anlai.omnicar/splitscreen.native";
NSString * const SCPNoteNativeAck        = @"com.anlai.omnicar/splitscreen.ack";
NSString * const SCPNoteScreenReady      = @"com.anlai.omnicar/splitscreen.ready";
NSString * const SCPNoteKillApp          = @"com.anlai.omnicar/splitscreen.kill";
NSString * const SCPNoteURL              = @"com.anlai.omnicar/url";
NSString * const SCPNoteBridgeOpen       = @"com.anlai.omnicar/appbridge.open";
NSString * const SCPNoteBridgeClose      = @"com.anlai.omnicar/appbridge.close";
NSString * const SCPNoteBridgeCloseAll   = @"com.anlai.omnicar/appbridge.closeall";
NSString * const SCPNoteBridgeFrame      = @"com.anlai.omnicar/appbridge.frame";
NSString * const SCPNoteBridgeState      = @"com.anlai.omnicar/appbridge.state";
NSString * const SCPNoteBridgeShield     = @"com.anlai.omnicar/appbridge.shield";
NSString * const SCPNoteBridgeKnobs      = @"com.anlai.omnicar/appbridge.knobs";
NSString * const SCPNoteBridgeHandleTap  = @"com.anlai.omnicar/appbridge.handletap";
NSString * const SCPNoteBridgeHandleDrag = @"com.anlai.omnicar/appbridge.handledrag";
NSString * const SCPNoteBridgeBarAction  = @"com.anlai.omnicar/appbridge.baraction";
NSString * const SCPNoteBridgeBarDismiss = @"com.anlai.omnicar/appbridge.bardismiss";
NSString * const SCPNoteBridgeKnobTouch  = @"com.anlai.omnicar/appbridge.knobtouch";

// Guarded dynamic message send used all over the module: the original calls
// NSSelectorFromString + respondsToSelector:, and on failure calls
// SCPMissingSelector(obj, selName) and yields nil. Written once here; the
// original inlines this pattern at every call site (VERIFIED pattern).
id SCPGuardedSend(id obj, NSString *selName) { // [phase1 fix 19; backported to src in phase 3] de-static'd: called cross-TU from SCPSpringBoardHooks.m
    SEL sel = NSSelectorFromString(selName);
    if ([obj respondsToSelector:sel])
        return ((id (*)(id, SEL))objc_msgSend)(obj, sel);
    SCPMissingSelector(obj, selName);
    return nil;
}

// sub_e5b4 VERIFIED: the current CarPlay dashboard object.
id SCPDashboardObject(void) {
    UIApplication *app = [UIApplication sharedApplication];
    return SCPGuardedSend(app, @"_currentDashboard");
}

// sub_12658 VERIFIED: root view controller of the dashboard.
id SCPDashboardRootViewController(void) {
    id dashboard = SCPDashboardObject();
    if (!dashboard) return nil;
    return SCPGuardedSend(dashboard, @"rootViewController");
}

// sub_162ac VERIFIED: build a DBEvent and deliver it to the dashboard.
void SCPSendDashboardEvent(NSInteger type, id context) {
    id dashboard = SCPDashboardObject();
    if (!dashboard) return;
    Class eventClass = OMCCarClass("DBEvent");
    SEL makeSel = NSSelectorFromString(@"eventWithType:context:");
    id event = nil;
    if ([eventClass respondsToSelector:makeSel])
        event = ((id (*)(id, SEL, NSInteger, id))objc_msgSend)(eventClass, makeSel, type, context);
    else
        SCPMissingSelector(eventClass, NSStringFromSelector(makeSel));
    if (!event) return;
    SEL handleSel = NSSelectorFromString(@"handleEvent:");
    if ([dashboard respondsToSelector:handleSel])
        ((void (*)(id, SEL, id))objc_msgSend)(dashboard, handleSel, event);
    else
        SCPMissingSelector(dashboard, NSStringFromSelector(handleSel));
}

// sub_12efc VERIFIED: main-queue dispatch_after (delay > 0) or dispatch_async.
void SCPDispatchAfter(double delaySeconds, void (^block)(void)) {
    void (^wrapper)(void) = ^{ block(); };   // original: trampoline sub_46814
    if (delaySeconds > 0) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delaySeconds * 1e9)),
                       dispatch_get_main_queue(), wrapper);
    } else {
        dispatch_async(dispatch_get_main_queue(), wrapper);
    }
}

// sub_75cc VERIFIED: the module-wide @catch logger. (Phase-2 seam fix:
// callStackSymbols is sent to the exception argument itself — at 0x75f8
// the receiver is x19 = x1 — not to NSThread.)
void SCPExceptionLog(const char *where, NSException *exception) {
    OMCLogWrite(@"SplitScreen",
        [NSString stringWithFormat:@"LOI trong %s: %@\n%@", where, exception,
                                   [exception callStackSymbols]]);
}

// sub_4672c VERIFIED (dump src/SplitScreenC/disasm/sub_4672c.txt; the VA
// was also re-disassembled from the payload dylib and matched 58/58
// lines): [UIApplication sharedApplication] -> guarded
// sharedApplicationLibrary. The returned object is the
// FBSApplicationLibrary, and it — not an LSApplicationWorkspace — is
// the receiver sub_e324 sends applicationInfoForBundleIdentifier: to.
// (The earlier INFERRED body used LSApplicationWorkspace
// defaultWorkspace; that instance has no
// applicationInfoForBundleIdentifier:, which is exactly the THIEU
// METHOD line in the 2026-11-08 21:56 device log and what closed the
// isCarPlayApp: gate for every app.) The binary tests
// respondsToSelector: twice: the first test's failure returns nil
// silently, the second's logs via SCPMissingSelector (the same
// double-test pattern as SCPInfoBool / sub_17d84).
static id SCPAppLibrary(void) {
    id app = [UIApplication sharedApplication];
    SEL sel = NSSelectorFromString(@"sharedApplicationLibrary");
    if (![app respondsToSelector:sel]) return nil;
    if ([app respondsToSelector:sel])
        return ((id (*)(id, SEL))objc_msgSend)(app, sel);
    SCPMissingSelector(app, @"sharedApplicationLibrary");
    return nil;
}

// sub_e324 VERIFIED: applicationInfoForBundleIdentifier: on the shared
// application library obtained via sub_4672c.
id SCPApplicationInfoForBundle(NSString *bundleID) {
    id workspace = SCPAppLibrary();
    if (!workspace || !bundleID) return nil;
    SEL sel = NSSelectorFromString(@"applicationInfoForBundleIdentifier:");
    if ([workspace respondsToSelector:sel])
        return ((id (*)(id, SEL, id))objc_msgSend)(workspace, sel, bundleID);
    SCPMissingSelector(workspace, NSStringFromSelector(sel));
    return nil;
}

// sub_101bc VERIFIED (dump disasm/sub_101bc.txt): length, then the
// appBridge feature gate (@0x101e0), then injected -> YES; otherwise
// the app info runs through sub_e324 + sub_ffb4 and a REAL CarPlay app
// is NOT hosted (ffb4 YES -> NO @0x1022c); only a non-CarPlay app in
// the sub_48864 set falls through to containsObject:. There is NO
// nil-info gate in the binary: ffb4(nil) is NO, so an app with no info
// still reaches the chosen-set test. (An earlier reconstruction added
// `if (!SCPApplicationInfoForBundle(...)) return NO;` — combined with
// the sub_4672c receiver defect, which made app info always nil, it
// killed the hosted branch outright.) sub_48864 itself is the chosen
// set INTERSECTED with installed apps (LSApplicationWorkspace
// allInstalledApplications, ~60 s cache); SCPBridgedChosenApps() in
// SCPCarApps.m carries that logic.
BOOL SCPIsHostedApp(NSString *bundleID) {
    if (!bundleID.length) return NO;
    if (!OMCFeatureEnabled(@"appBridge")) return NO;
    if (SCPIsInjectedPhoneApp(bundleID)) return YES;
    if (SCPAppHasCarPlayUI(SCPApplicationInfoForBundle(bundleID))) return NO;
    extern id SCPBridgedChosenApps(void);   // sub_48864
    return [SCPBridgedChosenApps() containsObject:bundleID];
}

// sub_14fa4 VERIFIED.
BOOL SCPVCIsHosted(id vc) {
    return [vc isKindOfClass:[SCPHostedAppVC class]];
}

// sub_1ab70 VERIFIED (final closure — line-read end to end, dump
// src/SplitScreenA/disasm/sub_1ab70.txt): NOT an ivar walk at all. The VC
// is KVC-probed for its scene with the constant key list
// @[@"scene", @"_scene"] (NSConstantArray in __DATA @0x80530), in order;
// the first non-nil value wins. If both miss, the fallback probes
// -valueForKey:@"sceneHandle" and returns the handle's own @"scene"
// value. Exception discipline from the LSDA pads: a probe that throws
// inside the key loop is swallowed and the next key is tried; a throwing
// fallback returns nil. (The old INFERRED body — a single guarded
// @"scene" send — was the module's oldest stub.)
id SCPSceneOfVC(id vc) {
    for (NSString *key in @[@"scene", @"_scene"]) {
        id scene = nil;
        @try { scene = [vc valueForKey:key]; } @catch (id) { }
        if (scene) return scene;
    }
    @try {
        id handle = [vc valueForKey:@"sceneHandle"];
        if (handle) {
            id scene = [handle valueForKey:@"scene"];
            if (scene) return scene;
        }
    } @catch (id) { }
    return nil;
}

// sub_1b13c VERIFIED (micro-closure; dump
// src/SplitScreenA/disasm/sub_1b13c.txt): direct scene-identifier probe,
// NOT a second scene walk. Both binary call sites (@0x1ae4c and @0x1ae64
// in -scene:destroyedForViewController:ownScene:) pass a scene object —
// first the destroyed scene, then the pane VC's ownScene — never a VC.
// The IMP first probes `identifier` with objc_opt_respondsToSelector:
// (@0x1b154-0x1b16c); a first-probe miss returns nil silently. Inside the
// exception-guarded second probe (@0x1b178-0x1b1a0), a miss calls
// SCPMissingSelector(scene, @"identifier") (@0x1b1b4-0x1b1c0), while a hit
// sends -identifier and returns its object unchanged (no description or
// other string conversion). A caught exception likewise yields nil.
// There is no SCPSceneOfVC call and no sceneHandle fallback in this IMP.
NSString *SCPSceneIdentifierOfVC(id scene) {
    SEL identifierSel = NSSelectorFromString(@"identifier");
    if (![scene respondsToSelector:identifierSel]) return nil;
    @try {
        if ([scene respondsToSelector:identifierSel])
            return ((id (*)(id, SEL))objc_msgSend)(scene, identifierSel);
        SCPMissingSelector(scene, @"identifier");
    } @catch (id) {
    }
    return nil;
}

// ===========================================================================
// [phase2 closure; backported to src in phase 3] Bodies for the cross-module helpers that A and C left as
// extern placeholders (SplitScreenA_REPORT §5 "the coordinator must
// reconcile"). Each transcribed from the annotated binary dump of the
// payload dylib (tools/disasm.py output), VA noted per function.
// ===========================================================================

// _SCPMissingSelector @ 0x4f330 — VERIFIED from dump: the SplitScreen-local
// 2-arg twin of OMCCommon's OMCMissingSelector (dedupe set + one log line
// per class/selector pair; NO iOS-version field, unlike the Core version).
void SCPMissingSelector(id object, NSString *selectorName) {
    if (!object) return;
    static NSMutableSet *seenMissing;         // bss 0x88208
    static dispatch_once_t seenMissingOnce;   // bss 0x88210
    dispatch_once(&seenMissingOnce, ^{ seenMissing = [NSMutableSet set]; });
    NSString *key = [NSString stringWithFormat:@"%@ %@",
                        NSStringFromClass([object class]), selectorName];
    @synchronized (seenMissing) {
        if ([seenMissing containsObject:key]) return;
        [seenMissing addObject:key];
    }
    OMCLogWrite(@"SplitScreen", [NSString stringWithFormat:
        @"THIEU METHOD: %@ khong co %@ -> bo qua",
        NSStringFromClass([object class]), selectorName]);
}

// sub_17d84 — VERIFIED from dump: guarded BOOL send of the selector named
// `key` on an app-info object; missing selector is reported via
// SCPMissingSelector. (The binary tests respondsToSelector: twice; the
// second test's failure path is the one that logs.)
BOOL SCPInfoBool(id info, NSString *key) {
    if (info == nil) return NO;
    SEL sel = NSSelectorFromString(key);
    if (![info respondsToSelector:sel]) {
        SCPMissingSelector(info, key);
        return NO;
    }
    return ((BOOL (*)(id, SEL))objc_msgSend)(info, sel);
}

// sub_ffb4 — VERIFIED from dump: YES when the app-info object represents a
// real, visible, fullscreen CarPlay app. (A's placeholder took the bundle
// id string; the binary reads bundleIdentifier from the info itself.
// B called the same function SCPProxyIsValid.)
BOOL SCPAppHasCarPlayUI(id appInfo) {
    if (appInfo == nil) return NO;
    NSString *bundleID = SCPGuardedSend(appInfo, @"bundleIdentifier");
    if (bundleID.length == 0) return NO;
    if ([bundleID isEqualToString:@"com.apple.CarPlayTemplateUIHost"] ||
        [bundleID isEqualToString:@"com.apple.CarPlayApp"] ||
        [bundleID isEqualToString:@"com.apple.CarPlaySettings"] ||
        [bundleID isEqualToString:@"com.apple.InCallService"]) return NO;
    if (SCPIsInjectedPhoneApp(bundleID)) return NO;
    SEL declSel = NSSelectorFromString(@"carPlayDeclaration");
    if (![appInfo respondsToSelector:declSel]) return NO;
    id declaration = SCPGuardedSend(appInfo, @"carPlayDeclaration");
    if (declaration == nil) return NO;
    if (SCPInfoBool(appInfo, @"isHidden")) return NO;
    return !SCPInfoBool(appInfo, @"presentsFullScreen");
}

// sub_8350 — VERIFIED from dump: a BOOL PREDICATE, not a key extractor
// (A's placeholder name/ABI were wrong): YES iff the element's
// `identifier` is an NSString equal to `candidate`.
BOOL SCPLayoutElementKey(id element, NSString *candidate) {
    if (![element respondsToSelector:@selector(identifier)]) return NO;
    id ident = ((id (*)(id, SEL))objc_msgSend)(element, @selector(identifier));
    if (![ident isKindOfClass:[NSString class]]) return NO;
    return [ident isEqualToString:candidate];
}

// sub_1a1b8 — VERIFIED from dump: un-hide + restore alpha on a detached
// view, recursing (depth cap 4) ONLY into subviews whose class name starts
// with _UIScene or _UITouchPassthrough. Returns YES iff any alpha was
// restored. (A's placeholder had (UIView*, BOOL); arg 2 is the depth —
// A's call site passes NO == 0.)
BOOL SCPResetDetachedView(UIView *view, NSInteger depth) {
    BOOL changed = NO;
    if (view == nil || (NSUInteger)depth > 4) return NO;
    if (view.hidden) view.hidden = NO;
    if (view.alpha < 1.0) { view.alpha = 1.0; changed = YES; }
    for (UIView *sub in view.subviews) {
        NSString *name = NSStringFromClass([sub class]);
        if ([name hasPrefix:@"_UIScene"] || [name hasPrefix:@"_UITouchPassthrough"])
            changed |= SCPResetDetachedView(sub, depth + 1);
    }
    return changed;
}

@interface UIImage (SCPPrivateIconAPI)
+ (UIImage *)_applicationIconImageForBundleIdentifier:(NSString *)bundleID
                                               format:(NSInteger)format
                                                scale:(double)scale;
@end

// sub_dec8 — VERIFIED from dump (name INFERRED per B report): the app icon
// via UIImage's private class method (format 2, scale 2.0), with a
// once-per-bundle DIAG log line. When the private selector is absent the
// function returns nil WITHOUT logging (dump branch 0xdf38).
UIImage *SCPAppIconForBundle(NSString *bundleID) {
    SEL sel = @selector(_applicationIconImageForBundleIdentifier:format:scale:);
    if (![UIImage respondsToSelector:sel]) return nil;
    UIImage *icon = [UIImage _applicationIconImageForBundleIdentifier:bundleID
                                                               format:2
                                                                scale:2.0];
    static NSMutableSet *loggedIcons;   // bss 0x881a0
    if (!loggedIcons) loggedIcons = [NSMutableSet set];
    if (bundleID != nil && ![loggedIcons containsObject:bundleID]) {
        [loggedIcons addObject:bundleID];
        NSString *sizeStr = icon ? NSStringFromCGSize(icon.size) : @"nil";
        OMCLogWrite(@"SplitScreen", [NSString stringWithFormat:
            @"DIAG icon %@: %@ scale %.0f (%.0fx%.0f px)", bundleID, sizeStr,
            (double)icon.scale,
            (double)(icon.size.width * icon.scale),
            (double)(icon.size.height * icon.scale)]);
    }
    return icon;
}
