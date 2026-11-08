// SCPHomeVisibility.m — SplitScreen-C: which icons the CarPlay home grid
// shows or hides.
//
// Data flow: the Settings side (Prefs module) writes two bundle-id lists,
// `homeScreenHiddenApps` and `homeScreenShownApps`, into the
// com.anlai.omnicar domain. This family caches them as sets, refreshes the
// caches (debounced) when prefs change, and the isIconVisible hook
// (SCPHomeHooks.m) consults SCPIconHiddenOnCar / SCPIconForcedOnCar.
//
// Hard protections (VERIFIED): the five stock communication apps in
// SCPProtectedBundles, anything with the com.apple.CarPlay prefix, and
// anything whose id contains "NowPlaying" can never be hidden; OmniCar's
// own injected phone apps can never be hidden either (they are how the
// user gets those apps at all), and a hidden entry only takes effect when
// the app is actually installed.

#import "SCPHomeCommon.h"

NS_ASSUME_NONNULL_BEGIN

static NSSet<NSString *> *SCPHiddenCache;   // 0x880e0
static NSSet<NSString *> *SCPShownCache;    // 0x880e8
static id SCPVisibilityLock;                // 0x880f0 (NSObject, once-created)
static NSInteger SCPHiddenRefreshCounter;   // 0x880f8
static NSMutableDictionary<NSString *, NSNumber *> *SCPInstalledCache; // 0x880110
static NSMutableSet<NSString *> *SCPLogOnceSet;                        // 0x880118

// Constant array at 0x80380 — VERIFIED contents.
static NSArray<NSString *> *SCPProtectedBundles(void) {
    return @[@"com.apple.mobilephone", @"com.apple.Music", @"com.apple.Maps",
             @"com.apple.MobileSMS", @"com.apple.InCallService"];
}

// 0xc338 + dispatch_once trampoline 0x5607c + once-block 0xd6c0 — VERIFIED
static id SCPHomeVisibilityLock(void) {
    static dispatch_once_t once; // token 0x88120
    dispatch_once(&once, ^{ SCPVisibilityLock = [[NSObject alloc] init]; });
    return SCPVisibilityLock;
}

// 0xc268 — VERIFIED: generic pref -> set reader (no feature gate).
static NSSet<NSString *> *SCPPrefBundleSet(NSString *key) {
    OMCPrefsSync();
    id v = OMCPref(key, nil);
    if ([v isKindOfClass:[NSArray class]]) return [NSSet setWithArray:v];
    return [NSSet set];
}

// 0xb78c — VERIFIED
NSSet<NSString *> *SCPHomeHiddenApps(void) {
    @synchronized (SCPHomeVisibilityLock()) {
        if (!SCPHiddenCache) SCPHiddenCache = SCPPrefBundleSet(@"homeScreenHiddenApps");
        return SCPHiddenCache;
    }
}

// 0xbc44 — VERIFIED
NSSet<NSString *> *SCPHomeShownApps(void) {
    @synchronized (SCPHomeVisibilityLock()) {
        if (!SCPShownCache) SCPShownCache = SCPPrefBundleSet(@"homeScreenShownApps");
        return SCPShownCache;
    }
}

// 0xb82c — VERIFIED: first non-empty NSString among the icon's
// applicationBundleID / leafIdentifier (constant key list at 0x80398).
static NSString *_Nullable SCPIconBundleID(id icon) {
    for (NSString *key in @[@"applicationBundleID", @"leafIdentifier"]) {
        id v = SCPHomeSafeGet(icon, key);
        if ([v isKindOfClass:[NSString class]] && [(NSString *)v length] > 0)
            return v;
    }
    return nil;
}

// 0xb310 — VERIFIED: cached "is the app installed" check.
static BOOL SCPAppIsInstalled(NSString *bid) {
    @synchronized (SCPHomeVisibilityLock()) {
        if (!SCPInstalledCache) SCPInstalledCache = [NSMutableDictionary dictionary];
        NSNumber *cached = SCPInstalledCache[bid];
        if (cached) return cached.boolValue;
    }
    BOOL installed;
    Class proxyClass = objc_getClass("LSApplicationProxy");
    SEL sel = NSSelectorFromString(@"applicationProxyForIdentifier:");
    id proxy = nil;
    if ([proxyClass respondsToSelector:sel]) {
        proxy = ((id (*)(id, SEL, id))objc_msgSend)(proxyClass, sel, bid);
    } else SCPMissingSelector(proxyClass, @"applicationProxyForIdentifier:");
    id state = SCPHomeSafeGet(proxy, @"appState");
    if (!proxy) installed = NO;
    else if (!state) installed = YES;
    else {
        SEL isSel = NSSelectorFromString(@"isInstalled");
        if ([state respondsToSelector:isSel])
            installed = ((BOOL (*)(id, SEL))objc_msgSend)(state, isSel);
        else { SCPMissingSelector(state, @"isInstalled"); installed = NO; }
    }
    @synchronized (SCPHomeVisibilityLock()) {
        SCPInstalledCache[bid] = @(installed);
    }
    return installed;
}

// 0xb9ac — VERIFIED: log once per (prefix + bundleId).
static void SCPHomeLogOnce(NSString *prefix, NSString *bid) {
    NSString *key = [prefix stringByAppendingString:bid];
    @synchronized (SCPHomeVisibilityLock()) {
        if (!SCPLogOnceSet) SCPLogOnceSet = [NSMutableSet set];
        if ([SCPLogOnceSet containsObject:key]) return;
        [SCPLogOnceSet addObject:key];
    }
    OMCLogWrite(@"SplitScreen", [NSString stringWithFormat:@"HomeScreen: %@ %@", prefix, bid]);
}

// Shared protection predicate (the NSString branch of 0xb5ec / 0xb1f8) — VERIFIED
static BOOL SCPBundleIsProtected(NSString *bid) {
    if ([bid isKindOfClass:[NSString class]] && bid.length > 0) {
        if ([SCPProtectedBundles() containsObject:bid]) return YES;
        if ([bid hasPrefix:@"com.apple.CarPlay"]) return YES;
        if ([bid rangeOfString:@"NowPlaying"].location != NSNotFound) return YES;
    }
    return NO;
}

// 0xb5ec (_SCPIconHiddenOnCar) — VERIFIED
BOOL SCPIconHiddenOnCar(id icon) {
    NSSet<NSString *> *hidden = SCPHomeHiddenApps();
    if (!icon || hidden.count == 0) return NO;
    NSString *bid = SCPIconBundleID(icon);
    if (!bid || ![hidden containsObject:bid]) return NO;
    if (SCPBundleIsProtected(bid)) return NO;
    if (SCPIsInjectedPhoneApp(bid)) return NO;
    if (!SCPAppIsInstalled(bid)) return NO;
    SCPHomeLogOnce(@"an khoi man chinh (isIconVisible: NO):", bid);
    return YES;
}

// 0xbb20 (_SCPIconForcedOnCar) — VERIFIED (mirror of the above; an explicit
// "shown" entry wins unless the app is also in the hidden list)
BOOL SCPIconForcedOnCar(id icon) {
    NSSet<NSString *> *shown = SCPHomeShownApps();
    if (!icon || shown.count == 0) return NO;
    NSString *bid = SCPIconBundleID(icon);
    if (!bid || ![shown containsObject:bid]) return NO;
    if ([SCPHomeHiddenApps() containsObject:bid]) return NO;
    SCPHomeLogOnce(@"hien lai tren man chinh (isIconVisible: YES):", bid);
    return YES;
}

// 0xb1f8 (_SCPHomeAppRemovable) — VERIFIED body; NO caller exists anywhere
// in either slice of this dylib or in any other OmniCar binary (checked:
// direct branches, adrp+add materialization, data-slot pointers, cross-
// binary imports). It is the "may the user hide this app" predicate:
// not protected, not injected, and installed.
BOOL SCPHomeAppRemovable(NSString *bid) {
    if (!bid || bid.length == 0) return NO;
    if (SCPBundleIsProtected(bid)) return NO;
    if (SCPIsInjectedPhoneApp(bid)) return NO;
    return SCPAppIsInstalled(bid);
}

// 0xbce4 (_SCPHomeIconModelLayout) — VERIFIED
void SCPHomeIconModelLayout(NSString *reason) {
    id homeVC = SCPHomeVCWeak; // weak global 0x880d0 (SCPAppIcons.m)
    id model = SCPHomeSafeGet(homeVC, @"iconModel");
    if (!model) model = SCPHomeSafeKVCGet(homeVC, @"_iconModel");
    SEL layoutSel = NSSelectorFromString(@"layout");
    if (model && [model respondsToSelector:layoutSel]) {
        ((void (*)(id, SEL))objc_msgSend)(model, layoutSel);
        OMCLogWrite(@"SplitScreen", [NSString stringWithFormat:
            @"HomeScreen: %@ -> %@ layout", reason, NSStringFromClass([model class])]);
        return;
    }
    // Fallback: ask the home VC to refresh from the library instead.
    SEL refreshSel = NSSelectorFromString(@"_handleAppLibraryRefresh");
    if ([homeVC respondsToSelector:refreshSel]) {
        ((void (*)(id, SEL))objc_msgSend)(homeVC, refreshSel);
    } else SCPMissingSelector(homeVC, @"_handleAppLibraryRefresh");
    OMCLogWrite(@"SplitScreen", [NSString stringWithFormat:
        @"HomeScreen: %@, khong co iconModel (%@) -> _handleAppLibraryRefresh",
        reason, model ? NSStringFromClass([model class]) : @"nil"]);
}

// 0xc088 (refresh block invoke) — VERIFIED
static void SCPRefreshHiddenAppsBlock(NSInteger token) {
    if (token != SCPHiddenRefreshCounter) return;
    NSSet<NSString *> *hidden = SCPPrefBundleSet(@"homeScreenHiddenApps");
    NSSet<NSString *> *shown = SCPPrefBundleSet(@"homeScreenShownApps");
    if ([hidden isEqualToSet:SCPHomeHiddenApps()] &&
        [shown isEqualToSet:SCPHomeShownApps()])
        return;
    @synchronized (SCPHomeVisibilityLock()) {
        SCPHiddenCache = hidden;
        SCPShownCache = shown;
    }
    SCPHomeIconModelLayout([NSString stringWithFormat:
        @"danh sach app doi (bo %lu, them lai %lu)",
        (unsigned long)hidden.count, (unsigned long)shown.count]);
}

// 0xc008 (_SCPRefreshHiddenAppsSoon) — VERIFIED (same 0.8 s debounce)
void SCPRefreshHiddenAppsSoon(void) {
    NSInteger token = ++SCPHiddenRefreshCounter;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 800000000),
                   dispatch_get_main_queue(), ^{ SCPRefreshHiddenAppsBlock(token); });
}

NS_ASSUME_NONNULL_END
