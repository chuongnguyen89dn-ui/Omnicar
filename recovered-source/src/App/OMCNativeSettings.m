// HL26: UIKit-owned iPhone settings. Do not instantiate Settings.app Preferences controllers.
// All values use the same domain/key/notify contract as OmniCarPrefs and the CarPlay owner.
#import "OMCNativeSettings.h"
#import "OMCLePrefsHost.h" // [le024] actual vendor UI, no disconnected mirror
#import "OMCDeviceVitalsController.h" // [duocar-vitals] standalone detail page
#import <CoreFoundation/CoreFoundation.h>
#import <objc/message.h>
#import <objc/runtime.h>
#import <dlfcn.h>
#import <AVFoundation/AVFoundation.h>
#import <UniformTypeIdentifiers/UniformTypeIdentifiers.h>
#import <notify.h>
#import <math.h>

static NSString *const kOMCNativeDomain=@"com.anlai.omnicar";
static const char *kOMCNativeChanged="com.anlai.omnicar/prefschanged";

id OMCNativePref(NSString *key, id fallback) {
    if (![key isKindOfClass:NSString.class] || !key.length) return fallback;
    CFPreferencesAppSynchronize((__bridge CFStringRef)kOMCNativeDomain);
    id x=CFBridgingRelease(CFPreferencesCopyAppValue((__bridge CFStringRef)key,
                                                     (__bridge CFStringRef)kOMCNativeDomain));
    return x ?: fallback;
}

BOOL OMCNativeSetPref(NSString *key, id value) {
    if (![key isKindOfClass:NSString.class] || !key.length) return NO;
    if (value && ![NSPropertyListSerialization propertyList:value isValidForFormat:NSPropertyListBinaryFormat_v1_0])
        return NO;
    CFPreferencesSetAppValue((__bridge CFStringRef)key, (__bridge CFPropertyListRef)value,
                             (__bridge CFStringRef)kOMCNativeDomain);
    BOOL synced=CFPreferencesAppSynchronize((__bridge CFStringRef)kOMCNativeDomain);
    if (synced) notify_post(kOMCNativeChanged);
    NSLog(@"[hl26-settings] pref-write key=%@ sync=%d type=%@",
          key, synced, value?NSStringFromClass([value class]):@"removed");
    return synced;
}

static NSString *OMCNativeCurrentLanguage(void) {
    NSArray *supported=@[@"vi",@"en",@"es",@"pt-BR",@"de",@"fr",@"it",@"ru",
                          @"zh-Hans",@"ja",@"ko",@"ar",@"th",@"id"];
    id saved=OMCNativePref(@"language",nil);
    if([saved isKindOfClass:NSString.class]&&[supported containsObject:saved])return saved;
    for(NSString *preferred in NSLocale.preferredLanguages){
        for(NSString *lang in supported)
            if([preferred isEqualToString:lang]||
               [preferred hasPrefix:[lang stringByAppendingString:@"-"]])return lang;
        NSString *base=[[preferred componentsSeparatedByString:@"-"] firstObject];
        if([base isEqualToString:@"zh"])continue;
        for(NSString *lang in supported)
            if([[[lang componentsSeparatedByString:@"-"] firstObject] isEqualToString:base])return lang;
    }
    return @"en";
}
// Original OMCLoadStrings merges every .strings table (en fallback + selected
// language), including Car.strings, and honors the "language" preference.
// NSLocale-only NSLocalizedStringFromTableInBundle misses user overrides.
NSString *OMCNativeLocalized(NSString *key) {
    if(!key.length)return @"";
    static NSMutableDictionary<NSString *,NSDictionary *> *cache;
    NSString *lang=OMCNativeCurrentLanguage();
    @synchronized(NSBundle.mainBundle) {
        if(!cache)cache=[NSMutableDictionary dictionary];
        NSDictionary *strings=cache[lang];
        if(!strings) {
            NSMutableDictionary *merged=[NSMutableDictionary dictionary];
            NSArray *tables=@[@"Localizable",@"AppBridge",@"Car",@"HomeScreen",
                @"Profiles",@"SplitScreen",@"SpeedBubble",@"StartupScreen",
                @"Onboarding",@"WhatsNew"];
            NSArray *locales=[lang isEqualToString:@"en"]?@[@"en"]:@[@"en",lang];
            for(NSString *locale in locales) {
                NSString *folder=[NSBundle.mainBundle pathForResource:locale ofType:@"lproj"];
                if(!folder.length)continue;
                for(NSString *table in tables) {
                    NSString *path=[folder stringByAppendingPathComponent:
                        [table stringByAppendingPathExtension:@"strings"]];
                    NSDictionary *dict=[NSDictionary dictionaryWithContentsOfFile:path];
                    if([dict isKindOfClass:NSDictionary.class])[merged addEntriesFromDictionary:dict];
                }
            }
            strings=[merged copy];
            cache[lang]=strings;
            NSLog(@"[hl26-settings] localization lang=%@ keys=%lu",
                lang,(unsigned long)strings.count);
        }
        id result=strings[key];
        return [result isKindOfClass:NSString.class]?result:key;
    }
}

NSString *OMCNativeStartupDirectory(void) {
    return @"/var/mobile/Library/OmniCar/StartupScreen";
}
// Original OMCRescueFeatures filters feature names already enabled.
static NSArray<NSString *> *OMCNativePendingRescue(void) {
    id data=OMCNativePref(@"rescueFeatures",@[]);
    if (![data isKindOfClass:NSArray.class])return @[];
    NSMutableArray *out=[NSMutableArray array];
    for (id feature in data) {
        if (![feature isKindOfClass:NSString.class] || ![feature length] || [feature length]>80)continue;
        NSString *key=[feature stringByAppendingString:@"Enabled"];
        if (![OMCNativePref(key,@YES) boolValue] && ![out containsObject:feature])
            [out addObject:feature];
    }
    return out;
}
static NSArray<NSString *> *OMCNativeActiveConflicts(void) {
    NSDictionary *known=@{@"carbridge":@"CarBridge",@"duodash":@"DuoDash",
                          @"truedash":@"TrueDash",@"carplayenable":@"CarPlayEnable"};
    NSMutableSet *active=[NSMutableSet set];
    NSFileManager *fm=NSFileManager.defaultManager;
    for(NSString *dir in @[@"/var/jb/Library/MobileSubstrate/DynamicLibraries",
                            @"/Library/MobileSubstrate/DynamicLibraries",
                            @"/var/jb/usr/lib/TweakInject",
                            @"/usr/lib/TweakInject"]) {
        NSArray *files=[fm contentsOfDirectoryAtPath:dir error:nil];
        for(NSString *file in files){
            if(![file.pathExtension isEqualToString:@"dylib"])continue;
            NSString *name=[file.stringByDeletingPathExtension lowercaseString];
            NSMutableString *norm=[NSMutableString string];
            for(NSUInteger i=0;i<name.length;i++){
                unichar ch=[name characterAtIndex:i];
                if ((ch>='a'&&ch<='z')||(ch>='0'&&ch<='9'))[norm appendFormat:@"%C",ch];
            }
            NSString *vendor=known[norm];
            if(vendor.length)[active addObject:vendor];
        }
    }
    return [active.allObjects sortedArrayUsingSelector:@selector(compare:)];
}
static BOOL OMCVi(void) { return [OMCNativeCurrentLanguage() isEqualToString:@"vi"]; }
static NSString *OMCText(NSString *vi,NSString *en) {return OMCVi()?vi:en;}
static NSString *OMCRowName(NSDictionary *r) {
    NSString *key=r[@"label"];
    return key.length?OMCNativeLocalized(key):@"";
}

static NSString *OMCLeOptionDisplay(NSString *key, id value) {
    if (!value) return @"";
    if (![key hasPrefix:@"leTraffic"]) return [value description];
    NSString *choice=[value description];
    NSDictionary<NSString *,NSDictionary<NSString *,NSString *> *> *names=@{
        @"leTrafficSource":@{@"vietmap-live":@"VietMap Live", @"gofa":@"GOFA", @"waze":@"Waze"},
        @"leTrafficPresentation":@{@"maps-home":@"Maps + bubble", @"maps-only":@"Maps only",
                                 @"bubble-only":@"Bubble only", @"except-dashboard":@"Except Dashboard"},
        @"leTrafficArrangement":@{@"corner":@"Corner", @"side":@"Side",
                                @"strip":@"Strip", @"compact":@"Compact"},
        @"leTrafficBackground":@{@"asphalt":@"Asphalt", @"paint":@"Paint",
                               @"glass":@"Glass", @"haze":@"Haze", @"bare":@"Bare"},
        @"leTrafficMapsStyle":@{@"halo":@"Lề (Halo)", @"classic":@"Classic"},
        @"leTrafficMapsPhoneLayout":@{@"auto":@"Auto", @"horizontal":@"Horizontal",
                                    @"vertical":@"Vertical"},
        @"leTrafficMapsOverspeedMode":@{@"off":@"Off", @"map":@"Google Maps",
                                       @"carplay":@"CarPlay"}
    };
    return names[key][choice] ?: choice;
}
static NSDictionary *OMCRow(NSString *label,NSString *type,NSString *key,id def,NSArray *choices) {
    NSMutableDictionary *r=[@{@"label":label?:@"",@"type":type?:@"link"} mutableCopy];
    if (key) r[@"key"]=key;
    if (def) r[@"default"]=def;
    if (choices) r[@"choices"]=choices;
    return r;
}
static NSDictionary *OMCSection(NSString *header, NSArray *rows) {
    return @{@"header":header?:@"",@"rows":rows?:@[]};
}
static void OMCAlert(UIViewController *owner,NSString *message) {
    UIAlertController *a=[UIAlertController alertControllerWithTitle:@"OmniCar"
        message:message preferredStyle:UIAlertControllerStyleAlert];
    [a addAction:[UIAlertAction actionWithTitle:OMCText(@"Đóng",@"Close")
                                          style:UIAlertActionStyleCancel handler:nil]];
    [owner presentViewController:a animated:YES completion:nil];
}

@interface OMCNativeAppsPage : UITableViewController <UISearchResultsUpdating>
@property(nonatomic,copy) void (^onPick)(NSString *);
@property(nonatomic,strong) NSArray<NSDictionary *> *inventory;
@property(nonatomic,strong) NSArray<NSDictionary *> *visible;
@property(nonatomic,copy) NSString *query;
@property(nonatomic,strong) NSMutableSet<NSString *> *chosen;
@property(nonatomic) BOOL homeMode;
@end

@interface OMCNativeSimplePage : UITableViewController <UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIDocumentPickerDelegate>
@property(nonatomic) NSInteger kind; // 0 general, 1 split, 2 Home, 3 Bubble, 4 profiles
@property(nonatomic,strong) NSArray<NSDictionary *> *sections;
@property(nonatomic,strong) UISwitch *masterSwitch;
@property(nonatomic,strong) UILabel *masterStatus;
- (instancetype)initWithKind:(NSInteger)kind;
@end

@implementation OMCNativeAppsPage
- (instancetype)init {
    if ((self=[super initWithStyle:UITableViewStyleInsetGrouped])) {
        self.title=OMCNativeLocalized(@"APPS");
        self.query=@"";
    }
    return self;
}
- (NSArray<NSDictionary *> *)installed {
    NSMutableDictionary<NSString *,NSString *> *all=[NSMutableDictionary dictionary];
    NSMutableArray *old=[NSMutableArray array];
    for (NSString *key in @[@"appBridgeApps",@"splitScreenCarPlayApps",
                            @"homeScreenShownApps",@"homeScreenHiddenApps"]) {
        id x=OMCNativePref(key,@[]);
        if ([x isKindOfClass:NSArray.class]) [old addObjectsFromArray:x];
    }
    id car=OMCNativePref(@"homeScreenCarApps",@[]);
    if ([car isKindOfClass:NSArray.class]) {
        for (id x in car) if ([x isKindOfClass:NSDictionary.class] &&
                             [x[@"id"] isKindOfClass:NSString.class])
            all[x[@"id"]]=[x[@"name"] isKindOfClass:NSString.class]?x[@"name"]:x[@"id"];
    }
    for (id item in old) if ([item isKindOfClass:NSString.class] && [item length])
        all[item]=all[item]?:item;
    Class c=NSClassFromString(@"LSApplicationWorkspace");
    SEL s=NSSelectorFromString(@"defaultWorkspace");
    SEL allSel=NSSelectorFromString(@"allInstalledApplications");
    @try {
        id workspace=(c&&[c respondsToSelector:s])
            ?((id(*)(id,SEL))objc_msgSend)(c,s):nil;
        id proxies=(workspace&&[workspace respondsToSelector:allSel])
            ?((id(*)(id,SEL))objc_msgSend)(workspace,allSel):nil;
        if ([proxies isKindOfClass:NSArray.class]) for (id proxy in proxies) {
            // The original Prefs path uses LSApplicationProxy.bundleIdentifier.
            SEL bidSel=NSSelectorFromString(@"bundleIdentifier");
            SEL titleSel=NSSelectorFromString(@"localizedName");
            SEL typeSel=NSSelectorFromString(@"applicationType");
            SEL tagsSel=NSSelectorFromString(@"appTags");
            SEL hiddenSel=NSSelectorFromString(@"isLaunchProhibited");
            SEL placeholderSel=NSSelectorFromString(@"isPlaceholder");
            if (![proxy respondsToSelector:bidSel]) continue;
            id bid=((id(*)(id,SEL))objc_msgSend)(proxy,bidSel);
            if (![bid isKindOfClass:NSString.class] || ![bid length] ||
                [bid hasPrefix:@"com.apple.springboard"] ||
                [bid hasPrefix:@"com.apple.CarPlay"] ||
                [bid hasPrefix:@"com.anlai.omnicar"]) continue;
            id type=[proxy respondsToSelector:typeSel]
                ?((id(*)(id,SEL))objc_msgSend)(proxy,typeSel):nil;
            if (![type isEqual:@"User"] && ![type isEqual:@"System"]) continue;
            id tags=[proxy respondsToSelector:tagsSel]
                ?((id(*)(id,SEL))objc_msgSend)(proxy,tagsSel):nil;
            if ([tags isKindOfClass:NSArray.class] && [tags containsObject:@"hidden"])continue;
            if ([proxy respondsToSelector:hiddenSel] &&
                ((BOOL(*)(id,SEL))objc_msgSend)(proxy,hiddenSel)) continue;
            if ([proxy respondsToSelector:placeholderSel] &&
                ((BOOL(*)(id,SEL))objc_msgSend)(proxy,placeholderSel)) continue;
            id name=[proxy respondsToSelector:titleSel]
                ?((id(*)(id,SEL))objc_msgSend)(proxy,titleSel):nil;
            all[bid]=[name isKindOfClass:NSString.class]&&[name length]?name:bid;
        }
    } @catch (NSException *e) {
        NSLog(@"[hl26-settings] app-enumeration exception=%@",e.name);
    }
    NSMutableArray *rows=[NSMutableArray array];
    for (NSString *bid in all) {
        if ([bid isEqualToString:@"com.anlai.omnicar.app"]) continue;
        [rows addObject:@{@"id":bid,@"name":all[bid]}];
    }
    [rows sortUsingComparator:^NSComparisonResult(NSDictionary *a,NSDictionary *b){
        return [a[@"name"] localizedStandardCompare:b[@"name"]];
    }];
    return rows;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.keyboardDismissMode=UIScrollViewKeyboardDismissModeOnDrag;
    UISearchController *search=[[UISearchController alloc] initWithSearchResultsController:nil];
    search.searchResultsUpdater=self;
    search.obscuresBackgroundDuringPresentation=NO;
    self.navigationItem.searchController=search;
    self.definesPresentationContext=YES;
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.title=self.homeMode?OMCNativeLocalized(@"HOME_SCREEN"):OMCNativeLocalized(@"APPS");
    self.inventory=[self installed];
    if (self.homeMode) {
        self.title=OMCNativeLocalized(@"HOME_SCREEN");
        id c=OMCNativePref(@"homeScreenCarApps",@[]);
        NSMutableSet *carIDs=[NSMutableSet set];
        NSMutableSet *offIDs=[NSMutableSet set];
        if([c isKindOfClass:NSArray.class])for(id entry in c){
            if (![entry isKindOfClass:NSDictionary.class] ||
                ![entry[@"id"] isKindOfClass:NSString.class])continue;
            [carIDs addObject:entry[@"id"]];
            if ([entry[@"off"] boolValue]) [offIDs addObject:entry[@"id"]];
        }
        if (!carIDs.count) {
            // The original Prefs path falls back to splitScreenCarPlayApps.
            id fallback=OMCNativePref(@"splitScreenCarPlayApps",@[]);
            if ([fallback isKindOfClass:NSArray.class]) for (id bid in fallback)
                if ([bid isKindOfClass:NSString.class] && [bid length])
                    [carIDs addObject:bid];
        }
        if (carIDs.count) {
            self.inventory=[self.inventory filteredArrayUsingPredicate:
                [NSPredicate predicateWithBlock:^BOOL(NSDictionary *a,NSDictionary *ctx){
                    return [carIDs containsObject:a[@"id"]];
                }]];
        } else {
            // A missing native CarPlay catalog is BLIND, never a license to
            // hide arbitrary iPhone apps from CarPlay Home.
            self.inventory=@[];
            NSLog(@"[hl26-settings] home catalog=BLIND no-changes-allowed");
        }
        NSSet *hidden=[NSSet setWithArray:OMCNativePref(@"homeScreenHiddenApps",@[])];
        NSSet *shown=[NSSet setWithArray:OMCNativePref(@"homeScreenShownApps",@[])];
        self.chosen=[NSMutableSet set];
        for (NSDictionary *row in self.inventory) {
            NSString *bid=row[@"id"];
            if (![hidden containsObject:bid] &&
                (![offIDs containsObject:bid]||[shown containsObject:bid])) [self.chosen addObject:bid];
        }
    } else {
        id data=OMCNativePref(@"appBridgeApps",@[]);
        self.chosen=[NSMutableSet setWithArray:[data isKindOfClass:NSArray.class]?data:@[]];
        if(!self.onPick) {
            // The original AppBridge page separates phone-only apps from
            // native CarPlay apps. Keep historical choices visible for removal,
            // but never offer a new native system app as an AppBridge duplicate.
            NSMutableSet *nativeIDs=[NSMutableSet set];
            id catalog=OMCNativePref(@"homeScreenCarApps",@[]);
            if([catalog isKindOfClass:NSArray.class])for(id item in catalog)
                if([item isKindOfClass:NSDictionary.class]&&
                   [item[@"id"] isKindOfClass:NSString.class])
                    [nativeIDs addObject:item[@"id"]];
            if(nativeIDs.count) {
                NSSet *already=[self.chosen copy];
                self.inventory=[self.inventory filteredArrayUsingPredicate:
                    [NSPredicate predicateWithBlock:^BOOL(NSDictionary *app,NSDictionary *unused){
                        return ![nativeIDs containsObject:app[@"id"]]||
                               [already containsObject:app[@"id"]];
                    }]];
            }
        }
    }
    [self updateSearchResultsForSearchController:self.navigationItem.searchController];
    NSLog(@"[hl26-settings] page=apps inventory=%lu chosen=%lu",
          (unsigned long)self.inventory.count,(unsigned long)self.chosen.count);
}
- (void)updateSearchResultsForSearchController:(UISearchController *)controller {
    self.query=controller.searchBar.text?:@"";
    if (!self.query.length) self.visible=self.inventory;
    else {
        NSPredicate *p=[NSPredicate predicateWithBlock:^BOOL(NSDictionary *x,NSDictionary *b){
            return [x[@"name"] localizedCaseInsensitiveContainsString:self.query] ||
                   [x[@"id"] localizedCaseInsensitiveContainsString:self.query];
        }];
        self.visible=[self.inventory filteredArrayUsingPredicate:p];
    }
    [self.tableView reloadData];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.visible.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)p {
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"app"];
    if (!cell) cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"app"];
    NSDictionary *a=self.visible[p.row];
    cell.textLabel.text=a[@"name"];
    cell.detailTextLabel.text=a[@"id"];
    cell.accessoryType=[self.chosen containsObject:a[@"id"]]
        ?UITableViewCellAccessoryCheckmark:UITableViewCellAccessoryNone;
    if (self.homeMode && [self isHomeProtected:a[@"id"]]) {
        cell.textLabel.textColor=UIColor.secondaryLabelColor;
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
    } else {
        cell.textLabel.textColor=UIColor.labelColor;
        cell.selectionStyle=UITableViewCellSelectionStyleDefault;
    }
    return cell;
}
- (BOOL)isHomeProtected:(NSString *)bid {
    if ([@[@"com.apple.mobilephone",@"com.apple.Music",@"com.apple.Maps",
          @"com.apple.MobileSMS",@"com.apple.InCallService"] containsObject:bid])return YES;
    return [bid hasPrefix:@"com.apple.CarPlay"]||
        [bid rangeOfString:@"NowPlaying"].location!=NSNotFound;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)p {
    [tableView deselectRowAtIndexPath:p animated:YES];
    NSString *bid=self.visible[p.row][@"id"];
    if (self.onPick) {
        self.onPick(bid);[self.navigationController popViewControllerAnimated:YES];return;
    }
    if(self.homeMode){
        if ([self isHomeProtected:bid])return;
        NSMutableSet *hidden=[NSMutableSet setWithArray:OMCNativePref(@"homeScreenHiddenApps",@[])];
        NSMutableSet *shown=[NSMutableSet setWithArray:OMCNativePref(@"homeScreenShownApps",@[])];
        id entries=OMCNativePref(@"homeScreenCarApps",@[]);
        BOOL iosOff=NO;
        if([entries isKindOfClass:NSArray.class])for(id entry in entries)
            if([entry isKindOfClass:NSDictionary.class]&&[entry[@"id"] isEqual:bid]) {
                iosOff=[entry[@"off"] boolValue];break;
            }
        if ([self.chosen containsObject:bid]) {
            [self.chosen removeObject:bid];
            if ([shown containsObject:bid]) [shown removeObject:bid];
            else [hidden addObject:bid];
        } else {
            [self.chosen addObject:bid];[hidden removeObject:bid];
            if(iosOff)[shown addObject:bid];
        }
        NSArray *h=[hidden.allObjects sortedArrayUsingSelector:@selector(compare:)];
        NSArray *a=[shown.allObjects sortedArrayUsingSelector:@selector(compare:)];
        if (!OMCNativeSetPref(@"homeScreenHiddenApps",h) ||
            !OMCNativeSetPref(@"homeScreenShownApps",a)) {
            OMCAlert(self,OMCText(@"Không lưu được Home.",@"Unable to save Home apps."));
        }
    }else{
        if ([self.chosen containsObject:bid]) [self.chosen removeObject:bid];
        else [self.chosen addObject:bid];
        NSArray *sorted=[self.chosen.allObjects sortedArrayUsingSelector:@selector(compare:)];
        if (!OMCNativeSetPref(@"appBridgeApps",sorted)) {
            OMCAlert(self,OMCText(@"Không lưu được danh sách app.",@"Failed to save the app list."));
        }
    }
    [tableView reloadRowsAtIndexPaths:@[p] withRowAnimation:UITableViewRowAnimationNone];
}
@end

@implementation OMCNativeSimplePage
- (instancetype)initWithKind:(NSInteger)kind {
    if ((self=[super initWithStyle:UITableViewStyleInsetGrouped])) {
        self.kind=kind;
        NSArray *keys=@[@"", @"SPLITSCREEN",@"HOME_SCREEN",@"SPEEDBUBBLE",@"PROFILES"];
        NSInteger selected=MAX(0,MIN(kind,4));
        self.title=selected==0?@"DuoCar":OMCNativeLocalized(keys[selected]);
    }
    return self;
}
- (NSArray<NSDictionary *> *)makeSections {
    if (self.kind==0) {
        NSMutableArray *sections=[NSMutableArray array];
        NSArray *pending=OMCNativePendingRescue();
        if (pending.count) {
            [sections addObject:OMCSection(OMCNativeLocalized(@"RESCUE_GROUP"),@[
                OMCRow(@"RESCUE_RESTORE",@"rescue",nil,nil,nil)])];
        }
        NSArray *conflicts=OMCNativeActiveConflicts();
        if (conflicts.count){
            [sections addObject:OMCSection(OMCNativeLocalized(@"CONFLICTS_GROUP"),@[
                OMCRow([conflicts componentsJoinedByString:@", "],@"conflicts",nil,nil,nil)])];
        }
        // Match the original Root.plist layout and insert Feature*.plist by
        // featureOrder 10 Startup, 20 SpeedBubble, 30 SplitScreen. The 3
        // DuoNavi-style tabs remain for quick access, but Settings now
        // reproduces the original OmniCar root ordering and header actions.
        [sections addObject:OMCSection(OMCNativeLocalized(@"APPS_GROUP"),@[
            OMCRow(@"APPS",@"apps",nil,nil,nil),
            OMCRow(@"HOME_SCREEN",@"home",nil,nil,nil)])];
        [sections addObject:OMCSection(OMCNativeLocalized(@"FEATURES_GROUP"),@[
            OMCRow(@"STARTUPSCREEN",@"startup",nil,nil,nil),
            OMCRow(@"SPEEDBUBBLE",@"bubble",nil,nil,nil),
            OMCRow(OMCText(@"Tùy chỉnh riêng DuoCar cho Lề",
                            @"DuoCar extras for Lề"),
                    @"leCompat",nil,nil,nil),
            OMCRow(@"SPLITSCREEN",@"split",nil,nil,nil)])];
        [sections addObject:OMCSection(@"",@[
            OMCRow(@"PROFILES",@"profiles",nil,nil,nil)])];
        // [hl36-voice-off] Speech assistant is temporarily absent from DuoCar.
        // Keep startup/speed-bubble/split/settings sections unchanged.
        [sections addObject:OMCSection(OMCText(@"Thiết bị",@"Device"),@[
             OMCRow(OMCText(@"Pin và nhiệt độ",@"Battery & temperature"),@"vitals",nil,nil,nil),
             OMCRow(OMCText(@"Hiện pin, nhiệt trên Dock CarPlay",@"Show battery and heat on CarPlay Dock"),
                    @"switch",@"duocarVitalsEnabled",@YES,nil),
             OMCRow(OMCText(@"Bong bóng giờ, pin, nhiệt khi toàn màn hình",@"Fullscreen time, battery & heat bubble"),
                    @"switch",@"duocarFullscreenVitalsEnabled",@YES,nil)])];
        [sections addObject:OMCSection(OMCNativeLocalized(@"SUPPORT_GROUP"),@[
            OMCRow(@"ONB_SHOW_AGAIN",@"guide",nil,nil,nil),
            OMCRow(@"WN_ROW",@"whatsnew",nil,nil,nil)])];
        [sections addObject:OMCSection(OMCNativeLocalized(@"DEV_GROUP"),@[
            OMCRow(@"SEND_LOG",@"logs",nil,nil,nil)])];
        return sections;
    }
    if (self.kind==1) {
        NSMutableArray *favorites=[NSMutableArray array];
        for (NSInteger i=1;i<=3;i++) {
            NSString *n=[NSString stringWithFormat:@"splitScreenFav%ldName",(long)i];
            [favorites addObject:OMCRow([NSString stringWithFormat:@"%@ %ld",
                OMCNativeLocalized(@"SPLITSCREEN_FAV_GROUP"),(long)i],
                @"favorite",n,@(i),nil)];
        }
        return @[
            OMCSection(@"SPLITSCREEN_LAYOUT_GROUP",@[
                OMCRow(@"SPLITSCREEN_ENABLE",@"switch",@"splitScreenEnabled",@YES,nil),
                OMCRow(@"SPLITSCREEN_AUTO_LAUNCH",@"switch",@"splitScreenAutoLaunch",@NO,nil),
                OMCRow(@"SPLITSCREEN_PINNED",@"pickapp",@"splitScreenPinnedApp",@"",nil)]),
            OMCSection(OMCNativeLocalized(@"SPLITSCREEN_FAV_GROUP"),favorites),
            OMCSection(OMCNativeLocalized(@"SPLITSCREEN_LAYOUT_GROUP"),@[
                OMCRow(@"SPLITSCREEN_SHOW_RECENT",@"switch",@"splitScreenShowRecent",@YES,nil),
                OMCRow(@"SPLITSCREEN_SHOW_FAVORITES",@"switch",@"splitScreenShowFavorites",@YES,nil)]),
            OMCSection(OMCText(@"Cử chỉ và lệnh tắt",@"Gestures & Shortcuts"),@[
                OMCRow(@"SPLITSCREEN_GESTURES",@"help",nil,nil,nil),
                OMCRow(@"SPLITSCREEN_SIRI",@"shortcuts",nil,nil,nil)])
        ];
    }
    if (self.kind==2) return @[
        OMCSection(OMCNativeLocalized(@"HOMESCREEN_GRID"),@[
            OMCRow(@"HOMESCREEN_COLS",@"number",@"homeScreenGridCols",@0,@[@0,@3,@4,@5,@6,@7,@8]),
            OMCRow(@"HOMESCREEN_ROWS",@"number",@"homeScreenGridRows",@0,@[@0,@2,@3,@4,@5,@6]),
            OMCRow(@"HOMESCREEN_ICON_SIZE",@"number",@"homeScreenIconSize",@100,@[@60,@70,@80,@90,@100,@110,@120]),
            OMCRow(@"HOMESCREEN_NAMES",@"switch",@"homeScreenShowNames",@YES,nil),
            OMCRow(@"HOMESCREEN_BLUR",@"number",@"homeScreenBlur",@0,@[@0,@5,@10,@15,@20,@25,@30]),
            OMCRow(@"HOMESCREEN_DIM",@"number",@"homeScreenDim",@25,@[@0,@10,@20,@25,@30,@40,@50,@60,@70])]),
        OMCSection(OMCNativeLocalized(@"HOMESCREEN_WALLPAPER"),@[
            OMCRow(@"HOMESCREEN_WALLPAPER",@"homewallpaper",nil,nil,nil)]),
        OMCSection(OMCText(@"Ứng dụng trên Home",@"Home applications"),@[
            OMCRow(@"APPS",@"homeapps",nil,nil,nil),
            OMCRow(OMCText(@"Khôi phục bố cục Home",@"Reset Home layout"),@"resethome",nil,nil,nil)])
    ];
    // [hl52-le-original] The primary entry invokes LePrefs.bundle's own
    // signed root UI; extra DuoCar-only switches remain a separate page.
    if (self.kind==3) return @[
        OMCSection(OMCText(@"Lề 0.2.4", @"Lề 0.2.4"), @[
            OMCRow(OMCText(@"Cài đặt Lề (giao diện gốc)",
                           @"Original Lề settings"),
                   @"leOriginal", nil, nil, nil),
            OMCRow(OMCText(@"Tùy chỉnh thêm: GPS ±5, kéo tự do",
                           @"DuoCar extras: GPS ±5, free drag"),
                   @"leCompat", nil, nil, nil)
        ])
    ];
    id raw=OMCNativePref(@"carProfiles",@{});
    NSDictionary *profiles=[raw isKindOfClass:NSDictionary.class]?raw:@{};
    NSMutableArray *cars=[NSMutableArray array];
    for (NSString *key in [[profiles allKeys] sortedArrayUsingSelector:@selector(compare:)]) {
        NSDictionary *p=[profiles[key] isKindOfClass:NSDictionary.class]?profiles[key]:@{};
        [cars addObject:@{@"label":p[@"name"]?:key,@"type":@"car",
                          @"key":key,@"default":p[@"lastSeen"]?:@0}];
    }
    return @[
        OMCSection(OMCText(@"Tùy chọn",@"Options"),@[
            OMCRow(OMCText(@"Ghi nhớ cấu hình từng xe",@"Profiles per car"),
                @"switch",@"carProfilesEnabled",@NO,nil)]),
        OMCSection(OMCNativeLocalized(@"PROFILES_CARS"),cars)
    ];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    if (self.kind!=0)return;
    // Original Prefs uses a 118pt header card with master switch, plus
    // independent language and Respring actions in the navigation bar.
    UIView *header=[[UIView alloc] initWithFrame:CGRectMake(0,0,
        CGRectGetWidth(self.tableView.bounds),136)];
    header.autoresizingMask=UIViewAutoresizingFlexibleWidth;
    UIView *card=[[UIView alloc] initWithFrame:CGRectInset(CGRectMake(0,8,
        CGRectGetWidth(header.bounds),120),16,0)];
    card.autoresizingMask=UIViewAutoresizingFlexibleWidth;
    card.backgroundColor=UIColor.secondarySystemGroupedBackgroundColor;
    card.layer.cornerRadius=15;
    card.clipsToBounds=YES;
    UILabel *title=[[UILabel alloc] initWithFrame:CGRectMake(18,15,
        CGRectGetWidth(card.bounds)-105,36)];
    title.autoresizingMask=UIViewAutoresizingFlexibleWidth;
    title.text=@"DuoCar";
    title.font=[UIFont systemFontOfSize:26 weight:UIFontWeightBold];
    [card addSubview:title];
    UILabel *subtitle=[[UILabel alloc] initWithFrame:CGRectMake(18,58,
        CGRectGetWidth(card.bounds)-36,45)];
    subtitle.autoresizingMask=UIViewAutoresizingFlexibleWidth;
    subtitle.font=[UIFont preferredFontForTextStyle:UIFontTextStyleSubheadline];
    subtitle.textColor=UIColor.secondaryLabelColor;
    subtitle.numberOfLines=2;
    [card addSubview:subtitle];self.masterStatus=subtitle;
    UISwitch *sw=[UISwitch new];
    CGRect fr=sw.frame;fr.origin=CGPointMake(CGRectGetWidth(card.bounds)-fr.size.width-15,18);
    sw.frame=fr;sw.autoresizingMask=UIViewAutoresizingFlexibleLeftMargin;
    [sw addTarget:self action:@selector(omcMasterChanged:)
      forControlEvents:UIControlEventValueChanged];
    [card addSubview:sw];self.masterSwitch=sw;
    [header addSubview:card];
    self.tableView.tableHeaderView=header;
    UIBarButtonItem *respring=[[UIBarButtonItem alloc]
        initWithImage:[UIImage systemImageNamed:@"arrow.clockwise"]
        style:UIBarButtonItemStylePlain target:self action:@selector(confirmRespring)];
    respring.accessibilityLabel=OMCNativeLocalized(@"RESPRING");
    UIBarButtonItem *language=[[UIBarButtonItem alloc]
        initWithImage:[UIImage systemImageNamed:@"globe"]
        style:UIBarButtonItemStylePlain target:self action:@selector(chooseLanguage)];
    language.accessibilityLabel=OMCNativeLocalized(@"LANGUAGE");
    self.navigationItem.rightBarButtonItems=@[respring,language];
    [self refreshMasterCard];
    NSLog(@"[hl27-settings] gate=original-root-cards feature-order=10,20,30");
}
- (void)refreshMasterCard {
    if(self.kind!=0 || !self.masterSwitch)return;
    BOOL enabled=[OMCNativePref(@"enabled",@YES) boolValue];
    [self.masterSwitch setOn:enabled animated:NO];
    self.masterStatus.text=[NSString stringWithFormat:@"%@ • %@",
        OMCNativeLocalized(@"HEADER_TAGLINE"),
        OMCNativeLocalized(enabled?@"STATUS_ON":@"STATUS_OFF")];
}
- (void)omcMasterChanged:(UISwitch *)sender {
    BOOL wanted=sender.isOn;
    if(!OMCNativeSetPref(@"enabled",@(wanted))) {
        sender.on=!wanted;
        OMCAlert(self,OMCText(@"Không lưu được cấu hình.",@"Could not save settings."));
    }
    [self refreshMasterCard];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    NSArray *keys=@[@"", @"SPLITSCREEN",@"HOME_SCREEN",@"SPEEDBUBBLE",@"PROFILES"];
    self.title=self.kind==0?@"DuoCar":
        OMCNativeLocalized(keys[MAX(0,MIN(self.kind,4))]);
    self.sections=[self makeSections];
    [self.tableView reloadData];
    [self refreshMasterCard];
    NSLog(@"[hl26-settings] page=%ld sections=%lu",(long)self.kind,(unsigned long)self.sections.count);
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)t {return self.sections.count;}
- (NSInteger)tableView:(UITableView *)t numberOfRowsInSection:(NSInteger)s {
    return [self.sections[s][@"rows"] count];
}
- (NSString *)tableView:(UITableView *)t titleForHeaderInSection:(NSInteger)s {
    NSString *v=self.sections[s][@"header"];return OMCNativeLocalized(v);
}
- (NSDictionary *)rowAt:(NSIndexPath *)p {return self.sections[p.section][@"rows"][p.row];}
- (UITableViewCell *)tableView:(UITableView *)t cellForRowAtIndexPath:(NSIndexPath *)p {
    NSDictionary *r=[self rowAt:p];
    NSString *type=r[@"type"],*key=r[@"key"];
    UITableViewCell *cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
    cell.textLabel.text=OMCRowName(r);
    cell.textLabel.numberOfLines=2;
    cell.detailTextLabel.font=[UIFont systemFontOfSize:13];
    cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    if ([type isEqualToString:@"switch"]) {
        UISwitch *sw=[UISwitch new];sw.on=[OMCNativePref(key,r[@"default"]?:@NO) boolValue];
        objc_setAssociatedObject(sw,@selector(omcChanged:),key,OBJC_ASSOCIATION_COPY_NONATOMIC);
        [sw addTarget:self action:@selector(omcChanged:) forControlEvents:UIControlEventValueChanged];
        cell.accessoryView=sw;cell.accessoryType=UITableViewCellAccessoryNone;
    } else if ([type isEqualToString:@"slider"]) {
        UISlider *slider=[[UISlider alloc] initWithFrame:CGRectMake(0,0,150,44)];
        slider.minimumValue=[r[@"min"] floatValue];slider.maximumValue=[r[@"max"] floatValue];
        slider.value=[OMCNativePref(key,r[@"default"]?:@0) floatValue];
        slider.accessibilityLabel=OMCRowName(r);
        objc_setAssociatedObject(slider,@selector(omcSliderDone:),r,OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        [slider addTarget:self action:@selector(omcSliderDone:) forControlEvents:
            UIControlEventTouchUpInside|UIControlEventTouchUpOutside];
        cell.accessoryView=slider;cell.accessoryType=UITableViewCellAccessoryNone;
    } else if ([type isEqualToString:@"number"] || [type isEqualToString:@"text"] ||
               [type isEqualToString:@"pickapp"] || [type isEqualToString:@"favorite"]) {
        id value=OMCNativePref(key,[type isEqualToString:@"favorite"]?nil:r[@"default"]);
        cell.detailTextLabel.text=value?OMCLeOptionDisplay(key,value):OMCText(@"Chưa chọn",@"Not set");
    } else if ([type isEqualToString:@"car"]) {
        cell.detailTextLabel.text=[OMCNativePref(@"carProfileCurrent",@"") isEqual:key]
            ?@"✓":@"";
    } else if (self.kind==0) {
        NSString *featureKey=nil;
        if([type isEqualToString:@"startup"])featureKey=@"startupScreenEnabled";
        else if([type isEqualToString:@"bubble"]) {
            cell.detailTextLabel.text=OMCLeOriginalPreferencesAvailable()?@"Lề 0.2.4":OMCText(@"Chưa nạp Lề", @"Le unavailable");
        }
        else if([type isEqualToString:@"split"])featureKey=@"splitScreenEnabled";
        if(featureKey.length) {
            cell.detailTextLabel.text=OMCNativeLocalized(
                [OMCNativePref(featureKey,@YES) boolValue]?@"STATUS_ON":@"STATUS_OFF");
        }
    }
    return cell;
}
- (void)omcChanged:(UISwitch *)s {
    NSString *key=objc_getAssociatedObject(s,@selector(omcChanged:));
    if (!OMCNativeSetPref(key,@(s.on))) {
        s.on=!s.on; OMCAlert(self,OMCText(@"Không lưu được cấu hình.",@"Could not save settings."));
    }
}
- (void)omcSliderDone:(UISlider *)slider {
    NSDictionary *r=objc_getAssociatedObject(slider,@selector(omcSliderDone:));
    NSString *key=r[@"key"];
    if (!key.length)return;
    NSInteger n=(NSInteger)roundf(slider.value);
    n=MAX([r[@"min"] integerValue],MIN(n,[r[@"max"] integerValue]));
    if (!OMCNativeSetPref(key,@(n))) {
        slider.value=[OMCNativePref(key,r[@"default"]?:@0) floatValue];
        OMCAlert(self,OMCText(@"Không lưu được.",@"Failed to save."));
    }else {
        slider.value=n;
        UIAccessibilityPostNotification(UIAccessibilityAnnouncementNotification,
            [NSString stringWithFormat:@"%@: %ld",OMCRowName(r),(long)n]);
    }
}
- (void)chooseValueFor:(NSDictionary *)r {
    NSString *key=r[@"key"];NSArray *values=r[@"choices"];
    UIAlertController *a=[UIAlertController alertControllerWithTitle:OMCRowName(r)
        message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    for (id v in values) {
        NSString *name=OMCLeOptionDisplay(key,v);
        if ([key isEqualToString:@"speedBubbleLook"]||
            [key isEqualToString:@"speedBubbleColor"]||
            [key isEqualToString:@"speedBubbleSource"]) {
            NSString *prefix=[key isEqualToString:@"speedBubbleLook"]?@"SPEEDBUBBLE_LOOK":
                ([key isEqualToString:@"speedBubbleColor"]?@"SPEEDBUBBLE_COLOR":@"SPEEDBUBBLE_SRC");
            NSString *label=OMCNativeLocalized([NSString stringWithFormat:@"%@_%ld",prefix,(long)[v integerValue]]);
            if (![label hasPrefix:prefix])name=label;
        }
        if ([key isEqualToString:@"homeScreenGridCols"] ||
            [key isEqualToString:@"homeScreenGridRows"]) {
            if ([v integerValue]==0) name=OMCNativeLocalized(@"HOMESCREEN_AUTO");
        }
        [a addAction:[UIAlertAction actionWithTitle:name style:UIAlertActionStyleDefault
            handler:^(UIAlertAction *action){
                if (OMCNativeSetPref(key,v)) [self.tableView reloadData];
                else OMCAlert(self,OMCText(@"Không lưu được.",@"Failed to save."));
            }]];
    }
    [a addAction:[UIAlertAction actionWithTitle:OMCText(@"Hủy",@"Cancel")
                                           style:UIAlertActionStyleCancel handler:nil]];
    a.popoverPresentationController.sourceView=self.view;
    a.popoverPresentationController.sourceRect=CGRectMake(CGRectGetMidX(self.view.bounds),CGRectGetMidY(self.view.bounds),1,1);
    [self presentViewController:a animated:YES completion:nil];
}
- (void)editTextFor:(NSDictionary *)r {
    NSString *key=r[@"key"];
    UIAlertController *a=[UIAlertController alertControllerWithTitle:OMCRowName(r)
             message:nil preferredStyle:UIAlertControllerStyleAlert];
    [a addTextFieldWithConfigurationHandler:^(UITextField *t){
        t.text=OMCNativePref(key,@"");
    }];
    [a addAction:[UIAlertAction actionWithTitle:OMCText(@"Hủy",@"Cancel")
                                           style:UIAlertActionStyleCancel handler:nil]];
    [a addAction:[UIAlertAction actionWithTitle:OMCText(@"Lưu",@"Save")
                                           style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
        if (OMCNativeSetPref(key,a.textFields.firstObject.text?:@""))[self.tableView reloadData];
    }]];
    [self presentViewController:a animated:YES completion:nil];
}
- (void)editFavorite:(NSDictionary *)r {
    NSInteger n=[r[@"default"] integerValue];
    NSString *k=[NSString stringWithFormat:@"splitScreenFav%ldName",(long)n];
    NSString *layout=[NSString stringWithFormat:@"splitScreenFav%ldLayout",(long)n];
    NSString *base=[NSString stringWithFormat:@"splitScreenFav%ld",(long)n];
    UIAlertController *a=[UIAlertController alertControllerWithTitle:OMCText(@"Bố cục yêu thích",@"Favorite layout")
        message:OMCNativePref(k,@"") preferredStyle:UIAlertControllerStyleActionSheet];
    [a addAction:[UIAlertAction actionWithTitle:OMCText(@"Đổi tên",@"Rename")
                                           style:UIAlertActionStyleDefault handler:^(UIAlertAction *x){
        [self editTextFor:OMCRowName(r)?OMCRow(OMCRowName(r),@"text",k,@"",nil):r];
    }]];
    NSArray *layoutCodes=@[@2,@3,@13,@31];
    NSArray *layoutNames=@[@"SPLITSCREEN_LAYOUT_2",@"SPLITSCREEN_LAYOUT_3",
                           @"SPLITSCREEN_LAYOUT_13",@"SPLITSCREEN_LAYOUT_31"];
    for (NSInteger i=0;i<layoutCodes.count;i++) {
        NSNumber *v=layoutCodes[i];
        [a addAction:[UIAlertAction actionWithTitle:OMCNativeLocalized(layoutNames[i])
                                               style:UIAlertActionStyleDefault handler:^(UIAlertAction *x){
            OMCNativeSetPref(layout,v);[self.tableView reloadData];
        }]];
    }
    // Original SSFavParts() is exactly Left, Right, Third; never App1..4.
    NSInteger slotCount=[OMCNativePref(layout,@2) integerValue]==2?2:3;
    NSArray<NSString *> *parts=@[@"Left",@"Right",@"Third"];
    for (NSInteger i=0;i<slotCount;i++) {
        NSString *key=[base stringByAppendingString:parts[i]];
        NSString *name=[NSString stringWithFormat:@"%@ %ld",OMCText(@"Ô",@"Slot"),(long)(i+1)];
        [a addAction:[UIAlertAction actionWithTitle:name style:UIAlertActionStyleDefault handler:^(UIAlertAction *x){
            OMCNativeAppsPage *page=[OMCNativeAppsPage new];
            page.title=name;
            page.onPick=^(NSString *bid){OMCNativeSetPref(key,bid);[self.tableView reloadData];};
            [self.navigationController pushViewController:page animated:YES];
        }]];
    }
    [a addAction:[UIAlertAction actionWithTitle:OMCText(@"Hủy",@"Cancel")
        style:UIAlertActionStyleCancel handler:nil]];
    a.popoverPresentationController.sourceView=self.view;
    a.popoverPresentationController.sourceRect=CGRectMake(CGRectGetMidX(self.view.bounds),CGRectGetMidY(self.view.bounds),1,1);
    [self presentViewController:a animated:YES completion:nil];
}
- (void)chooseLanguage {
    NSArray *names=@[@"Tiếng Việt",@"English",@"Español",@"Português",@"Deutsch",@"Français",
                     @"Italiano",@"Русский",@"简体中文",@"日本語",@"한국어",@"العربية",@"ไทย",@"Indonesia"];
    NSArray *codes=@[@"vi",@"en",@"es",@"pt-BR",@"de",@"fr",@"it",@"ru",
                     @"zh-Hans",@"ja",@"ko",@"ar",@"th",@"id"];
    UIAlertController *a=[UIAlertController alertControllerWithTitle:OMCText(@"Ngôn ngữ",@"Language")
        message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    for (NSUInteger i=0;i<codes.count;i++){
        NSString *code=codes[i];
        [a addAction:[UIAlertAction actionWithTitle:names[i] style:UIAlertActionStyleDefault
            handler:^(UIAlertAction *action){
                if (OMCNativeSetPref(@"language",code)) {
                    NSArray *tabs=@[OMCNativeLocalized(@"APPS"),OMCNativeLocalized(@"SPLITSCREEN"),
                                    OMCText(@"Cài đặt",@"Settings")];
                    for(NSUInteger n=0;n<self.tabBarController.tabBar.items.count && n<tabs.count;n++)
                        self.tabBarController.tabBar.items[n].title=tabs[n];
                    self.title=OMCText(@"Cài đặt",@"Settings");
                    self.sections=[self makeSections];
                    [self.tableView reloadData];
                }
            }]];
    }
    [a addAction:[UIAlertAction actionWithTitle:OMCText(@"Hủy",@"Cancel")
                                           style:UIAlertActionStyleCancel handler:nil]];
    a.popoverPresentationController.sourceView=self.view;
    a.popoverPresentationController.sourceRect=CGRectMake(CGRectGetMidX(self.view.bounds),CGRectGetMidY(self.view.bounds),1,1);
    [self presentViewController:a animated:YES completion:nil];
}
- (void)confirmRescue {
    NSArray<NSString *> *features=OMCNativePendingRescue();
    if(!features.count){[self.tableView reloadData];return;}
    UIAlertController *a=[UIAlertController alertControllerWithTitle:OMCNativeLocalized(@"RESCUE_RESTORE")
        message:[NSString stringWithFormat:@"%@\n%@",OMCNativeLocalized(@"RESCUE_GROUP"),
                 [features componentsJoinedByString:@", "]]
        preferredStyle:UIAlertControllerStyleAlert];
    [a addAction:[UIAlertAction actionWithTitle:OMCText(@"Hủy",@"Cancel")
        style:UIAlertActionStyleCancel handler:nil]];
    [a addAction:[UIAlertAction actionWithTitle:OMCText(@"Khôi phục",@"Restore")
        style:UIAlertActionStyleDefault handler:^(UIAlertAction *act){
        BOOL ok=YES;
        for(NSString *feature in features) {
            NSString *key=[feature stringByAppendingString:@"Enabled"];
            ok=OMCNativeSetPref(key,@YES)&&ok;
        }
        if(ok) {
            ok=OMCNativeSetPref(@"rescueFeatures",nil)&&ok;
            ok=OMCNativeSetPref(@"rescueDate",nil)&&ok;
        }
        if(!ok)OMCAlert(self,OMCText(@"Chưa khôi phục được tất cả tính năng.",
                @"Some features could not be restored."));
        self.sections=[self makeSections];[self.tableView reloadData];
    }]];
    [self presentViewController:a animated:YES completion:nil];
}
// HL27: The iPhone app cannot assume its own FrontBoard request has
// authority to restart SpringBoard. Route only an explicit confirmed tap
// over the already-established NSDistributed channel into our SpringBoard
// tweak, with a short-lived nonce and an acknowledgement.
- (void)confirmRespring {
    UIAlertController *a=[UIAlertController alertControllerWithTitle:OMCNativeLocalized(@"RESPRING")
         message:OMCNativeLocalized(@"RESPRING_CONFIRM")
         preferredStyle:UIAlertControllerStyleAlert];
    [a addAction:[UIAlertAction actionWithTitle:OMCNativeLocalized(@"CANCEL")
        style:UIAlertActionStyleCancel handler:nil]];
    [a addAction:[UIAlertAction actionWithTitle:OMCNativeLocalized(@"RESPRING")
        style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action){
            Class klass=NSClassFromString(@"NSDistributedNotificationCenter");
            SEL shared=NSSelectorFromString(@"defaultCenter");
            SEL add=NSSelectorFromString(@"addObserverForName:object:queue:usingBlock:");
            SEL send=NSSelectorFromString(@"postNotificationName:object:userInfo:");
            if (!klass || ![klass respondsToSelector:shared]) {
                NSLog(@"[hl27-respring] stage=unavailable-center");
                OMCAlert(self,OMCText(@"Không có kênh liên lạc SpringBoard.",
                          @"SpringBoard messaging is unavailable."));return;
            }
            id center=((id(*)(id,SEL))objc_msgSend)(klass,shared);
            if(!center || ![center respondsToSelector:send] ||
                ![center respondsToSelector:add]) {
                NSLog(@"[hl27-respring] stage=unavailable-selector");
                OMCAlert(self,OMCText(@"SpringBoard không hỗ trợ kênh điều khiển.",
                          @"SpringBoard control channel unavailable."));return;
            }
            NSString *nonce=[[NSUUID UUID] UUIDString];
            __block BOOL acked=NO;
            __block id observer=nil;
            observer=((id(*)(id,SEL,id,id,id,id))objc_msgSend)(
                 center,add,@"com.anlai.omnicar/respring.ack",nil,
                 [NSOperationQueue mainQueue],^(NSNotification *note){
                if(![note.userInfo[@"nonce"] isEqualToString:nonce])return;
                acked=YES;
                NSLog(@"[hl27-respring] stage=ack-received status=%@",
                      note.userInfo[@"status"]);
                if(observer && [center respondsToSelector:@selector(removeObserver:)])
                    [center removeObserver:observer];
                observer=nil;
            });
            if (!observer) {
                NSLog(@"[hl27-respring] stage=observer-failed");
                OMCAlert(self,OMCText(@"Không thể theo dõi phản hồi từ SpringBoard.",
                    @"Could not subscribe to SpringBoard acknowledgement."));return;
            }
            NSLog(@"[hl27-respring] stage=request-sent nonce=%@",nonce);
            ((void(*)(id,SEL,id,id,id))objc_msgSend)(center,send,
                @"com.anlai.omnicar/respring.request",nil,
                @{@"nonce":nonce,@"issuedAt":@(CFAbsoluteTimeGetCurrent())});
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW,3LL*NSEC_PER_SEC),
                           dispatch_get_main_queue(),^{
                if(acked)return;
                if(observer && [center respondsToSelector:@selector(removeObserver:)])
                    [center removeObserver:observer];
                observer=nil;
                NSLog(@"[hl27-respring] stage=ack-timeout; not proven");
                OMCAlert(self,OMCText(@"SpringBoard chưa xác nhận yêu cầu. Không báo đã respring.",
                    @"SpringBoard did not acknowledge the request."));
            });
        }]];
    [self presentViewController:a animated:YES completion:nil];
}
// Home background: the same file/key contract as OMCAppBridgeAppsController.
- (NSString *)nativeHomeDirectory {
    return @"/var/mobile/Library/OmniCar/HomeScreen";
}
- (BOOL)homeWriteJPEG:(UIImage *)image name:(NSString *)name {
    if (!image || image.size.width<=0 || image.size.height<=0 || !name.length)return NO;
    CGFloat w=image.size.width*image.scale,h=image.size.height*image.scale;
    CGFloat scale=MIN(1,2000.0/MAX(w,h));
    CGSize newSize=CGSizeMake(MAX(1,round(w*scale)),MAX(1,round(h*scale)));
    UIGraphicsImageRendererFormat *fmt=[UIGraphicsImageRendererFormat preferredFormat];
    fmt.scale=1;fmt.opaque=YES;
    UIGraphicsImageRenderer *r=[[UIGraphicsImageRenderer alloc] initWithSize:newSize format:fmt];
    UIImage *rendered=[r imageWithActions:^(UIGraphicsImageRendererContext *ctx){
        [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    }];
    NSData *jpeg=UIImageJPEGRepresentation(rendered,0.85);
    NSString *dir=[self nativeHomeDirectory];
    NSError *err=nil;
    if(![NSFileManager.defaultManager createDirectoryAtPath:dir
            withIntermediateDirectories:YES attributes:nil error:&err]) {
        NSLog(@"[hl26-settings] Home mkdir failed: %@",err);return NO;
    }
    NSString *dest=[dir stringByAppendingPathComponent:name];
    if(![jpeg writeToFile:dest options:NSDataWritingAtomic error:&err]) {
        NSLog(@"[hl26-settings] Home JPEG write failed: %@",err);return NO;
    }
    [NSFileManager.defaultManager setAttributes:@{NSFilePosixPermissions:@0644}
        ofItemAtPath:dest error:nil];
    return YES;
}
- (void)homeUseImage:(UIImage *)image {
    if (![self homeWriteJPEG:image name:@"photo.jpg"] ||
        ![self homeWriteJPEG:image name:@"wallpaper.jpg"]) {
        OMCAlert(self,OMCText(@"Không lưu được ảnh nền.",@"Could not save Home wallpaper."));return;
    }
    if (!OMCNativeSetPref(@"homeScreenWallpaperStyle",@7) ||
        !OMCNativeSetPref(@"homeScreenWallpaper",@YES))
        OMCAlert(self,OMCText(@"Không lưu được trạng thái ảnh nền.",@"Wallpaper settings not saved."));
    [self.tableView reloadData];
}
- (void)homeUseVideo:(NSURL *)url {
    if(!url || self.kind!=2)return;
    NSFileManager *fm=NSFileManager.defaultManager;
    NSString *tmp=[NSTemporaryDirectory() stringByAppendingPathComponent:
        [NSString stringWithFormat:@"omc-home-import-%@.mp4",[[NSUUID UUID] UUIDString]]];
    NSError *err=nil;
    if(![fm copyItemAtURL:url toURL:[NSURL fileURLWithPath:tmp] error:&err]) {
        OMCAlert(self,err.localizedDescription?:@"Video copy failed");return;
    }
    AVURLAsset *asset=[AVURLAsset URLAssetWithURL:[NSURL fileURLWithPath:tmp] options:nil];
    AVAssetTrack *track=[asset tracksWithMediaType:AVMediaTypeVideo].firstObject;
    if(!track){[fm removeItemAtPath:tmp error:nil];
        OMCAlert(self,OMCNativeLocalized(@"APPS_VIDEO_FAILED"));return;}
    AVMutableComposition *comp=[AVMutableComposition composition];
    AVMutableCompositionTrack *video=[comp addMutableTrackWithMediaType:AVMediaTypeVideo
        preferredTrackID:kCMPersistentTrackID_Invalid];
    CMTime limit=CMTimeMinimum(asset.duration,CMTimeMakeWithSeconds(20,600));
    if(![video insertTimeRange:CMTimeRangeMake(kCMTimeZero,limit)
        ofTrack:track atTime:kCMTimeZero error:&err]){
        [fm removeItemAtPath:tmp error:nil];
        OMCAlert(self,err.localizedDescription?:@"Video track failed");return;
    }
    video.preferredTransform=track.preferredTransform;
    AVAssetExportSession *exp=[[AVAssetExportSession alloc] initWithAsset:comp
        presetName:AVAssetExportPreset1280x720];
    NSString *out=[NSTemporaryDirectory() stringByAppendingPathComponent:
        [NSString stringWithFormat:@"omc-home-export-%@.mp4",[[NSUUID UUID] UUIDString]]];
    exp.outputURL=[NSURL fileURLWithPath:out];exp.outputFileType=AVFileTypeMPEG4;
    exp.shouldOptimizeForNetworkUse=YES;
    UIAlertController *pending=[UIAlertController alertControllerWithTitle:@"DuoCar"
        message:OMCNativeLocalized(@"APPS_VIDEO_WORKING")
        preferredStyle:UIAlertControllerStyleAlert];
    [self presentViewController:pending animated:YES completion:nil];
    [exp exportAsynchronouslyWithCompletionHandler:^{
        dispatch_async(dispatch_get_main_queue(),^{
            [pending dismissViewControllerAnimated:YES completion:^{
                [fm removeItemAtPath:tmp error:nil];
                if(exp.status!=AVAssetExportSessionStatusCompleted) {
                    [fm removeItemAtPath:out error:nil];
                    OMCAlert(self,exp.error.localizedDescription?:@"Video export failed");return;
                }
                NSString *dest=[[self nativeHomeDirectory] stringByAppendingPathComponent:@"video.mp4"];
                NSError *mv=nil;
                if(![fm createDirectoryAtPath:[self nativeHomeDirectory]
                        withIntermediateDirectories:YES attributes:nil error:&mv]) {
                    [fm removeItemAtPath:out error:nil];
                    OMCAlert(self,mv.localizedDescription?:@"Home directory not writable");return;
                }
                // Stage on the destination volume. Keep the previous video
                // intact if copying or atomic replacement fails.
                NSString *stage=[[self nativeHomeDirectory] stringByAppendingPathComponent:
                    [NSString stringWithFormat:@".incoming-%@.mp4",[[NSUUID UUID] UUIDString]]];
                if(![fm copyItemAtPath:out toPath:stage error:&mv]) {
                    [fm removeItemAtPath:out error:nil];
                    OMCAlert(self,mv.localizedDescription?:@"Video staging failed");return;
                }
                BOOL installed=NO;
                if([fm fileExistsAtPath:dest]) {
                    NSURL *result=nil;
                    installed=[fm replaceItemAtURL:[NSURL fileURLWithPath:dest]
                        withItemAtURL:[NSURL fileURLWithPath:stage]
                        backupItemName:nil options:0 resultingItemURL:&result error:&mv];
                } else {
                    installed=[fm moveItemAtPath:stage toPath:dest error:&mv];
                }
                [fm removeItemAtPath:out error:nil];
                if(!installed) {
                    [fm removeItemAtPath:stage error:nil];
                    OMCAlert(self,mv.localizedDescription?:@"Video replace failed");return;
                }
                [fm setAttributes:@{NSFilePosixPermissions:@0644} ofItemAtPath:dest error:nil];
                AVAssetImageGenerator *g=[[AVAssetImageGenerator alloc]
                    initWithAsset:[AVURLAsset URLAssetWithURL:[NSURL fileURLWithPath:dest] options:nil]];
                g.appliesPreferredTrackTransform=YES;
                CGImageRef cg=[g copyCGImageAtTime:kCMTimeZero actualTime:nil error:nil];
                UIImage *thumb=cg?[UIImage imageWithCGImage:cg]:nil;
                if(cg)CGImageRelease(cg);
                if(![self homeWriteJPEG:thumb name:@"video.jpg"] ||
                   ![self homeWriteJPEG:thumb name:@"wallpaper.jpg"]) {
                    OMCAlert(self,OMCNativeLocalized(@"APPS_VIDEO_FAILED"));return;
                }
                OMCNativeSetPref(@"homeScreenWallpaperStyle",@8);
                OMCNativeSetPref(@"homeScreenWallpaper",@YES);
                [self.tableView reloadData];
            }];
        });
    }];
}
- (void)homePickerFromPhotos {
    if(![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]){
        OMCAlert(self,OMCText(@"Thư viện ảnh không khả dụng.",@"Photos unavailable."));return;
    }
    UIImagePickerController *picker=[UIImagePickerController new];
    picker.sourceType=UIImagePickerControllerSourceTypePhotoLibrary;
    picker.mediaTypes=@[UTTypeImage.identifier,UTTypeMovie.identifier];
    picker.videoExportPreset=AVAssetExportPresetPassthrough;
    picker.delegate=self;
    [self presentViewController:picker animated:YES completion:nil];
}
- (void)homePickerFromFiles {
    UIDocumentPickerViewController *picker=[[UIDocumentPickerViewController alloc]
        initForOpeningContentTypes:@[UTTypeImage,UTTypeMovie] asCopy:YES];
    picker.delegate=self;
    [self presentViewController:picker animated:YES completion:nil];
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    NSURL *video=info[UIImagePickerControllerMediaURL];
    UIImage *photo=info[UIImagePickerControllerOriginalImage];
    [picker dismissViewControllerAnimated:YES completion:^{
        if(video)[self homeUseVideo:video];else if(photo)[self homeUseImage:photo];
    }];
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
}
- (void)documentPicker:(UIDocumentPickerViewController *)picker didPickDocumentsAtURLs:(NSArray<NSURL *> *)urls {
    NSURL *url=urls.firstObject;if(!url)return;
    BOOL scope=[url startAccessingSecurityScopedResource];
    @try{
        UTType *kind=[UTType typeWithFilenameExtension:url.pathExtension];
        if([kind conformsToType:UTTypeImage])
            [self homeUseImage:[UIImage imageWithContentsOfFile:url.path]];
        else if ([kind conformsToType:UTTypeMovie])
            [self homeUseVideo:url];
        else OMCAlert(self,OMCText(@"Định dạng không hỗ trợ.",@"Unsupported format."));
    } @finally{if(scope)[url stopAccessingSecurityScopedResource];}
}
- (void)homeWallpaperOptions {
    UIAlertController *a=[UIAlertController alertControllerWithTitle:OMCNativeLocalized(@"HOMESCREEN_WALLPAPER")
        message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    [a addAction:[UIAlertAction actionWithTitle:OMCNativeLocalized(@"HOMESCREEN_WALLPAPER_DEFAULT")
        style:UIAlertActionStyleDefault handler:^(UIAlertAction *act) {
            [NSFileManager.defaultManager removeItemAtPath:[[self nativeHomeDirectory]
                stringByAppendingPathComponent:@"wallpaper.jpg"] error:nil];
            OMCNativeSetPref(@"homeScreenWallpaperStyle",@0);
            OMCNativeSetPref(@"homeScreenWallpaper",@NO);
            [self.tableView reloadData];
        }]];
    [a addAction:[UIAlertAction actionWithTitle:OMCNativeLocalized(@"APPS_FROM_PHOTOS")
        style:UIAlertActionStyleDefault handler:^(UIAlertAction *act){[self homePickerFromPhotos];}]];
    [a addAction:[UIAlertAction actionWithTitle:OMCText(@"Chọn từ Tệp",@"Choose from Files")
        style:UIAlertActionStyleDefault handler:^(UIAlertAction *act){[self homePickerFromFiles];}]];
    [a addAction:[UIAlertAction actionWithTitle:OMCText(@"Hủy",@"Cancel")
        style:UIAlertActionStyleCancel handler:nil]];
    a.popoverPresentationController.sourceView=self.view;
    a.popoverPresentationController.sourceRect=CGRectMake(CGRectGetMidX(self.view.bounds),CGRectGetMidY(self.view.bounds),1,1);
    [self presentViewController:a animated:YES completion:nil];
}
- (void)resetHome {
    UIAlertController *a=[UIAlertController alertControllerWithTitle:OMCText(@"Khôi phục Home",@"Reset Home")
        message:OMCNativeLocalized(@"HOMESCREEN_RESET_CONFIRM")
        preferredStyle:UIAlertControllerStyleAlert];
    [a addAction:[UIAlertAction actionWithTitle:OMCText(@"Hủy",@"Cancel")
        style:UIAlertActionStyleCancel handler:nil]];
    [a addAction:[UIAlertAction actionWithTitle:OMCText(@"Khôi phục",@"Reset")
        style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action){
            for (NSString *key in @[@"homeScreenGridCols",@"homeScreenGridRows",
                                    @"homeScreenIconSize",@"homeScreenShowNames",
                                    @"homeScreenBlur",@"homeScreenDim",@"homeScreenWallpaper",
                                    @"homeScreenWallpaperStyle"]) OMCNativeSetPref(key,nil);
            [self.tableView reloadData];
        }]];
    [self presentViewController:a animated:YES completion:nil];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)p {
    [tableView deselectRowAtIndexPath:p animated:YES];
    NSDictionary *r=[self rowAt:p];NSString *type=r[@"type"];
    if ([type isEqualToString:@"number"]) {[self chooseValueFor:r];return;}
    if ([type isEqualToString:@"text"]) {[self editTextFor:r];return;}
    if ([type isEqualToString:@"language"]) {[self chooseLanguage];return;}
    if ([type isEqualToString:@"favorite"]) {[self editFavorite:r];return;}
    if ([type isEqualToString:@"pickapp"]) {
        NSString *k=r[@"key"];OMCNativeAppsPage *apps=[OMCNativeAppsPage new];
        apps.onPick=^(NSString *bid) {OMCNativeSetPref(k,bid);[self.tableView reloadData];};
        [self.navigationController pushViewController:apps animated:YES];return;
    }
    if ([type isEqualToString:@"apps"]) {
        [self.navigationController pushViewController:[OMCNativeAppsPage new] animated:YES];return;
    }
    if ([type isEqualToString:@"vitals"]) {
        [self.navigationController pushViewController:OMCDeviceVitalsController() animated:YES];return;
    }
    if ([type isEqualToString:@"split"]) {
        [self.navigationController pushViewController:[[OMCNativeSimplePage alloc] initWithKind:1] animated:YES];return;
    }
    if ([type isEqualToString:@"startup"]) {
        [self.navigationController pushViewController:OMCNativeStartupController() animated:YES];return;
    }
    if ([type isEqualToString:@"bubble"]) {
        // [hl52-le-original] Open LePrefs 0.2.4 original root on first tap;
        // do not route users through DuoCar's handwritten table.
        [self.navigationController pushViewController:OMCLeOriginalPreferencesController() animated:YES];return;
    }
    if ([type isEqualToString:@"leOriginal"]) {
        [self.navigationController pushViewController:OMCLeOriginalPreferencesController() animated:YES];return;
    }
    if ([type isEqualToString:@"leCompat"]) {
        [self.navigationController pushViewController:OMCLeCompatiblePreferencesController() animated:YES];return;
    }
    if ([type isEqualToString:@"home"]) {
        [self.navigationController pushViewController:[[OMCNativeSimplePage alloc] initWithKind:2] animated:YES];return;
    }
    if ([type isEqualToString:@"profiles"]) {
        [self.navigationController pushViewController:[[OMCNativeSimplePage alloc] initWithKind:4] animated:YES];return;
    }
    if ([type isEqualToString:@"homewallpaper"]) {[self homeWallpaperOptions];return;}
    if ([type isEqualToString:@"homeapps"]) {
        OMCNativeAppsPage *page=[OMCNativeAppsPage new];
        page.homeMode=YES;
        [self.navigationController pushViewController:page animated:YES];return;
    }
    if ([type isEqualToString:@"help"]) {
        OMCAlert(self,OMCNativeLocalized(@"SPLITSCREEN_GUIDE_CAR_TEXT"));return;
    }
    if ([type isEqualToString:@"shortcuts"]) {
        NSString *urls=OMCNativeLocalized(@"SPLITSCREEN_SHORTCUTS_FOOTER");
        UIAlertController *a=[UIAlertController alertControllerWithTitle:OMCText(@"Lệnh tắt",@"Shortcuts")
            message:urls preferredStyle:UIAlertControllerStyleActionSheet];
        for(NSString *line in [urls componentsSeparatedByString:@"\n"]) {
            NSString *trim=[line stringByTrimmingCharactersInSet:NSCharacterSet.whitespaceAndNewlineCharacterSet];
            if (!trim.length)continue;
            [a addAction:[UIAlertAction actionWithTitle:trim style:UIAlertActionStyleDefault handler:^(UIAlertAction *act){
                UIPasteboard.generalPasteboard.string=trim;
            }]];
        }
        [a addAction:[UIAlertAction actionWithTitle:OMCText(@"Hủy",@"Cancel") style:UIAlertActionStyleCancel handler:nil]];
        a.popoverPresentationController.sourceView=self.view;
        a.popoverPresentationController.sourceRect=CGRectMake(CGRectGetMidX(self.view.bounds),CGRectGetMidY(self.view.bounds),1,1);
        [self presentViewController:a animated:YES completion:nil];return;
    }
    if ([type isEqualToString:@"demo"]) {notify_post("com.anlai.omnicar/speedbubble.demo");return;}
    if ([type isEqualToString:@"resetbubble"]) {
        UIAlertController *a=[UIAlertController alertControllerWithTitle:OMCNativeLocalized(@"SPEEDBUBBLE_RESET_LAYOUT")
            message:OMCText(@"Khôi phục vị trí bong bóng tốc độ?",@"Reset speed bubble position?")
            preferredStyle:UIAlertControllerStyleAlert];
        [a addAction:[UIAlertAction actionWithTitle:OMCText(@"Hủy",@"Cancel") style:UIAlertActionStyleCancel handler:nil]];
        [a addAction:[UIAlertAction actionWithTitle:OMCText(@"Khôi phục",@"Reset") style:UIAlertActionStyleDestructive handler:^(UIAlertAction *act){
            notify_post("com.anlai.omnicar/speedbubble.resetlayout");
        }]];
        [self presentViewController:a animated:YES completion:nil];return;
    }
    if ([type isEqualToString:@"resethome"]) {[self resetHome];return;}
    if ([type isEqualToString:@"respring"]) {[self confirmRespring];return;}
    if ([type isEqualToString:@"rescue"]) {[self confirmRescue];return;}
    if ([type isEqualToString:@"conflicts"]) {
        OMCAlert(self,[NSString stringWithFormat:@"%@\n%@",
            OMCNativeLocalized(@"CONFLICTS_FOOTER"),
            [OMCNativeActiveConflicts() componentsJoinedByString:@", "]]);return;
    }
    if ([type isEqualToString:@"car"]) {
        NSString *key=r[@"key"];
        UIAlertController *a=[UIAlertController alertControllerWithTitle:OMCRowName(r)
            message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        [a addAction:[UIAlertAction actionWithTitle:OMCText(@"Chọn xe này",@"Select car")
            style:UIAlertActionStyleDefault handler:^(UIAlertAction *act){
                OMCNativeSetPref(@"carProfileCurrent",key);[self.tableView reloadData];
            }]];
        [a addAction:[UIAlertAction actionWithTitle:OMCText(@"Quên xe này",@"Forget car")
            style:UIAlertActionStyleDestructive handler:^(UIAlertAction *act){
                NSMutableDictionary *all=[OMCNativePref(@"carProfiles",@{}) mutableCopy];
                [all removeObjectForKey:key];
                OMCNativeSetPref(@"carProfiles",all);
                self.sections=[self makeSections];[self.tableView reloadData];
            }]];
        [a addAction:[UIAlertAction actionWithTitle:OMCText(@"Hủy",@"Cancel")
            style:UIAlertActionStyleCancel handler:nil]];
        a.popoverPresentationController.sourceView=self.view;
        a.popoverPresentationController.sourceRect=CGRectMake(CGRectGetMidX(self.view.bounds),CGRectGetMidY(self.view.bounds),1,1);
        [self presentViewController:a animated:YES completion:nil];return;
    }
    if ([type isEqualToString:@"guide"]||[type isEqualToString:@"whatsnew"]) {
        BOOL whatsNew=[type isEqualToString:@"whatsnew"];
        UIViewController *vc=[UIViewController new];
        vc.title=whatsNew?OMCNativeLocalized(@"WN_ROW"):OMCNativeLocalized(@"ONB_SHOW_AGAIN");
        vc.view.backgroundColor=UIColor.systemBackgroundColor;
        UITextView *text=[[UITextView alloc] initWithFrame:CGRectZero];
        text.translatesAutoresizingMaskIntoConstraints=NO;
        text.editable=NO;text.selectable=YES;
        text.font=[UIFont preferredFontForTextStyle:UIFontTextStyleBody];
        NSMutableArray *paragraphs=[NSMutableArray array];
        if (whatsNew) {
            for (NSString *key in @[@"WN_ZOOM_TEXT",@"WN_KEYBOARD_TEXT",@"WN_LANG_TITLE"]) {
                NSString *v=OMCNativeLocalized(key);if(![v isEqualToString:key])[paragraphs addObject:v];
            }
        } else {
            for(NSInteger i=1;i<=4;i++){
                NSString *t=[NSString stringWithFormat:@"ONB_P%ld_TITLE",(long)i];
                NSString *b=[NSString stringWithFormat:@"ONB_P%ld_BODY",(long)i];
                [paragraphs addObject:[NSString stringWithFormat:@"%@\n%@",
                    OMCNativeLocalized(t),OMCNativeLocalized(b)]];
            }
        }
        text.text=[paragraphs componentsJoinedByString:@"\n\n"];
        [vc.view addSubview:text];
        [NSLayoutConstraint activateConstraints:@[
            [text.leadingAnchor constraintEqualToAnchor:vc.view.safeAreaLayoutGuide.leadingAnchor constant:16],
            [text.trailingAnchor constraintEqualToAnchor:vc.view.safeAreaLayoutGuide.trailingAnchor constant:-16],
            [text.topAnchor constraintEqualToAnchor:vc.view.safeAreaLayoutGuide.topAnchor constant:16],
            [text.bottomAnchor constraintEqualToAnchor:vc.view.safeAreaLayoutGuide.bottomAnchor constant:-16]
        ]];
        [self.navigationController pushViewController:vc animated:YES];return;
    }
    if ([type isEqualToString:@"logs"]) {
        NSMutableString *report=[NSMutableString stringWithFormat:
            @"DuoCar iPhone settings report\nEnabled: %@\nLanguage: %@\n",
            OMCNativePref(@"enabled",@YES),OMCNativePref(@"language",@"en")];
        for (NSString *f in @[@"/var/mobile/Documents/OmniCar.log.old",
                              @"/var/mobile/Documents/OmniCar.log"]) {
            NSString *body=[NSString stringWithContentsOfFile:f encoding:NSUTF8StringEncoding error:nil];
            [report appendFormat:@"\n=== %@ ===\n%@\n",f,body?:@"(not available)"];
        }
        NSString *file=[NSTemporaryDirectory() stringByAppendingPathComponent:@"OmniCar-report.txt"];
        if (![report writeToFile:file atomically:YES encoding:NSUTF8StringEncoding error:nil]) {
            OMCAlert(self,OMCText(@"Không tạo được báo cáo.",@"Could not write report."));return;
        }
        UIActivityViewController *share=[[UIActivityViewController alloc]
             initWithActivityItems:@[[NSURL fileURLWithPath:file]] applicationActivities:nil];
        share.popoverPresentationController.sourceView=self.view;
        share.popoverPresentationController.sourceRect=CGRectMake(CGRectGetMidX(self.view.bounds),
                                                                 CGRectGetMidY(self.view.bounds),1,1);
        [self presentViewController:share animated:YES completion:nil];return;
    }
}
@end

UIViewController *OMCNativeSettingsRootController(void) {
    UITabBarController *root=[UITabBarController new];
    OMCNativeAppsPage *apps=[OMCNativeAppsPage new];
    OMCNativeSimplePage *split=[[OMCNativeSimplePage alloc] initWithKind:1];
    OMCNativeSimplePage *settings=[[OMCNativeSimplePage alloc] initWithKind:0];
    UINavigationController *a=[[UINavigationController alloc] initWithRootViewController:apps];
    UINavigationController *b=[[UINavigationController alloc] initWithRootViewController:split];
    UINavigationController *c=[[UINavigationController alloc] initWithRootViewController:settings];
    a.tabBarItem=[[UITabBarItem alloc] initWithTitle:OMCText(@"Ứng dụng",@"Apps")
                                              image:[UIImage systemImageNamed:@"square.grid.2x2.fill"] tag:0];
    b.tabBarItem=[[UITabBarItem alloc] initWithTitle:OMCText(@"Chia màn",@"Split")
                                              image:[UIImage systemImageNamed:@"rectangle.split.2x1"] tag:1];
    c.tabBarItem=[[UITabBarItem alloc] initWithTitle:OMCText(@"Cài đặt",@"Settings")
                                              image:[UIImage systemImageNamed:@"gearshape.fill"] tag:2];
    root.viewControllers=@[a,b,c];
    root.selectedIndex=2;
    NSLog(@"[hl26-settings] gate=uikit-tab-ready tabs=3 domain=%@",kOMCNativeDomain);
    return root;
}
