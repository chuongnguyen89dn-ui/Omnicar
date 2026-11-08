//  SCPCarDividerView.h
//  OmniCar 1.0.3 — OmniCarSplitScreen.dylib (reconstructed, module B)
//
//  One divider bar between two panes: hit target, drag handle host and
//  owner of the round knob view. Superclass UIView is the corrected
//  value from the raw class struct (wave-1 metadata said NSMutableArray
//  — bind-name off-by-one in the scan tooling, see SCPCommon.h).
//  Ivars: _index @8 (int), _knob @16 (strong UIView).

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SCPCarDividerView : UIView

/// Which gap this divider sits in: divider i separates slot i and i+1.
@property (nonatomic, assign) int index;

/// The round knob view centred on the divider (drag + double-tap target,
/// gets the accent highlight while touched).
@property (nonatomic, strong, nullable) UIView *knob;

@end

NS_ASSUME_NONNULL_END
