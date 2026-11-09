// SCPCarSplit+Divider.m — OmniCarSplitScreen reconstruction, module SplitScreenB.
// Divider drag (linear + main-stack), resize covers, ratio presets/menu.
// All geometry constants are taken from the arm64 disassembly; evidence file
// per method is listed in SplitScreenB_REPORT.md.
//
// File-static drag state in the binary (in __data):
//   0x87e58 / 0x87e60 : linear drag start fractions (pair around the divider)
//   0x87e68 / 0x87e70 : main-stack drag start fractions [0] and [1]
//   0x88168           : main-stack "knob grabbed" byte
//   0x8816c           : main-stack drag axis classification (0 none, 1 main,
//                       2 sub, 3 both/diagonal)

#import "SCPCarSplit.h"
#import "SCPCarDividerView.h"
#import "SCPCarPane.h"
#import "SCPCommon.h" // [phase2; backported to src in phase 3] OMC* declarations used in this TU

extern void SCPDispatchAfter(double delaySeconds, void (^block)(void)); // 0x12efc (A, SCPShared)

// SCPSetKnobActive / SCPLayerNamed live in SCPCarDividerView.m (module B).
void SCPSetKnobActive(UIView *knob, BOOL active);                       // 0xeb20

// MARK: - Fraction snapping (static helper @0x2d9e8)

// On drag end, when the *second* pane of a pair was squeezed under the 0.12
// threshold, the divider is not closed; the dragged fraction is snapped:
//  - 2 fractions: nearest of { 1/3, 1/2, 2/3 } (the static array @0x80548);
//  - otherwise:   if pair < 0.4 -> pair / 2, else round to a 1/12 grid and
//                 clamp into [0.2, pair - 0.2].
static double SCPSnapFraction(double f, double pair, NSInteger paneCount) {
    if (paneCount == 2) {
        double best = 0.5;
        for (NSNumber *preset in @[ @(1.0 / 3.0), @0.5, @(2.0 / 3.0) ]) { // [phase3] was `@[ @1.0 / 3.0, … ]` — NSNumber-pointer arithmetic; @(…) form (phase 2 fixed only the project copy)
            double p = preset.doubleValue;
            if (fabs(f - p) < fabs(f - best)) best = p;
        }
        return best;
    }
    if (pair < 0.4) return pair * 0.5;
    double snapped = round(f * 12.0) / 12.0;
    return MIN(MAX(snapped, 0.2), pair - 0.2);
}

static double sDragStartF0;   // 0x87e58
static double sDragStartF1;   // 0x87e60
static double sStackStartF0;  // 0x87e68
static double sStackStartF1;  // 0x87e70
static BOOL   sStackKnobDown; // 0x88168
static int    sStackDragKind; // 0x8816c

@implementation SCPCarSplit (Divider)

// MARK: Resize covers

- (void)beginResize {                                                   // 0x2c128
    if (self.resizing) return;
    self.resizing = YES;
    for (SCPCarPane *pane in self.slots)
        [self addCoverToPane:pane];
}

- (void)endResize {                                                     // 0x2c25c
    if (!self.resizing) return;
    self.resizing = NO;
    [self pushHostFramesLive:NO];
    NSArray<SCPCarPane *> *panes = [self.slots copy];
    __weak SCPCarSplit *weakSelf = self;
    SCPDispatchAfter(0.45, ^{
        SCPCarSplit *s = weakSelf;
        if (s != nil && !s.resizing) {
            [s markDismissSlot:-1];
            for (SCPCarPane *pane in panes)
                [s removeCoverFromPane:pane];
        }
    });
}

// MARK: Pan entry point

- (void)dividerPanned:(UIPanGestureRecognizer *)gr {                    // 0x2d05c
    @try {
        SCPCarDividerView *divider = (SCPCarDividerView *)gr.view;
        [self dividerPan:divider
                   state:gr.state
                location:[gr locationInView:divider]
             translation:[gr translationInView:self.container]];
    } @catch (id exception) {
        OMCLogWrite(@"SplitScreen",
            [NSString stringWithFormat:@"CarSplit: loi keo vach %@", exception]);
        [self markDismissSlot:-1];
        [self endResize];
        [self relayoutAnimated:YES];
    }
}

// MARK: Linear divider drag
//
// fractions[idx] / fractions[idx+1] are the pair being resized. The drag works
// from the fractions captured at Began (sDragStartF0/F1):
//   newF0 = clamp(startF0 + translation / avail, 0.04, pair - 0.04)
//   newF1 = pair - newF0
// where avail = (vertical ? area.height : area.width) - (paneCount - 1) and
// pair = startF0 + startF1. Dismiss encoding written to markDismissSlot: :
//   newF0 < 0.12  -> idx            (first pane squeezed out)
//   newF1 < 0.12  -> ~(idx + 1)     (second pane squeezed; negative: snap)
//   otherwise     -> 0
// On Ended/Cancelled/Failed: non-negative dismiss closes that slot via
// closeSlot:background: ; a negative dismiss snaps via SCPSnapFraction and
// saves the ratio instead.
- (void)dividerPan:(SCPCarDividerView *)divider
              state:(NSInteger)state
           location:(CGPoint)location
        translation:(CGPoint)translation {                             // 0x2d210
    NSInteger idx = divider.index;
    NSInteger count = self.paneCount;
    if (idx < 0 || idx + 1 >= count) {
        if (state >= 3 && state <= 5) [self endResize];
        return;
    }
    if (state == UIGestureRecognizerStateBegan) {
        for (SCPCarPane *pane in self.slots)
            [self setBarVisible:NO forPane:pane];
        [self hideRatioMenu];
        [self beginResize];
    }
    if (self.mainStack) {
        [self mainStackDividerPan:divider
                            state:state
                         location:location
                      translation:translation
                            ended:(state >= 3 && state <= 5)];
        return;
    }

    CGRect area = CGRectInset(self.container.bounds, 0, 0);
    BOOL vertical = self.vertical;
    double total = vertical ? area.size.height : area.size.width;
    double avail = total - (double)(count - 1);
    if (avail < 10.0) {
        if (state >= 3 && state <= 5) [self endResize];
        return;
    }
    if ((NSInteger)self.fractions.count != count)
        [self resetFractions];

    if (state == UIGestureRecognizerStateBegan) {
        sDragStartF0 = [self fractionAt:idx];
        sDragStartF1 = [self fractionAt:idx + 1];
        SCPSetKnobActive(divider.knob, YES);
    }

    double pair = sDragStartF0 + sDragStartF1;
    double t = vertical ? translation.y : translation.x;
    double newF0 = sDragStartF0 + t / avail;
    newF0 = MAX(newF0, 0.04);
    newF0 = MIN(newF0, pair - 0.04);
    double newF1 = pair - newF0;

    // VERIFIED @0x2d52c-0x2d538 (fcmp/csinv/csel, register-level):
    // the binary computes dismiss = idx when newF0 is squeezed below
    // 0.12, idx + 1 (POSITIVE) when only newF1 is squeezed, and -1
    // ("no squeeze" -> snap) otherwise. There is no dismiss==0
    // double-meaning: 0 arises only as idx==0 via the newF0 branch.
    // Corrected in the final micro-closure pass per the Closure
    // addendum's register proof (the earlier ~(idx+1)/default-0
    // transcription was wrong twice).
    NSInteger dismiss = (newF0 < 0.12) ? idx : ((newF1 < 0.12) ? idx + 1 : -1);

    if (state >= 3 && state <= 5) {
        // Terminal state.
        SCPSetKnobActive(divider.knob, NO);
        [self markDismissSlot:-1];
        if (dismiss < 0) {
            double snapped = SCPSnapFraction(newF0, pair, count);
            self.fractions[idx] = @(snapped);
            self.fractions[idx + 1] = @(pair - snapped);
            [self endResize];
            [self relayoutAnimated:YES];
            [self saveRatio];
            return;
        }
        self.fractions[idx] = @(newF0);
        self.fractions[idx + 1] = @(newF1);
        SCPCarPane *victim = self.slots[dismiss];
        OMCLogWrite(@"SplitScreen",
            [NSString stringWithFormat:@"CarSplit: keo vach %d sat mep -> dong o %d (%@)",
                (int)idx, (int)dismiss, victim.bundleID]);
        [self endResize];
        [self closeSlot:(int)dismiss background:YES];
        return;
    }

    // Began / Changed: live update.
    self.fractions[idx] = @(newF0);
    self.fractions[idx + 1] = @(newF1);
    [self markDismissSlot:(int)dismiss];
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    [self relayoutAnimated:NO pushScenes:NO];
    [CATransaction commit];
}

// MARK: Main-stack divider drag (1 main + 2 stacked)
//
// Two fractions only: fractions[0] = main band share, fractions[1] = the
// sub-split share inside the stacked band. Dragging divider 1 always moves
// the sub-split. Dragging divider 0 moves the main band; if the drag began
// on divider 0's knob, the gesture is classified once the touch has moved
// more than 12 pt: dominant axis wins by a 1.5x factor
// (1 = main only, 2 = sub only, 3 = both).
//   newF0 = clamp(startF0 + signedMain / mainTotal, 0.04, 0.75)
//   newF1 = clamp(startF1 + sub / subTotal,       0.04, 0.96)
// mainTotal = (runsH0 ? area.height : area.width) - 1
// subTotal  = (runsH1 ? union(1,2).height : union(1,2).width) - 1
// signedMain is negated when mainRight. Dismiss encoding:
//   newF0 < 0.12 -> 0 ; newF1 < 0.12 -> 1 ; (1 - newF1) < 0.12 -> ~2 ;
//   otherwise 0. A negative dismiss on end snaps both fractions through
//   SCPSnapFraction(x, 1.0, 2) with fractions[0] additionally capped at 0.67.
- (void)mainStackDividerPan:(SCPCarDividerView *)divider
                      state:(NSInteger)state
                   location:(CGPoint)location
                translation:(CGPoint)translation
                      ended:(BOOL)ended {                              // 0x2db68
    NSInteger idx = divider.index;
    CGRect area = CGRectInset(self.container.bounds, 0, 0);
    BOOL runsH0 = [self dividerRunsHorizontally:0];
    BOOL runsH1 = [self dividerRunsHorizontally:1];
    CGRect union12 = CGRectUnion([self frameForSlot:1], [self frameForSlot:2]);
    double mainTotal = (runsH0 ? area.size.height : area.size.width) - 1.0;
    double subTotal = (runsH1 ? union12.size.height : union12.size.width) - 1.0;
    if (mainTotal < 10.0 || subTotal < 10.0) {
        if (ended) [self endResize];
        return;
    }
    if (self.fractions.count != 2)
        [self resetFractions];

    UIView *knob0 = self.dividers.count > 0 ? self.dividers[0].knob : nil;

    if (state == UIGestureRecognizerStateBegan) {
        sStackStartF0 = [self fractionAt:0];
        sStackStartF1 = [self fractionAt:1];
        if (idx != 0) {
            sStackKnobDown = NO;
            sStackDragKind = 0;
        } else {
            UIView *knob = divider.knob;
            sStackKnobDown = !knob.isHidden &&
                CGRectContainsPoint(CGRectInset(knob.frame, -26, -26), location);
            sStackDragKind = 0;
            SCPSetKnobActive(knob0, YES);
        }
    }

    double f0 = sStackStartF0;
    double f1 = sStackStartF1;
    double tMainRaw = runsH0 ? translation.y : translation.x;
    double signedMain = self.mainRight ? -tMainRaw : tMainRaw;
    double tSub = runsH1 ? translation.y : translation.x;

    if (sStackKnobDown && sStackDragKind == 0 &&
        hypot(signedMain, tSub) > 12.0) {
        double a = fabs(signedMain), b = fabs(tSub);
        int kind = (b > a * 1.5) ? 2 : 3;
        if (a > b * 1.5) kind = 1;
        sStackDragKind = kind;
    }

    double newF0 = f0, newF1 = f1;
    BOOL doMain = NO, doSub = NO;
    if (idx == 1) {
        doSub = YES;
    } else if (!sStackKnobDown) {
        doMain = YES;
    } else {
        doMain = (sStackDragKind == 1 || sStackDragKind == 3);
        doSub = (sStackDragKind == 2 || sStackDragKind == 3);
        if (sStackDragKind == 0) doMain = YES;  // not yet classified: main only
    }
    if (doMain) newF0 = MIN(MAX(f0 + signedMain / mainTotal, 0.04), 0.75);
    if (doSub)  newF1 = MIN(MAX(f1 + tSub / subTotal, 0.04), 0.96);

    NSInteger dismiss = 0;
    if (newF0 < 0.12) dismiss = 0;
    else if (newF1 < 0.12) dismiss = 1;
    else if (1.0 - newF1 < 0.12) dismiss = ~2;

    self.fractions[0] = @(newF0);
    self.fractions[1] = @(newF1);

    if (!ended) {
        [self markDismissSlot:(int)dismiss];
        [CATransaction begin];
        [CATransaction setDisableActions:YES];
        [self relayoutAnimated:NO pushScenes:NO];
        [CATransaction commit];
        return;
    }

    if (sStackKnobDown) SCPSetKnobActive(knob0, NO);
    [self markDismissSlot:-1];
    if (dismiss < 0) {
        double s0 = MIN(SCPSnapFraction(newF0, 1.0, 2), 0.67);
        double s1 = SCPSnapFraction(newF1, 1.0, 2);
        self.fractions[0] = @(s0);
        self.fractions[1] = @(s1);
        [self endResize];
        [self relayoutAnimated:YES];
        [self saveRatio];
        return;
    }
    SCPCarPane *victim = self.slots[dismiss];
    OMCLogWrite(@"SplitScreen",
        [NSString stringWithFormat:@"CarSplit: keo vach sat mep (1 lon + 2) -> dong o %d (%@)",
            (int)dismiss, victim.bundleID]);
    [self endResize];
    [self closeSlot:(int)dismiss background:YES];
}

// MARK: Ratio persistence

- (void)saveRatio {                                                     // 0x2e360
    NSMutableArray<NSString *> *parts = [NSMutableArray array];
    for (NSNumber *f in self.fractions)
        [parts addObject:[NSString stringWithFormat:@"%.2f", f.doubleValue]];
    NSString *joined = [parts componentsJoinedByString:@" / "];
    OMCLogWrite(@"SplitScreen",
        [NSString stringWithFormat:@"CarSplit: ti le cac o = %@", joined]);
    if (self.paneCount == 2) {
        double r = [self fractionAt:0];
        [SCPPrefs setSplitRatio:r];
        NSString *left = self.slots[0].bundleID;
        NSString *right = self.slots[1].bundleID;
        if (left != nil && right != nil)
            [SCPPrefs setRatio:r forPairLeft:left right:right];
    }
}

// The three preset tables are NSConstantArray literals in __data
// (@0x803f8 / @0x80458 / @0x804d0), decoded value-by-value.
- (NSArray *)ratioPresets {                                             // 0x2e9a0
    if (self.mainStack)
        return @[ @[@(1.0 / 3.0), @0.5], @[@0.5, @0.5], @[@(2.0 / 3.0), @0.5] ];
    if (self.paneCount == 2)
        return @[ @[@(1.0 / 3.0), @(2.0 / 3.0)], @[@0.5, @0.5], @[@(2.0 / 3.0), @(1.0 / 3.0)] ];
    return @[ @[@(1.0 / 3.0), @(1.0 / 3.0), @(1.0 / 3.0)],
              @[@0.25, @0.5, @0.25],
              @[@0.5, @0.25, @0.25],
              @[@0.25, @0.25, @0.5] ];
}

- (BOOL)fractionsMatch:(NSArray *)other {                               // 0x2e9f0
    if (other.count != self.fractions.count) return NO;
    for (NSUInteger i = 0; i < other.count; i++) {
        double a = ((NSNumber *)other[i]).doubleValue; // [phase2; backported to src in phase 3] untyped NSArray subscript yields id
        double b = self.fractions[i].doubleValue;
        if (fabs(a - b) > 0.03) return NO;
    }
    return YES;
}

// MARK: Divider double-tap = swap the two adjacent panes

- (void)dividerDoubleTapped:(UITapGestureRecognizer *)gr {              // 0x2e6e8
    [self dividerDoubleTapOn:(SCPCarDividerView *)gr.view];
}

- (void)dividerDoubleTapOn:(SCPCarDividerView *)divider {               // 0x2e73c
    @try {
        NSInteger i = divider.index;
        if (i < 0 || i + 1 >= self.paneCount) return;
        OMCLogWrite(@"SplitScreen",
            [NSString stringWithFormat:@"CarSplit: cham 2 lan vach %d -> doi cho o %d va %d",
                (int)i, (int)i, (int)i + 1]);
        [self hideRatioMenu];
        for (SCPCarPane *pane in self.slots)
            [self setBarVisible:NO forPane:pane];
        [self swapSlot:(int)i with:(int)i + 1];
    } @catch (id exception) {
        OMCLogWrite(@"SplitScreen",
            [NSString stringWithFormat:@"CarSplit: loi doi cho %@", exception]);
    }
}

// MARK: Divider tap = ratio menu toggle (only when the knob itself is hit)

- (void)dividerTapped:(UITapGestureRecognizer *)gr {                    // 0x2eb64
    SCPCarDividerView *divider = (SCPCarDividerView *)gr.view;
    [self dividerTapOn:divider at:[gr locationInView:divider]];
}

- (void)dividerTapOn:(SCPCarDividerView *)divider at:(CGPoint)point {   // 0x2ebf0
    @try {
        UIView *knob = divider.knob;
        if (knob == nil || knob.isHidden) return;
        if (!CGRectContainsPoint(CGRectInset(knob.frame, -26, -26), point)) return;
        // [do] fix-round4 E-2 instrumentation (NOT original behaviour):
        // timestamp the knob-tap toggle so it can be lined up against a
        // closePopups that lands milliseconds later.
        OMCLogWrite(@"SplitScreen",
            [NSString stringWithFormat:@"CarSplit: [do] dividerTap vach %ld tai %@ -> %@ menu ti le",
                (long)divider.index, NSStringFromCGPoint(point),
                self.ratioMenu != nil ? @"dong" : @"mo"]);
        if (self.ratioMenu != nil) [self hideRatioMenu];
        else [self showRatioMenuForDivider:divider];
    } @catch (id exception) {
        OMCLogWrite(@"SplitScreen",
            [NSString stringWithFormat:@"CarSplit: loi cham tay nam %@\n%@",
                exception, ((NSException *)exception).callStackSymbols]);
    }
}

- (void)ratioPresetTapped:(UIView *)sender {                            // 0x31194
    @try {
        NSArray *presets = [self ratioPresets];
        NSInteger tag = sender.tag;
        if (tag < 0 || tag >= (NSInteger)presets.count) {
            [self hideRatioMenu];
            return;
        }
        [self hideRatioMenu];
        [self beginResize];
        self.fractions = [presets[tag] mutableCopy];
        [self relayoutAnimated:YES];
        [self saveRatio];
        [self endResize];
    } @catch (id exception) {
        OMCLogWrite(@"SplitScreen",
            [NSString stringWithFormat:@"CarSplit: loi chon ti le %@\n%@",
                exception, ((NSException *)exception).callStackSymbols]);
        [self hideRatioMenu];
    }
}

// MARK: Remote knob touch (SpringBoard side)
//
// The knob can also be driven by touches forwarded from the other process;
// the payload is a dictionary:
//   { @"index": @(divider index), @"phase": @(0 down, 1 move, 2 up, ...),
//     @"x": @(window x), @"y": @(window y) }
// phase 0 only logs and lights the knob; the drag's Began is synthesised by
// the first move whose delta from the down point reaches 8 pt. A quick
// up-tap becomes dividerTapOn:at: and two taps within 0.35 s become
// dividerDoubleTapOn: (statics at 0x88170/0x88178 last point, 0x88180
// dragging flag, 0x88188 last tap time).

static CGPoint sRemoteLastPoint;    // 0x88170 / 0x88178
static BOOL    sRemoteDragging;     // 0x88180
static double  sRemoteLastTapTime;  // 0x88188

- (void)remoteKnobTouch:(NSDictionary *)payload {                       // 0x2edfc
    NSInteger idx = [payload[@"index"] intValue];
    NSInteger phase = [payload[@"phase"] intValue];

    SCPCarDividerView *divider = nil;
    for (SCPCarDividerView *d in self.dividers)
        if (d.index == idx) divider = d;

    if (divider == nil) {
        if (phase == 0)
            OMCLogWrite(@"SplitScreen",
                [NSString stringWithFormat:@"CarSplit: cham tron SpringBoard vach %d bo qua (vach %@, active %d)",
                    (int)idx, @"khong", (int)self.active]);
        return;
    }
    BOOL ok = self.active && self.container != nil && divider.window != nil;
    if (!ok) {
        if (phase == 0)
            OMCLogWrite(@"SplitScreen",
                [NSString stringWithFormat:@"CarSplit: cham tron SpringBoard vach %d bo qua (vach %@, active %d)",
                    (int)idx, @"co", (int)self.active]);
        return;
    }

    double wx = [payload[@"x"] doubleValue];
    double wy = [payload[@"y"] doubleValue];
    CGPoint inContainer = [self.container convertPoint:CGPointMake(wx, wy)
                                              fromView:nil];
    CGPoint inDivider = [divider convertPoint:CGPointMake(wx, wy)
                                     fromView:nil];
    CGPoint delta = CGPointMake(inContainer.x - sRemoteLastPoint.x,
                                inContainer.y - sRemoteLastPoint.y);

    if (phase == 0) {
        sRemoteLastPoint = inContainer;
        sRemoteDragging = NO;
        OMCLogWrite(@"SplitScreen",
            [NSString stringWithFormat:@"CarSplit: cham tron SpringBoard vach %d tai %@",
                (int)idx, NSStringFromCGPoint(inDivider)]);
        UIView *knob = divider.knob;
        if (knob != nil && !knob.isHidden)
            SCPSetKnobActive(knob, YES);
        return;
    }

    if (phase == 1) {
        if (sRemoteDragging) {
            [self dividerPan:divider state:2 location:inDivider translation:delta];
        } else if (hypot(delta.x, delta.y) >= 8.0) {
            sRemoteDragging = YES;
            [self dividerPan:divider state:1 location:inDivider translation:delta];
        }
        return;
    }

    // phase >= 2: up / cancel.
    if (sRemoteDragging) {
        sRemoteDragging = NO;
        NSInteger state = (phase == 2) ? 3 : 4;
        [self dividerPan:divider state:state location:inDivider translation:delta];
        return;
    }
    UIView *knob = divider.knob;
    if (knob != nil) SCPSetKnobActive(knob, NO);
    if (phase == 2) {
        [self dividerTapOn:divider at:inDivider];
        double now = CACurrentMediaTime();
        if (now - sRemoteLastTapTime < 0.35) {
            sRemoteLastTapTime = 0;
            [self dividerDoubleTapOn:divider];
        } else {
            sRemoteLastTapTime = now;
        }
    }
}

@end
