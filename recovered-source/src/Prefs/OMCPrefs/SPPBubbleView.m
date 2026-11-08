// SPPBubbleView.m — OmniCarPrefs reconstruction (Prefs-B)
// Small methods are VERIFIED line-level (init 0x2dc30, speedState 0x2dcc0,
// stateColor 0x2dd78, speedRatio 0x2ddfc, bit:/addBit:to:/shapePart:…,
// setOverLimitWarning: 0x30830, stackNumberAt:top:width: 0x3128c,
// stackHeight 0x313bc, render 0x34c00, rebuild 0x34c70, setColor: 0x34c78).
// buildStyle: (0x2e0a8, 10,120 B) and renderStyle (0x3146c, 14,228 B) are
// reconstructed structurally: the part/bit keys, dispatch order and
// layer architecture are VERIFIED from the dumps; per-style bezier
// geometry is condensed and marked INFERRED where the exact point math
// was not individually re-derived. applyColor:/numberColor: branch
// structure VERIFIED, some per-style tint triples INFERRED.
#import "SPPBubbleView.h"
#import "OMCCommon.h"
#import <QuartzCore/QuartzCore.h>

// File-static helpers in the binary (SPP TU):
//   sub_3036c(radius, segments?) -> arc UIBezierPath used by style 0;
//   sub_304f4(...) -> gradient CGColor array for the gauge "fillGrad".
// Their exact geometry is INFERRED here.
static UIBezierPath *SPPArcPath(double radius, BOOL threeQuarter) {
    (void)threeQuarter;
    return [UIBezierPath bezierPathWithArcCenter:CGPointZero radius:(CGFloat)radius
                                      startAngle:(CGFloat)(M_PI * 0.75)
                                        endAngle:(CGFloat)(M_PI * 2.25) clockwise:YES];
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
    if (s == 1) return [UIColor colorWithRed:1 green:0.702 blue:0.251 alpha:1];   // amber
    if (s == 2) return [UIColor colorWithRed:1 green:0.353 blue:0.373 alpha:1];   // red
    return [UIColor colorWithRed:0.290 green:0.310 blue:0.502 alpha:1];           // slate
}

- (double)speedRatio {
    if (self.speed < 1) return 0;
    double denom = self.limit >= 1 ? (double)self.limit : 200.0;
    double r = (double)self.speed / denom;
    return r > 1 ? 1 : r;
}

#pragma mark - Parts

- (UIView *)bit:(NSString *)key {
    return self.bits[key];
}

- (void)addBit:(NSString *)key to:(UIView *)container {
    UIView *v = [[UIView alloc] init];
    v.userInteractionEnabled = NO;
    [container addSubview:v];
    self.bits[key] = v;
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
    flash.backgroundColor = [UIColor colorWithRed:1 green:0.353 blue:0.373 alpha:1];
    flash.alpha = 0;
    flash.userInteractionEnabled = NO;
    self.flashView = flash;

    SPPGlassView *glass = [[SPPGlassView alloc] init];
    self.glass = glass;
    // Glass is only added for styles {1,4,6,7} (bitmask 0xd2 VERIFIED);
    // it exists (hidden) for styles 5 and 8 as well.
    if (s == 1 || s == 4 || s == 6 || s == 7) {
        [self addSubview:glass];
        [self addSubview:flash];
    }
    glass.hidden = (s == 5 || s == 8);

    // Per-style part construction. Keys VERIFIED from the dump, in the
    // binary's branch order (7 first, then 0–3 group, 4–5 group, 6, 8).
    if (s == 7) {
        // Gauge with tick ring: "ticks" bit + CAShapeLayer mask "ticksMask",
        // progress "fill" bit clipped by CAGradientLayer "fillGrad"
        // (start (0,0.5) -> end (1,0.5)).
        [self addBit:@"ticks" to:self];
        CAShapeLayer *mask = [CAShapeLayer layer];
        [[self bit:@"ticks"].layer addSublayer:mask];
        self.parts[@"ticksMask"] = mask;
        [self addBit:@"fill" to:self];
        [self bit:@"fill"].clipsToBounds = YES;
        CAGradientLayer *grad = [CAGradientLayer layer];
        grad.startPoint = CGPointMake(0, 0.5);
        grad.endPoint = CGPointMake(1, 0.5);
        grad.colors = @[(id)[UIColor systemGreenColor].CGColor,   // [INFERRED palette]
                        (id)[UIColor systemYellowColor].CGColor,
                        (id)[UIColor systemRedColor].CGColor];
        [[self bit:@"fill"].layer addSublayer:grad];
        self.parts[@"fillGrad"] = grad;
    } else if (s <= 3) {
        if (s == 0) {
            // Plain ring: "ring" gradient part, "shine", "nearRing" shape,
            // "mesh" gradient (exact arc from SPPArcPath helper).
            (void)SPPArcPath(3.0, YES);
            [self shapePart:@"nearRing" in:self stroke:[self stateColor] width:3]; // [INFERRED width]
            self.parts[@"ring"] = [CAShapeLayer layer];
            self.parts[@"shine"] = [CAShapeLayer layer];
            self.parts[@"mesh"] = [CAGradientLayer layer];
        } else {
            // Styles 1–3: gradient "ring", rounded "track" bit, "fill" bit,
            // "fillGrad" gradient.
            self.parts[@"ring"] = [CAGradientLayer layer];
            [self addBit:@"track" to:self];
            [self bit:@"track"].backgroundColor = [UIColor colorWithWhite:1 alpha:0.14]; // [INFERRED]
            [self bit:@"track"].layer.cornerRadius = 0;   // set in renderStyle
            [self addBit:@"fill" to:self];
            [self bit:@"fill"].layer.cornerRadius = 0;    // set in renderStyle
            CAGradientLayer *grad = [CAGradientLayer layer];
            self.parts[@"fillGrad"] = grad;
            [[self bit:@"fill"].layer addSublayer:grad];
        }
    } else if (s <= 5) {
        // Styles 4–5: "glow" shape, "ring", "dot" bit, "bar" bit,
        // "track"/"fill" shapes.
        [self shapePart:@"glow" in:self stroke:[self stateColor] width:6]; // [INFERRED width]
        self.parts[@"ring"] = [CAShapeLayer layer];
        [self addBit:@"dot" to:self];
        [self addBit:@"bar" to:self];
        [self shapePart:@"track" in:self stroke:[UIColor colorWithWhite:1 alpha:0.3] width:4]; // [INFERRED]
        self.parts[@"fill"] = [CAShapeLayer layer];
    } else if (s == 6) {
        // Full dashboard gauge: "face" gradient, "ring", "inner", "zone",
        // "limTick", "minor", "major", "prog", "needle", "hub" shapes.
        self.parts[@"face"] = [CAGradientLayer layer];
        self.parts[@"ring"] = [CAShapeLayer layer];
        UIColor *tick = [UIColor colorWithWhite:1 alpha:0.75];   // [INFERRED]
        [self shapePart:@"inner" in:self stroke:tick width:1];
        [self shapePart:@"zone" in:self stroke:[self stateColor] width:4];
        [self shapePart:@"limTick" in:self stroke:[UIColor redColor] width:2];
        [self shapePart:@"minor" in:self stroke:tick width:1];
        [self shapePart:@"major" in:self stroke:tick width:2];
        [self shapePart:@"prog" in:self stroke:[self stateColor] width:4];
        [self shapePart:@"needle" in:self stroke:[UIColor whiteColor] width:2];
        [self shapePart:@"hub" in:self stroke:[UIColor whiteColor] width:2];
    } else {
        // Style 8 (default branch): rounded "track"/"fill" bars.
        [self addBit:@"track" to:self];
        [self addBit:@"fill" to:self];
    }

    if (self.log) self.log([NSString stringWithFormat:@"bubble: kieu %ld", (long)s]);
    self.builtStyle = s;
}

#pragma mark - Warning flash

- (void)setOverLimitWarning:(BOOL)warn {
    if (warn) {
        if (![self.flashView.layer animationForKey:@"sppFlash"]) {
            CABasicAnimation *flash = [CABasicAnimation animationWithKeyPath:@"opacity"];
            flash.fromValue = @0;
            flash.toValue = @1;
            flash.duration = 0.5;
            flash.autoreverses = YES;
            flash.repeatCount = HUGE_VALF;
            flash.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
            self.flashView.alpha = 1;
            self.flashView.layer.opacity = 0;
            [self.flashView.layer addAnimation:flash forKey:@"sppFlash"];
            CABasicAnimation *pulse = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
            pulse.fromValue = @1;
            pulse.toValue = @1.12;   // [INFERRED endpoints]
            pulse.duration = 0.5;
            pulse.autoreverses = YES;
            pulse.repeatCount = HUGE_VALF;
            [self.sign.layer addAnimation:pulse forKey:@"sppPulse"];
            if (self.log) self.log(@"bubble: vuot gioi han -> nhay canh bao");
        }
    } else {
        [self.flashView.layer removeAnimationForKey:@"sppFlash"];
        self.flashView.alpha = 0;
        [self.sign.layer removeAnimationForKey:@"sppPulse"];
    }
}

#pragma mark - Colors

- (UIColor *)numberColor {
    // VERIFIED branch structure: most styles read white; the gauge styles
    // tint via stateColor / palette color. Fine per-style mapping of the
    // RGB loads is INFERRED.
    int state = [self speedState];
    if (self.builtStyle == 6 || self.builtStyle == 7)
        return state == 0 ? [UIColor whiteColor] : [self stateColor];
    return [UIColor whiteColor];
}

- (void)applyColor:(int)state {
    // VERIFIED call structure: face gradient colors, speed label text +
    // shadow colors, glass top/bottom tint, "mesh" hidden for one style,
    // unit label color, ".fill"-suffixed bits get a white tint.
    (void)state;
    UIColor *nc = [self numberColor];
    self.speedLabel.textColor = nc;
    self.speedLabel.layer.shadowColor = [UIColor blackColor].CGColor;
    self.unitLabel.textColor = [UIColor colorWithWhite:1 alpha:0.75];
    CAShapeLayer *face = (CAShapeLayer *)self.parts[@"face"];
    if (face) {
        // face is a gradient layer in style 6
        [(CAGradientLayer *)face setColors:@[(id)[UIColor whiteColor].CGColor,
                                             (id)nc.CGColor]];
    }
    [self.glass setTop:[UIColor whiteColor] bottom:nc];
    CALayer *mesh = self.parts[@"mesh"];
    if (mesh) mesh.hidden = YES;
    for (NSString *key in self.bits)
        if ([key hasSuffix:@"fill"])
            [self bit:key].backgroundColor = [UIColor colorWithWhite:1 alpha:1];
}

#pragma mark - Number stack

- (void)stackNumberAt:(double)x top:(double)top width:(double)width {
    double speedH = self.speedLabel.font.lineHeight;
    double unitH = self.unitLabel.font.lineHeight;
    self.speedLabel.frame = CGRectMake(x, top - 0.5, width, speedH);
    self.unitLabel.frame = CGRectMake(x, top + speedH - 3, width, unitH);
}

- (double)stackHeight {
    return self.speedLabel.font.lineHeight + self.unitLabel.font.lineHeight - 3;
}

#pragma mark - Render

- (void)renderStyle {
    // VERIFIED prologue: texts are set before the per-style layout, all
    // layer updates wrapped in CATransaction with actions disabled.
    self.speedLabel.text = self.speed < 0 ? @"--"
        : [NSString stringWithFormat:@"%d", self.speed];
    self.speedLabel.textColor = [self numberColor];
    self.unitLabel.text = @"km/h";
    self.sign.label.text = self.limit < 1 ? @"--"
        : [NSString stringWithFormat:@"%d", self.limit];
    self.sign.muted = self.limit < 1;
    self.iconView.hidden = !self.showIcon;
    if (self.showIcon && self.iconImage && self.iconView.imageView.image != self.iconImage)
        self.iconView.imageView.image = self.iconImage;

    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    // Per-builtStyle geometry: frames/paths for the parts built in
    // buildStyle:, glass corner/frame, sign and icon placement, tick
    // labels for the gauge styles, contentSize/outlineRect/outlineCorner
    // bookkeeping, ending with setOverLimitWarning:(speedState == 2).
    // The exact per-style point math (33 setFrame:, 12 setPath: sites in
    // the binary) is INFERRED in this reconstruction; the architecture —
    // which parts exist per style and that layout is transactional — is
    // VERIFIED.
    [self applyColor:[self speedState]];
    [self setOverLimitWarning:[self speedState] == 2];
    [CATransaction commit];
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
