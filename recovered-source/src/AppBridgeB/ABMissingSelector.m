// ABMissingSelector.m — the AppBridge-local missing-selector guard,
// _ABMissingSelector @ 0x9698 in OmniCarAppBridge.dylib (468 B,
// evidence: disasm/f_ABMissingSelector.txt).
//
// Provenance (phase 2, 2026-11-08): extracted from AppBridgeA's
// src/AppBridgeA/src/OMCCore.m (lines 180-196), where the function was
// bundled into A's copy of the shared OMC core. Per the coordinator
// ruling on BLOCKER-CORE-APPBRIDGE, A's OMCCore.m is EXCLUDED from the
// build in favour of the independently verified shared unit
// src/OMCCommon/: A's copy defaults the feature-enabled pref to NO
// (OMCCore.m:29, kCFBooleanFalse) where the shared unit has @YES, and
// its expiry deadline is 1809216000 (OMCCore.m:48, self-labelled
// INFERRED) where the shared unit has the instruction-verified
// 1809104400 (VERIFY_OMCCommon.md:41). A's file is NOT deleted — the
// integration agent manages the exclusion. This TU carries only
// ABMissingSelector, which module B links against and the shared unit
// does not provide under this name/signature.
//
// Two corrections to A's copy, both VERIFIED from the full 468-byte
// disassembly (A had traced only the head and said so):
//  1. The log line is "THIEU METHOD: %@ khong co %@ -> bo qua",
//     formatted with (NSStringFromClass([object class]), selectorName)
//     — NOT A's @"THIEU METHOD: %@" (A itself flagged that wording
//     INFERRED; the function's tail shows the real format string and
//     its two arguments).
//  2. The return type is void. AppBridgeB.h declares the function
//     returning id — a mis-read: the body never sets a meaningful
//     return value (it ends in a tail-call to objc_release), and the
//     call site in the CarPlay-connect handler (sub_958C,
//     disasm/blk_carplay_958c.txt) zeroes the result register itself
//     immediately after the call (mov x20, #0). This file therefore
//     deliberately does NOT import AppBridgeB.h, whose declaration
//     would conflict; A's header (OMCCore.h:88) has the correct void
//     signature. Module B call sites use the function as a statement,
//     which is valid under either declaration. (ABHostGeometry.m
//     assigns the "return value" in one place — that is B's prose
//     layer disagreeing with the binary, noted in the phase-2 report
//     section, not something this TU can fix.)
//
// Body notes (VERIFIED): the dedup set is a process-wide NSMutableSet
// (slot 0x3EA20) created once (predicate slot 0x3EA28, once-helper
// sub_241A4); the dedup key is "%@ %@" (class name, selector name);
// the contains/add pair runs inside @synchronized on the set; the log
// fires only for a first-seen (class, selector) pair; a nil object
// returns immediately.

#import <Foundation/Foundation.h>

extern void OMCLogWrite(NSString *tag, NSString *message);

void ABMissingSelector(id object, NSString *selectorName) {
    if (!object) return;
    static NSMutableSet<NSString *> *seen;
    static dispatch_once_t once;
    dispatch_once(&once, ^{ seen = [NSMutableSet set]; });
    NSString *entry = [NSString stringWithFormat:@"%@ %@",
                       NSStringFromClass([object class]), selectorName];
    @synchronized (seen) {
        if ([seen containsObject:entry]) return;
        [seen addObject:entry];
    }
    OMCLogWrite(@"AppBridge", [NSString stringWithFormat:
        @"THIEU METHOD: %@ khong co %@ -> bo qua",
        NSStringFromClass([object class]), selectorName]);
}
