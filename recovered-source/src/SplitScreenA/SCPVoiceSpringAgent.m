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
    BOOL configured=[audio setCategory:AVAudioSessionCategoryPlayAndRecord
        mode:AVAudioSessionModeDefault options:
            (AVAudioSessionCategoryOptionMixWithOthers|AVAudioSessionCategoryOptionAllowBluetooth)
        error:&error];
    if (!configured || ![audio setActive:YES error:&error]) {
        OMCLogWrite(@"SplitScreen",[NSString stringWithFormat:
            @"[hl31-voice-agent] event=audio-session-failed domain=%@ code=%ld",
            error.domain,(long)error.code]);
        [self fail:@"audio-session-failed" reply:@"microphone"];return;
    }
    self.ownsAudio=YES;
    @try {
        self.engine=[AVAudioEngine new];
        AVAudioInputNode *input=self.engine.inputNode;
        AVAudioFormat *format=[input outputFormatForBus:0];
        if (!format || format.sampleRate<=0) {
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
        [input installTapOnBus:0 bufferSize:1024 format:format
            block:^(AVAudioPCMBuffer *buffer,__unused AVAudioTime *when) {
            SCPVoiceSpringSession *owner=weakSelf;
            if (!owner || owner.generation!=generation || !owner.request) return;
            int32_t n=__sync_add_and_fetch(&DCBuffers,1);
            [owner.request appendAudioPCMBuffer:buffer];
            if (n==1 || (n%40)==0) {
                // Input energy telemetry only, never store PCM/transcripts.
                float rms=-1.f;
                if (buffer.format.commonFormat==AVAudioPCMFormatFloat32 &&
                    buffer.floatChannelData && buffer.floatChannelData[0]) {
                    AVAudioFrameCount count=MIN(buffer.frameLength,(AVAudioFrameCount)512);
                    if (count) {
                        double sum=0;
                        const float *samples=buffer.floatChannelData[0];
                        for (AVAudioFrameCount i=0;i<count;i++)
                            sum+=(double)samples[i]*(double)samples[i];
                        rms=(float)sqrt(sum/(double)count);
                    }
                }
                float level=rms;
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (owner.generation!=generation || !owner.listening) return;
                    OMCLogWrite(@"SplitScreen",[NSString stringWithFormat:
                        @"[hl32-voice] pid=%d event=pcm-frames count=%d rms=%.5f source=actual-input",
                        getpid(),(int)n,(double)level]);
                    if (n==1)
                        [owner sendState:@"listening" detail:@"pcm-confirmed" reply:@""];
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
        [self sendState:@"requesting" detail:@"awaiting-first-pcm" reply:@""];
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
                else [self fail:@"no-speech-timeout" reply:@"no-speech"];
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
