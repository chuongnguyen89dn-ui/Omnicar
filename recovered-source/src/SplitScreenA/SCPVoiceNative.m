// HL30: first-party, opt-in CarPlay microphone bubble.
// Never transplant DuoNavi binary, edit TCC, hook Siri or record silently.
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <Speech/Speech.h>
#import <AVFoundation/AVFoundation.h>
#import <objc/runtime.h>
#import "SCPVoiceNative.h"
#import "SCPCarSplit.h"
#import "SCPVoiceBridge.h"
#import "SCPPrefs.h"
#import "SCPFullscreenController.h"
#import "DCVoiceCommand.h"

static char DCVoiceButtonAssociation;
static NSString *const DCVoiceActionName=@"com.anlai.omnicar/voice.action";
static UIButton *DCVoiceButton(SCPCarSplit *split) {
    return split ? objc_getAssociatedObject(split,&DCVoiceButtonAssociation) : nil;
}
@interface DCVoiceCarSession : NSObject
@property(nonatomic,strong) AVAudioEngine *engine;
@property(nonatomic,strong) SFSpeechRecognizer *recognizer;
@property(nonatomic,strong) SFSpeechAudioBufferRecognitionRequest *request;
@property(nonatomic,strong) SFSpeechRecognitionTask *task;
@property(nonatomic,weak) SCPCarSplit *split;
@property(nonatomic) NSUInteger generation;
@property(nonatomic) BOOL listening;
@property(nonatomic) BOOL audioOwned;
@property(nonatomic,copy) NSString *oldCategory;
@property(nonatomic,copy) NSString *oldMode;
@property(nonatomic) AVAudioSessionCategoryOptions oldOptions;
@property(nonatomic,strong) id interruptionObserver;
@property(nonatomic,strong) id routeObserver;
- (void)toggle:(SCPCarSplit *)split;
- (void)stop;
@end
static DCVoiceCarSession *DCVoiceSession;
static void DCVoicePaint(SCPCarSplit *split, BOOL listening) {
    UIButton *b=DCVoiceButton(split);
    if (!b) return;
    [b setImage:[UIImage systemImageNamed:(listening ? @"waveform" : @"mic.fill")]
         forState:UIControlStateNormal];
    b.accessibilityLabel=listening ? @"Dừng nghe DuoCar" : @"Nói với DuoCar trên CarPlay";
}
@implementation DCVoiceCarSession
- (void)stop {
    ++self.generation;
    self.listening=NO;
    NSNotificationCenter *notices=[NSNotificationCenter defaultCenter];
    if (self.interruptionObserver) {
        [notices removeObserver:self.interruptionObserver];
        self.interruptionObserver=nil;
    }
    if (self.routeObserver) {
        [notices removeObserver:self.routeObserver];
        self.routeObserver=nil;
    }
    if (self.engine.isRunning) [self.engine stop];
    if (self.engine) {
        @try { [self.engine.inputNode removeTapOnBus:0]; }
        @catch (__unused NSException *e) {}
    }
    [self.request endAudio];
    [self.task cancel];
    self.task=nil;self.engine=nil;self.request=nil;self.recognizer=nil;
    if (self.audioOwned) {
        self.audioOwned=NO;
        AVAudioSession *audio=AVAudioSession.sharedInstance;
        [audio setActive:NO withOptions:
            AVAudioSessionSetActiveOptionNotifyOthersOnDeactivation error:nil];
        if (self.oldCategory.length && self.oldMode.length)
            [audio setCategory:self.oldCategory mode:self.oldMode
                 options:self.oldOptions error:nil];
    }
    DCVoicePaint(self.split,NO);
    NSLog(@"[hl30-voice] event=capture-stopped");
}
- (void)toggle:(SCPCarSplit *)split {
    if (self.listening) {
        [self stop]; [split toast:@"Đã dừng nghe."]; return;
    }
    if (!split.active || ![SCPPrefs enabled] ||
        ![OMCPref(@"voiceAssistantEnabled",@NO) boolValue]) return;
    // CarPlayApp is NOT the DuoCar iPhone app. Its mic and Speech TCC
    // permissions must be checked separately. No silent permission grant.
    NSDictionary *info=NSBundle.mainBundle.infoDictionary;
    NSString *microphone=info[@"NSMicrophoneUsageDescription"];
    NSString *speech=info[@"NSSpeechRecognitionUsageDescription"];
    SFSpeechRecognizerAuthorizationStatus s=[SFSpeechRecognizer authorizationStatus];
    AVAudioSessionRecordPermission m=AVAudioSession.sharedInstance.recordPermission;
    if (![microphone isKindOfClass:NSString.class] || !microphone.length ||
        ![speech isKindOfClass:NSString.class] || !speech.length ||
        s!=SFSpeechRecognizerAuthorizationStatusAuthorized ||
        m!=AVAudioSessionRecordPermissionGranted) {
        NSLog(@"[hl30-voice] event=permission-block speech=%ld mic=%ld keys=%d/%d",
              (long)s,(long)m,(int)(microphone.length>0),(int)(speech.length>0));
        [split toast:@"CarPlay chưa được cấp quyền Micro/Speech. Không bắt đầu nghe."];
        return;
    }
    NSString *lang=OMCPref(@"voiceAssistantLanguage",@"vi-VN");
    if (![lang isEqualToString:@"vi-VN"] &&
        ![lang isEqualToString:@"en-US"]) lang=@"vi-VN";
    self.recognizer=[[SFSpeechRecognizer alloc] initWithLocale:
        [NSLocale localeWithLocaleIdentifier:lang]];
    if (!self.recognizer || !self.recognizer.available) {
        self.recognizer=nil; [split toast:@"Không có nhận dạng giọng nói."];
        return;
    }
    BOOL online=[OMCPref(@"voiceAppleOnlineEnabled",@NO) boolValue];
    if (!self.recognizer.supportsOnDeviceRecognition && !online) {
        self.recognizer=nil;
        [split toast:@"Thiết bị chưa hỗ trợ nhận dạng offline; xem Cài đặt."];
        return;
    }
    self.split=split;
    AVAudioSession *audio=AVAudioSession.sharedInstance;
    self.oldCategory=audio.category;
    self.oldMode=audio.mode;
    self.oldOptions=audio.categoryOptions;
    NSError *error=nil;
    if (![audio setCategory:AVAudioSessionCategoryPlayAndRecord
        mode:AVAudioSessionModeDefault options:AVAudioSessionCategoryOptionMixWithOthers
        error:&error]) {
        self.recognizer=nil; [split toast:@"Không đặt được chế độ micro."];
        return;
    }
    if (![audio setActive:YES error:&error]) {
        [audio setCategory:self.oldCategory mode:self.oldMode
             options:self.oldOptions error:nil];
        self.recognizer=nil; [split toast:@"Micro CarPlay không khởi động."];
        return;
    }
    self.audioOwned=YES;
    // Stop on incoming calls/Siri and when CarPlay audio route is lost.
    // One tap, one bounded command; never auto-resume audio capture.
    __weak typeof(self) weakSession=self;
    self.interruptionObserver=[[NSNotificationCenter defaultCenter]
        addObserverForName:AVAudioSessionInterruptionNotification
        object:nil queue:NSOperationQueue.mainQueue
        usingBlock:^(NSNotification *note) {
            DCVoiceCarSession *owner=weakSession;
            if (!owner || !owner.listening) return;
            NSNumber *kind=note.userInfo[AVAudioSessionInterruptionTypeKey];
            if (kind.integerValue!=AVAudioSessionInterruptionTypeBegan) return;
            SCPCarSplit *target=owner.split;
            [owner stop];
            [target toast:@"Phiên giọng nói bị ngắt bởi Siri/cuộc gọi."];
            NSLog(@"[hl30-voice] event=audio-interrupted reason=system");
        }];
    self.routeObserver=[[NSNotificationCenter defaultCenter]
        addObserverForName:AVAudioSessionRouteChangeNotification
        object:nil queue:NSOperationQueue.mainQueue
        usingBlock:^(NSNotification *note) {
            DCVoiceCarSession *owner=weakSession;
            if (!owner || !owner.listening) return;
            NSNumber *kind=note.userInfo[AVAudioSessionRouteChangeReasonKey];
            if (kind.integerValue!=AVAudioSessionRouteChangeReasonOldDeviceUnavailable)
                return;
            SCPCarSplit *target=owner.split;
            [owner stop];
            [target toast:@"Microphone/CarPlay đã ngắt kết nối."];
            NSLog(@"[hl30-voice] event=audio-route-lost");
        }];
    @try {
        self.engine=[AVAudioEngine new];
        AVAudioInputNode *node=self.engine.inputNode;
        AVAudioFormat *fmt=[node outputFormatForBus:0];
        if (!fmt || fmt.sampleRate<=0) {
            [self stop]; [split toast:@"Micro không có tín hiệu."]; return;
        }
        self.request=[SFSpeechAudioBufferRecognitionRequest new];
        self.request.shouldReportPartialResults=NO;
        if (self.recognizer.supportsOnDeviceRecognition)
            self.request.requiresOnDeviceRecognition=YES;
        NSUInteger gen=++self.generation;
        __weak typeof(self) weakSelf=self;
        [node installTapOnBus:0 bufferSize:1024 format:fmt
             block:^(AVAudioPCMBuffer *pcm,__unused AVAudioTime *time) {
            DCVoiceCarSession *current=weakSelf;
            if (current && current.generation==gen && current.request)
                [current.request appendAudioPCMBuffer:pcm];
        }];
        [self.engine prepare];
        if (![self.engine startAndReturnError:&error]) {
            [self stop]; [split toast:@"Không ghi âm được trên CarPlay."]; return;
        }
        self.listening=YES; DCVoicePaint(split,YES);
        NSLog(@"[hl30-voice] event=audio-started route=%@ language=%@ offline=%d",
             audio.currentRoute.inputs.firstObject.portType ?: @"none",
             lang,(int)self.recognizer.supportsOnDeviceRecognition);
        [split toast:@"Đang nghe trên CarPlay (12 giây)..."];
        self.task=[self.recognizer recognitionTaskWithRequest:self.request
            resultHandler:^(SFSpeechRecognitionResult *result,NSError *failure) {
            DCVoiceCarSession *current=weakSelf;
            if (!current || current.generation!=gen) return;
            if (result.isFinal && result.bestTranscription.formattedString.length) {
                NSString *utterance=result.bestTranscription.formattedString;
                dispatch_async(dispatch_get_main_queue(), ^{
                    DCVoiceCarSession *owner=weakSelf;
                    if (!owner || owner.generation!=gen) return;
                    SCPCarSplit *activeSplit=owner.split;
                    [owner stop];
                    if (!activeSplit.active) return;
                    NSMutableSet<NSString *> *allowed=[NSMutableSet set];
                    for (NSString *key in @[@"appBridgeApps",@"splitScreenCarPlayApps"]) {
                        id bundles=OMCPref(key,@[]);
                        if (![bundles isKindOfClass:NSArray.class]) continue;
                        for (id bundle in bundles)
                            if ([bundle isKindOfClass:NSString.class])
                                [allowed addObject:bundle];
                    }
                    NSDictionary *command=DCVoiceParseCommand(utterance,allowed);
                    if (!command) {
                        NSLog(@"[hl30-voice] event=parser-rejected");
                        [activeSplit toast:@"Không hiểu lệnh, hãy thử lại."];
                        return;
                    }
                    BOOL accepted=SCPVoiceDispatchLocalCommand(command);
                    [activeSplit toast:accepted
                        ? @"Đã nhận lệnh, kiểm tra kết quả trên xe."
                        : @"CarPlay từ chối lệnh này."];
                    NSLog(@"[hl30-voice] event=command-dispatch action=%@ accepted=%d device-proven=NO",
                          command[@"action"],(int)accepted);
                });
            } else if (failure) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    DCVoiceCarSession *owner=weakSelf;
                    if (!owner || owner.generation!=gen) return;
                    SCPCarSplit *activeSplit=owner.split;
                    [owner stop];
                    [activeSplit toast:@"Không nhận dạng được, chạm để thử lại."];
                    NSLog(@"[hl30-voice] event=recognition-error code=%ld",
                          (long)failure.code);
                });
            }
        }];
        if (!self.task) {
            [self stop];
            [split toast:@"Apple Speech không tạo được phiên nhận dạng."];
            NSLog(@"[hl30-voice] event=recognition-task-nil");
            return;
        }
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW,12*NSEC_PER_SEC),
            dispatch_get_main_queue(), ^{
            DCVoiceCarSession *owner=weakSelf;
            if (!owner || owner.generation!=gen || !owner.listening) return;
            SCPCarSplit *activeSplit=owner.split;
            [owner stop];
            [activeSplit toast:@"Hết 12 giây nghe."];
        });
    } @catch (NSException *exception) {
        [self stop];
        [split toast:@"Đã dừng micro sau lỗi."];
        NSLog(@"[hl30-voice] event=capture-error exception=%@",exception.name);
    }
}
@end

void SCPVoiceNativeToggle(SCPCarSplit *split) {
    if (!DCVoiceSession) DCVoiceSession=[DCVoiceCarSession new];
    [DCVoiceSession toggle:split];
}
void SCPVoiceBubbleDetach(SCPCarSplit *split) {
    if (DCVoiceSession && DCVoiceSession.listening)
        [DCVoiceSession stop];
    [DCVoiceButton(split) removeFromSuperview];
    if (split) objc_setAssociatedObject(split,&DCVoiceButtonAssociation,nil,
        OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
void SCPVoiceBubbleUpdate(SCPCarSplit *split) {
    if (!NSThread.isMainThread) return;
    if (!split || !split.active || !split.container.superview ||
        ![SCPPrefs enabled] ||
        ![OMCPref(@"voiceAssistantEnabled",@NO) boolValue]) {
        SCPVoiceBubbleDetach(split); return;
    }
    UIButton *button=DCVoiceButton(split);
    if (!button) {
        button=[UIButton buttonWithType:UIButtonTypeSystem];
        button.tintColor=UIColor.whiteColor;
        button.backgroundColor=[UIColor colorWithWhite:0.08 alpha:0.88];
        button.layer.cornerRadius=23;
        button.layer.borderWidth=1;
        button.layer.borderColor=[UIColor colorWithWhite:1 alpha:0.4].CGColor;
        [button addTarget:split action:@selector(dcVoiceRequest:)
            forControlEvents:UIControlEventTouchUpInside];
        objc_setAssociatedObject(split,&DCVoiceButtonAssociation,button,
            OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        DCVoicePaint(split,NO);
        NSLog(@"[hl30-voice] event=bubble-created on=carplay");
    }
    UIView *host=split.container;
    if (button.superview!=host) [host addSubview:button];
    CGRect bounds=host.bounds;
    CGRect frame=CGRectMake(MAX(8,CGRectGetWidth(bounds)-54),
                             MAX(8,CGRectGetHeight(bounds)-62),46,46);
    if (!CGRectEqualToRect(frame,button.frame)) button.frame=frame;
    // Do not intercept the original picker/tray/ratio controls.
    BOOL fullscreen=([[SCPFullscreenController shared] fsCommittedState]
        == SCPFullscreenStateExpanded);
    BOOL popup=split.tray!=nil || split.pickerSheet!=nil ||
        split.ratioMenu!=nil || split.resizing || split.dragGhost!=nil;
    button.hidden=(fullscreen || popup);
    button.userInteractionEnabled=!button.hidden;
    [host bringSubviewToFront:button];
}
