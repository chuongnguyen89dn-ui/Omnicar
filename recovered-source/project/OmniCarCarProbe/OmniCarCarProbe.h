// OmniCarCarProbe.h
// Reconstructed header for OmniCarCarProbe.dylib (OmniCar 1.0.3, arm64 slice,
// UUID 60EABE81-28C1-328C-8B03-53AAC26BC7E0).
//
// Reconstruction status: see CarProbe_REPORT.md. Function bodies in
// OmniCarCarProbe.m are labelled VERIFIED / INFERRED per function there.
//
// This dylib contains NO Objective-C classes. It is the shared OMCCommon
// translation unit (statically embedded in every OmniCar module) linked into
// a dylib whose substrate filter loads it into CarPlayApp only. Its 20
// exports are exactly the OMCCommon API surface.

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

// ---------------------------------------------------------------------------
// Preferences (domain "com.anlai.omnicar")
// ---------------------------------------------------------------------------

/// CFPreferencesAppSynchronize(@"com.anlai.omnicar")
void OMCPrefsSync(void);

/// CFPreferencesCopyAppValue(key, domain) ?: fallback (returned autoreleased).
id _Nullable OMCPref(NSString *key, id _Nullable defaultValue);

/// !OMCExpired() && OMCPref(@"enabled", @YES).boolValue
BOOL OMCEnabled(void);

/// OMCEnabled() && OMCPref(feature + @"Enabled", @YES).boolValue
BOOL OMCFeatureEnabled(NSString *feature);

/// Hard expiry check. Expiry instant is compiled in: the date string
/// "2027-04-30" parsed as GMT+7 midnight plus 86400 s. The comparison uses
/// max(now, persisted "trustedTime" pref) so clock rollback cannot extend it.
BOOL OMCExpired(void);

/// Lite mode state. Mode pref "liteMode" (default @2 = auto, INFERRED):
/// 0 = off, 1 = forced on (still gated by OMCEnabled), 2 = auto
/// (thermalState >= 2, or the Darwin state of "com.anlai.omnicar/lite").
/// Result is cached for 3 s.
BOOL OMCLiteActive(void);

// ---------------------------------------------------------------------------
// Localisation
// ---------------------------------------------------------------------------

/// The 14 supported language ids:
/// vi en es pt-BR de fr it ru zh-Hans ja ko ar th id
NSArray<NSString *> *OMCSupportedLanguages(void);

/// Pref "language" if valid, else best match against
/// [NSLocale preferredLanguages] (exact, "sup-" prefix, or base-language
/// match — base match is skipped for zh), else @"en".
NSString *OMCCurrentLanguage(void);

/// Translation helper: vi -> first argument; en -> second argument;
/// otherwise looks the English string up in
/// <OmniCarPrefs.bundle>/<lang>.lproj/Car.strings (cached per language).
NSString *OMCTr(NSString *vi, NSString *en);

// ---------------------------------------------------------------------------
// Logging
// ---------------------------------------------------------------------------

/// NSLog(@"[OmniCar/%@] %@", tag, msg) + timestamped line
/// "%@ [%@:%d] %@: %@\n" appended (on a serial queue) to
/// /var/mobile/Documents/OmniCar.log. Also stamps the crash-session
/// "last module" field with this dylib's name ("CarProbe").
/// In non-SpringBoard processes a failed file write falls back to posting
/// the line via NSDistributedNotificationCenter ("com.anlai.omnicar/log");
/// SpringBoard collects those lines (see OMCLogRelayStart).
void OMCLogWrite(NSString *tag, NSString *msg);

/// SpringBoard only: start collecting relayed log lines from other
/// processes and appending them to the shared log file.
void OMCLogRelayStart(void);

// ---------------------------------------------------------------------------
// Crash guard (per-process, shared by all OMCCommon copies via environment)
// ---------------------------------------------------------------------------

/// Crash-loop rescue gate. In CarPlayApp: first caller (across all OmniCar
/// dylibs in the process) creates the shared crash session, reads the
/// leftover crash report (NSTemporaryDirectory()/OmniCar-CarPlay-crash.txt),
/// counts early crashes in NSTemporaryDirectory()/OmniCar-crashguard.plist,
/// and on a repeated early crash disables the suspected features
/// (pref <feature>Enabled = NO, prefs "rescueFeatures"/"rescueDate",
/// Darwin posts "com.anlai.omnicar/rescue" + "com.anlai.omnicar/prefschanged"),
/// then installs the exception/signal handlers and screen observers and
/// schedules the connect probe (+4 s).
/// Returns NO when this feature was rescue-disabled and is still off.
BOOL OMCCrashGuard(NSString *feature);

// ---------------------------------------------------------------------------
// CarPlay-runtime introspection helpers (used by the feature modules)
// ---------------------------------------------------------------------------

/// objc_getClass with CarPlay name mapping: "DashBoard" -> CARApplication;
/// "DB..." -> "CAR..." then "_CAR...".
Class _Nullable OMCCarClass(const char *name);

/// YES if the (mapped) class implements the selector; a leading "+"
/// in selName selects a class method.
BOOL OMCHasMethod(const char *className, NSString *selName);

/// Logs "THIEU METHOD (iOS %@): %@ -> bo qua" once per (class, selector).
void OMCMissingSelector(NSString *tag, Class cls, NSString *selName);

/// Verifies a list of "ClassName selector" specs against the live runtime,
/// records renames/missing hooks into pref "diagHooks.<module>@<processName>"
/// and logs a per-iOS summary.
void OMCCheckHooks(NSString *module, NSArray<NSString *> *specs);

/// [DBApplicationLaunchInfo launchInfoForApplication:...] via runtime lookup.
id _Nullable OMCCarLaunchInfo(id appInfo);

/// -1 unknown / 0 wired / 1 wireless, derived by scanning the "diagCar"
/// pref's session/configuration dictionaries for wireless/wired/transport
/// keys and values.
int OMCCarWireless(void);

// ---------------------------------------------------------------------------
// Per-car profiles
// ---------------------------------------------------------------------------

/// The 14 pref keys captured/restored per car profile:
/// splitScreenLastLeft, splitScreenLastRight, splitScreenSplitRatio,
/// splitScreenSplitDirection, splitScreenPaneOrientation,
/// splitScreenAutoLaunch, splitScreenPinnedApp, speedBubbleSizeCar,
/// speedBubbleLook, startupScreenVideoName, startupScreenStyle,
/// startupScreenCarName, startupScreenTempo, appBridgeZoom.
NSArray<NSString *> *OMCProfileKeys(void);

// ---------------------------------------------------------------------------
// Logo mesh image
// ---------------------------------------------------------------------------

/// 96x96 pastel mesh-gradient image, rendered once per variant
/// (0 = translucent background, 1 = opaque) and cached.
UIImage *OMCLogoMeshImage(int variant);

NS_ASSUME_NONNULL_END
