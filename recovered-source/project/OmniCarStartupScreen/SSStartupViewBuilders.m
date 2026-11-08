// SSStartupViewBuilders.m — StartupScreen CLOSURE addendum (2026-11-08)
//
// Line-level reconstruction of the six scene builders that wave B left at
// PARTIAL (skeletons + literal strings only):
//   ss_buildSky       @0x11124    ss_buildHud       @0x15ad0
//   ss_buildParticles @0x14d50    ss_buildBriefing  @0x16af8
//   ss_buildLiquid    @0x17bb4    ss_buildFestive   @0x18af0
// plus the default-HUD-items builder sub_16544 (a separate C function inside
// the ss_buildHud span) and the image-render helper sub_1ac0c with its two
// drawing blocks used here (rain droplet @0x1ad48, Tết flower @0x1ae44).
//
// This file SUPERSEDES the structural bodies for these six methods in
// SSStartupView.m at integration time (same pattern as
// SSStartupViewScenesB.m). The original files are not edited here.
//
// Fidelity: every constant, color, count and string below was read from the
// arm64 instruction stream / constant tables of
// OmniCarStartupScreen.dylib via the calibrated resolver
// (verify/macho_truth.py); own dumps in disasm/builders/. Items that remain
// less than fully determined are tagged [INFERRED] inline and listed in the
// addendum to StartupScreenB_REPORT.md. Nothing in this file is a guess
// dressed as code: the only structural liberty taken is factoring the
// festive title/subtitle tail (shared machine code at 0x19d6c-0x19f00,
// entered from five switch arms) into one private method.
//
// Ground truth for names: metadata/xref/OmniCarStartupScreen.json.
// Ivar names follow SSStartupScreen.h (original agent).

@class SSStartupView;   // SSStartupScreen.h:73 uses it before its @interface
#import "SSStartupScreen.h"
#import <math.h>
#import <string.h>

// OMC core export used by SSDateLineText; declared in the OMCCommon
// deliverable (OMCCommon.h) — repeated here so this file compiles standalone.
extern NSString *OMCCurrentLanguage(void);

// ===========================================================================
// Mote record — the 56-byte struct passed BY VALUE as the first argument of
// ss_addMote:layer:to: (type encoding {?=qdddddd}: int64 kind + 6 doubles).
// The class extension in SSStartupView.m declares a WRONG inferred signature
// for ss_addMote ("(CALayer *)layer to:(UIView *)container"); the real
// selector is ss_addMote:layer:to: with this record first and a CALayer as
// the `to:` container. Field meaning is per-kind (see each builder).
// ===========================================================================
typedef struct {
    int64_t kind;
    double f1, f2, f3, f4, f5, f6;
} SSMoteRecord;

@interface SSStartupView (BuildersInternals)
- (UIView *)ss_host;
- (void)ss_addCanvas;
- (UILabel *)ss_label:(NSString *)text at:(CGPoint)point size:(double)size
               weight:(UIFontWeight)weight color:(UIColor *)color
                 left:(BOOL)left in:(UIView *)container maxWidth:(double)maxWidth;
- (SSFade *)ss_fade:(UIView *)view from:(double)from to:(double)to alpha:(double)alpha;
- (void)ss_addMote:(SSMoteRecord)record layer:(CALayer *)layer to:(CALayer *)container;
- (void)ss_festiveLabelsWithTitle:(NSString *)title subtitle:(NSString *)subtitle
                       titleColor:(UIColor *)titleColor subtitleColor:(UIColor *)subtitleColor
                           titleY:(double)titleY titleSize:(double)titleSize
                       subtitleY:(double)subtitleY subtitleSize:(double)subtitleSize;
@end

// ===========================================================================
// C helpers shared with the rest of SSStartupView's translation unit.
// The file-static helpers of SSStartupViewScenesB.m are duplicated here
// verbatim (they are TU-local in the original binary too); integration
// de-duplicates if the files are ever merged.
// ===========================================================================

// arc4random_uniform(1000000) / 1e6 — the binary's only randomness source,
// always in this exact shape (ucvtf, optional scale, /1e6, optional offset).
static double SSRand01(void) {
    return arc4random_uniform(1000000) / 1000000.0;
}

// sub_d4f0 — [VERIFIED] WMO weather code -> category index 0..9.
// (Copy of the ScenesB helper; see that file for the jump-table provenance.)
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

// sub_da28 — [VERIFIED] the scene label factory. (Copy of the ScenesB helper.)
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

// sub_f6ac — [VERIFIED] rounded-design system font. (Copy of the ScenesB helper.)
static UIFont *SSRoundedFont(double size, double weight) {
    UIFont *font = [UIFont systemFontOfSize:size weight:weight];
    UIFontDescriptor *rounded = [font.fontDescriptor fontDescriptorWithDesign:UIFontDescriptorSystemDesignRounded];
    if (rounded) font = [UIFont fontWithDescriptor:rounded size:size];
    return font;
}

// sub_13e24 — [VERIFIED] nil-safe whitespace trim (non-strings -> @"").
// (Copy of the ScenesB helper.)
static NSString *SSTrimmed(id value) {
    if ([value isKindOfClass:[NSString class]])
        return [(NSString *)value stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    return @"";
}

// sub_155c8 — [VERIFIED] period greeting, exactly 3 cases, no occasion input.
// (Copy of the ScenesB helper.)
static NSString *SSPeriodGreetingText(NSInteger period) {
    if (period == 0) return OMCTr(@"Chào buổi sáng", @"Good morning");
    if (period == 1) return OMCTr(@"Chào buổi chiều", @"Good afternoon");
    return OMCTr(@"Chào buổi tối", @"Good evening");
}

// sub_db60 — [VERIFIED] "Greeting, Name" or the bare greeting.
// (Copy of the ScenesB helper.)
static NSString *SSGreetingWithName(NSString *name, NSInteger period) {
    NSString *greeting = SSPeriodGreetingText(period);
    NSString *trimmed = SSTrimmed(name);
    if (trimmed.length) return [NSString stringWithFormat:@"%@, %@", greeting, trimmed];
    return greeting;
}

// sub_dc18 — [VERIFIED] long localised date line, template "EEEEdMMMM",
// locale = OMCCurrentLanguage(). (Copy of the ScenesB helper.)
static NSString *SSDateLineText(NSDate *date) {
    NSDateFormatter *formatter = [NSDateFormatter new];
    formatter.locale = [NSLocale localeWithLocaleIdentifier:OMCCurrentLanguage()];
    [formatter setLocalizedDateFormatFromTemplate:@"EEEEdMMMM"];
    return [formatter stringFromDate:date];
}

// sub_13eb8 — [VERIFIED] format-with-name or the plain string.
// (Copy of the ScenesB helper.)
static NSString *SSNameFormatted(NSString *format, NSString *plain, NSString *name) {
    NSString *trimmed = SSTrimmed(name);
    if (trimmed.length) return [NSString stringWithFormat:format, trimmed];
    return plain;
}

// sub_eb68 — [VERIFIED] WMO code -> SF Symbol name + localised condition
// text. (Copy of the ScenesB helper; see that file for the entry-by-entry
// corrections against the original agent's table.)
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
// (Copy of the ScenesB helper.)
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
// (Copy of the ScenesB helper.)
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

// sub_159a8 — [VERIFIED math] HSL -> RGB (h in degrees).
// (Copy of the ScenesB helper.)
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
// sub_1ac0c — [VERIFIED] render a drawing block into a UIImage:
// UIGraphicsImageRenderer with the preferred format, opaque = NO.
// (SSSplash-side helper; reconstructed here because three of the six
// builders call it. The caller block receives the renderer's CGContext.)
// ===========================================================================
static UIImage *SSRenderedImage(CGSize size, void (^draw)(CGContextRef ctx)) {
    UIGraphicsImageRendererFormat *format = [UIGraphicsImageRendererFormat preferredFormat];
    format.opaque = NO;
    UIGraphicsImageRenderer *renderer = [[UIGraphicsImageRenderer alloc] initWithSize:size format:format];
    return [renderer imageWithActions:^(UIGraphicsImageRendererContext *rendererContext) {
        draw(rendererContext.CGContext);
    }];
}

// Global block @0x30c58 (invoke @0x1ad48) — [VERIFIED] the rain droplet
// sprite: the (3, 40) canvas is clipped to its ellipse and filled with a
// radial gradient (white 0.75 -> blue-grey 0.15), centres (11, 14) r0 ->
// (16, 20) r22, kCGGradientDrawsAfterEndLocation (options 2).
static UIImage *SSRainDropImage(void) {
    return SSRenderedImage(CGSizeMake(3, 40), ^(CGContextRef ctx) {
        CGContextAddEllipseInRect(ctx, CGRectMake(0, 0, 3, 40));
        CGContextClip(ctx);
        CGFloat components[8] = { 1, 1, 1, 0.75,
                                  0.7058823529411765, 0.7843137254901961, 0.8627450980392157, 0.15 };
        CGFloat locations[2] = { 0, 1 };
        CGColorSpaceRef space = CGColorSpaceCreateDeviceRGB();
        CGGradientRef gradient = CGGradientCreateWithColorComponents(space, components, locations, 2);
        CGContextDrawRadialGradient(ctx, gradient, CGPointMake(11, 14), 0,
                                    CGPointMake(16, 20), 22, kCGGradientDrawsAfterEndLocation);
        CGGradientRelease(gradient);
        CGColorSpaceRelease(space);
    });
}

// Global block @0x30c78 (invoke @0x1ae44) — [VERIFIED] the Tết flower
// sprite (48x48): five gold petals (ellipse (-7, -22, 14, 22), rotated
// 72 degrees = 1.2566370614359172 rad per petal around the centre) plus a
// red centre dot (ellipse (-4.5, -4.5, 9, 9)).
static UIImage *SSFlowerImage(void) {
    return SSRenderedImage(CGSizeMake(48, 48), ^(CGContextRef ctx) {
        CGContextTranslateCTM(ctx, 24, 24);
        CGContextSetFillColorWithColor(ctx, [UIColor colorWithRed:1 green:0.8313725490196079
                                                               blue:0.23137254901960785 alpha:1].CGColor);
        for (NSInteger i = 0; i < 5; i++) {
            CGContextRotateCTM(ctx, 1.2566370614359172);
            CGContextFillEllipseInRect(ctx, CGRectMake(-7, -22, 14, 22));
        }
        CGContextSetFillColorWithColor(ctx, [UIColor colorWithRed:0.9098039215686274 green:0.34901960784313724
                                                               blue:0.047058823529411764 alpha:1].CGColor);
        CGContextFillEllipseInRect(ctx, CGRectMake(-4.5, -4.5, 9, 9));
    });
}

// sub_16544 — [VERIFIED] default HUD checklist used when self.hud is empty.
// NOTE: the binary calls SSTrimmed(carName) twice (length test, then the
// value); transcribed as-is.
static NSArray *SSDefaultHudItems(NSString *carName) {
    NSString *name = SSTrimmed(carName).length ? SSTrimmed(carName) : @"OmniCar";
    return @[
        @{ @"text": OMCTr(@"Kết nối CarPlay", @"CarPlay connected"), @"ok": @YES },
        @{ @"text": OMCTr(@"Pin iPhone 82% · đang sạc", @"iPhone battery 82% · charging"), @"ok": @YES },
        @{ @"text": OMCTr(@"Nhiệt độ máy: ổn", @"Phone temperature: OK"), @"ok": @YES },
        @{ @"text": OMCTr(@"Chế độ nhẹ: tự động", @"Lite mode: auto"), @"ok": @YES },
        @{ @"text": [NSString stringWithFormat:OMCTr(@"Hồ sơ xe: %@", @"Car profile: %@"), name], @"ok": @YES },
    ];
}

@implementation SSStartupView (Builders)

// ---------------------------------------------------------------------------
// Scene 3: Sky — 0x11124 [VERIFIED line-level]
// Two dispatches on _sky (the WMO-derived sky code): the first, on
// (_sky & ~2), builds the day sun / night stars backdrop; the second, on
// the full _sky, adds the weather layer (clouds / fog / rain / lightning /
// snow). Mote record fields per kind (read back by ss_applyMotes):
//   kind 0 rain:  { x, y, rand, len, 0, 0 }
//   kind 1 stars: { 0, 0, 0, radius, 0, phase }
//   kind 2 fog:   { x, y, speed, 0, 0, 0 }
//   kind 3 cloud: { x, y, speed, 0, width, 0 }
//   kind 4 snow:  { x, y, speed, radius, 0, phase }
// ---------------------------------------------------------------------------
- (void)ss_buildSky {
    double W = _sceneSize.width, H = _sceneSize.height;
    UIView *host = [self ss_host];
    CALayer *hostLayer = host.layer;
    BOOL isDay = [self.weather[@"isDay"] boolValue];

    NSInteger masked = _sky & ~2;
    if (masked == 0) {
        // Day (_sky 0 or 2): sun disc + 12 rays + warm glow.
        CGPoint sun = CGPointMake(_ox + 1340 * _k, _oy + 150 * _k);
        _rays = [CALayer layer];
        _rays.bounds = CGRectZero;
        _rays.position = sun;
        for (NSInteger i = 1; i < 13; i++) {
            CALayer *ray = [CALayer layer];
            ray.backgroundColor = [UIColor colorWithRed:1 green:0.9411764705882353
                                                   blue:0.7058823529411765 alpha:0.18].CGColor;
            ray.anchorPoint = CGPointMake(0, 0.5);
            ray.bounds = CGRectMake(0, 0, 520 * _k, 28 * _k);
            ray.position = CGPointZero;
            ray.transform = CATransform3DMakeRotation(i * M_PI / 6, 0, 0, 1);
            [_rays addSublayer:ray];
        }
        [hostLayer addSublayer:_rays];
        [hostLayer addSublayer:SSRadialGlowLayer(
            [UIColor colorWithRed:1 green:0.9803921568627451 blue:0.8627450980392157 alpha:1],
            [UIColor colorWithRed:1 green:0.8627450980392157 blue:0.47058823529411764 alpha:0],
            sun, 180 * _k)];
    } else if (masked == 1) {
        // Night (_sky 1 or 3): 110 twinkling stars + moon glow.
        for (NSInteger i = 0; i < 110; i++) {
            double radius = MAX(_k * (0.6 + 1.4 * SSRand01()), 0.5);
            CALayer *star = [CALayer layer];
            star.backgroundColor = [UIColor whiteColor].CGColor;
            star.bounds = CGRectMake(0, 0, 2 * radius, 2 * radius);
            star.cornerRadius = radius;
            star.position = CGPointMake(W * SSRand01(), 0.7 * H * SSRand01());
            SSMoteRecord rec = { 1, 0, 0, 0, radius, 0, 6 * SSRand01() };
            [self ss_addMote:rec layer:star to:hostLayer];
        }
        [hostLayer addSublayer:SSRadialGlowLayer(
            [UIColor colorWithRed:1 green:0.9019607843137255 blue:0.95 alpha:1],
            [UIColor colorWithRed:1 green:1 blue:0.9019607843137255 alpha:0],
            CGPointMake(_ox + 1340 * _k, _oy + 140 * _k), 120 * _k)];
    }

    switch (_sky) {
        case 2: case 3: case 4: {
            // Clouds (5 when _sky == 4, else 3): SF-Symbol cloud images
            // re-rendered through sub_1ac0c, drifting as kind-3 motes.
            UIColor *tint = isDay ? [UIColor whiteColor]
                                  : [UIColor colorWithRed:0.7058823529411765 green:0.7450980392156863
                                                     blue:0.8235294117647058 alpha:1];
            UIImageSymbolConfiguration *config =
                [UIImageSymbolConfiguration configurationWithPointSize:120.0];
            UIImage *image = [UIImage systemImageNamed:@"cloud.fill" withConfiguration:config];
            UIImage *tinted = [image imageWithTintColor:tint renderingMode:UIImageRenderingModeAlwaysOriginal];
            if (tinted) {
                UIImage *processed = SSRenderedImage(tinted.size, ^(CGContextRef ctx) {
                    (void)ctx;   // drawInRect targets the renderer's context
                    [tinted drawInRect:CGRectMake(0, 0, tinted.size.width, tinted.size.height)];
                });
                NSInteger count = (_sky == 4) ? 5 : 3;
                for (NSInteger i = 0; i < count; i++) {
                    double cloudW = _k * (260 + 100 * SSRand01());
                    double height = cloudW * processed.size.height / MAX(processed.size.width, 1);
                    CALayer *cloud = [CALayer layer];
                    cloud.contents = (id)processed.CGImage;
                    cloud.contentsGravity = kCAGravityResizeAspect;
                    cloud.bounds = CGRectMake(0, 0, cloudW, height);
                    cloud.opacity = (float)(0.35 + (double)arc4random_uniform(1000000) / 4.0 / 1000000.0);
                    double y = H * (0.1 + 0.4 * SSRand01());
                    cloud.position = CGPointMake(0, y);
                    SSMoteRecord rec = { 3, (W + cloudW) * SSRand01(), y,
                                         _k * (8 + 14 * SSRand01()), 0, cloudW, 0 };
                    [self ss_addMote:rec layer:cloud to:hostLayer];
                }
            }
            break;
        }
        case 5: {
            // Fog: 6 radial-gradient bands drifting slowly (kind 2).
            for (double band = 120; band != 600; band += 80) {
                CAGradientLayer *fog = [CAGradientLayer layer];
                fog.type = kCAGradientLayerRadial;
                fog.colors = @[(id)[UIColor colorWithRed:1 green:1 blue:1 alpha:0.3].CGColor,
                               (id)[UIColor colorWithRed:1 green:1 blue:1 alpha:0.14].CGColor,
                               (id)[UIColor colorWithRed:1 green:1 blue:1 alpha:0].CGColor];
                fog.locations = @[@0, @0.6, @1];   // constant array @0x354a0
                fog.startPoint = CGPointMake(0.5, 0.5);
                fog.endPoint = CGPointMake(1, 1);
                fog.bounds = CGRectMake(0, 0, 840 * _k, 110 * _k);
                SSMoteRecord rec = { 2, W * SSRand01(), _oy + band * _k,
                                     _k * 3 * (20 + 40 * SSRand01()), 0, 0, 0 };
                [self ss_addMote:rec layer:fog to:hostLayer];
            }
            break;
        }
        case 6: case 7: case 8: {
            if (_sky == 8) {
                // Thunderstorm flash plane (opacity driven by apply).
                _lightning = [CALayer layer];
                _lightning.frame = _scene.bounds;
                _lightning.backgroundColor = [UIColor colorWithRed:0.8666666666666667
                                                              green:0.9019607843137255 blue:1 alpha:1].CGColor;
                _lightning.opacity = 0;
                [hostLayer addSublayer:_lightning];
            }
            // Rain on glass: droplet motes (kind 0) fall over a dark pane;
            // the wet mask + wiper clear them (apply side).
            _glass = [[UIView alloc] initWithFrame:self.bounds];
            _glass.userInteractionEnabled = NO;
            [self addSubview:_glass];
            CALayer *pane = [CALayer layer];
            pane.frame = _glass.bounds;
            CALayer *shade = [CALayer layer];
            shade.frame = pane.bounds;
            shade.backgroundColor = [UIColor colorWithRed:0.11764705882352941 green:0.1568627450980392
                                                     blue:0.21568627450980393 alpha:0.55].CGColor;
            [pane addSublayer:shade];
            [_glass.layer addSublayer:pane];
            UIImage *drop = SSRainDropImage();
            NSInteger count = (_sky == 6) ? 70 : 120;
            for (NSInteger i = 0; i < count; i++) {
                double len = _k * (3 + 6 * SSRand01());
                CALayer *dropLayer = [CALayer layer];
                dropLayer.contents = (id)drop.CGImage;
                dropLayer.bounds = CGRectMake(0, 0, 1.6 * len, 2 * len);
                SSMoteRecord rec = { 0, W * SSRand01(), H * SSRand01(), SSRand01(), len, 0, 0 };
                [self ss_addMote:rec layer:dropLayer to:pane];
            }
            _wetMask = [CAShapeLayer layer];
            _wetMask.frame = pane.bounds;
            _wetMask.fillRule = kCAFillRuleEvenOdd;
            _wetMask.fillColor = [UIColor blackColor].CGColor;
            pane.mask = _wetMask;
            _wiperPivot = CGPointMake(W * 0.5, H + 81 * _k);
            _wiperLength = MIN(980 * _k, 0.6125 * W);
            _wiper = [CALayer layer];
            _wiper.bounds = CGRectZero;
            _wiper.position = _wiperPivot;
            CAShapeLayer *arm = [CAShapeLayer layer];
            arm.path = ({
                UIBezierPath *p = [UIBezierPath bezierPath];
                [p moveToPoint:CGPointZero];
                [p addLineToPoint:CGPointMake(_wiperLength, 0)];
                p.CGPath;
            });
            arm.strokeColor = [UIColor colorWithRed:0.043137254901960784 green:0.043137254901960784
                                               blue:0.050980392156862744 alpha:1].CGColor;
            arm.lineWidth = MAX(16 * _k, 2);
            arm.lineCap = kCALineCapRound;
            [_wiper addSublayer:arm];
            CAShapeLayer *blade = [CAShapeLayer layer];
            blade.path = ({
                UIBezierPath *p = [UIBezierPath bezierPath];
                [p moveToPoint:CGPointMake(60 * _k, -6 * _k)];
                [p addLineToPoint:CGPointMake(_wiperLength, -6 * _k)];
                p.CGPath;
            });
            blade.strokeColor = [UIColor colorWithWhite:1 alpha:0.15].CGColor;
            blade.lineWidth = MAX(3 * _k, 1);
            [_wiper addSublayer:blade];
            [_glass.layer addSublayer:_wiper];
            break;
        }
        case 9: {
            // Clouds (3) then snow. The binary reaches the cloud block
            // above with count 3 and falls into the snow loop; factored
            // here as the same cloud code with _sky != 4.
            UIColor *tint = isDay ? [UIColor whiteColor]
                                  : [UIColor colorWithRed:0.7058823529411765 green:0.7450980392156863
                                                     blue:0.8235294117647058 alpha:1];
            UIImageSymbolConfiguration *config =
                [UIImageSymbolConfiguration configurationWithPointSize:120.0];
            UIImage *image = [UIImage systemImageNamed:@"cloud.fill" withConfiguration:config];
            UIImage *tinted = [image imageWithTintColor:tint renderingMode:UIImageRenderingModeAlwaysOriginal];
            if (tinted) {
                UIImage *processed = SSRenderedImage(tinted.size, ^(CGContextRef ctx) {
                    (void)ctx;
                    [tinted drawInRect:CGRectMake(0, 0, tinted.size.width, tinted.size.height)];
                });
                for (NSInteger i = 0; i < 3; i++) {
                    double cloudW = _k * (260 + 100 * SSRand01());
                    double height = cloudW * processed.size.height / MAX(processed.size.width, 1);
                    CALayer *cloud = [CALayer layer];
                    cloud.contents = (id)processed.CGImage;
                    cloud.contentsGravity = kCAGravityResizeAspect;
                    cloud.bounds = CGRectMake(0, 0, cloudW, height);
                    cloud.opacity = (float)(0.35 + (double)arc4random_uniform(1000000) / 4.0 / 1000000.0);
                    double y = H * (0.1 + 0.4 * SSRand01());
                    cloud.position = CGPointMake(0, y);
                    SSMoteRecord rec = { 3, (W + cloudW) * SSRand01(), y,
                                         _k * (8 + 14 * SSRand01()), 0, cloudW, 0 };
                    [self ss_addMote:rec layer:cloud to:hostLayer];
                }
            }
            // Snow: 100 flakes (kind 4).
            for (NSInteger i = 0; i < 100; i++) {
                double radius = _k * (1.5 + 3 * SSRand01());
                CALayer *flake = [CALayer layer];
                flake.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.85].CGColor;
                flake.bounds = CGRectMake(0, 0, 2 * radius, 2 * radius);
                flake.cornerRadius = radius;
                SSMoteRecord rec = { 4, W * SSRand01(), H * SSRand01(),
                                     _k * (30 + 40 * SSRand01()), radius, 0, 6 * SSRand01() };
                [self ss_addMote:rec layer:flake to:hostLayer];
            }
            break;
        }
        default:
            break;
    }
}

// ---------------------------------------------------------------------------
// Scene 6: Particles — 0x14d50 [VERIFIED line-level]
// The name text is rasterised into an alpha-only bitmap; set pixels are
// sampled on a grid and stored as 48-byte particle records in _particles
// { targetX, targetY, startX, startY, delayA, delayB } for
// ss_drawParticles:. A period-greeting label is the only subview.
// ---------------------------------------------------------------------------
- (void)ss_buildParticles {
    double W = _sceneSize.width, H = _sceneSize.height;
    UIView *host = [self ss_host];
    [host.layer addSublayer:SSRadialGlowLayer(
        [UIColor colorWithRed:0.23529411764705882 green:0.35294117647058826 blue:0.7843137254901961 alpha:0.25],
        [UIColor colorWithRed:0 green:0 blue:0 alpha:0],
        CGPointMake(W / 2, H / 2), W * 0.45)];
    [self ss_addCanvas];

    NSString *text = SSTrimmed(self.name);
    if (text.length == 0) text = SSTrimmed(self.carName);
    if (text.length == 0) text = @"OmniCar";

    UIFont *font = SSRoundedFont(_k * 180, UIFontWeightHeavy);
    NSDictionary *attrs = @{ NSFontAttributeName: font };
    CGSize textSize = [text sizeWithAttributes:attrs];
    if (textSize.width > W * 0.9 && textSize.width > 0) {
        font = SSRoundedFont(_k * 180 * (W * 0.9) / textSize.width, UIFontWeightHeavy);
        attrs = @{ NSFontAttributeName: font };
        textSize = [text sizeWithAttributes:attrs];
    }

    // Bounds guard exactly as emitted (rem4 VERIFIED, dump
    // rem4_buildParticles.txt @0x15020-0x15040): each dimension is
    // converted with fcvtpu (ceil) and range-tested as
    // (dim - 0x1001) + 0xFFF unsigned — i.e. the bitmap is built only
    // when 2 <= dim <= 0x1000 (4096). Width is checked first, then
    // height; either failure bails out of the whole bitmap block.
    NSUInteger w = (NSUInteger)ceil(textSize.width);
    NSUInteger h = (NSUInteger)ceil(textSize.height);
    if (w >= 2 && w <= 0x1000 && h >= 2 && h <= 0x1000) {
        CGContextRef ctx = CGBitmapContextCreate(NULL, w, h, 8, 0, NULL,
                                                 kCGImageAlphaOnly);   // bitmapInfo 7
        if (ctx) {
            CGContextTranslateCTM(ctx, 0, h);
            CGContextScaleCTM(ctx, 1, -1);
            UIGraphicsPushContext(ctx);
            [text drawAtPoint:CGPointZero withAttributes:@{
                NSFontAttributeName: font,
                NSForegroundColorAttributeName: [UIColor whiteColor],
            }];
            UIGraphicsPopContext();
            const uint8_t *bytes = CGBitmapContextGetData(ctx);
            size_t stride = CGBitmapContextGetBytesPerRow(ctx);
            NSUInteger onCount = 0;
            for (NSUInteger y = 0; y < h; y++)
                for (NSUInteger x = 0; x < w; x++)
                    if (bytes[y * stride + x] > 0x80) onCount++;
            double step = MAX(sqrt(onCount / 800.0), 1.0);
            NSMutableData *points = [NSMutableData data];
            for (double y = step / 2; y < h; y += step) {
                for (double x = step / 2; x < w; x += step) {
                    if (bytes[(NSUInteger)y * stride + (NSUInteger)x] >= 0x81) {
                        double pair[2] = { x, y };
                        [points appendBytes:pair length:sizeof(pair)];
                    }
                }
            }
            CGContextRelease(ctx);

            NSUInteger total = points.length / sizeof(double) / 2;
            NSUInteger count = MIN(total, 900);
            _particles = [NSMutableData dataWithLength:count * 48];
            double *records = _particles.mutableBytes;
            const double *pts = points.bytes;
            double originX = W / 2 - textSize.width / 2;
            double originY = H / 2 - 20 * _k - textSize.height / 2;
            double span = H + 220 * _k + 0.06 * _k;
            for (NSUInteger i = 0; i < count; i++) {
                NSUInteger src = (i * total) / count;   // even resampling
                double *rec = records + i * 6;
                rec[0] = originX + pts[src * 2];
                rec[1] = originY + pts[src * 2 + 1];
                rec[2] = span * SSRand01() - 0.06 * _k;
                rec[3] = span * SSRand01() - 0.06 * _k;
                rec[4] = 0.5 * SSRand01();
                rec[5] = 40 * SSRand01() + 190;
            }
            _dot = MAX(step * 0.55, 1.5);
        }
    }

    NSDate *date = self.date ?: [NSDate date];
    SSFade *fade = [self ss_fade:[self ss_label:SSPeriodGreetingText(SSPeriodForDate(date))
                                             at:CGPointMake(_ox + 800 * _k, _oy + 500 * _k)
                                           size:3.0 weight:UIFontWeightSemibold
                                          color:nil left:NO in:_scene maxWidth:0]
                            from:2.0 to:2.6 alpha:1.0];
    if (self.duration > 1.5) {
        fade.outA = self.duration - 0.9;
        fade.outB = self.duration - 0.4;
    }
}

// ---------------------------------------------------------------------------
// Scene 7: HUD — 0x15ad0 [VERIFIED line-level]
// Three dashed accent rings + a conic sweep disc (kept in _flash), the
// percent readout (built at "100%", immediately reset to "0%" — the apply
// side counts it up), up to 5 checklist rows (glyph + text, staggered
// fades) and the READY caption.
// ---------------------------------------------------------------------------
- (void)ss_buildHud {
    UIView *host = [self ss_host];
    CALayer *hostLayer = host.layer;
    double cx = _ox + 400 * _k, cy = _oy + 300 * _k;
    UIColor *accent = [UIColor colorWithRed:0.47058823529411764 green:0.8627450980392157
                                       blue:1 alpha:0.55];

    static const double ringRadii[3] = { 210, 170, 130 };   // table @0x29560
    for (NSInteger i = 0; i < 3; i++) {
        double r = ringRadii[i] * _k;
        CAShapeLayer *ring = [CAShapeLayer layer];
        ring.bounds = CGRectMake(0, 0, 2 * r, 2 * r);
        ring.position = CGPointMake(cx, cy);
        ring.path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(r, r) radius:r
                                               startAngle:0 endAngle:2 * M_PI clockwise:YES].CGPath;
        ring.fillColor = NULL;
        ring.strokeColor = accent.CGColor;
        ring.lineWidth = MAX(_k * (i == 0 ? 3 : 2), 1);
        if (i == 1) ring.lineDashPattern = @[@(6 * _k), @(10 * _k)];
        if (i == 2) ring.lineDashPattern = @[@(40 * _k), @(16 * _k)];
        [hostLayer addSublayer:ring];
        [_rings addObject:ring];
    }

    double discR = 205 * _k;
    CAGradientLayer *disc = [CAGradientLayer layer];
    disc.type = kCAGradientLayerConic;
    disc.bounds = CGRectMake(0, 0, 2 * discR, 2 * discR);
    disc.position = CGPointMake(cx, cy);
    disc.cornerRadius = discR;
    disc.masksToBounds = YES;
    disc.startPoint = CGPointMake(0.5, 0.5);
    disc.endPoint = CGPointMake(1, 0.5);
    disc.colors = @[(id)[UIColor colorWithRed:0.47058823529411764 green:0.8627450980392157 blue:1 alpha:0].CGColor,
                    (id)[UIColor colorWithRed:0.47058823529411764 green:0.8627450980392157 blue:1 alpha:0].CGColor,
                    (id)[UIColor colorWithRed:0.47058823529411764 green:0.8627450980392157 blue:1 alpha:0.45].CGColor];
    disc.locations = @[@0, @0.88, @1];   // constant array @0x355d8
    [hostLayer addSublayer:disc];
    _flash = disc;

    UIColor *percentColor = [UIColor colorWithRed:0.6666666666666666 green:0.9215686274509803
                                             blue:1 alpha:1];
    _percentLabel = [self ss_label:@"100%" at:CGPointMake(cx, cy) size:64
                            weight:UIFontWeightHeavy color:percentColor
                              left:NO in:host maxWidth:0];
    [_percentLabel setText:@"0%"];

    NSArray *items = self.hud.count ? self.hud : SSDefaultHudItems(self.carName);
    if (items.count) {
        NSInteger shown = MIN((NSInteger)items.count, 5);
        double rowY = 305 - 31 * shown;   // in _k units
        for (NSInteger i = 0; i < shown; i++) {
            NSDictionary *dict = [items[i] isKindOfClass:[NSDictionary class]] ? items[i] : @{};
            id okVal = dict[@"ok"];
            BOOL notOk = okVal ? ![okVal boolValue] : NO;
            NSString *text = [dict[@"text"] isKindOfClass:[NSString class]] ? dict[@"text"] : @"";
            UILabel *glyph = [self ss_label:(notOk ? @"!" : @"✓")
                                         at:CGPointMake(_ox + 800 * _k, _oy + rowY * _k)
                                       size:30 weight:UIFontWeightHeavy
                                      color:(notOk ? [UIColor colorWithRed:1 green:0.6666666666666666
                                                                       blue:0.23529411764705882 alpha:1]
                                                   : [UIColor colorWithRed:0.47058823529411764 green:1
                                                                       blue:0.6666666666666666 alpha:1])
                                       left:YES in:host maxWidth:0];
            UILabel *label = [self ss_label:text
                                         at:CGPointMake(_ox + 850 * _k, _oy + rowY * _k)
                                       size:30 weight:UIFontWeightMedium
                                      color:[UIColor colorWithRed:0.8627450980392157 green:0.9411764705882353
                                                              blue:1 alpha:1]
                                       left:YES in:host maxWidth:0];
            [self ss_fade:glyph from:0.5 + 0.38 * i to:0.8 + 0.38 * i alpha:1];
            [self ss_fade:label from:0.5 + 0.38 * i to:0.8 + 0.38 * i alpha:1];
            rowY += 62;
        }
    }

    UILabel *ready = [self ss_label:OMCTr(@"SẴN SÀNG", @"READY")
                                 at:CGPointMake(_ox + 1060 * _k, _oy + 500 * _k)
                               size:44 weight:UIFontWeightHeavy color:percentColor
                                left:NO in:host maxWidth:0];
    [self ss_fade:ready from:2.6 to:3.1 alpha:1];
}

// ---------------------------------------------------------------------------
// Scene 8: Briefing — 0x16af8 [VERIFIED line-level]
// Builds up to 5 info rows, each an NSArray triple [ title, detail, icon ]
// (element order proven by the layout code), then lays them out as glass
// cards in a 2-column grid. Rows: greeting (always), weather OR battery
// (mutually exclusive — the battery row is built only when there is no
// weather dictionary), next calendar event (when it has a title), and the
// closing safety line (always). There is NO row-count cap in the binary.
// ---------------------------------------------------------------------------
- (void)ss_buildBriefing {
    UIView *host = [self ss_host];
    [host.layer addSublayer:SSRadialGlowLayer(
        [UIColor colorWithRed:1 green:0.7450980392156863 blue:0.47058823529411764 alpha:0.25],
        [UIColor colorWithRed:1 green:0.7450980392156863 blue:0.47058823529411764 alpha:0],
        CGPointMake(_ox + 220 * _k, _oy + 81 * _k), 600 * _k)];

    NSDate *date = self.date ?: [NSDate date];
    NSInteger period = SSPeriodForDate(date);
    NSMutableArray *rows = [NSMutableArray array];

    // Row 1: greeting + date line.
    NSString *greetDetail = [NSString stringWithFormat:@"%@ · %@",
        [NSDateFormatter localizedStringFromDate:date dateStyle:NSDateFormatterNoStyle
                                       timeStyle:NSDateFormatterShortStyle],
        SSDateLineText(date)];
    [rows addObject:@[SSGreetingWithName(self.name, period), greetDetail, @"👋"]];

    if (self.weather) {
        // Row 2: weather.
        NSDictionary *weather = self.weather;
        NSInteger code = [weather[@"code"] integerValue];
        BOOL isDay = [weather[@"isDay"] boolValue];
        NSString *symbol = nil, *conditionText = nil;
        SSWeatherSymbolAndText(code, isDay, &symbol, &conditionText);
        // NOTE: the builder consumes only the condition TEXT; the symbol
        // returned alongside is dropped, and the row icon comes from the
        // static emoji table below, indexed by SSWeatherCategory.
        NSMutableArray *parts = [NSMutableArray array];
        if (weather[@"high"] && weather[@"low"]) {
            // Format verified byte-exact: TWO spaces before the down arrow.
            [parts addObject:[NSString stringWithFormat:@"↑ %@  ↓ %@",
                              SSTemperatureText(weather[@"high"]),
                              SSTemperatureText(weather[@"low"])]];
        }
        if (weather[@"rain"]) {
            [parts addObject:[NSString stringWithFormat:OMCTr(@"%ld%% khả năng mưa", @"%ld%% chance of rain"),
                              (long)[weather[@"rain"] integerValue]]];
        }
        NSString *title = [NSString stringWithFormat:@"%@ · %@",
                           SSTemperatureText(weather[@"temp"]), conditionText];
        NSString *detail = parts.count ? [parts componentsJoinedByString:@" · "]
                                       : OMCTr(@"Thời tiết hôm nay", @"Today's weather");
        static NSString * const emoji[10] = {   // constant table @0x30c98
            @"☀️", @"🌙", @"⛅", @"☁️", @"☁️", @"🌫", @"🌦", @"🌧", @"⛈", @"🌨"
        };
        [rows addObject:@[title, detail, emoji[SSWeatherCategory(code, isDay)]]];
    } else if (self.batteryPercent >= 0) {
        // Row 3: battery — ONLY in the no-weather branch (the binary
        // branches over this whole block when weather is present).
        NSInteger percent = self.batteryPercent;
        NSString *title = [NSString stringWithFormat:OMCTr(@"Pin iPhone %ld%%", @"iPhone battery %ld%%"),
                           (long)percent];
        NSString *detail, *icon;
        if (percent <= 19) {
            detail = OMCTr(@"Nhớ cắm sạc trên xe", @"Plug it in on the way");
            icon = @"🪫";
        } else {
            detail = OMCTr(@"Đủ pin cho chuyến đi", @"Enough for the trip");
            icon = @"🔋";
        }
        [rows addObject:@[title, detail, icon]];
    }

    // Row 4: next calendar event (needs a non-empty NSString title).
    NSDictionary *event = self.nextEvent;
    NSString *eventTitle = [event[@"title"] isKindOfClass:[NSString class]] ? event[@"title"] : nil;
    if (eventTitle.length) {
        NSDate *eventDate = [event[@"date"] isKindOfClass:[NSDate class]] ? event[@"date"] : nil;
        NSString *titleText, *detail;
        if (eventDate) {
            titleText = [NSString stringWithFormat:@"%@ %@",
                [NSDateFormatter localizedStringFromDate:eventDate dateStyle:NSDateFormatterNoStyle
                                               timeStyle:NSDateFormatterShortStyle],
                eventTitle];
            // The binary computes the "next on your calendar" header here
            // too and then discards it (dead store in the dated path).
            NSString *unusedHeader = OMCTr(@"Lịch hẹn kế tiếp", @"Next on your calendar");
            (void)unusedHeader;
            NSInteger mins = (NSInteger)([eventDate timeIntervalSinceDate:date] / 60.0);
            if (mins <= 0) {
                detail = OMCTr(@"Đang diễn ra", @"Happening now");
            } else if (mins <= 59) {
                detail = [NSString stringWithFormat:OMCTr(@"Còn %ld phút", @"In %ld min"), (long)mins];
            } else {
                detail = [NSString stringWithFormat:OMCTr(@"Còn %ld giờ %ld phút", @"In %ld h %ld min"),
                          (long)(mins / 60), (long)(mins % 60)];
            }
        } else {
            titleText = eventTitle;
            detail = OMCTr(@"Lịch hẹn kế tiếp", @"Next on your calendar");
        }
        NSString *location = [event[@"location"] isKindOfClass:[NSString class]]
                             ? SSTrimmed(event[@"location"]) : @"";
        if (location.length) {
            detail = [NSString stringWithFormat:@"%@ · %@", detail, location];
        }
        [rows addObject:@[titleText, detail, @"📅"]];
    }

    // Row 5: closing line (always).
    [rows addObject:@[OMCTr(@"Thắt dây an toàn", @"Buckle up"),
                      OMCTr(@"Chúc bạn thượng lộ bình an", @"Have a safe trip"),
                      @"🛡"]];

    // Layout: glass cards, 2 columns; a lone third row (of 3) is centred.
    double cardW = 700 * _k, cardH = 210 * _k;
    for (NSInteger i = 0; i < (NSInteger)rows.count; i++) {
        NSArray *row = rows[i];
        double cardX = (i == 2 && rows.count == 3) ? 450 : (i % 2 ? 810 : 70);
        double cardY = (rows.count == 2) ? 195 : 70 + 240 * (i / 2);
        UIView *card = [[UIView alloc] initWithFrame:CGRectMake(_ox + cardX * _k, _oy + cardY * _k,
                                                                cardW, cardH)];
        card.backgroundColor = [UIColor colorWithWhite:1 alpha:0.08];
        card.layer.cornerRadius = 34 * _k;
        card.layer.cornerCurve = kCACornerCurveContinuous;
        card.layer.borderWidth = MAX(1.2 * _k, 0.5);
        card.layer.borderColor = [UIColor colorWithWhite:1 alpha:0.22].CGColor;
        [host addSubview:card];
        [self ss_label:row[2] at:CGPointMake(90 * _k, 105 * _k) size:70
                weight:UIFontWeightRegular color:nil left:NO in:card maxWidth:150 * _k];
        [self ss_label:row[0] at:CGPointMake(170 * _k, 85 * _k) size:40
                weight:UIFontWeightBold color:nil left:YES in:card maxWidth:500 * _k];
        UILabel *detail = [self ss_label:row[1] at:CGPointMake(170 * _k, 140 * _k) size:26
                                  weight:UIFontWeightMedium color:nil left:YES in:card
                                maxWidth:500 * _k];
        detail.alpha = 0.7;
        SSFade *fade = [self ss_fade:card from:0.3 + 0.45 * i to:0.9 + 0.45 * i alpha:1];
        fade.outEase = YES;
        fade.rise = 40 * _k;
    }
}

// ---------------------------------------------------------------------------
// Scene 9: Liquid — 0x17bb4 [VERIFIED line-level]
// Four coloured glow blobs (palette table @0x35650: packed RGB + centre +
// radius, all in _k units) drifting on `position` (key ssDrift); the app
// logo breathing on transform.translation.y (key ssBreathe); the "OmniCar"
// title as a gradient-masked label; a tagline; and a loading pill whose
// gradient sweeps on transform.translation.x (key ssSweep).
// (Animation key/path assignment as in the binary — it contradicts the
// original agent's structural body, which had the three keys rotated.)
// ---------------------------------------------------------------------------
- (void)ss_buildLiquid {
    UIView *host = [self ss_host];
    CALayer *hostLayer = host.layer;

    static const struct { uint32_t rgb; double x, y, scale; } palette[4] = {
        { 12035839, 260, 120, 700 },    // 0xB7A9FF lavender
        { 9425919, 1350, 170, 650 },    // 0x8FD7FF sky blue
        { 10351320, 1250, 560, 600 },   // 0x9DF668 green
        { 16761558, 320, 540, 560 },    // 0xFFC966 amber
    };
    for (NSInteger i = 0; i < 4; i++) {
        uint32_t packed = palette[i].rgb;
        double r = ((packed >> 16) & 0xFF) / 255.0;
        double g = ((packed >> 8) & 0xFF) / 255.0;
        double b = (packed & 0xFF) / 255.0;
        CGPoint center = CGPointMake(_ox + palette[i].x * _k, _oy + palette[i].y * _k);
        CAGradientLayer *glow = SSRadialGlowLayer(
            [UIColor colorWithRed:r green:g blue:b alpha:0.85],
            [UIColor colorWithRed:r green:g blue:b alpha:0],
            center, palette[i].scale * _k);
        [hostLayer addSublayer:glow];
        CABasicAnimation *drift = [CABasicAnimation animationWithKeyPath:@"position"];
        drift.fromValue = [NSValue valueWithCGPoint:center];
        drift.toValue = [NSValue valueWithCGPoint:CGPointMake(
            center.x + (i % 2 == 0 ? 60 : -60) * _k,
            center.y + (i < 2 ? 40 : -70) * _k)];
        drift.duration = 14.0;
        drift.autoreverses = YES;
        drift.repeatCount = HUGE_VALF;
        drift.timeOffset = i * 3.5;
        drift.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        [glow addAnimation:drift forKey:@"ssDrift"];
    }

    // Logo (Prefs bundle icon, falling back to logo@3x.png).
    const char *realPath = OMCRealPath("/Library/PreferenceBundles/OmniCarPrefs.bundle/PackageIcon.png");
    UIImage *image = realPath ? [UIImage imageWithContentsOfFile:[NSString stringWithUTF8String:realPath]] : nil;
    if (!image) {
        realPath = OMCRealPath("/Library/PreferenceBundles/OmniCarPrefs.bundle/logo@3x.png");
        if (realPath) image = [UIImage imageWithContentsOfFile:[NSString stringWithUTF8String:realPath]];
    }
    UIImageView *logoView = [[UIImageView alloc] initWithImage:image];
    logoView.contentMode = UIViewContentModeScaleAspectFit;   // 1
    logoView.bounds = CGRectMake(0, 0, 300 * _k, 300 * _k);
    logoView.center = CGPointMake(_ox + 560 * _k, _oy + 300 * _k);
    logoView.layer.shadowColor = [UIColor colorWithRed:0.35294117647058826 green:0.3137254901960784
                                                  blue:0.6666666666666666 alpha:1].CGColor;
    logoView.layer.shadowOpacity = 0.35f;                     // float @0x29434
    logoView.layer.shadowRadius = 26 * _k;
    logoView.layer.shadowOffset = CGSizeMake(0, 14 * _k);
    [host addSubview:logoView];
    SSFade *logoFade = [self ss_fade:logoView from:0.1 to:0.9 alpha:1];
    logoFade.rise = 40 * _k;
    CABasicAnimation *breathe = [CABasicAnimation animationWithKeyPath:@"transform.translation.y"];
    breathe.fromValue = @(_k * 4);
    breathe.toValue = @(_k * -4);
    breathe.duration = 2.4;
    breathe.autoreverses = YES;
    breathe.repeatCount = HUGE_VALF;
    breathe.additive = YES;
    breathe.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    [logoView.layer addAnimation:breathe forKey:@"ssBreathe"];

    // Title: black SSSceneLabel used as the mask of a gradient container.
    UILabel *title = SSSceneLabel(@"OmniCar");
    title.font = SSRoundedFont(110 * _k, UIFontWeightHeavy);
    title.textColor = [UIColor blackColor];
    CGSize fit = [title sizeThatFits:CGSizeMake(DBL_MAX, DBL_MAX)];
    UIView *container = [[UIView alloc] initWithFrame:CGRectMake(_ox + 780 * _k, _oy + 215 * _k,
                                                                  ceil(fit.width), ceil(fit.height))];
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = container.bounds;
    gradient.colors = @[(id)[UIColor colorWithRed:0.43529411764705883 green:0.3607843137254902
                                             blue:0.9647058823529412 alpha:1].CGColor,
                        (id)[UIColor colorWithRed:0.23137254901960785 green:0.611764705882353
                                             blue:0.9411764705882353 alpha:1].CGColor];
    gradient.startPoint = CGPointMake(0, 0.5);
    gradient.endPoint = CGPointMake(1, 0.5);
    [container.layer addSublayer:gradient];
    title.frame = container.bounds;
    container.maskView = title;
    [host addSubview:container];
    SSFade *titleFade = [self ss_fade:container from:0.45 to:1.15 alpha:1];
    titleFade.rise = 30 * _k;

    // Tagline.
    UILabel *tagline = [self ss_label:OMCTr(@"Sức mạnh của CarPlay", @"The power of CarPlay")
                                   at:CGPointMake(_ox + 784 * _k, _oy + 355 * _k)
                                 size:40 weight:UIFontWeightMedium
                                color:[UIColor colorWithRed:0.4196078431372549 green:0.4392156862745098
                                                       blue:0.5647058823529412 alpha:1]
                                 left:YES in:host maxWidth:700 * _k];
    tagline.layer.shadowOpacity = 0;
    SSFade *taglineFade = [self ss_fade:tagline from:0.7 to:1.4 alpha:1];
    taglineFade.rise = 30 * _k;

    // Loading pill with a sweeping gradient.
    double pillW = 240 * _k, pillH = MAX(8 * _k, 2);
    UIView *pill = [[UIView alloc] initWithFrame:CGRectMake(_ox + 680 * _k, _oy + 540 * _k, pillW, pillH)];
    pill.backgroundColor = [UIColor colorWithRed:0.12156862745098039 green:0.13333333333333333
                                            blue:0.2 alpha:0.9];
    pill.layer.cornerRadius = pillH * 0.5;
    pill.clipsToBounds = YES;
    [host addSubview:pill];
    CAGradientLayer *sweep = [CAGradientLayer layer];
    sweep.frame = CGRectMake(0, 0, pillW * 0.4, pillH);
    sweep.cornerRadius = pillH * 0.5;
    sweep.colors = @[(id)[UIColor colorWithRed:0.5450980392156862 green:0.48627450980392156
                                          blue:1 alpha:1].CGColor,
                     (id)[UIColor colorWithRed:0.85 green:0.7215686274509804
                                          blue:1 alpha:1].CGColor];
    sweep.startPoint = CGPointMake(0, 0.5);
    sweep.endPoint = CGPointMake(1, 0.5);
    [pill.layer addSublayer:sweep];
    CABasicAnimation *sweepAnim = [CABasicAnimation animationWithKeyPath:@"transform.translation.x"];
    sweepAnim.fromValue = @(pillW * -0.4);
    sweepAnim.toValue = @(pillW * 1.04);
    sweepAnim.duration = 1.6;
    sweepAnim.repeatCount = HUGE_VALF;
    sweepAnim.timingFunction = [CAMediaTimingFunction functionWithControlPoints:0.2 :0 :0.2 :1];
    [sweep addAnimation:sweepAnim forKey:@"ssSweep"];
    [self ss_fade:pill from:1.0 to:1.5 alpha:1];
}

// ---------------------------------------------------------------------------
// Scene 11: Festive — 0x18af0 [VERIFIED line-level]
// Occasion switch (self.occasion): 1 Tết, 2 birthday, 3 Christmas,
// 4 Mid-Autumn, 5 New Year (with fireworks bursts), 0/other New Year
// (labels only). Occasions 1 and 5 share a preamble: a radial backdrop
// glow, the canvas, and the 7-record _bursts table consumed by
// ss_drawFireworks: — records are 32 bytes { cx, cy, delay, hue } with
// cx = W*(0.125 + 0.75r), cy = H*(0.13 + 0.37r), delay = 0.3 + 0.55i and
// hues from the constant table @0x29578.
// Mote kinds used here: 5 = Tết petals, 6 = birthday confetti,
// 7 = Mid-Autumn moons, 4 = Christmas snow.
// ---------------------------------------------------------------------------

// Shared title/subtitle tail (machine code 0x19d6c-0x19f00, entered from
// every festive arm): title Heavy at (_ox + 800k, _oy + titleY*k), fade
// 0.8 -> (occasion 1 ? 1.6 : 1.5); subtitle Semibold below it, fade
// (occasion 1 ? 1.4 : 1.3) -> (occasion 1 ? 2.1 : 2.0). The occasion test
// inside the tail reads self.occasion again, as the binary does.
- (void)ss_festiveLabelsWithTitle:(NSString *)title subtitle:(NSString *)subtitle
                       titleColor:(UIColor *)titleColor subtitleColor:(UIColor *)subtitleColor
                           titleY:(double)titleY titleSize:(double)titleSize
                       subtitleY:(double)subtitleY subtitleSize:(double)subtitleSize {
    UIView *host = [self ss_host];
    UILabel *titleLabel = [self ss_label:title
                                      at:CGPointMake(_ox + 800 * _k, _oy + titleY * _k)
                                    size:titleSize weight:UIFontWeightHeavy
                                   color:titleColor left:NO in:host maxWidth:0];
    [self ss_fade:titleLabel from:0.8 to:(self.occasion == 1 ? 1.6 : 1.5) alpha:1];
    UILabel *subtitleLabel = [self ss_label:subtitle
                                         at:CGPointMake(_ox + 800 * _k, _oy + subtitleY * _k)
                                       size:subtitleSize weight:UIFontWeightSemibold
                                      color:subtitleColor left:NO in:host maxWidth:0];
    [self ss_fade:subtitleLabel from:(self.occasion == 1 ? 1.4 : 1.3)
                                 to:(self.occasion == 1 ? 2.1 : 2.0) alpha:1];
}

// Icon line used by the birthday and Christmas arms (machine code
// 0x197c4-0x198ac): the icon sits at (_ox + 800k, _oy + table[occasion]*k)
// with table { 180, 190 } — index 1 only for Christmas (occasion 3).
- (void)ss_festiveIcon:(NSString *)icon {
    UIView *host = [self ss_host];
    static const double iconY[2] = { 180, 190 };   // table @0x29480
    UILabel *label = [self ss_label:icon
                                 at:CGPointMake(_ox + 800 * _k,
                                                _oy + iconY[self.occasion == 3 ? 1 : 0] * _k)
                               size:120 weight:UIFontWeightRegular color:nil
                                left:NO in:host maxWidth:0];
    SSFade *fade = [self ss_fade:label from:0.3 to:1.0 alpha:1];
    fade.outEase = YES;
}

- (void)ss_buildFestive {
    double W = _sceneSize.width, H = _sceneSize.height;
    NSInteger occasion = self.occasion;
    NSString *name = self.name;
    UIView *host = [self ss_host];
    CALayer *hostLayer = host.layer;

    if (occasion == 1 || occasion == 5) {
        // Shared preamble: backdrop glow + canvas + fireworks table.
        UIColor *glowColor, *glowClear;
        CGPoint glowCenter;
        if (occasion == 1) {
            glowColor = [UIColor colorWithRed:1 green:0.7843137254901961 blue:0.23529411764705882 alpha:0.25];
            glowClear = [UIColor colorWithRed:1 green:0.7843137254901961 blue:0.23529411764705882 alpha:0];
            glowCenter = CGPointMake(W * 0.5, H * 0.5);
        } else {
            glowColor = [UIColor colorWithRed:0.23529411764705882 green:0.35294117647058826 blue:0.7843137254901961 alpha:0.3];
            glowClear = [UIColor colorWithRed:0.23529411764705882 green:0.35294117647058826 blue:0.7843137254901961 alpha:0];
            glowCenter = CGPointMake(W * 0.5, H * 0.35);
        }
        [hostLayer addSublayer:SSRadialGlowLayer(glowColor, glowClear, glowCenter, W * 0.5)];
        [self ss_addCanvas];
        _bursts = [NSMutableData dataWithLength:7 * 32];
        double *bursts = _bursts.mutableBytes;
        static const double hues[7] = { 0, 45, 55, 330, 20, 200, 120 };   // @0x29578
        for (NSInteger i = 0; i < 7; i++) {
            bursts[i * 4 + 0] = W * (0.125 + 0.75 * SSRand01());
            bursts[i * 4 + 1] = H * (0.13 + 0.37 * SSRand01());
            bursts[i * 4 + 2] = 0.3 + i * 0.55;
            bursts[i * 4 + 3] = hues[i];
        }
    }

    switch (occasion) {
        case 1: {
            // Tết: 36 falling flower petals (kind 5).
            UIImage *flower = SSFlowerImage();
            for (NSInteger i = 0; i < 36; i++) {
                double size = _k * (10 + 8 * SSRand01());
                CALayer *layer = [CALayer layer];
                layer.contents = (id)flower.CGImage;
                layer.bounds = CGRectMake(0, 0, size * 2.2, size * 2.2);
                SSMoteRecord rec = { 5, W * SSRand01(), H * SSRand01() - H,
                                     _k * (60 + 60 * SSRand01()), size,
                                     2 * SSRand01() + 1, 6 * SSRand01() };
                [self ss_addMote:rec layer:layer to:hostLayer];
            }
            [self ss_festiveLabelsWithTitle:OMCTr(@"Chúc Mừng Năm Mới", @"Happy Lunar New Year")
                                   subtitle:SSNameFormatted(
                                       OMCTr(@"An khang thịnh vượng · thượng lộ bình an, %@", @"Health, luck and safe travels, %@"),
                                       OMCTr(@"An khang thịnh vượng · thượng lộ bình an", @"Health, luck and safe travels"),
                                       name)
                                 titleColor:[UIColor colorWithRed:1 green:0.8392156862745098 blue:0.3607843137254902 alpha:1]
                              subtitleColor:[UIColor colorWithRed:1 green:0.9254901960784314 blue:0.7450980392156863 alpha:1]
                                     titleY:250 titleSize:96 subtitleY:360 subtitleSize:3.0];
            break;
        }
        case 2: {
            // Birthday: 100 HSL confetti strips (kind 6).
            for (NSInteger i = 0; i < 100; i++) {
                double rgb[3];
                SSHSLToRGB(360.0 * SSRand01(), 0.9, 0.6, rgb);
                CALayer *layer = [CALayer layer];
                layer.backgroundColor = [UIColor colorWithRed:rgb[0] green:rgb[1] blue:rgb[2] alpha:1].CGColor;
                double size = _k * (8 + 8 * SSRand01());
                layer.bounds = CGRectMake(0, 0, size, 6 * _k);
                SSMoteRecord rec = { 6, W * SSRand01(), H * SSRand01() - H,
                                     _k * (120 + 140 * SSRand01()), 0, 0, 6 * SSRand01() };
                [self ss_addMote:rec layer:layer to:hostLayer];
            }
            [self ss_festiveIcon:@"🎂"];
            [self ss_festiveLabelsWithTitle:SSNameFormatted(
                                                 OMCTr(@"Chúc mừng sinh nhật, %@!", @"Happy birthday, %@!"),
                                                 OMCTr(@"Chúc mừng sinh nhật!", @"Happy birthday!"), name)
                                   subtitle:OMCTr(@"Hôm nay lái xe vui nhé", @"Enjoy the drive today")
                                 titleColor:nil
                              subtitleColor:[UIColor colorWithRed:0.9019607843137255 green:0.8627450980392157 blue:1 alpha:1]
                                     titleY:330 titleSize:72 subtitleY:420 subtitleSize:30];
            break;
        }
        case 3: {
            // Christmas: 120 snow flakes (kind 4, same shape as sky snow).
            for (NSInteger i = 0; i < 120; i++) {
                double radius = _k * (1.5 + 3 * SSRand01());
                CALayer *layer = [CALayer layer];
                layer.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.85].CGColor;
                layer.bounds = CGRectMake(0, 0, 2 * radius, 2 * radius);
                layer.cornerRadius = radius;
                SSMoteRecord rec = { 4, W * SSRand01(), H * SSRand01(),
                                     _k * (30 + 40 * SSRand01()), radius, 0, 6 * SSRand01() };
                [self ss_addMote:rec layer:layer to:hostLayer];
            }
            [self ss_festiveIcon:@"🎄"];
            [self ss_festiveLabelsWithTitle:OMCTr(@"Giáng Sinh An Lành", @"Merry Christmas")
                                   subtitle:SSNameFormatted(
                                       OMCTr(@"Merry Christmas, %@", @"Happy holidays, %@"),
                                       OMCTr(@"Giáng Sinh An Lành", @"Happy holidays"), name)
                                 titleColor:nil
                              subtitleColor:[UIColor colorWithRed:0.7843137254901961 green:0.9019607843137255 blue:1 alpha:1]
                                     titleY:340 titleSize:80 subtitleY:425 subtitleSize:30];
            break;
        }
        case 4: {
            // Mid-Autumn: moon glow + 7 moon motes (kind 7) — a plain
            // layer carrying a radial glow and an oval "petal" shape.
            [hostLayer addSublayer:SSRadialGlowLayer(
                [UIColor colorWithRed:1 green:0.9411764705882353 blue:0.7450980392156863 alpha:1],
                [UIColor colorWithRed:1 green:0.8627450980392157 blue:0.47058823529411764 alpha:0],
                CGPointMake(_ox + 1300 * _k, _oy + 160 * _k), 160 * _k)];
            for (NSInteger j = 0; j < 7; j++) {
                CALayer *layer = [CALayer layer];
                layer.bounds = CGRectZero;
                [layer addSublayer:SSRadialGlowLayer(
                    [UIColor colorWithRed:1 green:0.6666666666666666 blue:0.3137254901960784 alpha:0.35],
                    [UIColor colorWithRed:1 green:0.6666666666666666 blue:0.3137254901960784 alpha:0],
                    CGPointZero, 90 * _k)];
                CAShapeLayer *oval = [CAShapeLayer layer];
                oval.path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(-0.03 * _k, -0.06 * _k,
                                                                              68 * _k, 86 * _k)].CGPath;
                oval.fillColor = [UIColor colorWithRed:1 green:0.47058823529411764
                                                  blue:0.1568627450980392 alpha:0.9].CGColor;
                [layer addSublayer:oval];
                SSMoteRecord rec = { 7, _ox + j * 230 * _k, 0, 0, 0, 0, j * 90 * _k };
                [self ss_addMote:rec layer:layer to:hostLayer];
            }
            [self ss_festiveLabelsWithTitle:OMCTr(@"Trung Thu Vui Vẻ", @"Happy Mid-Autumn Festival")
                                   subtitle:SSNameFormatted(
                                       OMCTr(@"Trăng tròn, đường thông, %@ nhé", @"Full moon and clear roads, %@"),
                                       OMCTr(@"Trăng tròn, đường thông", @"Full moon and clear roads"), name)
                                 titleColor:[UIColor colorWithRed:1 green:0.8862745098039215 blue:0.6274509803921569 alpha:1]
                              subtitleColor:nil
                                     titleY:300 titleSize:85 subtitleY:400 subtitleSize:30];
            break;
        }
        default: {
            // New Year (occasion 0, 5, and any other value): year from
            // the Gregorian calendar over self.date (or now).
            NSCalendar *calendar = [NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian];
            NSInteger year = [calendar component:NSCalendarUnitYear
                                        fromDate:(self.date ?: [NSDate date])];
            NSString *title = [NSString stringWithFormat:OMCTr(@"Chúc mừng năm mới %ld", @"Happy New Year %ld"),
                               (long)year];
            [self ss_festiveLabelsWithTitle:title
                                   subtitle:SSNameFormatted(
                                       OMCTr(@"Thượng lộ bình an, %@", @"Safe travels, %@"),
                                       OMCTr(@"Thượng lộ bình an", @"Safe travels"), name)
                                 titleColor:[UIColor colorWithRed:1 green:0.8784313725490196 blue:0.5490196078431373 alpha:1]
                              subtitleColor:[UIColor colorWithRed:0.8627450980392157 green:0.9019607843137255 blue:1 alpha:1]
                                     titleY:270 titleSize:90 subtitleY:375 subtitleSize:3.0];
            break;
        }
    }
}

@end
