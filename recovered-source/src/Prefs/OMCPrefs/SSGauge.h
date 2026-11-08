// SSGauge.h — OmniCarPrefs (reconstructed, Prefs-B)
// Value object for one SSStartupView engine gauge. [VERIFIED: ivar layout
// hot@8, arc@0x10, fill@0x18, needle@0x20, number@0x28, max@0x30,
// red@0x38, shown@0x40 — all plain synthesized accessors]
#import <QuartzCore/QuartzCore.h>
#import <UIKit/UIKit.h>

@interface SSGauge : NSObject
@property (nonatomic) BOOL hot;
@property (nonatomic, strong) CAShapeLayer *arc;       // progress arc (mask layer; strokeEnd driven)
@property (nonatomic, strong) CAGradientLayer *fill;
@property (nonatomic, strong) CAShapeLayer *needle;
@property (nonatomic, strong) UILabel *number;
@property (nonatomic) double max;
@property (nonatomic) double red;
@property (nonatomic) NSInteger shown;
@end
