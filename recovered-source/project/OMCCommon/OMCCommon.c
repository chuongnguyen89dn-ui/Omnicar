// OMCCommon.c — reconstructed shared core of OmniCar 1.0.3.
// Objective-C (ARC). See OMCCommon.h for the overview and OMCCommon_REPORT.md
// for per-function evidence. Function addresses = OmniCarCore.dylib arm64.
//
// Recovered constants:
//   build hash "fbebb21", version "1.0.3" (see OmniCarCore.c diag writer)
//   expiry deadline epoch 1809104400 (2027-05-01 00:00 GMT+7)

#import "OMCCommon.h"
#import <CoreFoundation/CoreFoundation.h>
#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import <notify.h>
#import <dlfcn.h>
#import <mach/mach.h>
#import <mach/mach_time.h>
#import <mach-o/dyld.h>
#import <mach-o/getsect.h>
#import <execinfo.h>
#import <math.h>
#import <os/proc.h>
#import <signal.h>
#import <stdatomic.h>
#import <string.h>
#import <stdio.h>
#import <stdlib.h>
#import <time.h>
#import <unistd.h>
#import <fcntl.h>
#import <objc/runtime.h>

CFStringRef const kOMCPrefsDomain = CFSTR("com.anlai.omnicar");

// Internal helpers defined further down / in this file.
static void OMCLogInitOnce(void);

#pragma mark - libroot path layer (sub_4118 / sub_4170) — VERIFIED behaviour
//
// The core resolves jailbreak-rooted paths through opa334's libroot,
// dlopen'ed lazily ("@rpath/libroot.dylib", RTLD_LAZY). If any symbol is
// missing, built-in fallbacks with stock libroot semantics are used.
// (API-name correspondence to libroot is INFERRED; the fallback behaviour
// below is exactly what the machine code does.)

typedef const char *(*OMCStringFn)(void);
typedef char *(*OMCPathFn)(const char *path, char *out);

static OMCStringFn gRootPrefixFn;   // bss+0x00
static OMCStringFn gJBRootPrefixFn; // bss+0x08
static OMCStringFn gBootUUIDFn;     // bss+0x10
static OMCPathFn   gRootFSPathFn;   // bss+0x18
static OMCPathFn   gJBRootPathFn;   // bss+0x20
static dispatch_once_t gJBRootOnce; // bss+0x28

static const char *OMCFallbackRootPrefix(void) { return ""; }
static const char *OMCFallbackJBRootPrefix(void) { return "/var/jb"; }
static const char *OMCFallbackBootUUID(void) {
    return "00000000-0000-0000-0000-000000000000";
}
static char *OMCFallbackJBRootPath(const char *path, char *out) {
    if (!out) out = malloc(1024);
    if (path[0] == '/') {
        strlcpy(out, gJBRootPrefixFn(), 1024);
        strlcat(out, path, 1024);
    } else {
        strlcpy(out, path, 1024);
    }
    return out;
}
static char *OMCFallbackRootFSPath(const char *path, char *out) {
    if (!out) out = malloc(1024);
    if (path[0] == '/') {
        const char *jb = gJBRootPrefixFn();
        size_t jblen = strlen(jb);
        if (strncmp(path, jb, jblen) == 0) {
            strlcpy(out, path + jblen, 1024);
        } else {
            strlcpy(out, gRootPrefixFn(), 1024);
            strlcat(out, path, 1024);
        }
    } else {
        strlcpy(out, path, 1024);
    }
    return out;
}

static void OMCJBRootInit(void) { // sub_4170
    dispatch_once(&gJBRootOnce, ^{
        void *h = dlopen("@rpath/libroot.dylib", RTLD_LAZY /* 2 */);
        OMCStringFn rp = (OMCStringFn)dlsym(h, "libroot_get_root_prefix");
        OMCStringFn jp = (OMCStringFn)dlsym(h, "libroot_get_jbroot_prefix");
        OMCStringFn bu = (OMCStringFn)dlsym(h, "libroot_get_boot_uuid");
        OMCPathFn   jb = (OMCPathFn)dlsym(h, "libroot_jbrootpath");
        OMCPathFn   rf = (OMCPathFn)dlsym(h, "libroot_rootfspath");
        if (rp && jp && bu && jb && rf) {
            gRootPrefixFn = rp; gJBRootPrefixFn = jp; gBootUUIDFn = bu;
            gJBRootPathFn = jb; gRootFSPathFn = rf;
        } else {
            gRootPrefixFn = OMCFallbackRootPrefix;
            gJBRootPrefixFn = OMCFallbackJBRootPrefix;
            gBootUUIDFn = OMCFallbackBootUUID;
            gJBRootPathFn = OMCFallbackJBRootPath;
            gRootFSPathFn = OMCFallbackRootFSPath;
        }
    });
}

// sub_4118: dispatch_once + tail-call through gJBRootPathFn.
static char *OMCJBRootPath(const char *path, char *out) {
    OMCJBRootInit();
    return gJBRootPathFn(path, out);
}

#pragma mark - Preferences — VERIFIED

// _OMCPrefsSync @ 0x6528 (12 bytes: a single tail branch).
void OMCPrefsSync(void) {
    CFPreferencesAppSynchronize(kOMCPrefsDomain);
}

// _OMCPref @ 0x6534
id OMCPref(id key, id def) {
    id v = CFBridgingRelease(CFPreferencesCopyAppValue((CFStringRef)key,
                                                       kOMCPrefsDomain));
    return v != nil ? v : def;
}

#pragma mark - Expiry — VERIFIED

static BOOL   gExpiredLatch;          // bss+0x200 (VA 0x18700)
static double gExpiryDeadline;        // bss+0x228 (VA 0x18728), epoch seconds
static dispatch_once_t gExpiryOnce;   // bss+0x230 (VA 0x18730)

// _OMCExpired @ 0xc414; deadline computation = the dispatch_once block
// (block literal @0x14868, invoke sub_cef8).
BOOL OMCExpired(void) {
    if (gExpiredLatch) return YES;
    dispatch_once(&gExpiryOnce, ^{
        // Deadline date string is the constant @"2027-04-30"; the guard is
        // what the machine code does (an empty string leaves the deadline
        // unset -> fail-open).
        NSString *dateStr = @"2027-04-30";
        if (dateStr.length == 0) return;
        NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
        fmt.locale = [NSLocale localeWithLocaleIdentifier:@"en_US_POSIX"];
        fmt.dateFormat = @"yyyy-MM-dd";
        fmt.timeZone = [NSTimeZone timeZoneForSecondsFromGMT:25200]; // GMT+7
        NSDate *d = [fmt dateFromString:dateStr];
        gExpiryDeadline = [d timeIntervalSince1970] + 86400.0;
        // = 1809104400 (2027-05-01 00:00:00 GMT+7)
    });
    if (gExpiryDeadline <= 0) return NO; // fail-open
    double effNow = [[NSDate date] timeIntervalSince1970];
    id stored = OMCPref(@"trustedTime", nil);
    if ([stored isKindOfClass:[NSNumber class]]) {
        double sv = [stored doubleValue];
        if (sv > effNow) effNow = sv; // trusted time can only push time forward
    }
    if (effNow >= gExpiryDeadline) {
        gExpiredLatch = YES;
        return YES;
    }
    return NO;
}

#pragma mark - Switches — VERIFIED

// _OMCEnabled @ 0x659c
BOOL OMCEnabled(void) {
    if (OMCExpired()) return NO;
    return [OMCPref(@"enabled", (id)kCFBooleanTrue) boolValue];
}

// _OMCFeatureEnabled @ 0x65f8
BOOL OMCFeatureEnabled(NSString *feature) {
    if (!OMCEnabled()) return NO;
    NSString *key = [feature stringByAppendingString:@"Enabled"];
    return [OMCPref(key, @YES) boolValue];
}

#pragma mark - Lite mode — VERIFIED

static BOOL   gLiteCached;            // bss+0x50
static double gLiteLastCheck;         // bss+0x58 (CFAbsoluteTime)
static int32_t gLiteNotifyToken = -1; // __data (VA 0x184F0), initial value -1

// _OMCLiteActive @ 0x6688
BOOL OMCLiteActive(void) {
    CFAbsoluteTime now = CFAbsoluteTimeGetCurrent();
    if (gLiteLastCheck != 0 && now - gLiteLastCheck < 3.0) return gLiteCached;
    gLiteLastCheck = now;
    OMCPrefsSync();
    NSInteger mode = [OMCPref(@"liteMode", @2) integerValue];
    BOOL result;
    if (mode == 1) {
        result = OMCEnabled();
    } else if (mode == 2) {
        if (!OMCEnabled()) {
            result = NO;
        } else if ([[NSProcessInfo processInfo] thermalState]
                       >= NSProcessInfoThermalStateSerious /* 2 */) {
            result = YES;
        } else {
            if (gLiteNotifyToken == -1) {
                if (notify_register_check("com.anlai.omnicar/lite",
                                          &gLiteNotifyToken) != 0) {
                    gLiteCached = NO;
                    return NO;
                }
            }
            uint64_t state = 0;
            notify_get_state(gLiteNotifyToken, &state);
            result = (state != 0);
        }
    } else {
        result = NO;
    }
    gLiteCached = result;
    return result;
}

#pragma mark - Car wireless heuristic — VERIFIED

// _OMCCarWireless @ 0x67e4. Reads the "diagCar" diagnostics dictionary that
// the connect-time recorder (see crash-guard section) maintains.
int OMCCarWireless(void) {
    id diag = OMCPref(@"diagCar", nil);
    if (![diag isKindOfClass:[NSDictionary class]]) return -1;
    for (NSString *sectionName in @[@"session", @"configuration"]) {
        id section = diag[sectionName];
        if (![section isKindOfClass:[NSDictionary class]]) continue;
        for (NSString *key in (NSDictionary *)section) {
            if (![key isKindOfClass:[NSString class]]) continue;
            NSString *lk = key.lowercaseString;
            NSString *lv = [[section[key] description] lowercaseString];
            if ([lk containsString:@"wireless"]) {
                if ([lv isEqualToString:@"1"] || [lv isEqualToString:@"0"])
                    return [lv isEqualToString:@"1"] ? 1 : 0;
            } else if ([lk containsString:@"wired"]) {
                if ([lv isEqualToString:@"1"] || [lv isEqualToString:@"0"])
                    return [lv isEqualToString:@"1"] ? 0 : 1;
            } else if ([lk containsString:@"transport"]) {
                if ([lv containsString:@"wifi"] ||
                    [lv containsString:@"wireless"] ||
                    [lv containsString:@"wi-fi"])
                    return 1;
                if ([lv containsString:@"usb"] || [lv containsString:@"wired"])
                    return 0;
            }
        }
    }
    return -1;
}

#pragma mark - Logging — VERIFIED

// Forward declaration: crash-guard state (defined in the crash section).
// In OmniCarCore's OMCLogWrite the getter is called and the result
// DISCARDED; the other five modules use it to stamp lastFeature.
static void *OMCCrashStatePtr(void);

static NSDateFormatter *gLogFormatter;      // bss+0x60
static dispatch_once_t gLogFormatterOnce;   // bss+0x68
static dispatch_queue_t gLogQueue;          // bss+0xC0
static dispatch_once_t gLogQueueOnce;       // bss+0xC8
static BOOL gIsSpringBoard;                 // bss+0xD0
static dispatch_once_t gSpringBoardOnce;    // bss+0xD8

// sub_c400 / block sub_929c
static void OMCLogInitOnce(void) {
    dispatch_once(&gSpringBoardOnce, ^{
        gIsSpringBoard =
            [[[NSBundle mainBundle] bundleIdentifier]
                isEqualToString:@"com.apple.springboard"];
    });
}

// sub_6dd0
static dispatch_queue_t OMCLogQueue(void) {
    dispatch_once(&gLogQueueOnce, ^{
        gLogQueue = dispatch_queue_create("com.anlai.omnicar.log", NULL);
    });
    return gLogQueue;
}

// sub_705c: the class is looked up by name (not linked directly).
static id OMCDistributedCenter(void) {
    return [NSClassFromString(@"NSDistributedNotificationCenter")
        defaultCenter];
}

// sub_6fec
static BOOL OMCAppendLogLine(NSString *line) {
    FILE *f = fopen("/var/mobile/Documents/OmniCar.log", "a");
    if (f) {
        fputs(line.UTF8String, f);
        fclose(f);
    }
    return f != NULL;
}

// sub_6f2c. (The ".old" path is the log path with @".old" appended —
// INFERRED construction; the 2 MiB threshold and remove+move are VERIFIED.)
static void OMCRotateLogIfNeeded(void) {
    NSString *path = @"/var/mobile/Documents/OmniCar.log";
    NSDictionary *attrs =
        [[NSFileManager defaultManager] attributesOfItemAtPath:path error:nil];
    if ([attrs fileSize] >= 0x200000 /* 2 MiB */) {
        NSString *old = [path stringByAppendingString:@".old"];
        [[NSFileManager defaultManager] removeItemAtPath:old error:nil];
        [[NSFileManager defaultManager] moveItemAtPath:path toPath:old
                                                 error:nil];
    }
}

// _OMCLogWrite @ 0x6be4 (Core: 424 bytes; other modules: 452 bytes — the
// only one of the 20 shared functions that differs between binaries).
void OMCLogWrite(NSString *tag, NSString *msg) {
#ifdef OMC_MODULE_NAME
    // Variant compiled into SplitScreen / AppBridge / SpeedBubble /
    // CarProbe / StartupScreen: stamp the crash state's lastFeature with
    // this module's name ("AppBridge", "SplitScreen", "SpeedBubble",
    // "CarProbe", "StartupScreen") via __strlcpy_chk(state + 0x400, name,
    // 0x40, 0x40). This is the writer of the "last=" field in crash markers.
    void *st = OMCCrashStatePtr();
    if (st) {
        // Original: __strlcpy_chk(state + 0x400, name, 0x40, 0x40).
        strlcpy((char *)st + 0x400, OMC_MODULE_NAME, 0x40);
    }
#else
    (void)OMCCrashStatePtr(); // Core calls the getter and discards it.
#endif
    NSLog(@"[OmniCar/%@] %@", tag, msg);
    dispatch_once(&gLogFormatterOnce, ^{
        gLogFormatter = [[NSDateFormatter alloc] init];
        gLogFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss.SSS";
    });
    NSString *line = [NSString stringWithFormat:@"%@ [%@:%d] %@: %@\n",
                      [gLogFormatter stringFromDate:[NSDate date]],
                      [[NSProcessInfo processInfo] processName],
                      getpid(), tag, msg];
    dispatch_async(OMCLogQueue(), ^{ // block invoke sub_6e14
        OMCLogInitOnce();
        if (gIsSpringBoard == 1) OMCRotateLogIfNeeded();
        if (OMCAppendLogLine(line)) return;
        OMCLogInitOnce();
        if (gIsSpringBoard) return; // SpringBoard gives up silently
        [OMCDistributedCenter()
            postNotificationName:@"com.anlai.omnicar/log"
                          object:nil
                        userInfo:@{@"line" : line}];
    });
}

// _OMCLogRelayStart @ 0x7088 (SpringBoard only)
void OMCLogRelayStart(void) {
    OMCLogInitOnce();
    if (gIsSpringBoard != 1) return;
    [OMCDistributedCenter()
        addObserverForName:@"com.anlai.omnicar/log"
                    object:nil
                     queue:nil
                usingBlock:^(NSNotification *notif) { // sub_710c
                    id line = notif.userInfo[@"line"];
                    if ([line isKindOfClass:[NSString class]]) {
                        dispatch_async(OMCLogQueue(), ^{ // sub_71e8
                            OMCRotateLogIfNeeded();
                            OMCAppendLogLine(line);
                        });
                    }
                }];
    // The returned observer token is deliberately discarded (unsafe-claimed
    // in the original): the relay lives for the process lifetime.
}

#pragma mark - CarPlay class / selector resolution — VERIFIED

// _OMCCarClass @ 0x72c0
Class OMCCarClass(const char *name) {
    Class cls = objc_getClass(name);
    if (cls) return cls;
    NSString *n = [NSString stringWithUTF8String:name];
    if ([n isEqualToString:@"DashBoard"]) {
        return objc_getClass("CARApplication");
    }
    if ([n hasPrefix:@"DB"]) {
        NSString *rest = [n substringFromIndex:2];
        if (rest) {
            Class c = objc_getClass(
                [[@"CAR" stringByAppendingString:rest] UTF8String]);
            if (c) return c;
            return objc_getClass(
                [[@"_CAR" stringByAppendingString:rest] UTF8String]);
        }
    }
    return nil;
}

// _OMCHasMethod @ 0x720c
BOOL OMCHasMethod(const char *className, NSString *selectorName) {
    Class cls = OMCCarClass(className);
    if (!cls) return NO;
    Method m;
    if ([selectorName hasPrefix:@"+"]) {
        m = class_getClassMethod(
            cls, NSSelectorFromString([selectorName substringFromIndex:1]));
    } else {
        m = class_getInstanceMethod(cls, NSSelectorFromString(selectorName));
    }
    return m != NULL;
}

// _OMCCheckHooks @ 0x7408
static NSMutableDictionary *gHookDiag; // bss+0x70, lazily created, unsynchronised

void OMCCheckHooks(NSString *tag, NSArray<NSString *> *specs) {
    NSMutableArray<NSString *> *missing = [NSMutableArray array];
    NSMutableOrderedSet<NSString *> *renamed = [NSMutableOrderedSet orderedSet];
    for (NSString *spec in specs) {
        NSArray<NSString *> *parts = [spec componentsSeparatedByString:@" "];
        if (parts.count != 2) continue;
        Class cls = OMCCarClass(parts[0].UTF8String);
        if (cls && ![NSStringFromClass(cls) isEqualToString:parts[0]]) {
            [renamed addObject:[NSString stringWithFormat:@"%@=%@",
                                        parts[0], NSStringFromClass(cls)]];
        }
        NSString *selName = parts[1];
        if ([selName hasPrefix:@"-"]) selName = [selName substringFromIndex:1];
        // ("+" is passed through; OMCHasMethod interprets it.)
        if (!OMCHasMethod(parts[0].UTF8String, selName)) {
            [missing addObject:spec];
        }
    }
    NSString *ios = [UIDevice currentDevice].systemVersion;
    if (!gHookDiag) gHookDiag = [NSMutableDictionary dictionary];
    NSString *key = [NSString stringWithFormat:@"%@%@@%@", @"diagHooks.", tag,
                       [[NSProcessInfo processInfo] processName]];
    NSMutableDictionary *entry = gHookDiag[key];
    if (!entry) {
        entry = [@{@"total" : @0, @"missing" : [NSMutableArray array]} mutableCopy];
        gHookDiag[key] = entry;
    }
    entry[@"ios"] = ios;
    entry[@"total"] = @([entry[@"total"] unsignedIntegerValue] + specs.count);
    [entry[@"missing"] addObjectsFromArray:missing];
    CFPreferencesSetAppValue((CFStringRef)key, (CFPropertyListRef)entry,
                             kOMCPrefsDomain);
    OMCPrefsSync();
    if (renamed.count) {
        OMCLogWrite(tag, [NSString stringWithFormat:@"iOS %@: lop CarPlay %@",
                                  ios,
                                  [renamed.array
                                      componentsJoinedByString:@", "]]);
    }
    if (missing.count) {
        OMCLogWrite(tag,
            [NSString stringWithFormat:
                @"iOS %@: %lu/%lu hook KHONG co tren iOS nay "
                 "(tinh nang lien quan se khong chay): %@",
                ios, (unsigned long)missing.count, (unsigned long)specs.count,
                [missing componentsJoinedByString:@", "]]);
    } else {
        OMCLogWrite(tag, [NSString stringWithFormat:@"iOS %@: du %lu hook",
                                  ios, (unsigned long)specs.count]);
    }
}

// _OMCMissingSelector @ 0x7af8
static NSMutableSet *gSeenMissing;        // bss+0x78
static dispatch_once_t gSeenMissingOnce;  // bss+0x80

void OMCMissingSelector(NSString *tag, id object, NSString *selectorName) {
    if (!object) return;
    dispatch_once(&gSeenMissingOnce, ^{
        gSeenMissing = [NSMutableSet set];
    });
    NSString *key = [NSString stringWithFormat:@"%@ %@",
                       NSStringFromClass([object class]), selectorName];
    @synchronized(gSeenMissing) {
        if ([gSeenMissing containsObject:key]) return;
        [gSeenMissing addObject:key];
    }
    OMCLogWrite(tag, [NSString stringWithFormat:
                          @"THIEU METHOD (iOS %@): %@ -> bo qua",
                          [UIDevice currentDevice].systemVersion, key]);
}

// Private CarPlay class API used by OMCCarLaunchInfo (declared here so
// the reconstruction type-checks; the original resolves it dynamically).
@interface NSObject (OMCCarLaunchInfoPrivate)
+ (id)launchInfoForApplication:(id)application;
+ (id)launchInfoForApplication:(id)application
       withActivationSettings:(id)settings;
@end

// _OMCCarLaunchInfo @ 0x7cd8
id OMCCarLaunchInfo(id application) {
    if (!application) return nil;
    Class cls = OMCCarClass("DBApplicationLaunchInfo");
    SEL s1 = @selector(launchInfoForApplication:);
    if ([(id)cls respondsToSelector:s1]) {
        return [(id)cls launchInfoForApplication:application];
    }
    SEL s2 = @selector(launchInfoForApplication:withActivationSettings:);
    if ([(id)cls respondsToSelector:s2]) {
        return [(id)cls launchInfoForApplication:application
                         withActivationSettings:nil];
    }
    OMCLogWrite(@"Core", [NSString stringWithFormat:
                              @"THIEU METHOD: %@ khong tao duoc launchInfo",
                              cls]);
    return nil;
}

#pragma mark - Crash guard — VERIFIED (state machine and handlers)
//
// State lives OUTSIDE the heap object graph on purpose: a raw allocation
// whose address is passed between processes/launches through the
// OMC_CRASHGUARD environment variable (hex string), so a handler running
// in a dying process can still find it.

typedef struct {
    char path[0x400];       // +0x000: crash marker file path
    char lastFeature[0x40]; // +0x400: last feature that logged (see the
                            // OMCLogWrite stamp variant)
    time_t startTime;       // +0x440: process start (time(NULL))
} OMCCrashState;            // sizeof = 0x448

static OMCCrashState *gCrashState; // bss+0xF0 (cached)

static BOOL gIsCarPlayApp;                 // bss+0xE0
static dispatch_once_t gIsCarPlayAppOnce;  // bss+0xE8
static void (*gPrevExceptionHandler)(NSException *); // bss+0xF8

// sub_8f7c: env-pointer getter. Returns NULL if OMC_CRASHGUARD is unset or
// parses to 0; caches the parsed pointer.
static void *OMCCrashStatePtr(void) {
    if (!gCrashState) {
        const char *e = getenv("OMC_CRASHGUARD");
        if (e) {
            gCrashState =
                (OMCCrashState *)(uintptr_t)strtoull(e, NULL, 16);
        }
    }
    return gCrashState;
}

// sub_8fc0
static NSString *OMCCrashStateFilePath(void) {
    return [[NSTemporaryDirectory()
        stringByAppendingPathComponent:@"OmniCar-crashguard.plist"] copy];
}

// sub_9a54: appends one marker line. `suspect` = the module name of the
// first stack frame whose image is "OmniCar<Name>.dylib", minus the
// "OmniCar" prefix and ".dylib" suffix (<= 63 chars).
static void OMCWriteCrashMarker(int fd, const char *how, void **frames,
                                int count) {
    char suspect[64] = "";
    for (int i = 0; i < count; i++) {
        Dl_info info;
        if (!dladdr(frames[i], &info) || !info.dli_fname) continue;
        const char *base = strrchr(info.dli_fname, '/');
        base = base ? base + 1 : info.dli_fname;
        size_t len = strlen(base);
        if (strncmp(base, "OmniCar", 7) == 0 && len >= 14 &&
            strcmp(base + len - 6, ".dylib") == 0) {
            size_t n = len - 13; // strip "OmniCar" (7) + ".dylib" (6)
            if (n > 63) n = 63;
            memcpy(suspect, base + 7, n);
            suspect[n] = '\0';
            break;
        }
    }
    OMCCrashState *st = OMCCrashStatePtr();
    long age = st ? (long)(time(NULL) - st->startTime) : 0;
    dprintf(fd, "omc-crash age=%ld suspect=%s last=%s how=%s\n", age, suspect,
            st ? st->lastFeature : "", how);
}

// sub_935c: chained uncaught-exception handler.
static void OMCExceptionHandler(NSException *exc) {
    OMCCrashState *st = OMCCrashStatePtr();
    if (st) {
        int fd = open(st->path, 0x209 /* O_WRONLY|O_CREAT|O_APPEND */, 0644);
        if (fd >= 0) {
            NSArray<NSNumber *> *addrs = [exc callStackReturnAddresses];
            NSUInteger n = addrs.count > 64 ? 64 : addrs.count;
            void *frames[64];
            for (NSUInteger i = 0; i < n; i++)
                frames[i] = (void *)(uintptr_t)addrs[i].unsignedLongLongValue;
            OMCWriteCrashMarker(fd, "exception", frames, (int)n);
            NSString *s = [NSString
                stringWithFormat:@"uncaught %@: %@\n%@\n", exc.name, exc.reason,
                                 [exc.callStackSymbols
                                     componentsJoinedByString:@"\n"]];
            dprintf(fd, "%s", s.UTF8String);
            close(fd);
        }
    }
    if (gPrevExceptionHandler) gPrevExceptionHandler(exc);
}

// sub_95bc: SA_SIGINFO handler. siginfo field offsets are the Darwin
// layout as read by the machine code (code at +8, addr at +24).
static void OMCSignalHandler(int sig, siginfo_t *info, void *ucontext) {
    (void)ucontext;
    OMCCrashState *st = OMCCrashStatePtr();
    if (st) {
        int fd = open(st->path, 0x209, 0644);
        if (fd >= 0) {
            void *bt[64];
            int n = backtrace(bt, 64);
            char how[32];
            snprintf(how, sizeof(how), "signal-%d", sig);
            OMCWriteCrashMarker(fd, how, bt, n);
            int code = info ? *(int *)((char *)info + 8) : 0;
            void *addr = info ? *(void **)((char *)info + 24) : NULL;
            dprintf(fd, "signal %d (code %d) addr %p pid %d\n", sig, code,
                    addr, getpid());
            backtrace_symbols_fd(bt, n, fd);
            uint32_t images = _dyld_image_count();
            for (uint32_t i = 0; i < images; i++) {
                const struct mach_header *h = _dyld_get_image_header(i);
                size_t size = 0;
                const uint8_t *ci = getsectiondata(
                    (const struct mach_header_64 *)h, "__DATA",
                    "__crash_info", &size);
                if (!ci)
                    ci = getsectiondata((const struct mach_header_64 *)h,
                                        "__DATA_DIRTY", "__crash_info", &size);
                if (ci && size >= 0x28) {
                    const char *name = _dyld_get_image_name(i);
                    const char *base = strrchr(name, '/');
                    base = base ? base + 1 : name;
                    const char *m1 = *(const char **)(ci + 8);
                    const char *m2 = *(const char **)(ci + 0x20);
                    if (m1 && *m1)
                        dprintf(fd, "crash_info [%s]: %s\n", base, m1);
                    if (m2 && *m2)
                        dprintf(fd, "crash_info [%s]: %s\n", base, m2);
                }
            }
            close(fd);
        }
    }
    signal(sig, SIG_DFL);
    raise(sig);
}

// --- Performance / car-diagnostics statics (shared by the screen handlers)
// All offsets VERIFIED by the stub-closure pass (sub_9bc0 / sub_af54 /
// sub_b23c / sub_b40c / sub_b864 / sub_9814 dumps). bss starts at VA 0x18500.
static UIScreen *gPerfSessionObject;     // bss+0x88 (the external screen; released on disconnect)
static CADisplayLink *gPerfDisplayLink;  // bss+0x90 — a CADisplayLink, NOT an
                                         // NSTimer (created in sub_b40c via
                                         // -[UIScreen displayLinkWithTarget:selector:])
static dispatch_source_t gPerfSource;    // bss+0x98
static NSDate *gSessionStart;            // bss+0xA0
static NSArray *gSessionTweaks;          // bss+0xA8 (other tweaks found in CarPlayApp)
static NSMutableDictionary *gStatHangWho;// bss+0xB0 (hang culprit -> count)
static NSString *gLiteReason;            // bss+0xB8 (last auto-lite reason)
static id gSessionStatus;                // bss+0x100 (CARSessionStatus instance)
static long gDisconnectCount;            // bss+0x108 — session-generation counter:
                                         // incremented on connect (sub_9bc0)
                                         // AND on disconnect (sub_9814)
static double gStatFrameInterval;        // +0x110 (1 / maxFPS, seconds)
static double gStatWorstMs;              // +0x118 (worst frame gap, ms; diagPerf "worstMs")
static double gStatLateFrames;           // +0x120 (summary arg 2: "tre %.0f"; diagPerf "late")
static double gStatFrames;               // +0x128 (summary arg 3: "/%.0f khung"; diagPerf "frames")
static double gStatLastTick;             // +0x130 (last display-link tick, monotonic s)
static double gStatHangMaxMs;            // +0x138 (summary arg 5: "max %.0f ms"; diagPerf "hangMaxMs")
static double gStatFreezes;              // +0x140 (gaps >= 2 s; diagPerf "freezes")
static double gStatHangs;                // +0x148 (gaps >= 0.5 s; summary arg 4: "do %.0f lan"; diagPerf "hangs")
static double gStatMemMB;                // +0x150 (PEAK phys_footprint MB; summary arg 7: "RAM %.0f MB"; diagPerf "memMaxMB")
static double gStatMemLastMB;            // +0x158 (latest phys_footprint MB; diagPerf "memMB")
static double gStatCPUMax;               // +0x160 (diagPerf "cpuMax")
static double gStatCPUSum;               // +0x168 (avg numerator; diagPerf "cpuAvg")
static double gStatSysFreeMinMB;         // +0x170 (min (free+inactive) pages, MB; diagPerf "sysFreeMinMB"; DBL_MAX = none)
static double gStatAvailMinMB;           // +0x178 (min os_proc_available_memory, MB; diagPerf "availMinMB"; DBL_MAX = none)
static long gStatCPUCount;               // +0x180 (sample count; the binary loads it as an integer)
static long gStatThermalMax;             // +0x188 (max NSProcessInfoThermalState)
static BOOL gStatLowPower;               // +0x190 (byte: low-power mode seen)
static double gLateAtLinkStart;          // +0x198 (late frames when the link window opened)
static double gFramesAtLinkStart;        // +0x1A0 (frames when the link window opened)
static double gStatLatePct;              // +0x1A8 (late-frame percent over the link window; reset to sentinel -8.5)
static double gHangTimes[3];             // +0x1B0/+0x1B8/+0x1C0 (sliding window of recent hang times)
static uint64_t gLiteCount;              // +0x1C8 (auto-lite activations; diagPerf "liteCount")
static uint8_t gAutoLiteOn;              // +0x1D0 (current auto-lite state byte)
static _Atomic uint8_t gSamplerMainBusy; // +0x1D1 (watchdog hop in flight)
static int32_t gSampleDivider;           // +0x1D4 (source fires; sample every 10th)
static mach_port_t gHostPort;            // +0x1E0 (cached mach_host_self)
static uint64_t gHostPageSize;           // +0x1E8 (cached host page size)
static double gLiteStateChangedAt;       // +0x1F0 (monotonic time of last auto-lite change)
static id gPerfTicker;                   // +0x1F8 (OMCPerfTicker instance for the display link)

// sub_b1e4: monotonic clock in seconds (mach_absolute_time based).
static double OMCMonotonicSeconds(void) {
    static mach_timebase_info_data_t sTimebase; // bss+0x1D8 (numer) / +0x1DC (denom)
    if (sTimebase.denom == 0) mach_timebase_info(&sTimebase);
    return (double)mach_absolute_time() * (double)sTimebase.numer /
           (double)sTimebase.denom / 1.0e9;
}

// sub_aee4: write side of the "com.anlai.omnicar/lite" notify state.
// NOTE: the writer keeps its OWN registration token (__data+0x4); the
// reader in OMCLiteActive uses a different token (__data+0x0) for the
// same name. Reproduced as-is.
static int32_t gLiteNotifySetToken = -1; // __data+0x4
static void OMCSetLiteNotifyState(int state) {
    if (gLiteNotifySetToken != -1) {
        notify_set_state(gLiteNotifySetToken, (uint64_t)state);
    } else if (notify_register_check("com.anlai.omnicar/lite",
                                     &gLiteNotifySetToken) == 0 &&
               gLiteNotifySetToken != -1) {
        notify_set_state(gLiteNotifySetToken, (uint64_t)state);
    }
    notify_post("com.anlai.omnicar/lite");
}

// sub_b864: flushes the session's perf statistics to the "diagPerf" pref.
/* closed by stub-closure pass: full value assembly read line-by-line from
 * the sub_b864 dump — session gate (>= 30 s), all 22 verified keys with
 * their exact value sources, the cpuCount!=0 gate around the CPU/memory
 * block, and the DBL_MAX sentinel handling for the two min trackers. */
static void OMCFlushPerfStats(void) {
    if (!gSessionStart) return;
    double elapsed = -[gSessionStart timeIntervalSinceNow];
    if (elapsed < 30.0) return;
    NSMutableDictionary *d = [NSMutableDictionary dictionary];
    d[@"start"] = gSessionStart;
    d[@"updated"] = [NSDate date];
    d[@"seconds"] = @(llrint(elapsed));
    d[@"fps"] = @(llrint(1.0 / gStatFrameInterval));
    d[@"frames"] = @(llrint(gStatFrames));
    d[@"late"] = @(llrint(gStatLateFrames));
    d[@"worstMs"] = @(llrint(gStatWorstMs));
    d[@"hangs"] = @(llrint(gStatHangs));
    d[@"freezes"] = @(llrint(gStatFreezes));
    d[@"hangMaxMs"] = @(llrint(gStatHangMaxMs));
    if (gStatHangWho.count > 0) d[@"hangWho"] = [gStatHangWho copy];
    if (gStatCPUCount != 0) {
        d[@"cpuAvg"] = @(llrint(gStatCPUSum / (double)gStatCPUCount));
        d[@"cpuMax"] = @(llrint(gStatCPUMax));
        d[@"memMB"] = @(llrint(gStatMemLastMB));
        d[@"memMaxMB"] = @(llrint(gStatMemMB));
        d[@"availMinMB"] = @(gStatAvailMinMB < DBL_MAX
                                 ? llrint(gStatAvailMinMB) : 0);
        d[@"sysFreeMinMB"] = @(gStatSysFreeMinMB < DBL_MAX
                                   ? llrint(gStatSysFreeMinMB) : 0);
    }
    d[@"thermalMax"] = @(gStatThermalMax);
    d[@"lowPower"] = @(gStatLowPower);
    d[@"tweaks"] = gSessionTweaks ?: @[];
    d[@"liteCount"] = @(gLiteCount);
    if (gLiteReason) d[@"liteReason"] = gLiteReason;
    CFPreferencesSetAppValue(CFSTR("diagPerf"), (CFPropertyListRef)d,
                             kOMCPrefsDomain);
    CFPreferencesAppSynchronize(kOMCPrefsDomain);
}

// sub_bde0: auto-lite state setter. (The decision logic that calls this
// lives in the perf-sample consumer, sub_b40c — see OMCPerfSampleConsume.)
// The second parameter is an NSString reason, not an int: the previous
// (int, int) prototype was a stub artefact, corrected by this pass; the
// disconnect call site passes nil.
/* closed by stub-closure pass: change-only state transition — no-op when
 * the state byte already matches; on enable it bumps gLiteCount, stores
 * the reason and posts lite=1 via sub_aee4; the log line appends
 * " vi <reason>" only in the enable branch. */
static void OMCAutoLiteEvaluate(int on, NSString *reason) {
    if ((uint8_t)on == gAutoLiteOn) return; // no change: no-op
    gAutoLiteOn = (uint8_t)on;
    gLiteStateChangedAt = OMCMonotonicSeconds();
    NSString *suffix;
    NSString *word;
    if (on) {
        gLiteCount++;
        gLiteReason = reason;
        OMCSetLiteNotifyState(1);
        suffix = [@" vi " stringByAppendingString:reason];
        word = @"BAT";
    } else {
        OMCSetLiteNotifyState(0);
        suffix = @"";
        word = @"tat";
    }
    OMCLogWrite(@"Core", [NSString stringWithFormat:
                             @"che do nhe tu dong: %@%@", word, suffix]);
}

#pragma mark - Perf sampler cluster (installed by sub_9bc0; decoded by the stub-closure pass)

// sub_b23c: main-queue hang watchdog. The perf source handler hops here
// with its fire time; a long gap means the main queue was blocked.
static void OMCHangWatchdog(double firedAt) {
    double gap = OMCMonotonicSeconds() - firedAt;
    atomic_store_explicit(&gSamplerMainBusy, 0, memory_order_release); // stlrb in the original
    if (gap < 0.5 || !gPerfSessionObject) return;
    gStatHangs += 1.0;
    if (gap >= 2.0) gStatFreezes += 1.0;
    if (gap * 1000.0 > gStatHangMaxMs) gStatHangMaxMs = gap * 1000.0;
    OMCCrashState *st = (OMCCrashState *)OMCCrashStatePtr();
    NSString *who = (st && st->lastFeature[0])
                        ? [NSString stringWithUTF8String:st->lastFeature]
                        : @"-";
    gStatHangWho[who] = @([gStatHangWho[who] integerValue] + 1);
    gHangTimes[0] = gHangTimes[1];
    gHangTimes[1] = gHangTimes[2];
    gHangTimes[2] = OMCMonotonicSeconds();
    if (gap >= 2.0) {
        OMCLogWrite(@"Core", [NSString stringWithFormat:
                                 @"CarPlay do %.1fs (OmniCar gan nhat: %@)",
                                 gap, who]);
    }
}

// sub_bf98: -[OMCPerfTicker tick:] IMP (installed via
// imp_implementationWithBlock; the block ignores its arguments and calls
// this). Counts frames from display-link cadence; a gap over 1.5 frame
// intervals adds the missed frames as late.
static void OMCPerfTickerTick(void) {
    double now = OMCMonotonicSeconds();
    if (gStatLastTick > 0) {
        double dt = now - gStatLastTick;
        double missed = 0;
        if (dt > gStatFrameInterval * 1.5)
            missed = round(dt / gStatFrameInterval) - 1.0; // frinta in the original
        gStatFrames += missed + 1.0;
        gStatLateFrames += missed;
        if (dt * 1000.0 > gStatWorstMs) gStatWorstMs = dt * 1000.0;
    }
    gStatLastTick = now;
}

// Creates the OMCPerfTicker class on first use (sub_b40c tail).
static void OMCEnsurePerfTicker(void) {
    if (gPerfTicker) return;
    Class cls = objc_getClass("OMCPerfTicker");
    if (!cls) {
        cls = objc_allocateClassPair([NSObject class], "OMCPerfTicker", 0);
        SEL sel = sel_registerName("tick:");
        IMP imp = imp_implementationWithBlock(
            ^(id _self, id link) { OMCPerfTickerTick(); });
        class_addMethod(cls, sel, imp, "v@:@");
        objc_registerClassPair(cls);
    }
    gPerfTicker = [cls new];
}

// sub_bf04: runs 10 s after the display link starts; ends the measurement
// window and computes the session's late-frame percentage.
static void OMCPerfLinkWindowEnd(long generation) {
    if (generation != gDisconnectCount) return;
    [gPerfDisplayLink invalidate];
    gPerfDisplayLink = nil;
    double framesDelta = gStatFrames - gFramesAtLinkStart;
    if (framesDelta < 100.0) return;
    double lateDelta = gStatLateFrames - gLateAtLinkStart;
    gStatLatePct = lateDelta * 100.0 / framesDelta;
}

// sub_b40c: main-queue consumer for one perf sample (fired every 10th
// source tick = every 2.5 s). Also drives auto-lite and lazily creates
// the display link on samples where (count % 6 == 4).
static void OMCPerfSampleConsume(double cpu, double memMB, double availMB,
                                 double sysFreeMB) {
    if (!gPerfSessionObject) return;
    gStatCPUCount++;
    if (cpu >= 0) {
        gStatCPUSum += cpu;
        if (cpu > gStatCPUMax) gStatCPUMax = cpu;
    }
    if (memMB >= 0) {
        gStatMemLastMB = memMB;
        if (memMB > gStatMemMB) gStatMemMB = memMB;
    }
    if (availMB > 0 && availMB < gStatAvailMinMB) gStatAvailMinMB = availMB;
    if (sysFreeMB >= 0 && sysFreeMB < gStatSysFreeMinMB)
        gStatSysFreeMinMB = sysFreeMB;
    NSProcessInfo *pi = [NSProcessInfo processInfo];
    NSProcessInfoThermalState thermal = [pi thermalState];
    if (thermal > gStatThermalMax) gStatThermalMax = thermal;
    if ([pi isLowPowerModeEnabled]) gStatLowPower = YES;
    if ((gStatCPUCount & 1) == 0) CFPreferencesAppSynchronize(kOMCPrefsDomain);
    // Auto-lite (pref "liteMode" == 2 and master switch on).
    if (OMCEnabled() && [OMCPref(@"liteMode", @2) integerValue] == 2) {
        double now = OMCMonotonicSeconds();
        if (thermal > 1) { // >= NSProcessInfoThermalStateSerious
            OMCAutoLiteEvaluate(1, @"heat");
        } else if (gHangTimes[0] > 0 && now - gHangTimes[0] < 120.0) {
            OMCAutoLiteEvaluate(1, @"hangs");
        } else if (gStatLatePct >= 15.0) {
            OMCAutoLiteEvaluate(1, @"frames");
        } else if (!((gHangTimes[2] != 0 && now - gHangTimes[2] <= 180.0) ||
                     gStatLatePct > 5.0 || !gAutoLiteOn ||
                     now - gLiteStateChangedAt <= 180.0)) {
            // No recent hang, frame rate acceptable, lite currently on and
            // unchanged for over 180 s: turn it back off.
            OMCAutoLiteEvaluate(0, nil);
        }
    } else {
        OMCAutoLiteEvaluate(0, nil);
    }
    // Display-link frame sampler, created once per session.
    if (gStatCPUCount % 6 == 4 && gPerfSessionObject && !gPerfDisplayLink) {
        OMCEnsurePerfTicker();
        gPerfDisplayLink = [gPerfSessionObject
            displayLinkWithTarget:gPerfTicker selector:@selector(tick:)];
        gStatLastTick = 0;
        gFramesAtLinkStart = gStatFrames;
        gLateAtLinkStart = gStatLateFrames;
        [gPerfDisplayLink addToRunLoop:[NSRunLoop mainRunLoop]
                               forMode:NSRunLoopCommonModes];
        long generation = gDisconnectCount;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 10000000000LL),
                       dispatch_get_main_queue(), ^{
                           OMCPerfLinkWindowEnd(generation);
                       });
    }
    if (gStatCPUCount % 6 == 0) OMCFlushPerfStats();
}

// sub_af54: perf dispatch-source event handler (250 ms timer on the
// "com.anlai.omnicar.perf" queue). Every fire hops to the main queue for
// the hang watchdog; every 10th fire takes a CPU/memory sample and hands
// it to OMCPerfSampleConsume on the main queue.
static void OMCPerfSourceFired(void) {
    double firedAt = OMCMonotonicSeconds();
    uint8_t expected = 0;
    if (atomic_compare_exchange_strong(&gSamplerMainBusy, &expected, 1)) {
        dispatch_async(dispatch_get_main_queue(), ^{
            OMCHangWatchdog(firedAt);
        });
    }
    int32_t n = ++gSampleDivider;
    if (n % 10 != 0) return;
    double cpu = -1.0, memMB = -1.0, sysFreeMB = -1.0;
    thread_act_array_t threads = NULL;
    mach_msg_type_number_t threadCount = 0;
    if (task_threads(mach_task_self(), &threads, &threadCount) ==
        KERN_SUCCESS) {
        cpu = 0.0;
        for (mach_msg_type_number_t i = 0; i < threadCount; i++) {
            thread_basic_info_data_t info;
            mach_msg_type_number_t infoCount = THREAD_BASIC_INFO_COUNT;
            if (thread_info(threads[i], THREAD_BASIC_INFO,
                            (thread_info_t)&info, &infoCount) ==
                    KERN_SUCCESS &&
                !(info.flags & TH_FLAGS_IDLE)) {
                cpu += (double)info.cpu_usage * 100.0 / 1000.0;
            }
            mach_port_deallocate(mach_task_self(), threads[i]);
        }
        vm_deallocate(mach_task_self(), (vm_address_t)threads,
                      threadCount * sizeof(thread_t));
    }
    task_vm_info_data_t vmInfo;
    mach_msg_type_number_t infoCount = TASK_VM_INFO_COUNT;
    if (task_info(mach_task_self(), TASK_VM_INFO, (task_info_t)&vmInfo,
                  &infoCount) == KERN_SUCCESS) {
        memMB = (double)vmInfo.phys_footprint * 1.0e-6;
    }
    if (gHostPort == 0) {
        gHostPort = mach_host_self();
        vm_size_t pageSize = 0;
        host_page_size(gHostPort, &pageSize);
        gHostPageSize = pageSize;
    }
    vm_statistics64_data_t vmStats;
    mach_msg_type_number_t statCount = HOST_VM_INFO64_COUNT;
    if (host_statistics64(gHostPort, HOST_VM_INFO64, (host_info64_t)&vmStats,
                          &statCount) == KERN_SUCCESS) {
        sysFreeMB = (double)(vmStats.free_count + vmStats.inactive_count) *
                    (double)gHostPageSize * 1.0e-6;
    }
    double availMB = (double)os_proc_available_memory() / 1048576.0;
    dispatch_async(dispatch_get_main_queue(), ^{
        OMCPerfSampleConsume(cpu, memMB, availMB, sysFreeMB);
    });
}

#pragma mark - Car probing helpers (sub_9bc0 cluster; decoded by the stub-closure pass)

// sub_c2bc: snapshot of the current values of all profile keys.
static NSDictionary *OMCProfileValuesSnapshot(void) {
    NSMutableDictionary *values = [NSMutableDictionary dictionary];
    for (NSString *key in OMCProfileKeys()) {
        id v = OMCPref(key, nil);
        if (v) values[key] = v;
    }
    return values;
}

// sub_c038: first usable string for any of `keys`, searching the
// "configuration" section of `dict` first, then "session". The probe
// dictionaries store -description strings, so "nil" / "(null)" and empty
// strings do not count.
static NSString *OMCFirstProbeValue(NSDictionary *dict,
                                    NSArray<NSString *> *keys) {
    for (NSString *section in @[ @"configuration", @"session" ]) {
        id sub = dict[section];
        if (![sub isKindOfClass:[NSDictionary class]]) continue;
        for (NSString *key in keys) {
            id v = ((NSDictionary *)sub)[key];
            if ([v isKindOfClass:[NSString class]] &&
                [(NSString *)v length] > 0 &&
                ![v isEqualToString:@"nil"] &&
                ![v isEqualToString:@"(null)"]) {
                return v;
            }
        }
    }
    return nil;
}

// sub_abf4: snapshot an object's properties into a flat string
// dictionary. Walks the class hierarchy from the object's class up to
// (but excluding) NSObject; per property keeps the most-derived value.
// Only object-typed, non-pointer, non-block properties are read, via
// KVC; values are flattened to single-line descriptions of at most
// 160 chars + "...". Capped at 80 entries.
static NSDictionary *OMCProbeObject(id obj) {
    NSMutableDictionary *out = [NSMutableDictionary dictionary];
    for (Class cls = object_getClass(obj); cls && cls != [NSObject class];
         cls = class_getSuperclass(cls)) {
        if (out.count >= 80) break;
        unsigned int count = 0;
        objc_property_t *props = class_copyPropertyList(cls, &count);
        for (unsigned int i = 0; i < count; i++) {
            NSString *name =
                [NSString stringWithUTF8String:property_getName(props[i])];
            const char *attrs = property_getAttributes(props[i]);
            if (!attrs || attrs[0] != 'T') continue;
            if (attrs[1] == '^') continue;                   // pointer type
            if (attrs[1] == '@' && attrs[2] == '?') continue; // block type
            if (out[name]) continue;                          // most-derived wins
            if ([name hasPrefix:@"_"]) continue;
            if ([@[ @"description", @"debugDescription", @"hash",
                    @"superclass" ] containsObject:name])
                continue;
            @try {
                id value = [obj valueForKey:name];
                NSString *desc = value ? [value description] : @"nil";
                desc = [[desc componentsSeparatedByCharactersInSet:
                                  [NSCharacterSet newlineCharacterSet]]
                    componentsJoinedByString:@" "];
                if (desc.length >= 161)
                    desc = [[desc substringToIndex:160]
                        stringByAppendingString:@"..."];
                out[name] = desc;
            } @catch (id e) {
            }
        }
        free(props);
    }
    return out;
}

// sub_9bc0: connect-time car recorder, runs 4 s after a screen connects.
/* closed by stub-closure pass: the complete per-screen sequence was read
 * line-by-line from the sub_9bc0 dump — one-time session init (tweak
 * scan, statics reset incl. the -8.5 late-percent sentinel and the
 * DBL_MAX min trackers, 250 ms perf source on its own queue,
 * "car.connected" post), the diagCar record with the CarKit
 * session/configuration probe via the sub_abf4 property snapshotter, the
 * carProfiles load-or-create flow keyed by vehicle identifier (falling
 * back to "<name>|<pixels>"), and the closing "man xe" log line. */
static void OMCDiagCarRecordConnect(void) {
    for (UIScreen *screen in [UIScreen screens]) {
        if (screen == [UIScreen mainScreen]) continue;
        if (!gPerfSessionObject) {
            // --- one-time session init ---
            gPerfSessionObject = screen;
            gDisconnectCount++;
            gSessionStart = [NSDate date];
            // Other tweaks loaded into this process (dyld image scan).
            NSMutableOrderedSet *names = [NSMutableOrderedSet orderedSet];
            uint32_t imageCount = _dyld_image_count();
            for (uint32_t i = 0; i < imageCount; i++) {
                const char *image = _dyld_get_image_name(i);
                if (!image) continue;
                if (!strstr(image, "/DynamicLibraries/") &&
                    !strstr(image, "/TweakInject/"))
                    continue;
                NSString *base = [[[NSString stringWithUTF8String:image]
                                      lastPathComponent]
                    stringByDeletingPathExtension];
                if (![base hasPrefix:@"OmniCar"]) [names addObject:base];
            }
            gSessionTweaks = names.array;
            gStatHangWho = [NSMutableDictionary dictionary];
            long fps = [screen maximumFramesPerSecond];
            gStatFrameInterval = 1.0 / (fps > 1 ? fps : 1);
            gStatWorstMs = 0;
            gStatLateFrames = 0;
            gStatFrames = 0;
            gStatLastTick = 0;
            gStatHangMaxMs = 0;
            gStatFreezes = 0;
            gStatHangs = 0;
            gStatMemMB = 0;
            gStatMemLastMB = 0;
            gStatCPUMax = 0;
            gStatCPUSum = 0;
            gStatSysFreeMinMB = DBL_MAX;
            gStatAvailMinMB = DBL_MAX;
            gStatCPUCount = 0;
            gStatThermalMax = 0;
            gStatLowPower = NO;
            gLateAtLinkStart = 0;
            gFramesAtLinkStart = 0;
            gStatLatePct = -8.5;
            gHangTimes[0] = gHangTimes[1] = gHangTimes[2] = 0;
            gLiteCount = 0;
            gLiteReason = nil;
            gAutoLiteOn = 0;
            OMCSetLiteNotifyState(0);
            atomic_store_explicit(&gSamplerMainBusy, 0, memory_order_release);
            // Perf sampler: 250 ms timer on its own queue.
            dispatch_queue_t queue =
                dispatch_queue_create("com.anlai.omnicar.perf", NULL);
            gPerfSource = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER,
                                                 0, 0, queue);
            dispatch_source_set_timer(
                gPerfSource, dispatch_time(DISPATCH_TIME_NOW, 250000000),
                250000000, 50000000);
            dispatch_source_set_event_handler(gPerfSource, ^{
                OMCPerfSourceFired();
            });
            dispatch_resume(gPerfSource);
            notify_post("com.anlai.omnicar/car.connected");
            OMCLogWrite(@"Core",
                [NSString stringWithFormat:
                    @"do hieu nang: bat dau, %lu tweak khac trong CarPlay: %@",
                    (unsigned long)gSessionTweaks.count,
                    [gSessionTweaks componentsJoinedByString:@", "]]);
        }
        // --- diagCar record for this screen ---
        NSMutableDictionary *diag = [NSMutableDictionary dictionary];
        diag[@"date"] = [NSDate date];
        diag[@"connected"] = (id)kCFBooleanTrue;
        diag[@"ios"] = [UIDevice currentDevice].systemVersion;
        diag[@"points"] = [NSString stringWithFormat:@"%.0fx%.0f",
                               screen.bounds.size.width,
                               screen.bounds.size.height];
        diag[@"pixels"] = [NSString stringWithFormat:@"%.0fx%.0f",
                               screen.nativeBounds.size.width,
                               screen.nativeBounds.size.height];
        diag[@"scale"] = @(screen.scale);
        diag[@"maxFPS"] = @([screen maximumFramesPerSecond]);
        dlopen("/System/Library/PrivateFrameworks/CarKit.framework/CarKit",
               RTLD_LAZY);
        @try {
            Class statusClass = NSClassFromString(@"CARSessionStatus");
            if (!gSessionStatus && statusClass)
                gSessionStatus = [statusClass new];
            if ([gSessionStatus
                    respondsToSelector:NSSelectorFromString(
                                           @"currentSession")]) {
                id session = [gSessionStatus valueForKey:@"currentSession"];
                if (session) {
                    diag[@"session"] = OMCProbeObject(session);
                    if ([session respondsToSelector:NSSelectorFromString(
                                                        @"configuration")]) {
                        id config = [session valueForKey:@"configuration"];
                        if (config)
                            diag[@"configuration"] = OMCProbeObject(config);
                    }
                }
            }
        } @catch (id e) {
            OMCLogWrite(@"Core", [NSString stringWithFormat:@"CarKit loi: %@",
                                                            e]);
        }
        CFPreferencesSetAppValue(CFSTR("diagCar"), (CFPropertyListRef)diag,
                                 kOMCPrefsDomain);
        CFPreferencesAppSynchronize(kOMCPrefsDomain); // the original syncs twice here
        OMCPrefsSync();
        // --- per-car profiles ---
        if ([OMCPref(@"carProfilesEnabled", (id)kCFBooleanFalse) boolValue]) {
            NSString *name = OMCFirstProbeValue(diag, @[
                @"modelName", @"name", @"vehicleName", @"accessoryName",
                @"model"
            ]);
            NSString *ident = OMCFirstProbeValue(diag, @[
                @"vehicleIdentifier", @"identifier", @"uniqueIdentifier",
                @"accessoryID", @"deviceID", @"serialNumber"
            ]);
            NSString *profileKey =
                ident ?: [NSString stringWithFormat:@"%@|%@",
                              name ?: @"?", diag[@"pixels"] ?: @"?"];
            NSMutableDictionary *profiles = [NSMutableDictionary dictionary];
            id stored = OMCPref(@"carProfiles", nil);
            if ([stored isKindOfClass:[NSDictionary class]]) {
                for (NSString *k in (NSDictionary *)stored) {
                    id entry = ((NSDictionary *)stored)[k];
                    if ([entry isKindOfClass:[NSDictionary class]])
                        profiles[k] = [entry mutableCopy];
                }
            }
            // Leaving a car: snapshot the live values into its profile.
            NSString *currentKey = OMCPref(@"carProfileCurrent", nil);
            if ([currentKey isKindOfClass:[NSString class]]) {
                NSMutableDictionary *current = profiles[currentKey];
                if (current && ![currentKey isEqualToString:profileKey])
                    current[@"values"] = OMCProfileValuesSnapshot();
            }
            NSMutableDictionary *entry = profiles[profileKey];
            if (!entry) {
                entry = [@{@"values" : OMCProfileValuesSnapshot()} mutableCopy];
                profiles[profileKey] = entry;
                OMCLogWrite(@"Core",
                    [NSString stringWithFormat:@"ho so xe moi: %@ (%@)",
                                               name ?: @"?", profileKey]);
            } else if (![currentKey isEqual:profileKey]) {
                // Phase-2 re-check of the ORIGINAL OmniCarCore.dylib
                // (2026-11-08): sub_9bc0 at 0xa6c4-0xa6d0 calls
                // `isEqual:` (stub 0xdc60) on the RAW carProfileCurrent
                // pref value against the new profile key and branches
                // to 0xa8e4 (name/lastSeen stamping) when equal —
                // skipping the apply loop and its "nap ho so xe" log.
                // (The outgoing-car refresh above uses isEqualToString:
                // after an NSString check; this one does not.)
                NSDictionary *values = entry[@"values"];
                for (NSString *key in OMCProfileKeys()) {
                    id v = [values isKindOfClass:[NSDictionary class]]
                               ? values[key]
                               : nil;
                    CFPreferencesSetAppValue((CFStringRef)key,
                                             (CFPropertyListRef)v,
                                             kOMCPrefsDomain);
                }
                OMCLogWrite(@"Core",
                    [NSString stringWithFormat:@"nap ho so xe %@ (%@)",
                                               name ?: @"?", profileKey]);
            }
            entry[@"name"] = name ?: OMCTr(@"Xe", @"Car");
            entry[@"lastSeen"] = [NSDate date];
            CFPreferencesSetAppValue(CFSTR("carProfiles"),
                                     (CFPropertyListRef)profiles,
                                     kOMCPrefsDomain);
            CFPreferencesSetAppValue(CFSTR("carProfileCurrent"),
                                     (CFPropertyListRef)profileKey,
                                     kOMCPrefsDomain);
            CFPreferencesAppSynchronize(kOMCPrefsDomain);
            notify_post("com.anlai.omnicar/prefschanged");
        }
        OMCLogWrite(@"Core",
            [NSString stringWithFormat:
                @"man xe %@ pt, %@ px, %@ fps, session=%d", diag[@"points"],
                diag[@"pixels"], diag[@"maxFPS"], diag[@"session"] != nil]);
    }
}

// sub_97e4
static void OMCOnScreenConnected(void) {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 4000000000LL),
                   dispatch_get_main_queue(), ^{
                       OMCDiagCarRecordConnect();
                   });
}

// sub_9814 — VERIFIED structure. (Phase-2 re-check of the ORIGINAL
// OmniCarCore.dylib arm64 slice, 2026-11-08: the entry branch at
// 0x9868/0x986c loads gPerfSessionObject (bss+0x88) and `cbz` skips the
// whole teardown block 0x9870-0x9984 straight to the diagCar tail at
// 0x9988 when it is nil — the guard below is in the Core binary, it is
// NOT a SplitScreen-only variant.)
static void OMCOnScreenDisconnected(NSNotification *notif) {
    UIScreen *screen = notif.object;
    if (screen == [UIScreen mainScreen]) return; // only external screens
    if (gPerfSessionObject) {
        if (gPerfSource) {
            dispatch_source_cancel(gPerfSource);
            gPerfSource = nil;
        }
        [gPerfDisplayLink invalidate];
        gPerfDisplayLink = nil;
        gDisconnectCount++;
        OMCFlushPerfStats();
        double seconds = -[gSessionStart timeIntervalSinceNow];
        double avgCPU = gStatCPUCount ? gStatCPUSum / gStatCPUCount : 0;
        OMCLogWrite(@"Core",
            [NSString stringWithFormat:
                @"do hieu nang: %.0fs, tre %.0f/%.0f khung, do %.0f lan "
                 "(max %.0f ms), CPU tb %.0f%%, RAM %.0f MB",
                seconds, gStatLateFrames, gStatFrames, gStatHangs,
                gStatHangMaxMs, avgCPU, gStatMemMB]);
        OMCAutoLiteEvaluate(0, nil);
        gPerfSessionObject = nil;
    }
    NSMutableDictionary *d = [OMCPref(@"diagCar", nil) mutableCopy];
    if ([d isKindOfClass:[NSMutableDictionary class]]) {
        d[@"connected"] = (id)kCFBooleanFalse;
        d[@"disconnected"] = [NSDate date];
        CFPreferencesSetAppValue(CFSTR("diagCar"), (CFPropertyListRef)d,
                                 kOMCPrefsDomain);
        OMCPrefsSync();
    }
}

// _OMCCrashGuard @ 0x7de8 — VERIFIED (see header for the behaviour summary).
BOOL OMCCrashGuard(NSString *feature) {
    dispatch_once(&gIsCarPlayAppOnce, ^{ // block sub_92fc
        gIsCarPlayApp = [[[NSBundle mainBundle] bundleIdentifier]
            isEqualToString:@"com.apple.CarPlayApp"];
    });
    if (gIsCarPlayApp != 1 || feature.length == 0) return YES;

    OMCCrashState *st = (OMCCrashState *)OMCCrashStatePtr();
    if (!st) {
        // First call in this process: allocate the state, publish its
        // address via the environment, process any previous crash, arm
        // the handlers.
        st = calloc(1, 0x448);
        gCrashState = st;
        st->startTime = time(NULL);
        char hex[32];
        snprintf(hex, sizeof(hex), "%llx",
                 (unsigned long long)(uintptr_t)st);
        setenv("OMC_CRASHGUARD", hex, 1);
        NSString *markerPath = [NSTemporaryDirectory()
            stringByAppendingPathComponent:@"OmniCar-CarPlay-crash.txt"];
        strlcpy(st->path, markerPath.UTF8String, sizeof(st->path));

        NSString *stateFile = OMCCrashStateFilePath();
        NSMutableDictionary *dict =
            [NSMutableDictionary dictionaryWithContentsOfFile:stateFile]
                ?: [NSMutableDictionary dictionary];
        long early = [dict[@"early"] integerValue];
        NSMutableArray *suspects =
            [NSMutableArray arrayWithArray:dict[@"suspects"] ?: @[]];

        long minAge = INT64_MAX;
        NSString *suspectName = nil;
        // (File encoding UTF8 is INFERRED; content checks are VERIFIED.)
        NSString *text = [NSString stringWithContentsOfFile:markerPath
                                                   encoding:NSUTF8StringEncoding
                                                      error:nil];
        if (text.length) {
            OMCLogWrite(@"Core",
                [NSString stringWithFormat:@"CARPLAY SAP LAN TRUOC:\n%@",
                                           text]);
            NSDate *modDate =
                [[NSFileManager defaultManager]
                    attributesOfItemAtPath:markerPath
                                     error:nil][NSFileModificationDate]
                    ?: [NSDate date];
            unlink(st->path);
            NSString *suspectRaw = nil, *lastRaw = nil;
            for (NSString *line in [text componentsSeparatedByString:@"\n"]) {
                if (![line hasPrefix:@"omc-crash "]) continue;
                for (NSString *tok in
                     [line componentsSeparatedByString:@" "]) {
                    if ([tok hasPrefix:@"age="]) {
                        long a = [tok substringFromIndex:4].longLongValue;
                        if (a < minAge) minAge = a;
                    } else if (!suspectRaw && [tok hasPrefix:@"suspect="] &&
                               tok.length >= 9) {
                        suspectRaw = [tok substringFromIndex:8];
                    } else if (!lastRaw && [tok hasPrefix:@"last="] &&
                               tok.length >= 6) {
                        lastRaw = [tok substringFromIndex:5];
                    }
                }
            }
            NSString *raw = lastRaw ?: suspectRaw;
            if (raw.length) {
                suspectName = [[raw substringToIndex:1].lowercaseString
                    stringByAppendingString:[raw substringFromIndex:1]];
            }
            NSMutableDictionary *crashInfo =
                [@{@"date" : modDate} mutableCopy];
            if (minAge != INT64_MAX) crashInfo[@"age"] = @(minAge);
            if (suspectName) crashInfo[@"suspect"] = suspectName;
            CFPreferencesSetAppValue(CFSTR("diagLastCrash"),
                                     (CFPropertyListRef)crashInfo,
                                     kOMCPrefsDomain);
            if (minAge <= 59 && suspectName &&
                ![suspects containsObject:suspectName]) {
                [suspects addObject:suspectName];
            }
        }

        if (minAge < 60) {
            if (early >= 1) {
                // RESCUE: second consecutive early crash.
                NSArray *features = dict[@"features"] ?: @[];
                NSMutableOrderedSet *toDisable =
                    [NSMutableOrderedSet orderedSet];
                for (NSString *s in suspects)
                    if ([features containsObject:s]) [toDisable addObject:s];
                if (toDisable.count == 0) {
                    for (NSString *f in features) {
                        if ([OMCPref([f stringByAppendingString:@"Enabled"],
                                     (id)kCFBooleanTrue) boolValue])
                            [toDisable addObject:f];
                    }
                }
                if (toDisable.count > 0) {
                    id prev = OMCPref(@"rescueFeatures", nil);
                    NSMutableOrderedSet *prevSet =
                        [NSMutableOrderedSet orderedSetWithArray:
                            [prev isKindOfClass:[NSArray class]]
                                ? prev
                                : @[]];
                    for (NSString *f in toDisable) {
                        CFPreferencesSetAppValue(
                            (CFStringRef)
                                [f stringByAppendingString:@"Enabled"],
                            kCFBooleanFalse, kOMCPrefsDomain);
                        [prevSet addObject:f];
                    }
                    CFPreferencesSetAppValue(
                        CFSTR("rescueFeatures"),
                        (CFPropertyListRef)prevSet.array, kOMCPrefsDomain);
                    CFPreferencesSetAppValue(CFSTR("rescueDate"),
                                             (CFPropertyListRef)[NSDate date],
                                             kOMCPrefsDomain);
                    OMCPrefsSync();
                    OMCLogWrite(@"Core",
                        [NSString stringWithFormat:
                            @"CHE DO CUU: CarPlay sap %d lan lien trong %ds "
                             "dau -> tat %@",
                            2, 60,
                            [toDisable.array
                                componentsJoinedByString:@", "]]);
                    notify_post("com.anlai.omnicar/rescue");
                    notify_post("com.anlai.omnicar/prefschanged");
                    [suspects removeAllObjects];
                    early = 0;
                }
            } else {
                OMCLogWrite(@"Core",
                    [NSString stringWithFormat:
                        @"CarPlay sap som %ld/%d lan lien (nghi: %@)",
                        early + 1, 2,
                        [suspects componentsJoinedByString:@", "]]);
                early = early + 1;
            }
        } else {
            [suspects removeAllObjects];
            early = 0;
        }

        dict[@"early"] = @(early);
        dict[@"suspects"] = suspects;
        [dict writeToFile:stateFile atomically:YES];

        // Arm crash capture + screen observers.
        gPrevExceptionHandler = NSGetUncaughtExceptionHandler();
        NSSetUncaughtExceptionHandler(OMCExceptionHandler);
        static const int kSignals[6] = {11, 10, 6, 4, 5, 8}; // table @0xFAE8:
            // SIGSEGV, SIGBUS, SIGABRT, SIGILL, SIGTRAP, SIGFPE
        for (int i = 0; i < 6; i++) {
            struct sigaction sa;
            memset(&sa, 0, sizeof(sa));
            sa.sa_sigaction = OMCSignalHandler;
            sa.sa_flags = SA_SIGINFO; // 0x40
            sigaction(kSignals[i], &sa, NULL);
        }
        [[NSNotificationCenter defaultCenter]
            addObserverForName:UIScreenDidConnectNotification
                        object:nil
                         queue:[NSOperationQueue mainQueue]
                    usingBlock:^(NSNotification *n) {
                        OMCOnScreenConnected();
                    }];
        [[NSNotificationCenter defaultCenter]
            addObserverForName:UIScreenDidDisconnectNotification
                        object:nil
                         queue:[NSOperationQueue mainQueue]
                    usingBlock:^(NSNotification *n) {
                        OMCOnScreenDisconnected(n);
                    }];
        OMCOnScreenConnected();
    }

    // Register + gate: also the direct entry when the env pointer existed.
    NSString *stateFile = OMCCrashStateFilePath();
    NSMutableDictionary *dict =
        [NSMutableDictionary dictionaryWithContentsOfFile:stateFile]
            ?: [NSMutableDictionary dictionary];
    NSArray *features = dict[@"features"] ?: @[];
    if (![features containsObject:feature]) {
        dict[@"features"] = [features arrayByAddingObject:feature];
        [dict writeToFile:stateFile atomically:YES];
    }
    CFPreferencesAppSynchronize(kOMCPrefsDomain);
    id rescue = OMCPref(@"rescueFeatures", nil);
    if ([rescue isKindOfClass:[NSArray class]] &&
        [rescue containsObject:feature]) {
        NSString *key = [feature stringByAppendingString:@"Enabled"];
        if ([OMCPref(key, (id)kCFBooleanTrue) boolValue]) {
            NSMutableArray *copy = [rescue mutableCopy];
            [copy removeObject:feature];
            CFPreferencesSetAppValue(CFSTR("rescueFeatures"),
                                     copy.count
                                         ? (CFPropertyListRef)(__bridge void *)copy
                                         : NULL,
                                     kOMCPrefsDomain);
            OMCPrefsSync();
            OMCLogWrite(@"Core",
                [NSString stringWithFormat:@"%@ bat lai sau che do cuu",
                                           feature]);
            return YES;
        }
        OMCLogWrite(@"Core",
            [NSString stringWithFormat:
                @"%@ dang tat boi che do cuu (tu %@): khong cai hook "
                 "trong CarPlay",
                feature, OMCPref(@"rescueDate", nil)]);
        return NO;
    }
    return YES;
}

#pragma mark - Profile keys / languages — VERIFIED

// _OMCProfileKeys @ 0xc510: returns a constant array (VA 0x170D8).
NSArray<NSString *> *OMCProfileKeys(void) {
    return @[
        @"splitScreenLastLeft", @"splitScreenLastRight",
        @"splitScreenSplitRatio", @"splitScreenSplitDirection",
        @"splitScreenPaneOrientation", @"splitScreenAutoLaunch",
        @"splitScreenPinnedApp", @"speedBubbleSizeCar", @"speedBubbleLook",
        @"startupScreenVideoName", @"startupScreenStyle",
        @"startupScreenCarName", @"startupScreenTempo", @"appBridgeZoom"
    ];
}

// _OMCSupportedLanguages @ 0xc51c: constant array (VA 0x170F0).
NSArray<NSString *> *OMCSupportedLanguages(void) {
    return @[
        @"vi", @"en", @"es", @"pt-BR", @"de", @"fr", @"it", @"ru",
        @"zh-Hans", @"ja", @"ko", @"ar", @"th", @"id"
    ];
}

// _OMCCurrentLanguage @ 0xc528
NSString *OMCCurrentLanguage(void) {
    id pref = CFBridgingRelease(CFPreferencesCopyAppValue(
        CFSTR("language"), kOMCPrefsDomain));
    NSArray<NSString *> *supported = OMCSupportedLanguages();
    if ([pref isKindOfClass:[NSString class]] &&
        [supported containsObject:pref]) {
        return pref;
    }
    for (NSString *raw in [NSLocale preferredLanguages]) {
        for (NSString *sup in supported) {
            if ([raw isEqualToString:sup]) return sup;
            if ([raw hasPrefix:[sup stringByAppendingString:@"-"]])
                return sup;
        }
        NSString *base =
            [[raw componentsSeparatedByString:@"-"] firstObject];
        if (![base isEqualToString:@"zh"]) {
            for (NSString *sup in supported) {
                if ([[[sup componentsSeparatedByString:@"-"] firstObject]
                        isEqualToString:base])
                    return sup;
            }
        }
    }
    return @"en";
}

#pragma mark - Localisation lookup — VERIFIED

static NSMutableDictionary *gTrCache;     // bss+0x238
static dispatch_once_t gTrCacheOnce;      // bss+0x240

// _OMCTr @ 0xc8c0. Lookup source verified against the DEB payload:
// OmniCarPrefs.bundle/<lang>.lproj/Car.strings, keyed by the ENGLISH
// string (e.g. the es table maps 'Split Screen' -> 'Pantalla dividida').
NSString *OMCTr(NSString *viText, NSString *enText) {
    NSString *lang = OMCCurrentLanguage();
    if ([lang isEqualToString:@"vi"]) return viText;
    if ([lang isEqualToString:@"en"] || enText == nil) return enText;
    dispatch_once(&gTrCacheOnce, ^{
        gTrCache = [NSMutableDictionary dictionary];
    });
    NSDictionary *table;
    @synchronized(gTrCache) {
        table = gTrCache[lang];
        if (!table) {
            char buf[1024];
            NSString *base = [NSString stringWithUTF8String:OMCJBRootPath(
                "/Library/PreferenceBundles/OmniCarPrefs.bundle", buf)];
            NSString *path =
                [NSString stringWithFormat:@"%@/%@.lproj/Car.strings", base,
                                           lang];
            table = [NSDictionary dictionaryWithContentsOfFile:path] ?: @{};
            gTrCache[lang] = table;
        }
    }
    return table[enText] ?: enText;
}

#pragma mark - Logo mesh image — VERIFIED

// Draw block invoke (sub_ccd8). Gradient stop colours come from four
// packed uint32 literals at __TEXT,__const+0xB0:
//   {0x00A0F1D9, 0x00FEC4D8, 0x00A6DDFD, 0x00C9BAFC}  (byte0=R, byte1=G,
//   byte2=B) -> (217,241,160), (216,196,254), (253,221,166), (252,186,201).
// End radius 95.035151391472 is a literal in the binary (INFERRED to be a
// plain design constant; ~1.08x the 88pt size).
static void OMCDrawLogoMesh(CGContextRef ctx, int style, double alpha) {
    UIColor *bg;
    if (style) {
        bg = [UIColor colorWithRed:226 / 255.0 green:228 / 255.0
                              blue:246 / 255.0 alpha:1.0];
    } else {
        bg = [UIColor colorWithRed:232 / 255.0 green:234 / 255.0
                              blue:250 / 255.0 alpha:0.8];
    }
    [bg setFill];
    CGContextFillRect(ctx, CGRectMake(0, 0, 88, 88));
    static const uint32_t kStops[4] = {0x00A0F1D9, 0x00FEC4D8, 0x00A6DDFD,
                                       0x00C9BAFC};
    static const CGFloat kCenters[4][2] = {
        {88, 88}, {0, 88}, {88, 0}, {0, 0}};
    CGColorSpaceRef space = CGColorSpaceCreateDeviceRGB();
    for (int i = 0; i < 4; i++) {
        uint32_t p = kStops[i];
        CGFloat comps[8] = {
            (p & 0xFF) / 255.0, ((p >> 8) & 0xFF) / 255.0,
            ((p >> 16) & 0xFF) / 255.0, (CGFloat)alpha,
            (p & 0xFF) / 255.0, ((p >> 8) & 0xFF) / 255.0,
            ((p >> 16) & 0xFF) / 255.0, 0.0};
        CGFloat locs[2] = {0.0, 1.0};
        CGGradientRef g =
            CGGradientCreateWithColorComponents(space, comps, locs, 2);
        CGPoint c = CGPointMake(kCenters[i][0], kCenters[i][1]);
        CGContextDrawRadialGradient(ctx, g, c, 0, c, 95.035151391472, 0);
        CGGradientRelease(g);
    }
    CGColorSpaceRelease(space);
}

// _OMCLogoMeshImage @ 0xcb38 (per-index once tokens; no bounds check).
id OMCLogoMeshImage(int style) {
    static id images[2];              // bss+0x208
    static dispatch_once_t tokens[2]; // bss+0x218
    dispatch_once(&tokens[style], ^{ // block invoke sub_cbcc
        double alpha = style ? 1.0 : 0.95;
        UIGraphicsImageRendererFormat *format =
            [UIGraphicsImageRendererFormat preferredFormat];
        format.scale = 1.0;
        format.opaque = (style != 0);
        UIGraphicsImageRenderer *renderer = [[UIGraphicsImageRenderer alloc]
            initWithSize:CGSizeMake(88, 88)
                  format:format];
        images[style] = [renderer
            imageWithActions:^(UIGraphicsImageRendererContext *rctx) {
                OMCDrawLogoMesh(rctx.CGContext, style, alpha);
            }];
    });
    return images[style];
}
