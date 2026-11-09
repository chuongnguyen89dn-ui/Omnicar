// BridgeWakePack.h — bridgewake.v1 packet pack/unpack (design §3).
//
// ONE canonical copy per module (OmniCarSplitScreen + OmniCarAppBridge);
// integration diffs the two copies and requires 0 differences. Layout and
// test vectors below are copied verbatim from
// work/wake-round/design-bridgewake.md §3.2/§3.4 — do not edit one copy
// without the other.
//
// The packet core is pure C (stdint/stdbool) so the Gate-1 unit harness
// can exercise it on the build VM; the NSString hash wrapper is the only
// Foundation-dependent part and is compiled out under BW_PACK_NO_FOUNDATION.
//
// Darwin channel names (design §3.1) are NOT declared here; each module
// defines the identical strings in its own constants file
// (SCPShared.m / ABChannelNames.m):
//   state  "com.anlai.omnicar/bridgewake.v1.state"  owner -> apps + ABHost
//   query  "com.anlai.omnicar/bridgewake.v1.query"  app   -> owner
//   wake   "com.anlai.omnicar/bridgewake.v1.wake"   app   -> owner (+ABHost)
//   ack    "com.anlai.omnicar/bridgewake.v1.ack"    both ways, split by role
//
// Bit layout (design §3.2 — one layout for all four channels, uint64):
//   bit  63     v           1  always 1 in a valid packet; an empty /
//                              never-set slot reads 0 -> v=0 = no packet
//   bits 62-35  hash       28  high 28 bits of FNV-1a-32(bundleID):
//                              BWBundleHash(bundle) >> 4
//   bits 34-23  seq        12  sender sequence (owner: per state emission,
//                              monotone modulo 4096; app: per wake
//                              transaction; ack echoes the wake's seq)
//   bits 22-11  gen        12  assignment generation of the slot holding
//                              the bundle (owner is the only source,
//                              1..4095, wraps modulo)
//   bit  10     flag        1  state packet -> pinchAllowed (arbitrated);
//                              ack packet -> role (0 = owner->app,
//                              1 = ABHost->owner); act packet -> kbActive
//                              (design-autohide §4.2); query/wake -> 0
//   bits  9-8   pinchMode   2  0=OFF, 1=DRY_RUN, 2=ENFORCE, 3=reserved
//                              (receivers treat 3 as OFF)
//   bits  7-6   wakeMode    2  same encoding as pinchMode
//   bits  5-3   state       3  0=INACTIVE, 1=UNKNOWN, 2=VISIBLE, 3=HIDDEN,
//                              4=WAKING, 5-7 reserved (receivers treat
//                              as UNKNOWN)
//   bits  2-0   type        3  1=state, 2=query, 3=wake, 4=ack,
//                              5=act (design-autohide §3.2.1); 0=invalid,
//                              6-7 reserved
//
// Field discipline (design §3.2): state/wakeMode/pinchMode/flag carry
// meaning only in type=state packets (except flag=role and state=applied
// state in ack packets); in query/wake packets they are 0. Act packets
// (design-autohide §3.2.1) carry v/hash/gen/seq plus flag=kbActive; their
// state/mode fields are 0. Receivers drop packets with v=0, a type that
// does not match the channel, a hash that is not their bundle's, or a gen
// older than the newest known gen.

#ifndef BRIDGEWAKE_PACK_H
#define BRIDGEWAKE_PACK_H

#include <stdint.h>
#include <stdbool.h>

#ifdef __cplusplus
extern "C" {
#endif

// Packet types (bits 2-0).
enum {
    BWTypeInvalid = 0,
    BWTypeState   = 1,
    BWTypeQuery   = 2,
    BWTypeWake    = 3,
    BWTypeAck     = 4,
    BWTypeAct     = 5 // app -> owner activity (design-autohide §3.2.1)
    // 6-7 reserved
};

// Chrome states (bits 5-3).
enum {
    BWStateInactive = 0,
    BWStateUnknown  = 1,
    BWStateVisible  = 2,
    BWStateHidden   = 3,
    BWStateWaking   = 4
};

// Feature modes (bits 7-6 wakeMode, bits 9-8 pinchMode).
enum {
    BWModeOff    = 0,
    BWModeDryRun = 1,
    BWModeEnforce = 2
    // 3 = reserved; receivers treat it as OFF (BWModeNormalise).
};

typedef struct {
    bool     valid;     // v bit
    uint32_t hash28;    // bits 62-35
    uint16_t seq;       // bits 34-23 (12 bits)
    uint16_t gen;       // bits 22-11 (12 bits)
    bool     flag;      // bit 10 (pinchAllowed in state, role in ack)
    uint8_t  pinchMode; // bits 9-8 (raw; normalise before use)
    uint8_t  wakeMode;  // bits 7-6 (raw; normalise before use)
    uint8_t  state;     // bits 5-3 (raw; 5-7 mean UNKNOWN to receivers)
    uint8_t  type;      // bits 2-0
} BWPacket;

// FNV-1a 32-bit over the bundle ID's UTF-8 bytes (offset 0x811C9DC5,
// prime 0x01000193) — byte-identical algorithm to ABBundleHash in
// AppBridgeB.h, which the original producer/host code already shares.
static inline uint32_t BWBundleHashCString(const char *s) {
    uint32_t h = 0x811C9DC5u;
    if (s) {
        while (*s) { h = (h ^ (uint8_t)*s) * 0x01000193u; s++; }
    }
    return h;
}

// Receivers treat reserved mode value 3 as OFF (design §3.2).
static inline uint8_t BWModeNormalise(uint8_t rawMode) {
    return (rawMode == 3) ? (uint8_t)BWModeOff : rawMode;
}

// Receivers treat reserved state values 5-7 as UNKNOWN (design §3.2).
static inline uint8_t BWStateNormalise(uint8_t rawState) {
    return (rawState > 4) ? (uint8_t)BWStateUnknown : rawState;
}

static inline uint64_t BWPackFields(uint32_t hash28, unsigned seq,
                                    unsigned gen, bool flag,
                                    unsigned pinchMode, unsigned wakeMode,
                                    unsigned state, unsigned type) {
    uint64_t p = 0;
    p |= (uint64_t)1u << 63;                       // v
    p |= (uint64_t)(hash28 & 0x0FFFFFFFu) << 35;   // hash
    p |= (uint64_t)(seq & 0xFFFu) << 23;           // seq
    p |= (uint64_t)(gen & 0xFFFu) << 11;           // gen
    p |= (uint64_t)(flag ? 1u : 0u) << 10;         // flag
    p |= (uint64_t)(pinchMode & 0x3u) << 8;        // pinchMode
    p |= (uint64_t)(wakeMode & 0x3u) << 6;         // wakeMode
    p |= (uint64_t)(state & 0x7u) << 3;            // state
    p |= (uint64_t)(type & 0x7u);                  // type
    return p;
}

static inline BWPacket BWUnpack(uint64_t p) {
    BWPacket out;
    out.valid     = (bool)((p >> 63) & 0x1u);
    out.hash28    = (uint32_t)((p >> 35) & 0x0FFFFFFFu);
    out.seq       = (uint16_t)((p >> 23) & 0xFFFu);
    out.gen       = (uint16_t)((p >> 11) & 0xFFFu);
    out.flag      = (bool)((p >> 10) & 0x1u);
    out.pinchMode = (uint8_t)((p >> 8) & 0x3u);
    out.wakeMode  = (uint8_t)((p >> 6) & 0x3u);
    out.state     = (uint8_t)((p >> 3) & 0x7u);
    out.type      = (uint8_t)(p & 0x7u);
    return out;
}

#ifdef __cplusplus
}
#endif

#ifndef BW_PACK_NO_FOUNDATION
#import <Foundation/Foundation.h>
// NSString front-end over the identical C core above.
static inline uint32_t BWBundleHash(NSString *bundleID) {
    return BWBundleHashCString(bundleID.UTF8String);
}
static inline uint32_t BWBundleHash28(NSString *bundleID) {
    return BWBundleHash(bundleID) >> 4;
}
#endif // BW_PACK_NO_FOUNDATION

// Test vectors (design §3.4, verbatim — shared by the implementation
// strands and the Gate-1 unit test). Reference hashes:
//   FNV1a32("com.google.ios.youtube") = 0xD3B4E0DF -> hash28 0xD3B4E0D
//   FNV1a32("vn.vietmap.live")        = 0x2E775677 -> hash28 0x2E77567
// V1 state: yt, HIDDEN(3), wakeMode=DRY_RUN(1), pinchMode=OFF(0),
//    flag=0, gen=7, seq=101                    -> 0xE9DA706832803859
// V2 state: yt, VISIBLE(2), wakeMode=ENFORCE(2), pinchMode=ENFORCE(2),
//    flag=1, gen=7, seq=102                    -> 0xE9DA706833003E91
// V3 query: vietmap, gen=0, seq=1 (state/mode fields 0)
//                                               -> 0x973BAB3800800002
// V4 wake: yt, gen=7, seq=41                    -> 0xE9DA706814803803
// V5 ack: owner->app, role=0, state=VISIBLE(2), yt, gen=7, seq=41 (echo V4)
//                                               -> 0xE9DA706814803814
// V6 ack: ABHost->owner, role=1, state=VISIBLE(2), yt, gen=7, seq=41
//                                               -> 0xE9DA706814803C14
// V7 wake: yt, gen=6 (stale), seq=42            -> 0xE9DA706815003003
//    (owner drops it: gen 6 != current gen 7)
// V8 empty slot reads 0                         -> v=0, no packet
// V9 act: yt, gen=7, seq=1, flag=0 (kb inactive), state/mode fields 0
//    (design-autohide §3.2.1)                   -> 0xE9DA706800803805
// V10 act: yt, gen=7, seq=2, flag=1 (kbActive)  -> 0xE9DA706801003C05

#endif // BRIDGEWAKE_PACK_H
