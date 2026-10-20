// OmniCar native ratio MENU REPLACEMENT — source-only candidate for ONE upgraded base DEB.
// Preserve the original capsule and touch region. Replace 3 presets with Zoom + Swap.
// Former under-knob Zoom is retired. Original divider pan and pane/host owners retained.
// Not packaged or tested on a real CarPlay scene.
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <objc/runtime.h>
#import <math.h>
#import <QuartzCore/QuartzCore.h>
extern void OMCChromeSetHidden(BOOL hidden);

@interface SCPCarSplit : NSObject
- (BOOL)active;
- (UIView *)container;
- (UIView *)ratioMenu;
- (CGRect)appAreaInParent:(UIView *)parent;
- (void)relayoutAnimated:(BOOL)animated pushScenes:(BOOL)pushScenes;
- (void)rootDidLayout;
- (void)showRatioMenuForDivider:(id)divider;
- (void)hideRatioMenu;
- (void)dividerDoubleTapped:(id)recognizer;
- (void)dividerDoubleTapOn:(id)divider;
@end

@interface OMCZoomState : NSObject
@property(nonatomic) BOOL expanded;
@property(nonatomic, weak) UIView *layoutParent;
@property(nonatomic) BOOL previousClipsToBounds;
@property(nonatomic) CGRect originalArea;
@property(nonatomic, strong) UIButton *button;
@property(nonatomic, weak) UIView *menu;
@property(nonatomic, strong) UIButton *swapButton;
@property(nonatomic, strong) UIView *menuCover;
@property(nonatomic, weak) id nativeDivider;
@property(nonatomic, strong) NSMapTable<UIView *,NSNumber *> *oldSubviewHidden;
@property(nonatomic, strong) NSMapTable<UIGestureRecognizer *,NSNumber *> *oldMenuGestures;
@end
@implementation OMCZoomState @end
static char kOMCStateKey;
static BOOL OMCInstalled=NO;

static OMCZoomState *OMCState(SCPCarSplit *split) {
    OMCZoomState *state=objc_getAssociatedObject(split,&kOMCStateKey);
    if (!state) {
        state=[OMCZoomState new];
        objc_setAssociatedObject(split,&kOMCStateKey,state,OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return state;
}
static BOOL OMCAreaValid(CGRect rect) {
    return isfinite(rect.origin.x) && isfinite(rect.origin.y) &&
        isfinite(rect.size.width) && isfinite(rect.size.height) &&
        rect.size.width>50.0 && rect.size.height>50.0;
}
static CGRect OMCWindowBoundsInParent(UIView *parent) {
    UIWindow *window=parent.window;
    return window ? [parent convertRect:window.bounds fromView:window] : CGRectNull;
}
static UIImage *OMCZoomGlyph(BOOL expanded) {
    // Crisp vector arrows: no dependency on SF Symbols available on the device.
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(20.0,20.0),NO,0.0);
    CGContextRef ctx=UIGraphicsGetCurrentContext();
    CGContextSetStrokeColorWithColor(ctx,
        [UIColor colorWithRed:.09 green:.32 blue:.76 alpha:1.0].CGColor);
    CGContextSetLineWidth(ctx,2.0);
    CGContextSetLineCap(ctx,kCGLineCapRound);
    CGContextSetLineJoin(ctx,kCGLineJoinRound);
    if (!expanded) {
        CGContextMoveToPoint(ctx,8,8); CGContextAddLineToPoint(ctx,3,3);
        CGContextMoveToPoint(ctx,3,7); CGContextAddLineToPoint(ctx,3,3); CGContextAddLineToPoint(ctx,7,3);
        CGContextMoveToPoint(ctx,12,12); CGContextAddLineToPoint(ctx,17,17);
        CGContextMoveToPoint(ctx,13,17); CGContextAddLineToPoint(ctx,17,17); CGContextAddLineToPoint(ctx,17,13);
    } else {
        CGContextMoveToPoint(ctx,3,3); CGContextAddLineToPoint(ctx,8,8);
        CGContextMoveToPoint(ctx,4,8); CGContextAddLineToPoint(ctx,8,8); CGContextAddLineToPoint(ctx,8,4);
        CGContextMoveToPoint(ctx,17,17); CGContextAddLineToPoint(ctx,12,12);
        CGContextMoveToPoint(ctx,16,12); CGContextAddLineToPoint(ctx,12,12); CGContextAddLineToPoint(ctx,12,16);
    }
    CGContextStrokePath(ctx);
    UIImage *icon=UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return [icon imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
}
static void OMCRefreshButton(OMCZoomState *state) {
    UIButton *b=state.button;
    if (!b) return;
    [b setImage:OMCZoomGlyph(state.expanded) forState:UIControlStateNormal];
    b.accessibilityLabel=state.expanded?@"Thu nhỏ":@"Phóng to";
    b.accessibilityHint=@"Chạm để phóng to hoặc thu nhỏ toàn bộ giao diện OmniCar";
}
static void OMCToggleHost(SCPCarSplit *split) {
    if (!split || ![split active]) {
        NSLog(@"[OmniCarZoom] event=skip reason=inactive");
        return;
    }
    UIView *container=[split container];
    UIView *parent=container.superview;
    if (!parent || !parent.window) {
        NSLog(@"[OmniCarZoom] event=skip reason=host-unavailable");
        return;
    }
    OMCZoomState *state=OMCState(split);
    if (!state.expanded) {
        CGRect original=[split appAreaInParent:parent];
        CGRect target=OMCWindowBoundsInParent(parent);
        if (!OMCAreaValid(original) || !OMCAreaValid(target)) {
            NSLog(@"[OmniCarZoom] event=skip reason=invalid-rect original=%@ target=%@",
                  NSStringFromCGRect(original),NSStringFromCGRect(target));
            return;
        }
        state.layoutParent=parent;
        state.previousClipsToBounds=parent.clipsToBounds;
        state.originalArea=original;
        state.expanded=YES;
        parent.clipsToBounds=NO;
        [split relayoutAnimated:NO pushScenes:YES];
        [split rootDidLayout];
        OMCChromeSetHidden(YES);
        NSLog(@"[OmniCarZoom] event=expand-request original=%@ full=%@ result=%@",
              NSStringFromCGRect(original),NSStringFromCGRect(target),
              NSStringFromCGRect(container.frame));
    } else {
        UIView *owner=state.layoutParent;
        state.expanded=NO;
        if (owner) owner.clipsToBounds=state.previousClipsToBounds;
        state.layoutParent=nil;
        [split relayoutAnimated:NO pushScenes:YES];
        [split rootDidLayout];
        OMCChromeSetHidden(NO);
        NSLog(@"[OmniCarZoom] event=restore-request baseline=%@ result=%@",
              NSStringFromCGRect(state.originalArea),NSStringFromCGRect(container.frame));
    }
    OMCRefreshButton(state);
}


@interface OMCZoomAction : NSObject
@property(nonatomic, weak) SCPCarSplit *split;
- (void)pressed:(UIButton *)sender;
@end
@implementation OMCZoomAction
- (void)pressed:(UIButton *)sender {
    (void)sender;
    NSLog(@"[OmniCarMenu2] event=zoom-pressed");
    OMCToggleHost(self.split);
}
@end

// Only the original double-tap callback is retired. Its implementation is
// kept available for a guarded invocation from the new Swap icon.
static BOOL OMCButtonOriginatedSwap=NO;
static BOOL OMCInNativeSwap=NO;

static UITapGestureRecognizer *OMCOriginalDoubleTap(id divider) {
    if (![divider isKindOfClass:UIView.class]) return nil;
    UIView *view=(UIView *)divider;
    NSMutableArray<UIView *> *targets=[NSMutableArray arrayWithObject:view];
    if ([divider respondsToSelector:@selector(knob)]) {
        id knob=[divider performSelector:@selector(knob)];
        if ([knob isKindOfClass:UIView.class]) [targets addObject:knob];
    }
    for (UIView *v in targets) {
        for (UIGestureRecognizer *candidate in v.gestureRecognizers) {
            if ([candidate isKindOfClass:UITapGestureRecognizer.class] &&
                ((UITapGestureRecognizer *)candidate).numberOfTapsRequired==2)
                return (UITapGestureRecognizer *)candidate;
        }
    }
    return nil;
}
static BOOL OMCSwapUsingNativeCallback(SCPCarSplit *split,id divider) {
    if (!split || !divider || ![split active]) {
        NSLog(@"[OmniCarMenu2] event=swap-blocked reason=inactive-or-no-divider");
        return NO;
    }
    // The original internal swap implementation is
    // SCPCarSplit -dividerDoubleTapOn: (ARM64 IMP 0x2e73c).
    // Only call when this OS build exposes one object argument and the
    // candidate is a verified native divider. No guessed primitive ABI.
    Class cls=NSClassFromString(@"SCPCarDividerView");
    NSMethodSignature *internal=[split methodSignatureForSelector:@selector(dividerDoubleTapOn:)];
    if (cls && [divider isKindOfClass:cls] &&
        internal && internal.numberOfArguments==3 &&
        internal.methodReturnType[0]=='v' &&
        [internal getArgumentTypeAtIndex:2][0]=='@') {
        OMCZoomState *zoom=OMCState(split);
        BOOL wasExpanded=zoom.expanded;
        OMCInNativeSwap=YES;
        @try {
            // Run ORIGINAL rearrangement against ORIGINAL, non-fullscreen
            // geometry: appAreaInParent: returns native layout during swap.
            [split dividerDoubleTapOn:divider];
        } @finally {
            OMCInNativeSwap=NO;
        }
        if(wasExpanded) {
            if([split active]) {
                zoom.expanded=YES;
                [split relayoutAnimated:NO pushScenes:YES];
                [split rootDidLayout];
                OMCChromeSetHidden(YES);
                // Original swap may enqueue its own deferred layout pass.
                __weak SCPCarSplit *weakSplit=split;
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW,200*NSEC_PER_MSEC),
                               dispatch_get_main_queue(), ^{
                    SCPCarSplit *strongSplit=weakSplit;
                    if(strongSplit && [strongSplit active] &&
                       OMCState(strongSplit).expanded) {
                        [strongSplit relayoutAnimated:NO pushScenes:YES];
                        [strongSplit rootDidLayout];
                        OMCChromeSetHidden(YES);
                    }
                });
            } else {
                zoom.expanded=NO;
                OMCChromeSetHidden(NO);
                NSLog(@"[OmniCarMenu2] event=swap-ended-inactive cannot-keep-fullscreen");
            }
        }
        NSLog(@"[OmniCarMenu2] event=internal-native-swap-requested wasFullscreen=%d remainsFullscreen=%d",
              wasExpanded,zoom.expanded);
        return YES;
    }
    NSLog(@"[OmniCarMenu2] event=internal-swap-unavailable; fallback-to-original-recognizer");
    // The original ABI for dividerDoubleTapped: is the *gesture callback*,
    // NOT the unverified dividerDoubleTapOn: internal helper signature.
    SEL selector=@selector(dividerDoubleTapped:);
    NSMethodSignature *sig=[split methodSignatureForSelector:selector];
    if (!sig || sig.numberOfArguments!=3 || sig.methodReturnType[0]!='v' ||
        [sig getArgumentTypeAtIndex:2][0]!='@') {
        NSLog(@"[OmniCarMenu2] event=swap-blocked reason=unverified-abi");
        return NO;
    }
    UITapGestureRecognizer *native=OMCOriginalDoubleTap(divider);
    if (!native) {
        NSLog(@"[OmniCarMenu2] event=swap-blocked reason=native-doubletap-missing");
        return NO;
    }
    OMCButtonOriginatedSwap=YES;
    @try {
        [split dividerDoubleTapped:native];
    } @finally {
        OMCButtonOriginatedSwap=NO;
    }
    NSLog(@"[OmniCarMenu2] event=native-swap-dispatched device-outcome-unverified");
    return YES;
}
@interface OMCSwapAction : NSObject
@property(nonatomic, weak) SCPCarSplit *split;
@property(nonatomic, weak) id divider;
- (void)pressed:(UIButton *)sender;
@end
@implementation OMCSwapAction
- (void)pressed:(UIButton *)sender {
    (void)sender;
    (void)OMCSwapUsingNativeCallback(self.split,self.divider);
}
@end

static UIImage *OMCSwapGlyph(void) {
    // Two counter-directional arrows, not another ratio/split pictogram.
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(24,24),NO,0.0);
    CGContextRef c=UIGraphicsGetCurrentContext();
    CGContextSetStrokeColorWithColor(c,[UIColor colorWithRed:.73 green:.90 blue:.96 alpha:1].CGColor);
    CGContextSetLineWidth(c,2.0);
    CGContextSetLineCap(c,kCGLineCapRound);
    CGContextSetLineJoin(c,kCGLineJoinRound);
    CGContextMoveToPoint(c,4,8); CGContextAddLineToPoint(c,20,8);
    CGContextMoveToPoint(c,15,4); CGContextAddLineToPoint(c,20,8); CGContextAddLineToPoint(c,15,12);
    CGContextMoveToPoint(c,20,16); CGContextAddLineToPoint(c,4,16);
    CGContextMoveToPoint(c,9,12); CGContextAddLineToPoint(c,4,16); CGContextAddLineToPoint(c,9,20);
    CGContextStrokePath(c);
    UIImage *img=UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return [img imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
}

static void OMCHideMenuControls(SCPCarSplit *split) {
    OMCZoomState *state=objc_getAssociatedObject(split,&kOMCStateKey);
    if (!state) return;
    // Restore exactly what the native menu already owned before a later show.
    for (UIView *view in state.oldSubviewHidden.keyEnumerator) {
        NSNumber *before=[state.oldSubviewHidden objectForKey:view];
        if (before) view.hidden=before.boolValue;
    }
    for (UIGestureRecognizer *gesture in state.oldMenuGestures.keyEnumerator) {
        NSNumber *before=[state.oldMenuGestures objectForKey:gesture];
        if (before) gesture.enabled=before.boolValue;
    }
    [state.menuCover removeFromSuperview];
    state.menuCover=nil;
    state.button=nil;
    state.swapButton=nil;
    state.oldSubviewHidden=nil;
    state.oldMenuGestures=nil;
    state.menu=nil;
    state.nativeDivider=nil;
}

static void OMCInstallTwoActionMenu(SCPCarSplit *split,id divider) {
    // Native method creates original outer capsule. Never recreate its frame.
    UIView *menu=[split ratioMenu];
    if (![menu isKindOfClass:UIView.class] || !menu.window ||
        CGRectIsEmpty(menu.bounds)) {
        NSLog(@"[OmniCarMenu2] event=menu-unavailable");
        return;
    }
    OMCZoomState *state=OMCState(split);
    OMCHideMenuControls(split); // old panel may have been replaced by native
    state.menu=menu;
    state.nativeDivider=divider;
    // Three native preset icons/targets are suppressed only inside menu.
    // Do NOT alter divider gesture/pan recognizers or host-app touches.
    state.oldSubviewHidden=[NSMapTable weakToStrongObjectsMapTable];
    for (UIView *sub in [menu.subviews copy]) {
        [state.oldSubviewHidden setObject:@(sub.hidden) forKey:sub];
        sub.hidden=YES;
    }
    state.oldMenuGestures=[NSMapTable weakToStrongObjectsMapTable];
    for (UIGestureRecognizer *recognizer in [menu.gestureRecognizers copy]) {
        [state.oldMenuGestures setObject:@(recognizer.enabled) forKey:recognizer];
        recognizer.enabled=NO; // prevent the three original preset hit actions
    }

    // One original capsule, two *equal halves* occupying the SAME hit region.
    // Graphite Titanium inner surface; the original exterior border stays put.
    UIView *cover=[[UIView alloc] initWithFrame:menu.bounds];
    cover.autoresizingMask=UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    cover.backgroundColor=[UIColor colorWithRed:53./255 green:61./255 blue:70./255 alpha:.98];
    cover.layer.cornerRadius=menu.layer.cornerRadius>0
        ?menu.layer.cornerRadius : CGRectGetHeight(menu.bounds)*.5;
    cover.clipsToBounds=YES;
    cover.accessibilityIdentifier=@"OmniCar.menu.two-actions";
    [menu addSubview:cover];
    state.menuCover=cover;
    CGFloat width=CGRectGetWidth(cover.bounds);
    CGFloat height=CGRectGetHeight(cover.bounds);
    if (width<=0 || height<=0) return;

    UIButton *zoom=[UIButton buttonWithType:UIButtonTypeCustom];
    zoom.frame=CGRectMake(0,0,width*.5,height);
    zoom.accessibilityIdentifier=@"OmniCar.menu.zoom";
    zoom.tintColor=[UIColor colorWithRed:.73 green:.90 blue:.96 alpha:1];
    zoom.imageView.contentMode=UIViewContentModeScaleAspectFit;
    zoom.backgroundColor=UIColor.clearColor;
    zoom.exclusiveTouch=YES;
    OMCZoomAction *zoomTarget=[OMCZoomAction new];
    zoomTarget.split=split;
    objc_setAssociatedObject(zoom,@selector(pressed:),zoomTarget,OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [zoom addTarget:zoomTarget action:@selector(pressed:) forControlEvents:UIControlEventTouchUpInside];
    [cover addSubview:zoom];
    state.button=zoom;
    OMCRefreshButton(state);

    UIButton *swap=[UIButton buttonWithType:UIButtonTypeCustom];
    swap.frame=CGRectMake(width*.5,0,width-width*.5,height);
    swap.accessibilityLabel=@"Đổi trái phải";
    swap.accessibilityHint=@"Hoán đổi hai ứng dụng trái và phải";
    swap.accessibilityIdentifier=@"OmniCar.menu.swap";
    swap.backgroundColor=UIColor.clearColor;
    swap.exclusiveTouch=YES;
    swap.imageView.contentMode=UIViewContentModeScaleAspectFit;
    [swap setImage:OMCSwapGlyph() forState:UIControlStateNormal];
    OMCSwapAction *swapTarget=[OMCSwapAction new];
    swapTarget.split=split;
    swapTarget.divider=divider;
    objc_setAssociatedObject(swap,@selector(pressed:),swapTarget,OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [swap addTarget:swapTarget action:@selector(pressed:) forControlEvents:UIControlEventTouchUpInside];
    [cover addSubview:swap];
    state.swapButton=swap;

    CALayer *separator=[CALayer layer];
    separator.frame=CGRectMake(width*.5-.5,height*.23,1,height*.54);
    separator.backgroundColor=[UIColor colorWithRed:.71 green:.74 blue:.77 alpha:.65].CGColor;
    [cover.layer addSublayer:separator];
    NSLog(@"[OmniCarMenu2] event=two-actions-installed bounds=%@ zoom=%@ swap=%@",
          NSStringFromCGRect(menu.bounds),NSStringFromCGRect(zoom.frame),NSStringFromCGRect(swap.frame));
}

%hook SCPCarSplit
- (void)showRatioMenuForDivider:(id)divider {
    OMCHideMenuControls((SCPCarSplit *)self);
    %orig;
    OMCInstallTwoActionMenu((SCPCarSplit *)self,divider);
}
- (void)hideRatioMenu {
    OMCHideMenuControls((SCPCarSplit *)self);
    %orig;
}
// Original THREE native ratio preset callbacks must not execute beneath
// the replacement controls, even if a gesture is mounted on an ancestor
// rather than menu.gestureRecognizers. Leave original callback unchanged
// when custom menu was not successfully mounted.
- (void)ratioPresetTapped:(id)sender {
    OMCZoomState *state=objc_getAssociatedObject(self,&kOMCStateKey);
    if(state.menuCover && state.menuCover.superview==state.menu) {
        NSLog(@"[OmniCarMenu2] event=blocked-original-three-ratio-preset");
        return;
    }
    %orig;
}
// Retire the OLD double-tap gesture path; use its original IMP only when
// the new native-menu Swap icon dispatches with a native recognizer.
- (void)dividerDoubleTapped:(id)recognizer {
    if (!OMCButtonOriginatedSwap) {
        NSLog(@"[OmniCarMenu2] event=legacy-doubletap-swapping-blocked");
        return;
    }
    %orig;
}
- (void)setActive:(BOOL)active {
    if (!active && !OMCInNativeSwap) {
        OMCZoomState *state=objc_getAssociatedObject(self,&kOMCStateKey);
        if (state && state.expanded) {
            state.expanded=NO;
            if (state.layoutParent)
                state.layoutParent.clipsToBounds=state.previousClipsToBounds;
            state.layoutParent=nil;
            OMCChromeSetHidden(NO);
            NSLog(@"[OmniCarZoom] event=split-deactivate-chrome-restored");
        }
    }
    %orig;
}
- (CGRect)appAreaInParent:(UIView *)parent {
    CGRect native=%orig;
    OMCZoomState *state=objc_getAssociatedObject(self,&kOMCStateKey);
    if (OMCInNativeSwap || !state || !state.expanded || !parent ||
        parent!=state.layoutParent || ![self active]) return native;
    CGRect target=OMCWindowBoundsInParent(parent);
    return OMCAreaValid(target)?target:native;
}
%end

static void OMCTryInstall(NSUInteger retry) {
    if (OMCInstalled) return;
    if (!NSClassFromString(@"SCPCarSplit")) {
        if (retry<30) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW,500*NSEC_PER_MSEC),
                           dispatch_get_main_queue(),^{ OMCTryInstall(retry+1); });
        } else NSLog(@"[OmniCarZoom] event=hook-unavailable");
        return;
    }
    %init;
    OMCInstalled=YES;
    NSLog(@"[OmniCarZoom] event=hook-installed candidate=two-action-menu-source-only");
}
%ctor {
    @autoreleasepool {
        NSString *bid=NSBundle.mainBundle.bundleIdentifier.lowercaseString ?: @"";
        if ([bid isEqualToString:@"com.apple.carplayapp"] ||
            [bid isEqualToString:@"com.apple.springboard"]) {
            dispatch_async(dispatch_get_main_queue(),^{ OMCTryInstall(0); });
        }
    }
}
