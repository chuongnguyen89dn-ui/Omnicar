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
#import "../SplitScreenC/BWInputStore.h" // [ytz5] pure-C authenticated input-session store (package YTZ5, strand B5)
#import <notify.h>
#import <CoreFoundation/CoreFoundation.h> // [ytz5] pinch migration writes via CFPreferences (OMCCommon domain)

@interface SCPCarSplit (BridgeWakePrivate)
- (void)bwRenewTick:(NSTimer *)timer;
- (void)bwRenewMaintain;
- (void)bwKbEmitForPane:(SCPCarPane *)pane;
- (void)bwHandleKbStateNote:(NSNotification *)note;
- (void)bwHandlePinchNote:(NSNotification *)note;
- (void)bwApplyAssignmentForSlot:(NSInteger)slot bundle:(NSString *)bundle;
- (void)bwCheckKbHoldRelease;
@end

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
static NSInteger      bwPinchMode = BWModeOff;      // [ytz5] absent = OFF
// [hl2-split G6] Gate 3 scoped trial + in-app pinch packet mode,
// re-read at every bwReloadModesAndRepublish: the trial rewrote the
// wakeMode of ONE bundle's state packets to ENFORCE (the global
// bwWakeMode above stayed the default for every other pane), and the
// packet pinchMode of hosted panes comes from bridgewake.pinchInApp
// (absent = ENFORCE) instead of the legacy bwPinchMode — the legacy
// CarPlayApp recognizer keeps reading bwPinchMode through the
// arbiter, so exactly one pinch shooter is live per mode source.
// [hl4] Scope expansion (PATCH 29.24): the hl3 car session proved
// the trial (12/12 correct swallows, 0 false — 29.23), so the
// per-bundle trial is RETIRED: with the kill-switch ON, EVERY hosted
// pane's state packet carries wakeMode ENFORCE. The pref
// bridgewake.gate3TrialBundle no longer has any role and is not
// read; bwGate3TrialEnabled survives as the global kill-switch
// (bridgewake.gate3Trial: absent = ON, 0 = OFF -> every pane falls
// back to the global bwWakeMode layer).
static BOOL           bwGate3TrialEnabled = YES;    // kill-switch pref
static NSInteger      bwPinchInAppMode = BWModeEnforce;
static uint64_t       bwGate3TrialSigBySlot[10];    // last logged shape
static unsigned       bwGate3TrialEmitCount;        // ENFORCE packets sent
// (an ENFORCE default shipped briefly on 2026-11-09 under Nguyen's
// "noi pinch luon" order; GPT's post-fs1 audit WO superseded it —
// ENFORCE is reachable only via an explicit pref until the fullscreen
// controller has independent device acceptance. See reload below.)
// [ytz5] Package YTZ5 pinch ruling: the pinch reader's absent
// default is OFF (was DRY_RUN), and a one-time targeted migration
// in bwReloadModesAndRepublish rewrites a stored non-OFF pinchMode
// to 0 exactly once (marker bridgewake.pinchOffMigratedYtz5).
static NSArray<NSString *> *bwPinchAllowlist;       // §2.2 (nil = absent =
// no restriction: every eligible pane; an array = only its members)
static BOOL           bwExpandedFlag;               // §2.1 input; since
// fs1 its producer is SCPFullscreenController (settle points only).
static NSString      *bwExpandedBundle;             // WO P1: LOG ONLY —
// EXPANDED is a session state (the controller reports forBundle:nil
// because fullscreen covers the whole split); arbitration never
// compares a pane's bundle against this value any more.
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
static NSTimer       *bwRenewTimer;    // WO W2: state renewal (1.0 s)

// [ytz5] Authenticated keyboard truth (package YTZ5, strand B5 —
// replaces the ytz4-hb per-slot BOOL arrays). Three-state model —
// UNKNOWN / INACTIVE / ACTIVE — never collapsed, held in the pure-C
// BWInputStore (SplitScreenC/BWInputStore.h) so the Gate harness
// exercises the exact validation the owner runs. A record belongs
// to one (hash, gen) assignment identity: BWInputSlotAssign/Clear
// run at every assignment lifecycle event (see
// bwApplyAssignmentForSlot:bundle:), and the ONLY writer of records
// is bwHandleKbStateNote: — the hosted app's own input session
// reporting on the NSDistributed kbstate channel. A record decays
// to UNKNOWN 3.5 s after its last accepted report; re-emission by
// the owner never refreshes it.
static BWInputStore bwInputStore;
static BOOL         bwInputStoreReady;
static NSInteger    bwKbAggPrev; // last hosted aggregate seen by the
// hold-release watcher (bwCheckKbHoldRelease): a fall from non-zero
// to 0 restarts AutoHide's idle clock at the release moment.

static void BWEnsureInputStore(void) {
    if (!bwInputStoreReady) {
        BWInputStoreInit(&bwInputStore);
        bwInputStoreReady = YES;
    }
}

// The kbstate distributed channel (NSDistributed, app -> owner):
// {hash, gen, session, seq, state, t}. Defined locally — SCPShared
// is outside this strand's file scope, and the string must match
// the app side's poster byte for byte.
static NSString * const BWKbStateNoteName =
    @"com.anlai.omnicar/bridgewake.v1.kbstate";

// [hl2-split W6] The in-app pinch relay channel (NSDistributed,
// hosted app -> owner): {hash, gen, session, seq, gid, dir, t} —
// dir 0 = toggle (hl4: the app asserts no direction; the owner
// flips by its real FS state), 1 = pinch-out (expand),
// 2 = pinch-in (restore); t is the sender's send stamp in
// seconds (same device clock as the owner).
// Defined locally like the kbstate name; the string must match the
// app side's poster byte for byte.
static NSString * const BWPinchNoteName =
    @"com.anlai.omnicar/bridgewake.v1.pinch";

// [hl2-split W6] Per-slot pinch-relay ordering book: the last
// ACCEPTED (gen, session) key, its highest seq, and the (gid, seq)
// of the last accepted gesture command (dedup: one FS command per
// gesture). Reset implicitly whenever (gen, session) changes — a
// new assignment generation or a new app session starts a fresh
// baseline, mirroring BWInputSlotReport's session discipline.
static uint32_t bwPinchGenBySlot[10];
static uint32_t bwPinchSessionBySlot[10];
static uint64_t bwPinchLastSeqBySlot[10];
static uint64_t bwPinchLastGidBySlot[10];
static BOOL     bwPinchHasBySlot[10];

// [kbstate] reject reason names (log-stable).
static const char *BWKbReasonName(int reason) {
    switch (reason) {
        case BW_OK:           return "ok";
        case BW_R_BADHASH:    return "badhash";
        case BW_R_BADGEN:     return "badgen";
        case BW_R_BADSESSION: return "badsession";
        case BW_R_STALESEQ:   return "staleseq";
        case BW_R_NOASSIGN:   return "noassignment";
        default:              return "?";
    }
}

// Kb-sync packet type (bits 2-0): the first unused value in the
// BridgeWakePack.h type table (0 = invalid, 1 = state, 2 = query,
// 3 = wake, 4 = ack, 5 = act; 7 stays reserved). Defined locally so
// both BridgeWakePack.h copies stay bit-identical this round; the
// app-side receiver keys on this value.
static const uint8_t BWTypeKbSync = 6;

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

// [hl2-split G6] Per-pane packet modes. State packets are addressed
// per pane by bundle hash28 (BWPackFields in BWEmitStatePacket), so
// a per-pane override needs no format change: for the Gate 3 trial
// bundle (trial enabled) the packet's wakeMode is ENFORCE while
// every other pane keeps the global bwWakeMode; the packet
// pinchMode of a hosted pane is bwPinchInAppMode (pref
// bridgewake.pinchInApp) — the app side reads bits 9-8 it already
// parses. Used by BOTH bwEmitStateForPane: and the emission-
// signature computation in bwRecomputeForPane:, so a trial/mode
// change alone re-emits exactly like a state change.
// [hl4] The trial scope is gone (PATCH 29.24): the wakeMode of
// EVERY hosted pane is ENFORCE while the kill-switch
// (bwGate3TrialEnabled) is on, and the global bwWakeMode otherwise.
// No bundle is compared against anything here any more; the third
// out-param now reports whether this packet carries the expanded
// ENFORCE (kept so bwEmitStateForPane: can log scope evidence).
static void BWEmitModesForBundle(NSString *bundle, NSInteger *wmOut,
                                 NSInteger *pmOut, BOOL *trialOut) {
    (void)bundle; // [hl4] no per-bundle scope remains
    BOOL enforce = bwGate3TrialEnabled;
    if (wmOut) *wmOut = enforce ? BWModeEnforce : bwWakeMode;
    if (pmOut) *pmOut = bwPinchInAppMode;
    if (trialOut) *trialOut = enforce;
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

// One of the state channel's two posters in this TU (design §7.1
// Gate 1 counts state packets): state packets post here, kb-sync
// packets (type 6) post through BWEmitKbPacket below. Both share
// the single register-check token and the single monotone seq
// counter, so the channel's word stream stays ordered and receivers
// dispatch on (type, hash). bwEmitStateForPane: and the teardown/OFF
// paths all funnel through here.
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

// [ytz4-hb] Kb-sync packet poster (GPT ytz4 ruling, item 1): type 6
// on the state channel, header discipline identical to state packets
// (v / hash28 of the pane's bundle / shared monotone seq / the slot's
// live assignment gen). The payload is defined PER TYPE: in a kb
// packet, bits 9-8 — the pinchMode position in state packets —
// carry bit 9 = kbKnown and bit 8 = kbActive; flag, wakeMode and
// state are 0. kbKnown=0 is UNKNOWN: no authenticated snapshot for
// this assignment; it does NOT mean the keyboard is inactive.
// [ytz5] The values packed here are the BWInputStore's state at
// emission time (see bwKbEmitForPane:) — the only source is the
// app's own input session ("app-input-session"); the act flag is
// never republished as knowledge.
static void BWEmitKbPacket(NSString *bundle, uint32_t gen,
                           BOOL kbKnown, BOOL kbActive) {
    if (!bundle.length) return;
    if (!bwStateSendToken)
        notify_register_check(SCPBridgeWakeState, &bwStateSendToken);
    bwStateSeq = (uint16_t)((bwStateSeq + 1) & 0xFFF);
    unsigned kbField = (kbKnown ? 0x2u : 0x0u) | (kbActive ? 0x1u : 0x0u);
    uint64_t packet = BWPackFields(BWBundleHash28(bundle), bwStateSeq, gen,
                                   NO, kbField, 0, 0, BWTypeKbSync);
    notify_set_state(bwStateSendToken, packet);
    notify_post(SCPBridgeWakeState);
    OMCLogWrite(@"SplitScreen", [NSString stringWithFormat:
        @"[kb-sync] emit %@ gen=%u seq=%u known=%d active=%d source=app-input-session",
        bundle, gen, bwStateSeq, (int)kbKnown, (int)kbActive]);
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
    // [hl2-split G6] per-pane modes (wakeMode override + pinchInApp
    // packet pinchMode) — see BWEmitModesForBundle. [hl4] the
    // override is no longer a per-bundle trial: it is the expanded
    // all-hosted ENFORCE while the kill-switch is on.
    NSInteger emitWM, emitPM;
    BOOL enforce = NO;
    BWEmitModesForBundle(bundle, &emitWM, &emitPM, &enforce);
    BWEmitStatePacket(bundle, bwGenBySlot[slot], state, pinch,
                      emitWM, emitPM);
    uint64_t sig = BWEmitSig(state, pinch, emitWM, emitPM,
                             bwGenBySlot[slot]);
    bwEmitSigBySlot[slot] = sig;
    if (enforce) {
        // [gate3] ENFORCE emission evidence: counted on EVERY
        // expanded-scope packet, logged only when the packet shape
        // changed (assignment / state / mode transition) — the 1.0 s
        // renewal rotation re-sends identical shapes and must not
        // spam. [hl4] scope=all-hosted + kill-switch state are part
        // of the line so a session log proves the expansion was live.
        bwGate3TrialEmitCount++;
        if (sig != bwGate3TrialSigBySlot[slot]) {
            bwGate3TrialSigBySlot[slot] = sig;
            OMCLogWrite(@"SplitScreen", [NSString stringWithFormat:
                @"[gate3] enforce packet bundle=%@ slot=%ld "
                @"scope=all-hosted killswitch=%d wm=ENFORCE "
                @"(global %ld) state=%@ gen=%u count=%u",
                bundle, (long)slot, (int)bwGate3TrialEnabled,
                (long)bwWakeMode,
                BWStateName(state), bwGenBySlot[slot],
                bwGate3TrialEmitCount]);
        }
    }
}

// Re-emit the state of every hosted pane (query answers §3.3(iii),
// mode/EXPANDED changes §1.3 point 6) — spaced by the emit queue.
- (void)bwEmitAllHostedStates {
    for (SCPCarPane *pane in [self hostedPanes]) [self bwQueueEmitForPane:pane];
}

#pragma mark - Kb input store (package YTZ5, strand B5)

// The single assignment-identity writer. EVERY assignment lifecycle
// event for a slot funnels through here (explicit
// bwNoteAssignmentForPane: calls in SCPCarSplit.m, the bundle-change
// backstop in bwRecomputeForPane:, session teardown): the slot's
// generation advances — first assignment starts at 1, every later
// event wraps via BWGenNext — even when the same bundle is assigned
// to the same slot again, and the BWInputStore identity is
// re-registered for the new generation (Assign) or cleared
// (teardown to nil), so no kb record survives its assignment.
- (void)bwApplyAssignmentForSlot:(NSInteger)slot bundle:(NSString *)bundle {
    if (slot < 0 || slot >= 10) return;
    BWEnsureInputStore();
    bwGenBySlot[slot] = bwGenBySlot[slot] ? BWGenNext(bwGenBySlot[slot]) : 1;
    bwBundleBySlot[slot] = [bundle copy];
    bwAssignAtBySlot[slot] = BWNow();
    bwWakePendingBySlot[slot] = NO;
    if (bundle.length)
        BWInputSlotAssign(&bwInputStore, (int)slot,
                          BWBundleHash28(bundle), bwGenBySlot[slot]);
    else
        BWInputSlotClear(&bwInputStore, (int)slot);
}

// Public assignment-event entry (SCPCarSplit+BridgeWake.h): the
// pane's CURRENT bundleID is the event's identity (nil = teardown).
- (void)bwNoteAssignmentForPane:(SCPCarPane *)pane {
    if (!BWSlotValid(pane)) return;
    [self bwApplyAssignmentForSlot:pane.slot bundle:pane.bundleID];
}

// AutoHide's kb accessor (SCPCarSplit+BridgeWake.h): aggregate over
// the slots of the currently HOSTED panes — hosted determined by
// the pane table's own mechanism ([self hostedPanes], i.e. panes
// whose vc is a hosted AppBridge VC).
- (NSInteger)bwKbAggregateForHostedPanes {
    BWEnsureInputStore();
    int hosted[10] = {0};
    for (SCPCarPane *pane in [self hostedPanes])
        if (BWSlotValid(pane)) hosted[pane.slot] = 1;
    return BWInputAggregate(&bwInputStore, hosted, 10, BWNow());
}

// Hold-release watcher: when the hosted aggregate falls from
// holding (2 = ACTIVE or 1 = UNKNOWN) to 0 — the last ACTIVE input
// session ended — AutoHide's idle clock restarts at the release
// moment. Observed at every accepted kbstate report (below) and at
// the owner's 1.0 s renewal tick (bwRenewTick:), which is also how
// a release caused purely by freshness expiry is caught.
- (void)bwCheckKbHoldRelease {
    NSInteger agg = [self bwKbAggregateForHostedPanes];
    if (bwKbAggPrev != 0 && agg == 0) [self ahNoteKbHoldReleased];
    bwKbAggPrev = agg;
}

// Publish the slot's kb truth (possibly UNKNOWN) to the pane's app
// as a type-6 packet on the state channel. [ytz5] known/active are
// read from the BWInputStore AT EMISSION TIME with real freshness:
// known = (stateAt != UNKNOWN), active = (stateAt == ACTIVE). A
// re-emission is a pure read — BWInputSlotStateAt never touches the
// record's lastReport, so renewal cannot keep a stale record alive.
- (void)bwKbEmitForPane:(SCPCarPane *)pane {
    if (!BWSlotValid(pane)) return;
    NSInteger slot = pane.slot;
    NSString *bundle = bwBundleBySlot[slot] ?: pane.bundleID;
    if (!bundle.length) return;
    BWEnsureInputStore();
    int st = BWInputSlotStateAt(&bwInputStore, (int)slot, BWNow());
    BWEmitKbPacket(bundle, bwGenBySlot[slot],
                   st != BW_KB_UNKNOWN, st == BW_KB_ACTIVE);
}

// Inbound app->owner input-session reports (NSDistributed kbstate
// channel, posted by the hosted app's own input-session tracking):
// {hash, gen, session, seq, state, t} — hash/gen name the assignment
// the report claims, session/seq order it inside that assignment,
// state is the wire boolean (nonzero = keyboard ACTIVE), t is the
// sender's send stamp (log only; freshness runs on the owner's
// receive clock). This is the owner's ONLY kb source since the
// drawn panel — and with it the old appbridge.kbsync host channel —
// was removed. Every report is validated by BWInputSlotReport
// against the slot's live assignment identity; rejects are logged
// with their reason and never touch the record.
- (void)bwHandleKbStateNote:(NSNotification *)note {
    NSDictionary *info = note.userInfo;
    if (![info isKindOfClass:[NSDictionary class]]) return;
    uint32_t hash    = [info[@"hash"] unsignedIntValue];
    uint32_t gen     = [info[@"gen"] unsignedIntValue];
    uint32_t session = [info[@"session"] unsignedIntValue];
    uint64_t seq     = [info[@"seq"] unsignedLongLongValue];
    int      wire    = [info[@"state"] intValue];
    BWEnsureInputStore();
    // Address the report by hash among the LIVE assignments (the
    // store's registered identities). No live assignment carries
    // this hash -> the report is not this owner's data.
    NSInteger slot = -1;
    if (hash != 0)
        for (NSInteger s = 0; s < 10; s++)
            if (bwInputStore.slots[s].hash == hash) { slot = s; break; }
    if (slot < 0) {
        OMCLogWrite(@"SplitScreen", [NSString stringWithFormat:
            @"[kbstate] reject reason=%s hash=%07x gen=%u session=%u seq=%llu",
            BWKbReasonName(BW_R_NOASSIGN), hash, gen, session,
            (unsigned long long)seq]);
        return;
    }
    int reason = BWInputSlotReport(&bwInputStore, (int)slot, hash, gen,
                                   session, seq, wire, BWNow());
    if (reason != BW_OK) {
        OMCLogWrite(@"SplitScreen", [NSString stringWithFormat:
            @"[kbstate] reject reason=%s slot=%ld hash=%07x gen=%u session=%u seq=%llu",
            BWKbReasonName(reason), (long)slot, hash, gen, session,
            (unsigned long long)seq]);
        return;
    }
    OMCLogWrite(@"SplitScreen", [NSString stringWithFormat:
        @"[kbstate] accept slot=%ld hash=%07x gen=%u session=%u seq=%llu state=%d source=app-input-session",
        (long)slot, hash, gen, session, (unsigned long long)seq, wire]);
    // Republish this pane's fresh truth to its app at once, then run
    // the hold-release watcher: an accepted INACTIVE that ends the
    // last ACTIVE session restarts AutoHide's idle clock here.
    SCPCarPane *pane = bwPaneBySlot[slot];
    if (!pane || pane.slot != slot)
        pane = [self paneForBundle:bwBundleBySlot[slot]];
    if (pane && pane.slot == slot) [self bwKbEmitForPane:pane];
    [self bwCheckKbHoldRelease];
}

// [hl2-split W6] Inbound in-app pinch relay (NSDistributed channel
// BWPinchNoteName, posted by the hosted app's own pinch recognizer —
// GPT YTZ5HL1 ruling §1/§3: the recognizer lives IN the app, the
// owner alone calls the fullscreen surface): {hash, gen, session,
// seq, gid, dir, t}; dir 0 = toggle (hl4), 1 = pinch-out,
// 2 = pinch-in. Validation
// mirrors the kbstate discipline above: the hash must name a LIVE
// assignment (bwBundleBySlot), gen must equal the slot's current
// assignment generation, the session must match the session the
// BWInputStore knows for this assignment when it knows one (from
// kbstate reports — LIMIT: a hosted app that has not reported any
// kbstate yet has no owner-side session on record, so the check is
// then vacuous and the note's own session becomes the ordering key
// under gen + seq + TTL), seq must strictly advance per
// (hash, gen, session), a repeated (gid, seq) is a duplicate, and
// the send stamp must be within 1000 ms of the owner's clock (both
// processes share the device clock). An accepted command fires ONLY
// through SCPFullscreenAdapter (via the pinch controller's shared
// adapter instance — the same surface the legacy recognizer used),
// and only against the matching COMMITTED state: dir=out requires
// SPLIT, dir=in requires EXPANDED; pending/refused/unknown states
// reject as badstate and fire nothing.
// [hl4] dir=0 = bare TOGGLE — the only dir current app builds
// send (PATCH 29.22): the app asserts no direction at all, the
// effective direction is derived here from the adapter's real
// currentState (SPLIT -> out, EXPANDED -> in), and the result is
// logged as toggle-applied from=<state>. For dir=0 the badstate
// reject can only mean currentState was neither (Unknown —
// unreadable): a direction mismatch is impossible by
// construction, because no direction was asserted. Legacy
// dir 1/2 notes keep the exact-match rule above; no current
// build posts them any more.
- (void)bwHandlePinchNote:(NSNotification *)note {
    NSDictionary *info = note.userInfo;
    if (![info isKindOfClass:[NSDictionary class]]) return;
    uint32_t hash    = [info[@"hash"] unsignedIntValue];
    uint32_t gen     = [info[@"gen"] unsignedIntValue];
    uint32_t session = [info[@"session"] unsignedIntValue];
    uint64_t seq     = [info[@"seq"] unsignedLongLongValue];
    uint64_t gid     = [info[@"gid"] unsignedLongLongValue];
    NSInteger dir    = [info[@"dir"] integerValue];
    NSTimeInterval now = BWNow();
    NSInteger slot = (hash != 0) ? BWSlotForHash28(hash) : -1;
    void (^reject)(const char *) = ^(const char *reason) {
        OMCLogWrite(@"SplitScreen", [NSString stringWithFormat:
            @"[pinch2] owner reject reason=%s slot=%ld hash=%07x gen=%u "
            @"session=%u seq=%llu gid=%llu dir=%ld",
            reason, (long)slot, hash, gen, session,
            (unsigned long long)seq, (unsigned long long)gid, (long)dir]);
    };
    if (slot < 0 || !bwBundleBySlot[slot]) { reject("badhash"); return; }
    NSString *bundle = bwBundleBySlot[slot];
    if (gen != bwGenBySlot[slot]) { reject("badgen"); return; }
    id tval = info[@"t"];
    NSTimeInterval t = [tval respondsToSelector:@selector(doubleValue)]
        ? [tval doubleValue] : 0;
    if (t <= 0 || fabs(now - t) > 1.0) { reject("stale"); return; }
    BWEnsureInputStore();
    uint32_t knownSession = bwInputStore.slots[slot].session;
    BOOL sessionFromStore = knownSession != 0 &&
        bwInputStore.slots[slot].hasReport &&
        (now - bwInputStore.slots[slot].lastReport) <= BW_KB_FRESH_WINDOW;
    if (sessionFromStore && session != knownSession) {
        reject("badsession"); return;
    }
    BOOL sameKey = bwPinchHasBySlot[slot] &&
        bwPinchGenBySlot[slot] == gen &&
        bwPinchSessionBySlot[slot] == session;
    if (sameKey) {
        if (gid == bwPinchLastGidBySlot[slot] &&
            seq == bwPinchLastSeqBySlot[slot]) { reject("dup"); return; }
        if (seq <= bwPinchLastSeqBySlot[slot]) {
            reject("staleseq"); return;
        }
    }
    SCPCarPane *pane = [self paneForBundle:bundle];
    SCPFullscreenState committed =
        [SCPPinchController shared].adapter.currentState;
    // [hl4] dir=0 is a bare TOGGLE (the only dir current app
    // builds send): the app asserts no direction, so no
    // direction mismatch can exist — the effective direction is
    // derived HERE from the real committed state (SPLIT -> out,
    // EXPANDED -> in). For dir=0 the badstate reject below can
    // therefore only mean currentState was neither state
    // (Unknown — unreadable), never a wrong direction. Legacy
    // dir 1/2 keeps the exact-match rule.
    BOOL isToggle = (dir == 0);
    NSInteger effDir = dir;
    if (isToggle) {
        effDir = (committed == SCPFullscreenStateSplit) ? 1 :
                 (committed == SCPFullscreenStateExpanded) ? 2 : 0;
    }
    BOOL dirOK = (effDir == 1 && committed == SCPFullscreenStateSplit) ||
                 (effDir == 2 && committed == SCPFullscreenStateExpanded);
    if (!pane || pane.slot != slot ||
        ![[self hostedPanes] containsObject:pane] || !dirOK) {
        reject("badstate"); return;
    }
    bwPinchHasBySlot[slot] = YES;
    bwPinchGenBySlot[slot] = gen;
    bwPinchSessionBySlot[slot] = session;
    bwPinchLastSeqBySlot[slot] = seq;
    bwPinchLastGidBySlot[slot] = gid;
    OMCLogWrite(@"SplitScreen", [NSString stringWithFormat:
        @"[pinch2] owner accept slot=%ld bundle=%@ dir=%@ gid=%llu "
        @"seq=%llu gen=%u session=%u sessrc=%@ state=%@",
        (long)slot, bundle,
        isToggle ? (effDir == 1 ? @"toggle->out" : @"toggle->in")
                 : (dir == 1 ? @"out" : @"in"),
        (unsigned long long)gid, (unsigned long long)seq, gen, session,
        sessionFromStore ? @"store" : @"note",
        committed == SCPFullscreenStateSplit ? @"SPLIT" : @"EXPANDED"]);
    id<SCPFullscreenControlling> adapter =
        [SCPPinchController shared].adapter;
    if (effDir == 1) {
        [adapter requestExpandWithCompletion:^(BOOL applied) {
            OMCLogWrite(@"SplitScreen", [NSString stringWithFormat:
                isToggle
                    ? @"[pinch2] owner toggle-applied from=SPLIT action=expand applied=%d gid=%llu"
                    : @"[pinch2] owner expand applied=%d gid=%llu",
                (int)applied, (unsigned long long)gid]);
        }];
    } else {
        [adapter requestRestoreWithCompletion:^(BOOL applied) {
            OMCLogWrite(@"SplitScreen", [NSString stringWithFormat:
                isToggle
                    ? @"[pinch2] owner toggle-applied from=EXPANDED action=restore applied=%d gid=%llu"
                    : @"[pinch2] owner restore applied=%d gid=%llu",
                (int)applied, (unsigned long long)gid]);
        }];
    }
}

#pragma mark - State renewal (WO W2)

// The app side treats a state copy older than 2.5 s as stale (§4
// freshness), but the owner otherwise emits only on change — after
// controls have been hidden a long time, a hosted app's copy is
// guaranteed stale at exactly the moment a suppression decision
// needs it. While the split session is live and at least one pane
// is hosted, the owner therefore re-publishes the CURRENT state of
// every hosted pane every 1.0 s. The channel carries a single word,
// so the panes are posted in rotation through the 30 ms emit queue
// inside each cycle: every pane's word (its own bundle hash) is
// re-posted well inside the 2.5 s freshness bound even with two
// hosted panes — no pane can be overwritten past freshness by the
// other. Content is the stored state verbatim: seq advances
// (inside BWEmitStatePacket), generation and semantics do not
// change. The timer lives and dies with the session —
// bwRenewMaintain is re-evaluated at every bwRecomputeForPane: and
// at bwSessionTeardown.
- (void)bwRenewMaintain {
    if (![NSThread isMainThread]) {
        dispatch_async(dispatch_get_main_queue(),
            ^{ [self bwRenewMaintain]; });
        return;
    }
    BOOL shouldRun = bwInstalled && self.active &&
                     [self hostedPanes].count > 0;
    if (shouldRun && !bwRenewTimer) {
        bwRenewTimer = [NSTimer scheduledTimerWithTimeInterval:1.0
            target:self selector:@selector(bwRenewTick:) userInfo:nil
            repeats:YES];
        OMCLogWrite(@"SplitScreen", @"[wake1] bw renew start (1.0s)");
    } else if (!shouldRun && bwRenewTimer) {
        [bwRenewTimer invalidate];
        bwRenewTimer = nil;
        OMCLogWrite(@"SplitScreen", @"[wake1] bw renew stop");
    }
}

- (void)bwRenewTick:(NSTimer *)timer {
    (void)timer;
    // [ytz5] Hold-release observation point 2 (strand B5): a release
    // caused purely by freshness expiry produces no kbstate report,
    // so the 1.0 s tick re-checks the aggregate transition here.
    [self bwCheckKbHoldRelease];
    NSArray<SCPCarPane *> *hosted = [self hostedPanes];
    if (!self.active || hosted.count == 0) {
        [self bwRenewMaintain]; // conditions ended: stop the timer
        return;
    }
    NSMutableArray<NSString *> *hashes = [NSMutableArray array];
    for (SCPCarPane *pane in hosted) {
        if (pane.bundleID.length)
            [hashes addObject:[NSString stringWithFormat:
                @"%07x", BWBundleHash28(pane.bundleID)]];
        [self bwQueueEmitForPane:pane];
        // [ytz4-hb] the kb snapshot rides the same 1.0 s rotation
        // (GPT ytz4 ruling, item 1): a hosted app that missed the
        // change emission re-syncs within one cycle.
        [self bwKbEmitForPane:pane];
    }
    OMCLogWrite(@"SplitScreen", [NSString stringWithFormat:
        @"[wake1] bw renew panes=%lu hashes=%@",
        (unsigned long)hosted.count,
        [hashes componentsJoinedByString:@","]]);
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
    // EXPANDED row (WO P1 session model): fullscreen covers the
    // WHOLE split, so EXPANDED is a property of the session, never
    // of one bundle — pinch-in has priority on any pane still
    // assigned+live in the current split session while no other
    // transition (wake txn on this slot / divider drag) is running.
    // Mirrors pinchDispositionForPane:'s EXPANDED row exactly.
    if (bwExpandedFlag && self.active &&
        [[self allPanes] containsObject:pane] &&
        !bwWakePendingBySlot[pane.slot] && !self.resizing)
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
    // [ytz4-hb] EXPANDED no longer suspends the fade machine (GPT
    // ytz4 ruling, item 2 point 1): AutoHide keeps running while the
    // session is expanded, so controls fade and wake in fullscreen
    // exactly as in split. The ahSetSuspended: call that used to sit
    // here is gone; suspension remains ONLY for hosted-solo, driven
    // by SCPCarSplit's own calls in SCPCarSplit.m.
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
    // first assignment starts at 1. [ytz5] This bundle-change check
    // is now only the BACKSTOP: since package YTZ5 every assignment
    // lifecycle event — including re-assigning the SAME bundle to
    // the SAME slot, which this string comparison cannot see — is
    // reported explicitly through bwNoteAssignmentForPane:, and both
    // paths funnel into bwApplyAssignmentForSlot:bundle:, which
    // advances the generation AND re-registers the BWInputStore
    // identity (Assign/Clear), so a kb record never survives its
    // assignment.
    if (![bundle ?: @"" isEqualToString:bwBundleBySlot[slot] ?: @""])
        [self bwApplyAssignmentForSlot:slot bundle:bundle];

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
        // [ytz4-hb] EXPANDED no longer promotes HIDDEN -> VISIBLE
        // (GPT ytz4 ruling, item 2 point 3): while the session is
        // expanded, a pane whose controls have faded aggregates to
        // HIDDEN and the state packet says so — otherwise the app
        // side would be told VISIBLE while its chrome is faded and
        // suppression semantics would be wrong. Pinch-in does NOT
        // depend on this promotion: the arbiter's EXPANDED row
        // (bwPinchAllowedForPane: / pinchDispositionForPane:) keys
        // on the session flag and short-circuits BEFORE any read of
        // bwStateBySlot, so the escape stays independent of the
        // fade state.
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
    // [hl2-split G6] the signature is computed with the same per-pane
    // modes bwEmitStateForPane: packs (expanded ENFORCE / pinchInApp
    // — [hl4] no per-bundle trial scope remains), so a kill-switch
    // or pinchInApp change re-emits on its own.
    BOOL pinch = [self bwPinchAllowedForPane:pane];
    NSInteger emitWM, emitPM;
    BWEmitModesForBundle(bwBundleBySlot[slot] ?: bundle,
                         &emitWM, &emitPM, NULL);
    uint64_t sig = BWEmitSig(bwStateBySlot[slot], pinch, emitWM,
                             emitPM, bwGenBySlot[slot]);
    if (sig != bwEmitSigBySlot[slot]) [self bwQueueEmitForPane:pane];
    // WO W2: assignment/session changes are the renewal timer's
    // lifecycle inputs (first hosted pane starts it, losing the
    // last one stops it).
    [self bwRenewMaintain];
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
        // [ytz5] teardown ends every assignment: its BWInputStore
        // identity is cleared with it (record back to UNKNOWN,
        // hash = 0 — later reports are NOASSIGN until a new Assign).
        BWEnsureInputStore();
        BWInputSlotClear(&bwInputStore, (int)s);
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
    [self bwRenewMaintain]; // WO W2: session over -> renewal stops
    OMCLogWrite(@"SplitScreen", @"[wake1] bw session teardown -> INACTIVE");
}

#pragma mark - Modes (design §4)

- (void)bwReloadModesAndRepublish {
    // The owner (CarPlayApp, the tweak's own process — not an App
    // Store sandbox) is the ONLY reader of these prefs; apps learn the
    // modes solely from state packets. Wake: absent = DRY_RUN.
    // Pinch history: the 2026-11-09 "noi pinch luon" wiring briefly
    // made pinch absent = ENFORCE; GPT's post-fs1 audit WO superseded
    // that (fix-wp-owner): with pinch-in dead under the old bundle
    // arbiter and the FS controller unproven on device, ENFORCE is
    // reachable ONLY via an explicit pref (0/1/2 all still honoured,
    // so OFF and DRY_RUN remain available in this same build).
    // [ytz5] Package YTZ5 supersedes the pinch default once more:
    // absent now reads OFF (0), and the one-time migration below
    // forces any legacy stored value (including a stored DRY_RUN=1)
    // to OFF exactly once.
    id w = OMCPref(@"bridgewake.wakeMode", nil);
    id p = OMCPref(@"bridgewake.pinchMode", nil);
    // [ytz5] One-time targeted pinch migration: if the ytz5 marker
    // is absent, a stored pinchMode != 0 is rewritten to 0 (with the
    // discriminator log line) and the marker is set. No other pref
    // is touched and nothing is deleted; once the marker exists this
    // block never runs again, so a pinchMode stored AFTER the
    // migration is honoured as an explicit user choice.
    if (!OMCPref(@"bridgewake.pinchOffMigratedYtz5", nil)) {
        if (p && [p integerValue] != 0) {
            CFPreferencesSetAppValue(CFSTR("bridgewake.pinchMode"),
                (__bridge CFPropertyListRef)@(0),
                CFSTR("com.anlai.omnicar"));
            OMCLogWrite(@"SplitScreen",
                @"[pinch1] legacy pinchMode overridden to OFF (ytz5)");
            p = @0;
        }
        CFPreferencesSetAppValue(CFSTR("bridgewake.pinchOffMigratedYtz5"),
            (__bridge CFPropertyListRef)@(1),
            CFSTR("com.anlai.omnicar"));
        CFPreferencesAppSynchronize(CFSTR("com.anlai.omnicar"));
    }
    bwWakeMode  = w ? MIN(MAX([w integerValue], 0), 2) : BWModeDryRun;
    bwPinchMode = p ? MIN(MAX([p integerValue], 0), 2) : BWModeOff;
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
    // [hl2-split G6] Gate 3 trial scope + in-app pinch packet mode.
    // [hl4] The per-bundle trial scope is RETIRED (PATCH 29.24):
    // bridgewake.gate3TrialBundle is no longer read and has no role.
    // What remains is the global kill-switch and the pinch mode:
    // bridgewake.gate3Trial (kill-switch): absent = ON, 0 = OFF;
    // ON = every hosted pane's packet wakeMode is ENFORCE, OFF =
    // every pane falls back to the global bwWakeMode layer above.
    // bridgewake.pinchInApp: absent = ENFORCE, 1 = DRY_RUN, 0 = OFF
    // (any other value = ENFORCE); it sets ONLY the packet pinchMode
    // of hosted panes — the legacy bwPinchMode above is untouched.
    id tk = OMCPref(@"bridgewake.gate3Trial", nil);
    bwGate3TrialEnabled = tk ? [tk boolValue] : YES;
    id pa = OMCPref(@"bridgewake.pinchInApp", nil);
    bwPinchInAppMode = !pa ? BWModeEnforce
        : [pa integerValue] == 0 ? BWModeOff
        : [pa integerValue] == 1 ? BWModeDryRun : BWModeEnforce;
    OMCLogWrite(@"SplitScreen", [NSString stringWithFormat:
        @"[gate3] scope=all-hosted killswitch=%d packetPinch=%ld",
        (int)bwGate3TrialEnabled,
        (long)bwPinchInAppMode]);
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
    // [ytz4-hb] a query also pulls the ASKING app's kb snapshot
    // (GPT ytz4 ruling, item 1: emit on query) — the app that just
    // (re)registered gets its authenticated kb truth immediately,
    // not at the next renewal tick.
    NSInteger slot = BWSlotForHash28(pkt.hash28);
    if (slot >= 0 && bwBundleBySlot[slot]) {
        SCPCarPane *pane = [self paneForBundle:bwBundleBySlot[slot]];
        if (pane && pane.slot == slot) [self bwKbEmitForPane:pane];
    }
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
// hosted. [ytz5] The packet's flag is kept ONLY as a diagnostic
// field in the accepted log line: since package YTZ5 an act packet
// neither sets nor clears any kb truth (the fade gate reads the
// BWInputStore aggregate), it is forwarded purely as activity.
// This handler NEVER posts anything (anti-loop rule, §3.2.1).
- (void)bwHandleActPacket:(uint64_t)raw {
    BWPacket pkt = BWUnpack(raw);
    // WO W1: EVERY drop point logs its own [autohide] reason — a
    // silently swallowed act is what made the on-car reveal failure
    // undiagnosable. The accepted path logs too, so a log reader can
    // walk the whole chain: act in -> reason or accepted -> reveal.
    if (!pkt.valid || pkt.type != BWTypeAct) {
        OMCLogWrite(@"SplitScreen", [NSString stringWithFormat:
            @"[autohide] act drop reason=decode-fail raw=%llx valid=%d type=%u",
            (unsigned long long)raw, (int)pkt.valid, (unsigned)pkt.type]);
        return;
    }
    NSInteger slot = BWSlotForHash28(pkt.hash28);
    if (slot < 0) {
        OMCLogWrite(@"SplitScreen", [NSString stringWithFormat:
            @"[autohide] act drop reason=bad-hash hash=%07x",
            pkt.hash28]);
        return;
    }
    NSString *bundle = bwBundleBySlot[slot];
    if (pkt.gen != bwGenBySlot[slot]) { // stale session (§3.2.1)
        OMCLogWrite(@"SplitScreen", [NSString stringWithFormat:
            @"[autohide] act drop reason=bad-gen bundle=%@ gen=%u cur=%u",
            bundle, pkt.gen, bwGenBySlot[slot]]);
        return;
    }
    if (!self.active) {
        OMCLogWrite(@"SplitScreen", [NSString stringWithFormat:
            @"[autohide] act drop reason=session-inactive bundle=%@",
            bundle]);
        return;
    }
    SCPCarPane *pane = [self paneForBundle:bundle];
    if (!pane || pane.slot != slot ||
        ![[self hostedPanes] containsObject:pane]) {
        OMCLogWrite(@"SplitScreen", [NSString stringWithFormat:
            @"[autohide] act drop reason=not-assigned bundle=%@ pane=%d",
            bundle, pane != nil]);
        return;
    }
    if (bwStateBySlot[slot] == BWStateInactive) {
        OMCLogWrite(@"SplitScreen", [NSString stringWithFormat:
            @"[autohide] act drop reason=split-inactive bundle=%@ slot=%ld",
            bundle, (long)slot]);
        return;
    }
    OMCLogWrite(@"SplitScreen", [NSString stringWithFormat:
        @"[autohide] act-accepted bundle=%@ kb=%d seq=%u -> ahNoteActivity",
        bundle, (int)pkt.flag, pkt.seq]);
    // [ytz5] Activity only — pkt.flag (the app's kb bit) is NOT
    // forwarded into any hold: ahNoteActWithKbActive:'s hold writes
    // are gone, and the AutoHide fade gate no longer reads a global
    // hold at all (it reads bwKbAggregateForHostedPanes).
    [self ahNoteActivity:AHSourceApp];
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
        // [ytz5] App->owner input-session reports (package YTZ5,
        // strand B5): the hosted app's own input session reports on
        // the NSDistributed kbstate channel {hash, gen, session,
        // seq, state, t}; the owner validates each report through
        // the BWInputStore and re-publishes the slot's truth to the
        // apps as type-6 state-channel packets (see
        // bwHandleKbStateNote: / bwKbEmitForPane:). The ytz4 host
        // appbridge.kbsync registration is gone with the drawn
        // panel it measured.
        BWEnsureInputStore();
        [[NSDistributedNotificationCenter defaultCenter]
            addObserverForName:BWKbStateNoteName object:nil
                         queue:[NSOperationQueue mainQueue]
                    usingBlock:^(NSNotification *n) {
                        [owner bwHandleKbStateNote:n];
                    }];
        // [hl2-split W6] In-app pinch relay (same registration point
        // as kbstate): the hosted app's recognizer reports a proven
        // pair on BWPinchNoteName; the owner validates it like a
        // kbstate report and alone calls SCPFullscreenAdapter.
        [[NSDistributedNotificationCenter defaultCenter]
            addObserverForName:BWPinchNoteName object:nil
                         queue:[NSOperationQueue mainQueue]
                    usingBlock:^(NSNotification *n) {
                        [owner bwHandlePinchNote:n];
                    }];
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
    // EXPANDED row (§2.2, WO P1 session model): fullscreen expands
    // the WHOLE split and the controller reports it with
    // forBundle:nil, so the row keys on the session flag alone —
    // pinch-in is allowed on any pane still assigned+live in the
    // current split session (allPanes: native panes included) while
    // no other transition (wake txn on this slot / divider drag) is
    // running. Mirrors bwPinchAllowedForPane:'s EXPANDED row.
    if (bwExpandedFlag && self.active &&
        [[self allPanes] containsObject:pane] &&
        !bwWakePendingBySlot[pane.slot] && !self.resizing)
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
