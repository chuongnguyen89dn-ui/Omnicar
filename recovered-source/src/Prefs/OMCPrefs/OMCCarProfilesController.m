// OMCCarProfilesController.m — OmniCarPrefs reconstruction (Prefs-B)
// All methods VERIFIED against the disassembly (loadView 0x5844,
// viewDidLoad 0x58bc, reload 0x5a2c, enabledChanged: 0x5ce0,
// cellForRowAtIndexPath: 0x5e88, commitEditingStyle: 0x6560).
// Preference access goes through the TU-local read/write helpers
// (sub_5b64 = CopyAppValue, sub_5d34 = SetAppValue + AppSynchronize +
// notify_post) — same pattern as the other Prefs TUs.
#import "OMCCarProfilesController.h"
#import "OMCCommon.h"
#import <Preferences/PSSpecifier.h> // [integration phase 1; backported to src in phase 3] self.specifier's class must be fully declared, not @class-forwarded
#import <notify.h>

static id OMCCarPref(NSString *key) {
    return CFBridgingRelease(CFPreferencesCopyAppValue((__bridge CFStringRef)key,
                                                       CFSTR("com.anlai.omnicar")));
}
static void OMCCarSetPref(NSString *key, id value) {
    CFPreferencesSetAppValue((__bridge CFStringRef)key, (__bridge CFPropertyListRef)value,
                             CFSTR("com.anlai.omnicar"));
    CFPreferencesAppSynchronize(CFSTR("com.anlai.omnicar"));
    notify_post("com.anlai.omnicar/prefschanged");
}

@implementation OMCCarProfilesController

- (void)loadView {
    self.table = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    self.table.dataSource = self;
    self.table.delegate = self;
    self.view = self.table;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    OMCLoadStrings();
    self.title = self.specifier.name ?: L(@"PROFILES");
    self.view.tintColor = OMCAccentColor();
    self.table.backgroundColor = OMCBackgroundColor();
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self reload];
}

- (void)reload {
    CFPreferencesAppSynchronize(CFSTR("com.anlai.omnicar"));
    id raw = OMCCarPref(@"carProfiles");
    self.profiles = [raw isKindOfClass:[NSDictionary class]] ? raw : @{};
    self.keys = [self.profiles.allKeys sortedArrayUsingComparator:
        ^NSComparisonResult(NSString *a, NSString *b) {
            id da = self.profiles[a][@"lastSeen"];
            id db = self.profiles[b][@"lastSeen"];
            if ([da isKindOfClass:[NSDate class]] && [db isKindOfClass:[NSDate class]])
                return [(NSDate *)da compare:(NSDate *)db];
            return NSOrderedSame;
        }];
    [self.table reloadData];
}

- (void)enabledChanged:(UISwitch *)sender {
    OMCCarSetPref(@"carProfilesEnabled", @(sender.isOn));
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tv { return 2; }

- (NSInteger)tableView:(UITableView *)tv numberOfRowsInSection:(NSInteger)section {
    if (section == 0) return 1;
    NSInteger count = (NSInteger)self.keys.count;
    return count > 1 ? count + 1 : count;   // [VERIFIED formula]
}

- (NSString *)tableView:(UITableView *)tv titleForHeaderInSection:(NSInteger)section {
    return section == 1 ? L(@"PROFILES_CARS") : nil;
}

- (NSString *)tableView:(UITableView *)tv titleForFooterInSection:(NSInteger)section {
    if (section == 0) return L(@"PROFILES_FOOTER");
    return self.keys.count ? L(@"PROFILES_CARS_FOOTER") : nil;
}

- (void)tableView:(UITableView *)tv willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section {
    // The binary passes a second argument (1 = header) to the styling
    // helper; OMCCommon.h declares the one-argument form.
    ((void (*)(UIView *, BOOL))OMCStyleHeaderFooter)(view, YES);
}

- (void)tableView:(UITableView *)tv willDisplayFooterView:(UIView *)view forSection:(NSInteger)section {
    ((void (*)(UIView *, BOOL))OMCStyleHeaderFooter)(view, NO);
}

- (UITableViewCell *)tableView:(UITableView *)tv cellForRowAtIndexPath:(NSIndexPath *)ip {
    if (ip.section == 0) {
        UITableViewCell *cell = [tv dequeueReusableCellWithIdentifier:@"switch"];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                          reuseIdentifier:@"switch"];
            UISwitch *sw = [UISwitch new];
            sw.onTintColor = OMCSwitchColor();
            [sw addTarget:self action:@selector(enabledChanged:)
         forControlEvents:UIControlEventValueChanged];
            cell.accessoryView = sw;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        OMCStyleCell(cell);
        cell.textLabel.text = L(@"PROFILES_ENABLE");
        // VERIFIED nil color: at the binary call site the color argument
        // register is loaded with literal 0 (mov x1, #0 @0x6010, then
        // bl _OMCIcon @0x6014, x0 = @"car.2.fill" @0x6008).
        cell.imageView.image = OMCIcon(@"car.2.fill", nil);
        ((UISwitch *)cell.accessoryView).on = [OMCCarPref(@"carProfilesEnabled") boolValue];
        return cell;
    }
    UITableViewCell *cell = [tv dequeueReusableCellWithIdentifier:@"car"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                      reuseIdentifier:@"car"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    OMCStyleCell(cell);
    cell.detailTextLabel.textColor = [UIColor secondaryLabelColor];
    if (self.keys.count == 0 || ip.row >= (NSInteger)self.keys.count) {
        // Empty state (also the extra row the count formula adds). [INFERRED for extra row]
        cell.textLabel.text = L(@"PROFILES_NONE");
        cell.textLabel.textColor = [UIColor secondaryLabelColor];
        cell.detailTextLabel.text = nil;
        cell.imageView.image = nil;
        cell.accessoryType = UITableViewCellAccessoryNone;
        return cell;
    }
    NSString *carID = self.keys[ip.row];
    NSDictionary *profile = self.profiles[carID];
    cell.textLabel.textColor = [UIColor labelColor];
    id name = profile[@"name"];
    if ([name isKindOfClass:[NSString class]]) cell.textLabel.text = name;
    id seen = profile[@"lastSeen"];
    if ([seen isKindOfClass:[NSDate class]]) {
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%@: %@",
            L(@"PROFILES_LAST_SEEN"),
            [NSDateFormatter localizedStringFromDate:(NSDate *)seen
                                           dateStyle:NSDateFormatterShortStyle
                                           timeStyle:NSDateFormatterShortStyle]];
    } else {
        cell.detailTextLabel.text = nil;
    }
    // VERIFIED nil color: mov x1, #0 @0x6440 immediately before
    // bl _OMCIcon @0x6444 (x0 = @"car.fill" @0x6438).
    cell.imageView.image = OMCIcon(@"car.fill", nil);
    cell.accessoryType = [carID isEqual:OMCCarPref(@"carProfileCurrent")]
        ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
    return cell;
}

- (BOOL)tableView:(UITableView *)tv canEditRowAtIndexPath:(NSIndexPath *)ip {
    return ip.section == 1 && self.keys.count > 0;
}

- (void)tableView:(UITableView *)tv commitEditingStyle:(UITableViewCellEditingStyle)style
    forRowAtIndexPath:(NSIndexPath *)ip {
    if (style != UITableViewCellEditingStyleDelete) return;
    if (ip.row >= (NSInteger)self.keys.count) return;
    NSString *carID = self.keys[ip.row];
    NSMutableDictionary *profiles = [self.profiles mutableCopy];
    [profiles removeObjectForKey:carID];
    OMCCarSetPref(@"carProfiles", profiles.count ? profiles : nil);
    if ([carID isEqual:OMCCarPref(@"carProfileCurrent")])
        OMCCarSetPref(@"carProfileCurrent", nil);
    [self reload];
}

@end
