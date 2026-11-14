#import "DCLLeOriginalStoreServer.h"
#import "DCLLeStoreWire.h"
#import "DCLLeStateWriter.h"
#import <Foundation/Foundation.h>
#import <CoreFoundation/CoreFoundation.h>
#import <notify.h>
#import <stdint.h>
#import <errno.h>
#import <unistd.h>

static NSMutableData *DCLPending=nil;
static uint16_t DCLNonce=0,DCLNextSeq=0;
static NSUInteger DCLExpected=0;
static NSTimeInterval DCLStarted=0;
static const char *const DCLVendorDirectory=
    "/var/mobile/Library/Preferences/dev.bechou.le.bubble";
static void DCLReset(void) {
    DCLPending=nil;DCLNonce=0;DCLNextSeq=0;DCLExpected=0;DCLStarted=0;
}
static BOOL DCLJSONAccept(NSData *data) {
    if(data.length<2||data.length>DCL_LE_RAW_LIMIT)return NO;
    id json=[NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    if(![json isKindOfClass:NSDictionary.class] ||
       [(NSDictionary *)json count]<1 || [(NSDictionary *)json count]>64)return NO;
    id bubble=((NSDictionary *)json)[@"bubble"];
    if(bubble && ![bubble isKindOfClass:NSDictionary.class])return NO;
    id schema=((NSDictionary *)json)[@"schemaVersion"];
    if(schema && (![schema isKindOfClass:NSNumber.class] ||
                  [schema integerValue]<1 || [schema integerValue]>10))return NO;
    // Preserve vendor's serialized bytes and all its unknown keys verbatim.
    // Never translate this payload through DuoCar's supplemental row mapper.
    return YES;
}
static void DCLReply(int ack,uint8_t op,uint16_t seq,
                     uint16_t nonce,uint16_t status) {
    if(ack<0)return;
    notify_set_state(ack,DCLLeFrame(DCL_LE_MAGIC_ACK,op,seq,
                                    ((uint32_t)nonce<<16)|status));
    notify_post(DCL_LE_RAW_ACK);
}
static void DCLHandleRaw(uint64_t frame,int ack) {
    if(DCLLeMagic(frame)!=DCL_LE_MAGIC_REQ)return;
    uint8_t op=DCLLeOp(frame);
    uint16_t seq=DCLLeSeq(frame);
    uint32_t word=DCLLePayload(frame);
    if(DCLPending && [NSDate timeIntervalSinceReferenceDate]-DCLStarted>8.0){
        NSLog(@"[hl54-store-sb] expired transaction bytes=%lu",
              (unsigned long)DCLPending.length);
        DCLReset();
    }
    if(op==DCL_LE_BEGIN) {
        uint16_t length=(uint16_t)(word>>16),incoming=(uint16_t)word;
        uint16_t status=DCL_LE_OK;
        if(DCLPending)status=DCL_LE_BUSY;
        else if(seq!=1 || incoming==0 || length<2 || length>DCL_LE_RAW_LIMIT)
            status=DCL_LE_SIZE;
        else {
            DCLPending=[NSMutableData dataWithCapacity:length];
            DCLNonce=incoming;DCLNextSeq=2;DCLExpected=length;
            DCLStarted=[NSDate timeIntervalSinceReferenceDate];
            NSLog(@"[hl54-store-sb] begin bytes=%u euid=%d",length,geteuid());
        }
        DCLReply(ack,op,seq,incoming,status);
        return;
    }
    uint16_t nonce=DCLNonce;
    if(op==DCL_LE_CANCEL) {
        if(DCLPending && (uint16_t)word==DCLNonce)DCLReset();
        DCLReply(ack,op,seq,nonce,DCL_LE_OK);return;
    }
    if(!DCLPending || seq!=DCLNextSeq) {
        DCLReply(ack,op,seq,nonce,DCL_LE_SEQUENCE);return;
    }
    if(op==DCL_LE_DATA) {
        NSUInteger remain=DCLExpected-DCLPending.length;
        if(remain==0){DCLReply(ack,op,seq,nonce,DCL_LE_SIZE);DCLReset();return;}
        uint8_t bytes[4];size_t count=MIN((NSUInteger)4,remain);
        DCLLeUnword(word,bytes,count);
        [DCLPending appendBytes:bytes length:count];
        DCLNextSeq++;
        DCLReply(ack,op,seq,nonce,DCL_LE_OK);return;
    }
    if(op!=DCL_LE_FINISH || DCLPending.length!=DCLExpected){
        DCLReply(ack,op,seq,nonce,DCL_LE_SEQUENCE);DCLReset();return;
    }
    uint16_t status=DCL_LE_OK;
    if(DCLLeCRC32(DCLPending.bytes,DCLPending.length)!=word)
        status=DCL_LE_CHECKSUM;
    else if(!DCLJSONAccept(DCLPending))status=DCL_LE_JSON;
    else {
        int stage=0,err=0;
        BOOL saved=DCLLeWriteStateAtomically(DCLVendorDirectory,"layout-v1.json",
                       DCLPending.bytes,DCLPending.length,&stage,&err)!=0;
        if(!saved)status=(err==EPERM||err==EACCES)?DCL_LE_OWNER:DCL_LE_IO;
        NSLog(@"[hl54-store-sb] original layout commit=%d bytes=%lu stage=%d errno=%d",
              saved,(unsigned long)DCLPending.length,stage,err);
        if(saved) {
            // Original LePrefs may update bubbleEnabled in the same layout;
            // synchronize a fallback view for sandboxed CarPlayApp.
            NSDictionary *doc=[NSJSONSerialization JSONObjectWithData:DCLPending
                                            options:0 error:nil];
            id master=[doc isKindOfClass:NSDictionary.class]
                      ?doc[@"bubbleEnabled"]:nil;
            if([master isKindOfClass:NSNumber.class]) {
                CFStringRef domain=CFSTR("com.chuong.duocar");
                CFPreferencesSetAppValue(CFSTR("leBubbleMasterMirror"),
                         (__bridge CFPropertyListRef)master,domain);
                BOOL mirrored=CFPreferencesAppSynchronize(domain);
                NSLog(@"[hl55-le-master] original-vendor mirror=%d synced=%d",
                      [master boolValue],mirrored);
            }
            notify_post("dev.bechou.le.bubble.layout-changed");
            notify_post("com.chuong.duocar/prefschanged");
        }
    }
    DCLReply(ack,op,seq,nonce,status);
    DCLReset();
}
void DCLLeOriginalStoreStart(void) {
    if(![NSBundle.mainBundle.bundleIdentifier isEqualToString:@"com.apple.springboard"])
        return;
    static dispatch_once_t once;
    dispatch_once(&once,^{
        static int receive=-1,ack=-1;
        if(notify_register_check(DCL_LE_RAW_ACK,&ack)!=NOTIFY_STATUS_OK)ack=-1;
        int result=notify_register_dispatch(DCL_LE_RAW_REQ,&receive,
            dispatch_get_main_queue(),^(int token){
                uint64_t command=0;
                if(notify_get_state(token,&command)==NOTIFY_STATUS_OK)
                    DCLHandleRaw(command,ack);
            });
        NSLog(@"[hl54-store-sb] registered=%d ack=%d euid=%d pid=%d",
              result,ack,geteuid(),getpid());
    });
}
