// SSFade.m — OmniCarPrefs (reconstructed, Prefs-B)
// [VERIFIED from disassembly 0x45d6c: progress p = clamp01((t-inA)/(inB-inA));
//  eased with 1-pow(1-p,3) when outEase is set; alpha *= eased-in factor;
//  when the out window is set, alpha *= 1 - clamp01((t-outA)/(outB-outA));
//  rise applies transform translation y = rise * pow(1-p, 3).]
#import "SSFade.h"

@implementation SSFade

static double SSClamp01(double v) { return v < 0 ? 0 : (v > 1 ? 1 : v); }

- (void)applyTime:(double)t {
    double p = SSClamp01((t - self.inA) / (self.inB - self.inA));
    double a = self.alpha;
    if (self.outEase) {
        double e = (p < 0) ? 0 : 1 - pow(1 - p, 3);
        a *= e;
    } else {
        a *= p;
    }
    if (self.outB > self.outA && self.outA > 0) {
        double q = SSClamp01((t - self.outA) / (self.outB - self.outA));
        a *= (1 - q);
    }
    self.view.alpha = (CGFloat)a;
    if (self.rise != 0) {
        double ty = self.rise * pow(1 - p, 3);
        self.view.transform = CGAffineTransformMakeTranslation(0, (CGFloat)ty);
    }
}

@end
