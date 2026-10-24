// QA18: original 1.0.3 native idle + DuoFace-style touch hitTest broadcasts ONE activity for ALL controls.
// Only original SCPCarSplitView hitTest is observed, never change native hit-test result or player/scene.
// DO NOT hook native soloBundle:/hostSolo:/closeGoingHome:/closeSlot:.
// Keep original split/solo/drag/player/UI controls, and all native touch frames.
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>
#import <objc/runtime.h>
#import <objc/message.h>
#import <CoreFoundation/CoreFoundation.h>

static const NSTimeInterval kOMCNativeIdleSeconds=4.0;
static char kOMCNativeTimerKey;
static char kOMCNativeSavedOpacityKey;
static char kOMCNativeRootActivityKey;
static NSHashTable<SCPCarSplit *> *gOMCNativeSplits=nil;
static CFTimeInterval gOMCLastGlobalTap=0.0;
static void OMCNativeSharedActivity(BOOL publish,const char *reason);

@class SCPCarSplit;
@interface SCPCarSplitView : UIView
@end

@interface SCPCarSplit : NSObject
- (BOOL)active;
- (UIView *)container;
- (UIView *)tabParent;
- (id)allPanes;
- (id)dividers;
@end

@class OMCNativeTimerState;
static void OMCNativeTimerWake(SCPCarSplit *split);

@interface OMCNativeTimerTouch : UIGestureRecognizer
@property(nonatomic,weak) SCPCarSplit *nativeSplit;
@end
@implementation OMCNativeTimerTouch
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    if(touches.count) OMCNativeTimerWake(self.nativeSplit);
    self.state=UIGestureRecognizerStateFailed;
}
- (BOOL)canPreventGestureRecognizer:(UIGestureRecognizer *)other { (void)other; return NO; }
- (BOOL)canBePreventedByGestureRecognizer:(UIGestureRecognizer *)other { (void)other; return NO; }
@end

@interface OMCNativeTimerState : NSObject
@property(nonatomic,weak) SCPCarSplit *nativeSplit;
@property(nonatomic,strong) NSTimer *timer;
@property(nonatomic,strong) NSHashTable<UIView *> *modifiedViews;
@property(nonatomic,strong) OMCNativeTimerTouch *containerTouch;
@property(nonatomic,strong) OMCNativeTimerTouch *tabTouch;
@property(nonatomic,weak) UIView *containerOwner;
@property(nonatomic,weak) UIView *tabOwner;
@property(nonatomic) BOOL visible;
@property(nonatomic) BOOL started;
@end
@implementation OMCNativeTimerState @end

static id OMCNativeGet(id obj,SEL sel) {
    return obj && [obj respondsToSelector:sel] ?
      ((id(*)(id,SEL))objc_msgSend)(obj,sel) : nil;
}
static OMCNativeTimerState *OMCNativeState(SCPCarSplit *split,BOOL create) {
    if(!split)return nil;
    OMCNativeTimerState *s=objc_getAssociatedObject(split,&kOMCNativeTimerKey);
    if(!s && create){
        s=[OMCNativeTimerState new];
        s.nativeSplit=split;
        s.visible=YES;
        s.modifiedViews=[NSHashTable weakObjectsHashTable];
        objc_setAssociatedObject(split,&kOMCNativeTimerKey,s,OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        if(!gOMCNativeSplits)gOMCNativeSplits=[NSHashTable weakObjectsHashTable];
        [gOMCNativeSplits addObject:split];
    }
    return s;
}
// Cosmetic CALayer change ONLY. Do not change hidden, userInteractionEnabled,
// frame, native pan/touch recognizers, or any Solo/CarPlay state.
static void OMCNativePaint(id target,OMCNativeTimerState *s,BOOL visible) {
    if(![target isKindOfClass:UIView.class])return;
    UIView *v=(UIView *)target;
    NSNumber *saved=objc_getAssociatedObject(v,&kOMCNativeSavedOpacityKey);
    if(visible) {
        if(saved){
            v.layer.opacity=saved.floatValue;
            objc_setAssociatedObject(v,&kOMCNativeSavedOpacityKey,nil,OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            [s.modifiedViews removeObject:v];
        }
    } else {
        if(!saved){
            objc_setAssociatedObject(v,&kOMCNativeSavedOpacityKey,@(v.layer.opacity),
                OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            [s.modifiedViews addObject:v];
        }
        v.layer.opacity=0.0f;
    }
}
static void OMCNativeApply(SCPCarSplit *split) {
    OMCNativeTimerState *s=OMCNativeState(split,NO);
    if(!s)return;
    id panes=[split allPanes];
    if([panes isKindOfClass:NSArray.class])
        for(id pane in (NSArray *)panes)
            OMCNativePaint(OMCNativeGet(pane,@selector(handle)),s,s.visible);
    // Hide the NATIVE divider visual (line and knob) together, retaining
    // its actual UIView and pointInside/drag/gesture interaction unchanged.
    id dividers=[split dividers];
    if([dividers isKindOfClass:NSArray.class])
        for(id divider in (NSArray *)dividers)
            OMCNativePaint(divider,s,s.visible);
}
static void OMCNativeSchedule(OMCNativeTimerState *s) {
    [s.timer invalidate];
    s.timer=nil;
    __weak OMCNativeTimerState *weak=s;
    s.timer=[NSTimer scheduledTimerWithTimeInterval:kOMCNativeIdleSeconds
        repeats:NO block:^(NSTimer *timer) {
        (void)timer;
        OMCNativeTimerState *live=weak;
        if(!live || !live.nativeSplit || ![live.nativeSplit active])return;
        live.timer=nil;
        live.visible=NO;
        OMCNativeApply(live.nativeSplit);
        NSLog(@"[OmniCarNativeSoloTimer] event=hide-two-pane-menus-and-divider");
    }];
}
static void OMCNativeTimerWake(SCPCarSplit *split) {
    if(!split || ![split active])return;
    OMCNativeTimerState *s=OMCNativeState(split,YES);
    BOOL hadHidden=!s.visible;
    s.visible=YES;
    OMCNativeApply(split);
    OMCNativeSchedule(s);
    if(hadHidden)
        NSLog(@"[OmniCarUnifiedWakeQA18] event=native-all-controls-revealed");
}
// Exactly as DuoFace v12: the actual split-view hitTest is the activity entry,
// BEFORE the original remote/hosted app event is delivered. On the second
// process, a Darwin notification resets all ABPane YouTube handle timers.
static void OMCNativeSharedActivity(BOOL publish,const char *reason) {
    for(SCPCarSplit *split in gOMCNativeSplits.allObjects) {
        if([split active])OMCNativeTimerWake(split);
    }
    if(publish){
        CFTimeInterval now=CACurrentMediaTime();
        if(now-gOMCLastGlobalTap>=0.12){
            gOMCLastGlobalTap=now;
            CFNotificationCenterPostNotification(CFNotificationCenterGetDarwinNotifyCenter(),
                CFSTR("com.anlai.omnicar.qa18.controls.activity"),NULL,NULL,true);
            NSLog(@"[OmniCarUnifiedWakeQA18] event=activity-published source=%s",reason);
        }
    }
}
static void OMCNativeReceivedActivity(CFNotificationCenterRef center,void *observer,
    CFStringRef name,const void *object,CFDictionaryRef userInfo) {
    (void)center;(void)observer;(void)name;(void)object;(void)userInfo;
    if(NSThread.isMainThread)OMCNativeSharedActivity(NO,"darwin");
    else dispatch_async(dispatch_get_main_queue(),^{ OMCNativeSharedActivity(NO,"darwin"); });
}
static void OMCNativeAttachTouch(OMCNativeTimerState *s,SCPCarSplit *split,
                                 UIView *view,BOOL tab) {
    if(!view || [view isKindOfClass:UIWindow.class])return;
    OMCNativeTimerTouch *gesture=tab?s.tabTouch:s.containerTouch;
    UIView *prior=tab?s.tabOwner:s.containerOwner;
    if(!gesture) {
        gesture=[[OMCNativeTimerTouch alloc]initWithTarget:nil action:NULL];
        gesture.nativeSplit=split;
        gesture.cancelsTouchesInView=NO;
        gesture.delaysTouchesBegan=NO;
        gesture.delaysTouchesEnded=NO;
        if(tab)s.tabTouch=gesture;
        else s.containerTouch=gesture;
    }
    if(prior!=view) {
        if(prior)[prior removeGestureRecognizer:gesture];
        [view addGestureRecognizer:gesture];
        if(tab)s.tabOwner=view;
        else s.containerOwner=view;
    }
}
static void OMCNativeAttach(SCPCarSplit *split) {
    if(!split || ![split active])return;
    OMCNativeTimerState *s=OMCNativeState(split,YES);
    UIView *root=[split container];
    Class splitView=NSClassFromString(@"SCPCarSplitView");
    if(splitView && [root isKindOfClass:splitView]) {
        // The association is a retained state with WEAK split pointer: no
        // dangling SCPCarSplit reference when original split is torn down.
        objc_setAssociatedObject(root,&kOMCNativeRootActivityKey,s,OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    if([root isKindOfClass:UIView.class] && ![root isKindOfClass:UIWindow.class]) {
        OMCNativeAttachTouch(s,split,root,NO);
        UIView *tab=[split tabParent];
        if([tab isKindOfClass:UIView.class] && tab!=root &&
           ![tab isKindOfClass:UIWindow.class] && root.window && tab.window==root.window)
            OMCNativeAttachTouch(s,split,tab,YES);
        else if(s.tabOwner && s.tabTouch) {
            [s.tabOwner removeGestureRecognizer:s.tabTouch];
            s.tabOwner=nil;
        }
    }
    if(!s.started){
        s.started=YES;
        OMCNativeTimerWake(split);
    }else OMCNativeApply(split); // repeated layout MUST NOT reset the timer
}
static void OMCNativeStop(SCPCarSplit *split) {
    OMCNativeTimerState *s=OMCNativeState(split,NO);
    if(!s)return;
    [s.timer invalidate];
    s.timer=nil;
    UIView *root=[split container];
    if(root && objc_getAssociatedObject(root,&kOMCNativeRootActivityKey)==s)
        objc_setAssociatedObject(root,&kOMCNativeRootActivityKey,nil,OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [gOMCNativeSplits removeObject:split];
    s.visible=YES;
    // Restore ALL modified opacity before native Solo tears down panes.
    for(UIView *view in s.modifiedViews.allObjects)
        OMCNativePaint(view,s,YES);
    if(s.containerOwner && s.containerTouch)
        [s.containerOwner removeGestureRecognizer:s.containerTouch];
    if(s.tabOwner && s.tabTouch)
        [s.tabOwner removeGestureRecognizer:s.tabTouch];
    s.containerOwner=nil;
    s.tabOwner=nil;
    s.containerTouch=nil;
    s.tabTouch=nil;
    s.started=NO;
}

// Only native split VISUAL hooks; absolutely NO Solo lifecycle methods.
%group OMCNativeSoloTimerHooks
%hook SCPCarSplit
- (void)rootDidLayout {
    %orig;
    OMCNativeAttach((SCPCarSplit *)self);
}
- (void)setActive:(BOOL)active {
    if(!active) OMCNativeStop((SCPCarSplit *)self);
    %orig;
    if(active) OMCNativeAttach((SCPCarSplit *)self);
}
- (void)layoutBarForPane:(id)pane {
    %orig;
    OMCNativeTimerState *s=OMCNativeState((SCPCarSplit *)self,NO);
    if(s) OMCNativePaint(OMCNativeGet(pane,@selector(handle)),s,s.visible);
}
- (void)handleTapped:(id)handle {
    %orig;
    OMCNativeSharedActivity(YES,"native-handle-tapped");
}
- (void)dividerTapped:(id)divider {
    %orig;
    OMCNativeSharedActivity(YES,"native-divider-tapped");
}
%end
// Binary-proven SCPCarSplitView.hitTest:withEvent: IMP 0xe88c.
// Same entry-point category as DuoFace CBSplitContainerView.hitTest 0x10182c;
// retain exact native %@ hit target (never return a new UIView or take touches).
%hook SCPCarSplitView
- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    UIView *nativeTarget=%orig;
    OMCNativeTimerState *s=objc_getAssociatedObject(self,&kOMCNativeRootActivityKey);
    SCPCarSplit *split=s.nativeSplit;
    if(s && split && [split active] && event && event.type==UIEventTypeTouches &&
       CGRectContainsPoint(self.bounds,point) && self.window) {
        BOOL userBegan=NO;
        for(UITouch *touch in event.allTouches) {
            if(touch.phase==UITouchPhaseBegan && touch.window==self.window){
                userBegan=YES;
                break;
            }
        }
        if(userBegan)OMCNativeSharedActivity(YES,"original-split-hitTest");
    }
    return nativeTarget;
}
%end
%end

static BOOL kOMCNativeTimerInstalled=NO;
static void OMCNativeTimerInstall(NSUInteger attempts) {
    if(kOMCNativeTimerInstalled)return;
    if(!NSClassFromString(@"SCPCarSplit")) {
        if(attempts<30)dispatch_after(dispatch_time(DISPATCH_TIME_NOW,
            (int64_t)(0.5*NSEC_PER_SEC)),dispatch_get_main_queue(),
            ^{ OMCNativeTimerInstall(attempts+1); });
        return;
    }
    %init(OMCNativeSoloTimerHooks);
    CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(),
        NULL,OMCNativeReceivedActivity,
        CFSTR("com.anlai.omnicar.qa18.controls.activity"),NULL,
        CFNotificationSuspensionBehaviorDeliverImmediately);
    kOMCNativeTimerInstalled=YES;
    NSLog(@"[OmniCarNativeSoloTimer] QA18 original DuoFace-style native split hitTest and shared 4s reveal enabled; Solo untouched");
}
%ctor {
    @autoreleasepool {
        NSString *bundle=NSBundle.mainBundle.bundleIdentifier.lowercaseString?:@"";
        if([bundle isEqualToString:@"com.apple.carplayapp"]||
           [bundle isEqualToString:@"com.apple.springboard"])
            dispatch_async(dispatch_get_main_queue(), ^{OMCNativeTimerInstall(0);});
    }
}
