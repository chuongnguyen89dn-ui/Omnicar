// OMCAppBridgeAppsController.h — reconstructed interface (evidence: metadata objc dump)
#import <UIKit/UIKit.h>
#import <Preferences/PSListController.h>
#import <Preferences/PSSpecifier.h>
#import <Preferences/PSTableCell.h>

@interface OMCAppBridgeAppsController : PSViewController <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>
{
    @"UITableView" _table;  // offset None
    @"OMCHSPreview" _preview;  // offset None
    @"NSArray" _phoneApps;  // offset None
    @"NSArray" _carplayApps;  // offset None
    @"NSArray" _guessApps;  // offset None
    @"NSArray" _included;  // offset None
    @"NSArray" _other;  // offset None
    @"NSMutableSet" _shown;  // offset None
    @"NSSet" _iosOff;  // offset None
    @"NSMutableSet" _chosen;  // offset None
    @"NSMutableSet" _hidden;  // offset None
    @"NSMutableSet" _open;  // offset None
    @"NSString" _query;  // offset None
    @"UIImage" _wallpaper;  // offset None
    @"UIImage" _photo;  // offset None
    @"UIImage" _videoThumb;  // offset None
    q _wallStyle;  // offset None
    @"NSCache" _icons;  // offset None
}
@property (T@"UITableView",&,N,V_table) id table;
@property (T@"OMCHSPreview",&,N,V_preview) id preview;
@property (T@"NSArray",&,N,V_phoneApps) id phoneApps;
@property (T@"NSArray",&,N,V_carplayApps) id carplayApps;
@property (T@"NSArray",&,N,V_guessApps) id guessApps;
@property (T@"NSArray",&,N,V_included) id included;
@property (T@"NSArray",&,N,V_other) id other;
@property (T@"NSMutableSet",&,N,V_shown) id shown;
@property (T@"NSSet",&,N,V_iosOff) id iosOff;
@property (T@"NSMutableSet",&,N,V_chosen) id chosen;
@property (T@"NSMutableSet",&,N,V_hidden) id hidden;
@property (T@"NSMutableSet",&,N,V_open) id open;
@property (T@"NSString",C,N,V_query) id query;
@property (T@"UIImage",&,N,V_wallpaper) id wallpaper;
@property (T@"UIImage",&,N,V_photo) id photo;
@property (T@"UIImage",&,N,V_videoThumb) id videoThumb;
@property (Tq,N,V_wallStyle) id wallStyle;
@property (T@"NSCache",&,N,V_icons) id icons;
@property (TQ,R) id hash;
@property (T#,R) id superclass;
@property (T@"NSString",R,C) id description;
@property (T@"NSString",?,R,C) id debugDescription;
@end
