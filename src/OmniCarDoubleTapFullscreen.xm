// OmniCar Double-Tap Full Host Geometry - candidate v0.2
// Scope: only the circular knob of SCPCarDividerView.
// Runs next to OmniCar 1.0.3; does NOT modify its original binaries.
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <objc/runtime.h>
#import <math.h>

@interface SCPCarDividerView : UIView
- (UIView *)knob;
@end

@interface SCPCarSplit : NSObject
- (BOOL)active;
- (UIView *)container;
- (CGRect)appAreaInParent:(UIView *)parent;
- (void)relayoutAnimated:(BOOL)animated pushScenes:(BOOL)pushScenes;
- (void)rootDidLayout;
@end

@interface OCDTState : NSObject
@property(nonatomic, assign) BOOL expanded;
@property(nonatomic, weak) UIView *layoutParent;
@property(nonatomic, assign) BOOL originalClips;
@property(nonatomic, assign) CGRect baseline;
@end
@implementation OCDTState @end

static char kOCDTStateKey;
// Reuse the original OmniCar divider's built-in double-tap recognizer.
static BOOL OCDTRectValid(CGRect r) {
    return isfinite(r.origin.x) && isfinite(r.origin.y) &&
        isfinite(r.size.width) && isfinite(r.size.height) &&
        r.size.width > 50.0 && r.size.height > 50.0;
}
static OCDTState *OCDTGetState(SCPCarSplit *split) {
    OCDTState *state=objc_getAssociatedObject(split,&kOCDTStateKey);
    if (!state) {
        state=[OCDTState new];
        objc_setAssociatedObject(split,&kOCDTStateKey,state,OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return state;
}
static BOOL OCDTHitKnob(UIGestureRecognizer *recognizer, CGPoint p) {
    UIView *divider=recognizer.view;
    if (![divider isKindOfClass:NSClassFromString(@"SCPCarDividerView")]) return NO;
    UIView *knob=[(SCPCarDividerView *)divider knob];
    if (![knob isKindOfClass:UIView.class] || knob.hidden || knob.alpha<0.05 ||
        CGRectIsEmpty(knob.bounds)) return NO;
    CGRect rect=[divider convertRect:knob.bounds fromView:knob];
    return CGRectContainsPoint(CGRectInset(rect,-9.0,-9.0),p);
}
static CGRect OCDTFullArea(UIView *parent) {
    UIWindow *window=parent.window;
    if (!window) return CGRectNull;
    // The app area is in parent coordinates, not window coordinates.
    return [parent convertRect:window.bounds fromView:window];
}


static void OCDTPerformFullscreenToggle(SCPCarSplit *split) {
    if (!split || ![split active]) {
        NSLog(@"[OmniCarDT] event=skip reason=split-inactive");
        return;
    }
    UIView *container=[split container];
    UIView *parent=container.superview;
    if (!parent || !parent.window) {
        NSLog(@"[OmniCarDT] event=skip reason=missing-live-host");
        return;
    }
    OCDTState *state=OCDTGetState(split);
    if (!state.expanded) {
        CGRect native=[split appAreaInParent:parent];
        CGRect full=OCDTFullArea(parent);
        if (!OCDTRectValid(native) || !OCDTRectValid(full)) {
            NSLog(@"[OmniCarDT] event=skip reason=invalid-area native=%@ full=%@",
                  NSStringFromCGRect(native),NSStringFromCGRect(full));
            return;
        }
        state.baseline=native;
        state.layoutParent=parent;
        state.originalClips=parent.clipsToBounds;
        state.expanded=YES;
        parent.clipsToBounds=NO;
        NSLog(@"[OmniCarDT] event=enter-request native=%@ full=%@",
              NSStringFromCGRect(native),NSStringFromCGRect(full));
        [split relayoutAnimated:NO pushScenes:YES];
        [split rootDidLayout];
        NSLog(@"[OmniCarDT] event=enter-layout container=%@ expanded=%d",
              NSStringFromCGRect(container.frame),state.expanded);
    } else {
        UIView *owner=state.layoutParent;
        state.expanded=NO;
        if (owner) owner.clipsToBounds=state.originalClips;
        [split relayoutAnimated:NO pushScenes:YES];
        [split rootDidLayout];
        NSLog(@"[OmniCarDT] event=restore-layout baseline=%@ container=%@",
              NSStringFromCGRect(state.baseline),NSStringFromCGRect(container.frame));
        state.layoutParent=nil;
    }
}

%hook SCPCarSplit

- (CGRect)appAreaInParent:(UIView *)parent {
    CGRect native=%orig;
    OCDTState *state=objc_getAssociatedObject(self,&kOCDTStateKey);
    if (!state || !state.expanded || !parent || parent!=state.layoutParent ||
        ![self active] || ![self container].window) return native;
    CGRect full=OCDTFullArea(parent);
    return OCDTRectValid(full) ? full : native;
}

- (void)dividerDoubleTapped:(UITapGestureRecognizer *)recognizer {
    // OmniCar 1.0.3 already installs a 2-tap UIGestureRecognizer here.
    // Route ONLY its circular knob to host expand/restore.
    // The original double-tap elsewhere continues to swap adjacent panes.
    if ([recognizer isKindOfClass:UITapGestureRecognizer.class]) {
        CGPoint point=[recognizer locationInView:recognizer.view];
        BOOL knob=OCDTHitKnob(recognizer,point);
        NSLog(@"[OmniCarDT] event=native-doubletap knob=%d class=%@ position=%@",
              knob,NSStringFromClass(recognizer.view.class),
              NSStringFromCGPoint(point));
        if (knob) {
            OCDTPerformFullscreenToggle((SCPCarSplit *)self);
            return;
        }
    }
    %orig;
}

%end

static BOOL OCDTInstalled=NO;
static void OCDTTryInstall(NSUInteger retry) {
    if (OCDTInstalled) return;
    if (!NSClassFromString(@"SCPCarSplit") || !NSClassFromString(@"SCPCarDividerView")) {
        if (retry<20) dispatch_after(dispatch_time(DISPATCH_TIME_NOW,500*NSEC_PER_MSEC),
                                     dispatch_get_main_queue(),^{ OCDTTryInstall(retry+1); });
        else NSLog(@"[OmniCarDT] hooks not installed: OmniCar classes unavailable");
        return;
    }
    %init;
    OCDTInstalled=YES;
    NSLog(@"[OmniCarDT] hooks installed after class load (retry=%lu)",(unsigned long)retry);
}
%ctor {
    @autoreleasepool {
        NSString *bundle=NSBundle.mainBundle.bundleIdentifier.lowercaseString ?: @"";
        BOOL allowed=[bundle isEqualToString:@"com.apple.carplayapp"] ||
                     [bundle isEqualToString:@"com.apple.springboard"];
        if (allowed) dispatch_async(dispatch_get_main_queue(),^{ OCDTTryInstall(0); });
    }
}
