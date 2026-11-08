// SBPublish.m — SpeedBubble SOURCE-APP side (agent B, wave 2.5)
// The publication path: how a speed reading leaves the source app.
// Everything here is VERIFIED from disassembly of OmniCarSpeedBubble.dylib
// (arm64) unless a line is explicitly marked INFERRED.
//
// CHANNEL PROOF (xref): the only cross-process writes in the source-app
// range are notify_set_state + notify_post on three Darwin notify names:
//   "com.anlai.omnicar/speedbubble.speed"   — packed speed/limit (below)
//   "com.anlai.omnicar/speedbubble.source"  — READ here (state written by
//                                             the display side: the index
//                                             of the currently-chosen
//                                             source host)
//   "com.anlai.omnicar/location"            — packed lat/lon (SPPSpeedGPS.m)
// No file writes, no NSDistributedNotificationCenter on this side.

#import "SBSourceGlobals.h"
#import "SPPSpeedGPS.h"
#import <CoreLocation/CoreLocation.h>
#import <UIKit/UIKit.h>
#import <math.h>

// ---- globals (addresses in SBSourceGlobals.h) ----
int          SPPHostIndex;
int          SPPLastPublishedSpeed, SPPLastPublishedLimit;
uint32_t     SPPSpeedNotifyToken, SPPLocationNotifyToken, SPPSourceNotifyToken;
double       SPPLastLocationPubTime;
int          SPPFlutterLimit;
double       SPPFlutterLimitTime;
NSString    *SPPFlutterLimitKey;
int          SPPScanLimit, SPPScanSpeed;
double       SPPScanLimitTime, SPPScanSpeedTime, SPPLastFullScanTime;
BOOL         SPPScanWasActive;
__weak id    SPPCachedSpeedView;
id           SPPCachedLimitView;
__weak id    SPPCachedAuxView;
double       SPPAXDeadline, SPPAXLastBudgetLogTime;
BOOL         SPPAXOverran;
IMP          SPPOrigCLStartUpdatingLocation, SPPOrigCLStopUpdatingLocation;
IMP          SPPOrigFlutterTaskQueue, SPPOrigFlutterPlain;
IMP          SPPOrigSwitchControlRunning;
NSSet       *SPPWatchedChannelExclusions;
NSMutableSet *SPPSeenChannelMethods;
SPPSpeedGPS *SPPSpeedGPSSharedInstance;

// sub_538c — SPPKmhFromLocation — VERIFIED
// Returns -1 for: nil location, fix older than 3.0 s, horizontal accuracy
// outside 0..100 m, or a computed speed above 300 km/h. Otherwise
// round(max(speed, 0) * 3.6). *ageOut receives the fix age even for nil
// (as -1) — written before the nil check in the original.
int SPPKmhFromLocation(CLLocation *loc, double *ageOut) {
    if (ageOut) {
        *ageOut = -1;
    }
    if (!loc) {
        return -1;
    }
    double age = -[loc.timestamp timeIntervalSinceNow];
    if (ageOut) {
        *ageOut = age;
    }
    if (age > 3.0) {
        return -1;
    }
    double accuracy = loc.horizontalAccuracy;
    if (accuracy < 0 || accuracy > 100.0) {
        return -1;
    }
    double kmh = round(fmax(loc.speed, 0.0) * 3.6);
    if (kmh > 300) {
        return -1;
    }
    return (int)kmh;
}

// sub_5734 — SPPCurrentLimit — VERIFIED
// Priority: a fresh Flutter-channel limit (younger than 600 s) wins over a
// fresh screen-scan limit (younger than 2 s). -1 when neither is fresh.
int SPPCurrentLimit(void) {
    double now = CFAbsoluteTimeGetCurrent();
    if (SPPFlutterLimitTime > 0 && now - SPPFlutterLimitTime < 600.0) {
        return SPPFlutterLimit;
    }
    if (now - SPPScanLimitTime < 2.0) {
        return SPPScanLimit;
    }
    return -1;
}

// sub_5498 — SPPPublishSpeed — VERIFIED (state packing read instruction
// by instruction; the lazy notify_register_check mirrors sub_65a8 and is
// the one INFERRED detail).
//
// Darwin notify "com.anlai.omnicar/speedbubble.speed", 32-bit state:
//   bits  0..7   limit, clamped 0..255 (a negative limit becomes 0 here;
//                meta bit 1 is the limit-valid flag — set iff limit >= 0,
//                so a negative limit is signalled by bit 1 being CLEAR)
//   bits  8..15  speed, clamped 0..255
//   bits 16..31  meta = (hostIndex << 3) + sceneCode
//                       + (limit >= 0 ? 2 : 0) + (speed >= 0 ? 1 : 0)
//                sceneCode = 4 when (on the main thread) any
//                foreground-active connected scene has a session role NOT
//                containing "InstrumentCluster", else 0; off the main
//                thread sceneCode is 0.
// Called on every accepted GPS fix and on every 0.3 s scan tick, so the
// effective cadence is the GPS fix rate / tick rate — no extra throttle.
void SPPPublishSpeed(int speed, int limit) {
    SPPLastPublishedSpeed = speed;
    SPPLastPublishedLimit = limit;

    int sceneCode = 0;
    if ([NSThread isMainThread]) {
        for (UIScene *scene in [UIApplication sharedApplication].connectedScenes) {
            if (scene.activationState == UISceneActivationStateForegroundActive &&
                ![scene.session.role containsString:@"InstrumentCluster"]) {
                sceneCode = 4;
                break;
            }
        }
    }

    int meta = (SPPHostIndex << 3) + sceneCode +
               (limit >= 0 ? 2 : 0) + (speed >= 0 ? 1 : 0);
    int clampedLimit = limit < 0 ? 0 : (limit > 255 ? 255 : limit);
    int clampedSpeed = speed < 0 ? 0 : (speed > 255 ? 255 : speed);
    uint32_t state = (uint32_t)clampedLimit |
                     ((uint32_t)clampedSpeed << 8) |
                     ((uint32_t)meta << 16);

    if (!SPPSpeedNotifyToken) {
        notify_register_check("com.anlai.omnicar/speedbubble.speed",
                              (int *)&SPPSpeedNotifyToken);
    }
    notify_set_state(SPPSpeedNotifyToken, state);
    notify_post("com.anlai.omnicar/speedbubble.speed");
}

// sub_65a8 — SPPSourceIsActive — VERIFIED
// Hosts 0 (Vietmap) and 1 (GOFA) are always allowed to publish. Hosts 2
// (Waze) and 3 (Wyn) must first win arbitration: the display side writes
// the chosen host index as the state of
// "com.anlai.omnicar/speedbubble.source"; the source app compares it
// against its own host index. (The writer is NOT in this dylib's
// source-app range — display side, agent A / coordinator.)
BOOL SPPSourceIsActive(void) {
    if (SPPHostIndex < 2) {
        return YES;
    }
    if (!SPPSourceNotifyToken) {
        notify_register_check("com.anlai.omnicar/speedbubble.source",
                              (int *)&SPPSourceNotifyToken);
    }
    uint64_t state = 0;
    notify_get_state(SPPSourceNotifyToken, &state);
    return (int)state == SPPHostIndex;
}
