//  SCPHomeWallView.m
//  OmniCar 1.0.3 — OmniCarSplitScreen.dylib (reconstructed, module B)
//
//  Behaviour verified from the disassembly; applySettings:source:
//  is fully closed, including its main-queue block @0x4a294 (see
//  the report's Final micro-closure note).

#import "SCPHomeWallView.h"
#import "SCPCarSplit.h"
#import "SCPCommon.h"   // OMCLogWrite (used by the @0x4a294 block)

@implementation SCPHomeWallView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.userInteractionEnabled = NO;
        self.clipsToBounds = YES;
        _image = [[UIImageView alloc] initWithFrame:self.bounds];
        _image.contentMode = UIViewContentModeScaleAspectFill;   // INFERRED mode
        _image.autoresizingMask = 0x12;
        [self addSubview:_image];
        _dim = [[UIView alloc] initWithFrame:self.bounds];
        _dim.backgroundColor = UIColor.blackColor;
        _dim.autoresizingMask = 0x12;
        [self addSubview:_dim];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    self.videoLayer.frame = self.bounds;
    [CATransaction commit];
}

- (void)didMoveToWindow {
    [super didMoveToWindow];
    [self updatePlayback];
}

- (void)startVideo:(NSString *)path {
    [self stopVideo];
    AVPlayerItem *item =
        [AVPlayerItem playerItemWithURL:[NSURL fileURLWithPath:path]];
    self.player = [AVQueuePlayer queuePlayerWithItems:@[item]];
    self.player.muted = YES;                                     // value INFERRED
    self.player.preventsDisplaySleepDuringVideoPlayback = NO;    // value INFERRED
    self.looper = [AVPlayerLooper playerLooperWithPlayer:self.player
                                            templateItem:item];
    self.videoLayer = [AVPlayerLayer playerLayerWithPlayer:self.player];
    self.videoLayer.videoGravity = AVLayerVideoGravityResizeAspectFill; // INFERRED
    self.videoLayer.frame = self.bounds;
    [self.layer insertSublayer:self.videoLayer below:self.dim.layer];   // INFERRED placement
    [self updatePlayback];
}

- (void)stopVideo {
    [self.player pause];
    [self.looper disableLooping];
    [self.videoLayer removeFromSuperlayer];
    self.player = nil;
    self.looper = nil;
    self.videoLayer = nil;
}

// Play only while on a window, the split is active and the device is not
// thermally throttled; the thermal ceiling comparison is INFERRED.
- (void)updatePlayback {
    @try {
        AVQueuePlayer *player = self.player;
        if (player == nil) return;
        BOOL shouldPlay = self.window != nil &&
            [NSProcessInfo processInfo].thermalState <= NSProcessInfoThermalStateFair &&
            [SCPCarSplit shared].active;
        if (shouldPlay) {
            if (player.rate == 0) [player play];
        } else {
            [player pause];
        }
    } @catch (id exception) {
    }
}

// CLOSED in the wave-3 closure pass (was PARTIAL) — @0x49b2c. The dim
// value is a PERCENTAGE (divided by 100); path and video come from the
// SOURCE dict, not settings; the cache key is '%@|%@|%@|%d' over
// (path, modification date, blur object, video). Still images load on a
// user-initiated global queue with an optional CIGaussianBlur, then
// apply on the main queue.
- (void)applySettings:(NSDictionary *)settings source:(id)source {
    self.dim.alpha = [settings[@"dim"] doubleValue] / 100.0;
    NSString *path = source[@"path"];
    BOOL video = [source[@"video"] boolValue];
    NSDate *modified = [[[NSFileManager defaultManager]
        attributesOfItemAtPath:path error:nil] fileModificationDate];
    NSString *key = [NSString stringWithFormat:@"%@|%@|%@|%d",
                     path, modified, settings[@"blur"], (int)video];
    if ([key isEqualToString:self.loadedKey]) {
        [self updatePlayback];
        return;
    }
    self.loadedKey = key;
    if (video) {
        [self startVideo:path];
        return;
    }
    [self stopVideo];
    double blur = [settings[@"blur"] doubleValue];
    __weak SCPHomeWallView *weakSelf = self;
    dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0), ^{
        // Async block @0x49ee4 (VERIFIED).
        UIImage *image = [UIImage imageWithContentsOfFile:path];
        if (blur > 0 && image.CGImage != NULL) {
            CIImage *ci = [CIImage imageWithCGImage:image.CGImage];
            CIFilter *filter = [CIFilter filterWithName:@"CIGaussianBlur"];
            [filter setValue:[ci imageByClampingToExtent] forKey:kCIInputImageKey];
            [filter setValue:@(blur) forKey:kCIInputRadiusKey];
            CIImage *out = [filter.outputImage imageByCroppingToRect:ci.extent];
            if (out != nil) {
                CIContext *context = [CIContext contextWithOptions:nil];
                CGImageRef cg = [context createCGImage:out fromRect:ci.extent];
                if (cg != NULL) {
                    image = [UIImage imageWithCGImage:cg scale:image.scale
                                          orientation:image.imageOrientation];
                    CGImageRelease(cg);
                }
            }
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            // Main-queue completion block @0x4a294 — VERIFIED,
            // line-read in the final micro-closure pass (captures:
            // key @+0x20, image @+0x28, path @+0x30, weak self
            // @+0x38). It cross-dissolves the loaded image in over
            // 0.4 s (UIView transition, animations block @0x4a450)
            // only when self.loadedKey still equals the captured
            // key, and logs the failure case afterwards.
            SCPHomeWallView *strongSelf = weakSelf;
            if (strongSelf == nil) return;
            if (![strongSelf.loadedKey isEqualToString:key]) return;
            [UIView transitionWithView:strongSelf.image
                              duration:0.4
                               options:UIViewAnimationOptionTransitionCrossDissolve
                            animations:^{ strongSelf.image.image = image; }
                            completion:nil];
            if (image == nil)
                OMCLogWrite(@"SplitScreen",
                    [NSString stringWithFormat:
                        @"HomeScreen: khong doc duoc hinh nen %@", path]);
        });
    });
}

@end
