// OMCSplitPreview.m — OmniCarPrefs reconstruction (Prefs-B)
// init VERIFIED (0x37944); drawRect: VERIFIED in structure (0x37a48):
// header strip + three traffic dots, split panes with icons resolved by
// the file-static helper below, pin badge, off caption. Exact pane
// geometry factors are taken from the dump (0.375 width fraction etc.).
#import "OMCSplitPreview.h"
#import "OMCCommon.h"

// File-static in the binary (sub_380a4): app icon for a bundle id via the
// private UIImage API, rasterized at the display scale; nil for bad ids.
@interface UIImage (OMCPrivateIcon)
+ (UIImage *)_applicationIconImageForBundleIdentifier:(NSString *)bundleID
                                               format:(int)format scale:(double)scale;
@end

static UIImage *SPPSplitIconForBundleID(NSString *bundleID) {
    if (![bundleID isKindOfClass:[NSString class]] || bundleID.length == 0) return nil;
    SEL sel = NSSelectorFromString(@"_applicationIconImageForBundleIdentifier:format:scale:");
    if (![UIImage respondsToSelector:sel]) return nil;
    UIImage *icon = [UIImage _applicationIconImageForBundleIdentifier:bundleID
                                                                format:2
                                                                 scale:[UIScreen mainScreen].scale];
    if (!icon) return nil;
    UIGraphicsImageRenderer *renderer =
        [[UIGraphicsImageRenderer alloc] initWithSize:icon.size];
    return [renderer imageWithActions:^(UIGraphicsImageRendererContext *ctx) {
        (void)ctx;
        [icon drawInRect:CGRectMake(0, 0, icon.size.width, icon.size.height)];
    }];
}

@implementation OMCSplitPreview

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (!self) return nil;
    self.backgroundColor = [UIColor colorWithRed:0.13 green:0.14 blue:0.20 alpha:1]; // [INFERRED triple]
    self.layer.cornerRadius = 14;
    self.layer.cornerCurve = kCACornerCurveContinuous;
    self.clipsToBounds = YES;
    self.contentMode = (UIViewContentMode)3;   // VERIFIED raw value in the binary
    return self;
}

- (void)drawRect:(CGRect)rect {
    CGRect b = self.bounds;
    // Header strip.
    [[UIColor colorWithRed:0.10 green:0.11 blue:0.16 alpha:1] setFill]; // [INFERRED triple]
    UIRectFill(CGRectMake(0, 0, b.size.width, 30));
    // Traffic dots.
    NSArray<UIColor *> *dots = @[OMCColorFromHex(@"#8B7CFF"),
                                 OMCColorFromHex(@"#2E9CF5"),
                                 OMCColorFromHex(@"#FA2D55")];
    double y = 10;
    for (UIColor *c in dots) {
        [c setFill];
        [[UIBezierPath bezierPathWithRoundedRect:CGRectMake(7, y, 16, 16)
                                    cornerRadius:5] fill];
        y += 22;
    }
    if (self.on) {
        // Two panes (left app + pinned app), split by the stored ratio.
        double paneY = 30 - 8 + 4;                       // [INFERRED offsets]
        double paneH = b.size.height - paneY - 4;
        double leftW = floor((b.size.width - 8 - 4) * 0.375);
        NSArray<NSString *> *ids = @[self.left ?: @"", self.pinned ?: @""];
        double x = 4;
        for (NSUInteger i = 0; i < ids.count; i++) {
            double w = (i == 0) ? leftW : (b.size.width - 8 - leftW);
            CGRect pane = CGRectMake(x, paneY, w, paneH);
            [[UIColor colorWithRed:0.12 green:0.13 blue:0.20 alpha:0.55] setFill]; // [INFERRED]
            [[UIBezierPath bezierPathWithRoundedRect:pane cornerRadius:10] fill];
            UIImage *icon = SPPSplitIconForBundleID(ids[i]);
            if (icon) {
                double side = MIN(44, MIN(pane.size.width, pane.size.height) * 0.62);
                [icon drawInRect:CGRectMake(CGRectGetMidX(pane) - side / 2,
                                            CGRectGetMidY(pane) - side / 2, side, side)];
            }
            x += w + 4;
        }
        // Pin badge on the pinned pane.
        if (self.pinned.length) {
            CGRect lastPane = CGRectMake(4 + leftW + 4, paneY,
                                         b.size.width - 8 - leftW, paneH);
            UIImage *pin = [[UIImage systemImageNamed:@"pin.fill"]
                imageWithTintColor:OMCColorFromHex(@"#FFB340")
                     renderingMode:UIImageRenderingModeAlwaysOriginal];
            [pin drawInRect:CGRectMake(CGRectGetMaxX(lastPane) - 18, paneY + 4, 10, 13)];
        }
    } else {
        NSDictionary *attrs = @{
            NSFontAttributeName: [UIFont systemFontOfSize:13],
            NSForegroundColorAttributeName: [UIColor colorWithWhite:1 alpha:0.55],
        };
        CGSize size = [self.offText sizeWithAttributes:attrs];
        [self.offText drawAtPoint:CGPointMake((b.size.width - size.width) / 2 + 15,
                                              (b.size.height - size.height) / 2)
                   withAttributes:attrs];
    }
}

@end
