// SPPBubble.m — reconstructed from OmniCarSpeedBubble.dylib (arm64).
// Agent A (display side). SPPBubble : NSObject — the SpringBoard-side
// controller of the speed bubble: it consumes readings from the selected
// source app, arbitrates between sources, decides visibility, owns the
// bubble window (on the phone screen or on the CarPlay display), the
// card + SPPBubbleView, gestures (tap / pan / pinch / long-press), the
// long-press menu, and feeds SPPOverspeed.
// Status: VERIFIED from disassembly except where a comment says INFERRED.
// Log strings are the module's own (tag "SpeedBubble").

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <notify.h>
#import <math.h>
#import <objc/runtime.h>   // objc_getClass (phase-2 compile fix: was undeclared)
#import <objc/message.h>   // objc_msgSend casts (phase-2 compile fix: was undeclared)

extern void _OMCLogWrite(NSString *module, NSString *message);
// 3-argument form, as proven at the binary definition (_OMCMissingSelector
// @0x2248c: retains x0 module, x1 object, x2 name; logs the object's class
// + the name) and at every call site in this file (see call-site comments).
extern void _OMCMissingSelector(NSString *module, id object,
                                NSString *selectorName);
extern BOOL _OMCLiteActive(void);   // OMC core: lite (low-power) build flag
extern UIImage *_OMCLogoMeshImage(int style);   // [phase-2 integration; backported to src in phase 3] binary takes a style arg: showMenu passes w0 = 0 (@0x1b590); matches OMCCommon.h `id OMCLogoMeshImage(int)`

static void SPPStripLayerShadows(CALayer *layer);
static void SPPDrawIconTile(UIGraphicsImageRendererContext *ctx,
                            NSInteger appIndex, NSString *shortName);
static void SPPApplyCrispScaleToLayer(CALayer *layer, double scale,
                                      BOOL isMask);

// SPPPrefs (SPPPrefs.m)
@interface SPPPrefs : NSObject
+ (BOOL)enabled;
+ (NSInteger)style;
+ (BOOL)showAppIcon;
+ (NSInteger)color;
+ (NSInteger)warnMode;
+ (void)setWarnMode:(NSInteger)mode;
+ (double)sizePercentForCar:(BOOL)car;
+ (void)setSizePercent:(double)percent forCar:(BOOL)car;
@end

// SPPOverspeed (SPPOverspeed.m)
@interface SPPOverspeed : NSObject
+ (instancetype)shared;
- (void)updateSpeed:(NSInteger)speed limit:(NSInteger)limit;
@end

// SPPBubbleView (SPPBubbleView.m)
@class SPPGlassView, SPPIconView, SPPSignView;  // [phase-2 integration; backported to src in phase 3] for the completed property list below
@interface SPPBubbleView : UIView
@property (nonatomic) NSInteger style;
@property (nonatomic) NSInteger builtStyle;
@property (nonatomic) int speed;
@property (nonatomic) int limit;
@property (nonatomic) BOOL showIcon;
@property (nonatomic, strong) UIImage *iconImage;
@property (nonatomic) NSInteger color;
@property (nonatomic, copy) void (^log)(NSString *message);
@property (nonatomic, readonly) CGSize contentSize;
@property (nonatomic, readonly) CGRect outlineRect;
@property (nonatomic, readonly) double outlineCorner;
// [phase-2 integration; backported to src in phase 3] remaining SPPBubbleView properties, declared in
// SPPBubbleView.m's own interface and in the binary property list
// (metadata/raw/OmniCarSpeedBubble/objc.json); declaration completion only.
@property (nonatomic, strong) UILabel *speedLabel;
@property (nonatomic, strong) SPPGlassView *glass;
@property (nonatomic, strong) SPPIconView *iconView;
@property (nonatomic, strong) SPPSignView *sign;
@property (nonatomic, strong) UILabel *unitLabel;
@property (nonatomic, strong) UIView *deco;
@property (nonatomic, strong) NSMutableDictionary *parts;
@property (nonatomic, strong) NSMutableDictionary *bits;
@property (nonatomic, strong) NSArray *tickLabels;
@property (nonatomic, strong) UIView *flashView;
- (void)rebuild;
- (CGSize)render;
- (NSInteger)speedState;
@end

// SPPWindowFactory.m
extern id SPPGetCarPlayCADisplay(void);
extern UIWindow *SPPMakeCarWindow(void *metrics);
extern void SPPMakeWindowPassThrough(UIWindow *window);

// Parallel per-app tables (see metadata): index 0..3 used, slots to 7.
extern NSString *const SPPAppNames[];      // Vietmap, GOFA, Waze, Wyn
extern NSString *const SPPAppBundleIds[];  // vn.vietmap.live, com.lumi.GOFA,
                                           // com.waze.iphone, com.wynauto.wyn
extern NSString *const SPPAppShortNames[]; // VM, GO, WZ (only 3 entries)

@interface SPPBubble : NSObject
// [phase-2 integration; backported to src in phase 3] @property census: all 31 properties from the binary
// property list (metadata/raw/OmniCarSpeedBubble/objc.json: name + type
// encoding per ivar, attributes T<enc>,&,N for objects / T<enc>,N for
// scalars). The src interface declared only the accessor pairs noted in
// the module report, so the 58 synthesized accessors + .cxx_destruct
// counted UNCLAIMED in metadata/COVERAGE_GAPS.md (59 entries) were
// never generated. speed and carBusy have custom getter+setter
// implementations below and are not re-synthesized.
@property (nonatomic, strong) UIWindow *window;
@property (nonatomic, strong) UIView *card;
@property (nonatomic, strong) SPPBubbleView *bubbleView;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic) double timerInterval;
@property (nonatomic) BOOL builtLite;
@property (nonatomic) int speed;
@property (nonatomic) int limit;
@property (nonatomic) double lastUpdate;
@property (nonatomic) double speedAt;
@property (nonatomic) double limitAt;
@property (nonatomic) double carLostAt;
@property (nonatomic) BOOL onPhone;
@property (nonatomic) BOOL carBusy;
@property (nonatomic) double scale;
@property (nonatomic) BOOL pinching;
@property (nonatomic) int app;
@property (nonatomic) int iconApp;
@property (nonatomic, strong) UIView *menu;
@property (nonatomic, strong) UIView *menuShield;
@property (nonatomic, strong) NSTimer *menuTimer;
@property (nonatomic) CGPoint holdStart;
@property (nonatomic) BOOL holdDragging;
@property (nonatomic) CGRect outlineRect;
@property (nonatomic) double outlineCorner;
@property (nonatomic, strong) NSTimer *demoTimer;
@property (nonatomic, strong) NSTimer *staleTimer;
@property (nonatomic) double appliedRotation;
@property (nonatomic) double displayScale;
@property (nonatomic) CGPoint phoneFraction;
@property (nonatomic) CGPoint carFraction;
+ (instancetype)shared;
@end

// Per-app foreground bookkeeping, file-static in the binary
// (bss 0x1a0 / 0x1a8 / 0x1e8 / 0x228, 8 slots each).
static BOOL   SPPAppFG[8];        // last reported foreground flag
static double SPPAppFGAt[8];      // last report time
static double SPPAppFGStart[8];   // when the current foreground stint began
static BOOL   SPPAppOpened[8];    // app seen foreground for >= 1.5 s once
static int    SPPForegroundApp;   // __data 0x43780: last foreground app

@implementation SPPBubble {
    BOOL _builtLite;
    BOOL _onPhone;
    BOOL _carBusy;
    BOOL _pinching;
    BOOL _holdDragging;
    int _speed;                   // km/h, -1 = invalid
    int _limit;                   // km/h, -1 = invalid
    int _app;                     // current source app index
    int _iconApp;                 // app the cached icon belongs to
    UIWindow *_window;
    UIView *_card;
    SPPBubbleView *_bubbleView;
    NSTimer *_timer;              // refresh timer (0.5 s / 1.0 s lite)
    double _timerInterval;
    double _lastUpdate;           // CFAbsoluteTime of last accepted reading
    double _speedAt;
    double _limitAt;
    double _carLostAt;            // when the car display was last seen gone
    double _scale;                // current bubble scale (1.0 == 100% -> 0.9)
    UIView *_menu;
    UIView *_menuShield;
    NSTimer *_menuTimer;
    double _outlineCorner;
    NSTimer *_demoTimer;
    NSTimer *_staleTimer;
    double _appliedRotation;
    double _displayScale;
    CGPoint _holdStart;
    CGPoint _phoneFraction;       // saved card center, normalized; -1 unset
    CGPoint _carFraction;
    CGRect _outlineRect;
}

// +shared @0x17ab4 — VERIFIED shape (singleton via the OMC once helper).
+ (instancetype)shared {
    static SPPBubble *instance;
    static dispatch_once_t once;
    dispatch_once(&once, ^{ instance = [self new]; });
    return instance;
}

#pragma mark - Reading intake

// -setSpeed: @0x17d64 — VERIFIED (CUSTOM setter). Stores the value, then
// publishes it on Darwin channel "com.anlai.omnicar/speed" (state =
// clamped speed), deduplicated against the last published value and
// suppressed while the demo runs. Clamp: negative -> 0xFFFF (65535),
// else min(v, 255).
- (void)setSpeed:(int)speed {
    _speed = speed;
    if (_demoTimer) return;
    int64_t clamped = (speed < 0) ? 0xFFFF : MIN(speed, 255);
    static int64_t lastPublished;   // __data 0x43790
    if (clamped == lastPublished) return;
    static int token;
    if (!token) {
        if (notify_register_check("com.anlai.omnicar/speed", &token)
                != NOTIFY_STATUS_OK) {
            token = 0;
        }
        if (!token) return;
    }
    lastPublished = clamped;
    notify_set_state(token, (uint64_t)clamped);
    notify_post("com.anlai.omnicar/speed");
}
- (int)speed { return _speed; }

// -updateSpeed:limit: @0x18254 and -updateSpeed:limit:appForeground:
// @0x1825c — VERIFIED forwards.
- (void)updateSpeed:(int)speed limit:(int)limit {
    [self updateSpeed:speed limit:limit appForeground:NO];
}
- (void)updateSpeed:(int)speed limit:(int)limit appForeground:(BOOL)fg {
    [self updateSpeed:speed limit:limit appForeground:fg app:_app];
}

// -updateSpeed:limit:appForeground:app: @0x18304 — VERIFIED.
// Foreground bookkeeping runs for every report; the reading itself is
// only accepted when the app has been "opened" (seen in the foreground
// continuously for >= 1.5 s at least once) or the demo is running.
// Source arbitration for a reading from a NON-current app:
//   - current source quiet for > 2 s           -> accept (switch)
//   - either speed invalid: accept only if the reporter is the globally
//     foreground app and the current source is not
//   - reporter in foreground, current source not in foreground, and the
//     current source updated < 5 s ago         -> yield: refresh only
// On a switch, speedAt/limitAt reset to 0 so the old app's values die
// immediately instead of coasting on the 3 s keep-alive below.
// Keep-alive: an invalid speed/limit keeps the previous value unless it
// is older than 3 s, in which case it becomes -1.
- (void)updateSpeed:(int)speed limit:(int)limit appForeground:(BOOL)fg
                app:(NSInteger)app {
    NSInteger idx = app & 7;
    double now = CFAbsoluteTimeGetCurrent();
    NSString *name = (idx <= 3) ? SPPAppNames[idx] : @"?";
    if (SPPAppFG[idx] != fg) {
        _OMCLogWrite(@"SpeedBubble",
            [NSString stringWithFormat:@"bubble: %@ %@", name,
                fg ? @"dang hien -> an bong bong"
                   : @"chay nen -> hien bong bong"]);
    }
    if (fg) {
        if (!SPPAppFG[idx]) SPPAppFGStart[idx] = now;
        SPPAppFG[idx] = YES;
        SPPAppFGAt[idx] = now;
        if (!SPPAppOpened[idx] && now - SPPAppFGStart[idx] >= 1.5) {
            SPPAppOpened[idx] = YES;
            _OMCLogWrite(@"SpeedBubble",
                [NSString stringWithFormat:@"bubble: %@ da duoc mo", name]);
        }
    } else {
        SPPAppFG[idx] = NO;
        SPPAppFGAt[idx] = now;
    }
    if (!SPPAppOpened[idx] && !_demoTimer) return;
    if (fg) SPPForegroundApp = (int)idx;

    double sinceLast = now - _lastUpdate;
    if (idx != _app) {
        BOOL accept;
        if (sinceLast > 2.0) {
            accept = YES;
        } else if (speed < 0 || _speed < 0) {
            accept = (idx == SPPForegroundApp && _app != SPPForegroundApp);
        } else if (fg && !SPPAppFG[_app & 7] && sinceLast < 5.0) {
            [self feedWarning];
            [self refresh];
            return;
        } else {
            accept = YES;
        }
        if (!accept) return;
        _OMCLogWrite(@"SpeedBubble",
            [NSString stringWithFormat:@"bubble: nguon toc do -> %@", name]);
        _speedAt = 0;
        _limitAt = 0;
    }
    _app = (int)idx;
    if (speed >= 0) {
        self.speed = speed;
        _speedAt = now;
    } else if (now - _speedAt > 3.0) {
        self.speed = -1;
    }
    if (limit >= 1) {
        _limit = limit;
        _limitAt = now;
    } else if (now - _limitAt > 3.0) {
        _limit = -1;
    }
    _lastUpdate = now;
    [self feedWarning];
    [self refresh];
}

// -anyAppForeground @0x182a4 — VERIFIED: any app whose foreground flag
// was reported within the last 5 s.
- (BOOL)anyAppForeground {
    double now = CFAbsoluteTimeGetCurrent();
    for (int i = 0; i < 8; i++) {
        if (SPPAppFG[i] && now - SPPAppFGAt[i] < 5.0) return YES;
    }
    return NO;
}

// -sourceStopped: @0x18100 — VERIFIED: the current source app quit ->
// drop the numbers (unless the demo is running or it is another app).
- (void)sourceStopped:(NSInteger)app {
    if (((_app ^ (int)app) & 7) != 0) return;
    if (_demoTimer) return;
    NSString *name = (app <= 3) ? SPPAppNames[app] : @"?";
    _OMCLogWrite(@"SpeedBubble",
        [NSString stringWithFormat:@"bubble: nguon %@ ngung -> bo so", name]);
    self.speed = -1;
    _limit = -1;
    _speedAt = 0;
    _limitAt = 0;
    _lastUpdate = 0;
    [self feedWarning];
    [self refresh];
}

// -sourceAppState @0x1874c — VERIFIED. Probes the current source app
// through SpringBoard's private API; every step is
// respondsToSelector-guarded with _OMCMissingSelector logging:
//   SBApplicationController +sharedInstance
//     -> -applicationWithBundleIdentifier: (bundleIds[app & 7],
//        default vn.vietmap.live) -> SBApplication
//   then -isRunning on the application; if the application does not
//   respond to isRunning, -processState is fetched and -isRunning is
//   probed on the process-state object instead.
// Returns:  1 = app running
//           0 = app NOT running, but its foreground flag (SPPAppFG) is
//               fresh — refresh treats this as "source died"
//          -1 = unknown (no SBApplication, or no usable probe)
- (NSInteger)sourceAppState {
    NSInteger idx = _app & 7;
    Class controllerClass = objc_getClass("SBApplicationController");
    SEL sharedSel = NSSelectorFromString(@"sharedInstance");
    id controller = nil;
    if ([controllerClass respondsToSelector:sharedSel]) {
        controller = ((id (*)(id, SEL))objc_msgSend)(controllerClass, sharedSel);
    } else {
        // Binary @0x187d0: x1 = the SBApplicationController class object
        // (x21, straight from objc_getClass), x2 = @"sharedInstance".
        _OMCMissingSelector(@"SpeedBubble", controllerClass,
                            @"sharedInstance");
    }
    id sbApp = nil;
    if (controller) {
        NSString *bundleId = (idx <= 3) ? SPPAppBundleIds[idx]
                                        : @"vn.vietmap.live";
        SEL appSel = NSSelectorFromString(@"applicationWithBundleIdentifier:");
        if ([controller respondsToSelector:appSel]) {
            sbApp = ((id (*)(id, SEL, id))objc_msgSend)(controller, appSel,
                                                       bundleId);
        } else {
            // Binary @0x18854: x1 = the controller (x19),
            // x2 = @"applicationWithBundleIdentifier:".
            _OMCMissingSelector(@"SpeedBubble", controller,
                                @"applicationWithBundleIdentifier:");
        }
    }
    if (!sbApp) return -1;
    SEL runningSel = NSSelectorFromString(@"isRunning");
    if ([sbApp respondsToSelector:runningSel]) {
        // Binary re-probes before sending (@0x188d4, after retaining
        // sbApp @0x188b4); if the second probe fails it logs @0x18978
        // (x1 = x20 = sbApp, x2 = @"isRunning") and takes the same
        // freshness tail as the not-running result (@0x18a1c).
        if (![sbApp respondsToSelector:runningSel]) {
            _OMCMissingSelector(@"SpeedBubble", sbApp, @"isRunning");
            return SPPAppFG[idx] ? 0 : -1;
        }
        BOOL running = ((BOOL (*)(id, SEL))objc_msgSend)(sbApp, runningSel);
        if (running) return 1;
        return SPPAppFG[idx] ? 0 : -1;
    }
    SEL stateSel = NSSelectorFromString(@"processState");
    if (![sbApp respondsToSelector:stateSel]) return -1;
    // Binary re-probes before sending (@0x18938, after retaining sbApp
    // @0x18918); if the second probe fails it logs @0x189a0 (x1 = x20 =
    // sbApp, x2 = @"processState") and continues with a nil process
    // state — the freshness tail of the nil check below (@0x18a1c).
    if (![sbApp respondsToSelector:stateSel]) {
        _OMCMissingSelector(@"SpeedBubble", sbApp, @"processState");
        return SPPAppFG[idx] ? 0 : -1;
    }
    id processState = ((id (*)(id, SEL))objc_msgSend)(sbApp, stateSel);
    if (!processState) return SPPAppFG[idx] ? 0 : -1;
    if ([processState respondsToSelector:runningSel]) {
        // Binary re-probes before sending (@0x189f0, after retaining
        // the process state @0x189d0); if the second probe fails it
        // logs @0x18a88 (x1 = x21 = processState, x2 = @"isRunning")
        // and takes the freshness tail (@0x18a1c).
        if (![processState respondsToSelector:runningSel]) {
            _OMCMissingSelector(@"SpeedBubble", processState, @"isRunning");
            return SPPAppFG[idx] ? 0 : -1;
        }
        BOOL running = ((BOOL (*)(id, SEL))objc_msgSend)(processState,
                                                         runningSel);
        if (running) return 1;
        return SPPAppFG[idx] ? 0 : -1;
    }
    return SPPAppFG[idx] ? 0 : -1;   // INFERRED tail (0x18a34/0x18a74)
}

// -feedWarning @0x17e1c — VERIFIED. Freshness window 5 s on both values.
// While the speed is fresh, a 1 s repeating stale timer re-feeds the
// warner so it can expire on time; when the speed goes stale the timer
// is torn down and the speed is cleared (which also publishes 0xFFFF).
- (void)feedWarning {
    double now = CFAbsoluteTimeGetCurrent();
    BOOL speedFresh = (_speed >= 0) && (now - _speedAt <= 5.0);
    NSInteger limit = -1;
    if (_limit >= 1 && now - _limitAt <= 5.0) limit = _limit;
    [[SPPOverspeed shared] updateSpeed:(speedFresh ? _speed : -1)
                                 limit:limit];
    if (speedFresh) {
        if (!_staleTimer) {
            __weak SPPBubble *weakSelf = self;
            _staleTimer = [NSTimer
                scheduledTimerWithTimeInterval:1.0 repeats:YES
                block:^(NSTimer *t) { [weakSelf feedWarning]; }];
        }
    } else {
        if (_speed >= 0 && !_demoTimer) self.speed = -1;
        [_staleTimer invalidate];
        _staleTimer = nil;
    }
}

#pragma mark - Visibility lifecycle

// -setCarBusy: @0x19580 — VERIFIED (custom setter; logs + refresh).
- (void)setCarBusy:(BOOL)busy {
    if (_carBusy == busy) return;
    _carBusy = busy;
    _OMCLogWrite(@"SpeedBubble",
        [NSString stringWithFormat:@"bubble: man xe %@ (Split Screen)",
            busy ? @"ban -> an tren xe" : @"ranh"]);
    [self refresh];
}
- (BOOL)carBusy { return _carBusy; }

// -refresh @0x18b24 — VERIFIED (see the report for the full decision
// table). Cadence: driven by events plus a repeating timer of 0.5 s
// (1.0 s in lite mode) that exists only while the bubble is shown.
- (void)refresh {
    double now = CFAbsoluteTimeGetCurrent();
    if (now - _speedAt > 5.0) self.speed = -1;   // stale expiry, 5 s
    if (now - _limitAt > 5.0) _limit = -1;
    NSInteger state;
    BOOL alive;
    if (_lastUpdate > 0) {
        if (_demoTimer) {
            state = 1;
            alive = YES;
        } else {
            state = [self sourceAppState];
            alive = (state == 1) || (now - _lastUpdate < 90.0);
        }
    } else {
        state = 1;
        alive = NO;
    }
    BOOL carBlocks = _carBusy && (SPPGetCarPlayCADisplay() != nil);
    if (!alive) {
        [self hideIfShownWithReason:@"(no source)" now:now state:state];
        return;
    }
    if (carBlocks) {
        [self hideIfShownWithReason:@"(car busy)" now:now state:state];
        return;
    }
    if (![SPPPrefs enabled]) {
        [self hideIfShownWithReason:@"(disabled)" now:now state:state];
        return;
    }
    if ([self anyAppForeground]) {
        [self hideIfShownWithReason:@"(app foreground)" now:now state:state];
        return;
    }
    if (state == 0) {
        NSString *name = (_app <= 3) ? SPPAppNames[_app] : @"?";
        _OMCLogWrite(@"SpeedBubble",
            [NSString stringWithFormat:@"bubble: %@ da tat -> an bong bong ngay",
                                       name]);
        self.speed = -1;
        _limit = -1;
        _lastUpdate = 0;
        SPPAppOpened[_app & 7] = NO;
        SPPAppFG[_app & 7] = NO;
        [self hideIfShownWithReason:@"(app off)" now:now state:state];
        return;
    }
    // Show path.
    [self ensureWindow];
    if (!_window) return;
    if (_onPhone) [self applyPhoneOrientationForce:NO];
    [self applySavedScale];
    [self renderBubble];
    [self applyCrispScale];
    if (_builtLite) SPPStripLayerShadows(_card.layer);   // sub_19270
    if (_window.isHidden) {
        _window.hidden = NO;
        _card.alpha = 0;
        _card.transform = [self baseScaled:0.7];
        [UIView animateWithDuration:0.45 delay:0
            usingSpringWithDamping:0.5 initialSpringVelocity:0 options:0
            animations:^{
                _card.alpha = 1;
                _card.transform = [self baseScaled:1.0];
            } completion:nil];
    } else if (_card.alpha < 1.0) {
        [UIView animateWithDuration:0.2 delay:0
            options:UIViewAnimationOptionBeginFromCurrentState
            animations:^{ _card.alpha = 1; } completion:nil];
    }
    // Refresh timer: interval follows the lite flag; recreated when the
    // wanted interval changes.
    double interval = _builtLite ? 1.0 : 0.5;
    if (_timer && _timerInterval != interval) {
        [_timer invalidate];
        _timer = nil;
    }
    if (!_timer) {
        _timerInterval = interval;
        __weak SPPBubble *weakSelf = self;
        _timer = [NSTimer scheduledTimerWithTimeInterval:interval
            repeats:YES block:^(NSTimer *t) { [weakSelf refresh]; }];
    }
}

// Internal helper standing in for refresh's shared hide tail @0x18f20:
// logs "bubble: an (ban tin %.1fs truoc, app chay=%d, tat=%d, app dan
// duong dang hien=%d, man xe ban=%d)" (only when the window is visible)
// and calls -hide. VERIFIED behaviour; factored here for readability.
- (void)hideIfShownWithReason:(NSString *)unused now:(double)now
                        state:(NSInteger)state {
    if (_window && !_window.isHidden) {
        _OMCLogWrite(@"SpeedBubble",
            [NSString stringWithFormat:
                @"bubble: an (ban tin %.1fs truoc, app chay=%d, tat=%d, "
                 "app dan duong dang hien=%d, man xe ban=%d)",
                now - _lastUpdate, (int)state,
                [SPPPrefs enabled] ? 0 : 1,
                [self anyAppForeground] ? 1 : 0,
                (_carBusy && SPPGetCarPlayCADisplay() != nil) ? 1 : 0]);
    }
    [self hide];
}

// -hide @0x19630 — VERIFIED: 0.18 s shrink/fade (alpha -> 0, transform
// -> baseScaled:0.8), completion hides the window when alpha < 0.01;
// the refresh timer is invalidated.
- (void)hide {
    if (_window && !_window.isHidden) {
        [self hideMenu];
        [UIView animateWithDuration:0.18 animations:^{
            _card.alpha = 0;
            _card.transform = [self baseScaled:0.8];
        } completion:^(BOOL finished) {
            if (_card.alpha < 0.01) _window.hidden = YES;
        }];
    }
    [_timer invalidate];
    _timer = nil;
}

// -speedState @0x198cc — VERIFIED: forwards to the view.
- (NSInteger)speedState {
    return [_bubbleView speedState];
}

#pragma mark - Rendering

// sub_19270 — VERIFIED behaviour: in lite mode, strip the card layer's
// shadow and every sublayer's shadow.
static void SPPStripLayerShadows(CALayer *layer) {
    layer.shadowOpacity = 0;
    for (CALayer *sub in layer.sublayers) SPPStripLayerShadows(sub);
}

// -renderBubble @0x1991c — VERIFIED. Pushes prefs + values into the
// view, resolves the app icon (private UIApplication icon API, cached
// per app in a static NSMutableDictionary; slot 0x43068 truth =
// NSMutableDictionary), falling back to a drawn letter tile (62x62,
// sub_1ea60 renders the app short name on a per-app colour), then lays
// the card out around the view's content size.
- (void)renderBubble {
    BOOL lite = _OMCLiteActive();
    if (lite != _builtLite) {
        _builtLite = lite;
        [_bubbleView rebuild];
    }
    SPPBubbleView *bv = _bubbleView;
    bv.style = [SPPPrefs style];
    bv.speed = _speed;
    bv.limit = _limit;
    BOOL showIcon = [SPPPrefs showAppIcon];
    bv.showIcon = showIcon;
    bv.color = [SPPPrefs color];
    if (showIcon) {
        static NSMutableDictionary *iconCache;
        if (!iconCache) iconCache = [NSMutableDictionary new];
        NSNumber *key = @(_app);
        UIImage *icon = iconCache[key];
        if (!icon) {
            NSString *bundleId = (_app <= 3) ? SPPAppBundleIds[_app]
                                             : @"vn.vietmap.live";
            UIApplication *app = [UIApplication sharedApplication];
            SEL iconSel = NSSelectorFromString(
                @"_applicationIconImageForBundleIdentifier:format:scale:");
            if ([app respondsToSelector:iconSel]) {
                icon = ((id (*)(id, SEL, id, NSInteger, double))objc_msgSend)(
                    app, iconSel, bundleId, 0 /* format INFERRED */,
                    [UIScreen mainScreen].scale);
            }
            if (!icon) {
                _OMCLogWrite(@"SpeedBubble",
                    [NSString stringWithFormat:
                        @"bubble: khong lay duoc icon %@ -> dung chu viet tat",
                        bundleId]);
                NSString *shortName = (_app <= 2) ? SPPAppShortNames[_app]
                                                  : @"?";
                UIGraphicsImageRenderer *renderer =
                    [[UIGraphicsImageRenderer alloc]
                        initWithSize:CGSizeMake(62, 62)];
                NSInteger appIndex = _app;
                icon = [renderer imageWithActions:
                    ^(UIGraphicsImageRendererContext *ctx) {
                        SPPDrawIconTile(ctx, appIndex, shortName);  // sub_1ea60
                    }];
            }
            if (icon) iconCache[key] = icon;
        }
        bv.iconImage = icon;
        _iconApp = _app;
    }
    CGPoint center = _card.center;
    CGSize bubbleSize = [bv render];   // original uses the returned size
                                       // directly for the card bounds
                                       // (dump 0x19cb0-0x19ce0)
    _card.bounds = CGRectMake(0, 0, bubbleSize.width,
                              bubbleSize.height);
    _card.center = center;
    bv.frame = _card.bounds;
    _outlineRect = bv.outlineRect;
    _outlineCorner = bv.outlineCorner;
    [self clampCard];
}

// Fallback tile drawing (block body sub_1ea60 @0x1ea60) — VERIFIED
// outline: fill the rect with a per-app colour (three colour branches
// by index cmp 1/2: (0.6, 0.45, 1.0)-family purple, (0.2, 0.75, 0.95)
// teal, (0.1, 0.4, 0.85) blue; the red components and the exact
// index->colour assignment are INFERRED), then draw the short name
// centred in white system font 26.
static void SPPDrawIconTile(UIGraphicsImageRendererContext *ctx,
                            NSInteger appIndex, NSString *shortName) {
    UIColor *fill;
    if (appIndex == 2) {
        fill = [UIColor colorWithRed:0.1 green:0.4 blue:0.85 alpha:1];
    } else if (appIndex == 1) {
        fill = [UIColor colorWithRed:0.2 green:0.75 blue:0.95 alpha:1];
    } else {
        fill = [UIColor colorWithRed:0.6 green:0.45 blue:1.0 alpha:1];
    }
    [fill setFill];
    UIRectFill(CGRectMake(0, 0, 62, 62));
    NSDictionary *attrs = @{
        NSFontAttributeName: [UIFont systemFontOfSize:26
            weight:UIFontWeightBold],   // weight INFERRED
        NSForegroundColorAttributeName: [UIColor whiteColor],
    };
    CGSize textSize = [shortName sizeWithAttributes:attrs];
    [shortName drawAtPoint:CGPointMake((62 - textSize.width) / 2,
                                       (62 - textSize.height) / 2)
            withAttributes:attrs];
}

#pragma mark - Scale / transforms

// -baseTransform @0x1a254, -baseScaled: @0x1a2bc — VERIFIED.
- (CGAffineTransform)baseTransform {
    return CGAffineTransformMakeScale(_scale, _scale);
}
- (CGAffineTransform)baseScaled:(double)factor {
    return CGAffineTransformMakeScale(_scale * factor, _scale * factor);
}

// -savedScale @0x1a1ec — VERIFIED: user percent (car/phone specific)
// / 100 * 0.9. At 100% the bubble renders at 0.9.
- (double)savedScale {
    return [SPPPrefs sizePercentForCar:!_onPhone] / 100.0 * 0.9;
}

// -applySavedScale @0x19f24 — VERIFIED: while not pinching, snap to the
// saved scale when it differs by more than 0.001.
- (void)applySavedScale {
    if (!_pinching) {
        double saved = [self savedScale];
        if (fabs(saved - _scale) > 0.001) {
            _scale = saved;
            _card.transform = [self baseTransform];
        }
    }
    [self clampCard];
    [self applyCrispScale];
}

// -setWarnShake: @0x19e2c — VERIFIED. fx==3 in SPPOverspeed shakes the
// bubble itself: an infinite 0.7 s keyframe wobble on the view's layer
// (scale 1.12 with +/-3 deg (0.05235987755982988 rad) rotations, 5
// keyframes, easeInEaseOut), plus a red shadow (1, 0.23, 0.19) unless
// lite mode is active. Removal clears the animation and the shadow.
- (void)setWarnShake:(BOOL)shake {
    CALayer *layer = _bubbleView.layer;
    if (!layer) return;
    BOOL has = ([layer animationForKey:@"sppShake"] != nil);
    if (shake == has) return;
    if (!shake) {
        [layer removeAnimationForKey:@"sppShake"];
        layer.shadowOpacity = 0;
        return;
    }
    CAKeyframeAnimation *anim =
        [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    CATransform3D s = CATransform3DMakeScale(1.12, 1.12, 1);
    anim.values = @[
        [NSValue valueWithCATransform3D:s],
        [NSValue valueWithCATransform3D:
            CATransform3DRotate(s, -0.05235987755982988, 0, 0, 1)],
        [NSValue valueWithCATransform3D:s],
        [NSValue valueWithCATransform3D:
            CATransform3DRotate(s, 0.05235987755982988, 0, 0, 1)],
        [NSValue valueWithCATransform3D:s],   // 5th value INFERRED
    ];
    anim.duration = 0.7;
    anim.repeatCount = HUGE_VALF;
    anim.timingFunction =
        [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    [layer addAnimation:anim forKey:@"sppShake"];
    if (!_OMCLiteActive()) {
        layer.shadowColor =
            [UIColor colorWithRed:1 green:0.23 blue:0.19 alpha:1].CGColor;
        layer.shadowOpacity = 1;   // exact radius/opacity constants
        layer.shadowRadius = 9;    // INFERRED from packed const @0x32dc8
    }
}

#pragma mark - Demo / layout reset

// -runDemo @0x1a448 — [VERIFIED line-level, final closure
// 2026-11-08] The 10-second preview (log "bubble: xem thu 10 giay"):
// invalidates the running demo timer (through the demoTimer getter),
// then schedules a 0.5 s repeating timer and stores it through
// setDemoTimer:. The tick block (sub_1a5e8, 0x1a5e8-0x1a710 —
// sub_1a710, the address sometimes cited for the "curve helper", is
// only the block's release epilogue) pre-increments a __block tick:
//   ticks 1..20: [owner updateSpeed:(40 + 2 * tick) limit:60] —
//     synthetic speeds 42, 44, ..., 80 against limit 60, crossing
//     the limit from tick 11;
//   tick 21: invalidate the timer (the block's own argument), then
//     on the owner, in order: demoTimer = nil, speed = -1,
//     limit = -1, speedAt = 0, limitAt = 0, lastUpdate = 0, refresh —
//     a full state wipe, so the demo leaves no reading behind. The
//     order matters: clearing the demo timer first re-arms
//     setSpeed:'s Darwin publish, so the -1 goes out as the 0xFFFF
//     "no reading" state.
// The demo feeds the owner's OWN -updateSpeed:limit: — the earlier
// draft's curve (30 + (tick * 7) % 90, poked _limit = 50, routed
// through SPPOverspeed) was INFERRED and wrong on every point.
- (void)runDemo {
    [self.demoTimer invalidate];
    _OMCLogWrite(@"SpeedBubble", @"bubble: xem thu 10 giay");
    __weak SPPBubble *weakSelf = self;
    __block int tick = 0;
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:0.5
        repeats:YES block:^(NSTimer *t) {
            tick++;
            if (tick >= 21) {
                [t invalidate];
                SPPBubble *owner = weakSelf;
                owner.demoTimer = nil;
                owner.speed = -1;
                owner.limit = -1;
                owner.speedAt = 0;
                owner.limitAt = 0;
                owner.lastUpdate = 0;
                [owner refresh];
                return;
            }
            SPPBubble *owner = weakSelf;
            [owner updateSpeed:(40 + 2 * tick) limit:60];
        }];
    self.demoTimer = timer;
}

// -resetLayout @0x1a304 — VERIFIED: size back to 100% on both
// surfaces, saved positions cleared, card re-placed.
- (void)resetLayout {
    [SPPPrefs setSizePercent:100 forCar:YES];
    [SPPPrefs setSizePercent:100 forCar:NO];
    _scale = [self savedScale];
    _phoneFraction = CGPointMake(-1, -1);
    _carFraction = CGPointMake(-1, -1);
    if (_window) {
        _card.transform = [self baseTransform];
        [self restoreCardPosition];
        [self applyCrispScale];
    }
    _OMCLogWrite(@"SpeedBubble", @"bubble: dat lai vi tri + kich thuoc");
}

#pragma mark - Gestures (wired in -ensureWindow)

// -tapped: @0x1ccfc — VERIFIED behaviour; exact branch wiring of the
// two open mechanisms INFERRED. Tap with the menu open just closes it.
// Otherwise: 0.1 s bounce of the card, then reopen the source app —
// on the phone via SpringBoard's private
// -[UIApplication launchApplicationWithIdentifier:suspended:]
// (respondsToSelector-guarded); on the car by posting
// "com.anlai.omnicar/speedbubble.opencar" with state = app index,
// which CarPlayApp's handler (sub_45b4) turns into a dashboard open.
- (void)tapped:(UITapGestureRecognizer *)recognizer {
    if (_menu) {
        [self hideMenu];
        return;
    }
    [UIView animateWithDuration:0.1 animations:^{
        _card.transform = [self baseScaled:0.92];   // INFERRED depth
    } completion:^(BOOL finished) {
        _card.transform = [self baseTransform];
    }];
    NSString *name = (_app <= 3) ? SPPAppNames[_app] : @"?";
    NSString *bundleId = (_app <= 3) ? SPPAppBundleIds[_app]
                                     : @"vn.vietmap.live";
    if (_onPhone) {
        _OMCLogWrite(@"SpeedBubble",
            [NSString stringWithFormat:@"bubble: cham -> mo %@ tren iPhone",
                                       name]);
        UIApplication *app = [UIApplication sharedApplication];
        SEL launchSel = NSSelectorFromString(
            @"launchApplicationWithIdentifier:suspended:");
        if ([app respondsToSelector:launchSel]) {
            ((void (*)(id, SEL, id, BOOL))objc_msgSend)(app, launchSel,
                                                        bundleId, NO);
        }
    } else {
        _OMCLogWrite(@"SpeedBubble",
            [NSString stringWithFormat:@"bubble: cham -> mo %@ tren CarPlay",
                                       name]);
        static int token;
        if (!token &&
            notify_register_check("com.anlai.omnicar/speedbubble.opencar",
                                  &token) != NOTIFY_STATUS_OK) {
            token = 0;
        }
        if (token) {
            notify_set_state(token, (uint64_t)_app);
            notify_post("com.anlai.omnicar/speedbubble.opencar");
        }
    }
}

// -panned: @0x1cb44 — VERIFIED outline: drags the card by the
// recognizer's translation in the window; saves the position at the
// end. (The card also has a dedicated drag handle path via
// long-press; see -longPressed:.)
- (void)panned:(UIPanGestureRecognizer *)recognizer {
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        [self hideMenu];
    }
    CGPoint translation = [recognizer translationInView:_window];
    static CGPoint startCenter;   // INFERRED storage (no spare ivar)
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        startCenter = _card.center;
    }
    _card.center = CGPointMake(startCenter.x + translation.x,
                               startCenter.y + translation.y);
    if (recognizer.state == UIGestureRecognizerStateEnded ||
        recognizer.state == UIGestureRecognizerStateCancelled) {
        [self saveCardPosition];
    }
}

// -pinched: @0x1c910 — VERIFIED. Two-finger pinch resizes the bubble:
// scale = clamp(base * recognizer.scale, 0.54, 1.98) (== percent
// 60..220 through the 0.9 factor); on end the percent is persisted via
// SPPPrefs (which rounds it) and the scale snaps to the saved value.
- (void)pinched:(UIPinchGestureRecognizer *)recognizer {
    static double baseScale;   // INFERRED storage (no spare ivar)
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        baseScale = _scale;
        _pinching = YES;
        [self hideMenu];
    }
    if (recognizer.state == UIGestureRecognizerStateBegan ||
        recognizer.state == UIGestureRecognizerStateChanged) {
        double s = baseScale * recognizer.scale;
        _scale = fmin(fmax(s, 0.54), 1.98);
        _card.transform = [self baseTransform];
        [self clampCard];
    }
    if (recognizer.state == UIGestureRecognizerStateEnded ||
        recognizer.state == UIGestureRecognizerStateCancelled) {
        _pinching = NO;
        [self saveCardPosition];
        [SPPPrefs setSizePercent:(_scale / 0.9 * 100.0) forCar:!_onPhone];
        _scale = [self savedScale];
        _card.transform = [self baseTransform];
        [self applyCrispScale];
    }
}

// -longPressed: @0x1a7dc — VERIFIED. Press-and-hold: moving more than
// 12 pt from the touch-down point turns it into a drag (menu hidden);
// releasing without dragging opens the menu.
- (void)longPressed:(UILongPressGestureRecognizer *)recognizer {
    CGPoint loc = [recognizer locationInView:_window];
    static CGPoint centerAtStart;   // INFERRED storage
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        _holdStart = loc;
        centerAtStart = _card.center;
    } else if (recognizer.state == UIGestureRecognizerStateChanged) {
        if (!_holdDragging &&
            hypot(loc.x - _holdStart.x, loc.y - _holdStart.y) > 12.0) {
            _holdDragging = YES;
            [self hideMenu];
        }
        if (_holdDragging) {
            _card.center = CGPointMake(
                centerAtStart.x + (loc.x - _holdStart.x),
                centerAtStart.y + (loc.y - _holdStart.y));
            [self clampCard];
        }
    } else if (recognizer.state == UIGestureRecognizerStateEnded ||
               recognizer.state == UIGestureRecognizerStateCancelled) {
        if (_holdDragging) {
            [self saveCardPosition];
            _holdDragging = NO;
        } else {
            [self showMenu];
        }
    }
}

#pragma mark - Long-press menu

// -menuButton: @0x1b758 — VERIFIED outline. 48x48 round button,
// cornerRadius 18, white 0.55 background, 1 pt white 0.95 border,
// soft indigo shadow (radius 3, offset (0,2)); SF Symbol from
// @[minus, plus, exclamationmark.triangle, speaker.wave.2, xmark]
// indexed by kind, point size 17. Tag = kind, except the close
// (kind 5) which carries tag 104. Kind 4's tint depends on the
// warning state (INFERRED mapping).
- (UIButton *)menuButton:(NSInteger)kind {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.bounds = CGRectMake(0, 0, 48, 48);
    button.tag = (kind == 5) ? 104 : kind;
    button.layer.cornerRadius = 18;
    button.backgroundColor = [UIColor colorWithWhite:1 alpha:0.55];
    button.layer.borderWidth = 1;
    button.layer.borderColor = [UIColor colorWithWhite:1 alpha:0.95].CGColor;
    button.layer.shadowColor =
        [UIColor colorWithRed:0.27450980392156865 green:0.23529411764705882
                         blue:0.5490196078431373 alpha:1].CGColor;
    button.layer.shadowRadius = 3;
    button.layer.shadowOffset = CGSizeMake(0, 2);
    button.layer.shadowOpacity = 1;
    static NSArray *symbols;
    if (!symbols) symbols = @[ @"minus", @"plus",
        @"exclamationmark.triangle", @"speaker.wave.2", @"xmark" ];
    if (kind < 5) {
        UIImageSymbolConfiguration *cfg =
            [UIImageSymbolConfiguration configurationWithPointSize:17
                weight:UIImageSymbolWeightMedium];   // weight INFERRED
        UIImage *image = [[UIImage systemImageNamed:symbols[kind]
            withConfiguration:cfg]
            imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        [button setImage:image forState:UIControlStateNormal];
    }
    [button addTarget:self action:@selector(menuTapped:)
        forControlEvents:UIControlEventTouchUpInside];
    return button;
}

// -setMenuButton:off: @0x1b41c — VERIFIED: an "off" toggle button gets
// a diagonal slash: a CAShapeLayer sublayer named "slash" (slot
// 0x43030 truth = CAShapeLayer) and a dimmed tint (indigo at 0.45
// alpha); "on" removes the slash layers and restores full tint.
- (void)setMenuButton:(UIButton *)button off:(BOOL)off {
    if (off) {
        for (CALayer *sub in [button.layer.sublayers copy]) {
            if ([sub.name isEqualToString:@"slash"]) [sub removeFromSuperlayer];
        }
        CAShapeLayer *slash = [CAShapeLayer layer];
        slash.name = @"slash";
        [button.layer addSublayer:slash];
        button.tintColor = [[UIColor colorWithRed:0.2901960784313726
            green:0.30980392156862746 blue:0.5019607843137255 alpha:1]
            colorWithAlphaComponent:0.45];
    } else {
        for (CALayer *sub in [button.layer.sublayers copy]) {
            if ([sub.name isEqualToString:@"slash"]) [sub removeFromSuperlayer];
        }
        button.tintColor = [UIColor colorWithRed:0.2901960784313726
            green:0.30980392156862746 blue:0.5019607843137255 alpha:1];
    }
}

// -showMenu @0x1ac84 — VERIFIED outline (panel composition partly
// INFERRED): a near-transparent shield (white 0.02) under the card
// catches outside taps; the panel is a row of menu buttons sized from
// the 48/69/46 pt constants with 5/4/9 pt spacings, the OmniCar logo
// (_OMCLogoMeshImage) as a round first item, toggle states read from
// SPPPrefs.warnMode; opens with a spring from scale 0.85.
- (void)showMenu {
    [self hideMenu];
    UIView *shield = [[UIView alloc] initWithFrame:_window.bounds];
    shield.backgroundColor = [UIColor colorWithWhite:1 alpha:0.02];
    shield.autoresizingMask = 0x12;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
        initWithTarget:self action:@selector(hideMenu)];
    [shield addGestureRecognizer:tap];
    [_window insertSubview:shield belowSubview:_card];
    _menuShield = shield;

    UIView *panel = [[UIView alloc] init];
    panel.layer.shadowColor = [UIColor colorWithRed:0.35294117647058826
        green:0.27450980392156865 blue:0.6666666666666666 alpha:1].CGColor;
    panel.layer.shadowRadius = 12;
    panel.layer.shadowOffset = CGSizeMake(0, 6);
    panel.layer.shadowOpacity = 1;
    UIImageView *logo = [[UIImageView alloc] initWithImage:_OMCLogoMeshImage(0)];  // [phase-2 integration; backported to src in phase 3] style 0 per binary @0x1b590 `mov w0,#0`
    logo.layer.cornerRadius = logo.bounds.size.height / 2;
    logo.layer.borderWidth = 1;
    logo.layer.borderColor = [UIColor colorWithWhite:1 alpha:0.92].CGColor;
    logo.layer.masksToBounds = YES;
    [panel addSubview:logo];
    NSInteger mode = [SPPPrefs warnMode];
    for (NSInteger kind = 0; kind < 6; kind++) {
        UIButton *b = [self menuButton:kind];
        if (kind == 2) [self setMenuButton:b off:((mode & 1) == 0)];
        if (kind == 3) [self setMenuButton:b off:((mode & 2) == 0)];
        [panel addSubview:b];
    }
    [_window addSubview:panel];
    _menu = panel;
    [self placeMenuAnimated:NO];
    [self armMenuTimer];
    panel.alpha = 0;
    panel.transform = CGAffineTransformMakeScale(0.85, 0.85);
    [UIView animateWithDuration:0.3 delay:0 usingSpringWithDamping:0.85
        initialSpringVelocity:0 options:0 animations:^{
            panel.alpha = 1;
            panel.transform = CGAffineTransformIdentity;
        } completion:nil];
}

// -menuTapped: @0x1c0a8 — VERIFIED behaviour:
//   tag 0 / 1   : size -10% / +10% (percent clamped at 220; log
//                 "bubble: menu -> co %.0f %% (%@)")
//   tag 2 / 3   : toggle warnMode bit 0 ("canh bao") / bit 1
//                 ("am thanh") via SPPPrefs setWarnMode:(mode ^ mask),
//                 slash updated, log "bubble: menu -> %@ %@"
//   tag 104     : quitSourceApp
// Every tap re-arms the 4 s auto-hide timer and plays a 0.1 s press
// animation. (Tag-to-action assignment follows the VERIFIED branch
// structure; which of tags 0/1 is minus vs plus is INFERRED from the
// symbol table order.)
- (void)menuTapped:(UIButton *)sender {
    [self armMenuTimer];
    [UIView animateWithDuration:0.1 animations:^{
        sender.transform = CGAffineTransformMakeScale(0.92, 0.92);
    } completion:^(BOOL f) { sender.transform = CGAffineTransformIdentity; }];
    NSInteger tag = sender.tag;
    if (tag == 104) {
        [self quitSourceApp];
        return;
    }
    if (tag == 2 || tag == 3) {
        NSInteger mask = (tag == 2) ? 1 : 2;
        NSInteger newMode = [SPPPrefs warnMode] ^ mask;
        [SPPPrefs setWarnMode:newMode];
        BOOL on = (newMode & mask) != 0;
        [self setMenuButton:sender off:!on];
        _OMCLogWrite(@"SpeedBubble",
            [NSString stringWithFormat:@"bubble: menu -> %@ %@",
                (mask == 1) ? @"canh bao" : @"am thanh",
                on ? @"bat" : @"tat"]);
        return;
    }
    double delta = (tag == 1) ? -10.0 : 10.0;   // INFERRED sign mapping
    double percent = _scale / 0.9 * 100.0 + delta;
    if (percent > 220.0) percent = 220.0;
    [SPPPrefs setSizePercent:percent forCar:!_onPhone];
    _scale = [self savedScale];
    [UIView animateWithDuration:0.3 delay:0 usingSpringWithDamping:0.8
        initialSpringVelocity:0 options:0 animations:^{
            _card.transform = [self baseTransform];
        } completion:nil];
    [self placeMenuAnimated:YES];
    _OMCLogWrite(@"SpeedBubble",
        [NSString stringWithFormat:@"bubble: menu -> co %.0f %% (%@)",
            percent, _onPhone ? @"iPhone" : @"xe"]);
}

// -armMenuTimer @0x1bf74 — VERIFIED: menu auto-hides after 4.0 s.
- (void)armMenuTimer {
    [_menuTimer invalidate];
    __weak SPPBubble *weakSelf = self;
    _menuTimer = [NSTimer scheduledTimerWithTimeInterval:4.0 repeats:NO
        block:^(NSTimer *t) { [weakSelf hideMenu]; }];
}

// -placeMenuAnimated: @0x1bb90 — VERIFIED outline: positions the panel
// next to the card (anchorPoint adjusted, 6/10/4 pt offsets), spring
// 0.3 s damping 0.85 when animated. Exact anchor choice INFERRED.
- (void)placeMenuAnimated:(BOOL)animated {
    if (!_menu) return;
    CGRect cardFrame = _card.frame;
    CGRect bounds = _window.bounds;
    CGPoint target = CGPointMake(
        fmin(fmax(CGRectGetMidX(cardFrame), 0), bounds.size.width),
        CGRectGetMinY(cardFrame) - 10);
    void (^place)(void) = ^{ _menu.center = target; };
    if (animated) {
        [UIView animateWithDuration:0.3 delay:0
            usingSpringWithDamping:0.85 initialSpringVelocity:0
            options:0 animations:place completion:nil];
    } else {
        place();
    }
}

// -hideMenu @0x1b328 — VERIFIED: timer off, shield removed, panel
// animates out over 0.18 s and is removed on completion.
- (void)hideMenu {
    [_menuTimer invalidate];
    _menuTimer = nil;
    [_menuShield removeFromSuperview];
    _menuShield = nil;
    UIView *menu = _menu;
    _menu = nil;
    if (menu) {
        [UIView animateWithDuration:0.18 animations:^{
            menu.alpha = 0;
        } completion:^(BOOL f) { [menu removeFromSuperview]; }];
    }
}

// -quitSourceApp @0x1c600 — VERIFIED: haptic
// UINotificationFeedbackGenerator + the private FBSSystemService
// terminateApplication:forReason:andReport:withDescription: with
// description @"OmniCar: user closed". (Feedback type and the
// reason/report arguments are not pinned in the dumps: INFERRED.)
- (void)quitSourceApp {
    [self hideMenu];
    NSString *bundleId = (_app <= 3) ? SPPAppBundleIds[_app]
                                     : @"vn.vietmap.live";
    _OMCLogWrite(@"SpeedBubble",
        [NSString stringWithFormat:@"bubble: menu -> thoat han %@",
                                   bundleId]);
    UINotificationFeedbackGenerator *haptic =
        [[UINotificationFeedbackGenerator alloc] init];
    [haptic notificationOccurred:UINotificationFeedbackTypeSuccess];
    Class serviceClass = objc_getClass("FBSSystemService");
    SEL sharedSel = NSSelectorFromString(@"sharedService");
    id service = nil;
    if ([serviceClass respondsToSelector:sharedSel]) {
        service = ((id (*)(id, SEL))objc_msgSend)(serviceClass, sharedSel);
    }
    SEL termSel = NSSelectorFromString(
        @"terminateApplication:forReason:andReport:withDescription:");
    if ([service respondsToSelector:termSel]) {
        ((void (*)(id, SEL, id, NSInteger, BOOL, id))objc_msgSend)(
            service, termSel, bundleId, 0, NO, @"OmniCar: user closed");
    }
    _OMCLogWrite(@"SpeedBubble",
        [NSString stringWithFormat:@"terminate %@ (FBSSystemService)",
                                   bundleId]);
}

#pragma mark - Window / geometry

// -ensureWindow @0x1d170 — VERIFIED outline. Chooses car mode when a
// CarPlay CADisplay exists, phone mode otherwise — but a car display
// that disappears must stay gone for 3.0 s before the bubble falls
// back to the phone (carLostAt debounce). Rebuilds the window on a
// mode switch; installs the bubble view's log block, the card, the
// pass-through transform (car windows) and the four gesture
// recognizers (tail wiring partly INFERRED). Phone windows are plain
// UIWindows on the main screen's scene; car windows come from
// SPPMakeCarWindow + SPPMakeWindowPassThrough.
- (void)ensureWindow {
    id display = SPPGetCarPlayCADisplay();
    double now = CFAbsoluteTimeGetCurrent();
    BOOL wantPhone;
    if (display) {
        wantPhone = NO;
        _carLostAt = 0;
    } else if (_carLostAt == 0 && !_onPhone && _window) {
        _carLostAt = now;   // first missed sighting: start debounce
        wantPhone = NO;
    } else if (!_onPhone && _window && now - _carLostAt < 3.0) {
        wantPhone = NO;
    } else {
        wantPhone = YES;
    }
    if (_window && _onPhone == wantPhone) return;
    [self hideMenu];
    _window.hidden = YES;
    [_window removeFromSuperview];
    _window = nil;

    if (wantPhone) {
        _onPhone = YES;
        _displayScale = [UIScreen mainScreen].scale;
        UIWindowScene *scene = nil;
        for (UIScene *s in [UIApplication sharedApplication].connectedScenes) {
            if ([s isKindOfClass:[UIWindowScene class]] &&
                ((UIWindowScene *)s).screen == [UIScreen mainScreen]) {
                scene = (UIWindowScene *)s;
                break;
            }
        }
        _window = [[UIWindow alloc] initWithWindowScene:scene];
        _window.frame = [UIScreen mainScreen].bounds;
    } else {
        _onPhone = NO;
        // Metrics buffer for SPPMakeCarWindow. [VERIFIED, final
        // closure 2026-11-08] The callee touches ONLY word 0: it
        // writes the effective scale there (@0x17720) and reads
        // nothing — the 2.0 preset is never consumed, and the named
        // fields after `scale` (like SPPOverspeed's double[8] tail)
        // are dead padding on both sides. Only metrics.scale below
        // is live.
        struct SPPDisplayMetrics {
            double scale;
            double width, height, insetTop, insetLeft, insetBottom,
                   insetRight, reserved[3];
        } metrics = { 2.0, 0, 0, 0, 0, 0, 0, { 0, 0, 0 } };
        _window = SPPMakeCarWindow(&metrics);
        _displayScale = metrics.scale;
        if (_window) SPPMakeWindowPassThrough(_window);
    }
    if (!_window) return;

    if (!_card) {
        _card = [[UIView alloc] init];
        _bubbleView = [[SPPBubbleView alloc] init];
        // NOTE (phase-2 compile fix): the first draft declared an
        // unused `__weak SPPBubble *weakSelf` here. The binary's
        // -ensureWindow @0x1d170 contains no objc_storeWeak /
        // objc_destroyWeak at all, so the declaration was spurious
        // and has been removed to match the binary.
        _bubbleView.log = ^(NSString *message) {
            _OMCLogWrite(@"SpeedBubble", message);
        };
        [_card addSubview:_bubbleView];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
            initWithTarget:self action:@selector(tapped:)];
        [_card addGestureRecognizer:tap];
        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc]
            initWithTarget:self action:@selector(panned:)];
        [_card addGestureRecognizer:pan];
        UIPinchGestureRecognizer *pinch = [[UIPinchGestureRecognizer alloc]
            initWithTarget:self action:@selector(pinched:)];
        [_card addGestureRecognizer:pinch];
        UILongPressGestureRecognizer *hold =
            [[UILongPressGestureRecognizer alloc]
                initWithTarget:self action:@selector(longPressed:)];
        [_card addGestureRecognizer:hold];
    }
    [_window addSubview:_card];
    [self restoreCardPosition];
    if (_onPhone) [self startOrientationTracking];
}

// -startOrientationTracking @0x1d94c — VERIFIED outline: observes
// UIDeviceOrientationDidChangeNotification on the main queue; the
// handler re-applies the phone orientation when on the phone.
- (void)startOrientationTracking {
    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
    __weak SPPBubble *weakSelf = self;
    [[NSNotificationCenter defaultCenter]
        addObserverForName:UIDeviceOrientationDidChangeNotification
                    object:nil
                     queue:[NSOperationQueue mainQueue]
                usingBlock:^(NSNotification *note) {
                    SPPBubble *self = weakSelf;
                    if (self && self->_onPhone) {
                        [self applyPhoneOrientationForce:NO];
                    }
                }];
}

// -phoneRotation @0x1db38 — VERIFIED angles (sign assignment
// INFERRED): portrait 0, landscape +/- pi/2.
- (double)phoneRotation {
    switch ([UIDevice currentDevice].orientation) {
        case UIDeviceOrientationPortrait: return 0;
        case UIDeviceOrientationLandscapeLeft: return 1.5707963267948966;
        case UIDeviceOrientationLandscapeRight: return -1.5707963267948966;
        default: return 0;
    }
}

// -applyPhoneOrientationForce: @0x1dbe0 — VERIFIED: rotates the whole
// window around the screen centre; skips when the rotation changed by
// < 0.01 rad (unless forced), saving/restoring the card position
// around the change; logs "bubble: iPhone xoay %.0f do".
- (void)applyPhoneOrientationForce:(BOOL)force {
    if (!_onPhone) return;
    double rot = [self phoneRotation];
    if (!force && fabs(rot - _appliedRotation) < 0.01) return;
    if (_window.isHidden) return;
    if (!force) [self saveCardPosition];
    _window.transform = CGAffineTransformMakeRotation(rot);
    CGRect bounds = [UIScreen mainScreen].bounds;
    _window.center = CGPointMake(CGRectGetMidX(bounds), CGRectGetMidY(bounds));
    _appliedRotation = rot;
    [self restoreCardPosition];
    _OMCLogWrite(@"SpeedBubble",
        [NSString stringWithFormat:@"bubble: iPhone xoay %.0f do",
                                   rot * 180.0 / M_PI]);
}

// -defaultCardCenter @0x1deb8 — VERIFIED constants (52/70 phone,
// 86/170 car); exact formula INFERRED: inset from the top-right area
// of the window bounds.
- (CGPoint)defaultCardCenter {
    CGSize size = _window.bounds.size;
    if (_onPhone) {
        return CGPointMake(size.width - 52.0, 70.0);
    }
    return CGPointMake(size.width - 86.0, 170.0);
}

// -saveCardPosition @0x1df64 — VERIFIED: stores the card centre as a
// fraction of the window size, clamped to [0,1], per surface.
// -restoreCardPosition @0x1e098 — VERIFIED: fraction < 0 (unset) ->
// default centre; else fraction * bounds.
- (void)saveCardPosition {
    CGSize size = _window.bounds.size;
    if (size.width <= 0 || size.height <= 0) return;
    CGPoint frac = CGPointMake(
        fmin(fmax(_card.center.x / size.width, 0), 1),
        fmin(fmax(_card.center.y / size.height, 0), 1));
    if (_onPhone) _phoneFraction = frac; else _carFraction = frac;
}
- (void)restoreCardPosition {
    CGPoint frac = _onPhone ? _phoneFraction : _carFraction;
    if (frac.x < 0) {
        _card.center = [self defaultCardCenter];
        return;
    }
    CGSize size = _window.bounds.size;
    _card.center = CGPointMake(frac.x * size.width, frac.y * size.height);
}

// -clampCard @0x1e168 — VERIFIED outline: keeps the card frame inside
// the window bounds with a hairline margin from the display scale
// (1/displayScale, INFERRED).
- (void)clampCard {
    if (!_window) return;
    CGRect bounds = _window.bounds;
    CGRect frame = _card.frame;
    double margin = 1.0 / _displayScale;
    CGPoint c = _card.center;
    CGFloat halfW = frame.size.width / 2, halfH = frame.size.height / 2;
    c.x = fmin(fmax(c.x, margin + halfW), bounds.size.width - margin - halfW);
    c.y = fmin(fmax(c.y, margin + halfH), bounds.size.height - margin - halfH);
    _card.center = c;
}

// -applyCrispScale @0x1e2f8 + sub_1e418 — VERIFIED: walks the card's
// layer tree (recursing into sublayers and masks); for every layer
// whose delegate is a UIView, aligns contentsScale to the display
// scale (when off by > 0.001, with setNeedsDisplay) and fixes
// rasterizationScale on rasterizing layers, so the bubble stays crisp
// at any pinch scale. The snapped scale is derived from self.scale and
// the display scale (helper argument pattern INFERRED).
- (void)applyCrispScale {
    if (!_card) return;
    SPPApplyCrispScaleToLayer(_card.layer, _displayScale, NO);
}
static void SPPApplyCrispScaleToLayer(CALayer *layer, double scale,
                                      BOOL isMask) {
    id delegate = layer.delegate;
    if (delegate && [delegate isKindOfClass:[UIView class]]) {
        if (fabs(layer.contentsScale - scale) > 0.001) {
            layer.contentsScale = scale;
            [(UIView *)delegate setNeedsDisplay];
        }
        if (layer.shouldRasterize) {
            layer.rasterizationScale = scale;
        }
    }
    for (CALayer *sub in layer.sublayers) {
        SPPApplyCrispScaleToLayer(sub, scale, isMask);
    }
    if (layer.mask) {
        SPPApplyCrispScaleToLayer(layer.mask, scale, YES);
    }
}

@end
