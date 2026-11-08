// SPPSpeedGPS.h — SpeedBubble SOURCE-APP side (agent B, wave 2.5)
// OmniCarSpeedBubble.dylib, arm64 slice.
//
// SPPSpeedGPS is the dylib's OWN GPS engine inside a source app. The app's
// own CLLocationManager start/stop calls are hooked (see SBSourceHooks.m);
// while at least one app manager is running, SPPSpeedGPS runs a private
// CLLocationManager and publishes speed readings (see SBPublish.m).
//
// Evidence: class struct @0x43318, method list + ivars from
// metadata/raw/OmniCarSpeedBubble/objc.json (names are plain strings,
// unaffected by the import off-by-one), IMPs verified in disassembly.
// Superclass: wave-1 metadata said NSRunLoop — WRONG (chained-fixup
// off-by-one). Raw bind ordinal at 0x43320 = 267 -> imports[267] =
// _OBJC_CLASS_$_NSObject with the calibrated 0-based decode; confirmed by
// the LC_DYSYMTAB-calibrated xref and by semantics. VERIFIED: NSObject.
// Protocol: CLLocationManagerDelegate (from class struct protocol list).

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface SPPSpeedGPS : NSObject <CLLocationManagerDelegate>

@property (nonatomic, strong) CLLocationManager *mgr;
@property (nonatomic, strong) CLLocation *last;
@property (nonatomic, strong) NSHashTable *appManagers;   // weak objects
@property (nonatomic) BOOL loggedFirst;
@property (nonatomic) NSUInteger stopToken;
@property (nonatomic) BOOL stopPending;

+ (instancetype)shared;
- (void)appManager:(CLLocationManager *)manager running:(BOOL)running;
- (void)scheduleStop;
- (void)start;
- (void)stop;

@end
