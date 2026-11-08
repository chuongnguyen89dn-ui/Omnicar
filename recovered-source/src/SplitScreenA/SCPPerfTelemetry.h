// SCPPerfTelemetry.h — the OMC performance-telemetry cluster of
// OmniCarSplitScreen.dylib (the copy of the shared OMCCommon unit linked
// into this binary).
//
// This cluster was claimed by NO source file before the coverage census
// (metadata/COVERAGE_GAPS.md): the census flagged sub_53f90 and sub_54448
// as unclaimed, and SplitScreen-C's adjudication identified sub_54448 as
// the lite-mode telemetry consumer that creates the OMCPerfTicker class.
// This header declares the two cross-translation-unit seams of the
// cluster; every other name in SCPPerfTelemetry.m is a file-static in the
// binary, exactly as transcribed there.
//
// Cross-TU seams (the session machinery lives in the same original TU in
// the binary; in this reconstruction the session-start/stop block invokes
// sub_52bfc / sub_52850 are NOT part of this cluster — see
// PerfTelemetry_REPORT.md §4 — so the two names they consume are
// exported here):
//
//   * OMCPerfSamplerBlock — the global block at 0x79480 whose invoke
//     function IS sub_53f90. sub_52bfc installs it as the event handler
//     of a 250 ms dispatch timer ("com.anlai.omnicar.perf").
//   * OMCSetLiteNotifyState — sub_53f20, the `com.anlai.omnicar/lite`
//     writer; also called directly by sub_52bfc when a session is armed.
//
// All session/perf state statics are defined in SCPPerfTelemetry.m with
// their binary addresses (0x88258–0x883c8); the session blocks write
// several of them directly in the original TU.

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

// sub_53f90 (invoke) — global block @0x79480 VERIFIED.
extern void (^const OMCPerfSamplerBlock)(void);

#ifdef __cplusplus
extern "C" {
#endif

// sub_53f20 VERIFIED: set + post the `com.anlai.omnicar/lite` state.
void OMCSetLiteNotifyState(int state);

#ifdef __cplusplus
}
#endif

NS_ASSUME_NONNULL_END
