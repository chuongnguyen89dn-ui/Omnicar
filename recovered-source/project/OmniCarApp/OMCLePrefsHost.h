#import <UIKit/UIKit.h>

// Instantiate the real Lề 0.2.4 PreferenceBundle UI inside DuoCar's
// UIKit settings navigation hierarchy. No private code is redistributed
// by this bridge; the vendor bundle must be present in the install payload.
FOUNDATION_EXPORT UIViewController *OMCLeOriginalPreferencesController(void);
FOUNDATION_EXPORT UIViewController *OMCLeCompatiblePreferencesController(void);
FOUNDATION_EXPORT BOOL OMCLeOriginalPreferencesAvailable(void);
