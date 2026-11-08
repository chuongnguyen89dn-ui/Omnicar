// AppBridgeEntry.m — process-role dispatch (the three constructors).
//
// The dylib's filter is {"Bundles": ["com.apple.UIKit"]} — it loads into
// EVERY UIKit process. Role selection is done per-process by the ctors:
//
//   ctor 0x44A8 — hosted-app role: every .app process EXCEPT the six
//                 excluded bundle IDs below (incl. SpringBoard and
//                 CarPlayApp, which have their own roles).
//   ctor 0x6E08 — SpringBoard host role (bundleID == com.apple.springboard).
//   ctor 0x20184 — shared OMC scaffold ctor (present, in some form, in every
//                 dylib of the package; NOT AppBridge-specific — module
//                 assignment: shared/Core, see report §6). It references the
//                 strings "SpringBoard"/"CarPlay" (process checks) and sets
//                 up the OMC* helpers (prefs, logging, lite/wireless state).
//
// Reconstruction notes: the original uses dyld3 __init_offsets entries
// pointing at plain C functions; equivalent __attribute__((constructor))
// functions are used here.

#import "AppBridgeB.h"
#import <objc/runtime.h>
#import <substrate.h>
#import <dlfcn.h> // [integration phase 1; backported to src in phase 3] declares dlsym used in this file

extern void ABInstallInAppObservers(NSString *bundleID);   // ABInApp.m
extern void ABSpringBoardReady(id self, SEL _cmd, id app); // ABHost registrar (module A file in original layout; block bodies in ABHostGeometry.m / module A)

// ---------------------------------------------------------------------------
// ctor 0x44A8 — hosted-app role. VERIFIED from disassembly:
//   * bails unless bundleID non-empty, bundlePath contains ".app", and
//     bundleID is NOT in the constant exclusion array (0x393D8, count 6).
//   * registers two NSDistributedNotificationCenter observers addressed to
//     object = own bundleID, both delivered on the main queue:
//       - ABChanOrientation -> block whose invoke is sub_4728 (ABInApp.m)
//       - ABChanKey         -> block whose invoke is sub_5908 (ABInApp.m)
// ---------------------------------------------------------------------------
__attribute__((constructor))
static void ABAppCtor(void) {
    @autoreleasepool {
        NSBundle *bundle = [NSBundle mainBundle];
        NSString *bundleID = bundle.bundleIdentifier;
        if (bundleID.length == 0) return;
        if (![bundle.bundlePath containsString:@".app"]) return;
        // Constant array at 0x393D8 (__objc_arrayobj, 6 elements, verbatim):
        static NSArray<NSString *> *excluded;
        static dispatch_once_t once;
        dispatch_once(&once, ^{
            excluded = @[@"com.apple.springboard",
                         @"com.apple.CarPlayApp",
                         @"com.apple.CarPlayTemplateUIHost",
                         @"com.apple.CarPlaySettings",
                         @"com.apple.InCallService",
                         @"com.apple.Preferences"];
        });
        if ([excluded containsObject:bundleID]) return;
        ABInstallInAppObservers(bundleID);
    }
}

// ---------------------------------------------------------------------------
// ctor 0x6E08 — SpringBoard host role. VERIFIED from disassembly:
//   * only runs when bundleID == "com.apple.springboard"; logs
//     "loaded into SpringBoard" via OMCLogWrite(@"AppBridge", ...).
//   * MSHookMessageEx:
//       -[SpringBoard applicationDidFinishLaunching:]        -> sub_7004
//       -[SBSuspendedUnderLockManager
//           _shouldBeBackgroundUnderLockForScene:withSettings:] -> sub_72BC
//       -[FBScene updateSettings:withTransitionContext:completion:] -> sub_74B4
//       -[SBSceneView _updateReferenceSize:andOrientation:]   -> sub_7764
//   * OMCCheckHooks(@"AppBridge", <table at 0x39408>) — shared scaffold
//     self-check of the hook table (OMC module, not reconstructed here).
//   * MSHookFunction on dlsym(RTLD_DEFAULT /* -2 */,
//     "BKSDisplayServicesSetScreenBlanked") -> sub_777C, orig at 0x3EA10;
//     if the symbol is missing it logs
//     "khong tim thay BKSDisplayServicesSetScreenBlanked" and continues.
// ---------------------------------------------------------------------------
extern BOOL ABHook_SBSuspended(id self, SEL _cmd, id scene, id settings);
extern void ABHook_FBSceneUpdateSettings(id self, SEL _cmd, id settings, id ctx, ABFBSceneUpdateCompletion completion);
extern void ABHook_SBSceneViewRefSize(id self, SEL _cmd, CGSize size, NSInteger orientation);
extern void ABHook_ScreenBlanked(BOOL blanked); // C hook, sub_777C

// Original-IMP slots, defined in ABHostGeometry.m (addresses are the
// original's __DATA slots). [hotfix: the installers below previously
// passed NULL for every one of these, leaving the handlers' orig_*
// variables NULL while the handlers call through them]
extern IMP orig_SBDidFinishLaunching;          // 0x3E9F0
extern IMP orig_SBSuspended;                   // 0x3E9F8
extern IMP orig_FBSceneUpdate;                 // 0x3EA00
extern IMP orig_SBSceneView;                   // 0x3EA08
extern void (*orig_ScreenBlanked)(BOOL);       // 0x3EA10

__attribute__((constructor))
static void ABHostCtor(void) {
    @autoreleasepool {
        if (![[[NSBundle mainBundle] bundleIdentifier] isEqualToString:@"com.apple.springboard"]) return;
        OMCLogWrite(@"AppBridge", [NSString stringWithFormat:@"loaded into SpringBoard"]);
        ABInstallSpringBoardHooks();
    }
}
