// SCPCarSplit+AutoHide.m — AutoHide controller (design-autohide.md §3–§4).
//
// One session-wide 4.0 s idle timer for the whole split (QA20's shape:
// per-split, not per-pane), fed by the activity points of design §3.2,
// painting layer.opacity = 0 onto every CarPlay-side control (pane
// handles, dividers + their knobs, the home/logo button) with the
// QA20/QA19 save/restore discipline. The hosted mirrors are NOT painted
// from here: this TU flips the single ahFaded flag and forces a frame /
// knob push; the part-2 strand puts the flag into the payloads
// (hostFrameInfo `fade`, publishKnobsNow `kfade`) and ABHost applies it.
//
// State lives in file statics of this TU (the wake1 owner precedent).
// This TU never touches barTimer/trayTimer/ratioTimer, never calls
// setBarVisible:forPane:, and never writes hidden/alpha/
// userInteractionEnabled (design §2.5).

#import "SCPCarSplit+AutoHide.h"
#import "SCPCarSplit+BridgeWake.h" // bwRecomputeForPane:, bwExpandedActive
#import "SCPCommon.h"              // OMCLogWrite, OMCPref
#import <objc/runtime.h>
#import <QuartzCore/QuartzCore.h>

NS_ASSUME_NONNULL_BEGIN

@interface SCPCarSplit (AutoHidePrivate)
- (void)ahTimerFired:(NSTimer *)timer;
@end

NS_ASSUME_NONNULL_END

static const NSTimeInterval kAHIdleSeconds    = 4.0;  // QA20/QA19: 4.0 s
// [ytz5] Legacy act-hold expiry (design §4.2): since package YTZ5 no
// code path arms the act hold any more — the fade gate reads the
// BWInputStore aggregate via the BridgeWake TU — so this constant
// and the ahKbHoldState/ahKbHoldExpiry statics below survive only
// as lifecycle state that start/teardown/close-cleanup reset.
static const NSTimeInterval kAHKbHoldSeconds  = 10.0; // design §4.2 expiry

static BOOL           ahInstalled      = NO;
static BOOL           ahConfigKnown    = NO;
static BOOL           ahEnabled        = YES; // pref absent = ON (§3.5)
static BOOL           ahFadedState     = NO;
static BOOL           ahSuspendedState = NO;
static BOOL           ahKbHoldState    = NO;
static NSTimer       *ahTimerRef       = nil;
static CFTimeInterval ahLastActivityAt = 0;
static AHActivitySource ahLastSource   = AHSourceContainer;
static CFTimeInterval ahKbHoldExpiry   = 0;
static NSHashTable<UIView *> *ahPaintedViews = nil; // weak; restore registry
static char           ahSavedOpacityKey;

static const char *AHSourceName(AHActivitySource src) {
    switch (src) {
        case AHSourceContainer:  return "container";
        case AHSourceHostHandle: return "hosthandle";
        case AHSourceHostKnob:   return "hostknob";
        case AHSourceHome:       return "home";
        case AHSourceApp:        return "app";
        case AHSourceDragEnd:    return "dragend";
    }
    return "?";
}

static const char *AHRevealName(AHRevealReason reason) {
    switch (reason) {
        case AHRevealActivity:  return "activity";
        case AHRevealWake:      return "wake";
        case AHRevealUnsuspend: return "unsuspend";
        case AHRevealPrefOff:   return "prefoff";
    }
    return "?";
}

#pragma mark - Painting (design §2.5 discipline)

// Save/restore is per view, via an associated object (QA20's pattern):
// painting a view that already has a save NEVER overwrites the save, so
// the value restored later is always the true pre-fade opacity.
static void AHPaintView(UIView *_Nullable view, BOOL faded) {
    if (view == nil) return;
    NSNumber *saved = objc_getAssociatedObject(view, &ahSavedOpacityKey);
    if (faded) {
        if (saved == nil) {
            objc_setAssociatedObject(view, &ahSavedOpacityKey,
                @(view.layer.opacity), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            [ahPaintedViews addObject:view];
        }
        view.layer.opacity = 0.0f;
    } else if (saved != nil) {
        view.layer.opacity = saved.floatValue;
        objc_setAssociatedObject(view, &ahSavedOpacityKey, nil,
            OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        [ahPaintedViews removeObject:view];
    }
}

@implementation SCPCarSplit (AutoHide)

// The CarPlay-side paint set (design §2.1): every pane's handle, every
// divider AND its knob (two separate views, two separate saves — the
// QA20 fix for QA19's still-visible knob), and the home/logo button.
// Explicitly excluded: self.ratioKnob (temporary ratio popup's own
// knob — QA20 excludes it verbatim), pane.bar (own original timer),
// launcherHost (may hold other dock-cluster elements; only the button
// itself is ours to paint).
- (void)ahPaintCurrentSet {
    for (SCPCarPane *pane in [self allPanes])
        AHPaintView(pane.handle, YES);
    for (SCPCarDividerView *divider in self.dividers) {
        AHPaintView(divider, YES);
        AHPaintView(divider.knob, YES);
    }
    AHPaintView(self.homeButton, YES);
}

// Restore EVERY view this TU has ever painted in this session —
// including views that have since left the current paint set (a pane
// closed while faded, a replaced home button) — so no view can carry
// opacity 0 into another layout/session (design §2.5 rule 3).
- (void)ahRestoreAllPainted {
    for (UIView *view in ahPaintedViews.allObjects)
        AHPaintView(view, NO);
}

#pragma mark - Timer

- (void)ahInvalidateTimer {
    [ahTimerRef invalidate];
    ahTimerRef = nil;
}

- (void)ahArmTimer {
    [self ahInvalidateTimer];
    if (!ahInstalled || !ahEnabled || !self.active || ahSuspendedState)
        return;
    ahTimerRef = [NSTimer scheduledTimerWithTimeInterval:kAHIdleSeconds
        target:self selector:@selector(ahTimerFired:) userInfo:nil
        repeats:NO];
}

// Fire-time gates (design §4.2) — evaluated ONLY when the timer fires,
// never continuously. Every fact read here already exists in
// SCPCarSplit; no new signal is invented. Returns a static reason
// string when fading is blocked, nil when it may proceed.
- (const char *)ahFadeBlockedReason {
    // [ytz4-hb] the expanded-state block is gone (GPT ytz4 ruling,
    // item 2 point 2): fading runs while the session is EXPANDED, as in
    // split. The popup / dragging / keyboard-hold blocks below are
    // unchanged, and hosted-solo still blocks via "solo" (and via
    // the ahSetSuspended: suspension driven from SCPCarSplit.m).
    if (self.soloHostedBundle != nil) return "solo";
    // [ytz5] Kb block (package YTZ5, strand B5): the gate reads the
    // SAME kb truth the owner publishes — the BWInputStore aggregate
    // over the live HOSTED assignments (accessor on the BridgeWake
    // TU; hosted determined by the pane table's hostedPanes). The
    // old global act-fed ahKbHoldState is no longer read here: an
    // act flag=0 from app A used to clear app B's hold, and opening
    // a keyboard produced no act at all (the 17:32 fade of map-m3).
    //   aggregate 2 (some hosted assignment freshly ACTIVE)
    //     -> block, reason "kb";
    //   aggregate 1 (no ACTIVE, some hosted assignment UNKNOWN)
    //     -> block, reason "kbunknown" — YTZ5 rule: a hosted
    //        assignment whose input state is not yet known HOLDS
    //        the controls rather than failing open;
    //   aggregate 0 (every hosted assignment freshly INACTIVE)
    //     -> no kb block.
    NSInteger kbAgg = [self bwKbAggregateForHostedPanes];
    if (kbAgg == 2) return "kb";
    if (kbAgg == 1) {
        OMCLogWrite(@"SplitScreen", @"[autohide] hold reason=kbunknown");
        return "kbunknown";
    }
    if ([self popupOpen] || self.pickerSheet != nil ||
        self.ratioMenu != nil ||
        (self.tray != nil && !self.trayOverlay))
        return "surface-open";
    if (self.resizing || self.dragGhost != nil) return "dragging";
    return nil;
}

- (void)ahTimerFired:(NSTimer *)timer {
    (void)timer;
    ahTimerRef = nil;
    if (!ahEnabled || !self.active || ahSuspendedState || ahFadedState)
        return;
    const char *blocked = [self ahFadeBlockedReason];
    if (blocked != nil) {
        // Do not drop the cycle: re-evaluate one idle period later
        // (design §4.2 — popup/keyboard/drag may have ended by then).
        OMCLogWrite(@"SplitScreen", [NSString stringWithFormat:
            @"[autohide] fade deferred (%s)", blocked]);
        [self ahArmTimer];
        return;
    }
    ahFadedState = YES;
    [self ahPaintCurrentSet];
    // Push the new flag to the hosted mirrors in the same beat
    // (payload keys themselves are wired by the part-2 strand).
    [self pushHostFramesLive:NO];
    [self publishKnobsSoon];
    for (SCPCarPane *pane in [self hostedPanes])
        [self bwRecomputeForPane:pane];
    OMCLogWrite(@"SplitScreen", [NSString stringWithFormat:
        @"[autohide] fade last=%s idle=%.2f",
        AHSourceName(ahLastSource),
        CACurrentMediaTime() - ahLastActivityAt]);
}

// Shared reveal body (design §3.4): restore CarPlay opacity, push the
// cleared flag to the mirrors, and let the wake owner re-aggregate —
// HIDDEN just stopped being true for every hosted pane.
- (void)ahRevealBody:(AHRevealReason)reason {
    if (!ahFadedState) return;
    ahFadedState = NO;
    // WO W1 evidence point: count the CarPlay-side views actually
    // carrying a saved opacity BEFORE restoring, so the log proves
    // the reveal landed on this side. The hosted mirrors are a
    // different strand's surface: they receive the cleared flag
    // through the pushHostFramesLive:NO hand-off below (the
    // hostFrameInfo `fade` key), not from this TU.
    NSUInteger restored = 0;
    for (UIView *view in ahPaintedViews.allObjects)
        if (objc_getAssociatedObject(view, &ahSavedOpacityKey) != nil)
            restored++;
    [self ahRestoreAllPainted];
    [self pushHostFramesLive:NO];
    [self publishKnobsSoon];
    for (SCPCarPane *pane in [self hostedPanes])
        [self bwRecomputeForPane:pane];
    OMCLogWrite(@"SplitScreen", [NSString stringWithFormat:
        @"[autohide] reveal-applied reason=%s views=%lu",
        AHRevealName(reason), (unsigned long)restored]);
}

#pragma mark - Public interface

- (void)ahInstall {
    if (ahInstalled) return;
    ahInstalled = YES;
    if (ahPaintedViews == nil)
        ahPaintedViews = [NSHashTable weakObjectsHashTable];
    ahLastActivityAt = CACurrentMediaTime();
    [self ahReloadConfig]; // also arms the timer when enabled + active
    OMCLogWrite(@"SplitScreen", [NSString stringWithFormat:
        @"[autohide] install enabled=%d", ahEnabled ? 1 : 0]);
}

- (void)ahNoteActivity:(AHActivitySource)source {
    if (![NSThread isMainThread]) {
        dispatch_async(dispatch_get_main_queue(),
            ^{ [self ahNoteActivity:source]; });
        return;
    }
    if (!ahInstalled || !ahEnabled || !self.active || ahSuspendedState)
        return;
    ahLastActivityAt = CACurrentMediaTime();
    ahLastSource = source;
    if (ahFadedState) [self ahRevealBody:AHRevealActivity];
    // Always re-arm, even while visible: the 4.0 s clock runs from the
    // LAST activity (QA20/QA19 discipline, design §1.2).
    [self ahArmTimer];
}

- (void)ahNoteActWithKbActive:(BOOL)kbActive {
    if (![NSThread isMainThread]) {
        dispatch_async(dispatch_get_main_queue(),
            ^{ [self ahNoteActWithKbActive:kbActive]; });
        return;
    }
    // [ytz5] The act packet's kb flag no longer sets or clears any
    // kb truth (package YTZ5, strand B5): the fade gate reads the
    // BWInputStore aggregate, which only authenticated kbstate
    // reports may move. An act packet — flag 1 or 0, from any app —
    // is purely app activity now; in particular a flag=0 act can no
    // longer clear another app's keyboard hold.
    (void)kbActive;
    (void)kAHKbHoldSeconds; // legacy constant retained (see statics note)
    [self ahNoteActivity:AHSourceApp];
}

// [ytz5] Kb hold release: the hosted aggregate just fell to 0 (the
// last ACTIVE input session ended, or the last UNKNOWN resolved to
// a fresh INACTIVE). The idle clock restarts from THIS moment — not
// from the activity that preceded the keyboard session — so the
// controls get a full fresh 4.0 s before they may fade.
- (void)ahNoteKbHoldReleased {
    if (![NSThread isMainThread]) {
        dispatch_async(dispatch_get_main_queue(),
            ^{ [self ahNoteKbHoldReleased]; });
        return;
    }
    if (!ahInstalled) return;
    ahLastActivityAt = CACurrentMediaTime();
    ahLastSource = AHSourceApp;
    [self ahArmTimer]; // self-guards on enabled/active/suspended
    OMCLogWrite(@"SplitScreen", @"[autohide] kb hold released -> idle reset");
}

- (void)ahRevealWithReason:(AHRevealReason)reason {
    if (![NSThread isMainThread]) {
        dispatch_async(dispatch_get_main_queue(),
            ^{ [self ahRevealWithReason:reason]; });
        return;
    }
    if (!ahInstalled) return;
    [self ahRevealBody:reason];
    // A wake is the strongest form of activity (design §3.4): restart
    // the idle clock (ahArmTimer self-guards on enabled/active/suspend).
    [self ahArmTimer];
}

- (void)ahSetSuspended:(BOOL)suspended {
    if (![NSThread isMainThread]) {
        dispatch_async(dispatch_get_main_queue(),
            ^{ [self ahSetSuspended:suspended]; });
        return;
    }
    if (!ahInstalled || ahSuspendedState == suspended) return;
    ahSuspendedState = suspended;
    if (suspended) {
        [self ahInvalidateTimer];
        // [ytz4-hb] Suspension is now hosted-solo only (EXPANDED no
        // longer suspends — GPT ytz4 ruling): solo must start from a
        // known visual state: restore any fade BEFORE the solo takes
        // over (design §4.1).
        if (ahFadedState) [self ahRevealBody:AHRevealUnsuspend];
        OMCLogWrite(@"SplitScreen", @"[autohide] suspend");
    } else {
        // Back to SPLIT visible, with a fresh 4.0 s clock from the exit
        // — no instant fade, no time debt from before (design §4.1).
        OMCLogWrite(@"SplitScreen", @"[autohide] resume");
        [self ahArmTimer];
    }
}

- (BOOL)ahFaded {
    return ahFadedState;
}

- (void)ahReloadConfig {
    if (![NSThread isMainThread]) {
        dispatch_async(dispatch_get_main_queue(),
            ^{ [self ahReloadConfig]; });
        return;
    }
    id raw = OMCPref(@"bridgewake.autoHide", nil);
    BOOL enabled = raw ? [raw boolValue] : YES; // absent = ON (§3.5)
    if (ahConfigKnown && enabled == ahEnabled) return;
    ahConfigKnown = YES;
    ahEnabled = enabled;
    OMCLogWrite(@"SplitScreen", [NSString stringWithFormat:
        @"[autohide] config enabled=%d", ahEnabled ? 1 : 0]);
    if (!ahEnabled) {
        // Never leave an orphaned fade behind its own off switch.
        [self ahInvalidateTimer];
        if (ahFadedState) [self ahRevealBody:AHRevealPrefOff];
    } else {
        [self ahArmTimer];
    }
}

- (void)ahSessionStarted {
    if (![NSThread isMainThread]) {
        dispatch_async(dispatch_get_main_queue(),
            ^{ [self ahSessionStarted]; });
        return;
    }
    if (!ahInstalled) return;
    // [ytz5] Session-start resets (CHANGE_MAP_YTZ5 M1): a new session
    // must not inherit the previous session's kb-hold bookkeeping or
    // activity source. The faded flag is deliberately NOT reset here
    // — paint saves live on the views themselves and are restored by
    // the close-path cleanup (ahCloseCleanup) / teardown, not by a
    // flag reset that would orphan them (map-m1 §5.2).
    ahKbHoldState = NO;
    ahKbHoldExpiry = 0;
    ahLastSource = AHSourceContainer;
    ahLastActivityAt = CACurrentMediaTime();
    [self ahArmTimer];
    OMCLogWrite(@"SplitScreen", @"[autohide] session start");
}

- (void)ahSessionTeardown {
    if (![NSThread isMainThread]) {
        dispatch_async(dispatch_get_main_queue(),
            ^{ [self ahSessionTeardown]; });
        return;
    }
    [self ahInvalidateTimer];
    BOOL wasFaded = ahFadedState;
    ahFadedState = NO;
    [self ahRestoreAllPainted];
    ahKbHoldState = NO;
    ahKbHoldExpiry = 0; // [ytz5] M1: expiry resets together with the hold
    ahSuspendedState = NO;
    OMCLogWrite(@"SplitScreen", [NSString stringWithFormat:
        @"[autohide] teardown faded=%d", wasFaded ? 1 : 0]);
}

// [ytz5] Close cleanup for the ordinary close path (closeGoingHome:),
// CHANGE_MAP_YTZ5 M1. Same lifecycle semantics as ahSessionTeardown
// (stop timer + restore paint + clear session state) but callable
// synchronously at the head of closeGoingHome:, BEFORE hostCloseAll
// and any detach — the views of the dying session are still in the
// hierarchy here, so the restore lands on live views instead of
// silently no-oping through the weak registry after teardown.
// Deliberately NOT ahRevealBody:: no pushHostFramesLive:, no
// publishKnobsSoon, no bwRecomputeForPane:, and no timer re-arm —
// the session is ending, not waking. The destination mode owns what
// comes next: a hosted-solo target re-suspends AFTER this cleanup
// (soloBundle: sets ahSetSuspended:YES after its closeGoingHome:
// call — GPT ruling 2026-11-09 18:45), so suspended is reset here
// unconditionally. Idempotent; never arms the timer.
- (void)ahCloseCleanup {
    if (![NSThread isMainThread]) {
        // Synchronous hop: the caller's ordering guarantee (cleanup
        // strictly before hostCloseAll) must survive the thread hop.
        dispatch_sync(dispatch_get_main_queue(),
            ^{ [self ahCloseCleanup]; });
        return;
    }
    [self ahInvalidateTimer];
    BOOL wasFaded = ahFadedState;
    ahFadedState = NO;
    [self ahRestoreAllPainted];       // direct restore, registry mechanism
    [ahPaintedViews removeAllObjects]; // registry explicitly empty afterwards
    ahKbHoldState = NO;
    ahKbHoldExpiry = 0;
    ahSuspendedState = NO;
    ahLastActivityAt = 0;
    ahLastSource = AHSourceContainer;
    OMCLogWrite(@"SplitScreen", [NSString stringWithFormat:
        @"[autohide] close-cleanup faded=%d", wasFaded ? 1 : 0]);
}

- (void)ahApplyCurrentStateToView:(UIView *)view {
    if (view == nil || !ahInstalled) return;
    if (![NSThread isMainThread]) {
        dispatch_async(dispatch_get_main_queue(),
            ^{ [self ahApplyCurrentStateToView:view]; });
        return;
    }
    AHPaintView(view, ahFadedState);
}

@end
