// OMCHSPreview.h — OmniCarPrefs reconstruction (Prefs-B)
// Live preview of the CarPlay home-screen grid for the App Bridge page:
// draws the wallpaper (aspect fill, white blur wash + black dim overlay),
// a fake status bar ("9:41"), and the app icon grid. Superclass: UIView
// (calibrated). All drawing is immediate-mode in drawRect:.
#import <UIKit/UIKit.h>

@interface OMCHSPreview: UIView
@property (nonatomic, copy) NSArray *items;      // bundle ids to draw
@property (nonatomic, strong) UIImage *wallpaper;
@property (nonatomic, assign) NSInteger size;    // icon size percent
@property (nonatomic, assign) NSInteger blur;    // white wash strength 0–30
@property (nonatomic, assign) NSInteger dim;     // black overlay 0–70
@property (nonatomic, assign) NSInteger cols;    // 0 = auto (5)
@property (nonatomic, assign) NSInteger rows;    // 0 = auto (2)
@property (nonatomic, assign) BOOL names;
@property (nonatomic, assign) BOOL video;        // wallpaper is a video ("▶︎ video" tag)
- (void)drawIcon:(NSString *)bundleID in:(CGRect)rect;
@end

// Shared helpers defined in this TU in the binary:
// OMCIconSized (sub_1b7cc) — cached app icon at a point size, with a
// gradient SF-Symbol fallback tile; OMCThumb (sub_22df0) — aspect
// thumbnail renderer used by the wallpaper tiles in the App Bridge page.
UIImage *OMCIconSized(NSString *bundleID, double points);
UIImage *OMCThumb(UIImage *image, double width, double height, double scale);
