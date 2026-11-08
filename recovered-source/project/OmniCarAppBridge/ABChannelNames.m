// ABChannelNames.m — definitions of the AppBridge channel-name
// constants declared extern in AppBridgeB.h. Written in phase 2
// (2026-11-08): phase 1's diagnostic link reported all 16 symbols
// undefined; neither half defined them. NOTE: module A's
// src/AppBridgeA/src/ABChannels.m is a DIFFERENT translation unit
// (channel handlers/bootstrap) that uses string literals throughout
// and defines none of these constants — this file follows the
// AppBridgeB.h grouping. [phase 3] Renamed ABChannels.m ->
// ABChannelNames.m in src as well (the project used this name since
// phase 2), so the two TUs are unambiguous in both trees.
//
// Values: metadata/IPC_MAP.md + AppBridgeB_REPORT.md. EVERY string
// below was verified byte-for-byte against the binary's __cstring
// table in phase 2 (strings(1) over OmniCarAppBridge.dylib): all 14
// NSDistributed names "com.anlai.omnicar/appbridge.<suffix>" and both
// Darwin names are present verbatim.
//
// Transports (see AppBridgeB.h for payload contracts):
//   ABChan*    — NSDistributedNotificationCenter names.
//   ABNotify*  — Darwin notify names (state-carrying uint64).

#import "AppBridgeB.h"

NSString *const ABChanOrientation = @"com.anlai.omnicar/appbridge.orientation";
NSString *const ABChanKey         = @"com.anlai.omnicar/appbridge.key";
NSString *const ABChanOpen        = @"com.anlai.omnicar/appbridge.open";
NSString *const ABChanFrame       = @"com.anlai.omnicar/appbridge.frame";
NSString *const ABChanShield      = @"com.anlai.omnicar/appbridge.shield";
NSString *const ABChanClose       = @"com.anlai.omnicar/appbridge.close";
NSString *const ABChanCloseAll    = @"com.anlai.omnicar/appbridge.closeall";
NSString *const ABChanKnobs       = @"com.anlai.omnicar/appbridge.knobs";
NSString *const ABChanState       = @"com.anlai.omnicar/appbridge.state";
NSString *const ABChanKnobTouch   = @"com.anlai.omnicar/appbridge.knobtouch";
NSString *const ABChanHandleDrag  = @"com.anlai.omnicar/appbridge.handledrag";
NSString *const ABChanHandleTap   = @"com.anlai.omnicar/appbridge.handletap";
NSString *const ABChanBarAction   = @"com.anlai.omnicar/appbridge.baraction";
NSString *const ABChanBarDismiss  = @"com.anlai.omnicar/appbridge.bardismiss";

const char *ABNotifyKeyboard  = "com.anlai.omnicar/appbridge.keyboard";
const char *ABNotifyAppOrient = "com.anlai.omnicar/appbridge.apporient";
