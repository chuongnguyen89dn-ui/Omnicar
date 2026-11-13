// Fullscreen-only CarPlay clock/battery/thermal bubble.
// HL31 drag, edge snap and persistent position + HL33 dedicated pass-through
// CarPlay UIRootSceneWindow. No voice/microphone module is compiled or reused.
// Unlike the old voice bubble: NO idle timer, NO dim/hide while fullscreen.
// Fullscreen ownership remains exclusively in SCPFullscreenController.
#import "SCPFullscreenVitalsBubble.h"
#import "SCPFullscreenController.h"
#import "SCPCarSplit.h"
#import "SCPVitalsPlacement.h"
#import "OMCDeviceVitals.h"
#import "SCPCommon.h"
#import "SCPShared.h"
#import <QuartzCore/QuartzCore.h>
#import <objc/runtime.h>
#import <objc/message.h>
#import <math.h>

static char DCFVHitTargetAssociation;
static NSString *const DCFVEdgeKey = @"DuoCar.fullscreenVitalsBubble.left";
static NSString *const DCFVYKey = @"DuoCar.fullscreenVitalsBubble.normalizedY";
static const CGFloat DCFVMargin = 9.0;

// HL33's working design: pass ONLY bubble/descendant taps into this window.
// All other touches pass to the original app/Dock/pinch/picker hierarchy.
static UIView *DCFVPassHitTest(UIWindow *window, SEL cmd,
                               CGPoint point, UIEvent *event) {
    struct objc_super sup = {window, class_getSuperclass(object_getClass(window))};
    UIView *hit = ((UIView *(*)(struct objc_super *, SEL, CGPoint, UIEvent *))
                   objc_msgSendSuper)(&sup, cmd, point, event);
    UIView *bubble = objc_getAssociatedObject(window, &DCFVHitTargetAssociation);
    return (bubble && (hit == bubble ||
            (hit && [hit isDescendantOfView:bubble]))) ? hit : nil;
}

// An ordinary UIWindow may bind to the iPhone instead of the CarPlay display.
// Resolve the CarPlay scene exactly as the old HL33 voice bubble did.
static UIWindow *DCFVCreateCarPlayWindow(UIView *parent) {
    UIScreen *screen = parent.window.screen;
    if (!screen) return nil;
    id config = nil;
    SEL cfgSel = NSSelectorFromString(@"displayConfiguration");
    if ([screen respondsToSelector:cfgSel])
        config = ((id (*)(id,SEL))objc_msgSend)(screen,cfgSel);
    if (!config) {
        SEL displaySel = NSSelectorFromString(@"_display");
        id display = [screen respondsToSelector:displaySel]
            ? ((id (*)(id,SEL))objc_msgSend)(screen,displaySel) : nil;
        Class cfgClass = objc_getClass("FBSDisplayConfiguration");
        SEL initSel = NSSelectorFromString(@"initWithCADisplay:isMainDisplay:");
        id fresh = cfgClass ? [cfgClass alloc] : nil;
        if (display && [fresh respondsToSelector:initSel])
            config = ((id (*)(id,SEL,id,BOOL))objc_msgSend)(fresh,
                                                               initSel,display,NO);
    }
    Class root = objc_getClass("UIRootSceneWindow");
    SEL initSel = NSSelectorFromString(@"initWithDisplayConfiguration:");
    id instance = root ? [root alloc] : nil;
    UIWindow *window = nil;
    if (config && [instance respondsToSelector:initSel])
        window = ((id (*)(id,SEL,id))objc_msgSend)(instance,initSel,config);
    if (![window isKindOfClass:UIWindow.class]) {
        OMCLogWrite(@"SplitScreen",
            @"[fs-vitals] overlay create-failed reason=no-CarPlay-root-scene-window");
        return nil;
    }
    Class baseClass = object_getClass(window);
    NSString *name = [NSString stringWithFormat:@"DCFVPass_%@",
                                               NSStringFromClass(baseClass)];
    Class passClass = objc_getClass(name.UTF8String);
    if (!passClass) {
        passClass = objc_allocateClassPair(baseClass,name.UTF8String,0);
        Method base = class_getInstanceMethod(baseClass,
                                               @selector(hitTest:withEvent:));
        if (!passClass || !base ||
            !class_addMethod(passClass,@selector(hitTest:withEvent:),
                             (IMP)DCFVPassHitTest,method_getTypeEncoding(base))) {
            OMCLogWrite(@"SplitScreen",
                @"[fs-vitals] overlay create-failed reason=passthrough-ABI");
            return nil;
        }
        objc_registerClassPair(passClass);
    }
    object_setClass(window,passClass);
    // Hosted TikTok ~1060, picker tray ~1065 in the measured baseline.
    window.windowLevel = UIWindowLevelStatusBar + 64.0;
    window.backgroundColor = UIColor.clearColor;
    window.hidden = NO; // never become key, never grab outside-bubble taps
    OMCLogWrite(@"SplitScreen",[NSString stringWithFormat:
        @"[fs-vitals] overlay ready class=%@ level=%.1f screen=%@ pass=only-bubble",
        NSStringFromClass(window.class),(double)window.windowLevel,screen]);
    return window;
}

@interface SCPFullscreenVitalsBubble ()
@property(nonatomic,weak) UIView *parent;
@property(nonatomic,weak) UIWindow *sourceWindow;
@property(nonatomic,strong) UIWindow *overlayWindow;
@property(nonatomic,strong) UIView *pill;
@property(nonatomic,strong) UILabel *timeLabel;
@property(nonatomic,strong) UILabel *metricsLabel;
@property(nonatomic,strong) UIPanGestureRecognizer *pan;
@property(nonatomic,strong) NSTimer *timer;
@property(nonatomic,strong) NSDateFormatter *clockFormatter;
@property(nonatomic,strong) NSDictionary<NSString *, id> *lastSample;
@property(nonatomic) NSTimeInterval lastSampleTime;
@property(nonatomic) SCPVitalsRect dragBounds;
@property(nonatomic) SCPVitalsSafeInsets dragSafe;
@property(nonatomic) BOOL leftEdge;
@property(nonatomic) CGFloat normalizedY;
@property(nonatomic) BOOL positionSaved;
@property(nonatomic) BOOL dragging;
@property(nonatomic) BOOL noRoomLogged;
@end

@implementation SCPFullscreenVitalsBubble

+ (instancetype)shared {
    static SCPFullscreenVitalsBubble *singleton;
    static dispatch_once_t once;
    dispatch_once(&once, ^{ singleton = [[self alloc] init]; });
    return singleton;
}
- (instancetype)init {
    if ((self = [super init])) {
        NSUserDefaults *store = NSUserDefaults.standardUserDefaults;
        self.positionSaved = ([store objectForKey:DCFVEdgeKey] &&
                              [store objectForKey:DCFVYKey]);
        self.leftEdge = self.positionSaved ? [store boolForKey:DCFVEdgeKey] : NO;
        CGFloat oldY = self.positionSaved ? [store doubleForKey:DCFVYKey] : 0.0;
        self.normalizedY = isfinite(oldY) ? fmax(0.0,fmin(1.0,oldY)) : 0.0;
        NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
        [center addObserver:self selector:@selector(systemClockChanged:)
                      name:NSSystemTimeZoneDidChangeNotification object:nil];
        [center addObserver:self selector:@selector(systemClockChanged:)
                      name:NSCurrentLocaleDidChangeNotification object:nil];
        [center addObserver:self selector:@selector(systemClockChanged:)
                      name:UIApplicationSignificantTimeChangeNotification object:nil];
    }
    return self;
}
- (void)systemClockChanged:(NSNotification *)note {
    (void)note;
    if (![NSThread isMainThread]) {
        dispatch_async(dispatch_get_main_queue(), ^{ [self systemClockChanged:nil]; });
        return;
    }
    self.clockFormatter = nil;
    if (self.pill) [self tick];
}
- (NSDateFormatter *)systemClockFormatter {
    if (!self.clockFormatter) {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.locale = [NSLocale currentLocale];
        formatter.timeZone = [NSTimeZone localTimeZone];
        formatter.dateStyle = NSDateFormatterNoStyle;
        formatter.timeStyle = NSDateFormatterShortStyle;
        self.clockFormatter = formatter;
    }
    return self.clockFormatter;
}
- (void)stop {
    if (![NSThread isMainThread]) {
        dispatch_async(dispatch_get_main_queue(), ^{ [self stop]; });
        return;
    }
    if (self.pill || self.overlayWindow)
        OMCLogWrite(@"SplitScreen",@"[fs-vitals] bubble detached");
    [self.timer invalidate];
    self.timer = nil;
    if (self.pan && self.pill) [self.pill removeGestureRecognizer:self.pan];
    self.pan = nil;
    if (self.overlayWindow)
        objc_setAssociatedObject(self.overlayWindow,&DCFVHitTargetAssociation,
                                 nil,OBJC_ASSOCIATION_ASSIGN);
    [self.pill removeFromSuperview];
    self.pill = nil;
    self.timeLabel = nil;
    self.metricsLabel = nil;
    self.overlayWindow.hidden = YES;
    self.overlayWindow = nil;
    self.sourceWindow = nil;
    self.parent = nil;
    self.lastSample = nil;
    self.lastSampleTime = 0;
    self.dragging = NO;
}
- (BOOL)fullscreenValidForParent:(UIView *)parent {
    SCPCarSplit *split = [SCPCarSplit shared];
    return parent && parent.window && !parent.window.hidden &&
        !parent.hidden && parent.alpha > 0.01 && split.active &&
        split.container.superview == parent &&
        [[SCPFullscreenController shared] fsCommittedState] ==
            SCPFullscreenStateExpanded &&
        [OMCPref(@"duocarFullscreenVitalsEnabled",@YES) boolValue];
}
- (void)tick {
    if (!self.pill || ![self fullscreenValidForParent:self.parent]) {
        [self stop];
        return;
    }
    // Recreate a retired/display-switched CarPlay window, not an iPhone window.
    if (!self.overlayWindow || !self.sourceWindow ||
        self.sourceWindow != self.parent.window ||
        self.overlayWindow.screen != self.sourceWindow.screen ||
        self.overlayWindow.hidden) {
        [self showForConfirmedFullscreenInParent:self.parent];
        if (!self.pill || !self.overlayWindow || self.overlayWindow.hidden)
            return;
    }
    self.pill.alpha = 1.0; // NO idle-dim/AutoHide lease; fullscreen-only gate
    self.timeLabel.text = [[self systemClockFormatter] stringFromDate:[NSDate date]];
    NSTimeInterval now = [NSDate date].timeIntervalSince1970;
    if (!self.lastSample || now - self.lastSampleTime >= 12.0 ||
        now < self.lastSampleTime) {
        self.lastSample = OMCDeviceVitalsSample();
        self.lastSampleTime = now;
        NSNumber *battery = [self.lastSample[@"batteryPercent"] isKindOfClass:NSNumber.class]
            ? self.lastSample[@"batteryPercent"] : nil;
        NSNumber *temperature = [self.lastSample[@"temperatureCelsius"]
                                  isKindOfClass:NSNumber.class]
            ? self.lastSample[@"temperatureCelsius"] : nil;
        NSString *bat = battery
            ? [NSString stringWithFormat:@"%ld%%",(long)battery.integerValue]
            : @"--";
        NSString *heat = temperature
            ? [NSString stringWithFormat:@"~%.0f°C",temperature.doubleValue]
            : OMCDeviceVitalsThermalDescription(self.lastSample[@"thermalState"]);
        self.metricsLabel.text = [NSString stringWithFormat:@"🔋 %@   🌡 %@",bat,heat];
        self.pill.accessibilityLabel = [NSString stringWithFormat:
            @"Giờ %@, pin %@, nhiệt %@. Nguồn nhiệt: %@. Kéo để di chuyển.",
            self.timeLabel.text ?: @"--",bat,heat,
            self.lastSample[@"temperatureSource"] ?: @"không rõ"];
        OMCLogWrite(@"SplitScreen",[NSString stringWithFormat:
            @"[fs-vitals] sample clock=%@ battery=%@ charge=%@ tempC=%@ source=%@ thermal=%@",
            self.timeLabel.text ?: @"--",battery ?: @"unavailable",
            self.lastSample[@"batteryState"] ?: @"unknown",
            temperature ?: @"unavailable",
            self.lastSample[@"temperatureSource"] ?: @"unknown",
            self.lastSample[@"thermalState"] ?: @"unknown"]);
    }
}
// The free-area owner is the overlay's CarPlay window, NOT split.container.
// Its bounds cover native and hosted apps even while they occupy the host.
- (BOOL)updateDragGeometryForOverlay:(UIWindow *)overlay
                          hostWindow:(UIWindow *)host
                           frameSize:(CGSize *)sizeOut {
    if (!host || overlay.screen != host.screen) return NO;
    CGRect mapped = [overlay convertRect:host.bounds fromWindow:host];
    CGRect bounds = CGRectIntersection(mapped,overlay.bounds);
    if (CGRectIsNull(bounds) || CGRectIsInfinite(bounds) ||
        CGRectIsEmpty(bounds) ||
        !isfinite(bounds.origin.x) || !isfinite(bounds.origin.y) ||
        !isfinite(bounds.size.width) || !isfinite(bounds.size.height))
        return NO;
    UIEdgeInsets h = host.safeAreaInsets;
    UIEdgeInsets o = overlay.safeAreaInsets;
    SCPVitalsSafeInsets safe = {MAX(0,MAX(h.top,o.top)),
                                MAX(0,MAX(h.right,o.right)),
                                MAX(0,MAX(h.bottom,o.bottom)),
                                MAX(0,MAX(h.left,o.left))};
    SCPVitalsRect r = {bounds.origin.x,bounds.origin.y,
                       bounds.size.width,bounds.size.height};
    SCPVitalsLayoutResult initial = SCPVitalsFullscreenBubblePlace(
        r,safe.top,safe.right,1);
    if (!initial.valid) return NO;
    // Do not reject a physically usable window just because its LEFT safe
    // inset was not represented by the older top-right C placement API.
    double usableWidth = r.w - safe.left - safe.right - 2.0*DCFVMargin;
    double width = fmin(initial.frame.w,usableWidth);
    if (!isfinite(width) || width < 198.0) return NO;
    SCPVitalsPoint fit = SCPVitalsBubbleEdgeCenter(
        r,safe,width,initial.frame.h,DCFVMargin,NO,0.0);
    if (!isfinite(fit.x) || !isfinite(fit.y)) return NO;
    self.dragBounds = r;
    self.dragSafe = safe;
    if (sizeOut) *sizeOut = CGSizeMake(width,initial.frame.h);
    return YES;
}
- (CGPoint)boundedCenter:(CGPoint)point {
    if (!self.pill) return point;
    SCPVitalsPoint bounded = SCPVitalsBubbleBoundCenter(
        self.dragBounds,self.dragSafe,
        self.pill.bounds.size.width,self.pill.bounds.size.height,
        DCFVMargin,(SCPVitalsPoint){point.x,point.y});
    return (isfinite(bounded.x) && isfinite(bounded.y))
        ? CGPointMake(bounded.x,bounded.y) : self.pill.center;
}
- (CGPoint)storedEdgeCenter {
    SCPVitalsPoint point = SCPVitalsBubbleEdgeCenter(
        self.dragBounds,self.dragSafe,
        self.pill.bounds.size.width,self.pill.bounds.size.height,
        DCFVMargin,self.leftEdge,self.normalizedY);
    return (isfinite(point.x) && isfinite(point.y))
        ? CGPointMake(point.x,point.y) : self.pill.center;
}
- (void)handlePan:(UIPanGestureRecognizer *)gesture {
    if (!self.overlayWindow || !self.pill ||
        ![self fullscreenValidForParent:self.parent]) return;
    switch (gesture.state) {
        case UIGestureRecognizerStateBegan:
            self.dragging = YES;
            [self.pill.layer removeAllAnimations];
            OMCLogWrite(@"SplitScreen",@"[fs-vitals] drag begin");
            break;
        case UIGestureRecognizerStateChanged: {
            CGPoint translation = [gesture translationInView:self.overlayWindow];
            self.pill.center = [self boundedCenter:CGPointMake(
                self.pill.center.x+translation.x,
                self.pill.center.y+translation.y)];
            [gesture setTranslation:CGPointZero inView:self.overlayWindow];
            break;
        }
        case UIGestureRecognizerStateEnded:
        case UIGestureRecognizerStateCancelled:
        case UIGestureRecognizerStateFailed: {
            self.dragging = NO;
            self.leftEdge = SCPVitalsBubbleNearestLeft(self.dragBounds,
                                                        self.pill.center.x);
            double y = SCPVitalsBubbleRelativeY(self.dragBounds,self.dragSafe,
                 self.pill.bounds.size.width,self.pill.bounds.size.height,
                 DCFVMargin,self.pill.center.y);
            if (isfinite(y)) self.normalizedY = (CGFloat)y;
            self.positionSaved = YES;
            NSUserDefaults *store = NSUserDefaults.standardUserDefaults;
            [store setBool:self.leftEdge forKey:DCFVEdgeKey];
            [store setDouble:self.normalizedY forKey:DCFVYKey];
            CGPoint target = [self storedEdgeCenter];
            [UIView animateWithDuration:0.32 delay:0
                usingSpringWithDamping:0.82 initialSpringVelocity:0
                options:UIViewAnimationOptionBeginFromCurrentState
                animations:^{ self.pill.center = target; }
                completion:nil];
            OMCLogWrite(@"SplitScreen",[NSString stringWithFormat:
                @"[fs-vitals] drag snap edge=%@ normalizedY=%.3f center=%@",
                self.leftEdge?@"left":@"right",
                (double)self.normalizedY,NSStringFromCGPoint(target)]);
            break;
        }
        default: break;
    }
}
- (void)showForConfirmedFullscreenInParent:(UIView *)parent {
    if (![NSThread isMainThread]) return;
    if (![self fullscreenValidForParent:parent]) {
        [self stop];
        return;
    }
    UIWindow *host = parent.window;
    if (self.overlayWindow &&
        (self.sourceWindow != host || self.overlayWindow.screen != host.screen)) {
        [self stop]; // disconnect/reconnect, no stale window or stale hit target
    }
    if (!self.overlayWindow) {
        self.overlayWindow = DCFVCreateCarPlayWindow(parent);
        if (!self.overlayWindow) return;
        self.sourceWindow = host;
    }
    CGSize size = CGSizeZero;
    if (![self updateDragGeometryForOverlay:self.overlayWindow
                                 hostWindow:host frameSize:&size]) {
        if (!self.noRoomLogged) {
            OMCLogWrite(@"SplitScreen",[NSString stringWithFormat:
                @"[fs-vitals] no-room overlay=%@ host=%@",
                NSStringFromCGRect(self.overlayWindow.bounds),
                NSStringFromCGRect(host.bounds)]);
            self.noRoomLogged = YES;
        }
        [self stop];
        return;
    }
    self.noRoomLogged = NO;
    BOOL created = (self.pill == nil);
    if (created) {
        UIView *pill = [[UIView alloc] initWithFrame:
            CGRectMake(0,0,size.width,size.height)];
        pill.backgroundColor = [UIColor colorWithWhite:0.07 alpha:0.96];
        pill.layer.cornerRadius = 19.0;
        pill.layer.borderWidth = 0.5;
        pill.layer.borderColor = [UIColor colorWithWhite:1 alpha:0.22].CGColor;
        pill.clipsToBounds = YES;
        pill.userInteractionEnabled = YES; // pan ONLY, unlike old non-touch HUD
        pill.alpha = 1.0;
        pill.isAccessibilityElement = YES;
        pill.accessibilityTraits = UIAccessibilityTraitAdjustable;
        UILabel *clock = [[UILabel alloc] initWithFrame:CGRectZero];
        clock.font = [UIFont monospacedDigitSystemFontOfSize:13.0
                                                    weight:UIFontWeightSemibold];
        clock.textColor = UIColor.whiteColor;
        clock.adjustsFontSizeToFitWidth = YES;
        clock.minimumScaleFactor = 0.67;
        clock.textAlignment = NSTextAlignmentCenter;
        UILabel *metrics = [[UILabel alloc] initWithFrame:CGRectZero];
        metrics.font = [UIFont systemFontOfSize:10.0 weight:UIFontWeightMedium];
        metrics.textColor = UIColor.whiteColor;
        metrics.adjustsFontSizeToFitWidth = YES;
        metrics.minimumScaleFactor = 0.62;
        metrics.textAlignment = NSTextAlignmentCenter;
        [pill addSubview:clock];
        [pill addSubview:metrics];
        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc]
                                       initWithTarget:self action:@selector(handlePan:)];
        pan.maximumNumberOfTouches = 1;
        [pill addGestureRecognizer:pan];
        [self.overlayWindow addSubview:pill];
        self.pill = pill;
        self.timeLabel = clock;
        self.metricsLabel = metrics;
        self.pan = pan;
        self.parent = parent;
        objc_setAssociatedObject(self.overlayWindow,&DCFVHitTargetAssociation,
                                 pill,OBJC_ASSOCIATION_ASSIGN);
        if (self.positionSaved) self.pill.center = [self storedEdgeCenter];
        else {
            // First install matches the previous top-right fullscreen HUD.
            SCPVitalsPoint point = SCPVitalsBubbleEdgeCenter(
                self.dragBounds,self.dragSafe,size.width,size.height,
                DCFVMargin,NO,0.0);
            self.pill.center = CGPointMake(point.x,point.y);
            self.leftEdge = NO;
            self.normalizedY = 0.0;
        }
        self.timer = [NSTimer timerWithTimeInterval:1.0
            target:self selector:@selector(tick) userInfo:nil repeats:YES];
        [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
        OMCLogWrite(@"SplitScreen",[NSString stringWithFormat:
            @"[fs-vitals] bubble attached frame=%@ window=%@ level=%.1f pass=only-bubble dim=disabled",
            NSStringFromCGRect(self.pill.frame),
            NSStringFromClass(self.overlayWindow.class),
            (double)self.overlayWindow.windowLevel]);
    } else {
        self.parent = parent;
        self.pill.bounds = CGRectMake(0,0,size.width,size.height);
        if (self.dragging) self.pill.center = [self boundedCenter:self.pill.center];
        else self.pill.center = [self storedEdgeCenter];
        [self.overlayWindow bringSubviewToFront:self.pill];
    }
    self.overlayWindow.hidden = NO;
    self.pill.alpha = 1.0;
    CGFloat timeWidth = MIN(87.0,floor(size.width*0.37));
    self.timeLabel.frame = CGRectMake(8.0,0.0,timeWidth,size.height);
    self.metricsLabel.frame = CGRectMake(8.0+timeWidth,0.0,
                                           MAX(1.0,size.width-timeWidth-16.0),
                                           size.height);
    if (created) [self tick];
}
@end
