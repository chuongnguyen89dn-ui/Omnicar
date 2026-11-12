#ifndef AB_KEYBOARD_TRAITS104_H
#define AB_KEYBOARD_TRAITS104_H
#import <UIKit/UIKit.h>
// DuoCar HL32 first-party reconstruction from DuoNavi 1.0.4 ARM64 evidence.
// All hooks are optional, per-signature guarded, and active ONLY while the
// CarPlay host has an authenticated native-keyboard assignment.
void ABKB104SetHostGeometry(BOOL hosted, CGFloat logicalWidth,
                            CGFloat physicalWidth, NSInteger orientation,
                            unsigned long long revision,
                            CGFloat logicalHeight, CGFloat physicalHeight);
void ABKB104NoteWindowWidth(CGFloat width);
void ABKB104InstallIfAvailable(void);
void ABKB104RestoreClips(NSString *reason);
void ABKB104InspectClips(UIView *keyboardWindow);
// One native UIWindow geometry owner; no app-level frame writer/retry.
BOOL ABKB104PlaceKeyboardWindow(UIWindow *keyboard, UIWindow *sceneWindow,
                               CGRect keyplaneInWindow, NSString *reason);
// A per-revision, hosted-only UIKit LayoutStar/traits refresh.
// This never rewrites keycaps or changes native CarPlay template scenes.
BOOL ABKB104RequestUIKitKeyplaneUpdate(UIWindow *keyboard, UIView *layout,
                                       NSString *reason);
void ABKB104RestoreKeyboardWindow(NSString *reason);
#endif
