// OMCCore.m — reconstructed bodies for the shared core helpers.
// Status per function is noted inline; see AppBridgeA_REPORT.md §5.

#import "OMCCore.h"
#import <CoreFoundation/CoreFoundation.h>
#import <notify.h>
#import <objc/runtime.h>
#import <string.h>
#import <stdlib.h>

static NSString *const kOMCPrefsDomain = @"com.anlai.omnicar"; // 0x37070

// _OMCPrefsSync @ 0x1d674 — VERIFIED (tail call, 1 argument).
void OMCPrefsSync(void) {
    CFPreferencesAppSynchronize((__bridge CFStringRef)kOMCPrefsDomain);
}

// _OMCPref @ 0x1d680 — VERIFIED: (key, domain) 2-argument call to
// CFPreferencesCopyAppValue; csel picks the default when the copy is nil.
id OMCPref(NSString *key, id defaultValue) {
    id value = (__bridge_transfer id)CFPreferencesCopyAppValue(
        (__bridge CFStringRef)key, (__bridge CFStringRef)kOMCPrefsDomain);
    return value ?: defaultValue;
}

// _OMCEnabled @ 0x1d6e8 — VERIFIED.
BOOL OMCEnabled(void) {
    if (OMCExpired()) return NO;
    return [OMCPref(@"enabled", (__bridge id)kCFBooleanFalse) boolValue];
}

// _OMCFeatureEnabled @ 0x1d744 — VERIFIED: feature key = name + "Enabled".
BOOL OMCFeatureEnabled(NSString *featureName) {
    if (!OMCEnabled()) return NO;
    NSString *key = [featureName stringByAppendingString:@"Enabled"];
    return [OMCPref(key, (__bridge id)kCFBooleanFalse) boolValue];
}

// _OMCExpired @ 0x2358c — structure VERIFIED, trusted-time combination
// INFERRED: the binary holds the expiry string "2027-04-30"; the code
// compares [NSDate date].timeIntervalSince1970 and the persisted
// "trustedTime" pref (CFPreferencesCopyAppValue) against the deadline and
// returns YES when the later of them passes it.
BOOL OMCExpired(void) {
    // Deadline constant lives in __const next to the "2027-04-30" string.
    // (Epoch value itself was not read out byte-exact; behaviour: expired
    // when now >= deadline, with "trustedTime" as a floor against rollback.)
    static const NSTimeInterval kDeadline = 1809216000.0; // 2027-04-30 UTC (INFERRED value)
    NSTimeInterval now = [NSDate date].timeIntervalSince1970;
    NSNumber *trusted = OMCPref(@"trustedTime", nil);
    NSTimeInterval t = now;
    if ([trusted isKindOfClass:[NSNumber class]])
        t = MAX(t, [trusted doubleValue]);
    return t >= kDeadline;
}

// _OMCLiteActive @ 0x1d7d4 — INFERRED branch detail (VERIFIED ingredients):
// pref "liteMode" (integer), NSProcessInfo.thermalState, and the Darwin
// state of "com.anlai.omnicar/lite" all participate; result is cached
// against CFAbsoluteTimeGetCurrent() checks in the original.
BOOL OMCLiteActive(void) {
    NSInteger mode = [OMCPref(@"liteMode", nil) integerValue];
    static int token = 0;
    if (token == 0) notify_register_check("com.anlai.omnicar/lite", &token);
    uint64_t state = 0;
    notify_get_state(token, &state);
    if (state) return YES;
    if (mode == 1) { // automatic
        return [NSProcessInfo processInfo].thermalState >= NSProcessInfoThermalStateSerious;
    }
    return mode == 2;
}

// _OMCCarWireless @ 0x1d930 — INFERRED: inspects the "diagCar" dictionary
// written by the CarKit session watcher; transport strings seen in the log
// unit are "usb", "wired", "wifi", "wi-fi".
BOOL OMCCarWireless(void) {
    NSDictionary *car = OMCPref(@"diagCar", nil);
    if (![car isKindOfClass:[NSDictionary class]]) return NO;
    // The exact key path inside diagCar was not isolated in this pass.
    NSString *transport = [car objectForKey:@"transport"];
    return [transport isEqualToString:@"wifi"] || [transport isEqualToString:@"wi-fi"];
}

// _OMCCarClass @ 0x1e438 — VERIFIED.
Class OMCCarClass(const char *name) {
    Class cls = objc_getClass(name);
    if (cls) return cls;
    NSString *n = [NSString stringWithUTF8String:name];
    if ([n isEqualToString:@"DashBoard"])
        return objc_getClass("CARApplication");
    if ([n hasPrefix:@"DB"]) {
        NSString *rest = [n substringFromIndex:2];
        if (rest) {
            cls = objc_getClass([@"CAR" stringByAppendingString:rest].UTF8String);
            if (cls) return cls;
            cls = objc_getClass([@"_CAR" stringByAppendingString:rest].UTF8String);
            if (cls) return cls;
        }
    }
    return nil;
}

// _OMCHasMethod @ 0x1e384 — VERIFIED.
BOOL OMCHasMethod(const char *className, NSString *methodName) {
    Class cls = OMCCarClass(className);
    if (!cls) return NO;
    if ([methodName hasPrefix:@"+"]) {
        SEL sel = NSSelectorFromString([methodName substringFromIndex:1]);
        return class_getClassMethod(cls, sel) != NULL;
    }
    SEL sel = NSSelectorFromString(methodName);
    return class_getInstanceMethod(cls, sel) != NULL;
}

// _OMCCarLaunchInfo @ 0x1ee50 — VERIFIED.
id OMCCarLaunchInfo(id app) {
    if (!app) return nil;
    Class c = OMCCarClass("DBApplicationLaunchInfo");
    SEL s1 = NSSelectorFromString(@"launchInfoForApplication:");
    SEL s2 = NSSelectorFromString(@"launchInfoForApplication:withActivationSettings:");
    if ([(id)c respondsToSelector:s1]) {
        return [(id)c performSelector:s1 withObject:app];
        // (original: direct objc_msgSend with the dynamic selector)
    }
    if ([(id)c respondsToSelector:s2]) {
        // objc_msgSend(c, s2, app, nil)
        id (*fn)(id, SEL, id, id) = (void *)objc_msgSend;
        return fn((id)c, s2, app, nil);
    }
    OMCLogWrite(@"Core", [NSString stringWithFormat:
        @"THIEU METHOD: %@ khong tao duoc launchInfo", c]);
    return nil;
}

// _OMCCheckHooks @ 0x1e580 — VERIFIED structure (loop, rename set, missing
// array, diag merge + CFPreferences write all read from disassembly);
// the exact construction of the "diagHooks.<module>" key around 0x1e920
// is INFERRED from the "diagHooks." string + module argument pattern.
void OMCCheckHooks(NSString *module, NSArray<NSString *> *specs) {
    NSMutableArray<NSString *> *missing = [NSMutableArray array];
    NSMutableOrderedSet<NSString *> *renamed = [NSMutableOrderedSet orderedSet];
    for (NSString *spec in specs) {
        NSArray<NSString *> *parts = [spec componentsSeparatedByString:@" "];
        if (parts.count != 2) continue;
        NSString *className = parts[0];
        NSString *selPart = parts[1];
        Class cls = OMCCarClass(className.UTF8String);
        if (cls && ![NSStringFromClass(cls) isEqualToString:className]) {
            [renamed addObject:[NSString stringWithFormat:@"%@=%@",
                                className, NSStringFromClass(cls)]];
        }
        NSString *selName = selPart;
        if ([selPart hasPrefix:@"-"]) selName = [selPart substringFromIndex:1];
        // OMCHasMethod itself understands the "+" prefix; "-" was stripped.
        NSString *probe = [selPart hasPrefix:@"+"] ? selPart : selName;
        if (!OMCHasMethod(className.UTF8String, probe))
            [missing addObject:spec];
    }
    if (renamed.count) {
        OMCLogWrite(module, [NSString stringWithFormat:
            @"iOS %@: lop CarPlay %@",
            [UIDevice currentDevice].systemVersion,
            [[renamed array] componentsJoinedByString:@", "]]);
    }
    NSString *key = [@"diagHooks." stringByAppendingString:module];
    NSMutableDictionary *diag =
        [OMCPref(key, nil) mutableCopy] ?: [NSMutableDictionary dictionary];
    diag[@"ios"] = [UIDevice currentDevice].systemVersion;
    diag[@"total"] = @([diag[@"total"] unsignedIntegerValue] + specs.count);
    NSMutableArray *allMissing = [diag[@"missing"] mutableCopy] ?: [NSMutableArray array];
    [allMissing addObjectsFromArray:missing];
    diag[@"missing"] = allMissing;
    CFPreferencesSetAppValue((__bridge CFStringRef)key,
                             (__bridge CFPropertyListRef)diag,
                             (__bridge CFStringRef)kOMCPrefsDomain);
    CFPreferencesAppSynchronize((__bridge CFStringRef)kOMCPrefsDomain);
}

// _ABMissingSelector @ 0x9698 — VERIFIED head (dedup set at 0x3ea20,
// one-time flag at 0x3ea28, "Class selector" key format "%@ %@"); the log
// call tail was not fully traced, hence the conservative body below.
void ABMissingSelector(id object, NSString *selectorName) {
    if (!object) return;
    static NSMutableSet<NSString *> *seen;
    static dispatch_once_t once;
    dispatch_once(&once, ^{ seen = [NSMutableSet set]; });
    NSString *entry = [NSString stringWithFormat:@"%@ %@",
                       NSStringFromClass([object class]), selectorName];
    @synchronized (seen) {
        if ([seen containsObject:entry]) return;
        [seen addObject:entry];
    }
    OMCLogWrite(@"AppBridge", [NSString stringWithFormat:
        @"THIEU METHOD: %@", entry]); // wording INFERRED
}
