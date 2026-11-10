// SCPPrefs.h — OmniCarSplitScreen (agent A)
// The SplitScreen preference store. VERIFIED from disassembly: a stateless
// class with +methods only; every value lives in the shared OMC preferences
// (suite com.anlai.omnicar) behind three file-static accessors of the OMC
// layer: sub_4dab8 (object for key), sub_4dcf4 (string for key),
// sub_4db84 (set string for key), sub_4ec70 (set object for key) — thin
// wrappers over OMCPref()/CFPreferences in the Core module.

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SCPPrefs : NSObject

+ (BOOL)enabled;                                  // OMCFeatureEnabled(@"splitScreen") after OMCPrefsSync()
+ (nullable NSString *)lastLeftApp;               // key splitScreenLastLeft
+ (nullable NSString *)lastRightApp;              // key splitScreenLastRight
+ (void)setLastPairLeft:(nullable NSString *)left right:(nullable NSString *)right;
+ (BOOL)autoLaunch;                               // key splitScreenAutoLaunch (boolValue)
+ (nullable NSArray<NSString *> *)carPlayApps;    // key splitScreenCarPlayApps
+ (void)setCarPlayApps:(nullable NSArray<NSString *> *)apps;
+ (NSArray<NSDictionary *> *)recentLayouts;       // key splitScreenRecentLayouts, entries {layout:@(n), apps:[...]}
+ (void)addRecentLayout:(NSInteger)layout apps:(NSArray<NSString *> *)apps;
+ (double)ratioForPairLeft:(nullable NSString *)left right:(nullable NSString *)right; // key splitScreenPairRatios
+ (void)setRatio:(double)ratio forPairLeft:(nullable NSString *)left right:(nullable NSString *)right;
+ (double)splitRatio;                             // key splitScreenSplitRatio, default 0.5
+ (void)setSplitRatio:(double)ratio;
+ (NSInteger)splitDirection;                      // OMC pref (key in Core layer)
+ (NSInteger)paneOrientation;                     // OMC pref (key in Core layer)
+ (nullable NSDictionary *)favorite:(NSInteger)index; // keys splitScreenFav%ld{Left,Right,Third,Layout,Name}; returns {name, left?, right?, third?, layout}
// (no +favoriteApps: in the binary — apps extraction is -[SCPCarSplit favoriteApps:] on the dictionary)
+ (BOOL)showRecent;
+ (BOOL)showFavorites;
+ (BOOL)english;
+ (NSInteger)tipCount;
+ (void)setTipCount:(NSInteger)count;
+ (BOOL)pickerSheetClearFaceOff; // [hl5-picker] rollback gate: YES restores the picker's original opaque sheet face

@end

NS_ASSUME_NONNULL_END
