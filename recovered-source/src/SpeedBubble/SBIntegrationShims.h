// SBIntegrationShims.h — [integration phase 1] selector declarations for
// private-API message sends the reconstruction performs on `id` objects
// obtained through performSelector:. Force-included into every TU of
// this subproject via -include in the Makefile. No reconstructed logic.
#import <Foundation/Foundation.h>

// [integration phase 2] OMC core symbol-name aliases. The SpeedBubble
// A-side sources spell the shared OMCCommon helpers with the Mach-O
// symbol's leading underscore as part of the C identifier (e.g.
// `_OMCLogWrite(...)`), which names a DIFFERENT C symbol
// (`__OMCLogWrite`) from the one OMCCommon.c defines (`OMCLogWrite`,
// Mach-O symbol `_OMCLogWrite`). Other subprojects' sources use the
// plain C names. These macros map the module's spellings onto the
// real C names; declarations, signatures and call sites are otherwise
// untouched. Every name below is defined in ../OMCCommon/OMCCommon.h.
#define _OMCLogWrite        OMCLogWrite
#define _OMCMissingSelector OMCMissingSelector
#define _OMCLiteActive      OMCLiteActive
#define _OMCLogoMeshImage   OMCLogoMeshImage
#define _OMCCrashGuard      OMCCrashGuard
#define _OMCCarClass        OMCCarClass
#define _OMCCarLaunchInfo   OMCCarLaunchInfo
#define _OMCFeatureEnabled  OMCFeatureEnabled
#define _OMCPrefsSync       OMCPrefsSync
#define _OMCPref            OMCPref
#define _OMCTr              OMCTr
#define _OMCCurrentLanguage OMCCurrentLanguage

@interface NSObject (SBIntegrationPrivateSelectors)
// DashBoard application library (DBApplicationLibrary), fetched via
// -[UIApplication performSelector:@selector(sharedApplicationLibrary)].
// Sent in SBOpenCar.m on the resulting `id`.
- (id)applicationInfoForBundleIdentifier:(NSString *)bundleID;
@end
