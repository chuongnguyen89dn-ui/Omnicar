// SPPBubbleView.m — OmniCarPrefs reconstruction (Prefs-B)
// Small methods VERIFIED line-level against the Prefs dump
// (src/Prefs/disasm/SPPBubbleView.asm): init 0x2dc30, speedState 0x2dcc0,
// stateColor 0x2dd78, speedRatio 0x2ddfc, bit:/addBit:to:/shapePart:…,
// setOverLimitWarning: 0x30830, numberColor 0x30b48, applyColor: 0x30c98,
// stackNumberAt:top:width: 0x3128c, stackHeight 0x313bc, render 0x34c00,
// rebuild 0x34c70, setColor: 0x34c78.
// buildStyle: (0x2e0a8) and renderStyle (0x3146c) re-audited line-level
// 2026-11-08 (prefsbubble round): every per-style view/layer/frame/color
// below is restored from that dump with all __const doubles decoded from
// the original binary; the previous "structural" reconstruction (which
// built almost none of the render objects and no render geometry at
// all) is replaced. The two constant arrays are decoded from the
// chained-fixup tables: applyColor: key list @0x7fbb8 = @[@"bar",@"ticks"],
// style-4 mesh locations @0x7fba0 = @[@0, @0.5, @0.5, @1].
// The speed font's feature-settings ids follow SPPSignView.m's
// reconstruction of the shared binary function sub_2d6bc (INFERRED there).
#import "SPPBubbleView.h"
#import "OMCCommon.h"
#import <QuartzCore/QuartzCore.h>
#import <math.h>

// sub_2d6bc: rounded-design Heavy font with tabular-number feature
// settings (shared with SPPSignView; see SPPSignView.m).
static UIFont *SPPSpeedFont(double size) {
    UIFont *base = [UIFont systemFontOfSize:size weight:UIFontWeightHeavy];
    UIFontDescriptor *desc = [base.fontDescriptor fontDescriptorWithDesign:UIFontDescriptorSystemDesignRounded];
    if (!desc) desc = base.fontDescriptor;
    desc = [desc fontDescriptorByAddingAttributes:@{
        UIFontDescriptorFeatureSettingsAttribute: @[@{
            UIFontFeatureTypeIdentifierKey: @(1),
            UIFontFeatureSelectorIdentifierKey: @(0),
        }],
    }];
    return [UIFont fontWithDescriptor:desc size:size];
}

// sub_30644: rounded-design Semibold font.
static UIFont *SPPRoundedFont(double size) {
    UIFont *base = [UIFont systemFontOfSize:size weight:UIFontWeightSemibold];
    UIFontDescriptor *desc = [base.fontDescriptor fontDescriptorWithDesign:UIFontDescriptorSystemDesignRounded];
    if (!desc) desc = base.fontDescriptor;
    return [UIFont fontWithDescriptor:desc size:size];
}

// sub_2d620: label factory (font + color, centered, shrinks to fit).
static UILabel *SPPMakeLabel(UIFont *font, UIColor *color) {
    UILabel *l = [[UILabel alloc] init];
    l.font = font;
    l.textColor = color;
    l.textAlignment = NSTextAlignmentCenter;
    l.adjustsFontSizeToFitWidth = YES;
    l.minimumScaleFactor = 0.6;
    return l;
}

// sub_304f4: the 3-stop palette (indigo -> blue -> teal), CGColors.
static NSArray *SPPPaletteColors(void) {
    return @[(id)[UIColor colorWithRed:0.65490 green:0.54510 blue:0.98039 alpha:1].CGColor,
             (id)[UIColor colorWithRed:0.37647 green:0.77255 blue:0.98039 alpha:1].CGColor,
             (id)[UIColor colorWithRed:0.36863 green:0.86667 blue:0.71373 alpha:1].CGColor];
}

// sub_3499c: the 5-stop conic palette (palette + pink, first repeated).
static NSArray *SPPConicColors(void) {
    return @[(id)[UIColor colorWithRed:0.65490 green:0.54510 blue:0.98039 alpha:1].CGColor,
             (id)[UIColor colorWithRed:0.37647 green:0.77255 blue:0.98039 alpha:1].CGColor,
             (id)[UIColor colorWithRed:0.36863 green:0.86667 blue:0.71373 alpha:1].CGColor,
             (id)[UIColor colorWithRed:0.96078 green:0.60392 blue:0.75294 alpha:1].CGColor,
             (id)[UIColor colorWithRed:0.65490 green:0.54510 blue:0.98039 alpha:1].CGColor];
}

// sub_3036c: gradient layer masked by a stroked circle path. Conic form
// sweeps the conic palette; linear form uses the 3-stop palette.
static CAGradientLayer *SPPArcGradient(double width, BOOL conic) {
    CAGradientLayer *grad = [CAGradientLayer layer];
    if (conic) {
        grad.type = kCAGradientLayerConic;
        grad.startPoint = CGPointMake(0.5, 0.5);
        grad.endPoint = CGPointMake(0.5, 0);
        grad.colors = SPPConicColors();
    } else {
        grad.startPoint = CGPointMake(0, 0);
        grad.endPoint = CGPointMake(1, 1);
        grad.colors = SPPPaletteColors();
    }
    CAShapeLayer *mask = [CAShapeLayer layer];
    mask.fillColor = [UIColor clearColor].CGColor;
    mask.strokeColor = [UIColor blackColor].CGColor;
    mask.lineWidth = (CGFloat)width;
    mask.lineCap = kCALineCapRound;
    grad.mask = mask;
    return grad;
}

// sub_3460c: size a view to a square and center it on (cx, cy).
static void SPPPlaceSquare(UIView *view, double cx, double cy, double size) {
    view.bounds = CGRectMake(0, 0, size, size);
    view.center = CGPointMake(cx, cy);
    [view setNeedsLayout];
}

// sub_3467c: frame a layer and give its mask the same bounds + a path.
static void SPPSetPartPath(CALayer *layer, UIBezierPath *path, CGRect rect) {
    layer.frame = rect;
    layer.mask.frame = layer.bounds;
    ((CAShapeLayer *)layer.mask).path = path.CGPath;
}

// sub_34760: place the unit label right after the speed label, aligned
// so the two baselines sit on one line.
static void SPPPlaceUnitAfterSpeed(UILabel *unit, UILabel *speed) {
    CGFloat baseline = CGRectGetMinY(speed.frame) + speed.font.ascender;
    CGFloat d = baseline + (speed.frame.size.height - speed.font.lineHeight) * 0.5;
    CGFloat w = ceil([unit sizeThatFits:CGSizeMake(200, 40)].width);
    CGFloat x = CGRectGetMaxX(speed.frame) + 4;
    unit.frame = CGRectMake(x, d - unit.font.ascender, w, unit.font.lineHeight);
}

// sub_348d8 (+ its block sub_35254): animate a bit's width; the frame
// becomes (0, 0, width, superview height). No-op for deltas < 0.25.
static void SPPAnimateBitWidth(UIView *bit, double width, double duration) {
    if (fabs(bit.frame.size.width - width) < 0.25) return;
    [UIView animateWithDuration:duration delay:0
                        options:UIViewAnimationOptionCurveEaseOut |
                                UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
        bit.frame = CGRectMake(0, 0, width, bit.superview.bounds.size.height);
    } completion:nil];
}

// sub_30730: soft coloured shadow under a label.
static void SPPLabelShadow(UIView *view, UIColor *color, double radius) {
    view.layer.shadowColor = color.CGColor;
    view.layer.shadowOffset = CGSizeZero;
    view.layer.shadowRadius = (CGFloat)radius;
    view.layer.shadowOpacity = 1.0f;
}

// Style-8 gauge math (the two blocks captured at 0x31bd0/0x31c10 in the
// binary, invoke bodies 0x34b80/0x34bb8): value -> dial angle in
// degrees, and dial point on the (70, 70) centre.
static double SPPGaugeAngle(double value) {
    double t = MAX(value, 0.0) / 200.0;
    if (t > 1.04) t = 1.04;
    return t * 240.0 + 150.0;
}
static CGPoint SPPGaugePoint(double radius, double angleDeg) {
    double rad = angleDeg * M_PI / 180.0;
    return CGPointMake(70.0 + radius * cos(rad), 70.0 + radius * sin(rad));
}

static UIColor *SPPSlate(void) {
    return [UIColor colorWithRed:0.29020 green:0.30980 blue:0.50196 alpha:1];
}
static UIColor *SPPAmber(void) {
    return [UIColor colorWithRed:1 green:0.70196 blue:0.25098 alpha:1];
}
static UIColor *SPPStateRed(void) {
    return [UIColor colorWithRed:1 green:0.35294 blue:0.37255 alpha:1];
}

@implementation SPPBubbleView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (!self) return nil;
    _builtStyle = -1;
    _speed = -1;
    _limit = -1;
    _showIcon = YES;
    self.userInteractionEnabled = NO;
    return self;
}

#pragma mark - State

- (int)speedState {
    if (self.limit < 1 || self.speed < 0) return 0;
    if (self.builtStyle == 7) {
        if (self.speed >= self.limit) return 2;
    } else {
        if (self.speed > self.limit) return 2;
    }
    // Near the limit at >= 90%.
    return ((double)self.limit * 0.9 <= (double)self.speed) ? 1 : 0;
}

- (UIColor *)stateColor {
    int s = [self speedState];
    if (s == 1) return SPPAmber();
    if (s == 2) return SPPStateRed();
    return SPPSlate();
}

- (double)speedRatio {
    if (self.speed < 1) return 0;
    double denom = self.limit >= 1 ? (double)self.limit : 160.0;
    double r = (double)self.speed / denom;
    return r > 1 ? 1 : r;
}

#pragma mark - Parts

- (UIView *)bit:(NSString *)key {
    return self.bits[key];
}

- (UIView *)addBit:(NSString *)key to:(UIView *)container {
    UIView *v = [[UIView alloc] init];
    v.userInteractionEnabled = NO;
    [container addSubview:v];
    self.bits[key] = v;
    return v;
}

- (CAShapeLayer *)shapePart:(NSString *)key in:(UIView *)container
                     stroke:(UIColor *)color width:(double)width {
    CAShapeLayer *layer = [CAShapeLayer layer];
    layer.fillColor = [UIColor clearColor].CGColor;
    layer.strokeColor = color.CGColor;
    layer.lineWidth = (CGFloat)width;
    [container.layer addSublayer:layer];
    self.parts[key] = layer;
    return layer;
}

#pragma mark - Build

- (void)buildStyle:(NSInteger)style {
    for (UIView *v in [self.subviews copy]) [v removeFromSuperview];
    for (CALayer *l in [self.layer.sublayers copy]) [l removeFromSuperlayer];
    self.glass = nil;
    self.iconView = nil;
    self.sign = nil;
    self.flashView = nil;
    self.deco = nil;
    self.speedLabel = nil;
    self.unitLabel = nil;
    self.tickLabels = nil;
    self.parts = [NSMutableDictionary dictionary];
    self.bits = [NSMutableDictionary dictionary];

    NSInteger s = (NSUInteger)style > 8 ? 0 : style;

    // Over-limit flash layer exists for every style (red, starts hidden).
    UIView *flash = [[UIView alloc] init];
    flash.backgroundColor = SPPStateRed();
    flash.alpha = 0;
    flash.userInteractionEnabled = NO;
    self.flashView = flash;

    SPPGlassView *glass = [[SPPGlassView alloc] init];
    self.glass = glass;
    // Glass joins the hierarchy only for styles {1,4,6,7} (bitmask 0xd2
    // on the unclamped argument, VERIFIED); the flash rides inside it.
    if (((1LL << style) & 0xd2) != 0) {
        [self addSubview:glass];
        [glass addSubview:flash];
    }
    glass.hidden = (s == 5 || s == 8);

    // Label colors/fonts, replaced per style below.
    UIColor *speedColor = SPPSlate();
    UIColor *unitColor = [SPPSlate() colorWithAlphaComponent:0.55];
    double speedSize = 30, unitSize = 10;

    // Branch order follows the binary: 7 first, then 0–3, 4–5, 6, 8.
    if (s == 7) {
        UIView *ticks = [self addBit:@"ticks" to:self];
        ticks.backgroundColor = [SPPSlate() colorWithAlphaComponent:0.16];
        CAShapeLayer *ticksMask = [CAShapeLayer layer];
        ticks.layer.mask = ticksMask;
        self.parts[@"ticksMask"] = ticksMask;
        UIView *fill = [self addBit:@"fill" to:ticks];
        fill.clipsToBounds = YES;
        CAGradientLayer *fillGrad = [CAGradientLayer layer];
        fillGrad.startPoint = CGPointMake(0, 0.5);
        fillGrad.endPoint = CGPointMake(1, 0.5);
        fillGrad.colors = SPPPaletteColors();
        [fill.layer addSublayer:fillGrad];
        self.parts[@"fillGrad"] = fillGrad;
        speedSize = 30; unitSize = 10;
    } else if (s == 0) {
        CAGradientLayer *ring = SPPArcGradient(3.0, YES);
        [glass.layer addSublayer:ring];
        self.parts[@"ring"] = ring;
        CAGradientLayer *shine = [CAGradientLayer layer];
        shine.colors = @[(id)[UIColor colorWithWhite:1 alpha:0.75].CGColor,
                         (id)[UIColor colorWithWhite:1 alpha:0].CGColor];
        shine.masksToBounds = YES;
        [glass.layer addSublayer:shine];
        self.parts[@"shine"] = shine;
        speedSize = 33; unitSize = 10;
    } else if (s == 1) {
        UIView *dot = [self addBit:@"dot" to:self];
        dot.layer.cornerRadius = 4;
        UIView *bar = [self addBit:@"bar" to:self];
        bar.backgroundColor = [SPPSlate() colorWithAlphaComponent:0.18];
        bar.layer.cornerRadius = 0.75;
        speedSize = 32; unitSize = 10;
    } else if (s == 2) {
        [self shapePart:@"nearRing" in:glass stroke:SPPAmber() width:3];
        speedSize = 30; unitSize = 10;
    } else if (s == 3) {
        CAShapeLayer *track = [self shapePart:@"track" in:glass
            stroke:[SPPSlate() colorWithAlphaComponent:0.12] width:7];
        track.lineCap = kCALineCapRound;
        CAGradientLayer *fill = SPPArcGradient(7.0, NO);
        [glass.layer addSublayer:fill];
        self.parts[@"fill"] = fill;
        speedSize = 34; unitSize = 10;
    }
    if (s == 4) {
        glass.fill.startPoint = CGPointMake(0, 0);
        glass.fill.endPoint = CGPointMake(1, 1);
        CAGradientLayer *mesh = [CAGradientLayer layer];
        mesh.startPoint = CGPointMake(1, 0);
        mesh.endPoint = CGPointMake(0, 1);
        UIColor *meshA = [UIColor colorWithRed:0.65098 green:0.86667 blue:0.99216 alpha:1];
        UIColor *meshB = [UIColor colorWithRed:0.99608 green:0.76863 blue:0.84706 alpha:1];
        mesh.colors = @[(id)[meshA colorWithAlphaComponent:0.9].CGColor,
                        (id)[meshA colorWithAlphaComponent:0].CGColor,
                        (id)[meshB colorWithAlphaComponent:0].CGColor,
                        (id)[meshB colorWithAlphaComponent:0.9].CGColor];
        mesh.locations = @[@0, @0.5, @0.5, @1];
        [glass.fill insertSublayer:mesh atIndex:0];
        self.parts[@"mesh"] = mesh;
        glass.fill.borderColor = [UIColor whiteColor].CGColor;
        glass.layer.shadowColor = [UIColor colorWithRed:0.31373 green:0.27451 blue:0.62745 alpha:1].CGColor;
        glass.layer.shadowOpacity = 0.28f;
        glass.layer.shadowRadius = 12;
        UIView *track = [self addBit:@"track" to:self];
        track.backgroundColor = [UIColor colorWithWhite:1 alpha:0.55];
        track.layer.cornerRadius = 3;
        track.clipsToBounds = YES;
        UIView *fill = [self addBit:@"fill" to:track];
        fill.layer.cornerRadius = 3;
        fill.clipsToBounds = YES;
        CAGradientLayer *fillGrad = [CAGradientLayer layer];
        fillGrad.startPoint = CGPointMake(0, 0.5);
        fillGrad.endPoint = CGPointMake(1, 0.5);
        fillGrad.colors = @[(id)[UIColor colorWithRed:0.60784 green:0.52941 blue:0.97255 alpha:1].CGColor,
                            (id)[UIColor colorWithRed:0.36471 green:0.70588 blue:0.96471 alpha:1].CGColor];
        [fill.layer addSublayer:fillGrad];
        self.parts[@"fillGrad"] = fillGrad;
        speedSize = 40; unitSize = 10;
    } else if (s == 5) {
        speedColor = SPPSlate();
        unitColor = SPPSlate();
        UIView *track = [self addBit:@"track" to:self];
        track.backgroundColor = [UIColor colorWithWhite:1 alpha:0.8];
        track.layer.cornerRadius = 2.5;
        track.layer.shadowColor = [UIColor blackColor].CGColor;
        track.layer.shadowOpacity = 0.15f;
        track.layer.shadowRadius = 2;
        track.layer.shadowOffset = CGSizeMake(0, 1);
        UIView *fill = [self addBit:@"fill" to:track];
        fill.layer.cornerRadius = 2.5;
        fill.clipsToBounds = YES;
        CAGradientLayer *fillGrad = [CAGradientLayer layer];
        fillGrad.startPoint = CGPointMake(0, 0.5);
        fillGrad.endPoint = CGPointMake(1, 0.5);
        fillGrad.colors = SPPPaletteColors();
        [fill.layer addSublayer:fillGrad];
        self.parts[@"fillGrad"] = fillGrad;
        speedSize = 48; unitSize = 12;
    } else if (s == 6) {
        speedColor = [UIColor whiteColor];
        unitColor = [UIColor colorWithWhite:1 alpha:0.6];
        [glass setTop:[UIColor colorWithRed:0.07059 green:0.07843 blue:0.11765 alpha:0.82]
               bottom:[UIColor colorWithRed:0.04706 green:0.07843 blue:0.05098 alpha:0.86]];
        glass.fill.borderWidth = 0;
        glass.sheen.hidden = YES;
        glass.layer.shadowColor = [UIColor blackColor].CGColor;
        glass.layer.shadowOpacity = 0.35f;
        UIColor *glowColor = [UIColor colorWithRed:0.65490 green:0.54510 blue:0.98039 alpha:1];
        CAShapeLayer *glow = [self shapePart:@"glow" in:self stroke:glowColor width:1.5];
        glow.shadowColor = glowColor.CGColor;
        glow.shadowRadius = 4;
        glow.shadowOpacity = 0.9f;
        glow.shadowOffset = CGSizeZero;
        CAGradientLayer *ring = SPPArcGradient(1.5, YES);
        [self.layer addSublayer:ring];
        self.parts[@"ring"] = ring;
        speedSize = 30; unitSize = 10;
    }
    if (s == 8) {
        speedColor = [UIColor whiteColor];
        unitColor = [UIColor colorWithWhite:1 alpha:0.6];
        UIView *deco = [[UIView alloc] init];
        deco.userInteractionEnabled = NO;
        deco.layer.shadowColor = [UIColor blackColor].CGColor;
        deco.layer.shadowOpacity = 0.35f;
        deco.layer.shadowRadius = 8;
        deco.layer.shadowOffset = CGSizeMake(0, 4);
        [self addSubview:deco];
        self.deco = deco;
        CAGradientLayer *face = [CAGradientLayer layer];
        face.type = kCAGradientLayerRadial;
        face.colors = @[(id)[UIColor colorWithRed:0.16471 green:0.18039 blue:0.27059 alpha:1].CGColor,
                        (id)[UIColor colorWithRed:0.04706 green:0.07843 blue:0.05098 alpha:1].CGColor];
        face.masksToBounds = YES;
        [deco.layer addSublayer:face];
        self.parts[@"face"] = face;
        CAGradientLayer *ring = SPPArcGradient(3.0, YES);
        [deco.layer addSublayer:ring];
        self.parts[@"ring"] = ring;
        [self shapePart:@"inner" in:deco
                 stroke:[UIColor colorWithWhite:1 alpha:0.08] width:1];
        CAShapeLayer *zone = [self shapePart:@"zone" in:deco
            stroke:[SPPStateRed() colorWithAlphaComponent:0.9] width:3.5];
        zone.lineCap = kCALineCapButt;
        CAShapeLayer *limTick = [self shapePart:@"limTick" in:deco
                                          stroke:SPPStateRed() width:2.5];
        limTick.lineCap = kCALineCapRound;
        CAShapeLayer *minor = [self shapePart:@"minor" in:deco
            stroke:[UIColor colorWithWhite:1 alpha:0.45] width:1.2];
        minor.lineCap = kCALineCapRound;
        CAShapeLayer *major = [self shapePart:@"major" in:deco
            stroke:[UIColor colorWithWhite:1 alpha:0.9] width:2];
        major.lineCap = kCALineCapRound;
        CAGradientLayer *prog = SPPArcGradient(3.0, NO);
        prog.startPoint = CGPointMake(0, 1);
        prog.endPoint = CGPointMake(1, 0);
        [deco.layer addSublayer:prog];
        self.parts[@"prog"] = prog;
        CAShapeLayer *needle = [self shapePart:@"needle" in:deco stroke:nil width:0];
        UIColor *needleColor = [UIColor colorWithRed:1 green:0.35294 blue:0.21176 alpha:1];
        needle.fillColor = needleColor.CGColor;
        needle.shadowColor = needleColor.CGColor;
        needle.shadowRadius = 3;
        needle.shadowOpacity = 0.8f;
        needle.shadowOffset = CGSizeZero;
        CAShapeLayer *hub = [self shapePart:@"hub" in:deco
            stroke:[UIColor colorWithWhite:1 alpha:0.85] width:1.5];
        hub.fillColor = [UIColor colorWithRed:0.13725 green:0.14902 blue:0.22745 alpha:1].CGColor;
        NSMutableArray *labels = [NSMutableArray array];
        for (int i = 0; i < 9; i++) {
            UILabel *tick = SPPMakeLabel(SPPRoundedFont(9),
                [UIColor colorWithWhite:1 alpha:0.85]);
            tick.font = [UIFont systemFontOfSize:9 weight:UIFontWeightBold];
            [deco addSubview:tick];
            [labels addObject:tick];
        }
        self.tickLabels = labels;
        speedSize = 24; unitSize = 9;
    }

    // Shared tail: labels, sign, icon.
    self.speedLabel = SPPMakeLabel(SPPSpeedFont(speedSize), speedColor);
    self.unitLabel = SPPMakeLabel(SPPRoundedFont(unitSize), unitColor);
    if (s == 5) {
        SPPLabelShadow(self.speedLabel, [UIColor whiteColor], 4.0);
        SPPLabelShadow(self.unitLabel, [UIColor whiteColor], 4.0);
    }
    if (style == 6 || style == 8) {
        SPPLabelShadow(self.speedLabel,
            [UIColor colorWithRed:0.54902 green:0.74510 blue:1 alpha:0.7], 8.0);
    }
    [self addSubview:self.speedLabel];
    [self addSubview:self.unitLabel];
    SPPSignView *sign = [[SPPSignView alloc] init];
    self.sign = sign;
    [self addSubview:sign];
    SPPIconView *iconView = [[SPPIconView alloc] init];
    self.iconView = iconView;
    iconView.shape = 0;
    [self addSubview:iconView];
    iconView.imageView.image = nil;

    if (self.log) self.log([NSString stringWithFormat:@"bubble: kieu %ld", (long)s]);
    self.builtStyle = s;
}

#pragma mark - Warning flash

- (void)setOverLimitWarning:(BOOL)warn {
    BOOL has = [self.flashView.layer animationForKey:@"sppFlash"] != nil;
    if (warn == has) return;
    if (warn) {
        CABasicAnimation *flash = [CABasicAnimation animationWithKeyPath:@"opacity"];
        flash.fromValue = @0.0;
        flash.toValue = @0.5;
        flash.duration = 0.5;
        flash.autoreverses = YES;
        flash.repeatCount = HUGE_VALF;
        flash.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        self.flashView.alpha = 1;
        self.flashView.layer.opacity = 0;
        [self.flashView.layer addAnimation:flash forKey:@"sppFlash"];
        CABasicAnimation *pulse = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
        pulse.fromValue = @1.0;
        pulse.toValue = @1.1;
        pulse.duration = 0.5;
        pulse.autoreverses = YES;
        pulse.repeatCount = HUGE_VALF;
        [self.sign.layer addAnimation:pulse forKey:@"sppPulse"];
        if (self.log) self.log(@"bubble: vuot gioi han -> nhay canh bao");
    } else {
        [self.flashView.layer removeAnimationForKey:@"sppFlash"];
        self.flashView.alpha = 0;
        [self.sign.layer removeAnimationForKey:@"sppPulse"];
    }
}

#pragma mark - Colors

- (UIColor *)numberColor {
    int state = [self speedState];
    NSInteger s = self.builtStyle;
    if (s == 6 || s == 8) {
        if (state == 1) return [UIColor colorWithRed:1 green:0.83529 blue:0.54118 alpha:1];
        if (state == 2) return [UIColor colorWithRed:1 green:0.54118 blue:0.55294 alpha:1];
        return [UIColor whiteColor];
    }
    if (s == 4) {
        if (state >= 1) return [UIColor whiteColor];
        return SPPSlate();
    }
    if (s == 2 && state == 2) return [UIColor whiteColor];
    if (state == 1) return [UIColor colorWithRed:0.85098 green:0.54118 blue:0 alpha:1];
    if (state == 2) return [UIColor colorWithRed:0.94118 green:0.19608 blue:0.22745 alpha:1];
    return SPPSlate();
}

- (void)applyColor:(int)state {
    NSInteger c = self.color;
    if (c < 1 || c > 6) return;
    static const uint32_t kRGB[7] = {0x000000, 0xFFFFFF, 0x16182A, 0x7C5CF0,
                                     0x2F8FE0, 0x16A87F, 0xE8558C};
    static const double kAlpha[7] = {0, 0.94, 0.88, 0.92, 0.92, 0.92, 0.92};
    uint32_t v = kRGB[c];
    UIColor *base = [UIColor colorWithRed:((v >> 16) & 0xff) / 255.0
                                    green:((v >> 8) & 0xff) / 255.0
                                     blue:(v & 0xff) / 255.0 alpha:1];
    UIColor *faded = [base colorWithAlphaComponent:kAlpha[c]];
    if (self.builtStyle == 8) {
        if (c != 1) {
            ((CAGradientLayer *)self.parts[@"face"]).colors =
                @[(id)base.CGColor, (id)base.CGColor];
        }
        return;
    }
    if (self.builtStyle == 5) {
        if (state != 0) {
            self.speedLabel.layer.shadowColor = [UIColor whiteColor].CGColor;
            return;
        }
        self.speedLabel.textColor = base;
        self.speedLabel.layer.shadowColor =
            (c == 1 ? [UIColor blackColor] : [UIColor whiteColor]).CGColor;
        return;
    }
    UIColor *tint = state == 2 ? SPPStateRed() : state == 1 ? SPPAmber() : faded;
    [self.glass setTop:tint bottom:tint];
    ((CALayer *)self.parts[@"mesh"]).hidden = YES;
    if (state <= 0 && c == 1) {
        self.speedLabel.textColor = SPPSlate();
        self.unitLabel.textColor = [SPPSlate() colorWithAlphaComponent:0.55];
    } else {
        self.speedLabel.textColor = [UIColor whiteColor];
        self.unitLabel.textColor = state >= 1 ? [UIColor whiteColor]
            : [UIColor colorWithWhite:1 alpha:0.75];
        if (c != 1) {
            for (NSString *key in @[@"bar", @"ticks"])
                [self bit:key].backgroundColor = [UIColor colorWithWhite:1 alpha:0.28];
        }
    }
}

#pragma mark - Number stack

- (void)stackNumberAt:(double)x top:(double)top width:(double)width {
    double speedH = ceil(self.speedLabel.font.lineHeight);
    double unitH = ceil(self.unitLabel.font.lineHeight);
    self.speedLabel.frame = CGRectMake(x - width / 2, top, width, speedH);
    self.unitLabel.frame = CGRectMake(x - width / 2, top + speedH - 3, width, unitH);
}

- (double)stackHeight {
    return ceil(self.speedLabel.font.lineHeight) - 3
         + ceil(self.unitLabel.font.lineHeight);
}

#pragma mark - Render

- (void)renderStyle {
    NSInteger limit = self.limit;
    BOOL showIcon = self.showIcon;
    int state = [self speedState];
    UIColor *sColor = [self stateColor];
    double ratio = [self speedRatio];

    self.speedLabel.text = self.speed < 0 ? @"--"
        : [NSString stringWithFormat:@"%d", self.speed];
    self.speedLabel.textColor = [self numberColor];
    self.unitLabel.text = @"km/h";
    self.sign.label.text = limit < 1 ? @"--"
        : [NSString stringWithFormat:@"%d", (int)limit];
    self.sign.muted = limit < 1;
    self.iconView.hidden = !showIcon;
    if (showIcon && self.iconView.imageView.image != self.iconImage)
        self.iconView.imageView.image = self.iconImage;

    [CATransaction begin];
    [CATransaction setDisableActions:YES];

    SPPGlassView *glass = self.glass;
    UIView *flashBase = nil;       // path A: inset this view's frame
    BOOL flashFromGlass = NO;      // path B: glass bounds + glass corner
    CGSize content = CGSizeZero;

    switch (self.builtStyle) {
    case 0:
    default: {
        glass.frame = CGRectMake(4, 16, 100, 100);
        glass.corner = 50;
        CAGradientLayer *ring = (CAGradientLayer *)self.parts[@"ring"];
        SPPSetPartPath(ring, [UIBezierPath bezierPathWithOvalInRect:CGRectMake(1.5, 1.5, 97, 97)],
                       CGRectMake(0, 0, 100, 100));
        ring.colors = state == 0 ? SPPConicColors()
            : @[(id)sColor.CGColor, (id)sColor.CGColor];
        CAGradientLayer *shine = (CAGradientLayer *)self.parts[@"shine"];
        shine.frame = CGRectMake(16, 9, 46, 26);
        shine.cornerRadius = 13;
        [self stackNumberAt:54 top:68 - [self stackHeight] / 2 width:84];
        SPPPlaceSquare(self.iconView, 11, 107, 22);
        SPPPlaceSquare(self.sign, 95, 25, 50);
        content = CGSizeMake(120, 118);
        flashBase = glass;
        break;
    }
    case 1: {
        UIView *dot = [self bit:@"dot"];
        dot.hidden = showIcon;
        dot.backgroundColor = state != 0 ? sColor
            : [UIColor colorWithRed:0.36863 green:0.86667 blue:0.71373 alpha:1];
        double leftPad;
        if (showIcon) {
            SPPPlaceSquare(self.iconView, 21, 30, 22);
            leftPad = 42;
        } else {
            dot.frame = CGRectMake(10, 26, 8, 8);
            leftPad = 24;
        }
        double textW = MAX(ceil([self.speedLabel sizeThatFits:CGSizeMake(200, 40)].width), 52);
        [self stackNumberAt:leftPad + textW / 2 top:30 - [self stackHeight] / 2 width:textW];
        double barX = leftPad + textW + 10;
        [self bit:@"bar"].frame = CGRectMake(barX, 14, 1.5, 32);
        double mid = barX + 11.5;
        SPPPlaceSquare(self.sign, mid + 22, 30, 44);
        double totalW = mid + 44 + 8;
        glass.frame = CGRectMake(0, 0, totalW, 60);
        glass.corner = 30;
        content = CGSizeMake(totalW, 60);
        flashFromGlass = YES;
        break;
    }
    case 2: {
        glass.frame = CGRectMake(4, 4, 76, 76);
        glass.corner = 38;
        if (state == 2)
            [glass setTop:SPPStateRed()
                   bottom:[UIColor colorWithRed:0.94118 green:0.25098 blue:0.27451 alpha:1]];
        else
            [glass setTop:[UIColor colorWithWhite:1 alpha:0.9]
                   bottom:[UIColor colorWithRed:0.94510 green:0.94118 blue:0.98431 alpha:0.9]];
        CAShapeLayer *nearRing = (CAShapeLayer *)self.parts[@"nearRing"];
        nearRing.hidden = (state != 1);
        nearRing.frame = CGRectMake(0, 0, 76, 76);
        nearRing.path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(1.5, 1.5, 73, 73)].CGPath;
        self.unitLabel.textColor = state == 2 ? [UIColor whiteColor]
            : [SPPSlate() colorWithAlphaComponent:0.55];
        [self stackNumberAt:42 top:42 - [self stackHeight] / 2 width:64];
        SPPPlaceSquare(self.iconView, 10, 10, 20);
        SPPPlaceSquare(self.sign, 124, 42, 72);
        content = CGSizeMake(160, 80);
        flashBase = glass;
        break;
    }
    case 3: {
        glass.frame = CGRectMake(0, 0, 104, 104);
        glass.corner = 52;
        UIBezierPath *arc = [UIBezierPath bezierPathWithArcCenter:CGPointMake(52, 52)
            radius:46 startAngle:2.356194490192345 endAngle:7.0685834705770345 clockwise:YES];
        CAShapeLayer *track = (CAShapeLayer *)self.parts[@"track"];
        track.frame = CGRectMake(0, 0, 104, 104);
        track.path = arc.CGPath;
        CAGradientLayer *fill = (CAGradientLayer *)self.parts[@"fill"];
        SPPSetPartPath(fill, arc, CGRectMake(0, 0, 104, 104));
        fill.colors = state != 0 ? @[(id)sColor.CGColor, (id)sColor.CGColor]
                                 : SPPPaletteColors();
        [CATransaction setDisableActions:NO];
        [CATransaction setAnimationDuration:0.6];
        ((CAShapeLayer *)fill.mask).strokeEnd = (CGFloat)ratio;
        [CATransaction setDisableActions:YES];
        [self stackNumberAt:52 top:46 - [self stackHeight] / 2 width:80];
        SPPPlaceSquare(self.iconView, 10, 12, 20);
        SPPPlaceSquare(self.sign, 52, 99, 46);
        content = CGSizeMake(104, 122);
        flashBase = glass;
        break;
    }
    case 4: {
        glass.frame = CGRectMake(0, 0, 124, 124);
        glass.corner = 28;
        CAGradientLayer *mesh = (CAGradientLayer *)self.parts[@"mesh"];
        mesh.frame = CGRectMake(0, 0, 124, 124);
        mesh.hidden = (state != 0);
        if (state == 2)
            [glass setTop:SPPStateRed()
                   bottom:[UIColor colorWithRed:1 green:0.30980 blue:0.33333 alpha:1]];
        else if (state == 1)
            [glass setTop:[UIColor colorWithRed:1 green:0.83529 blue:0.54118 alpha:1]
                   bottom:SPPAmber()];
        else
            [glass setTop:[UIColor colorWithRed:0.78824 green:0.72941 blue:0.98824 alpha:0.97]
                   bottom:[UIColor colorWithRed:0.62745 green:0.94510 blue:0.85098 alpha:0.97]];
        glass.sheen.hidden = (state != 0);
        if (showIcon) SPPPlaceSquare(self.iconView, 23, 23, 22);
        SPPPlaceSquare(self.sign, 88, 36, 48);
        self.unitLabel.textColor = state != 0 ? [UIColor whiteColor]
            : [SPPSlate() colorWithAlphaComponent:0.55];
        double textW = ceil([self.speedLabel sizeThatFits:CGSizeMake(200, 50)].width);
        self.speedLabel.frame = CGRectMake(12, 59, textW, 48);
        SPPPlaceUnitAfterSpeed(self.unitLabel, self.speedLabel);
        UIView *track = [self bit:@"track"];
        track.frame = CGRectMake(12, 106, 100, 6);
        CAGradientLayer *fillGrad = (CAGradientLayer *)self.parts[@"fillGrad"];
        fillGrad.frame = CGRectMake(0, 0, track.bounds.size.width, 6);
        fillGrad.hidden = (state != 0);
        [self bit:@"fill"].backgroundColor = state != 0 ? [UIColor whiteColor]
                                                        : [UIColor clearColor];
        [CATransaction setDisableActions:NO];
        SPPAnimateBitWidth([self bit:@"fill"], ratio * track.bounds.size.width, 0.6);
        [CATransaction setDisableActions:YES];
        content = CGSizeMake(124, 124);
        flashFromGlass = YES;
        break;
    }
    case 5: {
        double pad = showIcon ? 24 : 0;
        if (showIcon) SPPPlaceSquare(self.iconView, 10, 10, 20);
        self.unitLabel.textColor = SPPSlate();
        double textW = ceil([self.speedLabel sizeThatFits:CGSizeMake(220, 60)].width);
        self.speedLabel.frame = CGRectMake(0, pad, textW, 52);
        SPPPlaceUnitAfterSpeed(self.unitLabel, self.speedLabel);
        double contentW = MAX(CGRectGetMaxX(self.unitLabel.frame), 92);
        double trackY = pad + 55;
        UIView *track = [self bit:@"track"];
        track.frame = CGRectMake(0, trackY, 92, 5);
        CAGradientLayer *fillGrad = (CAGradientLayer *)self.parts[@"fillGrad"];
        fillGrad.frame = CGRectMake(0, 0, 92, 5);
        fillGrad.colors = state != 0 ? @[(id)sColor.CGColor, (id)sColor.CGColor]
                                     : SPPPaletteColors();
        [CATransaction setDisableActions:NO];
        SPPAnimateBitWidth([self bit:@"fill"], ratio * 92, 0.6);
        [CATransaction setDisableActions:YES];
        SPPPlaceSquare(self.sign, contentW + 28, trackY - 23, 40);
        content = CGSizeMake(contentW + 48, trackY + 5);
        flashBase = self.speedLabel;
        break;
    }
    case 6: {
        SPPPlaceSquare(self.sign, 35, 33, 50);
        [self stackNumberAt:35 top:66 width:62];
        double contentH = 66 + [self stackHeight];
        if (showIcon) {
            SPPPlaceSquare(self.iconView, 35, contentH + 17, 18);
            contentH += 26;
        }
        contentH += 12;
        glass.frame = CGRectMake(0, 0, 70, contentH);
        glass.corner = 35;
        UIBezierPath *ringPath = [UIBezierPath
            bezierPathWithRoundedRect:CGRectMake(0.75, 0.75, 68.5, contentH - 1.5)
                         cornerRadius:34.25];
        CAGradientLayer *ring = (CAGradientLayer *)self.parts[@"ring"];
        SPPSetPartPath(ring, ringPath, CGRectMake(0, 0, 70, contentH));
        ring.colors = state == 0 ? SPPConicColors()
            : @[(id)sColor.CGColor, (id)sColor.CGColor];
        CAShapeLayer *glow = (CAShapeLayer *)self.parts[@"glow"];
        glow.frame = CGRectMake(0, 0, 70, contentH);
        glow.path = ringPath.CGPath;
        glow.strokeColor = (state == 0
            ? [UIColor colorWithRed:0.65490 green:0.54510 blue:0.98039 alpha:1]
            : sColor).CGColor;
        glow.shadowColor = glow.strokeColor;
        self.speedLabel.layer.shadowColor = (state == 2 ? SPPStateRed()
            : state == 1 ? SPPAmber()
            : [UIColor colorWithRed:0.54902 green:0.74510 blue:1 alpha:0.7]).CGColor;
        content = CGSizeMake(70, contentH);
        flashFromGlass = YES;
        break;
    }
    case 7: {
        double leftPad = showIcon ? 36 : 10;
        if (showIcon) SPPPlaceSquare(self.iconView, 17, 29, 22);
        double speedW = ceil([self.speedLabel sizeThatFits:CGSizeMake(200, 40)].width);
        double unitW = ceil([self.unitLabel sizeThatFits:CGSizeMake(200, 20)].width);
        double contentW = MAX(speedW, unitW);
        [self stackNumberAt:leftPad + contentW / 2
                        top:29 - [self stackHeight] / 2 width:contentW];
        double totalW = leftPad + contentW + 8;
        UIView *ticks = [self bit:@"ticks"];
        ticks.frame = CGRectMake(totalW, 17, 61, 24);
        UIBezierPath *maskPath = [UIBezierPath bezierPath];
        for (double x = 0; x + 5 <= 61.5; x += 8) {
            double t = ((x + 2.5) / -61.0 + 1) * 14.88;
            [maskPath appendPath:[UIBezierPath
                bezierPathWithRoundedRect:CGRectMake(x, t, 5, 24 - t)
                             cornerRadius:1.5]];
        }
        CAShapeLayer *ticksMask = (CAShapeLayer *)self.parts[@"ticksMask"];
        ticksMask.frame = ticks.bounds;
        ticksMask.path = maskPath.CGPath;
        CAGradientLayer *fillGrad = (CAGradientLayer *)self.parts[@"fillGrad"];
        fillGrad.frame = CGRectMake(0, 0, 61, 24);
        if (state == 1)
            fillGrad.colors = @[(id)[UIColor colorWithRed:1 green:0.83529 blue:0.54118 alpha:1].CGColor,
                                (id)SPPAmber().CGColor];
        else if (state == 2)
            fillGrad.colors = @[(id)SPPStateRed().CGColor, (id)SPPStateRed().CGColor];
        else
            fillGrad.colors = SPPPaletteColors();
        [CATransaction setDisableActions:NO];
        SPPAnimateBitWidth([self bit:@"fill"], ratio * 61, 0.9);
        [CATransaction setDisableActions:YES];
        SPPPlaceSquare(self.sign, totalW + 94, 29, 50);
        glass.frame = CGRectMake(0, 0, totalW + 123, 58);
        glass.corner = 29;
        content = CGSizeMake(totalW + 123, 58);
        flashFromGlass = YES;
        break;
    }
    case 8: {
        UIView *deco = self.deco;
        deco.frame = CGRectMake(0, 0, 140, 140);
        deco.layer.shadowPath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(70, 70)
            radius:70 startAngle:0 endAngle:2 * M_PI clockwise:YES].CGPath;
        CAGradientLayer *face = (CAGradientLayer *)self.parts[@"face"];
        face.frame = CGRectMake(0, 0, 140, 140);
        face.cornerRadius = 70;
        face.startPoint = CGPointMake(0.5, 0.42);
        face.endPoint = CGPointMake(1.1, 1.02);
        CAGradientLayer *ring = (CAGradientLayer *)self.parts[@"ring"];
        SPPSetPartPath(ring, [UIBezierPath bezierPathWithArcCenter:CGPointMake(70, 70)
            radius:67 startAngle:0 endAngle:2 * M_PI clockwise:YES],
            CGRectMake(0, 0, 140, 140));
        ((CAShapeLayer *)self.parts[@"inner"]).path =
            [UIBezierPath bezierPathWithArcCenter:CGPointMake(70, 70)
                radius:64 startAngle:0 endAngle:2 * M_PI clockwise:YES].CGPath;
        UIBezierPath *minorPath = [UIBezierPath bezierPath];
        UIBezierPath *majorPath = [UIBezierPath bezierPath];
        NSInteger labelIdx = 0;
        for (int v = 0; v <= 150; v += 10) {
            double angle = SPPGaugeAngle(v);
            BOOL major = (v % 20 == 0);
            UIBezierPath *p = major ? majorPath : minorPath;
            [p moveToPoint:SPPGaugePoint(major ? 53 : 57, angle)];
            [p addLineToPoint:SPPGaugePoint(61, angle)];
            if (major && labelIdx < (NSInteger)self.tickLabels.count) {
                UILabel *tick = self.tickLabels[labelIdx++];
                tick.text = [NSString stringWithFormat:@"%d", v];
                CGPoint c = SPPGaugePoint(43, angle);
                tick.frame = CGRectMake(c.x - 12, c.y - 6, 24, 12);
                tick.hidden = NO;
            }
        }
        for (NSInteger i = labelIdx; i < (NSInteger)self.tickLabels.count; i++)
            ((UILabel *)self.tickLabels[i]).hidden = YES;
        ((CAShapeLayer *)self.parts[@"minor"]).path = minorPath.CGPath;
        ((CAShapeLayer *)self.parts[@"major"]).path = majorPath.CGPath;
        BOOL zoneHidden = (limit < 1 || limit >= 160);
        CAShapeLayer *zone = (CAShapeLayer *)self.parts[@"zone"];
        CAShapeLayer *limTick = (CAShapeLayer *)self.parts[@"limTick"];
        zone.hidden = zoneHidden;
        limTick.hidden = zoneHidden;
        if (!zoneHidden) {
            zone.path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(70, 70)
                radius:63 startAngle:SPPGaugeAngle(limit) * M_PI / 180
                  endAngle:SPPGaugeAngle(160) * M_PI / 180 clockwise:YES].CGPath;
            UIBezierPath *tick = [UIBezierPath bezierPath];
            [tick moveToPoint:SPPGaugePoint(40, SPPGaugeAngle(limit))];
            [tick addLineToPoint:SPPGaugePoint(65, SPPGaugeAngle(limit))];
            limTick.path = tick.CGPath;
        }
        CAGradientLayer *prog = (CAGradientLayer *)self.parts[@"prog"];
        SPPSetPartPath(prog, [UIBezierPath bezierPathWithArcCenter:CGPointMake(70, 70)
            radius:49 startAngle:2.6179938779914944 endAngle:6.8067840827778845
            clockwise:YES], CGRectMake(0, 0, 140, 140));
        prog.colors = state != 0 ? @[(id)sColor.CGColor, (id)sColor.CGColor]
                                 : SPPPaletteColors();
        CAShapeLayer *needle = (CAShapeLayer *)self.parts[@"needle"];
        needle.bounds = CGRectMake(0, 0, 140, 140);
        needle.position = CGPointMake(70, 70);
        UIBezierPath *np = [UIBezierPath bezierPath];
        [np moveToPoint:CGPointMake(60, 67.8)];
        [np addLineToPoint:CGPointMake(117, 70)];
        [np addLineToPoint:CGPointMake(60, 72.2)];
        [np closePath];
        needle.path = np.CGPath;
        ((CAShapeLayer *)self.parts[@"hub"]).path =
            [UIBezierPath bezierPathWithArcCenter:CGPointMake(70, 70)
                radius:7 startAngle:0 endAngle:2 * M_PI clockwise:YES].CGPath;
        [CATransaction setDisableActions:NO];
        [CATransaction setAnimationDuration:0.6];
        double spd = self.speed < 0 ? 0 : self.speed;
        ((CAShapeLayer *)prog.mask).strokeEnd =
            (CGFloat)MIN((SPPGaugeAngle(spd) - 150) / 240, 1);
        needle.transform = CATransform3DMakeRotation(SPPGaugeAngle(spd) * M_PI / 180, 0, 0, 1);
        [CATransaction setDisableActions:YES];
        self.speedLabel.frame = CGRectMake(30, 86, 80, 28);
        self.unitLabel.frame = CGRectMake(40, 112, 60, 11);
        self.speedLabel.layer.shadowColor = (state == 2 ? SPPStateRed()
            : state == 1 ? SPPAmber()
            : [UIColor colorWithRed:0.54902 green:0.74510 blue:1 alpha:0.6]).CGColor;
        SPPPlaceSquare(self.iconView, 14, 14, 24);
        SPPPlaceSquare(self.sign, 131, 125, 66);
        content = CGSizeMake(164, 158);
        flashBase = deco;
        break;
    }
    }

    [self applyColor:state];

    if (flashFromGlass) {
        self.flashView.frame = glass.bounds;
        self.flashView.layer.cornerRadius = (CGFloat)glass.corner;
    } else if (flashBase) {
        CGRect f = CGRectInset(flashBase.frame, -6, -6);
        self.flashView.frame = f;
        self.flashView.layer.cornerRadius = flashBase == self.speedLabel ? 16
            : (CGFloat)(MIN(f.size.width, f.size.height) / 2);
    }

    if (self.builtStyle == 5) {
        self.outlineRect = CGRectMake(0, 0, content.width, content.height);
        self.outlineCorner = 16;
    } else if (self.builtStyle == 8) {
        self.outlineRect = self.deco.frame;
        self.outlineCorner = self.deco.frame.size.width * 0.5;
    } else {
        self.outlineRect = glass.frame;
        self.outlineCorner = glass.corner;
    }

    [CATransaction commit];
    self.contentSize = content;
    [self setOverLimitWarning:state == 2];
}

- (CGSize)render {
    NSInteger s = self.style;
    if (s < 0 || s > 8) s = 0;
    if (self.builtStyle != s) [self buildStyle:s];
    [self renderStyle];
    return self.contentSize;
}

- (void)rebuild {
    self.builtStyle = -1;
}

- (void)setColor:(NSInteger)color {
    if (color == _color) return;
    _color = color;
    [self rebuild];
}

@end
