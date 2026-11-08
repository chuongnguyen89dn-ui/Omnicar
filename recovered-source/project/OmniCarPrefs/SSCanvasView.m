// SSCanvasView.m — OmniCarPrefs (reconstructed, Prefs-B)
// [VERIFIED 0x461c0]
#import "SSCanvasView.h"
#import "SSStartupView.h"

@implementation SSCanvasView

- (void)drawRect:(CGRect)rect {
    (void)rect;
    [self.owner ss_drawCanvas:UIGraphicsGetCurrentContext() size:self.bounds.size];
}

@end
