// SSStartupView.h — OmniCarPrefs (reconstructed, Prefs-B)
// UIView whose backing layer is a CAGradientLayer. Renders the 12 startup
// styles (0 video … 11 occasion/festive) as a self-animating preview driven
// by a CADisplayLink (through SSLinkTarget). Superclass UIView [VERIFIED via
// calibrated metadata/xref + disasm ivar layout].
#import <UIKit/UIKit.h>

@class SSGauge;
@class SSCanvasView;

@interface SSStartupView : UIView

// Public state (set by OMCStartupScreenController before -reload).
@property (nonatomic) BOOL imageFits;
@property (nonatomic) NSInteger style;
@property (nonatomic, strong) UIImage *image;
@property (nonatomic) NSInteger logoEffect;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSDictionary *weather;
@property (nonatomic, strong) NSDate *date;
@property (nonatomic, copy) NSString *carName;
@property (nonatomic) NSInteger tempo;          // 0 slow, 1 normal, 2 fast
@property (nonatomic) NSInteger occasion;       // 1 Tet, 2 birthday, 3 Xmas, 4 Mid-Autumn, 5 New Year
@property (nonatomic, copy) NSArray *hud;
@property (nonatomic, copy) NSDictionary *nextEvent;
@property (nonatomic) NSInteger batteryPercent;
@property (nonatomic) double duration;

- (void)reload;
- (void)playIntro;

// Internal engine (used by SSCanvasView / SSApplySampleData / SSLinkTarget;
// declared here because sibling TUs call them).
- (void)ss_step;
- (void)ss_drawCanvas:(CGContextRef)ctx size:(CGSize)size;
- (void)ss_drawParticles:(CGContextRef)ctx t:(double)t;
- (void)ss_drawFireworks:(CGContextRef)ctx t:(double)t;

@end
