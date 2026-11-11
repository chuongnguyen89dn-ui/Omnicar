// HL26: UIKit-owned iPhone settings. Do not instantiate Settings.app Preferences controllers.
// All values use the same domain/key/notify contract as OmniCarPrefs and the CarPlay owner.
#import "OMCNativeSettings.h"
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

NSString *OMCNativeLocalized(NSString *key) {
    if (!key.length) return @"";
    NSBundle *b=NSBundle.mainBundle;
    for (NSString *t in @[@"Localizable",@"AppBridge",@"HomeScreen",@"Profiles",
                          @"SplitScreen",@"SpeedBubble",@"StartupScreen",@"Onboarding",@"WhatsNew"]) {
        NSString *s=NSLocalizedStringFromTableInBundle(key,t,b,key);
        if (![s isEqualToString:key]) return s;
    }
    return key;
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
static BOOL OMCVi(void) { return [[[NSLocale preferredLanguages] firstObject] hasPrefix:@"vi"]; }
static NSString *OMCText(NSString *vi,NSString *en) {return OMCVi()?vi:en;}
static NSString *OMCRowName(NSDictionary *r) {
    NSString *key=r[@"label"];
    return key.length?OMCNativeLocalized(key):@"";
}
static NSDictionary *OMCRow(NSString *label,NSString *type,NSString *key,id def,NSArray *choices) {
    NSMutableDictionary *r=[@{@"label":label?:@"",@"type":type?:@"link"} mutableCopy];
    if (key) r[@"key"]=key;
    if (def) r[@"default"]=def;
    if (choices) r[@"choices"]=choices;
    return r;
}
static NSDictionary *OMCSliderRow(NSString *label,NSString *key,NSInteger fallback,NSInteger minimum,NSInteger maximum) {
    NSMutableDictionary *row=[OMCRow(label,@"slider",key,@(fallback),nil) mutableCopy];
    row[@"min"]=@(minimum);row[@"max"]=@(maximum);return row;
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
        NSArray *titles=@[@"Cài đặt",@"Chia màn hình",@"Màn hình Home",@"Bong bóng tốc độ",@"Hồ sơ xe"];
        self.title=titles[MAX(0,MIN(kind,4))];
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
        [sections addObject:OMCSection(OMCText(@"Tổng quan",@"Overview"),@[
            OMCRow(OMCText(@"Bật DuoCar",@"Enable DuoCar"),@"switch",@"enabled",@YES,nil),
            OMCRow(OMCText(@"Ngôn ngữ",@"Language"),@"language",nil,nil,nil)])];
        [sections addObject:OMCSection(OMCNativeLocalized(@"FEATURES_GROUP"),@[
            OMCRow(@"STARTUPSCREEN",@"startup",nil,nil,nil),
            OMCRow(@"SPEEDBUBBLE",@"bubble",nil,nil,nil),
            OMCRow(@"HOME_SCREEN",@"home",nil,nil,nil),
            OMCRow(@"PROFILES",@"profiles",nil,nil,nil)])];
        [sections addObject:OMCSection(OMCText(@"Hỗ trợ",@"Support"),@[
            OMCRow(@"ONB_SHOW_AGAIN",@"guide",nil,nil,nil),
            OMCRow(@"WN_ROW",@"whatsnew",nil,nil,nil),
            OMCRow(@"SEND_LOG",@"logs",nil,nil,nil),
            OMCRow(OMCText(@"Respring (xác nhận)",@"Respring (confirm)"),@"respring",nil,nil,nil)])];
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
    if (self.kind==3) return @[
        OMCSection(@"SPEEDBUBBLE",@[
            OMCRow(@"SPEEDBUBBLE_ENABLE",@"switch",@"speedBubbleEnabled",@YES,nil),
            OMCRow(@"SPEEDBUBBLE_SHOW_APP_ICON",@"switch",@"speedBubbleShowAppIcon",@YES,nil),
            OMCRow(OMCText(@"Kiểu hiển thị",@"Appearance"),@"number",@"speedBubbleLook",@0,@[@0,@1,@2,@3,@4,@5,@6,@7,@8]),
            OMCRow(OMCText(@"Nguồn tốc độ",@"Speed source"),@"number",@"speedBubbleSource",@0,@[@0,@1,@2,@3]),
            OMCRow(OMCText(@"Màu sắc",@"Color"),@"number",@"speedBubbleColor",@0,@[@0,@1,@2,@3,@4,@5,@6]),
            OMCSliderRow(OMCText(@"Kích thước xe (%)",@"Car size (%)"),@"speedBubbleSizeCar",100,60,220),
            OMCSliderRow(OMCText(@"Kích thước điện thoại (%)",@"Phone size (%)"),@"speedBubbleSizePhone",100,60,220),
            OMCRow(@"SPEEDBUBBLE_RESET_LAYOUT",@"resetbubble",nil,nil,nil)]),
        OMCSection(OMCText(@"Cảnh báo",@"Alerts"),@[
            OMCRow(OMCText(@"Chế độ cảnh báo",@"Warning mode"),@"number",@"speedBubbleWarnMode",@3,@[@0,@1,@2,@3]),
            OMCRow(OMCText(@"Hiệu ứng cảnh báo",@"Warning effect"),@"number",@"speedBubbleWarnFx",@0,@[@0,@1,@2,@3]),
            OMCSliderRow(OMCText(@"Ngưỡng cảnh báo",@"Over-limit threshold"),@"speedBubbleWarnOver",5,-10,10),
            OMCRow(OMCText(@"Âm cảnh báo",@"Warning sound"),@"number",@"speedBubbleWarnSound",@0,@[@0,@1]),
            OMCRow(OMCText(@"Tiếng cảnh báo",@"Warning tone"),@"number",@"speedBubbleWarnTone",@0,@[@0,@1,@2,@3,@4,@5]),
            OMCRow(OMCText(@"Lời nhắc",@"Warning voice"),@"number",@"speedBubbleWarnVoice",@0,@[@0,@1,@2,@3,@4,@5,@6,@7,@8]),
            OMCRow(OMCText(@"Tùy chỉnh lời nhắc",@"Custom warning text"),@"text",@"speedBubbleWarnVoiceText",@"",nil)]),
        OMCSection(OMCText(@"Kiểm tra",@"Testing"),@[
            OMCRow(OMCText(@"Xem thử trên xe",@"Try on car"),@"demo",nil,nil,nil)])
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
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.sections=[self makeSections];
    [self.tableView reloadData];
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
        cell.detailTextLabel.text=value?[value description]:OMCText(@"Chưa chọn",@"Not set");
    } else if ([type isEqualToString:@"car"]) {
        cell.detailTextLabel.text=[OMCNativePref(@"carProfileCurrent",@"") isEqual:key]
            ?@"✓":@"";
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
        NSString *name=[v description];
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
                if (OMCNativeSetPref(@"language",code)) [self.tableView reloadData];
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
- (void)confirmRespring {
    UIAlertController *a=[UIAlertController alertControllerWithTitle:@"Respring"
         message:OMCText(@"Khởi động lại giao diện SpringBoard?",@"Restart SpringBoard UI?")
         preferredStyle:UIAlertControllerStyleAlert];
    [a addAction:[UIAlertAction actionWithTitle:OMCText(@"Hủy",@"Cancel")
        style:UIAlertActionStyleCancel handler:nil]];
    [a addAction:[UIAlertAction actionWithTitle:@"Respring"
        style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action){
            // Use exactly the original FrontBoardServices respring contract.
            // No guessed Darwin channel and no killall fallback.
            dlopen("/System/Library/PrivateFrameworks/FrontBoardServices.framework/FrontBoardServices",RTLD_LAZY);
            dlopen("/System/Library/PrivateFrameworks/SpringBoardServices.framework/SpringBoardServices",RTLD_LAZY);
            Class actionClass=NSClassFromString(@"SBSRelaunchAction");
            Class serviceClass=NSClassFromString(@"FBSSystemService");
            SEL actionSelector=NSSelectorFromString(@"actionWithReason:options:targetURL:");
            SEL serviceSelector=NSSelectorFromString(@"sharedService");
            SEL sendSelector=NSSelectorFromString(@"sendActions:withResult:");
            if (actionClass&&[actionClass respondsToSelector:actionSelector]&&
                serviceClass&&[serviceClass respondsToSelector:serviceSelector]){
                id result=((id(*)(id,SEL,id,NSUInteger,id))objc_msgSend)(
                     actionClass,actionSelector,@"RestartRenderServer",4,nil);
                id service=((id(*)(id,SEL))objc_msgSend)(serviceClass,serviceSelector);
                if (result&&service&&[service respondsToSelector:sendSelector]){
                    ((void(*)(id,SEL,id,id))objc_msgSend)(service,sendSelector,
                        [NSSet setWithObject:result],nil);
                    return;
                }
            }
            OMCAlert(self,OMCText(@"Respring không khả dụng trên thiết bị này.",
                @"Respring unavailable on this device."));
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
                [fm createDirectoryAtPath:[self nativeHomeDirectory] withIntermediateDirectories:YES attributes:nil error:nil];
                [fm removeItemAtPath:dest error:nil];
                NSError *mv=nil;
                if(![fm moveItemAtPath:out toPath:dest error:&mv]) {
                    OMCAlert(self,mv.localizedDescription?:@"Video write failed");return;
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
    if ([type isEqualToString:@"startup"]) {
        [self.navigationController pushViewController:OMCNativeStartupController() animated:YES];return;
    }
    if ([type isEqualToString:@"bubble"]) {
        [self.navigationController pushViewController:[[OMCNativeSimplePage alloc] initWithKind:3] animated:YES];return;
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
