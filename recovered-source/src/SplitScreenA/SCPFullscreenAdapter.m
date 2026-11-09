// SCPFullscreenAdapter.m — OmniCarSplitScreen [fs1, design-fullscreen-fs1 §4.9]
//
// Pure forwarding layer onto SCPFullscreenController, the single
// fullscreen state owner of this module. The protocol in
// SCPFullscreenAdapter.h is unchanged from the wake round; what
// changed is only what stands behind it:
//
//   wake1: A1 = BLOCKED — the QA20 binary offers no safe external
//   control entry, so this body was the disciplined empty body
//   (currentState always Unknown, every request refused). That
//   protection is NOT broken here: nothing calls the QA20 toggle by
//   offset, simulates its menu button, or assumes a fullscreen state.
//
//   fs1 (Nguyen's decision, GPT reopening A1): the fullscreen
//   mechanism itself is rebuilt in-module from the QA20 reference
//   source, owned by SCPFullscreenController. This adapter forwards
//   the three protocol points to it and holds NO fullscreen state of
//   its own — currentState is the controller's settled state, the
//   completions are the controller's confirmed completions, and
//   stateDidChange re-emits the controller's settle events verbatim.

#import "SCPFullscreenAdapter.h"
#import "SCPFullscreenController.h"

@implementation SCPFullscreenAdapter

@synthesize stateDidChange = _stateDidChange;

- (instancetype)init {
    self = [super init];
    if (self) {
        // §4.9: subscribe ONCE to the controller's settle events and
        // re-emit them unchanged through the protocol callback.
        __weak typeof(self) weakSelf = self;
        [SCPFullscreenController shared].fsStateDidChange =
            ^(SCPFullscreenState newState) {
                __strong typeof(weakSelf) self = weakSelf;
                if (self && self->_stateDidChange)
                    self->_stateDidChange(newState);
            };
    }
    return self;
}

- (SCPFullscreenState)currentState {
    return [[SCPFullscreenController shared] fsCommittedState];
}

- (void)requestExpandWithCompletion:(void (^)(BOOL applied))completion {
    [[SCPFullscreenController shared]
        fsRequestExpandWithCompletion:completion provenance:@"pinch"];
}

- (void)requestRestoreWithCompletion:(void (^)(BOOL applied))completion {
    [[SCPFullscreenController shared]
        fsRequestRestoreWithCompletion:completion provenance:@"pinch"];
}

@end
