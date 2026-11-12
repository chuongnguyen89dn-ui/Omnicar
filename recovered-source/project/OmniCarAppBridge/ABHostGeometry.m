// ABHostGeometry.m — SpringBoard-side machinery in module B's scope:
//   * the -[SpringBoard applicationDidFinishLaunching:] replacement
//     (sub_7004, the channel registrar — the method itself is module A's
//     launch surface, but its registrations define B's channels, so the
//     registration code is reproduced here with the partition noted),
//   * the lifecycle hooks that keep hosted scenes alive (sub_72BC, sub_74B4,
//     sub_7764, sub_777C),
//   * the channel consumer blocks for frame / shield / apporient /
//     keyboard / CarPlay-connect (sub_8274, sub_8C7C, sub_92B4, sub_93B0,
//     sub_958C),
//   * ABHost methods for geometry, orientation, shield, lifecycle
//     (setFrame:…, layoutPane:, nudgePane:, appWithHash:…, setHole:…,
//     sceneMonitor:sceneWasDestroyed:, carDisconnected, handlePanned:,
//     handleTapped:, outsideTouched, …),
//   * C helpers sub_E6B8 (orientation post) and sub_BED4 (state post).
//
// ABHost / ABPane class declarations live in ABHost.h (shared with module A).

#import "AppBridgeB.h"
#import "ABHost.h"
#import "ABKeyboardDecl.h" // [hl40-original-keyboard] restored original host panel class
#import <objc/runtime.h>
#import <objc/message.h> // [integration phase 1; backported to src in phase 3] declares objc_msgSend used below
#import <substrate.h> // FIX-ROUND2: ABInstallSpringBoardHooks (below) calls MSHookMessageEx/MSHookFunction from this TU
#import <dlfcn.h>     // FIX-ROUND2: dlsym for BKSDisplayServicesSetScreenBlanked in ABInstallSpringBoardHooks
#import <CoreFoundation/CoreFoundation.h> // [ytz5-k5] CFNotificationCenter (Darwin prefschanged observer, below)
#import <math.h> // [hl23-kbphysical] finite dimension validation

// OMC scaffold helpers (shared, not part of this module).
extern BOOL OMCLiteActive(void);
extern NSInteger OMCCarWireless(void);
extern id OMCPref(NSString *key, id defaultValue);
// [ytz5-k5] the native-keyboard gate readers (defined in
// ABHostBMethods.m — the host's ONE reading point of the pref).
extern BOOL ABNativeKeyboardEnabled(void);
extern BOOL ABDrawnKeyboardEnabled(void);

// [hl8diag] Window observations are PROCESS-SCOPED; no local window
// match means BLIND about a remote CarPlayTemplateUIHost keyboard.
static BOOL ABHL8Trace(void) {
    return [OMCPref(@"hl8.unifiedDiag", @YES) boolValue];
}
static void ABHL8KeyboardWindows(NSString *source) {
    if (!ABHL8Trace()) return;
    NSUInteger count = 0;
    NSMutableString *sample = [NSMutableString string];
    // This diagnostic intentionally scans all SpringBoard windows, including
    // windows not attached to a scene; suppress only the iOS 15 deprecation.
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    for (UIWindow *w in [UIApplication sharedApplication].windows) {
        NSString *cls = NSStringFromClass(w.class);
        if ([cls containsString:@"Keyboard"] ||
            [cls containsString:@"InputSet"] ||
            [cls containsString:@"TextEffects"]) {
            count++;
            if (sample.length < 360)
                [sample appendFormat:@"%@:%@:%d;",
                    cls, NSStringFromCGRect(w.frame), (int)w.hidden];
        }
    }
#pragma clang diagnostic pop
    UIWindow *carWindow = [ABHost shared].carWindow;
    OMCLogWrite(@"AppBridge", [NSString stringWithFormat:
        @"[hl8diag] eye=kb-spring ev=window-scan source=%@ "
         "windows=%lu sample=%@ carWindow=%@ bounds=%@ "
         "scope=SpringBoard noMatchMeans=BLIND",
        source ?: @"-", (unsigned long)count, sample,
        carWindow ? NSStringFromClass(carWindow.class) : @"nil",
        carWindow ? NSStringFromCGRect(carWindow.bounds) : @"nil"]);
}

// ===========================================================================
// C helper sub_E6B8 — post ABChanOrientation to one app.
// fps rule (verified): orientation < 1 -> fps 0. Otherwise the pref
// "appBridgeFps"; if that is <= 0: 30 when OMCLiteActive(), else 30 when
// OMCCarWireless() == 1, else 0.
// "device" = max(orientation, 0).
// ===========================================================================
// [hl24-stable] One revision per bundle, bumped on every new frame
// request. Only the latest confirmed frame may publish geometry after
// the divider settles; old delayed callbacks are rejected.
static NSMutableDictionary<NSString *, NSNumber *> *AB24FrameRevisions(void) {
    static NSMutableDictionary<NSString *, NSNumber *> *revisions;
    static dispatch_once_t once;
    dispatch_once(&once, ^{ revisions = [NSMutableDictionary dictionary]; });
    return revisions;
}
static unsigned long long AB24FrameRevision(NSString *bundleID) {
    return [AB24FrameRevisions()[bundleID ?: @""] unsignedLongLongValue];
}
static unsigned long long AB24AdvanceFrameRevision(NSString *bundleID) {
    unsigned long long newRevision = AB24FrameRevision(bundleID) + 1;
    AB24FrameRevisions()[bundleID] = @(newRevision);
    return newRevision;
}
static NSString *AB24HostEpoch(void) {
    static NSString *epoch;
    static dispatch_once_t once;
    dispatch_once(&once, ^{ epoch = [NSUUID UUID].UUIDString; });
    return epoch;
}

void ABPostOrientationToApp(NSString *bundleID, NSInteger orientation) {
    if (!bundleID) return;
    NSInteger fps = 0;
    if (orientation >= 1) {
        fps = [OMCPref(@"appBridgeFps", @0) intValue];
        if (fps <= 0) {
            if (OMCLiteActive()) fps = 30;
            else fps = (OMCCarWireless() == 1) ? 30 : 0;
        }
    }
    // [hl23-kbphysical] Authoritative PHYSICAL pane geometry is pane.frame,
    // not box.bounds (which may still animate) or the app's logical UIWindow.
    // This packet extends the existing host->app orientation channel, it does
    // not introduce a second transport or a separate keyboard surface.
    ABPane *pane = [[ABHost shared] paneFor:bundleID];
    CGFloat physicalW = pane ? pane.frame.size.width : 0;
    // Only committed scene-box geometry is stable enough to describe
    // UIKit's keyboard viewport. During live drag, do not claim that
    // the app's FBScene already has the new size.
    if (!pane ||
        fabs(pane.sceneBox.width - pane.frame.size.width) > 1.0 ||
        fabs(pane.sceneBox.height - pane.frame.size.height) > 1.0)
        physicalW = 0;
    CGFloat physicalH = pane ? pane.frame.size.height : 0;
    if (physicalW == 0) physicalH = 0;
    double zoom = [[ABHost shared] zoom];
    CGFloat logicalW = (physicalW > 0 && isfinite(zoom) && zoom > 0.3)
        ? round(physicalW / zoom) : 0;
    CGFloat logicalH = (physicalH > 0 && isfinite(zoom) && zoom > 0.3)
        ? round(physicalH / zoom) : 0;
    if (!isfinite(physicalW) || !isfinite(logicalW) ||
        physicalW < 100 || physicalW > 1800 ||
        logicalW < 200 || logicalW > 1800 ||
        physicalW/logicalW < 0.45 || physicalW/logicalW > 2.1 ||
        physicalH < 100 || logicalH < 200 || logicalH > 1800) {
        physicalW = 0; logicalW = 0;
        physicalH = 0; logicalH = 0;
    }
    // [hl2] the gate value is read once so the payload field and
    // the acceptance log line below can never disagree.
    BOOL drawnKb = ABDrawnKeyboardEnabled();
    NSDictionary *info = @{
        @"kbPhysicalW": @(physicalW),
        @"kbLogicalW": @(logicalW),
        @"kbPhysicalH": @(physicalH),
        @"kbLogicalH": @(logicalH),
        @"kbGeometryRevision": @(AB24FrameRevision(bundleID)),
        @"kbHostEpoch": AB24HostEpoch(),
        @"orientation": @(orientation),
        @"device": @(MAX(orientation, 0)),
        @"fps": @((int)fps),
        // [ytz5-k5] RELAY POINT (the frame-info payload this host
        // posts to the app process): the native-keyboard gate,
        // carried to the app because the app must never read the
        // pref itself. 1 = drawn panel enabled, 0 = native.
        // [hl3] The host gate is hard-locked native (Nguyen's
        // direct order 2026-11-09 22:14, overriding the hl2 drawn
        // default), so this stamp is ALWAYS 0 in this build.
        // Stamped on EVERY post — launch, layout re-posts,
        // release — so the app's cache (ABOrientationBlock,
        // ABInApp.m) always converges to the host's current
        // reading, including after a mid-session flip re-post from
        // the prefschanged handler below.
        @"drawnKeyboard": @(drawnKb ? 1 : 0),
    };
    [[NSDistributedNotificationCenter defaultCenter]
        postNotificationName:ABChanOrientation object:bundleID userInfo:info];
    // [hl2] acceptance eye (GPT ruling §5 chain): the effective
    // pref/mode and the payload value actually sent, in one line.
    OMCLogWrite(@"AppBridge", [NSString stringWithFormat:
        @"[ytz5-k5] payload %@ drawnKeyboard=%d mode=%@",
        bundleID, drawnKb ? 1 : 0, drawnKb ? @"drawn" : @"native-locked-hl3"]);
    OMCLogWrite(@"AppBridge", [NSString stringWithFormat:
        @"[hl23-kbphysical] send bundle=%@ physicalW=%.1f logicalW=%.1f zoom=%.3f",
        bundleID, physicalW, logicalW, zoom]);
    if (ABHL8Trace())
        OMCLogWrite(@"AppBridge", [NSString stringWithFormat:
            @"[hl8diag] eye=kb-relay ev=mode-push bundle=%@ "
             "orientation=%ld drawn=%d nativeLock=%d",
            bundleID, (long)orientation, (int)drawnKb,
            (int)ABNativeKeyboardEnabled()]);
}

// C helper sub_BED4 — post ABChanState (object nil).
// Observed state values at the six call sites: "ready", "failed", "gone".
void ABPostStateToApp(NSString *state, NSString *identifier) {
    if (!identifier) return;
    [[NSDistributedNotificationCenter defaultCenter]
        postNotificationName:ABChanState object:nil
                    userInfo:@{@"identifier": identifier, @"state": state}];
}

// ===========================================================================
// [ytz4-hb] Hosted-keyboard session sync (GPT ytz4 ruling, item 1) —
// NEW machinery, not part of the original binary. ABKeyboardDispatch
// (below) is the management point where the car keyboard is actually
// opened/closed for an app; this TU therefore owns the ONE live
// session record (owning bundle + session id) and reports it to the
// car side on the appbridge.kbsync host->car channel, where the
// bridgewake owner keeps the authenticated kb truth per pane. The
// session id increments on every open; a close reports the id of
// the session it closes (0 when the closed app owns no recorded
// session). Every show/hide in the module — the dispatch, the
// per-app teardown in ABHostLaunch.m, the disconnect force-hide
// below — funnels through ABKbSyncNoteEvent so the record and the
// posts cannot diverge.
// ===========================================================================
static NSString *abKbLiveBundle;   // bundle owning the live kb session
static uint32_t  abKbLiveSession;  // its session id (0 = none live)
static uint32_t  abKbSessionCounter;

static void ABKbSyncPost(NSString *bundleID, BOOL active, uint32_t session) {
    [[NSDistributedNotificationCenter defaultCenter]
        postNotificationName:ABChanKbSync object:nil userInfo:@{
            @"identifier": bundleID,
            @"kbactive": @(active),
            @"kbsession": @(session),
            @"kbsource": @"host-keyboard-session",
        }];
    OMCLogWrite(@"AppBridge", [NSString stringWithFormat:
        @"[kb-sync] host post %@ active=%d session=%u source=host-keyboard-session",
        bundleID, (int)active, session]);
}

void ABKbSyncNoteEvent(NSString *bundleID, BOOL active) {
    if (!bundleID.length) return;
    // [ytz5-k5] native gate, funnel backstop: while native, a panel
    // OPEN claim must never leave this host — no panel event may
    // carry input-session truth in native mode (contract item 4);
    // the app's own kbstate report (bridgewake.v1.kbstate) is the
    // truth source then. NO events still pass: they are teardown /
    // invalidation (disconnect, app close, the flip-to-native
    // invalidation in ABNativeKbHandlePrefsChanged below), never a
    // claim that a session is active.
    if (active && ABNativeKeyboardEnabled()) {
        OMCLogWrite(@"AppBridge", [NSString stringWithFormat:
            @"[ytz5-k5] kb-sync ACTIVE bi chan o cong native (%@)", bundleID]);
        return;
    }
    uint32_t session = 0;
    if (active) {
        abKbSessionCounter++;
        abKbLiveBundle = [bundleID copy];
        abKbLiveSession = abKbSessionCounter;
        session = abKbLiveSession;
    } else if ([abKbLiveBundle isEqualToString:bundleID]) {
        session = abKbLiveSession;
        abKbLiveBundle = nil;
        abKbLiveSession = 0;
    }
    ABKbSyncPost(bundleID, active, session);
}

// Snapshot for an app whose pane (re)opened (called from ABOpenBlock):
// the app's kb truth as the host knows it at this moment — active
// only if the app owns the live session. Gives the car side an
// initial authenticated snapshot per assignment; anything not
// covered by an event or a snapshot stays UNKNOWN there by design.
static void ABKbSyncSnapshotForApp(NSString *bundleID) {
    if (!bundleID.length) return;
    // [ytz5-k5] native gate: a snapshot is a panel-derived kb claim
    // in either direction; while native it is not posted at all —
    // the assignment's kb record stays to be governed by the app's
    // kbstate report, not by the dead panel's bookkeeping.
    if (ABNativeKeyboardEnabled()) return;
    BOOL active = abKbLiveBundle != nil &&
                  [abKbLiveBundle isEqualToString:bundleID];
    ABKbSyncPost(bundleID, active, active ? abKbLiveSession : 0);
}

// ===========================================================================
// [ytz5-k5] Gate flip handling (host side). The observer registration
// lives in ABSpringBoardReady below, on the YZPrefsChangedCallback
// pattern of ABYTZoom.m (Darwin prefschanged -> hop to main queue ->
// re-read the pref there). Two duties on a flip:
//   * to NATIVE while a drawn-panel session is live: close the
//     panel through the host's EXISTING hide path — the disconnect
//     shape of ABCarPlayChanged below (capture the live bundle,
//     force-hide, funnel NO). That one NO is snapshot INVALIDATION
//     at the transition instant (CHANGE_MAP M2 (d)): without it the
//     owner would keep re-emitting the panel's stale ACTIVE. It is
//     not an ongoing truth source — from this moment the dispatch
//     below shows nothing and funnels nothing for the panel, and
//     the apps' kbstate reports govern. The panel SOURCE is
//     disabled by the gate checks in ABKeyboardDispatch /
//     ABKbSyncNoteEvent / ABKbSyncSnapshotForApp themselves, which
//     re-read the pref on every event, so no latch is needed here.
//   * BOTH directions: relay the fresh gate value to every hosted
//     app by re-posting its frame info (ABPostOrientationToApp
//     stamps drawnKeyboard). A flip to DRAWN never shows a panel
//     here — the panel may only return on an app's next keyboard
//     publish, which the app re-arms from its next responder event.
// ===========================================================================
static void ABNativeKbHandlePrefsChanged(void) {
    BOOL native = ABNativeKeyboardEnabled();
    if (native) {
        NSString *kbBundle = abKbLiveBundle;
        if (kbBundle) {
            // Invalidate legacy panel session metadata, not UIKit windows.
            ABKbSyncNoteEvent(kbBundle, NO);
        }
    }
    for (ABPane *pane in [[ABHost shared].panes copy]) {
        // Only apps under a forced orientation consume the payload's
        // keyboard machinery at all (ABOrientationBlock's gates key
        // off ABForcedOrientation >= 1); a pane without one is left
        // alone rather than being handed a release-shaped post.
        if (pane.orientation >= 1)
            ABPostOrientationToApp(pane.bundleID, pane.orientation);
    }
    OMCLogWrite(@"AppBridge", [NSString stringWithFormat:
        @"[ytz5-k5] cong ban phim: %@ (prefschanged; hl3 native khoa cung — che do khong do pref quyet dinh)",
        native ? @"native" : @"drawn"]);
}

static void ABNativeKbPrefsChangedCallback(CFNotificationCenterRef center,
                                           void *observer, CFStringRef name,
                                           const void *object,
                                           CFDictionaryRef userInfo) {
    dispatch_async(dispatch_get_main_queue(), ^{ ABNativeKbHandlePrefsChanged(); });
}

// ===========================================================================
// Registrar — sub_7004, replacement for
// -[SpringBoard applicationDidFinishLaunching:]. Calls the original IMP
// (slot 0x3E9F0) first, logs "SpringBoard ready", then registers:
//   NSDistributed observers (object nil, main queue) for open / frame /
//   shield / close / closeall / knobs — block literals at
//   0x34690..0x34730, invokes sub_783C / sub_8274 / sub_8C7C / sub_8DF0 /
//   sub_8FD4 / sub_9144 (open/close/closeall/knobs are module A's handlers;
//   frame and shield are reproduced below).
//   notify_register_dispatch (main queue) for the two Darwin state
//   channels: apporient -> block sub_92B4, keyboard -> block sub_93B0.
//   A local NSNotificationCenter observer for
//   "CarPlayIsConnectedDidChange" -> block sub_958C.
// ===========================================================================
static void ABFrameBlock(NSNotification *note);   // sub_8274, below
static void ABShieldBlock(NSNotification *note);  // sub_8C7C, below
static void ABOpenBlock(NSNotification *note);    // sub_783C, below
static void ABCloseBlock(NSNotification *note);   // sub_8DF0, below
static void ABCloseAllBlock(NSNotification *note);// sub_8FD4, below
static void ABKnobsBlock(NSNotification *note);   // sub_9144, below

// Original IMP of -[SpringBoard applicationDidFinishLaunching:], stored
// by the substrate install in AppBridgeEntry.m (slot 0x3E9F0 in the
// original). Non-static: the installer in AppBridgeEntry.m takes its
// address. [hotfix: was never wired — ABSpringBoardReady could not call
// the original at all]
IMP orig_SBDidFinishLaunching; // 0x3E9F0

void ABSpringBoardReady(id self, SEL _cmd, id application) {
    // sub_7004 verified order (disasm/registrar_7004.txt): the original
    // IMP (loaded from slot 0x3E9F0) is called FIRST, at 0x7028-0x703C,
    // before the "SpringBoard ready" log (0x706C) and every
    // registration below.
    ((void (*)(id, SEL, id))orig_SBDidFinishLaunching)(self, _cmd, application);
    // FIX-ROUND2 (audit item 4): registration body runs only once; the
    // orig call above stays first and unconditional on every call.
    static BOOL ABRegistrarRegistered;
    if (!ABRegistrarRegistered) {
        ABRegistrarRegistered = YES;
    OMCLogWrite(@"AppBridge", [NSString stringWithFormat:@"SpringBoard ready"]);
    NSDistributedNotificationCenter *center = [NSDistributedNotificationCenter defaultCenter];
    NSOperationQueue *queue = [NSOperationQueue mainQueue];
    // Registration order as in sub_7004: open, frame, shield, close,
    // closeall, knobs.
    [center addObserverForName:ABChanOpen object:nil queue:queue
                    usingBlock:^(NSNotification *n) { ABOpenBlock(n); }];
    [center addObserverForName:ABChanFrame object:nil queue:queue
                    usingBlock:^(NSNotification *n) { ABFrameBlock(n); }];
    [center addObserverForName:ABChanShield object:nil queue:queue
                    usingBlock:^(NSNotification *n) { ABShieldBlock(n); }];
    [center addObserverForName:ABChanClose object:nil queue:queue
                    usingBlock:^(NSNotification *n) { ABCloseBlock(n); }];
    [center addObserverForName:ABChanCloseAll object:nil queue:queue
                    usingBlock:^(NSNotification *n) { ABCloseAllBlock(n); }];
    [center addObserverForName:ABChanKnobs object:nil queue:queue
                    usingBlock:^(NSNotification *n) { ABKnobsBlock(n); }];
    static int apporientToken; // Original apporient transport retained.
    notify_register_dispatch(ABNotifyAppOrient, &apporientToken,
                             dispatch_get_main_queue(),
                             ^(int token) { ABAppOrientDispatch(token); });
    // [hl40-original-keyboard] Restore the original keyboard-state receiver.
    static int keyboardToken;
    notify_register_dispatch(ABNotifyKeyboard, &keyboardToken,
                             dispatch_get_main_queue(),
                             ^(int token) { ABKeyboardDispatch(token); });
    // [ytz5-k5] native-keyboard gate: watch the shared prefschanged
    // signal (ABYTZoom registration pattern) so a mid-session flip
    // closes a live panel and re-relays drawnKeyboard to the apps.
    CFNotificationCenterAddObserver(
        CFNotificationCenterGetDarwinNotifyCenter(), NULL,
        ABNativeKbPrefsChangedCallback,
        CFSTR("com.anlai.omnicar/prefschanged"), NULL,
        CFNotificationSuspensionBehaviorDeliverImmediately);
    [[NSNotificationCenter defaultCenter]
        addObserverForName:@"CarPlayIsConnectedDidChange" object:nil queue:queue
                usingBlock:^(NSNotification *n) { ABCarPlayChanged(n); }];
    if (ABHL8Trace()) {
        NSNotificationCenter *local = [NSNotificationCenter defaultCenter];
        for (NSString *name in @[UIKeyboardWillShowNotification,
                                  UIKeyboardDidShowNotification,
                                  UIKeyboardDidChangeFrameNotification,
                                  UIKeyboardWillHideNotification]) {
            [local addObserverForName:name object:nil queue:queue
                         usingBlock:^(NSNotification *note) {
                CGRect f = [note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
                OMCLogWrite(@"AppBridge", [NSString stringWithFormat:
                    @"[hl8diag] eye=kb-spring ev=notification name=%@ "
                     "frame=%@ screen=%@",
                    note.name, NSStringFromCGRect(f),
                    NSStringFromCGRect([UIScreen mainScreen].bounds)]);
                ABHL8KeyboardWindows(note.name);
            }];
        }
        OMCLogWrite(@"AppBridge",
            @"[hl8diag] eye=spring ev=installed schema=1 "
             "domains=kb-mode,kb-window,layout-recv,layout-applied");
        ABHL8KeyboardWindows(@"install");
    }
    } // ABRegistrarRegistered once-guard
}

// ===========================================================================
// Darwin consumers. Both decode the packed states proven in AppBridgeB.h.
// ===========================================================================
// sub_92B4 — apporient consumer.
void ABAppOrientDispatch(int token) {
    uint64_t state = 0;
    notify_get_state(token, &state);
    [[ABHost shared] appWithHash:(state >> 24)
              changedOrientation:(state & 0xFF)
                 supportedMask:(NSUInteger)((state >> 8) & 0xFFFF)];
}

// [hl40-original-keyboard] The original Darwin keyboard consumer (sub_93B0).
// Only hashes of panes held by ABHost are eligible; native CarPlay apps
// never enter this registry and keep their UIKit/CarPlay keyboard.
void ABKeyboardDispatch(int token) {
    @try {
        if (!ABDrawnKeyboardEnabled()) return;
        uint64_t state = 0;
        if (notify_get_state(token, &state) != NOTIFY_STATUS_OK) return;
        NSString *bundleID = [[ABHost shared] bundleForHash:(state >> 24)];
        if (!bundleID.length || ![[ABHost shared] paneFor:bundleID]) {
            OMCLogWrite(@"AppBridge", [NSString stringWithFormat:
                @"[hl40-original-keyboard] ignore non-hosted keyboard hash=%llu",
                (unsigned long long)(state >> 24)]);
            return;
        }
        ABKeyboard *kb = [ABKeyboard shared];
        if ((state & 1u) != 0) {
            NSString *oldOwner = [kb.app copy];
            if (oldOwner.length && ![oldOwner isEqualToString:bundleID])
                ABKbSyncNoteEvent(oldOwner, NO);
            [kb showForApp:bundleID
             keyboardType:(UIKeyboardType)((state >> 1) & 0x7Fu)
               returnType:(UIReturnKeyType)((state >> 8) & 0xFFu)];
            if ([kb.app isEqualToString:bundleID] && kb.panel.superview &&
                (!abKbLiveSession || ![abKbLiveBundle isEqualToString:bundleID]))
                ABKbSyncNoteEvent(bundleID, YES);
        } else {
            [kb hideForApp:bundleID];
            ABKbSyncNoteEvent(bundleID, NO);
        }
    } @catch (NSException *ex) {
        OMCLogWrite(@"AppBridge",
            [NSString stringWithFormat:@"[hl40-original-keyboard] dispatch error %@", ex]);
    }
}

// ===========================================================================
// ===========================================================================
// sub_958C — CarPlayIsConnectedDidChange. Determines connection from
// [AVExternalDevice currentCarPlayExternalDevice] (resolved dynamically,
// ABMissingSelector fallback). On disconnect: hide the car keyboard and
// tear down all panes via -[ABHost carDisconnected].
// ===========================================================================
void ABCarPlayChanged(NSNotification *note) {
    Class cls = objc_getClass("AVExternalDevice");
    SEL sel = NSSelectorFromString(@"currentCarPlayExternalDevice");
    id device = nil;
    if ([cls respondsToSelector:sel])
        device = ((id (*)(id, SEL))objc_msgSend)(cls, sel);
    else
        // [integration phase 2; backported to src in phase 3]
        // ABMissingSelector returns void (proven from its 468-byte body;
        // see ABMissingSelector.m) — the binary's call site zeroes the
        // result itself, so `device` stays nil here instead of receiving
        // the function's (non-)return value.
        ABMissingSelector(cls, @"currentCarPlayExternalDevice");
    if (!device) {
        // [ytz4-hb] the force-hide below closes whichever session is
        // live; report that close before the record is torn down.
        NSString *kbBundle = abKbLiveBundle;
        // [hl40-original-keyboard] Force-hide the original panel before
        // ABHost frees the scene; never leave its overlay on reconnect.
        [[ABKeyboard shared] hideForApp:nil];
        if (kbBundle) ABKbSyncNoteEvent(kbBundle, NO);
        [[ABHost shared] carDisconnected];
    }
    // Connected case (device != nil): the binary does literally nothing
    // further — the tail is only the release of `device` and the return
    // (plus the exception-unwind landing pad). Verified over the full
    // body in remediation round 2: 252/252 B, 63 insns,
    // disasm/rem4_tail_958c.txt.
}

// ===========================================================================
// NSDistributed consumers
// ===========================================================================
// [hl25-host-surface] Read-only host projection at a committed divider
// revision. Correlate with the in-app [hl25-kb-surface] probe by time/bundle.
// This process cannot prove remote UIKit keyboard z-order.
static void AB25HostSurface(ABPane *pane, NSString *bundle,
                            unsigned long long revision) {
    if (!pane) return;
    @try {
        UIView *box = (UIView *)pane.box;
        UIView *appView = ((UIViewController *)pane.appViewController).view;
        if (!box || !appView) return;
        // Cross-window convertRect is not a reliable measurement of
        // physical pane clipping. Mark it UNKNOWN instead of inventing
        // a comparable coordinate space.
        BOOL sameWindow = box.window && appView.window &&
                          box.window == appView.window;
        NSMutableArray<NSString *> *trace = [NSMutableArray array];
        NSUInteger depth = 0;
        for (UIView *v = appView; v && depth < 12; v = v.superview, depth++) {
            NSString *projection = sameWindow
                ? NSStringFromCGRect([v convertRect:v.bounds toView:box])
                : @"UNKNOWN-cross-window";
            [trace addObject:[NSString stringWithFormat:
                @"%@ rectInBox=%@ clip=%d alpha=%.2f",
                NSStringFromClass(v.class), projection,
                (int)(v.clipsToBounds || v.layer.masksToBounds),
                (double)v.alpha]];
        }
        OMCLogWrite(@"AppBridge", [NSString stringWithFormat:
            @"[hl25-host-surface] bundle=%@ revision=%llu box=%@ "
             "app=%@ boxClip=%d appTransform=%@ winLevel=%.1f "
             "boxWindowSame=%d chain=%@",
            bundle, revision, NSStringFromCGRect(box.bounds),
            NSStringFromCGRect(appView.frame),
            (int)(box.clipsToBounds || box.layer.masksToBounds),
            NSStringFromCGAffineTransform(appView.transform),
            (double)appView.window.windowLevel,
            (int)sameWindow,
            [trace componentsJoinedByString:@" / "]]);
    } @catch (NSException *e) {
        OMCLogWrite(@"AppBridge", [NSString stringWithFormat:
            @"[hl25-host-surface] bundle=%@ revision=%llu exception=%@",
            bundle, revision, e.name]);
    }
}

// sub_8274 — frame consumer. One notification carries the whole geometry
// state for one app; every field is applied through ABHost setters:
//   x,y,w,h (double) + identifier + live,handle (bool) + pt,pl,pb,pr
//     -> setFrame:forApp:live:handle:passInsets:
//   bar (bool), pop (int), popDim (bool), single (bool)
//     -> setBarVisible:pop:dim:single:forApp:
//   ox,oy,ow,oh -> setHole:forApp:
//   r (double), corners (uint64) -> setCornerRadius:corners:forApp:
//   hx (double) -> setHandleOffset:forApp:
//   front (bool) -> setFront:forApp:
//   ax,ay,aw,ah (only when aw > 0) -> setCarAppArea:
static void ABFrameBlock(NSNotification *note) {
    @try {
    NSDictionary *u = note.userInfo;
    ABHost *host = [ABHost shared];
    NSString *app = u[@"identifier"];
    CGRect frame = CGRectMake([u[@"x"] doubleValue], [u[@"y"] doubleValue],
                              [u[@"w"] doubleValue], [u[@"h"] doubleValue]);
    // Diagnostics are sampled on each *changed* incoming frame.
    static NSMutableDictionary *hl8PreviousFrame;
    if (!hl8PreviousFrame)
        hl8PreviousFrame = [NSMutableDictionary dictionary];
    NSString *hl8Bundle = app ?: @"";
    NSNumber *hl8Seq = u[@"hl8seq"];
    NSValue *hl8Prev = hl8PreviousFrame[hl8Bundle];
    BOOL hl8Changed = !hl8Prev ||
        !CGRectEqualToRect([hl8Prev CGRectValue], frame);
    BOOL hl8ShouldLog = ABHL8Trace() && hl8Changed;
    if (hl8Changed)
        hl8PreviousFrame[hl8Bundle] = [NSValue valueWithCGRect:frame];
    if (hl8ShouldLog)
        OMCLogWrite(@"AppBridge", [NSString stringWithFormat:
            @"[hl8diag] eye=layout ev=frame-recv seq=%llu bundle=%@ "
             "requested=%@ live=%d split=%d faded=%d hasPane=%d",
            (unsigned long long)[hl8Seq unsignedLongLongValue],
            hl8Bundle, NSStringFromCGRect(frame),
            (int)[u[@"live"] boolValue], (int)[u[@"split"] boolValue],
            (int)[u[@"fade"] boolValue], (int)([host paneFor:app] != nil)]);
    UIEdgeInsets insets = UIEdgeInsetsMake([u[@"pt"] doubleValue], [u[@"pl"] doubleValue],
                                           [u[@"pb"] doubleValue], [u[@"pr"] doubleValue]);
    [host setFrame:frame forApp:app live:[u[@"live"] boolValue]
            handle:[u[@"handle"] boolValue] passInsets:insets];
    // [hl24-stable] Hold the geometry packet until the LAST frame of
    // the divider has committed its sceneBox. Reject stale timers even
    // when the old pane object still exists. This path runs independent
    // of the optional HL8 diagnostic logger.
    if (app.length && isfinite(frame.size.width) &&
        isfinite(frame.size.height) && frame.size.width >= 100 &&
        frame.size.height >= 100) {
        unsigned long long revision = AB24AdvanceFrameRevision(app);
        NSString *bundle = [app copy];
        ABPane *captured = [host paneFor:bundle];
        CGRect expected = frame;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 350000000LL),
                       dispatch_get_main_queue(), ^{
            ABPane *current = [[ABHost shared] paneFor:bundle];
            BOOL valid = AB24FrameRevision(bundle) == revision &&
                current && current == captured && current.orientation >= 1 &&
                CGRectEqualToRect(current.frame, expected) &&
                fabs(current.sceneBox.width - expected.size.width) <= 1.0 &&
                fabs(current.sceneBox.height - expected.size.height) <= 1.0;
            if (!valid) return;
            ABPostOrientationToApp(bundle, current.orientation);
            OMCLogWrite(@"AppBridge", [NSString stringWithFormat:
                @"[hl24-stable] commit bundle=%@ revision=%llu paneW=%.1f",
                bundle, revision, expected.size.width]);
            AB25HostSurface(current, bundle, revision);
        });
    }
    if (hl8ShouldLog) {
        ABPane *p = [host paneFor:app];
        OMCLogWrite(@"AppBridge", [NSString stringWithFormat:
            @"[hl8diag] eye=layout ev=frame-applied seq=%llu "
             "bundle=%@ pane=%@ box=%@ sceneBox=%@ view=%@",
            (unsigned long long)[hl8Seq unsignedLongLongValue], hl8Bundle,
            p ? NSStringFromCGRect(p.frame) : @"nil",
            p.box ? NSStringFromCGRect(((UIView *)p.box).frame) : @"nil",
            p ? NSStringFromCGSize(p.sceneBox) : @"nil",
            p.appViewController
                ? NSStringFromCGRect(((UIViewController *)p.appViewController).view.frame)
                : @"nil"]);
        NSString *joinedBundle = [hl8Bundle copy];
        unsigned long long joinedSeq = [hl8Seq unsignedLongLongValue];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 350000000LL),
                       dispatch_get_main_queue(), ^{
            @try {
                ABPane *settled = [[ABHost shared] paneFor:joinedBundle];
                OMCLogWrite(@"AppBridge", [NSString stringWithFormat:
                    @"[hl8diag] eye=layout ev=frame-settled seq=%llu "
                     "bundle=%@ sameOwner=%d expected=%@ pane=%@ "
                     "box=%@ sceneBox=%@ view=%@",
                    joinedSeq, joinedBundle, (int)(settled && settled == p),
                    NSStringFromCGRect(frame),
                    settled ? NSStringFromCGRect(settled.frame) : @"nil",
                    settled.box ? NSStringFromCGRect(((UIView *)settled.box).frame) : @"nil",
                    settled ? NSStringFromCGSize(settled.sceneBox) : @"nil",
                    settled.appViewController
                        ? NSStringFromCGRect(((UIViewController *)settled.appViewController).view.frame)
                        : @"nil"]);
                ABHL8KeyboardWindows(@"frame-settled");
            } @catch (NSException *ex) {
                OMCLogWrite(@"AppBridge", [NSString stringWithFormat:
                    @"[hl8diag] eye=layout ev=settle-exception %@", ex.name]);
            }
        });
    }
    [host setBarVisible:[u[@"bar"] boolValue] pop:[u[@"pop"] intValue]
                    dim:[u[@"popDim"] boolValue] single:[u[@"single"] boolValue] forApp:app];
    CGRect hole = CGRectMake([u[@"ox"] doubleValue], [u[@"oy"] doubleValue],
                             [u[@"ow"] doubleValue], [u[@"oh"] doubleValue]);
    [host setHole:hole forApp:app];
    [host setCornerRadius:[u[@"r"] doubleValue]
                  corners:(NSUInteger)[u[@"corners"] unsignedLongLongValue] forApp:app];
    [host setHandleOffset:[u[@"hx"] doubleValue] forApp:app];
    [host setFront:[u[@"front"] boolValue] forApp:app];
    if ([u[@"aw"] doubleValue] > 0) {
        host.carAppArea = CGRectMake([u[@"ax"] doubleValue], [u[@"ay"] doubleValue],
                                     [u[@"aw"] doubleValue], [u[@"ah"] doubleValue]);
    }
    } @catch (NSException *e) {
        OMCLogWrite(@"AppBridge", [NSString stringWithFormat:@"frame loi %@", e]);
    }
}

// sub_8C7C — shield consumer: {on} -> setShieldAll:.
static void ABShieldBlock(NSNotification *note) {
    @try {
        [[ABHost shared] setShieldAll:[note.userInfo[@"on"] boolValue]];
    } @catch (NSException *e) {
        OMCLogWrite(@"AppBridge", [NSString stringWithFormat:@"shield loi %@", e]);
    }
}

// sub_783C — open consumer. Ported from module A's verified (key-by-key)
// reconstruction in src/AppBridgeA/src/ABChannels.m when that file's
// duplicate SpringBoard installer was neutralised (see the note there):
// [ABHost openApp:frame:] runs FIRST; every other key group is applied
// afterwards, in the order below. Keys (all optional except identifier):
//   identifier; x,y,w,h; pt,pl,pb,pr -> setPassInsets:forApp:;
//   bar,pop,popDim,single -> setBarVisible:pop:dim:single:forApp:;
//   ox,oy,ow,oh -> setHole:forApp:; r,corners -> setCornerRadius:;
//   hx -> setHandleOffset:; front -> setFront:; ax,ay,aw,ah -> carAppArea.
static void ABOpenBlock(NSNotification *note) {
    @try {
    NSDictionary *u = note.userInfo;
    NSString *app = u[@"identifier"];
    CGRect frame = CGRectMake([u[@"x"] doubleValue], [u[@"y"] doubleValue],
                              [u[@"w"] doubleValue], [u[@"h"] doubleValue]);
    [[ABHost shared] openApp:app frame:frame];
    ABHost *host = [ABHost shared];
    // FIX-ROUND2 (audit-registrar item 4): no key-presence guards in the
    // binary — setter groups fire unconditionally; a missing key yields
    // zeroed values via the extraction below.
    [host setPassInsets:UIEdgeInsetsMake([u[@"pt"] doubleValue],
                                         [u[@"pl"] doubleValue],
                                         [u[@"pb"] doubleValue],
                                         [u[@"pr"] doubleValue])
                 forApp:app];
    [host setBarVisible:[u[@"bar"] boolValue]
                    pop:[u[@"pop"] intValue]
                    dim:[u[@"popDim"] boolValue]
                 single:[u[@"single"] boolValue]
                 forApp:app];
    [host setHole:CGRectMake([u[@"ox"] doubleValue], [u[@"oy"] doubleValue],
                             [u[@"ow"] doubleValue], [u[@"oh"] doubleValue])
           forApp:app];
    [host setCornerRadius:[u[@"r"] doubleValue]
                  corners:[u[@"corners"] unsignedLongLongValue]
                   forApp:app];
    [host setHandleOffset:[u[@"hx"] doubleValue] forApp:app];
    [host setFront:[u[@"front"] boolValue] forApp:app];
    if ([u[@"aw"] doubleValue] > 0)
        host.carAppArea = CGRectMake([u[@"ax"] doubleValue], [u[@"ay"] doubleValue],
                                     [u[@"aw"] doubleValue], [u[@"ah"] doubleValue]);
    // [ytz4-hb] initial kb snapshot for the (re)opened app: the car
    // side's per-assignment kb record starts UNKNOWN and this is
    // its first authenticated value.
    ABKbSyncSnapshotForApp(app);
    } @catch (NSException *e) {
        OMCLogWrite(@"AppBridge", [NSString stringWithFormat:@"open loi %@", e]);
    }
}

// sub_8DF0 — close consumer: {identifier, terminate} -> closeApp:terminate:.
static void ABCloseBlock(NSNotification *note) {
    @try {
        [[ABHost shared] closeApp:note.userInfo[@"identifier"]
                        terminate:[note.userInfo[@"terminate"] boolValue]];
    } @catch (NSException *e) {
        OMCLogWrite(@"AppBridge", [NSString stringWithFormat:@"close loi %@", e]);
    }
}

// sub_8FD4 — closeall consumer: {except} -> closeAllExcept:.
static void ABCloseAllBlock(NSNotification *note) {
    @try {
        [[ABHost shared] closeAllExcept:note.userInfo[@"except"]];
    } @catch (NSException *e) {
        OMCLogWrite(@"AppBridge", [NSString stringWithFormat:@"closeall loi %@", e]);
    }
}

// sub_9144 — knobs consumer: {knobs: NSArray} -> setKnobs:.
static void ABKnobsBlock(NSNotification *note) {
    @try {
        [[ABHost shared] setKnobs:note.userInfo[@"knobs"]];
    } @catch (NSException *e) {
        OMCLogWrite(@"AppBridge", [NSString stringWithFormat:@"knobs loi %@", e]);
    }
}

// ===========================================================================
// SpringBoard lifecycle hooks
// ===========================================================================
// Non-static: the installers in AppBridgeEntry.m take these addresses.
// [hotfix: they were static here while AppBridgeEntry.m passed NULL to
// MSHookMessageEx/MSHookFunction, so every call through them below was a
// call through a NULL pointer]
IMP orig_SBSuspended;   // 0x3E9F8
IMP orig_FBSceneUpdate; // 0x3EA00
IMP orig_SBSceneView;   // 0x3EA08
void (*orig_ScreenBlanked)(BOOL); // 0x3EA10

// sub_72BC — -[SBSuspendedUnderLockManager
// _shouldBeBackgroundUnderLockForScene:withSettings:]: a hosted app is
// NEVER background-under-lock: result = orig && !hostsApp(scene's app).
// Exceptions fail open to YES (the @catch tail sets the result to 1).
BOOL ABHook_SBSuspended(id self, SEL _cmd, id scene, id settings) { // [integration phase 1; backported to src in phase 3] return type corrected void->BOOL: every return in the body is BOOL and orig_SBSuspended is cast to a BOOL-returning pointer; the hooked method returns BOOL
    BOOL orig = ((BOOL (*)(id, SEL, id, id))orig_SBSuspended)(self, _cmd, scene, settings);
    if (!orig) return NO;
    @try {
        id process = [scene valueForKey:@"clientProcess"]; // via NSSelectorFromString in the original
        NSString *bundleID = [process valueForKey:@"bundleIdentifier"];
        if (bundleID && [[ABHost shared] hostsApp:bundleID]) return NO;
    } @catch (NSException *e) { return YES; }
    return orig;
}

// sub_74B4 — -[FBScene updateSettings:withTransitionContext:completion:]:
// when ABHost hosts at least one app, and this scene belongs to a hosted
// app, and the new settings' isForeground is NO, the update is SWALLOWED
// (the original is never called): the hosted scene never learns it was
// backgrounded. A missing isForeground selector also swallows. Exceptions
// fail open (the original is called from the @catch tail).
void ABHook_FBSceneUpdateSettings(FBScene *self, SEL _cmd, id settings, id ctx, ABFBSceneUpdateCompletion completion) {
    BOOL swallow = NO;
    if ([[ABHost shared] count] > 0) {
        @try {
            id process = [self valueForKey:@"clientProcess"];
            NSString *bundleID = [process valueForKey:@"bundleIdentifier"];
            if (bundleID && [[ABHost shared] hostsApp:bundleID]) {
                SEL fg = NSSelectorFromString(@"isForeground");
                if (![settings respondsToSelector:fg]) {
                    ABMissingSelector(settings, @"isForeground");
                    swallow = YES;
                } else if (!((BOOL (*)(id, SEL))objc_msgSend)(settings, fg)) {
                    swallow = YES;
                }
            }
        } @catch (NSException *e) { swallow = NO; }
    }
    if (!swallow)
        ((void (*)(id, SEL, id, id, ABFBSceneUpdateCompletion))orig_FBSceneUpdate)(self, _cmd, settings, ctx, completion);
}

// sub_7764 — -[SBSceneView _updateReferenceSize:andOrientation:]:
// clamps the orientation argument: values > 4 become 3.
void ABHook_SBSceneViewRefSize(id self, SEL _cmd, CGSize size, NSInteger orientation) {
    if (orientation > 4) orientation = 3;
    ((void (*)(id, SEL, CGSize, NSInteger))orig_SBSceneView)(self, _cmd, size, orientation);
}

// sub_777C — BKSDisplayServicesSetScreenBlanked hook: when a blank is
// requested while panes are hosted, the blank is applied and then REVERSED
// 1.0 s later (the delayed block sub_9688 calls orig(0)); the car display
// does not stay asleep while apps are hosted.
// dispatch_time constant verified: 0x3B9ACA00 = 1,000,000,000 ns.
void ABHook_ScreenBlanked(BOOL blanked) {
    if (blanked == 1 && [[ABHost shared] count] > 0) {
        orig_ScreenBlanked(1);
        dispatch_after(dispatch_time(0, 1000000000), dispatch_get_main_queue(), ^{
            orig_ScreenBlanked(0);
        });
        return;
    }
    orig_ScreenBlanked(blanked);
}

// ===========================================================================
// FIX-ROUND2 (audit items 1+2+3+5) — single SpringBoard hook installer
// (ctor 0x6E08 body, moved here from AppBridgeEntry.m's ABHostCtor).
// Idempotent: ABHooksInstalledOnce is set BEFORE installing, so a
// re-entrant call cannot double-chain. Each ObjC hook is verified before
// MSHookMessageEx: class must exist, method must exist, and the method's
// type encoding must structurally match the §4 table (return-type char
// plus argument structure after self/_cmd; argument offsets and BOOL
// spelling 'B' vs 'c' are not hard-gated). Any failure logs a diagnostic
// via OMCLogWrite and skips only that hook.
// ===========================================================================
static BOOL ABHooksInstalledOnce;

void ABInstallSpringBoardHooks(void) {
    if (ABHooksInstalledOnce) return;
    ABHooksInstalledOnce = YES;

    // -[SpringBoard applicationDidFinishLaunching:] -> ABSpringBoardReady
    // §4: void, 1 object arg after self/_cmd.
    {
        SEL sel = @selector(applicationDidFinishLaunching:);
        Class cls = objc_getClass("SpringBoard");
        if (!cls) {
            OMCLogWrite(@"AppBridge", [NSString stringWithFormat:@"hook skip: khong thay class %s", "SpringBoard"]);
        } else {
            Method m = class_getInstanceMethod(cls, sel);
            if (!m) {
                OMCLogWrite(@"AppBridge", [NSString stringWithFormat:@"hook skip: khong thay method %s %s", "SpringBoard", sel_getName(sel)]);
            } else {
                const char *enc = method_getTypeEncoding(m);
                char ret[32] = {0}; method_getReturnType(m, ret, sizeof(ret));
                char a0[64] = {0};
                if (method_getNumberOfArguments(m) > 2) method_getArgumentType(m, 2, a0, sizeof(a0));
                BOOL ok = (ret[0] == 'v' && method_getNumberOfArguments(m) == 3 && a0[0] == '@');
                if (!ok) {
                    OMCLogWrite(@"AppBridge", [NSString stringWithFormat:@"hook skip: type encoding khong khop %s %s: %s", "SpringBoard", sel_getName(sel), enc ? enc : "(null)"]);
                } else {
                    MSHookMessageEx(cls, sel, (IMP)ABSpringBoardReady, (IMP *)&orig_SBDidFinishLaunching); // orig IMP stored at 0x3E9F0 in the original
                }
            }
        }
    }

    // -[SBSuspendedUnderLockManager _shouldBeBackgroundUnderLockForScene:withSettings:] -> ABHook_SBSuspended
    // §4: BOOL ('B' or 'c'), 2 object args after self/_cmd.
    {
        SEL sel = NSSelectorFromString(@"_shouldBeBackgroundUnderLockForScene:withSettings:");
        Class cls = objc_getClass("SBSuspendedUnderLockManager");
        if (!cls) {
            OMCLogWrite(@"AppBridge", [NSString stringWithFormat:@"hook skip: khong thay class %s", "SBSuspendedUnderLockManager"]);
        } else {
            Method m = class_getInstanceMethod(cls, sel);
            if (!m) {
                OMCLogWrite(@"AppBridge", [NSString stringWithFormat:@"hook skip: khong thay method %s %s", "SBSuspendedUnderLockManager", sel_getName(sel)]);
            } else {
                const char *enc = method_getTypeEncoding(m);
                char ret[32] = {0}; method_getReturnType(m, ret, sizeof(ret));
                char a0[64] = {0}, a1[64] = {0};
                if (method_getNumberOfArguments(m) > 2) method_getArgumentType(m, 2, a0, sizeof(a0));
                if (method_getNumberOfArguments(m) > 3) method_getArgumentType(m, 3, a1, sizeof(a1));
                BOOL ok = ((ret[0] == 'B' || ret[0] == 'c') && method_getNumberOfArguments(m) == 4 && a0[0] == '@' && a1[0] == '@');
                if (!ok) {
                    OMCLogWrite(@"AppBridge", [NSString stringWithFormat:@"hook skip: type encoding khong khop %s %s: %s", "SBSuspendedUnderLockManager", sel_getName(sel), enc ? enc : "(null)"]);
                } else {
                    MSHookMessageEx(cls, sel, (IMP)ABHook_SBSuspended, (IMP *)&orig_SBSuspended); // orig at 0x3E9F8
                }
            }
        }
    }

    // -[FBScene updateSettings:withTransitionContext:completion:] -> ABHook_FBSceneUpdateSettings
    // §4: void, 3 args after self/_cmd, the 3rd a block ('@?' or '@').
    {
        SEL sel = @selector(updateSettings:withTransitionContext:completion:);
        Class cls = objc_getClass("FBScene");
        if (!cls) {
            OMCLogWrite(@"AppBridge", [NSString stringWithFormat:@"hook skip: khong thay class %s", "FBScene"]);
        } else {
            Method m = class_getInstanceMethod(cls, sel);
            if (!m) {
                OMCLogWrite(@"AppBridge", [NSString stringWithFormat:@"hook skip: khong thay method %s %s", "FBScene", sel_getName(sel)]);
            } else {
                const char *enc = method_getTypeEncoding(m);
                char ret[32] = {0}; method_getReturnType(m, ret, sizeof(ret));
                char a0[64] = {0}, a1[64] = {0}, a2[64] = {0};
                if (method_getNumberOfArguments(m) > 2) method_getArgumentType(m, 2, a0, sizeof(a0));
                if (method_getNumberOfArguments(m) > 3) method_getArgumentType(m, 3, a1, sizeof(a1));
                if (method_getNumberOfArguments(m) > 4) method_getArgumentType(m, 4, a2, sizeof(a2));
                BOOL ok = (ret[0] == 'v' && method_getNumberOfArguments(m) == 5 && a0[0] == '@' && a1[0] == '@' &&
                           (strcmp(a2, "@?") == 0 || strcmp(a2, "@") == 0));
                if (!ok) {
                    OMCLogWrite(@"AppBridge", [NSString stringWithFormat:@"hook skip: type encoding khong khop %s %s: %s", "FBScene", sel_getName(sel), enc ? enc : "(null)"]);
                } else {
                    MSHookMessageEx(cls, sel, (IMP)ABHook_FBSceneUpdateSettings, (IMP *)&orig_FBSceneUpdate); // orig at 0x3EA00
                }
            }
        }
    }

    // -[SBSceneView _updateReferenceSize:andOrientation:] -> ABHook_SBSceneViewRefSize
    // §4: void, 2 args after self/_cmd, the 1st a struct ('{...}').
    {
        SEL sel = NSSelectorFromString(@"_updateReferenceSize:andOrientation:");
        Class cls = objc_getClass("SBSceneView");
        if (!cls) {
            OMCLogWrite(@"AppBridge", [NSString stringWithFormat:@"hook skip: khong thay class %s", "SBSceneView"]);
        } else {
            Method m = class_getInstanceMethod(cls, sel);
            if (!m) {
                OMCLogWrite(@"AppBridge", [NSString stringWithFormat:@"hook skip: khong thay method %s %s", "SBSceneView", sel_getName(sel)]);
            } else {
                const char *enc = method_getTypeEncoding(m);
                char ret[32] = {0}; method_getReturnType(m, ret, sizeof(ret));
                char a0[64] = {0};
                if (method_getNumberOfArguments(m) > 2) method_getArgumentType(m, 2, a0, sizeof(a0));
                BOOL ok = (ret[0] == 'v' && method_getNumberOfArguments(m) == 4 && a0[0] == '{');
                if (!ok) {
                    OMCLogWrite(@"AppBridge", [NSString stringWithFormat:@"hook skip: type encoding khong khop %s %s: %s", "SBSceneView", sel_getName(sel), enc ? enc : "(null)"]);
                } else {
                    MSHookMessageEx(cls, sel, (IMP)ABHook_SBSceneViewRefSize, (IMP *)&orig_SBSceneView); // orig at 0x3EA08
                }
            }
        }
    }

    OMCCheckHooks(@"AppBridge", @[@"SBSuspendedUnderLockManager -_shouldBeBackgroundUnderLockForScene:withSettings:", @"FBScene -updateSettings:withTransitionContext:completion:", @"SBSceneView -_updateReferenceSize:andOrientation:"]);

    // BKSDisplayServicesSetScreenBlanked (MSHookFunction) — dlsym branch
    // preserved from the original installer: NULL logs and skips.
    void *fn = dlsym((void *)-2 /* RTLD_DEFAULT */, "BKSDisplayServicesSetScreenBlanked");
    if (fn) {
        MSHookFunction(fn, (void *)ABHook_ScreenBlanked, (void **)&orig_ScreenBlanked); // orig at 0x3EA10
    } else {
        OMCLogWrite(@"AppBridge", [NSString stringWithFormat:@"khong tim thay BKSDisplayServicesSetScreenBlanked"]);
    }
}
