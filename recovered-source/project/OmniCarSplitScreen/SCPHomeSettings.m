// SCPHomeSettings.m — SplitScreen-C: the home-screen settings dictionary
// and its derived getters.
//
// One builder (sub_4b640) reads the homeScreen* preferences and produces an
// 8-key dictionary; the result is cached (global 0x881d8) and every visual
// feature of the family reads through it:
//   on    — master OmniCar enabled flag
//   size  — icon size percent, pref homeScreenIconSize, default 100, 60..130
//   cols  — grid columns override, pref homeScreenGridCols, default 0,
//           clamped 0..8 then whitelisted to {0,3,4,5,6,7,8}
//   rows  — grid rows override, pref homeScreenGridRows, default 0,
//           clamped 0..4, whitelist {0,1,2,3,4}
//   names — show icon labels, pref homeScreenShowNames, default YES
//   style — wallpaper style, pref homeScreenWallpaperStyle, default 7,
//           1..8, but forced to 0 unless pref homeScreenWallpaper is on
//   blur  — pref homeScreenBlur, default 0, 0..30
//   dim   — pref homeScreenDim, default 25, 0..70
// A value of 0 for cols/rows/size-scale means "no override".

#import "SCPHomeCommon.h"

NS_ASSUME_NONNULL_BEGIN

static NSDictionary *SCPSettingsCache;                 // 0x881d8
__weak id SCPApplyHomeVCWeak;                          // 0x881e0 (stored by SCPHomeApply)
static BOOL SCPHomeVisibleState;                       // byte 0x87f51

void SCPHomeApply(id homeVC); // 0x4a6d8 (SCPHomeApply.m)

// 0x4d99c — VERIFIED: clamped integer preference.
static NSInteger SCPClampedPrefInt(NSString *key, NSInteger dflt,
                                   NSInteger lo, NSInteger hi) {
    id v = OMCPref(key, nil);
    NSInteger n = [v respondsToSelector:@selector(integerValue)]
                      ? [v integerValue] : dflt;
    if (n < lo) n = lo;
    if (n > hi) n = hi;
    return n;
}

// 0x4b640 — VERIFIED
static NSDictionary *SCPBuildHomeSettings(void) {
    BOOL wallpaperOn = [OMCPref(@"homeScreenWallpaper", (id)kCFBooleanFalse) boolValue];
    NSInteger cols = SCPClampedPrefInt(@"homeScreenGridCols", 0, 0, 8);
    if (![@[@0, @3, @4, @5, @6, @7, @8] containsObject:@(cols)]) cols = 0;
    NSInteger rows = SCPClampedPrefInt(@"homeScreenGridRows", 0, 0, 4);
    if (![@[@0, @1, @2, @3, @4] containsObject:@(rows)]) rows = 0;
    return @{
        @"on":    @(OMCEnabled()),
        @"size":  @(SCPClampedPrefInt(@"homeScreenIconSize", 100, 60, 130)),
        @"cols":  @(cols),
        @"rows":  @(rows),
        @"names": OMCPref(@"homeScreenShowNames", (id)kCFBooleanTrue),
        @"style": @(wallpaperOn
                        ? SCPClampedPrefInt(@"homeScreenWallpaperStyle", 7, 1, 8)
                        : 0),
        @"blur":  @(SCPClampedPrefInt(@"homeScreenBlur", 0, 0, 30)),
        @"dim":   @(SCPClampedPrefInt(@"homeScreenDim", 25, 0, 70)),
    };
}

// 0x48ef8 — VERIFIED: cached accessor (built lazily on first use).
NSDictionary *SCPHomeSettings(void) {
    if (!SCPSettingsCache) SCPSettingsCache = SCPBuildHomeSettings();
    return SCPSettingsCache;
}

// 0x48e24 (_SCPHomeIconScale) — VERIFIED
CGFloat SCPHomeIconScale(void) {
    NSDictionary *s = SCPHomeSettings();
    if (![s[@"on"] boolValue]) return 1.0;
    return [s[@"size"] doubleValue] / 100.0;
}

// 0x48f48 (_SCPHomeGridColumns) — VERIFIED (0 = no override)
NSInteger SCPHomeGridColumns(void) {
    NSDictionary *s = SCPHomeSettings();
    if (![s[@"on"] boolValue]) return 0;
    return [s[@"cols"] integerValue];
}

// 0x49014 (_SCPHomeGridRows) — VERIFIED
NSInteger SCPHomeGridRows(void) {
    NSDictionary *s = SCPHomeSettings();
    if (![s[@"on"] boolValue]) return 0;
    return [s[@"rows"] integerValue];
}

// 0x490e0 (_SCPHomeShowNames) — VERIFIED
BOOL SCPHomeShowNames(void) {
    NSDictionary *s = SCPHomeSettings();
    if (![s[@"on"] boolValue]) return YES;
    return [s[@"names"] boolValue];
}

// 0x4b598 (_SCPHomeRefresh) — VERIFIED. Called from A's prefschanged block
// (0x54bc) together with SCPRefreshAppIconsSoon / SCPRefreshHiddenAppsSoon.
void SCPHomeRefresh(void) {
    SCPSettingsCache = SCPBuildHomeSettings();
    id homeVC = SCPApplyHomeVCWeak;
    if ([homeVC isViewLoaded]) {
        SCPHomeApply(homeVC);
        [[homeVC view] setNeedsLayout];
    }
}

// 0x4b4bc (_SCPHomeSetVisible) — VERIFIED. Called from A's home-VC
// viewDidAppear:/viewDidDisappear: hooks (0x4d24/0x4d90). The wall view is
// SplitScreen-B's SCPHomeWallView (tag 0x4857); -updatePlayback is B's
// method. The state byte 0x87f51 is presumably also read by B's class.
void SCPHomeSetVisible(BOOL visible) {
    if (SCPHomeVisibleState == visible) return;
    SCPHomeVisibleState = visible;
    id homeVC = SCPApplyHomeVCWeak;
    UIView *wall = nil;
    if ([homeVC isViewLoaded])
        wall = [[homeVC view] viewWithTag:0x4857];
    [(id)wall updatePlayback];
}

// 0x4bd7c — VERIFIED: invoke of the repeating 30 s timer block created in
// SCPHomeApply when the wallpaper is a video (style 8); re-applies the
// home settings while the style is still 8.
void SCPVideoWallpaperTimerTick(void) {
    id homeVC = SCPApplyHomeVCWeak;
    if ([homeVC isViewLoaded] &&
        [SCPHomeSettings()[@"style"] integerValue] == 8)
        SCPHomeApply(homeVC);
}

NS_ASSUME_NONNULL_END
