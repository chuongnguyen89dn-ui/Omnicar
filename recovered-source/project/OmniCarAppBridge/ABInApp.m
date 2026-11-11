// ABInApp.m — everything that runs INSIDE a hosted app process.
// Reconstructed from: ctor sub_44A8, orientation block sub_4728, hooks
// sub_50A8..sub_58C0, helpers sub_5C64..sub_6D50, publishers sub_67FC /
// sub_6AD4, key receiver block sub_5908, deferred blocks sub_5FF0/sub_6028.
//
// Data flow (all proven from this binary):
//   * Host (CarPlay-side) posts NSDistributed "appbridge.orientation"
//     {orientation, device, fps} addressed to this app's bundleID.
//   * The block sub_4728 installs the in-app hooks LAZILY on first receipt,
//     stores the forced orientation, forces the key window's rotatable view
//     if the app's supported mask allows it, arms the fake-orientation
//     machinery, and schedules fake UIDeviceOrientationDidChange re-posts
//     at +0.3s / +1.5s / +4.0s (constant array at 0x393F0, __objc_doubleobj
//     values read verbatim: 0.3, 1.5, 4.0).
//   * The app reports its OWN orientation wishes back to SpringBoard over
//     the Darwin channel "appbridge.apporient" (debounced 0.25 s), and its
//     keyboard focus over "appbridge.keyboard".
//   * While hosted, the system keyboard is suppressed by giving the first
//     responder a zero-size blank inputView; the car keyboard (ABKeyboard,
//     SpringBoard side) sends key actions back over the NSDistributed
//     "appbridge.key" channel, applied here to the tracked responder.

#import "AppBridgeB.h"
#import "BridgeWakePack.h"
#import "ABYTLease.h"
#import <objc/runtime.h>
#import <substrate.h>
#import <UIKit/UIGestureRecognizerSubclass.h> // [hl2-w6] ABPinchGestureRecognizer sets state
#import <mach/mach_time.h> // WO fix-w W1: act decision log stamps

// [integration phase 1; backported to src in phase 3] forward
// declarations: the in-app hook replacements below are installed near
// the top of this file but defined (static) further down it; signatures
// copied verbatim from their definitions.
static void ABHook_UIWindowSetRotatable(UIWindow *self, SEL _cmd, NSInteger orientation, double duration, BOOL force);
static CADisplayLink *ABHook_CADisplayLinkNew(id self, SEL _cmd, id target, SEL selector);
static void ABHook_CADisplayLinkSetFPS(CADisplayLink *self, SEL _cmd, NSInteger fps);
static void ABHook_CADisplayLinkSetRange(CADisplayLink *self, SEL _cmd, CAFrameRateRange range);
static BOOL ABHook_TFBecome(UITextField *self, SEL _cmd);
static BOOL ABHook_TFResign(UITextField *self, SEL _cmd);
static BOOL ABHook_TVBecome(UITextView *self, SEL _cmd);
static BOOL ABHook_TVResign(UITextView *self, SEL _cmd);
static void ABHook_UIDeviceSetOrientation(UIDevice *self, SEL _cmd, NSInteger orientation, BOOL animated);
static NSInteger ABHook_UIDeviceOrientation(UIDevice *self, SEL _cmd);
static void ABHook_UIDeviceBeginGen(UIDevice *self, SEL _cmd);
static void ABHook_SceneRequestGeometry(UIWindowScene *self, SEL _cmd, id preferences, id errorHandler);
static void ABHook_VCSetNeedsUpdate(UIViewController *self, SEL _cmd);
static void ABHook_VCAttemptRotation(id self, SEL _cmd);
// YT-ZOOM answer-surface hooks (design-ytzoom.md §5.2 #1/#2/#3/#5);
// defined in the YZ section below, installed only in the YouTube
// process, and inert unless a lease lives (YZActive()).
static NSUInteger ABHook_VCSupportedOrientations(UIViewController *self, SEL _cmd);
static NSUInteger ABHook_VCSupportedOrientationsPrivate(UIViewController *self, SEL _cmd);
static NSInteger ABHook_SceneInterfaceOrientation(UIWindowScene *self, SEL _cmd);
static void ABHook_UIWindowRotateWindow(UIWindow *self, SEL _cmd, NSInteger orientation, BOOL updateStatusBar, double duration, BOOL skipCallbacks);
// AutoHide act scene binding (WO fix-w W3): the BridgeWake section sits
// above the YT-ZOOM section, so the scene-candidate reader is forward
// declared here and the lease scene id is declared as a tentative
// definition; its single initializing definition lives with the YZ
// statics below.
static NSString *YZSceneCandidateID(UIWindowScene *scene);
static NSString *YZLeaseSceneID;

NSInteger ABForcedOrientation = -1;  // 0x3E7D0 (stored as int32 in the original)
int64_t   ABAppOrientation    = 0;   // 0x3E9C8
NSInteger ABDeviceFake       = 0;   // 0x3E9D0 (int32)
NSInteger ABFPSLimit         = 0;   // 0x3E9B0 (int32)
__weak id ABCurrentResponder = nil; // 0x3E930

static BOOL ABHooksInstalled = NO;  // 0x3E938 (byte)
static int ABKeyboardToken = 0;     // 0x3E9E8
static int ABAppOrientToken = 0;    // 0x3E9E0
static id ABPendingPublishBlock = nil; // 0x3E9D8 (dispatch_block_t, retained)

// Original IMP slots (0x3E940..0x3E9A8), in install order.
static IMP orig_CADisplayLink_new, orig_CADisplayLink_setFPS, orig_CADisplayLink_setRange;
static IMP orig_UIWindow_setRotatable;
static IMP orig_UIDevice_beginGen, orig_UIDevice_setOrientation, orig_UIDevice_orientation;
static IMP orig_TF_become, orig_TF_resign, orig_TV_become, orig_TV_resign;
static IMP orig_Scene_reqGeometry, orig_VC_setNeedsUpdate, orig_VC_attemptRotation;

// ---------------------------------------------------------------------------
// Forward declarations
// ---------------------------------------------------------------------------
static void ABPublishAppOrientation(int64_t orientationField); // sub_67FC
static void ABScheduleAppOrientationPublish(int64_t field);    // sub_6750
static void ABKeyboardPublish(BOOL shown, id traits);          // sub_6AD4
static void ABRestoreBlankInputView(id responder);             // [ytz5-k5] marker restore, defined with the FR hooks below
static NSUInteger ABSupportedOrientationMask(void);            // sub_612C
static UIWindow *ABKeyWindow(void);                            // sub_61D0
static NSUInteger ABMaskFromViewController(UIViewController *vc, NSInteger depth); // sub_6498
static NSUInteger ABMaskFromWindow(UIWindow *window);          // sub_5EC0
static void ABAfterDelay(NSTimeInterval seconds);              // sub_5FF0 (+ block sub_6028)
static void ABApplyFPSLimit(id displayLink);                   // sub_5CBC
static NSHashTable *ABDisplayLinks(void);                      // sub_5C64 (weak hash table in the original) — // [integration phase 1; backported to src in phase 3] forward-decl return type corrected NSMutableSet*->NSHashTable* to match this file's own definition/body below

// ===========================================================================
// BridgeWake — QA180 wake port, in-app side (design-bridgewake.md §5).
// NEW machinery beside the original in-app code; the original functions
// around this section are unchanged. Roles:
//   * state client: receives packed state packets on the Darwin channel
//     bridgewake.v1.state (owner = SCPCarSplit in CarPlayApp), answers
//     with query, sends wake, consumes ack (role=0).
//   * ONE sendEvent: observation point feeding two independent probe
//     evaluations (wouldSwallow for wake, wouldPinch for pinch) and,
//     only when the owner-arbitrated wakeMode == ENFORCE, the
//     suppression engine of WO §V as mapped in design §5.4.
//   * keyboard guard (§5.5): the first-responder session is the primary
//     evidence (ABResponderBecame/Resigned below), keyboard
//     notifications are auxiliary; window existence is NEVER evidence
//     (QA178 lesson).
// Mode comes ONLY from state packets — this side never reads prefs or
// plists (QA179 lesson). No packet yet => DRY_RUN posture for the probe
// and fail-open for everything else (§4). Installed lazily inside
// ABOrientationBlock (§5.1), so the sendEvent: hook exists only while
// this app is actually hosted.
// [hl3] Swallow-decision basis = QA180 h1wake3 shape: the host
// PUSHES on every state change (change-driven emit, sig-gated in
// SCPCarSplit+BridgeWake.m) and this side decides at sendEvent:
// from the latched local state + its OWN first-hand kb state.
// Freshness arithmetic and the owner round-trip kb (type-6) are
// out of the decision; both survive for diagnostics/AutoHide.
// ===========================================================================

// Channel names (design §3.1). File-local copies of the same strings the
// ABHost strand publishes as ABChannelNames.m constants; the values
// must match byte-for-byte (integration gate).
static const char *BWNameState = "com.anlai.omnicar/bridgewake.v1.state";
static const char *BWNameQuery = "com.anlai.omnicar/bridgewake.v1.query";
static const char *BWNameWake  = "com.anlai.omnicar/bridgewake.v1.wake";
static const char *BWNameAck   = "com.anlai.omnicar/bridgewake.v1.ack";
static const char *BWNameAct   = "com.anlai.omnicar/bridgewake.v1.act";

// ---- state client (§5.2) ----
static BOOL     BWInstalled  = NO;
static BOOL     BWKnown      = NO;  // a valid packet for THIS bundle arrived
static NSInteger BWState     = BWStateUnknown;
static uint32_t BWGen        = 0;   // gen of the latest accepted packet
static NSInteger BWWakeMode  = BWModeDryRun;
static NSInteger BWPinchMode = BWModeDryRun;
static BOOL     BWPinchAllowed = NO; // arbitrated flag of the last packet
static NSTimeInterval BWStateRxAt = 0;      // systemUptime of last accept
static NSTimeInterval BWStateChangedAt = 0; // systemUptime of last change
// [hl2-g6] seq=45 truy ca instruments (G6 iii): seq carried by the
// latest accepted STATE packet (owner per-emission seq, BridgeWakePack
// bits 34-23) and a counter of BWState value changes this app process
// has observed since load (incremented in BWOnStatePacket whenever
// the accepted snapshot's state differs from the standing BWState).
static uint32_t BWStateSeq = 0;        // seq of latest accepted state packet
static NSUInteger BWStateFlipCount = 0; // observed BWState value changes
// [hl6-wake] the state BWState was latched FROM at the last flip
// (BWStateUnknown until the first flip): BWGatePass scopes its
// 250 ms transition guard by whether the flip INTO Hidden left a
// state that can still move — a flip out of WAKING is unsettled,
// a fade settle VISIBLE -> HIDDEN is final.
static NSInteger BWPrevState = BWStateUnknown;
static int      BWStateRxToken = 0;
static int      BWAckRxToken   = 0;
static int      BWQueryToken   = 0;
static int      BWWakeToken    = 0;
static int      BWActToken     = 0;
static uint32_t BWQuerySeq     = 0;
static uint32_t BWActSeq       = 0;   // app-side act sequence (§3.2.1)
static NSTimeInterval BWLastActAt = 0; // 0.12 s act throttle stamp
static NSTimeInterval BWLastQueryAt = 0;
// AutoHide act basis (WO fix-w W2-A): session-verified identity. Set at
// the exact point BWOnStatePacket accepts a packet (valid pack, own
// hash, gen accepted) — the owner has authenticated this bundle's
// hosted session; cleared in BWResetAll when the session closes. The
// act feed posts on THIS basis, never on state freshness.
// [hl3] BWFresh() is no longer the currency of the suppression
// path either: BWGatePass decides on the latched push state +
// local kb (QA180 shape). [hl3-L4] The pinch arbitration's
// freshness veto is removed on the same principle (PATCH
// 29.19): freshness now survives only as probe diagnostics
// and the BWQueryIfStale self-heal trigger.
static BOOL     BWActSessionVerified = NO;
static NSUInteger BWActSetFail  = 0; // notify_set_state failures (act)
static NSUInteger BWActPostFail = 0; // notify_post failures (act)
// [hl2-w6] in-app pinch recognizer lifecycle (defined in the pinch
// section below, after the probe machinery): attach is attempted on
// an accepted state packet and at a hosted sequence start; detach
// happens in BWResetAll when the assignment dies.
static void ABPinchTryAttach(void);
static void ABPinchDetach(void);

// ---- keyboard guard state (§5.5; three-state signal reworked by
// WO ytz4 K2) ----
// The kb truth is THREE-state end to end (UNKNOWN / INACTIVE /
// ACTIVE); nothing in this TU may collapse UNKNOWN into INACTIVE.
// Two sources feed the effective state (BWKbEffective, below):
//   local — this app's own keyboard evidence: the first-responder
//           session (primary, ABResponderBecame/Resigned) plus the
//           frame notifications (§5.5). It is kept as a LOCAL ACTIVE
//           source: a local ACTIVE is positive evidence and wins.
//   owner — the host's authenticated snapshot of the hosted keyboard
//           session, carried by kb packets on the state channel
//           (BWOnKbPacket, below). GPT's ytz3 audit convicted the old
//           arrangement, in which the act packet's one flag bit —
//           derived by testing the raw local value against ACTIVE —
//           let UNKNOWN masquerade as a measured "kb inactive" on
//           the owner side (38/38 kb=- app-side against 26/26
//           owner kb=0 in the ytz3 log).
enum { BWKbUnknown = 0, BWKbInactive = 1, BWKbActive = 2 };
static NSInteger BWKb = BWKbUnknown;
// Effective three-state kb and its provenance (defined with the kb
// sync machinery below; forward-declared for BWPostAct's flag).
enum { BWKbSrcNone = 0, BWKbSrcLocal = 1, BWKbSrcOwner = 2 };
static NSInteger BWKbEffective(NSInteger *srcOut, long *ageMsOut);

// ---- suppression engine (§5.4) ----
enum { BWEngIdle = 0, BWEngSwallowing = 1, BWEngFinished = 2 };
static NSInteger BWEngine = BWEngIdle;
static NSMutableSet *BWHeldTouches = nil; // touches of the swallowed chain
static uint32_t BWNextTxnSeq = 0;         // app-side wake seq counter
static uint32_t BWTxnSeq     = 0;         // seq of the live transaction
static BOOL     BWAcked      = NO;
static id       BWAckTimeoutBlock = nil;  // dispatch_block_t (pattern of
                                          // ABPendingPublishBlock above)
static BOOL     BWSuppressLocked = NO; // mixed touch: locked until the
                                       // next fresh state packet (§5.4)
static BOOL     BWFailOpenLatch  = NO; // ack timeout: fail-open until
                                       // the next fresh state packet

// ---- probe / sequence tracking (§5.3) ----
static BOOL     BWSeqActive = NO;
static NSMutableSet *BWActiveTouches = nil; // touches live in the sequence
static NSMutableSet *BWSeqTouches = nil;    // distinct touches, whole seq
static NSUInteger BWPhB = 0, BWPhM = 0, BWPhE = 0, BWPhC = 0;
static NSTimeInterval BWSeqStartAt = 0;
static NSUInteger BWProbeSeqNo = 0;
static BOOL     BWSeqWouldSwallow = NO;
static NSString *BWSeqFailOpen = nil;       // reason latched at seq start
static NSInteger BWSeqStateAtStart = BWStateUnknown;
// kb instrument latched at sequence start (WO ytz4 K2): the effective
// tri-state decomposed into known/active plus its source and the age
// of the winning source's information, so a car log can audit every
// suppression decision's kb basis instead of the old one-letter code.
static BOOL     BWSeqKbKnownAtStart = NO;
static BOOL     BWSeqKbActiveAtStart = NO;
static NSInteger BWSeqKbSrcAtStart = 0; // BWKbSrc* (kb state section)
static long     BWSeqKbAgeAtStart = -1; // ms; -1 = no kb information
static BOOL     BWSeqHosted = NO;
// [hl2-g6] probe instruments latched at sequence start (G6 iii): the
// state snapshot the gate decision actually used — its packet seq,
// its age at the decision instant, and the observed flip count then.
static uint32_t BWSeqStateSeqAtStart = 0;
static long     BWSeqStateAgeAtStart = -1; // ms; -1 = no snapshot
static NSUInteger BWSeqStateFlipsAtStart = 0;
// Two-touch distance tracking for wouldPinch — INTERNAL ONLY: distances
// are computed from touch locations but never written to any log.
static double   BWPairD0 = -1, BWPairDMin = -1, BWPairDMax = -1;
static NSUInteger BWLoggedSeqs = 0;  // 200/launch individual-log cap
static NSUInteger BWOverSeqs = 0, BWOverSwallow = 0, BWOverPinch = 0;
static NSTimeInterval BWNow(void) {
    return [NSProcessInfo processInfo].systemUptime;
}

// Monotonic stamp for act decision logs (WO fix-w W1):
// mach_absolute_time converted to milliseconds; immune to wall-clock
// changes, so app-side and owner-side lines can be ordered by it.
static uint64_t BWActNowMs(void) {
    static mach_timebase_info_data_t tb;
    static dispatch_once_t once;
    dispatch_once(&once, ^{ mach_timebase_info(&tb); });
    return (uint64_t)((mach_absolute_time() * (uint64_t)tb.numer)
                      / (uint64_t)tb.denom / 1000000ULL);
}

static uint32_t BWOwnHash28(void) {
    static uint32_t hash = 0;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        hash = ABBundleHash([NSBundle mainBundle].bundleIdentifier) >> 4;
    });
    return hash;
}

// Freshness (§5.2): a state packet is usable for 2.5 s after receipt.
static BOOL BWFresh(void) {
    return BWKnown && (BWNow() - BWStateRxAt) <= 2.5;
}

// Effective modes (§4): none received yet -> DRY_RUN posture; stale ->
// OFF for every blocking/pinch behaviour until the next valid packet.
static NSInteger BWEffectiveWakeMode(void) {
    if (!BWKnown) return BWModeDryRun;
    return BWFresh() ? BWWakeMode : BWModeOff;
}
static NSInteger BWEffectivePinchMode(void) {
    if (!BWKnown) return BWModeDryRun;
    return BWFresh() ? BWPinchMode : BWModeOff;
}

// Reserved field values collapse to the safe value (§3.2).
static NSInteger BWNormMode(int m)  { return (m >= 0 && m <= 2) ? m : BWModeOff; }
static NSInteger BWNormState(int s) { return (s >= 0 && s <= 4) ? s : BWStateUnknown; }

// gen acceptance (§3.2): equal to the known gen, or ahead of it in
// modulo-4096 forward distance; older gens are stale and dropped.
static BOOL BWGenAccept(uint32_t gen) {
    if (!BWKnown) return YES;
    if (gen == BWGen) return YES;
    uint32_t fwd = (gen - BWGen) & 0xFFFu;
    return fwd >= 1 && fwd <= 0x7FFu;
}

static void BWSendQuery(void) {
    if (!BWQueryToken) notify_register_check(BWNameQuery, &BWQueryToken);
    BWLastQueryAt = BWNow();
    uint64_t raw = BWPackFields(BWOwnHash28(), (++BWQuerySeq) & 0xFFFu, BWGen,
                                NO, 0, 0, 0, BWTypeQuery);
    notify_set_state(BWQueryToken, raw);
    notify_post(BWNameQuery);
}

// Re-query throttle (§5.2): at most one query per 2 s.
static void BWQueryIfStale(void) {
    if (BWNow() - BWLastQueryAt >= 2.0) BWSendQuery();
}

static void BWPostWake(uint32_t seq) {
    if (!BWWakeToken) notify_register_check(BWNameWake, &BWWakeToken);
    uint64_t raw = BWPackFields(BWOwnHash28(), seq, BWGen, NO, 0, 0, 0, BWTypeWake);
    notify_set_state(BWWakeToken, raw);
    notify_post(BWNameWake);
}

// AutoHide activity feed (design-autohide §3.2.1/§5.3; emission basis
// reworked by WO fix-w W2-A/W3): posted from the Began observation
// path of the existing sendEvent: hook — BEFORE any swallow decision,
// so a chain that gets swallowed still counts as activity (it is the
// touch that fires the wake). Posted in every WAKE_MODE, including
// OFF/DRY_RUN: AutoHide is independent of suppression (the QA19 relay
// precedent). Throttled at 0.12 s (the QA19/QA20 on-car-proven value).
// The packet carries no touch content — hash/gen/seq only;
// flag = kbActive at post time (§5.5 of design-bridgewake), computed
// from the EFFECTIVE three-state kb (WO ytz4 K2): the bit is 1 only
// on positive ACTIVE evidence (local responder session or a fresh
// owner snapshot); UNKNOWN never masquerades as a measured inactive
// here — the tri-state itself travels in the probe log (kbKnown /
// kbActive / kbSrc / kbAge), not in this bit.
//
// Emission basis (W2-A): session-verified identity + scene binding,
// NOT state freshness. The retired rule (post only while BWFresh())
// starved this feed exactly when it mattered: the owner emits state
// on change and on query, so once the controls had been faded for a
// while the app's state copy was older than 2.5 s and the revealing
// touch itself posted nothing — the feed locked its own reveal path
// out (convicted from source by the post-fs1 audit; Nguyen's car
// report matches: only a tap on the invisible logo button, whose
// handler lives in CarPlayApp, brought the controls back). An act
// packet claims nothing but "the verified hosted session saw a touch
// on the hosted scene": the owner re-validates hash/gen/assignment/
// session on receipt, and act never grants suppression rights —
// BWGatePass keeps demanding fresh state exactly as before.
// Returns YES when a packet was actually posted (NO when throttled);
// the notify status codes are handed back for the decision log (W1).
static BOOL BWPostAct(int *setStatus, int *postStatus) {
    NSTimeInterval now = BWNow();
    if (now - BWLastActAt < 0.12) return NO;
    BWLastActAt = now;
    if (!BWActToken) notify_register_check(BWNameAct, &BWActToken);
    uint64_t raw = BWPackFields(BWOwnHash28(), (++BWActSeq) & 0xFFFu, BWGen,
                                BWKbEffective(NULL, NULL) == BWKbActive,
                                0, 0, 0, BWTypeAct);
    int ss = notify_set_state(BWActToken, raw);
    int ps = notify_post(BWNameAct);
    if (ss != 0) BWActSetFail++;
    if (ps != 0) BWActPostFail++;
    if (setStatus) *setStatus = ss;
    if (postStatus) *postStatus = ps;
    return YES;
}

// ---- act scene binding (WO fix-w W3) ----
// An act may only be posted for touches on the scene CarPlay actually
// hosts in this process. Authority order: when a YT-Zoom lease has
// pinned a scene id, the scene whose candidate id matches it is the
// hosted scene; otherwise the scene of ABKeyWindow() — the same
// window the suppression gate verifies targets against (sub_61D0:
// first key, non-hidden window). A non-nil touch.window is NEVER
// sufficient on its own: an iPhone-screen touch in the same process
// lives in a different scene and must not wake the car's controls.
static UIWindowScene *BWActHostedScene(void) {
    if (YZLeaseSceneID.length > 0) {
        for (UIScene *s in [UIApplication sharedApplication].connectedScenes) {
            if (![s isKindOfClass:UIWindowScene.class]) continue;
            NSString *cand = YZSceneCandidateID((UIWindowScene *)s);
            if (cand && [cand isEqualToString:YZLeaseSceneID])
                return (UIWindowScene *)s;
        }
        return nil; // the lease names a scene this process cannot find
    }
    UIWindow *kw = ABKeyWindow();
    return kw ? kw.windowScene : nil;
}

// Act decision at a sequence's Began (WO fix-w W1/W2-A/W3). Every
// outcome is logged once per sequence with a monotonic ms stamp and
// the age of the state copy, so a car log can convict "the hook saw
// the touch but the state was old" (act-posted with a large stateage)
// separately from "no session was ever verified" (act-drop-nosession)
// and from scene mis-binding (act-drop-scene / -target-unknown).
static void BWActOnSequenceStart(NSSet *began) {
    uint64_t tms = BWActNowMs();
    long ageMs = BWKnown ? (long)((BWNow() - BWStateRxAt) * 1000.0) : -1L;
    if (!BWActSessionVerified) {
        OMCLogWrite(@"AppBridge", [NSString stringWithFormat:
            @"[autohide] act-drop-nosession t=%llu stateage=%ld",
            (unsigned long long)tms, ageMs]);
        return;
    }
    UIWindowScene *hosted = BWActHostedScene();
    BOOL unknown = (hosted == nil);
    BOOL foreign = NO;
    if (!unknown) {
        for (UITouch *t in began) {
            if (!t.window) { unknown = YES; break; }
            if (t.window.windowScene != hosted) { foreign = YES; break; }
        }
    }
    if (unknown) {
        OMCLogWrite(@"AppBridge", [NSString stringWithFormat:
            @"[autohide] act-drop-target-unknown t=%llu stateage=%ld",
            (unsigned long long)tms, ageMs]);
        return;
    }
    if (foreign) {
        OMCLogWrite(@"AppBridge", [NSString stringWithFormat:
            @"[autohide] act-drop-scene t=%llu stateage=%ld",
            (unsigned long long)tms, ageMs]);
        return;
    }
    int ss = -1, ps = -1;
    if (BWPostAct(&ss, &ps)) {
        OMCLogWrite(@"AppBridge", [NSString stringWithFormat:
            @"[autohide] act-posted t=%llu stateage=%ld gen=%lu set=%d post=%d setfail=%lu postfail=%lu",
            (unsigned long long)tms, ageMs, (unsigned long)BWGen,
            ss, ps,
            (unsigned long)BWActSetFail, (unsigned long)BWActPostFail]);
    }
}

// ---- kb sync: owner snapshot + effective state (WO ytz4 K2) ----
// Packet interface, fixed with the host strand: the kb packet rides
// the STATE channel with the unchanged header (valid/hash28/seq/gen)
// and type = 6 — the first previously-unused type value
// (BridgeWakePack.h assigns 1-5 and reserves 6-7). Its payload
// repurposes bits 9-8 (the pinchMode field position): bit9 = kbKnown,
// bit8 = kbActive. The constant stays local to this TU so the shared
// pack header is not forked from this side; the header gains the same
// value with the SplitScreen copy.
enum { BWTypeKbState = 6 };

// Owner snapshot: the last kb packet accepted for THIS bundle.
static BOOL BWKbOwnerKnown  = NO; // owner's snapshot itself knows kb
static BOOL BWKbOwnerActive = NO;
static NSTimeInterval BWKbOwnerRxAt = 0; // BWNow() stamp; 0 = never

// Owner-sync freshness window: 3.5 s. The owner emits kb on session
// open/close, on query, and with the 1 s state renew, which rotates
// through the hosted panes — worst case for one bundle in a two-pane
// split is therefore one kb-bearing emission every ~2 s. 3.5 s =
// 2.0 s worst-case rotation + 1.0 s for one fully missed tick + 0.5 s
// scheduling slack. Past the window the sync is stale and the kb
// state is UNKNOWN again — never a remembered INACTIVE.
static const NSTimeInterval BWKbOwnerFreshWindow = 3.5;

// Local kb changes go through one setter so the local source carries
// an age like the owner's.
static NSTimeInterval BWKbLocalChangedAt = 0;
static void BWKbLocalSet(NSInteger v) {
    if (BWKb == v) return;
    BWKb = v;
    BWKbLocalChangedAt = BWNow();
}

// kb packet acceptance follows the state packet discipline exactly
// (§3.2): own bundle hash + gen accepted against the newest known
// gen; anything else is dropped and the previous snapshot (or its
// absence) stands. A kb packet never touches the chrome state, the
// act session identity, or the §5.4 unlock latches — those belong to
// state packets alone.
static void BWOnKbPacket(BWPacket p) {
    if (p.hash28 != BWOwnHash28()) return;
    if (!BWGenAccept(p.gen)) return;
    BOOL known  = ((p.pinchMode >> 1) & 0x1u) != 0;       // bit 9
    BOOL active = known && ((p.pinchMode & 0x1u) != 0);   // bit 8
    BWKbOwnerKnown  = known;
    BWKbOwnerActive = active;
    BWKbOwnerRxAt   = BWNow();
}

// The effective three-state kb (§5.5 as reworked by WO ytz4 K2).
// [hl3] Consumers are now the AutoHide act flag, the pinch
// arbitration and the probe instruments ONLY — the swallow gate
// reads the local BWKb directly (see BWGatePass).
// ACTIVE on ANY valid ACTIVE evidence — the local responder/frame
// tracking or a fresh owner snapshot saying active. Otherwise a
// fresh owner snapshot decides (its INACTIVE, or its own UNKNOWN).
// No fresh sync and no local ACTIVE -> UNKNOWN. *srcOut receives the
// winning source (BWKbSrc*), *ageMsOut the age of that source's
// information in ms (-1 when there is none).
static NSInteger BWKbEffective(NSInteger *srcOut, long *ageMsOut) {
    NSTimeInterval now = BWNow();
    NSInteger src = BWKbSrcNone;
    long age = -1;
    NSInteger eff = BWKbUnknown;
    if (BWKb == BWKbActive) {
        eff = BWKbActive;
        src = BWKbSrcLocal;
        age = (long)((now - BWKbLocalChangedAt) * 1000.0);
    } else if (BWKbOwnerRxAt > 0
               && (now - BWKbOwnerRxAt) <= BWKbOwnerFreshWindow) {
        // A fresh sync governs even when its content is "owner does
        // not know": the sync is live, the state is honestly UNKNOWN.
        src = BWKbSrcOwner;
        age = (long)((now - BWKbOwnerRxAt) * 1000.0);
        if (BWKbOwnerKnown)
            eff = BWKbOwnerActive ? BWKbActive : BWKbInactive;
    }
    if (srcOut) *srcOut = src;
    if (ageMsOut) *ageMsOut = age;
    return eff;
}

// ===========================================================================
// [ytz5-k5] K5 — drawn/native gate cache + kbstate reporter.
//
// ---- the gate, as RELAYED by the host ----
// This side NEVER reads CFPreferences for the gate (contract — mode
// comes only from the bridge; the QA179 lesson this file's header
// already carries). The host stamps @"drawnKeyboard" (NSNumber:
// 1 = drawn panel enabled, 0 = native) into every frame-info
// payload it posts to this app (ABPostOrientationToApp stamps it in
// ABHostGeometry.m), and ABOrientationBlock — the existing
// frame-info handler — caches the value here via
// ABDrawnKbNoteFrameInfo.
// Default law (HL3 — supersedes the HL2-K6 law and restores the
// K5 original): NATIVE is the cached default AND the lock. The
// cache starts at NO (native) — exactly the ytz5 configuration
// that ran on the car — and the host of this build only ever
// stamps drawnKeyboard=0. A drawnKeyboard=1 payload, should one
// ever arrive, is logged once and IGNORED under the lock (see
// ABDrawnKbNoteFrameInfo): Nguyen's direct order 2026-11-09
// 22:14 — all hosted apps on the stock CarPlay keyboard, the
// drawn panel is not used — overrides the GPT drawn-default
// ruling. The drawn code stays in the tree, unreachable.
// ===========================================================================
static BOOL ABDrawnKb = NO; // [hl3] cached drawnKeyboard; NO = native (default + locked); host stamps 0 only
static BOOL ABDrawnKbGateSeen = NO; // [hl2-k6] an explicit drawnKeyboard value has been received

static BOOL ABDrawnKeyboardActive(void) { return ABDrawnKb; }

// [hl8diag] Focus + geometry ONLY. Never log text, candidate words
// or key values from the user's app.
static BOOL ABHL8Trace(void) {
    return [OMCPref(@"hl8.unifiedDiag", @YES) boolValue];
}
static void ABHL8Focus(NSString *event, id responder) {
    if (!ABHL8Trace()) return;
    UIView *v = [responder isKindOfClass:UIView.class] ? (UIView *)responder : nil;
    UIWindow *w = v.window;
    NSUInteger found = 0;
    NSMutableString *windows = [NSMutableString string];
    // HL8 diagnostic reads all process-local windows, including non-scene windows.
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
            NSArray<UIWindow *> *hl8AllWindows = [UIApplication sharedApplication].windows;
#pragma clang diagnostic pop
            for (UIWindow *x in hl8AllWindows) {
        NSString *kind = NSStringFromClass(x.class);
        if ([kind containsString:@"Keyboard"] ||
            [kind containsString:@"InputSet"] ||
            [kind containsString:@"TextEffects"]) {
            found++;
            if (windows.length < 260)
                [windows appendFormat:@"%@:%@:%d;",
                    kind, NSStringFromCGRect(x.frame), (int)x.hidden];
        }
    }
    OMCLogWrite(@"AppBridge", [NSString stringWithFormat:
        @"[hl8diag] eye=kb-app ev=%@ bundle=%@ responder=%@ "
         "orientation=%ld fake=%ld drawn=%d focusFrame=%@ "
         "window=%@ windowFrame=%@ windowScene=%@ "
         "phoneScreen=%@ keyboardWindows=%lu sample=%@",
        event, [NSBundle mainBundle].bundleIdentifier ?: @"unknown",
        responder ? NSStringFromClass([responder class]) : @"nil",
        (long)ABForcedOrientation, (long)ABDeviceFake,
        (int)ABDrawnKeyboardActive(),
        v ? NSStringFromCGRect(v.frame) : @"nil",
        w ? NSStringFromClass(w.class) : @"nil",
        w ? NSStringFromCGRect(w.frame) : @"nil",
        w.windowScene ? NSStringFromClass(w.windowScene.class) : @"nil",
        NSStringFromCGRect([UIScreen mainScreen].bounds),
        (unsigned long)found, windows]);
}

static void ABDrawnKbNoteFrameInfo(NSDictionary *info) {
    id v = info[@"drawnKeyboard"];
    if (ABHL8Trace())
        OMCLogWrite(@"AppBridge", [NSString stringWithFormat:
            @"[hl8diag] eye=kb-app ev=mode-recv bundle=%@ "
             "requested=%@ cached=%d orientation=%@ focus=%d",
            [NSBundle mainBundle].bundleIdentifier ?: @"unknown",
            v ?: @"missing", (int)ABDrawnKeyboardActive(),
            info[@"orientation"] ?: @"missing",
            (int)(ABCurrentResponder != nil)]);
    // [hl2-k6] only an explicit NSNumber speaks: absent / mistyped
    // fields keep the cached mode (which starts at DRAWN).
    if (![v isKindOfClass:NSNumber.class]) return;
    BOOL drawn = [v boolValue];
    if (drawn) {
        // [hl3] hard lock (Nguyen 22:14): a drawn=1 payload never
        // flips this app to the drawn panel in this build — the
        // cache stays native whatever the bridge carries.
        static BOOL hl3DrawnIgnoredLogged;
        if (!hl3DrawnIgnoredLogged) {
            hl3DrawnIgnoredLogged = YES;
            OMCLogWrite(@"AppBridge",
                @"[ytz5-k5] hl3: drawnKeyboard=1 bi bo qua — native khoa cung (lenh Nguyen 22:14)");
        }
        return;
    }
    if (!ABDrawnKbGateSeen) {
        // [hl2-k6] marker eye 1 of 3: the app received the gate.
        ABDrawnKbGateSeen = YES;
        OMCLogWrite(@"AppBridge", [NSString stringWithFormat:
            @"[ytz5-k5] gate nhan drawnKeyboard=%d (explicit, cached=%d)",
            drawn ? 1 : 0, ABDrawnKb ? 1 : 0]);
    }
    if (drawn == ABDrawnKb) return;
    BOOL wasDrawn = ABDrawnKb;
    ABDrawnKb = drawn;
    if (wasDrawn && !drawn) {
        // Flip drawn -> native MID-SESSION (contract item 2): hand
        // the system keyboard back on the live responder — restore
        // ONLY an inputView this tweak blanked (marker
        // ABBlankInputViewKey), and clear the marker in the restore.
        // A responder carrying its own custom inputView was never
        // blanked, bears no marker, and is never touched.
        ABRestoreBlankInputView(ABCurrentResponder);
        OMCLogWrite(@"AppBridge",
            @"[ytz5-k5] cong lat native: phuc hoi inputView theo marker");
    }
    if (!wasDrawn && drawn) {
        // [hl2-k6] marker: the gate flipped native -> drawn. Nothing
        // is forced (known K5 limit, kept): suppression applies from
        // the next becomeFirstResponder and the panel from the next
        // publish; a live native session is left exactly as it is.
        OMCLogWrite(@"AppBridge",
            @"[ytz5-k5] cong lat drawn: ap dung tu responder/publish ke tiep");
    }
    // Flip native -> drawn: nothing is forced. Suppression applies
    // from the next becomeFirstResponder and the panel from the
    // next publish; a live native session is left exactly as it is.
}

// ===========================================================================
// [ytz5-k5] kbstate reporter — app -> owner input-session truth
// (contract item 3). While native, the drawn panel is dead and its
// funnel (appbridge.kbsync, host-owned) must not speak for this
// app's input session; THIS report is the session's truth source.
// Transport: NSDistributedNotificationCenter, name
// com.anlai.omnicar/bridgewake.v1.kbstate, object = own bundle id.
// userInfo:
//   hash    NSNumber uint32 — hash28 of OWN bundle (BWOwnHash28():
//           the BridgeWakePack.h FNV-1a-32 >> 4 identity, the same
//           hash every bridgewake packet for this bundle carries)
//   gen     NSNumber — gen of the newest owner->app state packet
//           accepted here (BWGen at send time)
//   session NSNumber uint32 — minted ONCE per ABInApp load
//           (arc4random); identifies this app-process session
//   seq     NSNumber uint64 — per-source monotone, first post = 1
//   state   NSNumber — 1 = ACTIVE, 0 = INACTIVE
//   t       NSNumber double — app clock (BWNow(), systemUptime)
// Identity rule: nothing is posted until a state packet for this
// bundle has been accepted (BWKnown — the acceptance that also
// sets BWActSessionVerified), i.e. while the reporter holds a live
// (hash, gen) identity. [hl2-l8] The reporter posts only while
// that identity is still live: BWKbStatePost requires BWKnown AND
// BWKbReporterLive. BWKbReporterLive is set on every accepted state
// packet and cleared by BWResetAll. [hl4-D2] The heartbeat no
// longer clears it on silence alone: > 5 s of silence opens a
// bounded query verification (max 3 BWSendQuery), and only an
// unanswered verification stops the reporter
// (reason=query-unanswered) — see BWKbHeartbeatTick. The next
// accepted packet revives it in all cases. No typed content is
// ever logged or sent — the payload above is the whole surface.
// ===========================================================================
static NSString *const BWKbStateChannel = @"com.anlai.omnicar/bridgewake.v1.kbstate";
static uint32_t BWKbSessionID = 0;    // minted once, first reporter use
static uint64_t BWKbReportSeq = 0;    // monotone; first post carries 1
static BOOL     BWKbReportedActive = NO; // last state actually posted
static BOOL     BWKbHaveReported = NO;
static BOOL     BWKbReporterLive = NO; // [hl2-l8] identity still live (see rule above)
// [hl4-D2] Silence-verification episode (GPT ruling 533ac9a): the
// reporter no longer declares its own death from silence alone.
// Abnormal silence opens an episode: a suspicion is logged and up
// to BWKbVerifyMaxQueries queries (BWSendQuery) are sent, spaced
// ~2 s; any accepted STATE packet closes the episode (assignment
// alive — see BWOnStatePacket); exhausting the queries with no
// answer stops the reporter with reason=query-unanswered.
static int      BWKbSilenceQueries = 0;   // queries sent this episode
static NSTimeInterval BWKbVerifyLastQueryAt = 0;
static const int BWKbVerifyMaxQueries = 3;
static NSTimer *BWKbHeartbeatTimer = nil;

static uint32_t BWKbSession(void) {
    if (!BWKbSessionID) {
        BWKbSessionID = arc4random();
        if (!BWKbSessionID) BWKbSessionID = 1; // 0 reads as "none"
    }
    return BWKbSessionID;
}

// The FR-tracking truth (§5.5 primary evidence): a session is live
// exactly while the tracked responder stands. ABResponderBecame /
// ABResponderResigned are its only writers.
static BOOL BWKbSessionActiveNow(void) {
    return ABCurrentResponder != nil;
}

static void BWKbStatePost(BOOL active) {
    if (!BWKnown || !BWKbReporterLive) return; // no live identity (hash+gen) yet
    BWKbReportSeq++;
    NSDictionary *info = @{
        @"hash":    @(BWOwnHash28()),
        @"gen":     @(BWGen),
        @"session": @(BWKbSession()),
        @"seq":     @(BWKbReportSeq),
        @"state":   @(active ? 1 : 0),
        @"t":       @(BWNow()),
    };
    [[NSDistributedNotificationCenter defaultCenter]
        postNotificationName:BWKbStateChannel
                      object:[NSBundle mainBundle].bundleIdentifier
                    userInfo:info];
    BWKbReportedActive = active;
    BWKbHaveReported = YES;
}

// ACTIVE — called from ABResponderBecame, which the become hooks
// invoke ONLY after the original becomeFirstResponder has already
// succeeded: the responder is established and editing has begun.
// Never called at become-call time.
static void BWKbStateBecame(void) {
    BWKbStatePost(YES);
}

// INACTIVE decision on resign — DEFERRED one runloop tick. A focus
// move between two fields of this same app resigns the old field
// and becomes the new one back to back; deciding instantly would
// emit a false INACTIVE for a session that never ended. At the
// tick, the CURRENT tracked responder decides: one stands -> the
// session lives, nothing is posted; none stands -> the session
// truly ended, INACTIVE is posted (once — a heartbeat or a second
// deferred check finding the same closed state stays silent).
static void BWKbStateResignedDeferred(void) {
    dispatch_async(dispatch_get_main_queue(), ^{
        if (BWKbSessionActiveNow()) return; // focus moved, not ended
        if (BWKbHaveReported && !BWKbReportedActive) return;
        BWKbStatePost(NO);
    });
}

// Heartbeat (1 s, started in BWInstallBridgeWake): while the
// identity lives (BWKnown + BWKbReporterLive), re-post the CURRENT
// state with a fresh seq. This also carries the first INACTIVE of
// an identity learned while no responder stands, and corrects the
// record if the tracked responder died without a resign reaching
// the hooks (the weak ABCurrentResponder simply nils out).
// [hl2-l8] Silence death (SUPERSEDED by hl4-D2 below): the owner
// renews a live assignment's state ~every 1 s, so > 5 s without an
// accepted packet used to stop the reporter on presumption alone.
// In hl3 that presumption fired prematurely in 16/19 kb episodes —
// the pushes had stopped for other reasons while the assignment
// still lived.
// [hl4-D2] Verified death (GPT ruling 533ac9a): the reporter stops
// ONLY on a real teardown (BWResetAll) or after silence has been
// VERIFIED dead by query — abnormal silence (> 5 s, as before)
// logs a suspicion and sends up to 3 queries (BWSendQuery, ~2 s
// apart); the owner answers a live assignment's query with a
// fresh state packet, and any accepted STATE packet closes the
// episode in BWOnStatePacket (BWKbSilenceQueries reset). No
// answer after the last query -> stop, reason=query-unanswered:
// a genuinely dead assignment still stops (no return of the
// post-forever reject storm), but a live one is never presumed
// dead again. While an episode is open the reporter posts no
// renewals — its identity is exactly what is in question.
static void BWKbHeartbeatTick(void) {
    if (!BWKnown) return;
    if (BWKbReporterLive && BWStateRxAt > 0 && (BWNow() - BWStateRxAt) > 5.0) {
        NSTimeInterval now = BWNow();
        if (BWKbSilenceQueries == 0) {
            OMCLogWrite(@"AppBridge", [NSString stringWithFormat:
                @"[kbstate] reporter-suspect: state im lang %.1fs -- xac thuc bang query (toi da %d)",
                now - BWStateRxAt, BWKbVerifyMaxQueries]);
        }
        if (BWKbSilenceQueries < BWKbVerifyMaxQueries) {
            if (now - BWKbVerifyLastQueryAt >= 2.0) {
                BWSendQuery();
                BWKbSilenceQueries++;
                BWKbVerifyLastQueryAt = now;
                OMCLogWrite(@"AppBridge", [NSString stringWithFormat:
                    @"[kbstate] reporter-verify query %d/%d (im lang %.1fs)",
                    BWKbSilenceQueries, BWKbVerifyMaxQueries,
                    now - BWStateRxAt]);
            }
            return; // episode open: no renewals, no presumption
        }
        // One full query spacing after the last query, still silent.
        // [hl5-reporter] GPT verdict HL4->HL5, ruling 2: silence plus
        // unanswered queries is NOT proof of death — hl4's false stop
        // had a live assignment whose state packets were lost in the
        // shared state word. This stop is therefore recorded as
        // UNVERIFIED (a suspension): renewals pause, and the next
        // accepted STATE revives the reporter, exactly as it
        // self-healed in hl4. A REAL close arrives as an INACTIVE
        // state (owner revoke, hl5) and stops the reporter at once
        // with reason=owner-inactive.
        if (now - BWKbVerifyLastQueryAt >= 2.0) {
            BWKbReporterLive = NO;
            BWKbSilenceQueries = 0;
            BWKbVerifyLastQueryAt = 0;
            OMCLogWrite(@"AppBridge", [NSString stringWithFormat:
                @"[kbstate] reporter-stop reason=query-unanswered class=unverified (%d query khong tra loi, im lang %.1fs)",
                BWKbVerifyMaxQueries, now - BWStateRxAt]);
        }
        return;
    }
    BOOL active = BWKbSessionActiveNow();
    if (BWKbHaveReported && active == BWKbReportedActive) {
        BWKbStatePost(active); // renewal, new seq
        return;
    }
    BWKbStatePost(active); // first post for this identity, or a correction
}

static void BWCompleteTxn(void) {
    if (BWAckTimeoutBlock) {
        dispatch_block_cancel((dispatch_block_t)BWAckTimeoutBlock);
        BWAckTimeoutBlock = nil;
    }
    BWEngine = BWEngIdle;
    BWHeldTouches = nil;
    BWAcked = NO;
}

// Ack deadline (§5.4): 1.5 s after the swallowed chain ended. A timeout
// latches fail-open until the next fresh state packet; the wake is
// NEVER re-sent on Moved/Ended.
static void BWArmAckTimeout(uint32_t seq) {
    if (BWAckTimeoutBlock)
        dispatch_block_cancel((dispatch_block_t)BWAckTimeoutBlock);
    dispatch_block_t block = dispatch_block_create(0, ^{
        BWAckTimeoutBlock = nil;
        if (BWEngine == BWEngFinished && BWTxnSeq == seq && !BWAcked) {
            OMCLogWrite(@"AppBridge", [NSString stringWithFormat:
                @"[do] bw ack timeout seq=%lu: fail-open toi state tuoi ke tiep",
                (unsigned long)seq]);
            BWEngine = BWEngIdle;
            BWHeldTouches = nil;
            BWFailOpenLatch = YES;
        }
    });
    BWAckTimeoutBlock = block;
    dispatch_after(dispatch_time(0, 1500000000LL /* 1.5 s */),
                   dispatch_get_main_queue(), block);
}

static void BWOnStatePacket(uint64_t raw) {
    BWPacket p = BWUnpack(raw);
    // [hl5-rx] GPT verdict HL4->HL5, ruling 2 (measurement): STATE
    // and KB-SYNC share ONE Darwin state word on this channel, so a
    // packet can be overwritten between the owner's post and this
    // callback and vanish without a trace (the standing hypothesis
    // for the hl4 false reporter stop). Count what this callback
    // actually SEES — by type, and by drop reason — and while a
    // reporter verification episode is open, log every packet, so
    // the next session log shows whether state packets arrived
    // during the window at all, and if not, what arrived instead.
    static uint32_t bwRxState, bwRxKb, bwRxDropType, bwRxDropHash, bwRxDropGen;
    if (BWKbSilenceQueries > 0) {
        OMCLogWrite(@"AppBridge", [NSString stringWithFormat:
            @"[bw1] rx-during-verify type=%u state=%u gen=%u seq=%u",
            (unsigned)p.type, (unsigned)p.state,
            (unsigned)p.gen, (unsigned)p.seq]);
    }
    if (!p.valid || p.type == BWTypeInvalid) { bwRxDropType++; return; }
    if (p.type == BWTypeKbState) { bwRxKb++; BWOnKbPacket(p); return; } // WO ytz4 K2
    if (p.type != BWTypeState) { bwRxDropType++; return; }
    if (p.hash28 != BWOwnHash28()) { bwRxDropHash++; return; }
    if (!BWGenAccept(p.gen)) { bwRxDropGen++; return; }
    bwRxState++;
    if ((bwRxState + bwRxKb) % 64 == 1) {
        OMCLogWrite(@"AppBridge", [NSString stringWithFormat:
            @"[bw1] rx-sample state=%u kb=%u dropType=%u dropHash=%u dropGen=%u",
            bwRxState, bwRxKb, bwRxDropType, bwRxDropHash, bwRxDropGen]);
    }
    NSInteger st = BWNormState(p.state);
    NSTimeInterval now = BWNow();
    if (!BWKnown || st != BWState) BWStateChangedAt = now;
    // [hl2-g6] flip counter (G6 iii): count every observed BWState
    // value change, including the first accepted snapshot when it
    // differs from the standing Unknown.
    if (st != BWState) { BWStateFlipCount++; BWPrevState = BWState; }
    BWStateSeq = p.seq;
    BWState = st;
    BWGen = p.gen;
    BWWakeMode = BWNormMode(p.wakeMode);
    BWPinchMode = BWNormMode(p.pinchMode);
    BWPinchAllowed = (p.flag != 0);
    BWKnown = YES;
    if (st == BWStateInactive) {
        // [hl5-revoke] GPT verdict HL4->HL5, ruling 2: an accepted
        // INACTIVE is the owner stating this assignment is CLOSED —
        // it must close the local identity, never open it. Before
        // hl5, the code below set BWActSessionVerified and
        // BWKbReporterLive for EVERY accepted state, INACTIVE
        // included, so a torn-down app kept a "verified" identity:
        // its kbstate reporter stayed live until a 12-14 s query
        // timeout, and it posted act packets with the revoked
        // identity minutes after teardown (hl4: act posted with
        // stateage ~184 s, correctly rejected bad-hash by the
        // owner). Close in place: reporter stops NOW with its own
        // reason, the act session is unverified (the act gate's
        // existing session check now actually engages), any open
        // verification episode ends as answered-by-revoke, and the
        // pinch recognizer detaches. BWGen/BWState stay latched so a
        // later live state still passes BWGenAccept; BWResetAll
        // remains the full teardown for the distributed close
        // channels.
        BWActSessionVerified = NO;
        BWKbReporterLive = NO;
        if (BWKbSilenceQueries > 0) {
            OMCLogWrite(@"AppBridge", [NSString stringWithFormat:
                @"[kbstate] reporter-verify answered=INACTIVE sau %d query — assignment da dong",
                BWKbSilenceQueries]);
            BWKbSilenceQueries = 0;
            BWKbVerifyLastQueryAt = 0;
        }
        OMCLogWrite(@"AppBridge",
            @"[kbstate] reporter-stop reason=owner-inactive (assignment closed by owner STATE)");
        BWKnown = NO;
        ABPinchDetach();
        return;
    }
    BWActSessionVerified = YES; // WO fix-w W2-A: this acceptance (valid
                                // pack + own hash + gen accepted) is the
                                // act feed's session identity.
    BWStateRxAt = now;
    BWKbReporterLive = YES; // [hl2-l8] accepted packet = live assignment: reporter (re)starts
    // [hl4-D2] an accepted STATE packet is the answer the silence
    // verification was waiting for: the assignment lives — close
    // any open episode and clear the silence clock (BWStateRxAt
    // above already restarted it).
    if (BWKbSilenceQueries > 0) {
        OMCLogWrite(@"AppBridge", [NSString stringWithFormat:
            @"[kbstate] reporter-verify answered sau %d query — assignment con song",
            BWKbSilenceQueries]);
        BWKbSilenceQueries = 0;
        BWKbVerifyLastQueryAt = 0;
    }
    // [hl3] this accept IS the push latching the local decision
    // state (BWState/BWWakeMode/BWPinch*) the swallow gate reads —
    // no freshness window is applied to it downstream.
    // A fresh state packet is the unlock condition of §5.4 for both the
    // mixed-touch lock and the ack-timeout latch.
    BWSuppressLocked = NO;
    BWFailOpenLatch = NO;
    // [hl2-w6] an accepted packet is the assignment living: give the
    // pinch recognizer its chance to land on the hosted window.
    ABPinchTryAttach();
}

static void BWOnAckPacket(uint64_t raw) {
    BWPacket p = BWUnpack(raw);
    // [hl5-ack] GPT verdict HL4->HL5, ruling 4 (P1 telemetry): every
    // return below used to be silent, so for hl4's one ack timeout
    // nobody could tell whether the role=0 ack never arrived, was
    // overwritten in the shared ack state word by another pane's
    // ack, or arrived and failed a check. Record the raw callback
    // BEFORE any filter, then name the drop. No behaviour change:
    // same checks, same order, same consumption.
    OMCLogWrite(@"AppBridge", [NSString stringWithFormat:
        @"[do] bw ack-cb type=%u flag=%u hash=%08x gen=%u seq=%lu txn=%lu engine=%d known=%d",
        (unsigned)p.type, (unsigned)p.flag, p.hash28, (unsigned)p.gen,
        (unsigned long)p.seq, (unsigned long)BWTxnSeq, (int)BWEngine,
        BWKnown ? 1 : 0]);
    if (!p.valid || p.type == BWTypeInvalid) {
        OMCLogWrite(@"AppBridge", @"[do] bw ack-drop reason=invalid");
        return;
    }
    if (p.type != BWTypeAck) {
        OMCLogWrite(@"AppBridge", @"[do] bw ack-drop reason=type");
        return;
    }
    if (p.flag != 0) { // role: only owner->app acks are consumed here
        OMCLogWrite(@"AppBridge", @"[do] bw ack-drop reason=role");
        return;
    }
    if (p.hash28 != BWOwnHash28()) {
        OMCLogWrite(@"AppBridge", @"[do] bw ack-drop reason=hash");
        return;
    }
    if (p.gen != BWGen) {
        OMCLogWrite(@"AppBridge", @"[do] bw ack-drop reason=gen");
        return;
    }
    if (BWEngine == BWEngIdle) {
        OMCLogWrite(@"AppBridge", @"[do] bw ack-drop reason=engine-idle");
        return;
    }
    if (p.seq != BWTxnSeq) {
        OMCLogWrite(@"AppBridge", @"[do] bw ack-drop reason=seq");
        return;
    }
    if (BWAcked) {
        OMCLogWrite(@"AppBridge", @"[do] bw ack-drop reason=acked");
        return;
    }
    BWAcked = YES;
    OMCLogWrite(@"AppBridge", [NSString stringWithFormat:
        @"[do] bw ack seq=%lu", (unsigned long)p.seq]);
    if (BWEngine == BWEngFinished) BWCompleteTxn();
}
// [hl11kb] DuoFace QA179-181 taught the correct ownership boundary:
// the native keyboard WINDOW and key window must be inspected INSIDE
// the hosted app process. The remote host's SpringBoard window scan is
// BLIND to that state. Resize only the app's own visible keyboard window,
// never the app's full screen or keyplane, and restore on hide/release.
static __weak UIWindow *ABNativeKbWindow;
static CGRect ABNativeKbOriginal;
static BOOL ABNativeKbHasOriginal = NO;
static NSUInteger ABNativeKbEpoch = 0;
// [hl23-kbphysical] Validated session-local dimensions from the host's
// existing orientation packet. Zero means unknown; never guess a pane width
// from the phone screen and never apply this limit outside a hosted scene.
static CGFloat ABNativeKbPhysicalWidth = 0;
static CGFloat ABNativeKbLogicalWidth = 0;
 // [hl22-keyplane] UIKit owns the keys. Only when a visible layout subtree
 // is wider than the actual keyboard window do we apply a reversible
 // UIView transform to that subtree. Its hit-test coordinates transform
 // together with the keys; do not spoof keyboardScreenReferenceSize or
 // overwrite the private keyplane/individual keys.
static __weak UIView *ABNativeKbLayoutView;
static CGAffineTransform ABNativeKbLayoutOriginalTransform;
static CGPoint ABNativeKbLayoutOriginalCenter;
static BOOL ABNativeKbLayoutAdjusted = NO;

static UIView *ABNativeKbFindLayout(UIView *view, NSUInteger depth) {
    if (!view || depth > 14) return nil;
    if ([NSStringFromClass(view.class) containsString:@"UIKeyboardLayoutStar"])
        return view;
    for (UIView *child in view.subviews) {
        UIView *found = ABNativeKbFindLayout(child, depth + 1);
        if (found) return found;
    }
    return nil;
}

static void ABNativeKbRestoreLayout(void) {
    UIView *view = ABNativeKbLayoutView;
    if (ABNativeKbLayoutAdjusted && view) {
        view.transform = ABNativeKbLayoutOriginalTransform;
        view.center = ABNativeKbLayoutOriginalCenter;
    }
    ABNativeKbLayoutView = nil;
    ABNativeKbLayoutAdjusted = NO;
}

// Geometry verification is deliberately conservative: we only scale if
// the key-layout visual rect would otherwise exceed the window viewport.
// No assumptions about the labels or contents of any individual key.
static BOOL ABNativeKbFitLayout(UIWindow *window, CGFloat *widthBefore,
                                CGFloat *widthAfter, CGFloat *ratioOut) {
    if (widthBefore) *widthBefore = 0;
    if (widthAfter) *widthAfter = 0;
    if (ratioOut) *ratioOut = 1;
    if (!window) return NO;
    UIView *layout = ABNativeKbFindLayout(window, 0);
    if (!layout) return NO;
    if (ABNativeKbLayoutAdjusted && layout != ABNativeKbLayoutView)
        ABNativeKbRestoreLayout();
    if (ABNativeKbLayoutAdjusted && layout == ABNativeKbLayoutView) {
        layout.transform = ABNativeKbLayoutOriginalTransform;
        layout.center = ABNativeKbLayoutOriginalCenter;
    }
    CGRect before = [layout convertRect:layout.bounds toView:window];
    CGFloat targetWidth = window.bounds.size.width;
    // [hl23-kbphysical] A floating keyboard window can be logical-width
    // while its CarPlay viewport is physically narrower (e.g. 495 -> 396).
    // Use the physical limit only when the host-stamped logical width
    // actually matches this keyboard window. Otherwise fail open.
    if (ABNativeKbPhysicalWidth >= 100 &&
        ABNativeKbLogicalWidth >= ABNativeKbPhysicalWidth &&
        fabs(ABNativeKbLogicalWidth - targetWidth) <= 8.0)
        targetWidth = MIN(targetWidth, ABNativeKbPhysicalWidth);
    CGFloat width = before.size.width;
    if (widthBefore) *widthBefore = width;
    if (!isfinite(width) || !isfinite(targetWidth) ||
        width < 50 || targetWidth < 90 || CGRectIsEmpty(before))
        return NO;
    const CGFloat inset = 2.0;
    CGFloat startX = MAX(0, CGRectGetMinX(before));
    CGFloat available = targetWidth - startX - inset;
    CGFloat factor = width > available + 2.0 ? available / width : 1.0;
    // Avoid corrupting UIKit geometry on unrealistic/stale view sizes.
    if (factor < 0.40 || factor > 1.0) return NO;
    if (factor < 0.999) {
        if (!ABNativeKbLayoutAdjusted) {
            ABNativeKbLayoutView = layout;
            ABNativeKbLayoutOriginalTransform = layout.transform;
            ABNativeKbLayoutOriginalCenter = layout.center;
            ABNativeKbLayoutAdjusted = YES;
        }
        layout.transform = CGAffineTransformScale(
            ABNativeKbLayoutOriginalTransform, factor, 1.0);
        CGRect scaled = [layout convertRect:layout.bounds toView:window];
        CGPoint center = layout.center;
        center.x += startX - CGRectGetMinX(scaled);
        layout.center = center;
    } else if (ABNativeKbLayoutAdjusted) {
        ABNativeKbRestoreLayout();
    }
    CGRect after = [layout convertRect:layout.bounds toView:window];
    if (widthAfter) *widthAfter = after.size.width;
    if (ratioOut) *ratioOut = factor;
    return CGRectGetMinX(after) >= -2.0 &&
           CGRectGetMaxX(after) <= targetWidth + 2.0;
}


static NSArray<UIWindow *> *ABNativeKbWindows(void) {
    NSMutableArray<UIWindow *> *out = [NSMutableArray array];
    for (UIScene *scene in [UIApplication sharedApplication].connectedScenes) {
        if (![scene isKindOfClass:UIWindowScene.class]) continue;
        for (UIWindow *w in ((UIWindowScene *)scene).windows)
            if (![out containsObject:w]) [out addObject:w];
    }
    // UIRemoteKeyboardWindow is often absent from scene.windows.
    // DuoFace QA179 uses the guarded, process-local internal list.
    @try {
        SEL sel = NSSelectorFromString(
            @"allWindowsIncludingInternalWindows:onlyVisibleWindows:");
        if ([UIWindow respondsToSelector:sel]) {
            NSArray *more = ((NSArray *(*)(id, SEL, BOOL, BOOL))objc_msgSend)(
                (id)UIWindow.class, sel, YES, NO);
            if ([more isKindOfClass:NSArray.class])
                for (id item in more)
                    if ([item isKindOfClass:UIWindow.class] &&
                        ![out containsObject:item])
                        [out addObject:item];
        }
    } @catch (__unused NSException *e) {}
    return out;
}

static void ABNativeKbRestore(NSString *reason) {
    ABNativeKbRestoreLayout();
    if (!ABNativeKbHasOriginal) return;
    UIWindow *window = ABNativeKbWindow;
    if (window && !CGRectEqualToRect(window.frame, ABNativeKbOriginal))
        window.frame = ABNativeKbOriginal;
    OMCLogWrite(@"AppBridge", [NSString stringWithFormat:
        @"[hl11kb] ev=restore reason=%@ found=%d original=%@",
        reason, (int)(window != nil), NSStringFromCGRect(ABNativeKbOriginal)]);
    ABNativeKbWindow = nil;
    ABNativeKbHasOriginal = NO;
}

static BOOL ABNativeKbFit(NSString *when, NSInteger attempt) {
    if (ABForcedOrientation < 1 || ABDrawnKb ||
        !ABCurrentResponder || ![ABCurrentResponder isFirstResponder])
        return NO;
    NSArray<UIWindow *> *windows = ABNativeKbWindows();
    UIWindow *key = nil, *keyboard = nil;
    for (UIWindow *w in windows) {
        NSString *cn = NSStringFromClass(w.class);
        BOOL kb = [cn containsString:@"Keyboard"];
        BOOL textEffects = [cn containsString:@"TextEffects"];
        if (kb) {
            if (!keyboard || (keyboard.hidden && !w.hidden))
                keyboard = w;
        } else if (!textEffects &&
                   fabs(w.windowLevel - UIWindowLevelNormal) < 0.5 &&
                   !w.hidden) {
            if (w.isKeyWindow) key = w;
            else if (!key) key = w;
        }
    }
    // The key-window rect is the same authority DuoFace used. If
    // phone and key-window sizes are equal, there is nothing to fit.
    CGRect target = key ? key.frame : CGRectNull;
    BOOL visibleKeyboard = keyboard && !keyboard.hidden &&
        keyboard.alpha > 0.01 && !CGRectIsEmpty(keyboard.bounds);
    NSString *reason = !keyboard ? @"no-kb-window" :
                       !visibleKeyboard ? @"kb-not-visible" :
                       !key ? @"no-key-window" :
                       CGRectIsEmpty(target) ? @"empty-target" :
                       CGRectEqualToRect(keyboard.frame, target)
                           ? @"already-fit" : @"applied";
    CGFloat layoutBefore = 0, layoutAfter = 0, layoutRatio = 1;
    BOOL layoutMeasured = NO;
    if (visibleKeyboard && key && !CGRectIsEmpty(target)) {
        if (ABNativeKbHasOriginal && keyboard != ABNativeKbWindow)
            ABNativeKbRestore(@"window-replaced");
        BOOL changedFrame = !CGRectEqualToRect(keyboard.frame, target);
        if (changedFrame && !ABNativeKbHasOriginal) {
            ABNativeKbWindow = keyboard;
            ABNativeKbOriginal = keyboard.frame;
            ABNativeKbHasOriginal = YES;
        }
        if (changedFrame) keyboard.frame = target;
        layoutMeasured = ABNativeKbFitLayout(
            keyboard, &layoutBefore, &layoutAfter, &layoutRatio);
        if (ABNativeKbLayoutAdjusted && !ABNativeKbHasOriginal) {
            ABNativeKbWindow = keyboard;
            ABNativeKbOriginal = changedFrame ? ABNativeKbOriginal : keyboard.frame;
            ABNativeKbHasOriginal = YES;
        }
    }
    OMCLogWrite(@"AppBridge", [NSString stringWithFormat:
        @"[hl22-keyplane] when=%@ try=%ld found=%d starBefore=%.1f starAfter=%.1f "
         "factor=%.3f viewport=%.1f physicalW=%.1f logicalW=%.1f adjusted=%d",
        when, (long)attempt, (int)layoutMeasured, layoutBefore, layoutAfter,
        layoutRatio, keyboard ? keyboard.bounds.size.width : 0,
        ABNativeKbPhysicalWidth, ABNativeKbLogicalWidth,
        (int)ABNativeKbLayoutAdjusted]);
    OMCLogWrite(@"AppBridge", [NSString stringWithFormat:
        @"[hl11kb] ev=native-fit when=%@ try=%ld result=%@ "
         "windows=%lu key=%@ keyFrame=%@ kb=%@ kbFrame=%@ "
         "kbHidden=%d screen=%@ focus=1",
        when, (long)attempt, reason, (unsigned long)windows.count,
        key ? NSStringFromClass(key.class) : @"none",
        key ? NSStringFromCGRect(key.frame) : @"nil",
        keyboard ? NSStringFromClass(keyboard.class) : @"none",
        keyboard ? NSStringFromCGRect(keyboard.frame) : @"nil",
        keyboard ? (int)keyboard.hidden : -1,
        NSStringFromCGRect(UIScreen.mainScreen.bounds)]);
    // A fitted window with an oversized keyboard subtree is NOT success.
    // If UIKit has not created LayoutStar yet, defer the layout verdict.
    return visibleKeyboard && key != nil && !CGRectIsEmpty(target) &&
           layoutMeasured;
}

static void ABNativeKbBegin(NSString *why) {
    if (ABForcedOrientation < 1 || ABDrawnKb ||
        !ABCurrentResponder || ![ABCurrentResponder isFirstResponder])
        return;
    NSUInteger epoch = ++ABNativeKbEpoch;
    ABNativeKbFit(why, 0);
    // [hl23-kbphysical] Never mistake a fitted outer window at first-show
    // for the final UIKit keyplane. UIKit may relayout on the next tick
    // without changing the keyboard frame or emitting another DidShow.
    // Keep bounded follow-up evaluations even if the initial fit succeeded.
    for (NSUInteger n = 1; n <= 3; n++) {
        NSTimeInterval delay = n == 1 ? 0.3 : (n == 2 ? 0.6 : 1.2);
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW,
                                     (int64_t)(delay * NSEC_PER_SEC)),
                       dispatch_get_main_queue(), ^{
            if (epoch != ABNativeKbEpoch || ABForcedOrientation < 1 ||
                !ABCurrentResponder ||
                ![ABCurrentResponder isFirstResponder]) return;
            BOOL found = ABNativeKbFit(@"retry", (NSInteger)n);
            if (!found && n == 1 &&
                [ABCurrentResponder respondsToSelector:@selector(reloadInputViews)]) {
                // One bounded native UIKit re-evaluation when a valid
                // responder exists but no keyboard window materialized.
                [ABCurrentResponder reloadInputViews];
                OMCLogWrite(@"AppBridge",
                    @"[hl11kb] ev=reload-input-views reason=no-kb-window");
            }
        });
    }
}

static void ABNativeKbWindowVisible(NSNotification *note) {
    if (ABForcedOrientation < 1 || ABDrawnKb) return;
    id obj = note.object;
    if (![obj isKindOfClass:UIWindow.class] ||
        ![NSStringFromClass([obj class]) containsString:@"Keyboard"])
        return;
    ABNativeKbFit(@"window-visible", 0);
}

// ---- keyboard guard: auxiliary notification evidence (§5.5) ----
// A show/change-frame counts as "visible" evidence ONLY with a real
// on-screen frame (origin.y in (0, screen height)); parked frames are
// ignored. A hide NEVER lowers ACTIVE on its own: the car keyboard
// lives in SpringBoard behind a blank inputView, so the system
// notifications may not fire at all in this process — only the
// first-responder session (ABResponderBecame/Resigned) may do that.
static void BWKbFrameNote(NSNotification *note) {
    NSValue *v = note.userInfo[UIKeyboardFrameEndUserInfoKey];
    if (ABHL8Trace())
        OMCLogWrite(@"AppBridge", [NSString stringWithFormat:
            @"[hl8diag] eye=kb-app ev=keyboard-frame-notify "
             "name=%@ frame=%@ focus=%d",
            note.name, [v isKindOfClass:NSValue.class]
                ? NSStringFromCGRect(v.CGRectValue) : @"missing",
            (int)(ABCurrentResponder != nil)]);
    if (![v isKindOfClass:NSValue.class]) return;
    CGRect f = v.CGRectValue;
    CGFloat h = [UIScreen mainScreen].bounds.size.height;
    if (f.origin.y > 0 && f.origin.y < h) BWKbLocalSet(BWKbActive);
    // Defer to the next main-loop pass: UIKit may still be laying out its
    // keyboard when UIKeyboardDidChangeFrame fires. No new keyboard created.
    if (ABCurrentResponder && [ABCurrentResponder isFirstResponder] &&
        !ABDrawnKb && ABForcedOrientation >= 1) {
        NSUInteger epoch = ABNativeKbEpoch;
        dispatch_async(dispatch_get_main_queue(), ^{
            if (epoch == ABNativeKbEpoch && ABCurrentResponder &&
                [ABCurrentResponder isFirstResponder] &&
                ABForcedOrientation >= 1)
                ABNativeKbFit(@"keyboard-frame", 0);
        });
    }
}
static void BWKbHideNote(NSNotification *note) {
    (void)note;
    // Definitive "not shown" only when no responder session is live.
    if (!ABCurrentResponder && BWKb == BWKbUnknown) BWKbLocalSet(BWKbInactive);
}

static const char *BWStateLetter(NSInteger s) {
    switch (s) {
        case BWStateInactive: return "I";
        case BWStateVisible:  return "V";
        case BWStateHidden:   return "H";
        case BWStateWaking:   return "W";
        default:              return "U";
    }
}

// ---- suppression gate (WO §V, mapped 1:1 in design §5.4) ----
// Evaluated ONCE at a sequence's Began. The mode check is the caller's
// (the probe evaluates as-if ENFORCE); every other condition lives
// here. *reason receives the fail-open cause for the probe log.
// [hl3] Decision basis = QA180 h1wake3 shape: latched push state
// (no freshness veto) + LOCAL first-hand kb (no owner round-trip).
static BOOL BWGatePass(UIEvent *event, NSString **reason) {
    if (reason) *reason = nil;
    if (!BWKnown) { if (reason) *reason = @"unknown"; return NO; }
    // [hl3] LOCAL-PUSH decision (QA180 h1wake3 shape): BWState is
    // the pane state LATCHED at the last accepted push (or query
    // answer) — there is NO freshness veto here any more. The
    // 2.5 s staleness arithmetic that used to kill this gate
    // (reason=stale) is removed from the swallow decision; the
    // packet channel still feeds diagnostics/AutoHide, and the
    // query path (BWQueryIfStale at sequence start) remains the
    // self-heal if a push was missed. The ack-timeout latch below
    // is an EVENT latch (set on ack timeout, cleared by the next
    // accepted packet in BWOnStatePacket), not age arithmetic.
    if (BWFailOpenLatch) { if (reason) *reason = @"stale"; return NO; }
    // known && hidden: any other state (incl. WAKING) is a normal
    // pass-through, not a fail-open.
    if (BWState != BWStateHidden) return NO;
    // [hl2-g6] EXPANDED arbitration (G6 ii; ruling §2 invariant 3):
    // HIDDEN + pinchAllowed=1 + pinchMode=ENFORCE yields the chain
    // to pinch-in — the gate must NOT swallow finger 1 of the
    // pinch-in that exits fullscreen. Why this triple can only be
    // EXPANDED: the owner's bwPinchAllowedForPane: grants
    // pinchAllowed in SPLIT only while the pane is VISIBLE, but in
    // EXPANDED regardless of BWState (SCPCarSplit+BridgeWake.m);
    // so a HIDDEN snapshot carrying pinchAllowed=1 cannot be a
    // SPLIT pane — SPLIT+HIDDEN always arrives with allowed=0 and
    // still swallows above this line's siblings. ENFORCE is
    // required so a DRY_RUN/OFF pinch never disarms the wake gate.
    if (BWPinchAllowed && BWPinchMode == BWModeEnforce) {
        if (reason) *reason = @"pinchin";
        OMCLogWrite(@"AppBridge", [NSString stringWithFormat:
            @"[gate3] bw gate yield pinch-in: state=H pinchAllowed=1 pinchMode=enforce stateSeq=%lu",
            (unsigned long)BWStateSeq]);
        return NO;
    }
    // [hl3] kb guard on the LOCAL first-hand state ONLY (QA180
    // shape): BWKb is this app's own input-session truth, written
    // by the same responder hooks that drive the kbstate reporter
    // (BWKbLocalSet) — a live session in THIS process cannot exist
    // without them having fired, so local ACTIVE is the only kb
    // block, and local UNKNOWN honestly means "no session ever
    // observed here", not a missing measurement. The round-trip
    // through the owner (type-6 bits -> BWKbEffective) is REMOVED
    // from the swallow decision: BWKbEffective survives for the
    // AutoHide act flag, the pinch arbitration and the probe
    // instruments, where the loop delay is harmless. (The old
    // kbunknown block belonged to the round-trip design; with a
    // first-hand source it only disarmed the gate.)
    if (BWKb == BWKbActive)  { if (reason) *reason = @"kb"; return NO; }
    if (BWSuppressLocked) { if (reason) *reason = @"mixed"; return NO; }
    // transitioning: a wake transaction still in flight — never
    // swallow on a moving state.
    if (BWEngine != BWEngIdle) return NO;
    // [hl4-C1] The 250 ms transition gate STAYS (GPT ruling
    // 533ac9a) but now names itself: in hl3 a sequence starting
    // 123 ms after the last state flip failed open WITHOUT a
    // reason and was read as a generic fail-open, when in fact
    // this gate was working exactly as designed (never swallow
    // on a moving state).
    // [hl6-wake] GPT work order HL5->HL6 (d313f17), item 1c: the
    // blanket form is REFUTED by a device specimen — hl5 session B
    // 10:30:32.794 the owner settled VISIBLE -> HIDDEN by fade;
    // the Began at +152 ms (stateAgeMs=151) failed open on this
    // guard and the touch reached the app under a just-hidden UI,
    // exactly the video symptom "tap right after hiding goes into
    // the app; only later taps swallow". The guard is therefore
    // SCOPED to unsettled transitions: a flip INTO Hidden out of
    // WAKING means a wake transaction just collapsed and the state
    // may still move — the guard keeps vetoing there, under its
    // existing name. Every other road here is settled by the
    // checks above: the HIDDEN latch is positively verified (an
    // accepted packet), the state is not WAKING, touches are not
    // mixed (BWSuppressLocked), kb is not ACTIVE and no wake
    // transaction is in flight (BWEngine idle) — a fade settle
    // VISIBLE -> HIDDEN is final, so the gate swallows at once.
    // Fail-open behaviour of every other branch is unchanged.
    if (BWPrevState == BWStateWaking &&
        BWNow() - BWStateChangedAt < 0.25) {
        if (reason) *reason = @"transition-250ms";
        return NO;
    }
    // targetVerified + mixedTouches over the Began touches (§5.1): a
    // sequence belongs to the hosted session only if it starts on the
    // verified hosted window; a nil window is "notarget", a different
    // window is classified "phone" (iPhone-screen touch — Gate 2 must
    // confirm this classification before ENFORCE may rely on it).
    UIWindow *key = ABKeyWindow();
    // [hl2-g6] key-window hole (G6 i, GPT log review §5): the old
    // test `key && t.window != key` let EVERY touch through when
    // ABKeyWindow() was nil — there was no confirmed hosted key
    // window to belong to, yet the gate passed. Now a nil key
    // window fails open (no swallow), exactly like a touch on any
    // other window than the confirmed hosted key window.
    if (!key) { if (reason) *reason = @"nokeywindow"; return NO; }
    NSUInteger beganCount = 0;
    for (UITouch *t in event.allTouches) {
        if (t.phase != UITouchPhaseBegan) continue;
        beganCount++;
        if (!t.window) { if (reason) *reason = @"notarget"; return NO; }
        if (t.window != key) { if (reason) *reason = @"phone"; return NO; }
    }
    if (beganCount == 0) return NO;
    if (beganCount > 1) { if (reason) *reason = @"mixed"; return NO; }
    return YES;
}

static void BWBeginSwallow(NSSet *beganTouches) {
    BWEngine = BWEngSwallowing;
    BWHeldTouches = [beganTouches mutableCopy];
    BWTxnSeq = (++BWNextTxnSeq) & 0xFFFu;
    BWAcked = NO;
    BWPostWake(BWTxnSeq); // exactly one wake per swallowed chain (§5.4)
    OMCLogWrite(@"AppBridge", [NSString stringWithFormat:
        @"[do] bw nuot day: txn=%lu probe=%lu",
        (unsigned long)BWTxnSeq, (unsigned long)BWProbeSeqNo]);
}

// wouldPinch distance tracking: current two-touch distance only.
static void BWUpdatePairDistance(void) {
    if (BWActiveTouches.count != 2) return;
    NSArray *ts = BWActiveTouches.allObjects;
    CGPoint a = [ts[0] locationInView:nil];
    CGPoint b = [ts[1] locationInView:nil];
    double d = hypot((double)(a.x - b.x), (double)(a.y - b.y));
    if (BWPairD0 < 0) { BWPairD0 = BWPairDMin = BWPairDMax = d; }
    else {
        if (d < BWPairDMin) BWPairDMin = d;
        if (d > BWPairDMax) BWPairDMax = d;
    }
}

static BOOL BWComputeWouldPinch(void) {
    if (BWSeqTouches.count != 2) return NO;   // exactly 2 touches, whole seq
    if (BWEffectivePinchMode() == BWModeOff) return NO;
    if (!BWPinchAllowed) return NO;           // owner arbitration (§5.3)
    if (BWPairD0 <= 0) return NO;
    double dev = MAX(BWPairDMax - BWPairD0, BWPairD0 - BWPairDMin) / BWPairD0;
    return dev > 0.10;                        // distance changed > 10%
}

static BOOL BWProbeLogging(void) {
    if (!BWKnown) return YES;  // default DRY_RUN posture (§4)
    if (!BWFresh()) return NO; // stale: only the 30 s summary continues
    return BWEffectiveWakeMode() != BWModeOff
        || BWEffectivePinchMode() != BWModeOff;
}

static void BWCloseSequence(void) {
    BOOL wouldPinch = BWComputeWouldPinch();
    if (BWLoggedSeqs >= 200) {   // cap reached: feed the 30 s summary
        BWOverSeqs++;
        if (BWSeqWouldSwallow) BWOverSwallow++;
        if (wouldPinch) BWOverPinch++;
        return;
    }
    if (!BWProbeLogging()) return;
    BWLoggedSeqs++;
    const char *kbSrc = BWSeqKbSrcAtStart == BWKbSrcOwner ? "owner"
                      : BWSeqKbSrcAtStart == BWKbSrcLocal ? "local"
                      : "none";
    OMCLogWrite(@"AppBridge", [NSString stringWithFormat:
        @"[do] bw probe seq=%lu ph B=%lu M=%lu E=%lu C=%lu dur=%.2f "
         "hosted=%d kbKnown=%d kbActive=%d kbSrc=%s kbAge=%ld "
         "state=%s stateSeq=%lu stateAgeMs=%ld stateFlips=%lu "
         "wouldSwallow=%d wouldPinch=%d failopen=%@ dsrc=local-push",
        (unsigned long)BWProbeSeqNo,
        (unsigned long)BWPhB, (unsigned long)BWPhM,
        (unsigned long)BWPhE, (unsigned long)BWPhC,
        BWNow() - BWSeqStartAt,
        BWSeqHosted ? 1 : 0,
        BWSeqKbKnownAtStart ? 1 : 0, BWSeqKbActiveAtStart ? 1 : 0,
        kbSrc, BWSeqKbAgeAtStart,
        BWStateLetter(BWSeqStateAtStart),
        (unsigned long)BWSeqStateSeqAtStart, BWSeqStateAgeAtStart,
        (unsigned long)BWSeqStateFlipsAtStart,
        BWSeqWouldSwallow ? 1 : 0, wouldPinch ? 1 : 0,
        BWSeqFailOpen ? BWSeqFailOpen : @"-"]);
}

static void BWStartSummaryTimer(void) {
    dispatch_after(dispatch_time(0, 30000000000LL /* 30 s */),
                   dispatch_get_main_queue(), ^{
        if (BWOverSeqs > 0) {
            OMCLogWrite(@"AppBridge", [NSString stringWithFormat:
                @"[do] bw probe summary 30s seqs=%lu wouldSwallow=%lu wouldPinch=%lu",
                (unsigned long)BWOverSeqs, (unsigned long)BWOverSwallow,
                (unsigned long)BWOverPinch]);
            BWOverSeqs = BWOverSwallow = BWOverPinch = 0;
        }
        BWStartSummaryTimer();
    });
}
// ===========================================================================
// [hl2-w6] W6 — in-app pinch recognizer + relay (GPT ruling §1/§3).
// A REAL UIGestureRecognizer inside the hosted app process, on the
// hosted scene's real UIWindow — NOT a sendEvent: invention and NOT
// an overlay. When it Begins, UIKit itself cancels the touches it
// already delivered to the app's views (cancelsTouchesInView=YES);
// this code never calls touchesCancelled on the app, never forges a
// UIEvent, and never delays a one-finger touch
// (delaysTouchesBegan=NO). The recognizer owns NO fullscreen engine:
// the moment a pair forms (second finger down) it relays ONE toggle
// to the host on the NSDistributed channel
// com.anlai.omnicar/bridgewake.v1.pinch and the host's existing
// SCPFullscreenController remains the only FS owner.
//
// [hl4] ACTIVATION LAW — the arbitration layer is DELETED
// (Nguyen 2026-11-10 06:41: "làm giống" means the mechanism is
// IDENTICAL to the proven one, not similar to it). Builds 21-35
// had NO arbitration between the second finger and the toggle:
// the recognizer Began, UIKit cancelled the app's touches, and
// a bare toggle was relayed; the HOST flipped the fullscreen
// surface by its own real state. hl2/hl3 instead kept a
// pair-arbitration function (ABPinchPairDecision — latch /
// allowed / kb / mode gates, then dir derived app-side from a
// latched committed label) between the touch and the signal,
// and the car sessions showed what that layer cost: hl2 pinch
// died at its thresholds and at the app's committed label being
// wrong in 91/93 expanded-window Begans (PATCH 29.18 L2/L3/L4);
// hl3 removed the thresholds and the freshness veto but kept
// the arbitration, and pinch still fired expand 1x / restore
// 0x (PATCH 29.21). ABPinchPairDecision is therefore DELETED,
// not bypassed — the recognizer below was its only caller —
// and the activation path contains no condition at all beyond
// "a second touch landed in this window": Began -> relay
// dir=0 (toggle). The wake chain (BWHandleTouchEvent) is
// untouched: touches it swallows at SPLIT+HIDDEN never reach
// this recognizer, which is exactly how SPLIT+HIDDEN stays
// wake-first, and at EXPANDED+HIDDEN the wake gate yields
// (pinchin) so the pair still forms and toggles back. History
// of the deleted gates: hl2 §29.13 W6 (arbitration introduced),
// hl3 §29.19 (freshness veto removed from it), hl4 §29.22
// (the function itself deleted).
// ===========================================================================
static NSString *const BWPinchChannel = @"com.anlai.omnicar/bridgewake.v1.pinch";
static uint64_t BWPinchReportSeq = 0;  // per-source monotone; first fire = 1
                                       // (same discipline as BWKbReportSeq)
static NSUInteger BWPinchGidCounter = 0; // gesture id source; ++ per formed pair

// Relay ONE toggle command for a formed pair, fired at Began.
// [hl4] The payload asserts NO direction: dir = 0 is a bare
// toggle and the OWNER flips SCPFullscreenAdapter by its real
// currentState (SPLIT -> expand, EXPANDED -> restore). That is
// the builds-21-35 division of labour, and it removes the hl2
// L2/L3 failure mode by construction: an app-side direction can
// no longer disagree with the surface, because the app sends
// none. There is deliberately NO condition between the
// recognizer's Began and this post — the remaining fields are
// TRANSPORT only, with the kbstate reporter's discipline
// (BWKbStatePost): hash = BWOwnHash28(), gen = BWGen at fire
// time, session = BWKbSession() (minted once per load), seq =
// own per-source monotone; the owner validates them (badhash /
// badgen / badsession / dup / staleseq / stale-TTL) before
// anything fires — validation lives at the owner, never as a
// gate here. (The recognizer itself only exists while an
// assignment lives: ABPinchTryAttach is BWKnown-gated and
// BWResetAll detaches it with the assignment.) t is the
// exception to the kbstate discipline: that reporter stamps
// BWNow() (systemUptime) and its owner never cross-compares
// clocks (freshness is anchored at receipt), but the pinch
// owner DOES check a TTL against its own BWNow() =
// timeIntervalSince1970 (SplitScreenA/SCPCarSplit+BridgeWake.m),
// so this channel stamps wall-clock epoch seconds.
// (Coordinator alignment fix at hl2 integration — the first cut
// stamped uptime and every relay would have been rejected as
// stale.)
static void ABPinchRelayFire(NSUInteger gid) {
    BWPinchReportSeq++;
    NSDictionary *info = @{
        @"hash":    @(BWOwnHash28()),
        @"gen":     @(BWGen),
        @"session": @(BWKbSession()),
        @"seq":     @(BWPinchReportSeq),
        @"gid":     @(gid),
        @"dir":     @(0),
        @"t":       @([[NSDate date] timeIntervalSince1970]),
    };
    [[NSDistributedNotificationCenter defaultCenter]
        postNotificationName:BWPinchChannel
                      object:[NSBundle mainBundle].bundleIdentifier
                    userInfo:info];
    OMCLogWrite(@"AppBridge", [NSString stringWithFormat:
        @"[pinch2] trigger=began toggle-sent dir=0 seq=%llu gid=%lu "
         "gen=%lu stateSeq=%lu",
        (unsigned long long)BWPinchReportSeq, (unsigned long)gid,
        (unsigned long)BWGen, (unsigned long)BWStateSeq]);
}

@interface ABPinchGestureRecognizer : UIGestureRecognizer
@property (nonatomic, strong) NSMutableSet<UITouch *> *abTouches;
@property (nonatomic) BOOL abPairFormed;
@property (nonatomic) BOOL abConcluded; // pair fired; book clears at reset
@property (nonatomic) BOOL abFired;
@property (nonatomic) NSUInteger abGid;
@property (nonatomic) uint32_t abStateSeq; // state packet seq at formation (log only)
@end

@implementation ABPinchGestureRecognizer

- (instancetype)init {
    self = [super initWithTarget:nil action:nil];
    if (self) {
        // Ruling §1, non-negotiable: a real recognizer whose Began
        // makes UIKit cancel the app's touches; one-finger touches
        // are never held back (delaysTouchesBegan=NO).
        self.cancelsTouchesInView = YES;
        self.delaysTouchesBegan = NO;
        self.delaysTouchesEnded = NO;
        _abTouches = [NSMutableSet set];
    }
    return self;
}

- (void)abClearPair {
    _abPairFormed = NO;
    _abConcluded = NO;
    _abFired = NO;
    _abGid = 0;
    _abStateSeq = 0;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    // [hl6-pinch-measure] GPT work order HL5->HL6 (d313f17), item
    // 4 — MEASURE ONLY, at the recognizer itself. hl5 split the
    // failure in two (29.29): one incarnation died at the
    // BWKnown attach gate, another attached for ~386 s yet never
    // formed a pair — and the log could not say whether the second
    // finger ever REACHED this recognizer (every app-probe read
    // B=1; the CarPlay side cannot prove a two-finger formation
    // either, since one touch is mirrored through two windows).
    // This line records, for every Began the recognizer is shown:
    // its view/window (class + key + scene), how many touches this
    // call carries, how many DISTINCT touch objects the event
    // holds (pointer identities — never coordinates), the tracked
    // count after this call's touches join, the recognizer state,
    // its cancellation setting, whether any event touch lives on a
    // different (overlay) window, and the event type. No decision
    // reads any of it; the activation path below is untouched.
    {
        UIWindow *recWin = self.view.window;
        NSMutableString *touchIDs = [NSMutableString string];
        BOOL foreignWin = NO;
        for (UITouch *t in event.allTouches) {
            if (touchIDs.length) [touchIDs appendString:@","];
            [touchIDs appendFormat:@"%p", (void *)t];
            if (t.window && self.view.window && t.window != self.view.window)
                foreignWin = YES;
        }
        OMCLogWrite(@"AppBridge", [NSString stringWithFormat:
            @"[pinch2] began view=%@ win=%@ winKey=%d scene=%@ "
            @"touches=%lu distinct=%lu ids=[%@] tracked=%lu state=%ld "
            @"cancels=%d foreignWin=%d evType=%ld evSubtype=%ld "
            @"known=%d stateSeq=%lu",
            self.view ? NSStringFromClass(self.view.class) : @"nil",
            recWin ? NSStringFromClass(recWin.class) : @"nil",
            recWin ? (int)recWin.isKeyWindow : -1,
            recWin.windowScene ? NSStringFromClass(recWin.windowScene.class) : @"nil",
            (unsigned long)touches.count,
            (unsigned long)event.allTouches.count,
            touchIDs,
            (unsigned long)_abTouches.count,
            (long)self.state,
            self.cancelsTouchesInView ? 1 : 0,
            foreignWin ? 1 : 0,
            (long)event.type, (long)event.subtype,
            BWKnown ? 1 : 0, (unsigned long)BWStateSeq]);
    }
    for (UITouch *t in touches) {
        // Exactly-two-touches law, same window: this recognizer's
        // view IS the hosted window; a touch addressed anywhere
        // else is never counted into a pair.
        if (t.window && self.view && t.window != self.view) continue;
        [_abTouches addObject:t];
    }
    if (_abPairFormed || _abConcluded) {
        // The pair fires in the same touchesBegan that forms it
        // (below), so by the time any further finger lands the
        // toggle is already sent and the recognizer has Ended:
        // extra fingers change nothing, and -reset clears the
        // book when every touch lifts.
        return;
    }
    if (_abTouches.count != 2) return;
    // [hl4] FIRE AT BEGAN — the second finger landing IS the
    // whole decision (builds 21-35 law). No arbitration reads
    // anything here: Began makes UIKit cancel the touches
    // already delivered to the app's views, the relay posts a
    // bare toggle (dir=0), and Ended makes UIKit reset the
    // book so a fresh two-finger formation may toggle again.
    _abPairFormed = YES;
    _abGid = ++BWPinchGidCounter;
    _abStateSeq = BWStateSeq;
    _abFired = YES;
    _abConcluded = YES;
    self.state = UIGestureRecognizerStateBegan;
    ABPinchRelayFire(_abGid);
    self.state = UIGestureRecognizerStateEnded;
}

// -touchesMoved is intentionally NOT overridden: firing happens
// at pair formation in touchesBegan (see the activation law at
// the head of this section). The hl2 threshold engine that lived
// here — ratio-cross + mid-drift fire gate evaluated from Moved,
// with direction read off which cross tripped — was deleted in
// hl3, and the hl2/hl3 pair-arbitration function that gated
// formation was deleted in hl4: no movement of the pair and no
// state snapshot is consulted anywhere in this recognizer.

- (void)abTouchesFinished:(NSSet<UITouch *> *)touches cancelled:(BOOL)cancelled {
    for (UITouch *t in touches) [_abTouches removeObject:t];
    if (_abTouches.count > 0) return;
    if (self.state == UIGestureRecognizerStateBegan ||
        self.state == UIGestureRecognizerStateChanged) {
        // Pair dissolved before any fire: no relay was sent.
        OMCLogWrite(@"AppBridge", [NSString stringWithFormat:
            @"[pinch2] pair-end gid=%lu fired=0 cancelled=%d",
            (unsigned long)_abGid, cancelled ? 1 : 0]);
        self.state = UIGestureRecognizerStateFailed;
    }
    if (self.state == UIGestureRecognizerStatePossible) {
        // One-finger touches never left Possible, so UIKit will
        // not call -reset for them: clear the book here.
        [self abClearPair];
    }
    // Began -> Ended/Cancelled/Failed transitions make UIKit call
    // -reset, which clears the book there.
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self abTouchesFinished:touches cancelled:NO];
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self abTouchesFinished:touches cancelled:YES];
}

- (void)reset {
    [super reset];
    [_abTouches removeAllObjects];
    [self abClearPair];
}

@end

// Attach/detach: the recognizer lives on the real UIWindow of the
// hosted scene — ABKeyWindow(), the very window BWGatePass verifies
// touches against — and only while the hosted assignment lives (an
// accepted state packet for this bundle: BWKnown). ABPinchTryAttach
// is attempted on every accepted state packet and at every hosted
// sequence start, so a window that appears after the packet still
// gets the recognizer; BWResetAll detaches it with the assignment.
static ABPinchGestureRecognizer *ABPinchRec = nil;

static void ABPinchTryAttach(void) {
    if (!BWKnown) return; // no live assignment, nothing to attach to
    // [hl4-B] Pinch OFF gate, at the attach point (GPT ruling
    // 533ac9a): the latched packet pinchMode is CONFIG, read here
    // and only here — with pinchMode OFF the recognizer must not
    // exist on the window, or it would still cancel two-finger
    // touches and post toggles the owner never asked for. This is
    // not a pair-arbitration gate (nothing is decided per-touch);
    // it is the same class of check as the BWKnown gate above.
    // Mid-session flips land here too: BWOnStatePacket latches the
    // new BWPinchMode and calls ABPinchTryAttach on EVERY accepted
    // packet, so a flip to OFF detaches within one packet, and a
    // flip back re-attaches below.
    if (BWPinchMode == BWModeOff) {
        if (ABPinchRec && ABPinchRec.view) {
            ABPinchDetach();
            OMCLogWrite(@"AppBridge", @"[pinch2] detached reason=pinchmode-off");
        }
        return;
    }
    UIWindow *w = ABKeyWindow();
    if (!w) return;
    if (!ABPinchRec) ABPinchRec = [[ABPinchGestureRecognizer alloc] init];
    if (ABPinchRec.view == w) return;
    if (ABPinchRec.view) [ABPinchRec.view removeGestureRecognizer:ABPinchRec];
    [w addGestureRecognizer:ABPinchRec];
    OMCLogWrite(@"AppBridge", [NSString stringWithFormat:
        @"[pinch2] attached window=%p bundle=%@",
        (void *)w, [NSBundle mainBundle].bundleIdentifier]);
}

static void ABPinchDetach(void) {
    if (ABPinchRec && ABPinchRec.view) {
        [ABPinchRec.view removeGestureRecognizer:ABPinchRec];
        OMCLogWrite(@"AppBridge", @"[pinch2] detached");
    }
}

// ---- the one touch-path entry: probe + engine (§5.3/§5.4) ----
// Returns YES when this event belongs to a swallowed chain and must
// NOT reach the original implementation.
static BOOL BWHandleTouchEvent(UIEvent *event) {
    NSSet *touches = event.allTouches;
    if (touches.count == 0) return NO;
    NSMutableSet *began = [NSMutableSet set];
    NSMutableSet *ended = [NSMutableSet set];
    for (UITouch *t in touches) {
        if (t.phase == UITouchPhaseBegan) [began addObject:t];
        else if (t.phase == UITouchPhaseEnded ||
                 t.phase == UITouchPhaseCancelled) [ended addObject:t];
    }
    BOOL swallowEvent = NO;

    // Sequence start: latch the probe record and evaluate the gate
    // exactly once. A chain that begins pass-through is NEVER blocked
    // at a later phase (§5.4).
    if (!BWSeqActive && began.count > 0) {
        BWSeqActive = YES;
        BWProbeSeqNo++;
        BWSeqStartAt = BWNow();
        BWPhB = BWPhM = BWPhE = BWPhC = 0;
        BWActiveTouches = [NSMutableSet set];
        BWSeqTouches = [NSMutableSet set];
        BWPairD0 = BWPairDMin = BWPairDMax = -1;
        BWSeqStateAtStart = BWState;
        // [hl2-g6] latch the decision snapshot's provenance (G6 iii,
        // seq=45 truy ca): which state packet seq the gate is about
        // to use, how old that snapshot is right now, and how many
        // BWState flips this process has observed so far.
        BWSeqStateSeqAtStart = BWStateSeq;
        BWSeqStateAgeAtStart = BWKnown
            ? (long)((BWNow() - BWStateRxAt) * 1000.0) : -1L;
        BWSeqStateFlipsAtStart = BWStateFlipCount;
        {
            // kb instrument latch (WO ytz4 K2): decompose the
            // effective tri-state at this exact instant; the close
            // log below prints these verbatim.
            NSInteger kbSrc = BWKbSrcNone;
            long kbAge = -1;
            NSInteger kbEff = BWKbEffective(&kbSrc, &kbAge);
            BWSeqKbKnownAtStart  = (kbEff != BWKbUnknown);
            BWSeqKbActiveAtStart = (kbEff == BWKbActive);
            BWSeqKbSrcAtStart    = kbSrc;
            BWSeqKbAgeAtStart    = kbAge;
        }
        BWSeqHosted = (ABForcedOrientation >= 1);
        if (BWSeqHosted) {
            for (UITouch *t in began)
                if (!t.window) { BWSeqHosted = NO; break; }
        }
        // AutoHide activity feed (design-autohide §5.3; basis reworked
        // by WO fix-w W2-A/W3): a Began in the session-verified hosted
        // session, bound to the hosted scene, is activity whatever the
        // gate decides below. State freshness is NOT the criterion —
        // it remains the suppression gate's alone (BWGatePass).
        BWActOnSequenceStart(began);
        // [hl2-w6] a hosted sequence is flowing, so the hosted
        // window exists: retry the pinch recognizer attach in case
        // the window appeared after the last state packet.
        ABPinchTryAttach();
        NSString *reason = nil;
        BWSeqWouldSwallow = BWGatePass(event, &reason);
        BWSeqFailOpen = reason;
        if (BWSeqWouldSwallow && BWKnown
            && BWWakeMode == BWModeOff) {
            // The packet itself disables wake: report the mode, not a
            // phantom pass (probe still runs for pinch).
            BWSeqWouldSwallow = NO;
            BWSeqFailOpen = @"mode";
        }
        // [hl3] execution follows the LATCHED mode of the last
        // accepted packet (the trial writes ENFORCE into this
        // pane's packets host-side) — BWEffectiveWakeMode()'s
        // stale->OFF collapse no longer applies to the decision.
        if (BWSeqWouldSwallow && BWWakeMode == BWModeEnforce) {
            BWBeginSwallow(began);
            swallowEvent = YES;
        }
        if (!BWFresh()) BWQueryIfStale(); // self-heal: ask (§5.2)
    }

    // Phase counts, live set, pinch distances (internal only).
    if (BWSeqActive) {
        for (UITouch *t in touches) {
            switch (t.phase) {
                case UITouchPhaseBegan:     BWPhB++; break;
                case UITouchPhaseMoved:     BWPhM++; break;
                case UITouchPhaseEnded:     BWPhE++; break;
                case UITouchPhaseCancelled: BWPhC++; break;
                default: break;
            }
        }
        for (UITouch *t in began) {
            [BWActiveTouches addObject:t];
            [BWSeqTouches addObject:t];
        }
        BWUpdatePairDistance();
        for (UITouch *t in ended) [BWActiveTouches removeObject:t];
    }

    // Suppression engine: events of the held chain are dropped whole,
    // even if the state flips to VISIBLE mid-chain — a swallowed chain
    // is never converted to pass-through halfway (§5.4).
    if (BWEngine == BWEngSwallowing) {
        BOOL touchesHeld = NO;
        for (UITouch *t in touches)
            if ([BWHeldTouches containsObject:t]) { touchesHeld = YES; break; }
        if (touchesHeld || began.count > 0) {
            swallowEvent = YES;
            // A touch beginning mid-swallow is an unsupported mixed
            // chain: absorb it into the held chain so no chain is
            // ever left half-delivered, and lock suppression for new
            // sequences until the next fresh state packet (§5.4).
            for (UITouch *t in began) {
                if (![BWHeldTouches containsObject:t]) {
                    if (BWHeldTouches.count > 0) {
                        OMCLogWrite(@"AppBridge",
                            @"[do] bw mixed touch giua day nuot: khoa suppression toi state tuoi ke tiep");
                        BWSuppressLocked = YES;
                    }
                    [BWHeldTouches addObject:t];
                }
            }
            for (UITouch *t in ended) [BWHeldTouches removeObject:t];
            if (BWHeldTouches.count == 0) {
                if (BWAcked) BWCompleteTxn();
                else {
                    BWEngine = BWEngFinished;
                    BWArmAckTimeout(BWTxnSeq);
                }
            }
        }
    }

    if (BWSeqActive && BWActiveTouches.count == 0) {
        BWCloseSequence();
        BWSeqActive = NO;
    }
    return swallowEvent;
}

static IMP orig_SendEvent = NULL;
static void ABHook_SendEvent(UIApplication *self, SEL _cmd, UIEvent *event) {
    BOOL swallow = NO;
    if (event && event.type == UIEventTypeTouches)
        swallow = BWHandleTouchEvent(event);
    // Exactly ONE orig call site (§7.3 gate): taken once on every
    // pass-through path, never for a swallowed event.
    if (!swallow)
        ((void (*)(id, SEL, UIEvent *))orig_SendEvent)(self, _cmd, event);
}

// ---- install (§5.1): lazy, inside ABOrientationBlock, same one-shot
// condition as the other in-app hooks — the hook therefore exists only
// while this app is hosted. ----
static void BWInstallBridgeWake(void) {
    if (BWInstalled) return;
    BWInstalled = YES;
    MSHookMessageEx(objc_getClass("UIApplication"), @selector(sendEvent:),
                    (IMP)ABHook_SendEvent, &orig_SendEvent);
    notify_register_dispatch(BWNameState, &BWStateRxToken,
        dispatch_get_main_queue(),
        ^(int token) { uint64_t v = 0; notify_get_state(token, &v); BWOnStatePacket(v); });
    notify_register_dispatch(BWNameAck, &BWAckRxToken,
        dispatch_get_main_queue(),
        ^(int token) { uint64_t v = 0; notify_get_state(token, &v); BWOnAckPacket(v); });
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    NSOperationQueue *mq = [NSOperationQueue mainQueue];
    [nc addObserverForName:UIKeyboardWillShowNotification object:nil
                     queue:mq usingBlock:^(NSNotification *n) { BWKbFrameNote(n); }];
    [nc addObserverForName:UIKeyboardDidChangeFrameNotification object:nil
                     queue:mq usingBlock:^(NSNotification *n) { BWKbFrameNote(n); }];
    [nc addObserverForName:UIKeyboardWillHideNotification object:nil
                     queue:mq usingBlock:^(NSNotification *n) {
        BWKbHideNote(n);
        ++ABNativeKbEpoch;
        ABNativeKbRestore(@"will-hide");
    }];
    [nc addObserverForName:UIKeyboardDidShowNotification object:nil
                     queue:mq usingBlock:^(NSNotification *n) {
        (void)n;
        ABNativeKbBegin(@"did-show");
    }];
    [nc addObserverForName:UIWindowDidBecomeVisibleNotification object:nil
                     queue:mq usingBlock:^(NSNotification *n) {
        ABNativeKbWindowVisible(n);
    }];
    // [ytz5-k5] kbstate reporter heartbeat (1 s): posts only while
    // the identity lives (BWKnown + BWKbReporterLive) — see
    // BWKbHeartbeatTick. The timer is never invalidated; BWResetAll
    // closes the identity, and > 5 s of state silence stops the
    // reporter, so the tick goes silent, ready for the next session.
    if (!BWKbHeartbeatTimer) {
        BWKbHeartbeatTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 repeats:YES
            block:^(NSTimer *t) { (void)t; BWKbHeartbeatTick(); }];
    }
    BWStartSummaryTimer();
    BWSendQuery(); // ask for our state; never assume hidden (§5.1)
    OMCLogWrite(@"AppBridge", [NSString stringWithFormat:
        @"[do] bw cai sendEvent probe (%@)",
        [NSBundle mainBundle].bundleIdentifier]);
}

// ---- teardown (§5.6): registered for ABChanClose/ABChanCloseAll in
// ABInstallInAppObservers below. Everything returns to pristine; a
// pending ack wait is cancelled, never replayed, and no latch survives
// into the next hosted session. ----
static void BWResetAll(void) {
    if (BWAckTimeoutBlock) {
        dispatch_block_cancel((dispatch_block_t)BWAckTimeoutBlock);
        BWAckTimeoutBlock = nil;
    }
    BWEngine = BWEngIdle;
    BWHeldTouches = nil;
    BWActiveTouches = nil;
    BWSeqTouches = nil;
    BWSeqActive = NO;
    BWAcked = NO;
    BWSuppressLocked = NO;
    BWFailOpenLatch = NO;
    BWState = BWStateUnknown;
    BWPrevState = BWStateUnknown; // [hl6-wake] flip history dies too
    BWKnown = NO;
    BWActSessionVerified = NO; // WO fix-w W2-A: session closed
    BWGen = 0;
    BWKbLocalSet(BWKbUnknown);
    // WO ytz4 K2: the owner's kb sync dies with the session too —
    // a snapshot from a closed assignment must never govern the next.
    BWKbOwnerKnown  = NO;
    BWKbOwnerActive = NO;
    BWKbOwnerRxAt   = 0;
    // [ytz5-k5] the kbstate identity dies with the session too: the
    // report latch resets so the next session's first heartbeat
    // posts its true state under the new (hash, gen). The session
    // id and the seq are NOT reset — the session is minted once per
    // load and the seq is monotone per source for the load's life.
    BWKbHaveReported = NO;
    BWKbReportedActive = NO;
    BWKbReporterLive = NO; // [hl2-l8] identity teardown: reporter dies at once
    BWKbSilenceQueries = 0;     // [hl4-D2] real teardown also
    BWKbVerifyLastQueryAt = 0;  //   closes any verification episode
    BWWakeMode = BWModeDryRun;
    BWPinchMode = BWModeDryRun;
    BWPinchAllowed = NO;
    // [hl2-g6] the seq=45 instruments die with the session too: the
    // next hosted session's probe lines start from a clean snapshot
    // provenance (seq 0 / no flips observed).
    BWStateSeq = 0;
    BWStateFlipCount = 0;
    // [hl2-w6] the in-app pinch recognizer leaves with the assignment.
    ABPinchDetach();
}

// ===========================================================================
// YT-ZOOM — orientation virtualization for hosted YouTube
// (design-ytzoom.md §5/§6). NEW machinery beside BridgeWake; no
// original function is rewritten — two existing hooks gain a
// lease-first branch, three reporting hooks gain a mute branch, and
// four answer surfaces are added. Principle (§0): while a host-issued
// lease (ABYTLease.h) is valid, landscape never exists for this app —
// every orientation query answers Portrait, every rotate command is
// rewritten to Portrait, and the player's mask-24 declaration is
// consumed in place instead of being published to appbridge.apporient.
// The ONLY life condition is a fresh lease: the app never reads prefs
// or plists (QA179 lesson). Lease gone/stale/revoked => every hook
// falls back to its original IMP at the very next call — no answer is
// ever latched (§5.6). The whole machine exists ONLY in the YouTube
// process: the lease observer is registered under that bundle check
// and the four new hooks are installed under it (§5.1).
// ===========================================================================

// ---- accepted lease (latest, §4.6) ----
static BOOL     YZHaveLease      = NO;
static BOOL     YZLeaseActiveFlag = NO;
static NSString *YZLeaseOwner    = nil;
static uint32_t YZLeaseGen       = 0;
static NSTimeInterval YZLeaseIssuedAt = 0; // wall-clock epoch seconds
static double   YZLeaseW = 0, YZLeaseH = 0;
static BOOL     YZLeaseIsSplit   = NO;
static NSString *YZLeaseSceneID  = nil;

// ---- virtualization state ----
static BOOL     YZInVirt         = NO; // an active lease was accepted
static BOOL     YZHosted         = NO; // ABOrientationBlock ran: hosted
static BOOL     YZHooksInstalled = NO;
static NSUInteger YZSurfaceCount = 0;  // answer surfaces live (BAT log)
static __weak UIWindowScene *YZSceneCache = nil;
static NSString *YZSceneTier     = nil; // @"id" | @"single" | @"key" | @"none"
static NSMapTable *YZSnapshots   = nil; // window(weak) -> {frame, bounds}
static NSTimer  *YZWatchdog      = nil;
static NSTimeInterval YZLastRequestAt = 0;
static NSTimeInterval YZLastConsumeLogAt = 0;

// Original IMP slots of the four new answer hooks (§5.2).
static IMP orig_VC_supported, orig_VC_supportedPriv;
static IMP orig_Scene_interfaceOrient, orig_UIWindow_rotate;

// The lease clock is the WALL clock: issuedAt is epoch seconds and
// both processes share the device clock (§4.2) — deliberately NOT
// BWNow()'s uptime.
static NSTimeInterval YZWallNow(void) {
    return [[NSDate date] timeIntervalSince1970];
}

static BOOL YZIsYouTube(void) {
    return [[[NSBundle mainBundle] bundleIdentifier]
        isEqualToString:ABYTLeaseYouTubeBundle];
}

static BOOL YZLeaseFreshNow(void) {
    if (!YZHaveLease || !YZLeaseActiveFlag) return NO;
    return (YZWallNow() - YZLeaseIssuedAt) <= ABYTLeaseTTL;
}

// The one predicate every answer hook consults AT CALL TIME (§5.6):
// virtualization answers only while the lease is fresh; the moment it
// ages past the TTL the original answers return, watchdog or not.
static BOOL YZActive(void) {
    return YZInVirt && YZLeaseFreshNow();
}

// Consumed-declaration log (§8.2), throttled like the host-side gate.
static void YZNoteConsumed(void) {
    NSTimeInterval now = BWNow();
    if (now - YZLastConsumeLogAt < 5.0) return;
    YZLastConsumeLogAt = now;
    OMCLogWrite(@"AppBridge", @"[ytz] tieu thu tuyen bo (lease song)");
}

// Ack/request postings (§4.5): the ONLY things the app side may say
// on the lease channels — they carry no orientation data.
static void YZPostAck(NSString *phase, NSInteger windows,
                      double w, double h, NSInteger mismatch) {
    NSString *bundle = [NSBundle mainBundle].bundleIdentifier;
    NSDictionary *info = @{
        ABYTLeaseAckKeyIdentifier: bundle ?: @"",
        ABYTLeaseAckKeyPhase:      phase,
        ABYTLeaseAckKeyGeneration: @(YZLeaseGen),
        ABYTLeaseAckKeyWindows:    @(windows),
        ABYTLeaseAckKeyWidth:      @(w),
        ABYTLeaseAckKeyHeight:     @(h),
        ABYTLeaseAckKeyMismatch:   @(mismatch),
    };
    [[NSDistributedNotificationCenter defaultCenter]
        postNotificationName:ABYTLeaseAckChannel object:bundle userInfo:info];
}

// ---- leased-scene selection (§5.4 step 1): three tiers, the matched
// tier is kept in YZSceneTier for the BAT log. Whether an FBScene
// identifier is readable from inside the app at all is [SUY — do xe];
// tiers (b)/(c) are the designed fallbacks, not afterthoughts. ----
static NSString *YZSceneCandidateID(UIWindowScene *scene) {
    @try {
        id fb = [scene valueForKey:@"_scene"];
        SEL idSel = NSSelectorFromString(@"identifier");
        if (fb && [fb respondsToSelector:idSel]) {
            id v = ((id (*)(id, SEL))objc_msgSend)(fb, idSel);
            if ([v isKindOfClass:NSString.class]) return v;
        }
    } @catch (NSException *e) { (void)e; }
    @try {
        NSString *p = scene.session.persistentIdentifier;
        if ([p isKindOfClass:NSString.class]) return p;
    } @catch (NSException *e) { (void)e; }
    return nil;
}

static UIWindowScene *YZSelectScene(NSString **tierOut) {
    NSMutableArray *scenes = [NSMutableArray array];
    for (UIScene *s in [UIApplication sharedApplication].connectedScenes)
        if ([s isKindOfClass:UIWindowScene.class]) [scenes addObject:s];
    // (a) lease sceneID against each scene's FBScene-side identifier.
    if (YZLeaseSceneID.length > 0) {
        for (UIWindowScene *s in scenes) {
            NSString *cand = YZSceneCandidateID(s);
            if (cand && [cand isEqualToString:YZLeaseSceneID]) {
                *tierOut = @"id";
                return s;
            }
        }
    }
    // (b) exactly one windowed scene.
    NSMutableArray *windowed = [NSMutableArray array];
    for (UIWindowScene *s in scenes)
        if (s.windows.count > 0) [windowed addObject:s];
    if (windowed.count == 1) {
        *tierOut = @"single";
        return windowed.firstObject;
    }
    // (c) the key window's scene.
    UIWindow *kw = ABKeyWindow();
    if (kw.windowScene) {
        *tierOut = @"key";
        return kw.windowScene;
    }
    *tierOut = @"none";
    return nil;
}

static UIWindowScene *YZLeasedScene(void) {
    if (YZSceneCache) {
        BOOL still = NO;
        for (UIScene *s in [UIApplication sharedApplication].connectedScenes)
            if (s == (UIScene *)YZSceneCache) { still = YES; break; }
        if (still) return YZSceneCache;
        YZSceneCache = nil;
    }
    NSString *tier = nil;
    UIWindowScene *s = YZSelectScene(&tier);
    YZSceneCache = s;
    YZSceneTier = tier;
    return s;
}

// ---- window selection (§5.4 step 2): normal level, has a root VC,
// and not a keyboard / text-effects window (class-name filter). ----
static NSArray *YZTargetWindows(UIWindowScene *scene) {
    NSMutableArray *out = [NSMutableArray array];
    for (UIWindow *w in scene.windows) {
        if (w.windowLevel != UIWindowLevelNormal) continue;
        if (!w.rootViewController) continue;
        NSString *cn = NSStringFromClass([w class]);
        if ([cn containsString:@"Keyboard"] ||
            [cn containsString:@"TextEffects"]) continue;
        [out addObject:w];
    }
    return out;
}

// ---- per-window snapshots (§5.4 step 3): taken the FIRST time a
// window is seen in the current lease session, never overwritten
// within it; restored whole on revoke/close, dropped on expiry. ----
static NSMapTable *YZSnapshotTable(void) {
    if (!YZSnapshots)
        YZSnapshots = [NSMapTable weakToStrongObjectsMapTable];
    return YZSnapshots;
}

static void YZSnapshotWindow(UIWindow *w) {
    NSMapTable *t = YZSnapshotTable();
    if ([t objectForKey:w]) return;
    [t setObject:@{ @"frame":  [NSValue valueWithCGRect:w.frame],
                    @"bounds": [NSValue valueWithCGRect:w.bounds] }
          forKey:w];
}

static void YZRestoreSnapshots(void) {
    NSMapTable *t = YZSnapshotTable();
    for (UIWindow *w in [t keyEnumerator]) {
        NSDictionary *snap = [t objectForKey:w];
        if (!snap) continue;
        w.frame  = [snap[@"frame"] CGRectValue];
        w.bounds = [snap[@"bounds"] CGRectValue];
    }
}

// ---- leaving virtualization (§5.3): revoke/close restore the
// snapshot; expiry/owner-change deliberately do NOT (the host's
// geometry may have moved on — snapping windows back to a stale
// snapshot is worse, the QA175 discipline). ----
static void YZExitVirtualization(NSString *reason, BOOL restore) {
    if (YZInVirt) {
        if (restore) YZRestoreSnapshots();
        YZInVirt = NO;
        OMCLogWrite(@"AppBridge", [NSString stringWithFormat:
            @"[ytz] ao hoa TAT ly do=%@", reason]);
        if ([reason isEqualToString:@"revoke"])
            YZPostAck(ABYTLeasePhaseRevoked, 0, 0, 0, 0);
        else if ([reason isEqualToString:@"expiry"])
            YZPostAck(ABYTLeasePhaseExpired, 0, 0, 0, 0);
    }
    [YZSnapshotTable() removeAllObjects];
    YZSceneCache = nil;
    YZSceneTier = nil;
}

// ---- the 0.12 s re-read (§5.5, split only): if the leased scene's
// TRUE orientation (read through the original IMP, bypassing answer
// hook #3) still is not Portrait after a relay apply, wake UIKit once
// so it re-reads the Portrait answers, and ask the scene for Portrait
// geometry through the ORIGINAL requestGeometry IMP — the one place
// the app side initiates the iOS 16 geometry API, asking Portrait. ----
static void YZScheduleReRead(UIWindowScene *scene, NSArray *windows) {
    if (!YZLeaseIsSplit || !orig_Scene_interfaceOrient) return;
    NSInteger cur = ((NSInteger (*)(id, SEL))orig_Scene_interfaceOrient)(
        scene, @selector(interfaceOrientation));
    if (cur == 1) return;
    __weak UIWindowScene *weakScene = scene;
    NSArray *wins = [windows copy];
    dispatch_after(dispatch_time(0, 120000000LL /* 0.12 s */),
                   dispatch_get_main_queue(), ^{
        if (!YZActive()) return;
        UIWindowScene *s = weakScene;
        if (!s) return;
        // Both surfaces used here are iOS 16+ (the module's floor is
        // 15.0); virtualization itself only ever runs on the hosted
        // iOS 16 path, so the guard costs nothing. Existence is probed
        // with the installer's own idiom (OMCHasMethod on this very
        // selector — the same probe ABOrientationBlock uses to decide
        // whether the geometry hook may be installed) instead of the
        // compile-time availability operator: that operator lowers to
        // __isPlatformVersionAtLeast, which this toolchain does not
        // provide to dylibs, so the module cannot link with it present.
        if (OMCHasMethod("UIWindowScene", @"requestGeometryUpdateWithPreferences:errorHandler:")) {
            // The reporting hook behind this call is muted while the
            // lease lives (§6.1) — it publishes nothing; it only makes
            // UIKit re-ask the (Portrait) answer surfaces. Both iOS 16
            // surfaces are reached by dynamic dispatch (objc_msgSend
            // cast, dynamic class lookup, the original IMP) — the
            // idiom the rest of this module uses for them — so this
            // path needs no availability annotation either.
            for (UIWindow *w in wins)
                ((void (*)(id, SEL))objc_msgSend)(w.rootViewController,
                    @selector(setNeedsUpdateOfSupportedInterfaceOrientations));
            if (orig_Scene_reqGeometry) {
                id prefs = [[objc_getClass("UIWindowSceneGeometryPreferencesIOS") alloc] init];
                [prefs setInterfaceOrientations:UIInterfaceOrientationMaskPortrait];
                ((void (*)(id, SEL, id, id))orig_Scene_reqGeometry)(
                    s, @selector(requestGeometryUpdateWithPreferences:errorHandler:),
                    prefs, nil);
            }
            OMCLogWrite(@"AppBridge", @"[ytz] doc lai 0.12s: da phat");
        }
    });
}

// ---- the relay (§5.4 steps 4–5): rotate back to Portrait through
// the ORIGINAL IMP of hook #5 (straight to UIKit, no publish layer),
// then frame = bounds = the lease size, layout, re-measure, ack. ----
static void YZRelayApply(void) {
    UIWindowScene *scene = YZLeasedScene();
    NSArray *windows = scene ? YZTargetWindows(scene) : @[];
    if (!scene || windows.count == 0) {
        // No tier matched: measurement data (§5.4), not silent failure.
        OMCLogWrite(@"AppBridge", @"[ytz] relay ap: windows=0 mismatch=-1");
        YZPostAck(ABYTLeasePhaseApplied, 0, 0, 0, -1);
        return;
    }
    CGRect target = CGRectMake(0, 0, YZLeaseW, YZLeaseH);
    SEL rotateSel = NSSelectorFromString(
        @"_rotateWindowToOrientation:updateStatusBar:duration:skipCallbacks:");
    for (UIWindow *w in windows) {
        YZSnapshotWindow(w);
        if (orig_UIWindow_rotate)
            ((void (*)(id, SEL, NSInteger, BOOL, double, BOOL))orig_UIWindow_rotate)(
                w, rotateSel, 1, NO, 0.0, YES);
        else if ([w respondsToSelector:rotateSel])
            ((void (*)(id, SEL, NSInteger, BOOL, double, BOOL))objc_msgSend)(
                w, rotateSel, 1, NO, 0.0, YES);
        w.frame = target;
        w.bounds = target;
        [w layoutIfNeeded];
    }
    NSInteger mismatch = 0;
    double mw = 0, mh = 0;
    BOOL first = YES;
    for (UIWindow *w in windows) {
        CGSize sz = w.bounds.size;
        if (first) { mw = sz.width; mh = sz.height; first = NO; }
        if (fabs(sz.width - YZLeaseW) > 1.0 ||
            fabs(sz.height - YZLeaseH) > 1.0) mismatch++;
    }
    OMCLogWrite(@"AppBridge", [NSString stringWithFormat:
        @"[ytz] relay ap: windows=%lu mismatch=%ld",
        (unsigned long)windows.count, (long)mismatch]);
    YZPostAck(ABYTLeasePhaseApplied, (NSInteger)windows.count, mw, mh, mismatch);
    YZScheduleReRead(scene, windows);
}

// Entry into virtualization once hooks exist (§5.3): relay, then the
// BAT verdict line with the surface count and the matched tier.
static void YZActivateNow(void) {
    YZRelayApply();
    OMCLogWrite(@"AppBridge", [NSString stringWithFormat:
        @"[ytz] ao hoa BAT hooks=%lu match=%@",
        (unsigned long)YZSurfaceCount, YZSceneTier ?: @"none"]);
}

// ---- lease acceptance (§4.6): malformed payloads are dropped with a
// log and change nothing; a revoke (active = NO) from the CURRENT
// owner takes effect immediately; an owner change is accepted only
// when the current lease has expired or the new lease opens a fresh
// host session (generation == 0, fresh issuedAt), and resets the
// virtualization state WITHOUT restoring before the new lease is
// applied. Heartbeats (same generation) only refresh issuedAt. ----
static void YZLogBad(NSString *why) {
    OMCLogWrite(@"AppBridge", [NSString stringWithFormat:
        @"[ytz] lease hong: %@", why]);
}

static void YZOnLease(NSNotification *note) {
    NSDictionary *info = note.userInfo;
    if (![info isKindOfClass:NSDictionary.class]) {
        YZLogBad(@"payload khong phai dict");
        return;
    }
    id verV = info[ABYTLeaseKeyVersion];
    id ownV = info[ABYTLeaseKeyOwner];
    id issV = info[ABYTLeaseKeyIssuedAt];
    id actV = info[ABYTLeaseKeyActive];
    if (![verV isKindOfClass:NSNumber.class] ||
        [verV integerValue] != ABYTLeaseVersion) { YZLogBad(@"version"); return; }
    if (![ownV isKindOfClass:NSString.class] ||
        [(NSString *)ownV length] == 0)          { YZLogBad(@"owner"); return; }
    if (![issV isKindOfClass:NSNumber.class])    { YZLogBad(@"issuedAt"); return; }
    if (![actV isKindOfClass:NSNumber.class])    { YZLogBad(@"active"); return; }
    NSString *owner = ownV;
    NSTimeInterval issuedAt = [issV doubleValue];
    NSTimeInterval now = YZWallNow();

    if (![actV boolValue]) {
        // Revoke: current owner only, effective immediately.
        if (YZHaveLease && [owner isEqualToString:YZLeaseOwner]) {
            YZExitVirtualization(@"revoke", YES);
            YZHaveLease = NO;
            YZLeaseActiveFlag = NO;
        }
        return;
    }

    id genV = info[ABYTLeaseKeyGeneration];
    id oriV = info[ABYTLeaseKeyOrientation];
    id wV   = info[ABYTLeaseKeyWidth];
    id hV   = info[ABYTLeaseKeyHeight];
    if (![genV isKindOfClass:NSNumber.class])    { YZLogBad(@"generation"); return; }
    if (![oriV isKindOfClass:NSNumber.class] ||
        [oriV integerValue] != 1)                { YZLogBad(@"orientation"); return; }
    if (![wV isKindOfClass:NSNumber.class] ||
        ![hV isKindOfClass:NSNumber.class] ||
        [wV doubleValue] <= 0 || [hV doubleValue] <= 0) {
        YZLogBad(@"size");
        return;
    }
    if (now - issuedAt > ABYTLeaseTTL) return; // stale copy: dropped
    uint32_t gen = (uint32_t)[genV unsignedIntegerValue];

    BOOL sameOwner = YZHaveLease && [owner isEqualToString:YZLeaseOwner];
    if (YZHaveLease && !sameOwner) {
        BOOL currentExpired = !YZLeaseActiveFlag ||
            (now - YZLeaseIssuedAt) > ABYTLeaseTTL;
        if (!currentExpired && gen != 0) return; // foreign owner, ours lives
        YZExitVirtualization(@"owner", NO);      // reset, no restore
        YZHaveLease = NO;
        sameOwner = NO;
    }
    if (sameOwner && issuedAt < YZLeaseIssuedAt) return; // out-of-order copy

    id splitV = info[ABYTLeaseKeyIsSplit];
    BOOL isSplit = [splitV isKindOfClass:NSNumber.class]
        ? [splitV boolValue] : NO;
    id sidV = info[ABYTLeaseKeySceneID];
    NSString *sceneID = [sidV isKindOfClass:NSString.class] ? sidV : nil;
    BOOL contentChanged = !YZHaveLease || gen != YZLeaseGen ||
        [wV doubleValue] != YZLeaseW || [hV doubleValue] != YZLeaseH ||
        isSplit != YZLeaseIsSplit ||
        ![(sceneID ?: @"") isEqualToString:(YZLeaseSceneID ?: @"")];

    YZLeaseOwner = [owner copy];
    YZLeaseGen = gen;
    YZLeaseIssuedAt = issuedAt;
    YZLeaseW = [wV doubleValue];
    YZLeaseH = [hV doubleValue];
    YZLeaseIsSplit = isSplit;
    YZLeaseSceneID = [sceneID copy];
    YZHaveLease = YES;
    YZLeaseActiveFlag = YES;

    if (contentChanged) {
        YZSceneCache = nil; // scene choice may follow the new content
        NSString *shortOwner = owner.length > 8
            ? [owner substringToIndex:8] : owner;
        OMCLogWrite(@"AppBridge", [NSString stringWithFormat:
            @"[ytz] lease nhan gen=%lu owner=%@ size=%.0fx%.0f",
            (unsigned long)gen, shortOwner, YZLeaseW, YZLeaseH]);
    }
    if (!YZInVirt) {
        YZInVirt = YES;
        if (YZHooksInstalled) YZActivateNow();
        // else: the lease waits; YZInstallHooks finishes the
        // activation the moment the hooks land (§5.1).
    } else if (contentChanged && YZHooksInstalled) {
        YZRelayApply();
    }
}

// ---- expiry watchdog (§5.6): 0.5 s tick. Pure housekeeping — the
// answer hooks check the lease age themselves, so correctness never
// depends on this timer. Silent expiry leaves virtualization WITHOUT
// restoring the snapshot, reports `expired`, and — while the app is
// still hosted — keeps asking for a lease (phase `request`, 2 s
// throttle, §4.5), which also covers the never-granted race. ----
static void YZWatchdogTick(void) {
    NSTimeInterval now = YZWallNow();
    if (YZHaveLease && YZLeaseActiveFlag &&
        (now - YZLeaseIssuedAt) > ABYTLeaseTTL) {
        YZExitVirtualization(@"expiry", NO);
        YZHaveLease = NO;
        YZLeaseActiveFlag = NO;
    }
    if (YZHosted && !YZInVirt && (now - YZLastRequestAt) >= 2.0) {
        YZLastRequestAt = now;
        YZPostAck(ABYTLeasePhaseRequest, 0, 0, 0, 0);
    }
}

static void YZStartWatchdog(void) {
    if (YZWatchdog) return;
    YZWatchdog = [NSTimer scheduledTimerWithTimeInterval:0.5 repeats:YES
        block:^(NSTimer *t) { (void)t; YZWatchdogTick(); }];
}

// ---- teardown (§5.1): registered next to BWResetAll for close /
// close-all in ABInstallInAppObservers. Leaving via close restores
// the snapshot (it is a revoke-shaped exit) and drops the lease. ----
static void YZResetAll(void) {
    if (YZInVirt) YZExitVirtualization(@"close", YES);
    else {
        [YZSnapshotTable() removeAllObjects];
        YZSceneCache = nil;
        YZSceneTier = nil;
    }
    YZHaveLease = NO;
    YZLeaseActiveFlag = NO;
    YZLeaseOwner = nil;
    YZLeaseSceneID = nil;
    YZLeaseGen = 0;
    YZLeaseIssuedAt = 0;
    YZHosted = NO;
}

// ---- install (§5.1): called from ABOrientationBlock right after
// BWInstallBridgeWake(), in the same one-shot block — so the new
// hooks exist only in a hosted session, and (bundle self-check) only
// in the YouTube process. Surfaces #4/#6 are the pre-existing hooks
// ABHook_UIDeviceOrientation / ABHook_UIWindowSetRotatable, whose
// bodies consult YZActive() first; they are counted here because
// virtualization re-purposes them (§5.2). ----
static void YZInstallHooks(void) {
    if (YZHooksInstalled) return;
    if (!YZIsYouTube()) return;
    YZHooksInstalled = YES;
    YZHosted = YES;
    NSUInteger surfaces = 2; // #4 + #6, already hooked above
    Class vcCls = objc_getClass("UIViewController");
    // #1 — public, always present: installed unconditionally (§5.2).
    MSHookMessageEx(vcCls, @selector(supportedInterfaceOrientations),
                    (IMP)ABHook_VCSupportedOrientations, &orig_VC_supported);
    surfaces++;
    // #2 — private twin of #1: existence-guarded; absent => skip + log.
    SEL privSel = NSSelectorFromString(@"__supportedInterfaceOrientations");
    if (class_getInstanceMethod(vcCls, privSel)) {
        MSHookMessageEx(vcCls, privSel,
                        (IMP)ABHook_VCSupportedOrientationsPrivate,
                        &orig_VC_supportedPriv);
        surfaces++;
    } else {
        OMCLogWrite(@"AppBridge",
            @"[ytz] khong co __supportedInterfaceOrientations: bo qua");
    }
    // #3 — public since iOS 13, certain on 16.7.16 (§5.2).
    MSHookMessageEx(objc_getClass("UIWindowScene"),
                    @selector(interfaceOrientation),
                    (IMP)ABHook_SceneInterfaceOrientation,
                    &orig_Scene_interfaceOrient);
    surfaces++;
    // #5 — private rotate command: existence-guarded.
    SEL rotSel = NSSelectorFromString(
        @"_rotateWindowToOrientation:updateStatusBar:duration:skipCallbacks:");
    if (class_getInstanceMethod(objc_getClass("UIWindow"), rotSel)) {
        MSHookMessageEx(objc_getClass("UIWindow"), rotSel,
                        (IMP)ABHook_UIWindowRotateWindow, &orig_UIWindow_rotate);
        surfaces++;
    }
    YZSurfaceCount = surfaces;
    YZStartWatchdog();
    // A lease may already be waiting (§5.1): finish its activation
    // now — or, if it aged out while waiting, leave by the expiry
    // path (no restore: nothing was ever applied).
    if (YZInVirt) {
        if (YZLeaseFreshNow()) YZActivateNow();
        else {
            YZExitVirtualization(@"expiry", NO);
            YZHaveLease = NO;
            YZLeaseActiveFlag = NO;
        }
    }
    OMCLogWrite(@"AppBridge", [NSString stringWithFormat:
        @"[ytz] cai may ao hoa (%@)",
        [NSBundle mainBundle].bundleIdentifier]);
}

// ---- the four new answer hooks (§5.2). Every one consults
// YZActive() first; outside a live lease the original IMP runs with
// the original arguments, untouched. ----
// #1 -[UIViewController supportedInterfaceOrientations]
static NSUInteger ABHook_VCSupportedOrientations(UIViewController *self, SEL _cmd) {
    if (YZActive()) return UIInterfaceOrientationMaskPortrait; // 2
    return ((NSUInteger (*)(id, SEL))orig_VC_supported)(self, _cmd);
}
// #2 -[UIViewController __supportedInterfaceOrientations] (private)
static NSUInteger ABHook_VCSupportedOrientationsPrivate(UIViewController *self, SEL _cmd) {
    if (YZActive()) return UIInterfaceOrientationMaskPortrait;
    return ((NSUInteger (*)(id, SEL))orig_VC_supportedPriv)(self, _cmd);
}
// #3 -[UIWindowScene interfaceOrientation]: Portrait only for the
// leased scene; any other scene (e.g. the same app's iPhone scene)
// keeps the original answer.
static NSInteger ABHook_SceneInterfaceOrientation(UIWindowScene *self, SEL _cmd) {
    if (YZActive() && self == YZLeasedScene())
        return 1; // UIInterfaceOrientationPortrait
    return ((NSInteger (*)(id, SEL))orig_Scene_interfaceOrient)(self, _cmd);
}
// #5 -[UIWindow _rotateWindowToOrientation:updateStatusBar:duration:
// skipCallbacks:]: the orientation argument is rewritten to Portrait;
// the other three arguments pass through unchanged.
static void ABHook_UIWindowRotateWindow(UIWindow *self, SEL _cmd,
                                        NSInteger orientation,
                                        BOOL updateStatusBar,
                                        double duration, BOOL skipCallbacks) {
    if (YZActive()) orientation = 1;
    ((void (*)(id, SEL, NSInteger, BOOL, double, BOOL))orig_UIWindow_rotate)(
        self, _cmd, orientation, updateStatusBar, duration, skipCallbacks);
}
// The one-time hook installation and the per-notification work are in the
// SAME function in the original.
// ===========================================================================
static void ABOrientationBlock(NSNotification *note) {
    if (!ABHooksInstalled) {
        ABHooksInstalled = YES;
        // CADisplayLink hooks: the class method is hooked on the
        // METACLASS; the two FPS setters are instance methods and are
        // hooked on the class itself. (Original sub_4728 keeps the
        // objc_getClass result in x21, applies object_getClass ONLY
        // for +displayLinkWithTarget:selector:, and passes x21
        // directly for both setters — installer_app_4728.txt
        // @0x4780-0x47ec.) [hotfix: setters were on the metaclass, so
        // the hooks never landed and their orig slots stayed NULL
        // while ABApplyFPSLimit calls them.]
        MSHookMessageEx(object_getClass(objc_getClass("CADisplayLink")),
                        @selector(displayLinkWithTarget:selector:),
                        (IMP)ABHook_CADisplayLinkNew, &orig_CADisplayLink_new);
        MSHookMessageEx(objc_getClass("CADisplayLink"),
                        @selector(setPreferredFramesPerSecond:),
                        (IMP)ABHook_CADisplayLinkSetFPS, &orig_CADisplayLink_setFPS);
        MSHookMessageEx(objc_getClass("CADisplayLink"),
                        @selector(setPreferredFrameRateRange:),
                        (IMP)ABHook_CADisplayLinkSetRange, &orig_CADisplayLink_setRange);
        MSHookMessageEx(objc_getClass("UIWindow"),
                        NSSelectorFromString(@"_setRotatableViewOrientation:duration:force:"),
                        (IMP)ABHook_UIWindowSetRotatable, &orig_UIWindow_setRotatable);
        MSHookMessageEx(objc_getClass("UIDevice"),
                        @selector(beginGeneratingDeviceOrientationNotifications),
                        (IMP)ABHook_UIDeviceBeginGen, &orig_UIDevice_beginGen);
        MSHookMessageEx(objc_getClass("UIDevice"),
                        NSSelectorFromString(@"setOrientation:animated:"),
                        (IMP)ABHook_UIDeviceSetOrientation, &orig_UIDevice_setOrientation);
        MSHookMessageEx(objc_getClass("UIDevice"), @selector(orientation),
                        (IMP)ABHook_UIDeviceOrientation, &orig_UIDevice_orientation);
        MSHookMessageEx(objc_getClass("UITextField"), @selector(becomeFirstResponder),
                        (IMP)ABHook_TFBecome, &orig_TF_become);
        MSHookMessageEx(objc_getClass("UITextField"), @selector(resignFirstResponder),
                        (IMP)ABHook_TFResign, &orig_TF_resign);
        MSHookMessageEx(objc_getClass("UITextView"), @selector(becomeFirstResponder),
                        (IMP)ABHook_TVBecome, &orig_TV_become);
        MSHookMessageEx(objc_getClass("UITextView"), @selector(resignFirstResponder),
                        (IMP)ABHook_TVResign, &orig_TV_resign);
        BOOL hasScene = OMCHasMethod("UIWindowScene", @"requestGeometryUpdateWithPreferences:errorHandler:"); // [hotfix] 2nd arg was a C string; the impl treats it as NSString* (original passes the cfstring — installer_app_4728.txt @0x491c-0x492c)
        BOOL hasVCUpdate = class_getInstanceMethod(objc_getClass("UIViewController"), @selector(setNeedsUpdateOfSupportedInterfaceOrientations)) != NULL;
        BOOL hasAttempt = class_getClassMethod(objc_getClass("UIViewController"), @selector(attemptRotationToDeviceOrientation)) != NULL;
        if (hasScene) {
            MSHookMessageEx(objc_getClass("UIWindowScene"),
                            @selector(requestGeometryUpdateWithPreferences:errorHandler:),
                            (IMP)ABHook_SceneRequestGeometry, &orig_Scene_reqGeometry);
        }
        if (hasVCUpdate) {
            MSHookMessageEx(objc_getClass("UIViewController"),
                            @selector(setNeedsUpdateOfSupportedInterfaceOrientations),
                            (IMP)ABHook_VCSetNeedsUpdate, &orig_VC_setNeedsUpdate);
        }
        if (!hasVCUpdate && hasAttempt) {
            // Pre-iOS-16 fallback: hook the class method on the metaclass.
            MSHookMessageEx(object_getClass(objc_getClass("UIViewController")),
                            @selector(attemptRotationToDeviceOrientation),
                            (IMP)ABHook_VCAttemptRotation, &orig_VC_attemptRotation);
        }
        // BridgeWake (design §5.1): sendEvent: hook + state client +
        // keyboard observers + first query, installed in the same
        // one-shot block so they exist only in a hosted session.
        BWInstallBridgeWake();
        // YT-ZOOM (design-ytzoom §5.1): the virtualization machine
        // installs in the same one-shot block, right after BridgeWake;
        // it self-gates on the YouTube bundle, so no YZ hook exists in
        // any other app's process.
        YZInstallHooks();
        OMCLogWrite(@"AppBridge", [NSString stringWithFormat:@"%@: dua len xe, cai hook",
                                   [NSBundle mainBundle].bundleIdentifier]);
    }

    NSDictionary *info = note.userInfo;
    // [ytz5-k5] this handler IS the frame-info relay endpoint: the
    // host stamps the gate into the same payload (drawnKeyboard) —
    // cache it before anything below acts, so a release-resign in
    // the else branch and every later responder event this session
    // see the gate the host currently holds.
    ABDrawnKbNoteFrameInfo(info);
    NSInteger orientation = [info[@"orientation"] intValue];
    // [hl23-kbphysical] Transport values are independent of UIScreen's
    // phone size; reject absent, stale or impossible host geometry.
    CGFloat physicalW = [info[@"kbPhysicalW"] doubleValue];
    CGFloat logicalW = [info[@"kbLogicalW"] doubleValue];
    if (orientation > 0 && isfinite(physicalW) && isfinite(logicalW) &&
        physicalW >= 100 && logicalW >= physicalW &&
        logicalW <= physicalW * 2.1) {
        ABNativeKbPhysicalWidth = physicalW;
        ABNativeKbLogicalWidth = logicalW;
    } else {
        ABNativeKbPhysicalWidth = 0;
        ABNativeKbLogicalWidth = 0;
    }
    OMCLogWrite(@"AppBridge", [NSString stringWithFormat:
        @"[hl23-kbphysical] recv physicalW=%.1f logicalW=%.1f hosted=%d",
        ABNativeKbPhysicalWidth, ABNativeKbLogicalWidth, (int)(orientation > 0)]);
    NSInteger old = ABForcedOrientation;
    if (orientation > 0) {
        ABForcedOrientation = orientation;
        ABAppOrientation = 0;
        ABDeviceFake = [info[@"device"] intValue];
    } else {
        // Host released the app: restore keyboard geometry before
        // resigning, and invalidate any delayed native-fit attempts.
        ++ABNativeKbEpoch;
        ABNativeKbRestore(@"host-release");
        if (ABCurrentResponder) [ABCurrentResponder resignFirstResponder];
        ABForcedOrientation = orientation;
        ABAppOrientation = 0;
        ABDeviceFake = 0;
    }
    OMCLogWrite(@"AppBridge", [NSString stringWithFormat:@"huong o %d, thiet bi gia %d (doi=%d)",
                               (int)orientation, (int)ABDeviceFake, orientation != old]);

    if (orientation != old) {
        if (ABDeviceFake >= 1) {
            // Constant array at 0x393F0: @[@0.3, @1.5, @4.0] (verbatim).
            for (NSNumber *delay in @[@0.3, @1.5, @4.0]) ABAfterDelay(delay.doubleValue);
        }
        // Decide the orientation the app should believe in, and force the
        // rotatable view if the supported mask admits it.
        NSInteger target = ABForcedOrientation;
        if (target == -1) {
            NSInteger o = [UIDevice currentDevice].orientation; // (hooked getter)
            target = o > 1 ? o : 1;
        }
        NSUInteger mask = ABSupportedOrientationMask();
        if (target >= 1 && (mask & (1u << target)) == 0) {
            OMCLogWrite(@"AppBridge", [NSString stringWithFormat:@"bo qua ep xoay %d: app chi cho mask %lu",
                                       (int)target, (unsigned long)mask]);
        } else {
            id view = ABKeyWindow(); // sub_61D0 result (window; the original
                                     // passes it through an intermediate that
                                     // yields the rotatable target — see report)
            SEL sel = NSSelectorFromString(@"_setRotatableViewOrientation:duration:force:");
            if (view && [view respondsToSelector:sel]) {
                // objc_msgSend(view, sel, target, 0.0, YES)
                ((void (*)(id, SEL, NSInteger, double, BOOL))objc_msgSend)(view, sel, target, 0.0, YES);
            }
        }
    }

    // FPS limit carried by the same notification.
    NSInteger orient2 = [note.userInfo[@"orientation"] intValue];
    NSInteger fps = orient2 >= 1 ? [note.userInfo[@"fps"] intValue] : 0;
    if (fps != ABFPSLimit) {
        ABFPSLimit = fps;
        for (id link in [ABDisplayLinks() allObjects]) ABApplyFPSLimit(link);
        OMCLogWrite(@"AppBridge", [NSString stringWithFormat:@"gioi han khung hinh: %d", (int)fps]);
    }
    // [hl11kb] Refit an ALREADY-OBSERVED native keyboard window when
    // the host posts its updated frame/orientation after divider drag.
    // Do not create a keyboard merely because layout changed.
    if (orientation >= 1 && !ABDrawnKb && ABNativeKbHasOriginal &&
        ABCurrentResponder && [ABCurrentResponder isFirstResponder]) {
        NSUInteger epoch = ++ABNativeKbEpoch;
        ABNativeKbFit(@"host-frame", 0);
        // The host scene and UIKit keyboard settle asynchronously.
        const NSTimeInterval delays[] = {0.12, 0.35};
        for (NSUInteger i = 0; i < 2; ++i) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW,
                (int64_t)(delays[i] * NSEC_PER_SEC)),
                dispatch_get_main_queue(), ^{
                    if (epoch != ABNativeKbEpoch || ABForcedOrientation < 1 ||
                        !ABCurrentResponder ||
                        ![ABCurrentResponder isFirstResponder]) return;
                    ABNativeKbFit(@"host-frame-settled", (NSInteger)i + 1);
                });
        }
    }
}

// ===========================================================================
// Key receiver block — sub_5908. Registered by the ctor for ABChanKey.
// Applies one car-keyboard action to the tracked first responder.
// ===========================================================================
static void ABKeyBlock(NSNotification *note) {
    @try {
        NSDictionary *info = note.userInfo;
        id responder = ABCurrentResponder;
        if (!responder || ![responder isFirstResponder]) return;
        if (![responder conformsToProtocol:@protocol(UITextInput)]) return;
        NSString *action = info[@"action"];
        if ([action isEqualToString:@"type"]) {
            NSInteger del = [info[@"del"] intValue];
            for (NSInteger i = 0; i < del; i++) [responder deleteBackward];
            NSString *text = info[@"text"];
            if ([text isKindOfClass:NSString.class] && text.length > 0)
                [responder insertText:text];
        } else if ([action isEqualToString:@"return"]) {
            if ([responder isKindOfClass:UITextField.class]) {
                id<UITextFieldDelegate> delegate = [(UITextField *)responder delegate];
                BOOL proceed = YES;
                if ([delegate respondsToSelector:@selector(textFieldShouldReturn:)])
                    proceed = [delegate textFieldShouldReturn:(UITextField *)responder];
                if (proceed)
                    [(UIControl *)responder sendActionsForControlEvents:UIControlEventEditingDidEndOnExit]; // 0x80000
            } else {
                [responder insertText:@"\n"];
            }
        } else if ([action isEqualToString:@"dismiss"]) {
            [responder resignFirstResponder];
        }
    } @catch (NSException *e) {
        OMCLogWrite(@"AppBridge", [NSString stringWithFormat:@"%@: phim loi %@",
                                   [NSBundle mainBundle].bundleIdentifier, e]);
    }
}

void ABInstallInAppObservers(NSString *bundleID) {
    NSDistributedNotificationCenter *center = [NSDistributedNotificationCenter defaultCenter];
    NSOperationQueue *queue = [NSOperationQueue mainQueue];
    [center addObserverForName:ABChanOrientation object:bundleID queue:queue
                    usingBlock:^(NSNotification *n) { ABOrientationBlock(n); }];
    [center addObserverForName:ABChanKey object:bundleID queue:queue
                    usingBlock:^(NSNotification *n) { ABKeyBlock(n); }];
    // YT-ZOOM (design-ytzoom §5.1): the lease observer exists ONLY in
    // the YouTube process. A lease may arrive before the first
    // orientation packet; it is only stored until the hooks land.
    BOOL isYouTube = [bundleID isEqualToString:ABYTLeaseYouTubeBundle];
    if (isYouTube) {
        [center addObserverForName:ABYTLeaseChannel object:bundleID queue:queue
                        usingBlock:^(NSNotification *n) { YZOnLease(n); }];
    }
    // BridgeWake teardown (§5.6): a close of this app (or a close-all)
    // resets the wake client to pristine, fail-open state. YT-ZOOM
    // registers its reset (design-ytzoom §5.1) next to it.
    [center addObserverForName:ABChanClose object:bundleID queue:queue
                    usingBlock:^(NSNotification *n) {
                        (void)n;
                        BWResetAll();
                        if (isYouTube) YZResetAll();
                    }];
    [center addObserverForName:ABChanCloseAll object:nil queue:queue
                    usingBlock:^(NSNotification *n) {
                        (void)n;
                        BWResetAll();
                        if (isYouTube) YZResetAll();
                    }];
}

// ===========================================================================
// Deferred fake-orientation re-post — sub_5FF0 + block sub_6028.
// sub_5FF0 is a generic helper: dispatch_after(dispatch_time(0, seconds*1e9),
// main, <the one global block 0x34630 whose invoke is sub_6028>).
// The block re-posts UIDeviceOrientationDidChangeNotification (object =
// [UIDevice currentDevice]) if a fake device orientation is active and the
// supported mask has bit 1 set; otherwise it logs the skip.
// ===========================================================================
static void ABFakeOrientationEvent(void) {
    if (ABDeviceFake < 1) return;
    NSUInteger mask = ABSupportedOrientationMask();
    if ((mask & 0x2) == 0) {
        OMCLogWrite(@"AppBridge", [NSString stringWithFormat:@"bo qua su kien xoay gia: app dang chi cho mask %lu",
                                   (unsigned long)mask]);
        return;
    }
    [[NSNotificationCenter defaultCenter]
        postNotificationName:UIDeviceOrientationDidChangeNotification
                      object:[UIDevice currentDevice]];
}

static void ABAfterDelay(NSTimeInterval seconds) {
    dispatch_after(dispatch_time(0, (int64_t)(seconds * 1e9)),
                   dispatch_get_main_queue(), ^{ ABFakeOrientationEvent(); });
}

// ===========================================================================
// First-responder hooks (keyboard suppression + channel publish)
// ===========================================================================
// sub_698C — before becomeFirstResponder: while hosted, give the responder a
// blank zero-size inputView so the system keyboard never appears in the app.
// The marker associated object lives at a unique static address used as
// the key (the original materialises its own in-image slot, VA 0x3E9E4,
// PC-relative @0x6a1c–0x6a20, and never dereferences it). [fix-round-3]
// The absolute VA must not be used as the pointer value in the rebuild;
// the self-referential form gives the same semantics (a stable,
// distinct, in-image address, never dereferenced by the runtime).
static const void *ABBlankInputViewKey = &ABBlankInputViewKey;

// [ytz5-k5] marker restore, shared by ABResponderResigned and the
// drawn->native flip (ABDrawnKbNoteFrameInfo): give a responder its
// system keyboard back ONLY if this tweak blanked it — the marker
// is the ownership proof — and clear the marker as part of the
// restore. Unmarked responders are never touched.
static void ABRestoreBlankInputView(id responder) {
    if (!responder) return;
    if (objc_getAssociatedObject(responder, ABBlankInputViewKey)) {
        objc_setAssociatedObject(responder, ABBlankInputViewKey, nil, OBJC_ASSOCIATION_ASSIGN);
        [responder setInputView:nil]; // restore the real input view
    }
}

static void ABSuppressSystemKeyboard(id responder) {
    if (ABForcedOrientation < 1) return;
    // [ytz5-k5] native gate, as locked by HL3 (Nguyen 22:14): the
    // cache is native by default and a drawn payload is ignored,
    // so this suppression never runs in this build; while native
    // the system keyboard is left fully alone — no blank
    // inputView, no marker (contract item 2).
    if (!ABDrawnKeyboardActive()) return;
    if (![responder respondsToSelector:@selector(setInputView:)]) return;
    if ([responder inputView] != nil) return;
    UIView *blank = [[UIView alloc] initWithFrame:CGRectZero];
    [responder setInputView:blank];
    objc_setAssociatedObject(responder, ABBlankInputViewKey, (id)kCFBooleanTrue,
                             OBJC_ASSOCIATION_ASSIGN); // policy 1 in the original
}

// sub_6A70 — after a successful becomeFirstResponder while hosted.
static void ABResponderBecame(id responder) {
    if (ABForcedOrientation < 1) return;
    ABCurrentResponder = responder;
    ABHL8Focus(@"focus-became", responder);
    if (!ABDrawnKb) ABNativeKbBegin(@"focus-became");
    // [hl3] marker eye 2 of 3: a responder became first responder
    // under the gate currently cached (native, hard-locked).
    OMCLogWrite(@"AppBridge", [NSString stringWithFormat:
        @"[ytz5-k5] responder became drawn=%d class=%@",
        ABDrawnKeyboardActive() ? 1 : 0, NSStringFromClass([responder class])]);
    ABKeyboardPublish(YES, responder);
    BWKbLocalSet(BWKbActive); // BridgeWake kb guard: primary evidence
                              // (§5.5) — the local ACTIVE source of the
                              // effective kb (WO ytz4 K2)
    // [ytz5-k5] kbstate report: ACTIVE only now — the hooks call
    // this solely after the original becomeFirstResponder returned
    // success, i.e. focus is confirmed and editing has begun.
    BWKbStateBecame();
}

// sub_6D50 — after a successful resignFirstResponder.
static void ABResponderResigned(id responder) {
    ABHL8Focus(@"focus-resigned", responder);
    ++ABNativeKbEpoch;
    ABNativeKbRestore(@"focus-resigned");
    ABRestoreBlankInputView(responder);
    if (ABCurrentResponder == responder) {
        ABCurrentResponder = nil;
        ABKeyboardPublish(NO, nil);
        BWKbLocalSet(BWKbInactive); // BridgeWake kb guard: only the
                                    // responder session may lower
                                    // ACTIVE (§5.5)
        // [ytz5-k5] kbstate report: the INACTIVE decision is NOT
        // taken here — it is deferred one runloop tick so a focus
        // move to another field of this app does not emit a false
        // INACTIVE (see BWKbStateResignedDeferred). The local
        // BWKbLocalSet law above is unchanged (K2/K5 contract).
        BWKbStateResignedDeferred();
    }
}

static BOOL ABHook_TFBecome(UITextField *self, SEL _cmd) {
    ABSuppressSystemKeyboard(self);
    BOOL ok = ((BOOL (*)(id, SEL))orig_TF_become)(self, _cmd);
    if (ok) ABResponderBecame(self);
    return ok;
}
static BOOL ABHook_TFResign(UITextField *self, SEL _cmd) {
    BOOL ok = ((BOOL (*)(id, SEL))orig_TF_resign)(self, _cmd);
    if (ok) ABResponderResigned(self);
    return ok;
}
static BOOL ABHook_TVBecome(UITextView *self, SEL _cmd) {
    if (self.isEditable) ABSuppressSystemKeyboard(self);
    BOOL ok = ((BOOL (*)(id, SEL))orig_TV_become)(self, _cmd);
    if (ok && self.isEditable) ABResponderBecame(self);
    return ok;
}
static BOOL ABHook_TVResign(UITextView *self, SEL _cmd) {
    BOOL ok = ((BOOL (*)(id, SEL))orig_TV_resign)(self, _cmd);
    if (ok) ABResponderResigned(self);
    return ok;
}

// ===========================================================================
// Keyboard channel publisher — sub_6AD4. PROVEN packed format:
//   state = shown | keyboardType<<1 | returnKeyType<<8 | FNV1a(bundleID)<<24
// ===========================================================================
static void ABKeyboardPublish(BOOL shown, id traits) {
    // [ytz5-k5] native gate (contract item 2), as locked by HL3
    // (Nguyen 22:14): the cached gate is native by default and a
    // drawn payload is ignored, so NO panel request is published
    // in either direction in this build — the Darwin keyboard
    // channel stays silent for this app and the host panel can
    // never be summoned. Gating at the publisher's head covers
    // both call points (Became YES / Resigned NO) at once; the
    // host dispatch double-checks the gate on its side regardless.
    if (!ABDrawnKeyboardActive()) {
        if (ABHL8Trace())
            OMCLogWrite(@"AppBridge", [NSString stringWithFormat:
                @"[hl8diag] eye=kb-app ev=publish-blocked "
                 "bundle=%@ show=%d reason=native-locked focused=%d",
                [NSBundle mainBundle].bundleIdentifier ?: @"unknown",
                (int)shown, (int)(ABCurrentResponder != nil)]);
        return;
    }
    if (ABHL8Trace())
        OMCLogWrite(@"AppBridge", [NSString stringWithFormat:
            @"[hl8diag] eye=kb-app ev=publish-allowed bundle=%@ "
             "show=%d channel=darwin-keyboard",
            [NSBundle mainBundle].bundleIdentifier ?: @"unknown",
            (int)shown]);
    if (!ABKeyboardToken)
        notify_register_check(ABNotifyKeyboard, &ABKeyboardToken);
    uint64_t state = 0;
    if (shown) {
        state = 1;
        if ([traits respondsToSelector:@selector(keyboardType)])
            state |= (uint64_t)([traits keyboardType] & 0x7F) << 1;
        if ([traits respondsToSelector:@selector(returnKeyType)])
            state |= (uint64_t)([traits returnKeyType] & 0xFF) << 8;
    }
    state |= (uint64_t)ABBundleHash([NSBundle mainBundle].bundleIdentifier) << 24;
    notify_set_state(ABKeyboardToken, state);
    notify_post(ABNotifyKeyboard);
    // [hl2-k6] marker eye 3 of 3: the panel publish actually went
    // out on the Darwin keyboard channel (drawn gate active).
    OMCLogWrite(@"AppBridge", [NSString stringWithFormat:
        @"[ytz5-k5] publish shown=%d drawn=1", shown ? 1 : 0]);
    OMCLogWrite(@"AppBridge", [NSString stringWithFormat:@"ban phim xe: %@ (%@)",
                               shown ? @"hien" : @"an",
                               traits ? NSStringFromClass([traits class]) : @"-"]);
}

// ===========================================================================
// Orientation machinery hooks
// ===========================================================================
// -[UIDevice setOrientation:animated:] (sub_5504): while hosted, remember the
// app's own landscape choice (only values 3 and 4 kept, everything else
// zeroed — the original filters via `sub x8,x20,#3; cmp x8,#2; csel x8,x20,
// xzr, lo` at 0x553c-0x5544, i.e. (value-3) <u 2, so 5/FaceUp also becomes 0),
// log it, and schedule a (debounced) report to SpringBoard; always calls the
// original.
static void ABHook_UIDeviceSetOrientation(UIDevice *self, SEL _cmd, NSInteger orientation, BOOL animated) {
    // YT-ZOOM (design-ytzoom §6.1): while a lease lives, the
    // declaration is consumed in place — the original still runs,
    // but nothing is recorded in ABAppOrientation and nothing is
    // published to appbridge.apporient.
    if (YZActive()) {
        ((void (*)(id, SEL, NSInteger, BOOL))orig_UIDevice_setOrientation)(self, _cmd, orientation, animated);
        YZNoteConsumed();
        return;
    }
    if (ABForcedOrientation >= 1) {
        ABAppOrientation = (orientation == 3 || orientation == 4) ? orientation : 0;
        OMCLogWrite(@"AppBridge", [NSString stringWithFormat:@"app setOrientation %lld -> %lld",
                                   (long long)orientation, (long long)ABAppOrientation]);
        ABScheduleAppOrientationPublish(ABAppOrientation);
    }
    ((void (*)(id, SEL, NSInteger, BOOL))orig_UIDevice_setOrientation)(self, _cmd, orientation, animated);
}

// -[UIDevice orientation] (sub_55D8): the app's own choice wins; else the
// host's fake device orientation; else the real one.
static NSInteger ABHook_UIDeviceOrientation(UIDevice *self, SEL _cmd) {
    // YT-ZOOM (design-ytzoom §5.2 #4): while a lease lives, the lease
    // outranks both branches below — the answer is Portrait
    // (UIDeviceOrientationPortrait == 1).
    if (YZActive()) return 1;
    if (ABAppOrientation > 0) return ABAppOrientation;
    if (ABDeviceFake >= 1) return ABDeviceFake;
    return ((NSInteger (*)(id, SEL))orig_UIDevice_orientation)(self, _cmd);
}

// -[UIDevice beginGeneratingDeviceOrientationNotifications] (sub_54C8):
// original, then one fake-orientation re-post at +0.2 s (constant at 0x2B1D8).
static void ABHook_UIDeviceBeginGen(UIDevice *self, SEL _cmd) {
    ((void (*)(id, SEL))orig_UIDevice_beginGen)(self, _cmd);
    if (ABDeviceFake >= 1) ABAfterDelay(0.2);
}

// -[UIWindow _setRotatableViewOrientation:duration:force:] (sub_543C):
// while hosted, substitutes the effective orientation (app's own if set,
// else the host-forced one) for the requested argument. (The original also
// computes the window mask via sub_5EC0; its comparison only gates a branch
// that cannot change the outcome when hosted — see report §4.3.)
static void ABHook_UIWindowSetRotatable(UIWindow *self, SEL _cmd, NSInteger orientation, double duration, BOOL force) {
    // YT-ZOOM (design-ytzoom §5.2 #6): while a lease lives —
    // Portrait with force = YES (the DuoFace-proven value: make the
    // rotatable view settle Portrait even when UIKit believes it
    // already is). Outside a lease the body below is untouched.
    if (YZActive()) {
        ((void (*)(id, SEL, NSInteger, double, BOOL))orig_UIWindow_setRotatable)(self, _cmd, 1, duration, YES);
        return;
    }
    NSInteger effective = ABAppOrientation > 0 ? ABAppOrientation : ABForcedOrientation;
    NSInteger use = effective >= 1 ? effective : orientation;
    ((void (*)(id, SEL, NSInteger, double, BOOL))orig_UIWindow_setRotatable)(self, _cmd, use, duration, force);
}

// -[UIWindowScene requestGeometryUpdateWithPreferences:errorHandler:]
// (sub_5734, iOS 16+): while hosted, derives ABAppOrientation from the
// requested preferences' interfaceOrientations mask and schedules a report.
// Derivation (csel chain, verified against sub_5734): first compute the
// priority value — LandscapeLeft (bit 16 -> 4) over LandscapeRight
// (bit 8 -> 3) over PortraitUpsideDown (bit 4 -> value 2 via (mask>>1)&2);
// then the final csel @0x57c0-0x57c4 (tst w0, #2; csel x9, xzr, x8, ne)
// forces the result to 0 when the portrait bit (2) IS present, and keeps
// the priority value when it is absent.
static NSInteger ABOrientationDerivedFromMask(NSUInteger mask) {
    NSInteger v = (mask & 8) ? 3 : (NSInteger)((mask >> 1) & 2);
    if (mask & 16) v = 4;
    if (mask & 2) v = 0;
    return v;
}

static void ABHook_SceneRequestGeometry(UIWindowScene *self, SEL _cmd, id preferences, id errorHandler) {
    // YT-ZOOM (design-ytzoom §6.1): while a lease lives, the request
    // is consumed in place — the original runs with the app's own
    // preferences, nothing is derived, recorded or published.
    if (YZActive()) {
        ((void (*)(id, SEL, id, id))orig_Scene_reqGeometry)(self, _cmd, preferences, errorHandler);
        YZNoteConsumed();
        return;
    }
    if (ABForcedOrientation >= 1 &&
        [preferences respondsToSelector:@selector(interfaceOrientations)]) {
        NSUInteger mask = [preferences interfaceOrientations];
        ABAppOrientation = ABOrientationDerivedFromMask(mask);
        OMCLogWrite(@"AppBridge", [NSString stringWithFormat:@"app xin huong mask=%lu -> %lld",
                                   (unsigned long)mask, (long long)ABAppOrientation]);
        ABScheduleAppOrientationPublish(ABAppOrientation);
    }
    ((void (*)(id, SEL, id, id))orig_Scene_reqGeometry)(self, _cmd, preferences, errorHandler);
}

// -[UIViewController setNeedsUpdateOfSupportedInterfaceOrientations]
// (sub_5888) and +[UIViewController attemptRotationToDeviceOrientation]
// (sub_58C0, fallback): original, then schedule a report with the sentinel
// field 0xFF ("recompute from mask" — consumed by ABHost, see report).
static void ABHook_VCSetNeedsUpdate(UIViewController *self, SEL _cmd) {
    ((void (*)(id, SEL))orig_VC_setNeedsUpdate)(self, _cmd);
    // YT-ZOOM (design-ytzoom §6.1): while a lease lives, the
    // declaration is consumed in place — no publish is scheduled.
    if (YZActive()) { YZNoteConsumed(); return; }
    if (ABForcedOrientation >= 1) ABScheduleAppOrientationPublish(0xFF);
}
static void ABHook_VCAttemptRotation(id self, SEL _cmd) {
    ((void (*)(id, SEL))orig_VC_attemptRotation)(self, _cmd);
    if (ABForcedOrientation >= 1) ABScheduleAppOrientationPublish(0xFF);
}

// ===========================================================================
// App-orientation publisher — sub_67FC + debounce sub_6750 (0.25 s).
// PROVEN packed format:
//   state = (orientationField & 0xFF) | (mask & 0xFFFF) << 8 | FNV1a << 24
// The 0xFF sentinel passes through as the low byte; ABHost resolves it.
// ===========================================================================
static void ABPublishAppOrientation(int64_t orientationField) {
    ABPendingPublishBlock = nil; // the original releases the stored block here
    if (!ABAppOrientToken)
        notify_register_check(ABNotifyAppOrient, &ABAppOrientToken);
    NSUInteger mask = ABSupportedOrientationMask();
    uint64_t state = ((uint64_t)orientationField & 0xFF)
                   | ((uint64_t)(mask & 0xFFFF) << 8)
                   | ((uint64_t)ABBundleHash([NSBundle mainBundle].bundleIdentifier) << 24);
    notify_set_state(ABAppOrientToken, state);
    notify_post(ABNotifyAppOrient);
    OMCLogWrite(@"AppBridge", [NSString stringWithFormat:@"bao SpringBoard: ma %lld, mask %lu",
                               (long long)orientationField, (unsigned long)mask]);
}

static void ABScheduleAppOrientationPublish(int64_t field) {
    if (ABPendingPublishBlock) dispatch_block_cancel((dispatch_block_t)ABPendingPublishBlock);
    dispatch_block_t block = dispatch_block_create(0, ^{ ABPublishAppOrientation(field); });
    ABPendingPublishBlock = block;
    dispatch_after(dispatch_time(0, 250000000 /* 0.25 s, immediate constant in sub_6750 */),
                   dispatch_get_main_queue(), block);
}

// ===========================================================================
// Supported-mask computation — sub_612C / sub_6498 / sub_5EC0 / sub_61D0
// ===========================================================================
// sub_6498: recursive search (depth cap 12) for a visible view controller
// whose supported mask contains a landscape bit (8 or 16) and does NOT
// contain the portrait bit (2); presented controllers are tried before
// children (skipped when nil or being dismissed). Returns that mask, or 0.
// (Full body line-read in remediation round 2 — 696/696 B, 174 insns,
// disasm/rem4_tail_6498.txt: the return rule is `(m & 0x18) != 0 &&
// (m & 0x2) == 0` at 0x6558/0x6560, and the presented recursion is gated
// on `!presentedViewController.isBeingDismissed`. An earlier draft had
// the portrait condition inverted and the presented step ungated; both
// corrected.)
static NSUInteger ABMaskFromViewController(UIViewController *vc, NSInteger depth) {
    if (!vc || depth > 12) return 0;
    if (vc.isViewLoaded && vc.view.window && !vc.view.isHidden) {
        NSUInteger m = vc.supportedInterfaceOrientations;
        if ((m & 0x18) != 0 && (m & 0x2) == 0) return m;
    }
    UIViewController *presented = vc.presentedViewController;
    if (presented && !presented.isBeingDismissed) {
        NSUInteger m = ABMaskFromViewController(presented, depth + 1);
        if (m) return m;
    }
    for (UIViewController *child in vc.childViewControllers) {
        NSUInteger m = ABMaskFromViewController(child, depth + 1);
        if (m) return m;
    }
    return 0;
}

// sub_5EC0: mask of a window's root/presented chain (used by the rotatable
// hook and as layoutPane-independent fallback).
static NSUInteger ABMaskFromWindow(UIWindow *window) {
    UIViewController *vc = window.rootViewController;
    while (vc.presentedViewController && !vc.presentedViewController.isBeingDismissed)
        vc = vc.presentedViewController;
    return vc ? vc.supportedInterfaceOrientations : 0;
}

// sub_61D0: first key, non-hidden window across connected scenes.
static UIWindow *ABKeyWindow(void) {
    for (UIScene *scene in [UIApplication sharedApplication].connectedScenes) {
        if (![scene isKindOfClass:UIWindowScene.class]) continue;
        for (UIWindow *w in ((UIWindowScene *)scene).windows)
            if (w.isKeyWindow && !w.isHidden) return w;
    }
    return nil;
}

// sub_612C: mask entry point — 0x1E (all four orientations) when there is
// no window at all.
static NSUInteger ABSupportedOrientationMask(void) {
    UIWindow *window = ABKeyWindow();
    if (!window) return 0x1E;
    NSUInteger m = ABMaskFromViewController(window.rootViewController, 0);
    if (m == 0) m = ABMaskFromWindow(window);
    return m;
}

// ===========================================================================
// FPS limiting — sub_5C64 (weak set of links), sub_5CBC (apply), hooks
// sub_50A8 / sub_5144 / sub_5220. While ABFPSLimit > 0 every CADisplayLink
// the app creates or reconfigures is re-clamped by calling the ORIGINAL
// setters directly (no recursion). The requested range's components are
// read back as floats and clamped to the limit; when the app only used the
// integer setter, the clamped integer is re-applied.
// (Field-level detail is in disasm/apply_fps_5cbc.txt.)
// ===========================================================================
static NSHashTable *ABDisplayLinks(void) {
    static NSHashTable *table;
    static dispatch_once_t once;
    dispatch_once(&once, ^{ table = [NSHashTable weakObjectsHashTable]; });
    return table;
}

static void ABApplyFPSLimit(CADisplayLink *link) {
    if (ABFPSLimit <= 0) return;
    // Original reads the link's current preferred range components and
    // re-applies them clamped; see evidence file. Simplified faithful form:
    CAFrameRateRange range = link.preferredFrameRateRange;
    float lim = (float)ABFPSLimit;
    range.maximum = MIN(range.maximum, lim);
    range.preferred = MIN(range.preferred, lim);
    if (range.minimum > range.maximum) range.minimum = range.maximum;
    if (orig_CADisplayLink_setRange)
        ((void (*)(id, SEL, CAFrameRateRange))orig_CADisplayLink_setRange)(link, @selector(setPreferredFrameRateRange:), range);
    NSInteger fps = link.preferredFramesPerSecond;
    if (orig_CADisplayLink_setFPS && fps > ABFPSLimit)
        ((void (*)(id, SEL, NSInteger))orig_CADisplayLink_setFPS)(link, @selector(setPreferredFramesPerSecond:), ABFPSLimit);
}

static CADisplayLink *ABHook_CADisplayLinkNew(id self, SEL _cmd, id target, SEL selector) {
    CADisplayLink *link = ((CADisplayLink *(*)(id, SEL, id, SEL))orig_CADisplayLink_new)(self, _cmd, target, selector);
    if (link) {
        [ABDisplayLinks() addObject:link];
        ABApplyFPSLimit(link);
    }
    return link;
}
static void ABHook_CADisplayLinkSetFPS(CADisplayLink *self, SEL _cmd, NSInteger fps) {
    if (orig_CADisplayLink_setFPS)
        ((void (*)(id, SEL, NSInteger))orig_CADisplayLink_setFPS)(self, _cmd, fps);
    ABApplyFPSLimit(self);
}
static void ABHook_CADisplayLinkSetRange(CADisplayLink *self, SEL _cmd, CAFrameRateRange range) {
    if (orig_CADisplayLink_setRange)
        ((void (*)(id, SEL, CAFrameRateRange))orig_CADisplayLink_setRange)(self, _cmd, range);
    ABApplyFPSLimit(self);
}
