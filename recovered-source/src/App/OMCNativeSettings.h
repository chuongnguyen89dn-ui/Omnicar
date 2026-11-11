#import <UIKit/UIKit.h>

// Entirely app-owned UIKit interface. No PSRootController or PSListController.
FOUNDATION_EXPORT UIViewController *OMCNativeSettingsRootController(void);
FOUNDATION_EXPORT UIViewController *OMCNativeStartupController(void);
FOUNDATION_EXPORT id OMCNativePref(NSString *key, id fallback);
FOUNDATION_EXPORT BOOL OMCNativeSetPref(NSString *key, id value);
FOUNDATION_EXPORT NSString *OMCNativeLocalized(NSString *key);
FOUNDATION_EXPORT NSString *OMCNativeStartupDirectory(void);
