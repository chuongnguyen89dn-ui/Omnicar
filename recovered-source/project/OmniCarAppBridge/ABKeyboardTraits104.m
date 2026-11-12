// HL32 — native scene keyboard traits/keyplane policy, not a drawn keyboard.
// Derived from a SHA-pinned read-only study of DuoNavi 1.0.4, NOT vendor code.
// No hard-coded 50% size, input content, hardware-keyboard spoof, or TCC edits.
// Runtime ABI probes fail closed when UIKit private methods are absent.
#import "ABKeyboardTraits104.h"
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import <objc/runtime.h>
#import <objc/message.h>
#import <substrate.h>
#import <math.h>
#import <stdlib.h>
#import <string.h>
extern void OMCLogWrite(NSString *tag, NSString *message);

static BOOL KB104Hosted = NO;
static double KB104LogicalW=0, KB104PhysicalW=0, KB104WindowW=0;
static double KB104LogicalH=0, KB104PhysicalH=0;
static NSMapTable<UIView *,NSDictionary *> *KB104ClipSnapshots;
// HL34: only owner of a hosted native keyboard UIWindow frame.
// Other hooks configure traits/keyplanes; they must NEVER write window
// geometry, and layout callback hooks only manage clip/mask.
static __weak UIWindow *KB104PositionedWindow;
static CGRect KB104OriginalWindowFrame;
static CGRect KB104LastPositionedFrame;
static BOOL KB104HasFrameSnapshot=NO;
static unsigned long long KB104PositionedRevision=0;
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
    // One owner: committed host-scene packet. UIWindow is diagnostic
    // bootstrap only; it MUST NOT supersede a received packet.
    return KB104ValidWidth(KB104LogicalW) ? KB104LogicalW :
           KB104ValidWidth(KB104WindowW) ? KB104WindowW : 0.0;
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
                            unsigned long long revision,
                            CGFloat logicalHeight, CGFloat physicalHeight) {
    if (![NSThread isMainThread]) return;
    BOOL valid=hosted && KB104ValidWidth(logicalWidth) &&
        isfinite(physicalWidth) && physicalWidth>=100 &&
        physicalWidth<=1800 && physicalWidth/logicalWidth>=0.45 &&
        physicalWidth/logicalWidth<=2.1;
    BOOL validH=isfinite(logicalHeight) && logicalHeight>=200 &&
        logicalHeight<=1800 && isfinite(physicalHeight) &&
        physicalHeight>=100 && physicalHeight/logicalHeight>=0.45 &&
        physicalHeight/logicalHeight<=2.1;
    double width = valid ? logicalWidth : 0;
    if (valid != KB104Hosted || fabs(width-KB104LogicalW) > 1 ||
        KB104Orientation != orientation) {
        KB104WindowW = 0; // Never reuse a previous scene/window dimension.
        OMCLogWrite(@"AppBridge",[NSString stringWithFormat:
            @"[hl32-kbtraits] event=host-geometry native=%d physical=%.1f logical=%.1f orientation=%ld rev=%llu",
            (int)valid,(double)physicalWidth,width,(long)orientation,revision]);
    }
    if (KB104Hosted && !valid) {
        ABKB104RestoreKeyboardWindow(@"geometry-revoked");
        ABKB104RestoreClips(@"geometry-revoked");
    }
    KB104Hosted = valid;
    KB104LogicalW = width;
    KB104PhysicalW = valid ? physicalWidth : 0;
    KB104LogicalH = valid && validH ? logicalHeight : 0;
    KB104PhysicalH = valid && validH ? physicalHeight : 0;
    KB104Orientation = orientation;
    KB104Revision = revision;
}
void ABKB104NoteWindowWidth(CGFloat width) {
    if (!KB104Eligible() || !KB104ValidWidth(width)) return;
    // Trusted from the hosted process key UIWindow, not remote CarPlay pixels.
    if (KB104LogicalW > 0 &&
        fabs(width-KB104LogicalW)>KB104LogicalW*.65) {
        OMCLogWrite(@"AppBridge",[NSString stringWithFormat:
            @"[hl33-kb-owner] event=window-bootstrap-ignored actual=%.1f packet=%.1f",
            (double)width,KB104LogicalW]);
        return;
    }
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
    // HL33 accidentally overrode keyboardScreenReferenceSize.height with
    // the SPLIT PANE's height. That value is NOT a keyboard screen height.
    // DuoNavi 1.0.4 audit did not validate such a setter. Keep UIKit's
    // original height to preserve keyplane creation and vertical anchor.
    if (KB104ValidWidth(wanted) && isfinite(original.height) &&
        original.height>0) original.width=wanted;
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
static void (*KB104OrigContainerLayout)(id,SEL);
static void (*KB104OrigHostLayout)(id,SEL);
static void (*KB104OrigContainerMove)(id,SEL);
static void (*KB104OrigHostMove)(id,SEL);
static void KB104ContainerLayout(id,SEL);
static void KB104HostLayout(id,SEL);
static void KB104ContainerMove(id,SEL);
static void KB104HostMove(id,SEL);
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
    // Two source-level native UIKit clipping hooks from DuoNavi 1.0.4
    // disassembly IMP 0x2d2aa8/0x2d2ca0. Install once and act ONLY on the
    // currently hosted keyboard-window subtree, not other app UI.
    Class container=objc_getClass("UIInputSetContainerView");
    Class host=objc_getClass("UIInputSetHostView");
    if (container) {
        KB104Hook(container,@selector(layoutSubviews),NO,
            1u<<7,(IMP)KB104ContainerLayout,(IMP *)&KB104OrigContainerLayout,
            2,'v',0,0,@"UIInputSetContainerView.layoutSubviews");
        KB104Hook(container,@selector(didMoveToWindow),NO,
            1u<<8,(IMP)KB104ContainerMove,(IMP *)&KB104OrigContainerMove,
            2,'v',0,0,@"UIInputSetContainerView.didMoveToWindow");
    }
    if (host) {
        KB104Hook(host,@selector(layoutSubviews),NO,
            1u<<9,(IMP)KB104HostLayout,(IMP *)&KB104OrigHostLayout,
            2,'v',0,0,@"UIInputSetHostView.layoutSubviews");
        KB104Hook(host,@selector(didMoveToWindow),NO,
            1u<<10,(IMP)KB104HostMove,(IMP *)&KB104OrigHostMove,
            2,'v',0,0,@"UIInputSetHostView.didMoveToWindow");
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

static BOOL KB104CloseEnough(CGRect a, CGRect b) {
    return fabs(a.origin.x-b.origin.x)<2.0 &&
           fabs(a.origin.y-b.origin.y)<2.0 &&
           fabs(a.size.width-b.size.width)<2.0 &&
           fabs(a.size.height-b.size.height)<2.0;
}
void ABKB104RestoreKeyboardWindow(NSString *reason) {
    if (![NSThread isMainThread] || !KB104HasFrameSnapshot) return;
    UIWindow *win=KB104PositionedWindow;
    BOOL canRestore=win && CGAffineTransformIsIdentity(win.transform) &&
        KB104CloseEnough(win.frame,KB104LastPositionedFrame);
    if (canRestore) win.frame=KB104OriginalWindowFrame;
    OMCLogWrite(@"AppBridge",[NSString stringWithFormat:
        @"[hl34-keyboard] event=single-owner-release reason=%@ restored=%d "
         "last=%@ original=%@",
        reason,(int)canRestore,
        NSStringFromCGRect(KB104LastPositionedFrame),
        NSStringFromCGRect(KB104OriginalWindowFrame)]);
    KB104PositionedWindow=nil;
    KB104HasFrameSnapshot=NO;
    KB104PositionedRevision=0;
}
// UIKit may still have a plane from the preceding pane width.
// Check its actual key-bearing bounds, not LayoutStar decoration.
static BOOL KB104PlaneFitsViewport(CGRect plane,CGFloat width) {
    if (CGRectIsNull(plane) || CGRectIsEmpty(plane) || !isfinite(width))
        return NO;
    CGFloat left=CGRectGetMinX(plane),right=CGRectGetMaxX(plane);
    return isfinite(left) && isfinite(right) &&
           left>=-1.0 && right<=width+1.0;
}
BOOL ABKB104PlaceKeyboardWindow(UIWindow *keyboard,UIWindow *sceneWindow,
                               CGRect keyplaneInWindow,NSString *reason) {
    if (!KB104Eligible() || !keyboard || !sceneWindow ||
        keyboard==sceneWindow || keyboard.hidden || keyboard.alpha<0.01)
        return NO;
    NSString *cn=NSStringFromClass(keyboard.class);
    if (![cn containsString:@"UIRemoteKeyboardWindow"] ||
        keyboard.screen!=sceneWindow.screen ||
        !CGAffineTransformIsIdentity(keyboard.transform) ||
        !CGAffineTransformIsIdentity(sceneWindow.transform)) return NO;
    CGRect target=sceneWindow.frame, before=keyboard.frame;
    CGFloat reference=KB104ReferenceWidth();
    if (!isfinite(target.origin.x)||!isfinite(target.origin.y)||
        !isfinite(target.size.width)||!isfinite(target.size.height)||
        target.size.width<200||target.size.width>1400||
        target.size.height<200||target.size.height>1400||
        !KB104ValidWidth(reference)||
        fabs(target.size.width-reference)>3.0) {
        OMCLogWrite(@"AppBridge",[NSString stringWithFormat:
            @"[hl34-keyboard] event=viewport-deferred reason=unsettled-scene "
             "packet=%.1f target=%@ when=%@",
            reference,NSStringFromCGRect(target),reason]);
        return NO;
    }
    if (KB104PositionedWindow && KB104PositionedWindow!=keyboard)
        ABKB104RestoreKeyboardWindow(@"keyboard-window-replaced");
    // Do not modify any custom keyboard window, keyplane, layoutStar,
    // keyboard.transform or UIWindowScene. Defer narrowing until UIKit
    // has recomputed its own key-bearing layout. One authenticated
    // scene key-window frame is the only geometry reference.
    BOOL changed=!KB104CloseEnough(before,target);
    BOOL fits=KB104PlaneFitsViewport(keyplaneInWindow,target.size.width);
    BOOL narrowing=before.size.width>target.size.width+1.0;
    // Prevent a host packet from shrinking the remote keyboard UIWindow
    // while UIKit's keyplane still has the previous wider geometry.
    // On an unchanged viewport, an out-of-bounds plane also needs UIKit
    // relayout. Enlargements cannot clip existing keyplane content.
    if (!fits && (narrowing || !changed)) {
        OMCLogWrite(@"AppBridge",[NSString stringWithFormat:
            @"[hl36-kbsync] event=viewport-await-uikit rev=%llu when=%@ "
             "old=%@ target=%@ plane=%@ narrowing=%d action=defer",
            KB104Revision,reason,NSStringFromCGRect(before),
            NSStringFromCGRect(target),NSStringFromCGRect(keyplaneInWindow),
            (int)narrowing]);
        return NO;
    }
    if (changed && !KB104HasFrameSnapshot) {
        KB104PositionedWindow=keyboard;
        KB104OriginalWindowFrame=before;
        KB104HasFrameSnapshot=YES;
    }
    if (changed) {
        // If UIKit has moved this window independently after our last
        // commit, do not race it. Only our original or last frame
        // authorizes another write for the next committed scene revision.
        BOOL ours=!KB104HasFrameSnapshot ||
            KB104CloseEnough(before,KB104OriginalWindowFrame)||
            KB104CloseEnough(before,KB104LastPositionedFrame);
        if (!ours) {
            OMCLogWrite(@"AppBridge",
                @"[hl34-keyboard] event=viewport-deferred reason=UIKit-moved-window");
            return NO;
        }
        keyboard.frame=target; // THE ONLY keyboard.frame writer in HL34.
        KB104LastPositionedFrame=target;
        KB104PositionedRevision=KB104Revision;
    }
    OMCLogWrite(@"AppBridge",[NSString stringWithFormat:
        @"[hl34-keyboard] event=native-window-placed when=%@ changed=%d "
         "packetW=%.1f revision=%llu before=%@ after=%@ "
         "transform=identity rollbackOnClipFailure=DISABLED rasterTouch=DEVICE-PENDING",
        reason,(int)changed,reference,KB104Revision,
        NSStringFromCGRect(before),NSStringFromCGRect(keyboard.frame)]);
    return YES;
}

static BOOL KB104KeyboardWindow(UIView *view) {
    UIWindow *window=view.window;
    NSString *name=window?NSStringFromClass(window.class):@"";
    return window && [name containsString:@"Keyboard"] &&
           !window.hidden && window.alpha>0.01;
}
static void KB104UnclipOwnedView(UIView *origin) {
    if (!KB104Eligible() || !origin || !KB104KeyboardWindow(origin)) return;
    UIWindow *window=origin.window;
    if (!KB104ClipSnapshots)
        KB104ClipSnapshots=[NSMapTable weakToStrongObjectsMapTable];
    NSUInteger depth=0,changed=0;
    // Keep UIWindow and parent host scene boundaries intact, unlike
    // an unsafe global UIKit clipsToBounds=NO hook.
    for (UIView *v=origin;v && v!=(UIView *)window && depth<18;
         v=v.superview,depth++) {
        NSDictionary *existing=[KB104ClipSnapshots objectForKey:v];
        CALayer *layer=v.layer;
        if (existing) {
            // UIKit may reset masks during a new input-mode layout.
            if (v.clipsToBounds || layer.masksToBounds || layer.mask ||
                layer.cornerRadius!=0) {
                v.clipsToBounds=NO;layer.masksToBounds=NO;
                layer.mask=nil;layer.cornerRadius=0;changed++;
            }
            continue;
        }
        if (!v.clipsToBounds && !layer.masksToBounds &&
            !layer.mask && layer.cornerRadius==0) continue;
        NSDictionary *snapshot=@{
            @"clips":@(v.clipsToBounds),
            @"masks":@(layer.masksToBounds),
            @"mask":layer.mask?:NSNull.null,
            @"radius":@(layer.cornerRadius),
        };
        [KB104ClipSnapshots setObject:snapshot forKey:v];
        v.clipsToBounds=NO;
        layer.masksToBounds=NO;
        layer.mask=nil;
        layer.cornerRadius=0;
        changed++;
    }
    if (changed)
        OMCLogWrite(@"AppBridge",[NSString stringWithFormat:
            @"[hl33-kb-owner] event=unclip-owned count=%lu window=%@ "
             "clipHostBoundary=UNCHANGED",
            (unsigned long)changed,NSStringFromClass(window.class)]);
}
void ABKB104RestoreClips(NSString *reason) {
    if (![NSThread isMainThread] || !KB104ClipSnapshots) return;
    NSUInteger restored=0,skipped=0;
    NSArray<UIView *> *views=[KB104ClipSnapshots.keyEnumerator allObjects];
    for (UIView *v in views) {
        NSDictionary *s=[KB104ClipSnapshots objectForKey:v];
        if (!s) continue;
        CALayer *l=v.layer;
        if (!v.clipsToBounds && !l.masksToBounds && !l.mask &&
            l.cornerRadius==0) {
            v.clipsToBounds=[s[@"clips"] boolValue];
            l.masksToBounds=[s[@"masks"] boolValue];
            l.mask=s[@"mask"]==NSNull.null?nil:s[@"mask"];
            l.cornerRadius=[s[@"radius"] doubleValue];
            restored++;
        } else skipped++; // UIKit may have changed it for a new mode.
    }
    [KB104ClipSnapshots removeAllObjects];
    OMCLogWrite(@"AppBridge",[NSString stringWithFormat:
        @"[hl33-kb-owner] event=clip-restore reason=%@ restored=%lu skipped=%lu",
        reason,(unsigned long)restored,(unsigned long)skipped]);
}
static void KB104ContainerLayout(id self,SEL cmd) {
    if (KB104OrigContainerLayout) KB104OrigContainerLayout(self,cmd);
    KB104UnclipOwnedView(self);
}
static void KB104HostLayout(id self,SEL cmd) {
    if (KB104OrigHostLayout) KB104OrigHostLayout(self,cmd);
    KB104UnclipOwnedView(self);
}
static void KB104ContainerMove(id self,SEL cmd) {
    if (KB104OrigContainerMove) KB104OrigContainerMove(self,cmd);
    KB104UnclipOwnedView(self);
}
static void KB104HostMove(id self,SEL cmd) {
    if (KB104OrigHostMove) KB104OrigHostMove(self,cmd);
    KB104UnclipOwnedView(self);
}

// [hl33] The first keyboard layout may precede host geometry; after a
// real window appears we may un-clip its already-created input-set views
// without forcing layoutSubviews or touching keyplane/frame.
static void KB104WalkExisting(UIView *view,NSUInteger depth) {
    if (!view || depth>22) return;
    Class container=objc_getClass("UIInputSetContainerView");
    Class host=objc_getClass("UIInputSetHostView");
    if ((container && [view isKindOfClass:container]) ||
        (host && [view isKindOfClass:host]))
        KB104UnclipOwnedView(view);
    for (UIView *v in view.subviews) KB104WalkExisting(v,depth+1);
}
void ABKB104InspectClips(UIView *window) {
    if (!KB104Eligible() || !window || !KB104KeyboardWindow(window)) return;
    KB104WalkExisting(window,0);
}
