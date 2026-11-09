// SSStartupView.m
// OmniCar 1.0.3 — OmniCarStartupScreen.dylib — SSStartupView + SSFade +
// SSGauge + SSLinkTarget + SSCanvasView reconstruction.
//
// SSStartupView is a time-driven animated scene engine:
//   - its backing layer is a CAGradientLayer (sky/backdrop gradient);
//   - reload() builds static content (greeting or weather card, logo);
//   - ss_buildScene() builds one of eight animated scenes (sky, engine
//     gauges, welcome, particles, HUD checklist, briefing, liquid, festive);
//   - a CADisplayLink (via the weak SSLinkTarget proxy) drives ss_step ->
//     ss_applyTime:, which evaluates SSFade envelopes and the per-scene
//     apply functions under a CATransaction with actions disabled;
//   - particles and fireworks are drawn with raw CoreGraphics into an
//     SSCanvasView, which forwards drawRect: back to the owner.
//
// The engine, lifecycle and dispatch are [VERIFIED]. The eight scene builders
// are reconstructed at structural fidelity: every element, string, SF Symbol
// and animation found in the disassembly is present, but exact geometry,
// colour tables and physics constants of the cosmetic builders are
// [NOT-RECOVERED] line-level — the disassembly files remain the ground truth
// (see StartupScreen_REPORT.md for the per-method status table).

#import "SSStartupScreen.h"
#import <math.h>
#import <stdlib.h>

// Mote record (56 bytes) — the by-value first argument of
// ss_addMote:layer:to: (type encoding {?=qdddddd}: int64 kind + 6 doubles).
// Same layout as the SSMoteRecord in SSStartupViewBuilders.m (separate TU
// there); field meaning is per kind — see the table above ss_addMote below.
typedef struct {
    int64_t kind;
    double f1, f2, f3, f4, f5, f6;
} SSMoteRecord;

// Private engine surface (from the class dump).
@interface SSStartupView ()
- (double)ss_now;
- (void)ss_startLink;
- (void)ss_stopLink;
- (void)ss_step;
- (void)ss_applyTime:(double)t;
- (void)ss_clearScene;
- (void)ss_buildScene;
- (UIView *)ss_host;
- (void)ss_addCanvas;
- (UILabel *)ss_label:(NSString *)text at:(CGPoint)point size:(double)size
               weight:(UIFontWeight)weight color:(UIColor *)color
                 left:(BOOL)left in:(UIView *)container maxWidth:(double)maxWidth;
- (SSFade *)ss_fade:(UIView *)view from:(double)from to:(double)to alpha:(double)alpha;
- (void)ss_addMote:(SSMoteRecord)record layer:(CALayer *)layer to:(CALayer *)container;
- (void)ss_applyMotes:(double)t;
- (NSArray *)ss_sceneColors;
- (void)ss_buildSky;
- (void)ss_applySky:(double)t;
- (SSGauge *)ss_gaugeAt:(CGPoint)center radius:(double)radius label:(NSString *)label
                   unit:(NSString *)unit max:(double)max red:(double)red in:(UIView *)container;
- (void)ss_buildEngine;
- (void)ss_setGauge:(SSGauge *)gauge value:(double)value;
- (void)ss_applyEngine:(double)t;
- (void)ss_buildWelcome;
- (void)ss_applyWelcome:(double)t;
- (void)ss_buildParticles;
- (void)ss_drawParticles:(CGContextRef)ctx t:(double)t;
- (void)ss_buildHud;
- (void)ss_applyHud:(double)t;
- (void)ss_buildBriefing;
- (void)ss_buildLiquid;
- (void)ss_buildFestive;
- (void)ss_drawFireworks:(CGContextRef)ctx t:(double)t;
- (void)ss_drawCanvas:(CGContextRef)ctx size:(CGSize)size;
- (void)buildGreetingWithDate:(NSDate *)date period:(NSInteger)period;
- (void)buildWeatherWithPeriod:(NSInteger)period;
- (void)applyUnit:(double)unit;
@end

// sub_d6f0 — gradient colour-pair builder for the style-3 category
// re-selection in -reload (defined beside SSWeatherCategory below).
static NSArray *SSCategoryGradientColors(uint32_t rgb1, uint32_t rgb2);

// Font helper used by every label path (sub_f6ac) — rounded-design system
// font, NO scaling inside: callers scale (applyUnit/title at the call site,
// ss_label: internally). [VERIFIED from dump 0xf6ac — restored fix-round3 D6;
// the previous body returned the plain system font.]
static UIFont *SSFont(double size, UIFontWeight weight) {
    UIFont *font = [UIFont systemFontOfSize:size weight:weight];
    UIFontDescriptor *rounded = [font.fontDescriptor fontDescriptorWithDesign:UIFontDescriptorSystemDesignRounded];
    if (rounded) font = [UIFont fontWithDescriptor:rounded size:size];
    return font;
}

// sub_da28 — the scene label factory (local copy; same body as the
// Builders/ScenesB copies). [VERIFIED from dump 0xda28 — added fix-round3 D6]
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

// ===========================================================================
// SSFade [VERIFIED applyTime: structure]
// ===========================================================================

@implementation SSFade
- (void)applyTime:(double)t {   // 0xc130
    double alpha = 0;
    if (t >= self.inA) {
        double p = (self.inB > self.inA) ? MIN(1.0, (t - self.inA) / (self.inB - self.inA)) : 1.0;
        alpha = self.alpha * p;
        double riseP = pow(p, 2.0);   // [INFERRED exponent]
        self.view.transform = CGAffineTransformMakeTranslation(0, self.rise * (1.0 - riseP));
    }
    if (self.outB > self.outA && t > self.outA) {
        double q = MIN(1.0, (t - self.outA) / (self.outB - self.outA));
        if (self.outEase) q = pow(q, 2.0);   // [INFERRED exponent]
        alpha *= (1.0 - q);
    }
    self.view.alpha = alpha;
}
@end

@implementation SSGauge
@end

@implementation SSLinkTarget
- (void)step:(CADisplayLink *)link {   // 0xc4f8 [VERIFIED]
    SSStartupView *owner = self.owner;
    if (owner) [owner ss_step];
    else [link invalidate];
}
@end

@implementation SSCanvasView
- (void)drawRect:(CGRect)rect {   // 0xc584 [VERIFIED — passes the current
                                  // context straight to the owner, exactly
                                  // as the dump; the nil check lives inside
                                  // ss_drawCanvas:size: (0x1a31c).
                                  // Signature restored fix-round3 G/§8E.]
    [self.owner ss_drawCanvas:UIGraphicsGetCurrentContext() size:self.bounds.size];
}
@end

// ===========================================================================
// SSStartupView
// ===========================================================================

@implementation SSStartupView

+ (Class)layerClass {   // [VERIFIED by usage: reload drives self.layer as a gradient]
    return CAGradientLayer.class;
}

- (instancetype)initWithFrame:(CGRect)frame {   // 0xc630 [VERIFIED]
    self = [super initWithFrame:frame];
    if (self) {
        self.clipsToBounds = YES;
        self.backgroundColor = UIColor.blackColor;
    }
    return self;
}

- (void)dealloc {
    [self ss_stopLink];
}

// ---------------------------------------------------------------------------
// Content lifecycle
// ---------------------------------------------------------------------------

- (void)clearContent {   // 0xc734 [VERIFIED]
    for (UIView *subview in [self.subviews copy]) [subview removeFromSuperview];
    _stack = nil; _logoView = nil; _posterView = nil;
    _timeLabel = nil; _titleLabel = nil; _dateLabel = nil;
    _tempLabel = nil; _condLabel = nil; _rangeLabel = nil;
    _rainLabel = nil; _updatedLabel = nil; _iconView = nil;
    _row = nil; _cardStack = nil; _card = nil;
    _iconW = nil; _iconH = nil; _stackMaxWidth = nil; _cardInsets = nil;
    [self ss_clearScene];
    _sceneSize = CGSizeZero;
}

- (void)reload {   // 0xc9f4 [VERIFIED structure; style->scene mapping follows the
                  // branch table in the disassembly — see the report]
    [self clearContent];
    NSDate *date = self.date ?: NSDate.date;
    NSInteger period = SSPeriodForDate(date);
    // Effective style (dump 0xcac8-0xcb3c) — restored fix-round4 strand 2
    // (audit-S LP-1/LP-6): the original derives the style that actually
    // drives content BEFORE building anything, and ss_sceneColors /
    // ss_buildScene / the content dispatch below all key off the derived
    // value in _sceneStyle, never the raw setting:
    //   style 11 -> occasion in [1,6) ? 11 : 2    (0xcb04-0xcb2c)
    //   style 3  -> weather present ? 3 : 2       (0xcadc-0xcb00)
    //   clamp: eff != 11 and (eff < 0 or eff >= 10) -> 2
    //          (0xcb30-0xcb3c: cmp #0xa / ccmp #0xb, #2, ne / csel hi —
    //          the forced-flags arm maps style 10 to 2 as well)
    NSInteger effectiveStyle = self.style;
    if (effectiveStyle == 11) {
        effectiveStyle = (self.occasion >= 1 && self.occasion < 6) ? 11 : 2;
    } else if (effectiveStyle == 3) {
        effectiveStyle = self.weather ? 3 : 2;
    }
    if (effectiveStyle != 11 && (effectiveStyle < 0 || effectiveStyle >= 10))
        effectiveStyle = 2;
    _sceneStyle = effectiveStyle;

    CAGradientLayer *gradient = (CAGradientLayer *)self.layer;
    gradient.type = kCAGradientLayerAxial;
    gradient.startPoint = CGPointMake(0.5, 0.0);
    gradient.endPoint = CGPointMake(0.5, 1.0);
    gradient.colors = [self ss_sceneColors];

    // The original ALWAYS creates two distinct image views (dump 0xc9f4):
    // _posterView (full-frame backdrop, clipsToBounds) and _logoView (the
    // logo itself, AspectFit; layoutSubviews sizes it as a centred square).
    // Our previous version aliased both ivars to a single view.
    UIImageView *poster = [[UIImageView alloc] initWithFrame:self.bounds];
    poster.clipsToBounds = YES;   // 0xcd54
    _posterView = poster;
    [self addSubview:poster];
    UIImageView *logo = [UIImageView new];
    logo.contentMode = UIViewContentModeScaleAspectFit;   // 0xcfe4
    _logoView = logo;
    if (self.image) {
        poster.image = self.image;   // 0xcd94
        poster.contentMode = self.imageFits ? UIViewContentModeScaleAspectFit   // 0xcdac
                                            : UIViewContentModeScaleAspectFill;
        logo.image = self.image;   // 0xd008
        logo.tintColor = UIColor.whiteColor;   // shared tail at 0xd278
    } else {
        // No logo image: the poster shows the "play.rectangle.fill" symbol
        // with contentMode Center (layoutSubviews re-renders it at 28*s
        // points), tinted white at alpha 0.35 (constant read from the
        // original binary at 0x28de8); the logo view falls back to the
        // "car.fill" glyph. Both are unconditional on the style in the
        // original — our previous style-dependent glyph choice was wrong.
        poster.image = [UIImage systemImageNamed:@"play.rectangle.fill"];   // 0xd1bc
        poster.tintColor = [UIColor colorWithWhite:1.0 alpha:0.35];   // 0xd1e4
        poster.contentMode = UIViewContentModeCenter;   // 0xd214
        logo.image = [UIImage systemImageNamed:@"car.fill"];   // 0xd240
        logo.tintColor = UIColor.whiteColor;
    }
    [self addSubview:logo];

    // Content dispatch (dump 0xd068: cmp effective, #3 / b.ne greeting).
    // The weather block exists ONLY when the effective style is 3; the
    // mere presence of weather data never builds it. [Restored fix-round4
    // strand 2 — the previous `if (self.weather)` test (audit-S LP-1)
    // built the weather stack at EVERY style, including the user-selected
    // Greeting style 2, stacking it over the greeting content.]
    if (_sceneStyle == 3) {
        // dump 0xd078-0xd0f8: isDay/code out of weather, category =
        // sub_d4f0(code, isDay), stored in _sky (ivar table slot 0xd18);
        // -ss_buildSky dispatches on it.
        NSDictionary *weather = self.weather;
        BOOL isDay = [weather[@"isDay"] boolValue];
        _sky = SSWeatherCategory([weather[@"code"] integerValue], isDay);
        // [weatherinst — WO GPT 4b, LOG ONLY] The display sink: this is
        // where the weather dict actually becomes category + gradient on
        // screen. Correlate with the [weather] applied line in SSSplash
        // by timestamp; temp=none means the card renders without a real
        // temperature (fallback/no-data dict).
        OMCLogWrite(@"StartupScreen", [NSString stringWithFormat:@"[weather] display category=%ld isDay=%d temp=%@ code=%@ (gradient re-selected from category)",
                    (long)_sky, (int)isDay, weather[@"temp"] ?: @"none", weather[@"code"] ?: @"none"]);
        // dump 0xd10c-0xd35c [VERIFIED — restored fix-round6 weather
        // W-item 3]: BEFORE the weather card is built, the original
        // re-selects the main gradient's colours from the category
        // (split by isDay only where the dump tests w23) and re-asserts
        // the gradient geometry; this setColors: @0xd318 is the LAST
        // write to the main gradient before buildWeatherWithPeriod:.
        // The previous build had no re-selection at all — style 3 kept
        // whatever ss_sceneColors produced. Branch shape follows the
        // dump: (category - 6) unsigned < 3 first, then 5, then 9;
        // the low side tests 0/2 and 1/3; everything else (category 4,
        // >= 10, negatives) lands on the day/night default pair.
        uint32_t rgb1, rgb2;
        if (_sky > 4) {
            if ((uint64_t)(_sky - 6) < 3) {              // 6, 7, 8 @0xd124
                rgb1 = 0x1C2633; rgb2 = 0x33404F;
            } else if (_sky == 5) {                      // @0xd2b0
                rgb1 = 0x5F6670; rgb2 = 0x9AA1AA;
            } else if (_sky == 9) {                      // @0xd174 / @0xd2dc
                if (isDay) { rgb1 = 0x5D6E86; rgb2 = 0xB4C2D3; }
                else       { rgb1 = 0x141B2A; rgb2 = 0x38445A; }
            } else if (isDay) {                          // default day @0xd2c8
                rgb1 = 0x4A5B70; rgb2 = 0x8D9BAD;
            } else {                                     // default night @0xd2f0
                rgb1 = 0x10141F; rgb2 = 0x2A3243;
            }
        } else if (_sky == 0 || _sky == 2) {             // @0xd29c
            rgb1 = 0x2A7FD8; rgb2 = 0x9FD3FF;
        } else if (_sky == 1 || _sky == 3) {             // @0xd198
            rgb1 = 0x02030A; rgb2 = 0x0B1230;
        } else if (isDay) {                              // 4 / negative, day
            rgb1 = 0x4A5B70; rgb2 = 0x8D9BAD;
        } else {                                         // 4 / negative, night
            rgb1 = 0x10141F; rgb2 = 0x2A3243;
        }
        gradient.colors = SSCategoryGradientColors(rgb1, rgb2);   // @0xd300
        gradient.startPoint = CGPointMake(0.5, 0.0);              // @0xd330
        gradient.endPoint = CGPointMake(0.5, 1.0);                // @0xd340
        _sceneStyle = 3;                                          // @0xd348
        [self buildWeatherWithPeriod:period];
    } else {
        [self buildGreetingWithDate:date period:period];
    }

    // Common tail of the original (dump 0xd360-0xd4a8 — the greeting path
    // branches into it at 0xd144, the weather path falls through): _stack
    // (built by either builder) is pinned into self: centred on both axes,
    // width <= self.width - 16, and that width constraint is stored in
    // _stackMaxWidth so -applyUnit: can drive its constant (-12*unit).
    // [Restored fix-round3 G/§8F — the whole pinning block was absent.]
    _stack.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:_stack];
    _stackMaxWidth = [_stack.widthAnchor constraintLessThanOrEqualToAnchor:self.widthAnchor
                                                                   constant:-16.0];
    [NSLayoutConstraint activateConstraints:@[
        [_stack.centerXAnchor constraintEqualToAnchor:self.centerXAnchor],
        [_stack.centerYAnchor constraintEqualToAnchor:self.centerYAnchor],
        _stackMaxWidth]];

    [self setNeedsLayout];
}

// ---------------------------------------------------------------------------
// [integration phase 2 — SUPERSEDED; applied to src in phase 3] The structural body of
//   - (NSArray *)ss_sceneColors {   // 0xd580 [VERIFIED shape: (style, occasion) switch ->
// was removed from this file: the canonical line-level implementation is in
// SSStartupViewScenesB.m — SSStartupView (ScenesB) category. Keeping both would duplicate the method.
// The class-extension declaration is retained (internal callers use it).
// ---------------------------------------------------------------------------

// Greeting text builders at 0xda28 / 0xdb60 / 0xdc18 in the binary assemble
// the bilingual (OMCTr) lines for period/occasion/name. [VERIFIED existence;
// exact wording tables NOT-RECOVERED]
static NSString *SSGreetingLine(NSInteger period, NSInteger occasion) {
    switch (occasion) {
        case 1: return OMCTr(@"Chúc mừng năm mới!", @"Happy New Year!");
        case 3: return OMCTr(@"Giáng sinh vui vẻ!", @"Merry Christmas!");
        case 4: return OMCTr(@"Tết Trung thu vui vẻ!", @"Happy Mid-Autumn Festival!");
        case 5: return OMCTr(@"Chúc mừng năm mới!", @"Happy New Year!");
        default: break;
    }
    switch (period) {
        case 0: return OMCTr(@"Chào buổi sáng", @"Good morning");
        case 1: return OMCTr(@"Chào buổi trưa", @"Good afternoon");
        case 2: return OMCTr(@"Chào buổi tối", @"Good evening");
        default: return OMCTr(@"Chúc ngủ ngon", @"Good night");
    }
}

// ---------------------------------------------------------------------------
// [integration phase 2 — SUPERSEDED; applied to src in phase 3] The structural body of
//   - (void)buildGreetingWithDate:(NSDate *)date period:(NSInteger)period {   // 0xd824 [VERIFIED shape]
// was removed from this file: the canonical line-level implementation is in
// SSStartupViewScenesB.m — SSStartupView (ScenesB) category. Keeping both would duplicate the method.
// The class-extension declaration is retained (internal callers use it).
// ---------------------------------------------------------------------------

// sub_d6f0 @0xd6f0 — [VERIFIED: body read from dump] builds the two-stop
// gradient colour array for a pair of 0xRRGGBB literals: each becomes a
// UIColor with components (rgb >> 16) / 255.0, ((rgb >> 8) & 0xFF) /
// 255.0, (rgb & 0xFF) / 255.0, alpha 1.0, and the array holds the two
// CGColors (arrayWithObjects:count:2; no locations, no other alpha).
// Used only by the style-3 category re-selection in -reload (@0xd300).
static NSArray *SSCategoryGradientColors(uint32_t rgb1, uint32_t rgb2) {
    UIColor *first = [UIColor colorWithRed:(rgb1 >> 16) / 255.0
                                     green:((rgb1 >> 8) & 0xFF) / 255.0
                                      blue:(rgb1 & 0xFF) / 255.0
                                     alpha:1.0];
    UIColor *second = [UIColor colorWithRed:(rgb2 >> 16) / 255.0
                                      green:((rgb2 >> 8) & 0xFF) / 255.0
                                       blue:(rgb2 & 0xFF) / 255.0
                                      alpha:1.0];
    return @[ (id)first.CGColor, (id)second.CGColor ];
}

// sub_d4f0 — [VERIFIED] WMO weather code -> category index 0..9.
// (Local copy for this TU — same body as the ScenesB/Builders copies;
// -reload needs it to fill _sky on the effective-style-3 path.
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

// Weather-condition symbol for an Open-Meteo WMO code.
// [INFERRED table; "cloud.fill" is VERIFIED present. NOTE: this table is
// not sub_d4f0 — that helper is SSWeatherCategory above; the symbol/text
// pairing used by the builders is SSWeatherSymbolAndText (sub_eb68).]
static NSString *SSWeatherSymbolName(NSInteger code, BOOL isDay) {
    if (code == 0) return isDay ? @"sun.max.fill" : @"moon.fill";
    if (code == 1 || code == 2) return isDay ? @"cloud.sun.fill" : @"cloud.moon.fill";
    if (code == 3) return @"cloud.fill";
    if (code == 45 || code == 48) return @"cloud.fog.fill";
    if (code >= 51 && code <= 57) return @"cloud.drizzle.fill";
    if (code >= 61 && code <= 67) return @"cloud.rain.fill";
    if (code >= 71 && code <= 77) return @"cloud.snow.fill";
    if (code >= 80 && code <= 82) return @"cloud.heavyrain.fill";
    if (code == 85 || code == 86) return @"cloud.snow.fill";
    if (code >= 95) return @"cloud.bolt.fill";
    return @"cloud.fill";
}

// ---------------------------------------------------------------------------
// [integration phase 2 — SUPERSEDED; applied to src in phase 3] The structural body of
//   - (void)buildWeatherWithPeriod:(NSInteger)period {   // 0xdcdc [VERIFIED elements]
// was removed from this file: the canonical line-level implementation is in
// SSStartupViewScenesB.m — SSStartupView (ScenesB) category. Keeping both would duplicate the method.
// The class-extension declaration is retained (internal callers use it).
// ---------------------------------------------------------------------------

// ---------------------------------------------------------------------------
// Layout / scale unit
// ---------------------------------------------------------------------------

- (void)layoutSubviews {   // 0xeefc [VERIFIED from the dump — liquidfix round]
    [super layoutSubviews];
    CGRect b = self.bounds;
    // Same scale as ss_buildScene: s = min(H/100, W/260) (0xef74-0xef88;
    // 260.0 read from the original binary at 0x28e90).
    double s = MIN(b.size.height / 100.0, b.size.width / 260.0);
    if (s <= 0) return;   // 0xef8c
    if (_sceneStyle >= 0 && !CGSizeEqualToSize(b.size, _sceneSize))
        [self ss_buildScene];   // 0xefa8 (original re-checks the style sign)
    _posterView.frame = b;   // 0xefc4
    if (_posterView.contentMode == UIViewContentModeCenter) {
        // Poster carries an SF Symbol (no logo image): re-render it at a
        // point size of 28*s (0xeff0-0xf030).
        UIImageSymbolConfiguration *cfg =
            [UIImageSymbolConfiguration configurationWithPointSize:28.0 * s];
        _posterView.image = [_posterView.image imageWithConfiguration:cfg];
    }
    if (_logoView) {
        // The logo is a CENTRED SQUARE, side = min(W*0.5, H*0.62)
        // (0xf058-0xf0b4; 0.62 read from the original binary at 0x28e98) —
        // NOT the full bounds our previous version forced.
        double side = MIN(b.size.width * 0.5, b.size.height * 0.62);
        _logoView.bounds = CGRectMake(0, 0, side, side);
        _logoView.center = CGPointMake(b.size.width * 0.5, b.size.height * 0.5);
        _logoView.layer.shadowRadius = 7.0 * s;
    }
    // Unit update is epsilon-guarded in the original (0xf0c0-0xf0ec):
    // only when |s - _unit| >= 0.01 (constant at 0x28ea0) does it store
    // _unit and re-apply.
    if (fabs(s - _unit) >= 0.01) {
        _unit = s;
        [self applyUnit:s];
    }
}

- (void)applyUnit:(double)unit {   // 0xf110 [VERIFIED from the dump — liquidfix
                                   // round; ivar identities anchored via the
                                   // builder dumps — see liquidfix-notes]
    _unit = unit;
    // Shadow pass over all eight labels (0xf188-0xf2a4): shadowRadius
    // 1.5*unit, shadowOffset (0, 0.5*unit), each label only if non-nil.
    UILabel *labels[] = { _timeLabel, _titleLabel, _dateLabel, _tempLabel,
                          _condLabel, _rangeLabel, _rainLabel, _updatedLabel };
    for (int i = 0; i < 8; i++) {
        UILabel *l = labels[i];
        if (!l) continue;
        l.layer.shadowRadius = 1.5 * unit;
        l.layer.shadowOffset = CGSizeMake(0, 0.5 * unit);
    }
    // Stack width cap (0xf2a8): the single _stackMaxWidth constraint
    // created in -reload is driven to -12*unit on the common path (both
    // content branches). No nil check in the original — messaging nil is
    // a no-op. [Restored fix-round3 G/§8F.]
    _stackMaxWidth.constant = -12.0 * unit;
    if (_timeLabel) {
        // Greeting branch (0xf2c4): time/title/date only, then the tail.
        _timeLabel.font = SSFont(30 * unit, UIFontWeightLight);
        _titleLabel.font = SSFont(10 * unit, UIFontWeightSemibold);
        _dateLabel.font = SSFont(6 * unit, UIFontWeightMedium);
    } else if (_tempLabel) {
        // Weather branch (0xf374): fonts, icon size, stack metrics, card.
        _titleLabel.font = SSFont(7 * unit, UIFontWeightSemibold);
        _tempLabel.font = SSFont(30 * unit, UIFontWeightMedium);
        _condLabel.font = SSFont(7.5 * unit, UIFontWeightSemibold);
        _rangeLabel.font = SSFont(6 * unit, UIFontWeightMedium);
        _rainLabel.font = SSFont(5.5 * unit, UIFontWeightMedium);
        _updatedLabel.font = SSFont(4.2 * unit, UIFontWeightRegular);   // 4.2 at 0x28ea8
        _iconH.constant = 32 * unit;   // ivar-table 0xcf8
        _iconW.constant = 32 * unit;   // ivar-table 0xcfc
        _row.spacing = 4 * unit;   // ivar-table 0xcbc
        [_row setCustomSpacing:6 * unit afterView:_tempLabel];
        _cardStack.spacing = 1.2 * unit;   // ivar-table 0xcb8; 1.2 at 0x28eb0
        _card.layer.cornerRadius = 5.5 * unit;   // ivar-table 0xcf0; 5.5 per dump (fmul 0xf45c-0xf460 -> setCornerRadius: 0xf568)
        // The 4 card-inset constraints live in _cardInsets (original
        // NSArray ivar, table slot 0xd00 — subscripted directly at
        // 0xf584-0xf61c: [0]/[1] -> 5*unit, [2]/[3] -> 3.5*unit). An
        // earlier integration phase mistakenly subscripted _stackMaxWidth
        // here; that ivar is the single width-cap constraint above.
        // [Corrected fix-round3 G/§8F.]
        if (_cardInsets.count > 0) ((NSLayoutConstraint *)_cardInsets[0]).constant = 5 * unit;
        if (_cardInsets.count > 1) ((NSLayoutConstraint *)_cardInsets[1]).constant = 5 * unit;
        if (_cardInsets.count > 2) ((NSLayoutConstraint *)_cardInsets[2]).constant = 3.5 * unit;
        if (_cardInsets.count > 3) ((NSLayoutConstraint *)_cardInsets[3]).constant = 3.5 * unit;
    }
    // Common tail at 0xf638 (ivar-table 0xcc0): in the dump it is reached
    // ONLY from a taken branch above — the greeting branch jumps in at
    // 0xf370, the weather branch falls through; with neither label
    // population present the original skips it (0xf37c -> 0xf64c). The
    // branch tests themselves are the dump's: ivar @0xcd8 (_timeLabel) at
    // 0xf2c4, then ivar @0xcec (_tempLabel) at 0xf37c — applyUnit reads
    // no _sceneStyle; the metric branch follows the effective style
    // indirectly, because the dispatch in -reload (fix-round4 S1)
    // guarantees exactly the label population that style builds.
    // [Tail guard restored fix-round4 strand 2 (audit-S LP-3).]
    if (_timeLabel || _tempLabel) _stack.spacing = 3 * unit;
}

// ---------------------------------------------------------------------------
// Intro + animation clock
// ---------------------------------------------------------------------------

- (void)playIntro {   // 0xf768 [logo branches restored from the dump,
                     // fix-round4 — replaces the merged INFERRED variant;
                     // the no-logo tail at the bottom is NOT from this
                     // dump pass and stays as reconstructed earlier]
    [self layoutIfNeeded];
    double s1 = MAX(_unit, 1.0);   // 0xf790-0xf7a4: max(_unit, 1)
    if (_logoView) {
        UIView *logoView = _logoView;
        CALayer *layer = logoView.layer;
        [layer removeAllAnimations];          // 0xf7d4
        layer.shadowOpacity = 0.0;            // 0xf7f4
        logoView.alpha = 0.0;                 // 0xf804
        // Branch source (0xf814, re-read at 0xf928): self.logoEffect —
        // the NSInteger property SSSplash assigns from the pref
        // @"startupScreenLogoEffect" (default 0). 1 -> spring scale-in;
        // 2 -> identity + ssGlow shadow pulse; anything else -> the
        // 0.96 settle. No branch but 2 touches the layer shadow: the
        // logo keeps layoutSubviews' shadowRadius 7*_unit, and the
        // shadowOpacity zeroed above stays 0 for effects 1 and 3.
        NSInteger effect = self.logoEffect;
        if (effect == 1) {
            logoView.transform = CGAffineTransformMakeScale(0.5, 0.5);   // 0xf820
            [UIView animateWithDuration:1.1 delay:0.1        // @0x28ec8 / @0x28ed0
                  usingSpringWithDamping:0.7                 // @0x28e10
                  initialSpringVelocity:0.0 options:0 animations:^{
                logoView.alpha = 1.0;                        // sub_fd2c
                logoView.transform = CGAffineTransformIdentity;
            } completion:nil];
        } else if (effect == 2) {
            logoView.transform = CGAffineTransformIdentity;  // 0xf934
            layer.shadowColor = UIColor.whiteColor.CGColor;  // 0xf958
            layer.shadowOffset = CGSizeZero;                 // 0xf9a8
            layer.shadowRadius = 7.0 * s1;                   // 0xf9dc: 7*max(_unit,1)
            layer.shadowOpacity = 0.6f;                      // float @0x29424
            CABasicAnimation *glow = [CABasicAnimation animationWithKeyPath:@"shadowOpacity"];
            glow.fromValue = @0.0;                           // const NSNumber @0x35710
            glow.toValue = @0.95;                            // const NSNumber @0x35720
            glow.duration = 1.2;                             // @0x28eb0
            glow.autoreverses = YES;
            glow.repeatCount = HUGE_VALF;
            glow.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
            [layer addAnimation:glow forKey:@"ssGlow"];      // 0xfae4
            [UIView animateWithDuration:0.9 animations:^{     // @0x28e70; sub_fd80
                logoView.alpha = 1.0;
            }];
        } else {
            logoView.transform = CGAffineTransformMakeScale(0.96, 0.96);   // @0x28eb8
            [UIView animateWithDuration:1.2 delay:0.05       // @0x28eb0 / @0x28ec0
                  options:0 animations:^{                    // sub_fd8c
                logoView.alpha = 1.0;
                logoView.transform = CGAffineTransformIdentity;
            } completion:nil];
        }
        return;
    }
    [self ss_applyTime:0];
    [self ss_startLink];
}

- (double)ss_now {   // [INFERRED bookkeeping: elapsed seconds since _t0]
    return CACurrentMediaTime() - _t0;
}

- (void)ss_startLink {   // 0xfef4 [VERIFIED]
    if (_link) return;
    if (!self.window) return;
    if (self.duration < 0) return;
    _t0 = CACurrentMediaTime() - _restTime;
    SSLinkTarget *target = [SSLinkTarget new];
    target.owner = self;
    CADisplayLink *link = [CADisplayLink displayLinkWithTarget:target selector:@selector(step:)];
    link.preferredFrameRateRange = CAFrameRateRangeMake(30, 60, 60);   // [INFERRED range values]
    [link addToRunLoop:NSRunLoop.mainRunLoop forMode:NSRunLoopCommonModes];
    _link = link;
    _playing = YES;
}

- (void)ss_stopLink {
    [_link invalidate];
    _link = nil;
    _playing = NO;
}

- (void)ss_step {   // 0x100b0 [VERIFIED]
    double t = [self ss_now];
    if (t < 0) { [self ss_stopLink]; return; }
    if (!self.window) { [self ss_stopLink]; return; }
    [self ss_applyTime:t];
}

- (void)ss_applyTime:(double)t {   // 0x1013c [VERIFIED]
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    for (SSFade *fade in _fades) [fade applyTime:t];
    [self ss_applyMotes:t];
    switch (_sceneStyle) {   // style names VERIFIED from the Settings bundle;
                             // numeric scene assignment INFERRED (see report)
        case 4: [self ss_applyEngine:t]; break;    // Engine
        case 7: [self ss_applyHud:t]; break;       // HUD
        case 3: [self ss_applySky:t]; break;       // Weather (sky dressing)
        case 5: [self ss_applyWelcome:t]; break;   // Welcome
        default: break;
    }
    [_canvas setNeedsDisplay];
    [CATransaction commit];
}

- (void)didMoveToWindow {
    [super didMoveToWindow];
    if (self.window && _sceneBuilt) [self ss_startLink];
    else if (!self.window) [self ss_stopLink];
}

// ---------------------------------------------------------------------------
// Scene construction
// ---------------------------------------------------------------------------

- (void)ss_clearScene {   // 0x10310 [VERIFIED]
    [self ss_stopLink];
    [_scene removeFromSuperview];
    [_glass removeFromSuperview];
    _scene = nil; _glass = nil; _canvas = nil;
    _fades = [NSMutableArray array];
    _motes = [NSMutableData data];
    _moteLayers = [NSMutableArray array];
    _gauges = [NSMutableArray array];
    _particles = [NSMutableData data];
    _bursts = [NSMutableData data];
    _rings = [NSMutableArray array];
    _outline = nil; _wheels = nil; _wetMask = nil;
    _flash = nil; _horizon = nil; _rays = nil; _wiper = nil;
    _lightning = nil; _radar = nil;
    _sceneBuilt = NO;
}

- (void)ss_buildScene {   // 0x10570 [VERIFIED dispatch; head geometry restored
                          // from the dump at 0x10570-0x1063c — liquidfix round]
    [self ss_clearScene];
    CGRect b = self.bounds;
    _sceneSize = b.size;   // stored BEFORE the guards in the original (0x10598)
    // Scene scale s = min(H/100, W/260) (100.0 at 0x105ac; 260.0 read from the
    // original binary at 0x28e90). Guards (0x105d8/0x105dc): a negative scene
    // style or s <= 0 returns with the scene left cleared.
    double s = MIN(b.size.height / 100.0, b.size.width / 260.0);
    if (_sceneStyle < 0 || s <= 0) return;
    // Design canvas 1600x600, cover-fitted: _k = s/6 (store at 0x105f4),
    // _ox = (W - 1600*_k)/2 (0x10614), _oy = (H - 600*_k)/2 (0x10634;
    // -600.0 read from the binary at 0x28ee0). These are the ONLY stores to
    // _k/_ox/_oy in the whole original binary — every scene builder reads
    // them, and our tree previously never assigned them (all zero), which
    // collapsed every builder's geometry to the top-left corner at scale 0.
    _k = s / 6.0;
    _ox = (b.size.width - 1600.0 * _k) * 0.5;
    _oy = (b.size.height - 600.0 * _k) * 0.5;
    UIView *scene = [[UIView alloc] initWithFrame:b];
    scene.userInteractionEnabled = NO;
    [self insertSubview:scene atIndex:0];
    _scene = scene;
    switch (_sceneStyle) {   // cmp chain at 0x10690-0x10740 covers values 3-9, 11;
                             // style names VERIFIED from Settings, mapping INFERRED.
                             // The original's default case builds NOTHING (falls
                             // through to 0x10744) — no Sky fallback.
        case 3: [self ss_buildSky]; break;         // Weather backdrop
        case 4: [self ss_buildEngine]; break;      // Engine
        case 5: [self ss_buildWelcome]; break;     // Welcome
        case 6: [self ss_buildParticles]; break;   // Particles
        case 7: [self ss_buildHud]; break;         // HUD
        case 8: [self ss_buildBriefing]; break;    // Briefing
        case 9: [self ss_buildLiquid]; break;      // Liquid
        case 11: [self ss_buildFestive]; break;    // Occasion
        default: break;
    }
    _sceneBuilt = YES;
    [self ss_applyTime:[self ss_now]];
    if (_playing) [self ss_startLink];
}

- (UIView *)ss_host {   // [NOT-RECOVERED: purpose not determined; listed in the report]
    return _scene;
}

- (void)ss_addCanvas {   // 0x107f4 [VERIFIED]
    SSCanvasView *canvas = [[SSCanvasView alloc] initWithFrame:self.bounds];
    canvas.owner = self;
    canvas.opaque = NO;
    canvas.backgroundColor = UIColor.clearColor;
    canvas.userInteractionEnabled = NO;
    canvas.contentScaleFactor = self.window.screen.scale ?: UIScreen.mainScreen.scale;
    canvas.contentMode = UIViewContentModeScaleToFill;
    [_scene addSubview:canvas];
    _canvas = canvas;
}

- (UILabel *)ss_label:(NSString *)text at:(CGPoint)point size:(double)size
               weight:(UIFontWeight)weight color:(UIColor *)color
                 left:(BOOL)left in:(UIView *)container maxWidth:(double)maxWidth {   // 0x108c8 [VERIFIED — rewritten fix-round3 D6:
    // the previous transcription dropped the internal _k scaling of `size`,
    // the left-edge semantics of `at:` for left-aligned labels, the
    // SSSceneLabel factory and the width clamp. See work/fix-round3/audit-D6.md]
    UILabel *label = SSSceneLabel(text);                        // sub_da28
    label.font = SSFont(MAX(size * _k, 1.0), weight);           // 0x10940: size*_k, fmaxnm 1.0 -> sub_f6ac
    label.textColor = color ?: UIColor.whiteColor;
    label.textAlignment = left ? NSTextAlignmentLeft : NSTextAlignmentCenter;   // eor w2, left, #1
    label.layer.shadowOpacity = 0.4f;                           // float @0x29428
    label.layer.shadowRadius = MAX(7.0 * _k, 1.0);              // 0x109ec: max(7*_k, 1)
    label.layer.shadowOffset = CGSizeZero;
    label.layer.shouldRasterize = YES;
    double displayScale = self.traitCollection.displayScale;    // 0x10a58
    label.layer.rasterizationScale = displayScale > 0 ? displayScale : 2.0;   // 0x10aa0 fcsel
    CGSize fit = [label sizeThatFits:CGSizeMake(DBL_MAX, DBL_MAX)];           // 0x10ad0: unconstrained
    double limit;                                               // 0x10aec-0x10b1c
    if (maxWidth > 0) limit = maxWidth;
    else if (left) limit = (container.bounds.size.width - point.x) - 6.0 * _k;
    else limit = container.bounds.size.width - 12.0 * _k;
    double width = MIN(ceil(fit.width), MAX(limit, 10.0));      // 0x10b20-0x10b34
    label.bounds = CGRectMake(0, 0, width, ceil(fit.height));   // 0x10b38-0x10b4c
    label.center = CGPointMake(left ? point.x + width * 0.5 : point.x, point.y);   // 0x10b50-0x10b6c
    [container addSubview:label];
    return label;
}

- (SSFade *)ss_fade:(UIView *)view from:(double)from to:(double)to alpha:(double)alpha {   // 0x10bb4 [VERIFIED]
    SSFade *fade = [SSFade new];
    fade.view = view;
    fade.inA = from;
    fade.inB = to;
    fade.alpha = alpha;
    [_fades addObject:fade];
    return fade;
}

// Mote records in _motes (NSMutableData): 56-byte SSMoteRecords appended
// verbatim by ss_addMote:layer:to:. [VERIFIED line-level — writer 0x10c60,
// consumer 0x10cf0 with its core loop at 0x10d50; final closure 2026-11-08
// supersedes the legacy 48-byte {x,y,phase,speed,size,kind} shape and the
// arc4random writer that earlier drafts carried here.]
// Field meaning per kind (writers: SSStartupViewBuilders.m):
//   kind 0 rain:     f1=x, f2=y0, f3=fall-rate factor, f4=streak length
//                    (baked into the layer's path; unused by the consumer)
//   kind 1 stars:    f4=radius (unused here), f6=twinkle phase
//   kind 2 fog:      f1=x0, f2=y, f3=drift speed
//   kind 3 cloud:    f1=x0, f2=y, f3=drift speed, f5=cloud width
//   kind 4 snow:     f1=x0, f2=y0, f3=fall speed, f4=radius, f6=phase
//   kind 5 petals:   f1=x0, f2=y0 (starts in [-H,0)), f3=fall speed,
//                    f4=size (unused here), f5=sway rate, f6=phase
//   kind 6 confetti: f1=x0, f2=y0 (starts in [-H,0)), f3=fall speed, f6=phase
//   kind 7 moons:    f1=x, f6=rise stagger offset
// The "+" floor terms in kinds 2/5/6/7 are transcribed exactly as the
// binary computes them (base + (period - 2*margin) * floor(base / period));
// they are NOT fmod — combined with the spawn ranges they make each mote
// perform a single pass over the scene during the splash's lifetime.
- (void)ss_addMote:(SSMoteRecord)record layer:(CALayer *)layer to:(CALayer *)container {   // 0x10c60 [VERIFIED]
    [_motes appendBytes:&record length:sizeof(record)];   // length 0x38 in the binary
    [_moteLayers addObject:layer];
    [container addSublayer:layer];
}

- (void)ss_applyMotes:(double)t {   // 0x10cf0, core loop 0x10d50 [VERIFIED line-level]
    NSUInteger count = _moteLayers.count;
    if (count == 0) return;
    const SSMoteRecord *motes = _motes.bytes;
    double W = _sceneSize.width, H = _sceneSize.height, u = _k;
    for (NSUInteger i = 0; i < count; i++) {
        const SSMoteRecord *m = &motes[i];
        CALayer *layer = _moteLayers[i];
        switch (m->kind) {
            case 0: {   // rain: x fixed at f1; y falls at 60*f3*u, fmod over H
                double y = m->f2 + 60.0 * t * m->f3 * u;
                if (H > 0) y -= H * floor(y / H);
                layer.position = CGPointMake(m->f1, y);
                break;
            }
            case 1: {   // stars: twinkle only, position untouched
                layer.opacity = (float)(0.4 + 0.6 * fabs(sin(2.0 * t + m->f6)));
                break;
            }
            case 2: {   // fog: x drifts, wrapped over W + 600u, shifted -300u; y fixed
                double x = m->f1 + t * m->f3;
                double period = W + 600.0 * u;
                if (period > 0) x += (W - 600.0 * u) * floor(x / period);
                x -= 300.0 * u;
                layer.position = CGPointMake(x, m->f2);
                break;
            }
            case 3: {   // cloud: x drifts, true fmod over W + width, centred by -width/2; y fixed
                double x = m->f1 + t * m->f3;
                double period = W + m->f5;
                if (period > 0) x -= period * floor(x / period);
                x -= 0.5 * m->f5;
                layer.position = CGPointMake(x, m->f2);
                break;
            }
            case 4: {   // snow: y falls, true fmod over H + 4*radius, resting -2*radius;
                        // x sways +/-10u at sin(t + phase)
                double y = m->f2 + t * m->f3;
                double period = H + 4.0 * m->f4;
                if (period > 0) y -= period * floor(y / period);
                y -= 2.0 * m->f4;
                double x = m->f1 + 10.0 * sin(t + m->f6) * u;
                layer.position = CGPointMake(x, y);
                break;
            }
            case 5: {   // Tet petals: y falls (single-pass "+" wrap over H + 40u,
                        // resting -20u); x sways +/-30u at sin(t*swayRate + phase);
                        // spins at t + phase
                double y = m->f2 + t * m->f3;
                double period = H + 40.0 * u;
                if (period > 0) y += (H - 40.0 * u) * floor(y / period);
                y -= 20.0 * u;
                double x = m->f1 + 30.0 * sin(t * m->f5 + m->f6) * u;
                layer.position = CGPointMake(x, y);
                layer.transform = CATransform3DMakeRotation(t + m->f6, 0, 0, 1);
                break;
            }
            case 6: {   // confetti: y falls (single-pass "+" wrap over H + 30u,
                        // resting -15u); x sways +/-20u at sin(2t + phase);
                        // spins at 3t + phase
                double y = m->f2 + t * m->f3;
                double period = H + 30.0 * u;
                if (period > 0) y += (H - 30.0 * u) * floor(y / period);
                y -= 15.0 * u;
                double x = m->f1 + 20.0 * sin(2.0 * t + m->f6) * u;
                layer.position = CGPointMake(x, y);
                layer.transform = CATransform3DMakeRotation(3.0 * t + m->f6, 0, 0, 1);
                break;
            }
            case 7: {   // Mid-Autumn moons: x fixed at f1; rises at 50u/s from
                        // below the bottom edge, staggered by f6
                double v = 50.0 * t * u + m->f6;
                double period = H + 120.0 * u;
                if (period > 0) v += (H - 120.0 * u) * floor(v / period);
                layer.position = CGPointMake(m->f1, H - v + 60.0 * u);
                break;
            }
            default: break;   // kinds outside 0-7: layer left untouched
        }
    }
}

// ---------------------------------------------------------------------------
// Scene: Sky (weather-driven backdrop dressing) — 0x11124 / apply 0x126b0
// [VERIFIED elements: sun/moon rays rotation, cloud symbol, wiper wet-mask
//  sweep rebuilt per frame from CGPath arcs, lightning flash via pow curves]
// ---------------------------------------------------------------------------

// ---------------------------------------------------------------------------
// [integration phase 2 — SUPERSEDED; applied to src in phase 3] The structural body of
//   - (void)ss_buildSky {
// was removed from this file: the canonical line-level implementation is in
// SSStartupViewBuilders.m — SSStartupView (Builders) category. Keeping both would duplicate the method.
// The class-extension declaration is retained (internal callers use it).
// ---------------------------------------------------------------------------

- (void)ss_applySky:(double)t {   // 0x126b0 [VERIFIED shape]
    if (_rays) _rays.transform = CATransform3DMakeRotation(t * 0.02, 0, 0, 1);
    if (_flash) _flash.opacity = (float)MAX(0.0, pow(MAX(0.0, sin(t * 0.7)), 24.0) - 0.9);
    if (_wetMask) {
        double sweep = 0.5 + 0.5 * sin(t * 0.9);
        CGMutablePathRef path = CGPathCreateMutable();
        CGRect bounds = self.bounds;
        CGPathAddRect(path, NULL, bounds);
        CGPathMoveToPoint(path, NULL, _wiperPivot.x, _wiperPivot.y);
        CGPathAddArc(path, NULL, _wiperPivot.x, _wiperPivot.y, _wiperLength,
                     sweep - 0.4, sweep + 0.4, NO);
        CGPathCloseSubpath(path);
        _wetMask.path = path;
        CGPathRelease(path);
        _cleared = sweep;
    }
}

// ---------------------------------------------------------------------------
// Scene: Engine (dashboard gauges) — gauge 0x12a98, build 0x134b8,
// set 0x13f60, apply 0x14158 [VERIFIED elements]
// ---------------------------------------------------------------------------

// ---------------------------------------------------------------------------
// [integration phase 2 — SUPERSEDED; applied to src in phase 3] The structural body of
//   - (SSGauge *)ss_gaugeAt:(CGPoint)center radius:(double)radius label:(NSString *)label
// was removed from this file: the canonical line-level implementation is in
// SSStartupViewScenesB.m — SSStartupView (ScenesB) category. Keeping both would duplicate the method.
// The class-extension declaration is retained (internal callers use it).
// ---------------------------------------------------------------------------

// ---------------------------------------------------------------------------
// [integration phase 2 — SUPERSEDED; applied to src in phase 3] The structural body of
//   - (void)ss_buildEngine {   // [VERIFIED strings: SPEED, RPM, km/h / mph, x1000 rpm, ABS]
// was removed from this file: the canonical line-level implementation is in
// SSStartupViewScenesB.m — SSStartupView (ScenesB) category. Keeping both would duplicate the method.
// The class-extension declaration is retained (internal callers use it).
// ---------------------------------------------------------------------------

- (void)ss_setGauge:(SSGauge *)gauge value:(double)value {   // 0x13f60 [VERIFIED —
    // semantics corrected by verifier #6: the value is fraction-scale and
    // ONLY the arc's strokeEnd consumes it clamped; needle, hot test and
    // number consume the RAW value. There is NO value/gauge.max division
    // in the binary (no fdiv in the function) — an earlier draft invented
    // one, sent strokeEnd to gauge.fill.mask, and used >= for hot.]
    double frac = MAX(0.0, MIN(1.0, value));
    gauge.arc.strokeEnd = (CGFloat)frac;   // fcsel clamp pair @0x13f88-0x13f9c;
                                           // setStrokeEnd: on gauge.arc @0x13fb8
    gauge.needle.transform = CATransform3DMakeRotation(M_PI * 0.75 + value * M_PI * 1.5, 0, 0, 1);
                                           // 3pi/4 (@0x29050) + raw * 3pi/2
                                           // (@0x29068); fmadd @0x13fd4 reads raw
    gauge.shown = (NSInteger)round(value * gauge.max);   // fcvtas(raw * max)
                                           // @0x140c4 — round-to-nearest of the
                                           // raw product, NOT (NSInteger)(frac * max)
    gauge.number.text = [NSString stringWithFormat:@"%ld", (long)gauge.shown];
    gauge.hot = value > gauge.red;         // strict >; fcmp @0x1403c / @0x14054
                                           // reads the raw value against red
    UIColor *fillTop = gauge.hot
        ? [UIColor colorWithRed:0xFF / 255.0 green:0x5C / 255.0 blue:0x54 / 255.0 alpha:1.0]   // 0xFF5C54
        : UIColor.whiteColor;                                                                  // 0xFFFFFF
    gauge.fill.colors = @[(id)fillTop.CGColor,
                          (id)[UIColor colorWithRed:0x7F / 255.0 green:0xD3 / 255.0
                                               blue:0xFF / 255.0 alpha:1.0].CGColor];   // bottom stays 0x7FD3FF
    gauge.number.textColor = gauge.hot ? UIColor.redColor : UIColor.whiteColor;   // [INFERRED]
}

- (void)ss_applyEngine:(double)t {   // 0x14158 [SUBSTITUTED at integration phase 2 —
    // the structural body in src was WRONG: it scaled by gauge.max * 0.62 /
    // * 0.71 and used a pow(min(1,t/2.5),2) sweep; NO such multiplication or
    // factors exist in the instruction stream (disasm/builders/
    // applyEngine.txt, 0x14158-0x14384; closure addendum to
    // StartupScreenB_REPORT.md). The binary emits PURE FRACTIONS in [0,1],
    // composing with the verified ss_setGauge: fraction semantics:
    //   sweep: 0 outside [0.4, 2.3]; rising easeInOutCubic((t-0.4)/0.9) on
    //          [0.4, 1.3]; falling 1 - easeInOutCubic((t-1.3)/1.0) on
    //          [1.3, 2.3] (x clamped to [0,1]; cubic 4x^3 below 0.5,
    //          1-(-2x+2)^3/2 above).
    //   wobble (idle): 0.08 + 0.004*sin(9t) — read from the dump: computed
    //          at 0x141d0-0x141ec ONLY on the path where t > 2.3 (fcmp vs
    //          2.3 @0x141c4, b.le skips it), i.e. after the sweep ends; the
    //          closure addendum's prose says 'for t <= 2.3', which the
    //          instruction stream contradicts — the dump governs. Flagged
    //          in the phase-2 log.
    //   gauges[0] <- max(sweep, wobble) (fcmp/fcsel @0x14208-0x1420c);
    //   gauges[1] <- sweep.]
    if (_gauges.count < 2) return;
    double sweep = 0;
    if (t >= 0.4 && t < 1.3) {
        double x = MAX(0.0, MIN(1.0, (t - 0.4) / 0.9));
        sweep = (x < 0.5) ? 4.0 * x * x * x : 1.0 - pow(-2.0 * x + 2.0, 3.0) / 2.0;
    } else if (t >= 1.3 && t <= 2.3) {
        double x = MAX(0.0, MIN(1.0, (t - 1.3) / 1.0));
        double e = (x < 0.5) ? 4.0 * x * x * x : 1.0 - pow(-2.0 * x + 2.0, 3.0) / 2.0;
        sweep = 1.0 - e;
    }
    double wobble = 0;
    if (t > 2.3) wobble = 0.08 + 0.004 * sin(9.0 * t);   // @0x141d0-0x141ec
    [self ss_setGauge:_gauges[0] value:MAX(sweep, wobble)];
    [self ss_setGauge:_gauges[1] value:sweep];
}

// ---------------------------------------------------------------------------
// Scene: Welcome — 0x14384 / apply 0x14b78 [VERIFIED shape: greeting stack +
// logo with fade envelopes; apply drives pow-based emphasis]
// ---------------------------------------------------------------------------

// ---------------------------------------------------------------------------
// [integration phase 2 — SUPERSEDED; applied to src in phase 3] The structural body of
//   - (void)ss_buildWelcome {   // [VERIFIED shape: greeting/name/car-name labels,
// was removed from this file: the canonical line-level implementation is in
// SSStartupViewScenesB.m — SSStartupView (ScenesB) category. Keeping both would duplicate the method.
// The class-extension declaration is retained (internal callers use it).
// ---------------------------------------------------------------------------

- (void)ss_applyWelcome:(double)t {
    double p = pow(MIN(1.0, MAX(0.0, t / 3.0)), 2.0);
    _stack.alpha = (CGFloat)p;
}

// ---------------------------------------------------------------------------
// Scene: Particles — build 0x14d50, draw 0x15628
// [VERIFIED: raw CGContext rects, blend mode, sin/pow motion; "OmniCar" title]
// ---------------------------------------------------------------------------

typedef struct { double x, y, vx, vy, size, phase; } SSParticle;

// ---------------------------------------------------------------------------
// [integration phase 2 — SUPERSEDED; applied to src in phase 3] The structural body of
//   - (void)ss_buildParticles {
// was removed from this file: the canonical line-level implementation is in
// SSStartupViewBuilders.m — SSStartupView (Builders) category. Keeping both would duplicate the method.
// The class-extension declaration is retained (internal callers use it).
// ---------------------------------------------------------------------------

- (void)ss_drawParticles:(CGContextRef)ctx t:(double)t {
    CGContextSetBlendMode(ctx, kCGBlendModeScreen);
    NSUInteger count = _particles.length / sizeof(SSParticle);
    const SSParticle *particles = _particles.bytes;
    CGSize size = _sceneSize;
    for (NSUInteger i = 0; i < count; i++) {
        double drift = fmod(particles[i].y + t * 0.02 * (1 + particles[i].size / 4), 1.0);
        double x = particles[i].x * size.width + 10 * sin(t + particles[i].phase);
        double y = (1.0 - drift) * size.height;
        double a = 0.25 + 0.75 * pow(0.5 + 0.5 * sin(t * 2 + particles[i].phase), 2.0);
        CGContextSetRGBFillColor(ctx, 1, 1, 1, (CGFloat)a);
        CGContextFillRect(ctx, CGRectMake(x, y, particles[i].size, particles[i].size));
    }
}

// ---------------------------------------------------------------------------
// Scene: HUD checklist — build 0x15ad0, apply 0x16860
// [VERIFIED elements: READY header, percent label 0%->100%, rows from _hud
//  {text, ok} with "!" badge for failed rows]
// ---------------------------------------------------------------------------

// ---------------------------------------------------------------------------
// [integration phase 2 — SUPERSEDED; applied to src in phase 3] The structural body of
//   - (void)ss_buildHud {
// was removed from this file: the canonical line-level implementation is in
// SSStartupViewBuilders.m — SSStartupView (Builders) category. Keeping both would duplicate the method.
// The class-extension declaration is retained (internal callers use it).
// ---------------------------------------------------------------------------

- (void)ss_applyHud:(double)t {   // [VERIFIED shape: eased percent count-up]
    double p = pow(MIN(1.0, MAX(0.0, t / 2.0)), 3.0);
    NSInteger percent = (NSInteger)lrint(p * 100);
    if (percent != _percentShown) {
        _percentShown = percent;
        _percentLabel.text = [NSString stringWithFormat:@"%ld%%", (long)percent];
    }
    _percentLabel.transform = CGAffineTransformMakeScale(1 + 0.05 * sin(t * 2), 1 + 0.05 * sin(t * 2));
}

// ---------------------------------------------------------------------------
// Scene: Briefing — 0x16af8 [VERIFIED elements: greeting + weather summary
// ("%ld%% chance of rain", temp/high/low) + next event + battery rows]
// ---------------------------------------------------------------------------

// ---------------------------------------------------------------------------
// [integration phase 2 — SUPERSEDED; applied to src in phase 3] The structural body of
//   - (void)ss_buildBriefing {
// was removed from this file: the canonical line-level implementation is in
// SSStartupViewBuilders.m — SSStartupView (Builders) category. Keeping both would duplicate the method.
// The class-extension declaration is retained (internal callers use it).
// ---------------------------------------------------------------------------

// ---------------------------------------------------------------------------
// Scene: Liquid — 0x17bb4 [VERIFIED: gradient blobs with CABasicAnimations
// ssBreathe (position), ssDrift (transform.translation.x), ssSweep
// (transform.translation.y); titles "OmniCar" / "The power of CarPlay"]
// ---------------------------------------------------------------------------

// ---------------------------------------------------------------------------
// [integration phase 2 — SUPERSEDED; applied to src in phase 3] The structural body of
//   - (void)ss_buildLiquid {
// was removed from this file: the canonical line-level implementation is in
// SSStartupViewBuilders.m — SSStartupView (Builders) category. Keeping both would duplicate the method.
// The class-extension declaration is retained (internal callers use it).
// ---------------------------------------------------------------------------

// ---------------------------------------------------------------------------
// Scene: Festive (occasions) — build 0x18af0, draw 0x19f4c
// [VERIFIED elements: "Happy birthday!" / "Happy birthday, %@!" /
//  "Enjoy the drive today"; fireworks bursts drawn as ellipses with sin/pow]
// ---------------------------------------------------------------------------

typedef struct { double x, y, start, hue; } SSFirework;

// ---------------------------------------------------------------------------
// [integration phase 2 — SUPERSEDED; applied to src in phase 3] The structural body of
//   - (void)ss_buildFestive {
// was removed from this file: the canonical line-level implementation is in
// SSStartupViewBuilders.m — SSStartupView (Builders) category. Keeping both would duplicate the method.
// The class-extension declaration is retained (internal callers use it).
// ---------------------------------------------------------------------------

- (void)ss_drawFireworks:(CGContextRef)ctx t:(double)t {
    CGContextSetBlendMode(ctx, kCGBlendModeScreen);
    NSUInteger count = _bursts.length / sizeof(SSFirework);
    const SSFirework *bursts = _bursts.bytes;
    CGSize size = _sceneSize;
    for (NSUInteger i = 0; i < count; i++) {
        double age = fmod(t - bursts[i].start, 4.2);
        if (age < 0) continue;
        double radius = pow(age, 1.5) * 60;
        double alpha = MAX(0, 1 - age / 2.0);
        for (NSInteger spark = 0; spark < 24; spark++) {
            double angle = spark * (2 * M_PI / 24) + bursts[i].hue;
            double x = bursts[i].x * size.width + radius * cos(angle);
            double y = bursts[i].y * size.height + radius * sin(angle) + 20 * pow(age, 2);
            CGContextSetRGBFillColor(ctx, 1, 0.8, 0.4, (CGFloat)alpha);
            CGContextFillEllipseInRect(ctx, CGRectMake(x, y, 3, 3));
        }
    }
}

- (void)ss_drawCanvas:(CGContextRef)ctx size:(CGSize)size {   // 0x1a30c [signature
                                   // restored fix-round3 G/§8E: the original
                                   // takes the CGContextRef (nil-checked at
                                   // 0x1a31c) and forwards it to the two draw
                                   // helpers — it does not fetch the current
                                   // context itself. Dispatch below unchanged.]
    if (!ctx) return;
    double t = [self ss_now];
    if (_sceneStyle == 6) [self ss_drawParticles:ctx t:t];        // Particles [INFERRED number]
    else if (_sceneStyle == 11) [self ss_drawFireworks:ctx t:t];  // Occasion/festive
}

@end
