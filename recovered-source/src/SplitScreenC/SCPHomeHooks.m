// SCPHomeHooks.m — SplitScreen-C: icon-grid hook REPLACEMENT bodies.
//
// The installers live in SplitScreen-A's __init_0 (0x44a8): 17
// MSHookMessageEx calls storing the original IMPs in the slots referenced
// below. These bodies implement OmniCar's home-screen customization:
// icon scale, grid column/row overrides, label hiding, and the
// hidden/shown app filtering of -[..IconModel isIconVisible:].

#import "SCPHomeCommon.h"
#import "SCPHomeLauncher.h" // [gpt-home] only own-icon visibility

NS_ASSUME_NONNULL_BEGIN

typedef struct { CGSize size; CGFloat scale; CGFloat continuousCornerRadius; }
    SBIconImageInfoCompat; // [phase1 fix 20; backported to src in phase 3] compat typedef moved ABOVE the Orig slots (was below them)

// Original IMPs (installed by A; addresses are the storage slots).
// Phase-2 seam fix: slots and bodies are EXTERN (not static) — in the
// binary there is exactly one slot per hook, and A's installer
// (SCPInitHomeHooks) writes these slots and references these bodies.
SBIconImageInfoCompat (*OrigIconImageInfo)(id, SEL);                    // 0x87ff0
NSInteger (*OrigPortraitColumns)(id, SEL);                        // 0x87ff8
NSInteger (*OrigPortraitRows)(id, SEL);                           // 0x88000
NSInteger (*OrigLandscapeColumns)(id, SEL);                       // 0x88008
NSInteger (*OrigLandscapeRows)(id, SEL);                          // 0x88010
void (*OrigSetLabelHidden)(id, SEL, BOOL);                        // 0x88018
BOOL (*OrigIsIconVisible)(id, SEL, id);                           // 0x88020
CGSize (*OrigMaxLabelSize)(id, SEL, CGSize);                      // 0x88028

// Home settings getters (SCPHomeSettings.m)
extern CGFloat SCPHomeIconScale(void);                                   // 0x48e24
extern NSInteger SCPHomeGridColumns(void);                               // 0x48f48
extern NSInteger SCPHomeGridRows(void);                                  // 0x49014
extern BOOL SCPHomeShowNames(void);                                      // 0x490e0

// Visibility predicates (SCPHomeVisibility.m)
extern BOOL SCPIconHiddenOnCar(id icon);                                 // 0xb5ec
extern BOOL SCPIconForcedOnCar(id icon);                                 // 0xbb20


// 0x5520 — VERIFIED. Shared exception logger for the whole home hook group;
// A-covered hooks (0x4af0/0x4bcc/0x4cb4/0x4d24/0x4d90/0x4f30, prefschanged
// block 0x54bc) call it from their @catch blocks, as does the
// isIconVisible hook below. (SplitScreen-A's report guessed this address
// was "SCPHomeKick" — the body is a pure logger; see report §5.)
void SCPLogException(const char *where, NSException *e) {
    OMCLogWrite(@"SplitScreen", [NSString stringWithFormat:
        @"LOI trong %s: %@\n%@", where, e, [e callStackSymbols]]);
}

// 0x5104 — -[SBIconListGridLayoutConfiguration iconImageInfo] — VERIFIED
SBIconImageInfoCompat SCPHook_IconImageInfo(id self, SEL _cmd) {
    SBIconImageInfoCompat info = OrigIconImageInfo(self, _cmd);
    @try {
        CGFloat s = SCPHomeIconScale();
        if (s > 0 && fabs(s - 1.0) > 0.001) {
            info.size.width *= s;
            info.size.height *= s;
            info.continuousCornerRadius *= s; // NOTE: `scale` field untouched
        }
    } @catch (NSException *e) {}
    return info;
}

// 0x55f4 — grid dimension override helper — VERIFIED.
// The original's re-entrancy guard is a 1-byte __thread variable
// (__thread_bss @0x87f78, zero-init) reached through the
// __DATA,__thread_vars descriptor @0x87f60, whose first word binds to
// __tlv_bootstrap (access sequence @0x5624–0x5634). While the byte is
// set the hooks pass the original value through (the helper itself
// re-queries the configuration, re-entering these hooks).
// [fix-round-3] An earlier transcription dereferenced the descriptor's
// VA 0x87f60 as an absolute runtime address — that was the CarPlay
// crash-loop of 2026-11-08 (fault addr exactly 0x87f60, proven at
// instruction level in the rebuilt binary). The faithful form below
// declares the real TLS variable and lets the compiler emit the
// descriptor + __tlv_bootstrap access itself. NEVER write the VA.
static __thread BOOL SCPGridReentrancyGuard;

static NSInteger SCPGridDimension(id self, NSInteger orig,
                                  BOOL isLandscape, BOOL isColumns) {
    if (SCPGridReentrancyGuard) return orig; // test @0x5634
    NSInteger wanted = 0;
    @try { // getter range [0x5670,0x567c); catch pad 0x5864 -> return orig
        wanted = isColumns ? SCPHomeGridColumns() : SCPHomeGridRows();
    } @catch (NSException *e) { return orig; }
    if (wanted < 1 || wanted == orig) return orig;
    SCPGridReentrancyGuard = YES;            // set @0x569c
    NSInteger cols = 0, rows = 0;
    @try { // re-query range [0x56b8,0x56f4); catch pad 0x5880 clears
           // the guard @0x5898 and returns orig (exception swallowed)
        SEL colSel = NSSelectorFromString(isLandscape ? @"numberOfLandscapeColumns"
                                                      : @"numberOfPortraitColumns");
        cols = ((NSInteger (*)(id, SEL))objc_msgSend)(self, colSel);
        SEL rowSel = NSSelectorFromString(isLandscape ? @"numberOfLandscapeRows"
                                                      : @"numberOfPortraitRows");
        rows = ((NSInteger (*)(id, SEL))objc_msgSend)(self, rowSel);
    } @catch (NSException *e) { SCPGridReentrancyGuard = NO; return orig; }
    SCPGridReentrancyGuard = NO;             // clear @0x56f8
    if ((NSUInteger)cols < 2 || (NSUInteger)rows <= 1) return orig; // unsigned b.lo/b.ls @0x5704–0x5710
    static NSMutableSet<NSString *> *logged; // 0x88038
    if (!logged) logged = [NSMutableSet set];
    NSString *key = [NSString stringWithFormat:@"%@%@%lu>%ld",
                     isLandscape ? @"L" : @"P", isColumns ? @"c" : @"r",
                     (unsigned long)orig, (long)wanted];
    if (![logged containsObject:key]) {
        [logged addObject:key];
        OMCLogWrite(@"SplitScreen", [NSString stringWithFormat:
            @"HomeScreen: luoi %@ %@ %lu -> %ld",
            isLandscape ? @"ngang" : @"doc", isColumns ? @"cot" : @"hang",
            (unsigned long)orig, (long)wanted]);
    }
    return wanted;
}

// 0x51a0 / 0x51d8 / 0x5210 / 0x5248 — VERIFIED
NSInteger SCPHook_PortraitColumns(id self, SEL _cmd) {
    return SCPGridDimension(self, OrigPortraitColumns(self, _cmd), NO, YES);
}
NSInteger SCPHook_PortraitRows(id self, SEL _cmd) {
    return SCPGridDimension(self, OrigPortraitRows(self, _cmd), NO, NO);
}
NSInteger SCPHook_LandscapeColumns(id self, SEL _cmd) {
    return SCPGridDimension(self, OrigLandscapeColumns(self, _cmd), YES, YES);
}
NSInteger SCPHook_LandscapeRows(id self, SEL _cmd) {
    return SCPGridDimension(self, OrigLandscapeRows(self, _cmd), YES, NO);
}

// 0x5280 — -[SBIconView setLabelHidden:] — VERIFIED
void SCPHook_SetLabelHidden(id self, SEL _cmd, BOOL hidden) {
    BOOL effective = hidden;
    @try {
        effective = hidden || !SCPHomeShowNames();
    } @catch (NSException *e) {}
    OrigSetLabelHidden(self, _cmd, effective);
}

// 0x5338 — -[<icon model> isIconVisible:] — VERIFIED
BOOL SCPHook_IsIconVisible(id self, SEL _cmd, id icon) {
    BOOL result = NO;
    @try {
        // [gpt-home] Own Home launcher is not a chosen AppBridge app.
        // Preserve stock/native policy unchanged for every other bundle.
        if (SCPHomeLauncherIsOwnIcon(icon)) return SCPHomeLauncherEnabled();
        if (SCPIconHiddenOnCar(icon)) return NO;
    } @catch (NSException *e) { SCPLogException("isIconVisible", e); }
    @try {
        result = OrigIsIconVisible(self, _cmd, icon);
        if (!result && SCPIconForcedOnCar(icon)) result = YES;
    } @catch (NSException *e) { SCPLogException("isIconVisible", e); }
    return result;
}

// 0x5438 — +[<icon view class> maxLabelSizeForIconImageSize:] — VERIFIED
// Meta hook; installer picks CARIconView when present, else DBIconView.
CGSize SCPHook_MaxLabelSize(id self, SEL _cmd, CGSize size) {
    @try {
        if (SCPHomeShowNames()) return OrigMaxLabelSize(self, _cmd, size);
        return CGSizeZero;
    } @catch (NSException *e) {
        return OrigMaxLabelSize(self, _cmd, size);
    }
}

NS_ASSUME_NONNULL_END
