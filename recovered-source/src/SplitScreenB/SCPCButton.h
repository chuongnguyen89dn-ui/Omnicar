//  SCPCButton.h
//  OmniCar 1.0.3 — OmniCarSplitScreen.dylib (reconstructed, module B)
//
//  The split UI's button: guarantees a 44x44 pt minimum hit target and
//  animates a 0.9x press scale. Superclass UIButton is the corrected
//  value from the raw class struct (wave-1 metadata said NSSortDescriptor
//  — bind-name off-by-one in the scan tooling, see SCPCommon.h).
//  No ivars of its own (instance_size 8).

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SCPCButton : UIButton
@end

NS_ASSUME_NONNULL_END
