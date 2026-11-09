// SPPBubbleView.m — reconstructed from OmniCarSpeedBubble.dylib (arm64).
// Agent A (display side) + wave-3 style-geometry closure.
//
// SPPBubbleView : UIView — renders the speed bubble in 9 styles
// (SPPPrefs.style 0..8). Owns the glass plate, the app icon, the limit
// sign, the speed/unit labels and a dictionary of named shape/gradient
// layers ("parts": bar, dot, face, fill, fillGrad, glow, hub, inner,
// limTick, major, mesh, minor, nearRing, needle, prog, ring, shine,
// ticks, ticksMask, track, zone) rebuilt per style.
//
// Status: state math, render pipeline and warning animation VERIFIED
// (agent A). Per-style layout geometry CLOSED by the wave-3 closure
// pass — every frame/constant below was transcribed from the
// calibrated dumps in disasm/styles/ (buildStyle: @0xed04,
// renderStyle @0x120c8) unless a block is explicitly marked PARTIAL /
// INFERRED / STUB-UNRECOVERED. See REPORT_A.md, "Style-geometry
// closure addendum", for the per-style status table and the list of
// contradictions with agent A's original scaffolds.
//
// BUBBLEFIX (2026-11-08, GPT-ordered re-audit of buildStyle +
// renderStyle against the full annotated dumps): the wave-3
// "CLOSED" label above did NOT hold in detail — 23 divergences
// were found and fixed (17 in renderStyle, 6 in buildStyle),
// each pinned to a dump offset and marked "bubblefix" inline.
// Full table: work/fix-round2/bubblefix-notes.md.

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <math.h>

@class SPPGlassView, SPPIconView, SPPSignView;
@interface SPPGlassView : UIView
@property (nonatomic, strong) CAGradientLayer *fill;
@property (nonatomic, strong) CAGradientLayer *sheen;
@property (nonatomic) double corner;
- (void)setTop:(UIColor *)top bottom:(UIColor *)bottom;
- (void)setCorner:(double)corner;
@end
@interface SPPIconView : UIView
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic) NSInteger shape;
@end
@interface SPPSignView : UIView
@property (nonatomic, strong) UILabel *label;
@property (nonatomic) BOOL muted;
- (void)applyColors;
@end

@interface SPPBubbleView : UIView
@property (nonatomic) BOOL showIcon;
@property (nonatomic) int speed;            // km/h, -1 = invalid
@property (nonatomic) int limit;            // km/h, <1 = unknown
@property (nonatomic) NSInteger style;      // wanted style 0..8
@property (nonatomic, strong) UIImage *iconImage;
@property (nonatomic) NSInteger color;      // SPPPrefs color 0..6
@property (nonatomic, copy) void (^log)(NSString *message);
@property (nonatomic) NSInteger builtStyle; // style actually built, -1 dirty
@property (nonatomic) double outlineCorner;
@property (nonatomic, strong) UILabel *speedLabel;
@property (nonatomic, strong) SPPGlassView *glass;
@property (nonatomic, strong) SPPIconView *iconView;
@property (nonatomic, strong) SPPSignView *sign;
@property (nonatomic, strong) UILabel *unitLabel;
@property (nonatomic, strong) UIView *deco;
@property (nonatomic, strong) NSMutableDictionary *parts;
@property (nonatomic, strong) NSMutableDictionary *bits;
@property (nonatomic, strong) NSArray *tickLabels;
@property (nonatomic, strong) UIView *flashView;
@property (nonatomic) CGSize contentSize;
@property (nonatomic) CGRect outlineRect;
- (void)rebuild;
- (CGSize)render;
- (NSInteger)speedState;
- (void)buildStyle:(NSInteger)style;
- (void)renderStyle;
- (double)stackHeight;
- (void)stackNumberAt:(double)cx top:(double)top width:(double)width;
- (id)bit:(NSString *)key;
- (UIView *)addBit:(NSString *)key to:(UIView *)parent;
- (CAShapeLayer *)shapePart:(NSString *)key in:(CALayer *)parentLayer
                     stroke:(UIColor *)color width:(double)width;
- (UIColor *)numberColor;
- (void)applyColor:(NSInteger)colorIndex;
- (void)setOverLimitWarning:(BOOL)on;
@end

@implementation SPPBubbleView

// -initWithFrame: @0xe88c — super init + setUserInteractionEnabled:
// (argument value not pinned in the dump: INFERRED YES).
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (!self) return nil;
    self.userInteractionEnabled = YES;
    _builtStyle = -1;
    return self;
}

#pragma mark - State math (all VERIFIED)

// -speedState @0xe91c: 0 = cruising, 1 = near limit (>= 90% of limit),
// 2 = over limit. No data (limit < 1 or speed < 0) -> 0. Style 7 is
// stricter: at the limit already counts as over (>= instead of >).
- (NSInteger)speedState {
    if (_limit < 1 || _speed < 0) return 0;
    if (_builtStyle == 7) {
        return (_speed >= _limit) ? 2 : 1;
    }
    if (_speed > _limit) return 2;
    return (0.9 * _limit <= _speed) ? 1 : 0;
}

// -stateColor @0xe9d4: state 1 amber (255,179,64), state 2 red
// (255,90,95), state 0 indigo (74,79,128).
- (UIColor *)stateColor {
    switch ([self speedState]) {
        case 1:
            return [UIColor colorWithRed:1 green:0.7019607843137254
                                    blue:0.25098039215686274 alpha:1];
        case 2:
            return [UIColor colorWithRed:1 green:0.35294117647058826
                                    blue:0.37254901960784315 alpha:1];
        default:
            return [UIColor colorWithRed:0.2901960784313726
                                   green:0.30980392156862746
                                    blue:0.5019607843137255 alpha:1];
    }
}

// -speedRatio @0xea58: speed/limit clamped to [0,1]; with no limit the
// denominator defaults to 40 km/h; speed < 1 -> 0.
- (double)speedRatio {
    if (_speed < 1) return 0;
    double denom = (_limit >= 1) ? (double)_limit : 40.0;
    double r = _speed / denom;
    return (r > 1) ? 1 : r;
}

#pragma mark - Render pipeline

// -rebuild @0x158cc — VERIFIED (8 bytes): forces a style rebuild.
- (void)rebuild {
    _builtStyle = -1;
}

// -render @0x1585c — VERIFIED: an out-of-range style falls back to 0
// (the dump branches to 0 both when style is negative and when it is
// > 8 — it does NOT clamp to 8), a changed style rebuilds, then the
// method renders and RETURNS -contentSize (tail call at 0x158c8).
// [Return type + clamp restored fix-round3 G/§8A — was void / clamp-to-8.]
- (CGSize)render {
    NSInteger style = _style;
    if (style < 0 || style > 8) style = 0;
    if (style != _builtStyle) {
        [self buildStyle:style];
    }
    [self renderStyle];
    return self.contentSize;
}

#pragma mark - Layout helpers (all VERIFIED from their dumps)

// sub_15268 — place a square view: bounds (0,0,size,size), centre
// (cx,cy), setNeedsLayout. Used for iconView and sign in every style.
static void SPPPlaceSquare(UIView *view, double cx, double cy, double size) {
    view.bounds = CGRectMake(0, 0, size, size);
    view.center = CGPointMake(cx, cy);
    [view setNeedsLayout];
}

// sub_152d8 — frame a layer and give its shape mask the path:
// layer.frame = rect; layer.mask.frame = layer.bounds;
// layer.mask.path = path.CGPath. (For a mask-less layer only the
// frame assignment has an effect.)
static void SPPFrameMask(CALayer *layer, UIBezierPath *path, CGRect rect) {
    layer.frame = rect;
    CAShapeLayer *mask = (CAShapeLayer *)layer.mask;
    mask.frame = layer.bounds;
    mask.path = path.CGPath;
}

// sub_153bc — place the unit label right of the speed label.
// VERIFIED term-by-term (item-7 micro-closure, dump of 0x153bc):
//   w = ceil([unit sizeThatFits:(200,40)].width)   (frintp @0x15478)
//   x = CGRectGetMaxX(anchor.frame) + 4            (@0x154ac-0x154b4)
//   h = unit.font.lineHeight                       (@0x154e8)
//   baseline = anchor.frame.minY + anchor.font.ascender
//              + (anchor.frame.height - anchor.font.lineHeight) / 2
//        (@0x153f8 minY, @0x15418 +ascender, @0x15440-0x1544c
//         +(h - lineHeight) * 0.5 — the anchor text's baseline when
//         its line box is centred in the frame)
//   y = baseline - unit.font.ascender              (@0x154d0)
// The binary fetches anchor.frame three times and each font twice;
// those are pure getters, so one fetch here is equivalent. (The
// earlier INFERRED form midY + ascender - lineHeight/2 is the same
// value algebraically; this is the binary's literal chain.)
static void SPPPlaceUnitRightOf(UILabel *unit, UILabel *anchor) {
    CGRect af = anchor.frame;
    double baseline = CGRectGetMinY(af) + anchor.font.ascender
        + (af.size.height - anchor.font.lineHeight) / 2;
    double w = ceil([unit sizeThatFits:CGSizeMake(200, 40)].width);
    unit.frame = CGRectMake(CGRectGetMaxX(af) + 4,
                            baseline - unit.font.ascender,
                            w, unit.font.lineHeight);
}

// sub_15534 — animate a view's frame width (only when it changes by
// >= 0.25 pt): UIView animateWithDuration:delay:0 options:
// CurveEaseOut|BeginFromCurrentState (0x20004). The animations
// block (invoke @0x15eb0, captures = view + width) does NOT keep the
// view's own x/y/height: it sets the frame to
// (0, 0, width, view.superview.bounds.height) — d0/d1 are zeroed
// @0x15ee4-0x15ee8 and the height is the superview-bounds height
// left in d3 by the bounds call @0x15edc. (Item-7 micro-closure
// correction: the previous draft kept the view's own frame origin
// and height, which the binary never reads.)
static void SPPAnimateViewWidth(UIView *view, double width, double duration) {
    if (fabs(view.frame.size.width - width) < 0.25) return;
    [UIView animateWithDuration:duration delay:0
                        options:UIViewAnimationOptionCurveEaseOut |
                                UIViewAnimationOptionBeginFromCurrentState
                     animations:^{ view.frame = CGRectMake(0, 0, width,
                                         view.superview.bounds.size.height); }
                     completion:nil];
}

// sub_155f8 — the 5-colour rainbow set (violet, sky, teal, pink,
// violet), all alpha 1, as CGColors.
static NSArray *SPPGradientColors5(void) {
    return @[
        (id)[UIColor colorWithRed:0.6549019607843137 green:0.5450980392156862
                              blue:0.9803921568627451 alpha:1].CGColor,
        (id)[UIColor colorWithRed:0.3764705882352941 green:0.7725490196078432
                              blue:0.9803921568627451 alpha:1].CGColor,
        (id)[UIColor colorWithRed:0.3686274509803922 green:0.8666666666666667
                              blue:0.7137254901960784 alpha:1].CGColor,
        (id)[UIColor colorWithRed:0.9607843137254902 green:0.6039215686274509
                              blue:0.7529411764705882 alpha:1].CGColor,
        (id)[UIColor colorWithRed:0.6549019607843137 green:0.5450980392156862
                              blue:0.9803921568627451 alpha:1].CGColor,
    ];
}

// sub_11150 — the 3-colour set (violet, sky, teal), all alpha 1, as
// CGColors. VERIFIED (item-7 micro-closure): the binary builds this
// array independently — it never calls sub_155f8 and slices; the
// values merely coincide with the first three of the 5-set (same
// __const slots @0x32930+). (Previous draft returned a subarray of
// the 5-set: equal values, wrong mechanism.)
static NSArray *SPPGradientColors3(void) {
    return @[
        (id)[UIColor colorWithRed:0.6549019607843137 green:0.5450980392156862
                              blue:0.9803921568627451 alpha:1].CGColor,
        (id)[UIColor colorWithRed:0.3764705882352941 green:0.7725490196078432
                              blue:0.9803921568627451 alpha:1].CGColor,
        (id)[UIColor colorWithRed:0.3686274509803922 green:0.8666666666666667
                              blue:0.7137254901960784 alpha:1].CGColor,
    ];
}

// sub_10fc8 — gradient "ring" layer factory: a CAGradientLayer whose
// mask is a round-capped CAShapeLayer stroked in black with the given
// line width (the caller assigns the mask's path via SPPFrameMask).
// conic: type = kCAGradientLayerConic, start (0.5,0.5), end (0.5,0),
// colours = the 5-colour set. Linear: start (0,0), end (1,1),
// colours = the 3-colour set.
static CAGradientLayer *SPPGradientRing(double lineWidth, BOOL conic) {
    CAGradientLayer *g = [CAGradientLayer layer];
    if (conic) {
        g.type = kCAGradientLayerConic;
        g.startPoint = CGPointMake(0.5, 0.5);
        g.endPoint = CGPointMake(0.5, 0);
        g.colors = SPPGradientColors5();
    } else {
        g.startPoint = CGPointMake(0, 0);
        g.endPoint = CGPointMake(1, 1);
        g.colors = SPPGradientColors3();
    }
    CAShapeLayer *mask = [CAShapeLayer layer];
    mask.fillColor = [UIColor clearColor].CGColor;
    mask.strokeColor = [UIColor blackColor].CGColor;
    mask.lineWidth = lineWidth;
    mask.lineCap = kCALineCapRound;
    g.mask = mask;
    return g;
}

// sub_112a0 — rounded-design font: systemFontOfSize:weight:Semibold
// with the Rounded design descriptor applied. VERIFIED (item-7
// micro-closure): if fontDescriptorWithDesign: returns nil the
// binary falls back to the base fontDescriptor (cbz @0x1130c ->
// refetch @0x11320) — the same idiom as SPPHeavyFont @0xe398. The
// fallback was missing from the previous draft.
static UIFont *SPPRoundedFont(double size) {
    UIFont *base = [UIFont systemFontOfSize:size weight:UIFontWeightSemibold];
    UIFontDescriptor *d = [base.fontDescriptor
        fontDescriptorWithDesign:UIFontDescriptorSystemDesignRounded];
    if (!d) d = base.fontDescriptor;
    return [UIFont fontWithDescriptor:d size:size];
}

// sub_e318 — heavy rounded font for the speed digits: same recipe
// with weight Heavy plus a UIFontDescriptorFeatureSettingsAttribute
// selecting monospaced (tabular) figures. [VERIFIED line-level,
// final closure 2026-11-08: the @0x3ce60 constant array decoded in
// full — see REPORT_A.md final-closure addendum. The descriptor the
// attributes are added to is the Rounded-design descriptor, falling
// back to the base descriptor when that is nil (branch @0xe398).]
static UIFont *SPPHeavyFont(double size) {
    UIFont *base = [UIFont systemFontOfSize:size weight:UIFontWeightHeavy];
    UIFontDescriptor *d = [base.fontDescriptor
        fontDescriptorWithDesign:UIFontDescriptorSystemDesignRounded];
    UIFontDescriptor *desc = d ?: base.fontDescriptor;
    desc = [desc fontDescriptorByAddingAttributes:@{
        UIFontDescriptorFeatureSettingsAttribute: @[
            // Constant array @0x3ce60: one setting dictionary whose
            // keys are the raw CoreText strings (identical to the
            // UIFontFeature*IdentifierKey values):
            //   CTFeatureTypeIdentifier     = 6 (kNumberSpacingType)
            //   CTFeatureSelectorIdentifier = 0 (kMonospacedNumbersSelector)
            @{ @"CTFeatureTypeIdentifier": @6,
               @"CTFeatureSelectorIdentifier": @0 },
        ],
    }];
    return [UIFont fontWithDescriptor:desc size:size];
}

// sub_e27c — label factory: centred, shrinks to fit (min scale 0.6).
static UILabel *SPPMakeLabel(UIFont *font, UIColor *color) {
    UILabel *label = [[UILabel alloc] init];
    label.font = font;
    label.textColor = color;
    label.textAlignment = NSTextAlignmentCenter;
    label.adjustsFontSizeToFitWidth = YES;
    label.minimumScaleFactor = 0.6;
    return label;
}

// sub_1138c — soft glow behind a label: shadow colour, zero offset,
// given radius, full opacity.
static void SPPApplyLabelShadow(UIView *view, UIColor *color, double radius) {
    view.layer.shadowColor = color.CGColor;
    view.layer.shadowOffset = CGSizeZero;
    view.layer.shadowRadius = radius;
    view.layer.shadowOpacity = 1.0;
}

#pragma mark - Part helpers

// -bit: — registry accessor over _bits (VERIFIED).
- (id)bit:(NSString *)key {
    return _bits[key];
}

// -addBit:to: @0xeb40 — TRUE signature (closure correction of agent
// A's scaffold, which had the arguments swapped): creates a plain
// UIView (userInteractionEnabled = NO), adds it to the given parent,
// registers it in _bits under key and returns it.
- (UIView *)addBit:(NSString *)key to:(UIView *)parent {
    UIView *view = [[UIView alloc] init];
    view.userInteractionEnabled = NO;
    [parent addSubview:view];
    _bits[key] = view;
    return view;
}

// -shapePart:in:stroke:width: @0xebe0 — TRUE semantics (closure
// correction): creates a CAShapeLayer (fill clear, stroke colour,
// line width), adds it as a sublayer of the given PARENT LAYER,
// registers it in _parts under key and returns it. No path is set at
// build time — every style assigns its paths in -renderStyle.
- (CAShapeLayer *)shapePart:(NSString *)key in:(CALayer *)parentLayer
                     stroke:(UIColor *)color width:(double)width {
    CAShapeLayer *layer = [CAShapeLayer layer];
    layer.fillColor = [UIColor clearColor].CGColor;
    layer.strokeColor = color.CGColor;
    layer.lineWidth = width;
    [parentLayer addSublayer:layer];
    _parts[key] = layer;
    return layer;
}

// -stackHeight @0x12018 — VERIFIED: ceil(speed lineHeight) - 3 +
// ceil(unit lineHeight).
- (double)stackHeight {
    return ceil(_speedLabel.font.lineHeight) - 3
         + ceil(_unitLabel.font.lineHeight);
}

// -stackNumberAt:top:width: @0x11ee8 — VERIFIED: the speed label
// sits at (cx - width/2, top) with height ceil(speed lineHeight);
// the unit label directly below it, overlapping by 3 pt.
- (void)stackNumberAt:(double)cx top:(double)top width:(double)width {
    double speedH = ceil(_speedLabel.font.lineHeight);
    double unitH = ceil(_unitLabel.font.lineHeight);
    double x = cx - width / 2;
    _speedLabel.frame = CGRectMake(x, top, width, speedH);
    _unitLabel.frame = CGRectMake(x, top + speedH - 3, width, unitH);
}

#pragma mark - Style construction

// -buildStyle: @0xed04 (8,900 bytes) — per-style part trees CLOSED
// (closure pass; evidence: disasm/styles/0000ed04). Common flow:
//   1. clamp: style outside 0..8 -> 0. Tear down: every subview and
//      sublayer removed; glass/iconView/sign/flashView/deco/labels
//      nilled; _parts/_bits replaced with fresh NSMutableDictionary.
//   2. flashView created (bg = the over-limit red (1, 0.35294,
//      0.37255), alpha 0, no interaction). Stacking differs: styles
//      {1,4,6,7} add glass to self, then flash INTO glass; styles
//      {0,2,3,5,8} add flash to self first, then glass above it.
//      glass.hidden = (style == 5 || style == 8) in both branches.
//   3. per-style parts (below).
//   4. shared tail: speed label = SPPMakeLabel(SPPHeavyFont(speedSize),
//      speedColor), unit label = SPPMakeLabel(SPPRoundedFont(unitSize),
//      unitColor) — colours are per-style (bubblefix): indigo /
//      indigo @ 0.55 generically, style 5's unit = full indigo,
//      styles 6/8 = white / white @ 0.6. Font sizes (speed/unit)
//      per style:
//      0: 34/10, 1: 32/10, 2: 30/10, 3: 33/10, 4: 40/10, 5: 48/12,
//      6: 30/10, 7: 30/10, 8: 24/9. Style 5 adds a white label shadow
//      (radius 4) to both labels; styles 6 and 8 add a light-blue
//      shadow ((0.549, 0.745, 1) @ 0.7, radius 8) to the speed label.
//      Then sign (SPPSignView) and iconView (SPPIconView, shape = 0,
//      image = nil) are added, builtStyle is set and the build is
//      logged "bubble: kieu %ld".
- (void)buildStyle:(NSInteger)style {
    if (style < 0 || style > 8) style = 0;
    for (UIView *sub in [self.subviews copy]) [sub removeFromSuperview];
    for (CALayer *layer in [self.layer.sublayers copy]) {
        [layer removeFromSuperlayer];
    }
    _glass = nil;
    _iconView = nil;
    _sign = nil;
    _flashView = nil;
    _deco = nil;
    _speedLabel = nil;
    _unitLabel = nil;
    _tickLabels = nil;
    _parts = [NSMutableDictionary dictionary];
    _bits = [NSMutableDictionary dictionary];

    UIColor *indigo = [UIColor colorWithRed:0.2901960784313726
        green:0.30980392156862746 blue:0.5019607843137255 alpha:1];

    UIView *flash = [[UIView alloc] init];
    flash.backgroundColor = [UIColor colorWithRed:1
        green:0.35294117647058826 blue:0.37254901960784315 alpha:1];
    flash.alpha = 0;
    flash.userInteractionEnabled = NO;
    _flashView = flash;

    SPPGlassView *glass = [[SPPGlassView alloc] init];
    glass.hidden = (style == 5 || style == 8);
    _glass = glass;
    BOOL flashInGlass = (style == 1 || style == 4 || style == 6 || style == 7);
    if (flashInGlass) {
        [self addSubview:glass];
        [glass addSubview:flash];
    } else {
        [self addSubview:flash];
        [self addSubview:glass];
    }

    double speedSize, unitSize;
    switch (style) {
        case 0: {
            speedSize = 34; unitSize = 10;
            // Conic gradient ring (line width 3) + a shine wedge,
            // both in the glass's layer; paths/frames in renderStyle.
            CAGradientLayer *ring = SPPGradientRing(3.0, YES);
            [glass.layer addSublayer:ring];
            _parts[@"ring"] = ring;
            CAGradientLayer *shine = [CAGradientLayer layer];
            shine.colors = @[
                (id)[UIColor colorWithWhite:1 alpha:0.75].CGColor,
                (id)[UIColor colorWithWhite:1 alpha:0].CGColor];
            shine.masksToBounds = YES;
            [glass.layer addSublayer:shine];
            _parts[@"shine"] = shine;
            break;
        }
        case 1: {
            speedSize = 32; unitSize = 10;
            // Status dot (shown when the app icon is not) + divider bar.
            UIView *dot = [self addBit:@"dot" to:self];
            dot.layer.cornerRadius = 4;
            UIView *bar = [self addBit:@"bar" to:self];
            bar.backgroundColor = [indigo colorWithAlphaComponent:0.18];
            bar.layer.cornerRadius = 0.75;
            break;
        }
        case 2: {
            speedSize = 30; unitSize = 10;
            // Amber "near limit" ring inside the glass.
            [self shapePart:@"nearRing" in:glass.layer
                     stroke:[UIColor colorWithRed:1
                                     green:0.7019607843137254
                                      blue:0.25098039215686274 alpha:1]
                      width:3];
            break;
        }
        case 3: {
            speedSize = 33; unitSize = 10;
            // 270-degree arc gauge: indigo track + linear gradient fill.
            CAShapeLayer *track = [self shapePart:@"track" in:glass.layer
                stroke:[indigo colorWithAlphaComponent:0.12] width:7];
            track.lineCap = kCALineCapRound;
            CAGradientLayer *fill = SPPGradientRing(7.0, NO);
            [glass.layer addSublayer:fill];
            _parts[@"fill"] = fill;
            break;
        }
        case 4: {
            speedSize = 40; unitSize = 10;
            // Big card: diagonal glass fill, a mesh gradient inserted
            // UNDER the fill (index 0), white border, violet shadow.
            glass.fill.startPoint = CGPointMake(0, 0);
            glass.fill.endPoint = CGPointMake(1, 1);
            CAGradientLayer *mesh = [CAGradientLayer layer];
            mesh.startPoint = CGPointMake(1, 0);
            mesh.endPoint = CGPointMake(0, 1);
            mesh.colors = @[
                (id)[UIColor colorWithRed:0.6509803921568628
                    green:0.8666666666666667 blue:0.9921568627450981
                    alpha:0.9].CGColor,
                (id)[UIColor colorWithRed:0.6509803921568628
                    green:0.8666666666666667 blue:0.9921568627450981
                    alpha:0].CGColor,
                (id)[UIColor colorWithRed:0.996078431372549
                    green:0.7686274509803922 blue:0.8470588235294118
                    alpha:0].CGColor,
                (id)[UIColor colorWithRed:0.996078431372549
                    green:0.7686274509803922 blue:0.8470588235294118
                    alpha:0.9].CGColor];
            /* mesh.locations [VERIFIED, final closure 2026-11-08]:
               the constant array @0x3ce30 decoded in full as
               @[@0, @0.5, @0.5, @1] (integer/double/integer constant
               numbers) and is passed to setLocations: @0xf6c8. */
            mesh.locations = @[ @0, @0.5, @0.5, @1 ];
            [glass.fill insertSublayer:mesh atIndex:0];
            _parts[@"mesh"] = mesh;
            glass.fill.borderColor = [UIColor whiteColor].CGColor;
            glass.layer.shadowColor = [UIColor colorWithRed:0.3137254901960784
                green:0.27450980392156865 blue:0.6274509803921569
                alpha:1].CGColor;
            glass.layer.shadowOpacity = 0.28;
            glass.layer.shadowRadius = 12;
            // Progress bar: white track view + gradient fill view.
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
            fillGrad.colors = @[
                (id)[UIColor colorWithRed:0.6078431372549019
                    green:0.5294117647058824 blue:0.9725490196078431
                    alpha:1].CGColor,
                (id)[UIColor colorWithRed:0.36470588235294116
                    green:0.7058823529411765 blue:0.9647058823529412
                    alpha:1].CGColor];
            [fill.layer addSublayer:fillGrad];
            _parts[@"fillGrad"] = fillGrad;
            break;
        }
        case 5: {
            speedSize = 48; unitSize = 12;
            // Bare digits (glass hidden) + a thin progress bar with a
            // soft drop shadow on the track.
            UIView *track = [self addBit:@"track" to:self];
            track.backgroundColor = [UIColor colorWithWhite:1 alpha:0.8];
            track.layer.cornerRadius = 2.5;
            track.layer.shadowColor = [UIColor blackColor].CGColor;
            track.layer.shadowOpacity = 0.15;
            track.layer.shadowRadius = 2;
            track.layer.shadowOffset = CGSizeMake(0, 1);
            UIView *fill = [self addBit:@"fill" to:track];
            fill.layer.cornerRadius = 2.5;
            fill.clipsToBounds = YES;
            CAGradientLayer *fillGrad = [CAGradientLayer layer];
            fillGrad.startPoint = CGPointMake(0, 0.5);
            fillGrad.endPoint = CGPointMake(1, 0.5);
            fillGrad.colors = SPPGradientColors3();
            [fill.layer addSublayer:fillGrad];
            _parts[@"fillGrad"] = fillGrad;
            break;
        }
        case 6: {
            speedSize = 30; unitSize = 10;
            // Dark navy glass, no border/sheen, black shadow; a violet
            // glow outline + a thin (1.5) conic ring in self's layer.
            [glass setTop:[UIColor colorWithRed:0.07058823529411765
                    green:0.0784313725490196 blue:0.11764705882352941
                    alpha:0.82]
                  bottom:[UIColor colorWithRed:0.047058823529411764
                    green:0.05098039215686274 blue:0.0784313725490196
                    alpha:0.86]];
            glass.fill.borderWidth = 0;
            glass.sheen.hidden = YES;
            glass.layer.shadowColor = [UIColor blackColor].CGColor;
            glass.layer.shadowOpacity = 0.35;
            CAShapeLayer *glow = [self shapePart:@"glow" in:self.layer
                stroke:[UIColor colorWithRed:0.6549019607843137
                    green:0.5450980392156862 blue:0.9803921568627451
                    alpha:1] width:1.5];
            glow.shadowColor = [UIColor colorWithRed:0.6549019607843137
                green:0.5450980392156862 blue:0.9803921568627451
                alpha:1].CGColor;
            glow.shadowRadius = 4;
            glow.shadowOpacity = 0.9;
            glow.shadowOffset = CGSizeZero;
            CAGradientLayer *ring = SPPGradientRing(1.5, YES);
            [self.layer addSublayer:ring];
            _parts[@"ring"] = ring;
            break;
        }
        case 7: {
            speedSize = 30; unitSize = 10;
            // Bar-graph ticks: an indigo-tinted strip view whose mask
            // (built in renderStyle) cuts it into bars; gradient fill
            // view inside the strip.
            UIView *ticks = [self addBit:@"ticks" to:self];
            ticks.backgroundColor = [indigo colorWithAlphaComponent:0.16];
            CAShapeLayer *ticksMask = [CAShapeLayer layer];
            ticks.layer.mask = ticksMask;
            _parts[@"ticksMask"] = ticksMask;
            UIView *fill = [self addBit:@"fill" to:ticks];
            fill.clipsToBounds = YES;
            CAGradientLayer *fillGrad = [CAGradientLayer layer];
            fillGrad.startPoint = CGPointMake(0, 0.5);
            fillGrad.endPoint = CGPointMake(1, 0.5);
            fillGrad.colors = SPPGradientColors3();
            [fill.layer addSublayer:fillGrad];
            _parts[@"fillGrad"] = fillGrad;
            break;
        }
        case 8: {
            speedSize = 24; unitSize = 9;
            // Analogue gauge on a "deco" plate (glass hidden): radial
            // face, conic ring, inner circle, red zone arc + limit
            // tick, minor/major tick rings, 9 tick labels, a linear
            // progress arc, needle and hub. Paths in renderStyle.
            UIView *deco = [[UIView alloc] init];
            deco.userInteractionEnabled = NO;
            deco.layer.shadowColor = [UIColor blackColor].CGColor;
            deco.layer.shadowOpacity = 0.35;
            deco.layer.shadowRadius = 8;
            deco.layer.shadowOffset = CGSizeMake(0, 4);
            [self addSubview:deco];
            _deco = deco;
            CAGradientLayer *face = [CAGradientLayer layer];
            face.type = kCAGradientLayerRadial;
            face.colors = @[
                (id)[UIColor colorWithRed:0.16470588235294117
                    green:0.1803921568627451 blue:0.27058823529411763
                    alpha:1].CGColor,
                (id)[UIColor colorWithRed:0.047058823529411764
                    green:0.05098039215686274 blue:0.0784313725490196
                    alpha:1].CGColor];
            face.masksToBounds = YES;
            [deco.layer addSublayer:face];
            _parts[@"face"] = face;
            CAGradientLayer *ring = SPPGradientRing(3.0, YES);
            [deco.layer addSublayer:ring];
            _parts[@"ring"] = ring;
            [self shapePart:@"inner" in:deco.layer
                     stroke:[UIColor colorWithWhite:1 alpha:0.08] width:1.0];
            // Zone/limTick red (bubblefix audit @0x1077c/@0x10824):
            // the binary reuses the prologue's hoisted pair
            // (0.35294, 0.37255) — the over-limit red (255,90,95) —
            // NOT (0.21176, 0.45) as the earlier draft had it.
            CAShapeLayer *zone = [self shapePart:@"zone" in:deco.layer
                stroke:[UIColor colorWithRed:1 green:0.35294117647058826
                                         blue:0.37254901960784315 alpha:0.9] width:3.5];
            zone.lineCap = kCALineCapButt;
            CAShapeLayer *limTick = [self shapePart:@"limTick" in:deco.layer
                stroke:[UIColor colorWithRed:1 green:0.35294117647058826
                                         blue:0.37254901960784315 alpha:1] width:2.5];
            limTick.lineCap = kCALineCapRound;
            CAShapeLayer *minor = [self shapePart:@"minor" in:deco.layer
                stroke:[UIColor colorWithWhite:1 alpha:0.45] width:1.2];
            minor.lineCap = kCALineCapRound;
            CAShapeLayer *major = [self shapePart:@"major" in:deco.layer
                stroke:[UIColor colorWithWhite:1 alpha:0.9] width:2.0];
            major.lineCap = kCALineCapRound;
            NSMutableArray *labels = [NSMutableArray array];
            for (int i = 0; i < 9; i++) {
                UILabel *tick = SPPMakeLabel(SPPRoundedFont(9),
                    [UIColor colorWithWhite:1 alpha:0.85]);
                tick.font = [UIFont systemFontOfSize:9 weight:UIFontWeightBold];
                [deco addSubview:tick];
                [labels addObject:tick];
            }
            _tickLabels = labels;
            CAGradientLayer *prog = SPPGradientRing(3.0, NO);
            prog.startPoint = CGPointMake(0, 1);
            prog.endPoint = CGPointMake(1, 0);
            [deco.layer addSublayer:prog];
            _parts[@"prog"] = prog;
            CAShapeLayer *needle = [self shapePart:@"needle" in:deco.layer
                                            stroke:nil width:0];
            // Needle red (bubblefix audit @0x10b50/@0x10b94):
            // (1, 0.35294, 0.21176) — green is the hoisted 0.35294,
            // blue the fresh 0.21176 const @0x328f0.
            needle.fillColor = [UIColor colorWithRed:1
                green:0.35294117647058826 blue:0.21176470588235294 alpha:1].CGColor;
            needle.shadowColor = [UIColor colorWithRed:1
                green:0.35294117647058826 blue:0.21176470588235294 alpha:1].CGColor;
            needle.shadowRadius = 3;
            needle.shadowOpacity = 0.8;
            needle.shadowOffset = CGSizeZero;
            CAShapeLayer *hub = [self shapePart:@"hub" in:deco.layer
                stroke:[UIColor colorWithWhite:1 alpha:0.85] width:1.5];
            hub.fillColor = [UIColor colorWithRed:0.13725490196078433
                green:0.14901960784313725 blue:0.22745098039215686
                alpha:1].CGColor;
            break;
        }
        default:  // style 0 handled above; unreachable for 1..8
            speedSize = 34; unitSize = 10;
            break;
    }

    // Label base colours (bubblefix audit): generic = indigo /
    // indigo @ 0.55; style 5's unit label is FULL indigo (@0x10d44);
    // the dark styles 6 and 8 build white labels, unit @ 0.6
    // (@0xfa74 regs, @0x1041c slots).
    UIColor *speedColor = indigo;
    UIColor *unitColor = [indigo colorWithAlphaComponent:0.55];
    if (style == 5) {
        unitColor = indigo;
    } else if (style == 6 || style == 8) {
        speedColor = [UIColor whiteColor];
        unitColor = [UIColor colorWithWhite:1 alpha:0.6];
    }
    _speedLabel = SPPMakeLabel(SPPHeavyFont(speedSize), speedColor);
    _unitLabel = SPPMakeLabel(SPPRoundedFont(unitSize), unitColor);
    if (style == 5) {
        SPPApplyLabelShadow(_speedLabel, [UIColor whiteColor], 4);
        SPPApplyLabelShadow(_unitLabel, [UIColor whiteColor], 4);
    }
    if (style == 6 || style == 8) {
        SPPApplyLabelShadow(_speedLabel,
            [UIColor colorWithRed:0.5490196078431373
                            green:0.7450980392156863 blue:1 alpha:0.7], 8);
    }
    [self addSubview:_speedLabel];
    [self addSubview:_unitLabel];
    _sign = [[SPPSignView alloc] init];
    [self addSubview:_sign];
    _iconView = [[SPPIconView alloc] init];
    _iconView.shape = 0;
    [self addSubview:_iconView];
    _iconView.imageView.image = nil;
    _builtStyle = style;
    if (_log) _log([NSString stringWithFormat:@"bubble: kieu %ld",
                                              (long)style]);
}

#pragma mark - Per-frame layout

// Style 8 gauge helpers — the two stack blocks renderStyle builds
// at 0x12820-0x1289c (VERIFIED line-level, item-7 micro-closure):
// block 1 (invoke @0x157dc, signature d16@?0d8) captures the divisor
// 160.0 (stored into the block @0x12858) and computes
// angle(v) = 150 + 240 * min(max(v,0)/160, 1.04) degrees
// (fmaxnm/fdiv/fcsel/fmadd @0x157dc-0x15810; 1.04 @0x32be0,
// 150.0 @0x32be8, 240.0 immediate) — full scale is 160 km/h.
// Block 2 (invoke @0x15814, signature {CGPoint=dd}24@?0d8d16)
// captures the centre 70.0 (@0x12888) and takes (radius, angleDeg)
// — in that order — returning the polar point
// (70 + r*cos, 70 + r*sin) via __sincos_stret @0x15840.
static double SPPGaugeAngle(double v) {
    double r = fmin(fmax(v, 0) / 160.0, 1.04);
    return 150 + 240 * r;
}
static CGPoint SPPGaugePoint(double r, double angleDeg) {
    double rad = angleDeg * M_PI / 180;
    return CGPointMake(70 + r * cos(rad), 70 + r * sin(rad));
}

// -renderStyle @0x120c8 (12,704 bytes) — per-style layout CLOSED
// (closure pass; evidence: disasm/styles/000120c8). Common pipeline:
// state = speedState, sColor = stateColor, ratio = speedRatio;
// speedLabel.text = speed >= 0 ? "%d" : "--", textColor =
// numberColor; unitLabel.text = "km/h"; sign.label.text =
// limit >= 1 ? "%d" : "--"; sign.muted = (limit < 1);
// iconView.hidden = !showIcon; the icon image is only re-assigned
// when it changed. Everything else runs inside a CATransaction with
// actions disabled; the epilogue calls applyColor: (with the speed
// STATE — see the note there), frames the flash view, sets
// outlineRect/outlineCorner, commits, publishes contentSize and
// finally setOverLimitWarning:(state == 2).
- (void)renderStyle {
    NSInteger state = [self speedState];
    UIColor *sColor = [self stateColor];
    double ratio = [self speedRatio];
    UIColor *indigo = [UIColor colorWithRed:0.2901960784313726
        green:0.30980392156862746 blue:0.5019607843137255 alpha:1];
    _speedLabel.text = (_speed >= 0)
        ? [NSString stringWithFormat:@"%d", _speed] : @"--";
    _speedLabel.textColor = [self numberColor];
    _unitLabel.text = @"km/h";
    _sign.label.text = (_limit >= 1)
        ? [NSString stringWithFormat:@"%d", _limit] : @"--";
    _sign.muted = (_limit < 1);
    _iconView.hidden = !_showIcon;
    if (_iconView.imageView.image != _iconImage) {
        _iconView.imageView.image = _iconImage;
    }
    [CATransaction begin];
    [CATransaction setDisableActions:YES];

    CGSize content = CGSizeZero;      // published as contentSize
    UIView *flashRef = nil;           // inset-family flash reference
    switch (_builtStyle) {
        case 0: {
            // Round glass bubble, conic ring + shine wedge.
            _glass.frame = CGRectMake(4, 16, 100, 100);
            [_glass setCorner:50];   // bubblefix @0x13690 (was 34)
            CAGradientLayer *ring = (CAGradientLayer *)_parts[@"ring"];
            UIBezierPath *oval = [UIBezierPath
                bezierPathWithOvalInRect:CGRectMake(1.5, 1.5, 97, 97)];
            SPPFrameMask(ring, oval, CGRectMake(0, 0, 100, 100));
            ring.colors = (state != 0)
                ? @[ (id)sColor.CGColor, (id)sColor.CGColor ]
                : SPPGradientColors5();
            CAGradientLayer *shine = (CAGradientLayer *)_parts[@"shine"];
            shine.frame = CGRectMake(16, 9, 46, 26);
            shine.cornerRadius = 13;
            [self stackNumberAt:52 top:68 - [self stackHeight] / 2 width:84];
            SPPPlaceSquare(_iconView, 11, 107, 22);
            SPPPlaceSquare(_sign, 95, 25, 50);   // bubblefix @0x1467c (was 34)
            content = CGSizeMake(120, 118);
            flashRef = _glass;
            break;
        }
        case 1: {
            // Horizontal strip: [icon|dot] number | bar | sign.
            UIView *dot = [self bit:@"dot"];
            dot.hidden = _showIcon;
            // bubblefix @0x139c8/@0x12e84: the dot takes the state
            // colour when state != 0 and the gradient teal
            // (0.3686, 0.8667, 0.7137) at state 0; its frame is set
            // only on the no-icon path: (10, 26, 8, 8) @0x13a14.
            dot.backgroundColor = (state != 0) ? sColor
                : [UIColor colorWithRed:0.3686274509803922
                                  green:0.8666666666666667
                                   blue:0.7137254901960784 alpha:1];
            double leftPad = _showIcon ? 41 : 24;
            if (_showIcon) {
                SPPPlaceSquare(_iconView, 21, 30, 22);
            } else {
                dot.frame = CGRectMake(10, 26, 8, 8);
            }
            double fitW = MAX(ceil([_speedLabel
                sizeThatFits:CGSizeMake(200, 40)].width), 52);
            [self stackNumberAt:leftPad + fitW / 2
                            top:30 - [self stackHeight] / 2 width:fitW];
            double barX = leftPad + fitW + 10;
            ((UIView *)[self bit:@"bar"]).frame =
                CGRectMake(barX, 14, 1.5, 32);
            double rightEdge = barX + 11.5;
            SPPPlaceSquare(_sign, rightEdge + 22, 30, 44);
            double contentW = rightEdge + 44 + 8;
            _glass.frame = CGRectMake(0, 0, contentW, 60);
            [_glass setCorner:30];
            content = CGSizeMake(contentW, 60);   // VERIFIED @0x13b48
            break;
        }
        case 2: {
            // Glass disc with the sign beside it; amber near-ring.
            _glass.frame = CGRectMake(4, 4, 76, 76);
            [_glass setCorner:38];
            if (state == 2) {
                [_glass setTop:[UIColor colorWithRed:1
                        green:0.35294117647058826 blue:0.37254901960784315
                        alpha:1]
                      bottom:[UIColor colorWithRed:0.9411764705882353
                        green:0.25098039215686274 blue:0.27450980392156865
                        alpha:1]];
            } else {
                [_glass setTop:[UIColor colorWithWhite:1 alpha:0.9]
                      bottom:[UIColor colorWithRed:0.9450980392156862
                        green:0.9411764705882353 blue:0.984313725490196
                        alpha:0.9]];
            }
            CAShapeLayer *nearRing = (CAShapeLayer *)_parts[@"nearRing"];
            nearRing.hidden = (state != 1);
            nearRing.frame = CGRectMake(0, 0, 76, 76);
            nearRing.path = [UIBezierPath
                bezierPathWithOvalInRect:CGRectMake(1.5, 1.5, 73, 73)].CGPath;
            _unitLabel.textColor = (state == 2)
                ? [UIColor whiteColor]
                : [indigo colorWithAlphaComponent:0.55];
            [self stackNumberAt:41 top:41 - [self stackHeight] / 2 width:64];
            SPPPlaceSquare(_iconView, 10, 10, 20);
            SPPPlaceSquare(_sign, 124, 41, 72);
            content = CGSizeMake(160, 80);
            flashRef = _glass;
            break;
        }
        case 3: {
            // 270-degree arc gauge (135 deg -> 405 deg), radius 46.
            _glass.frame = CGRectMake(0, 0, 104, 104);
            [_glass setCorner:52];
            UIBezierPath *arc = [UIBezierPath
                bezierPathWithArcCenter:CGPointMake(52, 52) radius:46
                startAngle:2.356194490192345 endAngle:7.0685834705770345
                clockwise:YES];
            CAShapeLayer *track = (CAShapeLayer *)_parts[@"track"];
            track.path = arc.CGPath;
            SPPFrameMask(track, arc, CGRectMake(0, 0, 104, 104));
            CAGradientLayer *fill = (CAGradientLayer *)_parts[@"fill"];
            fill.colors = (state != 0)
                ? @[ (id)sColor.CGColor, (id)sColor.CGColor ]
                : SPPGradientColors3();
            SPPFrameMask(fill, arc, CGRectMake(0, 0, 104, 104));
            [CATransaction setDisableActions:NO];
            [CATransaction setAnimationDuration:0.6];
            ((CAShapeLayer *)fill.mask).strokeEnd = ratio;
            [CATransaction setDisableActions:YES];
            [self stackNumberAt:52 top:46 - [self stackHeight] / 2 width:80];
            SPPPlaceSquare(_iconView, 10, 12, 20);
            SPPPlaceSquare(_sign, 52, 99, 46);
            content = CGSizeMake(104, 122);
            flashRef = _glass;
            break;
        }
        case 4: {
            // Big 124x124 card: mesh + state-tinted glass, bar below.
            _glass.frame = CGRectMake(0, 0, 124, 124);
            [_glass setCorner:28];
            CAGradientLayer *mesh = (CAGradientLayer *)_parts[@"mesh"];
            mesh.frame = CGRectMake(0, 0, 124, 124);
            mesh.hidden = (state != 0);
            if (state == 1) {
                [_glass setTop:[UIColor colorWithRed:1
                        green:0.8352941176470589 blue:0.5411764705882353
                        alpha:1]
                      bottom:[UIColor colorWithRed:1
                        green:0.7019607843137254 blue:0.25098039215686274
                        alpha:1]];
            } else if (state == 2) {
                // bubblefix @0x127d0 + join @0x14964: the bottom is
                // built at the join from the components carried in
                // (1, 0.30980, 0.33333) — NOT the state-0 bottom.
                [_glass setTop:[UIColor colorWithRed:1
                        green:0.5411764705882353 blue:0.5529411764705883
                        alpha:1]
                      bottom:[UIColor colorWithRed:1
                        green:0.30980392156862746 blue:0.3333333333333333
                        alpha:1]];
            } else {
                [_glass setTop:[UIColor colorWithRed:0.788235294117647
                        green:0.7294117647058823 blue:0.9882352941176471
                        alpha:0.97]
                      bottom:[UIColor colorWithRed:0.6274509803921569
                        green:0.9450980392156862 blue:0.8509803921568627
                        alpha:0.97]];
            }
            _glass.sheen.hidden = (state != 0);
            if (_showIcon) SPPPlaceSquare(_iconView, 23, 23, 22);
            SPPPlaceSquare(_sign, 88, 34, 48);
            _unitLabel.textColor = (state != 0)
                ? [UIColor whiteColor]
                : [indigo colorWithAlphaComponent:0.55];
            double fitW = ceil([_speedLabel
                sizeThatFits:CGSizeMake(200, 50)].width);   // bubblefix @0x14adc (was 34)
            _speedLabel.frame = CGRectMake(12, 59, fitW, 48);
            SPPPlaceUnitRightOf(_unitLabel, _speedLabel);
            UIView *track = [self bit:@"track"];
            track.frame = CGRectMake(12, 106, 100, 6);
            CAGradientLayer *fillGrad = (CAGradientLayer *)_parts[@"fillGrad"];
            fillGrad.frame = CGRectMake(0, 0, 100, 6);
            // bubblefix @0x14a90/@0x14c60 + @0x14c7c: both
            // polarities were inverted in the earlier draft — the
            // gradient shows at state 0, the white fill takes over
            // when near/over the limit.
            fillGrad.hidden = (state != 0);
            UIView *fill = [self bit:@"fill"];
            fill.backgroundColor = (state != 0)
                ? [UIColor whiteColor] : [UIColor clearColor];
            [CATransaction setDisableActions:NO];
            SPPAnimateViewWidth(fill, ratio * track.bounds.size.width, 0.6);
            [CATransaction setDisableActions:YES];
            content = CGSizeMake(124, 124);
            break;
        }
        case 5: {
            // Bare digits + thin bar; sign floats right of the stack.
            double topOff = _showIcon ? 24 : 0;
            if (_showIcon) SPPPlaceSquare(_iconView, 10, 10, 20);
            _unitLabel.textColor = indigo;
            double fitW = ceil([_speedLabel
                sizeThatFits:CGSizeMake(220, 60)].width);
            _speedLabel.frame = CGRectMake(0, topOff, fitW, 52);
            SPPPlaceUnitRightOf(_unitLabel, _speedLabel);
            double contentW = MAX(CGRectGetMaxX(_unitLabel.frame), 92);
            double trackY = topOff + 52 + 3;
            UIView *track = [self bit:@"track"];
            track.frame = CGRectMake(0, trackY, 92, 5);
            CAGradientLayer *fillGrad = (CAGradientLayer *)_parts[@"fillGrad"];
            fillGrad.frame = CGRectMake(0, 0, 92, 5);
            fillGrad.colors = (state != 0)
                ? @[ (id)sColor.CGColor, (id)sColor.CGColor ]
                : SPPGradientColors3();
            [CATransaction setDisableActions:NO];
            SPPAnimateViewWidth([self bit:@"fill"], ratio * 92, 0.6);
            [CATransaction setDisableActions:YES];
            SPPPlaceSquare(_sign, contentW + 28, trackY - 23, 40);
            // bubblefix @0x13c04/@0x13c44: content width =
            // (contentW + 8) + 40 (the sign's size) = contentW + 48;
            // height = trackY + 5 VERIFIED.
            content = CGSizeMake(contentW + 48, trackY + 5);
            // bubblefix @0x13c58: style 5's flash anchor is the
            // SPEED LABEL (fetched into the shared slot at the end
            // of the branch) — inset family, see the epilogue.
            flashRef = _speedLabel;
            break;
        }
        case 6: {
            // Tall dark pill: sign on top, number, optional icon.
            SPPPlaceSquare(_sign, 35, 33, 50);   // bubblefix @0x12524 (was 34)
            [self stackNumberAt:35 top:66 width:62];   // bubblefix @0x12544 (was 70)
            double contentH = 66 + [self stackHeight];
            if (_showIcon) {
                SPPPlaceSquare(_iconView, 35, contentH + 17, 18);
                contentH += 26;
            }
            contentH += 12;
            _glass.frame = CGRectMake(0, 0, 70, contentH);
            [_glass setCorner:35];
            UIBezierPath *ringPath = [UIBezierPath
                bezierPathWithRoundedRect:CGRectMake(0.75, 0.75, 68.5,
                                                     contentH - 1.5)
                              cornerRadius:34.25];
            CAGradientLayer *ring = (CAGradientLayer *)_parts[@"ring"];
            SPPFrameMask(ring, ringPath, CGRectMake(0, 0, 70, contentH));
            ring.colors = (state != 0)
                ? @[ (id)sColor.CGColor, (id)sColor.CGColor ]
                : SPPGradientColors5();
            CAShapeLayer *glow = (CAShapeLayer *)_parts[@"glow"];
            glow.frame = CGRectMake(0, 0, 70, contentH);
            glow.path = ringPath.CGPath;
            UIColor *glowColor = (state == 0)
                ? [UIColor colorWithRed:0.6549019607843137
                    green:0.5450980392156862 blue:0.9803921568627451
                    alpha:1]
                : sColor;
            glow.strokeColor = glowColor.CGColor;
            glow.shadowColor = glowColor.CGColor;
            // (speed-label shadow colour is state-dependent and set
            // in the shared block after the switch — bubblefix.)
            content = CGSizeMake(70, contentH);   // VERIFIED @0x125cc
            break;
        }
        case 7: {
            // Number + bar-graph ticks strip + sign.
            double pad = _showIcon ? 34 : 10;
            if (_showIcon) SPPPlaceSquare(_iconView, 17, 29, 22);
            double fitW = MAX(
                ceil([_speedLabel sizeThatFits:CGSizeMake(200, 40)].width),
                ceil([_unitLabel sizeThatFits:CGSizeMake(200, 20)].width));
            [self stackNumberAt:pad + fitW / 2
                            top:29 - [self stackHeight] / 2 width:fitW];
            double contentW = pad + fitW + 8;
            UIView *ticks = [self bit:@"ticks"];
            ticks.frame = CGRectMake(contentW, 17, 61, 24);
            UIBezierPath *maskPath = [UIBezierPath bezierPath];
            for (double x = 0; x + 5 <= 61.5; x += 8) {
                double h = 14.88 * (1 - (x + 2.5) / 61);
                [maskPath appendPath:[UIBezierPath
                    bezierPathWithRoundedRect:CGRectMake(x, 24 - h, 5, h)
                                  cornerRadius:1.5]];
            }
            CAShapeLayer *ticksMask = (CAShapeLayer *)_parts[@"ticksMask"];
            ticksMask.frame = ticks.bounds;
            ticksMask.path = maskPath.CGPath;
            CAGradientLayer *fillGrad = (CAGradientLayer *)_parts[@"fillGrad"];
            fillGrad.frame = CGRectMake(0, 0, 61, 24);
            if (state == 1) {
                fillGrad.colors = @[
                    (id)[UIColor colorWithRed:1 green:0.8352941176470589
                        blue:0.5411764705882353 alpha:1].CGColor,
                    (id)[UIColor colorWithRed:1 green:0.7019607843137254
                        blue:0.25098039215686274 alpha:1].CGColor];
            } else if (state == 2) {
                fillGrad.colors = @[ (id)sColor.CGColor, (id)sColor.CGColor ];
            } else {
                fillGrad.colors = SPPGradientColors3();
            }
            [CATransaction setDisableActions:NO];
            SPPAnimateViewWidth([self bit:@"fill"], ratio * 61, 0.9);
            [CATransaction setDisableActions:YES];
            SPPPlaceSquare(_sign, contentW + 69 + 25, 29, 50);   // bubblefix @0x14868 (was 34)
            // bubblefix @0x14884: total width = contentW + 69 +
            // sign size 50 + 4.
            double totalW = contentW + 69 + 50 + 4;
            _glass.frame = CGRectMake(0, 0, totalW, 59);
            [_glass setCorner:29];
            content = CGSizeMake(totalW, 59);   // VERIFIED @0x148a4
            break;
        }
        case 8: {
            // Analogue gauge, 140x140 face on the deco plate.
            CAGradientLayer *face = (CAGradientLayer *)_parts[@"face"];
            face.frame = CGRectMake(0, 0, 140, 140);
            face.cornerRadius = 70;
            face.startPoint = CGPointMake(0.5, 0.42);
            face.endPoint = CGPointMake(1.1, 1.02);
            _deco.frame = CGRectMake(0, 0, 140, 140);
            _deco.layer.shadowPath = [UIBezierPath
                bezierPathWithArcCenter:CGPointMake(70, 70) radius:70
                startAngle:0 endAngle:2 * M_PI clockwise:YES].CGPath;
            CAGradientLayer *ring = (CAGradientLayer *)_parts[@"ring"];
            SPPFrameMask(ring, [UIBezierPath
                bezierPathWithArcCenter:CGPointMake(70, 70) radius:67
                startAngle:0 endAngle:2 * M_PI clockwise:YES],
                CGRectMake(0, 0, 140, 140));
            ((CAShapeLayer *)_parts[@"inner"]).path = [UIBezierPath
                bezierPathWithArcCenter:CGPointMake(70, 70) radius:64
                startAngle:0 endAngle:2 * M_PI clockwise:YES].CGPath;
            // Ticks every 10 km/h from 0 to 150; majors every 20.
            // Radii pair @0x32c20 = (57 minor inner, 53 major inner),
            // outer end 61, labels at radius 43.
            UIBezierPath *minorPath = [UIBezierPath bezierPath];
            UIBezierPath *majorPath = [UIBezierPath bezierPath];
            NSInteger labelIdx = 0;
            for (int v = 0; v <= 150; v += 10) {
                double angle = SPPGaugeAngle(v);
                BOOL major = (v % 20 == 0);
                UIBezierPath *p = major ? majorPath : minorPath;
                CGPoint a = SPPGaugePoint(major ? 53 : 57, angle);
                CGPoint b = SPPGaugePoint(61, angle);
                [p moveToPoint:a];
                [p addLineToPoint:b];
                if (major && labelIdx < (NSInteger)_tickLabels.count) {
                    UILabel *tick = _tickLabels[labelIdx++];
                    tick.text = [NSString stringWithFormat:@"%d", v];
                    CGPoint c = SPPGaugePoint(43, angle);
                    tick.frame = CGRectMake(c.x - 12, c.y - 6, 24, 12);
                    tick.hidden = NO;
                }
            }
            for (NSInteger i = labelIdx; i < (NSInteger)_tickLabels.count; i++) {
                ((UILabel *)_tickLabels[i]).hidden = YES;
            }
            ((CAShapeLayer *)_parts[@"minor"]).path = minorPath.CGPath;
            ((CAShapeLayer *)_parts[@"major"]).path = majorPath.CGPath;
            // Red zone from the limit to full scale (160); hidden
            // when the limit is unknown or >= full scale.
            BOOL zoneHidden = (_limit < 1 || _limit >= 160);
            CAShapeLayer *zone = (CAShapeLayer *)_parts[@"zone"];
            CAShapeLayer *limTick = (CAShapeLayer *)_parts[@"limTick"];
            zone.hidden = zoneHidden;
            limTick.hidden = zoneHidden;
            if (!zoneHidden) {
                zone.path = [UIBezierPath
                    bezierPathWithArcCenter:CGPointMake(70, 70) radius:63
                    startAngle:SPPGaugeAngle(_limit) * M_PI / 180
                      endAngle:SPPGaugeAngle(160) * M_PI / 180
                    clockwise:YES].CGPath;
                UIBezierPath *tick = [UIBezierPath bezierPath];
                [tick moveToPoint:SPPGaugePoint(52, SPPGaugeAngle(_limit))];
                [tick addLineToPoint:SPPGaugePoint(65, SPPGaugeAngle(_limit))];
                limTick.path = tick.CGPath;
            }
            CAGradientLayer *prog = (CAGradientLayer *)_parts[@"prog"];
            SPPFrameMask(prog, [UIBezierPath
                bezierPathWithArcCenter:CGPointMake(70, 70) radius:49
                startAngle:2.6179938779914944 endAngle:6.8067840827778845
                clockwise:YES], CGRectMake(0, 0, 140, 140));
            prog.colors = (state != 0)
                ? @[ (id)sColor.CGColor, (id)sColor.CGColor ]
                : SPPGradientColors3();
            CAShapeLayer *needle = (CAShapeLayer *)_parts[@"needle"];
            needle.bounds = CGRectMake(0, 0, 140, 140);
            needle.position = CGPointMake(70, 70);
            UIBezierPath *np = [UIBezierPath bezierPath];
            [np moveToPoint:CGPointMake(59, 67.8)];
            [np addLineToPoint:CGPointMake(117, 70)];
            [np addLineToPoint:CGPointMake(59, 72.2)];
            [np closePath];
            needle.path = np.CGPath;
            ((CAShapeLayer *)_parts[@"hub"]).path = [UIBezierPath
                bezierPathWithArcCenter:CGPointMake(70, 70) radius:7
                startAngle:0 endAngle:2 * M_PI clockwise:YES].CGPath;
            [CATransaction setDisableActions:NO];
            [CATransaction setAnimationDuration:0.6];
            // bubblefix @0x13f5c: the gauge value is the ABSOLUTE
            // speed (bic w21, w0, w0, asr #31); it feeds both the
            // progress strokeEnd (@0x1412c) and the needle rotation.
            double gaugeSpeed = fabs((double)_speed);
            ((CAShapeLayer *)prog.mask).strokeEnd =
                fmin((SPPGaugeAngle(gaugeSpeed) - 150) / 240, 1);
            needle.transform = CATransform3DMakeRotation(
                SPPGaugeAngle(gaugeSpeed) * M_PI / 180, 0, 0, 1);
            [CATransaction setDisableActions:YES];
            _speedLabel.frame = CGRectMake(30, 86, 80, 28);
            _unitLabel.frame = CGRectMake(40, 112, 60, 11);
            // (speed-label shadow colour is state-dependent and set
            // in the shared block after the switch — bubblefix
            // @0x14df0/@0x14e20.)
            SPPPlaceSquare(_iconView, 14, 14, 24);
            SPPPlaceSquare(_sign, 131, 125, 66);
            content = CGSizeMake(164, 158);   // VERIFIED @0x14f68
            flashRef = _deco;
            break;
        }
        default:
            break;
    }

    // Bubblefix: styles 6 and 8 re-apply the speed label's shadow
    // colour on EVERY render, and it is state-dependent (binary
    // merges @0x14d14/@0x14d48 for style 6, @0x14df0/@0x14e20 for
    // style 8): state 0 -> light blue (0.549, 0.745, 1) at alpha
    // 0.7 (style 6) / 0.6 (style 8); states 1/2 -> the state
    // colour at alpha 1.
    if (_builtStyle == 6 || _builtStyle == 8) {
        double shadowAlpha = (_builtStyle == 6) ? 0.7 : 0.6;
        _speedLabel.layer.shadowColor = (state == 0)
            ? [UIColor colorWithRed:0.5490196078431373
                              green:0.7450980392156863
                               blue:1 alpha:shadowAlpha].CGColor
            : sColor.CGColor;
    }

    // Epilogue (0x14de0 / 0x14f7c -> 0x15048..0x15210). NOTE: the
    // render-time applyColor: call passes the speed STATE (0/1/2),
    // not the prefs colour — VERIFIED at both epilogue entries
    // (x2 = saved state). See the closure addendum.
    [self applyColor:state];
    if (flashRef) {
        // Inset family (styles 0, 2, 3, 5, 8 — style 5's ref is
        // the speed label): the flash view spills 6 pt past the
        // ref's frame on every side. Corner (bubblefix @0x14fa0,
        // compare @0x15004/@0x14ff4): 16 when the ref is the speed
        // label (style 5), else half the SMALLER SIDE OF THE REF
        // FRAME — not of the content size.
        _flashView.frame = CGRectInset(flashRef.frame, -6, -6);
        _flashView.layer.cornerRadius =
            (flashRef == _speedLabel) ? 16
                : MIN(flashRef.frame.size.width,
                      flashRef.frame.size.height) / 2;
    } else {
        // Glass-bounds family (styles 1, 4, 6, 7).
        _flashView.frame = _glass.bounds;
        _flashView.layer.cornerRadius = _glass.corner;
    }
    if (_builtStyle == 5) {
        _outlineRect = CGRectMake(0, 0, content.width, content.height);
        _outlineCorner = 16;
    } else if (_builtStyle == 8) {
        _outlineRect = _deco.frame;
        _outlineCorner = _deco.frame.size.width / 2;
    } else {
        _outlineRect = _glass.frame;
        _outlineCorner = _glass.corner;
    }
    [CATransaction commit];
    self.contentSize = content;   // setter, as in the binary @0x15200
    [self setOverLimitWarning:(state == 2)];
}

#pragma mark - Warning animation (agent A, VERIFIED — unchanged)

// -setOverLimitWarning: @0x1148c — VERIFIED (from/to opacity values
// not pinned). ON: flashView pulses (CABasicAnimation "opacity",
// 0.5 s, autoreverses, infinite, easeInEaseOut, key "sppFlash") and
// the sign pulses scale (same timing, key "sppPulse"); the transition
// is logged through the view's log block: "bubble: vuot gioi han ->
// nhay canh bao". OFF: both animations removed, flash reset.
- (void)setOverLimitWarning:(BOOL)on {
    CALayer *flashLayer = _flashView.layer;
    if (on) {
        if ([flashLayer animationForKey:@"sppFlash"] == nil) {
            CABasicAnimation *flash =
                [CABasicAnimation animationWithKeyPath:@"opacity"];
            flash.duration = 0.5;
            flash.autoreverses = YES;
            flash.repeatCount = HUGE_VALF;
            flash.timingFunction = [CAMediaTimingFunction
                functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
            [flashLayer addAnimation:flash forKey:@"sppFlash"];
            _flashView.alpha = 1;
            CABasicAnimation *pulse =
                [CABasicAnimation animationWithKeyPath:@"transform.scale"];
            pulse.duration = 0.5;
            pulse.autoreverses = YES;
            pulse.repeatCount = HUGE_VALF;
            pulse.timingFunction = [CAMediaTimingFunction
                functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
            [_sign.layer addAnimation:pulse forKey:@"sppPulse"];
            if (_log) _log(@"bubble: vuot gioi han -> nhay canh bao");
        }
    } else {
        [flashLayer removeAnimationForKey:@"sppFlash"];
        _flashView.alpha = 0;
        [_sign.layer removeAnimationForKey:@"sppPulse"];
    }
}

#pragma mark - Colours (agent A — unchanged by the closure pass)

// -numberColor @0x117a4 — [VERIFIED line-level, final closure
// 2026-11-08] The full builtStyle x speedState matrix, transcribed
// from the dispatch at 0x117c4-0x11854. Colours:
//   indigo  (74,79,128)   = (0.2901960784313726, 0.30980392156862746,
//                            0.5019607843137255)   @0x11880
//   orange  (217,138,0)   = (0.8509803921568627, 0.5411764705882353, 0)
//                                                      @0x118a4
//   red     (240,50,58)   = (0.9411764705882353, 0.19607843137254902,
//                            0.22745098039215686)   @0x11834
//   amber   (255,213,138) = (1, 0.8352941176470589, 0.5411764705882353)
//                                                      @0x118c4
//   pink    (255,138,141) = (1, 0.5411764705882353, 0.5529411764705883)
//                                                      @0x11810
// Matrix (rows: builtStyle; states 0/1/2):
//   0,1,3,5 and 7 (default):  indigo / orange / red
//   2:                        indigo / orange / white
//   4:                        indigo / white  / white
//   6, 8:                     white  / amber  / pink
// (The earlier draft's grouping {2,4,5,6,8} and its "muted red
// (217,138,141)" were wrong: that cell is orange with blue = 0, and
// (255,138,141) belongs to styles 6/8 state 2.)
- (UIColor *)numberColor {
    NSInteger state = [self speedState];
    NSInteger style = _builtStyle;
    if (style == 6 || style == 8) {
        if (state == 1) {
            return [UIColor colorWithRed:1 green:0.8352941176470589
                        blue:0.5411764705882353 alpha:1];
        }
        if (state == 2) {
            return [UIColor colorWithRed:1 green:0.5411764705882353
                        blue:0.5529411764705883 alpha:1];
        }
        return [UIColor whiteColor];
    }
    if (style == 2) {
        if (state == 1) {
            return [UIColor colorWithRed:0.8509803921568627
                        green:0.5411764705882353 blue:0 alpha:1];
        }
        if (state == 2) return [UIColor whiteColor];
        return [UIColor colorWithRed:0.2901960784313726
                    green:0.30980392156862746 blue:0.5019607843137255
                    alpha:1];
    }
    if (style == 4) {
        if (state >= 1) return [UIColor whiteColor];
        return [UIColor colorWithRed:0.2901960784313726
                    green:0.30980392156862746 blue:0.5019607843137255
                    alpha:1];
    }
    // Styles 0, 1, 3, 5, 7 (and anything else): default row.
    if (state == 1) {
        return [UIColor colorWithRed:0.8509803921568627
                    green:0.5411764705882353 blue:0 alpha:1];
    }
    if (state == 2) {
        return [UIColor colorWithRed:0.9411764705882353
                    green:0.19607843137254902 blue:0.22745098039215686
                    alpha:1];
    }
    return [UIColor colorWithRed:0.2901960784313726
                green:0.30980392156862746 blue:0.5019607843137255
                alpha:1];
}

// -applyColor: @0x118f4 — [VERIFIED line-level, final closure
// 2026-11-08] All branch discriminators resolved. Two different
// values steer the function — do not conflate them:
//   * self.color (the stored SPPPrefs colour index) gates the whole
//     method and indexes both static tables. Outside 1..6 the method
//     returns immediately, changing nothing (jump @0x11940).
//   * the ARGUMENT (colour index from setColor:, or the speed STATE
//     0/1/2 from renderStyle's epilogue) selects the label tints in
//     the style-5 and default branches below.
// Tables: palette @0x32C30 (uint32 0xRRGGBB):
//   1 = (255,255,255) white      4 = (47,143,224) blue
//   2 = (22,24,42) near-black    5 = (22,168,127) teal
//   3 = (124,92,240) violet      6 = (232,85,140) pink
// alpha table @0x32c50 (for the dimmed accent): 1: 0.94, 2: 0.88,
// 3-6: 0.92.
- (void)applyColor:(NSInteger)colorIndex {
    static const uint32_t palette[7] = {
        0x000000, 0xFFFFFF, 0x16182A, 0x7C5CF0, 0x2F8FE0, 0x16A87F,
        0xE8558C,
    };
    static const double accentAlpha[7] = {
        0, 0.94, 0.88, 0.92, 0.92, 0.92, 0.92,
    };
    NSInteger color = self.color;
    if (color < 1 || color > 6) return;
    uint32_t packed = palette[color];
    UIColor *accent = [UIColor
        colorWithRed:((packed >> 16) & 0xFF) / 255.0
               green:((packed >> 8) & 0xFF) / 255.0
                blue:(packed & 0xFF) / 255.0 alpha:1];
    UIColor *accentDim = [accent colorWithAlphaComponent:accentAlpha[color]];
    NSInteger style = _builtStyle;
    if (style == 8) {
        // Only the face gradient takes the accent; colour 1 (white)
        // leaves even that untouched.
        if (color == 1) return;
        CAGradientLayer *face = (CAGradientLayer *)_parts[@"face"];
        face.colors = @[ (id)accent.CGColor, (id)accent.CGColor ];
        return;
    }
    if (style == 5) {
        if (colorIndex == 0) {
            _speedLabel.textColor = accent;
            _speedLabel.layer.shadowColor =
                (color == 1 ? [UIColor blackColor]
                            : [UIColor whiteColor]).CGColor;
        } else {
            _speedLabel.layer.shadowColor = [UIColor whiteColor].CGColor;
        }
        return;
    }
    // Default styles: the glass takes a state/accent tint on both
    // stops and the mesh part is hidden unconditionally.
    UIColor *tint;
    if (colorIndex == 1) {
        tint = [UIColor colorWithRed:1 green:0.7019607843137254
                     blue:0.25098039215686274 alpha:1];   // (255,179,64)
    } else if (colorIndex == 2) {
        tint = [UIColor colorWithRed:1 green:0.35294117647058826
                     blue:0.37254901960784315 alpha:1];   // (255,90,95)
    } else {
        tint = accentDim;
    }
    [_glass setTop:tint bottom:tint];
    ((CALayer *)_parts[@"mesh"]).hidden = YES;
    if (colorIndex <= 0 && color == 1) {
        // Idle state with the white accent: indigo labels.
        _speedLabel.textColor = [UIColor colorWithRed:0.2901960784313726
            green:0.30980392156862746 blue:0.5019607843137255 alpha:1];
        _unitLabel.textColor = [UIColor colorWithRed:0.2901960784313726
            green:0.30980392156862746 blue:0.5019607843137255 alpha:0.55];
        return;
    }
    _speedLabel.textColor = [UIColor whiteColor];
    _unitLabel.textColor = colorIndex >= 1
        ? [UIColor whiteColor]
        : [UIColor colorWithWhite:1 alpha:0.75];
    if (color == 1) return;
    // Non-white accents wash the bar and tick marks white @ 0.28.
    // (The enumerated constant array @0x3ce48 is @[@"bar", @"ticks"].)
    for (NSString *key in @[ @"bar", @"ticks" ]) {
        ((UIView *)[self bit:key]).backgroundColor =
            [UIColor colorWithWhite:1 alpha:0.28];
    }
}

@end
