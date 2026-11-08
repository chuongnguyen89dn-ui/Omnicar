// SPPWarningSound.m — reconstructed from OmniCarSpeedBubble.dylib (arm64).
// Agent A (display side). Warning audio: synthesized WAV tones (SPPPlayTone),
// TTS voice lines (SPPSpeak + SPPVoiceLine/SPPVoiceTemplate), the shared
// AVAudioSession acquire/release pair, and SPPSoundDelegate.
// Status: VERIFIED from disassembly except where a comment says INFERRED.
// Log lines are the module's own Vietnamese strings (tag "SpeedBubble").

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioToolbox.h>
#import <math.h>
#import <stdlib.h>

// OMC core (shared): localization + log.
extern NSString *_OMCTr(NSString *vi, NSString *en);
extern void _OMCLogWrite(NSString *module, NSString *message);
extern NSString *_OMCCurrentLanguage(void);   // returns an NSString language code

#pragma mark - Voice lines

// _SPPVoiceTemplate @0x15f18 — VERIFIED. _OMCTr(vi, en) picks by current language.
NSString *SPPVoiceTemplate(NSInteger line) {
    switch (line) {
        case 1:  return _OMCTr(@"Quá tốc độ, giới hạn {L}",
                               @"Too fast, the limit is {L}");
        case 2:  return _OMCTr(@"Vui lòng giảm tốc độ",
                               @"Please slow down");
        case 3:  return _OMCTr(@"Ê, xe chứ có phải máy bay đâu!",
                               @"Hey, this is a car, not a plane!");
        case 4:  return _OMCTr(@"Bình tĩnh, đường còn dài mà ví thì còn mỏng",
                               @"Easy now, the road is long and the wallet is thin");
        case 5:  return _OMCTr(@"Camera phạt nguội đang mỉm cười với bạn đó",
                               @"The speed camera is smiling at you");
        case 6:  return _OMCTr(@"Chạy gì mà vội, cơm nhà vẫn còn nóng mà",
                               @"What's the rush? Dinner at home is still hot");
        case 7:  return _OMCTr(@"Nhẹ chân ga thôi, chạy nhanh không làm bạn đẹp trai hơn đâu",
                               @"Easy on the gas, speeding won't make you any better looking");
        default: return _OMCTr(@"Bạn đang vượt quá giới hạn tốc độ",
                               @"You are over the speed limit");
    }
}

// _SPPVoiceIsFun @0x16018 — VERIFIED: lines 3..7 are the "fun" lines.
BOOL SPPVoiceIsFun(NSInteger line) {
    return (NSUInteger)(line - 3) < 5;
}

// _SPPVoiceLine @0x16028 — VERIFIED.
// line 8 = user custom text (SPPPrefs warnVoiceText); empty custom text
// falls back to template 0. "{L}" is replaced by the limit (or "" when
// limit < 1); the result is trimmed of leading/trailing spaces and commas.
NSString *SPPVoiceLine(NSInteger line, NSString *customText, NSInteger limit) {
    NSString *text = nil;
    if (line == 8) {
        text = [customText stringByTrimmingCharactersInSet:
                [NSCharacterSet whitespaceAndNewlineCharacterSet]];
    }
    if (text.length == 0) {
        text = SPPVoiceTemplate(line == 8 ? 0 : line);
    }
    NSString *num = (limit >= 1) ? [NSString stringWithFormat:@"%d", (int)limit] : @"";
    text = [text stringByReplacingOccurrencesOfString:@"{L}" withString:num];
    return [text stringByTrimmingCharactersInSet:
            [NSCharacterSet characterSetWithCharactersInString:@" ,"]];
}

#pragma mark - Sound delegate (SPPSoundDelegate)

// Class SPPSoundDelegate: audioPlayerDidFinishPlaying:successfully: @0x161a4
// is an EMPTY body (4-byte ret); the two speech delegate methods are empty
// too; only the decode-error callback logs.
@interface SPPSoundDelegate : NSObject <AVAudioPlayerDelegate, AVSpeechSynthesizerDelegate>
@end

@implementation SPPSoundDelegate
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag {
    // empty in the binary
}
- (void)audioPlayerDecodeErrorDidOccur:(AVAudioPlayer *)player error:(NSError *)error {
    _OMCLogWrite(@"SpeedBubble",
                 [NSString stringWithFormat:@"am thanh: loi giai ma %@", error]);
}
- (void)speechSynthesizer:(AVSpeechSynthesizer *)synthesizer
    didFinishSpeechUtterance:(AVSpeechUtterance *)utterance {
    // empty in the binary
}
- (void)speechSynthesizer:(AVSpeechSynthesizer *)synthesizer
    didCancelSpeechUtterance:(AVSpeechUtterance *)utterance {
    // empty in the binary
}
@end

// sub_16c54 @0x16c54 — VERIFIED shape: process-wide shared delegate instance.
static SPPSoundDelegate *SPPSharedSoundDelegate(void) {
    static SPPSoundDelegate *delegate;
    if (!delegate) delegate = [SPPSoundDelegate new];
    return delegate;
}

#pragma mark - AVAudioSession acquire / release

static NSInteger SPPAudioSessionUsers;          // bss+0x178
static NSString *SPPSavedCategory;              // bss+0x170
static AVAudioSessionCategoryOptions SPPSavedOptions; // bss+0x180

// sub_16a1c @0x16a1c — VERIFIED (log strings + call sequence):
// ensure the shared session is Playback and active, logging the route.
// (INFERRED detail: the saved-category store + refcount increment pair with
//  SPPReleaseAudioSession's decrement-and-restore, which is proven there.)
void SPPPrepareAudioSession(void) {
    AVAudioSession *session = [AVAudioSession sharedInstance];
    SPPAudioSessionUsers++;
    if (SPPAudioSessionUsers == 1) {
        SPPSavedCategory = session.category;
        SPPSavedOptions = session.categoryOptions;
    }
    NSError *error = nil;
    if (![session.category isEqualToString:AVAudioSessionCategoryPlayback]) {
        [session setCategory:AVAudioSessionCategoryPlayback withOptions:0 error:&error];
        if (error) {
            _OMCLogWrite(@"SpeedBubble",
                [NSString stringWithFormat:@"am thanh: khong dat duoc phien Playback: %@", error]);
            error = nil;
        }
    }
    [session setActive:YES error:&error];
    if (error) {
        _OMCLogWrite(@"SpeedBubble",
            [NSString stringWithFormat:@"am thanh: khong bat duoc phien: %@", error]);
    } else {
        NSString *port = session.currentRoute.outputs.firstObject.portType ?: @"?";
        _OMCLogWrite(@"SpeedBubble",
            [NSString stringWithFormat:@"am thanh: phien bat, ra %@", port]);
    }
}

// sub_161a8 @0x161a8 — VERIFIED: decrement the user count; at zero,
// deactivate (notify others) and restore the saved category/options.
void SPPReleaseAudioSession(void) {
    if (--SPPAudioSessionUsers < 0) { SPPAudioSessionUsers = 0; return; }
    if (SPPAudioSessionUsers != 0) return;
    AVAudioSession *session = [AVAudioSession sharedInstance];
    [session setActive:NO withOptions:AVAudioSessionSetActiveOptionNotifyOthersOnDeactivation
                 error:nil];
    if (SPPSavedCategory) {
        [session setCategory:SPPSavedCategory withOptions:SPPSavedOptions error:nil];
        SPPSavedCategory = nil;
    }
}

#pragma mark - Speech

// sub_16e44 @0x16e44 — VERIFIED: BCP-47 locale for the current OMC language,
// from the constant map {ar:ar-SA, de:de-DE, en:en-US, es:es-ES, fr:fr-FR,
// id:id-ID, it:it-IT, ja:ja-JP, ko:ko-KR, pt-BR:pt-BR, ru:ru-RU, th:th-TH,
// vi:vi-VN, zh-Hans:zh-CN}; unknown -> @"en-US".
static NSString *SPPSpeechLocale(void) {
    static NSDictionary *map;
    if (!map) map = @{@"ar": @"ar-SA", @"de": @"de-DE", @"en": @"en-US",
                      @"es": @"es-ES", @"fr": @"fr-FR", @"id": @"id-ID",
                      @"it": @"it-IT", @"ja": @"ja-JP", @"ko": @"ko-KR",
                      @"pt-BR": @"pt-BR", @"ru": @"ru-RU", @"th": @"th-TH",
                      @"vi": @"vi-VN", @"zh-Hans": @"zh-CN"};
    NSString *locale = map[_OMCCurrentLanguage()];
    return locale ?: @"en-US";
}

// _SPPSpeak @0x16ca4 — VERIFIED.
void SPPSpeak(NSString *text) {
    if (text.length == 0) return;
    static AVSpeechSynthesizer *synth;   // bss+0x168
    if (!synth) {
        synth = [AVSpeechSynthesizer new];
        synth.usesApplicationAudioSession = YES;
        synth.delegate = SPPSharedSoundDelegate();
    }
    if (synth.isSpeaking) {
        [synth stopSpeakingAtBoundary:AVSpeechBoundaryImmediate];
    }
    SPPPrepareAudioSession();
    AVSpeechUtterance *utt = [AVSpeechUtterance speechUtteranceWithString:text];
    NSString *lang = SPPSpeechLocale();
    AVSpeechSynthesisVoice *voice = [AVSpeechSynthesisVoice voiceWithLanguage:lang];
    if (!voice) {
        _OMCLogWrite(@"SpeedBubble",
            [NSString stringWithFormat:@"am thanh: khong co giong %@, dung giong mac dinh", lang]);
    }
    utt.voice = voice;
    utt.volume = 1.0f;
    [synth speakUtterance:utt];
}

#pragma mark - Synthesized tones

// _SPPPlayTone @0x162a0 — VERIFIED (segment tables, renderer, WAV build,
// playback chain and fallback). One segment = one oscillator burst:
//   wave: 0 = square (sign of sine), 1 = sine, 2 = triangle (asin * 2/pi)
// Envelope per segment (VERIFIED): 12 ms linear attack to `gain`, then an
// exponential decay env = gain * pow(0.0008/gain, (t-start-0.012)/(dur-0.012))
// across the segment, then a 0.0008 residual tail for 50 ms past the end.
// All segments are mixed into one double buffer, peak-normalized to 0.8,
// and rendered as 16-bit mono WAV at 22050 Hz.
typedef struct {
    double freq;    // Hz
    double start;   // seconds
    double dur;     // seconds
    int32_t wave;   // 0 square, 1 sine, 2 triangle
    double gain;
} SPPToneSegment;

static const SPPToneSegment SPPTone0[] = {   // single short square beep
    {1320, 0, 0.16, 0, 0.06},
};
static const SPPToneSegment SPPTone1[] = {   // double square beep
    {1320, 0, 0.12, 0, 0.06},
    {1320, 0.18, 0.12, 0, 0.06},
};
static const SPPToneSegment SPPTone2[] = {   // triple square beep
    {1472, 0, 0.09, 0, 0.06},
    {1472, 0.13, 0.09, 0, 0.06},
    {1472, 0.26, 0.09, 0, 0.06},
};
static const SPPToneSegment SPPTone3[] = {   // two overlapping sines
    {988, 0, 0.7, 1, 0.3},
    {784, 0.28, 0.9, 1, 0.3},
};
static const SPPToneSegment SPPTone4[] = {   // one long high sine
    {1760, 0, 0.9, 1, 0.28},
};
static const SPPToneSegment SPPTone5[] = {   // rising triangle arpeggio
    {900, 0, 0.1, 2, 0.2},
    {1120, 0.2, 0.1, 2, 0.2},
    {1340, 0.4, 0.1, 2, 0.2},
    {1560, 0.6, 0.1, 2, 0.2},
};
// tone index > 5 falls back to tone 0 (binary: csel hi at entry).

static NSData *SPPRenderTone(const SPPToneSegment *segs, NSUInteger count) {
    double total = 0;
    for (NSUInteger s = 0; s < count; s++) {
        double end = segs[s].start + segs[s].dur;
        if (end > total) total = end;
    }
    total += 0.05;
    NSUInteger n = (NSUInteger)(total * 22050.0);
    double *buf = calloc(n, sizeof(double));
    for (NSUInteger s = 0; s < count; s++) {
        const SPPToneSegment *seg = &segs[s];
        double attackEnd = seg->start + 0.012;
        double segEnd = seg->start + seg->dur;
        double tailEnd = segEnd + 0.05;
        double decayBase = 0.0008 / seg->gain;
        NSUInteger first = (NSUInteger)(seg->start * 22050.0);
        for (NSUInteger i = first; i < n; i++) {
            double t = (double)i / 22050.0;
            if (t > tailEnd) break;
            double env;
            if (t < attackEnd) {
                env = seg->gain * (t - seg->start) / 0.012;
            } else if (t < segEnd) {
                env = seg->gain * pow(decayBase, (t - attackEnd) / (seg->dur - 0.012));
            } else {
                env = 0.0008;
            }
            double ph = sin(seg->freq * 6.283185307179586 * (t - seg->start));
            double w;
            if (seg->wave == 2)      w = asin(ph) * 0.6366197723675814;
            else if (seg->wave == 0) w = (ph >= 0) ? 1.0 : -1.0;
            else                     w = ph;
            buf[i] += env * w;
        }
    }
    double peak = 0;
    for (NSUInteger i = 0; i < n; i++) {
        double a = fabs(buf[i]);
        if (a > peak) peak = a;
    }
    double scale = (peak > 0) ? 0.8 / peak : 0;
    NSMutableData *data = [NSMutableData dataWithLength:n * 2 + 44];
    uint8_t *b = data.mutableBytes;
    // 44-byte canonical WAV header (PCM, mono, 22050 Hz, 16-bit) — the
    // binary writes these exact fields dword by dword.
    memcpy(b + 0, "RIFF", 4);
    *(uint32_t *)(b + 4) = (uint32_t)(n * 2 + 36);
    memcpy(b + 8, "WAVEfmt ", 8);
    *(uint32_t *)(b + 16) = 16;
    *(uint16_t *)(b + 20) = 1;        // PCM
    *(uint16_t *)(b + 22) = 1;        // channels
    *(uint32_t *)(b + 24) = 22050;    // sample rate
    *(uint32_t *)(b + 28) = 44100;    // byte rate
    *(uint16_t *)(b + 32) = 2;        // block align
    *(uint16_t *)(b + 34) = 16;       // bits per sample
    memcpy(b + 36, "data", 4);
    *(uint32_t *)(b + 40) = (uint32_t)(n * 2);
    int16_t *samples = (int16_t *)(b + 44);
    for (NSUInteger i = 0; i < n; i++) {
        double v = buf[i] * scale;
        if (v > 1.0) v = 1.0;
        if (v < -1.0) v = -1.0;
        samples[i] = (int16_t)lrint(v * 32767.0);   // fcvtas in the binary
    }
    free(buf);
    return data;
}

void SPPPlayTone(NSInteger tone) {
    static NSData *cache[6];              // bss+0x120
    static AVAudioPlayer *player;         // bss+0x118
    static SystemSoundID soundIDs[6];     // bss+0x150
    NSInteger idx = (tone >= 0 && tone <= 5) ? tone : 0;
    if (!cache[idx]) {
        const SPPToneSegment *segs;
        NSUInteger count;
        switch (idx) {
            case 1:  segs = SPPTone1; count = 2; break;
            case 2:  segs = SPPTone2; count = 3; break;
            case 3:  segs = SPPTone3; count = 2; break;
            case 4:  segs = SPPTone4; count = 1; break;
            case 5:  segs = SPPTone5; count = 4; break;
            default: segs = SPPTone0; count = 1; break;
        }
        cache[idx] = SPPRenderTone(segs, count);
    }
    if (player) {
        [player stop];
        player = nil;
    }
    SPPPrepareAudioSession();
    NSError *error = nil;
    player = [[AVAudioPlayer alloc] initWithData:cache[idx]
                                  fileTypeHint:AVFileTypeWAVE
                                           error:&error];
    if (player) {
        player.delegate = SPPSharedSoundDelegate();
        player.volume = 1.0f;
        if (![player play]) {
            _OMCLogWrite(@"SpeedBubble",
                [NSString stringWithFormat:@"am thanh: khong phat duoc am bao %ld", (long)idx]);
            SPPReleaseAudioSession();
        }
        return;
    }
    // Player could not be created: fall back to a system sound played
    // from a cached WAV file in the temporary directory.
    _OMCLogWrite(@"SpeedBubble",
        [NSString stringWithFormat:@"am thanh: khong mo duoc am bao %ld: %@ -> am he thong",
                                   (long)idx, error]);
    SPPReleaseAudioSession();
    if (soundIDs[idx] == 0) {
        NSString *path = [NSTemporaryDirectory() stringByAppendingPathComponent:
                          [NSString stringWithFormat:@"omc-speedbubble-tone-%ld.wav", (long)idx]];
        if ([cache[idx] writeToFile:path atomically:YES]) {
            SystemSoundID sid = 0;
            if (AudioServicesCreateSystemSoundID((__bridge CFURLRef)[NSURL fileURLWithPath:path],
                                                 &sid) == 0) {
                soundIDs[idx] = sid;
            }
        }
    }
    if (soundIDs[idx] != 0) {
        AudioServicesPlaySystemSound(soundIDs[idx]);
    }
}
