// DuoCar APEX (GPT V2) design tokens for the iPhone app — presentation only.
// Values from APEX_V2_SPEC.md section 2 (GPT design pack, commit eab80668).
// Header-only helpers: no linkage, no state, no prefs, no behavior.
#import <UIKit/UIKit.h>

static inline UIColor *OMCApexHex(uint32_t hex) {
    return [UIColor colorWithRed:((hex >> 16) & 0xFF) / 255.0
                           green:((hex >> 8) & 0xFF) / 255.0
                            blue:(hex & 0xFF) / 255.0
                           alpha:1.0];
}

static inline UIColor *OMCApexSurfaceRoot(void)   { return OMCApexHex(0x101820); }
static inline UIColor *OMCApexSurfaceDeep(void)   { return OMCApexHex(0x0A1218); }
static inline UIColor *OMCApexSurface1(void)      { return OMCApexHex(0x1B2A34); }
static inline UIColor *OMCApexSurface2(void)      { return OMCApexHex(0x233640); }
static inline UIColor *OMCApexSurface3(void)      { return OMCApexHex(0x2C424D); }
static inline UIColor *OMCApexTextPrimary(void)   { return OMCApexHex(0xEAF6FB); }
static inline UIColor *OMCApexTextSecondary(void) { return OMCApexHex(0x93AAB8); }
static inline UIColor *OMCApexAccent(void)        { return OMCApexHex(0x61D9F2); }
static inline UIColor *OMCApexTeal(void)          { return OMCApexHex(0x2EA6BB); }
static inline UIColor *OMCApexAmber(void)         { return OMCApexHex(0xF4B75F); }
static inline UIColor *OMCApexDanger(void)        { return OMCApexHex(0xFF4757); }
static inline UIColor *OMCApexStroke(void)        { return OMCApexHex(0x35515F); }
