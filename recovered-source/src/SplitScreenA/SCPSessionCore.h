// SCPSessionCore.h — OmniCarSplitScreen: car-session start/stop pair,
// the 4 s arming helper, the CarKit probe helpers and the lazy log-queue
// getter (the session cluster that owns the perf-telemetry lifecycle).
//
// Reconstructed from OmniCarSplitScreen.dylib (1.0.3, arm64 slice) by the
// session-closure pass. See SessionCore_REPORT.md for the evidence, the
// trigger-chain verdict and the delta list vs the OmniCarCore copy.
//
// These functions are this dylib's private copies of the shared OMC core
// machinery (the same source-level functions OmniCarCore.dylib carries as
// sub_9bc0 / sub_9814 / sub_97e4 / sub_6dd0). They are declared here because
// the registration site — the tail of _OMCCrashGuard (0x50e24, shared unit)
// — references them, and _OMCLogWrite (0x4fbf4, shared unit) calls the log
// queue getter.

#import <Foundation/Foundation.h>
#import <dispatch/dispatch.h>

NS_ASSUME_NONNULL_BEGIN

// sub_4fdfc — VERIFIED: lazy getter for the serial log queue
// ("com.anlai.omnicar.log", global 0x88290; once token 0x88298). The
// binary splits the dispatch_once into an outlined tail-call forwarder
// (sub_560e8) whose block (0x793c0, invoke sub_522a8) creates the queue.
dispatch_queue_t OMCLogQueue(void);

// sub_52820 — VERIFIED: screen-connect arming helper. Schedules the
// session-start recorder 4.0 s later (dispatch_time offset 0xEE6B2800 ns)
// on the main queue; the delayed block is global block 0x79460 whose
// invoke is the session-start function itself (sub_52bfc).
// The UIScreenDidConnectNotification observer block (0x79420, registered
// by _OMCCrashGuard) has invoke sub_5281c, a 4-byte thunk `b sub_52820`;
// _OMCCrashGuard also calls this function directly once at arm time for
// the already-connected case.
void OMCOnScreenConnected(void);

// sub_52850 — VERIFIED: session stop; invoke of the disconnect observer
// block 0x79440 (registered by _OMCCrashGuard for
// UIScreenDidDisconnectNotification, main queue, object nil). No-op when
// the disconnected screen is the main screen.
void OMCOnScreenDisconnected(NSNotification *notification);

NS_ASSUME_NONNULL_END
