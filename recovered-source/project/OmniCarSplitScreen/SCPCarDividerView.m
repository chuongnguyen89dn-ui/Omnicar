//  SCPCarDividerView.m
//  OmniCar 1.0.3 — OmniCarSplitScreen.dylib (reconstructed, module B)
//  Evidence: disasm/SCPCarDividerView__pointInside_withEvent_.txt   (@0xf174)
//            disasm/SCPCarDividerView__touchesBegan_withEvent_.txt (@0xe9f4)
//            disasm/SCPCarDividerView__touchesEnded_withEvent_.txt (@0xefa4)
//            disasm/SCPCarDividerView__touchesCancelled_withEvent_.txt (@0xf08c)
//            disasm/SCP_LayerNamed_helper.txt            (@0x47944)
//            disasm/SCPCarDividerView__knobHighlight_*   (@0xeb20/@0x47b0c/@0x47dbc)

#import "SCPCarDividerView.h"
#import "SCPCommon.h"
#import "SCPCarSplit.h"
#import <QuartzCore/QuartzCore.h>

// ---------------------------------------------------------------------------
// File-local helpers in the binary (no surviving symbol names; reconstructed
// names). Both are plain C functions in the original.
// ---------------------------------------------------------------------------

// VERIFIED (@0x47944): first sublayer of the view's layer whose name
// matches, else nil.
CALayer *SCPLayerNamed(UIView *view, NSString *name)
{
    for (CALayer *layer in view.layer.sublayers) {
        if ([layer.name isEqualToString:name]) {
            return layer;
        }
    }
    return nil;
}

// VERIFIED (@0xeb20, animation block @0x47b0c, completion block @0x47dbc):
// finger-down/up highlight for the knob.
//  - On activate, if the gradient "accent" layer is missing it is created:
//    colours RGB(155,135,248) -> RGB(93,180,246), startPoint (0,0),
//    endPoint (1,1), frame = knob bounds, cornerRadius = width/2,
//    opacity 0, inserted below the "omcDot" layer (or added on top).
//  - A spring animation (duration 0.15 s on / 0.3 s off, damping 0.7,
//    velocity 0, options 6 = BeginFromCurrentState|AllowUserInteraction)
//    scales the knob to 1.6x, fades the accent in, turns the dot white,
//    and restyles border/shadow; reversing restores identity scale, dot
//    colour RGB(74,79,128), border white @0.95 alpha, shadow
//    RGB(110,100,200) opacity 0 radius 3 (active shadow: RGB(110,120,255),
//    opacity 0.5, radius 7).
//  - Completion removes the accent layer if this was a deactivation and
//    it ended fully transparent.
//  - Finally the split controller is asked to republish knob state
//    ([[SCPCarSplit shared] publishKnobsSoon] — module A/B shared call).
void SCPSetKnobActive(UIView *knob, BOOL active)
{
    CAGradientLayer *accent = (CAGradientLayer *)SCPLayerNamed(knob, @"omcAccent");
    CALayer *dot = SCPLayerNamed(knob, @"omcDot");
    if (active && accent == nil) {
        accent = [CAGradientLayer layer];
        accent.name = @"omcAccent";
        accent.colors = @[
            (id)[UIColor colorWithRed:155.0 / 255.0 green:135.0 / 255.0 blue:248.0 / 255.0 alpha:1.0].CGColor,
            (id)[UIColor colorWithRed:93.0 / 255.0 green:180.0 / 255.0 blue:246.0 / 255.0 alpha:1.0].CGColor,
        ];
        accent.startPoint = CGPointMake(0.0, 0.0); // CGPointZero global in the binary
        accent.endPoint = CGPointMake(1.0, 1.0);
        accent.frame = knob.bounds;
        accent.cornerRadius = knob.bounds.size.width * 0.5;
        accent.opacity = 0.0;
        if (dot != nil) {
            [knob.layer insertSublayer:accent below:dot];
        } else {
            [knob.layer addSublayer:accent];
        }
    }
    [UIView animateWithDuration:(active ? 0.15 : 0.3)
                          delay:0.0
         usingSpringWithDamping:0.7
          initialSpringVelocity:0.0
                        options:6
                     animations:^{
        knob.transform = active ? CGAffineTransformMakeScale(1.6, 1.6)
                                : CGAffineTransformIdentity;
        accent.opacity = active ? 1.0 : 0.0;
        dot.backgroundColor = (active ? [UIColor whiteColor]
                               : [UIColor colorWithRed:74.0 / 255.0 green:79.0 / 255.0 blue:128.0 / 255.0 alpha:1.0]).CGColor;
        knob.layer.borderColor = [UIColor colorWithWhite:1.0 alpha:(active ? 1.0 : 0.95)].CGColor;
        knob.layer.shadowColor = (active ? [UIColor colorWithRed:110.0 / 255.0 green:120.0 / 255.0 blue:1.0 alpha:1.0]
                                  : [UIColor colorWithRed:110.0 / 255.0 green:100.0 / 255.0 blue:200.0 / 255.0 alpha:1.0]).CGColor;
        knob.layer.shadowOpacity = active ? 0.5 : 0.0;
        knob.layer.shadowRadius = active ? 7.0 : 3.0;
    } completion:^(BOOL finished) {
        if (!active && accent.opacity == 0.0) {
            [accent removeFromSuperlayer];
        }
    }];
    [[SCPCarSplit shared] publishKnobsSoon];
}

/// Knob "face" factory (@0x35c74): the blur/glass disc inside a divider
/// knob. In OMC lite mode it degrades to a plain effect view with a
/// translucent white background; otherwise a UIBlurEffect view
/// (style 11 — INFERRED name UIBlurEffectStyleSystemUltraThinMaterialLight).
UIVisualEffectView *SCPKnobFaceView(void) // [phase2; backported to src in phase 3] return type unified with SCPCommon.h (was UIView*)
{
    if (OMCLiteActive()) {
        UIVisualEffectView *view = [[UIVisualEffectView alloc] initWithEffect:nil];
        view.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.92];
        return view;
    }
    return [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:11]];
}

@implementation SCPCarDividerView

// VERIFIED (@0xf174): the knob (when visible) is hittable over its frame
// expanded by 26 pt on every side; otherwise the divider body is hittable
// over its bounds expanded by 6 pt on every side.
- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event
{
    UIView *knob = self.knob;
    if (knob != nil && !knob.isHidden) {
        if (CGRectContainsPoint(CGRectInset(knob.frame, -26.0, -26.0), point)) {
            return YES;
        }
    }
    return CGRectContainsPoint(CGRectInset(self.bounds, -6.0, -6.0), point);
}

// VERIFIED (@0xe9f4): pressing on the divider lights the knob up.
// (No `isHidden` re-check is needed for the helper call itself beyond
// the guard shown: the binary checks knob != nil && !knob.hidden.)
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    if (self.knob != nil && !self.knob.isHidden) {
        SCPSetKnobActive(self.knob, YES);
    }
}

// VERIFIED (@0xefa4): releasing turns the knob highlight off.
- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [super touchesEnded:touches withEvent:event];
    if (self.knob != nil) {
        SCPSetKnobActive(self.knob, NO);
    }
}

// VERIFIED (@0xf08c): identical to touchesEnded:.
- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [super touchesCancelled:touches withEvent:event];
    if (self.knob != nil) {
        SCPSetKnobActive(self.knob, NO);
    }
}

@end
