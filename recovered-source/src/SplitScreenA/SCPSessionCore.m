// SCPSessionCore.m — OmniCarSplitScreen (1.0.3, arm64 slice):
// the car-session start/stop pair, its 4 s arming helper, the CarKit
// probe helpers it uses, and the lazy log-queue getter of this dylib's
// _OMCLogWrite.
//
// WHY THIS CLUSTER EXISTS: _OMCCrashGuard (0x50e24, shared unit) arms —
// in its first-call path, after installing the exception/signal
// handlers — two NSNotificationCenter observers on the main queue
// (object nil): UIScreenDidConnectNotification -> block 0x79420
// (invoke sub_5281c, a thunk into the arming helper below) and
// UIScreenDidDisconnectNotification -> block 0x79440 (invoke =
// session stop). It then calls the arming helper once directly for the
// already-connected case. Session start materialises the 250 ms perf
// timer (SCPPerfTelemetry.m) 4 s after a connect; session stop tears
// it down. Trigger chain fully proven in SessionCore_REPORT.md.
//
// These are this dylib's private copies of the shared OMC core
// functions (OmniCarCore.dylib carries the same source-level functions
// as sub_9bc0 / sub_9814 / sub_97e4 / sub_6dd0, reconstructed in
// src/OMCCommon/OMCCommon.c). Two behavioural deltas vs that copy are
// marked DELTA below and listed in the report; everything else was
// verified instruction-for-instruction against the Core text.
//
// Evidence tags: VERIFIED = read in this binary's disassembly
// (dumps in disasm/session/). Address comments are SplitScreen VAs.

#import "SCPSessionCore.h"
#import "SCPPerfTelemetry.h"
#import <CoreFoundation/CoreFoundation.h>
#import <UIKit/UIKit.h>
#import <notify.h>
#import <dlfcn.h>
#import <mach-o/dyld.h>
#import <objc/runtime.h>
#import <float.h>
#import <stdatomic.h>
#import <string.h>

// ---------------------------------------------------------------------------
// Shared-unit functions used here (defined in this dylib's OMC* copy).
// ---------------------------------------------------------------------------
extern id OMCPref(id key, id defaultValue);                 // 0x4f544
extern void OMCLogWrite(NSString *tag, NSString *message);  // 0x4fbf4
extern NSString *OMCTr(NSString *key, NSString *fallback);  // 0x558fc
extern NSArray<NSString *> *OMCProfileKeys(void);           // 0x5554c

// ---------------------------------------------------------------------------
// Perf-telemetry cluster state (defined in SCPPerfTelemetry.m; in the
// original these statics live in the same translation unit as this
// file's functions). INTEGRATION SEAM: OMCFlushPerfStats /
// OMCAutoLiteEvaluate are `static` in SCPPerfTelemetry.m — the build
// integration must drop that qualifier (or merge the files) for these
// externs to link.
// ---------------------------------------------------------------------------
extern void OMCFlushPerfStats(void);                        // sub_548a0
extern void OMCAutoLiteEvaluate(int on, NSString *reason);  // sub_54e1c

extern UIScreen *gPerfSessionObject;          // 0x88258
extern CADisplayLink *gPerfDisplayLink;       // 0x88260
extern dispatch_source_t gPerfSource;         // 0x88268
extern NSDate *gSessionStart;                 // 0x88270
extern NSArray *gSessionTweaks;               // 0x88278
extern NSMutableDictionary *gStatHangWho;     // 0x88280
extern NSString *gLiteReason;                 // 0x88288
extern long gDisconnectCount;                 // 0x882d8 session generation
extern double gStatFrameInterval;             // 0x882e0
extern double gStatWorstMs;                   // 0x882e8
extern double gStatLateFrames;                // 0x882f0
extern double gStatFrames;                    // 0x882f8
extern double gStatLastTick;                  // 0x88300
extern double gStatHangMaxMs;                 // 0x88308
extern double gStatFreezes;                   // 0x88310
extern double gStatHangs;                     // 0x88318
extern double gStatMemMB;                 // 0x88320
extern double gStatMemLastMB;                 // 0x88328
extern double gStatCPUMax;                    // 0x88330
extern double gStatCPUSum;                    // 0x88338
extern double gStatSysFreeMinMB;              // 0x88340
extern double gStatAvailMinMB;                // 0x88348
extern long gStatCPUCount;                    // 0x88350
extern long gStatThermalMax;                  // 0x88358
extern BOOL gStatLowPower;                    // 0x88360
extern double gLateAtLinkStart;               // 0x88368
extern double gFramesAtLinkStart;             // 0x88370
extern double gStatLatePct;                   // 0x88378
extern double gHangTimes[3];                  // 0x88380 ring
extern uint64_t gLiteCount;                   // 0x88398
extern uint8_t gAutoLiteOn;                   // 0x883a0
extern _Atomic uint8_t gSamplerMainBusy;      // 0x883a1

static id gSessionStatus;                     // 0x882d0 CARSessionStatus singleton

#pragma mark - Log queue (lazy chain of _OMCLogWrite)

// sub_4fdfc (+ outlined once-forwarder sub_560e8; block 0x793c0,
// invoke sub_522a8 creates the queue) — VERIFIED.
// The binary's getter first tests the once token for -1 (the
// dispatch_once "done" value) and returns the queue directly; the
// cold path tail-calls sub_560e8, which is exactly
// dispatch_once(&gLogQueueOnce, block 0x793c0). Same semantics as
// Core's single-function form (sub_6dd0 in OmniCarCore.dylib).
static dispatch_queue_t gLogQueue;            // 0x88290
static dispatch_once_t gLogQueueOnce;         // 0x88298

dispatch_queue_t OMCLogQueue(void) {
    dispatch_once(&gLogQueueOnce, ^{
        gLogQueue = dispatch_queue_create("com.anlai.omnicar.log", NULL);
    });
    return gLogQueue;
}

#pragma mark - CarKit probe helpers

// sub_53c30 — VERIFIED: snapshot an object's properties into a flat
// string dictionary. Walks the class hierarchy from the object's
// class up to (but excluding) NSObject; per property keeps the
// most-derived value. Only object-typed, non-pointer, non-block
// properties are read, via KVC; values are flattened to single-line
// descriptions of at most 160 chars + "...". The 80-entry cap is
// tested once per class, before its property list is walked.
// Per-property exceptions are swallowed (landing pad 0x53ec0).
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
            if (attrs[1] == '^') continue;                    // pointer type
            if (attrs[1] == '@' && attrs[2] == '?') continue; // block type
            if (out[name]) continue; // most-derived wins
            if ([name hasPrefix:@"_"]) continue;
            if ([@[ @"description", @"debugDescription", @"hash",
                    @"superclass" ] containsObject:name])
                continue;
            @try {
                id value = [obj valueForKey:name];
                NSString *desc = [value description] ?: @"nil";
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

// sub_55074 — VERIFIED: first usable string for any of `keys`,
// searching the "configuration" section of `dict` first, then
// "session" (the section array is a compile-time constant @0x80620
// inside the function). The probe dictionaries store -description
// strings, so "nil" / "(null)" and empty strings do not count.
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

// sub_552f8 — VERIFIED: snapshot of the current values of all
// profile keys (keys with a nil pref value are omitted).
static NSDictionary *OMCProfileValuesSnapshot(void) {
    NSMutableDictionary *values = [NSMutableDictionary dictionary];
    for (NSString *key in OMCProfileKeys()) {
        id v = OMCPref(key, nil);
        if (v) values[key] = v;
    }
    return values;
}

#pragma mark - Session start

// sub_52bfc — VERIFIED (4,148 B; invoke of global block 0x79460).
// Runs 4 s after a screen connect (see OMCOnScreenConnected). The
// whole body sits under one @try whose handler logs
// "CarKit loi: %@" and resumes at the diagCar write; the LSDA resume
// point (0x533a8) and the message pin the scope to the CarKit probe
// region, matching the Core copy's verified @try placement.
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
            dispatch_source_set_event_handler(gPerfSource,
                                              OMCPerfSamplerBlock);
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
                                 CFSTR("com.anlai.omnicar"));
        // VERIFIED: the binary synchronises twice here (an ARC retain
        // of diag sits between the two CFPreferencesAppSynchronize
        // calls, 0x533b4 and 0x533e0).
        CFPreferencesAppSynchronize(CFSTR("com.anlai.omnicar"));
        CFPreferencesAppSynchronize(CFSTR("com.anlai.omnicar"));
        // --- per-car profiles ---
        if ([OMCPref(@"carProfilesEnabled", (id)kCFBooleanFalse) boolValue]) {
            // Key chains are compile-time constant arrays in the
            // binary (@0x805f0 / @0x80608 in __objc_arrayobj).
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
                // DELTA vs Core copy (0x53708): the apply loop — and
                // its log line — is skipped when the stored current
                // key already IS this car. Core's reconstruction
                // applies unconditionally; see SessionCore_REPORT.md.
                NSDictionary *values = entry[@"values"];
                for (NSString *key in OMCProfileKeys()) {
                    id v = [values isKindOfClass:[NSDictionary class]]
                               ? values[key]
                               : nil;
                    CFPreferencesSetAppValue((CFStringRef)key,
                                             (CFPropertyListRef)v,
                                             CFSTR("com.anlai.omnicar"));
                }
                OMCLogWrite(@"Core",
                    [NSString stringWithFormat:@"nap ho so xe %@ (%@)",
                                               name ?: @"?", profileKey]);
            }
            entry[@"name"] = name ?: OMCTr(@"Xe", @"Car");
            entry[@"lastSeen"] = [NSDate date];
            CFPreferencesSetAppValue(CFSTR("carProfiles"),
                                     (CFPropertyListRef)profiles,
                                     CFSTR("com.anlai.omnicar"));
            CFPreferencesSetAppValue(CFSTR("carProfileCurrent"),
                                     (CFPropertyListRef)profileKey,
                                     CFSTR("com.anlai.omnicar"));
            CFPreferencesAppSynchronize(CFSTR("com.anlai.omnicar"));
            notify_post("com.anlai.omnicar/prefschanged");
        }
        OMCLogWrite(@"Core",
            [NSString stringWithFormat:
                @"man xe %@ pt, %@ px, %@ fps, session=%d", diag[@"points"],
                diag[@"pixels"], diag[@"maxFPS"], diag[@"session"] != nil]);
    }
}

// sub_52820 — VERIFIED. In the binary the delayed block is the
// global block 0x79460 whose invoke IS sub_52bfc itself (no wrapper
// function exists); a block literal here compiles to the equivalent.
// The connect observer block 0x79420's invoke is the 4-byte thunk
// sub_5281c (`b sub_52820`), i.e. the observer calls this directly.
void OMCOnScreenConnected(void) {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 4000000000LL),
                   dispatch_get_main_queue(), ^{
                       OMCDiagCarRecordConnect();
                   });
}

#pragma mark - Session stop

// sub_52850 — VERIFIED (576 B; invoke of disconnect block 0x79440).
// DELTA vs Core copy: the whole teardown (source cancel, link
// invalidate, generation bump, stats flush, summary log, auto-lite
// re-evaluation, session-object release) is guarded by
// `if (gPerfSessionObject)` at 0x52884 — Core's reconstruction
// (sub_9814) tears down unconditionally and only the source cancel
// is conditional. The diagCar update below runs on both paths.
void OMCOnScreenDisconnected(NSNotification *notification) {
    UIScreen *screen = notification.object;
    if (screen == [UIScreen mainScreen]) return; // only external screens
    if (gPerfSessionObject) {
        if (gPerfSource) {
            dispatch_source_cancel(gPerfSource);
        }
        gPerfSource = nil;
        [gPerfDisplayLink invalidate];
        gPerfDisplayLink = nil;
        gDisconnectCount++;
        OMCFlushPerfStats();
        double seconds = -[gSessionStart timeIntervalSinceNow];
        double avgCPU = gStatCPUCount ? gStatCPUSum / (double)gStatCPUCount
                                      : 0;
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
                                 CFSTR("com.anlai.omnicar"));
        CFPreferencesAppSynchronize(CFSTR("com.anlai.omnicar"));
    }
}
