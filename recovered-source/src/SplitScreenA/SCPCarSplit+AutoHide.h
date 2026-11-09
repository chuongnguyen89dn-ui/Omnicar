// SCPCarSplit+AutoHide.h — AutoHide controller interface
// (design-autohide.md §3, §5.1).
//
// AutoHide is the rebuilt tree's own idle-fade feature, modelled on the
// QA20/QA19 add-ons' car-proven behaviour (read from their sources, not
// copied): after 4.0 s without activity, EVERY on-screen split control
// fades completely (layer.opacity = 0, original value saved per view and
// restored verbatim on reveal) — pane handles, dividers + their knobs,
// and the home/logo button on the CarPlay side; the hosted mirrors
// follow through the fade/kfade keys the frame/knob payloads carry
// (wired by the CarPlay part-2 strand in SCPCarSplit.m).
//
// The controller lives in this TU (module OmniCarSplitScreen, CarPlayApp
// process, beside the bridgewake owner). It owns exactly one session-
// wide idle timer (independent of the original bar/tray/ratio timers,
// which it never touches) and the single global faded flag `ahFaded`.
// That flag is a NARROW READ-ONLY INPUT to the wake owner:
// bwRecomputeForPane: folds it into HIDDEN (design-autohide §3.3);
// nobody outside this TU writes fade state.
//
// Painting discipline (design §2.5, from QA20/QA19): layer.opacity ONLY
// — never hidden, never alpha, never userInteractionEnabled — so every
// faded hit target stays tappable, which is what lets the first touch
// after a fade reach both the app (DRY_RUN parity) and the invisible
// handles themselves. No animation in either direction.

#import "SCPCarSplit.h"
#import "SCPCarPane.h"

NS_ASSUME_NONNULL_BEGIN

/// Activity feed sources (design §3.2). F1 is wired in this strand
/// (SCPCarSplitView hitTest); F2/F3 call sites live in SCPCarSplit.m /
/// SCPCarSplit+Divider.m and are wired by the CarPlay part-2 strand
/// against this same entry point; F4 arrives as bridgewake `act`
/// packets, validated by the BridgeWake TU and forwarded through
/// ahNoteActWithKbActive:.
typedef NS_ENUM(NSInteger, AHActivitySource) {
    AHSourceContainer  = 0, // F1: split container hitTest (Began)
    AHSourceHostHandle,     // F2: bridgeHandleTapped: (appbridge.handletap)
    AHSourceHostKnob,       // F2: remoteKnobTouch: (appbridge.knobtouch)
    AHSourceHome,           // F3: homeButtonTapped (invisible logo)
    AHSourceApp,            // F4: hosted-app act packet (ABInApp relay)
    AHSourceDragEnd,        // §4.2: divider/pane drag end re-arms the clock
};

/// Why a reveal happened (log-only; the reveal body is shared,
/// design §3.4).
typedef NS_ENUM(NSInteger, AHRevealReason) {
    AHRevealActivity = 0,   // ordinary activity feed (design §3.4 path 1)
    AHRevealWake,           // accepted wake packet (design §3.4 path 2)
    AHRevealUnsuspend,      // leaving EXPANDED/solo suspension
    AHRevealPrefOff,        // feature switched off while faded (§3.5)
};

@interface SCPCarSplit (AutoHide)

/// One-time install (called from the __init_1 glue beside bwInstallOwner
/// by the part-2 strand; CarPlayApp only). Idempotent. Loads the
/// bridgewake.autoHide pref and arms the idle timer when applicable.
- (void)ahInstall;

/// THE activity entry point (design §3.2). Main-queue; a call while the
/// split is inactive, the feature is off, or AutoHide is suspended is a
/// no-op. Any accepted call (a) reveals everything if currently faded
/// and (b) always re-arms the 4.0 s timer from now — the clock runs
/// from the LAST activity, exactly as in QA20/QA19.
- (void)ahNoteActivity:(AHActivitySource)source;

/// F4 boundary: a bridgewake `act` packet (BWTypeAct) that the
/// BridgeWake TU has already validated (hash/gen, design §3.2.1). The
/// flag updates the keyboard hold (kbActive=YES arms a hold that
/// self-expires after 10 s without a refreshing act; kbActive=NO
/// clears it), then the packet counts as AHSourceApp activity.
- (void)ahNoteActWithKbActive:(BOOL)kbActive;

/// Reveal everything NOW (design §3.4 path 2): the wake owner calls
/// this when it accepts a wake packet, so an ENFORCE wake restores the
/// full chrome set together with the bar. Safe to call when not faded.
- (void)ahRevealWithReason:(AHRevealReason)reason;

/// Suspension (design §4.1): the wake owner calls with YES at the same
/// point it takes the EXPANDED input (and for the hosted-solo session).
/// Suspending invalidates the timer and restores any fade FIRST, so
/// fullscreen starts from a known visual state; unsuspending starts
/// visible with a freshly armed 4.0 s clock.
- (void)ahSetSuspended:(BOOL)suspended;

/// The global faded flag — read-only input for the wake owner
/// (bwRecomputeForPane:) and for the part-2 frame/knob payload code
/// (hostFrameInfo `fade`, publishKnobsNow `kfade`). Written ONLY by
/// this TU.
- (BOOL)ahFaded;

/// Re-read the bridgewake.autoHide pref (absent = ON, design §3.5).
/// Called at install and by the owner on SCPNotePrefsChanged (part-2
/// wiring in bwReloadModesAndRepublish). Switching off while faded
/// restores everything immediately and stops the timer.
- (void)ahReloadConfig;

/// Session start counterpart of ahSessionTeardown: the part-2 strand
/// calls this where the split becomes active (the activation-side
/// sibling of the dashboardInvalidated point), so the FIRST fade of a
/// session can happen 4.0 s after the split appears even with zero
/// touches — QA20 arms its clock at attach the same way. Stamps the
/// activity clock and arms the timer (self-guarded).
- (void)ahSessionStarted;

/// Session teardown (part-2 calls beside bwSessionTeardown in
/// dashboardInvalidated): stop the timer, restore every painted view,
/// clear hold/suspension. Host-side saves are restored by ABHost's own
/// pane teardown; this TU owns only the CarPlay side.
- (void)ahSessionTeardown;

/// Re-apply the current fade state to ONE control view that was just
/// (re)built or relaid out — the part-2 strand calls this at the end of
/// layoutBarForPane: (pane handle), rebuildDividers (divider + knob)
/// and refreshHomeButton (home button), following QA20's
/// paint-at-layout pattern. If faded, the view is painted (saving its
/// current opacity first); if not faded, any stale save is restored.
- (void)ahApplyCurrentStateToView:(nullable UIView *)view;

@end

NS_ASSUME_NONNULL_END
