// SPPOverspeed.m — reconstructed from OmniCarSpeedBubble.dylib (arm64).
// Agent A (display side). The over-speed warner that runs in SpringBoard:
// owns a pass-through window on the CAR display holding two overlay layers
// (a stroked "glow" frame image and a translucent red "flash" view) and
// pulses them when the current speed exceeds limit + margin. It also fires
// the warning sound/voice (SPPWarningSound.m) on a re-armable one-shot.
// Class: SPPOverspeed : NSObject. Status: VERIFIED from disassembly
// except where a comment says INFERRED.

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import <objc/message.h>   // objc_msgSend casts (phase-2 compile fix: was undeclared)

// SPPPrefs (SPPPrefs.m)
@interface SPPPrefs : NSObject
+ (BOOL)enabled;
+ (NSInteger)warnMode;
+ (double)warnMarginKmh;
+ (NSInteger)warnFx;
+ (BOOL)warnVoice;
+ (NSInteger)warnTone;
+ (NSInteger)warnVoiceLine;
+ (NSString *)warnVoiceText;
@end

// SPPBubble (SPPBubble.m) — only the warning-shake outlet is used here.
@interface SPPBubble : NSObject
+ (instancetype)shared;
- (void)setWarnShake:(BOOL)shake;
@end

// SPPWindowFactory.m / SPPWarningSound.m
extern id SPPGetCarPlayCADisplay(void);
extern UIWindow *SPPMakeCarWindow(void *metrics);
extern void SPPMakeWindowPassThrough(UIWindow *window);
extern NSString *SPPVoiceLine(NSInteger line, NSString *customText, NSInteger limit);
extern void SPPPlayTone(NSInteger tone);
extern void SPPSpeak(NSString *text);
extern void _OMCLogWrite(NSString *module, NSString *message);

@interface SPPOverspeed : NSObject
// [phase-2 integration; backported to src in phase 3] @property census: all 18 properties from the binary
// property list (metadata/raw/OmniCarSpeedBubble/objc.json: name + type
// encoding per ivar; attributes T@<class>,&,N objects / T@<class>,C,N for
// displayID+voiceText / T<enc>,N scalars). The src interface declared none,
// so the 36 synthesized accessors + .cxx_destruct counted UNCLAIMED in
// metadata/COVERAGE_GAPS.md (37 entries) were never generated.
@property (nonatomic, strong) UIWindow *window;
@property (nonatomic, strong) UIImageView *glow;
@property (nonatomic, strong) UIView *flash;
@property (nonatomic) NSInteger shownFx;
@property (nonatomic, copy) NSString *displayID;
@property (nonatomic) int speed;
@property (nonatomic) int limit;
@property (nonatomic) BOOL enabled;
@property (nonatomic) NSInteger mode;
@property (nonatomic) double marginKmh;
@property (nonatomic) NSInteger fx;
@property (nonatomic) BOOL voice;
@property (nonatomic) NSInteger tone;
@property (nonatomic) NSInteger voiceLine;
@property (nonatomic, copy) NSString *voiceText;
@property (nonatomic) BOOL over;
@property (nonatomic) BOOL armed;
@property (nonatomic) double belowSince;
+ (instancetype)shared;
- (void)loadPrefs;
- (void)reloadPrefs;
- (void)updateSpeed:(NSInteger)speed limit:(NSInteger)limit;
- (void)carChanged;
- (void)evaluate;
- (BOOL)ensureWindow;
- (void)dropWindow;
- (void)showFx:(NSInteger)fx;
@end

@implementation SPPOverspeed {
    UIWindow *_window;          // car-display warning window
    UIImageView *_glow;         // stroked-frame image view (fx 0/1)
    UIView *_flash;             // translucent red view (fx 2)
    NSInteger _shownFx;         // -1 hidden, else the fx being shown
    NSString *_displayID;       // [phase-2 integration; backported to src in phase 3] was `id`: binary ivar type is @"NSString" (property T@"NSString",C,N). uniqueId of the CADisplay in use
    int _speed;                 // [phase-2 integration; backported to src in phase 3] was NSInteger: binary ivar type is `i` (property Ti). km/h, -1 = invalid
    int _limit;                 // [phase-2 integration; backported to src in phase 3] was NSInteger: binary ivar type is `i` (property Ti). km/h, -1 = invalid
    BOOL _enabled;
    NSInteger _mode;            // warnMode bitfield: bit0 visual, bit1 sound
    double _marginKmh;          // over-margin, km/h
    NSInteger _fx;              // warnFx 0..3 (3 = shake the bubble instead)
    BOOL _voice;                // warnVoice: speak instead of tone
    NSInteger _tone;            // warnTone 0..5
    NSInteger _voiceLine;       // warnVoiceLine 0..8
    NSString *_voiceText;       // warnVoiceText (custom line 8)
    BOOL _over;                 // currently over the threshold
    BOOL _armed;                // sound one-shot is armed
    double _belowSince;         // timestamp speed fell back under threshold
}

// +[SPPOverspeed shared] @0x1f458 + init block sub_1f49c — VERIFIED:
// speed = limit = -1, armed = YES, shownFx = -1, then loadPrefs.
+ (instancetype)shared {
    static SPPOverspeed *instance;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        instance = [self new];
        instance->_speed = -1;
        instance->_limit = -1;
        instance->_armed = YES;
        instance->_shownFx = -1;
        [instance loadPrefs];
    });
    return instance;
}

// -loadPrefs @0x1f508 — VERIFIED: snapshot SPPPrefs into ivars.
- (void)loadPrefs {
    _enabled = [SPPPrefs enabled];
    _mode = [SPPPrefs warnMode];
    _marginKmh = [SPPPrefs warnMarginKmh];
    _fx = [SPPPrefs warnFx];
    _voice = [SPPPrefs warnVoice];
    _tone = [SPPPrefs warnTone];
    _voiceLine = [SPPPrefs warnVoiceLine];
    _voiceText = [SPPPrefs warnVoiceText];
}

// -reloadPrefs @0x1f5e8 — VERIFIED: just loadPrefs again.
- (void)reloadPrefs {
    [self loadPrefs];
}

// -updateSpeed:limit: @0x1f64c — VERIFIED.
- (void)updateSpeed:(NSInteger)speed limit:(NSInteger)limit {
    _speed = speed;
    _limit = limit;
    [self evaluate];
}

// -carChanged @0x1f60c — VERIFIED: car display gone -> drop the window,
// then re-evaluate either way.
- (void)carChanged {
    if (!SPPGetCarPlayCADisplay()) {
        [self dropWindow];
    }
    [self evaluate];
}

// -evaluate @0x1f680 — VERIFIED (threshold, hysteresis, gating, logging).
//   have      = speed valid AND limit > 0
//   over      = speed > limit + marginKmh          (strict)
//   re-arm    = after 5.0 s continuously NOT over (with valid data),
//               armed = YES again; any over/no-data sample resets the timer
//   wantFx    = enabled && mode >= 1 && car display present && have
//               (so with no car display there is NO warning at all,
//                not even sound)
//   warnMode is a bitfield: bit 0 = visual FX, bit 1 = sound.
//   fx == 3 means "shake the bubble" instead of the car-window effect.
- (void)evaluate {
    BOOL have = (_speed > -1) && (_limit > 0);
    double threshold = (double)_limit + _marginKmh;
    BOOL overNow = have && ((double)_speed > threshold);

    if (have && !overNow) {
        if (_belowSince == 0) {
            _belowSince = CFAbsoluteTimeGetCurrent();   // VERIFIED clock
        } else if (CFAbsoluteTimeGetCurrent() - _belowSince >= 5.0
                   && !_armed) {
            _armed = YES;
            _OMCLogWrite(@"SpeedBubble",
                @"canh bao: da cham lai duoi nguong -> lan vuot sau se keu");
        }
    } else {
        _belowSince = 0;
    }

    BOOL wantFx = _enabled && (_mode >= 1) && (SPPGetCarPlayCADisplay() != nil) && have;
    if (!wantFx) {
        if (_over) {
            _OMCLogWrite(@"SpeedBubble",
                [NSString stringWithFormat:@"canh bao: het vuot (toc do %d, gioi han %d)",
                                           (int)_speed, (int)_limit]);
            _over = NO;
        }
        [[SPPBubble shared] setWarnShake:NO];
        [self showFx:-1];
        return;
    }

    if (overNow && !_over) {
        _OMCLogWrite(@"SpeedBubble",
            [NSString stringWithFormat:@"canh bao: %d km/h > gioi han %d %+.0f -> vien do (che do %ld)",
                                       (int)_speed, (int)_limit, _marginKmh, (long)_mode]);
        _over = YES;
    } else if (!overNow && _over) {
        _OMCLogWrite(@"SpeedBubble",
            [NSString stringWithFormat:@"canh bao: het vuot (toc do %d, gioi han %d)",
                                       (int)_speed, (int)_limit]);
        _over = NO;
    }

    if (_over && _armed) {
        if (_mode & 2) {   // sound bit
            if (_voice) {
                NSString *line = SPPVoiceLine(_voiceLine, _voiceText, _limit);
                SPPSpeak(line);
                _OMCLogWrite(@"SpeedBubble",
                    [NSString stringWithFormat:@"canh bao: noi \"%@\"", line]);
            } else {
                SPPPlayTone(_tone);
                _OMCLogWrite(@"SpeedBubble",
                    [NSString stringWithFormat:@"canh bao: phat am bao %ld", (long)_tone]);
            }
        }
        _armed = NO;   // one shot per re-arm
    }

    [[SPPBubble shared] setWarnShake:((_mode & 1) && _fx == 3)];
    [self showFx:(_mode & 1) ? (_fx == 3 ? -1 : _fx) : -1];
}

#pragma mark - Warning window

// Glow frame images (VERIFIED renders; the two file-static caches sit at
// bss+0x258 (orange) and bss+0x260 (red)).
//   SPPGlowImageOrange (sub_1ff2c, render block sub_20b50): 74x74,
//     capInsets 36; rounded rect inset 3, radius 18, lineWidth 6, color
//     (1, 0.17, 0.18, 1) stroked twice with a same-color CG shadow
//     (offset zero, blur 20); then lineWidth 2 stroke in (1, 0.55, 0.55, 0.9).
//   SPPGlowImageRed (render block sub_20d48): 122x122; for inset in
//     0..<122 step 1: rounded rect CGRectInset(bounds, inset, inset + 0.5),
//     radius max(30 - 0.5*inset, 2), lineWidth 1.2, stroke color
//     (1, 0.23, 0.19, alpha = 0.6 * t^2), t = 1 - inset/122.
// (The render bodies are long UIGraphicsImageRenderer blocks; they are
//  transcribed in the report's evidence table and drawn exactly as above.)
//
// Phase-2 compile fix: agent A left only forward declarations for the
// two getters, so the file failed with -Wundefined-internal once its
// objc_msgSend error was fixed. The bodies below implement exactly the
// renders documented above; the phase-2 pass spot-verified the
// constants against the binary (orange getter sub_1ff2c: renderer +
// imageWithActions:, resizableImageWithCapInsets:resizingMode: with
// all four insets = 36.0 and mode 1 (tile), result cached in the
// global @0x439f8; orange block sub_20b50: inset 3, radius 18,
// lineWidth 6 and 2, shadow blur 20; red block sub_20d48: radius base
// 30, slope 0.5, floor 2, UIBezierPath strokes in a loop).
static UIImage *SPPGlowImageOrange(void) {
    static UIImage *cached;
    if (cached) return cached;
    UIGraphicsImageRenderer *renderer = [[UIGraphicsImageRenderer alloc]
        initWithSize:CGSizeMake(74, 74)];
    UIImage *image = [renderer imageWithActions:
        ^(UIGraphicsImageRendererContext *ctx) {
        CGContextRef cg = ctx.CGContext;
        UIColor *stroke = [UIColor colorWithRed:1.0 green:0.17
                                           blue:0.18 alpha:1.0];
        CGRect rect = CGRectInset(CGRectMake(0, 0, 74, 74), 3, 3);
        UIBezierPath *path = [UIBezierPath
            bezierPathWithRoundedRect:rect cornerRadius:18];
        CGContextSetShadowWithColor(cg, CGSizeZero, 20,
                                    stroke.CGColor);
        [stroke setStroke];
        path.lineWidth = 6;
        [path stroke];
        [path stroke];   // second stroke, same shadow (VERIFIED)
        CGContextSetShadowWithColor(cg, CGSizeZero, 0, NULL);
        [[UIColor colorWithRed:1.0 green:0.55 blue:0.55 alpha:0.9]
            setStroke];
        path.lineWidth = 2;
        [path stroke];
    }];
    cached = [image resizableImageWithCapInsets:
        UIEdgeInsetsMake(36, 36, 36, 36)
        resizingMode:UIImageResizingModeTile];
    return cached;
}
static UIImage *SPPGlowImageRed(void) {
    static UIImage *cached;
    if (cached) return cached;
    UIGraphicsImageRenderer *renderer = [[UIGraphicsImageRenderer alloc]
        initWithSize:CGSizeMake(122, 122)];
    cached = [renderer imageWithActions:
        ^(UIGraphicsImageRendererContext *ctx) {
        (void)ctx;
        CGRect bounds = CGRectMake(0, 0, 122, 122);
        for (double inset = 0; inset < 122; inset += 1) {
            double t = 1 - inset / 122;
            double radius = fmax(30 - 0.5 * inset, 2);
            UIBezierPath *path = [UIBezierPath
                bezierPathWithRoundedRect:
                    CGRectInset(bounds, inset, inset + 0.5)
                cornerRadius:radius];
            [[UIColor colorWithRed:1.0 green:0.23 blue:0.19
                              alpha:0.6 * t * t] setStroke];
            path.lineWidth = 1.2;
            [path stroke];
        }
    }];
    return cached;
}

// -ensureWindow @0x1fab8 — VERIFIED.
- (BOOL)ensureWindow {
    id display = SPPGetCarPlayCADisplay();
    if (!display) {
        [self dropWindow];
        return NO;
    }
    id uid = nil;
    SEL uidSel = NSSelectorFromString(@"uniqueId");
    if ([display respondsToSelector:uidSel]) {
        uid = ((id (*)(id, SEL))objc_msgSend)(display, uidSel);
    } else {
        extern void _OMCMissingSelector(NSString *, id, NSString *);
        // Binary @0x1fb7c: x1 = the CADisplay (x19, the result of
        // _SPPGetCarPlayCADisplay), x2 = @"uniqueId".
        _OMCMissingSelector(@"SpeedBubble", display, @"uniqueId");
    }
    if (_window && (uid == nil || [_displayID isEqual:uid])) {
        return YES;   // same display: keep the existing window
    }
    [self dropWindow];
    double metrics[8] = {0};
    ((double *)metrics)[0] = 2.0;   // preferred scale (see SPPWindowFactory.m)
    _window = SPPMakeCarWindow(metrics);
    if (!_window) return NO;
    SPPMakeWindowPassThrough(_window);
    _window.userInteractionEnabled = NO;
    _window.windowLevel = UIWindowLevelStatusBar + 65.0;
    _window.backgroundColor = [UIColor clearColor];
    _glow = [[UIImageView alloc] initWithFrame:_window.bounds];
    _glow.image = SPPGlowImageOrange();
    _glow.autoresizingMask = 0x12;   // flexible width | height
    _glow.userInteractionEnabled = NO;
    _glow.alpha = 0;
    [_window addSubview:_glow];
    _flash = [[UIView alloc] initWithFrame:_window.bounds];
    _flash.backgroundColor = [UIColor colorWithRed:1.0 green:0.23 blue:0.19 alpha:0.32];
    _flash.autoresizingMask = 0x12;
    _flash.userInteractionEnabled = NO;
    _flash.alpha = 0;
    [_window addSubview:_flash];
    _window.hidden = YES;
    _displayID = uid;
    _shownFx = -1;
    _OMCLogWrite(@"SpeedBubble",
        [NSString stringWithFormat:@"canh bao: cua so vien tren xe tao xong (%.0fx%.0f)",
                                   _window.bounds.size.width,
                                   _window.bounds.size.height]);
    return YES;
}

// -dropWindow @0x20050 — VERIFIED.
- (void)dropWindow {
    [_glow.layer removeAllAnimations];
    [_flash.layer removeAllAnimations];
    _window.hidden = YES;
    _window = nil;
    _glow = nil;
    _flash = nil;
    _displayID = nil;
}

// -showFx: @0x20198 — VERIFIED.
//   fx < 0 : fade both layers out over 0.25 s, then hide the window.
//   fx == 2: flash mode — glow off, flash at alpha 1, pulse flash to 0.
//   fx 0/1 : glow mode — glow image = red (0) or orange (1), flash off.
//   Pulse: CABasicAnimation on opacity, autoreverses, repeats forever,
//   easeInEaseOut, key "sppWarnPulse"; durations 0.7 s (fx 0),
//   1.6 s (fx 1), 0.45 s (fx 2); glow pulses 1 -> 0.25, flash 1 -> 0.
- (void)showFx:(NSInteger)fx {
    if (fx < 0) {
        _shownFx = -1;
        if (_window && !_window.hidden) {
            [_glow.layer removeAnimationForKey:@"sppWarnPulse"];
            [_flash.layer removeAnimationForKey:@"sppWarnPulse"];
            [UIView animateWithDuration:0.25 animations:^{
                _glow.alpha = 0;
                _flash.alpha = 0;
            } completion:^(BOOL finished) {
                if (_glow.alpha < 0.01 && _flash.alpha < 0.01) {
                    _window.hidden = YES;
                }
            }];
        }
        return;
    }
    if (![self ensureWindow]) return;
    if (fx == _shownFx && !_window.hidden) return;
    [_glow.layer removeAllAnimations];
    [_flash.layer removeAllAnimations];
    _window.hidden = NO;
    CALayer *target;
    if (fx == 2) {
        _glow.alpha = 0;
        _flash.alpha = 1;
        target = _flash.layer;
    } else {
        _glow.alpha = 1;
        _flash.alpha = 0;
        _glow.image = (fx == 1) ? SPPGlowImageOrange() : SPPGlowImageRed();
        target = _glow.layer;
    }
    CABasicAnimation *pulse = [CABasicAnimation animationWithKeyPath:@"opacity"];
    pulse.fromValue = @1.0;
    pulse.toValue = (fx == 2) ? @0.0 : @0.25;
    pulse.duration = (fx == 0) ? 0.7 : (fx == 1) ? 1.6 : 0.45;
    pulse.autoreverses = YES;
    pulse.repeatCount = HUGE_VALF;
    pulse.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    [target addAnimation:pulse forKey:@"sppWarnPulse"];
    _shownFx = fx;
}

@end
