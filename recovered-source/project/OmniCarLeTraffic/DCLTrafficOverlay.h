#import <Foundation/Foundation.h>
NS_ASSUME_NONNULL_BEGIN

// CarPlay-only, non-key overlay. Lives separately from split/zoom/keyboard
// and from DuoCar's existing fullscreen time/battery/temperature bubble.
// Stage 2 implementation: speed+limit UI; Le's complete sign/lanes pipeline
// and provider hooks still require independent work.
@interface DCLTrafficOverlay : NSObject
+ (instancetype)shared;
- (void)start;
- (void)stop;
@end

NS_ASSUME_NONNULL_END
