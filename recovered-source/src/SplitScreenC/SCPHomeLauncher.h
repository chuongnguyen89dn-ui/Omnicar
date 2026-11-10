// SCPHomeLauncher.h — the OWN OmniCar icon on genuine CarPlay Home.
//
// Separate from the appBridgeApps-selected phone-app publisher.
// Routes tap to the EXISTING split layout panel, never to iPhone Settings.
#import <Foundation/Foundation.h>
NS_ASSUME_NONNULL_BEGIN
NSString *SCPHomeLauncherBundleIdentifier(void);
BOOL SCPHomeLauncherIsBundle(NSString * _Nullable bid);
BOOL SCPHomeLauncherIsOwnIcon(id _Nullable icon);
BOOL SCPHomeLauncherEnabled(void);
BOOL SCPHomeLauncherEnsureInLibrary(id _Nullable library);
void SCPHomeLauncherInjectInfo(id _Nullable info);
BOOL SCPHomeLauncherConsumeLaunch(NSString * _Nullable bid, NSString *source);
void SCPHomeLauncherReconcile(NSString *reason);
void SCPHomeLauncherAuditModel(NSString *reason);
void SCPHomeLauncherDockSetVisible(BOOL presented, NSString *reason); // [hl12dock]
void SCPHomeLauncherDockHostedReady(NSString * _Nullable bid, NSString *reason); // [hl14-dockapps]
void SCPHomeLauncherInstallTapHook(void); // ABI-validated native Home callback
NS_ASSUME_NONNULL_END
