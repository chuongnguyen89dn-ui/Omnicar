// HL57: passive single-row clock/battery/heat at the TOP-LEFT of CarPlay
// fullscreen. NO bubble background or gestures. Keep the historical class
// name because SCPFullscreenController owns this existing lifecycle.
// The continuous 37C edge warning stays independent.
#import "SCPFullscreenVitalsBubble.h"
#import "SCPFullscreenController.h"
#import "SCPCarSplit.h"
#import "SCPThermalAlarm.h" // [hl60] continuous 37C gate
#import "SCPThermalEdgeWarning.h" // [hl61] shared edge warning
#import "OMCDeviceVitals.h"
#import "SCPCommon.h"
#import "SCPShared.h"
#import <QuartzCore/QuartzCore.h>
#import <objc/runtime.h>
#import <objc/message.h>
#import <math.h>
#import <notify.h>
#import <CoreFoundation/CoreFoundation.h>

// [hl57-status] No touch target ever; the existing CarPlay UIWindow
// lets fullscreen pinch, native picker, apps and Dock receive every touch.
static UIView *DCFVPassHitTest(UIWindow *window, SEL cmd,
                               CGPoint point, UIEvent *event) {
    (void)window;(void)cmd;(void)point;(void)event;
    return nil;
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
    window.userInteractionEnabled = NO;
    window.hidden = NO; // never key, completely touch-through
    OMCLogWrite(@"SplitScreen",[NSString stringWithFormat:
        @"[hl57-status] overlay ready class=%@ level=%.1f screen=%@ pass=all",
        NSStringFromClass(window.class),(double)window.windowLevel,screen]);
    return window;
}

@interface SCPFullscreenVitalsBubble ()
@property(nonatomic,weak) UIView *parent;
@property(nonatomic,weak) UIWindow *sourceWindow;
@property(nonatomic,strong) UIWindow *overlayWindow;
@property(nonatomic,strong) UIView *statusView;
@property(nonatomic,strong) UILabel *timeLabel;
@property(nonatomic,strong) UILabel *metricsLabel;
@property(nonatomic,strong) NSTimer *timer;
@property(nonatomic,strong) NSDateFormatter *clockFormatter;
@property(nonatomic,strong) NSDictionary<NSString *, id> *lastSample;
@property(nonatomic) NSTimeInterval lastSampleTime;
@property(nonatomic) BOOL noRoomLogged;
@property(nonatomic,strong) UIView *thermalCurtain;
@property(nonatomic) SCPThermalAlarmState thermalAlarm;
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
        // Preserve but never consult old normalized drag preferences.
        _thermalAlarm=(SCPThermalAlarmState){0};
        static int thermalTestToken=-1;
        __weak typeof(self) weakSelf=self;
        notify_register_dispatch("com.anlai.omnicar/thermaltest37.changed",
            &thermalTestToken,dispatch_get_main_queue(),^(int token) {
                (void)token;
                CFPreferencesAppSynchronize(CFSTR("com.anlai.omnicar"));
                SCPFullscreenVitalsBubble *owner=weakSelf;
                if(!owner)return;
                owner.lastSampleTime=0; // immediate sensor update on toggle
                if(owner.statusView) {
                    [owner tick];
                } else {
                    SCPCarSplit *split=[SCPCarSplit shared];
                    if(split.active && [[SCPFullscreenController shared] fsCommittedState]
                       ==SCPFullscreenStateExpanded)
                        [owner showForConfirmedFullscreenInParent:split.container.superview];
                }
            });
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
    if (self.statusView) [self tick];
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
    if (self.statusView || self.overlayWindow)
        OMCLogWrite(@"SplitScreen",@"[hl57-status] detached");
    [self.timer invalidate];
    self.timer = nil;
    [self.thermalCurtain removeFromSuperview];
    self.thermalCurtain=nil;
    self.thermalAlarm=(SCPThermalAlarmState){0};
    [self.statusView removeFromSuperview];
    self.statusView = nil;
    self.timeLabel = nil;
    self.metricsLabel = nil;
    self.overlayWindow.hidden = YES;
    self.overlayWindow = nil;
    self.sourceWindow = nil;
    self.parent = nil;
    self.lastSample = nil;
    self.lastSampleTime = 0;
}
- (BOOL)fullscreenValidForParent:(UIView *)parent {
    SCPCarSplit *split = [SCPCarSplit shared];
    return parent && parent.window && !parent.window.hidden &&
        !parent.hidden && parent.alpha > 0.01 && split.active &&
        split.container.superview == parent &&
        [[SCPFullscreenController shared] fsCommittedState] ==
            SCPFullscreenStateExpanded &&
        ([OMCPref(@"duocarFullscreenVitalsEnabled",@YES) boolValue] ||
         [OMCPref(@"duocarThermalTest37Enabled",@NO) boolValue]);
}
// [hl61-thermal-ui] Fullscreen shows an edge glow, never a red screen fill.
// Neither the full-screen curtain nor the top-left status intercepts touches;
// the same passive CarPlay window always returns nil in hitTest:.
// HL60: persistent warning at raw 37C+ or while test switch is ON.
// Original CarPlay overlay remains pass-through for all taps and gestures.
- (void)updateThermalWarningWithSample:(NSDictionary *)sample now:(NSTimeInterval)now {
    if(!self.overlayWindow || !self.statusView)return;
    NSNumber *temp=[sample[@"temperatureCelsius"] isKindOfClass:NSNumber.class]
        ?sample[@"temperatureCelsius"]:nil;
    BOOL simulated=[OMCPref(@"duocarThermalTest37Enabled",@NO) boolValue];
    BOOL before=_thermalAlarm.active,wasSimulated=_thermalAlarm.simulated;
    BOOL active=SCPThermalAlarmStep(&_thermalAlarm,
        temp?temp.doubleValue:NAN,temp!=nil,simulated,now);
    if(before!=active || wasSimulated!=simulated)
        OMCLogWrite(@"SplitScreen",[NSString stringWithFormat:
            @"[hl60-thermal] fullscreen active=%d simulated=%d raw=%@ source=%@",
            active,simulated,temp?:@"unavailable",
            sample[@"temperatureSource"]?:@"unknown"]);
    if(!active) {
        if(self.thermalCurtain) {
            [self.thermalCurtain removeFromSuperview];
            self.thermalCurtain=nil;
            OMCLogWrite(@"SplitScreen",@"[hl60-thermal] fullscreen HIDE");
        }
        return;
    }
    if(!self.thermalCurtain) {
        UIView *edgeWarning=SCPThermalEdgeWarningCreate(self.overlayWindow.bounds);
        [self.overlayWindow addSubview:edgeWarning];
        self.thermalCurtain=edgeWarning;
        OMCLogWrite(@"SplitScreen",@"[hl61-thermal-ui] fullscreen EDGE_GLOW_SHOW pass-through");
    }
    self.thermalCurtain.frame=self.overlayWindow.bounds;
    [self.overlayWindow bringSubviewToFront:self.thermalCurtain];
    [self.overlayWindow bringSubviewToFront:self.statusView];
}
// [hl57-status] Match Dock's small Semibold typography + shadow.
- (void)layoutStatusLine {
    if(!self.statusView || !self.timeLabel || !self.metricsLabel)return;
    CGFloat width=self.statusView.bounds.size.width;
    NSString *time=self.timeLabel.text.length?self.timeLabel.text:
        [[self systemClockFormatter] stringFromDate:[NSDate date]];
    CGFloat measured=ceil([time sizeWithAttributes:
        @{NSFontAttributeName:self.timeLabel.font}].width);
    CGFloat clockWidth=MAX(26.0,MIN(measured,floor(width*0.48)));
    self.timeLabel.frame=CGRectMake(0,0,clockWidth,self.statusView.bounds.size.height);
    CGFloat batteryX=CGRectGetMaxX(self.timeLabel.frame)+4.0;
    self.metricsLabel.frame=CGRectMake(batteryX,0,
        MAX(1.0,width-batteryX),self.statusView.bounds.size.height);
}
- (void)tick {
    if (!self.statusView || ![self fullscreenValidForParent:self.parent]) {
        [self stop];
        return;
    }
    // Recreate a retired/display-switched CarPlay window, not an iPhone window.
    if (!self.overlayWindow || !self.sourceWindow ||
        self.sourceWindow != self.parent.window ||
        self.overlayWindow.screen != self.sourceWindow.screen ||
        self.overlayWindow.hidden) {
        [self showForConfirmedFullscreenInParent:self.parent];
        if (!self.statusView || !self.overlayWindow || self.overlayWindow.hidden)
            return;
    }
    NSTimeInterval now = [NSDate date].timeIntervalSince1970;
    self.statusView.alpha = 1.0; // NO idle-dim/AutoHide lease; fullscreen-only gate
    self.timeLabel.text = [[self systemClockFormatter] stringFromDate:[NSDate date]];
    if (!self.lastSample || now - self.lastSampleTime >= 3.0 ||
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
            ? [NSString stringWithFormat:@"%.0f°",temperature.doubleValue]
            : OMCDeviceVitalsThermalDescription(self.lastSample[@"thermalState"]);
        self.metricsLabel.text = [NSString stringWithFormat:@"🔋%@ 🌡%@",bat,heat];
        self.statusView.accessibilityLabel = [NSString stringWithFormat:
            @"Giờ %@, pin %@, nhiệt %@. Nguồn nhiệt: %@.",
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
    [self updateThermalWarningWithSample:self.lastSample ?: @{} now:now];
    [self layoutStatusLine];
}
// CarPlay safe-area coordinate space. A fixed status, not a draggable
// object. The overlay is display-specific; never bind to iPhone UIWindow.
- (BOOL)statusFrameForOverlay:(UIWindow *)overlay
                  hostWindow:(UIWindow *)host
                       frame:(CGRect *)outFrame {
    if(!outFrame||!overlay||!host||!host.screen||overlay.screen!=host.screen)
        return NO;
    CGRect mapped=[overlay convertRect:host.bounds fromWindow:host];
    CGRect bounds=CGRectIntersection(mapped,overlay.bounds);
    if(CGRectIsNull(bounds)||CGRectIsInfinite(bounds)||CGRectIsEmpty(bounds)||
       !isfinite(bounds.origin.x)||!isfinite(bounds.origin.y)||
       !isfinite(bounds.size.width)||!isfinite(bounds.size.height))return NO;
    UIEdgeInsets a=host.safeAreaInsets,b=overlay.safeAreaInsets;
    CGFloat left=MAX(0.0,MAX(a.left,b.left))+6.0;
    CGFloat top=MAX(0.0,MAX(a.top,b.top))+3.0;
    CGFloat right=MAX(0.0,MAX(a.right,b.right))+4.0;
    CGFloat bottom=MAX(0.0,MAX(a.bottom,b.bottom))+3.0;
    CGFloat width=MIN(190.0,bounds.size.width-left-right);
    CGFloat height=MIN(23.0,bounds.size.height-top-bottom);
    if(!isfinite(width)||!isfinite(height)||width<115.0||height<17.0)
        return NO;
    *outFrame=CGRectMake(CGRectGetMinX(bounds)+left,
                         CGRectGetMinY(bounds)+top,width,height);
    return YES;
}
- (void)showForConfirmedFullscreenInParent:(UIView *)parent {
    if(![NSThread isMainThread])return;
    if(![self fullscreenValidForParent:parent]){[self stop];return;}
    UIWindow *host=parent.window;
    if(self.overlayWindow &&
       (self.sourceWindow!=host || self.overlayWindow.screen!=host.screen))
        [self stop]; // old CarPlay display ended
    if(!self.overlayWindow) {
        self.overlayWindow=DCFVCreateCarPlayWindow(parent);
        if(!self.overlayWindow)return;
        self.sourceWindow=host;
    }
    CGRect frame=CGRectNull;
    if(![self statusFrameForOverlay:self.overlayWindow
                        hostWindow:host frame:&frame]) {
        if(!self.noRoomLogged)
            OMCLogWrite(@"SplitScreen",[NSString stringWithFormat:
                @"[hl57-status] NO_SAFE_TOP_LEFT overlay=%@ host=%@",
                NSStringFromCGRect(self.overlayWindow.bounds),
                NSStringFromCGRect(host.bounds)]);
        self.noRoomLogged=YES;
        [self stop];return;
    }
    self.noRoomLogged=NO;
    BOOL created=(self.statusView==nil);
    if(created) {
        UIView *status=[[UIView alloc]initWithFrame:frame];
        status.backgroundColor=UIColor.clearColor;
        status.opaque=NO;
        status.layer.cornerRadius=0;
        status.layer.borderWidth=0;
        status.clipsToBounds=NO;
        status.userInteractionEnabled=NO;
        status.isAccessibilityElement=YES;
        status.accessibilityTraits=UIAccessibilityTraitStaticText;
        UILabel *clock=[[UILabel alloc]initWithFrame:CGRectZero];
        clock.font=[UIFont systemFontOfSize:10.0 weight:UIFontWeightSemibold];
        clock.textColor=[UIColor colorWithRed:0.918 green:0.965 blue:0.984 alpha:1]; // APEX Ice #EAF6FB
        clock.textAlignment=NSTextAlignmentLeft;
        clock.backgroundColor=UIColor.clearColor;
        clock.adjustsFontSizeToFitWidth=YES;
        clock.minimumScaleFactor=0.72;
        clock.shadowColor=[UIColor colorWithWhite:0 alpha:0.50];
        clock.shadowOffset=CGSizeMake(0,0.5);
        clock.userInteractionEnabled=NO;
        UILabel *metrics=[[UILabel alloc]initWithFrame:CGRectZero];
        metrics.font=[UIFont systemFontOfSize:10.0 weight:UIFontWeightSemibold];
        metrics.textColor=[UIColor colorWithRed:0.918 green:0.965 blue:0.984 alpha:1]; // APEX Ice #EAF6FB
        metrics.textAlignment=NSTextAlignmentLeft;
        metrics.backgroundColor=UIColor.clearColor;
        metrics.adjustsFontSizeToFitWidth=YES;
        metrics.minimumScaleFactor=0.65;
        metrics.shadowColor=[UIColor colorWithWhite:0 alpha:0.50];
        metrics.shadowOffset=CGSizeMake(0,0.5);
        metrics.userInteractionEnabled=NO;
        [status addSubview:clock];
        [status addSubview:metrics];
        [self.overlayWindow addSubview:status];
        self.statusView=status;
        self.timeLabel=clock;
        self.metricsLabel=metrics;
        self.parent=parent;
        self.timer=[NSTimer timerWithTimeInterval:1.0
            target:self selector:@selector(tick) userInfo:nil repeats:YES];
        [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
        OMCLogWrite(@"SplitScreen",[NSString stringWithFormat:
            @"[hl57-status] TOP-LEFT attached frame=%@ background=NONE pass=all",
            NSStringFromCGRect(status.frame)]);
    } else {
        self.parent=parent;
        self.statusView.frame=frame;
        [self.overlayWindow bringSubviewToFront:self.statusView];
    }
    self.overlayWindow.userInteractionEnabled=NO;
    self.overlayWindow.hidden=NO;
    self.statusView.alpha=1.0;
    [self layoutStatusLine];
    if(created)[self tick];
}
@end
