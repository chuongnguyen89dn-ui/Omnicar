// SPPWindowFactory.m — reconstructed from OmniCarSpeedBubble.dylib (arm64).
// Agent A (display side). CarPlay window plumbing shared by SPPOverspeed
// (warning frame) and SPPBubble (the bubble card):
//   SPPGetCarPlayCADisplay()  — find the car's CADisplay (private API,
//                               every step respondsToSelector-guarded with
//                               _OMCMissingSelector logging)
//   SPPMakeCarWindow()        — build a UIRootSceneWindow on that display
//   SPPMakeWindowPassThrough()— runtime-subclass the window so touches that
//                               hit no subview pass through
// Status: VERIFIED from disassembly except where a comment says INFERRED.

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <objc/runtime.h>
#import <objc/message.h>
#import <math.h>

extern void _OMCLogWrite(NSString *module, NSString *message);
// 3-argument form, as proven at the binary definition (_OMCMissingSelector
// @0x2248c: module, object, selector name) and at every call site in the
// two functions below (see call-site comments).
extern void _OMCMissingSelector(NSString *module, id object,
                                NSString *selectorName);

// Dynamic, guarded message send used all over this module: returns nil and
// logs via _OMCMissingSelector when the receiver does not implement the
// selector. (Shape VERIFIED; the helper is the binary's own idiom, written
// here as a macro-free local equivalent.)
static id SPPDynSend(id target, NSString *selectorName) {
    SEL sel = NSSelectorFromString(selectorName);
    if (![target respondsToSelector:sel]) {
        // The binary inlines this idiom; at every inlined site the object
        // argument is the guarded receiver itself: _SPPGetCarPlayCADisplay
        // @0x16f54 (AVExternalDevice class), @0x16fcc (device), @0x17080
        // (CADisplay class), @0x17134 (display); _SPPMakeCarWindow
        // @0x174fc (config), @0x17588 (display), @0x175ec/@0x1764c (mode).
        _OMCMissingSelector(@"SpeedBubble", target, selectorName);
        return nil;
    }
    return ((id (*)(id, SEL))objc_msgSend)(target, sel);
}

// _SPPGetCarPlayCADisplay @0x16ebc — VERIFIED.
// Chain: [AVExternalDevice currentCarPlayExternalDevice].screenIDs[0]
// gives the wanted display id; scan [CADisplay displays] for a display
// whose -uniqueId matches. nil when any link is missing.
id SPPGetCarPlayCADisplay(void) {
    Class avClass = objc_getClass("AVExternalDevice");
    id device = SPPDynSend(avClass, @"currentCarPlayExternalDevice");
    NSArray *screenIDs = SPPDynSend(device, @"screenIDs");
    if (screenIDs.count == 0) return nil;
    NSString *wanted = screenIDs[0];
    Class caClass = objc_getClass("CADisplay");
    NSArray *displays = SPPDynSend(caClass, @"displays");
    for (id display in displays) {
        NSString *uid = SPPDynSend(display, @"uniqueId");
        if ([uid isEqualToString:wanted]) return display;
    }
    return nil;
}

// Metrics exchanged with SPPMakeCarWindow — [VERIFIED line-level,
// final closure 2026-11-08] The callee's ONLY access to the struct
// is a single 8-byte store at offset 0 (`str d8, [x22]` @0x17720:
// the effective scale, on the success path only). It never loads
// from the struct and touches no other offset, so the honest layout
// is one in/out double at offset 0. Both callers pass a stack buffer
// whose word 0 they preset to 2.0 — a value the callee never reads;
// SPPBubble reads word 0 back after the call as its _displayScale,
// and SPPOverspeed's double[8] buffer's remaining words are dead
// padding, as are the extra fields of SPPBubble's local struct.
typedef struct {
    double scale;   // in: preset 2.0 (never read by the callee)
                    // out: effective scale written by SPPMakeCarWindow
} SPPWindowMetrics;

// Probe idiom for non-object returns (the binary repeats it inline
// for pointScale / currentMode / width / height): string selector +
// respondsToSelector, direct msgSend on success, _OMCMissingSelector
// on failure (result 0).
static double SPPProbeDouble(id target, NSString *name) {
    SEL sel = NSSelectorFromString(name);
    if ([target respondsToSelector:sel]) {
        return ((double (*)(id, SEL))objc_msgSend)(target, sel);
    }
    _OMCMissingSelector(@"SpeedBubble", target, name);
    return 0;
}
static NSUInteger SPPProbeInt(id target, NSString *name) {
    SEL sel = NSSelectorFromString(name);
    if ([target respondsToSelector:sel]) {
        return ((NSUInteger (*)(id, SEL))objc_msgSend)(target, sel);
    }
    _OMCMissingSelector(@"SpeedBubble", target, name);
    return 0;
}
static id SPPProbeObject(id target, NSString *name) {
    SEL sel = NSSelectorFromString(name);
    if ([target respondsToSelector:sel]) {
        return ((id (*)(id, SEL))objc_msgSend)(target, sel);
    }
    _OMCMissingSelector(@"SpeedBubble", target, name);
    return nil;
}

// _SPPMakeCarWindow @0x172a8 — [VERIFIED line-level, final closure
// 2026-11-08] Full scale derivation, replacing the old PARTIAL draft
// (which clamped to [0.25, 4.0] and logged window.screen.scale —
// both wrong):
//   display = SPPGetCarPlayCADisplay() (nil -> nil, metrics untouched)
//   config  = [[FBSDisplayConfiguration alloc] initWithCADisplay:display
//                                                  isMainDisplay:NO]
//             (the NO is VERIFIED: `mov w3, #0` @0x17324)
//   window  = [[UIRootSceneWindow alloc] initWithDisplayConfiguration:config]
//   scale   = config.pointScale (probe idiom, double return)
//     if scale < 1.0: pixel-derived — longest currentMode edge
//       (integer width/height) over longest bounds edge in points,
//       snapped to quarter steps: round(px/pt * 4.0) * 0.25
//     if scale outside [1.0, 4.0] after either path: fall back to
//       window.screen.scale, or 2.0 when even that is < 1.0
//   metrics->scale = scale (the callee's single struct store)
//   logs "man xe: %.0fx%.0f diem, ti le %.2f" with (bounds W, H, scale)
UIWindow *SPPMakeCarWindow(SPPWindowMetrics *metrics) {
    id display = SPPGetCarPlayCADisplay();
    if (!display) return nil;
    Class cfgClass = objc_getClass("FBSDisplayConfiguration");
    SEL cfgSel = NSSelectorFromString(@"initWithCADisplay:isMainDisplay:");
    id config = nil;
    if ([cfgClass instancesRespondToSelector:cfgSel]) {
        config = ((id (*)(id, SEL, id, BOOL))objc_msgSend)(
            [cfgClass alloc], cfgSel, display, NO);
    } else {
        // Binary @0x17358: x1 = x21 = [FBSDisplayConfiguration alloc] —
        // the binary allocs first, probes THAT instance with
        // objc_opt_respondsToSelector, and passes it here. This source
        // probes the class (instancesRespondToSelector:) and keeps no
        // alloc'd instance in scope, so it passes the class; the callee
        // logs NSStringFromClass(object's class), which is
        // "FBSDisplayConfiguration" either way.
        _OMCMissingSelector(@"SpeedBubble", cfgClass,
                            @"initWithCADisplay:isMainDisplay:");
    }
    if (!config) {
        _OMCLogWrite(@"SpeedBubble", @"khong tao duoc FBSDisplayConfiguration");
        return nil;
    }
    Class winClass = objc_getClass("UIRootSceneWindow");
    SEL winSel = NSSelectorFromString(@"initWithDisplayConfiguration:");
    UIWindow *window = nil;
    if ([winClass instancesRespondToSelector:winSel]) {
        window = ((id (*)(id, SEL, id))objc_msgSend)([winClass alloc], winSel, config);
    } else {
        // Binary @0x17408: x1 = x23 = [UIRootSceneWindow alloc], probed
        // and passed exactly as at the FBSDisplayConfiguration site
        // above; this source passes the class (see the note there).
        _OMCMissingSelector(@"SpeedBubble", winClass,
                            @"initWithDisplayConfiguration:");
    }
    if (![window isKindOfClass:[UIWindow class]]) {
        // Binary @0x174a4: this is the isKindOfClass failure path, and
        // the format argument is the window result itself (x21), not
        // the configuration.
        _OMCLogWrite(@"SpeedBubble",
            [NSString stringWithFormat:@"khong tao duoc UIRootSceneWindow: %@", window]);
        return nil;
    }
    double scale = SPPProbeDouble(config, @"pointScale");
    if (scale < 1.0) {
        // Pixel-derived scale: longest currentMode edge (integer
        // width/height probes) over the longest bounds edge in
        // points, snapped to quarter steps (frinta @0x176a0 = rint).
        id mode = SPPProbeObject(display, @"currentMode");
        double pxLong = 0;
        if (mode) {
            NSUInteger w = SPPProbeInt(mode, @"width");
            NSUInteger h = SPPProbeInt(mode, @"height");
            pxLong = (double)(w > h ? w : h);
        }
        CGRect b = window.bounds;
        double ptLong = MAX(b.size.width, b.size.height);
        if (pxLong > 0 && ptLong > 0) {
            scale = rint(pxLong / ptLong * 4.0) * 0.25;
        }
    }
    if (scale < 1.0 || scale > 4.0) {
        double screenScale = window.screen.scale;
        scale = (screenScale >= 1.0) ? screenScale : 2.0;
    }
    metrics->scale = scale;   // the binary's single struct store
                              // @0x17720 — unconditional on this path
    CGRect bounds = window.bounds;
    _OMCLogWrite(@"SpeedBubble",
        [NSString stringWithFormat:@"man xe: %.0fx%.0f diem, ti le %.2f",
                                   bounds.size.width, bounds.size.height,
                                   scale]);
    return window;
}

// sub_179e0 @0x179e0 — VERIFIED: the pass-through hitTest override.
// A hit on the window itself means "nothing was touched" -> nil, so the
// touch falls through to whatever is underneath; subview hits pass back.
static UIView *SPPPassThroughHitTest(UIView *self, SEL _cmd, CGPoint point,
                                     UIEvent *event) {
    struct objc_super sup = { self, class_getSuperclass(object_getClass(self)) };
    UIView *hit = ((UIView *(*)(struct objc_super *, SEL, CGPoint, UIEvent *))
                   objc_msgSendSuper)(&sup, _cmd, point, event);
    return (hit == self) ? nil : hit;
}

// _SPPMakeWindowPassThrough @0x1789c — VERIFIED.
// Creates (once per window class) a runtime subclass named
// "SPPPassThrough_<OriginalClass>", overrides hitTest:withEvent: with the
// function above (type encoding copied from the original method), and
// re-classes the window to it.
void SPPMakeWindowPassThrough(UIWindow *window) {
    if (!window) return;
    Class original = object_getClass(window);
    NSString *name = [NSString stringWithFormat:@"SPPPassThrough_%@",
                      NSStringFromClass(original)];
    Class sub = objc_getClass(name.UTF8String);
    if (!sub) {
        sub = objc_allocateClassPair(original, name.UTF8String, 0);
        Method m = class_getInstanceMethod(original,
                                           @selector(hitTest:withEvent:));
        class_addMethod(sub, @selector(hitTest:withEvent:),
                        (IMP)SPPPassThroughHitTest,
                        method_getTypeEncoding(m));
        objc_registerClassPair(sub);
    }
    object_setClass(window, sub);
}
