// DuoCar HL29 - opt-in first-party iPhone voice session (not DuoNavi binary).
#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN
FOUNDATION_EXPORT UIViewController *DCVoiceCreateController(void);
FOUNDATION_EXPORT BOOL DCVoiceIsEnabled(void);
FOUNDATION_EXPORT void DCVoiceHandleCarRequest(NSDictionary * _Nullable payload,
                                               UIViewController * _Nullable root);
NS_ASSUME_NONNULL_END
