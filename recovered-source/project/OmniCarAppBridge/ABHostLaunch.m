// ABHostLaunch.m — ABHost registry, launch entry, close/disconnect routing,
// bar-action posting, and the app-state feedback poster.
// Agent A scope. Bodies reconstructed from disassembly; statuses inline.

#import "ABHost.h"
#import "ABChromeViews.h" // [integration phase 1; backported to src in phase 3] full chrome-view interfaces (module B decls)
#import "OMCCore.h"
#import <objc/runtime.h>
#import <objc/message.h> // [integration phase 1; backported to src in phase 3] declares objc_msgSend used below

static NSString *const kABStateName = @"com.anlai.omnicar/appbridge.state";
static NSString *const kABBarActionName = @"com.anlai.omnicar/appbridge.baraction";

// ---------------------------------------------------------------------------
// FNV-1a 32 — VERIFIED @ 0xf4d0-0xf504 (basis 0x811C9DC5 in w27,
// prime 0x01000193 in w25; loop: h = (h ^ byte) * prime).
// ---------------------------------------------------------------------------
uint32_t ABBundleIDHash(NSString *bundleID) {
    const char *s = bundleID.UTF8String;
    uint32_t h = 0x811C9DC5u;
    if (s) {
        while (*s) {
            h = (h ^ (uint8_t)*s) * 0x01000193u;
            s++;
        }
    }
    return h;
}

// ---------------------------------------------------------------------------
// sub_bed4 @ 0xbed4 — VERIFIED: object is nil (x3 = 0 at 0xbf74).
// ---------------------------------------------------------------------------
void ABPostAppState(NSString *bundleID, NSString *state) {
    if (!bundleID) return;
    NSDistributedNotificationCenter *center =
        [NSClassFromString(@"NSDistributedNotificationCenter") defaultCenter];
    NSDictionary *info = @{@"identifier": bundleID, @"state": state};
    [center postNotificationName:kABStateName object:nil userInfo:info];
}

@implementation ABHost

// +shared @ 0xa9e8 — VERIFIED, ADJUDICATED the sole definition (final
// closure): the once-block invoke @0xaa2c does objc_opt_new on ABHost
// and then setPanes:[NSMutableArray array] — exactly this body;
// module B's duplicate (no panes initialisation) was removed.
+ (instancetype)shared {
    static ABHost *shared;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        shared = [self new];
        shared.panes = [NSMutableArray array];
    });
    return shared;
}

// -count @ 0xaaa0 — VERIFIED.
- (NSUInteger)count { return self.panes.count; }

// -hostsApp: @ 0xaaf0 — VERIFIED, ADJUDICATED the sole definition
// (final closure): the IMP branches on a nil argument first
// (cbz x19 @0xab2c -> NO) — the explicit guard below; module B's
// unguarded duplicate was removed.
- (BOOL)hostsApp:(NSString *)bundleID {
    if (!bundleID) return NO;
    for (ABPane *pane in self.panes)
        if ([pane.bundleID isEqualToString:bundleID]) return YES;
    return NO;
}

// -paneFor: @ 0xac84 — VERIFIED.
- (ABPane *)paneFor:(NSString *)bundleID {
    for (ABPane *pane in self.panes)
        if ([pane.bundleID isEqualToString:bundleID]) return pane;
    return nil;
}

// -zoom @ 0xae20 — ADJUDICATED (final closure; dump
// disasm/fin_imp_zoom.txt in AppBridgeB): the sole definition lives in
// module B's ABHostBMethods.m. The IMP calls _OMCPrefsSync first and
// reads OMCPref(@"appBridgeZoom", @80) — the default is the
// NSConstantIntegerNumber @80 at 0x395a0 — then /100.0, fmaxnm against
// 0.6 (@0x2b210), fcsel against 1.0. This file's former body (nil
// default, no sync) contradicts the IMP on both points and was removed.
//
// -bundleForHash: @ 0xf40c — VERIFIED, ADJUDICATED the sole definition
// (module B's duplicate reduced to a pointer note). Correction applied
// (final closure): the IMP compares the zero-extended 32-bit FNV-1a
// hash against the FULL 64-bit argument (cmp x27, x20 @0xf510); the
// former (uint32_t) cast on the argument truncated it instead.
- (NSString *)bundleForHash:(unsigned long long)hash {
    for (ABPane *pane in self.panes)
        if ((uint64_t)ABBundleIDHash(pane.bundleID) == hash)
            return pane.bundleID;
    return nil;
}

// -frameOfApp: @ 0xf5ec — VERIFIED (pane's box frame, CGRectZero if none).
- (CGRect)frameOfApp:(NSString *)bundleID {
    ABPane *pane = [self paneFor:bundleID];
    return pane ? pane.box.frame : CGRectZero;
}

// -appWithHash:changedOrientation:supportedMask: @ 0xf6b0 —
// ADJUDICATED (final closure; dump disasm/fin_imp_appWithHash.txt in
// AppBridgeB): the sole definition lives in module B's
// ABHostBMethods.m. This file's former body was truncated against the
// IMP: it stored the requested orientation raw, but the IMP derives
// it from the supported mask when the change code is 0xFF (bit algebra
// @0xf83c-0xf87c) and finishes with [self nudgePane:found] (@0xf8f8),
// neither of which was here; it was removed.

// ---------------------------------------------------------------------------
// -openApp:frame: @ 0xb8a0 — VERIFIED step by step:
//  1. empty bundleID -> return
//  2. !OMCFeatureEnabled(@"appBridge") -> log "tat trong Cai dat -> khong
//     host %@", ABPostAppState(bundleID, @"failed"), return
//  3. existing pane -> setFrame:forApp:live:NO handle:YES
//     passInsets:pane.box.passInsets (ABBoxView property, B), return
//  4. ![self ensureWindow] (B; fails when no CarPlay display) ->
//     log "xe chua ket noi -> khong host %@", post @"failed", return
//  5. build pane: bundleID, frame; orientation from pref
//     "appBridgeOrientation" (default object @0x395b8 = @1, decoded
//     byte-exact rem4 — see the call site below),
//     with values 3 and 4 mapped to 0 (cmp/csel at 0xba2c-0xba38);
//     ABBoxView initWithFrame, black background, clipsToBounds YES,
//     alpha 0; add to window; shield if shieldOn; raiseKnobs;
//     setupHandleForPane:; panes += pane; setupLiveAppViewForPane: (B);
//     layoutPane: (B); log "host %@ tai %@ (huong %lld, zoom %.2f)"
//  6. dispatch_after(2.5 s, main): block @ 0xc018 — loadWeakRetained
//     pane; if self.panes still contains it, [self revealPane:pane]
//     (@0xc070); if pane.ready is already set, stop (@0xc078); re-check
//     containment (@0xc098), then pane.ready = YES (@0xc0b4) and
//     ABPostAppState(pane.bundleID, @"ready") (@0xc0d4, @"ready" @ 0xc0d0)
//     [fix-round2 RESTORED: the previous transcription posted @"ready"
//     on weakPane-non-nil alone — no reveal, no ready check/flag, no
//     containment check. That was the ready-without-show divergence;
//     see work/fix-round2/audit-appbridge-launch.md item 3.]
//  @catch: log "host %@ that bai: %@", remove pane + box, dropWindowIfEmpty,
//     post @"failed"
// ---------------------------------------------------------------------------
- (void)openApp:(NSString *)bundleID frame:(CGRect)frame {
    if (bundleID.length == 0) return;
    if (!OMCFeatureEnabled(@"appBridge")) {
        OMCLogWrite(@"AppBridge", [NSString stringWithFormat:
            @"tat trong Cai dat -> khong host %@", bundleID]);
        ABPostAppState(bundleID, @"failed");
        return;
    }
    ABPane *pane = [self paneFor:bundleID];
    if (pane) {
        // passInsets comes from pane.box (ABBoxView -passInsets, B method).
        UIEdgeInsets insets = UIEdgeInsetsZero;
        if ([pane.box respondsToSelector:@selector(passInsets)]) {
            UIEdgeInsets (*fn)(id, SEL) = (void *)objc_msgSend;
            insets = fn(pane.box, @selector(passInsets));
        }
        [self setFrame:frame forApp:bundleID live:NO handle:YES
          passInsets:insets];
        return;
    }
    if (![self ensureWindow]) {
        OMCLogWrite(@"AppBridge", [NSString stringWithFormat:
            @"xe chua ket noi -> khong host %@", bundleID]);
        ABPostAppState(bundleID, @"failed");
        return;
    }
    pane = [ABPane new];
    pane.bundleID = bundleID;
    pane.frame = frame;
    OMCPrefsSync();
    // rem4: the IMP materialises the __objc_intobj constant @0x395b8
    // as the _OMCPref default (@0xba08); that object decodes byte-
    // exact as the constant NSNumber @1 (24-byte intobj entry,
    // payload +16 = 1). The former `nil` default was wrong: with the
    // pref unset the binary yields orientation 1, not 0.
    long long ori = [OMCPref(@"appBridgeOrientation", @1) longLongValue];
    if (ori == 3 || ori == 4) ori = 0;
    pane.orientation = ori;
    @try {
        UIView *box = [[NSClassFromString(@"ABBoxView") alloc] initWithFrame:frame];
        pane.box = box;
        box.backgroundColor = [UIColor blackColor];
        box.clipsToBounds = YES;
        box.alpha = 0;
        [self.window addSubview:box];
        if (self.shieldOn) [self setShield:YES forPane:pane];
        [self raiseKnobs];
        [self setupHandleForPane:pane];
        [self.panes addObject:pane];
        // [fix-round2] [GPT-F] MILESTONE logging only (no flow change).
        OMCLogWrite(@"AppBridge", [NSString stringWithFormat:
            @"MILESTONE request bundle=%@ pane=%p",
            bundleID, (void *)pane]);
        [self setupLiveAppViewForPane:pane];   // [B] scene launch + hosting
        [self layoutPane:pane];                // [B]
        OMCLogWrite(@"AppBridge", [NSString stringWithFormat:
            @"host %@ tai %@ (huong %lld, zoom %.2f)",
            bundleID, NSStringFromCGRect(frame), pane.orientation, [self zoom]]);
        __weak ABPane *weakPane = pane;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 2500000000LL),
                       dispatch_get_main_queue(), ^{
            // Block @0xc018, restored verbatim in flow [fix-round2]:
            // strong self capture, weak pane; reveal precedes the
            // ready check, containment is checked twice.
            ABPane *p = weakPane;
            if (!p) return;
            if ([self.panes containsObject:p]) {
                // [fix-round2] MILESTONE logging only.
                OMCLogWrite(@"AppBridge", [NSString stringWithFormat:
                    @"MILESTONE revealPane bundle=%@ pane=%p readySource=timer",
                    p.bundleID, (void *)p]);
                [self revealPane:p];
            }
            if (p.ready) return;
            if (![self.panes containsObject:p]) return;
            p.ready = YES;
            ABPostAppState(p.bundleID, @"ready");
        });
    } @catch (NSException *e) {
        OMCLogWrite(@"AppBridge", [NSString stringWithFormat:
            @"host %@ that bai: %@", bundleID, e]);
        [self.panes removeObject:pane];
        [pane.box removeFromSuperview];
        [self dropWindowIfEmpty];
        ABPostAppState(bundleID, @"failed");
    }
}

// ---------------------------------------------------------------------------
// -closeApp:terminate: @ 0x15ca0 — VERIFIED through dropWindowIfEmpty:
// log "dong %@%@" (suffix @" (tat han)" when terminate),
// [ABKeyboard.shared hideForApp:] (B class), teardownPane: (B),
// remove from panes, dropWindowIfEmpty.
// The terminate==YES tail (0x15da4-0x15fb4) is VERIFIED as well —
// transcribed from src/AppBridgeB/disasm/
// m_ABHost_closeApp_terminate.txt: it resolves the frontmost
// application via UIApplication _accessibilityFrontMostApplication;
// if that app's bundle id equals the closing app's, it logs
// "%@ dang mo tren iPhone, khong tat" and does NOT terminate;
// otherwise it calls FBSSystemService sharedService
// terminateApplication:forReason:andReport:withDescription:
// (bundleID, 1, NO, @"OmniCar App Bridge: closed") and logs
// "tat han %@", or logs "khong tim thay API terminate cho %@" when
// the service or the selector is unavailable. Private selectors are
// resolved dynamically with ABMissingSelector fallbacks, exactly as
// in the binary.
// ---------------------------------------------------------------------------
- (void)closeApp:(NSString *)bundleID terminate:(BOOL)terminate {
    ABPane *pane = [self paneFor:bundleID];
    if (!pane) return;
    OMCLogWrite(@"AppBridge", [NSString stringWithFormat:
        @"dong %@%@", bundleID, terminate ? @" (tat han)" : @""]);
    // [[ABKeyboard shared] hideForApp:bundleID] (ABKeyboard is B's class;
    // called here via dynamic dispatch exactly as the binary does).
    id kb = [NSClassFromString(@"ABKeyboard") shared];
    [kb performSelector:@selector(hideForApp:) withObject:bundleID];
    // [ytz4-hb] this teardown hide bypasses ABKeyboardDispatch, so
    // the kb session record would go stale without its own sync:
    // report the close through the same funnel (ABHostGeometry.m).
    ABKbSyncNoteEvent(bundleID, NO);
    [self teardownPane:pane];
    [self.panes removeObject:pane];
    [self dropWindowIfEmpty];
    if (terminate) {
        // Terminate tail @ 0x15da4 — VERIFIED (dump cited above).
        id app = [UIApplication sharedApplication];
        SEL frontSel = NSSelectorFromString(@"_accessibilityFrontMostApplication");
        id frontApp = nil;
        if ([app respondsToSelector:frontSel])
            frontApp = ((id (*)(id, SEL))objc_msgSend)(app, frontSel);
        else
            ABMissingSelector(app, @"_accessibilityFrontMostApplication");
        BOOL frontIsTarget = NO;
        if (frontApp) {
            SEL idSel = NSSelectorFromString(@"bundleIdentifier");
            NSString *frontID = nil;
            if ([frontApp respondsToSelector:idSel])
                frontID = ((id (*)(id, SEL))objc_msgSend)(frontApp, idSel);
            else
                ABMissingSelector(frontApp, @"bundleIdentifier");
            frontIsTarget = [frontID isEqualToString:bundleID];
        }
        if (frontIsTarget) {
            // The app is frontmost on the phone itself: closing the
            // car pane must not kill it (0x15e94-0x15ec4).
            OMCLogWrite(@"AppBridge", [NSString stringWithFormat:
                @"%@ dang mo tren iPhone, khong tat", bundleID]);
        } else {
            // 0x15ec8-0x15fb4: FBSSystemService terminate API.
            Class fbsClass = objc_getClass("FBSSystemService");
            SEL svcSel = NSSelectorFromString(@"sharedService");
            id service = nil;
            if ([(id)fbsClass respondsToSelector:svcSel])
                service = ((id (*)(id, SEL))objc_msgSend)((id)fbsClass, svcSel);
            else
                ABMissingSelector((id)fbsClass, @"sharedService");
            SEL termSel = NSSelectorFromString(
                @"terminateApplication:forReason:andReport:withDescription:");
            if (service && [service respondsToSelector:termSel]) {
                ((void (*)(id, SEL, id, int, BOOL, id))objc_msgSend)(
                    service, termSel, bundleID, 1, NO,
                    @"OmniCar App Bridge: closed");
                OMCLogWrite(@"AppBridge", [NSString stringWithFormat:
                    @"tat han %@", bundleID]);
            } else {
                OMCLogWrite(@"AppBridge", [NSString stringWithFormat:
                    @"khong tim thay API terminate cho %@", bundleID]);
            }
        }
    }
}

// -closeAll @ 0x160ec / -closeAllExcept: @ 0x160f4 — VERIFIED pattern
// (closeAll tail-calls closeAllExcept:nil).
- (void)closeAll { [self closeAllExcept:nil]; }

- (void)closeAllExcept:(NSString *)bundleID {
    for (ABPane *pane in [self.panes copy])
        if (!bundleID || ![pane.bundleID isEqualToString:bundleID])
            [self closeApp:pane.bundleID terminate:NO];
}

// -carDisconnected @ 0x163e8 — ADJUDICATED (final closure; dump
// disasm/fin_imp_carDisconnected.txt in AppBridgeB): the sole
// definition lives in module B's ABHostBMethods.m, now VERIFIED
// against the IMP. This file's former INFERRED skeleton contradicted
// the IMP on its central mechanism — the IMP contains no closeApp:
// call at all: it clears the knob views, returns early when there are
// no panes and no window, logs "xe ngat -> bo %lu o" BEFORE tearing
// down, calls teardownPane: on every pane directly, clears the
// registry, and hides + releases the window. Removed.

// ---------------------------------------------------------------------------
// -postBarAction:from: @ 0x13148 — VERIFIED: pane via paneOfBarButton: (B),
// log "thanh nut %@: %@", post baraction with object nil.
// Wrappers @ 0x13378-0x133c8 — VERIFIED action strings.
// ---------------------------------------------------------------------------
- (void)postBarAction:(NSString *)action from:(id)sender {
    ABPane *pane = [self paneOfBarButton:sender];
    OMCLogWrite(@"AppBridge", [NSString stringWithFormat:
        @"thanh nut %@: %@", pane.bundleID, action]);
    // [hl18-picker] SpringBoard's bar shield can swallow the very next
    // touch over a CarPlay picker. Remove it before posting replace.
    if ([action isEqualToString:@"replace"]) {
        [self outsideTouched];
        OMCLogWrite(@"AppBridge",
            @"[hl18-picker] ev=replace shield-cleared before-post");
    }
    NSDistributedNotificationCenter *center =
        [NSClassFromString(@"NSDistributedNotificationCenter") defaultCenter];
    NSDictionary *info = @{@"identifier": pane.bundleID ?: @"",
                           @"action": action};
    [center postNotificationName:kABBarActionName object:nil userInfo:info];
}

- (void)barReplace:(id)sender    { [self postBarAction:@"replace" from:sender]; }
- (void)barPop:(id)sender        { [self postBarAction:@"pop" from:sender]; }
- (void)barFull:(id)sender       { [self postBarAction:@"full" from:sender]; }
- (void)barBackground:(id)sender { [self postBarAction:@"bg" from:sender]; }
- (void)barClose:(id)sender      { [self postBarAction:@"close" from:sender]; }

@end
