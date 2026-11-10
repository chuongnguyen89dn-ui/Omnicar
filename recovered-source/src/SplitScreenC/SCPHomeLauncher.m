// SCPHomeLauncher.m — OmniCar's OWN CarPlay Home launcher (GPT).
//
// Triad: real installed LS proxy -> own DBApplicationInfo declaration ->
// original icon model / scoped visibility -> Dashboard tap intercepted
// into the SINGLE existing -[SCPCarSplit showLayoutPanelForApp:] controller.
//
// No fake Home view, no new split engine, no global entitlement spoof,
// no on-disk preference or native app-list mutation, no iPhone app launch.
// [hl12dock] Native Dock membership is a separate in-memory state path.
// Runtime private-ABI behaviour remains PENDING-DEVICE until car test.
#import "SCPHomeLauncher.h"
#import "SCPHomeCommon.h"
#import "../SplitScreenA/SCPShared.h"
#import "../SplitScreenA/SCPPrefs.h"
#import "../SplitScreenA/SCPCarSplit.h"
#import "../SplitScreenA/SCPCarSplit+AutoHide.h"
#import <objc/message.h>
#import <objc/runtime.h>
#import <QuartzCore/QuartzCore.h>
#import <substrate.h>
#include <string.h> // method_getTypeEncoding ABI guard

static NSString *const OwnID = @"com.anlai.omnicar.app";
static NSString *const OwnTag = @"OmniCarHomeLauncher";
static BOOL SCPHomeDockPanelOpen(id split); // [hl12dock] forward declaration

NSString *SCPHomeLauncherBundleIdentifier(void) { return OwnID; }
BOOL SCPHomeLauncherIsBundle(NSString *bid) {
    return [bid isKindOfClass:[NSString class]] && [bid isEqualToString:OwnID];
}
BOOL SCPHomeLauncherEnabled(void) { return [SCPPrefs enabled]; }

static void HLog(NSString *phase, NSString *detail) {
    OMCLogWrite(@"SplitScreen", [NSString stringWithFormat:
        @"[home-launch] phase=%@ bundle=%@ %@",
        phase, OwnID, detail ?: @""]);
}
static NSString *BundleOf(id obj) {
    for (NSString *key in @[@"applicationBundleID", @"leafIdentifier",
                             @"bundleIdentifier"]) {
        id x = SCPHomeSafeGet(obj, key);
        if ([x isKindOfClass:[NSString class]] && [x length]) return x;
    }
    return nil;
}
BOOL SCPHomeLauncherIsOwnIcon(id icon) {
    return SCPHomeLauncherIsBundle(BundleOf(icon));
}

static id InstalledOwnProxy(void) {
    Class cls = objc_getClass("LSApplicationProxy");
    SEL get = NSSelectorFromString(@"applicationProxyForIdentifier:");
    if (!cls || ![cls respondsToSelector:get]) {
        HLog(@"library", @"reason=no-LSApplicationProxy-api");
        return nil;
    }
    id proxy = ((id (*)(id, SEL, id))objc_msgSend)(cls, get, OwnID);
    id state = SCPHomeSafeGet(proxy, @"appState");
    SEL valid = NSSelectorFromString(@"isValid");
    if (!proxy || !state || ![state respondsToSelector:valid] ||
        !((BOOL (*)(id, SEL))objc_msgSend)(state, valid)) {
        HLog(@"library", @"reason=not-installed-or-invalid-proxy");
        return nil;
    }
    return proxy;
}
static BOOL SetDeclBool(id obj, NSString *name, BOOL value) {
    SEL sel = NSSelectorFromString(name);
    if (![obj respondsToSelector:sel]) return NO;
    ((void (*)(id, SEL, BOOL))objc_msgSend)(obj, sel, value);
    return YES;
}
void SCPHomeLauncherInjectInfo(id info) {
    @try {
        if (!SCPHomeLauncherIsBundle(
                SCPHomeSafeGet(info, @"bundleIdentifier"))) return;
        if (!SCPHomeLauncherEnabled()) return;

        id old = SCPHomeSafeKVCGet(info, @"_carPlayDeclaration");
        id rawTags = SCPHomeSafeGet(info, @"tags");
        NSArray *tags = [rawTags isKindOfClass:[NSArray class]] ? rawTags : @[];
        if (old) {
            // Never replace an Apple/native or another producer's declaration.
            HLog(@"declaration", [tags containsObject:OwnTag]
                ? @"status=already-ours" : @"status=preserve-existing");
            return;
        }
        Class cls = objc_getClass("CRCarPlayAppDeclaration");
        if (!cls) { HLog(@"declaration", @"reason=class-unavailable"); return; }
        id decl = [[cls alloc] init];
        if (!SetDeclBool(decl, @"setSupportsTemplates:", NO) ||
            !SetDeclBool(decl, @"setSupportsMaps:", YES)) {
            HLog(@"declaration", @"reason=setter-unavailable");
            return;
        }
        SEL setBid = NSSelectorFromString(@"setBundleIdentifier:");
        if (![decl respondsToSelector:setBid]) {
            HLog(@"declaration", @"reason=bundle-setter-unavailable");
            return;
        }
        ((void (*)(id, SEL, id))objc_msgSend)(decl, setBid, OwnID);
        id url = SCPHomeSafeGet(info, @"bundleURL");
        NSString *path = [url isKindOfClass:[NSURL class]] ? [url path] :
                         ([url isKindOfClass:[NSString class]] ? url : nil);
        SEL setPath = NSSelectorFromString(@"setBundlePath:");
        if (path.length && [decl respondsToSelector:setPath])
            ((void (*)(id, SEL, id))objc_msgSend)(decl, setPath, path);

        if (!SCPHomeSafeSet(info, @"_carPlayDeclaration", decl)) {
            HLog(@"declaration", @"reason=write-failed");
            return;
        }
        SCPHomeSafeSet(info, @"_tags",
            [@[OwnTag] arrayByAddingObjectsFromArray:tags]);
        SEL valid = NSSelectorFromString(@"isValid");
        if ([info respondsToSelector:valid] &&
            !((BOOL (*)(id, SEL))objc_msgSend)(info, valid))
            SCPHomeSafeSet(info, @"_valid", (id)kCFBooleanTrue);
        HLog(@"declaration", [NSString stringWithFormat:
            @"status=injected path=%@", path.length ? @"present" : @"unknown"]);
    } @catch (NSException *e) {
        HLog(@"declaration", [NSString stringWithFormat:
            @"status=exception name=%@", e.name]);
    }
}

BOOL SCPHomeLauncherEnsureInLibrary(id library) {
    if (!SCPHomeLauncherEnabled()) return NO;
    if (!library) { HLog(@"library", @"reason=no-library"); return NO; }
    @try {
        SEL lookup = NSSelectorFromString(@"applicationInfoForBundleIdentifier:");
        if (![library respondsToSelector:lookup]) {
            HLog(@"library", @"reason=no-lookup-selector");
            return NO;
        }
        id info = ((id (*)(id, SEL, id))objc_msgSend)(library, lookup, OwnID);
        if (info) {
            // An already-present FBS record can have no CarPlay declaration.
            // Promotion is itself a Home-model mutation and must request
            // the same refresh as a newly added proxy on reconnect/reentry.
            BOOL hadDeclaration =
                (SCPHomeSafeKVCGet(info, @"_carPlayDeclaration") != nil);
            SCPHomeLauncherInjectInfo(info);
            BOOL hasDeclaration =
                (SCPHomeSafeKVCGet(info, @"_carPlayDeclaration") != nil);
            BOOL changed = (!hadDeclaration && hasDeclaration);
            if (changed) HLog(@"library", @"status=existing-record-promoted");
            return changed;  // library/model refresh needed; NOT device proof
        }
        id proxy = InstalledOwnProxy();
        if (!proxy) return NO;
        SEL add = NSSelectorFromString(@"addApplicationProxy:withOverrideURL:");
        if (![library respondsToSelector:add]) {
            HLog(@"library", @"reason=no-add-selector");
            return NO;
        }
        ((void (*)(id, SEL, id, id))objc_msgSend)(library, add, proxy, nil);
        info = ((id (*)(id, SEL, id))objc_msgSend)(library, lookup, OwnID);
        if (!info) {
            HLog(@"library", @"status=add-unconfirmed");
            return NO;
        }
        SCPHomeLauncherInjectInfo(info);
        HLog(@"library", @"status=added-to-real-library");
        return YES;
    } @catch (NSException *e) {
        HLog(@"library", [NSString stringWithFormat:
            @"status=exception name=%@", e.name]);
        return NO;
    }
}

// Read-only Home instrumentation. BLIND never means ABSENT.
// Cell claim only when an actual *IconView has an own-bundle icon.
typedef struct {
    NSUInteger lists, icons, ownModels, ownCells, visibleAttachedCells;
} OwnProbe;
static void Inspect(UIView *view, NSInteger depth, OwnProbe *p) {
    if (!view || depth > 16) return;
    NSString *className = NSStringFromClass([view class]);
    if ([className hasSuffix:@"IconListView"]) {
        p->lists++;
        id model = SCPHomeSafeGet(view, @"model");
        id raw = SCPHomeSafeGet(model, @"lists");
        if ([raw isKindOfClass:[NSArray class]]) for (id list in raw) {
            id icons = SCPHomeSafeGet(list, @"icons");
            if (![icons isKindOfClass:[NSArray class]]) continue;
            for (id icon in icons) {
                p->icons++;
                if (SCPHomeLauncherIsOwnIcon(icon)) p->ownModels++;
            }
        }
    }
    if ([className hasSuffix:@"IconView"] &&
        SCPHomeLauncherIsOwnIcon(SCPHomeSafeGet(view, @"icon"))) {
        p->ownCells++;
        if (view.window && !view.hidden && view.alpha > 0.01 &&
            view.layer.opacity > 0.01) p->visibleAttachedCells++;
    }
    for (UIView *child in view.subviews) Inspect(child, depth+1, p);
}
void SCPHomeLauncherAuditModel(NSString *reason) {
    if (![NSThread isMainThread]) {
        NSString *copy = [reason copy];
        dispatch_async(dispatch_get_main_queue(), ^{ SCPHomeLauncherAuditModel(copy); });
        return;
    }
    static CFAbsoluteTime lastLayoutProbe = 0;
    CFAbsoluteTime now = CFAbsoluteTimeGetCurrent();
    if ([reason isEqualToString:@"home-layout"]) {
        if (now - lastLayoutProbe < 2.0) return;
        lastLayoutProbe = now;
    }
    @try {
        id vc = SCPHomeVCWeak;
        UIView *v = nil;
        NSString *blind = nil;
        if (!vc) blind = @"no-homeVC";
        else if (![vc isViewLoaded]) blind = @"view-not-loaded";
        else if (!(v = [vc view])) blind = @"no-view";
        else if (!v.window) blind = @"no-window";
        OwnProbe p = {0};
        if (!blind) {
            Inspect(v, 0, &p);
            if (p.lists == 0) blind = @"no-icon-list";
            else if (p.icons == 0) blind = @"no-icon-models";
        }
        NSString *state = blind ? @"BLIND" :
            (p.ownModels ? @"PRESENT-MODEL" : @"ABSENT-MODEL");
        HLog(@"model", [NSString stringWithFormat:
            @"reason=%@ state=%@ blind=%@ lists=%lu icons=%lu ownModel=%lu ownCells=%lu attached=%lu",
            reason, state, blind ?: @"none", (unsigned long)p.lists,
            (unsigned long)p.icons, (unsigned long)p.ownModels,
            (unsigned long)p.ownCells, (unsigned long)p.visibleAttachedCells]);
    } @catch (NSException *e) {
        HLog(@"model", [NSString stringWithFormat:
            @"reason=%@ state=BLIND exception=%@", reason, e.name]);
    }
}

void SCPHomeLauncherReconcile(NSString *reason) {
    if (![NSThread isMainThread]) {
        NSString *copy = [reason copy];
        dispatch_async(dispatch_get_main_queue(), ^{ SCPHomeLauncherReconcile(copy); });
        return;
    }
    if (!SCPHomeLauncherEnabled()) {
        SCPHomeLauncherDockSetVisible(NO, @"feature-disabled");
        HLog(@"reconcile", [NSString stringWithFormat:
            @"reason=%@ status=feature-disabled", reason]);
        return;
    }
    @try {
        id vc = SCPHomeVCWeak;
        id library = SCPHomeSafeGet(vc, @"library");
        if (!library) library = SCPHomeSafeGet(
            [UIApplication sharedApplication], @"sharedApplicationLibrary");
        BOOL added = SCPHomeLauncherEnsureInLibrary(library);
        HLog(@"reconcile", [NSString stringWithFormat:
            @"reason=%@ library=%@ added=%d", reason,
            library ? NSStringFromClass([library class]) : @"nil", added]);
        if (added) {
            SEL refresh = NSSelectorFromString(@"_handleAppLibraryRefresh");
            if ([vc respondsToSelector:refresh])
                ((void (*)(id, SEL))objc_msgSend)(vc, refresh);
        }
        SCPHomeLauncherAuditModel(reason);
        if ([reason isEqualToString:@"home-appear"] ||
            [reason isEqualToString:@"prefs-changed"]) {
            SCPCarSplit *split = [SCPCarSplit shared];
            SCPHomeLauncherDockSetVisible(
                split.active || SCPHomeDockPanelOpen(split), reason);
        }
    } @catch (NSException *e) {
        HLog(@"reconcile", [NSString stringWithFormat:
            @"reason=%@ exception=%@", reason, e.name]);
    }
}

// [hl12dock] Dock membership is independent of the Home icon model.
// Preserve the real DashBoard icon provider and native app-history model;
// never invent a workspace scene or mutate the native app list.
static BOOL SCPDockABI(id target, NSString *name, char returnKind,
                       char argumentKind, unsigned int argumentCount) {
    if (!target) return NO;
    SEL sel = NSSelectorFromString(name);
    Method method = class_getInstanceMethod(object_getClass(target), sel);
    if (!method || method_getNumberOfArguments(method) != argumentCount) return NO;
    char result[16] = {0};
    method_getReturnType(method, result, sizeof(result));
    if (returnKind && result[0] != returnKind) return NO;
    if (argumentCount == 3) {
        char arg[16] = {0};
        method_getArgumentType(method, 2, arg, sizeof(arg));
        if (arg[0] != argumentKind) return NO;
    }
    return YES;
}
static BOOL SCPHomeDockPanelOpen(id split) {
    SEL sel = NSSelectorFromString(@"panelOpen");
    return SCPDockABI(split, @"panelOpen", 'B', 0, 2) ?
        ((BOOL (*)(id, SEL))objc_msgSend)(split, sel) :
        (SCPDockABI(split, @"panelOpen", 'c', 0, 2) ?
            ((BOOL (*)(id, SEL))objc_msgSend)(split, sel) : NO);
}
static NSString *SCPDockBundle(id dock) {
    id value = SCPHomeSafeGet(dock, @"activeBundleIdentifier");
    return [value isKindOfClass:[NSString class]] ? value : nil;
}
static NSUInteger SCPDockOwnItems(id dock, NSUInteger *total) {
    id items = SCPHomeSafeGet(dock, @"orderedAppItems");
    if (![items isKindOfClass:[NSArray class]]) {
        if (total) *total = NSNotFound;
        return NSNotFound; // BLIND, not ABSENT
    }
    if (total) *total = [items count];
    NSUInteger found = 0;
    for (id item in items)
        if (SCPHomeLauncherIsBundle(SCPHomeSafeGet(item, @"bundleIdentifier")))
            found++;
    return found;
}
static BOOL SCPDockSetActive(id dock, id bundle) {
    NSString *name = @"setActiveBundleIdentifier:";
    if (!SCPDockABI(dock, name, 'v', '@', 3)) return NO;
    ((void (*)(id, SEL, id))objc_msgSend)(dock, NSSelectorFromString(name), bundle);
    return YES;
}
static BOOL SCPDockRefresh(id dock) {
    NSString *name = @"_refreshAppDock";
    if (!SCPDockABI(dock, name, 'v', 0, 2)) return NO;
    ((void (*)(id, SEL))objc_msgSend)(dock, NSSelectorFromString(name));
    return YES;
}
static BOOL SCPDockCanShowOwn(id dock, id history, NSString **why) {
    NSString *categorySelector = @"appDockCategoryForBundleIdentifier:";
    if (!SCPDockABI(history, categorySelector, 'Q', '@', 3) &&
        !SCPDockABI(history, categorySelector, 'q', '@', 3)) {
        if (why) *why = @"dock-category-abi-blind";
        return NO;
    }
    unsigned long long cat = ((unsigned long long (*)(id, SEL, id))objc_msgSend)(
        history, NSSelectorFromString(categorySelector), OwnID);
    if (cat != 0) {
        // An incorrect nav classification would evict Maps from its slot.
        if (why) *why = @"dock-category-not-other";
        return NO;
    }
    NSString *validSelector = @"isBundleIdentifierValidForDock:";
    if (SCPDockABI(history, validSelector, 'B', '@', 3) ||
        SCPDockABI(history, validSelector, 'c', '@', 3)) {
        BOOL valid = ((BOOL (*)(id, SEL, id))objc_msgSend)(
            history, NSSelectorFromString(validSelector), OwnID);
        if (!valid) { if (why) *why = @"dock-policy-rejected"; return NO; }
    }
    id provider = SCPHomeSafeGet(dock, @"iconProvider");
    NSString *iconSelector = @"iconForIdentifier:";
    if (!SCPDockABI(provider, iconSelector, '@', '@', 3)) {
        if (why) *why = @"icon-provider-blind";
        return NO;
    }
    id icon = ((id (*)(id, SEL, id))objc_msgSend)(
        provider, NSSelectorFromString(iconSelector), OwnID);
    if (!icon) { if (why) *why = @"icon-provider-no-own-icon"; return NO; }
    NSString *visibleSelector = @"isIconVisible:";
    if (SCPDockABI(provider, visibleSelector, 'B', '@', 3) ||
        SCPDockABI(provider, visibleSelector, 'c', '@', 3)) {
        BOOL visible = ((BOOL (*)(id, SEL, id))objc_msgSend)(
            provider, NSSelectorFromString(visibleSelector), icon);
        if (!visible) { if (why) *why = @"icon-provider-not-visible"; return NO; }
    }
    return YES;
}
// [hl14-dockapps] Only user-selected, home-injected phone apps enter
// the synthetic Dock history path. Native CarPlay apps retain Apple's
// original AppDock policy; OmniCar's own Dock owner is unchanged.
extern NSSet<NSString *> *SCPChosenPhoneApps(void);
static BOOL SCPDockIsChosenHosted(NSString *bid) {
    return [bid isKindOfClass:[NSString class]] && bid.length > 0 &&
        !SCPHomeLauncherIsBundle(bid) && SCPIsInjectedPhoneApp(bid) &&
        [SCPChosenPhoneApps() containsObject:bid];
}
void SCPHomeLauncherDockHostedReady(NSString *bid, NSString *reason) {
    if (![NSThread isMainThread]) {
        NSString *b = [bid copy], *r = [reason copy];
        dispatch_async(dispatch_get_main_queue(), ^{
            SCPHomeLauncherDockHostedReady(b, r);
        });
        return;
    }
    if (!SCPHomeLauncherEnabled() || !SCPDockIsChosenHosted(bid)) {
        HLog(@"dock-hosted", [NSString stringWithFormat:
            @"status=skipped source=%@ bid=%@", reason ?: @"?", bid ?: @"nil"]);
        return;
    }
    @try {
        id root = SCPDashboardRootViewController();
        id dock = SCPHomeSafeGet(root, @"appDockViewController");
        id hist = SCPHomeSafeGet(dock, @"appHistory");
        id provider = SCPHomeSafeGet(dock, @"iconProvider");
        if (!dock || !hist || !provider) {
            HLog(@"dock-hosted", [NSString stringWithFormat:
                @"status=BLIND reason=no-model bid=%@", bid]);
            return;
        }
        NSString *iconName = @"iconForIdentifier:";
        if (!SCPDockABI(provider, iconName, '@', '@', 3)) {
            HLog(@"dock-hosted", [NSString stringWithFormat:
                @"status=BLIND reason=icon-abi bid=%@", bid]);
            return;
        }
        id icon = ((id (*)(id, SEL, id))objc_msgSend)(
            provider, NSSelectorFromString(iconName), bid);
        if (!icon) {
            HLog(@"dock-hosted", [NSString stringWithFormat:
                @"status=BLIND reason=no-home-icon bid=%@", bid]);
            return;
        }
        NSString *visibleName = @"isIconVisible:";
        if (SCPDockABI(provider, visibleName, 'B', '@', 3) ||
            SCPDockABI(provider, visibleName, 'c', '@', 3)) {
            if (!((BOOL (*)(id, SEL, id))objc_msgSend)(
                    provider, NSSelectorFromString(visibleName), icon)) {
                HLog(@"dock-hosted", [NSString stringWithFormat:
                    @"status=reject reason=icon-not-visible bid=%@", bid]);
                return;
            }
        }
        NSString *validName = @"isBundleIdentifierValidForDock:";
        if (SCPDockABI(hist, validName, 'B', '@', 3) ||
            SCPDockABI(hist, validName, 'c', '@', 3)) {
            if (!((BOOL (*)(id, SEL, id))objc_msgSend)(
                    hist, NSSelectorFromString(validName), bid)) {
                HLog(@"dock-hosted", [NSString stringWithFormat:
                    @"status=reject reason=policy bid=%@", bid]);
                return;
            }
        }
        NSString *categoryName = @"appDockCategoryForBundleIdentifier:";
        if (!SCPDockABI(hist, categoryName, 'Q', '@', 3) &&
            !SCPDockABI(hist, categoryName, 'q', '@', 3)) {
            HLog(@"dock-hosted", [NSString stringWithFormat:
                @"status=BLIND reason=category-abi bid=%@", bid]);
            return;
        }
        unsigned long long category =
            ((unsigned long long (*)(id, SEL, id))objc_msgSend)(
                hist, NSSelectorFromString(categoryName), bid);
        if (category != 0) {
            HLog(@"dock-hosted", [NSString stringWithFormat:
                @"status=reject reason=not-other bid=%@ category=%llu",
                bid, category]);
            return;
        }
        id entries = SCPHomeSafeGet(hist, @"appHistory");
        if (![entries isKindOfClass:[NSMutableDictionary class]]) {
            HLog(@"dock-hosted", [NSString stringWithFormat:
                @"status=BLIND reason=history-not-mutable bid=%@", bid]);
            return;
        }
        ((NSMutableDictionary *)entries)[bid] =
            @([[NSDate date] timeIntervalSince1970]);
        BOOL wrote = SCPDockSetActive(dock, bid);
        BOOL refreshed = SCPDockRefresh(dock);
        BOOL active = [SCPDockBundle(dock) isEqualToString:bid];
        HLog(@"dock-hosted", [NSString stringWithFormat:
            @"status=%@ bid=%@ source=%@ history=1 active=%d "
             "wrote=%d refresh=%d",
            active ? @"model-active" : @"model-not-confirmed",
            bid, reason ?: @"?", active, wrote, refreshed]);
        NSString *tracked = [bid copy];
        dispatch_async(dispatch_get_main_queue(), ^{
            NSUInteger total = NSNotFound, found = 0;
            id items = SCPHomeSafeGet(dock, @"orderedAppItems");
            if ([items isKindOfClass:[NSArray class]]) {
                total = [items count];
                for (id item in items)
                    if ([SCPHomeSafeGet(item, @"bundleIdentifier")
                         isEqualToString:tracked]) found++;
            }
            HLog(@"dock-hosted-readback", [NSString stringWithFormat:
                @"bid=%@ ownCells=%@ count=%@",
                tracked,
                total == NSNotFound ? @"BLIND" :
                    [NSString stringWithFormat:@"%lu", (unsigned long)found],
                total == NSNotFound ? @"BLIND" :
                    [NSString stringWithFormat:@"%lu", (unsigned long)total]]);
        });
    } @catch (NSException *e) {
        HLog(@"dock-hosted", [NSString stringWithFormat:
            @"status=exception bid=%@ name=%@", bid, e.name]);
    }
}

void SCPHomeLauncherDockSetVisible(BOOL presented, NSString *reason) {
    if (![NSThread isMainThread]) {
        NSString *r = [reason copy];
        dispatch_async(dispatch_get_main_queue(), ^{
            SCPHomeLauncherDockSetVisible(presented, r);
        });
        return;
    }
    static BOOL lastClaimed = NO;
    NSString *why = reason ?: @"unknown";
    if (presented && !SCPHomeLauncherEnabled()) {
        HLog(@"dock", [NSString stringWithFormat:
            @"reason=%@ status=feature-disabled", why]);
        return;
    }
    if (!presented && !lastClaimed) return;
    @try {
        id root = SCPDashboardRootViewController();
        id dock = SCPHomeSafeGet(root, @"appDockViewController");
        id history = SCPHomeSafeGet(dock, @"appHistory");
        if (!dock || !history) {
            if (!presented) lastClaimed = NO;
            HLog(@"dock", [NSString stringWithFormat:
                @"reason=%@ requested=%d status=BLIND no-dock=%d no-history=%d",
                why, (int)presented, dock == nil, history == nil]);
            return;
        }
        NSString *before = SCPDockBundle(dock);
        if (!presented) {
            // Clear ONLY our own active claim. Never clobber a native
            // bundle that became active while OmniCar was backgrounded.
            BOOL wrote = NO;
            if (SCPHomeLauncherIsBundle(before))
                wrote = SCPDockSetActive(dock, nil);
            BOOL refreshed = SCPDockRefresh(dock);
            lastClaimed = NO;
            HLog(@"dock", [NSString stringWithFormat:
                @"reason=%@ status=released owned-before=%d wrote=%d refresh=%d after=%@",
                why, SCPHomeLauncherIsBundle(before), wrote, refreshed,
                SCPDockBundle(dock) ?: @"nil"]);
            return;
        }
        NSString *gate = nil;
        if (!SCPDockCanShowOwn(dock, history, &gate)) {
            HLog(@"dock", [NSString stringWithFormat:
                @"reason=%@ requested=1 status=BLIND gate=%@ active-before=%@",
                why, gate ?: @"unknown", before ?: @"nil"]);
            return;
        }
        id entries = SCPHomeSafeGet(history, @"appHistory");
        BOOL historyUpdated = NO;
        if ([entries isKindOfClass:[NSMutableDictionary class]]) {
            ((NSMutableDictionary *)entries)[OwnID] =
                @([[NSDate date] timeIntervalSince1970]);
            historyUpdated = YES;
        }
        // The real workspace-visible callback is intentionally NOT
        // spoofed: it emits unrelated activation notifications. History
        // here is in-memory only; DashBoard still owns the app scene.
        BOOL refreshed = SCPDockRefresh(dock);
        BOOL wrote = SCPDockSetActive(dock, OwnID);
        NSString *after = SCPDockBundle(dock);
        lastClaimed = wrote && SCPHomeLauncherIsBundle(after);
        HLog(@"dock", [NSString stringWithFormat:
            @"reason=%@ status=%@ history=%d refresh=%d wrote=%d active-before=%@ active-after=%@",
            why, lastClaimed ? @"active-model" : @"not-confirmed",
            historyUpdated, refreshed, wrote, before ?: @"nil",
            after ?: @"nil"]);
        // _refreshAppDock schedules list generation on the main queue.
        // Model readback is NOT proof that pixels appeared on the vehicle.
        dispatch_async(dispatch_get_main_queue(), ^{
            NSUInteger count = NSNotFound;
            NSUInteger own = SCPDockOwnItems(dock, &count);
            id other = SCPHomeSafeGet(SCPHomeSafeGet(dock, @"otherAppButton"), @"bundleIdentifier");
            id nav = SCPHomeSafeGet(SCPHomeSafeGet(dock, @"navigationAppButton"), @"bundleIdentifier");
            HLog(@"dock-readback", [NSString stringWithFormat:
                @"reason=%@ active-own=%d ownItems=%@ count=%@ other=%@ nav=%@",
                why, SCPHomeLauncherIsBundle(SCPDockBundle(dock)),
                own == NSNotFound ? @"BLIND" : [NSString stringWithFormat:@"%lu", (unsigned long)own],
                count == NSNotFound ? @"BLIND" : [NSString stringWithFormat:@"%lu", (unsigned long)count],
                other ?: @"nil", nav ?: @"nil"]);
        });
    } @catch (NSException *exception) {
        HLog(@"dock", [NSString stringWithFormat:
            @"reason=%@ requested=%d status=exception name=%@",
            why, (int)presented, exception.name]);
    }
}

// Consume ONLY the own bundle before stock phone launch and AppBridge.
// Both existing launch callbacks can fire for one tap: coalesce on main.
// No Dashboard event-1 injection; do not open Settings or a phone scene.
BOOL SCPHomeLauncherConsumeLaunch(NSString *bid, NSString *source) {
    if (!SCPHomeLauncherIsBundle(bid)) return NO;
    NSString *trigger = [source copy] ?: @"unknown";
    dispatch_async(dispatch_get_main_queue(), ^{
        static CFAbsoluteTime lastTap = 0;
        CFAbsoluteTime now = CFAbsoluteTimeGetCurrent();
        if (now - lastTap < 0.65) {
            HLog(@"tap", [NSString stringWithFormat:
                @"source=%@ status=coalesced", trigger]);
            return;
        }
        if (!SCPHomeLauncherEnabled()) {
            HLog(@"tap", [NSString stringWithFormat:
                @"source=%@ status=feature-disabled", trigger]);
            return;
        }
        id root = SCPDashboardRootViewController();
        if (![root isKindOfClass:[UIViewController class]] ||
            ![root isViewLoaded] || ![[root view] window]) {
            HLog(@"tap", [NSString stringWithFormat:
                @"source=%@ status=no-live-CarPlay-root", trigger]);
            return;
        }
        lastTap = now;
        @try {
            SCPCarSplit *split = [SCPCarSplit shared];
            [split ahNoteActivity:AHSourceHome];
            // Exact same panel and same split owner as the dock.
            // showLayoutPanelForApp: already collapses a prior tray.
            [split showLayoutPanelForApp:
                split.active ? nil : [split fullscreenAppBundle]];
            HLog(@"tap", [NSString stringWithFormat:
                @"source=%@ status=routed-existing-panel active=%d",
                trigger, split.active]);
        } @catch (NSException *e) {
            HLog(@"tap", [NSString stringWithFormat:
                @"source=%@ status=exception name=%@", trigger, e.name]);
        }
    });
    return YES;
}

// Verified on iOS 16.7.16 in DuoFace QA142 real Log21:
// -[DBDashboardHomeViewController iconManager:launchIconForIconView:]
// has method encoding v32@0:8@16@24.  Other Home overloads were absent.
// Intercept ONLY the own OmniCar icon; forward the original exactly once
// for native Apple apps, phone bridge apps and any unrecognized identity.
// No guessed DBApplicationController, CPTemplate startup or fake scene.
typedef void (*SCPHomeOriginalTap)(id, SEL, id, id);
static SCPHomeOriginalTap SCPHomeTapOriginal;

static id SCPHomeTypedGetter(id object, const char *name) {
    if (!object || !name) return nil;
    SEL selector = sel_registerName(name);
    Method method = class_getInstanceMethod(object_getClass(object), selector);
    if (!method || !method_getTypeEncoding(method) ||
        strcmp(method_getTypeEncoding(method), "@16@0:8") != 0) return nil;
    @try {
        return ((id (*)(id, SEL))objc_msgSend)(object, selector);
    } @catch (NSException *e) {
        return nil;
    }
}

static NSString *SCPHomeTapBundle(id object, NSUInteger depth) {
    if (!object || depth > 3) return nil;
    static const char *const identifiers[] = {
        "applicationBundleID", "leafIdentifier", "bundleIdentifier",
        "bundleID", "applicationIdentifier", "displayIdentifier", NULL
    };
    for (NSUInteger i = 0; identifiers[i]; i++) {
        id value = SCPHomeTypedGetter(object, identifiers[i]);
        if ([value isKindOfClass:[NSString class]] && [value length])
            return value;
    }
    static const char *const children[] = {
        "icon", "application", "representedApplication",
        "applicationInfo", "representedIcon", "model", NULL
    };
    for (NSUInteger i = 0; children[i]; i++) {
        id nested = SCPHomeTypedGetter(object, children[i]);
        if (!nested || nested == object) continue;
        NSString *candidate = SCPHomeTapBundle(nested, depth + 1);
        if (candidate.length) return candidate;
    }
    return nil;
}

static void SCPHomeTapReplacement(id homeVC, SEL action, id manager, id iconView) {
    NSString *bundle = nil;
    @try { bundle = SCPHomeTapBundle(iconView, 0); }
    @catch (NSException *e) {}
    // [gpt-home] Actual native callback observed; model/icon presence
    // alone is not a tap proof. Leave all other icon launchers untouched.
    HLog(@"home-callback", [NSString stringWithFormat:
        @"observedBundle=%@ viewClass=%@ own=%d",
        bundle ?: @"unresolved", iconView ? NSStringFromClass([iconView class]) : @"nil",
        SCPHomeLauncherIsBundle(bundle)]);
    if (SCPHomeLauncherIsBundle(bundle) &&
        SCPHomeLauncherConsumeLaunch(bundle, @"iconManager:launchIconForIconView:")) {
        HLog(@"tap-gate", @"status=consumed-own-icon");
        return;
    }
    // Exact single original forwarding for EVERY non-own/unknown icon.
    if (SCPHomeTapOriginal) SCPHomeTapOriginal(homeVC, action, manager, iconView);
}

// [hl12dock] A native Dock icon must reenter the existing OmniCar panel;
// otherwise Dashboard would launch the iPhone settings app for OwnID.
typedef void (*SCPDockOriginalTapType)(id, SEL, id);
static SCPDockOriginalTapType SCPDockOriginalTap;
static void SCPDockTapReplacement(id dock, SEL action, id button) {
    NSString *bundle = nil;
    @try { bundle = SCPHomeTapBundle(button, 0); }
    @catch (NSException *exception) {}
    if (SCPHomeLauncherIsBundle(bundle) &&
        SCPHomeLauncherConsumeLaunch(bundle, @"appDock:_dockButtonPressed:")) {
        HLog(@"dock-tap", @"status=consumed-own-icon");
        return;
    }
    if (SCPDockOriginalTap) SCPDockOriginalTap(dock, action, button);
}
typedef void (*SCPClosePopupsOriginalType)(id, SEL);
static SCPClosePopupsOriginalType SCPClosePopupsOriginal;
static void SCPHomeClosePopupsReplacement(id split, SEL action) {
    if (SCPClosePopupsOriginal) SCPClosePopupsOriginal(split, action);
    if (![(SCPCarSplit *)split active] && !SCPHomeDockPanelOpen(split))
        SCPHomeLauncherDockSetVisible(NO, @"popups-closed");
}
typedef unsigned long long (*SCPDockHistoryCategoryOriginalType)(id, SEL, id);
static SCPDockHistoryCategoryOriginalType SCPDockHistoryCategoryOriginal;
static unsigned long long SCPDockHistoryCategoryReplacement(id history, SEL action, id bundle) {
    if (SCPHomeLauncherIsBundle(bundle)) return 0; // Own launcher occupies OTHER, not Maps.
    if (SCPDockIsChosenHosted(bundle)) return 0; // [hl14-dockapps] keep Maps/audio slots intact
    return SCPDockHistoryCategoryOriginal ?
        SCPDockHistoryCategoryOriginal(history, action, bundle) : 0;
}
static void SCPHomeDockInstallCategoryHook(void) {
    Class historyClass = OMCCarClass("DBAppHistory");
    SEL sel = NSSelectorFromString(@"appDockCategoryForBundleIdentifier:");
    Method method = historyClass ? class_getInstanceMethod(historyClass, sel) : NULL;
    const char *abi = method ? method_getTypeEncoding(method) : NULL;
    // NSUInteger/NSInteger is 64-bit on the target, never cast to BOOL.
    if (abi && (!strcmp(abi, "Q24@0:8@16") ||
                !strcmp(abi, "q24@0:8@16"))) {
        SCPDockHistoryCategoryOriginal =
            (SCPDockHistoryCategoryOriginalType)method_getImplementation(method);
        MSHookMessageEx(historyClass, sel,
                        (IMP)SCPDockHistoryCategoryReplacement,
                        (IMP *)&SCPDockHistoryCategoryOriginal);
        HLog(@"dock-category", [NSString stringWithFormat:
            @"status=%@ ownCategory=other abi=%s",
            SCPDockHistoryCategoryOriginal ? @"installed" : @"not-confirmed", abi]);
    } else {
        HLog(@"dock-category", [NSString stringWithFormat:
            @"status=abi-unavailable observed=%s", abi ?: "none"]);
    }
}
typedef void (*SCPDockShowLayoutOriginalType)(id, SEL, id);
static SCPDockShowLayoutOriginalType SCPDockShowLayoutOriginal;
static void SCPDockShowLayoutReplacement(id split, SEL action, id bundle) {
    if (SCPDockShowLayoutOriginal)
        SCPDockShowLayoutOriginal(split, action, bundle);
    if ([(SCPCarSplit *)split active] || SCPHomeDockPanelOpen(split))
        SCPHomeLauncherDockSetVisible(YES, @"layout-panel-presented");
}
typedef void (*SCPDockCollapseTrayOriginalType)(id, SEL);
static SCPDockCollapseTrayOriginalType SCPDockCollapseTrayOriginal;
static void SCPDockCollapseTrayReplacement(id split, SEL action) {
    if (SCPDockCollapseTrayOriginal)
        SCPDockCollapseTrayOriginal(split, action);
    // Collapse can animate; recheck after the caller has finished replacing
    // the tray so opening a new panel never transiently releases the dock.
    dispatch_async(dispatch_get_main_queue(), ^{
        if (![(SCPCarSplit *)split active] && !SCPHomeDockPanelOpen(split))
            SCPHomeLauncherDockSetVisible(NO, @"layout-panel-dismissed");
    });
}
static void SCPHomeDockInstallSplitHooks(void) {
    Class splitClass = objc_getClass("SCPCarSplit");
    SEL showSel = NSSelectorFromString(@"showLayoutPanelForApp:");
    Method showMethod = splitClass ? class_getInstanceMethod(splitClass, showSel) : NULL;
    const char *showABI = showMethod ? method_getTypeEncoding(showMethod) : NULL;
    if (showABI && strcmp(showABI, "v24@0:8@16") == 0) {
        MSHookMessageEx(splitClass, showSel, (IMP)SCPDockShowLayoutReplacement,
                        (IMP *)&SCPDockShowLayoutOriginal);
        HLog(@"dock-lifecycle", [NSString stringWithFormat:
            @"show=%@", SCPDockShowLayoutOriginal ? @"installed" : @"not-confirmed"]);
    } else {
        HLog(@"dock-lifecycle", [NSString stringWithFormat:
            @"show=abi-unavailable observed=%s", showABI ?: "none"]);
    }
    SEL collapseSel = NSSelectorFromString(@"collapseAppTray");
    Method collapseMethod = splitClass ? class_getInstanceMethod(splitClass, collapseSel) : NULL;
    const char *collapseABI = collapseMethod ? method_getTypeEncoding(collapseMethod) : NULL;
    if (collapseABI && strcmp(collapseABI, "v16@0:8") == 0) {
        MSHookMessageEx(splitClass, collapseSel, (IMP)SCPDockCollapseTrayReplacement,
                        (IMP *)&SCPDockCollapseTrayOriginal);
        HLog(@"dock-lifecycle", [NSString stringWithFormat:
            @"collapse=%@", SCPDockCollapseTrayOriginal ? @"installed" : @"not-confirmed"]);
    } else {
        HLog(@"dock-lifecycle", [NSString stringWithFormat:
            @"collapse=abi-unavailable observed=%s", collapseABI ?: "none"]);
    }
}

static void SCPHomeDockInstallHooks(void) {
    static BOOL installed = NO;
    if (installed) return;
    installed = YES;
    SCPHomeDockInstallCategoryHook();
    SCPHomeDockInstallSplitHooks();
    Class dockClass = OMCCarClass("DBAppDockViewController");
    SEL tap = NSSelectorFromString(@"_dockButtonPressed:");
    const char *tapType = NULL;
    Method tapMethod = dockClass ? class_getInstanceMethod(dockClass, tap) : NULL;
    if (tapMethod) tapType = method_getTypeEncoding(tapMethod);
    if (tapType && strcmp(tapType, "v24@0:8@16") == 0) {
        MSHookMessageEx(dockClass, tap, (IMP)SCPDockTapReplacement,
                        (IMP *)&SCPDockOriginalTap);
        HLog(@"dock-tap", [NSString stringWithFormat:
            @"status=%@ abi=%s", SCPDockOriginalTap ? @"installed" : @"not-confirmed", tapType]);
    } else {
        HLog(@"dock-tap", [NSString stringWithFormat:
            @"status=abi-unavailable observed=%s", tapType ?: "none"]);
    }
    Class splitClass = objc_getClass("SCPCarSplit");
    SEL closeSel = @selector(closePopups);
    Method closeMethod = splitClass ? class_getInstanceMethod(splitClass, closeSel) : NULL;
    const char *closeType = closeMethod ? method_getTypeEncoding(closeMethod) : NULL;
    if (closeType && strcmp(closeType, "v16@0:8") == 0) {
        MSHookMessageEx(splitClass, closeSel, (IMP)SCPHomeClosePopupsReplacement,
                        (IMP *)&SCPClosePopupsOriginal);
        HLog(@"dock-lifecycle", [NSString stringWithFormat:
            @"status=%@", SCPClosePopupsOriginal ? @"installed" : @"not-confirmed"]);
    } else {
        HLog(@"dock-lifecycle", [NSString stringWithFormat:
            @"status=abi-unavailable observed=%s", closeType ?: "none"]);
    }
}

void SCPHomeLauncherInstallTapHook(void) {
    SCPHomeDockInstallHooks();
    if (SCPHomeTapOriginal) return;
    Class homeVC = OMCCarClass("DBDashboardHomeViewController");
    SEL action = sel_registerName("iconManager:launchIconForIconView:");
    Method method = homeVC ? class_getInstanceMethod(homeVC, action) : NULL;
    const char *type = method ? method_getTypeEncoding(method) : NULL;
    if (!type || strcmp(type, "v32@0:8@16@24") != 0) {
        HLog(@"tap-gate", [NSString stringWithFormat:
            @"status=abi-unavailable observed=%s", type ?: "none"]);
        return;  // never hook an unknown signature
    }
    MSHookMessageEx(homeVC, action,
        (IMP)SCPHomeTapReplacement, (IMP *)&SCPHomeTapOriginal);
    HLog(@"tap-gate", [NSString stringWithFormat:
        @"status=%@ type=%s", SCPHomeTapOriginal ? @"installed" : @"not-confirmed", type]);
}
