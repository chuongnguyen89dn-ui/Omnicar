// SCPTouchProbe.m — [fix-w] WO W4: passive sendEvent: probe in CarPlayApp.
// OmniCarSplitScreen (Muse feature TU — not part of the 1.0.3 original).
//
// WHAT THIS IS
//   Exactly ONE additional MSHookMessageEx in this module, on
//   -[UIApplication sendEvent:], installed only inside CarPlayApp
//   (the caller, SCPInitDashboardHooks, is host-gated). The
//   replacement calls the original FIRST, with the event untouched,
//   and only then observes — inside @try/@catch — so a defect in this
//   file can never delay, alter or drop a touch. No hitTest target is
//   changed, no recognizer is installed, nothing is cancelled.
//
// WHAT IT LOGS (tag "SplitScreen", prefix [probe] / [probe-foreign])
//   Per Began: monotonic timestamp, sequence number, scene class,
//   window class, split-active flag, window point, and the pane the
//   point falls in per the CURRENT layout (slot, bundle, native or
//   hosted, side) — or "outside" when the point lands on CarPlay
//   chrome / dashboard area outside every pane.
//   Per finished touch chain: Began/Moved/Ended/Cancelled counts, so
//   the log shows whether CarPlayApp receives whole chains or
//   truncated ones. Phases arriving without a Began are counted as
//   orphans and summarised at Ended/Cancelled.
//   Touches whose window is not the split/dashboard window are logged
//   under [probe-foreign] and are NEVER treated as CarPlay input.
//
// SCENE CLASSIFICATION (module's own identification)
//   splitWindow = [SCPCarSplit shared].container.window — the
//   dashboard window the split container lives in.
//     touch.window == splitWindow        -> "carplay"
//     touch.window == split.trayWindow   -> "carplay-aux"
//     touch.window == nil / no container -> "unknown"
//     anything else                      -> "foreign"
//   The window class is always logged so an unexpected window can be
//   adjudicated from the log instead of guessed in code.

#import "SCPTouchProbe.h"
#import "SCPShared.h"     // OMCLogWrite, SCPVCIsHosted
#import "SCPCarSplit.h"   // shared session: active, container, allPanes
#import "SCPCarPane.h"
#import <UIKit/UIKit.h>
#import <objc/runtime.h>
#import <substrate.h>
#import <mach/mach_time.h>
#import <unistd.h>

static void (*orig_UIApplication_sendEvent)(id, SEL, UIEvent *);

// Monotonic clock, seconds — same mach_absolute_time idiom as
// SCPPerfTelemetry.m (OMCMonotonicSeconds), kept local to this TU.
static double SCPProbeNow(void) {
    static mach_timebase_info_data_t sTimebase;
    static dispatch_once_t once;
    dispatch_once(&once, ^{ mach_timebase_info(&sTimebase); });
    return (double)mach_absolute_time() * (double)sTimebase.numer /
           (double)sTimebase.denom / 1e9;
}

// Per-touch chain record, keyed by touch pointer value. Values:
//   began/moved/ended/cancelled: NSNumber counts
//   scene/pane: classification captured at Began (NSString)
//   t0: monotonic time of Began (NSNumber)
static NSMutableDictionary *SCPProbeChains(void) {
    static NSMutableDictionary *chains;
    static dispatch_once_t once;
    dispatch_once(&once, ^{ chains = [NSMutableDictionary dictionary]; });
    return chains;
}
static unsigned long long sProbeSeq;      // Began sequence
static unsigned long long sProbeOrphans; // phases seen without a Began

// Classify one Began touch. Outputs: scene label; pane label
// ("slot<k>"/"outside"/"n/a"); pane detail (bundle + hosted flag);
// side label. Pure reads of live layout state — no mutation.
static void SCPProbeClassify(UITouch *touch, NSString **outScene,
                             NSString **outPane, NSString **outDetail,
                             NSString **outSide) {
    SCPCarSplit *split = [SCPCarSplit shared];
    UIWindow *splitWindow = split.container.window;
    UIWindow *tw = touch.window;
    NSString *scene;
    if (!tw || !splitWindow) scene = @"unknown";
    else if (tw == splitWindow) scene = @"carplay";
    else if (split.trayWindow && tw == split.trayWindow) scene = @"carplay-aux";
    else scene = @"foreign";
    *outScene = scene;

    *outPane = @"n/a"; *outDetail = @"-"; *outSide = @"-";
    if (!tw) return;
    CGPoint pt = [touch locationInView:nil];   // window coordinates
    for (SCPCarPane *pane in [split allPanes]) {
        UIView *candidate = pane.view ?: pane.host;
        if (!candidate || !candidate.window) continue;
        CGPoint local = [candidate convertPoint:pt fromView:nil];
        if (!CGRectContainsPoint(candidate.bounds, local)) continue;
        BOOL hosted = SCPVCIsHosted(pane.vc);
        *outPane = [NSString stringWithFormat:@"slot%d", pane.slot];
        *outDetail = [NSString stringWithFormat:@"%@ %@",
                      pane.bundleID ?: @"(nil)",
                      hosted ? @"hosted" : @"native"];
        // Side from the hit pane's centre vs the container's centre,
        // along the layout axis (vertical stack -> T/B, else L/R).
        CGRect cf = [split.container convertRect:split.container.bounds
                                          toView:nil];
        CGRect pf = [candidate convertRect:candidate.bounds toView:nil];
        if ([split vertical])
            *outSide = CGRectGetMidY(pf) < CGRectGetMidY(cf) ? @"T" : @"B";
        else
            *outSide = CGRectGetMidX(pf) < CGRectGetMidX(cf) ? @"L" : @"R";
        return;
    }
    if ([scene isEqualToString:@"carplay"] ||
        [scene isEqualToString:@"carplay-aux"])
        *outPane = @"outside";   // CarPlay window, but no pane under it
}

static void SCPProbeObserveEvent(UIEvent *event) {
    if (event.type != UIEventTypeTouches) return;
    SCPCarSplit *split = [SCPCarSplit shared];
    double now = SCPProbeNow();
    NSMutableDictionary *chains = SCPProbeChains();
    for (UITouch *touch in event.allTouches) {
        NSValue *key = [NSValue valueWithPointer:(const void *)touch];
        NSMutableDictionary *rec = chains[key];
        switch (touch.phase) {
        case UITouchPhaseBegan: {
            NSString *scene, *pane, *detail, *side;
            SCPProbeClassify(touch, &scene, &pane, &detail, &side);
            unsigned long long seq = ++sProbeSeq;
            CGPoint pt = [touch locationInView:nil];
            NSString *prefix = [scene isEqualToString:@"foreign"] ||
                               [scene isEqualToString:@"unknown"]
                                   ? @"[probe-foreign]" : @"[probe]";
            OMCLogWrite(@"SplitScreen", [NSString stringWithFormat:
                @"%@ began t=%.3f seq=%llu scene=%@ win=%@ active=%d "
                 "pt={%.1f,%.1f} pane=%@ (%@) side=%@",
                prefix, now, seq, scene,
                touch.window ? NSStringFromClass([touch.window class])
                             : @"(nil)",
                split.active ? 1 : 0, pt.x, pt.y, pane, detail, side]);
            rec = [@{ @"began": @1, @"moved": @0, @"ended": @0,
                      @"cancelled": @0, @"seq": @(seq),
                      @"where": [NSString stringWithFormat:@"%@ %@",
                                 scene, pane],
                      @"t0": @(now) } mutableCopy];
            chains[key] = rec;
            break;
        }
        case UITouchPhaseMoved:
            if (rec) rec[@"moved"] = @([rec[@"moved"] integerValue] + 1);
            else sProbeOrphans++;
            break;
        case UITouchPhaseEnded:
        case UITouchPhaseCancelled: {
            BOOL ended = (touch.phase == UITouchPhaseEnded);
            if (!rec) {
                sProbeOrphans++;
                OMCLogWrite(@"SplitScreen", [NSString stringWithFormat:
                    @"[probe] chain-orphan t=%.3f %@ without began "
                     "(orphans=%llu)", now, ended ? @"ended" : @"cancelled",
                    sProbeOrphans]);
                break;
            }
            rec[ended ? @"ended" : @"cancelled"] =
                @([rec[ended ? @"ended" : @"cancelled"] integerValue] + 1);
            BOOL complete = [rec[@"began"] integerValue] == 1 &&
                            ([rec[@"ended"] integerValue] +
                             [rec[@"cancelled"] integerValue]) == 1;
            OMCLogWrite(@"SplitScreen", [NSString stringWithFormat:
                @"[probe] chain seq=%@ %@ began=%@ moved=%@ ended=%@ "
                 "cancelled=%@ complete=%d dur=%.3f",
                rec[@"seq"], rec[@"where"], rec[@"began"], rec[@"moved"],
                rec[@"ended"], rec[@"cancelled"], complete ? 1 : 0,
                now - [rec[@"t0"] doubleValue]]);
            [chains removeObjectForKey:key];
            break;
        }
        default:
            break;
        }
    }
}

// The replacement: original FIRST, event untouched; observation runs
// afterwards under @try/@catch so probe defects cannot affect input.
static void Hook_UIApplication_sendEvent(id self, SEL _cmd, UIEvent *event) {
    orig_UIApplication_sendEvent(self, _cmd, event);
    @try {
        SCPProbeObserveEvent(event);
    } @catch (id e) {
        // Passive by contract: never let observation break delivery.
    }
}

void SCPTouchProbeInstall(void) {
    static BOOL installed = NO;
    if (installed) return;
    installed = YES;
    MSHookMessageEx(objc_getClass("UIApplication"), @selector(sendEvent:),
                    (IMP)Hook_UIApplication_sendEvent,
                    (IMP *)&orig_UIApplication_sendEvent);
    OMCLogWrite(@"SplitScreen", [NSString stringWithFormat:
        @"[probe] sendEvent probe installed pid=%d (passive, measure-only)",
        getpid()]);
}
