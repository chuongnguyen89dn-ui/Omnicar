// OMCCells.m — reconstructed from disasm/OMCFeatureStatusCell.asm,
// disasm/OMCAppBridgeAppsLinkCell.asm, disasm/OMCSplitScreenAppLinkCell.asm.
// All three cells are read-only displays: they read preferences directly
// (CFPreferences, domain com.anlai.omnicar) when Preferences refreshes them.

#import "OMCCells.h"
#import "OMCCommon.h"
#import <Preferences/PSSpecifier.h>

static id OMCCellPref(NSString *key) {
    return (__bridge_transfer id)CFPreferencesCopyAppValue((__bridge CFStringRef)key,
                                                           OMC_PREFS_DOMAIN);
}

@implementation OMCFeatureStatusCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style
              reuseIdentifier:(NSString *)identifier
                    specifier:(PSSpecifier *)specifier {
    return [super initWithStyle:style reuseIdentifier:identifier specifier:specifier];
}

// [VERIFIED] key/default come from the specifier properties that
// insertFeatureSpecifiers stamps ("featureKey"/"featureDefault").
- (void)refreshCellContentsWithSpecifier:(PSSpecifier *)specifier {
    [super refreshCellContentsWithSpecifier:specifier];
    NSString *key = [specifier propertyForKey:@"featureKey"];
    id def = [specifier propertyForKey:@"featureDefault"];
    id value = key ? OMCCellPref(key) : nil;
    BOOL on = value ? [value boolValue] : [def boolValue];
    self.detailTextLabel.text = L(on ? @"FEATURE_ON" : @"FEATURE_OFF");
    self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
}

@end

@implementation OMCAppBridgeAppsLinkCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style
              reuseIdentifier:(NSString *)identifier
                    specifier:(PSSpecifier *)specifier {
    return [super initWithStyle:style reuseIdentifier:identifier specifier:specifier];
}

// [VERIFIED] Proves the App Bridge selection lives under the preference key
// "appBridgeApps" as a countable collection (NSArray of bundle ids — the
// element encoding is proved by OMCAppBridgeAppsController).
- (void)refreshCellContentsWithSpecifier:(PSSpecifier *)specifier {
    [super refreshCellContentsWithSpecifier:specifier];
    CFPreferencesAppSynchronize(OMC_PREFS_DOMAIN);
    id apps = OMCCellPref(@"appBridgeApps");
    NSUInteger count = [apps respondsToSelector:@selector(count)] ? [apps count] : 0;
    if (count > 0) {
        self.detailTextLabel.text =
            [L(@"APPBRIDGE_APPS_COUNT") stringByReplacingOccurrencesOfString:@"%ld"
                                                                  withString:[@(count) stringValue]];
    } else {
        self.detailTextLabel.text = L(@"APPBRIDGE_APPS_NONE");
    }
    self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
}

@end

@implementation OMCSplitScreenAppLinkCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style
              reuseIdentifier:(NSString *)identifier
                    specifier:(PSSpecifier *)specifier {
    return [super initWithStyle:style reuseIdentifier:identifier specifier:specifier];
}

// [VERIFIED] The specifier's "key" property names a preference holding a
// bundle id; the row shows the app's localized name via the private
// LSApplicationProxy API.
- (void)refreshCellContentsWithSpecifier:(PSSpecifier *)specifier {
    [super refreshCellContentsWithSpecifier:specifier];
    NSString *key = [specifier propertyForKey:@"key"];
    NSString *bundleID = key ? OMCCellPref(key) : nil;
    NSString *text = nil;
    if (bundleID.length) {
        Class proxyClass = NSClassFromString(@"LSApplicationProxy");
        id proxy = [proxyClass applicationProxyForIdentifier:bundleID];
        text = [proxy localizedName] ?: bundleID;
    }
    self.detailTextLabel.text = text ?: L(@"SPLITSCREEN_APP_NOT_SET");
    self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
}

@end
