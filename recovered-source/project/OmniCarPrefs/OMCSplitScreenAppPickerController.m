// OMCSplitScreenAppPickerController.m — OmniCarPrefs reconstruction (Prefs-B)
// All methods VERIFIED against the disassembly (loadView 0x363b0,
// viewDidLoad 0x36438, currentValue 0x36cc8, cellForRowAtIndexPath:
// 0x36f18, didSelectRowAtIndexPath: 0x37444). App enumeration uses
// LSApplicationWorkspace through dynamic dispatch (sub_378b8), exactly
// like the App Bridge page; the CarPlay test is the seed set at
// 0x7fbe8 (VERIFIED contents) or the entitlements check (sub_24e90
// pattern: com.apple.developer.carplay* / playable-content keys).
#import "OMCSplitScreenAppPickerController.h"
#import "OMCCommon.h"
#import <Preferences/PSSpecifier.h> // [integration phase 1; backported to src in phase 3] declares PSSpecifier used in this file
#import <notify.h>

static id SSPickPref(NSString *key) {                    // sub_36280
    return CFBridgingRelease(CFPreferencesCopyAppValue((__bridge CFStringRef)key,
                                                       CFSTR("com.anlai.omnicar")));
}
static void SSPickSetPref(NSString *key, id value) {     // sub_37698
    CFPreferencesSetAppValue((__bridge CFStringRef)key, (__bridge CFPropertyListRef)value,
                             CFSTR("com.anlai.omnicar"));
    CFPreferencesAppSynchronize(CFSTR("com.anlai.omnicar"));
}
static id SSPickGet(id obj, NSString *name) {            // sub_24d80 pattern
    SEL sel = NSSelectorFromString(name);
    if (![obj respondsToSelector:sel]) return nil;
    return [obj performSelector:sel];
}
static NSArray *SSPickInstalled(void) {                  // sub_378b8
    Class ws = NSClassFromString(@"LSApplicationWorkspace");
    id workspace = SSPickGet(ws, @"defaultWorkspace");
    id apps = SSPickGet(workspace, @"allInstalledApplications");
    return [apps isKindOfClass:[NSArray class]] ? apps : @[];
}
static BOOL SSPickEntitled(id proxy) {                   // sub_24e90 pattern
    NSDictionary *ent = SSPickGet(proxy, @"entitlements");
    if (![ent isKindOfClass:[NSDictionary class]]) return NO;
    for (NSString *key in ent)
        if ([key hasPrefix:@"com.apple.developer.carplay"] ||
            [key isEqualToString:@"com.apple.developer.playable-content"])
            return YES;
    return NO;
}
// sub_36a7c: [{id, name}] for the given bundle ids, deduped, sorted by name.
static NSArray *SSPickRows(NSArray *ids, NSArray *proxies) {
    NSMutableArray *rows = [NSMutableArray array];
    NSMutableArray *seen = [NSMutableArray array];
    for (id raw in ids) {
        if (![raw isKindOfClass:[NSString class]]) continue;
        NSString *bid = raw;
        if (bid.length == 0 || [seen containsObject:bid]) continue;
        [seen addObject:bid];
        NSString *name = bid;
        for (id proxy in proxies)
            if ([[SSPickGet(proxy, @"bundleIdentifier") description] isEqualToString:bid]) {
                id ln = SSPickGet(proxy, @"localizedName");
                if ([ln isKindOfClass:[NSString class]]) name = ln;
                break;
            }
        [rows addObject:@{@"id": bid, @"name": name}];
    }
    [rows sortUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"name"
                                                               ascending:YES
                                                                selector:@selector(localizedCaseInsensitiveCompare:)]]];
    return rows;
}

@interface UIImage (OMCPickerIcon)
+ (UIImage *)_applicationIconImageForBundleIdentifier:(NSString *)bundleID
                                               format:(int)format scale:(double)scale;
@end

@implementation OMCSplitScreenAppPickerController

- (void)loadView {
    self.table = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    self.table.dataSource = self;
    self.table.delegate = self;
    self.table.rowHeight = 52;
    self.view = self.table;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    OMCLoadStrings();
    self.title = self.specifier.name;
    self.view.tintColor = OMCAccentColor();
    self.table.backgroundColor = OMCBackgroundColor();

    CFPreferencesAppSynchronize(CFSTR("com.anlai.omnicar"));
    id saved = SSPickPref(@"splitScreenCarPlayApps");
    self.fromCar = [saved isKindOfClass:[NSArray class]] && [(NSArray *)saved count] > 0;

    NSArray *proxies = SSPickInstalled();
    // Section 1 ids: saved selection first (when it exists), then every
    // seed/entitled CarPlay app found installed.
    NSMutableArray *carIDs = [NSMutableArray array];
    if (self.fromCar) [carIDs addObjectsFromArray:saved];
    NSSet *seed = [NSSet setWithArray:@[@"com.apple.Maps", @"com.apple.Music",
                                        @"com.apple.podcasts", @"com.apple.mobilephone",
                                        @"com.apple.MobileSMS", @"com.apple.iBooks",
                                        @"com.apple.news", @"com.apple.mobilecal"]];
    for (id proxy in proxies) {
        id bid = SSPickGet(proxy, @"bundleIdentifier");
        if (![bid isKindOfClass:[NSString class]] || [bid length] == 0) continue;
        if ([seed containsObject:bid] || SSPickEntitled(proxy))
            [carIDs addObject:bid];
    }
    self.carPlayApps = SSPickRows(carIDs, proxies);

    // Section 2 ids: the App Bridge selection (pref appBridgeApps).
    NSMutableArray *phoneIDs = [NSMutableArray array];
    id bridge = SSPickPref(@"appBridgeApps");
    if ([bridge isKindOfClass:[NSArray class]] && [(NSArray *)bridge count] > 0) {
        NSSet *wanted = [NSSet setWithArray:bridge];
        for (id proxy in proxies) {
            id bid = SSPickGet(proxy, @"bundleIdentifier");
            if ([bid isKindOfClass:[NSString class]] && [bid length] > 0 &&
                [wanted containsObject:bid])
                [phoneIDs addObject:bid];
        }
    }
    self.phoneApps = SSPickRows(phoneIDs, proxies);
}

- (NSString *)currentValue {
    NSString *key = [self.specifier propertyForKey:@"key"];
    id value = key ? SSPickPref(key) : nil;
    return [value isKindOfClass:[NSString class]] ? value : nil;
}

- (NSArray *)rowsInSection:(NSInteger)section {
    return section == 1 ? self.carPlayApps : self.phoneApps;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tv { return 3; }

- (NSInteger)tableView:(UITableView *)tv numberOfRowsInSection:(NSInteger)section {
    if (section == 0) return 1;
    return (NSInteger)[self rowsInSection:section].count;
}

- (NSString *)tableView:(UITableView *)tv titleForHeaderInSection:(NSInteger)section {
    if (section == 1) return L(@"SPLITSCREEN_PICKER_CARPLAY_APPS");
    if (section == 2) return L(@"SPLITSCREEN_PICKER_PHONE_APPS");
    return nil;
}

- (NSString *)tableView:(UITableView *)tv titleForFooterInSection:(NSInteger)section {
    if (section == 1)
        return self.fromCar ? nil : L(@"SPLITSCREEN_PICKER_GUESS_FOOTER");
    if (section == 2)
        return self.phoneApps.count ? L(@"SPLITSCREEN_PICKER_PHONE_FOOTER")
                                    : L(@"SPLITSCREEN_PICKER_NO_PHONE_FOOTER");
    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tv cellForRowAtIndexPath:(NSIndexPath *)ip {
    UITableViewCell *cell = [tv dequeueReusableCellWithIdentifier:@"app"];
    if (!cell)
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                      reuseIdentifier:@"app"];
    cell.backgroundColor = OMCCardColor();
    NSString *current = [self currentValue];
    if (ip.section == 0) {
        cell.textLabel.text = L(@"SPLITSCREEN_PICKER_NONE");
        cell.detailTextLabel.text = nil;
        UIImageSymbolConfiguration *cfg =
            [UIImageSymbolConfiguration configurationWithPointSize:22 weight:UIImageSymbolWeightRegular];
        cell.imageView.image = [[UIImage systemImageNamed:@"nosign" withConfiguration:cfg]
            imageWithTintColor:[UIColor tertiaryLabelColor]
                 renderingMode:UIImageRenderingModeAlwaysOriginal];
        cell.accessoryType = current == nil ? UITableViewCellAccessoryCheckmark
                                            : UITableViewCellAccessoryNone;
        return cell;
    }
    NSDictionary *app = [self rowsInSection:ip.section][ip.row];
    cell.textLabel.text = app[@"name"];
    cell.detailTextLabel.text = app[@"id"];
    cell.detailTextLabel.textColor = [UIColor secondaryLabelColor];
    UIImage *icon = nil;
    if ([UIImage respondsToSelector:@selector(_applicationIconImageForBundleIdentifier:format:scale:)])
        icon = [UIImage _applicationIconImageForBundleIdentifier:app[@"id"]
                                                           format:2
                                                            scale:[UIScreen mainScreen].scale];
    if (icon) {
        UIGraphicsImageRenderer *renderer =
            [[UIGraphicsImageRenderer alloc] initWithSize:CGSizeMake(36, 36)];
        icon = [renderer imageWithActions:^(UIGraphicsImageRendererContext *ctx) {
            [[UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, 36, 36)
                                        cornerRadius:9] addClip];
            [icon drawInRect:CGRectMake(0, 0, 36, 36)];
            (void)ctx;
        }];
    }
    cell.imageView.image = icon;
    cell.accessoryType = [app[@"id"] isEqualToString:current]
        ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
    return cell;
}

- (void)tableView:(UITableView *)tv didSelectRowAtIndexPath:(NSIndexPath *)ip {
    [tv deselectRowAtIndexPath:ip animated:YES];
    NSString *key = [self.specifier propertyForKey:@"key"];
    if (![key isKindOfClass:[NSString class]]) return;
    NSString *value = nil;
    if (ip.section != 0)
        value = [self rowsInSection:ip.section][ip.row][@"id"];
    SSPickSetPref(key, value);
    notify_post("com.anlai.omnicar/prefschanged");
    [self.table reloadData];
    // Ask the parent list controller to refresh this specifier.
    id parent = nil;
    SEL parentSel = NSSelectorFromString(@"parentController");
    if ([self respondsToSelector:parentSel])
        parent = [self performSelector:parentSel];
    if ([parent respondsToSelector:@selector(reloadSpecifier:)])
        [parent performSelector:@selector(reloadSpecifier:) withObject:self.specifier];
    // After 250 ms the controller pops (the delayed block @0x37714 only
    // pops; the value is written exactly once, by the SSPickSetPref call
    // above).
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 250 * NSEC_PER_MSEC),
                   dispatch_get_main_queue(), ^{
        [self.navigationController popViewControllerAnimated:YES];
    });
}

@end
