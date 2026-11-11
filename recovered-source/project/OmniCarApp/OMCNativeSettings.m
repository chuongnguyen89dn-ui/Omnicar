// HL26: UIKit-owned iPhone settings. Do not instantiate Settings.app Preferences controllers.
// All values use the same domain/key/notify contract as OmniCarPrefs and the CarPlay owner.
#import "OMCNativeSettings.h"
#import <CoreFoundation/CoreFoundation.h>
#import <objc/message.h>
#import <objc/runtime.h>
#import <dlfcn.h>
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

@interface OMCNativeSimplePage : UITableViewController
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
            SEL bidSel=NSSelectorFromString(@"applicationIdentifier");
            SEL titleSel=NSSelectorFromString(@"localizedName");
            if (![proxy respondsToSelector:bidSel]) continue;
            id bid=((id(*)(id,SEL))objc_msgSend)(proxy,bidSel);
            if (![bid isKindOfClass:NSString.class] || ![bid length] ||
                [bid hasPrefix:@"com.apple.springboard"] ||
                [bid hasPrefix:@"com.anlai.omnicar"]) continue;
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
        if (carIDs.count)self.inventory=[self.inventory filteredArrayUsingPredicate:
            [NSPredicate predicateWithBlock:^BOOL(NSDictionary *a,NSDictionary *ctx){
                return [carIDs containsObject:a[@"id"]];
            }]];
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
    if (self.kind==0) return @[
        OMCSection(OMCText(@"Tổng quan",@"Overview"),@[
            OMCRow(OMCText(@"Bật DuoCar",@"Enable DuoCar"),@"switch",@"enabled",@YES,nil),
            OMCRow(OMCText(@"Ngôn ngữ",@"Language"),@"language",nil,nil,nil)]),
        OMCSection(OMCNativeLocalized(@"FEATURES_GROUP"),@[
            OMCRow(@"STARTUPSCREEN",@"startup",nil,nil,nil),
            OMCRow(@"SPEEDBUBBLE",@"bubble",nil,nil,nil),
            OMCRow(@"HOME_SCREEN",@"home",nil,nil,nil),
            OMCRow(@"PROFILES",@"profiles",nil,nil,nil)]),
        OMCSection(OMCText(@"Hỗ trợ",@"Support"),@[
            OMCRow(@"ONB_SHOW_AGAIN",@"guide",nil,nil,nil),
            OMCRow(@"WN_ROW",@"whatsnew",nil,nil,nil),
            OMCRow(@"SEND_LOG",@"logs",nil,nil,nil),
            OMCRow(OMCText(@"Respring (xác nhận)",@"Respring (confirm)"),@"respring",nil,nil,nil)])
    ];
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
                OMCRow(@"SPLITSCREEN_SHOW_FAVORITES",@"switch",@"splitScreenShowFavorites",@YES,nil)])
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
        OMCSection(OMCText(@"Ứng dụng trên Home",@"Home applications"),@[
            OMCRow(@"APPS",@"homeapps",nil,nil,nil),
            OMCRow(OMCText(@"Khôi phục bố cục Home",@"Reset Home layout"),@"resethome",nil,nil,nil)])
    ];
    if (self.kind==3) return @[
        OMCSection(@"SPEEDBUBBLE",@[
            OMCRow(@"SPEEDBUBBLE_ENABLE",@"switch",@"speedBubbleEnabled",@YES,nil),
            OMCRow(@"SPEEDBUBBLE_SHOW_APP_ICON",@"switch",@"speedBubbleShowAppIcon",@YES,nil),
            OMCRow(OMCText(@"Kiểu hiển thị",@"Appearance"),@"number",@"speedBubbleLook",@0,@[@0,@1,@2,@3,@4,@5]),
            OMCRow(OMCText(@"Nguồn tốc độ",@"Speed source"),@"number",@"speedBubbleSource",@0,@[@0,@1,@2,@3]),
            OMCRow(OMCText(@"Màu sắc",@"Color"),@"number",@"speedBubbleColor",@0,@[@0,@1,@2,@3,@4,@5,@6]),
            OMCRow(OMCText(@"Kích thước xe (%)",@"Car size (%)"),@"number",@"speedBubbleSizeCar",@100,@[@60,@70,@80,@90,@100,@110,@120,@130,@140,@150]),
            OMCRow(OMCText(@"Kích thước điện thoại (%)",@"Phone size (%)"),@"number",@"speedBubbleSizePhone",@100,@[@60,@80,@100,@120,@140])]),
        OMCSection(OMCText(@"Cảnh báo",@"Alerts"),@[
            OMCRow(OMCText(@"Chế độ cảnh báo",@"Warning mode"),@"number",@"speedBubbleWarnMode",@3,@[@0,@1,@2,@3]),
            OMCRow(OMCText(@"Hiệu ứng cảnh báo",@"Warning effect"),@"number",@"speedBubbleWarnFx",@0,@[@0,@1,@2,@3]),
            OMCRow(OMCText(@"Ngưỡng cảnh báo",@"Over-limit threshold"),@"number",@"speedBubbleWarnOver",@5,@[@(-10),@(-5),@0,@5,@10]),
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
- (void)chooseValueFor:(NSDictionary *)r {
    NSString *key=r[@"key"];NSArray *values=r[@"choices"];
    UIAlertController *a=[UIAlertController alertControllerWithTitle:OMCRowName(r)
        message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    for (id v in values) {
        NSString *name=[v description];
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
    for (NSInteger i=1;i<=4;i++) {
        NSString *key=[base stringByAppendingFormat:@"App%ld",(long)i];
        NSString *name=[NSString stringWithFormat:@"%@ %ld",OMCText(@"Ô",@"Slot"),(long)i];
        [a addAction:[UIAlertAction actionWithTitle:name style:UIAlertActionStyleDefault handler:^(UIAlertAction *x){
            OMCNativeAppsPage *page=[OMCNativeAppsPage new];
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
    if ([type isEqualToString:@"homeapps"]) {
        OMCNativeAppsPage *page=[OMCNativeAppsPage new];
        page.homeMode=YES;
        [self.navigationController pushViewController:page animated:YES];return;
    }
    if ([type isEqualToString:@"demo"]) {notify_post("com.anlai.omnicar/speedbubble.demo");return;}
    if ([type isEqualToString:@"resethome"]) {[self resetHome];return;}
    if ([type isEqualToString:@"respring"]) {[self confirmRespring];return;}
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
        OMCAlert(self,OMCText(@"Cài đặt DuoCar hiện đã chuyển vào ứng dụng iPhone. Các tính năng CarPlay vẫn dùng cấu hình trước đây.",
                              @"DuoCar settings now live in the iPhone app. Existing CarPlay preferences are preserved."));return;
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
