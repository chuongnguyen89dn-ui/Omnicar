// OMCSSStyleTileCell.h — OmniCarPrefs reconstruction (Prefs-B)
// Gallery tile for one startup-screen style (used by
// OMCStartupScreenController's style strip). Superclass:
// UICollectionViewCell (calibrated).
#import <UIKit/UIKit.h>

@interface OMCSSStyleTileCell: UICollectionViewCell
@property (nonatomic, strong) UIView *card;
@property (nonatomic, strong) CAGradientLayer *fill;
@property (nonatomic, copy) NSArray *styleColors;   // two CGColors for the gradient
@property (nonatomic, strong) UIImageView *glyph;
@property (nonatomic, strong) UILabel *title;
- (void)showStyle:(NSInteger)style chosen:(BOOL)chosen dark:(BOOL)dark;
- (void)setChosen:(BOOL)chosen dark:(BOOL)dark;
@end
