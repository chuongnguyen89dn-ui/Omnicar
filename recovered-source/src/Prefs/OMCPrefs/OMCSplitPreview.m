// OMCSplitPreview.m — OmniCarPrefs reconstruction (Prefs-B)
// init VERIFIED (0x37944); drawRect: VERIFIED (0x37a48): LEFT header
// strip (0,0,30,H) + three traffic dots, split panes (ratio 0.46 on
// W-40, panes at y=4 height H-8) with icons resolved by the file-static
// helper below (side = MIN(paneH*0.42, 44), rendered at side x side),
// pin badge, off caption. Geometry restored per
// work/prefs-audit/W2-preview-geometry.md (c).
#import "OMCSplitPreview.h"
#import "OMCCommon.h"

// File-static in the binary (sub_380a4): app icon for a bundle id via the
// private UIImage API, rasterized at (points, points) — the caller passes
// side = MIN(paneH * 0.42, 44) @0x37dbc-0x37dc8; nil for bad ids.
@interface UIImage (OMCPrivateIcon)
+ (UIImage *)_applicationIconImageForBundleIdentifier:(NSString *)bundleID
                                               format:(int)format scale:(double)scale;
@end

static UIImage *SPPSplitIconForBundleID(NSString *bundleID, double points) {
    if (![bundleID isKindOfClass:[NSString class]] || bundleID.length == 0) return nil;
    SEL sel = NSSelectorFromString(@"_applicationIconImageForBundleIdentifier:format:scale:");
    if (![UIImage respondsToSelector:sel]) return nil;
    UIImage *icon = [UIImage _applicationIconImageForBundleIdentifier:bundleID
                                                                format:2
                                                                 scale:[UIScreen mainScreen].scale];
    if (!icon) return nil;
    UIGraphicsImageRenderer *renderer =
        [[UIGraphicsImageRenderer alloc] initWithSize:CGSizeMake(points, points)];
    return [renderer imageWithActions:^(UIGraphicsImageRendererContext *ctx) {
        (void)ctx;
        [icon drawInRect:CGRectMake(0, 0, points, points)];
    }];
}

@implementation OMCSplitPreview

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (!self) return nil;
    self.backgroundColor = [UIColor colorWithRed:0.055 green:0.06 blue:0.075 alpha:1]; // VERIFIED @0x37984 (pools 0x65e10/0x65760/0x65e18)
    self.layer.cornerRadius = 14;
    self.layer.cornerCurve = kCACornerCurveContinuous;
    self.clipsToBounds = YES;
    self.contentMode = (UIViewContentMode)3;   // VERIFIED raw value in the binary
    return self;
}

- (void)drawRect:(CGRect)rect {
    CGRect b = self.bounds;
    // Header is a LEFT vertical strip (0, 0, 30, H) @0x37a9c-0x37ae8,
    // RGB (0.086, 0.09, 0.106) — not a top bar.
    [[UIColor colorWithRed:0.086 green:0.09 blue:0.106 alpha:1] setFill];
    UIRectFill(CGRectMake(0, 0, 30, b.size.height));
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
        // Two panes (left app + pinned app) @0x37c14-0x37c7c: content
        // starts at x = 34 (strip 30 + 4); leftW = floor((W-40) * 0.46);
        // pane1 = (34, 4, leftW, H-8), pane2 = (38+leftW, 4,
        // W-40-leftW, H-8). Pane fill RGB (0.12, 0.13, 0.16) alpha 1.0
        // @0x37d08-0x37d4c, corner radius 10.
        double leftW = floor((b.size.width - 40) * 0.46);
        CGRect p1 = CGRectMake(34, 4, leftW, b.size.height - 8);
        CGRect p2 = CGRectMake(38 + leftW, 4, b.size.width - 40 - leftW, b.size.height - 8);
        NSArray<NSString *> *ids = @[self.left ?: @"", self.pinned ?: @""];
        NSArray<NSValue *> *panes = @[[NSValue valueWithCGRect:p1],
                                      [NSValue valueWithCGRect:p2]];
        [[UIColor colorWithRed:0.12 green:0.13 blue:0.16 alpha:1] setFill];
        for (NSUInteger i = 0; i < ids.count; i++) {
            CGRect pane = panes[i].CGRectValue;
            [[UIBezierPath bezierPathWithRoundedRect:pane cornerRadius:10] fill];
            // Icon side = MIN(paneH * 0.42, 44) @0x37dbc-0x37dc8; the
            // helper renders at (side, side) and the image is drawn
            // centred at its own size @0x37de4-0x37e60.
            double side = MIN(pane.size.height * 0.42, 44);
            UIImage *icon = SPPSplitIconForBundleID(ids[i], side);
            if (icon) {
                [icon drawInRect:CGRectMake(CGRectGetMidX(pane) - icon.size.width / 2,
                                            CGRectGetMidY(pane) - icon.size.height / 2,
                                            icon.size.width, icon.size.height)];
            }
        }
        // Pin badge on the pinned pane @0x37f08-0x37f2c:
        // (MaxX(pane2) - 18, 10, 12, 13).
        if (self.pinned.length) {
            UIImage *pin = [[UIImage systemImageNamed:@"pin.fill"]
                imageWithTintColor:OMCColorFromHex(@"#FFB340")
                     renderingMode:UIImageRenderingModeAlwaysOriginal];
            [pin drawInRect:CGRectMake(CGRectGetMaxX(p2) - 18, 10, 12, 13)];
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
