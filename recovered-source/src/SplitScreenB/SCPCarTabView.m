//  SCPCarTabView.m
//  OmniCar 1.0.3 — OmniCarSplitScreen.dylib (reconstructed, module B)
//  Evidence: disasm/SCPCarTabView__pointInside_withEvent_.txt (@0xf334)

#import "SCPCarTabView.h"

@implementation SCPCarTabView

// VERIFIED (@0xf334): hit area = bounds expanded by 18 pt horizontally
// and 14 pt vertically on each side (CGRectInset with dx = -18, dy = -14).
- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event
{
    return CGRectContainsPoint(CGRectInset(self.bounds, -18.0, -14.0), point);
}

@end
