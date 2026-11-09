// OMCAppBridgeAppsController.m — reconstructed from OmniCarPrefs (OmniCar 1.0.3)
// by static analysis (capstone disassembly of the arm64 slice; every method
// below was read instruction-by-instruction — see PrefsB_REPORT.md for the
// per-method evidence/status table).
//
// Preference domain for everything: "com.anlai.omnicar" (CFPreferences app
// domain). Every committed write synchronizes and posts the Darwin
// notification "com.anlai.omnicar/prefschanged".

#import "OMCAppBridgeAppsController.h"
#import "OMCCommon.h"
#import "OMCHSPreview.h"
#import <Preferences/PSSpecifier.h> // [integration phase 1; backported to src in phase 3] self.specifier's class must be fully declared, not @class-forwarded
#import <objc/runtime.h>
#import <objc/message.h> // [integration phase 1; backported to src in phase 3] declares objc_msgSend used below
#include <notify.h>
#import <AVFoundation/AVFoundation.h>
#import <UniformTypeIdentifiers/UniformTypeIdentifiers.h>

static NSString * const kOMCDomain = @"com.anlai.omnicar";

// Shared id->name map (global at 0x90018 in the original): written by
// -loadState below from the homeScreenCarApps entries, read by the
// sub_1c620 name lookup in OMCHSPreview.m. Defined in OMCHSPreview.m.
extern NSMutableDictionary *OMCHSNameMap;

// ---- per-TU static preference helpers (the binary carries several identical
// ---- copies of these in different translation units) -----------------------
static id OMCPrefRead(NSString *key) {           // sub_1cd84
    return CFBridgingRelease(CFPreferencesCopyAppValue((__bridge CFStringRef)key,
                                                         (__bridge CFStringRef)kOMCDomain));
}
static void OMCPrefWrite(NSString *key, id value) {  // sub_1cda0 / sub_21eb8
    CFPreferencesSetAppValue((__bridge CFStringRef)key, (__bridge CFPropertyListRef)value,
                             (__bridge CFStringRef)kOMCDomain);
    CFPreferencesAppSynchronize((__bridge CFStringRef)kOMCDomain);
    notify_post("com.anlai.omnicar/prefschanged");
}
static NSArray *OMCPrefArray(NSString *key) {    // sub_1dc60
    id v = OMCPrefRead(key);
    return [v isKindOfClass:[NSArray class]] ? v : @[];
}
static id OMCPrefOrDef(NSString *key, id def) {  // sub_1dcc4
    id v = OMCPrefRead(key);
    return v ?: def;
}
static NSArray *OMCAppBridgeAppsPref(void) {     // sub_1b510
    CFPreferencesAppSynchronize((__bridge CFStringRef)kOMCDomain);
    return OMCPrefArray(@"appBridgeApps");
}

// Dynamic (string-named) property access on private-API objects.
static id OMCDynObj(id obj, NSString *name) {    // sub_24d80
    SEL sel = NSSelectorFromString(name);
    if (obj && [obj respondsToSelector:sel])
        return ((id (*)(id, SEL))objc_msgSend)(obj, sel);
    return nil;
}
static BOOL OMCDynBool(id obj, NSString *name) { // sub_24e0c
    SEL sel = NSSelectorFromString(name);
    if (obj && [obj respondsToSelector:sel])
        return ((BOOL (*)(id, SEL))objc_msgSend)(obj, sel);
    return NO;
}
// YES when the app proxy's entitlements contain a CarPlay entitlement key.
static BOOL OMCHasCarPlayEntitlement(id proxy) { // sub_24e90 (tail comparison INFERRED)
    NSDictionary *ent = OMCDynObj(proxy, @"entitlements");
    if (![ent isKindOfClass:[NSDictionary class]]) return NO;
    for (NSString *k in ent) {
        if ([k isKindOfClass:[NSString class]] &&
            ([k hasPrefix:@"com.apple.developer.carplay"] ||
             [k hasPrefix:@"com.apple.developer.playable-content"]))
            return YES;
    }
    return NO;
}

// <datadir> = realpath("/var/mobile/Library/OmniCar") so the rootless
// /var/jb symlink resolves to the real location.
static NSString *OMCDataPath(NSString *rel) {
    char buf[4096];
    NSString *base = @"/var/mobile/Library/OmniCar";
    if (realpath(base.fileSystemRepresentation, buf))
        base = [NSString stringWithUTF8String:buf];
    return rel ? [base stringByAppendingPathComponent:rel] : base;
}

// Icon loader (sibling TU helper, also used by OMCHSPreview): app icon at a
// point size via the private icon services. Not to be confused with
// _OMCIcon in OMCCommon.m @0x18144: that renderer is 2-argument,
// (symbolName, color), as declared in OMCCommon.h — the binary has no
// 1-argument OMCIcon variant. This sized variant is marked INFERRED in
// the report.
UIImage *OMCIconSized(NSString *bundleID, double size); // sub_1b7cc — defined in the OMCHSPreview TU

// Installed-state cache helper used by -locked: (LSApplicationProxy).
static BOOL OMCAppInstalled(NSString *bundleID) {  // sub_1e0c4
    static NSMutableDictionary *cache = nil;
    if (!cache) cache = [NSMutableDictionary dictionary];
    if (bundleID.length == 0) return NO;
    NSNumber *hit = cache[bundleID];
    if (hit) return hit.boolValue;
    Class proxyCls = NSClassFromString(@"LSApplicationProxy");
    id proxy = ((id (*)(id, SEL, id))objc_msgSend)(proxyCls,
                NSSelectorFromString(@"applicationProxyForIdentifier:"), bundleID);
    BOOL installed = NO;
    if (proxy) {
        id state = OMCDynObj(proxy, @"appState");
        installed = state ? OMCDynBool(state, @"isInstalled")
                          : OMCDynBool(proxy, @"isInstalled");
    }
    cache[bundleID] = @(installed);
    return installed;
}

static char kOMCSliderAssocKey;   // global at 0x90020 in the original

@implementation OMCAppBridgeAppsController

- (BOOL)layoutPage { return NO; }

// Sections shown: base page -> 1..3, layout page -> 0 and 4.
- (BOOL)shows:(NSInteger)section {
    BOOL middle = (NSUInteger)(section - 1) <= 2;
    return middle ^ [self layoutPage];
}

- (void)loadView {
    UITableView *tv = [[UITableView alloc] initWithFrame:CGRectZero
                                                   style:UITableViewStyleGrouped];
    tv.dataSource = self;
    tv.delegate = self;
    tv.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    self.table = tv;
    self.view = tv;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    OMCLoadStrings();
    NSString *name = [self.specifier name];
    self.title = name ?: L([self layoutPage] ? @"HOME_SCREEN" : @"APPS_TITLE");
    self.view.tintColor = OMCAccentColor();
    OMCStyleTable(self.table);
    self.icons = [NSCache new];
    self.open = [NSMutableSet setWithObject:@4];
    if (![self layoutPage]) {
        self.table.editing = YES;
        self.table.allowsSelectionDuringEditing = YES;
        self.navigationItem.rightBarButtonItem =
            [[UIBarButtonItem alloc] initWithTitle:L(@"APPS_RESET")
                                             style:UIBarButtonItemStylePlain
                                            target:self action:@selector(resetTapped)];
    }
    [self resetAdvancedOnce];
    [self loadState];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self loadState];
    [self.table reloadData];
}

// One-time migration: clear the two advanced keys once, then set the flag.
- (void)resetAdvancedOnce {
    if ([OMCPrefRead(@"appBridgeAdvancedReset") boolValue]) return;
    for (NSString *key in @[@"appBridgeEnabled", @"appBridgeFps"])
        CFPreferencesSetAppValue((__bridge CFStringRef)key, NULL,
                                 (__bridge CFStringRef)kOMCDomain);
    OMCPrefWrite(@"appBridgeAdvancedReset", (id)kCFBooleanTrue);
}

- (NSInteger)num:(NSString *)key def:(NSInteger)def {
    id v = OMCPrefRead(key);
    return v ? [v integerValue] : def;
}

// ---------------------------------------------------------------- loadState
- (void)loadState {
    CFPreferencesAppSynchronize((__bridge CFStringRef)kOMCDomain);

    if (!self.phoneApps) {
        NSSet *excluded = [NSSet setWithArray:@[
            @"com.anlai.omnicar.app", @"com.apple.springboard",
            @"com.apple.CarPlayApp", @"com.apple.CarPlaySettings",
            @"com.apple.CarPlayTemplateUIHost", @"com.apple.webapp"]];
        NSMutableArray *apps = [NSMutableArray array];
        id ws = ((id (*)(id, SEL))objc_msgSend)(NSClassFromString(@"LSApplicationWorkspace"),
                                             NSSelectorFromString(@"defaultWorkspace"));
        for (id proxy in OMCDynObj(ws, @"allInstalledApplications")) {
            NSString *bid = OMCDynObj(proxy, @"bundleIdentifier");
            if (![bid isKindOfClass:[NSString class]] || bid.length == 0) continue;
            if ([excluded containsObject:bid]) continue;
            NSString *type = OMCDynObj(proxy, @"applicationType");
            BOOL entitled = OMCHasCarPlayEntitlement(proxy);
            if ([type isEqualToString:@"System"]) {
                NSArray *tags = OMCDynObj(proxy, @"appTags");
                if ([tags containsObject:@"hidden"]) continue;
                if (OMCDynBool(proxy, @"isLaunchProhibited")) continue;
                if (OMCDynBool(proxy, @"isPlaceholder")) continue;
                if (entitled) continue;   // INFERRED polarity (see report)
            } else if (![type isEqualToString:@"User"]) {
                continue;
            }
            [apps addObject:@{@"id": bid,
                              @"name": OMCDynObj(proxy, @"localizedName") ?: bid,
                              @"system": entitled ? @0 : @1}];
        }
        [apps sortUsingComparator:^NSComparisonResult(NSDictionary *a, NSDictionary *b) {
            return [a[@"name"] localizedCaseInsensitiveCompare:b[@"name"]];
        }];
        self.phoneApps = apps;
    }

    // Included (stock CarPlay) apps: pref homeScreenCarApps = [{id,name,off}]
    NSArray *entries = OMCPrefArray(@"homeScreenCarApps");
    NSMutableArray *included = [NSMutableArray array];
    NSMutableDictionary *names = [NSMutableDictionary dictionary];
    NSMutableSet *off = [NSMutableSet set];
    for (NSDictionary *e in entries) {
        if (![e isKindOfClass:[NSDictionary class]]) continue;
        NSString *bid = e[@"id"];
        if (![bid isKindOfClass:[NSString class]]) continue;
        [included addObject:bid];
        if (e[@"name"]) names[bid] = e[@"name"];
        if ([e[@"off"] boolValue]) [off addObject:bid];
    }
    // The id->name map is kept in the shared global at 0x90018 in the
    // original (stored @0x1d454, right after the entries enumeration).
    OMCHSNameMap = names;
    if (included.count == 0)
        included = [OMCPrefArray(@"splitScreenCarPlayApps") mutableCopy];
    self.included = included;
    self.iosOff = off;

    NSMutableArray *guess = [NSMutableArray array];
    NSMutableSet *installedIDs = [NSMutableSet set];
    for (NSDictionary *a in self.phoneApps) [installedIDs addObject:a[@"id"]];
    for (NSString *seed in @[@"com.apple.Maps", @"com.apple.Music",
                             @"com.apple.mobilephone", @"com.apple.MobileSMS",
                             @"com.apple.podcasts", @"com.apple.iBooks",
                             @"com.apple.news", @"com.apple.mobilecal"])
        if ([installedIDs containsObject:seed]) [guess addObject:seed];
    for (NSDictionary *a in self.phoneApps)
        if ([a[@"system"] isEqual:@0] && ![guess containsObject:a[@"id"]])
            [guess addObject:a[@"id"]];   // entitled apps (INFERRED merge order)
    self.guessApps = guess;
    self.carplayApps = @[];   // populated only from homeScreenCarApps ids in the
                              // original flow; see report (carplayGuessed path)

    self.chosen = [NSMutableSet setWithArray:OMCAppBridgeAppsPref()];
    self.hidden = [NSMutableSet set];
    for (NSString *bid in OMCPrefArray(@"homeScreenHiddenApps"))
        if (![self locked:bid]) [self.hidden addObject:bid];
    self.shown = [NSMutableSet setWithArray:OMCPrefArray(@"homeScreenShownApps")];

    NSString *hs = OMCDataPath(@"HomeScreen");
    self.photo = [UIImage imageWithContentsOfFile:[hs stringByAppendingPathComponent:@"photo.jpg"]];
    BOOL hasVideo = [[NSFileManager defaultManager]
        fileExistsAtPath:[hs stringByAppendingPathComponent:@"video.mp4"]];
    self.videoThumb = hasVideo
        ? [UIImage imageWithContentsOfFile:[hs stringByAppendingPathComponent:@"video.jpg"]] : nil;

    BOOL wall = [OMCPrefOrDef(@"homeScreenWallpaper", (id)kCFBooleanFalse) boolValue];
    self.wallpaper = nil;
    if (wall) {
        self.wallStyle = [self num:@"homeScreenWallpaperStyle" def:7];
        if (self.wallStyle == 8) {
            self.wallpaper = self.videoThumb;
        } else {
            self.wallpaper = [UIImage imageWithContentsOfFile:
                [hs stringByAppendingPathComponent:@"wallpaper.jpg"]];
        }
    }
    if (!self.wallpaper) self.wallStyle = 0;

    [self rebuildRows];
}

- (BOOL)carplayGuessed { return self.carplayApps.count == 0; }

- (NSArray *)carplayIDs {
    NSMutableArray *ids = [NSMutableArray array];
    NSArray *chosenSorted = [self.chosen.allObjects
        sortedArrayUsingComparator:^NSComparisonResult(NSString *a, NSString *b) {
            return [a localizedCaseInsensitiveCompare:b];  // via name map in orig.
        }];
    [ids addObjectsFromArray:chosenSorted];
    NSArray *rest = [self carplayGuessed] ? self.guessApps : self.carplayApps;
    for (NSString *bid in rest)
        if ([bid isKindOfClass:[NSString class]] &&
            ![self.chosen containsObject:bid] && ![ids containsObject:bid])
            [ids addObject:bid];
    return ids;
}

// Stock CarPlay core apps and anything CarPlay-prefixed can never be removed.
- (BOOL)locked:(NSString *)bundleID {
    if ([bundleID isKindOfClass:[NSString class]] && bundleID.length > 0) {
        if ([@[@"com.apple.mobilephone", @"com.apple.Music", @"com.apple.Maps",
               @"com.apple.MobileSMS", @"com.apple.InCallService"]
                containsObject:bundleID])
            return YES;
        if ([bundleID hasPrefix:@"com.apple.CarPlay"]) return YES;
        if ([bundleID rangeOfString:@"NowPlaying"].location != NSNotFound)
            return YES;
    }
    if ([self carplayGuessed]) return NO;
    if ([self.carplayApps containsObject:bundleID]) return NO;
    return !OMCAppInstalled(bundleID);
}

- (BOOL)hides:(NSDictionary *)app {
    NSString *bid = app[@"id"];
    if ([self locked:bid]) return NO;
    if ([self.hidden containsObject:bid]) return YES;
    if ([self.iosOff containsObject:bid]) return ![self.shown containsObject:bid];
    return NO;
}

- (BOOL)removable:(NSDictionary *)app {
    if (![app[@"carplay"] boolValue]) return YES;
    return ![self locked:app[@"id"]];
}

- (void)rebuildRows {
    NSString *q = self.query;
    BOOL (^match)(NSDictionary *) = ^BOOL(NSDictionary *app) {
        if (q.length == 0) return YES;
        NSString *name = app[@"name"];
        return [name rangeOfString:q options:NSCaseInsensitiveSearch | NSAnchoredSearch].location != NSNotFound;
    };
    NSMutableArray *inc = [NSMutableArray array], *oth = [NSMutableArray array];
    for (NSDictionary *app in self.phoneApps) {
        if (!match(app)) continue;
        if ([self.chosen containsObject:app[@"id"]]) [inc addObject:app];
        else [oth addObject:app];
    }
    self.included = inc;
    self.other = oth;
}

- (void)storeChoices {
    NSMutableArray *ids = [NSMutableArray array];
    for (NSDictionary *app in self.phoneApps)
        if ([self.chosen containsObject:app[@"id"]]) [ids addObject:app[@"id"]];
    OMCPrefWrite(@"appBridgeApps", ids);
    OMCPrefWrite(@"homeScreenHiddenApps",
                 [self.hidden.allObjects sortedArrayUsingSelector:@selector(compare:)]);
    OMCPrefWrite(@"homeScreenShownApps",
                 [self.shown.allObjects sortedArrayUsingSelector:@selector(compare:)]);
}

- (void)reloadLists {
    NSInteger oldInc = [self tableView:self.table numberOfRowsInSection:1];
    NSInteger oldOth = [self tableView:self.table numberOfRowsInSection:2];
    [self rebuildRows];
    NSInteger newOth = [self tableView:self.table numberOfRowsInSection:2];
    [self.table performBatchUpdates:^{
        [self.table reloadSections:[NSIndexSet indexSetWithIndex:1]
                  withRowAnimation:UITableViewRowAnimationFade];
        NSMutableArray *del = [NSMutableArray array], *ins = [NSMutableArray array];
        for (NSInteger r = 1; r < oldOth; r++)
            [del addObject:[NSIndexPath indexPathForRow:r inSection:2]];
        for (NSInteger r = 1; r < newOth; r++)
            [ins addObject:[NSIndexPath indexPathForRow:r inSection:2]];
        (void)oldInc;
        [self.table deleteRowsAtIndexPaths:del withRowAnimation:UITableViewRowAnimationFade];
        [self.table insertRowsAtIndexPaths:ins withRowAnimation:UITableViewRowAnimationFade];
    } completion:nil];
    [self updatePreview];
}

- (void)updatePreview {
    if (!self.preview) return;
    NSMutableArray *items = [NSMutableArray array];
    for (NSString *bid in self.carplayApps)
        if ([self.chosen containsObject:bid] && ![self hides:@{@"id": bid}])
            [items addObject:bid];
    for (NSDictionary *app in self.phoneApps)
        if ([self.chosen containsObject:app[@"id"]] &&
            ![items containsObject:app[@"id"]])
            [items addObject:app[@"id"]];
    if (items.count == 0)
        items = [@[@"com.apple.Maps", @"com.apple.Music", @"com.apple.mobilephone",
                   @"com.apple.MobileSMS", @"com.apple.podcasts"] mutableCopy];
    self.preview.items = items;
    self.preview.wallpaper = self.wallpaper;
    self.preview.video = (self.wallStyle == 8);
    self.preview.size = [self num:@"homeScreenIconSize" def:100];
    self.preview.blur = [self num:@"homeScreenBlur" def:0];
    self.preview.dim = [self num:@"homeScreenDim" def:25];
    self.preview.cols = [self num:@"homeScreenGridCols" def:0];
    self.preview.rows = [self num:@"homeScreenGridRows" def:0];
    self.preview.names = [OMCPrefOrDef(@"homeScreenShowNames", (id)kCFBooleanTrue) boolValue];
    [self.preview setNeedsDisplay];
}

// ------------------------------------------------------------ reset actions
- (void)resetTapped {
    BOOL layout = [self layoutPage];
    UIAlertController *ac = [UIAlertController
        alertControllerWithTitle:nil
                         message:L(layout ? @"HOMESCREEN_RESET_CONFIRM" : @"APPS_RESET_CONFIRM")
                  preferredStyle:UIAlertControllerStyleAlert];
    [ac addAction:[UIAlertAction actionWithTitle:L(@"CANCEL") style:UIAlertActionStyleCancel
                                          handler:nil]];
    [ac addAction:[UIAlertAction actionWithTitle:L(@"APPS_RESET") style:UIAlertActionStyleDestructive
        handler:^(UIAlertAction *a) {
            if (layout) { [self resetLayout]; return; }
            [self.hidden removeAllObjects];
            [self.shown removeAllObjects];
            [self storeChoices];
            [self rebuildRows];
            [self.table reloadData];
            [self updatePreview];
        }]];
    ac.popoverPresentationController.barButtonItem = self.navigationItem.rightBarButtonItem;
    [self presentViewController:ac animated:YES completion:nil];
}

- (void)resetLayout {
    for (NSString *key in @[@"homeScreenGridCols", @"homeScreenGridRows",
                            @"homeScreenIconSize", @"homeScreenShowNames",
                            @"homeScreenBlur", @"homeScreenDim",
                            @"homeScreenWallpaper", @"homeScreenWallpaperStyle"])
        CFPreferencesSetAppValue((__bridge CFStringRef)key, NULL,
                                 (__bridge CFStringRef)kOMCDomain);
    [[NSFileManager defaultManager]
        removeItemAtPath:OMCDataPath(@"HomeScreen/wallpaper.jpg") error:nil];
    CFPreferencesAppSynchronize((__bridge CFStringRef)kOMCDomain);
    notify_post("com.anlai.omnicar/prefschanged");
    [self loadState];
}

// ------------------------------------------------------------- table basics
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tv { return 5; }

- (NSInteger)tableView:(UITableView *)tv numberOfRowsInSection:(NSInteger)section {
    if (![self shows:section]) return 0;
    if (section == 0) return 1;
    if (section == 1) return (NSInteger)self.included.count;
    if (section == 2) {   // literal formula from the binary
        NSInteger c = (NSInteger)self.other.count;
        return (c > 1 ? c + 1 : 1) + 1;
    }
    if (section == 3) return 4;
    if (section == 4) return [self isOpen:4] ? 6 : 1;
    return 0;
}

- (NSString *)tableView:(UITableView *)tv titleForHeaderInSection:(NSInteger)section {
    if (![self shows:section]) return nil;
    if (section == 1) return L(@"APPS_INCLUDED");       // INFERRED keys
    if (section == 2) return L(@"APPS_ALL");
    return nil;
}

- (NSString *)tableView:(UITableView *)tv titleForFooterInSection:(NSInteger)section {
    if (![self shows:section]) return nil;
    if (section == 1) return L(@"APPBRIDGE_APPS_FOOTER");
    if (section == 2) return L(@"APPBRIDGE_APPS_FOOTER2");
    return nil;
}

- (CGFloat)tableView:(UITableView *)tv heightForHeaderInSection:(NSInteger)section {
    return [self shows:section] ? UITableViewAutomaticDimension
                                : CGFLOAT_MIN;
}
- (CGFloat)tableView:(UITableView *)tv heightForFooterInSection:(NSInteger)section {
    return [self shows:section] ? UITableViewAutomaticDimension
                                : CGFLOAT_MIN;
}

// VERIFIED (CLOSURE-2; census items M1/M2; dump
// disasm/rem2_M1M2_willDisplayShims.txt): both delegate methods are
// 12-byte tail-call shims in the binary — IMP 0x20084:
//   mov x0, x3; mov w1, #1; b _OMCStyleHeaderFooter
// IMP 0x200f8: same with w1 = #0. They were missing from this
// controller's reconstruction (rebuilt class 103 methods vs the
// original's 105); sibling controllers carry the identical pair.
- (void)tableView:(UITableView *)tv willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section {
    // The binary passes a second argument (1 = header) to the styling
    // helper; OMCCommon.h declares the one-argument form.
    ((void (*)(UIView *, BOOL))OMCStyleHeaderFooter)(view, YES);
}

- (void)tableView:(UITableView *)tv willDisplayFooterView:(UIView *)view forSection:(NSInteger)section {
    ((void (*)(UIView *, BOOL))OMCStyleHeaderFooter)(view, NO);
}

- (CGFloat)tableView:(UITableView *)tv heightForRowAtIndexPath:(NSIndexPath *)ip {
    CGFloat w = tv.bounds.size.width;
    if (ip.section == 0) return floor((w - 60) * 300.0 / 800.0) + 20;
    if (ip.section == 2 && ip.row == 0) return 50;
    if (ip.section == 4 && ip.row == 1) return [self layoutTilesIn:nil width:w - 40];
    if (ip.section == 4 && ip.row == 2) return 58;
    return 52;
}

- (BOOL)isOpen:(NSInteger)section {
    return [self.open containsObject:@(section)];
}

- (void)reloadCard:(NSInteger)section {
    [self.table reloadSections:[NSIndexSet indexSetWithIndex:section]
              withRowAnimation:UITableViewRowAnimationFade];
    if (section == 4) [self updatePreview];
}

- (NSString *)wallName:(NSInteger)style {
    NSInteger s = style < 0 ? 0 : (style > 8 ? 8 : style);
    return L([NSString stringWithFormat:@"APPS_WALL_%ld", (long)s]);
}

- (NSString *)summaryFor:(NSInteger)section {
    return section == 4 ? [self wallName:self.wallStyle] : nil;
}

- (void)updateHeaders {
    for (NSNumber *n in @[@4]) {
        UITableViewCell *c = [self.table cellForRowAtIndexPath:
            [NSIndexPath indexPathForRow:0 inSection:n.integerValue]];
        c.detailTextLabel.text = [self summaryFor:n.integerValue];
    }
}

// ------------------------------------------------------------------- cells
- (UITableViewCell *)cellWithId:(NSString *)ident inTable:(UITableView *)table {
    UITableViewCell *cell = [table dequeueReusableCellWithIdentifier:ident];
    if (!cell) cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                             reuseIdentifier:ident];
    OMCStyleCell(cell);
    cell.accessoryView = nil;
    cell.editingAccessoryView = nil;
    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.imageView.image = nil;
    cell.detailTextLabel.text = nil;
    cell.textLabel.textColor = [UIColor labelColor];
    return cell;
}

- (UIView *)boxInCell:(UITableViewCell *)cell {
    UIView *box = [cell.contentView viewWithTag:16984];
    if (!box) {
        // [VERIFIED va 0x22284 (size 228): the original creates the box
        // with initWithFrame:[contentView bounds] @0x222f8-0x22300 and
        // setAutoresizingMask:0x12 @0x22320-0x22324 (FlexibleWidth |
        // FlexibleHeight) before addSubview:. The pre-fix code used
        // [UIView new] (CGRectZero, mask 0), so the box never tracked the
        // contentView it hosts content in.]
        box = [[UIView alloc] initWithFrame:cell.contentView.bounds];
        box.tag = 16984;
        box.autoresizingMask = UIViewAutoresizingFlexibleWidth |
                               UIViewAutoresizingFlexibleHeight;
        [cell.contentView addSubview:box];
    }
    return box;
}

- (void)setAccessory:(UIView *)view onCell:(UITableViewCell *)cell {
    if ([self.table isEditing]) cell.editingAccessoryView = view;
    else cell.accessoryView = view;
}

- (UIImage *)iconFor:(NSString *)bundleID {
    UIImage *img = [self.icons objectForKey:bundleID];
    if (!img) {
        img = OMCIconSized(bundleID, 37);
        if (img) [self.icons setObject:img forKey:bundleID];
    }
    return img;
}

- (UITableViewCell *)appCell:(NSDictionary *)app inTable:(UITableView *)table {
    UITableViewCell *cell = [self cellWithId:@"app" inTable:table];
    cell.textLabel.text = app[@"name"];
    cell.imageView.image = [self iconFor:app[@"id"]];
    BOOL carplay = [app[@"carplay"] boolValue];
    BOOL offByIOS = [self.iosOff containsObject:app[@"id"]] &&
                    ![self.shown containsObject:app[@"id"]];
    if (carplay && offByIOS) cell.detailTextLabel.text = L(@"APPBRIDGE");
    else if (!carplay && offByIOS) cell.detailTextLabel.text = L(@"APPS_IOS_REMOVED");
    cell.detailTextLabel.font = [UIFont systemFontOfSize:11 weight:UIFontWeightSemibold];
    cell.detailTextLabel.textColor = [UIColor secondaryLabelColor];
    return cell;
}

- (UITableViewCell *)headerCellFor:(NSInteger)section inTable:(UITableView *)table {
    UITableViewCell *cell = [table dequeueReusableCellWithIdentifier:@"head"];
    if (!cell) cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1
                                             reuseIdentifier:@"head"];
    OMCStyleCell(cell);
    NSArray *entry = (section == 4)
        ? @[@"HOMESCREEN_WALLPAPER", @"photo.fill", @"#FF8A65"] : nil;
    cell.textLabel.text = L(entry[0]);
    // [VERIFIED @0x1fbec: _OMCIcon(entry[1], _OMCColorFromHex(entry[2])) —
    // entry[1] loaded @0x1fba4 (objectAtIndexedSubscript: w2=#1), entry[2]
    // @0x1fbbc (w2=#2) -> _OMCColorFromHex @0x1fbd4, moved to x1 @0x1fbe8;
    // result -> imageView setImage: @0x1fc14. No setTintColor: send exists
    // at this site — the colour is consumed by _OMCIcon itself (hue picks
    // the gradient palette); the former 1-arg call + tintColor line was a
    // reconstruction error.]
    cell.imageView.image = OMCIcon(entry[1], OMCColorFromHex(entry[2]));
    cell.detailTextLabel.text = [self summaryFor:section];
    UIImageView *chev = [[UIImageView alloc]
        initWithImage:[UIImage systemImageNamed:[self isOpen:section]
                        ? @"chevron.down" : @"chevron.right"]];
    chev.tintColor = [UIColor tertiaryLabelColor];
    cell.accessoryView = chev;
    return cell;
}

- (NSDictionary *)appAt:(NSIndexPath *)ip {
    if (ip.section == 1)
        return ip.row < (NSInteger)self.included.count ? self.included[ip.row] : nil;
    if (ip.section == 2) {
        if (ip.row < 1) return nil;
        NSInteger i = ip.row - 1;
        return i <= (NSInteger)self.other.count && i < (NSInteger)self.other.count
            ? self.other[i] : nil;
    }
    return nil;
}

static NSArray *OMCGridEntries(void) {
    return @[@[@"HOMESCREEN_COLS", @"rectangle.split.3x1.fill", @"#5AB8FF"],
             @[@"HOMESCREEN_ROWS", @"rectangle.split.1x2.fill", @"#2BC79A"],
             @[@"HOMESCREEN_ICON_SIZE", @"plus.magnifyingglass", @"#8B7CFF"],
             @[@"HOMESCREEN_NAMES", @"textformat", @"#FF7FA8"]];
}

- (UITableViewCell *)tableView:(UITableView *)tv cellForRowAtIndexPath:(NSIndexPath *)ip {
    NSInteger section = ip.section, row = ip.row;
    if (section == 0) {   // Home Screen preview
        UITableViewCell *cell = [self cellWithId:@"preview" inTable:tv];
        // [VERIFIED va 0x20a24-0x20b58: the original parents the preview
        // DIRECTLY to cell.contentView (no box). It compares
        // preview.superview with contentView @0x20a24/0x20a38; on mismatch
        // it removeFromSuperview @0x20a80, creates a FRESH OMCHSPreview
        // (setPreview: @0x20aa4) and addSubview:s it to contentView
        // @0x20ae0, then setFrame: @0x20b48 and tail-calls updatePreview
        // @0x20b58. The pre-fix code kept ONE persistent preview inside
        // the zero-frame boxInCell box, so a re-queried preview cell
        // could keep showing a stale instance the original would have
        // discarded and rebuilt.]
        if (self.preview.superview != cell.contentView) {
            [self.preview removeFromSuperview];
            self.preview = [OMCHSPreview new];
        }
        [cell.contentView addSubview:self.preview];
        CGFloat w = tv.bounds.size.width;
        self.preview.frame = CGRectMake(10, 10, w - 60, floor((w - 60) * 300.0 / 800.0));
        [self updatePreview];
        return cell;
    }
    if (section == 1) {
        NSDictionary *app = [self appAt:ip];
        return app ? [self appCell:app inTable:tv] : [self cellWithId:@"cell" inTable:tv];
    }
    if (section == 2) {
        if (row == 0) {   // tools / search cell (UISearchBar added in orig.)
            return [self cellWithId:@"tools" inTable:tv];   // (search bar wiring INFERRED)
        }
        NSDictionary *app = [self appAt:ip];
        if (app) return [self appCell:app inTable:tv];
        UITableViewCell *cell = [self cellWithId:@"none" inTable:tv];
        cell.textLabel.text = L(self.query.length ? @"APPBRIDGE_APPS_NO_MATCH"
                                                  : @"APPBRIDGE_APPS_NONE");
        return cell;
    }
    if (section == 3) {   // grid settings: cols / rows / icon size / names
        NSArray *entry = OMCGridEntries()[row];
        UITableViewCell *cell = [self cellWithId:[NSString stringWithFormat:@"grid%ld", (long)row]
                                        inTable:tv];
        cell.textLabel.text = L(entry[0]);
        // [VERIFIED @0x208e0: _OMCIcon(entry[1], _OMCColorFromHex(entry[2]))
        // — entry[1] loaded @0x20898 (w2=#1), entry[2] @0x208b0 (w2=#2) ->
        // _OMCColorFromHex @0x208c8, moved to x1 @0x208dc; result ->
        // imageView setImage: @0x20908. No setTintColor: send at this
        // site either.]
        cell.imageView.image = OMCIcon(entry[1], OMCColorFromHex(entry[2]));
        if (row == 0)
            [self setAccessory:[self stepperFor:@"homeScreenGridCols"
                                         values:@[@0, @3, @4, @5, @6, @7, @8]] onCell:cell];
        else if (row == 1)
            [self setAccessory:[self stepperFor:@"homeScreenGridRows"
                                         values:@[@0, @1, @2, @3, @4]] onCell:cell];
        else if (row == 2)
            [self setAccessory:[self sliderFor:@"homeScreenIconSize"
                                           min:60 max:130 def:100 unit:@"%"] onCell:cell];
        else {
            UISwitch *sw = [UISwitch new];
            sw.onTintColor = OMCSwitchColor();
            sw.on = [OMCPrefOrDef(@"homeScreenShowNames", (id)kCFBooleanTrue) boolValue];
            [sw addTarget:self action:@selector(namesSwitched:)
                 forControlEvents:UIControlEventValueChanged];
            [self setAccessory:sw onCell:cell];
        }
        return cell;
    }
    // section == 4: wallpaper card (rows: 0 header, 1 tiles, 2 photo button,
    // 3 blur slider, 4 dim slider, 5 unused/plain — row mapping INFERRED,
    // see PrefsB_REPORT.md)
    if (row == 0) return [self headerCellFor:4 inTable:tv];
    if (row == 1) {
        UITableViewCell *cell = [self cellWithId:@"tiles" inTable:tv];
        UIView *box = [self boxInCell:cell];
        [self layoutTilesIn:box width:tv.bounds.size.width - 40];
        return cell;
    }
    if (row == 2) {
        UITableViewCell *cell = [self cellWithId:@"wall" inTable:tv];
        UIButton *b = [UIButton buttonWithType:UIButtonTypeCustom];
        b.tag = 80;
        [b setTitle:L(@"APPS_FROM_PHOTOS") forState:UIControlStateNormal];
        [b setTitleColor:OMCAccentColor() forState:UIControlStateNormal];
        b.titleLabel.font = [UIFont systemFontOfSize:15 weight:UIFontWeightSemibold];
        b.frame = CGRectMake(12, 4, tv.bounds.size.width - 24, 42);
        b.layer.cornerRadius = 11;
        b.layer.cornerCurve = kCACornerCurveContinuous;
        [b addTarget:self action:@selector(pickPhoto)
            forControlEvents:UIControlEventTouchUpInside];
        [[self boxInCell:cell] addSubview:b];
        return cell;
    }
    if (row == 3 || row == 4) {
        BOOL blur = (row == 3);
        UITableViewCell *cell = [self cellWithId:@"wall" inTable:tv];
        cell.textLabel.text = L(blur ? @"HOMESCREEN_BLUR" : @"HOMESCREEN_DIM");
        // [VERIFIED @0x20f50: all three operands are csel on cmp row,#3
        // (row = [indexPath row], held in x23) — symbol csel @0x20ee0:
        // eq -> @"drop.fill" (0x79948), ne -> @"moon.fill" (0x79968);
        // hex csel @0x20ef4: eq -> @"#5AB8FF" (0x78f08), ne -> @"#4A4F80"
        // (0x79988); hex -> _OMCColorFromHex @0x20f38 -> x1 @0x20f4c,
        // symbol in x0 @0x20f48; result -> imageView setImage: @0x20f78.
        // No setTintColor: send at this site.]
        cell.imageView.image = OMCIcon(blur ? @"drop.fill" : @"moon.fill",
                                       OMCColorFromHex(blur ? @"#5AB8FF" : @"#4A4F80"));
        UIView *slider = blur
            ? [self sliderFor:@"homeScreenBlur" min:0 max:30 def:0 unit:@""]
            : [self sliderFor:@"homeScreenDim" min:0 max:70 def:25 unit:@"%"];
        [self setAccessory:slider onCell:cell];
        return cell;
    }
    return [self cellWithId:@"wall" inTable:tv];
}

// ---------------------------------------------------------------- editing
- (BOOL)tableView:(UITableView *)tv canEditRowAtIndexPath:(NSIndexPath *)ip {
    return [self appAt:ip] != nil;
}
- (BOOL)tableView:(UITableView *)tv canMoveRowAtIndexPath:(NSIndexPath *)ip {
    return NO;
}
- (BOOL)tableView:(UITableView *)tv shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)ip {
    return [self appAt:ip] != nil;
}
- (UITableViewCellEditingStyle)tableView:(UITableView *)tv
           editingStyleForRowAtIndexPath:(NSIndexPath *)ip {
    NSDictionary *app = [self appAt:ip];
    if (!app) return UITableViewCellEditingStyleNone;
    if (ip.section == 2) return UITableViewCellEditingStyleInsert;
    return [self removable:app] ? UITableViewCellEditingStyleDelete
                                 : UITableViewCellEditingStyleNone;
}
- (NSString *)tableView:(UITableView *)tv
    titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)ip {
    return L(@"APPS_REMOVE");
}

- (void)tableView:(UITableView *)tv commitEditingStyle:(UITableViewCellEditingStyle)style
                                        forRowAtIndexPath:(NSIndexPath *)ip {
    NSDictionary *app = [self appAt:ip];
    if (!app) return;
    NSString *bid = app[@"id"];
    if ([app[@"carplay"] boolValue]) {
        if (style == UITableViewCellEditingStyleInsert) {
            [self.hidden removeObject:bid];
            if ([self.iosOff containsObject:bid]) [self.shown addObject:bid];
        } else {
            if ([self.shown containsObject:bid]) [self.shown removeObject:bid];
            else [self.hidden addObject:bid];
        }
    } else {
        // (branch polarity re-verified against raw asm; see report)
        if (style == UITableViewCellEditingStyleInsert) [self.chosen addObject:bid];
        else [self.chosen removeObject:bid];
    }
    [[[UISelectionFeedbackGenerator alloc] init] selectionChanged];
    [self storeChoices];
    [self reloadLists];
}

- (void)tableView:(UITableView *)tv didSelectRowAtIndexPath:(NSIndexPath *)ip {
    [tv deselectRowAtIndexPath:ip animated:YES];
    if (ip.section == 4 && ip.row == 0) {
        if ([self isOpen:4]) [self.open removeObject:@4];
        else [self.open addObject:@4];
        [self.view endEditing:YES];
        [tv reloadSections:[NSIndexSet indexSetWithIndex:4]
          withRowAnimation:UITableViewRowAnimationNone];
    }
}

// ----------------------------------------------------------------- search
- (void)searchBar:(UISearchBar *)sb textDidChange:(NSString *)text {
    self.query = text;
    [self reloadLists];
}
- (void)searchBarSearchButtonClicked:(UISearchBar *)sb {
    [sb resignFirstResponder];
}

// --------------------------------------------------------------- controls
- (UIView *)sliderFor:(NSString *)key min:(NSInteger)min max:(NSInteger)max
                  def:(NSInteger)def unit:(NSString *)unit {
    UIView *box = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 200, 32)];
    UISlider *slider = [[UISlider alloc] initWithFrame:CGRectMake(0, 0, 150, 32)];
    slider.minimumValue = min;
    slider.maximumValue = max;
    slider.value = [self num:key def:def];
    slider.minimumTrackTintColor = OMCAccentColor();
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(154, 0, 42, 32)];
    label.textAlignment = NSTextAlignmentRight;
    label.font = [UIFont monospacedDigitSystemFontOfSize:14 weight:UIFontWeightRegular];
    label.textColor = [UIColor secondaryLabelColor];
    label.text = [NSString stringWithFormat:@"%ld%@", (long)slider.value, unit];
    objc_setAssociatedObject(slider, &kOMCSliderAssocKey, @[key, unit, label],
                             OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [slider addTarget:self action:@selector(sliderMoved:)
        forControlEvents:UIControlEventValueChanged];
    [slider addTarget:self action:@selector(sliderDone:)
        forControlEvents:UIControlEventTouchUpInside | UIControlEventTouchUpOutside];
    [box addSubview:slider];
    [box addSubview:label];
    return box;
}

- (void)sliderMoved:(UISlider *)sender {
    NSArray *assoc = objc_getAssociatedObject(sender, &kOMCSliderAssocKey);
    UILabel *label = assoc[2];
    label.text = [NSString stringWithFormat:@"%ld%@", (long)sender.value, assoc[1]];
    // live write during the drag: SetAppValue only (no sync / no notify)
    CFPreferencesSetAppValue((__bridge CFStringRef)assoc[0],
                             (__bridge CFPropertyListRef)@((long)sender.value),
                             (__bridge CFStringRef)kOMCDomain);
    [self updatePreview];
}

- (void)sliderDone:(UISlider *)sender {
    NSArray *assoc = objc_getAssociatedObject(sender, &kOMCSliderAssocKey);
    OMCPrefWrite(assoc[0], @((long)sender.value));
}

- (UIView *)stepperFor:(NSString *)key values:(NSArray *)values {
    UIView *box = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 170, 32)];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 64, 32)];
    label.textAlignment = NSTextAlignmentRight;
    label.font = [UIFont monospacedDigitSystemFontOfSize:14 weight:UIFontWeightRegular];
    label.textColor = [UIColor secondaryLabelColor];
    label.adjustsFontSizeToFitWidth = YES;
    UIStepper *stepper = [UIStepper new];
    CGRect f = stepper.frame;
    f.origin.x = 170 - f.size.width;
    f.origin.y = (32 - f.size.height) / 2;
    stepper.frame = f;
    stepper.minimumValue = 0;
    stepper.maximumValue = (double)values.count - 1;
    stepper.stepValue = 1;
    NSUInteger idx = [values indexOfObject:@([self num:key def:0])];
    stepper.value = idx == NSNotFound ? 0 : (double)idx;
    objc_setAssociatedObject(stepper, &kOMCSliderAssocKey, @[key, values, label],
                             OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [stepper addTarget:self action:@selector(stepped:)
        forControlEvents:UIControlEventValueChanged];
    [box addSubview:label];
    [box addSubview:stepper];
    [self showStep:stepper];
    return box;
}

- (void)showStep:(UIStepper *)stepper {
    NSArray *assoc = objc_getAssociatedObject(stepper, &kOMCSliderAssocKey);
    NSArray *values = assoc[1];
    UILabel *label = assoc[2];
    NSNumber *v = values[(NSUInteger)stepper.value];
    label.text = v.integerValue == 0 ? L(@"HOMESCREEN_AUTO") : v.stringValue;
}

- (void)stepped:(UIStepper *)sender {
    [[[UISelectionFeedbackGenerator alloc] init] selectionChanged];
    [self showStep:sender];
    NSArray *assoc = objc_getAssociatedObject(sender, &kOMCSliderAssocKey);
    OMCPrefWrite(assoc[0], assoc[1][(NSUInteger)sender.value]);
    [self updatePreview];
}

- (void)namesSwitched:(UISwitch *)sender {
    OMCPrefWrite(@"homeScreenShowNames", @(sender.isOn));
    [self updatePreview];
}

- (UIButton *)smallButton:(NSString *)symbol tint:(UIColor *)tint
                   action:(SEL)action bundle:(NSString *)bundleID {
    UIButton *b = [UIButton buttonWithType:UIButtonTypeCustom];
    [b setImage:[UIImage systemImageNamed:symbol] forState:UIControlStateNormal];
    b.tintColor = tint;
    b.frame = CGRectMake(0, 0, 37, 37);
    objc_setAssociatedObject(b, &kOMCSliderAssocKey, bundleID, OBJC_ASSOCIATION_COPY);
    [b addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    return b;
}

// -------------------------------------------------------------- wallpaper
// Renders a square-cropped thumbnail (sibling TU helper at 0x22df0).
UIImage *OMCThumb(UIImage *image, double a, double b, double c); // INFERRED sig.

- (CGFloat)layoutTilesIn:(UIView *)container width:(CGFloat)width {
    NSMutableArray *styles = [NSMutableArray array];
    for (NSInteger i = 0; i <= 6; i++) [styles addObject:@(i)];
    if (self.photo) [styles addObject:@7];
    if (self.videoThumb) [styles addObject:@8];
    if (container)
        for (UIView *v in [container.subviews copy]) [v removeFromSuperview];
    CGFloat tileW = floor((width - 24 - 24) * 0.25);
    CGFloat tileH = floor(tileW / 1.6);
    NSInteger i = 0;
    for (NSNumber *sn in styles) {
        NSInteger style = sn.integerValue;
        NSInteger col = i % 4, row = i / 4;
        if (container) {
            UIButton *tile = [UIButton buttonWithType:UIButtonTypeCustom];
            tile.frame = CGRectMake(12 + col * (tileW + 8), 12 + row * (tileH + 8),
                                    tileW, tileH);
            tile.layer.cornerRadius = 10;
            tile.layer.cornerCurve = kCACornerCurveContinuous;
            tile.clipsToBounds = YES;
            tile.tag = style;
            [tile addTarget:self action:@selector(tileTapped:)
                forControlEvents:UIControlEventTouchUpInside];
            if (style == 0) {
                tile.backgroundColor = [UIColor systemBackgroundColor];
                tile.layer.borderWidth = 1;
                tile.layer.borderColor = [UIColor colorWithWhite:0.5 alpha:1].CGColor;
                [tile setTitle:L(@"HOMESCREEN_WALLPAPER_DEFAULT")
                      forState:UIControlStateNormal];
                [tile setTitleColor:[UIColor secondaryLabelColor] forState:UIControlStateNormal];
                tile.titleLabel.font = [UIFont systemFontOfSize:12];
                tile.titleLabel.textAlignment = NSTextAlignmentCenter;
                tile.titleLabel.numberOfLines = 2;
                tile.titleLabel.adjustsFontSizeToFitWidth = YES;
            } else if (style == 7 || style == 8) {
                UIImage *src = style == 7 ? self.photo : self.videoThumb;
                [tile setImage:OMCThumb(src, 0, 0, 0) forState:UIControlStateNormal];
                tile.imageView.contentMode = UIViewContentModeScaleAspectFill;
                if (style == 8) {
                    UIImageView *play = [[UIImageView alloc]
                        initWithImage:[UIImage systemImageNamed:@"play.circle.fill"]];
                    play.tintColor = [UIColor whiteColor];
                    play.userInteractionEnabled = NO;
                    [tile addSubview:play];
                }
            } else {
                // conic gradient preview; the 5 RGB triples per style are
                // read from the constant pool at 0x657a0 in the original
                // (per-style offsets in disasm 0x22810-0x22c00 — INFERRED
                // exact component order, structure VERIFIED).
                CAGradientLayer *g = [CAGradientLayer layer];
                g.type = kCAGradientLayerConic;
                g.frame = CGRectInset(tile.bounds, -3, -3);
                g.startPoint = CGPointMake(0.5, 0.5);
                g.endPoint = CGPointMake(0, 1);
                g.colors = @[(id)[UIColor systemPurpleColor].CGColor,
                             (id)[UIColor systemBlueColor].CGColor,
                             (id)[UIColor systemPinkColor].CGColor,
                             (id)[UIColor systemOrangeColor].CGColor,
                             (id)[UIColor systemTealColor].CGColor];
                CAShapeLayer *mask = [CAShapeLayer layer];
                mask.path = [UIBezierPath bezierPathWithRoundedRect:
                    CGRectInset(tile.bounds, 1, 1) cornerRadius:12].CGPath;
                mask.fillColor = nil;
                mask.strokeColor = [UIColor blackColor].CGColor;
                mask.lineWidth = 2;
                UIView *ov = [UIView new];
                ov.userInteractionEnabled = NO;
                [ov.layer addSublayer:g];
                [tile addSubview:ov];
                [tile.layer addSublayer:mask];
            }
            [container addSubview:tile];
        }
        i++;
    }
    NSInteger rows = (styles.count + 3) / 4;
    return (rows - 1) * 8 + rows * tileH + 24;
}

- (void)tileTapped:(UIButton *)sender { [self useStyle:sender.tag]; }

- (void)useStyle:(NSInteger)style {
    UIImage *image = nil;
    if (style == 7) image = self.photo;
    else if (style == 8) image = self.videoThumb;
    else if (style == 0) {
        [[NSFileManager defaultManager]
            removeItemAtPath:OMCDataPath(@"HomeScreen/wallpaper.jpg") error:nil];
        self.wallpaper = nil;
        self.wallStyle = 0;
        OMCPrefWrite(@"homeScreenWallpaperStyle", @0);
        OMCPrefWrite(@"homeScreenWallpaper", (id)kCFBooleanFalse);
        [self reloadCard:4];
        [self updatePreview];
        return;
    } else {
        image = OMCThumb(nil, 2000, 720, 1);   // gradient render (INFERRED args)
        if (!image) return;
    }
    if (!image) return;
    if (![self writeJPEG:image to:OMCDataPath(@"HomeScreen/wallpaper.jpg")]) return;
    self.wallpaper = image;
    self.wallStyle = style;
    OMCPrefWrite(@"homeScreenWallpaperStyle", @(style));
    OMCPrefWrite(@"homeScreenWallpaper", (id)kCFBooleanTrue);
    [self reloadCard:4];
    [self updatePreview];
}

- (BOOL)writeJPEG:(UIImage *)image to:(NSString *)path {
    NSData *data = UIImageJPEGRepresentation(image, 0.85);
    NSFileManager *fm = [NSFileManager defaultManager];
    [fm createDirectoryAtPath:[path stringByDeletingLastPathComponent]
        withIntermediateDirectories:YES attributes:nil error:nil];
    NSError *err = nil;
    if (![data writeToFile:path options:NSDataWritingAtomic error:&err]) {
        [self alert:err.localizedDescription ?: @"JPEG"];
        return NO;
    }
    [fm setAttributes:@{NSFilePosixPermissions: @0644} ofItemAtPath:path error:nil];
    return YES;
}

- (void)useWallpaper:(UIImage *)image {
    if (!image) return;
    CGFloat pw = image.size.width * image.scale, ph = image.size.height * image.scale;
    CGFloat factor = MIN(1.0, 2000.0 / MAX(pw, ph));
    CGSize size = CGSizeMake(round(pw * factor), round(ph * factor));
    UIGraphicsImageRendererFormat *fmt = [UIGraphicsImageRendererFormat preferredFormat];
    fmt.scale = 1;
    fmt.opaque = YES;
    UIGraphicsImageRenderer *r = [[UIGraphicsImageRenderer alloc] initWithSize:size format:fmt];
    UIImage *rendered = [r imageWithActions:^(UIGraphicsImageRendererContext *ctx) {
        [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    }];
    if ([self writeJPEG:rendered to:OMCDataPath(@"HomeScreen/photo.jpg")]) {
        self.photo = rendered;
        [self useStyle:7];
    }
}

- (void)useVideo:(NSURL *)url {
    AVURLAsset *asset = [AVURLAsset URLAssetWithURL:url options:nil];
    AVAssetTrack *track = [asset tracksWithMediaType:AVMediaTypeVideo].firstObject;
    if (!track) { [self alert:L(@"APPS_VIDEO_FAILED")]; return; }
    AVMutableComposition *comp = [AVMutableComposition composition];
    AVMutableCompositionTrack *ctrack = [comp addMutableTrackWithMediaType:AVMediaTypeVideo
                                                          preferredTrackID:kCMPersistentTrackID_Invalid];
    CMTime dur = CMTimeMinimum(asset.duration, CMTimeMakeWithSeconds(20, 600));
    [ctrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, dur) ofTrack:track atTime:kCMTimeZero error:nil];
    ctrack.preferredTransform = track.preferredTransform;
    NSString *tmp = [NSTemporaryDirectory() stringByAppendingPathComponent:@"omnicar-wallpaper.mp4"];
    [[NSFileManager defaultManager] removeItemAtPath:tmp error:nil];
    AVAssetExportSession *exp = [[AVAssetExportSession alloc] initWithAsset:comp
                                                                   presetName:AVAssetExportPreset1280x720];
    exp.outputURL = [NSURL fileURLWithPath:tmp];
    exp.outputFileType = AVFileTypeMPEG4;
    exp.shouldOptimizeForNetworkUse = YES;
    UIAlertController *working = [UIAlertController
        alertControllerWithTitle:nil message:L(@"APPS_VIDEO_WORKING")
                  preferredStyle:UIAlertControllerStyleAlert];
    [self presentViewController:working animated:YES completion:nil];
    [exp exportAsynchronouslyWithCompletionHandler:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [working dismissViewControllerAnimated:YES completion:^{
                if (exp.status != AVAssetExportSessionStatusCompleted) {
                    [self alert:exp.error.localizedDescription ?: L(@"APPS_VIDEO_FAILED")];
                    return;
                }
                NSString *hs = OMCDataPath(@"HomeScreen");
                NSFileManager *fm = [NSFileManager defaultManager];
                [fm createDirectoryAtPath:hs withIntermediateDirectories:YES attributes:nil error:nil];
                NSString *dest = [hs stringByAppendingPathComponent:@"video.mp4"];
                [fm removeItemAtPath:dest error:nil];
                NSError *err = nil;
                if (![fm moveItemAtPath:tmp toPath:dest error:&err]) {
                    [self alert:err.localizedDescription ?: L(@"APPS_VIDEO_FAILED")];
                    return;
                }
                [fm setAttributes:@{NSFilePosixPermissions: @0644} ofItemAtPath:dest error:nil];
                AVAssetImageGenerator *gen = [[AVAssetImageGenerator alloc]
                    initWithAsset:[AVURLAsset URLAssetWithURL:[NSURL fileURLWithPath:dest] options:nil]];
                gen.appliesPreferredTrackTransform = YES;
                CGImageRef cg = [gen copyCGImageAtTime:kCMTimeZero actualTime:nil error:nil];
                if (cg) {
                    UIImage *thumb = [UIImage imageWithCGImage:cg];
                    CGImageRelease(cg);
                    if ([self writeJPEG:thumb to:[hs stringByAppendingPathComponent:@"video.jpg"]]) {
                        self.videoThumb = thumb;
                        [self useStyle:8];
                        return;
                    }
                }
                [self alert:L(@"APPS_VIDEO_FAILED")];
            }];
        });
    }];
}

- (void)pickPhoto {
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary])
        return;
    UIImagePickerController *picker = [UIImagePickerController new];
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    picker.mediaTypes = @[UTTypeImage.identifier, UTTypeMovie.identifier];
    picker.videoExportPreset = AVAssetExportPresetPassthrough;
    picker.delegate = self;
    [self presentViewController:picker animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker
        didFinishPickingMediaWithInfo:(NSDictionary *)info {
    NSURL *url = info[UIImagePickerControllerMediaURL];
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    [picker dismissViewControllerAnimated:YES completion:^{
        if (url) [self useVideo:url];
        else if (image) [self useWallpaper:image];
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)alert:(NSString *)message {
    UIAlertController *ac = [UIAlertController alertControllerWithTitle:nil
        message:message preferredStyle:UIAlertControllerStyleAlert];
    [ac addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil]];
    [self presentViewController:ac animated:YES completion:nil];
}

@end
