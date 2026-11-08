// OMCCarProfilesController.h — OmniCarPrefs reconstruction (Prefs-B)
// Per-car preference profiles: list of cars seen (pref `carProfiles`,
// a dictionary keyed by car id with {name, lastSeen}), a master switch
// (pref `carProfilesEnabled`) and swipe-to-delete. The current car is
// marked with a checkmark (pref `carProfileCurrent`).
// Superclass: PSViewController (calibrated). NOT a PSListController —
// it builds its own grouped UITableView in loadView.
#import <UIKit/UIKit.h>
#import <Preferences/PSViewController.h>

@interface OMCCarProfilesController: PSViewController <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) UITableView *table;
@property (nonatomic, strong) NSArray *keys;          // car ids, sorted by lastSeen
@property (nonatomic, strong) NSDictionary *profiles; // id -> {name, lastSeen}
- (void)reload;
- (void)enabledChanged:(UISwitch *)sender;
@end
