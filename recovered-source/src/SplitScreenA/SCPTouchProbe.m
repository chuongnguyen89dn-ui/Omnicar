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
// EVOLUTION ([fix-np] WO GPT items 2+3): the probe now also
//   (A) FEEDS ACTIVITY for NATIVE panes only, through the existing
//       F1 entry point -[SCPCarSplit ahNoteActivity:], under the
//       gate set in SCPProbeFeedEvaluate below (car screen identity,
//       live pane assignment, screen-space containment, system-region
//       and popup exclusions). Hosted panes are NOT fed here — the
//       in-app act path (F4) owns them. The feed never swallows,
//       never blocks, never reveals directly: it calls the same
//       activity entry point a container hitTest Began calls.
//   (B) MEASURES the active touch set ([touchset] lines): every
//       touch's window class, raw window point, screen-space point,
//       pane assignment and event timestamp, so a later log can tell
//       two independent simultaneous contacts in one pane apart from
//       two window representations of ONE contact. Measure only —
//       no pairing, no pinch command, no new recognizer.
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
#import "SCPCarSplit+AutoHide.h" // [fix-np] ahNoteActivity: (F1 entry)
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

// ===========================================================================
// [fix-np] Part A — native-pane activity feed + Part B touch-set record.
//
// SCREEN-SPACE CONVERSION (GPT ruling): a point is NEVER carried
// between two different windows with fromView:nil — that silently
// assumes the windows share coordinates. Every conversion below goes
// through a NAMED coordinate space: touch point -> its window's
// coordinate space -> that window's SCREEN coordinate space; pane
// rect -> the pane view's own window space (same window, so
// toView:nil is that window by construction) -> the same screen
// space. Containment is decided only inside the screen space, and
// the screen must be the very UIScreen the split container lives on.
// ===========================================================================

// Touch point in its window's screen coordinates. NO when the touch
// has no window or no screen (nothing honest to convert through).
static BOOL SCPProbeTouchScreenPoint(UITouch *touch, CGPoint *outPt,
                                     UIScreen **outScreen) {
    UIWindow *w = touch.window;
    if (!w || !w.screen) return NO;
    CGPoint inWindow = [touch locationInView:w];
    *outPt = [w.coordinateSpace convertPoint:inWindow
                          toCoordinateSpace:w.screen.coordinateSpace];
    if (outScreen) *outScreen = w.screen;
    return YES;
}

// A view's bounds rect in its window's screen coordinates.
static CGRect SCPProbeViewScreenRect(UIView *v) {
    UIWindow *w = v.window;
    if (!w || !w.screen) return CGRectNull;
    CGRect inWindow = [v convertRect:v.bounds toView:nil]; // v's window
    return [w.coordinateSpace convertRect:inWindow
                       toCoordinateSpace:w.screen.coordinateSpace];
}

// Resolve the pane under a screen-space point, reading the LIVE pane
// list in this same pass. Returns a "slotK(bundle)" label or @"none";
// the pane itself (when found) comes back in outPane.
static NSString *SCPProbePaneAtScreenPoint(CGPoint sp, UIScreen *screen,
                                           SCPCarPane **outPane) {
    if (outPane) *outPane = nil;
    SCPCarSplit *split = [SCPCarSplit shared];
    for (SCPCarPane *pane in [split allPanes]) {
        UIView *candidate = pane.view ?: pane.host;
        if (!candidate || !candidate.window) continue;
        if (candidate.window.screen != screen) continue;
        CGRect r = SCPProbeViewScreenRect(candidate);
        if (CGRectIsNull(r)) continue;
        if (!CGRectContainsPoint(r, sp)) continue;
        if (outPane) *outPane = pane;
        return [NSString stringWithFormat:@"slot%d(%@)", pane.slot,
                pane.bundleID ?: @"(nil)"];
    }
    return @"none";
}

// Session generation for the feed. The BridgeWake owner's numeric
// per-slot generations (bwGenBySlot) are file statics inside
// SCPCarSplit+BridgeWake.m and are NOT exposed by its header, so
// this TU cannot read them (gap recorded in the strand report).
// The generation used here is a probe-side session epoch anchored
// on SCPCarSplit state itself: it advances whenever the container
// object or its window changes (a new session builds a new
// container via -ensureContainer) and whenever `active` falls (the
// dashboardInvalidated teardown edge). Every other feed input —
// pane membership, screen, popup state — is read live in the same
// pass, so a decision can never be stamped with a generation that
// does not match the state it was computed from.
static NSUInteger sFeedEpoch = 0;
static const void *sFeedContainerPtr = NULL;
static const void *sFeedContainerWindowPtr = NULL;
static BOOL sFeedWasActive = NO;
static NSUInteger SCPProbeFeedEpoch(SCPCarSplit *split) {
    const void *c = (__bridge const void *)split.container;
    const void *cw = (__bridge const void *)(split.container.window);
    if (c != sFeedContainerPtr || cw != sFeedContainerWindowPtr ||
        (sFeedWasActive && !split.active)) {
        sFeedEpoch++;
        sFeedContainerPtr = c;
        sFeedContainerWindowPtr = cw;
    }
    sFeedWasActive = split.active;
    return sFeedEpoch;
}

// Popup/overlay-active predicate — the SAME shape the fullscreen
// guard uses after the GPT tray fix (existence of a retained window
// is not openness), grounded in SCPCarSplit+Picker.m:
//   * pickerSheet is nil-ed synchronously when the picker closes
//     (removePickerSheet), so != nil means presented (its close
//     animation still counts — a closing transition is active).
//   * the tray view exists while the app tray is open/closing;
//     hideTrayWindowIfIdle only hides trayWindow once tray,
//     ratioMenu, pickerSheet and dragGhost are ALL nil, so a
//     visible trayWindow always has an overlay (tray, sheet, ratio
//     menu, or the background toast) on it.
//   * ratioMenu != nil is the ratio overlay; dragGhost / resizing
//     are the pane-drag and divider-drag transitions.
// Returns the firing sub-condition for the log, or nil.
static NSString *SCPProbePopupSub(SCPCarSplit *split) {
    if (split.pickerSheet) return @"picker";
    if (split.tray) return @"tray";
    if (split.trayWindow && !split.trayWindow.hidden)
        return @"traywindow";
    if (split.ratioMenu) return @"ratio";
    if (split.dragGhost) return @"drag";
    if (split.resizing) return @"resize";
    return nil;
}

// The stock Home escape corner: bottom-left of the CAR SCREEN, in
// screen coordinates. The session log's escape touches landed at
// x = 12.5..23.5, y = 217..226 on a 240 pt-tall display; a 48 pt
// corner covers them with margin while staying clear of any pane
// content a user would legitimately tap to wake controls.
static BOOL SCPProbeIsHomeCorner(CGPoint sp, UIScreen *screen) {
    const CGFloat kCorner = 48.0;
    CGRect b = screen.bounds;
    return sp.x < kCorner && sp.y > CGRectGetMaxY(b) - kCorner;
}

// The feed decision for ONE Began. Gates, in order (GPT item 2):
//   (ii) split active -> (unconvertible touch) -> (i) touch is on
//   the car screen (the UIScreen holding the split container) ->
//   (v) system region: DBStatusBarWindow by window identity (the
//   module's own convention, cf. SCPFullscreenController) at any
//   point, plus the Home corner by screen geometry at any window —
//   the log's escape appeared in BOTH representations -> (vi) a
//   popup/overlay is active -> (iii)+(iv) a pane is hit in screen
//   space from the LIVE assignment. (vii) The foreign label is
//   never a gate: a _UISystemGestureWindow touch that lands in a
//   pane is a full candidate (that is exactly how native-pane
//   Begans arrive). Hosted panes drop as drop-hosted — F4 owns
//   them, feeding here too would double-count activity.
static void SCPProbeFeedEvaluate(UITouch *touch, double now) {
    SCPCarSplit *split = [SCPCarSplit shared];
    NSUInteger epoch = SCPProbeFeedEpoch(split);
    NSString *winCls = touch.window
        ? NSStringFromClass([touch.window class]) : @"(nil)";
    if (!split.active) {
        OMCLogWrite(@"SplitScreen", [NSString stringWithFormat:
            @"[probe-feed] t=%.3f epoch=%lu drop-inactive win=%@",
            now, (unsigned long)epoch, winCls]);
        return;
    }
    CGPoint sp; UIScreen *touchScreen = nil;
    if (!SCPProbeTouchScreenPoint(touch, &sp, &touchScreen)) {
        OMCLogWrite(@"SplitScreen", [NSString stringWithFormat:
            @"[probe-feed] t=%.3f epoch=%lu drop-unconverted win=%@",
            now, (unsigned long)epoch, winCls]);
        return;
    }
    UIWindow *carWindow = split.container.window;
    if (!carWindow || touchScreen != carWindow.screen) {
        OMCLogWrite(@"SplitScreen", [NSString stringWithFormat:
            @"[probe-feed] t=%.3f epoch=%lu drop-display win=%@",
            now, (unsigned long)epoch, winCls]);
        return;
    }
    if ([winCls isEqualToString:@"DBStatusBarWindow"] ||
        SCPProbeIsHomeCorner(sp, touchScreen)) {
        OMCLogWrite(@"SplitScreen", [NSString stringWithFormat:
            @"[probe-feed] t=%.3f epoch=%lu drop-systemregion win=%@ "
             "scr={%.1f,%.1f}", now, (unsigned long)epoch, winCls,
            sp.x, sp.y]);
        return;
    }
    NSString *popupSub = SCPProbePopupSub(split);
    if (popupSub) {
        OMCLogWrite(@"SplitScreen", [NSString stringWithFormat:
            @"[probe-feed] t=%.3f epoch=%lu drop-popup(%@) win=%@ "
             "scr={%.1f,%.1f}", now, (unsigned long)epoch, popupSub,
            winCls, sp.x, sp.y]);
        return;
    }
    SCPCarPane *pane = nil;
    NSString *label = SCPProbePaneAtScreenPoint(sp, touchScreen, &pane);
    if (!pane || !pane.bundleID) {
        OMCLogWrite(@"SplitScreen", [NSString stringWithFormat:
            @"[probe-feed] t=%.3f epoch=%lu drop-notassigned win=%@ "
             "scr={%.1f,%.1f} pane=%@", now, (unsigned long)epoch,
            winCls, sp.x, sp.y, label]);
        return;
    }
    if (SCPVCIsHosted(pane.vc)) {
        OMCLogWrite(@"SplitScreen", [NSString stringWithFormat:
            @"[probe-feed] t=%.3f epoch=%lu drop-hosted pane=%@ win=%@",
            now, (unsigned long)epoch, label, winCls]);
        return;
    }
    [split ahNoteActivity:AHSourceContainer];
    OMCLogWrite(@"SplitScreen", [NSString stringWithFormat:
        @"[probe-feed] t=%.3f epoch=%lu fired pane=%@ win=%@ "
         "scr={%.1f,%.1f}", now, (unsigned long)epoch, label, winCls,
        sp.x, sp.y]);
}

// ===========================================================================
// [fix-np] Part B — active touch set (measure only for the future
// pinch decision). One record per live UITouch, keyed by pointer:
// window class, raw window point, screen-space point, screen-space
// pane assignment, the EVENT timestamp of its Began and of the last
// phase, and monotonic stamps. Two representations of one contact
// (the log's escape: same point, 3 ms apart, two windows) show up
// as two records with near-equal scr points and near-equal evB —
// distinguishable from two independent contacts by exactly this
// data. The set never pairs, never fires anything.
// ===========================================================================
static NSMutableDictionary *SCPProbeTouchSet(void) {
    static NSMutableDictionary *set;
    static dispatch_once_t once;
    dispatch_once(&once, ^{ set = [NSMutableDictionary dictionary]; });
    return set;
}
static BOOL sTouchSetDirty = NO;

static void SCPProbeTouchSetBegan(UITouch *touch, UIEvent *event,
                                  double now) {
    NSMutableDictionary *rec = [NSMutableDictionary dictionary];
    rec[@"win"] = touch.window
        ? NSStringFromClass([touch.window class]) : @"(nil)";
    CGPoint raw = touch.window ? [touch locationInView:touch.window]
                               : [touch locationInView:nil];
    rec[@"raw"] = [NSValue valueWithCGPoint:raw];
    CGPoint sp; UIScreen *scr = nil;
    if (SCPProbeTouchScreenPoint(touch, &sp, &scr)) {
        rec[@"scr"] = [NSValue valueWithCGPoint:sp];
        rec[@"pane"] = SCPProbePaneAtScreenPoint(sp, scr, NULL);
    } else {
        rec[@"pane"] = @"n/a";
    }
    rec[@"evB"] = @(event.timestamp);
    rec[@"evL"] = @(event.timestamp);
    rec[@"tB"] = @(now);
    rec[@"tL"] = @(now);
    SCPProbeTouchSet()[[NSValue valueWithPointer:(const void *)touch]]
        = rec;
    sTouchSetDirty = YES;
}

static void SCPProbeTouchSetMoved(UITouch *touch, UIEvent *event,
                                  double now) {
    NSMutableDictionary *rec =
        SCPProbeTouchSet()[[NSValue valueWithPointer:(const void *)touch]];
    if (!rec) return;
    if (touch.window)
        rec[@"raw"] = [NSValue valueWithCGPoint:
                       [touch locationInView:touch.window]];
    CGPoint sp; UIScreen *scr = nil;
    if (SCPProbeTouchScreenPoint(touch, &sp, &scr)) {
        rec[@"scr"] = [NSValue valueWithCGPoint:sp];
        rec[@"pane"] = SCPProbePaneAtScreenPoint(sp, scr, NULL);
    }
    rec[@"evL"] = @(event.timestamp);
    rec[@"tL"] = @(now);
    sTouchSetDirty = YES;
}

static void SCPProbeTouchSetEnded(UITouch *touch) {
    NSValue *key = [NSValue valueWithPointer:(const void *)touch];
    if (SCPProbeTouchSet()[key]) {
        [SCPProbeTouchSet() removeObjectForKey:key];
        sTouchSetDirty = YES;
    }
}

// One [touchset] line per event that changed the set, entries in
// Began order: ptr, window, raw point, screen point (or "-"),
// pane, Began event timestamp.
static void SCPProbeTouchSetFlush(double now, NSTimeInterval evTs) {
    if (!sTouchSetDirty) return;
    sTouchSetDirty = NO;
    NSMutableDictionary *set = SCPProbeTouchSet();
    NSArray *keys = [set.allKeys sortedArrayUsingComparator:
        ^NSComparisonResult(NSValue *a, NSValue *b) {
            double ta = [set[a][@"tB"] doubleValue];
            double tb = [set[b][@"tB"] doubleValue];
            return ta < tb ? NSOrderedAscending
                 : ta > tb ? NSOrderedDescending : NSOrderedSame;
        }];
    NSMutableString *desc = [NSMutableString string];
    for (NSValue *key in keys) {
        NSDictionary *r = set[key];
        CGPoint raw = [r[@"raw"] CGPointValue];
        NSString *scrStr = @"-";
        if (r[@"scr"]) {
            CGPoint sp = [r[@"scr"] CGPointValue];
            scrStr = [NSString stringWithFormat:@"{%.0f,%.0f}",
                      sp.x, sp.y];
        }
        [desc appendFormat:@" [ptr=%p win=%@ raw={%.0f,%.0f} scr=%@ "
             "pane=%@ evB=%.3f]", key.pointerValue, r[@"win"],
            raw.x, raw.y, scrStr, r[@"pane"],
            [r[@"evB"] doubleValue]];
    }
    OMCLogWrite(@"SplitScreen", [NSString stringWithFormat:
        @"[touchset] t=%.3f ev=%.3f active=%lu%@",
        now, evTs, (unsigned long)set.count,
        desc.length ? desc : @" (empty)"]);
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
            // [fix-np] Part A feed + Part B set record, after the
            // classic classification above (both worlds logged).
            SCPProbeFeedEvaluate(touch, now);
            SCPProbeTouchSetBegan(touch, event, now);
            break;
        }
        case UITouchPhaseMoved:
            if (rec) rec[@"moved"] = @([rec[@"moved"] integerValue] + 1);
            else sProbeOrphans++;
            SCPProbeTouchSetMoved(touch, event, now);
            break;
        case UITouchPhaseEnded:
        case UITouchPhaseCancelled: {
            SCPProbeTouchSetEnded(touch);
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
    SCPProbeTouchSetFlush(now, event.timestamp); // [fix-np] Part B
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
