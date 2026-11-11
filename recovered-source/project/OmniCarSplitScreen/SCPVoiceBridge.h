// HL29: isolated CarPlay command ingress. Never changes Siri or split ownership.
#import <Foundation/Foundation.h>
FOUNDATION_EXPORT void SCPVoiceInstall(void);
// Same allowlisted owner used by remote IPC and local CarPlay speech.
FOUNDATION_EXPORT BOOL SCPVoiceDispatchLocalCommand(NSDictionary *command);
