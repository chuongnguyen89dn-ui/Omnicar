// SCPFullscreenController.m — OmniCarSplitScreen [fs1, design-fullscreen-fs1 §4]
//
// Fullscreen (dock/chrome hidden) rebuilt from the QA20 reference
// source as a first-class controller of this module — see the header
// for ownership. Mechanism discipline copied from OMCToggleHost:
// snapshot BEFORE the state flip, the layout target is the window
// bounds inside the parent, the area source itself is switched (the
// container frame is never set from here), restore flips the flag
// first and lets the stock layout pull the container back.
//
// Chrome is an internal function of this file (§2 mapping): the
// status-bar windows are found by class-name scan of the process
// windows, their original hidden flags are recorded before hiding
// and restored exactly — no external chrome symbol is referenced.
//
// All entry points funnel to the main queue. All log lines carry the
// [fs1] prefix. Commands arrive through the adapter (pinch) and
// through the [fs-diag] prefs listener (diagnostic drive + escape
// path, GPT WO fix-p).

#import "SCPFullscreenController.h"
#import "SCPCarSplit.h"
#import "SCPCarSplit+BridgeWake.h" // bwSetExpandedActive:forBundle: (§4.10)
#import "SCPShared.h"               // SCPDispatchAfter
#import "SCPCommon.h"               // OMCLogWrite
#import "SCPFullscreenVitalsBubble.h" // [fs-vitals] display only, controller owns fullscreen
#import <notify.h>                  // [fs-diag] prefs listener

#pragma mark - File statics (thresholds copied from the reference source)

/// OMCAreaValid [XM :50]: finite, every dimension > 50 pt.
static BOOL FSAreaValid(CGRect r) {
    return isfinite(r.origin.x) && isfinite(r.origin.y) &&
           isfinite(r.size.width) && isfinite(r.size.height) &&
           r.size.width > 50.0 && r.size.height > 50.0;
}

/// OMCWindowBoundsInParent [XM :55]: the whole window in parent space.
static CGRect FSWindowBoundsInParent(UIView *parent) {
    UIWindow *window = parent.window;
    if (!window) return CGRectNull;
    return [parent convertRect:window.bounds fromView:window];
}

/// Frame confirmation tolerance (§4.4 step 5): 0.5 pt per component.
static BOOL FSRectClose(CGRect a, CGRect b) {
    return fabs(a.origin.x - b.origin.x) <= 0.5 &&
           fabs(a.origin.y - b.origin.y) <= 0.5 &&
           fabs(a.size.width - b.size.width) <= 0.5 &&
           fabs(a.size.height - b.size.height) <= 0.5;
}

static void FSOnMain(void (^block)(void)) {
    if ([NSThread isMainThread]) block();
    else dispatch_async(dispatch_get_main_queue(), block);
}

typedef NS_ENUM(NSInteger, SCPFSPhase) {
    SCPFSPhaseSplit = 0,
    SCPFSPhaseExpanding,
    SCPFSPhaseExpanded,
    SCPFSPhaseRestoring,
};

@interface SCPFullscreenController () {
    SCPFSPhase _phase;
    // Internal expanded flag, flipped BEFORE the relayout exactly like
    // the reference toggle's state.expanded: fsAreaForParent: keys on
    // this, while fsCommittedState keys on the settled phase (§4.1/§4.3).
    BOOL _expandedFlag;
    BOOL _installed;
    uint64_t _txnCounter;   // monotone (§4.2)
    uint64_t _currentTxn;   // transaction owning the live state/snapshot
    // Snapshot — one at a time, owned by _currentTxn (§4.2).
    __weak UIView *_snapParent;
    CGRect _snapOriginalArea;
    CGRect _snapTargetArea;
    BOOL _snapPreviousClips;
    uint64_t _snapTxn;
    // Restore retry (§4.5 step 4): the only async tail of any chain.
    void (^_pendingCompletion)(BOOL);
    uint64_t _pendingTxn;
    NSString *_pendingProvenance;
    BOOL _inReconcile;      // fsDidLayout re-entrancy guard (§4.8)
    // [fs-diag] diagnostic drive: prefs-listener token + the last
    // fullscreenDiagExpand value this controller acted on (edge base).
    int _fsDiagPrefsToken;
    BOOL _fsDiagWant;
    // Chrome (§4.7): status-bar window -> its ORIGINAL hidden flag,
    // recorded on first sight only, restored exactly, then cleared.
    NSMapTable<UIWindow *, NSNumber *> *_chromeOriginals;
    // HL9: one identity-scoped snapshot for each recall button hidden by FS.
    // Weak keys avoid retaining a retired button across a layout rebuild.
    NSMapTable<UIButton *, NSNumber *> *_homeHiddenOriginals;
}
@end

@implementation SCPFullscreenController

@synthesize fsStateDidChange = _fsStateDidChange;

+ (instancetype)shared {
    static SCPFullscreenController *instance;
    static dispatch_once_t once;
    dispatch_once(&once, ^{ instance = [[self alloc] init]; });
    return instance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _phase = SCPFSPhaseSplit;
        _chromeOriginals = [NSMapTable weakToStrongObjectsMapTable];
        _homeHiddenOriginals = [NSMapTable weakToStrongObjectsMapTable];
    }
    return self;
}

#pragma mark - Install

- (void)fsInstallIfNeeded {
    if (_installed) return;
    _installed = YES;
    // Command sources: the adapter (pinch) and the [fs-diag] prefs
    // listener below — a controlled diagnostic drive restored under
    // GPT's WO (fix-p) after the fs1 staging switch was removed: it
    // is the controller's independent acceptance trigger AND the
    // recognizer-independent escape path (pref OFF from anywhere
    // while EXPANDED restores — see fsDiagPrefsChanged).
    _fsDiagWant = [OMCPref(@"fullscreenDiagExpand", @NO) boolValue];
    __weak typeof(self) weakSelf = self;
    notify_register_dispatch(SCPNotePrefsChanged.UTF8String,
        &_fsDiagPrefsToken, dispatch_get_main_queue(), ^(int token) {
            (void)token;
            [weakSelf fsDiagPrefsChanged];
        });
    OMCLogWrite(@"SplitScreen", @"[fs1] fs controller installed (CarPlayApp)");
    OMCLogWrite(@"SplitScreen", [NSString stringWithFormat:
        @"[fs-diag] diag listener installed want=%d", (int)_fsDiagWant]);
}

#pragma mark - Diagnostic prefs drive [fs-diag]

/// [fs-diag] pref fullscreenDiagExpand changed (any prefs write wakes
/// this — the channel is global). The pref is an INPUT: this
/// controller only READS it (OMCPref) and never writes it back.
/// ON -> the same internal expand the adapter forwards to (identical
/// entry gates, transaction and read-back confirmation); OFF ->
/// restore; provenance "diag" either way. Edge-triggered on the
/// stored last-acted value, with one level safety: a post that finds
/// the pref OFF while the machine sits EXPANDED still restores, so
/// switching the pref off from anywhere is always an escape from
/// fullscreen even if the change edge itself was somehow missed.
- (void)fsDiagPrefsChanged {
    BOOL want = [OMCPref(@"fullscreenDiagExpand", @NO) boolValue];
    if (want == _fsDiagWant) {
        if (!want && _phase == SCPFSPhaseExpanded) {
            OMCLogWrite(@"SplitScreen",
                @"[fs-diag] pref off while EXPANDED (no edge) -> restore");
            [self fsRequestRestoreWithCompletion:nil provenance:@"diag"];
        }
        return;
    }
    _fsDiagWant = want;
    OMCLogWrite(@"SplitScreen", [NSString stringWithFormat:
        @"[fs-diag] fullscreenDiagExpand -> %@ (%@)",
        want ? @"ON" : @"OFF", want ? @"expand" : @"restore"]);
    if (want)
        [self fsRequestExpandWithCompletion:nil provenance:@"diag"];
    else
        [self fsRequestRestoreWithCompletion:nil provenance:@"diag"];
}

#pragma mark - Settled state + area consultation

- (SCPFullscreenState)fsCommittedState {
    if (!_installed) return SCPFullscreenStateUnknown;
    switch (_phase) {
        case SCPFSPhaseExpanded:
        case SCPFSPhaseRestoring: // §4.1: still Expanded until confirmed
            return SCPFullscreenStateExpanded;
        default:                  // Split + Expanding (§4.1)
            return SCPFullscreenStateSplit;
    }
}

- (CGRect)fsAreaForParent:(UIView *)parent
             nativeArea:(CGRect)nativeArea
                  split:(SCPCarSplit *)split {
    // §4.3: target ONLY while the internal flag is up (phases Expanding
    // and Expanded — restore lowers the flag first, §4.5 step 2), for
    // the snapshotted parent alone, split active, target valid. Every
    // other caller/parent gets the native area bit for bit.
    if (!_expandedFlag) return nativeArea;
    if (_phase != SCPFSPhaseExpanding && _phase != SCPFSPhaseExpanded)
        return nativeArea;
    if (!parent || parent != _snapParent) return nativeArea;
    if (!split.active) return nativeArea;
    if (!FSAreaValid(_snapTargetArea)) return nativeArea;
    return _snapTargetArea;
}

- (void)fsFireStateDidChange:(SCPFullscreenState)state {
    // The settled fullscreen owner is the ONLY source of visibility.
    // Do not replace the adapter's existing stateDidChange subscriber.
    if (state == SCPFullscreenStateExpanded) {
        UIView *parent = [SCPCarSplit shared].container.superview;
        [[SCPFullscreenVitalsBubble shared] showForConfirmedFullscreenInParent:parent];
    } else {
        [[SCPFullscreenVitalsBubble shared] stop];
    }
    if (_fsStateDidChange) _fsStateDidChange(state);
}

- (void)fsClearSnapshot {
    _snapParent = nil;
    _snapOriginalArea = CGRectZero;
    _snapTargetArea = CGRectZero;
    _snapTxn = 0;
}

#pragma mark - Chrome (§4.7 — internal, no external symbol)

/// Sweep the process windows for the status-bar window classes and
/// hide each, recording its ORIGINAL hidden flag on first sight only.
/// Late-appearing windows are picked up by the reconcile re-sweep.
/// No window observed -> FAILED log, nothing latched (§2 mapping);
/// the failure is logged at the expand settle point only, the
/// reconcile sweeps stay silent so the log is not spammed.
- (BOOL)fsChromeSweepAndHide {
    BOOL found = NO;
    // Window walk in the module's own idiom (connectedScenes ->
    // UIWindowScene.windows, as in -installIconLongPress): the same
    // per-process window set the design's scan names, without the
    // deprecated flat accessor.
    for (UIScene *scene in [UIApplication sharedApplication].connectedScenes) {
        if (![scene isKindOfClass:[UIWindowScene class]]) continue;
        for (UIWindow *window in ((UIWindowScene *)scene).windows) {
            NSString *cls = NSStringFromClass([window class]);
            if (![cls isEqualToString:@"DBStatusBarWindow"] &&
                ![cls isEqualToString:@"CARStatusBarWindow"]) continue;
            found = YES;
            if (![_chromeOriginals objectForKey:window])
                [_chromeOriginals setObject:@(window.hidden) forKey:window];
            if (!window.hidden) window.hidden = YES;
        }
    }
    return found;
}

// Restore the exact pre-fullscreen hidden flag on each still-live button.
// The AutoHide opacity/interaction axis is deliberately NOT touched.
- (void)fsRestoreHomeButtonHidden {
    NSUInteger restored = 0;
    for (UIButton *button in [[_homeHiddenOriginals keyEnumerator] allObjects]) {
        NSNumber *original = [_homeHiddenOriginals objectForKey:button];
        if (!original) continue;
        button.hidden = original.boolValue;
        restored++;
    }
    [_homeHiddenOriginals removeAllObjects];
    if (restored)
        OMCLogWrite(@"SplitScreen", [NSString stringWithFormat:
            @"[hl9logo] ev=fs-hidden-restore count=%lu currentHidden=%d",
            (unsigned long)restored,
            [SCPCarSplit shared].homeButton
                ? (int)[SCPCarSplit shared].homeButton.hidden : -1]);
}

- (void)fsChromeSetHidden:(BOOL)hidden {
    if (hidden) {
        if (![self fsChromeSweepAndHide])
            OMCLogWrite(@"SplitScreen",
                @"[fs1] fs chrome FAILED no-window");
        return;
    }
    // Restore EXACTLY the recorded original flag per window (§2),
    // never a blanket hidden = NO; then clear the records.
    for (UIWindow *window in [[_chromeOriginals keyEnumerator] allObjects]) {
        NSNumber *original = [_chromeOriginals objectForKey:window];
        if (original) window.hidden = original.boolValue;
    }
    [_chromeOriginals removeAllObjects];
    [self fsRestoreHomeButtonHidden];
}

/// The rebuilt's own Home/launcher button is FS chrome while EXPANDED
/// (§4.7 item 2): forced hidden here and re-asserted by every
/// reconcile, because refreshHomeButton may build a different button
/// while fullscreen. Restore EXACTLY the prior hidden flag for each
/// live button at rollback, confirmed/unconfirmed restore or teardown.
/// This does not override the independent AutoHide fade/interaction.
- (void)fsAssertHomeButtonHidden {
    UIButton *button = [SCPCarSplit shared].homeButton;
    if (!button) return;
    if (![_homeHiddenOriginals objectForKey:button]) {
        [_homeHiddenOriginals setObject:@(button.hidden) forKey:button];
        OMCLogWrite(@"SplitScreen", [NSString stringWithFormat:
            @"[hl9logo] ev=fs-hidden-save button=%p original=%d",
            (void *)button, (int)button.hidden]);
    }
    if (!button.hidden) button.hidden = YES;
}

#pragma mark - Entry-gate state (§4.4 step 1, [fix-g] activity predicates)

/// [fix-g] Is the shared overlay ("tray") window presenting anything
/// the earlier gate branches did not already name? GPT's audit: the
/// old existence test on the tray window/overlay flags confused a
/// RETAINED window with an OPEN popup — trayWindowForParent: keeps
/// the window alive after first use (it is nil'd only at teardown,
/// SCPCarSplit.m dashboardInvalidated, or on a screen change,
/// Picker.m:888) and even un-hides it on reuse (Picker.m:884), while
/// trayOverlay is a sticky hosting-mode flag of the layout panel
/// (set once at Panel.m:188, never reset; it feeds the appArea
/// suppression at SCPCarSplit.m:2120, NOT an open/closed signal).
/// The module's own activity vocabulary is the content set of
/// hideTrayWindowIfIdle (Picker.m:977-980): tray / ratioMenu /
/// pickerSheet / dragGhost / background toast (tag 0x5c9b). The
/// first three are already refused above as "picker"/"popup"
/// (panelOpen, Chrome.m:388); what remains for this branch is a
/// drag ghost in flight and the background toast. Closing
/// transitions need no term here: every close path clears its state
/// pointer FIRST (Picker.m:653 pickerSheet, Picker.m:995 tray,
/// RatioMenu.m:469 ratioMenu) and animates the detached view out —
/// the module treats the pointer as the state everywhere.
- (BOOL)fsTraySurfaceBusy:(SCPCarSplit *)split {
    if (split.dragGhost != nil) return YES;
    UIWindow *window = split.trayWindow;
    if (window != nil && [window viewWithTag:0x5c9b] != nil) return YES;
    return NO;
}

/// [fix-g] One-line state snapshot appended to EVERY refusal this
/// controller logs, so a later log read can tell a true block from a
/// stale-state one: tray window existence/hidden, trayOverlay value,
/// tray/picker/ratio/drag-ghost existence, toast, resize + float
/// transitions, and this machine's phase.
/// [hl2-split F6] The trayOverlay field is labelled with its FULL
/// name on purpose: trayOverlay is a sticky hosting-mode flag (set
/// once at Panel.m to (window != nil), never reset) and is NOT an
/// input of any guard predicate in this controller — the expand
/// gate reads active / zoomedSlot / soloHostedBundle / pickerSheet /
/// popupOpen / fsTraySurfaceBusy only. The old two-letter label
/// "to" read as if it were a live guard input (in the ytz5hl1 log
/// all five refusals showed to=1 while picker/ratio/dg/toast/tray
/// were all 0; the actual refusal inputs were phase and `inactive`).
- (NSString *)fsRefusalSnapshot:(SCPCarSplit *)split {
    UIWindow *tw = split.trayWindow;
    return [NSString stringWithFormat:
        @"snap{tw=%d twh=%@ trayOverlay=%d tray=%d picker=%d ratio=%d dg=%d "
        @"toast=%d rz=%d fc=%d phase=%ld}",
        tw != nil, tw ? (tw.hidden ? @"1" : @"0") : @"-",
        (int)split.trayOverlay, split.tray != nil,
        split.pickerSheet != nil, split.ratioMenu != nil,
        split.dragGhost != nil,
        (tw != nil && [tw viewWithTag:0x5c9b] != nil),
        (int)split.resizing, (int)split.floatClosing, (long)_phase];
}

#pragma mark - Expand (§4.4)

- (void)fsRequestExpandWithCompletion:(void (^)(BOOL))completion
                           provenance:(NSString *)provenance {
    FSOnMain(^{ [self fsExpandWithCompletion:completion
                                 provenance:provenance ?: @"?"]; });
}

- (void)fsExpandWithCompletion:(void (^)(BOOL))completion
                    provenance:(NSString *)prov {
    // §4.2: a second command during a transition is refused outright.
    if (_phase == SCPFSPhaseExpanding || _phase == SCPFSPhaseRestoring) {
        OMCLogWrite(@"SplitScreen", [NSString stringWithFormat:
            @"[fs1] fs busy txn=%llu expand refused provenance=%@ %@",
            (unsigned long long)_currentTxn, prov,
            [self fsRefusalSnapshot:[SCPCarSplit shared]]]);
        if (completion) completion(NO);
        return;
    }
    if (_phase != SCPFSPhaseSplit) {
        OMCLogWrite(@"SplitScreen", [NSString stringWithFormat:
            @"[fs1] fs expand refused state=EXPANDED provenance=%@ %@",
            prov, [self fsRefusalSnapshot:[SCPCarSplit shared]]]);
        if (completion) completion(NO);
        return;
    }
    // Entry gate (§4.4 step 1 / §6): refuse quietly, touch nothing —
    // FS never closes a picker, ends a solo or cancels a zoom itself.
    SCPCarSplit *split = [SCPCarSplit shared];
    UIView *container = split.container;
    UIView *parent = container.superview;
    NSString *refuse = nil;
    if (!split.active) refuse = @"inactive";
    else if (!container || !parent || !parent.window)
        refuse = @"host-unavailable";
    else if (split.zoomedSlot) refuse = @"zoomed";
    else if (split.soloHostedBundle) refuse = @"solo";
    else if (split.pickerSheet) refuse = @"picker";
    else if ([split popupOpen]) refuse = @"popup";
    else if ([self fsTraySurfaceBusy:split]) refuse = @"tray";
    if (refuse) {
        OMCLogWrite(@"SplitScreen", [NSString stringWithFormat:
            @"[fs1] fs expand refused reason=%@ provenance=%@ %@",
            refuse, prov, [self fsRefusalSnapshot:split]]);
        if (completion) completion(NO);
        return;
    }
    // Snapshot BEFORE the flip (§4.4 step 2): the pre-flip
    // appAreaInParent: call still consults to the native area.
    uint64_t txn = ++_txnCounter;
    CGRect original = [split appAreaInParent:parent];
    CGRect target = FSWindowBoundsInParent(parent);
    if (!FSAreaValid(original) || !FSAreaValid(target)) {
        OMCLogWrite(@"SplitScreen", [NSString stringWithFormat:
            @"[fs1] fs expand refused reason=invalid-rect original=%@ "
            @"target=%@ provenance=%@ %@",
            NSStringFromCGRect(original), NSStringFromCGRect(target),
            prov, [self fsRefusalSnapshot:split]]);
        if (completion) completion(NO);
        return;
    }
    _currentTxn = txn;
    _snapParent = parent;
    _snapOriginalArea = original;
    _snapTargetArea = target;
    _snapPreviousClips = parent.clipsToBounds;
    _snapTxn = txn;
    // Flip, un-clip, and let the stock layout pull the container —
    // the exact command pair of the reference toggle (§4.4 steps 3–4).
    _phase = SCPFSPhaseExpanding;
    _expandedFlag = YES;
    parent.clipsToBounds = NO;
    [split relayoutAnimated:NO pushScenes:YES];
    [split rootDidLayout];
    // Confirmation (§4.4 step 5): a returned relayout call is NOT
    // proof — read the world back.
    BOOL confirmed = FSRectClose(container.frame, target) &&
                     container.superview == parent &&
                     parent.window != nil && split.active;
    if (!confirmed) {
        OMCLogWrite(@"SplitScreen", [NSString stringWithFormat:
            @"[fs1] fs expand unconfirmed txn=%llu frame=%@ target=%@ "
            @"superview-ok=%d window=%d active=%d provenance=%@",
            (unsigned long long)txn, NSStringFromCGRect(container.frame),
            NSStringFromCGRect(target), container.superview == parent,
            parent.window != nil, split.active, prov]);
        [self fsRollbackWithProvenance:prov];
        if (completion) completion(NO);
        return;
    }
    // Settle (§4.4 step 6): chrome, wake owner, event, completion.
    _phase = SCPFSPhaseExpanded;
    [self fsChromeSetHidden:YES];
    [self fsAssertHomeButtonHidden];
    [split bwSetExpandedActive:YES forBundle:nil];
    OMCLogWrite(@"SplitScreen", [NSString stringWithFormat:
        @"[fs1] fs expand confirmed txn=%llu provenance=%@",
        (unsigned long long)txn, prov]);
    [self fsFireStateDidChange:SCPFullscreenStateExpanded];
    if (completion) completion(YES);
}

/// Rollback (§4.6): an expand that failed mid-flight returns the
/// system to a measurable pre-command state; completion was already
/// answered NO by the caller.
- (void)fsRollbackWithProvenance:(NSString *)prov {
    [[SCPFullscreenVitalsBubble shared] stop]; // no bubble on unconfirmed expand
    SCPCarSplit *split = [SCPCarSplit shared];
    _expandedFlag = NO;
    UIView *parent = _snapParent;
    if (parent) parent.clipsToBounds = _snapPreviousClips;
    [split relayoutAnimated:NO pushScenes:YES];
    [split rootDidLayout];
    [self fsChromeSetHidden:NO];
    [split bwSetExpandedActive:NO forBundle:nil];
    _phase = SCPFSPhaseSplit;
    [self fsClearSnapshot];
    OMCLogWrite(@"SplitScreen", [NSString stringWithFormat:
        @"[fs1] fs rollback done provenance=%@ frame=%@ clips=%d",
        prov, NSStringFromCGRect(split.container.frame),
        parent ? (int)parent.clipsToBounds : -1]);
}

#pragma mark - Restore (§4.5)

- (void)fsRequestRestoreWithCompletion:(void (^)(BOOL))completion
                            provenance:(NSString *)provenance {
    FSOnMain(^{ [self fsRestoreWithCompletion:completion
                                  provenance:provenance ?: @"?"]; });
}

/// Read-back for restore (§4.5 step 4): the container frame must equal
/// the CURRENT native area — recomputed now, flag already down. If the
/// dashboard legitimately moved its area while expanded, the current
/// area wins and the snapshot rect is simply dropped.
- (BOOL)fsRestoreConfirmed {
    SCPCarSplit *split = [SCPCarSplit shared];
    UIView *container = split.container;
    UIView *parent = container.superview;
    if (!container || !parent) return NO;
    return FSRectClose(container.frame, [split appAreaInParent:parent]);
}

- (void)fsRestoreWithCompletion:(void (^)(BOOL))completion
                     provenance:(NSString *)prov {
    if (_phase == SCPFSPhaseRestoring) {
        OMCLogWrite(@"SplitScreen", [NSString stringWithFormat:
            @"[fs1] fs busy txn=%llu restore refused provenance=%@ %@",
            (unsigned long long)_currentTxn, prov,
            [self fsRefusalSnapshot:[SCPCarSplit shared]]]);
        if (completion) completion(NO);
        return;
    }
    if (_phase == SCPFSPhaseExpanding) {
        // §4.5 step 1: a restore demand against an in-flight expand is
        // a cancel — it goes through rollback, never a second chain.
        [self fsRollbackWithProvenance:prov];
        if (completion) completion(NO);
        return;
    }
    if (_phase != SCPFSPhaseExpanded) {
        OMCLogWrite(@"SplitScreen", [NSString stringWithFormat:
            @"[fs1] fs restore refused state=SPLIT provenance=%@ %@",
            prov, [self fsRefusalSnapshot:[SCPCarSplit shared]]]);
        if (completion) completion(NO);
        return;
    }
    uint64_t txn = ++_txnCounter;
    _currentTxn = txn;
    [[SCPFullscreenVitalsBubble shared] stop]; // remove BEFORE restoring stock Dock/chrome
    _phase = SCPFSPhaseRestoring;
    // Flag down FIRST (§4.5 step 2): the area consultation returns the
    // native area from here on; clips restored while parent lives.
    _expandedFlag = NO;
    if (_snapParent) _snapParent.clipsToBounds = _snapPreviousClips;
    SCPCarSplit *split = [SCPCarSplit shared];
    [split relayoutAnimated:NO pushScenes:YES];
    [split rootDidLayout];
    if ([self fsRestoreConfirmed]) {
        [self fsSettleRestoreWithCompletion:completion
                                 provenance:prov txn:txn];
        return;
    }
    // Exactly one retry after 0.05 s (§4.5 step 4) — the dashboard may
    // be mid-layout. The block carries the txn; a stale one is dropped.
    _pendingCompletion = [completion copy];
    _pendingTxn = txn;
    _pendingProvenance = [prov copy];
    __weak typeof(self) weakSelf = self;
    SCPDispatchAfter(0.05, ^{
        __strong typeof(weakSelf) self = weakSelf;
        if (!self) return;
        if (self->_pendingTxn != txn || self->_currentTxn != txn ||
            self->_phase != SCPFSPhaseRestoring) return; // stale (§4.2)
        void (^done)(BOOL) = self->_pendingCompletion;
        NSString *p = self->_pendingProvenance;
        self->_pendingCompletion = nil;
        self->_pendingProvenance = nil;
        if ([self fsRestoreConfirmed])
            [self fsSettleRestoreWithCompletion:done provenance:p txn:txn];
        else
            [self fsSettleRestoreUnconfirmedWithCompletion:done
                                                provenance:p txn:txn];
    });
}

- (void)fsSettleRestoreWithCompletion:(void (^)(BOOL))completion
                           provenance:(NSString *)prov
                                  txn:(uint64_t)txn {
    SCPCarSplit *split = [SCPCarSplit shared];
    [self fsChromeSetHidden:NO];
    [split bwSetExpandedActive:NO forBundle:nil];
    [self fsClearSnapshot];
    _phase = SCPFSPhaseSplit;
    OMCLogWrite(@"SplitScreen", [NSString stringWithFormat:
        @"[fs1] fs restore confirmed txn=%llu provenance=%@",
        (unsigned long long)txn, prov]);
    [self fsFireStateDidChange:SCPFullscreenStateSplit];
    if (completion) completion(YES);
}

/// Unconfirmed restore (§4.5 step 4): close SAFE at SPLIT with every
/// restoration applied and the failure logged — never keep an
/// EXPANDED label that was not read back (principle §9.3).
- (void)fsSettleRestoreUnconfirmedWithCompletion:(void (^)(BOOL))completion
                                      provenance:(NSString *)prov
                                             txn:(uint64_t)txn {
    SCPCarSplit *split = [SCPCarSplit shared];
    if (_snapParent) _snapParent.clipsToBounds = _snapPreviousClips;
    [self fsChromeSetHidden:NO];
    [split bwSetExpandedActive:NO forBundle:nil];
    OMCLogWrite(@"SplitScreen", [NSString stringWithFormat:
        @"[fs1] fs restore-unconfirmed txn=%llu frame=%@ provenance=%@",
        (unsigned long long)txn, NSStringFromCGRect(split.container.frame),
        prov]);
    [self fsClearSnapshot];
    _phase = SCPFSPhaseSplit;
    [self fsFireStateDidChange:SCPFullscreenStateSplit];
    if (completion) completion(NO);
}

#pragma mark - Abbreviated restore (§4.6) + reconcile (§4.8)

/// Session end: NO relayout — the session is dying; clips + chrome +
/// wake flag are restored and the machine lands at SPLIT. Modelled on
/// the reference setActive: teardown (§1.3).
- (void)fsSessionDidEnd {
    FSOnMain(^{
        [[SCPFullscreenVitalsBubble shared] stop]; // teardown always wins
        BOOL wasSettledExpanded = (_phase == SCPFSPhaseExpanded ||
                                   _phase == SCPFSPhaseRestoring);
        if (_phase == SCPFSPhaseSplit && !_expandedFlag && !_snapParent &&
            !_pendingCompletion) return;
        // Invalidate any in-flight retry before touching state (§4.2).
        _currentTxn = ++_txnCounter;
        void (^pending)(BOOL) = _pendingCompletion;
        _pendingCompletion = nil;
        _pendingProvenance = nil;
        _expandedFlag = NO;
        if (_snapParent) _snapParent.clipsToBounds = _snapPreviousClips;
        [self fsChromeSetHidden:NO];
        [[SCPCarSplit shared] bwSetExpandedActive:NO forBundle:nil];
        _phase = SCPFSPhaseSplit;
        [self fsClearSnapshot];
        OMCLogWrite(@"SplitScreen",
            @"[fs1] fs session-end abbreviated restore provenance=teardown");
        if (wasSettledExpanded)
            [self fsFireStateDidChange:SCPFullscreenStateSplit];
        if (pending) pending(NO);
    });
}

- (void)fsDidLayout {
    if (![NSThread isMainThread]) return; // the seam is main-queue work
    if (_phase != SCPFSPhaseExpanded || _inReconcile) return;
    if (_snapTxn == 0 || _snapTxn != _currentTxn) return; // no live txn
    SCPCarSplit *split = [SCPCarSplit shared];
    if (!split.active) { [self fsSessionDidEnd]; return; }
    // Outside override (§4.8): a solo/zoom that arrived through the
    // bridge or UI owns the presentation area now — FS yields to the
    // fact on the ground instead of fighting it, and never calls back
    // into any solo/zoom entry to clean up (§6).
    if (split.soloHostedBundle != nil || split.zoomedSlot != nil) {
        OMCLogWrite(@"SplitScreen", [NSString stringWithFormat:
            @"[fs1] fs external-override solo=%@ zoomed=%@",
            split.soloHostedBundle, split.zoomedSlot]);
        [self fsSessionDidEnd];
        return;
    }
    UIView *container = split.container;
    if (container && !FSRectClose(container.frame, _snapTargetArea)) {
        _inReconcile = YES;
        [split relayoutAnimated:NO pushScenes:YES];
        [split rootDidLayout];
        _inReconcile = NO;
        if (!FSRectClose(container.frame, _snapTargetArea)) {
            OMCLogWrite(@"SplitScreen", [NSString stringWithFormat:
                @"[fs1] fs reconcile frame-drift unrecovered frame=%@ "
                @"target=%@", NSStringFromCGRect(container.frame),
                NSStringFromCGRect(_snapTargetArea)]);
            [self fsSessionDidEnd];
            return;
        }
    }
    // Re-assert chrome (§4.8): late status-bar windows get recorded +
    // hidden; the Home button is forced back down after layout.
    [self fsChromeSweepAndHide];
    [self fsAssertHomeButtonHidden];
    [[SCPFullscreenVitalsBubble shared] showForConfirmedFullscreenInParent:split.container.superview];
}

@end
