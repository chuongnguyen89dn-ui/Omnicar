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
#endif
