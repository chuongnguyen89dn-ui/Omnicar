// Transient, draggable CarPlay status bubble with pass-through outside its
// own pill. Unlike the old Voice bubble it never auto-dims. The existing
// SCPFullscreenController remains the sole fullscreen state owner.
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@interface SCPFullscreenVitalsBubble : NSObject
+ (instancetype)shared;
- (void)showForConfirmedFullscreenInParent:(UIView *)parent;
- (void)stop;
@end
NS_ASSUME_NONNULL_END
