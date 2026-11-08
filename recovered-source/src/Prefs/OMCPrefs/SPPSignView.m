// SPPSignView.m — OmniCarPrefs reconstruction (Prefs-B)
// Bodies VERIFIED in structure (init 0x2d3e4, applyColors 0x2d840,
// setMuted: 0x2d980, layoutSubviews 0x2da08); exact RGB triples for the
// sign red / muted grey live in the constant pool and are marked INFERRED
// where the register setup was stripped by the condenser.
#import "SPPSignView.h"
#import <QuartzCore/QuartzCore.h>

// File-static in the binary (sub_2d6bc): rounded-design Heavy font with
// tabular-number feature settings, used for the sign digits.
static UIFont *SPPSignFont(double size) {
    UIFont *base = [UIFont systemFontOfSize:size weight:UIFontWeightHeavy];
    UIFontDescriptor *desc = [base.fontDescriptor fontDescriptorWithDesign:UIFontDescriptorSystemDesignRounded];
    if (!desc) desc = base.fontDescriptor;
    desc = [desc fontDescriptorByAddingAttributes:@{
        UIFontDescriptorFeatureSettingsAttribute: @[@{
            UIFontFeatureTypeIdentifierKey: @(1),        // [INFERRED feature ids]
            UIFontFeatureSelectorIdentifierKey: @(0),
        }],
    }];
    return [UIFont fontWithDescriptor:desc size:size];
}

@implementation SPPSignView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (!self) return nil;
    self.userInteractionEnabled = NO;
    self.backgroundColor = [UIColor whiteColor];
    self.layer.borderColor = [UIColor colorWithRed:0.898 green:0.149 blue:0.176 alpha:1].CGColor; // sign red, VERIFIED
    self.layer.shadowColor = [UIColor blackColor].CGColor;
    self.layer.shadowOpacity = 0.4f;
    self.layer.shadowRadius = 3;
    self.layer.shadowOffset = CGSizeMake(0, 1.5);
    _label = [UILabel new];
    _label.font = SPPSignFont(20);
    _label.textColor = [UIColor colorWithRed:0.078 green:0.078 blue:0.09 alpha:1]; // [INFERRED g/b]
    _label.textAlignment = NSTextAlignmentCenter;
    _label.adjustsFontSizeToFitWidth = YES;
    _label.minimumScaleFactor = 0.6;
    [self addSubview:_label];
    return self;
}

- (void)applyColors {
    if (self.muted) {
        // VERIFIED triples from the constant pool.
        self.backgroundColor = [UIColor colorWithRed:0.471 green:0.486 blue:0.525 alpha:1];
        self.layer.borderColor = [UIColor colorWithRed:0.682 green:0.29 blue:0.737 alpha:1].CGColor; // [INFERRED g]
    } else {
        self.backgroundColor = [UIColor whiteColor];
        self.layer.borderColor = [UIColor colorWithRed:0.898 green:0.149 blue:0.176 alpha:1].CGColor;
    }
    self.label.textColor = self.muted
        ? [UIColor colorWithRed:0.682 green:0.29 blue:0.737 alpha:1] // [INFERRED g]
        : [UIColor colorWithRed:0.078 green:0.078 blue:0.09 alpha:1]; // [INFERRED g/b]
}

- (void)setMuted:(BOOL)muted {
    if (_muted == muted && self.layer.borderColor != NULL) return;
    _muted = muted;
    [self applyColors];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGRect b = self.bounds;
    double h = b.size.height;
    self.layer.cornerRadius = (CGFloat)(h * 0.12);   // VERIFIED factor
    self.layer.borderWidth = (CGFloat)(h * 0.09);   // [INFERRED factor]
    double fontSize = h * (self.label.text.length > 2 ? 0.34 : 0.42); // [INFERRED factors]
    self.label.font = SPPSignFont(fontSize);
    self.label.frame = CGRectInset(b, h * 0.9 * 0.1, 0); // [INFERRED inset]
}

@end
