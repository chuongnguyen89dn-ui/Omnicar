// DuoCar design tokens for the iPhone app — presentation only.
// APEX V2 values (APEX_V2_SPEC.md section 2) retuned to V3 Purple Horizon
// by role (GPT V3 P2 review, lane B2): same helpers, same structure.
// Header-only helpers: no linkage, no state, no prefs, no behavior.
#import <UIKit/UIKit.h>

static inline UIColor *OMCApexHex(uint32_t hex) {
    return [UIColor colorWithRed:((hex >> 16) & 0xFF) / 255.0
                           green:((hex >> 8) & 0xFF) / 255.0
                            blue:(hex & 0xFF) / 255.0
                           alpha:1.0];
}

static inline UIColor *OMCApexSurfaceRoot(void)   { return OMCApexHex(0x070416); }
static inline UIColor *OMCApexSurfaceDeep(void)   { return OMCApexHex(0x100923); }
static inline UIColor *OMCApexSurface1(void)      { return OMCApexHex(0x100923); }
static inline UIColor *OMCApexSurface2(void)      { return OMCApexHex(0x1B1138); }
static inline UIColor *OMCApexSurface3(void)      { return OMCApexHex(0x28194D); }
static inline UIColor *OMCApexTextPrimary(void)   { return OMCApexHex(0xF5F0FF); }
static inline UIColor *OMCApexTextSecondary(void) { return OMCApexHex(0xC7B8E4); }
static inline UIColor *OMCApexAccent(void)        { return OMCApexHex(0xA16EFF); }
static inline UIColor *OMCApexTeal(void)          { return OMCApexHex(0xA16EFF); }
static inline UIColor *OMCApexAmber(void)         { return OMCApexHex(0xF4B75F); }
static inline UIColor *OMCApexDanger(void)        { return OMCApexHex(0xFF4757); }
static inline UIColor *OMCApexStroke(void)        { return OMCApexHex(0xDBB9FF); }
