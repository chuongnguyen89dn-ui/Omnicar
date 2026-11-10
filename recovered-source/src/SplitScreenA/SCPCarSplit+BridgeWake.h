// SCPCarSplit+BridgeWake.h — bridgewake.v1 owner interface (design §7.1).
//
// The bridgewake state owner lives in SCPCarSplit (CarPlayApp process
// only — design §0/Q2). Declarations sit in this header rather than in
// SCPCarSplit.h/SCPCarPane.h because this strand's file scope is the new
// BridgeWake TU + call points; per-slot owner state (including
// bwGenBySlot[10] and the per-slot bwState) is held in file statics
// inside SCPCarSplit+BridgeWake.m, keyed by SCPCarPane.slot (0..9).
//
// Packet layout: BridgeWakePack.h (design §3). Channel name strings are
// defined in SCPShared.m and declared below; the AppBridge module
// declares byte-identical strings in ABChannelNames.m.

#import "SCPCarSplit.h"
#import "SCPCarPane.h"
#import "BridgeWakePack.h"
#import "SCPPinchController.h" // [pinch1] SCPPinchArbiter conformance (design-pinch §3.5)

NS_ASSUME_NONNULL_BEGIN

// bridgewake.v1 Darwin channel names (design §3.1), defined in SCPShared.m.
extern const char *SCPBridgeWakeState; // owner -> apps + ABHost (state)
extern const char *SCPBridgeWakeQuery; // app -> owner (please re-emit)
extern const char *SCPBridgeWakeWake;  // app -> owner (+ ABHost arm)
extern const char *SCPBridgeWakeAck;   // owner -> app / ABHost -> owner
extern const char *SCPBridgeWakeAct;   // app -> owner (AutoHide activity, design-autohide §3.2.1)

// [ytz4-hb] Kb-sync packets (GPT ytz4 ruling, item 1): a SIXTH packet
// type on the state channel above — type 6 (first unused value in
// the BridgeWakePack.h table; 0-5 are invalid/state/query/wake/ack/
// act, 7 reserved). Header discipline is the state packet's (valid
// bit, hash28 of the pane's bundle, owner's shared seq, the slot's
// assignment gen); the payload is defined per type: bits 9-8 carry
// bit 9 = kbKnown, bit 8 = kbActive, all other payload fields 0.
// kbKnown=0 means UNKNOWN — the owner holds no authenticated
// snapshot for that assignment — and must never be read as
// "keyboard inactive". Emitted on kb session open/close, on app
// query, and in the 1.0 s renewal rotation for every hosted pane.
// State packets (type 1) and the V1-V10 harness vectors are
// unchanged, bit for bit.
//
// [ytz5] Kb SOURCE replaced (package YTZ5, strand B5): the truth is
// no longer ABHost's drawn-panel session (appbridge.kbsync is gone
// with the panel — Nguyen's 2026-11-09 ruling). The hosted app's
// own input session reports on the NSDistributed channel
// "com.anlai.omnicar/bridgewake.v1.kbstate"
// {hash, gen, session, seq, state, t}; the owner validates every
// report through the pure-C BWInputStore (SplitScreenC/
// BWInputStore.h) against the slot's live (hash, gen) assignment
// identity before it may move the record, and type-6 packets are
// packed from the store's state at emission time with source
// string "app-input-session".

@interface SCPCarSplit (BridgeWake) <SCPPinchArbiter>

// One-time owner install (called from __init_1 in SCPHooks.m, CarPlayApp
// only): Darwin receivers for query/wake/ack, prefs-changed observer,
// initial mode load (design §4). Idempotent.
- (void)bwInstallOwner;

// The single aggregation point (design §1.3): recompute the pane's wake
// state from the raw inputs, and emit a state packet only on change.
- (void)bwRecomputeForPane:(SCPCarPane *)pane;

// The single state-packet emitter (design §7.1 Gate 1: the state
// channel's notify_post exists only inside this method's TU). Callers
// outside the BridgeWake TU must go through bwRecomputeForPane: /
// bwQueueEmitForPane: instead of posting themselves.
- (void)bwEmitStateForPane:(SCPCarPane *)pane;

// Enqueue a state emission for the pane on the 30 ms-spaced emit queue
// (design §3.3 mitigation (i)); the queued emission recomputes nothing,
// it packs the pane's currently stored arbitrated state.
- (void)bwQueueEmitForPane:(SCPCarPane *)pane;

// Inbound packet handlers, fed by the Darwin receivers in bwInstallOwner.
- (void)bwHandleQueryPacket:(uint64_t)raw;
- (void)bwHandleWakePacket:(uint64_t)raw;
- (void)bwHandleAckPacket:(uint64_t)raw;
// AutoHide `act` packet (BWTypeAct, design-autohide §3.2.1): validated
// here (hash/gen, same anti-stale discipline as wake) and forwarded to
// the AutoHide TU via ahNoteActWithKbActive:. The owner NEVER posts
// anything in response to an act packet (anti-loop rule, §3.2.1).
- (void)bwHandleActPacket:(uint64_t)raw;

// Split teardown (design §1.3 call group 3, the "setActive:NO" point —
// dashboardInvalidated): every known slot's generation advances and its
// state goes INACTIVE with a single emission per pane.
- (void)bwSessionTeardown;

// [ytz5] Explicit assignment lifecycle event (package YTZ5, strand
// B5): SCPCarSplit calls this at every point that assigns or clears
// a pane's bundle (hostApp:/adopt: installs, pane teardown clears,
// the closeGoingHome: loop). EVERY such event advances the slot's
// generation — including a re-assignment of the SAME bundle to the
// SAME slot — and re-registers the BWInputStore identity for the
// slot (BWInputSlotAssign for a live bundle, BWInputSlotClear for
// nil), so the kb record of the previous assignment can never leak
// into the next one. bwRecomputeForPane: keeps its own bundle-change
// detection as a backstop for paths without an explicit call.
- (void)bwNoteAssignmentForPane:(SCPCarPane *)pane;

// [ytz5] AutoHide's kb input (package YTZ5, strand B5): the
// BWInputAggregate over the slots of the currently HOSTED panes
// (hosted = [self hostedPanes], the pane table's own mechanism).
// Returns 2 when any hosted assignment is freshly ACTIVE, 1 when
// none is ACTIVE but at least one is UNKNOWN, 0 when every hosted
// assignment is freshly INACTIVE (or none is hosted). AutoHide's
// fade gate reads this — and only this — for its kb block.
- (NSInteger)bwKbAggregateForHostedPanes;

// Re-read bridgewake.wakeMode / bridgewake.pinchMode /
// bridgewake.pinchAllowlist from prefs (design §4) and re-emit the state
// of every hosted pane. Called at install and on SCPNotePrefsChanged.
- (void)bwReloadModesAndRepublish;

// Arbitrated pinch permission for a pane (design §2.2 table), computed
// from the pane's stored state + allowlist + EXPANDED input. This is
// the flag packed into state packets; the pinch feature itself is a
// different strand — nothing here calls any pinch code (§2.3).
- (BOOL)bwPinchAllowedForPane:(SCPCarPane *)pane;

// EXPANDED input (design §2.1): supplied by the fullscreen layer —
// since fs1 the producer is SCPFullscreenController, reporting at its
// settle points with forBundle:nil. EXPANDED is a SESSION state
// (WO P1): fullscreen covers the whole split, so the bundle argument
// is retained for logging only and arbitration never compares
// against it. Pinch-in is allowed on any live pane of the session
// (design §2.2, first row) — keyed on the session flag in the
// arbiter, independent of the fade state. [ytz4-hb] Since the GPT
// ytz4 ruling, EXPANDED neither suspends AutoHide nor promotes
// HIDDEN -> VISIBLE: a faded pane aggregates to HIDDEN while
// expanded, exactly as in split.
- (void)bwSetExpandedActive:(BOOL)active forBundle:(nullable NSString *)bundleID;
- (BOOL)bwExpandedActive;

// [gpt-hl6-host-pinch] CarPlay-side two-finger detector. YES keeps
// native/cross-pane pinch in the host, with hosted same-pane pairs
// delegated to the in-app relay when HL13 fallback is active.
- (BOOL)bwCarHostPinchEnabled;
// [hl13pinch] Cached effective owner decision, not an independent
// preference read in the touch path.
- (BOOL)bwHostedPinchFallbackEnabled;

// SCPPinchArbiter conformance (design-pinch §3.5 + impl-pinch deviation
// L1: pinchMode also comes from the owner). The owner answers purely
// from its stored per-slot wake state + the EXPANDED input above; the
// controller's (bundle, scene) allowlist stays the controller's own
// gate 5 and is NOT consulted here. Assigned to
// [SCPPinchController shared].arbiter in bwInstallOwner.
- (SCPArbiterDisposition)pinchDispositionForPane:(SCPCarPane *)pane
                               touchesSuppressed:(BOOL)anyTouchSuppressed;
- (BOOL)hostIsExpanded;
- (SCPPinchMode)pinchMode;

@end

NS_ASSUME_NONNULL_END
