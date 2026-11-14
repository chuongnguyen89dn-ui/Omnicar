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
    double limit=DCLNow()+((op==DCL_LE_FINISH || op==DCL_LE_READ_END)?1.5:0.4);
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
        usleep(600); // bounded IPC polling: avoid 4KB+ UI stalls
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
    double deadline=DCLNow()+12.0; // vendor JSON up to 16 KiB
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
    BOOL committed=DCLBrokerWrite(data);
    if(!committed)return NO;
    // Keep the app-private mirror used by the authentic LePrefs reader
    // synchronized only AFTER SpringBoard has committed canonical JSON.
    // Original hook trampoline writes this app-owned file, not global.
    BOOL mirrored=DCLVendorWriter?DCLVendorWriter(directory,name,data):NO;
    NSLog(@"[hl56-config-source] vendor save canonical=1 appMirror=%d bytes=%lu",
          mirrored,(unsigned long)[(NSData *)data length]);
    return mirrored;
}
static BOOL DCLVerifiedVendorFile(NSString *path);
// [hl56-config-source] Read canonical mobile-owned layout from SpringBoard.
// Each frame is read-only, owner checked and nonce/sequence/CRC verified.
// NEVER fall back to a private stale Lề file or default VietMap silently.
BOOL DCLLeFetchCanonicalLayout(NSData **result) {
    if(result)*result=nil;
    if(!result)return NO;
    int req=-1,ack=-1,info=-1,word=-1,crcToken=-1;
    BOOL ok=NO;
    __strong NSMutableData *bytes=nil;
    __strong NSDictionary *layout=nil;
    const char *names[]={DCL_LE_RAW_REQ,DCL_LE_RAW_ACK,DCL_LE_RAW_INFO,
                         DCL_LE_RAW_WORD,DCL_LE_RAW_CRC};
    int *tokens[]={&req,&ack,&info,&word,&crcToken};
    for(int i=0;i<5;i++) {
        if(notify_register_check(names[i],tokens[i])!=NOTIFY_STATUS_OK)
            goto finish;
    }
    uint16_t nonce=(uint16_t)(arc4random_uniform(65535)+1);
    uint16_t status=0;
    uint16_t seq=1;
    double deadline=DCLNow()+16.0;
    if(!DCLWaitReply(req,ack,DCL_LE_READ_BEGIN,seq,nonce,nonce,
                     deadline,&status)) {
        NSLog(@"[hl56-config-source] canonical read BEGIN failed status=%u",status);
        goto finish;
    }
    uint64_t infoWord=0;
    if(notify_get_state(info,&infoWord)!=NOTIFY_STATUS_OK ||
       (uint16_t)(infoWord>>16)!=nonce)goto finish;
    NSUInteger length=(uint16_t)infoWord;
    if(length<2 || length>DCL_LE_RAW_LIMIT)goto finish;
    bytes=[NSMutableData dataWithLength:length];
    for(NSUInteger offset=0;offset<length;offset+=4) {
        seq++;
        if(!DCLWaitReply(req,ack,DCL_LE_READ_DATA,seq,nonce,
                 ((uint32_t)nonce<<16)|(uint32_t)(offset/4),
                 deadline,&status)) {
            NSLog(@"[hl56-config-source] canonical read DATA failed at=%lu status=%u",
                  (unsigned long)offset,status);
            goto finish;
        }
        uint64_t packed=0;
        if(notify_get_state(word,&packed)!=NOTIFY_STATUS_OK)goto finish;
        DCLLeUnword((uint32_t)packed,
                    (uint8_t *)bytes.mutableBytes+offset,
                    MIN((NSUInteger)4,length-offset));
    }
    seq++;
    if(!DCLWaitReply(req,ack,DCL_LE_READ_END,seq,nonce,
                     ((uint32_t)nonce<<16),deadline,&status))goto finish;
    uint64_t checksum=0;
    if(notify_get_state(crcToken,&checksum)!=NOTIFY_STATUS_OK ||
       (uint32_t)checksum!=DCLLeCRC32(bytes.bytes,length)){
        NSLog(@"[hl56-config-source] canonical CRC mismatch");
        goto finish;
    }
    layout=[NSJSONSerialization JSONObjectWithData:bytes
                                             options:0 error:nil];
    if(![layout isKindOfClass:NSDictionary.class] || !layout.count)goto finish;
    *result=bytes;ok=YES;
    NSLog(@"[hl56-config-source] canonical fetch OK bytes=%lu source=%@",
          (unsigned long)length,layout[@"source"]);
finish:
    for(int i=0;i<5;i++)if(*tokens[i]>=0)notify_cancel(*tokens[i]);
    if(!ok)NSLog(@"[hl56-config-source] NO CANONICAL DATA: no fallback to stale/default");
    return ok;
}
// Mirror exact canonical file into the app's own LePrefs read domain.
// The vendor Mach-O proves CWReadStoredTrafficBubbleLayout calls
// NSHomeDirectory(), lstat(owner), open and read; this is NOT the global
// /var/mobile file used by CarPlay/SpringBoard.
BOOL DCLLeHydrateAppLayout(NSString *binaryPath, NSData *canonical) {
    if(![canonical isKindOfClass:NSData.class] || canonical.length<2 ||
       canonical.length>DCL_LE_RAW_LIMIT || ![binaryPath isKindOfClass:NSString.class])
        return NO;
    if(!DCLVerifiedVendorFile(binaryPath)) {
        NSLog(@"[hl56-config-source] hydrate refused: vendor SHA mismatch");
        return NO;
    }
    NSString *home=NSHomeDirectory();
    if(!home.length)return NO;
    NSString *dir=[home stringByAppendingPathComponent:
        @"Library/Preferences/dev.bechou.le.bubble"];
    NSString *local=[dir stringByAppendingPathComponent:@"layout-v1.json"];
    NSString *canonicalFile=@"/var/mobile/Library/Preferences/dev.bechou.le.bubble/layout-v1.json";
    if([local isEqualToString:canonicalFile]) {
        NSData *now=[NSData dataWithContentsOfFile:local];
        return [now isEqualToData:canonical];
    }
    void *handle=dlopen(binaryPath.fileSystemRepresentation,RTLD_NOW|RTLD_NOLOAD);
    if(!handle)return NO;
    // After the FIRST page, MSHookFunction is already installed in this
    // process. Use its original trampoline, not dlsym's hooked entry,
    // or re-opening settings would re-submit the same canonical write.
    BOOL (*writer)(id,id,id)=DCLVendorWriter?DCLVendorWriter:
                            (BOOL (*)(id,id,id))dlsym(handle,"CWWriteOwnedStateFile");
    if(!writer)return NO;
    NSFileManager *fm=[NSFileManager defaultManager];
    NSString *backup=[local stringByAppendingString:@".duocar56-prehydration.bak"];
    if([fm fileExistsAtPath:local] && ![fm fileExistsAtPath:backup]){
        NSError *backupError=nil;
        if(![fm copyItemAtPath:local toPath:backup error:&backupError]){
            NSLog(@"[hl56-config-source] preserving older local data failed: %@",
                  backupError);
            return NO;
        }
    }
    BOOL saved=writer(dir,@"layout-v1.json",canonical);
    NSData *readback=saved?[NSData dataWithContentsOfFile:local]:nil;
    BOOL good=saved && [canonical isEqualToData:readback];
    NSLog(@"[hl56-config-source] app mirror hydrate=%d bytes=%lu originalSource=%@",
          good,(unsigned long)canonical.length,
          [[NSJSONSerialization JSONObjectWithData:canonical options:0 error:nil]
             objectForKey:@"source"]);
    return good;
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
