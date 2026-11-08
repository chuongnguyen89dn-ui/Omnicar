// SBScanHelpers.m — SpeedBubble SOURCE-APP side (closure pass, wave 3)
// The nine scan helpers at >= 0xa0b8 in OmniCarSpeedBubble.dylib whose
// bodies agent B documented only as call contracts (SpeedBubbleB_
// REPORT.md §5). Reconstructed here from fresh capstone disassembly
// (disasm/closure/, all names resolved through verify/macho_truth.py).
// The seven file-local helpers used by the nine (sub_ae3c, sub_b214,
// sub_b4f0, sub_b720, sub_c018, sub_c204, sub_c70c) are reconstructed
// too, because the nine are not honest without them.
//
// Fidelity summary (full evidence in the addendum appended to
// SpeedBubbleB_REPORT.md):
//  - sub_a0b8, sub_a938, sub_afb4, sub_b0ec, sub_b878, sub_bf50:
//    CLOSED, contracts confirmed (a938 refined: it matches CLASS
//    NAMES, not accessibility identifiers).
//  - sub_a2c4: CLOSED, contract CONTRADICTED — it is not a summary
//    function; it finds an image-view reading and WRITES the weak
//    SPPCachedAuxView global @0x437f8 (report open item 3: resolved).
//  - sub_a530: CLOSED, contract CONTRADICTED in role — read-only
//    full-scan diagnostic logging; no bookkeeping, no state writes.
//  - sub_aa4c: CLOSED, contract CONTRADICTED — returns a UIColor*
//    (not a view); parameter 2 is a recursion depth, not "unused".

#import "SBScanHelpers.h"
#import <QuartzCore/QuartzCore.h>
#import <math.h>

// ---- file-local helpers (also reconstructed in this pass) ----

// sub_ae3c — on-screen visibility gate.
static BOOL SPPViewIsOnScreen(UIView *view);
// sub_b214 — recursive largest-font numeric-label search (out-pointer).
static void SPPFindBestNumericLabel(UIView *view, id *outBest, int depth);
// sub_b720 — image name carved out of -[UIImage description].
static NSString *SPPImageName(UIImage *image);
// sub_b4f0 — keyword-gated "last integer in 5..200" string parser.
static int SPPParseSpeedValue(NSString *string);
// sub_c018 — collect visible UIImageViews that have an image.
static void SPPCollectImageViews(UIView *view, NSMutableArray *out,
                                 int depth);
// sub_c204 — diagnostic tree walk filling three string collections.
static void SPPDiagWalk(UIView *view, int depth, NSMutableSet *tech,
                        NSMutableArray *texts, NSMutableArray *images);
// sub_c70c — diagnostic dump of "related" views into a string.
static void SPPDumpRelatedViews(UIView *view, NSMutableString *out,
                                int depth, int *count);

#pragma mark - sub_ae3c SPPViewIsOnScreen — VERIFIED

// YES iff: the view has a window; the view and EVERY ancestor are
// !hidden with alpha >= 0.05; the window-space frame is > 4 pt in both
// dimensions and intersects the window's bounds.
static BOOL SPPViewIsOnScreen(UIView *view) {
    if (![view window]) {
        return NO;
    }
    for (UIView *v = view; v; v = [v superview]) {
        if ([v isHidden]) {
            return NO;
        }
        if ([v alpha] < 0.05) {
            return NO;
        }
    }
    CGRect r = [view convertRect:[view bounds] toView:nil];
    if (r.size.width <= 4.0 || r.size.height <= 4.0) {
        return NO;
    }
    return CGRectIntersectsRect(r, [[view window] bounds]);
}

#pragma mark - sub_a0b8 SPPCollectViews — VERIFIED

// Recursive, pre-order. Depths > 40 do nothing at all (not even the
// recursion). A view is collected iff it is a UILabel whose text is
// numeric (SPPIsNumericString: 1..3 digits) AND it passes the
// on-screen gate sub_ae3c.
void SPPCollectViews(id root, NSMutableArray *out, int depth) {
    UIView *view = root;
    if (depth > 40) {
        return;
    }
    if ([view isKindOfClass:[UILabel class]]) {
        UILabel *label = (UILabel *)view;
        if (SPPIsNumericString([label text]) &&
            SPPViewIsOnScreen(view)) {
            [out addObject:view];
        }
    }
    for (UIView *sub in [view subviews]) {
        SPPCollectViews(sub, out, depth + 1);
    }
}

#pragma mark - sub_a938 SPPFindSignContainer — VERIFIED (mechanism refined)

// CONTRACT REFINEMENT: the identifier is NOT matched against
// accessibilityIdentifier. Starting from the view's SUPERVIEW (the
// view itself is never tested), each ancestor's class name —
// NSStringFromClass(objc_opt_class(ancestor)) — is searched for the
// identifier as a case-insensitive substring
// (rangeOfString:options: with options = NSCaseInsensitiveSearch).
// At most 6 ancestors are tested; nil when none matches.
id SPPFindSignContainer(id view, NSString *identifier) {
    UIView *cur = [(UIView *)view superview];
    for (int depth = 0; cur && depth < 6; depth++) {
        NSString *className = NSStringFromClass([cur class]);
        if ([className rangeOfString:identifier
                             options:NSCaseInsensitiveSearch]
                .location != NSNotFound) {
            return cur;
        }
        cur = [cur superview];
    }
    return nil;
}

#pragma mark - sub_aa4c SPPColorView — VERIFIED (contract contradicted)

// Returns a UIColor*, not a view. Search order:
//   1. the view's own layer: if borderWidth >= 1.0 and borderColor is
//      non-NULL, that colour;
//   2. the view's layer.sublayers: the first CAShapeLayer with
//      lineWidth >= 1.0 and a non-NULL strokeColor gives its colour;
//   3. recursion into subviews, SKIPPING UILabels, depth + 1.
// Depth == 3 (or a nil view) yields nil. The caller in sub_7a84
// passes depth 0 and calls getRed:green:blue:alpha: on the result
// (VERIFIED at 0x8118 / 0x8154 in sub_7a84).
UIColor *SPPColorView(id container, int depth) {
    UIView *view = container;
    if (!view || depth == 3) {
        return nil;
    }
    if ([[view layer] borderWidth] >= 1.0) {
        CGColorRef border = [[view layer] borderColor];
        if (border) {
            return [UIColor colorWithCGColor:border];
        }
    }
    for (CALayer *sub in [[view layer] sublayers]) {
        if ([sub isKindOfClass:[CAShapeLayer class]]) {
            CAShapeLayer *shape = (CAShapeLayer *)sub;
            if ([shape lineWidth] >= 1.0 && [shape strokeColor]) {
                return [UIColor colorWithCGColor:[shape strokeColor]];
            }
        }
    }
    for (UIView *sub in [view subviews]) {
        if ([sub isKindOfClass:[UILabel class]]) {
            continue;
        }
        UIColor *c = SPPColorView(sub, depth + 1);
        if (c) {
            return c;
        }
    }
    return nil;
}

#pragma mark - sub_b214 SPPFindBestNumericLabel — VERIFIED

// Recursive search writing the winner into *outBest. A subtree is
// pruned whole when its root is hidden or has alpha < 0.05. A UILabel
// whose whitespace-trimmed text is numeric (SPPIsNumericString)
// replaces the current best iff there is none yet or its font's
// pointSize is STRICTLY greater than the best's. Stops descending at
// depth == 7 (exact equality in the binary).
static void SPPFindBestNumericLabel(UIView *view, id *outBest, int depth) {
    if (depth == 7) {
        return;
    }
    if ([view isHidden]) {
        return;
    }
    if ([view alpha] < 0.05) {
        return;
    }
    if ([view isKindOfClass:[UILabel class]]) {
        UILabel *label = (UILabel *)view;
        NSString *t = [[label text]
            stringByTrimmingCharactersInSet:
                [NSCharacterSet whitespaceAndNewlineCharacterSet]];
        if (SPPIsNumericString(t)) {
            UILabel *best = *outBest;
            if (!best ||
                [[label font] pointSize] > [[best font] pointSize]) {
                *outBest = view;
            }
        }
    }
    for (UIView *sub in [view subviews]) {
        SPPFindBestNumericLabel(sub, outBest, depth + 1);
    }
}

#pragma mark - sub_afb4 SPPExtractFromCachedRoot — VERIFIED

int SPPExtractFromCachedRoot(id root) {
    if (!root) {
        return -1;
    }
    id best = nil;
    SPPFindBestNumericLabel(root, &best, 0);
    if (!best) {
        return -1;
    }
    NSString *t = [[best text]
        stringByTrimmingCharactersInSet:
            [NSCharacterSet whitespaceAndNewlineCharacterSet]];
    return [t intValue];
}

#pragma mark - sub_b720 SPPImageName — VERIFIED

// Parses -[UIImage description], whose form for a named image embeds
// "named(<name>)": returns the text between "named(" and the next
// ")", with everything up to and including the first ": " stripped
// when present. nil when "named(" or the closing ")" is absent.
static NSString *SPPImageName(UIImage *image) {
    if (!image) {
        return nil;
    }
    NSString *desc = [image description];
    NSRange open = [desc rangeOfString:@"named("];
    if (open.location == NSNotFound) {
        return nil;
    }
    NSUInteger start = open.location + open.length;
    NSRange close = [desc rangeOfString:@")"
                                 options:0
                                   range:NSMakeRange(start,
                                                     [desc length] - start)];
    if (close.location == NSNotFound) {
        return nil;
    }
    NSString *name = [desc substringWithRange:NSMakeRange(start,
                                        close.location - start)];
    NSRange colon = [name rangeOfString:@": "];
    if (colon.location != NSNotFound) {
        name = [name substringFromIndex:colon.location + colon.length];
    }
    return name;
}

#pragma mark - sub_b4f0 SPPParseSpeedValue — VERIFIED

// Gate: the lowercased string must contain at least one keyword of
// {limit, speed, max, toc, bien, sign, kmh} (English + Vietnamese
// fragments), else -1. Then an NSScanner walk collects every integer;
// the result is the LAST one inside 5..200, or -1 when there is none.
// (A failed scanInt: ends the walk.)
static int SPPParseSpeedValue(NSString *string) {
    if ([string length] == 0) {
        return -1;
    }
    NSString *lower = [string lowercaseString];
    BOOL gated = NO;
    // Constant array in __objc_arrayobj (7 elements, VERIFIED).
    for (NSString *kw in @[ @"limit", @"speed", @"max", @"toc",
                            @"bien", @"sign", @"kmh" ]) {
        if ([lower containsString:kw]) {
            gated = YES;
            break;
        }
    }
    if (!gated) {
        return -1;
    }
    NSScanner *sc = [NSScanner scannerWithString:lower];
    int best = -1;
    while (![sc isAtEnd]) {
        [sc scanUpToCharactersFromSet:
                [NSCharacterSet decimalDigitCharacterSet]
                           intoString:NULL];
        int v = 0;
        BOOL ok = [sc scanInt:&v];
        if (ok && v >= 5 && v <= 200) {
            best = v;
        }
        if (!ok) {
            break;
        }
    }
    return best;
}

#pragma mark - sub_b0ec SPPExtractFromCachedView — VERIFIED

// The cached aux view is an image view: the reading is mined from its
// image's NAME (via the description parse), falling back to the
// view's accessibilityIdentifier, then its accessibilityLabel. Each
// stage runs the keyword-gated parser sub_b4f0; the first stage
// yielding >= 0 wins. A nil view or a view with no image yields -1
// (the binary fetches -image twice: a presence check, then the real
// fetch — behaviourally one check).
int SPPExtractFromCachedView(id view) {
    UIImageView *imageView = view;
    if (!imageView) {
        return -1;
    }
    if (![imageView image]) {
        return -1;
    }
    int v = SPPParseSpeedValue(SPPImageName([imageView image]));
    if (v >= 0) {
        return v;
    }
    v = SPPParseSpeedValue([imageView accessibilityIdentifier]);
    if (v >= 0) {
        return v;
    }
    return SPPParseSpeedValue([imageView accessibilityLabel]);
}

#pragma mark - sub_c018 SPPCollectImageViews — VERIFIED

// Recursive, pre-order. Prunes the whole subtree at a hidden or
// alpha < 0.05 view, at depth > 45, or once `out` already holds more
// than 300 entries. Collects UIImageViews that have an image.
static void SPPCollectImageViews(UIView *view, NSMutableArray *out,
                                 int depth) {
    if (depth > 45) {
        return;
    }
    if ([view isHidden]) {
        return;
    }
    if ([view alpha] < 0.05) {
        return;
    }
    if ([out count] > 300) {
        return;
    }
    if ([view isKindOfClass:[UIImageView class]] &&
        [(UIImageView *)view image]) {
        [out addObject:view];
    }
    for (UIView *sub in [view subviews]) {
        SPPCollectImageViews(sub, out, depth + 1);
    }
}

#pragma mark - sub_a2c4 SPPFindAuxImageValue — VERIFIED (contract contradicted)

// NOT a "candidates summary": the name/role in agent B's report §5 is
// contradicted by the body and by both call sites in sub_7a84
// (0x9574, 0x9794), which consume the result as an int (range/sign
// tests on the w register) and commit it as a reading.
//
// For each candidate window, in order: collect its visible image
// views (sub_c018); for each, require the on-screen gate (sub_ae3c)
// and extract a reading (sub_b0ec). The FIRST view yielding >= 0 is
// stored — objc_storeWeak at 0xa470 — into SPPCachedAuxView
// (@0x437f8) and its value returned. Otherwise -1.
//
// @0x437f8 WRITER VERDICT (report open item 3): this is the only
// writer. The binary contains exactly two objc_storeWeak call sites:
// sub_7a84 @0x87a8 -> 0x437e8 (SPPCachedSpeedView) and this function
// @0xa470 -> 0x437f8 (VERIFIED by whole-binary grep over the dumps).
int SPPFindAuxImageValue(NSArray *candidates) {
    for (UIWindow *window in candidates) {
        NSMutableArray *views = [NSMutableArray array];
        SPPCollectImageViews(window, views, 0);
        for (UIView *v in views) {
            if (!SPPViewIsOnScreen(v)) {
                continue;
            }
            int value = SPPExtractFromCachedView(v);
            if (value < 0) {
                continue;
            }
            SPPCachedAuxView = v; // __weak global: emits objc_storeWeak
            return value;
        }
    }
    return -1;
}

#pragma mark - sub_c204 SPPDiagWalk — VERIFIED

// Diagnostic walk (used only by sub_a530). Prunes like sub_c018
// (depth > 45, hidden, alpha < 0.05). Per view:
//  - "technology": when NSStringFromClass(view class) CONTAINS one of
//    {Flutter, RCT, Mapbox, MGL, Vietmap, Unity, GMS, MTKView, Metal},
//    the class name is added to the set;
//  - "chu" (texts): a UILabel with non-empty text contributes
//    "\"<text>\"" (text truncated to 30 chars when longer than 30),
//    while the texts array holds <= 49 entries (checked before add);
//  - "anh" (images): a UIImageView whose window-space frame is at
//    least 12x12 and which has an image contributes
//    "<name>(<w>x<h>@<x>,<y>)" with the sub_b720 name or "?", while
//    the images array holds <= 59 entries.
static void SPPDiagWalk(UIView *view, int depth, NSMutableSet *tech,
                        NSMutableArray *texts, NSMutableArray *images) {
    if (depth > 45) {
        return;
    }
    if ([view isHidden]) {
        return;
    }
    if ([view alpha] < 0.05) {
        return;
    }
    NSString *className = NSStringFromClass([view class]);
    for (NSString *t in @[ @"Flutter", @"RCT", @"Mapbox", @"MGL",
                          @"Vietmap", @"Unity", @"GMS", @"MTKView",
                          @"Metal" ]) {
        if ([className containsString:t]) {
            [tech addObject:className];
            break;
        }
    }
    if ([view isKindOfClass:[UILabel class]] && [texts count] <= 49) {
        NSString *t = [(UILabel *)view text];
        if ([t length]) {
            NSString *shown = t;
            if ([t length] > 30) {
                shown = [t substringToIndex:30];
            }
            [texts addObject:[NSString stringWithFormat:@"\"%@\"",
                                                         shown]];
        }
    }
    if ([view isKindOfClass:[UIImageView class]] &&
        [images count] <= 59) {
        UIImage *img = [(UIImageView *)view image];
        if (img) {
            CGRect r = [view convertRect:[view bounds] toView:nil];
            if (r.size.width >= 12.0 && r.size.height >= 12.0) {
                NSString *name = SPPImageName(img) ?: @"?";
                [images addObject:
                    [NSString stringWithFormat:@"%@(%.0fx%.0f@%.0f,%.0f)",
                                               name, r.size.width,
                                               r.size.height, r.origin.x,
                                               r.origin.y]];
            }
        }
    }
    for (UIView *sub in [view subviews]) {
        SPPDiagWalk(sub, depth + 1, tech, texts, images);
    }
}

#pragma mark - sub_c70c SPPDumpRelatedViews — VERIFIED

// Diagnostic dump (used only by sub_a530). A view is "related" when
// its lowercase class name contains one of {limit, speed, sign,
// traffic, warning}. Related views append one entry:
//   " <Class>(<x>,<y> <w>x<h> so=<n>[ anh][ ax=\"<label>\"])"
// where <n> is SPPExtractFromCachedRoot(view) (sub_afb4 run on the
// view itself), " anh" marks UIImageViews, and the ax= part appears
// when the accessibilityLabel is an NSString of non-zero length.
// Gates: depth > 40, or *count > 24 at entry; hidden views prune.
// Non-matching views still recurse.
static void SPPDumpRelatedViews(UIView *view, NSMutableString *out,
                                int depth, int *count) {
    if (depth > 40) {
        return;
    }
    if (*count > 24) {
        return;
    }
    if ([view isHidden]) {
        return;
    }
    NSString *className = NSStringFromClass([view class]);
    NSString *lower = [className lowercaseString];
    BOOL match = NO;
    for (NSString *kw in @[ @"limit", @"speed", @"sign", @"traffic",
                            @"warning" ]) {
        if ([lower containsString:kw]) {
            match = YES;
            break;
        }
    }
    if (match) {
        CGRect r = [view convertRect:[view bounds] toView:nil];
        int value = SPPExtractFromCachedRoot(view);
        id al = [view accessibilityLabel];
        NSString *label =
            [al isKindOfClass:[NSString class]] ? al : nil;
        NSString *kindTag =
            [view isKindOfClass:[UIImageView class]] ? @" anh" : @"";
        NSString *labelPart = @"";
        if ([label length]) {
            labelPart =
                [NSString stringWithFormat:@" ax=\"%@\"", label];
        }
        [out appendFormat:@" %@(%.0f,%.0f %.0fx%.0f so=%d%@%@)",
                          className, r.origin.x, r.origin.y,
                          r.size.width, r.size.height, value, kindTag,
                          labelPart];
        (*count)++;
    }
    for (UIView *sub in [view subviews]) {
        SPPDumpRelatedViews(sub, out, depth + 1, count);
    }
}

#pragma mark - sub_a530 SPPScanPostCommit — VERIFIED (role contradicted)

// Despite the inherited name, this performs NO post-commit
// bookkeeping: it reads the candidate windows' trees and emits ONE
// diagnostic log line per window, then returns. It writes no global
// and mutates no scan state (its only externally visible effect is
// the OMCLogWrite call at 0xa784). Callers (sub_7a84 @0x9624 on full
// scans, @0x97b0) ignore any result; the function returns void.
// Per window: sub_c204 fills a technology set + text list + image
// list; sub_c70c builds the "related views" dump; the line is
//   "chan doan <Class> (<w>x<h>): cong nghe=[<tech joined ' '>]
//    chu=[<texts joined ' '>] anh=[<images joined ' '>]
//    view lien quan:<dump or ' (khong co)'>"
// The binary also contains the fallback string " (khong co cua so)"
// for a nil window — unreachable inside this loop (windows come from
// the candidates array); its presence suggests the original source
// had a window-conditional there (INFERRED).
void SPPScanPostCommit(NSArray *candidates) {
    for (UIWindow *window in candidates) {
        NSMutableSet *tech = [NSMutableSet set];
        NSMutableArray *texts = [NSMutableArray array];
        NSMutableArray *images = [NSMutableArray array];
        SPPDiagWalk(window, 0, tech, texts, images);
        NSString *className = NSStringFromClass([window class]);
        // The binary reads -bounds twice, once per component.
        CGFloat w = [window bounds].size.width;
        CGFloat h = [window bounds].size.height;
        NSMutableString *dump = [NSMutableString string];
        int count = 0;
        SPPDumpRelatedViews(window, dump, 0, &count);
        NSString *related = [dump length] ? dump : @" (khong co)";
        OMCLogWrite(@"SpeedBubble",
                    [NSString stringWithFormat:
                        @"chan doan %@ (%.0fx%.0f): cong nghe=[%@] "
                        @"chu=[%@] anh=[%@] view lien quan:%@",
                        className, w, h,
                        [[tech allObjects] componentsJoinedByString:@" "],
                        [texts componentsJoinedByString:@" "],
                        [images componentsJoinedByString:@" "],
                        related]);
    }
}

#pragma mark - sub_b878 SPPCollectAXElements — VERIFIED

// Depth-first AX walk. Entry gates, in order: nil element; depth >
// 80; out already > 600 entries; seen already > 4000 entries;
// SPPAXOverran already set; deadline — when CFAbsoluteTimeGetCurrent()
// exceeds SPPAXDeadline the walk sets SPPAXOverran = YES and stops.
// Each element is visited at most once across the whole walk (seen
// holds NSValue nonretained-object wrappers; an already-seen element
// returns immediately, children included).
//
// An element contributes @{ @"t": text, @"f": NSValue(CGRect) } when
// its assembled text is non-empty AND it counts as an accessibility
// element: non-UIView objects always count; UIViews only when
// isAccessibilityElement. The text is the accessibilityLabel and
// accessibilityValue (NSString, non-empty ones only) joined with a
// single space; the frame is accessibilityFrame when the element
// responds to it, else CGRectZero.
//
// Children are walked (depth + 1) from, in order:
//   1. accessibilityElements, when it is a non-empty NSArray;
//   2. else accessibilityElementAtIndex: for 1..399 elements
//      (the count-1 <= 398 unsigned test in the binary);
// and afterwards, for UIViews, ALWAYS also the subviews.
void SPPCollectAXElements(id root, NSMutableArray *out,
                          NSMutableSet *seen, int depth) {
    if (!root) {
        return;
    }
    if (depth > 80) {
        return;
    }
    if ([out count] > 600) {
        return;
    }
    if ([seen count] > 4000) {
        return;
    }
    if (SPPAXOverran) {
        return;
    }
    if (CFAbsoluteTimeGetCurrent() > SPPAXDeadline) {
        SPPAXOverran = YES;
        return;
    }
    NSValue *key = [NSValue valueWithNonretainedObject:root];
    if ([seen containsObject:key]) {
        return;
    }
    [seen addObject:key];

    NSString *label =
        [root respondsToSelector:@selector(accessibilityLabel)]
            ? [root accessibilityLabel]
            : nil;
    NSString *value =
        [root respondsToSelector:@selector(accessibilityValue)]
            ? [root accessibilityValue]
            : nil;
    NSMutableString *text = [NSMutableString string];
    if ([label isKindOfClass:[NSString class]] && [label length]) {
        [text appendString:label];
    }
    if ([value isKindOfClass:[NSString class]] && [value length]) {
        if ([text length]) {
            [text appendString:@" "];
        }
        [text appendString:value];
    }

    BOOL countsAsElement =
        ![root isKindOfClass:[UIView class]] ||
        [root isAccessibilityElement];
    if ([text length] > 0 && countsAsElement) {
        CGRect frame =
            [root respondsToSelector:@selector(accessibilityFrame)]
                ? [root accessibilityFrame]
                : CGRectZero;
        [out addObject:@{ @"t" : [text copy],
                          @"f" : [NSValue valueWithCGRect:frame] }];
    }

    NSArray *children =
        [root respondsToSelector:@selector(accessibilityElements)]
            ? [root accessibilityElements]
            : nil;
    if ([children isKindOfClass:[NSArray class]] &&
        [children count] > 0) {
        for (id child in children) {
            SPPCollectAXElements(child, out, seen, depth + 1);
        }
    } else if ([root
                   respondsToSelector:@selector(accessibilityElementCount)]) {
        NSUInteger count = [root accessibilityElementCount];
        if (count >= 1 && count <= 399) {
            for (NSUInteger i = 0; i < count; i++) {
                SPPCollectAXElements(
                    [root accessibilityElementAtIndex:i], out, seen,
                    depth + 1);
            }
        }
    }
    if ([root isKindOfClass:[UIView class]]) {
        for (UIView *sub in [(UIView *)root subviews]) {
            SPPCollectAXElements(sub, out, seen, depth + 1);
        }
    }
}

#pragma mark - sub_bf50 SPPAXTextIsCandidate — VERIFIED

// Lowercase, delete every space, then require a real unit form:
// "km/h", "kmh" or "km/g" (Vietnamese km/gio). A bare "km" does NOT
// pass this gate (the additional contains-"km" test agent B saw lives
// in sub_7a84's pass 1, not here).
BOOL SPPAXTextIsCandidate(id text) {
    NSString *s = [[(NSString *)text lowercaseString]
        stringByReplacingOccurrencesOfString:@" " withString:@""];
    return [s containsString:@"km/h"] || [s containsString:@"kmh"] ||
           [s containsString:@"km/g"];
}
