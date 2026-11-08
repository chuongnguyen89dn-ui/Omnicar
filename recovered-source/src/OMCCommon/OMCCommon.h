// OMCCommon.h — reconstructed shared core of OmniCar 1.0.3 (com.anlai.omnicar)
//
// This header + OMCCommon.c reconstruct the 20-function OMC* C core that is
// statically embedded, function-for-function, in every OmniCar dylib
// (OmniCarCore, OmniCarSplitScreen, OmniCarAppBridge, OmniCarSpeedBubble,
// OmniCarStartupScreen, OmniCarCarProbe). Cross-binary comparison (normalized
// instruction streams) shows 19 of the 20 shared functions are identical in
// all six binaries; the single exception is OMCLogWrite (see OMCCommon.c).
// _OMCTrustedTimeStart exists ONLY in OmniCarCore.dylib and is reconstructed
// in OmniCarCore.c.
//
// The original is Objective-C compiled with ARC (objc_retain /
// objc_retainAutoreleasedReturnValue patterns throughout the machine code).
// Compile these files as Objective-C (.m, or -x objective-c) with ARC.
//
// Evidence status per function is documented in OMCCommon_REPORT.md.
// Addresses cited are VAs in OmniCarCore.dylib's arm64 slice.
//
// Reconstruction by disassembly (capstone) of the original 1.0.3 DEB
// (SHA256 d9297b010cdc08e401439b7332413f79cb1a056a05159a5deb673e218d76d9fd).

#ifndef OMC_COMMON_H
#define OMC_COMMON_H

#import <Foundation/Foundation.h>
#import <CoreFoundation/CoreFoundation.h>
#import <stdbool.h>

#ifdef __cplusplus
extern "C" {
#endif

// Preference domain used for EVERY CFPreferences call in the core.
// Verified: the same CFSTR("com.anlai.omnicar") is materialised at the head
// of _OMCPrefsSync (0x6528) and passed by every helper.
extern CFStringRef const kOMCPrefsDomain; // = CFSTR("com.anlai.omnicar")

// Darwin / distributed notification names (all verified as string literals
// at their registration / post sites).
//   "com.anlai.omnicar/prefschanged"  notify_post — prefs changed
//   "com.anlai.omnicar/rescue"        notify — rescue mode entered / announce
//   "com.anlai.omnicar/car.connected" notify — CarPlay screen connected
//   "com.anlai.omnicar/cleanram.now"  notify — run the clean/classify pass now
//   "com.anlai.omnicar/lite"          notify state — lite mode on/off (uint64)
//   "com.anlai.omnicar/log"           NSDistributedNotification — log relay
//   "com.anlai.omnicar/url"           NSDistributedNotification — omnicar:// URL

#pragma mark - Preferences (VERIFIED)

// Tail-calls CFPreferencesAppSynchronize(CFSTR("com.anlai.omnicar")).
void OMCPrefsSync(void);

// Returns CFPreferencesCopyAppValue(key, domain) if non-nil, else `def`.
// No caching: hits CFPreferences on every call. Return is autoreleased (ARC).
id OMCPref(id key, id def);

#pragma mark - Master / feature switches (VERIFIED)

// Master switch: NO if OMCExpired(), else [OMCPref(@"enabled", @YES) boolValue].
BOOL OMCEnabled(void);

// NO if !OMCEnabled(); else reads pref "<feature>Enabled" (feature name with
// @"Enabled" appended), default YES.
BOOL OMCFeatureEnabled(NSString *feature);

#pragma mark - Free-period expiry (VERIFIED)

// Deadline: 2027-04-30 parsed as yyyy-MM-dd in GMT+7 (NSDateFormatter,
// en_US_POSIX), plus 86400 s  =>  deadline epoch 1809104400
// (2027-05-01 00:00:00 GMT+7). Computed once via dispatch_once.
// Effective "now" = max(wall clock, stored pref "trustedTime" if NSNumber),
// so rolling the device clock back cannot undo elapsed time; a monotonic
// network-fetched time is stored by OmniCarCore (see OmniCarCore.c).
// Fail-open: if no deadline could be computed (<= 0) returns NO forever.
// Once expired, a latch makes it sticky for the process lifetime.
BOOL OMCExpired(void);

#pragma mark - Lite mode (VERIFIED)

// Result is cached for 3.0 s (CFAbsoluteTimeGetCurrent throttle).
// Pref "liteMode" (default @2):
//   1 -> OMCEnabled()
//   2 -> NO if !OMCEnabled(); YES if thermalState >= NSProcessInfoThermalStateSerious;
//        else the Darwin notify state of "com.anlai.omnicar/lite" (!= 0)
//   anything else -> NO
BOOL OMCLiteActive(void);

// -1 unknown / 1 wireless / 0 wired, heuristically from the "diagCar" pref
// dictionary's "session" and "configuration" sections (see OMCCommon.c).
int OMCCarWireless(void);

#pragma mark - Logging (VERIFIED)

// Line format written to the log file:
//   "<yyyy-MM-dd HH:mm:ss.SSS> [<processName>:<pid>] <tag>: <msg>\n"
// Also echoed with NSLog(@"[OmniCar/%@] %@", tag, msg) — unconditionally,
// no preference gate. Appends happen on a serial queue
// ("com.anlai.omnicar.log"). File: /var/mobile/Documents/OmniCar.log
// (SpringBoard rotates it at >= 2 MiB to OmniCar.log.old; non-SpringBoard
// processes that cannot append forward the line to SpringBoard via the
// "com.anlai.omnicar/log" distributed notification).
//
// PER-MODULE VARIANT (verified): OmniCarCore's copy of this function is
// 424 bytes and does NOT stamp the crash state. The copy in the other five
// dylibs is 452 bytes and, when the crash-guard state exists, first does
//   strlcpy(state->lastFeature, "<ModuleName>", 64)
// with its own module name ("AppBridge", "SplitScreen", "SpeedBubble",
// "CarProbe", "StartupScreen"). Build those modules with
// -DOMC_MODULE_NAME='"<ModuleName>"' to reproduce the variant; OmniCarCore
// is built without it.
void OMCLogWrite(NSString *tag, NSString *msg);

// Only SpringBoard actually subscribes to the log-relay notification;
// in any other process this returns after the one-time init.
void OMCLogRelayStart(void);

#pragma mark - CarPlay class / selector resolution (VERIFIED)

// objc_getClass(name), with a rename fallback for CarPlay's DashBoard-era
// names: "DashBoard" -> "CARApplication"; "DB<Rest>" -> "CAR<Rest>", then
// "_CAR<Rest>". Returns nil if none resolve.
Class OMCCarClass(const char *name);

// selectorName with a leading "+" looks up a CLASS method (prefix stripped),
// otherwise an instance method, on OMCCarClass(className).
BOOL OMCHasMethod(const char *className, NSString *selectorName);

// Batch hook-availability audit; `specs` entries are "<Class> <-| +selector>".
// Writes a cumulative "diagHooks.<tag>@<processName>" pref entry
// (total / missing / ios) and logs renamed classes and missing hooks.
void OMCCheckHooks(NSString *tag, NSArray<NSString *> *specs);

// Logs "THIEU METHOD (iOS <ver>): <Class> <selector> -> bo qua" at most once
// per (class, selector) pair per process.
void OMCMissingSelector(NSString *tag, id object, NSString *selectorName);

// [DBApplicationLaunchInfo launchInfoForApplication:application], falling
// back to +launchInfoForApplication:withActivationSettings: (nil settings);
// logs via OMCLogWrite(@"Core", ...) and returns nil if neither exists.
id OMCCarLaunchInfo(id application);

#pragma mark - Crash guard (VERIFIED state machine; see OMCCommon.c)

// CarPlayApp-only feature gate driven by a persistent crash counter.
// Returns YES if the feature may install its hooks in CarPlayApp.
// Non-CarPlayApp processes always get YES. Behaviour summary:
//  - Installs an uncaught-exception handler + sigaction handlers for
//    {SIGSEGV, SIGBUS, SIGABRT, SIGILL, SIGTRAP, SIGFPE} that append
//    "omc-crash age=<s> suspect=<Feature> last=<Feature> how=<cause>" lines
//    to NSTemporaryDirectory()/OmniCar-CarPlay-crash.txt.
//  - On the next launch, crashes within the first 60 s of a session are
//    counted ("early" in NSTemporaryDirectory()/OmniCar-crashguard.plist).
//    On the 2nd consecutive early crash, rescue mode disables the suspect
//    features (writes "<feature>Enabled" = NO, records "rescueFeatures" and
//    "rescueDate" prefs, posts the rescue + prefschanged notifications).
//  - A feature still listed in "rescueFeatures" with its Enabled pref back
//    ON is un-rescued (removed from the list) and allowed again.
BOOL OMCCrashGuard(NSString *feature);

#pragma mark - Profile / language (VERIFIED)

// Constant 14-entry array of per-car profile preference keys.
NSArray<NSString *> *OMCProfileKeys(void);

// Constant 14-entry array: vi en es pt-BR de fr it ru zh-Hans ja ko ar th id
NSArray<NSString *> *OMCSupportedLanguages(void);

// Pref "language" if supported; else best match from
// [NSLocale preferredLanguages] (exact, then prefix, then base language,
// with zh handled specially); else @"en".
NSString *OMCCurrentLanguage(void);

// Two-language string picker: vi -> viText, en -> enText; any other
// supported language loads
//   <jbroot>/Library/PreferenceBundles/OmniCarPrefs.bundle/<lang>.lproj/Car.strings
// and looks the string up BY ITS ENGLISH TEXT (table[enText] ?: enText).
// Tables are cached per language. (There is no vi.lproj — vi is the source
// language; en.lproj exists but is never loaded due to the short-circuit.)
NSString *OMCTr(NSString *viText, NSString *enText);

#pragma mark - Logo (VERIFIED)

// 88x88 rendered mesh-gradient logo image, cached per style index
// (dispatch_once per slot; no bounds check in the original).
// style 0: translucent (alpha 0.95) on a light bluish fill, non-opaque;
// style 1: opaque variant. Four radial gradients from the corners with
// pastel stops (#D9F1A0, #D8C4FE, #FD DDA6, #FCBAC9) fading to transparent.
id OMCLogoMeshImage(int style);

#ifdef __cplusplus
}
#endif

#endif // OMC_COMMON_H
