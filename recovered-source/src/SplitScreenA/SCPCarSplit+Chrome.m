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
#import "SCPCarSplit+BridgeWake.h" // [wake1] bwRecomputeForPane: call points (design §1.3)
#import "SCPCarSplit+AutoHide.h" // [autohide] fade re-apply at layoutBarForPane: (design-autohide §5.1)

// Shared helpers implemented elsewhere:
extern UIImage *SCPSymbolImage(NSString *name, double pointSize);       // 0x2b474 (RatioMenu)
extern void SCPStyleRatioMenu(UIView *view, double radius);             // 0x29b10 (RatioMenu)
extern void SCPPrepareRatioMenu(UIView *view);                          // 0x24a34 (RatioMenu)

// MARK: - Shared visual helpers

// @0x35c74 — [phase2; backported to src in phase 3] unification] the frosted-backdrop factory lives in
// SCPCarDividerView.m as SCPKnobFaceView (the ONE name for @0x35c74;
// this file's duplicate definition under the name SCPBlurEffectView,
// whose blur-style constant contradicted the binary, was removed at
// merge — see project/logs/phase2-splitscreen.md).

// @0x35d5c — the mesh/logo backdrop applied to a frosted view: the OMC
// logo mesh image pinned to the content view, hairline border.
// APEX M3-0 (GPT scope approval 6875586688): skin Graphite/Titanium trung tinh
// ve bang code, thay artwork mesh logo cu CHI o cac mat DuoCar so huu. Loi dung
// chung OMCLogoMeshImage/OMCCommon.c giu nguyen; caller ngoai (SPPBubbleView)
// khong bi anh huong.
static UIImage *SCPApexGraphiteSkinImage(void) {
    static UIImage *img; static dispatch_once_t once;
    dispatch_once(&once, ^{
        UIGraphicsImageRenderer *r = [[UIGraphicsImageRenderer alloc] initWithSize:CGSizeMake(64, 64)];
        img = [r imageWithActions:^(UIGraphicsImageRendererContext *ctx) {
            CGContextRef c = ctx.CGContext;
            CGGradientRef g = CGGradientCreateWithColors(CGColorSpaceCreateDeviceRGB(),
                (CFArrayRef)@[(id)[UIColor colorWithRed:0.0392156862745098 green:0.07058823529411765 blue:0.09411764705882353 alpha:1].CGColor,
                              (id)[UIColor colorWithRed:0.13725490196078433 green:0.21176470588235294 blue:0.25098039215686274 alpha:1].CGColor],
                (CGFloat[]){0, 1});
            CGContextDrawLinearGradient(c, g, CGPointMake(0, 0), CGPointMake(64, 64), 0);
            CGGradientRelease(g);
        }];
    });
    return img;
}

void SCPApplyMeshBackdrop(UIVisualEffectView *effectView) {
    effectView.contentView.backgroundColor = UIColor.clearColor;
    UIImageView *mesh = [[UIImageView alloc]
        initWithImage:SCPApexGraphiteSkinImage()]; // APEX M3-0: bo mesh cu
    mesh.frame = effectView.contentView.bounds;
    mesh.contentMode = UIViewContentModeScaleToFill;
    mesh.autoresizingMask = 0x12;
    mesh.userInteractionEnabled = NO;
    [effectView.contentView insertSubview:mesh atIndex:0];
    effectView.layer.borderWidth = 1;
    effectView.layer.borderColor =
        [UIColor colorWithRed:0.20784313725490197 green:0.3176470588235294
                         blue:0.37254901960784315 alpha:0.85].CGColor; // APEX stroke
}

// @0x2b380 — the secondary text colour: navy at 55% alpha.
UIColor *SCPColorSecondary(void) {
    return [[UIColor colorWithRed:0.5764705882352941
                            green:0.6666666666666666
                             blue:0.7215686274509804
                            alpha:1.0] colorWithAlphaComponent:0.85];
}

// @0x35f70 — small-chip styling (cancel/exit chips): translucent white,
// hairline border, faint shadow.
void SCPStyleChip(UIView *view, double radius) {
    view.backgroundColor = [UIColor colorWithRed:0.106 green:0.165 blue:0.204 alpha:0.55]; // APEX surface.1
    view.layer.cornerRadius = radius;
    view.layer.cornerCurve = kCACornerCurveContinuous;
    view.layer.borderWidth = 1;
    view.layer.borderColor = [UIColor colorWithRed:0.208 green:0.318 blue:0.373 alpha:0.9].CGColor; // APEX stroke
    view.layer.shadowColor = [UIColor blackColor].CGColor;
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

// sub_24794 -> SCPApplyAccent @0x293a0: the handle accent toggled by
// setBarVisible:forPane: (gradient "omcAccent" layer + glow shadow on;
// layer removed + shadow off). TU-local copy of Picker.m's static of the
// same name (the module has one @0x293a0 in the binary; dedupe at
// integration, as with Picker's copy).
static void SCPApplyAccent(UIView *view, BOOL on) {
    CALayer *found = nil;
    for (CALayer *sub in view.layer.sublayers)
        if ([sub.name isEqualToString:@"omcAccent"]) { found = sub; break; }
    if (!on) {
        [found removeFromSuperlayer];
        view.layer.shadowColor = [UIColor colorWithRed:0.43137254901960786
                                                 green:0.39215686274509803
                                                  blue:0.7843137254901961
                                                 alpha:1.0].CGColor;
        view.layer.shadowOpacity = 0;
        return;
    }
    CAGradientLayer *grad = (CAGradientLayer *)found;
    if (grad == nil) {
        grad = [CAGradientLayer layer];
        grad.name = @"omcAccent";
        grad.colors = @[
            (id)[UIColor colorWithRed:0.4745098039215686 green:0.9294117647058824
                                 blue:0.9568627450980392 alpha:1.0].CGColor,
            (id)[UIColor colorWithRed:0.12941176470588237 green:0.5607843137254902
                                 blue:0.6666666666666666 alpha:1.0].CGColor]; // APEX #79EDF4 -> #218FAA
        grad.startPoint = CGPointZero;
        grad.endPoint = CGPointMake(1, 1);
        [view.layer insertSublayer:grad atIndex:0];
    }
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    grad.frame = view.bounds;
    grad.cornerRadius = view.layer.cornerRadius;
    grad.cornerCurve = kCACornerCurveContinuous;
    [CATransaction commit];
    view.layer.shadowColor = [UIColor colorWithRed:0.18
                                             green:0.65
                                                  blue:0.73
                                                 alpha:1.0].CGColor; // APEX teal glow
    view.layer.shadowOpacity = 0.45f;
    view.layer.shadowRadius = 9;
    view.layer.shadowOffset = CGSizeMake(0, 4);
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
        dot.backgroundColor = [[UIColor colorWithRed:0.06274509803921569
                                               green:0.09411764705882353
                                                blue:0.12549019607843137
                                               alpha:1.0]
            colorWithAlphaComponent:0.85]; // APEX graphite dots
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

    UIColor *navy = [UIColor colorWithRed:0.9176470588235294
                                    green:0.9647058823529412
                                     blue:0.984313725490196 alpha:1.0]; // APEX Ice (ten bien giu nguyen)
    UIColor *red = [UIColor colorWithRed:1.0 green:0.2784313725490196
                                    blue:0.3411764705882353 alpha:1.0]; // APEX danger #FF4757
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
            divider.backgroundColor = [UIColor colorWithRed:0.9176470588235294 green:0.9647058823529412 blue:0.984313725490196 alpha:0.35];
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

- (void)layoutBarForPane:(SCPCarPane *)pane {                             // 0x23b9c
    CGSize size = pane.view.bounds.size;
    // C3-3: handleShiftForPane: is added to the handle's X; Y stays 12
    // (@0x23c1c–0x23c2c). The earlier draft added the shift to Y.
    pane.handle.center = CGPointMake(size.width * 0.5 + [self handleShiftForPane:pane],
                                     12.0);
    pane.handle.hidden = (pane.vc == nil);
    // Bar scale (@0x23c90–0x23cc0): shrink to (paneW − 10)/barW only when
    // the bar does not fit (barW > paneW − 10) AND paneW − 10 > 40;
    // otherwise scale 1. Centre Y = 24 + scale × barH/2 (@0x23d48).
    double barW = pane.bar.bounds.size.width;
    double avail = size.width - 10.0;
    double scale = (barW > avail && avail > 40.0) ? avail / barW : 1.0;
    pane.bar.transform = CGAffineTransformMakeScale(scale, scale);
    pane.bar.center = CGPointMake(size.width * 0.5,
        24.0 + scale * pane.bar.bounds.size.height * 0.5);
    // Pop button (@0x23d74–0x23e9c): on the FLOAT pane the button docks
    // back, so its content swaps to hm_split / "Chia màn" and its enabled
    // state is (vc != nil && paneCount < 3) instead of canPopOutPane:.
    // Other panes keep hm_float / "Cửa sổ nổi" + canPopOutPane:.
    BOOL isFloat = (pane == self.floatPane);
    BOOL popEnabled = isFloat ? (pane.vc != nil && self.paneCount < 3)
                              : [self canPopOutPane:pane];
    SCPSetBarButtonContent(pane.popButton,
        isFloat ? @"hm_split" : @"hm_float",
        isFloat ? OMCTr(@"Chia màn", @"Split")
                : OMCTr(@"Cửa sổ nổi", @"Float"));
    pane.popButton.alpha = popEnabled ? 1.0 : 0.35;
    // Solo button (@0x23eac–0x23f78): content swap through the @0x24104
    // factory — a zoomed pane reads hm_split / "Chia màn", any other pane
    // hm_full / "Toàn màn". (The earlier draft's soloButton.selected was
    // INFERRED; the binary has no setSelected: here.)
    BOOL zoomed = self.zoomedSlot != nil &&
                  self.zoomedSlot.intValue == pane.slot;
    SCPSetBarButtonContent(pane.soloButton,
        zoomed ? @"hm_split" : @"hm_full",
        zoomed ? OMCTr(@"Chia màn", @"Split")
               : OMCTr(@"Toàn màn", @"Full screen"));
    [pane.view bringSubviewToFront:pane.handle];
    [pane.view bringSubviewToFront:pane.bar];
    [self bwRecomputeForPane:pane]; // [wake1] handle.hidden was (re)assigned above (design §1.3 point 2)
    [self ahApplyCurrentStateToView:pane.handle]; // [autohide] a (re)laid-out handle takes the current fade state — QA20's paint-at-layout pattern (design-autohide §2.1/§5.1)
}

// Show/hide a pane's bar (@0x241fc; GPT brief cites @0x23e60).
// Showing: hide every other pane's bar, layout, unhide, accent the
// handle (sub_24794); the entrance spring (SCPPrepareRatioMenu) and the
// host-frame push run ONLY on a hidden->shown transition; a 4 s timer
// auto-hides either way. Hiding: early-out when the bar is already
// hidden; otherwise accent off and a 0.18 s fade/shrink (block
// @0x24c44) whose completion (block @0x24cbc) runs FOUR commands in
// order — hidden=YES (@0x24cd8), alpha=1 (@0x24ce4), restore the saved
// transform (@0x24d04), then pushHostFramesLive:NO (@0x24d2c), the push
// gated on both weak captures (pane @+0x28, self @+0x30) being alive.
// (Acceptance pass 2026-11-09, GPT Deep Function Wiring Audit §7 N6:
// the strand-3 completion had only hidden+transform behind an
// alpha==0 guard borrowed from the AB side's hideBarForPane: shape;
// this function's own blocks, read from the original arm64 slice,
// have no such guard and do carry the alpha restore + push.)
// (The earlier draft hid instantly, animated a -10 pt slide both ways,
// laid out on the hide path too, and pushed host frames unconditionally.)
- (void)setBarVisible:(BOOL)visible forPane:(SCPCarPane *)pane {          // 0x241fc
    [pane.barTimer invalidate];
    pane.barTimer = nil;
    if (visible) {
        [self hideRatioMenu];
        for (SCPCarPane *other in self.allPanes)
            if (other != pane)
                [self setBarVisible:NO forPane:other];
        [self layoutBarForPane:pane];
        BOOL wasHidden = pane.bar.isHidden;
        pane.bar.hidden = NO;
        SCPApplyAccent(pane.handle, YES);                                 // sub_24794
        if (wasHidden) SCPPrepareRatioMenu(pane.bar);
        __weak SCPCarSplit *weakSelf = self;
        __weak SCPCarPane *weakPane = pane;
        pane.barTimer = [NSTimer scheduledTimerWithTimeInterval:4.0
            repeats:NO block:^(NSTimer *timer) {
                [weakSelf setBarVisible:NO forPane:weakPane];
            }];
        if (wasHidden) [self pushHostFramesLive:NO];
        [self bwRecomputeForPane:pane]; // [wake1] show decision point (design §1.3 point 1)
        return;
    }
    if (pane.bar.isHidden) return;
    SCPApplyAccent(pane.handle, NO);                                      // sub_24794
    UIView *bar = pane.bar;
    CGAffineTransform saved = bar.transform;
    __weak SCPCarSplit *weakSelf = self;
    __weak SCPCarPane *weakPane = pane;
    [UIView animateWithDuration:0.18 delay:0
        options:0x10000        // raw; CurveEaseIn (@0x245ec)
        animations:^{
            bar.alpha = 0;
            bar.transform = CGAffineTransformScale(saved, 0.94, 0.94);
        } completion:^(BOOL finished) {
            // Block @0x24cbc: four commands, this order, no alpha guard.
            bar.hidden = YES;                                             // @0x24cd8
            bar.alpha = 1;                                                // @0x24ce4
            bar.transform = saved;                                        // @0x24d04
            SCPCarSplit *s = weakSelf;
            if (s != nil && weakPane != nil) {
                [s pushHostFramesLive:NO];                                // @0x24d2c
                [s bwRecomputeForPane:weakPane]; // [wake1] bar.hidden landed YES (design §1.3 point 1)
            }
        }];
    [self bwRecomputeForPane:pane]; // [wake1] hide decision point: fade in flight -> transient (design §1.3 point 1)
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

// The picker presentation A/B is owned by SCPCarSplit+Picker.m;
// the touch shield must follow the SAME hosting decision. If a hosted
// sheet lives inside the original container, avoid creating a second
// UIRootSceneWindow solely for the 2% transparent shield.
extern BOOL SCPHL49SameWindowPicker(SCPCarSplit *owner);

// MARK: - Popup bookkeeping

- (BOOL)panelOpen {                                                      // 0x26394 (approx.)
    return self.tray != nil || self.ratioMenu != nil ||
           self.pickerSheet != nil;
}

- (BOOL)popupOpen {
    return [self panelOpen] || [self anyBarVisible];
}

- (void)closePopups {                                                    // 0x267e4 (approx.)
    // [do] fix-round4 E-2 instrumentation (NOT original behaviour): log
    // the caller (return address tells the shield-outside caller apart
    // from bridgeOutsideTouched within a run) and the popup state at
    // entry — fires even for calls that turn out to be no-ops.
    OMCLogWrite(@"SplitScreen",
        [NSString stringWithFormat:@"CarSplit: [do] closePopups <= %p (popup %d)",
            __builtin_return_address(0), (int)[self popupOpen]]);
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
    BOOL hl49SameWindow = SCPHL49SameWindowPicker(self);
    UIWindow *window = hl49SameWindow ? nil : [self trayWindowForParent:parent];
    UIView *host = window != nil ? (UIView *)window : parent;
    if (hl49SameWindow) {
        // An idle cached overlay must not sit over a live hosted surface.
        // Never hide an overlay that still owns a tray/ratio/ghost/toast.
        UIWindow *cached=self.trayWindow;
        if (cached && !self.tray && !self.ratioMenu && !self.dragGhost &&
            [cached viewWithTag:0x5c9b]==nil)
            cached.hidden=YES;
        OMCLogWrite(@"SplitScreen",@"[hl49-window-ab] popupShield=SAME-PARENT");
    }
    SCPCTouchWatch *shield = (SCPCTouchWatch *)self.popupShield; // [phase2; backported to src in phase 3] property is UIView* in metadata; the stored view is the touch watch
    if (shield == nil || shield.superview != host) {
        [shield removeFromSuperview];
        shield = [[SCPCTouchWatch alloc] initWithFrame:host.bounds];
        shield.autoresizingMask = 0x12;
        shield.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.02];
        __weak SCPCarSplit *weakSelf = self;
        shield.exempt = ^BOOL(CGPoint point) {
            BOOL ok = [weakSelf shieldExemptPoint:point];
            // [do] fix-round4 E-2 instrumentation (NOT original
            // behaviour): the verdict and the exempt rects behind it.
            OMCLogWrite(@"SplitScreen",
                [NSString stringWithFormat:@"CarSplit: [do] shield exempt %@ -> %d rects %@",
                    NSStringFromCGPoint(point), (int)ok,
                    [weakSelf shieldExemptRects]]);
            return ok;
        };
        shield.outside = ^(CGPoint point) {
            [weakSelf closePopups];
        };
        [host addSubview:shield];
        self.popupShield = shield;
    }
    [host bringSubviewToFront:shield];
    // [do] fix-round4 E-2 instrumentation (NOT original behaviour):
    // which host carries the shield, and where the shield sits in it.
    OMCLogWrite(@"SplitScreen",
        [NSString stringWithFormat:@"CarSplit: [do] shield host %@ superview %@",
            NSStringFromClass(host.class),
            NSStringFromClass(shield.superview.class)]);
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
