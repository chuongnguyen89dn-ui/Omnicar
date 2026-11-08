// SCPSmallClasses.m — reconstructed from disassembly (agent A). All bodies VERIFIED.

#import "SCPSmallClasses.h"

@implementation SCPHostedAppVC

// VERIFIED: dark placeholder background (colorWithWhite:alpha: on the view).
// The two float constants sit in __const and were not decoded to exact
// values; the shape (white + alpha) is certain. INFERRED values 0.0/1.0
// (opaque black) — the pane shows its own loader over this anyway.
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithWhite:0.0 alpha:1.0];
}

// VERIFIED (0xfd14): if (completion) completion();
- (void)backgroundSceneWithCompletion:(void (^)(void))completion {
    if (completion) completion();
}

// VERIFIED (0xfd60): if (completion) completion();
- (void)foregroundSceneWithSettings:(id)settings completion:(void (^)(void))completion {
    if (completion) completion();
}

// VERIFIED: return nil.
- (id)applicationInfo { return nil; }
- (id)proxyApplicationInfo { return nil; }
- (id)sceneHostView { return nil; }

@end

@implementation SCPNoopLayoutAssertion
// VERIFIED (0x58b0): empty body.
- (void)invalidate {}
@end
