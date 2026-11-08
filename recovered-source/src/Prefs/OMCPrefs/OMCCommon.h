// OMCCommon.h — shared helpers statically linked into OmniCarPrefs
// (the same "OMCCommon" core is embedded in every OmniCar binary).
//
// RECONSTRUCTION NOTES
//   Evidence: disasm/_CFunctions.asm (42 C functions), metadata strings/objc dump.
//   [VERIFIED] = read directly from disassembly. [INFERRED] = name/semantics
//   reconstructed from call sites; the original symbol names for static
//   helpers are not present in the binary (only exported _OMC* names are).

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class SSStartupView;

#ifdef __cplusplus
extern "C" {
#endif

// Preference domain for the whole package (CFPreferences application id).
// [VERIFIED: CFString "com.anlai.omnicar" passed to every CFPreferences call]
#define OMC_PREFS_DOMAIN CFSTR("com.anlai.omnicar")
// Darwin/notify_post name posted after every preference write.
// [VERIFIED in -[OMCCardPage storeValue:forKey:] and PS specifier writes]
#define OMC_PREFS_CHANGED_NOTIFICATION "com.anlai.omnicar/prefschanged"

// ---------------------------------------------------------------------------
// Localised strings
// ---------------------------------------------------------------------------

/// Merged dictionary of every *.strings table of the active locale
/// (en.lproj is loaded first as fallback, active locale overrides).
/// Loaded by OMCLoadStrings(); result cached in a file-static variable.
/// [VERIFIED: _OMCLoadStrings, _L]
NSDictionary *OMCLoadStrings(void);

/// _L(key) == OMCLocalizedStrings()[key] ?: key   [VERIFIED: _L, 108 bytes]
NSString *L(NSString *key);

/// Tr(viText, enText):
///   language == "vi"  -> viText
///   language == "en"  -> enText
///   otherwise         -> Car.strings[enText] of that locale ?: enText
/// Per-locale Car.strings dictionaries are cached in a static
/// NSMutableDictionary guarded by @synchronized + dispatch_once.
/// [VERIFIED: _OMCTr, 632 bytes]
NSString *OMCTr(NSString *viText, NSString *enText);

// ---------------------------------------------------------------------------
// Language
// ---------------------------------------------------------------------------

/// The 14 supported locale codes, in this exact order:
/// vi en es pt-BR de fr it ru zh-Hans ja ko ar th id
/// [VERIFIED: constant array at 0x7f710 decoded from __objc_arraydata]
NSArray<NSString *> *OMCSupportedLanguages(void);
NSArray<NSString *> *OMCLanguages(void); // tail-call alias [VERIFIED]

/// Active language: preference "language" if it is a supported code, else the
/// first NSLocale preferredLanguage that matches a supported code exactly,
/// by "code-" prefix, or by base language; fallback @"en".
/// [VERIFIED: _OMCCurrentLanguage, 920 bytes]
NSString *OMCCurrentLanguage(void);
NSString *OMCLanguage(void); // tail-call alias [VERIFIED]

/// Display name of a language code from a constant lookup table
/// (ar→العربية, de→Deutsch, en→English, ..., vi→Tiếng Việt, zh-Hans→简体中文);
/// returns the code itself when unknown. [VERIFIED: _OMCLanguageName + dict
/// constant at 0x80030 decoded]
NSString *OMCLanguageName(NSString *code);

// ---------------------------------------------------------------------------
// Master switch / expiry
// ---------------------------------------------------------------------------

/// YES unless OMCExpired(), otherwise preference "enabled" (default YES).
/// [VERIFIED: _OMCEnabled, 100 bytes]
BOOL OMCEnabled(void);

/// Expiry check with anti-clock-rollback: expired when
/// max(now, preference "trustedTime") >= expiry timestamp; the timestamp and
/// the result are computed once and cached in statics.
/// [VERIFIED: _OMCExpired, 252 bytes; the deadline constant is initialised by
/// the once-block at 0x557c8 — see report for the recovered value]
BOOL OMCExpired(void);

// ---------------------------------------------------------------------------
// Per-car profile keys
// ---------------------------------------------------------------------------

/// The 14 preference keys that are stored per car profile, in this order:
/// splitScreenLastLeft, splitScreenLastRight, splitScreenSplitRatio,
/// splitScreenSplitDirection, splitScreenPaneOrientation, splitScreenAutoLaunch,
/// splitScreenPinnedApp, speedBubbleSizeCar, speedBubbleLook,
/// startupScreenVideoName, startupScreenStyle, startupScreenCarName,
/// startupScreenTempo, appBridgeZoom
/// [VERIFIED: constant array at 0x7f6a0 decoded from __objc_arraydata]
NSArray<NSString *> *OMCProfileKeys(void);

// ---------------------------------------------------------------------------
// Specifier / table styling helpers (used by the list controllers)
// ---------------------------------------------------------------------------

/// Localises title/footerText/text/value labels of an array of PSSpecifiers
/// in place. [VERIFIED: _OMCLocalizeSpecifiers]
void OMCLocalizeSpecifiers(NSArray *specifiers);
void OMCStyleTable(UITableView *table);          // [VERIFIED: _OMCStyleTable]
void OMCStyleCell(UITableViewCell *cell);        // [VERIFIED: _OMCStyleCell]
void OMCStyleGlassCard(UIView *view);            // [VERIFIED: _OMCStyleGlassCard]
void OMCStyleHeaderFooter(UIView *view);         // [VERIFIED: _OMCStyleHeaderFooter — the original's 2nd (header/footer) param is a recorded fidelity gap, deferred per GPT consolidated §D]

UIColor *OMCColorFromHex(NSString *hex);         // [VERIFIED]
UIColor *OMCAccentColor(void);                   // light 0x7B6CF6 / dark 0xA89BFF
UIColor *OMCBackgroundColor(void);               // light 0xF4F5FB / dark 0x0E0F16
UIColor *OMCCardColor(void);                     // dynamic provider colour
UIColor *OMCSwitchColor(void);                   // [UIColor systemGreenColor] (12-byte thunk @0x17fd8)

// ---------------------------------------------------------------------------
// Features / rescue / diagnostics
// ---------------------------------------------------------------------------

/// Display name for a feature plist name. [VERIFIED: _OMCFeatureDisplayName]
NSString *OMCFeatureDisplayName(NSString *feature);

/// Names of features that still need rescue (not currently restorable state).
/// Source list comes from the bundle resource "rescueFeatures".
/// [VERIFIED: _OMCRescueFeatures]
NSArray<NSString *> *OMCRescueFeatures(void);

/// Rescue restore: turns every rescued feature back off/on to defaults
/// (writes via the standard prefs path) — see implementation notes.
/// [VERIFIED: _OMCRescueRestore]
void OMCRescueRestore(void);

/// List of known conflicting tweaks detected on the device
/// (checks /var/lib/dpkg/status and tweak-injection paths).
/// [VERIFIED: _OMCConflictingTweaks]
NSArray *OMCConflictingTweaks(void);

NSArray *OMCDiagSections(void);                  // [VERIFIED: _OMCDiagSections]
NSArray *OMCDiagChecks(void);                    // [VERIFIED: _OMCDiagChecks]
NSDictionary *OMCDiagSummary(void);              // [VERIFIED: _OMCDiagSummary]
/// Builds the text report and presents a share sheet from `presenter`.
/// [VERIFIED: _OMCShareReport — presenter is the first argument]
void OMCShareReport(UIViewController *presenter);

/// [GPT-F] Candidate-only diagnostic logger — NOT a restored behaviour:
/// the original Prefs binary contains no _OMCLogWrite at all (absent from
/// its 31-function _CFunctions census and from the built binary's symbol
/// table) and no Prefs source called it; the shared core unit is not
/// linked into this bundle (see the phase-1 deviation note in the Prefs
/// Makefile). Added solely so the GPT consolidated fix §F Settings
/// diagnostics can land in /var/mobile/Documents/OmniCar.log. Semantics
/// mirror the verified shared-core OMCLogWrite (src/OMCCommon/
/// OMCCommon.c): NSLog echo, "<yyyy-MM-dd HH:mm:ss.SSS> [<process>:<pid>]
/// <tag>: <msg>" line appended on the serial queue
/// "com.anlai.omnicar.log", with the "com.anlai.omnicar/log"
/// distributed-notification relay when a non-SpringBoard process cannot
/// append directly. The dylib variants' crash-state lastFeature stamp is
/// omitted: this binary has no crash-guard state to stamp.
void OMCLogWrite(NSString *tag, NSString *msg);

// ---------------------------------------------------------------------------
// Speed Bubble voice helpers (C functions used by SPPBubbleView)
// ---------------------------------------------------------------------------
/// Voice modes 3..7 are the "fun" lines. [VERIFIED: _SPPVoiceIsFun, 16 bytes]
BOOL SPPVoiceIsFun(NSInteger mode);
/// Spoken warning template for a voice mode (0/default = serious over-limit
/// line; 1 = "limit is {L}"; 2 = "please slow down"; 3..7 = jokes), via OMCTr.
/// [VERIFIED: _SPPVoiceTemplate switch]
NSString *SPPVoiceTemplate(NSInteger mode);
/// A custom line wins; if empty, the mode template is used. {L} is then
/// substituted with the limit and the result trimmed. [VERIFIED: _SPPVoiceLine]
NSString *SPPVoiceLine(NSString *customLine, NSInteger mode, NSInteger limit);
void SPPSpeak(NSString *text);                   // [VERIFIED: _SPPSpeak]
void SPPPlayTone(NSInteger index);               // [VERIFIED: _SPPPlayTone]

// ---------------------------------------------------------------------------
// Startup Screen weather helpers (C functions used by SSStartupView)
// ---------------------------------------------------------------------------
/// Day period by hour: 5-10 -> 0, 11-16 -> 1, 17-20 -> 2, else 3.
/// nil date means now. [VERIFIED: _SSPeriodForDate]
NSInteger SSPeriodForDate(NSDate *date);
NSDictionary *SSWeatherLoadCache(void);          // [VERIFIED: _SSWeatherLoadCache]
void SSWeatherSaveCache(NSDictionary *info);     // [VERIFIED: _SSWeatherSaveCache]
NSDictionary *SSWeatherParse(NSData *data);      // [VERIFIED: _SSWeatherParse]
void SSApplySampleData(SSStartupView *view);     // [VERIFIED: _SSApplySampleData]

/// Renders an SF Symbol (14 pt, white) centred on a 29x29 rounded-rect
/// gradient tile; the gradient palette is picked from the hue of `color`.
/// [VERIFIED: _OMCIcon]
UIImage *OMCIcon(NSString *symbolName, UIColor *color);

/// libroot-compatible jbroot path resolution (vendored mini-libroot).
/// [VERIFIED: helper at 0x4118/0x4170]
char *OMCJBRootPath(const char *path, char *buffer);

/// Procedurally drawn OmniCar logo mesh image. [VERIFIED: _OMCLogoMeshImage]
UIImage *OMCLogoMeshImage(void);

/// Respring: SBSRelaunchAction/FBSSystemService via dlopen'd private
/// frameworks; fallback posix_spawn(killall -9 SpringBoard) using the first
/// executable of @[ "/var/jb/usr/bin/killall", "/usr/bin/killall" ].
/// [VERIFIED: _OMCRespring, 684 bytes]
void OMCRespring(void);

#ifdef __cplusplus
}
#endif
