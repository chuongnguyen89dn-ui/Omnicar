// OMCHeaderCard.m — reconstructed from disasm/OMCHeaderCard.asm.
// The Root page's header: a glass/gradient card with the app logo, name,
// version, tagline, a status line with a coloured dot, and the master
// UISwitch (wired by OMCRootListController to masterToggled:).
// Purely presentational; exact frames are in the disassembly.

#import "OMCHeaderCard.h"
#import "OMCCommon.h"

@implementation OMCHeaderCard

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (!self) return nil;

    _card = [[UIView alloc] initWithFrame:self.bounds];
    _card.layer.cornerRadius = 20;
    _card.layer.shadowColor = [UIColor blackColor].CGColor;
    _card.layer.shadowOpacity = 0.18f;
    _card.layer.shadowRadius = 16;
    _card.layer.shadowOffset = CGSizeMake(0, 6);
    [self addSubview:_card];

    _clip = [[UIView alloc] initWithFrame:self.bounds];
    _clip.layer.cornerRadius = 20;
    _clip.clipsToBounds = YES;
    [_card addSubview:_clip];

    // Diagonal brand gradient (original hex constants VERIFIED in the
    // disassembly: #B7A6FF / #8FD3FF / #9DF2D8 — APEX V2 retune below to the
    // titanium/graphite family of the GPT design pack).
    _gradient = [CAGradientLayer layer];
    _gradient.colors = @[(__bridge id)OMCColorFromHex(@"#28194D").CGColor,
                         (__bridge id)OMCColorFromHex(@"#1B1138").CGColor,
                         (__bridge id)OMCColorFromHex(@"#100923").CGColor];
    _gradient.startPoint = CGPointMake(0, 0);
    _gradient.endPoint = CGPointMake(1, 1);
    [_clip.layer addSublayer:_gradient];

    _glass = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleSystemUltraThinMaterial]];
    [_clip addSubview:_glass];

    _sheen = [[UIView alloc] initWithFrame:CGRectZero];
    _sheen.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.12];
    [_clip addSubview:_sheen];

    NSBundle *bundle = [NSBundle bundleForClass:[self class]];
    _logo = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"logo"
                                                           inBundle:bundle
                                      compatibleWithTraitCollection:nil]];
    _logo.contentMode = UIViewContentModeScaleAspectFit;
    [_clip addSubview:_logo];

    _nameLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    _nameLabel.text = @"DuoCar";
    _nameLabel.textColor = OMCColorFromHex(@"#F5F0FF");
    _nameLabel.font = [UIFont systemFontOfSize:22 weight:UIFontWeightBold];
    [_clip addSubview:_nameLabel];

    _versionLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    _versionLabel.text = [[bundle infoDictionary] objectForKey:@"CFBundleShortVersionString"] ?: @"1.0.3";
    _versionLabel.font = [UIFont systemFontOfSize:13 weight:UIFontWeightMedium];
    _versionLabel.textColor = OMCColorFromHex(@"#C7B8E4");
    [_clip addSubview:_versionLabel];

    _taglineLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    _taglineLabel.font = [UIFont systemFontOfSize:13];
    _taglineLabel.textColor = OMCColorFromHex(@"#C7B8E4");
    [_clip addSubview:_taglineLabel];

    _dot = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 8, 8)];
    _dot.layer.cornerRadius = 4;
    [_clip addSubview:_dot];

    _statusLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    _statusLabel.textColor = OMCColorFromHex(@"#F5F0FF");
    _statusLabel.font = [UIFont systemFontOfSize:13 weight:UIFontWeightSemibold];
    [_clip addSubview:_statusLabel];

    _toggle = [[UISwitch alloc] initWithFrame:CGRectZero];
    _toggle.onTintColor = OMCSwitchColor();
    [_clip addSubview:_toggle];

    return self;
}

// [VERIFIED call set]
- (void)updateWithTagline:(NSString *)tagline status:(NSString *)status enabled:(BOOL)enabled {
    self.taglineLabel.text = tagline;
    self.statusLabel.text = status;
    [self.toggle setOn:enabled];
    self.dot.backgroundColor = enabled ? OMCColorFromHex(@"#A16EFF") : [UIColor tertiaryLabelColor];
    self.card.layer.shadowOpacity = enabled ? 0.22f : 0.10f;
    [self setNeedsLayout];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGRect bounds = self.bounds;
    UIEdgeInsets margins = self.layoutMargins;
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    self.card.frame = bounds;
    self.clip.frame = bounds;
    self.gradient.frame = bounds;
    self.glass.frame = bounds;
    self.card.layer.shadowPath =
        [UIBezierPath bezierPathWithRoundedRect:bounds cornerRadius:20].CGPath;
    CGFloat x = margins.left + 16;
    self.logo.frame = CGRectMake(x, 18, 44, 44);
    CGFloat textX = CGRectGetMaxX(self.logo.frame) + 12;
    self.nameLabel.frame = CGRectMake(textX, 16, 140, 26);
    self.versionLabel.frame = CGRectMake(textX + [self.nameLabel sizeThatFits:CGSizeZero].width + 6, 21, 60, 18);
    self.taglineLabel.frame = CGRectMake(textX, 44, bounds.size.width - textX - 90, 18);
    self.toggle.frame = CGRectMake(bounds.size.width - margins.right - 67,
                                   (bounds.size.height - 31) / 2, 51, 31);
    self.dot.frame = CGRectMake(x, bounds.size.height - 30, 8, 8);
    self.statusLabel.frame = CGRectMake(x + 14, bounds.size.height - 36, 200, 18);
    self.sheen.frame = CGRectMake(0, 0, bounds.size.width, bounds.size.height / 2);
    [CATransaction commit];
}

@end
