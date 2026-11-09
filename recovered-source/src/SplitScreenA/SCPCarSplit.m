// SCPCarSplit.m — OmniCarSplitScreen, agent A domain.
// Reconstructed from arm64 disassembly of OmniCarSplitScreen.dylib.
// Every method carries its status; the per-function evidence table is in
// SplitScreenA_REPORT.md. Methods of agent B's domain (geometry, dividers,
// picker/tray UI) are declared in SCPCarSplit.h and implemented by agent B;
// they are called here but not defined in this file.
//
// Conventions proven throughout the binary and used below:
//  - Private-class access is always NSSelectorFromString +
//    respondsToSelector:, with SCPMissingSelector() on the failure path.
//    Written here via SCPGuardedSend-style inline code (see SCPShared.m).
//  - Most public entry points are wrapped in @try/@catch with
//    SCPExceptionLog("<name>", ex) — shown once per method where proven.
//  - All delays go through SCPDispatchAfter() (sub_12efc).

#import "SCPCarSplit.h"
#import "SCPShared.h"
#import "SCPPrefs.h"
#import "SCPSmallClasses.h"
#import "SCPCButton.h" // integration (remediation): the home/dock helpers
// below use SCPCButton as a full class (buttonWithType:, UIView
// properties) — the in-implementation forward declaration is not enough.
#import <objc/message.h>
#import <objc/runtime.h> // remediation: installLongPressIn:depth: uses associated objects (IMP 0x44344)
#import <notify.h> // remediation: publishBusy uses notify_register_check/set_state/post (IMP 0x15834)
#import "SCPCarSplit+BridgeWake.h" // [wake1] bridgewake recompute/teardown call points (design §1.3)
#import "SCPPinchController.h" // [pinch1] integration glue: attach/detach (design-pinch §7, 2 lines max)
#import "SCPFullscreenController.h" // [fs1] glue: shortened restore when the session ends (design-fullscreen-fs1 §4.6)
#import "SCPCarSplit+AutoHide.h" // [autohide] fade payload keys + activity feeds + teardown (design-autohide §5.1)
#import "../SplitScreenC/SCPHomeApply.h" // [ytz5] SCPLogInjectedIconState (M5 icon instrument points in closeGoingHome:)
#import "../SplitScreenC/SCPHomeLauncher.h" // [gpt-home] native Home entry is authoritative

static id SCPGuarded(id obj, NSString *selName) {
    SEL sel = NSSelectorFromString(selName);
    if ([obj respondsToSelector:sel])
        return ((id (*)(id, SEL))objc_msgSend)(obj, sel);
    SCPMissingSelector(obj, selName);
    return nil;
}

// The current fullscreen base VC of the dashboard root (guarded private API).
static UIViewController *SCPCurrentBaseViewController(SCPCarSplit *self) {
    (void)self;
    id root = SCPDashboardRootViewController();
    if (!root) return nil;
    return SCPGuarded(root, @"currentBaseViewController");
}

// [scenevis] instrument (WO GPT item 4a, LOG-ONLY — reads state, changes
// nothing): one line per scene presentation event naming the pane's
// bundle/slot, whether a scene object exists (attachment), whether the
// VC's view actually sits in the pane host (inHost), and the view's
// hidden/alpha/window state — the discriminator for "scene frame OK but
// pane renders white". Lifecycle events pass force=YES and are never
// dropped; the verify path passes force=NO and is throttled to one line
// per (event, bundle) per second.
static NSMutableDictionary<NSString *, NSDate *> *SCPSceneVisLastLog;
static void SCPSceneVisLog(NSString *event, SCPCarPane *pane,
                           UIViewController *vc, BOOL force) {
    if (!vc) vc = pane.vc;
    NSString *bundle = pane.bundleID;
    if (!force) {
        if (!SCPSceneVisLastLog) SCPSceneVisLastLog = [NSMutableDictionary dictionary];
        NSString *key = [NSString stringWithFormat:@"%@|%@", event, bundle ?: @""];
        NSDate *now = [NSDate date];
        NSDate *last = SCPSceneVisLastLog[key];
        if (last && [now timeIntervalSinceDate:last] < 1.0) return;
        SCPSceneVisLastLog[key] = now;
    }
    UIView *view = (vc && vc.isViewLoaded) ? vc.view : nil;
    id scene = vc ? SCPSceneOfVC(vc) : nil;
    NSString *sceneID = scene ? SCPSceneIdentifierOfVC(scene) : nil;
    OMCLogWrite(@"SplitScreen", [NSString stringWithFormat:
        @"[scenevis] %@ bundle=%@ slot=%d scene=%@ attached=%d inHost=%d hidden=%d alpha=%.2f window=%d",
        event, bundle ?: @"?", pane ? (int)pane.slot : -1,
        sceneID ?: (scene ? @"?" : @"nil"), scene != nil,
        (view && pane && view.superview == pane.host) ? 1 : 0,
        view ? (view.hidden ? 1 : 0) : -1,
        view ? view.alpha : -1.0,
        (view && view.window) ? 1 : 0]);
}

@implementation SCPCarSplit

// +shared (0xfdf4) VERIFIED: dispatch_once singleton; the once-block
// (sub_56090) allocates the single instance. Globals: instance 0x88128,
// once token 0x88130.
+ (instancetype)shared {
    static SCPCarSplit *instance;
    static dispatch_once_t once;
    dispatch_once(&once, ^{ instance = [[self alloc] init]; });
    return instance;
}

// -init VERIFIED (skeleton): [super init] + two NSMutableDictionary
// creations (pending and cancelledLaunches). The remaining ivars are
// created lazily (slots/fractions in -ensureContainer / -setPaneCount:).
- (instancetype)init {
    self = [super init];
    if (self) {
        _pending = [NSMutableDictionary dictionary];
        _cancelledLaunches = [NSMutableDictionary dictionary];
    }
    return self;
}

#pragma mark - Activation / session lifecycle

// -activate (0x15c24) VERIFIED: tail-call.
- (BOOL)activate { return [self activateWithCount:2]; }

// -activateWithLayout: (0x15c2c) VERIFIED (rem_activateWithLayout.txt):
// when already active it just switches layout; otherwise it derives the
// pane count from the layout id (13/31 -> 3, 2/3 -> itself, else 2),
// activates, and only for the two stacked layouts (13/31) applies the
// layout kind afterwards (13 -> 1, 31 -> 2 per the csinc in the binary).
- (BOOL)activateWithLayout:(NSInteger)layout {
    if (self.active) {
        [self switchToLayout:layout];
        return YES;
    }
    NSInteger count = ((layout & ~1) == 2) ? layout : 2;
    if (layout == 13 || layout == 31) count = 3;
    if (![self activateWithCount:count]) return NO;
    if (layout == 13 || layout == 31) {
        self.layoutKind = (layout == 13) ? 1 : 2;
        [self resetFractions];
        [self rebuildDividers];
        [self relayoutAnimated:NO];
    }
    return YES;
}

// -activateWithCount: (0x15cdc) VERIFIED (control flow read end-to-end,
// remediation re-check rem_activateWithCount.txt + rem_suppressReopen_*).
- (BOOL)activateWithCount:(NSInteger)count {
    if (![SCPPrefs enabled]) return NO;
    [self removeAppTab];
    if (self.active) {
        if (self.container.superview) { [self raise]; return YES; }
    }
    UIViewController *currentBase = SCPCurrentBaseViewController(self);
    // Decide whether the currently fullscreen app should be re-opened into
    // the left pane. VERIFIED predicate (remediation): the csinc sequence
    // at 0x15de0-0x15e00 skips the resolution exactly when currentBase is
    // nil OR suppressReopen is set, so reopen resolution runs iff
    // currentBase && !suppressReopen && isAdoptableViewController: — the
    // shape below is the binary's, not an inference.
    NSString *reopenBundle = nil;
    if (currentBase && !self.suppressReopen && [self isAdoptableViewController:currentBase]) {
        id appInfo = SCPGuarded(currentBase, @"applicationInfo");
        id proxyInfo = SCPGuarded(currentBase, @"proxyApplicationInfo");
        reopenBundle = SCPRealBundleForInfos(appInfo, proxyInfo);
    }
    if (self.soloHostedBundle) {
        if (!reopenBundle && !self.suppressReopen) reopenBundle = self.soloHostedBundle;
        [self endHostedSolo];
    }
    if (currentBase) {
        OMCLogWrite(@"SplitScreen", [NSString stringWithFormat:
            @"CarSplit: dang mo %@ toan man -> ve man chinh truoc%@",
            currentBase, reopenBundle ? [NSString stringWithFormat:@", mo lai %@ vao ngan trai", reopenBundle] : @""]);
        SCPSendDashboardEvent(1, @"SplitScreen: mo split");   // VERIFIED type 1 + this context string
        [self dismissStuckBaseSoon];
        self.nextLaunchAt = CFAbsoluteTimeGetCurrent() + 0.5; // VERIFIED +0.5 s
    }
    if (![self ensureContainer]) return NO;
    self.active = YES;
    [self ahSessionStarted]; // [autohide] session-start counterpart of ahSessionTeardown in dashboardInvalidated: the first 4.0 s clock runs from activation, not from the first touch (impl-autohide-car1 §4.2)
    self.focusedSlot = 0;
    [self publishBusy];
    [self.pending removeAllObjects];
    self.layoutKind = 0;
    [self setPaneCount:count];
    OMCLogWrite(@"SplitScreen", [NSString stringWithFormat:@"CarSplit: bat split CarPlay (%d o)", (int)self.paneCount]);
    [self showTipSoon];
    [self relayoutAnimated:NO];
    // Entry animation (VERIFIED, remediation: __const slots read directly
    // — scale 0.97 @0x6f090, duration 0.35 @0x6f098, damping 0.9 @0x6f028,
    // initialSpringVelocity 0.3 @0x6f010; block invoke @0x16428 dumped in
    // rem_activate_anim_block.txt sets alpha 1 + identity transform).
    self.container.alpha = 0;
    self.container.transform = CGAffineTransformMakeScale(0.97, 0.97);
    [UIView animateWithDuration:0.35 delay:0 usingSpringWithDamping:0.9
          initialSpringVelocity:0.3 options:0 animations:^{
              self.container.alpha = 1;
              self.container.transform = CGAffineTransformIdentity;
          } completion:nil];
    if (reopenBundle) [self openApp:reopenBundle slot:0];
    return YES;
}

// -carScreenAppeared VERIFIED: once per connection — post the ready signal
// for the SpringBoard side, then auto-launch the remembered layout when the
// user enabled it.
- (void)carScreenAppeared {
    if (self.autoLaunchDone) return;
    self.autoLaunchDone = YES;
    [[NSDistributedNotificationCenter defaultCenter]
        postNotificationName:SCPNoteScreenReady object:nil userInfo:nil];
    if ([SCPPrefs enabled] && [SCPPrefs autoLaunch]) {
        OMCLogWrite(@"SplitScreen", @"CarSplit: cam xe -> se tu mo split");
        [self autoLaunchAttempt:0];
    }
}

// -autoLaunchAttempt: VERIFIED (IMP 0x44dc4; retry block invoke 0x44ee4,
// terminal block invoke 0x44f30): while there is no dashboard root and
// attempt <= 39, retry after 1.0 s; once a root exists — or attempts are
// exhausted (attempt > 39) — schedule the terminal open after 1.5 s.
- (void)autoLaunchAttempt:(int)attempt {
    if (self.active) return;
    __weak SCPCarSplit *weakSelf = self;
    id root = SCPDashboardRootViewController();
    if (attempt > 39 || root) {
        SCPDispatchAfter(1.5, ^{
            SCPCarSplit *s = weakSelf;
            if (!s || s.active) return;
            OMCLogWrite(@"SplitScreen", [NSString stringWithFormat:@"CarSplit: tu mo split khi cam xe"]);
            [s openRememberedPairForConnect];
        });
    } else {
        SCPDispatchAfter(1.0, ^{ [weakSelf autoLaunchAttempt:attempt + 1]; });
    }
}

// -rootDidLayout (0x15984) VERIFIED (disasm/-SCPCarSplit_rootDidLayout.txt,
// re-read end-to-end in fix-round2 — the previous body was WRONG: it
// returned early when inactive and called refreshAppTab on the active
// path): publish busy state; when INACTIVE, tail-call refreshAppTab
// (0x159b4 tbz -> 0x15ab0 -> tail 0x15ad0) and nothing else; when active
// and the container has a superview, refreshHomeButton, then follow the
// dashboard's app-area: when the container's frame no longer matches
// appAreaInParent:, log + resize + relayoutAnimated:NO (tail call).
// The original calls refreshAppTab on NO active branch.
- (void)rootDidLayout {
    [self publishBusy];
    if (!self.active) { [self refreshAppTab]; return; }
    UIView *parent = self.container.superview;
    if (!parent) return;
    [self refreshHomeButton];
    CGRect area = [self appAreaInParent:parent];
    if (!CGRectEqualToRect(area, self.container.frame)) {
        OMCLogWrite(@"SplitScreen", [NSString stringWithFormat:@"CarSplit: vung app doi %@ -> %@",
            NSStringFromCGRect(self.container.frame), NSStringFromCGRect(area)]);
        self.container.frame = area;
        [self relayoutAnimated:NO];
    }
}

// -baseViewControllerPresented (0x214b8) VERIFIED (remediation,
// rem_baseVCPresented.txt + block @0x21564 rem_baseVCPresented_block.txt):
// a fullscreen app took over while a hosted app was solo -> end the solo
// session; dismiss the solo cover after 0.35 s (constant @0x6f098).
- (void)baseViewControllerPresented {
    [self endHostedSolo];
    if (self.soloCover) {
        __weak SCPCarSplit *weakSelf = self;
        SCPDispatchAfter(0.35, ^{ [weakSelf hideSoloCover]; });
    }
}

// -dashboardInvalidated (0x22724) VERIFIED: the disconnect/teardown path
// driven by the DBDashboard -invalidate hook. Tears down every piece of
// session UI and state; safe to call when inactive (the split-specific
// part is guarded by self.active in the original — inactive callers get
// only the unconditional prologue, 0x22754-0x227e4, then return at
// 0x22a14). Fix-round2 Item D: the active branch ENDS with
// setSlots:/setFractions:/setDividers: nil (0x229f8/0x22a04/0x22a10,
// right after setContainer: nil) and sets dragTarget to -1
// (0x22958 w2=#-1), NOT 0 — both restored; the previous body dropped
// the three clears and used dragTarget = 0.
- (void)dashboardInvalidated {
    [self removeAppTab];
    [self removeHomeButton];
    self.autoLaunchDone = NO;
    self.soloHostedBundle = nil;
    [self removePickerSheet];
    self.trayWindow.hidden = YES;
    self.trayWindow = nil;
    [self.popupShield removeFromSuperview];
    self.popupShield = nil;
    self.shieldPosted = NO;
    if (self.active) {
        OMCLogWrite(@"SplitScreen", @"CarSplit: DashBoard invalidate -> bo split");
        for (SCPCarPane *pane in [self allPanes]) // [scenevis] snapshot before teardown
            SCPSceneVisLog(@"invalidate", pane, pane.vc, YES);
        self.active = NO;
        [self bwSessionTeardown]; // [wake1] the "setActive:NO" point: all slots -> INACTIVE (design §1.3 point 3)
        [self ahSessionTeardown]; // [autohide] stop the fade timer, restore every painted view (design-autohide §3.1)
        [[SCPPinchController shared] detach]; // [pinch1] glue: session teardown ends pinch tracking (design-pinch §7)
        [[SCPFullscreenController shared] fsSessionDidEnd]; // [fs1] glue: shortened restore at the same "setActive:NO" point — drop the expanded flag, restore clips/chrome, publish NO; NO relayout on a dead session (design §4.6)
        [self.pending removeAllObjects];
        [self publishBusy];
        for (SCPCarPane *pane in [self allPanes]) {
            [pane.barTimer invalidate];
            pane.barTimer = nil;
        }
        self.floatPane = nil;
        self.floatClosing = NO;
        [self.dragGhost removeFromSuperview];
        self.dragGhost = nil;
        self.dragTarget = -1;
        [self.ratioMenu removeFromSuperview];
        [self.ratioTimer invalidate];
        self.ratioTimer = nil;
        self.ratioMenu = nil;
        self.resizing = NO;
        [self.container removeFromSuperview];
        self.container = nil;
        self.slots = nil;
        self.fractions = nil;
        self.dividers = nil;
    }
}

// -ensureContainer (0x12718) VERIFIED (fix-round2 B1 FULL restoration —
// evidence: work/fix-round2/b1-block-dump.md against
// disasm/-SCPCarSplit_ensureContainer.txt): early YES when the container
// already has a superview (0x1273c-0x12770); nil root -> log + NO
// (0x127d4-0x12800, return is root!=nil from 0x12788, so YES whenever a
// root exists). Otherwise parent = baseContainerView.superview
// (0x12824-0x12834), falling back to root.view (0x1284c-0x1285c), and on
// EVERY such entry a FRESH SCPCarSplitView is built, wired and stored —
// no reuse of a detached container, no guarded array reuse.
- (BOOL)ensureContainer {
    if (self.container.superview) return YES;
    id root = SCPDashboardRootViewController();
    if (!root) {
        OMCLogWrite(@"SplitScreen", @"CarSplit: chua co DBDashboardRootViewController (xe chua ket noi?)");
        return NO;
    }
    UIView *base = SCPGuarded(root, @"baseContainerView");
    UIView *parent = base.superview;
    if (!parent) parent = [root view];
    // Fresh view (0x12868-0x12884): parent.bounds, black, clipsToBounds.
    SCPCarSplitView *view = [[SCPCarSplitView alloc] initWithFrame:parent.bounds];
    view.backgroundColor = [UIColor blackColor];
    view.clipsToBounds = YES;
    // Touched block (invoke 0x12b78, descriptor 0x78a80, signature
    // v32@?0{CGPoint=dd}8@"UIView"24): captures WEAK self ONLY
    // (objc_initWeak/objc_copyWeak 0x128c4-0x12908), installed via
    // setTouched: on the NEW view (0x12914). Body per the block map:
    // hideBarsForTouchOn: unconditionally; early return inside the
    // visible float pane; else scan slots (no break), focusing each hit
    // pane and — only on a focus change with >= 2 panes — scheduling
    // flashFocusOnPane: via the delay-0 dispatch helper (sub_12efc at
    // 0x12da0; SCPDispatchAfter(0, ...) is its verified equivalent,
    // SCPShared.m sub_12efc: delay <= 0 -> dispatch_async main queue).
    // The nested block captures self + pane STRONG (0x12d58-0x12d94).
    __weak SCPCarSplit *weakSelf = self;
    view.touched = ^(CGPoint point, UIView *hitView) {
        SCPCarSplit *self = weakSelf; // objc_loadWeakRetained (0x12bc8)
        if (!self) return;
        [self hideBarsForTouchOn:hitView];
        SCPCarPane *fp = self.floatPane;
        if (fp) {
            UIView *fv = fp.view;
            if (fv.alpha > 0 && CGRectContainsPoint(fv.frame, point)) return;
        }
        for (SCPCarPane *pane in self.slots) {
            UIView *pv = pane.view;
            if (pv.alpha <= 0) continue;
            if (!CGRectContainsPoint(pv.frame, point)) continue;
            if (self.focusedSlot != pane.slot && self.paneCount >= 2) {
                SCPDispatchAfter(0, ^{ [self flashFocusOnPane:pane]; });
            }
            self.focusedSlot = pane.slot;
        }
    };
    self.container = view;
    // Fresh arrays via the setters, unconditional (0x12944/0x1296c/0x12994).
    self.slots = [NSMutableArray array];
    self.fractions = [NSMutableArray array];
    self.dividers = [NSMutableArray array];
    [parent addSubview:view];
    [self raise];
    self.loggedArea = NO;
    view.frame = [self appAreaInParent:parent];
    OMCLogWrite(@"SplitScreen", [NSString stringWithFormat:
        @"CarSplit: container trong %@ frame=%@",
        NSStringFromClass(parent.class), NSStringFromCGRect(view.frame)]);
    [[SCPPinchController shared] attachIfNeeded]; // [pinch1] glue: a FRESH container exists only here (design-pinch §7)
    return YES;
}

#pragma mark - Pane bookkeeping

// VERIFIED pattern (accessors are direct ivar access; the collection
// helpers below are reconstructed from their call sites + name semantics —
// status per method in the report).

- (NSArray<SCPCarPane *> *)allPanes {
    NSMutableArray *all = [NSMutableArray arrayWithArray:self.slots ?: @[]];
    if (self.floatPane) [all addObject:self.floatPane];
    return all;
}

- (SCPCarPane *)paneAtSlot:(NSInteger)slot {
    if (slot == 9) return self.floatPane;
    if (slot < 0 || slot >= (NSInteger)self.slots.count) return nil;
    return self.slots[slot];
}

- (BOOL)validSlot:(NSInteger)slot {
    // @0x107cc: validity IS pane existence — slot 9 is valid only
    // when a float pane actually exists (paneAtSlot: returns
    // self.floatPane, possibly nil). The earlier draft hard-coded
    // YES for slot 9, which broke the autoSlot fallback in callers
    // like showPickerForSlot: (GPT wiring audit N11).
    return [self paneAtSlot:slot] != nil;
}

- (SCPCarPane *)paneForBundle:(NSString *)bundleID {
    if (!bundleID) return nil;
    for (SCPCarPane *pane in [self allPanes]) {
        // Dump @0x108ac-0x108bc: the pane's vc is read FIRST and a nil
        // vc skips the pane entirely — a pane carrying only a bundle
        // id (loader/picker stage, no VC yet) must not match.
        if (!pane.vc) continue;
        if ([pane.bundleID isEqualToString:bundleID]) return pane;
    }
    return nil;
}

// -paneForView: (0x23914) VERIFIED: the original walks allPanes and
// returns the first pane whose pane.view CONTAINS the argument
// ([view isDescendantOfView:pane.view] @0x239d4 — isDescendantOfView:
// is YES for the view itself, so pane.view and every deep descendant
// (host, loader, picker, bar buttons) match). There is NO separate
// pane.host equality branch in the dump.
// [fix-round3 G] Explicit nil guards (GPT expanded audit §3): a nil
// view resolves to NO pane, and a pane whose view is not built yet is
// skipped — nil must never "match" nil into a phantom pane (the old
// pointer-equality body's nil==nil failure mode).
- (SCPCarPane *)paneForView:(UIView *)view {
    if (!view) return nil;
    for (SCPCarPane *pane in [self allPanes]) {
        if (!pane.view) continue;
        if ([view isDescendantOfView:pane.view]) return pane;
    }
    return nil;
}

// -pendingSlotForBundle: VERIFIED: pending[bundle] == @[ @(slot), NSDate ];
// entries older than 12.0 s are stale and report "no slot" (-1).
- (NSInteger)pendingSlotForBundle:(NSString *)bundleID {
    NSArray *entry = self.pending[bundleID];
    if (![entry isKindOfClass:[NSArray class]] || entry.count < 2) return -1;
    if ([[NSDate date] timeIntervalSinceDate:entry[1]] > 12.0) return -1;
    return [entry[0] intValue];
}

// -purgePending VERIFIED: drop entries older than 12.0 s, with the log line.
- (void)purgePending {
    NSDate *now = [NSDate date];
    for (NSString *bundle in [self.pending allKeys]) {
        NSArray *entry = self.pending[bundle];
        if ([entry isKindOfClass:[NSArray class]] && entry.count >= 2 &&
            [now timeIntervalSinceDate:entry[1]] > 12.0) {
            OMCLogWrite(@"SplitScreen", [NSString stringWithFormat:
                @"CarSplit: het han cho %@ (DashBoard khong trinh bay app)", bundle]);
            [self.pending removeObjectForKey:bundle];
        }
    }
}

// -slotOccupied: (0x10df4) VERIFIED (remediation, rem_slotOccupied.txt —
// the previous body was wrong and carried no label: it missed the picker
// test and tested pending through the pane's own bundle only). A slot is
// occupied when its pane has a VC, shows the picker, or any pending launch
// targets this slot.
- (BOOL)slotOccupied:(NSInteger)slot {
    SCPCarPane *pane = [self paneAtSlot:slot];
    if (!pane) return NO;
    if (pane.vc) return YES;
    if (pane.picker) return YES;
    for (NSString *bundle in self.pending)
        if ([self pendingSlotForBundle:bundle] == slot) return YES;
    return NO;
}

- (NSInteger)paneCount { return (NSInteger)self.slots.count; }

// -autoSlot (0x115a0) VERIFIED (remediation, rem_autoSlot.txt — replaces an
// INFERRED body; there is NO float-slot/9 fallback in the binary): first
// unoccupied slot; else the focused slot clamped into range when it is not
// pinned; else the first unpinned slot; else the clamped focused slot.
- (NSInteger)autoSlot {
    for (NSInteger i = 0; i < self.paneCount; i++)
        if (![self slotOccupied:i]) return i;
    NSInteger slot = MIN(self.focusedSlot, MAX(self.paneCount, 1) - 1);
    if (![self slotIsPinned:slot]) return slot;
    for (NSInteger i = 0; i < self.paneCount; i++)
        if (![self slotIsPinned:i]) return i;
    return slot;
}

// -markDismissSlot: (0x2be00) VERIFIED (remediation,
// rem_markDismissSlot.txt — replaces an INFERRED body: this is a VISUAL
// mark for the divider-drag dismiss candidate, not a cancellation record;
// the cancelledLaunches mechanism lives in adoptViewController: and is not
// touched here). The pane whose slot matches gets the highlight color, its
// tag-77 cover subview dims to 0.35 and scales to 0.8; every other pane is
// reset. Callers pass -1 to clear the mark.
- (void)markDismissSlot:(NSInteger)slot {
    for (SCPCarPane *pane in self.slots) {
        BOOL selected = (pane.slot == slot);
        UIView *tagged = [pane.cover viewWithTag:77];
        pane.cover.backgroundColor = selected
            ? [UIColor colorWithRed:0.8509803921568627 green:0.8392156862745098 blue:0.9333333333333333 alpha:1.0]
            : [UIColor colorWithRed:0.9333333333333333 green:0.9411764705882353 blue:0.984313725490196 alpha:1.0];
        tagged.alpha = selected ? 0.35 : 1.0;
        tagged.transform = selected ? CGAffineTransformMakeScale(0.8, 0.8) : CGAffineTransformIdentity;
    }
}

#pragma mark - App identity

// -isCarPlayApp: VERIFIED (call order, IMP 0xff50): app info via
// sub_e324, tested by sub_ffb4 (SCPAppHasCarPlayUI in SCPShared.m —
// bundle-id exclusions, carPlayDeclaration, isHidden,
// presentsFullScreen; NOT scene/role keys), OR hosted through
// AppBridge (sub_101bc).
- (BOOL)isCarPlayApp:(NSString *)bundleID {
    id appInfo = SCPApplicationInfoForBundle(bundleID);
    if (appInfo) {
        extern BOOL SCPAppHasCarPlayUI(id appInfo); // sub_ffb4 [phase2; backported to src in phase 3]: the dump reads bundleIdentifier from the info object itself — A passed the id string]
        if (SCPAppHasCarPlayUI(appInfo)) return YES;
    }
    return SCPIsHostedApp(bundleID);
}

// -displayNameFor: VERIFIED (fallback chain): applicationInfo.displayName
// (guarded) -> LSApplicationProxy localizedName (guarded) -> bundle ID.
- (NSString *)displayNameFor:(NSString *)bundleID {
    id info = SCPApplicationInfoForBundle(bundleID);
    NSString *name = SCPGuarded(info, @"displayName");
    if (name.length) return name;
    // Fallback VERIFIED (IMP 0x1029c @0x10354-0x1039c): the
    // LSApplicationProxy CLASS object answers the class method
    // applicationProxyForIdentifier: directly — no workspace, no
    // instance, no defaultWorkspace. (The earlier reconstruction sent
    // defaultWorkspace to a fresh LSApplicationWorkspace instance,
    // which can never answer a class method: that is the false
    // "THIEU METHOD: LSApplicationWorkspace khong co defaultWorkspace"
    // line in the 2026-11-08 21:56 device log.)
    Class proxyClass = objc_getClass("LSApplicationProxy");
    SEL proxySel = NSSelectorFromString(@"applicationProxyForIdentifier:");
    id proxy = nil;
    if ([proxyClass respondsToSelector:proxySel])
        proxy = ((id (*)(id, SEL, id))objc_msgSend)(proxyClass, proxySel, bundleID);
    else
        SCPMissingSelector(proxyClass, NSStringFromSelector(proxySel));
    name = SCPGuarded(proxy, @"localizedName");
    return name.length ? name : bundleID;
}

#pragma mark - Launch flow

// -openApp:slot: (0x164d4) VERIFIED (read end-to-end). The assignment
// algorithm: validate -> activate -> resolve the effective slot (explicit,
// existing pane's slot, autoSlot, pinned-slot fallback) -> move/swap when
// already open -> hosted branch -> pending + loader + throttled launch.
- (void)openApp:(NSString *)bundleID slot:(NSInteger)slot {
    if (!bundleID.length) return;
    if (![self isCarPlayApp:bundleID]) {
        OMCLogWrite(@"SplitScreen", [NSString stringWithFormat:
            @"CarSplit: %@ khong co giao dien CarPlay -> bo qua", bundleID]);
        [self toast:OMCTr(@"App này không hỗ trợ CarPlay", @"This app doesn't support CarPlay")];
        return;
    }
    BOOL wasActive = self.active;
    if (![self activate]) return;
    [self purgePending];
    BOOL valid = [self validSlot:slot];
    SCPCarPane *existing = [self paneForBundle:bundleID];
    if (!valid) slot = existing ? existing.slot : [self autoSlot];

    BOOL fresh = NO;
    if (!existing) {
        if (slot != 9 && [self slotIsPinned:slot]) {
            NSInteger alt = [self autoSlot];
            if ([self slotIsPinned:alt]) {
                [self toast:OMCTr(@"Ô này đang ghim", @"This pane is pinned")];
                return;
            }
            OMCLogWrite(@"SplitScreen", [NSString stringWithFormat:
                @"CarSplit: o %d dang ghim -> mo %@ vao o %d", (int)slot, bundleID, (int)alt]);
            slot = alt;
        }
        fresh = YES;
    } else if (existing.slot == slot || existing.slot == 9 || slot == 9) {
        [self toast:[NSString stringWithFormat:OMCTr(@"%@ đang mở ở %@", @"%@ is already open in %@"),
                     [self displayNameFor:bundleID],
                     existing.slot == 9 ? OMCTr(@"cửa sổ nổi", @"the floating window")
                                        : OMCTr(@"ô khác", @"another pane")]];
        return;
    }

    SCPCarPane *pane = [self paneAtSlot:slot];
    if (!pane) return;
    [self removePickerFromPane:pane];

    if (!fresh) {
        // Already open elsewhere: just move it.
        if ([self pendingSlotForBundle:bundleID] == slot) {
            [self relayoutAnimated:YES];
            return;
        }
        if (existing.slot != slot) [self swapSlot:existing.slot with:slot];
        if (!(wasActive || valid)) [self showPickersForEmptySlots];
        [self relayoutAnimated:YES];
        if (SCPVCIsHosted(pane.vc)) [self sendHostFrameForPane:pane live:NO];
        return;
    }

    // Fresh launch.
    if (SCPIsHostedApp(bundleID)) {
        [self hostApp:bundleID inPane:pane];
        if (!(wasActive || valid)) [self showPickersForEmptySlots];
        return;
    }
    self.pending[bundleID] = @[ @(slot), [NSDate date] ];
    [self showLoaderInPane:pane bundle:bundleID];
    if (!(wasActive || valid)) [self showPickersForEmptySlots];
    [self relayoutAnimated:YES];

    // The launch-info factory takes the application-info OBJECT, never
    // the bundle ID string: the original fetches it fresh here
    // (sub_e324 @0x169b4) and passes it to _OMCCarLaunchInfo (@0x169c4).
    // Passing the string put an NSString inside DBApplicationLaunchInfo
    // and crashed the dashboard (-[__NSCFString carPlayDeclaration]).
    id appInfo = SCPApplicationInfoForBundle(bundleID);
    if (!appInfo || !SCPAppHasCarPlayUI(appInfo)) {
        [self launchFailed:bundleID slot:slot];
        return;
    }
    id launchInfo = OMCCarLaunchInfo(appInfo);
    // Launch throttle (VERIFIED arithmetic): launches are spaced by a
    // per-launch interval kept in nextLaunchAt (constant at 0x6f0a0 in
    // __const = 1.2 s — remediation: read in the openApp: dump at 0x169f8
    // and cross-confirmed as openAppsInOrder:'s step; replaces an
    // INFERRED 0.35 s); wait = max(0, nextLaunchAt - now).
    CFAbsoluteTime now = CFAbsoluteTimeGetCurrent();
    double wait = MAX(0, self.nextLaunchAt - now);
    self.nextLaunchAt = now + wait + 1.2;
    OMCLogWrite(@"SplitScreen", [NSString stringWithFormat:
        @"CarSplit: mo %@ vao ngan %d sau %.1fs (launchInfo=%@)", bundleID, (int)slot, wait, launchInfo]);
    if (launchInfo) {
        __weak SCPCarSplit *weakSelf = self;
        NSString *b = bundleID; NSInteger s = slot;
        SCPDispatchAfter(wait, ^{ [weakSelf sendLaunch:launchInfo bundle:b tries:0]; });
    } else {
        [self launchFailed:bundleID slot:slot];
    }
}

// -sendLaunch:bundle:tries: (0x16e04) VERIFIED. The dashboard often still
// shows the previous fullscreen app; the launch event (DBEvent type 4) is
// only sent once that base VC is gone (or is one of ours), with a
// 0.25 s retry cadence, a hard stop after try 11 (~3 s, per the log line),
// and a 2 s post-launch recovery check.
- (void)sendLaunch:(id)launchInfo bundle:(NSString *)bundleID tries:(NSInteger)tries {
    if (!self.active) return;
    if ([self pendingSlotForBundle:bundleID] < 0) return;
    UIViewController *currentBase = SCPCurrentBaseViewController(self);
    BOOL baseIsOurs = NO;
    for (SCPCarPane *pane in [self allPanes])
        if (pane.vc && pane.vc == currentBase) baseIsOurs = YES;
    BOOL clear = (currentBase == nil) || baseIsOurs;
    if (tries > 11 || clear) {
        if (!clear)
            OMCLogWrite(@"SplitScreen", [NSString stringWithFormat:
                @"CarSplit: DashBoard van trinh bay %@ sau 3s -> mo %@ luon", currentBase, bundleID]);
        SCPSendDashboardEvent(4, launchInfo);
        __weak SCPCarSplit *weakSelf = self;
        SCPDispatchAfter(2.0, ^{ [weakSelf recoverPending:bundleID attempt:0]; });
        return;
    }
    if (tries == 0)
        OMCLogWrite(@"SplitScreen", [NSString stringWithFormat:
            @"CarSplit: DashBoard con trinh bay %@ -> doi ve Home xong roi moi mo %@", currentBase, bundleID]);
    __weak SCPCarSplit *weakSelf = self;
    SCPDispatchAfter(0.25, ^{ [weakSelf sendLaunch:launchInfo bundle:bundleID tries:tries + 1]; });
}

// -recoverPending:attempt: VERIFIED. If the dashboard never presented the
// app, steal the already-created scene VC straight out of the dashboard's
// workspace map: [dashboard workspaceOwner] valueForKey:
// "_entityIdentifierToViewControllerMap" -> allValues; adopt the VC whose
// real bundle matches. Retries every 2.0 s while attempt <= 2 (raw
// dump @0x17618: cmp attempt, #2; b.gt -> terminal; log seconds are
// attempt << 1, i.e. 0s/2s/4s; terminal therefore fires at
// attempt > 2 — see PATCH_NOTES section 18 note on the spec text).
// "CarSplit: %@ chua toi sau %ds, doi them"); on success logs
// "CarSplit: DashBoard khong trinh bay %@ -> lay VC co san". When the
// attempts run out, the terminal branch (@0x17750) logs the VC list
// the dashboard is holding, toasts, and calls launchFailed:slot:.
- (void)recoverPending:(NSString *)bundleID attempt:(NSInteger)attempt {
    if (!self.active) return;
    if ([self pendingSlotForBundle:bundleID] < 0) return;
    id owner = SCPGuarded(SCPDashboardObject(), @"workspaceOwner");
    // Dump @0x17414-0x17428: the VC map is read by KVC —
    // [owner valueForKey:@"_entityIdentifierToViewControllerMap"] — and
    // class-checked as NSDictionary before allValues. SCPGuarded would
    // send a no-arg selector literally named after the ivar, which does
    // not exist, so the lookup always missed (device log: "THIEU
    // METHOD: DBDashboardWorkspaceOwner khong co
    // _entityIdentifierToViewControllerMap -> bo qua"). The
    // workspaceOwner getter above stays as-is; only the map read is KVC.
    NSDictionary *map = nil;
    @try {
        id rawMap = [owner valueForKey:@"_entityIdentifierToViewControllerMap"];
        if ([rawMap isKindOfClass:[NSDictionary class]]) map = rawMap;
    } @catch (NSException *exception) {
        map = nil;
    }
    if (!map) {
        OMCLogWrite(@"SplitScreen", [NSString stringWithFormat:
            @"CarSplit: recoverPending khong doc duoc _entityIdentifierToViewControllerMap (KVC) -> bo qua"]);
    }
    for (id vc in [map allValues]) {
        if (![self wantsViewController:vc]) continue;
        id appInfo = SCPGuarded(vc, @"applicationInfo");
        id proxyInfo = SCPGuarded(vc, @"proxyApplicationInfo");
        if ([SCPRealBundleForInfos(appInfo, proxyInfo) isEqualToString:bundleID]) {
            OMCLogWrite(@"SplitScreen", [NSString stringWithFormat:
                @"CarSplit: DashBoard khong trinh bay %@ -> lay VC co san", bundleID]);
            [self adoptViewController:vc];
            return;
        }
    }
    if (attempt <= 2) {
        OMCLogWrite(@"SplitScreen", [NSString stringWithFormat:
            @"CarSplit: %@ chua toi sau %ds, doi them", bundleID, (int)(attempt << 1)]);
        __weak SCPCarSplit *weakSelf = self;
        SCPDispatchAfter(2.0, ^{ [weakSelf recoverPending:bundleID attempt:attempt + 1]; });
    } else {
        // Terminal branch (dump @0x17750-0x17ac8): attempts exhausted.
        // The pending entry was re-validated at function entry
        // (pendingSlotForBundle: >= 0 within its 12 s window), so this
        // failure still belongs to the CURRENT launch — a newer launch
        // of the same bundle would have refreshed the entry and this
        // call chain would not be the one expiring. Log every VC the
        // dashboard currently holds ("Class(bundle fullScreen=N)"),
        // toast, then hand over to launchFailed:slot: with a FRESH
        // pendingSlotForBundle: read (@0x17ab0-0x17ac8).
        NSMutableArray *held = [NSMutableArray array];
        for (id heldVC in [map allValues]) {
            id heldInfo = SCPGuarded(heldVC, @"applicationInfo");
            NSString *heldBundle = nil;
            BOOL fullScreen = NO;
            if (heldInfo) {
                id heldProxy = SCPGuarded(heldVC, @"proxyApplicationInfo");
                heldBundle = SCPRealBundleForInfos(heldInfo, heldProxy);
                fullScreen = SCPInfoBool(heldInfo, @"presentsFullScreen");
            }
            [held addObject:[NSString stringWithFormat:@"%@(%@ fullScreen=%d)",
                NSStringFromClass([heldVC class]), heldBundle ?: @"?", (int)fullScreen]];
        }
        OMCLogWrite(@"SplitScreen", [NSString stringWithFormat:
            @"CarSplit: khong tim thay VC cua %@ sau khi mo; DashBoard dang giu: %@",
            bundleID, [held componentsJoinedByString:@", "]]);
        [self toast:[NSString stringWithFormat:
            OMCTr(@"Không mở được %@ trong ô", @"Couldn't open %@ in the pane"),
            [self displayNameFor:bundleID]]];
        [self launchFailed:bundleID slot:[self pendingSlotForBundle:bundleID]];
    }
}

// -launchFailed:slot: (0x17e70) VERIFIED against the full dump: drop the
// pending entry; then PER PANE, when the pane's slot matches OR the
// pane's loader accessibilityIdentifier equals bundleID (isEqualToString:
// @0x17f54-0x17f7c, remove at @0x17f94 — OR, not AND, so the watchdog's
// slot -1 call still clears a loader by id), remove the loader; if that
// pane then has no VC and its OWN slot is unoccupied, show the picker
// for the pane's own slot (@0x17fa4-0x17fe8). Relayout at the end.
- (void)launchFailed:(NSString *)bundleID slot:(NSInteger)slot {
    // GUARD (GPT directive — intentional divergence from the original):
    // the dump has NO nil-bundle guard at 0x17ecc (removeObjectForKey:
    // would raise on nil). This guard is added on purpose; see report.
    if (!bundleID) {
        OMCLogWrite(@"SplitScreen", [NSString stringWithFormat:
            @"CarSplit: launchFailed bundle nil o %d -> bo qua (guard GPT)", (int)slot]);
        return;
    }
    [self.pending removeObjectForKey:bundleID];
    for (SCPCarPane *pane in [self allPanes]) {
        if (pane.slot == slot ||
            [pane.loader.accessibilityIdentifier isEqualToString:bundleID]) {
            [self removeLoaderFromPane:pane animated:YES];
            if (!pane.vc && ![self slotOccupied:pane.slot])
                [self showPickerForSlot:(int)pane.slot];
        }
    }
    [self relayoutAnimated:YES];
}

// -killAppSoon: (0x180dc) VERIFIED (remediation, rem_killAppSoon.txt +
// block @0x181b0 rem_killAppSoon_block.txt): after 0.6 s (constant
// @0x6f0a8 — replaces an INFERRED 1.0 s), re-check: if the split is still
// active and the app came back (present in a pane or pending again), log
// and keep it; otherwise log and post splitscreen.kill so the SpringBoard
// side terminates the app (see SCPSpringBoardHooks.m).
- (void)killAppSoon:(NSString *)bundleID {
    if (!bundleID.length) return;
    __weak SCPCarSplit *weakSelf = self;
    SCPDispatchAfter(0.6, ^{
        SCPCarSplit *self = weakSelf;
        if (self.active) {
            if ([self paneForBundle:bundleID] || [self pendingSlotForBundle:bundleID] >= 0) {
                OMCLogWrite(@"SplitScreen", [NSString stringWithFormat:
                    @"CarSplit: %@ vua mo lai -> khong tat", bundleID]);
                return;
            }
        }
        OMCLogWrite(@"SplitScreen", [NSString stringWithFormat:
            @"CarSplit: tat han %@", bundleID]);
        [[NSDistributedNotificationCenter defaultCenter]
            postNotificationName:SCPNoteKillApp object:nil
                        userInfo:@{@"identifier": bundleID}];
    });
}

#pragma mark - Pairs, layouts, restore

// -openPairLeft:right: VERIFIED (IMP 0x183a8; re-checked against the
// dump 2026-11-08): already active -> setPaneCount:2 and skip
// activation; not active -> activateWithCount:2 and STOP if it
// returns NO (@0x18454). The pair ratio is computed only when BOTH
// bundles are non-nil (@0x18458/0x1845c) and assigned only when it
// lies in [0.2, 0.8] (@0x18480/0x18490; __const 0x6f078/0x6f080); the
// second fraction is 1.0 - ratio (fsub @0x184c4), never a literal 1.0.
- (void)openPairLeft:(NSString *)left right:(NSString *)right {
    OMCLogWrite(@"SplitScreen", [NSString stringWithFormat:@"CarSplit: mo cap left=%@ right=%@", left, right]);
    if (self.active) {
        [self setPaneCount:2];
    } else if (![self activateWithCount:2]) {
        return;
    }
    if (left && right) {
        double ratio = [SCPPrefs ratioForPairLeft:left right:right];
        if (ratio >= 0.2 && ratio <= 0.8)
            self.fractions = [@[@(ratio), @(1.0 - ratio)] mutableCopy];
    }
    [self openAppsInOrder:@[left ?: (id)[NSNull null], right ?: (id)[NSNull null]]];
}

// -openAppsInOrder: (0x1869c) VERIFIED (remediation,
// rem_openAppsInOrder.txt + block @0x18a48 rem_openAppsInOrder_block.txt —
// replaces a body whose branch polarity was INVERTED: the binary opens
// HOSTED apps immediately and staggers NATIVE apps). Per slot index: a
// missing or non-string entry shows the picker; a hosted app opens at
// once; native apps open one immediately, then each subsequent one is
// seeded into pending + loader and deferred by a growing delay
// (step 1.2 s @0x6f0a0). The deferred block re-checks active and the
// pane count, drops the pending entry, then opens.
- (void)openAppsInOrder:(NSArray *)apps {
    double delay = 0;
    double step = 1.2;
    for (NSInteger i = 0; i < self.paneCount; i++) {
        NSString *app = nil;
        if (i < (NSInteger)apps.count) {
            id entry = apps[i];
            if ([entry isKindOfClass:[NSString class]]) app = entry;
        }
        if (!app) { [self showPickerForSlot:i]; continue; }
        if (SCPIsHostedApp(app)) { [self openApp:app slot:i]; continue; }
        if (delay <= 0) {
            [self openApp:app slot:i];
            delay = step;
            continue;
        }
        self.pending[app] = @[ @(i), [NSDate date] ];
        [self showLoaderInPane:self.slots[i] bundle:app];
        __weak SCPCarSplit *weakSelf = self;
        SCPDispatchAfter(delay, ^{
            SCPCarSplit *self = weakSelf;
            if (!self.active) return;
            if (i >= self.paneCount) return;
            [self.pending removeObjectForKey:app];
            [self openApp:app slot:i];
        });
        delay += step;
    }
    [self relayoutAnimated:YES];
}

// -openSetupLayout:apps: VERIFIED (IMP 0x3ab7c; re-checked against
// the dump 2026-11-08): active -> switchToLayout:; not active ->
// activateWithLayout: under suppressReopen, and if activation
// returns NO the function returns WITHOUT opening apps (@0x3abf0).
// The pair ratio applies ONLY to layout 2 (@0x3abf4) with at least 2
// apps whose first two elements are NSString (@0x3ac38/0x3ac80) and
// a ratio in [0.2, 0.8] (@0x3ace8/0x3acf8); the second fraction is
// 1.0 - ratio (fsub @0x3ad2c).
- (void)openSetupLayout:(NSInteger)layout apps:(NSArray *)apps {
    if (self.active) {
        [self switchToLayout:layout];
    } else {
        self.suppressReopen = YES;
        BOOL activated = [self activateWithLayout:layout];
        self.suppressReopen = NO;
        if (!activated) return;
    }
    if (layout == 2 && apps.count >= 2 &&
        [apps[0] isKindOfClass:[NSString class]] &&
        [apps[1] isKindOfClass:[NSString class]]) {
        double ratio = [SCPPrefs ratioForPairLeft:apps[0] right:apps[1]];
        if (ratio >= 0.2 && ratio <= 0.8)
            self.fractions = [@[@(ratio), @(1.0 - ratio)] mutableCopy];
    }
    [self openAppsInOrder:apps];
}

// -openRememberedPairForConnect VERIFIED (IMP 0x43720 — re-read end to
// end in the final closure; the previous body diverged in five places:
// recent validity is apps.count > 1 with an NSString class check per
// element, the favorite fallback is favorite:1 (not 0) expanded through
// -favoriteApps: with a layout 0 -> 2 default, the app list is REBUILT
// (non-strings become NSNull), the fullscreen app replaces slot 0 only
// when the rebuilt list is non-empty, and the log prints the app array
// itself plus (fullscreenAppBundle ?: @"-")). The reconnect restore:
// first recent layout whose apps all still qualify; else favorite #1.
- (void)openRememberedPairForConnect {
    NSInteger layout = 0;
    NSArray *source = nil;
    for (NSDictionary *entry in [SCPPrefs recentLayouts]) {
        NSArray *apps = entry[@"apps"];
        BOOL ok = apps.count > 1;
        for (id bundle in apps) {
            if (![bundle isKindOfClass:[NSString class]] ||
                ![self isCarPlayApp:bundle]) ok = NO;
        }
        if (ok) { layout = [entry[@"layout"] intValue]; source = apps; break; }
    }
    if (!source) {
        NSDictionary *fav = [SCPPrefs favorite:1];
        source = [self favoriteApps:fav];
        layout = [fav[@"layout"] intValue];
        if (layout == 0) layout = 2;
    }
    if (!source) {
        OMCLogWrite(@"SplitScreen", @"CarSplit: chua co cach chia gan day / yeu thich -> khong tu mo");
        return;
    }
    NSString *full = [self fullscreenAppBundle];
    NSMutableArray *apps = [NSMutableArray array];
    for (id bundle in source)
        [apps addObject:[bundle isKindOfClass:[NSString class]] ? bundle : [NSNull null]];
    if (full && ![apps containsObject:full] && apps.count)
        apps[0] = full;
    OMCLogWrite(@"SplitScreen", [NSString stringWithFormat:
        @"CarSplit: tu mo khi cam xe: bo cuc %d, app %@ (dang mo %@)",
        (int)layout, apps, full ?: @"-"]);
    [self openSetupLayout:layout apps:apps];
}

// -openRememberedPair VERIFIED (IMP 0x43cdc — re-read end to end in the
// final closure): the SAME recent-layout validity scan as the connect
// path (the previous body just took recentLayouts.firstObject); a valid
// recent opens with its own apps array verbatim — no rebuild, no
// fullscreen merge. Otherwise favorite #1 via -favoriteApps:, logged
// ("... -> Bo cuc yeu thich 1") only when it yields apps; the layout is
// the raw intValue (no 0 -> 2 default on this path).
- (void)openRememberedPair {
    for (NSDictionary *entry in [SCPPrefs recentLayouts]) {
        NSArray *apps = entry[@"apps"];
        BOOL ok = apps.count > 1;
        for (id bundle in apps) {
            if (![bundle isKindOfClass:[NSString class]] ||
                ![self isCarPlayApp:bundle]) ok = NO;
        }
        if (!ok) continue;
        OMCLogWrite(@"SplitScreen", [NSString stringWithFormat:@"CarSplit: mo lai cach chia gan nhat %@", entry]);
        [self openSetupLayout:[entry[@"layout"] intValue] apps:apps];
        return;
    }
    NSDictionary *fav = [SCPPrefs favorite:1];
    NSArray *apps = [self favoriteApps:fav];
    if (!apps) {
        OMCLogWrite(@"SplitScreen", @"CarSplit: chua co cach chia gan day / yeu thich -> khong tu mo");
        return;
    }
    OMCLogWrite(@"SplitScreen", @"CarSplit: chua co cach chia gan day -> Bo cuc yeu thich 1");
    [self openSetupLayout:[fav[@"layout"] intValue] apps:apps];
}

// -rememberPair VERIFIED: persist slots 0/1 bundle IDs as the last pair.
- (void)rememberPair {
    if (self.paneCount < 2) return;
    [SCPPrefs setLastPairLeft:self.slots[0].bundleID right:self.slots[1].bundleID];
}

// -rememberRecent (0x1a3d0) VERIFIED (remediation, rem_rememberRecent.txt
// — replaces an INFERRED body): no-op for a single pane; otherwise
// snapshots the CURRENT layout id (-layoutID, not layoutKind) with the
// bundle IDs of panes that actually hold an app (vc + bundleID set and
// no picker) into SCPPrefs recent layouts.
- (void)rememberRecent {
    if (self.paneCount < 2) return;
    NSMutableArray *apps = [NSMutableArray array];
    for (SCPCarPane *pane in self.slots)
        if (pane.vc && pane.bundleID && !pane.picker) [apps addObject:pane.bundleID];
    [SCPPrefs addRecentLayout:[self layoutID] apps:apps];
}

// -openFavorite: VERIFIED (IMP 0x3aa60 — line-read in the final
// closure): resolve the favorite DICTIONARY, expand it through
// -favoriteApps:, ALWAYS log the pick, and open only when the expansion
// produced at least one usable app. It never reads an @"apps" key (the
// favorite dictionary has none — see +[SCPPrefs favorite:]).
- (void)openFavorite:(NSInteger)index {
    NSDictionary *fav = [SCPPrefs favorite:index];
    NSArray *apps = [self favoriteApps:fav];
    OMCLogWrite(@"SplitScreen", [NSString stringWithFormat:
        @"CarSplit: bo cuc yeu thich %ld: %@", (long)index, fav]);
    if (apps) [self openSetupLayout:[fav[@"layout"] intValue] apps:apps];
}

// -favoriteApps: VERIFIED (IMP 0x3a86c — line-read end to end in the
// final closure; A's old version was an index-taking wrapper over the
// nonexistent +[SCPPrefs favoriteApps:] and is replaced). Takes the
// favorite DICTIONARY: the box count comes from dict[@"layout"] — 3 for
// layouts 13/31, else the layout itself when it is 2 or 3, else 2 —
// then the slot keys @[@"left", @"right", @"third"] (constant array in
// __DATA @0x80518) are walked up to that count: a slot value passing
// -isCarPlayApp: is kept, anything else (missing or not a CarPlay app)
// is padded with NSNull so positions are preserved; nil when no slot
// passed (and nil for a nil dictionary).
- (NSArray *)favoriteApps:(NSDictionary *)fav {
    if (!fav) return nil;
    NSInteger layout = [fav[@"layout"] intValue];
    NSInteger count;
    if (layout == 13 || layout == 31) count = 3;
    else if (layout == 2 || layout == 3) count = layout;
    else count = 2;
    NSMutableArray *apps = [NSMutableArray array];
    BOOL any = NO;
    NSArray *keys = @[@"left", @"right", @"third"];
    for (NSInteger i = 0; i < count; i++) {
        id bundle = fav[keys[i]];
        if (bundle && [self isCarPlayApp:bundle]) {
            [apps addObject:bundle];
            any = YES;
        } else {
            [apps addObject:[NSNull null]];
        }
    }
    return any ? apps : nil;
}

#pragma mark - Scene adoption / VC lifecycle

// -wantsViewController: VERIFIED.
- (BOOL)wantsViewController:(UIViewController *)vc {
    return self.active && [self isAdoptableViewController:vc];
}

// -isAdoptableViewController: VERIFIED: a DBApplicationSceneViewController
// whose app does NOT present fullscreen and whose real bundle resolves.
- (BOOL)isAdoptableViewController:(UIViewController *)vc {
    Class sceneVC = OMCCarClass("DBApplicationSceneViewController");
    if (!sceneVC || ![vc isKindOfClass:sceneVC]) return NO;
    id appInfo = SCPGuarded(vc, @"applicationInfo");
    // sub_17d84 VERIFIED role: boolean for key on the info object/dict.
    extern BOOL SCPInfoBool(id info, NSString *key);
    if (SCPInfoBool(appInfo, @"presentsFullScreen")) return NO;
    id proxyInfo = SCPGuarded(vc, @"proxyApplicationInfo");
    return SCPRealBundleForInfos(appInfo, proxyInfo) != nil;
}

// -adoptViewController: (0x18d20) VERIFIED (read end-to-end).
- (void)adoptViewController:(UIViewController *)vc {
    id appInfo = SCPGuarded(vc, @"applicationInfo");
    id proxyInfo = SCPGuarded(vc, @"proxyApplicationInfo");
    NSString *bundle = SCPRealBundleForInfos(appInfo, proxyInfo);
    NSInteger slot = [self pendingSlotForBundle:bundle];
    BOOL noPending = slot < 0;
    SCPCarPane *existing = nil;
    for (SCPCarPane *pane in [self allPanes])
        if ([pane.bundleID isEqualToString:bundle]) existing = pane;

    // Launch cancelled by the user moments ago: if the VC still shows up
    // within 30 s, background it instead of adopting (VERIFIED window).
    NSDate *cancelledAt = bundle ? self.cancelledLaunches[bundle] : nil;
    if (cancelledAt) {
        [self.cancelledLaunches removeObjectForKey:bundle];
        if (noPending && !existing &&
            [[NSDate date] timeIntervalSinceDate:cancelledAt] < 30.0) {
            OMCLogWrite(@"SplitScreen", [NSString stringWithFormat:
                @"CarSplit: %@ da bi huy luc dang mo -> dua ve nen", bundle]);
            [self detachVC:vc background:YES];
            return;
        }
    }
    if (![self validSlot:slot])
        slot = existing ? existing.slot : [self autoSlot];
    if (bundle) [self.pending removeObjectForKey:bundle];
    SCPCarPane *pane = [self paneAtSlot:slot];
    // Fresh claim on a pane that holds a different app: announce the swap.
    if (noPending && !existing && pane.vc && pane.bundleID &&
        ![pane.bundleID isEqualToString:bundle]) {
        [self toast:[NSString stringWithFormat:OMCTr(@"%@ thay %@ ở ô %d", @"%@ replaced %@ in pane %d"),
                     [self displayNameFor:bundle], [self displayNameFor:pane.bundleID],
                     (int)slot + 1]];
    }
    [self adopt:vc slot:slot];
}

// -adopt:slot: (0x1942c) VERIFIED (read end-to-end). This is where a hosted
// scene is attached: the scene VC is re-parented into the pane.
- (void)adopt:(UIViewController *)vc slot:(NSInteger)slot {
    SCPCarPane *pane = [self paneAtSlot:slot];
    if (!pane) {
        OMCLogWrite(@"SplitScreen", [NSString stringWithFormat:
            @"CarSplit: bo qua dua VC vao o %d (chi co %d o)", (int)slot, (int)self.paneCount]);
        return;
    }
    id appInfo = SCPGuarded(vc, @"applicationInfo");
    id proxyInfo = SCPGuarded(vc, @"proxyApplicationInfo");
    NSString *bundle = SCPRealBundleForInfos(appInfo, proxyInfo);
    [self removePickerFromPane:pane];
    if (pane.vc == vc) { [self relayoutAnimated:YES]; return; }

    // Same app already lives in another pane: evict that copy first.
    // The evicted pane is remembered in vacatedPane (the dump's x22,
    // assigned @0x19730): the picker at the tail is shown for THAT pane,
    // never for the destination.
    SCPCarPane *vacatedPane = nil;
    for (SCPCarPane *other in [self allPanes]) {
        if (other == pane || !other.vc) continue;
        if ([other.bundleID isEqualToString:bundle]) {
            [self detachVC:other.vc background:NO];
            other.vc = nil; other.bundleID = nil; other.sceneSize = CGSizeZero;
            [self bwNoteAssignmentForPane:other]; // [ytz5] eviction = assignment teardown event
            vacatedPane = other;
        }
    }
    // Pane occupied: close a hosted occupant through the bridge, detach a
    // native occupant (backgrounded only when it is a different app).
    if (pane.vc) {
        if (SCPVCIsHosted(pane.vc)) {
            [self hostClose:pane.bundleID terminate:NO];
        } else {
            [self detachVC:pane.vc background:![pane.bundleID isEqualToString:bundle]];
        }
        pane.vc = nil; pane.bundleID = nil;
    }
    // Reparent the scene VC into the pane (VERIFIED sequence, incl. the
    // parent identity): the PARENT is the dashboard's root view controller
    // (SCPDashboardRootViewController(), sub_12658) — SCPCarSplit itself is
    // an NSObject and never becomes the parent. If the VC is already the
    // root's child, containment calls are skipped entirely.
    UIViewController *root = SCPDashboardRootViewController();
    BOOL alreadyChild = (vc.parentViewController == root);
    if (!alreadyChild) {
        if (vc.parentViewController) {
            [vc willMoveToParentViewController:nil];
            [vc removeFromParentViewController];
        }
        [root addChildViewController:vc];
    }
    [vc.view removeFromSuperview];
    vc.view.hidden = NO;
    vc.view.alpha = 1;
    vc.view.transform = CGAffineTransformIdentity;
    vc.view.frame = pane.host.bounds;
    vc.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [pane.host addSubview:vc.view];
    if (!alreadyChild) [vc didMoveToParentViewController:root];
    vc.additionalSafeAreaInsets = UIEdgeInsetsZero; // VERIFIED (_UIEdgeInsetsZero from GOT)
    pane.vc = vc;
    pane.bundleID = bundle;
    // [ytz5] assignment event: generation advances + BWInputStore
    // identity re-registered for this (bundle, assignment) pair.
    [self bwNoteAssignmentForPane:pane];
    SCPSceneVisLog(@"attach", pane, vc, YES); // [scenevis]
    pane.sceneSize = CGSizeZero;   // VERIFIED: zeroed at adopt; filled by verifySceneOfPane:
    self.focusedSlot = (int)slot;
    [self removeLoaderFromPane:pane animated:YES];
    OMCLogWrite(@"SplitScreen", [NSString stringWithFormat:
        @"CarSplit: dua %@ (%@) vao o %d", bundle, NSStringFromClass([vc class]), (int)slot]);
    [self rememberPair];
    [self rememberRecent];
    [self raise];
    // Dump tail @0x19b48-0x19b7c: rememberPair -> rememberRecent -> raise
    // -> showPickerForSlot: -> relayoutAnimated:. The picker is for the
    // VACATED pane only: the destination is x20 (skipped in the eviction
    // loop @0x19674-0x19678), x22 is set to the evicted other pane
    // @0x19730, tested @0x19b5c, and its slot is passed to
    // showPickerForSlot: @0x19b60-0x19b70. (A previous comment here
    // claimed the picker took the destination pane's slot — that
    // misread covered the just-adopted app with a picker; GPT log
    // audit 2026-11-09.) There is NO verifySceneOfPane: call in the
    // original adopt: tail (the retry:2 call here was an addition).
    if (vacatedPane) [self showPickerForSlot:(int)vacatedPane.slot];
    [self relayoutAnimated:YES];
}

// -detachVC:background: VERIFIED (call sequence): the deliberate-background
// path raises allowBackground (a counter) around the private
// backgroundSceneWithCompletion: call so the protection hooks let it
// through exactly once.
- (void)detachVC:(UIViewController *)vc background:(BOOL)background {
    @try {
        // [scenevis] state BEFORE the detach mutates anything.
        SCPCarPane *visPane = nil;
        for (SCPCarPane *p in [self allPanes])
            if (p.vc == vc) { visPane = p; break; }
        SCPSceneVisLog(background ? @"detach-bg" : @"detach", visPane, vc, YES);
        if (background) {
            self.allowBackground += 1;
            SEL sel = NSSelectorFromString(@"backgroundSceneWithCompletion:");
            if ([vc respondsToSelector:sel])
                ((void (*)(id, SEL, id))objc_msgSend)(vc, sel, nil);
            else
                SCPMissingSelector(vc, NSStringFromSelector(sel));
            self.allowBackground -= 1;
        }
        [vc willMoveToParentViewController:nil];
        [vc.view removeFromSuperview];
        [vc removeFromParentViewController];
        // sub_1a1b8 = SCPResetDetachedView (VERIFIED, SCPShared.m): un-hides
        // the detached view and restores alpha >= 0.99, recursing (depth
        // cap 4) into _UIScene*/_UITouchPassthrough* subviews. It does NOT
        // touch geometry — an earlier comment here claiming frame/transform
        // resets was wrong (remediation, rem_sub_1a1b8.txt).
        SCPResetDetachedView(vc.view, 0);
        vc.view.transform = CGAffineTransformIdentity;
    } @catch (NSException *ex) {
        OMCLogWrite(@"SplitScreen", [NSString stringWithFormat:@"CarSplit: background loi %@", ex]);
    }
}

// -protectsViewController: VERIFIED: the predicate behind the
// backgroundScene/deactivateScene hooks — a VC in a pane is protected
// while the split is active and no deliberate background is in flight.
- (BOOL)protectsViewController:(UIViewController *)vc {
    if (!self.active || self.allowBackground > 0) return NO;
    for (SCPCarPane *pane in [self allPanes])
        if (pane.vc == vc) return YES;
    return NO;
}

// -sceneOfViewController: VERIFIED shape: nil for non-VCs, else the scene
// walk of sub_1ab70 (SCPSceneOfVC in SCPShared.m — VERIFIED in the final
// closure: KVC probes @"scene"/@"_scene", then the sceneHandle fallback).
- (id)sceneOfViewController:(UIViewController *)vc {
    if (![vc isKindOfClass:[UIViewController class]]) return nil;
    return SCPSceneOfVC(vc);
}

// -scene:destroyedForViewController:ownScene: (0x1ad58) VERIFIED
// (remediation, rem_sceneDestroyed.txt + close block @0x1b238
// rem_sceneDestroyed_block.txt — replaces a body with an INFERRED 0.5 s
// delay, a wrong keep-case log and an early return): per pane holding
// this VC, compare the destroyed scene against the pane's own scene —
// a match is ownScene non-nil AND (pointer-equal OR identifiers equal).
// A match schedules the pane's close with delay 0.0 through a block that
// captures the pane WEAKLY and re-validates it; a mismatch just logs.
// The loop does not stop at the first matching pane.
- (void)scene:(id)scene destroyedForViewController:(UIViewController *)vc ownScene:(id)ownScene {
    for (SCPCarPane *pane in [self allPanes]) {
        if (pane.vc != vc) continue;
        NSString *destroyedID = SCPSceneIdentifierOfVC(scene);
        NSString *ownID = SCPSceneIdentifierOfVC(ownScene);
        BOOL match = ownScene && (ownScene == scene ||
                                  (destroyedID && [destroyedID isEqualToString:ownID]));
        if (match) {
            SCPSceneVisLog(@"scene-destroyed", pane, vc, YES); // [scenevis]
            OMCLogWrite(@"SplitScreen", [NSString stringWithFormat:
                @"CarSplit: scene cua %@ bi huy (app thoat/crash) -> dong ngan %d",
                pane.bundleID, (int)pane.slot]);
            __weak SCPCarPane *weakPane = pane;
            SCPDispatchAfter(0.0, ^{
                SCPCarPane *p = weakPane;
                if (p && p.vc == vc && [[self allPanes] containsObject:p])
                    [self closeSlot:p.slot background:NO];
            });
        } else {
            OMCLogWrite(@"SplitScreen", [NSString stringWithFormat:
                @"CarSplit: scene %@ bi huy khong phai cua %@ (%@) -> giu ngan %d",
                destroyedID ?: (id)scene, pane.bundleID, ownID ?: @"?", (int)pane.slot]);
        }
    }
}

// -verifySceneOfPane:expected:retry: (IMP 0x1cce0) VERIFIED — rewritten
// from the full dump (370 lines) + block dumps sub_1d2a8 / sub_1d444:
//  * Entry gates: !active -> return (@0x1cd2c); !pane.vc -> return
//    (@0x1cd44); then a STALENESS gate (@0x1cd48-0x1cd6c): pane.sceneSize
//    is compared to expected with exact fcmp on both dimensions and the
//    method returns when they DIFFER (b.ne -> epilogue) — pushSceneSizes
//    records pane.sceneSize = size before scheduling this call, so a
//    mismatch means a newer size superseded this check. (An earlier
//    transcription inverted this gate.)
//  * The scene's settings object comes from SCPGuarded (object return —
//    sound), but -frame must NEVER go through SCPGuarded: -frame returns
//    a CGRect BY VALUE in v0-v3 while x0 keeps the receiver, so the
//    guarded object-returning send yields `settings` itself and the old
//    code's [frameValue CGRectValue] threw. The dump (@0x1ce5c-0x1ce9c)
//    reads it directly: NSSelectorFromString(@"frame") +
//    respondsToSelector: + a CGRect-returning objc_msgSend cast;
//    no responds -> CGSizeZero.
//  * actual == CGSizeZero -> log "khong doc duoc kich thuoc scene" and
//    return (@0x1cee0-0x1cf3c).
//  * Match test (@0x1cf40-0x1cf84): within 2 pt on both axes, straight
//    OR swapped (landscape/portrait permutation included).
//  * The "scene %@ that = %@ (can %@)%@" log fires whenever a frame was
//    read, matched or not (@0x1cf88-0x1d02c); suffix is "" when matched,
//    else " -> ve nen roi len lai" (retry != 0) or " -> van sai"
//    (retry == 0), selected at @0x1cfd4-0x1cff8.
//  * retry == 0 or matched -> return (@0x1d050-0x1d058). Otherwise the
//    retry branch (@0x1d05c-0x1d120) backgrounds the scene under the
//    allowBackground counter and, after 0.25 s, foregrounds it again and
//    re-verifies with retry:0 after a further 0.8 s.
//  * The dump contains NO setSceneSize in this method (grep: only the
//    sceneSize getter @0x1cd4c) — the old trailing
//    `pane.sceneSize = actual;` was an addition and is removed.
- (void)verifySceneOfPane:(SCPCarPane *)pane expected:(CGSize)expected retry:(NSInteger)retry {
    if (!self.active) return;
    if (!pane.vc) return;
    CGSize recorded = pane.sceneSize;
    if (recorded.width != expected.width || recorded.height != expected.height)
        return;
    id scene = SCPSceneOfVC(pane.vc);
    id settings = SCPGuarded(scene, @"settings");
    CGSize actual = CGSizeZero;
    SEL frameSel = NSSelectorFromString(@"frame");
    if ([settings respondsToSelector:frameSel])
        actual = ((CGRect (*)(id, SEL))objc_msgSend)(settings, frameSel).size;
    if (actual.width == 0 && actual.height == 0) {
        OMCLogWrite(@"SplitScreen", [NSString stringWithFormat:
            @"CarSplit: khong doc duoc kich thuoc scene %@", pane.bundleID]);
        return;
    }
    BOOL matched = (fabs(actual.width - expected.width) <= 2.0 &&
                    fabs(actual.height - expected.height) <= 2.0) ||
                   (fabs(actual.width - expected.height) <= 2.0 &&
                    fabs(actual.height - expected.width) <= 2.0);
    NSString *suffix = matched ? @""
        : (retry != 0 ? @" -> ve nen roi len lai" : @" -> van sai");
    OMCLogWrite(@"SplitScreen", [NSString stringWithFormat:
        @"CarSplit: scene %@ that = %@ (can %@)%@",
        pane.bundleID, NSStringFromCGSize(actual),
        NSStringFromCGSize(expected), suffix]);
    SCPSceneVisLog(@"verify", pane, pane.vc, NO); // [scenevis] throttled: view state beside the scene-frame verdict above
    if (retry == 0 || matched) return;
    UIViewController *vc = pane.vc;
    self.allowBackground = self.allowBackground + 1;
    @try {
        SEL bgSel = NSSelectorFromString(@"backgroundSceneWithCompletion:");
        ((void (*)(id, SEL, id))objc_msgSend)(vc, bgSel, (id)^{});
    } @catch (NSException *ex) {
        // Original catch (landing pad @0x1d180-0x1d1d4): log and continue
        // to the allowBackground decrement below.
        OMCLogWrite(@"SplitScreen", [NSString stringWithFormat:
            @"CarSplit: background loi %@", ex]);
    }
    self.allowBackground = self.allowBackground - 1;
    __weak SCPCarSplit *weakSelf = self;
    SCPDispatchAfter(0.25, ^{
        SCPCarSplit *self = weakSelf;
        if (!self || !self.active) return;
        if (pane.vc != vc) return;
        SEL fgSel = NSSelectorFromString(@"foregroundSceneWithSettings:completion:");
        ((void (*)(id, SEL, id, id))objc_msgSend)(vc, fgSel, nil, (id)^{});
        SCPDispatchAfter(0.8, ^{
            [weakSelf verifySceneOfPane:pane expected:expected retry:0];
        });
    });
}

// -paneSize:forBundle: (IMP 0x1b328) VERIFIED — the binary ABI is
// - (BOOL)paneSize:(CGSize *)outSize forBundle:, NOT the previously
// declared (CGSize)paneSize:(CGRect)frame forBundle: (that declaration
// was false; the scene-frame hook caller @0x5d8c passes a stack CGSize*
// and tests the BOOL result @0x5db4). Dump order: return NO when
// !active or bundleID == nil (@0x1b350-0x1b360) or container == nil
// (@0x1b37c); slot = paneForBundle: hit ? pane.slot (@0x1b39c, tested
// for nil FIRST @0x1b398 — messaging nil for .slot yields 0 and defeats
// the slot<0 check, which is why unassigned apps never reached the
// pending lookup) : pendingSlotForBundle: (@0x1b3b0); slot < 0 -> NO
// (@0x1b3c0). The result is valid only when MIN(frame width, height)
// >= 2 (@0x1b3cc-0x1b3d8); *outSize is written only when valid and
// outSize != NULL (@0x1b3dc-0x1b3ec); the return value is the validity.
- (BOOL)paneSize:(CGSize *)outSize forBundle:(NSString *)bundleID {
    if (!self.active || !bundleID) return NO;
    if (!self.container) return NO;
    SCPCarPane *pane = [self paneForBundle:bundleID];
    NSInteger slot = pane ? pane.slot : [self pendingSlotForBundle:bundleID];
    if (slot < 0) return NO;
    CGRect frame = [self frameForSlot:slot];
    BOOL valid = MIN(frame.size.width, frame.size.height) >= 2.0;
    if (valid && outSize != NULL) *outSize = frame.size;
    return valid;
}

// -repairPresentedViewController: (0x19e04) VERIFIED (remediation,
// rem_repairPresentedViewController.txt — replaces an INFERRED one-liner;
// the binary contains NO wantsViewController:/adoptViewController: call).
// Called by the delayed block in the presentBaseViewController hook
// (sub_80c4): a VC the dashboard presented fullscreen may be a leftover
// split app whose view tree got hidden — if no pane owns it, un-hide it
// (SCPResetDetachedView) and log. It does NOT adopt anything.
- (void)repairPresentedViewController:(UIViewController *)vc {
    if (![vc isKindOfClass:[UIViewController class]]) return;
    if (!vc.isViewLoaded) return;
    for (SCPCarPane *pane in [self allPanes])
        if (pane.vc == vc) return;
    if (!SCPResetDetachedView(vc.view, 0)) return;
    vc.view.transform = CGAffineTransformIdentity;
    id appInfo = SCPGuarded(vc, @"applicationInfo");
    id proxyInfo = SCPGuarded(vc, @"proxyApplicationInfo");
    NSString *bundle = SCPRealBundleForInfos(appInfo, proxyInfo);
    OMCLogWrite(@"SplitScreen", [NSString stringWithFormat:
        @"CarSplit: app toan man %@ bi an (con sot tu split) -> hien lai", bundle]);
}

#pragma mark - Pane set mutation

// The methods below were re-read instruction by instruction in the
// remediation round (dumps rem_newPane/rem_insertPaneAt/rem_reindexPanes/
// rem_setPaneCount/rem_removePaneAt.txt); earlier INFERRED skeletons are
// replaced.

// -newPane (0x13040) VERIFIED: builds the pane's view (dark 0.08-white
// background, corner radius 6 continuous, border width 0 via sub_132cc)
// and its flexible host view, then installs the bar. No slot is assigned
// here — slots come from reindexPanes.
- (SCPCarPane *)newPane {
    SCPCarPane *pane = [SCPCarPane new];
    pane.view = [[UIView alloc] initWithFrame:CGRectZero];
    pane.view.backgroundColor = [UIColor colorWithWhite:0.08 alpha:1.0];
    pane.view.layer.cornerRadius = 6.0;
    pane.view.layer.cornerCurve = kCACornerCurveContinuous;
    pane.view.clipsToBounds = YES;
    pane.view.layer.borderWidth = 0; // sub_132cc in the binary (rem_sub_132cc.txt)
    pane.host = [[UIView alloc] initWithFrame:CGRectZero];
    pane.host.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [pane.view addSubview:pane.host];
    [self setupBarForPane:pane];
    return pane;
}

// -insertPaneAt: (0x135e4) VERIFIED: only with a container and at most 2
// existing panes; the index is clamped once and the clamped value drives
// the pending-slot shift and the focused-slot bump. No fractions traffic.
- (SCPCarPane *)insertPaneAt:(NSInteger)slot {
    SCPCarPane *pane = nil;
    if (self.container && self.paneCount <= 2) {
        NSInteger at = MAX(MIN(slot, self.paneCount), 0);
        pane = [self newPane];
        [self.container addSubview:pane.view];
        [self.slots insertObject:pane atIndex:(NSUInteger)at];
        for (NSString *bundle in [self.pending allKeys]) {
            NSArray *entry = self.pending[bundle];
            NSInteger s = [entry[0] intValue];
            if (s != 9 && s >= at)
                self.pending[bundle] = @[ @(s + 1), entry[1] ];
        }
        if (self.focusedSlot >= at) self.focusedSlot += 1;
        [self reindexPanes];
    }
    return pane;
}

// -reindexPanes (0x14154) VERIFIED.
- (void)reindexPanes {
    NSInteger i = 0;
    for (SCPCarPane *pane in self.slots) pane.slot = (int)i++;
}

// -setPaneCount: (0x147e0) VERIFIED: the target is clamped to 1..3;
// layoutKind is reset for count <= 2 BEFORE the equality early-return;
// shrinking removes with background:YES; growing inlines newPane (it does
// NOT go through insertPaneAt:); finishes with resetFractions (not
// normalizeFractions), rebuildDividers and a log line.
- (void)setPaneCount:(NSInteger)count {
    NSInteger target = MIN(MAX(count, 1), 3);
    if (count <= 2) self.layoutKind = 0;
    if (target == self.paneCount) return;
    while (self.paneCount > target)
        [self removePaneAt:self.paneCount - 1 background:YES];
    while (self.paneCount < target) {
        SCPCarPane *pane = [self newPane];
        [self.container addSubview:pane.view];
        [self.slots addObject:pane];
    }
    [self reindexPanes];
    [self resetFractions];
    [self rebuildDividers];
    OMCLogWrite(@"SplitScreen", [NSString stringWithFormat:@"CarSplit: bo cuc %d o", (int)target]);
}

// -swapSlot:with: (0x1d494) VERIFIED from the full dump (1,316 B): a
// full transaction, not a bare exchange. Guards (@0x1d4d0-0x1d4f4):
// a == b, either index negative ((a|b) sign bit), either >= paneCount
// — slot 9 (the float pane) is never an element of `slots`, so the
// paneCount guard is what keeps it out of the exchange; the binary
// has NO slot-9 special case. Then: slots exchange; focusedSlot
// follows the swap (@0x1d528-0x1d55c); fractions exchange only when
// !mainStack && fractions.count == paneCount (@0x1d560-0x1d5b4);
// pending entries remapped over a SNAPSHOT of pending.allKeys with
// the NSDate object preserved (@0x1d5c0-0x1d7b0); reindexPanes; log
// "doi cho o"; rememberPair + rememberRecent; relayoutAnimated:YES.
- (void)swapSlot:(NSInteger)a with:(NSInteger)b {
    NSInteger count = self.paneCount;
    if (a == b) return;
    if (a < 0 || b < 0) return;
    if (a >= count || b >= count) return;
    [self.slots exchangeObjectAtIndex:a withObjectAtIndex:b];
    if (self.focusedSlot == a) self.focusedSlot = (int)b;
    else if (self.focusedSlot == b) self.focusedSlot = (int)a;
    if (!self.mainStack && (NSInteger)self.fractions.count == count)
        [self.fractions exchangeObjectAtIndex:a withObjectAtIndex:b];
    for (NSString *key in [self.pending.allKeys copy]) {
        NSArray *entry = self.pending[key];
        if (![entry isKindOfClass:[NSArray class]] || entry.count < 2) continue;
        NSInteger slot = [entry[0] intValue];
        if (slot == a)
            self.pending[key] = @[ @(b), entry[1] ];
        else if (slot == b)
            self.pending[key] = @[ @(a), entry[1] ];
    }
    [self reindexPanes];
    OMCLogWrite(@"SplitScreen", [NSString stringWithFormat:@"CarSplit: doi cho o %d va %d", (int)a, (int)b]);
    [self rememberPair];
    [self rememberRecent];
    [self relayoutAnimated:YES];
}

// -removePaneAt:background: (0x149a8) VERIFIED (remediation,
// rem_removePaneAt.txt — full line-read; three corrections to the earlier
// call-sequence version: the layoutKind line RESETS the kind and clears
// fractions instead of decrementing; the pending remap reads the raw
// entry (not pendingSlotForBundle:) and shifts entries behind the slot;
// the tail clamps focusedSlot and rebuilds dividers).
- (void)removePaneAt:(NSInteger)slot background:(BOOL)background {
    if (slot < 0 || slot >= self.paneCount) return;
    SCPCarPane *pane = self.slots[slot];
    SCPSceneVisLog(@"pane-remove", pane, pane.vc, YES); // [scenevis]
    if (SCPVCIsHosted(pane.vc))
        [self hostClose:pane.bundleID terminate:NO];
    [pane.barTimer invalidate];
    pane.barTimer = nil;
    [self removePickerFromPane:pane];
    if (pane.vc) {
        if (!SCPVCIsHosted(pane.vc)) [self detachVC:pane.vc background:background];
        pane.vc = nil;
        pane.bundleID = nil;
        // [ytz5] assignment teardown event (before reindexPanes
        // shifts slots): generation advances + store identity cleared.
        [self bwNoteAssignmentForPane:pane];
    }
    [pane.view removeFromSuperview];
    if (self.layoutKind != 0) {
        self.layoutKind = 0;
        [self.fractions removeAllObjects];
    }
    [self.slots removeObjectAtIndex:slot];
    if (slot < (NSInteger)self.fractions.count) [self.fractions removeObjectAtIndex:slot];
    [self normalizeFractions];
    for (NSString *bundle in [self.pending allKeys]) {
        NSArray *entry = self.pending[bundle];
        NSInteger s = [entry[0] intValue];
        if (s == 9) continue;
        if (s == slot) [self.pending removeObjectForKey:bundle];
        else if (s > slot) self.pending[bundle] = @[ @(s - 1), entry[1] ];
    }
    if (self.focusedSlot > slot) self.focusedSlot -= 1;
    if (self.focusedSlot >= self.paneCount) self.focusedSlot = MAX(self.paneCount, 1) - 1;
    [self reindexPanes];
    [self rebuildDividers];
}

// -closeSlot:background: VERIFIED: slot 9 closes the float pane; the last
// remaining pane closes the whole split via afterPaneRemoved:.
- (void)closeSlot:(NSInteger)slot background:(BOOL)background {
    if (slot == 9) { [self closeFloat:background]; return; } // [phase2; backported to src in phase 3] fix] binary has ONLY closeFloat: (objc.json); A header's no-arg closeFloat was a slip — the method's own background flag is the argument (cf. Picker.m's [self closeFloat:NO])
    if (!self.active || slot < 0 || slot >= self.paneCount) return;
    NSString *bundle = self.slots[slot].bundleID;
    [self removePaneAt:slot background:background];
    OMCLogWrite(@"SplitScreen", [NSString stringWithFormat:
        @"CarSplit: dong o %d (%@), con %d o", (int)slot, bundle, (int)self.paneCount]);
    [self afterPaneRemoved:bundle]; // remediation: the binary passes the removed pane's bundle (IMP 0x1d9b8, rem_closeSlot.txt) — an earlier note here claiming the callee ignores the arg was wrong
}

// -afterPaneRemoved: (0x1db48) VERIFIED (remediation,
// rem_afterPaneRemoved.txt + retry block @0x1e2ec — replaces an INFERRED
// stub; the argument is the removed pane's bundle ID, binary type
// v24@0:8@16). Recovery routine: with no panes left, the float pane's app
// (if any) goes solo, else the split closes home. With exactly one pane
// and no float pane, that pane's app (or the last pending app for slot 0)
// goes solo. Otherwise it relayouts and, when the dashboard's active base
// app is exactly the removed bundle shown in a pane as a NON-hosted app,
// re-seeds its launch (pending + dashboard event 4) so it re-presents,
// with the pending entry expiring after 2.0 s.
- (void)afterPaneRemoved:(NSString *)bundle {
    if (self.paneCount == 0) {
        if (self.floatPane.vc && self.floatPane.bundleID)
            [self soloBundle:self.floatPane.bundleID];
        else {
            [self noteCloseSource:@"pane-last"]; // [ytz5] M5 src=
            [self closeGoingHome:YES];
        }
        return;
    }
    if (self.paneCount == 1 && !self.floatPane) {
        NSString *b = self.slots[0].bundleID;
        if (b) { [self soloBundle:b]; return; }
        NSString *candidate = nil;
        for (NSString *key in self.pending)
            if ([self pendingSlotForBundle:key] == 0) candidate = key;
        if (candidate) { [self soloBundle:candidate]; return; }
        [self noteCloseSource:@"pane-last"]; // [ytz5] M5 src=
        [self closeGoingHome:YES];
        return;
    }
    [self relayoutAnimated:YES];
    // @0x1dc3c: workspaceOwner is asked on the DASHBOARD object
    // (helper @0xe5b4 = SCPDashboardObject, UIApplication's
    // _currentDashboard), NOT on the root view controller — the
    // earlier draft's receiver never answers workspaceOwner, so
    // activeID stayed nil and the re-seed below never ran
    // (GPT wiring audit N8).
    id dashboard = SCPDashboardObject();
    id owner = SCPGuarded(dashboard, @"workspaceOwner");
    NSString *activeID = SCPGuarded(owner, @"activeBaseApplicationBundleID");
    SCPCarPane *pane = nil;
    for (SCPCarPane *p in self.slots)
        if (p.vc && p.bundleID) { pane = p; break; }
    if (!pane || !bundle) return;
    if (![activeID isEqualToString:bundle]) return;
    if (SCPIsHostedApp(pane.bundleID)) return;
    NSString *b = pane.bundleID;
    self.pending[b] = @[ @(pane.slot), [NSDate date] ];
    id info = OMCCarLaunchInfo(SCPApplicationInfoForBundle(b));
    if (info) SCPSendDashboardEvent(4, info);
    SCPDispatchAfter(2.0, ^{ [self.pending removeObjectForKey:b]; });
}

// -switchToLayout: (0x15000) VERIFIED (remediation,
// rem_switchToLayout.txt — replaces an INFERRED stub): same (count, kind)
// derivation as activateWithLayout: (13/31 -> count 3 + kind 1/2, 2/3 ->
// count = id + kind 0, else count 2 + kind 0). No-op when nothing would
// change. Shrinking evicts panes — first an empty unpending one, else the
// last unpinned one, else the last one — with background:YES, collecting
// display names for a "moved to the background" toast.
- (void)switchToLayout:(NSInteger)layout {
    NSInteger count = ((layout & ~1) == 2) ? layout : 2;
    NSInteger kind = 0;
    if (layout == 13 || layout == 31) {
        count = 3;
        kind = (layout == 13) ? 1 : 2;
    }
    if (count == self.paneCount && kind == self.layoutKind) return;
    OMCLogWrite(@"SplitScreen", [NSString stringWithFormat:
        @"CarSplit: doi bo cuc %d -> %d", (int)[self layoutID], (int)layout]);
    NSMutableArray *moved = [NSMutableArray array];
    while (self.paneCount > count) {
        SCPCarPane *victim = nil;
        for (SCPCarPane *pane in self.slots) {
            BOOL keep = pane.vc != nil;
            if (!keep) {
                for (NSString *bundle in self.pending)
                    if ([self pendingSlotForBundle:bundle] == pane.slot) { keep = YES; break; }
            }
            if (!keep) { victim = pane; break; }
        }
        if (!victim) {
            for (SCPCarPane *pane in [self.slots reverseObjectEnumerator])
                if (![self slotIsPinned:pane.slot]) { victim = pane; break; }
        }
        if (!victim) victim = self.slots.lastObject;
        if (victim.bundleID) [moved addObject:[self displayNameFor:victim.bundleID]];
        [self removePaneAt:victim.slot background:YES];
    }
    if (moved.count)
        [self toast:[NSString stringWithFormat:OMCTr(@"%@ về nền", @"%@ moved to the background"),
            [moved componentsJoinedByString:@", "]]];
    [self setPaneCount:count];
    self.layoutKind = kind;
    [self resetFractions];
    [self rebuildDividers];
    [self showPickersForEmptySlots];
    [self relayoutAnimated:YES];
}

// -layoutID (0x11080) VERIFIED (remediation, rem_layoutID.txt — the old
// body returned layoutKind): the layout's public id — 31 for the
// right-main layout, 13 for the stacked layout, else the pane count.
- (NSInteger)layoutID {
    if (self.mainRight) return 31;
    if (self.mainStack) return 13;
    return self.paneCount;
}

// -layoutChosenID: (0x3c61c) VERIFIED (remediation,
// rem_layoutChosenID.txt — replaces a fabricated BOOL predicate; the
// binary method is VOID): the user picked a layout for the pending
// layout app (self.layoutApp). Active splits just switch; otherwise the
// split activates with that layout and opens the app (or shows pickers).
- (void)layoutChosenID:(NSInteger)layout {
    NSString *app = self.layoutApp;
    self.layoutApp = nil;
    [self collapseAppTray];
    if (self.active) {
        [self switchToLayout:layout];
        return;
    }
    OMCLogWrite(@"SplitScreen", [NSString stringWithFormat:
        @"CarSplit: chon bo cuc %d cho %@", (int)layout, app ?: @"man chinh (moi o trong)"]);
    if (app) {
        if (![self activateWithLayout:layout]) return;
        [self openApp:app slot:0];
        for (NSInteger i = 0; i < self.paneCount; i++)
            if (![self slotOccupied:i]) [self showPickerForSlot:i];
    } else {
        if (![self activateWithLayout:layout]) return;
        [self showPickersForEmptySlots];
    }
}

#pragma mark - Close / home

// -closeApp: VERIFIED.
- (void)closeApp:(NSString *)bundleID {
    SCPCarPane *pane = [self paneForBundle:bundleID];
    if (self.active && pane) [self closeSlot:pane.slot background:YES];
}

// -closeGoingHome: (0x21618) VERIFIED (remediation,
// rem_stub_closeGoingHome:.txt + animation blocks @0x21b08/@0x21b14
// rem_closeGoingHome_anim/done.txt — corrections to the earlier
// call-sequence version: detachVC is called for EVERY pane VC with NO
// hosted check (hostCloseAll already handled hosted apps); cover removal
// is a separate loop over self.slots; the container is NOT removed
// synchronously — it is detached from the properties and faded out over
// 0.2 s; the type-1 dashboard event send is explicit in the binary, not
// inferred; the tail refreshes the app tab and knobs).
- (void)noteCloseSource:(NSString *)source {
    self.closeSource = source;
}

- (void)closeGoingHome:(BOOL)goHome {
    // [ytz5] M5 src=: the source stamped by the call site (nil reads
    // as "unknown"); it is reset to nil (unknown) before returning,
    // on BOTH paths — the !active early return logs it too, instead
    // of being invisible as before.
    NSString *src = self.closeSource ?: @"unknown";
    if (!self.active) {
        OMCLogWrite(@"SplitScreen", [NSString stringWithFormat:
            @"CarSplit: tat split (goHome=%d) src=%@", goHome, src]);
        self.closeSource = nil;
        return;
    }
    // [ytz5] M5 measurement point T1: before ANY cleanup or detach.
    SCPLogInjectedIconState(@"before-close", src);
    // [ytz5] M1 cleanup (CHANGE_MAP_YTZ5 M1): IMMEDIATELY after the
    // guard, BEFORE hostCloseAll — stop the AutoHide timer, restore
    // painted views directly through AutoHide's restore mechanism
    // (never ahRevealBody:), reset faded/kb-hold-expiry/activity and
    // the split session's faded/hold/suspended state, clear the
    // paint registry. The destination mode owns what follows: a
    // hosted-solo target re-suspends AFTER this cleanup (see
    // soloBundle:). Idempotent.
    [self ahCloseCleanup];
    OMCLogWrite(@"SplitScreen", [NSString stringWithFormat:
        @"CarSplit: tat split (goHome=%d) src=%@", goHome, src]);
    for (SCPCarPane *pane in [self allPanes]) // [scenevis] snapshot at the exit-home point, before any detach
        SCPSceneVisLog(@"going-home", pane, pane.vc, YES);
    [self hostCloseAll];
    for (SCPCarPane *pane in [self allPanes]) {
        [pane.barTimer invalidate];
        pane.barTimer = nil;
        if (pane.vc) {
            [self detachVC:pane.vc background:YES];
        }
        // [GPT patch A6, orig 0x2174c -> 0x2177c: vc/bundleID are nilled
        // unconditionally; only detachVC depends on vc existing]
        pane.vc = nil;
        pane.bundleID = nil;
        // [ytz5] assignment teardown event: generation advances and
        // the slot's BWInputStore identity is cleared with the pane.
        [self bwNoteAssignmentForPane:pane];
        [pane.picker removeFromSuperview];
        pane.picker = nil;
    }
    self.active = NO;
    [self.pending removeAllObjects];
    [self publishBusy];
    [self removePickerSheet];
    [self hideRatioMenu];
    [self cancelPaneDrag];
    for (SCPCarPane *pane in self.slots) [self removeCoverFromPane:pane];
    self.resizing = NO;
    UIView *container = self.container;
    self.container = nil;
    self.slots = nil;
    self.fractions = nil;
    self.dividers = nil;
    self.floatPane = nil;
    self.floatClosing = NO;
    [UIView animateWithDuration:0.2 animations:^{
        container.alpha = 0;
    } completion:^(BOOL finished) {
        [container removeFromSuperview];
    }];
    if (goHome) SCPSendDashboardEvent(1, @"SplitScreen: dong split");
    [self refreshAppTabSoon];
    [self publishKnobsSoon];
    // [ytz5] M5 measurement point T2: the close body is done.
    SCPLogInjectedIconState(@"after-close", src);
    self.closeSource = nil; // [ytz5] reset nguon = unknown
}

// -homePressedDuringSplit: (0x40298) VERIFIED against the full dump
// (fix-round3 G; GPT expanded audit §7). Signature is (void)(BOOL):
// wasActive is captured by the hook BEFORE any close. Body per dump:
// dismissStuckBaseSoon runs when wasActive (@0x40318 tbz w22), OR —
// only when wasActive is NO — when the dashboard's currentBase exists
// AND is identical to soloReturnedVC (@0x40328 cbz currentBase,
// @0x40344-0x40348 cmp + b.eq to the same call). soloReturnedVC is
// then ALWAYS cleared (@0x4034c setSoloReturnedVC:nil) — the previous
// body returned early from three branches and skipped this cleanup.
// Tail: ignoreHomeOnce is consumed when set (@0x40358-0x40370); only
// when it was NOT set does a live soloHostedBundle end the hosted
// solo (@0x40374-0x40394). No return value, no early return.
- (void)homePressedDuringSplit:(BOOL)wasActive {
    UIViewController *currentBase = SCPCurrentBaseViewController(self);
    if (wasActive || (currentBase && currentBase == self.soloReturnedVC))
        [self dismissStuckBaseSoon];
    self.soloReturnedVC = nil;
    if (self.ignoreHomeOnce) {
        self.ignoreHomeOnce = NO;
    } else if (self.soloHostedBundle) {
        [self endHostedSolo];
    }
}

// -dismissStuckBaseSoon (0x3ff28) VERIFIED (remediation,
// rem_dismissStuckBaseSoon.txt + block @0x3ffc8
// rem_dismissStuckBaseSoon_block.txt — replaces an INFERRED interior and
// a 0.5 s delay): one-shot deferred dismissal of a base VC the dashboard
// still holds after Home. After 0.35 s (@0x6f098) the block clears the
// flag, bails when a solo hosted app is up or when the base VC is one of
// the panes, and otherwise asks the dashboard ROOT (not the base VC) to
// dismiss its base view controller, animated, via a direct msgSend.
- (void)dismissStuckBaseSoon {
    if (self.dismissStuckPending) return;
    self.dismissStuckPending = YES;
    __weak SCPCarSplit *weakSelf = self;
    SCPDispatchAfter(0.35, ^{
        SCPCarSplit *self = weakSelf;
        self.dismissStuckPending = NO;
        if (!self) return;
        if (self.soloHostedBundle) return;
        id root = SCPDashboardRootViewController();
        UIViewController *base = SCPGuarded(root, @"currentBaseViewController");
        if (!base) return;
        for (SCPCarPane *pane in [self allPanes])
            if (pane.vc == base) return;
        OMCLogWrite(@"SplitScreen", [NSString stringWithFormat:
            @"CarSplit: DashBoard con giu %@ sau Home -> dong de hien man chinh", base]);
        SEL dismissSel = NSSelectorFromString(@"dismissBaseViewControllerAnimated:completion:");
        if ([root respondsToSelector:dismissSel])
            ((void (*)(id, SEL, BOOL, id))objc_msgSend)(root, dismissSel, YES, nil);
    });
}

// -launchPhoneAppIfNeeded: (0x403d0) VERIFIED from the full dump: the
// argument IS the bundle-id NSString — @0x403f8-0x403fc passes it
// straight into the hosted predicate (sub_101bc = SCPIsHostedApp).
// The binary never reads applicationInfo/proxyApplicationInfo off
// this parameter; that reading lives in the dashboard launch hook
// (@0x61d0), which hands the STRING over. Dashboard icon tap on a
// hosted (phone) app — into the split when active, otherwise solo
// fullscreen through the bridge. Returns YES when consumed (the
// return value is the predicate result, x20 in the dump).
// Three branches (@0x40444-0x404ac):
//   active            -> openApp:bundle slot:-1 (@0x40458 mov w3,#-1)
//   inactive, bundle == soloHostedBundle
//                     -> consumed silently (@0x4048c tbnz jumps PAST
//                        endHostedSolo: the live solo session stays)
//   inactive, other   -> endHostedSolo FIRST (@0x40494), then
//                        showSoloCoverForBundle:, then hostSolo:.
- (BOOL)launchPhoneAppIfNeeded:(NSString *)bundleID {
    if (![bundleID isKindOfClass:[NSString class]] || !bundleID.length) return NO;
    if (!SCPIsHostedApp(bundleID)) return NO;
    OMCLogWrite(@"SplitScreen", [NSString stringWithFormat:@"AppBridge: cham icon %@ tren man chinh", bundleID]);
    if (self.active) {
        [self openApp:bundleID slot:-1];
    } else if (![self.soloHostedBundle isEqualToString:bundleID]) {
        [self endHostedSolo];
        [self showSoloCoverForBundle:bundleID];
        [self hostSolo:bundleID];
    }
    return YES;
}

#pragma mark - Hosted (AppBridge) panes

// The bridge protocol (all VERIFIED names): CarPlayApp posts
// NSDistributedNotificationCenter notifications; OmniCarAppBridge (in the
// phone apps / SpringBoard) executes and answers on appbridge.state.

// -hostPost:info: VERIFIED.
- (void)hostPost:(NSString *)name info:(NSDictionary *)info {
    [[NSDistributedNotificationCenter defaultCenter]
        postNotificationName:name object:nil userInfo:info];
}

// -hostClose:terminate: VERIFIED.
- (void)hostClose:(NSString *)bundleID terminate:(BOOL)terminate {
    if (!bundleID.length) return;
    [self hostPost:SCPNoteBridgeClose info:@{@"identifier": bundleID,
                                             @"terminate": @(terminate)}];
    SCPCarPane *bwPane = [self paneForBundle:bundleID]; // [wake1]
    if (bwPane) [self bwRecomputeForPane:bwPane];
}

// -hostCloseAll VERIFIED: the solo app (if any) is excepted.
- (void)hostCloseAll {
    [self hostPost:SCPNoteBridgeCloseAll
              info:@{@"except": self.soloHostedBundle ?: @""}];
    for (SCPCarPane *bwPane in [self hostedPanes]) // [wake1]
        [self bwRecomputeForPane:bwPane];
}

// -hostApp:inPane: VERIFIED (call sequence): put a hosted app into a pane —
// evict the occupant, install an SCPHostedAppVC token, size it to the pane,
// show the loader, and post the open/frame state to the bridge.
// -hostApp:inPane: VERIFIED (CLOSURE-2 line-read of IMP 0x3e490,
// dumps SplitScreenB/disasm/rem2_C7_hostAppInPane_parent.txt,
// rem2_C7_block1_3e8f4.txt, rem2_C7_block_3eb24.txt,
// rem2_delay_helper_12efc.txt). The previous condensed body diverged
// from the binary: detach used background:YES, the hosted view is
// framed/masked/added to pane.host, sceneSize starts at CGSizeZero,
// hostFrame at CGRectNull, focusedSlot is skipped for slot 9, the tail
// is rememberPair/rememberRecent/raise/relayoutAnimated:YES, and the
// frame publish + loader timeout are two SCPDispatchAfter blocks
// (0.05 s and 8 s) — there is no synchronous sendHostFrameForPane call.
- (void)hostApp:(NSString *)bundleID inPane:(SCPCarPane *)pane {
    if (pane.vc) {
        if (SCPVCIsHosted(pane.vc)) [self hostClose:pane.bundleID terminate:NO];
        else [self detachVC:pane.vc background:YES];
        pane.vc = nil;
        pane.bundleID = nil;
    }
    SCPHostedAppVC *hosted = [SCPHostedAppVC new];
    hosted.bundleID = bundleID;
    hosted.view.frame = pane.host.bounds;
    hosted.view.autoresizingMask = UIViewAutoresizingFlexibleWidth |
                                   UIViewAutoresizingFlexibleHeight; // 0x12
    [pane.host addSubview:hosted.view];
    pane.vc = hosted;
    pane.bundleID = bundleID;
    // [ytz5] assignment event (also covers re-assigning the SAME
    // bundle to this slot): generation advances + BWInputStore
    // identity re-registered, kb record reset to UNKNOWN.
    [self bwNoteAssignmentForPane:pane];
    SCPSceneVisLog(@"host-attach", pane, hosted, YES); // [scenevis] hosted: scene=nil expected (scene lives SpringBoard-side)
    pane.sceneSize = CGSizeZero;
    pane.hostFrame = CGRectNull;
    pane.hostHandle = NO;
    if (pane.slot != 9) self.focusedSlot = pane.slot;
    [self showLoaderInPane:pane bundle:bundleID];
    OMCLogWrite(@"SplitScreen", [NSString stringWithFormat:@"AppBridge: host %@ vao o %d", bundleID, (int)pane.slot]);
    [self rememberPair];
    [self rememberRecent];
    [self raise];
    [self relayoutAnimated:YES];
    __weak SCPCarSplit *weakSelf = self;
    __weak SCPCarPane *weakPane = pane;
    // +0.05 s (block invoke @0x3e8f4): if the split is still active and
    // the pane still hosts this bundle, publish the host frame as
    // appbridge.open.
    SCPDispatchAfter(0.05, ^{
        SCPCarSplit *self = weakSelf;
        SCPCarPane *pane = weakPane;
        if (!pane || !self.active) return;
        if (![pane.bundleID isEqualToString:bundleID]) return;
        CGRect frame = [self hostFrameForPane:pane];
        if (CGRectIsEmpty(frame))
            frame = [pane.view convertRect:pane.view.bounds toView:nil];
        pane.hostFrame = frame;
        pane.hostHandle = !CGRectIsEmpty(frame);
        pane.hostBar = !pane.bar.isHidden;
        NSDictionary *info = [self hostFrameInfo:frame pane:pane live:NO
                                          handle:pane.hostHandle];
        [self hostPost:SCPNoteBridgeOpen info:info];
        [self bwRecomputeForPane:pane]; // [wake1] hostHandle/hostBar just cached (design §1.3 point 3)
    });
    // +8 s loader timeout (block invoke @0x3eb24, census item C7): if
    // the pane still hosts this bundle, drop the loader.
    SCPDispatchAfter(8.0, ^{
        SCPCarPane *pane = weakPane;
        if (!pane) return;
        if (![pane.bundleID isEqualToString:bundleID]) return;
        [weakSelf removeLoaderFromPane:pane animated:YES];
    });
}

// -hostedApp:state: (0x3f35c) VERIFIED from the full dump: the bridge's
// state answers. SOLO route first — bundle equal to soloHostedBundle
// (nil-safe: @0x3f3a8 cbz skips the whole route when no solo session):
//   state == "ready" -> hideSoloCover ONLY and RETURN (@0x3f3f0 tbnz
//     jumps straight to hideSoloCover @0x3f438, then the epilogue —
//     the solo session is KEPT, endHostedSolo is NOT called);
//   any other state  -> log "app toan man", endHostedSolo,
//     hideSoloCover, RETURN (@0x3f3f4-0x3f440).
// SPLIT route (@0x3f444): pane membership is confirmed against the
// CURRENT pane table (paneForBundle: — bundle + live vc) and the
// hosted-VC check (sub_14fa4 = SCPVCIsHosted) before the callback may
// touch the pane, so a stale answer for a bundle that has since been
// swapped out cannot clear or close the pane now hosting another app:
//   "ready" -> removeLoaderFromPane:animated:YES, return;
//   else    -> log "-> dong o", toast only when "failed", then BOTH
//     non-ready paths converge on closeSlot:pane.slot background:NO
//     (@0x3f5a0-0x3f5b4).
- (void)hostedApp:(NSString *)bundleID state:(NSString *)state {
    NSString *solo = self.soloHostedBundle;
    if (solo && [solo isEqualToString:bundleID]) {
        if ([state isEqualToString:@"ready"]) {
            [self hideSoloCover];
            return;
        }
        OMCLogWrite(@"SplitScreen", [NSString stringWithFormat:@"AppBridge: app toan man %@ %@", bundleID, state]);
        [self endHostedSolo];
        [self hideSoloCover];
        return;
    }
    SCPCarPane *pane = [self paneForBundle:bundleID];
    if (!self.active || !pane || !SCPVCIsHosted(pane.vc)) return;
    SCPSceneVisLog([NSString stringWithFormat:@"host-state-%@", state], pane, pane.vc, NO); // [scenevis] throttled
    if ([state isEqualToString:@"ready"]) {
        [self removeLoaderFromPane:pane animated:YES];
        return;
    }
    OMCLogWrite(@"SplitScreen", [NSString stringWithFormat:@"AppBridge: %@ %@ -> dong o %d", bundleID, state, (int)pane.slot]);
    if ([state isEqualToString:@"failed"]) {
        [self toast:[NSString stringWithFormat:OMCTr(@"Không mở được %@ trên xe", @"Couldn't show %@ on the car"),
                     [self displayNameFor:bundleID]]];
    }
    [self closeSlot:pane.slot background:NO];
}

// -hostSolo: (IMP 0x3f9c0) VERIFIED (fix-round2 spot fold-in, dump
// -SCPCarSplit_hostSolo_.txt): run a hosted app fullscreen (over the
// dashboard's app area). Original order: tabParent nil guard FIRST
// (cbz x20 @0x3fa1c -> 0x3fd1c plain return — no state, no posts);
// appAreaInParent: + convertRect:toView:nil; setSoloHostedBundle:
// (0x3fa50), setSoloHostedFrame: (0x3fa68), setTrayHidesBridge:NO
// (0x3fa70 `mov w2,#0` — was YES in the recon, corrected); log; post
// appbridge.open (5 keys, hostPost @0x3fbc4); post appbridge.frame
// (7 keys: identifier/x/y/w/h + live=@NO + handle=@NO, hostPost
// @0x3fce8); tail refreshAppTabSoon (@0x3fd18).
- (void)hostSolo:(NSString *)bundleID {
    UIView *parent = [self tabParent];
    if (!parent) return;
    CGRect frame = [self appAreaInParent:parent];
    frame = [parent convertRect:frame toView:nil];
    self.soloHostedBundle = bundleID;
    [self ahSetSuspended:YES]; // [autohide] §4.1: a hosted solo session suspends the fade machine — ahSetSuspended: restores any live fade BEFORE the solo takes over (additive line; original body untouched)
    self.soloHostedFrame = frame;
    self.trayHidesBridge = NO;
    OMCLogWrite(@"SplitScreen", [NSString stringWithFormat:@"AppBridge: %@ toan man %@", bundleID, NSStringFromCGRect(frame)]);
    [self hostPost:SCPNoteBridgeOpen info:@{@"identifier": bundleID,
                                            @"x": @(frame.origin.x), @"y": @(frame.origin.y),
                                            @"w": @(frame.size.width), @"h": @(frame.size.height)}];
    [self hostPost:SCPNoteBridgeFrame info:@{@"identifier": bundleID,
                                             @"x": @(frame.origin.x), @"y": @(frame.origin.y),
                                             @"w": @(frame.size.width), @"h": @(frame.size.height),
                                             @"live": @NO, @"handle": @NO}];
    [self refreshAppTabSoon];
}

// -endHostedSolo (0x3fe5c) VERIFIED (remediation, rem_endHostedSolo.txt —
// state is cleared BEFORE the log + hostClose in the binary).
- (void)endHostedSolo {
    NSString *bundle = self.soloHostedBundle;
    if (!bundle) return;
    self.soloHostedBundle = nil;
    [self ahSetSuspended:NO]; // [autohide] §4.1: back to SPLIT — resume with a fresh 4.0 s clock (additive line; original body untouched)
    self.trayHidesBridge = NO;
    OMCLogWrite(@"SplitScreen", [NSString stringWithFormat:@"AppBridge: dong app toan man %@", bundle]);
    [self hostClose:bundle terminate:NO];
    SCPCarPane *bwPane = [self paneForBundle:bundle]; // [wake1]
    if (bwPane) [self bwRecomputeForPane:bwPane];
}

// -sendHostFrameForPane:live: VERIFIED (call sequence): recompute the
// pane's bridge geometry, cache it on the pane, post appbridge.frame.
- (void)sendHostFrameForPane:(SCPCarPane *)pane live:(BOOL)live {
    if (!SCPVCIsHosted(pane.vc)) return;
    CGRect frame = [self hostFrameForPane:pane];
    CGRect hole = [self holeForPane:pane];
    // The binary caller (@0x3e164-0x3e184) passes the just-computed frame
    // itself to hostFrameInfo:, and derives its handle argument as
    // !CGRectIsEmpty(frame) — not from the pane's cached hostHandle.
    BOOL handle = !CGRectIsEmpty(frame);
    BOOL bar = !pane.bar.isHidden;
    pane.hostFrame = frame;
    pane.hostHandle = handle;
    pane.hostBar = bar;
    pane.hostHole = hole;
    NSDictionary *info = [self hostFrameInfo:frame pane:pane live:live handle:handle];
    [self hostPost:SCPNoteBridgeFrame info:info];
    [self publishKnobsSoon];
    [self bwRecomputeForPane:pane]; // [wake1] hostHandle refreshed from the frame (design §1.3 point 4)
}

// -hostFrameInfo:pane:live:handle: VERIFIED (IMP 0x3d39c — line-read
// end to end in the micro-closure; dump
// disasm/-SCPCarSplit_hostFrameInfo_pane_live_handle_.txt). The ObjC
// type encoding is decisive for the first argument:
// @64@0:8{CGRect={CGPoint=dd}{CGSize=dd}}16@48B56B60 — it is the CGRect
// supplied by -sendHostFrameForPane:live:, NOT a bundle-ID string and
// NOT pane.hostFrame. The identifier is obtained inside this IMP from
// pane.bundleID (@0x3d44c-0x3d470, nil -> @"").
//   Base dictionary (11 keys, @0x3d440-0x3d624): identifier, x/y/w/h
//   from the argument frame, live, handle, and pt/pl/pb/pr from
//   -hostPassInsetsForPane:. The insets call is made before the base
//   dictionary is built (@0x3d40c-0x3d424); a nil pane substitutes
//   UIEdgeInsetsZero (@0x3d42c-0x3d438) and returns only the base
//   dictionary. `handle` is copied into the dictionary as a BOOL; in
//   the sole binary caller it is !CGRectIsEmpty(frame), but it does not
//   alter the frame or insets inside this IMP.
//   For a non-nil pane (@0x3d69c onward), the IMP then merges
//   -hostBarInfoForPane:, and adds r (pane.view.layer.cornerRadius),
//   corners (pane.view.layer.maskedCorners, as unsigned long long),
//   hx (-handleShiftForPane:), front (whether pane is -floatPane),
//   ox/oy/ow/oh from -holeForPane:, and — only when -tabParent is
//   non-nil — ax/ay/aw/ah from
//   [tabParent convertRect:[self appAreaInParent:tabParent] toView:nil].
- (NSDictionary *)hostFrameInfo:(CGRect)frame pane:(SCPCarPane *)pane live:(BOOL)live handle:(BOOL)handle {
    UIEdgeInsets insets = pane ? [self hostPassInsetsForPane:pane]
                               : UIEdgeInsetsZero;
    NSMutableDictionary *info = [@{@"identifier": pane.bundleID ?: @"",
                                   @"x": @(frame.origin.x),
                                   @"y": @(frame.origin.y),
                                   @"w": @(frame.size.width),
                                   @"h": @(frame.size.height),
                                   @"live": @(live),
                                   @"handle": @(handle),
                                   @"pt": @(insets.top),
                                   @"pl": @(insets.left),
                                   @"pb": @(insets.bottom),
                                   @"pr": @(insets.right)} mutableCopy];
    if (!pane) return info;

    [info addEntriesFromDictionary:[self hostBarInfoForPane:pane]];
    // [autohide] additive key (design-autohide §2.4): the owner's fade
    // flag rides the same packet as `handle`, so ABHost applies both in
    // the same beat and every frame push self-heals the mirror. All
    // original keys keep their names/formulas (superset rule, §5.4).
    // The fade is NEVER encoded through `handle` itself (§2.2).
    info[@"fade"] = @([self ahFaded]);
    // [ytz-y1] additive keys (GPT WO Y1): the AUTHORITATIVE split
    // presentation state rides the same packet, computed HERE on the
    // owner from its own presentation state — split session active
    // (self.active, set at activateWithCount:) AND at least two
    // panes in the layout (paneCount = slots.count, SCPCarSplit.m
    // -paneCount) AND no slot zoomed (with a zoomed slot the screen
    // presents ONE pane — the same third term as this module's
    // VERIFIED -dividersVisible predicate, SCPCarSplit+Layout.m
    // @0x11b50). ABHost must NOT infer this from its hosted-pane
    // count: a mixed split (one native pane + one hosted pane)
    // shows ABHost exactly one pane while the car IS split.
    // `splitver` versions the field (1 = this BOOL); a packet
    // without the field is "unknown" host-side and takes the logged
    // fallback there. The bar's `single` key is deliberately NOT
    // reused: its semantics are the bar's zoom state, not the
    // presentation's (WO Y1). Superset rule holds — every original
    // key keeps its name/formula.
    info[@"split"] = @(self.active && self.paneCount >= 2 && self.zoomedSlot == nil);
    info[@"splitver"] = @1;
    info[@"r"] = @(pane.view.layer.cornerRadius);
    info[@"corners"] = @(pane.view.layer.maskedCorners);
    info[@"hx"] = @([self handleShiftForPane:pane]);
    info[@"front"] = @(pane == self.floatPane);

    CGRect hole = [self holeForPane:pane];
    info[@"ox"] = @(hole.origin.x);
    info[@"oy"] = @(hole.origin.y);
    info[@"ow"] = @(hole.size.width);
    info[@"oh"] = @(hole.size.height);

    UIView *tabParent = [self tabParent];
    if (tabParent) {
        CGRect appArea = [tabParent convertRect:[self appAreaInParent:tabParent]
                                         toView:nil];
        info[@"ax"] = @(appArea.origin.x);
        info[@"ay"] = @(appArea.origin.y);
        info[@"aw"] = @(appArea.size.width);
        info[@"ah"] = @(appArea.size.height);
    }
    return info;
}

// Geometry helpers for the bridge (remediation: all three line-read from
// the binary — the previous INFERRED one-liners were wrong).
// -hostFrameForPane: (0x3ca0c) VERIFIED (rem_stub_hostFrameForPane:.txt):
// the pane's frame in window coordinates, or CGRectZero when the pane
// cannot be presented to the bridge right now (inactive, no VC, picker
// up, faded out, too small, no window, or covered by the tray / picker
// sheet / ratio menu overlays — the ratio menu cuts a 6 pt-inflated hole).
- (CGRect)hostFrameForPane:(SCPCarPane *)pane {
    if (!self.active || !pane.vc) return CGRectZero;
    if (pane.picker) return CGRectZero;
    if (pane.view.alpha < 0.5) return CGRectZero;
    if (pane.view.bounds.size.width < 20.0) return CGRectZero;
    if (!pane.view.window) return CGRectZero;
    if (self.tray && !self.trayOverlay) return CGRectZero;
    if (self.pickerSheet && !self.pickerSheetOverlay) return CGRectZero;
    if (self.ratioMenu && !self.ratioOverlay) {
        CGRect hole = CGRectInset(self.ratioMenu.frame, -6.0, -6.0);
        if (CGRectIntersectsRect(hole, pane.view.frame)) return CGRectZero;
    }
    return [pane.view convertRect:pane.view.bounds toView:nil];
}

// -holeForPane: (0x3dca8) VERIFIED (rem_stub_holeForPane:.txt): the float
// pane's window-space rect when it overlaps this pane — the region the
// bridge must cut out. Zero unless there is a visible, non-hosted float
// pane distinct from this pane.
- (CGRect)holeForPane:(SCPCarPane *)pane {
    SCPCarPane *floatPane = self.floatPane;
    if (!pane || !floatPane || pane == floatPane) return CGRectZero;
    if (!floatPane.vc || SCPVCIsHosted(floatPane.vc)) return CGRectZero;
    if (!floatPane.view.window) return CGRectZero;
    if (floatPane.view.alpha < 0.5) return CGRectZero;
    CGRect floatRect = [floatPane.view convertRect:floatPane.view.bounds toView:nil];
    CGRect paneRect = [pane.view convertRect:pane.view.bounds toView:nil];
    return CGRectIntersectsRect(floatRect, paneRect) ? floatRect : CGRectZero;
}

// -hostBarInfoForPane: (0x3cd60) VERIFIED (rem_stub_hostBarInfoForPane:.txt):
// bar visibility, pop affordance (2 for the float pane, 1 otherwise),
// whether pop is dimmed (float pane: only with < 3 panes; other panes:
// -canPopOutPane:), and whether this pane is the zoomed one.
- (NSDictionary *)hostBarInfoForPane:(SCPCarPane *)pane {
    BOOL canPop;
    if (pane == self.floatPane) canPop = pane.vc && self.paneCount < 3;
    else canPop = [self canPopOutPane:pane];
    NSNumber *zoomed = self.zoomedSlot;
    BOOL single = zoomed && zoomed.intValue == pane.slot;
    return @{ @"bar": @(!pane.bar.isHidden),
              @"pop": @((pane == self.floatPane) ? 2 : 1),
              @"popDim": @(!canPop),
              @"single": @(single) };
}
// [phase2; backported to src in phase 3] merge] -anyBarVisible is implemented in SCPCarSplit+Chrome.m.
// A's copy here read pane.hostBar; the binary @0x3d058 (disasm
// SCPCarSplit__anyBarVisible.txt) iterates allPanes sending `bar` then
// `isHidden` — exactly the Chrome body — so this duplicate was removed
// to avoid two implementations of one selector.
// -hostPassInsetsForPane: VERIFIED (IMP 0x3d1e4 — line-read end to end
// in the final closure): returns UIEdgeInsets, four doubles in v0-v3
// with NO sret and no object traffic — B's header declaration was
// right, A's NSDictionary* declaration/body were wrong. Each edge gets
// 10 pt when the pane's view does NOT reach that edge of its superview:
// top/left when the frame origin sits more than 1 pt in, bottom/right
// when the frame max stops more than 1 pt short of the host's extent.
// (pane.view is fetched twice in the binary — once for the frame, once
// for the superview — as written here.)
- (UIEdgeInsets)hostPassInsetsForPane:(SCPCarPane *)pane {
    CGRect frame = pane.view.frame;
    CGRect host = pane.view.superview.bounds;
    UIEdgeInsets insets = UIEdgeInsetsZero;
    if (CGRectGetMinY(frame) > 1.0) insets.top = 10.0;
    if (CGRectGetMinX(frame) > 1.0) insets.left = 10.0;
    if (CGRectGetMaxY(frame) < host.size.height - 1.0) insets.bottom = 10.0;
    if (CGRectGetMaxX(frame) < host.size.width - 1.0) insets.right = 10.0;
    return insets;
}
- (NSArray<SCPCarPane *> *)hostedPanes {
    NSMutableArray *out = [NSMutableArray array];
    for (SCPCarPane *pane in [self allPanes]) if (SCPVCIsHosted(pane.vc)) [out addObject:pane];
    return out;
}
- (SCPCarPane *)bridgedPane { return [self hostedPanes].firstObject; }
// -pushHostFramesLive: (IMP 0x3e238) VERIFIED (fix-round2 spot
// fold-in, dump -SCPCarSplit_pushHostFramesLive_.txt): after the
// hostedPanes enumeration the original UNCONDITIONALLY calls
// publishShield (@0x3e30c) then refreshShieldHoles (@0x3e314). The
// empty-enumeration exit (first countByEnumerating cbz @0x3e29c) and
// the loop-exhausted exit (@0x3e2fc) both converge on 0x3e300, the
// only normal exit block; no other return exists (the 0x3e358+
// landing pads are unwind-only). Tail restored.
- (void)pushHostFramesLive:(BOOL)live {
    for (SCPCarPane *pane in [self hostedPanes]) [self sendHostFrameForPane:pane live:live];
    [self publishShield];
    [self refreshShieldHoles];
}
// -pushSceneSizes (0x1c550) VERIFIED (remediation, rem_pushSceneSizes.txt
// + blocks @0x1c9d4/@0x1cc90 rem_pushSceneSizes_block1/2.txt — replaces an
// INFERRED one-liner; the binary does NOT call pushHostFramesLive:). For
// every pane with a NON-hosted VC whose slot size changed (and is at
// least 2x2), record the new scene size, ask the VC to foreground its
// scene with that size (direct msgSend, empty completion block, wrapped
// in @try/@catch), then schedule two fix-ups: at +0.4 s re-frame the VC's
// sceneHostView to the VC view's bounds, at +0.9 s verify the scene size.
// No self.active check exists in the binary body.
- (void)pushSceneSizes {
    for (SCPCarPane *pane in [self allPanes]) {
        if (!pane.vc) continue;
        if (SCPVCIsHosted(pane.vc)) continue;
        CGSize size = [self frameForSlot:pane.slot].size;
        if (size.width < 2.0 || size.height < 2.0) continue;
        if (CGSizeEqualToSize(size, pane.sceneSize)) continue;
        pane.sceneSize = size;
        OMCLogWrite(@"SplitScreen", [NSString stringWithFormat:
            @"CarSplit: scene %@ -> %@", pane.bundleID, NSStringFromCGSize(size)]);
        UIViewController *vc = pane.vc;
        @try {
            ((void (*)(id, SEL, id, id))objc_msgSend)(vc,
                NSSelectorFromString(@"foregroundSceneWithSettings:completion:"),
                nil, (id)^{});
        } @catch (NSException *ex) {
            OMCLogWrite(@"SplitScreen", [NSString stringWithFormat:
                @"CarSplit: foregroundScene loi %@", ex]);
        }
        SCPDispatchAfter(0.4, ^{
            UIView *hostView = SCPGuarded(vc, @"sceneHostView");
            if (!hostView) return;
            if (hostView.superview != vc.view) return;
            if (CGRectEqualToRect(hostView.frame, vc.view.bounds)) return;
            OMCLogWrite(@"SplitScreen", [NSString stringWithFormat:
                @"CarSplit: sceneHostView %@ -> %@",
                NSStringFromCGRect(hostView.frame), NSStringFromCGRect(vc.view.bounds)]);
            hostView.frame = vc.view.bounds;
        });
        __weak SCPCarSplit *weakSelf = self;
        SCPDispatchAfter(0.9, ^{
            [weakSelf verifySceneOfPane:pane expected:size retry:1];
        });
    }
}
// -soloBundle: VERIFIED (IMP 0x1e33c — line-read end to end in the
// final closure, incl. its three deferred blocks; dumps sub_1e33c /
// sub_1ea0c / sub_1ebb4 / sub_1ee70 in src/SplitScreenA/disasm/). TRUE
// ABI: - (void)soloBundle:(NSString *)bundleID — A's old body
// ((NSString *)soloBundle:(BOOL)) and B's header guess
// ((SCPCarPane *) -> NSString*) were both wrong-ABI INFERRED stubs.
// Takes the split back to a single fullscreen app: a hosted (AppBridge)
// app goes through hostSolo:; a native pane's VC is handed back to the
// dashboard root VC for presentation; when no pane holds the app, a
// DBApplicationLaunchInfo relaunch is attempted (cover + a 0.8 s
// dashboard relaunch through -_launchAppWithInfo:forURL:, falling back
// to a type-4 DBEvent carrying the launchInfo).
- (void)soloBundle:(NSString *)bundleID {
    if (!self.active) return;
    if (!bundleID) {
        [self noteCloseSource:@"native-close"]; // [ytz5] M5 src=: no app kept, plain close
        [self closeGoingHome:YES];
        return;
    }
    if (SCPIsHostedApp(bundleID)) {
        OMCLogWrite(@"SplitScreen", [NSString stringWithFormat:
            @"CarSplit: chi giu %@ (app iPhone) -> App Bridge toan man", bundleID]);
        [self hostSolo:bundleID];
        self.ignoreHomeOnce = YES;
        [self noteCloseSource:@"solo"]; // [ytz5] M5 src=
        [self closeGoingHome:YES];
        self.ignoreHomeOnce = NO;
        // [ytz5] Solo order (GPT ruling 2026-11-09 18:45): hostSolo:
        // set ahSetSuspended:YES BEFORE the close (inside hostSolo:),
        // and the M1 cleanup inside closeGoingHome: resets the split
        // session's suspended state — so the DESTINATION mode
        // (hosted-solo) sets its suspension AFTER the cleanup, here.
        // Do NOT "preserve" the pre-close suspension inside cleanup.
        [self ahSetSuspended:YES];
        return;
    }
    OMCLogWrite(@"SplitScreen", [NSString stringWithFormat:
        @"CarSplit: chi giu %@ -> mo toan man", bundleID]);
    SCPCarPane *target = nil;
    for (SCPCarPane *pane in [self allPanes]) {
        if (!pane.vc) continue;
        if (![pane.bundleID isEqualToString:bundleID]) continue;
        if (SCPVCIsHosted(pane.vc)) continue;
        target = pane;   // no break in the binary: the LAST match wins
    }
    UIViewController *vc = target.vc;
    id rootVC = SCPDashboardRootViewController();
    SEL presentSel = NSSelectorFromString(
        @"presentBaseViewController:animated:launchSource:completion:");
    if (vc && rootVC && [rootVC respondsToSelector:presentSel]) {
        target.vc = nil;
        target.bundleID = nil;
        [self bwNoteAssignmentForPane:target]; // [ytz5] assignment teardown event
        [self detachVC:vc background:NO];
        [self noteCloseSource:@"native-close"]; // [ytz5] M5 src=: native VC handed back to the dashboard
        [self closeGoingHome:NO];
        ((void (*)(id, SEL, id, BOOL, id, id))objc_msgSend)(
            rootVC, presentSel, vc, YES, nil, nil);
        self.soloReturnedVC = vc;
        OMCLogWrite(@"SplitScreen", [NSString stringWithFormat:
            @"CarSplit: tra %@ cho DashBoard trinh bay toan man", bundleID]);
        // Block @0x1ea0c (+0.15 s): foreground the returned VC's scene,
        // then log its size; any exception is logged, not propagated.
        SCPDispatchAfter(0.15, ^{
            @try {
                SEL fgSel = NSSelectorFromString(
                    @"foregroundSceneWithSettings:completion:");
                ((void (*)(id, SEL, id, id))objc_msgSend)(vc, fgSel, nil, (id)^{});
                OMCLogWrite(@"SplitScreen", [NSString stringWithFormat:
                    @"CarSplit: scene %@ -> toan man %@", bundleID,
                    NSStringFromCGSize(vc.view.bounds.size)]);
            } @catch (NSException *ex) {
                OMCLogWrite(@"SplitScreen", [NSString stringWithFormat:
                    @"CarSplit: foregroundScene toan man loi %@", ex]);
            }
        });
        // Block @0x1ebb4 (+0.6 s): stretch the VC's sceneHostView to the
        // VC's bounds when it is hosted directly by the VC's view and
        // its frame has not caught up; all exceptions swallowed.
        SCPDispatchAfter(0.6, ^{
            @try {
                UIView *hostView = SCPGuardedSend(vc, @"sceneHostView");
                if (!hostView) return;
                if (hostView.superview != vc.view) return;
                CGRect bounds = vc.view.bounds;
                if (CGRectEqualToRect(hostView.frame, bounds)) return;
                OMCLogWrite(@"SplitScreen", [NSString stringWithFormat:
                    @"CarSplit: sceneHostView %@ -> %@ (toan man)",
                    NSStringFromCGRect(hostView.frame),
                    NSStringFromCGRect(bounds)]);
                hostView.frame = bounds;
            } @catch (id) { }
        });
        return;
    }
    // No live pane holds the app: rebuild a launch info and relaunch.
    // (OMCCarLaunchInfo takes the application-info OBJECT here.)
    id info = SCPApplicationInfoForBundle(bundleID);
    id launchInfo = OMCCarLaunchInfo(info);
    if (launchInfo) [self showSoloCoverForBundle:bundleID];
    [self noteCloseSource:@"native-close"]; // [ytz5] M5 src=: native relaunch path
    [self closeGoingHome:YES];
    if (launchInfo) {
        // Block @0x1ee70 (+0.8 s, weak self): only while the split is
        // inactive — relaunch through the dashboard when possible,
        // else post the launchInfo as a type-4 DBEvent. (The binary
        // double-probes _launchAppWithInfo:forURL: and would log
        // SCPMissingSelector in the unreachable second-probe failure;
        // the single probe here is behaviourally identical.)
        __weak SCPCarSplit *weakSelf = self;
        SCPDispatchAfter(0.8, ^{
            SCPCarSplit *strongSelf = weakSelf;
            if (!strongSelf) return;
            if (strongSelf.active) return;
            id dashboard = SCPDashboardObject();
            id info2 = SCPApplicationInfoForBundle(bundleID);
            OMCLogWrite(@"SplitScreen", [NSString stringWithFormat:
                @"CarSplit: mo lai %@ toan man (dashboard=%d, info=%d)",
                bundleID, dashboard != nil, info2 != nil]);
            SEL launchSel = NSSelectorFromString(@"_launchAppWithInfo:forURL:");
            if (info2 && dashboard && objc_getClass("DBDashboard") &&
                [dashboard respondsToSelector:launchSel]) {
                ((void (*)(id, SEL, id, id))objc_msgSend)(
                    dashboard, launchSel, info2, nil);
            } else {
                SCPSendDashboardEvent(4, launchInfo);
            }
        });
    } else {
        [self toast:[NSString stringWithFormat:
            OMCTr(@"Không mở lại được %@", @"Couldn't reopen %@"),
            [self displayNameFor:bundleID]]];
    }
}

// [phase2 transcriptions; backported to src in phase 3] The next three methods exist in the binary and
// are called from B's Panel.m, but no src file implemented them (census
// UNCLAIMED). Transcribed from A's own disasm dumps; VERIFIED against
// them line by line.

// -[SCPCarSplit exitKeepBundle] @0x3ae10
- (nullable NSString *)exitKeepBundle {
    if (!self.active) return nil;
    NSInteger focused = self.focusedSlot;
    if (focused >= 0 && focused < self.paneCount) {
        NSString *b = self.slots[(NSUInteger)focused].bundleID;
        if (b != nil) return b;
    }
    for (SCPCarPane *pane in [self allPanes]) {
        if (pane.vc != nil && pane.bundleID != nil) return pane.bundleID;
    }
    return nil;
}

// -[SCPCarSplit exitTapped] @0x3b138 (@catch log format @0x7cf20 VERIFIED)
- (void)exitTapped {
    @try {
        [self collapseAppTray];
        if (self.active) {
            NSString *keep = [self exitKeepBundle];
            NSString *suffix = keep ? [NSString stringWithFormat:@", %@ ve toan man", keep] : @"";
            OMCLogWrite(@"SplitScreen", [NSString stringWithFormat:
                @"CarSplit: nut thoat -> thoat chia man%@", suffix]);
            if (keep) [self soloBundle:keep];
            else {
                [self noteCloseSource:@"tweak-exit"]; // [ytz5] M5 src=
                [self closeGoingHome:YES];
            }
        } else {
            OMCLogWrite(@"SplitScreen", @"CarSplit: nut thoat (chua chia) -> dong bang");
        }
    } @catch (NSException *e) {
        OMCLogWrite(@"SplitScreen", [NSString stringWithFormat:
            @"CarSplit: loi nut thoat %@\n%@", e, [e callStackSymbols]]);
    }
}

// -[SCPCarSplit atHomeScreen] @0x404fc
- (BOOL)atHomeScreen {
    id root = SCPDashboardRootViewController(); // sub_12658 (SCPShared)
    if (root == nil || self.active || ![SCPPrefs enabled]) return NO;
    SEL sel = NSSelectorFromString(@"currentBaseViewController");
    id base = nil;
    if ([root respondsToSelector:sel])
        base = ((id (*)(id, SEL))objc_msgSend)(root, sel);
    else
        SCPMissingSelector(root, @"currentBaseViewController");
    return base == nil;
}

// Solo cover (the placeholder shown while a solo hosted app starts).
// sub_21158 (remediation, rem_sub_21158.txt): icon styling for the cover —
// continuous corner radius at 27% of the width, clear background when an
// image is present, the cover's own pale color otherwise. (Helper name
// invented; no symbol survives in the binary.)
static void SCPStyleSoloIconView(UIImageView *view) {
    view.layer.cornerRadius = view.bounds.size.width * 0.27;
    view.layer.cornerCurve = kCACornerCurveContinuous;
    view.clipsToBounds = YES;
    view.backgroundColor = view.image ? [UIColor clearColor]
        : [UIColor colorWithRed:0.9333333333333333 green:0.9411764705882353 blue:0.984313725490196 alpha:1.0];
}

// -showSoloCoverForBundle: (0x20d8c) VERIFIED (remediation,
// rem_stub_showSoloCoverForBundle:.txt + timeout block @0x212bc
// rem_showSoloCover_block.txt — replaces an empty stub): pale cover over
// the app area with the app's icon (52 pt, centered, raised 6 pt) and a
// medium spinner under it; a watchdog hides the cover after 6 s for
// hosted apps, 3 s otherwise, if it is still the current cover.
- (void)showSoloCoverForBundle:(NSString *)bundleID {
    UIView *parent = [self tabParent];
    if (!parent) return;
    [self.soloCover removeFromSuperview];
    UIView *cover = [[UIView alloc] initWithFrame:[self appAreaInParent:parent]];
    cover.backgroundColor = [UIColor colorWithRed:0.9333333333333333 green:0.9411764705882353 blue:0.984313725490196 alpha:1.0];
    cover.userInteractionEnabled = NO;
    UIImageView *iconView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 52, 52)];
    iconView.image = SCPAppIconForBundle(bundleID);
    SCPStyleSoloIconView(iconView);
    iconView.center = CGPointMake(cover.bounds.size.width * 0.5, cover.bounds.size.height * 0.5 - 6.0);
    [cover addSubview:iconView];
    UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc]
        initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleMedium]; // 100 in the binary
    spinner.color = [UIColor colorWithRed:0.6078431372549019 green:0.5294117647058824 blue:0.9725490196078431 alpha:1.0];
    spinner.center = CGPointMake(cover.bounds.size.width * 0.5, CGRectGetMaxY(iconView.frame) + 18.0);
    [spinner startAnimating];
    [cover addSubview:spinner];
    [parent addSubview:cover];
    [self raiseView:cover];
    self.soloCover = cover;
    __weak UIView *weakCover = cover;
    __weak SCPCarSplit *weakSelf = self;
    SCPDispatchAfter(SCPIsHostedApp(bundleID) ? 6.0 : 3.0, ^{
        if (!weakCover) return;
        if (weakSelf.soloCover == weakCover) [weakSelf hideSoloCover];
    });
}

// -hideSoloCover (0x21390) VERIFIED (remediation, rem_stub_hideSoloCover.txt
// + blocks @0x214a4/@0x214b0 rem_hideSoloCover_anim/done.txt — replaces a
// property-only stub): fade the cover out over 0.25 s, then remove it.
- (void)hideSoloCover {
    UIView *cover = self.soloCover;
    self.soloCover = nil;
    if (!cover) return;
    [UIView animateWithDuration:0.25 animations:^{
        cover.alpha = 0;
    } completion:^(BOOL finished) {
        [cover removeFromSuperview];
    }];
}
// -setFullscreenBridgeHidden:bundle: (0x3c33c) VERIFIED from the full
// dump: this is the SOLO bridge path, not a pane path — the bundle:
// argument is never read; the solo session's own bundle rules.
// No solo session -> return (@0x3c388 cbz). State unchanged
// (hidden == trayHidesBridge) -> return (@0x3c394 cmp/b.eq).
// Otherwise: update trayHidesBridge, log, and post appbridge.frame
// with CGRectZero when hiding (@0x3c3ac) or soloHostedFrame when
// showing (@0x3c3cc), identifier = solo bundle, live=NO, handle=NO
// (7-key dictionary, hostPost @0x3c528).
- (void)setFullscreenBridgeHidden:(BOOL)hidden bundle:(NSString *)bundleID {
    NSString *solo = self.soloHostedBundle;
    if (!solo) return;
    if (hidden == self.trayHidesBridge) return;
    self.trayHidesBridge = hidden;
    CGRect frame = hidden ? CGRectZero : self.soloHostedFrame;
    OMCLogWrite(@"SplitScreen", [NSString stringWithFormat:
        @"AppBridge: %@ app toan man %@ (bang bo cuc)", hidden ? @"an" : @"hien lai", solo]);
    [self hostPost:SCPNoteBridgeFrame info:@{@"identifier": solo,
                                             @"x": @(frame.origin.x), @"y": @(frame.origin.y),
                                             @"w": @(frame.size.width), @"h": @(frame.size.height),
                                             @"live": @NO, @"handle": @NO}];
}

// Bridge input callbacks (posted by AppBridge). All four line-read in
// the remediation round (rem_stub_bridge*.txt) — the previous INFERRED
// empty forwarders were wrong, and bridgeHandleTapped: takes the bundle
// STRING, not a dictionary (binary type confirms an object arg read as
// the bundle by paneForBundle:).

// -bridgeBarAction:forBundle: (0x3f7f4) VERIFIED: dispatch a bar button
// action coming from the bridge side for the bundle's pane.
- (void)bridgeBarAction:(NSString *)action forBundle:(NSString *)bundleID {
    SCPCarPane *pane = [self paneForBundle:bundleID];
    if (!self.active || !pane) return;
    OMCLogWrite(@"SplitScreen", [NSString stringWithFormat:
        @"AppBridge: thanh nut %@ cua %@", action, bundleID]);
    if ([action isEqualToString:@"replace"]) {
        [self setBarVisible:NO forPane:pane];
        [self showPickerForSlot:pane.slot];
    } else if ([action isEqualToString:@"full"]) {
        [self runSoloForPane:pane];
    } else if ([action isEqualToString:@"pop"]) {
        [self popOutPane:pane];
    } else if ([action isEqualToString:@"bg"]) {
        [self runBackgroundForPane:pane];
    } else if ([action isEqualToString:@"close"]) {
        [self runCloseForPane:pane];
    }
}

// -bridgeHandleTapped: (0x3f65c) VERIFIED: a tap on the bridge handle —
// a second tap on the same bundle within 0.35 s is a double tap (zoom,
// or float-size for the float pane); a single tap toggles the pane's bar.
- (void)bridgeHandleTapped:(NSString *)bundle {
    SCPCarPane *pane = [self paneForBundle:bundle];
    if (!self.active || !pane) return;
    CFAbsoluteTime now = CFAbsoluteTimeGetCurrent();
    BOOL doubleTap = NO;
    NSString *record = bundle;
    if ([self.lastBridgeTapBundle isEqualToString:bundle]) {
        doubleTap = (now - self.lastBridgeTapAt) < 0.35;
        if (doubleTap) record = nil;
    }
    self.lastBridgeTapBundle = record;
    self.lastBridgeTapAt = now;
    if (doubleTap) {
        if (pane == self.floatPane) [self toggleFloatSize];
        else [self toggleZoomForPane:pane];
    } else {
        [self setBarVisible:pane.bar.isHidden forPane:pane];
    }
    [self ahNoteActivity:AHSourceHostHandle]; // [autohide] F2 feed (design-autohide §3.2; wiring per impl-autohide-car1 §4.4): a tap on the (possibly invisible) hosted handle is activity
}

// -bridgeOutsideTouched (0x257e8) VERIFIED: a single tail call.
- (void)bridgeOutsideTouched { [self closePopups]; }

// -bridgeHandleDrag: (0x28260) VERIFIED: route a bridge handle drag by
// phase (0 begin, 1 move, 2 end, anything else cancel); the float pane
// has its own drag path. Guard order in the binary: pane, container,
// active.
- (void)bridgeHandleDrag:(NSDictionary *)info {
    SCPCarPane *pane = [self paneForBundle:info[@"identifier"]];
    if (!pane || !self.container || !self.active) return;
    NSInteger phase = [info[@"phase"] intValue];
    CGPoint point = [self.container convertPoint:CGPointMake([info[@"x"] doubleValue],
                                                              [info[@"y"] doubleValue])
                                        fromView:nil];
    if (pane == self.floatPane) {
        [self floatDragPhase:phase at:point];
        return;
    }
    switch (phase) {
        case 0: [self beginPaneDrag:pane at:point]; break;
        case 1: [self movePaneDragTo:point from:pane]; break;
        case 2: [self endPaneDrag:pane]; break;
        default: [self cancelPaneDrag]; break;
    }
}

#pragma mark - State publishing

// -publishBusy (0x15834) VERIFIED (remediation, rem_stub_publishBusy.txt
// — replaces an INFERRED body: this is NOT a prefs write). The car side
// is "busy" while the app tray is up or the picker sheet is shown; the
// state goes out on the Darwin notify channel com.anlai.omnicar/car.busy
// (name read from the cstring at 0x61ee2), posted only on transitions.
- (void)publishBusy {
    BOOL busy = (self.tray != nil || self.pickerSheet != nil);
    static int token;
    static int lastState = -1;
    if (!token) notify_register_check("com.anlai.omnicar/car.busy", &token);
    if (lastState != busy) {
        lastState = busy;
        notify_set_state(token, (uint64_t)busy);
        notify_post("com.anlai.omnicar/car.busy");
        OMCLogWrite(@"SplitScreen", [NSString stringWithFormat:
            @"CarSplit: man xe %@", busy ? @"ban (an lop phu)" : @"ranh"]);
    }
}

// -publishCarPlayApps VERIFIED: collect the native CarPlay app IDs
// (sub_21d4c — the dashboard library walk of the home-grid family) into
// SCPPrefs for the Settings app; log both counts.
- (void)publishCarPlayApps {
    extern NSArray *SCPCarPlayAppInfos(void);   // sub_21d4c
    extern NSArray *SCPChosenPhoneAppInfos(void); // [phase2; backported to src in phase 3] sub_22210 returns the sorted infos array (C, dump-verified) — A's "Count" name was wrong
    NSMutableArray *ids = [NSMutableArray array];
    for (NSDictionary *info in SCPCarPlayAppInfos()) {
        if (info[@"id"]) [ids addObject:info[@"id"]];
    }
    [SCPPrefs setCarPlayApps:ids];
    // [applib] publish event for the Settings-side list; self bundle =
    // com.anlai.omnicar.app (app target Info.plist CFBundleIdentifier).
    OMCLogWrite(@"SplitScreen", [NSString stringWithFormat:
        @"[applib] build reason=publish-for-settings count=%lu omni=%d",
        (unsigned long)ids.count,
        [ids containsObject:@"com.anlai.omnicar.app"] ? 1 : 0]);
    OMCLogWrite(@"SplitScreen", [NSString stringWithFormat:
        @"CarSplit: %lu app CarPlay cho Settings, %lu app iPhone da chon (App Bridge)",
        (unsigned long)ids.count, (unsigned long)SCPChosenPhoneAppInfos().count]);
}

// -publishShield VERIFIED.
- (void)publishShield {
    BOOL open = [self popupOpen];
    if (open == self.shieldPosted) return;
    self.shieldPosted = open;
    [self hostPost:SCPNoteBridgeShield info:@{@"on": @(open)}];
}

// -publishKnobsSoon (0x3ed08) VERIFIED (remediation,
// rem_stub_publishKnobsSoon.txt + block @0x3ed74
// rem_publishKnobsSoon_block.txt — replaces an INFERRED debounce): a
// static scheduled flag coalesces calls; the block runs on the main
// queue (dispatch_async, NOT SCPDispatchAfter), clears the flag, then
// publishes. Self is captured strongly in the binary block.
- (void)publishKnobsSoon {
    static BOOL scheduled;
    if (scheduled) return;
    scheduled = YES;
    dispatch_async(dispatch_get_main_queue(), ^{
        scheduled = NO;
        [self publishKnobsNow];
    });
}

// -publishKnobsNow (0x3ed84) VERIFIED (remediation,
// rem_stub_publishKnobsNow.txt — replaces an INFERRED empty post):
// publish the window-space centers of all visible divider knobs (with an
// scaled/active flag and the divider index) on appbridge.knobs, but only while
// active with at least one hosted pane and no tray. Empty posts are
// suppressed except one final empty update when the set becomes empty.
- (void)publishKnobsNow {
    BOOL anyHosted = NO;
    for (SCPCarPane *pane in [self allPanes])
        anyHosted |= SCPVCIsHosted(pane.vc);
    NSMutableArray *knobs = [NSMutableArray array];
    if (self.active && anyHosted && !self.tray) {
        for (SCPCarDividerView *divider in self.dividers) {
            UIView *knob = divider.knob;
            if (!knob || knob.isHidden) continue;
            if (divider.alpha < 0.5) continue;
            if (!knob.window) continue;
            CGPoint center = [divider convertPoint:knob.center toView:nil];
            // Element 3 = !CGAffineTransformIsIdentity(transform), as the
            // original computes it: eor w2, w27, #1 on the IsIdentity
            // result (arm64 @0x3eff8, arm64e @0x413ac) feeding
            // numberWithBool: directly — publish `scaled`, no 2nd negation.
            BOOL scaled = !CGAffineTransformIsIdentity(knob.transform);
            [knobs addObject:@[ @(center.x), @(center.y), @(scaled), @(divider.index) ]];
        }
    }
    static BOOL postedNonEmpty;
    if (knobs.count == 0 && !postedNonEmpty) return;
    postedNonEmpty = (knobs.count != 0);
    // [autohide] `kfade` rides beside `knobs` (design-autohide §2.4):
    // the knob channel is the only one already carrying knob data, and
    // the payload is a dict, so the sibling key cannot break the
    // existing parser (it reads only @"knobs").
    [self hostPost:SCPNoteBridgeKnobs info:@{@"knobs": knobs,
                                             @"kfade": @([self ahFaded])}];
}

#pragma mark - Home button / dock / launcher (lifecycle side)

// This whole section was re-read instruction by instruction in the
// remediation round (rem_stub_refreshHomeButton.txt,
// rem_stub_launcherCenterInParent:size:shift:.txt,
// rem_stub_dockClusterInParent:.txt, rem_stub_dockHostForRect:inParent:.txt
// and the rem_sub_* helper dumps) — the previous INFERRED stubs (empty
// refreshHomeButton, nil-returning geometry helpers, a value-typed
// launcherCenter signature) are replaced. The C helpers below are
// file-local in the binary; their names are invented (no symbols survive).

@class SCPCButton;

// sub_41358: recursive search for the dashboard's real Home glyph —
// a view whose class name contains "Home" (case-insensitive), sized
// 20..70 pt, whose center falls inside the anchor rect (inset -4);
// the glyph rect is the union of its visible subview rects when that
// union fits inside the view rect grown by 1 pt. Keeps the topmost hit.
static void SCPFindHomeGlyph(UIView *view, UIView *parent, int depth, UIView *button,
                             CGRect anchor, CGRect *outRect, UIView **outView) {
    if (!view || depth > 20 || view == button) return;
    if (view.isHidden || view.alpha < 0.05) return;
    NSString *cls = NSStringFromClass(view.class);
    if ([cls rangeOfString:@"Home" options:NSCaseInsensitiveSearch].location == NSNotFound) {
        for (UIView *sub in view.subviews)
            SCPFindHomeGlyph(sub, parent, depth + 1, button, anchor, outRect, outView);
        return;
    }
    CGRect r = [parent convertRect:view.bounds fromView:view];
    if (r.size.width < 20 || r.size.width > 70 || r.size.height < 20 || r.size.height > 70) {
        for (UIView *sub in view.subviews)
            SCPFindHomeGlyph(sub, parent, depth + 1, button, anchor, outRect, outView);
        return;
    }
    CGRect inset = CGRectInset(anchor, -4, -4);
    if (!CGRectContainsPoint(inset, CGPointMake(CGRectGetMidX(r), CGRectGetMidY(r)))) {
        for (UIView *sub in view.subviews)
            SCPFindHomeGlyph(sub, parent, depth + 1, button, anchor, outRect, outView);
        return;
    }
    CGRect unionR = CGRectNull;
    for (UIView *sub in view.subviews) {
        if (sub.isHidden || sub.alpha < 0.05) continue;
        if (sub.bounds.size.height <= 2) continue;
        unionR = CGRectUnion(unionR, [parent convertRect:sub.bounds fromView:sub]);
    }
    if (!CGRectIsNull(unionR) && CGRectContainsRect(CGRectInset(r, -1, -1), unionR))
        r = unionR;
    if (!CGRectIsNull(*outRect) && CGRectGetMinY(r) <= CGRectGetMinY(*outRect)) return;
    *outRect = r;
    *outView = view;
}

// sub_41898: recursive scan that raises *base past status-bar / battery
// views (class prefixes _UIStatusBar / _UIBattery, 2 < height < 40)
// whose center falls inside the anchor rect (inset -4) above its middle.
static void SCPScanStatusBarBaseline(UIView *view, UIView *parent, int depth,
                                     CGRect anchor, double *base) {
    if (!view || depth > 20) return;
    if (view.isHidden) return;
    if (view.alpha < 0.05) return;
    NSString *cls = NSStringFromClass(view.class);
    if ([cls hasPrefix:@"_UIStatusBar"] || [cls hasPrefix:@"_UIBattery"]) {
        CGRect b = view.bounds;
        if (b.size.height > 2.0 && b.size.height < 40.0) {
            CGRect r = [parent convertRect:view.bounds fromView:view];
            CGRect inset = CGRectInset(anchor, -4, -4);
            if (CGRectContainsPoint(inset, CGPointMake(CGRectGetMidX(r), CGRectGetMidY(r))) &&
                CGRectGetMidY(r) < CGRectGetMidY(anchor))
                *base = MAX(*base, CGRectGetMaxY(r));
        }
    }
    for (UIView *sub in view.subviews)
        SCPScanStatusBarBaseline(sub, parent, depth + 1, anchor, base);
}

// sub_431c0: append a view-tree dump (class + frame in root coordinates,
// " hidden" / " noTouch" markers, 2 spaces per depth, depth cap 7,
// output cap 6000 chars) for the one-time dock diagnostic.
static void SCPDumpDockTree(UIView *view, UIView *root, int depth, NSMutableString *out) {
    if (!view || depth > 7) return;
    if (out.length > 6000) return;
    CGRect r = [root convertRect:view.bounds fromView:view];
    NSString *indent = [@"" stringByPaddingToLength:(NSUInteger)(depth * 2)
                                        withString:@" " startingAtIndex:0];
    [out appendFormat:@"%@%@ %@%@%@\n", indent, NSStringFromClass(view.class),
        NSStringFromCGRect(r), view.isHidden ? @" hidden" : @"",
        view.isUserInteractionEnabled ? @"" : @" noTouch"];
    for (UIView *sub in view.subviews)
        SCPDumpDockTree(sub, root, depth + 1, out);
}

// sub_42564: render the split-screen glyph (two white rounded rects side
// by side) as a template image. Sizes are rounded (frinta in the binary);
// pane width is capped by the height; the gap scales at 11% of the width.
static UIImage *SCPLauncherGlyphImage(double w, double h) {
    w = MAX(round(w), 6.0);
    h = MAX(round(h), 4.0);
    double gap = MAX(round(w * 0.11), 1.5);
    double paneW = MIN((w - gap) * 0.5, h);
    double radius = MAX(paneW * 0.18, 2.5);
    UIGraphicsImageRendererFormat *format = [UIGraphicsImageRendererFormat preferredFormat];
    format.opaque = NO;
    UIGraphicsImageRenderer *renderer = [[UIGraphicsImageRenderer alloc]
        initWithSize:CGSizeMake(w, h) format:format];
    UIImage *image = [renderer imageWithActions:^(UIGraphicsImageRendererContext * _Nonnull ctx) {
        (void)ctx;
        UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, paneW, h)
                                                        cornerRadius:radius];
        [path appendPath:[UIBezierPath bezierPathWithRoundedRect:CGRectMake(paneW + gap, 0, paneW, h)
                                                    cornerRadius:radius]];
        [[UIColor whiteColor] setFill];
        [path fill];
    }];
    return [image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
}

// sub_302f8: bare SCPCButton factory for the launcher (34 pt default
// bounds, corner radius 17, fixed ink tint, glyph image, tap target).
static SCPCButton *SCPButtonWithGlyph(UIImage *image, id target, SEL action) {
    SCPCButton *button = [SCPCButton buttonWithType:UIButtonTypeCustom];
    button.bounds = CGRectMake(0, 0, 34, 34);
    button.layer.cornerRadius = 17;
    button.tintColor = [UIColor colorWithRed:0.2901960784313726 green:0.30980392156862746 blue:0.5019607843137255 alpha:1.0];
    [button setImage:image forState:UIControlStateNormal];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return button;
}

// sub_271e4: the launcher button's card styling (pale background,
// continuous corners, hairline border, violet shadow).
static void SCPStyleLauncherButton(UIView *view, double radius) {
    view.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.9];
    view.layer.cornerRadius = radius;
    view.layer.cornerCurve = kCACornerCurveContinuous;
    view.layer.borderWidth = 0.5;
    view.layer.borderColor = [UIColor colorWithWhite:1.0 alpha:0.85].CGColor;
    view.layer.shadowColor = [UIColor colorWithRed:0.43137254901960786 green:0.39215686274509803 blue:0.7843137254901961 alpha:1.0].CGColor;
    view.layer.shadowOpacity = 0.25;
    view.layer.shadowRadius = 10;
    view.layer.shadowOffset = CGSizeMake(0, 4);
}

// sub_2b404: the free-standing (corner) launcher button — glyph button
// sized to `size` and given the card styling at half-size radius.
static SCPCButton *SCPLauncherButton(UIImage *image, id target, SEL action, double size) {
    SCPCButton *button = SCPButtonWithGlyph(image, target, action);
    button.bounds = CGRectMake(0, 0, size, size);
    SCPStyleLauncherButton(button, size * 0.5);
    return button;
}

// [GPT-F] §F Dock gate diagnostic (fix-round2, candidate-only; logging
// ONLY — no flow change): emits ONE line per home-button TRANSITION in
// -refreshHomeButton: (a) created/attached, (b) removed on a gate
// failure, (c) host (superview) change. Gate-failure lines name the
// failed gate per §E ("root nil" / "feature disabled" / "tabParent
// nil"); the snapshot fields are the gate state the function itself
// tests: active, featureEnabled ([SCPPrefs enabled]), root class,
// parent class, homeButton superview class, button frame in window
// coordinates (its own frame when windowless), hidden, alpha and
// launcherWhere. Callers invoke this ONLY on a transition (removals are
// guarded on a button actually existing), so a keep-path refresh that
// creates/removes/moves nothing logs nothing — never per layout pass.
static void SCPFDockGateLog(SCPCarSplit *owner, NSString *event, NSString *gate, id root, UIView *parent) {
    UIButton *btn = owner.homeButton;
    UIView *sup = btn.superview;
    CGRect frameWin = btn ? (btn.window ? [btn convertRect:btn.bounds toView:nil] : btn.frame)
                          : CGRectZero;
    OMCLogWrite(@"SplitScreen", [NSString stringWithFormat:
        @"[GPT-F] Dock gate %@ gate=%@ active=%d featureEnabled=%d root=%@ parent=%@ homeSuper=%@ frameWin=%@ hidden=%d alpha=%.2f launcherWhere=%@",
        event, gate, (int)owner.active, (int)[SCPPrefs enabled],
        root ? NSStringFromClass([root class]) : @"nil",
        parent ? NSStringFromClass(parent.class) : @"nil",
        sup ? NSStringFromClass(sup.class) : @"nil",
        NSStringFromCGRect(frameWin),
        btn ? (int)btn.hidden : 0, btn ? btn.alpha : 0.0,
        owner.launcherWhere ?: @"nil"]);
}

// -refreshHomeButton (0x41be4) VERIFIED: maintain the Split Screen
// launcher button on the dashboard. Bails (removing the button) without
// a dashboard root or with the tweak disabled; throttles recompute to
// once per second while the button is already hosted; otherwise asks
// -launcherCenterInParent:size:shift: for placement, rebuilds the button
// when its glyph/size/mode changed, tints it (dark-ink in corner mode,
// dynamic ink otherwise), hosts it (directly in the tab parent in corner
// mode, else inside the dock host for its rect) and raises it.
- (void)refreshHomeButton {
    // [GPT-F] transition snapshot (read-only): told apart at the attach
    // site below to classify created / attached / host-changed.
    UIButton *fdPrevButton = self.homeButton;
    UIView *fdPrevSuper = fdPrevButton.superview;
    id root = SCPDashboardRootViewController();
    // [GPT-F] the combined bail is split so the removal line can name
    // WHICH gate failed (§E); order and flow are unchanged (root first,
    // then enabled, then tabParent — audit-spotfold.md rows 1-3).
    if (!root) {
        if (self.homeButton) SCPFDockGateLog(self, @"removed", @"root nil", root, nil);
        [self removeHomeButton];
        return;
    }
    if (![SCPPrefs enabled]) {
        if (self.homeButton) SCPFDockGateLog(self, @"removed", @"feature disabled", root, nil);
        [self removeHomeButton];
        return;
    }
    UIView *parent = [self tabParent];
    if (!parent) {
        if (self.homeButton) SCPFDockGateLog(self, @"removed", @"tabParent nil", root, parent);
        [self removeHomeButton];
        return;
    }
    // [gpt-home-grid-only] The real OmniCar Home tile now launches the
    // SAME SCPCarSplit layout panel. Retire ONLY our extra UIButton in
    // the Dock; keep the native Apple Dock and all split/host controllers.
    // In particular, removeHomeButton restores the launcher-induced Dock
    // transform, and the icon long-press installer previously piggybacked
    // on this method: keep that operation even without a custom button.
    if (SCPHomeLauncherEnabled()) {
        if (self.homeButton) {
            SCPFDockGateLog(self, @"removed", @"native Home grid only", root, parent);
            [self removeHomeButton];
            OMCLogWrite(@"SplitScreen",
                @"[home-launch] custom Dock button detached; native Home tile retained");
        }
        if ([self atHomeScreen]) [self installIconLongPress];
        return;
    }
    CFAbsoluteTime now = CFAbsoluteTimeGetCurrent();
    UIView *btnSuper = self.homeButton.superview;
    if (btnSuper && btnSuper == self.launcherHost && now - self.lastLauncherCalc < 1.0) {
        [self raiseLauncher];
        return;
    }
    self.lastLauncherCalc = now;
    double size = 34.0;
    double shift = 0.0;
    CGPoint center = [self launcherCenterInParent:parent size:&size shift:&shift];
    [self setDockShift:shift];
    BOOL bare = [self.launcherWhere hasPrefix:@"goc"];
    double imgW, imgH;
    if (bare) {
        imgW = size * 0.5;
        imgH = size * 0.36;
    } else {
        imgW = size * 0.6;
        imgH = size * 0.4;
        if (!CGRectIsNull(self.homeGlyph) &&
            self.homeGlyph.size.width >= 8 && self.homeGlyph.size.width <= size) {
            imgW = self.homeGlyph.size.width;
            imgH = MIN(self.homeGlyph.size.height, size - 2);
        }
    }
    imgW = round(imgW);
    imgH = round(imgH);
    UIButton *button = self.homeButton;
    BOOL rebuild = YES;
    if (button) {
        UIImage *img = [button imageForState:UIControlStateNormal];
        BOOL sizeOK = (img.size.width == imgW) && (img.size.height == imgH);
        // Keep gate (0x41ee0-0x41f28, spot-audit adjudicated — see
        // work/fix-round2/audit-spotfold.md): bounds |w-size| <= 0.5 is
        // a GATE (b.le @0x41ef0) to the w25 test; w26 is the image-size
        // MISMATCH flag (cset/csinc @0x41e7c-0x41e88; 1 when no
        // button), w8 = bare ^ launcherBare (eor @0x41f10),
        // w25 = w26 | ~w8 (orn @0x41f14); tbz w25,#0 (@0x41f28) skips
        // the rebuild to 0x420e8 iff w26 == 0 AND w8 == 1, i.e. iff
        // sizeOK && bare != launcherBare. Combined form below is the
        // original's condition exactly.
        if (fabs(button.bounds.size.width - size) <= 0.5 && sizeOK && bare != self.launcherBare)
            rebuild = NO;
    }
    if (rebuild) {
        [button removeFromSuperview];
        if (bare) {
            // Original bare order: glyph (sub_42564 @0x41f5c) ->
            // SCPLauncherButton (sub_2b404 @0x41f7c) -> setBounds:
            // (@0x41fa8; the helper also sets bounds internally).
            UIImage *glyph = SCPLauncherGlyphImage(imgW, imgH);
            button = SCPLauncherButton(glyph, self, @selector(homeButtonTapped), size);
            button.bounds = CGRectMake(0, 0, size, size);
        } else {
            // Original non-bare order (spot-audit minor, restored):
            // buttonWithType: (@0x41fc0) BEFORE the glyph (@0x41fdc),
            // setBounds: (@0x42038) BEFORE the log block (@0x4203c).
            button = [SCPCButton buttonWithType:UIButtonTypeCustom];
            UIImage *glyph = SCPLauncherGlyphImage(imgW, imgH);
            [button setImage:glyph forState:UIControlStateNormal];
            [button addTarget:self action:@selector(homeButtonTapped)
             forControlEvents:UIControlEventTouchUpInside];
            button.bounds = CGRectMake(0, 0, size, size);
            OMCLogWrite(@"SplitScreen", [NSString stringWithFormat:
                @"CarSplit: nut Split Screen tren dock %.0fpt, hinh %@ (luoi nut Home %@)",
                size, NSStringFromCGSize(CGSizeMake(imgW, imgH)),
                NSStringFromCGRect(self.homeGlyph)]);
        }
        self.homeButton = button;
        // The binary stores the INVERSE of the current corner-mode flag
        // here (eor w2, w22, #1 at 0x420d4) — reproduced as read. The
        // keep-check above therefore requires bare != launcherBare
        // (fix-round2 correction: at 0x41f10-0x41f28 the skip-rebuild
        // branch is taken only when (bare ^ launcherBare) == 1 and the
        // image-size flag w26 == 0; the previous transcription had the
        // bare comparison inverted, so a rebuilt button could never be
        // kept). With the inverse store, a rebuilt button IS kept by
        // the next non-throttled refresh.
        self.launcherBare = !bare;
    }
    UIColor *ink = self.homeInk;
    if (!ink) {
        ink = [UIColor colorWithDynamicProvider:^UIColor * _Nonnull(UITraitCollection * _Nonnull traits) {
            return traits.userInterfaceStyle == UIUserInterfaceStyleDark
                ? [UIColor whiteColor] : [UIColor blackColor];
        }];
        self.homeInk = ink;
    }
    if (bare)
        ink = [UIColor colorWithRed:0.2901960784313726 green:0.30980392156862746 blue:0.5019607843137255 alpha:1.0];
    self.homeButton.tintColor = ink;
    UIView *host;
    if (bare) {
        host = parent;
    } else {
        CGRect rect = CGRectMake(center.x - size / 2, center.y - size / 2, size, size);
        host = [self dockHostForRect:rect inParent:parent];
        if (!host) host = parent;
    }
    if (self.homeButton.superview != host) {
        [host addSubview:self.homeButton];
        // [GPT-F] this branch IS the attach/host-change transition (the
        // original's own superview != host test, audit-spotfold.md row
        // 18): log AFTER addSubview so homeSuper/frameWin are the new
        // host state. A rebuilt button (identity changed vs the entry
        // snapshot) is "created"; a kept button with no previous host is
        // "attached"; with a different previous host, "host-changed".
        SCPFDockGateLog(self,
                        self.homeButton != fdPrevButton ? @"created"
                            : (fdPrevSuper ? @"host-changed" : @"attached"),
                        @"pass", root, parent);
        OMCLogWrite(@"SplitScreen", [NSString stringWithFormat:
            @"CarSplit: nut Split Screen gan vao %@ %@",
            NSStringFromClass(host.class),
            host == parent ? @"(tabParent)"
                           : NSStringFromCGRect([parent convertRect:host.bounds fromView:host])]);
    }
    self.launcherHost = host;
    self.homeButton.center = [host convertPoint:center fromView:parent];
    [self raiseLauncher];
    if ([self atHomeScreen]) [self installIconLongPress];
    [self ahApplyCurrentStateToView:self.homeButton]; // [autohide] a (re)built logo takes the current fade state (design-autohide §5.1)
}

// -removeHomeButton (0x434a8) VERIFIED (remediation,
// rem_stub_removeHomeButton.txt): also resets the launcher bookkeeping
// (the dockShift reset goes through the custom setter, un-shifting the
// dock view).
- (void)removeHomeButton {
    [self.homeButton removeFromSuperview];
    self.homeButton = nil;
    self.lastLauncherCalc = 0;
    [self setDockShift:0];
}

// -homeButtonTapped (0x43514) VERIFIED (remediation,
// rem_stub_homeButtonTapped.txt): @try wrapper over the unsafe body.
- (void)homeButtonTapped {
    [self ahNoteActivity:AHSourceHome]; // [autohide] F3 feed (design-autohide §3.2): a tap on the invisible logo is activity
    @try {
        [self homeButtonTappedUnsafe];
    } @catch (NSException *ex) {
        OMCLogWrite(@"SplitScreen", [NSString stringWithFormat:
            @"CarSplit: loi nut Split Screen %@\n%@", ex, [ex callStackSymbols]]);
    }
}

// -homeButtonTappedUnsafe (0x4360c) VERIFIED (remediation,
// rem_stub_homeButtonTappedUnsafe.txt — the previous body, an immediate
// closeGoingHome:, was wrong): with the split active the tap opens the
// layout panel to switch layouts; otherwise it opens the panel for the
// fullscreen app under the dashboard (or the home screen). An open app
// tray is collapsed instead.
- (void)homeButtonTappedUnsafe {
    NSString *app = self.active ? nil : [self fullscreenAppBundle];
    OMCLogWrite(@"SplitScreen", [NSString stringWithFormat:
        @"CarSplit: bam nut Split Screen tren dock (%@)",
        self.active ? @"dang chia -> doi bo cuc" : (app ?: @"man chinh")]);
    if (self.tray) [self collapseAppTray];
    else [self showLayoutPanelForApp:app];
}

- (void)raise { [self raiseView:self.container]; }

// -raiseView: (0x36bd8) VERIFIED (remediation, rem_stub_raiseView:.txt):
// raise a view just below the dashboard's stacked container when that
// container shares the parent, else to the very front.
- (void)raiseView:(UIView *)view {
    UIView *parent = view.superview;
    if (!parent) return;
    if ([self viewIsRaised:view]) return;
    UIView *stacked = SCPGuarded(SCPDashboardRootViewController(), @"stackedContainerView");
    if (stacked.superview == parent) [parent insertSubview:view belowSubview:stacked];
    else [parent bringSubviewToFront:view];
}

// -viewIsRaised: (0x36a18) VERIFIED (remediation,
// rem_stub_viewIsRaised:.txt): directly under the stacked container, or
// the last subview when no stacked container shares the parent.
- (BOOL)viewIsRaised:(UIView *)view {
    UIView *parent = view.superview;
    if (!parent) return NO;
    UIView *stacked = SCPGuarded(SCPDashboardRootViewController(), @"stackedContainerView");
    NSArray *subs = parent.subviews;
    if (stacked.superview == parent) {
        NSInteger i = [subs indexOfObjectIdenticalTo:view];
        NSInteger j = [subs indexOfObjectIdenticalTo:stacked];
        return i != NSNotFound && i + 1 == j;
    }
    return subs.lastObject == view;
}
// -raiseLauncher (0x42900) VERIFIED (GPT wiring audit N12): raises
// the home BUTTON, never its host. When the button's superview is the
// tab parent it goes through raiseView: (stacked-container aware);
// in any other host (e.g. the dock cluster) only a plain
// bringSubviewToFront: runs, and only when the button is not already
// the last subview. The earlier draft raised launcherHost wholesale.
- (void)raiseLauncher {
    UIView *button = self.homeButton;
    UIView *parent = button.superview;
    if (!parent) return;
    if (parent == self.tabParent) {
        [self raiseView:button];
    } else if (parent.subviews.lastObject != button) {
        [parent bringSubviewToFront:button];
    }
}
// -dockClusterInParent: (0x405fc) VERIFIED (remediation,
// rem_stub_dockClusterInParent:.txt — the return type is CGRect, not
// UIView *: the old declaration was wrong-ABI). The dock view's bounds
// in parent coordinates, with the dock's own shift (transform.ty)
// removed; CGRectNull when the dock is hidden or windowless.
- (CGRect)dockClusterInParent:(UIView *)parent {
    id root = SCPDashboardRootViewController();
    id dockVC = SCPGuarded(root, @"appDockViewController");
    UIView *dockView = SCPGuarded(dockVC, @"view");
    UIWindow *window = dockView.window;
    if (!window || dockView.isHidden) return CGRectNull;
    UIWindow *parentWindow = parent.window;
    if (!parentWindow) return CGRectNull;
    UIScreen *screen = parentWindow.screen ?: dockView.window.screen;
    if (!screen) return CGRectNull;
    CGRect rect = [dockView convertRect:dockView.bounds toCoordinateSpace:screen.coordinateSpace];
    rect.origin.y -= dockView.transform.ty;
    return [parent convertRect:rect fromCoordinateSpace:screen.coordinateSpace];
}

// -launcherCenterInParent:size:shift: (0x409b0) VERIFIED (remediation,
// rem_stub_launcherCenterInParent:size:shift:.txt — the out-parameters
// are double pointers; the old value-typed declaration was wrong-ABI).
// Computes where the Split Screen launcher button goes. The dock strip
// is the >= 30 pt gap between the dashboard content view's edge and the
// app area; without one, the button sits in the app area's top-right
// corner at 34 pt. With a strip, it docks onto the strip: its size is
// capped by the strip (min(gap - 8, 30)) and by the free vertical space
// down to a limit Y (the real Home glyph's top when that glyph hangs
// below the dock cluster, else the host's bottom minus the strip
// width), and *shift reports how far the dock cluster must be pushed up
// to clear the button. Placement changes are logged (the where string is
// kept in self.launcherWhere, which also drives corner/"bare" mode).
- (CGPoint)launcherCenterInParent:(UIView *)parent size:(double *)outSize shift:(double *)outShift {
    id root = SCPDashboardRootViewController();
    UIView *content = SCPGuarded(root, @"contentView");
    UIView *hostView = content ?: [root view];
    CGRect hostRect = [parent convertRect:hostView.bounds fromView:hostView];
    CGRect appArea = [self appAreaInParent:parent];
    double appMinX = CGRectGetMinX(appArea);
    double appMaxX = CGRectGetMaxX(appArea);
    double appMinY = CGRectGetMinY(appArea);
    double gapLeft = appMinX - CGRectGetMinX(hostRect);
    double gapRight = CGRectGetMaxX(hostRect) - appMaxX;
    CGRect anchorRect;
    if (gapLeft >= 30.0)
        anchorRect = CGRectMake(CGRectGetMinX(hostRect), CGRectGetMinY(hostRect), gapLeft, hostRect.size.height);
    else if (gapRight >= 30.0)
        anchorRect = CGRectMake(appMaxX, CGRectGetMinY(hostRect), gapRight, hostRect.size.height);
    else
        anchorRect = CGRectNull;
    CGRect cluster = CGRectNull;
    CGRect glyphRect = CGRectNull;
    NSString *where = @"goc tren phai vung app (khong co dock doc)";
    double centerX = appMaxX - 25;
    double centerY = appMinY + 25;
    double size = 34.0;
    double shiftAmt = 0;
    if (!CGRectIsNull(anchorRect)) {
        double gap = anchorRect.size.width;
        double cap = MIN(gap - 8, 30.0);
        centerX = CGRectGetMidX(anchorRect);
        cluster = CGRectIntersection([self dockClusterInParent:parent], anchorRect);
        id dockVC = SCPGuarded(root, @"appDockViewController");
        UIView *dockView = SCPGuarded(dockVC, @"view");
        UIView *glyphHost = dockView.window ?: [root view];
        UIView *foundView = nil;
        SCPFindHomeGlyph(glyphHost, parent, 0, self.homeButton, anchorRect, &glyphRect, &foundView);
        self.homeGlyph = glyphRect;
        double baseline = CGRectGetMinY(anchorRect) + 34;
        SCPScanStatusBarBaseline(glyphHost, parent, 0, anchorRect, &baseline);
        double clusterBottom = CGRectIsNull(cluster) ? baseline : CGRectGetMaxY(cluster);
        double clusterTop = CGRectIsNull(cluster) ? baseline : CGRectGetMinY(cluster);
        double limit;
        if (!CGRectIsNull(glyphRect) && CGRectGetMinY(glyphRect) > clusterBottom)
            limit = CGRectGetMinY(glyphRect);
        else
            limit = CGRectGetMaxY(anchorRect) - gap;
        double overlap = CGRectIsNull(cluster) ? 0 : MAX(clusterTop - (baseline + 4), 0);
        double avail = (limit - 4) - (clusterBottom - overlap + 4);
        if (avail < 22) {
            where = @"goc tren phai vung app (dock khong con cho)";
            centerX = appMaxX - 25;
            centerY = appMinY + 25;
            size = 34.0;
            shiftAmt = 0;
        } else {
            size = MIN(cap, floor(avail));
            shiftAmt = CGRectIsNull(cluster) ? 0
                       : MAX(clusterBottom + 4 + size - (limit - 4), 0);
            centerY = (limit - 4) - size / 2;
            where = [NSString stringWithFormat:@"tren nut Home, %.0fpt%@",
                        size, shiftAmt > 0 ? @" (day cum icon len)" : @""];
        }
    }
    if (![self.launcherWhere isEqualToString:where]) {
        self.launcherWhere = where;
        OMCLogWrite(@"SplitScreen", [NSString stringWithFormat:
            @"CarSplit: nut Split Screen dat %@ | dai dock=%@ cum icon=%@ nut Home=%@ day len %.1f",
            where, NSStringFromCGRect(anchorRect), NSStringFromCGRect(cluster),
            NSStringFromCGRect(glyphRect), shiftAmt]);
    }
    if (outSize) *outSize = size;
    if (outShift) *outShift = shiftAmt;
    return CGPointMake(centerX, centerY);
}

// -setDockShift: (0x426f8) VERIFIED (remediation,
// rem_stub_setDockShift:.txt): this is a CUSTOM setter with no storage —
// it shifts the dock view up by `shift` points via its transform
// (identity when shift <= 0), applying only on change.
- (void)setDockShift:(CGFloat)shift {
    id root = SCPDashboardRootViewController();
    id dockVC = SCPGuarded(root, @"appDockViewController");
    if (!dockVC) return;
    UIView *dockView = SCPGuarded(dockVC, @"view");
    if (!dockView) return;
    CGAffineTransform t = shift > 0 ? CGAffineTransformMakeTranslation(0, -shift)
                                    : CGAffineTransformIdentity;
    if (!CGAffineTransformEqualToTransform(dockView.transform, t))
        dockView.transform = t;
}

// -dockHostForRect:inParent: (0x42a64) VERIFIED (remediation,
// rem_stub_dockHostForRect:inParent:.txt — replaces a nil stub): walk
// up from the dock view to the first ancestor whose screen-space rect
// contains the (0.5 pt-grown) target rect; give up (nil) at a window, at
// the parent itself, or when an ancestor is wider than half the parent.
// Also runs a one-time dock-tree diagnostic (SCPDumpDockTree) when the
// dock is much shorter than the parent.
- (UIView *)dockHostForRect:(CGRect)rect inParent:(UIView *)parent {
    id root = SCPDashboardRootViewController();
    id dockVC = SCPGuarded(root, @"appDockViewController");
    UIView *dockView = SCPGuarded(dockVC, @"view");
    UIWindow *dockWindow = dockView.window;
    if (!dockWindow) return nil;
    UIWindow *parentWindow = parent.window;
    if (!parentWindow) return nil;
    UIScreen *screen = parentWindow.screen ?: dockView.window.screen;
    if (!screen) return nil;
    CGRect rectScr = [parent convertRect:rect toCoordinateSpace:screen.coordinateSpace];
    CGRect parentScr = [parent convertRect:parent.bounds toCoordinateSpace:screen.coordinateSpace];
    double halfParentW = parentScr.size.width * 0.5;
    UIView *host = nil;
    UIView *v = dockView;
    while (v) {
        if ([v isKindOfClass:[UIWindow class]] || v == parent) { host = nil; break; }
        CGRect vScr = [v convertRect:v.bounds toCoordinateSpace:screen.coordinateSpace];
        if (vScr.size.width > halfParentW) { host = nil; break; }
        if (CGRectContainsRect(CGRectInset(vScr, -0.5, -0.5), rectScr)) { host = v; break; }
        v = v.superview;
    }
    if (!self.dockTreeLogged &&
        dockView.bounds.size.height < parentScr.size.height * 0.9) {
        self.dockTreeLogged = YES;
        UIView *dv = dockView;
        while (dv.superview) {
            UIView *sup = dv.superview;
            if ([sup isKindOfClass:[UIWindow class]]) break;
            if (sup == parent) break;
            CGRect supScr = [sup convertRect:sup.bounds toCoordinateSpace:screen.coordinateSpace];
            if (supScr.size.width > halfParentW) break;
            dv = sup;
        }
        NSMutableString *s = [NSMutableString string];
        SCPDumpDockTree(dockView, dockView, 0, s);
        OMCLogWrite(@"SplitScreen", [NSString stringWithFormat:@"DIAG cay dai dock:\n%@", s]);
    }
    return host;
}
// Icon long-press group (remediation: all four line-read,
// rem_stub_installIconLongPress.txt, rem_stub_installLongPressIn:depth:.txt,
// rem_stub_iconLongPressed:.txt, rem_stub_iconLongPressedUnsafe:.txt —
// replaces empty stubs). The two walker helpers live in SplitScreenC's
// SCPCarApps.m (sub_44a54 / sub_44b5c) as file-local statics in the
// current tree; they are declared extern here because the binary has a
// single shared copy — the coordinator must drop the `static` on the C
// definitions for this file to link.
extern id _Nullable SCPWalkerSafeGet(id _Nullable obj, NSString *name);
extern NSString *_Nullable SCPWalkerIconBundleID(id icon);

// -installIconLongPress (0x440e0) VERIFIED: throttled to one scan per
// 2 s; walks every window of every window scene.
- (void)installIconLongPress {
    CFAbsoluteTime now = CFAbsoluteTimeGetCurrent();
    if (now - self.lastIconScan < 2.0) return;
    self.lastIconScan = now;
    for (UIScene *scene in [UIApplication sharedApplication].connectedScenes) {
        if (![scene isKindOfClass:[UIWindowScene class]]) continue;
        for (UIWindow *window in ((UIWindowScene *)scene).windows)
            [self installLongPressIn:window depth:0];
    }
}

// -installLongPressIn:depth: (0x44344) VERIFIED: recursive view walk
// (depth cap 14, never into the split container); every *IconListView
// gets one 0.7 s long-press recognizer, marked by an associated object
// (the binary uses the address of a file-static byte as the key; a named
// static is the source equivalent).
- (void)installLongPressIn:(UIView *)view depth:(NSInteger)depth {
    static const char kSCPIconLongPressInstalledKey;
    if (!view || depth > 14) return;
    if (view == self.container) return;
    if ([NSStringFromClass(view.class) hasSuffix:@"IconListView"]) {
        if (objc_getAssociatedObject(view, &kSCPIconLongPressInstalledKey)) return;
        UILongPressGestureRecognizer *press = [[UILongPressGestureRecognizer alloc]
            initWithTarget:self action:@selector(iconLongPressed:)];
        press.minimumPressDuration = 0.7;
        [view addGestureRecognizer:press];
        objc_setAssociatedObject(view, &kSCPIconLongPressInstalledKey,
                                 (id)kCFBooleanTrue, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        OMCLogWrite(@"SplitScreen", [NSString stringWithFormat:
            @"CarSplit: gan giu icon vao %@", NSStringFromClass(view.class)]);
        return;
    }
    for (UIView *sub in view.subviews)
        [self installLongPressIn:sub depth:depth + 1];
}

// -iconLongPressed: (0x44620) VERIFIED: @try wrapper over the unsafe body.
- (void)iconLongPressed:(id)gesture {
    @try {
        [self iconLongPressedUnsafe:gesture];
    } @catch (NSException *ex) {
        OMCLogWrite(@"SplitScreen", [NSString stringWithFormat:
            @"CarSplit: loi giu icon %@\n%@", ex, [ex callStackSymbols]]);
    }
}

// -iconLongPressedUnsafe: (0x44738) VERIFIED: on Began only, inactive
// split, tweak enabled — hit-test the icon list, walk up from the hit
// view to the list's superview resolving the icon's bundle ID through
// the walker helpers; a CarPlay-capable app opens the layout panel, any
// other resolved app gets the "can't be split" toast.
- (void)iconLongPressedUnsafe:(id)gesture {
    UILongPressGestureRecognizer *press = gesture;
    if (press.state != UIGestureRecognizerStateBegan) return;
    if (self.active) return;
    if (![SCPPrefs enabled]) return;
    UIView *hit = [press.view hitTest:[press locationInView:press.view] withEvent:nil];
    NSString *bundle = nil;
    UIView *stop = press.view.superview;
    for (UIView *v = hit; v && v != stop; v = v.superview) {
        if (bundle) break;
        id icon = SCPWalkerSafeGet(v, @"icon");
        if (icon) bundle = SCPWalkerIconBundleID(icon);
    }
    if (bundle && [self isCarPlayApp:bundle]) {
        OMCLogWrite(@"SplitScreen", [NSString stringWithFormat:
            @"CarSplit: giu icon %@ -> bang bo cuc", bundle]);
        [self showLayoutPanelForApp:bundle];
        return;
    }
    OMCLogWrite(@"SplitScreen", [NSString stringWithFormat:
        @"CarSplit: giu icon %@ -> khong chia man duoc", bundle]);
    if (bundle) [self toast:OMCTr(@"App này không chia màn hình được", @"This app can't be split")];
}

// -tabParent (0x366dc) VERIFIED (remediation, rem_stub_tabParent.txt —
// the old body returned container.superview): the dashboard's base
// container's superview, falling back to the root's own view.
- (UIView *)tabParent {
    id root = SCPDashboardRootViewController();
    UIView *base = SCPGuarded(root, @"baseContainerView");
    return base.superview ?: [root view];
}

// -fullscreenAppBundle (0x367f0) VERIFIED (remediation,
// rem_stub_fullscreenAppBundle.txt — the old body missed the solo
// shortcut and the adoptable gate): the solo hosted bundle wins;
// otherwise the current base VC's bundle, only when it is adoptable.
- (NSString *)fullscreenAppBundle {
    if (self.soloHostedBundle) return self.soloHostedBundle;
    UIViewController *base = SCPCurrentBaseViewController(self);
    if (!base || ![self isAdoptableViewController:base]) return nil;
    id appInfo = SCPGuarded(base, @"applicationInfo");
    id proxyInfo = SCPGuarded(base, @"proxyApplicationInfo");
    return SCPRealBundleForInfos(appInfo, proxyInfo);
}

// Pane menu actions (solo / background / close) — remediation: all six
// line-read (rem_stub_paneSolo:.txt, rem_stub_runSoloForPane:.txt,
// rem_stub_paneBackground:.txt, rem_stub_runBackgroundForPane:.txt,
// rem_stub_paneClose:.txt, rem_stub_runCloseForPane:.txt). The entry
// points take the tapped VIEW (they are button actions — see
// SCPCarSplit+Chrome.m's addTarget registrations), resolve the pane via
// paneForView:, and wrap the run* call in @try/@catch with a log line.
// The previous INFERRED dispatchers (pane-typed args, hostSolo/detach
// one-liners) were wrong.

// -paneSolo: (0x287b8) VERIFIED.
- (void)paneSolo:(UIView *)view {
    @try {
        SCPCarPane *pane = [self paneForView:view];
        if (pane) [self runSoloForPane:pane];
    } @catch (NSException *ex) {
        OMCLogWrite(@"SplitScreen", [NSString stringWithFormat:
            @"CarSplit: loi nut chay 1 man hinh %@", ex]);
    }
}

// -runSoloForPane: (0x288c0) VERIFIED: hide the bar; in a multi-pane
// split this is the zoom toggle; for a lone/float pane it keeps only
// this app (solo).
- (void)runSoloForPane:(SCPCarPane *)pane {
    [self setBarVisible:NO forPane:pane];
    if (pane != self.floatPane && self.paneCount >= 2) {
        [self toggleZoomForPane:pane];
        return;
    }
    OMCLogWrite(@"SplitScreen", [NSString stringWithFormat:
        @"CarSplit: [chay 1 man hinh] o %d -> chi giu %@", (int)pane.slot, pane.bundleID]);
    [self soloBundle:pane.bundleID];
}

// -paneBackground: (0x28a30) VERIFIED.
- (void)paneBackground:(UIView *)view {
    @try {
        SCPCarPane *pane = [self paneForView:view];
        if (pane) [self runBackgroundForPane:pane];
    } @catch (NSException *ex) {
        OMCLogWrite(@"SplitScreen", [NSString stringWithFormat:
            @"CarSplit: loi nut chay nen %@", ex]);
    }
}

// -runBackgroundForPane: (0x28b38) VERIFIED: hide the bar, close the
// slot into the background, then show the background toast.
- (void)runBackgroundForPane:(SCPCarPane *)pane {
    NSString *bundle = pane.bundleID;
    NSInteger slot = pane.slot;
    [self setBarVisible:NO forPane:pane];
    OMCLogWrite(@"SplitScreen", [NSString stringWithFormat:
        @"CarSplit: [chay nen] o %d (%@)", (int)slot, bundle]);
    [self closeSlot:slot background:YES];
    if (bundle) [self showBackgroundToastFor:bundle slot:slot];
}

// -paneClose: (0x2a0e0) VERIFIED.
- (void)paneClose:(UIView *)view {
    @try {
        SCPCarPane *pane = [self paneForView:view];
        if (pane) [self runCloseForPane:pane];
    } @catch (NSException *ex) {
        OMCLogWrite(@"SplitScreen", [NSString stringWithFormat:
            @"CarSplit: loi nut dong %@", ex]);
    }
}

// -runCloseForPane: (0x2a1e8) VERIFIED: hide the bar, close the slot
// into the background, then schedule the app's full termination.
- (void)runCloseForPane:(SCPCarPane *)pane {
    NSString *bundle = pane.bundleID;
    [self setBarVisible:NO forPane:pane];
    [self closeSlot:pane.slot background:YES];
    OMCLogWrite(@"SplitScreen", [NSString stringWithFormat:
        @"CarSplit: [tat han app] %@", bundle]);
    if (bundle) [self killAppSoon:bundle];
}

@end

// [phase2; backported to src in phase 3] SCPCarPane has no behaviour
// methods in the binary — all 37 of its methods are synthesized
// accessors (see SCPCarPane.h) — so an empty implementation is the
// faithful reconstruction; phase 2 added it in the project copy only
// and verified the class + accessors in the built dylib.
@implementation SCPCarPane
@end
