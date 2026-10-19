// OmniCar 1.0.3: approved native ratio-menu Zoom BELOW the circular knob.
// Independent addon; no existing gesture, divider, layout preset or app picker is replaced.
// Candidate requires testing on the user's real CarPlay head unit.
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <objc/runtime.h>
#import <math.h>

@interface SCPCarSplit : NSObject
- (BOOL)active;
- (UIView *)container;
- (UIView *)ratioMenu;
- (UIView *)ratioKnob;
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
    UIView *knob=[split ratioKnob];
    if (![knob isKindOfClass:UIView.class] || !knob.window) {
        if ([divider isKindOfClass:UIView.class] &&
            [divider respondsToSelector:@selector(knob)]) {
            knob=[divider performSelector:@selector(knob)];
        }
    }
    if (![knob isKindOfClass:UIView.class] || !knob.window) {
        NSLog(@"[OmniCarZoom] event=knob-unavailable");
        return;
    }
    UIView *parent=menu.superview;
    CGRect knobBounds=[parent convertRect:knob.bounds fromView:knob];
    if (CGRectIsEmpty(knobBounds)) return;

    // Base control height on the REAL ratio menu rather than arbitrary pixels.
    CGFloat nativeHeight=CGRectGetHeight(menu.bounds);
    CGFloat diameter=MAX(42.0,MIN(62.0,nativeHeight-4.0));
    if (!isfinite(diameter)) return;
    CGRect frame=CGRectMake(CGRectGetMidX(knobBounds)-diameter/2.0,
                            CGRectGetMaxY(knobBounds)+10.0,
                            diameter,diameter);
    if (!OMCAreaValid(CGRectInset(menu.bounds,-80.0,-80.0))) return;
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
    button.layer.borderWidth=menu.layer.borderWidth>0 ? menu.layer.borderWidth : 1.0;
    button.layer.borderColor=menu.layer.borderColor ?: UIColor.whiteColor.CGColor;
    button.backgroundColor=(menu.backgroundColor && CGColorGetAlpha(menu.backgroundColor.CGColor)>0.1) ?
        menu.backgroundColor : [UIColor colorWithRed:0.78 green:0.91 blue:1.0 alpha:0.88];
    button.tintColor=[UIColor colorWithRed:0.05 green:0.35 blue:0.84 alpha:1.0];
    OMCRefreshButton(state);
    if (button.superview!=parent) {
        [button removeFromSuperview];
        [parent addSubview:button];
    }
    [parent bringSubviewToFront:button];
    state.menu=menu;
    state.knob=knob;
    NSLog(@"[OmniCarZoom] event=button-installed frame=%@ menu=%@ knob=%@",
          NSStringFromCGRect(frame),NSStringFromCGRect(menu.frame),NSStringFromCGRect(knobBounds));
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
    NSLog(@"[OmniCarZoom] event=hook-installed version=0.3.0");
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
