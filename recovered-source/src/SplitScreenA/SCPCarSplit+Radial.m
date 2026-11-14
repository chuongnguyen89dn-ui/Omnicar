//  SCPCarSplit+Radial.m
//  DuoCar V3 P4/G2 — OmniCarSplitScreen.dylib
//
//  Radial wheel presenter + dispatcher (category on the shared
//  SCPCarSplit; no second split/popup engine). Hosting follows the
//  picker: the tray window of the current parent (tabParent), falling
//  back to the parent itself; the backdrop is transparent and only
//  the wheel disc and the target cards claim touches — a tap that
//  lands on the backdrop itself dismisses with no side effects.
//
//  Geometry (G1 contract D, design formulas): inside the current
//  appArea, S1 diameter <= min(0.83*h, 0.60*w, 380); with target
//  cards (S2) <= min(0.66*h, 0.60*w, 360); strip 56 pt + 10 pt gap
//  under the wheel. Original pane/handle/bar geometry is untouched.

#import "SCPCarSplit+Radial.h"
#import "SCPCarPane.h"
#import "SCPCommon.h" // OMCLogWrite / OMCTr / OMCPref
#import <objc/runtime.h>

// Shared helpers implemented elsewhere in this module:
extern char *SCPJBRootPath(const char *path, char *buf);   // SCPLibRoot.m (libroot trampoline)
extern UIImage *SCPAppIconForBundle(NSString *bundleID);   // SCPAppIcons.m
extern NSString *SCPCarAppName(NSString *bundleID);        // SCPCarApps.m (LSApplicationProxy name)

// MARK: - Feature flag

BOOL SCPRadialEnabled(void) {
    return [OMCPref(@"duocarRadialEnabled", @YES) boolValue];
}

// MARK: - Private view / record types

// Full-host backdrop: transparent; a touch whose hit view is the
// backdrop itself (i.e. outside the wheel disc and the cards) ends
// the presentation. Touches assigned to subviews never trigger it
// (UITouch.view stays the original hit view up the responder chain).
@interface SCPRadialBackdropView : UIView
@property (nonatomic, copy, nullable) void (^tapOutsideHandler)(void);
@end

@implementation SCPRadialBackdropView
- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesEnded:touches withEvent:event];
    if (touches.anyObject.view == self && self.tapOutsideHandler)
        self.tapOutsideHandler();
}
@end

// Snapshot of one target card at build time: the dispatch re-resolves
// the pane by slot and refuses to act when bundle or VC moved on
// (GPT dispatch pseudocode: bundle mismatch || vc mismatch -> refresh).
@interface SCPRadialTargetRecord : NSObject
@property (nonatomic) NSInteger slot;   // pane slot; 9 = floating pane
@property (nonatomic) BOOL isFloat;
@property (nonatomic, copy, nullable) NSString *bundleID;
@property (nonatomic, weak, nullable) UIViewController *vc;
@end

@implementation SCPRadialTargetRecord
@end

// MARK: - Centre logo

// The official DuoCar D asset, loaded from the prefs bundle through
// the module's own rootless path helper — the same logo@3x.png the
// prefs UI ships (never redrawn here).
static UIImage *SCPRadialCenterLogoImage(void) {
    static UIImage *image = nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        char buf[1024];
        NSString *base = [NSString stringWithUTF8String:
            SCPJBRootPath("/Library/PreferenceBundles/OmniCarPrefs.bundle", buf)];
        for (NSString *name in @[@"logo@3x.png", @"logo@2x.png", @"logo.png"]) {
            image = [UIImage imageWithContentsOfFile:
                        [base stringByAppendingPathComponent:name]];
            if (image != nil) break;
        }
        if (image == nil)
            OMCLogWrite(@"SplitScreen",
                @"[radial] khong tim thay logo D trong OmniCarPrefs.bundle");
    });
    return image;
}

// MARK: - Geometry (G1 contract D formulas)

static CGFloat SCPRadialDiameter(CGRect area, BOOL withCards) {
    CGFloat h = CGRectGetHeight(area), w = CGRectGetWidth(area);
    return withCards ? MIN(MIN(0.66 * h, 0.60 * w), 360.0)
                     : MIN(MIN(0.83 * h, 0.60 * w), 380.0);
}

static const CGFloat kSCPRadialStripHeight = 56.0;
static const CGFloat kSCPRadialStripGap = 10.0;

// MARK: - Presenter state (associated objects)

static const void *kSCPRadialBackdropKey = &kSCPRadialBackdropKey;
static const void *kSCPRadialWheelKey = &kSCPRadialWheelKey;
static const void *kSCPRadialStripKey = &kSCPRadialStripKey;
static const void *kSCPRadialHostKey = &kSCPRadialHostKey;
static const void *kSCPRadialAreaKey = &kSCPRadialAreaKey;
static const void *kSCPRadialDiameterKey = &kSCPRadialDiameterKey;
static const void *kSCPRadialSelectedKey = &kSCPRadialSelectedKey;
static const void *kSCPRadialRecordsKey = &kSCPRadialRecordsKey;

@implementation SCPCarSplit (Radial)

- (SCPRadialBackdropView *)scp_radialBackdrop {
    return objc_getAssociatedObject(self, kSCPRadialBackdropKey);
}
- (void)scp_setRadialBackdrop:(SCPRadialBackdropView *)view {
    objc_setAssociatedObject(self, kSCPRadialBackdropKey, view,
                             OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (SCPRadialControlView *)scp_radialWheel {
    return objc_getAssociatedObject(self, kSCPRadialWheelKey);
}
- (void)scp_setRadialWheel:(SCPRadialControlView *)view {
    objc_setAssociatedObject(self, kSCPRadialWheelKey, view,
                             OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (SCPRadialTargetStrip *)scp_radialStrip {
    return objc_getAssociatedObject(self, kSCPRadialStripKey);
}
- (void)scp_setRadialStrip:(SCPRadialTargetStrip *)view {
    objc_setAssociatedObject(self, kSCPRadialStripKey, view,
                             OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (UIView *)scp_radialHost {
    return objc_getAssociatedObject(self, kSCPRadialHostKey);
}
- (void)scp_setRadialHost:(UIView *)view {
    objc_setAssociatedObject(self, kSCPRadialHostKey, view,
                             OBJC_ASSOCIATION_ASSIGN);
}
- (CGRect)scp_radialArea {
    NSValue *value = objc_getAssociatedObject(self, kSCPRadialAreaKey);
    return value ? value.CGRectValue : CGRectNull;
}
- (void)scp_setRadialArea:(CGRect)area {
    objc_setAssociatedObject(self, kSCPRadialAreaKey,
                             [NSValue valueWithCGRect:area],
                             OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (CGFloat)scp_radialDiameter {
    NSNumber *n = objc_getAssociatedObject(self, kSCPRadialDiameterKey);
    return n ? n.doubleValue : 0;
}
- (void)scp_setRadialDiameter:(CGFloat)d {
    objc_setAssociatedObject(self, kSCPRadialDiameterKey, @(d),
                             OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (NSNumber *)scp_radialSelectedAction {
    return objc_getAssociatedObject(self, kSCPRadialSelectedKey);
}
- (void)scp_setRadialSelectedAction:(NSNumber *)action {
    objc_setAssociatedObject(self, kSCPRadialSelectedKey, action,
                             OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (NSDictionary<NSNumber *, SCPRadialTargetRecord *> *)scp_radialRecords {
    return objc_getAssociatedObject(self, kSCPRadialRecordsKey);
}
- (void)scp_setRadialRecords:(NSDictionary<NSNumber *, SCPRadialTargetRecord *> *)records {
    objc_setAssociatedObject(self, kSCPRadialRecordsKey, records,
                             OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)scpRadialIsPresented {
    return [self scp_radialBackdrop] != nil;
}

// MARK: - Wheel construction / layout

- (SCPRadialControlView *)scp_radialMakeWheelWithDiameter:(CGFloat)d {
    SCPRadialControlView *wheel =
        [[SCPRadialControlView alloc] initWithDiameter:d];
    wheel.delegate = self;
    wheel.centerLogoView.image = SCPRadialCenterLogoImage();
    // R4 gate: true fullscreen (hide Dock/logo, pinch-in restore) is
    // unproven against the FS1/zoomedSlot guards, so the sector ships
    // disabled with its reason (G1 contract C2).
    [wheel setAction:SCPRadialActionFull enabled:NO
              reason:OMCTr(@"Chưa khả dụng", @"Not available yet")];
    return wheel;
}

- (void)scp_radialLayout {
    SCPRadialControlView *wheel = [self scp_radialWheel];
    if (wheel == nil) return;
    SCPRadialTargetStrip *strip = [self scp_radialStrip];
    CGRect area = [self scp_radialArea];
    CGFloat d = [self scp_radialDiameter];
    CGFloat totalH = d + (strip ? (kSCPRadialStripGap + kSCPRadialStripHeight) : 0);
    CGFloat y = CGRectGetMinY(area) +
                MAX(0.0, (CGRectGetHeight(area) - totalH) * 0.5);
    CGFloat cx = CGRectGetMidX(area);
    wheel.frame = CGRectMake(cx - d * 0.5, y, d, d);
    if (strip)
        strip.frame = CGRectMake(cx - d * 0.5, y + d + kSCPRadialStripGap,
                                 d, kSCPRadialStripHeight);
}

// MARK: - Present / dismiss

- (void)scpRadialPresentFromPane:(SCPCarPane *)pane {
    if (![NSThread isMainThread]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self scpRadialPresentFromPane:pane];
        });
        return;
    }
    if ([self scpRadialIsPresented]) [self scpRadialDismiss];
    if (!self.active) {
        OMCLogWrite(@"SplitScreen", @"[radial] bo qua: split chua active");
        return;
    }
    // One-popup ownership: close tray/ratio/picker/bars BEFORE the
    // wheel exists, so closePopups can never tear the wheel down.
    [self closePopups];
    UIView *parent = self.tabParent ?: self.container;
    if (parent == nil) {
        OMCLogWrite(@"SplitScreen", @"[radial] bo qua: khong co parent");
        return;
    }
    UIWindow *window = [self trayWindowForParent:parent];
    UIView *host = window ?: parent;
    CGRect area = [self appAreaInParent:parent];
    if (window != nil) area = [parent convertRect:area toView:nil];
    if (CGRectIsNull(area) || area.size.width < 120.0 ||
        area.size.height < 120.0) {
        OMCLogWrite(@"SplitScreen", [NSString stringWithFormat:
            @"[radial] bo qua: vung app khong dung duoc %@", NSStringFromCGRect(area)]);
        if (window != nil) [self hideTrayWindowIfIdle];
        return;
    }
    CGFloat d = SCPRadialDiameter(area, NO);
    SCPRadialBackdropView *backdrop =
        [[SCPRadialBackdropView alloc] initWithFrame:host.bounds];
    backdrop.autoresizingMask =
        UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    backdrop.backgroundColor = UIColor.clearColor;
    __weak SCPCarSplit *weakSelf = self;
    backdrop.tapOutsideHandler = ^{ [weakSelf scpRadialDismiss]; };
    SCPRadialControlView *wheel = [self scp_radialMakeWheelWithDiameter:d];
    [backdrop addSubview:wheel];

    [self scp_setRadialBackdrop:backdrop];
    [self scp_setRadialWheel:wheel];
    [self scp_setRadialStrip:nil];
    [self scp_setRadialHost:host];
    [self scp_setRadialArea:area];
    [self scp_setRadialDiameter:d];
    [self scp_setRadialSelectedAction:nil];
    [self scp_setRadialRecords:nil];
    [host addSubview:backdrop];
    [self scp_radialLayout];

    backdrop.alpha = 0;
    wheel.transform = CGAffineTransformMakeScale(0.92, 0.92);
    [UIView animateWithDuration:0.25 animations:^{
        backdrop.alpha = 1;
        wheel.transform = CGAffineTransformIdentity;
    }];
    OMCLogWrite(@"SplitScreen", [NSString stringWithFormat:
        @"[radial] mo wheel slotGoiY=%ld host=%@ area=%@ d=%.0f",
        pane ? (long)pane.slot : -1L, NSStringFromClass(host.class),
        NSStringFromCGRect(area), d]);
}

- (void)scpRadialToggleForPane:(SCPCarPane *)pane {
    if ([self scpRadialIsPresented]) [self scpRadialDismiss];
    else [self scpRadialPresentFromPane:pane];
}

- (void)scpRadialDismiss {
    SCPRadialBackdropView *backdrop = [self scp_radialBackdrop];
    if (backdrop == nil) return;
    UIView *host = [self scp_radialHost];
    BOOL wasWindow = [host isKindOfClass:UIWindow.class];
    [backdrop removeFromSuperview];
    [self scp_setRadialBackdrop:nil];
    [self scp_setRadialWheel:nil];
    [self scp_setRadialStrip:nil];
    [self scp_setRadialHost:nil];
    [self scp_setRadialArea:CGRectNull];
    [self scp_setRadialDiameter:0];
    [self scp_setRadialSelectedAction:nil];
    [self scp_setRadialRecords:nil];
    if (wasWindow) {
        // Let the shield owner drop its (now idle) shield, then hide
        // the shared tray window if nothing else still uses it.
        [self updatePopupShield];
        [self hideTrayWindowIfIdle];
    }
    OMCLogWrite(@"SplitScreen", @"[radial] dong wheel");
}

// MARK: - Target cards

- (void)scp_radialBuildItems:(NSArray<SCPRadialTargetItem *> **)itemsOut
                     records:(NSDictionary<NSNumber *, SCPRadialTargetRecord *> **)recordsOut
                   forAction:(SCPRadialAction)action {
    NSMutableArray<SCPRadialTargetItem *> *items = [NSMutableArray array];
    NSMutableDictionary<NSNumber *, SCPRadialTargetRecord *> *records =
        [NSMutableDictionary dictionary];
    for (SCPCarPane *pane in self.allPanes) {
        BOOL isFloat = (pane == self.floatPane);
        BOOL hasApp = (pane.vc != nil && pane.bundleID != nil);
        if (isFloat && !hasApp) continue;  // empty float: no card
        if (isFloat && action == SCPRadialActionReplace) continue;
        SCPRadialTargetItem *item = [[SCPRadialTargetItem alloc] init];
        item.slot = isFloat ? -1 : pane.slot;
        item.isFloatCard = isFloat;
        item.title = isFloat
            ? OMCTr(@"Nổi", @"Floating")
            : [NSString stringWithFormat:OMCTr(@"Ô %d", @"Pane %d"),
                                         pane.slot + 1];
        item.appName = hasApp ? SCPCarAppName(pane.bundleID) : nil;
        item.icon = hasApp ? SCPAppIconForBundle(pane.bundleID) : nil;
        BOOL enabled = YES;
        NSString *reason = nil;
        switch (action) {
            case SCPRadialActionReplace:
                if (!hasApp) {
                    enabled = NO;
                    reason = OMCTr(@"Ô chưa có app", @"This pane has no app");
                } else if ([self slotIsPinned:pane.slot]) {
                    enabled = NO;
                    reason = OMCTr(@"Ô này đang ghim", @"This pane is pinned");
                }
                break;
            case SCPRadialActionPop:
                if (!isFloat) {
                    reason = [self popOutBlockReason:pane];
                    enabled = (reason == nil);
                }   // float card: enabled, its tap docks back
                break;
            case SCPRadialActionBackground:
            case SCPRadialActionClose:
                if (!hasApp) {
                    enabled = NO;
                    reason = OMCTr(@"Ô chưa có app", @"This pane has no app");
                }
                break;
            case SCPRadialActionFull:
                enabled = NO;
                reason = OMCTr(@"Chưa khả dụng", @"Not available yet");
                break;
        }
        item.enabled = enabled;
        item.disabledReason = enabled ? nil : reason;
        [items addObject:item];
        SCPRadialTargetRecord *record = [[SCPRadialTargetRecord alloc] init];
        record.slot = isFloat ? 9 : pane.slot;
        record.isFloat = isFloat;
        record.bundleID = pane.bundleID;
        record.vc = pane.vc;
        records[@(record.slot)] = record;
    }
    if (itemsOut) *itemsOut = items;
    if (recordsOut) *recordsOut = records;
}

// (Re)build the strip for the pending action. Also the stale-refresh
// path: cards always reflect the CURRENT model after this call.
- (void)scpRadialRefreshCards {
    SCPRadialBackdropView *backdrop = [self scp_radialBackdrop];
    NSNumber *selected = [self scp_radialSelectedAction];
    if (backdrop == nil || selected == nil) return;
    SCPRadialAction action = (SCPRadialAction)selected.integerValue;
    CGRect area = [self scp_radialArea];
    CGFloat d2 = SCPRadialDiameter(area, YES);
    if (fabs([self scp_radialDiameter] - d2) > 0.5) {
        // The wheel bakes its diameter at init (no relayout), so the
        // S1 -> S2 shrink swaps in a fresh wheel at the S2 size.
        SCPRadialControlView *old = [self scp_radialWheel];
        SCPRadialControlView *fresh = [self scp_radialMakeWheelWithDiameter:d2];
        [fresh setSelectedAction:selected];
        [backdrop insertSubview:fresh
                       atIndex:[backdrop.subviews indexOfObject:old]];
        [old removeFromSuperview];
        [self scp_setRadialWheel:fresh];
        [self scp_setRadialDiameter:d2];
    } else {
        [[self scp_radialWheel] setSelectedAction:selected];
    }
    NSArray<SCPRadialTargetItem *> *items = nil;
    NSDictionary<NSNumber *, SCPRadialTargetRecord *> *records = nil;
    [self scp_radialBuildItems:&items records:&records forAction:action];
    [[self scp_radialStrip] removeFromSuperview];
    [self scp_setRadialStrip:nil];
    [self scp_setRadialRecords:records];
    if (items.count == 0) {
        OMCLogWrite(@"SplitScreen",
            @"[radial] khong con pane nao, dong wheel");
        [self scpRadialDismiss];
        return;
    }
    SCPRadialTargetStrip *strip =
        [[SCPRadialTargetStrip alloc] initWithItems:items width:d2];
    strip.delegate = self;
    [backdrop addSubview:strip];
    [self scp_setRadialStrip:strip];
    [self scp_radialLayout];
}

// MARK: - Selection + dispatch

- (void)scpRadialSelectAction:(SCPRadialAction)action {
    if (![self scpRadialIsPresented]) return;
    if (action == SCPRadialActionFull) {
        // Sector is disabled in the view; a programmatic call lands
        // here and must stay a no-op while the R4 gate is unproven.
        OMCLogWrite(@"SplitScreen",
            @"[radial] Full chua kha dung (cong R4), bo qua");
        return;
    }
    [self scp_setRadialSelectedAction:@(action)];
    [[self scp_radialWheel] setSelectedAction:@(action)];
    [self scpRadialRefreshCards];
    OMCLogWrite(@"SplitScreen", [NSString stringWithFormat:
        @"[radial] chon lenh %ld, hien the dich", (long)action]);
}

- (void)scpRadialSelectTargetSlot:(NSInteger)slot {
    if (![self scpRadialIsPresented]) return;
    SCPRadialTargetRecord *record = [self scp_radialRecords][@(slot)];
    NSNumber *selected = [self scp_radialSelectedAction];
    if (record == nil || selected == nil) {
        OMCLogWrite(@"SplitScreen", [NSString stringWithFormat:
            @"[radial] the slot=%ld khong co ban ghi, bo qua", (long)slot]);
        return;
    }
    SCPRadialAction action = (SCPRadialAction)selected.integerValue;
    SCPCarPane *pane = (slot == 9) ? self.floatPane
                                   : [self paneAtSlot:slot];
    // Stale guard (GPT pseudocode): re-resolve NOW; on any drift of
    // pane / bundle / VC, refresh the cards and do NOT dispatch.
    if (pane == nil || pane.vc == nil ||
        ![pane.bundleID isEqualToString:record.bundleID] ||
        pane.vc != record.vc) {
        OMCLogWrite(@"SplitScreen", [NSString stringWithFormat:
            @"[radial] the slot=%ld da cu (bundle %@ -> %@), lam moi the",
            (long)slot, record.bundleID, pane.bundleID]);
        [self scpRadialRefreshCards];
        return;
    }
    NSString *bundle = pane.bundleID;
    [self scpRadialDismiss];
    switch (action) {
        case SCPRadialActionReplace:
            if ([self slotIsPinned:pane.slot]) {
                [self toast:OMCTr(@"Ô này đang ghim", @"This pane is pinned")];
                OMCLogWrite(@"SplitScreen", [NSString stringWithFormat:
                    @"[radial] dispatch replace slot=%ld %@ -> o dang ghim, khong mo picker",
                    (long)slot, bundle]);
            } else {
                [self showPickerForSlot:(int)pane.slot];
                OMCLogWrite(@"SplitScreen", [NSString stringWithFormat:
                    @"[radial] dispatch replace slot=%ld %@ -> showPickerForSlot",
                    (long)slot, bundle]);
            }
            break;
        case SCPRadialActionPop:
            if (record.isFloat) {
                [self floatDockBack];
                OMCLogWrite(@"SplitScreen", [NSString stringWithFormat:
                    @"[radial] dispatch pop float %@ -> floatDockBack", bundle]);
            } else {
                NSString *reason = [self popOutBlockReason:pane];
                if (reason != nil) {
                    [self toast:reason];
                    OMCLogWrite(@"SplitScreen", [NSString stringWithFormat:
                        @"[radial] dispatch pop slot=%ld %@ bi chan: %@",
                        (long)slot, bundle, reason]);
                } else {
                    [self popOutPane:pane];
                    OMCLogWrite(@"SplitScreen", [NSString stringWithFormat:
                        @"[radial] dispatch pop slot=%ld %@ -> popOutPane",
                        (long)slot, bundle]);
                }
            }
            break;
        case SCPRadialActionBackground:
            [self runBackgroundForPane:pane];
            OMCLogWrite(@"SplitScreen", [NSString stringWithFormat:
                @"[radial] dispatch bg slot=%ld %@ -> runBackgroundForPane",
                (long)slot, bundle]);
            break;
        case SCPRadialActionClose:
            [self runCloseForPane:pane];
            OMCLogWrite(@"SplitScreen", [NSString stringWithFormat:
                @"[radial] dispatch close slot=%ld %@ -> runCloseForPane",
                (long)slot, bundle]);
            break;
        case SCPRadialActionFull:
            OMCLogWrite(@"SplitScreen",
                @"[radial] dispatch full bi chan (cong R4)");
            break;
    }
}

// MARK: - View delegates

- (void)radialView:(SCPRadialControlView *)view
   didSelectAction:(SCPRadialAction)action {
    [self scpRadialSelectAction:action];
}

- (void)radialViewDidTapCenter:(SCPRadialControlView *)view {
    [self scpRadialDismiss];
}

- (void)targetStrip:(SCPRadialTargetStrip *)strip
      didSelectItem:(SCPRadialTargetItem *)item {
    // The strip addresses the float card as slot -1; the dispatcher
    // (and the engine) know the floating pane as slot 9.
    [self scpRadialSelectTargetSlot:(item.isFloatCard ? 9 : item.slot)];
}

@end
