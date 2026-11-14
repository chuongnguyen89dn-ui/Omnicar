#import <Foundation/Foundation.h>
// Install only on the SHA-verified original or text-only patched LePrefs 0.2.4 bundle.
// Returns NO without changing vendor behavior if hooking is unavailable.
BOOL DCLLeInstallOriginalStoreHook(NSString *binaryPath);
// Fetch actual SpringBoard-owned vendor JSON before opening original LePrefs.
// Must run off-main; never fabricate defaults when no canonical state arrives.
BOOL DCLLeFetchCanonicalLayout(NSData **result);
// Call on main only after the original bundle is loaded, before hook/UI init.
BOOL DCLLeHydrateAppLayout(NSString *binaryPath,NSData *canonical);
