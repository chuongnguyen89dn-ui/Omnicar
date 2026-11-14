//  SCPRadialControlView.h
//  DuoCar V3 P4/G2 — OmniCarSplitScreen.dylib
//
//  Pure view (no split-engine knowledge): a five-sector radial wheel
//  around a tappable centre logo. Actions clockwise from top:
//  Replace, Full, Pop, Background, Close — each sector spans 72 deg
//  with a 2 deg visual gap (70 deg drawn). The presenter assigns the
//  centre logo image and receives delegate callbacks; dispatching to
//  panes/handlers is NOT this view's job (G1 contract C2/E).

#import <UIKit/UIKit.h>

@class SCPRadialControlView;

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, SCPRadialAction) {
    SCPRadialActionReplace = 0,
    SCPRadialActionFull = 1,
    SCPRadialActionPop = 2,
    SCPRadialActionBackground = 3,
    SCPRadialActionClose = 4
};

@protocol SCPRadialControlViewDelegate <NSObject>
- (void)radialView:(SCPRadialControlView *)view didSelectAction:(SCPRadialAction)action;
- (void)radialViewDidTapCenter:(SCPRadialControlView *)view;
@end

@interface SCPRadialControlView : UIView

@property (nonatomic, weak, nullable) id<SCPRadialControlViewDelegate> delegate;

/// Centre logo (ScaleAspectFit). The presenter assigns the official
/// DuoCar D asset; this view never draws a logo itself.
@property (nonatomic, strong, readonly) UIImageView *centerLogoView;

- (instancetype)initWithDiameter:(CGFloat)diameter;

/// Enable/disable one sector. A disabled sector renders dimmed, shows
/// `reason` under its label when provided, and never fires the delegate.
- (void)setAction:(SCPRadialAction)action enabled:(BOOL)enabled reason:(nullable NSString *)reason;

/// Highlight one sector as selected (accent fill); nil clears.
- (void)setSelectedAction:(nullable NSNumber *)action;

@end

NS_ASSUME_NONNULL_END
