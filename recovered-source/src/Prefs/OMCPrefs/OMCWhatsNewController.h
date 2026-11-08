// OMCWhatsNewController.h — OmniCarPrefs reconstruction (Prefs-B)
// "What's New" sheet shown once per release: content comes from the
// WhatsNew.plist resource in the prefs bundle ({version: [ {symbol,
// titleKey, textKey}, … ]}); the seen version is stored in the pref
// `whatsNewSeen`. Superclass: UIViewController (calibrated).
#import <UIKit/UIKit.h>

@interface OMCWhatsNewController: UIViewController
@property (nonatomic, copy) NSString *version;
@property (nonatomic, copy) NSArray *items;
+ (BOOL)shouldShow;
+ (void)markSeen;
+ (UINavigationController *)whatsNewNavigationController;
- (void)close;
@end
