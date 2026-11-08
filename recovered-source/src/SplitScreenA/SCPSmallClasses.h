// SCPSmallClasses.h — OmniCarSplitScreen (agent A)
// SCPHostedAppVC and SCPNoopLayoutAssertion, both VERIFIED body-by-body.

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

// SCPHostedAppVC — the stand-in VC placed in a pane for an AppBridge-hosted
// (phone) app. CALIBRATION CORRECTION: wave-1 metadata named its superclass
// NSOperationQueue; the calibrated superclass (LC_DYSYMTAB xref, delta=1)
// is UIViewController — consistent with its viewDidLoad and with it being
// stored in SCPCarPane.vc. It is a shell: the real scene lives in the phone
// app's process, rendered by AppBridge; this VC carries the bundle ID and
// answers the scene-management selectors the dashboard/pane code sends.
@interface SCPHostedAppVC : UIViewController
@property (nonatomic, copy, nullable) NSString *bundleID;  // only real state (ivar _bundleID)
// All three VERIFIED to return nil (`mov x0,#0; ret`):
- (nullable id)applicationInfo;
- (nullable id)proxyApplicationInfo;
- (nullable id)sceneHostView;
// VERIFIED: exists for duck-typing; sets a dark background if ever called.
- (void)viewDidLoad;
// VERIFIED: both simply invoke the completion block immediately — there is
// no local scene to background/foreground.
- (void)backgroundSceneWithCompletion:(nullable void (^)(void))completion;
- (void)foregroundSceneWithSettings:(nullable id)settings completion:(nullable void (^)(void))completion;
@end

// SCPNoopLayoutAssertion — VERIFIED: -invalidate is an empty body (`ret`).
// A no-op object with the shape of an FBSDisplayLayout assertion, used where
// a real assertion would fight the split's own layout bookkeeping
// (companion of the FBSDisplayLayoutPublisher -addElement: hook).
// CALIBRATION CORRECTION: superclass is NSObject (wave-1 said
// UIViewController).
@interface SCPNoopLayoutAssertion : NSObject
- (void)invalidate;
@end

NS_ASSUME_NONNULL_END
