// SCPCarSplit+RatioMenu.m — OmniCarSplitScreen reconstruction, module SplitScreenB.
// The ratio preset menu shown when a divider knob is tapped.
//
// CLOSURE (wave 3, finisher): all five helper stubs in this file are now
// reconstructed from the disassembly — see the "Closure addendum" in
// SplitScreenB_REPORT.md. Corrections to the earlier draft's framing:
//   - @0x46a64 is a generic TEMPLATE-IMAGE renderer returning UIImage*
//     (used both by SCPSymbolImage and by the ratio-chip previews); the
//     name SCPMakeRatioChipPreview and the UIView* return type in the
//     earlier draft were wrong.
//   - The helpers are NOT file-static in effect: Picker/Panel/Chrome
//     call several of them, so they are exported here (the binary has
//     exactly one copy of each).

#import "SCPCarSplit.h"
#import "SCPVoiceNative.h"
#import "SCPCommon.h" // [phase2; backported to src in phase 3] OMC* declarations used in this TU
#import "SCPCButton.h" // [phase2; backported to src in phase 3] SCPCButton interface used in this TU
#import "SCPCarDividerView.h"
#import "SCPCarPane.h"

// Shared visual helpers implemented in other SplitScreenB files:
extern UIVisualEffectView *SCPKnobFaceView(void);                     // 0x35c74 (Chrome) — [phase2; backported to src in phase 3] ONE name (phase2 unification)
extern void SCPApplyMeshBackdrop(UIVisualEffectView *effectView);       // 0x35d5c (Chrome)
extern void SCPStyleDragGhost(UIView *view, double radius);             // 0x271e4 (Drag)

// MARK: - Template image renderer @0x46a64 (+ renderer block @0x477dc)
//
// Renders a 24x24-grid vector drawing into a template image of `size`
// points. When `rotated` is set the canvas is turned -90 degrees (the
// "filled" orientation used by vertical previews). The draw block
// receives a stroke path (lineWidth 1.8, round caps/joins) and a fill
// path; both are painted black before the template mask is taken.
UIImage *SCPRenderTemplateImage(BOOL rotated,
                                void (^draw)(UIBezierPath *stroke, UIBezierPath *fill),
                                double size) {
    UIGraphicsImageRenderer *renderer =
        [[UIGraphicsImageRenderer alloc] initWithSize:CGSizeMake(size, size)];
    UIImage *image = [renderer imageWithActions:^(UIGraphicsImageRendererContext *ctx) {
        CGContextRef c = ctx.CGContext;
        CGContextScaleCTM(c, size / 24.0, size / 24.0);
        if (rotated) {
            CGContextTranslateCTM(c, 24, 0);
            CGContextRotateCTM(c, -M_PI_2);
        }
        [[UIColor blackColor] set];
        UIBezierPath *stroke = [UIBezierPath bezierPath];
        UIBezierPath *fill = [UIBezierPath bezierPath];
        stroke.lineWidth = 1.8;
        stroke.lineCapStyle = kCGLineCapRound;
        stroke.lineJoinStyle = kCGLineJoinRound;
        draw(stroke, fill);
        [stroke stroke];
        [fill fill];
    }];
    return [image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
}

// MARK: - Symbol icons (draw block @0x46b90)
//
// Every icon is drawn vectorially on the 24x24 grid — no PNG assets for
// check/close/etc. exist in the payload. Branch structure and all
// coordinates transcribed from the block; branches share a merged tail
// line to a branch-specific final point (noted per icon).

static void SCPDrawSymbolIcon(NSString *name, UIBezierPath *stroke, UIBezierPath *fill) {
    if ([name isEqualToString:@"fullscreen"]) {
        [stroke moveToPoint:CGPointMake(13.5, 4)];
        [stroke addLineToPoint:CGPointMake(20, 4)];
        [stroke addLineToPoint:CGPointMake(20, 10.5)];
        [stroke moveToPoint:CGPointMake(20, 4)];
        [stroke addLineToPoint:CGPointMake(14, 10)];
        [stroke moveToPoint:CGPointMake(10.5, 20)];
        [stroke addLineToPoint:CGPointMake(4, 20)];
        [stroke addLineToPoint:CGPointMake(4, 13.5)];
        [stroke moveToPoint:CGPointMake(4, 20)];
        [stroke addLineToPoint:CGPointMake(10, 14)];   // shared tail
    } else if ([name isEqualToString:@"replace"]) {
        [stroke appendPath:[UIBezierPath bezierPathWithRoundedRect:CGRectMake(3.5, 3.5, 7.5, 7.5) cornerRadius:2.4]];
        [stroke appendPath:[UIBezierPath bezierPathWithRoundedRect:CGRectMake(13, 3.5, 7.5, 7.5) cornerRadius:2.4]];
        [stroke appendPath:[UIBezierPath bezierPathWithRoundedRect:CGRectMake(3.5, 13, 7.5, 7.5) cornerRadius:2.4]];
        [stroke moveToPoint:CGPointMake(16.75, 13.5)];
        [stroke addLineToPoint:CGPointMake(20, 16.75)];
        [stroke moveToPoint:CGPointMake(13.5, 16.75)];
        [stroke addLineToPoint:CGPointMake(20, 16.75)];   // shared tail
    } else if ([name isEqualToString:@"close"]) {
        [stroke moveToPoint:CGPointMake(7, 7)];
        [stroke addLineToPoint:CGPointMake(17, 17)];
        [stroke moveToPoint:CGPointMake(17, 7)];
        [stroke addLineToPoint:CGPointMake(7, 17)];   // shared tail
    } else if ([name isEqualToString:@"layouts"]) {
        [stroke appendPath:[UIBezierPath bezierPathWithRoundedRect:CGRectMake(3.5, 5, 9, 14) cornerRadius:2.6]];
        [stroke appendPath:[UIBezierPath bezierPathWithRoundedRect:CGRectMake(14, 5, 6.5, 14) cornerRadius:2.6]];
    } else if ([name isEqualToString:@"recent"]) {
        [stroke appendPath:[UIBezierPath bezierPathWithOvalInRect:CGRectMake(3.75, 3.75, 16.5, 16.5)]];
        [stroke moveToPoint:CGPointMake(12, 7.5)];
        [stroke addLineToPoint:CGPointMake(12, 12)];
        [stroke addLineToPoint:CGPointMake(15, 14)];   // shared tail
    } else if ([name isEqualToString:@"favorite"]) {
        // Computed 10-point star, outer radius 8.6 / inner 3.9, centre (12, 12.6).
        for (NSInteger i = 0; i < 10; i++) {
            double theta = i * M_PI / 5.0 - M_PI_2;
            double r = (i % 2 == 0) ? 8.6 : 3.9;
            CGPoint p = CGPointMake(12 + r * cos(theta), 12.6 + r * sin(theta));
            if (i == 0) [stroke moveToPoint:p];
            else [stroke addLineToPoint:p];
        }
        [stroke closePath];
    } else if ([name isEqualToString:@"exit"]) {
        [stroke moveToPoint:CGPointMake(10, 4)];
        [stroke addLineToPoint:CGPointMake(6.5, 4)];
        [stroke addArcWithCenter:CGPointMake(6.5, 6.5) radius:2.5
                      startAngle:-M_PI_2 endAngle:-M_PI clockwise:NO];
        [stroke addLineToPoint:CGPointMake(4, 17.5)];
        [stroke addArcWithCenter:CGPointMake(6.5, 17.5) radius:2.5
                      startAngle:M_PI endAngle:M_PI_2 clockwise:NO];
        [stroke addLineToPoint:CGPointMake(10, 20)];
        [stroke moveToPoint:CGPointMake(10, 12)];
        [stroke addLineToPoint:CGPointMake(20, 12)];
        [stroke moveToPoint:CGPointMake(16.5, 8.5)];
        [stroke addLineToPoint:CGPointMake(16.5, 15.5)];   // shared tail
    } else if ([name isEqualToString:@"float"]) {
        [stroke appendPath:[UIBezierPath bezierPathWithRoundedRect:CGRectMake(3.5, 4.5, 17, 15) cornerRadius:3]];
        [fill appendPath:[UIBezierPath bezierPathWithRoundedRect:CGRectMake(11.5, 11, 6.5, 6) cornerRadius:1.6]];
    } else if ([name isEqualToString:@"dock"]) {
        [stroke appendPath:[UIBezierPath bezierPathWithRoundedRect:CGRectMake(3.5, 4.5, 17, 15) cornerRadius:3]];
        [stroke moveToPoint:CGPointMake(12, 4.5)];
        [stroke addLineToPoint:CGPointMake(12, 19.5)];
        [fill appendPath:[UIBezierPath bezierPathWithRoundedRect:CGRectMake(5.6, 6.6, 4.6, 10.8) cornerRadius:1.4]];
    } else if ([name isEqualToString:@"check"]) {
        [stroke moveToPoint:CGPointMake(6, 12.5)];
        [stroke addLineToPoint:CGPointMake(10, 16.5)];
        [stroke addLineToPoint:CGPointMake(18, 8)];   // shared tail
    } else if ([name isEqualToString:@"swap"]) {
        [stroke moveToPoint:CGPointMake(4.5, 8.5)];
        [stroke addLineToPoint:CGPointMake(19, 8.5)];
        [stroke moveToPoint:CGPointMake(15.5, 5)];
        [stroke addLineToPoint:CGPointMake(19, 8.5)];
        [stroke addLineToPoint:CGPointMake(15.5, 12)];
        [stroke moveToPoint:CGPointMake(19.5, 15.5)];
        [stroke addLineToPoint:CGPointMake(5, 15.5)];
        [stroke moveToPoint:CGPointMake(8.5, 12)];
        [stroke addLineToPoint:CGPointMake(5, 15.5)];
        [stroke addLineToPoint:CGPointMake(8.5, 19)];   // shared tail
    } else if ([name hasPrefix:@"hm_"]) {
        stroke.lineWidth = 1.5;
        NSString *base = [name substringFromIndex:3];
        if ([base isEqualToString:@"apps"]) {
            [stroke appendPath:[UIBezierPath bezierPathWithRoundedRect:CGRectMake(4, 4, 7, 7) cornerRadius:2.2]];
            [stroke appendPath:[UIBezierPath bezierPathWithRoundedRect:CGRectMake(13, 4, 7, 7) cornerRadius:2.2]];
            [stroke appendPath:[UIBezierPath bezierPathWithRoundedRect:CGRectMake(4, 13, 7, 7) cornerRadius:2.2]];
            [stroke appendPath:[UIBezierPath bezierPathWithRoundedRect:CGRectMake(13, 13, 7, 7) cornerRadius:2.2]];
        } else if ([base isEqualToString:@"full"]) {
            // Rounded-rect outline (4,4,16,16) r=3.5 drawn as 4 corner arcs.
            [stroke moveToPoint:CGPointMake(4, 9.5)];
            [stroke addLineToPoint:CGPointMake(4, 7.5)];
            [stroke addArcWithCenter:CGPointMake(7.5, 7.5) radius:3.5
                          startAngle:M_PI endAngle:-M_PI_2 clockwise:YES];
            [stroke addLineToPoint:CGPointMake(9.5, 4)];
            [stroke moveToPoint:CGPointMake(14.5, 4)];
            [stroke addLineToPoint:CGPointMake(16.5, 4)];
            [stroke addArcWithCenter:CGPointMake(16.5, 7.5) radius:3.5
                          startAngle:-M_PI_2 endAngle:0 clockwise:YES];
            [stroke addLineToPoint:CGPointMake(20, 9.5)];
            [stroke moveToPoint:CGPointMake(20, 14.5)];
            [stroke addLineToPoint:CGPointMake(20, 16.5)];
            [stroke addArcWithCenter:CGPointMake(16.5, 16.5) radius:3.5
                          startAngle:0 endAngle:M_PI_2 clockwise:YES];
            [stroke addLineToPoint:CGPointMake(14.5, 20)];
            [stroke moveToPoint:CGPointMake(9.5, 20)];
            [stroke addLineToPoint:CGPointMake(7.5, 20)];
            [stroke addArcWithCenter:CGPointMake(7.5, 16.5) radius:3.5
                          startAngle:M_PI_2 endAngle:M_PI clockwise:YES];
            [stroke addLineToPoint:CGPointMake(4, 14.5)];   // shared tail
        } else if ([base isEqualToString:@"split"]) {
            [stroke appendPath:[UIBezierPath bezierPathWithRoundedRect:CGRectMake(3.5, 4.5, 7.5, 15) cornerRadius:2.5]];
            [stroke appendPath:[UIBezierPath bezierPathWithRoundedRect:CGRectMake(13, 4.5, 7.5, 15) cornerRadius:2.5]];
        } else if ([base isEqualToString:@"float"]) {
            [stroke appendPath:[UIBezierPath bezierPathWithRoundedRect:CGRectMake(3.5, 4.5, 17, 15) cornerRadius:3]];
            [fill appendPath:[UIBezierPath bezierPathWithRoundedRect:CGRectMake(11.5, 11.5, 6.5, 5.5) cornerRadius:1.6]];
        } else if ([base isEqualToString:@"min"]) {
            [stroke moveToPoint:CGPointMake(5.5, 12)];
            [stroke addLineToPoint:CGPointMake(18.5, 12)];   // shared tail
        } else if ([base isEqualToString:@"close"]) {
            [stroke moveToPoint:CGPointMake(6.5, 6.5)];
            [stroke addLineToPoint:CGPointMake(17.5, 17.5)];
            [stroke moveToPoint:CGPointMake(17.5, 6.5)];
            [stroke addLineToPoint:CGPointMake(6.5, 17.5)];   // shared tail
        }
    }
    // Unknown name: no drawing — an empty template image.
}

// Cached symbol-image factory @0x2b474. Cache key "name/size/0".
UIImage *SCPSymbolImage(NSString *name, double pointSize) {
    static NSMutableDictionary *cache = nil;
    if (cache == nil) cache = [NSMutableDictionary dictionary];
    NSString *key = [NSString stringWithFormat:@"%@/%.0f/%d", name, pointSize, 0];
    UIImage *image = cache[key];
    if (image != nil) return image;
    image = SCPRenderTemplateImage(NO, ^(UIBezierPath *stroke, UIBezierPath *fill) {
        SCPDrawSymbolIcon(name, stroke, fill);
    }, pointSize);
    cache[key] = image;
    return image;
}

// Preset-preview draw block @0x47e00 (captures: preset fractions,
// mainStack flag, mainRight flag) — VERIFIED line-by-line in the
// final micro-closure pass, including the segment block @0x48140.
// The glyph does NOT draw divider lines: on the 24x24 grid (cells
// span x:[3,21], y:[5,19]) it appends one ROUNDED-RECT outline per
// cell to the stroke path (lineWidth set to 1.5 by the block) via
// the segment block @0x48140, which converts each cell rect into a
// bezierPathWithRoundedRect:cornerRadius: subpath (radius from the
// UNCLAMPED cell size, rect dims clamped to >= 1). The inter-cell
// gap is 1.6 everywhere; cell sizes are rounded to 1 decimal
// (frinta, ties away — as C round()).
static void SCPDrawPresetGlyph(UIBezierPath *stroke, UIBezierPath *fill,
                               NSArray *preset, BOOL mainStack, BOOL mainRight) {
    (void)fill;
    stroke.lineWidth = 1.5;
    // Segment block @0x48140 (captures the stroke path).
    void (^addCell)(CGRect) = ^(CGRect rect) {
        double w = MAX(rect.size.width, 1.0);
        double h = MAX(rect.size.height, 1.0);
        double radius = MIN(MIN(rect.size.width, rect.size.height) * 0.5, 2.0);
        [stroke appendPath:[UIBezierPath bezierPathWithRoundedRect:
            CGRectMake(rect.origin.x, rect.origin.y, w, h)
            cornerRadius:radius]];
    };
    if (mainStack && preset.count >= 2) {
        // Main cell width from preset[0] over 16.4 (= 18 - 1.6 gap);
        // the stack column takes the rest; its top cell height comes
        // from preset[1] over 12.4 (= 14 - 1.6 gap).
        double mainW = round([preset[0] doubleValue] * 16.4 * 10.0) / 10.0;
        double stackH = round([preset[1] doubleValue] * 12.4 * 10.0) / 10.0;
        double stackX = mainRight ? 3.0 : (mainW + 3.0 + 1.6);
        double stackW = 18.0 - mainW - 1.6;
        addCell(CGRectMake(mainRight ? 21.0 - mainW : 3.0, 5.0, mainW, 14.0));
        addCell(CGRectMake(stackX, 5.0, stackW, stackH));
        addCell(CGRectMake(stackX, 5.0 + stackH + 1.6, stackW,
                           14.0 - stackH - 1.6));
        return;
    }
    double total = 18.0 - (double)(preset.count - 1) * 1.6;
    double x = 3.0;
    NSUInteger count = preset.count;
    for (NSUInteger i = 1; i <= count; i++) {
        double w = (i == count) ? (21.0 - x)
            : round(total * [preset[i - 1] doubleValue] * 10.0) / 10.0;
        addCell(CGRectMake(x, 5.0, w, 14.0));
        x += w + 1.6;
    }
}

// CLOSED @0x302f8: wraps an image in a 34x34 SCPCButton chip.
UIButton *SCPWrapRatioChip(UIImage *image, id target, SEL action) {
    SCPCButton *button = [SCPCButton buttonWithType:0];
    button.bounds = CGRectMake(0, 0, 34, 34);
    button.layer.cornerRadius = 17;
    button.tintColor = [UIColor colorWithRed:0.2901960784313726
                                       green:0.30980392156862746
                                        blue:0.5019607843137255 alpha:1.0];
    [button setImage:image forState:UIControlStateNormal];
    [button addTarget:target action:action
        forControlEvents:UIControlEventTouchUpInside];
    return button;
}

// CLOSED @0x2b404: icon button of an arbitrary size (wrap + ghost style).
UIButton *SCPMakeIconButton(UIImage *image, id target, SEL action, double size) {
    UIButton *button = SCPWrapRatioChip(image, target, action);
    button.bounds = CGRectMake(0, 0, size, size);
    SCPStyleDragGhost(button, size * 0.5);
    return button;
}

// CLOSED @0x30450: selected-state ring — a conic gradient layer masked
// by a rounded-rect stroke, plus an accent shadow.
void SCPMarkRatioChipSelected(UIView *view) {
    CAGradientLayer *ring = nil;
    for (CALayer *sub in view.layer.sublayers)
        if ([sub.name isEqualToString:@"omcRing"]) { ring = (CAGradientLayer *)sub; break; }
    if (ring == nil) {
        ring = [CAGradientLayer layer];
        ring.name = @"omcRing";
        ring.type = kCAGradientLayerConic;
        ring.startPoint = CGPointMake(0.5, 0.5);
        ring.endPoint = CGPointMake(0, 1);
        UIColor *c1 = [UIColor colorWithRed:0.6549019607843137 green:0.5450980392156862 blue:0.9803921568627451 alpha:1.0];
        UIColor *c2 = [UIColor colorWithRed:0.3764705882352941 green:0.7725490196078432 blue:0.9803921568627451 alpha:1.0];
        UIColor *c3 = [UIColor colorWithRed:0.3686274509803922 green:0.8666666666666667 blue:0.7137254901960784 alpha:1.0];
        UIColor *c4 = [UIColor colorWithRed:0.9607843137254902 green:0.6039215686274509 blue:0.7529411764705882 alpha:1.0];
        ring.colors = @[(id)c1.CGColor, (id)c2.CGColor, (id)c3.CGColor,
                        (id)c4.CGColor, (id)c1.CGColor];
        CAShapeLayer *mask = [CAShapeLayer layer];
        mask.fillColor = nil;
        mask.strokeColor = UIColor.blackColor.CGColor;
        mask.lineWidth = 2;
        ring.mask = mask;
        [view.layer insertSublayer:ring atIndex:0];
    }
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    ring.frame = view.bounds;
    ((CAShapeLayer *)ring.mask).path =
        [UIBezierPath bezierPathWithRoundedRect:CGRectInset(view.bounds, 1, 1)
            cornerRadius:MAX(view.layer.cornerRadius - 1, 0)].CGPath;
    [CATransaction commit];
    view.layer.borderWidth = 0;
    view.layer.shadowColor = [UIColor colorWithRed:0.6078431372549019
                                             green:0.5294117647058824
                                              blue:0.9725490196078431
                                             alpha:1.0].CGColor;
    view.layer.shadowOpacity = 0.3f;
    view.layer.shadowRadius = 8;
    view.layer.shadowOffset = CGSizeMake(0, 4);
}

// CLOSED @0x29b10: pill styling — blur/mesh backdrop inserted at index 0.
void SCPStyleRatioMenu(UIView *view, double radius) {
    view.backgroundColor = UIColor.clearColor;
    view.layer.cornerRadius = radius;
    view.layer.cornerCurve = kCACornerCurveContinuous;
    view.layer.shadowColor = [UIColor colorWithRed:0.43137254901960786
                                             green:0.39215686274509803
                                              blue:0.7843137254901961
                                             alpha:1.0].CGColor;
    view.layer.shadowOpacity = 0.3f;
    view.layer.shadowRadius = 14;
    view.layer.shadowOffset = CGSizeMake(0, 6);
    UIVisualEffectView *effect = SCPKnobFaceView(); // [phase2; backported to src in phase 3] name unified
    effect.frame = view.bounds;
    effect.autoresizingMask = 0x12;
    SCPApplyMeshBackdrop(effect);
    effect.layer.cornerRadius = radius;
    effect.layer.cornerCurve = kCACornerCurveContinuous;
    effect.clipsToBounds = YES;
    effect.userInteractionEnabled = NO;
    [view insertSubview:effect atIndex:0];
}

// CLOSED @0x24a34: entrance preparation — starts invisible at 90% scale,
// shifted up 8 pt, then springs to the saved transform.
void SCPPrepareRatioMenu(UIView *view) {
    CGAffineTransform saved = view.transform;
    view.alpha = 0;
    view.transform = CGAffineTransformConcat(
        CGAffineTransformMakeScale(0.9, 0.9),
        CGAffineTransformMakeTranslation(0, -8));
    [UIView animateWithDuration:0.45 delay:0
         usingSpringWithDamping:0.86 initialSpringVelocity:0.4 options:6
        animations:^{
            view.alpha = 1;
            view.transform = saved;
        } completion:nil];
}

@implementation SCPCarSplit (RatioMenu)

- (void)showRatioMenuForDivider:(SCPCarDividerView *)divider {          // 0x2f614
    if (self.paneCount < 2) return;
    if (self.container == nil) return;
    for (SCPCarPane *pane in self.slots)
        [self setBarVisible:NO forPane:pane];
    if ((NSInteger)self.fractions.count != (self.mainStack ? 2 : self.paneCount))
        [self resetFractions];

    NSArray *presets = [self ratioPresets];
    BOOL vertical = self.vertical;
    BOOL mainStack = self.mainStack;
    BOOL mainRight = self.mainRight;

    NSMutableArray<UIView *> *chips = [NSMutableArray array];
    for (NSUInteger i = 0; i < presets.count; i++) {
        NSArray *preset = presets[i];
        // CLOSURE: the preview is an IMAGE from the template renderer
        // @0x46a64 with the preset draw block @0x47e00 (captures
        // preset/mainStack/mainRight), wrapped by SCPWrapRatioChip.
        UIImage *preview = SCPRenderTemplateImage(vertical,
            ^(UIBezierPath *stroke, UIBezierPath *fill) {
                SCPDrawPresetGlyph(stroke, fill, preset, mainStack, mainRight);
            }, 22.0);
        UIView *chip = SCPWrapRatioChip(preview, self, @selector(ratioPresetTapped:));
        chip.tag = (NSInteger)i;
        if ([self fractionsMatch:preset])
            SCPMarkRatioChipSelected(chip);
        [chips addObject:chip];
    }

    // Menu width: 6 + 36 per button chip, 9 per separator.
    double total = 6.0;
    for (UIView *chip in chips)
        total += [chip isKindOfClass:UIButton.class] ? 36.0 : 9.0;

    UIView *menu = [[UIView alloc] initWithFrame:CGRectMake(0, 0, total, 42.0)];
    SCPStyleRatioMenu(menu, 21.0);

    // Lay the chips out left-to-right; cursor starts at 4.
    double cursor = 4.0;
    for (UIView *chip in chips) {
        if ([chip isKindOfClass:UIButton.class]) {
            chip.center = CGPointMake(cursor + 17.0, 21.0);
            [menu addSubview:chip];
            cursor += 36.0;
        } else {
            UIView *sep = [[UIView alloc] init];
            sep.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.95];
            sep.userInteractionEnabled = NO;
            sep.frame = CGRectMake(cursor - 1.0 + 4.5, 12.0, 1.0, 18.0);
            [menu addSubview:sep];
            cursor += 9.0;
        }
    }

    // Position the menu above the knob (below it if it would clip the top),
    // clamped inside the container with a 6 pt margin.
    CGRect knobRect = [self.container convertRect:divider.knob.frame fromView:divider];
    CGSize menuSize = menu.bounds.size;
    double cy = CGRectGetMinY(knobRect) - 10.0 - menuSize.height / 2.0;
    if (cy < menuSize.height / 2.0 + 6.0)
        cy = CGRectGetMaxY(knobRect) + 10.0 + menuSize.height / 2.0;
    cy = MIN(cy, self.container.bounds.size.height - menuSize.height / 2.0 - 6.0);
    double cx = CGRectGetMidX(knobRect);
    cx = MAX(cx, menuSize.width / 2.0 + 6.0);
    cx = MIN(cx, self.container.bounds.size.width - menuSize.width / 2.0 - 6.0);
    menu.center = CGPointMake(cx, cy);

    UIWindow *window = [self trayWindowForParent:self.container];
    self.ratioOverlay = (window != nil);
    if (window != nil) {
        menu.center = [self.container convertPoint:menu.center toView:nil];
        [window addSubview:menu];
    } else {
        [self.container addSubview:menu];
    }
    self.ratioMenu = menu;
    SCPVoiceBubbleUpdate(self);
    [self updatePopupShield];

    if (window == nil) {
        // In-container menus cover hosted panes: cover any whose frame
        // intersects the menu frame (inset by -6).
        for (SCPCarPane *pane in [self hostedPanes]) {
            if (CGRectIntersectsRect(CGRectInset(menu.frame, -6, -6), pane.view.frame)) {
                self.ratioHidesBridge = YES;
                [self addCoverToPane:pane];
            }
        }
    }
    [self pushHostFramesLive:NO];

    self.ratioKnob = divider.knob;
    SCPSetKnobActive(divider.knob, YES);
    SCPPrepareRatioMenu(menu);

    __weak SCPCarSplit *weakSelf = self;
    self.ratioTimer = [NSTimer scheduledTimerWithTimeInterval:4.0 repeats:NO
        block:^(NSTimer *timer) { [weakSelf hideRatioMenu]; }];

    OMCLogWrite(@"SplitScreen",
        [NSString stringWithFormat:@"CarSplit: cham tay nam vach %d -> thanh ti le (%lu muc)",
            divider.index, (unsigned long)presets.count]);
}

- (void)hideRatioMenu {                                                 // 0x30ce0
    [self.ratioTimer invalidate];
    self.ratioTimer = nil;
    UIView *menu = self.ratioMenu;
    self.ratioMenu = nil;
    [self updatePopupShield];
    if (menu == nil) return;

    if (self.ratioKnob != nil) SCPSetKnobActive(self.ratioKnob, NO);
    self.ratioKnob = nil;

    UIWindow *window = self.ratioOverlay ? self.trayWindow : nil;
    __weak SCPCarSplit *weakSelf = self;
    [UIView animateWithDuration:0.15
        animations:^{
            menu.alpha = 0;
        } completion:^(BOOL finished) {
            [menu removeFromSuperview];
            SCPCarSplit *showSplit=weakSelf;
            if (showSplit) SCPVoiceBubbleUpdate(showSplit);
            // INFERRED from the completion block @0x31070: the tray window
            // is hidden once nothing (tray / ratio menu / picker sheet)
            // is using it any more.
            SCPCarSplit *s = weakSelf;
            if (window != nil && s.tray == nil && s.ratioMenu == nil &&
                s.pickerSheet == nil)
                window.hidden = YES;
        }];

    if (self.ratioHidesBridge) {
        self.ratioHidesBridge = NO;
        if (!self.resizing) {
            for (SCPCarPane *pane in [self hostedPanes])
                [self removeCoverFromPane:pane];
        }
        [self pushHostFramesLive:NO];
    }
}

@end
