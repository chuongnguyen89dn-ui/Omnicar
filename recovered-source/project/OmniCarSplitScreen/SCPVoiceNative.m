// HL31: DuoCar bubble is presentation only. A separate, permission-gated
// voice session in SpringBoard handles mic/STT/TTS. This file never records
// from com.apple.CarPlayApp and never copies a DuoNavi runtime component.
// Device success requires BOTH voice states and actual acoustic testing.
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <objc/runtime.h>
#import "SCPVoiceNative.h"
#import "SCPVoiceBubbleView.h"
#import "SCPCarSplit.h"
#import "SCPShared.h"
#import "SCPPrefs.h"
#import "SCPFullscreenController.h"
#import "SCPIntegrationShims.h"
#import <unistd.h>
#import <math.h>

static NSString *const DCVoiceCaptureRequest=@"com.anlai.omnicar/voice.capture.request";
static char DCVoiceBubbleAssociation;
static NSString *DCRemotePhase=@"idle";
static NSString *DCRemoteRequestID;
static BOOL DCRemoteResponded=NO;
static SCPVoiceBubbleView *DCVoiceBubble(SCPCarSplit *split) {
    return split?objc_getAssociatedObject(split,&DCVoiceBubbleAssociation):nil;
}
static NSString *DCVoiceSummary(NSString *code) {
    NSDictionary *messages=@{
      @"springboard-tcc-denied":@"Tiến trình thu âm chưa có quyền Micro/Speech.",
      @"audio-session-failed":@"Không bật được phiên âm thanh.",
      @"audio-no-input-format":@"Không tìm thấy đầu vào microphone.",
      @"audio-engine-failed":@"Microphone không hoạt động.",
      @"no-pcm-frames":@"Không có dữ liệu âm thanh từ microphone. Kiểm tra quyền và đường âm thanh.",
      @"speech-task-nil":@"Apple Speech chưa tạo được phiên nghe.",
      @"recognizer-unavailable":@"Nhận dạng giọng nói chưa khả dụng.",
      @"on-device-not-supported":@"Ngôn ngữ này chưa hỗ trợ nhận dạng offline.",
      @"no-speech-timeout":@"Không nghe được tiếng nói. Hãy thử lại.",
      @"parser-rejected":@"Chưa hiểu lệnh. Hãy nói lại.",
      @"owner-ack-timeout":@"CarPlay không xác nhận đã nhận lệnh.",
      @"command-rejected":@"Lệnh bị từ chối.",
      @"audio-interruption":@"Phiên nghe bị cuộc gọi hoặc Siri ngắt.",
      @"route-unavailable":@"Microphone/CarPlay đã ngắt kết nối.",
      @"tts-session-failed":@"Không phát được giọng nói trả lời."
    };
    return messages[code]?:@"Giọng nói chưa hoạt động, hãy kiểm tra log.";
}
static void DCVoiceSendRequest(NSString *operation) {
    NSString *rid=NSUUID.UUID.UUIDString;
    DCRemoteRequestID=rid;
    DCRemoteResponded=NO;
    NSDictionary *packet=@{
      @"requestID":rid,
      @"op":operation,
      @"time":@(NSDate.date.timeIntervalSince1970)
    };
    [[NSDistributedNotificationCenter defaultCenter]
        postNotificationName:DCVoiceCaptureRequest object:nil userInfo:packet];
    OMCLogWrite(@"SplitScreen",[NSString stringWithFormat:
        @"[hl31-voice] pid=%d event=bubble-request op=%@ request=%@",
        getpid(),operation,rid]);
}
void SCPVoiceNativeToggle(SCPCarSplit *split) {
    if (!split.active || ![SCPPrefs enabled] ||
        ![OMCPref(@"voiceAssistantEnabled",@NO) boolValue]) {
        [split toast:@"Bật Trợ lý giọng nói trong Cài đặt DuoCar."];
        return;
    }
    BOOL active=([DCRemotePhase isEqualToString:@"listening"] ||
                 [DCRemotePhase isEqualToString:@"thinking"] ||
                 [DCRemotePhase isEqualToString:@"speaking"] ||
                 [DCRemotePhase isEqualToString:@"requesting"]);
    [DCVoiceBubble(split) wakeBubble];
    DCVoiceSendRequest(active?@"stop":@"toggle");
    if (active) {
        DCRemotePhase=@"idle";
        [DCVoiceBubble(split) setVoiceState:SCPVoiceBubbleStateIdle animated:YES];
        return;
    }
    DCRemotePhase=@"requesting";
    [DCVoiceBubble(split) setVoiceState:SCPVoiceBubbleStateThinking animated:YES];
    NSString *rid=[DCRemoteRequestID copy];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW,(int64_t)(4*NSEC_PER_SEC)),
        dispatch_get_main_queue(),^{
        if (![DCRemoteRequestID isEqual:rid] || DCRemoteResponded) return;
        DCRemotePhase=@"error";
        [DCVoiceBubble([SCPCarSplit shared])
            setVoiceState:SCPVoiceBubbleStateError animated:YES];
        [[SCPCarSplit shared] toast:
            @"Không nhận được phản hồi từ tiến trình thu âm."];
        OMCLogWrite(@"SplitScreen",
            @"[hl31-voice] event=agent-timeout owner=SpringBoard response=NONE");
    });
}
void SCPVoiceHandleRemoteState(NSDictionary *packet) {
    if (![packet isKindOfClass:NSDictionary.class] || !NSThread.isMainThread) return;
    NSString *source=packet[@"source"],*rid=packet[@"requestID"],
             *phase=packet[@"state"],*detail=packet[@"detail"];
    NSNumber *time=packet[@"time"];
    if (![source isEqualToString:@"SpringBoard"] ||
        ![rid isKindOfClass:NSString.class] ||
        ![rid isEqualToString:DCRemoteRequestID] ||
        ![phase isKindOfClass:NSString.class] ||
        ![time isKindOfClass:NSNumber.class] ||
        !isfinite(time.doubleValue) ||
        fabs(NSDate.date.timeIntervalSince1970-time.doubleValue)>60) return;
    SCPCarSplit *split=[SCPCarSplit shared];
    if (!split.active) return;
    DCRemoteResponded=YES;
    SCPVoiceBubbleView *bubble=DCVoiceBubble(split);
    if ([phase isEqualToString:@"requesting"]) {
        DCRemotePhase=@"requesting";
        [bubble setVoiceState:SCPVoiceBubbleStateThinking animated:YES];
        [split toast:@"Đang kiểm tra tín hiệu microphone..."];
    } else if ([phase isEqualToString:@"listening"]) {
        DCRemotePhase=@"listening";
        [bubble setVoiceState:SCPVoiceBubbleStateListening animated:YES];
        [split toast:@"Đã nhận tín hiệu microphone. Hãy nói lệnh DuoCar."];
    } else if ([phase isEqualToString:@"thinking"] ||
               [phase isEqualToString:@"reply"]) {
        DCRemotePhase=@"thinking";
        [bubble setVoiceState:SCPVoiceBubbleStateThinking animated:YES];
        if ([phase isEqualToString:@"reply"] &&
            [detail isEqualToString:@"command-accepted"])
            [split toast:@"CarPlay đã nhận yêu cầu."];
    } else if ([phase isEqualToString:@"speaking"]) {
        DCRemotePhase=@"speaking";
        [bubble setVoiceState:SCPVoiceBubbleStateSpeaking animated:YES];
    } else if ([phase isEqualToString:@"error"]) {
        DCRemotePhase=@"error";
        [bubble setVoiceState:SCPVoiceBubbleStateError animated:YES];
        [split toast:DCVoiceSummary(detail)];
    } else if ([phase isEqualToString:@"idle"]) {
        DCRemotePhase=@"idle";
        [bubble setVoiceState:SCPVoiceBubbleStateIdle animated:YES];
    } else return;
    OMCLogWrite(@"SplitScreen",[NSString stringWithFormat:
        @"[hl31-voice] pid=%d event=agent-state state=%@ detail=%@ source=SpringBoard",
        getpid(),phase,detail?:@""]);
}
void SCPVoiceBubbleDetach(SCPCarSplit *split) {
    if (![DCRemotePhase isEqualToString:@"idle"] &&
        ![DCRemotePhase isEqualToString:@"error"]) {
        DCVoiceSendRequest(@"stop");
    }
    DCRemotePhase=@"idle";
    SCPVoiceBubbleView *bubble=DCVoiceBubble(split);
    bubble.onBubbleTapped=nil;
    bubble.onPositionChanged=nil;
    [bubble removeFromSuperview];
    if (split) objc_setAssociatedObject(split,&DCVoiceBubbleAssociation,nil,
        OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    OMCLogWrite(@"SplitScreen",
        @"[hl31-voice] event=bubble-detach agent-stop-requested");
}
void SCPVoiceBubbleUpdate(SCPCarSplit *split) {
    if (!NSThread.isMainThread) return;
    if (!split || !split.active || !split.container.superview ||
        ![SCPPrefs enabled] ||
        ![OMCPref(@"voiceAssistantEnabled",@NO) boolValue]) {
        SCPVoiceBubbleDetach(split);
        return;
    }
    UIView *host=split.container;
    SCPVoiceBubbleView *bubble=DCVoiceBubble(split);
    if (!bubble) {
        bubble=[[SCPVoiceBubbleView alloc] initWithBoundaryBounds:host.bounds];
        __weak SCPCarSplit *weakSplit=split;
        bubble.onBubbleTapped=^{
            SCPCarSplit *owner=weakSplit;
            if (!owner || !owner.active) return;
            OMCLogWrite(@"SplitScreen",
                @"[hl31-voice] event=carplay-bubble-hit owner=existing-split");
            SCPVoiceNativeToggle(owner);
        };
        bubble.onPositionChanged=^(BOOL left,CGFloat y) {
            OMCLogWrite(@"SplitScreen",[NSString stringWithFormat:
                @"[hl31-voice] event=bubble-position edge=%@ y=%.3f",
                left?@"left":@"right",y]);
        };
        objc_setAssociatedObject(split,&DCVoiceBubbleAssociation,bubble,
            OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        OMCLogWrite(@"SplitScreen",
            @"[hl31-bubble] event=created mode=stateful-pan-tap-edge-snap-idle");
    }
    if (bubble.superview!=host) [host addSubview:bubble];
    [bubble updateBoundaryBounds:host.bounds];
    BOOL fullscreen=([[SCPFullscreenController shared] fsCommittedState]
        == SCPFullscreenStateExpanded);
    BOOL popup=(split.tray!=nil || split.pickerSheet!=nil ||
                split.ratioMenu!=nil || split.resizing || split.dragGhost!=nil);
    bubble.hidden=(fullscreen || popup);
    bubble.userInteractionEnabled=!bubble.hidden;
    if (!bubble.hidden) [host bringSubviewToFront:bubble];
}
