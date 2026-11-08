// SSLinkTarget.m — OmniCarPrefs (reconstructed, Prefs-B)
// [VERIFIED 0x46134: owner alive → [owner ss_step]; owner gone → invalidate
// the sender link]
#import "SSLinkTarget.h"
#import "SSStartupView.h"
#import <QuartzCore/QuartzCore.h>

@implementation SSLinkTarget

- (void)step:(CADisplayLink *)link {
    if (self.owner) [self.owner ss_step];
    else [link invalidate];
}

@end
