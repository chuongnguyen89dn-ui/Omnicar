// SBIntegrationTables.m — [integration phase 2; backported to src in phase 3] definitions TU.
//
// SPPBubble.m declares three per-app tables extern
// (SPPAppNames / SPPAppBundleIds / SPPAppShortNames) but no source TU in
// src/SpeedBubble/ defines them; in the original binary they are constant
// arrays in __objc_arrayobj, not named globals (no SPPApp* symbol exists
// in metadata/raw/OmniCarSpeedBubble/objc.json). This TU supplies the
// definitions so the project links. Contents are exactly the values
// documented at the declaration site (SPPBubble.m lines 75-78) and in the
// VERIFIED host table in SBSourceGlobals.h (bundle IDs + names); the
// short-name set has only 3 entries, matching the guarded accesses
// (idx <= 2) in SPPBubble.m. No reconstructed logic.
#import <Foundation/Foundation.h>

NSString *const SPPAppNames[] = {
    @"Vietmap", @"GOFA", @"Waze", @"Wyn",
};
NSString *const SPPAppBundleIds[] = {
    @"vn.vietmap.live", @"com.lumi.GOFA", @"com.waze.iphone", @"com.wynauto.wyn",
};
NSString *const SPPAppShortNames[] = {
    @"VM", @"GO", @"WZ",
};
