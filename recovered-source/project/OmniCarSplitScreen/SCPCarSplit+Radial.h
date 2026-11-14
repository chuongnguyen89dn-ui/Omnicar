//  SCPCarSplit+Radial.h
//  DuoCar V3 P4/G2 — OmniCarSplitScreen.dylib
//
//  Presenter for the five-sector radial wheel (G1 contract + GPT code
//  route APEX_V3_P4_MUSE_REAL_CODE_ROUTE_20261114): ONE owner on the
//  shared SCPCarSplit, hosted on the picker's tray window (tabParent
//  fallback), ACTION-FIRST — a sector only selects the command, the
//  target card under the wheel picks the pane, and only the card tap
//  dispatches to the existing handlers (showPickerForSlot:,
//  popOutPane:/floatDockBack, runBackgroundForPane:, runCloseForPane:).
//  Full stays disabled until the R4 fullscreen transaction is proven.

#import "SCPCarSplit.h"
#import "SCPRadialControlView.h"
#import "SCPRadialTargetStrip.h"

NS_ASSUME_NONNULL_BEGIN

/// Feature flag (pref `duocarRadialEnabled`, default ON). Both entry
/// points (native handle tap, DuoCar Home icon) test this first: when
/// OFF they keep the original bar / layout-panel behaviour untouched.
BOOL SCPRadialEnabled(void);

@interface SCPCarSplit (Radial) <SCPRadialControlViewDelegate, SCPRadialTargetStripDelegate>

/// Present the wheel (state S1, no action selected yet). `pane` is the
/// source pane when opened from a handle (kept as the suggested
/// target); nil from the Home route.
- (void)scpRadialPresentFromPane:(nullable SCPCarPane *)pane;

/// Handle entry point: dismiss when the wheel is open, otherwise
/// present it for that pane.
- (void)scpRadialToggleForPane:(SCPCarPane *)pane;

/// Tear the wheel down without touching any pane/scene.
- (void)scpRadialDismiss;

- (BOOL)scpRadialIsPresented;

/// Sector choice (from the wheel delegate): records the pending
/// action and (re)builds the target cards. Never mutates an app.
- (void)scpRadialSelectAction:(SCPRadialAction)action;

/// Target choice by slot (9 = the floating pane): re-resolves the
/// pane, verifies bundle + VC against the snapshot taken when the
/// cards were built, then dismisses and dispatches.
- (void)scpRadialSelectTargetSlot:(NSInteger)slot;

@end

NS_ASSUME_NONNULL_END
