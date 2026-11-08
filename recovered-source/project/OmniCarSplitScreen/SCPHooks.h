// SCPHooks.h — OmniCarSplitScreen (agent A)
// Original-IMP storage for every MSHookMessageEx hook installed by the four
// initializers, with the exact global addresses from the binary (all in
// __DATA, 0x87fb0-0x880a8). The installers themselves are in SCPHooks.m
// (CarPlayApp) and SCPSpringBoardHooks.m (SpringBoard + diag).

#import <Foundation/Foundation.h>

// __init_0 (0x44a8) — CarPlayApp, home/app-library group. Origs 0x87fb0+.
extern void *orig_DashBoard_newApplicationLibrary;            // 0x87fb0 meta DashBoard +_newApplicationLibrary
extern void *orig_DBApplicationInfo_loadFromProxy;            // 0x87fb8
extern void *orig_HomeVC_initWithEnvironment;                 // 0x87fc0
extern void *orig_HomeVC_viewDidLayoutSubviews;               // 0x87fc8
extern void *orig_HomeVC_viewDidAppear;                       // 0x87fd0
extern void *orig_HomeVC_viewDidDisappear;                    // 0x87fd8
extern void *orig_LaunchInfo_launchInfoForApplication;        // 0x87fe0 meta DBApplicationLaunchInfo
extern void *orig_LaunchInfo_launchInfoWithSettings;          // 0x87fe8
// The 8 icon-grid orig slots (0x87ff0-0x88028) are deliberately NOT
// declared here: the single surviving set is SplitScreen-C's typed slots
// in SCPHomeHooks.m (OrigIconImageInfo, OrigPortraitColumns, ...), which
// A's installer in SCPHooks.m now writes. (Phase-2 seam fix: A's void*
// duplicates of the same binary slots were removed.)
extern int   scpPrefsChangedToken;                            // 0x88030 notify token

// __init_1 (0x58b4) — CarPlayApp, dashboard/scene group. Origs 0x88040+.
extern void *orig_DBDashboard_sceneFrameForAppInfo;           // 0x88040
extern void *orig_DBDashboard_safeAreaInsetsForAppInfo;       // 0x88048
extern void *orig_DBDashboard_handleHomeEvent;                // 0x88050
extern void *orig_DBDashboard_invalidate;                     // 0x88058
extern void *orig_DBDashboard_launchAppWithInfo;              // 0x88060
extern void *orig_RootVC_presentBaseViewController;           // 0x88068
extern void *orig_RootVC_dismissBaseViewController;           // 0x88070
extern void *orig_RootVC_viewDidLayoutSubviews;               // 0x88078
extern void *orig_RootVC_viewDidAppear;                       // 0x88080
extern void *orig_SceneVC_backgroundSceneWithCompletion;      // 0x88088
extern void *orig_SceneVC_deactivateSceneWithReasonMask;      // 0x88090
extern void *orig_SceneVC_sceneManagerDidDestroyScene;        // 0x88098
extern void *orig_FBSDisplayLayoutPublisher_addElement;       // 0x880a0

// __init_2 (0x843c) — SpringBoard. Orig 0x880b0.
extern void *orig_SpringBoard_applicationDidFinishLaunching;  // 0x880b0
