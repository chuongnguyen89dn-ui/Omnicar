// SBScanHelpers.h — SpeedBubble SOURCE-APP side (closure pass, wave 3)
// Corrected prototypes for the nine scan helpers at >= 0xa0b8 in
// OmniCarSpeedBubble.dylib whose bodies agent B left NOT-RECOVERED.
// Bodies: SBScanHelpers.m. Evidence: disasm/closure/ (fresh capstone
// dumps, names resolved via verify/macho_truth.py) and the addendum at
// the end of SpeedBubbleB_REPORT.md.
//
// PROTOTYPE CORRECTIONS vs the extern block in SBScan.m (agent B):
//  - SPPCandidatesSummary does not exist. The function at 0xa2c4 returns
//    an int reading, not an object; it is declared here under its
//    accurate name SPPFindAuxImageValue. SBScan.m's extern declaration
//    `id SPPCandidatesSummary(NSArray *)` must be deleted/replaced.
//  - SPPColorView returns a UIColor*, and its second parameter is a
//    recursion DEPTH (callers pass 0), not "unused". SBScan.m's comment
//    must be corrected; the `id` return type remains ABI-compatible.
// All other prototypes match SBScan.m's declarations exactly.

#import "SBSourceGlobals.h"
#import <UIKit/UIKit.h>

// sub_7904, reconstructed by agent B (SPPIsNumericString): string of
// length 1..3 consisting only of digits.
extern BOOL SPPIsNumericString(NSString *string);

// sub_a0b8 — recursively collect the numeric-text UILabels of a subtree
// that are actually visible on screen (see SPPViewIsOnScreen).
void SPPCollectViews(id root, NSMutableArray *out, int depth);

// sub_a2c4 — scan the candidate windows' image views for a readable
// speed value; on the first hit, cache the view weakly in
// SPPCachedAuxView (@0x437f8) and return the value; -1 when none.
// (This is the writer of SPPCachedAuxView — report open item 3.)
int SPPFindAuxImageValue(NSArray *candidates);

// sub_a530 — full-scan diagnostic: one OMCLogWrite line per candidate
// window ("chan doan ..."). Despite the name kept from SBScan.m, it
// performs NO bookkeeping and writes NO scan state.
void SPPScanPostCommit(NSArray *candidates);

// sub_a938 — first ancestor (superview chain, up to 6 levels) whose
// CLASS NAME contains `identifier` (case-insensitive); nil when none.
id SPPFindSignContainer(id view, NSString *identifier);

// sub_aa4c — the sign's colour as a UIColor: own layer border colour,
// else a CAShapeLayer sublayer's stroke colour, else the first colour
// found recursing into non-UILabel subviews. `depth` starts at 0;
// the search stops (nil) at depth 3.
UIColor *SPPColorView(id container, int depth);

// sub_afb4 — intValue of the largest-font visible numeric label in the
// cached root's subtree; -1 when there is none (or root is nil).
int SPPExtractFromCachedRoot(id root);

// sub_b0ec — extract a 5..200 reading from one cached image view:
// image name parsed out of -[UIImage description], else the view's
// accessibilityIdentifier, else its accessibilityLabel.
int SPPExtractFromCachedView(id view);

// sub_b878 — recursively collect AX elements as @{ @"t": text,
// @"f": NSValue(CGRect) } honouring the 40 ms deadline
// (SPPAXDeadline / SPPAXOverran) and the `seen` set.
void SPPCollectAXElements(id root, NSMutableArray *out,
                          NSMutableSet *seen, int depth);

// sub_bf50 — text-candidacy gate: after lowercasing and removing all
// spaces, the text must contain "km/h", "kmh" or "km/g".
BOOL SPPAXTextIsCandidate(id text);
