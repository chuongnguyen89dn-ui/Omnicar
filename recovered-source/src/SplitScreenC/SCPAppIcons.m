// SCPAppIcons.m — SplitScreen-C: the app-icon injection core.
//
// Mechanism (all VERIFIED from disassembly, see SplitScreenC_REPORT.md):
//  - The user picks phone apps in Settings; the choice is stored in the
//    `appBridgeApps` preference (domain com.anlai.omnicar).
//  - When CarPlay's DashBoard builds its application library, the
//    +[DashBoard _newApplicationLibrary] hook (installer + body shell in
//    SplitScreen-A, 0x4af0) calls into this family:
//      SCPAppIconsBeginInjection()  — crash-guard state machine
//      SCPChosenPhoneApps()         — the chosen set
//      SCPAddChosenAppsToLibrary()  — add LSApplicationProxy objects for
//                                     chosen apps the library doesn't know
//  - When the system later loads an application info, the
//    -[DBApplicationInfo _loadFromProxy:] hook (A, 0x4bcc) calls
//    SCPInjectDeclarationIfChosen(), which grafts a synthetic
//    CRCarPlayAppDeclaration (supportsMaps=YES, templates=NO) onto the info
//    so the stock icon model treats the phone app as a CarPlay app.
//  - A debounced refresh (0.8 s) watches the chosen set for changes and
//    re-syncs the live library.

#import "SCPHomeCommon.h"
#import "SCPHomeLauncher.h" // [gpt-home] exclude own app from phone host

NS_ASSUME_NONNULL_BEGIN

// ---- globals (original addresses) -----------------------------------------
static NSMutableSet<NSString *> *SCPInjectedSet;      // 0x880c0, created by
                                                      // once-block sub_d68c
static NSSet<NSString *> *SCPChosenSnapshot;          // 0x880c8
__weak id SCPHomeVCWeak;                              // 0x880d0
static NSInteger SCPRefreshCounter;                   // 0x880d8

void SCPAppIconsRetry(void); // 0xb044, defined below

// ---- safe accessors --------------------------------------------------------

// 0xa26c — VERIFIED
id _Nullable SCPHomeSafeGet(id _Nullable obj, NSString *name) {
    @try {
        if (obj && [obj respondsToSelector:NSSelectorFromString(name)])
            return [obj performSelector:NSSelectorFromString(name)];
    } @catch (NSException *e) {}
    return nil;
}

// 0xa32c — VERIFIED
id _Nullable SCPHomeSafeKVCGet(id _Nullable obj, NSString *name) {
    @try {
        return [obj valueForKey:name];
    } @catch (NSException *e) {}
    return nil;
}

// 0xa3c4 — VERIFIED
BOOL SCPHomeSafeSet(id obj, NSString *name, id _Nullable value) {
    @try {
        [obj setValue:value forKey:name];
        return YES;
    } @catch (NSException *e) {
        OMCLogWrite(@"SplitScreen",
            [NSString stringWithFormat:@"AppIcons: khong dat duoc %@ cua %@: %@", name, obj, e]);
        return NO;
    }
}

// 0x4d8dc — VERIFIED (same pattern as SCPHomeSafeGet; the selector name is
// passed as an NSString object by the HomeApply cluster callers)
id _Nullable SCPHomeSafePerform(id _Nullable obj, NSString *name) {
    @try {
        if (obj && [obj respondsToSelector:NSSelectorFromString(name)])
            return [obj performSelector:NSSelectorFromString(name)];
    } @catch (NSException *e) {}
    return nil;
}

// 0xc4f4 — VERIFIED
void SCPHomePrefSet(NSString *key, id _Nullable value) {
    CFPreferencesSetAppValue((__bridge CFStringRef)key,
                             (__bridge CFPropertyListRef)value,
                             CFSTR("com.anlai.omnicar"));
    CFPreferencesAppSynchronize(CFSTR("com.anlai.omnicar"));
}

// ---- chosen apps -----------------------------------------------------------

// 0x9a1c + dispatch_once trampoline 0x56068 + once-block 0xd68c — VERIFIED
static NSMutableSet<NSString *> *SCPInjectedAppsSet(void) {
    static dispatch_once_t once; // token 0x88108
    dispatch_once(&once, ^{ SCPInjectedSet = [NSMutableSet set]; });
    return SCPInjectedSet;
}

// 0x9a60 (_SCPChosenPhoneApps) — VERIFIED
NSSet<NSString *> *SCPChosenPhoneApps(void) {
    if (!OMCFeatureEnabled(@"appBridge")) return [NSSet set];
    OMCPrefsSync();
    id v = OMCPref(@"appBridgeApps", nil);
    if ([v isKindOfClass:[NSArray class]]) {
        NSMutableSet *ids = [NSMutableSet setWithArray:v];
        // Own OmniCar is a CarPlay panel launcher, never AppBridge-hosted.
        [ids removeObject:SCPHomeLauncherBundleIdentifier()];
        return ids;
    }
    return [NSSet set];
}

// 0x9980 (_SCPIsInjectedPhoneApp) — VERIFIED
BOOL SCPIsInjectedPhoneApp(NSString *_Nullable bundleId) {
    if (!bundleId) return NO;
    NSMutableSet *set = SCPInjectedAppsSet();
    @synchronized (set) {
        return [set containsObject:bundleId];
    }
}

// ---- [homelib] instrument (WO GPT ytz4 item I2, log-only) -------------------
//
// Decision journal for the inject/remove path below. A per-bundle
// decision is logged only when the decision for that bundle CHANGES
// (in-memory cache, keyed by bundle); com.anlai.omnicar.app is exempt
// from suppression — every decision touching it is logged and also
// gets its own OMNI marker line so its fate can be grepped alone.
// proc= reads the executing process at runtime (this family is reached
// only through the CarPlayApp-gated hooks in SCPHooks.m).
static NSString *SCPHomeLibProcDesc(void) {
    NSString *name = [[NSProcessInfo processInfo] processName] ?: @"?";
    NSString *bundle = [[NSBundle mainBundle] bundleIdentifier] ?: @"?";
    return [NSString stringWithFormat:@"%@(%@)", name, bundle];
}

static NSMutableDictionary<NSString *, NSString *> *SCPHomeLibDecisionCache(void) {
    static NSMutableDictionary *cache;
    static dispatch_once_t once;
    dispatch_once(&once, ^{ cache = [NSMutableDictionary dictionary]; });
    return cache;
}

static void SCPHomeLibLogDecision(NSString *bid, NSString *decision) {
    if (!bid.length) return;
    BOOL omni = [bid isEqualToString:@"com.anlai.omnicar.app"];
    NSMutableDictionary *cache = SCPHomeLibDecisionCache();
    @synchronized (cache) {
        if (!omni && [cache[bid] isEqualToString:decision]) return;
        cache[bid] = decision;
    }
    OMCLogWrite(@"SplitScreen", [NSString stringWithFormat:
        @"[homelib] proc=%@ decision=%@ bundle=%@",
        SCPHomeLibProcDesc(), decision, bid]);
    if (omni)
        OMCLogWrite(@"SplitScreen", [NSString stringWithFormat:
            @"[homelib] OMNI decision=%@ bundle=%@", decision, bid]);
}

// ---- declaration injection -------------------------------------------------

// 0x9b34 (_SCPInjectDeclarationIfChosen) — VERIFIED
void SCPInjectDeclarationIfChosen(id info) {
    NSString *bid = SCPHomeSafeGet(info, @"bundleIdentifier");
    if (![bid isKindOfClass:[NSString class]] || bid.length == 0) return;
    // [homelib] (log-only; the flow check below is untouched)
    if (![SCPChosenPhoneApps() containsObject:bid])
        SCPHomeLibLogDecision(bid, @"skip-not-chosen");
    if (![SCPChosenPhoneApps() containsObject:bid]) return;

    id decl = SCPHomeSafeKVCGet(info, @"_carPlayDeclaration");
    if (decl) {
        // 0x9bc0: the binary reads the tag list from INFO via SCPHomeSafeGet
        // (sub_a26c, x0 = info), NOT from the declaration — verifier #5.
        id tags = SCPHomeSafeGet(info, @"tags");
        // [homelib] (log-only)
        if ([tags isKindOfClass:[NSArray class]] &&
            [tags containsObject:@"OmniCarAppBridge"])
            SCPHomeLibLogDecision(bid, @"skip-already-ours");
        else
            SCPHomeLibLogDecision(bid, @"skip-real-declaration");
        if ([tags isKindOfClass:[NSArray class]] &&
            [tags containsObject:@"OmniCarAppBridge"])
            return; // already ours
        OMCLogWrite(@"SplitScreen", [NSString stringWithFormat:
            @"AppIcons: %@ da co declaration that (app CarPlay) -> khong chen", bid]);
        return;
    }

    Class declClass = objc_getClass("CRCarPlayAppDeclaration");
    if (!declClass) {
        OMCLogWrite(@"SplitScreen", @"AppIcons: khong co lop CRCarPlayAppDeclaration");
        SCPHomeLibLogDecision(bid, @"skip-no-decl-class"); // [homelib]
        return;
    }
    decl = [[declClass alloc] init];

    SEL setTemplates = NSSelectorFromString(@"setSupportsTemplates:");
    if ([decl respondsToSelector:setTemplates]) {
        ((void (*)(id, SEL, BOOL))objc_msgSend)(decl, setTemplates, NO);
    } else SCPMissingSelector(decl, @"setSupportsTemplates:");
    SEL setMaps = NSSelectorFromString(@"setSupportsMaps:");
    if ([decl respondsToSelector:setMaps]) {
        ((void (*)(id, SEL, BOOL))objc_msgSend)(decl, setMaps, YES);
    } else SCPMissingSelector(decl, @"setSupportsMaps:");
    SEL setBid = NSSelectorFromString(@"setBundleIdentifier:");
    if ([decl respondsToSelector:setBid]) {
        ((void (*)(id, SEL, id))objc_msgSend)(decl, setBid, bid);
    } else SCPMissingSelector(decl, @"setBundleIdentifier:");

    id bundleURL = SCPHomeSafeGet(info, @"bundleURL");
    NSString *path = nil;
    if ([bundleURL isKindOfClass:[NSURL class]]) path = [(NSURL *)bundleURL path];
    else if ([bundleURL isKindOfClass:[NSString class]]) path = bundleURL;
    if (path) {
        SEL setPath = NSSelectorFromString(@"setBundlePath:");
        if ([decl respondsToSelector:setPath]) {
            ((void (*)(id, SEL, id))objc_msgSend)(decl, setPath, path);
        } else SCPMissingSelector(decl, @"setBundlePath:");
    }

    if (!SCPHomeSafeSet(info, @"_carPlayDeclaration", decl)) return;
    // [homelib] past this point the declaration write succeeded (a
    // failure returns above and is already logged by SCPHomeSafeSet).
    SCPHomeLibLogDecision(bid, @"inject");

    // 0x9e54: the pre-prepend read is also SCPHomeSafeGet(info, @"tags")
    // in the binary; the KVC "_tags" form is only the WRITE below (0x9eb0).
    id oldTags = SCPHomeSafeGet(info, @"tags");
    NSArray *base = [oldTags isKindOfClass:[NSArray class]] ? oldTags : @[];
    NSArray *tags = [@[@"OmniCarAppBridge"] arrayByAddingObjectsFromArray:base];
    SCPHomeSafeSet(info, @"_tags", tags);

    BOOL wasValid = NO;
    if ([info respondsToSelector:NSSelectorFromString(@"isValid")])
        wasValid = ((BOOL (*)(id, SEL))objc_msgSend)(info, NSSelectorFromString(@"isValid"));
    if (!wasValid) SCPHomeSafeSet(info, @"_valid", (id)kCFBooleanTrue);

    BOOL already;
    NSMutableSet *set = SCPInjectedAppsSet();
    @synchronized (set) {
        already = [set containsObject:bid];
        [set addObject:bid];
    }
    if (!already) {
        BOOL hidden = NO, installed = NO, fullScreen = NO;
        SEL s;
        s = NSSelectorFromString(@"isHidden");
        if ([info respondsToSelector:s]) hidden = ((BOOL (*)(id, SEL))objc_msgSend)(info, s);
        else SCPMissingSelector(info, @"isHidden");
        s = NSSelectorFromString(@"isInstalled");
        if ([info respondsToSelector:s]) installed = ((BOOL (*)(id, SEL))objc_msgSend)(info, s);
        else SCPMissingSelector(info, @"isInstalled");
        s = NSSelectorFromString(@"presentsFullScreen");
        if ([info respondsToSelector:s]) fullScreen = ((BOOL (*)(id, SEL))objc_msgSend)(info, s);
        else SCPMissingSelector(info, @"presentsFullScreen");
        OMCLogWrite(@"SplitScreen", [NSString stringWithFormat:
            @"AppIcons: chen %@: valid=%d hidden=%d installed=%d fullScreen=%d path=%@",
            bid, wasValid, hidden, installed, fullScreen, path]);
    }
}

// ---- library population ----------------------------------------------------

// 0xa860 — VERIFIED: LSApplicationProxy for bid, only when its appState is valid.
static id _Nullable SCPValidProxyForBundle(NSString *bid) {
    Class proxyClass = objc_getClass("LSApplicationProxy");
    SEL sel = NSSelectorFromString(@"applicationProxyForIdentifier:");
    id proxy = nil;
    if ([proxyClass respondsToSelector:sel]) {
        proxy = ((id (*)(id, SEL, id))objc_msgSend)(proxyClass, sel, bid);
    } else SCPMissingSelector(proxyClass, @"applicationProxyForIdentifier:");
    id state = SCPHomeSafeGet(proxy, @"appState");
    if (state && [state respondsToSelector:NSSelectorFromString(@"isValid")] &&
        ((BOOL (*)(id, SEL))objc_msgSend)(state, NSSelectorFromString(@"isValid")))
        return proxy;
    return nil;
}

// 0xa500 (_SCPAddChosenAppsToLibrary) — VERIFIED
void SCPAddChosenAppsToLibrary(id library) {
    NSSet<NSString *> *chosen = SCPChosenPhoneApps();
    SCPChosenSnapshot = chosen;
    NSUInteger added = 0;
    for (NSString *bid in chosen) {
        SEL lookup = NSSelectorFromString(@"applicationInfoForBundleIdentifier:");
        id info = nil;
        if ([library respondsToSelector:lookup]) {
            info = ((id (*)(id, SEL, id))objc_msgSend)(library, lookup, bid);
        } else SCPMissingSelector(library, @"applicationInfoForBundleIdentifier:");
        // [homelib] (log-only)
        if (info) SCPHomeLibLogDecision(bid, @"lib-skip-present");
        if (info) continue; // the _loadFromProxy: hook injects on load
        id proxy = SCPValidProxyForBundle(bid);
        if (!proxy) {
            OMCLogWrite(@"SplitScreen", [NSString stringWithFormat:
                @"AppIcons: %@ khong cai / khong hop le -> bo qua", bid]);
            SCPHomeLibLogDecision(bid, @"lib-skip-no-proxy"); // [homelib]
            continue;
        }
        SEL addSel = NSSelectorFromString(@"addApplicationProxy:withOverrideURL:");
        if ([library respondsToSelector:addSel]) {
            ((void (*)(id, SEL, id, id))objc_msgSend)(library, addSel, proxy, nil);
            added++;
            SCPHomeLibLogDecision(bid, @"lib-add"); // [homelib]
        } else SCPMissingSelector(library, @"addApplicationProxy:withOverrideURL:");
    }
    OMCLogWrite(@"SplitScreen", [NSString stringWithFormat:
        @"AppIcons: them %lu / %lu app da chon vao thu vien %@",
        (unsigned long)added, (unsigned long)chosen.count, [library class]]);
}

// ---- home view controller + debounced refresh ------------------------------

// 0xaa00 (_SCPSetHomeViewController) — VERIFIED (objc_storeWeak)
void SCPSetHomeViewController(id vc) {
    SCPHomeVCWeak = vc;
}

// Global block literal 0x78980, invoke 0xb0e8 — VERIFIED
static void SCPRefreshHomeLibrary(void) {
    @try {
        id vc = SCPHomeVCWeak;
        SEL sel = NSSelectorFromString(@"_handleAppLibraryRefresh");
        if ([vc respondsToSelector:sel]) {
            ((void (*)(id, SEL))objc_msgSend)(vc, sel);
        } else SCPMissingSelector(vc, @"_handleAppLibraryRefresh");
    } @catch (NSException *e) {
        OMCLogWrite(@"SplitScreen", [NSString stringWithFormat:@"AppIcons: refresh loi %@", e]);
    }
}

// 0xaa90 (refresh block invoke) — VERIFIED
static void SCPRefreshAppIconsBlock(NSInteger token) {
    if (token != SCPRefreshCounter) return; // superseded
    @try {
        NSSet<NSString *> *chosen = SCPChosenPhoneApps();
        NSSet<NSString *> *prev = SCPChosenSnapshot ?: [NSSet set];
        if ([chosen isEqualToSet:prev]) return;
        SCPAppIconsRetry(); // list changed -> allow injection again
        id library = SCPHomeSafeGet(SCPHomeVCWeak, @"library");
        if (!library)
            library = SCPHomeSafeGet([UIApplication sharedApplication],
                                     @"sharedApplicationLibrary");
        if (!library) {
            OMCLogWrite(@"SplitScreen", @"AppIcons: chua co thu vien de cap nhat");
            return;
        }
        NSMutableSet<NSString *> *removed = [NSMutableSet set];
        NSMutableSet *set = SCPInjectedAppsSet();
        @synchronized (set) {
            for (NSString *bid in set)
                if (![chosen containsObject:bid]) [removed addObject:bid];
            [set minusSet:removed];
        }
        for (NSString *bid in removed) {
            id proxy = SCPValidProxyForBundle(bid);
            // [homelib] (log-only)
            if (!proxy) SCPHomeLibLogDecision(bid, @"remove-skip-no-proxy");
            if (!proxy) continue;
            SEL rmSel = NSSelectorFromString(@"removeApplicationProxy:");
            if ([library respondsToSelector:rmSel]) {
                ((void (*)(id, SEL, id))objc_msgSend)(library, rmSel, proxy);
                SCPHomeLibLogDecision(bid, @"remove"); // [homelib]
            } else SCPMissingSelector(library, @"removeApplicationProxy:");
        }
        SCPAddChosenAppsToLibrary(library);
        OMCLogWrite(@"SplitScreen", [NSString stringWithFormat:
            @"AppIcons: danh sach doi -> bo %lu app, ve lai man chinh",
            (unsigned long)removed.count]);
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 1000000000),
                       dispatch_get_main_queue(), ^{ SCPRefreshHomeLibrary(); });
    } @catch (NSException *e) {
        OMCLogWrite(@"SplitScreen", [NSString stringWithFormat:
            @"AppIcons: cap nhat thu vien loi %@", e]);
    }
}

// 0xaa10 (_SCPRefreshAppIconsSoon) — VERIFIED (0.8 s debounce)
void SCPRefreshAppIconsSoon(void) {
    NSInteger token = ++SCPRefreshCounter;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 800000000),
                   dispatch_get_main_queue(), ^{ SCPRefreshAppIconsBlock(token); });
}

// ---- crash-guard state machine ----------------------------------------------

// 0xb044 (_SCPAppIconsRetry) — VERIFIED
void SCPAppIconsRetry(void) {
    OMCPrefsSync();
    if (OMCPref(@"splitScreenIconsCrashed", nil) != nil) {
        SCPHomePrefSet(@"splitScreenIconsCrashed", nil);
        OMCLogWrite(@"SplitScreen",
            @"AppIcons: danh sach app doi -> cho phep chen icon lai");
    }
}

// 0xc37c (_SCPAppIconsBeginInjection) — VERIFIED
BOOL SCPAppIconsBeginInjection(void) {
    OMCPrefsSync();
    if ([OMCPref(@"splitScreenIconsPending", nil) boolValue]) {
        // Previous run armed "pending" but never confirmed a healthy car
        // screen -> it crashed during injection. Disable for this version.
        OMCLogWrite(@"SplitScreen", [NSString stringWithFormat:
            @"AppIcons: lan truoc CarPlay sap sau khi chen icon -> tat chen icon o ban %@ (doi danh sach app de thu lai)",
            @"1.0.3"]);
        SCPHomePrefSet(@"splitScreenIconsCrashed", @"1.0.3");
        SCPHomePrefSet(@"splitScreenIconsPending", nil);
    }
    if ([OMCPref(@"splitScreenIconsCrashed", nil) isEqual:@"1.0.3"]) {
        OMCLogWrite(@"SplitScreen", [NSString stringWithFormat:
            @"AppIcons: dang tat vi tung sap o ban %@", @"1.0.3"]);
        return NO;
    }
    SCPHomePrefSet(@"splitScreenIconsPending", (id)kCFBooleanTrue);
    return YES;
}

// 0xc570 (_SCPAppIconsCarScreenOK) — VERIFIED
void SCPAppIconsCarScreenOK(void) {
    OMCPrefsSync();
    if ([OMCPref(@"splitScreenIconsPending", nil) boolValue]) {
        SCPHomePrefSet(@"splitScreenIconsPending", nil);
        OMCLogWrite(@"SplitScreen",
            @"AppIcons: man xe hien binh thuong sau khi chen icon");
    }
}

NS_ASSUME_NONNULL_END
