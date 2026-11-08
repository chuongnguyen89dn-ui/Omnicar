// SPPSpeedGPS.m — SpeedBubble SOURCE-APP side (agent B, wave 2.5)
// Reconstruction from disassembly of OmniCarSpeedBubble.dylib (arm64).
// Per-function status is noted above each function; all VERIFIED unless
// marked. IMP addresses refer to the arm64 slice.

#import "SPPSpeedGPS.h"
#import "SBSourceGlobals.h"
#import <dispatch/dispatch.h>
#import <math.h>

// C helpers implemented in SBPublish.m
extern int  SPPKmhFromLocation(CLLocation *location, double *ageOut); // sub_538c
extern void SPPPublishSpeed(int speed, int limit);                    // sub_5498
extern int  SPPCurrentLimit(void);                                    // sub_5734

@implementation SPPSpeedGPS

// +[SPPSpeedGPS shared] @0x4a70 (+ once-block sub_4ab4 @0x4ab4) — VERIFIED
+ (instancetype)shared {
    static dispatch_once_t once; // 0x437e0
    dispatch_once(&once, ^{
        SPPSpeedGPSSharedInstance = [[SPPSpeedGPS alloc] init]; // 0x437d8
    });
    return SPPSpeedGPSSharedInstance;
}

// Lazy accessor backing -appManager:running: — VERIFIED
// (weakObjectsHashTable, built on first use)
- (NSHashTable *)appManagers {
    if (!_appManagers) {
        _appManagers = [NSHashTable weakObjectsHashTable];
    }
    return _appManagers;
}

// -appManager:running: @0x4ae0 — VERIFIED
// Tracks the host app's own location managers. While any is running the
// private GPS stays on; when the last one stops, shutdown is delayed via
// -scheduleStop (a new start cancels it through stopToken).
- (void)appManager:(CLLocationManager *)manager running:(BOOL)running {
    if (running) {
        [self.appManagers addObject:manager];
    } else {
        [self.appManagers removeObject:manager];
    }
    if (self.appManagers.count > 0) {
        self.stopToken += 1;
        self.stopPending = NO;
        if (!self.mgr) {
            [self start];
        }
    } else if (self.mgr) {
        [self scheduleStop];
    }
}

// -scheduleStop @0x4cac — VERIFIED (20 s = 0x4a817c800 ns dispatch_after)
- (void)scheduleStop {
    self.stopToken += 1;
    self.stopPending = YES;
    NSUInteger token = self.stopToken;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 20000000000LL),
                   dispatch_get_main_queue(), ^{
        // sub_4d44 @0x4d44 — VERIFIED: stale-token aborts; only stop when
        // no app manager came back in the meantime.
        if (token != self.stopToken) {
            return;
        }
        self.stopPending = NO;
        if (self.appManagers.count == 0) {
            [self stop];
        }
    });
}

// -start @0x4e28 — VERIFIED
- (void)start {
    CLLocationManager *m = [CLLocationManager new];
    m.delegate = self;
    m.desiredAccuracy = kCLLocationAccuracyBestForNavigation;
    m.distanceFilter = kCLDistanceFilterNone;
    m.activityType = CLActivityTypeAutomotiveNavigation; // raw value 2 in disasm
    m.pausesLocationUpdatesAutomatically = NO;
    // Background updates only when the HOST app already declares the
    // location background mode; the setter is called inside @try/@catch.
    NSArray *modes = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"UIBackgroundModes"];
    BOOL background = [modes containsObject:@"location"];
    @try {
        m.allowsBackgroundLocationUpdates = background;
    } @catch (id exception) {
    }
    self.mgr = m;
    self.loggedFirst = NO;
    [m startUpdatingLocation];
    SPPLog(@"speed gps: bat GPS rieng (nen=%d)", background);
}

// -stop @0x4ffc — VERIFIED
- (void)stop {
    [self.mgr stopUpdatingLocation];
    self.mgr.delegate = nil;
    self.mgr = nil;
    self.last = nil;
    SPPLog(@"speed gps: app tat GPS -> tat GPS rieng");
}

// -locationManager:didUpdateLocations: @0x50c0 — VERIFIED
// (publication packing in SBPublish.m; location channel packed below)
- (void)locationManager:(CLLocationManager *)manager
     didUpdateLocations:(NSArray<CLLocation *> *)locations {
    CLLocation *loc = locations.lastObject;
    if (manager != self.mgr) {
        return; // callbacks from any other manager are ignored
    }
    if (self.appManagers.count == 0 && !self.stopPending) {
        [self scheduleStop];
    }
    self.last = loc;

    int kmh = SPPKmhFromLocation(loc, NULL);
    if (!self.loggedFirst) {
        self.loggedFirst = YES;
        SPPLog(@"speed gps: vi tri dau tien, %d km/h (sai so %.0fm)",
               kmh, loc.horizontalAccuracy);
    }
    if (kmh >= 0) {
        SPPPublishSpeed(kmh, SPPCurrentLimit());
    }

    // Coarse position channel for the display side:
    // "com.anlai.omnicar/location", state =
    //   (int64)llround(lat * 100) << 32 | (uint32)llround(lon * 100)
    // (~0.01 degree grid), gated to accuracy 0..5000 m and >= 3.0 s between
    // posts. Mechanics VERIFIED; the choice of clock call is INFERRED
    // (CFAbsoluteTimeGetCurrent, consistent with the scan code).
    double accuracy = loc.horizontalAccuracy;
    double now = CFAbsoluteTimeGetCurrent();
    if (accuracy >= 0 && accuracy <= 5000 &&
        now - SPPLastLocationPubTime >= 3.0) {
        SPPLastLocationPubTime = now;
        uint64_t packed =
            ((uint64_t)(int64_t)llround(loc.coordinate.latitude * 100.0) << 32) |
            (uint64_t)(uint32_t)(int32_t)llround(loc.coordinate.longitude * 100.0);
        if (!SPPLocationNotifyToken) {
            notify_register_check("com.anlai.omnicar/location",
                                  (int *)&SPPLocationNotifyToken);
        }
        notify_set_state(SPPLocationNotifyToken, packed);
        notify_post("com.anlai.omnicar/location");
    }
}

// -locationManager:didFailWithError: @0x5798 — VERIFIED (log only)
- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error {
    SPPLog(@"speed gps: loi %@", error);
}

@end
