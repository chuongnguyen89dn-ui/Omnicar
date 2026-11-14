#import "DCLLeOriginalStoreClient.h"
#import "DCLLeStoreWire.h" // local exact mirror; safe after source rebrand
#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonDigest.h>
#import <dlfcn.h>
#import <notify.h>
#import <stdint.h>
#import <unistd.h>
#import <stdlib.h>
#import <stdio.h>
#import <string.h>

static BOOL (*DCLVendorWriter)(id,id,id)=NULL;
static BOOL DCLLeStoreHook(id directory,id name,id data);
static const char *const DCLExpectedLePrefsSHA =
    "a2051747de56b26739dd323efddffd34c23d429c481451648e501a5af15546e7";
static double DCLNow(void){return [NSDate timeIntervalSinceReferenceDate];}
static BOOL DCLWaitReply(int req,int ack,uint8_t op,uint16_t seq,uint16_t nonce,
                         uint32_t payload,double deadline,uint16_t *status) {
    uint64_t command=DCLLeFrame(DCL_LE_MAGIC_REQ,op,seq,payload);
    if(notify_set_state(req,command)!=NOTIFY_STATUS_OK ||
       notify_post(DCL_LE_RAW_REQ)!=NOTIFY_STATUS_OK)return NO;
    double limit=DCLNow()+((op==DCL_LE_FINISH)?1.5:0.4);
    if(limit>deadline)limit=deadline;
    while(DCLNow()<limit) {
        uint64_t frame=0;
        if(notify_get_state(ack,&frame)==NOTIFY_STATUS_OK &&
           DCLLeMagic(frame)==DCL_LE_MAGIC_ACK &&
           DCLLeOp(frame)==op && DCLLeSeq(frame)==seq &&
           (uint16_t)(DCLLePayload(frame)>>16)==nonce) {
            *status=(uint16_t)DCLLePayload(frame);
            return *status==DCL_LE_OK;
        }
        usleep(2000);
    }
    return NO;
}
static BOOL DCLBrokerWrite(NSData *data) {
    NSUInteger len=data.length;
    if(len<2||len>DCL_LE_RAW_LIMIT)return NO;
    int req=-1,ack=-1;
    if(notify_register_check(DCL_LE_RAW_REQ,&req)!=NOTIFY_STATUS_OK ||
       notify_register_check(DCL_LE_RAW_ACK,&ack)!=NOTIFY_STATUS_OK) {
        if(req>=0)notify_cancel(req);
        if(ack>=0)notify_cancel(ack);
        NSLog(@"[hl54-store] BROKER_UNAVAILABLE register");
        return NO;
    }
    const uint8_t *bytes=data.bytes;
    uint16_t nonce=(uint16_t)(arc4random_uniform(65535)+1);
    uint16_t status=0,seq=1;
    double deadline=DCLNow()+8.0;
    uint8_t failedOp=DCL_LE_BEGIN;
    BOOL ok=DCLWaitReply(req,ack,DCL_LE_BEGIN,seq,nonce,
                  ((uint32_t)len<<16)|nonce,deadline,&status);
    BOOL begun=ok;
    for(size_t offset=0;ok&&offset<len;offset+=4) {
        size_t count=MIN((size_t)4,(size_t)len-offset);
        uint32_t word=DCLLeWord(bytes+offset,count);
        seq++;failedOp=DCL_LE_DATA;
        ok=DCLWaitReply(req,ack,DCL_LE_DATA,seq,nonce,word,deadline,&status);
    }
    if(ok) {
        seq++;failedOp=DCL_LE_FINISH;
        ok=DCLWaitReply(req,ack,DCL_LE_FINISH,seq,nonce,
             DCLLeCRC32(bytes,len),deadline,&status);
    }
    if(!ok && begun) {
        // Best-effort cancellation. Never claim a write without FINISH ACK.
        notify_set_state(req,DCLLeFrame(DCL_LE_MAGIC_REQ,DCL_LE_CANCEL,
                                        seq+1,nonce));
        notify_post(DCL_LE_RAW_REQ);
    }
    notify_cancel(req);notify_cancel(ack);
    NSLog(@"[hl54-store] original writer broker result=%d bytes=%lu op=%u seq=%u status=%u",
          ok,(unsigned long)len,failedOp,seq,status);
    return ok;
}
static BOOL DCLLeStoreHook(id directory,id name,id data) {
    if(![directory isKindOfClass:NSString.class] ||
       ![name isKindOfClass:NSString.class] ||
       ![data isKindOfClass:NSData.class])
        return DCLVendorWriter?DCLVendorWriter(directory,name,data):NO;
    NSString *dir=[(NSString *)directory stringByStandardizingPath];
    if(![dir hasSuffix:@"/Library/Preferences/dev.bechou.le.bubble"] ||
       ![(NSString *)name isEqualToString:@"layout-v1.json"])
        return DCLVendorWriter?DCLVendorWriter(directory,name,data):NO;
    NSError *error=nil;
    id json=[NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
    if(![json isKindOfClass:NSDictionary.class] || ![(NSDictionary *)json count]) {
        NSLog(@"[hl54-store] REJECT invalid vendor payload length=%lu",
              (unsigned long)[(NSData *)data length]);
        return NO;
    }
    NSLog(@"[hl54-store] original layout write intercepted bytes=%lu globalDir=%d",
          (unsigned long)[(NSData *)data length],
          [dir isEqualToString:@"/var/mobile/Library/Preferences/dev.bechou.le.bubble"]);
    return DCLBrokerWrite(data);
}
static BOOL DCLVerifiedVendorFile(NSString *path) {
    NSData *binary=[NSData dataWithContentsOfFile:path options:NSDataReadingMappedIfSafe error:nil];
    if(!binary || binary.length==0)return NO;
    unsigned char sha[CC_SHA256_DIGEST_LENGTH];
    CC_SHA256(binary.bytes,(CC_LONG)binary.length,sha);
    char hex[CC_SHA256_DIGEST_LENGTH*2+1];
    for(NSUInteger i=0;i<CC_SHA256_DIGEST_LENGTH;i++)
        snprintf(hex+i*2,3,"%02x",sha[i]);
    hex[CC_SHA256_DIGEST_LENGTH*2]='\0';
    // Known original and text-only patched LePrefs 0.2.4 FAT.
    // Refuse a future/unknown vendor ABI instead of guessing.
    return strcmp(hex,DCLExpectedLePrefsSHA)==0 ||
           strcmp(hex,"f56bbe586853690204bbc2ada5ea6385dacb6bd96b50becd4251a2f93e89f83b")==0;
}
BOOL DCLLeInstallOriginalStoreHook(NSString *binaryPath) {
    static BOOL installed=NO;
    if(installed)return YES;
    if(![binaryPath isKindOfClass:NSString.class] ||
       !DCLVerifiedVendorFile(binaryPath)) {
        NSLog(@"[hl54-store] HOOK_OFF vendor binary integrity mismatch");
        return NO;
    }
    void *handle=dlopen(binaryPath.fileSystemRepresentation,RTLD_NOW|RTLD_NOLOAD);
    if(!handle) {
        NSLog(@"[hl54-store] HOOK_OFF vendor handle not loaded: %s",dlerror());
        return NO;
    }
    void *symbol=dlsym(handle,"CWWriteOwnedStateFile");
    if(!symbol) {
        NSLog(@"[hl54-store] HOOK_OFF vendor export unavailable");
        return NO;
    }
    typedef void (*MSHook)(void *,void *,void **);
    MSHook hook=(MSHook)dlsym(RTLD_DEFAULT,"MSHookFunction");
    if(!hook) {
        const char *paths[]={"/var/jb/usr/lib/libsubstrate.dylib",
                             "/usr/lib/libsubstrate.dylib",
                             "/var/jb/usr/lib/libellekit.dylib",
                             NULL};
        for(int i=0;!hook&&paths[i];i++){
            void *lib=dlopen(paths[i],RTLD_NOW|RTLD_GLOBAL);
            if(lib)hook=(MSHook)dlsym(lib,"MSHookFunction");
        }
    }
    if(!hook) {
        NSLog(@"[hl54-store] HOOK_OFF MSHookFunction unavailable");
        return NO;
    }
    hook(symbol,(void *)&DCLLeStoreHook,(void **)&DCLVendorWriter);
    installed=DCLVendorWriter!=NULL;
    NSLog(@"[hl54-store] original writer hook installed=%d binary-verified=1",installed);
    return installed;
}
