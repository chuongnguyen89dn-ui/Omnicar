// SPPSoundDelegate.m — OmniCarPrefs reconstruction (Prefs-B)
// All four methods VERIFIED (0x35538, 0x355d0, 0x355f8, 0x355fc).
// The counter / saved-category state lives in file statics of the SPP TU
// in the binary (globals at 0x900a0/0x900a8/0x900b0); SPPSpeak/SPPPlayTone
// (OMCCommon) increment the counter and stash the previous category
// before playing.
#import "SPPSoundDelegate.h"

// Shared with the SPPSpeak/SPPPlayTone TU (extern in the binary).
extern NSString *SPPSavedAudioCategory;
extern NSInteger SPPSavedAudioOptions;
extern int SPPActiveSoundCount;

@implementation SPPSoundDelegate

// Common finish path (0x3553c in the binary): when the last active sound
// ends, deactivate the session and restore the saved category.
static void SPPFinishOneSound(void) {
    SPPActiveSoundCount -= 1;
    if (SPPActiveSoundCount < 0) return;
    if (SPPActiveSoundCount != 0) return;
    AVAudioSession *session = [AVAudioSession sharedInstance];
    [session setActive:NO withOptions:AVAudioSessionSetActiveOptionNotifyOthersOnDeactivation error:nil];
    if (SPPSavedAudioCategory) {
        [session setCategory:SPPSavedAudioCategory
                 withOptions:(AVAudioSessionCategoryOptions)SPPSavedAudioOptions error:nil];
        SPPSavedAudioCategory = nil;
    }
}

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag {
    SPPFinishOneSound();
}

- (void)audioPlayerDecodeErrorDidOccur:(AVAudioPlayer *)player error:(NSError *)error {
    NSLog(@"OmniCar SpeedBubble: am thanh: loi giai ma %@", error);
    SPPFinishOneSound();
}

- (void)speechSynthesizer:(AVSpeechSynthesizer *)synthesizer
    didFinishSpeechUtterance:(AVSpeechUtterance *)utterance {
    SPPFinishOneSound();
}

- (void)speechSynthesizer:(AVSpeechSynthesizer *)synthesizer
    didCancelSpeechUtterance:(AVSpeechUtterance *)utterance {
    SPPFinishOneSound();
}

@end
