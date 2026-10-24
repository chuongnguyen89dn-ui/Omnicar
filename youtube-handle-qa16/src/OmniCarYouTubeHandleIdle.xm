// QA16: restore original QA12 YouTube player and fade only its actual AppBridge handle.
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
@end

@class OMCYTHandleState;
static void OMCYTWake(id pane);

@interface OMCYTObserveTouch : UIGestureRecognizer
@property(nonatomic,weak) id trackedPane;
@end
@implementation OMCYTObserveTouch
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    if(touches.count) OMCYTWake(self.trackedPane);
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
static void OMCYTAttach(id pane,OMCYTHandleState *state) {
    UIView *box=OMCYTView(pane,@selector(box));
    UIView *hit=OMCYTView(pane,@selector(handleHit));
    if([box isKindOfClass:UIView.class])
        OMCYTObserve(state,box,NO);
    if(OMCYTIsSmallControl(hit,box) && hit!=box)
        OMCYTObserve(state,hit,YES);
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
        NSLog(@"[OmniCarYTHandleIdleQA16] event=idle4-hide app=youtube handleValid=%d hitValid=%d saved=%lu",
              OMCYTIsSmallControl(handle,box),OMCYTIsSmallControl(hit,box),
              (unsigned long)active.savedOpacity.count);
    }];
}
static void OMCYTWake(id pane) {
    OMCYTHandleState *state=OMCYTState(pane,NO);
    if(!state || !state.nativeVisible || !OMCYTIsYouTube(pane))return;
    BOOL wasHidden=!state.visible;
    state.visible=YES;
    OMCYTApply(pane);
    OMCYTSchedule(state);
    if(wasHidden)NSLog(@"[OmniCarYTHandleIdleQA16] event=touch-reveal app=youtube");
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
    state.contentObserver=nil;
    state.handleObserver=nil;
    state.nativeVisible=NO;
    state.visible=YES;
    state.started=NO;
}
static void OMCYTNativeVisibility(id pane,BOOL nativeVisible) {
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
    OMCYTAttach(pane,state);
    if(!state.started) {
        state.started=YES;
        OMCYTWake(pane);
        NSLog(@"[OmniCarYTHandleIdleQA16] event=host-visible app=youtube idle=4s");
    }else OMCYTApply(pane); // native relayout must NOT reset the four-second timer
}
%group OMCYTBridgeHooks
%hook ABHost
- (void)setHandleVisible:(BOOL)visible forPane:(id)pane {
    %orig;
    if(NSThread.isMainThread)OMCYTNativeVisibility(pane,visible);
    else {
        __weak id weakPane=pane;
        dispatch_async(dispatch_get_main_queue(),^{
            id p=weakPane;
            if(p)OMCYTNativeVisibility(p,visible);
        });
    }
}
- (void)layoutBarForPane:(id)pane {
    %orig;
    if(NSThread.isMainThread) {
        OMCYTHandleState *state=OMCYTState(pane,NO);
        if(state && state.nativeVisible){
            OMCYTAttach(pane,state);
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
        else NSLog(@"[OmniCarYTHandleIdleQA16] event=hook-unavailable reason=ABHost-class-not-loaded");
        return;
    }
    %init(OMCYTBridgeHooks);
    gOMCYTInstalled=YES;
    NSLog(@"[OmniCarYTHandleIdleQA16] event=hook-ready process=%@ target=ABHost original-player=preserved",
          NSBundle.mainBundle.bundleIdentifier?:@"unknown");
}
%ctor {
    @autoreleasepool {
        // Same injection target as ORIGINAL OmniCarAppBridge.dylib: com.apple.UIKit.
        // Do not assume SpringBoard/CarPlayApp is the AppBridge receiver process.
        dispatch_async(dispatch_get_main_queue(),^{ OMCYTTryInstall(0); });
    }
}
