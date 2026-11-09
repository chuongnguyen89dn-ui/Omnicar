// SCPFullscreenAdapter.m — OmniCarSplitScreen [wake-round, design-pinch §4]
//
// Disciplined empty body — FINAL for this round, per A1:
//
//   A1=BLOCKED 2026-11-09, xem work/wake-round/a1-fullscreen-entry.md
//
// The QA20 fullscreen dylib (OmniCarDoubleTapFullscreen.dylib, md5
// 944d6f37c9ce327298dd6edd1d1a3bd8) offers no safe external control
// entry: OMCToggleHost is static with exactly one internal call site
// (-[OMCZoomAction pressed:]), its state lives behind associated
// objects keyed by a dylib-internal static address, its only
// notification channel is one-way chrome state OUT, and the one
// exported symbol (_OMCChromeSetHidden) drives SpringBoard status-bar
// chrome, not the host toggle. Calling any of these by guessed offset
// or selector is forbidden by the work order.
//
// Binding point for a future round (when/if an entry is ever proven):
// implement the three protocol methods against that entry HERE, in
// this file only. currentState must remain a read of the QA20 source
// of truth — never a self-maintained shadow of commands we sent
// (design-pinch §4.3: no second expanded-state machine competing with
// QA20).

#import "SCPFullscreenAdapter.h"
#import "SCPShared.h" // OMCLogWrite

@implementation SCPFullscreenAdapter

@synthesize stateDidChange = _stateDidChange;

- (SCPFullscreenState)currentState {
    // A1=BLOCKED: no safe read path exists -> always Unknown, which
    // fails every dependent decision open (design-pinch §4.2/§4.3).
    return SCPFullscreenStateUnknown;
}

- (void)requestExpandWithCompletion:(void (^)(BOOL applied))completion {
    OMCLogWrite(@"SplitScreen",
        @"[pinch1] adapter expand refused (A1=BLOCKED: no callable QA20 fullscreen entry)");
    if (completion) completion(NO);
}

- (void)requestRestoreWithCompletion:(void (^)(BOOL applied))completion {
    OMCLogWrite(@"SplitScreen",
        @"[pinch1] adapter restore refused (A1=BLOCKED: no callable QA20 fullscreen entry)");
    if (completion) completion(NO);
}

// stateDidChange is never invoked by this body: with no binding there
// is no state source that could change (design-pinch §4.3).

@end
