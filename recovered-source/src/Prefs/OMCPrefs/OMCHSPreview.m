// OMCHSPreview.m — OmniCarPrefs reconstruction (Prefs-B)
// init VERIFIED (0x1b588); drawIcon:in: VERIFIED (0x1b670) including the
// OMCIconSized fallback rules; drawRect: VERIFIED in structure (0x1bc48,
// 2,876 B): the context is scaled so the logical height is 800 pt, the
// wallpaper is drawn aspect-fill with blur/dim washes, a "9:41" status
// bar and the icon grid follow. Grid spacing constants are taken from
// the dump; minor glyph details are INFERRED where noted.
#import "OMCHSPreview.h"
#import "OMCCommon.h"

@interface UIImage (OMCHSIcon)
+ (UIImage *)_applicationIconImageForBundleIdentifier:(NSString *)bundleID
                                               format:(int)format scale:(double)scale;
@end

// The installed-check helper shared with the App Bridge TU (sub_1e0c4):
// YES when LaunchServices reports the app installed.
static BOOL OMCHSInstalled(NSString *bundleID) {
    Class proxyClass = NSClassFromString(@"LSApplicationProxy");
    SEL sel = NSSelectorFromString(@"applicationProxyForIdentifier:");
    if (![proxyClass respondsToSelector:sel]) return NO;
    id proxy = [proxyClass performSelector:sel withObject:bundleID];
    id state = nil;
    SEL stateSel = NSSelectorFromString(@"appState");
    if ([proxy respondsToSelector:stateSel]) state = [proxy performSelector:stateSel];
    id installed = nil;
    SEL instSel = NSSelectorFromString(@"isInstalled");
    if ([state respondsToSelector:instSel]) installed = [state performSelector:instSel];
    return [installed boolValue];
}

UIImage *OMCIconSized(NSString *bundleID, double points) {   // sub_1b7cc
    static NSCache *cache = nil;
    if (!cache) cache = [NSCache new];
    NSString *key = [NSString stringWithFormat:@"%@/%.0f", bundleID, points];
    UIImage *hit = [cache objectForKey:key];
    if (hit) return hit;
    UIImage *result = nil;
    if (OMCHSInstalled(bundleID) &&
        [UIImage respondsToSelector:@selector(_applicationIconImageForBundleIdentifier:format:scale:)]) {
        UIImage *raw = [UIImage _applicationIconImageForBundleIdentifier:bundleID
                                                                  format:2
                                                                   scale:[UIScreen mainScreen].scale];
        if (raw) {
            UIGraphicsImageRenderer *renderer =
                [[UIGraphicsImageRenderer alloc] initWithSize:CGSizeMake(points, points)];
            result = [renderer imageWithActions:^(UIGraphicsImageRendererContext *ctx) {
                (void)ctx;
                [raw drawInRect:CGRectMake(0, 0, points, points)];
            }];
        }
    }
    if (!result) {
        // Fallback tile: gradient + SF Symbol chosen from the bundle id.
        NSString *symbol = @"app.fill";
        if ([bundleID rangeOfString:@"NowPlaying"].location != NSNotFound) symbol = @"play.fill";
        else if ([bundleID rangeOfString:@"Settings"].location != NSNotFound) symbol = @"gearshape.fill";
        else if ([bundleID hasPrefix:@"com.apple.CarPlay"]) symbol = @"car.fill";
        UIColor *c1, *c2;
        if ([symbol isEqualToString:@"play.fill"]) { c1 = OMCColorFromHex(@"#FF8A65"); c2 = OMCColorFromHex(@"#FF3D71"); }
        else if ([symbol isEqualToString:@"car.fill"]) { c1 = OMCColorFromHex(@"#5AB8FF"); c2 = OMCColorFromHex(@"#2E7CF6"); }
        else { c1 = OMCColorFromHex(@"#9AA0A8"); c2 = OMCColorFromHex(@"#636A73"); }
        UIImageSymbolConfiguration *cfg =
            [UIImageSymbolConfiguration configurationWithPointSize:points * 0.48
                                                            weight:UIImageSymbolWeightSemibold];
        UIImage *glyph = [[UIImage systemImageNamed:symbol withConfiguration:cfg]
            imageWithTintColor:[UIColor whiteColor]
                 renderingMode:UIImageRenderingModeAlwaysOriginal];
        UIGraphicsImageRenderer *renderer =
            [[UIGraphicsImageRenderer alloc] initWithSize:CGSizeMake(points, points)];
        result = [renderer imageWithActions:^(UIGraphicsImageRendererContext *ctx) {
            CGContextRef cg = ctx.CGContext;
            CGColorSpaceRef space = CGColorSpaceCreateDeviceRGB();
            CGGradientRef grad = CGGradientCreateWithColors(space,
                (__bridge CFArrayRef)@[(id)c1.CGColor, (id)c2.CGColor], NULL);
            CGContextDrawLinearGradient(cg, grad, CGPointMake(0, 0),
                                        CGPointMake(points, points), 0);
            CGGradientRelease(grad);
            CGColorSpaceRelease(space);
            CGSize gs = glyph.size;
            [glyph drawInRect:CGRectMake((points - gs.width) / 2, (points - gs.height) / 2,
                                         gs.width, gs.height)];
        }];
    }
    if (result) [cache setObject:result forKey:key];
    return result;
}

UIImage *OMCThumb(UIImage *image, double width, double height, double scale) {  // sub_22df0 [INFERRED signature]
    if (!image) return nil;
    UIGraphicsImageRendererFormat *format = [UIGraphicsImageRendererFormat preferredFormat];
    format.scale = (CGFloat)scale;
    UIGraphicsImageRenderer *renderer =
        [[UIGraphicsImageRenderer alloc] initWithSize:CGSizeMake(width, height) format:format];
    return [renderer imageWithActions:^(UIGraphicsImageRendererContext *ctx) {
        (void)ctx;
        [image drawInRect:CGRectMake(0, 0, width, height)];
    }];
}

@implementation OMCHSPreview

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (!self) return nil;
    self.backgroundColor = [UIColor blackColor];
    self.layer.cornerRadius = 12;
    self.layer.cornerCurve = kCACornerCurveContinuous;
    self.clipsToBounds = YES;
    self.contentMode = (UIViewContentMode)3;   // VERIFIED raw value
    return self;
}

- (void)drawIcon:(NSString *)bundleID in:(CGRect)rect {
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextSaveGState(ctx);
    CGContextSetShadowWithColor(ctx, CGSizeMake(0, 3), 6,
                                [UIColor colorWithWhite:0 alpha:0.3].CGColor);
    UIImage *icon = OMCIconSized(bundleID, rect.size.width);
    if (icon) {
        [icon drawInRect:rect];
    } else {
        [[UIColor colorWithWhite:1 alpha:0.16] setFill];
        [[UIBezierPath bezierPathWithRoundedRect:rect
                                    cornerRadius:rect.size.width * 0.225] fill];
    }
    CGContextRestoreGState(ctx);
}

- (void)drawRect:(CGRect)rect {
    CGRect b = self.bounds;
    // Logical space: height = 800 units, context scaled uniformly.
    double scale = b.size.height / 800.0;
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextScaleCTM(ctx, (CGFloat)scale, (CGFloat)scale);
    double W = b.size.width / scale;
    const double H = 800;

    if (self.wallpaper) {
        CGSize img = self.wallpaper.size;
        double s = MIN(720.0 / img.width, W / img.height);
        double dw = img.width * s, dh = img.height * s;
        CGContextSaveGState(ctx);
        CGContextClipToRect(ctx, CGRectMake(0, 0, W, H));
        [self.wallpaper drawInRect:CGRectMake((W - dw) / 2, (H - dh) / 2, dw, dh)];
        if (self.blur >= 1 && !self.video) {
            double a = MIN((double)self.blur / 64.0, 0.25);
            [[UIColor colorWithWhite:1 alpha:(CGFloat)a] setFill];
            UIRectFillUsingBlendMode(CGRectMake(0, 0, W, H), kCGBlendModeNormal);
        }
        [[UIColor colorWithWhite:0 alpha:(CGFloat)((double)self.dim / 100.0)] setFill];
        UIRectFillUsingBlendMode(CGRectMake(0, 0, W, H), kCGBlendModeNormal);
        CGContextRestoreGState(ctx);
        if (self.video) {
            NSDictionary *attrs = @{
                NSFontAttributeName: [UIFont systemFontOfSize:12 weight:UIFontWeightSemibold],
                NSForegroundColorAttributeName: [UIColor colorWithWhite:1 alpha:0.85],
            };
            [@"▶︎ video" drawAtPoint:CGPointMake(17, H - 20) withAttributes:attrs];
        }
    } else {
        // Default gradient backdrop (two stacked fills in the binary).
        [[UIColor colorWithRed:0.16 green:0.18 blue:0.30 alpha:1] setFill];   // [INFERRED triple]
        UIRectFill(CGRectMake(0, 0, W, 64));
        [[UIColor colorWithRed:0.07 green:0.08 blue:0.14 alpha:1] setFill];   // [INFERRED triple]
        UIRectFill(CGRectMake(0, 0, W, H));
    }

    // Status bar clock.
    NSDictionary *clockAttrs = @{
        NSFontAttributeName: [UIFont boldSystemFontOfSize:12],
        NSForegroundColorAttributeName: [UIColor whiteColor],
    };
    [@"9:41" drawAtPoint:CGPointMake(17, 8) withAttributes:clockAttrs];

    // Icon grid.
    NSInteger cols = self.cols > 0 ? self.cols : 5;
    NSInteger rows = self.rows >= 1 ? self.rows : 2;
    NSInteger capacity = rows * cols;
    NSInteger count = MIN((NSInteger)self.items.count, capacity);
    double iconPt = 11 + (double)self.size;   // [INFERRED size mapping]
    double gapX = 50, gapY = 42;              // [INFERRED from dump constants]
    double x0 = 34, y0 = 120;                 // [INFERRED origin]
    NSDictionary *nameAttrs = @{
        NSFontAttributeName: [UIFont systemFontOfSize:11],
        NSForegroundColorAttributeName: [UIColor whiteColor],
    };
    for (NSInteger i = 0; i < count; i++) {
        double x = x0 + (i % cols) * gapX;
        double y = y0 + (i / cols) * (iconPt + gapY);
        NSString *bid = self.items[i];
        [self drawIcon:bid in:CGRectMake(x, y, iconPt, iconPt)];
        if (self.names) {
            // The binary draws the app name under the icon (name lookup
            // is the same id->name map the page builds). [INFERRED source]
            [bid drawAtPoint:CGPointMake(x, y + iconPt + 2) withAttributes:nameAttrs];
        }
    }
}

@end
