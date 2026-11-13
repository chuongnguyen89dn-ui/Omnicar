#import <Foundation/Foundation.h>
#import "DCLTrafficCore.h"

NS_ASSUME_NONNULL_BEGIN

// One read-only adapter for the legacy Le IPC and for a future DuoCar-native
// provider. Callbacks are delivered on the main queue while CarPlay is alive.
// Does not create windows, alter SpringBoard, or start any provider app.
typedef void (^DCLTrafficSampleCallback)(DCLTrafficReading reading,
                                          NSString *providerName);

@interface DCLTrafficSampler : NSObject
- (void)startWithCallback:(DCLTrafficSampleCallback)callback;
- (void)stop;
@end

NS_ASSUME_NONNULL_END
