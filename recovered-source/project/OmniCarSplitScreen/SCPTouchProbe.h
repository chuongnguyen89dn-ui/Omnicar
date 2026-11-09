// SCPTouchProbe.h — [fix-w] WO W4: passive touch probe, CarPlayApp side.
// OmniCarSplitScreen (Muse feature TU — not part of the 1.0.3 original).
//
// PURPOSE (WO W4): produce the evidence that discriminates the touch
// path. If the in-app hook (ABInApp) never sees Began on a hosted pane,
// does the CarPlayApp process see it? This probe answers that from the
// CarPlayApp side. The original replacement is untouched in spirit:
// the original IMP runs FIRST, the event is never altered, cancelled
// or swallowed by anything in this TU.
//
// EVOLUTION ([fix-np] WO GPT items 2+3): on top of the passive
// classifier, this TU now (A) feeds activity for NATIVE panes through
// the existing F1 entry point -[SCPCarSplit ahNoteActivity:] under a
// strict gate set (car-screen identity, live assignment, screen-space
// containment, system-region and popup exclusions — see
// SCPProbeFeedEvaluate), and (B) records the active touch set for the
// future pinch decision. Neither addition touches the event; the feed
// is an activity note, not a reveal or a swallow. See
// SCPTouchProbe.m for the full design.

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/// Installs the single passive -[UIApplication sendEvent:] observation
/// hook owned by this TU. MUST be called only from
/// SCPInitDashboardHooks in SCPHooks.m, which is already gated to the
/// CarPlayApp process (SCPHostIsCarPlayApp + crash guard). Idempotent:
/// repeat calls are no-ops.
void SCPTouchProbeInstall(void);

NS_ASSUME_NONNULL_END
