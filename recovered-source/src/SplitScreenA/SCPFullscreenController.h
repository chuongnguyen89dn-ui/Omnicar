// SCPFullscreenController.h — OmniCarSplitScreen [fs1, design-fullscreen-fs1 §4]
//
// The single owner of fullscreen (meaning (c): full-host, dock/chrome
// hidden) state in the rebuilt tree. Rebuilt from the QA20 reference
// source (src/OmniCarDoubleTapFullscreen.xm — OMCToggleHost, snapshot/
// restore, the appAreaInParent: consultation) with a formal control
// API; the QA20 binary itself is never loaded and none of its symbols
// are referenced (design §0/§2).
//
// State machine (§4.1): SPLIT -> EXPANDING -> EXPANDED -> RESTORING ->
// SPLIT, with rollback to SPLIT on any unconfirmed step. The controller
// is the ONLY holder of the machine, the snapshot and the settled
// expanded flag: the adapter (SCPFullscreenAdapter) is a pure
// forwarding layer onto this class, the pinch controller keeps no
// fullscreen variable, and the wake owner only receives the settled
// flag through bwSetExpandedActive:forBundle: (§4.10).
//
// Lives only in the CarPlayApp process: installed from the __init_1
// glue beside bwInstallOwner. In any other process the class exists
// but is never installed, and fsCommittedState reports Unknown.

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "SCPFullscreenAdapter.h" // SCPFullscreenState

NS_ASSUME_NONNULL_BEGIN

@class SCPCarSplit;

@interface SCPFullscreenController : NSObject

+ (instancetype)shared;

/// Idempotent install (CarPlayApp glue only): arms the [fs1-test]
/// prefs observer. Without install the controller stays inert and
/// fsCommittedState is Unknown.
- (void)fsInstallIfNeeded;

/// Settled state for outside readers (§4.1): EXPANDING still reports
/// Split, RESTORING still reports Expanded; only a confirmed settle
/// flips the reported value. Unknown when not installed.
- (SCPFullscreenState)fsCommittedState;

/// Control API (adapter + [fs1-test] switch funnel through these).
/// One transaction at a time: a request arriving while EXPANDING or
/// RESTORING is refused ("fs busy") — never queued, never concurrent.
/// completion YES is delivered only after the layout change has been
/// read back and confirmed (§4.4/§4.5); provenance ("pinch" / "test" /
/// "teardown") is log-only (§4.2).
- (void)fsRequestExpandWithCompletion:(nullable void (^)(BOOL applied))completion
                           provenance:(NSString *)provenance;
- (void)fsRequestRestoreWithCompletion:(nullable void (^)(BOOL applied))completion
                            provenance:(NSString *)provenance;

/// The single area-coordination point (§4.3): called from the one
/// consultation line at the return of -[SCPCarSplit appAreaInParent:].
/// Returns the snapshot target area ONLY while the internal expanded
/// flag is up, for the snapshotted parent, with the split active and
/// a valid target; otherwise returns nativeArea untouched.
- (CGRect)fsAreaForParent:(nullable UIView *)parent
             nativeArea:(CGRect)nativeArea
                  split:(SCPCarSplit *)split;

/// Layout reconcile (§4.8): called from the rootDidLayout seam after
/// every layout. No-op unless the machine is EXPANDED under a live
/// transaction. Re-confirms the container frame, yields to outside
/// overrides (solo/zoom/teardown) via the abbreviated restore, and
/// re-asserts FS chrome.
- (void)fsDidLayout;

/// Session end (§4.6 abbreviated restore): dashboard invalidated or
/// split deactivated while expanded — clips + chrome restored, wake
/// owner notified, NO relayout. No-op in SPLIT.
- (void)fsSessionDidEnd;

/// Settled-state event sink, set once by the adapter at its init
/// (§4.9) and fired by the controller at every settle point.
@property (nonatomic, copy, nullable) void (^fsStateDidChange)(SCPFullscreenState newState);

@end

NS_ASSUME_NONNULL_END
