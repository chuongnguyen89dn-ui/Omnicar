// ABPane.m — @implementation ABPane (declared in ABHost.h). Written in
// phase 2 (2026-11-08): phase 1's diagnostic link reported
// _OBJC_CLASS_$_ABPane undefined because neither half carried the
// implementation.
//
// Evidence: metadata/raw/OmniCarAppBridge/objc.json (class ABPane,
// superclass NSObject, instance_size 176) + the 35 method dumps
// disasm/m_ABPane_*.txt, batch-checked in phase 2: every one of the 35
// IMPs is a textbook synthesized accessor for the 17 properties
// declared in ABHost.h, plus .cxx_destruct. Spot evidence:
//
//   ivar                    offset  accessor evidence
//   _ready        (BOOL)    0x08    -ready @0xA2B8: ldrb [x0, #8]
//   _bundleID     (copy)    0x10    -setBundleID: @0xA188 tail-calls
//                                   _objc_setProperty_nonatomic_copy
//                                   with ivar offset 0x10
//   _box                    0x18
//   _application            0x20
//   _appViewController      0x28
//   _sceneMonitor           0x30
//   _orientation  (int)     0x38
//   _requestedOrientation   0x40
//   _handle                 0x48
//   _handleHit              0x50
//   _bar                    0x58
//   _popButton              0x60
//   _soloButton             0x68
//   _handleOffset (double)  0x70
//   _shield                 0x78
//   _sceneBox     (CGSize)  0x80
//   _frame        (CGRect)  0x90    -frame @0xA290 loads [x0, #0x90]
//                                   and [x0, #0xa0]
//
// Object getters are plain ivar loads; object setters are
// retain/release (objc_storeStrong shape); .cxx_destruct releases the
// object ivars via _objc_storeStrong. There is NO hand-written logic
// in this class in the binary — VERIFIED for all 35 IMPs, so the
// implementation is exactly the @synthesize block below (the compiler
// regenerates .cxx_destruct from the strong/copy properties).

#import "ABHost.h"

@implementation ABPane

@synthesize ready = _ready;
@synthesize bundleID = _bundleID;
@synthesize box = _box;
@synthesize application = _application;
@synthesize appViewController = _appViewController;
@synthesize sceneMonitor = _sceneMonitor;
@synthesize orientation = _orientation;
@synthesize requestedOrientation = _requestedOrientation;
@synthesize handle = _handle;
@synthesize handleHit = _handleHit;
@synthesize bar = _bar;
@synthesize popButton = _popButton;
@synthesize soloButton = _soloButton;
@synthesize handleOffset = _handleOffset;
@synthesize shield = _shield;
@synthesize sceneBox = _sceneBox;
@synthesize frame = _frame;

@end
