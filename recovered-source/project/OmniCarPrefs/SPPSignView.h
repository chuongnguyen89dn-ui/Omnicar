// SPPSignView.h — OmniCarPrefs reconstruction (Prefs-B)
// The speed-limit sign inside SPPBubbleView. Superclass: UIView (calibrated).
#import <UIKit/UIKit.h>

@interface SPPSignView: UIView
@property (nonatomic, strong) UILabel *label;
@property (nonatomic, assign) BOOL muted;   // setMuted: re-applies colors (guarded)
- (void)applyColors;
@end
