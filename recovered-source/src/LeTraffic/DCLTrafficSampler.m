// Le 0.2.4 traffic sample reader. Stage 2: a DATA adapter, not a
// replacement for Le's native source collectors, alerts or lanes.
// Two channels encode independent measurements: moving speed and posted limit.
// No GPS coordinate adjustments, no autonomous source start.
#import "DCLTrafficSampler.h"
#import <CoreFoundation/CoreFoundation.h>
#import <notify.h>
#import <QuartzCore/QuartzCore.h>
#import <string.h>

static NSString *const DCLTrafficPrefsDomain = @"com.chuong.duocar";
static const double DCLFreshSeconds = 5.0;
static const char *DCLNativeSpeed = "com.chuong.duocar/traffic.speed";
static const char *DCLNativeLimit = "com.chuong.duocar/traffic.limit";
static const char *DCLLeSpeed = "dev.bechou.le.gmaps.speed";
static const char *DCLLeLimit = "dev.bechou.le.gmaps.limit";

@interface DCLTrafficSampler ()
@property(nonatomic,copy) DCLTrafficSampleCallback callback;
@property(nonatomic,strong) NSTimer *timer;
@end

@implementation DCLTrafficSampler {
    int _token[4];
    uint64_t _previousState[4];
    BOOL _initialized[4];
    CFTimeInterval _changedAt[4];
    DCLTrafficReading _previousReading;
    NSString *_previousProvider;
    BOOL _hasPreviousReading;
}

- (instancetype)init {
    if ((self = [super init])) {
        for (NSUInteger i=0;i<4;i++) _token[i]=-1;
    }
    return self;
}

static int DCLTrafficCorrection(void) {
    CFStringRef domain = (__bridge CFStringRef)DCLTrafficPrefsDomain;
    CFPreferencesAppSynchronize(domain);
    CFTypeRef raw = CFPreferencesCopyAppValue(CFSTR("leTrafficGpsOffsetKph"),domain);
    NSInteger correction = 0;
    if (raw) {
        id value = CFBridgingRelease(raw);
        if ([value respondsToSelector:@selector(integerValue)])
            correction = [value integerValue];
    }
    return DCLTrafficClampGpsOffset((int)MAX(-5,MIN(5,correction)));
}

// A timecoded state can linger in notifyd after the publisher quits. Do NOT
// accept the initial cached state as proof of a live source: require CHANGE
// after subscription, then expire it if unchanged for 5 seconds.
// This is conservative when a car is standing still; Le publishes new
// timestamps when its source is alive.
- (void)startWithCallback:(DCLTrafficSampleCallback)callback {
    NSAssert(NSThread.isMainThread, @"traffic sampler runs on main");
    [self stop];
    self.callback = callback;
    if (!callback) return;
    const char *const names[4] = {
        DCLNativeSpeed,DCLNativeLimit,DCLLeSpeed,DCLLeLimit
    };
    for (NSUInteger i=0;i<4;i++) {
        _token[i] = -1;
        if (notify_register_check(names[i], &_token[i]) != NOTIFY_STATUS_OK)
            _token[i] = -1;
        _initialized[i] = NO;
        _changedAt[i] = 0;
        _previousState[i] = 0;
    }
    self.timer = [NSTimer timerWithTimeInterval:0.5
        target:self selector:@selector(poll) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
    [self poll];
}
- (void)stop {
    [self.timer invalidate]; self.timer = nil;
    for (NSUInteger i=0;i<4;i++) {
        if (_token[i] >= 0) notify_cancel(_token[i]);
        _token[i] = -1;
        _initialized[i] = NO;
        _changedAt[i] = 0;
        _previousState[i] = 0;
    }
    _hasPreviousReading = NO;
    _previousProvider = nil;
    self.callback = nil;
}
- (BOOL)readSlot:(NSUInteger)index value:(int *)value {
    if (_token[index]<0) return NO;
    uint64_t raw = 0;
    if (notify_get_state(_token[index], &raw) != NOTIFY_STATUS_OK)
        return NO;
    CFTimeInterval now = CACurrentMediaTime();
    if (!_initialized[index]) {
        _initialized[index] = YES;
        _previousState[index] = raw;
        return NO;
    }
    if (raw != _previousState[index]) {
        _previousState[index] = raw;
        _changedAt[index] = now;
    }
    if (_changedAt[index] == 0 || now - _changedAt[index] > DCLFreshSeconds)
        return NO;
    return DCLTrafficDecodeLeSample(raw,value);
}
- (void)poll {
    if (!self.callback) return;
    int speed = 0, limit = 0;
    BOOL hasSpeed = [self readSlot:0 value:&speed];
    BOOL hasLimit = [self readSlot:1 value:&limit];
    NSString *provider = @"DuoCar-native";
    if (!hasSpeed) {
        hasSpeed = [self readSlot:2 value:&speed];
        hasLimit = [self readSlot:3 value:&limit];
        provider = @"Le-external";
    } else {
        // Still advance cache state of external channels while native is in use.
        int ignored = 0;
        [self readSlot:2 value:&ignored];
        [self readSlot:3 value:&ignored];
    }
    DCLTrafficReading reading = DCLTrafficComputeReading(
        hasSpeed, speed, hasLimit, limit, DCLTrafficCorrection());
    if (_hasPreviousReading &&
        _previousReading.hasSpeed == reading.hasSpeed &&
        _previousReading.rawSpeedKph == reading.rawSpeedKph &&
        _previousReading.correctedSpeedKph == reading.correctedSpeedKph &&
        _previousReading.hasLimit == reading.hasLimit &&
        _previousReading.postedLimitKph == reading.postedLimitKph &&
        _previousReading.overspeed == reading.overspeed &&
        [_previousProvider isEqualToString:provider]) return;
    _previousReading = reading;
    _previousProvider = provider;
    _hasPreviousReading = YES;
    self.callback(reading,provider);
}
@end
