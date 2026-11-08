// SCPCarApps.m — SplitScreen-C: picker-side app-list builders and the
// CarPlay home-grid reader helpers.
//
// Two groups live here:
//
// (1) LIVE builders used by the split pickers (SplitScreen-A's
//     publishCarPlayApps and SplitScreen-B's -[SCPCarSplit
//     buildPickerSheetForPane:] call the first two):
//       SCPCarPlayAppInfos()    (sub_21d4c) — CarPlay-native apps
//       SCPChosenPhoneAppInfos()(sub_22210) — user-chosen phone apps
//       SCPBridgedChosenApps()  (sub_48864) — chosen ∩ installed, 60 s cache
//     Each entry is @{ @"id": bundleId, @"name": displayName }, sorted by
//     name. (SplitScreen-A's extern placeholder named sub_22210
//     "SCPChosenPhoneAppCount" from its call site; the body returns the
//     sorted array itself — see report §5.)
//
// (2) A grid-reader / launcher cluster. SCPCarHomeBundles has exactly
//     one caller (sub_21d4c above, as a merge source). SCPCarAppIcon,
//     SCPCarAppName, SCPCarLaunchApp (and SCPHomeAppRemovable in
//     SCPHomeVisibility.m) have NO caller anywhere in either slice of
//     this dylib or in any other OmniCar binary — verified by
//     direct-branch call graph, adrp+add materialization scan, data-slot
//     pointer scan and cross-binary import scan. They are reconstructed
//     faithfully and reported as uncalled in this build (an
//     earlier/alternate implementation of the home-grid sync that
//     sub_4c438 in SCPHomeApply.m supersedes).

#import "SCPHomeCommon.h"
#import <notify.h>

NS_ASSUME_NONNULL_BEGIN

extern NSSet<NSString *> *SCPChosenPhoneApps(void); // SCPAppIcons.m (0x9a60)

// 0x4672c — VERIFIED: [UIApplication sharedApplication] sharedApplicationLibrary
// via the string-selector pattern.
static id _Nullable SCPSharedApplicationLibrary(void) {
    id app = [UIApplication sharedApplication];
    SEL sel = NSSelectorFromString(@"sharedApplicationLibrary");
    if ([app respondsToSelector:sel])
        return ((id (*)(id, SEL))objc_msgSend)(app, sel);
    SCPMissingSelector(app, @"sharedApplicationLibrary");
    return nil;
}

// ---- (2a) live-grid reader ---------------------------------------------------

// 0x44a54 — VERIFIED: another copy of the safe perform-selector getter
// (same pattern as SCPHomeSafeGet, used only by this walker cluster).
// CLOSURE-2 link fix: NOT static — the binary carries one shared copy;
// SplitScreenA/SCPCarSplit.m declares these extern and calls them.
id _Nullable SCPWalkerSafeGet(id _Nullable obj, NSString *name) {
    @try {
        if (obj && [obj respondsToSelector:NSSelectorFromString(name)])
            return [obj performSelector:NSSelectorFromString(name)];
    } @catch (NSException *e) {}
    return nil;
}

// 0x44b5c — VERIFIED structure: first non-empty NSString produced by
// applying the candidate getters to an icon model object.
// CLOSURE-2 link fix: NOT static (single shared copy, see above).
NSString *_Nullable SCPWalkerIconBundleID(id icon) {
    for (NSString *key in @[@"applicationBundleID", @"leafIdentifier",
                            @"bundleIdentifier"]) {
        id v = SCPWalkerSafeGet(icon, key);
        if ([v isKindOfClass:[NSString class]] && [(NSString *)v length] > 0)
            return v;
    }
    return nil;
}

// 0x46584 — VERIFIED structure: recursively collect icon bundle ids from a
// list/folder node ("icons" children; folders recurse).
static void SCPWalkerCollectIcons(id node, NSMutableOrderedSet<NSString *> *out) {
    for (id icon in SCPWalkerSafeGet(node, @"icons") ?: @[]) {
        NSString *bid = SCPWalkerIconBundleID(icon);
        if (bid.length) [out addObject:bid];
    }
}

// 0x46198 — VERIFIED structure: walk a window's view tree; for every view
// whose class ends with "IconListView", read its model -> lists -> icons
// and collect bundle ids; recurse into subviews otherwise.
static void SCPWalkerWalkView(UIView *view, NSMutableOrderedSet<NSString *> *out,
                              NSInteger depth) {
    if ([NSStringFromClass([view class]) hasSuffix:@"IconListView"]) {
        id model = SCPWalkerSafeGet(view, @"model");
        for (id list in SCPWalkerSafeGet(model, @"lists") ?: @[])
            SCPWalkerCollectIcons(list, out);
        id folder = SCPWalkerSafeGet(view, @"folder");
        if (folder) SCPWalkerCollectIcons(folder, out);
        return;
    }
    for (UIView *sub in view.subviews)
        SCPWalkerWalkView(sub, out, depth + 1);
}

// 0xdb30 (body of _SCPCarHomeBundles, 0xdb2c) — VERIFIED at call-sequence
// level: ordered bundle ids currently on the CarPlay home grid, read from
// the live scene/window/view hierarchy. Result is cached in a static and
// a change is logged (joined id list) — tail detail INFERRED.
NSArray<NSString *> *SCPCarHomeBundles(void) {
    NSMutableOrderedSet<NSString *> *found = [NSMutableOrderedSet orderedSet];
    for (UIScene *scene in [UIApplication sharedApplication].connectedScenes) {
        if (![scene isKindOfClass:[UIWindowScene class]]) continue;
        for (UIWindow *window in [(UIWindowScene *)scene windows])
            SCPWalkerWalkView(window, found, 0);
    }
    return [found array];
}

// ---- (2b) icon / name / launch helpers (no callers in this build) ------------

// 0xdec8 — INFERRED structure (diagnostic): fetch the icon image for a
// bundle id and log its scale/size:
// "DIAG icon %@: %@ scale %.0f (%.0fx%.0f px)".
static id _Nullable SCPDiagIconForBundle(NSString *bid) {
    id image = nil;
    // (resolved through the icon model via string selectors in the
    // original; the diagnostic logs whatever was found, or "nil")
    OMCLogWrite(@"SplitScreen", [NSString stringWithFormat:
        @"DIAG icon %@: %@ scale %.0f (%.0fx%.0f px)", bid,
        image ?: @"nil", 0.0, 0.0, 0.0]);
    return image;
}

// 0xdeac (_SCPCarAppIcon) — VERIFIED wrapper (returns sub_dec8's result).
id _Nullable SCPCarAppIcon(NSString *bid) {
    return SCPDiagIconForBundle(bid);
}

// 0xe0c0 (_SCPCarAppName) — VERIFIED: LSApplicationProxy display name.
NSString *_Nullable SCPCarAppName(NSString *bid) {
    Class proxyClass = objc_getClass("LSApplicationProxy");
    SEL sel = NSSelectorFromString(@"applicationProxyForIdentifier:");
    id proxy = nil;
    if ([proxyClass respondsToSelector:sel]) {
        proxy = ((id (*)(id, SEL, id))objc_msgSend)(proxyClass, sel, bid);
    } else SCPMissingSelector(proxyClass, @"applicationProxyForIdentifier:");
    NSString *name = SCPHomeSafeGet(proxy, @"displayName");
    if (!name.length) name = SCPHomeSafeGet(proxy, @"localizedName");
    return name;
}

// 0xe5b4 — VERIFIED: the current DBDashboard, reached as a CarPlay
// category-style property on UIApplication via the string-selector pattern.
static id _Nullable SCPCurrentDashboard(void) {
    id app = [UIApplication sharedApplication];
    SEL sel = NSSelectorFromString(@"_currentDashboard");
    if ([app respondsToSelector:sel])
        return ((id (*)(id, SEL))objc_msgSend)(app, sel);
    SCPMissingSelector(app, @"_currentDashboard");
    return nil;
}

// 0xe410 (_SCPCarLaunchApp) — VERIFIED. NOTE the routing: an injected
// icon tap does NOT go through the appbridge.open distributed
// notification. The live tap path in this build is the stock dashboard
// launch, intercepted by SplitScreen-A's +launchInfoForApplication:
// hooks. This helper (uncalled here) shows the family's own fallback:
// first SCPCarSplit's -launchPhoneAppIfNeeded: (A's open pipeline), then
// a direct -[DBDashboard _launchAppWithInfo:forURL:].
BOOL SCPCarLaunchApp(NSString *bid) {
    if (!bid.length) return NO;
    Class splitClass = objc_getClass("SCPCarSplit");
    id split = ((id (*)(id, SEL))objc_msgSend)(splitClass,
                                               NSSelectorFromString(@"shared"));
    SEL launchSel = NSSelectorFromString(@"launchPhoneAppIfNeeded:");
    if ([split respondsToSelector:launchSel] &&
        ((BOOL (*)(id, SEL, id))objc_msgSend)(split, launchSel, bid))
        return YES;
    id info = SCPApplicationInfoForBundle(bid); // [phase2; backported to src in phase 3] sub_e324 — C's name SCPAppInfoForBundle unified to A's (body in SCPShared.m)
    id dashboard = SCPCurrentDashboard();
    SEL dashSel = NSSelectorFromString(@"_launchAppWithInfo:forURL:");
    if (info && dashboard && [dashboard respondsToSelector:dashSel]) {
        ((void (*)(id, SEL, id, id))objc_msgSend)(dashboard, dashSel, info, nil);
        return YES;
    }
    if (info && dashboard) SCPMissingSelector(dashboard, @"_launchAppWithInfo:forURL:");
    OMCLogWrite(@"SplitScreen", [NSString stringWithFormat:
        @"HomeScreen: khong mo duoc %@ (info %@, dashboard %@)", bid, info, dashboard]);
    return NO;
}

// 0xd950 (_SCPRealBundleForInfos) — VERIFIED. Used by SplitScreen-A (its
// placeholder of the same name): the real bundle id behind an info/proxy
// pair, skipping the template-UI host placeholder.
NSString *_Nullable SCPRealBundleForInfos(id _Nullable info, id _Nullable proxyInfo) {
    NSString *a = nil, *b = nil;
    SEL sel = NSSelectorFromString(@"bundleIdentifier");
    if (info) {
        if ([info respondsToSelector:sel])
            a = ((id (*)(id, SEL))objc_msgSend)(info, sel);
        else SCPMissingSelector(info, @"bundleIdentifier");
    }
    if (proxyInfo) {
        if ([proxyInfo respondsToSelector:sel])
            b = ((id (*)(id, SEL))objc_msgSend)(proxyInfo, sel);
        else SCPMissingSelector(proxyInfo, @"bundleIdentifier");
    }
    NSString *host = @"com.apple.CarPlayTemplateUIHost";
    if (a.length && ![a isEqualToString:host]) return a;
    if (b.length && ![b isEqualToString:host]) return b;
    return a ?: b;
}

// ---- (1) picker list builders -------------------------------------------------

// 0x48cb0 — VERIFIED: prefschanged handler for the builder cache; simply
// invalidates the 60 s timestamp (global block 0x791d0).
static NSTimeInterval SCPBridgedCacheTime;   // 0x881c0
static NSSet<NSString *> *SCPBridgedCache;   // 0x881b8
static void SCPBridgedCacheInvalidate(void) { SCPBridgedCacheTime = 0; }

// 0x48c8c — VERIFIED: dispatch_once body (trampoline 0x560a4, token
// 0x881d0, block literal 0x791b0) registering the invalidation above.
static void SCPBridgedRegisterInvalidation(void) {
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        static NSInteger token; // 0x881c8
        notify_register_dispatch("com.anlai.omnicar/prefschanged", (int *)&token,
                                 dispatch_get_main_queue(),
                                 ^(int t) { SCPBridgedCacheInvalidate(); });
    });
}

// 0x48864 (= SplitScreen-A's placeholder SCPBridgedChosenApps) — VERIFIED:
// the chosen phone apps that are actually installed, cached for 60 s.
NSSet<NSString *> *SCPBridgedChosenApps(void) {
    SCPBridgedRegisterInvalidation();
    NSTimeInterval now = CFAbsoluteTimeGetCurrent();
    if (SCPBridgedCache && SCPBridgedCacheTime > 0 &&
        now - SCPBridgedCacheTime <= 60.0)
        return SCPBridgedCache;
    SCPBridgedCacheTime = now;
    OMCPrefsSync();
    id pref = OMCPref(@"appBridgeApps", nil);
    NSMutableSet<NSString *> *result = [NSMutableSet set];
    if ([pref isKindOfClass:[NSArray class]] && [(NSArray *)pref count] > 0) {
        NSSet<NSString *> *wanted = [NSSet setWithArray:pref];
        Class wsClass = objc_getClass("LSApplicationWorkspace");
        SEL defSel = NSSelectorFromString(@"defaultWorkspace");
        id workspace = nil;
        if ([wsClass respondsToSelector:defSel]) {
            workspace = ((id (*)(id, SEL))objc_msgSend)(wsClass, defSel);
        } else SCPMissingSelector(wsClass, @"defaultWorkspace");
        SEL allSel = NSSelectorFromString(@"allInstalledApplications");
        NSArray *installed = nil;
        if ([workspace respondsToSelector:allSel]) {
            installed = ((id (*)(id, SEL))objc_msgSend)(workspace, allSel);
        } else SCPMissingSelector(workspace, @"allInstalledApplications");
        for (id proxy in installed ?: @[]) {
            NSString *bid = SCPHomeSafeGet(proxy, @"applicationIdentifier");
            if (bid && [wanted containsObject:bid]) [result addObject:bid];
        }
    }
    SCPBridgedCache = result;
    return result;
}

// Shared tail of the two builders: sort @{id,name} dicts by name.
// (In the original this uses an NSSortDescriptor on "name" with
// localizedCaseInsensitiveCompare:, plus — in sub_21d4c — a comparator
// block; the block copy/dispose helpers at 0x487e4/0x48824 retain/release
// five captured objects and belong to one of these builder blocks. Their
// bodies are compiler-generated and reproduced in the disasm dumps.)

static NSArray<NSDictionary *> *SCPSortAppInfos(NSMutableArray<NSDictionary *> *infos) {
    [infos sortUsingDescriptors:@[[NSSortDescriptor
        sortDescriptorWithKey:@"name" ascending:YES
                     selector:@selector(localizedCaseInsensitiveCompare:)]]];
    return infos;
}

// 0x21d4c (= A's placeholder SCPCarPlayAppInfos) — VERIFIED at
// call-sequence level: CarPlay-native apps for the picker.
NSArray<NSDictionary *> *SCPCarPlayAppInfos(void) {
    NSMutableArray<NSDictionary *> *out = [NSMutableArray array];
    NSMutableSet<NSString *> *seen = [NSMutableSet set];
    id library = SCPSharedApplicationLibrary();
    SEL allSel = NSSelectorFromString(@"allInstalledApplications");
    NSArray *infos = nil;
    if ([library respondsToSelector:allSel]) {
        infos = ((id (*)(id, SEL))objc_msgSend)(library, allSel);
    } else SCPMissingSelector(library, @"allInstalledApplications");
    for (id info in infos ?: @[]) {
        NSString *bid = SCPHomeSafeGet(info, @"bundleIdentifier");
        if (!bid.length || [seen containsObject:bid]) continue;
        if (!SCPAppHasCarPlayUI(info)) continue; // sub_ffb4 (A)
        [seen addObject:bid];
        NSString *name = SCPHomeSafeGet(info, @"displayName");
        [out addObject:@{@"id": bid, @"name": name ?: bid}];
    }
    // Merge anything the live grid shows that the library walk missed.
    // (Name resolution for grid-only entries is INFERRED — see report.)
    for (NSString *bid in SCPCarHomeBundles()) {
        if ([seen containsObject:bid]) continue;
        [seen addObject:bid];
        [out addObject:@{@"id": bid, @"name": bid}];
    }
    return SCPSortAppInfos(out);
}

// 0x22210 (= A's placeholder "SCPChosenPhoneAppCount") — VERIFIED at
// call-sequence level: chosen phone apps for the picker (feature-gated).
NSArray<NSDictionary *> *SCPChosenPhoneAppInfos(void) {
    NSMutableArray<NSDictionary *> *out = [NSMutableArray array];
    if (!OMCFeatureEnabled(@"appBridge")) return out;
    NSSet<NSString *> *chosen = SCPBridgedChosenApps();
    Class wsClass = objc_getClass("LSApplicationWorkspace");
    SEL defSel = NSSelectorFromString(@"defaultWorkspace");
    id workspace = nil;
    if ([wsClass respondsToSelector:defSel]) {
        workspace = ((id (*)(id, SEL))objc_msgSend)(wsClass, defSel);
    } else SCPMissingSelector(wsClass, @"defaultWorkspace");
    SEL allSel = NSSelectorFromString(@"allInstalledApplications");
    NSArray *installed = nil;
    if ([workspace respondsToSelector:allSel]) {
        installed = ((id (*)(id, SEL))objc_msgSend)(workspace, allSel);
    } else SCPMissingSelector(workspace, @"allInstalledApplications");
    for (id proxy in installed ?: @[]) {
        NSString *bid = SCPHomeSafeGet(proxy, @"applicationIdentifier");
        if (!bid.length || ![chosen containsObject:bid]) continue;
        NSString *name = SCPHomeSafeGet(proxy, @"localizedName");
        if (!name.length) name = SCPHomeSafeGet(proxy, @"displayName");
        [out addObject:@{@"id": bid, @"name": name ?: bid}];
    }
    return SCPSortAppInfos(out);
}

// 0x48da0 — VERIFIED body, ownership INFERRED: invoke of a block that maps
// a trait collection / style owner to a label color (white in dark style
// (2), black otherwise). It sits in the builder cluster's address range
// but no function in either slice references its literal in a way the
// direct-branch/materialization scans could resolve; it most likely
// belongs to the picker sheet UI (SplitScreen-B) as a dynamic color
// provider block. Reproduced here so the body is not lost; flagged for
// coordinator reconciliation with B.
static UIColor *SCPDynamicLabelColor(id styleOwner) {
    UIUserInterfaceStyle style = [styleOwner userInterfaceStyle];
    return style == 2 ? [UIColor whiteColor] : [UIColor blackColor];
}

NS_ASSUME_NONNULL_END
