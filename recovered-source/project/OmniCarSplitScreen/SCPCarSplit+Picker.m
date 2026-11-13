// SCPCarSplit+Picker.m — OmniCarSplitScreen reconstruction, module SplitScreenB.
// Pane covers (shown while resizing/dragging), the per-slot app picker,
// the picker sheet, the app tray window bookkeeping, loaders and toasts.
//
// CLOSURE (wave 3, finisher): every STUB-UNRECOVERED / PARTIAL body in this
// file was closed by line-by-line disassembly reading — see the "Closure
// addendum" in SplitScreenB_REPORT.md for per-item verdicts and evidence.

#import "SCPCarSplit.h"
#import "SCPCarPane.h"
#import "SCPCommon.h" // [phase2; backported to src in phase 3] OMC* declarations used in this TU
#import "SCPCButton.h" // [phase2; backported to src in phase 3] SCPCButton interface used in this TU
#import <objc/message.h>  // rem4: trayWindowForParent: super-send + guarded msgSend casts
#import <objc/runtime.h>  // rem4: SCPCPass runtime subclass (objc_allocateClassPair & friends)

// Guarded-call logger of this dylib (_SCPMissingSelector @0x4f330,
// 2-arg form used by module A; see SCPCarSplit.m).
extern void SCPMissingSelector(id object, NSString *selectorName);

// App icon lookup (static helper @0xdec8; name INFERRED — shared with Drag).
extern UIImage *SCPAppIconForBundle(NSString *bundleID);
extern void SCPDispatchAfter(double delaySeconds, void (^block)(void)); // 0x12efc (A)
extern BOOL SCPVCIsHosted(id vc); // [hl45-layer] classifier from SCPShared
// Dashboard root view controller getter @0x12658 (A; name INFERRED).
extern UIViewController *SCPDashboardRootViewController(void);

// Shared visual helpers implemented in other SplitScreenB files:
extern UIVisualEffectView *SCPKnobFaceView(void);                     // 0x35c74 (Chrome) — [phase2; backported to src in phase 3] ONE name
extern void SCPApplyMeshBackdrop(UIVisualEffectView *effectView);       // 0x35d5c (Chrome)
extern UIColor *SCPColorSecondary(void);                                // 0x2b380 (Chrome)
extern void SCPStyleChip(UIView *view, double radius);                  // 0x35f70 (Chrome)
extern void SCPStyleDragGhost(UIView *view, double radius);             // 0x271e4 (Drag)
extern void SCPStyleGhostIcon(UIImageView *imageView);                  // 0x21158 (Drag)
extern void SCPStyleRatioMenu(UIView *view, double radius);             // 0x29b10 (RatioMenu)
extern void SCPPrepareRatioMenu(UIView *view);                          // 0x24a34 (RatioMenu)
extern UIImage *SCPSymbolImage(NSString *name, double pointSize);       // 0x2b474 (RatioMenu)
extern UIButton *SCPWrapRatioChip(UIImage *image, id target, SEL action); // 0x302f8 (RatioMenu)
extern UIButton *SCPMakeIconButton(UIImage *image, id target, SEL action, double size); // 0x2b404 (RatioMenu)

// App catalog builders (module C):
extern NSArray *SCPCarPlayAppInfos(void);                               // 0x21d4c
extern NSArray *SCPChosenPhoneAppInfos(void);                           // 0x22210
extern NSArray *SCPBridgedChosenApps(void);                             // 0x48864
extern BOOL SCPIsInjectedPhoneApp(NSString *bundleID);                  // name INFERRED (C)
// Proxy lookup helpers (shared; names INFERRED):
extern id SCPApplicationInfoForBundle(NSString *bundleID); // [phase2; backported to src in phase 3] 0xe324 — B's "SCPProxyForBundle" is A's SCPApplicationInfoForBundle (SCPShared.m)
extern BOOL SCPAppHasCarPlayUI(id appInfo); // [phase2; backported to src in phase 3] 0xffb4 — B's "SCPProxyIsValid" is SCPAppHasCarPlayUI (dump-verified)

// Accent gradient/shadow styler @0x293a0 (name INFERRED). Two callers in
// this file (picker map, background toast) plus one in sub_24794.
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
            (id)[UIColor colorWithRed:0.6078431372549019 green:0.5294117647058824
                                 blue:0.9725490196078431 alpha:1.0].CGColor,
            (id)[UIColor colorWithRed:0.36470588235294116 green:0.7058823529411765
                                 blue:0.9647058823529412 alpha:1.0].CGColor];
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
    view.layer.shadowColor = [UIColor colorWithRed:0.43137254901960786
                                             green:0.47058823529411764
                                              blue:1.0
                                             alpha:1.0].CGColor;
    view.layer.shadowOpacity = 0.45f;
    view.layer.shadowRadius = 9;
    view.layer.shadowOffset = CGSizeMake(0, 4);
}

// [hl2-split P6] Compact live-state summary of one view for the
// single [picker-measure] line in showPickerForSlot: (alpha, hidden,
// superview class, frame, background colour as r,g,b,a — "?" when the
// colour cannot be read as RGB, e.g. a pattern/dynamic colour).

// [hl45-layer] Observation only: no changes to original picker/cover/scene UI.
static unsigned long long DCHL45Seq=0;
static NSString *DCHL45View(UIView *v) {
    if (!v) return @"nil";
    UIView *parent=v.superview;
    NSUInteger idx=parent ? [parent.subviews indexOfObject:v] : NSNotFound;
    UIWindow *win=v.window;
    // UIView.alpha is the model value; during a fade it may differ from pixels.
    CALayer *liveLayer = v.layer.presentationLayer;
    CGFloat bgR=0, bgG=0, bgB=0, bgA=-1;
    if (v.backgroundColor &&
        ![v.backgroundColor getRed:&bgR green:&bgG blue:&bgB alpha:&bgA])
        bgA = -1; // unknown color opacity is NOT opaque
    return [NSString stringWithFormat:
        @"%p:%@ fr=%@ a=%.2f pres=%.2f bgA=%.2f hidden=%d parent=%p z=%ld/%lu win=%p level=%.1f winHidden=%d",
        (__bridge void *)v, NSStringFromClass(v.class), NSStringFromCGRect(v.frame),
        (double)v.alpha, (double)(liveLayer ? liveLayer.opacity : v.layer.opacity),
        (double)bgA, (int)v.hidden, (__bridge void *)parent,
        idx==NSNotFound ? -1L : (long)idx,
        (unsigned long)(parent ? parent.subviews.count : 0),
        (__bridge void *)win, win ? (double)win.windowLevel : -1.0,
        win ? (int)win.hidden : -1];
}
// Linked by the Divider TU, called only at UI action boundaries.
void DCHL45OverlayTrace(SCPCarSplit *split, NSString *event,
                        SCPCarPane *pane, UIView *old) {
    if (!split) return;
    if (![NSThread isMainThread]) {
        OMCLogWrite(@"SplitScreen", [NSString stringWithFormat:
            @"[hl45-layer] ev=%@ result=BLIND off-main",event]);
        return;
    }
    @try {
        UIViewController *vc=pane.vc;
        BOOL hosted=vc ? SCPVCIsHosted(vc) : NO;
        UIView *nativeView=(vc && [vc isViewLoaded]) ? vc.view : nil;
        UIWindow *win=split.trayWindow;
        OMCLogWrite(@"SplitScreen",[NSString stringWithFormat:
            @"[hl45-layer] seq=%llu ev=%@ t=%.3f slot=%d app=%@ mode=%@ resizing=%d sceneSize=%@ pane=%p paneView{%@} host{%@} vcView{%@} cover{%@} picker{%@} loader{%@} sheet{%@} old{%@} trayWin=%p trayLevel=%.1f trayHidden=%d",
            ++DCHL45Seq,event,CACurrentMediaTime(),pane ? pane.slot : -1,
            pane.bundleID ?: @"(none)",
            !vc ? @"EMPTY" : (hosted ? @"HOSTED" : @"NATIVE"),
            (int)split.resizing,NSStringFromCGSize(pane ? pane.sceneSize : CGSizeZero),
            (__bridge void *)pane,DCHL45View(pane.view),
            DCHL45View(pane.host),DCHL45View(nativeView),
            DCHL45View(pane.cover),DCHL45View(pane.picker),
            DCHL45View(pane.loader),DCHL45View(split.pickerSheet),
            DCHL45View(old),(__bridge void *)win,
            win ? (double)win.windowLevel : -1.0,win ? (int)win.hidden : -1]);
    } @catch(NSException *exception) {
        OMCLogWrite(@"SplitScreen",[NSString stringWithFormat:
            @"[hl45-layer] ev=%@ result=EXCEPTION name=%@",event,exception.name]);
    }
}


// Observation-only samples of original fades; weak refs prevent retaining views.
static void DCHL45ScheduleTrace(SCPCarSplit *split, NSString *event,
                                SCPCarPane *pane, UIView *observed, double delay) {
    __weak SCPCarSplit *owner = split;
    __weak SCPCarPane *target = pane;
    __weak UIView *old = observed;
    SCPDispatchAfter(delay, ^{
        SCPCarSplit *s = owner;
        if (s) DCHL45OverlayTrace(s, event, target, old);
    });
}

static NSString *SCPViewMeasureDesc(UIView *view) {
    if (view == nil) return @"nil";
    CGFloat r = 0, g = 0, b = 0, a = 0;
    NSString *bg = @"?";
    if (view.backgroundColor != nil &&
        [view.backgroundColor getRed:&r green:&g blue:&b alpha:&a])
        bg = [NSString stringWithFormat:@"%.3f,%.3f,%.3f,%.3f", r, g, b, a];
    return [NSString stringWithFormat:
        @"alpha=%.2f hidden=%d super=%@ frame=%@ bg=%@",
        view.alpha, (int)view.isHidden,
        view.superview ? NSStringFromClass(view.superview.class) : @"nil",
        NSStringFromCGRect(view.frame), bg];
}

// [picker-measure3] (hl4, MEASURE ONLY): raw background of a colour
// for the measure line — unlike SCPViewMeasureDesc, a nil colour is
// reported as "nil" (not "?"), because 29.23 L5 showed the sheet's
// and the scene host's backgroundColor are in fact nil (their "bg=?"
// in measure2 hid whether the colour was absent or unreadable).
static NSString *SCPMeasureBgRaw(UIColor *color) {
    if (color == nil) return @"nil";
    CGFloat r = 0, g = 0, b = 0, a = 0;
    if ([color getRed:&r green:&g blue:&b alpha:&a])
        return [NSString stringWithFormat:@"%.3f,%.3f,%.3f,%.3f", r, g, b, a];
    return @"?";
}

// [picker-measure3] (hl4, MEASURE ONLY): class-prefixed live-state
// summary of every subview of a view, joined with " | " ("none" when
// the view has no subviews, "nil" when the view itself is nil).
// SCPViewMeasureDesc names the SUPERVIEW's class, not the view's own,
// so the class is spelled out here — 29.23 L5 needs the class of the
// picker's single subview and of the scene host's content subviews.
static NSString *SCPMeasureSubviewDescs(UIView *view) {
    if (view == nil) return @"nil";
    if (view.subviews.count == 0) return @"none";
    NSMutableArray<NSString *> *parts = [NSMutableArray array];
    for (UIView *sub in view.subviews)
        [parts addObject:[NSString stringWithFormat:@"%@{%@}",
            NSStringFromClass(sub.class), SCPViewMeasureDesc(sub)]];
    return [parts componentsJoinedByString:@" | "];
}

// [picker-measure3] (hl4, MEASURE ONLY): index of a view inside its
// superview's subview order (back-to-front), with the sibling count —
// the z-order evidence 29.23 L5 asked for. -1/0 when detached.
static NSString *SCPMeasureZIndex(UIView *view) {
    if (view == nil || view.superview == nil) return @"-1/0";
    NSUInteger idx = [view.superview.subviews indexOfObject:view];
    return [NSString stringWithFormat:@"%lu/%lu",
        (unsigned long)(idx == NSNotFound ? 0 : idx + 1),
        (unsigned long)view.superview.subviews.count];
}

// [hl6-picker] MEASURE ONLY: superview chain of a view as class
// names from the view up to (and including) its window, joined
// with " < " — the window-hierarchy evidence the hl6 round adds
// for the picture-loss question (29.29: the video's lost picture
// was a real pane teardown + re-host, but whether the SHEET's
// window sits over the pane's scene surface while presented is
// still unproven either way). "nil" for a nil view, the chain
// just ends early when a view has no window yet.
static NSString *SCPMeasureChainDesc(UIView *view) {
    if (view == nil) return @"nil";
    NSMutableArray<NSString *> *parts = [NSMutableArray array];
    UIView *v = view;
    while (v != nil) {
        [parts addObject:NSStringFromClass(v.class)];
        if ([v isKindOfClass:UIWindow.class]) break;
        v = v.superview;
    }
    return [parts componentsJoinedByString:@" < "];
}

// [hl6-picker] GPT work order HL5->HL6 (d313f17), item 3: the
// close-done measurement snapshot, pinned as SCALARS at sheet
// CREATION (buildPickerSheetForPane:) and read back by
// removePickerSheet. hl5 pinned by reading self.pickerSheetPane
// inside removePickerSheet — but refreshPickerSheet nils
// pickerSheetPane (Picker.m, the found==nil path) BEFORE calling
// removePickerSheet, so 4/4 hl5 close-done lines read slot=-1 /
// preBundle=null (29.29 source conviction). These statics belong
// to the CURRENT sheet: a rebuild re-pins them for the new sheet,
// and removePickerSheet copies them into locals at entry, so a
// completion block always reports the sheet it closes.
static NSInteger SCPickerMeasureSlot = -1;
static NSString *SCPickerMeasurePreBundle = nil;

// Bridged-phone-app predicate @0x101bc (name INFERRED; also called from
// module A methods — dedupe at integration, A owns most call sites).
static BOOL SCPIsBridgedPhoneApp(NSString *bundleID) {
    if (bundleID.length == 0) return NO;
    if (!OMCFeatureEnabled(@"appBridge")) return NO; // [phase2; backported to src in phase 3] C name has no leading underscore
    if (SCPIsInjectedPhoneApp(bundleID)) return YES;
    id app = SCPApplicationInfoForBundle(bundleID); // [phase2; backported to src in phase 3] names unified to A/C
    if (!SCPAppHasCarPlayUI(app)) return NO;
    return [SCPBridgedChosenApps() containsObject:bundleID];
}

@implementation SCPCarSplit (Picker)

// MARK: - Visual covers during resize (non-interactive, matching the original)

- (void)addCoverToPane:(SCPCarPane *)pane {                               // 0x2a2e8 VERIFIED
    // CLOSURE NOTE: the earlier draft annotated this method "@0x24a34+";
    // 0x24a34 is SCPPrepareRatioMenu (see RatioMenu) — the annotation was
    // wrong and has been removed.
    // N10 (GPT wiring audit): the cover contract is — no cover for a
    // pane without a VC; cover NON-interactive (@0x2a3d0); ghost icon
    // 52x52 styled by sub_21158 and TAGGED 77 (@0x2a450), the tag
    // markDismissSlot: looks up via [pane.cover viewWithTag:77];
    // cover starts at alpha 0 and fades in over 0.12 s (block
    // @0x2a65c). Only the handle is raised above the cover; the
    // original has no bar bring-to-front here.
    if (pane.cover != nil || pane.vc == nil) return;
    UIView *cover = [[UIView alloc] initWithFrame:pane.view.bounds];
    cover.autoresizingMask = 0x12;
    cover.backgroundColor = [UIColor colorWithRed:0.9333333333333333
                                            green:0.9411764705882353
                                             blue:0.9843137254901961
                                            alpha:1.0];
    cover.userInteractionEnabled = NO;
    UIImageView *icon = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 52, 52)];
    icon.image = SCPAppIconForBundle(pane.bundleID);
    SCPStyleGhostIcon(icon);
    icon.tag = 77;
    icon.center = CGPointMake(CGRectGetMidX(cover.bounds),
                              CGRectGetMidY(cover.bounds));
    icon.autoresizingMask = 0x2d;   // VERIFIED (CLOSURE-2): parent @0x2a488 sets
                                    // w2 = 0x2d (flexible left/right/top/bottom
                                    // margins — keep centred); disasm/rem2_addCoverToPane.txt
    [cover addSubview:icon];
    pane.cover = cover;
    [pane.view insertSubview:cover aboveSubview:pane.host];
    if (pane.handle != nil)
        [pane.view bringSubviewToFront:pane.handle];
    cover.alpha = 0;
    [UIView animateWithDuration:0.12 animations:^{ cover.alpha = 1; }];
    DCHL45OverlayTrace(self,@"cover-added",pane,cover);
    DCHL45ScheduleTrace(self,@"cover-fade-settled",pane,cover,0.18);
}

- (void)removeCoverFromPane:(SCPCarPane *)pane {                          // 0x2a668 VERIFIED
    UIView *cover = pane.cover;
    if (cover == nil) return;
    DCHL45OverlayTrace(self,@"cover-remove-request",pane,cover);
    pane.cover = nil;
    __weak SCPCarSplit *hl45Split=self;
    __weak SCPCarPane *hl45Pane=pane;
    [UIView animateWithDuration:0.22
        animations:^{ cover.alpha = 0; }              // VERIFIED (CLOSURE-2): invoke
                                                      // @0x2a7a4 = [cover setAlpha:0]
        completion:^(BOOL finished) {
            [cover removeFromSuperview];
            DCHL45OverlayTrace(hl45Split,@"cover-remove-complete",hl45Pane,cover);
        }]; // invoke @0x2a7b0 VERIFIED
}

// MARK: - Per-slot picker (empty-slot placeholder)

- (void)showPickerForSlot:(int)slot {                                     // 0x31530 VERIFIED
    if (!self.active) return;
    if (![self validSlot:slot]) slot = [self autoSlot];
    SCPCarPane *pane = [self paneAtSlot:slot];
    if (pane == nil) return;
    [self removePickerFromPane:pane];
    [self removeLoaderFromPane:pane animated:NO];
    // Keep this state for existing diagnostics, never for the face opacity.
    BOOL hasContent = (pane.vc != nil || [self slotOccupied:pane.slot]);
    // [hl22-original] The original DEB uses an opaque pane placeholder
    // for both occupied and empty panes. It protects the content beneath
    // while the picker is active; do not opt into the HL5 transparent fix.
    UIView *picker = [[UIView alloc] init];
    pane.picker = picker;                                                // @0x315c0 setPicker: precedes styling
    // Dump @0x315cc-0x315e4: the picker frame is (0, 0, slotSize) — the
    // SIZE of frameForSlot: with origin ZEROED, because the picker is
    // added INSIDE pane.view (pane-local coordinates). The previous
    // initWithFrame:[self frameForSlot:slot] used the container-space
    // origin and displaced the picker inside the pane.
    CGRect slotFrame = [self frameForSlot:slot];
    picker.frame = CGRectMake(0, 0, slotFrame.size.width, slotFrame.size.height);
    picker.backgroundColor = [UIColor colorWithRed:0.9333333333333333
                                               green:0.9411764705882353
                                                blue:0.984313725490196
                                               alpha:1.0]; // original @0x315ec..0x31624
    OMCLogWrite(@"SplitScreen", @"[hl22-original] picker-pane-opacity=1.0");   // VERIFIED @0x315ec-0x3160c (was labelled INFERRED — values were right)
    // [hl2-split P6] THE single picker measurement line (2026-11-09):
    // the ytz5hl1 car log proved hasContent=1 on both real opens while
    // the pane still showed white, and the source audit could NOT
    // convict one element — pane.cover is the only structurally
    // opaque full-pane view (addCoverToPane: rgb 0.933/0.941/0.984
    // alpha 1, inserted above pane.host), but its add paths (Divider
    // beginResize; RatioMenu/Panel only when the tray window is nil)
    // do not prove it was present at picker-open, and the popup
    // shield is white at alpha 0.02 (SCPCTouchWatch, Chrome.m
    // updatePopupShield) so it cannot be opaque white. This line
    // records every candidate's live state at the capture point:
    // cover / the fresh picker / the standing sheet / both shields /
    // the tray window (frame + level).
    OMCLogWrite(@"SplitScreen", [NSString stringWithFormat:
        @"[picker-measure] slot=%d hasContent=%d cover{%@} picker{%@} "
        @"sheet{%@} shield{%@} pshield{%@} trayWin{frame=%@ level=%.0f hidden=%d}",
        slot, (int)hasContent,
        SCPViewMeasureDesc(pane.cover), SCPViewMeasureDesc(picker),
        SCPViewMeasureDesc(self.pickerSheet),
        SCPViewMeasureDesc(self.popupShield),
        SCPViewMeasureDesc(self.pickerShield),
        self.trayWindow ? NSStringFromCGRect(self.trayWindow.frame) : @"nil",
        self.trayWindow ? self.trayWindow.windowLevel : -1.0,
        self.trayWindow ? (int)self.trayWindow.isHidden : -1]);
    picker.autoresizingMask = 0x12;
    // Dump @0x3163c-0x31690: border colour is the lavender accent
    // colorWithRed:0.6078431372549019 green:0.5294117647058824
    // blue:0.9725490196078431 alpha:1.0 — NOT white at 0.55.
    picker.layer.borderColor = [UIColor colorWithRed:0.6078431372549019
                                               green:0.5294117647058824
                                                blue:0.9725490196078431
                                               alpha:1.0].CGColor;
    UILabel *label = [[UILabel alloc] initWithFrame:picker.bounds];
    label.text = @"+";   // VERIFIED: cfstring @0x7c720 == "+"
    // Dump @0x316d4-0x31704: text colour is
    // [SCPColorSecondary() colorWithAlphaComponent:0.6] — the navy
    // helper @0x2b380 at 60% — NOT white at 0.85.
    label.textColor = [SCPColorSecondary() colorWithAlphaComponent:0.6];
    // Dump @0x31718-0x31734: systemFontOfSize:40 weight:UIFontWeightLight
    // (weight GOT slot @0x782a8 == _UIFontWeightLight) — NOT Bold.
    label.font = [UIFont systemFontOfSize:40 weight:UIFontWeightLight];
    label.textAlignment = NSTextAlignmentCenter;
    label.autoresizingMask = 0x12;
    [picker addSubview:label];
    UITapGestureRecognizer *tap =
        [[UITapGestureRecognizer alloc] initWithTarget:self
                                                action:@selector(pickerPaneTapped:)];
    [picker addGestureRecognizer:tap];
    [pane.view addSubview:picker];                                       // @0x317b0-0x317c8
    [pane.view bringSubviewToFront:pane.handle];                         // @0x317e8-0x31804
    [self relayoutAnimated:YES];                                         // @0x31818
    picker.alpha = 0;                                                    // @0x31824
    [UIView animateWithDuration:0.25                                     // @0x3186c; block @0x31954 sets alpha = 1
                     animations:^{ picker.alpha = 1; }];
    DCHL45OverlayTrace(self,@"picker-presented",pane,picker);
    DCHL45ScheduleTrace(self,@"picker-fade-settled",pane,picker,0.32);
    [self refreshPickerSheetSoon];                                       // @0x3187c
}

- (void)removePickerFromPane:(SCPCarPane *)pane {                         // 0x313ac VERIFIED
    UIView *picker = pane.picker;
    if (picker == nil) return;
    DCHL45OverlayTrace(self,@"picker-remove-request",pane,picker);
    pane.picker = nil;
    __weak SCPCarSplit *hl45Split=self;
    __weak SCPCarPane *hl45Pane=pane;
    [UIView animateWithDuration:0.15
        animations:^{ picker.alpha = 0; }              // VERIFIED (CLOSURE-2): invoke
                                                       // @0x3151c = [picker setAlpha:0]
        completion:^(BOOL finished) {
            [picker removeFromSuperview];
            DCHL45OverlayTrace(hl45Split,@"picker-remove-complete",hl45Pane,picker);
        }]; // @0x31528 VERIFIED
    [self refreshPickerSheetSoon];
}

- (void)showPickersForEmptySlots {                                       // 0x2fb40 (approx.)
    for (int i = 0; i < self.paneCount; i++)
        if (![self slotOccupied:i])
            [self showPickerForSlot:i];
}

- (void)pickerPaneTapped:(UITapGestureRecognizer *)gr {                   // 0x30010 (approx.)
    SCPCarPane *pane = [self paneForView:gr.view];
    if (pane != nil && pane.picker != nil) {
        self.pickerSheetPane = pane;
        [self refreshPickerSheetSoon];
    }
}

// MARK: - Picker sheet

- (void)refreshPickerSheetSoon {                                         // 0x30100 (approx.)
    if (self.pickerSheetQueued) return;
    self.pickerSheetQueued = YES;
    dispatch_async(dispatch_get_main_queue(), ^{
        self.pickerSheetQueued = NO;
        [self refreshPickerSheet];
    });
}

// VERIFIED (CLOSURE-2; parent IMP 0x31ba0, comparator block invoke
// @0x31c38 — the earlier "@0x30218" was a landing pad of another
// function): the float pane sorts LAST; the other panes compare by the
// frames of their SLOTS ([self frameForSlot:pane.slot], not view.frame),
// X first with a 1.0 tolerance, then Y, then the slot number itself.
// disasm/rem2_panesInReadingOrder.txt + rem2_readingOrderComparator.txt.
- (NSArray *)panesInReadingOrder {
    return [self.allPanes sortedArrayUsingComparator:
        ^NSComparisonResult(SCPCarPane *a, SCPCarPane *b) {
            SCPCarPane *floatPane = self.floatPane;
            BOOL aFloat = (a == floatPane), bFloat = (b == floatPane);
            if (aFloat != bFloat)
                return aFloat ? NSOrderedDescending : NSOrderedAscending;
            CGRect fa = [self frameForSlot:a.slot];
            CGRect fb = [self frameForSlot:b.slot];
            if (fabs(CGRectGetMinX(fa) - CGRectGetMinX(fb)) > 1.0)
                return CGRectGetMinX(fa) < CGRectGetMinX(fb)
                    ? NSOrderedAscending : NSOrderedDescending;
            if (fabs(CGRectGetMinY(fa) - CGRectGetMinY(fb)) > 1.0)
                return CGRectGetMinY(fa) < CGRectGetMinY(fb)
                    ? NSOrderedAscending : NSOrderedDescending;
            return a.slot < b.slot ? NSOrderedAscending : NSOrderedDescending;
        }];
}

// CLOSED (was PARTIAL): resolves the sheet's pane, rebuilds the sheet
// when the state key changed, and re-marks the panes. The stored
// pickerSheetPane WINS while it is still in allPanes and its picker is
// live: the original keeps it in x20 and the fallback enumeration tests
// a candidate only while x20 == nil (@0x31fd8 cbnz skips the test), so
// the reading-order scan is a fallback for an invalid stored pane,
// never an override. (A previous draft validated the stored pane and
// then discarded it, always rescanning from nil — the sheet jumped
// back to the first picker pane on every refresh; GPT Deep Function
// Wiring Audit N2, fixed 2026-11-09.) There is no float-pane branch in
// the body; the fallback order is panesInReadingOrder (sorted
// allPanes). @0x31eac.
- (void)refreshPickerSheet {
    NSArray *panes = self.active ? self.allPanes : @[];
    SCPCarPane *sheetPane = self.pickerSheetPane;
    if (sheetPane.picker == nil || ![panes containsObject:sheetPane])
        sheetPane = nil;
    NSArray *order = self.active ? [self panesInReadingOrder] : @[];
    SCPCarPane *found = sheetPane;
    if (found == nil) {
        for (SCPCarPane *pane in order) {
            if (pane.picker != nil) { found = pane; break; }
        }
    }
    self.pickerSheetPane = found;
    if (found == nil) {
        [self removePickerSheet];
        return;
    }
    if (self.container.window == nil) {
        [self removePickerSheet];
        return;
    }
    NSString *key = [NSString stringWithFormat:@"%p/%d/%lu/%d/%@",
        (void *)found, found.slot, (unsigned long)panes.count,
        (int)self.mainStack, NSStringFromCGSize(self.container.bounds.size)];
    if (self.pickerSheet == nil || ![key isEqualToString:self.pickerSheetKey]) {
        [self buildPickerSheetForPane:found];
        self.pickerSheetKey = key;
    }
    [self markPickerPanes];
}

// CLOSED (was STUB-UNRECOVERED): the app-grid sheet. Hosted in the tray
// window when one exists (frames converted to window coordinates), else
// directly in the container. Layout: TWO regions — a paging scroll view
// of 62x56 app cells (SCPCButton) at x=0 in contentView, and a 150-pt
// side column at (gridW, 0) holding the slot-map header, title/subtitle
// and cancel in column-local coordinates. (The two-region tree was
// restored 2026-11-09 per the GPT video audit: the previous build
// parented the header block to contentView with area-wide coordinates,
// so the grid drew over it.) @0x334e4 (9,628 bytes).
- (void)buildPickerSheetForPane:(SCPCarPane *)pane {
    // [hl6-picker] pin the close-done snapshot NOW, tied to the
    // sheet this call creates (see the statics' note above):
    // refreshPickerSheet may nil pickerSheetPane before the sheet
    // is removed, but it never touches these scalars.
    SCPickerMeasureSlot = pane.slot;
    SCPickerMeasurePreBundle = [pane.bundleID copy];
    UIView *oldSheet = self.pickerSheet;
    UIView *oldShield = self.pickerShield;
    UIWindow *window = [self trayWindowForParent:self.container];
    CGRect area;
    UIView *host;
    if (window != nil) {
        area = [self.container convertRect:self.container.bounds toView:nil];
        host = window;
    } else {
        area = self.container.bounds;
        host = self.container;
    }
    [oldShield removeFromSuperview];

    // App list: native CarPlay apps + chosen phone apps; the float pane
    // only offers non-bridged apps.
    NSMutableArray *apps = [NSMutableArray array];
    NSArray *all = [SCPCarPlayAppInfos()
        arrayByAddingObjectsFromArray:SCPChosenPhoneAppInfos()];
    for (NSDictionary *info in all) {
        if (pane == self.floatPane && SCPIsBridgedPhoneApp(info[@"id"]))
            continue;
        [apps addObject:info];
    }

    double areaW = area.size.width, areaH = area.size.height;
    double scale = (areaW > 1) ? MIN(96.0 * areaH / areaW, 56.0) : 40.0;

    NSString *title = (pane != self.floatPane)
        ? [NSString stringWithFormat:
               OMCTr(@"Chọn app cho ô %d", @"Choose an app for pane %d"),
               pane.slot + 1]
        : OMCTr(@"Chọn app cho cửa sổ nổi",
                @"Choose an app for the floating window");
    NSString *subtitle = OMCTr(@"Chạm 1 app để mở vào ô này",
                               @"Tap an app to open it here");
    UIFont *titleFont = [UIFont systemFontOfSize:12.5 weight:UIFontWeightSemibold];
    UIFont *subFont = [UIFont systemFontOfSize:10.5];
    double titleH = ceil([title boundingRectWithSize:CGSizeMake(134, 40)
        options:1 attributes:@{NSFontAttributeName: titleFont} context:nil].size.height);
    double subH = ceil([subtitle boundingRectWithSize:CGSizeMake(134, 30)
        options:1 attributes:@{NSFontAttributeName: subFont} context:nil].size.height);

    NSInteger count = (NSInteger)apps.count;
    NSInteger t = (NSInteger)((areaW - 194.0) / 62.0);
    NSInteger cols = MAX(MIN(MAX(count, 4), t), 1);
    NSInteger rowsAvail = MAX((NSInteger)((areaH - 44.0) / 56.0), 1);
    NSInteger totalRows = (count + cols - 1) / cols;
    NSInteger rowsPerPage = MAX(MIN(rowsAvail, totalRows), 1);
    NSInteger perPage = rowsPerPage * cols;
    NSInteger pages = MAX((count + perPage - 1) / perPage, 1);
    double gridH = rowsPerPage * 56.0 + 4.0;
    double extra = (pages > 1) ? 16.0 : 0.0;   // VERIFIED (CLOSURE-2): parent
                                               // @0x33ad8 fcsel gt on (pages > 1)
                                               // picks 16.0; disasm/rem2_buildPickerSheetForPane.txt
    double headerH = scale + 10.0 + 8.0 + titleH + 2.0 + subH;
    double sheetH = MIN(areaH - 16.0, MAX(headerH + 66.0, gridH + 14.0 + extra));
    // Constant CORRECTED 18.0 -> 14.0 (remediation, 2026-11-08): the
    // binary's grid candidate is gridH + 8.0 + extra + 6.0 (fadd chain
    // @0x33afc/@0x33b04/@0x33b0c in disasm/rem2_buildPickerSheetForPane.txt),
    // i.e. gridH + 14.0 + extra, before the MAX at @0x33b10-0x33b14.
    double sheetW = cols * 62.0 + 20.0;

    UIView *sheet = [[UIView alloc] initWithFrame:CGRectMake(
        CGRectGetMidX(area) - (sheetW + 150.0) * 0.5,
        CGRectGetMidY(area) - sheetH * 0.5, sheetW + 150.0, sheetH)];
    sheet.layer.cornerRadius = 24;
    sheet.layer.cornerCurve = kCACornerCurveContinuous;
    sheet.layer.shadowColor = [UIColor colorWithRed:0.43137254901960786
                                              green:0.39215686274509803
                                               blue:0.7843137254901961
                                              alpha:1.0].CGColor;
    sheet.layer.shadowOpacity = 0.3f;
    sheet.layer.shadowRadius = 24;
    sheet.layer.shadowOffset = CGSizeMake(0, 8);

    UIVisualEffectView *effectView = SCPKnobFaceView(); // [phase2; backported to src in phase 3] name unified
    effectView.frame = sheet.bounds;
    // [hl44-original] Direct original DEB picker face: no HL5 clear/mesh switch.
    SCPApplyMeshBackdrop(effectView);
    effectView.layer.cornerRadius = 24;
    effectView.layer.cornerCurve = kCACornerCurveContinuous;
    effectView.clipsToBounds = YES;
    [sheet addSubview:effectView];
    UIView *contentView = effectView.contentView;

    // Side column right of the grid: a dedicated UIView at (gridW, 0)
    // with width 150.0 (constant loaded @0x33b7c; frame built
    // @0x33d98-0x33da8) and height sheetH, child of contentView. The
    // slot-map wrapper (@0x34114), title, subtitle (@0x3429c) and cancel
    // (@0x3445c) are ALL children of this column in column-local
    // coordinates; the scroll grid stays in contentView (@0x344e8).
    UIView *sideColumn = [[UIView alloc] initWithFrame:
        CGRectMake(sheetW, 0, 150.0, sheetH)];
    sideColumn.backgroundColor = UIColor.clearColor;
    [contentView addSubview:sideColumn];
    CAGradientLayer *grad = [CAGradientLayer layer];
    grad.frame = CGRectMake(0, 10, 1, sheetH - 20);
    UIColor *navy = [UIColor colorWithRed:0.2901960784313726
                                    green:0.30980392156862746
                                     blue:0.5019607843137255 alpha:1.0];
    grad.colors = @[(id)[navy colorWithAlphaComponent:0].CGColor,
                    (id)[navy colorWithAlphaComponent:0.32].CGColor,
                    (id)[navy colorWithAlphaComponent:0.32].CGColor,
                    (id)[navy colorWithAlphaComponent:0].CGColor];
    grad.locations = @[@0.0, @0.2, @0.8, @1.0];
    [sideColumn.layer addSublayer:grad];

    // Slot-map header.
    UIView *map = [self pickerMapForPane:pane height:scale];
    double mapW = (map != nil) ? map.bounds.size.width + 10.0 : 106.0;
    // Wrapper x is (150.0 - mapW)/2 in sideColumn-local coordinates
    // (dump @0x33ff4-0x33ffc) and the vertical offset constant is 54.0
    // (dump @0x33fe8, bit pattern 0x404b000000000000), not 52.0.
    UIView *wrapper = [[UIView alloc] initWithFrame:CGRectMake(
        (150.0 - mapW) * 0.5,
        MAX((sheetH - 68.0 - headerH) * 0.5, 0) + 54.0, mapW, scale + 10.0)];
    wrapper.backgroundColor = [UIColor colorWithWhite:1 alpha:0.35];
    wrapper.layer.cornerRadius = 12;
    wrapper.layer.cornerCurve = kCACornerCurveContinuous;
    wrapper.layer.borderWidth = 1;
    wrapper.layer.borderColor = [UIColor colorWithWhite:1 alpha:0.7].CGColor;
    [sideColumn addSubview:wrapper];
    if (map != nil) {
        map.frame = CGRectMake(5, 5, map.bounds.size.width, scale);
        [wrapper addSubview:map];
    }

    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(
        8, CGRectGetMaxY(wrapper.frame) + 8, 134, titleH)];
    titleLabel.text = title;
    titleLabel.font = titleFont;
    titleLabel.textColor = navy;
    titleLabel.numberOfLines = 2;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [sideColumn addSubview:titleLabel];

    UILabel *subLabel = [[UILabel alloc] initWithFrame:CGRectMake(
        8, CGRectGetMaxY(titleLabel.frame) + 2, 134, subH)];
    subLabel.text = subtitle;
    subLabel.font = subFont;
    subLabel.textColor = SCPColorSecondary();
    subLabel.numberOfLines = 2;
    subLabel.textAlignment = NSTextAlignmentCenter;
    [sideColumn addSubview:subLabel];

    NSInteger otherPickers = 0;
    for (SCPCarPane *p in self.allPanes)
        if (p.picker != nil && p != pane) otherPickers++;

    // Cancel chip in the side column: centre (120, 30) in column-local
    // coordinates (dump @0x34448-0x34458). The previous build had the
    // axes swapped — centre (30, 120) — and the wrong parent.
    UIView *cancel = SCPWrapRatioChip(SCPSymbolImage(@"close", 14.0),
                                      self, @selector(pickerCancel:));
    cancel.bounds = CGRectMake(0, 0, 32, 32);
    cancel.layer.cornerRadius = 16;
    SCPStyleChip(cancel, 16.0);
    cancel.tintColor = [UIColor colorWithRed:1.0 green:0.35294117647058826
                                        blue:0.37254901960784315 alpha:1.0];
    cancel.center = CGPointMake(120, 30);
    [sideColumn addSubview:cancel];

    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(
        0, MAX((sheetH - gridH - extra) * 0.5, 8), sheetW, gridH)];
    scrollView.pagingEnabled = YES;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.alwaysBounceHorizontal = (pages > 1);
    scrollView.delegate = self;
    [contentView addSubview:scrollView];
    scrollView.contentSize = CGSizeMake(pages * sheetW, gridH);

    NSMutableSet *used = [NSMutableSet set];
    for (SCPCarPane *p in self.allPanes)
        if (p.bundleID != nil) [used addObject:p.bundleID];
    [used addObjectsFromArray:self.pending.allKeys];

    NSMutableArray *shownCells = [NSMutableArray array];
    for (NSInteger i = 0; i < count; i++) {
        NSDictionary *info = apps[i];
        NSString *bundleID = info[@"id"];
        NSInteger col = i % cols;
        NSInteger page = i / perPage;
        NSInteger rowInPage = (i % perPage) / cols;
        SCPCButton *cell = [SCPCButton buttonWithType:0];
        cell.frame = CGRectMake(page * sheetW + 10 + col * 62,
                                rowInPage * 56 + 2, 62, 56);
        cell.accessibilityIdentifier = bundleID;
        [cell addTarget:self action:@selector(pickerAppTapped:)
               forControlEvents:UIControlEventTouchUpInside];
        cell.accessibilityLabel = info[@"name"];
        UIImageView *iconView = [[UIImageView alloc] initWithFrame:
            CGRectMake(12, 9, 38, 38)];
        iconView.image = SCPAppIconForBundle(bundleID);
        SCPStyleGhostIcon(iconView);
        iconView.userInteractionEnabled = NO;
        UIView *shadowView = [[UIView alloc] initWithFrame:iconView.frame];
        shadowView.userInteractionEnabled = NO;
        shadowView.layer.shadowColor = [UIColor colorWithRed:0.43137254901960786
                                                       green:0.39215686274509803
                                                        blue:0.7843137254901961
                                                       alpha:1.0].CGColor;
        shadowView.layer.shadowOpacity = 0.25f;
        shadowView.layer.shadowRadius = 5;
        shadowView.layer.shadowOffset = CGSizeMake(0, 4);
        shadowView.layer.shadowPath =
            [UIBezierPath bezierPathWithRoundedRect:iconView.bounds
                cornerRadius:iconView.layer.cornerRadius].CGPath;
        [cell addSubview:shadowView];
        [cell addSubview:iconView];
        if ([used containsObject:bundleID]) {
            UIImageView *badge = [[UIImageView alloc] initWithImage:
                SCPSymbolImage(@"check", 10.0)];
            badge.tintColor = UIColor.whiteColor;
            badge.backgroundColor = [UIColor colorWithRed:0.6078431372549019
                                                    green:0.5294117647058824
                                                     blue:0.9725490196078431
                                                    alpha:1.0];
            badge.frame = CGRectMake(CGRectGetMaxX(iconView.frame) - 10,
                                     CGRectGetMinY(iconView.frame) - 4, 14, 14);
            badge.contentMode = UIViewContentModeScaleAspectFit;
            badge.layer.cornerRadius = 7;
            badge.layer.borderWidth = 1;
            badge.layer.borderColor = UIColor.whiteColor.CGColor;
            badge.clipsToBounds = YES;
            badge.userInteractionEnabled = NO;
            [cell addSubview:badge];
            for (UIView *sub in cell.subviews) sub.alpha = 0.3;
            cell.userInteractionEnabled = NO;
            cell.accessibilityTraits |= UIAccessibilityTraitNotEnabled;
        }
        [scrollView addSubview:cell];
        if (i < perPage) [shownCells addObject:cell];
    }

    if (pages >= 2) {
        UIView *dotsView = [[UIView alloc] initWithFrame:
            CGRectMake(0, gridH + extra, sheetW, 16)];
        dotsView.userInteractionEnabled = NO;
        for (NSInteger i = 0; i < pages; i++) {
            UIView *dot = [[UIView alloc] init];
            dot.layer.cornerRadius = 3;
            [dotsView addSubview:dot];
        }
        self.pickerDots = dotsView;
        [contentView addSubview:dotsView];
        // The binary stores 1 in the dots view's tag at build time
        // (transcribed literally; scrollViewDidScroll: below uses the
        // same tag as the current page — see closure addendum).
        dotsView.tag = 1;
        [self layoutPickerDotsForPage:0];
    } else {
        self.pickerDots = nil;
    }

    if (count == 0) {
        UILabel *empty = [[UILabel alloc] initWithFrame:scrollView.bounds];
        empty.text = OMCTr(@"Không có app", @"No apps");
        empty.textColor = SCPColorSecondary();
        empty.textAlignment = NSTextAlignmentCenter;
        [scrollView addSubview:empty];
    }

    [host addSubview:sheet];
    if (self.tray != nil && self.tray.superview == host)
        [host bringSubviewToFront:self.tray];
    self.pickerSheet = sheet;
    self.pickerShield = nil;
    self.pickerSheetOverlay = (window != nil);
    [self updatePopupShield];
    [self publishBusy];
    DCHL45OverlayTrace(self,@"sheet-new-attached",pane,oldSheet);
    DCHL45ScheduleTrace(self,@"sheet-fade-settled",pane,sheet,0.60);

    // Entrance: cross-fade from an old sheet, spring up otherwise.
    if (oldSheet != nil) {
        __weak SCPCarSplit *hl45Owner=self;
        __weak SCPCarPane *hl45Pane=pane;
        [UIView animateWithDuration:0.15
            animations:^{ oldSheet.alpha = 0; }
            completion:^(BOOL finished) {
                [oldSheet removeFromSuperview];
                DCHL45OverlayTrace(hl45Owner,@"sheet-old-removed",hl45Pane,oldSheet);
            }];
    }
    sheet.alpha = 0;
    sheet.transform = (oldSheet != nil)
        ? CGAffineTransformMakeTranslation(0, 14)
        : CGAffineTransformScale(CGAffineTransformMakeTranslation(0, 48),
                                 0.92, 0.92);
    [UIView animateWithDuration:(oldSheet != nil) ? 0.35 : 0.5
                          delay:0
         usingSpringWithDamping:0.86
          initialSpringVelocity:0.4
                        options:6
                     animations:^{
                         sheet.alpha = 1;
                         sheet.transform = CGAffineTransformIdentity;
                     } completion:nil];
    for (UIView *cell in shownCells) {
        cell.alpha = 0;
        cell.transform = CGAffineTransformMakeTranslation(0, 16);
        NSInteger row = (NSInteger)((cell.frame.origin.y - 2) / 56);
        NSInteger col = (NSInteger)((cell.frame.origin.x - 10) / 62);
        [UIView animateWithDuration:0.45
                              delay:row * 0.05 + col * 0.012
             usingSpringWithDamping:0.85
              initialSpringVelocity:0.3
                            options:2
                         animations:^{
                             cell.alpha = 1;
                             cell.transform = CGAffineTransformIdentity;
                         } completion:nil];
    }

    if (window == nil) [self pushHostFramesLive:NO];
    OMCLogWrite(@"SplitScreen",
        [NSString stringWithFormat:@"CarSplit: popup chon %ld app cho o %d (%s, %d o cho)",
            (long)count, pane.slot, window != nil ? "cua so rieng" : "container",
            (int)otherPickers]);
    // [picker-measure2] (hl3, MEASURE ONLY): post-presentation
    // measurement replacing the missed pre-presentation capture of
    // [picker-measure] (hl2 L5/L6: picker super=nil, trayWin hidden=1
    // in 13/13 opens because that line ran BEFORE presentation).
    // Placed at the very end of buildPickerSheetForPane:, after
    // [host addSubview:sheet] + self.pickerSheet = sheet, so the
    // sheet, picker, cover, scene host and tray window are read in
    // their final presented state. Read-only: logs only, no view
    // behaviour is changed.
    // [picker-measure3] (hl4, MEASURE ONLY): the hl3 session
    // (29.23 L5) still could not convict a cover: every measure2
    // field matched between hosted and native opens, the trayWin
    // opaque-background hypothesis was refuted on its bg field, and
    // the SHEET was left as the only standing candidate while its
    // background was absent from 10/10 lines. This extension adds
    // exactly the fields 29.23 L5 listed as missing, at the same
    // post-presentation point: (1) sheetBg/sheetFx/fxContentBg —
    // the sheet's own background (nil: its face is the
    // UIVisualEffectView subview) plus that effect view's state and
    // its contentView background; (2) sceneBg/sceneSubs — the pane
    // scene host's own background (nil) plus the class/state of the
    // subviews that actually carry the hosted scene; (3) psub —
    // class/frame/bg/alpha/hidden of the picker's single subview
    // (subs=1 in hl3); (4) shield/pshield — popupShield and
    // pickerShield state AT presented (measure2 omitted both);
    // (5) z{...} — subview-order position of picker vs scene host
    // inside the pane and of the sheet inside its host, plus both
    // window levels. All measure2 fields are kept verbatim.
    {
        BOOL measureHasContent = (pane.vc != nil || [self slotOccupied:pane.slot]);
        UIWindow *measureWin = self.trayWindow;
        NSString *measureWinBg = @"?";
        if (measureWin.backgroundColor != nil) {
            CGFloat wr = 0, wg = 0, wb = 0, wa = 0;
            if ([measureWin.backgroundColor getRed:&wr green:&wg blue:&wb alpha:&wa])
                measureWinBg = [NSString stringWithFormat:@"%.3f,%.3f,%.3f,%.3f", wr, wg, wb, wa];
        }
        UIVisualEffectView *measureFx = nil;
        for (UIView *sub in self.pickerSheet.subviews)
            if ([sub isKindOfClass:UIVisualEffectView.class]) {
                measureFx = (UIVisualEffectView *)sub;
                break;
            }
        UIView *measurePSub = pane.picker.subviews.firstObject;
        OMCLogWrite(@"SplitScreen", [NSString stringWithFormat:
            @"[picker-measure2] phase=presented slot=%d hosted=%d hasContent=%d picker{%@ subs=%lu} psub{%@} sheet{%@} sheetBg=%@ sheetFx{%@} fxContentBg=%@ cover{%@} scene{%@} sceneBg=%@ sceneSubs{%@} shield{%@} pshield{%@} z{picker=%@ host=%@ sheet=%@ pwin=%.0f swin=%.0f} trayWin{hidden=%d alpha=%.2f frame=%@ level=%.0f bg=%@ root{%@}}",
            pane.slot, SCPIsBridgedPhoneApp(pane.bundleID) ? 1 : 0, (int)measureHasContent,
            SCPViewMeasureDesc(pane.picker), (unsigned long)pane.picker.subviews.count,
            measurePSub ? [NSString stringWithFormat:@"%@{%@}",
                NSStringFromClass(measurePSub.class),
                SCPViewMeasureDesc(measurePSub)] : @"none",
            SCPViewMeasureDesc(self.pickerSheet),
            SCPMeasureBgRaw(self.pickerSheet.backgroundColor),
            SCPViewMeasureDesc(measureFx),
            SCPMeasureBgRaw(measureFx.contentView.backgroundColor),
            SCPViewMeasureDesc(pane.cover),
            SCPViewMeasureDesc(pane.host),
            SCPMeasureBgRaw(pane.host.backgroundColor),
            SCPMeasureSubviewDescs(pane.host),
            SCPViewMeasureDesc(self.popupShield),
            SCPViewMeasureDesc(self.pickerShield),
            SCPMeasureZIndex(pane.picker), SCPMeasureZIndex(pane.host),
            SCPMeasureZIndex(self.pickerSheet),
            pane.picker.window ? pane.picker.window.windowLevel : -1.0,
            self.pickerSheet.window ? self.pickerSheet.window.windowLevel : -1.0,
            measureWin ? (int)measureWin.isHidden : -1,
            measureWin ? measureWin.alpha : 0.0,
            measureWin ? NSStringFromCGRect(measureWin.frame) : @"nil",
            measureWin ? measureWin.windowLevel : -1.0,
            measureWinBg,
            SCPViewMeasureDesc(measureWin.rootViewController.view)]);
    }
    // [hl6-picker] MEASURE ONLY: surface evidence at presented —
    // the window hierarchy of the sheet and the scene-surface state
    // of the TARGET pane, so the next round can convict or clear
    // the sheet's window for the picture loss without guessing
    // (29.29 left compositing unproven: effectNil=1 does not prove
    // the media surface under a level-1065 window still shows).
    // Read-only, like every measure block in this method.
    {
        UIView *surfSheet = self.pickerSheet;
        UIView *surfHost = pane.host;
        UIView *surfVCView = pane.vc.view;
        OMCLogWrite(@"SplitScreen", [NSString stringWithFormat:
            @"[picker-surface] phase=presented slot=%d "
            @"sheetChain{%@} sheetWin=%@ sheetLevel=%.0f "
            @"hostChain{%@} hostWin=%@ hostLevel=%.0f sameWin=%d "
            @"vcViewInHost=%d vcViewSuper=%@ hostSubs=%lu",
            pane.slot,
            SCPMeasureChainDesc(surfSheet),
            surfSheet.window ? NSStringFromClass(surfSheet.window.class) : @"nil",
            surfSheet.window ? surfSheet.window.windowLevel : -1.0,
            SCPMeasureChainDesc(surfHost),
            surfHost.window ? NSStringFromClass(surfHost.window.class) : @"nil",
            surfHost.window ? surfHost.window.windowLevel : -1.0,
            (surfSheet.window && surfHost.window &&
             surfSheet.window == surfHost.window) ? 1 : 0,
            (surfVCView && surfVCView.superview == surfHost) ? 1 : 0,
            surfVCView.superview ? NSStringFromClass(surfVCView.superview.class)
                                 : @"nil",
            (unsigned long)(surfHost ? surfHost.subviews.count : 0)]);
    }
}

// CLOSED (was PARTIAL): the sheet's pane gets a 3 pt border on its picker
// placeholder; every other pane's picker border is cleared. @0x322cc.
- (void)markPickerPanes {
    for (SCPCarPane *pane in self.allPanes)
        pane.picker.layer.borderWidth = (pane == self.pickerSheetPane) ? 3.0 : 0.0;
}

// CLOSED (was PARTIAL): tears the sheet down with a 0.22 s fade/drop and
// hides the tray window once nothing else uses it. The binary does NOT
// clear pickerSheetPane here. @0x32498.
- (void)removePickerSheet {
    UIView *sheet = self.pickerSheet;
    UIView *shield = self.pickerShield;
    // [picker-measure2] (hl4-D1, MEASURE ONLY): the sheet's pane,
    // captured before the teardown nils the sheet ivars (this
    // method deliberately does NOT clear pickerSheetPane, but the
    // completion below reads the pane's post-close state, so pin
    // the object here).
    // [hl5-picker] GPT verdict HL4->HL5, ruling 1 (L6): pin SCALARS,
    // not the pane object — in hl4 the pinned object read slot=-1 /
    // bundle NULL at close-done for hosted panes whose pane was still
    // attached, so the measurement itself was broken, not the pane.
    // The completion below re-resolves the CURRENT pane at the slot
    // that was targeted when the sheet presented.
    // [hl6-picker] GPT work order HL5->HL6 (d313f17), item 3: the
    // hl5 scalars were still read off self.pickerSheetPane HERE —
    // and refreshPickerSheet nils pickerSheetPane on its
    // found==nil path BEFORE calling this method, so hl5 read
    // slot=-1 in 4/4 closes (29.29). The scalars now come from the
    // snapshot pinned at sheet CREATION (buildPickerSheetForPane:),
    // copied into locals at entry so the completion below reports
    // the sheet THIS call closes even if a rebuild re-pins them.
    NSInteger measureSlot = SCPickerMeasureSlot;
    NSString *measurePreBundle = SCPickerMeasurePreBundle;
    BOOL overlay = self.pickerSheetOverlay;
    if (sheet) DCHL45OverlayTrace(self,@"sheet-remove-request",
        measureSlot>=0 && measureSlot<(NSInteger)self.slots.count ? self.slots[(NSUInteger)measureSlot] : nil,sheet);
    self.pickerSheet = nil;
    self.pickerShield = nil;
    self.pickerSheetKey = nil;
    self.pickerSheetOverlay = NO;
    [self updatePopupShield];
    [self publishBusy];
    if (sheet != nil || shield != nil) {
        UIWindow *window = self.trayWindow;
        __weak SCPCarSplit *weakSelf = self;
        [UIView animateWithDuration:0.22 delay:0 options:UIViewAnimationOptionLayoutSubviews
            animations:^{
                sheet.alpha = 0;
                if ([shield isKindOfClass:UIVisualEffectView.class]) {
                    ((UIVisualEffectView *)shield).effect = nil;
                    ((UIVisualEffectView *)shield).contentView.alpha = 0;
                } else {
                    shield.alpha = 0;
                }
                sheet.transform = CGAffineTransformScale(
                    CGAffineTransformMakeTranslation(0, 24), 0.92, 0.92);
            } completion:^(BOOL finished) {
                [sheet removeFromSuperview];
                [shield removeFromSuperview];
                SCPCarSplit *s = weakSelf;
                if (s) DCHL45OverlayTrace(s,@"sheet-remove-complete",
                    measureSlot>=0 && measureSlot<(NSInteger)s.slots.count ? s.slots[(NSUInteger)measureSlot] : nil,sheet);

                if (window != nil && s != nil && s.tray == nil &&
                    s.ratioMenu == nil && s.pickerSheet == nil)
                    window.hidden = YES;
                // [picker-measure2] (hl4-D1, MEASURE ONLY, GPT
                // ruling 533ac9a): post-close record — every sheet
                // close (choose AND cancel both end in this 0.22 s
                // animation's completion) states whether the sheet
                // is really gone, whether the target pane still
                // holds its scene, and whether the pane's content
                // is back on screen. The path (choose vs cancel)
                // is the close-choose / close-cancel line logged
                // for the same slot ~0.22 s earlier. Logs only;
                // no view state is touched.
                // [hl5-picker] re-resolve the CURRENT pane at the
                // slot pinned at presentation (GPT ruling 1, L6): a
                // pane object pinned at open time goes stale, and a
                // chosen pane may legitimately hold a NEW bundle by
                // now — preBundle vs paneBundle is the comparison.
                // The old contentBack field is renamed
                // hostStructPresent: it only ever verified structure
                // (host attached, visible, alpha > 0), never pixels.
                SCPCarPane *donePane = s ? [s paneAtSlot:measureSlot] : nil;
                OMCLogWrite(@"SplitScreen", [NSString stringWithFormat:
                    @"[picker-measure2] phase=close-done slot=%ld finished=%d "
                     "sheetGone=%d sheet{%@} shieldGone=%d shield{%@} "
                     "preBundle=%@ paneBundle=%@ paneHasVC=%d host{%@} hostSuper=%@ "
                     "hostStructPresent=%d",
                    (long)measureSlot, finished ? 1 : 0,
                    sheet.superview == nil ? 1 : 0, SCPViewMeasureDesc(sheet),
                    shield.superview == nil ? 1 : 0, SCPViewMeasureDesc(shield),
                    measurePreBundle, donePane.bundleID,
                    donePane.vc != nil ? 1 : 0,
                    SCPViewMeasureDesc(donePane.host),
                    donePane.host.superview
                        ? NSStringFromClass(donePane.host.superview.class)
                        : @"nil",
                    (donePane.host && !donePane.host.hidden &&
                     donePane.host.alpha > 0 &&
                     donePane.host.superview != nil) ? 1 : 0]);
                // [hl6-picker] MEASURE ONLY: the target pane's
                // surface state AFTER the close callback — the
                // closing counterpart of the [picker-surface]
                // presented line, so a lost picture can be told
                // apart from a lost structure next round.
                OMCLogWrite(@"SplitScreen", [NSString stringWithFormat:
                    @"[picker-surface] phase=close-done slot=%ld "
                    @"hostChain{%@} hostWin=%@ vcViewInHost=%d "
                    @"hostSubs=%lu sheetSuper=%@",
                    (long)measureSlot,
                    SCPMeasureChainDesc(donePane.host),
                    donePane.host.window
                        ? NSStringFromClass(donePane.host.window.class)
                        : @"nil",
                    (donePane.vc.view &&
                     donePane.vc.view.superview == donePane.host) ? 1 : 0,
                    (unsigned long)(donePane.host
                        ? donePane.host.subviews.count : 0),
                    sheet.superview
                        ? NSStringFromClass(sheet.superview.class)
                        : @"nil"]);
            }];
        if (!overlay && self.active)
            [self pushHostFramesLive:NO];
    }
}

// CLOSED (was STUB-UNRECOVERED): miniature map of the current split; one
// button per pane (icon when occupied, "+" when empty and picker-less).
// The target pane's button carries the accent gradient. @0x329a0.
- (UIView *)pickerMapForPane:(SCPCarPane *)pane height:(double)height {
    CGSize size = self.container.bounds.size;
    if (size.width <= 1 || size.height <= 1) return nil;
    double scale = height / size.height;
    UIView *map = [[UIView alloc] initWithFrame:
        CGRectMake(0, 0, size.width * scale, height)];
    for (SCPCarPane *p in self.allPanes) {
        CGRect frame = (p == self.floatPane)
            ? self.floatFrame : [self frameForSlot:p.slot];
        if (frame.size.width < 1 || frame.size.height < 1) continue;
        CGRect rect = CGRectInset(CGRectMake(frame.origin.x * scale,
                                             frame.origin.y * scale,
                                             frame.size.width * scale,
                                             frame.size.height * scale),
                                  1.5, 1.5);
        NSString *bundleID = nil;
        if (p.picker == nil) {
            bundleID = p.bundleID;
            if (bundleID == nil) {
                for (NSString *key in self.pending) {
                    NSArray *entry = self.pending[key];
                    if (((NSNumber *)entry[0]).intValue == p.slot) { bundleID = key; break; } // [phase2; backported to src in phase 3] untyped NSArray subscript yields id
                }
            }
        }
        SCPCButton *button = [SCPCButton buttonWithType:0];
        button.frame = rect;
        button.tag = p.slot;
        button.layer.cornerRadius = 5;
        button.layer.cornerCurve = kCACornerCurveContinuous;
        if (p == pane) {
            button.backgroundColor = UIColor.clearColor;
            SCPApplyAccent(button, YES);
        } else {
            button.backgroundColor = [UIColor colorWithWhite:1
                alpha:(p.picker != nil) ? 0.6 : 0.45];
            button.layer.borderWidth = 1.5;
            button.layer.borderColor =
                [UIColor colorWithWhite:1 alpha:0.8].CGColor;
        }
        if (bundleID != nil) {
            double iconSize = MIN(floor(MIN(rect.size.width, rect.size.height) * 0.7), 22);
            UIImageView *icon = [[UIImageView alloc] initWithFrame:CGRectMake(
                (rect.size.width - iconSize) / 2, (rect.size.height - iconSize) / 2,
                iconSize, iconSize)];
            icon.image = SCPAppIconForBundle(bundleID);
            SCPStyleGhostIcon(icon);
            icon.userInteractionEnabled = NO;
            [button addSubview:icon];
        } else if (p.picker == nil) {
            UILabel *plus = [[UILabel alloc] initWithFrame:button.bounds];
            plus.text = @"+";
            plus.textAlignment = NSTextAlignmentCenter;
            plus.textColor = (p == pane) ? UIColor.whiteColor : SCPColorSecondary();
            plus.font = [UIFont systemFontOfSize:
                MIN(floor(MIN(rect.size.width, rect.size.height) * 0.8), 22)
                weight:(p == pane) ? UIFontWeightBold : UIFontWeightRegular];
            plus.userInteractionEnabled = NO;
            [button addSubview:plus];
        }
        button.userInteractionEnabled = (p.picker != nil && p != pane);
        [button addTarget:self action:@selector(pickerMapTapped:)
                 forControlEvents:UIControlEventTouchUpInside];
        [map addSubview:button];
    }
    return map;
}

- (void)pickerMapTapped:(UIView *)sender {
    SCPCarPane *pane = [self paneAtSlot:(int)sender.tag];
    if (pane != nil && pane.picker != nil) {
        self.pickerSheetPane = pane;
        [self refreshPickerSheetSoon];
    }
}

// CLOSED (was PARTIAL): centres the dot strip; the current page's dot is
// a 16 pt accent pill, the rest 6 pt navy at 20% alpha. @0x3b630.
- (void)layoutPickerDotsForPage:(NSInteger)page {
    UIView *dots = self.pickerDots;
    if (dots == nil) return;
    NSArray *subviews = dots.subviews;
    NSInteger n = (NSInteger)subviews.count;
    double total = (n - 1) * 6.0;
    for (NSInteger i = 0; i < n; i++) total += (i == page) ? 16.0 : 6.0;
    double x = (dots.bounds.size.width - total) * 0.5;
    double y = dots.bounds.size.height * 0.5 - 3.0;
    for (NSInteger i = 0; i < n; i++) {
        UIView *dot = subviews[i];
        double width = (i == page) ? 16.0 : 6.0;
        dot.frame = CGRectMake(x, y, width, 6);
        dot.backgroundColor = (i == page)
            ? [UIColor colorWithRed:0.6078431372549019 green:0.5294117647058824
                               blue:0.9725490196078431 alpha:1.0]
            : [[UIColor colorWithRed:0.2901960784313726 green:0.30980392156862746
                                 blue:0.5019607843137255 alpha:1.0]
                  colorWithAlphaComponent:0.2];
        x += width + 6.0;
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (self.pickerDots == nil) return;
    if (![scrollView isDescendantOfView:self.pickerSheet]) return;
    double w = scrollView.bounds.size.width;
    if (w <= 0) return;
    NSInteger page = (NSInteger)lround(scrollView.contentOffset.x / w);
    if (page == self.pickerDots.tag) return;
    self.pickerDots.tag = page;
    [UIView animateWithDuration:0.25 animations:^{
        [self layoutPickerDotsForPage:page];   // INFERRED call target
    }];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    if ([scrollView isDescendantOfView:self.tray])
        [self restartTrayTimer];
}

// CLOSED (was PARTIAL): an app cell was tapped — open the app in the
// sheet's pane and refresh the sheet if that pane still shows a picker.
// @0x362a0 (560 bytes, @try/@catch with log).
- (void)pickerAppTapped:(UIView *)sender {
    @try {
        SCPCarPane *pane = self.pickerSheetPane;
        if (pane == nil) pane = [self paneForView:sender];
        if (pane == nil) return;
        NSString *bundle = sender.accessibilityIdentifier;
        OMCLogWrite(@"SplitScreen",
            [NSString stringWithFormat:@"CarSplit: chon %@ cho o %d",
                bundle, pane.slot]);
        [self openApp:bundle slot:pane.slot];
        if (pane.picker != nil)
            [self refreshPickerSheetSoon];
        // [picker-measure2] (hl3, MEASURE ONLY): closing counterpart
        // of the post-presentation line in buildPickerSheetForPane: —
        // state right after openApp: + refreshPickerSheetSoon on the
        // choose path, replacing the missed pre-presentation capture
        // of [picker-measure] (hl2 L5/L6). Read-only: logs only.
        OMCLogWrite(@"SplitScreen", [NSString stringWithFormat:
            @"[picker-measure2] phase=close-choose slot=%d chosen=%@ paneBundle=%@ paneHasVC=%d picker{%@} sheet{%@} sceneSuper=%@",
            pane.slot, bundle, pane.bundleID, pane.vc != nil ? 1 : 0,
            SCPViewMeasureDesc(pane.picker), SCPViewMeasureDesc(self.pickerSheet),
            pane.host.superview ? NSStringFromClass(pane.host.superview.class) : @"nil"]);
    } @catch (id exception) {
        OMCLogWrite(@"SplitScreen",
            [NSString stringWithFormat:@"CarSplit: loi chon app %@\n%@",
                exception, ((NSException *)exception).callStackSymbols]);
    }
}

// CLOSED (B's draft only called removePickerSheet — wrong): cancel removes
// the picker from its pane; an occupied slot just relayouts, an empty
// float pane closes, any other empty pane is removed. @0x364d0 (@try/@catch).
- (void)pickerCancel:(UIView *)sender {
    @try {
        SCPCarPane *pane = self.pickerSheetPane;
        if (pane == nil) pane = [self paneForView:sender];
        if (pane == nil) return;
        [self removePickerFromPane:pane];
        if (pane.vc != nil || [self slotOccupied:pane.slot]) {
            [self relayoutAnimated:YES];
        } else if (pane == self.floatPane) {
            [self closeFloat:NO];
        } else {
            [self removePaneAt:pane.slot background:NO];
            [self afterPaneRemoved:nil];
        }
        // [picker-measure2] (hl3, MEASURE ONLY): closing counterpart
        // of the post-presentation line in buildPickerSheetForPane: —
        // state at the end of the cancel path (after the
        // relayout/closeFloat/removePane branch), replacing the
        // missed pre-presentation capture of [picker-measure]
        // (hl2 L5/L6). Read-only: logs only.
        OMCLogWrite(@"SplitScreen", [NSString stringWithFormat:
            @"[picker-measure2] phase=close-cancel slot=%d paneBundle=%@ paneHasVC=%d picker{%@} sheet{%@} sceneSuper=%@",
            pane.slot, pane.bundleID, pane.vc != nil ? 1 : 0,
            SCPViewMeasureDesc(pane.picker), SCPViewMeasureDesc(self.pickerSheet),
            pane.host.superview ? NSStringFromClass(pane.host.superview.class) : @"nil"]);
    } @catch (id exception) {
        OMCLogWrite(@"SplitScreen",
            [NSString stringWithFormat:@"CarSplit: loi huy bang chon %@\n%@",
                exception, ((NSException *)exception).callStackSymbols]);
    }
}

// MARK: - Tray

// The pass-through hitTest override installed on the tray window's
// runtime subclass (IMP @0x481c8, 212 bytes — VERIFIED rem4;
// disasm/rem4_tray_hitTest_481c8.txt): ask the superclass (the window's
// original class) to hit-test; a hit on the window ITSELF means the
// point touched no subview, so return nil and let the touch fall
// through to whatever is underneath. Subview hits return unchanged.
static UIView *SCPCPassHitTest(UIView *self, SEL _cmd, CGPoint point,
                               UIEvent *event) {
    struct objc_super sup = { self, class_getSuperclass(object_getClass(self)) };
    UIView *hit = ((UIView *(*)(struct objc_super *, SEL, CGPoint, UIEvent *))
                   objc_msgSendSuper)(&sup, _cmd, point, event);
    return (hit == self) ? nil : hit;
}

// The shared overlay window for trays/menus/ghosts. NOT a plain
// UIWindow (the previous condensed body created one with initWithFrame:
// and omitted everything below — corrected rem4). IMP
// @0x3782c..0x37e8c — VERIFIED (disasm/rem4_trayWindowForParent.txt):
// the binary builds a UIRootSceneWindow from the parent screen's
// FBSDisplayConfiguration, then re-classes it into a runtime subclass
// "SCPCPass_<the window's own class>" carrying only the hitTest
// override above, so the window's empty areas are touch-transparent.
// Level is UIWindowLevelStatusBar + 65 (@0x37c08/@0x37c14 — the parent
// window's level is never read; CLOSURE-2).
- (UIWindow *)trayWindowForParent:(UIView *)parent {                     // 0x3782c VERIFIED (rem4)
    UIScreen *screen = parent.window.screen;
    if (screen == nil) return nil;                       // @0x3787c
    UIWindow *window = self.trayWindow;
    if (window != nil) {
        if (window.screen == screen) {                    // @0x37938
            window.hidden = NO;
            return window;
        }
        window.hidden = YES;                              // screen changed:
        self.trayWindow = nil;                            // drop and rebuild
    }

    // FBSDisplayConfiguration for the screen (@0x378d0..0x37a80): the
    // private -displayConfiguration; if that yields nothing, build one
    // from the CADisplay (-_display) with isMainDisplay:NO. The binary
    // probes each get with respondsToSelector: and falls through
    // silently; SCPMissingSelector is logged on the two init calls
    // below when their selector is absent (@0x37a5c / @0x37ad8).
    id config = nil;
    SEL configSel = NSSelectorFromString(@"displayConfiguration");
    if ([screen respondsToSelector:configSel])
        config = ((id (*)(id, SEL))objc_msgSend)(screen, configSel);
    if (config == nil) {
        id display = nil;
        SEL displaySel = NSSelectorFromString(@"_display");
        if ([screen respondsToSelector:displaySel])
            display = ((id (*)(id, SEL))objc_msgSend)(screen, displaySel);
        if (display != nil) {
            id cfg = [objc_getClass("FBSDisplayConfiguration") alloc];
            SEL initSel = NSSelectorFromString(@"initWithCADisplay:isMainDisplay:");
            if ([cfg respondsToSelector:initSel]) {
                config = ((id (*)(id, SEL, id, BOOL))objc_msgSend)(cfg, initSel, display, NO);
            } else {
                SCPMissingSelector(cfg, @"initWithCADisplay:isMainDisplay:");
            }
        }
    }

    UIWindow *win = nil;
    if (config != nil) {                                  // @0x37a84
        id w = [objc_getClass("UIRootSceneWindow") alloc];
        SEL initSel = NSSelectorFromString(@"initWithDisplayConfiguration:");
        if ([w respondsToSelector:initSel]) {
            win = ((id (*)(id, SEL, id))objc_msgSend)(w, initSel, config);
        } else {
            SCPMissingSelector(w, @"initWithDisplayConfiguration:");
        }
    }
    if (![win isKindOfClass:UIWindow.class]) {            // @0x37af4 / fail @0x37cf8
        OMCLogWrite(@"SplitScreen",
            [NSString stringWithFormat:
                @"CarSplit: khong tao duoc cua so bang bo cuc (config %@, window %@) -> bang nam trong view goc, an o app iPhone",
                config, win]);
        return nil;
    }

    // Re-class the window into "SCPCPass_<its own class>"
    // (@0x37b10..0x37bec). Registration is guarded per call by the
    // objc_getClass existence check (@0x37b88) — there is NO
    // dispatch_once. Exactly one method is added: hitTest:withEvent:,
    // IMP @0x481c8, type encoding copied from the superclass's own
    // method. object_setClass runs on both guard paths.
    Class winClass = object_getClass(win);
    NSString *name = [NSString stringWithFormat:@"SCPCPass_%@",
                      NSStringFromClass(winClass)];
    Class passClass = objc_getClass(name.UTF8String);
    if (passClass == nil) {
        passClass = objc_allocateClassPair(winClass, name.UTF8String, 0);
        Method m = class_getInstanceMethod(winClass,
                                           @selector(hitTest:withEvent:));
        class_addMethod(passClass, @selector(hitTest:withEvent:),
                        (IMP)SCPCPassHitTest, method_getTypeEncoding(m));
        objc_registerClassPair(passClass);
    }
    object_setClass(win, passClass);

    win.windowLevel = UIWindowLevelStatusBar + 65.0;      // @0x37c1c
    win.backgroundColor = UIColor.clearColor;
    win.hidden = NO;
    self.trayWindow = win;
    OMCLogWrite(@"SplitScreen",
        [NSString stringWithFormat:@"CarSplit: cua so bang bo cuc %@ muc %.0f",
            NSStringFromCGRect(win.bounds), win.windowLevel]);
    return win;
}

- (void)hideTrayWindowIfIdle {                                           // 0x28180
    UIWindow *window = self.trayWindow;
    if (window == nil) return;
    // The background toast (Reopen / "Mở lại", tag 0x5c9b, created by
    // showBackgroundToastFor:slot:) lives in this same window: while it
    // is up the window is NOT idle (@0x28214–0x2822c). The toast's two
    // removal paths (the Reopen action and the auto-dismiss completion)
    // remove the view BEFORE calling here, so the view test IS the
    // state — no separate boolean flag. (Guard restored 2026-11-09,
    // GPT Deep Function Wiring Audit N5.)
    if (self.tray == nil && self.ratioMenu == nil &&
        self.pickerSheet == nil && self.dragGhost == nil &&
        [window viewWithTag:0x5c9b] == nil)
        window.hidden = YES;
}

- (void)restartTrayTimer {                                               // 0x3bc20 VERIFIED
    [self.trayTimer invalidate];
    __weak SCPCarSplit *weakSelf = self;
    self.trayTimer = [NSTimer scheduledTimerWithTimeInterval:4.0
        repeats:NO block:^(NSTimer *timer) {
            [weakSelf collapseAppTray];   // VERIFIED (CLOSURE-2): block invoke
                                          // @0x3bd38 = loadWeak + collapseAppTray
        }];
}

// CLOSED (was PARTIAL): collapses the app tray. The tray cover fades out
// over 0.2 s; the tray itself fades/shrinks over 0.22 s and the tray
// window is hidden once nothing else uses it. Covers are removed from
// hosted panes unless a resize or the ratio menu is in flight. @0x3bd78.
- (void)collapseAppTray {
    [self.trayTimer invalidate];
    self.trayTimer = nil;
    UIView *tray = self.tray;
    self.tray = nil;
    [self updatePopupShield];
    [self publishBusy];
    [self setFullscreenBridgeHidden:NO bundle:nil];
    [self pushHostFramesLive:NO];
    if (!self.resizing && self.ratioMenu == nil) {
        for (SCPCarPane *pane in [self hostedPanes])
            [self removeCoverFromPane:pane];
    }
    UIView *cover = self.trayCover;
    self.trayCover = nil;
    if (cover != nil) {
        [UIView animateWithDuration:0.2
            animations:^{ cover.alpha = 0; }
            completion:^(BOOL finished) { [cover removeFromSuperview]; }];
    }
    if (tray != nil) {
        UIWindow *window = self.trayWindow;
        __weak SCPCarSplit *weakSelf = self;
        [UIView animateWithDuration:0.22 delay:0
                            options:UIViewAnimationOptionLayoutSubviews
            animations:^{
                tray.alpha = 0;
                tray.transform = CGAffineTransformScale(
                    CGAffineTransformMakeTranslation(0, -14), 0.92, 0.92);
            } completion:^(BOOL finished) {
                [tray removeFromSuperview];
                SCPCarSplit *s = weakSelf;
                if (window != nil && s != nil && s.tray == nil &&
                    s.ratioMenu == nil && s.pickerSheet == nil)
                    window.hidden = YES;
            }];
    }
}

- (void)removeAppTab {                                                   // 0x36f04
    [self collapseAppTray];
}

- (void)refreshAppTabSoon {                                              // 0x36f08 (approx.)
    __weak SCPCarSplit *weakSelf = self;
    SCPDispatchAfter(0.35, ^{ [weakSelf refreshAppTab]; });
}

- (void)refreshAppTab {                                                  // 0x36e04 VERIFIED (SCPCarSplit__refreshAppTab.txt): strictly sequential — refreshHomeButton first, single guard on tray only, popupShield raised unconditionally after tray (no nil/viewIsRaised: check on it in the original)
    [self refreshHomeButton];
    if (!self.tray || [self viewIsRaised:self.tray]) return;
    [self raiseView:self.tray];
    [self raiseView:self.popupShield];
}

- (void)showPickerForFocusedPane {                                       // 0x37000 (approx.)
    if (!self.active) return;
    NSInteger slot = self.focusedSlot;
    if (slot < 0 || slot >= self.paneCount) slot = [self autoSlot];
    [self showPickerForSlot:(int)slot];
    SCPCarPane *pane = [self paneAtSlot:slot];
    if (pane != nil && pane.picker != nil) {
        self.pickerSheetPane = pane;
        [self refreshPickerSheetSoon];
    }
}

// MARK: - Loader (launch-in-progress overlay)

- (void)loaderCancelTapped:(UIView *)sender {                            // 0x2b980 VERIFIED + GPT guard chain
    // Dump @0x2b9e8 (cbz pane) / @0x2b9ec (cbz bundle) -> shared return
    // @0x2ba98: when either is nil the original returns silently — no
    // log, no cancelledLaunches entry, no launchFailed:.
    // [fix-round3 G] GPT expanded audit §3 validation chain, applied in
    // full: pane must exist -> the pane's CURRENT loader must exist ->
    // sender must belong to that current loader -> the bundle read from
    // the loader's accessibilityIdentifier must be a non-empty NSString
    // -> only then cancel. There is deliberately NO fallback to
    // pane.bundleID: during an app swap the pane can still carry the OLD
    // bundle while the loader is opening the NEW one, and cancelling by
    // the stale id was the 06:34:33 nil-key crash path. (The log format
    // is verified verbatim: the .ips symbolication of 2026-11-09 decoded
    // the cfstring at the crash site to exactly this string.)
    SCPCarPane *pane = [self paneForView:sender];
    if (pane == nil) return;
    UIView *loader = pane.loader;
    if (loader == nil) return;
    if (![sender isDescendantOfView:loader]) return;
    NSString *bundle = loader.accessibilityIdentifier;
    if (![bundle isKindOfClass:[NSString class]] || bundle.length == 0) return;
    OMCLogWrite(@"SplitScreen",
        [NSString stringWithFormat:@"CarSplit: huy mo %@ o %d", bundle, (int)pane.slot]);
    self.cancelledLaunches[bundle] = [NSDate date];
    [self launchFailed:bundle slot:pane.slot];
}

// CLOSED (was STUB-UNRECOVERED): full-screen loader card — app icon,
// display name, an arc spinner (0.9 s rotation + 0.8 s pulse) and a
// cancel chip; a 20 s watchdog fails the launch if it never lands.
// @0x2a7e8 (3,016 bytes).
- (void)showLoaderInPane:(SCPCarPane *)pane bundle:(NSString *)bundle {
    if (pane.view == nil) return;
    [self removeLoaderFromPane:pane animated:NO];
    UIView *loader = [[UIView alloc] initWithFrame:pane.view.bounds];
    loader.autoresizingMask = 0x12;
    loader.backgroundColor = [UIColor colorWithRed:0.9333333333333333
                                             green:0.9411764705882353
                                              blue:0.984313725490196
                                             alpha:1.0];
    loader.userInteractionEnabled = NO;   // set twice in the binary (NO, then YES)
    loader.accessibilityIdentifier = bundle;
    loader.userInteractionEnabled = YES;

    UIView *card = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 120, 112)];
    card.center = CGPointMake(CGRectGetMidX(loader.bounds),
                              CGRectGetMidY(loader.bounds));
    card.autoresizingMask = 0x2d;
    [loader addSubview:card];

    UIImageView *icon = [[UIImageView alloc] initWithFrame:CGRectMake(32, 0, 56, 56)];
    icon.image = SCPAppIconForBundle(bundle);
    SCPStyleGhostIcon(icon);
    icon.tag = 0x4e;
    [card addSubview:icon];

    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 62, 120, 16)];
    label.text = [self displayNameFor:bundle];
    label.textColor = SCPColorSecondary();
    label.font = [UIFont systemFontOfSize:12 weight:UIFontWeightMedium];
    label.textAlignment = NSTextAlignmentCenter;
    [card addSubview:label];

    UIView *ringView = [[UIView alloc] initWithFrame:CGRectMake(50, 88, 20, 20)];
    CAShapeLayer *ring = [CAShapeLayer layer];
    ring.frame = ringView.bounds;
    ring.path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(10, 10)
        radius:8 startAngle:-M_PI_2 endAngle:M_PI clockwise:YES].CGPath;
    ring.fillColor = nil;
    ring.strokeColor = [UIColor colorWithRed:0.6078431372549019
                                       green:0.5294117647058824
                                        blue:0.9725490196078431
                                       alpha:1.0].CGColor;
    ring.lineWidth = 2;
    ring.lineCap = kCALineCapRound;
    [ringView.layer addSublayer:ring];
    CABasicAnimation *spin = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    spin.toValue = @6.283185307179586;
    spin.duration = 0.9;
    spin.repeatCount = HUGE_VALF;
    [ringView.layer addAnimation:spin forKey:@"spin"];
    [card addSubview:ringView];

    double s = MIN(pane.view.bounds.size.width / 130.0,
                   pane.view.bounds.size.height / 124.0);
    if (s > 1) s = 1;
    if (s > 0.2) card.transform = CGAffineTransformMakeScale(s, s);

    [pane.view insertSubview:loader aboveSubview:pane.host];
    [pane.view bringSubviewToFront:pane.handle];
    [pane.view bringSubviewToFront:pane.bar];
    pane.loader = loader;
    DCHL45OverlayTrace(self,@"loader-added",pane,loader);

    UIButton *cancel = SCPMakeIconButton(SCPSymbolImage(@"close", 16.0),
                                         self, @selector(loaderCancelTapped:), 32.0);
    cancel.tintColor = [UIColor colorWithRed:1.0 green:0.35294117647058826
                                        blue:0.37254901960784315 alpha:1.0];
    cancel.backgroundColor = [cancel.tintColor colorWithAlphaComponent:0.14];
    cancel.center = CGPointMake(loader.bounds.size.width - 22, 22);
    cancel.autoresizingMask = 0x21;
    cancel.accessibilityLabel = OMCTr(@"Huỷ mở app", @"Cancel opening");
    [loader addSubview:cancel];

    __weak SCPCarSplit *weakSelf = self;
    __weak SCPCarPane *weakPane = pane;
    __weak UIView *weakLoader = loader;
    SCPDispatchAfter(20.0, ^{
        SCPCarSplit *self = weakSelf;
        SCPCarPane *p = weakPane;
        UIView *l = weakLoader;
        if (self == nil || p == nil || l == nil) return;
        if (p.loader != l) return;
        if ([self pendingSlotForBundle:bundle] >= 0) return;
        OMCLogWrite(@"SplitScreen",
            [NSString stringWithFormat:@"CarSplit: the dang mo %@ con sot -> bo",
                bundle]);
        [self launchFailed:bundle slot:-1];
    });

    loader.alpha = 0;
    card.transform = CGAffineTransformMakeScale(0.6, 0.6);
    [UIView animateWithDuration:0.2
        animations:^{ loader.alpha = 1; }];
    [UIView animateWithDuration:0.5 delay:0
         usingSpringWithDamping:0.6 initialSpringVelocity:0.6 options:0
        animations:^{ card.transform = CGAffineTransformIdentity; }
        completion:^(BOOL finished) {
            CABasicAnimation *pulse =
                [CABasicAnimation animationWithKeyPath:@"transform.scale"];
            pulse.fromValue = @1.0;
            pulse.toValue = @0.93;
            pulse.duration = 0.8;
            pulse.autoreverses = YES;
            pulse.repeatCount = HUGE_VALF;
            pulse.timingFunction = [CAMediaTimingFunction
                functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
            [card.layer addAnimation:pulse forKey:@"pulse"];
        }];
}

- (void)removeLoaderFromPane:(SCPCarPane *)pane animated:(BOOL)animated {  // 0x2bbb4 VERIFIED
    UIView *loader = pane.loader;
    if (loader) DCHL45OverlayTrace(self,@"loader-remove-request",pane,loader);
    pane.loader = nil;
    if (loader == nil) return;
    __weak SCPCarSplit *hl45Owner=self;
    __weak SCPCarPane *hl45Pane=pane;
    if (animated) {
        // VERIFIED (CLOSURE-2; disasm/rem2_removeLoaderFromPane.txt): the
        // card is the loader's tag-78 subview; its "pulse" animation (set
        // by showLoader's completion block) is removed first, then the
        // loader fades out while the card scales to 1.25 — options are
        // CurveEaseOut (0x20000), not 0. Animations invoke @0x2bd9c,
        // completion invoke @0x2bdf8 = [loader removeFromSuperview].
        UIView *card = [loader viewWithTag:78];
        [card.layer removeAnimationForKey:@"pulse"];
        [UIView animateWithDuration:0.3 delay:0.2
            options:UIViewAnimationOptionCurveEaseOut
            animations:^{
                loader.alpha = 0;
                card.transform = CGAffineTransformMakeScale(1.25, 1.25);
            }
            completion:^(BOOL finished) {
                [loader removeFromSuperview];
                DCHL45OverlayTrace(hl45Owner,@"loader-remove-complete",hl45Pane,loader);
            }];
    } else {
        [loader removeFromSuperview];
        DCHL45OverlayTrace(self,@"loader-remove-complete",pane,loader);
    }
}

// MARK: - Toasts & tips

- (void)toast:(NSString *)text {                                         // 0x39000 (approx.)
    [self toast:text duration:2.6];
}

// CLOSED (was STUB-UNRECOVERED): a pill label (navy on white 0.94, font
// 14 Medium) centred 50 pt above the bottom of the dashboard root view;
// when the bridged pane is live it dodges to the first other visible
// pane so it does not cover the toast point. Fades in 0.2 s, out 0.3 s
// after `duration`. @0x44f80 (1,816 bytes).
- (void)toast:(NSString *)text duration:(double)duration {
    UIView *host = SCPDashboardRootViewController().view;
    if (host == nil || text.length == 0) return;
    UILabel *label = [[UILabel alloc] init];
    label.text = text;
    label.textColor = [UIColor colorWithRed:0.2901960784313726
                                      green:0.30980392156862746
                                       blue:0.5019607843137255 alpha:1.0];
    label.font = [UIFont systemFontOfSize:14 weight:UIFontWeightMedium];
    label.textAlignment = NSTextAlignmentCenter;
    label.numberOfLines = 2;
    double maxW = MAX(host.bounds.size.width - 48, 160);
    CGSize fitted = [label sizeThatFits:CGSizeMake(maxW - 32, 60)];
    double width = MIN(maxW, fitted.width + 32);
    double height = MAX(fitted.height + 18, 38);
    label.bounds = CGRectMake(0, 0, width, height);
    SCPStyleDragGhost(label, 19.0);
    label.backgroundColor = [UIColor colorWithWhite:1 alpha:0.94];
    double cx = CGRectGetMidX(host.bounds);
    double cy = host.bounds.size.height - 50;
    if (self.bridgedPane != nil && self.active && self.container != nil) {
        CGRect rect = [host convertRect:self.bridgedPane.view.frame
                               fromView:self.container];
        if (CGRectContainsPoint(CGRectInset(rect, -width / 2, -height / 2),
                                CGPointMake(cx, cy))) {
            for (SCPCarPane *pane in self.allPanes) {
                if (pane == self.bridgedPane || pane.view.alpha < 0.5) continue;
                CGRect frame = [host convertRect:pane.view.frame
                                       fromView:self.container];
                cx = CGRectGetMidX(frame);
                cy = CGRectGetMaxY(frame) - height / 2 - 12;
                break;
            }
        }
    }
    label.center = CGPointMake(cx, cy);
    [host addSubview:label];
    label.alpha = 0;
    [UIView animateWithDuration:0.2
        animations:^{ label.alpha = 1; }
        completion:^(BOOL finished) {
            [UIView animateWithDuration:0.3 delay:duration options:0
                animations:^{ label.alpha = 0; }
                completion:^(BOOL finished2) { [label removeFromSuperview]; }];
        }];
}

// CLOSED (was STUB-UNRECOVERED): "app is running in the background" toast
// with the app's icon, name, and a Reopen button; auto-dismisses after
// 5 s. Hosted in the tray window when there is one. @0x28c68
// (1,880 bytes).
- (void)showBackgroundToastFor:(NSString *)name slot:(int)slot {
    UIView *host = SCPDashboardRootViewController().view;
    if (host == nil) return;
    UIWindow *window = [self trayWindowForParent:host];
    UIView *container = (window != nil) ? (UIView *)window : host;
    [[container viewWithTag:0x5c9b] removeFromSuperview];
    UIView *toast = [[UIView alloc] initWithFrame:CGRectZero];
    toast.tag = 0x5c9b;

    UIImageView *icon = [[UIImageView alloc] initWithFrame:CGRectMake(7, 6, 24, 24)];
    icon.image = SCPAppIconForBundle(name);
    SCPStyleGhostIcon(icon);
    [toast addSubview:icon];

    UILabel *label = [[UILabel alloc] init];
    label.text = [NSString stringWithFormat:
        OMCTr(@"%@ đang chạy nền", @"%@ is running in the background"),
        [self displayNameFor:name]];
    label.textColor = [UIColor colorWithRed:0.2901960784313726
                                      green:0.30980392156862746
                                       blue:0.5019607843137255 alpha:1.0];
    label.font = [UIFont systemFontOfSize:13 weight:UIFontWeightMedium];
    [label sizeToFit];
    double labelW = MIN(label.bounds.size.width,
                        MAX(container.bounds.size.width - 196, 84));
    label.frame = CGRectMake(39, 0, labelW, 34);
    [toast addSubview:label];

    UIButton *button = [UIButton buttonWithType:0];
    [button setTitle:OMCTr(@"Mở lại", @"Reopen") forState:0];
    [button setTitleColor:UIColor.whiteColor forState:0];
    button.titleLabel.font = [UIFont systemFontOfSize:13 weight:UIFontWeightSemibold];
    double fittedW = [button.titleLabel sizeThatFits:CGSizeZero].width;
    button.frame = CGRectMake(CGRectGetMaxX(label.frame) + 10, 5,
                              fittedW + 24, 26);
    button.layer.cornerRadius = 13;
    SCPApplyAccent(button, YES);
    __weak UIView *weakToast = toast;
    __weak SCPCarSplit *weakSelf = self;
    UIAction *action = [UIAction actionWithHandler:^(UIAction *a) {
        [weakToast removeFromSuperview];
        SCPCarSplit *s = weakSelf;
        if (s == nil) return;
        [s hideTrayWindowIfIdle];
        int target = s.active ? MIN(slot, s.paneCount) : 0;
        OMCLogWrite(@"SplitScreen",
            [NSString stringWithFormat:@"CarSplit: [mo lai] %@ vao o %d",
                name, target]);
        [s openApp:name slot:target];
    }];
    [button addAction:action forControlEvents:UIControlEventTouchUpInside];
    [toast addSubview:button];

    toast.bounds = CGRectMake(0, 0, CGRectGetMaxX(button.frame) + 5, 34);
    SCPStyleRatioMenu(toast, 18.0);
    toast.center = CGPointMake(CGRectGetMidX(container.bounds), 26);
    [container addSubview:toast];
    SCPPrepareRatioMenu(toast);

    SCPDispatchAfter(5.0, ^{
        UIView *t = weakToast;
        if (t == nil) return;
        [UIView animateWithDuration:0.25
            animations:^{ t.alpha = 0; }
            completion:^(BOOL finished) {
                [t removeFromSuperview];
                [weakSelf hideTrayWindowIfIdle];
            }];
    });
}

// CLOSED (was PARTIAL): rotating usage tips. At most three tips are ever
// shown (tipCount is a SCPPrefs counter); the tip fires 3 s later and
// only while the split is active. @0x3b374 + block @0x3b570.
- (void)showTipSoon {
    NSInteger count = [SCPPrefs tipCount];
    if (count > 2) return;
    NSArray *tips = @[
        OMCTr(@"Mẹo: chạm 2 lần vào vạch chia để đổi chỗ 2 ô",
              @"Tip: double-tap a divider to swap the two panes"),
        OMCTr(@"Mẹo: giữ và kéo ••• thả lên ô khác để đổi chỗ",
              @"Tip: drag ••• onto another pane to swap them"),
        OMCTr(@"Mẹo: kéo vạch chia sát mép để đóng ô đó",
              @"Tip: drag a divider to the edge to close that pane")];
    [SCPPrefs setTipCount:count + 1];
    __weak SCPCarSplit *weakSelf = self;
    SCPDispatchAfter(3.0, ^{
        SCPCarSplit *s = weakSelf;
        if (s == nil || !s.active) return;
        [s toast:tips[count] duration:4.5];
    });
}

@end
