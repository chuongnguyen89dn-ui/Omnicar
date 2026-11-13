// DuoCar read-only device vitals. Independent of CarPlay UI/scene ownership.
// A Celsius value is emitted ONLY when an IOKit sensor returns a plausible
// numeric reading. thermalState is categorical and is never converted to °C.
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
FOUNDATION_EXPORT NSDictionary<NSString *, id> *OMCDeviceVitalsSample(void);
FOUNDATION_EXPORT NSString *OMCDeviceVitalsThermalDescription(NSString *state);
NS_ASSUME_NONNULL_END
