#import <Foundation/Foundation.h>
// Install only on the SHA-verified original or text-only patched LePrefs 0.2.4 bundle.
// Returns NO without changing vendor behavior if hooking is unavailable.
BOOL DCLLeInstallOriginalStoreHook(NSString *binaryPath);
