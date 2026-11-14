//  SCPRadialTargetStrip.h
//  DuoCar V3 P4/G2 — OmniCarSplitScreen.dylib
//
//  Pure view (no split-engine knowledge): the row of target cards shown
//  under the radial wheel after an action is picked (G1 contract C2/C3,
//  ACTION-FIRST: sector -> card -> dispatch). Each card names one slot
//  ("Ô 1" / "Ô 2" / "Nổi") plus the real app currently in it. The strip
//  background is transparent; cards use the shared solid sheet face so
//  pane 1 and pane 2 read identically on native and hosted.

#import <UIKit/UIKit.h>

@class SCPRadialTargetStrip;

NS_ASSUME_NONNULL_BEGIN

@interface SCPRadialTargetItem : NSObject

/// Slot index; -1 marks the floating-window card.
@property (nonatomic) NSInteger slot;
/// Card headline: "Ô 1" / "Ô 2" / "Nổi".
@property (nonatomic, copy) NSString *title;
/// localizedDisplayName of the app in the slot; nil = empty slot.
@property (nonatomic, copy, nullable) NSString *appName;
@property (nonatomic, strong, nullable) UIImage *icon;
@property (nonatomic) BOOL enabled;
/// Why the card cannot be used (pinned, no app, action unproven, ...).
@property (nonatomic, copy, nullable) NSString *disabledReason;
@property (nonatomic) BOOL isFloatCard;

@end

@protocol SCPRadialTargetStripDelegate <NSObject>
- (void)targetStrip:(SCPRadialTargetStrip *)strip didSelectItem:(SCPRadialTargetItem *)item;
@end

@interface SCPRadialTargetStrip : UIView

@property (nonatomic, weak, nullable) id<SCPRadialTargetStripDelegate> delegate;

/// Cards share `width` equally (8 pt gaps), fixed height 56 pt.
- (instancetype)initWithItems:(NSArray<SCPRadialTargetItem *> *)items width:(CGFloat)width;

@end

NS_ASSUME_NONNULL_END
