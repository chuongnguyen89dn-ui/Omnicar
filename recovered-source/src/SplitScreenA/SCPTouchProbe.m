// SCPTouchProbe.m — CarPlayApp sendEvent: passive probe + live host pinch.
// [gpt-hl6-host-pinch] The existing hook calls original FIRST, untouched;
// CarPlay observes two real screen contacts and requests fullscreen of the
// WHOLE OmniCar split from its one existing adapter (not YouTube video).
// OmniCarSplitScreen (Muse feature TU — not part of the 1.0.3 original).
//
// WHAT THIS IS
//   Exactly ONE additional MSHookMessageEx in this module, on
//   -[UIApplication sendEvent:], installed only inside CarPlayApp
//   (the caller, SCPInitDashboardHooks, is host-gated). The
//   replacement calls original for all events EXCEPT the accepted
//   first wake chain on a faded native pane. That accepted chain is
//   consumed before UIKit dispatch, and fully logged. All normal
//   deliveries still invoke original exactly once, event untouched.
//   No hitTest target is changed and no recognizer is installed.
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
//       two window representations of ONE contact. This probe is
//       still read-only; the separate host-gesture consumer below
//       uses the same callback to request full-split expand/restore
//       only after a proven two-finger directional gesture.
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
#import "SCPCarSplit+BridgeWake.h" // [gpt-hl6-host-pinch] mode owner
#import "SCPPinchController.h" // [gpt-hl6-host-pinch] existing FS adapter
#import "SCPCarPane.h"
#import <UIKit/UIKit.h>
#import <objc/runtime.h>
#import <substrate.h>
#import <mach/mach_time.h>
#import <unistd.h>

static void (*orig_UIApplication_sendEvent)(id, SEL, UIEvent *);

// Monotonic clock, seconds — same mach_absolute_time idiom as
// SCPPerfTelemetry.m (OMCMonotonicSeconds), kept local to this TU.
// [hl8diag] ONE log stream, keyed by existing OMCLogWrite timestamp/PID.
// No new log file, IPC endpoint, capture of typed text, or input mutation.
// Default ON for one diagnostic DEB; pref hl8.unifiedDiag=NO disables it.
static BOOL SCPHL8TraceEnabled(void) {
    static int enabled = -1;
    if (enabled < 0) {
        id pref = OMCPref(@"hl8.unifiedDiag", nil);
        enabled = pref ? ([pref boolValue] ? 1 : 0) : 1;
    }
    return enabled == 1;
}

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


// ============================================================================
// [gpt-hl6-host-pinch] OmniCar FULL-SURFACE pinch detector in CarPlayApp.
//
// HL6 proof: all 54 in-app YouTube recognizer Begans had one touch; no
// pair formed. The CarPlay sendEvent probe can see the dashboard stream,
// including native and hosted panes, but it also sees a physical contact
// mirrored in _UISystemGestureWindow and a passthrough window. Count a
// pair ONLY if TWO independent start points are in the SAME live split
// session (they may span two panes); mirror objects never form a pair.
//
// This reuses the EXISTING SCPFullscreenAdapter (the sole fullscreen
// owner, which expands the entire split and hides the stock dock).
// It never calls runSoloForPane:, zooms YouTube video, creates a second
// fullscreen engine, changes UIEvent, or blocks one-finger touches.
// Old in-app pinch is disabled at the owner's state-packet emission while
// this host path is enabled (bridgewake.carHostPinch, default YES).
// ============================================================================
static NSMutableDictionary<NSValue *, NSMutableDictionary *> *SCPHostPinchContacts(void) {
    static NSMutableDictionary *contacts;
    static dispatch_once_t once;
    dispatch_once(&once, ^{ contacts = [NSMutableDictionary dictionary]; });
    return contacts;
}
static const void *sHostPinchContainer;
static const void *sHostPinchWindow;
static NSValue *sHostPinchKey1;
static NSValue *sHostPinchKey2;
static CGFloat sHostPinchStartDistance;
static CGPoint sHostPinchStartMidpoint;
static BOOL sHostPinchPairOpen;
static BOOL sHostPinchPairFired;
static BOOL sHostPinchPairKilled;
static BOOL sHostPinchTerminalLogged;
static NSTimeInterval sHostPinchLastMirrorLog;
static uint64_t sHL8PairCounter;
static uint64_t sHL8CurrentPair;
static NSTimeInterval sHL8LastPairRejectAt;

static void SCPHostPinchReset(void) {
    [SCPHostPinchContacts() removeAllObjects];
    sHostPinchKey1 = nil;
    sHostPinchKey2 = nil;
    sHostPinchPairOpen = NO;
    sHostPinchPairFired = NO;
    sHostPinchPairKilled = NO;
    sHostPinchTerminalLogged = NO;
    sHL8CurrentPair = 0;
    sHostPinchStartDistance = 0.0;
    sHostPinchStartMidpoint = CGPointZero;
}

static CGFloat SCPHostPinchDistance(CGPoint a, CGPoint b) {
    return hypot(a.x - b.x, a.y - b.y);
}

static NSArray<NSValue *> *SCPHostPinchDistinctKeys(void) {
    NSDictionary *contacts = SCPHostPinchContacts();
    NSArray<NSValue *> *keys = [contacts.allKeys sortedArrayUsingComparator:
        ^NSComparisonResult(NSValue *a, NSValue *b) {
        NSDictionary *ra = contacts[a], *rb = contacts[b];
        double ta = [ra[@"at"] doubleValue], tb = [rb[@"at"] doubleValue];
        if (ta < tb) return NSOrderedAscending;
        if (ta > tb) return NSOrderedDescending;
        // Prefer a stable representative; pointer ordering is only
        // used to break equal timestamp ties, not to identify fingers.
        uintptr_t pa = (uintptr_t)a.pointerValue;
        uintptr_t pb = (uintptr_t)b.pointerValue;
        return pa < pb ? NSOrderedAscending
                       : pa > pb ? NSOrderedDescending : NSOrderedSame;
    }];
    NSMutableArray<NSValue *> *unique = [NSMutableArray array];
    for (NSValue *key in keys) {
        NSDictionary *rec = contacts[key];
        CGPoint start = [rec[@"start"] CGPointValue];
        BOOL mirrored = NO;
        for (NSValue *otherKey in unique) {
            NSDictionary *other = contacts[otherKey];
            if ([rec[@"slot"] integerValue] != [other[@"slot"] integerValue])
                continue;
            if (fabs([rec[@"at"] doubleValue] -
                     [other[@"at"] doubleValue]) <= 0.050 &&
                SCPHostPinchDistance(start, [other[@"start"] CGPointValue]) <= 12.0) {
                mirrored = YES;
                break;
            }
        }
        if (!mirrored) [unique addObject:key];
    }
    return unique;
}

static BOOL SCPHostPinchPopupBusy(SCPCarSplit *split) {
    return split.pickerSheet != nil || split.ratioMenu != nil ||
           split.tray != nil || split.dragGhost != nil ||
           split.resizing || [split popupOpen];
}

// [gpt-hl7] Evaluate a pair on Moved, Stationary AND Ended.
// Uses the existing fullscreen adapter. No inferred/synthetic motion.
static void SCPHostPinchEvaluate(SCPCarSplit *split,
                                 NSMutableDictionary *contacts,
                                 NSTimeInterval eventTime,
                                 BOOL terminalEvent) {
    NSArray<NSValue *> *unique = SCPHostPinchDistinctKeys();
    if (unique.count < contacts.count &&
        eventTime - sHostPinchLastMirrorLog > 3.0) {
        sHostPinchLastMirrorLog = eventTime;
        OMCLogWrite(@"SplitScreen", [NSString stringWithFormat:
            @"[car-pinch] mirrored contacts=%lu distinct=%lu (no synthetic pair)",
            (unsigned long)contacts.count, (unsigned long)unique.count]);
    }
    if (unique.count > 2 && !sHostPinchPairKilled && SCPHL8TraceEnabled())
        OMCLogWrite(@"SplitScreen",
            @"[hl8diag] eye=pinch ev=drop reason=three-independent-contacts");
    if (unique.count > 2)
        sHostPinchPairKilled = YES;
    if (SCPHostPinchPopupBusy(split) && !sHostPinchPairKilled &&
        unique.count >= 2 && SCPHL8TraceEnabled())
        OMCLogWrite(@"SplitScreen",
            @"[hl8diag] eye=pinch ev=drop reason=popup-or-divider");
    if (SCPHostPinchPopupBusy(split)) sHostPinchPairKilled = YES;
    if (sHostPinchPairKilled) return;

    if (!sHostPinchPairOpen) {
        // Never form a new pair from already-ended contacts.
        if (terminalEvent || unique.count != 2) return;
        NSDictionary *a = contacts[unique[0]], *b = contacts[unique[1]];
        // A fullscreen OmniCar gesture is allowed ACROSS its two panes.
        // Both original assignments must still be live, not necessarily
        // the same bundle or slot.
        if (fabs([a[@"at"] doubleValue] - [b[@"at"] doubleValue]) > 1.2)
            return;
        SCPCarPane *liveA = [split paneAtSlot:[a[@"slot"] integerValue]];
        SCPCarPane *liveB = [split paneAtSlot:[b[@"slot"] integerValue]];
        if (!liveA || !liveB ||
            ![liveA.bundleID isEqualToString:a[@"bundle"]] ||
            ![liveB.bundleID isEqualToString:b[@"bundle"]])
            return;
        CGPoint p1 = [a[@"current"] CGPointValue];
        CGPoint p2 = [b[@"current"] CGPointValue];
        CGFloat d = SCPHostPinchDistance(p1, p2);
        if (d < 26.0) return;
        sHostPinchKey1 = unique[0];
        sHostPinchKey2 = unique[1];
        sHostPinchStartDistance = d;
        sHostPinchStartMidpoint = CGPointMake((p1.x + p2.x) * 0.5,
                                              (p1.y + p2.y) * 0.5);
        sHostPinchPairOpen = YES;
        sHL8CurrentPair = ++sHL8PairCounter;
        OMCLogWrite(@"SplitScreen", [NSString stringWithFormat:
            @"[car-pinch] pair panes=%@/%@ bundles=%@/%@ d0=%.1f contacts=%lu distinct=%lu",
            a[@"slot"], b[@"slot"], a[@"bundle"], b[@"bundle"], d,
            (unsigned long)contacts.count, (unsigned long)unique.count]);
        if (SCPHL8TraceEnabled())
            OMCLogWrite(@"SplitScreen", [NSString stringWithFormat:
                @"[hl8diag] eye=pinch ev=formed pair=%llu event=%.3f "
                 "startA=%@ startB=%@ slotA=%@ slotB=%@ active=%d",
                (unsigned long long)sHL8CurrentPair, eventTime,
                NSStringFromCGPoint([a[@"start"] CGPointValue]),
                NSStringFromCGPoint([b[@"start"] CGPointValue]),
                a[@"slot"], b[@"slot"], (int)split.active]);

        // [gpt-hl7-pair-toggle] HL7 car: 17/17 real physical two-finger
        // pairs; 16/17 chains had no Moved callback. HL4's proven
        // in-app recognizer toggled at pair formation. Reuse its
        // pair-at-Began law on the CarPlay host's SAME fullscreen
        // adapter. This toggles the entire OmniCar split, not a
        // YouTube video. One transaction maximum for each pair.
        //
        // Pref bridgewake.carHostPinchPairToggle=NO falls back to the
        // movement/terminal detector without changing the FS engine.
        id pairPref = OMCPref(@"bridgewake.carHostPinchPairToggle", nil);
        BOOL pairToggle = pairPref ? [pairPref boolValue] : YES;
        if (pairToggle) {
            id<SCPFullscreenControlling> adapter =
                [SCPPinchController shared].adapter;
            SCPFullscreenState state = adapter.currentState;
            if (SCPHL8TraceEnabled())
                OMCLogWrite(@"SplitScreen", [NSString stringWithFormat:
                    @"[hl8diag] eye=pinch ev=fs-gate pair=%llu adapter=%@ "
                     "state=%ld active=%d popup=%d frame=%@",
                    (unsigned long long)sHL8CurrentPair,
                    adapter ? NSStringFromClass([(id)adapter class]) : @"nil",
                    (long)state, (int)split.active,
                    (int)SCPHostPinchPopupBusy(split),
                    NSStringFromCGRect(split.container.frame)]);
            if (state != SCPFullscreenStateSplit &&
                state != SCPFullscreenStateExpanded) {
                OMCLogWrite(@"SplitScreen", [NSString stringWithFormat:
                    @"[car-pinch] pair-began-reject state=%ld",
                    (long)state]);
                sHostPinchPairFired = YES;
                return;
            }
            BOOL expand = (state == SCPFullscreenStateSplit);
            uint64_t hl8RequestID = sHL8CurrentPair;
            sHostPinchPairFired = YES;
            OMCLogWrite(@"SplitScreen", [NSString stringWithFormat:
                @"[car-pinch] request dir=%@ state=%ld source=pair-began d0=%.1f",
                expand ? @"expand" : @"restore", (long)state, (double)d]);
            if (SCPHL8TraceEnabled())
                OMCLogWrite(@"SplitScreen", [NSString stringWithFormat:
                    @"[hl8diag] eye=pinch ev=fs-request pair=%llu "
                     "dir=%@ adapter=%@ state=%ld",
                    (unsigned long long)hl8RequestID,
                    expand ? @"expand" : @"restore",
                    adapter ? NSStringFromClass([(id)adapter class]) : @"nil",
                    (long)state]);
            if (expand) {
                [adapter requestExpandWithCompletion:^(BOOL applied) {
                    OMCLogWrite(@"SplitScreen", [NSString stringWithFormat:
                        @"[car-pinch] expand applied=%d newState=%ld source=pair-began",
                        (int)applied, (long)adapter.currentState]);
                    if (SCPHL8TraceEnabled())
                        OMCLogWrite(@"SplitScreen", [NSString stringWithFormat:
                            @"[hl8diag] eye=pinch ev=fs-result pair=%llu dir=expand "
                             "applied=%d state=%ld container=%@",
                            (unsigned long long)hl8RequestID, (int)applied,
                            (long)adapter.currentState,
                            NSStringFromCGRect([SCPCarSplit shared].container.frame)]);
                }];
            } else {
                [adapter requestRestoreWithCompletion:^(BOOL applied) {
                    OMCLogWrite(@"SplitScreen", [NSString stringWithFormat:
                        @"[car-pinch] restore applied=%d newState=%ld source=pair-began",
                        (int)applied, (long)adapter.currentState]);
                    if (SCPHL8TraceEnabled())
                        OMCLogWrite(@"SplitScreen", [NSString stringWithFormat:
                            @"[hl8diag] eye=pinch ev=fs-result pair=%llu dir=restore "
                             "applied=%d state=%ld container=%@",
                            (unsigned long long)hl8RequestID, (int)applied,
                            (long)adapter.currentState,
                            NSStringFromCGRect([SCPCarSplit shared].container.frame)]);
                }];
            }
        }
        return;
    }
    if (sHostPinchPairFired || !contacts[sHostPinchKey1] ||
        !contacts[sHostPinchKey2]) return;
    NSDictionary *a = contacts[sHostPinchKey1], *b = contacts[sHostPinchKey2];
    CGPoint p1 = [a[@"current"] CGPointValue];
    CGPoint p2 = [b[@"current"] CGPointValue];
    CGFloat d = SCPHostPinchDistance(p1, p2);
    CGFloat delta = fabs(d - sHostPinchStartDistance);
    CGPoint mid = CGPointMake((p1.x + p2.x) * 0.5,
                              (p1.y + p2.y) * 0.5);
    CGFloat drift = SCPHostPinchDistance(mid, sHostPinchStartMidpoint);
    // HL7 17 real pairs, 16 with zero Moved callbacks. The terminal
    // position must be evaluated before the UITouch record is removed.
    // When even the terminal position is stationary, never make up
    // an expansion or restoration.
    if (terminalEvent && !sHostPinchTerminalLogged) {
        sHostPinchTerminalLogged = YES;
        OMCLogWrite(@"SplitScreen", [NSString stringWithFormat:
            @"[car-pinch] terminal d0=%.1f d1=%.1f ratio=%.3f drift=%.1f "
             "move=%ld/%ld p1=%@ p2=%@",
            (double)sHostPinchStartDistance, (double)d,
            (double)(d / MAX(sHostPinchStartDistance, 0.01)),
            (double)drift, (long)[a[@"moves"] integerValue],
            (long)[b[@"moves"] integerValue],
            NSStringFromCGPoint(p1), NSStringFromCGPoint(p2)]);
    }
    if (delta < 12.0 || drift > 0.6 * delta + 10.0) return;
    CGFloat ratio = d / sHostPinchStartDistance;
    BOOL outward = ratio >= 1.10;
    BOOL inward = ratio <= 0.90;
    if (!outward && !inward) return;
    // Real direction is known from two independent contacts. A wrong
    // direction never toggles: pinch OUT expands, pinch IN restores.
    id<SCPFullscreenControlling> adapter = [SCPPinchController shared].adapter;
    SCPFullscreenState state = adapter.currentState;
    SCPCarPane *nowA = [split paneAtSlot:[a[@"slot"] integerValue]];
    SCPCarPane *nowB = [split paneAtSlot:[b[@"slot"] integerValue]];
    if (!nowA || !nowB ||
        ![nowA.bundleID isEqualToString:a[@"bundle"]] ||
        ![nowB.bundleID isEqualToString:b[@"bundle"]]) {
        sHostPinchPairFired = YES;
        OMCLogWrite(@"SplitScreen", @"[car-pinch] drop reason=assignment-changed");
        return;
    }
    BOOL correct = (outward && state == SCPFullscreenStateSplit) ||
                   (inward && state == SCPFullscreenStateExpanded);
    sHostPinchPairFired = YES; // one command maximum per physical pair
    if (!correct) {
        OMCLogWrite(@"SplitScreen", [NSString stringWithFormat:
            @"[car-pinch] direction-reject dir=%@ state=%ld ratio=%.3f",
            outward ? @"out" : @"in", (long)state, ratio]);
        return;
    }
    OMCLogWrite(@"SplitScreen", [NSString stringWithFormat:
        @"[car-pinch] request dir=%@ state=%ld ratio=%.3f drift=%.1f",
        outward ? @"expand" : @"restore", (long)state, ratio, drift]);
    if (outward) {
        [adapter requestExpandWithCompletion:^(BOOL applied) {
            OMCLogWrite(@"SplitScreen", [NSString stringWithFormat:
                @"[car-pinch] expand applied=%d newState=%ld",
                (int)applied, (long)adapter.currentState]);
        }];
    } else {
        [adapter requestRestoreWithCompletion:^(BOOL applied) {
            OMCLogWrite(@"SplitScreen", [NSString stringWithFormat:
                @"[car-pinch] restore applied=%d newState=%ld",
                (int)applied, (long)adapter.currentState]);
        }];
    }
}

static void SCPHostPinchObserve(UIEvent *event) {
    if (event.type != UIEventTypeTouches) return;
    SCPCarSplit *split = [SCPCarSplit shared];
    UIWindow *carWindow = split.container.window;
    const void *containerRef = (__bridge const void *)split.container;
    const void *windowRef = (__bridge const void *)carWindow;
    if (sHostPinchContainer != containerRef || sHostPinchWindow != windowRef) {
        SCPHostPinchReset();
        sHostPinchContainer = containerRef;
        sHostPinchWindow = windowRef;
    }
    if (!split.active || !carWindow || ![split bwCarHostPinchEnabled]) {
        if (SCPHostPinchContacts().count) SCPHostPinchReset();
        return;
    }

    NSMutableDictionary *contacts = SCPHostPinchContacts();
    NSMutableArray<NSValue *> *endedKeys = [NSMutableArray array];
    for (UITouch *touch in event.allTouches) {
        NSValue *key = [NSValue valueWithPointer:(const void *)touch];
        switch (touch.phase) {
        case UITouchPhaseBegan: {
            if (contacts[key] || SCPHostPinchPopupBusy(split)) break;
            CGPoint pt; UIScreen *screen = nil;
            if (!SCPProbeTouchScreenPoint(touch, &pt, &screen) ||
                screen != carWindow.screen ||
                SCPProbeIsHomeCorner(pt, screen) ||
                (touch.window &&
                 [NSStringFromClass(touch.window.class)
                    isEqualToString:@"DBStatusBarWindow"])) break;
            SCPCarPane *pane = nil;
            SCPProbePaneAtScreenPoint(pt, screen, &pane);
            if (!pane || !pane.bundleID.length) break;
            contacts[key] = [@{ @"start": [NSValue valueWithCGPoint:pt],
                                @"current": [NSValue valueWithCGPoint:pt],
                                @"at": @(event.timestamp),
                                @"slot": @(pane.slot),
                                @"bundle": pane.bundleID } mutableCopy];
            break;
        }
        case UITouchPhaseMoved:
        case UITouchPhaseStationary:
        case UITouchPhaseEnded:
        case UITouchPhaseCancelled: {
            NSMutableDictionary *rec = contacts[key];
            if (rec) {
                CGPoint pt; UIScreen *screen = nil;
                if (SCPProbeTouchScreenPoint(touch, &pt, &screen) &&
                    screen == carWindow.screen)
                    rec[@"current"] = [NSValue valueWithCGPoint:pt];
                if (touch.phase == UITouchPhaseMoved)
                    rec[@"moves"] = @([rec[@"moves"] integerValue] + 1);
            }
            if (touch.phase == UITouchPhaseCancelled)
                sHostPinchPairKilled = YES;
            if (touch.phase == UITouchPhaseEnded ||
                touch.phase == UITouchPhaseCancelled)
                [endedKeys addObject:key];
            break;
        }
        default:
            break;
        }
    }

    if (contacts.count == 0) {
        SCPHostPinchReset();  // never carry touches into another gesture
        return;
    }
    SCPHostPinchEvaluate(split, contacts, event.timestamp,
                         endedKeys.count != 0);
    if (endedKeys.count && sHostPinchPairOpen &&
        SCPHL8TraceEnabled() && sHL8CurrentPair) {
        NSDictionary *a = contacts[sHostPinchKey1];
        NSDictionary *b = contacts[sHostPinchKey2];
        if (a && b) {
            CGPoint p1 = [a[@"current"] CGPointValue];
            CGPoint p2 = [b[@"current"] CGPointValue];
            OMCLogWrite(@"SplitScreen", [NSString stringWithFormat:
                @"[hl8diag] eye=pinch ev=terminal pair=%llu d0=%.1f "
                 "dEnd=%.1f moves=%ld/%ld fired=%d killed=%d",
                (unsigned long long)sHL8CurrentPair,
                (double)sHostPinchStartDistance,
                (double)SCPHostPinchDistance(p1, p2),
                (long)[a[@"moves"] integerValue],
                (long)[b[@"moves"] integerValue],
                (int)sHostPinchPairFired, (int)sHostPinchPairKilled]);
        }
    }
    for (NSValue *key in endedKeys)
        [contacts removeObjectForKey:key];
    if (contacts.count == 0) SCPHostPinchReset();
}

// ============================================================================
// [gpt-hl7-native-wake] Native CarPlay wake FIRST-touch ownership.
//
// HL7 car log 12:25:48/55: [probe-feed] fired on native Maps and the
// user's first tap still operated the app. The old observer ran only
// AFTER orig_UIApplication_sendEvent. While AutoHide is faded, intercept
// ONLY a fresh single physical Began in a live native pane, reveal
// controls before forwarding, and consume that UITouch chain. Hosted
// panes keep their existing app-side Gate3 wake/swallow path.
//
// This path does not add an overlay, alter UITouch/UIEvent, consume
// unrelated touches, or suppress an already-visible native pane.
// It may not intercept independent delivery in CarPlayTemplateUIHost;
// the next device log/visual test must prove the behaviour separately.
// ============================================================================
static NSMutableSet<NSValue *> *SCPNativeWakeCaptured(void) {
    static NSMutableSet<NSValue *> *captured;
    static dispatch_once_t once;
    dispatch_once(&once, ^{ captured = [NSMutableSet set]; });
    return captured;
}
static const void *sNativeWakeContainer;
static const void *sNativeWakeWindow;
static NSTimeInterval sNativeWakeLastDownAt;
static CGPoint sNativeWakeLastDownPt;
static NSString *sNativeWakeLastBundle;

static void SCPNativeWakeReset(void) {
    [SCPNativeWakeCaptured() removeAllObjects];
    sNativeWakeLastDownAt = -1.0;
    sNativeWakeLastDownPt = CGPointZero;
    sNativeWakeLastBundle = nil;
}

static BOOL SCPNativeWakePreflight(UIEvent *event) {
    if (!event || event.type != UIEventTypeTouches) return NO;
    SCPCarSplit *split = [SCPCarSplit shared];
    UIWindow *carWindow = split.container.window;
    const void *containerRef = (__bridge const void *)split.container;
    const void *windowRef = (__bridge const void *)carWindow;
    if (sNativeWakeContainer != containerRef ||
        sNativeWakeWindow != windowRef) {
        SCPNativeWakeReset();
        sNativeWakeContainer = containerRef;
        sNativeWakeWindow = windowRef;
    }
    if (!split.active || !carWindow) {
        if (SCPNativeWakeCaptured().count) SCPNativeWakeReset();
        return NO;
    }
    NSArray<UITouch *> *all = event.allTouches.allObjects;
    if (all.count == 0) return NO;
    NSMutableSet<NSValue *> *captured = SCPNativeWakeCaptured();
    NSUInteger owned = 0;
    for (UITouch *t in all)
        if ([captured containsObject:[NSValue valueWithPointer:(const void *)t]])
            owned++;
    if (owned != 0) {
        BOOL onlyOwned = owned == all.count;
        for (UITouch *t in all) {
            if (t.phase == UITouchPhaseEnded || t.phase == UITouchPhaseCancelled)
                [captured removeObject:[NSValue valueWithPointer:(const void *)t]];
        }
        if (!onlyOwned) {
            // An unrelated finger/gesture is now in the same UIEvent;
            // never withhold its input just to hide a consumed finger.
            OMCLogWrite(@"SplitScreen",
                @"[native-wake] mixed event fail-open (unrelated touch present)");
            return NO;
        }
        return YES;
    }

    NSString *hl8Popup = SCPProbePopupSub(split);
    if (all.count > 2 || hl8Popup) {
        if (SCPHL8TraceEnabled())
            OMCLogWrite(@"SplitScreen", [NSString stringWithFormat:
                @"[hl8diag] eye=native-wake ev=gate decision=forward "
                 "reason=%@ contacts=%lu",
                hl8Popup ?: @"three-contacts",
                (unsigned long)all.count]);
        return NO;
    }
    CGPoint representative = CGPointZero;
    BOOL haveRepresentative = NO;
    NSString *bundle = nil;
    for (UITouch *touch in all) {
        if (touch.phase != UITouchPhaseBegan) return NO;
        CGPoint pt; UIScreen *screen = nil;
        if (!SCPProbeTouchScreenPoint(touch, &pt, &screen) ||
            screen != carWindow.screen ||
            SCPProbeIsHomeCorner(pt, screen) ||
            [NSStringFromClass(touch.window.class)
                isEqualToString:@"DBStatusBarWindow"]) return NO;
        SCPCarPane *pane = nil;
        SCPProbePaneAtScreenPoint(pt, screen, &pane);
        if (!pane || !pane.bundleID.length || SCPVCIsHosted(pane.vc)) {
            if (SCPHL8TraceEnabled())
                OMCLogWrite(@"SplitScreen", [NSString stringWithFormat:
                    @"[hl8diag] eye=native-wake ev=gate decision=forward "
                     "reason=%@ pane=%ld bundle=%@ faded=%d",
                    !pane || !pane.bundleID.length ? @"no-live-pane"
                        : @"hosted-pane-owned-by-app",
                    (long)(pane ? pane.slot : -1),
                    pane.bundleID ?: @"none", (int)[split ahFaded]]);
            return NO; // supported/native pane ONLY
        }
        if (haveRepresentative &&
            (SCPHostPinchDistance(pt, representative) > 12.0 ||
             ![bundle isEqualToString:pane.bundleID]))
            return NO; // two real fingers must pass, not be swallowed
        representative = pt;
        haveRepresentative = YES;
        bundle = pane.bundleID;
    }
    if (!haveRepresentative) return NO;

    BOOL faded = [split ahFaded];
    BOOL mirrored = !faded &&
        event.timestamp >= sNativeWakeLastDownAt &&
        event.timestamp - sNativeWakeLastDownAt <= 0.080 &&
        SCPHostPinchDistance(representative, sNativeWakeLastDownPt) <= 12.0 &&
        [bundle isEqualToString:sNativeWakeLastBundle];
    if (!faded && !mirrored) {
        if (SCPHL8TraceEnabled())
            OMCLogWrite(@"SplitScreen", [NSString stringWithFormat:
                @"[hl8diag] eye=native-wake ev=gate decision=forward "
                 "reason=controls-visible bundle=%@ position=%@",
                bundle, NSStringFromCGPoint(representative)]);
        return NO;
    }
    for (UITouch *touch in all)
        [captured addObject:[NSValue valueWithPointer:(const void *)touch]];
    if (faded) {
        sNativeWakeLastDownAt = event.timestamp;
        sNativeWakeLastDownPt = representative;
        sNativeWakeLastBundle = [bundle copy];
        // On CarPlayApp's main sendEvent path. Restore the faded
        // controls before the original UIKit dispatch could deliver
        // this one-tap chain to the native/template scene.
        [split ahNoteActivity:AHSourceContainer];
    }
    OMCLogWrite(@"SplitScreen", [NSString stringWithFormat:
        @"[native-wake] swallow=%@ bundle=%@ pt=%@ contacts=%lu nowFaded=%d",
        mirrored ? @"mirror" : @"first", bundle,
        NSStringFromCGPoint(representative), (unsigned long)all.count,
        (int)[split ahFaded]]);
    if (SCPHL8TraceEnabled())
        OMCLogWrite(@"SplitScreen", [NSString stringWithFormat:
            @"[hl8diag] eye=native-wake ev=gate decision=consume "
             "reason=%@ bundle=%@ contacts=%lu",
            mirrored ? @"mirror-of-first" : @"first-tap-while-faded",
            bundle, (unsigned long)all.count]);
    return YES;
}


static uint64_t sHL8TouchSeq;
static uint64_t SCPHL8DescribeBegan(UIEvent *event) {
    if (!SCPHL8TraceEnabled() || event.type != UIEventTypeTouches)
        return 0;
    SCPCarSplit *split = [SCPCarSplit shared];
    if (!split.active || !split.container.window) return 0;
    uint64_t seq = 0;
    for (UITouch *touch in event.allTouches) {
        if (touch.phase != UITouchPhaseBegan) continue;
        if (!seq) seq = ++sHL8TouchSeq;
        CGPoint pt = CGPointZero;
        UIScreen *screen = nil;
        BOOL valid = SCPProbeTouchScreenPoint(touch, &pt, &screen);
        SCPCarPane *pane = nil;
        if (valid) SCPProbePaneAtScreenPoint(pt, screen, &pane);
        UIButton *btn = split.homeButton;
        CGRect logoRect = CGRectNull;
        if (btn && btn.window && valid && screen == btn.window.screen)
            logoRect = [btn convertRect:CGRectInset(btn.bounds, -5, -5)
                       toCoordinateSpace:screen.coordinateSpace];
        BOOL inLogo = !CGRectIsNull(logoRect) &&
                      CGRectContainsPoint(logoRect, pt);
        NSString *kind = !pane ? @"outside" :
            SCPVCIsHosted(pane.vc) ? @"hosted" : @"native";
        OMCLogWrite(@"SplitScreen", [NSString stringWithFormat:
            @"[hl8diag] eye=touch ev=begin id=%llu t=%.3f win=%@ "
             "pos=%@ valid=%d pane=%ld bundle=%@ kind=%@ active=%d "
             "faded=%d inLogo=%d logoRect=%@ logoAlpha=%.2f "
             "logoOpacity=%.2f logoHidden=%d logoUI=%d",
            (unsigned long long)seq, event.timestamp,
            touch.window ? NSStringFromClass(touch.window.class) : @"nil",
            NSStringFromCGPoint(pt), (int)valid,
            (long)(pane ? pane.slot : -1), pane.bundleID ?: @"-",
            kind, (int)split.active, (int)[split ahFaded],
            (int)inLogo, NSStringFromCGRect(logoRect),
            btn ? (double)btn.alpha : -1.0,
            btn ? (double)btn.layer.opacity : -1.0,
            btn ? (int)btn.hidden : -1,
            btn ? (int)btn.userInteractionEnabled : -1]);
    }
    return seq;
}

// CarPlayApp-local visibility only. Absence here is BLIND for other
// process-owned keyboard windows, never evidence of system absence.
static void SCPHL8KeyboardViewScan(NSString *source) {
    if (!SCPHL8TraceEnabled()) return;
    NSUInteger matches = 0;
    NSMutableString *views = [NSMutableString string];
    for (UIWindow *w in [UIApplication sharedApplication].windows) {
        NSString *cls = NSStringFromClass(w.class);
        if ([cls containsString:@"Keyboard"] ||
            [cls containsString:@"TextEffects"] ||
            [cls containsString:@"InputSet"]) {
            matches++;
            if (views.length < 300)
                [views appendFormat:@"%@:%@:%d;", cls,
                     NSStringFromCGRect(w.frame), (int)w.hidden];
        }
    }
    OMCLogWrite(@"SplitScreen", [NSString stringWithFormat:
        @"[hl8diag] eye=kb-car ev=window-scan source=%@ scope=CarPlayApp "
         "keyboardWindows=%lu sample=%@ noMatchMeans=BLIND",
        source, (unsigned long)matches, views]);
}
static void SCPHL8KeyboardNotification(NSNotification *note) {
    if (!SCPHL8TraceEnabled()) return;
    CGRect frame = [note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    OMCLogWrite(@"SplitScreen", [NSString stringWithFormat:
        @"[hl8diag] eye=kb-car ev=notification name=%@ frame=%@ "
         "screen=%@ splitActive=%d",
        note.name, NSStringFromCGRect(frame),
        NSStringFromCGRect([UIScreen mainScreen].bounds),
        (int)[SCPCarSplit shared].active]);
    SCPHL8KeyboardViewScan(note.name);
}

// First-tap native wake is the ONLY intercept; all other touches use orig.
static void Hook_UIApplication_sendEvent(id self, SEL _cmd, UIEvent *event) {
    uint64_t hl8TouchID = 0;
    BOOL consumed = NO;
    @try {
        hl8TouchID = SCPHL8DescribeBegan(event);
        consumed = SCPNativeWakePreflight(event);
    } @catch (id e) {
        OMCLogWrite(@"SplitScreen",
            @"[native-wake] preflight exception; fail-open to UIKit");
        consumed = NO;
    }
    if (!consumed) orig_UIApplication_sendEvent(self, _cmd, event);
    if (hl8TouchID && SCPHL8TraceEnabled())
        OMCLogWrite(@"SplitScreen", [NSString stringWithFormat:
            @"[hl8diag] eye=touch ev=dispatch id=%llu path=%@ "
             "fadedAfter=%d",
            (unsigned long long)hl8TouchID,
            consumed ? @"swallowed-before-orig" : @"forwarded-to-orig",
            (int)[[SCPCarSplit shared] ahFaded]]);
    @try {
        SCPProbeObserveEvent(event); // original telemetry, unchanged
        if (!consumed) SCPHostPinchObserve(event);
    } @catch (id e) {
        OMCLogWrite(@"SplitScreen",
            @"[car-pinch] observer exception; no event mutation");
    }
}

void SCPTouchProbeInstall(void) {
    static BOOL installed = NO;
    if (installed) return;
    installed = YES;
    MSHookMessageEx(objc_getClass("UIApplication"), @selector(sendEvent:),
                    (IMP)Hook_UIApplication_sendEvent,
                    (IMP *)&orig_UIApplication_sendEvent);
    if (SCPHL8TraceEnabled()) {
        NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
        for (NSString *name in @[UIKeyboardWillShowNotification,
                                  UIKeyboardDidShowNotification,
                                  UIKeyboardDidChangeFrameNotification,
                                  UIKeyboardWillHideNotification]) {
            [nc addObserverForName:name object:nil
                            queue:[NSOperationQueue mainQueue]
                       usingBlock:^(NSNotification *note) {
                           SCPHL8KeyboardNotification(note);
                       }];
        }
        OMCLogWrite(@"SplitScreen",
            @"[hl8diag] eye=car ev=installed schema=1 "
             "domains=touch,pinch,native-wake,logo,kb-car,layout");
        SCPHL8KeyboardViewScan(@"install");
    }
    OMCLogWrite(@"SplitScreen", [NSString stringWithFormat:
        @"[probe] sendEvent installed pid=%d (passive probe + host pinch + native wake gate)",
        getpid()]);
}
