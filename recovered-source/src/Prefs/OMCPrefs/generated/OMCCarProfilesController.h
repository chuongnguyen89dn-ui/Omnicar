// OMCCarProfilesController.h — reconstructed interface (evidence: metadata objc dump)
#import <UIKit/UIKit.h>
#import <Preferences/PSListController.h>
#import <Preferences/PSSpecifier.h>
#import <Preferences/PSTableCell.h>

@interface OMCCarProfilesController : PSViewController <UITableViewDataSource, UITableViewDelegate>
{
    @"UITableView" _table;  // offset None
    @"NSArray" _keys;  // offset None
    @"NSDictionary" _profiles;  // offset None
}
@property (T@"UITableView",&,N,V_table) id table;
@property (T@"NSArray",&,N,V_keys) id keys;
@property (T@"NSDictionary",&,N,V_profiles) id profiles;
@property (TQ,R) id hash;
@property (T#,R) id superclass;
@property (T@"NSString",R,C) id description;
@property (T@"NSString",?,R,C) id debugDescription;
@end
