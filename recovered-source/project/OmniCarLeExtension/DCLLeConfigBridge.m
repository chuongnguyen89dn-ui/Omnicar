// HL58: standalone Lề is NOT bundled. Two optional DuoCar settings ONLY.
// Cross-process SpringBoard owner of DuoCar's GPS offset and Lề visibility
// gate, with ACK/readback. Never touch Lề's canonical vendor JSON,
// Waze/VietMap preferences, renderer, position, notification owner or assets.
#import <Foundation/Foundation.h>
#import <CoreFoundation/CoreFoundation.h>
#import <notify.h>
#import <stdint.h>
#import "DCLLeConfigBridge.h"

static NSString *const DCLDomain=@"com.chuong.duocar";
static const char *const DCLReq="com.chuong.duocar/le024.cfg";
static const char *const DCLAck="com.chuong.duocar/le024.ack";
static const char *const DCLVisibility="com.chuong.duocar/le024.visibility";
static dispatch_queue_t DCLBridgeSerialQueue(void) {
    static dispatch_queue_t queue=nil;
    static dispatch_once_t once;
    dispatch_once(&once,^{
        queue=dispatch_queue_create("com.chuong.duocar.external-le.settings",
                                   DISPATCH_QUEUE_SERIAL);
    });
    return queue;
}
static id DCLRead(NSString *key) {
    CFStringRef domain=(__bridge CFStringRef)DCLDomain;
    CFPreferencesAppSynchronize(domain);
    return CFBridgingRelease(CFPreferencesCopyAppValue(
        (__bridge CFStringRef)key,domain));
}
static BOOL DCLWriteAndVerify(NSString *key,NSNumber *value) {
    CFStringRef domain=(__bridge CFStringRef)DCLDomain;
    CFPreferencesSetAppValue((__bridge CFStringRef)key,
                             (__bridge CFPropertyListRef)value,domain);
    if(!CFPreferencesAppSynchronize(domain))return NO;
    id readback=DCLRead(key);
    return [readback isKindOfClass:NSNumber.class] &&
           [readback isEqualToNumber:value];
}
static void DCLHandle(uint64_t frame,int ack) {
    if((frame>>48)!=0x4c45)return;
    NSUInteger seq=(frame>>32)&0xffff;
    NSUInteger packedKey=(frame>>16)&0xffff;
    BOOL read=(packedKey&0x8000)!=0;
    NSUInteger key=packedKey&0x7fff;
    NSUInteger raw=frame&0xffff;
    BOOL ok=NO;
    NSUInteger output=0;
    // 4: DuoCar master visibility gate; 27: +/-10 GPS moving speed.
    // These key IDs are unchanged from DuoCar55/57 for compatibility.
    if(key==4||key==27) {
        NSString *name=key==4?@"leBubbleMasterEnabled":@"leTrafficGpsOffsetKph";
        NSNumber *value=key==4?@((BOOL)(raw?YES:NO)):@((NSInteger)raw-10);
        if(read) {
            id stored=DCLRead(name);
            value=[stored isKindOfClass:NSNumber.class]?stored:
                       (key==4?@YES:@0);
            ok=YES;
        } else if((key==4 && raw<=1)||(key==27 && raw<=20)) {
            ok=DCLWriteAndVerify(name,value);
            if(ok) {
                notify_post("com.chuong.duocar/prefschanged");
                if(key==4)notify_post(DCLVisibility);
            }
        }
        if(ok) {
            output=key==4?([value boolValue]?1:0):
                   (NSUInteger)MAX(0,MIN(20,[value integerValue]+10));
        }
    }
    uint64_t answer=(UINT64_C(0xac49)<<48)|
                    ((uint64_t)seq<<32)|((uint64_t)key<<16)|
                    ((uint64_t)(output&0x3fff))|(ok?0:0x8000);
    if(ack>=0) {
        notify_set_state(ack,answer);
        notify_post(DCLAck);
    }
    NSLog(@"[hl58-external-le-config] %@ key=%lu ok=%d val=%lu",
          read?@"read":@"write",(unsigned long)key,ok,(unsigned long)output);
}
void DCLLeConfigStartBridge(void) {
    if(![NSBundle.mainBundle.bundleIdentifier isEqualToString:
         @"com.apple.springboard"])return;
    static dispatch_once_t once;
    dispatch_once(&once,^{
        // Migrate only DuoCar's existing last successful master choice.
        // Avoid writing/creating/editing the original Lề JSON entirely.
        if(!DCLRead(@"leBubbleMasterEnabled")) {
            id old=DCLRead(@"leBubbleMasterMirror");
            if([old isKindOfClass:NSNumber.class])
                DCLWriteAndVerify(@"leBubbleMasterEnabled",old);
        }
        static int req=-1,ack=-1;
        if(notify_register_check(DCLAck,&ack)!=NOTIFY_STATUS_OK)ack=-1;
        int result=notify_register_dispatch(DCLReq,&req,
                  DCLBridgeSerialQueue(),^(int token){
            uint64_t frame=0;
            if(notify_get_state(token,&frame)==NOTIFY_STATUS_OK)
                DCLHandle(frame,ack);
        });
        NSLog(@"[hl58-external-le-config] bridge=%d ack=%d; vendor separate",
              result,ack);
    });
}
