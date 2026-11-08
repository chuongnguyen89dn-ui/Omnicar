// PrefsIntegrationShims.h — [integration phase 1] minimal declarations
// for private-framework classes the reconstruction resolves dynamically
// with NSClassFromString (so no header exists to import). Signatures are
// taken from the call sites in OMCCommon.m (OMCRespring / diag checks).
// Force-included into every TU of this subproject via -include in the
// Makefile. Contains no reconstructed logic.
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h> // [integration phase 1] for the UIImage category below (this header is force-included before each TU's own imports)
#import <Preferences/PSSpecifier.h> // [integration phase 1] real interface, plus the vendor-gap category below

// [integration phase 1] the Theos-vendored PSSpecifier.h omits this real
// Preferences-framework method, which OMCStartupScreenController.m calls.
@interface PSSpecifier (OMCVendorGap)
- (void)setValues:(NSArray *)values titles:(NSArray *)titles;
@end

@interface SBSRelaunchAction : NSObject
+ (id)actionWithReason:(NSString *)reason options:(NSUInteger)options
           targetURL:(NSURL *)targetURL;
@end

@interface FBSSystemService : NSObject
+ (id)sharedService;
- (void)sendActions:(NSSet *)actions withResult:(id)result;
@end

@interface LSApplicationWorkspace : NSObject
+ (id)defaultWorkspace;
- (BOOL)applicationIsInstalled:(NSString *)bundleID;
@end

// Sent to a Class object obtained via NSClassFromString in OMCCells.m.
@interface LSApplicationProxy : NSObject
+ (id)applicationProxyForIdentifier:(NSString *)identifier;
@end

// [integration phase 1] private UIImage class method used by
// OMCSpeedBubbleController.m (guarded there by respondsToSelector:).
// Needs UIKit in scope; this shim is included after each TU's own
// imports in practice via the sources' headers — declared on a category.
@interface UIImage (OMCPrivateIconAPI)
+ (UIImage *)_applicationIconImageForBundleIdentifier:(NSString *)bundleIdentifier format:(int)format scale:(CGFloat)scale;
@end
