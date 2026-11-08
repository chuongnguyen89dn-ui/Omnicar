// SPPGlassView.h — OmniCarPrefs reconstruction (Prefs-B)
// Source of truth: capstone disassembly of OmniCarPrefs (arm64 slice).
// Superclass: UIView (calibrated — wave-1 metadata said UIColor, an
// off-by-one chained-fixup artifact; see PrefsB_REPORT.md).
#import <UIKit/UIKit.h>

@interface SPPGlassView: UIView
@property (nonatomic, strong) CAGradientLayer *fill;   // two-stop vertical fill
@property (nonatomic, strong) CAGradientLayer *sheen;  // top highlight gradient
@property (nonatomic, assign) double corner;           // corner radius (setCorner: relayouts)
- (void)setTop:(UIColor *)top bottom:(UIColor *)bottom;
@end
