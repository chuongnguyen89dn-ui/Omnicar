// AppBridgeB.h — reconstructed from OmniCarAppBridge.dylib (arm64 slice,
// UUID 81EF5920-BB7A-37E8-B953-D88453F2EA89) by machine-code analysis.
// Module B scope: in-app hosting machinery, keyboard channel, touch path.
// See AppBridgeB_REPORT.md for the per-function evidence table.
//
// All Darwin/NSDistributed channel names and payload formats in this header
// were proven from the producer AND consumer code inside this binary
// (see report). Vietnamese log strings are quoted verbatim (diacritics are
// stored stripped in the binary, e.g. "ban phim xe: hien").

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <notify.h>

NS_ASSUME_NONNULL_BEGIN

// ---------------------------------------------------------------------------
// IPC channels
// ---------------------------------------------------------------------------
// NSDistributedNotificationCenter, name = channel, object = bundleID of the
// target app (per-app addressing) unless noted otherwise.
extern NSString *const ABChanOrientation; // host->app  {orientation, device, fps}
extern NSString *const ABChanOpen;        // car->host   full frame payload + identifier
extern NSString *const ABChanFrame;       // car->host   frame/bar/hole/area payload + identifier
extern NSString *const ABChanShield;      // car->host   {on}
extern NSString *const ABChanClose;       // car->host   {identifier, terminate}
extern NSString *const ABChanCloseAll;    // car->host   {except}
extern NSString *const ABChanKnobs;       // car->host   {knobs: [...]}
extern NSString *const ABChanState;       // host->car   {identifier, state: ready|failed|gone}, object nil
extern NSString *const ABChanKnobTouch;   // host->car   {index, phase, x, y}, object nil
extern NSString *const ABChanHandleDrag;  // host->car   {identifier, phase, x, y}, object nil
extern NSString *const ABChanHandleTap;   // host->car   {identifier}, object nil
extern NSString *const ABChanBarAction;   // host->car   (ABHost postBarAction:from: — module A)
extern NSString *const ABChanBarDismiss;  // host->car   {}, object nil (+ local outsideTouched)
extern NSString *const ABChanKbSync;      // host->car   {identifier, kbactive, kbsession, kbsource}, object nil [ytz4-hb NEW]

// Darwin notify channels (state-carrying, notify_set_state/get_state):
//   "com.anlai.omnicar/appbridge.keyboard"  packed uint64, proven layout:
//       bit  0      keyboard shown
//       bits 1..7   UIKeyboardType
//       bits 8..15  UIReturnKeyType
//       bits 24..55 FNV-1a-32(bundleID UTF8) << 24
//   "com.anlai.omnicar/appbridge.apporient" packed uint64, proven layout:
//       bits 0..7   orientation code (0xff = recompute-from-mask sentinel
//                   is used on the NSDistributed path, not here)
//       bits 8..23  supportedInterfaceOrientations mask
//       bits 24..55 FNV-1a-32(bundleID UTF8) << 24
extern const char *ABNotifyAppOrient;

// FNV-1a 32-bit over the bundle ID's UTF8 bytes (offset 0x811C9DC5,
// prime 0x01000193). Identical copy exists in the producer (sub_6AD4,
// sub_67FC) and in ABHost's hash matchers (appWithHash:/bundleForHash:).
static inline uint32_t ABBundleHash(NSString *bundleID) {
    const char *s = bundleID.UTF8String;
    uint32_t h = 0x811C9DC5u;
    if (s) {
        while (*s) { h = (h ^ (uint8_t)*s) * 0x01000193u; s++; }
    }
    return h;
}

// Host-side helpers (SpringBoard process), C functions in the original:
// sub_E6B8 — posts ABChanOrientation to one app; fps resolved from prefs.
// sub_BED4 — posts ABChanState (object nil).
void ABPostOrientationToApp(NSString *bundleID, NSInteger orientation);
void ABPostStateToApp(NSString *state, NSString *identifier);

// FIX-ROUND2 (audit item 9c): explicit block type for the completion
// argument of -[FBScene updateSettings:withTransitionContext:completion:].
// No @class FBScene is added here: the project TU already receives the
// full @interface FBScene from ABIntegrationShims.h (force-included via
// -include in the Makefile) before this header.
typedef void (^ABFBSceneUpdateCompletion)(void);

// FIX-ROUND2 (audit item 1): single SpringBoard hook installer, defined
// in ABHostGeometry.m; ABHostCtor (AppBridgeEntry.m) only gates + calls it.
void ABInstallSpringBoardHooks(void);

// OMCCheckHooks — shared scaffold (src/OMCCommon/OMCCommon.h:131);
// declared here because ABHostGeometry.m's TU does not include that header.
void OMCCheckHooks(NSString *tag, NSArray<NSString *> *specs);

// [hl36-native-only] ABTelexApply remains in unbuilt legacy source.
// The system IME implements text composition (including Vietnamese).
// ---------------------------------------------------------------------------
// OMC shared-scaffold helpers (defined in the Core component present in
// every OmniCar dylib; declared here so module B sources are
// self-consistent — implementations are NOT part of module B).
// ---------------------------------------------------------------------------
void OMCLogWrite(NSString *tag, NSString *message);
id _Nullable OMCPref(NSString *key, id _Nullable defaultValue);
void OMCPrefsSync(void);
BOOL OMCHasMethod(const char *className, NSString *selectorName); // [hotfix] 2nd param was declared const char* here (all other decls/impls — OMCCommon, Core, CarProbe — take NSString*); the original call passes an NSString (installer_app_4728.txt @0x4928)
BOOL OMCLiteActive(void);
NSInteger OMCCarWireless(void);
NSString *OMCCurrentLanguage(void);
NSString *OMCTr(NSString *vi, NSString *en);
// Fallback used wherever the original probes a possibly-missing private
// selector (defined symbol _ABMissingSelector in this binary): logs and
// skips when the receiver does not respond.
// [integration phase 2; backported to src in phase 3] Return type
// corrected id -> void: the 468-byte body (disasm/f_ABMissingSelector.txt)
// never sets a return value and its call site zeroes the result register
// itself; ABMissingSelector.m (extracted TU) and A's OMCCore.h:88 both
// declare void. See project/logs/phase2-appbridge.md.
void ABMissingSelector(id receiver, NSString *selectorName);

// In-app globals (single set per process; addresses in the original are
// __bss/__data slots listed in the report):
extern NSInteger ABForcedOrientation;   // 0x3E7D0, init -1; host-forced orientation, 0 = released
extern int64_t   ABAppOrientation;      // 0x3E9C8, app's own landscape setOrientation (3/4/5) or 0
extern NSInteger ABDeviceFake;          // 0x3E9D0, fake UIDevice orientation reported to the app
extern NSInteger ABFPSLimit;            // 0x3E9B0, 0 = unlimited
extern __weak id ABCurrentResponder;    // 0x3E930, tracked first responder (UITextInput)

NS_ASSUME_NONNULL_END
