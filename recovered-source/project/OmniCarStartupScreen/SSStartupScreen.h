// SSStartupScreen.h
// OmniCar 1.0.3 — OmniCarStartupScreen.dylib — reconstructed interface.
//
// Fidelity tags used across this module's sources:
//   [VERIFIED]   structure and operands read directly from the arm64 disassembly
//                (src/StartupScreen/disasm/, 347 functions).
//   [INFERRED]   behaviour deduced from call sites / naming / standard semantics;
//                the report lists the basis for every inference.
//   [NOT-RECOVERED] line-level detail (exact geometry constants, colour tables)
//                not transcribed; the disassembly remains the ground truth.
//
// Superclass names are the CORRECTED ones (wave-1 metadata had an off-by-one
// bind-ordinal bug; confirmed by the independent annotation audit and by a
// 5,275-site call-target cross-check against metadata/xref, 0 disagreements):
//   SSLocationOnce, SSSplash, SSFade, SSGauge, SSLinkTarget : NSObject
//   SSSplashWindow : UIWindow
//   SSCanvasView, SSStartupView : UIView

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import <CoreLocation/CoreLocation.h>

@class SSStartupView;   // [integration phase 2; backported to src in phase 3] forward decl: SSApplySampleData(SSStartupView *)
                       // at line ~73 uses SSStartupView before its @interface below
                       // (header nit (a) in StartupScreenB_REPORT.md §6).

// ---------------------------------------------------------------------------
// Shared "OMC core" — statically linked into every OmniCar dylib.
// Reconstructed in the core deliverable; declared here as extern.
// ---------------------------------------------------------------------------
extern void        OMCPrefsSync(void);
extern id          OMCPref(NSString *key, id defaultValue);
extern BOOL        OMCEnabled(void);
extern BOOL        OMCFeatureEnabled(NSString *featureName);   // reads "<name>Enabled"
extern BOOL        OMCLiteActive(void);
extern BOOL        OMCCrashGuard(NSString *featureName);      // NO => rescue mode, abort load of feature
extern void OMCLogWrite(NSString *tag, NSString *msg);
extern NSString   *OMCTr(NSString *vietnamese, NSString *english);
// Core path resolver (0x4118 in this binary): maps a logical path to the real
// rootless path via libroot; returns NULL when unresolvable.
extern const char *OMCRealPath(const char *logicalPath);

// ---------------------------------------------------------------------------
// Darwin / notify names [VERIFIED]
// ---------------------------------------------------------------------------
// CFNotificationCenter (Darwin), posted by SSSplash, received in SpringBoard:
//   com.anlai.omnicar/startupscreen.audio.play
//   com.anlai.omnicar/startupscreen.audio.stop
//   com.anlai.omnicar/startupscreen.weather.request
// notify(3) state channels:
//   com.anlai.omnicar/startupscreen.style        (state = style + 1; 0 = unset sentinel, consumer subtracts 1; set by -[SSSplash startCountdown])
//   com.anlai.omnicar/startupscreen.weather.ready (posted by SpringBoard when the cache is refreshed)
//   com.anlai.omnicar/location                    (state = (int32)(lat*100)<<32 | (uint32)(int32)(lon*100),
//                                                  posted by SpeedBubble's GPS; consumed in SpringBoard)

// ---------------------------------------------------------------------------
// C helpers (StartupScreen-specific)
// ---------------------------------------------------------------------------
NSString *SSStartupDir(void);        // /var/mobile/Library/OmniCar/StartupScreen (real path)
NSString *SSVideosDir(void);         // <dir>/Videos
NSString *SSSoundsDir(void);         // <dir>/Sounds
NSString *SSLogoPath(void);          // <dir>/Logo/logo.png
NSInteger SSStyleSetting(void);                     // sub_9afc: clamp(pref startupScreenStyle, 0..10)
NSString *SSChosenVideoName(void);                  // sub_9764
NSTimeInterval SSPlaybackSeconds(void);             // sub_5a04: MAX(pref startupScreenDuration (def 5), 1)
UIImage  *SSLoadImageAtPath(NSString *path);        // sub_5a5c: ImageIO, kCGImageSourceShouldCacheImmediately
NSInteger SSBatteryPercent(BOOL *outCharging);      // sub_5b68: -1 when level unknown
NSString *SSScreenDescription(UIScreen *screen);    // sub_8308
BOOL      SSIsCarScreen(UIScreen *screen);          // sub_a61c: idiom==CarPlay || screen != mainScreen
void      SSHandleCarScreen(UIScreen *screen, UIWindowScene *scene, NSString *reason); // sub_a6c4

NSInteger SSPeriodForDate(NSDate *date);            // 0 morning 5-10, 1 day 11-16, 2 evening 17-20, 3 night
NSDictionary *SSWeatherParse(NSDictionary *json);   // -> {temp, code, isDay, high, low, rain, date}
NSDictionary *SSWeatherLoadCache(void);
void          SSWeatherSaveCache(NSDictionary *weather);
void          SSWeatherFetch(double lat, double lon, void (^completion)(NSDictionary *weather));
void          SSApplySampleData(SSStartupView *view);   // exported; fills preview/sample content

// ---------------------------------------------------------------------------
// SSLocationOnce — one-shot CLLocationManager wrapper [VERIFIED]
// ---------------------------------------------------------------------------
@interface SSLocationOnce : NSObject <CLLocationManagerDelegate>
@property (nonatomic, strong) CLLocationManager *manager;
@property (nonatomic, copy)   void (^done)(CLLocation *location);
@end

// ---------------------------------------------------------------------------
// SSSplashWindow — marker subclass; excluded from the setHidden: trigger.
// ---------------------------------------------------------------------------
@interface SSSplashWindow : UIWindow
@end

// ---------------------------------------------------------------------------
// SSStartupView — the animated welcome/briefing scene (styles 1-9 and 11).
// Its backing layer is a CAGradientLayer (+layerClass). [VERIFIED by usage]
// ---------------------------------------------------------------------------
@class SSFade, SSGauge, SSCanvasView;

@interface SSStartupView : UIView {
    // Ivar layout exactly as dumped (72 ivars); only names/types reproduced.
    double _unit;
    UIStackView *_stack;
    UIImageView *_logoView;
    UIImageView *_posterView;
    UILabel *_timeLabel, *_titleLabel, *_dateLabel, *_tempLabel, *_condLabel;
    UILabel *_rangeLabel, *_rainLabel, *_updatedLabel;
    UIImageView *_iconView;
    UIStackView *_row, *_cardStack;
    UIVisualEffectView *_card;
    NSLayoutConstraint *_iconW, *_iconH;
    NSArray<NSLayoutConstraint *> *_stackMaxWidth;   // [integration phase 2; backported to src in phase 3] slot 0x3ad00 actually stores
                       // the NSArray of the 4 card constraints built in -buildWeatherWithPeriod:
                       // (ScenesB), NOT a single constraint — type reconciled per
                       // StartupScreenB_REPORT.md §6 header nit (b). Name kept.
    NSArray *_cardInsets;
    NSInteger _sceneStyle, _sky;
    CGSize _sceneSize;
    BOOL _sceneBuilt;
    double _k, _ox, _oy, _restTime, _linkEnd, _tempoScale, _t0;
    BOOL _playing;
    CADisplayLink *_link;
    UIView *_scene, *_glass;
    SSCanvasView *_canvas;
    NSMutableArray *_fades;        // SSFade *
    NSMutableData *_motes;         // packed mote records
    NSMutableArray *_moteLayers;   // CALayer *
    NSMutableArray *_gauges;       // SSGauge *
    NSMutableData *_particles;     // packed particle records
    double _dot;
    NSMutableData *_bursts;        // packed firework bursts
    CAShapeLayer *_outline, *_wheels, *_wetMask;
    CALayer *_flash, *_horizon, *_rays, *_wiper, *_lightning, *_radar;
    double _wiperLength, _cleared;
    CGPoint _wiperPivot;
    NSMutableArray *_rings;
    UILabel *_percentLabel;
    NSInteger _percentShown;
    // public-state ivars (back the properties below)
    BOOL _imageFits;
    NSInteger _style;
    UIImage *_image;
    NSInteger _logoEffect;
    NSString *_name;
    NSDictionary *_weather;
    NSDate *_date;
    NSString *_carName;
    NSInteger _tempo;
    NSInteger _occasion;
    NSArray *_hud;
    NSDictionary *_nextEvent;
    NSInteger _batteryPercent;
    double _duration;
}
@property (nonatomic)         NSInteger style;
@property (nonatomic, strong) UIImage *image;
@property (nonatomic)         BOOL imageFits;
@property (nonatomic)         NSInteger logoEffect;
@property (nonatomic, copy)   NSString *name;
@property (nonatomic, copy)   NSDictionary *weather;
@property (nonatomic, copy)   NSDate *date;
@property (nonatomic, copy)   NSString *carName;
@property (nonatomic)         NSInteger tempo;
@property (nonatomic)         NSInteger occasion;
@property (nonatomic, copy)   NSArray *hud;          // of @{ @"text": NSString, @"ok": NSNumber }
@property (nonatomic, copy)   NSDictionary *nextEvent; // @{ @"title":…, @"date": NSDate, … }
@property (nonatomic)         NSInteger batteryPercent; // -1 = unknown
@property (nonatomic)         double duration;

- (void)clearContent;
- (void)reload;
- (void)playIntro;
@end

// ---------------------------------------------------------------------------
// SSSplash — one splash session bound to one UIScreen.
// Style 0: JPEG frame-sequence player (framesDir/%05lu.jpg + info.plist).
// Styles 1-11: hosts an SSStartupView.
// ---------------------------------------------------------------------------
@interface SSSplash : NSObject {
    BOOL _loop, _decoding, _finished;
    UIWindow *_window;
    NSInteger _style;
    UIImageView *_imageView;
    SSStartupView *_startView;
    __weak UIScreen *_screen;
    NSString *_framesDir;
    NSUInteger _frameCount;
    double _fps;
    NSMutableArray *_buffer;       // decoded UIImages awaiting display
    dispatch_queue_t _decodeQueue; // "com.anlai.omnicar.startupscreen.decode"
    NSUInteger _queuedFrames, _shownFrames, _failedFrames;
    double _startTime;
    CADisplayLink *_displayLink;
    NSString *_endReason;
    double _shownAt;
}
// [integration phase 2; backported to src in phase 3] — SSSplash accessors] @property declarations restored
// verbatim from metadata/raw/OmniCarStartupScreen/objc.json (arm64 slice,
// SSSplash properties[], 20 entries). Placed in the main @interface (as with
// SSStartupView/SSLocationOnce in this header) so clang auto-synthesises the
// accessors bound to the EXISTING _<name> ivars above — no ivar was added,
// renamed or retyped. decodeQueue: dispatch_queue_t is
// NSObject<OS_dispatch_queue> * under OS_OBJECT_USE_OBJC, exactly the
// metadata encoding T@"NSObject<OS_dispatch_queue>",&,N,V_decodeQueue.
@property (nonatomic, strong) UIWindow *window;
@property (nonatomic)         NSInteger style;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) SSStartupView *startView;
@property (nonatomic, weak)   UIScreen *screen;
@property (nonatomic, copy)   NSString *framesDir;
@property (nonatomic)         NSUInteger frameCount;
@property (nonatomic)         double fps;
@property (nonatomic)         BOOL loop;
@property (nonatomic, strong) NSMutableArray *buffer;
@property (nonatomic, strong) dispatch_queue_t decodeQueue;
@property (nonatomic)         BOOL decoding;
@property (nonatomic)         NSUInteger queuedFrames;
@property (nonatomic)         NSUInteger shownFrames;
@property (nonatomic)         NSUInteger failedFrames;
@property (nonatomic)         double startTime;
@property (nonatomic, strong) CADisplayLink *displayLink;
@property (nonatomic)         BOOL finished;
@property (nonatomic, copy)   NSString *endReason;
@property (nonatomic)         double shownAt;
- (instancetype)initWithScreen:(UIScreen *)screen scene:(UIWindowScene *)scene
                         style:(NSInteger)style occasion:(NSInteger)occasion
                     framesDir:(NSString *)framesDir frameCount:(NSUInteger)frameCount
                           fps:(double)fps;
- (void)start;
- (void)decodeMore;
- (void)refreshWeather;
- (void)tick;                          // CADisplayLink callback
- (void)startCountdown;
- (void)tapped:(UITapGestureRecognizer *)recognizer;
- (void)dismiss;                       // dismissBecause: @"skip"
- (void)dismissBecause:(NSString *)reason;
- (void)tearDown;
@end

// ---------------------------------------------------------------------------
// SSFade — alpha/translation envelope for one view. [VERIFIED applyTime:]
// ---------------------------------------------------------------------------
@interface SSFade : NSObject
@property (nonatomic, strong) UIView *view;
@property (nonatomic) double inA, inB;     // fade-in window (seconds)
@property (nonatomic) double outA, outB;   // fade-out window
@property (nonatomic) double alpha;        // peak alpha
@property (nonatomic) double rise;         // vertical rise (points) across the in-window
@property (nonatomic) BOOL   outEase;      // pow() easing on the out ramp
- (void)applyTime:(double)t;
@end

// ---------------------------------------------------------------------------
// SSGauge — one dashboard gauge (arc + gradient fill + needle + number).
// No logic methods of its own; driven by SSStartupView. [VERIFIED]
// ---------------------------------------------------------------------------
@interface SSGauge : NSObject
@property (nonatomic, strong) CAShapeLayer *arc;
@property (nonatomic, strong) CAGradientLayer *fill;
@property (nonatomic, strong) CALayer *needle;
@property (nonatomic, strong) UILabel *number;
@property (nonatomic) double max, red;
@property (nonatomic) NSInteger shown;
@property (nonatomic) BOOL hot;
@end

// ---------------------------------------------------------------------------
// SSLinkTarget / SSCanvasView — weak-owner proxies (avoid retain cycles).
// ---------------------------------------------------------------------------
@interface SSLinkTarget : NSObject
@property (nonatomic, weak) SSStartupView *owner;
- (void)step:(CADisplayLink *)link;
@end

@interface SSCanvasView : UIView
@property (nonatomic, weak) SSStartupView *owner;
@end
