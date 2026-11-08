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
#import <objc/message.h>

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

// -activateWithLayout: INFERRED: same entry as activateWithCount: with the
// layout preset first (its body parallels activateWithCount: and is called
// by openSetupLayout:apps: between setSuppressReopen: toggles).
- (BOOL)activateWithLayout:(NSInteger)layout {
    self.layoutKind = layout;
    return [self activateWithCount:2];
}

// -activateWithCount: (0x15cdc) VERIFIED (control flow read end-to-end;
// the one bit-level subtlety is marked INFERRED inline).
- (BOOL)activateWithCount:(NSInteger)count {
    if (![SCPPrefs enabled]) return NO;
    [self removeAppTab];
    if (self.active) {
        if (self.container.superview) { [self raise]; return YES; }
    }
    UIViewController *currentBase = SCPCurrentBaseViewController(self);
    // Decide whether the currently fullscreen app should be re-opened into
    // the left pane: proven inputs are currentBase, self.suppressReopen,
    // isAdoptableViewController:, and the bundle resolved through
    // SCPRealBundleForInfos(appInfo, proxyInfo). INFERRED exact predicate
    // shape (a csinc on suppressReopen in the disassembly): reopen happens
    // when a base VC exists and suppressReopen is NO.
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
    self.focusedSlot = 0;
    [self publishBusy];
    [self.pending removeAllObjects];
    self.layoutKind = 0;
    [self setPaneCount:count];
    OMCLogWrite(@"SplitScreen", [NSString stringWithFormat:@"CarSplit: bat split CarPlay (%d o)", (int)self.paneCount]);
    [self showTipSoon];
    [self relayoutAnimated:NO];
    // Entry animation (VERIFIED): container starts invisible + scaled
    // (scale constants in __const, ~0.9) and springs in via
    // animateWithDuration:delay:usingSpringWithDamping:initialSpringVelocity:
    // (duration/damping/velocity constants in __const, not decoded to exact
    // values — INFERRED standard 0.35/0.85/0.0).
    self.container.alpha = 0;
    self.container.transform = CGAffineTransformMakeScale(0.92, 0.92);
    [UIView animateWithDuration:0.35 delay:0 usingSpringWithDamping:0.85
          initialSpringVelocity:0 options:0 animations:^{
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

// -autoLaunchAttempt: VERIFIED (skeleton): retry loop until the dashboard
// root exists, then restore. Delays proven: 1.0 s then 1.5 s steps.
- (void)autoLaunchAttempt:(NSInteger)attempt {
    if (self.active) return;
    if (SCPDashboardRootViewController()) {
        [self openRememberedPairForConnect];
        return;
    }
    double delay = attempt == 0 ? 1.0 : 1.5;   // both constants VERIFIED in body
    __weak SCPCarSplit *weakSelf = self;
    SCPDispatchAfter(delay, ^{ [weakSelf autoLaunchAttempt:attempt + 1]; });
}

// -rootDidLayout VERIFIED: publish busy state; while active, follow the
// dashboard's app-area: when the container's frame no longer matches
// appAreaInParent:, log + resize + relayout.
- (void)rootDidLayout {
    [self publishBusy];
    if (!self.active || !self.container.superview) return;
    [self refreshHomeButton];
    UIView *parent = self.container.superview;
    CGRect area = [self appAreaInParent:parent];
    if (!CGRectEqualToRect(area, self.container.frame)) {
        OMCLogWrite(@"SplitScreen", [NSString stringWithFormat:@"CarSplit: vung app doi %@ -> %@",
            NSStringFromCGRect(self.container.frame), NSStringFromCGRect(area)]);
        self.container.frame = area;
        [self relayoutAnimated:NO];
    }
    [self refreshAppTab];
}

// -baseViewControllerPresented VERIFIED: a fullscreen app took over while a
// hosted app was solo -> end the solo session; dismiss the solo cover
// shortly after (deferred via SCPDispatchAfter; exact delay in the block
// setup, INFERRED 0.3 s).
- (void)baseViewControllerPresented {
    [self endHostedSolo];
    if (self.soloCover) {
        __weak SCPCarSplit *weakSelf = self;
        SCPDispatchAfter(0.3, ^{ [weakSelf hideSoloCover]; });
    }
}

// -dashboardInvalidated VERIFIED: the disconnect/teardown path driven by
// the DBDashboard -invalidate hook. Tears down every piece of session UI
// and state; safe to call when inactive (the split-specific part is
// guarded by self.active in the original).
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
        self.active = NO;
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
        self.dragTarget = 0;
        [self.ratioMenu removeFromSuperview];
        [self.ratioTimer invalidate];
        self.ratioTimer = nil;
        self.ratioMenu = nil;
        self.resizing = NO;
        [self.container removeFromSuperview];
        self.container = nil;
    }
}

// -ensureContainer VERIFIED: attach (once) the SCPCarSplitView into the
// dashboard root's baseContainerView.
- (BOOL)ensureContainer {
    if (self.container.superview) return YES;
    id root = SCPDashboardRootViewController();
    if (!root) {
        OMCLogWrite(@"SplitScreen", @"CarSplit: chua co DBDashboardRootViewController (xe chua ket noi?)");
        return NO;
    }
    UIView *base = SCPGuarded(root, @"baseContainerView");
    if (!self.container) {
        SCPCarSplitView *view = [[SCPCarSplitView alloc] initWithFrame:base.bounds];
        view.backgroundColor = [UIColor blackColor];
        view.clipsToBounds = YES;
        self.container = view;
        if (!_slots) _slots = [NSMutableArray array];
        if (!_fractions) _fractions = [NSMutableArray array];
    }
    // The original also flags the container as touched (setTouched: in the
    // call list — a SCPCarSplitView property of agent B's class).
    [base addSubview:self.container];
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
    return slot == 9 || (slot >= 0 && slot < self.paneCount);
}

- (SCPCarPane *)paneForBundle:(NSString *)bundleID {
    if (!bundleID) return nil;
    for (SCPCarPane *pane in [self allPanes])
        if ([pane.bundleID isEqualToString:bundleID]) return pane;
    return nil;
}

- (SCPCarPane *)paneForView:(UIView *)view {
    for (SCPCarPane *pane in [self allPanes])
        if (pane.view == view || pane.host == view) return pane;
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

- (BOOL)slotOccupied:(NSInteger)slot {
    SCPCarPane *pane = [self paneAtSlot:slot];
    return pane.vc != nil || [self pendingSlotForBundle:pane.bundleID] >= 0;
}

- (NSInteger)paneCount { return (NSInteger)self.slots.count; }

// -autoSlot INFERRED (from openApp:/adopt call sites): first slot with no
// VC and no pending launch; 9 (the float slot) when every pane is taken.
- (NSInteger)autoSlot {
    for (NSInteger i = 0; i < self.paneCount; i++)
        if (![self slotOccupied:i]) return i;
    return 9;
}

// -markDismissSlot: INFERRED: records a cancellation so a late-arriving VC
// for that slot's bundle is backgrounded by adoptViewController: (the
// cancelledLaunches dictionary + 30 s window are VERIFIED there).
- (void)markDismissSlot:(NSInteger)slot {
    SCPCarPane *pane = [self paneAtSlot:slot];
    if (pane.bundleID) self.cancelledLaunches[pane.bundleID] = [NSDate date];
}

#pragma mark - App identity

// -isCarPlayApp: VERIFIED (call order): installed (sub_e324) AND has a
// CarPlay interface (sub_ffb4 — INFERRED: checks the app info's CarPlay
// scene/role keys), OR hosted through AppBridge (sub_101bc).
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
    id workspace = SCPGuarded([NSClassFromString(@"LSApplicationWorkspace") new], @"defaultWorkspace");
    SEL proxySel = NSSelectorFromString(@"applicationProxyForIdentifier:");
    id proxy = nil;
    if ([workspace respondsToSelector:proxySel])
        proxy = ((id (*)(id, SEL, id))objc_msgSend)(workspace, proxySel, bundleID);
    else
        SCPMissingSelector(workspace, NSStringFromSelector(proxySel));
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
        [self toast:OMCTr(@"A", @"This app doesn't support CarPlay")];
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
                [self toast:OMCTr(@"�", @"This pane is pinned")];
                return;
            }
            OMCLogWrite(@"SplitScreen", [NSString stringWithFormat:
                @"CarSplit: o %d dang ghim -> mo %@ vao o %d", (int)slot, bundleID, (int)alt]);
            slot = alt;
        }
        fresh = YES;
    } else if (existing.slot == slot || existing.slot == 9 || slot == 9) {
        [self toast:[NSString stringWithFormat:OMCTr(@"%", @"%@ is already open in %@"),
                     [self displayNameFor:bundleID],
                     existing.slot == 9 ? OMCTr(@"c", @"the floating window")
                                        : OMCTr(@"�", @"another pane")]];
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

    id launchInfo = OMCCarLaunchInfo(bundleID);
    // Launch throttle (VERIFIED arithmetic): launches are spaced by a
    // per-launch interval kept in nextLaunchAt (constant at 0x6f0a0 in
    // __const, INFERRED 0.35 s); wait = max(0, nextLaunchAt - now).
    CFAbsoluteTime now = CFAbsoluteTimeGetCurrent();
    double wait = MAX(0, self.nextLaunchAt - now);
    self.nextLaunchAt = now + wait + 0.35;
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
// real bundle matches. Retries every 2.0 s while attempt < 2 (log:
// "CarSplit: %@ chua toi sau %ds, doi them"); on success logs
// "CarSplit: DashBoard khong trinh bay %@ -> lay VC co san".
- (void)recoverPending:(NSString *)bundleID attempt:(NSInteger)attempt {
    if (!self.active) return;
    if ([self pendingSlotForBundle:bundleID] < 0) return;
    id owner = SCPGuarded(SCPDashboardObject(), @"workspaceOwner");
    NSDictionary *map = SCPGuarded(owner, @"_entityIdentifierToViewControllerMap");
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
    if (attempt < 2) {
        OMCLogWrite(@"SplitScreen", [NSString stringWithFormat:
            @"CarSplit: %@ chua toi sau %ds, doi them", bundleID, (int)(attempt + 1) * 2]);
        __weak SCPCarSplit *weakSelf = self;
        SCPDispatchAfter(2.0, ^{ [weakSelf recoverPending:bundleID attempt:attempt + 1]; });
    }
}

// -launchFailed:slot: VERIFIED: drop the pending entry and the loader
// (matched by accessibilityIdentifier == bundleID); show the picker again
// when the slot is free; relayout.
- (void)launchFailed:(NSString *)bundleID slot:(NSInteger)slot {
    [self.pending removeObjectForKey:bundleID];
    for (SCPCarPane *pane in [self allPanes]) {
        if (pane.slot == slot && [pane.loader.accessibilityIdentifier isEqualToString:bundleID])
            [self removeLoaderFromPane:pane animated:YES];
        if (pane.slot == slot && ![self slotOccupied:slot])
            [self showPickerForSlot:slot];
    }
    [self relayoutAnimated:YES];
}

// -killAppSoon: VERIFIED (skeleton): for a non-empty bundle, schedule the
// splitscreen.kill distributed post (the SpringBoard side terminates the
// app — see SCPSpringBoardHooks.m). The delay sits in the block setup;
// INFERRED 1.0 s.
- (void)killAppSoon:(NSString *)bundleID {
    if (!bundleID.length) return;
    SCPDispatchAfter(1.0, ^{
        [[NSDistributedNotificationCenter defaultCenter]
            postNotificationName:SCPNoteKillApp object:nil
                        userInfo:@{@"identifier": bundleID}];
    });
}

#pragma mark - Pairs, layouts, restore

// -openPairLeft:right: VERIFIED.
- (void)openPairLeft:(NSString *)left right:(NSString *)right {
    OMCLogWrite(@"SplitScreen", [NSString stringWithFormat:@"CarSplit: mo cap left=%@ right=%@", left, right]);
    if (!self.active) {
        [self setPaneCount:2];
        [self activateWithCount:2];
    }
    double ratio = [SCPPrefs ratioForPairLeft:left right:right];
    self.fractions = [@[@(ratio), @(1.0)] mutableCopy];
    [self openAppsInOrder:@[left ?: (id)[NSNull null], right ?: (id)[NSNull null]]];
}

// -openAppsInOrder: VERIFIED (call sequence): per index — NSNull shows the
// picker; hosted apps are seeded into pending + loader first and opened
// deferred (so native scenes land first); native apps open immediately.
- (void)openAppsInOrder:(NSArray *)apps {
    NSInteger n = MIN(self.paneCount, (NSInteger)apps.count);
    for (NSInteger i = 0; i < n; i++) {
        id app = apps[i];
        if ([app isKindOfClass:[NSNull class]]) { [self showPickerForSlot:i]; continue; }
        if (SCPIsHostedApp(app)) {
            self.pending[app] = @[ @(i), [NSDate date] ];
            [self showLoaderInPane:[self paneAtSlot:i] bundle:app];
            __weak SCPCarSplit *weakSelf = self;
            SCPDispatchAfter(0.5, ^{ [weakSelf openApp:app slot:i]; }); // INFERRED stagger 0.5 s
        } else {
            [self openApp:app slot:i];
        }
    }
    [self relayoutAnimated:YES];
}

// -openSetupLayout:apps: VERIFIED.
- (void)openSetupLayout:(NSInteger)layout apps:(NSArray *)apps {
    if (self.active) {
        [self switchToLayout:layout];
    } else {
        self.suppressReopen = YES;
        [self activateWithLayout:layout];
        self.suppressReopen = NO;
    }
    if (apps.count >= 2) {
        double ratio = [SCPPrefs ratioForPairLeft:apps[0] right:apps[1]];
        self.fractions = [@[@(ratio), @(1.0)] mutableCopy];
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

// -rememberRecent INFERRED: snapshots the current layout + apps into
// SCPPrefs recent layouts (called from adopt:slot: after every successful
// placement). Body not individually read; contract from call sites +
// SCPPrefs.addRecentLayout:apps:.
- (void)rememberRecent {
    NSMutableArray *apps = [NSMutableArray array];
    for (SCPCarPane *pane in self.slots) [apps addObject:pane.bundleID ?: @""];
    [SCPPrefs addRecentLayout:self.layoutKind apps:apps];
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
        [self toast:[NSString stringWithFormat:OMCTr(@"%", @"%@ replaced %@ in pane %d"),
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
    for (SCPCarPane *other in [self allPanes]) {
        if (other == pane || !other.vc) continue;
        if ([other.bundleID isEqualToString:bundle]) {
            [self detachVC:other.vc background:NO];
            other.vc = nil; other.bundleID = nil; other.sceneSize = CGSizeZero;
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
    pane.sceneSize = CGSizeZero;   // VERIFIED: zeroed at adopt; filled by verifySceneOfPane:
    self.focusedSlot = (int)slot;
    [self removeLoaderFromPane:pane animated:YES];
    OMCLogWrite(@"SplitScreen", [NSString stringWithFormat:
        @"CarSplit: dua %@ (%@) vao o %d", bundle, NSStringFromClass([vc class]), (int)slot]);
    [self rememberPair];
    [self rememberRecent];
    [self raise];
    [self relayoutAnimated:YES];
    [self verifySceneOfPane:pane expected:pane.sceneSize retry:2];
}

// -detachVC:background: VERIFIED (call sequence): the deliberate-background
// path raises allowBackground (a counter) around the private
// backgroundSceneWithCompletion: call so the protection hooks let it
// through exactly once.
- (void)detachVC:(UIViewController *)vc background:(BOOL)background {
    @try {
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
        // sub_1a1b8 INFERRED: resets the detached view's geometry (frame/
        // transform) to the dashboard's fullscreen defaults.
        extern BOOL SCPResetDetachedView(UIView *view, NSInteger depth); // [phase2; backported to src in phase 3] dump 0x1a1b8: returns BOOL, 2nd arg is a recursion depth (cap 4); A's NO == depth 0
        SCPResetDetachedView(vc.view, NO);
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

// -scene:destroyedForViewController:ownScene: VERIFIED (call sequence):
// match the destroyed scene to the pane whose VC is the method's VC
// argument; the pane's own scene dying closes the pane ("app thoat/crash"),
// a foreign scene leaves the pane alone. The micro-closure's call-site
// read (@0x1ae28-0x1ae94) is explicit: sub_1b13c is called on the destroyed
// scene and on ownScene — never on pane.vc — and a match is ownScene ==
// scene by pointer OR the two returned identifiers being equal.
- (void)scene:(id)scene destroyedForViewController:(UIViewController *)vc ownScene:(id)ownScene {
    NSString *destroyedID = nil;
    for (SCPCarPane *pane in [self allPanes]) {
        if (pane.vc != vc) continue;
        destroyedID = SCPSceneIdentifierOfVC(scene);
        NSString *paneSceneID = SCPSceneIdentifierOfVC(ownScene);
        if ((ownScene && ownScene == scene) ||
            (destroyedID && [paneSceneID isEqualToString:destroyedID])) {
            OMCLogWrite(@"SplitScreen", [NSString stringWithFormat:
                @"CarSplit: scene cua %@ bi huy (app thoat/crash) -> dong ngan %d",
                pane.bundleID, (int)pane.slot]);
            NSInteger slot = pane.slot;
            __weak SCPCarSplit *weakSelf = self;
            SCPDispatchAfter(0.5, ^{ [weakSelf closeSlot:slot background:NO]; }); // INFERRED delay
            return;
        }
    }
    OMCLogWrite(@"SplitScreen", [NSString stringWithFormat:
        @"CarSplit: scene %@ bi huy khong phai cua %@ (%@) -> giu ngan", destroyedID,
        [self paneForBundle:nil].bundleID, vc]);   // INFERRED formatting of the keep-case log
}

// -verifySceneOfPane:expected:retry: VERIFIED (call sequence): reads the
// scene's settings frame (valueForKey "settings" -> "frame" via the scene
// walk) and compares against the expected size with a 2 pt tolerance;
// retries after 2.0 s while retry > 0, logging "-> van sai" when it stays
// wrong and "CarSplit: khong doc duoc kich thuoc scene %@" when unreadable.
- (void)verifySceneOfPane:(SCPCarPane *)pane expected:(CGSize)expected retry:(NSInteger)retry {
    if (!self.active || !pane.vc) return;
    id scene = SCPSceneOfVC(pane.vc);
    id settings = SCPGuarded(scene, @"settings");
    NSValue *frameValue = SCPGuarded(settings, @"frame");
    if (!frameValue) {
        OMCLogWrite(@"SplitScreen", [NSString stringWithFormat:
            @"CarSplit: khong doc duoc kich thuoc scene %@", pane.bundleID]);
        return;
    }
    CGSize actual = [frameValue CGRectValue].size;
    if (fabs(actual.width - expected.width) <= 2.0 && fabs(actual.height - expected.height) <= 2.0)
        return;
    if (retry > 0) {
        __weak SCPCarSplit *weakSelf = self;
        SCPDispatchAfter(2.0, ^{ [weakSelf verifySceneOfPane:pane expected:expected retry:retry - 1]; });
    } else {
        OMCLogWrite(@"SplitScreen", [NSString stringWithFormat:
            @"CarSplit: kich thuoc scene %@ %@ -> van sai", pane.bundleID, NSStringFromCGSize(actual)]);
    }
    pane.sceneSize = actual;
}

// -paneSize:forBundle: VERIFIED (call sequence): the size the scene-frame
// hook answers with — the container's frame for the bundle's (pending)
// slot; CGSizeZero when the split is inactive or the app has no slot.
- (CGSize)paneSize:(CGRect)frame forBundle:(NSString *)bundleID {
    if (!self.active || !self.container) return CGSizeZero;
    NSInteger slot = [self paneForBundle:bundleID].slot;
    if (slot < 0) slot = [self pendingSlotForBundle:bundleID];
    if (slot < 0) return CGSizeZero;
    return [self frameForSlot:slot].size; // [phase2; backported to src in phase 3] A's C placeholder was B's -frameForSlot: method (SCPCarSplit+Layout.m)
}

// -repairPresentedViewController: INFERRED: called by the delayed block in
// the presentBaseViewController hook (sub_80c4) to re-adopt a VC that the
// dashboard presented fullscreen while the split wanted it. Body not
// individually read.
- (void)repairPresentedViewController:(UIViewController *)vc {
    if ([self wantsViewController:vc]) [self adoptViewController:vc];
}

#pragma mark - Pane set mutation

// The four methods below are reconstructed from their call sites and the
// VERIFIED removePaneAt:background: sequence; individual bodies were
// skeleton-checked only (status INFERRED in the report).

- (SCPCarPane *)newPane {
    SCPCarPane *pane = [SCPCarPane new];
    pane.slot = (int)self.slots.count;
    return pane;
}

- (SCPCarPane *)insertPaneAt:(NSInteger)slot { // [phase2; backported to src in phase 3] returns the pane per binary type @20@0:8i16 (Zoom floatDockBack uses it)
    SCPCarPane *pane = [self newPane];
    [self.slots insertObject:pane atIndex:slot];
    [self.fractions insertObject:@(1.0) atIndex:slot];
    [self reindexPanes];
    return pane;
}

- (void)reindexPanes {
    NSInteger i = 0;
    for (SCPCarPane *pane in self.slots) pane.slot = (int)i++;
}

- (void)setPaneCount:(NSInteger)count {
    while ((NSInteger)self.slots.count < count) [self insertPaneAt:self.slots.count];
    while ((NSInteger)self.slots.count > count)
        [self removePaneAt:self.slots.count - 1 background:NO];
    [self normalizeFractions];
}

- (void)swapSlot:(NSInteger)a with:(NSInteger)b {
    if (a == b) return;
    [self.slots exchangeObjectAtIndex:a withObjectAtIndex:b];
    [self reindexPanes];
}

// -removePaneAt:background: VERIFIED (call sequence).
- (void)removePaneAt:(NSInteger)slot background:(BOOL)background {
    if (slot < 0 || slot >= self.paneCount) return;
    SCPCarPane *pane = self.slots[slot];
    if (SCPVCIsHosted(pane.vc))
        [self hostClose:pane.bundleID terminate:NO];
    [pane.barTimer invalidate];
    pane.barTimer = nil;
    [self removePickerFromPane:pane];
    if (pane.vc) {
        if (!SCPVCIsHosted(pane.vc)) [self detachVC:pane.vc background:background];
        pane.vc = nil;
        pane.bundleID = nil;
    }
    [pane.view removeFromSuperview];
    if (self.layoutKind > 0) self.layoutKind -= 1;   // INFERRED adjustment seen in the call list
    [self.slots removeObjectAtIndex:slot];
    if (slot < (NSInteger)self.fractions.count) [self.fractions removeObjectAtIndex:slot];
    [self normalizeFractions];
    // Pending entries pointing at/behind the removed slot are dropped or
    // shifted (VERIFIED: the body re-walks self.pending by slot).
    for (NSString *bundle in [self.pending allKeys]) {
        NSInteger s = [self pendingSlotForBundle:bundle];
        if (s == slot) [self.pending removeObjectForKey:bundle];
    }
    [self reindexPanes];
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
    [self afterPaneRemoved:nil]; // [phase2; backported to src in phase 3] callee ignores the arg; binary arg type is @ (was the NSInteger slot)
}

// -afterPaneRemoved: INFERRED: when no panes remain, tear the split down;
// otherwise relayout. (Name + single call site in closeSlot:.)
- (void)afterPaneRemoved:(id)info { (void)info; // [phase2; backported to src in phase 3] binary arg type @; body never used it
    if (self.paneCount == 0) { [self closeGoingHome:NO]; return; }
    [self relayoutAnimated:YES];
}

// -switchToLayout: / -layoutID / -layoutChosenID: INFERRED: switchToLayout:
// re-derives paneCount + fractions for the layout id and relayouts (it is
// the entry used by openSetupLayout:apps: when already active). The layout
// id -> (count, fractions) table lives in agent B's geometry code.
- (void)switchToLayout:(NSInteger)layout {
    self.layoutKind = layout;
    [self relayoutAnimated:YES];
}
- (NSInteger)layoutID { return self.layoutKind; }
- (BOOL)layoutChosenID:(NSInteger)layout { return self.layoutKind == layout; }

#pragma mark - Close / home

// -closeApp: VERIFIED.
- (void)closeApp:(NSString *)bundleID {
    SCPCarPane *pane = [self paneForBundle:bundleID];
    if (self.active && pane) [self closeSlot:pane.slot background:YES];
}

// -closeGoingHome: VERIFIED (call sequence): full split teardown; goHome
// only changes the log line and whether a type-1 dashboard event follows
// (the event send itself is INFERRED from SCPSendDashboardEvent's role).
- (void)closeGoingHome:(BOOL)goHome {
    if (!self.active) return;
    OMCLogWrite(@"SplitScreen", [NSString stringWithFormat:@"CarSplit: tat split (goHome=%d)", goHome]);
    [self hostCloseAll];
    for (SCPCarPane *pane in [self allPanes]) {
        [pane.barTimer invalidate];
        pane.barTimer = nil;
        if (pane.vc) {
            if (!SCPVCIsHosted(pane.vc)) [self detachVC:pane.vc background:YES];
            pane.vc = nil;
            pane.bundleID = nil;
        }
        [pane.picker removeFromSuperview];
        pane.picker = nil;
        [self removeCoverFromPane:pane];
    }
    self.active = NO;
    [self.pending removeAllObjects];
    [self publishBusy];
    [self removePickerSheet];
    [self hideRatioMenu];
    [self cancelPaneDrag];
    self.resizing = NO;
    [self.container removeFromSuperview];
    self.container = nil;
    if (goHome) SCPSendDashboardEvent(1, @"SplitScreen: dong split");
}

// -homePressedDuringSplit: VERIFIED (call sequence): returns YES when the
// home press was consumed by the split (one-shot ignore flag, or a solo
// hosted app returning). The DBDashboard _handleHomeEvent: hook falls back
// to closeGoingHome: when this returns NO.
- (BOOL)homePressedDuringSplit:(id)event {
    (void)event;
    UIViewController *currentBase = SCPCurrentBaseViewController(self);
    if (currentBase) { [self dismissStuckBaseSoon]; return YES; }
    if (self.soloReturnedVC) {
        self.soloReturnedVC = nil;
        return YES;
    }
    if (self.ignoreHomeOnce) {
        self.ignoreHomeOnce = NO;
        return YES;
    }
    if (self.soloHostedBundle) {
        [self endHostedSolo];
        return YES;
    }
    return NO;
}

// -dismissStuckBaseSoon VERIFIED: one-shot (dismissStuckPending) deferred
// dismissal of a base VC that stayed presented over the split; the block
// re-checks currentBaseViewController and dismisses it (INFERRED interior).
- (void)dismissStuckBaseSoon {
    if (self.dismissStuckPending) return;
    self.dismissStuckPending = YES;
    __weak SCPCarSplit *weakSelf = self;
    SCPDispatchAfter(0.5, ^{
        SCPCarSplit *self = weakSelf;
        self.dismissStuckPending = NO;
        UIViewController *base = SCPCurrentBaseViewController(self);
        [base dismissViewControllerAnimated:NO completion:nil];
    });
}

// -launchPhoneAppIfNeeded: VERIFIED (call sequence): dashboard icon tap on
// a hosted (phone) app — into the split when active, otherwise solo
// fullscreen through the bridge. Returns YES when consumed.
- (BOOL)launchPhoneAppIfNeeded:(id)launchInfo {
    id appInfo = SCPGuarded(launchInfo, @"applicationInfo");
    id proxyInfo = SCPGuarded(launchInfo, @"proxyApplicationInfo");
    NSString *bundle = SCPRealBundleForInfos(appInfo, proxyInfo);
    if (!SCPIsHostedApp(bundle)) return NO;
    OMCLogWrite(@"SplitScreen", [NSString stringWithFormat:@"AppBridge: cham icon %@ tren man chinh", bundle]);
    if (self.active) {
        [self openApp:bundle slot:[self autoSlot]];
    } else if ([self.soloHostedBundle isEqualToString:bundle]) {
        [self endHostedSolo];
    } else {
        [self showSoloCoverForBundle:bundle];
        [self hostSolo:bundle];
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
}

// -hostCloseAll VERIFIED: the solo app (if any) is excepted.
- (void)hostCloseAll {
    [self hostPost:SCPNoteBridgeCloseAll
              info:@{@"except": self.soloHostedBundle ?: @""}];
}

// -hostApp:inPane: VERIFIED (call sequence): put a hosted app into a pane —
// evict the occupant, install an SCPHostedAppVC token, size it to the pane,
// show the loader, and post the open/frame state to the bridge.
- (void)hostApp:(NSString *)bundleID inPane:(SCPCarPane *)pane {
    if (pane.vc) {
        if (SCPVCIsHosted(pane.vc)) [self hostClose:pane.bundleID terminate:NO];
        else [self detachVC:pane.vc background:NO];
        pane.vc = nil;
        pane.bundleID = nil;
    }
    SCPHostedAppVC *hosted = [SCPHostedAppVC new];
    hosted.bundleID = bundleID;
    pane.vc = hosted;
    pane.bundleID = bundleID;
    pane.sceneSize = pane.host.bounds.size;
    pane.hostFrame = pane.host.bounds;
    pane.hostHandle = NO;
    self.focusedSlot = pane.slot;
    [self showLoaderInPane:pane bundle:bundleID];
    OMCLogWrite(@"SplitScreen", [NSString stringWithFormat:@"AppBridge: host %@ vao o %d", bundleID, (int)pane.slot]);
    [self sendHostFrameForPane:pane live:NO];
}

// -hostedApp:state: VERIFIED (call sequence): the bridge's state answers.
// "ready" clears the loader (and ends a solo session for that app);
// "failed" toasts "Couldn't show %@ on the car"; other states log
// "AppBridge: %@ %@ -> dong o %d" when the pane is dropped.
- (void)hostedApp:(NSString *)bundleID state:(NSString *)state {
    if ([self.soloHostedBundle isEqualToString:bundleID] && [state isEqualToString:@"ready"]) {
        OMCLogWrite(@"SplitScreen", [NSString stringWithFormat:@"AppBridge: app toan man %@ %@", bundleID, state]);
        [self endHostedSolo];
        [self hideSoloCover];
    }
    SCPCarPane *pane = [self paneForBundle:bundleID];
    if (!self.active || !pane || !SCPVCIsHosted(pane.vc)) return;
    if ([state isEqualToString:@"ready"]) {
        [self removeLoaderFromPane:pane animated:YES];
        return;
    }
    OMCLogWrite(@"SplitScreen", [NSString stringWithFormat:@"AppBridge: %@ %@ -> dong o %d", bundleID, state, (int)pane.slot]);
    if ([state isEqualToString:@"failed"]) {
        [self toast:[NSString stringWithFormat:OMCTr(@"K", @"Couldn't show %@ on the car"),
                     [self displayNameFor:bundleID]]];
    }
}

// -hostSolo: VERIFIED: run a hosted app fullscreen (over the dashboard's
// app area) — posts appbridge.open with the frame.
- (void)hostSolo:(NSString *)bundleID {
    UIView *parent = [self tabParent];
    CGRect frame = [self appAreaInParent:parent];
    frame = [parent convertRect:frame toView:nil];
    self.soloHostedBundle = bundleID;
    self.soloHostedFrame = frame;
    self.trayHidesBridge = YES;
    OMCLogWrite(@"SplitScreen", [NSString stringWithFormat:@"AppBridge: %@ toan man %@", bundleID, NSStringFromCGRect(frame)]);
    [self hostPost:SCPNoteBridgeOpen info:@{@"identifier": bundleID,
                                            @"x": @(frame.origin.x), @"y": @(frame.origin.y),
                                            @"w": @(frame.size.width), @"h": @(frame.size.height)}];
}

// -endHostedSolo VERIFIED.
- (void)endHostedSolo {
    if (!self.soloHostedBundle) return;
    OMCLogWrite(@"SplitScreen", [NSString stringWithFormat:@"AppBridge: dong app toan man %@", self.soloHostedBundle]);
    [self hostClose:self.soloHostedBundle terminate:NO];
    self.soloHostedBundle = nil;
    self.trayHidesBridge = NO;
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

// Geometry helpers for the bridge — INFERRED thin wrappers over agent B's
// layout (the frames themselves are computed by the container's layout).
- (CGRect)hostFrameForPane:(SCPCarPane *)pane { return pane.host ? pane.host.frame : CGRectZero; }
- (CGRect)holeForPane:(SCPCarPane *)pane { return pane.hostHole; }
- (NSDictionary *)hostBarInfoForPane:(SCPCarPane *)pane {
    return @{@"identifier": pane.bundleID ?: @"", @"bar": @(pane.hostBar)};
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
- (void)pushHostFramesLive:(BOOL)live {
    for (SCPCarPane *pane in [self hostedPanes]) [self sendHostFrameForPane:pane live:live];
}
// -pushSceneSizes INFERRED: pushes each hosted pane's scene size through
// the same frame channel after a layout change.
- (void)pushSceneSizes { [self pushHostFramesLive:NO]; }
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
        [self closeGoingHome:YES];
        return;
    }
    if (SCPIsHostedApp(bundleID)) {
        OMCLogWrite(@"SplitScreen", [NSString stringWithFormat:
            @"CarSplit: chi giu %@ (app iPhone) -> App Bridge toan man", bundleID]);
        [self hostSolo:bundleID];
        self.ignoreHomeOnce = YES;
        [self closeGoingHome:YES];
        self.ignoreHomeOnce = NO;
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
        [self detachVC:vc background:NO];
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
    // (OMCCarLaunchInfo takes the application-info OBJECT here, despite
    // the loose NSString* spelling in SCPShared.h.)
    id info = SCPApplicationInfoForBundle(bundleID);
    id launchInfo = OMCCarLaunchInfo(info);
    if (launchInfo) [self showSoloCoverForBundle:bundleID];
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
            else [self closeGoingHome:YES];
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

// Solo cover (the placeholder shown while a solo hosted app starts) —
// INFERRED UI glue in A's domain only as session state.
- (void)showSoloCoverForBundle:(NSString *)bundleID { (void)bundleID; }
- (void)hideSoloCover { self.soloCover = nil; }
- (void)setFullscreenBridgeHidden:(BOOL)hidden bundle:(NSString *)bundleID {
    // VERIFIED: posts an appbridge.frame update for the bundle (the name
    // appears in this method's string xrefs).
    SCPCarPane *pane = [self paneForBundle:bundleID];
    if (pane) [self sendHostFrameForPane:pane live:NO];
}

// Bridge input callbacks (posted by AppBridge, handled in SCPHooks.m
// blocks) — INFERRED thin forwarders into B's bar/handle machinery.
- (void)bridgeBarAction:(NSString *)action forBundle:(NSString *)bundleID { (void)action; (void)bundleID; }
- (void)bridgeHandleTapped:(NSDictionary *)info { (void)info; }
- (void)bridgeOutsideTouched {}
- (void)bridgeHandleDrag:(NSDictionary *)info { (void)info; }

#pragma mark - State publishing

// -publishBusy INFERRED: publishes the split busy/active state into the
// shared OMC prefs for the other modules (called from activate,
// closeGoingHome:, dashboardInvalidated, rootDidLayout). Exact key in the
// Core namespace.
- (void)publishBusy {
    extern void SCPHomePrefSet(NSString *key, id _Nullable value); // [phase2; backported to src in phase 3] name unified (sub_c4f4)
    SCPHomePrefSet(@"splitScreenActive", @(self.active));
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

// -publishKnobsSoon / -publishKnobsNow INFERRED pair: debounced vs
// immediate appbridge.knobs posts carrying the divider knob geometry
// (payload built by agent B's divider code).
- (void)publishKnobsSoon {
    __weak SCPCarSplit *weakSelf = self;
    SCPDispatchAfter(0.1, ^{ [weakSelf publishKnobsNow]; });
}
- (void)publishKnobsNow {
    [self hostPost:SCPNoteBridgeKnobs info:@{}];
}

#pragma mark - Home button / dock / launcher (lifecycle side)

// These are reconstructed at call-sequence fidelity from their call sites
// (rootDidLayout -> refreshHomeButton; dashboardInvalidated ->
// removeHomeButton) — status INFERRED in the report; the geometry helpers
// (dockClusterInParent:, launcherCenterInParent:size:shift:,
// dockHostForRect:inParent:) only had their signatures verified.
- (void)refreshHomeButton {}
- (void)removeHomeButton {
    [self.homeButton removeFromSuperview];
    self.homeButton = nil;
}
- (void)homeButtonTapped { [self homeButtonTappedUnsafe]; }
- (void)homeButtonTappedUnsafe { [self closeGoingHome:YES]; }
- (void)raise { [self raiseView:self.container]; }
- (void)raiseView:(UIView *)view {
    if (view.superview) [view.superview bringSubviewToFront:view];
}
- (BOOL)viewIsRaised:(UIView *)view {
    return view.superview.subviews.lastObject == view;
}
- (void)raiseLauncher { [self raiseView:self.launcherHost]; }
- (UIView *)dockClusterInParent:(UIView *)parent { (void)parent; return nil; }
- (CGPoint)launcherCenterInParent:(UIView *)parent size:(CGSize)size shift:(CGFloat)shift {
    (void)parent; (void)size; (void)shift; return CGPointZero;
}
- (void)setDockShift:(CGFloat)shift { (void)shift; }
- (UIView *)dockHostForRect:(CGRect)rect inParent:(UIView *)parent { (void)rect; (void)parent; return nil; }
- (void)installIconLongPress {}
- (void)installLongPressIn:(UIView *)view depth:(NSInteger)depth { (void)view; (void)depth; }
- (void)iconLongPressed:(id)gesture { (void)gesture; }
- (void)iconLongPressedUnsafe:(id)gesture { (void)gesture; }
- (UIView *)tabParent { return self.container.superview; }
- (NSString *)fullscreenAppBundle {
    UIViewController *base = SCPCurrentBaseViewController(self);
    if (!base) return nil;
    id appInfo = SCPGuarded(base, @"applicationInfo");
    id proxyInfo = SCPGuarded(base, @"proxyApplicationInfo");
    return SCPRealBundleForInfos(appInfo, proxyInfo);
}

// Pane menu actions (solo / background / close) — INFERRED dispatchers:
// the paneSolo:/paneBackground:/paneClose: entry points confirm via the
// popup UI (agent B) and then run the run* variants.
- (void)paneSolo:(SCPCarPane *)pane { [self runSoloForPane:pane]; }
- (void)runSoloForPane:(SCPCarPane *)pane {
    if (SCPVCIsHosted(pane.vc)) [self hostSolo:pane.bundleID];
}
- (void)paneBackground:(SCPCarPane *)pane { [self runBackgroundForPane:pane]; }
- (void)runBackgroundForPane:(SCPCarPane *)pane {
    if (pane.vc && !SCPVCIsHosted(pane.vc)) [self detachVC:pane.vc background:YES];
}
- (void)paneClose:(SCPCarPane *)pane { [self runCloseForPane:pane]; }
- (void)runCloseForPane:(SCPCarPane *)pane { [self closeSlot:pane.slot background:YES]; }

@end

// [phase2; backported to src in phase 3] SCPCarPane has no behaviour
// methods in the binary — all 37 of its methods are synthesized
// accessors (see SCPCarPane.h) — so an empty implementation is the
// faithful reconstruction; phase 2 added it in the project copy only
// and verified the class + accessors in the built dylib.
@implementation SCPCarPane
@end
