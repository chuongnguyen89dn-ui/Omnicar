// SCPCarSplit+Zoom.m — OmniCarSplitScreen reconstruction, module SplitScreenB.
// Pane zoom (expand one pane to the full area), the floating "picture in
// picture" pane (slot 9), its drag/snap behaviour, pop-out / dock-back,
// and the omnicar:// URL commands for layout, ratio, swap and zoom.
//
// NOTE on zoom in 1.0.3: there are NO OMCZoomAction / OMCZoomState classes
// in this binary (zero hits in its string and ObjC metadata). Zoom state is
// simply SCPCarSplit's `zoomedSlot` (NSNumber, nil = no zoom) plus the
// frame recomputation in relayout. Those class names exist only in a
// later repack's separate fullscreen dylib.

#import "SCPCarSplit.h"
#import "SCPCarPane.h"
#import "SCPCommon.h" // [phase2; backported to src in phase 3] OMC* declarations used in this TU
#import "SCPSmallClasses.h" // [phase2; backported to src in phase 3] SCPHostedAppVC interface used in this TU

extern void SCPDispatchAfter(double delaySeconds, void (^block)(void)); // 0x12efc (A, SCPShared)

@implementation SCPCarSplit (Zoom)

// MARK: - Zoom (expand / restore)

- (void)toggleZoomForPane:(SCPCarPane *)pane {                           // 0x251b0
    if (!self.active) return;
    if (pane.vc == nil || pane.slot == 9) return;
    if (self.paneCount < 2) return;
    BOOL zooming;
    if (self.zoomedSlot != nil && self.zoomedSlot.intValue == pane.slot) {
        self.zoomedSlot = nil;
        zooming = NO;
    } else {
        self.zoomedSlot = @(pane.slot);
        zooming = YES;
    }
    OMCLogWrite(@"SplitScreen",
        [NSString stringWithFormat:@"CarSplit: %@ o %d (%@)",
            zooming ? @"phong to" : @"thu nho", pane.slot, pane.bundleID]);
    [self setBarVisible:NO forPane:pane];
    [self relayoutAnimated:YES];
}

- (void)urlZoomPane:(int)n {                                             // 0x24ff0
    [self toggleZoomForPane:[self paneAtSlot:n - 1]];
}

// Pane double-tap: float pane toggles its size, a split pane zooms.
// CLOSURE CORRECTION: the @catch format is the UTF-16 cfstring
// 'CarSplit: loi cham dup thanh ••• %@' @0x7c080 — the earlier draft's
// single character "C" was the first byte of its UTF-16LE encoding,
// misread as text (same misread family as the OMCTr keys below).
- (void)handleDoubleTapped:(UITapGestureRecognizer *)gr {                // 0x25048
    @try {
        SCPCarPane *pane = [self paneForView:gr.view];
        if (pane == self.floatPane) [self floatHandleDoubleTapped:gr];
        else [self toggleZoomForPane:pane];
    } @catch (id exception) {
        OMCLogWrite(@"SplitScreen",
            [NSString stringWithFormat:@"CarSplit: loi cham dup thanh ••• %@", exception]);
    }
}

// Pane handle tap: toggle that pane's chrome bar.
- (void)handleTapped:(UITapGestureRecognizer *)gr {                      // 0x253e4
    @try {
        SCPCarPane *pane = [self paneForView:gr.view];
        if (pane != nil)
            [self setBarVisible:pane.bar.isHidden forPane:pane];
    } @catch (id exception) {
        OMCLogWrite(@"SplitScreen",
            [NSString stringWithFormat:@"CarSplit: loi cham thanh ••• %@", exception]);
    }
}

// Valid layout ids are exactly {2, 3, 13, 31}: the binary tests
// (1 << id) & 0x8000200c after range-checking 0 <= id <= 31.
- (void)urlLayout:(NSInteger)layoutID {                                  // 0x24dc8
    if (layoutID < 0 || layoutID > 31) return;
    if (((1 << layoutID) & 0x8000200c) == 0) return;
    if (self.active) {
        [self switchToLayout:(int)layoutID];
    } else if ([self activateWithLayout:(int)layoutID]) {
        [self showPickersForEmptySlots];
    }
}

- (void)urlRatio:(double)ratio {                                         // 0x24e44
    if (!self.active || self.paneCount != 2 || self.mainStack) return;
    double r = MIN(MAX(ratio, 0.2), 0.8);
    self.fractions = [NSMutableArray arrayWithObjects:@(r), @(1.0 - r), nil];
    [self relayoutAnimated:YES];
    [self rememberPair];
}

- (void)urlSwap {                                                        // 0x24f98
    if (!self.active || self.paneCount < 2) return;
    [self swapSlot:0 with:1];
    [self relayoutAnimated:YES];
}

// MARK: - Floating pane lifecycle

- (SCPCarPane *)ensureFloatPane {                                        // 0x1f040
    if (self.floatPane != nil) return self.floatPane;
    if (self.container == nil) return nil;
    SCPCarPane *pane = [self newPane];
    pane.slot = 9;
    pane.view.layer.borderWidth = 1.0;
    pane.view.layer.borderColor =
        [UIColor colorWithWhite:1.0 alpha:0.85].CGColor;
    [self.container addSubview:pane.view];
    self.floatPane = pane;
    self.floatLarge = NO;
    CGSize size = [self floatSizeLarge:NO];
    CGRect bounds = self.container.bounds;
    self.floatFrame = CGRectMake(bounds.size.width - size.width - 8.0,
                                 bounds.size.height - size.height - 8.0,
                                 size.width, size.height);
    [self fitFloatFrame];
    pane.view.frame = self.floatFrame;
    pane.host.frame = pane.view.bounds;
    pane.view.alpha = 0;
    pane.view.transform = CGAffineTransformMakeScale(0.6, 0.6);
    [UIView animateWithDuration:0.45 delay:0
         usingSpringWithDamping:0.75 initialSpringVelocity:0.5 options:0
        animations:^{                                                     // block @0x1f4f8 VERIFIED
            pane.view.alpha = 1;
            pane.view.transform = CGAffineTransformIdentity;
        } completion:nil];
    OMCLogWrite(@"SplitScreen",
        [NSString stringWithFormat:@"CarSplit: mo cua so noi %@",
            NSStringFromCGRect(self.floatFrame)]);
    return pane;
}

// Float size presets, clamped component-wise and finally to bounds - 16:
//   small: w = clamp(W * 0.30, 160, 240), h = clamp(H * 0.45,  96, 170)
//   large: w = clamp(W * 0.45, 220, 360), h = clamp(H * 0.62, 130, 260)
- (CGSize)floatSizeLarge:(BOOL)large {                                   // 0x1f5a4
    CGSize b = self.container.bounds.size;
    double w = large ? MIN(MAX(b.width * 0.45, 220.0), 360.0)
                     : MIN(MAX(b.width * 0.30, 160.0), 240.0);
    double h = large ? MIN(MAX(b.height * 0.62, 130.0), 260.0)
                     : MIN(MAX(b.height * 0.45, 96.0), 170.0);
    return CGSizeMake(MIN(w, b.width - 16.0), MIN(h, b.height - 16.0));
}

- (void)floatHandleDoubleTapped:(UITapGestureRecognizer *)gr {           // 0x1f678
    [self toggleFloatSize];
}

// Resize around the anchored corner: if the pane's centre is past the
// container's centre on an axis, that axis stays anchored to the max edge.
- (void)toggleFloatSize {                                                // 0x1f67c
    @try {
        SCPCarPane *pane = self.floatPane;
        if (pane == nil || self.container == nil) return;
        self.floatLarge = !self.floatLarge;
        CGSize size = [self floatSizeLarge:self.floatLarge];
        CGRect frame = self.floatFrame;
        CGRect bounds = self.container.bounds;
        double newX = frame.origin.x;
        double newY = frame.origin.y;
        if (CGRectGetMidX(frame) > CGRectGetMidX(bounds))
            newX = CGRectGetMaxX(frame) - size.width;
        if (CGRectGetMidY(frame) > CGRectGetMidY(bounds))
            newY = CGRectGetMaxY(frame) - size.height;
        self.floatFrame = CGRectMake(newX, newY, size.width, size.height);
        [self setBarVisible:NO forPane:pane];
        OMCLogWrite(@"SplitScreen",
            [NSString stringWithFormat:@"CarSplit: cua so noi %@ %@",
                self.floatLarge ? @"lon" : @"nho", NSStringFromCGSize(size)]);
        [self relayoutAnimated:YES];
    } @catch (id exception) {
        OMCLogWrite(@"SplitScreen",
            [NSString stringWithFormat:@"CarSplit: loi doi co cua so noi %@",
                exception]);
    }
}

// Clamp the float frame inside the container: 8 pt margins, with the max
// origin computed against MIN(size, bounds - 16) on each axis.
- (void)fitFloatFrame {                                                  // 0x1f9d8
    if (self.floatPane == nil || self.container == nil) return;
    CGSize bounds = self.container.bounds.size;
    CGRect f = self.floatFrame;
    self.floatClosing = NO;
    double maxY = bounds.height - MIN(f.size.height, bounds.height - 16.0) - 8.0;
    double maxX = bounds.width - MIN(f.size.width, bounds.width - 16.0) - 8.0;
    f.origin.y = MIN(MAX(f.origin.y, 8.0), maxY);
    f.origin.x = MIN(MAX(f.origin.x, 8.0), maxX);
    self.floatFrame = f;
}

- (void)closeFloat:(BOOL)background {                                    // 0x1fb1c
    SCPCarPane *pane = self.floatPane;
    if (pane == nil) return;
    NSString *bundle = pane.bundleID;
    [pane.barTimer invalidate];
    pane.barTimer = nil;
    [self removePickerFromPane:pane];
    [self removeLoaderFromPane:pane animated:NO];
    if (pane.vc != nil)
        [self detachVC:pane.vc background:background];
    pane.vc = nil;
    pane.bundleID = nil;
    self.floatPane = nil;
    self.floatClosing = NO;
    self.floatReturnLayout = 0;
    self.floatReturnFractions = nil;
    // Drop pending entries that targeted the float slot (slot 9).
    for (NSString *key in self.pending.allKeys) {
        NSArray *entry = self.pending[key];
        if ([entry[0] intValue] == 9)
            [self.pending removeObjectForKey:key];
    }
    UIView *view = pane.view;
    [UIView animateWithDuration:0.2
        animations:^{                                                     // block @0x1ffec VERIFIED
            view.alpha = 0;
            view.transform = CGAffineTransformMakeScale(0.8, 0.8);
        } completion:^(BOOL finished) {                                  // block @0x2004c VERIFIED
            [view removeFromSuperview];
        }];
    OMCLogWrite(@"SplitScreen",
        [NSString stringWithFormat:@"CarSplit: dong cua so noi (%@), con %d o",
            bundle, (int)self.paneCount]);
    if (self.active) {
        if (self.paneCount > 1) [self relayoutAnimated:YES];
        else [self afterPaneRemoved:bundle];
    }
}

// MARK: - Pop out / dock back

- (BOOL)canPopOutPane:(SCPCarPane *)pane {                               // 0x20040 (approx.)
    return [self popOutBlockReason:pane] == nil;
}

// nil when the pane may pop out; otherwise a localized reason (shown as a
// toast). CLOSURE CORRECTION: the OMCTr keys are ordinary Vietnamese
// UTF-16 cfstrings — 'Ô chưa có app' @0x7bcc0 (its first code unit U+00D4
// is "Ô"; the earlier draft read only its first byte 0xD4) and
// 'Cần ít nhất 2 ô' @0x7bd00 (first byte 0x43 = "C", likewise misread).
- (NSString *)popOutBlockReason:(SCPCarPane *)pane {                     // 0x20054
    if (pane == nil || pane == self.floatPane || pane.vc == nil ||
        pane.bundleID == nil)
        return OMCTr(@"Ô chưa có app", @"This pane has no app");
    if (self.floatPane.vc != nil) return nil;   // a swap is possible
    if (self.paneCount <= 1)
        return OMCTr(@"Cần ít nhất 2 ô", @"Needs at least 2 panes");
    return nil;
}

- (void)panePopOut:(UIGestureRecognizer *)gr {                           // 0x201d8 (approx.)
    [self popOutPane:[self paneForView:gr.view]];
}

- (void)popOutPane:(SCPCarPane *)pane {                                  // 0x20244
    if (pane == self.floatPane) {
        [self floatDockBack];
        return;
    }
    NSString *reason = [self popOutBlockReason:pane];
    if (reason != nil) {
        [self toast:reason];
        return;
    }
    [self setBarVisible:NO forPane:pane];
    SCPHostedAppVC *vc = (SCPHostedAppVC *)pane.vc; // [phase2; backported to src in phase 3] pane.vc is UIViewController* in SCPCarPane.h; hosted panes carry SCPHostedAppVC
    NSString *bundle = pane.bundleID;
    SCPCarPane *oldFloat = self.floatPane;
    if (oldFloat.vc != nil) {
        // Swap: the floating app takes the slot, the slot app floats.
        SCPHostedAppVC *floatVC = (SCPHostedAppVC *)oldFloat.vc; // [phase2; backported to src in phase 3] same cast as above
        NSString *floatBundle = oldFloat.bundleID;
        [self removePickerFromPane:oldFloat];
        [vc.view removeFromSuperview];
        [floatVC.view removeFromSuperview];
        vc.view.frame = oldFloat.host.bounds;
        [oldFloat.host addSubview:vc.view];
        floatVC.view.frame = pane.host.bounds;
        [pane.host addSubview:floatVC.view];
        oldFloat.vc = vc;
        oldFloat.bundleID = bundle;
        oldFloat.sceneSize = CGSizeZero;
        pane.vc = floatVC;
        pane.bundleID = floatBundle;
        pane.sceneSize = CGSizeZero;
        OMCLogWrite(@"SplitScreen",
            [NSString stringWithFormat:@"CarSplit: hinh trong hinh doi cho %@ (o %d) <-> %@ (cua so noi)",
                bundle, pane.slot, floatBundle]);
        [self rememberPair];
        [self rememberRecent];
        [self relayoutAnimated:YES];
        return;
    }
    // Fresh pop-out: stash the origin layout for floatDockBack.
    self.floatReturnLayout = (int)self.layoutID;
    self.floatReturnSlot = pane.slot;
    self.floatReturnFractions = [self.fractions copy];
    SCPCarPane *floatPane = [self ensureFloatPane];
    if (floatPane == nil) return;
    [self removePickerFromPane:floatPane];
    [vc.view removeFromSuperview];
    vc.view.frame = floatPane.host.bounds;
    [floatPane.host addSubview:vc.view];
    floatPane.vc = vc;
    floatPane.bundleID = bundle;
    floatPane.sceneSize = CGSizeZero;
    pane.vc = nil;
    pane.bundleID = nil;
    OMCLogWrite(@"SplitScreen",
        [NSString stringWithFormat:@"CarSplit: dua %@ tu o %d ra cua so noi",
            bundle, pane.slot]);
    [self removePaneAt:pane.slot background:NO];
    [self afterPaneRemoved:nil];
}

// Dock the floating app back into the split. When the layout that was
// stashed at pop-out still fits (pane count + 1, fractions length), the
// exact layout — kind, fractions and slot — is restored; otherwise the
// pane is appended with equal fractions.
- (void)floatDockBack {                                                  // 0x139dc
    SCPCarPane *pane = self.floatPane;
    NSInteger count = self.paneCount;
    if (pane.vc == nil || pane.bundleID == nil) return;
    if (count >= 3) {
        // CLOSURE (task item 3): the key @0x7b220 is the UTF-16 cfstring
        // 'Đã đủ 3 ô, không đưa về được' (28 characters; the raw bytes
        // 10 01 E3 ... are its UTF-16LE encoding — fully recovered as a
        // plain string literal, no byte-array construction needed).
        [self toast:OMCTr(@"Đã đủ 3 ô, không đưa về được", @"Already 3 panes, can't dock back")];
        return;
    }
    NSInteger returnLayout = self.floatReturnLayout;
    BOOL exact = NO;
    NSInteger insertAt = count;
    if (returnLayout != 0) {
        NSInteger needed = (returnLayout == 13 || returnLayout == 31)
            ? 3 : (((returnLayout & ~1) == 2) ? returnLayout : 2);
        if (needed == count + 1) {
            exact = YES;
            NSInteger slot = self.floatReturnSlot;
            if (slot >= 0 && slot <= count) insertAt = slot;
        }
    }
    [self setBarVisible:NO forPane:pane];
    SCPCarPane *slotPane = [self insertPaneAt:(int)insertAt];
    if (slotPane == nil) return;
    self.layoutKind = exact ? ((returnLayout == 31) ? 2
                             : (returnLayout == 13) ? 1 : 0)
                            : 0;
    NSInteger expected = (self.layoutKind == 0) ? count + 1 : 2;
    if (exact && (NSInteger)self.floatReturnFractions.count == expected)
        self.fractions = [self.floatReturnFractions mutableCopy];
    else
        [self resetFractions];
    [self rebuildDividers];

    SCPHostedAppVC *vc = (SCPHostedAppVC *)pane.vc; // [phase2; backported to src in phase 3] cast as in popOutPane:
    NSString *bundle = pane.bundleID;
    [vc.view removeFromSuperview];
    vc.view.frame = slotPane.host.bounds;
    [slotPane.host addSubview:vc.view];
    slotPane.vc = vc;
    slotPane.bundleID = bundle;
    slotPane.sceneSize = CGSizeZero;
    pane.vc = nil;
    pane.bundleID = nil;
    [pane.barTimer invalidate];
    pane.barTimer = nil;
    self.floatPane = nil;
    self.floatClosing = NO;
    self.floatReturnLayout = 0;
    self.floatReturnFractions = nil;
    UIView *view = pane.view;
    [UIView animateWithDuration:0.2
        animations:^{                                                     // block @0x140ec VERIFIED
            view.alpha = 0;
            view.transform = CGAffineTransformMakeScale(0.8, 0.8);
        } completion:^(BOOL finished) {                                  // block @0x1414c VERIFIED
            [view removeFromSuperview];
        }];
    self.focusedSlot = slotPane.slot;
    OMCLogWrite(@"SplitScreen",
        [NSString stringWithFormat:@"CarSplit: dua %@ tu cua so noi ve o %d (bo cuc %d%@)",
            bundle, slotPane.slot, (int)self.layoutID,
            exact ? @", nhu truoc" : @""]);
    [self rememberPair];
    [self rememberRecent];
    [self relayoutAnimated:YES];
}

// MARK: - Float dragging

static CGPoint sFloatDragStartOrigin;   // 0x88138 / 0x88140 (floatPanned:)
static CGPoint sFloatGrabPoint;         // 0x88148 / 0x88150 (floatDragPhase:)
static CGPoint sFloatOriginAtGrab;      // 0x88158 / 0x88160 (floatDragPhase:)

- (void)floatPanned:(UIPanGestureRecognizer *)gr {                       // 0x20a30
    SCPCarPane *pane = self.floatPane;
    if (pane == nil || self.container == nil) return;
    if (gr.state == UIGestureRecognizerStateBegan) {
        sFloatDragStartOrigin = self.floatFrame.origin;
        [self setBarVisible:NO forPane:pane];
        [self hideRatioMenu];
    }
    CGPoint t = [gr translationInView:self.container];
    CGRect f = self.floatFrame;
    f.origin = CGPointMake(sFloatDragStartOrigin.x + t.x,
                           sFloatDragStartOrigin.y + t.y);
    if (gr.state >= 3 && gr.state <= 5) {
        CGRect bounds = self.container.bounds;
        f.origin.x = (CGRectGetMidX(f) < CGRectGetMidX(bounds))
            ? 8.0 : bounds.size.width - f.size.width - 8.0;
        self.floatFrame = f;
        [self relayoutAnimated:YES];
        OMCLogWrite(@"SplitScreen",
            [NSString stringWithFormat:@"CarSplit: tha cua so noi o %@",
                NSStringFromCGRect(self.floatFrame)]);
    } else {
        self.floatFrame = f;
        [CATransaction begin];
        [CATransaction setDisableActions:YES];
        pane.view.frame = f;
        [CATransaction commit];
        if ([self hostedPanes].count > 0)
            [self pushHostFramesLive:YES];
    }
}

// The same drag driven remotely (point in container coordinates):
// phase 0 = grab, 1 = move, anything else = release + edge snap.
- (void)floatDragPhase:(NSInteger)phase at:(CGPoint)point {              // 0x284e8
    SCPCarPane *pane = self.floatPane;
    if (pane == nil || self.container == nil) return;
    if (phase == 0) {
        sFloatGrabPoint = point;
        sFloatOriginAtGrab = self.floatFrame.origin;
        [self setBarVisible:NO forPane:pane];
        [self hideRatioMenu];
        return;
    }
    CGRect f = self.floatFrame;
    f.origin = CGPointMake(point.x + sFloatOriginAtGrab.x - sFloatGrabPoint.x,
                           point.y + sFloatOriginAtGrab.y - sFloatGrabPoint.y);
    if (phase == 1) {
        self.floatFrame = f;
        [CATransaction begin];
        [CATransaction setDisableActions:YES];
        pane.view.frame = f;
        [CATransaction commit];
        [self pushHostFramesLive:YES];
        return;
    }
    CGRect bounds = self.container.bounds;
    f.origin.x = (CGRectGetMidX(f) < CGRectGetMidX(bounds))
        ? 8.0 : bounds.size.width - f.size.width - 8.0;
    self.floatFrame = f;
    [self relayoutAnimated:YES];
    OMCLogWrite(@"SplitScreen",
        [NSString stringWithFormat:@"CarSplit: tha cua so noi (app iPhone) o %@",
            NSStringFromCGRect(self.floatFrame)]);
}

@end
