// OMCSSStyleTileCell.m — OmniCarPrefs reconstruction (Prefs-B)
// Bodies VERIFIED (init 0x3be94, showStyle:chosen:dark: 0x3c458,
// setChosen:dark: 0x3c840). The per-style base colors and SF Symbol
// candidate lists are decoded from the constant arrays at 0x7fc90 /
// 0x7fdb0 in the binary (VERIFIED).
#import "OMCSSStyleTileCell.h"
#import "OMCCommon.h"
#import <QuartzCore/QuartzCore.h>

// SSStyleNameKey lives in OMCStartupScreenController's TU (sub_3c7f0);
// declared in OMCCommon.h as part of the startup-screen helpers.
extern NSString *SSStyleNameKey(NSInteger style);

static NSArray<NSString *> *SSStyleHexes(void) {
    return @[@"#E11D48", @"#7C3AED", @"#F59E0B", @"#0EA5E9", @"#EA580C",
             @"#0D9488", @"#C026D3", @"#16A34A", @"#4F46E5", @"#8B7CFF", @"#475569"];
}
static NSArray<NSArray<NSString *> *> *SSStyleGlyphs(void) {
    return @[@[@"film"],
             @[@"seal.fill", @"seal"],
             @[@"hand.wave.fill", @"hand.wave"],
             @[@"cloud.sun.rain.fill"],
             @[@"gauge.with.dots.needle.67percent", @"speedometer"],
             @[@"car.side.fill", @"car.fill"],
             @[@"sparkles"],
             @[@"scope"],
             @[@"rectangle.grid.2x2.fill"],
             @[@"drop.fill", @"drop"],
             @[@"shuffle"]];
}

@implementation OMCSSStyleTileCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (!self) return nil;
    // Card: 62 pt wide, horizontally centered, near the top of the cell.
    double cardX = round((frame.size.width - 62) * 0.5);   // [INFERRED exact math]
    _card = [[UIView alloc] initWithFrame:CGRectMake(cardX, 10, 62, 62)];
    _card.layer.cornerRadius = 18;
    _card.layer.cornerCurve = kCACornerCurveContinuous;
    _card.layer.shadowPath =
        [UIBezierPath bezierPathWithRoundedRect:_card.bounds cornerRadius:18].CGPath;
    [self.contentView addSubview:_card];

    _fill = [CAGradientLayer layer];
    _fill.frame = _card.bounds;
    _fill.cornerRadius = 18;
    _fill.cornerCurve = kCACornerCurveContinuous;
    _fill.masksToBounds = YES;
    _fill.startPoint = CGPointMake(0, 0);
    _fill.endPoint = CGPointMake(1, 1);
    [_card.layer addSublayer:_fill];

    _glyph = [[UIImageView alloc] initWithFrame:_card.bounds];
    _glyph.contentMode = UIViewContentModeCenter;
    [_card addSubview:_glyph];

    _title = [[UILabel alloc] initWithFrame:CGRectMake(0, 78, frame.size.width, 30)];
    _title.textAlignment = NSTextAlignmentCenter;
    _title.numberOfLines = 2;
    _title.adjustsFontSizeToFitWidth = YES;
    _title.minimumScaleFactor = 0.8;
    _title.lineBreakMode = NSLineBreakByClipping;
    [self.contentView addSubview:_title];
    self.isAccessibilityElement = YES;
    return self;
}

- (void)showStyle:(NSInteger)style chosen:(BOOL)chosen dark:(BOOL)dark {
    NSArray *hexes = SSStyleHexes();
    NSInteger idx = (style < 0 || style >= (NSInteger)hexes.count) ? 0 : style;
    UIColor *base = OMCColorFromHex(hexes[idx]);
    CGFloat h = 0, s = 0, b = 0, a = 0;
    [base getHue:&h saturation:&s brightness:&b alpha:&a];
    UIColor *derived = [UIColor colorWithHue:h saturation:s * 0.75
                                  brightness:MIN(b * 1.15, 1) alpha:1];
    self.styleColors = @[(id)base.CGColor, (id)derived.CGColor];

    UIImageSymbolConfiguration *cfg =
        [UIImageSymbolConfiguration configurationWithPointSize:28 weight:UIImageSymbolWeightSemibold];
    UIImage *glyph = nil;
    if (style >= 0 && style < (NSInteger)SSStyleGlyphs().count) {
        for (NSString *name in SSStyleGlyphs()[style]) {
            glyph = [UIImage systemImageNamed:name withConfiguration:cfg];
            if (glyph) break;
        }
    }
    self.glyph.image = [glyph imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    self.title.text = L(SSStyleNameKey(style));
    self.accessibilityLabel = self.title.text;
    [self setChosen:chosen dark:dark];
}

- (void)setChosen:(BOOL)chosen dark:(BOOL)dark {
    (void)dark;
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    if (chosen) {
        self.fill.colors = @[(id)OMCColorFromHex(@"#8B7CFF").CGColor,
                             (id)OMCColorFromHex(@"#5AB8FF").CGColor];
    } else {
        self.fill.colors = self.styleColors;
    }
    [CATransaction commit];
    self.card.backgroundColor = [UIColor clearColor];
    self.glyph.tintColor = [UIColor whiteColor];
    if (chosen) {
        self.card.layer.shadowColor = OMCColorFromHex(@"#6E78FF").CGColor;
        self.card.layer.shadowOpacity = 0.5f;
        self.card.layer.shadowRadius = 12;
        self.card.layer.shadowOffset = CGSizeMake(0, 5);
    } else {
        self.card.layer.shadowColor = [UIColor colorWithRed:0.275 green:0.235 blue:0.549 alpha:1].CGColor;
        self.card.layer.shadowOpacity = 0.14f;
        self.card.layer.shadowRadius = 5;
        self.card.layer.shadowOffset = CGSizeMake(0, 2);
    }
    self.card.layer.borderWidth = 0.5;
    self.card.layer.borderColor = [UIColor colorWithWhite:1 alpha:0.18].CGColor; // [INFERRED alpha]
    self.card.transform = chosen ? CGAffineTransformMakeScale(1.06, 1.06)
                                 : CGAffineTransformIdentity;
    self.title.font = [UIFont systemFontOfSize:11
                                        weight:chosen ? UIFontWeightSemibold : UIFontWeightMedium];
    self.title.textColor = chosen ? [UIColor labelColor] : [UIColor secondaryLabelColor];
    self.accessibilityTraits = UIAccessibilityTraitButton |
        (chosen ? UIAccessibilityTraitSelected : 0);
}

@end
