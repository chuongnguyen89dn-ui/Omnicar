// DuoCar-owned Le-style traffic overlay, first stage.
// Uses the tested DCLTrafficCore (speed/limit, correction, X/Y geometry).
// This DOES NOT embed or redistribute Le's third-party binaries.
// The full original Le alert/lane art, maps cards, wake supervisor and source
// extractors are not implemented by this stage: do not claim feature parity.
#import "DCLTrafficOverlay.h"
#import "DCLTrafficSampler.h"
#import "DCLTrafficCore.h"
#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import <CoreFoundation/CoreFoundation.h>
#import <objc/runtime.h>
#import <objc/message.h>
#import <math.h>
#import <notify.h>

static char DCLTrafficHitAssociation;
static NSString *const DCLPrefDomain = @"com.chuong.duocar";
static NSString *const DCLXKey = @"leTrafficPositionX";
static NSString *const DCLYKey = @"leTrafficPositionY";
static CGFloat const DCLBubbleMargin = 9.0;

static id DCLPref(NSString *key, id fallback) {
    CFStringRef domain=(__bridge CFStringRef)DCLPrefDomain;
    CFPreferencesAppSynchronize(domain);
    id value=CFBridgingRelease(CFPreferencesCopyAppValue(
        (__bridge CFStringRef)key,domain));
    return value?:fallback;
}
static BOOL DCLPrefSet(NSString *key, id value) {
    CFStringRef domain=(__bridge CFStringRef)DCLPrefDomain;
    CFPreferencesSetAppValue((__bridge CFStringRef)key,
                            (__bridge CFPropertyListRef)value,domain);
    BOOL written=CFPreferencesAppSynchronize(domain);
    if (written) notify_post("com.chuong.duocar/prefschanged");
    return written;
}
static CGFloat DCLLimit(CGFloat x, CGFloat lo, CGFloat hi) {
    return fmax(lo,fmin(hi,x));
}
static UIView *DCLWindowHitTest(UIWindow *window, SEL cmd,
                                CGPoint point, UIEvent *event) {
    struct objc_super sup={window,class_getSuperclass(object_getClass(window))};
    UIView *hit=((UIView *(*)(struct objc_super *,SEL,CGPoint,UIEvent *))
                 objc_msgSendSuper)(&sup,cmd,point,event);
    UIView *bubble=objc_getAssociatedObject(window,&DCLTrafficHitAssociation);
    return bubble && (hit==bubble || (hit && [hit isDescendantOfView:bubble]))
        ? hit : nil;
}
static BOOL DCLMakePassThrough(UIWindow *window) {
    if (!window) return NO;
    Class orig=object_getClass(window);
    NSString *name=[NSString stringWithFormat:@"DCLTrafficPass_%@",
                        NSStringFromClass(orig)];
    Class replacement=objc_getClass(name.UTF8String);
    if (!replacement) {
        replacement=objc_allocateClassPair(orig,name.UTF8String,0);
        Method method=class_getInstanceMethod(orig,@selector(hitTest:withEvent:));
        if (!replacement || !method ||
            !class_addMethod(replacement,@selector(hitTest:withEvent:),
                (IMP)DCLWindowHitTest,method_getTypeEncoding(method))) return NO;
        objc_registerClassPair(replacement);
    }
    object_setClass(window,replacement);
    return YES;
}

@interface DCLTrafficOverlay ()
@property(nonatomic,strong) DCLTrafficSampler *sampler;
@property(nonatomic,strong) NSTimer *pollTimer;
@property(nonatomic,strong) UIWindow *window;
@property(nonatomic,weak) UIWindow *hostWindow;
@property(nonatomic,strong) UIView *card;
@property(nonatomic,strong) UILabel *speedLabel;
@property(nonatomic,strong) UILabel *limitLabel;
@property(nonatomic,strong) UILabel *sourceLabel;
@property(nonatomic,strong) UIView *limitSign;
@property(nonatomic,strong) UIPanGestureRecognizer *pan;
@property(nonatomic) DCLTrafficReading reading;
@property(nonatomic,copy) NSString *providerName;
@property(nonatomic) DCLTrafficRect availableBounds;
@property(nonatomic) DCLTrafficInsets availableSafe;
@property(nonatomic) BOOL visible;
@property(nonatomic) BOOL tracking;
@property(nonatomic) BOOL started;
@end

@implementation DCLTrafficOverlay

+ (instancetype)shared {
    static DCLTrafficOverlay *object;
    static dispatch_once_t once;
    dispatch_once(&once,^{object=[DCLTrafficOverlay new];});
    return object;
}
- (void)start {
    if (!NSThread.isMainThread) {
        dispatch_async(dispatch_get_main_queue(),^{[self start];});
        return;
    }
    if (self.started) return;
    if (![[NSBundle mainBundle].bundleIdentifier isEqualToString:@"com.apple.CarPlayApp"])
        return;
    self.started=YES;
    self.sampler=[DCLTrafficSampler new];
    __weak typeof(self) weakSelf=self;
    [self.sampler startWithCallback:^(DCLTrafficReading reading,NSString *provider) {
        typeof(self) owner=weakSelf;
        if (!owner) return;
        owner.reading=reading;
        owner.providerName=provider;
        [owner update];
    }];
    [[NSNotificationCenter defaultCenter] addObserver:self
        selector:@selector(sceneChanged:)
        name:UISceneDidActivateNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
        selector:@selector(sceneChanged:)
        name:UISceneDidDisconnectNotification object:nil];
    self.pollTimer=[NSTimer timerWithTimeInterval:1.0 target:self
        selector:@selector(update) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:self.pollTimer forMode:NSRunLoopCommonModes];
    [self update];
    NSLog(@"[le024-runtime] started CarPlayApp presentation-only");
}
- (void)sceneChanged:(NSNotification *)note {
    (void)note;
    [self discardWindow];
    [self update];
}
- (void)discardWindow {
    if (self.window) {
        objc_setAssociatedObject(self.window,&DCLTrafficHitAssociation,
                                 nil,OBJC_ASSOCIATION_ASSIGN);
    }
    [self.pan setEnabled:NO];
    [self.card removeFromSuperview];
    self.card=nil;
    self.speedLabel=nil;
    self.limitLabel=nil;
    self.sourceLabel=nil;
    self.limitSign=nil;
    self.pan=nil;
    self.window.hidden=YES;
    self.window=nil;
    self.hostWindow=nil;
    self.visible=NO;
    self.tracking=NO;
}
- (void)stop {
    if (!NSThread.isMainThread) {
        dispatch_async(dispatch_get_main_queue(),^{[self stop];});
        return;
    }
    [self.pollTimer invalidate];self.pollTimer=nil;
    [self.sampler stop];self.sampler=nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self discardWindow];
    self.started=NO;
}
- (UIWindow *)findCarPlayHost {
    UIApplication *app=UIApplication.sharedApplication;
    // Only a scene explicitly advertised as CarPlay is accepted; never
    // accidentally attach an overlay to the iPhone's default UIWindow.
    for (UIScene *scene in app.connectedScenes) {
        if (![scene isKindOfClass:UIWindowScene.class]) continue;
        NSString *role=scene.session.role ?: @"";
        if ([role rangeOfString:@"CarPlay" options:NSCaseInsensitiveSearch].location
            == NSNotFound) continue;
        UIWindowScene *carScene=(UIWindowScene *)scene;
        for (UIWindow *candidate in carScene.windows) {
            if (candidate==self.window || candidate.hidden ||
                !candidate.rootViewController) continue;
            if (candidate.bounds.size.width<200 || candidate.bounds.size.height<150)
                continue;
            return candidate;
        }
    }
    return nil;
}
- (BOOL)attachToHost:(UIWindow *)host {
    if (!host || !host.windowScene) return NO;
    if (self.window && self.hostWindow==host &&
        self.window.windowScene==host.windowScene) return YES;
    [self discardWindow];
    UIWindow *window=[[UIWindow alloc] initWithWindowScene:host.windowScene];
    if (!DCLMakePassThrough(window)) {
        NSLog(@"[le024-runtime] no-window: pass-through ABI not available");
        return NO;
    }
    self.window=window;
    self.hostWindow=host;
    window.frame=host.bounds;
    window.backgroundColor=UIColor.clearColor;
    // Level is relative to visible CarPlay windows, not hardcoded to one
    // particular scene. Do not become key; pass ALL non-bubble taps through.
    CGFloat level=UIWindowLevelStatusBar+65;
    for (UIWindow *other in host.windowScene.windows) {
        if (other!=window && !other.hidden && other.windowLevel<UIWindowLevelAlert+64)
            level=MAX(level,other.windowLevel+1);
    }
    window.windowLevel=level;
    window.hidden=NO;
    [self buildCard];
    NSLog(@"[le024-runtime] CarPlay window attached frame=%@ level=%.0f",
          NSStringFromCGRect(window.bounds),(double)level);
    return YES;
}
- (void)buildCard {
    UIView *card=[[UIView alloc] initWithFrame:CGRectMake(0,0,220,85)];
    card.clipsToBounds=YES;
    card.layer.cornerRadius=18;
    card.layer.borderWidth=1;
    card.layer.borderColor=[UIColor colorWithWhite:1 alpha:0.24].CGColor;
    card.userInteractionEnabled=YES;
    UILabel *speed=[[UILabel alloc] init];
    speed.font=[UIFont monospacedDigitSystemFontOfSize:42
                                           weight:UIFontWeightBold];
    speed.adjustsFontSizeToFitWidth=YES;
    speed.minimumScaleFactor=0.6;
    speed.textAlignment=NSTextAlignmentCenter;
    UILabel *source=[[UILabel alloc] init];
    source.font=[UIFont systemFontOfSize:11 weight:UIFontWeightMedium];
    source.textAlignment=NSTextAlignmentCenter;
    UIView *limit=[[UIView alloc] init];
    limit.layer.borderWidth=3;
    limit.layer.borderColor=UIColor.systemRedColor.CGColor;
    limit.backgroundColor=UIColor.whiteColor;
    limit.layer.cornerRadius=23;
    UILabel *limitText=[[UILabel alloc] init];
    limitText.font=[UIFont monospacedDigitSystemFontOfSize:17
                                               weight:UIFontWeightBold];
    limitText.textAlignment=NSTextAlignmentCenter;
    limitText.textColor=UIColor.blackColor;
    [limit addSubview:limitText];
    [card addSubview:speed];
    [card addSubview:source];
    [card addSubview:limit];
    UIPanGestureRecognizer *pan=[[UIPanGestureRecognizer alloc]
        initWithTarget:self action:@selector(panned:)];
    pan.maximumNumberOfTouches=1;
    [card addGestureRecognizer:pan];
    [self.window addSubview:card];
    objc_setAssociatedObject(self.window,&DCLTrafficHitAssociation,
                             card,OBJC_ASSOCIATION_ASSIGN);
    self.card=card;self.speedLabel=speed;self.limitSign=limit;
    self.limitLabel=limitText;self.sourceLabel=source;self.pan=pan;
}
- (BOOL)updateAvailableGeometry {
    UIWindow *host=self.hostWindow;
    UIWindow *overlay=self.window;
    if (!host || !overlay || host.hidden ||
        host.windowScene!=overlay.windowScene) return NO;
    CGRect mapped=[overlay convertRect:host.bounds fromWindow:host];
    CGRect bounds=CGRectIntersection(mapped,overlay.bounds);
    if (CGRectIsNull(bounds)||CGRectIsEmpty(bounds)||CGRectIsInfinite(bounds))
        return NO;
    UIEdgeInsets h=host.safeAreaInsets,o=overlay.safeAreaInsets;
    self.availableBounds=(DCLTrafficRect){
        bounds.origin.x,bounds.origin.y,bounds.size.width,bounds.size.height};
    self.availableSafe=(DCLTrafficInsets){
        MAX(0,MAX(h.top,o.top)),MAX(0,MAX(h.right,o.right)),
        MAX(0,MAX(h.bottom,o.bottom)),MAX(0,MAX(h.left,o.left))};
    return YES;
}
- (DCLTrafficPoint)positionFromPrefsOrDefaultWithWidth:(double)w
                                                    height:(double)h {
    id x=DCLPref(DCLXKey,nil), y=DCLPref(DCLYKey,nil);
    DCLTrafficPoint normalized={0.12,0.80};
    if ([x isKindOfClass:NSNumber.class] && [y isKindOfClass:NSNumber.class]) {
        normalized.x=[x doubleValue];normalized.y=[y doubleValue];
    }
    DCLTrafficPoint result={NAN,NAN};
    DCLTrafficRestoreCenter(self.availableBounds,self.availableSafe,w,h,
                            DCLBubbleMargin,normalized,&result);
    return result;
}
- (void)moveCardToPoint:(CGPoint)point {
    DCLTrafficPoint bounded;
    BOOL valid=DCLTrafficClampCenter(self.availableBounds,self.availableSafe,
        self.card.bounds.size.width,self.card.bounds.size.height,
        DCLBubbleMargin,(DCLTrafficPoint){point.x,point.y},&bounded);
    if (valid) self.card.center=CGPointMake(bounded.x,bounded.y);
}
- (void)panned:(UIPanGestureRecognizer *)gesture {
    if (![DCLPref(@"leTrafficFreeDrag",@YES) boolValue] ||
        !self.card || !self.window) return;
    switch(gesture.state) {
        case UIGestureRecognizerStateBegan:
            self.tracking=YES;
            [self.card.layer removeAnimationForKey:@"leOverspeed"];
            break;
        case UIGestureRecognizerStateChanged: {
            CGPoint translation=[gesture translationInView:self.window];
            [self moveCardToPoint:CGPointMake(self.card.center.x+translation.x,
                                               self.card.center.y+translation.y)];
            [gesture setTranslation:CGPointZero inView:self.window];
            break;
        }
        case UIGestureRecognizerStateEnded:
        case UIGestureRecognizerStateCancelled:
        case UIGestureRecognizerStateFailed: {
            self.tracking=NO;
            DCLTrafficPoint normalized;
            if (DCLTrafficNormalizeCenter(self.availableBounds,self.availableSafe,
                    self.card.bounds.size.width,self.card.bounds.size.height,
                    DCLBubbleMargin,
                    (DCLTrafficPoint){self.card.center.x,self.card.center.y},
                    &normalized)) {
                // Persist BOTH coordinates: never force an edge/corner snap.
                DCLPrefSet(DCLXKey,@(normalized.x));
                DCLPrefSet(DCLYKey,@(normalized.y));
                NSLog(@"[le024-runtime] free-drag x=%.3f y=%.3f",
                      normalized.x,normalized.y);
            }
            [self render];
            break;
        }
        default:break;
    }
}
- (void)render {
    if (!self.card) return;
    NSString *style=DCLPref(@"leTrafficBackground",@"asphalt");
    CGFloat opacity=DCLLimit([DCLPref(@"leTrafficBackgroundOpacityPercent",@85)
                                doubleValue]/100.,0.,1.);
    BOOL light=[style isEqualToString:@"paint"];
    BOOL bare=[style isEqualToString:@"bare"];
    UIColor *fill=light?UIColor.whiteColor:
        ([style isEqualToString:@"haze"]?
        [UIColor colorWithRed:0.10 green:0.19 blue:0.33 alpha:1]:
        [UIColor colorWithWhite:0.065 alpha:1]);
    self.card.backgroundColor=bare?UIColor.clearColor:
        [fill colorWithAlphaComponent:opacity];
    self.card.layer.borderWidth=bare?0:0.8;
    self.speedLabel.textColor=light?UIColor.blackColor:UIColor.whiteColor;
    self.sourceLabel.textColor=light?UIColor.darkGrayColor:UIColor.lightGrayColor;
    char speed[16];
    if (DCLTrafficFormatSpeedNumber(&_reading,speed,sizeof(speed)))
        self.speedLabel.text=[NSString stringWithUTF8String:speed];
    else self.speedLabel.text=@"--";
    BOOL speedOn=[DCLPref(@"leTrafficModuleSpeed",@YES) boolValue];
    BOOL limitOn=[DCLPref(@"leTrafficModuleLimit",@YES) boolValue];
    BOOL sourceOn=[DCLPref(@"leTrafficModuleSource",@YES) boolValue];
    self.speedLabel.hidden=!speedOn;
    self.limitSign.hidden=!(limitOn && _reading.hasLimit);
    self.sourceLabel.hidden=!sourceOn;
    self.limitLabel.text=_reading.hasLimit?
        [NSString stringWithFormat:@"%d",_reading.postedLimitKph]:@"--";
    self.sourceLabel.text=[self.providerName isEqualToString:@"Le-external"]?
        @"Lề nguồn":@"DuoCar GPS";
    CGFloat w=self.card.bounds.size.width,h=self.card.bounds.size.height;
    CGFloat disk=MIN(46.0,h-18.);
    self.limitSign.frame=CGRectMake(w-disk-10,(h-disk)/2,disk,disk);
    self.limitSign.layer.cornerRadius=disk/2;
    self.limitLabel.frame=self.limitSign.bounds;
    CGFloat speedWidth=self.limitSign.hidden?w-20:w-disk-24;
    self.speedLabel.frame=CGRectMake(8,7,speedWidth,h-28);
    self.sourceLabel.frame=CGRectMake(8,h-25,speedWidth,19);
    // Alert animation is only a visual signal. Posted-limit comparison used
    // the corrected MOVING speed; no influence on the posted limit itself.
    BOOL blink=_reading.overspeed &&
        [DCLPref(@"leTrafficOverspeedBlink",@YES) boolValue];
    if (blink && !self.tracking) {
        if (![self.card.layer animationForKey:@"leOverspeed"]) {
            CABasicAnimation *flash=[CABasicAnimation animationWithKeyPath:@"borderColor"];
            flash.fromValue=(__bridge id)UIColor.systemRedColor.CGColor;
            flash.toValue=(__bridge id)UIColor.whiteColor.CGColor;
            flash.autoreverses=YES;flash.duration=0.5;
            flash.repeatCount=HUGE_VALF;
            [self.card.layer addAnimation:flash forKey:@"leOverspeed"];
        }
    } else [self.card.layer removeAnimationForKey:@"leOverspeed"];
    self.card.isAccessibilityElement=YES;
    self.card.accessibilityLabel=_reading.hasSpeed
       ? [NSString stringWithFormat:@"Tốc độ %d km/h, giới hạn %@",
             _reading.correctedSpeedKph,
             _reading.hasLimit?[NSString stringWithFormat:@"%d",_reading.postedLimitKph]:@"không rõ"]
       : @"Chưa có tốc độ GPS";
}
- (void)update {
    if (!self.started) return;
    if (![DCLPref(@"leTrafficEnabled",@YES) boolValue] ||
        [DCLPref(@"leTrafficPresentation",@"maps-home")
          isEqualToString:@"maps-only"] || !self.reading.hasSpeed) {
        [self discardWindow];
        return;
    }
    UIWindow *host=[self findCarPlayHost];
    if (!host || ![self attachToHost:host] || ![self updateAvailableGeometry]) {
        [self discardWindow];
        return;
    }
    CGFloat scale=DCLLimit([DCLPref(@"leTrafficScalePercent",@100)
                              doubleValue]/100.,0.5,2.0);
    NSString *layout=DCLPref(@"leTrafficArrangement",@"corner");
    CGFloat baseW=[layout isEqualToString:@"compact"]?155:
        ([layout isEqualToString:@"strip"]?260:220);
    CGFloat baseH=[layout isEqualToString:@"strip"]?66:
        ([layout isEqualToString:@"compact"]?67:85);
    CGSize size=CGSizeMake(baseW*scale,baseH*scale);
    BOOL first=!self.visible;
    if (!self.card || !isfinite(size.width) || !isfinite(size.height)) return;
    self.card.bounds=CGRectMake(0,0,size.width,size.height);
    if (self.tracking) [self moveCardToPoint:self.card.center];
    else {
        DCLTrafficPoint p=[self positionFromPrefsOrDefaultWithWidth:size.width
                                                              height:size.height];
        if (!isfinite(p.x)||!isfinite(p.y)) {
            [self discardWindow];
            return;
        }
        self.card.center=CGPointMake(p.x,p.y);
    }
    self.window.hidden=NO;
    self.visible=YES;
    [self render];
    if (first) NSLog(@"[le024-runtime] bubble shown source=%@ pos=%@",
                     self.providerName,NSStringFromCGPoint(self.card.center));
}
@end

__attribute__((constructor)) static void DCLTrafficBootstrap(void) {
    if (![[NSBundle mainBundle].bundleIdentifier isEqualToString:@"com.apple.CarPlayApp"])
        return;
    dispatch_async(dispatch_get_main_queue(),^{[[DCLTrafficOverlay shared] start];});
}
