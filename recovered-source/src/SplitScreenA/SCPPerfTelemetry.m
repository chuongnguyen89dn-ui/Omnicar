// SCPPerfTelemetry.m — OMC performance telemetry + auto-lite, the copy of
// the shared OMCCommon unit linked into OmniCarSplitScreen.dylib.
//
// RECONSTRUCTION — the cluster the coverage census proved was claimed by
// NO source file (sub_53f90 + sub_54448 unclaimed). Every function below
// was decoded from this binary's arm64 slice and is VERIFIED against the
// disassembly in disasm/perf/ unless a line says otherwise. Function
// names follow the shared unit (src/OMCCommon/OMCCommon.c); the binary
// addresses are THIS dylib's.
//
// Trigger (VERIFIED, PerfTelemetry_REPORT.md §2): nothing calls the
// sampler directly. sub_52bfc (the car-session-start block invoke) arms
// a 250 ms dispatch timer on a serial queue and installs the global
// block OMCPerfSamplerBlock (0x79480, invoke sub_53f90) as its handler.
// The sampler decimates to one sample every 20 fires (5 s), measures
// CPU / footprint / free memory on the timer queue, and hops to the main
// queue into OMCPerfSampleConsume (sub_54448), which accumulates the
// session statistics, runs the auto-lite evaluation, lazily creates the
// OMCPerfTicker CADisplayLink, and flushes `diagPerf` every 6th sample.
//
// Deltas from the Core copy of the same unit (all VERIFIED in this
// binary — do NOT reuse the Core text verbatim for this dylib):
//   * sampler decimation is every 20th fire (Core: every 10th);
//   * display-link creation cadence is sampleCount % 12 == 4
//     (Core: % 6 == 4);
//   * footprint / system-free scale is exactly 2^-20 (MB)
//     (Core reconstruction wrote 1.0e-6).

#import "SCPPerfTelemetry.h"
#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import <dispatch/dispatch.h>
#import <mach/mach.h>
#import <mach/mach_time.h>
#import <notify.h>
#import <objc/runtime.h>
#import <os/proc.h>
#import <stdatomic.h>
#import <stdlib.h>

// ---------------------------------------------------------------------------
// Shared-unit externs used by this file (this binary's copies).
// _OMCPref is the TWO-argument form — proven by the liteMode call site in
// sub_54448, which passes the @2 default object in x1 (OMCCommon.h form).
// (SCPShared.h declares a one-argument OMCPref; the machine code at
// 0x4f544 takes key + default.)
// ---------------------------------------------------------------------------
#ifdef __cplusplus
extern "C" {
#endif
id _Nullable OMCPref(NSString *key, id _Nullable defaultValue);   // 0x4f544
BOOL OMCEnabled(void);                                            // 0x4f5ac
void OMCLogWrite(NSString *tag, NSString *message);               // 0x4fbf4
#ifdef __cplusplus
}
#endif

// ---------------------------------------------------------------------------
// [phase2 hoist; backported to src in phase 3] Shared session/statistics state: the variables named in
// SCPSessionCore.m's extern block lost `static` in the project copy so the
// two TUs link as the original single TU did (SessionCore_REPORT.md seam note).
// Perf-internal state (gCrashState, gSampleDivider, sTimebase, gHostPort,
// gHostPageSize, gLiteStateChangedAt, gPerfTicker, gLiteNotifySetToken)
// stays static.
// Session / statistics state. The VAs are this dylib's __bss slots; the
// session blocks (sub_52bfc / sub_52850) also write several of them
// directly — they are the same globals the shared unit keeps at
// +0xC0..+0x1D0 of its own __bss block.
// ---------------------------------------------------------------------------
UIScreen *gPerfSessionObject;      // 0x88258 session object; the
                                          // -displayLinkWithTarget:selector:
                                          // receiver (its exact class is
                                          // INFERRED — see report §5)
CADisplayLink *gPerfDisplayLink;   // 0x88260
dispatch_source_t gPerfSource;     // 0x88268 (owned by sub_52bfc)
NSDate *gSessionStart;             // 0x88270
NSArray *gSessionTweaks;           // 0x88278
NSMutableDictionary *gStatHangWho; // 0x88280
NSString *gLiteReason;             // 0x88288
static char *gCrashState;                 // 0x882c0 (cache of OMCCrashStatePtr)
long gDisconnectCount;             // 0x882d8 window-generation counter
double gStatFrameInterval;         // 0x882e0 (set by the session block)
double gStatWorstMs;               // 0x882e8
double gStatLateFrames;            // 0x882f0
double gStatFrames;                // 0x882f8
double gStatLastTick;              // 0x88300
double gStatHangMaxMs;             // 0x88308
double gStatFreezes;               // 0x88310
double gStatHangs;                 // 0x88318
double gStatMemMB;                 // 0x88320 peak footprint, MB
double gStatMemLastMB;             // 0x88328 last footprint, MB
double gStatCPUMax;                // 0x88330
double gStatCPUSum;                // 0x88338
double gStatSysFreeMinMB;          // 0x88340
double gStatAvailMinMB;            // 0x88348
long gStatCPUCount;                // 0x88350 consumed samples
long gStatThermalMax;              // 0x88358
BOOL gStatLowPower;                // 0x88360 (byte)
double gLateAtLinkStart;           // 0x88368
double gFramesAtLinkStart;         // 0x88370
double gStatLatePct;               // 0x88378
double gHangTimes[3];              // 0x88380 / 0x88388 / 0x88390 ring
uint64_t gLiteCount;               // 0x88398
uint8_t gAutoLiteOn;               // 0x883a0
_Atomic uint8_t gSamplerMainBusy;  // 0x883a1 sampler→main latch
static int32_t gSampleDivider;            // 0x883a4
static mach_timebase_info_data_t sTimebase; // 0x883a8 numer / 0x883ac denom
static mach_port_t gHostPort;             // 0x883b0
static uint64_t gHostPageSize;            // 0x883b8
static double gLiteStateChangedAt;        // 0x883c0
static id gPerfTicker;                    // 0x883c8 OMCPerfTicker instance

// ---------------------------------------------------------------------------
// sub_54220 VERIFIED: monotonic clock, seconds (mach_absolute_time based;
// the timebase denominator doubles as the initialised flag).
// ---------------------------------------------------------------------------
static double OMCMonotonicSeconds(void) {
    if (sTimebase.denom == 0) {
        mach_timebase_info(&sTimebase);
    }
    return (double)mach_absolute_time() * (double)sTimebase.numer /
           (double)sTimebase.denom / 1.0e9;
}

// ---------------------------------------------------------------------------
// sub_51fb8 VERIFIED: lazily resolved pointer to the cross-process
// crash-guard state struct, published by whichever sibling module ran the
// guard first via the OMC_CRASHGUARD env var (hex pointer). Layout:
// +0x000 crash path, +0x400 last-logging module name (char[]),
// +0x440 start time. A NULL getenv result is not cached.
// ---------------------------------------------------------------------------
static char *OMCCrashStatePtr(void) {
    if (!gCrashState) {
        const char *hex = getenv("OMC_CRASHGUARD");
        if (hex) {
            gCrashState = (char *)strtoull(hex, NULL, 16);
        }
    }
    return gCrashState;
}

// ---------------------------------------------------------------------------
// sub_53f20 VERIFIED: Darwin-notify writer for `com.anlai.omnicar/lite`.
// The token slot (0x87f58, initialised to -1) is this TU's private writer
// token — distinct from _OMCLiteActive's reader token. notify_post runs
// unconditionally at the end; a failed registration leaves the token at
// -1 and skips the set_state.
// ---------------------------------------------------------------------------
static int32_t gLiteNotifySetToken = -1;  // 0x87f58

void OMCSetLiteNotifyState(int state) {
    if (gLiteNotifySetToken != -1) {
        notify_set_state(gLiteNotifySetToken, (uint64_t)state);
    } else if (notify_register_check("com.anlai.omnicar/lite",
                                    &gLiteNotifySetToken) == 0 &&
               gLiteNotifySetToken != -1) {
        notify_set_state(gLiteNotifySetToken, (uint64_t)state);
    }
    notify_post("com.anlai.omnicar/lite");
}

// ---------------------------------------------------------------------------
// sub_54e1c VERIFIED: auto-lite state setter — change-only. Turning on
// bumps the session's lite counter, remembers the reason, sets the lite
// notify state and logs (Vietnamese literals are the author's);
// turning off clears the notify state and logs.
// ---------------------------------------------------------------------------
void OMCAutoLiteEvaluate(int on, NSString *reason) { // [phase2 hoist; backported to src in phase 3] was static; extern in SCPSessionCore.m
    // [phase2 ARC adaptation; backported to src in phase 3] src transcribed the binary's objc_retain/release
    // calls literally; the project builds with -fobjc-arc (as does the shared
    // unit's identical function in OMCCommon.c, which uses plain strong
    // assignment). The explicit retain/release sends were dropped — ARC's
    // strong assignment to the static gLiteReason performs the same
    // retain-new/release-old sequence.
    if (gAutoLiteOn == on) {
        return;
    }
    gAutoLiteOn = (uint8_t)on;
    gLiteStateChangedAt = OMCMonotonicSeconds();
    NSString *suffix;
    NSString *word;
    if (on) {
        gLiteCount += 1;
        gLiteReason = reason; // [phase2 ARC adaptation; backported to src in phase 3] was [release]+[retain]
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
    // [phase2 ARC adaptation; backported to src in phase 3] trailing [suffix release]/[reason release] dropped (ARC scope-exit release).
}

// ---------------------------------------------------------------------------
// sub_54278 VERIFIED: hang watchdog — the invoke of the stack block the
// sampler dispatches to the main queue, capturing the fire time. A main
// queue that answers >= 0.5 s late counts as a hang (>= 2 s: a freeze),
// attributed to the module that last wrote the shared crash-state log
// buffer. The latch byte is cleared first, unconditionally.
// ---------------------------------------------------------------------------
static void OMCHangWatchdog(double firedAt) {
    double gap = OMCMonotonicSeconds() - firedAt;
    atomic_store_explicit(&gSamplerMainBusy, 0, memory_order_release);
    if (gap < 0.5 || !gPerfSessionObject) {
        return;
    }
    gStatHangs += 1.0;
    if (gap >= 2.0) {
        gStatFreezes += 1.0;
    }
    if (gap * 1000.0 > gStatHangMaxMs) {
        gStatHangMaxMs = gap * 1000.0;
    }
    char *state = OMCCrashStatePtr();
    NSString *who = (state && state[0x400])
        ? [NSString stringWithUTF8String:state + 0x400] : @"-";
    gStatHangWho[who] = @([gStatHangWho[who] integerValue] + 1);
    gHangTimes[0] = gHangTimes[1];
    gHangTimes[1] = gHangTimes[2];
    gHangTimes[2] = OMCMonotonicSeconds();
    if (gap >= 2.0) {
        OMCLogWrite(@"Core", [NSString stringWithFormat:
            @"CarPlay do %.1fs (OmniCar gan nhat: %@)", gap, who]);
    }
}

// ---------------------------------------------------------------------------
// sub_548a0 VERIFIED: periodic stats flush. Writes the `diagPerf`
// dictionary (22 keys) once the session is at least 30 s old; the caller
// invokes it every 6th consumed sample. Statistics are NOT reset.
// (The binary converts with fcvtas — round-to-nearest, ties away; the
// llrint conversions below match under the default rounding mode.)
// ---------------------------------------------------------------------------
void OMCFlushPerfStats(void) { // [phase2 hoist; backported to src in phase 3] was static; extern in SCPSessionCore.m
    if (!gSessionStart) {
        return;
    }
    double elapsed = -[gSessionStart timeIntervalSinceNow];
    if (elapsed < 30.0) {
        return;
    }
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
    if ([gStatHangWho count] > 0) {
        d[@"hangWho"] = [gStatHangWho copy];
    }
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
    d[@"tweaks"] = gSessionTweaks ? gSessionTweaks : [NSArray array];
    d[@"liteCount"] = @(gLiteCount);
    if (gLiteReason) {
        d[@"liteReason"] = gLiteReason;
    }
    CFPreferencesSetAppValue(CFSTR("diagPerf"), (CFPropertyListRef)d,
                             CFSTR("com.anlai.omnicar"));
    CFPreferencesAppSynchronize(CFSTR("com.anlai.omnicar"));
}

// ---------------------------------------------------------------------------
// sub_54fd4 VERIFIED: OMCPerfTicker's -tick: body — the invoke of the
// global block at 0x794e0, bound with imp_implementationWithBlock when
// the class is created. Counts frames and estimates dropped frames from
// the gap against the expected frame interval: a frame later than
// 1.5x the interval counts the missed whole frames as late.
// ---------------------------------------------------------------------------
static void OMCPerfTickerTick(void) {
    double now = OMCMonotonicSeconds();
    double last = gStatLastTick;
    if (last > 0) {
        double dt = now - last;
        double missed = 0;
        if (dt > 1.5 * gStatFrameInterval) {
            missed = round(dt / gStatFrameInterval) - 1;
        }
        gStatFrames += missed + 1;
        gStatLateFrames += missed;
        if (dt * 1000.0 > gStatWorstMs) {
            gStatWorstMs = dt * 1000.0;
        }
    }
    gStatLastTick = now;
}

// sub_546cc..0x54754 (inside sub_54448) VERIFIED: lazy creation of the
// private OMCPerfTicker class (NSObject subclass, single -tick: method
// implemented by the global block above) and its shared instance.
static void OMCEnsurePerfTicker(void) {
    if (gPerfTicker) {
        return;
    }
    Class cls = objc_getClass("OMCPerfTicker");
    if (!cls) {
        cls = objc_allocateClassPair([NSObject class], "OMCPerfTicker", 0);
        class_addMethod(cls, sel_registerName("tick:"),
            imp_implementationWithBlock(^(id _self, id link) {
                OMCPerfTickerTick();
            }), "v@:@");
        objc_registerClassPair(cls);
    }
    gPerfTicker = [[cls alloc] init];
}

// ---------------------------------------------------------------------------
// sub_54f40 VERIFIED: display-link window end — the invoke of the stack
// block scheduled 10 s after each link creation, capturing the session
// generation (gDisconnectCount) at creation time. A stale generation
// (session ended / restarted) makes it a no-op. Otherwise the link is
// invalidated and the late-frame percentage for the window is computed
// once >= 100 frames elapsed in it.
// ---------------------------------------------------------------------------
static void OMCPerfLinkWindowEnd(long generation) {
    if (generation != gDisconnectCount) {
        return;
    }
    [gPerfDisplayLink invalidate];
    gPerfDisplayLink = nil;
    double framesDelta = gStatFrames - gFramesAtLinkStart;
    if (framesDelta < 100.0) {
        return;
    }
    gStatLatePct = (gStatLateFrames - gLateAtLinkStart) * 100.0 / framesDelta;
}

// ---------------------------------------------------------------------------
// sub_54448 VERIFIED: sample consumer — the invoke of the stack block the
// sampler dispatches to the main queue with the measured values captured
// (block +0x20 cpu, +0x28 footprint MB, +0x30 available MB, +0x38 system
// free MB). Accumulates the session statistics, evaluates auto-lite
// (only in liteMode == 2, the pref's default), lazily creates the
// display link on samples where count % 12 == 4, and flushes diagPerf
// every 6th sample.
// ---------------------------------------------------------------------------
static void OMCPerfSampleConsume(double cpu, double footprintMB,
                                 double availMB, double sysFreeMB) {
    if (!gPerfSessionObject) {
        return;
    }
    gStatCPUCount += 1;
    if (cpu >= 0) {
        gStatCPUSum += cpu;
        if (cpu > gStatCPUMax) {
            gStatCPUMax = cpu;
        }
    }
    if (footprintMB >= 0) {
        gStatMemLastMB = footprintMB;
        if (footprintMB > gStatMemMB) {
            gStatMemMB = footprintMB;
        }
    }
    if (availMB > 0 && availMB < gStatAvailMinMB) {
        gStatAvailMinMB = availMB;
    }
    if (sysFreeMB >= 0 && sysFreeMB < gStatSysFreeMinMB) {
        gStatSysFreeMinMB = sysFreeMB;
    }
    NSProcessInfo *pi = [NSProcessInfo processInfo];
    long thermal = [pi thermalState];
    if (thermal > gStatThermalMax) {
        gStatThermalMax = thermal;
    }
    if ([pi isLowPowerModeEnabled]) {
        gStatLowPower = YES;
    }
    if ((gStatCPUCount & 1) == 0) {
        // NOTE: the binary calls CFPreferencesAppSynchronize directly
        // here, not the _OMCPrefsSync wrapper.
        CFPreferencesAppSynchronize(CFSTR("com.anlai.omnicar"));
    }
    long thermalNow = [pi thermalState];   // re-read, as in the binary
    if (!OMCEnabled()) {
        OMCAutoLiteEvaluate(0, nil);
    } else if ([OMCPref(@"liteMode", @2) integerValue] != 2) {
        OMCAutoLiteEvaluate(0, nil);
    } else {
        double now = OMCMonotonicSeconds();
        if (thermalNow > 1) {
            OMCAutoLiteEvaluate(1, @"heat");
        } else if (gHangTimes[0] > 0 && now - gHangTimes[0] < 120.0) {
            OMCAutoLiteEvaluate(1, @"hangs");
        } else if (gStatLatePct >= 15.0) {
            OMCAutoLiteEvaluate(1, @"frames");
        } else if (!((gHangTimes[2] != 0 && now - gHangTimes[2] <= 180.0) ||
                     gStatLatePct > 5.0 || !gAutoLiteOn ||
                     now - gLiteStateChangedAt <= 180.0)) {
            OMCAutoLiteEvaluate(0, nil);
        }
        // Otherwise: no setter call at all this sample.
    }
    if (gStatCPUCount % 12 == 4 && gPerfSessionObject && !gPerfDisplayLink) {
        OMCEnsurePerfTicker();
        gPerfDisplayLink = [gPerfSessionObject
            displayLinkWithTarget:gPerfTicker
                         selector:sel_registerName("tick:")];
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
    if (gStatCPUCount % 6 == 0) {
        OMCFlushPerfStats();
    }
}

// ---------------------------------------------------------------------------
// sub_53f90 VERIFIED: the sampler — invoke function of the global block
// at 0x79480, installed by the session-start block (sub_52bfc) as the
// event handler of a DISPATCH_SOURCE_TYPE_TIMER firing every 250 ms on
// the serial queue "com.anlai.omnicar.perf".
//
// Every fire: latch-dispatch the hang watchdog to the main queue
// (skipped while a previous watchdog hop is still outstanding), and
// every 20th fire (5 s) measure and hand the values to the consumer.
// CPU usage sums non-idle threads only; -1.0 marks a failed measurement
// and is filtered by the consumer.
// ---------------------------------------------------------------------------
void (^const OMCPerfSamplerBlock)(void) = ^{
    double firedAt = OMCMonotonicSeconds();
    uint8_t expected = 0;
    if (atomic_compare_exchange_strong(&gSamplerMainBusy, &expected, 1)) {
        dispatch_async(dispatch_get_main_queue(), ^{
            OMCHangWatchdog(firedAt);
        });
    }
    int32_t fire = ++gSampleDivider;
    if (fire % 20 != 0) {
        return;
    }
    double cpu = -1.0, memMB = -1.0, sysFreeMB = -1.0;
    thread_act_array_t threads = NULL;
    mach_msg_type_number_t threadCount = 0;
    if (task_threads(mach_task_self(), &threads, &threadCount) == KERN_SUCCESS) {
        cpu = 0.0;
        for (mach_msg_type_number_t i = 0; i < threadCount; i++) {
            thread_basic_info_data_t info;
            mach_msg_type_number_t infoCount = THREAD_BASIC_INFO_COUNT;
            if (thread_info(threads[i], THREAD_BASIC_INFO,
                            (thread_info_t)&info, &infoCount) == KERN_SUCCESS &&
                !(info.flags & TH_FLAGS_IDLE)) {
                cpu += (double)info.cpu_usage * 100.0 / 1000.0;
            }
            mach_port_deallocate(mach_task_self(), threads[i]);
        }
        vm_deallocate(mach_task_self(), (vm_address_t)threads,
                      threadCount * sizeof(thread_t));
    }
    task_vm_info_data_t vmInfo;
    mach_msg_type_number_t vmCount = 89;   // literal in the binary
                                           // (TASK_VM_INFO_COUNT there)
    if (task_info(mach_task_self(), TASK_VM_INFO, (task_info_t)&vmInfo,
                  &vmCount) == KERN_SUCCESS) {
        memMB = (double)vmInfo.phys_footprint / 1048576.0;   // x 2^-20
    }
    if (gHostPort == 0) {
        gHostPort = mach_host_self();
        host_page_size(gHostPort, (vm_size_t *)&gHostPageSize);
    }
    vm_statistics64_data_t vmStats;
    mach_msg_type_number_t statCount = HOST_VM_INFO64_COUNT;   // 38
    if (host_statistics64(gHostPort, HOST_VM_INFO64,
                          (host_info64_t)&vmStats, &statCount) == KERN_SUCCESS) {
        sysFreeMB = (double)(vmStats.free_count + vmStats.inactive_count) *
                    (double)gHostPageSize / 1048576.0;       // x 2^-20
    }
    double availMB = (double)os_proc_available_memory() / 1048576.0;
    dispatch_async(dispatch_get_main_queue(), ^{
        OMCPerfSampleConsume(cpu, memMB, availMB, sysFreeMB);
    });
};
