// HL32 — native scene keyboard traits/keyplane policy, not a drawn keyboard.
// Derived from a SHA-pinned read-only study of DuoNavi 1.0.4, NOT vendor code.
// No hard-coded 50% size, input content, hardware-keyboard spoof, or TCC edits.
// Runtime ABI probes fail closed when UIKit private methods are absent.
#import "ABKeyboardTraits104.h"
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <objc/runtime.h>
#import <objc/message.h>
#import <substrate.h>
#import <math.h>
#import <stdlib.h>
#import <string.h>
extern void OMCLogWrite(NSString *tag, NSString *message);

static BOOL KB104Hosted = NO;
static double KB104LogicalW = 0, KB104PhysicalW = 0, KB104WindowW = 0;
static NSInteger KB104Orientation = 1;
static unsigned long long KB104Revision = 0;
static NSUInteger KB104Hooks = 0;
static NSString *KB104LastWidthLog = nil;

static BOOL KB104ValidWidth(double w) {
    return isfinite(w) && w >= 200.0 && w <= 1400.0;
}
static BOOL KB104Eligible(void) {
    return KB104Hosted && [NSThread isMainThread];
}
static double KB104ReferenceWidth(void) {
    // The actual hosted key UIWindow is already in scene LOGICAL points.
    // Do not scale the same width again by pane zoom or by a phone screen.
    if (!KB104Eligible()) return 0.0;
    return KB104ValidWidth(KB104WindowW) ? KB104WindowW :
           KB104ValidWidth(KB104LogicalW) ? KB104LogicalW : 0.0;
}
static BOOL KB104Type(char actual, char expected) {
    if (expected == 'Q') return actual == 'q' || actual == 'i' ||
                                actual == 'Q' || actual == 'I';
    if (expected == '{') return actual == '{';
    return actual == expected;
}
static BOOL KB104Signature(Class cls, SEL selector, BOOL meta,
                           unsigned int count, char result,
                           char arg2, char arg3) {
    if (!cls) return NO;
    Class receiver = meta ? object_getClass(cls) : cls;
    Method method = class_getInstanceMethod(receiver, selector);
    if (!method || method_getNumberOfArguments(method) != count) return NO;
    char *ret = method_copyReturnType(method);
    BOOL ok = ret && KB104Type(ret[0], result);
    free(ret);
    if (ok && result == '{') {
        // A struct return is ABI-compatible only if it is really CGSize.
        // A CGRect/other UIKit struct would corrupt the returned registers.
        const char *types=method_getTypeEncoding(method);
        NSMethodSignature *signature=types
            ? [NSMethodSignature signatureWithObjCTypes:types] : nil;
        ok=signature && signature.methodReturnLength==sizeof(CGSize);
    }
    if (ok && count >= 3) {
        char *arg = method_copyArgumentType(method, 2);
        ok = arg && KB104Type(arg[0], arg2); free(arg);
    }
    if (ok && count >= 4) {
        char *arg = method_copyArgumentType(method, 3);
        ok = arg && KB104Type(arg[0], arg3); free(arg);
    }
    return ok;
}
void ABKB104SetHostGeometry(BOOL hosted, CGFloat logicalWidth,
                            CGFloat physicalWidth, NSInteger orientation,
                            unsigned long long revision) {
    if (![NSThread isMainThread]) return;
    BOOL valid = hosted && KB104ValidWidth(logicalWidth) &&
                 isfinite(physicalWidth) && physicalWidth >= 100 &&
                 physicalWidth <= logicalWidth;
    double width = valid ? logicalWidth : 0;
    if (valid != KB104Hosted || fabs(width-KB104LogicalW) > 1 ||
        KB104Orientation != orientation) {
        KB104WindowW = 0; // Never reuse a previous scene/window dimension.
        OMCLogWrite(@"AppBridge",[NSString stringWithFormat:
            @"[hl32-kbtraits] event=host-geometry native=%d physical=%.1f logical=%.1f orientation=%ld rev=%llu",
            (int)valid,(double)physicalWidth,width,(long)orientation,revision]);
    }
    KB104Hosted = valid;
    KB104LogicalW = width;
    KB104PhysicalW = valid ? physicalWidth : 0;
    KB104Orientation = orientation;
    KB104Revision = revision;
}
void ABKB104NoteWindowWidth(CGFloat width) {
    if (!KB104Eligible() || !KB104ValidWidth(width)) return;
    // Trusted from the hosted process key UIWindow, not remote CarPlay pixels.
    if (KB104LogicalW > 0 && width > KB104LogicalW * 1.8) return;
    if (fabs(KB104WindowW-width) > 1) KB104WindowW = width;
}
static void KB104WriteTraits(id traits) {
    double width = KB104ReferenceWidth();
    if (!KB104ValidWidth(width) || !traits) return;
    Class cls = objc_getClass("UIKBScreenTraits");
    SEL setter = NSSelectorFromString(@"setKeyboardWidth:");
    if (!cls || ![traits isKindOfClass:cls] ||
        !KB104Signature(cls,setter,NO,3,'v','d',0)) return;
    @try {
        // Original 1.0.4 sets width on screen traits before layout is built.
        ((void (*)(id,SEL,double))objc_msgSend)(traits,setter,width);
        NSString *stamp=[NSString stringWithFormat:@"%.1f/%llu",width,KB104Revision];
        if (![stamp isEqualToString:KB104LastWidthLog]) {
            KB104LastWidthLog=stamp;
            OMCLogWrite(@"AppBridge",[NSString stringWithFormat:
                @"[hl32-kbtraits] event=traits-width value=%.1f logical=%.1f physical=%.1f rev=%llu",
                width,KB104LogicalW,KB104PhysicalW,KB104Revision]);
        }
        SEL idiom=NSSelectorFromString(@"setIdiomToEmulate:");
        if (KB104Signature(cls,idiom,NO,3,'v','Q',0))
            ((void (*)(id,SEL,NSInteger))objc_msgSend)(traits,idiom,(NSInteger)0);
        SEL emulating=NSSelectorFromString(@"setIsEmulatingIdiom:");
        Method method=class_getInstanceMethod(cls,emulating);
        if (method && method_getNumberOfArguments(method)==3) {
            char *type=method_copyArgumentType(method,2);
            BOOL valid=type && (type[0]=='B'||type[0]=='c');
            free(type);
            if (valid)
                ((void (*)(id,SEL,BOOL))objc_msgSend)(traits,emulating,YES);
        }
    } @catch (NSException *e) {
        OMCLogWrite(@"AppBridge",[NSString stringWithFormat:
             @"[hl32-kbtraits] event=traits-exception name=%@",e.name]);
    }
}
static NSString *KB104CorrectKeyboardName(NSString *name) {
    NSString *prefix=(KB104Orientation==3 || KB104Orientation==4)
        ? @"iPhone-Landscape" : @"iPhone-Portrait";
    if (![name isKindOfClass:NSString.class] || !name.length)
        return [prefix stringByAppendingString:@"-QWERTY"];
    if ([name containsString:@"(null)"])
        return [name stringByReplacingOccurrencesOfString:@"(null)" withString:prefix];
    if (![name containsString:@"iPhone"] && ![name containsString:@"iPad"])
        return [NSString stringWithFormat:@"%@-%@",prefix,name];
    return name;
}

static id (*KB104OrigFactory)(id,SEL,id,NSInteger);
static void (*KB104OrigName)(id,SEL,id);
static void (*KB104OrigNameAppearance)(id,SEL,id,NSInteger);
static void (*KB104OrigPlane)(id,SEL,id);
static void (*KB104OrigScreenTraits)(id,SEL,id);
static double (*KB104OrigWidth)(id,SEL);
static CGSize (*KB104OrigReference)(id,SEL);

static id KB104Factory(id cls, SEL cmd, id screen, NSInteger orientation) {
    id result=KB104OrigFactory ? KB104OrigFactory(cls,cmd,screen,orientation):nil;
    if (KB104Eligible()) KB104WriteTraits(result);
    return result;
}
static void KB104Name(id self, SEL cmd, id name) {
    id final=KB104Eligible() ? KB104CorrectKeyboardName(name) : name;
    if (KB104OrigName) KB104OrigName(self,cmd,final);
}
static void KB104NameAppearance(id self, SEL cmd, id name, NSInteger appearance) {
    id final=KB104Eligible() ? KB104CorrectKeyboardName(name) : name;
    if (KB104OrigNameAppearance) KB104OrigNameAppearance(self,cmd,final,appearance);
}
static void KB104Plane(id self, SEL cmd, id plane) {
    id final=plane;
    if (KB104Eligible() && (![plane isKindOfClass:NSString.class] ||
          ![(NSString *)plane length] ||
          [(NSString *)plane containsString:@"(null)"])) final=@"letters";
    if (KB104OrigPlane) KB104OrigPlane(self,cmd,final);
}
static void KB104ScreenTraits(id self, SEL cmd, id traits) {
    if (KB104Eligible()) KB104WriteTraits(traits);
    if (KB104OrigScreenTraits) KB104OrigScreenTraits(self,cmd,traits);
}
static double KB104Width(id self, SEL cmd) {
    double original=KB104OrigWidth ? KB104OrigWidth(self,cmd):0;
    double wanted=KB104ReferenceWidth();
    return KB104ValidWidth(wanted)?wanted:original;
}
static CGSize KB104Reference(id self, SEL cmd) {
    CGSize original=KB104OrigReference ? KB104OrigReference(self,cmd):CGSizeZero;
    double wanted=KB104ReferenceWidth();
    if (KB104ValidWidth(wanted) && isfinite(original.height) && original.height>0)
        original.width=wanted;
    return original;
}
static void KB104Hook(Class cls, SEL sel, BOOL meta, NSUInteger bit, IMP repl,
                      IMP *original, unsigned int count, char ret,
                      char a2, char a3, NSString *label) {
    if ((KB104Hooks & bit) || !KB104Signature(cls,sel,meta,count,ret,a2,a3)) return;
    MSHookMessageEx(meta?object_getClass(cls):cls,sel,repl,original);
    if (*original) {
        KB104Hooks |= bit;
        OMCLogWrite(@"AppBridge",[NSString stringWithFormat:
             @"[hl32-kbtraits] event=hook-installed selector=%@ status=ABI-guarded",
             label]);
    }
}
void ABKB104InstallIfAvailable(void) {
    if (!KB104Eligible()) return;
    Class traits=objc_getClass("UIKBScreenTraits");
    Class star=objc_getClass("UIKeyboardLayoutStar");
    if (traits) {
        KB104Hook(traits,NSSelectorFromString(@"traitsWithScreen:orientation:"),YES,
            1u<<0,(IMP)KB104Factory,(IMP *)&KB104OrigFactory,4,'@','@','Q',
            @"traitsWithScreen:orientation:");
        KB104Hook(traits,NSSelectorFromString(@"keyboardWidth"),NO,
            1u<<1,(IMP)KB104Width,(IMP *)&KB104OrigWidth,2,'d',0,0,
            @"keyboardWidth");
        KB104Hook(traits,NSSelectorFromString(@"keyboardScreenReferenceSize"),NO,
            1u<<2,(IMP)KB104Reference,(IMP *)&KB104OrigReference,2,'{',0,0,
            @"keyboardScreenReferenceSize");
    }
    if (star) {
        KB104Hook(star,NSSelectorFromString(@"setKeyboardName:"),NO,
            1u<<3,(IMP)KB104Name,(IMP *)&KB104OrigName,3,'v','@',0,
            @"setKeyboardName:");
        KB104Hook(star,NSSelectorFromString(@"setKeyboardName:appearance:"),NO,
            1u<<4,(IMP)KB104NameAppearance,(IMP *)&KB104OrigNameAppearance,
            4,'v','@','Q',@"setKeyboardName:appearance:");
        KB104Hook(star,NSSelectorFromString(@"setKeyplaneName:"),NO,
            1u<<5,(IMP)KB104Plane,(IMP *)&KB104OrigPlane,3,'v','@',0,
            @"setKeyplaneName:");
        KB104Hook(star,NSSelectorFromString(@"setScreenTraits:"),NO,
            1u<<6,(IMP)KB104ScreenTraits,(IMP *)&KB104OrigScreenTraits,
            3,'v','@',0,@"setScreenTraits:");
    }
}
BOOL ABKB104RefreshLayout(UIView *layout) {
    if (!KB104Eligible() || !layout || !KB104ValidWidth(KB104ReferenceWidth()))
        return NO;
    Class cls=objc_getClass("UIKeyboardLayoutStar");
    SEL sel=NSSelectorFromString(@"screenTraits");
    if (!cls || ![layout isKindOfClass:cls] ||
        !KB104Signature(cls,sel,NO,2,'@',0,0)) return NO;
    @try {
        id traits=((id (*)(id,SEL))objc_msgSend)(layout,sel);
        if (!traits) return NO;
        KB104WriteTraits(traits);
        // Only a settled host geometry calls here. UIKit owns layout/keycaps.
        [layout setNeedsLayout];
        return YES;
    } @catch (NSException *e) {
        OMCLogWrite(@"AppBridge",[NSString stringWithFormat:
             @"[hl32-kbtraits] event=refresh-failed exception=%@",e.name]);
        return NO;
    }
}
