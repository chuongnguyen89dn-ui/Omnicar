//  SCPNoopLayoutAssertion.h
//  OmniCar 1.0.3 — OmniCarSplitScreen.dylib (reconstructed, module B)
//
//  A no-op stand-in for a SpringBoard layout assertion: it accepts the
//  assertion lifecycle message and does nothing. Superclass NSObject is
//  the corrected value from the raw class struct (wave-1 metadata said
//  UIViewController — bind-name off-by-one in the scan tooling).

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SCPNoopLayoutAssertion : NSObject

/// No-op override point: the body is a single `ret` in the binary (@0x58b0).
- (void)invalidate;

@end

NS_ASSUME_NONNULL_END
