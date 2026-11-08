// SPPBubbleView.h — OmniCarPrefs reconstruction (Prefs-B)
// The speed-bubble renderer: 9 visual styles (0–8) built from named parts
// (CAShapeLayers in `parts`, plain UIViews in `bits`). Superclass: UIView
// (calibrated). Used by OMCSpeedBubbleController for the live preview and
// the style picker, and (in the runtime dylibs) for the actual bubble.
#import <UIKit/UIKit.h>
#import "SPPGlassView.h"
#import "SPPIconView.h"
#import "SPPSignView.h"

@interface SPPBubbleView: UIView
// Inputs (setColor: triggers rebuild when changed; others are plain)
@property (nonatomic, assign) NSInteger style;      // 0–8 (clamped in render)
@property (nonatomic, assign) int speed;            // -1 = unknown ("--")
@property (nonatomic, assign) int limit;            // -1 = unknown
@property (nonatomic, assign) BOOL showIcon;
@property (nonatomic, strong) UIImage *iconImage;
@property (nonatomic, assign) NSInteger color;      // palette index 0–6
@property (nonatomic, copy) void (^log)(NSString *); // optional debug logger

// Internal build state
@property (nonatomic, assign) NSInteger builtStyle; // -1 = dirty
@property (nonatomic, assign) CGRect outlineRect;
@property (nonatomic, assign) double outlineCorner;
@property (nonatomic, assign) CGSize contentSize;
@property (nonatomic, strong) SPPGlassView *glass;
@property (nonatomic, strong) SPPIconView *iconView;
@property (nonatomic, strong) SPPSignView *sign;
@property (nonatomic, strong) UILabel *speedLabel;
@property (nonatomic, strong) UILabel *unitLabel;
@property (nonatomic, strong) UIView *deco;
@property (nonatomic, strong) NSMutableDictionary *parts; // name -> CAShapeLayer
@property (nonatomic, strong) NSMutableDictionary *bits;  // name -> UIView
@property (nonatomic, strong) NSArray *tickLabels;
@property (nonatomic, strong) UIView *flashView;

// Returns the natural content size, (re)building if the style changed.
- (CGSize)render;
- (void)rebuild;                    // marks builtStyle = -1
- (void)buildStyle:(NSInteger)style;
- (void)renderStyle;
- (int)speedState;                  // 0 ok, 1 near limit (>=90%), 2 over
- (UIColor *)stateColor;
- (double)speedRatio;               // min(speed/limit, 1); limit<1 -> /200
- (UIColor *)numberColor;
- (void)applyColor:(int)state;
- (void)setOverLimitWarning:(BOOL)warn;
- (UIView *)bit:(NSString *)key;
- (UIView *)addBit:(NSString *)key to:(UIView *)container;
- (CAShapeLayer *)shapePart:(NSString *)key in:(UIView *)container
                     stroke:(UIColor *)color width:(double)width;
- (void)stackNumberAt:(double)x top:(double)top width:(double)width;
- (double)stackHeight;
@end
