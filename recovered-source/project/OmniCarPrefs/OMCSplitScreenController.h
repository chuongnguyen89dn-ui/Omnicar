// OMCSplitScreenController.h — OmniCarPrefs reconstruction (Prefs-B)
// Split-screen settings page (an OMCCardPage): preview, master switch,
// auto-launch, pinned app, three favorite layouts ("splitScreenFav<N>*"
// prefs), panel visibility toggles, and a help section with gesture /
// Siri shortcut copy rows. Superclass: OMCCardPage (VERIFIED internal).
#import "OMCCardPage.h"
#import "OMCSplitPreview.h"

@interface OMCSplitScreenController: OMCCardPage <UITextFieldDelegate>
@property (nonatomic, strong) OMCSplitPreview *preview;
@property (nonatomic, assign) NSInteger editing;       // fav being edited (1–3), 0 = none
@property (nonatomic, assign) BOOL showGestures;
@property (nonatomic, assign) BOOL showSiri;
- (BOOL)on;
- (NSString *)stringForKey:(NSString *)key;
- (NSInteger)layoutOf:(NSInteger)fav;
- (NSInteger)boxCount:(NSInteger)layout;
- (NSArray *)appsOf:(NSInteger)fav;
- (NSString *)nameOf:(NSInteger)fav;
- (NSArray *)urls;
@end
