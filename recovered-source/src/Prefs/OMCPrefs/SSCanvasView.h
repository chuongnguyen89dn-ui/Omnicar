// SSCanvasView.h — OmniCarPrefs (reconstructed, Prefs-B)
// Transparent canvas whose drawRect: forwards to its weak owner's
// ss_drawCanvas:size:. [VERIFIED: owner via objc_storeWeak]
#import <UIKit/UIKit.h>

@class SSStartupView;

@interface SSCanvasView : UIView
@property (nonatomic, weak) SSStartupView *owner;
@end
