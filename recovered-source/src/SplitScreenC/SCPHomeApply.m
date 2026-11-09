// SCPHomeApply.m — SplitScreen-C: applying home settings to the live
// DBDashboardHomeViewController, plus the "publish car apps for Settings"
// sync block.
//
// SCPHomeApply is invoked from SplitScreen-A's home-VC lifecycle hooks
// (viewDidLayoutSubviews 0x4cb4, viewDidAppear: 0x4d24) and from
// SCPHomeRefresh. It maintains:
//   - the wallpaper wall view (SplitScreen-B's SCPHomeWallView, tag
//     0x4857) inserted under the icon grid,
//   - icon-size re-layout of every *IconListView in the tree,
//   - grid overrides (via SCPHomeIconModelLayout),
//   - label visibility on every *IconView,
//   - and schedules the delayed sync block sub_4c438 (1 s, generation
//     guarded) which writes the `homeScreenCarApps` pref — the list the
//     Prefs module shows in Settings.

#import "SCPHomeCommon.h"
#import "SCPHomeApply.h"
#import "SCPHomeLauncher.h" // [gpt-home] own icon at YTZ5 close probes
#import "../SplitScreenB/SCPHomeWallView.h" // B's class: applySettings:source:,
                                            // stopVideo, updatePlayback

NS_ASSUME_NONNULL_BEGIN

NSDictionary *SCPHomeSettings(void);   // SCPHomeSettings.m
NSInteger SCPHomeGridColumns(void);
NSInteger SCPHomeGridRows(void);
BOOL SCPHomeShowNames(void);
void SCPHomePrefSet(NSString *key, id _Nullable value); // SCPAppIcons.m
extern NSSet<NSString *> *SCPChosenPhoneApps(void);     // SCPAppIcons.m (0x9a60)

static NSInteger SCPLastIconSize;      // static slot 0x87f48
static NSString *SCPLastGridKey;       // static slot 0x87f40
static BOOL SCPLastShowNames;          // static byte 0x87f50
static NSTimer *SCPVideoRefreshTimer;  // 0x881f0
static NSInteger SCPApplyGeneration;   // 0x881f8

// [homelib] instrument (WO GPT ytz4 item I2, log-only): the executing
// process, read at runtime (used by the post-apply line in
// SCPPublishCarAppsBlock below).
static NSString *SCPHomeLibProcDesc(void) {
    NSString *name = [[NSProcessInfo processInfo] processName] ?: @"?";
    NSString *bundle = [[NSBundle mainBundle] bundleIdentifier] ?: @"?";
    return [NSString stringWithFormat:@"%@(%@)", name, bundle];
}

static void SCPPublishCarAppsBlock(NSInteger generation); // sub_4c438, below
extern void SCPVideoWallpaperTimerTick(void); // sub_4bd7c (SCPHomeSettings.m)

// libroot trampoline (SCPLibRoot.m): char *SCPJBRootPath(const char *, char *)
extern char *SCPJBRootPath(const char *path, char *buf);

// ---- view-tree helpers ------------------------------------------------------

// 0x4bae8 — VERIFIED structure: recursive indented dump of the view tree
// (class, frame in root coordinates, hidden flag) into `out`.
static void SCPDumpViewTree(id root, UIView *view, NSInteger depth,
                            NSMutableString *out) {
    NSString *indent = [@"" stringByPaddingToLength:depth * 2
                                         withString:@" " startingAtIndex:0];
    CGRect f = [view convertRect:view.bounds fromView:view];
    [out appendFormat:@"%@%@ frame=%@ hidden=%d\n", indent, view,
        NSStringFromCGRect(f), [view isHidden]];
    for (UIView *sub in view.subviews)
        SCPDumpViewTree(root, sub, depth + 1, out);
}

// 0x4b0e0 — VERIFIED: one-shot (static byte 0x881e8) diagnostic dump of the
// CarPlay home view tree.
static void SCPDiagHomeTreeOnce(UIView *view) {
    static BOOL done; // 0x881e8
    if (done) return;
    done = YES;
    NSMutableString *out = [NSMutableString string];
    SCPDumpViewTree(view, view, 0, out);
    OMCLogWrite(@"SplitScreen", [NSString stringWithFormat:
        @"HomeScreen: DIAG cay man chinh CarPlay:\n%@", out]);
}

// 0x4be40 — VERIFIED: collect every view whose class name ends with
// "IconListView", recursively.
static void SCPCollectIconListViews(UIView *view, NSMutableArray *out,
                                    NSInteger depth) {
    if ([NSStringFromClass([view class]) hasSuffix:@"IconListView"])
        [out addObject:view];
    for (UIView *sub in view.subviews)
        SCPCollectIconListViews(sub, out, depth + 1);
}

// 0x4c00c — VERIFIED: setNeedsLayout on the view and all descendants.
static void SCPSetNeedsLayoutRecursive(UIView *view, NSInteger depth) {
    [view setNeedsLayout];
    for (UIView *sub in view.subviews)
        SCPSetNeedsLayoutRecursive(sub, depth + 1);
}

// 0x4b1d0 — VERIFIED: force every icon list view in the tree to re-layout.
static void SCPReLayoutIconLists(UIView *view, NSInteger sizePercent) {
    NSMutableArray *lists = [NSMutableArray array];
    SCPCollectIconListViews(view, lists, 0);
    for (UIView *list in lists) {
        SCPSetNeedsLayoutRecursive(list, 0);
        SEL sel = NSSelectorFromString(@"layoutIconsNow");
        if ([list respondsToSelector:sel]) {
            ((void (*)(id, SEL))objc_msgSend)(list, sel);
        } else SCPMissingSelector(list, @"layoutIconsNow");
    }
    NSString *first = lists.count
        ? NSStringFromClass([lists.firstObject class])
        : @"khong thay *IconListView";
    OMCLogWrite(@"SplitScreen", [NSString stringWithFormat:
        @"HomeScreen: co icon %ld%% -> xep lai %lu luoi icon (%@)",
        (long)sizePercent, (unsigned long)lists.count, first]);
}

// 0x4c16c — VERIFIED: recursively set label visibility on every view whose
// class name ends with "IconView"; returns the number of views changed.
static NSUInteger SCPApplyLabelHidden(UIView *view, BOOL hide, NSInteger depth) {
    NSUInteger changed = 0;
    if ([NSStringFromClass([view class]) hasSuffix:@"IconView"]) {
        SEL getSel = NSSelectorFromString(@"isLabelHidden");
        SEL setSel = NSSelectorFromString(@"setLabelHidden:");
        BOOL cur = NO;
        if ([view respondsToSelector:getSel])
            cur = ((BOOL (*)(id, SEL))objc_msgSend)(view, getSel);
        else SCPMissingSelector(view, @"isLabelHidden");
        if (cur != hide) {
            if ([view respondsToSelector:setSel]) {
                ((void (*)(id, SEL, BOOL))objc_msgSend)(view, setSel, hide);
                changed++;
            } else SCPMissingSelector(view, @"setLabelHidden:");
        }
    }
    for (UIView *sub in view.subviews)
        changed += SCPApplyLabelHidden(sub, hide, depth + 1);
    return changed;
}

// ---- the apply pass ----------------------------------------------------------

// 0x4a6d8 (_SCPHomeApply) — VERIFIED
void SCPHomeApply(id homeVC) {
    if (![homeVC isViewLoaded]) return;
    SCPApplyHomeVCWeak = homeVC;
    UIView *view = [homeVC view];
    NSDictionary *settings = SCPHomeSettings();
    SCPHomeWallView *wall = (SCPHomeWallView *)[view viewWithTag:0x4857];

    NSDictionary *source = nil; // @{ @"path": ..., @"video": @BOOL }
    if ([settings[@"on"] boolValue]) {
        NSInteger style = [settings[@"style"] integerValue];
        if (style >= 1) {
            char buf[1024];
            const char *rooted = SCPJBRootPath(
                [@"/var/mobile/Library/OmniCar" fileSystemRepresentation], buf);
            NSString *dir = rooted ? [NSString stringWithUTF8String:rooted] : nil;
            NSString *path = (style == 8)
                ? [dir stringByAppendingPathComponent:@"HomeScreen/video.mp4"]
                : [dir stringByAppendingPathComponent:@"HomeScreen/wallpaper.jpg"];
            if (path && [[NSFileManager defaultManager] fileExistsAtPath:path])
                source = @{@"path": path, @"video": @(style == 8)};
        }
    }

    if (source) {
        SCPDiagHomeTreeOnce(view);
        if (!wall) {
            wall = [[SCPHomeWallView alloc] initWithFrame:view.bounds];
            wall.tag = 0x4857;
            wall.autoresizingMask = UIViewAutoresizingFlexibleWidth |
                                    UIViewAutoresizingFlexibleHeight; // 0x12
            [view insertSubview:wall atIndex:0];
            OMCLogWrite(@"SplitScreen", [NSString stringWithFormat:
                @"HomeScreen: hinh nen rieng %@ duoi luoi icon CarPlay",
                [source[@"video"] boolValue] ? @"(video)" : @"(anh)"]);
        }
        wall.frame = view.bounds;
        if (view.subviews.firstObject != wall) [view sendSubviewToBack:wall];
        if ([source[@"video"] boolValue] && !SCPVideoRefreshTimer) {
            SCPVideoRefreshTimer =
                [NSTimer scheduledTimerWithTimeInterval:30.0 repeats:YES
                    block:^(NSTimer *t) { SCPVideoWallpaperTimerTick(); }];
        }
        [wall applySettings:settings source:source];
    } else if (wall) {
        OMCLogWrite(@"SplitScreen",
            @"HomeScreen: bo hinh nen rieng -> hinh nen CarPlay");
        [wall stopVideo];
        [wall removeFromSuperview];
        wall = nil;
    }

    NSInteger size = [settings[@"on"] boolValue]
        ? [settings[@"size"] integerValue] : 100;
    if (size != SCPLastIconSize) {
        SCPLastIconSize = size;
        SCPDiagHomeTreeOnce(view);
        SCPReLayoutIconLists(view, size);
    }

    NSString *gridKey = [NSString stringWithFormat:@"%ldx%ld",
                         (long)SCPHomeGridColumns(), (long)SCPHomeGridRows()];
    if (![gridKey isEqualToString:SCPLastGridKey]) {
        SCPLastGridKey = gridKey;
        SCPDiagHomeTreeOnce(view);
        SCPHomeIconModelLayout([@"luoi " stringByAppendingString:gridKey]);
        SCPReLayoutIconLists(view, size);
    }

    BOOL showNames = SCPHomeShowNames();
    if (showNames != SCPLastShowNames || !showNames) {
        NSMutableArray *lists = [NSMutableArray array];
        SCPCollectIconListViews(view, lists, 0);
        NSUInteger changed = 0;
        for (UIView *list in lists)
            changed += SCPApplyLabelHidden(list, !showNames, 0);
        if (showNames != SCPLastShowNames) {
            OMCLogWrite(@"SplitScreen", [NSString stringWithFormat:
                @"HomeScreen: ten app %@ (%lu icon)",
                showNames ? @"hien" : @"an", (unsigned long)changed]);
        }
        SCPLastShowNames = showNames;
    }

    NSInteger generation = ++SCPApplyGeneration;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 1000000000),
                   dispatch_get_main_queue(), ^{
        SCPPublishCarAppsBlock(generation); // sub_4c438, below
    });

    // [iconstate] (YTZ5 I5, log-only) third call point: post-apply probe.
    // SCPHomeApply runs on every home layout/appear pass, which is far
    // denser than one line per measured bundle warrants, so this call
    // site — not the instrument itself, whose close-path callers (B5)
    // must stay unthrottled — is throttled to at most one probe per
    // second. The timestamp is a function-local static: no state is
    // shared with, or retained for, the instrument.
    static CFAbsoluteTime SCPHomeApplyLastIconStateProbe;
    CFAbsoluteTime iconStateNow = CFAbsoluteTimeGetCurrent();
    if (iconStateNow - SCPHomeApplyLastIconStateProbe >= 1.0) {
        SCPHomeApplyLastIconStateProbe = iconStateNow;
        SCPLogInjectedIconState(@"after-home", @"home");
    }
}

// ---- [iconstate] instrument (YTZ5 strand I5, log-only) ----------------------
//
// SCPLogInjectedIconState(phase, src) — declared in SCPHomeApply.h; the
// SplitScreen-A close-path strand (B5) calls it at its T1/T2/T3 points,
// and SCPHomeApply calls it post-apply above (throttled there, not here).
//
// Ground rules (map-m5-icon.md §1/§4, CHANGE_MAP_YTZ5 M5):
//  - The ONLY grid root is the weak home view controller
//    (SCPApplyHomeVCWeak, falling back to SCPHomeVCWeak), walked exactly
//    like SCPPublishCarAppsBlock below: SCPCollectIconListViews over its
//    view, then model -> lists -> icons -> applicationBundleID per list
//    view (SCPHomeApply.m:255-263 pattern). This function NEVER walks
//    the scene/window hierarchy (that is the blind-by-construction
//    reader in SCPCarApps.m, now tagged blind=1 in its own log line).
//  - Measured bundles: SCPChosenPhoneApps() (SCPAppIcons.m, the
//    `appBridgeApps` pref set) is the only enumerable source of truth in
//    this tree — the injected set SCPAppIcons maintains
//    (SCPInjectedAppsSet) is file-static there with no enumerator, so
//    per-bundle injected status is sampled through its exported
//    predicate SCPIsInjectedPhoneApp() and logged as injected=.
//  - Validity gate: a walk vouches for itself only when it collected
//    lists>0 AND modelIcons>0 (modelIcons = total icon objects iterated
//    across every list's model->lists). Gate not met -> every bundle
//    logs state=BLIND with a reason and NO presence conclusion.
//  - Gate met: bundle in the model set -> PRESENT-MODEL; not in the
//    model set -> ABSENT-MODEL. The state token claims MODEL presence
//    only; the dock= field is always appended on gate-met lines so a
//    dock-only bundle reads ABSENT-MODEL dock=present instead of being
//    mistaken for absent everywhere.
//  - Cell fields are reported only when the walk actually reaches the
//    *IconView of that exact bundle (view -> icon -> bundle, the
//    -iconLongPressedUnsafe: pattern); otherwise cell=unreadable. This
//    instrument never claims cell-level presence in its state token.
//  - Log-only: no state is written, no event is sent (in particular no
//    dashboard event-1), and nothing outlives the call — the weak home
//    VC is held only in a local for the duration of the walk, exactly
//    like SCPPublishCarAppsBlock does.

// Bundle id of an icon model object, walker fallback order (same getters
// as SCPWalkerIconBundleID, SCPCarApps.m:74-85, via this family's safe
// perform helper).
static NSString *_Nullable SCPHomeIconStateBundleID(id _Nullable icon) {
    if (!icon) return nil;
    for (NSString *key in @[@"applicationBundleID", @"leafIdentifier",
                            @"bundleIdentifier"]) {
        id v = SCPHomeSafePerform(icon, key);
        if ([v isKindOfClass:[NSString class]] && [(NSString *)v length] > 0)
            return v;
    }
    return nil;
}

// Recursively collect, from a view subtree, the first *IconView per
// wanted bundle (view -> @"icon" -> bundle, the hit-test pattern of
// -iconLongPressedUnsafe: in SplitScreen-A). Depth-capped like the
// other walkers in this tree; views are stored only in the caller's
// call-scoped dictionary, never retained beyond the probe.
static void SCPHomeIconStateCollectCells(UIView *view, NSInteger depth,
                                         NSSet<NSString *> *wanted,
                                         NSMutableDictionary<NSString *, UIView *> *cells) {
    if (!view || depth > 14) return;
    if ([NSStringFromClass([view class]) hasSuffix:@"IconView"]) {
        id icon = SCPHomeSafePerform(view, @"icon");
        NSString *bid = SCPHomeIconStateBundleID(icon);
        if (bid.length && [wanted containsObject:bid] && !cells[bid])
            cells[bid] = view;
    }
    for (UIView *sub in view.subviews)
        SCPHomeIconStateCollectCells(sub, depth + 1, wanted, cells);
}

// Dock presence per bundle, through the existing dashboard dock path
// (SCPShared.m:53-63 + SCPCarSplit.m:3160-3172 pattern, re-implemented
// with this family's safe getters so SplitScreen-C stays self-contained):
// dashboard (_currentDashboard) -> rootViewController ->
// appDockViewController -> view. Returns @"unknown" when any link is
// missing or the dock view is windowless/hidden (the conditions the
// existing dock code itself treats as invalid); otherwise walks the
// dock view's subtree with the same view->icon->bundle pattern, fills
// dockBundles with every wanted bundle found there, and returns
// @"read" (the caller derives per-bundle present/absent from the set).
static NSString *SCPHomeIconStateDockStatus(NSSet<NSString *> *wanted,
                                            NSMutableSet<NSString *> *dockBundles) {
    id dashboard = SCPHomeSafeGet([UIApplication sharedApplication],
                                   @"_currentDashboard");
    id root = SCPHomeSafeGet(dashboard, @"rootViewController");
    id dockVC = SCPHomeSafeGet(root, @"appDockViewController");
    UIView *dockView = SCPHomeSafeGet(dockVC, @"view");
    if (![dockView isKindOfClass:[UIView class]]) return @"unknown";
    if (!dockView.window || dockView.isHidden) return @"unknown";
    NSMutableDictionary<NSString *, UIView *> *dockCells =
        [NSMutableDictionary dictionary];
    SCPHomeIconStateCollectCells(dockView, 0, wanted, dockCells);
    [dockBundles addObjectsFromArray:dockCells.allKeys];
    return @"read";
}

void SCPLogInjectedIconState(NSString *phase, NSString *src) {
    // [gpt-home] Reuse YTZ5 before/after-close measurement instants.
    // Own OmniCar is NOT in appBridgeApps, so measure it independently.
    SCPHomeLauncherAuditModel([NSString stringWithFormat:@"ytz5-%@-%@", phase ?: @"?", src ?: @"?"]);
    NSString *safePhase = phase.length ? phase : @"?";
    NSString *safeSrc = src.length ? src : @"?";
    // Deterministic per-bundle line order across runs.
    NSArray<NSString *> *bundles =
        [[SCPChosenPhoneApps() allObjects]
            sortedArrayUsingSelector:@selector(compare:)];
    if (!bundles.count) return; // nothing chosen -> nothing to measure

    NSSet<NSString *> *wanted = [NSSet setWithArray:bundles];
    NSString *blindReason = nil;
    NSUInteger listsCount = 0;
    NSUInteger modelIcons = 0;
    NSMutableSet<NSString *> *modelBundles = [NSMutableSet set];
    NSMutableDictionary<NSString *, UIView *> *cells =
        [NSMutableDictionary dictionary];
    NSMutableSet<NSString *> *dockBundles = [NSMutableSet set];
    NSString *dockStatus = @"unknown";
    @try {
        // Weak home VC only (no strong reference is kept anywhere):
        // the apply-pass weak first, the hook-stored weak as fallback.
        id homeVC = SCPApplyHomeVCWeak ?: SCPHomeVCWeak;
        UIView *view = nil;
        if (!homeVC) blindReason = @"no-homevc";
        else if (![homeVC isViewLoaded]) blindReason = @"view-not-loaded";
        else if (!(view = [homeVC view])) blindReason = @"no-view";
        else if (!view.window) blindReason = @"no-window";
        if (!blindReason) {
            NSMutableArray *lists = [NSMutableArray array];
            SCPCollectIconListViews(view, lists, 0);
            listsCount = lists.count;
            for (UIView *listView in lists) {
                id model = SCPHomeSafePerform(listView, @"model");
                for (id iconList in SCPHomeSafePerform(model, @"lists") ?: @[]) {
                    for (id icon in SCPHomeSafePerform(iconList, @"icons") ?: @[]) {
                        modelIcons++;
                        NSString *bid =
                            SCPHomeSafePerform(icon, @"applicationBundleID");
                        if (bid.length) [modelBundles addObject:bid];
                    }
                }
                // Cell attempt for the same list view's subtree; most
                // bundles stay unreadable here (no model->cell path in
                // the original — map-m5-icon §4c), which is reported,
                // never papered over.
                SCPHomeIconStateCollectCells(listView, 0, wanted, cells);
            }
            if (listsCount == 0) blindReason = @"no-listview";
            else if (modelIcons == 0) blindReason = @"empty-model";
            if (!blindReason)
                dockStatus = SCPHomeIconStateDockStatus(wanted, dockBundles);
        }
    } @catch (NSException *e) {
        blindReason = @"exception";
        listsCount = 0;
        modelIcons = 0;
    }

    BOOL gateOK = (blindReason == nil); // lists>0 && modelIcons>0, checked above
    for (NSString *bid in bundles) {
        if (!gateOK) {
            OMCLogWrite(@"SplitScreen", [NSString stringWithFormat:
                @"[iconstate] phase=%@ src=%@ bundle=%@ state=BLIND reason=%@ lists=%lu modelIcons=%lu",
                safePhase, safeSrc, bid, blindReason ?: @"unknown",
                (unsigned long)listsCount, (unsigned long)modelIcons]);
            continue;
        }
        NSString *dock = [dockStatus isEqualToString:@"read"]
            ? ([dockBundles containsObject:bid] ? @"present" : @"absent")
            : @"unknown";
        if ([modelBundles containsObject:bid]) {
            UIView *cell = cells[bid];
            NSString *cellDesc = @"cell=unreadable";
            if (cell) {
                cellDesc = [NSString stringWithFormat:
                    @"cell=read window=%d hidden=%d alpha=%.2f frame=%@",
                    cell.window ? 1 : 0, cell.isHidden ? 1 : 0,
                    (double)cell.alpha, NSStringFromCGRect(cell.frame)];
            }
            OMCLogWrite(@"SplitScreen", [NSString stringWithFormat:
                @"[iconstate] phase=%@ src=%@ bundle=%@ state=PRESENT-MODEL lists=%lu modelIcons=%lu injected=%d dock=%@ %@",
                safePhase, safeSrc, bid,
                (unsigned long)listsCount, (unsigned long)modelIcons,
                SCPIsInjectedPhoneApp(bid) ? 1 : 0, dock, cellDesc]);
        } else {
            OMCLogWrite(@"SplitScreen", [NSString stringWithFormat:
                @"[iconstate] phase=%@ src=%@ bundle=%@ state=ABSENT-MODEL lists=%lu modelIcons=%lu injected=%d dock=%@",
                safePhase, safeSrc, bid,
                (unsigned long)listsCount, (unsigned long)modelIcons,
                SCPIsInjectedPhoneApp(bid) ? 1 : 0, dock]);
        }
    }
}

// ---- delayed sync: publish the car-home app list for Settings ----------------
//
// 0x4c438 (invoke of the stack block built at the end of SCPHomeApply;
// descriptor 0x789a0 is shared with SCPRefreshAppIconsSoon's block — the
// invoke pointer is what identifies it). Structure VERIFIED at call-
// sequence level; the exact merge ordering in the middle section is
// INFERRED where noted in the report.
//
// What it does: walk the live icon model of every *IconListView, collect
// @{ @"id": bundleId, @"name": displayName } for every real (non-folder)
// icon, resolve names through the shared application library, drop the
// InCallService / CarPlay-system entries, preserve the user's previous
// ordering from the existing `homeScreenCarApps` value, sort newcomers by
// name, and write the result back to `homeScreenCarApps` (reading
// `homeScreenHiddenApps` as part of the merge) so the Prefs module can
// present the list in Settings.
static void SCPPublishCarAppsBlock(NSInteger generation) {
    if (generation != SCPApplyGeneration) return; // superseded by a newer apply
    id homeVC = SCPApplyHomeVCWeak;
    if (![homeVC isViewLoaded]) return;
    UIView *view = [homeVC view];
    if (!view.window) return;
    @try {
        NSMutableArray *lists = [NSMutableArray array];
        SCPCollectIconListViews(view, lists, 0);
        NSMutableArray<NSDictionary *> *found = [NSMutableArray array];
        BOOL homelibOmniOnGrid = NO; // [homelib] OmniCar's own app seen in the walk below
        NSMutableSet<NSString *> *seen = [NSMutableSet set];
        for (UIView *listView in lists) {
            id model = SCPHomeSafePerform(listView, @"model");
            id folder = SCPHomeSafePerform(listView, @"folder");
            (void)folder;
            for (id iconList in SCPHomeSafePerform(model, @"lists") ?: @[]) {
                for (id icon in SCPHomeSafePerform(iconList, @"icons") ?: @[]) {
                    NSString *bid = SCPHomeSafePerform(icon, @"applicationBundleID");
                    // [homelib] presence is sampled BEFORE the seen/injected
                    // filters: an injected OmniCar icon is still on the grid.
                    if ([bid isEqualToString:@"com.anlai.omnicar.app"]) homelibOmniOnGrid = YES;
                    if (!bid.length || [seen containsObject:bid]) continue;
                    if (SCPIsInjectedPhoneApp(bid)) continue;
                    [seen addObject:bid];
                    id library = SCPHomeSafeGet([UIApplication sharedApplication],
                                                @"sharedApplicationLibrary");
                    id info = nil;
                    SEL lookup = NSSelectorFromString(@"applicationInfoForBundleIdentifier:");
                    if ([library respondsToSelector:lookup])
                        info = ((id (*)(id, SEL, id))objc_msgSend)(library, lookup, bid);
                    NSString *name = SCPHomeSafeGet(info, @"displayName");
                    if (!name.length) name = bid;
                    [found addObject:@{@"id": bid, @"name": name}];
                }
            }
        }
        OMCPrefsSync();
        NSArray *previous = OMCPref(@"homeScreenCarApps", nil);
        NSSet *hidden = nil;
        id hv = OMCPref(@"homeScreenHiddenApps", nil);
        hidden = [hv isKindOfClass:[NSArray class]] ? [NSSet setWithArray:hv]
                                                    : [NSSet set];
        (void)hidden; // consulted during the merge in the original
        NSMutableArray<NSDictionary *> *merged = [NSMutableArray array];
        NSMutableSet<NSString *> *used = [NSMutableSet set];
        if ([previous isKindOfClass:[NSArray class]]) {
            for (NSDictionary *old in previous) {
                NSString *bid = old[@"id"];
                for (NSDictionary *now in found) {
                    if ([now[@"id"] isEqualToString:bid] &&
                        ![used containsObject:bid]) {
                        [merged addObject:now];
                        [used addObject:bid];
                    }
                }
            }
        }
        NSMutableArray<NSDictionary *> *fresh = [NSMutableArray array];
        for (NSDictionary *now in found)
            if (![used containsObject:now[@"id"]]) [fresh addObject:now];
        [fresh sortUsingDescriptors:@[[NSSortDescriptor
            sortDescriptorWithKey:@"name" ascending:YES
                         selector:@selector(localizedCaseInsensitiveCompare:)]]];
        [merged addObjectsFromArray:fresh];
        if (![merged isEqualToArray:previous ?: @[]]) {
            SCPHomePrefSet(@"homeScreenCarApps", merged);
            NSMutableArray<NSString *> *ids = [NSMutableArray array];
            for (NSDictionary *e in merged) [ids addObject:e[@"id"]];
            OMCLogWrite(@"SplitScreen", [NSString stringWithFormat:
                @"HomeScreen: %lu app tren man chinh cho Cai dat: %@",
                (unsigned long)merged.count,
                [ids componentsJoinedByString:@", "]]);
        }
        // [homelib] post-apply grid state (log-only; every publish run.
        // count = real icons the walk above collected from the live icon
        // model — injected phone apps are excluded by the walk's own
        // filter, omni= is sampled before that filter).
        OMCLogWrite(@"SplitScreen", [NSString stringWithFormat:
            @"[homelib] proc=%@ event=apply-published count=%lu omni=%d",
            SCPHomeLibProcDesc(), (unsigned long)found.count, homelibOmniOnGrid]);
    } @catch (NSException *e) {
        OMCLogWrite(@"SplitScreen", [NSString stringWithFormat:
            @"HomeScreen: ghi danh sach app loi %@", e]);
    }
}

NS_ASSUME_NONNULL_END
