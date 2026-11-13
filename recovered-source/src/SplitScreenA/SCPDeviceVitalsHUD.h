// CarPlay-only, noninteractive Device Vitals HUD.
// Never cover app panes or native dock items; hide if geometry is unknown.
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@interface SCPDeviceVitalsHUD : NSObject
+ (instancetype)shared;
- (void)showForParent:(UIView *)parent appArea:(CGRect)appArea dockFrame:(CGRect)dockFrame;
- (void)stop;
@end
NS_ASSUME_NONNULL_END
