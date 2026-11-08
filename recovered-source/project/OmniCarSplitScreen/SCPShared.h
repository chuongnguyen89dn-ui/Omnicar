// SCPShared.h — OmniCarSplitScreen (agent A half: scene hosting & lifecycle)
// Shared declarations: private CarPlay classes (resolved by name at runtime),
// file-static helpers proven in the binary, and cross-module externs.
//
// Evidence tags: // VERIFIED = read in disassembly; // INFERRED = labelled guess
// with the disassembly fact behind it, also listed in SplitScreenA_REPORT.md.

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

// ---------------------------------------------------------------------------
// Private CarPlay / SpringBoard classes. None of these are linked; every use
// goes through OMCCarClass()/objc_getClass() + respondsToSelector: guards, or
// through the MSHookMessageEx replacements in SCPHooks.m. Declared here as
// opaque interfaces so the reconstructed source type-checks standalone.
// ---------------------------------------------------------------------------
@interface DBApplicationInfo : NSObject            // CarPlay framework
@property (nonatomic, readonly, nullable) NSString *bundleIdentifier;
@end
@interface DBApplicationLaunchInfo : NSObject      // CarPlay framework
+ (nullable id)launchInfoForApplication:(nullable id)app;
+ (nullable id)launchInfoForApplication:(nullable id)app withActivationSettings:(nullable id)settings;
@end
@interface DBDashboard : NSObject                  // CarPlay framework
@end
@interface DBDashboardRootViewController : UIViewController // CarPlay framework
@end
@interface DBDashboardHomeViewController : UIViewController // CarPlay framework
@end
@interface DBApplicationSceneViewController : UIViewController // CarPlay framework
- (void)backgroundSceneWithCompletion:(nullable void (^)(void))completion;
- (void)deactivateSceneWithReasonMask:(unsigned long long)mask;
- (void)sceneManager:(nullable id)manager didDestroyScene:(nullable id)scene;
@end
@interface DBEvent : NSObject                      // CarPlay framework
+ (nullable id)eventWithType:(NSInteger)type context:(nullable id)context;
@end
@interface FBSDisplayLayoutPublisher : NSObject    // FrontBoardServices
- (void)addElement:(nullable id)element;
@end

// ---------------------------------------------------------------------------
// OMC shared infrastructure (defined in OmniCarCore / this binary's OMC* C
// functions; reconstructed by the Core agent — declared here as externs).
// ---------------------------------------------------------------------------
#ifdef __cplusplus
extern "C" {
#endif
Class _Nullable OMCCarClass(const char *name);              // 0x502fc VERIFIED call sites
BOOL OMCFeatureEnabled(NSString *feature);                  // 0x4f608
BOOL OMCEnabled(void);                                      // 0x4f5ac
id _Nullable OMCPref(NSString *key, id _Nullable defaultValue);                 // 0x4f544
void OMCPrefsSync(void);                                    // 0x4f538
BOOL OMCCrashGuard(NSString *feature);                      // 0x50e24 (NO -> abort install)
void OMCLogWrite(NSString *tag, NSString *message);         // 0x4fbf4
void OMCCheckHooks(NSString *tag, NSArray<NSString *> *names); // 0x50444
NSString *OMCTr(NSString *key, NSString *fallback);         // 0x558fc localisation
id _Nullable OMCCarLaunchInfo(id _Nullable appInfo);       // 0x50d14 (application-info OBJECT from SCPApplicationInfoForBundle — NOT a bundle ID string)
void SCPMissingSelector(id obj, NSString *selectorName);    // 0x4f330 logs a missing private selector (2nd arg is the selector NAME: call sites load the cfstring into x1, e.g. 0x4e6c)
// [phase2 closure; backported to src in phase 3] helpers A/C declared as
// "extern placeholders for the coordinator to reconcile"
// (SplitScreenA_REPORT §5) — bodies transcribed from the binary dumps in
// SCPShared.m (marked section at file end).
BOOL SCPInfoBool(id _Nullable info, NSString *key);                 // 0x17d84
BOOL SCPAppHasCarPlayUI(id _Nullable appInfo);                      // 0xffb4
BOOL SCPLayoutElementKey(id element, NSString *candidate);          // 0x8350 (predicate — see SCPShared.m note)
BOOL SCPResetDetachedView(UIView *view, NSInteger depth);           // 0x1a1b8
UIImage * _Nullable SCPAppIconForBundle(NSString *bundleID);        // 0xdec8

// Home-grid / app-icon injection family — reconstructed by SplitScreen-C.
// Spellings per the binary symtab (_SCP* = single-underscore Mach-O symbol;
// the C identifier has NO leading underscore). Phase-2 seam fix: A's first
// declarations carried a literal extra underscore (producing __SCP* symbols
// that exist nowhere) and three signatures were wrong; the corrected
// signatures below are proven from the bodies and call sites (see report).
NSSet<NSString *> *SCPChosenPhoneApps(void);                // 0x9a60
BOOL SCPIsInjectedPhoneApp(NSString *bundleID);             // 0x9980
BOOL SCPAppIconsBeginInjection(void);                       // 0xc37c (BOOL: the 0x4af0 caller tests w0 at 0x4b40)
void SCPAddChosenAppsToLibrary(id library);                 // 0xa500
void SCPInjectDeclarationIfChosen(id appInfo);              // 0x9b34
void SCPSetHomeViewController(id vc);                       // 0xaa00
void SCPHomeSetVisible(BOOL visible);                       // 0x4b4bc (ONE BOOL arg: callers at 0x4d3c/0x4da8 set only w0)
void SCPHomeRefresh(void);                                  // 0x4b598
void SCPRefreshAppIconsSoon(void);                          // 0xaa10
void SCPRefreshHiddenAppsSoon(void);                        // 0xc008
void SCPAppIconsCarScreenOK(void);                          // 0xc570 (void: the body sets no return value)
void SCPDumpAppLibraryOnce(void);                           // 0xc624
NSString *_Nullable SCPRealBundleForInfos(id _Nullable appInfo, id _Nullable proxyInfo); // 0xd950
void SCPHomeApply(id homeVC);                               // 0x4a6d8 (SplitScreen-C, SCPHomeApply.m)
#ifdef __cplusplus
}
#endif

// ---------------------------------------------------------------------------
// File-static helpers of the SplitScreen module (proven in this binary).
// ---------------------------------------------------------------------------
// sub_12efc VERIFIED: dispatch_after on the main queue when delay > 0,
// dispatch_async otherwise (wraps the block in trampoline sub_46814).
void SCPDispatchAfter(double delaySeconds, void (^block)(void));
// sub_12658 VERIFIED: [SCPDashboardObject() rootViewController] (guarded).
id _Nullable SCPDashboardRootViewController(void);
// sub_e5b4 VERIFIED: [[UIApplication sharedApplication] _currentDashboard]
// (respondsToSelector:-guarded, SCPMissingSelector fallback). The result is
// the DBDashboard object: event sink (handleEvent:) and workspaceOwner source.
id _Nullable SCPDashboardObject(void);
// sub_162ac VERIFIED: +[DBEvent eventWithType:context:] delivered to
// [SCPDashboardObject() handleEvent:]. Type 1 = "go home" (context is a log
// string), type 4 = launch (context is a DBApplicationLaunchInfo).
void SCPSendDashboardEvent(NSInteger type, id _Nullable context);
// sub_75cc VERIFIED: @catch handler used by nearly every hook/method:
// OMCLogWrite(@"SplitScreen", "LOI trong %s: %@\n%@", where, ex, callStack).
void SCPExceptionLog(const char *where, NSException *exception);
// sub_e324 VERIFIED: applicationInfoForBundleIdentifier: (guarded) on
// the FBSApplicationLibrary from sub_4672c ([UIApplication
// sharedApplication] -> sharedApplicationLibrary); nil when not
// installed. (Not LSApplicationWorkspace — see SCPShared.m.)
id _Nullable SCPApplicationInfoForBundle(NSString *bundleID);
// sub_101bc VERIFIED: YES when the app must be hosted through AppBridge:
// feature "appBridge" enabled AND (injected phone app OR (NOT a real
// CarPlay app per sub_ffb4 AND listed in the sub_48864 chosen set)).
// No nil-info gate: an app with no info still reaches the set test.
BOOL SCPIsHostedApp(NSString *bundleID);
// sub_14fa4 VERIFIED: [vc isKindOfClass:[SCPHostedAppVC class]] — used in
// openApp:/adopt:slot:/hostApp:/removePaneAt: to pick hostClose vs detachVC.
BOOL SCPVCIsHosted(id _Nullable vc);
// sub_1ab70 VERIFIED (final closure): scene accessor for a VC — KVC-probes
// @"scene" then @"_scene", then falls back to the @"sceneHandle" object's
// own @"scene" (exception-guarded; see SCPShared.m). sub_1b13c VERIFIED
// (micro-closure): despite the historical "OfVC" name, the binary's only
// call sites pass a scene object directly (the destroyed scene and the
// ownScene argument in -scene:destroyedForViewController:ownScene:). It
// returns that object's guarded @"identifier" value; it does NOT call
// SCPSceneOfVC or perform a VC/scene walk.
id _Nullable SCPSceneOfVC(id vc);
NSString *_Nullable SCPSceneIdentifierOfVC(id scene);

// Distributed-notification names (NSDistributedNotificationCenter).
// Every name below is VERIFIED by string xref in the binary.
extern NSString * const SCPNotePrefsChanged;        // com.anlai.omnicar/prefschanged (Darwin notify_register_dispatch, CarPlayApp)
extern NSString * const SCPNoteNativeCommand;       // com.anlai.omnicar/splitscreen.native
extern NSString * const SCPNoteNativeAck;           // com.anlai.omnicar/splitscreen.ack
extern NSString * const SCPNoteScreenReady;         // com.anlai.omnicar/splitscreen.ready
extern NSString * const SCPNoteKillApp;             // com.anlai.omnicar/splitscreen.kill
extern NSString * const SCPNoteURL;                 // com.anlai.omnicar/url
extern NSString * const SCPNoteBridgeOpen;          // com.anlai.omnicar/appbridge.open
extern NSString * const SCPNoteBridgeClose;         // com.anlai.omnicar/appbridge.close
extern NSString * const SCPNoteBridgeCloseAll;      // com.anlai.omnicar/appbridge.closeall
extern NSString * const SCPNoteBridgeFrame;         // com.anlai.omnicar/appbridge.frame
extern NSString * const SCPNoteBridgeState;         // com.anlai.omnicar/appbridge.state
extern NSString * const SCPNoteBridgeShield;        // com.anlai.omnicar/appbridge.shield
extern NSString * const SCPNoteBridgeKnobs;         // com.anlai.omnicar/appbridge.knobs
extern NSString * const SCPNoteBridgeHandleTap;     // com.anlai.omnicar/appbridge.handletap
extern NSString * const SCPNoteBridgeHandleDrag;    // com.anlai.omnicar/appbridge.handledrag
extern NSString * const SCPNoteBridgeBarAction;     // com.anlai.omnicar/appbridge.baraction
extern NSString * const SCPNoteBridgeBarDismiss;    // com.anlai.omnicar/appbridge.bardismiss
extern NSString * const SCPNoteBridgeKnobTouch;     // com.anlai.omnicar/appbridge.knobtouch

NS_ASSUME_NONNULL_END
