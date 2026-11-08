// OMCSpeedBubbleController.h — OmniCarPrefs (reconstructed, Prefs-B)
// Speed Bubble settings page. Superclass OMCCardPage [VERIFIED: calibrated
// xref — internal superclass]. 6 table sections:
//   0 live preview (fake-map snapshot + live SPPBubbleView + "try on car")
//   1 enable switch
//   2 styles strip / color swatches / app-icon switch
//   3 bubble sizes (phone/car sliders) + reset-layout row
//   4 speed-source tiles + hint
//   5 over-speed warning (dynamic rows)
#import "OMCCardPage.h"

@class SPPBubbleView;

@interface OMCSpeedBubbleController : OMCCardPage
@property (nonatomic, strong) SPPBubbleView *live;
@property (nonatomic, strong) UIImageView *liveMap;
@property (nonatomic, strong) NSTimer *liveTimer;
@property (nonatomic) double liveStart;
@property (nonatomic, strong) UIScrollView *styleStrip;
@property (nonatomic) double stripOffset;
@property (nonatomic, copy) NSArray *warnRows;
@end
