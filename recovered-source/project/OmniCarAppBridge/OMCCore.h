// OMCCore.h — shared "core-lite" helpers compiled into OmniCarAppBridge.dylib
// (an identical copy of this unit ships inside every OmniCar dylib).
//
// Reconstruction: AppBridge module agent A, from arm64 disassembly of
// OmniCarAppBridge.dylib (UUID 81EF5920-BB7A-37E8-B953-D88453F2EA89).
// Every claim below is backed by the disassembly in ../disasm/; see
// AppBridgeA_REPORT.md for the per-function evidence table and statuses.
//
// NOTE (tooling): the wave-1 metadata parser mislabels chained-fixup bind
// targets by one import for this binary; all names here use the corrected
// mapping (see report §2).

#import <Foundation/Foundation.h>

#ifdef __cplusplus
extern "C" {
#endif

// ---------------------------------------------------------------------------
// Preferences. Domain is ALWAYS CFSTR("com.anlai.omnicar") accessed through
// CFPreferencesCopyAppValue / CFPreferencesSetAppValue /
// CFPreferencesAppSynchronize (i.e. the cfprefsd "current user, any host"
// view of the com.anlai.omnicar domain). PROVEN by xref in _OMCPref
// (0x1d680), _OMCPrefsSync (0x1d674) and dozens of call sites.
// ---------------------------------------------------------------------------

/// OMCPref(key, default): CFPreferencesCopyAppValue(key, "com.anlai.omnicar")
/// or `defaultValue` when the key is absent. Returned autoreleased.
id OMCPref(NSString *key, id defaultValue);

/// OMCPrefsSync(): CFPreferencesAppSynchronize("com.anlai.omnicar").
void OMCPrefsSync(void);

/// OMCEnabled(): NO when OMCExpired(), else [OMCPref(@"enabled", @NO) boolValue].
BOOL OMCEnabled(void);

/// OMCFeatureEnabled(name): OMCEnabled() &&
/// [OMCPref([name stringByAppendingString:@"Enabled"], @NO) boolValue].
/// So feature "appBridge" is gated by pref keys "enabled" + "appBridgeEnabled".
BOOL OMCFeatureEnabled(NSString *featureName);

/// OMCExpired(): YES once the current time passes the build expiry
/// (string "2027-04-30" in the binary); a persisted "trustedTime" pref is
/// consulted so rolling the clock back does not revive the build.
/// (Exact combination of the two timestamps: INFERRED, see report.)
BOOL OMCExpired(void);

/// OMCLiteActive(): "lite mode" state. Driven by integer pref "liteMode"
/// (1 = automatic: thermal state via NSProcessInfo.thermalState participates;
/// other values force on/off) OR-ed with the Darwin notification state of
/// "com.anlai.omnicar/lite" (notify_register_check/notify_get_state).
/// (Branch detail: INFERRED, see report.)
BOOL OMCLiteActive(void);

/// OMCCarWireless(): reads the "diagCar" pref dictionary (written by the car
/// session watcher, sub_214cc) and reports whether the CarPlay transport is
/// wireless ("wifi"/"wi-fi" vs "wired"/"usb"). (INFERRED detail.)
BOOL OMCCarWireless(void);

// ---------------------------------------------------------------------------
// Private-class compatibility layer (DashBoard framework renames across iOS).
// ---------------------------------------------------------------------------

/// OMCCarClass(name): objc_getClass(name); if missing and name is
/// "DashBoard" -> objc_getClass("CARApplication"); if missing and name has
/// prefix "DB" -> try "CAR"+rest, then "_CAR"+rest. Returns nil if all fail.
Class OMCCarClass(const char *name);

/// OMCHasMethod(className, methodName): methodName prefixed "+" checks a
/// class method, otherwise an instance method, on OMCCarClass(className).
BOOL OMCHasMethod(const char *className, NSString *methodName);

/// OMCCheckHooks(module, specs): diagnostics. Each spec is
/// "ClassName -selector:" / "ClassName +selector:" (split on a single space).
/// For every spec: resolve the class via OMCCarClass; if the runtime class
/// name differs from the requested name, record "requested=actual" in a
/// renamed set (logged as "iOS %@: lop CarPlay %@ ..."); if the method is
/// missing (OMCHasMethod), append the spec to a missing array. Merges
/// {ios: systemVersion, total: += specs.count, missing: [...]} into the
/// dictionary stored under pref key "diagHooks.<module>" in
/// com.anlai.omnicar and synchronizes. (Merge-key construction INFERRED.)
void OMCCheckHooks(NSString *module, NSArray<NSString *> *specs);

/// OMCMissingSelector / ABMissingSelector: dedup-logging helpers called when
/// a private selector is absent ("THIEU METHOD"-style diagnostics); they
/// record "Class selector" strings in a static set and log once per entry.
/// (ABMissingSelector @ 0x9698 is the AppBridge-local copy.)
void ABMissingSelector(id object, NSString *selectorName);

/// OMCCarLaunchInfo(app): the DashBoard launch-info factory.
///   Class c = OMCCarClass("DBApplicationLaunchInfo");
///   if ([c respondsToSelector:@selector(launchInfoForApplication:)])
///       return [c launchInfoForApplication:app];
///   if ([c respondsToSelector:@selector(launchInfoForApplication:withActivationSettings:)])
///       return [c launchInfoForApplication:app withActivationSettings:nil];
///   logs "THIEU METHOD: %@ khong tao duoc launchInfo" (module "Core");
///   return nil.
/// Exported from this dylib; NO direct caller inside AppBridge was found
/// (see report — it is part of the shared core used by sibling modules).
id OMCCarLaunchInfo(id app);

/// OMCCrashGuard(feature): rescue mode. One-time init installs a crash
/// marker (setenv("OMC_CRASHGUARD", hex-time)), tracks early CarPlay crashes
/// in tmp/OmniCar-CarPlay-crash.txt + OmniCar-crashguard.plist
/// ({early: count, suspects: [...]}). When a feature is implicated by
/// repeated early crashes it is disabled and
/// "%@ dang tat boi che do cuu (tu %@): khong cai hook trong CarPlay" is
/// logged; "%@ bat lai sau che do cuu" when it is re-enabled.
/// (Full state machine: INFERRED from the 0x1ef60-0x205c8 unit, see report.)
BOOL OMCCrashGuard(NSString *feature);

/// OMCLogWrite(module, message): appends "[OmniCar/<module>] <message>" to
/// /var/mobile/Documents/OmniCar.log and relays over the Darwin
/// "com.anlai.omnicar/log" channel. (Body in the 0x1d9cc unit; declared here
/// because every A-scope function uses it.)
void OMCLogWrite(NSString *module, NSString *message);

/// OMCTr(key): localized string from
/// /Library/PreferenceBundles/OmniCarPrefs.bundle, "%@/%@.lproj/Car.strings"
/// for OMCCurrentLanguage(). Used for the handle-menu titles (hm_* keys).
NSString *OMCTr(NSString *key);

#ifdef __cplusplus
}
#endif
