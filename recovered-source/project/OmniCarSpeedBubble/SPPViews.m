// SPPViews.m — reconstructed from OmniCarSpeedBubble.dylib (arm64).
// Agent A (display side). The three small views used by SPPBubbleView:
//   SPPGlassView : UIView — the frosted-glass plate behind the number
//   SPPIconView  : UIView — the source-app icon tile
//   SPPSignView  : UIView — the round speed-limit sign
// Status: VERIFIED outlines from disassembly; bodies marked INFERRED
// where the dumps were only skimmed (see REPORT_A.md).

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#pragma mark - SPPGlassView (0xd358+)

// VERIFIED: borderWidth 1, border white @ 0.85, continuous corner
// curve, masksToBounds, one fill gradient layer (white 1.0 -> 0.5
// alpha) and one sheen gradient layer, default top/bottom colours
// (1,1,1,~0.9) and (241,240,251) = (0.9450980392156862,
// 0.9411764705882353, 0.984313725490196), layer shadow colour
// (70,60,140) = (0.27450980392156865, 0.23529411764705882,
// 0.5490196078431373), radius 10, offset (0, 4).
@interface SPPGlassView : UIView
// [phase-2 integration; backported to src in phase 3] @property census: the 3 binary properties
// (metadata/raw/OmniCarSpeedBubble/objc.json: fill/sheen T@"CAGradientLayer",&,N;
// corner Td,N). Declared in SPPBubbleView.m's copy of this interface but
// missing here, in the @implementation TU, so no accessors were synthesized.
// -corner/-setCorner: below are custom implementations (VERIFIED in the
// final closure) and are not re-synthesized.
@property (nonatomic, strong) CAGradientLayer *fill;
@property (nonatomic, strong) CAGradientLayer *sheen;
@property (nonatomic) double corner;
- (void)setTop:(UIColor *)top bottom:(UIColor *)bottom;
@end

@implementation SPPGlassView {
    CAGradientLayer *_fill;    // ivar offset 8
    CAGradientLayer *_sheen;   // ivar offset 16
    double _corner;            // ivar offset 24
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (!self) return nil;
    self.userInteractionEnabled = NO;   // INFERRED value
    self.layer.masksToBounds = YES;
    self.layer.borderWidth = 1;
    self.layer.borderColor = [UIColor colorWithWhite:1 alpha:0.85].CGColor;
    if ([self.layer respondsToSelector:@selector(setCornerCurve:)]) {
        self.layer.cornerCurve = kCACornerCurveContinuous;
    }
    _fill = [CAGradientLayer layer];
    _fill.colors = @[
        (id)[UIColor colorWithWhite:1 alpha:1.0].CGColor,
        (id)[UIColor colorWithWhite:1 alpha:0.5].CGColor,
    ];
    [self.layer addSublayer:_fill];
    _sheen = [CAGradientLayer layer];
    [self.layer addSublayer:_sheen];
    [self setTop:[UIColor colorWithRed:1 green:1 blue:1 alpha:0.9]
          bottom:[UIColor colorWithRed:0.9450980392156862
                                 green:0.9411764705882353
                                  blue:0.984313725490196 alpha:1]];
    self.layer.shadowColor = [UIColor colorWithRed:0.27450980392156865
        green:0.23529411764705882 blue:0.5490196078431373 alpha:1].CGColor;
    self.layer.shadowRadius = 10;
    self.layer.shadowOffset = CGSizeMake(0, 4);
    self.layer.shadowOpacity = 1;   // INFERRED (const not pinned)
    return self;
}

// -setTop:bottom: @0xd6d4 — recolours the fill gradient (INFERRED body).
- (void)setTop:(UIColor *)top bottom:(UIColor *)bottom {
    _fill.colors = @[ (id)top.CGColor, (id)bottom.CGColor ];
}

// -setCorner: @0xd7b8 — [VERIFIED, final closure 2026-11-08] The 16-byte
// IMP is ONLY a store to _corner (ivar offset 24, slot @0x431e0) plus a
// tail-call to setNeedsLayout. It does NOT touch layer.cornerRadius —
// the stored value is applied by layoutSubviews. (Supersedes the earlier
// INFERRED body, which set the layer radius directly and never wrote
// _corner, leaving the -corner getter permanently reading 0.)
- (void)setCorner:(double)corner {
    _corner = corner;
    [self setNeedsLayout];
}

// -corner @0xda30 — [VERIFIED] plain ivar load of _corner.
- (double)corner {
    return _corner;
}

// -layoutSubviews @0xd7c8 — [VERIFIED, final closure 2026-11-08] Under a
// CATransaction with actions disabled: fill takes the full bounds and
// the stored corner as its cornerRadius; sheen takes the top 55% of the
// height; afterwards the view layer's shadowPath is rebuilt as the
// rounded-rect path of the bounds with the stored corner.
- (void)layoutSubviews {
    [super layoutSubviews];
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    _fill.frame = self.bounds;
    _fill.cornerRadius = self.corner;
    CGRect b = self.bounds;
    _sheen.frame = CGRectMake(0, 0, b.size.width, b.size.height * 0.55);
    [CATransaction commit];
    self.layer.shadowPath =
        [UIBezierPath bezierPathWithRoundedRect:self.bounds
                                   cornerRadius:self.corner].CGPath;
}
@end

#pragma mark - SPPIconView (0xda80+)

// VERIFIED outline: owns a UIImageView subview, masksToBounds;
// -setShape: selects the tile shape (ivars _shape, _tileCorner,
// _tileMask suggest rounded-rect / circle variants), layoutSubviews
// frames the image view. Bodies INFERRED.
@interface SPPIconView : UIView
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic) NSInteger shape;
// [phase-2 integration; backported to src in phase 3] @property census: tileCorner (Td,N) + tileMask
// (TQ,N) from the binary property list (metadata/raw/OmniCarSpeedBubble/
// objc.json); their ivars already exist in the @implementation block below
// but no accessors were synthesized without these declarations
// (5 UNCLAIMED entries in metadata/COVERAGE_GAPS.md incl. .cxx_destruct).
@property (nonatomic) double tileCorner;
@property (nonatomic) NSUInteger tileMask;
@end

@implementation SPPIconView {
    double _tileCorner;
    NSUInteger _tileMask;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (!self) return nil;
    _imageView = [[UIImageView alloc] init];
    _imageView.contentMode = UIViewContentModeScaleAspectFill;
    [self addSubview:_imageView];
    self.layer.masksToBounds = YES;
    return self;
}

// -setShape: @0xdce4 — INFERRED: 0 = rounded rect (corner from
// _tileCorner), else circle.
- (void)setShape:(NSInteger)shape {
    _shape = shape;
    if (shape == 0) {
        self.layer.cornerRadius = _tileCorner;
    } else {
        self.layer.cornerRadius = MIN(self.bounds.size.width,
                                      self.bounds.size.height) / 2;
    }
}

// -layoutSubviews @0xdcf4 — INFERRED body.
- (void)layoutSubviews {
    [super layoutSubviews];
    _imageView.frame = self.bounds;
}
@end

#pragma mark - SPPSignView (0xe040+)

// VERIFIED outline: the limit sign; owns a UILabel (_label), a _muted
// flag; -applyColors paints the sign (red ring / white face in the
// normal state, greyed when muted — INFERRED appearance), -setMuted:
// reapplies, layoutSubviews centres the label.
@interface SPPSignView : UIView
@property (nonatomic, strong) UILabel *label;
@property (nonatomic) BOOL muted;
- (void)applyColors;
@end

@implementation SPPSignView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (!self) return nil;
    _label = [[UILabel alloc] init];
    _label.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_label];
    [self applyColors];
    return self;
}

// -applyColors @0xe49c — INFERRED body (state colours follow the
// module's sign palette; muted greys the ring and the text).
- (void)applyColors {
    self.backgroundColor = [UIColor whiteColor];
    self.layer.borderWidth = 3;   // INFERRED width
    self.layer.borderColor = (_muted
        ? [UIColor colorWithWhite:0.6 alpha:1]
        : [UIColor colorWithRed:0.9411764705882353 green:0.19607843137254902
                            blue:0.22745098039215686 alpha:1]).CGColor;
    _label.textColor = _muted
        ? [UIColor colorWithWhite:0.55 alpha:1]
        : [UIColor colorWithRed:0.2901960784313726 green:0.30980392156862746
                            blue:0.5019607843137255 alpha:1];
}

// -setMuted: @0xe5dc — INFERRED body.
- (void)setMuted:(BOOL)muted {
    _muted = muted;
    [self applyColors];
}

// -layoutSubviews @0xe664 — INFERRED body: circular sign, label fills.
- (void)layoutSubviews {
    [super layoutSubviews];
    self.layer.cornerRadius = MIN(self.bounds.size.width,
                                  self.bounds.size.height) / 2;
    _label.frame = self.bounds;
}
@end
