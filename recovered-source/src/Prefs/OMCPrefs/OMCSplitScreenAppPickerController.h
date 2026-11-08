// OMCSplitScreenAppPickerController.h — OmniCarPrefs reconstruction (Prefs-B)
// Single-choice app picker used by the split-screen settings (specifier
// property "key" names the pref that receives the chosen bundle id, or
// nil for "None"). Sections: 0 = None, 1 = CarPlay apps (seed list +
// CarPlay-entitled apps), 2 = phone apps chosen in the App Bridge page
// (pref `appBridgeApps`). Superclass: PSViewController (calibrated).
#import <UIKit/UIKit.h>
#import <Preferences/PSViewController.h>

@interface OMCSplitScreenAppPickerController: PSViewController <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) UITableView *table;
@property (nonatomic, strong) NSArray *carPlayApps;  // [{id, name}]
@property (nonatomic, strong) NSArray *phoneApps;    // [{id, name}]
@property (nonatomic, assign) BOOL fromCar;          // splitScreenCarPlayApps pref non-empty
- (NSString *)currentValue;
- (NSArray *)rowsInSection:(NSInteger)section;
@end
