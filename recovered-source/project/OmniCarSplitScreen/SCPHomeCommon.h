// SCPHomeCommon.h — SplitScreen-C: Home / app-icon injection family.
//
// Shared declarations for the reconstructed C function family that puts the
// user-chosen phone apps onto the CarPlay home grid in
// OmniCarSplitScreen.dylib (original 1.0.3). All functions here were
// reconstructed from the arm64 slice with capstone (see disasm/ and
// SplitScreenC_REPORT.md for the per-function evidence table).
//
// Boundary:
//  - The MSHookMessageEx INSTALLERS for every hook in this family live in
//    the constructor groups reconstructed by SplitScreen-A (__init_0 /
//    __init_1). This module owns the replacement bodies and every helper
//    that is exclusively theirs.
//  - SCPHomeWallView (the wallpaper view class) and SCPCarSplit are
//    SplitScreen-B / SplitScreen-A classes; this family only sends them
//    messages.
//  - OMC* functions and _SCPMissingSelector are the shared OMC core
//    (reconstructed by the OMCCommon/Core agent); declared extern here.

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <objc/runtime.h>

NS_ASSUME_NONNULL_BEGIN

// ---- OMC core (extern, shared with every OmniCar dylib) -------------------
extern id _Nullable OMCPref(NSString *key, id _Nullable dflt);          // 0x4f544
extern void OMCPrefsSync(void);                                         // 0x4f538
extern BOOL OMCEnabled(void);                                           // 0x4f5ac
extern BOOL OMCFeatureEnabled(NSString *feature);                       // 0x4f608
extern void OMCLogWrite(NSString *tag, NSString *message);              // 0x4fbf4
extern void SCPMissingSelector(id obj, NSString *selectorName);         // 0x4f330 (shared infra)

// ---- SplitScreen-A helpers used by this family (extern) -------------------
// sub_e324: builds a DBApplicationInfo/launch-info object for a bundle id.
extern id _Nullable SCPApplicationInfoForBundle(NSString *bundleId); // [phase2; backported to src in phase 3] 0xe324 — name unified to A's
// sub_ffb4: YES when the app info declares CarPlay UI (carPlayDeclaration).
extern BOOL SCPAppHasCarPlayUI(id appInfo);                             // 0xffb4 (A)

// ---- cross-file family symbols ----------------------------------------------
// Weak ref to the DBDashboardHomeViewController, stored by
// SCPSetHomeViewController (0xaa00) from A's initWithEnvironment: hook.
extern __weak id SCPHomeVCWeak;                                          // 0x880d0
extern __weak id SCPApplyHomeVCWeak;                                     // 0x881e0
extern BOOL SCPIsInjectedPhoneApp(NSString *_Nullable bundleId);         // 0x9980
extern void SCPHomeIconModelLayout(NSString *reason);                    // 0xbce4

// ---- Safe dynamic-access helpers (this family) ----------------------------
// @try { obj responds to selector named `name` ? [obj performSelector:] : nil } @catch -> nil
extern id _Nullable SCPHomeSafeGet(id _Nullable obj, NSString *name);   // 0xa26c
// @try { [obj valueForKey:name] } @catch -> nil
extern id _Nullable SCPHomeSafeKVCGet(id _Nullable obj, NSString *name);// 0xa32c
// @try { [obj setValue:value forKey:name]; YES } @catch { log; NO }
extern BOOL SCPHomeSafeSet(id obj, NSString *name, id _Nullable value); // 0xa3c4
// Same as SCPHomeSafeGet but the selector name arrives as an NSString object.
extern id _Nullable SCPHomeSafePerform(id _Nullable obj, NSString *name); // 0x4d8dc

// Local equivalent of the OMC pref setter (CFPreferences, domain
// com.anlai.omnicar; nil value removes the key). NOTE: SplitScreen-A
// references an extern "OMCPrefSet" (Core) with identical semantics —
// sub_c4f4 is a SplitScreen-local copy; see report §5.
extern void SCPHomePrefSet(NSString *key, id _Nullable value);          // 0xc4f4

// Exception logger shared by the home hook group (called from the @catch
// blocks of A-covered hooks 0x4af0/0x4bcc/0x4cb4/0x4d24/0x4d90/0x4f30 and
// from this family's isIconVisible hook).
extern void SCPLogException(const char *where, NSException *e);         // 0x5520

NS_ASSUME_NONNULL_END
