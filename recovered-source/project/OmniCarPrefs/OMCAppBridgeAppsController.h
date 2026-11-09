// OMCAppBridgeAppsController.h — reconstructed from OmniCarPrefs (OmniCar 1.0.3)
// by static analysis (capstone disassembly of the arm64 slice).
// Superclass PSViewController: calibrated xref (wave-1 objc.json said
// "__objc_empty_cache" — off-by-one ordinal artifact; slot decodes to
// _OBJC_CLASS_$_PSViewController). This controller backs BOTH the
// AppBridge apps page (layoutPage == NO) and, via the subclass
// OMCHomeScreenController, the Home Screen layout page (layoutPage == YES).

#import <UIKit/UIKit.h>
#import <Preferences/PSViewController.h>

@class OMCHSPreview;

@interface OMCAppBridgeAppsController : PSViewController <UITableViewDataSource, UITableViewDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate> // [integration phase 1; backported to src in phase 3] conformances declared: the controller sets itself as table dataSource/delegate and as image-picker delegate, and implements those protocols
// ivars (offsets from the class struct; all strong unless noted)
@property (nonatomic, strong) UITableView *table;        // _table
@property (nonatomic, strong) NSCache *icons;            // _icons
@property (nonatomic, strong) NSMutableSet *open;        // _open (NSNumber sections)
@property (nonatomic, strong) NSArray *phoneApps;        // _phoneApps (dicts: id/name/system/carplay)
@property (nonatomic, strong) NSSet *iosOff;             // _iosOff
@property (nonatomic, strong) NSArray *carplayApps;      // _carplayApps
@property (nonatomic, strong) NSArray *guessApps;        // _guessApps
@property (nonatomic, strong) NSMutableSet *chosen;      // _chosen  (pref appBridgeApps)
@property (nonatomic, strong) NSMutableSet *hidden;      // _hidden  (pref homeScreenHiddenApps)
@property (nonatomic, strong) NSMutableSet *shown;       // _shown   (pref homeScreenShownApps)
@property (nonatomic, strong) UIImage *photo;            // _photo
@property (nonatomic, strong) UIImage *videoThumb;       // _videoThumb
@property (nonatomic) NSInteger wallStyle;               // _wallStyle (assign)
@property (nonatomic, strong) UIImage *wallpaper;        // _wallpaper
@property (nonatomic, copy) NSString *query;             // _query
@property (nonatomic, strong) NSArray *included;         // _included (filtered rows, section 1)
@property (nonatomic, strong) NSArray *other;            // _other    (filtered rows, section 2)
@property (nonatomic, strong) OMCHSPreview *preview;     // _preview

- (BOOL)layoutPage;                       // NO here; YES in OMCHomeScreenController
- (BOOL)shows:(NSInteger)section;
- (void)loadState;
- (void)rebuildRows;
- (NSArray *)carplayIDs;
- (BOOL)carplayGuessed;
- (BOOL)locked:(NSString *)bundleID;
- (BOOL)hides:(NSDictionary *)app;
- (BOOL)removable:(NSDictionary *)app;
- (NSDictionary *)appAt:(NSIndexPath *)indexPath;
- (void)storeChoices;
- (void)reloadLists;
- (void)updatePreview;
- (void)resetAdvancedOnce;
- (void)resetLayout;
- (NSInteger)num:(NSString *)key def:(NSInteger)def;
- (UITableViewCell *)cellWithId:(NSString *)ident inTable:(UITableView *)table;
- (UITableViewCell *)appCell:(NSDictionary *)app inTable:(UITableView *)table;
- (UITableViewCell *)headerCellFor:(NSInteger)section inTable:(UITableView *)table;
- (BOOL)isOpen:(NSInteger)section;
- (void)reloadCard:(NSInteger)section;
- (NSString *)summaryFor:(NSInteger)section;
- (NSString *)wallName:(NSInteger)style;
- (void)updateHeaders;
- (void)setAccessory:(UIView *)view onCell:(UITableViewCell *)cell;
- (UIView *)boxInCell:(UITableViewCell *)cell;
- (UIView *)sliderFor:(NSString *)key min:(NSInteger)min max:(NSInteger)max def:(NSInteger)def unit:(NSString *)unit;
- (UIView *)stepperFor:(NSString *)key values:(NSArray *)values;
- (void)showStep:(UIStepper *)stepper;
- (UIButton *)smallButton:(NSString *)symbol tint:(UIColor *)tint action:(SEL)action bundle:(NSString *)bundleID;
- (CGFloat)layoutTilesIn:(UIView *)container width:(CGFloat)width;
- (void)useStyle:(NSInteger)style;
- (BOOL)writeJPEG:(UIImage *)image to:(NSString *)path;
- (void)useWallpaper:(UIImage *)image;
- (void)useVideo:(NSURL *)url;
- (UIImage *)iconFor:(NSString *)bundleID;
- (void)alert:(NSString *)message;
@end
