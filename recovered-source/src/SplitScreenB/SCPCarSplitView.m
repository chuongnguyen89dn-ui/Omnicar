//  SCPCarSplitView.m
//  OmniCar 1.0.3 — OmniCarSplitScreen.dylib (reconstructed, module B)
//  Evidence: disasm/SCPCarSplitView__hitTest_withEvent_.txt (@0xe88c)

#import "SCPCarSplitView.h"
#import "SCPCarSplit.h"
#import "SCPCarSplit+AutoHide.h" // [autohide F1] activity feed

@implementation SCPCarSplitView

// VERIFIED (@0xe88c): forwards to super; when the hit view is non-nil, a
// `touched` block is installed, and the event is a touch event
// (UIEventTypeTouches == 0), the block is invoked with the hit-test point
// and the hit view. The hit view is returned unchanged.
- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    UIView *hit = [super hitTest:point withEvent:event];
    if (hit != nil && self.touched != nil && event.type == UIEventTypeTouches) {
        self.touched(point, hit);
    }
    // [autohide F1] Activity feed (design-autohide §3.2, point F1): the
    // same observation point QA20 proved on this exact IMP (@0xe88c).
    // QA20's filter verbatim — touch event, point inside bounds, view
    // windowed, and at least one Began touch belonging to this window.
    // Observation only: `hit` above is returned unchanged and no touch
    // is held, delayed or altered in any way.
    if (hit != nil && event.type == UIEventTypeTouches &&
        self.window != nil && CGRectContainsPoint(self.bounds, point)) {
        for (UITouch *touch in event.allTouches) {
            if (touch.phase == UITouchPhaseBegan &&
                touch.window == self.window) {
                [[SCPCarSplit shared] ahNoteActivity:AHSourceContainer];
                break;
            }
        }
    }
    return hit;
}

@end
