// SCPCarSplit+BridgeWake.m — bridgewake.v1 state owner (design §1–§4, §6).
//
// NEW code for the QA180 wake port; nothing here reconstructs original
// 1.0.3 behaviour (the original has no global controls state — audit
// work/wake-round/audit-runtime.md Q5). The owner lives in the
// CarPlayApp process inside SCPCarSplit (design §0/Q2). It aggregates
// the per-pane wake state (§1.2), arbitrates pinch vs wake (§2), speaks
// the bridgewake.v1 Darwin protocol (BridgeWakePack.h, §3) and takes
// its two feature modes from prefs (§4). ABHost only confirms (§6); the
// app side only consumes. All new log lines carry the [wake1] prefix.
//
// Storage note: bwGenBySlot[10] and the rest of the per-slot owner
// state are file statics of this TU keyed by SCPCarPane.slot (0..9,
// float pane = 9) — see SCPCarSplit+BridgeWake.h for why they are not
// new ivars on SCPCarSplit/SCPCarPane.

#import "SCPCarSplit+BridgeWake.h"
#import "SCPCarSplit+AutoHide.h" // [autohide] faded input + act/wake/suspend wiring (design-autohide §3.3–§3.4, §4.1, §5.1)
#import "SCPPinchController.h" // [pinch1] arbiter conformance + chain-suppressed glue flag
#import "SCPShared.h"
#import "SCPCommon.h" // OMCLogWrite / OMCPref (module-local header)
#import <notify.h>

#pragma mark - Owner state (file statics, keyed by slot 0..9)

static uint32_t       bwGenBySlot[10];        // design §1.3: 1..4095, wraps
static NSInteger      bwStateBySlot[10];      // BWState*; starts INACTIVE(0)
static NSString      *bwBundleBySlot[10];     // last bundle seen per slot
static NSTimeInterval bwAssignAtBySlot[10];   // last assignment change
static BOOL           bwWakePendingBySlot[10];// WAKING transaction open
static uint16_t       bwWakeSeqBySlot[10];    // seq of the open transaction
static NSTimeInterval bwWakeAtBySlot[10];     // when it opened
static uint16_t       bwHandledSeq[10][16];   // design §3.3: last 16 wake
static uint8_t        bwHandledCount[10];     //   seqs handled per slot
static uint8_t        bwHandledIdx[10];       //   (count guards seq 0)
static uint64_t       bwEmitSigBySlot[10];    // last emitted packet shape
static __weak SCPCarPane *bwPaneBySlot[10];   // last pane object per slot

static uint16_t       bwStateSeq;             // owner state seq (§3.2)
static NSInteger      bwWakeMode  = BWModeDryRun;   // §4: absent = DRY_RUN
static NSInteger      bwPinchMode = BWModeEnforce;  // absent = ENFORCE since
// 2026-11-09 (Nguyen: pinch wired live, staging removed — see reload).
static NSArray<NSString *> *bwPinchAllowlist;       // §2.2 (nil = absent =
// no restriction: every eligible pane; an array = only its members)
static BOOL           bwExpandedFlag;               // §2.1 input (A1: no
static NSString      *bwExpandedBundle;             //   producer this round)
static BOOL           bwAutoHideEnabled = YES;      // [autohide] owner's cached
// read of bridgewake.autoHide (absent = ON, design-autohide §3.5); the
// AutoHide TU keeps its own copy via ahReloadConfig, refreshed at the
// same point (bwReloadModesAndRepublish).
static BOOL           bwInstalled;
static unsigned       bwDroppedWakeCount;           // §3.4 V7-style drops

static int bwStateSendToken;   // notify_register_check tokens (sending)
static int bwAckSendToken;
static int bwQueryRecvToken;   // notify_register_dispatch tokens (receiving)
static int bwWakeRecvToken;
static int bwAckRecvToken;
static int bwActRecvToken;     // [autohide] bridgewake.v1.act receiver
static int bwPrefsRecvToken;

#pragma mark - Small helpers

static NSTimeInterval BWNow(void) { return [NSDate date].timeIntervalSince1970; }

static NSString *BWStateName(NSInteger s) {
    switch (s) {
        case BWStateInactive: return @"INACTIVE";
        case BWStateUnknown:  return @"UNKNOWN";
        case BWStateVisible:  return @"VISIBLE";
        case BWStateHidden:   return @"HIDDEN";
        case BWStateWaking:   return @"WAKING";
        default:              return @"?";
    }
}

// Generations live in 1..4095 and wrap to 1 (design §1.3/§3.2).
static uint32_t BWGenNext(uint32_t gen) { return gen % 4095 + 1; }

// Emission signature: everything in the state packet except seq/hash —
// a change in ANY of these (state, arbitration flag, modes, gen) must
// re-emit even when bwState itself did not move (design §1.3 point 6).
static uint64_t BWEmitSig(NSInteger state, BOOL pinch, NSInteger wm,
                          NSInteger pm, uint32_t gen) {
    return (uint64_t)(state & 0x7) | ((uint64_t)(pinch ? 1 : 0) << 3) |
           ((uint64_t)(wm & 0x3) << 4) | ((uint64_t)(pm & 0x3) << 6) |
           ((uint64_t)gen << 8);
}

static BOOL BWSlotValid(SCPCarPane *pane) {
    return pane != nil && pane.slot >= 0 && pane.slot < 10;
}

// Reverse hash lookup (design §3.3): the slot whose CURRENT bundle hashes
// to hash28, or -1. The owner never trusts the hash alone — callers
// re-check the candidate bundle against the pane table afterwards.
static NSInteger BWSlotForHash28(uint32_t hash28) {
    for (NSInteger s = 0; s < 10; s++)
        if (bwBundleBySlot[s] && BWBundleHash28(bwBundleBySlot[s]) == hash28)
            return s;
    return -1;
}

static BOOL BWSeqHandled(NSInteger slot, uint16_t seq) {
    for (int i = 0; i < bwHandledCount[slot]; i++)
        if (bwHandledSeq[slot][i] == seq) return YES;
    return NO;
}
static void BWSeqRecord(NSInteger slot, uint16_t seq) {
    bwHandledSeq[slot][bwHandledIdx[slot] % 16] = seq;
    bwHandledIdx[slot]++;
    if (bwHandledCount[slot] < 16) bwHandledCount[slot]++;
}

#pragma mark - Emission (single poster for the state channel)

// The ONLY notify_set_state/notify_post pair for the state channel in
// this module (design §7.1 Gate 1). bwEmitStateForPane: and the
// teardown/OFF paths all funnel through here.
static void BWEmitStatePacket(NSString *bundle, uint32_t gen, NSInteger state,
                              BOOL pinchAllowed, NSInteger wm, NSInteger pm) {
    if (!bundle.length) return;
    if (!bwStateSendToken)
        notify_register_check(SCPBridgeWakeState, &bwStateSendToken);
    bwStateSeq = (uint16_t)((bwStateSeq + 1) & 0xFFF);
    uint64_t packet = BWPackFields(BWBundleHash28(bundle), bwStateSeq, gen,
                                   pinchAllowed, (unsigned)pm, (unsigned)wm,
                                   (unsigned)state, BWTypeState);
    notify_set_state(bwStateSendToken, packet);
    notify_post(SCPBridgeWakeState);
    OMCLogWrite(@"SplitScreen", [NSString stringWithFormat:
        @"[wake1] bw emit %@ state=%@ gen=%u seq=%u wm=%ld pm=%ld pinch=%d",
        bundle, BWStateName(state), gen, bwStateSeq, (long)wm, (long)pm,
        (int)pinchAllowed]);
}

// §4 failure path: owner-side error -> one UNKNOWN packet per known
// bundle with both modes forced OFF, so apps fail open immediately.
static void BWForceOffBroadcast(void) {
    for (NSInteger s = 0; s < 10; s++)
        if (bwBundleBySlot[s])
            BWEmitStatePacket(bwBundleBySlot[s], bwGenBySlot[s],
                              BWStateUnknown, NO, BWModeOff, BWModeOff);
}

// [pinch1] Glue flag for the pinch controller's gate 4 (design-pinch
// §3.3/§3.5): the controller's `externalChainSuppressed` is maintained
// from the owner-side equivalent truth — a wake transaction open on
// ANY slot (bwWakePendingBySlot, i.e. that pane's state is WAKING and
// the app-side chain for it is being held by suppression). There is NO
// separate cross-process "chain suppressed" signal visible inside
// CarPlayApp; WAKING *is* that signal on this side, so nothing new is
// invented. Refreshed at every point that opens/closes a transaction.
static void BWPublishChainSuppressed(void) {
    BOOL any = NO;
    for (NSInteger s = 0; s < 10; s++)
        if (bwWakePendingBySlot[s]) { any = YES; break; }
    [SCPPinchController shared].externalChainSuppressed = any;
}

#pragma mark - Emit queue (design §3.3 mitigation (i): 30 ms spacing)

static NSMutableArray<NSString *> *bwEmitQueue;
static BOOL bwEmitDrainScheduled;

static void BWEmitDrain(void) {
    NSString *bundle = bwEmitQueue.firstObject;
    if (!bundle) { bwEmitDrainScheduled = NO; return; }
    [bwEmitQueue removeObjectAtIndex:0];
    SCPCarSplit *owner = [SCPCarSplit shared];
    SCPCarPane *pane = [owner paneForBundle:bundle];
    if (!pane) {
        NSInteger s = BWSlotForHash28(BWBundleHash28(bundle));
        if (s >= 0) pane = bwPaneBySlot[s];
    }
    if (pane) [owner bwEmitStateForPane:pane];
    SCPDispatchAfter(0.03, ^{ BWEmitDrain(); });
}

@implementation SCPCarSplit (BridgeWake)

- (void)bwQueueEmitForPane:(SCPCarPane *)pane {
    NSString *bundle = pane.bundleID ?: (BWSlotValid(pane) ? bwBundleBySlot[pane.slot] : nil);
    if (!bundle.length) return;
    if (!bwEmitQueue) bwEmitQueue = [NSMutableArray array];
    if (![bwEmitQueue containsObject:bundle]) [bwEmitQueue addObject:bundle];
    if (!bwEmitDrainScheduled) {
        bwEmitDrainScheduled = YES;
        BWEmitDrain();
    }
}

- (void)bwEmitStateForPane:(SCPCarPane *)pane {
    if (!BWSlotValid(pane)) return;
    NSInteger slot = pane.slot;
    NSString *bundle = bwBundleBySlot[slot] ?: pane.bundleID;
    if (!bundle.length) return;
    NSInteger state = bwStateBySlot[slot];
    BOOL pinch = [self bwPinchAllowedForPane:pane];
    BWEmitStatePacket(bundle, bwGenBySlot[slot], state, pinch,
                      bwWakeMode, bwPinchMode);
    bwEmitSigBySlot[slot] = BWEmitSig(state, pinch, bwWakeMode, bwPinchMode,
                                      bwGenBySlot[slot]);
}

// Re-emit the state of every hosted pane (query answers §3.3(iii),
// mode/EXPANDED changes §1.3 point 6) — spaced by the emit queue.
- (void)bwEmitAllHostedStates {
    for (SCPCarPane *pane in [self hostedPanes]) [self bwQueueEmitForPane:pane];
}

#pragma mark - Arbitration (design §2.2)

// popup(p): a panel (tray / ratio menu / picker sheet) is open, or
// ANOTHER pane's bar is up. popupOpen is NOT used: it includes this
// pane's own bar via anyBarVisible, which would ban pinch exactly in
// the SPLIT+VISIBLE row where pinch may be allowed.
- (BOOL)bwPopupForPane:(SCPCarPane *)pane {
    if ([self panelOpen]) return YES;
    for (SCPCarPane *other in self.allPanes)
        if (other != pane && other.bar != nil && !other.bar.isHidden)
            return YES;
    return NO;
}

- (BOOL)bwPinchAllowedForPane:(SCPCarPane *)pane {
    if (!BWSlotValid(pane)) return NO;
    NSString *bundle = pane.bundleID;
    if (!bundle.length) return NO;
    // EXPANDED row: pinch-in has priority, allowlist does not apply.
    if (bwExpandedFlag && [bundle isEqualToString:bwExpandedBundle])
        return YES;
    // Every other row requires the pane VISIBLE (HIDDEN belongs to
    // wake; UNKNOWN/INACTIVE/WAKING fail open with pinchAllowed = 0).
    if (bwStateBySlot[pane.slot] != BWStateVisible) return NO;
    if ([self bwPopupForPane:pane]) return NO;
    if (self.resizing) return NO; // native divider gesture in flight
    // Allowlist (2026-11-09): absent (nil) = every eligible pane; only
    // a present array restricts, and then membership decides.
    return bwPinchAllowlist ? [bwPinchAllowlist containsObject:bundle] : YES;
}

- (void)bwSetExpandedActive:(BOOL)active forBundle:(NSString *)bundleID {
    bwExpandedFlag = active;
    bwExpandedBundle = active ? [bundleID copy] : nil;
    OMCLogWrite(@"SplitScreen", [NSString stringWithFormat:
        @"[wake1] bw expanded %@ (%@)", active ? @"ON" : @"OFF",
        bundleID ?: @"-"]);
    // [autohide] EXPANDED suspends the fade machine at this same point
    // (design-autohide §4.1): suspending restores any fade first so
    // fullscreen starts from a known visual state; unsuspending starts
    // visible with a fresh 4.0 s clock.
    [self ahSetSuspended:active];
    // §1.3 point 6: an EXPANDED change re-runs aggregation for all.
    for (SCPCarPane *pane in [self hostedPanes]) [self bwRecomputeForPane:pane];
}

- (BOOL)bwExpandedActive { return bwExpandedFlag; }

#pragma mark - Aggregation (design §1.2/§1.3)

- (void)bwRecomputeForPane:(SCPCarPane *)pane {
    if (!BWSlotValid(pane)) return;
    NSInteger slot = pane.slot;
    NSTimeInterval now = BWNow();
    NSString *bundle = pane.bundleID;
    bwPaneBySlot[slot] = pane;

    // Generation bookkeeping (§1.3): a slot whose bundle changes (new
    // assignment or teardown to nil) advances its generation; the
    // first assignment starts at 1.
    if (![bundle ?: @"" isEqualToString:bwBundleBySlot[slot] ?: @""]) {
        bwGenBySlot[slot] = bwGenBySlot[slot] ? BWGenNext(bwGenBySlot[slot]) : 1;
        bwBundleBySlot[slot] = [bundle copy];
        bwAssignAtBySlot[slot] = now;
        bwWakePendingBySlot[slot] = NO;
    }

    NSInteger old = bwStateBySlot[slot];
    NSInteger state;
    BOOL assigned = self.active && bundle.length &&
                    [[self hostedPanes] containsObject:pane];
    if (!assigned) {
        bwWakePendingBySlot[slot] = NO;
        state = BWStateInactive;
    } else if (bwWakePendingBySlot[slot]) {
        state = BWStateWaking; // exit via ABHost confirm or 1.0 s deadline
    } else {
        BOOL liveSeen = !CGRectIsNull(pane.hostFrame);
        BOOL live = pane.hostHandle;
        BOOL barHidden = (pane.bar == nil || pane.bar.isHidden);
        // transient (§1.2): bar fade-out in flight (model alpha already
        // 0, hidden not yet set — the completion recomputes), split
        // relayout/resize running, or the pane was reassigned < 0.25 s
        // ago. bar.isHidden alone NEVER decides (§1.2 hard rule / B1).
        BOOL fading = pane.bar != nil && !pane.bar.isHidden &&
                      pane.bar.alpha == 0;
        BOOL transient = fading || self.resizing ||
                         (now - bwAssignAtBySlot[slot] < 0.25);
        if (!liveSeen || !live || transient) {
            state = BWStateUnknown;
        } else if (barHidden) {
            // [autohide] HIDDEN now also requires the fade
            // (design-autohide §3.3): fadedEffective = autohideEnabled
            // ? ahFaded : YES, so with AutoHide off the definition is
            // exactly wake1's (bar-only). Bar down but NOT yet faded is
            // not HIDDEN — handles/knob/logo are still on screen — so
            // the pane reports VISIBLE; a wake landing in that window
            // still re-shows the bar on the accepted path below.
            BOOL fadedEffective = !bwAutoHideEnabled || [self ahFaded];
            if ([self bwPopupForPane:pane]) state = BWStateUnknown;
            else if (fadedEffective) state = BWStateHidden;
            else state = BWStateVisible;
        } else {
            state = BWStateVisible;
        }
        // EXPANDED (§2.2 first row): never HIDDEN while expanded.
        // UNKNOWN stays UNKNOWN — fail-open beats a guessed VISIBLE.
        if (state == BWStateHidden && bwExpandedFlag &&
            [bundle isEqualToString:bwExpandedBundle])
            state = BWStateVisible;
        // Hash collision between two live panes (§3.3): both go
        // UNKNOWN (fail-open) rather than risk a misrouted state.
        if (state != BWStateUnknown) {
            uint32_t h = BWBundleHash28(bundle);
            for (SCPCarPane *other in [self hostedPanes])
                if (other != pane && other.bundleID.length &&
                    BWBundleHash28(other.bundleID) == h) {
                    state = BWStateUnknown;
                    OMCLogWrite(@"SplitScreen", [NSString stringWithFormat:
                        @"[wake1] bw hash collision %@ slot %ld -> UNKNOWN",
                        bundle, (long)slot]);
                    break;
                }
        }
    }

    if (state != old) {
        bwStateBySlot[slot] = state;
        OMCLogWrite(@"SplitScreen", [NSString stringWithFormat:
            @"[wake1] bw state %@ %@->%@ gen=%u", bundle ?: @"-",
            BWStateName(old), BWStateName(state), bwGenBySlot[slot]]);
    }
    // Emit when the packet SHAPE changed (state, arbitration, modes,
    // gen) — not only when the state enum moved (§1.3 point 6).
    BOOL pinch = [self bwPinchAllowedForPane:pane];
    uint64_t sig = BWEmitSig(bwStateBySlot[slot], pinch, bwWakeMode,
                             bwPinchMode, bwGenBySlot[slot]);
    if (sig != bwEmitSigBySlot[slot]) [self bwQueueEmitForPane:pane];
}

- (void)bwSessionTeardown {
    // §1.3 call group 3 ("setActive:NO"): generations advance (split
    // restart semantics), every known slot goes INACTIVE, one emission
    // per pane whose object is still around; orphan slots fail open on
    // the app side by state freshness (§4) — nothing can be addressed
    // without a bundle, and the bundle is what is being torn down.
    for (NSInteger s = 0; s < 10; s++) {
        if (!bwBundleBySlot[s]) continue;
        bwGenBySlot[s] = BWGenNext(bwGenBySlot[s]);
        bwWakePendingBySlot[s] = NO;
        bwStateBySlot[s] = BWStateInactive;
        bwBundleBySlot[s] = nil;
        SCPCarPane *pane = bwPaneBySlot[s];
        if (pane) {
            // Emit INACTIVE under the bundle just torn down.
            BWEmitStatePacket(pane.bundleID, bwGenBySlot[s],
                              BWStateInactive, NO, bwWakeMode, bwPinchMode);
            bwEmitSigBySlot[s] = BWEmitSig(BWStateInactive, NO, bwWakeMode,
                                           bwPinchMode, bwGenBySlot[s]);
        }
    }
    BWPublishChainSuppressed(); // [pinch1] all transactions closed above
    OMCLogWrite(@"SplitScreen", @"[wake1] bw session teardown -> INACTIVE");
}

#pragma mark - Modes (design §4)

- (void)bwReloadModesAndRepublish {
    // The owner (CarPlayApp, the tweak's own process — not an App
    // Store sandbox) is the ONLY reader of these prefs; apps learn the
    // modes solely from state packets. Wake: absent = DRY_RUN (as
    // designed). Pinch: absent = ENFORCE — Nguyen's decision
    // 2026-11-09 ("bỏ staging, nối pinch luôn"): pinch is a live
    // feature by default now; an explicit pref still wins, so
    // pinchMode = 0/1 remains available as an off/dry-run switch.
    id w = OMCPref(@"bridgewake.wakeMode", nil);
    id p = OMCPref(@"bridgewake.pinchMode", nil);
    bwWakeMode  = w ? MIN(MAX([w integerValue], 0), 2) : BWModeDryRun;
    bwPinchMode = p ? MIN(MAX([p integerValue], 0), 2) : BWModeEnforce;
    id al = OMCPref(@"bridgewake.pinchAllowlist", nil);
    if ([al isKindOfClass:[NSArray class]]) {
        NSMutableArray<NSString *> *clean = [NSMutableArray array];
        for (id item in (NSArray *)al)
            if ([item isKindOfClass:[NSString class]]) [clean addObject:item];
        bwPinchAllowlist = [clean copy];
    } else {
        // Absent (or malformed) = nil: NO restriction — every pane
        // that passes the state/popup/resizing checks above is
        // eligible (2026-11-09, same decision as the pinch default).
        bwPinchAllowlist = nil;
    }
    // [autohide] the AutoHide kill-switch rides the same prefs read
    // (design-autohide §3.5): absent = ON. The owner's cached copy
    // drives fadedEffective in bwRecomputeForPane:; the AutoHide TU
    // re-reads its own copy via ahReloadConfig at this same point
    // (switching off while faded restores everything immediately).
    id ah = OMCPref(@"bridgewake.autoHide", nil);
    bwAutoHideEnabled = ah ? [ah boolValue] : YES;
    [self ahReloadConfig];
    OMCLogWrite(@"SplitScreen", [NSString stringWithFormat:
        @"[wake1] bw modes wake=%ld pinch=%ld allowlist=%@ autohide=%d",
        (long)bwWakeMode, (long)bwPinchMode,
        bwPinchAllowlist ? [NSString stringWithFormat:@"%lu",
            (unsigned long)bwPinchAllowlist.count] : @"all",
        (int)bwAutoHideEnabled]);
    // Mode changes re-run aggregation for every hosted pane (§1.3
    // point 6); the emit signature carries the modes, so any change
    // re-emits even when the state enum itself does not move.
    for (SCPCarPane *pane in [self hostedPanes]) [self bwRecomputeForPane:pane];
}

#pragma mark - Inbound packets (design §3/§6)

- (void)bwHandleQueryPacket:(uint64_t)raw {
    BWPacket pkt = BWUnpack(raw);
    if (!pkt.valid || pkt.type != BWTypeQuery) return;
    // §1.3 point 7 + §3.3(iii): re-emit every hosted pane's state,
    // spaced by the emit queue; the query itself changes no state.
    [self bwEmitAllHostedStates];
}

- (void)bwHandleWakePacket:(uint64_t)raw {
    BWPacket pkt = BWUnpack(raw);
    if (!pkt.valid || pkt.type != BWTypeWake) return;
    NSInteger slot = BWSlotForHash28(pkt.hash28);
    if (slot < 0) { bwDroppedWakeCount++; return; }
    // Stale generation (V7): a wake from before a reconnect/reassign
    // must not resurrect controls. Counted, not error-logged (§3.4).
    if (pkt.gen != bwGenBySlot[slot]) {
        bwDroppedWakeCount++;
        OMCLogWrite(@"SplitScreen", [NSString stringWithFormat:
            @"[wake1] bw wake dropped stale gen=%u cur=%u (total %u)",
            pkt.gen, bwGenBySlot[slot], bwDroppedWakeCount]);
        return;
    }
    if (BWSeqHandled(slot, pkt.seq)) return; // §3.3: one wake, one handling
    NSString *bundle = bwBundleBySlot[slot];
    // §3.3 double-check: the hash's candidate bundle must still be the
    // bundle actually assigned AND hosted right now.
    SCPCarPane *pane = [self paneForBundle:bundle];
    if (!pane || pane.slot != slot ||
        ![[self hostedPanes] containsObject:pane]) {
        bwDroppedWakeCount++;
        return;
    }
    NSInteger state = bwStateBySlot[slot];
    if (state != BWStateHidden && state != BWStateVisible) {
        // UNKNOWN/WAKING/INACTIVE: fail-open — no bar call, no ack;
        // the app times out on its side and stays open (§5.4/§6).
        bwDroppedWakeCount++;
        OMCLogWrite(@"SplitScreen", [NSString stringWithFormat:
            @"[wake1] bw wake dropped state=%@ bundle=%@ (total %u)",
            BWStateName(state), bundle, bwDroppedWakeCount]);
        return;
    }
    BWSeqRecord(slot, pkt.seq);
    // §2.3 isolation: the wake handler ONLY drives the Chrome show
    // path. It never posts a pinch command, never touches solo/zoom.
    [self setBarVisible:YES forPane:pane];
    // [autohide] reveal path 2 (design-autohide §3.4): an accepted
    // wake restores the FULL chrome set together with the bar — the
    // AutoHide TU un-paints handles/dividers/knobs/logo and pushes the
    // fade change to the hosted mirrors. Safe when nothing is faded.
    [self ahRevealWithReason:AHRevealWake];
    if (state == BWStateVisible) {
        // Controls were already up; the wake's goal is met — ack at
        // once (role=0, state=VISIBLE, echo seq — vector V5 shape).
        if (!bwAckSendToken)
            notify_register_check(SCPBridgeWakeAck, &bwAckSendToken);
        uint64_t ack = BWPackFields(pkt.hash28, pkt.seq, pkt.gen, NO,
                                    0, 0, BWStateVisible, BWTypeAck);
        notify_set_state(bwAckSendToken, ack);
        notify_post(SCPBridgeWakeAck);
        return;
    }
    // HIDDEN -> WAKING: wait for ABHost's applied-chrome confirm (§6).
    bwWakePendingBySlot[slot] = YES;
    bwWakeSeqBySlot[slot] = pkt.seq;
    bwWakeAtBySlot[slot] = BWNow();
    [self bwRecomputeForPane:pane]; // stores + emits WAKING
    BWPublishChainSuppressed(); // [pinch1] a chain is now held (WAKING)
    __weak SCPCarSplit *weakSelf = self;
    SCPDispatchAfter(1.0, ^{
        // §6 deadline: no confirm within 1.0 s -> back to UNKNOWN,
        // emit it, never retry this wake.
        if (!bwWakePendingBySlot[slot] || bwWakeSeqBySlot[slot] != pkt.seq)
            return;
        bwWakePendingBySlot[slot] = NO;
        BWPublishChainSuppressed(); // [pinch1] transaction closed by deadline
        bwStateBySlot[slot] = BWStateUnknown;
        OMCLogWrite(@"SplitScreen", [NSString stringWithFormat:
            @"[wake1] bw wake confirm timeout seq=%u bundle=%@ -> UNKNOWN",
            pkt.seq, bundle]);
        SCPCarPane *p = [weakSelf paneForBundle:bundle];
        if (p) [weakSelf bwQueueEmitForPane:p];
    });
}

// [autohide] Inbound `act` (design-autohide §3.2.1): the hosted app's
// activity relay (ABInApp posts from its existing sendEvent probe,
// throttled 0.12 s on its side). Validation mirrors the wake path —
// hash resolves a CURRENT bundle, the generation must match the
// slot's live generation (a packet from before a reconnect/reassign
// is stale), and the candidate bundle must still be assigned AND
// hosted. The packet's flag is the app session's kbActive truth; the
// AutoHide TU owns the hold itself (arm/refresh/10 s self-expiry).
// This handler NEVER posts anything (anti-loop rule, §3.2.1).
- (void)bwHandleActPacket:(uint64_t)raw {
    BWPacket pkt = BWUnpack(raw);
    if (!pkt.valid || pkt.type != BWTypeAct) return;
    NSInteger slot = BWSlotForHash28(pkt.hash28);
    if (slot < 0) return;
    if (pkt.gen != bwGenBySlot[slot]) return; // stale session (§3.2.1)
    NSString *bundle = bwBundleBySlot[slot];
    SCPCarPane *pane = [self paneForBundle:bundle];
    if (!pane || pane.slot != slot ||
        ![[self hostedPanes] containsObject:pane])
        return;
    [self ahNoteActWithKbActive:pkt.flag];
}

- (void)bwHandleAckPacket:(uint64_t)raw {
    BWPacket pkt = BWUnpack(raw);
    if (!pkt.valid || pkt.type != BWTypeAck) return;
    if (!pkt.flag) return; // role=0 is owner->app; not addressed to us
    NSInteger slot = BWSlotForHash28(pkt.hash28);
    if (slot < 0) return;
    // §6: the confirm must match the open WAKING transaction exactly.
    if (!bwWakePendingBySlot[slot] || pkt.seq != bwWakeSeqBySlot[slot] ||
        pkt.gen != bwGenBySlot[slot])
        return;
    bwWakePendingBySlot[slot] = NO;
    BWPublishChainSuppressed(); // [pinch1] transaction closed by ABHost confirm
    NSString *bundle = bwBundleBySlot[slot];
    SCPCarPane *pane = [self paneForBundle:bundle];
    if (BWStateNormalise(pkt.state) == BWStateVisible) {
        // Chrome really applied visible: settle the pane VISIBLE,
        // emit the fresh state, then ack the app (V6 -> V5, §3.4).
        bwStateBySlot[slot] = BWStateVisible;
        OMCLogWrite(@"SplitScreen", [NSString stringWithFormat:
            @"[wake1] bw wake confirmed seq=%u bundle=%@", pkt.seq, bundle]);
        if (pane) [self bwQueueEmitForPane:pane];
        if (!bwAckSendToken)
            notify_register_check(SCPBridgeWakeAck, &bwAckSendToken);
        uint64_t ack = BWPackFields(pkt.hash28, pkt.seq, pkt.gen, NO,
                                    0, 0, BWStateVisible, BWTypeAck);
        notify_set_state(bwAckSendToken, ack);
        notify_post(SCPBridgeWakeAck);
    } else {
        // ABHost could not confirm (UNKNOWN): demote, emit, no app
        // ack — the app fails open on its ack timeout (§5.4/§6).
        bwStateBySlot[slot] = BWStateUnknown;
        OMCLogWrite(@"SplitScreen", [NSString stringWithFormat:
            @"[wake1] bw wake unconfirmed seq=%u bundle=%@ -> UNKNOWN",
            pkt.seq, bundle]);
        if (pane) [self bwQueueEmitForPane:pane];
    }
}

#pragma mark - Install (design §7.1: registered from __init_1)

- (void)bwInstallOwner {
    if (bwInstalled) return;
    bwInstalled = YES;
    @try {
        SCPCarSplit *owner = self;
        notify_register_dispatch(SCPBridgeWakeQuery, &bwQueryRecvToken,
            dispatch_get_main_queue(), ^(int token) {
                uint64_t raw = 0;
                notify_get_state(token, &raw);
                [owner bwHandleQueryPacket:raw];
            });
        notify_register_dispatch(SCPBridgeWakeWake, &bwWakeRecvToken,
            dispatch_get_main_queue(), ^(int token) {
                uint64_t raw = 0;
                notify_get_state(token, &raw);
                [owner bwHandleWakePacket:raw];
            });
        notify_register_dispatch(SCPBridgeWakeAck, &bwAckRecvToken,
            dispatch_get_main_queue(), ^(int token) {
                uint64_t raw = 0;
                notify_get_state(token, &raw);
                [owner bwHandleAckPacket:raw];
            });
        // [autohide] the fifth channel (design-autohide §3.2.1):
        // hosted-app activity for the fade machine. Receive-only here —
        // the owner never posts on it.
        notify_register_dispatch(SCPBridgeWakeAct, &bwActRecvToken,
            dispatch_get_main_queue(), ^(int token) {
                uint64_t raw = 0;
                notify_get_state(token, &raw);
                [owner bwHandleActPacket:raw];
            });
        // Mode source (§4): the existing prefs-changed Darwin name.
        notify_register_dispatch(SCPNotePrefsChanged.UTF8String,
            &bwPrefsRecvToken, dispatch_get_main_queue(), ^(int token) {
                (void)token;
                [owner bwReloadModesAndRepublish];
            });
        [self bwReloadModesAndRepublish];
        // [pinch1] arbitration glue: the owner IS the pinch arbiter
        // (design-pinch §3.5); publish the initial chain flag (none held).
        [SCPPinchController shared].arbiter = self;
        BWPublishChainSuppressed();
        OMCLogWrite(@"SplitScreen", @"[wake1] bw owner installed (CarPlayApp)");
    } @catch (NSException *ex) {
        // §4: an owner-side failure must not leave apps believing a
        // mode/state that no longer exists — broadcast OFF once.
        OMCLogWrite(@"SplitScreen", [NSString stringWithFormat:
            @"[wake1] bw owner install failed: %@ -> broadcast OFF", ex]);
        BWForceOffBroadcast();
    }
}

#pragma mark - Pinch arbitration (SCPPinchArbiter — design-pinch §3.5)

// Mode source is the owner's prefs read (§4); values share the packet
// encoding 0/1/2. Anything outside is OFF (the controller also clamps).
- (SCPPinchMode)pinchMode {
    if (bwPinchMode < 0 || bwPinchMode > 2) return SCPPinchModeOff;
    return (SCPPinchMode)bwPinchMode;
}

// The arbiter's cached copy of the EXPANDED input (§2.1/§3.5), fed
// by bwSetExpandedActive:forBundle: — since fs1 its producer is
// SCPFullscreenController, which reports every settle there.
- (BOOL)hostIsExpanded { return bwExpandedFlag; }

// Answered purely from the owner's stored per-slot state (the same
// state packed into state packets) + the EXPANDED input. The
// controller's own (bundle, scene) allowlist is its gate 5 and is NOT
// consulted here; the owner's packet-flag allowlist (bwPinchAllowed-
// ForPane:) serves the app-side probe, a different surface.
//
// touchesSuppressed: the controller passes its view of the glue flag
// (gate 4's input, which the controller enforces itself via cleanOK).
// The owner needs no separate answer for it: on this side, "a chain
// for this pane is being held by suppression" is exactly the pane's
// WAKING transaction (bwWakePendingBySlot), and while it is open the
// stored state IS BWStateWaking, which the switch below maps to
// BlockedUnknown. No new channel is invented for it.
- (SCPArbiterDisposition)pinchDispositionForPane:(SCPCarPane *)pane
                               touchesSuppressed:(BOOL)anyTouchSuppressed {
    (void)anyTouchSuppressed;
    if (!BWSlotValid(pane)) return SCPArbiterPinchBlockedUnknown;
    // EXPANDED row (§2.2): pinch-in has priority, wake suppression off.
    if (bwExpandedFlag && [pane.bundleID isEqualToString:bwExpandedBundle])
        return SCPArbiterPinchAllowed;
    switch (bwStateBySlot[pane.slot]) {
        case BWStateHidden:
            return SCPArbiterPinchBlockedHidden; // SPLIT+HIDDEN: wake wins
        case BWStateVisible:
            // popup / native divider gesture in flight -> fail open.
            if ([self bwPopupForPane:pane] || self.resizing)
                return SCPArbiterPinchBlockedUnknown;
            return SCPArbiterPinchAllowed;
        default: // INACTIVE / UNKNOWN / WAKING (incl. an open wake txn)
            return SCPArbiterPinchBlockedUnknown;
    }
}

@end
