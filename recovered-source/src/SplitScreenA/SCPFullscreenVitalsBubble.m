// Only visible once the existing fullscreen controller confirms EXPANDED.
// Does not modify stock Dock, status-bar windows, scene layout or touch routing.
#import "SCPFullscreenVitalsBubble.h"
#import "SCPFullscreenController.h"
#import "SCPCarSplit.h"
#import "SCPVitalsPlacement.h"
#import "OMCDeviceVitals.h"
#import "SCPCommon.h"
#import "SCPShared.h"
#import <math.h>

@interface SCPFullscreenVitalsBubble ()
@property(nonatomic,weak) UIView *parent;
@property(nonatomic,strong) UIView *pill;
@property(nonatomic,strong) UILabel *timeLabel;
@property(nonatomic,strong) UILabel *metricsLabel;
@property(nonatomic,strong) NSTimer *timer;
@property(nonatomic,strong) NSDateFormatter *clockFormatter;
@property(nonatomic,strong) NSDictionary<NSString *, id> *lastSample;
@property(nonatomic) NSTimeInterval lastSampleTime;
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
        NSNotificationCenter *center = NSNotificationCenter.defaultCenter;
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
    self.clockFormatter = nil; // user can change timezone and 12/24-hour format
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
    if (self.pill) OMCLogWrite(@"SplitScreen", @"[fs-vitals] bubble detached");
    [self.timer invalidate];
    self.timer = nil;
    [self.pill removeFromSuperview];
    self.pill = nil;
    self.timeLabel = nil;
    self.metricsLabel = nil;
    self.parent = nil;
    self.lastSample = nil;
    self.lastSampleTime = 0;
}
- (void)tick {
    if (!self.pill || !self.parent.window ||
        [[SCPFullscreenController shared] fsCommittedState] != SCPFullscreenStateExpanded ||
        ![OMCPref(@"duocarFullscreenVitalsEnabled", @YES) boolValue]) {
        [self stop];
        return;
    }
    self.timeLabel.text = [[self systemClockFormatter] stringFromDate:[NSDate date]];
    NSTimeInterval now = [NSDate date].timeIntervalSince1970;
    if (!self.lastSample || now - self.lastSampleTime >= 12.0 ||
        now < self.lastSampleTime) {
        self.lastSample = OMCDeviceVitalsSample();
        self.lastSampleTime = now;
        NSNumber *b = [self.lastSample[@"batteryPercent"] isKindOfClass:NSNumber.class]
            ? self.lastSample[@"batteryPercent"] : nil;
        NSNumber *t = [self.lastSample[@"temperatureCelsius"] isKindOfClass:NSNumber.class]
            ? self.lastSample[@"temperatureCelsius"] : nil;
        NSString *bat = b ? [NSString stringWithFormat:@"%ld%%", (long)b.integerValue] : @"--";
        NSString *heat = t ? [NSString stringWithFormat:@"~%.0f°C", t.doubleValue]
                           : OMCDeviceVitalsThermalDescription(self.lastSample[@"thermalState"]);
        self.metricsLabel.text = [NSString stringWithFormat:@"🔋 %@   🌡 %@", bat, heat];
        self.pill.accessibilityLabel = [NSString stringWithFormat:
            @"Giờ %@, pin %@, nhiệt %@. Nguồn nhiệt: %@.",
            self.timeLabel.text ?: @"--", bat, heat,
            self.lastSample[@"temperatureSource"]];
        OMCLogWrite(@"SplitScreen", [NSString stringWithFormat:
            @"[fs-vitals] sample clock=%@ battery=%@ charge=%@ tempC=%@ source=%@ thermal=%@",
            self.timeLabel.text ?: @"--",
            b ?: @"unavailable", self.lastSample[@"batteryState"],
            t ?: @"unavailable", self.lastSample[@"temperatureSource"],
            self.lastSample[@"thermalState"]]);
    }
}
- (void)showForConfirmedFullscreenInParent:(UIView *)parent {
    if (![NSThread isMainThread]) return;
    SCPCarSplit *split = [SCPCarSplit shared];
    if (!parent || !parent.window || !split.active ||
        split.container.superview != parent ||
        [[SCPFullscreenController shared] fsCommittedState] != SCPFullscreenStateExpanded ||
        ![OMCPref(@"duocarFullscreenVitalsEnabled", @YES) boolValue]) {
        [self stop];
        return;
    }
    CGRect bounds = parent.bounds;
    if (CGRectIsNull(bounds) || CGRectIsInfinite(bounds) ||
        CGRectIsEmpty(bounds) || !isfinite(bounds.size.width) ||
        !isfinite(bounds.size.height)) {
        [self stop];
        return;
    }
    UIEdgeInsets safe = parent.safeAreaInsets;
    SCPVitalsRect root = {bounds.origin.x,bounds.origin.y,bounds.size.width,bounds.size.height};
    SCPVitalsLayoutResult result = SCPVitalsFullscreenBubblePlace(
        root, MAX(0.0,safe.top),MAX(0.0,safe.right),1);
    if (!result.valid) {
        if (!self.noRoomLogged) {
            OMCLogWrite(@"SplitScreen", [NSString stringWithFormat:
                @"[fs-vitals] no-room bounds=%@ safe=%@",
                NSStringFromCGRect(bounds),NSStringFromUIEdgeInsets(safe)]);
            self.noRoomLogged = YES;
        }
        [self stop];
        return;
    }
    self.noRoomLogged = NO;
    CGRect frame = CGRectMake(result.frame.x,result.frame.y,
                              result.frame.w,result.frame.h);
    if (!self.pill || self.pill.superview != parent) {
        [self stop];
        UIView *pill = [[UIView alloc] initWithFrame:frame];
        pill.backgroundColor = [UIColor colorWithWhite:0.07 alpha:0.75];
        pill.layer.cornerRadius = 19.0;
        pill.layer.borderWidth = 0.5;
        pill.layer.borderColor = [UIColor colorWithWhite:1.0 alpha:0.22].CGColor;
        pill.clipsToBounds = YES;
        pill.userInteractionEnabled = NO; // touches continue to full-screen app
        UILabel *time = [[UILabel alloc] initWithFrame:CGRectZero];
        time.font = [UIFont monospacedDigitSystemFontOfSize:13.0
                                                   weight:UIFontWeightSemibold];
        time.textColor = UIColor.whiteColor;
        time.adjustsFontSizeToFitWidth = YES;
        time.minimumScaleFactor = 0.67;
        time.textAlignment = NSTextAlignmentCenter;
        UILabel *metrics = [[UILabel alloc] initWithFrame:CGRectZero];
        metrics.font = [UIFont systemFontOfSize:10.0 weight:UIFontWeightMedium];
        metrics.textColor = UIColor.whiteColor;
        metrics.adjustsFontSizeToFitWidth = YES;
        metrics.minimumScaleFactor = 0.62;
        metrics.textAlignment = NSTextAlignmentCenter;
        [pill addSubview:time];
        [pill addSubview:metrics];
        [parent addSubview:pill];
        self.parent = parent;
        self.pill = pill;
        self.timeLabel = time;
        self.metricsLabel = metrics;
        [self tick];
        self.timer = [NSTimer timerWithTimeInterval:1.0
            target:self selector:@selector(tick) userInfo:nil repeats:YES];
        [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
        OMCLogWrite(@"SplitScreen", [NSString stringWithFormat:
            @"[fs-vitals] bubble attached frame=%@ time=system-local",NSStringFromCGRect(frame)]);
    } else {
        self.pill.frame = frame;
        // A root relayout could lift the split after the badge was attached.
        [parent bringSubviewToFront:self.pill];
    }
    CGFloat timeWidth = MIN(87.0, floor(frame.size.width * 0.37));
    self.timeLabel.frame = CGRectMake(8.0,0.0,timeWidth,frame.size.height);
    self.metricsLabel.frame = CGRectMake(8.0+timeWidth,0.0,
                                    MAX(1.0,frame.size.width-timeWidth-16.0),
                                    frame.size.height);
}
@end
