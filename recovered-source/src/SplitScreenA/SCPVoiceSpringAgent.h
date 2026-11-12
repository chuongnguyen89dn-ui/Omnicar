// HL31: speech input agent is loaded ONLY by the already existing SpringBoard hook.
// Source has no privileged helper, no TCC writes, no automatic recording.
#import <Foundation/Foundation.h>
FOUNDATION_EXPORT void SCPVoiceSpringInstall(void);
