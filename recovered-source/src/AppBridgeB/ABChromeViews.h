// ABChromeViews.h — [integration phase 1; backported to src in phase 3] the four chrome-view @interface
// blocks below are module B's declarations, copied VERBATIM from
// ABChromeViews.m (where they remain, in-file). They are repeated in this
// header so the other AppBridge TUs that use these classes
// (ABHostLaunch.m, ABHostBMethods.m) can see full interfaces instead of
// ABHost.h's @class forwards. ABChromeViews.m itself does not import
// this header, so no TU sees a duplicate interface.
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ABBoxView : UIView
@property (nonatomic, strong, nullable) UIView *handleHit;
@property (nonatomic, strong, nullable) UIView *bar;
@property (nonatomic) UIEdgeInsets passInsets;
@property (nonatomic) CGRect hole;
- (void)applyHole;
@end

@interface ABShieldView : UIView
@end

@interface ABKnobView : UIView
@property (nonatomic) int index;
@property (nonatomic, strong, nullable) UIView *dot;
@property (nonatomic) CGPoint lastSent;
- (void)relay:(NSInteger)phase touches:(NSSet<UITouch *> *)touches;
@end

@interface ABBarButton : UIButton
@end

NS_ASSUME_NONNULL_END
