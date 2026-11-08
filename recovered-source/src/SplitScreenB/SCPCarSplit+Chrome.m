// SCPCarSplit+Chrome.m — OmniCarSplitScreen reconstruction, module SplitScreenB.
// Per-pane chrome: the drag handle (pill at the top of each pane) and the
// action bar (choose / solo / pop-out / background / close buttons), the
// popup shield (an SCPCTouchWatch that swallows outside taps while a
// popup is open), and popup bookkeeping.
//
// CLOSURE (wave 3, finisher): setupBarForPane: is now reconstructed
// line-by-line (the earlier PARTIAL row construction is superseded —
// see the "Closure addendum" in SplitScreenB_REPORT.md): the handle is
// 34x12 with THREE dots, and the bar row is built by the real factory
// @0x23710 with an NSNull separator. This file also hosts the shared
// visual helpers the panel/picker code calls (blur backdrop, mesh,
// secondary colour, chip styling).

#import "SCPCarSplit.h"
#import "SCPCommon.h" // [phase2; backported to src in phase 3] OMC* declarations used in this TU
#import "SCPCButton.h" // [phase2; backported to src in phase 3] SCPCButton interface used in this TU
#import "SCPCarPane.h"
#import "SCPCTouchWatch.h"

// Shared helpers implemented elsewhere:
extern UIImage *SCPSymbolImage(NSString *name, double pointSize);       // 0x2b474 (RatioMenu)
extern void SCPStyleRatioMenu(UIView *view, double radius);             // 0x29b10 (RatioMenu)

// MARK: - Shared visual helpers

// @0x35c74 — [phase2; backported to src in phase 3] unification] the frosted-backdrop factory lives in
// SCPCarDividerView.m as SCPKnobFaceView (the ONE name for @0x35c74;
// this file's duplicate definition under the name SCPBlurEffectView,
// whose blur-style constant contradicted the binary, was removed at
// merge — see project/logs/phase2-splitscreen.md).

// @0x35d5c — the mesh/logo backdrop applied to a frosted view: the OMC
// logo mesh image pinned to the content view, hairline border.
void SCPApplyMeshBackdrop(UIVisualEffectView *effectView) {
    effectView.contentView.backgroundColor = UIColor.clearColor;
    UIImageView *mesh = [[UIImageView alloc]
        initWithImage:OMCLogoMeshImage(0)];
    mesh.frame = effectView.contentView.bounds;
    mesh.contentMode = UIViewContentModeScaleToFill;
    mesh.autoresizingMask = 0x12;
    mesh.userInteractionEnabled = NO;
    [effectView.contentView insertSubview:mesh atIndex:0];
    effectView.layer.borderWidth = 1;
    effectView.layer.borderColor =
        [UIColor colorWithWhite:1 alpha:0.85].CGColor;
}

// @0x2b380 — the secondary text colour: navy at 55% alpha.
UIColor *SCPColorSecondary(void) {
    return [[UIColor colorWithRed:0.2901960784313726
                            green:0.30980392156862746
                             blue:0.5019607843137255
                            alpha:1.0] colorWithAlphaComponent:0.55];
}

// @0x35f70 — small-chip styling (cancel/exit chips): translucent white,
// hairline border, faint shadow.
void SCPStyleChip(UIView *view, double radius) {
    view.backgroundColor = [UIColor colorWithWhite:1 alpha:0.5];
    view.layer.cornerRadius = radius;
    view.layer.cornerCurve = kCACornerCurveContinuous;
    view.layer.borderWidth = 1;
    view.layer.borderColor = [UIColor colorWithWhite:1 alpha:0.9].CGColor;
    view.layer.shadowColor = [UIColor colorWithRed:0.43137254901960786
                                             green:0.39215686274509803
                                              blue:0.7843137254901961
                                             alpha:1.0].CGColor;
    view.layer.shadowOpacity = 0.12f;
    view.layer.shadowRadius = 3;
    view.layer.shadowOffset = CGSizeMake(0, 2);
}

// @0x24104 — (re)sets a bar button's icon + accessibility label.
static void SCPSetBarButtonContent(UIButton *button, NSString *iconName, NSString *label) {
    ((UIImageView *)[button viewWithTag:0x1c86]).image =
        SCPSymbolImage(iconName, 22.0);
    button.accessibilityLabel = label;
}

// @0x23710 — bar button factory: a 48x40 button carrying a 40x40 styled
// chip (tag 0x1c85) with an inset icon view (tag 0x1c86).
static UIButton *SCPBarButton(NSString *iconName, NSString *label,
                              UIColor *tint, id target, SEL action) {
    SCPCButton *button = [SCPCButton buttonWithType:0];
    button.bounds = CGRectMake(0, 0, 48, 40);
    button.tintColor = tint;
    UIView *chip = [[UIView alloc] initWithFrame:CGRectMake(4, 0, 40, 40)];
    chip.tag = 0x1c85;
    chip.userInteractionEnabled = NO;
    SCPStyleChip(chip, 20.0);
    UIImageView *iconView = [[UIImageView alloc]
        initWithFrame:CGRectInset(chip.bounds, 6, 6)];
    iconView.tag = 0x1c86;
    iconView.contentMode = UIViewContentModeScaleAspectFit;
    [chip addSubview:iconView];
    [button addSubview:chip];
    SCPSetBarButtonContent(button, iconName, label);
    [button addTarget:target action:action
        forControlEvents:UIControlEventTouchUpInside];
    return button;
}

@implementation SCPCarSplit (Chrome)

// MARK: - Bar construction

// CLOSED @0x22adc: handle pill 34x12 with three dots at x = 9/17/25,
// tap / double-tap / pan recognizers, then the five bar buttons via the
// factory (choose, solo, pop-out, background, close — red), an NSNull
// separator before close, and the 52 pt bar sized by the row width.
- (void)setupBarForPane:(SCPCarPane *)pane {                              // 0x22adc
    UIView *handle = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 34, 12)];
    handle.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.35];
    handle.layer.cornerRadius = 6;
    handle.layer.cornerCurve = kCACornerCurveContinuous;
    handle.layer.borderWidth = 0.5;
    handle.layer.borderColor = [UIColor colorWithWhite:1.0 alpha:0.55].CGColor;

    for (NSInteger dx = -8; dx < 16; dx += 8) {
        UIView *dot = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 4, 4)];
        dot.center = CGPointMake(dx + 17, 6);
        dot.backgroundColor = [[UIColor colorWithRed:0.2901960784313726
                                               green:0.30980392156862746
                                                blue:0.5019607843137255
                                               alpha:1.0]
            colorWithAlphaComponent:0.85];
        dot.layer.cornerRadius = 2;
        dot.userInteractionEnabled = NO;
        [handle addSubview:dot];
    }

    UITapGestureRecognizer *tap =
        [[UITapGestureRecognizer alloc] initWithTarget:self
                                                action:@selector(handleTapped:)];
    UITapGestureRecognizer *doubleTap =
        [[UITapGestureRecognizer alloc] initWithTarget:self
                                                action:@selector(handleDoubleTapped:)];
    doubleTap.numberOfTapsRequired = 2;
    [tap requireGestureRecognizerToFail:doubleTap];
    [handle addGestureRecognizer:tap];
    [handle addGestureRecognizer:doubleTap];
    UIPanGestureRecognizer *pan =
        [[UIPanGestureRecognizer alloc] initWithTarget:self
                                                action:@selector(handlePanned:)];
    pan.maximumNumberOfTouches = 1;
    [handle addGestureRecognizer:pan];

    pane.handle = handle;
    [pane.view addSubview:handle];

    UIColor *navy = [UIColor colorWithRed:0.2901960784313726
                                    green:0.30980392156862746
                                     blue:0.5019607843137255 alpha:1.0];
    UIColor *red = [UIColor colorWithRed:1.0 green:0.35294117647058826
                                    blue:0.37254901960784315 alpha:1.0];
    UIButton *choose = SCPBarButton(@"hm_apps", OMCTr(@"Đổi app", @"Change app"),
                                    navy, self, @selector(paneChoose:));
    pane.soloButton = SCPBarButton(@"hm_full", OMCTr(@"Toàn màn", @"Full screen"),
                                   navy, self, @selector(paneSolo:));
    pane.popButton = SCPBarButton(@"hm_float", OMCTr(@"Cửa sổ nổi", @"Float"),
                                  navy, self, @selector(panePopOut:));
    UIButton *background = SCPBarButton(@"hm_min", OMCTr(@"Chạy nền", @"Background"),
                                        navy, self, @selector(paneBackground:));
    UIButton *close = SCPBarButton(@"hm_close", OMCTr(@"Tắt app", @"Quit app"),
                                   red, self, @selector(paneClose:));
    NSArray *buttons = @[choose, pane.soloButton, pane.popButton,
                         background, [NSNull null], close];

    double totalW = 12.0;
    for (id item in buttons)
        totalW += [item isKindOfClass:UIButton.class] ? 48.0 : 7.0;
    UIView *bar = [[UIView alloc] initWithFrame:CGRectMake(0, 0, totalW, 52)];
    SCPStyleRatioMenu(bar, 22.0);

    double x = 6.0;
    for (id item in buttons) {
        if ([item isKindOfClass:UIButton.class]) {
            UIButton *button = item;
            button.center = CGPointMake(x + 24, 26);
            [bar addSubview:button];
            x += 48.0;
        } else {
            UIView *divider = [[UIView alloc]
                initWithFrame:CGRectMake(x + 3, 11, 1, 30)];
            divider.backgroundColor = [UIColor colorWithWhite:1 alpha:0.95];
            divider.layer.cornerRadius = 0.5;
            divider.userInteractionEnabled = NO;
            [bar addSubview:divider];
            x += 7.0;
        }
    }
    bar.hidden = YES;
    pane.bar = bar;
    [pane.view addSubview:bar];
}

// MARK: - Bar layout & visibility

// 38 pt when the pane does not start at the container's top edge (and the
// layout is not a main-stack); the float pane and main-stack panes get 0.
- (double)handleShiftForPane:(SCPCarPane *)pane {                         // 0x23ab4
    if (pane == self.floatPane) return 0;
    if (self.mainStack) return 0;
    return (CGRectGetMinY(pane.view.frame) > 1.0) ? 38.0 : 0.0;
}

- (void)layoutBarForPane:(SCPCarPane *)pane {                             // 0x23b9c (approx.)
    CGSize size = pane.view.bounds.size;
    pane.handle.center = CGPointMake(size.width * 0.5,
                                     12.0 + [self handleShiftForPane:pane]);
    pane.handle.hidden = (pane.vc == nil);
    pane.bar.center = CGPointMake(size.width * 0.5, 24.0);
    pane.popButton.alpha = [self canPopOutPane:pane] ? 1.0 : 0.35;
    // soloButton reflects the zoom state of this pane (zoomedSlot == slot).
    BOOL zoomed = self.zoomedSlot != nil &&
                  self.zoomedSlot.intValue == pane.slot;
    pane.soloButton.selected = zoomed;                                    // INFERRED setter
    [pane.view bringSubviewToFront:pane.handle];
    [pane.view bringSubviewToFront:pane.bar];
}

// Show/hide a pane's bar. Showing hides every other pane's bar and arms a
// 4 s auto-hide timer; the bar slides by a -10 pt vertical offset.
- (void)setBarVisible:(BOOL)visible forPane:(SCPCarPane *)pane {          // 0x23e60 (approx.)
    [pane.barTimer invalidate];
    pane.barTimer = nil;
    if (visible) {
        [self hideRatioMenu];
        for (SCPCarPane *other in self.allPanes)
            if (other != pane)
                [self setBarVisible:NO forPane:other];
    }
    [self layoutBarForPane:pane];
    pane.bar.hidden = !visible;
    if (visible) {
        __weak SCPCarSplit *weakSelf = self;
        pane.barTimer = [NSTimer scheduledTimerWithTimeInterval:4.0
            repeats:NO block:^(NSTimer *timer) {
                [weakSelf setBarVisible:NO forPane:pane];
            }];
    }
    [self pushHostFramesLive:NO];
    CGAffineTransform target = visible ? CGAffineTransformIdentity
        : CGAffineTransformMakeTranslation(0, -10);
    [UIView animateWithDuration:0.18 delay:0 options:0
        animations:^{ pane.bar.transform = target; } completion:nil];
}

- (BOOL)anyBarVisible {                                                  // (getter used by popupOpen)
    for (SCPCarPane *pane in self.allPanes)
        if (pane.bar != nil && !pane.bar.isHidden) return YES;
    return NO;
}

// Hide every visible bar except one whose bar/handle contains the touch
// (touched == nil hides all). The isDescendantOfView: direction is
// INFERRED (receiver/argument order not isolated in the disassembly).
- (void)hideBarsForTouchOn:(UIView *)touched {                            // 0x26010 (approx.)
    for (SCPCarPane *pane in self.allPanes) {
        if (pane.bar == nil || pane.bar.isHidden) continue;
        if (touched != nil &&
            ([touched isDescendantOfView:pane.bar] ||
             [touched isDescendantOfView:pane.handle]))
            continue;
        [self setBarVisible:NO forPane:pane];
    }
}

// MARK: - Popup bookkeeping

- (BOOL)panelOpen {                                                      // 0x26394 (approx.)
    return self.tray != nil || self.ratioMenu != nil ||
           self.pickerSheet != nil;
}

- (BOOL)popupOpen {
    return [self panelOpen] || [self anyBarVisible];
}

- (void)closePopups {                                                    // 0x267e4 (approx.)
    if ([self popupOpen]) {
        self.popupsClosedAt = [[NSDate date] timeIntervalSince1970]; // [phase2; backported to src in phase 3] fix] popupsClosedAt is Td/double (objc.json + both headers); src assigned the NSDate* itself
        OMCLogWrite(@"SplitScreen",
            [NSString stringWithFormat:@"CarSplit: dong popup (tray %@, ti le %@, chon app %@, thanh %@)",
                self.tray != nil ? @"co" : @"khong",
                self.ratioMenu != nil ? @"co" : @"khong",
                self.pickerSheet != nil ? @"co" : @"khong",
                [self anyBarVisible] ? @"co" : @"khong"]);   // INFERRED wording
    }
    [self collapseAppTray];
    [self hideRatioMenu];
    [self removePickerSheet];
    [self hideBarsForTouchOn:nil];
}

// MARK: - Popup shield

// The shield is an SCPCTouchWatch covering the popup host (tray window if
// any, else the tab parent). Touches outside the exempt rects close all
// popups; the exempt rects are punched through as holes.
- (void)updatePopupShield {                                              // 0x26424
    if (![self panelOpen] || self.tabParent == nil) {
        [self.popupShield removeFromSuperview];
        self.popupShield = nil;
        [self hideTrayWindowIfIdle];
        return;
    }
    UIView *parent = self.tabParent;
    UIWindow *window = [self trayWindowForParent:parent];
    UIView *host = window != nil ? (UIView *)window : parent;
    SCPCTouchWatch *shield = (SCPCTouchWatch *)self.popupShield; // [phase2; backported to src in phase 3] property is UIView* in metadata; the stored view is the touch watch
    if (shield == nil || shield.superview != host) {
        [shield removeFromSuperview];
        shield = [[SCPCTouchWatch alloc] initWithFrame:host.bounds];
        shield.autoresizingMask = 0x12;
        shield.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.02];
        __weak SCPCarSplit *weakSelf = self;
        shield.exempt = ^BOOL(CGPoint point) {
            return [weakSelf shieldExemptPoint:point];
        };
        shield.outside = ^(CGPoint point) {
            [weakSelf closePopups];
        };
        [host addSubview:shield];
        self.popupShield = shield;
    }
    [host bringSubviewToFront:shield];
    [self refreshShieldHoles];
}

// Window-coordinate rects of everything a popup touch may legitimately
// hit: open popups, the home button, the ratio knob, the picker's own
// pane picker, and every visible pane handle/bar.
- (NSArray<NSValue *> *)shieldExemptRects {                               // 0x25a30 (approx.)
    NSMutableArray<UIView *> *views = [NSMutableArray array];
    if (self.tray != nil) [views addObject:self.tray];
    if (self.ratioMenu != nil) [views addObject:self.ratioMenu];
    if (self.pickerSheet != nil) [views addObject:self.pickerSheet];
    if (self.homeButton != nil) [views addObject:self.homeButton];
    if (self.ratioKnob != nil) [views addObject:self.ratioKnob];
    if (self.pickerSheetPane.picker != nil)
        [views addObject:self.pickerSheetPane.picker];
    for (SCPCarPane *pane in self.allPanes) {
        if (pane.handle != nil && !pane.handle.isHidden)
            [views addObject:pane.handle];
        if (pane.bar != nil && !pane.bar.isHidden)
            [views addObject:pane.bar];
    }
    NSMutableArray<NSValue *> *rects = [NSMutableArray array];
    for (UIView *view in views) {
        if (view.window == nil || view.isHidden || view.alpha == 0)
            continue;
        CGRect r = [view convertRect:view.bounds toView:nil];
        [rects addObject:[NSValue valueWithCGRect:r]];
    }
    return rects;
}

- (BOOL)shieldExemptPoint:(CGPoint)point {                               // 0x26010 (approx.)
    for (NSValue *value in [self shieldExemptRects])
        if (CGRectContainsPoint(value.CGRectValue, point)) return YES;
    return NO;
}

- (void)refreshShieldHoles {                                             // 0x261b0
    SCPCTouchWatch *shield = (SCPCTouchWatch *)self.popupShield; // [phase2; backported to src in phase 3] property is UIView* in metadata; the stored view is the touch watch
    if (shield == nil) return;
    NSMutableArray<NSValue *> *holes = [NSMutableArray array];
    for (NSValue *value in [self shieldExemptRects]) {
        CGRect r = [shield convertRect:value.CGRectValue fromView:nil];
        [holes addObject:[NSValue valueWithCGRect:r]];
    }
    shield.holes = holes;
}

@end
