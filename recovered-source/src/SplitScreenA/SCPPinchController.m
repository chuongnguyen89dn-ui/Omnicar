// SCPPinchController.m — OmniCarSplitScreen [wake-round, design-pinch]
// Implementation of the pinch state machine (§3), the five-gate fire
// point (§3.3), the point->pane mapping (§2.1) and the Gate-2 probe
// (§6.1). See the header for the contract. Log lines are prefixed
// [pinch1] and go through OMCLogWrite(@"SplitScreen", ...) like the
// rest of the module; probe lines carry distances/ratios only — never
// absolute touch coordinates (§6.1).

#import "SCPPinchController.h"
#import "SCPCarSplit.h"
#import "SCPShared.h" // OMCLogWrite, SCPVCIsHosted
#import <math.h>

// ---------------------------------------------------------------------------
// Internal surface shared by the two classes in this file.
// ---------------------------------------------------------------------------

typedef NS_ENUM(NSInteger, SCPPinchDirection) {
    SCPPinchDirectionNone = 0,
    SCPPinchDirectionOut,  // fingers spreading: SPLIT -> EXPANDED candidate
    SCPPinchDirectionIn    // fingers closing: EXPANDED -> SPLIT candidate
};

typedef NS_ENUM(NSInteger, SCPPairPhase) {
    SCPPairPhaseIdle = 0,  // no accepted touch down
    SCPPairPhaseTracking,  // exactly one accepted touch down, no pair yet
    SCPPairPhasePaired,    // a pair is being tracked
    SCPPairPhaseConcluded  // pair concluded (fired / gate-dead / killed);
                           // waiting for every accepted touch to end
};

@interface SCPPinchController (SCPPinchInternal)
// Queries the recognizer makes of its controller.
- (BOOL)scpTrackingEnabled;   // armed && pinchMode != OFF
- (SCPPinchMode)scpCurrentMode;
- (NSInteger)scpNextGestureSeq;
- (BOOL)scpHostBucketExpanded;  // counter bucket: adapter says Expanded
- (nullable SCPCarPane *)scpPaneForStartPoint:(CGPoint)point
                                   touchView:(nullable UIView *)touchView
                                    deadKind:(SCPPinchDeadKind *)deadKindOut;
// Conclusions the recognizer reports to its controller (each is logged
// exactly once per pair by the controller).
- (void)scpRecognizerDidCross:(SCPPinchRecognizer *)recognizer;
- (void)scpRecognizerPairDissolved:(SCPPinchRecognizer *)recognizer;  // ended, never crossed
- (void)scpRecognizerPairKilled:(SCPPinchRecognizer *)recognizer reason:(NSString *)reason;
- (void)scpRecognizerPairFinished:(SCPPinchRecognizer *)recognizer complete:(BOOL)complete;
@end

@interface SCPPinchRecognizer ()
// Pair book (design-pinch §3.2). Touches are also held by
// _activeTouches; _t1/_t2 are strong refs so the book survives a touch
// leaving the active list at the moment its Ended is processed.
@property (nonatomic, strong) NSMutableArray<UITouch *> *activeTouches;
@property (nonatomic, strong) NSMutableSet<UITouch *> *ignoredTouches;
@property (nonatomic) SCPPairPhase phase;
@property (nonatomic, strong, nullable) UITouch *t1;
@property (nonatomic, strong, nullable) UITouch *t2;
@property (nonatomic) CGPoint t1Start;  // container coords, at t1's Began
@property (nonatomic) CGPoint t2Start;  // container coords, at t2's Began
@property (nonatomic, strong, nullable) SCPCarPane *t1Pane;
@property (nonatomic, strong, nullable) SCPCarPane *t2Pane;
@property (nonatomic) SCPPinchDeadKind t1DeadKind;
@property (nonatomic) SCPPinchDeadKind t2DeadKind;
@property (nonatomic, strong, nullable) SCPCarPane *pairPane;   // set only when both fingers share a pane
@property (nonatomic, copy, nullable) NSString *mappingDeath;   // "outside"/"divider"/"chrome"/"xpane"
@property (nonatomic) NSInteger seq;                            // 0 = no pair formed yet
@property (nonatomic) BOOL bucketExpanded;
@property (nonatomic) CGRect boundsAtPair;
@property (nonatomic) CGFloat dist0;    // distance at the moment finger 2 went down
@property (nonatomic) CGPoint mid0;     // midpoint at that same moment
@property (nonatomic) CGFloat scaleMax;
@property (nonatomic) CGFloat scaleMin;
@property (nonatomic) CGFloat lastMidDrift;
@property (nonatomic) SCPPinchDirection direction;  // set at the crossing Moved
@property (nonatomic) BOOL pairSawMove;
@property (nonatomic) BOOL concluded;   // summary already reported
@property (nonatomic) BOOL pairTruncated;
@property (nonatomic, copy, nullable) NSString *truncationReason;
@property (nonatomic) BOOL t1EndedOK;   // ended via touchesEnded (not Cancelled)
@property (nonatomic) BOOL t2EndedOK;
@property (nonatomic) BOOL pairCounted;
// Derived log values.
@property (nonatomic, readonly) SCPPinchDirection scpConclusionDirection;
@property (nonatomic, readonly) CGFloat scpScaleExtreme;
@property (nonatomic, readonly, nullable) SCPCarPane *scpLogPane;
@end

static NSString *SCPPinchDeadKindName(SCPPinchDeadKind kind) {
    switch (kind) {
        case SCPPinchDeadOutside: return @"outside";
        case SCPPinchDeadDivider: return @"divider";
        case SCPPinchDeadChrome:  return @"chrome";
        case SCPPinchDeadNone:    break;
    }
    return nil;
}

// ---------------------------------------------------------------------------
#pragma mark - SCPPinchRecognizer
// ---------------------------------------------------------------------------

@implementation SCPPinchRecognizer

- (instancetype)init {
    // No target/action: this recognizer never leaves the Possible
    // state and drives everything from the touch callbacks below.
    self = [super initWithTarget:nil action:nil];
    if (self) {
        // design-pinch §3.1 — mandatory, non-negotiable: the
        // recognizer observes in parallel and must never hold, cancel
        // or delay a touch. Pairs that do not prove themselves belong
        // to the app, intact.
        self.cancelsTouchesInView = NO;
        self.delaysTouchesBegan = NO;
        self.delaysTouchesEnded = NO;
        _activeTouches = [NSMutableArray array];
        _ignoredTouches = [NSMutableSet set];
        _phase = SCPPairPhaseIdle;
    }
    return self;
}

- (CGPoint)scpLocation:(UITouch *)touch {
    return [touch locationInView:self.view];
}

- (SCPPinchDirection)scpConclusionDirection {
    if (_direction != SCPPinchDirectionNone) return _direction;
    // No crossing happened: report the dominant direction of travel.
    return (_scaleMax - 1.0 >= 1.0 - _scaleMin) ? SCPPinchDirectionOut
                                                : SCPPinchDirectionIn;
}

- (CGFloat)scpScaleExtreme {
    return (self.scpConclusionDirection == SCPPinchDirectionIn) ? _scaleMin
                                                                : _scaleMax;
}

- (nullable SCPCarPane *)scpLogPane {
    return _pairPane ?: (_t1Pane ?: _t2Pane);
}

// Pair formation (design-pinch §3.2): dist0/mid0 are taken from the
// CURRENT positions at the moment finger 2 goes down (finger 1 may
// already have slid); the pane mapping uses each finger's own start
// point (§2.1).
- (void)scpFormPair {
    SCPPinchController *controller = self.controller;
    _seq = [controller scpNextGestureSeq];
    _bucketExpanded = [controller scpHostBucketExpanded];
    _boundsAtPair = self.view.bounds;
    if (_t1DeadKind != SCPPinchDeadNone) {
        _mappingDeath = SCPPinchDeadKindName(_t1DeadKind);
    } else if (_t2DeadKind != SCPPinchDeadNone) {
        _mappingDeath = SCPPinchDeadKindName(_t2DeadKind);
    } else if (_t1Pane != _t2Pane) {
        _mappingDeath = @"xpane";  // same container, two scenes — not one surface (§2.1)
    } else {
        _pairPane = _t1Pane;
    }
    CGPoint p1 = [self scpLocation:_t1];
    CGPoint p2 = [self scpLocation:_t2];
    _dist0 = hypot(p2.x - p1.x, p2.y - p1.y);
    _mid0 = CGPointMake((p1.x + p2.x) / 2.0, (p1.y + p2.y) / 2.0);
    _scaleMax = 1.0;
    _scaleMin = 1.0;
    _lastMidDrift = 0;
    _direction = SCPPinchDirectionNone;
    _pairSawMove = NO;
    _concluded = NO;
    _pairTruncated = NO;
    _truncationReason = nil;
    _t1EndedOK = NO;
    _t2EndedOK = NO;
    _pairCounted = NO;
    _phase = SCPPairPhasePaired;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if (!self.view) return;
    SCPPinchController *controller = self.controller;
    for (UITouch *touch in touches) {
        if (![controller scpTrackingEnabled]) {
            // Mode OFF / disarmed / no controller: this touch is never
            // counted into any pair (it did not begin under tracking).
            [_ignoredTouches addObject:touch];
            continue;
        }
        [_activeTouches addObject:touch];
        switch (_phase) {
            case SCPPairPhaseIdle: {
                _phase = SCPPairPhaseTracking;
                _t1 = touch;
                _t1Start = [self scpLocation:touch];
                SCPPinchDeadKind kind = SCPPinchDeadNone;
                _t1Pane = [controller scpPaneForStartPoint:_t1Start
                                                touchView:touch.view
                                                 deadKind:&kind];
                _t1DeadKind = kind;
                break;
            }
            case SCPPairPhaseTracking: {
                _t2 = touch;
                _t2Start = [self scpLocation:touch];
                SCPPinchDeadKind kind = SCPPinchDeadNone;
                _t2Pane = [controller scpPaneForStartPoint:_t2Start
                                                touchView:touch.view
                                                 deadKind:&kind];
                _t2DeadKind = kind;
                [self scpFormPair];
                break;
            }
            case SCPPairPhasePaired: {
                // Third touch (§3.2): kill the current gesture (no
                // command), then wait for every touch to end.
                _pairTruncated = YES;
                _truncationReason = @"third-touch";
                [controller scpRecognizerPairKilled:self reason:@"third-touch"];
                _concluded = YES;
                _phase = SCPPairPhaseConcluded;
                break;
            }
            case SCPPairPhaseConcluded:
                break;  // balancing only — a concluded pair never reopens
        }
    }
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if (_phase != SCPPairPhasePaired || !self.view) return;
    if (!CGRectEqualToRect(self.view.bounds, _boundsAtPair)) {
        // Container geometry changed mid-gesture (§1.3/§3.4): the
        // distances were measured in a stale coordinate frame.
        _pairTruncated = YES;
        _truncationReason = @"bounds";
        [self.controller scpRecognizerPairKilled:self reason:@"bounds"];
        _concluded = YES;
        _phase = SCPPairPhaseConcluded;
        return;
    }
    CGPoint p1 = [self scpLocation:_t1];
    CGPoint p2 = [self scpLocation:_t2];
    CGFloat dist = hypot(p2.x - p1.x, p2.y - p1.y);
    if (_dist0 <= 0.01) return;  // degenerate pair: no scale is meaningful
    CGFloat scale = dist / _dist0;
    CGFloat distChange = fabs(dist - _dist0);
    CGPoint mid = CGPointMake((p1.x + p2.x) / 2.0, (p1.y + p2.y) / 2.0);
    CGFloat drift = hypot(mid.x - _mid0.x, mid.y - _mid0.y);
    _pairSawMove = YES;
    _lastMidDrift = drift;
    if (scale > _scaleMax) _scaleMax = scale;
    if (scale < _scaleMin) _scaleMin = scale;
    if (_concluded) return;
    // The single evaluation point (§3.2/§3.3): both the threshold AND
    // the dominance test must hold at this same Moved.
    BOOL outCross = scale >= 1.10;
    BOOL inCross = scale <= 0.90;
    if ((outCross || inCross) && drift <= 0.6 * distChange + 10.0) {
        _direction = outCross ? SCPPinchDirectionOut : SCPPinchDirectionIn;
        [self.controller scpRecognizerDidCross:self];
        _concluded = YES;
        _phase = SCPPairPhaseConcluded;
    }
}

- (void)scpFinalisePair {
    if (_seq <= 0 || _pairCounted) return;
    _pairCounted = YES;
    // A pair counts as COMPLETE for Gate 2 (§6.1) only when the attach
    // point saw both touches Began -> Moved -> Ended with no cancel,
    // no intrusion and no session disruption.
    BOOL complete = !_pairTruncated && _t1EndedOK && _t2EndedOK && _pairSawMove;
    [self.controller scpRecognizerPairFinished:self complete:complete];
}

- (void)scpClearBook {
    _t1 = nil;
    _t2 = nil;
    _t1Pane = nil;
    _t2Pane = nil;
    _pairPane = nil;
    _mappingDeath = nil;
    _truncationReason = nil;
    _seq = 0;
    _direction = SCPPinchDirectionNone;
    _t1DeadKind = SCPPinchDeadNone;
    _t2DeadKind = SCPPinchDeadNone;
    _concluded = NO;
    _pairTruncated = NO;
    _pairCounted = NO;
}

- (void)scpTouchesFinished:(NSSet<UITouch *> *)touches cancelled:(BOOL)cancelled {
    for (UITouch *touch in touches) {
        BOOL wasActive = [_activeTouches containsObject:touch];
        [_activeTouches removeObject:touch];
        [_ignoredTouches removeObject:touch];
        if (!wasActive) continue;
        if (touch == _t1) {
            if (cancelled) {
                _pairTruncated = YES;
                if (!_truncationReason) _truncationReason = @"cancelled";
            } else {
                _t1EndedOK = YES;
            }
        }
        if (touch == _t2) {
            if (cancelled) {
                _pairTruncated = YES;
                if (!_truncationReason) _truncationReason = @"cancelled";
            } else {
                _t2EndedOK = YES;
            }
        }
        if (_phase == SCPPairPhaseTracking && touch == _t1) {
            // Single touch ended before any pair formed: nothing to log.
            [self scpClearBook];
            _phase = SCPPairPhaseIdle;
        } else if (_phase == SCPPairPhasePaired && (touch == _t1 || touch == _t2)) {
            // The pair dissolves without (further) conclusion.
            if (cancelled) {
                [self.controller scpRecognizerPairKilled:self reason:@"cancelled"];
            } else {
                [self.controller scpRecognizerPairDissolved:self];
            }
            _concluded = YES;
            _phase = SCPPairPhaseConcluded;
        }
    }
    if (_activeTouches.count == 0 && _phase == SCPPairPhaseConcluded) {
        [self scpFinalisePair];
        [self scpClearBook];
        _phase = SCPPairPhaseIdle;
    }
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self scpTouchesFinished:touches cancelled:NO];
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self scpTouchesFinished:touches cancelled:YES];
}

- (void)resetTrackingWithReason:(NSString *)reason {
    if (_phase == SCPPairPhasePaired) {
        _pairTruncated = YES;
        _truncationReason = reason;
        if (!_concluded) {
            [self.controller scpRecognizerPairKilled:self reason:reason];
            _concluded = YES;
        }
        _phase = SCPPairPhaseConcluded;
    } else if (_phase == SCPPairPhaseConcluded) {
        _pairTruncated = YES;
        if (!_truncationReason) _truncationReason = reason;
    } else if (_phase == SCPPairPhaseTracking) {
        // No pair to conclude; wait for the single touch to end before
        // the book is reused (§3.4: never fire from a just-reset state,
        // and a still-down touch never joins a fresh pair).
        _phase = SCPPairPhaseConcluded;
    }
    if (_activeTouches.count == 0 && _phase != SCPPairPhaseIdle) {
        [self scpFinalisePair];
        [self scpClearBook];
        _phase = SCPPairPhaseIdle;
    }
}

@end

// ---------------------------------------------------------------------------
#pragma mark - SCPPinchController
// ---------------------------------------------------------------------------

@interface SCPPinchController ()
@property (nonatomic, strong) NSMutableSet<NSString *> *allowlistKeys;
@property (nonatomic, readwrite, nullable) SCPPinchRecognizer *recognizer;
@property (nonatomic, readwrite) BOOL armed;
@property (nonatomic) NSInteger gestureSeq;
@property (nonatomic, readwrite) NSInteger pairsCompleteSplit;
@property (nonatomic, readwrite) NSInteger pairsTruncatedSplit;
@property (nonatomic, readwrite) NSInteger pairsCompleteExpanded;
@property (nonatomic, readwrite) NSInteger pairsTruncatedExpanded;
@end

@implementation SCPPinchController

+ (instancetype)shared {
    static SCPPinchController *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{ instance = [[SCPPinchController alloc] init]; });
    return instance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _adapter = [[SCPFullscreenAdapter alloc] init];  // forwards to SCPFullscreenController (fs1)
        _allowlistKeys = [NSMutableSet set];             // empty = no restriction (§A4, amended 2026-11-09)
    }
    return self;
}

#pragma mark Lifecycle glue (integration step calls these; see impl-pinch.md)

- (void)attachIfNeeded {
    SCPCarSplit *split = [SCPCarSplit shared];
    UIView *container = split.container;
    if (!container) return;
    if (!_recognizer) {
        _recognizer = [[SCPPinchRecognizer alloc] init];
        _recognizer.controller = self;
    }
    if (_recognizer.view != container) {
        [_recognizer.view removeGestureRecognizer:_recognizer];
        [container addGestureRecognizer:_recognizer];
        OMCLogWrite(@"SplitScreen", @"[pinch1] recognizer attached to split container");
    }
    [self syncArming];
}

- (void)detach {
    [_recognizer resetTrackingWithReason:@"teardown"];
    if (_recognizer.view) [_recognizer.view removeGestureRecognizer:_recognizer];
    _armed = NO;
    _recognizer.enabled = NO;
    OMCLogWrite(@"SplitScreen", [NSString stringWithFormat:
        @"[pinch1] session end pairs split complete=%ld truncated=%ld | expanded complete=%ld truncated=%ld",
        (long)_pairsCompleteSplit, (long)_pairsTruncatedSplit,
        (long)_pairsCompleteExpanded, (long)_pairsTruncatedExpanded]);
}

- (void)syncArming {
    SCPCarSplit *split = [SCPCarSplit shared];
    UIView *container = split.container;
    BOOL shouldArm = split.active && container && container.window != nil
                     && _recognizer.view == container;
    if (shouldArm) {
        _armed = YES;
        _recognizer.enabled = YES;
    } else {
        // Reset BEFORE disabling delivery so a live pair is concluded
        // as truncated, never silently dropped (§3.4).
        [_recognizer resetTrackingWithReason:@"disarm"];
        _armed = NO;
        _recognizer.enabled = NO;
    }
}

- (void)resetTracking {
    [_recognizer resetTrackingWithReason:@"session"];
}

#pragma mark Arbiter / mode inputs

- (SCPPinchMode)scpCurrentMode {
    if (!_arbiter) return SCPPinchModeDryRun;  // safe default (bridgewake §4)
    NSInteger mode = [_arbiter pinchMode];
    if (mode < 0 || mode > 2) return SCPPinchModeOff;  // reserved values = OFF
    return (SCPPinchMode)mode;
}

- (BOOL)scpTrackingEnabled {
    return _armed && [self scpCurrentMode] != SCPPinchModeOff;
}

- (NSInteger)scpNextGestureSeq {
    return ++_gestureSeq;
}

- (BOOL)scpHostBucketExpanded {
    return self.adapter.currentState == SCPFullscreenStateExpanded;
}

#pragma mark Allowlist (§3.3 gate 5 / §A4) — (bundleID, scene) keyed; an empty list restricts nothing (the staging-era default-OFF was lifted 2026-11-09 together with the staging itself)

+ (NSString *)scpAllowlistKeyForBundle:(NSString *)bundleID hosted:(BOOL)hosted {
    return [NSString stringWithFormat:@"%@|%@", bundleID, hosted ? @"H" : @"N"];
}

- (void)allowBundle:(NSString *)bundleID hosted:(BOOL)hosted {
    if (bundleID.length) {
        [_allowlistKeys addObject:[SCPPinchController scpAllowlistKeyForBundle:bundleID hosted:hosted]];
    }
}

- (BOOL)isAllowlistedBundle:(NSString *)bundleID hosted:(BOOL)hosted {
    if (!bundleID.length) return NO;
    // §A4 as amended (2026-11-09): the list is a restriction only once
    // it has entries. Empty = every (bundle, scene) passes — pinch is
    // wired live by default now; allowBundle:hosted: remains the way
    // to narrow it back down per app+scene.
    if (_allowlistKeys.count == 0) return YES;
    return [_allowlistKeys containsObject:
        [SCPPinchController scpAllowlistKeyForBundle:bundleID hosted:hosted]];
}

#pragma mark Point -> pane mapping (§2.1)

static BOOL SCPViewIsInHierarchyOf(UIView *view, UIView *ancestor) {
    for (UIView *v = view; v; v = v.superview) {
        if (v == ancestor) return YES;
    }
    return NO;
}

// Slots-walk identical to the container's `touched` block
// (SCPCarSplit.m:305-322): float pane checked first and wins; slots
// scanned in order skipping alpha <= 0; the LAST slot hit wins (the
// block does not break). One conservative addition, in the killing
// direction only: the finger's HIT VIEW is checked first — a finger
// landing on a divider or on pane chrome (handle/bar/cover/loader/
// picker) is dead even where that chrome geometrically overlaps the
// pane's frame, which the pure point walk cannot see. §2.1 already
// requires chrome starts to kill the pair; this is how that rule is
// realised. The check never creates a mapping, it only refuses one.
- (nullable SCPCarPane *)scpPaneForStartPoint:(CGPoint)point
                                   touchView:(nullable UIView *)touchView
                                    deadKind:(SCPPinchDeadKind *)deadKindOut {
    SCPCarSplit *split = [SCPCarSplit shared];
    if (touchView) {
        for (SCPCarDividerView *divider in split.dividers) {
            if (SCPViewIsInHierarchyOf(touchView, divider)) {
                if (deadKindOut) *deadKindOut = SCPPinchDeadDivider;
                return nil;
            }
        }
        for (SCPCarPane *pane in split.allPanes) {
            UIView *chromeViews[5] = { pane.handle, pane.bar, pane.cover,
                                       pane.loader, pane.picker };
            for (int i = 0; i < 5; i++) {
                UIView *chrome = chromeViews[i];
                if (chrome && SCPViewIsInHierarchyOf(touchView, chrome)) {
                    if (deadKindOut) *deadKindOut = SCPPinchDeadChrome;
                    return nil;
                }
            }
        }
    }
    SCPCarPane *floatPane = split.floatPane;
    if (floatPane) {
        UIView *fv = floatPane.view;
        if (fv.alpha > 0 && CGRectContainsPoint(fv.frame, point)) return floatPane;
    }
    SCPCarPane *hit = nil;
    for (SCPCarPane *pane in split.slots) {
        UIView *pv = pane.view;
        if (pv.alpha <= 0) continue;
        if (CGRectContainsPoint(pv.frame, point)) hit = pane;
    }
    if (hit) return hit;
    for (SCPCarDividerView *divider in split.dividers) {
        if (CGRectContainsPoint(divider.frame, point)) {
            if (deadKindOut) *deadKindOut = SCPPinchDeadDivider;
            return nil;
        }
    }
    if (deadKindOut) *deadKindOut = SCPPinchDeadOutside;
    return nil;
}

#pragma mark Pair conclusions (§3.3 fire point + §6.1 probe log)

- (void)scpLogSummaryForRecognizer:(SCPPinchRecognizer *)recognizer
                        wouldPinch:(BOOL)wouldPinch
                             fired:(BOOL)fired
                            reason:(NSString *)reason
                             gates:(NSString *)gates {
    SCPCarPane *pane = recognizer.scpLogPane;
    NSString *scene = pane ? (SCPVCIsHosted(pane.vc) ? @"hosted" : @"native") : @"-";
    NSString *dir = recognizer.scpConclusionDirection == SCPPinchDirectionIn ? @"in" : @"out";
    OMCLogWrite(@"SplitScreen", [NSString stringWithFormat:
        @"[pinch1] pair seq=%ld slot=%d bundle=%@ scene=%@ dir=%@ dist0=%.1f scale=%.3f drift=%.1f gates[%@] wouldPinch=%d fired=%d reason=%@",
        (long)recognizer.seq, pane ? pane.slot : -1, pane.bundleID ?: @"-", scene,
        dir, recognizer.dist0, recognizer.scpScaleExtreme, recognizer.lastMidDrift,
        gates, wouldPinch ? 1 : 0, fired ? 1 : 0, reason ?: @"-"]);
}

// The single fire point (§3.3): reached from the first Moved where the
// geometric conditions hold. Gates are evaluated in the design's order;
// the first failing gate is the recorded death reason.
- (void)scpRecognizerDidCross:(SCPPinchRecognizer *)recognizer {
    if (recognizer.mappingDeath || !recognizer.pairPane) {
        [self scpLogSummaryForRecognizer:recognizer wouldPinch:NO fired:NO
                                  reason:recognizer.mappingDeath ?: @"xpane"
                                   gates:@"m- h- a- c- l- s-"];
        return;
    }
    SCPCarPane *pane = recognizer.pairPane;
    // Gate 1 — PINCH_MODE from the owner (§3.3/§4). OFF at this point
    // means the mode flipped mid-pair; the pair dies here.
    SCPPinchMode mode = [self scpCurrentMode];
    BOOL modeOK = mode != SCPPinchModeOff;
    // Gate 2 — host state vs direction (§3.3, state read from the
    // adapter per §4): SPLIT accepts only pinch-out, EXPANDED only
    // pinch-in. Since fs1 the adapter forwards to
    // SCPFullscreenController, whose settled state is real (Split /
    // Expanded; Unknown only before install), so this gate passes
    // exactly on the matching direction.
    SCPFullscreenState host = self.adapter.currentState;
    BOOL out = recognizer.direction == SCPPinchDirectionOut;
    BOOL hostOK = (out && host == SCPFullscreenStateSplit)
               || (!out && host == SCPFullscreenStateExpanded);
    // Gate 3 — shared Pinch/Wake arbitration (§3.5).
    BOOL suppressed = self.externalChainSuppressed;
    SCPArbiterDisposition disposition = _arbiter
        ? [_arbiter pinchDispositionForPane:pane touchesSuppressed:suppressed]
        : SCPArbiterPinchBlockedUnknown;
    BOOL arbiterOK = disposition == SCPArbiterPinchAllowed;
    // Gate 4 — clean chain (§3.3): no touch of this pair belongs to a
    // chain held by wake suppression.
    BOOL cleanOK = !suppressed;
    // Gate 5 — (bundleID, scene) allowlist (§A4); empty list passes.
    BOOL allowOK = [self isAllowlistedBundle:pane.bundleID
                                      hosted:SCPVCIsHosted(pane.vc)];
    // Final session re-check (§2.2): the assignment may have changed
    // mid-gesture; the locked pane must still be assigned.
    SCPCarSplit *split = [SCPCarSplit shared];
    BOOL sessionOK = split.active && split.container.window != nil
                     && [split.allPanes containsObject:pane];

    BOOL wouldPinch = modeOK && hostOK && arbiterOK && cleanOK && allowOK && sessionOK;
    NSString *reason = wouldPinch ? @"-" :
        !modeOK   ? @"mode-off" :
        !hostOK   ? @"hoststate" :
        !arbiterOK ? (disposition == SCPArbiterPinchBlockedHidden ? @"hidden"
                                                                   : @"arbiter-unknown") :
        !cleanOK  ? @"suppressed" :
        !allowOK  ? @"not-allowlisted" : @"session";
    NSString *gates = [NSString stringWithFormat:@"m%@ h%@ a%@ c%@ l%@ s%@",
        modeOK ? @"1" : @"0", hostOK ? @"1" : @"0", arbiterOK ? @"1" : @"0",
        cleanOK ? @"1" : @"0", allowOK ? @"1" : @"0", sessionOK ? @"1" : @"0"];

    BOOL fired = NO;
    if (mode == SCPPinchModeEnforce && wouldPinch) {
        fired = YES;
        if (out) {
            [self.adapter requestExpandWithCompletion:^(BOOL applied) {
                OMCLogWrite(@"SplitScreen", [NSString stringWithFormat:
                    @"[pinch1] adapter expand completion applied=%d", applied ? 1 : 0]);
            }];
        } else {
            [self.adapter requestRestoreWithCompletion:^(BOOL applied) {
                OMCLogWrite(@"SplitScreen", [NSString stringWithFormat:
                    @"[pinch1] adapter restore completion applied=%d", applied ? 1 : 0]);
            }];
        }
    }
    [self scpLogSummaryForRecognizer:recognizer wouldPinch:wouldPinch
                               fired:fired reason:reason gates:gates];
}

- (void)scpRecognizerPairDissolved:(SCPPinchRecognizer *)recognizer {
    [self scpLogSummaryForRecognizer:recognizer wouldPinch:NO fired:NO
                              reason:recognizer.mappingDeath ?: @"no-cross"
                               gates:@"m- h- a- c- l- s-"];
}

- (void)scpRecognizerPairKilled:(SCPPinchRecognizer *)recognizer reason:(NSString *)reason {
    [self scpLogSummaryForRecognizer:recognizer wouldPinch:NO fired:NO
                              reason:reason
                               gates:@"m- h- a- c- l- s-"];
}

- (void)scpRecognizerPairFinished:(SCPPinchRecognizer *)recognizer complete:(BOOL)complete {
    if (recognizer.bucketExpanded) {
        if (complete) _pairsCompleteExpanded++; else _pairsTruncatedExpanded++;
    } else {
        if (complete) _pairsCompleteSplit++; else _pairsTruncatedSplit++;
    }
}

@end
