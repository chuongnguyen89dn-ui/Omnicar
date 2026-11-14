// OMCStartupScreenController.m — reconstructed from OmniCarPrefs (OmniCar 1.0.3)
// by static analysis (capstone disassembly of the arm64 slice; see
// PrefsB_REPORT.md for the per-method evidence/status table).
//
// Preference domain: "com.anlai.omnicar". This TU's write helper posts the
// change via CFNotificationCenterGetDarwinNotifyCenter +
// CFNotificationCenterPostNotification("com.anlai.omnicar/prefschanged",
// deliverImmediately = TRUE).
//
// Data directory (realpath-resolved, i.e. rootless symlink aware):
//   /var/mobile/Library/OmniCar/StartupScreen/{Videos,Sounds,Logo}
//   Videos/.frames/<videofile>/{00000.jpg, 00001.jpg, ..., info.plist}
//   info.plist = {version: 2, count: <frames>, fps: 24}

#import "OMCStartupScreenController.h"
#import "OMCCommon.h"
#import "SSStartupView.h"
#import <Preferences/PSSpecifier.h> // [integration phase 1; backported to src in phase 3] declares PSSpecifier used in this file
#import "OMCSSStyleTileCell.h"
#import <UniformTypeIdentifiers/UniformTypeIdentifiers.h>
#import <AVKit/AVKit.h>
#import <ImageIO/ImageIO.h>
#import <CoreImage/CoreImage.h>

static NSString * const kSSDomain = @"com.anlai.omnicar";
static NSString * const kSSDir = @"/var/mobile/Library/OmniCar/StartupScreen";

// ---- TU-local static helpers ------------------------------------------------
static NSString *SSStringPref(NSString *key) {           // sub_3d124
    id v = CFBridgingRelease(CFPreferencesCopyAppValue((__bridge CFStringRef)key,
                                                       (__bridge CFStringRef)kSSDomain));
    return [v isKindOfClass:[NSString class]] ? v : nil;
}
static void SSWritePref(NSString *key, id value) {       // sub_3f7c4
    CFPreferencesSetAppValue((__bridge CFStringRef)key, (__bridge CFPropertyListRef)value,
                             (__bridge CFStringRef)kSSDomain);
    CFPreferencesAppSynchronize((__bridge CFStringRef)kSSDomain);
    CFNotificationCenterPostNotification(CFNotificationCenterGetDarwinNotifyCenter(),
        CFSTR("com.anlai.omnicar/prefschanged"), NULL, NULL, TRUE);
}
static id SSRawPref(NSString *key) {
    return CFBridgingRelease(CFPreferencesCopyAppValue((__bridge CFStringRef)key,
                                                       (__bridge CFStringRef)kSSDomain));
}
// realpath() an absolute path; nil when it does not resolve.
static NSString *SSReal(NSString *path) {
    char buf[4096];
    if (!realpath(path.fileSystemRepresentation, buf)) return nil;
    return [NSString stringWithUTF8String:buf];
}
// Car name harvested from the diagnostics pref "diagCar": first non-empty
// string value (two dict levels deep) that is not "nil"/"(null)".
static NSString *SSDiagCarName(void) {                   // sub_3dd30
    id diag = SSRawPref(@"diagCar");
    if (![diag isKindOfClass:[NSDictionary class]]) return nil;
    for (id sub in [(NSDictionary *)diag allValues]) {
        if (![sub isKindOfClass:[NSDictionary class]]) continue;
        for (id v in [(NSDictionary *)sub allValues])
            if ([v isKindOfClass:[NSString class]] && [(NSString *)v length] > 0 &&
                ![v isEqualToString:@"nil"] && ![v isEqualToString:@"(null)"])
                return v;
    }
    return nil;
}
// ---- [W1] diagnostic instrumentation (W1 startup-ejection audit;
// candidate-only, NOT a restored behaviour) ---------------------------
// All [W1] lines go through OMCLogWriteSync (OMCCommon) so each line is
// appended on the calling thread and survives an abort on the next step.
static NSString *OMCW1ClassName(id v) {
    return v ? NSStringFromClass([v class]) : @"(nil)";
}
// [W1] YES until the first -viewDidAppear of this controller finishes:
// bounds the decorateCell logs to the first pass, per the W1 plan.
static BOOL sW1DecorateFirstPass = YES;
static NSUncaughtExceptionHandler *sW1PreviousHandler = NULL;
static BOOL sW1HandlerInstalled = NO;
static void OMCW1UncaughtExceptionHandler(NSException *exception) {
    // Synchronous log of name + reason + stack symbols, then PROPAGATE:
    // chain to the previous handler when there was one, otherwise
    // re-raise. This handler never returns normally on the no-previous
    // path and never swallows the exception.
    OMCLogWriteSync(@"Prefs", [NSString stringWithFormat:
        @"[W1] uncaught exception name=%@ reason=%@ stack=%@",
        exception.name, exception.reason,
        [exception.callStackSymbols componentsJoinedByString:@" | "]]);
    if (sW1PreviousHandler) {
        sW1PreviousHandler(exception);
    } else {
        [exception raise];
    }
}
static void OMCW1InstallExceptionHandler(void) {
    if (sW1HandlerInstalled) return;
    sW1HandlerInstalled = YES;
    sW1PreviousHandler = NSGetUncaughtExceptionHandler();
    NSSetUncaughtExceptionHandler(&OMCW1UncaughtExceptionHandler);
}

// Localization key for a style index (clamped: out-of-range -> 0).
NSString *SSStyleNameKey(NSInteger style) {       // sub_3c7f0 — shared symbol:
                                                  // also called from OMCSSStyleTileCell
    static NSArray *keys;   // constant array in the binary
    keys = @[@"STARTUPSCREEN_STYLE_VIDEO", @"STARTUPSCREEN_STYLE_LOGO",
             @"STARTUPSCREEN_STYLE_GREETING", @"STARTUPSCREEN_STYLE_WEATHER",
             @"STARTUPSCREEN_STYLE_ENGINE", @"STARTUPSCREEN_STYLE_WELCOME",
             @"STARTUPSCREEN_STYLE_PARTICLES", @"STARTUPSCREEN_STYLE_HUD",
             @"STARTUPSCREEN_STYLE_BRIEFING", @"STARTUPSCREEN_STYLE_LIQUID",
             @"STARTUPSCREEN_STYLE_RANDOM"];
    if (style < 0 || style >= (NSInteger)keys.count) style = 0;
    return keys[style];
}
// Upcoming-occasion scan (sub_3d47c): from today (noon, GMT+7) forward up
// to 400 days. Codes: 1 = Tet window (lunar 1/1-1/3), 2 = user birthday,
// 3 = Christmas (Dec 24/25), 4 = Mid-Autumn (lunar 8/15, non-leap month),
// 5 = Jan 1. Falls back to 1.
static NSInteger SSUpcomingOccasion(NSString *birthday) {  // sub_3d47c
    NSCalendar *greg = [NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian];
    NSCalendar *chin = [NSCalendar calendarWithIdentifier:NSCalendarIdentifierChinese];
    NSTimeZone *tz = [NSTimeZone timeZoneForSecondsFromGMT:25200];
    greg.timeZone = tz;
    chin.timeZone = tz;
    NSDate *day = [greg dateBySettingHour:12 minute:0 second:0
                                   ofDate:[NSDate date] options:0];
    if (!day) day = [NSDate date];
    NSString *bday = (birthday.length == 5) ? birthday : nil;
    for (NSInteger i = 0; i < 400; i++) {
        NSDateComponents *gc = [greg components:NSCalendarUnitMonth | NSCalendarUnitDay
                                       fromDate:day];
        NSDateComponents *cc = [chin components:NSCalendarUnitMonth | NSCalendarUnitDay
                                       fromDate:day];
        if (!cc.isLeapMonth && cc.month == 1 && cc.day < 4) return 1;
        if (bday && [[NSString stringWithFormat:@"%02ld-%02ld",
                        (long)gc.month, (long)gc.day] isEqualToString:bday])
            return 2;
        if (gc.month == 1 && gc.day == 1) return 5;
        if (gc.month == 12 && (gc.day == 24 || gc.day == 25)) return 3;
        if (!cc.isLeapMonth && cc.month == 8 && cc.day == 15) return 4;
        day = [greg dateByAddingUnit:NSCalendarUnitDay value:1 toDate:day options:0];
        if (!day) break;
    }
    return 1;
}
// Shared POSIX-locale date formatter factory (sub_406e0).
static NSDateFormatter *SSFormatter(NSString *format) {
    NSDateFormatter *f = [NSDateFormatter new];
    f.locale = [NSLocale localeWithLocaleIdentifier:@"en_US_POSIX"];
    f.calendar = [NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian];
    f.timeZone = [NSTimeZone localTimeZone];
    f.dateFormat = format;
    return f;
}
// Parse an "MM-dd" birthday string into a date in year 2000 (sub_40574).
static NSDate *SSBirthdayDate(NSString *mmdd) {
    if (![mmdd isKindOfClass:[NSString class]] || mmdd.length != 5) return nil;
    return [SSFormatter(@"yyyy-MM-dd") dateFromString:
            [@"2000-" stringByAppendingString:mmdd]];
}

@implementation OMCStartupScreenController

// [W1] Install the uncaught-exception handler as early as this TU can:
// the report specifies -viewDidLoad (before super), or +load of this TU
// if earlier is needed — +load is used, and -viewDidLoad re-calls the
// (idempotent) installer before [super viewDidLoad] as the report's
// named point.
+ (void)load {
    OMCW1InstallExceptionHandler();
}

// ------------------------------------------------------------- pref reads
- (NSInteger)currentStyle {
    id v = SSRawPref(@"startupScreenStyle");
    NSInteger s = v ? [v integerValue] : 0;
    return (NSUInteger)s < 11 ? s : 0;
}

- (NSString *)currentSound {
    NSString *name = SSStringPref(@"startupScreenSoundFile");
    if (name.length == 0) return nil;
    NSString *dir = SSReal([kSSDir stringByAppendingPathComponent:@"Sounds"]);
    if (!dir) return nil;
    NSString *path = [dir stringByAppendingPathComponent:name];
    // [W1 fix] Original returns the BARE file name when the file
    // exists (csel x19 at 0x3d0c0, currentSound 0x3cff4-0x3d120);
    // ours returned the full path and compensated with
    // lastPathComponent at the specifiers call site.
    return [[NSFileManager defaultManager] fileExistsAtPath:path] ? name : nil;
}

- (NSArray *)randomSet {
    // [W1 fix] Element range test is UNSIGNED in the original
    // (cmp #9 + b.hi at 0x3d27c-0x3d280): negative values are rejected
    // too. Ours previously used a signed <= 9 and admitted negatives.
    NSMutableArray *out = [NSMutableArray array];
    id v = SSRawPref(@"startupScreenRandomSet");
    if ([v isKindOfClass:[NSArray class]])
        for (id e in (NSArray *)v)
            if ([e isKindOfClass:[NSNumber class]] &&
                (NSUInteger)[e integerValue] <= 9 &&
                ![out containsObject:@([e integerValue])])
                [out addObject:@([e integerValue])];
    if (out.count == 0)
        for (NSInteger i = 0; i < 10; i++) [out addObject:@(i)];
    return out;
}

- (NSString *)occasionPreviewTitle {
    NSInteger code = SSUpcomingOccasion(SSStringPref(@"startupScreenBirthday"));
    NSString *key = @"STARTUPSCREEN_OCC_TET";
    if (code >= 2 && code <= 5)
        key = @[@"STARTUPSCREEN_OCC_BIRTHDAY", @"STARTUPSCREEN_OCC_XMAS",
                @"STARTUPSCREEN_OCC_MIDAUTUMN", @"STARTUPSCREEN_OCC_NEWYEAR"][code - 2];
    return [NSString stringWithFormat:L(@"STARTUPSCREEN_OCCASION_PREVIEW"), L(key)];
}

- (NSString *)nameFooterForStyle:(NSInteger)style {
    if (style == 3) {
        NSDictionary *cache = SSWeatherLoadCache();
        id date = cache[@"date"];
        NSString *head = L(@"STARTUPSCREEN_WEATHER_NONE");
        if ([date isKindOfClass:[NSDate class]])
            head = [NSString stringWithFormat:L(@"STARTUPSCREEN_WEATHER_LAST"),
                    [NSDateFormatter localizedStringFromDate:date
                                                   dateStyle:NSDateFormatterShortStyle
                                                   timeStyle:NSDateFormatterShortStyle]];
        return [NSString stringWithFormat:@"%@\n%@", head,
                L(@"STARTUPSCREEN_WEATHER_FOOTER")];
    }
    if (style == 6) return L(@"STARTUPSCREEN_PARTICLES_FOOTER");
    if (style == 8) return L(@"STARTUPSCREEN_BRIEFING_FOOTER");
    return L(@"STARTUPSCREEN_GREETING_FOOTER");
}

// -------------------------------------------------------------- specifiers
- (NSArray *)specifiers {
    if (!_specifiers) {
        // [W1] Bracket enter + background dump (W1 plan: logged ONCE at
        // the head of -specifiers): the current startup style, then for
        // EACH pref key read on page entry its runtime class, plus its
        // value only for NSString/NSNumber values.
        OMCLogWriteSync(@"Prefs", [NSString stringWithFormat:
            @"[W1] OMCStartupScreenController specifiers enter currentStyle=%ld",
            (long)[self currentStyle]]);
        for (NSString *w1Key in @[@"startupScreenStyle",
                                  @"startupScreenVideoName",
                                  @"startupScreenSoundFile",
                                  @"startupScreenRandomSet",
                                  @"startupScreenBirthday",
                                  @"startupScreenDuration",
                                  @"startupScreenTempo",
                                  @"startupScreenLogoEffect",
                                  @"startupScreenScaleMode",
                                  @"startupScreenGreetingName",
                                  @"startupScreenCarName"]) {
            id w1Value = SSRawPref(w1Key);
            NSString *w1Shown = ([w1Value isKindOfClass:[NSString class]] ||
                                 [w1Value isKindOfClass:[NSNumber class]])
                                ? [w1Value description]
                                : @"(value not logged: not NSString/NSNumber)";
            OMCLogWriteSync(@"Prefs", [NSString stringWithFormat:
                @"[W1] pref key=%@ class=%@ value=%@",
                w1Key, OMCW1ClassName(w1Value), w1Shown]);
        }
        NSMutableArray *specs = [[super specifiers] mutableCopy];
        // [W1] Bracket: after super.
        OMCLogWriteSync(@"Prefs", [NSString stringWithFormat:
            @"[W1] OMCStartupScreenController specifiers after super count=%lu",
            (unsigned long)specs.count]);
        NSInteger style = [self currentStyle];
        for (PSSpecifier *sp in [specs copy]) {
            id styles = [sp propertyForKey:@"ssStyles"];
            if ([styles isKindOfClass:[NSArray class]] &&
                ![styles containsObject:@(style)]) {
                [specs removeObject:sp];
                continue;
            }
            NSString *placeholder = [sp propertyForKey:@"placeholder"];
            if (placeholder)
                [sp setProperty:L(placeholder) forKey:@"placeholder"];
            NSString *ident = sp.identifier;
            if ([ident isEqualToString:@"soundGroup"]) {
                NSString *sound = [self currentSound];
                NSString *current = sound
                    ? [NSString stringWithFormat:L(@"STARTUPSCREEN_SOUND_CURRENT"),
                       sound]
                    : L(@"STARTUPSCREEN_SOUND_NONE");
                [sp setProperty:[NSString stringWithFormat:@"%@\n%@\n%@: %@",
                        L(@"STARTUPSCREEN_STARTUP_SOUND_FOOTER"),
                        L(@"STARTUPSCREEN_VOLUME_GROUP"),
                        L(@"STARTUPSCREEN_VOLUME_FOOTER"), current]
                         forKey:@"footerText"];
            } else if ([ident isEqualToString:@"nameGroup"]) {
                sp.name = L(SSStyleNameKey(style));
                [sp setProperty:[self nameFooterForStyle:style] forKey:@"footerText"];
            } else if ([ident isEqualToString:@"carGroup"] ||
                       [ident isEqualToString:@"tempoGroup"]) {
                sp.name = L(SSStyleNameKey(style));
            } else if ([ident isEqualToString:@"occasionPreview"]) {
                sp.name = [self occasionPreviewTitle];
            }
            // [W1 fix] Original compares the specifier IDENTIFIER to
            // @"carName" and writes the @"placeholder" property
            // (0x3dc3c-0x3dc78). Ours compared property @"key" (never
            // true: the plist key is startupScreenCarName) and wrote
            // @"footerText".
            if ([sp.identifier isEqualToString:@"carName"])
                [sp setProperty:SSDiagCarName() ?: @"DuoCar" forKey:@"placeholder"];
        }
        // [W1] Bracket: after the ssStyles filter loop (remaining count).
        OMCLogWriteSync(@"Prefs", [NSString stringWithFormat:
            @"[W1] OMCStartupScreenController specifiers after filter count=%lu",
            (unsigned long)specs.count]);
        _specifiers = specs;
        [self refreshVideoList];
        // [W1] Bracket exit.
        OMCLogWriteSync(@"Prefs", [NSString stringWithFormat:
            @"[W1] OMCStartupScreenController specifiers exit count=%lu",
            (unsigned long)_specifiers.count]);
    }
    return _specifiers;
}

// For preview-affecting keys the plist write path is repeated explicitly so
// the value lands in the app domain immediately, then the preview refreshes.
- (void)setPreferenceValue:(id)value specifier:(PSSpecifier *)specifier {
    [super setPreferenceValue:value specifier:specifier];
    NSString *key = [specifier propertyForKey:@"key"];
    if (key && [@[@"startupScreenGreetingName", @"startupScreenCarName",
                  @"startupScreenTempo", @"startupScreenLogoEffect",
                  @"startupScreenVideoName", @"startupScreenScaleMode"]
                   containsObject:key]) {
        CFPreferencesSetAppValue((__bridge CFStringRef)key,
                                 (__bridge CFPropertyListRef)value,
                                 (__bridge CFStringRef)kSSDomain);
        CFPreferencesAppSynchronize((__bridge CFStringRef)kSSDomain);
        [self updatePreview];
    }
}

- (UITableViewCell *)tableView:(UITableView *)table
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = nil;
    @try {
        cell = [super tableView:table cellForRowAtIndexPath:indexPath];
        [self decorateCell:cell];
    } @catch (NSException *exception) {
        // [W1] Log-then-rethrow, exactly the GPT-F pattern in
        // OMCRootListController.m (synchronous [W1] variant): log
        // section/row + specifier identifier + exception
        // name/reason/callStackSymbols, then @throw; — the exception
        // is NEVER swallowed or continued past.
        NSString *specifierID = nil;
        @try {
            PSSpecifier *spec = [self specifierAtIndexPath:indexPath];
            specifierID = [spec identifier] ?: [spec propertyForKey:@"plist"];
        } @catch (NSException *lookupException) {
            (void)lookupException;
            specifierID = nil;
        }
        OMCLogWriteSync(@"Prefs", [NSString stringWithFormat:
            @"[W1] cellForRow exception: controller=%@ section=%ld row=%ld specifier=%@ name=%@ reason=%@ stack=%@",
            NSStringFromClass([self class]), (long)indexPath.section,
            (long)indexPath.row, specifierID, exception.name, exception.reason,
            [exception.callStackSymbols componentsJoinedByString:@" | "]]);
        @throw;
    }
    return cell;
}

// Cell decoration driven by specifier properties:
//  - identifier "birthday": attach the date-picker accessory (selection off)
//  - property "ssRandomStyle" (NSNumber): checkmark accessory reflecting
//    membership in randomSet, label/tint colors follow the check state
//  - identifier "occasionPreview": the cell label shows the specifier name
- (void)decorateCell:(UITableViewCell *)cell {
    PSSpecifier *sp = nil;
    if ([cell isKindOfClass:[PSTableCell class]]) sp = [(PSTableCell *)cell specifier];
    NSString *ident = sp.identifier;
    // [W1] First pass only: identifier + class of the ssRandomStyle
    // property for each cell.
    if (sW1DecorateFirstPass) {
        OMCLogWriteSync(@"Prefs", [NSString stringWithFormat:
            @"[W1] decorateCell identifier=%@ ssRandomStyleClass=%@",
            ident, OMCW1ClassName([sp propertyForKey:@"ssRandomStyle"])]);
    }
    if ([ident isEqualToString:@"birthday"]) {
        UIView *acc = [self birthdayAccessory];
        if (cell.accessoryView != acc) cell.accessoryView = acc;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return;
    }
    id rs = [sp propertyForKey:@"ssRandomStyle"];
    if ([rs isKindOfClass:[NSNumber class]]) {
        BOOL in = [[self randomSet] containsObject:@([rs integerValue])];
        cell.accessoryType = in ? UITableViewCellAccessoryCheckmark
                                : UITableViewCellAccessoryNone;
        UIColor *tint = in ? [UIColor labelColor] : [UIColor secondaryLabelColor];
        cell.tintColor = tint;
        cell.textLabel.textColor = tint;
        return;
    }
    if ([ident isEqualToString:@"occasionPreview"])
        cell.textLabel.text = sp.name;
}

- (void)redecorateVisibleCells {
    for (UITableViewCell *cell in self.table.visibleCells)
        [self decorateCell:cell];
}

// ------------------------------------------------------------------- views
- (void)viewDidLoad {
    // [W1] Report's named install point: the uncaught-exception handler
    // is installed BEFORE [super viewDidLoad] (idempotent; +load of
    // this TU already installed it even earlier).
    OMCW1InstallExceptionHandler();
    // [W1] Bracket enter.
    OMCLogWriteSync(@"Prefs", @"[W1] OMCStartupScreenController viewDidLoad enter");
    [super viewDidLoad];
    // [W1 fix] Header frame restored to the original 320x280
    // (W1 audit row 6: d8=320.0 at 0x3e6f4, 280.0 const 0x65e90);
    // ours had the two dimensions flipped (280x320).
    UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 280)];
    self.previewHeader = header;
    UIView *shadow = [UIView new];
    shadow.layer.shadowColor = [UIColor blackColor].CGColor;
    shadow.layer.shadowOpacity = 0.22f;
    shadow.layer.shadowRadius = 12;
    shadow.layer.shadowOffset = CGSizeMake(0, 6);
    self.previewShadow = shadow;
    [header addSubview:shadow];
    // [W1 fix] Preview width restored to the original 320 (W1 audit
    // row 6); ours had 280.
    SSStartupView *preview = [[SSStartupView alloc] initWithFrame:CGRectMake(0, 0, 320, 120)];
    preview.layer.cornerRadius = 20;
    preview.layer.cornerCurve = kCACornerCurveContinuous;
    preview.layer.borderWidth = 0.5;
    preview.layer.borderColor = [UIColor colorWithWhite:1 alpha:0.22].CGColor;
    preview.autoresizingMask = UIViewAutoresizingFlexibleWidth |
                               UIViewAutoresizingFlexibleBottomMargin;
    [preview addGestureRecognizer:[[UITapGestureRecognizer alloc]
        initWithTarget:preview action:@selector(playIntro)]];
    self.preview = preview;
    [shadow addSubview:preview];
    UILabel *title = [UILabel new];
    title.font = [UIFont systemFontOfSize:14 weight:UIFontWeightMedium];
    title.textColor = [UIColor secondaryLabelColor];
    self.galleryTitle = title;
    [header addSubview:title];
    UILabel *hint = [UILabel new];
    hint.font = [UIFont systemFontOfSize:12];
    hint.textColor = [UIColor tertiaryLabelColor];
    hint.textAlignment = NSTextAlignmentCenter;
    hint.adjustsFontSizeToFitWidth = YES;
    hint.minimumScaleFactor = 0.8;   // (constant read as 0x65e70 region; INFERRED)
    self.galleryHint = hint;
    [header addSubview:hint];
    UICollectionViewFlowLayout *flow = [UICollectionViewFlowLayout new];
    flow.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    // [W1 fix] itemSize restored to the original 78x108; ours had it
    // flipped (110x78).
    flow.itemSize = CGSizeMake(78, 108);
    flow.minimumLineSpacing = 4;
    flow.minimumInteritemSpacing = 0;
    flow.sectionInset = UIEdgeInsetsMake(0, 14, 0, 14);
    UICollectionView *gallery = [[UICollectionView alloc]
        initWithFrame:CGRectZero collectionViewLayout:flow];
    gallery.backgroundColor = [UIColor clearColor];
    gallery.showsHorizontalScrollIndicator = NO;
    gallery.alwaysBounceHorizontal = YES;
    gallery.clipsToBounds = NO;
    gallery.dataSource = self;
    gallery.delegate = self;
    [gallery registerClass:[OMCSSStyleTileCell class]
        forCellWithReuseIdentifier:@"tile"];
    self.gallery = gallery;
    [header addSubview:gallery];
    // [W1] Bracket exit.
    OMCLogWriteSync(@"Prefs", @"[W1] OMCStartupScreenController viewDidLoad exit");
}

- (void)viewWillAppear:(BOOL)animated {
    // [W1] Bracket enter.
    OMCLogWriteSync(@"Prefs", @"[W1] OMCStartupScreenController viewWillAppear enter");
    [super viewWillAppear:animated];
    self.galleryTitle.text = L(@"STARTUPSCREEN_STYLE_GROUP");
    self.galleryHint.text = L(@"STARTUPSCREEN_REPLAY_HINT");
    [self.gallery reloadData];
    [self updatePreview];
    // [W1] Bracket exit.
    OMCLogWriteSync(@"Prefs", @"[W1] OMCStartupScreenController viewWillAppear exit");
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.soundPlayer stop];
    self.soundPlayer = nil;
}

- (void)viewDidLayoutSubviews {
    // [W1] Bracket ONLY on the first call (static flag, per W1 plan).
    static BOOL sW1LayoutLogged = NO;
    BOOL w1LogLayout = !sW1LayoutLogged;
    if (w1LogLayout) {
        sW1LayoutLogged = YES;
        OMCLogWriteSync(@"Prefs", @"[W1] OMCStartupScreenController viewDidLayoutSubviews enter (first)");
    }
    [super viewDidLayoutSubviews];
    CGFloat W = self.table.bounds.size.width;
    if (W <= 0 || fabs(W - self.previewWidth) < 0.5) {
        // [W1] Bracket exit (first call, early-return path).
        if (w1LogLayout)
            OMCLogWriteSync(@"Prefs", @"[W1] OMCStartupScreenController viewDidLayoutSubviews exit (first, early return)");
        return;
    }
    self.previewWidth = W;
    CGFloat contentW = MIN(W - 32, 560);
    CGFloat previewH = round(contentW * 0.375);
    CGFloat x = round((W - contentW) / 2);
    self.previewShadow.frame = CGRectMake(x, 18, contentW, previewH);
    self.preview.frame = self.previewShadow.bounds;
    self.previewShadow.layer.shadowPath =
        [UIBezierPath bezierPathWithRoundedRect:self.previewShadow.bounds
                                   cornerRadius:20].CGPath;
    CGFloat y = CGRectGetMaxY(self.previewShadow.frame) + 20;
    CGFloat titleW = floor(contentW * 0.5);
    self.galleryTitle.frame = CGRectMake(x, y, titleW, 18);
    self.galleryHint.frame = CGRectMake(x + titleW, y, contentW - titleW, 18);
    y += 20 + 18;
    self.gallery.frame = CGRectMake(0, y, W, 110);
    self.previewHeader.frame = CGRectMake(0, 0, W, CGRectGetMaxY(self.gallery.frame) + 2);
    self.table.tableHeaderView = self.previewHeader;
    [self scrollGalleryToStyle:[self currentStyle] animated:NO];
    // [W1] Bracket exit (first call only).
    if (w1LogLayout)
        OMCLogWriteSync(@"Prefs", @"[W1] OMCStartupScreenController viewDidLayoutSubviews exit (first)");
}

- (void)scrollGalleryToStyle:(NSInteger)style animated:(BOOL)animated {
    if (self.gallery.bounds.size.width <= 0) return;
    [self.gallery layoutIfNeeded];
    [self.gallery scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:style inSection:0]
                         atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally
                                 animated:animated];
}

- (BOOL)pageIsDark {
    return self.traitCollection.userInterfaceStyle == UIUserInterfaceStyleDark;
}

// ----------------------------------------------------------------- gallery
- (NSInteger)collectionView:(UICollectionView *)cv
     numberOfItemsInSection:(NSInteger)section {
    return 11;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)cv
                  cellForItemAtIndexPath:(NSIndexPath *)ip {
    OMCSSStyleTileCell *cell = [cv dequeueReusableCellWithReuseIdentifier:@"tile"
                                                             forIndexPath:ip];
    [cell showStyle:ip.item chosen:ip.item == [self currentStyle] dark:[self pageIsDark]];
    return cell;
}

- (void)collectionView:(UICollectionView *)cv
    didSelectItemAtIndexPath:(NSIndexPath *)ip {
    NSInteger style = ip.item;
    if (style == [self currentStyle]) { [self updatePreview]; return; }
    SSWritePref(@"startupScreenStyle", @(style));
    [[[UISelectionFeedbackGenerator alloc] init] selectionChanged];
    BOOL dark = [self pageIsDark];
    [UIView animateWithDuration:0.35 delay:0 usingSpringWithDamping:0.86
          initialSpringVelocity:0 options:2 animations:^{
        for (NSIndexPath *vip in cv.indexPathsForVisibleItems) {
            OMCSSStyleTileCell *c = (OMCSSStyleTileCell *)[cv cellForItemAtIndexPath:vip];
            if ([c isKindOfClass:[OMCSSStyleTileCell class]])
                [c setChosen:vip.item == style dark:dark];
        }
    } completion:nil];
    [self scrollGalleryToStyle:style animated:YES];
    _specifiers = nil;
    [self reloadSpecifiers];
    [self updatePreview];
}

// ------------------------------------------------------------ random style
- (void)toggleRandomStyle:(PSSpecifier *)specifier {
    id v = [specifier propertyForKey:@"ssRandomStyle"];
    if (![v isKindOfClass:[NSNumber class]]) return;
    NSNumber *style = @([v integerValue]);
    NSMutableArray *set = [[self randomSet] mutableCopy];
    if ([set containsObject:style]) {
        if (set.count <= 1) {
            [self showMessage:L(@"STARTUPSCREEN_RANDOM_KEEP_ONE")];
            return;
        }
        [set removeObject:style];
    } else {
        [set addObject:style];
    }
    [set sortUsingSelector:@selector(compare:)];
    SSWritePref(@"startupScreenRandomSet", set);
    [[[UISelectionFeedbackGenerator alloc] init] selectionChanged];
    [self redecorateVisibleCells];
}

- (NSInteger)randomPreviewStyle {
    NSMutableArray *set = [[self randomSet] mutableCopy];
    if (![self selectedVideo]) [set removeObject:@0];
    if (set.count == 0) return 2;
    return [set[arc4random_uniform((uint32_t)set.count)] integerValue];
}

// ---------------------------------------------------------------- preview
- (void)updatePreview {
    // [W1] Bracket enter (style in).
    OMCLogWriteSync(@"Prefs", [NSString stringWithFormat:
        @"[W1] updatePreview enter currentStyle=%ld", (long)[self currentStyle]]);
    [self showPreviewStyle:[self currentStyle] occasion:0];
    // [W1] Bracket exit.
    OMCLogWriteSync(@"Prefs", @"[W1] updatePreview exit");
}

- (void)showPreviewStyle:(NSInteger)style occasion:(NSInteger)occasion {
    // [W1] Bracket enter: style in + occasion.
    OMCLogWriteSync(@"Prefs", [NSString stringWithFormat:
        @"[W1] showPreviewStyle enter styleIn=%ld occasion=%ld",
        (long)style, (long)occasion]);
    SSStartupView *p = self.preview;
    if (!p) {
        // [W1] Bracket exit (no preview view).
        OMCLogWriteSync(@"Prefs", @"[W1] showPreviewStyle exit (no preview)");
        return;
    }
    if (style == 10) style = [self randomPreviewStyle];
    // [W1] Style after random-resolve + occasion.
    OMCLogWriteSync(@"Prefs", [NSString stringWithFormat:
        @"[W1] showPreviewStyle after random-resolve style=%ld occasion=%ld",
        (long)style, (long)occasion]);
    p.image = nil;
    p.weather = nil;
    p.hud = nil;
    p.nextEvent = nil;
    p.style = style;
    p.occasion = occasion;
    SSApplySampleData(p);
    // [W1] After SSApplySampleData: classes of weather/hud/nextEvent.
    OMCLogWriteSync(@"Prefs", [NSString stringWithFormat:
        @"[W1] showPreviewStyle after SSApplySampleData weatherClass=%@ hudClass=%@ nextEventClass=%@",
        OMCW1ClassName(p.weather), OMCW1ClassName(p.hud),
        OMCW1ClassName(p.nextEvent)]);
    p.occasion = occasion;
    p.name = SSStringPref(@"startupScreenGreetingName");
    NSString *car = SSStringPref(@"startupScreenCarName");
    if (car.length == 0) car = SSDiagCarName();
    p.carName = car;
    id tempo = SSRawPref(@"startupScreenTempo");
    NSInteger t = tempo ? [tempo integerValue] : 1;
    if (t < 0) t = 0;
    if (t >= 2) t = 2;
    p.tempo = tempo ? t : 1;
    p.logoEffect = [SSRawPref(@"startupScreenLogoEffect") integerValue];
    id dur = SSRawPref(@"startupScreenDuration");
    double d = dur ? [dur doubleValue] : 5;
    if (d > 30) d = 30;
    if (d < 1) d = 1;
    p.duration = dur ? d : 5;
    p.date = [NSDate date];
    if (style == 0) {
        NSString *video = [self selectedVideo];
        if (video) {
            NSString *frames = [SSReal([kSSDir stringByAppendingPathComponent:@"Videos"])
                stringByAppendingPathComponent:@".frames"];
            NSString *first = [[frames stringByAppendingPathComponent:video]
                stringByAppendingPathComponent:@"00000.jpg"];
            p.image = [UIImage imageWithContentsOfFile:first];
        }
    } else if (style == 1) {
        NSString *logo = SSReal([kSSDir stringByAppendingPathComponent:@"Logo/logo.png"]);
        if (logo) p.image = [UIImage imageWithContentsOfFile:logo];
    } else if (style == 3 || style == 8) {
        NSDictionary *w = SSWeatherLoadCache();
        if (w) p.weather = w;
        else if (!p.weather) p.weather = @{};   // (1-entry constant dict in orig.; INFERRED)
    }
    if (style == 0)
        p.imageFits = ([SSRawPref(@"startupScreenScaleMode") integerValue] == 1);
    [p reload];
    // [W1] After [preview reload].
    OMCLogWriteSync(@"Prefs", [NSString stringWithFormat:
        @"[W1] showPreviewStyle after preview reload style=%ld", (long)style]);
    [p playIntro];
    // [W1] After [preview playIntro] / bracket exit.
    OMCLogWriteSync(@"Prefs", [NSString stringWithFormat:
        @"[W1] showPreviewStyle after preview playIntro style=%ld exit", (long)style]);
}

// --------------------------------------------------------------- birthday
- (UIView *)birthdayAccessory {
    // [W1] Separate bracket around -birthdayAccessory (W1 plan).
    OMCLogWriteSync(@"Prefs", @"[W1] birthdayAccessory enter");
    if (self.birthdayView) {
        // [W1] Bracket exit (cached view).
        OMCLogWriteSync(@"Prefs", @"[W1] birthdayAccessory exit (cached)");
        return self.birthdayView;
    }
    UIDatePicker *picker = [UIDatePicker new];
    picker.datePickerMode = UIDatePickerModeDate;
    // [W1 fix] Picker style restored to Compact (original style arg
    // w2=#2 at 0x400e4-0x400e8); ours used Inline (=3).
    picker.preferredDatePickerStyle = UIDatePickerStyleCompact;
    picker.locale = [NSLocale localeWithLocaleIdentifier:OMCLanguage()];
    picker.tintColor = [UIColor labelColor];
    [picker addTarget:self action:@selector(birthdayChanged:)
        forControlEvents:UIControlEventValueChanged];
    UIButton *clear = [UIButton buttonWithType:UIButtonTypeCustom];
    [clear setImage:[UIImage systemImageNamed:@"xmark.circle.fill"] forState:UIControlStateNormal];
    clear.tintColor = OMCColorFromHex(@"#FF5C54");
    clear.accessibilityLabel = L(@"STARTUPSCREEN_BIRTHDAY_CLEAR");
    [clear addTarget:self action:@selector(clearBirthday)
        forControlEvents:UIControlEventTouchUpInside];
    [clear.widthAnchor constraintEqualToConstant:28].active = YES;
    UIStackView *stack = [[UIStackView alloc] initWithArrangedSubviews:@[picker, clear]];
    stack.axis = UILayoutConstraintAxisHorizontal;
    stack.alignment = UIStackViewAlignmentCenter;
    stack.spacing = 4;
    self.birthdayPicker = picker;
    self.birthdayClear = clear;
    self.birthdayView = stack;
    [self updateBirthdayAccessory];
    // [W1] Bracket exit.
    OMCLogWriteSync(@"Prefs", @"[W1] birthdayAccessory exit");
    return self.birthdayView;
}

- (void)updateBirthdayAccessory {
    NSString *str = SSStringPref(@"startupScreenBirthday");
    NSDate *date = SSBirthdayDate(str);
    BOOL animated = YES;
    if (!str) {
        date = SSBirthdayDate(@"01-01");
        if (!date) { date = [NSDate date]; animated = NO; }
    }
    if (date) [self.birthdayPicker setDate:date animated:animated];
    BOOL has = (str != nil);
    self.birthdayPicker.alpha = has ? 1 : 0.4;
    self.birthdayClear.alpha = has ? 1 : 0;
    self.birthdayClear.enabled = has;
    CGSize fit = [self.birthdayView
        systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    self.birthdayView.frame = CGRectMake(0, 0, ceil(fit.width),
                                         MAX(ceil(fit.height), 37));
}

- (void)birthdayChanged:(UIDatePicker *)picker {
    NSString *s = [SSFormatter(@"MM-dd") stringFromDate:picker.date];
    SSWritePref(@"startupScreenBirthday", s);
    [self birthdayDidChange];
}

- (void)clearBirthday {
    SSWritePref(@"startupScreenBirthday", @"");
    [self birthdayDidChange];
}

- (void)birthdayDidChange {
    [self updateBirthdayAccessory];
    for (PSSpecifier *sp in _specifiers)
        if ([sp.identifier isEqualToString:@"occasionPreview"])
            sp.name = [self occasionPreviewTitle];
    [self redecorateVisibleCells];
}

- (void)previewOccasion {
    [self.table setContentOffset:CGPointMake(0, -self.table.adjustedContentInset.top)
                        animated:YES];
    NSInteger code = SSUpcomingOccasion(SSStringPref(@"startupScreenBirthday"));
    [self showPreviewStyle:11 occasion:code];
}

// ------------------------------------------------------------------ videos
- (void)viewDidAppear:(BOOL)animated {
    // [W1] Bracket enter.
    OMCLogWriteSync(@"Prefs", @"[W1] OMCStartupScreenController viewDidAppear enter");
    [super viewDidAppear:animated];
    NSArray *w1Files = [self videoFiles];
    NSMutableArray *missing = [NSMutableArray array];
    for (NSString *name in w1Files)
        if (![self hasFramesForVideo:name]) [missing addObject:name];
    // [W1] videoFiles list + missing-frames list, BEFORE
    // extractFramesForVideos: (W1 plan point).
    OMCLogWriteSync(@"Prefs", [NSString stringWithFormat:
        @"[W1] viewDidAppear videoFiles=%@ missingFrames=%@",
        [w1Files componentsJoinedByString:@", "],
        [missing componentsJoinedByString:@", "]]);
    [self extractFramesForVideos:missing completion:nil];
    // [W1] Bracket exit; the decorateCell first pass ends here.
    OMCLogWriteSync(@"Prefs", @"[W1] OMCStartupScreenController viewDidAppear exit (after extractFramesForVideos call)");
    sW1DecorateFirstPass = NO;
}

- (NSArray *)videoFiles {
    NSFileManager *fm = [NSFileManager defaultManager];
    NSString *dir = SSReal([kSSDir stringByAppendingPathComponent:@"Videos"]);
    [fm createDirectoryAtPath:[kSSDir stringByAppendingPathComponent:@"Videos"]
        withIntermediateDirectories:YES attributes:nil error:nil];
    NSArray *contents = [fm contentsOfDirectoryAtPath:dir error:nil];
    // [W1] SSReal result (nil?) + contents count (W1 plan point).
    OMCLogWriteSync(@"Prefs", [NSString stringWithFormat:
        @"[W1] videoFiles realDir=%@ realIsNil=%d contentsCount=%lu",
        dir, dir == nil, (unsigned long)contents.count]);
    NSMutableArray *out = [NSMutableArray array];
    for (NSString *name in contents)
        if (![name hasPrefix:@"."]) [out addObject:name];
    NSArray *result = [out sortedArrayUsingSelector:@selector(localizedStandardCompare:)];
    // [W1] Result list.
    OMCLogWriteSync(@"Prefs", [NSString stringWithFormat:
        @"[W1] videoFiles result=%@", [result componentsJoinedByString:@", "]]);
    return result;
}

- (void)refreshVideoList {
    PSSpecifier *target = nil;
    for (PSSpecifier *sp in _specifiers)
        if ([sp.identifier isEqualToString:@"videoName"]) { target = sp; break; }
    if (!target) {
        // [W1] No videoName specifier found (W1 plan point).
        OMCLogWriteSync(@"Prefs", @"[W1] refreshVideoList targetFound=NO");
        return;
    }
    NSArray *files = [self videoFiles];
    // [W1] Target found + videoFiles array + branch (filled in below).
    OMCLogWriteSync(@"Prefs", [NSString stringWithFormat:
        @"[W1] refreshVideoList targetFound=YES videoFiles=%@",
        [files componentsJoinedByString:@", "]]);
    if (files.count == 0) {
        // [W1] Branch: empty.
        OMCLogWriteSync(@"Prefs", @"[W1] refreshVideoList branch=empty");
        [target setValues:@[@""] titles:@[L(@"STARTUPSCREEN_NO_VIDEO")]];
        return;
    }
    // [W1] Branch: has videos.
    OMCLogWriteSync(@"Prefs", [NSString stringWithFormat:
        @"[W1] refreshVideoList branch=hasVideos count=%lu", (unsigned long)files.count]);
    NSMutableArray *titles = [NSMutableArray array];
    for (NSString *f in files) [titles addObject:[f stringByDeletingPathExtension]];
    // [W1 fix / audit section 3a] Original passes values = FULL file
    // names and titles = extension-stripped names (0x40fa0-0x40fac,
    // titles built 0x40f44-0x40f64). Ours passed titles for BOTH.
    [target setValues:files titles:titles];
}

- (NSString *)selectedVideo {
    id name = SSRawPref(@"startupScreenVideoName");
    NSArray *files = [self videoFiles];
    if ([name isKindOfClass:[NSString class]] && [name length] > 0 &&
        [files containsObject:name])
        return name;
    return files.firstObject;
}

- (void)setSelectedVideo:(NSString *)name {
    CFPreferencesSetAppValue(CFSTR("startupScreenVideoName"),
                             (__bridge CFPropertyListRef)name,
                             (__bridge CFStringRef)kSSDomain);
    CFPreferencesAppSynchronize((__bridge CFStringRef)kSSDomain);
    [self reloadSpecifiers];
}

- (BOOL)hasFramesForVideo:(NSString *)name {
    NSString *info = [[[SSReal([kSSDir stringByAppendingPathComponent:@"Videos"])
        stringByAppendingPathComponent:@".frames"]
        stringByAppendingPathComponent:name]
        stringByAppendingPathComponent:@"info.plist"];
    NSDictionary *d = [NSDictionary dictionaryWithContentsOfFile:info];
    return [d[@"version"] integerValue] > 1;
}

// -------------------------------------------------------------- extraction
- (BOOL)extractAudioFromAsset:(AVAsset *)asset seconds:(double)seconds toDir:(NSString *)dir {
    if ([asset tracksWithMediaType:AVMediaTypeAudio].count == 0) return YES;
    AVAssetExportSession *exp = [AVAssetExportSession
        exportSessionWithAsset:asset presetName:AVAssetExportPresetAppleM4A];
    if (!exp) return NO;
    exp.outputURL = [NSURL fileURLWithPath:[dir stringByAppendingPathComponent:@"audio.m4a"]];
    exp.outputFileType = AVFileTypeAppleM4A;
    exp.timeRange = CMTimeRangeMake(kCMTimeZero, CMTimeMakeWithSeconds(seconds, 600));
    dispatch_semaphore_t sem = dispatch_semaphore_create(0);
    [exp exportAsynchronouslyWithCompletionHandler:^{
        dispatch_semaphore_signal(sem);
    }];
    dispatch_semaphore_wait(sem, DISPATCH_TIME_FOREVER);
    return exp.status == AVAssetExportSessionStatusCompleted;
}

- (void)extractFramesForVideos:(NSArray *)names completion:(void (^)(void))completion {
    if (names.count == 0 || self.extracting) {
        if (completion) completion();
        return;
    }
    self.extracting = YES;
    UIAlertController *alert = [UIAlertController
        alertControllerWithTitle:@"DuoCar"
                         message:[L(@"STARTUPSCREEN_PREPARING") stringByAppendingString:@"…"]
                  preferredStyle:UIAlertControllerStyleAlert];
    [self presentViewController:alert animated:YES completion:nil];
    dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0), ^{
        NSMutableArray *errors = [NSMutableArray array];
        [names enumerateObjectsUsingBlock:^(NSString *name, NSUInteger idx, BOOL *stop) {
            NSError *err = nil;
            BOOL ok = [self extractFramesForVideo:name error:&err progress:^(double p) {
                double frac = (idx + p) / names.count;
                dispatch_async(dispatch_get_main_queue(), ^{
                    NSString *suffix = names.count >= 2
                        ? [NSString stringWithFormat:@" (%lu/%lu)",
                           (unsigned long)(idx + 1), (unsigned long)names.count] : @"";
                    alert.message = [NSString stringWithFormat:@"%@%@… %d%%",
                        L(@"STARTUPSCREEN_PREPARING"), suffix, (int)(frac * 100)];
                });
            }];
            if (!ok)
                [errors addObject:[NSString stringWithFormat:@"%@: %@", name,
                    err.localizedDescription ?: @"?"]];
        }];
        dispatch_async(dispatch_get_main_queue(), ^{
            self.extracting = NO;
            [alert dismissViewControllerAnimated:YES completion:^{
                if (errors.count)
                    [self showMessage:[NSString stringWithFormat:@"%@\n%@",
                        L(@"STARTUPSCREEN_PROCESS_FAILED"),
                        [errors componentsJoinedByString:@"\n"]]];
                if (completion) completion();
            }];
        });
    });
}

// Frame extraction: AVAssetReader (BGRA pixel buffers) over the first
// (min(duration, 60)s) of the video, sampling at 24 fps (threshold step
// 1/24 s, 1 ms tolerance); each sampled frame is orientation-corrected,
// scaled so its longest side is <= 2000 px, and written as
// <name>.frames/%05lu.jpg via a CIContext JPEG representation; the audio
// track is exported to audio.m4a; finally info.plist {version:2, count,
// fps:24} is written. Any failure removes the frames dir and returns NO.
- (BOOL)extractFramesForVideo:(NSString *)name error:(NSError **)outErr
                     progress:(void (^)(double))progress {
    NSFileManager *fm = [NSFileManager defaultManager];
    NSString *videosDir = SSReal([kSSDir stringByAppendingPathComponent:@"Videos"]);
    NSString *framesDir = [[videosDir stringByAppendingPathComponent:@".frames"]
        stringByAppendingPathComponent:name];
    [fm removeItemAtPath:framesDir error:nil];
    if (![fm createDirectoryAtPath:framesDir withIntermediateDirectories:YES
                        attributes:nil error:outErr])
        return NO;
    AVURLAsset *asset = [AVURLAsset URLAssetWithURL:
        [NSURL fileURLWithPath:[videosDir stringByAppendingPathComponent:name]] options:nil];
    AVAssetTrack *track = [asset tracksWithMediaType:AVMediaTypeVideo].firstObject;
    AVAssetReader *reader = track
        ? [AVAssetReader assetReaderWithAsset:asset error:outErr] : nil;
    if (!reader) {
        if (outErr && !*outErr) *outErr = reader.error;
        [fm removeItemAtPath:framesDir error:nil];
        return NO;
    }
    NSDictionary *settings = @{ (id)kCVPixelBufferPixelFormatTypeKey:
                                @(kCVPixelFormatType_32BGRA) };  // 1111970369, VERIFIED
    AVAssetReaderTrackOutput *output = [AVAssetReaderTrackOutput
        assetReaderTrackOutputWithTrack:track outputSettings:settings];
    output.alwaysCopiesSampleData = NO;
    [reader addOutput:output];
    double total = CMTimeGetSeconds(asset.duration);
    double capped = MIN(total, 60.0);
    reader.timeRange = CMTimeRangeMake(kCMTimeZero, CMTimeMakeWithSeconds(capped, 600));
    if (![reader startReading]) {
        if (outErr) *outErr = reader.error;
        [fm removeItemAtPath:framesDir error:nil];
        return NO;
    }
    CIContext *ctx = [CIContext contextWithOptions:nil];
    CGColorSpaceRef srgb = CGColorSpaceCreateWithName(kCGColorSpaceSRGB);
    // preferredTransform -> CGImagePropertyOrientation (1/3/4/6/8 mapping)
    CGAffineTransform tr = track.preferredTransform;
    CGImagePropertyOrientation orient = kCGImagePropertyOrientationUp;
    if (tr.a == 0 && tr.b == 1 && tr.c == -1 && tr.d == 0) orient = 6;
    else if (tr.a == 0 && tr.b == -1 && tr.c == 1 && tr.d == 0) orient = 8;
    else if (tr.a == -1 && tr.b == 0 && tr.c == 0 && tr.d == -1) orient = 3;
    NSDictionary *jpegOpts = @{ (id)kCGImageDestinationLossyCompressionQuality: @0.85 }; // INFERRED value
    NSUInteger frame = 0;
    double next = 0;
    CMSampleBufferRef sample;
    while ((sample = [output copyNextSampleBuffer]) != NULL) {
        @autoreleasepool {
            double pts = CMTimeGetSeconds(CMSampleBufferGetPresentationTimeStamp(sample));
            CVPixelBufferRef pb = CMSampleBufferGetImageBuffer(sample);
            if (pb && pts + 0.001 >= next) {
                CIImage *img = [[CIImage imageWithCVPixelBuffer:pb]
                    imageByApplyingCGOrientation:orient];
                CGRect ext = img.extent;
                double scale = MIN(1.0, 2000.0 / MAX(ext.size.width, ext.size.height));
                img = [img imageByApplyingTransform:
                    CGAffineTransformMakeScale(scale, scale)];
                NSData *jpg = [ctx JPEGRepresentationOfImage:img colorSpace:srgb
                                                     options:jpegOpts];
                NSString *file = [framesDir stringByAppendingPathComponent:
                    [NSString stringWithFormat:@"%05lu.jpg", (unsigned long)frame]];
                [jpg writeToFile:file atomically:NO];
                frame++;
                next += 1.0 / 24.0;
                if (capped > 0 && progress) progress(MIN(1.0, pts / capped));
            }
        }
        CFRelease(sample);
    }
    CGColorSpaceRelease(srgb);
    if (reader.status != AVAssetReaderStatusCompleted && frame == 0) {
        if (outErr) *outErr = reader.error;
        [fm removeItemAtPath:framesDir error:nil];
        return NO;
    }
    if (![self extractAudioFromAsset:asset seconds:capped toDir:framesDir])
        NSLog(@"[OmniCar/StartupScreen] audio export failed for %@", name);
    NSDictionary *info = @{ @"version": @2, @"count": @(frame), @"fps": @24 };
    NSURL *infoURL = [NSURL fileURLWithPath:
        [framesDir stringByAppendingPathComponent:@"info.plist"]];
    if (![info writeToURL:infoURL error:outErr]) {
        [fm removeItemAtPath:framesDir error:nil];
        return NO;
    }
    return YES;
}

// ----------------------------------------------------------------- imports
- (void)importFromPhotos {
    self.pickKind = 0;
    UIImagePickerController *picker = [UIImagePickerController new];
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    picker.mediaTypes = @[UTTypeMovie.identifier];
    picker.videoExportPreset = AVAssetExportPresetPassthrough;
    picker.delegate = self;
    [self presentViewController:picker animated:YES completion:nil];
}

- (void)importFromFiles {
    self.pickKind = 0;
    UIDocumentPickerViewController *picker = [[UIDocumentPickerViewController alloc]
        initForOpeningContentTypes:@[UTTypeMovie] asCopy:YES];
    picker.delegate = self;
    [self presentViewController:picker animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker
        didFinishPickingMediaWithInfo:(NSDictionary *)info {
    if (self.pickKind == 1) {
        NSURL *imageURL = info[UIImagePickerControllerImageURL];
        UIImage *image = imageURL
            ? [UIImage imageWithContentsOfFile:imageURL.path] : nil;
        if (!image) image = info[UIImagePickerControllerOriginalImage];
        [picker dismissViewControllerAnimated:YES completion:^{
            [self saveLogoImage:image];
        }];
        return;
    }
    NSURL *url = info[UIImagePickerControllerMediaURL];
    [picker dismissViewControllerAnimated:YES completion:^{
        if (!url) return;
        NSDateFormatter *f = [NSDateFormatter new];
        f.dateFormat = @"yyyyMMdd-HHmmss";
        NSString *ext = url.pathExtension.length ? url.pathExtension : @"mov";
        NSString *name = [NSString stringWithFormat:@"Video %@.%@",
            [f stringFromDate:[NSDate date]], ext];
        [self copyVideoAtURL:url name:name];
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)documentPicker:(UIDocumentPickerViewController *)dp
    didPickDocumentsAtURLs:(NSArray<NSURL *> *)urls {
    NSURL *url = urls.firstObject;
    if (!url) return;
    if (self.pickKind == 1) {
        [self saveLogoImage:[UIImage imageWithContentsOfFile:url.path]];
    } else if (self.pickKind == 2) {
        [self copySoundAtURL:url];
    } else {
        [self copyVideoAtURL:url name:url.lastPathComponent];
    }
}

- (void)copyVideoAtURL:(NSURL *)url name:(NSString *)name {
    NSFileManager *fm = [NSFileManager defaultManager];
    NSString *dir = [kSSDir stringByAppendingPathComponent:@"Videos"];
    [fm createDirectoryAtPath:dir withIntermediateDirectories:YES attributes:nil error:nil];
    NSString *base = [name stringByDeletingPathExtension];
    NSString *ext = name.pathExtension;
    NSString *destName = name;
    NSString *dest = [SSReal(dir) stringByAppendingPathComponent:destName];
    for (int n = 2; [fm fileExistsAtPath:dest]; n++) {
        destName = [NSString stringWithFormat:@"%@ %d.%@", base, n, ext];
        dest = [SSReal(dir) stringByAppendingPathComponent:destName];
    }
    NSError *err = nil;
    if (![fm copyItemAtPath:url.path toPath:dest error:&err]) {
        [self showMessage:[NSString stringWithFormat:L(@"STARTUPSCREEN_SAVE_FAILED"),
            err.localizedDescription]];
        return;
    }
    [fm setAttributes:@{NSFilePosixPermissions: @0644} ofItemAtPath:dest error:nil];
    [self setSelectedVideo:dest.lastPathComponent];
    [self extractFramesForVideos:@[dest.lastPathComponent] completion:^{
        [self updatePreview];
    }];
}

- (void)addVideo {
    UIAlertController *ac = [UIAlertController alertControllerWithTitle:nil message:nil
        preferredStyle:UIAlertControllerStyleActionSheet];
    [ac addAction:[UIAlertAction actionWithTitle:L(@"STARTUPSCREEN_FROM_PHOTOS")
        style:UIAlertActionStyleDefault handler:^(UIAlertAction *a) { [self importFromPhotos]; }]];
    [ac addAction:[UIAlertAction actionWithTitle:L(@"STARTUPSCREEN_FROM_FILES")
        style:UIAlertActionStyleDefault handler:^(UIAlertAction *a) { [self importFromFiles]; }]];
    [ac addAction:[UIAlertAction actionWithTitle:L(@"CANCEL")
        style:UIAlertActionStyleCancel handler:nil]];
    ac.popoverPresentationController.sourceView = self.view;
    ac.popoverPresentationController.sourceRect =
        CGRectMake(CGRectGetMidX(self.view.bounds), CGRectGetMidY(self.view.bounds), 1, 1);
    [self presentViewController:ac animated:YES completion:nil];
}

- (void)previewVideo {
    NSString *name = [self selectedVideo];
    if (!name) { [self showMessage:L(@"STARTUPSCREEN_NO_VIDEO_PREVIEW")]; return; }
    AVPlayerViewController *vc = [AVPlayerViewController new];
    NSString *path = [SSReal([kSSDir stringByAppendingPathComponent:@"Videos"])
        stringByAppendingPathComponent:name];
    vc.player = [AVPlayer playerWithURL:[NSURL fileURLWithPath:path]];
    [self presentViewController:vc animated:YES completion:^{
        [vc.player play];
    }];
}

- (void)deleteVideo {
    NSString *name = [self selectedVideo];
    if (!name) { [self showMessage:L(@"STARTUPSCREEN_NO_VIDEO_DELETE")]; return; }
    UIAlertController *ac = [UIAlertController
        alertControllerWithTitle:L(@"STARTUPSCREEN_DELETE_TITLE")
                         message:[NSString stringWithFormat:L(@"STARTUPSCREEN_DELETE_CONFIRM"),
                                  [name stringByDeletingPathExtension]]
                  preferredStyle:UIAlertControllerStyleAlert];
    [ac addAction:[UIAlertAction actionWithTitle:L(@"CANCEL")
        style:UIAlertActionStyleCancel handler:nil]];
    [ac addAction:[UIAlertAction actionWithTitle:L(@"STARTUPSCREEN_DELETE_ACTION")
        style:UIAlertActionStyleDestructive handler:^(UIAlertAction *a) {
            NSFileManager *fm = [NSFileManager defaultManager];
            NSString *dir = SSReal([kSSDir stringByAppendingPathComponent:@"Videos"]);
            [fm removeItemAtPath:[dir stringByAppendingPathComponent:name] error:nil];
            [fm removeItemAtPath:[[dir stringByAppendingPathComponent:@".frames"]
                stringByAppendingPathComponent:name] error:nil];
            [self setSelectedVideo:[self videoFiles].firstObject];
            [self updatePreview];
        }]];
    [self presentViewController:ac animated:YES completion:nil];
}

// -------------------------------------------------------------------- logo
- (void)chooseLogo {
    UIAlertController *ac = [UIAlertController alertControllerWithTitle:nil message:nil
        preferredStyle:UIAlertControllerStyleActionSheet];
    [ac addAction:[UIAlertAction actionWithTitle:L(@"STARTUPSCREEN_FROM_PHOTOS")
        style:UIAlertActionStyleDefault handler:^(UIAlertAction *a) { [self logoFromPhotos]; }]];
    [ac addAction:[UIAlertAction actionWithTitle:L(@"STARTUPSCREEN_FROM_FILES")
        style:UIAlertActionStyleDefault handler:^(UIAlertAction *a) { [self logoFromFiles]; }]];
    [ac addAction:[UIAlertAction actionWithTitle:L(@"CANCEL")
        style:UIAlertActionStyleCancel handler:nil]];
    ac.popoverPresentationController.sourceView = self.view;
    ac.popoverPresentationController.sourceRect =
        CGRectMake(CGRectGetMidX(self.view.bounds), CGRectGetMidY(self.view.bounds), 1, 1);
    [self presentViewController:ac animated:YES completion:nil];
}

- (void)logoFromPhotos {
    self.pickKind = 1;
    UIImagePickerController *picker = [UIImagePickerController new];
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    picker.mediaTypes = @[UTTypeImage.identifier];
    picker.delegate = self;
    [self presentViewController:picker animated:YES completion:nil];
}

- (void)logoFromFiles {
    self.pickKind = 1;
    UIDocumentPickerViewController *picker = [[UIDocumentPickerViewController alloc]
        initForOpeningContentTypes:@[UTTypeImage] asCopy:YES];
    picker.delegate = self;
    [self presentViewController:picker animated:YES completion:nil];
}

// Logo: downscale so the longest pixel side is <= 1024, re-render at
// scale 1 (non-opaque, wide-gamut range), save as PNG with 0644 perms.
- (void)saveLogoImage:(UIImage *)image {
    if (!image || image.size.width <= 0 || image.size.height <= 0) {
        [self showMessage:L(@"STARTUPSCREEN_LOGO_FAILED")];
        return;
    }
    double pw = image.size.width * image.scale, ph = image.size.height * image.scale;
    double factor = MIN(1.0, 1024.0 / MAX(pw, ph));
    CGSize size = CGSizeMake(MAX(1, round(pw * factor)), MAX(1, round(ph * factor)));
    UIGraphicsImageRendererFormat *fmt = [UIGraphicsImageRendererFormat preferredFormat];
    fmt.scale = 1;
    fmt.opaque = NO;
    fmt.preferredRange = UIGraphicsImageRendererFormatRangeExtended;
    UIGraphicsImageRenderer *r = [[UIGraphicsImageRenderer alloc] initWithSize:size format:fmt];
    UIImage *rendered = [r imageWithActions:^(UIGraphicsImageRendererContext *ctx) {
        [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    }];
    NSData *png = UIImagePNGRepresentation(rendered);
    NSString *path = SSReal([kSSDir stringByAppendingPathComponent:@"Logo/logo.png"]);
    NSFileManager *fm = [NSFileManager defaultManager];
    [fm createDirectoryAtPath:[path stringByDeletingLastPathComponent]
        withIntermediateDirectories:YES attributes:nil error:nil];
    NSError *err = nil;
    if (!png || ![png writeToFile:path options:NSDataWritingAtomic error:&err]) {
        [self showMessage:[NSString stringWithFormat:L(@"STARTUPSCREEN_SAVE_FAILED"),
            err.localizedDescription ?: @"PNG"]];
        return;
    }
    [fm setAttributes:@{NSFilePosixPermissions: @0644} ofItemAtPath:path error:nil];
    [self updatePreview];
}

- (void)deleteLogo {
    NSString *path = SSReal([kSSDir stringByAppendingPathComponent:@"Logo/logo.png"]);
    NSFileManager *fm = [NSFileManager defaultManager];
    if (![fm fileExistsAtPath:path]) {
        [self showMessage:L(@"STARTUPSCREEN_LOGO_NONE")];
        return;
    }
    [fm removeItemAtPath:path error:nil];
    [self updatePreview];
}

// ------------------------------------------------------------------- sound
- (void)chooseSound {
    self.pickKind = 2;
    UIDocumentPickerViewController *picker = [[UIDocumentPickerViewController alloc]
        initForOpeningContentTypes:@[UTTypeAudio] asCopy:YES];
    picker.delegate = self;
    [self presentViewController:picker animated:YES completion:nil];
}

- (void)copySoundAtURL:(NSURL *)url {
    NSError *err = nil;
    AVAudioPlayer *probe = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&err];
    if (!probe) {
        [self showMessage:[NSString stringWithFormat:L(@"STARTUPSCREEN_SOUND_FAILED"),
            err.localizedDescription ?: url.lastPathComponent]];
        return;
    }
    NSFileManager *fm = [NSFileManager defaultManager];
    NSString *dir = [kSSDir stringByAppendingPathComponent:@"Sounds"];
    NSString *dest = [SSReal(dir) stringByAppendingPathComponent:url.lastPathComponent];
    [fm removeItemAtPath:dest error:nil];
    [fm createDirectoryAtPath:dir withIntermediateDirectories:YES attributes:nil error:nil];
    dest = [SSReal(dir) stringByAppendingPathComponent:url.lastPathComponent];
    if (![fm copyItemAtPath:url.path toPath:dest error:&err]) {
        [self showMessage:[NSString stringWithFormat:L(@"STARTUPSCREEN_SAVE_FAILED"),
            err.localizedDescription]];
        return;
    }
    [fm setAttributes:@{NSFilePosixPermissions: @0644} ofItemAtPath:dest error:nil];
    SSWritePref(@"startupScreenSoundFile", url.lastPathComponent);
    _specifiers = nil;
    [self reloadSpecifiers];
}

- (void)previewSound {
    NSString *name = [self currentSound];
    if (!name) { [self showMessage:L(@"STARTUPSCREEN_SOUND_NONE")]; return; }
    [self.soundPlayer stop];
    AVAudioSession *session = [AVAudioSession sharedInstance];
    [session setCategory:AVAudioSessionCategoryPlayback error:nil];
    [session setActive:YES error:nil];
    NSError *err = nil;
    // [W1 fix] currentSound returns the BARE file name in the
    // original; previewSound builds the full path itself from the
    // realpath-resolved Sounds dir (0x44ab0-0x44b0c), and its
    // failure message falls back to the bare name (csel at 0x44bfc).
    NSString *path = [SSReal([kSSDir stringByAppendingPathComponent:@"Sounds"])
        stringByAppendingPathComponent:name];
    self.soundPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:
        [NSURL fileURLWithPath:path] error:&err];
    if (!self.soundPlayer) {
        [self showMessage:[NSString stringWithFormat:L(@"STARTUPSCREEN_SOUND_FAILED"),
            err.localizedDescription ?: name]];
        return;
    }
    id vol = SSRawPref(@"startupScreenSoundVolume");
    double v = vol ? [vol doubleValue] : 100;
    self.soundPlayer.volume = (float)(MIN(MAX(v, 0), 100) / 100);
    [self.soundPlayer play];
}

- (void)deleteSound {
    // DELIBERATE DEVIATION from the original (GPT ruling 2026-11-08,
    // accepted as an acceptance gate): the original deleteSound
    // (0x44cf8) uses currentSound ONLY as a nil-gate (cbz x20 at
    // 0x44d34; the value is never messaged) and passes the
    // realpath-resolved Sounds DIRECTORY itself to
    // removeItemAtPath:error: (0x44e0c-0x44e18) — no
    // stringByAppendingPathComponent: anywhere in the method, i.e.
    // stock "delete sound" wipes every file in the Sounds folder.
    // To avoid data loss in the test release we delete ONLY the
    // currently selected sound file and clear its preference;
    // every other file in the directory is left untouched.
    NSString *name = [self currentSound];
    if (!name) { [self showMessage:L(@"STARTUPSCREEN_SOUND_NONE")]; return; }
    [self.soundPlayer stop];
    self.soundPlayer = nil;
    NSString *path = [SSReal([kSSDir stringByAppendingPathComponent:@"Sounds"])
        stringByAppendingPathComponent:name];
    [[NSFileManager defaultManager] removeItemAtPath:path error:nil];
    SSWritePref(@"startupScreenSoundFile", nil);
    _specifiers = nil;
    [self reloadSpecifiers];
}

@end
