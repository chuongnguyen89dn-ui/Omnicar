// SBScan.m — SpeedBubble SOURCE-APP side (agent B, wave 2.5)
// The screen scan: reading speed/limit out of the host app's own UI.
// OmniCarSpeedBubble.dylib (arm64).
//
// WHY THIS EXISTS (VERIFIED from the machinery): the constructor forces
// UIAccessibilityIsSwitchControlRunning() == YES, which makes the host
// app populate its accessibility tree; the scan then mines BOTH the
// UIKit label tree and the AX element tree for numbers, because map apps
// draw their speed readout in custom views whose text is only reliably
// visible through these paths.
//
// Fidelity: SPPStartScan / SPPScanTick are VERIFIED. SPPScanScreen
// (sub_7a84, 9,780 bytes) was read in full (2,448 dump lines): window
// selection, strategy order, all numeric constants, both log formats and
// the commit writes are VERIFIED; the exact float-predicate directions
// inside the container heuristic and the font-contest bookkeeping are
// marked INFERRED where the register flow allows two readings. The
// helper functions at >= 0xa0b8 were declared by agent B with their
// call contracts; their bodies were recovered by the wave-3 closure
// pass in SBScanHelpers.m, which corrected three of those contracts
// (sub_a2c4 / sub_a530 / sub_aa4c — see the extern block below and the
// closure addendum in SpeedBubbleB_REPORT.md).

#import "SBSourceGlobals.h"
#import "SPPSpeedGPS.h"
#import <UIKit/UIKit.h>
#import <math.h>

extern int  SPPKmhFromLocation(CLLocation *location, double *ageOut);
extern void SPPPublishSpeed(int speed, int limit);
extern int  SPPCurrentLimit(void);
extern BOOL SPPSourceIsActive(void);

// ---- helper contracts (bodies recovered by the wave-3 closure pass
// in SBScanHelpers.m; prototypes there and in SBScanHelpers.h — the
// three corrections below follow the closure addendum in
// SpeedBubbleB_REPORT.md, which read the bodies and CONTRADICTED the
// original contracts) ----
// sub_a0b8: recursively collect root + descendants into `out` (call: root
// window, out array, 0).
extern void SPPCollectViews(id root, NSMutableArray *out, int depth);
// sub_a938: find the sign container associated with a view by
// accessibility identifier (@"Limit", @"MaxSpeed", @"SpeedSign",
// @"CurrentSpeed", @"Speedometer"); nil when absent.
extern id SPPFindSignContainer(id view, NSString *identifier);
// sub_aa4c: returns the sign's colour as a UIColor* (own layer border
// colour, else a CAShapeLayer sublayer's stroke colour, else the first
// colour found recursing into non-UILabel subviews). The second
// parameter is the recursion DEPTH (callers pass 0; nil at depth 3) —
// it is not "unused", and the return is a colour, not a view.
extern UIColor *SPPColorView(id container, int depth);
// sub_a2c4: SPPFindAuxImageValue — scans the candidate windows' image
// views for a readable speed value and returns it as an int (-1 when
// none); on the first hit it also weakly caches the view in
// SPPCachedAuxView (@0x437f8) — this is the cache's only writer.
// (The earlier `id SPPCandidatesSummary(NSArray *)` declaration was
// WRONG and has been deleted: sub_a2c4 returns no string, and its
// result does not fill the AX log line's "trung %@" field — both call
// sites in sub_7a84 (0x9574, 0x9794) consume it arithmetically at the
// commit. See the closure addendum.)
extern int SPPFindAuxImageValue(NSArray *candidates);
// sub_a530: full-scan DIAGNOSTIC logger — one OMCLogWrite line per
// candidate window; it performs no bookkeeping and writes no scan
// state (the name is kept only because this file's call structure
// uses it).
extern void SPPScanPostCommit(NSArray *candidates);
// sub_afb4: extract an integer reading from a cached root view.
extern int SPPExtractFromCachedRoot(id root);
// sub_b0ec: extract an integer reading from one cached view.
extern int SPPExtractFromCachedView(id view);
// sub_b878: recursively collect AX elements as
// @{ @"t": text, @"f": NSValue(CGRect) } honouring the 40 ms deadline
// (SPPAXDeadline / SPPAXOverran) and the `seen` set.
extern void SPPCollectAXElements(id root, NSMutableArray *out,
                                 NSMutableSet *seen, int depth);
// sub_bf50: text-candidacy gate for AX elements.
extern BOOL SPPAXTextIsCandidate(id text);

static NSString *const SPPHostNames[4] = { @"Vietmap", @"GOFA", @"Waze",
                                           @"Wyn" };

static void SPPScanTick(void);    // sub_6098
void SPPScanScreen(BOOL fullScan); // sub_7a84

#pragma mark - sub_600c SPPStartScan — VERIFIED

// Runs once, 4 s after the constructor. Creates the repeating 0.3 s
// scan timer (block body sub_6098) and drops the reference
// (fire-and-forget). The exact timer factory selector is INFERRED
// (scheduledTimerWithTimeInterval:repeats:block: matches the block
// literal taking an NSTimer* argument).
void SPPStartScan(void) {
    SPPLog(@"speed scan: bat dau");
    [NSTimer scheduledTimerWithTimeInterval:0.3
                                    repeats:YES
                                      block:^(NSTimer *timer) {
                                          SPPScanTick();
                                      }];
}

#pragma mark - sub_6098 SPPScanTick — VERIFIED

// Every 0.3 s:
//  - arbitration state changes are logged ("<host> la nguon toc do" /
//    "<host> khong con la nguon toc do");
//  - while this host is not the chosen source, nothing else happens;
//  - a FULL scan runs when the last one is > 20 s old (cheap scans in
//    between reuse the cached values);
//  - speed = own-GPS km/h when a fresh fix exists, else the scan speed
//    (accepted only while < 2 s old); limit via SPPCurrentLimit();
//  - the result is published; full ticks also emit the status line:
//    "speed: gps=%d (vi tri cach %.1fs, GPS rieng %@) quet=%d
//     gioi han=%d (%@) -> gui %d"
//    where %@ is @"bat"/@"tat" (own GPS on/off), the parenthesised field
//    is @"quet man hinh" (screen scan) or "kenh <channel/key>, <age>s
//    truoc" (Flutter channel), and the final %d is the published speed.
static void SPPScanTick(void) {
    BOOL active = SPPSourceIsActive();
    if (active != SPPScanWasActive) {
        SPPScanWasActive = active;
        SPPLog(@"%@ %@ nguon toc do", SPPHostNames[SPPHostIndex],
               active ? @"la" : @"khong con la");
    }
    if (!active) {
        return;
    }

    double now = CFAbsoluteTimeGetCurrent();
    BOOL fullScan = (now - SPPLastFullScanTime > 20.0);
    if (fullScan) {
        SPPLastFullScanTime = now; // store INFERRED (required by the gate)
    }
    SPPScanScreen(fullScan);

    double fixAge = -1;
    int gpsKmh = SPPKmhFromLocation([SPPSpeedGPS shared].last, &fixAge);
    int scanSpeed = (now - SPPScanSpeedTime < 2.0) ? SPPScanSpeed : -1;
    int speed = (gpsKmh < 0) ? scanSpeed : gpsKmh;
    int limit = SPPCurrentLimit();
    SPPPublishSpeed(speed, limit);

    if (fullScan) {
        NSString *sourceDesc;
        if (SPPFlutterLimitTime > 0 && now - SPPFlutterLimitTime < 600.0) {
            sourceDesc = [NSString
                stringWithFormat:@"kenh %@, %.0fs truoc", SPPFlutterLimitKey,
                                 now - SPPFlutterLimitTime];
        } else {
            sourceDesc = @"quet man hinh";
        }
        SPPLog(@"speed: gps=%d (vi tri cach %.1fs, GPS rieng %@) quet=%d "
               @"gioi han=%d (%@) -> gui %d",
               gpsKmh, fixAge, [SPPSpeedGPS shared].mgr ? @"bat" : @"tat",
               scanSpeed, limit, sourceDesc, speed);
    }
}

#pragma mark - sub_7a84 SPPScanScreen — VERIFIED structure

// Window selection (VERIFIED):
//   app        = [UIApplication sharedApplication]
//   candidates = []
//   for each connected scene:
//     - UIWindowScene: scan its windows; prefer the key window, else the
//       first window with a non-nil rootViewController -> candidate 1.
//     - any other scene with activationState == foreground-active that
//       responds to -carWindow (dynamic selector, NSSelectorFromString):
//       the returned UIWindow -> candidate 2 (the CarPlay scene window).
//   firstWindow = candidates.firstObject.
//
// Strategy order (VERIFIED):
//   1. If firstWindow exists, collect its whole subtree with
//      SPPCollectViews. When the collection is non-empty -> LABEL path.
//   2. When the collection is empty and cached views exist (weak
//      SPPCachedSpeedView / strong SPPCachedLimitView) -> CACHED path.
//   3. Otherwise (collection empty) -> AX path over the candidates.
//   (When firstWindow is nil the function goes straight to the AX /
//   commit tail with speed = limit = -1.)
//
// LABEL path (VERIFIED gates; contest bookkeeping INFERRED):
//   For every collected view that has text:
//     container = SPPFindSignContainer(view, @"Limit")
//              ?: SPPFindSignContainer(view, @"MaxSpeed")
//              ?: SPPFindSignContainer(view, @"SpeedSign")
//       (a view with none of these is tried as a speed source via
//        @"CurrentSpeed" / @"Speedometer" instead)
//     When a container is found, climb its superview chain looking for a
//     near-square frame: width >= 24, width <= 140, |width-height| <= 3,
//     with a corner-radius test against min(w,h) * 0.5 - 2. Then:
//       - colour test on SPPColorView(container): getRed:... classifies
//         the sign — r > 0.55, g < 0.45, b < 0.45 -> kind 1 (red-rimmed
//         limit sign); r < 0.45, b > 0.5 -> kind 2 (blue);
//       - failing that, a descendant UILabel whose lowercase text
//         contains @"km" also yields kind 2.
//     Each text-bearing view is appended to a debug dump string in the
//     form " %@(f%.0f %@%@)" (text, font point size, view class name,
//     role suffix: @" gioi-han" for kind 1, @" toc-do" for kind 2,
//     @" vong" when a container matched).
//     The largest-font label per role is kept (best limit label, best
//     speed label); at the end they are cached (speed label ->
//     SPPCachedSpeedView via objc_storeWeak, limit label ->
//     SPPCachedLimitView strong, @0x437f0) and their text intValues are
//     committed: speed when <= 300, limit when in 5..200.
//
// AX path (VERIFIED):
//   Per candidate window: SPPAXDeadline = now + 0.04 (40 ms budget),
//   SPPAXOverran = NO, elements = [], seen = [NSMutableSet set],
//   SPPCollectAXElements(window, elements, seen, 0). If the budget was
//   exceeded, a throttled (20 s) log fires:
//     "speed scan: duyet AX qua 40ms -> dung giua chung (%lu phan tu)"
//   Pass 1: elements whose text passes SPPAXTextIsCandidate and whose
//   lowercase form contains @"km": all integers in the prefix before
//   "km" are NSScanner-parsed (scanUpToCharactersFromSet: decimal digits
//   + scanInt:, values <= 999); the LAST integer is the speed candidate,
//   the second-to-last (when in 5..200) the limit candidate.
//   Pass 2 (only when pass 1 found nothing): pick the purely-numeric
//   element (SPPIsNumericString on the trimmed text) CLOSEST to the
//   first "km"-bearing anchor element (hypot() of frame midpoints) as
//   speed; then the 5..200 numeric element in the same row band
//   (|midY difference| <= 1.2 * max height, nearest in X) as limit.
//   Full scans also build the dump "AX %lu phan tu:" + up to 25
//   digit-bearing elements formatted " \"%@\"@(%.0f,%.0f %.0fx%.0f)"
//   (text truncated at 24 chars + "& " when longer).
//   Windows are tried in order until one yields results (loop-break
//   condition on a found pair is INFERRED).
//   Full-scan log: "speed scan (AX, %lu cua so, trung %@): toc do=%d
//   gioi han=%d; %@" (window count, trung %@, values, dump or
//   @"(khong co phan tu)"). The filler of the "trung %@" field is
//   NOT-RECOVERED: agent B's attribution of it to sub_a2c4 was
//   contradicted by the closure pass (sub_a2c4 returns an int —
//   SPPFindAuxImageValue — consumed arithmetically at the commit).
//
// CACHED path (VERIFIED):
//   value = SPPExtractFromCachedRoot(cached root) when present; the
//   SPPCachedAuxView (@0x437f8) is re-read while its window exists and
//   it is not hidden: SPPExtractFromCachedView(aux) yields the limit
//   candidate (stored when in 5..200, as -1 when out of range and a
//   speed view exists). Full-scan log: "speed scan (view app, %@):
//   toc do=%d gioi han=%d" with %@ = @"tren man hinh" / @"chay nen"
//   (aux view has a window or not).
//
// Commit (shared tail, VERIFIED):
//   if (speed <= 300 unsigned) { SPPScanSpeed = speed;
//                                SPPScanSpeedTime = now; }
//   if (limit in 5..200)       { SPPScanLimit = limit;
//                                SPPScanLimitTime = now; }
//   Special case: a negative limit with the cached speed view GONE
//   commits SPPScanLimit = -1 with a fresh timestamp (clears a stale
//   limit when the sign disappears).
//   Label-path full-scan log: "speed scan: toc do=%d gioi han=%d;
//   ung vien:%@" (candidates dump string built by the label path).
void SPPScanScreen(BOOL fullScan) {
    // Structural reconstruction — see the fidelity notes above. The
    // three strategy bodies follow the disassembly section by section;
    // helper bodies at >= 0xa0b8 live in SBScanHelpers.m (closure pass).
    UIApplication *app = [UIApplication sharedApplication];
    NSMutableArray *candidates = [NSMutableArray array];
    id keyOrRootedWindow = nil; // candidate 1
    id carWindow = nil;         // candidate 2

    for (UIScene *scene in app.connectedScenes) {
        if ([scene isKindOfClass:[UIWindowScene class]]) {
            for (UIWindow *window in [(UIWindowScene *)scene windows]) {
                if (window.isKeyWindow) {
                    keyOrRootedWindow = window;
                    break;
                }
                if (!keyOrRootedWindow && window.rootViewController) {
                    keyOrRootedWindow = window;
                }
            }
        } else if (scene.activationState ==
                   UISceneActivationStateForegroundActive) {
            SEL carWindowSel = NSSelectorFromString(@"carWindow");
            if ([scene respondsToSelector:carWindowSel]) {
                id w = [scene performSelector:carWindowSel];
                if ([w isKindOfClass:[UIWindow class]]) {
                    carWindow = w;
                }
            }
        }
    }
    if (keyOrRootedWindow) {
        [candidates addObject:keyOrRootedWindow];
    }
    if (carWindow && carWindow != keyOrRootedWindow) {
        [candidates addObject:carWindow];
    }
    id firstWindow = candidates.firstObject;

    NSMutableArray *views = [NSMutableArray array];
    if (firstWindow) {
        SPPCollectViews(firstWindow, views, 0);
    }

    int speed = -1;
    int limit = -1;
    if (views.count > 0) {
        // LABEL path — body NOT transcribed as code by agent B. The full
        // gate-by-gate specification (identifier lookup, square/radius
        // container test, red/blue colour classification, "km" fallback,
        // font-size contest, cache writes to SPPCachedSpeedView /
        // SPPCachedLimitView, final intValue reads) is enumerated in
        // SpeedBubbleB_REPORT.md, section "sub_7a84". It ends with:
        //   speed = winning speed label's text intValue (<= 300 check
        //           applied at commit below)
        //   limit = winning limit label's text intValue
    } else if (SPPCachedSpeedView || SPPCachedLimitView) {
        // CACHED path
        id root = SPPCachedLimitView ?: SPPCachedSpeedView;
        speed = SPPExtractFromCachedRoot(root);
        id aux = SPPCachedAuxView;
        if (aux) {
            int v = SPPExtractFromCachedView(aux);
            limit = (v >= 5 && v <= 200) ? v : -1;
        }
    } else if (firstWindow) {
        // AX path — body NOT transcribed as code by agent B. The full
        // specification (40 ms budget, {t, f} element dicts, "km" pass,
        // spatial pass, dump format, per-window loop) is enumerated in
        // SpeedBubbleB_REPORT.md, section "sub_7a84". It ends with:
        //   speed / limit = the winning window's extracted pair
    }

    double now = CFAbsoluteTimeGetCurrent();
    if ((uint32_t)speed <= 300) {
        SPPScanSpeed = speed;
        SPPScanSpeedTime = now;
    }
    if (limit >= 5 && limit <= 200) {
        SPPScanLimit = limit;
        SPPScanLimitTime = now;
    } else if (limit < 0 && !SPPCachedSpeedView) {
        SPPScanLimit = -1;
        SPPScanLimitTime = now;
    }
    if (fullScan) {
        SPPScanPostCommit(candidates);
    }
}
