// SCPFullscreenAdapter.h — OmniCarSplitScreen [wake-round, design-pinch §4]
//
// Abstract control surface for the QA20 fullscreen mechanism (fullscreen
// meaning (c) — full-host, dock/chrome hidden — see study-pinch-fullscreen
// §0). The pinch controller (SCPPinchController) talks ONLY to the
// SCPFullscreenControlling protocol declared here; how QA20 is bound
// underneath is private to SCPFullscreenAdapter.m.
//
// A1 VERDICT (2026-11-09, work/wake-round/a1-fullscreen-entry.md):
// FULLSCREEN_ENTRY = BLOCKED. OMCToggleHost is a static function with a
// single internal call site; the QA20 dylib exposes no command channel,
// no accessor and no readable expanded state. The adapter in this round
// is therefore the DISCIPLINED EMPTY BODY of design-pinch §4.3, and that
// is its FINAL state for this round (not a placeholder awaiting A1):
// currentState is always Unknown, every request completes NO, and
// stateDidChange never fires. Consequence, by design: gate 2 of the
// pinch state machine (design-pinch §3.3) can never pass for pinch-out,
// so PINCH ENFORCE can never arm while this adapter is bound — the
// design locks itself, no controller change is needed to disable pinch.

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, SCPFullscreenState) {
    SCPFullscreenStateUnknown = 0,  // cannot be read — every decision fails open
    SCPFullscreenStateSplit,
    SCPFullscreenStateExpanded
};

@protocol SCPFullscreenControlling <NSObject>
/// Synchronous read of the current state. Unknown when no safe read path
/// exists — never guessed from a parallel internal state machine.
- (SCPFullscreenState)currentState;
/// Ask to expand to fullscreen (valid only when currentState == Split).
/// completion: YES = the UI really changed (state machine A6:
/// EXPANDING -> EXPANDED is confirmed only once the UI has changed).
- (void)requestExpandWithCompletion:(void (^)(BOOL applied))completion;
/// Ask to restore to split (valid only when currentState == Expanded).
- (void)requestRestoreWithCompletion:(void (^)(BOOL applied))completion;
/// Fires whenever the state changes from ANY source (including the user
/// leaving fullscreen through QA20's own mechanism — if a signal for
/// that exists; if none exists, the arbiter must accept a possibly-stale
/// cached state and re-check at session lifecycle points).
@property (nonatomic, copy, nullable) void (^stateDidChange)(SCPFullscreenState newState);
@end

/// Binding point for the QA20 fullscreen mechanism. This round: empty
/// body per A1 = BLOCKED (see file header). A future binding changes
/// only the body of this class — never the controller or the arbiter.
@interface SCPFullscreenAdapter : NSObject <SCPFullscreenControlling>
@end

NS_ASSUME_NONNULL_END
