// OmniCarCarProbe.m
// ============================================================================
// Reconstruction of OmniCarCarProbe.dylib from the arm64 slice of
// OmniCar 1.0.3 (fat offset 16384, UUID 60EABE81-28C1-328C-8B03-53AAC26BC7E0).
//
// Method: full manual reading of the capstone disassembly in
// src/CarProbe/disasm/ (82 functions). Import/selector/class names were
// cross-checked against the calibrated xref (metadata/xref/OmniCarCarProbe
// .json, LC_DYSYMTAB calibration delta=1, 125/125 votes): 891/891 import
// call sites and 398/399 selector sites agree; the one correction is noted
// at sub_ac84. Per-function status (VERIFIED / INFERRED) is tabulated in
// CarProbe_REPORT.md; INFERRED spots are also marked inline below.
//
// ROLE (derived from the code, not the name): this dylib is the shared
// OMCCommon core (prefs, expiry, i18n, logging + log relay, crash guard,
// runtime introspection helpers) statically embedded in every OmniCar
// module, here linked into a dylib filtered to CarPlayApp only. Its own
// constructor only stamps a "diagLoaded" diagnostic pref. The CarPlay
// connect/performance probe and the crash-guard machinery live in this
// translation unit too, but inside this binary OMCCrashGuard has no
// in-binary caller: in the real CarPlayApp process the session is created
// by whichever OmniCar module's constructor calls OMCCrashGuard first,
// and the session struct pointer is shared between the copies through the
// OMC_CRASHGUARD environment variable.
// ============================================================================

#import "OmniCarCarProbe.h"

#import <CoreFoundation/CoreFoundation.h>
#import <CoreGraphics/CoreGraphics.h>
#import <dlfcn.h>
#import <execinfo.h>
#import <mach/mach.h>
#import <mach-o/dyld.h>
#import <mach-o/getsect.h>
#import <notify.h>
#import <objc/runtime.h>
#import <os/proc.h>
#import <signal.h>
#import <stdatomic.h>
#import <string.h>
#import <time.h>
#import <unistd.h>

// [integration phase 1; backported to src in phase 3] NSDistributedNotificationCenter is not declared in
// the iOS SDK's Foundation headers (the class is resolved dynamically at
// runtime below); minimal interface so the signatures/messages compile.
// Only NSNotificationCenter-inherited methods are sent to it.
@interface NSDistributedNotificationCenter : NSNotificationCenter
+ (instancetype)defaultCenter;
@end

#define OMC_PREFS_DOMAIN ((CFStringRef)@"com.anlai.omnicar")
#define OMC_MODULE_NAME  "CarProbe"
#define OMC_BUILD_ID     "fbebb21"
#define OMC_VERSION      "1.0.3"

// Internal forward declarations (probe machinery, defined below; the
// crash guard installs the observers that call these).
static void OMCProbeScheduleStart(void);
static void OMCProbeScreenDisconnected(NSNotification *note);

// ============================================================================
// libroot shim (0x4000-0x44a4) — VERIFIED
// ----------------------------------------------------------------------------
// The OMCCommon unit links against libroot through dlopen("@rpath/
// libroot.dylib", RTLD_NOW) resolved lazily by a dispatch_once. When a
// symbol is missing, a built-in rootless fallback is installed instead:
// root prefix "", jbroot prefix "/var/jb", boot UUID all-zero string.
// ============================================================================

typedef const char *(*OMCStringFn)(void);
typedef char *(*OMCPathFn)(const char *path, char *out);

static OMCStringFn gRootPrefixFn;    // 0x14440 libroot_get_root_prefix
static OMCStringFn gJBRootPrefixFn;  // 0x14448 libroot_get_jbroot_prefix
static OMCStringFn gBootUUIDFn;      // 0x14450 libroot_get_boot_uuid
static OMCPathFn   gRootFSPathFn;    // 0x14458 libroot_rootfspath
static OMCPathFn   gJBRootPathFn;    // 0x14460 libroot_jbrootpath
static dispatch_once_t gLibRootOnce; // 0x14468

static const char *OMCFallbackEmpty(void) { return ""; }        // 0x42ac
static const char *OMCFallbackJBRoot(void) { return "/var/jb"; } // 0x42b8
static const char *OMCFallbackUUID(void) {                      // 0x42c4
    return "00000000-0000-0000-0000-000000000000";
}

// 0x42d0 — fallback libroot_jbrootpath: absolute path -> prefix + path.
static char *OMCFallbackJBRootPath(const char *path, char *out) {
    if (!path) return NULL;
    if (!out) out = malloc(0x400);
    const char *prefix = gJBRootPrefixFn();
    if (path[0] == '/') {
        strlcpy(out, prefix, 0x400);
        strlcat(out, path, 0x400);
    } else {
        strlcpy(out, path, 0x400);
    }
    return out;
}

// 0x4384 — fallback libroot_rootfspath: like jbrootpath, but a path that
// already carries the jbroot prefix has that prefix stripped first
// (rootfs paths are relative to the real root).
static char *OMCFallbackRootFSPath(const char *path, char *out) {
    if (!path) return NULL;
    if (!out) out = malloc(0x400);
    const char *rootPrefix = gRootPrefixFn();
    const char *jbPrefix = gJBRootPrefixFn();
    size_t jbLen = strlen(jbPrefix);
    if (path[0] == '/' && strncmp(path, jbPrefix, jbLen) != 0) {
        strlcpy(out, rootPrefix, 0x400);
        strlcat(out, path, 0x400);
    } else if (path[0] == '/') {
        strlcpy(out, path + jbLen, 0x400);
    } else {
        strlcpy(out, path, 0x400);
    }
    return out;
}

// 0x4170 — dispatch_once block resolving libroot.
static void OMCLibRootResolve(void) {
    void *h = dlopen("@rpath/libroot.dylib", RTLD_NOW /* 2 */);
    if (h) {
        gRootPrefixFn   = dlsym(h, "libroot_get_root_prefix");
        gJBRootPrefixFn = dlsym(h, "libroot_get_jbroot_prefix");
        gBootUUIDFn     = dlsym(h, "libroot_get_boot_uuid");
        gJBRootPathFn   = dlsym(h, "libroot_jbrootpath");
        gRootFSPathFn   = dlsym(h, "libroot_rootfspath");
    }
    if (!gRootPrefixFn)   gRootPrefixFn   = OMCFallbackEmpty;
    if (!gJBRootPrefixFn) gJBRootPrefixFn = OMCFallbackJBRoot;
    if (!gBootUUIDFn)     gBootUUIDFn     = OMCFallbackUUID;
    if (!gJBRootPathFn)   gJBRootPathFn   = OMCFallbackJBRootPath;
    if (!gRootFSPathFn)   gRootFSPathFn   = OMCFallbackRootFSPath;
}

// Trampolines 0x4000/0x4040/0x4080/0x40c0/0x4118: dispatch_once + tail call.
static const char *OMCRootPrefix(void) {
    dispatch_once(&gLibRootOnce, ^{ OMCLibRootResolve(); });
    return gRootPrefixFn();
}
static const char *OMCJBRootPrefix(void) {
    dispatch_once(&gLibRootOnce, ^{ OMCLibRootResolve(); });
    return gJBRootPrefixFn();
}
static const char *OMCBootUUID(void) {
    dispatch_once(&gLibRootOnce, ^{ OMCLibRootResolve(); });
    return gBootUUIDFn();
}
static char *OMCRootFSPath(const char *path, char *out) {   // 0x40c0
    dispatch_once(&gLibRootOnce, ^{ OMCLibRootResolve(); });
    return gRootFSPathFn(path, out);
}
static char *OMCJBRootPath(const char *path, char *out) {   // 0x4118
    dispatch_once(&gLibRootOnce, ^{ OMCLibRootResolve(); });
    return gJBRootPathFn(path, out);
}

// ============================================================================
// Preferences + feature gates (0x44a8-0x4764) — VERIFIED
// ============================================================================

void OMCPrefsSync(void) {                                    // 0x44a8
    CFPreferencesAppSynchronize(OMC_PREFS_DOMAIN);
}

id OMCPref(NSString *key, id fallback) {                     // 0x44b4
    id v = (__bridge_transfer id)CFPreferencesCopyAppValue(
        (__bridge CFStringRef)key, OMC_PREFS_DOMAIN);
    return v ?: fallback;
}

// --- expiry ---------------------------------------------------------------

static double gExpiryEpoch;              // 0x14648
static BOOL   gExpiredLatched;           // 0x14620
static dispatch_once_t gExpiryOnce;      // 0x14650

// 0xaea4 — once block: parse the compiled-in date. The formatter uses
// en_US_POSIX + GMT+7; "2027-04-30" midnight + 86400 s, i.e. the tweak
// stops working from 2027-05-01 00:00 (GMT+7).
static void OMCComputeExpiry(void) {
    NSString *s = @"2027-04-30";
    if (s.length == 0) return;
    NSDateFormatter *f = [NSDateFormatter new];
    f.locale = [NSLocale localeWithLocaleIdentifier:@"en_US_POSIX"];
    f.timeZone = [NSTimeZone timeZoneForSecondsFromGMT:25200];
    f.dateFormat = @"yyyy-MM-dd";
    NSDate *d = [f dateFromString:s];
    if (d) gExpiryEpoch = d.timeIntervalSince1970 + 86400.0;
}

BOOL OMCExpired(void) {                                      // 0xa3c0
    if (gExpiredLatched) return YES;
    dispatch_once(&gExpiryOnce, ^{ OMCComputeExpiry(); });
    if (gExpiryEpoch > 0) {
        double now = [NSDate date].timeIntervalSince1970;
        NSNumber *trusted = (__bridge_transfer NSNumber *)
            CFPreferencesCopyAppValue((CFStringRef)@"trustedTime",
                                      OMC_PREFS_DOMAIN);
        if ([trusted isKindOfClass:NSNumber.class])
            now = MAX(now, trusted.doubleValue);
        if (now >= gExpiryEpoch) {
            gExpiredLatched = YES;
            return YES;
        }
        return gExpiredLatched;
    }
    return NO;
}

BOOL OMCEnabled(void) {                                      // 0x451c
    return !OMCExpired() &&
           [OMCPref(@"enabled", @YES) boolValue];
}

BOOL OMCFeatureEnabled(NSString *feature) {                  // 0x4578
    return OMCEnabled() &&
           [OMCPref([feature stringByAppendingString:@"Enabled"], @YES)
               boolValue];
}

// --- lite mode --------------------------------------------------------------

static BOOL   gLiteCached;               // 0x14470
static double gLiteLastCheck;            // 0x14478 (CFAbsoluteTime)
static int    gLiteReadToken = 0;        // 0x14430 (notify token, reader)

BOOL OMCLiteActive(void) {                                   // 0x4608
    if (CFAbsoluteTimeGetCurrent() - gLiteLastCheck < 3.0)
        return gLiteCached;
    gLiteLastCheck = CFAbsoluteTimeGetCurrent();
    OMCPrefsSync();
    // INFERRED: the compiled-in default object at 0x11ea0 is the constant
    // number 2 (auto) — read from the __NSConstantIntegerNumber payload;
    // consistent with the mode-2 branch being the only one that consults
    // the Darwin state this module itself publishes.
    NSInteger mode = [OMCPref(@"liteMode", @2) integerValue];
    BOOL result = NO;
    if (mode == 1) {
        result = OMCEnabled();
    } else if (mode == 2) {
        if (OMCEnabled()) {
            if ([NSProcessInfo processInfo].thermalState >=
                NSProcessInfoThermalStateSerious) {
                result = YES;
            } else {
                if (gLiteReadToken == 0) {
                    if (notify_register_check("com.anlai.omnicar/lite",
                                              &gLiteReadToken) != 0)
                        gLiteReadToken = -1;
                }
                uint64_t state = 0;
                if (gLiteReadToken > 0 &&
                    notify_get_state(gLiteReadToken, &state) == 0)
                    result = (state != 0);
            }
        }
    }
    gLiteCached = result;
    return result;
}

// ============================================================================
// Localisation (0xa4bc-0xae90) — VERIFIED
// ============================================================================

NSArray<NSString *> *OMCSupportedLanguages(void) {           // 0xa4c8
    return @[@"vi", @"en", @"es", @"pt-BR", @"de", @"fr", @"it", @"ru",
             @"zh-Hans", @"ja", @"ko", @"ar", @"th", @"id"];
}

NSString *OMCCurrentLanguage(void) {                         // 0xa4d4
    NSString *pref = (__bridge_transfer NSString *)
        CFPreferencesCopyAppValue((CFStringRef)@"language",
                                  OMC_PREFS_DOMAIN);
    NSArray<NSString *> *supported = OMCSupportedLanguages();
    if ([pref isKindOfClass:NSString.class] &&
        [supported containsObject:pref])
        return pref;
    for (NSString *lang in [NSLocale preferredLanguages]) {
        for (NSString *sup in supported) {
            if ([lang isEqualToString:sup] ||
                [lang hasPrefix:[sup stringByAppendingString:@"-"]])
                return sup;
        }
        NSString *base =
            [lang componentsSeparatedByString:@"-"].firstObject;
        if (![base isEqualToString:@"zh"]) {
            for (NSString *sup in supported) {
                NSString *supBase =
                    [sup componentsSeparatedByString:@"-"].firstObject;
                if ([supBase isEqualToString:base]) return sup;
            }
        }
    }
    return @"en";
}

static NSMutableDictionary *gTrCache;    // 0x14658
static dispatch_once_t gTrCacheOnce;     // 0x14660

NSString *OMCTr(NSString *vi, NSString *en) {                // 0xa86c
    NSString *lang = OMCCurrentLanguage();
    if ([lang isEqualToString:@"vi"]) return vi;
    if (en == nil || [lang isEqualToString:@"en"]) return en;
    dispatch_once(&gTrCacheOnce, ^{                          // block 0xafa4
        gTrCache = [NSMutableDictionary dictionary];
    });
    NSDictionary *table;
    @synchronized (gTrCache) {
        table = gTrCache[lang];
        if (!table) {
            char buf[0x400];
            const char *bundle = OMCJBRootPath(
                [@"/Library/PreferenceBundles/OmniCarPrefs.bundle"
                    fileSystemRepresentation],
                buf);
            NSString *path = [NSString stringWithFormat:
                @"%@/%@.lproj/Car.strings",
                bundle ? [NSString stringWithUTF8String:bundle] : nil,
                lang];
            table = [NSDictionary dictionaryWithContentsOfFile:path]
                        ?: @{};
            gTrCache[lang] = table;
        }
    }
    return table[en] ?: en;
}

// ============================================================================
// Process identity helpers — VERIFIED
// ============================================================================

static BOOL gIsSpringBoard;              // 0x144f0
static dispatch_once_t gSBOnce;          // 0x144f8, block 0x7248
static BOOL gIsCarPlayApp;               // 0x14500
static dispatch_once_t gCPOnce;          // 0x14508, block 0x72a8

static BOOL OMCIsSpringBoard(void) {
    dispatch_once(&gSBOnce, ^{
        gIsSpringBoard = [[NSBundle mainBundle].bundleIdentifier
            isEqualToString:@"com.apple.springboard"];
    });
    return gIsSpringBoard;
}

static BOOL OMCIsCarPlayApp(void) {
    dispatch_once(&gCPOnce, ^{
        gIsCarPlayApp = [[NSBundle mainBundle].bundleIdentifier
            isEqualToString:@"com.apple.CarPlayApp"];
    });
    return gIsCarPlayApp;
}

// ============================================================================
// Crash session (shared intra-process across all OMCCommon copies)
// ----------------------------------------------------------------------------
// Layout of the 0x448-byte session struct:
//   +0x000  char crashPath[0x400]   NSTemporaryDirectory()/OmniCar-CarPlay-crash.txt
//   +0x400  char lastModule[0x40]   last OMCLogWrite caller's module name
//   +0x440  time_t sessionStart
// The creating copy publishes the struct POINTER as hex in the environment
// variable OMC_CRASHGUARD; every other copy adopts the same pointer, so
// all copies share one struct (and the "last module" attribution works
// across modules).
// ============================================================================

typedef struct {
    char   crashPath[0x400];
    char   lastModule[0x40];
    time_t sessionStart;
} OMCCrashSession;                       // sizeof == 0x448

static OMCCrashSession *gSession;        // 0x14510

// 0x6f28 — returns the shared session pointer (adopting it from the
// environment on first use), or NULL when no session exists yet.
static OMCCrashSession *OMCCrashSessionGet(void) {
    if (!gSession) {
        const char *e = getenv("OMC_CRASHGUARD");
        if (e) gSession = (OMCCrashSession *)(uintptr_t)strtoull(e, NULL, 16);
    }
    return gSession;
}

// 0x6f6c
static NSString *OMCCrashGuardStatePath(void) {
    return [NSTemporaryDirectory()
        stringByAppendingPathComponent:@"OmniCar-crashguard.plist"];
}

// ============================================================================
// Logging core (0x4b64-0x526c) — VERIFIED
// ============================================================================

static NSDateFormatter *gLogFormatter;   // 0x14480
static dispatch_once_t gLogFmtOnce;      // 0x14488, block 0x4d28
static dispatch_queue_t gLogQueue;       // 0x144e0
static dispatch_once_t gLogQueueOnce;    // 0x144e8, block 0x7218

static dispatch_queue_t OMCLogQueue(void) {                  // 0x4d6c
    dispatch_once(&gLogQueueOnce, ^{
        gLogQueue = dispatch_queue_create("com.anlai.omnicar.log",
                                          DISPATCH_QUEUE_SERIAL);
    });
    return gLogQueue;
}

#define OMC_LOG_PATH @"/var/mobile/Documents/OmniCar.log"

// 0x4ec8 — rotation: at >= 2 MiB, OmniCar.log -> OmniCar.log.1.
// (Selector names INFERRED from call arity; the size threshold 0x200000
// and the ".1" suffix are VERIFIED.)
static void OMCRotateLogIfNeeded(void) {
    NSFileManager *fm = [NSFileManager defaultManager];
    NSDictionary *attrs = [fm attributesOfItemAtPath:OMC_LOG_PATH
                                               error:nil];
    if (attrs.fileSize >= 0x200000) {
        NSString *old = [OMC_LOG_PATH stringByAppendingString:@".1"];
        [fm removeItemAtPath:old error:nil];
        [fm moveItemAtPath:OMC_LOG_PATH toPath:old error:nil];
    }
}

// 0x4f88
static BOOL OMCAppendLogLine(NSString *line) {
    FILE *fp = fopen([OMC_LOG_PATH fileSystemRepresentation], "a");
    if (fp) {
        fputs(line.UTF8String, fp);
        fclose(fp);
    }
    return fp != NULL;
}

// 0x4ff8 — NSDistributedNotificationCenter is resolved dynamically.
static NSDistributedNotificationCenter *OMCDistributedCenter(void) {
    return [NSClassFromString(@"NSDistributedNotificationCenter")
        defaultCenter];
}

// 0x4db0 — the block OMCLogWrite dispatches onto the log queue.
static void OMCWriteLogLine(NSString *line) {
    if (OMCIsSpringBoard()) OMCRotateLogIfNeeded();
    BOOL ok = OMCAppendLogLine(line);
    if (!ok && !OMCIsSpringBoard()) {
        // Non-SpringBoard processes cannot always write the shared file;
        // relay the line to SpringBoard, which owns it.
        [OMCDistributedCenter()
            postNotificationName:@"com.anlai.omnicar/log"
                          object:nil
                        userInfo:@{@"line" : line}];
    }
}

void OMCLogWrite(NSString *tag, NSString *msg) {             // 0x4b64
    OMCCrashSession *s = OMCCrashSessionGet();
    if (s) strlcpy(s->lastModule, OMC_MODULE_NAME, 0x40);
    NSLog(@"[OmniCar/%@] %@", tag, msg);
    dispatch_once(&gLogFmtOnce, ^{                           // block 0x4d28
        gLogFormatter = [NSDateFormatter new];
        gLogFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss.SSS";
    });
    NSString *line = [NSString stringWithFormat:@"%@ [%@:%d] %@: %@\n",
        [gLogFormatter stringFromDate:[NSDate date]],
        [NSProcessInfo processInfo].processName, getpid(), tag, msg];
    dispatch_async(OMCLogQueue(), ^{ OMCWriteLogLine(line); });
}

void OMCLogRelayStart(void) {                                // 0x5034
    if (!OMCIsSpringBoard()) return;
    // Block 0x50b8 (copy/dispose helpers 0x5024/0x502c): take
    // note.userInfo[@"line"] and append it on the log queue
    // (block 0x5194: rotate + append).
    [OMCDistributedCenter()
        addObserverForName:@"com.anlai.omnicar/log"
                    object:nil
                     queue:nil
                usingBlock:^(NSNotification *note) {
                    NSString *line = note.userInfo[@"line"];
                    if ([line isKindOfClass:NSString.class]) {
                        dispatch_async(OMCLogQueue(), ^{
                            OMCRotateLogIfNeeded();
                            OMCAppendLogLine(line);
                        });
                    }
                }];
}

// ============================================================================
// Crash handlers (0x7308-0x77c0 range) — VERIFIED (see report for the two
// INFERRED details: sigaction flags word and signal-handler open flags)
// ============================================================================

static NSUncaughtExceptionHandler *gPrevExceptionHandler;    // 0x14518

// 0x7a00 — appends one "omc-crash" summary line. The suspect is the
// middle of the first stack frame whose image is named
// OmniCar<Name>.dylib; "last" is the session's last-logging module.
static void OMCWriteCrashLine(int fd, const char *how,
                              const uint64_t *addrs, int count) {
    char suspect[0x40] = {0};
    for (int i = 0; i < count; i++) {
        Dl_info info;
        if (!dladdr((void *)(uintptr_t)addrs[i], &info) || !info.dli_fname)
            continue;
        const char *base = strrchr(info.dli_fname, '/');
        base = base ? base + 1 : info.dli_fname;
        size_t len = strlen(base);
        if (strncmp(base, "OmniCar", 7) == 0 && len >= 14 &&
            strcmp(base + len - 6, ".dylib") == 0) {
            size_t mid = MIN(len - 13, (size_t)0x3f);
            memcpy(suspect, base + 7, mid);
            suspect[mid] = '\0';
            break;
        }
    }
    OMCCrashSession *s = OMCCrashSessionGet();
    long age = (long)time(NULL) - (long)s->sessionStart;
    dprintf(fd, "omc-crash age=%ld suspect=%s last=%s how=%s\n",
            age, suspect, s->lastModule, how);
}

// 0x7308 (+ tail in the 0x7478 region)
static void OMCExceptionHandler(NSException *exception) {
    OMCCrashSession *s = OMCCrashSessionGet();
    int fd = open(s->crashPath, O_WRONLY | O_CREAT | O_APPEND, 0644);
    if (fd >= 0) {
        uint64_t addrs[64];
        int n = 0;
        for (NSNumber *a in exception.callStackReturnAddresses) {
            if (n == 64) break;
            addrs[n++] = a.unsignedLongLongValue;
        }
        OMCWriteCrashLine(fd, "exception", addrs, n);
        NSString *text = [NSString stringWithFormat:@"uncaught %@: %@\n%@\n",
            exception.name, exception.reason,
            [exception.callStackSymbols componentsJoinedByString:@"\n"]];
        dprintf(fd, "%s", text.UTF8String);
        close(fd);
    }
    if (gPrevExceptionHandler) gPrevExceptionHandler(exception);
}

// 0x7568 — a real function entry (confirmed by the calibrated xref).
// After writing the report it restores the default disposition and
// re-raises, so the process still dies with the original signal.
static void OMCSignalHandler(int sig, siginfo_t *info, void *uap) {
    OMCCrashSession *s = OMCCrashSessionGet();
    int fd = open(s->crashPath, O_WRONLY | O_CREAT | O_APPEND, 0644);
    if (fd >= 0) {
        void *frames[64]; // buffer size INFERRED
        int n = backtrace(frames, 64);
        char how[32];
        snprintf(how, sizeof(how), "signal-%d", sig);
        OMCWriteCrashLine(fd, how, (const uint64_t *)frames, n);
        dprintf(fd, "signal %d (code %d) addr %p pid %d\n",
                sig, info->si_code, info->si_addr, getpid());
        backtrace_symbols_fd(frames, n, fd);
        // Surface any dyld __crash_info message left by the dying image.
        for (uint32_t i = 0; i < _dyld_image_count(); i++) {
            const struct mach_header *h = _dyld_get_image_header(i);
            unsigned long size = 0;
            const char *msg = (const char *)getsectiondata(
                (struct mach_header_64 *)h, "__DATA", "__crash_info",
                &size);
            if (!msg)
                msg = (const char *)getsectiondata(
                    (struct mach_header_64 *)h, "__DATA_DIRTY",
                    "__crash_info", &size);
            if (msg && msg[0]) {
                const char *name = _dyld_get_image_name(i);
                const char *base = name ? strrchr(name, '/') : NULL;
                dprintf(fd, "crash_info [%s]: %s\n",
                        base ? base + 1 : (name ?: "?"), msg);
            }
        }
        close(fd);
    }
    signal(sig, SIG_DFL);
    raise(sig);
}

// ============================================================================
// Crash guard (0x5d94) — VERIFIED; the brace placement of the
// handler-install block relative to the report-nonempty check is INFERRED
// (install must be unconditional in the fresh-session path, otherwise the
// first crash could never be recorded).
// ============================================================================

BOOL OMCCrashGuard(NSString *feature) {
    if (!OMCIsCarPlayApp() || feature.length == 0) return YES;

    if (!OMCCrashSessionGet()) {
        // ---- fresh session: this copy creates the shared session ----
        OMCCrashSession *s = calloc(1, 0x448);
        gSession = s;
        s->sessionStart = time(NULL);
        char hex[0x20];
        snprintf(hex, sizeof(hex), "%llx",
                 (unsigned long long)(uintptr_t)s);
        setenv("OMC_CRASHGUARD", hex, 1);
        NSString *crashPath = [NSTemporaryDirectory()
            stringByAppendingPathComponent:@"OmniCar-CarPlay-crash.txt"];
        strlcpy(s->crashPath, crashPath.fileSystemRepresentation, 0x400);

        NSString *statePath = OMCCrashGuardStatePath();
        NSMutableDictionary *state =
            [NSMutableDictionary dictionaryWithContentsOfFile:statePath]
                ?: [NSMutableDictionary dictionary];
        NSInteger early = [state[@"early"] integerValue];
        NSMutableArray *suspects =
            [NSMutableArray arrayWithArray:state[@"suspects"] ?: @[]];

        NSString *report =
            [NSString stringWithContentsOfFile:crashPath
                                      encoding:NSUTF8StringEncoding
                                         error:nil];
        if (report.length) {
            OMCLogWrite(@"Core", [NSString stringWithFormat:
                @"CARPLAY SAP LAN TRUOC:\n%@", report]);
            NSDate *modDate = [[NSFileManager defaultManager]
                attributesOfItemAtPath:crashPath error:nil]
                [NSFileModificationDate] ?: [NSDate date];
            unlink(s->crashPath);

            long minAge = INT64_MAX;
            NSString *suspect = nil, *last = nil;
            for (NSString *line in
                 [report componentsSeparatedByString:@"\n"]) {
                if (![line hasPrefix:@"omc-crash "]) continue;
                for (NSString *tok in
                     [line componentsSeparatedByString:@" "]) {
                    if ([tok hasPrefix:@"age="]) {
                        long a = [tok substringFromIndex:4].longLongValue;
                        if (a < minAge) minAge = a;   // parse INFERRED
                    } else if (!suspect && tok.length > 9 &&
                               [tok hasPrefix:@"suspect="]) {
                        suspect = [tok substringFromIndex:8];
                    } else if (!last && [tok hasPrefix:@"last="]) {
                        last = [tok substringFromIndex:5];
                    }
                }
            }
            NSString *suspectName = last ?: suspect;

            NSMutableDictionary *diag = [NSMutableDictionary dictionary];
            diag[@"date"] = modDate;
            if (minAge != INT64_MAX) diag[@"age"] = @(minAge);
            if (suspectName) diag[@"suspect"] = suspectName;
            CFPreferencesSetAppValue((CFStringRef)@"diagLastCrash",
                                     (__bridge CFPropertyListRef)diag,
                                     OMC_PREFS_DOMAIN);
            OMCPrefsSync();

            if (minAge <= 59 && suspectName &&
                ![suspects containsObject:suspectName])
                [suspects addObject:suspectName];

            if (minAge < 60 && early >= 1) {
                // ---- rescue: disable the suspected features ----
                NSArray *stateFeatures = state[@"features"] ?: @[];
                NSMutableOrderedSet *candidates =
                    [NSMutableOrderedSet orderedSetWithArray:suspects];
                [candidates intersectSet:
                    [NSSet setWithArray:stateFeatures]];
                if (candidates.count == 0) {
                    for (NSString *f in stateFeatures)
                        if ([OMCPref([f stringByAppendingString:@"Enabled"],
                                     @YES) boolValue])
                            [candidates addObject:f];
                }
                if (candidates.count) {
                    NSMutableOrderedSet *rescued =
                        [NSMutableOrderedSet orderedSet];
                    id prev = OMCPref(@"rescueFeatures", nil);
                    if ([prev isKindOfClass:NSArray.class])
                        [rescued addObjectsFromArray:prev];
                    for (NSString *f in candidates) {
                        CFPreferencesSetAppValue(
                            (CFStringRef)[f stringByAppendingString:
                                              @"Enabled"],
                            kCFBooleanFalse, OMC_PREFS_DOMAIN);
                        [rescued addObject:f];
                    }
                    CFPreferencesSetAppValue(
                        (CFStringRef)@"rescueFeatures",
                        (__bridge CFPropertyListRef)rescued.array,
                        OMC_PREFS_DOMAIN);
                    CFPreferencesSetAppValue(
                        (CFStringRef)@"rescueDate",
                        (__bridge CFPropertyListRef)[NSDate date],
                        OMC_PREFS_DOMAIN);
                    OMCPrefsSync();
                    OMCLogWrite(@"Core", [NSString stringWithFormat:
                        @"CHE DO CUU: CarPlay sap %d lan lien trong %ds "
                        @"dau -> tat %@",
                        2, 60,
                        [candidates.array
                            componentsJoinedByString:@", "]]);
                    notify_post("com.anlai.omnicar/rescue");
                    notify_post("com.anlai.omnicar/prefschanged");
                    [suspects removeAllObjects];
                }
            } else if (minAge < 60) {
                early += 1;
                OMCLogWrite(@"Core", [NSString stringWithFormat:
                    @"CarPlay sap som %ld/%d lan lien (nghi: %@)",
                    (long)early, 2,
                    [suspects componentsJoinedByString:@", "]]);
            }
            state[@"early"] = @(early);
            state[@"suspects"] = suspects;
            [state writeToFile:statePath atomically:YES];
        }

        // ---- install crash handlers + screen observers ----
        gPrevExceptionHandler = NSGetUncaughtExceptionHandler();
        NSSetUncaughtExceptionHandler(&OMCExceptionHandler);
        static const int kSignals[6] = {11, 10, 6, 4, 5, 8}; // @0xd070:
            // SIGSEGV, SIGBUS, SIGABRT, SIGILL, SIGTRAP, SIGFPE
        struct sigaction sa;
        memset(&sa, 0, sizeof(sa));
        sa.sa_sigaction = &OMCSignalHandler;
        sa.sa_flags = SA_SIGINFO; // flags word INFERRED (struct is
                                  // zero-filled from __const in the binary)
        for (int i = 0; i < 6; i++) sigaction(kSignals[i], &sa, NULL);

        NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
        [nc addObserverForName:UIScreenDidConnectNotification
                        object:nil
                         queue:[NSOperationQueue mainQueue]
                    usingBlock:^(NSNotification *n) {
                        OMCProbeScheduleStart();
                    }];                                    // block 0x778c
        [nc addObserverForName:UIScreenDidDisconnectNotification
                        object:nil
                         queue:[NSOperationQueue mainQueue]
                    usingBlock:^(NSNotification *n) {
                        OMCProbeScreenDisconnected(n);
                    }];                                    // block 0x77c0
        OMCProbeScheduleStart();
    }

    // ---- phase 2 (also the only phase for later copies): register the
    // feature and return the rescue verdict ----
    NSMutableDictionary *state =
        [NSMutableDictionary dictionaryWithContentsOfFile:
            OMCCrashGuardStatePath()] ?: [NSMutableDictionary dictionary];
    NSArray *features = state[@"features"] ?: @[];
    if (![features containsObject:feature]) {
        state[@"features"] = [features arrayByAddingObject:feature];
        [state writeToFile:OMCCrashGuardStatePath() atomically:YES];
    }
    OMCPrefsSync();
    id rescue = OMCPref(@"rescueFeatures", nil);
    if ([rescue isKindOfClass:NSArray.class] &&
        [rescue containsObject:feature]) {
        NSString *key = [feature stringByAppendingString:@"Enabled"];
        if ([OMCPref(key, @YES) boolValue]) {
            NSMutableArray *remaining = [rescue mutableCopy];
            [remaining removeObject:feature];
            CFPreferencesSetAppValue(
                (CFStringRef)@"rescueFeatures",
                remaining.count
                    ? (__bridge CFPropertyListRef)remaining
                    : NULL,
                OMC_PREFS_DOMAIN);
            OMCPrefsSync();
            OMCLogWrite(@"Core", [NSString stringWithFormat:
                @"%@ bat lai sau che do cuu", feature]);
            return YES;
        }
        OMCLogWrite(@"Core", [NSString stringWithFormat:
            @"%@ dang tat boi che do cuu (tu %@): khong cai hook trong "
            @"CarPlay", feature, OMCPref(@"rescueDate", nil)]);
        return NO;
    }
    return YES;
}

// ============================================================================
// Per-car profile key set (0xa4bc) — VERIFIED
// ============================================================================

NSArray<NSString *> *OMCProfileKeys(void) {
    return @[@"splitScreenLastLeft", @"splitScreenLastRight",
             @"splitScreenSplitRatio", @"splitScreenSplitDirection",
             @"splitScreenPaneOrientation", @"splitScreenAutoLaunch",
             @"splitScreenPinnedApp", @"speedBubbleSizeCar",
             @"speedBubbleLook", @"startupScreenVideoName",
             @"startupScreenStyle", @"startupScreenCarName",
             @"startupScreenTempo", @"appBridgeZoom"];
}

// Snapshot of the current values of all profile keys (0xa268) — VERIFIED.
static NSDictionary *OMCSnapshotProfileValues(void) {
    NSMutableDictionary *d = [NSMutableDictionary dictionary];
    for (NSString *key in OMCProfileKeys()) {
        id v = OMCPref(key, nil);
        if (v) d[key] = v;
    }
    return d;
}

// ============================================================================
// Runtime introspection helpers (0x51b8-0x5d94) — VERIFIED
// ============================================================================

Class OMCCarClass(const char *name) {                        // 0x526c
    Class cls = objc_getClass(name);
    if (cls) return cls;
    NSString *s = [NSString stringWithUTF8String:name];
    if ([s isEqualToString:@"DashBoard"])
        return objc_getClass("CARApplication");
    if ([s hasPrefix:@"DB"]) {
        NSString *rest = [s substringFromIndex:2];
        cls = objc_getClass(
            [@"CAR" stringByAppendingString:rest].UTF8String);
        if (!cls)
            cls = objc_getClass(
                [@"_CAR" stringByAppendingString:rest].UTF8String);
        return cls;
    }
    return nil;
}

BOOL OMCHasMethod(const char *className, NSString *selName) { // 0x51b8
    Class cls = OMCCarClass(className);
    if (!cls) return NO;
    Method m;
    if ([selName hasPrefix:@"+"]) {
        SEL sel = NSSelectorFromString([selName substringFromIndex:1]);
        m = class_getClassMethod(cls, sel);
    } else {
        m = class_getInstanceMethod(cls, NSSelectorFromString(selName));
    }
    return m != NULL;
}

static NSMutableSet *gMissingSeen;       // 0x14498
static dispatch_once_t gMissingOnce;     // 0x144a0, block 0x5c50

void OMCMissingSelector(NSString *tag, Class cls, NSString *selName) {
    if (!cls) return;                                        // 0x5aa4
    dispatch_once(&gMissingOnce, ^{
        gMissingSeen = [NSMutableSet set];
    });
    NSString *key = [NSString stringWithFormat:@"%@ %@",
        NSStringFromClass(cls), selName];
    @synchronized (gMissingSeen) {
        if ([gMissingSeen containsObject:key]) return;
        [gMissingSeen addObject:key];
    }
    OMCLogWrite(tag, [NSString stringWithFormat:
        @"THIEU METHOD (iOS %@): %@ -> bo qua",
        [UIDevice currentDevice].systemVersion, key]);
}

void OMCCheckHooks(NSString *module, NSArray<NSString *> *specs) {
    // 0x53b4 prologue + 0x5458 body (one function in the source; the
    // split in the disassembly index is a sweep artifact).
    NSMutableOrderedSet *renames = [NSMutableOrderedSet orderedSet];
    NSMutableArray *missing = [NSMutableArray array];
    for (NSString *spec in specs) {
        NSArray *parts = [spec componentsSeparatedByString:@" "];
        if (parts.count != 2) continue;
        NSString *className = parts[0];
        Class cls = OMCCarClass(className.UTF8String);
        if (cls && ![NSStringFromClass(cls) isEqualToString:className])
            [renames addObject:[NSString stringWithFormat:@"%@=%@",
                className, NSStringFromClass(cls)]];
        NSString *selName = parts[1];
        if ([selName hasPrefix:@"-"])
            selName = [selName substringFromIndex:1];
        if (!OMCHasMethod(className.UTF8String, selName))
            [missing addObject:spec];
    }
    static NSMutableDictionary *reports;                     // 0x14490
    if (!reports) reports = [NSMutableDictionary dictionary];
    NSString *key = [NSString stringWithFormat:@"%@%@@%@",
        @"diagHooks.", module,
        [NSProcessInfo processInfo].processName];
    NSMutableDictionary *entry =
        [reports[key] mutableCopy] ?: [@{@"total" : @0,
                                         @"missing" : @[]} mutableCopy];
    entry[@"ios"] = [UIDevice currentDevice].systemVersion;
    entry[@"total"] = @([entry[@"total"] integerValue] +
                        (NSInteger)specs.count);
    [entry[@"missing"] addObjectsFromArray:missing];
    reports[key] = entry;
    CFPreferencesSetAppValue((CFStringRef)key,
                             (__bridge CFPropertyListRef)entry,
                             OMC_PREFS_DOMAIN);
    OMCPrefsSync();
    NSString *version = [UIDevice currentDevice].systemVersion;
    if (renames.count)
        OMCLogWrite(module, [NSString stringWithFormat:
            @"iOS %@: lop CarPlay %@", version,
            [renames.array componentsJoinedByString:@", "]]);
    if (missing.count)
        OMCLogWrite(module, [NSString stringWithFormat:
            @"iOS %@: %lu/%lu hook KHONG co tren iOS nay (tinh nang lien "
            @"quan se khong chay): %@",
            version, (unsigned long)missing.count,
            (unsigned long)specs.count,
            [missing componentsJoinedByString:@", "]]);
    else
        OMCLogWrite(module, [NSString stringWithFormat:
            @"iOS %@: du %lu hook", version,
            (unsigned long)specs.count]);
}

id OMCCarLaunchInfo(id appInfo) {                            // 0x5c84
    if (!appInfo) return nil;
    Class cls = OMCCarClass("DBApplicationLaunchInfo");
    SEL s1 = NSSelectorFromString(@"launchInfoForApplication:");
    SEL s2 = NSSelectorFromString(
        @"launchInfoForApplication:withActivationSettings:");
    if ([cls respondsToSelector:s1])
        return [cls performSelector:s1 withObject:appInfo];
    if ([cls respondsToSelector:s2])
        return [cls performSelector:s2 withObject:appInfo
                             withObject:nil];
    OMCLogWrite(@"Core", [NSString stringWithFormat:
        @"THIEU METHOD: %@ khong tao duoc launchInfo", cls]);
    return nil;
}

// ============================================================================
// CarKit object snapshot (0x8ba0) — VERIFIED
// ----------------------------------------------------------------------------
// Walks the class hierarchy (subclass first, stopping before NSObject and
// at 80 collected keys) and records, for every property whose type
// encoding is neither a pointer (^) nor a block (@?), the value's
// -description as a single-line string of at most 160 chars + "...".
// Names starting with "_" and the NSObject boilerplate names
// (description, debugDescription, hash, superclass — list @0x12060) are
// skipped; the first (most-derived) definition of a name wins.
// ============================================================================

static NSDictionary *OMCSnapshotObjectProperties(id obj) {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    for (Class cls = [obj class]; cls && cls != [NSObject class];
         cls = class_getSuperclass(cls)) {
        if (dict.count >= 80) break;
        unsigned int count = 0;
        objc_property_t *props = class_copyPropertyList(cls, &count);
        for (unsigned int i = 0; i < count; i++) {
            NSString *name = [NSString stringWithUTF8String:
                property_getName(props[i])];
            const char *attrs = property_getAttributes(props[i]);
            if (!attrs || attrs[0] != 'T' || attrs[1] == '^' ||
                (attrs[1] == '@' && attrs[2] == '?'))
                continue;
            if (dict[name]) continue;
            if ([name hasPrefix:@"_"]) continue;
            if ([@[@"description", @"debugDescription", @"hash",
                   @"superclass"] containsObject:name])
                continue;
            @try {
                id value = [obj valueForKey:name];
                NSString *text = [value description] ?: @"nil"; // [integration phase 1; backported to src in phase 3] dot->bracket (id has no .description property in this SDK)
                text = [[text componentsSeparatedByCharactersInSet:
                            [NSCharacterSet newlineCharacterSet]]
                    componentsJoinedByString:@" "];
                if (text.length > 160)
                    text = [[text substringToIndex:160]
                        stringByAppendingString:@"..."];
                dict[name] = text;
            } @catch (id e) {
            }
        }
        free(props);
    }
    return dict;
}

// 0x9fe4 — first non-empty string found at dict[outer][inner] for
// outer in {configuration, session} (in that order), skipping the
// literal strings "nil" and "(null)".
static NSString *OMCDeepFindString(NSDictionary *dict,
                                   NSArray<NSString *> *innerKeys) {
    for (NSString *outer in @[@"configuration", @"session"]) {
        NSDictionary *sub = dict[outer];
        if (![sub isKindOfClass:NSDictionary.class]) continue;
        for (NSString *k in innerKeys) {
            NSString *v = sub[k];
            if ([v isKindOfClass:NSString.class] && v.length > 0 &&
                ![v isEqualToString:@"nil"] &&
                ![v isEqualToString:@"(null)"])
                return v;
        }
    }
    return nil;
}

// ============================================================================
// Wired/wireless detection (0x4764) — VERIFIED
// ============================================================================

int OMCCarWireless(void) {
    NSDictionary *diag = OMCPref(@"diagCar", nil);
    if (![diag isKindOfClass:NSDictionary.class]) return -1;
    for (NSString *outer in @[@"session", @"configuration"]) {
        NSDictionary *sub = diag[outer];
        if (![sub isKindOfClass:NSDictionary.class]) continue;
        for (NSString *key in sub) {
            if (![key isKindOfClass:NSString.class]) continue;
            NSString *k = key.lowercaseString;
            NSString *desc = [[sub[key] description] lowercaseString]; // [integration phase 1; backported to src in phase 3] dot->bracket, same reason
            if ([k containsString:@"wireless"]) {
                if ([desc isEqualToString:@"1"]) return 1;
                if ([desc isEqualToString:@"0"]) return 0;
            }
            if ([k containsString:@"wired"]) {
                if ([desc isEqualToString:@"1"]) return 0;
                if ([desc isEqualToString:@"0"]) return 1;
            }
            if ([k containsString:@"transport"]) {
                if ([desc containsString:@"wifi"] ||
                    [desc containsString:@"wireless"] ||
                    [desc containsString:@"wi-fi"])
                    return 1;
                if ([desc containsString:@"usb"] ||
                    [desc containsString:@"wired"])
                    return 0;
            }
        }
    }
    return -1;
}

// ============================================================================
// CarPlay connect probe + performance monitor + auto lite mode
// (0x7790-0xa268) — VERIFIED except where marked INFERRED.
// All state below is file-static in the binary (VA range 0x144a8-0x14618).
// ============================================================================

static UIScreen *gProbeScreen;           // 0x144a8
static dispatch_source_t gPerfTimer;     // 0x144b8
static CADisplayLink *gDisplayLink;      // 0x144b0
static NSDate *gConnectDate;             // 0x144c0
static NSArray *gOtherTweaks;            // 0x144c8
static NSMutableDictionary *gHangWho;    // 0x144d0
static NSString *gLiteReason;            // 0x144d8
static id gCARSessionStatus;             // 0x14520
static NSUInteger gSessionCounter;       // 0x14528

static double gFrameInterval;            // 0x14530 (s)
static double gWorstMs;                  // 0x14538
static double gLateFrames;               // 0x14540
static double gTotalFrames;              // 0x14548
static double gLastTick;                 // 0x14550
static double gHangMaxMs;                // 0x14558
static double gFreezeCount;              // 0x14560
static double gHangCount;                // 0x14568
static double gMemMaxMB;                 // 0x14570
static double gMemMB;                    // 0x14578
static double gCpuMaxPct;                // 0x14580
static double gCpuSumPct;                // 0x14588
static double gSysFreeMinMB;             // 0x14590
static double gAvailMinMB;               // 0x14598
static NSUInteger gSampleCount;          // 0x145a0
static NSInteger gThermalMax;            // 0x145a8
static BOOL gLowPowerSeen;               // 0x145b0
static double gWindowLateStart;          // 0x145b8
static double gWindowFramesStart;        // 0x145c0
static double gLatePctWindow;            // 0x145c8
static double gHangRing[3];              // 0x145d0, 0x145d8, 0x145e0
static NSUInteger gLiteCount;            // 0x145e8
static BOOL gLiteOn;                     // 0x145f0
static _Atomic uint8_t gWatchdogBusy;    // 0x145f1
static uint32_t gBusyTicks;              // 0x145f4
static mach_timebase_info_data_t gTimebase; // 0x145f8
static double gLiteChangeTime;           // 0x14610
static id gPerfTicker;                   // 0x14618

// 0x9190
static double OMCNowSeconds(void) {
    if (gTimebase.denom == 0) mach_timebase_info(&gTimebase);
    return (double)mach_absolute_time() * gTimebase.numer /
           gTimebase.denom / 1e9;
}

// --- lite state publishing --------------------------------------------------

static int gLitePostToken;               // 0x14434 (notify token, poster)

// 0x8e90
static void OMCPostLiteState(uint64_t state) {
    if (gLitePostToken == 0) {
        if (notify_register_check("com.anlai.omnicar/lite",
                                  &gLitePostToken) != 0)
            gLitePostToken = -1;
    }
    if (gLitePostToken > 0) {
        notify_set_state(gLitePostToken, state);
        notify_post("com.anlai.omnicar/lite");
    }
}

// 0x9d8c
static void OMCSetLite(BOOL on, NSString *reason) {
    if (on == gLiteOn) return;
    gLiteOn = on;
    gLiteChangeTime = OMCNowSeconds();
    if (on) {
        gLiteCount++;
        gLiteReason = reason;
        OMCPostLiteState(1);
        NSString *msg = @"che do nhe tu dong: BAT";
        if (reason)
            msg = [[msg stringByAppendingString:@" vi "]
                      stringByAppendingString:reason];
        OMCLogWrite(@"Core", msg);
    } else {
        OMCPostLiteState(0);
        OMCLogWrite(@"Core", @"che do nhe tu dong: tat");
    }
}

// --- perf reporting -----------------------------------------------------------

// 0x9810 — writes the "diagPerf" pref; does nothing during the first
// 30 s after connect.
static void OMCWriteDiagPerf(void) {
    if (!gConnectDate) return;
    NSTimeInterval elapsed =
        [[NSDate date] timeIntervalSinceDate:gConnectDate];
    if (elapsed < 30.0) return;
    NSMutableDictionary *d = [NSMutableDictionary dictionary];
    d[@"start"] = gConnectDate;
    d[@"updated"] = [NSDate date];
    d[@"seconds"] = @((long)elapsed);
    d[@"fps"] = @((long)(1.0 / gFrameInterval));
    d[@"frames"] = @((long)gTotalFrames);
    d[@"late"] = @((long)gLateFrames);
    d[@"worstMs"] = @((long)gWorstMs);
    d[@"hangs"] = @((long)gHangCount);
    d[@"freezes"] = @((long)gFreezeCount);
    d[@"hangMaxMs"] = @((long)gHangMaxMs);
    if (gHangWho.count) d[@"hangWho"] = gHangWho;
    if (gSampleCount > 0) d[@"cpuAvg"] = @(gCpuSumPct / gSampleCount);
    d[@"cpuMax"] = @(gCpuMaxPct);
    d[@"memMB"] = @(gMemMB);
    d[@"memMaxMB"] = @(gMemMaxMB);
    d[@"availMinMB"] = @(gAvailMinMB == DBL_MAX ? 0 : gAvailMinMB);
    d[@"sysFreeMinMB"] = @(gSysFreeMinMB == DBL_MAX ? 0 : gSysFreeMinMB);
    d[@"thermalMax"] = @(gThermalMax);
    d[@"lowPower"] = @(gLowPowerSeen);
    d[@"tweaks"] = gOtherTweaks ?: @[];
    d[@"liteCount"] = @(gLiteCount);
    if (gLiteReason) d[@"liteReason"] = gLiteReason;
    CFPreferencesSetAppValue((CFStringRef)@"diagPerf",
                             (__bridge CFPropertyListRef)d,
                             OMC_PREFS_DOMAIN);
    OMCPrefsSync();
}

// --- display-link frame counting ----------------------------------------------

// 0x9f44 — IMP of -[OMCPerfTicker tick:] (registered at runtime).
static void OMCDisplayLinkTick(void) {
    double now = OMCNowSeconds();
    if (gLastTick > 0) {
        double dt = now - gLastTick;
        double missed = 0;
        if (dt > 1.5 * gFrameInterval)
            missed = round(dt / gFrameInterval) - 1;
        gTotalFrames += missed + 1;
        gLateFrames += missed;
        gWorstMs = MAX(gWorstMs, dt * 1000.0);
    }
    gLastTick = now;
}

// 0x9eb0 — 10 s after the link starts: stop it and score the window.
static void OMCStopDisplayLink(NSUInteger session) {
    if (session != gSessionCounter) return;
    [gDisplayLink invalidate];
    gDisplayLink = nil;
    double dFrames = gTotalFrames - gWindowFramesStart;
    if (dFrames >= 100.0)
        gLatePctWindow =
            (gLateFrames - gWindowLateStart) * 100.0 / dFrames;
}

// --- sampler (perf queue, every 250 ms) ----------------------------------------

// 0x91e8 — main-queue watchdog block: measures how late the main queue
// answered; a delay >= 0.5 s counts as a hang, >= 2 s as a freeze.
static void OMCWatchdogCheck(double scheduled) {
    double delay = OMCNowSeconds() - scheduled;
    atomic_store(&gWatchdogBusy, 0);
    if (delay < 0.5 || !gProbeScreen) return;
    gHangCount++;
    if (delay >= 2.0) {
        gFreezeCount++;
        gHangMaxMs = MAX(gHangMaxMs, delay * 1000.0); // placement INFERRED
    }
    OMCCrashSession *s = OMCCrashSessionGet();
    NSString *who = (s && s->lastModule[0])
        ? [NSString stringWithUTF8String:s->lastModule] : @"-";
    if (!gHangWho) gHangWho = [NSMutableDictionary dictionary];
    gHangWho[who] = @([gHangWho[who] integerValue] + 1);
    gHangRing[0] = gHangRing[1];
    gHangRing[1] = gHangRing[2];
    gHangRing[2] = OMCNowSeconds();
    if (delay >= 2.0)
        OMCLogWrite(@"Core", [NSString stringWithFormat:
            @"CarPlay do %.1fs (OmniCar gan nhat: %@)", delay, who]);
}

// 0x93b8 — folds one sample into the stats, runs the auto-lite
// evaluation, and manages the display link. Runs on the main queue.
static void OMCRecordSample(double cpu, double memMB, double availMB,
                            double sysFreeMB) {
    if (!gProbeScreen) return;
    gSampleCount++;
    if (cpu >= 0) {
        gCpuSumPct += cpu;
        gCpuMaxPct = MAX(gCpuMaxPct, cpu);
    }
    if (memMB >= 0) {
        gMemMB = memMB;
        gMemMaxMB = MAX(gMemMaxMB, memMB);
    }
    if (availMB > 0) gAvailMinMB = MIN(gAvailMinMB, availMB);
    if (sysFreeMB >= 0) gSysFreeMinMB = MIN(gSysFreeMinMB, sysFreeMB);
    NSProcessInfo *pi = [NSProcessInfo processInfo];
    gThermalMax = MAX(gThermalMax, pi.thermalState);
    if (pi.lowPowerModeEnabled) gLowPowerSeen = YES;
    if (gSampleCount % 2 == 0) OMCPrefsSync();          // cadence INFERRED

    // auto lite evaluation (predicate composition partly INFERRED)
    if (OMCEnabled() &&
        [OMCPref(@"liteMode", @2) integerValue] == 2) {
        double now = OMCNowSeconds();
        if (pi.thermalState > 1) {
            OMCSetLite(YES, @"heat");
        } else if (gHangRing[0] > 0 && now - gHangRing[0] >= 120.0) {
            OMCSetLite(YES, @"hangs");
        } else if (gLatePctWindow >= 15.0) {
            OMCSetLite(YES, @"frames");
        } else if (gLatePctWindow < 5.0 && gLiteOn &&
                   now - gLiteChangeTime > 180.0 &&
                   (gHangRing[2] == 0 || now - gHangRing[2] > 180.0)) {
            OMCSetLite(NO, nil);
        }
    }

    // display link: (re)created on every 3rd sample from the 4th
    if (gSampleCount % 3 == 1 && !gDisplayLink) {
        if (!gPerfTicker) {
            Class cls = objc_getClass("OMCPerfTicker");
            if (!cls) {
                cls = objc_allocateClassPair([NSObject class],
                                             "OMCPerfTicker", 0);
                IMP imp = imp_implementationWithBlock(
                    ^(id self, CADisplayLink *link) {
                        OMCDisplayLinkTick();
                    });
                class_addMethod(cls, @selector(tick:), imp, "v@:@");
                objc_registerClassPair(cls);
            }
            gPerfTicker = [[cls alloc] init];
        }
        gDisplayLink = [gProbeScreen
            displayLinkWithTarget:gPerfTicker selector:@selector(tick:)];
        [gDisplayLink addToRunLoop:[NSRunLoop mainRunLoop]
                           forMode:NSRunLoopCommonModes];
        gLastTick = 0;
        gWindowFramesStart = gTotalFrames;
        gWindowLateStart = gLateFrames;
        NSUInteger session = gSessionCounter;
        dispatch_after(
            dispatch_time(DISPATCH_TIME_NOW, 10 * NSEC_PER_SEC),
            dispatch_get_main_queue(),
            ^{ OMCStopDisplayLink(session); });
    }
    if (gSampleCount % 6 == 0) OMCWriteDiagPerf();      // cadence INFERRED
}

// 0x8f00 — the 250 ms timer handler on the perf queue.
static void OMCPerfTimerTick(void) {
    double now = OMCNowSeconds();
    uint8_t busy = atomic_exchange(&gWatchdogBusy, 1);
    if (busy) {
        // Main queue is behind; only sample every 20th busy tick.
        if ((++gBusyTicks % 20) != 0) return;
    } else {
        dispatch_async(dispatch_get_main_queue(),
                       ^{ OMCWatchdogCheck(now); });
    }

    // CPU: sum per-thread usage, skipping idle threads.
    double cpu = -1;
    thread_array_t threads;
    mach_msg_type_number_t threadCount = 0;
    if (task_threads(mach_task_self(), &threads, &threadCount) ==
        KERN_SUCCESS) {
        double sum = 0;
        for (mach_msg_type_number_t i = 0; i < threadCount; i++) {
            thread_basic_info_data_t info;
            mach_msg_type_number_t n = THREAD_BASIC_INFO_COUNT;
            if (thread_info(threads[i], THREAD_BASIC_INFO,
                            (thread_info_t)&info, &n) == KERN_SUCCESS &&
                !(info.flags & TH_FLAGS_IDLE))
                sum += info.cpu_usage * 100.0 / 1000.0; // TH_USAGE_SCALE
            mach_port_deallocate(mach_task_self(), threads[i]);
        }
        vm_deallocate(mach_task_self(), (vm_address_t)threads,
                      threadCount * sizeof(thread_t));
        cpu = sum;
    }

    // Memory: resident size of this process, in MiB.
    double memMB = -1;
    {
        mach_task_basic_info_data_t info;
        mach_msg_type_number_t n = MACH_TASK_BASIC_INFO_COUNT; // flavor 22
        if (task_info(mach_task_self(), MACH_TASK_BASIC_INFO,
                      (task_info_t)&info, &n) == KERN_SUCCESS)
            memMB = info.resident_size * 0x1p-20;
    }

    // System free memory from host statistics.
    double sysFreeMB = -1;
    {
        static mach_port_t host;                        // 0x14600
        static double pageSizeMB;                       // 0x14608
        if (!host) {
            host = mach_host_self();
            vm_size_t ps = 0;
            host_page_size(host, &ps);
            pageSizeMB = (double)ps * 0x1p-20;
        }
        vm_statistics64_data_t stats;
        mach_msg_type_number_t n = HOST_VM_INFO64_COUNT;
        if (host_statistics64(host, HOST_VM_INFO64,
                              (host_info64_t)&stats, &n) == KERN_SUCCESS)
            sysFreeMB = ((uint64_t)stats.free_count +
                         stats.inactive_count) * pageSizeMB;
    }

    double availMB = (double)(os_proc_available_memory() >> 20);
    dispatch_async(dispatch_get_main_queue(), ^{
        OMCRecordSample(cpu, memMB, availMB, sysFreeMB);
    });
}

// --- connect / disconnect ---------------------------------------------------

// 0x7b6c — runs ~4 s after a screen connect (and once at guard install).
// Executes at most once per external screen until it disconnects.
static void OMCProbeRun(void) {
    UIScreen *external = nil;
    for (UIScreen *s in [UIScreen screens]) {
        if (s != [UIScreen mainScreen]) { external = s; break; }
    }
    if (!external || gProbeScreen) return;
    gProbeScreen = external;
    gSessionCounter++;
    gConnectDate = [NSDate date];

    // Other tweaks injected into CarPlay (image names under
    // /DynamicLibraries/ or /TweakInject/, minus OmniCar's own).
    NSMutableOrderedSet *found = [NSMutableOrderedSet orderedSet];
    uint32_t imageCount = _dyld_image_count();
    for (uint32_t i = 0; i < imageCount; i++) {
        const char *name = _dyld_get_image_name(i);
        if (!name) continue;
        NSString *path = [NSString stringWithUTF8String:name];
        if (![path containsString:@"/DynamicLibraries/"] &&
            ![path containsString:@"/TweakInject/"])
            continue;
        NSString *base = path.lastPathComponent
                             .stringByDeletingPathExtension;
        if ([base hasPrefix:@"OmniCar"]) continue;
        [found addObject:base];
    }
    gOtherTweaks = found.array;

    // Reset the stats block.
    gFrameInterval = 1.0 / MAX(1, external.maximumFramesPerSecond);
    gWorstMs = gLateFrames = gTotalFrames = gLastTick = 0;
    gHangMaxMs = gFreezeCount = gHangCount = 0;
    gMemMaxMB = gMemMB = gCpuMaxPct = gCpuSumPct = 0;
    gSysFreeMinMB = gAvailMinMB = DBL_MAX;
    gSampleCount = 0;
    gThermalMax = 0;
    gLowPowerSeen = NO;
    gWindowLateStart = gWindowFramesStart = gLatePctWindow = 0;
    gHangRing[0] = gHangRing[1] = gHangRing[2] = 0;
    gHangWho = [NSMutableDictionary dictionary];
    OMCPostLiteState(0);
    gLiteOn = NO;

    dispatch_queue_t queue =
        dispatch_queue_create("com.anlai.omnicar.perf",
                              DISPATCH_QUEUE_SERIAL);
    gPerfTimer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,
                                        queue);
    dispatch_source_set_timer(
        gPerfTimer,
        dispatch_time(DISPATCH_TIME_NOW, 250 * NSEC_PER_MSEC),
        250 * NSEC_PER_MSEC, 50 * NSEC_PER_MSEC);
    dispatch_source_set_event_handler(gPerfTimer,
                                      ^{ OMCPerfTimerTick(); });
    dispatch_resume(gPerfTimer);

    notify_post("com.anlai.omnicar/car.connected");
    OMCLogWrite(@"Core", [NSString stringWithFormat:
        @"do hieu nang: bat dau, %lu tweak khac trong CarPlay: %@",
        (unsigned long)gOtherTweaks.count, gOtherTweaks]);

    NSString *points = [NSString stringWithFormat:@"%.0fx%.0f",
        external.bounds.size.width, external.bounds.size.height];
    NSString *pixels = [NSString stringWithFormat:@"%.0fx%.0f",
        external.nativeBounds.size.width,
        external.nativeBounds.size.height];
    NSMutableDictionary *diag = [NSMutableDictionary dictionary];
    diag[@"date"] = gConnectDate;
    diag[@"connected"] = @YES;
    diag[@"ios"] = [UIDevice currentDevice].systemVersion;
    diag[@"points"] = points;
    diag[@"pixels"] = pixels;
    diag[@"scale"] = @(external.scale);
    diag[@"maxFPS"] = @(external.maximumFramesPerSecond);

    id session = nil;
    @try {
        dlopen("/System/Library/PrivateFrameworks/CarKit.framework/"
               "CarKit", RTLD_LAZY);
        Class cls = NSClassFromString(@"CARSessionStatus");
        if (!gCARSessionStatus)
            gCARSessionStatus = [[cls alloc] init];    // INFERRED creation
        if ([gCARSessionStatus respondsToSelector:
                NSSelectorFromString(@"currentSession")])
            session = [gCARSessionStatus valueForKey:@"currentSession"];
        if (session) {
            diag[@"session"] = OMCSnapshotObjectProperties(session);
            id cfg = nil;
            if ([session respondsToSelector:
                    NSSelectorFromString(@"configuration")])
                cfg = [session valueForKey:@"configuration"];
            if (cfg)
                diag[@"configuration"] =
                    OMCSnapshotObjectProperties(cfg);
        }
        CFPreferencesSetAppValue((CFStringRef)@"diagCar",
                                 (__bridge CFPropertyListRef)diag,
                                 OMC_PREFS_DOMAIN);
        OMCPrefsSync();
    } @catch (NSException *e) {
        OMCLogWrite(@"Core", [NSString stringWithFormat:
            @"CarKit loi: %@", e]);
    }

    // Per-car profiles (branch order partly INFERRED).
    if ([OMCPref(@"carProfilesEnabled", @NO) boolValue]) {
        static NSArray *nameKeys, *idKeys;
        if (!nameKeys) {
            nameKeys = @[@"modelName", @"name", @"vehicleName",
                         @"accessoryName", @"model"];
            idKeys = @[@"vehicleIdentifier", @"identifier",
                       @"uniqueIdentifier", @"accessoryID", @"deviceID",
                       @"serialNumber"];
        }
        NSString *vehicleName = OMCDeepFindString(diag, nameKeys);
        NSString *accessoryID = OMCDeepFindString(diag, idKeys);
        NSString *profileKey = accessoryID ?: [NSString stringWithFormat:
            @"%@|%@", vehicleName ?: @"?", diag[@"pixels"] ?: @"?"];
        NSMutableDictionary *profiles = [NSMutableDictionary dictionary];
        NSDictionary *stored = OMCPref(@"carProfiles", nil);
        for (NSString *k in stored)
            profiles[k] = [stored[k] mutableCopy];
        NSString *currentID = OMCPref(@"carProfileCurrent", nil);
        NSMutableDictionary *entry = profiles[profileKey];
        if (entry) {
            if (currentID && ![currentID isEqualToString:profileKey] &&
                profiles[currentID])
                profiles[currentID][@"values"] =
                    OMCSnapshotProfileValues();
            NSDictionary *values = entry[@"values"];
            for (NSString *k in values)
                CFPreferencesSetAppValue(
                    (CFStringRef)k,
                    (__bridge CFPropertyListRef)values[k],
                    OMC_PREFS_DOMAIN);
            OMCPrefsSync();
            OMCLogWrite(@"Core", [NSString stringWithFormat:
                @"nap ho so xe %@ (%@)", profileKey, vehicleName]);
        } else {
            profiles[profileKey] = [@{
                @"values" : OMCSnapshotProfileValues(),
                @"name" : vehicleName ?: OMCTr(@"Xe", @"Car"),
                @"lastSeen" : [NSDate date],
            } mutableCopy];
            CFPreferencesSetAppValue((CFStringRef)@"carProfiles",
                (__bridge CFPropertyListRef)profiles, OMC_PREFS_DOMAIN);
            CFPreferencesSetAppValue((CFStringRef)@"carProfileCurrent",
                (__bridge CFPropertyListRef)profileKey, OMC_PREFS_DOMAIN);
            OMCPrefsSync();
            notify_post("com.anlai.omnicar/prefschanged");
            OMCLogWrite(@"Core", [NSString stringWithFormat:
                @"ho so xe moi: %@ (%@)", profileKey, vehicleName]);
        }
    }

    OMCLogWrite(@"Core", [NSString stringWithFormat:
        @"man xe %@ pt, %@ px, %@ fps, session=%d",
        points, pixels, diag[@"maxFPS"], session != nil]);
}

// 0x7790 (+ 4-byte notification trampoline 0x778c)
static void OMCProbeScheduleStart(void) {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 4 * NSEC_PER_SEC),
                   dispatch_get_main_queue(),
                   ^{ OMCProbeRun(); });
}

// 0x77c0 — UIScreenDidDisconnectNotification handler block.
static void OMCProbeScreenDisconnected(NSNotification *note) {
    UIScreen *screen = note.object;
    if (screen == [UIScreen mainScreen]) return;
    if (gPerfTimer) {
        dispatch_source_cancel(gPerfTimer);
        gPerfTimer = nil;
    }
    [gDisplayLink invalidate];
    gDisplayLink = nil;
    gSessionCounter++;
    OMCWriteDiagPerf();
    NSTimeInterval elapsed =
        [[NSDate date] timeIntervalSinceDate:gConnectDate];
    double cpuAvg = gSampleCount ? gCpuSumPct / gSampleCount : 0;
    OMCLogWrite(@"Core", [NSString stringWithFormat:
        @"do hieu nang: %.0fs, tre %.0f/%.0f khung, do %.0f lan "
        @"(max %.0f ms), CPU tb %.0f%%, RAM %.0f MB",
        elapsed, gLateFrames, gTotalFrames, gHangCount, gHangMaxMs,
        cpuAvg, gMemMaxMB]);
    OMCSetLite(NO, nil);
    gProbeScreen = nil;
    NSMutableDictionary *diag = [OMCPref(@"diagCar", nil) mutableCopy];
    if ([diag isKindOfClass:NSMutableDictionary.class]) {
        diag[@"connected"] = @NO;
        diag[@"disconnected"] = [NSDate date];
        CFPreferencesSetAppValue((CFStringRef)@"diagCar",
                                 (__bridge CFPropertyListRef)diag,
                                 OMC_PREFS_DOMAIN);
        OMCPrefsSync();
    }
}

// ============================================================================
// Logo mesh image (0xaae4-0xaea4) — structure VERIFIED; the gradient
// component packing is INFERRED from the NEON byte extraction.
// ============================================================================

// 0xac84 — renderer actions block.
static void OMCDrawLogoMesh(UIGraphicsImageRendererContext *rendererCtx,
                            double factor, BOOL variant) {
    // Selector "CGContext" per the calibrated xref; the wave-1 annotation
    // left this call site unresolved ("?").
    CGContextRef ctx = rendererCtx.CGContext;
    UIColor *bg;
    if (variant)
        bg = [UIColor colorWithRed:0.8862745098039215
                             green:0.8941176470588236
                              blue:0.9647058823529412 alpha:1.0];
    else
        bg = [UIColor colorWithRed:0.9098039215686274
                             green:0.9176470588235294
                              blue:0.9803921568627451 alpha:0.8];
    [bg setFill];
    CGContextFillRect(ctx, CGRectMake(0, 0, 96, 96));

    CGColorSpaceRef space = CGColorSpaceCreateDeviceRGB();
    static const uint32_t kMeshColors[4] = {   // @0xd0f0
        0x00a0f1d9, 0x00fec4d8, 0x00a6ddfd, 0x00c9bafc
    };
    static const CGPoint kCenters[4] = {       // order INFERRED
        {96, 96}, {0, 96}, {96, 0}, {0, 0}
    };
    for (int i = 0; i < 4; i++) {
        uint32_t c = kMeshColors[i];
        CGFloat comps[8] = {
            (c & 0xff) / 255.0, factor,
            ((c >> 16) & 0xff) / 255.0, ((c >> 8) & 0xff) / 255.0,
            (c & 0xff) / 255.0, 0, 0, 0  // fade to transparent (INFERRED)
        };
        CGFloat locations[2] = {0.0, 1.0};
        CGGradientRef gradient =
            CGGradientCreateWithColorComponents(space, comps, locations,
                                                2);
        CGPoint center = kCenters[i];
        CGContextDrawRadialGradient(ctx, gradient, center, 0, center,
                                    95.035151391472, 0);
        CGGradientRelease(gradient);
    }
    CGColorSpaceRelease(space);
}

UIImage *OMCLogoMeshImage(int variant) {                     // 0xaae4
    static UIImage *cache[2];                // 0x14628
    static dispatch_once_t once[2];          // 0x14638
    dispatch_once(&once[variant], ^{         // block invoke 0xab78
        double factor = variant ? 1.0 : 0.95;
        UIGraphicsImageRendererFormat *format =
            [UIGraphicsImageRendererFormat preferredFormat];
        format.scale = 1.0;
        format.opaque = (BOOL)variant;
        UIGraphicsImageRenderer *renderer =
            [[UIGraphicsImageRenderer alloc]
                initWithSize:CGSizeMake(96, 96) format:format];
        cache[variant] = [renderer
            imageWithActions:^(UIGraphicsImageRendererContext *ctx) {
                OMCDrawLogoMesh(ctx, factor, (BOOL)variant);
            }];
    });
    return cache[variant];
}

// ============================================================================
// Constructor (0x6fb8) — VERIFIED. (The block-support helper at 0x705c
// re-dispatches a captured block to a queue stored at +0x1c0 of its
// context; provenance INFERRED, no behavioural impact.)
// The substrate filter loads this dylib into CarPlayApp only, whose
// process name is "CarPlay"; the "SpringBoard" branch is live in the
// SpringBoard-filtered copies of OMCCommon instead.
// ============================================================================

__attribute__((constructor)) static void OMCProbeInit(void) {
    NSString *processName = [NSProcessInfo processInfo].processName;
    if (![processName isEqualToString:@"SpringBoard"] &&
        ![processName isEqualToString:@"CarPlay"])
        return;
    dispatch_async(dispatch_get_main_queue(), ^{             // block 0x7088
        OMCLogWrite(@"CarProbe", [NSString stringWithFormat:
            @"build %s (%s) loaded into %@",
            OMC_BUILD_ID, OMC_VERSION, processName]);
        NSString *key = [NSString stringWithFormat:@"%@%s%@",
            @"diagLoaded.", OMC_MODULE_NAME, processName];
        NSDictionary *value = @{
            @"version" : @OMC_VERSION,
            @"build" : @OMC_BUILD_ID,
            @"date" : [NSDate date],
        };
        CFPreferencesSetAppValue((CFStringRef)key,
                                 (__bridge CFPropertyListRef)value,
                                 OMC_PREFS_DOMAIN);
        CFPreferencesAppSynchronize(OMC_PREFS_DOMAIN);
    });
}
