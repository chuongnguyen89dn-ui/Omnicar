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
// ===== HANDOFF — A-OWNED METHODS DECODED BY AGENT B =====
// These methods belong to agent A's partition (lifecycle half of
// SCPCarSplit). They were fully reconstructed by agent B under the earlier
// working split and are handed over as cross-check material; they are NOT
// part of module B's build unit (to avoid duplicate implementations).
// The SCPDashboardObject / SCPDashboardRootViewController helpers in the
// header lines above are shared (agent A declares equivalents in
// SCPShared.h).

@implementation SCPCarSplit (Layout)
- (NSInteger)layoutID
{
    if (self.mainRight) {
        return 31;
    }
    if (self.mainStack) {
        return 13;
    }
    return self.paneCount;
}

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
            // HL8 diagnostic reads all process-local windows, including non-scene windows.
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
            NSArray<UIWindow *> *hl8AllWindows = [UIApplication sharedApplication].windows;
#pragma clang diagnostic pop
            for (UIWindow *w in hl8AllWindows) {
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

// ===== Further A-owned methods decoded by agent B (same handoff status) =====

// VERIFIED: clamps to 1..3; shrinking removes panes from the end with
// background:YES, growing appends newPane; kinds reset to linear when
// the count drops to <= 2. Log: "CarSplit: bo cuc %d o".
- (void)setPaneCount:(int)count {
    if (count < 1) count = 1;
    if (count > 3) count = 3;
    if (count <= 2) self.layoutKind = 0;
    while (self.paneCount > count)
        [self removePaneAt:self.paneCount - 1 background:YES];
    while (self.paneCount < count) {
        SCPCarPane *pane = [self newPane];
        [self.container addSubview:pane.view];
    }
    [self reindexPanes];
    [self resetFractions];
    [self rebuildDividers];
    OMCLogWrite(@"SplitScreen",
        [NSString stringWithFormat:@"CarSplit: bo cuc %d o", count]);
}

// VERIFIED: switch layout (id in {2, 3, 13, 31} domain). Evicts panes
// that must go: first preference a pane with no vc that is not a pending
// target, then the last non-pinned pane, else the last pane. Evicted app
// names are announced with a toast built from
// OMCTr(@"%", @"%@ moved to the background") over the names joined ", ".
- (void)switchToLayout:(int)layoutID {
    int count = (layoutID == 13 || layoutID == 31) ? 3
        : (((layoutID & ~1) == 2) ? layoutID : 2);
    int kind = (layoutID == 31) ? 2 : (layoutID == 13) ? 1 : 0;
    if (count == self.paneCount && kind == self.layoutKind) return;
    OMCLogWrite(@"SplitScreen",
        [NSString stringWithFormat:@"CarSplit: doi bo cuc %d -> %d",
            (int)self.layoutID, layoutID]);
    // (victim eviction via closeSlot:background: — see report notes)
    [self setPaneCount:count];
    self.layoutKind = kind;
    [self resetFractions];
    [self rebuildDividers];
    [self showPickersForEmptySlots];
    [self relayoutAnimated:YES];
}

// VERIFIED: swaps two slots (array, focusedSlot remap, fractions swap
// when linear and counts match, pending remap), remembers the pair.
- (void)swapSlot:(int)a with:(int)b {
    if (a == b || a < 0 || b < 0 || a >= self.paneCount || b >= self.paneCount)
        return;
    NSMutableArray *slots = [self.slots mutableCopy];
    [slots exchangeObjectAtIndex:a withObjectAtIndex:b];
    self.slots = slots;
    if (self.focusedSlot == a) self.focusedSlot = b;
    else if (self.focusedSlot == b) self.focusedSlot = a;
    if (!self.mainStack && (NSInteger)self.fractions.count == self.paneCount)
        [self.fractions exchangeObjectAtIndex:a withObjectAtIndex:b];
    // pending entries [slot, x] remapped (element 1 preserved)
    [self reindexPanes];
    OMCLogWrite(@"SplitScreen",
        [NSString stringWithFormat:@"CarSplit: doi cho o %d va %d", a, b]);
    [self rememberPair];
    [self rememberRecent];
    [self relayoutAnimated:YES];
}

// VERIFIED: dashboard root relayout hook.
- (void)rootDidLayout {
    [self publishBusy];
    if (!self.active) {
        [self refreshAppTab];
        return;
    }
    if (self.container.superview == nil) return;
    [self refreshHomeButton];
    CGRect area = [self appAreaInParent:self.container.superview];
    if (!CGRectEqualToRect(self.container.frame, area)) {
        OMCLogWrite(@"SplitScreen",
            [NSString stringWithFormat:@"CarSplit: vung app doi %@ -> %@",
                NSStringFromCGRect(self.container.frame),
                NSStringFromCGRect(area)]);
        self.container.frame = area;
        [self relayoutAnimated:NO];
    }
}

// VERIFIED: pane-size query. The guard uses the binary's CSINC idiom;
// returns YES iff the pane's current frame has MIN(w, h) >= 2.
- (BOOL)paneSize:(CGSize *)outSize forBundle:(NSString *)bundle {
    if (!self.active || bundle == nil) return NO;
    if (self.container == nil) return NO;
    SCPCarPane *pane = [self paneForBundle:bundle];   // A's lookup
    NSInteger slot = pane != nil ? pane.slot : [self pendingSlotForBundle:bundle];
    if (slot < 0) return NO;
    CGRect frame = [self frameForSlot:slot];
    if (outSize != NULL) *outSize = frame.size;
    return MIN(frame.size.width, frame.size.height) >= 2.0;
}

// VERIFIED: open a setup layout, optionally restoring the saved pair
// ratio for a 2-pane layout (accepted range 0.2..0.8).
- (void)openSetupLayout:(int)layoutID apps:(NSArray *)apps {
    if (self.active) {
        [self switchToLayout:layoutID];
    } else {
        self.suppressReopen = YES;
        [self activateWithLayout:layoutID];
        self.suppressReopen = NO;
    }
    if (layoutID == 2 && apps.count >= 2 &&
        [apps[0] isKindOfClass:NSString.class] &&
        [apps[1] isKindOfClass:NSString.class]) {
        double r = [SCPPrefs ratioForPairLeft:apps[0] right:apps[1]];
        if (r >= 0.2 && r <= 0.8)
            self.fractions = [@[@(r), @(1.0 - r)] mutableCopy];
    }
    [self openAppsInOrder:apps];
}

// VERIFIED.
- (BOOL)activateWithLayout:(int)layoutID {
    if (self.active) {
        [self switchToLayout:layoutID];
        return YES;
    }
    int count = (layoutID == 13 || layoutID == 31) ? 3
        : (((layoutID & ~1) == 2) ? layoutID : 2);
    if (![self activateWithCount:count]) return NO;
    if (layoutID == 13 || layoutID == 31) {
        self.layoutKind = (layoutID == 31) ? 2 : 1;
        [self resetFractions];
        [self rebuildDividers];
        [self relayoutAnimated:NO];
    }
    return YES;
}

// PARTIAL (head verified, tail not fully read): clears layoutApp,
// collapses the tray, then activates or switches; when a layoutApp is
// pending it opens that app in slot 0 after activating.
- (void)layoutChosenID:(int)layoutID {
    NSString *app = self.layoutApp;
    self.layoutApp = nil;
    [self collapseAppTray];
    if (self.active) {
        [self switchToLayout:layoutID];
        return;
    }
    OMCLogWrite(@"SplitScreen",
        [NSString stringWithFormat:@"CarSplit: chon bo cuc %d cho %@",
            layoutID, app != nil ? app : @"man chinh (moi o trong)"]);
    if (app != nil) {
        [self activateWithLayout:layoutID];
        [self openApp:app slot:0];   // tail — A's open path
    }
}

@end
