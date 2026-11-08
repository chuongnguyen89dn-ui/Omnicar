// SPPIconView.m — OmniCarPrefs reconstruction (Prefs-B)
// Bodies VERIFIED (init 0x2ce24, layoutSubviews 0x2d098, setShape: 0x2d088).
#import "SPPIconView.h"
#import <QuartzCore/QuartzCore.h>

@implementation SPPIconView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (!self) return nil;
    self.userInteractionEnabled = NO;
    _imageView = [[UIImageView alloc] init];
    _imageView.layer.masksToBounds = YES;
    _imageView.contentMode = UIViewContentModeScaleAspectFill;
    _imageView.layer.minificationFilter = kCAFilterTrilinear;
    _imageView.layer.borderWidth = 0.75;
    _imageView.layer.borderColor = [UIColor colorWithWhite:1 alpha:0.3].CGColor;
    _imageView.layer.cornerCurve = kCACornerCurveContinuous;
    [self addSubview:_imageView];
    self.layer.shadowColor = [UIColor blackColor].CGColor;
    self.layer.shadowOpacity = 0.4f;
    self.layer.shadowRadius = 2.5;
    self.layer.shadowOffset = CGSizeMake(0, 1.5);
    return self;
}

- (void)setShape:(NSInteger)shape {
    _shape = shape;
    [self setNeedsLayout];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGRect b = self.bounds;
    double radius;
    if (self.shape == 1) radius = MIN(b.size.width, b.size.height) * 0.5;
    else if (self.shape == 2) radius = self.tileCorner;
    else radius = b.size.width * 0.225;
    self.imageView.frame = b;
    self.imageView.layer.cornerRadius = (CGFloat)radius;
    self.imageView.layer.maskedCorners =
        self.shape == 2 ? (CACornerMask)self.tileMask
                        : (kCALayerMinXMinYCorner | kCALayerMaxXMinYCorner |
                           kCALayerMinXMaxYCorner | kCALayerMaxXMaxYCorner);
    self.imageView.layer.borderWidth = self.shape == 2 ? 0 : 0.75;
    if (self.shape == 2) {
        self.layer.shadowOpacity = 0;
        self.layer.shadowPath = nil;
    } else {
        self.layer.shadowPath =
            [UIBezierPath bezierPathWithRoundedRect:b cornerRadius:(CGFloat)radius].CGPath;
    }
}

@end
