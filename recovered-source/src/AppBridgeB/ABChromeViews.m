// ABChromeViews.m — the SpringBoard-side chrome views of a pane:
// ABBoxView (hit-test gate + visual hole mask), ABShieldView (touch shield),
// ABKnobView (split-divider knob touch relay), ABBarButton (bar button with
// a capped hit area). Interfaces are declared inline here; ivars are from
// objc.json verbatim.

#import "AppBridgeB.h"
#import "ABHost.h" // [integration phase 1; backported to src in phase 3] for +[ABHost shared] / -outsideTouched used below
#import <objc/runtime.h>

NS_ASSUME_NONNULL_BEGIN

// ---------------------------------------------------------------------------
// ABBoxView — ivars: _handleHit (UIView*), _bar (UIView*),
// _passInsets (UIEdgeInsets), _hole (CGRect).
// Superclass: UIView (proven by calibrated bind decode — see ABHost.h note;
// wave-1 metadata's "UIWindowScene" was the off-by-one error).
// ---------------------------------------------------------------------------
@interface ABBoxView : UIView
@property (nonatomic, strong, nullable) UIView *handleHit;
@property (nonatomic, strong, nullable) UIView *bar;
@property (nonatomic) UIEdgeInsets passInsets;
@property (nonatomic) CGRect hole;
- (void)applyHole;
@end

// ABShieldView — no ivars; only -touchesBegan:withEvent: is overridden.
@interface ABShieldView : UIView
@end

// ABKnobView — ivars: _index (int), _dot (UIView*), _lastSent (CGPoint).
@interface ABKnobView : UIView
@property (nonatomic) int index;
@property (nonatomic, strong, nullable) UIView *dot;
@property (nonatomic) CGPoint lastSent;
- (void)relay:(NSInteger)phase touches:(NSSet<UITouch *> *)touches;
@end

// ABBarButton — no ivars; overrides pointInside:withEvent: and
// setHighlighted:. Superclass: UIButton (proven by calibrated bind decode;
// wave-1 metadata's "NSNull" was the off-by-one error).
@interface ABBarButton : UIButton
@end

NS_ASSUME_NONNULL_END

@implementation ABBoxView

// -setHole: (0x9B14): stores the rect; if a mask layer already exists the
// hole is re-applied immediately (applyHole).
- (void)setHole:(CGRect)hole {
    _hole = hole;
    if (self.layer.mask) [self applyHole];
}

// -layoutSubviews (0x9E30): super, then applyHole (the mask tracks bounds).
- (void)layoutSubviews {
    [super layoutSubviews];
    [self applyHole];
}

// -applyHole (0x9C10): the box's rendering is masked by an even-odd
// CAShapeLayer: path = bounds rect + hole as a ROUNDED rect (corner radius
// 12) — with kCAFillRuleEvenOdd the hole is cut OUT of the mask, so the box
// (and the chrome it carries) is invisible inside the hole, where the
// hosted scene shows through. Empty hole -> mask removed entirely.
// The mask update runs inside a CATransaction with actions disabled.
- (void)applyHole {
    if (CGRectIsEmpty(self.hole)) {
        self.layer.mask = nil;
        return;
    }
    CAShapeLayer *mask = (CAShapeLayer *)self.layer.mask;
    if (![mask isKindOfClass:CAShapeLayer.class]) {
        mask = [CAShapeLayer layer];
        mask.frame = self.bounds;
    }
    mask.fillRule = kCAFillRuleEvenOdd;
    mask.frame = self.bounds;
    UIBezierPath *path = [UIBezierPath bezierPathWithRect:self.bounds];
    [path appendPath:[UIBezierPath bezierPathWithRoundedRect:self.hole cornerRadius:12.0]];
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    mask.path = path.CGPath;
    self.layer.mask = mask;
    [CATransaction commit];
}

// -pointInside:withEvent: (0x98A0). Verified decision order:
//   1. super says NO -> NO.
//   2. point inside the (visible) handleHit frame -> YES.
//   3. point inside the (visible) bar frame -> YES.
//   4. hole non-empty and point inside the hole -> NO (the touch falls
//      through to the hosted scene below).
//   5. otherwise YES only inside bounds shrunk by passInsets:
//      rect = {x + left, y + top, w - (left + right), h - (top + bottom)}.
- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    if (![super pointInside:point withEvent:event]) return NO;
    if (self.handleHit && !self.handleHit.isHidden &&
        CGRectContainsPoint(self.handleHit.frame, point)) return YES;
    if (self.bar && !self.bar.isHidden &&
        CGRectContainsPoint(self.bar.frame, point)) return YES;
    if (!CGRectIsEmpty(self.hole) && CGRectContainsPoint(self.hole, point)) return NO;
    CGRect inner = CGRectMake(self.bounds.origin.x + self.passInsets.left,
                              self.bounds.origin.y + self.passInsets.top,
                              self.bounds.size.width - (self.passInsets.left + self.passInsets.right),
                              self.bounds.size.height - (self.passInsets.top + self.passInsets.bottom));
    return CGRectContainsPoint(inner, point);
}

@end

@implementation ABShieldView

// -touchesBegan:withEvent: (0xA4B4): a touch on the shield means "touched
// outside the bar": log, post ABChanBarDismiss (object nil, empty userInfo)
// for the CarPlay side, and dismiss locally via -[ABHost outsideTouched].
// The touch itself is NOT forwarded — the shield swallows it.
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    OMCLogWrite(@"AppBridge", [NSString stringWithFormat:@"cham ngoai thanh nut (lop chan) -> an thanh nut"]);
    [[NSDistributedNotificationCenter defaultCenter]
        postNotificationName:ABChanBarDismiss object:nil userInfo:@{}];
    [[ABHost shared] outsideTouched];
}

@end

@implementation ABKnobView

// touchesBegan/Moved/Ended/Cancelled (0xA90C/0xA918/0xA924/0xA930) are
// 12-byte thunks: [self relay:<0/1/2/3> touches:touches].
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self relay:0 touches:touches];
}
- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self relay:1 touches:touches];
}
- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self relay:2 touches:touches];
}
- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self relay:3 touches:touches];
}

// -relay:touches: (0xA58C): point = [touch locationInView:self.window]
// (window coordinates). Phase 1 (moved) is throttled: moves shorter than
// 1.0 pt from lastSent (hypot) are dropped. Non-move phases are logged
// ("cham tron vach %d: pha %d tai %@"). Every surviving event posts
// ABChanKnobTouch, object nil, userInfo {index, phase, x, y}.
- (void)relay:(NSInteger)phase touches:(NSSet<UITouch *> *)touches {
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self.window];
    if (phase == 1) {
        if (hypot(point.x - self.lastSent.x, point.y - self.lastSent.y) < 1.0) return;
    }
    self.lastSent = point;
    if (phase != 1) {
        OMCLogWrite(@"AppBridge", [NSString stringWithFormat:@"cham tron vach %d: pha %d tai %@",
                                   self.index, (int)phase, NSStringFromCGPoint(point)]);
    }
    [[NSDistributedNotificationCenter defaultCenter]
        postNotificationName:ABChanKnobTouch object:nil userInfo:@{
            @"index": @(self.index), @"phase": @(phase),
            @"x": @(point.x), @"y": @(point.y)}];
}

@end

@implementation ABBarButton

// -pointInside:withEvent: (0x9F90): the hit area is the bounds INSET to a
// centered rect of at most 44x44 pt: dx = MAX(0, (w - 44) / 2),
// dy = MAX(0, (h - 44) / 2) — the constant is the double -44.0
// (0xC046000000000000) added before halving in the original.
- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    CGFloat dx = MAX(0.0, (self.bounds.size.width - 44.0) / 2.0);
    CGFloat dy = MAX(0.0, (self.bounds.size.height - 44.0) / 2.0);
    return CGRectContainsPoint(CGRectInset(self.bounds, dx, dy), point);
}

// -setHighlighted: @0xa02c — VERIFIED (phase-3 restoration; the body was
// missing from this file, leaving ABBarButton one method short of the
// original — read from disasm/m_ABBarButton_setHighlighted.txt plus the
// animation-block invoke @0xa104 in disasm/full_arm64.txt): forwards to
// super, and on an actual state change spring-animates the transform —
// pressed: CGAffineTransformMakeScale(0.9, 0.9) over 0.12 s; released:
// identity over 0.3 s; damping 0.7, velocity 0, options 6
// (AllowUserInteraction | BeginFromCurrentState), no completion. (The
// older "rest tint/colour" gloss was B's inference; the dump shows a
// transform-only animation.)
- (void)setHighlighted:(BOOL)highlighted {
    BOOL wasHighlighted = self.isHighlighted;
    [super setHighlighted:highlighted];
    if (highlighted == wasHighlighted) return;
    [UIView animateWithDuration:highlighted ? 0.12 : 0.3
                          delay:0
         usingSpringWithDamping:0.7
          initialSpringVelocity:0
                        options:UIViewAnimationOptionAllowUserInteraction |
                                UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
        self.transform = highlighted ? CGAffineTransformMakeScale(0.9, 0.9)
                                     : CGAffineTransformIdentity;
    } completion:nil];
}

@end
