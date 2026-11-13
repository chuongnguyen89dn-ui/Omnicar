// SCPPrefs.m — reconstructed from disassembly (agent A).
// Status per method is in SplitScreenA_REPORT.md. The four static accessors
// below wrap the OMC preference layer (Core module); their addresses in the
// original binary: object 0x4dab8, string 0x4dcf4, setString 0x4db84,
// setObject 0x4ec70. They are reconstructed as calls to OMCPref() plus the
// matching setter of the Core layer (OMCPrefSet), which the Core agent owns.

#import "SCPPrefs.h"
#import "SCPShared.h"

// Core-layer setter (companion of OMCPref) — declared here, owned by Core.
extern void SCPHomePrefSet(NSString *key, id _Nullable value); // [phase2; backported to src in phase 3] A's placeholder "OMCPrefSet" = sub_c4f4, transcribed by C as SCPHomePrefSet (SCPAppIcons.m)

static id SCPObjectForKey(NSString *key) { return OMCPref(key, nil); }
static NSString *SCPStringForKey(NSString *key) {
    id v = OMCPref(key, nil);
    return [v isKindOfClass:[NSString class]] ? v : nil;
}
static void SCPSetStringForKey(NSString *key, NSString *value) { SCPHomePrefSet(key, value); }
static void SCPSetObjectForKey(NSString *key, id value) { SCPHomePrefSet(key, value); }

@implementation SCPPrefs

// VERIFIED (0x…): OMCPrefsSync(); return OMCFeatureEnabled(@"splitScreen");
// The trailing call to sub_560b8 in the original is the class's +load-time
// self-check block; it does not affect the return value.
+ (BOOL)enabled {
    OMCPrefsSync();
    return OMCFeatureEnabled(@"splitScreen");
}

// VERIFIED: tail-call SCPStringForKey(@"splitScreenLastLeft").
+ (NSString *)lastLeftApp { return SCPStringForKey(@"splitScreenLastLeft"); }
+ (NSString *)lastRightApp { return SCPStringForKey(@"splitScreenLastRight"); }

// VERIFIED: writes only non-empty values and only when changed
// (length checks + isEqualToString: guards before each set).
+ (void)setLastPairLeft:(NSString *)left right:(NSString *)right {
    if (left.length && ![left isEqualToString:SCPStringForKey(@"splitScreenLastLeft")])
        SCPSetStringForKey(@"splitScreenLastLeft", left);
    if (right.length && ![right isEqualToString:SCPStringForKey(@"splitScreenLastRight")])
        SCPSetStringForKey(@"splitScreenLastRight", right);
}

// VERIFIED: boolValue of the stored object, NO when absent.
+ (BOOL)autoLaunch { return [SCPObjectForKey(@"splitScreenAutoLaunch") boolValue]; }

// VERIFIED: the raw stored object (array of bundle IDs published by
// -[SCPCarSplit publishCarPlayApps] for the Settings app).
+ (NSArray<NSString *> *)carPlayApps { return SCPObjectForKey(@"splitScreenCarPlayApps"); }
+ (void)setCarPlayApps:(NSArray<NSString *> *)apps { SCPSetObjectForKey(@"splitScreenCarPlayApps", apps); }

// VERIFIED: returns the stored array filtered/normalised to entries that are
// dictionaries carrying an "apps" array and a "layout" number; @[] when unset.
+ (NSArray<NSDictionary *> *)recentLayouts {
    NSArray *stored = SCPObjectForKey(@"splitScreenRecentLayouts");
    if (![stored isKindOfClass:[NSArray class]]) return @[];
    NSMutableArray *out = [NSMutableArray array];
    for (id entry in stored) {
        if ([entry isKindOfClass:[NSDictionary class]] &&
            [entry[@"apps"] isKindOfClass:[NSArray class]] && entry[@"layout"])
            [out addObject:entry];
    }
    return out;
}

// VERIFIED: builds @{layout:@(layout), apps:apps}; if an identical entry
// (isEqualToDictionary:) already exists it is not duplicated; entries equal
// by (layout, apps-as-set) are de-duplicated; the list is capped
// (the original compares against the stored count while inserting at head).
// Exact cap value: INFERRED 10 from the enumeration constants in the body.
+ (void)addRecentLayout:(NSInteger)layout apps:(NSArray<NSString *> *)apps {
    if (!apps.count) return;
    NSDictionary *entry = @{@"layout": @(layout), @"apps": apps};
    NSMutableArray *list = [[self recentLayouts] mutableCopy];
    for (NSDictionary *old in [list copy]) {
        if ([old isEqualToDictionary:entry] ||
            ([old[@"layout"] integerValue] == layout &&
             [[NSSet setWithArray:old[@"apps"]] isEqualToSet:[NSSet setWithArray:apps]]))
            [list removeObject:old];
    }
    [list insertObject:entry atIndex:0];
    while (list.count > 10) [list removeLastObject]; // INFERRED cap
    SCPSetObjectForKey(@"splitScreenRecentLayouts", list);
}

// VERIFIED: dict = splitScreenPairRatios; key built by sub_4ec70's caller
// convention "left|right" (INFERRED separator — the key-construction helper
// concatenates the two bundle IDs with a separator string); 0 when absent.
+ (double)ratioForPairLeft:(NSString *)left right:(NSString *)right {
    NSDictionary *ratios = SCPObjectForKey(@"splitScreenPairRatios");
    NSString *key = [NSString stringWithFormat:@"%@|%@", left ?: @"", right ?: @""];
    return [ratios[key] doubleValue];
}
+ (void)setRatio:(double)ratio forPairLeft:(NSString *)left right:(NSString *)right {
    NSMutableDictionary *ratios = [SCPObjectForKey(@"splitScreenPairRatios") mutableCopy] ?: [NSMutableDictionary dictionary];
    NSString *key = [NSString stringWithFormat:@"%@|%@", left ?: @"", right ?: @""];
    ratios[key] = @(ratio);
    SCPSetObjectForKey(@"splitScreenPairRatios", ratios);
}

// VERIFIED: stored double; the body returns 0.5 when the stored value is 0
// (fmov 0.5 fallback in the disassembly).
+ (double)splitRatio {
    double v = [SCPObjectForKey(@"splitScreenSplitRatio") doubleValue];
    return v > 0 ? v : 0.5;
}
+ (void)setSplitRatio:(double)ratio { SCPSetObjectForKey(@"splitScreenSplitRatio", @(ratio)); }

// INFERRED (bodies not individually read; same one-key accessor pattern as
// the verified methods above — keys live in the Core prefs namespace).
+ (NSInteger)splitDirection { return [SCPObjectForKey(@"splitScreenDirection") integerValue]; }
+ (NSInteger)paneOrientation { return [SCPObjectForKey(@"splitScreenPaneOrientation") integerValue]; }

// VERIFIED (full body read, dump disasm/SCPPrefs_favorite_.txt @0x4e138;
// metadata IMP 0x4e108): key scheme splitScreenFav%ld%@ with parts
// Left/Right/Third/Name read via sub_4dcf4 (SCPStringForKey) and Layout
// via sub_4dab8 (SCPObjectForKey) + integerValue. The returned dictionary
// shape is {name, left?, right?, third?, layout} — built as an
// NSMutableDictionary seeded with dictionaryWithObject:forKey:@"name"
// (0x4e374), slot keys added by setObject:forKeyedSubscript: ONLY when the
// stored string is non-nil (0x4e384/0x4e39c/0x4e3b4), and @"layout" set
// unconditionally last (0x4e3e8). There is NO @"apps" key.
// Layout validation (0x4e270-0x4e2b0): cmp layout,#0x1f / b.hi, then
// (1<<layout) & 0x80002008 — only layouts 3, 13, 31 pass; any other value
// (including a stored 2) forces layout = 2 and DISCARDS third before the
// empty test. Returns nil when left/right/third are all nil (0x4e290).
// A missing Name falls back to stringWithFormat:@"%@ %ld" over
// _OMCTr(@"Bố cục", @"Layout") and the index (0x4e304-0x4e344).
+ (NSDictionary *)favorite:(NSInteger)index {
    NSString *left  = SCPStringForKey([NSString stringWithFormat:@"splitScreenFav%ld%@", (long)index, @"Left"]);
    NSString *right = SCPStringForKey([NSString stringWithFormat:@"splitScreenFav%ld%@", (long)index, @"Right"]);
    NSString *third = SCPStringForKey([NSString stringWithFormat:@"splitScreenFav%ld%@", (long)index, @"Third"]);
    NSInteger layout = [SCPObjectForKey([NSString stringWithFormat:@"splitScreenFav%ld%@", (long)index, @"Layout"]) integerValue];
    if (layout < 0 || layout > 31 || ((1LL << layout) & 0x80002008) == 0) {
        third = nil;
        layout = 2;
    }
    if (!left && !right && !third) return nil;
    NSString *name = SCPStringForKey([NSString stringWithFormat:@"splitScreenFav%ld%@", (long)index, @"Name"]);
    if (!name) name = [NSString stringWithFormat:@"%@ %ld", OMCTr(@"Bố cục", @"Layout"), (long)index];
    NSMutableDictionary *fav = [NSMutableDictionary dictionaryWithObject:name forKey:@"name"];
    if (left)  fav[@"left"]  = left;
    if (right) fav[@"right"] = right;
    if (third) fav[@"third"] = third;
    fav[@"layout"] = @(layout);
    return fav;
}
// NOTE: the binary SCPPrefs has NO +favoriteApps: method (absent from the
// class's method list). The apps extraction lives in
// -[SCPCarSplit favoriteApps:] (IMP 0x3a86c), which takes the favorite
// DICTIONARY and walks the slot keys at __DATA 0x80518 (@"left", @"right",
// @"third") up to the layout's box count, keeping CarPlay apps and
// padding with NSNull. The former reconstruction here (reading a
// fabricated @"apps" key) was removed; the SplitScreen-side callers are
// flagged in PrefsB_REPORT.md's final-closure addendum.

// INFERRED one-key accessors (pattern identical to verified ones).
+ (BOOL)showRecent { return [SCPObjectForKey(@"splitScreenShowRecent") boolValue]; }
+ (BOOL)showFavorites { return [SCPObjectForKey(@"splitScreenShowFavorites") boolValue]; }
+ (BOOL)english { return [SCPObjectForKey(@"splitScreenEnglish") boolValue]; }
+ (NSInteger)tipCount { return [SCPObjectForKey(@"splitScreenTipCount") integerValue]; }
+ (void)setTipCount:(NSInteger)count { SCPSetObjectForKey(@"splitScreenTipCount", @(count)); }

@end
