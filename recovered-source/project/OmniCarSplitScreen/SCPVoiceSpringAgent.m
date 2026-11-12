// HL31: first-party DuoCar voice capture in SpringBoard, separate from the
// CarPlay bubble/UI. DuoNavi 1.0.4 static evidence: VoiceSessionManager owns
// VoiceAudioCapture and two STT providers; speech output is separate.
// User-initiated only. No system-permission database writes, vendor network, stored audio,
// persistent microphone, or source/transcript logging.
#import "SCPVoiceSpringAgent.h"
#import "SCPShared.h"
#import "SCPIntegrationShims.h"
#import "DCVoiceCommand.h"
#import <Speech/Speech.h>
#import <AVFoundation/AVFoundation.h>
#import <math.h>
#import <unistd.h>
static NSString *const DCReq=@"com.anlai.omnicar/voice.capture.request";
static NSString *const DCState=@"com.anlai.omnicar/voice.capture.state";
static NSString *const DCAction=@"com.anlai.omnicar/voice.action";
static NSString *const DCAck=@"com.anlai.omnicar/voice.ack";
static volatile int32_t DCBuffers;
// [hl33-voice] One audio-owner, diagnostic metrics ONLY. No audio or
// transcripts stored. The realtime tap updates integers, never logs.
static uint64_t DC33TotalFrames,DC33TotalSamples,DC33AboveLow,DC33AboveHigh;
static uint64_t DC33SumSquaresNano,DC33MaxPeakMicro,DC33UnsupportedBuffers;
static volatile int32_t DC33SignalSent;
static void DC33ResetEnergy(void) {
    __atomic_store_n(&DC33TotalFrames,0,__ATOMIC_RELAXED);
    __atomic_store_n(&DC33TotalSamples,0,__ATOMIC_RELAXED);
    __atomic_store_n(&DC33AboveLow,0,__ATOMIC_RELAXED);
    __atomic_store_n(&DC33AboveHigh,0,__ATOMIC_RELAXED);
    __atomic_store_n(&DC33SumSquaresNano,0,__ATOMIC_RELAXED);
    __atomic_store_n(&DC33MaxPeakMicro,0,__ATOMIC_RELAXED);
    __atomic_store_n(&DC33UnsupportedBuffers,0,__ATOMIC_RELAXED);
    DC33SignalSent=0;
}
static void DC33MeasureBuffer(AVAudioPCMBuffer *buffer) {
    AVAudioFrameCount frames=buffer.frameLength;
    AVAudioChannelCount channels=buffer.format.channelCount;
    if (!frames || !channels || channels>16 || frames>16384) return;
    BOOL interleaved=buffer.format.isInterleaved;
    AVAudioCommonFormat common=buffer.format.commonFormat;
    float **f=(common==AVAudioPCMFormatFloat32)?buffer.floatChannelData:NULL;
    int16_t **i16=(common==AVAudioPCMFormatInt16)?buffer.int16ChannelData:NULL;
    if ((!f && !i16) || (f && !f[0]) || (i16 && !i16[0])) {
        __atomic_fetch_add(&DC33UnsupportedBuffers,1,__ATOMIC_RELAXED);
        return;
    }
    uint64_t samples=0,low=0,high=0,squares=0,peak=0;
    for (AVAudioChannelCount c=0;c<channels;c++) {
        if ((!interleaved && f && !f[c]) ||
            (!interleaved && i16 && !i16[c])) continue;
        for (AVAudioFrameCount j=0;j<frames;j++) {
            NSUInteger ix=interleaved ? (NSUInteger)j*channels+c:j;
            double v=f ? (double)f[interleaved?0:c][ix]
                       : (double)i16[interleaved?0:c][ix]/32768.0;
            if (!isfinite(v)) continue;
            double a=fabs(v);
            if (a>1) a=1;
            if (a>0.0001) low++;
            if (a>0.001) high++;
            uint64_t vpeak=(uint64_t)(a*1000000.0);
            if (vpeak>peak) peak=vpeak;
            squares+=(uint64_t)(a*a*1000000000.0);
            samples++;
        }
    }
    __atomic_fetch_add(&DC33TotalFrames,(uint64_t)frames,__ATOMIC_RELAXED);
    __atomic_fetch_add(&DC33TotalSamples,samples,__ATOMIC_RELAXED);
    __atomic_fetch_add(&DC33AboveLow,low,__ATOMIC_RELAXED);
    __atomic_fetch_add(&DC33AboveHigh,high,__ATOMIC_RELAXED);
    __atomic_fetch_add(&DC33SumSquaresNano,squares,__ATOMIC_RELAXED);
    uint64_t observed=__atomic_load_n(&DC33MaxPeakMicro,__ATOMIC_RELAXED);
    while (peak>observed &&
        !__atomic_compare_exchange_n(&DC33MaxPeakMicro,&observed,peak,
            NO,__ATOMIC_RELAXED,__ATOMIC_RELAXED)) {}
}
static NSString *DC33RouteSignature(AVAudioSession *session,BOOL input) {
    NSArray<AVAudioSessionPortDescription *> *ports=input?
        session.currentRoute.inputs:session.currentRoute.outputs;
    NSMutableArray<NSString *> *entries=[NSMutableArray array];
    for (AVAudioSessionPortDescription *port in ports) {
        // Never log raw device UIDs, which can contain user identifiers.
        uint32_t signature=2166136261u;
        const char *uid=port.UID.UTF8String;
        if (uid) for (const unsigned char *p=(const unsigned char*)uid;*p;p++)
            signature=(signature^*p)*16777619u;
        [entries addObject:[NSString stringWithFormat:@"%@:%08x:%lu",
            port.portType?:@"none",signature,(unsigned long)port.channels.count]];
    }
    return entries.count?[entries componentsJoinedByString:@","]:@"none";
}

@interface SCPVoiceSpringSession : NSObject <AVSpeechSynthesizerDelegate>
@property(nonatomic,strong) AVAudioEngine *engine;
@property(nonatomic,strong) SFSpeechRecognizer *recognizer;
@property(nonatomic,strong) SFSpeechAudioBufferRecognitionRequest *request;
@property(nonatomic,strong) SFSpeechRecognitionTask *task;
@property(nonatomic,strong) AVSpeechSynthesizer *speaker;
@property(nonatomic,strong) AVSpeechUtterance *currentUtterance;
@property(nonatomic,copy) NSString *activeRequestID;
@property(nonatomic,assign) BOOL speaking;
@property(nonatomic,copy) NSString *lastAction;
@property(nonatomic,copy) NSString *ttsOldCategory;
@property(nonatomic,copy) NSString *ttsOldMode;
@property(nonatomic,assign) AVAudioSessionCategoryOptions ttsOldOptions;
@property(nonatomic,assign) BOOL ttsOwnsAudio;
@property(nonatomic,copy) NSString *previousCategory;
@property(nonatomic,copy) NSString *previousMode;
@property(nonatomic) AVAudioSessionCategoryOptions previousOptions;
@property(nonatomic) BOOL ownsAudio;
@property(nonatomic) BOOL listening;
@property(nonatomic) NSUInteger generation;
@property(nonatomic,copy) NSString *lastPartial;
@property(nonatomic) CFTimeInterval lastPartialAt;
@property(nonatomic,copy) NSString *waitingAck;
@property(nonatomic,copy) NSString *activeSource;
@property(nonatomic) NSUInteger partialCount;
@property(nonatomic) NSUInteger finalLength;
- (void)energyTickForGeneration:(NSUInteger)generation;
@property(nonatomic,strong) id interruptionObserver;
@property(nonatomic,strong) id routeObserver;
- (void)handle:(NSDictionary *)payload;
- (void)handleAck:(NSDictionary *)payload;
- (void)speakReply:(NSString *)replyKey;
@end

static SCPVoiceSpringSession *DCAgent;
static NSDistributedNotificationCenter *DCNotify(void) {
    return [NSDistributedNotificationCenter defaultCenter];
}
static BOOL DCVoiceEnabled(void) {
    return [OMCPref(@"voiceAssistantEnabled",@NO) boolValue];
}
@implementation SCPVoiceSpringSession
// [hl31-voice-output] On-car voice responses are speech synthesis,
// not a colored microphone icon. Route details are logged without
// storing audio or transcripts.
- (NSString *)textForReply:(NSString *)key {
    NSDictionary *vi=@{
      @"accepted":@"DuoCar đã nhận yêu cầu.",
      @"rejected":@"DuoCar không thực hiện được lệnh này.",
      @"unrecognized":@"Tôi chưa hiểu lệnh. Vui lòng nói lại.",
      @"permission":@"Tiến trình ghi âm chưa có quyền micro và nhận dạng giọng nói.",
      @"offline":@"Nhận dạng offline không khả dụng. Hãy kiểm tra cài đặt DuoCar.",
      @"microphone":@"Không truy cập được microphone.",
      @"no-speech":@"Tôi chưa nghe rõ. Vui lòng thử lại.",
      @"no-input-energy":@"Micro xe chưa đưa tiếng nói vào DuoCar. Hãy kiểm tra tuyến âm thanh.",
      @"interrupted":@"Phiên nghe bị gián đoạn.",
      @"unavailable":@"Giọng nói hiện chưa khả dụng.",
      @"disabled":@"Trợ lý giọng nói đang tắt."
    };
    NSDictionary *en=@{
      @"accepted":@"DuoCar received the command.",
      @"rejected":@"DuoCar could not carry out this command.",
      @"unrecognized":@"I didn't understand. Please try again.",
      @"permission":@"Microphone and speech permissions are unavailable for the audio process.",
      @"offline":@"Offline speech recognition is unavailable. Check DuoCar settings.",
      @"microphone":@"Microphone is unavailable.",
      @"no-speech":@"I didn't hear you. Please try again.",
      @"no-input-energy":@"Car microphone input is silent. Check the input route.",
      @"interrupted":@"Listening was interrupted.",
      @"unavailable":@"Speech is currently unavailable.",
      @"disabled":@"Voice assistant is disabled."
    };
    NSString *language=OMCPref(@"voiceAssistantLanguage",@"vi-VN");
    BOOL english=[language isEqualToString:@"en-US"];
    NSString *result=(english?en:vi)[key?:@""];
    return result.length?result:(english?@"Please try again.":@"Vui lòng thử lại.");
}
- (void)finishSpeaking {
    self.currentUtterance=nil;
    self.speaking=NO;
    if (self.ttsOwnsAudio) {
        self.ttsOwnsAudio=NO;
        AVAudioSession *audio=AVAudioSession.sharedInstance;
        [audio setActive:NO withOptions:
            AVAudioSessionSetActiveOptionNotifyOthersOnDeactivation error:nil];
        if (self.ttsOldCategory.length && self.ttsOldMode.length)
            [audio setCategory:self.ttsOldCategory mode:self.ttsOldMode
                options:self.ttsOldOptions error:nil];
    }
    [self sendState:@"idle" detail:@"reply-completed" reply:@""];
    OMCLogWrite(@"SplitScreen",[NSString stringWithFormat:
         @"[hl31-voice-agent] pid=%d event=tts-finished",getpid()]);
}
- (void)speechSynthesizer:(__unused AVSpeechSynthesizer *)synth
    didFinishSpeechUtterance:(AVSpeechUtterance *)utterance {
    if (utterance==self.currentUtterance) [self finishSpeaking];
}
- (void)speechSynthesizer:(__unused AVSpeechSynthesizer *)synth
    didCancelSpeechUtterance:(AVSpeechUtterance *)utterance {
    if (utterance==self.currentUtterance) [self finishSpeaking];
}
- (void)speakReply:(NSString *)replyKey {
    if (!NSThread.isMainThread) {
        dispatch_async(dispatch_get_main_queue(),^{ [self speakReply:replyKey]; });
        return;
    }
    self.currentUtterance=nil;
    [self.speaker stopSpeakingAtBoundary:AVSpeechBoundaryImmediate];
    self.speaking=NO;
    if (!self.speaker) {
        self.speaker=[AVSpeechSynthesizer new];
        self.speaker.delegate=self;
    }
    AVAudioSession *audio=AVAudioSession.sharedInstance;
    self.ttsOldCategory=audio.category;
    self.ttsOldMode=audio.mode;
    self.ttsOldOptions=audio.categoryOptions;
    NSError *err=nil;
    if (![audio setCategory:AVAudioSessionCategoryPlayback
         mode:AVAudioSessionModeDefault options:
           (AVAudioSessionCategoryOptionDuckOthers|AVAudioSessionCategoryOptionMixWithOthers)
         error:&err] ||
        ![audio setActive:YES error:&err]) {
        OMCLogWrite(@"SplitScreen",[NSString stringWithFormat:
            @"[hl31-voice-agent] pid=%d event=tts-session-failed domain=%@ code=%ld",
            getpid(),err.domain,(long)err.code]);
        if (self.ttsOldCategory.length && self.ttsOldMode.length)
            [audio setCategory:self.ttsOldCategory mode:self.ttsOldMode
                options:self.ttsOldOptions error:nil];
        [self sendState:@"error" detail:@"tts-session-failed" reply:replyKey];
        return;
    }
    self.ttsOwnsAudio=YES;
    NSString *lang=OMCPref(@"voiceAssistantLanguage",@"vi-VN");
    if (![lang isEqualToString:@"en-US"]) lang=@"vi-VN";
    AVSpeechUtterance *utterance=[AVSpeechUtterance
        speechUtteranceWithString:[self textForReply:replyKey]];
    utterance.voice=[AVSpeechSynthesisVoice voiceWithLanguage:lang];
    utterance.rate=AVSpeechUtteranceDefaultSpeechRate;
    self.speaking=YES;
    self.currentUtterance=utterance;
    [self sendState:@"speaking" detail:@"tts-started" reply:replyKey];
    OMCLogWrite(@"SplitScreen",[NSString stringWithFormat:
        @"[hl32-voice] pid=%d event=tts-started output=%@ speechKey=%@ acousticResult=DEVICE-PENDING",
        getpid(),audio.currentRoute.outputs.firstObject.portType?:@"none",replyKey]);
    [self.speaker speakUtterance:utterance];
}

- (void)sendState:(NSString *)state detail:(NSString *)detail reply:(NSString *)reply {
    if (!state) return;
    NSDictionary *packet=@{@"state":state,@"detail":detail?:@"",
                           @"reply":reply?:@"", @"time":@(NSDate.date.timeIntervalSince1970),
                           @"source":@"SpringBoard", @"requestID":self.activeRequestID?:@""};
    [DCNotify() postNotificationName:DCState object:nil userInfo:packet];
    OMCLogWrite(@"SplitScreen",[NSString stringWithFormat:
        @"[hl31-voice-agent] pid=%d event=state state=%@ detail=%@",
        getpid(),state,detail?:@""]);
}
- (void)stopCapture {
    // Capture verdict BEFORE tearing down the active session. Incomplete
    // source/audio format is UNKNOWN, not false "no speech" certainty.
    uint64_t samples=__atomic_load_n(&DC33TotalSamples,__ATOMIC_RELAXED);
    uint64_t peak=__atomic_load_n(&DC33MaxPeakMicro,__ATOMIC_RELAXED);
    uint64_t low=__atomic_load_n(&DC33AboveLow,__ATOMIC_RELAXED);
    uint64_t unsupported=__atomic_load_n(&DC33UnsupportedBuffers,__ATOMIC_RELAXED);
    if (self.listening)
        OMCLogWrite(@"SplitScreen",[NSString stringWithFormat:
            @"[hl33-voice] event=voice-verdict pid=%d buffers=%d "
             "samples=%llu maxPeak=%.6f above1e-4=%llu "
             "unsupported=%llu partial=%lu finalLen=%lu "
             "input=%@ source=raw-tap acoustic=DEVICE-PENDING",
            getpid(),(int)DCBuffers,(unsigned long long)samples,
            (double)peak/1e6,(unsigned long long)low,
            (unsigned long long)unsupported,(unsigned long)self.partialCount,
            (unsigned long)self.finalLength,
            DC33RouteSignature(AVAudioSession.sharedInstance,YES)]);
    ++self.generation;
    self.listening=NO;
    if (self.interruptionObserver) {
        [NSNotificationCenter.defaultCenter removeObserver:self.interruptionObserver];
        self.interruptionObserver=nil;
    }
    if (self.routeObserver) {
        [NSNotificationCenter.defaultCenter removeObserver:self.routeObserver];
        self.routeObserver=nil;
    }
    if (self.engine.isRunning) [self.engine stop];
    if (self.engine) {
        @try {[self.engine.inputNode removeTapOnBus:0];}
        @catch (__unused NSException *e){}
    }
    [self.request endAudio];
    [self.task cancel];
    self.engine=nil;self.request=nil;self.task=nil;self.recognizer=nil;
    self.lastPartial=nil;
    if (self.ownsAudio) {
        self.ownsAudio=NO;
        AVAudioSession *a=AVAudioSession.sharedInstance;
        [a setActive:NO withOptions:AVAudioSessionSetActiveOptionNotifyOthersOnDeactivation error:nil];
        if (self.previousCategory.length && self.previousMode.length)
            [a setCategory:self.previousCategory mode:self.previousMode
                options:self.previousOptions error:nil];
    }
    OMCLogWrite(@"SplitScreen",[NSString stringWithFormat:
        @"[hl31-voice-agent] pid=%d event=capture-stop bufferCount=%d",
        getpid(),(int)DCBuffers]);
}
- (void)fail:(NSString *)detail reply:(NSString *)reply {
    [self stopCapture];
    self.waitingAck=nil;
    [self sendState:@"error" detail:detail reply:reply];
    [self speakReply:reply];
}
- (void)handleAck:(NSDictionary *)payload {
    NSString *rid=payload[@"requestID"], *status=payload[@"status"];
    if (![rid isKindOfClass:NSString.class] || ![rid isEqual:self.waitingAck]) return;
    self.waitingAck=nil;
    BOOL accepted=[status isEqualToString:@"accepted"];
    [self sendState:@"reply" detail:(accepted?@"command-accepted":@"command-rejected")
               reply:(accepted?@"accepted":@"rejected")];
    [self speakReply:(accepted?@"accepted":@"rejected")];
    OMCLogWrite(@"SplitScreen",[NSString stringWithFormat:
         @"[hl31-voice-agent] pid=%d event=owner-ack accepted=%d",
         getpid(),(int)accepted]);
}
- (void)finishRecognized:(NSString *)text {
    if (!self.listening) return;
    NSUInteger sourceLength=text.length;
    self.finalLength=sourceLength;
    [self stopCapture]; // release mic before voice output or split action
    if (sourceLength==0) {
        [self sendState:@"reply" detail:@"no-speech" reply:@"no-speech"];
        [self speakReply:@"no-speech"];
        return;
    }
    NSMutableSet<NSString *> *approved=[NSMutableSet set];
    for (NSString *key in @[@"appBridgeApps",@"splitScreenCarPlayApps"]) {
        id names=OMCPref(key,@[]);
        if (![names isKindOfClass:NSArray.class]) continue;
        for (id item in names)
            if ([item isKindOfClass:NSString.class]) [approved addObject:item];
    }
    NSDictionary *command=DCVoiceParseCommand(text,approved);
    OMCLogWrite(@"SplitScreen",[NSString stringWithFormat:
        @"[hl31-voice-agent] pid=%d event=stt-ready length=%lu parse=%@ (no transcript)",
        getpid(),(unsigned long)sourceLength,command?@"accepted":@"rejected"]);
    if (!command) {
        [self sendState:@"reply" detail:@"parser-rejected" reply:@"unrecognized"];
        [self speakReply:@"unrecognized"];
        return;
    }
    NSString *rid=NSUUID.UUID.UUIDString;
    self.waitingAck=rid;
    [self sendState:@"thinking" detail:@"command-sent" reply:@""];
    NSDictionary *packet=@{@"requestID":rid,@"time":@(NSDate.date.timeIntervalSince1970),
                           @"command":command};
    [DCNotify() postNotificationName:DCAction object:nil userInfo:packet];
    OMCLogWrite(@"SplitScreen",[NSString stringWithFormat:
        @"[hl31-voice-agent] pid=%d event=owner-dispatch action=%@",
        getpid(),command[@"action"]]);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW,(int64_t)(3*NSEC_PER_SEC)),
        dispatch_get_main_queue(), ^{
        if ([self.waitingAck isEqual:rid]) {
            self.waitingAck=nil;
            [self sendState:@"reply" detail:@"owner-ack-timeout" reply:@"unavailable"];
            [self speakReply:@"unavailable"];
        }
    });
}
- (void)energyTickForGeneration:(NSUInteger)generation {
    if (self.generation!=generation || !self.listening) return;
    uint64_t samples=__atomic_load_n(&DC33TotalSamples,__ATOMIC_RELAXED);
    uint64_t low=__atomic_load_n(&DC33AboveLow,__ATOMIC_RELAXED);
    uint64_t high=__atomic_load_n(&DC33AboveHigh,__ATOMIC_RELAXED);
    uint64_t power=__atomic_load_n(&DC33SumSquaresNano,__ATOMIC_RELAXED);
    uint64_t peak=__atomic_load_n(&DC33MaxPeakMicro,__ATOMIC_RELAXED);
    OMCLogWrite(@"SplitScreen",[NSString stringWithFormat:
        @"[hl33-voice] event=voice-energy pid=%d buffers=%d frames=%llu "
         "samples=%llu rms=%.7f peak=%.6f above1e-4=%llu "
         "above1e-3=%llu unsupported=%llu",
        getpid(),(int)DCBuffers,
        (unsigned long long)__atomic_load_n(&DC33TotalFrames,__ATOMIC_RELAXED),
        (unsigned long long)samples,
        samples?sqrt((double)power/(1000000000.0*(double)samples)):0.0,
        (double)peak/1000000.0,(unsigned long long)low,
        (unsigned long long)high,
        (unsigned long long)__atomic_load_n(&DC33UnsupportedBuffers,__ATOMIC_RELAXED)]);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW,(int64_t)(NSEC_PER_SEC)),
        dispatch_get_main_queue(),^{
        [self energyTickForGeneration:generation];
    });
}
- (void)startSession {
    if (self.listening) return;
    if (self.waitingAck.length) {
        [self sendState:@"thinking" detail:@"owner-ack-pending" reply:@""];
        return;
    }
    if (!DCVoiceEnabled()) {
        [self sendState:@"error" detail:@"voice-disabled" reply:@"disabled"];
        [self speakReply:@"disabled"];
        return;
    }
    SFSpeechRecognizerAuthorizationStatus speech=[SFSpeechRecognizer authorizationStatus];
    AVAudioSessionRecordPermission mic=AVAudioSession.sharedInstance.recordPermission;
    OMCLogWrite(@"SplitScreen",[NSString stringWithFormat:
        @"[hl31-voice-agent] pid=%d event=permission owner=SpringBoard speech=%ld mic=%ld",
        getpid(),(long)speech,(long)mic]);
    if (speech!=SFSpeechRecognizerAuthorizationStatusAuthorized ||
        mic!=AVAudioSessionRecordPermissionGranted) {
        OMCLogWrite(@"SplitScreen",
            @"[hl32-voice] event=permission-block owner=SpringBoard action=USER_APPROVAL_REQUIRED noTCCMutation=1");
        [self sendState:@"error" detail:@"springboard-tcc-denied" reply:@"permission"];
        [self speakReply:@"permission"];
        return; // No system-process TCC bypass; not a false listening state.
    }
    NSString *lang=OMCPref(@"voiceAssistantLanguage",@"vi-VN");
    if (![lang isKindOfClass:NSString.class] ||
        !([lang isEqualToString:@"vi-VN"] || [lang isEqualToString:@"en-US"]))
        lang=@"vi-VN";
    self.recognizer=[[SFSpeechRecognizer alloc] initWithLocale:
        [NSLocale localeWithLocaleIdentifier:lang]];
    if (!self.recognizer || !self.recognizer.isAvailable) {
        [self fail:@"recognizer-unavailable" reply:@"unavailable"];return;
    }
    BOOL supportsOffline=self.recognizer.supportsOnDeviceRecognition;
    BOOL allowOnline=[OMCPref(@"voiceAppleOnlineEnabled",@NO) boolValue];
    if (!supportsOffline && !allowOnline) {
        [self fail:@"on-device-not-supported" reply:@"offline"];return;
    }
    AVAudioSession *audio=AVAudioSession.sharedInstance;
    self.previousCategory=audio.category;
    self.previousMode=audio.mode;
    self.previousOptions=audio.categoryOptions;
    NSError *error=nil;
    // Original DuoNavi 1.0.4 ARM64: category PlayAndRecord with options
    // 0x6e, mode Default, preferred sample rate 48000. Do NOT switch
    // input devices or pause media: those need an explicit device test.
    AVAudioSessionCategoryOptions options=
        AVAudioSessionCategoryOptionDuckOthers |
        AVAudioSessionCategoryOptionAllowBluetooth |
        AVAudioSessionCategoryOptionDefaultToSpeaker |
        AVAudioSessionCategoryOptionAllowBluetoothA2DP |
        AVAudioSessionCategoryOptionAllowAirPlay;
    BOOL configured=[audio setCategory:AVAudioSessionCategoryPlayAndRecord
        mode:AVAudioSessionModeDefault options:options error:&error];
    NSError *rateError=nil;
    if (configured && ![audio setPreferredSampleRate:48000 error:&rateError])
        OMCLogWrite(@"SplitScreen",[NSString stringWithFormat:
            @"[hl33-voice] event=sample-rate-warning domain=%@ code=%ld",
            rateError.domain,(long)rateError.code]);
    if (!configured || ![audio setActive:YES error:&error]) {
        OMCLogWrite(@"SplitScreen",[NSString stringWithFormat:
            @"[hl31-voice-agent] event=audio-session-failed domain=%@ code=%ld",
            error.domain,(long)error.code]);
        [self fail:@"audio-session-failed" reply:@"microphone"];return;
    }
    self.ownsAudio=YES;
    self.partialCount=0;self.finalLength=0;
    OMCLogWrite(@"SplitScreen",[NSString stringWithFormat:
        @"[hl33-voice] event=voice-session category=%@ mode=%@ options=%lu "
         "rate=%.0f input=%@ output=%@ otherAudio=%d availableInputs=%lu",
        audio.category,audio.mode,(unsigned long)audio.categoryOptions,
        audio.sampleRate,DC33RouteSignature(audio,YES),
        DC33RouteSignature(audio,NO),(int)audio.isOtherAudioPlaying,
        (unsigned long)audio.availableInputs.count]);
    @try {
        self.engine=[AVAudioEngine new];
        AVAudioInputNode *input=self.engine.inputNode;
        AVAudioFormat *format=[input outputFormatForBus:0];
        OMCLogWrite(@"SplitScreen",[NSString stringWithFormat:
            @"[hl33-voice] event=voice-format hwRate=%.0f channels=%u "
             "common=%ld interleaved=%d sessionRate=%.0f",
            format.sampleRate,(unsigned)format.channelCount,
            (long)format.commonFormat,(int)format.isInterleaved,audio.sampleRate]);
        if (!format || format.sampleRate<=0 || format.channelCount==0) {
            [self fail:@"audio-no-input-format" reply:@"microphone"];return;
        }
        self.request=[SFSpeechAudioBufferRecognitionRequest new];
        self.request.shouldReportPartialResults=YES;
        // Apple online recognition is explicit opt-in in DuoCar UIKit Settings;
        // on-device mode is mandatory otherwise. No third-party API key.
        BOOL localOnly=supportsOffline && !allowOnline;
        self.request.requiresOnDeviceRecognition=localOnly;
        OMCLogWrite(@"SplitScreen",[NSString stringWithFormat:
            @"[hl32-voice] event=recognition-policy locale=%@ onDeviceRequired=%d appleOnlineOptIn=%d",
            lang,(int)localOnly,(int)allowOnline]);
        NSUInteger generation=++self.generation;
        __weak typeof(self) weakSelf=self;
        DCBuffers=0;
        DC33ResetEnergy();
        [input installTapOnBus:0 bufferSize:1024 format:format
            block:^(AVAudioPCMBuffer *buffer,__unused AVAudioTime *when) {
            SCPVoiceSpringSession *owner=weakSelf;
            if (!owner || owner.generation!=generation || !owner.request) return;
            int32_t n=__sync_add_and_fetch(&DCBuffers,1);
            [owner.request appendAudioPCMBuffer:buffer];
            // Raw input tap: count energy in ALL channels, every buffer.
            // No NSLog, allocations, dispatch, or transcript on realtime tap.
            DC33MeasureBuffer(buffer);
            uint64_t low=__atomic_load_n(&DC33AboveLow,__ATOMIC_RELAXED);
            if (low>32 && __sync_bool_compare_and_swap(&DC33SignalSent,0,1)) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (owner.generation==generation && owner.listening)
                        [owner sendState:@"listening"
                            detail:@"input-energy-detected" reply:@""];
                });
            }
        }];
        [self.engine prepare];
        if (![self.engine startAndReturnError:&error]) {
            [self fail:@"audio-engine-failed" reply:@"microphone"];return;
        }
        self.listening=YES;
        NSString *inputRoute=audio.currentRoute.inputs.firstObject.portType?:@"none";
        NSString *outputRoute=audio.currentRoute.outputs.firstObject.portType?:@"none";
        OMCLogWrite(@"SplitScreen",[NSString stringWithFormat:
            @"[hl31-voice-agent] pid=%d event=capture-started routeIn=%@ routeOut=%@ rate=%.0f lang=%@ offline=%d",
            getpid(),inputRoute,outputRoute,format.sampleRate,lang,(int)supportsOffline]);
        // AVAudioEngine.start is NOT microphone proof; a PCM callback is.
        [self sendState:@"requesting" detail:@"awaiting-input-energy" reply:@""];
        [self energyTickForGeneration:generation];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW,(int64_t)(2*NSEC_PER_SEC)),
            dispatch_get_main_queue(), ^{
            if (self.generation==generation && self.listening && DCBuffers==0) {
                OMCLogWrite(@"SplitScreen",[NSString stringWithFormat:
                    @"[hl32-voice] event=no-pcm-frames routeIn=%@ routeOut=%@",
                    inputRoute,outputRoute]);
                [self fail:@"no-pcm-frames" reply:@"microphone"];
            }
        });
        self.task=[self.recognizer recognitionTaskWithRequest:self.request
            resultHandler:^(SFSpeechRecognitionResult *result,NSError *failure) {
            SCPVoiceSpringSession *owner=weakSelf;
            if (!owner || owner.generation!=generation) return;
            NSString *partial=result.bestTranscription.formattedString;
            BOOL final=result.isFinal;
            dispatch_async(dispatch_get_main_queue(), ^{
                SCPVoiceSpringSession *w=weakSelf;
                if (!w || w.generation!=generation || !w.listening) return;
                if (partial.length) {
                    BOOL changed=![w.lastPartial isEqualToString:partial];
                    w.lastPartial=[partial copy];
                    if (changed) {
                        w.partialCount++;
                        CFTimeInterval touched=CFAbsoluteTimeGetCurrent();
                        w.lastPartialAt=touched;
                        OMCLogWrite(@"SplitScreen",[NSString stringWithFormat:
                            @"[hl31-voice-agent] event=stt-partial length=%lu final=%d",
                            (unsigned long)partial.length,(int)final]);
                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW,(int64_t)(1.6*NSEC_PER_SEC)),
                            dispatch_get_main_queue(), ^{
                            if (w.generation==generation && w.listening &&
                                w.lastPartial.length &&
                                w.lastPartialAt==touched)
                                [w finishRecognized:w.lastPartial];
                        });
                    }
                }
                if (final && partial.length) { [w finishRecognized:partial]; return; }
                if (failure) {
                    OMCLogWrite(@"SplitScreen",[NSString stringWithFormat:
                        @"[hl31-voice-agent] event=stt-error domain=%@ code=%ld bufferCount=%d",
                        failure.domain,(long)failure.code,(int)DCBuffers]);
                    if (w.lastPartial.length) [w finishRecognized:w.lastPartial];
                    else [w fail:@"stt-error" reply:@"unavailable"];
                }
            });
        }];
        if (!self.task) { [self fail:@"speech-task-nil" reply:@"unavailable"]; return; }
        __weak typeof(self) agent= self;
        self.interruptionObserver=[NSNotificationCenter.defaultCenter
            addObserverForName:AVAudioSessionInterruptionNotification object:nil
            queue:NSOperationQueue.mainQueue usingBlock:^(NSNotification *note) {
            if ([note.userInfo[AVAudioSessionInterruptionTypeKey] integerValue]
                ==AVAudioSessionInterruptionTypeBegan && agent.listening)
                [agent fail:@"audio-interruption" reply:@"interrupted"];
        }];
        self.routeObserver=[NSNotificationCenter.defaultCenter
            addObserverForName:AVAudioSessionRouteChangeNotification object:nil
            queue:NSOperationQueue.mainQueue usingBlock:^(NSNotification *note) {
            if ([note.userInfo[AVAudioSessionRouteChangeReasonKey] integerValue]
                ==AVAudioSessionRouteChangeReasonOldDeviceUnavailable && agent.listening)
                [agent fail:@"route-unavailable" reply:@"microphone"];
        }];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW,(int64_t)(15*NSEC_PER_SEC)),
            dispatch_get_main_queue(),^{
            if (self.generation==generation && self.listening) {
                if (self.lastPartial.length) [self finishRecognized:self.lastPartial];
                else {
                    uint64_t samples=__atomic_load_n(&DC33TotalSamples,__ATOMIC_RELAXED);
                    uint64_t strong=__atomic_load_n(&DC33AboveLow,__ATOMIC_RELAXED);
                    BOOL silent=samples>0 && strong==0 &&
                        __atomic_load_n(&DC33UnsupportedBuffers,__ATOMIC_RELAXED)==0;
                    [self fail:(silent?@"no-input-energy":@"no-speech-timeout")
                          reply:(silent?@"no-input-energy":@"no-speech")];
                }
            }
        });
    } @catch (NSException *e) {
        OMCLogWrite(@"SplitScreen",[NSString stringWithFormat:
            @"[hl31-voice-agent] event=capture-exception name=%@",e.name]);
        [self fail:@"capture-exception" reply:@"unavailable"];
    }
}
- (void)handle:(NSDictionary *)packet {
    if (![packet isKindOfClass:NSDictionary.class]) return;
    NSString *rid=packet[@"requestID"], *op=packet[@"op"];
    NSNumber *stamp=packet[@"time"];
    if (![rid isKindOfClass:NSString.class] || rid.length!=36 ||
        ![stamp isKindOfClass:NSNumber.class] ||
        !isfinite(stamp.doubleValue) ||
        fabs(NSDate.date.timeIntervalSince1970-stamp.doubleValue)>5.0 ||
        ![op isKindOfClass:NSString.class]) return;
    self.activeRequestID=[rid copy];
    OMCLogWrite(@"SplitScreen",[NSString stringWithFormat:
        @"[hl31-voice-agent] pid=%d event=request op=%@ live=%d",
        getpid(),op,(int)self.listening]);
    if ([op isEqualToString:@"stop"]) {
        self.currentUtterance=nil;
        [self.speaker stopSpeakingAtBoundary:AVSpeechBoundaryImmediate];
        if (self.speaking) [self finishSpeaking];
        [self stopCapture];
        self.waitingAck=nil;
        [self sendState:@"idle" detail:@"user-stopped" reply:@""];
    } else if ([op isEqualToString:@"toggle"]) {
        if (self.speaking) {
            self.currentUtterance=nil;
            [self.speaker stopSpeakingAtBoundary:AVSpeechBoundaryImmediate];
            [self finishSpeaking];
            return;
        }
        if (self.listening) {
            [self stopCapture];
            self.waitingAck=nil;
            [self sendState:@"idle" detail:@"user-toggled-stop" reply:@""];
        } else [self startSession];
    }
}
@end
void SCPVoiceSpringInstall(void) {
    if (![[NSBundle.mainBundle bundleIdentifier] isEqualToString:@"com.apple.springboard"])
        return;
    static dispatch_once_t once;
    dispatch_once(&once,^{
        DCAgent=[SCPVoiceSpringSession new];
        [DCNotify() addObserverForName:DCReq object:nil
          queue:NSOperationQueue.mainQueue usingBlock:^(NSNotification *note) {
            [DCAgent handle:note.userInfo];
        }];
        [DCNotify() addObserverForName:DCAck object:nil
          queue:NSOperationQueue.mainQueue usingBlock:^(NSNotification *note) {
            [DCAgent handleAck:note.userInfo];
        }];
        OMCLogWrite(@"SplitScreen",[NSString stringWithFormat:
            @"[hl31-voice-agent] pid=%d event=observer-ready owner=SpringBoard",
            getpid()]);
    });
}
