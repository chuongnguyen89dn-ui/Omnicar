#import "DCLLeOriginalStoreServer.h"
#import "DCLLeStoreWire.h"
#import "DCLLeStateWriter.h"
#import <Foundation/Foundation.h>
#import <CoreFoundation/CoreFoundation.h>
#import <notify.h>
#import <stdint.h>
#import <errno.h>
#import <unistd.h>

dispatch_queue_t DCLLeStoreSerialQueue(void) {
    static dispatch_queue_t queue=nil;
    static dispatch_once_t once;
    dispatch_once(&once,^{
        queue=dispatch_queue_create("com.chuong.duocar.le024.store-serial",
                                    DISPATCH_QUEUE_SERIAL);
    });
    return queue;
}
static NSMutableData *DCLPending=nil;
static uint16_t DCLNonce=0,DCLNextSeq=0;
static NSUInteger DCLExpected=0;
// [hl56-canonical-read] Read-only bounded snapshot owned by SpringBoard.
static NSMutableData *DCLReadSnapshot=nil;
static uint16_t DCLReadNonce=0,DCLReadNext=0;
static NSUInteger DCLReadOffset=0;
static NSTimeInterval DCLReadStarted=0;
static int DCLReadInfo=-1,DCLReadWord=-1,DCLReadCRC=-1;
static NSTimeInterval DCLStarted=0;
static const char *const DCLVendorDirectory=
    "/var/mobile/Library/Preferences/dev.bechou.le.bubble";
static void DCLReset(void) {
    DCLPending=nil;DCLNonce=0;DCLNextSeq=0;DCLExpected=0;DCLStarted=0;
}
static void DCLResetRead(void) {
    DCLReadSnapshot=nil;DCLReadNonce=0;DCLReadNext=0;DCLReadOffset=0;
    DCLReadStarted=0;
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
// A complete, exact canonical JSON is transferred 4 bytes at a time;
// the client verifies nonce, sequence, length, JSON and CRC before mirroring
// it into its OWN sandbox. Never return default "vietmap-live" as a read.
static void DCLHandleCanonicalRead(uint8_t op,uint16_t seq,
                                   uint32_t word,int ack) {
    NSTimeInterval now=[NSDate timeIntervalSinceReferenceDate];
    if(DCLReadSnapshot && now-DCLReadStarted>16.0) {
        NSLog(@"[hl56-config-source] read snapshot expired");
        DCLResetRead();
    }
    if(op==DCL_LE_READ_BEGIN) {
        uint16_t nonce=(uint16_t)word;
        uint16_t result=DCL_LE_OK;
        if(DCLPending || DCLReadSnapshot)result=DCL_LE_BUSY;
        else if(seq!=1 || nonce==0 || DCLReadInfo<0 ||
                DCLReadWord<0 || DCLReadCRC<0)result=DCL_LE_SEQUENCE;
        else {
            NSMutableData *data=[NSMutableData dataWithLength:DCL_LE_RAW_LIMIT];
            size_t actual=0;int stage=0,err=0;
            int ok=DCLLeReadState(DCLVendorDirectory,"layout-v1.json",
                                  data.mutableBytes,data.length,&actual,
                                  &stage,&err);
            if(!ok) {
                result=(err==EPERM||err==EACCES)?DCL_LE_OWNER:DCL_LE_IO;
                NSLog(@"[hl56-config-source] canonical READ FAIL stage=%d errno=%d uid=%d",
                      stage,err,geteuid());
            } else {
                [data setLength:actual];
                if(!DCLJSONAccept(data))result=DCL_LE_JSON;
                else {
                    DCLReadSnapshot=data;
                    DCLReadNonce=nonce;DCLReadNext=2;DCLReadOffset=0;
                    DCLReadStarted=now;
                    uint64_t info=((uint64_t)nonce<<16)|(uint16_t)actual;
                    if(notify_set_state(DCLReadInfo,info)!=NOTIFY_STATUS_OK) {
                        result=DCL_LE_IO;DCLResetRead();
                    } else {
                        NSDictionary *json=[NSJSONSerialization JSONObjectWithData:data
                                                        options:0 error:nil];
                        NSLog(@"[hl56-config-source] canonical READ READY bytes=%lu source=%@ uid=%d",
                              (unsigned long)actual,json[@"source"],geteuid());
                    }
                }
            }
        }
        DCLReply(ack,op,seq,nonce,result);return;
    }
    uint16_t nonce=(uint16_t)(word>>16);
    uint16_t result=DCL_LE_OK;
    if(!DCLReadSnapshot || nonce!=DCLReadNonce) {
        DCLReply(ack,op,seq,nonce,DCL_LE_SEQUENCE);return;
    }
    if(op==DCL_LE_READ_DATA) {
        if(seq!=DCLReadNext || (uint16_t)word!=(uint16_t)(DCLReadOffset/4) ||
           DCLReadOffset>=DCLReadSnapshot.length) {
            DCLReply(ack,op,seq,nonce,DCL_LE_SEQUENCE);return;
        }
        NSUInteger remain=DCLReadSnapshot.length-DCLReadOffset;
        size_t count=MIN((NSUInteger)4,remain);
        uint32_t packet=DCLLeWord((const uint8_t *)DCLReadSnapshot.bytes+
                                 DCLReadOffset,count);
        if(notify_set_state(DCLReadWord,packet)!=NOTIFY_STATUS_OK)
            result=DCL_LE_IO;
        else {DCLReadOffset+=count;DCLReadNext++;}
        DCLReply(ack,op,seq,nonce,result);return;
    }
    if(op==DCL_LE_READ_END) {
        if(seq!=DCLReadNext || DCLReadOffset!=DCLReadSnapshot.length)
            result=DCL_LE_SEQUENCE;
        else {
            uint32_t checksum=DCLLeCRC32(DCLReadSnapshot.bytes,DCLReadSnapshot.length);
            if(notify_set_state(DCLReadCRC,checksum)!=NOTIFY_STATUS_OK)
                result=DCL_LE_IO;
            else NSLog(@"[hl56-config-source] canonical READ DELIVERED bytes=%lu CRC32=%08x",
                       (unsigned long)DCLReadSnapshot.length,checksum);
        }
        DCLResetRead();
        DCLReply(ack,op,seq,nonce,result);
        return;
    }
    DCLReply(ack,op,seq,nonce,DCL_LE_SEQUENCE);
}
static void DCLHandleRaw(uint64_t frame,int ack) {
    if(DCLLeMagic(frame)!=DCL_LE_MAGIC_REQ)return;
    uint8_t op=DCLLeOp(frame);
    uint16_t seq=DCLLeSeq(frame);
    uint32_t word=DCLLePayload(frame);
    if(op==DCL_LE_READ_BEGIN || op==DCL_LE_READ_DATA ||
       op==DCL_LE_READ_END) {
        DCLHandleCanonicalRead(op,seq,word,ack);
        return;
    }
    if(DCLPending && [NSDate timeIntervalSinceReferenceDate]-DCLStarted>8.0){
        NSLog(@"[hl54-store-sb] expired transaction bytes=%lu",
              (unsigned long)DCLPending.length);
        DCLReset();
    }
    if(op==DCL_LE_BEGIN) {
        uint16_t length=(uint16_t)(word>>16),incoming=(uint16_t)word;
        uint16_t status=DCL_LE_OK;
        if(DCLPending || DCLReadSnapshot)status=DCL_LE_BUSY;
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
        if(notify_register_check(DCL_LE_RAW_INFO,&DCLReadInfo)!=NOTIFY_STATUS_OK)DCLReadInfo=-1;
        if(notify_register_check(DCL_LE_RAW_WORD,&DCLReadWord)!=NOTIFY_STATUS_OK)DCLReadWord=-1;
        if(notify_register_check(DCL_LE_RAW_CRC,&DCLReadCRC)!=NOTIFY_STATUS_OK)DCLReadCRC=-1;
        int result=notify_register_dispatch(DCL_LE_RAW_REQ,&receive,
            DCLLeStoreSerialQueue(),^(int token){
                uint64_t command=0;
                if(notify_get_state(token,&command)==NOTIFY_STATUS_OK)
                    DCLHandleRaw(command,ack);
            });
        NSLog(@"[hl54-store-sb] registered=%d ack=%d euid=%d pid=%d read=%d/%d/%d",
              result,ack,geteuid(),getpid(),DCLReadInfo,DCLReadWord,DCLReadCRC);
    });
}
