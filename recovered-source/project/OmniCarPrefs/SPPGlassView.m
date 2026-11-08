// SPPGlassView.m — OmniCarPrefs reconstruction (Prefs-B)
// All bodies VERIFIED against the disassembly (init 0x2c6fc,
// setTop:bottom: 0x2ca78, setCorner: 0x2cb5c, layoutSubviews 0x2cb6c).
#import "SPPGlassView.h"
#import "OMCCommon.h"
#import <QuartzCore/QuartzCore.h>

@implementation SPPGlassView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (!self) return nil;
    self.userInteractionEnabled = NO;

    _fill = [CAGradientLayer layer];
    _fill.masksToBounds = YES;
    _fill.borderWidth = 1;
    _fill.borderColor = [UIColor colorWithWhite:1 alpha:0.85].CGColor;
    _fill.cornerCurve = kCACornerCurveContinuous;
    [self.layer addSublayer:_fill];

    _sheen = [CAGradientLayer layer];
    _sheen.colors = @[(id)[UIColor colorWithWhite:1 alpha:0.5].CGColor,
                      (id)[UIColor colorWithWhite:1 alpha:0].CGColor];
    [_fill addSublayer:_sheen];

    // Default glass tint VERIFIED from the constant pool: top is white at
    // alpha 0.9, bottom is (0.945, 0.941, 0.984).
    [self setTop:[UIColor colorWithWhite:1 alpha:0.9]
          bottom:[UIColor colorWithRed:0.945 green:0.941 blue:0.984 alpha:1]];

    self.layer.shadowColor = [UIColor colorWithRed:0.275 green:0.235 blue:0.549 alpha:1].CGColor;
    self.layer.shadowOpacity = 0.22f;
    self.layer.shadowRadius = 10;
    self.layer.shadowOffset = CGSizeMake(0, 4);
    return self;
}

- (void)setTop:(UIColor *)top bottom:(UIColor *)bottom {
    self.fill.colors = @[(id)top.CGColor, (id)bottom.CGColor];
}

- (void)setCorner:(double)corner {
    _corner = corner;
    [self setNeedsLayout];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    CGRect b = self.bounds;
    self.fill.frame = b;
    self.fill.cornerRadius = (CGFloat)self.corner;
    self.sheen.frame = CGRectMake(0, 0, b.size.width, b.size.height * 0.55);
    [CATransaction commit];
    self.layer.shadowPath =
        [UIBezierPath bezierPathWithRoundedRect:b cornerRadius:(CGFloat)self.corner].CGPath;
}

@end
