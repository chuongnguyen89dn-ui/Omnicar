// SSStartupViewScenesB.m — StartupScreen-B addendum (2026-11-08)
//
// Line-level reconstruction of the SSStartupView scene/text-builder family
// claimed in CLAIM_B.txt. The original agent's SSStartupView.m carries these
// methods at structural fidelity; this file SUPERSEDES those bodies at
// integration time (the original files are not edited by B).
//
// Fidelity tags per function:
//   [VERIFIED]  transcribed from the arm64 disassembly + constant/string
//               tables read directly from the binary (fat slice offset
//               0x4000, VA == slice file offset).
//   [INFERRED]  structure verified, a named detail guessed — the guess is
//               marked inline.
//   [PARTIAL]   verified skeleton only; body intentionally not written
//               (see StartupScreenB_REPORT.md) — no fake completion.
//
// Ground truth for names: metadata/xref/OmniCarStartupScreen.json.
// Ivar names follow SSStartupScreen.h (original agent).

@class SSStartupView;   // SSStartupScreen.h:73 uses it before its @interface
#import "SSStartupScreen.h"

// OMC core export used by sub_dc18; declared in the OMCCommon deliverable
// (OMCCommon.h) — repeated here so this addendum compiles standalone.
extern NSString *OMCCurrentLanguage(void);

// [integration phase 2; backported to src in phase 3] mechanical fix] Private SSStartupView selectors defined
// in SSStartupView.m and used by the (ScenesB) category below. B's standalone
// syntax gate saw them as warnings; under Theos/ARC they are hard errors
// ("no visible @interface ... declares the selector"), so they are declared
// here — same pattern SSStartupViewBuilders.m uses for its internals.
@interface SSStartupView (ScenesBInternals)
- (UIView *)ss_host;
- (UILabel *)ss_label:(NSString *)text at:(CGPoint)point size:(double)size
               weight:(UIFontWeight)weight color:(UIColor *)color
                 left:(BOOL)left in:(UIView *)container maxWidth:(double)maxWidth;
- (SSFade *)ss_fade:(UIView *)view from:(double)from to:(double)to alpha:(double)alpha;
@end

// ===========================================================================
// C helpers (all in SSStartupView's translation unit in the original)
// ===========================================================================

// sub_d6f0 — [VERIFIED] two packed 0xRRGGBB ints -> @[topColor, bottomColor]
// as CGColors, alpha 1, components / 255.0 (constant @0x28e50).
static NSArray *SSPairColors(uint32_t packedTop, uint32_t packedBottom) {
    UIColor *top = [UIColor colorWithRed:((packedTop >> 16) & 0xFF) / 255.0
                                   green:((packedTop >> 8) & 0xFF) / 255.0
                                    blue:(packedTop & 0xFF) / 255.0 alpha:1.0];
    UIColor *bottom = [UIColor colorWithRed:((packedBottom >> 16) & 0xFF) / 255.0
                                      green:((packedBottom >> 8) & 0xFF) / 255.0
                                       blue:(packedBottom & 0xFF) / 255.0 alpha:1.0];
    return @[(id)top.CGColor, (id)bottom.CGColor];
}

// sub_d4f0 — [VERIFIED] WMO weather code -> category index 0..9.
// Codes 61..86 pass mask 0x0339FC7F (bit code-61) then the int64 jump table
// @0x295f0 (26 entries, idx = code-61):
//   61-67 -> 7, 68-70 -> 0, 71-77 -> 9, 78-79 -> 0, 80-82 -> 7,
//   83-84 -> 0, 85-86 -> 9.  (Table values are authoritative even where the
//   result exceeds the 0..8 range used elsewhere.)
static NSInteger SSWeatherCategory(NSInteger code, BOOL isDay) {
    if (code == 0) return isDay ? 0 : 1;
    if (code == 1 || code == 2) return isDay ? 2 : 3;
    if (code == 3) return 4;
    if (code == 45 || code == 48) return 5;
    if (code >= 51 && code <= 57) return 6;
    if (code >= 95) return 8;
    if (code >= 61 && code <= 86) {
        static const int64_t table[26] = {
            7, 7, 7, 7, 7, 7, 7,   // 61-67
            0, 0, 0,               // 68-70
            9, 9, 9, 9, 9, 9, 9,   // 71-77
            0, 0,                  // 78-79
            7, 7, 7,               // 80-82
            0, 0,                  // 83-84
            9, 9                   // 85-86
        };
        if ((0x0339FC7Full >> (code - 61)) & 1) return table[code - 61];
    }
    return 4;
}

// sub_da28 — [VERIFIED] the scene label factory.
static UILabel *SSSceneLabel(NSString *text) {
    UILabel *label = [UILabel new];
    label.text = text;
    label.textColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;          // 1
    label.numberOfLines = 1;
    label.adjustsFontSizeToFitWidth = YES;
    label.minimumScaleFactor = 0.45;                      // @0x28e60
    label.layer.shadowColor = [UIColor blackColor].CGColor;
    label.layer.shadowOpacity = 0.22f;                    // float @0x29420
    [label setContentCompressionResistancePriority:250 forAxis:UILayoutConstraintAxisHorizontal];
    return label;
}

// sub_f6ac — [VERIFIED] rounded-design system font.
// NOTE: the original agent's SSFont() in SSStartupView.m omits the Rounded
// descriptor step; the binary applies it (fallback = plain font).
static UIFont *SSRoundedFont(double size, double weight) {
    UIFont *font = [UIFont systemFontOfSize:size weight:weight];
    UIFontDescriptor *rounded = [font.fontDescriptor fontDescriptorWithDesign:UIFontDescriptorSystemDesignRounded];
    if (rounded) font = [UIFont fontWithDescriptor:rounded size:size];
    return font;
}

// sub_13e24 — [VERIFIED] nil-safe whitespace trim (non-strings -> @"").
static NSString *SSTrimmed(id value) {
    if ([value isKindOfClass:[NSString class]])
        return [(NSString *)value stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    return @"";
}

// sub_155c8 — [VERIFIED] period greeting, exactly 3 cases, no occasion input.
// NOTE: contradicts the original agent's SSGreetingLine (4 cases incl.
// "Chào buổi trưa" plus occasion cases — none of that is in the binary).
static NSString *SSPeriodGreetingText(NSInteger period) {
    if (period == 0) return OMCTr(@"Chào buổi sáng", @"Good morning");
    if (period == 1) return OMCTr(@"Chào buổi chiều", @"Good afternoon");
    return OMCTr(@"Chào buổi tối", @"Good evening");
}

// sub_db60 — [VERIFIED] "Greeting, Name" or the bare greeting.
static NSString *SSGreetingWithName(NSString *name, NSInteger period) {
    NSString *greeting = SSPeriodGreetingText(period);
    NSString *trimmed = SSTrimmed(name);
    if (trimmed.length) return [NSString stringWithFormat:@"%@, %@", greeting, trimmed];
    return greeting;
}

// sub_dc18 — [VERIFIED] long localised date line, template "EEEEdMMMM",
// locale = OMCCurrentLanguage().
static NSString *SSDateLineText(NSDate *date) {
    NSDateFormatter *formatter = [NSDateFormatter new];
    formatter.locale = [NSLocale localeWithLocaleIdentifier:OMCCurrentLanguage()];
    [formatter setLocalizedDateFormatFromTemplate:@"EEEEdMMMM"];
    return [formatter stringFromDate:date];
}

// sub_13eb8 — [VERIFIED] format-with-name or the plain string.
static NSString *SSNameFormatted(NSString *format, NSString *plain, NSString *name) {
    NSString *trimmed = SSTrimmed(name);
    if (trimmed.length) return [NSString stringWithFormat:format, trimmed];
    return plain;
}

// sub_eb68 — [VERIFIED] WMO code -> SF Symbol name + localised condition
// text.  NOTE: corrects three entries in the original agent's INFERRED
// SSWeatherSymbolName table (marked *):
//   night-clear symbol is "moon.stars.fill" (* not "moon.fill");
//   heavy-rain set is exactly {65, 67, 82};
//   thunderstorm symbol is "cloud.bolt.rain.fill" (* not "cloud.bolt.fill").
static void SSWeatherSymbolAndText(NSInteger code, BOOL isDay,
                                   NSString **outSymbol, NSString **outText) {
    NSString *symbol, *text;
    if (code == 0) {
        symbol = isDay ? @"sun.max.fill" : @"moon.stars.fill";
        text = OMCTr(@"Trời quang", @"Clear");
    } else if (code == 1 || code == 2) {
        symbol = isDay ? @"cloud.sun.fill" : @"cloud.moon.fill";
        text = OMCTr(@"Ít mây", @"Partly cloudy");
    } else if (code == 3) {
        symbol = @"cloud.fill";
        text = OMCTr(@"Nhiều mây", @"Cloudy");
    } else if (code == 45 || code == 48) {
        symbol = @"cloud.fog.fill";
        text = OMCTr(@"Sương mù", @"Fog");
    } else if (code >= 51 && code <= 57) {
        symbol = @"cloud.drizzle.fill";
        text = OMCTr(@"Mưa phùn", @"Drizzle");
    } else if (code == 65 || code == 67 || code == 82) {
        symbol = @"cloud.heavyrain.fill";
        text = OMCTr(@"Mưa to", @"Heavy rain");
    } else if (code == 61 || code == 62 || code == 63 || code == 64 ||
               code == 66 || code == 80 || code == 81) {
        symbol = isDay ? @"cloud.sun.rain.fill" : @"cloud.rain.fill";
        text = OMCTr(@"Có mưa", @"Rain");
    } else if ((code >= 71 && code <= 77) || code == 85 || code == 86) {
        symbol = @"cloud.snow.fill";
        text = OMCTr(@"Có tuyết", @"Snow");
    } else if (code >= 95) {
        symbol = @"cloud.bolt.rain.fill";
        text = OMCTr(@"Dông", @"Thunderstorm");
    } else {
        symbol = @"cloud.fill";
        text = OMCTr(@"Nhiều mây", @"Cloudy");
    }
    if (outSymbol) *outSymbol = symbol;
    if (outText) *outText = text;
}

// sub_edf0 — [VERIFIED] temperature text: nil -> @"--", else an
// NSMeasurement (Celsius) through NSMeasurementFormatter, unitStyle 1
// (medium), number formatter maxFractionDigits 0.
static NSString *SSTemperatureText(NSNumber *number) {
    if (!number) return @"--";
    NSMeasurementFormatter *formatter = [NSMeasurementFormatter new];
    formatter.unitStyle = NSFormattingUnitStyleMedium;   // 1
    NSNumberFormatter *nf = [NSNumberFormatter new];
    nf.maximumFractionDigits = 0;
    formatter.numberFormatter = nf;
    NSMeasurement *m = [[NSMeasurement alloc] initWithDoubleValue:number.doubleValue
                                                               unit:[NSUnitTemperature celsius]];
    return [formatter stringFromMeasurement:m];
}

// sub_12554 — [VERIFIED] radial glow layer: CAGradientLayer type
// kCAGradientLayerRadial, colors [c1, c2], startPoint (0.5, 0.5),
// endPoint (1, 1), frame = circle of `radius` around `center`.
static CAGradientLayer *SSRadialGlowLayer(UIColor *color1, UIColor *color2,
                                          CGPoint center, double radius) {
    CAGradientLayer *layer = [CAGradientLayer layer];
    layer.type = kCAGradientLayerRadial;
    layer.colors = @[(id)color1.CGColor, (id)color2.CGColor];
    layer.startPoint = CGPointMake(0.5, 0.5);
    layer.endPoint = CGPointMake(1, 1);
    layer.frame = CGRectMake(center.x - radius, center.y - radius,
                             radius * 2, radius * 2);
    return layer;
}

// sub_149cc — [VERIFIED] invoke body of the block ss_buildWelcome passes
// around: shape layer for `path` in `host` — frame = host bounds, no fill,
// white stroke, lineWidth max(unit*6, 1.5), round cap/join, glow shadow
// (color @0x29140/@0x28f78, opacity 0.95 float @0x29430, radius unit*15,
// offset zero); added to host.layer and returned.
static CAShapeLayer *SSPathGlowLayer(UIView *host, UIBezierPath *path, double unit) {
    CAShapeLayer *layer = [CAShapeLayer layer];
    layer.frame = host.bounds;
    layer.path = path.CGPath;
    layer.fillColor = NULL;
    layer.strokeColor = [UIColor whiteColor].CGColor;
    layer.lineWidth = MAX(unit * 6, 1.5);
    layer.lineCap = kCALineCapRound;
    layer.lineJoin = kCALineJoinRound;
    layer.shadowColor = [UIColor colorWithRed:0.6274509803921569 green:0.8235294117647058
                                         blue:1.0 alpha:1.0].CGColor;
    layer.shadowOpacity = 0.95f;
    layer.shadowRadius = unit * 15;
    layer.shadowOffset = CGSizeZero;
    [host.layer addSublayer:layer];
    return layer;
}

// sub_159a8 — [VERIFIED math] HSL -> RGB: h wrapped into [0, 360) via
// floor(h/360) (constants @0x291e8 = 360, @0x291f0 = -360),
// C = (1 - |2L - 1|) * S, X = C * (1 - |fmod(h/60, 2) - 1|), sector select
// by h/60, m = L - C/2, components clamped to [0, 1], written to out[0..2].
static void SSHSLToRGB(double h, double s, double l, double out[3]) {
    double hh = h + floor(h / 360.0) * -360.0;
    double c = (1 - fabs(2 * l - 1)) * s;
    double x = c * (1 - fabs(fmod(hh / 60.0, 2) - 1));
    double r, g, b;
    if (hh < 60)       { r = c; g = x; b = 0; }
    else if (hh < 120) { r = x; g = c; b = 0; }
    else if (hh < 180) { r = 0; g = c; b = x; }
    else if (hh < 240) { r = 0; g = x; b = c; }
    else if (hh < 300) { r = x; g = 0; b = c; }
    else               { r = c; g = 0; b = x; }
    double m = l - c / 2;
    out[0] = MIN(MAX(r + m, 0), 1);
    out[1] = MIN(MAX(g + m, 0), 1);
    out[2] = MIN(MAX(b + m, 0), 1);
}

// ===========================================================================
@implementation SSStartupView (ScenesB)

// -[SSStartupView ss_sceneColors] @0xd580 — [VERIFIED] gradient pair for
// the backing CAGradientLayer, switched on _sceneStyle, else on _occasion.
// NOTE: the original agent's body returns two black colors; the binary
// returns the full table below.
- (NSArray *)ss_sceneColors {
    switch (_sceneStyle) {
        case 4:  return SSPairColors(0x05070C, 0x000000);
        case 5:  return SSPairColors(0x020308, 0x06070D);
        case 6:  return SSPairColors(0x020309, 0x070A18);
        case 7:  return SSPairColors(0x01050C, 0x04121E);
        case 8:  return SSPairColors(0x0C1A33, 0x1F3A66);
        case 9:  return SSPairColors(0xEEF0FB, 0xF4F5FB);
        default: break;
    }
    switch (_occasion) {
        case 1:  return SSPairColors(0x5A0006, 0xA3000F);
        case 2:  return SSPairColors(0x1B0B3A, 0x3B1A78);
        case 3:  return SSPairColors(0x04121F, 0x0B2A3D);
        case 4:  return SSPairColors(0x0A0A24, 0x1D1446);
        default: return SSPairColors(0x020A24, 0x0B1D4A);
    }
}

// -[SSStartupView buildGreetingWithDate:period:] @0xd824 — [VERIFIED]
// _stack (vertical, alignment center) of time / greeting / date labels.
- (void)buildGreetingWithDate:(NSDate *)date period:(NSInteger)period {
    _timeLabel = SSSceneLabel([NSDateFormatter localizedStringFromDate:date
                                                             dateStyle:NSDateFormatterNoStyle     // 0
                                                             timeStyle:NSDateFormatterShortStyle]); // 1
    _titleLabel = SSSceneLabel(SSGreetingWithName(self.name, period));
    _dateLabel = SSSceneLabel(SSDateLineText(date));
    _dateLabel.alpha = 0.85;   // @0x28e58
    _stack = [[UIStackView alloc] initWithArrangedSubviews:@[_timeLabel, _titleLabel, _dateLabel]];
    _stack.axis = UILayoutConstraintAxisVertical;         // 1
    _stack.alignment = UIStackViewAlignmentCenter;        // 3
}

// -[SSStartupView buildWeatherWithPeriod:] @0xdcdc — [VERIFIED]
// Layout tree built here (all literals from the dump):
//   _stack (vertical, alignment 3) = [_titleLabel, _row, _updatedLabel]
//   _row (horizontal, alignment 3) = [_iconView, _tempLabel, _card]
//   _card.contentView -> _cardStack (vertical, alignment 1)
//                      = [_condLabel, _rangeLabel, _rainLabel]
// The three card labels get textAlignment 4 (natural) after creation.
// _iconView (ivar table slot 0xcc4 — NOT _logoView @0xccc) carries the
// weather SF Symbol in this style: the dump stores the image view at
// 0xdeec through the 0xcc4 offset load at 0xdee4, and never references
// 0xccc in this method. [Store target corrected fix-round4 strand 2
// (audit-S LP-2): an integration phase stored it in _logoView, which
// hijacked the shared-logo layout/intro steps and left the real logo
// stuck at CGRectZero.]
- (void)buildWeatherWithPeriod:(NSInteger)period {
    NSDictionary *weather = self.weather;
    NSInteger code = [weather[@"code"] integerValue];
    BOOL isDay = [weather[@"isDay"] boolValue];
    NSString *symbol = nil, *condText = nil;
    SSWeatherSymbolAndText(code, isDay, &symbol, &condText);

    _titleLabel = SSSceneLabel(SSGreetingWithName(self.name, period));
    _titleLabel.alpha = 0.92;   // @0x28e68

    UIImageSymbolConfiguration *config =
        [UIImageSymbolConfiguration configurationWithPointSize:44 weight:4];
    config = [config configurationByApplyingConfiguration:
                [UIImageSymbolConfiguration configurationPreferringMulticolor]];
    UIImage *image = [UIImage systemImageNamed:symbol withConfiguration:config];
    if (!image) image = [UIImage systemImageNamed:@"cloud.fill" withConfiguration:config];
    _iconView = [[UIImageView alloc] initWithImage:image];
    _iconView.contentMode = UIViewContentModeScaleAspectFit;   // 1
    _iconView.tintColor = [UIColor whiteColor];
    _iconView.translatesAutoresizingMaskIntoConstraints = NO;
    _iconW = [_iconView.widthAnchor constraintEqualToConstant:30];
    _iconH = [_iconView.heightAnchor constraintEqualToConstant:30];
    [NSLayoutConstraint activateConstraints:@[_iconW, _iconH]];

    _tempLabel = SSSceneLabel(SSTemperatureText(weather[@"temp"]));
    [_tempLabel setContentCompressionResistancePriority:1000
                                                forAxis:UILayoutConstraintAxisHorizontal];
    _condLabel = SSSceneLabel(condText);

    NSMutableArray *rangeParts = [NSMutableArray array];
    if (weather[@"high"]) [rangeParts addObject:[@"↑ " stringByAppendingString:SSTemperatureText(weather[@"high"])]];
    if (weather[@"low"])  [rangeParts addObject:[@"↓ " stringByAppendingString:SSTemperatureText(weather[@"low"])]];
    _rangeLabel = SSSceneLabel([rangeParts componentsJoinedByString:@"   "]);
    _rangeLabel.hidden = (rangeParts.count == 0);

    NSString *rainText = nil;
    if (weather[@"rain"])
        rainText = [NSString stringWithFormat:@"%@ %ld%%",
                    OMCTr(@"Khả năng mưa", @"Chance of rain"),
                    (long)[weather[@"rain"] integerValue]];
    _rainLabel = SSSceneLabel(rainText);
    _rainLabel.hidden = (weather[@"rain"] == nil);
    _rainLabel.alpha = 0.9;   // @0x28e70

    for (UILabel *label in @[_condLabel, _rangeLabel, _rainLabel])
        label.textAlignment = NSTextAlignmentNatural;   // 4, literal in binary

    _cardStack = [[UIStackView alloc] initWithArrangedSubviews:@[_condLabel, _rangeLabel, _rainLabel]];
    _cardStack.axis = UILayoutConstraintAxisVertical;     // 1
    _cardStack.alignment = UIStackViewAlignmentLeading;   // 1

    _card = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:16]];
    _card.clipsToBounds = YES;
    _card.layer.cornerCurve = kCACornerCurveContinuous;
    _card.layer.borderWidth = 0.5;
    _card.layer.borderColor = [UIColor colorWithWhite:1.0 alpha:0.22].CGColor;   // alpha @0x28e78
    _card.contentView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.18];    // alpha @0x28e80
    [_card.contentView addSubview:_cardStack];
    _cardStack.translatesAutoresizingMaskIntoConstraints = NO;
    // The 4 constraints are stored in _cardInsets (the original's NSArray
    // ivar for them — applyUnit subscripts it at table slot 0xd00) before
    // activation. [Store target corrected fix-round3 G/§8F: an integration
    // phase stored them in _stackMaxWidth, but the class dump shows that
    // ivar is a single NSLayoutConstraint — the _stack width cap created
    // in -reload.]
    _cardInsets = @[
        [_cardStack.leadingAnchor constraintEqualToAnchor:_card.contentView.leadingAnchor constant:12],
        [_card.contentView.trailingAnchor constraintEqualToAnchor:_cardStack.trailingAnchor constant:12],
        [_cardStack.topAnchor constraintEqualToAnchor:_card.contentView.topAnchor constant:8],
        [_card.contentView.bottomAnchor constraintEqualToAnchor:_cardStack.bottomAnchor constant:8],
    ];
    [NSLayoutConstraint activateConstraints:_cardInsets];

    _row = [[UIStackView alloc] initWithArrangedSubviews:@[_iconView, _tempLabel, _card]];
    _row.axis = UILayoutConstraintAxisHorizontal;         // 0
    _row.alignment = UIStackViewAlignmentCenter;          // 3

    // "Updated …" line: dateStyle = NOT isDateInToday (1 or 0), timeStyle 1;
    // label hidden whenever the stored date is not an NSDate or formats nil.
    NSString *updatedText = nil;
    BOOL updatedHidden = YES;
    id dateObj = weather[@"date"];
    if ([dateObj isKindOfClass:[NSDate class]]) {
        BOOL today = [[NSCalendar currentCalendar] isDateInToday:dateObj];
        NSString *fmt = [NSDateFormatter localizedStringFromDate:dateObj
                                                       dateStyle:today ? 0 : 1
                                                       timeStyle:1];
        if (fmt) {
            updatedText = [NSString stringWithFormat:OMCTr(@"Cập nhật lúc %@", @"Updated %@"), fmt];
            updatedHidden = NO;
        }
    }
    _updatedLabel = SSSceneLabel(updatedText);
    _updatedLabel.alpha = 0.65;   // @0x28e88
    _updatedLabel.hidden = updatedHidden;

    _stack = [[UIStackView alloc] initWithArrangedSubviews:@[_titleLabel, _row, _updatedLabel]];
    _stack.axis = UILayoutConstraintAxisVertical;         // 1
    _stack.alignment = UIStackViewAlignmentCenter;        // 3
}

// -[SSStartupView ss_gaugeAt:radius:label:unit:max:red:in:] @0x12a98 —
// [VERIFIED] One SSGauge. All geometry scales off _unit ("u" below) and
// the square frame of side radius*2 + 4*lineWidth centered on `center`.
// (sub_12af8 in the wave-1 function list is NOT a separate function — the
// address lies inside this method's body.)
- (SSGauge *)ss_gaugeAt:(CGPoint)center radius:(double)radius label:(NSString *)label
                   unit:(NSString *)unitText max:(double)max red:(double)red
                     in:(UIView *)container {
    double u = _unit;
    double lineWidth = MAX(u * 10, 2);
    double side = radius * 2 + 4 * lineWidth;
    CGRect frame = CGRectMake(center.x - side / 2, center.y - side / 2, side, side);
    CGPoint mid = CGPointMake(side / 2, side / 2);
    // Arc spans 3π/4 (@0x29050) -> 9π/4 (@0x29058), clockwise.
    UIBezierPath *arc = [UIBezierPath bezierPathWithArcCenter:mid radius:radius
                                                   startAngle:2.356194490192345
                                                     endAngle:7.0685834705770345
                                                    clockwise:YES];
    SSGauge *gauge = [SSGauge new];
    gauge.max = max;
    gauge.red = red;
    gauge.shown = -1;

    CAShapeLayer *arcLayer = [CAShapeLayer layer];
    arcLayer.frame = frame;
    arcLayer.path = arc.CGPath;
    arcLayer.fillColor = NULL;
    arcLayer.strokeColor = [UIColor colorWithWhite:1 alpha:0.1].CGColor;   // @0x28ed0
    arcLayer.lineWidth = lineWidth;
    arcLayer.lineCap = kCALineCapRound;
    [container.layer addSublayer:arcLayer];
    gauge.arc = arcLayer;

    CALayer *glow = [CALayer layer];
    glow.frame = frame;
    glow.shadowColor = [UIColor whiteColor].CGColor;
    glow.shadowOpacity = 0.6f;   // float @0x29424
    glow.shadowRadius = u * 8;
    glow.shadowOffset = CGSizeZero;

    CAGradientLayer *fill = [CAGradientLayer layer];
    fill.frame = glow.bounds;
    fill.startPoint = CGPointMake(0, 0.5);
    fill.endPoint = CGPointMake(1, 0.5);
    fill.colors = SSPairColors(0x7FD3FF, 0xFFFFFF);
    CAShapeLayer *mask = [CAShapeLayer layer];
    mask.frame = glow.bounds;
    mask.path = arc.CGPath;
    mask.fillColor = NULL;
    mask.strokeColor = [UIColor blackColor].CGColor;
    mask.lineWidth = lineWidth;
    mask.lineCap = kCALineCapRound;
    mask.strokeEnd = 0;
    fill.mask = mask;
    [glow addSublayer:fill];
    [container.layer addSublayer:glow];
    gauge.fill = fill;

    // 11 ticks between radius-26u and radius-14u, angles stepping
    // (3π/2)/10 (@0x29068); two shape layers: white alpha 0.55 (@0x28f98)
    // and rgb(1, 0.3607843137254902, 0.32941176470588235) alpha 0.9
    // (@0x29070/@0x29078/@0x28e70); tick lineWidth max(u*3, 1).
    // [INFERRED: which of the two paths receives which tick parity.]
    UIBezierPath *ticksA = [UIBezierPath bezierPath];
    UIBezierPath *ticksB = [UIBezierPath bezierPath];
    for (NSInteger i = 0; i < 11; i++) {
        double angle = 2.356194490192345 + i * (4.71238898038469 / 10);
        double sn, cs;
        __sincos(angle, &sn, &cs);   // binary calls __sincos_stret
        CGPoint inner = CGPointMake(mid.x + (radius - 26 * u) * cs,
                                    mid.y + (radius - 26 * u) * sn);
        CGPoint outer = CGPointMake(mid.x + (radius - 14 * u) * cs,
                                    mid.y + (radius - 14 * u) * sn);
        UIBezierPath *path = (i % 2 == 0) ? ticksA : ticksB;
        [path moveToPoint:inner];
        [path addLineToPoint:outer];
    }
    for (UIBezierPath *path in @[ticksA, ticksB]) {
        CAShapeLayer *ticks = [CAShapeLayer layer];
        ticks.frame = frame;
        ticks.path = path.CGPath;
        ticks.fillColor = NULL;
        ticks.lineWidth = MAX(u * 3, 1);
        [container.layer addSublayer:ticks];
    }
    // (stroke colors per layer as in the note above.)

    CAShapeLayer *needle = [CAShapeLayer layer];
    needle.frame = frame;
    UIBezierPath *needlePath = [UIBezierPath bezierPath];
    [needlePath moveToPoint:mid];
    [needlePath addLineToPoint:CGPointMake(mid.x - 30 * u, mid.y)];
    needle.path = needlePath.CGPath;
    UIColor *needleColor = [UIColor colorWithRed:1 green:0.3607843137254902
                                            blue:0.32941176470588235 alpha:1];
    needle.strokeColor = needleColor.CGColor;
    needle.lineWidth = MAX(u * 5, 1.5);
    needle.lineCap = kCALineCapRound;
    needle.shadowColor = needleColor.CGColor;
    needle.shadowOpacity = 1.0f;
    needle.shadowRadius = u * 6;
    needle.shadowOffset = CGSizeZero;
    [container.layer addSublayer:needle];
    gauge.needle = (CALayer *)needle;

    CAShapeLayer *hub = [CAShapeLayer layer];
    hub.frame = frame;
    hub.path = [UIBezierPath bezierPathWithOvalInRect:
                CGRectMake(mid.x - 14 * u, mid.y - 14 * u, 28 * u, 28 * u)].CGPath;
    hub.fillColor = [UIColor colorWithRed:0.06666666666666667 green:0.06666666666666667
                                     blue:0.06666666666666667 alpha:1].CGColor;   // @0x29080
    [container.layer addSublayer:hub];

    UILabel *number = [self ss_label:@"888"
                                  at:CGPointMake(center.x, center.y + radius * 0.45)
                                size:45 weight:UIFontWeightBold color:nil
                                left:NO in:container maxWidth:0];
    number.text = @"0";
    gauge.number = number;
    UILabel *name = [self ss_label:label
                                at:CGPointMake(center.x, center.y + radius * 0.45 + 38 * u)
                              size:20 weight:UIFontWeightSemibold color:nil
                              left:NO in:container maxWidth:red];
    name.alpha = 0.55;
    UILabel *unitLabel = [self ss_label:unitText
                                     at:CGPointMake(center.x, center.y - radius * 0.35)
                                   size:18 weight:UIFontWeightSemibold color:nil
                                   left:NO in:container maxWidth:0];
    unitLabel.alpha = 0.9;
    [_gauges addObject:gauge];
    return gauge;
}

// -[SSStartupView ss_buildEngine] @0x134b8 — [VERIFIED] with two marked
// residues. RPM gauge is created FIRST, speed gauge second; `red` is a
// FRACTION of max (0.8 / 0.9) — ss_setGauge: compares the RAW value
// against gauge.red (raw > red => hot, strict); only arc.strokeEnd
// consumes the clamped fraction (@0x13f60, as corrected by verifier #6 —
// B's §3 note originally said the clamped fraction feeds the hot test).
- (void)ss_buildEngine {
    UIView *host = [self ss_host];
    UIColor *glowColor = [UIColor colorWithRed:0.1568627450980392 green:0.23529411764705882
                                          blue:0.43137254901960786 alpha:0.35];
    CAGradientLayer *backdrop = SSRadialGlowLayer(glowColor, [UIColor clearColor],
                                                  CGPointMake(_sceneSize.width * 0.5,
                                                              _sceneSize.height * 0.5),
                                                  _sceneSize.width * 0.5);
    [host.layer addSublayer:backdrop];

    BOOL metric = [[NSLocale currentLocale] usesMetricSystem];
    double u = _unit;
    [self ss_gaugeAt:CGPointMake(_ox + u * 330, _oy + u * 320) radius:u * 210
               label:OMCTr(@"VÒNG TUA", @"RPM") unit:@"x1000 rpm"
                 max:8 red:0.8 in:host];
    [self ss_gaugeAt:CGPointMake(_ox + u * 1270, _oy + u * 320) radius:u * 210
               label:OMCTr(@"TỐC ĐỘ", @"SPEED") unit:metric ? @"km/h" : @"mph"
                 max:metric ? 220 : 140 red:0.9 in:host];

    // Warning-lamp strip — static table @0x355c0 [VERIFIED, decoded from
    // the constant arrays in __data]: [candidate SF Symbol names, packed
    // RGB]. Entry 3 has NO names and always takes the text fallback.
    static const struct { const char *names[3]; NSUInteger count; uint32_t rgb; } kLamps[6] = {
        {{"fuelpump.fill"}, 1, 0xFFB400},
        {{"minus.plus.batteryblock.fill", "minus.plus.batteryblock", "bolt.fill"}, 3, 0xFF5C54},
        {{"exclamationmark.triangle.fill"}, 1, 0xFFB400},
        {{NULL}, 0, 0xFFB400},
        {{"engine.combustion.fill", "exclamationmark.circle.fill"}, 2, 0xFFB400},
        {{"headlight.high.beam.fill", "light.max"}, 2, 0x50C8FF},
    };
    UIImageSymbolConfiguration *lampConfig =
        [UIImageSymbolConfiguration configurationWithPointSize:MAX(u * 30, 6) weight:7];
    for (NSInteger i = 0; i < 6; i++) {
        uint32_t packed = kLamps[i].rgb;
        UIColor *color = [UIColor colorWithRed:((packed >> 16) & 0xFF) / 255.0
                                         green:((packed >> 8) & 0xFF) / 255.0
                                          blue:(packed & 0xFF) / 255.0 alpha:1.0];
        CGPoint at = CGPointMake(_ox + (600 + 80 * i) * u, _oy + 120 * u);
        UIImage *image = nil;
        for (NSUInteger j = 0; j < kLamps[i].count && !image; j++)
            image = [UIImage systemImageNamed:@(kLamps[i].names[j]) withConfiguration:lampConfig];
        UIView *lamp;
        if (image) {
            UIImageView *iv = [[UIImageView alloc] initWithImage:image];
            iv.tintColor = color;
            iv.contentMode = UIViewContentModeScaleAspectFit;   // 1
            [iv sizeToFit];
            iv.center = at;
            iv.layer.shadowColor = color.CGColor;
            iv.layer.shadowOpacity = 0.7f;   // float @0x2942c
            iv.layer.shadowRadius = u * 5;
            iv.layer.shadowOffset = CGSizeZero;
            lamp = iv;
        } else {
            // Fallback text is the literal @"ABS" in the binary (only
            // reachable for the name-less entry 3).
            lamp = [self ss_label:@"ABS" at:at size:26 weight:UIFontWeightHeavy
                            color:color left:NO in:host maxWidth:0];
        }
        [host addSubview:lamp];
        SSFade *fade = [self ss_fade:lamp from:0 to:1 alpha:1];
        fade.outA = 1.4 + 0.12 * i;   // @0x28e08 + i * @0x290c0
        fade.outB = 1.7 + 0.12 * i;   // @0x290c8 + i * @0x290c0
    }

    // Bottom title + ready line.
    // [INFERRED: exact _ox/_oy pairing of the two label anchor points;
    //  constants 640 / 300 / 390 and sizes are from the dump.]
    NSString *carDisplay = SSTrimmed(self.carName);
    if (!carDisplay.length) carDisplay = @"OmniCar";
    UILabel *title = [self ss_label:carDisplay
                                 at:CGPointMake(_ox + u * 640, _oy + u * 300)
                               size:70 weight:UIFontWeightHeavy color:nil
                               left:NO in:host maxWidth:u * 640];
    SSFade *titleFade = [self ss_fade:title from:2.2 to:2.9 alpha:1];
    titleFade.rise = -10 * u;
    NSString *ready = SSNameFormatted(OMCTr(@"Xe của bạn đã sẵn sàng, %@", @"Your car is ready, %@"),
                                      OMCTr(@"Xe của bạn đã sẵn sàng", @"Your car is ready"),
                                      self.name);
    UILabel *readyLabel = [self ss_label:ready
                                      at:CGPointMake(_ox + u * 640, _oy + u * 390)
                                    size:30 weight:UIFontWeightSemibold color:nil
                                    left:NO in:host maxWidth:0];
    [self ss_fade:readyLabel from:2.6 to:3.3 alpha:1];
}

// -[SSStartupView ss_buildWelcome] @0x14384 — [VERIFIED structure +
// constants; residues marked]. A wave polyline through 11 control points
// from the static table @0x294b0 (transformed by _unit and two basis rows
// @0x29440/@0x29450), drawn as quad curves through successive midpoints;
// SSPathGlowLayer shape layers for the wave and two arcs; a radial glow;
// the period greeting as the single label.
- (void)ss_buildWelcome {
    UIView *host = [self ss_host];
    double u = _unit;
    // [PARTIAL: the 11 CGPoint entries @0x294b0 and the two basis vectors
    //  were not transcribed — see report. The path construction (moveTo
    //  first point, addQuadCurveToPoint:controlPoint: over midpoints,
    //  addLineToPoint: back to the first point) is verified.]
    _flash = [CALayer layer];
    _flash.frame = CGRectMake(0, _oy + u * 423.6, _sceneSize.width, MAX(2 * u, 1));
    _flash.backgroundColor = [UIColor colorWithRed:0.6274509803921569 green:0.8235294117647058
                                              blue:1.0 alpha:1.0].CGColor;
    _flash.opacity = 0;
    [host.layer addSublayer:_flash];
    // Wave + two arc paths are passed through SSPathGlowLayer (sub_149cc);
    // the wave layer's strokeStart/strokeEnd are both set to 0.5, the arc
    // layers start at opacity 0. Their ivars are the CAShapeLayer slots
    // 0x3ad54 / 0x3ad50 in the original layout.
    _horizon = SSRadialGlowLayer([UIColor whiteColor], [UIColor clearColor],
                                 CGPointMake(_ox + u * 1052, _oy + u * 548),
                                 u * 367.6);
    _horizon.opacity = 0;
    [host.layer addSublayer:_horizon];

    NSDate *date = self.date ?: [NSDate date];
    NSString *greeting = SSGreetingWithName(self.name, SSPeriodForDate(date));
    UILabel *label = [self ss_label:greeting
                                 at:CGPointMake(_ox + u * 800, _oy + u * 545)
                               size:44 weight:UIFontWeightBold color:nil
                               left:NO in:host maxWidth:0];
    [self ss_fade:label from:_tempoScale * 2.7 to:_tempoScale * 3.4 alpha:1];
}

// ---------------------------------------------------------------------------
// [PARTIAL — bodies intentionally NOT written here]
// ss_buildSky @0x11124, ss_buildParticles @0x14d50, ss_buildHud @0x15ad0,
// ss_buildBriefing @0x16af8, ss_buildLiquid @0x17bb4, ss_buildFestive
// @0x18af0: B verified each one's call skeleton, literal strings and data
// flow (full tables in StartupScreenB_REPORT.md §5) but did not transcribe
// the bodies line-by-line; writing plausible bodies would violate the
// no-fake-completion rule. The wave-1 "helper" addresses inside their
// address spans (sky 115c8…, briefing 16c0c…, liquid 17c64…, festive
// 199d4…) are basic-block islands of the builders themselves, not
// separate functions.
// ---------------------------------------------------------------------------

@end
