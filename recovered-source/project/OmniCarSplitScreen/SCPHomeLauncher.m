// SCPHomeLauncher.m — OmniCar's OWN CarPlay Home launcher (GPT).
//
// Triad: real installed LS proxy -> own DBApplicationInfo declaration ->
// original icon model / scoped visibility -> Dashboard tap intercepted
// into the SINGLE existing -[SCPCarSplit showLayoutPanelForApp:] controller.
//
// No fake Home view, no new split engine, no global entitlement spoof,
// no on-disk preference or native app-list mutation, no iPhone app launch.
// Runtime private-ABI behaviour remains PENDING-DEVICE until car test.
#import "SCPHomeLauncher.h"
#import "SCPHomeCommon.h"
#import "SCPShared.h"
#import "SCPPrefs.h"
#import "SCPCarSplit.h"
#import "SCPCarSplit+AutoHide.h"
#import <objc/message.h>
#import <objc/runtime.h>
#import <QuartzCore/QuartzCore.h>
#import <substrate.h>

static NSString *const OwnID = @"com.anlai.omnicar.app";
static NSString *const OwnTag = @"OmniCarHomeLauncher";

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
            SCPHomeLauncherInjectInfo(info);
            return NO;  // present in library != icon/model/cell/tap
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
    } @catch (NSException *e) {
        HLog(@"reconcile", [NSString stringWithFormat:
            @"reason=%@ exception=%@", reason, e.name]);
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
    if (SCPHomeLauncherIsBundle(bundle) &&
        SCPHomeLauncherConsumeLaunch(bundle, @"iconManager:launchIconForIconView:")) {
        HLog(@"tap-gate", @"status=consumed-own-icon");
        return;
    }
    // Exact single original forwarding for EVERY non-own/unknown icon.
    if (SCPHomeTapOriginal) SCPHomeTapOriginal(homeVC, action, manager, iconView);
}

void SCPHomeLauncherInstallTapHook(void) {
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
