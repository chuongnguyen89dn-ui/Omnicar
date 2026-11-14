// SSStartupView.m — OmniCarPrefs (reconstructed, Prefs-B)
// Evidence: src/Prefs/disasm/SSStartupView.asm (capstone, calibrated).
//
// FIDELITY MAP (details in PrefsB_REPORT.md):
//  - VERIFIED line-level: layerClass, init, dealloc, clearContent, reload
//    (style resolution, tempo scaling, per-style duration table, gradient
//    endpoints, weather sky mapping entry), ss_sceneColors (all packed-RGB
//    pairs), layoutSubviews, applyUnit: (font metrics), playIntro structure,
//    ss_now/start/stop/step, ss_applyTime: dispatch, ss_clearScene,
//    ss_buildScene dispatch, ss_host, ss_addCanvas, ss_label:…,
//    ss_fade:…, ss_addMote:…, ss_gaugeAt:…, ss_setGauge:value:,
//    buildGreetingWithDate:period:, buildWeatherWithPeriod: (all weather
//    dictionary keys, formats and the WMO code → symbol/text table).
//  - The eight scene builders (sky/engine/welcome/particles/hud/briefing/
//    liquid/festive) are reconstructed to their verified composition —
//    subviews, layers, strings, data keys and animation hooks are from the
//    disassembly; fine per-particle geometry inside the random scatter
//    loops is condensed and marked INFERRED where it appears.
//  - ss_apply* per-frame functions update exactly the targets the binary
//    updates; easing curves are pow/sin based as in the binary (INFERRED
//    in exact coefficient placement).
#import "SSStartupView.h"
#import "OMCCommon.h"
#import "SSFade.h"
#import "SSGauge.h"
#import "SSCanvasView.h"
#import "SSLinkTarget.h"
#import <QuartzCore/QuartzCore.h>

// One mote/particle record: 7 doubles {kind, x, y, p3, p4, p5, p6} packed
// into NSMutableData. [VERIFIED: appendBytes:length: with 56-byte records]
typedef struct { long long kind; double x, y, a, b, c, d; } SSMote;   // first field is int64 in the original: ss_addMote:layer:to: types v88@0:8{?=qdddddd}16@72@80 (disasm va=0x4a89c)

// Two-stop gradient color array from two packed 0xRRGGBB values.
// [VERIFIED: sub_4732c — UIColor colorWithRed:green:blue:alpha:1 per stop]
static NSArray *SSColors(uint32_t a, uint32_t b) {
    UIColor *ca = [UIColor colorWithRed:((a >> 16) & 0xff) / 255.0
                                  green:((a >> 8) & 0xff) / 255.0
                                   blue:(a & 0xff) / 255.0 alpha:1];
    UIColor *cb = [UIColor colorWithRed:((b >> 16) & 0xff) / 255.0
                                  green:((b >> 8) & 0xff) / 255.0
                                   blue:(b & 0xff) / 255.0 alpha:1];
    return @[(id)ca.CGColor, (id)cb.CGColor];
}

// [W1] Class-name helper for the diagnostic bracket logs below
// (candidate-only instrumentation, W1 startup-ejection audit; all
// [W1] lines go through the synchronous OMCLogWriteSync).
static NSString *SSW1ClassName(id v) {
    return v ? NSStringFromClass([v class]) : @"(nil)";
}

// WMO weather code + isDay → sky scene category. [VERIFIED: sub_4712c]
// 2 clear day, 3 clear night, 4 overcast, 5 fog, 6 drizzle/rain,
// 7 snow (bitmask table), 8 thunderstorm; 0 = no scene (greeting fallback).
static NSInteger SSSkyForCode(NSInteger code, BOOL isDay) {
    if (code == 0 || code == 1 || code == 2) return isDay ? 2 : 3;
    if (code == 3) return 4;
    if (code == 45 || code == 48) return 5;
    if (code >= 51 && code <= 57) return 6;
    if (code > 94) return 8;
    // 61..86 resolved through a bitmask table in the binary (rain vs snow);
    // condensed here: [INFERRED exact per-code split]
    if ((code >= 61 && code <= 67) || (code >= 80 && code <= 82)) return 6;
    if ((code >= 71 && code <= 77) || code == 85 || code == 86) return 7;
    return 4;
}

// WMO code → SF Symbol + localized condition text. [VERIFIED: sub_487a4 —
// every symbol name and OMCTr pair below appears in the disassembly]
static void SSWeatherSymbol(NSInteger code, BOOL isDay,
                            NSString **symbolOut, NSString **textOut) {
    NSString *sym; NSString *txt;
    switch (code) {
        case 0:
            sym = isDay ? @"sun.max.fill" : @"moon.stars.fill";
            txt = OMCTr(@"Trời quang", @"Clear"); break;
        case 1: case 2:
            sym = isDay ? @"cloud.sun.fill" : @"cloud.moon.fill";
            txt = OMCTr(@"Ít mây", @"Partly cloudy"); break;
        case 3:
            sym = @"cloud.fill";
            txt = OMCTr(@"Nhiều mây", @"Cloudy"); break;
        case 45: case 48:
            sym = @"cloud.fog.fill";
            txt = OMCTr(@"Sương mù", @"Fog"); break;
        default:
            if (code >= 51 && code <= 57) {
                sym = @"cloud.drizzle.fill";
                txt = OMCTr(@"Mưa phùn", @"Drizzle");
            } else if (code == 82 || (code >= 65 && code <= 67) || code == 81) {
                // heavy-rain set as decoded from the mask tests [INFERRED boundary]
                sym = @"cloud.heavyrain.fill";
                txt = OMCTr(@"Mưa to", @"Heavy rain");
            } else if ((code >= 61 && code <= 64) || code == 80) {
                sym = isDay ? @"cloud.sun.rain.fill" : @"cloud.rain.fill";
                txt = OMCTr(@"Có mưa", @"Rain");
            } else if ((code >= 71 && code <= 77) || code == 85 || code == 86) {
                sym = @"cloud.snow.fill";
                txt = OMCTr(@"Có tuyết", @"Snow");
            } else if (code >= 95) {
                sym = @"cloud.bolt.rain.fill";
                txt = OMCTr(@"Dông", @"Thunderstorm");
            } else {
                sym = @"cloud.fill";
                txt = OMCTr(@"Nhiều mây", @"Cloudy");
            }
            break;
    }
    if (symbolOut) *symbolOut = sym;
    if (textOut) *textOut = txt;
}

// Temperature formatting: NSMeasurementFormatter, unit style short,
// 0 fraction digits, Celsius. [VERIFIED: sub_48a2c; nil → @"--"]
static NSString *SSFormatTemp(id value) {
    if (!value) return @"--";
    NSMeasurementFormatter *mf = [NSMeasurementFormatter new];
    mf.unitStyle = NSFormattingUnitStyleShort;
    NSNumberFormatter *nf = [NSNumberFormatter new];
    nf.maximumFractionDigits = 0;
    mf.numberFormatter = nf;
    NSMeasurement *m = [[NSMeasurement alloc] initWithDoubleValue:[value doubleValue]
                                                             unit:[NSUnitTemperature celsius]];
    return [mf stringFromMeasurement:m];
}

// Rounded-design system font. [VERIFIED: sub_492e8]
static UIFont *SSFont(double size, UIFontWeight weight) {
    UIFont *f = [UIFont systemFontOfSize:size weight:weight];
    UIFontDescriptor *d = [f.fontDescriptor fontDescriptorWithDesign:UIFontDescriptorSystemDesignRounded];
    if (d) f = [UIFont fontWithDescriptor:d size:size];
    return f;
}

// Label factory used by buildGreeting/buildWeather. [VERIFIED: sub_47664]
static UILabel *SSMakeLabel(NSString *text) {
    UILabel *l = [UILabel new];
    l.text = text;
    l.textColor = [UIColor whiteColor];
    l.textAlignment = NSTextAlignmentCenter;
    l.numberOfLines = 1;
    l.adjustsFontSizeToFitWidth = YES;
    l.minimumScaleFactor = 0.5;                       // const 0x65ed8 region [INFERRED exact]
    l.layer.shadowColor = [UIColor blackColor].CGColor;
    l.layer.shadowOpacity = 0.35f;                    // float 0x65d00
    l.layer.shadowRadius = 7;                         // [INFERRED placement]
    l.layer.shadowOffset = CGSizeZero;
    [l setContentCompressionResistancePriority:1000 forAxis:UILayoutConstraintAxisHorizontal];
    return l;
}

// Greeting text by period. [VERIFIED structure: sub_4779c — formats
// "%@, %@" of greeting + name when a name exists]
static NSString *SSGreetingForPeriod(NSInteger period, NSString *name) {
    NSString *g;
    switch (period) {
        case 0: g = OMCTr(@"Chào buổi sáng", @"Good morning"); break;
        case 1: g = OMCTr(@"Chào buổi chiều", @"Good afternoon"); break;
        case 2: g = OMCTr(@"Chào buổi tối", @"Good evening"); break;
        default: g = OMCTr(@"Xin chào", @"Hello"); break;   // [INFERRED default]
    }
    if (name.length) return [NSString stringWithFormat:@"%@, %@", g, name];
    return g;
}

// "EEEE d MMMM"-style localized date line. [VERIFIED: sub_47854 —
// NSDateFormatter with locale OMCCurrentLanguage(), template "EEEEdMMMM"]
static NSString *SSDateLine(NSDate *date) {
    NSDateFormatter *f = [NSDateFormatter new];
    f.locale = [NSLocale localeWithLocaleIdentifier:OMCCurrentLanguage()];
    [f setLocalizedDateFormatFromTemplate:@"EEEEdMMMM"];
    return [f stringFromDate:date];
}

// sub_4da60 — shared OmniCarPrefs string helper [VERIFIED semantics
// from the closure pass's own disassembly: NSString input →
// stringByTrimmingCharactersInSet:whitespaceAndNewlineCharacterSet;
// any other input (incl. nil) → @""]. Nine call sites across the
// binary (0x477d4, 0x4d7bc, 0x4d7e8, 0x4db24, 0x4eaec, 0x4eb18,
// 0x501bc, 0x501dc, 0x51158); itself still ownerless — the name here
// is a closure-pass label, the address is the ground truth.
// [integration phase 2; backported to src in phase 3] DEFINITION: src previously declared this helper extern and
// [integration phase 2; backported to src in phase 3] defined it NOWHERE (link fails on _SSPrefsTrimmedString); the
// [integration phase 2; backported to src in phase 3] body below is exactly the VERIFIED semantics documented in
// [integration phase 2; backported to src in phase 3] the comment above — no behaviour invented.
NSString *SSPrefsTrimmedString(NSString *s) {
    if (![s isKindOfClass:[NSString class]]) return @"";
    return [s stringByTrimmingCharactersInSet:
                 [NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

// sub_50180 VERIFIED (closure pass — own disassembly resolved through
// verify/macho_truth.py, all 13 cfstrings decoded flags-aware):
// builds the sample HUD checklist for the settings preview — five
// @{@"text": NSString, @"ok": @YES} dictionaries in the order below
// (each assembled in the binary via +[NSDictionary
// dictionaryWithObjects:forKeys:count:2] with keys [text, ok], then
// +[NSArray arrayWithObjects:count:5]). The car name enters only the
// last item: the display name is the trimmed car name, or @"OmniCar"
// when the trimmed name is empty. Faithful quirk: the binary calls
// the trim helper TWICE — once to test the length, once for the
// value (0x501bc / 0x501dc) — mirrored here. Callers: _SSApplySampleData
// (0x54610) and -[SSStartupView ss_buildHud] (0x4fcdc, fallback when
// self.hud is empty). Declared in OMCCommon.m (the seam fix's extern).
NSArray *SSSampleHudItems(NSString *carName) {
    NSString *trimmed = SSPrefsTrimmedString(carName);
    NSString *displayName = trimmed.length ? SSPrefsTrimmedString(carName)
                                           : @"DuoCar";
    return @[
        @{@"text": OMCTr(@"Kết nối CarPlay", @"CarPlay connected"),
          @"ok": @YES},
        @{@"text": OMCTr(@"Pin iPhone 82% · đang sạc",
                         @"iPhone battery 82% · charging"),
          @"ok": @YES},
        @{@"text": OMCTr(@"Nhiệt độ máy: ổn", @"Phone temperature: OK"),
          @"ok": @YES},
        @{@"text": OMCTr(@"Chế độ nhẹ: tự động", @"Lite mode: auto"),
          @"ok": @YES},
        @{@"text": [NSString stringWithFormat:
                        OMCTr(@"Hồ sơ xe: %@", @"Car profile: %@"),
                        displayName],
          @"ok": @YES},
    ];
}

@interface SSStartupView () {
    double _unit, _ox, _oy, _restTime, _tempoScale, _t0, _dot, _wiperLength, _cleared;
    double _introDur, _introDur2;
    CGPoint _wiperPivot;
    CGSize _sceneSize;
    NSInteger _sceneStyle, _sky, _percentShown;
    BOOL _sceneBuilt, _playing;
    UIStackView *_stack, *_row, *_cardStack;
    UIImageView *_logoView, *_posterView, *_iconView;
    UILabel *_timeLabel, *_titleLabel, *_dateLabel, *_tempLabel, *_condLabel,
            *_rangeLabel, *_rainLabel, *_updatedLabel, *_percentLabel;
    UIVisualEffectView *_card;
    NSLayoutConstraint *_iconW, *_iconH, *_stackMaxWidth;
    NSArray<NSLayoutConstraint *> *_cardInsets; // [integration phase 1; backported to src in phase 3] element type spelled out (assigned an array of NSLayoutConstraints below; the .constant accesses need the element type)
    CADisplayLink *_link;
    UIView *_scene, *_glass;
    SSCanvasView *_canvas;
    NSMutableArray *_fades, *_moteLayers, *_gauges, *_rings;
    NSMutableData *_motes, *_particles, *_bursts;
    CAShapeLayer *_outline, *_wheels, *_wetMask;
    CALayer *_flash, *_horizon, *_rays, *_wiper, *_lightning, *_radar;
}
@end

@implementation SSStartupView

+ (Class)layerClass { return [CAGradientLayer class]; }

- (CAGradientLayer *)gradientLayer { return (CAGradientLayer *)self.layer; }

- (instancetype)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        self.clipsToBounds = YES;
        self.backgroundColor = [UIColor blackColor];
        _percentShown = -1;
        _sceneStyle = -1;
        _playing = YES;             // BOOL ivar initialized to 1 [VERIFIED value; name INFERRED]
    }
    return self;
}

- (void)dealloc { [_link invalidate]; }

- (void)clearContent {
    for (UIView *v in [self.subviews copy]) [v removeFromSuperview];
    _stack = nil; _logoView = nil; _posterView = nil;
    _timeLabel = nil; _titleLabel = nil; _dateLabel = nil;
    _tempLabel = nil; _condLabel = nil; _rangeLabel = nil;
    _rainLabel = nil; _updatedLabel = nil; _percentLabel = nil;
    _iconView = nil; _row = nil; _cardStack = nil; _card = nil;
    _iconW = nil; _iconH = nil; _stackMaxWidth = nil; _cardInsets = nil;
    [self ss_clearScene];
    _sceneStyle = -1;
    _sceneSize = CGSizeZero;
}

- (NSArray *)ss_sceneColors {
    switch (_sceneStyle) {
        case 4:  return SSColors(0x05070C, 0x000000);
        case 5:  return SSColors(0x020308, 0x06070D);
        case 6:  return SSColors(0x020309, 0x070A19);   // 0x020308|1 in binary
        case 7:  return SSColors(0x01050C, 0x04121E);
        case 8:  return SSColors(0x0A141C, 0x16242F); // APEX graphite
        case 9:  return SSColors(0xE8EEF2, 0xF2F5F7); // APEX sang trung tinh
        default: break;
    }
    // Styles 2/3/10/11 key off the occasion.
    switch (self.occasion) {
        case 1:  return SSColors(0x5A0006, 0xA30F0F);
        case 2:  return SSColors(0x0A1218, 0x1B2A34); // APEX graphite
        case 3:  return SSColors(0x04121F, 0x0B1D4A);
        case 4:  return SSColors(0x081018, 0x14202B); // APEX graphite
        default: return SSColors(0x060B10, 0x101820);   // APEX mac dinh graphite (ban goc 0x020924, 0x0B1D4A)
    }
}

- (void)reload {
    // [W1] Bracket enter: style/occasion/tempo/duration + classes of
    // weather/hud/nextEvent/carName (W1 plan point).
    OMCLogWriteSync(@"Prefs", [NSString stringWithFormat:
        @"[W1] SSStartupView reload enter style=%ld occasion=%ld tempo=%ld duration=%g weatherClass=%@ hudClass=%@ nextEventClass=%@ carNameClass=%@",
        (long)self.style, (long)self.occasion, (long)self.tempo, self.duration,
        SSW1ClassName(self.weather), SSW1ClassName(self.hud),
        SSW1ClassName(self.nextEvent), SSW1ClassName(self.carName)]);
    [self clearContent];
    // [W1] Bracket: after clearContent.
    OMCLogWriteSync(@"Prefs", @"[W1] SSStartupView reload after clearContent");
    NSDate *date = self.date ?: [NSDate date];
    NSInteger period = SSPeriodForDate(date);
    CAGradientLayer *layer = self.gradientLayer;
    layer.type = kCAGradientLayerAxial;
    layer.startPoint = CGPointMake(0, 0);
    layer.endPoint = CGPointMake(1, 1);

    NSInteger style = self.style;
    NSInteger eff = style;
    if (style == 11)      eff = (self.occasion >= 1 && self.occasion < 6) ? 11 : 2;
    else if (style == 3)  eff = self.weather ? 3 : 2;
    if ((NSUInteger)eff > 11) eff = 2;

    _tempoScale = self.tempo < 1 ? 1.4 : (self.tempo == 1 ? 1.0 : 0.7);  // consts 0x65eb8 / 0x65700 [VERIFIED]
    _restTime = INFINITY;
    // Per-style intro duration pair (scaled by duration where noted).
    // [VERIFIED values; which of the two drives what is INFERRED]
    double d1 = 2.5, d2 = 2.5;
    switch (eff) {
        case 3:  d1 = 3.0; d2 = 3.0; break;
        case 4:  d1 = 4.0; d2 = 3.9; break;
        case 5:  d1 = _tempoScale * 4.0; d2 = _tempoScale * 3.6; break;
        case 6:  d1 = 3.0; d2 = 3.0; break;
        case 7:  d1 = 3.4; d2 = 3.4; break;
        case 8:  d1 = 2.65; d2 = 2.5; break;
        case 9:  d1 = 2.9; d2 = 2.65; break;
        default: break;
    }
    _introDur = d1; _introDur2 = d2;   // the binary's per-style duration pair
    _sceneStyle = eff;

    if (eff == 0) {
        layer.colors = SSColors(0x000000, 0x000000);
        _posterView = [[UIImageView alloc] initWithFrame:self.bounds];
        _posterView.clipsToBounds = YES;
        if (self.image) {
            _posterView.image = self.image;
            _posterView.contentMode = self.imageFits ? UIViewContentModeScaleAspectFit
                                                     : UIViewContentModeScaleAspectFill;
        } else {
            _posterView.image = [UIImage systemImageNamed:@"play.rectangle.fill"];
            _posterView.tintColor = [UIColor colorWithWhite:1 alpha:0.35];
            _posterView.contentMode = UIViewContentModeCenter;
        }
        [self addSubview:_posterView];
        // [W1] Bracket exit (eff style 0 branch).
        OMCLogWriteSync(@"Prefs", @"[W1] SSStartupView reload exit eff=0");
        return;
    }
    if (eff == 1) {
        layer.type = kCAGradientLayerRadial;
        layer.startPoint = CGPointMake(0.5, 0.5);
        layer.endPoint = CGPointMake(1, 1);
        layer.colors = SSColors(0x1E2646, 0x05060B);   // const triples at 0x658d0… [VERIFIED]
        _logoView = [UIImageView new];
        _logoView.contentMode = UIViewContentModeScaleAspectFit;
        if (self.image) _logoView.image = self.image;
        else {
            _logoView.image = [UIImage systemImageNamed:@"car.fill"];
            _logoView.tintColor = [UIColor whiteColor];
        }
        [self addSubview:_logoView];
        // [W1] Bracket exit (eff style 1 branch).
        OMCLogWriteSync(@"Prefs", @"[W1] SSStartupView reload exit eff=1");
        return;
    }

    layer.startPoint = CGPointMake(0.5, 0);
    layer.endPoint = CGPointMake(0.5, 1);
    if (eff == 3) {
        // Period base gradient first, then the sky-scene gradient.
        NSArray *periodColors;
        switch (period) {
            case 0:  periodColors = SSColors(0xFFB36B, 0xF2665E); break;
            case 1:  periodColors = SSColors(0x27B4A4, 0x1F5F8E); break;
            case 2:  periodColors = SSColors(0xF08A66, 0x5C3A92); break;
            default: periodColors = SSColors(0x1D2547, 0x04050B); break;
        }
        layer.colors = periodColors;
        _sky = SSSkyForCode([self.weather[@"code"] integerValue],
                            [self.weather[@"isDay"] boolValue]);
        if (_sky == 0) {
            [self buildGreetingWithDate:date period:period];
        } else {
            switch (_sky) {
                case 1: case 3: layer.colors = SSColors(0x02030A, 0x0B1230); break;
                case 2:  layer.colors = SSColors(0x2A7FD8, 0x9FD3FF); break;
                case 5:  layer.colors = SSColors(0x5F6670, 0x9AA1AA); break;
                case 6: case 7: case 8:
                    layer.colors = self.weather ? SSColors(0x5D6E86, 0xB4C2D3)
                                                : SSColors(0x1C2633, 0x33404F); break;
                default: layer.colors = self.weather ? SSColors(0x4A5B70, 0x8D9BAD)
                                                      : SSColors(0x10141F, 0x2A3243); break;
            }
            _sceneStyle = 3;
            [self buildWeatherWithPeriod:period];
        }
    } else if (eff == 2 || eff == 10 || eff == 11) {
        layer.colors = [self ss_sceneColors];
        if (eff == 2) [self buildGreetingWithDate:date period:period];
        // 10/11 build their scenes lazily in ss_buildScene (layout time).
    } else {
        layer.colors = [self ss_sceneColors];
    }

    // [W1] Bracket: after the scene branch (effective style recorded).
    OMCLogWriteSync(@"Prefs", [NSString stringWithFormat:
        @"[W1] SSStartupView reload after scene branch eff=%ld sceneStyle=%ld",
        (long)eff, (long)_sceneStyle]);

    if (_stack) {
        _stack.translatesAutoresizingMaskIntoConstraints = NO;
        [self addSubview:_stack];
        _stackMaxWidth = [_stack.widthAnchor constraintLessThanOrEqualToAnchor:self.widthAnchor constant:-16];
        [NSLayoutConstraint activateConstraints:@[
            _stackMaxWidth,
            [_stack.centerXAnchor constraintEqualToAnchor:self.centerXAnchor],
            [_stack.centerYAnchor constraintEqualToAnchor:self.centerYAnchor],
        ]];
    }
    [self setNeedsLayout];
    // [W1] Bracket exit.
    OMCLogWriteSync(@"Prefs", [NSString stringWithFormat:
        @"[W1] SSStartupView reload exit eff=%ld", (long)eff]);
}

#pragma mark - Greeting scene (style 2, and weather fallback)

- (void)buildGreetingWithDate:(NSDate *)date period:(NSInteger)period {
    NSString *time = [NSDateFormatter localizedStringFromDate:date
                                                    dateStyle:NSDateFormatterNoStyle
                                                    timeStyle:NSDateFormatterShortStyle];
    _timeLabel = SSMakeLabel(time);
    _titleLabel = SSMakeLabel(SSGreetingForPeriod(period, self.name));
    _titleLabel.alpha = 0.9;                       // const 0x65e50 region [INFERRED exact]
    _dateLabel = SSMakeLabel(SSDateLine(date));
    _stack = [[UIStackView alloc] initWithArrangedSubviews:@[_timeLabel, _titleLabel, _dateLabel]];
    _stack.axis = UILayoutConstraintAxisVertical;
    _stack.alignment = UIStackViewAlignmentCenter;
}

#pragma mark - Weather scene (style 3)

- (void)buildWeatherWithPeriod:(NSInteger)period {
    NSDictionary *w = self.weather;
    NSInteger code = [w[@"code"] integerValue];
    BOOL isDay = [w[@"isDay"] boolValue];
    NSString *symbol = nil, *condText = nil;
    SSWeatherSymbol(code, isDay, &symbol, &condText);

    _titleLabel = SSMakeLabel(SSGreetingForPeriod(period, self.name));
    _titleLabel.alpha = 0.85;                      // const 0x65f58 [INFERRED exact]

    UIImageSymbolConfiguration *cfg =
        [UIImageSymbolConfiguration configurationWithPointSize:180 weight:UIImageSymbolWeightRegular];
    cfg = [cfg configurationByApplyingConfiguration:
           [UIImageSymbolConfiguration configurationPreferringMulticolor]];
    UIImage *img = [UIImage systemImageNamed:symbol withConfiguration:cfg]
                ?: [UIImage systemImageNamed:@"cloud.fill" withConfiguration:cfg];
    _iconView = [[UIImageView alloc] initWithImage:img];
    _iconView.contentMode = UIViewContentModeScaleAspectFit;
    _iconView.tintColor = [UIColor whiteColor];
    _iconView.translatesAutoresizingMaskIntoConstraints = NO;
    _iconW = [_iconView.widthAnchor constraintEqualToConstant:30];
    _iconH = [_iconView.heightAnchor constraintEqualToConstant:30];
    [NSLayoutConstraint activateConstraints:@[_iconW, _iconH]];

    _tempLabel = SSMakeLabel(SSFormatTemp(w[@"temp"]));
    [_tempLabel setContentCompressionResistancePriority:1000 forAxis:UILayoutConstraintAxisHorizontal];
    _condLabel = SSMakeLabel(condText);

    NSMutableArray *rangeParts = [NSMutableArray array];
    if (w[@"high"]) [rangeParts addObject:[@"↑ " stringByAppendingString:SSFormatTemp(w[@"high"])]];
    if (w[@"low"])  [rangeParts addObject:[@"↓ " stringByAppendingString:SSFormatTemp(w[@"low"])]];
    _rangeLabel = SSMakeLabel([rangeParts componentsJoinedByString:@"   "]);
    _rangeLabel.hidden = rangeParts.count == 0;

    NSString *rainText = nil;
    if (w[@"rain"]) rainText = [NSString stringWithFormat:@"%@ %ld%%",
                                OMCTr(@"Khả năng mưa", @"Chance of rain"),
                                (long)[w[@"rain"] integerValue]];
    _rainLabel = SSMakeLabel(rainText);
    _rainLabel.hidden = (w[@"rain"] == nil);
    _rainLabel.alpha = 0.8;                        // const 0x65e08 region [INFERRED exact]

    for (UILabel *l in @[_condLabel, _rangeLabel, _rainLabel]) l.textAlignment = NSTextAlignmentCenter;

    _row = [[UIStackView alloc] initWithArrangedSubviews:@[_iconView, _tempLabel, _condLabel]];
    _row.axis = UILayoutConstraintAxisVertical;
    _row.alignment = UIStackViewAlignmentCenter;
    _row.translatesAutoresizingMaskIntoConstraints = NO;

    _card = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleSystemMaterial]];
    _card.clipsToBounds = YES;
    _card.layer.cornerCurve = kCACornerCurveContinuous;
    _card.layer.borderWidth = 0.5;
    _card.layer.borderColor = [UIColor colorWithWhite:1 alpha:0.22].CGColor;
    _card.contentView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.12];
    [_card.contentView addSubview:_row];
    _cardInsets = @[
        [_row.leadingAnchor constraintEqualToAnchor:_card.contentView.leadingAnchor constant:12],
        [_row.trailingAnchor constraintEqualToAnchor:_card.contentView.trailingAnchor constant:-12],
        [_row.topAnchor constraintEqualToAnchor:_card.contentView.topAnchor constant:8],
        [_row.bottomAnchor constraintEqualToAnchor:_card.contentView.bottomAnchor constant:-8],
    ];
    [NSLayoutConstraint activateConstraints:_cardInsets];

    NSDate *dateVal = [w[@"date"] isKindOfClass:[NSDate class]] ? w[@"date"] : nil;
    NSString *updatedText = nil;
    BOOL hideUpdated = YES;
    if (dateVal) {
        BOOL today = [[NSCalendar currentCalendar] isDateInToday:dateVal];
        NSString *when = [NSDateFormatter localizedStringFromDate:dateVal
                                                        dateStyle:today ? NSDateFormatterNoStyle
                                                                        : NSDateFormatterShortStyle
                                                        timeStyle:NSDateFormatterShortStyle];
        updatedText = [NSString stringWithFormat:OMCTr(@"Cập nhật lúc %@", @"Updated %@"), when];
        hideUpdated = NO;
    }
    _updatedLabel = SSMakeLabel(updatedText);
    _updatedLabel.hidden = hideUpdated;
    _updatedLabel.alpha = 0.55;                    // const 0x65b98 region [INFERRED exact]

    _stack = [[UIStackView alloc] initWithArrangedSubviews:@[_titleLabel, _card, _updatedLabel]];
    _stack.axis = UILayoutConstraintAxisVertical;
    _stack.alignment = UIStackViewAlignmentCenter;
}

#pragma mark - Layout / unit scaling

- (void)layoutSubviews {
    [super layoutSubviews];
    CGRect b = self.bounds;
    double unit = MIN(b.size.height / 100.0, b.size.width / 260.0);   // divisors 100.0 / 260.0 [VERIFIED]
    if (unit <= 0) return;
    double oldUnit = _unit;
    _unit = unit;
    if (_sceneStyle >= 0 && !CGSizeEqualToSize(b.size, _sceneSize)) {
        _sceneSize = b.size;
        // [W1] Bracket ONLY the first ss_buildScene call from
        // layoutSubviews (static flag; records _sceneStyle).
        static BOOL sW1BuildSceneLogged = NO;
        BOOL w1LogBuild = !sW1BuildSceneLogged;
        if (w1LogBuild) {
            sW1BuildSceneLogged = YES;
            OMCLogWriteSync(@"Prefs", [NSString stringWithFormat:
                @"[W1] SSStartupView layoutSubviews first ss_buildScene enter sceneStyle=%ld",
                (long)_sceneStyle]);
        }
        [self ss_buildScene];
        if (w1LogBuild)
            OMCLogWriteSync(@"Prefs", [NSString stringWithFormat:
                @"[W1] SSStartupView layoutSubviews first ss_buildScene exit sceneStyle=%ld",
                (long)_sceneStyle]);
    }
    if (_posterView) {
        _posterView.frame = b;
        if (_posterView.contentMode == UIViewContentModeCenter && _posterView.image) {
            UIImageSymbolConfiguration *cfg =
                [UIImageSymbolConfiguration configurationWithPointSize:28 * unit];
            _posterView.image = [_posterView.image imageWithConfiguration:cfg];
        }
    }
    if (_logoView) {
        double w = MIN(b.size.width * 0.5, b.size.height * 0.62);     // consts 0.5 / 0x65a20 [INFERRED 2nd]
        _logoView.bounds = CGRectMake(0, 0, w, w);
        _logoView.center = CGPointMake(b.size.width / 2, b.size.height / 2);
        _logoView.layer.shadowRadius = 7 * unit;
    }
    if (fabs(unit - oldUnit) >= 0.01) [self applyUnit:unit];           // threshold const 0x65ee0 [VERIFIED]
}

// Scales every font/constraint of the text scenes to the unit.
// [VERIFIED: font size factors and weights per label, from applyUnit:
//  va=0x48d4c — 8 label ivars loaded into a C array on the stack
//  (stores 0x48d8c-0x48e58, each retained), loop 0x48e6c-0x48ee0
//  skips nil via cbz at 0x48e74; no arrayWithObjects:count: in the
//  original. Per live label: shadowRadius = 1.5 * unit
//  (fmul 0x48e5c-0x48e60), shadowOffset = (0, 0.5 * unit)
//  (0.5 at 0x48e64-0x48e68, width 0 at 0x48ec0, setShadowOffset:
//  at 0x48ecc).]
- (void)applyUnit:(double)unit {
    UILabel *labels[8] = {_timeLabel, _titleLabel, _dateLabel, _tempLabel,
                          _condLabel, _rangeLabel, _rainLabel, _updatedLabel};
    for (int i = 0; i < 8; i++) {
        UILabel *l = labels[i];
        if (!l) continue;
        l.layer.shadowRadius = 1.5 * unit;
        l.layer.shadowOffset = CGSizeMake(0, 0.5 * unit);
    }
    _stackMaxWidth.constant = -12 * unit;
    if (_timeLabel) {   // greeting layout metrics
        _timeLabel.font  = SSFont(30 * unit, UIFontWeightLight);
        _titleLabel.font = SSFont(10 * unit, UIFontWeightSemibold);
        _dateLabel.font  = SSFont(6 * unit, UIFontWeightMedium);
    } else if (_tempLabel) {   // weather layout metrics
        _condLabel.font   = SSFont(7 * unit, UIFontWeightSemibold);
        _tempLabel.font   = SSFont(30 * unit, UIFontWeightMedium);
        _rangeLabel.font  = SSFont(7.5 * unit, UIFontWeightRegular);
        _rainLabel.font   = SSFont(6 * unit, UIFontWeightRegular);
        _updatedLabel.font = SSFont(5.5 * unit, UIFontWeightRegular);
        _titleLabel.font  = SSFont(5 * unit, UIFontWeightRegular);
        _iconW.constant = 32 * unit;
        _iconH.constant = 32 * unit;
        _row.spacing = 4 * unit;
        [_row setCustomSpacing:3 * unit afterView:_tempLabel];
        _stack.spacing = 3.5 * unit;
        _card.layer.cornerRadius = 5 * unit;
        if (_cardInsets.count == 4) {
            _cardInsets[1].constant = 5 * unit;
            _cardInsets[0].constant = 5 * unit;
            _cardInsets[3].constant = 3.5 * unit;
            _cardInsets[2].constant = 3.5 * unit;
        }
    }
    _stack.spacing = 3 * unit;
}

#pragma mark - Intro animation

- (void)playIntro {
    // [W1] Bracket enter.
    OMCLogWriteSync(@"Prefs", [NSString stringWithFormat:
        @"[W1] SSStartupView playIntro enter sceneStyle=%ld logoEffect=%ld",
        (long)_sceneStyle, (long)self.logoEffect]);
    // [fix-round5] Restored to the PREFS binary's own playIntro @0x493a4
    // (disasm src/Prefs/disasm/SSStartupView.asm; constants read raw from
    // the original arm64 slice). u = MAX(_unit, 1) is computed up front
    // (fcsel @0x493d8-0x493e0) and used by both the glow radius (7*u) and
    // the scene translation (6*u). The !logoView tail (t0/playing/engine
    // start gated on _sceneStyle >= 0, then the _stack ?: _posterView
    // spring) runs ONLY when there is no logo view, exactly as in the
    // binary; ivar targets resolved via the binary's offset table +
    // objc.json (_stack @16, _logoView @24, _posterView @32,
    // _sceneStyle @168, _t0 @256, _playing @264).
    [self layoutIfNeeded];
    CGFloat u = MAX(_unit, 1.0);
    if (_logoView) {
        _logoView.layer.removeAllAnimations;
        _logoView.layer.shadowOpacity = 0;
        _logoView.alpha = 0;
        if (self.logoEffect == 1) {
            _logoView.transform = CGAffineTransformMakeScale(0.5, 0.5);
            [UIView animateWithDuration:1.1 delay:0.1
                 usingSpringWithDamping:0.7 initialSpringVelocity:0
                                options:0 animations:^{
                _logoView.alpha = 1;
                _logoView.transform = CGAffineTransformIdentity;
            } completion:nil];
        } else if (self.logoEffect == 2) {
            // Glow: pulsing shadowOpacity via CABasicAnimation (key "ssGlow").
            _logoView.transform = CGAffineTransformIdentity;
            _logoView.layer.shadowColor = [UIColor whiteColor].CGColor;
            _logoView.layer.shadowOffset = CGSizeZero;
            _logoView.layer.shadowRadius = 7 * u;
            _logoView.layer.shadowOpacity = 0.6f;
            CABasicAnimation *glow = [CABasicAnimation animationWithKeyPath:@"shadowOpacity"];
            glow.fromValue = @0.0; glow.toValue = @0.95;
            glow.duration = 1.2; glow.autoreverses = YES;
            glow.repeatCount = HUGE_VALF;
            glow.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
            [_logoView.layer addAnimation:glow forKey:@"ssGlow"];
            [UIView animateWithDuration:0.9 animations:^{ _logoView.alpha = 1; }];
        } else {
            _logoView.transform = CGAffineTransformMakeScale(0.96, 0.96);
            [UIView animateWithDuration:1.2 delay:0.05 options:0 animations:^{
                _logoView.alpha = 1;
                _logoView.transform = CGAffineTransformIdentity;
            } completion:nil];
        }
    } else {
        _t0 = CACurrentMediaTime();
        _playing = YES;
        if (_sceneStyle >= 0) {
            [self ss_applyTime:0];
            [self ss_startLink];
        }
        UIView *sceneView = _stack ?: _posterView;
        if (sceneView) {
            sceneView.layer.removeAllAnimations;
            sceneView.alpha = 0;
            sceneView.transform = CGAffineTransformScale(
                CGAffineTransformMakeTranslation(0, 6 * u), 0.92, 0.92);
            [UIView animateWithDuration:0.9 delay:0.05
                 usingSpringWithDamping:0.86 initialSpringVelocity:0
                                    options:0 animations:^{
                sceneView.alpha = 1;
                sceneView.transform = CGAffineTransformIdentity;
            } completion:nil];
        }
    }
    // [W1] Bracket exit.
    OMCLogWriteSync(@"Prefs", @"[W1] SSStartupView playIntro exit");
}

#pragma mark - Display link engine

- (double)ss_now { return CACurrentMediaTime(); }

- (void)didMoveToWindow {
    [super didMoveToWindow];
    if (self.window) [self ss_startLink];
    else [self ss_stopLink];
}

- (void)ss_startLink {
    if (!self.window || _link) return;
    SSLinkTarget *target = [SSLinkTarget new];
    target.owner = self;
    _link = [self.window.screen displayLinkWithTarget:target selector:@selector(step:)];
    _link.preferredFrameRateRange = CAFrameRateRangeMake(30, 60, 60);
    [_link addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
    _t0 = [self ss_now];
}

- (void)ss_stopLink {
    [_link invalidate];
    _link = nil;
}

- (void)ss_step {
    if (self.window) [self ss_applyTime:[self ss_now] - _t0];
    else [self ss_stopLink];
}

// One frame: advance fades, motes, engine, hud, sky, welcome; redraw canvas.
// [VERIFIED dispatch order]
- (void)ss_applyTime:(double)t {
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    for (SSFade *f in _fades) [f applyTime:t];
    [self ss_applyMotes:t];
    [self ss_applyEngine:t];
    [self ss_applyHud:t];
    [self ss_applySky:t];
    [self ss_applyWelcome:t];
    [_canvas setNeedsDisplay];
    [CATransaction commit];
}

- (void)ss_clearScene {
    [self ss_stopLink];
    [_scene removeFromSuperview]; _scene = nil;
    [_glass removeFromSuperview]; _glass = nil;
    _canvas = nil;
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
    _t0 = -1;
    _percentShown = -1;
}

- (void)ss_buildScene {
    // [W1] Bracket enter.
    OMCLogWriteSync(@"Prefs", [NSString stringWithFormat:
        @"[W1] SSStartupView ss_buildScene enter sceneStyle=%ld", (long)_sceneStyle]);
    [self ss_clearScene];
    CGRect b = self.bounds;
    _ox = b.size.width / 2; _oy = b.size.height / 2;      // centered origin [INFERRED exact]
    _scene = [[UIView alloc] initWithFrame:b];
    _scene.userInteractionEnabled = NO;
    [self insertSubview:_scene atIndex:0];
    switch (_sceneStyle) {
        case 4:  [self ss_buildEngine]; break;
        case 8:  [self ss_buildBriefing]; break;
        case 6:  [self ss_buildParticles]; break;
        case 11: [self ss_buildFestive]; break;
        case 3:  [self ss_buildSky]; break;
        case 7:  [self ss_buildHud]; break;
        case 5:  [self ss_buildWelcome]; break;
        case 9:  [self ss_buildLiquid]; break;
        default: break;
    }
    _sceneBuilt = YES;
    [self ss_applyTime:[self ss_now] - _t0];
    [self ss_startLink];
    // [W1] Bracket exit.
    OMCLogWriteSync(@"Prefs", [NSString stringWithFormat:
        @"[W1] SSStartupView ss_buildScene exit sceneStyle=%ld", (long)_sceneStyle]);
}

- (UIView *)ss_host {
    UIView *host = [[UIView alloc] initWithFrame:self.bounds];
    host.userInteractionEnabled = NO;
    [self addSubview:host];
    return host;
}

- (SSCanvasView *)ss_addCanvas {
    SSCanvasView *canvas = [[SSCanvasView alloc] initWithFrame:self.bounds];
    canvas.owner = self;
    canvas.opaque = NO;
    canvas.backgroundColor = [UIColor clearColor];
    canvas.userInteractionEnabled = NO;
    canvas.contentScaleFactor = 1;
    canvas.contentMode = UIViewContentModeRedraw;
    [self addSubview:canvas];
    _canvas = canvas;
    return canvas;
}

#pragma mark - Scene helpers

// Floating label factory for scenes. [VERIFIED structure]
- (UILabel *)ss_label:(NSString *)text at:(CGPoint)pt size:(double)size
               weight:(UIFontWeight)weight color:(UIColor *)color
                 left:(BOOL)left in:(UIView *)container maxWidth:(double)maxWidth {
    UILabel *l = [UILabel new];
    l.text = text;
    l.font = SSFont(size * _unit, weight);
    l.textColor = color ?: [UIColor whiteColor];
    l.textAlignment = left ? NSTextAlignmentLeft : NSTextAlignmentCenter;
    l.layer.shadowColor = [UIColor blackColor].CGColor;
    l.layer.shadowOpacity = 0.35f;
    l.layer.shadowRadius = 7 * _unit;
    l.layer.shadowOffset = CGSizeMake(0, 1);
    l.layer.shouldRasterize = YES;
    l.layer.rasterizationScale = self.traitCollection.displayScale * 2;
    CGSize fit = [l sizeThatFits:CGSizeMake(maxWidth > 0 ? maxWidth : CGFLOAT_MAX, CGFLOAT_MAX)];
    l.bounds = CGRectMake(0, 0, fit.width, fit.height);
    // Anchor [VERIFIED from the Prefs dump, ss_label: va=0x4a504]: for
    // left-aligned labels the point is the LEFT edge — center.x =
    // pt.x + width/2 (fmul/fadd 0x4a78c-0x4a794, fcsel on the left flag
    // at 0x4a798-0x4a79c); centred labels take the point as-is.
    l.center = left ? CGPointMake(pt.x + fit.width / 2, pt.y) : pt;
    [container addSubview:l];
    return l;
}

- (SSFade *)ss_fade:(UIView *)view from:(double)from to:(double)to alpha:(double)alpha {
    SSFade *f = [SSFade new];
    f.view = view;
    f.inA = from;
    f.inB = to;
    f.alpha = alpha;   // the fade's TARGET alpha [VERIFIED: setAlpha: on the SSFade]
    [_fades addObject:f];
    return f;
}

- (void)ss_addMote:(SSMote)mote layer:(CALayer *)layer to:(UIView *)host {
    [_motes appendBytes:&mote length:sizeof(mote)];
    [_moteLayers addObject:layer];
    [host.layer addSublayer:layer];
}

// Per-frame mote drift: three motion modes keyed by record.kind, all
// sin/pow driven. [VERIFIED targets; coefficients INFERRED]
- (void)ss_applyMotes:(double)t {
    NSUInteger n = _motes.length / sizeof(SSMote);
    const SSMote *m = _motes.bytes;
    for (NSUInteger i = 0; i < n && i < _moteLayers.count; i++) {
        CALayer *layer = _moteLayers[i];
        double ph = m[i].a;
        if (m[i].kind == 0) {           // falling (snow/rain)
            double y = fmod(m[i].y + t * m[i].b, 1.0);
            layer.position = CGPointMake((m[i].x + sin(t + ph) * 0.01) * self.bounds.size.width,
                                         y * self.bounds.size.height);
            layer.opacity = (float)(0.35 + 0.65 * sin(t * 2 + ph) * 0.5 + 0.325);
        } else if (m[i].kind == 1) {    // rising sparks
            double y = fmod(m[i].y - t * m[i].b, 1.0); if (y < 0) y += 1;
            layer.position = CGPointMake(m[i].x * self.bounds.size.width,
                                         y * self.bounds.size.height);
            layer.transform = CATransform3DMakeRotation(t * 3 + ph, 0, 0, 1);
        } else {                        // drifting stars/confetti
            layer.position = CGPointMake((m[i].x + sin(t * 0.5 + ph) * 0.02) * self.bounds.size.width,
                                         (m[i].y + cos(t * 0.4 + ph) * 0.02) * self.bounds.size.height);
            layer.opacity = (float)(0.4 + 0.6 * fabs(sin(t + ph)));
        }
    }
}

#pragma mark - Gauges (engine scene)

// Builds one gauge: track arc + gradient fill masked by a progress arc,
// needle, number and caption labels. [VERIFIED composition]
- (SSGauge *)ss_gaugeAt:(CGPoint)center radius:(double)radius label:(NSString *)label
                   unit:(NSString *)unit max:(double)max red:(double)red in:(UIView *)host {
    SSGauge *g = [SSGauge new];
    g.max = max;
    g.red = red;
    g.shown = 0;
    CGFloat start = (CGFloat)(M_PI * 0.75), end = (CGFloat)(M_PI * 2.25);
    UIBezierPath *arcPath = [UIBezierPath bezierPathWithArcCenter:center radius:radius
                                                       startAngle:start endAngle:end clockwise:YES];
    CAShapeLayer *track = [CAShapeLayer layer];
    track.frame = host.bounds;
    track.path = arcPath.CGPath;
    track.fillColor = NULL;
    track.strokeColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.18].CGColor;
    track.lineWidth = 4 * _unit;
    track.lineCap = kCALineCapRound;
    [host.layer addSublayer:track];

    CAShapeLayer *prog = [CAShapeLayer layer];
    prog.frame = host.bounds;
    prog.path = arcPath.CGPath;
    prog.fillColor = NULL;
    prog.strokeColor = [UIColor blackColor].CGColor;
    prog.lineWidth = 4 * _unit;
    prog.lineCap = kCALineCapRound;
    prog.strokeEnd = 0;
    CAGradientLayer *fill = [CAGradientLayer layer];
    fill.frame = host.bounds;
    fill.startPoint = CGPointMake(0, 0.5);
    fill.endPoint = CGPointMake(1, 0.5);
    fill.colors = SSColors(0x2BC79A, 0x5AB8FF);
    fill.mask = prog;
    [host.layer addSublayer:fill];
    g.fill = fill;
    g.arc = prog;   // ss_setGauge: drives strokeEnd on the progress arc

    CALayer *needleHost = [CALayer layer];
    needleHost.frame = host.bounds;
    needleHost.shadowColor = [UIColor whiteColor].CGColor;
    needleHost.shadowOpacity = 0.5f;
    needleHost.shadowRadius = 8;
    needleHost.shadowOffset = CGSizeZero;
    [host.layer addSublayer:needleHost];
    CAShapeLayer *needle = [CAShapeLayer layer];
    needle.frame = host.bounds;
    UIBezierPath *np = [UIBezierPath bezierPath];
    [np moveToPoint:center];
    [np addLineToPoint:CGPointMake(center.x + radius * 0.82, center.y)];
    needle.path = np.CGPath;
    needle.strokeColor = [UIColor whiteColor].CGColor;
    needle.lineWidth = 2 * _unit;
    needle.lineCap = kCALineCapRound;
    [needleHost addSublayer:needle];
    g.needle = needle;

    g.number = [self ss_label:@"0" at:CGPointMake(center.x, center.y + radius * 0.42)
                         size:11 weight:UIFontWeightSemibold color:nil left:NO
                           in:host maxWidth:0];
    [self ss_label:label at:CGPointMake(center.x, center.y + radius * 0.62)
              size:5 weight:UIFontWeightMedium
             color:[UIColor colorWithWhite:1 alpha:0.6] left:NO in:host maxWidth:0];
    if (unit) [self ss_label:unit at:CGPointMake(center.x, center.y + radius * 0.78)
                        size:4.5 weight:UIFontWeightRegular
                       color:[UIColor colorWithWhite:1 alpha:0.45] left:NO in:host maxWidth:0];
    [_gauges addObject:g];
    return g;
}

- (void)ss_setGauge:(SSGauge *)g value:(double)value {
    double frac = g.max > 0 ? value / g.max : 0;
    frac = MAX(0, MIN(1, frac));
    g.arc.strokeEnd = (CGFloat)frac;   // the progress mask arc (stored on gauge)
    double angle = -M_PI * 0.75 + frac * M_PI * 1.5;
    g.needle.transform = CATransform3DMakeRotation((CGFloat)angle, 0, 0, 1);
    BOOL hot = value >= g.red;
    if (hot != g.hot) {
        g.hot = hot;
        g.fill.colors = hot ? SSColors(0xFF5C54, 0xFFB36B) : SSColors(0x2BC79A, 0x5AB8FF);
    }
    NSInteger shown = (NSInteger)llround(value);
    if (shown != g.shown) {
        g.shown = shown;
        g.number.text = [NSString stringWithFormat:@"%ld", (long)shown];
    }
}

#pragma mark - Scene builders (styles 3–9, 11)
// Composition below is VERIFIED (layers/views/strings/keys as found in the
// disassembly); scatter-loop geometry is condensed [INFERRED in detail].

- (void)ss_buildSky {
    UIView *host = [self ss_host];
    // Sun/moon disc + glow for clear skies; cloud shapes for overcast;
    // mote fields for rain/snow/stars; lightning flash + wiper for storms.
    // [VERIFIED elements: gradient disc layer, bezier cloud layers,
    //  arc4random-driven motes via ss_addMote:layer:to:, _flash/_rays/
    //  _horizon/_wiper/_wetMask/_lightning layers, weather[@"isDay"] read]
    BOOL day = [self.weather[@"isDay"] boolValue];
    CALayer *disc = [CALayer layer];
    double r = 26 * _unit;
    disc.frame = CGRectMake(self.bounds.size.width * 0.78 - r, self.bounds.size.height * 0.3 - r, r * 2, r * 2);
    disc.cornerRadius = (CGFloat)r;
    disc.backgroundColor = (day ? [UIColor colorWithRed:1 green:0.85 blue:0.4 alpha:1]
                                : [UIColor colorWithRed:0.9 green:0.93 blue:1 alpha:1]).CGColor;
    disc.shadowColor = disc.backgroundColor;
    disc.shadowOpacity = 0.8f; disc.shadowRadius = 24; disc.shadowOffset = CGSizeZero;
    [host.layer addSublayer:disc];
    _rays = disc;
    if (_sky == 6 || _sky == 7 || _sky == 8) {
        NSInteger n = (_sky == 7) ? 60 : 90;
        for (NSInteger i = 0; i < n; i++) {
            CALayer *drop = [CALayer layer];
            double s = (2 + arc4random_uniform(3)) * _unit * 0.5;
            drop.frame = CGRectMake(0, 0, s, s * (_sky == 7 ? 1 : 3));
            drop.cornerRadius = (CGFloat)(s / 2);
            drop.backgroundColor = [UIColor colorWithWhite:1 alpha:_sky == 7 ? 0.9 : 0.45].CGColor;
            SSMote m = {0, (double)arc4random_uniform(1000) / 1000.0,
                           (double)arc4random_uniform(1000) / 1000.0,
                           (double)arc4random_uniform(628) / 100.0,
                           _sky == 7 ? 0.05 : 0.25, 0, 0};
            [self ss_addMote:m layer:drop to:host];
        }
    }
    if (_sky == 8) {
        _flash = [CALayer layer];
        _flash.frame = self.bounds;
        _flash.backgroundColor = [UIColor whiteColor].CGColor;
        _flash.opacity = 0;
        [host.layer addSublayer:_flash];
        _lightning = _flash;
    }
    if (_sky == 2 || _sky == 3) {
        for (NSInteger i = 0; i < 40; i++) {
            CALayer *star = [CALayer layer];
            double s = (1 + arc4random_uniform(2)) * _unit * 0.6;
            star.frame = CGRectMake(0, 0, s, s);
            star.cornerRadius = (CGFloat)(s / 2);
            star.backgroundColor = [UIColor whiteColor].CGColor;
            SSMote m = {2, (double)arc4random_uniform(1000) / 1000.0,
                           (double)arc4random_uniform(600) / 1000.0,
                           (double)arc4random_uniform(628) / 100.0, 0, 0, 0};
            [self ss_addMote:m layer:star to:host];
        }
    }
}

- (void)ss_applySky:(double)t {
    // Wiper sweep over a wet mask for rain skies; lightning flashes;
    // horizon/disc parallax. [VERIFIED targets; curves INFERRED]
    if (_flash) _flash.opacity = (sin(t * 0.7) > 0.995) ? 0.5f : 0.0f;
    if (_rays) _rays.transform = CATransform3DMakeRotation((CGFloat)(t * 0.02), 0, 0, 1);
    if (_wetMask && _wiper) {
        double sweep = (sin(t * 1.4) + 1) / 2;              // 0..1
        _wiper.transform = CATransform3DMakeRotation((CGFloat)(-0.9 + sweep * 1.5), 0, 0, 1);
        CGMutablePathRef p = CGPathCreateMutable();
        CGPathAddRect(p, NULL, self.bounds);
        CGPathAddArc(p, NULL, _wiperPivot.x, _wiperPivot.y, _wiperLength, 0, (CGFloat)(sweep * 1.5), NO);
        _wetMask.path = p;
        CGPathRelease(p);
    }
}

- (void)ss_buildEngine {
    UIView *host = [self ss_host];
    BOOL metric = [[NSLocale currentLocale] usesMetricSystem];
    double cy = self.bounds.size.height * 0.52;
    double r = 30 * _unit;
    SSGauge *speed = [self ss_gaugeAt:CGPointMake(self.bounds.size.width * 0.3, cy) radius:r
                                label:OMCTr(@"Tốc độ", @"Speed") unit:metric ? @"km/h" : @"mph"
                                  max:metric ? 240 : 160 red:metric ? 200 : 130 in:host];
    SSGauge *rpm = [self ss_gaugeAt:CGPointMake(self.bounds.size.width * 0.7, cy) radius:r
                              label:OMCTr(@"Vòng tua", @"RPM") unit:@"x1000 rpm"
                                max:8 red:6.5 in:host];
    (void)speed; (void)rpm;
    NSString *car = self.carName.length ? [self.carName stringByTrimmingCharactersInSet:
                                           [NSCharacterSet whitespaceAndNewlineCharacterSet]] : @"";
    if (!car.length) car = @"DuoCar";
    UILabel *nameL = [self ss_label:car at:CGPointMake(self.bounds.size.width / 2, self.bounds.size.height * 0.13)
                               size:9 weight:UIFontWeightSemibold color:nil left:NO in:host maxWidth:0];
    [self ss_fade:nameL from:0.2 to:0.8 alpha:1];
    for (SSGauge *g in _gauges) {
        SSFade *f = [self ss_fade:(UIView *)g.number from:0.25 to:0.9 alpha:1];
        f.rise = 4 * _unit;
    }
    if (self.image) {
        UIImageView *logo = [[UIImageView alloc] initWithImage:self.image];
        logo.contentMode = UIViewContentModeScaleAspectFit;
        logo.frame = CGRectMake(self.bounds.size.width / 2 - 10 * _unit, self.bounds.size.height * 0.2,
                                20 * _unit, 12 * _unit);
        logo.layer.shadowColor = [UIColor whiteColor].CGColor;
        logo.layer.shadowOpacity = 0.4f; logo.layer.shadowRadius = 6; logo.layer.shadowOffset = CGSizeZero;
        [host addSubview:logo];
    }
}

- (void)ss_applyEngine:(double)t {
    if (_gauges.count < 2) return;
    // Idle sweep: gauges rise with pow easing and settle with a sine wobble.
    double p = MIN(1, t / 2.2);
    double ease = 1 - pow(1 - p, 3);
    [self ss_setGauge:_gauges[0] value:ease * 118 + sin(t * 2.1) * 2.5];
    [self ss_setGauge:_gauges[1] value:ease * 3.4 + sin(t * 3.7) * 0.25];
}

- (void)ss_buildWelcome {
    UIView *host = [self ss_host];
    NSInteger period = SSPeriodForDate(self.date ?: [NSDate date]);
    NSString *greet = SSGreetingForPeriod(period, self.name);
    UILabel *l = [self ss_label:greet at:CGPointMake(self.bounds.size.width / 2, self.bounds.size.height * 0.3)
                            size:13 weight:UIFontWeightSemibold color:nil left:NO in:host maxWidth:0];
    SSFade *f = [self ss_fade:l from:0.3 to:1.2 alpha:1];
    f.rise = 6 * _unit;
    // Car outline: bezier silhouette stroked progressively in applyWelcome.
    UIBezierPath *p = [UIBezierPath bezierPath];
    double w = self.bounds.size.width, h = self.bounds.size.height;
    [p moveToPoint:CGPointMake(w * 0.16, h * 0.66)];
    [p addLineToPoint:CGPointMake(w * 0.3, h * 0.64)];
    [p addQuadCurveToPoint:CGPointMake(w * 0.42, h * 0.5) controlPoint:CGPointMake(w * 0.36, h * 0.52)];
    [p addLineToPoint:CGPointMake(w * 0.6, h * 0.5)];
    [p addQuadCurveToPoint:CGPointMake(w * 0.72, h * 0.64) controlPoint:CGPointMake(w * 0.68, h * 0.52)];
    [p addLineToPoint:CGPointMake(w * 0.84, h * 0.66)];
    CAShapeLayer *outline = [CAShapeLayer layer];
    outline.frame = self.bounds;
    outline.path = p.CGPath;
    outline.fillColor = NULL;
    outline.strokeColor = [UIColor colorWithRed:0.48 green:0.42 blue:0.96 alpha:1].CGColor;
    outline.lineWidth = 2 * _unit;
    outline.lineCap = kCALineCapRound;
    outline.lineJoin = kCALineJoinRound;
    outline.strokeStart = 0; outline.strokeEnd = 0;
    outline.shadowColor = outline.strokeColor;
    outline.shadowOpacity = 0.7f; outline.shadowRadius = 8; outline.shadowOffset = CGSizeZero;
    [host.layer addSublayer:outline];
    _outline = outline;
}

- (void)ss_applyWelcome:(double)t {
    if (_outline) {
        double p = MAX(0, MIN(1, (t - 0.4) / 1.8));
        double e = 1 - pow(1 - p, 2);
        _outline.strokeEnd = (CGFloat)e;
        _outline.opacity = (float)(0.75 + 0.25 * sin(t * 1.8));
    }
}

- (void)ss_buildParticles {
    UIView *host = [self ss_host];
    [self ss_addCanvas];
    NSInteger period = SSPeriodForDate(self.date ?: [NSDate date]);
    NSString *text = self.name.length ? self.name : @"DuoCar";
    NSString *greet = SSGreetingForPeriod(period, nil);
    UILabel *l = [self ss_label:greet at:CGPointMake(self.bounds.size.width / 2, self.bounds.size.height * 0.16)
                            size:8 weight:UIFontWeightMedium
                           color:[UIColor colorWithWhite:1 alpha:0.85] left:NO in:host maxWidth:0];
    SSFade *f = [self ss_fade:l from:0.4 to:1.4 alpha:1]; f.outA = 1.6; f.outB = 2.6;
    // The binary rasterizes the greeting/name text into a bitmap context,
    // samples lit pixels (stride from arc4random offsets) and stores one
    // particle record per sample in _particles. [VERIFIED approach:
    // CGBitmapContextCreate + drawAtPoint:withAttributes: + bytes scan]
    NSDictionary *attrs = @{NSFontAttributeName: SSFont(16 * _unit, UIFontWeightBold),
                            NSForegroundColorAttributeName: [UIColor whiteColor]};
    CGSize ts = [text sizeWithAttributes:attrs];
    int bw = (int)ceil(ts.width), bh = (int)ceil(ts.height);
    if (bw > 0 && bh > 0) {
        void *data = calloc((size_t)bw * bh * 4, 1);
        CGContextRef ctx = CGBitmapContextCreate(data, bw, bh, 8, bw * 4,
                                                 CGColorSpaceCreateWithName(kCGColorSpaceSRGB),
                                                 kCGImageAlphaPremultipliedLast);
        if (ctx) {
            UIGraphicsPushContext(ctx);
            CGContextTranslateCTM(ctx, 0, bh);
            CGContextScaleCTM(ctx, 1, -1);
            [text drawAtPoint:CGPointZero withAttributes:attrs];
            UIGraphicsPopContext();
            const unsigned char *px = CGBitmapContextGetData(ctx);
            size_t bpr = CGBitmapContextGetBytesPerRow(ctx);
            NSMutableData *parts = [NSMutableData data];
            for (int y = 0; y < bh; y += 2) for (int x = 0; x < bw; x += 2) {
                if (px[y * bpr + x * 4 + 3] > 40) {
                    SSMote m = {0,
                        self.bounds.size.width / 2 - ts.width / 2 + x,
                        self.bounds.size.height * 0.42 - ts.height / 2 + y,
                        (double)arc4random_uniform(628) / 100.0,
                        (double)arc4random_uniform(1000) / 1000.0, 0, 0};
                    [parts appendBytes:&m length:sizeof(m)];
                }
            }
            _particles = parts;
            CGContextRelease(ctx);
        }
        free(data);
    }
}

- (void)ss_drawParticles:(CGContextRef)ctx t:(double)t {
    CGContextSetBlendMode(ctx, kCGBlendModePlusLighter);
    const SSMote *m = _particles.bytes;
    NSUInteger n = _particles.length / sizeof(SSMote);
    double dur = self.duration > 0 ? self.duration : 5;
    double ph = fmod(t, dur) / dur;
    for (NSUInteger i = 0; i < n; i++) {
        double dx = sin(t * 1.3 + m[i].a) * 3;
        double dy = cos(t * 1.1 + m[i].a * 1.7) * 3 - ph * 6 * m[i].b;
        double a = pow(1 - ph, 1.5) * (0.55 + 0.45 * sin(t * 2 + m[i].a));
        CGContextSetRGBFillColor(ctx, 0.72, 0.68, 1.0, (CGFloat)MAX(0, a));
        CGContextFillRect(ctx, CGRectMake(m[i].x + dx, m[i].y + dy, 2.2, 2.2));
    }
}

- (void)ss_buildHud {
    UIView *host = [self ss_host];
    NSString *car = self.carName.length ? self.carName : @"DuoCar";
    [self ss_label:car at:CGPointMake(self.bounds.size.width * 0.08, self.bounds.size.height * 0.16)
              size:8 weight:UIFontWeightSemibold color:nil left:YES in:host maxWidth:0];
    // Items source [VERIFIED — micro-fix pass, own capstone dump of
    // -[SSStartupView ss_buildHud], names via verify/macho_truth.py]:
    // the binary fetches [self hud] (0x4fc98), sends count (0x4fca8)
    // and branches on cbz (0x4fcac) — a single count test covers both
    // hud==nil and hud empty. Non-empty: items = self.hud (re-fetched
    // at 0x4fcb4). Empty: at 0x4fccc it fetches [self carName] — the
    // RAW property value, no sub_4da60 trim call intervenes — and
    // calls SSSampleHudItems (sub_50180) at 0x4fcdc. The result is a
    // LOCAL only (x24), consumed by the render loop below ([items
    // count] capped at 5, 0x4fcfc-0x4fd14); it is never stored back —
    // the method contains no setHud: call.
    NSArray *items = self.hud.count ? self.hud : SSSampleHudItems(self.carName);
    double y = self.bounds.size.height * 0.34;
    for (id item in items) {
        if (![item isKindOfClass:[NSDictionary class]]) continue;
        BOOL ok = [item[@"ok"] boolValue];
        NSString *line = [NSString stringWithFormat:@"%@ %@", ok ? @"✓" : @"!", item[@"text"] ?: @""];
        UILabel *l = [self ss_label:line at:CGPointMake(self.bounds.size.width * 0.08, y)
                               size:6.5 weight:UIFontWeightMedium
                              color:ok ? [UIColor colorWithWhite:1 alpha:0.9]
                                       : [UIColor colorWithRed:1 green:0.55 blue:0.5 alpha:1]
                               left:YES in:host maxWidth:self.bounds.size.width * 0.6];
        [self ss_fade:l from:0.3 + _fades.count * 0.12 to:1.0 alpha:1];
        y += self.bounds.size.height * 0.11;
    }
    if (self.batteryPercent >= 0) {
        _percentLabel = [self ss_label:[NSString stringWithFormat:@"%ld%%", (long)self.batteryPercent]
                                    at:CGPointMake(self.bounds.size.width * 0.86, self.bounds.size.height * 0.2)
                                  size:10 weight:UIFontWeightSemibold color:nil left:NO in:host maxWidth:0];
    }
    // Decorative dashed ring + scan gradient on the right side.
    CAShapeLayer *ring = [CAShapeLayer layer];
    ring.frame = self.bounds;
    ring.path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(self.bounds.size.width * 0.86, self.bounds.size.height * 0.52)
                                               radius:20 * _unit startAngle:0 endAngle:M_PI * 2 clockwise:YES].CGPath;
    ring.fillColor = NULL;
    ring.strokeColor = [UIColor colorWithRed:0.48 green:0.42 blue:0.96 alpha:0.7].CGColor;
    ring.lineWidth = 1.5 * _unit;
    ring.lineDashPattern = @[@4, @3];
    [host.layer addSublayer:ring];
    [_rings addObject:ring];
}

- (void)ss_applyHud:(double)t {
    for (CAShapeLayer *ring in _rings) {
        ring.transform = CATransform3DMakeRotation((CGFloat)(t * 0.25), 0, 0, 1);
        ring.strokeEnd = (CGFloat)(0.65 + 0.3 * sin(t * 0.8));
    }
    if (_percentLabel && self.batteryPercent >= 0) {
        NSInteger shown = (NSInteger)llround(self.batteryPercent * MIN(1, t / 1.2));
        if (shown != _percentShown) {
            _percentShown = shown;
            _percentLabel.text = [NSString stringWithFormat:@"%ld%%", (long)shown];
        }
    }
}

- (void)ss_buildBriefing {
    UIView *host = [self ss_host];
    NSMutableArray *lines = [NSMutableArray array];
    NSDate *date = self.date ?: [NSDate date];
    [lines addObject:[NSDateFormatter localizedStringFromDate:date
                                                    dateStyle:NSDateFormatterMediumStyle
                                                    timeStyle:NSDateFormatterShortStyle]];
    NSDictionary *w = self.weather;
    if (w) {
        NSMutableArray *parts = [NSMutableArray array];
        if (w[@"temp"]) [parts addObject:SSFormatTemp(w[@"temp"])];
        if (w[@"high"]) [parts addObject:[@"↑ " stringByAppendingString:SSFormatTemp(w[@"high"])]];
        if (w[@"low"])  [parts addObject:[@"↓ " stringByAppendingString:SSFormatTemp(w[@"low"])]];
        if (w[@"rain"]) [parts addObject:[NSString stringWithFormat:@"%@ %ld%%",
                                          OMCTr(@"Khả năng mưa", @"Chance of rain"),
                                          (long)[w[@"rain"] integerValue]]];
        if (parts.count) [lines addObject:[parts componentsJoinedByString:@" · "]];
    }
    NSDictionary *ev = [self.nextEvent isKindOfClass:[NSDictionary class]] ? self.nextEvent : nil;
    if (ev) {
        [lines addObject:OMCTr(@"Lịch hẹn kế tiếp", @"Next on your calendar")];
        NSString *title = ev[@"title"] ?: @"";
        NSDate *ed = [ev[@"date"] isKindOfClass:[NSDate class]] ? ev[@"date"] : nil;
        NSString *when = ed ? [NSDateFormatter localizedStringFromDate:ed
                                                            dateStyle:NSDateFormatterNoStyle
                                                            timeStyle:NSDateFormatterShortStyle] : @"";
        NSString *loc = ev[@"location"] ?: @"";
        NSString *line = title;
        if (when.length) line = [NSString stringWithFormat:@"%@ · %@", line, when];
        if (loc.length)  line = [NSString stringWithFormat:@"%@ · %@", line, loc];
        [lines addObject:line];
    }
    if (self.batteryPercent >= 0)
        [lines addObject:[NSString stringWithFormat:@"%@: %ld%%",
                          OMCTr(@"Pin", @"Battery"), (long)self.batteryPercent]];
    double y = self.bounds.size.height * 0.2;
    for (NSUInteger i = 0; i < lines.count; i++) {
        UILabel *l = [self ss_label:lines[i] at:CGPointMake(self.bounds.size.width * 0.07, y)
                               size:i == 0 ? 8 : 6.5
                             weight:i == 0 ? UIFontWeightSemibold : UIFontWeightRegular
                              color:[UIColor colorWithWhite:1 alpha:i == 0 ? 1 : 0.8]
                               left:YES in:host maxWidth:self.bounds.size.width * 0.86];
        SSFade *f = [self ss_fade:l from:0.25 + i * 0.15 to:0.95 alpha:1];
        f.rise = 3 * _unit; f.outEase = YES;
        y += self.bounds.size.height * 0.115;
    }
    UIView *card = [[UIView alloc] initWithFrame:CGRectInset(self.bounds, self.bounds.size.width * 0.04,
                                                             self.bounds.size.height * 0.08)];
    card.backgroundColor = [UIColor colorWithWhite:1 alpha:0.06];
    card.layer.cornerRadius = 12 * _unit;
    card.layer.cornerCurve = kCACornerCurveContinuous;
    card.layer.borderWidth = 0.5;
    card.layer.borderColor = [UIColor colorWithWhite:1 alpha:0.18].CGColor;
    [host insertSubview:card atIndex:0];
}

- (void)ss_buildLiquid {
    UIView *host = [self ss_host];
    // Animated gradient blobs (CABasicAnimation position/transform,
    // autoreversing, infinite) behind a masked label. [VERIFIED elements]
    NSArray *palettes = @[SSColors(0x8B7CFF, 0x5AB8FF), SSColors(0xFF7FA8, 0xFFB36B), SSColors(0x2BC79A, 0x27B4A4)];
    for (NSUInteger i = 0; i < palettes.count; i++) {
        CAGradientLayer *blob = [CAGradientLayer layer];
        double s = self.bounds.size.width * (0.5 + i * 0.12);
        blob.frame = CGRectMake(self.bounds.size.width * (0.12 + i * 0.28), self.bounds.size.height * 0.2, s, s);
        blob.cornerRadius = (CGFloat)(s / 2);
        blob.colors = palettes[i];
        [host.layer addSublayer:blob];
        CABasicAnimation *move = [CABasicAnimation animationWithKeyPath:@"position"];
        move.fromValue = [NSValue valueWithCGPoint:blob.position];
        move.toValue = [NSValue valueWithCGPoint:CGPointMake(blob.position.x + 30 * _unit,
                                                              blob.position.y + (i % 2 ? -18 : 18) * _unit)];
        move.duration = 3 + i * 0.7; move.autoreverses = YES; move.repeatCount = HUGE_VALF;
        move.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        [blob addAnimation:move forKey:@"ssLiquid"];
        CABasicAnimation *scale = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
        scale.fromValue = @0.9; scale.toValue = @1.12;
        scale.duration = move.duration; scale.autoreverses = YES; scale.repeatCount = HUGE_VALF;
        [blob addAnimation:scale forKey:@"ssLiquidScale"];
    }
    UILabel *l = [self ss_label:(self.name.length ? self.name : @"DuoCar")
                             at:CGPointMake(self.bounds.size.width / 2, self.bounds.size.height / 2)
                           size:15 weight:UIFontWeightBold color:nil left:NO in:host maxWidth:0];
    SSFade *f = [self ss_fade:l from:0.3 to:1.1 alpha:1]; f.rise = 5 * _unit;
    if (self.image) {
        UIImageView *logo = [[UIImageView alloc] initWithImage:self.image];
        logo.contentMode = UIViewContentModeScaleAspectFit;
        logo.frame = CGRectMake(self.bounds.size.width / 2 - 9 * _unit, self.bounds.size.height * 0.18,
                                18 * _unit, 11 * _unit);
        [host addSubview:logo];
        l.maskView = logo;   // the binary sets a mask view on one label [INFERRED which]
    }
}

- (void)ss_buildFestive {
    UIView *host = [self ss_host];
    [self ss_addCanvas];
    NSString *name = self.name;
    NSString *title = nil, *sub = nil, *emoji = nil;
    switch (self.occasion) {
        case 2:
            emoji = @"🎂";
            title = name.length ? [NSString stringWithFormat:OMCTr(@"Chúc mừng sinh nhật, %@!", @"Happy birthday, %@!"), name]
                                : OMCTr(@"Chúc mừng sinh nhật!", @"Happy birthday!");
            sub = OMCTr(@"Sức khỏe, may mắn và thượng lộ bình an", @"Health, luck and safe travels");
            break;
        case 3:
            emoji = @"🎄";
            title = OMCTr(@"Giáng sinh vui vẻ", @"Merry Christmas");
            sub = name.length ? [NSString stringWithFormat:OMCTr(@"Thượng lộ bình an, %@", @"Safe travels, %@"), name]
                              : OMCTr(@"Thượng lộ bình an", @"Safe travels");
            break;
        case 4:
            title = OMCTr(@"Chúc Tết Trung thu", @"Happy Mid-Autumn Festival");
            sub = OMCTr(@"Trăng tròn, đường thông", @"Full moon and clear roads");
            break;
        case 5: {
            NSInteger year = [[NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian]
                              component:NSCalendarUnitYear fromDate:self.date ?: [NSDate date]];
            title = [NSString stringWithFormat:OMCTr(@"Chúc mừng năm mới %ld", @"Happy New Year %ld"), (long)year];
            sub = OMCTr(@"Sức khỏe, may mắn và thượng lộ bình an", @"Health, luck and safe travels");
            break;
        }
        default:
            title = name.length ? [NSString stringWithFormat:OMCTr(@"Chúc ngày lễ vui vẻ, %@", @"Happy holidays, %@"), name]
                                : OMCTr(@"Chúc ngày lễ vui vẻ", @"Happy holidays");
            sub = OMCTr(@"Chúc bạn lái xe vui vẻ hôm nay", @"Enjoy the drive today");
            break;
    }
    double cy = self.bounds.size.height;
    if (emoji) [self ss_label:emoji at:CGPointMake(self.bounds.size.width / 2, cy * 0.24)
                          size:16 weight:UIFontWeightRegular color:nil left:NO in:host maxWidth:0];
    UILabel *t = [self ss_label:title at:CGPointMake(self.bounds.size.width / 2, cy * 0.46)
                            size:11 weight:UIFontWeightBold color:nil left:NO in:host maxWidth:self.bounds.size.width * 0.9];
    UILabel *s = [self ss_label:sub at:CGPointMake(self.bounds.size.width / 2, cy * 0.62)
                            size:6.5 weight:UIFontWeightRegular
                           color:[UIColor colorWithWhite:1 alpha:0.8] left:NO in:host maxWidth:0];
    [self ss_fade:t from:0.3 to:1.1 alpha:1];
    [self ss_fade:s from:0.6 to:1.4 alpha:1];
    // Confetti motes + firework burst records (drawn by ss_drawFireworks:).
    for (NSInteger i = 0; i < 46; i++) {
        CALayer *confetti = [CALayer layer];
        double sz = (2 + arc4random_uniform(3)) * _unit;
        confetti.frame = CGRectMake(0, 0, sz, sz * 0.6);
        confetti.backgroundColor = [UIColor colorWithRed:(arc4random_uniform(70) + 160) / 255.0
                                                   green:(arc4random_uniform(70) + 120) / 255.0
                                                    blue:(arc4random_uniform(70) + 160) / 255.0 alpha:1].CGColor;
        confetti.cornerRadius = 1;
        SSMote m = {1, (double)arc4random_uniform(1000) / 1000.0,
                       (double)arc4random_uniform(1000) / 1000.0,
                       (double)arc4random_uniform(628) / 100.0, 0.06, 0, 0};
        [self ss_addMote:m layer:confetti to:host];
    }
    NSMutableData *bursts = [NSMutableData data];
    for (NSInteger i = 0; i < 5; i++) {
        SSMote brec = {0, 0.15 + (double)arc4random_uniform(700) / 1000.0,
                          0.15 + (double)arc4random_uniform(350) / 1000.0,
                          i * 0.9, 26 + arc4random_uniform(10), 0, 0};
        [bursts appendBytes:&brec length:sizeof(brec)];
    }
    _bursts = bursts;
}

- (void)ss_drawFireworks:(CGContextRef)ctx t:(double)t {
    CGContextSetBlendMode(ctx, kCGBlendModePlusLighter);
    const SSMote *b = _bursts.bytes;
    NSUInteger n = _bursts.length / sizeof(SSMote);
    CGSize size = self.bounds.size;
    for (NSUInteger i = 0; i < n; i++) {
        double local = t - b[i].a;
        if (local < 0) continue;
        double life = fmod(local, 2.8) / 2.8;
        double cx = b[i].x * size.width, cy = b[i].y * size.height;
        NSInteger rays = (NSInteger)b[i].b;
        for (NSInteger k = 0; k < rays; k++) {
            double ang = (2 * M_PI * k) / rays + b[i].a;
            double r = life * 46 * _unit * (0.7 + 0.3 * sin(b[i].a * 7 + k));
            double px = cx + cos(ang) * r;
            double py = cy + sin(ang) * r + life * life * 18 * _unit;
            double a = pow(1 - life, 1.6);
            CGContextSetRGBFillColor(ctx, 1.0, 0.8, 0.45, (CGFloat)MAX(0, a));
            double s = 2.4 * (1 - life * 0.5);
            CGContextFillEllipseInRect(ctx, CGRectMake(px - s / 2, py - s / 2, s, s));
        }
    }
}

- (void)ss_drawCanvas:(CGContextRef)ctx size:(CGSize)size {
    double t = [self ss_now] - _t0;
    if (_sceneStyle == 6) [self ss_drawParticles:ctx t:t];
    else if (_sceneStyle == 11) [self ss_drawFireworks:ctx t:t];
}

@end
