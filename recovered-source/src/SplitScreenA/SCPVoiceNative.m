// HL31: DuoCar bubble is presentation only. A separate, permission-gated
// voice session in SpringBoard handles mic/STT/TTS. This file never records
// from com.apple.CarPlayApp and never copies a DuoNavi runtime component.
// Device success requires BOTH voice states and actual acoustic testing.
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <objc/runtime.h>
#import <objc/message.h>
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
static char DCVoiceWindowAssociation;
static char DCVoiceWindowHitTargetAssociation;
static CFTimeInterval DC33BubbleLastLog=0;
static CGRect DC33BubbleLastBoundary=CGRectNull;
static BOOL DC33BubbleLastVisible=NO;
static UIWindow *DCVoiceWindow(SCPCarSplit *split) {
    return split ? objc_getAssociatedObject(split,&DCVoiceWindowAssociation):nil;
}
// A dedicated CarPlay overlay/window ONLY for the voice bubble.
// The legacy split.container and picker trayWindow are NOT touched.
static UIView *DCHL33VoicePassHit(UIWindow *self, SEL cmd, CGPoint point, UIEvent *event) {
    struct objc_super sup={self,class_getSuperclass(object_getClass(self))};
    UIView *hit=((UIView *(*)(struct objc_super *,SEL,CGPoint,UIEvent *))
        objc_msgSendSuper)(&sup,cmd,point,event);
    UIView *bubble=objc_getAssociatedObject(self,&DCVoiceWindowHitTargetAssociation);
    // UIKit's top window must never eat an unrelated TikTok / Waze /
    // Dock / divider hit. Even a full-size root view is passthrough.
    return (bubble && (hit==bubble ||
        (hit && [hit isDescendantOfView:bubble]))) ? hit : nil;
}
static UIWindow *DCVoiceCreateCarPlayOverlay(UIView *container) {
    UIScreen *screen=container.window.screen;
    if (!screen) return nil;
    id config=nil;
    SEL cfgSel=NSSelectorFromString(@"displayConfiguration");
    if ([screen respondsToSelector:cfgSel])
        config=((id (*)(id,SEL))objc_msgSend)(screen,cfgSel);
    if (!config) {
        SEL displaySel=NSSelectorFromString(@"_display");
        id display=[screen respondsToSelector:displaySel]
            ? ((id (*)(id,SEL))objc_msgSend)(screen,displaySel):nil;
        Class cfgClass=objc_getClass("FBSDisplayConfiguration");
        SEL initSel=NSSelectorFromString(@"initWithCADisplay:isMainDisplay:");
        id newConfig=cfgClass ? [cfgClass alloc]:nil;
        if (display && [newConfig respondsToSelector:initSel])
            config=((id (*)(id,SEL,id,BOOL))objc_msgSend)(newConfig,
                initSel,display,NO);
    }
    Class root=objc_getClass("UIRootSceneWindow");
    SEL initSel=NSSelectorFromString(@"initWithDisplayConfiguration:");
    id instance=root?[root alloc]:nil;
    UIWindow *window=nil;
    if (config && [instance respondsToSelector:initSel])
        window=((id (*)(id,SEL,id))objc_msgSend)(instance,initSel,config);
    if (![window isKindOfClass:UIWindow.class]) {
        OMCLogWrite(@"SplitScreen",
            @"[hl33-bubble-window] event=create-failed reason=no-CarPlay-root-scene-window");
        return nil;
    }
    Class parent=object_getClass(window);
    NSString *name=[NSString stringWithFormat:@"DCHL33Pass_%@",NSStringFromClass(parent)];
    Class subclass=objc_getClass(name.UTF8String);
    if (!subclass) {
        subclass=objc_allocateClassPair(parent,name.UTF8String,0);
        Method base=class_getInstanceMethod(parent,@selector(hitTest:withEvent:));
        if (!subclass || !base ||
            !class_addMethod(subclass,@selector(hitTest:withEvent:),
                (IMP)DCHL33VoicePassHit,method_getTypeEncoding(base))) {
            OMCLogWrite(@"SplitScreen",
                @"[hl33-bubble-window] event=create-failed reason=passthrough-ABI");
            return nil;
        }
        objc_registerClassPair(subclass);
    }
    object_setClass(window,subclass);
    window.windowLevel=UIWindowLevelStatusBar+64.0; // TikTok 1060; picker 1065.
    window.backgroundColor=UIColor.clearColor;
    window.hidden=NO;
    OMCLogWrite(@"SplitScreen",[NSString stringWithFormat:
        @"[hl33-bubble-window] event=window-ready level=%.1f frame=%@ screen=%@ passThrough=1",
        window.windowLevel,NSStringFromCGRect(window.bounds),screen]);
    return window;
}
static CGRect DCVoiceOverlayBoundary(UIView *host, UIWindow *overlay) {
    if (!host.window || !overlay || host.window.screen!=overlay.screen)
        return CGRectNull;
    CGRect inHost=[host convertRect:host.bounds toView:host.window];
    CGRect inOverlay=[overlay convertRect:inHost fromWindow:host.window];
    return CGRectIntersection(inOverlay,overlay.bounds);
}

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
      @"no-input-energy":@"Tuyến microphone CarPlay chưa đưa âm thanh hữu ích vào DuoCar.",
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
    if (!DCVoiceBubble(split) && !DCVoiceWindow(split)) return;
    SCPVoiceBubbleView *bubble=DCVoiceBubble(split);
    UIWindow *voiceWindow=DCVoiceWindow(split);
    bubble.onBubbleTapped=nil;
    bubble.onPositionChanged=nil;
    [bubble removeFromSuperview];
    if (voiceWindow) {
        objc_setAssociatedObject(voiceWindow,&DCVoiceWindowHitTargetAssociation,nil,
            OBJC_ASSOCIATION_ASSIGN);
        voiceWindow.hidden=YES;
        objc_setAssociatedObject(split,&DCVoiceWindowAssociation,nil,
            OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
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
    UIWindow *voiceWindow=DCVoiceWindow(split);
    if (voiceWindow && host.window && voiceWindow.screen!=host.window.screen) {
        // Disconnect/reconnect: old overlay belongs to the old display.
        SCPVoiceBubbleDetach(split);
        voiceWindow=nil;
    }
    if (!voiceWindow) {
        voiceWindow=DCVoiceCreateCarPlayOverlay(host);
        if (!voiceWindow) return;
        objc_setAssociatedObject(split,&DCVoiceWindowAssociation,voiceWindow,
            OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    CGRect boundary=DCVoiceOverlayBoundary(host,voiceWindow);
    if (CGRectIsNull(boundary)||CGRectIsEmpty(boundary)) {
        OMCLogWrite(@"SplitScreen",
            @"[hl33-bubble-window] event=boundary-unavailable no-dashboard-window");
        voiceWindow.hidden=YES;
        return;
    }
    SCPVoiceBubbleView *bubble=DCVoiceBubble(split);
    if (!bubble) {
        bubble=[[SCPVoiceBubbleView alloc] initWithBoundaryBounds:boundary];
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
    if (bubble.superview!=voiceWindow) [voiceWindow addSubview:bubble];
    objc_setAssociatedObject(voiceWindow,&DCVoiceWindowHitTargetAssociation,
        bubble,OBJC_ASSOCIATION_ASSIGN);
    [bubble updateBoundaryBounds:boundary];
    BOOL fullscreen=([[SCPFullscreenController shared] fsCommittedState]
        == SCPFullscreenStateExpanded);
    BOOL popup=(split.tray!=nil || split.pickerSheet!=nil ||
                split.ratioMenu!=nil || split.resizing || split.dragGhost!=nil);
    BOOL visible=!fullscreen && !popup;
    bubble.hidden=!visible;
    bubble.userInteractionEnabled=visible;
    voiceWindow.hidden=!visible;
    if (visible) [voiceWindow bringSubviewToFront:bubble];
    CFTimeInterval now=CACurrentMediaTime();
    if (visible!=DC33BubbleLastVisible ||
        !CGRectEqualToRect(boundary,DC33BubbleLastBoundary) ||
        now-DC33BubbleLastLog>3.0) {
        DC33BubbleLastVisible=visible;
        DC33BubbleLastBoundary=boundary;
        DC33BubbleLastLog=now;
        OMCLogWrite(@"SplitScreen",[NSString stringWithFormat:
            @"[hl33-bubble-window] event=update available=1 visible=%d "
             "level=%.1f window=%@ boundary=%@ bubble=%@ touch=pass-only-bubble",
            (int)visible,voiceWindow.windowLevel,
            NSStringFromCGRect(voiceWindow.bounds),
            NSStringFromCGRect(boundary),NSStringFromCGRect(bubble.frame)]);
    }
}
