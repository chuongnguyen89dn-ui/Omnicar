// OmniCar Double-Tap Full Host Geometry - candidate v0.1
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
static char kOCDTGestureKey;
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

@interface OCDTGesture : NSObject <UIGestureRecognizerDelegate>
@property(nonatomic, weak) SCPCarSplit *split;
- (void)doubleTap:(UITapGestureRecognizer *)recognizer;
@end

@implementation OCDTGesture
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)recognizer shouldReceiveTouch:(UITouch *)touch {
    if (!self.split || ![self.split active]) return NO;
    return OCDTHitKnob(recognizer,[touch locationInView:recognizer.view]);
}
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gesture
 shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)other {
    (void)gesture; (void)other;
    // Do not block OmniCar's single-tap selection / drag recognizers.
    return YES;
}
- (void)doubleTap:(UITapGestureRecognizer *)recognizer {
    if (recognizer.state!=UIGestureRecognizerStateRecognized ||
        !OCDTHitKnob(recognizer,[recognizer locationInView:recognizer.view])) return;
    SCPCarSplit *split=self.split;
    if (!split || ![split active]) return;
    UIView *container=[split container];
    UIView *parent=container.superview;
    if (!parent || !parent.window) {
        NSLog(@"[OmniCarDT] ignored: missing live host");
        return;
    }
    OCDTState *state=OCDTGetState(split);
    if (!state.expanded) {
        CGRect original=[split appAreaInParent:parent];
        CGRect full=OCDTFullArea(parent);
        if (!OCDTRectValid(original) || !OCDTRectValid(full)) {
            NSLog(@"[OmniCarDT] ignored: invalid geometry original=%@ full=%@",
                  NSStringFromCGRect(original),NSStringFromCGRect(full));
            return;
        }
        // Do not attempt to enlarge beyond window bounds based on guessed
        // CarPlay dock dimensions. Always use actual live parent conversion.
        state.baseline=original;
        state.layoutParent=parent;
        state.originalClips=parent.clipsToBounds;
        state.expanded=YES;
        parent.clipsToBounds=NO;
        NSLog(@"[OmniCarDT] enter requested original=%@ full=%@",
              NSStringFromCGRect(original),NSStringFromCGRect(full));
        [split relayoutAnimated:NO pushScenes:YES];
        [split rootDidLayout];
        CGRect actual=container.frame;
        NSLog(@"[OmniCarDT] enter relayout container=%@",NSStringFromCGRect(actual));
    } else {
        UIView *owner=state.layoutParent;
        state.expanded=NO; // Stop the override before native relayout/restore.
        if (owner) owner.clipsToBounds=state.originalClips;
        [split relayoutAnimated:NO pushScenes:YES];
        [split rootDidLayout];
        NSLog(@"[OmniCarDT] restore requested baseline=%@",
              NSStringFromCGRect(state.baseline));
        state.layoutParent=nil;
    }
}
@end

%hook SCPCarSplit

- (id)newDividerAt:(int)index {
    id divider=%orig;
    if (![divider isKindOfClass:NSClassFromString(@"SCPCarDividerView")]) return divider;
    if (objc_getAssociatedObject(divider,&kOCDTGestureKey)) return divider;
    OCDTGesture *action=[OCDTGesture new];
    action.split=(SCPCarSplit *)self;
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc] initWithTarget:action
                                                                       action:@selector(doubleTap:)];
    tap.numberOfTapsRequired=2;
    tap.numberOfTouchesRequired=1;
    tap.cancelsTouchesInView=NO;
    tap.delaysTouchesBegan=NO;
    tap.delaysTouchesEnded=NO;
    tap.delegate=action;
    [(UIView *)divider addGestureRecognizer:tap];
    objc_setAssociatedObject(divider,&kOCDTGestureKey,action,OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    NSLog(@"[OmniCarDT] attached double-tap to divider=%d, knob-only hit area",index);
    return divider;
}

- (CGRect)appAreaInParent:(UIView *)parent {
    CGRect native=%orig;
    OCDTState *state=objc_getAssociatedObject(self,&kOCDTStateKey);
    if (!state || !state.expanded || !parent || parent!=state.layoutParent ||
        ![self active] || ![self container].window) return native;
    CGRect full=OCDTFullArea(parent);
    return OCDTRectValid(full) ? full : native;
}

- (void)dividerDoubleTapped:(UITapGestureRecognizer *)recognizer {
    // The original divider double tap may swap panes.
    // Suppress it ONLY on the circular handle; leave the divider line intact.
    if ([recognizer isKindOfClass:UIGestureRecognizer.class] &&
        OCDTHitKnob(recognizer,[recognizer locationInView:recognizer.view])) {
        NSLog(@"[OmniCarDT] suppress original swap on circular knob");
        return;
    }
    %orig;
}

%end

%ctor {
    @autoreleasepool {
        NSString *bundle=NSBundle.mainBundle.bundleIdentifier.lowercaseString ?: @"";
        BOOL allowed=[bundle isEqualToString:@"com.apple.carplayapp"] ||
                     [bundle isEqualToString:@"com.apple.springboard"];
        if (allowed && NSClassFromString(@"SCPCarSplit") &&
            NSClassFromString(@"SCPCarDividerView")) {
            %init;
            NSLog(@"[OmniCarDT] loaded in %@, geometry candidate v0.1",bundle);
        }
    }
}
