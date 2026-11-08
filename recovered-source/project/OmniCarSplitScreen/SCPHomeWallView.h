//  SCPHomeWallView.h
//  OmniCar 1.0.3 — OmniCarSplitScreen.dylib (reconstructed, module B)
//
//  Home-screen wallpaper view: a still image (UIImageView `image`) under
//  a black dimming view (`dim`), with an optional looping video layer
//  (AVQueuePlayer + AVPlayerLooper) composited by applySettings:source:.
//
//  Superclass is UIView (corrected table — the wave-1 metadata claimed a
//  shifted bind name; see SplitScreenB_REPORT.md, Finding 2).

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SCPHomeWallView : UIView

@property (nonatomic, strong) UIImageView *image;
@property (nonatomic, strong) UIView *dim;
@property (nonatomic, strong, nullable) AVQueuePlayer *player;
@property (nonatomic, strong, nullable) AVPlayerLooper *looper;
@property (nonatomic, strong, nullable) AVPlayerLayer *videoLayer;
/// Cache key of the currently loaded wallpaper (path + modification date).
@property (nonatomic, copy, nullable) NSString *loadedKey;

- (void)startVideo:(NSString *)path;
- (void)stopVideo;
- (void)updatePlayback;
- (void)applySettings:(NSDictionary *)settings source:(nullable id)source;

@end

NS_ASSUME_NONNULL_END
