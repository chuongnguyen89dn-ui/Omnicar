// QA17: QA16 proven idle fade + DuoFace-like first-touch reveal on the ORIGINAL AppBridge owner window.
// Original 1.0.3 ABI: ABPane.handle/handleHit are objects; SCPCarPane.hostHandle is BOOL.
// NO host scene/rotation/zoom, native split, Solo, Dock or hit-test geometry modifications.
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>
#import <objc/runtime.h>
#import <objc/message.h>
#import <math.h>

static const NSTimeInterval kOMCYTIdleSeconds=4.0;
static NSString * const kOMCYTBundle=@"com.google.ios.youtube";
static char kOMCYTHandleStateKey;
static BOOL gOMCYTInstalled=NO;

@interface ABHost : NSObject
- (void)setHandleVisible:(BOOL)visible forPane:(id)pane;
- (void)layoutBarForPane:(id)pane;
- (UIWindow *)window; // original ABHost owner, no global UIWindow hook
@end

@class OMCYTHandleState;
static void OMCYTWake(id pane);
static void OMCYTWakeFrom(id pane,NSString *source);

@interface OMCYTObserveTouch : UIGestureRecognizer
@property(nonatomic,weak) id trackedPane;
@property(nonatomic,weak) UIView *paneBox;
@property(nonatomic) BOOL scopeToPaneOnWindow;
@end
@implementation OMCYTObserveTouch
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    BOOL qualifies=NO;
    if(!self.scopeToPaneOnWindow){
        // Preserve QA16 native-pane and hit-target fallbacks.
        qualifies=touches.count>0;
    } else {
        // Mirror DuoFace v12 CBBridgedUIAppView.touchesBegan -> noteUserActivity:
        // observe the original host owner-window, not the remote YouTube player's
        // inner buttons. Never steal event delivery from the hosted app.
        UIWindow *hostWindow=[self.view isKindOfClass:UIWindow.class]?(UIWindow *)self.view:nil;
        UIView *box=self.paneBox;
        if(hostWindow && box && box.window==hostWindow) {
            CGRect rect=[box convertRect:box.bounds toView:hostWindow];
            CGRect visible=CGRectIntersection(rect,hostWindow.bounds);
            if(!CGRectIsNull(visible) && !CGRectIsEmpty(visible) &&
               isfinite(visible.origin.x) && isfinite(visible.origin.y) &&
               isfinite(visible.size.width) && isfinite(visible.size.height) &&
               visible.size.width>=24.0 && visible.size.height>=24.0) {
                for(UITouch *touch in touches) {
                    if(touch.phase!=UITouchPhaseBegan || touch.window!=hostWindow)continue;
                    if(CGRectContainsPoint(visible,[touch locationInView:hostWindow])) {
                        qualifies=YES;
                        break;
                    }
                }
            }
        }
    }
    if(qualifies)
        OMCYTWakeFrom(self.trackedPane,self.scopeToPaneOnWindow?@"owner-window":@"pane-local");
    // Always fail, no gesture recognition/consumption; original YouTube click
    // and scroll, divider drag, map controls and double tap keep their targets.
    self.state=UIGestureRecognizerStateFailed;
}
- (BOOL)canPreventGestureRecognizer:(UIGestureRecognizer *)other { (void)other; return NO; }
- (BOOL)canBePreventedByGestureRecognizer:(UIGestureRecognizer *)other { (void)other; return NO; }
@end

@interface OMCYTHandleState : NSObject
@property(nonatomic,weak) id pane;
@property(nonatomic,strong) NSTimer *timer;
@property(nonatomic,strong) NSMapTable<UIView *,NSNumber *> *savedOpacity;
@property(nonatomic,strong) OMCYTObserveTouch *contentObserver;
@property(nonatomic,strong) OMCYTObserveTouch *handleObserver;
@property(nonatomic,weak) UIView *contentOwner;
@property(nonatomic,weak) UIView *handleOwner;
@property(nonatomic,strong) OMCYTObserveTouch *windowObserver;
@property(nonatomic,weak) UIWindow *windowOwner;
@property(nonatomic) BOOL nativeVisible;
@property(nonatomic) BOOL visible;
@property(nonatomic) BOOL started;
@end
@implementation OMCYTHandleState @end

// Only verified object-returning ABPane accessors: bundleID, box, handle, handleHit.
// Never call SCPCarPane.hostHandle as id: original getter returns a scalar BOOL.
static id OMCYTReadObject(id instance,SEL selector) {
    if(!instance || ![instance respondsToSelector:selector])return nil;
    NSMethodSignature *signature=[instance methodSignatureForSelector:selector];
    if(!signature || signature.numberOfArguments!=2 || !signature.methodReturnType ||
       signature.methodReturnType[0]!='@')return nil;
    return ((id(*)(id,SEL))objc_msgSend)(instance,selector);
}
static BOOL OMCYTIsYouTube(id pane) {
    id bundle=OMCYTReadObject(pane,@selector(bundleID));
    return [bundle isKindOfClass:NSString.class] &&
           [(NSString *)bundle caseInsensitiveCompare:kOMCYTBundle]==NSOrderedSame;
}
static UIView *OMCYTView(id pane,SEL selector) {
    id value=OMCYTReadObject(pane,selector);
    return [value isKindOfClass:UIView.class]?(UIView *)value:nil;
}
static OMCYTHandleState *OMCYTState(id pane,BOOL create) {
    if(!pane)return nil;
    OMCYTHandleState *state=objc_getAssociatedObject(pane,&kOMCYTHandleStateKey);
    if(!state && create){
        state=[OMCYTHandleState new];
        state.pane=pane;
        state.visible=YES;
        state.savedOpacity=[NSMapTable weakToStrongObjectsMapTable];
        objc_setAssociatedObject(pane,&kOMCYTHandleStateKey,state,OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return state;
}
// A UI control must not be the app content/container or an ancestor of it.
// Original AppBridge allocates the three-dot hit capsule at 70x24 points.
static BOOL OMCYTIsSmallControl(UIView *view,UIView *box) {
    if(!view || view==box || (box && [box isDescendantOfView:view]))return NO;
    CGSize b=view.bounds.size;
    return isfinite(b.width) && isfinite(b.height) &&
           b.width>=5.0 && b.height>=5.0 && b.width<=160.0 && b.height<=100.0;
}
static void OMCYTPaint(UIView *view,OMCYTHandleState *state,BOOL visible) {
    if(!view)return;
    NSNumber *saved=[state.savedOpacity objectForKey:view];
    if(visible) {
        if(saved){
            view.layer.opacity=saved.floatValue;
            [state.savedOpacity removeObjectForKey:view];
        }
    }else {
        if(!saved) {
            [state.savedOpacity setObject:@(view.layer.opacity) forKey:view];
        }
        view.layer.opacity=0.0f;
    }
}
static void OMCYTRestoreAll(OMCYTHandleState *state) {
    for(UIView *view in [state.savedOpacity.keyEnumerator allObjects]){
        NSNumber *saved=[state.savedOpacity objectForKey:view];
        if(saved)view.layer.opacity=saved.floatValue;
        [state.savedOpacity removeObjectForKey:view];
    }
}
static void OMCYTApply(id pane) {
    OMCYTHandleState *state=OMCYTState(pane,NO);
    if(!state || !state.nativeVisible)return;
    UIView *box=OMCYTView(pane,@selector(box));
    UIView *handle=OMCYTView(pane,@selector(handle));
    UIView *hit=OMCYTView(pane,@selector(handleHit));
    BOOL visual=OMCYTIsSmallControl(handle,box);
    BOOL touch=OMCYTIsSmallControl(hit,box);
    // Do NOT set hidden/alpha/userInteractionEnabled: original hit target remains tappable.
    // Guard both visual and hit view so all original dots fade in the host scene.
    if(visual)OMCYTPaint(handle,state,state.visible);
    if(touch && hit!=handle)OMCYTPaint(hit,state,state.visible);
}
static void OMCYTObserve(OMCYTHandleState *state,UIView *view,BOOL hit) {
    if(!view || [view isKindOfClass:UIWindow.class])return;
    OMCYTObserveTouch *gesture=hit?state.handleObserver:state.contentObserver;
    UIView *owner=hit?state.handleOwner:state.contentOwner;
    if(!gesture){
        gesture=[[OMCYTObserveTouch alloc]initWithTarget:nil action:NULL];
        gesture.trackedPane=state.pane;
        gesture.cancelsTouchesInView=NO;
        gesture.delaysTouchesBegan=NO;
        gesture.delaysTouchesEnded=NO;
        if(hit)state.handleObserver=gesture;
        else state.contentObserver=gesture;
    }
    if(owner!=view){
        if(owner)[owner removeGestureRecognizer:gesture];
        [view addGestureRecognizer:gesture];
        if(hit)state.handleOwner=view;
        else state.contentOwner=view;
    }
}
static void OMCYTAttach(ABHost *host,id pane,OMCYTHandleState *state) {
    UIView *box=OMCYTView(pane,@selector(box));
    UIView *hit=OMCYTView(pane,@selector(handleHit));
    if([box isKindOfClass:UIView.class])
        OMCYTObserve(state,box,NO);
    if(OMCYTIsSmallControl(hit,box) && hit!=box)
        OMCYTObserve(state,hit,YES);

    // Only the host's REAL UIWindow. Original ABHost.window is object-returning.
    // The pane.box must actually belong to this same window and intersect it.
    id ownedWindow=OMCYTReadObject(host,@selector(window));
    UIWindow *window=[ownedWindow isKindOfClass:UIWindow.class]?(UIWindow *)ownedWindow:nil;
    BOOL inOwnerWindow=(window && box && box.window==window && box!=window);
    if(inOwnerWindow) {
        CGRect rect=[box convertRect:box.bounds toView:window];
        CGRect clipped=CGRectIntersection(rect,window.bounds);
        inOwnerWindow=!CGRectIsNull(clipped) && !CGRectIsEmpty(clipped) &&
                      isfinite(clipped.size.width) && isfinite(clipped.size.height) &&
                      clipped.size.width>=24.0 && clipped.size.height>=24.0;
    }
    if(!inOwnerWindow) {
        if(state.windowOwner && state.windowObserver)
            [state.windowOwner removeGestureRecognizer:state.windowObserver];
        state.windowOwner=nil;
        if(state.windowObserver)state.windowObserver.paneBox=nil;
        return; // QA16 local gestures remain available when host owner isn't ready.
    }
    if(!state.windowObserver){
        OMCYTObserveTouch *observer=[[OMCYTObserveTouch alloc]initWithTarget:nil action:NULL];
        observer.trackedPane=pane;
        observer.scopeToPaneOnWindow=YES;
        observer.cancelsTouchesInView=NO;
        observer.delaysTouchesBegan=NO;
        observer.delaysTouchesEnded=NO;
        state.windowObserver=observer;
    }
    state.windowObserver.paneBox=box;
    if(state.windowOwner!=window){
        if(state.windowOwner)[state.windowOwner removeGestureRecognizer:state.windowObserver];
        [window addGestureRecognizer:state.windowObserver];
        state.windowOwner=window;
        NSLog(@"[OmniCarYTHandleIdleQA17] event=owner-window-observer-attached app=youtube scope=pane gesture=nonblocking");
    }
}
static void OMCYTSchedule(OMCYTHandleState *state) {
    [state.timer invalidate];
    state.timer=nil;
    __weak OMCYTHandleState *weakState=state;
    state.timer=[NSTimer scheduledTimerWithTimeInterval:kOMCYTIdleSeconds
        repeats:NO block:^(NSTimer *timer) {
        (void)timer;
        OMCYTHandleState *active=weakState;
        id pane=active.pane;
        if(!active || !pane || !active.nativeVisible || !OMCYTIsYouTube(pane))return;
        active.timer=nil;
        active.visible=NO;
        OMCYTApply(pane);
        UIView *box=OMCYTView(pane,@selector(box));
        UIView *hit=OMCYTView(pane,@selector(handleHit));
        UIView *handle=OMCYTView(pane,@selector(handle));
        NSLog(@"[OmniCarYTHandleIdleQA17] event=idle4-hide app=youtube handleValid=%d hitValid=%d saved=%lu",
              OMCYTIsSmallControl(handle,box),OMCYTIsSmallControl(hit,box),
              (unsigned long)active.savedOpacity.count);
    }];
}
static void OMCYTWakeFrom(id pane,NSString *source) {
    OMCYTHandleState *state=OMCYTState(pane,NO);
    if(!state || !state.nativeVisible || !OMCYTIsYouTube(pane))return;
    BOOL wasHidden=!state.visible;
    state.visible=YES;
    OMCYTApply(pane);
    OMCYTSchedule(state);
    if(wasHidden)NSLog(@"[OmniCarYTHandleIdleQA17] event=touch-reveal app=youtube source=%@",source?:@"unknown");
}
static void OMCYTWake(id pane) {
    OMCYTWakeFrom(pane,@"native-host-visible");
}
static void OMCYTStop(id pane) {
    OMCYTHandleState *state=OMCYTState(pane,NO);
    if(!state)return;
    [state.timer invalidate];
    state.timer=nil;
    OMCYTRestoreAll(state);
    if(state.contentOwner && state.contentObserver)
        [state.contentOwner removeGestureRecognizer:state.contentObserver];
    if(state.handleOwner && state.handleObserver)
        [state.handleOwner removeGestureRecognizer:state.handleObserver];
    state.contentOwner=nil;
    state.handleOwner=nil;
    if(state.windowOwner && state.windowObserver)
        [state.windowOwner removeGestureRecognizer:state.windowObserver];
    state.windowOwner=nil;
    state.windowObserver=nil;
    state.contentObserver=nil;
    state.handleObserver=nil;
    state.nativeVisible=NO;
    state.visible=YES;
    state.started=NO;
}
static void OMCYTNativeVisibility(ABHost *host,id pane,BOOL nativeVisible) {
    if(!pane)return;
    if(!OMCYTIsYouTube(pane)){
        OMCYTStop(pane);
        return;
    }
    if(!nativeVisible){
        OMCYTStop(pane);
        return;
    }
    OMCYTHandleState *state=OMCYTState(pane,YES);
    state.nativeVisible=YES;
    OMCYTAttach(host,pane,state);
    if(!state.started) {
        state.started=YES;
        OMCYTWake(pane);
        NSLog(@"[OmniCarYTHandleIdleQA17] event=host-visible app=youtube idle=4s");
    }else OMCYTApply(pane); // native relayout must NOT reset the four-second timer
}
%group OMCYTBridgeHooks
%hook ABHost
- (void)setHandleVisible:(BOOL)visible forPane:(id)pane {
    %orig;
    if(NSThread.isMainThread)OMCYTNativeVisibility(self,pane,visible);
    else {
        __weak id weakPane=pane;
        dispatch_async(dispatch_get_main_queue(),^{
            id p=weakPane;
            if(p)OMCYTNativeVisibility(self,p,visible);
        });
    }
}
- (void)layoutBarForPane:(id)pane {
    %orig;
    if(NSThread.isMainThread) {
        OMCYTHandleState *state=OMCYTState(pane,NO);
        if(state && state.nativeVisible){
            OMCYTAttach(self,pane,state);
            OMCYTApply(pane);
        }
    }
}
%end
%end

static void OMCYTTryInstall(NSUInteger attempt) {
    if(gOMCYTInstalled)return;
    Class host=NSClassFromString(@"ABHost");
    if(!host){
        if(attempt<120)dispatch_after(dispatch_time(DISPATCH_TIME_NOW,(int64_t)(0.5*NSEC_PER_SEC)),
            dispatch_get_main_queue(),^{ OMCYTTryInstall(attempt+1); });
        else NSLog(@"[OmniCarYTHandleIdleQA17] event=hook-unavailable reason=ABHost-class-not-loaded");
        return;
    }
    %init(OMCYTBridgeHooks);
    gOMCYTInstalled=YES;
    NSLog(@"[OmniCarYTHandleIdleQA17] event=hook-ready process=%@ target=ABHost original-player=preserved",
          NSBundle.mainBundle.bundleIdentifier?:@"unknown");
}
%ctor {
    @autoreleasepool {
        // Same injection target as ORIGINAL OmniCarAppBridge.dylib: com.apple.UIKit.
        // Do not assume SpringBoard/CarPlayApp is the AppBridge receiver process.
        dispatch_async(dispatch_get_main_queue(),^{ OMCYTTryInstall(0); });
    }
}
