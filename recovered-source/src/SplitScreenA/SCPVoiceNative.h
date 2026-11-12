// HL30: first-party CarPlay voice bubble, existing split owner only.
#import <Foundation/Foundation.h>
@class SCPCarSplit;
FOUNDATION_EXPORT void SCPVoiceBubbleUpdate(SCPCarSplit *split);
FOUNDATION_EXPORT void SCPVoiceBubbleDetach(SCPCarSplit *split);
FOUNDATION_EXPORT void SCPVoiceNativeToggle(SCPCarSplit *split);
FOUNDATION_EXPORT void SCPVoiceHandleRemoteState(NSDictionary *packet);
