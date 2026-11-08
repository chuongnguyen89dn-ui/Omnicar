// OMCSplitPreview.h — OmniCarPrefs reconstruction (Prefs-B)
// Miniature split-screen preview drawn with CoreGraphics: window chrome
// dots, two app panes with real app icons, optional pin badge, or an
// "off" caption. Superclass: UIView (calibrated).
#import <UIKit/UIKit.h>

@interface OMCSplitPreview: UIView
@property (nonatomic, copy) NSString *left;    // bundle id of the left pane app
@property (nonatomic, copy) NSString *pinned;  // bundle id of the pinned app (pin badge)
@property (nonatomic, assign) BOOL on;
@property (nonatomic, copy) NSString *offText; // caption drawn when off
@end
