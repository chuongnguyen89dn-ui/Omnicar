//  SCPCarSplitView.h
//  OmniCar 1.0.3 — OmniCarSplitScreen.dylib (reconstructed, module B)
//
//  The root container view of the split layout. Superclass UIView is the
//  corrected value from the raw class struct (wave-1 metadata said
//  NSMutableArray — bind-name off-by-one in the scan tooling, see
//  SCPCommon.h). Single ivar: _touched @8 (copy block).

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SCPCarSplitView : UIView

/// Called from -hitTest:withEvent: for touch events (event.type == 0)
/// whenever the default hit test finds a view. Argument order as declared
/// here is ABI-identical to the reverse order; which of the two the
/// original source used cannot be distinguished from the binary
/// (INFERRED ordering — the block receives the point in v0/v1 and the hit
/// view in x1 either way).
@property (nonatomic, copy, nullable) void (^touched)(CGPoint point, UIView *hitView);

@end

NS_ASSUME_NONNULL_END
