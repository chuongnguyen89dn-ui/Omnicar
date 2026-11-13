// DuoCar first-party battery and temperature sampler (no vendor runtime code).
#import "OMCDeviceVitals.h"
#import <UIKit/UIKit.h>
#import <IOKit/IOKitLib.h>
#import <CoreFoundation/CoreFoundation.h>
#import <math.h>

// IOServiceMatching allocates the match dictionary, consumed by IOKit.
// MACH_PORT_NULL is the IOKit default master port for this read-only lookup.
static io_service_t OMCVitalsService(const char *name) {
    CFMutableDictionaryRef matching = IOServiceMatching(name);
    if (!matching) return IO_OBJECT_NULL;
    return IOServiceGetMatchingService(MACH_PORT_NULL, matching);
}

static BOOL OMCVitalsReadNumber(io_service_t service, CFStringRef key, double *out) {
    if (!service || !out) return NO;
    CFTypeRef raw = IORegistryEntryCreateCFProperty(service, key, kCFAllocatorDefault, 0);
    if (!raw) return NO;
    BOOL valid = NO;
    double n = 0;
    if (CFGetTypeID(raw) == CFNumberGetTypeID() &&
        CFNumberGetValue((CFNumberRef)raw, kCFNumberDoubleType, &n) &&
        isfinite(n)) {
        *out = n;
        valid = YES;
    }
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
    const char *services[] = {"AppleSmartBattery", "AppleTemperatureSensor"};
    for (NSUInteger index = 0; index < 2 && !temperature; ++index) {
        io_service_t service = OMCVitalsService(services[index]);
        if (!service) continue;
        double raw = 0, value = 0;
        BOOL valid = OMCVitalsReadNumber(service, CFSTR("Temperature"), &raw) &&
            OMCVitalsDecodeTemperature(raw, &value);
        IOObjectRelease(service);
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
