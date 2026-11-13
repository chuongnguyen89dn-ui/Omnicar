// CarPlay-only, noninteractive Device Vitals HUD.
// Never cover app panes, original native Dock or Home/launcher icons.
// Render only in verified free rail space; remain hidden otherwise.
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@interface SCPDeviceVitalsHUD : NSObject
+ (instancetype)shared;
- (void)showForParent:(UIView *)parent
             appArea:(CGRect)appArea
           dockFrame:(CGRect)dockFrame
           homeFrame:(CGRect)homeFrame
       launcherFrame:(CGRect)launcherFrame;
- (void)stop;
@end
NS_ASSUME_NONNULL_END
