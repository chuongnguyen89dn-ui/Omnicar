// DuoCar Le 0.2.4 settings owner: runs only inside the existing SpringBoard
// LeExtension injection (mobile UID). Never writes arbitrary paths/keys.
// Uses a bounded Darwin 64-bit request+ack so the sandboxed DuoCar UIKit app
// does not pretend it can directly write Lề's global JSON state directory.
#import <Foundation/Foundation.h>
#import <CoreFoundation/CoreFoundation.h>
#import <notify.h>

static const char *DCLReq="com.chuong.duocar/le024.cfg";
static const char *DCLAck="com.chuong.duocar/le024.ack";
static NSString *const DCLHome=@"/var/mobile/Library/Preferences/dev.bechou.le.bubble/layout-v1.json";
static NSString *const DCLVendor=@"dev.bechou.le.gmaps";
static NSString *const DCLDuo=@"com.chuong.duocar";
static NSArray<NSString *> *DCLKeys(void) {
  static NSArray *a;static dispatch_once_t once; dispatch_once(&once,^{a=@[
    @"source", @"wakeSource", @"closeSource", @"presentation",
    @"bubbleEnabled", @"fullEnabled", @"phoneEnabled", @"interfaceStyle",
    @"arrangement", @"background", @"backgroundOpacity", @"scale",
    @"overspeedBlink", @"modules",
    @"mapsFullEnabled", @"mapsDashboardEnabled", @"mapsPhoneEnabled",
    @"fullPosition", @"dashboardPosition", @"phonePosition",
    @"fullScale", @"dashboardScale", @"phoneScale", @"phoneLayout",
    @"overspeed.mode", @"phoneXPercent", @"phoneYPercent",
    @"leTrafficGpsOffsetKph", @"leTrafficFreeDrag"
  ];});return a;
}
static NSArray<NSString *> *DCLChoices(NSUInteger key) {
    switch(key) {
    case 0:return @[@"vietmap-live",@"gofa",@"waze"];
    case 3:return @[@"maps-home",@"maps-only",@"bubble-only",@"except-dashboard"];
    case 7:return @[@"halo",@"classic"];
    case 8:return @[@"corner",@"side",@"strip",@"compact"];
    case 9:return @[@"asphalt",@"paint",@"glass",@"haze",@"bare"];
    case 17:case 18:case 19:
        return @[@"top-left",@"top-right",@"bottom-left",@"bottom-right"];
    case 23:return @[@"auto",@"horizontal",@"vertical"];
    case 24:return @[@"off",@"map",@"carplay"];
    default:return nil;
    }
}
static BOOL DCLIsBool(NSUInteger key) {
    return key==1||key==2||key==4||key==5||key==6||key==12||
           key==14||key==15||key==16||key==28;
}
static BOOL DCLIsScale(NSUInteger key) {return key==11||key==20||key==21||key==22;}
static BOOL DCLIsPercent(NSUInteger key) {return key==10||key==25||key==26;}
static id DCLDecode(NSUInteger key, NSUInteger raw) {
    NSArray *options=DCLChoices(key);
    if(options) return raw<options.count?options[raw]:nil;
    if(DCLIsBool(key)) return @(raw?YES:NO);
    if(DCLIsScale(key)) return raw>=50&&raw<=200?@((double)raw/100.0):nil;
    if(DCLIsPercent(key)) return raw<=100?@((double)raw/100.0):nil;
    if(key==13) return raw<=31?@(raw):nil;
    if(key==27) return raw<=10?@((NSInteger)raw-5):nil;
    return nil;
}
static NSUInteger DCLEncode(NSUInteger key,id obj) {
    NSArray *opts=DCLChoices(key);
    if(opts) {
        NSUInteger i=[opts indexOfObject:obj];return i==NSNotFound?0:i;
    }
    if(DCLIsBool(key))return [obj boolValue]?1:0;
    if(DCLIsScale(key))return (NSUInteger)MAX(50,MIN(200,lround([obj doubleValue]*100)));
    if(DCLIsPercent(key))return (NSUInteger)MAX(0,MIN(100,lround([obj doubleValue]*100)));
    if(key==13)return [obj unsignedIntegerValue]&31;
    if(key==27)return (NSUInteger)MAX(0,MIN(10,[obj integerValue]+5));
    return 0;
}
static NSArray *DCLModules(void){return @[@"speed",@"limit",@"source",@"lanes",@"upcoming"];}
static NSNumber *DCLModuleMask(id val) {
    if(![val isKindOfClass:NSArray.class])return @(31);
    unsigned mask=0;
    NSArray *all=DCLModules();
    for(NSString *item in (NSArray *)val) {
        NSUInteger n=[all indexOfObject:item];
        if(n!=NSNotFound) mask |= (1u<<n);
    }
    return @(mask);
}
static id DCLModuleArray(NSNumber *mask,id old) {
    NSArray *all=DCLModules();
    NSMutableArray *out=[NSMutableArray array];
    if([old isKindOfClass:NSArray.class])for(NSString *item in old) {
        NSUInteger n=[all indexOfObject:item];
        if(n!=NSNotFound && ((mask.unsignedIntValue>>n)&1) && ![out containsObject:item])
            [out addObject:item];
    }
    for(NSUInteger n=0;n<all.count;n++)
        if(((mask.unsignedIntValue>>n)&1) && ![out containsObject:all[n]])
            [out addObject:all[n]];
    return out;
}
static id DCLValue(NSUInteger key,BOOL write,id value,NSError **error) {
    if(key>=DCLKeys().count)return nil;
    if(key==27||key==28) {
        CFStringRef domain=(__bridge CFStringRef)DCLDuo;
        if(write)CFPreferencesSetAppValue((__bridge CFStringRef)DCLKeys()[key],
                                         (__bridge CFPropertyListRef)value,domain);
        BOOL ok=CFPreferencesAppSynchronize(domain);
        if(!ok && write) return nil;
        return CFBridgingRelease(CFPreferencesCopyAppValue(
                 (__bridge CFStringRef)DCLKeys()[key],domain)) ?: (key==27?@0:@YES);
    }
    BOOL isLayout=(key<=2 || (key>=8 && key<=13));
    if(!isLayout) {
        NSString *keyName=DCLKeys()[key];
        if(key>=14 && key<=16) keyName=@[@"fullEnabled",@"dashboardEnabled",@"phoneEnabled"][key-14];
        CFStringRef domain=(__bridge CFStringRef)DCLVendor;
        if(write)CFPreferencesSetAppValue((__bridge CFStringRef)keyName,
                                         (__bridge CFPropertyListRef)value,domain);
        BOOL ok=CFPreferencesAppSynchronize(domain);
        if(!ok && write)return nil;
        return CFBridgingRelease(CFPreferencesCopyAppValue(
                   (__bridge CFStringRef)keyName,domain)) ?: @0;
    }
    NSFileManager *fm=NSFileManager.defaultManager;
    NSString *dir=[DCLHome stringByDeletingLastPathComponent];
    if(write && ![fm createDirectoryAtPath:dir withIntermediateDirectories:YES
                               attributes:nil error:error])return nil;
    NSData *before=[NSData dataWithContentsOfFile:DCLHome];
    NSDictionary *loaded=before?[NSJSONSerialization JSONObjectWithData:before
                                         options:0 error:nil]:nil;
    NSMutableDictionary *doc=[loaded isKindOfClass:NSDictionary.class]
                                  ?[loaded mutableCopy]:[NSMutableDictionary dictionary];
    NSMutableDictionary *bubble=[doc[@"bubble"] isKindOfClass:NSDictionary.class]
                          ?[doc[@"bubble"] mutableCopy]:[NSMutableDictionary dictionary];
    NSString *keyName=DCLKeys()[key];
    if(key==13) keyName=@"modules";
    id oldValue=(key>=8)?bubble[keyName]:doc[keyName];
    if(key==13) oldValue=DCLModuleMask(oldValue);
    if(!write) {
        if(oldValue)return oldValue;
        if(key==0)return @"vietmap-live";
        if(key==8)return @"corner";
        if(key==9)return @"asphalt";
        if(key==10)return @0.85;
        if(key==11)return @1.0;
        if(key==12)return @YES;
        return @NO;
    }
    if(key==13)value=DCLModuleArray(value,bubble[@"modules"]);
    if(key>=8){bubble[keyName]=value;doc[@"bubble"]=bubble;}
    else doc[keyName]=value;
    if(!doc[@"schemaVersion"])doc[@"schemaVersion"]=@1;
    if(!bubble[@"schemaVersion"])bubble[@"schemaVersion"]=@1;
    NSData *output=[NSJSONSerialization dataWithJSONObject:doc options:0 error:error];
    if(!output || ![output writeToFile:DCLHome options:NSDataWritingAtomic error:error])return nil;
    NSData *after=[NSData dataWithContentsOfFile:DCLHome];
    if(![after isEqualToData:output])return nil;
    return key==13?DCLModuleMask(bubble[@"modules"]):value;
}
static void DCLHandle(uint64_t raw,int ackToken) {
    if((raw>>48)!=0x4c45)return;
    NSUInteger seq=(raw>>32)&0xffff;
    NSUInteger requestKey=(raw>>16)&0xffff;
    BOOL query=(requestKey&0x8000)!=0;
    NSUInteger key=requestKey&0x7fff;
    NSUInteger val=raw&0xffff;
    BOOL valid=key<DCLKeys().count;
    id decoded=valid ? DCLDecode(key,val):nil;
    NSError *error=nil;
    id after=valid && (query || decoded)?DCLValue(key,!query,decoded,&error):nil;
    BOOL ok=after!=nil;
    NSUInteger echo=ok?DCLEncode(key,after):0;
    uint64_t response=(UINT64_C(0xac49)<<48)|
                ((uint64_t)seq<<32)|((uint64_t)key<<16)|
                ((uint64_t)(echo&0x3fff))|(ok?0:0x8000);
    if(ackToken>=0) {
        notify_set_state(ackToken,response);
        notify_post(DCLAck);
    }
    if(ok&&!query) {
        notify_post("dev.bechou.le.bubble.layout-changed");
        notify_post("dev.bechou.le.gmaps.bubble-configuration");
        notify_post("dev.bechou.le.gmaps.presentation-options");
        notify_post("com.chuong.duocar/prefschanged");
    }
    NSLog(@"[le024-config] %@ key=%lu seq=%lu success=%d value=%lu error=%@",
        query?@"read":@"write",(unsigned long)key,(unsigned long)seq,ok,
        (unsigned long)echo,error);
}
void DCLLeConfigStartBridge(void) {
    if(![NSBundle.mainBundle.bundleIdentifier isEqualToString:@"com.apple.springboard"])
        return;
    static dispatch_once_t once;
    dispatch_once(&once,^{
        static int receive=-1,ack=-1;
        if(notify_register_check(DCLAck,&ack)!=NOTIFY_STATUS_OK)ack=-1;
        int result=notify_register_dispatch(DCLReq,&receive,dispatch_get_main_queue(),
             ^(int token) {
               uint64_t state=0;
               if(notify_get_state(token,&state)==NOTIFY_STATUS_OK)DCLHandle(state,ack);
             });
        NSLog(@"[le024-config] bridge start result=%d ack=%d",result,ack);
    });
}
