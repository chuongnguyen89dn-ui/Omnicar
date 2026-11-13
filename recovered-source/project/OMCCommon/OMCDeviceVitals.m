// DuoCar first-party battery and temperature sampler (no vendor runtime code).
#import "OMCDeviceVitals.h"
#import <UIKit/UIKit.h>
#import <mach/mach.h>
#import <dlfcn.h>
#import <CoreFoundation/CoreFoundation.h>
#import <math.h>

// IOKit is private on iOS. Dynamically resolve read-only exports so the
// ordinary iPhoneOS SDK does not need a private IOKit header/link stub.
// All functions must resolve before a lookup; denial means no reading.
typedef mach_port_t OMCVitalsServiceID;
typedef CFMutableDictionaryRef (*OMCVitalsMatchingFn)(const char *);
typedef OMCVitalsServiceID (*OMCVitalsGetServiceFn)(mach_port_t, CFDictionaryRef);
typedef CFTypeRef (*OMCVitalsGetPropertyFn)(OMCVitalsServiceID, CFStringRef, CFAllocatorRef, uint32_t);
typedef kern_return_t (*OMCVitalsReleaseFn)(OMCVitalsServiceID);
typedef struct {
    OMCVitalsMatchingFn match;
    OMCVitalsGetServiceFn service;
    OMCVitalsGetPropertyFn property;
    OMCVitalsReleaseFn release;
} OMCVitalsIOKit;

static const OMCVitalsIOKit *OMCVitalsIOKitAPI(void) {
    static OMCVitalsIOKit api;
    static BOOL ready;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        void *lib = dlopen("/System/Library/Frameworks/IOKit.framework/IOKit",
                           RTLD_NOW | RTLD_LOCAL);
        if (!lib) lib = dlopen("/System/Library/Frameworks/IOKit.framework/Versions/A/IOKit",
                               RTLD_NOW | RTLD_LOCAL);
        if (!lib) return;
        api.match = (OMCVitalsMatchingFn)dlsym(lib, "IOServiceMatching");
        api.service = (OMCVitalsGetServiceFn)dlsym(lib, "IOServiceGetMatchingService");
        api.property = (OMCVitalsGetPropertyFn)dlsym(lib, "IORegistryEntryCreateCFProperty");
        api.release = (OMCVitalsReleaseFn)dlsym(lib, "IOObjectRelease");
        ready = api.match && api.service && api.property && api.release;
        if (!ready) dlclose(lib);
        // Keep a complete valid library open for the process lifetime.
    });
    return ready ? &api : NULL;
}

static BOOL OMCVitalsReadNumber(const OMCVitalsIOKit *api,
                               OMCVitalsServiceID service, CFStringRef key,
                               double *out) {
    if (!api || !service || !out) return NO;
    CFTypeRef raw = api->property(service, key, kCFAllocatorDefault, 0);
    if (!raw) return NO;
    double n = 0;
    BOOL valid = CFGetTypeID(raw) == CFNumberGetTypeID() &&
        CFNumberGetValue((CFNumberRef)raw, kCFNumberDoubleType, &n) && isfinite(n);
    if (valid) *out = n;
    CFRelease(raw);
    return valid;
}

// Values are variously stored in whole/deci/centi °C by devices.
// No unit can be certified solely by the registry key. Reject all out-of-range
// readings and expose provenance so the UI never labels these "GPU °C".
static BOOL OMCVitalsDecodeTemperature(double raw, double *celsius) {
    if (!isfinite(raw) || !celsius) return NO;
    double c = raw;
    if (raw >= 1500.0 && raw <= 6500.0) c = raw / 100.0;
    else if (raw >= 150.0 && raw <= 650.0) c = raw / 10.0;
    else if (raw < 15.0 || raw > 65.0) return NO;
    if (c < 15.0 || c > 65.0) return NO;
    *celsius = c;
    return YES;
}

static NSString *OMCVitalsThermalState(void) {
    switch ([NSProcessInfo processInfo].thermalState) {
        case NSProcessInfoThermalStateNominal: return @"nominal";
        case NSProcessInfoThermalStateFair: return @"fair";
        case NSProcessInfoThermalStateSerious: return @"serious";
        case NSProcessInfoThermalStateCritical: return @"critical";
        default: return @"unknown";
    }
}

NSString *OMCDeviceVitalsThermalDescription(NSString *state) {
    if ([state isEqualToString:@"nominal"]) return @"Ổn định";
    if ([state isEqualToString:@"fair"]) return @"Hơi nóng";
    if ([state isEqualToString:@"serious"]) return @"Nóng";
    if ([state isEqualToString:@"critical"]) return @"Rất nóng";
    return @"Không rõ";
}

NSDictionary<NSString *, id> *OMCDeviceVitalsSample(void) {
    UIDevice *device = [UIDevice currentDevice];
    if (!device.batteryMonitoringEnabled) device.batteryMonitoringEnabled = YES;
    double level = device.batteryLevel;
    NSNumber *percent = (isfinite(level) && level >= 0.0 && level <= 1.0)
        ? @((NSInteger)lround(level * 100.0)) : nil;
    UIDeviceBatteryState state = device.batteryState;
    NSString *batteryState = state == UIDeviceBatteryStateCharging ? @"charging"
        : state == UIDeviceBatteryStateFull ? @"full"
        : state == UIDeviceBatteryStateUnplugged ? @"unplugged" : @"unknown";

    NSNumber *temperature = nil;
    NSString *temperatureKind = @"unavailable";
    NSString *temperatureSource = @"none";
    const OMCVitalsIOKit *api = OMCVitalsIOKitAPI();
    const char *services[] = {"AppleSmartBattery", "AppleTemperatureSensor"};
    for (NSUInteger index = 0; api && index < 2 && !temperature; ++index) {
        CFMutableDictionaryRef match = api->match(services[index]);
        if (!match) continue;
        // IOServiceGetMatchingService consumes the matching dictionary.
        OMCVitalsServiceID service = api->service(MACH_PORT_NULL, match);
        if (!service) continue;
        double raw = 0, value = 0;
        BOOL valid = OMCVitalsReadNumber(api, service, CFSTR("Temperature"), &raw) &&
            OMCVitalsDecodeTemperature(raw, &value);
        api->release(service);
        if (valid) {
            temperature = @(value);
            temperatureKind = index == 0 ? @"battery" : @"device-unspecified";
            temperatureSource = index == 0
                ? @"AppleSmartBattery.Temperature"
                : @"AppleTemperatureSensor.Temperature";
        }
    }
    // NSNull is an explicit unavailable reading, never a fabricated 33/38/43/48°C.
    return @{
        @"batteryPercent": percent ?: [NSNull null],
        @"batteryState": batteryState,
        @"temperatureCelsius": temperature ?: [NSNull null],
        @"temperatureKind": temperatureKind,
        @"temperatureSource": temperatureSource,
        @"temperatureUnitsVerified": @NO,
        @"gpuTemperatureVerified": @NO,
        @"thermalState": OMCVitalsThermalState(),
        @"sampledAt": @([[NSDate date] timeIntervalSince1970])
    };
}
