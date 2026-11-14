// DuoCar Le 0.2.4 settings owner: runs only inside the existing SpringBoard
// LeExtension injection (mobile UID). Never writes arbitrary paths/keys.
// Uses a bounded Darwin 64-bit request+ack so the sandboxed DuoCar UIKit app
// does not pretend it can directly write Lề's global JSON state directory.
#import <Foundation/Foundation.h>
#import <CoreFoundation/CoreFoundation.h>
#import <notify.h>
#import <math.h>
#import <stdint.h>

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
    @"leTrafficGpsOffsetKph", @"leTrafficFreeDrag", @"moduleOrder"
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
    if(key==27) return raw<=20?@((NSInteger)raw-10):nil;
    if(key==29) return raw<120?@(raw):nil;
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
    if(key==27)return (NSUInteger)MAX(0,MIN(20,[obj integerValue]+10));
    if(key==29)return (NSUInteger)MAX(0,MIN(119,[obj integerValue]));
    return 0;
}
static NSArray *DCLModules(void){return @[@"speed",@"limit",@"source",@"lanes",@"upcoming"];}
// Vendor LePrefs 0.2.4 saves bubble.modules as five {id,enabled}
// dictionaries, never as an array of NSString. Previous DuoCar49 code
// wrote strings and could corrupt the renderer's expected state.
static NSString *DCLModuleID(id item) {
    if([item isKindOfClass:NSString.class])return item;
    if([item isKindOfClass:NSDictionary.class] &&
       [item[@"id"] isKindOfClass:NSString.class])return item[@"id"];
    return nil;
}
static NSNumber *DCLModuleMask(id val) {
    if(![val isKindOfClass:NSArray.class])return @(31);
    NSUInteger mask=0;
    NSArray *all=DCLModules();
    for(id item in (NSArray *)val) {
        NSString *identifier=DCLModuleID(item);
        NSUInteger index=[all indexOfObject:identifier?:@""];
        if(index==NSNotFound)continue;
        BOOL enabled=[item isKindOfClass:NSDictionary.class]
                      ?[item[@"enabled"] boolValue]:YES;
        if(enabled)mask|=1u<<index;
    }
    return @(mask);
}
static NSArray *DCLNormalizedModules(id old) {
    NSArray *known=DCLModules();
    NSMutableArray *out=[NSMutableArray array];
    NSMutableSet *seen=[NSMutableSet set];
    if([old isKindOfClass:NSArray.class])for(id item in (NSArray *)old) {
        NSString *identifier=DCLModuleID(item);
        if(!identifier || [seen containsObject:identifier])continue;
        [seen addObject:identifier];
        if([item isKindOfClass:NSDictionary.class]) {
            NSMutableDictionary *entry=[item mutableCopy];
            if(!entry[@"enabled"])entry[@"enabled"]=@YES;
            [out addObject:entry];
        } else {
            [out addObject:@{@"id":identifier,@"enabled":@YES}];
        }
    }
    for(NSString *identifier in known)if(![seen containsObject:identifier])
        [out addObject:@{@"id":identifier,@"enabled":@YES}];
    return out;
}
static id DCLModuleArray(NSNumber *mask,id original) {
    NSArray *originalEntries=DCLNormalizedModules(original);
    NSMutableArray *out=[NSMutableArray arrayWithCapacity:originalEntries.count];
    NSMutableSet *seen=[NSMutableSet set];
    NSArray *known=DCLModules();
    for(NSDictionary *entry in originalEntries) {
        NSString *identifier=DCLModuleID(entry);
        NSMutableDictionary *copy=[entry mutableCopy];
        NSUInteger index=[known indexOfObject:identifier?:@""];
        if(index!=NSNotFound) {
            copy[@"enabled"]=@((mask.unsignedIntValue>>index)&1u);
            [seen addObject:identifier];
        }
        [out addObject:copy];
    }
    // Vendor requires at least one visible module; reject empty mask.
    return [seen count] && (mask.unsignedIntValue&31u)==0 ? nil :out;
}
static NSInteger DCLModuleOrderRank(id original) {
    NSArray *known=DCLModules();
    NSArray *items=DCLNormalizedModules(original);
    NSMutableArray *remaining=[known mutableCopy];
    NSInteger rank=0,index=0;
    for(id entry in items) {
        NSString *identifier=DCLModuleID(entry);
        NSUInteger found=[remaining indexOfObject:identifier?:@""];
        if(found==NSNotFound)continue;
        NSInteger fact=1;
        for(NSInteger k=2;k<(NSInteger)(5-index);k++)fact*=k;
        rank+=found*fact;[remaining removeObjectAtIndex:found];
        if(++index==5)break;
    }
    return index==5?rank:0;
}
static NSArray *DCLModuleOrderArray(NSInteger rank,id original) {
    NSMutableArray *order=[DCLModules() mutableCopy];
    NSMutableArray *desired=[NSMutableArray arrayWithCapacity:5];
    for(NSInteger left=5;left>=1;left--) {
        NSInteger fact=1;for(NSInteger k=2;k<left;k++)fact*=k;
        NSInteger index=MAX(0,MIN((NSInteger)order.count-1,rank/fact));
        [desired addObject:order[(NSUInteger)index]];
        [order removeObjectAtIndex:(NSUInteger)index];rank%=fact;
    }
    NSArray *source=DCLNormalizedModules(original);
    NSMutableArray *result=[NSMutableArray arrayWithCapacity:source.count];
    for(NSString *identifier in desired)
        for(NSDictionary *entry in source)
            if([DCLModuleID(entry) isEqualToString:identifier])
                [result addObject:entry];
    // Preserve future vendor modules and unknown metadata.
    for(NSDictionary *entry in source)
        if(![desired containsObject:DCLModuleID(entry)])
            [result addObject:entry];
    return result;
}
static BOOL DCLMigrateMalformedVendorModules(void) {
    NSData *old=[NSData dataWithContentsOfFile:DCLHome];
    if(!old)return YES;
    NSDictionary *doc=[NSJSONSerialization JSONObjectWithData:old options:0 error:nil];
    if(![doc isKindOfClass:NSDictionary.class] ||
       ![doc[@"bubble"] isKindOfClass:NSDictionary.class])return YES;
    id oldModules=doc[@"bubble"][@"modules"];
    if(![oldModules isKindOfClass:NSArray.class])return YES;
    BOOL broken=NO;
    for(id value in (NSArray *)oldModules)
        if([value isKindOfClass:NSString.class]){broken=YES;break;}
    if(!broken)return YES;
    NSMutableDictionary *fixedDoc=[doc mutableCopy];
    NSMutableDictionary *fixedBubble=[doc[@"bubble"] mutableCopy];
    fixedBubble[@"modules"]=DCLNormalizedModules(oldModules);
    fixedDoc[@"bubble"]=fixedBubble;
    // Keep a byte-for-byte backup of any known-malformed version.
    NSString *backup=[DCLHome stringByAppendingString:@".duocar49-broken.bak"];
    if(![NSFileManager.defaultManager fileExistsAtPath:backup] &&
       ![old writeToFile:backup options:NSDataWritingAtomic error:nil])return NO;
    NSData *newData=[NSJSONSerialization dataWithJSONObject:fixedDoc
                                          options:0 error:nil];
    if(!newData ||
       ![newData writeToFile:DCLHome options:NSDataWritingAtomic error:nil])
        return NO;
    notify_post("dev.bechou.le.bubble.layout-changed");
    NSLog(@"[le024-config] repaired malformed modules from HL49; backup=%@",backup);
    return YES;
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
    // LePrefs original stores Root/Bubble preferences through its layout
    // store; only the Google Maps card-specific keys (14..26) belong to
    // CFPreferences dev.bechou.le.gmaps. DuoCar49 misrouted 3..7 there.
    BOOL isLayout=(key<=13 || key==29);
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
    if(!write && (![loaded isKindOfClass:NSDictionary.class] || !before.length)) {
        if(error)*error=[NSError errorWithDomain:@"DCLLeCanonical" code:56
                                    userInfo:@{NSLocalizedDescriptionKey:@"Missing canonical Lề JSON"}];
        NSLog(@"[hl56-config-source] canonical READ MISSING key=%lu no VietMap fallback",
              (unsigned long)key);
        return nil;
    }
    NSMutableDictionary *doc=[loaded isKindOfClass:NSDictionary.class]
                                  ?[loaded mutableCopy]:[NSMutableDictionary dictionary];
    NSMutableDictionary *bubble=[doc[@"bubble"] isKindOfClass:NSDictionary.class]
                          ?[doc[@"bubble"] mutableCopy]:[NSMutableDictionary dictionary];
    NSString *keyName=DCLKeys()[key];
    if(key==13 || key==29) keyName=@"modules";
    id oldValue=(key>=8)?bubble[keyName]:doc[keyName];
    if(key==13) oldValue=DCLModuleMask(oldValue);
    if(key==29) oldValue=@(DCLModuleOrderRank(oldValue));
    if(!write) {
        if(oldValue)return oldValue;
        if(key==0)return @"vietmap-live";
        if(key==3)return @"maps-home";
        if(key==4 || key==5)return @YES;
        if(key==7)return @"halo";
        if(key==8)return @"corner";
        if(key==9)return @"asphalt";
        if(key==10)return @0.85;
        if(key==11)return @1.0;
        if(key==12)return @YES;
        return @NO;
    }
    if(key==13) {
        value=DCLModuleArray(value,bubble[@"modules"]);
        if(!value)return nil;
    }
    if(key==29)value=DCLModuleOrderArray([value integerValue],bubble[@"modules"]);
    if(key>=8){bubble[keyName]=value;doc[@"bubble"]=bubble;}
    else doc[keyName]=value;
    if(!doc[@"schemaVersion"])doc[@"schemaVersion"]=@1;
    if(!bubble[@"schemaVersion"])bubble[@"schemaVersion"]=@1;
    NSData *output=[NSJSONSerialization dataWithJSONObject:doc options:0 error:error];
    if(!output || ![output writeToFile:DCLHome options:NSDataWritingAtomic error:error])return nil;
    NSData *after=[NSData dataWithContentsOfFile:DCLHome];
    if(![after isEqualToData:output])return nil;
    return key==13?DCLModuleMask(bubble[@"modules"]):
           (key==29?@(DCLModuleOrderRank(bubble[@"modules"])):value);
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
        // A READ-ONLY cross-process fallback for CarPlayApp, which may not
        // have file access to the mobile-owned vendor JSON. Canonical state
        // remains layout-v1.json; never use this mirror as a second master.
        if(key==4 && [after respondsToSelector:@selector(boolValue)]) {
            CFStringRef domain=(__bridge CFStringRef)DCLDuo;
            CFPreferencesSetAppValue(CFSTR("leBubbleMasterMirror"),
                 (__bridge CFPropertyListRef)after,domain);
            BOOL sync=CFPreferencesAppSynchronize(domain);
            NSLog(@"[hl55-le-master] mirror canonical key4 enabled=%d sync=%d",
                  [after boolValue],sync);
        }
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
        if(!DCLMigrateMalformedVendorModules())
            NSLog(@"[le024-config] repair blocked: preserving original file");
        NSLog(@"[le024-config] bridge start result=%d ack=%d",result,ack);
    });
}
