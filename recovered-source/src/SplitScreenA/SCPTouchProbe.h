// SCPTouchProbe.h — [fix-w] WO W4: passive touch probe, CarPlayApp side.
// OmniCarSplitScreen (Muse feature TU — not part of the 1.0.3 original).
//
// PURPOSE (WO W4): produce the evidence that discriminates the touch
// path. If the in-app hook (ABInApp) never sees Began on a hosted pane,
// does the CarPlayApp process see it? This probe answers that from the
// CarPlayApp side and nothing more: it is MEASUREMENT ONLY. It never
// feeds AutoHide, never reveals, never swallows, never touches the
// event. See SCPTouchProbe.m for the classification design.

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/// Installs the single passive -[UIApplication sendEvent:] observation
/// hook owned by this TU. MUST be called only from
/// SCPInitDashboardHooks in SCPHooks.m, which is already gated to the
/// CarPlayApp process (SCPHostIsCarPlayApp + crash guard). Idempotent:
/// repeat calls are no-ops.
void SCPTouchProbeInstall(void);

NS_ASSUME_NONNULL_END
