//  SCPCommon.h
//  OmniCar 1.0.3 — OmniCarSplitScreen.dylib (reconstructed, SplitScreen module B)
//
//  Shared declarations for the split-screen module: the OMC common logging
//  entry point (statically linked into every OmniCar dylib) and the two
//  file-local helpers of SCPCarDividerView.m.
//
//  EVIDENCE NOTES
//  - OMCLogWrite is a real exported local symbol of the binary
//    (_OMCLogWrite @0x4fbf4 in the arm64 slice); every log call in this
//    module passes a tag string (e.g. @"SplitScreen") and a message string.
//  - Class hierarchy in this project follows the RAW class structs of the
//    binary. The wave-1 metadata (objc.json / *.md) resolved chained-fixup
//    bind names through a 1-based ordinal table and is off by one import for
//    EVERY bind-resolved name (superclasses and classrefs). Ground truth was
//    re-derived from the raw slots (ordinal = raw & 0xFFFF, 0-based) and
//    confirmed by three semantic anchors: the slots the metadata calls
//    NSString/ CATransaction/ UIVisualEffectView are used in code as
//    NSArray (arrayWithObjects:count:), UIColor (colorWithRed:green:blue:
//    alpha:) and CAGradientLayer ([layer] + setColors:) respectively.
//    Corrected superclasses: SCPCarSplit: NSObject, SCPCarPane: NSObject,
//    SCPCarSplitView: UIView, SCPCarDividerView: UIView, SCPCarTabView:
//    UIView, SCPCTouchWatch: UIView, SCPCButton: UIButton,
//    SCPNoopLayoutAssertion: NSObject, SCPHostedAppVC: UIViewController,
//    SCPHomeWallView: UIView, SCPPrefs: NSObject.

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "SCPPrefs.h" // [phase2; backported to src in phase 3] SCPPrefs (SplitScreenBRefs) category below needs the primary interface

NS_ASSUME_NONNULL_BEGIN

/// Shared OMC logging core (one of the ~20 OMC* C functions statically
/// embedded in every OmniCar dylib). Writes `message` under `tag`
/// (this module uses the tag @"SplitScreen").
extern void OMCLogWrite(NSString *tag, NSString *message);   // _OMCLogWrite @0x4fbf4

/// Shared OMC translator: returns the localized string for `key`, falling
/// back to `fallback` (which may itself be an NSString format string).
extern NSString *OMCTr(NSString *key, NSString *fallback);   // _OMCTr @0x558fc

/// Shared OMC "lite mode" probe used across the OmniCar dylibs.
extern BOOL OMCLiteActive(void);                             // _OMCLiteActive @0x4f698

/// Shared OMC preference getter: the stored value for `key`, or `fallback`
/// when unset. Returns an object (NSString/NSNumber/...) or nil.
extern id _Nullable OMCPref(NSString *key, id _Nullable fallback); // _OMCPref @0x4f544

/// Shared OMC per-feature enable probe (key "<feature>Enabled", default YES).
extern BOOL OMCFeatureEnabled(NSString *feature); // [phase2; backported to src in phase 3] C name has NO leading underscore (the underscore is the Mach-O symbol prefix); body in OMCCommon.c

/// The OMC logo mesh image (style 0), used as the frosted-backdrop art.
extern id _Nullable OMCLogoMeshImage(int style);             // _OMCLogoMeshImage

/// SCPPrefs (module A's preferences facade) — only the class methods
/// module B calls, declared here for want of A's header.
@interface SCPPrefs (SplitScreenBRefs)
+ (BOOL)enabled;
+ (NSInteger)tipCount;
+ (void)setTipCount:(NSInteger)count;
+ (BOOL)showRecent;
+ (BOOL)showFavorites;
+ (NSArray *)recentLayouts;
+ (nullable NSDictionary *)favorite:(NSInteger)index;
@end

/// File-local helper (SCPCarDividerView.m): first sublayer of `view.layer`
/// whose `name` equals `name`, or nil. @0x47944 in the binary.
extern CALayer *_Nullable SCPLayerNamed(UIView *view, NSString *name);

/// File-local helper (SCPCarDividerView.m): applies/removes the knob's
/// "active" (finger-down) highlight. @0xeb20 in the binary.
extern void SCPSetKnobActive(UIView *knob, BOOL active);

/// Knob face factory (SCPCarDividerView.m). @0x35c74 in the binary.
extern UIVisualEffectView *SCPKnobFaceView(void); // [phase2; backported to src in phase 3] return type per DividerView def (was UIView*)

NS_ASSUME_NONNULL_END
