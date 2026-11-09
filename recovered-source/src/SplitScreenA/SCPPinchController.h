// SCPPinchController.h — OmniCarSplitScreen [wake-round, design-pinch]
// Pinch-fullscreen recognition on the split container, CarPlayApp side
// (design-pinch §1–§3, probe §6.1). Two classes live in this pair of
// files:
//   - SCPPinchRecognizer: a custom UIGestureRecognizer subclass that
//     OBSERVES the touch stream on the split container and tracks one
//     pair of touches. It is configured cancelsTouchesInView = NO,
//     delaysTouchesBegan = NO, delaysTouchesEnded = NO (design §3.1):
//     it never holds, cancels or delays any touch — the saga "Cách A"
//     pair-holding from Began is deliberately NOT used; pairs that do
//     not prove themselves reach the app intact.
//   - SCPPinchController: lifecycle (attach/arm/disarm/reset glue
//     points for the integration step), the five-gate decision at the
//     single fire point (design §3.3), the (bundleID, scene) allowlist,
//     and the Gate-2 probe counters/log (§6.1).
// The controller's only exits are the SCPFullscreenControlling adapter
// (SCPFullscreenAdapter.h) and the shared Pinch/Wake arbiter below.
// It never posts the appbridge.baraction 'full' channel (that path is
// runSoloForPane: = solo, the wrong fullscreen meaning) and never
// touches the wake bar timers (arbitration isolation, design-bridgewake
// §2.3).

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "SCPCarPane.h"
#import "SCPFullscreenAdapter.h"

NS_ASSUME_NONNULL_BEGIN

@class SCPCarSplit, SCPPinchController;

/// Pinch feature mode, owned by the wake state owner and read by the
/// controller through the arbiter — NEVER from a plist on this side
/// (design-bridgewake §4; values match the bridgewake packet encoding:
/// 0=OFF, 1=DRY_RUN, 2=ENFORCE; any other value is treated as OFF).
typedef NS_ENUM(NSInteger, SCPPinchMode) {
    SCPPinchModeOff = 0,
    SCPPinchModeDryRun = 1,
    SCPPinchModeEnforce = 2
};

/// Arbitration outcome for a pinch candidate — shape fixed by
/// design-pinch §3.5 (the wake side owns the detailed definition in
/// design-bridgewake.md; this is exactly the surface the pinch side
/// consumes).
typedef NS_ENUM(NSInteger, SCPArbiterDisposition) {
    SCPArbiterPinchAllowed,        // SPLIT+VISIBLE, or EXPANDED for pinch-in
    SCPArbiterPinchBlockedHidden,  // SPLIT+HIDDEN — wake wins
    SCPArbiterPinchBlockedUnknown  // state unclear / keyboard / popup / native gesture
};

/// The single arbitration interface between pinch and the wake owner
/// (design-pinch §3.5). Implemented by the wake side (SCPCarSplit
/// bridge-wake owner) and assigned to the controller at integration.
/// pinchMode is carried here in addition to the two §3.5 methods
/// because the mode, too, must come from the owner (WO §IX /
/// design-bridgewake §4) — recorded as a deviation in
/// work/wake-round/impl-pinch.md for the integration step to wire.
@protocol SCPPinchArbiter <NSObject>
- (SCPArbiterDisposition)pinchDispositionForPane:(SCPCarPane *)pane
                               touchesSuppressed:(BOOL)anyTouchSuppressed;
- (BOOL)hostIsExpanded;  // forwarded from the fullscreen adapter (§4); the arbiter keeps the cached copy
- (SCPPinchMode)pinchMode;
@end

/// Why a finger's start point failed to map to a content pane
/// (design-pinch §2.1). A pair is valid only when both fingers map to
/// the SAME pane; any dead kind kills the pair.
typedef NS_ENUM(NSInteger, SCPPinchDeadKind) {
    SCPPinchDeadNone = 0,
    SCPPinchDeadOutside,  // start point in no pane (container background / gap)
    SCPPinchDeadDivider,  // start point on a divider
    SCPPinchDeadChrome    // start point on pane chrome (handle / bar / cover / loader / picker)
};

/// Custom recogniser: self-tracks touches in touchesBegan/Moved/Ended/
/// Cancelled (design-pinch §3.1/§3.2). Attached to the split container
/// (SCPCarSplitView) by the controller; lives and dies with it (§1.3).
@interface SCPPinchRecognizer : UIGestureRecognizer

/// Owning controller (weak; the controller owns the recognizer).
@property (nonatomic, weak, nullable) SCPPinchController *controller;

/// Drop all pair tracking NOW: a live pair is concluded as truncated
/// with the given reason and no command is ever fired from the reset
/// state (design-pinch §3.4). Called by the controller on disarm /
/// teardown / session change; the recognizer also self-resets when the
/// container bounds change mid-gesture.
- (void)resetTrackingWithReason:(NSString *)reason;

@end

/// Pinch controller: lifecycle glue surface, gate evaluation, allowlist
/// and probe bookkeeping. All methods are main-queue (UIKit delivery).
@interface SCPPinchController : NSObject

+ (instancetype)shared;

/// Arbitration input from the wake owner (design-pinch §3.5). When nil,
/// the controller fails safe: mode = DRY_RUN, disposition = BlockedUnknown,
/// expanded = read from the adapter.
@property (nonatomic, weak, nullable) id<SCPPinchArbiter> arbiter;

/// Fullscreen control surface (design-pinch §4). Defaults to a fresh
/// SCPFullscreenAdapter, which since fs1 forwards to
/// SCPFullscreenController (the A1 empty body is gone).
@property (nonatomic, strong) id<SCPFullscreenControlling> adapter;

/// Published by the wake side while it holds a touch chain under
/// suppression (design-pinch §3.3 gate 4 / §3.5): a touch belonging to
/// a held chain is never counted into a pair. Glue-maintained; when in
/// doubt the integration side sets YES (the pair then dies at gate 4).
@property (nonatomic) BOOL externalChainSuppressed;

/// The recognizer (created lazily by attachIfNeeded).
@property (nonatomic, readonly, nullable) SCPPinchRecognizer *recognizer;

/// YES while armed: split active, container attached to the car-display
/// window (design-pinch §1.3/§2.3).
@property (nonatomic, readonly) BOOL armed;

// --- Lifecycle glue (called from the integration step only: -----------
// --- SCPHooks seam, ensureContainer, dashboardInvalidated) ------------

/// Attach the recognizer to the current split container if it is not
/// already attached there, then re-sync arming. No-op without a
/// container. Safe to call repeatedly (ensureContainer builds a FRESH
/// container view on every entry, so re-attachment is normal).
- (void)attachIfNeeded;

/// Full teardown: conclude any live pair as truncated, detach the
/// recognizer, disarm, and log the session probe totals (§6.1).
- (void)detach;

/// Re-derive arming from split state: arm when the split is active and
/// the container is in a window; disarm + reset tracking otherwise.
- (void)syncArming;

/// Reset pair tracking (session/assignment change, CarPlay loss).
- (void)resetTracking;

// --- Allowlist (design-pinch §3.3 gate 5, §A4) -------------------------
// Keyed by (bundleID, hosted-scene). EMPTY by default — and since
// 2026-11-09 (staging removed, pinch wired live) an empty list means
// NO restriction: every pair passes gate 5. The list only bites once
// entries exist; then membership decides. (Staging-era reading —
// empty = everything OFF — is superseded.)

- (void)allowBundle:(NSString *)bundleID hosted:(BOOL)hosted;
- (BOOL)isAllowlistedBundle:(NSString *)bundleID hosted:(BOOL)hosted;

// --- Gate-2 probe counters (§6.1), counted separately per host state --
@property (nonatomic, readonly) NSInteger pairsCompleteSplit;
@property (nonatomic, readonly) NSInteger pairsTruncatedSplit;
@property (nonatomic, readonly) NSInteger pairsCompleteExpanded;
@property (nonatomic, readonly) NSInteger pairsTruncatedExpanded;

@end

NS_ASSUME_NONNULL_END
