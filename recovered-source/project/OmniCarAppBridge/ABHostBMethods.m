// ABHostBMethods.m — ABHost methods in module B's scope. Each method cites
// its IMP address (arm64 slice) and its evidence file under disasm/.

#import "AppBridgeB.h"
#import "ABHost.h"
#import <objc/runtime.h>
#import <objc/message.h>

extern id OMCPref(NSString *key, id defaultValue);
extern void OMCPrefsSync(void);
extern NSString *OMCTr(NSString *vi, NSString *en);
extern id OMCLogoMeshImage(int style);   // shared unit (OMCCommon.h:188)

// ---------------------------------------------------------------------------
// CLOSURE (phase-2 follow-up) — support declarations and helpers for the 18
// ABHost bodies appended at the end of this file. ABBarButton / ABKnobView /
// ABBoxView / ABShieldView are fully declared and implemented in
// ABChromeViews.m (same module).
// [phase 3] The partial in-file re-declarations that used to stand here
// (ABBoxView with handleHit/bar only, no ABShieldView) do NOT cover the
// final closure bodies — setupLiveAppViewForPane: reads box.passInsets /
// box.hole and setShield:forPane: messages ABShieldView — so this TU now
// imports ABChromeViews.h (the verbatim interface extraction, kept in
// this directory) exactly as the phase-2 project copy did.
// ---------------------------------------------------------------------------
#import "ABChromeViews.h"

// Guarded private-selector sends, in the binary's own idiom: every private
// send in setupLiveAppViewForPane:/teardownPane: is wrapped in
// respondsToSelector: + objc_msgSend, with _ABMissingSelector on the miss
// path (result nil). ABMissingSelector is called as a statement only (its
// phase-2 project typing returns void).
static id ABSend0(id obj, NSString *name) {
    SEL sel = NSSelectorFromString(name);
    if ([obj respondsToSelector:sel]) {
        id (*fn)(id, SEL) = (void *)objc_msgSend;
        return fn(obj, sel);
    }
    ABMissingSelector(obj, name);
    return nil;
}
static id ABSend1(id obj, NSString *name, id a1) {
    SEL sel = NSSelectorFromString(name);
    if ([obj respondsToSelector:sel]) {
        id (*fn)(id, SEL, id) = (void *)objc_msgSend;
        return fn(obj, sel, a1);
    }
    ABMissingSelector(obj, name);
    return nil;
}
static id ABSend2(id obj, NSString *name, id a1, id a2) {
    SEL sel = NSSelectorFromString(name);
    if ([obj respondsToSelector:sel]) {
        id (*fn)(id, SEL, id, id) = (void *)objc_msgSend;
        return fn(obj, sel, a1, a2);
    }
    ABMissingSelector(obj, name);
    return nil;
}
static id ABSend2B(id obj, NSString *name, id a1, BOOL a2) {
    SEL sel = NSSelectorFromString(name);
    if ([obj respondsToSelector:sel]) {
        id (*fn)(id, SEL, id, BOOL) = (void *)objc_msgSend;
        return fn(obj, sel, a1, a2);
    }
    ABMissingSelector(obj, name);
    return nil;
}
static void ABSendV0(id obj, NSString *name) {
    SEL sel = NSSelectorFromString(name);
    if ([obj respondsToSelector:sel]) {
        void (*fn)(id, SEL) = (void *)objc_msgSend;
        fn(obj, sel);
    } else {
        ABMissingSelector(obj, name);
    }
}
// [fix-round2] ABSendV1 — ADDED minimal helper (flagged in
// work/fix-round2/audit-appbridge-launch.md): the file had NO void
// one-object-argument send (only ABSendV0/VB/VI/VBlock); void setters
// such as setDelegate: were being called through id-returning ABSend1,
// whose phantom return value ARC may treat as an object. Body mirrors
// ABSendVBlock's cast and guard exactly, minus the block semantics.
static void ABSendV1(id obj, NSString *name, id a1) {
    SEL sel = NSSelectorFromString(name);
    if ([obj respondsToSelector:sel]) {
        void (*fn)(id, SEL, id) = (void *)objc_msgSend;
        fn(obj, sel, a1);
    } else {
        ABMissingSelector(obj, name);
    }
}
static void ABSendVB(id obj, NSString *name, BOOL a1) {
    SEL sel = NSSelectorFromString(name);
    if ([obj respondsToSelector:sel]) {
        void (*fn)(id, SEL, BOOL) = (void *)objc_msgSend;
        fn(obj, sel, a1);
    } else {
        ABMissingSelector(obj, name);
    }
}
static void ABSendVI(id obj, NSString *name, NSInteger a1) {
    SEL sel = NSSelectorFromString(name);
    if ([obj respondsToSelector:sel]) {
        void (*fn)(id, SEL, NSInteger) = (void *)objc_msgSend;
        fn(obj, sel, a1);
    } else {
        ABMissingSelector(obj, name);
    }
}
static void ABSendVBlock(id obj, NSString *name, id block) {
    SEL sel = NSSelectorFromString(name);
    if ([obj respondsToSelector:sel]) {
        void (*fn)(id, SEL, id) = (void *)objc_msgSend;
        fn(obj, sel, block);
    } else {
        ABMissingSelector(obj, name);
    }
}

// CHECK_CAST (inlined 12x in setupLiveAppViewForPane:): a non-nil result of
// the wrong class logs "UNEXPECTED %s: got %@ (%s:%d)" with the source line
// baked in ("Features/AppBridge/ABHost.mm") and raises NSException
// @"AppBridge" / @"expected %s got %@". nil passes through (VERIFIED at
// the sceneIdentity check @0xC9C8; the same compiled shape is INFERRED for
// the other eleven sites).
static id ABCheckCast(id obj, const char *className, int line) {
    if (obj && ![obj isKindOfClass:objc_getClass(className)]) {
        OMCLogWrite(@"AppBridge", [NSString stringWithFormat:
            @"UNEXPECTED %s: got %@ (%s:%d)", className, obj,
            "Features/AppBridge/ABHost.mm", line]);
        [NSException raise:@"AppBridge" format:@"expected %s got %@", className, obj];
    }
    return obj;
}

// sub_D9B0 @0xD9B0 (1344 B) — VERIFIED flow: fuzzy selector-name resolver.
// Returns the first candidate `object` responds to; failing that, scans
// the class hierarchy's method lists for the SHORTEST method name
// containing `needle` (case-insensitive) and returns it (nil if none);
// failing candidates are logged once per (class, needle) through a static
// NSMutableSet: "iOS %@: %@ khong co %@ -> dung %@ (co: %@)".
// Candidate arrays RECOVERED (final closure, raw-byte decode): the
// three constants are NSConstantArray objects living IN
// __objc_arrayobj — the addresses 0x39420 / 0x39438 / 0x39450 ARE the
// objects (word 0 is the isa bind _OBJC_CLASS_$_NSConstantArray),
// which is why pointer-slot resolution stalled at the class. Layout
// {isa, count, element-buffer ptr}: counts 2/3/2, buffers in
// __objc_arraydata @0x38F30 / 0x38F40 / 0x38F58; every element slot
// decodes through the chained fixups to a __cfstring. Contents, with
// the call-site mapping proven in setupLiveAppViewForPane::
//   0x39420 (call @0xC600, needle @"layoutStateManager"):
//     @"layoutStateManager", @"_layoutStateManager"
//   0x39438 (call @0xC7C8, needle @"sceneIdentityForApplication"):
//     @"sceneIdentityForApplication:createPrimaryIfRequired:sceneSessionRole:",
//     @"sceneIdentityForApplication:createPrimaryIfRequired:",
//     @"_sceneIdentityForApplication:createPrimaryIfRequired:"
//   0x39450 (call @0xD3D8, needle
//   @"primarySceneIdentifierForBundleIdentifier"):
//     @"primarySceneIdentifierForBundleIdentifier:sceneSessionRole:displayIdentity:",
//     @"primarySceneIdentifierForBundleIdentifier:"
// The call sites below now pass these arrays verbatim.
static NSString *ABResolveSelectorName(id object, NSArray<NSString *> *candidates,
                                       NSString *needle) {
    if (!object) return needle;   // tail @0xDD88 (INFERRED: returns needle)
    for (NSString *name in candidates)
        if ([object respondsToSelector:NSSelectorFromString(name)]) return name;
    NSMutableArray<NSString *> *matches = [NSMutableArray array];
    NSString *best = nil;
    for (Class cls = [object class]; cls; cls = class_getSuperclass(cls)) {
        unsigned int count = 0;
        Method *methods = class_copyMethodList(cls, &count);
        for (unsigned int i = 0; i < count; i++) {
            NSString *name = NSStringFromSelector(method_getName(methods[i]));
            if ([name rangeOfString:needle options:1].location != NSNotFound) {
                [matches addObject:name];
                if (!best || name.length < best.length) best = name;
            }
        }
        free(methods);
    }
    static NSMutableSet<NSString *> *logged;
    if (!logged) logged = [NSMutableSet set];
    NSString *key = [NSString stringWithFormat:@"%@ %@", NSStringFromClass([object class]), needle];
    if (![logged containsObject:key]) {
        [logged addObject:key];
        OMCLogWrite(@"AppBridge", [NSString stringWithFormat:
            @"iOS %@: %@ khong co %@ -> dung %@ (co: %@)",
            [UIDevice currentDevice].systemVersion,
            [candidates componentsJoinedByString:@" / "], needle,
            best ?: @"(khong tim thay)",
            matches.count ? [matches componentsJoinedByString:@", "] : @"-"]);
    }
    return best;
}

// sub_DEF0 @0xDEF0 (944 B) — VERIFIED: generic NSInvocation adapter.
// Builds an invocation for `selectorName` on `target` and fills each
// argument by matching the lowercased selector component: BOOL-typed
// arguments get [component containsString:@"createprimary"]; object
// arguments get bundleID ("bundleidentifier"), application
// ("application"), UIWindowSceneSessionRoleApplication ("role") or
// displayIdentity ("display"); unmatched components get nil. Invokes and
// returns the retained return value (nil for void / no signature).
static id ABInvokeIdentityGetter(id target, NSString *selectorName, id application,
                                 NSString *bundleID, id displayIdentity) {
    if (!target || !selectorName) return nil;
    SEL sel = NSSelectorFromString(selectorName);
    NSMethodSignature *sig = [target methodSignatureForSelector:sel];
    if (!sig) return nil;
    NSInvocation *inv = [NSInvocation invocationWithMethodSignature:sig];
    inv.target = target;
    inv.selector = sel;
    NSArray<NSString *> *parts = [selectorName componentsSeparatedByString:@":"];
    for (NSUInteger i = 0; i + 1 < parts.count && i + 2 < sig.numberOfArguments; i++) {
        NSString *part = [parts[i] lowercaseString];
        const char *type = [sig getArgumentTypeAtIndex:i + 2];
        if (type[0] == 'c' || type[0] == 'B') {
            BOOL value = [part containsString:@"createprimary"];
            [inv setArgument:&value atIndex:i + 2];
        } else {
            id value = nil;
            if ([part containsString:@"bundleidentifier"]) value = bundleID;
            else if ([part containsString:@"application"]) value = application;
            else if ([part containsString:@"role"]) value = UIWindowSceneSessionRoleApplication;
            else if ([part containsString:@"display"]) value = displayIdentity;
            [inv setArgument:&value atIndex:i + 2];
        }
    }
    [inv retainArguments];
    [inv invoke];
    if (sig.methodReturnLength == 0) return nil;
    // [fix-round2 ABI C3] Return-value extraction. ORIGINAL sub_DEF0
    // @0xE148-0xE160: zeroed pointer-sized stack slot, getReturnValue:
    // into it, load as id, explicit objc_retain @0xE160, returned via
    // objc_autoreleaseReturnValue — with NO return-encoding check of
    // any kind. The raw-slot + strong-move shape below ADOPTS that
    // pattern (getReturnValue: writes raw bytes and performs no strong
    // store, so the value is read through __unsafe_unretained and moved
    // to a strong reference before the invocation leaves scope). The
    // encoding/length gate is HARDENING BEYOND THE BINARY (GPT spec,
    // not a restored behaviour — the original is silent): the fuzzy
    // resolver (ABResolveSelectorName) can in principle land on a
    // scalar/struct-returning selector, whose buffer must never be
    // read as id, so '@' + pointer-sized length are verified first.
    const char *retType = sig.methodReturnType;
    if (!retType || retType[0] != '@' || sig.methodReturnLength != sizeof(id))
        return nil;
    __unsafe_unretained id raw = nil;
    [inv getReturnValue:&raw];
    id result = raw;
    return result;
}

// sub_B4E4 @0xB4E4 (952 B) — VERIFIED: the CarPlay CADisplay. Takes the
// AVExternalDevice's first screenID and returns the CADisplay whose
// uniqueId matches it (all sends guarded, as throughout this file).
static id ABCarDisplay(void) {
    id device = ABSend0(objc_getClass("AVExternalDevice"), @"currentCarPlayExternalDevice");
    NSArray *screenIDs = ABSend0(device, @"screenIDs");
    if (screenIDs.count == 0) return nil;
    id target = screenIDs[0];
    NSArray *displays = ABSend0(objc_getClass("CADisplay"), @"displays");
    for (id display in displays) {
        id uid = ABSend0(display, @"uniqueId");
        if ([target isEqualToString:uid]) return display;
    }
    return nil;
}

// sub_167DC @0x167DC (212 B) — VERIFIED: hitTest:withEvent: IMP installed
// on the ABPassThrough_* window subclass by -ensureWindow: a hit that
// lands on the window itself becomes nil (touches pass through), any
// subview hit is kept.
static UIView *ABPassThroughHitTestIMP(id self, SEL _cmd, CGPoint point, UIEvent *event) {
    struct objc_super sup = { self, class_getSuperclass(object_getClass(self)) };
    UIView *(*fn)(struct objc_super *, SEL, CGPoint, UIEvent *) =
        (void *)objc_msgSendSuper;
    UIView *hit = fn(&sup, _cmd, point, event);
    return hit == (UIView *)self ? nil : hit;
}

// Accent palette (raw __const doubles, /255 fractions as in ABChromeViews):
// shadow = (110, 100, 200), dot/tint = (74, 79, 128).
// sub_11F58 @0x11F58 (1640 B) — VERIFIED: paint (or clear) the gradient
// accent layer named "omcAccent" on a chrome view, and recolor its
// subviews (handle dots): white when accented, dot-blue at 0.85 alpha at
// rest. The view's own background becomes clear when accented, white at
// 0.35 alpha at rest.
static void ABApplyAccent(UIView *view, BOOL on) {
    if (!view) return;
    CAGradientLayer *accent = nil;
    for (CALayer *layer in view.layer.sublayers)
        if ([layer.name isEqualToString:@"omcAccent"]) { accent = (CAGradientLayer *)layer; break; }
    if (on) {
        if (!accent) {
            accent = [CAGradientLayer layer];
            accent.name = @"omcAccent";
            accent.colors = @[
                (id)[UIColor colorWithRed:155.0/255.0 green:135.0/255.0 blue:248.0/255.0 alpha:1].CGColor,
                (id)[UIColor colorWithRed:93.0/255.0 green:180.0/255.0 blue:246.0/255.0 alpha:1].CGColor];
            accent.startPoint = CGPointMake(0, 0);
            accent.endPoint = CGPointMake(1, 1);
            accent.frame = view.bounds;
            accent.cornerRadius = view.layer.cornerRadius;
            [view.layer insertSublayer:accent atIndex:0];
        }
        view.backgroundColor = [UIColor clearColor];
    } else {
        [accent removeFromSuperlayer];
        view.backgroundColor = [UIColor colorWithWhite:1 alpha:0.35];
    }
    for (UIView *sub in view.subviews)
        sub.backgroundColor = on ? [UIColor whiteColor]
            : [[UIColor colorWithRed:74.0/255.0 green:79.0/255.0 blue:128.0/255.0 alpha:1]
                  colorWithAlphaComponent:0.85];
}

// sub_11CD8 @0x11CD8 — VERIFIED: per-name rendered-glyph cache.
// Looks the button's icon view up by tag 7302 (0x1C86), renders the named
// glyph once (22 pt for "hm_*" names, 20 pt otherwise), forces
// AlwaysOriginal rendering, caches it, and sets the accessibility label.
// The glyph-drawing block @0x168B0 (2356 B) is VERIFIED line-level
// (final closure; dump disasm/fin_glyph_168b0.txt): the renderer
// context is scaled into a 24x24 design grid (captured size / 24.0),
// black is set, a stroke path (lineWidth 1.8 @0x2B2F8, round cap/join)
// and a fill path are built in parallel and stroked/filled at the
// shared tail @0x16B8C; branches routed through @0x16B7C first append
// one last addLineToPoint: (written out inline, marked "tail").
// Dispatch order is the binary's: fullscreen, replace, close, float,
// dock, then the hm_* family under a hasPrefix:@"hm_" gate that first
// drops the stroke line width to 1.5. All geometry constants were read
// from the __const pool and re-verified byte-exact (1.8, 2.4, 16.75,
// 1.6, 2.2, 19.5, 5.6/6.6/4.6/10.8/1.4, 18.5, 17.5, pi, +/-pi/2, 16.5).
static void ABSetBarButtonContent(UIButton *button, NSString *name, NSString *title) {
    static NSMutableDictionary<NSString *, UIImage *> *cache;
    if (!cache) cache = [NSMutableDictionary dictionary];
    UIImage *image = cache[name];
    if (!image) {
        CGFloat size = [name hasPrefix:@"hm_"] ? 22 : 20;
        UIGraphicsImageRenderer *renderer =
            [[UIGraphicsImageRenderer alloc] initWithSize:CGSizeMake(size, size)];
        UIImage *drawn = [renderer imageWithActions:^(UIGraphicsImageRendererContext *ctx) {
            CGContextScaleCTM(ctx.CGContext, size / 24.0, size / 24.0);
            [[UIColor blackColor] set];
            UIBezierPath *path = [UIBezierPath bezierPath];
            UIBezierPath *fill = [UIBezierPath bezierPath];
            path.lineWidth = 1.8;
            path.lineCapStyle = kCGLineCapRound;    // raw 1 @0x1695C
            path.lineJoinStyle = kCGLineJoinRound;  // raw 1 @0x16964
            if ([name isEqualToString:@"fullscreen"]) {          // @0x16970
                [path moveToPoint:CGPointMake(13.5, 4)];
                [path addLineToPoint:CGPointMake(20, 4)];
                [path addLineToPoint:CGPointMake(20, 10.5)];
                [path moveToPoint:CGPointMake(20, 4)];
                [path addLineToPoint:CGPointMake(14, 10)];
                [path moveToPoint:CGPointMake(10.5, 20)];
                [path addLineToPoint:CGPointMake(4, 20)];
                [path addLineToPoint:CGPointMake(4, 13.5)];
                [path moveToPoint:CGPointMake(4, 20)];
                [path addLineToPoint:CGPointMake(10, 14)];       // tail @0x16B7C
            } else if ([name isEqualToString:@"replace"]) {      // @0x16A20
                [path appendPath:[UIBezierPath bezierPathWithRoundedRect:CGRectMake(3.5, 3.5, 7.5, 7.5) cornerRadius:2.4]];
                [path appendPath:[UIBezierPath bezierPathWithRoundedRect:CGRectMake(13, 3.5, 7.5, 7.5) cornerRadius:2.4]];
                [path appendPath:[UIBezierPath bezierPathWithRoundedRect:CGRectMake(3.5, 13, 7.5, 7.5) cornerRadius:2.4]];
                [path moveToPoint:CGPointMake(16.75, 13.5)];
                [path addLineToPoint:CGPointMake(16.75, 20)];
                [path moveToPoint:CGPointMake(13.5, 16.75)];
                [path addLineToPoint:CGPointMake(20, 16.75)];    // tail @0x16B7C
            } else if ([name isEqualToString:@"close"]) {        // @0x16B30
                [path moveToPoint:CGPointMake(7, 7)];
                [path addLineToPoint:CGPointMake(17, 17)];
                [path moveToPoint:CGPointMake(17, 7)];
                [path addLineToPoint:CGPointMake(7, 17)];        // tail @0x16B7C
            } else if ([name isEqualToString:@"float"]) {        // @0x16BCC
                [path appendPath:[UIBezierPath bezierPathWithRoundedRect:CGRectMake(3.5, 4.5, 17, 15) cornerRadius:3]];
                [fill appendPath:[UIBezierPath bezierPathWithRoundedRect:CGRectMake(11.5, 11, 6.5, 6) cornerRadius:1.6]];
            } else if ([name isEqualToString:@"dock"]) {         // @0x16C58
                [path appendPath:[UIBezierPath bezierPathWithRoundedRect:CGRectMake(3.5, 4.5, 17, 15) cornerRadius:3]];
                [path moveToPoint:CGPointMake(12, 4.5)];
                [path addLineToPoint:CGPointMake(12, 19.5)];
                [fill appendPath:[UIBezierPath bezierPathWithRoundedRect:CGRectMake(5.6, 6.6, 4.6, 10.8) cornerRadius:1.4]];
            } else if ([name hasPrefix:@"hm_"]) {                // @0x16D20
                path.lineWidth = 1.5;
                if ([name isEqualToString:@"hm_apps"]) {         // @0x16D40
                    [path appendPath:[UIBezierPath bezierPathWithRoundedRect:CGRectMake(4, 4, 7, 7) cornerRadius:2.2]];
                    [path appendPath:[UIBezierPath bezierPathWithRoundedRect:CGRectMake(13, 4, 7, 7) cornerRadius:2.2]];
                    [path appendPath:[UIBezierPath bezierPathWithRoundedRect:CGRectMake(4, 13, 7, 7) cornerRadius:2.2]];
                    [path appendPath:[UIBezierPath bezierPathWithRoundedRect:CGRectMake(13, 13, 7, 7) cornerRadius:2.2]];
                } else if ([name isEqualToString:@"hm_full"]) {  // @0x16E48
                    [path moveToPoint:CGPointMake(4, 9.5)];
                    [path addLineToPoint:CGPointMake(4, 7.5)];
                    [path addArcWithCenter:CGPointMake(7.5, 7.5) radius:3.5
                                startAngle:M_PI endAngle:-M_PI_2 clockwise:YES];
                    [path addLineToPoint:CGPointMake(9.5, 4)];
                    [path moveToPoint:CGPointMake(14.5, 4)];
                    [path addLineToPoint:CGPointMake(16.5, 4)];
                    [path addArcWithCenter:CGPointMake(16.5, 7.5) radius:3.5
                                startAngle:-M_PI_2 endAngle:0 clockwise:YES];
                    [path addLineToPoint:CGPointMake(20, 9.5)];
                    [path moveToPoint:CGPointMake(20, 14.5)];
                    [path addLineToPoint:CGPointMake(20, 16.5)];
                    [path addArcWithCenter:CGPointMake(16.5, 16.5) radius:3.5
                                startAngle:0 endAngle:M_PI_2 clockwise:YES];
                    [path addLineToPoint:CGPointMake(14.5, 20)];
                    [path moveToPoint:CGPointMake(9.5, 20)];
                    [path addLineToPoint:CGPointMake(7.5, 20)];
                    [path addArcWithCenter:CGPointMake(7.5, 16.5) radius:3.5
                                startAngle:M_PI_2 endAngle:M_PI clockwise:YES];
                    [path addLineToPoint:CGPointMake(4, 14.5)];  // tail @0x16B7C
                } else if ([name isEqualToString:@"hm_split"]) { // @0x16FB8
                    [path appendPath:[UIBezierPath bezierPathWithRoundedRect:CGRectMake(3.5, 4.5, 7.5, 15) cornerRadius:2.5]];
                    [path appendPath:[UIBezierPath bezierPathWithRoundedRect:CGRectMake(13, 4.5, 7.5, 15) cornerRadius:2.5]];
                } else if ([name isEqualToString:@"hm_float"]) { // @0x17040
                    [path appendPath:[UIBezierPath bezierPathWithRoundedRect:CGRectMake(3.5, 4.5, 17, 15) cornerRadius:3]];
                    [fill appendPath:[UIBezierPath bezierPathWithRoundedRect:CGRectMake(11.5, 11.5, 6.5, 5.5) cornerRadius:1.6]];
                } else if ([name isEqualToString:@"hm_min"]) {   // @0x170CC
                    [path moveToPoint:CGPointMake(5.5, 12)];
                    [path addLineToPoint:CGPointMake(18.5, 12)]; // tail @0x16B7C
                } else if ([name isEqualToString:@"hm_close"]) { // @0x17100
                    [path moveToPoint:CGPointMake(6.5, 6.5)];
                    [path addLineToPoint:CGPointMake(17.5, 17.5)];
                    [path moveToPoint:CGPointMake(17.5, 6.5)];
                    [path addLineToPoint:CGPointMake(6.5, 17.5)]; // tail @0x16B7C
                }
            }
            [path stroke];                                       // @0x16B90
            [fill fill];                                         // @0x16B94
        }];
        image = [drawn imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        cache[name] = image;
    }
    [(UIImageView *)[button viewWithTag:7302] setImage:image];
    button.accessibilityLabel = title;
}

// sub_112B0 @0x112B0 — VERIFIED: one bar button — a 48x40 custom button
// carrying a non-interactive 40x40 rounded "plate" (white 0.5, border,
// soft shadow) whose inset image view (tag 7302) ABSetBarButtonContent
// fills, wired to the host on TouchUpInside (0x40).
static ABBarButton *ABMakeBarButton(NSString *name, NSString *title, UIColor *tint,
                                    ABHost *host, SEL action) {
    ABBarButton *button = [ABBarButton buttonWithType:UIButtonTypeCustom];
    button.bounds = CGRectMake(0, 0, 48, 40);
    button.tintColor = tint;
    UIView *plate = [[UIView alloc] initWithFrame:CGRectMake(4, 0, 40, 40)];
    plate.userInteractionEnabled = NO;
    plate.backgroundColor = [UIColor colorWithWhite:1 alpha:0.5];
    plate.layer.cornerRadius = 20;
    plate.layer.borderWidth = 1;
    plate.layer.borderColor = [UIColor colorWithWhite:1 alpha:0.9].CGColor;
    plate.layer.shadowColor = [UIColor colorWithRed:110.0/255.0 green:100.0/255.0
                                               blue:200.0/255.0 alpha:1].CGColor;
    plate.layer.shadowOpacity = 0.12f;   // float @0x2B38C
    plate.layer.shadowRadius = 3;
    plate.layer.shadowOffset = CGSizeMake(0, 2);
    UIImageView *icon = [[UIImageView alloc] initWithFrame:CGRectInset(plate.bounds, 6, 6)];
    icon.tag = 7302;
    icon.contentMode = UIViewContentModeCenter;   // raw 4
    [plate addSubview:icon];
    [button addSubview:plate];
    ABSetBarButtonContent(button, name, title);
    [button addTarget:host action:action forControlEvents:UIControlEventTouchUpInside];
    return button;
}

// Private scene access used by layoutPane:/nudgePane: — the original goes
// through NSSelectorFromString + ABMissingSelector guards for every private
// selector; the reconstruction calls them directly for readability. The
// guard behavior (log via _ABMissingSelector and skip when absent) is
// preserved in ABSceneSettingsApply below.

// [integration phase 2; backported to src in phase 3] This TU opens
// @implementation ABHost (ModuleB) — a CATEGORY, not a second plain
// implementation: module A's ABHostLaunch.m carries the plain
// @implementation ABHost, and two plain implementations of one class
// emit duplicate OBJC_CLASS/METACLASS/IVAR symbols at link (proven on a
// toy build in phase 2; see project/BUILD_PHASE2_LOG.md §3). Method
// sets are disjoint by the final closure's duplicate-pair rulings, so
// every ABHost selector has exactly one definition across the module.
@implementation ABHost (ModuleB)

// +shared (0xA9E8) — ADJUDICATED (final closure; dumps
// disasm/fin_imp_shared.txt + fin_shared_trampoline.txt): the sole
// definition lives in module A's ABHostLaunch.m. The IMP's once-block
// (invoke @0xAA2C) does [ABHost new] AND setPanes:[NSMutableArray
// array]; this file's former body ([[ABHost alloc] init], no panes
// initialisation) contradicts the block and was removed.
//
// -count (0xAAA0) — ADJUDICATED: sole definition in module A
// (ABHostLaunch.m); both bodies were the identical
// `return self.panes.count;`, which is exactly the IMP.
//
// -hostsApp: (0xAAF0 — this file's old comment cited 0xAB00, mid-body)
// — ADJUDICATED: sole definition in module A. The IMP branches on a
// nil argument FIRST (cbz x19 @0xAB2C -> return NO); A's body carries
// that explicit guard, this file's former body omitted it and was
// removed (behaviour converged to NO via isEqualToString:nil, but the
// structure did not match).
//
// -paneFor: (0xAC84 — old comment here cited 0xAC9C, mid-body) —
// ADJUDICATED: sole definition in module A; both bodies were the same
// unguarded scan the IMP performs (no nil branch @0xAC84).
//
// -bundleForHash: (0xF40C) — ADJUDICATED: sole definition in module A
// (same scan + inline FNV-1a-32: basis 0x811C9DC5, prime 0x01000193).
// Kept there with one correction applied: the IMP compares the
// zero-extended 32-bit hash against the FULL 64-bit argument
// (cmp x27, x20 @0xF510); both reconstructions formerly truncated the
// argument with a (uint32_t) cast.

// -zoom (0xAE20, 136 B, disasm/m_ABHost_zoom.txt): VERIFIED
// instruction-level in phase 2 — the orphan fragment that stood here
// (a bare return with no signature, disagreeing with its own comment
// about /100.0) is replaced by the real body: OMCPrefsSync();
// v = [OMCPref(@"appBridgeZoom", @80) doubleValue] / 100.0 (fdiv by
// the immediate 100.0 @0xAE58); return MIN(MAX(v, 0.6), 1.0) — fmaxnm
// against the __const double at 0x2B210 (@0xAE70), then fcmp/fcsel
// against 1.0 (@0xAE78).
// FLOOR CORRECTION (phase 2, 2026-11-08): the floor is 0.6, NOT 0.3.
// The bytes at 0x2B210 are 33 33 33 33 33 33 E3 3F = 0.6, read
// directly from the binary twice in phase 2 (verify/macho_truth.py
// and an independent hand-rolled parser). 0.3 and 0.6 share the
// truncated hex tail "33333333333…" that the disassembly annotation
// printed for the slot, which is where the 0.3 in this file's old
// comment (and in ABHost.h) came from. The @80 default object at
// 0x395A0 was verifier-confirmed earlier and stands.
- (double)zoom {
    OMCPrefsSync();
    double v = [OMCPref(@"appBridgeZoom", @80) doubleValue] / 100.0;
    return MIN(MAX(v, 0.6), 1.0);
}

// -effectiveOrientation: (0xF364):
// requestedOrientation if >= 1, else the pane's current orientation.
- (NSInteger)effectiveOrientation:(ABPane *)pane {
    return pane.requestedOrientation >= 1 ? pane.requestedOrientation : pane.orientation;
}

// -appWithHash:changedOrientation:supportedMask: (0xF6B0) — VERIFIED,
// ADJUDICATED the sole definition (final closure; dump
// disasm/fin_imp_appWithHash.txt): finds the pane by FNV hash (logs
// "apporient: khong co o cho hash %llu" on a miss), resolves the
// requested orientation — 0xFF means "derive from the mask" using the
// shared priority (portrait bit gates; LandscapeLeft > LandscapeRight >
// PortraitUpsideDown) — stores it as requestedOrientation, logs
// "%@ doi yeu cau xoay (ma %d, mask %lu) -> scene huong %lld", and
// nudges. Module A's truncated body (raw store, no derivation, no
// nudgePane:) was removed in its favour. One correction applied here:
// the IMP compares the zero-extended hash against the FULL 64-bit
// argument (cmp x22, x23 @0xF7C0), so the scan below no longer casts
// the argument to uint32_t.
- (void)appWithHash:(uint64_t)hash changedOrientation:(NSInteger)changed
    supportedMask:(NSUInteger)mask {
    ABPane *found = nil;
    for (ABPane *pane in self.panes)
        if ((uint64_t)ABBundleHash(pane.bundleID) == hash) { found = pane; break; }
    if (!found) {
        OMCLogWrite(@"AppBridge", [NSString stringWithFormat:@"apporient: khong co o cho hash %llu",
                                   (unsigned long long)hash]);
        return;
    }
    NSInteger derived = 0;
    if (mask != 0 && (mask & 2)) {
        derived = (mask & 8) ? 3 : (NSInteger)((mask >> 1) & 2);
        if (mask & 16) derived = 4;
    }
    found.requestedOrientation = (changed == 0xFF) ? derived : changed;
    OMCLogWrite(@"AppBridge", [NSString stringWithFormat:@"%@ doi yeu cau xoay (ma %d, mask %lu) -> scene huong %lld",
                               found.bundleID, (int)changed, (unsigned long)mask,
                               (long long)[self effectiveOrientation:found]]);
    [self nudgePane:found];
}

// -setFrame:forApp:live:handle:passInsets: (0xFE68). Verified behavior:
//   * unknown app -> no-op.
//   * collapsed := MIN(w, h) < 2.0; box.hidden = collapsed;
//     box.passInsets = insets; handle visibility = handle && !collapsed;
//     collapsed -> stop.
//   * pane.frame = frame.
//   * live: box.frame = frame; appView.center = (w/2, h/2);
//     layoutBarForPane:; done (scene size sync below skipped in live mode —
//     INFERRED branch structure: the live path returns before the
//     sceneBox comparison; see dump lines 0xFF94..0x10018).
//   * not live: if the frame changed, animate box to it with
//     [UIView animateWithDuration:(oldFrame empty ? 0 : 0.25) ...]
//     (animations block sub_10284 applies the same assignments).
//   * if pane.sceneBox != frame.size: layoutPane: + log
//     "%@ -> %@ (huong %lld)"; else just re-center the app view.
- (void)setFrame:(CGRect)frame forApp:(NSString *)app live:(BOOL)live
          handle:(BOOL)handle passInsets:(UIEdgeInsets)insets {
    ABPane *pane = [self paneFor:app];
    if (!pane) return;
    BOOL collapsed = MIN(frame.size.width, frame.size.height) < 2.0;
    pane.box.hidden = collapsed;
    pane.box.passInsets = insets;
    [self setHandleVisible:(handle && !collapsed) forPane:pane];
    if (collapsed) return;
    CGRect old = pane.frame;
    pane.frame = frame;
    if (live) {
        pane.box.frame = frame;
        ((UIViewController *)pane.appViewController).view.center = // [integration phase 2; backported to src in phase 3] cast: ABPane.appViewController is typed id; the message chain is unchanged
            CGPointMake(frame.size.width * 0.5, frame.size.height * 0.5);
        [self layoutBarForPane:pane];
        return;
    }
    if (!CGRectEqualToRect(old, frame)) {
        NSTimeInterval duration = CGRectIsEmpty(old) ? 0 : 0.25;
        [UIView animateWithDuration:duration delay:0 options:0 animations:^{
            pane.box.frame = frame;
            ((UIViewController *)pane.appViewController).view.center = // [integration phase 2; backported to src in phase 3] cast: ABPane.appViewController is typed id; the message chain is unchanged
                CGPointMake(frame.size.width * 0.5, frame.size.height * 0.5);
            [self layoutBarForPane:pane];
        } completion:nil];
    }
    if (!CGSizeEqualToSize(pane.sceneBox, frame.size)) {
        [self layoutPane:pane];
        OMCLogWrite(@"AppBridge", [NSString stringWithFormat:@"%@ -> %@ (huong %lld)",
                                   app, NSStringFromCGRect(frame),
                                   (long long)[self effectiveOrientation:pane]]);
    } else {
        ((UIViewController *)pane.appViewController).view.center = // [integration phase 2; backported to src in phase 3] cast: ABPane.appViewController is typed id; the message chain is unchanged
            CGPointMake(frame.size.width * 0.5, frame.size.height * 0.5);
    }
}

// The settings mutation shared by layoutPane: (block sub_F210). Applies,
// through the guarded private selectors of FBSceneSettings:
//   setFrame: {0, 0, logicalSize} — logicalSize transposed when the
//   effective orientation is 3, 4 or 5; setInterfaceOrientation: (if the
//   selector exists); setBackgrounded:NO; setForeground:YES.
static void ABSceneSettingsApply(id scene, CGSize logicalSize, NSInteger orientation) {
    SEL update = NSSelectorFromString(@"updateSettingsWithBlock:");
    if (![scene respondsToSelector:update]) { ABMissingSelector(scene, @"updateSettingsWithBlock:"); return; }
    ((void (*)(id, SEL, id))objc_msgSend)(scene, update, ^(id settings) {
        SEL setFrame = NSSelectorFromString(@"setFrame:");
        ((void (*)(id, SEL, CGRect))objc_msgSend)(settings, setFrame,
                                                  CGRectMake(0, 0, logicalSize.width, logicalSize.height));
        SEL setOrient = NSSelectorFromString(@"setInterfaceOrientation:");
        if ([settings respondsToSelector:setOrient])
            ((void (*)(id, SEL, NSInteger))objc_msgSend)(settings, setOrient, orientation);
        SEL setBg = NSSelectorFromString(@"setBackgrounded:");
        if ([settings respondsToSelector:setBg])
            ((void (*)(id, SEL, BOOL))objc_msgSend)(settings, setBg, NO);
        else ABMissingSelector(settings, @"setBackgrounded:");
        SEL setFg = NSSelectorFromString(@"setForeground:");
        if ([settings respondsToSelector:setFg])
            ((void (*)(id, SEL, BOOL))objc_msgSend)(settings, setFg, YES);
        else ABMissingSelector(settings, @"setForeground:");
    });
}

static id ABSceneOfPane(ABPane *pane) {
    id vc = pane.appViewController;
    SEL handleSel = NSSelectorFromString(@"sceneHandle");
    if (![vc respondsToSelector:handleSel]) { ABMissingSelector(vc, @"sceneHandle"); return nil; }
    id handle = ((id (*)(id, SEL))objc_msgSend)(vc, handleSel);
    SEL sceneSel = NSSelectorFromString(@"sceneIfExists");
    if (![handle respondsToSelector:sceneSel]) { ABMissingSelector(handle, @"sceneIfExists"); return nil; }
    return ((id (*)(id, SEL))objc_msgSend)(handle, sceneSel);
}

// -layoutPane: (0xEC80). Verified geometry:
//   boxSize = pane.box.bounds.size; bail if either dimension < 2.
//   z = [self zoom]; appView = pane.appViewController.view:
//     appView.transform = identity;
//     appView.frame = {0, 0, roundA(boxW/z), roundA(boxH/z)};  (frinta)
//     appView.transform = CGAffineTransformMakeScale(z, z);
//     appView.center = (boxW/2, boxH/2).
//   The private scene content container (via _deviceAppViewController ->
//   sceneView -> _sceneContentContainerView, all valueForKey:) gets its
//   transform reset to identity.
//   The FBScene's settings are rewritten via ABSceneSettingsApply with the
//   logical size (transposed for orientations 3..5).
//   pane.sceneBox = boxSize.
- (void)layoutPane:(ABPane *)pane {
    UIViewController *vc = pane.appViewController;
    if (!vc) return;
    CGSize boxSize = pane.box.bounds.size;
    if (boxSize.width < 2 || boxSize.height < 2) return;
    double z = [self zoom];
    UIView *appView = vc.view;
    appView.transform = CGAffineTransformIdentity;
    appView.frame = CGRectMake(0, 0, round(boxSize.width / z), round(boxSize.height / z));
    appView.transform = CGAffineTransformMakeScale(z, z);
    appView.center = CGPointMake(boxSize.width * 0.5, boxSize.height * 0.5);

    id deviceVC = [vc valueForKey:@"_deviceAppViewController"];
    id sceneView = [deviceVC valueForKey:@"sceneView"];
    UIView *container = [sceneView valueForKey:@"_sceneContentContainerView"];
    container.transform = CGAffineTransformIdentity;

    id scene = ABSceneOfPane(pane);
    if (scene) {
        NSInteger orient = [self effectiveOrientation:pane];
        CGSize logical = CGSizeMake(round(boxSize.width / z), round(boxSize.height / z));
        if (orient >= 3 && orient <= 5)
            logical = CGSizeMake(logical.height, logical.width);
        @try { ABSceneSettingsApply(scene, logical, orient); }
        @catch (NSException *e) {
            OMCLogWrite(@"AppBridge", [NSString stringWithFormat:@"updateSettings %@ loi %@",
                                       pane.bundleID, e]);
        }
    }
    pane.sceneBox = boxSize;
}

// -nudgePane: (0xF9??, disasm/m_ABHost_nudgePane.txt). Forces the hosted app
// to re-render at the current orientation/size: the scene frame is first
// set to the logical size with its height reduced by 1 pt
// (frame = {0, 0, w, MAX(1, h - 1)}, block sub_FD98 applies ONLY setFrame:),
// then after 0.05 s (dispatch_time constant 0x2FAF080 = 50,000,000 ns) the
// full layoutPane: runs (block sub_FDF8, weak self/pane).
- (void)nudgePane:(ABPane *)pane {
    id scene = ABSceneOfPane(pane);
    if (!scene) return;
    double z = [self zoom];
    CGSize boxSize = pane.box.bounds.size;
    NSInteger orient = [self effectiveOrientation:pane];
    double lw = round(boxSize.width / z), lh = round(boxSize.height / z);
    CGSize nudged = (orient >= 3 && orient <= 5)
        ? CGSizeMake(lh, MAX(1.0, lw - 1.0))   // INFERRED axis mapping: the
        : CGSizeMake(lw, MAX(1.0, lh - 1.0));  // -1 applies to the second
    // component after the same transpose rule as layoutPane:; the dump
    // shows the pair (d8, MAX(1, d9-1)) with (d8, d9) = landscape ? (h, w)
    // : (w, h) of the logical size — see report §5.2.
    SEL update = NSSelectorFromString(@"updateSettingsWithBlock:");
    if ([scene respondsToSelector:update]) {
        ((void (*)(id, SEL, id))objc_msgSend)(scene, update, ^(id settings) {
            SEL setFrame = NSSelectorFromString(@"setFrame:");
            ((void (*)(id, SEL, CGRect))objc_msgSend)(settings, setFrame,
                                                      CGRectMake(0, 0, nudged.width, nudged.height));
        });
    } else {
        ABMissingSelector(scene, @"updateSettingsWithBlock:");
    }
    __weak ABHost *weakSelf = self;
    __weak ABPane *weakPane = pane;
    dispatch_after(dispatch_time(0, 50000000), dispatch_get_main_queue(), ^{
        [weakSelf layoutPane:weakPane];
    });
}

// -setHole:forApp: (0x12CE4): the incoming rect is in window coordinates;
// stored on the box offset by -pane.frame.origin (an empty rect clears the
// hole to CGRectZero).
- (void)setHole:(CGRect)hole forApp:(NSString *)app {
    ABPane *pane = [self paneFor:app];
    if (!pane) return;
    CGRect local = CGRectIsEmpty(hole)
        ? CGRectZero
        : CGRectOffset(hole, -pane.frame.origin.x, -pane.frame.origin.y);
    pane.box.hole = local;
}

// -setPassInsets:forApp: (0x1038C): pane.box.passInsets = insets.
- (void)setPassInsets:(UIEdgeInsets)insets forApp:(NSString *)app {
    ABPane *pane = [self paneFor:app];
    if (pane) pane.box.passInsets = insets;
}

// -setShieldAll: (0x??, disasm/m_ABHost_setShieldAll.txt):
// shieldOn = on; every pane gets setShield:forPane:.
- (void)setShieldAll:(BOOL)on {
    self.shieldOn = on;
    for (ABPane *pane in self.panes) [self setShield:on forPane:pane];
}

// -setShield:forPane: (0x129??, disasm/m_ABHost_setShield_forPane.txt):
// ON: lazily create an ABShieldView sized to the box bounds, background
// white with alpha 0.08 (constant at 0x2B2C8), flexible width/height
// autoresizing; add to the box, keep frame == box bounds, then re-raise
// the bar and the handle hit area ABOVE the shield.
// OFF: remove the shield and clear pane.shield.
- (void)setShield:(BOOL)on forPane:(ABPane *)pane {
    if (!pane) return;
    if (on) {
        if (!pane.shield) {
            ABShieldView *shield = [[ABShieldView alloc] initWithFrame:pane.box.bounds];
            shield.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.08];
            shield.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
            pane.shield = shield;
            [pane.box addSubview:shield];
        }
        pane.shield.frame = pane.box.bounds;
        [pane.box bringSubviewToFront:pane.shield];
        if (pane.bar) [pane.box bringSubviewToFront:pane.bar];
        if (pane.handleHit) [pane.box bringSubviewToFront:pane.handleHit];
    } else {
        [pane.shield removeFromSuperview];
        pane.shield = nil;
    }
}

// -outsideTouched (disasm/m_ABHost_outsideTouched.txt): shieldOn = NO; for
// every pane: remove its shield and hide its bar.
- (void)outsideTouched {
    self.shieldOn = NO;
    for (ABPane *pane in self.panes) {
        [pane.shield removeFromSuperview];
        pane.shield = nil;
        [self hideBarForPane:pane];
    }
}

// -handlePanned: (0x14D34): finds the pane whose handleHit is the gesture's
// view; maps the gesture state to a phase (Began 1 -> 0, Changed 2 -> 1,
// Ended 3 -> 2, anything else -> 3); posts ABChanHandleDrag with
// {identifier, phase, x, y} (location in the host window) and logs.
- (void)handlePanned:(UIPanGestureRecognizer *)gesture {
    ABPane *found = nil;
    for (ABPane *pane in self.panes)
        if (pane.handleHit == gesture.view) { found = pane; break; }
    if (!found) return;
    NSInteger phase;
    switch (gesture.state) {
        case UIGestureRecognizerStateBegan:   phase = 0; break;
        case UIGestureRecognizerStateChanged: phase = 1; break;
        case UIGestureRecognizerStateEnded:   phase = 2; break;
        default:                              phase = 3; break;
    }
    CGPoint p = [gesture locationInView:self.window];
    [[NSDistributedNotificationCenter defaultCenter]
        postNotificationName:ABChanHandleDrag object:nil userInfo:@{
            @"identifier": found.bundleID, @"phase": @(phase),
            @"x": @(p.x), @"y": @(p.y)}];
}

// -handleTapped: (0x15434): same pane lookup; logs "cham thanh ••• cua
// %@" (UTF-16 string, verbatim sense: "tapped the ••• bar of %@") and
// posts ABChanHandleTap with {identifier}.
// RESTORED (fix-round4 C2-2): the rebuild kept the post but dropped
// the log; the dump (m_ABHost_handleTapped.txt) shows stringWithFormat:
// -> OMCLogWrite @0x15428 BEFORE postNotificationName: @0x154b4.
- (void)handleTapped:(UITapGestureRecognizer *)gesture {
    ABPane *found = nil;
    for (ABPane *pane in self.panes)
        if (pane.handleHit == gesture.view) { found = pane; break; }
    if (!found) return;
    OMCLogWrite(@"AppBridge", [NSString stringWithFormat:@"cham thanh ••• cua %@", found.bundleID]);
    [[NSDistributedNotificationCenter defaultCenter]
        postNotificationName:ABChanHandleTap object:nil
                    userInfo:@{@"identifier": found.bundleID}];
}

// -sceneMonitor:sceneWasDestroyed: (disasm/...): the pane owning the
// monitor is torn down (teardownPane: — module A), removed from panes, its
// state reported as "gone" (ABPostStateToApp), and the window dropped if
// empty. Log: "scene cua %@ bi huy -> bo o".
- (void)sceneMonitor:(id)monitor sceneWasDestroyed:(id)scene {
    ABPane *found = nil;
    for (ABPane *pane in [self.panes copy])
        if (pane.sceneMonitor == monitor) { found = pane; break; }
    if (!found) return;
    OMCLogWrite(@"AppBridge", [NSString stringWithFormat:@"scene cua %@ bi huy -> bo o", found.bundleID]);
    [self teardownPane:found];
    [self.panes removeObject:found];
    ABPostStateToApp(@"gone", found.bundleID);
    [self dropWindowIfEmpty];
}

// -carDisconnected (0x163E8) — VERIFIED, ADJUDICATED the sole
// definition (final closure; dump disasm/fin_imp_carDisconnected.txt).
// This replaces module A's INFERRED skeleton: the IMP never calls
// closeApp: — panes are torn down directly, and the window IS hidden
// and released. This file's earlier body had the right mechanism but
// the wrong order and no guard; corrected to the IMP's exact shape:
// knob views are cleared FIRST (@0x16414/@0x1643C), then an early
// return when there are no panes AND no window (count probe @0x1646C,
// window probe @0x16484, cbz @0x164A0 — short-circuit order count,
// then window), then the log with a re-read count (@0x164C0),
// teardownPane: over a copy of the registry (@0x16580), removeAllObjects
// (@0x165C8), and the window hide + release (@0x165E8/@0x165FC).
- (void)carDisconnected {
    [self.knobViews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self.knobViews removeAllObjects];
    if (self.panes.count == 0 && !self.window) return;
    OMCLogWrite(@"AppBridge", [NSString stringWithFormat:@"xe ngat -> bo %lu o",
                               (unsigned long)self.panes.count]);
    for (ABPane *pane in [self.panes copy]) [self teardownPane:pane];
    [self.panes removeAllObjects];
    self.window.hidden = YES;
    self.window = nil;
}

// ===========================================================================
// CLOSURE (phase-2 follow-up) — the 18 DECL_ONLY ABHost bodies. Placement
// rule: ALL of them live in module B's file. In the binary their IMPs
// interleave with B's already-reconstructed ABHostBMethods methods,
// src/AppBridgeA/src/ABHost.h itself annotates them "[B]" (hosting
// internals + command appliers), and B's existing bodies already call
// teardownPane:/layoutBarForPane:/hideBarForPane:/setHandleVisible:forPane:
// internally. None belongs to A's ABHostLaunch.m set. Evidence per method:
// disasm/m_ABHost_<name>.txt unless noted.
// ===========================================================================

// -ensureWindow @0xAEA8 (1596 B) — VERIFIED. Creates the pass-through
// UIRootSceneWindow on the CarPlay CADisplay (ABCarDisplay) once; if the
// display identity changed, the old window is hidden and dropped first.
- (BOOL)ensureWindow {
    id display = ABCarDisplay();
    if (!display) {
        OMCLogWrite(@"AppBridge", @"khong tim thay CADisplay cua CarPlay");
        return NO;
    }
    NSString *uid = ABSend0(display, @"uniqueId");
    if (!uid) return NO;
    if (self.window && ![uid isEqualToString:self.displayID]) {
        self.window.hidden = YES;
        self.window = nil;
    }
    if (self.window) return YES;
    id config = ABSend2B([objc_getClass("FBSDisplayConfiguration") alloc],
                         @"initWithCADisplay:isMainDisplay:", display, NO);
    if (!config) {
        OMCLogWrite(@"AppBridge", @"khong tao duoc FBSDisplayConfiguration");
        return NO;
    }
    UIWindow *win = ABSend1([objc_getClass("UIRootSceneWindow") alloc],
                            @"initWithDisplayConfiguration:", config);
    if (![win isKindOfClass:[UIWindow class]]) {
        OMCLogWrite(@"AppBridge", [NSString stringWithFormat:
            @"khong tao duoc UIRootSceneWindow: %@", win]);
        return NO;
    }
    // Pass-through subclass: same class name + hitTest IMP @0x167DC, so
    // touches that miss every subview fall through the window.
    NSString *name = [NSString stringWithFormat:@"ABPassThrough_%@",
                      NSStringFromClass([win class])];
    Class cls = objc_getClass(name.UTF8String);
    if (!cls) {
        cls = objc_allocateClassPair([win class], name.UTF8String, 0);
        Method m = class_getInstanceMethod([win class], @selector(hitTest:withEvent:));
        class_addMethod(cls, @selector(hitTest:withEvent:),
                        (IMP)ABPassThroughHitTestIMP, method_getTypeEncoding(m));
        objc_registerClassPair(cls);
    }
    object_setClass(win, cls);
    win.windowLevel = UIWindowLevelStatusBar + 60.0;   // constant 60.0; base INFERRED
    win.backgroundColor = [UIColor clearColor];
    win.hidden = NO;
    self.window = win;
    self.displayID = uid;
    OMCLogWrite(@"AppBridge", [NSString stringWithFormat:
        @"cua so tren man xe %@ (%@)", NSStringFromCGRect(win.bounds), uid]);
    return YES;
}

// -dropWindowIfEmpty @0xB89C — VERIFIED no-op: the IMP is a single `ret`
// (4 bytes). The window is only ever dropped by -carDisconnected.
- (void)dropWindowIfEmpty {
}

// -carWindow @0xF3D0 — VERIFIED.
- (UIWindow *)carWindow {
    return [self ensureWindow] ? self.window : nil;
}

// -revealPane: @0xC178 — VERIFIED (block @0xC270 sets the alpha).
- (void)revealPane:(ABPane *)pane {
    if (pane.box.alpha < 1.0)
        [UIView animateWithDuration:0.25 animations:^{ pane.box.alpha = 1.0; }];
}

// -setCornerRadius:corners:forApp: @0x10438 — VERIFIED.
- (void)setCornerRadius:(double)radius corners:(NSUInteger)corners
                forApp:(NSString *)bundleID {
    ABPane *pane = [self paneFor:bundleID];
    if (!pane) return;
    pane.box.layer.cornerRadius = radius;
    pane.box.layer.maskedCorners = corners;
    pane.box.layer.cornerCurve = kCACornerCurveContinuous;
    pane.box.clipsToBounds = YES;
}

// -buildBarForPane: @0x105B8 (3320 B) — VERIFIED. Builds the 52-pt glass
// bar: blur + mesh backdrop, five buttons (apps / full / pop / background
// / close) around one separator; total width 12 + 5*48 + 7 = 259. The bar
// starts hidden and transparent; setBarVisible: drives it from there.
// (Declaration fix: objc.json types the return @ — the header's earlier
// void typing is corrected in ABHost.h, see the closure log section.)
- (UIView *)buildBarForPane:(ABPane *)pane {
    UIColor *tint = [UIColor colorWithRed:74.0/255.0 green:79.0/255.0
                                     blue:128.0/255.0 alpha:1];
    UIColor *closeTint = [UIColor colorWithRed:1 green:90.0/255.0
                                          blue:95.0/255.0 alpha:1];
    ABBarButton *appsBtn = ABMakeBarButton(@"hm_apps", OMCTr(@"Đổi app", @"Change app"),
                                           tint, self, @selector(barReplace:));
    ABBarButton *fullBtn = ABMakeBarButton(@"hm_full", OMCTr(@"Toàn màn", @"Full screen"),
                                           tint, self, @selector(barFull:));
    ABBarButton *popBtn = ABMakeBarButton(@"hm_float", OMCTr(@"Cửa sổ nổi", @"Float"),
                                          tint, self, @selector(barPop:));
    ABBarButton *bgBtn = ABMakeBarButton(@"hm_min", OMCTr(@"Chạy nền", @"Background"),
                                         tint, self, @selector(barBackground:));
    ABBarButton *closeBtn = ABMakeBarButton(@"hm_close", OMCTr(@"Tắt app", @"Quit app"),
                                            closeTint, self, @selector(barClose:));
    pane.popButton = popBtn;
    pane.soloButton = fullBtn;
    NSArray *items = @[appsBtn, fullBtn, popBtn, bgBtn, [NSNull null], closeBtn];
    CGFloat totalWidth = 12;
    for (id item in items) totalWidth += [item isKindOfClass:[UIButton class]] ? 48 : 7;
    UIView *bar = [[UIView alloc] initWithFrame:CGRectMake(0, 0, totalWidth, 52)];
    bar.backgroundColor = [UIColor clearColor];
    bar.layer.cornerRadius = 22;
    bar.layer.cornerCurve = kCACornerCurveContinuous;
    bar.layer.shadowColor = [UIColor colorWithRed:110.0/255.0 green:100.0/255.0
                                             blue:200.0/255.0 alpha:1].CGColor;
    bar.layer.shadowOpacity = 0.3f;    // float @0x2B388
    bar.layer.shadowRadius = 14;
    bar.layer.shadowOffset = CGSizeMake(0, 6);
    UIVisualEffectView *blur = [[UIVisualEffectView alloc]
        initWithEffect:[UIBlurEffect effectWithStyle:11]];   // style name INFERRED
    blur.frame = bar.bounds;
    UIImageView *mesh = [[UIImageView alloc] initWithImage:OMCLogoMeshImage(0)];
    mesh.frame = blur.contentView.bounds;
    mesh.contentMode = UIViewContentModeScaleToFill;   // raw 0
    mesh.autoresizingMask = UIViewAutoresizingFlexibleWidth |
                            UIViewAutoresizingFlexibleHeight;   // raw 0x12
    [blur.contentView addSubview:mesh];
    blur.layer.cornerRadius = 22;
    blur.layer.cornerCurve = kCACornerCurveContinuous;
    blur.layer.borderWidth = 1;
    blur.layer.borderColor = [UIColor colorWithWhite:1 alpha:0.85].CGColor;
    blur.clipsToBounds = YES;
    blur.userInteractionEnabled = NO;
    [bar addSubview:blur];
    CGFloat x = 6;
    for (id item in items) {
        if ([item isKindOfClass:[UIButton class]]) {
            ((UIView *)item).center = CGPointMake(x + 24, 26);
            [bar addSubview:item];
            x += 48;
        } else {
            UIView *separator = [[UIView alloc] initWithFrame:CGRectMake(x + 3, 11, 1, 30)];
            separator.backgroundColor = [UIColor colorWithWhite:1 alpha:0.95];
            separator.userInteractionEnabled = NO;
            [bar addSubview:separator];
            x += 7;
        }
    }
    bar.hidden = YES;
    bar.alpha = 0;
    pane.bar = bar;
    pane.box.bar = bar;
    [pane.box addSubview:bar];
    return bar;
}

// -layoutBarForPane: @0x11690 — VERIFIED. Shrinks the bar to fit the box
// (10 pt margin, never below a 40-pt box) and centres it 50 pt from the
// top, compensating the scale so the visual top stays put.
- (void)layoutBarForPane:(ABPane *)pane {
    if (!pane.bar) return;
    CGFloat boxW = pane.box.bounds.size.width;
    CGFloat barW = pane.bar.bounds.size.width;
    CGFloat scale = (barW > boxW - 10 && boxW - 10 > 40) ? (boxW - 10) / barW : 1.0;
    pane.bar.transform = CGAffineTransformMakeScale(scale, scale);
    pane.bar.center = CGPointMake(boxW * 0.5, (1.0 - scale) * -52.0 * 0.5 + 50.0);
    [pane.box bringSubviewToFront:pane.bar];
    [pane.box bringSubviewToFront:pane.handleHit];
}

// -setBarVisible:pop:dim:single:forApp: @0x11868 — VERIFIED (entrance
// block @0x125C0 restores the saved transform under a spring).
- (void)setBarVisible:(BOOL)visible pop:(NSInteger)pop dim:(BOOL)dim
               single:(BOOL)single forApp:(NSString *)bundleID {
    ABPane *pane = [self paneFor:bundleID];
    if (!pane) return;
    if (!visible && !pane.bar) return;
    UIView *bar = pane.bar ?: [self buildBarForPane:pane];
    ABSetBarButtonContent(pane.popButton,
                          pop == 2 ? @"hm_split" : @"hm_float",
                          pop == 2 ? OMCTr(@"Chia màn", @"Split")
                                   : OMCTr(@"Cửa sổ nổi", @"Float"));
    pane.popButton.alpha = dim ? 0.35 : 1.0;
    ABSetBarButtonContent(pane.soloButton,
                          single ? @"hm_split" : @"hm_full",
                          single ? OMCTr(@"Chia màn", @"Split")
                                 : OMCTr(@"Toàn màn", @"Full screen"));
    [self layoutBarForPane:pane];
    ABApplyAccent(pane.handle, visible);
    if (bar.isHidden != visible) {
        if (!visible) {
            [self hideBarForPane:pane];
        } else {
            bar.hidden = NO;
            CGAffineTransform orig = bar.transform;
            bar.transform = CGAffineTransformConcat(
                CGAffineTransformScale(orig, 0.9, 0.9),
                CGAffineTransformMakeTranslation(0, -8));
            [UIView animateWithDuration:0.45 delay:0
                 usingSpringWithDamping:0.86      // double @0x2B278
                  initialSpringVelocity:0.4       // double @0x2B280
                                  options:2       // raw; AllowUserInteraction INFERRED
                               animations:^{ bar.transform = orig; }
                               completion:nil];
        }
    }
}

// -hideBarForPane: @0x12610 — VERIFIED (blocks @0x127CC/@0x12844: fade +
// shrink, then hide and restore the saved transform).
- (void)hideBarForPane:(ABPane *)pane {
    UIView *bar = pane.bar;
    if (!bar || bar.isHidden) return;
    ABApplyAccent(pane.handle, NO);
    CGAffineTransform saved = bar.transform;
    [UIView animateWithDuration:0.18 delay:0 options:0x10000   // CurveEaseIn INFERRED
                     animations:^{
        bar.alpha = 0;
        bar.transform = CGAffineTransformScale(saved, 0.94, 0.94);
    } completion:^(BOOL finished) {
        if (bar.alpha == 0) {
            bar.hidden = YES;
            bar.transform = saved;
        }
    }];
}

// -paneOfBarButton: @0x12F78 — VERIFIED.
- (ABPane *)paneOfBarButton:(id)button {
    for (ABPane *pane in self.panes)
        if (pane.bar && [(UIView *)button isDescendantOfView:pane.bar]) return pane;
    return nil;
}

// -setupHandleForPane: @0x133C8 — VERIFIED. The drag handle: a 44x24 hit
// area carrying the 34x12 pill (three dot-blue dots), wired to
// handleTapped:/handlePanned: and pinned via setHandleVisible:forPane:.
- (void)setupHandleForPane:(ABPane *)pane {
    UIView *handleHit = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 44, 24)];
    UIView *handle = [[UIView alloc] initWithFrame:CGRectMake(5, 6, 34, 12)];
    handle.backgroundColor = [UIColor colorWithWhite:1 alpha:0.35];
    handle.layer.cornerRadius = 6;
    handle.layer.borderWidth = 0.5;
    handle.layer.borderColor = [UIColor colorWithWhite:1 alpha:0.55].CGColor;
    handle.userInteractionEnabled = NO;
    for (CGFloat dotX = 9; dotX <= 23; dotX += 7) {
        UIView *dot = [[UIView alloc] initWithFrame:CGRectMake(dotX, 4, 4, 4)];
        dot.backgroundColor = [[UIColor colorWithRed:74.0/255.0 green:79.0/255.0
                                                blue:128.0/255.0 alpha:1]
                               colorWithAlphaComponent:0.85];
        dot.layer.cornerRadius = 2;
        [handle addSubview:dot];
    }
    [handleHit addSubview:handle];
    [handleHit addGestureRecognizer:[[UITapGestureRecognizer alloc]
        initWithTarget:self action:@selector(handleTapped:)]];
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc]
        initWithTarget:self action:@selector(handlePanned:)];
    pan.maximumNumberOfTouches = 1;
    [handleHit addGestureRecognizer:pan];
    handleHit.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin |
                                 UIViewAutoresizingFlexibleRightMargin;   // raw 5
    pane.handle = handle;
    pane.handleHit = handleHit;
    pane.box.handleHit = handleHit;
    [pane.box addSubview:handleHit];
    [self setHandleVisible:YES forPane:pane];
}

// -setHandleVisible:forPane: @0x137CC — VERIFIED.
- (void)setHandleVisible:(BOOL)visible forPane:(ABPane *)pane {
    pane.handleHit.hidden = !visible;
    pane.handleHit.center = CGPointMake(pane.box.bounds.size.width * 0.5 +
                                        pane.handleOffset, 12);
    [pane.box bringSubviewToFront:pane.handleHit];
}

// -raiseKnobs @0x13918 — VERIFIED.
- (void)raiseKnobs {
    for (UIView *knob in self.knobViews)
        if (knob.superview == self.window)
            [self.window bringSubviewToFront:knob];
}

// -setHandleOffset:forApp: @0x14C7C — VERIFIED.
- (void)setHandleOffset:(double)offset forApp:(NSString *)bundleID {
    ABPane *pane = [self paneFor:bundleID];
    if (pane && pane.handleOffset != offset) {
        pane.handleOffset = offset;
        [self setHandleVisible:!pane.handleHit.isHidden forPane:pane];
    }
}

// -setFront:forApp: @0x151A8 — VERIFIED (raiseKnobs runs only on the
// successful bring-to-front path).
- (void)setFront:(BOOL)front forApp:(NSString *)bundleID {
    ABPane *pane = [self paneFor:bundleID];
    if (front && pane && pane.box.superview == self.window) {
        [self.window bringSubviewToFront:pane.box];
        [self raiseKnobs];
    }
}

// -setKnobs: @0x13ABC (4544 B) — VERIFIED (blocks @0x171E4/@0x174F4).
// Reconciles the knob overlay with the spec array ([x, y, active,
// index?]): extra knobs are removed, missing ones built (66x66 hit disc,
// centred 14x14 glass dot named layer "omcDot"), each knob is centred on
// its spec point and spring-animated between rest and the 1.6x accented
// active state; an accent gradient ("omcAccent") is inserted below the
// dot layer while active and removed once faded out.
- (void)setKnobs:(id)specsArg {
    if (!self.knobViews) self.knobViews = [NSMutableArray array];
    NSArray *specs = [specsArg isKindOfClass:[NSArray class]] ? specsArg : @[];
    if (specs.count > 0 && ![self ensureWindow]) return;
    while (self.knobViews.count > specs.count) {
        [self.knobViews.lastObject removeFromSuperview];
        [self.knobViews removeLastObject];
    }
    for (NSUInteger i = 0; i < specs.count; i++) {
        NSArray *spec = specs[i];
        if (![spec isKindOfClass:[NSArray class]] || spec.count < 3) continue;
        ABKnobView *knob;
        if (i < self.knobViews.count) {
            knob = self.knobViews[i];
        } else {
            knob = [[ABKnobView alloc] initWithFrame:CGRectMake(0, 0, 66, 66)];
            knob.multipleTouchEnabled = NO;
            knob.backgroundColor = [UIColor colorWithWhite:1 alpha:0.012];
            knob.layer.cornerRadius = 33;
            UIView *dotView = [[UIView alloc] initWithFrame:CGRectMake(26, 26, 14, 14)];
            dotView.userInteractionEnabled = NO;
            dotView.backgroundColor = [UIColor clearColor];
            dotView.layer.cornerRadius = 7;
            UIVisualEffectView *blur = [[UIVisualEffectView alloc]
                initWithEffect:[UIBlurEffect effectWithStyle:11]];   // INFERRED name
            blur.frame = dotView.bounds;
            blur.autoresizingMask = UIViewAutoresizingFlexibleWidth |
                                    UIViewAutoresizingFlexibleHeight;   // raw 0x12
            blur.contentView.backgroundColor = [UIColor colorWithWhite:1 alpha:0.35];
            blur.layer.cornerRadius = 7;
            blur.clipsToBounds = YES;
            blur.userInteractionEnabled = NO;
            [dotView addSubview:blur];
            dotView.layer.borderWidth = 1.5;
            dotView.layer.borderColor = [UIColor colorWithWhite:1 alpha:0.95].CGColor;
            dotView.layer.shadowColor = [UIColor colorWithRed:110.0/255.0 green:100.0/255.0
                                                         blue:200.0/255.0 alpha:1].CGColor;
            dotView.layer.shadowOpacity = 0.45f;   // float @0x2B390
            dotView.layer.shadowRadius = 3;
            dotView.layer.shadowOffset = CGSizeMake(0, 1);
            CALayer *dotLayer = [CALayer layer];
            dotLayer.name = @"omcDot";
            dotLayer.frame = CGRectMake(5, 5, 4, 4);
            dotLayer.cornerRadius = 2;
            dotLayer.backgroundColor = [UIColor colorWithRed:74.0/255.0 green:79.0/255.0
                                                        blue:128.0/255.0 alpha:1].CGColor;
            [dotView.layer addSublayer:dotLayer];
            [knob addSubview:dotView];
            knob.dot = dotView;
            [self.knobViews addObject:knob];
        }
        if (knob.superview != self.window) [self.window addSubview:knob];
        [self.window bringSubviewToFront:knob];
        knob.index = spec.count >= 4 ? [spec[3] intValue] : (NSInteger)i;
        BOOL active = [spec[2] boolValue];
        knob.center = CGPointMake([spec[0] doubleValue], [spec[1] doubleValue]);
        CALayer *dotLayer = nil;
        CAGradientLayer *accent = nil;
        for (CALayer *layer in knob.dot.layer.sublayers) {
            if ([layer.name isEqualToString:@"omcDot"]) dotLayer = layer;
            else if ([layer.name isEqualToString:@"omcAccent"])
                accent = (CAGradientLayer *)layer;
        }
        if (!accent && active) {
            accent = [CAGradientLayer layer];
            accent.name = @"omcAccent";
            accent.colors = @[
                (id)[UIColor colorWithRed:155.0/255.0 green:135.0/255.0 blue:248.0/255.0 alpha:1].CGColor,
                (id)[UIColor colorWithRed:93.0/255.0 green:180.0/255.0 blue:246.0/255.0 alpha:1].CGColor];
            accent.startPoint = CGPointMake(0, 0);
            accent.endPoint = CGPointMake(1, 1);
            accent.frame = knob.dot.bounds;
            accent.cornerRadius = knob.dot.bounds.size.width * 0.5;
            accent.opacity = 0;
            if (dotLayer) [knob.dot.layer insertSublayer:accent below:dotLayer];
            else [knob.dot.layer addSublayer:accent];
        }
        [UIView animateWithDuration:(active ? 0.15 : 0.2) delay:0
             usingSpringWithDamping:0.7 initialSpringVelocity:0 options:4
                         animations:^{
            knob.transform = active ? CGAffineTransformMakeScale(1.6, 1.6)
                                    : CGAffineTransformIdentity;
            accent.opacity = active ? 1 : 0;
            dotLayer.backgroundColor = (active ? [UIColor whiteColor]
                : [UIColor colorWithRed:74.0/255.0 green:79.0/255.0
                                   blue:128.0/255.0 alpha:1]).CGColor;
            knob.layer.borderColor = [UIColor colorWithWhite:1
                                                       alpha:(active ? 1.0 : 0.95)].CGColor;
            knob.layer.shadowColor = (active
                ? [UIColor colorWithRed:110.0/255.0 green:120.0/255.0 blue:1 alpha:1]
                : [UIColor colorWithRed:110.0/255.0 green:100.0/255.0
                                   blue:200.0/255.0 alpha:1]).CGColor;
            knob.layer.shadowOpacity = active ? 0.5f : 0.45f;
            knob.layer.shadowRadius = active ? 7 : 3;
        } completion:^(BOOL finished) {
            if (!active && accent.opacity == 0) [accent removeFromSuperlayer];
        }];
    }
}

// -teardownPane: @0x155B0 — VERIFIED. The whole head runs under
// @try/@catch: a failure logs "teardown %@ loi %@" and resumes at the
// appViewController release below. Inside: invalidate the scene monitor,
// post orientation -1 (app gone), reset the scene VC's mode, detach its
// view, invalidate it, and — unless the app is the frontmost one — mark
// its scene backgrounded/non-foreground. The box then fades out and is
// removed (blocks @0x15C8C/@0x15C98).
- (void)teardownPane:(ABPane *)pane {
    // [fix-round2] [GPT-F] MILESTONE logging only (no flow change).
    OMCLogWrite(@"AppBridge", [NSString stringWithFormat:
        @"MILESTONE teardown bundle=%@ pane=%p",
        pane.bundleID, (void *)pane]);
    @try {
        [pane.sceneMonitor invalidate];
        pane.sceneMonitor = nil;
        ABPostOrientationToApp(pane.bundleID, -1);
        id vc = pane.appViewController;
        ABSendVI(vc, @"_setCurrentMode:", 0);
        [[vc view] removeFromSuperview];
        if ([vc respondsToSelector:@selector(invalidate)]) ABSendV0(vc, @"invalidate");
        id handle = ABSend0(vc, @"sceneHandle");
        id scene = ABSend0(handle, @"sceneIfExists");
        if (scene) {
            id front = ABSend0([UIApplication sharedApplication],
                               @"_accessibilityFrontMostApplication");
            NSString *frontID = ABSend0(front, @"bundleIdentifier");
            if (!front || ![frontID isEqualToString:pane.bundleID]) {
                ABSendVBlock(scene, @"updateSettingsWithBlock:", ^(id settings) {
                    ABSendVB(settings, @"setBackgrounded:", YES);
                    ABSendVB(settings, @"setForeground:", NO);
                });
            }
        }
    } @catch (NSException *e) {
        OMCLogWrite(@"AppBridge", [NSString stringWithFormat:
            @"teardown %@ loi %@", pane.bundleID, e]);
    }
    pane.appViewController = nil;
    pane.box.userInteractionEnabled = NO;
    [UIView animateWithDuration:0.15 animations:^{ pane.box.alpha = 0; }
                     completion:^(BOOL finished) {
        [pane.box removeFromSuperview];
    }];
}

// -setupLiveAppViewForPane: @0xC2BC (5876 B) — VERIFIED chain (all sends
// guarded; class checks via ABCheckCast with the original's baked-in
// ABHost.mm line numbers). Resolves the SBApplication, scene manager and
// display identity; builds the scene identity through the fuzzy
// ABResolveSelectorName + ABInvokeIdentityGetter pair (the original's
// iOS-version-tolerant lookup); creates request/handle/entity/VC; kicks
// the scene update transaction whose completion (block @0xE2A0) removes
// itself from the VC's _activeTransitions and, once the FBProcess
// signals launch completion (inner block @0xE4F0 -> main-queue block
// @0xE57C), lays the pane out, reveals it and posts "ready". Finally the
// app view is switched to display mode 4, the VC's view is inserted into
// the box, and an FBSceneMonitor is attached when a scene identifier
// string is available.
- (void)setupLiveAppViewForPane:(ABPane *)pane {
    id controller = ABSend0(objc_getClass("SBApplicationController"), @"sharedInstance");
    id app = ABSend1(controller, @"applicationWithBundleIdentifier:", pane.bundleID);
    pane.application = app;
    ABCheckCast(app, "SBApplication", 437);
    id sceneManager = ABSend0(objc_getClass("SBSceneManagerCoordinator"),
                              @"mainDisplaySceneManager");
    ABCheckCast(sceneManager, "SBMainDisplaySceneManager", 440);
    NSString *layoutSel = ABResolveSelectorName(sceneManager,
        @[@"layoutStateManager", @"_layoutStateManager"],
        @"layoutStateManager");
    id layoutState = layoutSel ? ABSend0(sceneManager, layoutSel) : nil;
    id displayIdentity = ABSend0(sceneManager, @"displayIdentity");
    ABCheckCast(displayIdentity, "FBSDisplayIdentity", 447);
    NSString *identitySel = ABResolveSelectorName(sceneManager,
        @[@"sceneIdentityForApplication:createPrimaryIfRequired:sceneSessionRole:",
          @"sceneIdentityForApplication:createPrimaryIfRequired:",
          @"_sceneIdentityForApplication:createPrimaryIfRequired:"],
        @"sceneIdentityForApplication");
    id sceneIdentity = ABInvokeIdentityGetter(sceneManager, identitySel, app,
                                              pane.bundleID, displayIdentity);
    if (sceneIdentity) {
        ABCheckCast(sceneIdentity, "FBSSceneIdentity", 455);
    } else {
        if ([app respondsToSelector:@selector(sceneIdentityForRole:)])
            sceneIdentity = ABSend1(app, @"sceneIdentityForRole:",
                                    UIWindowSceneSessionRoleApplication);
        ABCheckCast(sceneIdentity, "FBSSceneIdentity", 455);
    }
    id request = nil;
    {
        SEL sel = NSSelectorFromString(
            @"defaultRequestForApplication:sceneIdentity:displayIdentity:");
        id cls = objc_getClass("SBApplicationSceneHandleRequest");
        if ([cls respondsToSelector:sel]) {
            id (*fn)(id, SEL, id, id, id) = (void *)objc_msgSend;
            request = fn(cls, sel, app, sceneIdentity, displayIdentity);
        } else {
            ABMissingSelector(cls,
                @"defaultRequestForApplication:sceneIdentity:displayIdentity:");
        }
    }
    ABCheckCast(request, "SBApplicationSceneHandleRequest", 459);
    id handle = ABSend1(sceneManager, @"fetchOrCreateApplicationSceneHandleForRequest:",
                        request);
    ABCheckCast(handle, "SBDeviceApplicationSceneHandle", 461);
    id entity = ABSend1([objc_getClass("SBDeviceApplicationSceneEntity") alloc],
                        @"initWithApplicationSceneHandle:", handle);
    ABCheckCast(entity, "SBDeviceApplicationSceneEntity", 463);
    id vc = ABSend2([objc_getClass("SBAppViewController") alloc],
                    @"initWithIdentifier:andApplicationSceneEntity:",
                    pane.bundleID, entity);
    ABCheckCast(vc, "SBAppViewController", 465);
    pane.appViewController = vc;
    ABSendVB(vc, @"setIgnoresOcclusions:", NO);
    // @0xCED0-0xCEE4 — VERIFIED (final closure): the value object is
    // materialised by adrp/add straight into x2: it is the
    // NSConstantIntegerNumber living at __objc_intobj 0x395D0 (isa bind
    // _OBJC_CLASS_$_NSConstantIntegerNumber, type string "i" @0x297A6,
    // value word @0x395E0 = 2); the key cfstring @"_currentMode"
    // (@0x35E10) goes in x3, receiver (x22 = vc) in x0, selstub
    // setValue:forKey:. So the assignment is @2, not a guess:
    [vc setValue:@2 forKey:@"_currentMode"];
    id settings = [vc valueForKey:@"_activationSettings"];
    ABSendV0(settings, @"clearActivationSettings");
    id transaction = nil;
    {
        SEL sel = NSSelectorFromString(
            @"_createSceneUpdateTransactionForApplicationSceneEntity:deliveringActions:");
        if ([vc respondsToSelector:sel]) {
            id (*fn)(id, SEL, id, BOOL) = (void *)objc_msgSend;
            transaction = fn(vc, sel, entity, YES);
        } else {
            ABMissingSelector(vc,
                @"_createSceneUpdateTransactionForApplicationSceneEntity:deliveringActions:");
        }
    }
    ABCheckCast(transaction, "SBApplicationSceneUpdateTransaction", 473);
    id transitions = [vc valueForKey:@"_activeTransitions"];
    [transitions addObject:transaction];
    __weak ABHost *weakSelf = self;
    __weak ABPane *weakPane = pane;
    ABSendVBlock(transaction, @"setCompletionBlock:", ^(NSInteger result) {
        // [fix-round2] MILESTONE logging only (no flow change).
        OMCLogWrite(@"AppBridge", [NSString stringWithFormat:
            @"MILESTONE transaction-complete bundle=%@ pane=%p readySource=launch-callback result=%d",
            weakPane.bundleID, (void *)weakPane, (int)result]);
        [transitions removeObject:transaction];
        id launchTransaction = [transaction valueForKey:@"_processLaunchTransaction"];
        id process = launchTransaction ? ABSend0(launchTransaction, @"process") : nil;
        void (^afterLaunch)(void) = ^{
            // [fix-round2] MILESTONE logging only (no flow change):
            // this block is what _executeBlockAfterLaunchCompletes:
            // invokes (or the no-process fallback calls directly).
            OMCLogWrite(@"AppBridge", [NSString stringWithFormat:
                @"MILESTONE process-launch-complete bundle=%@ pane=%p readySource=launch-callback",
                weakPane.bundleID, (void *)weakPane]);
            dispatch_async(dispatch_get_main_queue(), ^{
                ABHost *host = weakSelf;
                ABPane *p = weakPane;
                if (!host || !p) return;
                if (![host.panes containsObject:p]) return;
                ABPostOrientationToApp(p.bundleID, p.orientation);   // INFERRED position
                [host layoutPane:p];
                // [fix-round2] MILESTONE logging only (no flow change).
                OMCLogWrite(@"AppBridge", [NSString stringWithFormat:
                    @"MILESTONE revealPane bundle=%@ pane=%p readySource=launch-callback",
                    p.bundleID, (void *)p]);
                [host revealPane:p];
                if (!p.ready) {
                    p.ready = YES;
                    ABPostStateToApp(@"ready", p.bundleID);
                }
            });
        };
        if (process) {
            SEL sel = NSSelectorFromString(@"_executeBlockAfterLaunchCompletes:");
            if ([process respondsToSelector:sel]) {
                void (*fn)(id, SEL, id) = (void *)objc_msgSend;
                fn(process, sel, afterLaunch);
            } else {
                ABMissingSelector(process, @"_executeBlockAfterLaunchCompletes:");
            }
        } else {
            OMCLogWrite(@"AppBridge", [NSString stringWithFormat:
                @"khong co FBProcess sau launch (result=%d), coi nhu da chay",
                (int)result]);
            afterLaunch();
        }
    });
    ABSendV0(transaction, @"begin");
    // [fix-round2] The original @0xD200 calls _createSceneViewController
    // and discards the result untouched (no retain/release/store/message
    // on x0 before the next send) — so it is sent here as a void call,
    // NOT via id-returning ABSend0 (whose "create" name would imply an
    // ARC-family retained return). The type-encoding line below lets a
    // device log settle the method's true return type definitively.
    {
        Method csMethod = class_getInstanceMethod([vc class],
            NSSelectorFromString(@"_createSceneViewController"));
        const char *csEnc = csMethod ? method_getTypeEncoding(csMethod) : NULL;
        OMCLogWrite(@"AppBridge", [NSString stringWithFormat:
            @"MILESTONE type-encoding _createSceneViewController class=%@ encoding=%s bundle=%@ pane=%p",
            NSStringFromClass([vc class]), csEnc ? csEnc : "(none)",
            pane.bundleID, (void *)pane]);
    }
    ABSendV0(vc, @"_createSceneViewController");
    id factory = ABSend0(objc_getClass("SBApplicationSceneView"),
                         @"defaultDisplayModeAnimationFactory");
    id appView = ABSend0(vc, @"appView");
    {
        SEL sel = NSSelectorFromString(@"setDisplayMode:animationFactory:completion:");
        if ([appView respondsToSelector:sel]) {
            void (*fn)(id, SEL, NSInteger, id, id) = (void *)objc_msgSend;
            fn(appView, sel, 4, factory, nil);
        } else {
            ABMissingSelector(appView, @"setDisplayMode:animationFactory:completion:");
        }
    }
    UIView *vcView = [vc view];
    vcView.backgroundColor = [UIColor clearColor];
    [pane.box insertSubview:vcView atIndex:0];
    // [fix-round2] [GPT-F] MILESTONE logging only (no flow change).
    OMCLogWrite(@"AppBridge", [NSString stringWithFormat:
        @"MILESTONE scene-attached bundle=%@ pane=%p viewClass=%@",
        pane.bundleID, (void *)pane, NSStringFromClass([vcView class])]);
    NSString *primarySel = ABResolveSelectorName(layoutState,
        @[@"primarySceneIdentifierForBundleIdentifier:sceneSessionRole:displayIdentity:",
          @"primarySceneIdentifierForBundleIdentifier:"],
        @"primarySceneIdentifierForBundleIdentifier");
    id sceneID = ABInvokeIdentityGetter(layoutState, primarySel, app,
                                        pane.bundleID, displayIdentity);
    if (sceneID && [sceneID isKindOfClass:[NSString class]]) {
        id monitor = ABSend1([objc_getClass("FBSceneMonitor") alloc],
                             @"initWithSceneID:", sceneID);
        pane.sceneMonitor = monitor;
        // [fix-round2] setDelegate: returns void (original @0xD518
        // ignores the msgSend result entirely) — void send, not ABSend1.
        ABSendV1(monitor, @"setDelegate:", self);
    }
}

@end
