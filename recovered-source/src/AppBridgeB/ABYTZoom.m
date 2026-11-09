// ABYTZoom.m — YT-ZOOM orientation virtualization (design-ytzoom.md;
// NEW feature, not in the original binary). ONE translation unit,
// two roles, exactly as the module already keeps both roles in its
// B files:
//
//   HOST ROLE (below, this strand): runs only in SpringBoard — the
//   only process where ABHost exists. ABHost is the lease issuer:
//   it pins the hosted YouTube scene at orientation 1 (gate in
//   appWithHash: + yzEffectiveOrientation: at the two consumption
//   points), grants a 3.0 s lease carrying the pane's committed
//   logical size at launch-complete, renews it on a 1.0 s
//   heartbeat, republishes on committed layout changes (0.30 s
//   content throttle), and revokes it at teardown / pref OFF.
//   Grant conditions (design §4.4) are always the full triple:
//   pref ON ∧ bundle == YouTube ∧ pane exists.
//
//   APP ROLE (design §5; added by the app strand at the marker near
//   the end of this file): runs only in the YouTube process.
//
// Log markers use the [ytz] prefix (design §8.2) via OMCLogWrite.

#import "ABYTLease.h"
#import "AppBridgeB.h"
#import "ABHost.h"
#import <CoreFoundation/CoreFoundation.h>
#import <objc/message.h>

// ---------------------------------------------------------------------------
// The wire contract (channel names, payload keys, ack phases,
// timing constants) is defined ONCE in ABYTLease.h as statics —
// this TU defines none of them. What remains local to the host:
// the staging pref key (design §8.1; read ONLY on the host) and
// the ABHost (YTZoom) category declaration — declared here and in
// ABHostBMethods.m because ABHost.h predates the feature (the
// BridgeWake / AutoHide precedent in ABChannels.m).
// ---------------------------------------------------------------------------
#define ABYTPrefVirtualize @"youtubeVirtualize"

@interface ABHost (YTZoom)
- (BOOL)yzLeaseActiveForBundle:(NSString *)bundleID;
- (NSInteger)yzEffectiveOrientation:(ABPane *)pane;
- (void)yzLeaseNoteLayoutForPane:(ABPane *)pane;
- (void)yzLeaseGrantForPane:(ABPane *)pane;
- (void)yzLeaseRevokeForPane:(ABPane *)pane reason:(NSString *)reason;
- (void)yzLogAppOrientBlockedForPane:(ABPane *)pane hash:(uint64_t)hash;
@end

// ---------------------------------------------------------------------------
// Lease record — one per bundle (v1 ever holds exactly one: YouTube).
// A record survives its own revocation as a tombstone so the
// generation counter stays monotonic for the whole host session:
// generation starts at 0 per owner and increments ONLY when the
// published content changes (active, width, height, isSplit,
// sceneID — design §4.2); the first publish carries generation 0,
// which the app reads as the new-owner baseline (§4.6).
// ---------------------------------------------------------------------------
@interface ABYTLeaseRecord : NSObject
@property (nonatomic, copy) NSString *bundleID;
@property (nonatomic) BOOL active;              // granted, unrevoked
@property (nonatomic) NSUInteger generation;    // of last publish
@property (nonatomic) BOOL hasPublished;
@property (nonatomic) BOOL pubActive;
@property (nonatomic) double pubWidth, pubHeight;
@property (nonatomic) BOOL pubIsSplit;
@property (nonatomic, copy) NSString *pubSceneID;
@property (nonatomic) double width, height;     // latest committed candidate
@property (nonatomic) BOOL contentDirty;        // candidate awaits a post
@property (nonatomic) NSTimeInterval lastPostAt;
@property (nonatomic) NSUInteger expiryHeals;   // consecutive expired-ack heals
@end
@implementation ABYTLeaseRecord
@end

static NSMutableDictionary<NSString *, ABYTLeaseRecord *> *YZRecords(void) {
    static NSMutableDictionary *records;
    static dispatch_once_t once;
    dispatch_once(&once, ^{ records = [NSMutableDictionary dictionary]; });
    return records;
}

static ABYTLeaseRecord *YZRecordFor(NSString *bundleID, BOOL create) {
    if (!bundleID) return nil;
    ABYTLeaseRecord *rec = YZRecords()[bundleID];
    if (!rec && create) {
        rec = [ABYTLeaseRecord new];
        rec.bundleID = bundleID;
        YZRecords()[bundleID] = rec;
    }
    return rec;
}

// Session owner (design §4.2): one UUID per SpringBoard registrar
// run; a respring mints a new owner and the app resets on the
// change. Generated lazily at registration — ABSpringBoardReady
// (ABHostGeometry.m, outside this strand's files) would be the
// design's §9 placement; the value's lifetime is identical.
static NSString *YZOwnerID(void) {
    static NSString *owner;
    static dispatch_once_t once;
    dispatch_once(&once, ^{ owner = [[NSUUID UUID] UUIDString]; });
    return owner;
}

// The pref (design §8.1): read ONLY here on the host, at grant
// points, on prefschanged, and on ack requests. Absent = ON since
// 2026-11-09 (Nguyen: staging removed, features ship live); the key
// survives purely as a kill-switch — an explicit youtubeVirtualize
// = NO turns virtualization off.
static BOOL YZPrefEnabled(void) {
    OMCPrefsSync();
    return [OMCPref(ABYTPrefVirtualize, @YES) boolValue];
}

// ---------------------------------------------------------------------------
// Content helpers.
// ---------------------------------------------------------------------------

// sceneID (design §4.2: carried ONLY when the host has it). The
// pane's FBSceneMonitor was built with the scene identifier string
// in setupLiveAppViewForPane:; read it back through a guarded
// private send in the module's own idiom. nil is a normal outcome
// — the app relay has two fallback tiers for exactly this case.
static NSString *YZSceneIDForPane(ABPane *pane) {
    id monitor = pane.sceneMonitor;
    if (!monitor) return nil;
    SEL sel = NSSelectorFromString(@"sceneID");
    if (![monitor respondsToSelector:sel]) return nil;
    id value = nil;
    @try { value = ((id (*)(id, SEL))objc_msgSend)(monitor, sel); }
    @catch (NSException *e) { value = nil; }
    return [value isKindOfClass:[NSString class]] ? value : nil;
}

// Most recent `single` flag per bundle, recorded by this TU's own
// frame/open observers (YZRegisterHostLease). The flag itself is
// consumed inside setBarVisible:pop:dim:single:forApp: — a body
// this feature must not touch — so the raw packet key is tracked
// here instead (same delivery, same value). Since WO Y1 this map
// feeds ONLY the pre-field fallback in YZComputeIsSplit below —
// the bar's zoom flag is no longer the isSplit source.
static NSMutableDictionary<NSString *, NSNumber *> *YZLastSingleByBundle(void) {
    static NSMutableDictionary *singles;
    static dispatch_once_t once;
    dispatch_once(&once, ^{ singles = [NSMutableDictionary dictionary]; });
    return singles;
}

// ---------------------------------------------------------------------------
// Session split state (GPT WO Y1). SCPCarSplit — the presentation
// owner — computes the authoritative split verdict from its own
// state (active split session, >= 2 layout panes, no zoomed slot)
// and rides it in every hostFrameInfo packet as `split` (BOOL)
// with `splitver` (field version, 1). This TU's frame/open
// observers (YZRegisterHostLease) record the newest value PER
// SESSION here, with its receive time; YZComputeIsSplit reads
// this store. The value is event state, not a lease: it persists
// across quiet stretches (a static presentation posts no new
// packets and has not changed), and the first open packet of any
// hosted pane lands before that pane's launch completes, so the
// store is populated before the first publish that reads it.
// ---------------------------------------------------------------------------
static BOOL YZSessionSplitKnown = NO;
static BOOL YZSessionSplitValue = NO;
static NSTimeInterval YZSessionSplitAt = 0;   // receive time of the newest value
static NSInteger YZSessionSplitVer = 0;       // splitver of the newest packet

static void YZNoteSessionSplit(NSNumber *split, NSNumber *ver) {
    if (!split) return;   // packet predates the field: nothing learned
    YZSessionSplitKnown = YES;
    YZSessionSplitValue = [split boolValue];
    YZSessionSplitAt = [NSDate date].timeIntervalSince1970;
    YZSessionSplitVer = ver ? [ver integerValue] : 0;
}

// isSplit (design §4.2, source replaced by WO Y1): the session
// store above when a `split` field has been received. The ORIGINAL
// derivation — ABHost's hosted-pane count plus the bar's `single`
// key — is WRONG for a mixed split (one native pane + one hosted
// YouTube pane: ABHost hosts exactly one pane while the car IS
// split, so the count said "not split" and the app's 0.12 s
// re-read never armed) and survives ONLY as the fallback for
// senders older than the field; every fallback use is logged
// (throttled like yzLogAppOrientBlockedForPane:) so the car log
// can convict which source produced the value. The field only
// steers the app's 0.12 s re-read step (design §5.5); an error
// here cannot break the core mechanism.
static NSTimeInterval YZLastFallbackLogAt = 0;

static BOOL YZComputeIsSplit(ABHost *host, NSString *bundleID) {
    if (YZSessionSplitKnown) return YZSessionSplitValue;
    // FALLBACK (sender older than the `split` field): the pane
    // count lives ONLY on this path now, behind the log.
    NSTimeInterval now = [NSDate date].timeIntervalSince1970;
    if (now - YZLastFallbackLogAt >= 5.0) {
        YZLastFallbackLogAt = now;
        OMCLogWrite(@"AppBridge",
            @"[ytz] isSplit-fallback: chua nhan truong split tu CarPlay, dung dem pane + single");
    }
    if (host.panes.count <= 1) return NO;
    return ![YZLastSingleByBundle()[bundleID] boolValue];
}

// ---------------------------------------------------------------------------
// Issuer. Every post carries the FULL lease state (design §4.2);
// generation increments inside, only on a content change against
// the last published set. Callers decide WHEN to post:
//   grant / revoke / ack-request / ack-expired heal -> immediately
//   layout content change -> 0.30 s throttle (yzLeaseNoteLayoutForPane:)
//   heartbeat tick (1.0 s) -> always (renewal; same generation
//   unless the content changed since the last post).
// ---------------------------------------------------------------------------
static void YZPublish(ABHost *host, ABYTLeaseRecord *rec) {
    ABPane *pane = [host paneFor:rec.bundleID];
    BOOL split = YZComputeIsSplit(host, rec.bundleID);
    NSString *sid = pane ? YZSceneIDForPane(pane) : nil;
    BOOL changed = !rec.hasPublished
        || rec.active != rec.pubActive
        || rec.width != rec.pubWidth
        || rec.height != rec.pubHeight
        || split != rec.pubIsSplit
        || (sid != rec.pubSceneID && ![sid isEqualToString:rec.pubSceneID]);
    if (changed && rec.hasPublished) rec.generation += 1;
    if (changed) {
        rec.pubActive = rec.active;
        rec.pubWidth = rec.width;
        rec.pubHeight = rec.height;
        rec.pubIsSplit = split;
        rec.pubSceneID = sid;
        rec.hasPublished = YES;
    }
    rec.contentDirty = NO;
    NSMutableDictionary *payload = [@{
        ABYTLeaseKeyVersion:    @(ABYTLeaseVersion),
        ABYTLeaseKeyOwner:      YZOwnerID(),
        ABYTLeaseKeyGeneration: @(rec.generation),
        ABYTLeaseKeyIssuedAt:   @([NSDate date].timeIntervalSince1970),
        ABYTLeaseKeyActive:     @(rec.active),
        ABYTLeaseKeyOrientation: @1,
        ABYTLeaseKeyWidth:      @(rec.width),
        ABYTLeaseKeyHeight:     @(rec.height),
        ABYTLeaseKeyIsSplit:    @(split),
    } mutableCopy];
    if (sid) payload[ABYTLeaseKeySceneID] = sid;
    [[NSDistributedNotificationCenter defaultCenter]
        postNotificationName:ABYTLeaseChannel object:rec.bundleID
                    userInfo:payload];
    rec.lastPostAt = [NSDate date].timeIntervalSince1970;
}

// ---------------------------------------------------------------------------
// Heartbeat (design §4.3): one repeating 1.0 s timer, alive only
// while at least one lease is active. 1.0 s against the 3.0 s term
// tolerates two consecutive missed beats before the app expires.
// ---------------------------------------------------------------------------
static NSTimer *YZHeartbeatTimer = nil;

static void YZHeartbeatTick(void) {
    ABHost *host = [ABHost shared];
    for (ABYTLeaseRecord *rec in [YZRecords() allValues])
        if (rec.active) YZPublish(host, rec);
}

static void YZStartHeartbeatIfNeeded(void) {
    if (YZHeartbeatTimer) return;
    YZHeartbeatTimer = [NSTimer scheduledTimerWithTimeInterval:1.0
                                                         repeats:YES
                                                           block:^(NSTimer *timer) {
        YZHeartbeatTick();
    }];
    // Cadence begins (design §8.2 logs the rhythm change, not ticks).
    OMCLogWrite(@"AppBridge", @"[ytz] lease gia han");
}

static void YZStopHeartbeatIfIdle(void) {
    for (ABYTLeaseRecord *rec in [YZRecords() allValues])
        if (rec.active) return;
    [YZHeartbeatTimer invalidate];
    YZHeartbeatTimer = nil;
}

// ---------------------------------------------------------------------------
// Host role — the ABHost surface declared in ABYTLease.h.
// ---------------------------------------------------------------------------
@implementation ABHost (YTZoom)

- (BOOL)yzLeaseActiveForBundle:(NSString *)bundleID {
    ABYTLeaseRecord *rec = YZRecordFor(bundleID, NO);
    return rec && rec.active;
}

// Design §3.2.2: the pin lives at the READS, not in the stored
// state — while the lease lives the two consumption points
// (layoutPane:/nudgePane:) see orientation 1, so no axis transpose
// happens and the settings transaction writes 1. The moment the
// lease ends, the untouched -effectiveOrientation: result returns,
// bit-exact.
- (NSInteger)yzEffectiveOrientation:(ABPane *)pane {
    if (!pane) return 0;
    if ([self yzLeaseActiveForBundle:pane.bundleID]) return 1;
    return [self effectiveOrientation:pane];
}

// Issuer hook at the end of layoutPane: (design §4.3). pane.sceneBox
// has just been assigned the box size layoutPane: committed with,
// so the logical size derived here — round(box / zoom), transposed
// iff the orientation THIS layout used is in 3..5 — is exactly the
// pair the settings transaction wrote (under a live lease the
// orientation is 1, hence never transposed). The lease never
// carries a mid-drag/live size: this hook runs only from the
// committed layout path.
- (void)yzLeaseNoteLayoutForPane:(ABPane *)pane {
    if (!pane) return;
    ABYTLeaseRecord *rec = YZRecordFor(pane.bundleID, NO);
    if (!rec || !rec.active) return;
    // Belt (design §3.2.3, tail): while a lease lives the gate in
    // appWithHash: makes a nonzero residue unreachable; if one ever
    // appears, the settings THIS layout committed are already
    // portrait (yzEffectiveOrientation:), so only the stored value
    // is cleared and the anomaly logged.
    if (pane.requestedOrientation != 0) {
        OMCLogWrite(@"AppBridge", [NSString stringWithFormat:
            @"[ytz] sua residue: requestedOrientation %ld -> 0",
            (long)pane.requestedOrientation]);
        pane.requestedOrientation = 0;
    }
    CGSize box = pane.sceneBox;
    if (box.width < 2 || box.height < 2) return;
    double z = [self zoom];
    NSInteger orient = [self yzEffectiveOrientation:pane];
    CGSize logical = CGSizeMake(round(box.width / z), round(box.height / z));
    if (orient >= 3 && orient <= 5)
        logical = CGSizeMake(logical.height, logical.width);
    rec.width = logical.width;
    rec.height = logical.height;
    BOOL changed = !rec.hasPublished
        || rec.width != rec.pubWidth
        || rec.height != rec.pubHeight
        || YZComputeIsSplit(self, pane.bundleID) != rec.pubIsSplit;
    if (!changed) return;
    // Content throttle 0.30 s (design §4.3): a change inside the
    // window is carried by the next heartbeat (<= 1.0 s) instead.
    NSTimeInterval now = [NSDate date].timeIntervalSince1970;
    if (rec.hasPublished && now - rec.lastPostAt < 0.30) {
        rec.contentDirty = YES;
        return;
    }
    YZPublish(self, rec);
}

// Grant (design §4.4): full triple checked here so every call site
// (launch-complete, prefschanged ON, ack request) is safe to wire
// unconditionally.
- (void)yzLeaseGrantForPane:(ABPane *)pane {
    if (!pane) return;
    if (![pane.bundleID isEqualToString:ABYTLeaseYouTubeBundle]) return;
    if (!YZPrefEnabled()) return;
    if (![self.panes containsObject:pane]) return;
    ABYTLeaseRecord *rec = YZRecordFor(pane.bundleID, YES);
    BOOL fresh = !rec.active;
    // Portrait repair (design §3.2.3) BEFORE the lease is published:
    // clear any r6 residue, then one layoutPane: transaction
    // re-commits {untransposed logical size, orientation 1}; the
    // issuer hook at the end of that layout makes the first post.
    if (pane.requestedOrientation != 0) {
        OMCLogWrite(@"AppBridge", [NSString stringWithFormat:
            @"[ytz] sua residue: requestedOrientation %ld -> 0",
            (long)pane.requestedOrientation]);
        pane.requestedOrientation = 0;
    }
    rec.active = YES;
    rec.expiryHeals = 0;
    [self layoutPane:pane];
    if (!rec.hasPublished) YZPublish(self, rec);
    if (fresh) {
        OMCLogWrite(@"AppBridge", [NSString stringWithFormat:
            @"[ytz] lease cap gen=%lu size=%gx%g split=%d",
            (unsigned long)rec.generation, rec.pubWidth, rec.pubHeight,
            rec.pubIsSplit ? 1 : 0]);
    }
    YZStartHeartbeatIfNeeded();
}

// Revoke (design §4.4): the active flip is itself a content change,
// so the post bumps the generation and goes out immediately — the
// app must see the lease die before anything else the caller does
// next (teardownPane: posts orientation -1 right after this call).
- (void)yzLeaseRevokeForPane:(ABPane *)pane reason:(NSString *)reason {
    if (!pane) return;
    ABYTLeaseRecord *rec = YZRecordFor(pane.bundleID, NO);
    if (!rec || !rec.active) return;
    rec.active = NO;
    YZPublish(self, rec);
    OMCLogWrite(@"AppBridge", [NSString stringWithFormat:
        @"[ytz] lease thu hoi ly do=%@", reason ?: @"teardown"]);
    YZStopHeartbeatIfIdle();
}

- (void)yzLogAppOrientBlockedForPane:(ABPane *)pane hash:(uint64_t)hash {
    static NSMutableDictionary<NSString *, NSDate *> *lastLog;
    static dispatch_once_t once;
    dispatch_once(&once, ^{ lastLog = [NSMutableDictionary dictionary]; });
    NSDate *last = lastLog[pane.bundleID];
    NSDate *now = [NSDate date];
    if (last && [now timeIntervalSinceDate:last] < 5.0) return;
    lastLog[pane.bundleID] = now;
    OMCLogWrite(@"AppBridge", [NSString stringWithFormat:
        @"[ytz] chan apporient: pane dang ao hoa (hash=%llu)",
        (unsigned long long)hash]);
}

@end

// ---------------------------------------------------------------------------
// Ack channel (design §4.5). The host acts on exactly two phases:
// `request` (republish / grant — heals the app-started-first race)
// and `expired` (republish, self-healing capped at 3 CONSECUTIVE
// heals per pane so a clock disagreement cannot loop post/receive
// forever; an `applied` ack resets the counter). Every ack is
// logged in the design's §8.2 format — the `applied` line is the
// car session's measurement evidence.
// ---------------------------------------------------------------------------
static void YZHandleAck(NSNotification *note) {
    NSDictionary *ui = note.userInfo;
    if (![ui isKindOfClass:[NSDictionary class]]) return;
    NSString *bundle = ui[ABYTLeaseAckKeyIdentifier];
    if (![bundle isKindOfClass:[NSString class]] || !bundle)
        bundle = [note.object isKindOfClass:[NSString class]] ? note.object : nil;
    NSString *phase = ui[ABYTLeaseAckKeyPhase];
    if (!bundle || ![phase isKindOfClass:[NSString class]]) return;
    OMCLogWrite(@"AppBridge", [NSString stringWithFormat:
        @"[ytz] ack phase=%@ windows=%@ mismatch=%@",
        phase, ui[ABYTLeaseAckKeyWindows] ?: @"-", ui[ABYTLeaseAckKeyMismatch] ?: @"-"]);
    ABHost *host = [ABHost shared];
    ABPane *pane = [host paneFor:bundle];
    ABYTLeaseRecord *rec = YZRecordFor(bundle, NO);
    if ([phase isEqualToString:ABYTLeasePhaseApplied]) {
        if (rec) rec.expiryHeals = 0;
        return;
    }
    if ([phase isEqualToString:ABYTLeasePhaseRequest]) {
        if (!pane || !YZPrefEnabled()) return;
        if (rec && rec.active) YZPublish(host, rec);
        else [host yzLeaseGrantForPane:pane];
        return;
    }
    if ([phase isEqualToString:ABYTLeasePhaseExpired]) {
        // Y4 instrument (WO Y4): the app has declared the lease
        // LAPSED (no heartbeat inside its 3.0 s TTL window). The
        // generic ack line above does not distinguish this event,
        // so log the declaration explicitly — bundle, the record's
        // generation and the heal count this declaration is about
        // to consume — BEFORE the guards below, so a lapse the host
        // cannot heal (record inactive, pane gone, pref off) is
        // still on the record. OMCLogWrite stamps the time.
        OMCLogWrite(@"AppBridge", [NSString stringWithFormat:
            @"[ytz] lease-lapse: app khai het han bundle=%@ gen=%lu heal=%lu",
            bundle, (unsigned long)(rec ? rec.generation : 0),
            (unsigned long)(rec ? rec.expiryHeals : 0)]);
        if (!rec || !rec.active || !pane || !YZPrefEnabled()) return;
        if (rec.expiryHeals >= 3) return;   // heartbeat only, from here
        rec.expiryHeals += 1;
        YZPublish(host, rec);
        return;
    }
    // revoked: log-only (the line above) — the app has already left
    // virtualization; nothing for the host to undo.
}

// ---------------------------------------------------------------------------
// prefschanged (design §8.1): toggling youtubeVirtualize mid-session
// grants / revokes without re-plugging CarPlay. The Darwin callback
// hops to the main queue; the pref value itself is re-read there.
// ---------------------------------------------------------------------------
static void YZHandlePrefChanged(void) {
    ABHost *host = [ABHost shared];
    if (!YZPrefEnabled()) {
        for (ABYTLeaseRecord *rec in [YZRecords() allValues]) {
            if (!rec.active) continue;
            ABPane *pane = [host paneFor:rec.bundleID];
            if (pane) [host yzLeaseRevokeForPane:pane reason:@"pref"];
            else {
                // Pane already gone: the record is orphaned — post
                // the revocation directly so a listening app is not
                // left holding a lease nobody will renew.
                rec.active = NO;
                YZPublish(host, rec);
            }
        }
        YZStopHeartbeatIfIdle();
        return;
    }
    for (ABPane *pane in [host.panes copy])
        [host yzLeaseGrantForPane:pane];
}

static void YZPrefsChangedCallback(CFNotificationCenterRef center,
                                   void *observer, CFStringRef name,
                                   const void *object,
                                   CFDictionaryRef userInfo) {
    dispatch_async(dispatch_get_main_queue(), ^{ YZHandlePrefChanged(); });
}

// ---------------------------------------------------------------------------
// Registration (design §9 registrar role; wired from ABChannels.m
// §7 beside the BridgeWake / AutoHide host registrations).
// ---------------------------------------------------------------------------
void YZRegisterHostLease(void) {
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        (void)YZOwnerID();   // materialize the session owner up front
        // Y4 instrument (WO Y4): an owner change is, from the
        // app's side, exactly this moment — a new host process
        // minting a new session UUID. Log the boundary explicitly
        // so the car log shows when the owner turned over and to
        // what; OMCLogWrite stamps wall-clock time on every line.
        OMCLogWrite(@"AppBridge", [NSString stringWithFormat:
            @"[ytz] owner phien host: %@", YZOwnerID()]);
        NSDistributedNotificationCenter *dc =
            [NSClassFromString(@"NSDistributedNotificationCenter")
                defaultCenter];
        NSOperationQueue *mq = [NSOperationQueue mainQueue];
        // Ack channel — addressed per bundle; v1 serves YouTube only.
        [dc addObserverForName:ABYTLeaseAckChannel
                        object:ABYTLeaseYouTubeBundle queue:mq
                    usingBlock:^(NSNotification *note) {
            YZHandleAck(note);
        }];
        // Packet tracking for isSplit: observe the two packets
        // that carry the keys (no hop — recording raw keys does
        // not depend on the registrar's application order). The
        // `split`/`splitver` keys feed the WO Y1 session store
        // (the authoritative source); `single` is still recorded
        // but now feeds only the logged fallback.
        for (NSString *name in @[ABChanOpen, ABChanFrame]) {
            [dc addObserverForName:name object:nil queue:mq
                        usingBlock:^(NSNotification *note) {
                NSString *bundle = note.userInfo[@"identifier"];
                NSNumber *single = note.userInfo[@"single"];
                if (bundle && single) YZLastSingleByBundle()[bundle] = single;
                YZNoteSessionSplit(note.userInfo[@"split"],
                                   note.userInfo[@"splitver"]);
            }];
        }
        CFNotificationCenterAddObserver(
            CFNotificationCenterGetDarwinNotifyCenter(), NULL,
            YZPrefsChangedCallback,
            CFSTR("com.anlai.omnicar/prefschanged"), NULL,
            CFNotificationSuspensionBehaviorDeliverImmediately);
    });
}

// ===========================================================================
// APP ROLE (design §5) — added by the app strand in this same TU:
// process lease state + observer, the six answer surfaces' shared
// lease check, the window relay (§5.4), the 0.12 s re-read (§5.5)
// and the 0.5 s expiry watchdog (§5.6). Nothing below this marker
// is host code; nothing above it runs outside SpringBoard (the
// ABHost category is inert where no ABHost exists, and
// YZRegisterHostLease is called only from the SpringBoard branch
// of ABHostProcessInit).
// ===========================================================================
