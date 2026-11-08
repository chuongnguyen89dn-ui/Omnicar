//  SCPCTouchWatch.m
//  OmniCar 1.0.3 — OmniCarSplitScreen.dylib (reconstructed, module B)
//  Evidence: disasm/SCPCTouchWatch__hitTest_withEvent_.txt (@0xf36c)
//            disasm/SCPCTouchWatch__setHoles_.txt          (@0xf4d4)

#import "SCPCTouchWatch.h"
#import <QuartzCore/QuartzCore.h>

@implementation SCPCTouchWatch

// VERIFIED (@0xf36c): pure observer — always returns nil. For touch
// events only (event == nil passes through, non-touch types bail out),
// when the point is inside and an `outside` callback is installed, the
// point is converted to window coordinates; if an `exempt` callback is
// installed and returns YES the report is swallowed, otherwise
// `outside` is invoked with the window point.
- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    if (event != nil && event.type != UIEventTypeTouches) {
        return nil;
    }
    if (![self pointInside:point withEvent:event]) {
        return nil;
    }
    if (self.outside == nil) {
        return nil;
    }
    CGPoint windowPoint = [self convertPoint:point toView:nil];
    if (self.exempt != nil && self.exempt(windowPoint)) {
        return nil;
    }
    self.outside(windowPoint);
    return nil;
}

// VERIFIED (@0xf4d4): builds an even-odd shape mask of bounds-minus-holes,
// reusing an existing CAShapeLayer mask when present. The path update is
// wrapped in a CATransaction with actions disabled; assigning the mask
// (and clearing it for an empty hole list) is not.
- (void)setHoles:(NSArray<NSValue *> *)holes
{
    if (holes.count == 0) {
        self.layer.mask = nil;
        return;
    }
    UIBezierPath *path = [UIBezierPath bezierPathWithRect:self.bounds];
    for (NSValue *value in holes) {
        [path appendPath:[UIBezierPath bezierPathWithRect:value.CGRectValue]];
    }
    CAShapeLayer *mask = nil;
    if ([self.layer.mask isKindOfClass:[CAShapeLayer class]]) {
        mask = (CAShapeLayer *)self.layer.mask;
    } else {
        mask = [CAShapeLayer layer];
    }
    mask.fillRule = kCAFillRuleEvenOdd;
    mask.frame = self.bounds;
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    mask.path = path.CGPath;
    self.layer.mask = mask;
    [CATransaction commit];
}

@end
