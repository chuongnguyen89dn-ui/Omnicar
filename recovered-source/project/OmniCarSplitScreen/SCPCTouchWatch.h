//  SCPCTouchWatch.h
//  OmniCar 1.0.3 — OmniCarSplitScreen.dylib (reconstructed, module B)
//
//  A transparent touch observer ("shield") view: it never takes a touch
//  itself (-hitTest:withEvent: always returns nil) but reports touches
//  that land inside it — unless the point is exempted — through the
//  `outside` callback, in window coordinates. -setHoles: punches visible
//  holes into the view through an even-odd CAShapeLayer mask.
//  Superclass UIView is the corrected value from the raw class struct
//  (wave-1 metadata superclass was a bind-name off-by-one artifact).
//  Ivars: _exempt @8 (copy block), _outside @16 (copy block).

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SCPCTouchWatch : UIView

/// Exemption test, called with the touch point in window coordinates.
/// Return YES to swallow the report (the touch counts as "inside" an
/// exempt region, e.g. over a pane or popup).
@property (nonatomic, copy, nullable) BOOL (^exempt)(CGPoint windowPoint);

/// Called with the touch point in window coordinates for every
/// non-exempt touch that lands inside the watch view.
@property (nonatomic, copy, nullable) void (^outside)(CGPoint windowPoint);

/// Rebuilds the layer mask: the view's bounds minus the given hole rects
/// (NSArray of NSValue-wrapped CGRects, in the view's own coordinates).
/// An empty array removes the mask entirely.
- (void)setHoles:(NSArray<NSValue *> *)holes;

@end

NS_ASSUME_NONNULL_END
