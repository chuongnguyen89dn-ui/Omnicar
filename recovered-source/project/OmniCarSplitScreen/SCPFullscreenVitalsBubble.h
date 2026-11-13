// Transient, non-interactive CarPlay status bubble. The existing
// SCPFullscreenController remains the sole fullscreen state owner.
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@interface SCPFullscreenVitalsBubble : NSObject
+ (instancetype)shared;
- (void)showForConfirmedFullscreenInParent:(UIView *)parent;
- (void)stop;
@end
NS_ASSUME_NONNULL_END
