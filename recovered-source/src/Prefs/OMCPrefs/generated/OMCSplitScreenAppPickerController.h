// OMCSplitScreenAppPickerController.h — reconstructed interface (evidence: metadata objc dump)
#import <UIKit/UIKit.h>
#import <Preferences/PSListController.h>
#import <Preferences/PSSpecifier.h>
#import <Preferences/PSTableCell.h>

@interface OMCSplitScreenAppPickerController : PSViewController <UITableViewDataSource, UITableViewDelegate>
{
    B _fromCar;  // offset None
    @"UITableView" _table;  // offset None
    @"NSArray" _carPlayApps;  // offset None
    @"NSArray" _phoneApps;  // offset None
}
@property (T@"UITableView",&,N,V_table) id table;
@property (T@"NSArray",&,N,V_carPlayApps) id carPlayApps;
@property (T@"NSArray",&,N,V_phoneApps) id phoneApps;
@property (TB,N,V_fromCar) id fromCar;
@property (TQ,R) id hash;
@property (T#,R) id superclass;
@property (T@"NSString",R,C) id description;
@property (T@"NSString",?,R,C) id debugDescription;
@end
