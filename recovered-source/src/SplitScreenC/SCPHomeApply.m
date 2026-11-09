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
#import "../SplitScreenB/SCPHomeWallView.h" // B's class: applySettings:source:,
                                            // stopVideo, updatePlayback

NS_ASSUME_NONNULL_BEGIN

NSDictionary *SCPHomeSettings(void);   // SCPHomeSettings.m
NSInteger SCPHomeGridColumns(void);
NSInteger SCPHomeGridRows(void);
BOOL SCPHomeShowNames(void);
void SCPHomePrefSet(NSString *key, id _Nullable value); // SCPAppIcons.m

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
