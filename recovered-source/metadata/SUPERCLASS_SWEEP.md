# SUPERCLASS_SWEEP — every @interface superclass in src/ vs binary truth

Produced by verifier #2 (wave 3), independently of all module agents.
Ground truth: superclass field (class struct +8) of every class in the
8 original binaries, decoded with the 0-based chained-fixups resolver
(verify/macho_truth.py). The table reproduces ANNOTATION_AUDIT.md's
addendum exactly for AppBridge/SpeedBubble/SplitScreen and extends it
to App (1), StartupScreen (8) and Prefs (29) — 66 classes total.

Declarations swept: **79** — MATCH 71, WRONG 0, EXTERNAL (framework class, not defined in the package) 8.

| File | Line | Class | Declared | Verdict | Note |
|---|---|---|---|---|---|
| src/App/OMCAppDelegate.h | 7 | OMCAppDelegate | UIResponder | **MATCH** | truth(App)=UIResponder |
| src/AppBridgeA/src/ABHost.h | 17 | ABPane | NSObject | **MATCH** | truth(AppBridge)=NSObject |
| src/AppBridgeA/src/ABHost.h | 37 | ABHost | NSObject | **MATCH** | truth(AppBridge)=NSObject |
| src/AppBridgeB/ABChromeViews.m | 18 | ABBoxView | UIView | **MATCH** | truth(AppBridge)=UIView |
| src/AppBridgeB/ABChromeViews.m | 27 | ABShieldView | UIView | **MATCH** | truth(AppBridge)=UIView |
| src/AppBridgeB/ABChromeViews.m | 31 | ABKnobView | UIView | **MATCH** | truth(AppBridge)=UIView |
| src/AppBridgeB/ABChromeViews.m | 41 | ABBarButton | UIButton | **MATCH** | truth(AppBridge)=UIButton |
| src/AppBridgeB/ABHost.h | 29 | ABPane | NSObject | **MATCH** | truth(AppBridge)=NSObject |
| src/AppBridgeB/ABHost.h | 56 | ABHost | NSObject | **MATCH** | truth(AppBridge)=NSObject |
| src/AppBridgeB/ABKeyboard.m | 31 | ABKey | UIButton | **MATCH** | truth(AppBridge)=UIButton |
| src/AppBridgeB/ABKeyboard.m | 63 | ABKeyboard | NSObject | **MATCH** | truth(AppBridge)=NSObject |
| src/Prefs/OMCPrefs/OMCAppBridgeAppsController.h | 14 | OMCAppBridgeAppsController | PSViewController | **MATCH** | truth(Prefs)=PSViewController |
| src/Prefs/OMCPrefs/OMCCardPage.h | 9 | OMCCardPage | PSViewController | **MATCH** | truth(Prefs)=PSViewController |
| src/Prefs/OMCPrefs/OMCCells.h | 9 | OMCFeatureStatusCell | PSTableCell | **MATCH** | truth(Prefs)=PSTableCell |
| src/Prefs/OMCPrefs/OMCCells.h | 14 | OMCAppBridgeAppsLinkCell | PSTableCell | **MATCH** | truth(Prefs)=PSTableCell |
| src/Prefs/OMCPrefs/OMCCells.h | 20 | OMCSplitScreenAppLinkCell | PSTableCell | **MATCH** | truth(Prefs)=PSTableCell |
| src/Prefs/OMCPrefs/OMCCommon.m | 934 | SPPSoundDelegate | NSObject | **MATCH** | truth(Prefs)=NSObject |
| src/Prefs/OMCPrefs/OMCFeatureListController.h | 6 | OMCFeatureListController | PSListController | **MATCH** | truth(Prefs)=PSListController |
| src/Prefs/OMCPrefs/OMCHeaderCard.h | 7 | OMCHeaderCard | UIView | **MATCH** | truth(Prefs)=UIView |
| src/Prefs/OMCPrefs/OMCHomeScreenController.h | 8 | OMCHomeScreenController | OMCAppBridgeAppsController | **MATCH** | truth(Prefs)=OMCAppBridgeAppsController |
| src/Prefs/OMCPrefs/OMCRootListController.h | 9 | OMCRootListController | PSListController | **MATCH** | truth(Prefs)=PSListController |
| src/Prefs/OMCPrefs/OMCRootListController.m | 16 | OMCOnboardingController | UIViewController | **MATCH** | truth(Prefs)=UIViewController |
| src/Prefs/OMCPrefs/OMCRootListController.m | 20 | OMCWhatsNewController | UIViewController | **MATCH** | truth(Prefs)=UIViewController |
| src/Prefs/OMCPrefs/generated/OMCAppBridgeAppsController.h | 7 | OMCAppBridgeAppsController | PSViewController | **MATCH** | truth(Prefs)=PSViewController |
| src/Prefs/OMCPrefs/generated/OMCAppBridgeAppsLinkCell.h | 7 | OMCAppBridgeAppsLinkCell | PSTableCell | **MATCH** | truth(Prefs)=PSTableCell |
| src/Prefs/OMCPrefs/generated/OMCCarProfilesController.h | 7 | OMCCarProfilesController | PSViewController | **MATCH** | truth(Prefs)=PSViewController |
| src/Prefs/OMCPrefs/generated/OMCCardPage.h | 7 | OMCCardPage | PSViewController | **MATCH** | truth(Prefs)=PSViewController |
| src/Prefs/OMCPrefs/generated/OMCFeatureListController.h | 7 | OMCFeatureListController | PSListController | **MATCH** | truth(Prefs)=PSListController |
| src/Prefs/OMCPrefs/generated/OMCFeatureStatusCell.h | 7 | OMCFeatureStatusCell | PSTableCell | **MATCH** | truth(Prefs)=PSTableCell |
| src/Prefs/OMCPrefs/generated/OMCHSPreview.h | 7 | OMCHSPreview | UIView | **MATCH** | truth(Prefs)=UIView |
| src/Prefs/OMCPrefs/generated/OMCHeaderCard.h | 7 | OMCHeaderCard | UIView | **MATCH** | truth(Prefs)=UIView |
| src/Prefs/OMCPrefs/generated/OMCHomeScreenController.h | 7 | OMCHomeScreenController | OMCAppBridgeAppsController | **MATCH** | truth(Prefs)=OMCAppBridgeAppsController |
| src/Prefs/OMCPrefs/generated/OMCOnboardingController.h | 7 | OMCOnboardingController | UIViewController | **MATCH** | truth(Prefs)=UIViewController |
| src/Prefs/OMCPrefs/generated/OMCRootListController.h | 7 | OMCRootListController | PSListController | **MATCH** | truth(Prefs)=PSListController |
| src/Prefs/OMCPrefs/generated/OMCSSStyleTileCell.h | 7 | OMCSSStyleTileCell | UICollectionViewCell | **MATCH** | truth(Prefs)=UICollectionViewCell |
| src/Prefs/OMCPrefs/generated/OMCSpeedBubbleController.h | 7 | OMCSpeedBubbleController | OMCCardPage | **MATCH** | truth(Prefs)=OMCCardPage |
| src/Prefs/OMCPrefs/generated/OMCSplitPreview.h | 7 | OMCSplitPreview | UIView | **MATCH** | truth(Prefs)=UIView |
| src/Prefs/OMCPrefs/generated/OMCSplitScreenAppLinkCell.h | 7 | OMCSplitScreenAppLinkCell | PSTableCell | **MATCH** | truth(Prefs)=PSTableCell |
| src/Prefs/OMCPrefs/generated/OMCSplitScreenAppPickerController.h | 7 | OMCSplitScreenAppPickerController | PSViewController | **MATCH** | truth(Prefs)=PSViewController |
| src/Prefs/OMCPrefs/generated/OMCSplitScreenController.h | 7 | OMCSplitScreenController | OMCCardPage | **MATCH** | truth(Prefs)=OMCCardPage |
| src/Prefs/OMCPrefs/generated/OMCStartupScreenController.h | 7 | OMCStartupScreenController | OMCFeatureListController | **MATCH** | truth(Prefs)=OMCFeatureListController |
| src/Prefs/OMCPrefs/generated/OMCWhatsNewController.h | 7 | OMCWhatsNewController | UIViewController | **MATCH** | truth(Prefs)=UIViewController |
| src/Prefs/OMCPrefs/generated/SPPBubbleView.h | 7 | SPPBubbleView | UIView | **MATCH** | truth(Prefs)=UIView |
| src/Prefs/OMCPrefs/generated/SPPGlassView.h | 7 | SPPGlassView | UIView | **MATCH** | truth(Prefs)=UIView |
| src/Prefs/OMCPrefs/generated/SPPIconView.h | 7 | SPPIconView | UIView | **MATCH** | truth(Prefs)=UIView |
| src/Prefs/OMCPrefs/generated/SPPSignView.h | 7 | SPPSignView | UIView | **MATCH** | truth(Prefs)=UIView |
| src/Prefs/OMCPrefs/generated/SPPSoundDelegate.h | 7 | SPPSoundDelegate | NSObject | **MATCH** | truth(Prefs)=NSObject |
| src/Prefs/OMCPrefs/generated/SSCanvasView.h | 7 | SSCanvasView | UIView | **MATCH** | truth(Prefs)=UIView |
| src/Prefs/OMCPrefs/generated/SSFade.h | 7 | SSFade | NSObject | **MATCH** | truth(Prefs)=NSObject |
| src/Prefs/OMCPrefs/generated/SSGauge.h | 7 | SSGauge | NSObject | **MATCH** | truth(Prefs)=NSObject |
| src/Prefs/OMCPrefs/generated/SSLinkTarget.h | 7 | SSLinkTarget | NSObject | **MATCH** | truth(Prefs)=NSObject |
| src/Prefs/OMCPrefs/generated/SSStartupView.h | 7 | SSStartupView | UIView | **MATCH** | truth(Prefs)=UIView |
| src/SpeedBubble/SPPOverspeed.m | 15 | SPPPrefs | NSObject | **MATCH** | truth(SpeedBubble)=NSObject |
| src/SpeedBubble/SPPOverspeed.m | 27 | SPPBubble | NSObject | **MATCH** | truth(SpeedBubble)=NSObject |
| src/SpeedBubble/SPPOverspeed.m | 41 | SPPOverspeed | NSObject | **MATCH** | truth(SpeedBubble)=NSObject |
| src/SpeedBubble/SPPPrefs.m | 31 | SPPPrefs | NSObject | **MATCH** | truth(SpeedBubble)=NSObject |
| src/SpeedBubble/SPPSpeedGPS.h | 21 | SPPSpeedGPS | NSObject | **MATCH** | truth(SpeedBubble)=NSObject |
| src/SpeedBubble/SPPWarningSound.m | 72 | SPPSoundDelegate | NSObject | **MATCH** | truth(SpeedBubble)=NSObject |
| src/SplitScreenA/SCPCarPane.h | 18 | SCPCarPane | NSObject | **MATCH** | truth(SplitScreen)=NSObject |
| src/SplitScreenA/SCPCarSplit.h | 23 | SCPCarSplit | NSObject | **MATCH** | truth(SplitScreen)=NSObject |
| src/SplitScreenA/SCPPrefs.h | 13 | SCPPrefs | NSObject | **MATCH** | truth(SplitScreen)=NSObject |
| src/SplitScreenA/SCPShared.h | 19 | DBApplicationInfo | NSObject | **EXTERNAL** | not a class defined in any package binary (framework/forward decl) |
| src/SplitScreenA/SCPShared.h | 22 | DBApplicationLaunchInfo | NSObject | **EXTERNAL** | not a class defined in any package binary (framework/forward decl) |
| src/SplitScreenA/SCPShared.h | 26 | DBDashboard | NSObject | **EXTERNAL** | not a class defined in any package binary (framework/forward decl) |
| src/SplitScreenA/SCPShared.h | 28 | DBDashboardRootViewController | UIViewController | **EXTERNAL** | not a class defined in any package binary (framework/forward decl) |
| src/SplitScreenA/SCPShared.h | 30 | DBDashboardHomeViewController | UIViewController | **EXTERNAL** | not a class defined in any package binary (framework/forward decl) |
| src/SplitScreenA/SCPShared.h | 32 | DBApplicationSceneViewController | UIViewController | **EXTERNAL** | not a class defined in any package binary (framework/forward decl) |
| src/SplitScreenA/SCPShared.h | 37 | DBEvent | NSObject | **EXTERNAL** | not a class defined in any package binary (framework/forward decl) |
| src/SplitScreenA/SCPShared.h | 40 | FBSDisplayLayoutPublisher | NSObject | **EXTERNAL** | not a class defined in any package binary (framework/forward decl) |
| src/SplitScreenA/SCPSmallClasses.h | 16 | SCPHostedAppVC | UIViewController | **MATCH** | truth(SplitScreen)=UIViewController |
| src/SplitScreenA/SCPSmallClasses.h | 36 | SCPNoopLayoutAssertion | NSObject | **MATCH** | truth(SplitScreen)=NSObject |
| src/SplitScreenB/SCPCButton.h | 14 | SCPCButton | UIButton | **MATCH** | truth(SplitScreen)=UIButton |
| src/SplitScreenB/SCPCTouchWatch.h | 17 | SCPCTouchWatch | UIView | **MATCH** | truth(SplitScreen)=UIView |
| src/SplitScreenB/SCPCarDividerView.h | 14 | SCPCarDividerView | UIView | **MATCH** | truth(SplitScreen)=UIView |
| src/SplitScreenB/SCPCarPane.h | 36 | SCPCarPane | NSObject | **MATCH** | truth(SplitScreen)=NSObject |
| src/SplitScreenB/SCPCarSplit.h | 63 | SCPCarSplit | NSObject | **MATCH** | truth(SplitScreen)=NSObject |
| src/SplitScreenB/SCPCarSplitView.h | 13 | SCPCarSplitView | UIView | **MATCH** | truth(SplitScreen)=UIView |
| src/SplitScreenB/SCPCarTabView.h | 13 | SCPCarTabView | UIView | **MATCH** | truth(SplitScreen)=UIView |
| src/SplitScreenB/SCPNoopLayoutAssertion.h | 13 | SCPNoopLayoutAssertion | NSObject | **MATCH** | truth(SplitScreen)=NSObject |
