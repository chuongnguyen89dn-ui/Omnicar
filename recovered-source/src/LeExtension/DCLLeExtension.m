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
#import "../OmniCarLeTraffic/DCLTrafficCore.h"
#import "DCLLeConfigBridge.h"

static NSString *const DCLDomain=@"com.chuong.duocar";
static id (*originalContent)(id,SEL,id);
static void (*originalOverlayPlace)(id,SEL);
static void (*originalCastPlace)(id,SEL,id);
static BOOL installedContent=NO, installedOverlay=NO, installedCast=NO;
static BOOL dragging=NO, applying=NO, hasStored=NO;
static DCLTrafficPoint stored={0.5,0.5};
static __weak UIView *dragTarget;
static __weak id dragOwner;

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
static BOOL geometry(UIView *view,DCLTrafficRect *r,DCLTrafficInsets *safe) {
    if(!view||!view.window||!view.superview)return NO;
    UIWindow *win=view.window;
    CGRect bounds=win.bounds;
    if(bounds.size.width<200||bounds.size.height<150)return NO;
    UIEdgeInsets edge=win.safeAreaInsets;
    *r=(DCLTrafficRect){bounds.origin.x,bounds.origin.y,bounds.size.width,bounds.size.height};
    *safe=(DCLTrafficInsets){MAX(0,edge.top),MAX(0,edge.right),
                              MAX(0,edge.bottom),MAX(0,edge.left)};
    return YES;
}
static void applyCenter(UIView *view,DCLTrafficPoint normalized) {
    if(!view || applying)return;
    DCLTrafficRect rect;DCLTrafficInsets safe;
    if(!geometry(view,&rect,&safe))return;
    DCLTrafficPoint center;
    if(!DCLTrafficRestoreCenter(rect,safe,view.bounds.size.width,
                                view.bounds.size.height,6.0,normalized,&center))return;
    CGPoint wanted=[view.superview convertPoint:CGPointMake(center.x,center.y)
                                      fromView:view.window];
    if(hypot(wanted.x-view.center.x,wanted.y-view.center.y)<0.5)return;
    applying=YES;
    view.center=wanted;
    applying=NO;
}
static void enforce(id owner) {
    if(!enabledDrag()||!hasStored)return;
    UIView *view=bubble(owner);
    if(!view || (dragging && dragOwner==owner))return;
    applyCenter(view,stored);
}
static BOOL normalize(UIView *view,DCLTrafficPoint *result) {
    if(!view||!result)return NO;
    DCLTrafficRect rect;DCLTrafficInsets safe;
    if(!geometry(view,&rect,&safe))return NO;
    CGPoint p=[view.superview convertPoint:view.center toView:view.window];
    return DCLTrafficNormalizeCenter(rect,safe,view.bounds.size.width,
                                     view.bounds.size.height,6.0,
                                     (DCLTrafficPoint){p.x,p.y},result);
}
static void freePan(id owner,SEL sel,UIPanGestureRecognizer *gesture) {
    (void)sel;
    if(!enabledDrag()||![gesture isKindOfClass:UIPanGestureRecognizer.class])return;
    UIView *view=bubble(owner);
    if(!view || !view.window || !view.superview) {
        NSLog(@"[le024-ext] pan BLIND: no bubble view");
        return;
    }
    UIGestureRecognizerState state=gesture.state;
    if(state==UIGestureRecognizerStateBegan) {
        dragging=YES;dragOwner=owner;dragTarget=view;
        [gesture setTranslation:CGPointZero inView:view.superview];
        NSLog(@"[le024-ext] drag begin view=%@ frame=%@",NSStringFromClass(view.class),
              NSStringFromCGRect(view.frame));
    }
    if(state==UIGestureRecognizerStateChanged) {
        if(dragTarget!=view)return;
        CGPoint delta=[gesture translationInView:view.superview];
        CGPoint proposed=CGPointMake(view.center.x+delta.x,view.center.y+delta.y);
        CGPoint raw=[view.superview convertPoint:proposed toView:view.window];
        DCLTrafficRect rect;DCLTrafficInsets safe;
        if(geometry(view,&rect,&safe)) {
            DCLTrafficPoint bounded;
            if(DCLTrafficClampCenter(rect,safe,view.bounds.size.width,
                view.bounds.size.height,6.0,(DCLTrafficPoint){raw.x,raw.y},&bounded)) {
                applying=YES;
                view.center=[view.superview convertPoint:
                    CGPointMake(bounded.x,bounded.y) fromView:view.window];
                applying=NO;
                if(normalize(view,&stored)) hasStored=YES;
            }
        }
        [gesture setTranslation:CGPointZero inView:view.superview];
    }
    if(state==UIGestureRecognizerStateEnded ||
       state==UIGestureRecognizerStateCancelled ||
       state==UIGestureRecognizerStateFailed) {
        DCLTrafficPoint point;
        if(normalize(view,&point))saveStored(point);
        dragging=NO;dragOwner=nil;dragTarget=nil;
        NSLog(@"[le024-ext] drag end center=%@",NSStringFromCGPoint(view.center));
    }
}
static void newOverlayPan(id o,SEL sel,UIPanGestureRecognizer *g) { freePan(o,sel,g); }
static void newCastPan(id o,SEL sel,UIPanGestureRecognizer *g) { freePan(o,sel,g); }
static void newOverlayPlace(id o,SEL sel) {
    if(originalOverlayPlace)originalOverlayPlace(o,sel);
    enforce(o);
}
static void newCastPlace(id o,SEL sel,id value) {
    if(originalCastPlace)originalCastPlace(o,sel,value);
    enforce(o);
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
        static void (*origOverlayPan)(id,SEL,id);
        ok = ok && installOne(cls,@selector(panned:),
              (IMP)newOverlayPan,(IMP *)&origOverlayPan,YES,3);
        installedOverlay=ok;
        if(ok)NSLog(@"[le024-ext] overlay place/panned installed");
    }
    if(!installedCast) {
        Class cls=NSClassFromString(@"CWCastBubbleController");
        BOOL ok=cls && [cls instancesRespondToSelector:@selector(bubble)];
        ok=ok && installOne(cls,@selector(place:),
             (IMP)newCastPlace,(IMP *)&originalCastPlace,YES,3);
        static void (*origCastPan)(id,SEL,id);
        ok=ok && installOne(cls,@selector(panned:),
             (IMP)newCastPan,(IMP *)&origCastPan,YES,3);
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
