//  SCPCButton.m
//  OmniCar 1.0.3 — OmniCarSplitScreen.dylib (reconstructed, module B)
//  Evidence: disasm/SCPCButton__pointInside_withEvent_.txt (@0xe69c)
//            disasm/SCPCButton__setHighlighted_.txt        (@0xe738)
//            disasm/SCPCButton__setHighlighted__blockInvoke.txt (@0xe810)

#import "SCPCButton.h"

@implementation SCPCButton

// VERIFIED (@0xe69c): the hit rect is the bounds expanded symmetrically so
// that each dimension measures at least 44 pt (the constant -44.0 and the
// 0.5 factor are literal in the code; the inset is clamped at 0 so larger
// bounds are left unchanged):
//   dx = MIN(0, (bounds.width  - 44) * 0.5)
//   dy = MIN(0, (bounds.height - 44) * 0.5)
- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event
{
    CGRect bounds = self.bounds;
    CGFloat dx = MIN(0.0, (bounds.size.width - 44.0) * 0.5);
    CGFloat dy = MIN(0.0, (bounds.size.height - 44.0) * 0.5);
    return CGRectContainsPoint(CGRectInset(bounds, dx, dy), point);
}

// VERIFIED (@0xe738 + block @0xe810): on an actual highlight change, the
// button springs to 90% scale when highlighted and back to identity when
// not. Duration 0.12 s highlighting / 0.3 s unhighlighting, spring
// damping 0.7, initial velocity 0, options 6
// (BeginFromCurrentState | AllowUserInteraction).
- (void)setHighlighted:(BOOL)highlighted
{
    BOOL wasHighlighted = self.isHighlighted;
    [super setHighlighted:highlighted];
    if (highlighted == wasHighlighted) {
        return;
    }
    [UIView animateWithDuration:(highlighted ? 0.12 : 0.3)
                          delay:0.0
         usingSpringWithDamping:0.7
          initialSpringVelocity:0.0
                        options:6
                     animations:^{
        self.transform = highlighted ? CGAffineTransformMakeScale(0.9, 0.9)
                                     : CGAffineTransformIdentity;
    } completion:nil];
}

@end
