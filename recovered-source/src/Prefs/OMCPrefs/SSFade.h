// SSFade.h — OmniCarPrefs (reconstructed, Prefs-B)
// One view's fade envelope for SSStartupView scenes. [VERIFIED: ivar layout
// outEase@8, view@0x10, inA@0x18, inB@0x20, outA@0x28, outB@0x30,
// alpha@0x38, rise@0x40 — all plain synthesized accessors]
#import <UIKit/UIKit.h>

@interface SSFade : NSObject
@property (nonatomic) BOOL outEase;
@property (nonatomic, strong) UIView *view;
@property (nonatomic) double inA;    // fade-in start time
@property (nonatomic) double inB;    // fade-in end time
@property (nonatomic) double outA;   // fade-out start time (0 = never)
@property (nonatomic) double outB;   // fade-out end time
@property (nonatomic) double alpha;  // target alpha
@property (nonatomic) double rise;   // vertical rise offset while fading in
- (void)applyTime:(double)t;
@end
