// SPPIconView.h — OmniCarPrefs reconstruction (Prefs-B)
// Superclass: UIView (calibrated).
#import <UIKit/UIKit.h>

@interface SPPIconView: UIView
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, assign) NSInteger shape;      // 0 rounded, 1 circle, 2 tile
@property (nonatomic, assign) double tileCorner;    // corner radius when shape == 2
@property (nonatomic, assign) NSUInteger tileMask;  // CACornerMask when shape == 2
@end
