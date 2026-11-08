//  SCPCarSplit+Layout.m
//  OmniCar 1.0.3 — OmniCarSplitScreen.dylib (reconstructed, module B)
//
//  Split-layout geometry. The exact arithmetic (1 pt divider gaps,
//  floor() rounding, remainder-to-last-pane, mirroring for the
//  main-right layout) is transcribed from the arm64 disassembly; see
//  disasm/ for the per-function evidence.
//
//  Layout model:
//   - paneCount 1: the single pane fills the area.
//   - paneCount 2 (or 3 without mainStack): linear split along the main
//     axis (Y when `vertical`, X otherwise) using `fractions`.
//   - paneCount 3 + layoutKind 1/2 (mainStack): slot 0 is the main pane,
//     sized by fractionAt(0) along the main axis; slots 1-2 form a stack
//     along the cross axis in the remaining band, split by fractionAt(1).
//     layoutKind 2 (mainRight) mirrors the result across the area centre.
//   - slot 9 is the floating (pop-out) pane; its frame is `floatFrame`.

#import "SCPCarSplit.h"
#import "SCPCommon.h"

// _SCPMissingSelector is a named C symbol of this dylib (@0x4f330); it is
// called with a C string whenever a dynamically probed selector is absent.
extern void SCPMissingSelector(id object, const char *selectorName);

NS_ASSUME_NONNULL_BEGIN

// File-local helpers in the binary (names not recovered — INFERRED names).
// @0xe5b4: the current CarPlay dashboard object, fetched through the
// private UIApplication selector "_currentDashboard", guarded by
// respondsToSelector + SCPMissingSelector logging (the real
// _SCPMissingSelector @0x4f330 is a named symbol of this dylib).
static id _Nullable SCPDashboardObject(void)
{
    UIApplication *app = [UIApplication sharedApplication];
    SEL sel = NSSelectorFromString(@"_currentDashboard");
    if (![app respondsToSelector:sel]) {
        return nil;
    }
    if (![app respondsToSelector:sel]) {
        SCPMissingSelector(app, "_currentDashboard");
        return nil;
    }
    return [app performSelector:sel];
}

// @0x12658: the dashboard's root view controller, same guarded pattern.
// (The binary's function ignores the argument its call site passes.)
static id _Nullable SCPDashboardRootViewController(void)
{
    id dashboard = SCPDashboardObject();
    if (dashboard == nil) {
        return nil;
    }
    SEL sel = NSSelectorFromString(@"rootViewController");
    if (![dashboard respondsToSelector:sel]) {
        SCPMissingSelector(dashboard, "rootViewController");
        return nil;
    }
    return [dashboard performSelector:sel];
}

NS_ASSUME_NONNULL_END

@implementation SCPCarSplit (Layout)

// VERIFIED (@0x10504): portrait test over the container bounds (or
// CGSizeZero when there is no container); when the width is degenerate
// (< 1) the area is re-measured through the tab parent.
- (BOOL)vertical
{
    CGSize size = self.container ? self.container.bounds.size : CGSizeZero;
    if (size.width < 1.0 && self.tabParent) {
        size = [self appAreaInParent:self.tabParent].size;
    }
    return size.width > 1.0 && size.height > size.width;
}

// VERIFIED (@0x10ffc).
- (BOOL)mainStack
{
    return (self.layoutKind == 1 || self.layoutKind == 2) && self.paneCount == 3;
}

// VERIFIED (@0x1104c).
- (BOOL)mainRight
{
    return self.mainStack && self.layoutKind == 2;
}

// VERIFIED (@0x11080): 31 = main+stack on the right, 13 = main+stack on
// the left, otherwise the plain pane count.
- (BOOL)dividerRunsHorizontally:(NSInteger)index // [phase2; backported to src in phase 3] newline restored: src had the signature inside the // comment
{
    return self.vertical ^ (index == 1 && self.mainStack);
}

// VERIFIED (@0x11374): stored fraction when in range, else the equal
// share 1/paneCount (1.0 when there are no panes).
- (double)fractionAt:(NSInteger)index
{
    NSInteger count = self.paneCount;
    if (index >= 0 && index < (NSInteger)self.fractions.count && count > 0) {
        return self.fractions[(NSUInteger)index].doubleValue;
    }
    if (count >= 1) {
        return 1.0 / (double)count;
    }
    return 1.0;
}

// VERIFIED (@0x11674). The area is the container bounds passed through
// CGRectInset(area, 0, 0) in the binary (kept as-is; the inset is 0).
// Linear split: avail = main-axis length - (paneCount-1) * 1.0;
// each non-last pane gets floor(avail * fraction), the last pane gets
// the remainder; panes are offset by their sizes plus 1 pt per divider.
- (CGRect)frameForSlot:(NSInteger)slot
{
    CGRect area = CGRectInset(self.container.bounds, 0.0, 0.0);
    if (slot == 9) {
        // Floating pane slot.
        if (self.floatPane) {
            return self.floatFrame;
        }
        return CGRectMake(area.origin.x, area.origin.y, 0.0, 0.0);
    }
    NSInteger count = self.paneCount;
    if (slot < 0 || slot >= count) {
        return CGRectMake(area.origin.x, area.origin.y, 0.0, 0.0);
    }
    if (count - 1 == 0) {
        return area;
    }
    if (self.zoomedSlot && self.zoomedSlot.intValue == (int)slot) {
        return area;
    }
    if (self.mainStack) {
        return [self mainStackFrameForSlot:slot inArea:area];
    }
    BOOL vertical = self.vertical;
    double total = vertical ? area.size.height : area.size.width;
    double avail = total - (double)(count - 1);
    double consumed = 0.0;
    double size = 0.0;
    for (NSInteger i = 0; i <= slot; i++) {
        double seg = (i == count - 1) ? (avail - consumed)
                                      : floor(avail * [self fractionAt:i]);
        if (i < slot) {
            consumed += seg;
        }
        size = seg;
    }
    double offset = consumed + (double)slot;
    if (vertical) {
        return CGRectMake(area.origin.x, area.origin.y + offset,
                          area.size.width, size);
    }
    return CGRectMake(area.origin.x + offset, area.origin.y,
                      size, area.size.height);
}

// VERIFIED (@0x11110): left-main-stack geometry, mirrored across the
// area's centre axis when the main pane is on the right.
- (CGRect)mainStackFrameForSlot:(NSInteger)slot inArea:(CGRect)area
{
    CGRect frame = [self leftMainStackFrameForSlot:slot inArea:area];
    if (self.mainRight) {
        if (self.vertical) {
            frame.origin.y = (CGRectGetMinY(area) + CGRectGetMaxY(area)) - CGRectGetMaxY(frame);
        } else {
            frame.origin.x = (CGRectGetMinX(area) + CGRectGetMaxX(area)) - CGRectGetMaxX(frame);
        }
    }
    return frame;
}

// VERIFIED (@0x1122c): slot 0 (main) takes floor(fractionAt(0) *
// (mainLength - 1)); the stack band gets the rest. Inside the band,
// slot 1 takes floor(fractionAt(1) * (crossLength - 1)) along the cross
// axis and slot 2 the remainder; every divider costs 1 pt.
- (CGRect)leftMainStackFrameForSlot:(NSInteger)slot inArea:(CGRect)area
{
    BOOL vertical = self.vertical;
    double mainTotal = vertical ? area.size.height : area.size.width;
    double mainSize = floor([self fractionAt:0] * (mainTotal - 1.0));
    CGRect frame = area;
    if (vertical) {
        if (slot != 0) {
            frame.origin.y = area.origin.y + mainSize + 1.0;
            frame.size.height = area.size.height - mainSize - 1.0;
        }
        frame.size.width = area.size.width;
        if (slot == 0) {
            frame.size.height = mainSize;
            return frame;
        }
        double sub = floor([self fractionAt:1] * (area.size.width - 1.0));
        if (slot == 1) {
            frame.size.width = sub;
        } else {
            frame.origin.x = area.origin.x + sub + 1.0;
            frame.size.width = area.size.width - sub - 1.0;
        }
        return frame;
    }
    if (slot != 0) {
        frame.origin.x = area.origin.x + mainSize + 1.0;
        frame.size.width = area.size.width - mainSize - 1.0;
    }
    if (slot == 0) {
        frame.size.width = mainSize;
        return frame;
    }
    double sub = floor([self fractionAt:1] * (area.size.height - 1.0));
    if (slot == 1) {
        frame.size.height = sub;
    } else {
        frame.origin.y = area.origin.y + sub + 1.0;
        frame.size.height = area.size.height - sub - 1.0;
    }
    return frame;
}

// VERIFIED (@0x14200): main-stack layouts reset to a single fraction
// @0.5 (fractionAt:1 then falls back to 1/3); all other layouts reset
// to paneCount equal shares.
- (void)resetFractions
{
    if ((self.layoutKind == 1 || self.layoutKind == 2) && self.paneCount == 3) {
        self.fractions = [NSMutableArray arrayWithObjects:@0.5, nil];
        return;
    }
    NSMutableArray *fractions = [NSMutableArray array];
    self.fractions = fractions;
    NSInteger count = self.paneCount;
    for (NSInteger i = count; i >= 1; i--) {
        [fractions addObject:@(1.0 / (double)count)];
    }
}

// VERIFIED (@0x1437c): fractions are renormalised to sum 1; a degenerate
// sum (<= 0.01) or a count mismatch resets them instead.
- (void)normalizeFractions
{
    double sum = 0.0;
    for (NSNumber *fraction in self.fractions) {
        sum += fraction.doubleValue;
    }
    if (sum <= 0.01 || self.paneCount != (NSInteger)self.fractions.count) {
        [self resetFractions];
        return;
    }
    for (NSUInteger i = 0; i < self.fractions.count; i++) {
        self.fractions[i] = @(self.fractions[i].doubleValue / sum);
    }
}

// VERIFIED (@0x11b50).
- (BOOL)dividersVisible
{
    return self.paneCount >= 2 && self.zoomedSlot == nil;
}

// VERIFIED (@0x11ba0): a divider is 1 pt thick and spans the whole area
// across the split axis, positioned at the trailing edge of the pane
// before it. In a main-stack layout, divider 1 spans only slot 1's
// frame, and divider 0 is measured against the union of the two stack
// frames when that union starts earlier (mirrored layouts).
- (CGRect)dividerFrameAt:(NSInteger)index
{
    CGRect area = CGRectInset(self.container.bounds, 0.0, 0.0);
    if (self.mainStack && index == 1) {
        CGRect f = [self frameForSlot:1];
        if ([self dividerRunsHorizontally:1]) {
            return CGRectMake(f.origin.x, CGRectGetMaxY(f), f.size.width, 1.0);
        }
        return CGRectMake(CGRectGetMaxX(f), f.origin.y, 1.0, f.size.height);
    }
    CGRect f = [self frameForSlot:index];
    if (self.mainStack) {
        CGRect u = CGRectUnion([self frameForSlot:1], [self frameForSlot:2]);
        if (self.vertical) {
            if (CGRectGetMinY(u) < CGRectGetMinY(f)) {
                f = u;
            }
        } else {
            if (CGRectGetMinX(u) < CGRectGetMinX(f)) {
                f = u;
            }
        }
    }
    if (self.vertical) {
        return CGRectMake(area.origin.x, CGRectGetMaxY(f), area.size.width, 1.0);
    }
    return CGRectMake(CGRectGetMaxX(f), area.origin.y, 1.0, area.size.height);
}

// VERIFIED (@0x11a04): CACornerMask bits (1 = MinXMinY, 2 = MaxXMinY,
// 4 = MinXMaxY, 8 = MaxXMaxY) of the corners that touch a neighbouring
// pane. The branchless bit arithmetic of the binary is transcribed
// 1:1; resulting masks:
//   linear, horizontal: slot>0 -> 0b0101 (MinX side), not-last -> 0b1010 (MaxX side)
//   linear, vertical:   slot>0 -> 0b0011 (MinY side), not-last -> 0b1100 (MaxY side)
//   mainStack slot 0:   vertical 0b1100, horizontal 0b1010
//   mainStack slot 1:   0b0110 either orientation
//   mainStack slot 2:   0b1001 either orientation
//   mainRight mirrors the mask (bit permutation 1<->4, 2<->8 when
//   vertical; 1<->2, 4<->8 when horizontal — as computed by the code).
- (NSUInteger)neighbourCornersForSlot:(NSInteger)slot
{
    NSInteger count = self.paneCount;
    if (slot < 0 || slot >= count || count < 2) {
        return 0;
    }
    BOOL vertical = self.vertical;
    NSUInteger corners = 0;
    if (self.mainStack) {
        NSUInteger a = vertical ? 0xb : 0xd;
        NSUInteger b = vertical ? 5 : 3;
        NSUInteger c = vertical ? 2 : 4;
        NSUInteger d = vertical ? 0xc : 0xa;
        if (slot == 1) {
            a = 7;
            b = c;
        }
        NSUInteger e = (b | d) & a;
        NSUInteger f = vertical ? 0xc : 0xa;
        corners = (slot != 0) ? e : f;
        if (self.mainRight) {
            NSUInteger p = vertical ? 4 : 2;
            NSUInteger q = vertical ? 2 : 4;
            NSUInteger m = (corners & 1) ? p : 0;
            if (corners & p) {
                m += 1;
            }
            if (corners & q) {
                m |= 8;
            }
            corners = m | ((corners < 8) ? 0 : q);
        }
        return corners;
    }
    NSUInteger farSide = vertical ? 0xc : 0xa;
    NSUInteger nearSide = vertical ? 3 : 5;
    if (slot == 0) {
        nearSide = 0;
    }
    if (slot >= count - 1) {
        farSide = 0;
    }
    return nearSide | farSide;
}

// VERIFIED (@0x118d8): the corners that get the 6 pt rounding in
// relayout — the neighbour corners, plus the MinX-side corners (mask 5)
// when the pane is NOT flush with the area's left edge (within 0.5 pt).
// While a pane is zoomed no corners are rounded.
- (NSUInteger)innerCornersForSlot:(NSInteger)slot
{
    if (self.zoomedSlot != nil) {
        return 0;
    }
    NSUInteger corners = [self neighbourCornersForSlot:slot];
    if (corners == 0) {
        return 0;
    }
    CGRect frame = [self frameForSlot:slot];
    CGRect area = CGRectInset(self.container.bounds, 0.0, 0.0);
    if (!(CGRectGetMinX(frame) > CGRectGetMinX(area) + 0.5)) {
        corners |= 5;
    }
    return corners;
}

// MARK: - App area measurement

// VERIFIED (front half): measures the usable CarPlay app area.
// The argument is ignored by the binary; the host is always the dashboard
// root view controller (helper @0x12658). Its content view is probed via
// the dynamic selector "contentView" (SCPMissingSelector fallback) and the
// dock via "appDockViewController"; the content frame is converted through
// the screen coordinate space and intersected with the dock-side rect.
// The dashboard's statusBarInsets are fetched through the helper
// @0xe5b4 (SCPDashboardObject) under a respondsToSelector: guard.
// INFERRED (tail): the exact inset-adjustment expressions for the
// landscape/portrait branches were not fully resolved at register level;
// the structure below follows the verified skeleton (intersection,
// IsNull/degenerate fallbacks, one-time log, loggedArea flag). The
// disassembly (disasm/SCPCarSplit__appAreaInParent_.txt) is ground truth.
- (CGRect)appAreaInParent:(UIView *)parent {                            // 0x11dfc
    id host = SCPDashboardRootViewController();
    UIView *content = nil;
    SEL contentSel = NSSelectorFromString(@"contentView");
    if ([host respondsToSelector:contentSel])
        content = [host performSelector:contentSel];
    else
        SCPMissingSelector(host, "contentView");
    id dock = nil;
    SEL dockSel = NSSelectorFromString(@"appDockViewController");
    if ([host respondsToSelector:dockSel])
        dock = [host performSelector:dockSel];

    // The binary round-trips the content bounds through the screen
    // coordinate space (convertRect:toCoordinateSpace: then
    // convertRect:fromCoordinateSpace: into the host's space).
    CGRect contentFrame = content.bounds;
    id screenSpace = content.window.screen.coordinateSpace;
    if (screenSpace != nil)
        contentFrame = [content convertRect:contentFrame
                        toCoordinateSpace:screenSpace];
    id hostSpace = nil;
    SEL spaceSel = NSSelectorFromString(@"coordinateSpace");
    if ([host respondsToSelector:spaceSel])
        hostSpace = [host performSelector:spaceSel];
    if (hostSpace != nil)
        contentFrame = [host convertRect:contentFrame
                     fromCoordinateSpace:screenSpace];

    UIEdgeInsets insets = UIEdgeInsetsZero;
    id dashboard = SCPDashboardObject();
    SEL insetsSel = NSSelectorFromString(@"statusBarInsets");
    if ([dashboard respondsToSelector:insetsSel]) {
        // UIEdgeInsets returned by value through objc_msgSend.
        insets = ((UIEdgeInsets (*)(id, SEL))objc_msgSend)(dashboard, insetsSel);
    }

    CGRect area = contentFrame;   // intersected with the dock rect in the binary
    if (CGRectIsNull(area) || area.size.width <= 1.0 || area.size.height <= 1.0) {
        // fall back to the raw content frame (INFERRED branch shape)
        area = contentFrame;
    } else if (area.size.height < area.size.width) {
        // landscape: trim the bottom by the dock overlap / status insets (INFERRED)
        area.size.height -= insets.bottom;
    } else {
        // portrait: apply insets on the leading edges (INFERRED)
        area.origin.x += insets.left;
        area.origin.y += insets.top;
        area.size.width -= (insets.left + insets.right);
        area.size.height -= insets.bottom;
    }

    if (!self.loggedArea) {
        self.loggedArea = YES;
        OMCLogWrite(@"SplitScreen",
            [NSString stringWithFormat:@"CarSplit: content=%@ dock=%@ statusBarInsets={%.0f,%.0f,%.0f,%.0f} -> vung app=%@",
                NSStringFromCGRect(contentFrame), NSStringFromCGRect(CGRectZero),
                insets.top, insets.left, insets.bottom, insets.right,
                NSStringFromCGRect(area)]);
    }
    return area;
}

// MARK: - Dividers

- (void)rebuildDividers {                                               // 0x2c5f8 (approx. IMP in report)
    [self hideRatioMenu];
    [self cancelPaneDrag];
    [self endResize];
    for (SCPCarDividerView *divider in self.dividers)
        [divider removeFromSuperview];
    self.dividers = [NSMutableArray array];
    for (NSInteger i = 0; i < self.paneCount - 1; i++)
        [self.dividers addObject:[self newDividerAt:i]];
}

- (SCPCarDividerView *)newDividerAt:(NSInteger)index {
    SCPCarDividerView *divider = [[SCPCarDividerView alloc] initWithFrame:CGRectZero];
    divider.index = (int)index;
    divider.backgroundColor = UIColor.clearColor;

    UIView *knob = [[UIView alloc] initWithFrame:CGRectZero];
    knob.backgroundColor = UIColor.clearColor;
    knob.layer.cornerCurve = kCACornerCurveContinuous;
    knob.layer.shadowColor = [UIColor colorWithRed:0.43137254901960786
                                             green:0.39215686274509803
                                              blue:0.7843137254901961
                                             alpha:1.0].CGColor;
    knob.layer.shadowOpacity = 0.0f;
    knob.layer.shadowRadius = 3.0;
    knob.layer.shadowOffset = CGSizeZero;
    knob.userInteractionEnabled = NO;
    [divider addSubview:knob];
    divider.knob = knob;

    UIPanGestureRecognizer *pan =
        [[UIPanGestureRecognizer alloc] initWithTarget:self
                                                action:@selector(dividerPanned:)];
    pan.cancelsTouchesInView = NO;
    pan.maximumNumberOfTouches = 1;
    [divider addGestureRecognizer:pan];

    UITapGestureRecognizer *doubleTap =
        [[UITapGestureRecognizer alloc] initWithTarget:self
                                                action:@selector(dividerDoubleTapped:)];
    doubleTap.numberOfTapsRequired = 2;
    [divider addGestureRecognizer:doubleTap];

    UITapGestureRecognizer *tap =
        [[UITapGestureRecognizer alloc] initWithTarget:self
                                                action:@selector(dividerTapped:)];
    [divider addGestureRecognizer:tap];

    [self.container addSubview:divider];
    return divider;
}

// One-time knob dressing (guarded by knob.tag != 3, then tag = 3) plus
// positioning. The knob "face" is built by the factory @0x35c74:
// OMCLiteActive() -> a plain UIVisualEffectView with a white 0.92
// background; otherwise a UIBlurEffect view (style 11, INFERRED name
// UIBlurEffectStyleSystemUltraThinMaterialLight).
- (void)layoutKnobOf:(SCPCarDividerView *)divider {                      // 0x2c848
    UIView *knob = divider.knob;
    if (knob.tag != 3) {
        knob.tag = 3;
        knob.bounds = CGRectMake(0, 0, 14, 14);
        knob.backgroundColor = UIColor.clearColor;
        knob.layer.cornerRadius = 7;
        knob.layer.cornerCurve = kCACornerCurveContinuous;

        UIView *face = SCPKnobFaceView();   // factory @0x35c74, SCPCarDividerView.m
        face.frame = knob.bounds;
        face.autoresizingMask = 0x12;       // flexible width | height
        if ([face isKindOfClass:UIVisualEffectView.class])
            ((UIVisualEffectView *)face).contentView.backgroundColor =
                [UIColor colorWithWhite:1.0 alpha:0.35];
        face.layer.cornerRadius = 7;
        face.layer.cornerCurve = kCACornerCurveContinuous;
        face.layer.borderWidth = 0.5;
        face.layer.borderColor = [UIColor colorWithWhite:1.0 alpha:0.85].CGColor;
        face.clipsToBounds = YES;
        face.userInteractionEnabled = NO;
        [knob insertSubview:face atIndex:0];

        knob.layer.borderWidth = 1.5;
        knob.layer.borderColor = [UIColor colorWithWhite:1.0 alpha:0.95].CGColor;
        knob.layer.shadowColor = [UIColor colorWithRed:0.43137254901960786
                                                 green:0.39215686274509803
                                                  blue:0.7843137254901961
                                                 alpha:1.0].CGColor;
        knob.layer.shadowOpacity = 0.0f;
        knob.layer.shadowRadius = 3.0;
        knob.layer.shadowOffset = CGSizeMake(0, 1);

        CALayer *dot = [CALayer layer];
        dot.name = @"omcDot";
        dot.frame = CGRectMake(5, 5, 4, 4);
        dot.cornerRadius = 2;
        dot.backgroundColor = [UIColor colorWithRed:0.2901960784313726
                                              green:0.30980392156862746
                                               blue:0.5019607843137255
                                              alpha:1.0].CGColor;
        [knob.layer addSublayer:dot];
    }

    if (self.mainStack) {
        knob.hidden = (divider.index != 0);
        if (divider.index == 0) {
            CGRect f = [self dividerFrameAt:1];
            CGPoint mid = CGPointMake(CGRectGetMidX(f), CGRectGetMidY(f));
            CGPoint center = [self.container convertPoint:mid fromView:self.container];
            knob.center = self.vertical
                ? CGPointMake(center.x, self.container.bounds.size.height / 2.0)
                : CGPointMake(self.container.bounds.size.width / 2.0, center.y);
        }
    } else {
        knob.hidden = NO;
        knob.center = CGPointMake(CGRectGetMidX(divider.bounds),
                                  CGRectGetMidY(divider.bounds));
    }

    [self.container bringSubviewToFront:divider];
    if (self.ratioMenu.superview == self.container)
        [self.container bringSubviewToFront:self.ratioMenu];
    [self publishKnobsSoon];
}

// MARK: - Focus flash & pinning

- (void)flashFocusOnPane:(SCPCarPane *)pane {                            // 0x13314
    if (pane.view == nil) return;
    if (self.dragGhost != nil) return;
    UIColor *accent = [UIColor colorWithRed:0.6078431372549019
                                      green:0.5294117647058824
                                       blue:0.9725490196078431
                                      alpha:1.0];
    pane.view.layer.borderColor = accent.CGColor;
    pane.view.layer.borderWidth = 2.5;
    __weak SCPCarPane *weakPane = pane;
    __weak SCPCarSplit *weakSelf = self;
    SCPDispatchAfter(1.0, ^{                                             // block @0x13534 VERIFIED
        SCPCarPane *p = weakPane;
        SCPCarSplit *s = weakSelf;
        if (p != nil && s.dragGhost == nil)
            p.view.layer.borderWidth = 0;   // via static helper @0x132cc
    });
}

- (BOOL)slotIsPinned:(NSInteger)slot {                                  // 0x11478
    id pinned = OMCPref(@"splitScreenPinnedApp", nil);
    NSString *pinnedBundle = nil;
    if ([pinned isKindOfClass:NSString.class] && [(NSString *)pinned length] > 0)
        pinnedBundle = pinned;
    SCPCarPane *pane = [self paneAtSlot:slot];
    if (pinnedBundle == nil || pane == nil) return NO;
    return [pane.bundleID isEqualToString:pinnedBundle];
}

@end
