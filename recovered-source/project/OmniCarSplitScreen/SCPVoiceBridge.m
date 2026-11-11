// HL29: typed, short-lived voice commands on existing CarPlay split owner.
// No microphone inside SpringBoard/CarPlayApp and no vendor binary transplant.
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "SCPVoiceBridge.h"
#import "SCPIntegrationShims.h"
#import "SCPCarSplit.h"
#import "SCPShared.h"
#import "SCPPrefs.h"
#import <math.h>

static NSString *const DCVoiceActionName=@"com.anlai.omnicar/voice.action";
static NSString *const DCVoiceAckName=@"com.anlai.omnicar/voice.ack";
static NSString *DCVoiceLastID;
static NSTimeInterval DCVoiceLastReceiveAt;

static BOOL DCVoiceAllow(NSDictionary *command, SCPCarSplit *split) {
    NSString *action=command[@"action"];
    if (![action isKindOfClass:NSString.class]) return NO;
    if ([action isEqualToString:@"open"]) {
        NSString *bundle=command[@"identifier"];
        NSNumber *slot=command[@"slot"];
        if (![bundle isKindOfClass:NSString.class] ||
            ![slot isKindOfClass:NSNumber.class] ||
            slot.integerValue < -1 || slot.integerValue > 1) return NO;
        if (![split isCarPlayApp:bundle]) return NO;
        // This is user-selected app catalog, not free-form network or URLs.
        NSArray *enabled=OMCPref(@"appBridgeApps",@[]);
        NSArray *native=OMCPref(@"splitScreenCarPlayApps",@[]);
        return ([enabled isKindOfClass:NSArray.class] &&
                [enabled containsObject:bundle]) ||
               ([native isKindOfClass:NSArray.class] &&
                [native containsObject:bundle]);
    }
    if ([action isEqualToString:@"layout"]) {
        NSNumber *idn=command[@"id"];
        if (![idn isKindOfClass:NSNumber.class]) return NO;
        NSInteger layout=idn.integerValue;
        return layout==2||layout==3||layout==13||layout==31;
    }
    if ([action isEqualToString:@"fav"]) {
        NSNumber *n=command[@"index"];
        return [n isKindOfClass:NSNumber.class] && n.integerValue>=1 && n.integerValue<=3;
    }
    if (!split.active) return NO;
    if ([action isEqualToString:@"swap"]) return split.paneCount>=2;
    if ([action isEqualToString:@"ratio"]) {
        NSNumber *n=command[@"r"];
        return [n isKindOfClass:NSNumber.class] &&
            isfinite(n.doubleValue) && n.doubleValue>=0.2 &&
            n.doubleValue<=0.8 && split.paneCount==2 && ![split mainStack];
    }
    if ([action isEqualToString:@"zoom"]) {
        NSNumber *n=command[@"pane"];
        return [n isKindOfClass:NSNumber.class] &&
            n.integerValue>=1 && n.integerValue<=split.paneCount;
    }
    return NO; // no closing/killing/moving windows or arbitrary action types
}
static void DCVoiceAck(NSString *rid, NSString *status) {
    if (!rid.length) return;
    [[NSDistributedNotificationCenter defaultCenter]
        postNotificationName:DCVoiceAckName object:nil
        userInfo:@{@"requestID":rid,@"status":status}];
}
static void SCPVoiceHandle(NSNotification *note) {
    NSDictionary *packet=note.userInfo;
    if (![packet isKindOfClass:NSDictionary.class]) return;
    NSString *rid=packet[@"requestID"];
    NSNumber *sent=packet[@"time"];
    NSDictionary *command=packet[@"command"];
    if (![rid isKindOfClass:NSString.class] || rid.length!=36 ||
        ![sent isKindOfClass:NSNumber.class] ||
        ![command isKindOfClass:NSDictionary.class]) return;
    NSTimeInterval now=NSDate.date.timeIntervalSince1970;
    if (!isfinite(sent.doubleValue) ||
        fabs(now-sent.doubleValue)>8.0 ||
        now-DCVoiceLastReceiveAt<0.5 ||
        [rid isEqualToString:DCVoiceLastID]) {
        DCVoiceAck(rid, @"rejected");
        return;
    }
    DCVoiceLastID=[rid copy];
    DCVoiceLastReceiveAt=now;
    SCPCarSplit *split=[SCPCarSplit shared];
    if (![SCPPrefs enabled] ||
        ![OMCPref(@"voiceAssistantEnabled",@NO) boolValue] ||
        !DCVoiceAllow(command,split)) {
        DCVoiceAck(rid,@"rejected");
        return;
    }
    NSString *action=command[@"action"];
    @try {
        if ([action isEqualToString:@"open"])
            [split openApp:command[@"identifier"] slot:[command[@"slot"] integerValue]];
        else if ([action isEqualToString:@"layout"])
            [split urlLayout:[command[@"id"] integerValue]];
        else if ([action isEqualToString:@"fav"])
            [split openFavorite:[command[@"index"] integerValue]];
        else if ([action isEqualToString:@"swap"])
            [split urlSwap];
        else if ([action isEqualToString:@"ratio"])
            [split urlRatio:[command[@"r"] doubleValue]];
        else if ([action isEqualToString:@"zoom"])
            [split urlZoomPane:[command[@"pane"] intValue]];
        DCVoiceAck(rid,@"accepted");
        NSLog(@"[hl29-voice] event=command-dispatched action=%@ request=%@ result=accepted-not-device-proven",action,rid);
    } @catch (NSException *exception) {
        DCVoiceAck(rid,@"rejected");
        NSLog(@"[hl29-voice] event=exception action=%@",action);
    }
}
void SCPVoiceInstall(void) {
    // Called only from the existing CarPlayApp guarded constructor, once.
    [[NSDistributedNotificationCenter defaultCenter]
        addObserverForName:DCVoiceActionName object:nil
        queue:NSOperationQueue.mainQueue
        usingBlock:^(NSNotification *note) { SCPVoiceHandle(note); }];
    NSLog(@"[hl29-voice] event=carplay-observer-ready");
}
