// HL29: DuoNavi 1.0.4 architecture-inspired, first-party voice.
#import "DCVoiceSession.h"
#import "DCVoiceCommand.h"
#import "OMCNativeSettings.h"
#import <Speech/Speech.h>
#import <AVFoundation/AVFoundation.h>
#import <objc/message.h>

static NSString *const DCVoiceActionName = @"com.anlai.omnicar/voice.action";
static NSString *const DCVoiceAckName = @"com.anlai.omnicar/voice.ack";
static BOOL DCVEnabled(void) {
    return [OMCNativePref(@"voiceAssistantEnabled",@NO) boolValue];
}
BOOL DCVoiceIsEnabled(void) { return DCVEnabled(); }

static NSNotificationCenter *DCVoiceDistributed(void) {
    Class cls=NSClassFromString(@"NSDistributedNotificationCenter");
    if (!cls || ![cls respondsToSelector:@selector(defaultCenter)]) return nil;
    return [cls defaultCenter];
}

@interface DCVoiceViewController : UIViewController
@property(nonatomic,strong) UILabel *statusLabel;
@property(nonatomic,strong) UIButton *listenButton;
@property(nonatomic,strong) SFSpeechRecognizer *recognizer;
@property(nonatomic,strong) SFSpeechAudioBufferRecognitionRequest *request;
@property(nonatomic,strong) SFSpeechRecognitionTask *task;
@property(nonatomic,strong) AVAudioEngine *engine;
@property(nonatomic,strong) AVSpeechSynthesizer *speaker;
@property(nonatomic,strong) id ackToken;
@property(nonatomic,copy) NSString *pendingID;
@property(nonatomic,assign) NSUInteger generation;
@property(nonatomic,assign) BOOL listening;
@property(nonatomic,assign) BOOL ownsAudioSession;
@property(nonatomic,copy) NSString *lastPartial;
@property(nonatomic,assign) NSUInteger partialRevision;
@end

@implementation DCVoiceViewController

- (void)display:(NSString *)message {
    if (!NSThread.isMainThread) {
        dispatch_async(dispatch_get_main_queue(), ^{ [self display:message]; });
        return;
    }
    self.statusLabel.text=message;
}

- (void)stopListening {
    ++self.generation; // invalidates stale recognition and timeout callbacks
    self.listening=NO;
    self.lastPartial=nil;
    ++self.partialRevision;
    if (self.engine.isRunning) [self.engine stop];
    if (self.engine) {
        @try { [self.engine.inputNode removeTapOnBus:0]; }
        @catch (__unused NSException *exception) {}
    }
    [self.request endAudio];
    [self.task cancel];
    self.request=nil;
    self.task=nil;
    self.engine=nil;
    if (self.ownsAudioSession) {
        self.ownsAudioSession=NO;
        [[AVAudioSession sharedInstance] setActive:NO
            withOptions:AVAudioSessionSetActiveOptionNotifyOthersOnDeactivation
            error:nil];
    }
    if (self.listenButton) [self.listenButton setTitle:@"Bắt đầu nghe"
        forState:UIControlStateNormal];
}
- (void)voiceInterrupted:(NSNotification *)note {
    [self stopListening];
    [self.speaker stopSpeakingAtBoundary:AVSpeechBoundaryImmediate];
    [self display:@"Phiên nghe bị ngắt bởi hệ thống âm thanh."];
}
- (void)voiceAppBackgrounded:(NSNotification *)note {
    (void)note;
    // App deactivation must never leave a permissioned microphone recording
    // during background/lock transition even before the 12s timeout.
    if (self.listening) {
        [self stopListening];
        [self display:@"Đã dừng nghe do DuoCar chuyển sang nền."];
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"Trợ lý DuoCar";
    NSLog(@"[hl29-voice] event=iphone-voice-ui-ready foreground=%d",
          UIApplication.sharedApplication.applicationState==UIApplicationStateActive);
    self.view.backgroundColor=UIColor.systemBackgroundColor;
    UILabel *instructions=[UILabel new];
    instructions.translatesAutoresizingMaskIntoConstraints=NO;
    instructions.textAlignment=NSTextAlignmentCenter;
    instructions.numberOfLines=0;
    instructions.text=@"Chạm để nói một lệnh điều khiển DuoCar.\nKhông cần tài khoản AI hay API.";
    instructions.font=[UIFont preferredFontForTextStyle:UIFontTextStyleHeadline];
    UILabel *state=[UILabel new];
    state.translatesAutoresizingMaskIntoConstraints=NO;
    state.numberOfLines=0;
    state.textAlignment=NSTextAlignmentCenter;
    state.text=@"Micro chỉ hoạt động khi ứng dụng này mở trên iPhone.";
    self.statusLabel=state;
    UIButton *button=[UIButton buttonWithType:UIButtonTypeSystem];
    button.translatesAutoresizingMaskIntoConstraints=NO;
    [button setTitle:@"Bắt đầu nghe" forState:UIControlStateNormal];
    button.titleLabel.font=[UIFont boldSystemFontOfSize:20];
    button.layer.cornerRadius=16;
    button.backgroundColor=UIColor.secondarySystemGroupedBackgroundColor;
    button.accessibilityLabel=@"Bắt đầu hoặc dừng nghe giọng nói";
    [button addTarget:self action:@selector(toggleListening)
      forControlEvents:UIControlEventTouchUpInside];
    self.listenButton=button;
    UILabel *hint=[UILabel new];
    hint.translatesAutoresizingMaskIntoConstraints=NO;
    hint.numberOfLines=0;
    hint.textAlignment=NSTextAlignmentCenter;
    hint.font=[UIFont preferredFontForTextStyle:UIFontTextStyleFootnote];
    hint.textColor=UIColor.secondaryLabelColor;
    hint.text=@"Ví dụ: Mở YouTube bên trái; Chia 2 ô; Chia 60/40; Đổi chỗ hai ô.\n"
              @"Lệnh được xử lý nội bộ, không lưu bản ghi âm.";
    [self.view addSubview:instructions];
    [self.view addSubview:state];
    [self.view addSubview:button];
    [self.view addSubview:hint];
    UILayoutGuide *safe=self.view.safeAreaLayoutGuide;
    [NSLayoutConstraint activateConstraints:@[
        [instructions.topAnchor constraintEqualToAnchor:safe.topAnchor constant:28],
        [instructions.leadingAnchor constraintEqualToAnchor:safe.leadingAnchor constant:18],
        [instructions.trailingAnchor constraintEqualToAnchor:safe.trailingAnchor constant:-18],
        [button.topAnchor constraintEqualToAnchor:instructions.bottomAnchor constant:24],
        [button.centerXAnchor constraintEqualToAnchor:safe.centerXAnchor],
        [button.widthAnchor constraintEqualToConstant:220],
        [button.heightAnchor constraintEqualToConstant:60],
        [state.topAnchor constraintEqualToAnchor:button.bottomAnchor constant:20],
        [state.leadingAnchor constraintEqualToAnchor:safe.leadingAnchor constant:18],
        [state.trailingAnchor constraintEqualToAnchor:safe.trailingAnchor constant:-18],
        [hint.topAnchor constraintEqualToAnchor:state.bottomAnchor constant:20],
        [hint.leadingAnchor constraintEqualToAnchor:safe.leadingAnchor constant:18],
        [hint.trailingAnchor constraintEqualToAnchor:safe.trailingAnchor constant:-18]
    ]];
    self.speaker=[AVSpeechSynthesizer new];
    __weak typeof(self) weakSelf=self;
    self.ackToken=[DCVoiceDistributed() addObserverForName:DCVoiceAckName
        object:nil queue:NSOperationQueue.mainQueue
        usingBlock:^(NSNotification *note) {
            DCVoiceViewController *owner=weakSelf;
            if (!owner || ![note.userInfo[@"requestID"] isEqual:owner.pendingID]) return;
            NSString *status=note.userInfo[@"status"];
            owner.pendingID=nil;
            if ([status isEqualToString:@"accepted"])
                [owner display:@"DuoCar đã nhận lệnh. Kiểm tra kết quả trên màn hình xe."];
            else
                [owner display:@"CarPlay từ chối hoặc không thể thực hiện lệnh này."];
        }];
    [[NSNotificationCenter defaultCenter] addObserver:self
        selector:@selector(voiceInterrupted:)
        name:AVAudioSessionInterruptionNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
        selector:@selector(voiceAppBackgrounded:)
        name:UIApplicationDidEnterBackgroundNotification object:nil];
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self stopListening];
    [self.speaker stopSpeakingAtBoundary:AVSpeechBoundaryImmediate];
    self.pendingID=nil;
}
- (void)dealloc {
    [self stopListening];
    if (self.ackToken) [DCVoiceDistributed() removeObserver:self.ackToken];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)toggleListening {
    if (self.listening) { [self stopListening]; [self display:@"Đã dừng nghe."]; return; }
    if (!DCVEnabled()) { [self display:@"Bật Trợ lý giọng nói trong Cài đặt DuoCar."]; return; }
    if (UIApplication.sharedApplication.applicationState!=UIApplicationStateActive) {
        [self display:@"Mở DuoCar trên iPhone để sử dụng microphone."];
        return;
    }
    [self.speaker stopSpeakingAtBoundary:AVSpeechBoundaryImmediate];
    [self display:@"Đang xin quyền nhận dạng giọng nói..."];
    __weak typeof(self) weakSelf=self;
    [SFSpeechRecognizer requestAuthorization:^(SFSpeechRecognizerAuthorizationStatus status) {
        dispatch_async(dispatch_get_main_queue(), ^{
            DCVoiceViewController *owner=weakSelf;
            if (!owner || !owner.view.window) return;
            if (status!=SFSpeechRecognizerAuthorizationStatusAuthorized) {
                [owner display:@"Chưa cấp quyền Nhận dạng giọng nói cho DuoCar."];
                return;
            }
            [[AVAudioSession sharedInstance] requestRecordPermission:^(BOOL granted) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    DCVoiceViewController *w=weakSelf;
                    if (!w || !w.view.window) return;
                    if (!granted) {
                        [w display:@"Chưa cấp quyền Micro cho DuoCar."];
                    } else [w startAuthorized];
                });
            }];
        });
    }];
}
- (void)startAuthorized {
    if (self.listening || !DCVEnabled() ||
        UIApplication.sharedApplication.applicationState!=UIApplicationStateActive) return;
    NSString *language=OMCNativePref(@"voiceAssistantLanguage",@"vi-VN");
    if (![language isEqualToString:@"vi-VN"] && ![language isEqualToString:@"en-US"])
        language=@"vi-VN";
    SFSpeechRecognizer *recognizer=[[SFSpeechRecognizer alloc]
        initWithLocale:[NSLocale localeWithLocaleIdentifier:language]];
    self.recognizer=recognizer;
    if (!recognizer || !recognizer.isAvailable) {
        [self display:@"Nhận dạng giọng nói hiện không khả dụng."];
        return;
    }
    BOOL allowAppleOnline=[OMCNativePref(@"voiceAppleOnlineEnabled",@NO) boolValue];
    if (!recognizer.supportsOnDeviceRecognition && !allowAppleOnline) {
        [self display:@"Nhận dạng offline không hỗ trợ ngôn ngữ này trên máy. "
                      "Có thể bật 'Apple Speech trực tuyến' trong Cài đặt nếu đồng ý."];
        return;
    }
    NSError *error=nil;
    AVAudioSession *audio=[AVAudioSession sharedInstance];
    if (![audio setCategory:AVAudioSessionCategoryRecord
        mode:AVAudioSessionModeDefault
        options:AVAudioSessionCategoryOptionMixWithOthers error:&error]) {
        [self display:error.localizedDescription?:@"Không đặt được chế độ micro."];
        return;
    }
    if (![audio setActive:YES error:&error]) {
        [self display:error.localizedDescription?:@"Không kích hoạt được micro."];
        return;
    }
    self.ownsAudioSession=YES;
    AVAudioEngine *engine=[AVAudioEngine new];
    self.engine=engine;
    AVAudioInputNode *input=engine.inputNode;
    AVAudioFormat *format=[input outputFormatForBus:0];
    if (!format || format.sampleRate<=0) {
        [self stopListening]; [self display:@"Không có tín hiệu microphone."];
        return;
    }
    self.request=[SFSpeechAudioBufferRecognitionRequest new];
    // Original DuoNavi Apple Speech reports partials; do not wait for
    // a final result indefinitely while the user is speaking.
    self.request.shouldReportPartialResults=YES;
    if (recognizer.supportsOnDeviceRecognition)
        self.request.requiresOnDeviceRecognition=YES;
    __weak typeof(self) weakSelf=self;
    NSUInteger generation=++self.generation;
    [input installTapOnBus:0 bufferSize:1024 format:format
         block:^(AVAudioPCMBuffer *buffer, __unused AVAudioTime *when) {
        DCVoiceViewController *owner=weakSelf;
        SFSpeechAudioBufferRecognitionRequest *req=owner.request;
        if (owner.generation==generation && req)
            [req appendAudioPCMBuffer:buffer];
    }];
    [engine prepare];
    if (![engine startAndReturnError:&error]) {
        [self stopListening];
        [self display:error.localizedDescription?:@"Không khởi động được microphone."];
        return;
    }
    self.listening=YES;
    [self.listenButton setTitle:@"Dừng nghe" forState:UIControlStateNormal];
    [self display:@"Đang nghe... (tối đa 12 giây)"];
    self.task=[recognizer recognitionTaskWithRequest:self.request
        resultHandler:^(SFSpeechRecognitionResult *result, NSError *failure) {
        DCVoiceViewController *owner=weakSelf;
        if (!owner || generation!=owner.generation) return;
        NSString *text=result.bestTranscription.formattedString;
        BOOL final=result.isFinal;
        dispatch_async(dispatch_get_main_queue(), ^{
            DCVoiceViewController *w=weakSelf;
            if (!w || generation!=w.generation || !w.listening) return;
            if (text.length) {
                if (![w.lastPartial isEqualToString:text]) {
                    w.lastPartial=[text copy];
                    NSUInteger revision=++w.partialRevision;
                    NSLog(@"[hl31-iphone-voice] event=stt-partial len=%lu final=%d",
                        (unsigned long)text.length,(int)final);
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW,
                        (int64_t)(1.6*NSEC_PER_SEC)),dispatch_get_main_queue(),^{
                        if (w.generation==generation && w.listening &&
                            w.partialRevision==revision && w.lastPartial.length) {
                            NSString *phrase=[w.lastPartial copy];
                            [w stopListening];
                            [w handleTranscript:phrase];
                        }
                    });
                }
                if (final) {
                    NSString *phrase=[text copy];
                    [w stopListening];
                    [w handleTranscript:phrase];
                    return;
                }
            }
            if (failure) {
                NSString *best=[w.lastPartial copy];
                NSLog(@"[hl31-iphone-voice] event=stt-error domain=%@ code=%ld best=%d",
                    failure.domain,(long)failure.code,(int)(best.length>0));
                [w stopListening];
                if (best.length) [w handleTranscript:best];
                else [w display:@"Không nhận dạng được. Kiểm tra microphone và thử lại."];
            }
        });
    }];
    if (!self.task) {
        [self stopListening];
        [self display:@"Không tạo được phiên Apple Speech."];
        NSLog(@"[hl31-iphone-voice] event=recognition-task-nil");
        return;
    }
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(12*NSEC_PER_SEC)),
                   dispatch_get_main_queue(), ^{
        DCVoiceViewController *owner=weakSelf;
        if (!owner || owner.generation!=generation || !owner.listening) return;
        NSString *best=[owner.lastPartial copy];
        [owner stopListening];
        if (best.length) [owner handleTranscript:best];
        else [owner display:@"Hết thời gian nghe. Chạm micro để thử lại."];
    });
}
- (void)handleTranscript:(NSString *)phrase {
    if (!self.view.window || !DCVEnabled()) return;
    NSMutableSet<NSString *> *approved=[NSMutableSet set];
    for (NSString *key in @[@"appBridgeApps", @"splitScreenCarPlayApps"]) {
        NSArray *a=OMCNativePref(key,@[]);
        if (![a isKindOfClass:NSArray.class]) continue;
        for (id obj in a) if ([obj isKindOfClass:NSString.class])
            [approved addObject:obj];
    }
    NSDictionary *command=DCVoiceParseCommand(phrase,approved);
    if (!command) {
        [self display:@"Chưa hiểu hoặc lệnh chưa được cho phép. Thử lệnh khác."];
        return;
    }
    // No transcript, recorded audio, API key or general URL in cross-process IPC.
    NSNotificationCenter *center=DCVoiceDistributed();
    if (!center) {
        [self display:@"Không có kênh liên lạc CarPlay."];
        return;
    }
    NSString *rid=NSUUID.UUID.UUIDString;
    self.pendingID=rid;
    NSDictionary *payload=@{
        @"requestID":rid,
        @"time":@([NSDate date].timeIntervalSince1970),
        @"command":command
    };
    [center postNotificationName:DCVoiceActionName object:nil userInfo:payload];
    [self display:@"Đã gửi lệnh. Đang chờ CarPlay xác nhận..."];
    __weak typeof(self) weakSelf=self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW,(int64_t)(3*NSEC_PER_SEC)),
        dispatch_get_main_queue(),^{
            DCVoiceViewController *owner=weakSelf;
            if (owner && [owner.pendingID isEqual:rid]) {
                owner.pendingID=nil;
                [owner display:@"Chưa nhận phản hồi CarPlay. Không xác nhận đã thực hiện."];
            }
        });
}
@end

UIViewController *DCVoiceCreateController(void) {
    return [DCVoiceViewController new];
}

void DCVoiceHandleCarRequest(NSDictionary *payload, UIViewController *root) {
    // CarPlay may request voice, but microphone never starts from a
    // background/locked iPhone or without explicit user action and consent.
    if (!DCVEnabled() || UIApplication.sharedApplication.applicationState!=UIApplicationStateActive ||
        !root || !root.view.window) return;
    UIViewController *top=root;
    while (top.presentedViewController) top=top.presentedViewController;
    // The CarPlay touchscreen request itself is the explicit user action.
    // The app must already be active; permission dialogs remain on iPhone.
    DCVoiceViewController *voice=(DCVoiceViewController *)DCVoiceCreateController();
    if ([top isKindOfClass:UINavigationController.class]) {
        UINavigationController *nav=(UINavigationController *)top;
        [nav pushViewController:voice animated:YES];
        dispatch_async(dispatch_get_main_queue(), ^{ [voice toggleListening]; });
    } else {
        UINavigationController *nav=[[UINavigationController alloc]
            initWithRootViewController:voice];
        [top presentViewController:nav animated:YES
                       completion:^{ [voice toggleListening]; }];
    }
}
