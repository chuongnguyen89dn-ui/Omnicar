// DuoCar's private, personal-use extension for an unmodified Le 0.2.4.
// Only hook exact vendor classes when their ABI is present. EXPERIMENTAL;
// car/SDK testing is still required; no vendor code is copied here.
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CoreFoundation/CoreFoundation.h>
#import <objc/runtime.h>
#import <objc/message.h>
#import <notify.h>
#import <math.h>
#import <stdlib.h>
#import "../OmniCarLeTraffic/DCLTrafficCore.h"

static NSString *const DCLDomain=@"com.chuong.duocar";
static id (*origContent)(id,SEL,id);
static void (*origFrame)(id,SEL,CGRect);
static void (*origCenter)(id,SEL,CGPoint);
static void (*origMoved)(id,SEL);
static BOOL factoryInstalled=NO, viewInstalled=NO, applying=NO, dragging=NO;
static BOOL hasStored=NO;
static DCLTrafficPoint stored={0.5,0.5};
static char gestureMark;

static id pref(NSString *key) {
    CFStringRef domain=(__bridge CFStringRef)DCLDomain;
    CFPreferencesAppSynchronize(domain);
    return CFBridgingRelease(CFPreferencesCopyAppValue((__bridge CFStringRef)key,domain));
}
static int offset(void) {
    id number=pref(@"leTrafficGpsOffsetKph");
    return DCLTrafficClampGpsOffset([number respondsToSelector:@selector(integerValue)]
                                      ? (int)[number integerValue] : 0);
}
static void loadXY(void) {
    id x=pref(@"leTrafficPositionX"), y=pref(@"leTrafficPositionY");
    if ([x isKindOfClass:NSNumber.class] && [y isKindOfClass:NSNumber.class] &&
        isfinite([x doubleValue]) && isfinite([y doubleValue])) {
        stored=(DCLTrafficPoint){fmax(0,fmin(1,[x doubleValue])),
                                 fmax(0,fmin(1,[y doubleValue]))};
        hasStored=YES;
    }
}
static void saveXY(DCLTrafficPoint point) {
    if (!isfinite(point.x) || !isfinite(point.y)) return;
    stored=point;hasStored=YES;
    CFStringRef domain=(__bridge CFStringRef)DCLDomain;
    CFPreferencesSetAppValue(CFSTR("leTrafficPositionX"),
                             (__bridge CFPropertyListRef)@(point.x),domain);
    CFPreferencesSetAppValue(CFSTR("leTrafficPositionY"),
                             (__bridge CFPropertyListRef)@(point.y),domain);
    CFPreferencesAppSynchronize(domain);
    notify_post("com.chuong.duocar/prefschanged");
}
static BOOL getNumber(NSString *text,NSInteger *value) {
    if (![text isKindOfClass:NSString.class] || !text.length || !value) return NO;
    static NSRegularExpression *regex;
    static dispatch_once_t once;
    dispatch_once(&once,^{regex=[NSRegularExpression
        regularExpressionWithPattern:@"[0-9]+" options:0 error:nil];});
    NSArray *all=[regex matchesInString:text options:0
                                  range:NSMakeRange(0,text.length)];
    if (all.count!=1) return NO;
    NSRange range=[(NSTextCheckingResult *)all.firstObject range];
    NSInteger n=[[text substringWithRange:range] integerValue];
    if (n<0 || n>400) return NO;
    *value=n;return YES;
}
// Keep original Le producer, relay, signal, model and renderer. Only adjust
// the moving speed *text* of the completed model; leave limit and all other
// source fields intact. Units remain meaningful for voice/accessibility.
// This does NOT prove the renderer has no separately painted km/h suffix.
static id contentWithSnapshot(id cls,SEL cmd,id snapshot) {
    id value=origContent?origContent(cls,cmd,snapshot):nil;
    if (!value || ![value respondsToSelector:@selector(speedText)] ||
        ![value respondsToSelector:@selector(setSpeedText:)]) return value;
    NSString *text=((id(*)(id,SEL))objc_msgSend)(value,@selector(speedText));
    NSInteger raw;
    if (!getNumber(text,&raw)) return value;
    NSInteger adjusted=MAX(0,MIN(400,raw+offset()));
    ((void(*)(id,SEL,id))objc_msgSend)(value,@selector(setSpeedText:),
        [NSString stringWithFormat:@"%ld",(long)adjusted]);
    // Never guess Le's speedState / overspeedExcess ABI. Preserve the
    // original native warnings, limits, road signs and spoken guidance.
    // The calibrated value currently affects the visible moving-speed number
    // ONLY. Before any calibrated alert change, reverse/verify vendor logic.
    return value;
}
static BOOL geometry(UIView *bubble,DCLTrafficRect *bounds,DCLTrafficInsets *safe) {
    if (!bubble.window || !bubble.superview) return NO;
    UIWindow *window=bubble.window;
    CGRect r=window.bounds;
    if (r.size.width<200 || r.size.height<150) return NO;
    if (bubble.superview!=window && bubble.superview.clipsToBounds &&
        (bubble.superview.bounds.size.width<r.size.width-10 ||
         bubble.superview.bounds.size.height<r.size.height-10)) return NO;
    UIEdgeInsets insets=window.safeAreaInsets;
    *bounds=(DCLTrafficRect){r.origin.x,r.origin.y,r.size.width,r.size.height};
    *safe=(DCLTrafficInsets){MAX(0,insets.top),MAX(0,insets.right),
                             MAX(0,insets.bottom),MAX(0,insets.left)};
    return YES;
}
static void applyXY(UIView *bubble) {
    if (!hasStored || applying || dragging ||
        ![(pref(@"leTrafficFreeDrag")?:@YES) boolValue]) return;
    DCLTrafficRect screen;DCLTrafficInsets safe;
    if (!geometry(bubble,&screen,&safe)) return;
    DCLTrafficPoint point;
    if (!DCLTrafficRestoreCenter(screen,safe,bubble.bounds.size.width,
        bubble.bounds.size.height,9.0,stored,&point)) return;
    CGPoint actual=[bubble.superview convertPoint:CGPointMake(point.x,point.y)
                                        fromView:bubble.window];
    if (hypot(actual.x-bubble.center.x,actual.y-bubble.center.y)<0.8) return;
    applying=YES;
    if (origCenter) origCenter(bubble,@selector(setCenter:),actual);
    applying=NO;
}
@interface DCLLePan : NSObject <UIGestureRecognizerDelegate>
+ (instancetype)shared;
- (void)drag:(UIPanGestureRecognizer *)recognizer;
@end
@implementation DCLLePan
+ (instancetype)shared {static DCLLePan *one;static dispatch_once_t once;
    dispatch_once(&once,^{one=[DCLLePan new];});return one;}
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)a
 shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)other {
    (void)a;(void)other;return YES;
}
- (void)drag:(UIPanGestureRecognizer *)g {
    UIView *v=g.view;
    if (!v.superview || ![(pref(@"leTrafficFreeDrag")?:@YES) boolValue]) return;
    DCLTrafficRect screen;DCLTrafficInsets safe;
    if (!geometry(v,&screen,&safe)) return;
    if (g.state==UIGestureRecognizerStateBegan) dragging=YES;
    if (g.state==UIGestureRecognizerStateChanged) {
        CGPoint delta=[g translationInView:v.superview];
        CGPoint p=CGPointMake(v.center.x+delta.x,v.center.y+delta.y);
        CGPoint w=[v.superview convertPoint:p toView:v.window];
        DCLTrafficPoint bounded;
        if (DCLTrafficClampCenter(screen,safe,v.bounds.size.width,
            v.bounds.size.height,9.0,(DCLTrafficPoint){w.x,w.y},&bounded)) {
            v.center=[v.superview convertPoint:CGPointMake(bounded.x,bounded.y)
                                     fromView:v.window];
        }
        [g setTranslation:CGPointZero inView:v.superview];
    }
    if (g.state==UIGestureRecognizerStateEnded ||
        g.state==UIGestureRecognizerStateCancelled ||
        g.state==UIGestureRecognizerStateFailed) {
        CGPoint w=[v.superview convertPoint:v.center toView:v.window];
        DCLTrafficPoint normalized;
        if (DCLTrafficNormalizeCenter(screen,safe,v.bounds.size.width,
            v.bounds.size.height,9.0,(DCLTrafficPoint){w.x,w.y},&normalized)) {
            saveXY(normalized);
            NSLog(@"[le024-ext] free-drag x=%.3f y=%.3f",normalized.x,normalized.y);
        }
        dragging=NO;
        applyXY(v);
    }
}
@end
static void attachPan(UIView *view) {
    if (!view.window || objc_getAssociatedObject(view,&gestureMark)) return;
    UIPanGestureRecognizer *pan=[[UIPanGestureRecognizer alloc]
                  initWithTarget:[DCLLePan shared] action:@selector(drag:)];
    pan.delegate=[DCLLePan shared];
    pan.maximumNumberOfTouches=1;pan.cancelsTouchesInView=NO;
    [view addGestureRecognizer:pan];
    objc_setAssociatedObject(view,&gestureMark,pan,OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    NSLog(@"[le024-ext] pan attached");
}
static void customFrame(id obj,SEL cmd,CGRect frame) {
    origFrame(obj,cmd,frame);
    if (!applying) {attachPan(obj);applyXY(obj);}
}
static void customCenter(id obj,SEL cmd,CGPoint center) {
    origCenter(obj,cmd,center);
    if (!applying) {attachPan(obj);applyXY(obj);}
}
static void customMove(id obj,SEL cmd) {
    origMoved(obj,cmd);
    if (!applying) {attachPan(obj);applyXY(obj);}
}
static BOOL hookInstance(Class cls,SEL selector,IMP newIMP,IMP *oldIMP) {
    Method m=class_getInstanceMethod(cls,selector);
    if (!m || method_getNumberOfArguments(m)!=
              (selector==@selector(didMoveToWindow)?2:3)) return NO;
    // Prevent a half-completed three-selector installation from re-swizzling
    // a method to itself on the next timer tick (which would recurse).
    if (*oldIMP) return YES;
    IMP previous=method_getImplementation(m);
    if (!previous || previous==newIMP) return NO;
    *oldIMP=previous;
    if (!class_addMethod(cls,selector,newIMP,method_getTypeEncoding(m))) {
        IMP replaced=method_setImplementation(m,newIMP);
        if (replaced!=previous) {
            if (replaced) method_setImplementation(m,replaced);
            *oldIMP=NULL;
            return NO;
        }
    }
    return YES;
}
static void install(void) {
    if (!factoryInstalled) {
        Class klass=NSClassFromString(@"CWTrafficBubbleContent");
        Method m=klass?class_getClassMethod(klass,@selector(contentWithSnapshot:)):NULL;
        if (m && method_getNumberOfArguments(m)==3) {
            char *type=method_copyReturnType(m);
            if (type && type[0]=='@') {
                origContent=(void *)method_getImplementation(m);
                Class meta=object_getClass(klass);
                if (!class_addMethod(meta,@selector(contentWithSnapshot:),
                    (IMP)contentWithSnapshot,method_getTypeEncoding(m)))
                    method_setImplementation(m,(IMP)contentWithSnapshot);
                factoryInstalled=YES;
                NSLog(@"[le024-ext] factory hooked");
            }
            if (type) free(type);
        }
    }
    if (!viewInstalled) {
        Class klass=NSClassFromString(@"CWTrafficBubbleView");
        if (klass && [klass isSubclassOfClass:UIView.class] &&
            class_getInstanceMethod(klass,@selector(setFrame:)) &&
            class_getInstanceMethod(klass,@selector(setCenter:)) &&
            class_getInstanceMethod(klass,@selector(didMoveToWindow))) {
            BOOL a=hookInstance(klass,@selector(setFrame:),
                                (IMP)customFrame,(IMP *)&origFrame);
            BOOL c=hookInstance(klass,@selector(setCenter:),
                                (IMP)customCenter,(IMP *)&origCenter);
            BOOL w=hookInstance(klass,@selector(didMoveToWindow),
                                (IMP)customMove,(IMP *)&origMoved);
            viewInstalled=a&&c&&w;
            NSLog(@"[le024-ext] view hook frame=%d center=%d move=%d",a,c,w);
        }
    }
}
__attribute__((constructor)) static void DCLLeBootstrap(void) {
    NSString *bundle=NSBundle.mainBundle.bundleIdentifier;
    if (![bundle isEqualToString:@"com.apple.CarPlayApp"] &&
        ![bundle isEqualToString:@"com.apple.springboard"]) return;
    dispatch_async(dispatch_get_main_queue(),^{
        loadXY();
        install();
        // Le and DuoCar injection order is not stable across restarts.
        __block NSUInteger attempts=0;
        NSTimer *timer=[NSTimer timerWithTimeInterval:1 repeats:YES
          block:^(NSTimer *tick){
            install();
            if ((factoryInstalled && viewInstalled) || ++attempts>=90) {
                if (attempts>=90)
                    NSLog(@"[le024-ext] BLIND: original classes not installed");
                [tick invalidate];
            }
        }];
        [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
    });
}
