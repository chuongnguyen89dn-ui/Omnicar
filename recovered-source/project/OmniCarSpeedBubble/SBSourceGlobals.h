// SBSourceGlobals.h — SpeedBubble SOURCE-APP side (agent B, wave 2.5)
// Shared state of OmniCarSpeedBubble.dylib as used inside the four speed
// source apps (Vietmap / GOFA / Waze / Wyn). Every global below was located
// in __DATA/__bss of the arm64 slice and cross-checked against the
// LC_DYSYMTAB-calibrated xref (metadata/xref/OmniCarSpeedBubble.json).
// Address comments are arm64-slice VAs in the original binary.
//
// Reconstruction status: VERIFIED (layout + addresses from disassembly).

#import <Foundation/Foundation.h>
#import <notify.h>

@class SPPSpeedGPS;

// Host table (constant arrays in __objc_arrayobj, decoded from the binary):
//   bundle IDs : vn.vietmap.live, com.lumi.GOFA, com.waze.iphone, com.wynauto.wyn
//   names      : Vietmap,         GOFA,          Waze,             Wyn
//   index      : 0                1              2                 3
extern int          SPPHostIndex;            // 0x43800 (defaults to 0 = Vietmap)

// ---- publication state (sub_5498 / SPPPublishSpeed) ----
extern int          SPPLastPublishedSpeed;   // 0x436a8
extern int          SPPLastPublishedLimit;   // 0x436ac
extern uint32_t     SPPSpeedNotifyToken;     // 0x43818 "com.anlai.omnicar/speedbubble.speed"

// ---- own-GPS location channel (didUpdateLocations) ----
extern uint32_t     SPPLocationNotifyToken;  // 0x43830 "com.anlai.omnicar/location"
extern double       SPPLastLocationPubTime;  // 0x43838 (CFAbsoluteTime)

// ---- source arbitration (sub_65a8 / SPPSourceIsActive) ----
extern uint32_t     SPPSourceNotifyToken;    // 0x43840 "com.anlai.omnicar/speedbubble.source"

// ---- Flutter-extracted limit (sub_6aa0) ----
extern int          SPPFlutterLimit;         // 0x436b0 (-1 = none)
extern double       SPPFlutterLimitTime;     // 0x43820
extern NSString    *SPPFlutterLimitKey;      // 0x437d0 ("<channel>/<key>")

// ---- screen-scan results (sub_7a84) ----
extern int          SPPScanLimit;            // 0x436b4
extern double       SPPScanLimitTime;        // 0x43828
extern int          SPPScanSpeed;            // 0x436bc
extern double       SPPScanSpeedTime;        // 0x43880
extern double       SPPLastFullScanTime;     // 0x43878
extern BOOL         SPPScanWasActive;        // 0x436b8 (tick change-log state)

// ---- cached scan views (written at end of the label scan, sub_7a84) ----
extern __weak id    SPPCachedSpeedView;      // 0x437e8 (objc_storeWeak)
extern id           SPPCachedLimitView;      // 0x437f0 (strong)
extern __weak id    SPPCachedAuxView;        // 0x437f8 (read in cached path)

// ---- AX scan budget state (sub_7a84 AX path) ----
extern double       SPPAXDeadline;           // 0x43888 (now + 0.04 s)
extern BOOL         SPPAXOverran;            // 0x43890 (set by sub_b878)
extern double       SPPAXLastBudgetLogTime;  // 0x43898 (20 s log throttle)

// ---- original IMPs saved by the hooks ----
extern IMP          SPPOrigCLStartUpdatingLocation;  // 0x43808
extern IMP          SPPOrigCLStopUpdatingLocation;   // 0x43810
extern IMP          SPPOrigFlutterTaskQueue;         // 0x43848
extern IMP          SPPOrigFlutterPlain;             // 0x43850
extern IMP          SPPOrigSwitchControlRunning;     // 0x43870 (stored, never called)

// ---- Flutter channel-watch state ----
extern NSSet       *SPPWatchedChannelExclusions;     // 0x43858 ({"vml_main_channel"})
extern NSMutableSet *SPPSeenChannelMethods;          // 0x43868 (discovery log, cap 299)

// ---- SPPSpeedGPS singleton ----
extern SPPSpeedGPS *SPPSpeedGPSSharedInstance;       // 0x437d8

// ---- shared OmniCar helpers (owned by the OMCCommon agent; declared here
// only as the interface this module was observed calling) ----
extern void OMCLogWrite(NSString *tag, NSString *message);
extern BOOL OMCCrashGuard(NSString *name);
extern id   OMCCarLaunchInfo(id applicationInfo);
extern void _OMCMissingSelector(NSString *module, id object,
                                NSString *selectorName);  // binary @0x2248c, 3-arg form (corrected: the stale 2-arg decl named a symbol with no definition and no call site)

#define SPPLog(fmt, ...) OMCLogWrite(@"SpeedBubble", [NSString stringWithFormat:(fmt), ##__VA_ARGS__])
