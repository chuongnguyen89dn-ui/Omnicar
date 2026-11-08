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
- (void)ss_drawCanvas:(SSCanvasView *)canvas size:(CGSize)size;
- (void)buildGreetingWithDate:(NSDate *)date period:(NSInteger)period;
- (void)buildWeatherWithPeriod:(NSInteger)period;
- (void)applyUnit:(double)unit;
@end

// Font helper used by every label path (sub_f6ac). [INFERRED scaling: the
// layout unit multiplies the base size in applyUnit:/layout paths.]
static UIFont *SSFont(double size, UIFontWeight weight) {
    return [UIFont systemFontOfSize:size weight:weight];
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
- (void)drawRect:(CGRect)rect {   // 0xc584 [VERIFIED]
    if (!UIGraphicsGetCurrentContext()) return;
    [self.owner ss_drawCanvas:self size:self.bounds.size];
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
    _sceneStyle = self.style;   // refined by occasion/tempo branches in the original

    CAGradientLayer *gradient = (CAGradientLayer *)self.layer;
    gradient.type = kCAGradientLayerAxial;
    gradient.startPoint = CGPointMake(0.5, 0.0);
    gradient.endPoint = CGPointMake(0.5, 1.0);
    gradient.colors = [self ss_sceneColors];

    if (self.image) {
        UIImageView *poster = [[UIImageView alloc] initWithFrame:self.bounds];
        poster.clipsToBounds = YES;
        poster.image = self.image;
        poster.contentMode = self.imageFits ? UIViewContentModeScaleAspectFit
                                            : UIViewContentModeScaleAspectFill;
        [self addSubview:poster];
        _posterView = poster;
        _logoView = poster;
    } else {
        // No logo file: an SF Symbol glyph stands in for it. The video style
        // uses "play.rectangle.fill", the others "car.fill". [VERIFIED names]
        UIImageView *glyph = [UIImageView new];
        glyph.image = [UIImage systemImageNamed:self.style == 0 ? @"play.rectangle.fill"
                                                                : @"car.fill"];
        glyph.tintColor = self.style == 0 ? [UIColor colorWithWhite:1.0 alpha:0.85]
                                          : UIColor.whiteColor;
        glyph.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:glyph];
        _logoView = glyph;
    }

    if (self.weather) [self buildWeatherWithPeriod:period];
    else [self buildGreetingWithDate:date period:period];
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

// Weather-condition symbol for an Open-Meteo WMO code (helper at 0xd4f0).
// [INFERRED table; "cloud.fill" is VERIFIED present]
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

- (void)layoutSubviews {   // 0xeefc [VERIFIED]
    [super layoutSubviews];
    CGSize size = self.bounds.size;
    if (size.width <= 0 || size.height <= 0) return;
    if (!CGSizeEqualToSize(size, _sceneSize)) [self ss_buildScene];
    _posterView.frame = self.bounds;
    if (_logoView) {
        _logoView.bounds = CGRectMake(0, 0, size.width, size.height);
        _logoView.center = CGPointMake(size.width / 2, size.height / 2);
        _logoView.layer.shadowRadius = 24;   // [INFERRED value]
    }
    [self applyUnit:MIN(size.width, size.height) / 400.0];   // [INFERRED unit formula]
}

- (void)applyUnit:(double)unit {   // 0xf110 [VERIFIED purpose: re-scale fonts,
                                   // shadows and constraint constants to the unit]
    _unit = unit;
    _timeLabel.font = SSFont(64 * unit, UIFontWeightLight);
    _titleLabel.font = SSFont(28 * unit, UIFontWeightSemibold);
    _dateLabel.font = SSFont(17 * unit, UIFontWeightMedium);
    _tempLabel.font = SSFont(64 * unit, UIFontWeightLight);
    for (NSLayoutConstraint *c in _cardInsets ?: @[]) c.constant *= 1.0;   // constants rescaled in the original
}

// ---------------------------------------------------------------------------
// Intro + animation clock
// ---------------------------------------------------------------------------

- (void)playIntro {   // 0xf768 [VERIFIED]
    [self layoutIfNeeded];
    if (_logoView) {
        CALayer *layer = _logoView.layer;
        [layer removeAllAnimations];
        layer.shadowOpacity = 0.0;
        _logoView.alpha = 0.0;
        _logoView.transform = CGAffineTransformMakeScale(0.8, 0.8);   // [INFERRED per-logoEffect variant]
        [UIView animateWithDuration:0.9 delay:0.0 usingSpringWithDamping:0.7
              initialSpringVelocity:0.0 options:0 animations:^{
            self->_logoView.alpha = 1.0;
            self->_logoView.transform = CGAffineTransformIdentity;
            layer.shadowColor = UIColor.whiteColor.CGColor;
            layer.shadowOffset = CGSizeZero;
            layer.shadowRadius = 32;
            layer.shadowOpacity = 0.8;
        } completion:nil];
        CABasicAnimation *glow = [CABasicAnimation animationWithKeyPath:@"shadowOpacity"];
        glow.fromValue = @0.4;
        glow.toValue = @0.9;
        glow.duration = 1.6;
        glow.autoreverses = YES;
        glow.repeatCount = HUGE_VALF;
        glow.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        [layer addAnimation:glow forKey:@"ssGlow"];
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

- (void)ss_buildScene {   // 0x10570 [VERIFIED dispatch; sceneStyle numbers INFERRED]
    [self ss_clearScene];
    CGSize size = self.bounds.size;
    if (size.width <= 0 || size.height <= 0) return;
    _sceneSize = size;
    UIView *scene = [[UIView alloc] initWithFrame:self.bounds];
    scene.userInteractionEnabled = NO;
    [self insertSubview:scene atIndex:0];
    _scene = scene;
    switch (_sceneStyle) {   // cmp chain at 0x10690-0x10740 covers values 3-9;
                             // style names VERIFIED from Settings, mapping INFERRED
        case 3: [self ss_buildSky]; break;         // Weather backdrop
        case 4: [self ss_buildEngine]; break;      // Engine
        case 5: [self ss_buildWelcome]; break;     // Welcome
        case 6: [self ss_buildParticles]; break;   // Particles
        case 7: [self ss_buildHud]; break;         // HUD
        case 8: [self ss_buildBriefing]; break;    // Briefing
        case 9: [self ss_buildLiquid]; break;      // Liquid
        case 11: [self ss_buildFestive]; break;    // Occasion
        default: [self ss_buildSky]; break;
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
                 left:(BOOL)left in:(UIView *)container maxWidth:(double)maxWidth {   // 0x108c8 [VERIFIED]
    UILabel *label = [UILabel new];
    label.text = text;
    label.font = SSFont(size, weight);
    label.textColor = color ?: UIColor.whiteColor;
    label.textAlignment = left ? NSTextAlignmentLeft : NSTextAlignmentCenter;
    label.layer.shadowOpacity = 0.6;   // [INFERRED values]
    label.layer.shadowRadius = 6;
    label.layer.shadowOffset = CGSizeZero;
    label.layer.shouldRasterize = YES;
    label.layer.rasterizationScale = self.traitCollection.displayScale;
    CGSize fit = [label sizeThatFits:CGSizeMake(maxWidth > 0 ? maxWidth : CGFLOAT_MAX, CGFLOAT_MAX)];
    label.bounds = CGRectMake(0, 0, fit.width, fit.height);
    label.center = point;
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

- (void)ss_drawCanvas:(SSCanvasView *)canvas size:(CGSize)size {   // 0x1a30c [VERIFIED dispatch]
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    if (!ctx) return;
    double t = [self ss_now];
    if (_sceneStyle == 6) [self ss_drawParticles:ctx t:t];        // Particles [INFERRED number]
    else if (_sceneStyle == 11) [self ss_drawFireworks:ctx t:t];  // Occasion/festive
}

@end
