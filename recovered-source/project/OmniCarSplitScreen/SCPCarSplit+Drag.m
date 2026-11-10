// SCPCarSplit+Drag.m — OmniCarSplitScreen reconstruction, module SplitScreenB.
// Long-press pane dragging: a floating "ghost" card follows the finger and
// dropping it on another pane swaps the two slots (swapSlot:with:).
//
// The ghost is hosted in the tray window when one exists (same host choice
// as the ratio menu), so it can float above hosted app panes.

#import "SCPCarSplit.h"
#import "SCPCarPane.h"
#import "SCPCommon.h" // [phase2; backported to src in phase 3] OMC* declarations used in this TU
#import "SCPCarSplit+AutoHide.h" // [autohide] drag-end activity feed at endPaneDrag: (design-autohide §4.2, car1 §4.4)

// Shared helpers (other modules / shared core):
extern void SCPDispatchAfter(double delaySeconds, void (^block)(void)); // 0x12efc (A)
// App icon lookup for a bundle id (static helper @0xdec8; name INFERRED).
extern UIImage *SCPAppIconForBundle(NSString *bundleID);
// Styling helpers — CLOSED in the wave-3 closure pass (bodies read
// line-by-line from the dumps; see the "Closure addendum" in
// SplitScreenB_REPORT.md). Defined here, exported for Picker/Panel.

// @0x271e4 — frosted white ghost styling (toast labels, icon buttons,
// drag ghost): white 0.9 background, hairline border, soft shadow.
void SCPStyleDragGhost(UIView *view, double radius) {
    view.backgroundColor = [UIColor colorWithWhite:1 alpha:0.9];
    view.layer.cornerRadius = radius;
    view.layer.cornerCurve = kCACornerCurveContinuous;
    view.layer.borderWidth = 0.5;
    view.layer.borderColor = [UIColor colorWithWhite:1 alpha:0.85].CGColor;
    view.layer.shadowColor = [UIColor colorWithRed:0.43137254901960786
                                             green:0.39215686274509803
                                              blue:0.7843137254901961
                                             alpha:1.0].CGColor;
    view.layer.shadowOpacity = 0.25f;
    view.layer.shadowRadius = 10;
    view.layer.shadowOffset = CGSizeMake(0, 4);
}

// @0x21158 — app-icon look: squircle corners (27% of the width),
// clipped; an icon-less view gets the pale ghost background.
void SCPStyleGhostIcon(UIImageView *imageView) {
    imageView.layer.cornerRadius = imageView.bounds.size.width * 0.27;
    imageView.layer.cornerCurve = kCACornerCurveContinuous;
    imageView.clipsToBounds = YES;
    imageView.backgroundColor = imageView.image != nil
        ? UIColor.clearColor
        : [UIColor colorWithRed:0.9333333333333333 green:0.9411764705882353
                           blue:0.984313725490196 alpha:1.0];
}

@implementation SCPCarSplit (Drag)

// Pan on a pane's drag handle. The float pane has its own pan path.
- (void)handlePanned:(UIPanGestureRecognizer *)gr {                      // 0x26834
    @try {
        SCPCarPane *pane = [self paneForView:gr.view];
        if (pane == nil || self.container == nil) {
            [self cancelPaneDrag];
            return;
        }
        if (pane == self.floatPane) {
            [self floatPanned:gr];
            return;
        }
        CGPoint point = [gr locationInView:self.container];
        switch (gr.state) {
            case UIGestureRecognizerStateBegan:
                [self beginPaneDrag:pane at:point];
                break;
            case UIGestureRecognizerStateChanged:
                [self movePaneDragTo:point from:pane];
                break;
            case UIGestureRecognizerStateEnded:
                [self endPaneDrag:pane];
                break;
            default:
                [self cancelPaneDrag];
                break;
        }
    } @catch (id exception) {
        OMCLogWrite(@"SplitScreen",
            [NSString stringWithFormat:@"CarSplit: loi keo doi cho %@",
                exception]);
        [self cancelPaneDrag];
    }
}

- (void)beginPaneDrag:(SCPCarPane *)pane at:(CGPoint)point {             // 0x26a98
    if (self.paneCount < 2) return;
    if (pane.vc == nil) return;
    if (self.dragGhost != nil) return;
    for (SCPCarPane *p in self.allPanes)
        [self setBarVisible:NO forPane:p];
    [self hideRatioMenu];
    [self beginResize];
    pane.cover.alpha = 0.55;

    // Ghost card: 40% of the pane's size, clamped per axis.
    CGSize viewSize = pane.view.bounds.size;
    double ghostW = MIN(MAX(viewSize.width * 0.4, 88.0), 180.0);
    double ghostH = MIN(MAX(viewSize.height * (ghostW / MAX(viewSize.width, 1.0)),
                            72.0),
                        130.0);
    UIView *ghost = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ghostW, ghostH)];
    SCPStyleDragGhost(ghost, 16.0);                                     // @0x271e4
    ghost.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.92];
    ghost.layer.borderColor =
        [UIColor colorWithRed:0.6078431372549019
                        green:0.5294117647058824
                         blue:0.9725490196078431
                        alpha:1.0].CGColor;
    ghost.layer.borderWidth = 1.5;
    // [hl18-perf] This card moves on every drag sample. A fixed rounded
    // shadowPath avoids recompositing an unconstrained shadow each time.
    ghost.layer.shadowPath =
        [UIBezierPath bezierPathWithRoundedRect:ghost.bounds
                                  cornerRadius:ghost.layer.cornerRadius].CGPath;
    ghost.userInteractionEnabled = NO;

    UIImageView *icon = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    icon.image = SCPAppIconForBundle(pane.bundleID);                    // @0xdec8
    SCPStyleGhostIcon(icon);                                            // @0x21158
    icon.center = CGPointMake(ghostW * 0.5, ghostH * 0.5);
    [ghost addSubview:icon];

    UIWindow *window = [self trayWindowForParent:self.container];
    UIView *host = window != nil ? (UIView *)window : self.container;
    if (window != nil)
        point = [self.container convertPoint:point toView:nil];
    ghost.center = point;
    [host addSubview:ghost];

    self.dragGhost = ghost;
    self.dragTarget = -1;
    ghost.transform = CGAffineTransformMakeScale(0.6, 0.6);
    [UIView animateWithDuration:0.3 delay:0
         usingSpringWithDamping:0.7 initialSpringVelocity:0.5 options:6
        animations:^{                                                     // block @0x27458 VERIFIED (setTransform: only)
            ghost.transform = CGAffineTransformIdentity;
        } completion:nil];
    OMCLogWrite(@"SplitScreen",
        [NSString stringWithFormat:@"CarSplit: keo o %d (%@) de doi cho",
            pane.slot, pane.bundleID]);
}

- (void)movePaneDragTo:(CGPoint)point from:(SCPCarPane *)pane {          // @0x27494
    UIView *ghost = self.dragGhost;
    if (ghost == nil) return;
    CGPoint center = point;
    if (ghost.superview != self.container)
        center = [self.container convertPoint:point toView:nil];
    ghost.center = center;

    // Target = the (visible) slot pane whose frame contains the point.
    NSInteger target = -1;
    for (SCPCarPane *p in self.slots) {
        if (p == pane) continue;
        if (p.view.alpha == 0) continue;
        if (CGRectContainsPoint(p.view.frame, point)) {
            target = p.slot;
            break;
        }
    }
    if (target == self.dragTarget) return;
    self.dragTarget = (int)target;
    // Re-mark: accent border on the target pane, none elsewhere
    // (the non-target reset branch is INFERRED: borderWidth 0).
    for (SCPCarPane *p in self.slots) {
        if (p.slot == target) {
            p.view.layer.borderWidth = 3.0;
            p.view.layer.borderColor =
                [UIColor colorWithRed:0.6078431372549019
                                green:0.5294117647058824
                                 blue:0.9725490196078431
                                alpha:1.0].CGColor;
        } else {
            p.view.layer.borderWidth = 0;                                // INFERRED
        }
    }
}

- (void)endPaneDrag:(SCPCarPane *)pane {                                 // 0x27a30 (approx.)
    NSInteger target = self.dragTarget;
    UIView *ghost = self.dragGhost;
    if (ghost == nil) return;
    [self clearPaneDragMarks];
    CGPoint dest;
    if (target >= 0 && target < self.paneCount)
        dest = self.slots[target].view.center;
    else
        dest = pane.view.center;
    if (ghost.superview != self.container)
        dest = [self.container convertPoint:dest toView:nil];
    __weak SCPCarSplit *weakSelf = self;
    [UIView animateWithDuration:0.25
        animations:^{                                                     // block @0x27d7c VERIFIED
            ghost.center = dest;
            ghost.alpha = 0;
            ghost.transform = CGAffineTransformMakeScale(0.7, 0.7);
        } completion:^(BOOL finished) {                                  // block @0x27de8 VERIFIED
            [ghost removeFromSuperview];
            [weakSelf hideTrayWindowIfIdle];
        }];
    pane.cover.alpha = 1.0;
    if (target >= 0 && target != pane.slot)
        [self swapSlot:pane.slot with:(int)target];
    [self endResize];
    [self ahNoteActivity:AHSourceDragEnd]; // [autohide] §4.2: the pane-drag funnel feeds the drag-end re-arm itself — endResize's own feed is resizing-guarded and another path may already have consumed it (additive line; original body untouched)
    // The binary also calls cancelPaneDrag on the invalid-target path;
    // after clearPaneDragMarks that call is a no-op (its dragGhost guard).
}

- (void)clearPaneDragMarks {                                             // 0x27e60 (approx.)
    self.dragGhost = nil;
    self.dragTarget = -1;
    for (SCPCarPane *pane in self.slots) {
        pane.view.layer.borderWidth = 0;   // sub_132cc @0x27ef0: clear the drag-mark border
        pane.cover.alpha = 1.0;
    }
}

- (void)cancelPaneDrag {                                                 // 0x27fcc
    UIView *ghost = self.dragGhost;
    if (ghost == nil) return;
    [self clearPaneDragMarks];
    __weak SCPCarSplit *weakSelf = self;
    [UIView animateWithDuration:0.15
        animations:^{                                                     // block @0x28128 VERIFIED
            ghost.alpha = 0;
        } completion:^(BOOL finished) {                                  // block @0x28134 VERIFIED
            [ghost removeFromSuperview];
            [weakSelf hideTrayWindowIfIdle];
        }];
    [self endResize];
}

@end
