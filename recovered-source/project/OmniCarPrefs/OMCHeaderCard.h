// OMCHeaderCard.h — reconstructed interface.
// Evidence: disasm/classes.json (superclass UIView; 12 view/label properties)
// + disasm/OMCHeaderCard.asm (28 methods: initWithFrame:, layoutSubviews,
// updateWithTagline:status:enabled:, 24 accessors, .cxx_destruct).
#import <UIKit/UIKit.h>

@interface OMCHeaderCard : UIView
@property (nonatomic, strong) UIView *card;
@property (nonatomic, strong) UIView *clip;
@property (nonatomic, strong) UIView *dot;              // status dot
@property (nonatomic, strong) CAGradientLayer *gradient;
@property (nonatomic, strong) UIView *sheen;
@property (nonatomic, strong) UIImageView *logo;
@property (nonatomic, strong) UIVisualEffectView *glass;
@property (nonatomic, strong) UILabel *nameLabel;       // "OmniCar"
@property (nonatomic, strong) UILabel *versionLabel;    // "1.0.3"
@property (nonatomic, strong) UILabel *taglineLabel;
@property (nonatomic, strong) UILabel *statusLabel;
@property (nonatomic, strong) UISwitch *toggle;         // master switch

- (void)updateWithTagline:(NSString *)tagline status:(NSString *)status enabled:(BOOL)enabled;
@end
