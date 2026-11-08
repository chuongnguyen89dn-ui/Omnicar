// SPPSoundDelegate.h — OmniCarPrefs reconstruction (Prefs-B)
// Shared delegate for the SpeedBubble sound engine (SPPSpeak/SPPPlayTone
// in OMCCommon): reference-counts active playback so the AVAudioSession
// category changed for playback is restored when the last sound ends.
// Superclass: NSObject (calibrated).
#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@interface SPPSoundDelegate: NSObject <AVAudioPlayerDelegate, AVSpeechSynthesizerDelegate>
@end
