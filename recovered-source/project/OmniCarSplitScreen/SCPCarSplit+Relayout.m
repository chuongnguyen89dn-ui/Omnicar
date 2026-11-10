// SCPCarSplit+Relayout.m — [phase2 merge extraction]
// The ONLY two methods taken from src/SplitScreenB/handoff/
// SCPCarSplit+Layout_A-owned.m: -relayoutAnimated: and
// -relayoutAnimated:pushScenes:. Every other handoff method duplicates
// an implementation in A's SCPCarSplit.m (layoutID, setPaneCount:,
// switchToLayout:, swapSlot:with:, rootDidLayout, openSetupLayout:apps:,
// activateWithLayout:, layoutChosenID:, paneSize:forBundle:) or in
// SCPSmallClasses.m (SCPNoopLayoutAssertion), and the handoff file's own
// header says it is cross-check material, NOT a build unit — so the
// handoff files are NOT compiled. The relayout pair is the exception:
// no A/B/C source implements it (A only calls it; A's header assigned it
// to B's domain), and B's VERIFIED decode exists only in the handoff.
// Bodies below are verbatim from the handoff file.

#import "SCPCarSplit.h"
#import "SCPCommon.h"

@implementation SCPCarSplit (Layout)

// VERIFIED (@0x110cc): dividers run along the main axis, except the
// second divider of a main-stack layout, which flips.
// VERIFIED (@0x1b444): one-argument relayout always pushes scene sizes.
- (void)relayoutAnimated:(BOOL)animated
{
    [self relayoutAnimated:animated pushScenes:YES];
}

// VERIFIED (@0x1b44c, animation block @0x1ba18): validates the zoom
// state, then applies every pane/divider/float frame inside one spring
// animation (0.45 s, damping 0.86, velocity 0.4, options 6) or directly
// when not animated. Panes whose frame degenerates (<= 1 pt in either
// dimension) or which are not the zoomed pane while zoomed get alpha 0;
// pane view interaction is then synced to (alpha > 0), the float view
// is forced interactive, dividers follow dividersVisible, and scene
// sizes / host frames are pushed.
- (void)relayoutAnimated:(BOOL)animated pushScenes:(BOOL)pushScenes
{
    if (!self.container) {
        return;
    }
    if (self.pickerSheet) {
        [self refreshPickerSheetSoon];
    }
    if (self.zoomedSlot) {
        NSInteger z = self.zoomedSlot.intValue;
        SCPCarPane *zoomPane = nil;
        if (z >= 0 && z < (NSInteger)self.slots.count) {
            zoomPane = self.slots[(NSUInteger)z];
        }
        if (!(self.active && self.paneCount >= 2 && z < self.paneCount && zoomPane.vc)) {
            OMCLogWrite(@"SplitScreen",
                        [NSString stringWithFormat:@"CarSplit: bo phong to o %d", (int)z]);
            self.zoomedSlot = nil;
            zoomPane = nil;
        }
    }
    BOOL dv = self.dividersVisible;
    if (self.floatPane) {
        [self fitFloatFrame];
    }
    NSNumber *zoomedSlot = self.zoomedSlot;
    SCPCarPane *floatPane = self.floatPane;
    void (^animations)(void) = ^{
        for (SCPCarPane *pane in self.slots) {
            CGRect f = [self frameForSlot:pane.slot];
            CGFloat alpha = 0.0;
            if (f.size.width > 1.0 && f.size.height > 1.0) {
                alpha = zoomedSlot ? (zoomedSlot.intValue == pane.slot ? 1.0 : 0.0)
                                   : 1.0;
            }
            pane.view.frame = f;
            pane.view.alpha = alpha;
            NSUInteger corners = [self innerCornersForSlot:pane.slot];
            pane.view.layer.cornerRadius = (corners == 0) ? 0.0 : 6.0;
            pane.view.layer.maskedCorners = (CACornerMask)corners;
            pane.host.frame = pane.view.bounds;
            pane.picker.frame = pane.view.bounds;
            [self layoutBarForPane:pane];
        }
        for (SCPCarDividerView *divider in self.dividers) {
            divider.frame = [self dividerFrameAt:divider.index];
            divider.alpha = dv ? 1.0 : 0.0;
            [self layoutKnobOf:divider];
        }
        if (self.mainStack && self.dividers.count > 0) {
            [self.container bringSubviewToFront:self.dividers[0]];
        }
        if (floatPane) {
            floatPane.view.frame = self.floatFrame;
            floatPane.view.alpha = 1.0;
            floatPane.view.layer.cornerRadius = 6.0;
            floatPane.view.layer.maskedCorners = 15;
            floatPane.host.frame = floatPane.view.bounds;
            floatPane.picker.frame = floatPane.view.bounds;
            [self layoutBarForPane:floatPane];
            [self.container bringSubviewToFront:floatPane.view];
        }
        if (zoomedSlot && zoomedSlot.intValue < (NSInteger)self.slots.count) {
            [self.container bringSubviewToFront:self.slots[(NSUInteger)zoomedSlot.intValue].view];
        }
        if (floatPane) {
            [self.container bringSubviewToFront:floatPane.view];
        }
        if (self.dragGhost) {
            [self.container bringSubviewToFront:self.dragGhost];
        }
        if (self.ratioMenu && self.ratioMenu.superview == self.container) {
            [self.container bringSubviewToFront:self.ratioMenu];
        }
    };
    if (animated) {
        [UIView animateWithDuration:0.45
                              delay:0.0
             usingSpringWithDamping:0.86
              initialSpringVelocity:0.4
                            options:6
                         animations:animations
                         completion:nil];
    } else {
        animations();
    }
    for (SCPCarPane *pane in self.slots) {
        pane.view.userInteractionEnabled = (pane.view.alpha > 0.0);
    }
    if (self.floatPane) {
        self.floatPane.view.userInteractionEnabled = YES;
    }
    for (SCPCarDividerView *divider in self.dividers) {
        divider.userInteractionEnabled = dv;
    }
    if (pushScenes) {
        [self pushSceneSizes];
    }
    [self pushHostFramesLive:!pushScenes];
    // [hl8diag] Compare actual pane rectangles and scene-size requests
    // on every distinct resize. This is a read-only witness; keyboard
    // surfaces might belong to another process (absence is BLIND).
    if ([OMCPref(@"hl8.unifiedDiag", @YES) boolValue]) {
        static NSString *hl8LastGeometry;
        NSMutableString *rows = [NSMutableString string];
        for (SCPCarPane *p in self.slots) {
            if (!p.bundleID.length && !p.vc) continue;
            [rows appendFormat:@"slot=%ld:%@:%@:%@;",
                (long)p.slot, p.bundleID ?: @"native-or-empty",
                NSStringFromCGRect(p.view.frame),
                NSStringFromCGSize(p.sceneSize)];
        }
        UIView *parent = self.container.superview;
        CGRect area = parent ? [self appAreaInParent:parent] : CGRectNull;
        NSString *snapshot = [NSString stringWithFormat:
            @"container=%@ area=%@ panes=%@",
            NSStringFromCGRect(self.container.frame),
            NSStringFromCGRect(area), rows];
        if (![snapshot isEqualToString:hl8LastGeometry]) {
            hl8LastGeometry = [snapshot copy];
            OMCLogWrite(@"SplitScreen", [NSString stringWithFormat:
                @"[hl8diag] eye=layout ev=car-relayout animated=%d "
                 "pushScenes=%d active=%d zoom=%@ %@",
                (int)animated, (int)pushScenes, (int)self.active,
                self.zoomedSlot ?: @"none", snapshot]);
            NSUInteger count = 0;
            NSMutableString *windows = [NSMutableString string];
            for (UIWindow *w in [UIApplication sharedApplication].windows) {
                NSString *name = NSStringFromClass(w.class);
                if ([name containsString:@"Keyboard"] ||
                    [name containsString:@"InputSet"]) {
                    count++;
                    if (windows.length < 320)
                        [windows appendFormat:@"%@:%@:%d;",
                            name, NSStringFromCGRect(w.frame), (int)w.hidden];
                }
            }
            OMCLogWrite(@"SplitScreen", [NSString stringWithFormat:
                @"[hl8diag] eye=kb-car ev=layout-scan keyboardWindows=%lu "
                 "sample=%@ scope=CarPlayApp noMatchMeans=BLIND",
                (unsigned long)count, windows]);
        }
    }
}

@end
