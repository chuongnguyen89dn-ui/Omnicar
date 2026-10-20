// OmniCar 1.0.3 native controls: one 4s idle visual state, no new menu/touch UI.
// The original 4-second ratioMenu / paneBar / tray NSTimers are preserved.
// This source is STAGED for a future single com.anlai.omnicar DEB (NOT built).
// Do not hide UIView itself: keep native knob/handle hit regions and drag intact.
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>
#import <objc/runtime.h>
#import <objc/message.h>

static const NSTimeInterval kOMCIdleSeconds = 4.0; // original native ratio/bar menu interval
static char kOMCIdleStateKey;
static char kOMCIdleDividerLinkKey;
static char kOMCSavedOpacityKey;

@interface SCPCarSplit : NSObject
- (BOOL)active;
- (UIView *)container;
- (id)dividers;
- (id)allPanes;
- (UIView *)tabParent;
- (id)paneAtSlot:(int)slot;
- (UIView *)ratioMenu;
@end
@interface SCPCarDividerView : UIView
- (UIView *)knob;
@end

@class OMCIdleState;
static void OMCIdleWake(SCPCarSplit *split);
static void OMCIdleApply(SCPCarSplit *split);

@interface OMCIdleWakeGesture : UIGestureRecognizer
@property(nonatomic,weak) SCPCarSplit *split;
@end
@implementation OMCIdleWakeGesture
// Read-only touch observer: immediately FAIL recognition, without cancelling,
// delaying, or replacing the original touches, pans, app gestures or CarPlay dock.
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    if(touches.count)OMCIdleWake(self.split);
    self.state=UIGestureRecognizerStateFailed;
}
- (BOOL)canPreventGestureRecognizer:(UIGestureRecognizer *)other { (void)other; return NO; }
- (BOOL)canBePreventedByGestureRecognizer:(UIGestureRecognizer *)other { (void)other; return NO; }
@end

@interface OMCIdleDividerLink : NSObject
@property(nonatomic,weak) SCPCarSplit *split;
@end
@implementation OMCIdleDividerLink @end

@interface OMCIdleState : NSObject
@property(nonatomic,weak) SCPCarSplit *split;
@property(nonatomic,strong) NSTimer *idleTimer;
@property(nonatomic,strong) OMCIdleWakeGesture *wakeGesture;
@property(nonatomic,weak) UIView *gestureOwner;
@property(nonatomic,strong) OMCIdleWakeGesture *tabWakeGesture;
@property(nonatomic,weak) UIView *tabGestureOwner;
@property(nonatomic) BOOL visible;
@property(nonatomic) BOOL started;
@property(nonatomic) NSUInteger activeDividerTouches;
@end
@implementation OMCIdleState @end

static id OMCIdleGet(id object,SEL selector) {
    return object && [object respondsToSelector:selector]
      ?((id(*)(id,SEL))objc_msgSend)(object,selector):nil;
}
static OMCIdleState *OMCIdleStateFor(SCPCarSplit *split,BOOL create) {
    if(!split)return nil;
    OMCIdleState *s=objc_getAssociatedObject(split,&kOMCIdleStateKey);
    if(!s && create) {
        s=[OMCIdleState new];
        s.split=split;
        s.visible=YES;
        objc_setAssociatedObject(split,&kOMCIdleStateKey,s,OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return s;
}
// Preserve the EXACT original CALayer opacity, even when it wasn't 1.0.
// Change visual layer.opacity only; UIView.hidden/alpha, target/action,
// touch pointInside and geometry of native divider and pane remain untouched.
static void OMCIdlePaintControl(id object,BOOL visible) {
    UIView *view=[object isKindOfClass:[UIView class]]?(UIView *)object:nil;
    if(!view)return;
    NSNumber *saved=objc_getAssociatedObject(view,&kOMCSavedOpacityKey);
    if(visible) {
        if(saved){
            view.layer.opacity=saved.floatValue;
            objc_setAssociatedObject(view,&kOMCSavedOpacityKey,nil,OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        }
    } else {
        if(!saved)objc_setAssociatedObject(view,&kOMCSavedOpacityKey,@(view.layer.opacity),
                                           OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        view.layer.opacity=0.0f;
    }
}
static void OMCIdlePaintPaneHandles(id pane,BOOL visible) {
    UIView *native=OMCIdleGet(pane,@selector(handle));
    UIView *hosted=OMCIdleGet(pane,@selector(hostHandle));
    OMCIdlePaintControl(native,visible);
    if(hosted!=native)OMCIdlePaintControl(hosted,visible);
}
static void OMCIdleApply(SCPCarSplit *split) {
    OMCIdleState *s=OMCIdleStateFor(split,NO);
    if(!s)return;
    BOOL visible=s.visible || s.activeDividerTouches>0;
    id dividers=[split dividers];
    if([dividers isKindOfClass:[NSArray class]]) {
        for(id divider in (NSArray *)dividers)
            OMCIdlePaintControl(OMCIdleGet(divider,@selector(knob)),visible);
    }
    // The original ABI has a distinct allPanes owner. Some native
    // two-pane layouts use non-contiguous slot IDs (including AUTO=9),
    // so paneAtSlot:0..2 alone is not a complete enumeration.
    NSHashTable *seen=[NSHashTable weakObjectsHashTable];
    id all=[split allPanes];
    if([all isKindOfClass:NSArray.class]) {
        for(id pane in (NSArray *)all) {
            if(![pane respondsToSelector:@selector(handle)])continue;
            [seen addObject:pane];
            OMCIdlePaintPaneHandles(pane,visible);
        }
    }
    for(int slot=0;slot<3;slot++) {
        id pane=[split paneAtSlot:slot];
        if(pane && ![seen containsObject:pane])
            OMCIdlePaintPaneHandles(pane,visible);
    }
    if(!visible)NSLog(@"[OmniCarIdle] event=all-panes-painted count=%lu dividerCount=%lu",
       (unsigned long)seen.allObjects.count,
       (unsigned long)([dividers isKindOfClass:NSArray.class]?[(NSArray *)dividers count]:0));
    // NEVER touch split.ratioKnob; it is a DIFFERENT item within the native
    // three-choice popup. Original hideRatioMenu owns that object/lifecycle.
}
static void OMCIdleSchedule(OMCIdleState *s) {
    [s.idleTimer invalidate];
    s.idleTimer=nil;
    __weak OMCIdleState *weakState=s;
    s.idleTimer=[NSTimer scheduledTimerWithTimeInterval:kOMCIdleSeconds
        repeats:NO block:^(NSTimer *timer){
        (void)timer;
        OMCIdleState *live=weakState;
        if(!live || !live.split || ![live.split active])return;
        if(live.activeDividerTouches>0)return; // don't hide during native drag
        live.idleTimer=nil;
        live.visible=NO;
        OMCIdleApply(live.split);
        NSLog(@"[OmniCarIdle] event=auto-hide source=4s-idle");
    }];
}
static void OMCIdleWake(SCPCarSplit *split) {
    if(!split || ![split active])return;
    OMCIdleState *s=OMCIdleStateFor(split,YES);
    s.visible=YES;
    OMCIdleApply(split);
    OMCIdleSchedule(s);
}
static void OMCIdleHideWithNativeMenu(SCPCarSplit *split) {
    OMCIdleState *s=OMCIdleStateFor(split,NO);
    if(!s || ![split active])return;
    [s.idleTimer invalidate];
    s.idleTimer=nil;
    s.visible=NO;
    OMCIdleApply(split);
    NSLog(@"[OmniCarIdle] event=auto-hide source=native-hideRatioMenu");
}
static void OMCIdleLinkDividers(SCPCarSplit *split){
    id dividers=[split dividers];
    if(![dividers isKindOfClass:[NSArray class]])return;
    for(id divider in (NSArray *)dividers){
        if(![divider isKindOfClass:NSClassFromString(@"SCPCarDividerView")])continue;
        OMCIdleDividerLink *link=objc_getAssociatedObject(divider,&kOMCIdleDividerLinkKey);
        if(!link){
            link=[OMCIdleDividerLink new];
            objc_setAssociatedObject(divider,&kOMCIdleDividerLinkKey,link,OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        }
        link.split=split;
    }
}
static void OMCIdleAttach(SCPCarSplit *split){
    if(!split || ![split active])return;
    OMCIdleState *s=OMCIdleStateFor(split,YES);
    OMCIdleLinkDividers(split);
    UIView *root=[split container];
    if([root isKindOfClass:[UIView class]] && ![root isKindOfClass:[UIWindow class]]){
        if(!s.wakeGesture){
            OMCIdleWakeGesture *gesture=[[OMCIdleWakeGesture alloc]initWithTarget:nil action:NULL];
            gesture.split=split;
            gesture.cancelsTouchesInView=NO;
            gesture.delaysTouchesBegan=NO;
            gesture.delaysTouchesEnded=NO;
            s.wakeGesture=gesture;
        }
        if(s.gestureOwner!=root){
            if(s.gestureOwner)[s.gestureOwner removeGestureRecognizer:s.wakeGesture];
            [root addGestureRecognizer:s.wakeGesture];
            s.gestureOwner=root;
        }
    }
    // Host app views may be siblings of the split container. Observe
    // OmniCar's native tabParent only when it shares the original window;
    // recognizer FAILS immediately and never steals app/pan gestures.
    UIView *tab=[split tabParent];
    if([tab isKindOfClass:UIView.class] && ![tab isKindOfClass:UIWindow.class] &&
       tab!=root && tab.window && (!root.window || tab.window==root.window)) {
        if(!s.tabWakeGesture){
            s.tabWakeGesture=[[OMCIdleWakeGesture alloc]initWithTarget:nil action:NULL];
            s.tabWakeGesture.split=split;
            s.tabWakeGesture.cancelsTouchesInView=NO;
            s.tabWakeGesture.delaysTouchesBegan=NO;
            s.tabWakeGesture.delaysTouchesEnded=NO;
        }
        if(s.tabGestureOwner!=tab) {
            if(s.tabGestureOwner)[s.tabGestureOwner removeGestureRecognizer:s.tabWakeGesture];
            [tab addGestureRecognizer:s.tabWakeGesture];
            s.tabGestureOwner=tab;
        }
    } else if(s.tabGestureOwner && s.tabWakeGesture) {
        [s.tabGestureOwner removeGestureRecognizer:s.tabWakeGesture];
        s.tabGestureOwner=nil;
    }
    if(!s.started){
        s.started=YES;
        OMCIdleWake(split); // initial native split: controls vanish after 4s
    } else {
        OMCIdleApply(split); // preserve idle state after native relayout
    }
}
static void OMCIdleStop(SCPCarSplit *split){
    OMCIdleState *s=OMCIdleStateFor(split,NO);
    if(!s)return;
    [s.idleTimer invalidate];
    s.idleTimer=nil;
    s.activeDividerTouches=0;
    s.visible=YES;
    OMCIdleApply(split); // restore original opacity; no permanent visual patch
    if(s.gestureOwner && s.wakeGesture)
        [s.gestureOwner removeGestureRecognizer:s.wakeGesture];
    s.gestureOwner=nil;
    if(s.tabGestureOwner && s.tabWakeGesture)
        [s.tabGestureOwner removeGestureRecognizer:s.tabWakeGesture];
    s.tabGestureOwner=nil;
    s.tabWakeGesture=nil;
    s.started=NO;
}
// SCPCarSplit owns the original 4s ratio selector timer and pane handles.
%group OMCIdleSplit
%hook SCPCarSplit
- (id)newDividerAt:(int)index {
    id divider=%orig;
    OMCIdleDividerLink *link=[OMCIdleDividerLink new];
    link.split=(SCPCarSplit *)self;
    objc_setAssociatedObject(divider,&kOMCIdleDividerLinkKey,link,OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    OMCIdleApply((SCPCarSplit *)self);
    return divider;
}
- (void)rootDidLayout {
    %orig;
    OMCIdleAttach((SCPCarSplit *)self);
}
- (void)layoutBarForPane:(id)pane {
    %orig;
    OMCIdleState *state=OMCIdleStateFor((SCPCarSplit *)self,NO);
    OMCIdlePaintPaneHandles(pane,!state || state.visible ||
                                   state.activeDividerTouches>0);
}
- (void)showRatioMenuForDivider:(id)divider {
    %orig;
    OMCIdleWake((SCPCarSplit *)self);
}
- (void)hideRatioMenu {
    %orig;
    OMCIdleHideWithNativeMenu((SCPCarSplit *)self);
}
- (void)setBarVisible:(BOOL)visible forPane:(id)pane {
    %orig;
    (void)pane;
    // Native setBarVisible:YES can be emitted repeatedly during
    // streaming-app relayout. It is NOT necessarily a user touch;
    // rearming the timer here kept the YouTube handle permanently visible.
    // A real touch, native knob/menu event or first split activation owns
    // wake/rearm, and bar redraw must only repaint current idle state.
    OMCIdleState *idle=OMCIdleStateFor((SCPCarSplit *)self,NO);
    if(visible && (!idle || !idle.started))OMCIdleWake((SCPCarSplit *)self);
    else OMCIdleApply((SCPCarSplit *)self);
}
- (void)setActive:(BOOL)active {
    if(!active)OMCIdleStop((SCPCarSplit *)self);
    %orig;
    if(active)OMCIdleAttach((SCPCarSplit *)self);
}
%end
%end
// SCPCarDividerView handles native drag/touch recognizers and hit testing.
// Never alter its gesture recognizers or the divider's interactive geometry.
%group OMCIdleDivider
%hook SCPCarDividerView
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    OMCIdleDividerLink *link=objc_getAssociatedObject(self,&kOMCIdleDividerLinkKey);
    OMCIdleState *s=OMCIdleStateFor(link.split,NO);
    if(s && touches.count){
        s.activeDividerTouches+=1;
        [s.idleTimer invalidate];
        s.idleTimer=nil;
        OMCIdleWake(link.split);
    }
    %orig;
}
- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    %orig;
    OMCIdleDividerLink *link=objc_getAssociatedObject(self,&kOMCIdleDividerLinkKey);
    OMCIdleState *s=OMCIdleStateFor(link.split,NO);
    if(s){
        if(touches.count && s.activeDividerTouches)s.activeDividerTouches--;
        OMCIdleWake(link.split);
    }
}
- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    %orig;
    OMCIdleDividerLink *link=objc_getAssociatedObject(self,&kOMCIdleDividerLinkKey);
    OMCIdleState *s=OMCIdleStateFor(link.split,NO);
    if(s){
        if(touches.count && s.activeDividerTouches)s.activeDividerTouches--;
        OMCIdleWake(link.split);
    }
}
%end
%end

static BOOL OMCIdleInstalled=NO;
static void OMCIdleTryInstall(NSUInteger retry){
    if(OMCIdleInstalled)return;
    if(!NSClassFromString(@"SCPCarSplit")||!NSClassFromString(@"SCPCarDividerView")){
        if(retry<40)
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW,(int64_t)(0.5*NSEC_PER_SEC)),
              dispatch_get_main_queue(),^{OMCIdleTryInstall(retry+1);});
        return;
    }
    %init(OMCIdleSplit);
    %init(OMCIdleDivider);
    OMCIdleInstalled=YES;
    NSLog(@"[OmniCarIdle] installed source-only native 4s sync; no UI geometry changes");
}
%ctor{
    @autoreleasepool {
        NSString *bundle=NSBundle.mainBundle.bundleIdentifier.lowercaseString?:@"";
        if([bundle isEqualToString:@"com.apple.carplayapp"]||
           [bundle isEqualToString:@"com.apple.springboard"])
            dispatch_async(dispatch_get_main_queue(),^{OMCIdleTryInstall(0);});
    }
}
