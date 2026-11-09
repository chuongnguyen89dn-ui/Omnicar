// SCPHomeApply.h — SplitScreen-C: declarations for SCPHomeApply.m.
//
// The apply entry point itself (SCPHomeApply) stays declared where its
// existing callers expect it (SplitScreen-A's SCPShared.h and
// SplitScreen-C's SCPHomeSettings.m). This header carries the YTZ5
// strand-I5 icon instrument, whose contract is shared with the
// SplitScreen-A close-path strand (B5): that strand calls
// SCPLogInjectedIconState at its close measurement points and must use
// exactly this signature.

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

// [iconstate] instrument (YTZ5 I5, log-only): for every chosen/injected
// phone-app bundle, log one [iconstate] line describing what the live
// home icon model (reached through the weak home view controller, the
// same model->lists->icons walk SCPPublishCarAppsBlock uses) says about
// that bundle at this moment: BLIND when the walk cannot vouch for
// itself (validity gate lists>0 && modelIcons>0 not met), ABSENT-MODEL
// when the gate holds and the bundle is not in the model, PRESENT-MODEL
// when it is. Never walks the scene/window hierarchy. Safe to call when
// no home view controller exists yet (every bundle logs BLIND); never
// sends event-1 and touches no Home mechanism.
extern void SCPLogInjectedIconState(NSString *phase, NSString *src);

NS_ASSUME_NONNULL_END
