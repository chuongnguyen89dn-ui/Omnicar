// OmniCar 1.0.3: approved native ratio-menu Zoom BELOW the circular knob.
// Independent addon; no existing gesture, divider, layout preset or app picker is replaced.
// Candidate requires testing on the user's real CarPlay head unit.
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
@end

@interface OMCZoomState : NSObject
@property(nonatomic) BOOL expanded;
@property(nonatomic, weak) UIView *layoutParent;
@property(nonatomic) BOOL previousClipsToBounds;
@property(nonatomic) CGRect originalArea;
@property(nonatomic, strong) UIButton *button;
@property(nonatomic, weak) UIView *menu;
@property(nonatomic, weak) UIView *knob;
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
static void OMCRefreshButton(OMCZoomState *state) {
    UIButton *b=state.button;
    if (!b) return;
    NSString *symbol=state.expanded ?
        @"arrow.down.right.and.arrow.up.left" :
        @"arrow.up.left.and.arrow.down.right";
    UIImageSymbolConfiguration *cfg=[UIImageSymbolConfiguration
        configurationWithPointSize:21.0 weight:UIImageSymbolWeightMedium];
    UIImage *image=[UIImage systemImageNamed:symbol withConfiguration:cfg];
    [b setImage:image forState:UIControlStateNormal];
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
    NSLog(@"[OmniCarZoom] event=zoom-button-pressed");
    OMCToggleHost(self.split);
}
@end

static void OMCHideButton(SCPCarSplit *split) {
    OMCZoomState *state=objc_getAssociatedObject(split,&kOMCStateKey);
    [state.button removeFromSuperview];
    state.button=nil;
    state.menu=nil;
    state.knob=nil;
}

// Do not alter the original menu's frame, three tabs, selection logic or callbacks.
// The new button is a separate sibling of the original panel, BELOW the circular knob.
static void OMCShowButton(SCPCarSplit *split, id divider) {
    UIView *menu=[split ratioMenu];
    if (![menu isKindOfClass:UIView.class] || !menu.superview || !menu.window) {
        NSLog(@"[OmniCarZoom] event=menu-unavailable menu=%@",menu);
        return;
    }
    OMCZoomState *state=OMCState(split);
    UIView *parent=menu.superview;
    CGRect menuRect=[parent convertRect:menu.bounds fromView:menu];
    if (CGRectIsEmpty(menuRect)) return;

    // 0.3 REGRESSION: SCPCarSplit.ratioKnob was NOT the blue/white circle
    // below the native three-choice selector. It returned a different
    // handle over the map, moving the Zoom button far from its approved spot.
    // The native selector panel center is the reliable anchor.
    CGFloat nativeHeight=CGRectGetHeight(menuRect);
    CGFloat diameter=MAX(46.0,MIN(62.0,nativeHeight*0.70));
    CGFloat centerX=CGRectGetMidX(menuRect);

    // Prefer the original SCPCarDividerView's circle only if it lies on
    // the axis of the actual selector panel and immediately below it.
    CGRect nativeCircle=CGRectNull;
    if ([divider isKindOfClass:UIView.class] &&
        [divider respondsToSelector:@selector(knob)]) {
        UIView *candidate=[(id)divider knob];
        if ([candidate isKindOfClass:UIView.class] && candidate.window) {
            CGRect rect=[parent convertRect:candidate.bounds fromView:candidate];
            if (fabs(CGRectGetMidX(rect)-centerX)<MIN(36.0,nativeHeight*.5) &&
                CGRectGetMinY(rect)>=CGRectGetMaxY(menuRect)-nativeHeight*.3 &&
                CGRectGetMinY(rect)<CGRectGetMaxY(menuRect)+nativeHeight) {
                nativeCircle=rect;
            }
        }
    }
    // The ratio selector panel and its circular trigger have a fixed
    // visible ordering: panel ABOVE trigger ABOVE our NEW Zoom control.
    CGFloat circleBottom=CGRectIsNull(nativeCircle)
        ?CGRectGetMaxY(menuRect)+12.0+MIN(52.0,nativeHeight*.55)
        :CGRectGetMaxY(nativeCircle);
    CGRect frame=CGRectMake(centerX-diameter/2.0,
                            circleBottom+12.0,diameter,diameter);
    NSLog(@"[OmniCarZoom] event=anchor-check menu=%@ circle=%@ proposed=%@",
          NSStringFromCGRect(menuRect),NSStringFromCGRect(nativeCircle),
          NSStringFromCGRect(frame));
    if (!OMCAreaValid(menuRect)) return;
    if (CGRectGetMaxY(frame)>CGRectGetHeight(parent.bounds)-2.0) {
        NSLog(@"[OmniCarZoom] event=not-enough-space frame=%@ parent=%@",
              NSStringFromCGRect(frame),NSStringFromCGRect(parent.bounds));
        return;
    }
    if (!state.button) {
        UIButton *b=[UIButton buttonWithType:UIButtonTypeCustom];
        OMCZoomAction *action=[OMCZoomAction new];
        action.split=split;
        objc_setAssociatedObject(b,@selector(pressed:),action,OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        [b addTarget:action action:@selector(pressed:) forControlEvents:UIControlEventTouchUpInside];
        b.clipsToBounds=YES;
        state.button=b;
    }
    UIButton *button=state.button;
    button.frame=frame;
    button.layer.cornerRadius=diameter/2.0;
    // Match the original selector's pale lavender-to-cyan material instead
    // of the 0.3 blue solid-circle regression. No changes to native panel.
    button.layer.borderWidth=1.5;
    button.layer.borderColor=[UIColor colorWithWhite:1 alpha:.9].CGColor;
    button.backgroundColor=[UIColor colorWithRed:.86 green:.89 blue:1 alpha:.88];
    CAGradientLayer *fill=objc_getAssociatedObject(button,@selector(OMCRefreshButton:));
    if (!fill) {
        fill=[CAGradientLayer layer];
        fill.colors=@[(__bridge id)[UIColor colorWithRed:.96 green:.89 blue:1 alpha:.95].CGColor,
                      (__bridge id)[UIColor colorWithRed:.67 green:.92 blue:1 alpha:.95].CGColor];
        fill.startPoint=CGPointMake(0,0);
        fill.endPoint=CGPointMake(1,1);
        [button.layer insertSublayer:fill atIndex:0];
        objc_setAssociatedObject(button,@selector(OMCRefreshButton:),fill,OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    fill.frame=button.bounds;
    fill.cornerRadius=diameter/2.0;
    button.tintColor=[UIColor colorWithRed:.10 green:.32 blue:.80 alpha:1];
    OMCRefreshButton(state);
    if (button.superview!=parent) {
        [button removeFromSuperview];
        [parent addSubview:button];
    }
    [parent bringSubviewToFront:button];
    state.menu=menu;
    state.knob=nil;
    NSLog(@"[OmniCarZoom] event=button-installed frame=%@ menu=%@ nativeCircle=%@",
          NSStringFromCGRect(frame),NSStringFromCGRect(menuRect),NSStringFromCGRect(nativeCircle));
}

%hook SCPCarSplit
- (void)showRatioMenuForDivider:(id)divider {
    %orig;
    OMCShowButton((SCPCarSplit *)self,divider);
}
- (void)hideRatioMenu {
    OMCHideButton((SCPCarSplit *)self);
    %orig;
}
- (void)setActive:(BOOL)active {
    if (!active) {
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
    if (!state || !state.expanded || !parent ||
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
    NSLog(@"[OmniCarZoom] event=hook-installed version=0.4.0");
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
