// DuoCar personal Lề extension. The original Le 0.2.4 renderer, data
// collectors, limit, signs, lanes, Maps card and supervisor remain intact.
// Verified Mach-O methods used here: CWTrafficBubbleContent
// +contentWithSnapshot:, CWTrafficOverlayController -place/-panned:,
// CWCastBubbleController -place:/-panned:, both bubble/window accessors.
// This module does not alter posted speed limits or the vendor relay.
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CoreFoundation/CoreFoundation.h>
#import <objc/runtime.h>
#import <objc/message.h>
#import <notify.h>
#import <math.h>
#import <stdlib.h>
#import <string.h>
#import "../OmniCarLeTraffic/DCLTrafficCore.h"
#import "DCLLeConfigBridge.h"

static NSString *const DCLDomain=@"com.chuong.duocar";
static id (*originalContent)(id,SEL,id);
static void (*originalOverlayPlace)(id,SEL);
// Original arm64 selector type: v48@0:8{CGRect={CGPoint=dd}{CGSize=dd}}16
static void (*originalCastPlace)(id,SEL,CGRect);
static void (*originalOverlayPan)(id,SEL,id);
static void (*originalCastPan)(id,SEL,id);
static BOOL installedContent=NO, installedOverlay=NO, installedCast=NO;
static BOOL dragging=NO, applying=NO, hasStored=NO;
static DCLTrafficPoint stored={0.5,0.5};
static __weak UIView *dragTarget;
static __weak id dragOwner;
// [hl55-le] The original pan recognizer remains the ONLY recognizer.
static DCLTrafficPoint beforeDrag={0.5,0.5};
static BOOL beforeDragSaved=NO;
static __weak id DCLLastOverlayOwner;
static __weak id DCLLastCastOwner;
static CGRect DCLLastCastRect;
static __weak UIWindow *DCLHiddenByDuoCar;
static BOOL DCLBeforeHidden=NO,DCLBeforeInteractive=YES;
static NSTimeInterval DCLLastWindowProbe=0;

static id pref(NSString *key) {
    CFStringRef domain=(__bridge CFStringRef)DCLDomain;
    CFPreferencesAppSynchronize(domain);
    return CFBridgingRelease(CFPreferencesCopyAppValue(
                     (__bridge CFStringRef)key,domain));
}
static BOOL enabledDrag(void) {
    id v=pref(@"leTrafficFreeDrag");
    return v?[v boolValue]:YES;
}
static int gpsOffset(void) {
    id n=pref(@"leTrafficGpsOffsetKph");
    return DCLTrafficClampGpsOffset([n respondsToSelector:@selector(integerValue)]
        ?(int)[n integerValue]:0);
}
static void loadStored(void) {
    id x=pref(@"leTrafficPositionX"),y=pref(@"leTrafficPositionY");
    if([x isKindOfClass:NSNumber.class]&&[y isKindOfClass:NSNumber.class]&&
       isfinite([x doubleValue])&&isfinite([y doubleValue])) {
        stored=(DCLTrafficPoint){fmax(0,fmin(1,[x doubleValue])),
                                 fmax(0,fmin(1,[y doubleValue]))};
        hasStored=YES;
    }
}
static void saveStored(DCLTrafficPoint p) {
    if(!isfinite(p.x)||!isfinite(p.y))return;
    stored=p;hasStored=YES;
    CFStringRef domain=(__bridge CFStringRef)DCLDomain;
    CFPreferencesSetAppValue(CFSTR("leTrafficPositionX"),(__bridge CFPropertyListRef)@(p.x),domain);
    CFPreferencesSetAppValue(CFSTR("leTrafficPositionY"),(__bridge CFPropertyListRef)@(p.y),domain);
    BOOL ok=CFPreferencesAppSynchronize(domain);
    NSLog(@"[le024-ext] saveXY %.3f %.3f success=%d",p.x,p.y,ok);
}
static UIView *bubble(id owner) {
    SEL sel=@selector(bubble);
    if(!owner || ![owner respondsToSelector:sel])return nil;
    id v=((id(*)(id,SEL))objc_msgSend)(owner,sel);
    return [v isKindOfClass:UIView.class]?(UIView *)v:nil;
}
// [hl52-free-xy] Lề owns a real CWTrafficWindow (verified from original
// LeBubble 0.2.4 Mach-O); it can be BUBBLE-SIZED. DuoCar51 incorrectly
// required window.bounds >= 200x150 and normalized positions against that
// small window. Always use the actual CarPlay UIScreen coordinate space.
static UIWindow *DCLLeWindowForView(UIView *v) {
    if([v isKindOfClass:UIWindow.class])return (UIWindow *)v;
    return v.window;
}
static BOOL DCLLeCompactVendorWindow(UIWindow *w) {
    if(!w || !w.screen)return NO;
    CGRect screen=w.screen.bounds,frame=w.frame;
    return [NSStringFromClass(w.class) isEqualToString:@"CWTrafficWindow"] &&
           CGRectGetWidth(frame)>20 && CGRectGetHeight(frame)>20 &&
           CGRectGetWidth(frame)<CGRectGetWidth(screen)*0.85 &&
           CGRectGetHeight(frame)<CGRectGetHeight(screen)*0.85;
}
// Move the real hit-test owner. For a small CWTrafficWindow, moving only the
// bubble subview made its visible pixels depart from the touch region;
// move that SAME vendor window instead, preserving its level/recognizer.
// Full-screen windows must NEVER be relocated. For those, move only the
// vendor's compact hit container (if present), else original bubble view.
static UIView *DCLLeMoveSurface(id owner) {
    UIView *v=bubble(owner);
    UIWindow *w=v.window;
    if(!v || !w || !w.screen)return nil;
    if(DCLLeCompactVendorWindow(w))return w;
    UIView *hit=v.superview;
    CGSize screen=w.screen.bounds.size;
    if(hit && [NSStringFromClass(hit.class) isEqualToString:@"CWTrafficHitView"] &&
       hit.bounds.size.width>20 && hit.bounds.size.height>20 &&
       hit.bounds.size.width<screen.width*0.85 &&
       hit.bounds.size.height<screen.height*0.85)
        return hit;
    return v;
}
static BOOL DCLLeScreenGeometry(UIView *surface,DCLTrafficRect *r,
                                DCLTrafficInsets *safe) {
    UIWindow *w=DCLLeWindowForView(surface);
    if(!w || !w.screen || !r || !safe)return NO;
    CGRect b=w.screen.bounds;
    if(!isfinite(b.origin.x)||!isfinite(b.origin.y)||
       !isfinite(b.size.width)||!isfinite(b.size.height)||
       b.size.width<200||b.size.height<150)return NO;
    UIEdgeInsets insets=DCLLeCompactVendorWindow(w)
        ?UIEdgeInsetsZero:w.safeAreaInsets;
    *r=(DCLTrafficRect){b.origin.x,b.origin.y,b.size.width,b.size.height};
    *safe=(DCLTrafficInsets){fmax(0,insets.top),fmax(0,insets.right),
                             fmax(0,insets.bottom),fmax(0,insets.left)};
    return YES;
}
static BOOL DCLLeScreenCenter(UIView *surface,CGPoint *center) {
    if(!surface||!center)return NO;
    UIWindow *w=DCLLeWindowForView(surface);
    if(!w || !w.screen)return NO;
    if(surface==w) {
        *center=CGPointMake(CGRectGetMidX(w.frame),CGRectGetMidY(w.frame));
    } else if(surface.superview) {
        *center=[surface.superview convertPoint:surface.center
                           toCoordinateSpace:w.screen.coordinateSpace];
    } else return NO;
    return isfinite(center->x)&&isfinite(center->y);
}
static BOOL DCLLeSetScreenCenter(UIView *surface,CGPoint c) {
    UIWindow *w=DCLLeWindowForView(surface);
    if(!w || !w.screen || !isfinite(c.x)||!isfinite(c.y))return NO;
    CGPoint old;
    if(!DCLLeScreenCenter(surface,&old))return NO;
    if(hypot(c.x-old.x,c.y-old.y)<0.5)return YES;
    applying=YES;
    if(surface==w) {
        // Reposition the existing compact native window, not the whole
        // CarPlay scene. UIKit hit-testing stays attached to Lề's window.
        CGRect frame=w.frame;
        frame.origin.x=c.x-CGRectGetWidth(frame)*0.5;
        frame.origin.y=c.y-CGRectGetHeight(frame)*0.5;
        w.frame=frame;
    } else if(surface.superview) {
        surface.center=[surface.superview convertPoint:c
                          fromCoordinateSpace:w.screen.coordinateSpace];
    }
    applying=NO;
    return YES;
}
static BOOL DCLLeNormalizedSurface(UIView *surface,DCLTrafficPoint *out) {
    DCLTrafficRect r;DCLTrafficInsets safe;CGPoint c;
    if(!out||!DCLLeScreenGeometry(surface,&r,&safe)||
       !DCLLeScreenCenter(surface,&c))return NO;
    return DCLTrafficNormalizeCenter(r,safe,
              surface.bounds.size.width,surface.bounds.size.height,0.0,
              (DCLTrafficPoint){c.x,c.y},out);
}
static void applyCenter(id owner,DCLTrafficPoint normalized) {
    if(applying)return;
    UIView *surface=DCLLeMoveSurface(owner);
    DCLTrafficRect rect;DCLTrafficInsets safe;
    if(!surface||!DCLLeScreenGeometry(surface,&rect,&safe))return;
    DCLTrafficPoint center;
    if(!DCLTrafficRestoreCenter(rect,safe,surface.bounds.size.width,
           surface.bounds.size.height,0.0,normalized,&center))return;
    DCLLeSetScreenCenter(surface,CGPointMake(center.x,center.y));
}
static void enforce(id owner) {
    if(!enabledDrag()||!hasStored)return;
    if(dragging && dragOwner==owner)return;
    applyCenter(owner,stored);
}
// Retain Lề's original recognizer and call its original -panned: once.
// Offset and drag persistence are in SCREEN coordinates and refer to
// the SAME native hit surface for the whole gesture.
static char DCLDragDeltaKey;
static void freePan(id owner,UIPanGestureRecognizer *gesture) {
    if(!enabledDrag() || ![gesture isKindOfClass:UIPanGestureRecognizer.class])
        return;
    UIView *surface=DCLLeMoveSurface(owner);
    UIWindow *w=DCLLeWindowForView(surface);
    if(!surface || !w || !w.screen || !gesture.view ||
       !gesture.view.window || gesture.view.window.screen!=w.screen) {
        NSLog(@"[hl52-free-xy] BLIND owner=%@ surface=%@ touch=%@",
              NSStringFromClass([owner class]),surface,gesture.view);
        return;
    }
    DCLTrafficRect rect;DCLTrafficInsets safe;CGPoint current;
    if(!DCLLeScreenGeometry(surface,&rect,&safe)||
       !DCLLeScreenCenter(surface,&current)) {
        NSLog(@"[hl52-free-xy] BAD GEOMETRY surface=%@ window=%@ screen=%@",
             NSStringFromClass(surface.class),NSStringFromCGRect(w.bounds),
             NSStringFromCGRect(w.screen.bounds));
        return;
    }
    CGPoint touch=[gesture.view convertPoint:
       [gesture locationInView:gesture.view]
       toCoordinateSpace:w.screen.coordinateSpace];
    if(!isfinite(touch.x)||!isfinite(touch.y))return;
    UIGestureRecognizerState state=gesture.state;
    if(state==UIGestureRecognizerStateBegan) {
        dragging=YES;dragOwner=owner;dragTarget=surface;
        beforeDrag=stored;beforeDragSaved=hasStored;
        objc_setAssociatedObject(owner,&DCLDragDeltaKey,
            [NSValue valueWithCGPoint:CGPointMake(current.x-touch.x,
                                                  current.y-touch.y)],
            OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        NSLog(@"[hl52-free-xy] BEGIN owner=%@ mover=%@ screen=%@ nativeWindow=%@ bubble=%@",
              NSStringFromClass([owner class]),NSStringFromClass(surface.class),
              NSStringFromCGRect(w.screen.bounds),NSStringFromCGRect(w.frame),
              NSStringFromCGRect(bubble(owner).frame));
    } else if(state==UIGestureRecognizerStateChanged) {
        if(dragOwner!=owner||dragTarget!=surface)return;
        NSValue *value=objc_getAssociatedObject(owner,&DCLDragDeltaKey);
        if(![value isKindOfClass:NSValue.class])return;
        CGPoint delta=value.CGPointValue;
        DCLTrafficPoint bounded;
        if(DCLTrafficClampCenter(rect,safe,surface.bounds.size.width,
            surface.bounds.size.height,0.0,
            (DCLTrafficPoint){touch.x+delta.x,touch.y+delta.y},&bounded)) {
            if(DCLLeSetScreenCenter(surface,CGPointMake(bounded.x,bounded.y))) {
                DCLTrafficPoint normal;
                if(DCLLeNormalizedSurface(surface,&normal)){
                    stored=normal;hasStored=YES;
                }
            }
        }
    } else if(state==UIGestureRecognizerStateEnded) {
        if(dragOwner==owner && hasStored) {
            // The original -panned: may have already snapped to a corner.
            // Select from the final FREE coordinate, not its overwritten view.
            DCLTrafficPoint position={0},target={0};
            int snapped=0;
            BOOL ok=DCLTrafficRestoreCenter(rect,safe,surface.bounds.size.width,
                        surface.bounds.size.height,0.0,stored,&position) &&
                 DCLTrafficSnapWhenNearEdge(rect,safe,surface.bounds.size.width,
                        surface.bounds.size.height,0.0,32.0,
                        position,&target,&snapped);
            DCLTrafficPoint normalized={0};
            if(ok && DCLTrafficNormalizeCenter(rect,safe,surface.bounds.size.width,
                    surface.bounds.size.height,0.0,target,&normalized)) {
                applyCenter(owner,normalized);
                saveStored(normalized);
                NSLog(@"[hl55-le-edge] END snap=%d x=%.3f y=%.3f mover=%@ screen=%@",
                      snapped,normalized.x,normalized.y,
                      NSStringFromClass(surface.class),NSStringFromCGRect(w.screen.bounds));
            } else {
                NSLog(@"[hl55-le-edge] INVALID END geometry; no save");
            }
        }
        dragging=NO;dragOwner=nil;dragTarget=nil;
        objc_setAssociatedObject(owner,&DCLDragDeltaKey,nil,OBJC_ASSOCIATION_ASSIGN);
    } else if(state==UIGestureRecognizerStateCancelled ||
              state==UIGestureRecognizerStateFailed) {
        if(dragOwner==owner) {
            stored=beforeDrag;hasStored=beforeDragSaved;
            if(hasStored)applyCenter(owner,stored);
        }
        dragging=NO;dragOwner=nil;dragTarget=nil;
        objc_setAssociatedObject(owner,&DCLDragDeltaKey,nil,OBJC_ASSOCIATION_ASSIGN);
        NSLog(@"[hl55-le-edge] CANCEL no persisted state change");
    }
}
static void newOverlayPan(id o,SEL sel,UIPanGestureRecognizer *g) {
    // Always call the original vendor implementation exactly once.
    if(originalOverlayPan)originalOverlayPan(o,sel,g);
    freePan(o,g);
}
static void newCastPan(id o,SEL sel,UIPanGestureRecognizer *g) {
    if(originalCastPan)originalCastPan(o,sel,g);
    freePan(o,g);
}
// [hl55-le-window] Probe the real Lề-owned native window and host levels.
// We deliberately avoid relocating CarPlayApp scenes and app containers.
// The target level is below the measured picker tray (~1065), above hosted
// TikTok/YouTube (~1060) only for compact original CWTrafficWindow.
static BOOL DCLLeVendorEnabled(void) {
    NSData *data=[NSData dataWithContentsOfFile:
       @"/var/mobile/Library/Preferences/dev.bechou.le.bubble/layout-v1.json"];
    NSDictionary *doc=[data isKindOfClass:NSData.class]
        ?[NSJSONSerialization JSONObjectWithData:data options:0 error:nil]:nil;
    id flag=[doc isKindOfClass:NSDictionary.class]?doc[@"bubbleEnabled"]:nil;
    return [flag isKindOfClass:NSNumber.class]?[flag boolValue]:YES;
}
static void DCLLeWindowState(id owner,const char *stage) {
    UIView *move=DCLLeMoveSurface(owner);
    UIWindow *window=DCLLeWindowForView(move);
    if(!window || !window.screen)return;
    BOOL compact=DCLLeCompactVendorWindow(window);
    if(compact && window.windowLevel<UIWindowLevelStatusBar+62.0)
        window.windowLevel=UIWindowLevelStatusBar+62.0;
    BOOL on=DCLLeVendorEnabled();
    if(!on) {
        if(DCLHiddenByDuoCar!=window) {
            DCLHiddenByDuoCar=window;
            DCLBeforeHidden=window.hidden;
            DCLBeforeInteractive=window.userInteractionEnabled;
        }
        window.userInteractionEnabled=NO;
        window.hidden=YES; // no invisible hit target
    } else if(DCLHiddenByDuoCar==window) {
        window.userInteractionEnabled=DCLBeforeInteractive;
        window.hidden=DCLBeforeHidden;
        DCLHiddenByDuoCar=nil;
    }
    NSTimeInterval now=NSDate.date.timeIntervalSince1970;
    if(now-DCLLastWindowProbe>=8.0) {
        DCLLastWindowProbe=now;
        NSLog(@"[hl55-le-window] stage=%s enabled=%d owner=%@ moving=%@ class=%@ frame=%@ level=%.0f screen=%@ hidden=%d hit=%d compact=%d",
            stage,on,NSStringFromClass([owner class]),
            NSStringFromClass(move.class),NSStringFromClass(window.class),
            NSStringFromCGRect(window.frame),(double)window.windowLevel,
            NSStringFromCGRect(window.screen.bounds),window.hidden,
            window.userInteractionEnabled,compact);
    }
}
static void newOverlayPlace(id o,SEL sel) {
    DCLLastOverlayOwner=o;
    if(originalOverlayPlace)originalOverlayPlace(o,sel);
    enforce(o);
    DCLLeWindowState(o,"overlay");
}
static void newCastPlace(id o,SEL sel,CGRect frame) {
    DCLLastCastOwner=o;DCLLastCastRect=frame;
    if(originalCastPlace)originalCastPlace(o,sel,frame);
    enforce(o);
    DCLLeWindowState(o,"cast");
}
static id newContent(id cls,SEL sel,id snapshot) {
    id object=originalContent?originalContent(cls,sel,snapshot):nil;
    if(!object||![object respondsToSelector:@selector(speedText)]||
       ![object respondsToSelector:@selector(setSpeedText:)])return object;
    id value=((id(*)(id,SEL))objc_msgSend)(object,@selector(speedText));
    if(![value isKindOfClass:NSString.class])return object;
    NSScanner *scanner=[NSScanner scannerWithString:value];
    NSInteger current=0;
    if(![scanner scanInteger:&current] || !scanner.isAtEnd ||
       current<0 || current>400)return object;
    NSInteger adjusted=MAX(0,MIN(400,current+gpsOffset()));
    ((void(*)(id,SEL,id))objc_msgSend)(object,@selector(setSpeedText:),
            [NSString stringWithFormat:@"%ld",(long)adjusted]);
    return object;
}
static BOOL installOne(Class cls,SEL selector,IMP newIMP,IMP *old,
                        BOOL instance,unsigned args) {
    if(!cls||!old||*old)return *old!=NULL;
    Method m=instance?class_getInstanceMethod(cls,selector):
                       class_getClassMethod(cls,selector);
    if(!m||method_getNumberOfArguments(m)!=args)return NO;
    if(instance && selector==@selector(place:)) {
        // Verified vendor LeBubble Mach-O: CGRect, NOT an id object.
        const char *encoding=method_getTypeEncoding(m);
        if(!encoding || !strstr(encoding,"{CGRect=")) {
            NSLog(@"[le024-ext] place: ABI mismatch (%s)",encoding?: "null");
            return NO;
        }
    }
    char ret[16]={0};
    method_getReturnType(m,ret,sizeof(ret));
    if(instance ? ret[0]!='v' : ret[0]!='@')return NO;
    Class target=instance?cls:object_getClass(cls);
    IMP previous=method_getImplementation(m);
    if(!previous||previous==newIMP)return NO;
    if(class_addMethod(target,selector,newIMP,method_getTypeEncoding(m))) {
        *old=previous;return YES;
    }
    IMP replaced=method_setImplementation(m,newIMP);
    if(replaced!=previous) {
        if(replaced)method_setImplementation(m,replaced);
        return NO;
    }
    *old=previous;return YES;
}
static void install(void) {
    if(!installedContent) {
        Class content=NSClassFromString(@"CWTrafficBubbleContent");
        installedContent=installOne(content,@selector(contentWithSnapshot:),
             (IMP)newContent,(IMP *)&originalContent,NO,3);
        if(installedContent) NSLog(@"[le024-ext] factory hooked");
    }
    if(!installedOverlay) {
        Class cls=NSClassFromString(@"CWTrafficOverlayController");
        BOOL ok=cls && [cls instancesRespondToSelector:@selector(bubble)];
        ok = ok && installOne(cls,@selector(place),
              (IMP)newOverlayPlace,(IMP *)&originalOverlayPlace,YES,2);
        // The native controller already has the working pan recognizer.
        // Override its FINAL snap-to-corner handler instead of adding
        // a second competing pan onto CWTrafficBubbleView.
        ok = ok && installOne(cls,@selector(panned:),
              (IMP)newOverlayPan,(IMP *)&originalOverlayPan,YES,3);
        installedOverlay=ok;
        if(ok)NSLog(@"[le024-ext] overlay place/panned installed");
    }
    if(!installedCast) {
        Class cls=NSClassFromString(@"CWCastBubbleController");
        BOOL ok=cls && [cls instancesRespondToSelector:@selector(bubble)];
        ok=ok && installOne(cls,@selector(place:),
             (IMP)newCastPlace,(IMP *)&originalCastPlace,YES,3);
        ok=ok && installOne(cls,@selector(panned:),
             (IMP)newCastPan,(IMP *)&originalCastPan,YES,3);
        installedCast=ok;
        if(ok)NSLog(@"[le024-ext] cast place/panned installed");
    }
}
__attribute__((constructor)) static void DCLLeBootstrap(void) {
    NSString *bundle=NSBundle.mainBundle.bundleIdentifier;
    BOOL car=[bundle isEqualToString:@"com.apple.CarPlayApp"];
    BOOL springboard=[bundle isEqualToString:@"com.apple.springboard"];
    if(!car&&!springboard)return;
    dispatch_async(dispatch_get_main_queue(),^{
        if(springboard)DCLLeConfigStartBridge();
        loadStored();
        install();
        static int leNotify=-1;
        notify_register_dispatch("dev.bechou.le.bubble.layout-changed",
             &leNotify,dispatch_get_main_queue(),^(int token) {
             (void)token;
             if(DCLLastOverlayOwner)
                 newOverlayPlace(DCLLastOverlayOwner,@selector(place));
             if(DCLLastCastOwner)
                 newCastPlace(DCLLastCastOwner,@selector(place:),DCLLastCastRect);
        });
        __block NSUInteger tries=0;
        NSTimer *timer=[NSTimer timerWithTimeInterval:1 repeats:YES
         block:^(NSTimer *t) {
            install();
            BOOL done=installedContent && (car?installedOverlay:installedCast);
            if(done||++tries>=120){
                if(!done)NSLog(@"[le024-ext] BLIND: class/selector not installed");
                [t invalidate];
            }
         }];
        [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
    });
}
