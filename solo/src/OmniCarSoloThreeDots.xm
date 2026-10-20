// OmniCar native edge-close remains UNCHANGED. SOLO three-dots source-only stage.
// Native SCPCarPane.handle cannot be revived once closeGoingHome clears its VC.
// Capture native handle artwork, paired bundle IDs, retained CarPlay host
// window and app-content rect BEFORE closeSlot destroys split-owned views.
// Mount a pass-through menu on the VERIFIED native solo presentation owner,
// falling back only to the EXACT CarPlay host window captured from OmniCar.
// Do not hook UIWindow/UIKit globally. Do not touch CarPlay dock/Home or Zoom.
#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import <objc/runtime.h>
#import <math.h>
@interface SCPCarSplit : NSObject
- (BOOL)active;
- (int)paneCount;
- (int)layoutID;
- (NSArray *)slots;
- (NSArray *)allPanes;
- (NSArray *)panesInReadingOrder;
- (id)paneAtSlot:(int)slot;
- (NSArray *)fractions;
- (void)setFractions:(NSArray *)fractions;
- (void)relayoutAnimated:(BOOL)animated pushScenes:(BOOL)pushScenes;
- (UIView *)tabParent;
- (CGRect)appAreaInParent:(UIView *)parent;
- (NSString *)soloHostedBundle;
- (id)soloReturnedVC;
- (id)soloCover;
- (id)launcherHost;
- (void)openSetupLayout:(int)layout apps:(NSArray *)apps;
@end
@interface SCPCarPane : NSObject
- (NSString *)bundleID;
- (UIView *)handle;
@end
static char OMCSoloKey;
static const NSTimeInterval OMCSoloDelay=4.0;
@class OMCSoloState;
static void OMCSoloWake(OMCSoloState *s);
static void OMCSoloMount(OMCSoloState *s,int attempt);
@interface OMCSoloWakeGesture : UIGestureRecognizer
@property(nonatomic,weak) OMCSoloState *owner;
@end
@implementation OMCSoloWakeGesture
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    if(touches.count)OMCSoloWake(self.owner);
    self.state=UIGestureRecognizerStateFailed;
}
- (BOOL)canPreventGestureRecognizer:(UIGestureRecognizer *)other { (void)other; return NO; }
- (BOOL)canBePreventedByGestureRecognizer:(UIGestureRecognizer *)other { (void)other; return NO; }
@end
@interface OMCSoloState : NSObject
@property(nonatomic,weak) SCPCarSplit *split;
@property(nonatomic,copy) NSArray<NSString *> *apps;
@property(nonatomic,copy) NSArray *fractions;
@property(nonatomic) int layout;
@property(nonatomic,strong) UIImage *nativeDots;
@property(nonatomic) CGSize nativeSize;
@property(nonatomic) CGPoint relativePosition;
@property(nonatomic,strong) UIButton *dots;
@property(nonatomic,strong) UIButton *restore;
@property(nonatomic,strong) NSTimer *timer;
@property(nonatomic,strong) OMCSoloWakeGesture *gesture;
@property(nonatomic,weak) UIView *ownerView;
@property(nonatomic,weak) UIWindow *capturedCarPlayWindow;
@property(nonatomic,weak) UIView *capturedContentRoot;
@property(nonatomic) CGRect capturedAppRectInWindow;
@property(nonatomic,strong) UIView *hitPassOverlay;
@property(nonatomic) NSInteger mountedGeneration;
@property(nonatomic) NSInteger mountSequence;
@property(nonatomic) BOOL visible;
@property(nonatomic) BOOL busy;
@property(nonatomic) BOOL pendingEdgeClose;
@property(nonatomic) BOOL confirmedEdgeSolo;
@end
@implementation OMCSoloState @end
static OMCSoloState *OMCState(SCPCarSplit *split,BOOL create) {
    if(!split)return nil;
    OMCSoloState *s=objc_getAssociatedObject(split,&OMCSoloKey);
    if(!s && create){
        s=[OMCSoloState new];s.split=split;
        objc_setAssociatedObject(split,&OMCSoloKey,s,OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return s;
}
static void OMCClearVisual(OMCSoloState *s){
    [s.timer invalidate];s.timer=nil;
    if(s.gesture && s.ownerView)[s.ownerView removeGestureRecognizer:s.gesture];
    [s.restore removeFromSuperview];[s.dots removeFromSuperview];
    [s.hitPassOverlay removeFromSuperview];
    s.restore=nil;s.dots=nil;s.gesture=nil;s.ownerView=nil;s.hitPassOverlay=nil;
}
static void OMCTimeout(OMCSoloState *s){
    [s.timer invalidate];s.timer=nil;
    __weak OMCSoloState *weak=s;
    s.timer=[NSTimer scheduledTimerWithTimeInterval:OMCSoloDelay repeats:NO block:^(NSTimer *t){
        (void)t;OMCSoloState *state=weak;
        if(!state || state.busy)return;
        state.visible=NO;state.dots.layer.opacity=0;
        [state.restore removeFromSuperview];state.restore=nil;
        NSLog(@"[OmniCarSoloDots] event=auto-hide 4s");
    }];
}
static void OMCSoloWake(OMCSoloState *s){
    if(!s || !s.dots || s.busy)return;
    s.visible=YES;s.dots.layer.opacity=1;
    OMCTimeout(s);
}
static UIImage *OMCNativeHandleBitmap(UIView *handle){
    if(!handle || ![handle isKindOfClass:UIView.class])return nil;
    CGSize z=handle.bounds.size;
    if(z.width<8 || z.height<8 || z.width>230 || z.height>150)return nil;
    CGFloat saved=handle.layer.opacity;
    [CATransaction begin];[CATransaction setDisableActions:YES];
    handle.layer.opacity=1;
    UIGraphicsBeginImageContextWithOptions(z,NO,0);
    CGContextRef c=UIGraphicsGetCurrentContext();
    if(c)[handle.layer renderInContext:c];
    UIImage *result=c?UIGraphicsGetImageFromCurrentImageContext():nil;
    UIGraphicsEndImageContext();
    handle.layer.opacity=saved;
    [CATransaction commit];
    return result;
}
static void OMCSnapshotBeforeClose(SCPCarSplit *split,int slot) {
    // Native AUTO slot 9 is special-cased in original closeSlot:background:
    // ARM64 @0x1d9d8. NEVER reject a valid destructive edge-close solely
    // because its input is not 0/1. Only the split being a pair matters.
    if([split paneCount]!=2)return;
    // Native slots may include AUTO/noncontiguous indices. Reconstruct
    // the two actual panes in visual reading order; never interpret an
    // NSArray of slot identifiers as SCPCarPane objects.
    NSArray *all=[split panesInReadingOrder];
    if(![all isKindOfClass:NSArray.class] || all.count!=2 ||
       ![all[0] respondsToSelector:@selector(bundleID)] ||
       ![all[1] respondsToSelector:@selector(bundleID)]) {
        all=[split allPanes];
    }
    if(![all isKindOfClass:NSArray.class] || all.count!=2 ||
       ![all[0] respondsToSelector:@selector(bundleID)] ||
       ![all[1] respondsToSelector:@selector(bundleID)]) {
        all=[split slots];
    }
    if(![all isKindOfClass:NSArray.class] || all.count!=2 ||
       ![all[0] respondsToSelector:@selector(bundleID)] ||
       ![all[1] respondsToSelector:@selector(bundleID)]) {
        id leftCandidate=[split paneAtSlot:0],rightCandidate=[split paneAtSlot:1];
        if(leftCandidate && rightCandidate &&
           [leftCandidate respondsToSelector:@selector(bundleID)] &&
           [rightCandidate respondsToSelector:@selector(bundleID)])
            all=@[leftCandidate,rightCandidate];
    }
    if(![all isKindOfClass:NSArray.class] || all.count!=2 ||
       ![all[0] respondsToSelector:@selector(bundleID)] ||
       ![all[1] respondsToSelector:@selector(bundleID)]) {
        NSLog(@"[OmniCarSoloDots] capture-blocked: could-not-resolve-two-real-panes");
        return;
    }
    SCPCarPane *left=all[0], *right=all[1];
    NSString *a=[left bundleID],*b=[right bundleID];
    if(![a isKindOfClass:NSString.class]||a.length==0||
       ![b isKindOfClass:NSString.class]||b.length==0)return;
    SCPCarPane *survivor=slot==0?right:(slot==1?left:right);
    UIView *handle=[survivor handle],*root=[split tabParent];
    if(![root isKindOfClass:UIView.class] || !root.window) {
        root=[split respondsToSelector:@selector(launcherHost)]
            ?[split launcherHost]:nil;
    }
    UIImage *native=OMCNativeHandleBitmap(handle);
    CGSize handleSize=handle.bounds.size;
    if(!native) {
        // Original handle may be visually hidden by Idle4s or destroyed
        // before bitmap capture; keep an accessible 3-dot restore affordance.
        handleSize=CGSizeMake(48,26);
        UIGraphicsBeginImageContextWithOptions(handleSize,NO,0);
        CGContextRef context=UIGraphicsGetCurrentContext();
        if(context){
            UIBezierPath *pill=[UIBezierPath bezierPathWithRoundedRect:
                CGRectMake(1,1,46,24) cornerRadius:12];
            [[UIColor colorWithWhite:.15 alpha:.9] setFill];[pill fill];
            [[UIColor colorWithWhite:.78 alpha:.88] setStroke];
            pill.lineWidth=1.2;[pill stroke];
            [[UIColor colorWithWhite:.88 alpha:1] setFill];
            for(int dot=0;dot<3;dot++){
                UIBezierPath *circle=[UIBezierPath bezierPathWithOvalInRect:
                    CGRectMake(17+dot*7,11,3.1,3.1)];
                [circle fill];
            }
            native=UIGraphicsGetImageFromCurrentImageContext();
        }
        UIGraphicsEndImageContext();
        NSLog(@"[OmniCarSoloDots] capture-fallback: original-handle-unavailable");
    }
    if(!native)return;
    OMCSoloState *s=OMCState(split,YES);OMCClearVisual(s);
    s.apps=@[[a copy],[b copy]];
    // Existing native order is authoritative, even with AUTO slot=9.
    s.mountSequence++;s.mountedGeneration=0;
    s.capturedContentRoot=[root isKindOfClass:UIView.class]?root:nil;
    UIWindow *originalWindow=[root isKindOfClass:UIView.class]?root.window:nil;
    s.capturedCarPlayWindow=originalWindow;
    CGRect originalArea=CGRectZero;
    if(originalWindow && [root isKindOfClass:UIView.class]) {
        CGRect r=[split appAreaInParent:root];
        if(!CGRectIsEmpty(r) && CGRectIsFinite(r.origin.x) &&
           CGRectIsFinite(r.origin.y) && CGRectIsFinite(r.size.width) &&
           CGRectIsFinite(r.size.height))
            originalArea=[root convertRect:r toView:originalWindow];
    }
    s.capturedAppRectInWindow=originalArea;
    s.layout=[split layoutID];
    s.fractions=[[split fractions] copy];
    s.nativeDots=native;s.nativeSize=handleSize;
    CGRect area=[split appAreaInParent:root];
    if([root isKindOfClass:UIView.class] && handle.window &&
       root.window==handle.window && !CGRectIsEmpty(area)){
        CGRect box=[handle convertRect:handle.bounds toView:root];
        s.relativePosition=CGPointMake((CGRectGetMidX(box)-CGRectGetMinX(area))/CGRectGetWidth(area),
                                        (CGRectGetMidY(box)-CGRectGetMinY(area))/CGRectGetHeight(area));
    }else s.relativePosition=CGPointMake(.88,.12);
    s.busy=NO;s.pendingEdgeClose=YES;s.confirmedEdgeSolo=NO;
    NSLog(@"[OmniCarSoloDots] event=captured slot=%d apps=%lu preWindow=%d appRect=%@",
          slot,(unsigned long)s.apps.count,originalWindow!=nil,
          NSStringFromCGRect(s.capturedAppRectInWindow));
}
static void OMCRestoreFractions(OMCSoloState *s,int attempt){
    SCPCarSplit *split=s.split;
    if(!split || ![split active] || [split paneCount]!=2){
        if(attempt<12){
            __weak OMCSoloState *weak=s;
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW,300*NSEC_PER_MSEC),
                           dispatch_get_main_queue(),^{if(weak)OMCRestoreFractions(weak,attempt+1);});
        }else{
            s.busy=NO;
            NSLog(@"[OmniCarSoloDots] restore layout unconfirmed");
            // The original open call may fail to reactivate; only remount
            // if the native SOLO owner still exists, never on system UI.
            if(s.apps.count==2)OMCSoloMount(s,0);
        }
        return;
    }
    NSArray *saved=s.fractions,*cur=[split fractions];
    BOOL valid=[saved isKindOfClass:NSArray.class] && saved.count>0 &&
      [cur isKindOfClass:NSArray.class] && saved.count==cur.count;
    for(id v in saved)if(![v isKindOfClass:NSNumber.class]||
                         !isfinite([v doubleValue])||[v doubleValue]<0||[v doubleValue]>1)valid=NO;
    if(valid){
        [split setFractions:[saved copy]];
        [split relayoutAnimated:NO pushScenes:YES];
    }
    s.apps=nil;s.fractions=nil;s.nativeDots=nil;s.busy=NO;
    NSLog(@"[OmniCarSoloDots] native split restored; fractionsValid=%d",valid);
}
static void OMCRestoreSplit(OMCSoloState *s){
    SCPCarSplit *split=s.split;
    if(!split||s.busy||[split active]||s.apps.count!=2)return;
    s.busy=YES;OMCClearVisual(s);
    [split openSetupLayout:s.layout apps:[s.apps copy]]; // ORIGINAL IMP 0x3ab7c
    OMCRestoreFractions(s,0);
}
@interface OMCSoloDotAction : NSObject
@property(nonatomic,weak) OMCSoloState *owner;
- (void)openMenu:(UIButton *)sender;
- (void)restore:(UIButton *)sender;
@end
@implementation OMCSoloDotAction
- (void)openMenu:(UIButton *)sender {
    (void)sender;
    OMCSoloState *s=self.owner;
    if(!s || s.busy)return;
    if(!s.visible){OMCSoloWake(s);return;}
    if(s.restore){
        [s.restore removeFromSuperview];s.restore=nil;OMCTimeout(s);return;
    }
    UIView *parent=s.ownerView;
    if(!parent || !parent.window)return;
    CGRect area=[s.split appAreaInParent:parent],dot=s.dots.frame;
    CGFloat width=MIN(216,CGRectGetWidth(area)-16);
    if(width<140)return;
    CGFloat x=MIN(MAX(CGRectGetMidX(dot)-width/2,CGRectGetMinX(area)+8),
                  CGRectGetMaxX(area)-width-8);
    CGFloat y=CGRectGetMaxY(dot)+8;
    if(y+44>CGRectGetMaxY(area)-8)y=CGRectGetMinY(dot)-52;
    UIButton *choice=[UIButton buttonWithType:UIButtonTypeSystem];
    [choice setTitle:@"Khôi phục chia màn hình" forState:UIControlStateNormal];
    choice.accessibilityLabel=@"Khôi phục hai ô OmniCar";
    choice.frame=CGRectMake(x,y,width,44);
    choice.backgroundColor=[UIColor colorWithWhite:.10 alpha:.94];
    choice.layer.cornerRadius=10;
    choice.layer.borderWidth=1;
    choice.layer.borderColor=[UIColor colorWithWhite:.8 alpha:.7].CGColor;
    [choice setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    [choice addTarget:self action:@selector(restore:) forControlEvents:UIControlEventTouchUpInside];
    [parent addSubview:choice];s.restore=choice;OMCTimeout(s);
}
- (void)restore:(UIButton *)sender{(void)sender;OMCRestoreSplit(self.owner);}
@end
static void OMCSoloMount(OMCSoloState *s,int attempt){
    SCPCarSplit *split=s.split;
    if(!split||s.busy||s.apps.count!=2||[split active])return;
    UIView *parent=[split tabParent];
    NSString *solo=[split soloHostedBundle];
    id returned=[split soloReturnedVC];
    if((![parent isKindOfClass:UIView.class] || !parent.window) &&
       [returned isKindOfClass:UIViewController.class]) {
        UIView *returnedView=[(UIViewController *)returned viewIfLoaded];
        if(returnedView.window)parent=returnedView;
    }
    // Some native solo transitions detach the original VC instead of hostSolo.
    BOOL hasSolo=([solo isKindOfClass:NSString.class] && [s.apps containsObject:solo])
              || returned!=nil || s.confirmedEdgeSolo;
    if(![parent isKindOfClass:UIView.class] || !parent.window || !hasSolo){
        if(attempt<20){
            __weak OMCSoloState *weak=s;
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW,200*NSEC_PER_MSEC),
              dispatch_get_main_queue(),^{if(weak)OMCSoloMount(weak,attempt+1);});
        }else NSLog(@"[OmniCarSoloDots] unable to attach: parent=%d mounted=%d solo=%d returned=%d confirmedEdge=%d",
                       [parent isKindOfClass:UIView.class],parent.window!=nil,
                       solo.length>0,returned!=nil,s.confirmedEdgeSolo);
        return;
    }
    if(s.dots && s.ownerView==parent)return;
    OMCClearVisual(s);
    CGRect rect=[split appAreaInParent:parent];
    CGSize z=s.nativeSize;
    if(!s.nativeDots || CGRectGetWidth(rect)<z.width+16 ||
                         CGRectGetHeight(rect)<z.height+16)return;
    CGFloat cx=CGRectGetMinX(rect)+MAX(0,MIN(1,s.relativePosition.x))*CGRectGetWidth(rect);
    CGFloat cy=CGRectGetMinY(rect)+MAX(0,MIN(1,s.relativePosition.y))*CGRectGetHeight(rect);
    CGFloat x=MAX(CGRectGetMinX(rect)+4,MIN(cx-z.width/2,CGRectGetMaxX(rect)-z.width-4));
    CGFloat y=MAX(CGRectGetMinY(rect)+4,MIN(cy-z.height/2,CGRectGetMaxY(rect)-z.height-4));
    UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
    button.frame=CGRectMake(x,y,z.width,z.height);
    [button setBackgroundImage:s.nativeDots forState:UIControlStateNormal];
    button.accessibilityLabel=@"Menu OmniCar khi chỉ còn một ứng dụng";
    OMCSoloDotAction *a=[OMCSoloDotAction new];a.owner=s;
    objc_setAssociatedObject(button,@selector(openMenu:),a,OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [button addTarget:a action:@selector(openMenu:) forControlEvents:UIControlEventTouchUpInside];
    [parent addSubview:button];s.dots=button;s.ownerView=parent;
    OMCSoloWakeGesture *g=[[OMCSoloWakeGesture alloc]initWithTarget:nil action:NULL];
    g.owner=s;g.cancelsTouchesInView=NO;g.delaysTouchesBegan=NO;g.delaysTouchesEnded=NO;
    [parent addGestureRecognizer:g];s.gesture=g;s.visible=YES;
    OMCTimeout(s);
    NSLog(@"[OmniCarSoloDots] mounted native 3dots clone in OmniCar tabParent only");
}
static void OMCScheduleMount(OMCSoloState *s){
    __weak OMCSoloState *weak=s;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW,200*NSEC_PER_MSEC),
      dispatch_get_main_queue(),^{if(weak)OMCSoloMount(weak,0);});
}
%group OMCSoloNative
%hook SCPCarSplit
- (void)closeSlot:(int)slot background:(BOOL)background {
    OMCSnapshotBeforeClose((SCPCarSplit *)self,slot);
    %orig;
    OMCSoloState *s=OMCState((SCPCarSplit *)self,NO);
    if(s){
        BOOL prepared=s.pendingEdgeClose;
        s.pendingEdgeClose=NO;
        if(prepared && ![(SCPCarSplit *)self active]){
            s.confirmedEdgeSolo=YES;
            OMCScheduleMount(s);
        }
    }
}
- (void)closeGoingHome:(BOOL)background {
    %orig;
    OMCSoloState *s=OMCState((SCPCarSplit *)self,NO);
    if(s && s.pendingEdgeClose && s.apps.count==2 && !s.busy)
        OMCScheduleMount(s);
    else if(s && !s.pendingEdgeClose){
        // Explicit Home/disconnect after SOLO must not leave a floating 3dot.
        OMCClearVisual(s);s.apps=nil;s.fractions=nil;s.nativeDots=nil;
        s.confirmedEdgeSolo=NO;
    }
}
- (void)openSetupLayout:(int)layout apps:(NSArray *)apps {
    OMCSoloState *s=OMCState((SCPCarSplit *)self,NO);
    if(s){OMCClearVisual(s);s.pendingEdgeClose=NO;s.confirmedEdgeSolo=NO;}
    %orig;
}
%end
%end
static BOOL OMCSoloInstalled=NO;
static void OMCTry(NSUInteger retry){
    if(OMCSoloInstalled)return;
    if(!NSClassFromString(@"SCPCarSplit")){
        if(retry<40)dispatch_after(dispatch_time(DISPATCH_TIME_NOW,500*NSEC_PER_MSEC),
                                   dispatch_get_main_queue(),^{OMCTry(retry+1);});
        return;
    }
    %init(OMCSoloNative);
    OMCSoloInstalled=YES;
    NSLog(@"[OmniCarSoloDots] source stage installed (NO DEB built)");
}
%ctor{
    @autoreleasepool{
        NSString *bundle=NSBundle.mainBundle.bundleIdentifier.lowercaseString?:@"";
        if([bundle isEqualToString:@"com.apple.carplayapp"]||
           [bundle isEqualToString:@"com.apple.springboard"])
            dispatch_async(dispatch_get_main_queue(),^{OMCTry(0);});
    }
}
