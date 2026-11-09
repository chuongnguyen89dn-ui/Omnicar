// ABYTLease.h — shared YT-ZOOM lease contract (design-ytzoom.md §4).
// YT-ZOOM virtualizes orientation for ONE hosted bundle (YouTube):
// the host (ABHost, SpringBoard) pins the scene at orientation 1 and
// issues a short-lived lease carrying the pane's committed logical
// size; the app side (ABInApp) answers every orientation surface with
// Portrait while — and only while — a valid lease lives.
//
// This header is the single definition of the wire contract both
// sides build against: channel names, payload keys, ack phases and
// the timing constants. The channels are NEW NSDistributed names —
// the three orientation/keyboard channels (appbridge.apporient,
// appbridge.orientation, appbridge.keyboard) are never reused for
// the lease (design hard rule 3).

#ifndef ABYTLEASE_H
#define ABYTLEASE_H

#import <Foundation/Foundation.h>

// ---- channels (§4.1): NSDistributed, object = the app's bundleID ----
static NSString *const ABYTLeaseChannel    = @"com.anlai.omnicar/appbridge.ytlease";
static NSString *const ABYTLeaseAckChannel = @"com.anlai.omnicar/appbridge.ytleaseack";

// ---- the one virtualized bundle in v1 (§0, hard rule 4) ----
static NSString *const ABYTLeaseYouTubeBundle = @"com.google.ios.youtube";

// ---- lease payload keys, host -> app (§4.2) ----
static NSString *const ABYTLeaseKeyVersion     = @"version";     // NSNumber, == 1
static NSString *const ABYTLeaseKeyOwner       = @"owner";       // NSString UUID, per ABHost session
static NSString *const ABYTLeaseKeyGeneration  = @"generation";  // NSNumber, ++ only on content change
static NSString *const ABYTLeaseKeyIssuedAt    = @"issuedAt";     // NSNumber, wall-clock epoch seconds
static NSString *const ABYTLeaseKeyActive      = @"active";      // NSNumber BOOL; NO = revoke
static NSString *const ABYTLeaseKeyOrientation = @"orientation"; // NSNumber, == 1
static NSString *const ABYTLeaseKeyWidth       = @"width";       // NSNumber, committed logical size
static NSString *const ABYTLeaseKeyHeight      = @"height";      // NSNumber
static NSString *const ABYTLeaseKeyIsSplit     = @"isSplit";     // NSNumber BOOL
static NSString *const ABYTLeaseKeySceneID     = @"sceneID";     // NSString, only when the host has one

// ---- ack payload keys, app -> host (§4.5) ----
static NSString *const ABYTLeaseAckKeyIdentifier = @"identifier"; // the app's bundleID
static NSString *const ABYTLeaseAckKeyPhase      = @"phase";      // NSString, one of the phases below
static NSString *const ABYTLeaseAckKeyGeneration = @"generation"; // NSNumber
static NSString *const ABYTLeaseAckKeyWindows    = @"windows";    // NSNumber
static NSString *const ABYTLeaseAckKeyWidth      = @"width";      // NSNumber, measured after apply
static NSString *const ABYTLeaseAckKeyHeight     = @"height";     // NSNumber
static NSString *const ABYTLeaseAckKeyMismatch   = @"mismatch";   // NSNumber; -1 = no scene matched

// ---- ack phases (§4.5) ----
static NSString *const ABYTLeasePhaseRequest = @"request"; // hosted but no valid lease; throttled 2 s
static NSString *const ABYTLeasePhaseApplied = @"applied"; // relay applied a content change
static NSString *const ABYTLeasePhaseRevoked = @"revoked"; // left virtualization on a valid revoke
static NSString *const ABYTLeasePhaseExpired = @"expired"; // left virtualization on silent expiry

// ---- timing / version constants (§4.2–§4.3) ----
static const NSInteger ABYTLeaseVersion  = 1;
static const double    ABYTLeaseTTL      = 3.0; // s from issuedAt; host heartbeat 1.0 s

#endif // ABYTLEASE_H
