// SPPPrefs.m — reconstructed from OmniCarSpeedBubble.dylib (arm64) disassembly.
// Agent A (display side). Every method below was read instruction-by-instruction
// in disasm/ and is VERIFIED unless a comment says INFERRED.
// Prefs domain: com.anlai.omnicar (CFPreferences). Reads go through the shared
// OmniCar helpers _OMCPrefsSync()/_OMCPref(key) (OMC core, not part of this
// module's original source beyond the call sites shown).

#import <Foundation/Foundation.h>
#import <CoreFoundation/CoreFoundation.h>
#import <notify.h>   // notify_post (phase-2 compile fix: was undeclared)

// Shared OMC core helpers (defined in the OMC shared block of the dylib).
extern void _OMCPrefsSync(void);
extern id _OMCPref(NSString *key, id defaultValue);  // [phase-2 integration; backported to src in phase 3] 2-arg form: binary sub_1edb0 passes x1 = nil (@0x1edd0 `mov x1,#0`); matches OMCCommon.h `id OMCPref(id, id)`
extern BOOL _OMCFeatureEnabled(NSString *featureKey);

// sub_1edb0 @0x1edb0 — retained pref object for key (after a prefs sync).
static id SPPPrefObject(NSString *key) {
    _OMCPrefsSync();
    return _OMCPref(key, nil);  // [phase-2 integration; backported to src in phase 3] see declaration note above
}

// sub_1f108 @0x1f108 — integer pref with range guard:
// value = [obj respondsToSelector:@selector(integerValue)] ? [obj integerValue] : 0;
// returns value if value < limit, else 0.
static NSInteger SPPIntPref(NSString *key, NSInteger limit) {
    id obj = SPPPrefObject(key);
    NSInteger v = [obj respondsToSelector:@selector(integerValue)] ? [obj integerValue] : 0;
    return (v < limit) ? v : 0;
}

@interface SPPPrefs : NSObject
+ (BOOL)enabled;
+ (NSInteger)style;              // 0..8  (9 bubble styles)
+ (BOOL)showAppIcon;             // default YES
+ (double)sizePercentForCar:(BOOL)car;          // clamp [3, 220], default 100
+ (void)setSizePercent:(double)pct forCar:(BOOL)car;
+ (void)setWarnMode:(NSInteger)mode;            // clamp 0..3
+ (NSInteger)warnMode;           // 0..3, default 3
+ (NSInteger)warnFx;             // 0..3
+ (BOOL)warnVoice;               // speedBubbleWarnSound == 1
+ (NSInteger)warnTone;           // 0..5
+ (NSInteger)warnVoiceLine;      // 0..8
+ (NSString *)warnVoiceText;
+ (NSInteger)color;              // 0..6
+ (double)warnMarginKmh;         // round(), clamp [-10, 10], default 5
+ (NSInteger)source;             // 0..3 (0=Vietmap 1=GOFA 2=Waze 3=Wyn)
+ (BOOL)appEnabled:(NSInteger)app;
@end

@implementation SPPPrefs

// @0x1ed28 — feature gate via OMC core.
+ (BOOL)enabled {
    _OMCPrefsSync();
    return _OMCFeatureEnabled(@"speedBubble");
}

// @0x1ed44 — VERIFIED: nil -> 0; unsigned compare, value >= 9 -> 0.
+ (NSInteger)style {
    id v = SPPPrefObject(@"speedBubbleLook");
    if (!v) return 0;
    NSInteger s = [v integerValue];
    return ((NSUInteger)s < 9) ? s : 0;
}

// @0x1ee0c — VERIFIED: nil -> YES.
+ (BOOL)showAppIcon {
    id v = SPPPrefObject(@"speedBubbleShowAppIcon");
    return v ? [v boolValue] : YES;
}

// @0x1ee74 — VERIFIED: key by side, nil -> 100, clamp [3.0, 220.0].
+ (double)sizePercentForCar:(BOOL)car {
    id v = SPPPrefObject(car ? @"speedBubbleSizeCar" : @"speedBubbleSizePhone");
    double pct = v ? [v doubleValue] : 100.0;
    pct = fmax(pct, 3.0);
    if (pct > 220.0) pct = 220.0;
    return pct;
}

// @0x1ef10 — VERIFIED: clamp [3,220], round to integer (frinta),
// CFPreferences write + synchronize. NOTE: does NOT post prefschanged
// (asymmetry with setWarnMode: is in the binary, kept faithfully).
+ (void)setSizePercent:(double)pct forCar:(BOOL)car {
    NSString *key = car ? @"speedBubbleSizeCar" : @"speedBubbleSizePhone";
    double v = fmax(pct, 3.0);
    if (v > 220.0) v = 220.0;
    v = round(v);
    CFPreferencesSetAppValue((__bridge CFStringRef)key,
                             (__bridge CFPropertyListRef)@(v),
                             CFSTR("com.anlai.omnicar"));
    CFPreferencesAppSynchronize(CFSTR("com.anlai.omnicar"));
}

// @0x1efb8 — VERIFIED: clamp 0..3 (negatives -> 0); writes the integer to
// speedBubbleWarnMode AND kCFBooleanTrue to speedBubbleWarnModeV2
// (marks the value as written by the V2 setter), synchronize,
// notify_post("com.anlai.omnicar/prefschanged").
+ (void)setWarnMode:(NSInteger)mode {
    NSInteger m = mode < 0 ? 0 : mode;
    if (m > 3) m = 3;
    CFPreferencesSetAppValue(CFSTR("speedBubbleWarnMode"),
                             (__bridge CFPropertyListRef)@(m),
                             CFSTR("com.anlai.omnicar"));
    CFPreferencesSetAppValue(CFSTR("speedBubbleWarnModeV2"),
                             kCFBooleanTrue,
                             CFSTR("com.anlai.omnicar"));
    CFPreferencesAppSynchronize(CFSTR("com.anlai.omnicar"));
    notify_post("com.anlai.omnicar/prefschanged");
}

// @0x1f034 — VERIFIED:
//   no key            -> 3
//   stored value != 2 -> that value
//   stored value == 2 -> speedBubbleWarnModeV2 ? 2 : 3
//     (legacy "2" written before V2 existed means mode 3; the V2 setter
//      always writes V2=true, so its own 2 reads back as 2)
//   result clamped to <= 3.
+ (NSInteger)warnMode {
    id v = SPPPrefObject(@"speedBubbleWarnMode");
    NSInteger mode;
    if (!v) {
        mode = 3;
    } else {
        mode = [v integerValue];
        if (mode == 2) {
            BOOL v2 = [SPPPrefObject(@"speedBubbleWarnModeV2") boolValue];
            mode = v2 ? 2 : 3;
        }
    }
    return ((NSUInteger)mode < 3) ? mode : 3;
}

// @0x1f0f8
+ (NSInteger)warnFx {
    return SPPIntPref(@"speedBubbleWarnFx", 4);
}

// @0x1f17c — VERIFIED: sound pref enum (valid 0/1 via limit 2); voice on iff 1.
+ (BOOL)warnVoice {
    return SPPIntPref(@"speedBubbleWarnSound", 2) == 1;
}

// @0x1f1a4
+ (NSInteger)warnTone {
    return SPPIntPref(@"speedBubbleWarnTone", 6);
}

// @0x1f1b4
+ (NSInteger)warnVoiceLine {
    return SPPIntPref(@"speedBubbleWarnVoice", 9);
}

// @0x1f1c4 — VERIFIED: NSString value or @"".
+ (NSString *)warnVoiceText {
    id v = SPPPrefObject(@"speedBubbleWarnVoiceText");
    return [v isKindOfClass:[NSString class]] ? v : @"";
}

// @0x1f244
+ (NSInteger)color {
    return SPPIntPref(@"speedBubbleColor", 7);
}

// @0x1f254 — VERIFIED: nil -> 5.0; value rounded (frinta = round-half-away);
// clamp [-10, 10].
+ (double)warnMarginKmh {
    id v = SPPPrefObject(@"speedBubbleWarnOver");
    double m = v ? round([v doubleValue]) : 5.0;
    m = fmax(m, -10.0);
    if (m > 10.0) m = 10.0;
    return m;
}

// @0x1f2d8 — VERIFIED, including the quirky legacy fallback (transcribed
// exactly; Waze/Wyn per-app keys are never consulted here):
//   if speedBubbleSource exists:
//       s = intValue; v2 = [speedBubbleSourceV2 boolValue];
//       if (v2) r = s;
//       else { r = (s < 2) ? s : 0; if (s == 4) r = 2; }   // legacy remap
//       return (r < 4) ? r : 0;
//   else:
//       vmObj = pref(speedBubbleAppVietmap);
//       if (!vmObj) return 0;
//       if ([vmObj boolValue]) return 0;
//       gofaObj = pref(speedBubbleAppGOFA);
//       if (!gofaObj) return 1;
//       return [gofaObj boolValue] ? 1 : 0;
+ (NSInteger)source {
    id v = SPPPrefObject(@"speedBubbleSource");
    if (v) {
        int s = [v intValue];
        BOOL v2 = [SPPPrefObject(@"speedBubbleSourceV2") boolValue];
        int r;
        if (v2) {
            r = s;
        } else {
            r = ((unsigned)s < 2) ? s : 0;
            if (s == 4) r = 2;
        }
        return ((unsigned)r < 4) ? r : 0;
    }
    id vm = SPPPrefObject(@"speedBubbleAppVietmap");
    if (!vm) return 0;
    if ([vm boolValue]) return 0;
    id gofa = SPPPrefObject(@"speedBubbleAppGOFA");
    if (!gofa) return 1;
    return [gofa boolValue] ? 1 : 0;
}

// @0x1f430 — VERIFIED: exactly one source app is "enabled": the selected one.
+ (BOOL)appEnabled:(NSInteger)app {
    return [self source] == app;
}

@end
