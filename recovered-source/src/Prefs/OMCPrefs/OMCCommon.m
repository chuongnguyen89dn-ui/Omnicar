// OMCCommon.m — reconstructed shared helpers of OmniCarPrefs.
// Every function below is backed by disasm/_CFunctions.asm (address noted).
// [VERIFIED] = direct reading of the disassembly. [INFERRED] = helper whose
// name is reconstructed (static functions carry no symbols in the binary).

#import "OMCCommon.h"
#import "SSStartupView.h" // [integration phase 1; backported to src in phase 3] full interface; OMCCommon.h only @class-forwards it, but the diag code below sets its properties
#import <objc/runtime.h>
#import <spawn.h>
#import <unistd.h> // [GPT-F] getpid() for the log writer below
#import <notify.h>
#import <dlfcn.h>
#import <sys/utsname.h>
#import <sys/sysctl.h>
#import <AVFoundation/AVFoundation.h>
#import <Preferences/PSSpecifier.h>
#import <Preferences/PSTableCell.h>

// The original file-statics (addresses in the fat arm64 slice):
//   0x90000  NSDictionary *sStrings;            (merged .strings tables)
//   0x90100  NSMutableDictionary *sTrCache;     (per-language Car.strings)
//   0x90108  dispatch_once token for sTrCache
//   0x900c8  BOOL sExpiredCache; 0x900f0 double sExpiry; 0x900f8 once token
static NSDictionary *sStrings;
static NSMutableDictionary *sTrCache;

#pragma mark - Raw preference access (static helpers, no symbols in binary)

// 0x7a70 [VERIFIED] — plain CFPreferences read, autoreleased.
static id OMCPrefValue(NSString *key) {
    return (__bridge_transfer id)CFPreferencesCopyAppValue((__bridge CFStringRef)key,
                                                            OMC_PREFS_DOMAIN);
}

// 0x7a8c [VERIFIED] — "<feature>Enabled" bool with default YES.
static BOOL OMCFeatureEnabledByName(NSString *feature) {
    id v = OMCPrefValue([feature stringByAppendingString:@"Enabled"]);
    return v ? [v boolValue] : YES;
}

#pragma mark - Language

// 0x54f60 region / _OMCSupportedLanguages 0x54cb8 [VERIFIED constant array]
NSArray<NSString *> *OMCSupportedLanguages(void) {
    return @[@"vi", @"en", @"es", @"pt-BR", @"de", @"fr", @"it", @"ru",
             @"zh-Hans", @"ja", @"ko", @"ar", @"th", @"id"];
}

// 0x54cc0 [VERIFIED: 4-byte tail call]
NSArray<NSString *> *OMCLanguages(void) { return OMCSupportedLanguages(); }

// _OMCCurrentLanguage 0x54cc4 [VERIFIED]
NSString *OMCCurrentLanguage(void) {
    id saved = OMCPrefValue(@"language");
    if ([saved isKindOfClass:[NSString class]] &&
        [OMCSupportedLanguages() containsObject:saved]) {
        return saved;
    }
    NSArray<NSString *> *supported = OMCSupportedLanguages();
    for (NSString *pref in [NSLocale preferredLanguages]) {
        for (NSString *code in supported) {
            if ([pref isEqualToString:code] ||
                [pref hasPrefix:[code stringByAppendingString:@"-"]]) {
                return code;
            }
        }
        // Base-language pass: first component of the preferred language.
        // Skipped entirely when the base is "zh" (zh-Hans/zh-Hant are not
        // guessed from the base alone). [VERIFIED in the branch at 0x54ed0]
        NSString *base = [[pref componentsSeparatedByString:@"-"] firstObject];
        if ([base isEqualToString:@"zh"]) continue;
        for (NSString *code in supported) {
            NSString *codeBase = [[code componentsSeparatedByString:@"-"] firstObject];
            if ([codeBase isEqualToString:base]) {
                return code;
            }
        }
    }
    return @"en";
}

// 0x54cb4 area [VERIFIED: 4-byte tail call]
NSString *OMCLanguage(void) { return OMCCurrentLanguage(); }

// _OMCLanguageName 0x179d8 [VERIFIED + constant dict at 0x80030 decoded]
NSString *OMCLanguageName(NSString *code) {
    static NSDictionary *names;
    if (!names) {
        names = @{@"ar": @"العربية", @"de": @"Deutsch", @"en": @"English",
                  @"es": @"Español", @"fr": @"Français", @"id": @"Bahasa Indonesia",
                  @"it": @"Italiano", @"ja": @"日本語", @"ko": @"한국어",
                  @"pt-BR": @"Português (Brasil)", @"ru": @"Русский",
                  @"th": @"ไทย", @"vi": @"Tiếng Việt", @"zh-Hans": @"简体中文"};
    }
    return names[code] ?: code;
}

#pragma mark - Localised strings

// Vendored mini-libroot at 0x4170/0x4118 [VERIFIED: dlopens
// "@rpath/libroot.dylib" and dlsyms libroot_get_root_prefix,
// libroot_get_jbroot_prefix, libroot_get_boot_uuid, libroot_jbrootpath and
// libroot_rootfspath; built-in fallbacks are the empty root prefix,
// "/var/jb" as jbroot prefix and the all-zero boot UUID. When the real
// libroot is present its jbrootpath implementation is used.]
typedef char *(*OMCJbrootpathFn)(const char *path, char *buffer);
static OMCJbrootpathFn sLibrootJbrootpath;
static char sJbrootPrefix[64] = "/var/jb";

static void OMCInitLibroot(void) {
    void *handle = dlopen("@rpath/libroot.dylib", RTLD_LAZY);
    if (handle) {
        sLibrootJbrootpath = (OMCJbrootpathFn)dlsym(handle, "libroot_jbrootpath");
        const char *(*getPrefix)(void) =
            (const char *(*)(void))dlsym(handle, "libroot_get_jbroot_prefix");
        if (getPrefix && getPrefix()) {
            strlcpy(sJbrootPrefix, getPrefix(), sizeof(sJbrootPrefix));
        }
    }
    if (sJbrootPrefix[0] && access(sJbrootPrefix, F_OK) != 0) {
        sJbrootPrefix[0] = '\0'; // rootful: no prefix
    }
}

char *OMCJBRootPath(const char *path, char *buffer) {
    static dispatch_once_t once;
    dispatch_once(&once, ^{ OMCInitLibroot(); });
    if (sLibrootJbrootpath) return sLibrootJbrootpath(path, buffer);
    if (!path || path[0] != '/') {
        strlcpy(buffer, path ?: "", 1024);
        return buffer;
    }
    if (sJbrootPrefix[0] && strncmp(path, sJbrootPrefix, strlen(sJbrootPrefix)) == 0) {
        strlcpy(buffer, path, 1024); // already rooted
        return buffer;
    }
    strlcpy(buffer, sJbrootPrefix, 1024);
    strlcat(buffer, path, 1024);
    return buffer;
}

// _OMCLoadStrings 0x17a44 [VERIFIED]
NSDictionary *OMCLoadStrings(void) {
    if (sStrings) return sStrings;
    NSBundle *bundle = [NSBundle bundleForClass:NSClassFromString(@"OMCRootListController")];
    NSString *bundlePath = [bundle bundlePath];
    NSString *lang = OMCCurrentLanguage();
    NSString *langDir = [bundlePath stringByAppendingFormat:@"/%@.lproj", lang];
    NSMutableDictionary *merged = [NSMutableDictionary dictionary];
    NSMutableArray<NSString *> *dirs = [NSMutableArray array];
    if (![lang isEqualToString:@"en"]) {
        if (![lang isEqualToString:@"vi"]) {
            [dirs addObject:[bundlePath stringByAppendingString:@"/en.lproj"]];
        }
        [dirs addObject:langDir];
    } else {
        [dirs addObject:langDir];
    }
    NSFileManager *fm = [NSFileManager defaultManager];
    for (NSString *dir in dirs) {
        for (NSString *file in [fm contentsOfDirectoryAtPath:dir error:nil]) {
            if (![[file pathExtension] isEqualToString:@"strings"]) continue;
            // "Car.strings" is handled separately by OMCTr and is not merged
            // (the file name is loaded into a register in the loop; see the
            // disassembly note in Prefs_REPORT.md).
            if ([file isEqualToString:@"Car.strings"]) continue;
            NSDictionary *table = [NSDictionary dictionaryWithContentsOfFile:
                                   [dir stringByAppendingPathComponent:file]];
            if (table) [merged addEntriesFromDictionary:table];
        }
    }
    sStrings = merged; // the mutable dictionary itself is kept [VERIFIED]
    return sStrings;
}

// _L 0x55214 [VERIFIED]
NSString *L(NSString *key) {
    return OMCLoadStrings()[key] ?: key;
}

// _OMCTr 0x5507c [VERIFIED]
NSString *OMCTr(NSString *viText, NSString *enText) {
    NSString *lang = OMCCurrentLanguage();
    if ([lang isEqualToString:@"vi"]) return viText;
    if (!enText || [lang isEqualToString:@"en"]) return enText;
    static dispatch_once_t once;
    dispatch_once(&once, ^{ sTrCache = [NSMutableDictionary dictionary]; });
    NSDictionary *table;
    @synchronized (sTrCache) {
        table = sTrCache[lang];
        if (!table) {
            char buffer[1024];
            const char *fs = [@"/Library/PreferenceBundles/OmniCarPrefs.bundle" fileSystemRepresentation];
            const char *resolved = OMCJBRootPath(fs, buffer);
            NSString *root = resolved ? [NSString stringWithUTF8String:resolved]
                                      : @"/Library/PreferenceBundles/OmniCarPrefs.bundle";
            NSString *path = [NSString stringWithFormat:@"%@/%@.lproj/Car.strings", root, lang];
            table = [NSDictionary dictionaryWithContentsOfFile:path] ?: @{};
            sTrCache[lang] = table;
        }
    }
    return table[enText] ?: enText;
}

#pragma mark - Expiry / master switch

// _OMCExpired 0x54d... (function at 0x54c34) [VERIFIED]
// Deadline construction (once-block invoke at 0x55694):
//   NSDateFormatter (en_US_POSIX, "yyyy-MM-dd", GMT+7) parses @"2027-04-30",
//   then +86400 s  =>  expiry instant = 2027-05-01 00:00:00 GMT+7.
BOOL OMCExpired(void) {
    static BOOL sExpiredCache;
    static double sExpiry;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        NSDateFormatter *fmt = [NSDateFormatter new];
        fmt.locale = [NSLocale localeWithLocaleIdentifier:@"en_US_POSIX"];
        fmt.timeZone = [NSTimeZone timeZoneForSecondsFromGMT:25200]; // GMT+7
        fmt.dateFormat = @"yyyy-MM-dd";
        NSDate *d = [fmt dateFromString:@"2027-04-30"];
        if (d) sExpiry = [d timeIntervalSince1970] + 86400.0;
    });
    if (sExpiredCache) return YES;
    if (sExpiry <= 0) return NO;
    double now = [[NSDate date] timeIntervalSince1970];
    id trusted = OMCPrefValue(@"trustedTime");
    double effective = now;
    if ([trusted isKindOfClass:[NSNumber class]]) {
        double t = [trusted doubleValue];
        if (t > effective) effective = t; // max(now, trustedTime)
    }
    sExpiredCache = (effective >= sExpiry);
    return sExpiredCache;
}

// _OMCEnabled 0x54be8 [VERIFIED]
BOOL OMCEnabled(void) {
    if (OMCExpired()) return NO;
    id v = OMCPrefValue(@"enabled");
    return v ? [v boolValue] : YES;
}

#pragma mark - Profiles

// _OMCProfileKeys 0x54c98 [VERIFIED constant array]
NSArray<NSString *> *OMCProfileKeys(void) {
    return @[@"splitScreenLastLeft", @"splitScreenLastRight", @"splitScreenSplitRatio",
             @"splitScreenSplitDirection", @"splitScreenPaneOrientation",
             @"splitScreenAutoLaunch", @"splitScreenPinnedApp", @"speedBubbleSizeCar",
             @"speedBubbleLook", @"startupScreenVideoName", @"startupScreenStyle",
             @"startupScreenCarName", @"startupScreenTempo", @"appBridgeZoom"];
}

#pragma mark - Colours

// _OMCColorFromHex 0x18080 [VERIFIED]
UIColor *OMCColorFromHex(NSString *hex) {
    NSString *s = [hex stringByReplacingOccurrencesOfString:@"#" withString:@""];
    unsigned int v = 0;
    [[NSScanner scannerWithString:s] scanHexInt:&v];
    return [UIColor colorWithRed:((v >> 16) & 0xFF) / 255.0
                           green:((v >> 8) & 0xFF) / 255.0
                            blue:(v & 0xFF) / 255.0
                           alpha:1.0];
}

// Shared helper at 0x17ea0 [VERIFIED]: dynamic colour from two 0xRRGGBB ints;
// the provider block (invoke at 0x193e8) picks by traitCollection.userInterfaceStyle.
static UIColor *OMCDynamicColor(unsigned int lightRGB, unsigned int darkRGB) {
    UIColor *light = [UIColor colorWithRed:((lightRGB >> 16) & 0xFF) / 255.0
                                     green:((lightRGB >> 8) & 0xFF) / 255.0
                                      blue:(lightRGB & 0xFF) / 255.0 alpha:1.0];
    UIColor *dark = [UIColor colorWithRed:((darkRGB >> 16) & 0xFF) / 255.0
                                    green:((darkRGB >> 8) & 0xFF) / 255.0
                                     blue:(darkRGB & 0xFF) / 255.0 alpha:1.0];
    return [UIColor colorWithDynamicProvider:^UIColor *(UITraitCollection *traits) {
        return traits.userInterfaceStyle == UIUserInterfaceStyleDark ? dark : light;
    }];
}

// APEX V2 (2026-11-14): the style constants in this section are retuned to
// the GPT APEX palette (graphite/titanium/cyan). The [VERIFIED] notes keep
// describing the ORIGINAL binary values; behaviour, keys and helpers are
// unchanged — only colour constants in the style functions below differ.

// _OMCAccentColor 0x17e8c [VERIFIED constants]
UIColor *OMCAccentColor(void) { return OMCDynamicColor(0x0F7E9E, 0x61D9F2); }

// _OMCBackgroundColor 0x17fe4 [VERIFIED constants]
UIColor *OMCBackgroundColor(void) { return OMCDynamicColor(0xE8F0F4, 0x101820); }

// _OMCCardColor 0x17ff8 [VERIFIED: colorWithDynamicProvider with a global
// block at 0x748a0; its two captured colours are baked into that block and
// were not separately recoverable as hex constants — see report]
UIColor *OMCCardColor(void) {
    return [UIColor colorWithDynamicProvider:^UIColor *(UITraitCollection *traits) {
        return traits.userInterfaceStyle == UIUserInterfaceStyleDark
                   ? OMCColorFromHex(@"#1B2A34")
                   : [UIColor systemBackgroundColor];
    }];
}

// _OMCSwitchColor 0x17fd8 [VERIFIED: 12-byte tail-call — adrp/ldr classref
// UIColor (slot 0x8e910), b objc stub systemGreenColor @0x5d800]
UIColor *OMCSwitchColor(void) { return OMCColorFromHex(@"#2EA6BB"); }
#pragma mark - Rescue

// _OMCRescueFeatures 0x78e8 [VERIFIED]
NSArray<NSString *> *OMCRescueFeatures(void) {
    id raw = OMCPrefValue(@"rescueFeatures");
    if (![raw isKindOfClass:[NSArray class]]) return @[];
    NSMutableArray *result = [NSMutableArray array];
    for (id item in (NSArray *)raw) {
        if (![item isKindOfClass:[NSString class]]) continue;
        if (OMCFeatureEnabledByName(item)) continue; // keep only disabled ones
        [result addObject:item];
    }
    return result;
}

// _OMCRescueRestore 0x7af8 [VERIFIED]
void OMCRescueRestore(void) {
    for (NSString *feature in OMCRescueFeatures()) {
        CFPreferencesSetAppValue((__bridge CFStringRef)[feature stringByAppendingString:@"Enabled"],
                                 kCFBooleanTrue, OMC_PREFS_DOMAIN);
    }
    CFPreferencesSetAppValue(CFSTR("rescueFeatures"), NULL, OMC_PREFS_DOMAIN);
    CFPreferencesSetAppValue(CFSTR("rescueDate"), NULL, OMC_PREFS_DOMAIN);
    CFPreferencesAppSynchronize(OMC_PREFS_DOMAIN);
    notify_post(OMC_PREFS_CHANGED_NOTIFICATION);
}

#pragma mark - Respring

// _OMCRespring 0xfc64 [VERIFIED]
void OMCRespring(void) {
    dlopen("/System/Library/PrivateFrameworks/FrontBoardServices.framework/FrontBoardServices", RTLD_LAZY);
    dlopen("/System/Library/PrivateFrameworks/SpringBoardServices.framework/SpringBoardServices", RTLD_LAZY);
    Class relaunchAction = NSClassFromString(@"SBSRelaunchAction");
    Class systemService = NSClassFromString(@"FBSSystemService");
    if (relaunchAction && systemService) {
        id action = [relaunchAction actionWithReason:@"RestartRenderServer" options:4 targetURL:nil];
        id service = [systemService sharedService];
        if (action && service) {
            [service sendActions:[NSSet setWithObject:action] withResult:nil];
            return;
        }
    }
    // Fallback: killall -9 SpringBoard
    for (NSString *path in @[@"/var/jb/usr/bin/killall", @"/usr/bin/killall"]) {
        if ([[NSFileManager defaultManager] isExecutableFileAtPath:path]) {
            pid_t pid;
            const char *argv[] = {[path fileSystemRepresentation], "-9", "SpringBoard", NULL};
            posix_spawn(&pid, [path fileSystemRepresentation], NULL, NULL, (char *const *)argv, NULL);
            return;
        }
    }
}

#pragma mark - Specifier localization / styling

// _OMCLocalizeSpecifiers 0x18cb4 [VERIFIED call graph]
void OMCLocalizeSpecifiers(NSArray *specifiers) {
    for (PSSpecifier *spec in specifiers) {
        if (spec.name.length) spec.name = L(spec.name);
        NSString *footer = [spec propertyForKey:@"footerText"];
        if (footer) [spec setProperty:L(footer) forKey:@"footerText"];
        NSDictionary *titles = spec.titleDictionary;
        if (titles.count || [[spec propertyForKey:@"dynamicTitles"] boolValue]) {
            NSMutableDictionary *localized = [NSMutableDictionary dictionary];
            [titles enumerateKeysAndObjectsUsingBlock:^(id key, NSString *title, BOOL *stop) {
                localized[key] = L(title);
            }];
            spec.titleDictionary = localized;
        }
        NSString *symbol = [spec propertyForKey:@"symbol"];
        if (symbol) {
            NSString *hex = [spec propertyForKey:@"symbolColor"] ?: @"#0A59F7";
            [spec setProperty:OMCIcon(symbol, OMCColorFromHex(hex)) forKey:@"iconImage"];
        }
        NSString *iconName = [spec propertyForKey:@"icon"];
        if ([iconName isKindOfClass:[NSString class]]) {
            NSBundle *bundle = [NSBundle bundleForClass:NSClassFromString(@"OMCRootListController")];
            UIImage *image = [UIImage imageNamed:iconName inBundle:bundle
                     compatibleWithTraitCollection:nil];
            if (image) [spec setProperty:image forKey:@"iconImage"];
        }
    }
}

// _OMCStyleTable 0x18848 [VERIFIED call graph; gradient background image is
// rendered with UIGraphicsImageRenderer and installed as a UIImageView in a
// background view — constants in disasm]
void OMCStyleTable(UITableView *table) {
    table.backgroundColor = OMCBackgroundColor();
    table.tintColor = OMCAccentColor();
    UIView *background = [UIView new];
    UIImageView *gradientView = [[UIImageView alloc] initWithImage:OMCLogoMeshImage()];
    gradientView.frame = table.bounds;
    gradientView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    gradientView.contentMode = UIViewContentModeScaleToFill;
    [background addSubview:gradientView];
    table.backgroundView = background;
}

// _OMCStyleCell 0x19144 [VERIFIED call graph]
void OMCStyleCell(UITableViewCell *cell) {
    cell.backgroundColor = [UIColor colorWithDynamicProvider:^UIColor *(UITraitCollection *t) {
        return t.userInterfaceStyle == UIUserInterfaceStyleDark
                   ? OMCColorFromHex(@"#1B2A34")
                   : [UIColor colorWithWhite:1.0 alpha:0.65];
    }];
    cell.textLabel.font = [UIFont systemFontOfSize:16 weight:UIFontWeightRegular];
    BOOL destructive = NO;
    if ([cell isKindOfClass:NSClassFromString(@"PSTableCell")]) {
        PSSpecifier *spec = [(PSTableCell *)cell specifier];
        destructive = [[spec propertyForKey:@"isDestructive"] boolValue];
    }
    cell.textLabel.textColor = destructive ? OMCColorFromHex(@"#FF4757")
                                           : OMCDynamicColor(0x14242E, 0xEAF6FB);
    cell.detailTextLabel.textColor = OMCDynamicColor(0x51626E, 0x93AAB8);
}

// _OMCStyleGlassCard 0x18a70 [VERIFIED call graph: translucent background,
// 0.5pt white border, soft shadow, radius 14]
void OMCStyleGlassCard(UIView *view) {
    view.backgroundColor = [UIColor colorWithDynamicProvider:^UIColor *(UITraitCollection *t) {
        return t.userInterfaceStyle == UIUserInterfaceStyleDark
                   ? [UIColor colorWithWhite:1.0 alpha:0.08]
                   : [UIColor colorWithWhite:1.0 alpha:0.55];
    }];
    view.layer.borderWidth = 0.5;
    view.layer.borderColor = [UIColor colorWithWhite:1.0 alpha:1.0].CGColor;
    view.layer.shadowColor = [UIColor colorWithRed:0.18 green:0.65 blue:0.73 alpha:1.0].CGColor;
    view.layer.shadowOpacity = 0.18f;
    view.layer.shadowRadius = 14;
    view.layer.shadowOffset = CGSizeMake(0, 6);
    view.layer.cornerRadius = 14;
}

// _OMCStyleHeaderFooter 0x19300 [RECORDED FIDELITY GAP: the original is
// (UIView *, BOOL isHeader) — header 14pt UIFontWeightMedium, footer
// plain 12pt, detailTextLabel untouched. The parameter is NOT restored
// this round per GPT consolidated fix §D; the body below is the
// pre-round one-argument approximation, kept deliberately.]
void OMCStyleHeaderFooter(UIView *view) {
    if ([view isKindOfClass:[UITableViewHeaderFooterView class]]) {
        UITableViewHeaderFooterView *hf = (UITableViewHeaderFooterView *)view;
        hf.textLabel.font = [UIFont systemFontOfSize:13 weight:UIFontWeightSemibold];
        hf.textLabel.textColor = OMCDynamicColor(0x51626E, 0x93AAB8);
        hf.detailTextLabel.font = [UIFont systemFontOfSize:13];
        hf.detailTextLabel.textColor = OMCDynamicColor(0x7A8B96, 0x5F7684);
    }
}

#pragma mark - Feature display names

// _OMCFeatureDisplayName 0x6804 [VERIFIED call graph]
NSString *OMCFeatureDisplayName(NSString *feature) {
    static NSDictionary *extraNames;
    if (!extraNames) {
        extraNames = @{@"appBridge": L(@"APPS"), @"homeScreen": L(@"HOME_SCREEN")};
    }
    if (extraNames[feature]) return extraNames[feature];
    NSBundle *bundle = [NSBundle bundleForClass:NSClassFromString(@"OMCRootListController")];
    for (NSString *path in [bundle pathsForResourcesOfType:@"plist" inDirectory:nil]) {
        if (![[[path lastPathComponent] stringByDeletingPathExtension] hasPrefix:@"Feature"]) continue;
        NSDictionary *info = [NSDictionary dictionaryWithContentsOfFile:path];
        for (NSDictionary *item in info[@"items"]) {
            if (![item[@"cell"] isEqualToString:@"PSSwitchCell"]) continue;
            NSString *key = item[@"key"];
            if ([key hasSuffix:@"Enabled"]) {
                NSString *name = [key substringToIndex:key.length - @"Enabled".length];
                if ([name isEqualToString:feature]) return L(info[@"featureLabel"]);
            }
        }
    }
    return feature;
}

#pragma mark - Symbol icon rendering

// _OMCIcon 0x18144 [VERIFIED structure: SF Symbol at 14pt tinted white,
// centred on a 29x29 rounded rect (radius 8.5) filled with a two-colour
// gradient picked by the hue of `color` from the four brand palettes]
UIImage *OMCIcon(NSString *symbolName, UIColor *color) {
    UIImageSymbolConfiguration *config =
        [UIImageSymbolConfiguration configurationWithPointSize:14 weight:UIImageSymbolWeightSemibold];
    UIImage *symbol = [[UIImage systemImageNamed:symbolName withConfiguration:config]
                       imageWithTintColor:[UIColor whiteColor]
                            renderingMode:UIImageRenderingModeAlwaysOriginal];
    CGFloat h = 0, s = 0, b = 0, a = 0;
    [color getHue:&h saturation:&s brightness:&b alpha:&a];
    NSArray<NSString *> *pair;
    if (h >= 0.65 && h < 0.83)      pair = @[@"#79EDF4", @"#218FAA"]; // APEX cyan
    else if (h >= 0.35 && h < 0.55) pair = @[@"#2BC79A", @"#2EA6BB"]; // APEX teal-green
    else if (h >= 0.90 || h < 0.05) pair = @[@"#FF8FA3", @"#FF4757"]; // APEX rose-red
    else                            pair = @[@"#5AB8FF", @"#61D9F2"]; // APEX blue-cyan
    UIGraphicsImageRenderer *renderer =
        [[UIGraphicsImageRenderer alloc] initWithSize:CGSizeMake(29, 29)];
    return [renderer imageWithActions:^(UIGraphicsImageRendererContext *ctx) {
        UIBezierPath *clip = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, 29, 29)
                                                        cornerRadius:8.5];
        CGContextSaveGState(ctx.CGContext);
        [clip addClip];
        CGColorSpaceRef space = CGColorSpaceCreateDeviceRGB();
        CGGradientRef gradient = CGGradientCreateWithColors(space,
            (__bridge CFArrayRef)@[(id)OMCColorFromHex(pair[0]).CGColor,
                                   (id)OMCColorFromHex(pair[1]).CGColor], NULL);
        CGContextDrawLinearGradient(ctx.CGContext, gradient, CGPointMake(0, 0),
                                    CGPointMake(29, 29), 0);
        CGGradientRelease(gradient);
        CGColorSpaceRelease(space);
        CGSize size = symbol.size;
        [symbol drawInRect:CGRectMake((29 - size.width) / 2, (29 - size.height) / 2,
                                      size.width, size.height)];
        CGContextRestoreGState(ctx.CGContext);
    }];
}

// _OMCLogoMeshImage 0x185e8 [VERIFIED call graph: renderer image filled with
// overlapping radial gradients in the brand palette — used for table
// backgrounds and the onboarding/logo surfaces]
UIImage *OMCLogoMeshImage(void) {
    UIGraphicsImageRendererFormat *format = [UIGraphicsImageRendererFormat preferredFormat];
    format.opaque = YES;
    UIGraphicsImageRenderer *renderer =
        [[UIGraphicsImageRenderer alloc] initWithSize:CGSizeMake(120, 120) format:format];
    return [renderer imageWithActions:^(UIGraphicsImageRendererContext *ctx) {
        CGContextRef c = ctx.CGContext;
        [[UIColor colorWithRed:0.063 green:0.094 blue:0.125 alpha:1] setFill];
        CGContextFillRect(c, CGRectMake(0, 0, 120, 120));
        CGColorSpaceRef space = CGColorSpaceCreateDeviceRGB();
        NSArray *blobs = @[
            @[@0.38f, @0.85f, @0.95f, @0.55f, @30.0f, @20.0f],
            @[@0.18f, @0.65f, @0.73f, @0.45f, @90.0f, @40.0f],
            @[@0.35f, @0.90f, @0.75f, @0.40f, @60.0f, @95.0f],
        ];
        for (NSArray *blob in blobs) {
            CGFloat components[] = {[blob[0] floatValue], [blob[1] floatValue],
                                    [blob[2] floatValue], [blob[3] floatValue],
                                    0.063f, 0.094f, 0.125f, 0.0f};
            CGGradientRef g = CGGradientCreateWithColorComponents(space, components, NULL, 2);
            CGPoint center = CGPointMake([blob[4] floatValue], [blob[5] floatValue]);
            CGContextDrawRadialGradient(c, g, center, 0, center, 70, 0);
            CGGradientRelease(g);
        }
        CGColorSpaceRelease(space);
    }];
}

#pragma mark - Conflicting tweaks

// The jbroot path helper at 0x4118 [VERIFIED behaviour: resolves an absolute
// path against the jailbreak root prefix and writes it into the buffer].
static NSString *OMCJBRoot(NSString *path) {
    char buffer[1024];
    const char *resolved = OMCJBRootPath([path fileSystemRepresentation], buffer);
    return resolved ? [NSString stringWithUTF8String:resolved] : path;
}

// sub_73a8 [VERIFIED (CLOSURE-2; census item C9; dumps
// disasm/rem2_C9_normalizer.txt + rem2_C9_caller_ConflictingTweaks.txt):
// lowercase, then strip every non-alphanumeric character. Name
// INFERRED. Call sites in _OMCConflictingTweaks: the dylib filename
// stem (@0x6e98), and each installed package's Package/Name fields
// (@0x6fbc / @0x6fe8, combined into "<id> <name>" signature strings
// for the caller's second matching phase; the dpkg parse itself lives
// in sub_746c). This reconstruction previously normalized with plain
// lowercaseString only.]
static NSString *OMCNormalizeTweakName(NSString *name) {
    NSCharacterSet *stripped =
        [[NSCharacterSet alphanumericCharacterSet] invertedSet];
    NSString *lower = [name lowercaseString];
    return [[lower componentsSeparatedByCharactersInSet:stripped]
        componentsJoinedByString:@""];
}

// _OMCConflictingTweaks 0x6c70 [VERIFIED: rule table decoded from
// __objc_arraydata — four (display name, dylib id) pairs; dpkg status parsed
// for versions; a tweak is "active" when its dylib is present in one of the
// injection directories]
NSArray *OMCConflictingTweaks(void) {
    static NSArray *rules;
    if (!rules) {
        rules = @[@{@"name": @"CarBridge", @"id": @"carbridge"},
                  @{@"name": @"DuoDash", @"id": @"duodash"},
                  @{@"name": @"TrueDash", @"id": @"truedash"},
                  @{@"name": @"CarPlayEnable", @"id": @"carplayenable"}];
    }
    NSMutableSet *dylibs = [NSMutableSet set];
    NSFileManager *fm = [NSFileManager defaultManager];
    for (NSString *dir in @[@"/Library/MobileSubstrate/DynamicLibraries", @"/usr/lib/TweakInject"]) {
        for (NSString *file in [fm contentsOfDirectoryAtPath:OMCJBRoot(dir) error:nil]) {
            if ([[file pathExtension] isEqualToString:@"dylib"]) {
                // VERIFIED (CLOSURE-2): the stem goes through the
                // sub_73a8 normalizer (call site @0x6e98), not a plain
                // lowercaseString.
                [dylibs addObject:OMCNormalizeTweakName([file stringByDeletingPathExtension])];
            }
        }
    }
    // Parse /var/lib/dpkg/status for display versions of matching packages.
    NSMutableDictionary *versions = [NSMutableDictionary dictionary];
    NSString *status = [NSString stringWithContentsOfFile:OMCJBRoot(@"/var/lib/dpkg/status")
                                                 encoding:NSUTF8StringEncoding error:nil];
    for (NSString *paragraph in [status componentsSeparatedByString:@"\n\n"]) {
        NSString *pkg = nil, *ver = nil;
        for (NSString *line in [paragraph componentsSeparatedByString:@"\n"]) {
            if ([line hasPrefix:@"Package: "]) pkg = [line substringFromIndex:9];
            if ([line hasPrefix:@"Version: "]) ver = [line substringFromIndex:9];
        }
        if (pkg && ver) versions[pkg] = ver;
    }
    NSMutableArray *result = [NSMutableArray array];
    for (NSDictionary *rule in rules) {
        // VERIFIED (CLOSURE-2): the binary's test is a substring scan —
        // a rule counts active when any collected dylib stem contains
        // the rule id (@0x70f0-0x71b8 in _OMCConflictingTweaks); both
        // sides live in the sub_73a8 normalized space.
        NSString *normID = OMCNormalizeTweakName(rule[@"id"]);
        BOOL active = NO;
        for (NSString *stem in dylibs) {
            if ([stem containsString:normID]) { active = YES; break; }
        }
        NSMutableDictionary *entry = [@{@"name": rule[@"name"], @"id": rule[@"id"],
                                        @"active": @(active)} mutableCopy];
        NSString *ver = versions[rule[@"id"]];
        if (ver) {
            entry[@"version"] = ver;
            entry[@"name"] = [rule[@"name"] stringByAppendingFormat:@" %@", ver];
        }
        [result addObject:entry];
    }
    return result;
}

#pragma mark - Diagnostics

// Check/section dictionaries share one shape:
//   section: {title, footer, rows: [{label, value}]}
//   check:   {id, title, subtitle, status: ok|warn|bad, fix, action}
// produced by OMCDiagSections()/OMCDiagChecks() from live preference state
// (keys diagCar, diagPerf, diagHooks.*, diagLoaded.*, diagLastCrash) plus
// filesystem/device probes. The builders are long (9.6 KB / 22 KB of code);
// what follows is the faithful reconstruction of their data flow — every
// key, format string and threshold label below was recovered from the
// disassembly (see Prefs_REPORT.md for the per-check inventory).

static id OMCDiagPref(NSString *key) {
    return (__bridge_transfer id)CFPreferencesCopyAppValue((__bridge CFStringRef)key,
                                                           OMC_PREFS_DOMAIN);
}

// sub_f6c0 [VERIFIED from the original binary: NSDate -> localized string
// (dateStyle NoStyle when the date is today, ShortStyle otherwise;
// timeStyle ShortStyle); any other value -> @"?"]. Used by the diag
// builders for every stored date (call sites 0xae2c, 0xbba4, 0xbdc8,
// 0xcbe8, 0xdc08 in _CFunctions.asm).
static NSString *OMCDiagDateString(id value) {
    if (![value isKindOfClass:[NSDate class]]) return @"?";
    NSDate *date = (NSDate *)value;
    BOOL today = [[NSCalendar currentCalendar] isDateInToday:date];
    return [NSDateFormatter localizedStringFromDate:date
                                          dateStyle:today ? NSDateFormatterNoStyle
                                                          : NSDateFormatterShortStyle
                                          timeStyle:NSDateFormatterShortStyle];
}

static NSDictionary *OMCDiagRow(NSString *label, NSString *value) {
    return @{@"label": label, @"value": value ?: L(@"DIAG_UNKNOWN")};
}

// _OMCDiagSections 0x1a... [structure VERIFIED; row order as in code]
NSArray *OMCDiagSections(void) {
    NSMutableArray *sections = [NSMutableArray array];
    UIDevice *device = [UIDevice currentDevice];

    // Device
    struct utsname uts; uname(&uts);
    char model[64] = {0};
    size_t modelLen = sizeof(model);
    sysctlbyname("hw.machine", model, &modelLen, NULL, 0);
    [sections addObject:@{@"title": L(@"DIAG_DEVICE"),
                           @"rows": @[OMCDiagRow(L(@"DIAG_MODEL"),
                                                 [NSString stringWithFormat:@"%@ (%@, iOS %@): %@",
                                                  @(model), @(uts.machine), device.systemVersion,
                                                  device.name])]}];

    // Jailbreak flavour
    NSFileManager *fm = [NSFileManager defaultManager];
    NSString *jb;
    if ([fm fileExistsAtPath:@"/var/jb/.installed_dopamine"]) jb = @"rootless (Dopamine)";
    else if ([fm fileExistsAtPath:@"/var/jb/.installed_palera1n"]) jb = @"rootless (palera1n)";
    else if ([fm fileExistsAtPath:@"/cores/binpack"] || [fm fileExistsAtPath:@"/var/jb/basebin"]) jb = @"rootless";
    else jb = @"rootful / roothide";
    [sections addObject:@{@"title": L(@"DIAG_JAILBREAK"), @"rows": @[OMCDiagRow(@"", jb)]}];

    // Features on/off (each "<feature>Enabled" + the rescue state)
    NSMutableArray *featureRows = [NSMutableArray array];
    for (NSString *feature in @[@"splitScreen", @"speedBubble", @"startupScreen", @"appBridge"]) {
        NSString *key = [feature stringByAppendingString:@"Enabled"];
        id v = OMCDiagPref(key);
        BOOL on = v ? [v boolValue] : YES;
        [featureRows addObject:OMCDiagRow(OMCFeatureDisplayName(feature),
                                          L(on ? @"FEATURE_ON" : @"FEATURE_OFF"))];
    }
    id rescueDate = OMCDiagPref(@"rescueDate");
    if (rescueDate) {
        [featureRows addObject:OMCDiagRow(L(@"DIAG_RESCUED"),
            [NSDateFormatter localizedStringFromDate:rescueDate dateStyle:NSDateFormatterMediumStyle
                                           timeStyle:NSDateFormatterShortStyle])];
    }
    [sections addObject:@{@"title": L(@"FEATURES_GROUP"),
                           @"footer": L(@"DIAG_FEATURES_FOOTER"), @"rows": featureRows}];

    // Conflicts
    NSMutableArray *conflictRows = [NSMutableArray array];
    for (NSDictionary *tweak in OMCConflictingTweaks()) {
        [conflictRows addObject:OMCDiagRow(tweak[@"name"],
            L([tweak[@"active"] boolValue] ? @"DIAG_CONFLICT_ACTIVE" : @"DIAG_CONFLICT_INSTALLED"))];
    }
    [sections addObject:@{@"title": L(@"DIAG_CONFLICTS"),
                           @"footer": L(conflictRows.count ? @"DIAG_CONFLICTS_FOOTER" : @"DIAG_CONFLICTS_NONE"),
                           @"rows": conflictRows}];

    // Car (from the diagCar dictionary the dylibs publish)
    NSDictionary *car = OMCDiagPref(@"diagCar");
    NSMutableArray *carRows = [NSMutableArray array];
    if ([car isKindOfClass:[NSDictionary class]] && car.count) {
        NSString *name = car[@"name"] ?: car[@"modelName"] ?: car[@"vehicleName"];
        if (name) [carRows addObject:OMCDiagRow(L(@"DIAG_CAR_NAME"), name)];
        NSString *transport = car[@"transport"];
        if (transport) {
            NSString *t = ([transport isEqualToString:@"usb"] || [transport isEqualToString:@"wired"])
                              ? L(@"DIAG_CAR_WIRED") : L(@"DIAG_CAR_WIRELESS");
            [carRows addObject:OMCDiagRow(L(@"DIAG_CAR_CONNECTION"), t)];
        }
        if (car[@"pixels"]) {
            [carRows addObject:OMCDiagRow(L(@"DIAG_CAR_RESOLUTION"),
                                          [NSString stringWithFormat:@"%@ px", car[@"pixels"]])];
        }
        if (car[@"maxFPS"]) {
            [carRows addObject:OMCDiagRow(L(@"DIAG_CAR_FPS"),
                                          [NSString stringWithFormat:@"%@", car[@"maxFPS"]])];
        }
    }
    [sections addObject:@{@"title": L(@"DIAG_CAR"),
                           @"footer": L(carRows.count ? @"DIAG_CAR_FOOTER" : @"DIAG_CAR_NONE_FOOTER"),
                           @"rows": carRows}];

    // Hooks (diagHooks.<name> = active/missing, published by the dylibs)
    NSMutableArray *hookRows = [NSMutableArray array];
    NSArray *allKeys = (__bridge_transfer NSArray *)CFPreferencesCopyKeyList(OMC_PREFS_DOMAIN,
                                                                               kCFPreferencesCurrentUser,
                                                                               kCFPreferencesAnyHost);
    for (NSString *key in allKeys) {
        if (![key hasPrefix:@"diagHooks."]) continue;
        NSString *state = OMCDiagPref(key);
        [hookRows addObject:OMCDiagRow([key substringFromIndex:@"diagHooks.".length],
                                       L([state isEqualToString:@"active"] ? @"DIAG_HOOKS_OK"
                                                                           : @"DIAG_HOOKS_MISSING"))];
    }
    [sections addObject:@{@"title": L(@"DIAG_HOOKS"),
                           @"footer": L(hookRows.count ? @"DIAG_HOOKS_FOOTER_MISSING" : @"DIAG_HOOKS_OK"),
                           @"rows": hookRows}];
    return sections;
}

// _OMCDiagSummary [VERIFIED logic: counts statuses of OMCDiagChecks()]
NSDictionary *OMCDiagSummary(void) {
    NSUInteger ok = 0, warn = 0, bad = 0;
    for (NSDictionary *check in OMCDiagChecks()) {
        NSString *status = check[@"status"];
        if ([status isEqualToString:@"ok"]) ok++;
        else if ([status isEqualToString:@"warn"]) warn++;
        else if ([status isEqualToString:@"bad"]) bad++;
    }
    NSString *title = bad ? L(@"CHK_SUM_BAD") : warn ? L(@"CHK_SUM_WARN") : L(@"CHK_SUM_OK");
    NSString *subtitle = [NSString stringWithFormat:L(@"CHK_SUM_COUNTS"), (unsigned long)ok,
                                                     (unsigned long)warn, (unsigned long)bad];
    return @{@"title": title, @"subtitle": subtitle,
             @"checks": @[@(ok), @(warn), @(bad)]};
}

#pragma mark - Log writer ([GPT-F] candidate-only; see the OMCCommon.h note)

// [GPT-F] Module-local copy of the verified shared-core logger, statically
// embedded in this binary like every other OMC* helper here. The original
// Prefs binary has no such function; this exists only for the §F Settings
// diagnostics in OMCRootListController.m.
static NSDateFormatter *sPrefsLogFormatter;
static dispatch_once_t sPrefsLogFormatterOnce;
static dispatch_queue_t sPrefsLogQueue;
static dispatch_once_t sPrefsLogQueueOnce;

static BOOL OMCPrefsLogIsSpringBoard(void) {
    return [[[NSBundle mainBundle] bundleIdentifier]
        isEqualToString:@"com.apple.springboard"];
}

static BOOL OMCPrefsLogAppendLine(NSString *line) {
    FILE *f = fopen("/var/mobile/Documents/OmniCar.log", "a");
    if (f) {
        fputs(line.UTF8String, f);
        fclose(f);
    }
    return f != NULL;
}

// SpringBoard-only rotation at 2 MiB, as in the shared core.
static void OMCPrefsLogRotateIfNeeded(void) {
    NSString *path = @"/var/mobile/Documents/OmniCar.log";
    NSDictionary *attrs = [[NSFileManager defaultManager] attributesOfItemAtPath:path
                                                                           error:nil];
    if ([attrs fileSize] >= 0x200000) {
        NSString *old = [path stringByAppendingString:@".old"];
        [[NSFileManager defaultManager] removeItemAtPath:old error:nil];
        [[NSFileManager defaultManager] moveItemAtPath:path toPath:old error:nil];
    }
}

void OMCLogWrite(NSString *tag, NSString *msg) {
    NSLog(@"[OmniCar/%@] %@", tag, msg);
    dispatch_once(&sPrefsLogFormatterOnce, ^{
        sPrefsLogFormatter = [[NSDateFormatter alloc] init];
        sPrefsLogFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss.SSS";
    });
    NSString *line = [NSString stringWithFormat:@"%@ [%@:%d] %@: %@\n",
                      [sPrefsLogFormatter stringFromDate:[NSDate date]],
                      [[NSProcessInfo processInfo] processName],
                      getpid(), tag, msg];
    dispatch_once(&sPrefsLogQueueOnce, ^{
        sPrefsLogQueue = dispatch_queue_create("com.anlai.omnicar.log", NULL);
    });
    dispatch_async(sPrefsLogQueue, ^{
        if (OMCPrefsLogIsSpringBoard()) OMCPrefsLogRotateIfNeeded();
        if (OMCPrefsLogAppendLine(line)) return;
        if (OMCPrefsLogIsSpringBoard()) return; // SpringBoard gives up silently
        id center = [NSClassFromString(@"NSDistributedNotificationCenter") defaultCenter];
        [center postNotificationName:@"com.anlai.omnicar/log"
                              object:nil
                            userInfo:@{@"line": line}];
    });
}

// [W1] Synchronous variant (see the OMCCommon.h note): identical line
// format, but formatted and appended on the calling thread — no
// dispatch_async — so the line survives an abort on the next step.
void OMCLogWriteSync(NSString *tag, NSString *msg) {
    NSLog(@"[OmniCar/%@] %@", tag, msg);
    dispatch_once(&sPrefsLogFormatterOnce, ^{
        sPrefsLogFormatter = [[NSDateFormatter alloc] init];
        sPrefsLogFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss.SSS";
    });
    NSString *line = [NSString stringWithFormat:@"%@ [%@:%d] %@: %@\n",
                      [sPrefsLogFormatter stringFromDate:[NSDate date]],
                      [[NSProcessInfo processInfo] processName],
                      getpid(), tag, msg];
    if (OMCPrefsLogIsSpringBoard()) OMCPrefsLogRotateIfNeeded();
    if (OMCPrefsLogAppendLine(line)) return;
    if (OMCPrefsLogIsSpringBoard()) return; // SpringBoard gives up silently
    id center = [NSClassFromString(@"NSDistributedNotificationCenter") defaultCenter];
    [center postNotificationName:@"com.anlai.omnicar/log"
                          object:nil
                        userInfo:@{@"line": line}];
}

#pragma mark - Share report

// sub_10bf4 [VERIFIED (CLOSURE-2; census item C8; dumps
// disasm/rem2_C8_shareSection.txt + rem2_C8_caller_ShareReport.txt):
// reads the file as UTF-8, falls back to a Latin-1 decode of the raw
// data, substitutes "(empty / not found)" when the result is empty,
// and appends the "==== title (path) ====" section. Name INFERRED.]
static void OMCShareAppendLogSection(NSMutableString *report, NSString *title,
                                     NSString *path) {
    NSString *content = [NSString stringWithContentsOfFile:path
                                                  encoding:NSUTF8StringEncoding
                                                     error:nil];
    if (!content) {
        content = [[NSString alloc] initWithData:[NSData dataWithContentsOfFile:path]
                                        encoding:NSISOLatin1StringEncoding];
    }
    [report appendFormat:@"\n==== %@ (%@) ====\n%@\n", title, path,
        content.length ? content : @"(empty / not found)"];
}

// _OMCShareReport [VERIFIED call graph: builds the plain-text report from
// the summary + sections + checks, appends the raw logs and the installed
// package list, writes NSTemporaryDirectory()/OmniCar-log-<date>.txt and
// presents a UIActivityViewController anchored at the presenter]
void OMCShareReport(UIViewController *presenter) {
    NSDateFormatter *stamp = [NSDateFormatter new];
    stamp.locale = [NSLocale localeWithLocaleIdentifier:@"en_US_POSIX"];
    stamp.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSMutableString *report = [NSMutableString stringWithFormat:@"OmniCar report %@\n",
                               [stamp stringFromDate:[NSDate date]]];
    [report appendFormat:@"master switch: %@, language: %@\n",
        OMCEnabled() ? @"on" : @"off", OMCLanguage()];
    NSDictionary *summary = OMCDiagSummary();
    [report appendFormat:@"\n== %@ (%@) ==\n", summary[@"title"], summary[@"subtitle"]];
    for (NSDictionary *section in OMCDiagSections()) {
        [report appendFormat:@"\n== %@ ==\n", section[@"title"]];
        for (NSDictionary *row in section[@"rows"]) {
            [report appendFormat:@"%@: %@\n", row[@"label"], row[@"value"]];
        }
        if (section[@"footer"]) [report appendFormat:@"%@\n", section[@"footer"]];
    }
    for (NSDictionary *check in OMCDiagChecks()) {
        [report appendFormat:@"[%@] %@: %@", check[@"status"], check[@"title"], check[@"subtitle"]];
        if (check[@"fix"]) [report appendFormat:@" -> %@", check[@"fix"]];
        [report appendString:@"\n"];
    }
    // VERIFIED (CLOSURE-2): the binary appends the two log sections
    // through the sub_10bf4 helper, .old first (call sites @0x107e4 /
    // 0x10800 in _OMCShareReport) — not the inline "== … ==" variant
    // this reconstruction previously folded here.
    OMCShareAppendLogSection(report, @"OmniCar.log.old",
                             @"/var/mobile/Documents/OmniCar.log.old");
    OMCShareAppendLogSection(report, @"OmniCar.log",
                             @"/var/mobile/Documents/OmniCar.log");

    NSDateFormatter *fileStamp = [NSDateFormatter new];
    fileStamp.locale = [NSLocale localeWithLocaleIdentifier:@"en_US_POSIX"];
    fileStamp.dateFormat = @"yyyyMMdd-HHmm";
    NSString *path = [NSTemporaryDirectory() stringByAppendingPathComponent:
        [NSString stringWithFormat:@"OmniCar-log-%@.txt", [fileStamp stringFromDate:[NSDate date]]]];
    NSError *error = nil;
    if (![report writeToFile:path atomically:YES encoding:NSUTF8StringEncoding error:&error]) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"DuoCar"
                                                                       message:L(@"SEND_LOG_FAILED")
                                                                preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil]];
        [presenter presentViewController:alert animated:YES completion:nil];
        return;
    }
    UIActivityViewController *share =
        [[UIActivityViewController alloc] initWithActivityItems:@[[NSURL fileURLWithPath:path]]
                                          applicationActivities:nil];
    share.popoverPresentationController.sourceView = presenter.view;
    share.popoverPresentationController.sourceRect =
        CGRectMake(CGRectGetMidX(presenter.view.bounds), CGRectGetMidY(presenter.view.bounds), 1, 1);
    [presenter presentViewController:share animated:YES completion:nil];
}

// _OMCDiagChecks [data model + check inventory VERIFIED from the string
// table; thresholds as read from the disassembly — see Prefs_REPORT.md]
static NSDictionary *OMCCheck(NSString *cid, NSString *titleKey, NSString *subtitle,
                              NSString *status, NSString *fixKey, NSString *action) {
    NSMutableDictionary *check = [@{@"id": cid, @"title": L(titleKey),
                                    @"subtitle": subtitle ?: @"", @"status": status} mutableCopy];
    if (fixKey) check[@"fix"] = L(fixKey);
    if (action) check[@"action"] = action;
    return check;
}

NSArray *OMCDiagChecks(void) {
    NSMutableArray *checks = [NSMutableArray array];
    NSFileManager *fm = [NSFileManager defaultManager];

    // Master switch
    BOOL master = OMCEnabled();
    [checks addObject:OMCCheck(@"master", @"CHK_MASTER", L(master ? @"FEATURE_ON" : @"FEATURE_OFF"),
                               master ? @"ok" : @"bad", master ? nil : @"CHK_MASTER_FIX", nil)];

    // Package: every OmniCar<Name>.dylib + .plist pair must exist
    NSArray *modules = @[@"Core", @"AppBridge", @"SplitScreen", @"SpeedBubble", @"StartupScreen", @"CarProbe"];
    NSMutableArray *missing = [NSMutableArray array];
    NSString *libDir = OMCJBRoot(@"/Library/MobileSubstrate/DynamicLibraries");
    for (NSString *module in modules) {
        NSString *base = [libDir stringByAppendingPathComponent:[NSString stringWithFormat:@"OmniCar%@", module]];
        if (![fm fileExistsAtPath:[base stringByAppendingPathExtension:@"dylib"]] ||
            ![fm fileExistsAtPath:[base stringByAppendingPathExtension:@"plist"]]) {
            [missing addObject:module];
        }
    }
    [checks addObject:OMCCheck(@"package", @"CHK_PACKAGE",
        missing.count ? [NSString stringWithFormat:L(@"CHK_PACKAGE_BROKEN"), [missing componentsJoinedByString:@", "]]
                      // [VERIFIED: the original passes TWO varargs at
                      // 0xad24-0xad40 — the version string and the count
                      // of discovered OmniCar modules; every CHK_PACKAGE_OK
                      // string has "%@ … %lu". Passing only the version
                      // left %lu reading an uninitialised stack slot.]
                      : [NSString stringWithFormat:L(@"CHK_PACKAGE_OK"), @"1.0.3 (fbebb21)",
                                                   (unsigned long)modules.count],
        missing.count ? @"bad" : @"ok", missing.count ? @"CHK_PACKAGE_FIX" : nil, nil)];

    // Loader (substrate / ellekit / substitute present)
    BOOL loader = [fm fileExistsAtPath:@"/usr/lib/libsubstrate.dylib"] ||
                  [fm fileExistsAtPath:@"/usr/lib/libellekit.dylib"] ||
                  [fm fileExistsAtPath:@"/usr/lib/ellekit/libinjector.dylib"] ||
                  [fm fileExistsAtPath:@"/usr/lib/TweakInject.dylib"];
    [checks addObject:OMCCheck(@"loader", @"CHK_LOADER", L(loader ? @"ElleKit" : @"CHK_LOADER_NONE"),
                               loader ? @"ok" : @"bad", loader ? nil : @"CHK_LOADER_FIX", nil)];

    // Hooks loaded (diagLoaded.<module> flags written by the dylibs)
    NSMutableArray *hooksMissing = [NSMutableArray array];
    for (NSString *module in modules) {
        id flag = OMCDiagPref([@"diagLoaded." stringByAppendingString:module]);
        if (![flag boolValue]) [hooksMissing addObject:module];
    }
    [checks addObject:OMCCheck(@"hooks", @"CHK_HOOKS",
        hooksMissing.count ? [NSString stringWithFormat:L(@"CHK_HOOKS_MISSING"), [hooksMissing componentsJoinedByString:@", "]]
                           : L(@"CHK_HOOKS_OK"),
        hooksMissing.count ? @"warn" : @"ok", hooksMissing.count ? @"CHK_HOOKS_MISSING_FIX" : nil, @"respring")];

    // Car connection (diagCar published by the CarProbe/SpringBoard dylibs)
    NSDictionary *car = OMCDiagPref(@"diagCar");
    BOOL connected = [car[@"connected"] boolValue];
    NSString *carSub = connected ? L(@"CHK_CAR_CONNECTED")
                       : car ? [NSString stringWithFormat:L(@"CHK_CAR_LAST"), car[@"date"] ?: @"?"]
                             : L(@"CHK_CAR_NEVER");
    [checks addObject:OMCCheck(@"car", @"CHK_CAR", carSub, connected ? @"ok" : @"warn",
                               connected ? nil : @"CHK_CAR_NEVER_FIX", nil)];

    // Bridge apps still installed?
    NSArray *bridgeApps = OMCDiagPref(@"appBridgeApps");
    NSUInteger gone = 0;
    id workspace = [NSClassFromString(@"LSApplicationWorkspace") defaultWorkspace];
    for (NSString *bundleID in bridgeApps) {
        if (![workspace applicationIsInstalled:bundleID]) gone++;
    }
    NSString *bridgeSub = bridgeApps.count == 0 ? L(@"CHK_BRIDGE_NONE")
                        : gone ? [NSString stringWithFormat:L(@"CHK_BRIDGE_GONE"), (unsigned long)gone]
                               : [NSString stringWithFormat:L(@"CHK_BRIDGE_APPS"), (unsigned long)bridgeApps.count];
    [checks addObject:OMCCheck(@"bridge", @"CHK_BRIDGE_APPS", bridgeSub,
                               bridgeApps.count == 0 ? @"warn" : gone ? @"bad" : @"ok",
                               bridgeApps.count == 0 ? @"CHK_BRIDGE_NONE_FIX" : nil, nil)];

    // Conflicts
    NSMutableArray *activeConflicts = [NSMutableArray array];
    for (NSDictionary *tweak in OMCConflictingTweaks()) {
        if ([tweak[@"active"] boolValue]) [activeConflicts addObject:tweak[@"name"]];
    }
    [checks addObject:OMCCheck(@"conflict", @"CHK_CONFLICT",
        activeConflicts.count ? [NSString stringWithFormat:L(@"CHK_CONFLICT_ACTIVE"), [activeConflicts componentsJoinedByString:@", "]]
                              : L(@"CHK_CONFLICT_IDLE"),
        activeConflicts.count ? @"bad" : @"ok", nil, nil)];

    // Rescue pending?
    NSArray *rescue = OMCRescueFeatures();
    if (rescue.count) {
        [checks addObject:OMCCheck(@"rescue", @"RESCUE_GROUP",
            [NSString stringWithFormat:L(@"CHK_RESCUE_ON"), [rescue componentsJoinedByString:@", "]],
            @"warn", @"CHK_RESCUE_FIX", nil)];
    }

    // Battery / low power / thermal
    UIDevice *device = [UIDevice currentDevice];
    device.batteryMonitoringEnabled = YES;
    float level = device.batteryLevel;
    BOOL charging = device.batteryState == UIDeviceBatteryStateCharging ||
                    device.batteryState == UIDeviceBatteryStateFull;
    [checks addObject:OMCCheck(@"battery", @"CHK_BATTERY",
        [NSString stringWithFormat:@"%.0f%%%@", level * 100, charging ? [@" · " stringByAppendingString:L(@"CHK_BATTERY_CHARGING")] : @""],
        level >= 0 && level < 0.2 && !charging ? @"warn" : @"ok", nil, nil)];
    BOOL lowPower = [NSProcessInfo processInfo].lowPowerModeEnabled;
    [checks addObject:OMCCheck(@"lowpower", @"CHK_LOWPOWER", L(lowPower ? @"FEATURE_ON" : @"FEATURE_OFF"),
                               lowPower ? @"warn" : @"ok", lowPower ? @"CHK_LOWPOWER_FIX" : nil, nil)];
    NSProcessInfoThermalState thermal = [NSProcessInfo processInfo].thermalState;
    [checks addObject:OMCCheck(@"thermal", @"DIAG_THERMAL",
        L(thermal == NSProcessInfoThermalStateNominal ? @"DIAG_THERMAL_NOMINAL"
          : thermal == NSProcessInfoThermalStateFair ? @"DIAG_THERMAL_FAIR"
          : thermal == NSProcessInfoThermalStateSerious ? @"DIAG_THERMAL_SERIOUS" : @"DIAG_THERMAL_CRITICAL"),
        thermal >= NSProcessInfoThermalStateSerious ? @"warn" : @"ok",
        thermal >= NSProcessInfoThermalStateSerious ? @"CHK_THERMAL_FIX" : nil, nil)];

    // Storage: smallest free space ever recorded by the perf logger
    NSDictionary *perf = OMCDiagPref(@"diagPerf");
    NSNumber *freeMin = perf[@"sysFreeMinMB"] ?: perf[@"availMinMB"];
    if (freeMin) {
        double mb = [freeMin doubleValue];
        [checks addObject:OMCCheck(@"storage", @"CHK_STORAGE",
            [NSString stringWithFormat:L(@"CHK_STORAGE_FREE"), mb],
            mb < 500 ? @"bad" : mb < 1024 ? @"warn" : @"ok", mb < 1024 ? @"CHK_STORAGE_FIX" : nil, nil)];
    }

    // Last crash (diagLastCrash published by the crash guard)
    NSDictionary *crash = OMCDiagPref(@"diagLastCrash");
    if ([crash isKindOfClass:[NSDictionary class]] && crash.count) {
        // [VERIFIED: the original passes TWO varargs at 0xcbd8-0xcc04 —
        // OMCDiagDateString(crash[@"date"]) (sub_f6c0) and @""; every
        // CHK_CRASH_AT string is "%@%@". Passing only one argument left
        // the second %@ reading an uninitialised stack slot as an object
        // pointer — a crash-class format defect.]
        [checks addObject:OMCCheck(@"crash", @"CHK_CRASH",
            [NSString stringWithFormat:L(@"CHK_CRASH_AT"), OMCDiagDateString(crash[@"date"]), @""],
            @"warn", @"CHK_CRASH_FIX", nil)];
        if (crash[@"suspect"]) {
            [checks addObject:OMCCheck(@"crash.suspect", @"CHK_CRASH_SUSPECT",
                                        [crash[@"suspect"] description], @"bad", nil, nil)];
        }
    } else {
        [checks addObject:OMCCheck(@"crash", @"CHK_CRASH", L(@"CHK_CRASH_NONE"), @"ok", nil, nil)];
    }
    return checks;
}

#pragma mark - Startup Screen weather (C helpers for SSStartupView)

// _SSPeriodForDate 0x45c90 [VERIFIED ranges]
NSInteger SSPeriodForDate(NSDate *date) {
    NSDate *d = date ?: [NSDate date];
    NSInteger hour = [[NSCalendar currentCalendar] component:NSCalendarUnitHour fromDate:d];
    if (hour >= 5 && hour < 11) return 0;
    if (hour >= 11 && hour < 17) return 1;
    if (hour >= 17 && hour < 21) return 2;
    return 3;
}

static NSString *SSWeatherCachePath(void) {
    return OMCJBRoot(@"/var/mobile/Library/OmniCar/StartupScreen/weather.plist");
}

// _SSWeatherLoadCache [VERIFIED: primary jbroot path, fallback
// NSTemporaryDirectory()/OmniCarStartupWeather.plist; entries must carry a
// "date" no older than the staleness window and a "temp"]
NSDictionary *SSWeatherLoadCache(void) {
    for (NSString *path in @[SSWeatherCachePath(),
                             [NSTemporaryDirectory() stringByAppendingPathComponent:@"OmniCarStartupWeather.plist"]]) {
        NSDictionary *cache = [NSDictionary dictionaryWithContentsOfFile:path];
        NSDate *date = cache[@"date"];
        if ([date isKindOfClass:[NSDate class]] && cache[@"temp"] &&
            [date timeIntervalSinceNow] > -3600) {
            return cache;
        }
    }
    return nil;
}

// _SSWeatherSaveCache [VERIFIED: creates the directory, writes the plist,
// then normalises file attributes]
void SSWeatherSaveCache(NSDictionary *info) {
    NSString *path = SSWeatherCachePath();
    NSString *dir = [path stringByDeletingLastPathComponent];
    [[NSFileManager defaultManager] createDirectoryAtPath:dir
                              withIntermediateDirectories:YES attributes:nil error:nil];
    NSError *error = nil;
    [info writeToURL:[NSURL fileURLWithPath:path] error:&error];
    [[NSFileManager defaultManager] setAttributes:@{NSFilePosixPermissions: @0644}
                                     ofItemAtPath:path error:nil];
}

// _SSWeatherParse [VERIFIED key mapping: Open-Meteo JSON ->
// {temp, code, isDay, high, low, rain, date}]
NSDictionary *SSWeatherParse(NSData *data) {
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    NSDictionary *current = json[@"current"];
    NSDictionary *daily = json[@"daily"];
    if (![current isKindOfClass:[NSDictionary class]]) return nil;
    NSMutableDictionary *out = [NSMutableDictionary dictionary];
    if (current[@"temperature_2m"]) out[@"temp"] = current[@"temperature_2m"];
    if (current[@"weather_code"]) out[@"code"] = current[@"weather_code"];
    if (current[@"is_day"]) out[@"isDay"] = current[@"is_day"];
    NSArray *highs = daily[@"temperature_2m_max"];
    NSArray *lows = daily[@"temperature_2m_min"];
    NSArray *rain = daily[@"precipitation_probability_max"];
    if ([highs isKindOfClass:[NSArray class]] && highs.count) out[@"high"] = highs.firstObject;
    if ([lows isKindOfClass:[NSArray class]] && lows.count) out[@"low"] = lows.firstObject;
    if ([rain isKindOfClass:[NSArray class]] && rain.count) out[@"rain"] = rain.firstObject;
    out[@"date"] = [NSDate date];
    return out;
}

// _SSApplySampleData [VERIFIED call graph: fills an SSStartupView with
// sample weather/event/battery state for the settings preview, but only
// where the view does not already carry real data — batteryPercent is an
// NSInteger whose negative value means "unset" (setter called with 82)]
// sub_50180: builds the sample HUD checklist (NSArray of
// @{@"ok": NSNumber, @"text": NSString} dictionaries — the element shape
// consumed by -[SSStartupView ss_buildHud]) from the car name. Defined
// in SSStartupView.m (closure pass). TWO call sites, not one:
// _SSApplySampleData (binary 0x54610) and -[SSStartupView ss_buildHud]
// itself (binary 0x4fcdc — fallback when self.hud is empty).
extern NSArray *SSSampleHudItems(NSString *carName);

@interface SSStartupView (OMCSampleData)
@property (nonatomic, strong) NSDictionary *weather;
@property (nonatomic, strong) NSDictionary *nextEvent;
@property (nonatomic) NSInteger batteryPercent;
@property (nonatomic, copy) NSArray *hud;
@end

// [W1] Class-name helper for the SSApplySampleData bracket logs.
static NSString *OMCW1ClassName(id v) {
    return v ? NSStringFromClass([v class]) : @"(nil)";
}

void SSApplySampleData(SSStartupView *view) {
    // [W1] Bracket (W1 plan, SSApplySampleData point): synchronous logs.
    OMCLogWriteSync(@"Prefs", [NSString stringWithFormat:
        @"[W1] SSApplySampleData enter weatherClass=%@ hudClass=%@ nextEventClass=%@",
        OMCW1ClassName(view.weather), OMCW1ClassName(view.hud),
        OMCW1ClassName(view.nextEvent)]);
    // Field order restored to the original (W1 audit row 11): hud FIRST
    // (0x545e4-0x54628), then nextEvent (0x54640-0x546e0), then
    // battery<0->82 (0x54700-0x54710), weather LAST (0x54718-0x547fc).
    // Binary (0x545e4-0x54628): hud is an NSArray (SSStartupView ivar
    // _hud, T@"NSArray",C,N,V_hud), filled only when nil, with
    // SSSampleHudItems(view.carName) via setHud:. A's earlier
    // "view.hud = YES" (BOOL) was a misreading — see PrefsB_REPORT note.
    if (!view.hud) view.hud = SSSampleHudItems(view.carName);
    if (!view.nextEvent) {
        view.nextEvent = @{@"title": OMCTr(@"Họp nhóm", @"Team meeting"),
                           @"date": [NSDate dateWithTimeIntervalSinceNow:3600]};
    }
    if (view.batteryPercent < 0) view.batteryPercent = 82;
    if (!view.weather) {
        view.weather = @{@"temp": @27, @"code": @0, @"isDay": @1,
                         @"high": @31, @"low": @24, @"rain": @10, @"date": [NSDate date]};
    }
    // [W1] Bracket exit.
    OMCLogWriteSync(@"Prefs", [NSString stringWithFormat:
        @"[W1] SSApplySampleData exit weatherClass=%@ hudClass=%@ nextEventClass=%@",
        OMCW1ClassName(view.weather), OMCW1ClassName(view.hud),
        OMCW1ClassName(view.nextEvent)]);
}
