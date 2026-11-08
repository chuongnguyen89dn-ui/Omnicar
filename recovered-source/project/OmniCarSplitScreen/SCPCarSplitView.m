//  SCPCarSplitView.m
//  OmniCar 1.0.3 — OmniCarSplitScreen.dylib (reconstructed, module B)
//  Evidence: disasm/SCPCarSplitView__hitTest_withEvent_.txt (@0xe88c)

#import "SCPCarSplitView.h"

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
    return hit;
}

@end
