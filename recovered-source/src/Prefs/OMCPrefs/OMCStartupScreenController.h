// OMCStartupScreenController.h — reconstructed from OmniCarPrefs (OmniCar 1.0.3)
// by static analysis (capstone disassembly of the arm64 slice).
// Superclass OMCFeatureListController (calibrated; internal class) — a
// PSListController with a custom header: an SSStartupView live preview plus
// a horizontal gallery of the 11 startup styles. The specifiers themselves
// come from the bundle plist (StartupScreen.plist) via PSListController and
// are dynamically renamed/re-footed/filtered in -specifiers.
//
// Style indices: 0 Video, 1 Logo, 2 Greeting, 3 Weather, 4 Engine,
// 5 Welcome, 6 Particles, 7 HUD, 8 Briefing, 9 Liquid, 10 Random.

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "OMCFeatureListController.h"

@class SSStartupView;

@interface OMCStartupScreenController : OMCFeatureListController <UICollectionViewDataSource, UICollectionViewDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UIDocumentPickerDelegate> // [integration phase 1; backported to src in phase 3] conformance list completed (the .m assigns self as collection dataSource/delegate, image-picker and document-picker delegate)
@property (nonatomic) BOOL extracting;                 // _extracting
@property (nonatomic) NSInteger pickKind;              // _pickKind (0 video, 1 logo, 2 sound)
@property (nonatomic, strong) UIView *previewHeader;   // _previewHeader
@property (nonatomic, strong) UIView *previewShadow;   // _previewShadow
@property (nonatomic, strong) SSStartupView *preview;  // _preview
@property (nonatomic) double previewWidth;             // _previewWidth
@property (nonatomic, strong) UILabel *galleryTitle;   // _galleryTitle
@property (nonatomic, strong) UILabel *galleryHint;    // _galleryHint
@property (nonatomic, strong) UICollectionView *gallery; // _gallery
@property (nonatomic, strong) UIStackView *birthdayView;   // _birthdayView
@property (nonatomic, strong) UIDatePicker *birthdayPicker; // _birthdayPicker
@property (nonatomic, strong) UIButton *birthdayClear;     // _birthdayClear
@property (nonatomic, strong) AVAudioPlayer *soundPlayer;  // _soundPlayer

- (NSInteger)currentStyle;                 // pref startupScreenStyle, 0..10
- (NSString *)currentSound;               // full path of pref startupScreenSoundFile or nil
- (NSArray *)randomSet;                    // pref startupScreenRandomSet (NSNumber styles)
- (NSString *)occasionPreviewTitle;
- (NSString *)nameFooterForStyle:(NSInteger)style;
- (void)decorateCell:(UITableViewCell *)cell;
- (void)redecorateVisibleCells;
- (void)scrollGalleryToStyle:(NSInteger)style animated:(BOOL)animated;
- (BOOL)pageIsDark;
- (NSInteger)randomPreviewStyle;
- (void)updatePreview;
- (void)showPreviewStyle:(NSInteger)style occasion:(NSInteger)occasion;
- (void)toggleRandomStyle:(PSSpecifier *)specifier;
- (UIView *)birthdayAccessory;
- (void)updateBirthdayAccessory;
- (void)birthdayChanged:(UIDatePicker *)picker;
- (void)clearBirthday;
- (void)birthdayDidChange;
- (void)previewOccasion;
- (NSArray *)videoFiles;
- (void)refreshVideoList;
- (NSString *)selectedVideo;
- (void)setSelectedVideo:(NSString *)name;
- (BOOL)hasFramesForVideo:(NSString *)name;
- (BOOL)extractAudioFromAsset:(AVAsset *)asset seconds:(double)seconds toDir:(NSString *)dir;
- (void)extractFramesForVideos:(NSArray *)names completion:(void (^)(void))completion;
- (BOOL)extractFramesForVideo:(NSString *)name error:(NSError **)error
                     progress:(void (^)(double))progress;
- (void)importFromPhotos;
- (void)importFromFiles;
- (void)copyVideoAtURL:(NSURL *)url name:(NSString *)name;
- (void)addVideo;
- (void)previewVideo;
- (void)deleteVideo;
- (void)chooseLogo;
- (void)logoFromPhotos;
- (void)logoFromFiles;
- (void)saveLogoImage:(UIImage *)image;
- (void)deleteLogo;
- (void)chooseSound;
- (void)copySoundAtURL:(NSURL *)url;
- (void)previewSound;
- (void)deleteSound;
@end
