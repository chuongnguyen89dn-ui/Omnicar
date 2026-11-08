// OMCHSPreview.m — OmniCarPrefs reconstruction (Prefs-B)
// init VERIFIED (0x1b588); drawIcon:in: VERIFIED (0x1b670) including the
// OMCIconSized fallback rules; drawRect: VERIFIED (0x1bc48, 2,876 B):
// the context is scaled by previewWidth/800 so the logical canvas is
// 800 pt wide (logical height = height/scale), the wallpaper is drawn
// aspect-FILL with blur/dim washes, a dark 64-wide left strip, a "9:41"
// status label, strip icons, bottom-left bars, the icon grid (cell
// 712/cols x (H-30)/rows, icon round(64*size/100), labels via the
// sub_1c620 localized-name lookup) and multi-page pills follow.
// Geometry restored per work/prefs-audit/W2-preview-geometry.md (b);
// only the left-strip collection payload (@0x7f948) is UNRECOVERED.
#import "OMCHSPreview.h"
#import "OMCCommon.h"
#import <objc/message.h>

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
    BOOL installed = NO;
    SEL instSel = NSSelectorFromString(@"isInstalled");
    if ([state respondsToSelector:instSel])
        installed = ((BOOL (*)(id, SEL))objc_msgSend)(state, instSel);
    return installed;
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

// Shared id->name map (global at 0x90018 in the original), written by
// OMCAppBridgeAppsController -loadState from the homeScreenCarApps
// entries (store @0x1d454) and read by the name lookup below.
NSMutableDictionary *OMCHSNameMap = nil;

// Localized display name for a bundle id (sub_1c620 @0x1c620): the
// shared id->name map wins when it holds a name different from the id;
// otherwise the LSApplicationProxy localizedName; otherwise the id.
static NSString *OMCHSNameForBundleID(NSString *bundleID) {
    NSString *mapped = OMCHSNameMap[bundleID];
    if (mapped.length == 0 || [mapped isEqualToString:bundleID]) {
        NSString *localized = nil;
        Class proxyClass = NSClassFromString(@"LSApplicationProxy");
        SEL proxySel = NSSelectorFromString(@"applicationProxyForIdentifier:");
        SEL nameSel = NSSelectorFromString(@"localizedName");
        id proxy = nil;
        if ([proxyClass respondsToSelector:proxySel])
            proxy = ((id (*)(id, SEL, id))objc_msgSend)(proxyClass, proxySel, bundleID);
        if ([proxy respondsToSelector:nameSel])
            localized = ((id (*)(id, SEL))objc_msgSend)(proxy, nameSel);
        if ([localized isKindOfClass:[NSString class]] && [(NSString *)localized length] > 0)
            return localized;
        return bundleID;
    }
    return mapped;
}

// [UNRECOVERED payload] The left-strip icon list is a compile-time
// constant collection at 0x7f948 in the original (fast-enumerated
// @0x1c0ac); its elements are 24-byte constant objects whose string
// payloads could not be decoded (W2 audit item b, step 4). The drawing
// behaviour is proven — one drawIcon:in: per element at
// CGRectMake(11, 34 + 50*k, 42, 42) — and is implemented verbatim in
// drawRect: below; the list itself stays empty until the payload is
// recovered, so no invented icons are drawn.
static NSArray *OMCHSStripItems(void) {
    return @[];
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
    // Logical space @0x1bc94-0x1bcb4: scale = previewWidth/800, so the
    // logical width is exactly 800 and the logical height follows.
    double scale = b.size.width / 800.0;
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextScaleCTM(ctx, (CGFloat)scale, (CGFloat)scale);
    const double W = 800.0;
    const double H = b.size.height / scale;   // Hlog

    if (self.wallpaper) {
        // Aspect-FILL @0x1bd10-0x1bd24: s = MAX(736/imgW, Hlog/imgH),
        // drawn centred at (432, Hlog/2) — the midpoint of the rect
        // (64, 0, 736, Hlog) — clipped to (0, 0, 800, Hlog).
        CGSize img = self.wallpaper.size;
        double s = MAX(736.0 / img.width, H / img.height);
        double dw = img.width * s, dh = img.height * s;
        CGContextSaveGState(ctx);
        CGContextClipToRect(ctx, CGRectMake(0, 0, W, H));
        [self.wallpaper drawInRect:CGRectMake(432 - dw / 2, H / 2 - dh / 2, dw, dh)];
        if (self.blur >= 1 && !self.video) {
            // Blur wash @0x1bdf0-0x1be04: white, MIN(blur/120, 0.25).
            double a = MIN((double)self.blur / 120.0, 0.25);
            [[UIColor colorWithWhite:1 alpha:(CGFloat)a] setFill];
            UIRectFillUsingBlendMode(CGRectMake(0, 0, W, H), kCGBlendModeNormal);
        }
        // Dim wash @0x1be54: black, dim/100.
        [[UIColor colorWithWhite:0 alpha:(CGFloat)((double)self.dim / 100.0)] setFill];
        UIRectFillUsingBlendMode(CGRectMake(0, 0, W, H), kCGBlendModeNormal);
        CGContextRestoreGState(ctx);
        if (self.video) {
            // Video tag @0x1bf40-0x1bf58: (730, Hlog-20), 12 semibold.
            NSDictionary *attrs = @{
                NSFontAttributeName: [UIFont systemFontOfSize:12 weight:UIFontWeightSemibold],
                NSForegroundColorAttributeName: [UIColor colorWithWhite:1 alpha:0.85],
            };
            [@"▶︎ video" drawAtPoint:CGPointMake(730, H - 20) withAttributes:attrs];
        }
    } else {
        // No wallpaper @0x1bf6c-0x1bfc0: main area (64, 0, 736, Hlog)
        // filled with RGB (0.10, 0.11, 0.14).
        [[UIColor colorWithRed:0.10 green:0.11 blue:0.14 alpha:1] setFill];
        UIRectFill(CGRectMake(64, 0, 736, H));
    }
    // Left strip backdrop @0x1bfd0-0x1c020 (runs on both paths in the
    // original): rect (0, 0, 64, Hlog), RGB (0.06, 0.07, 0.08).
    [[UIColor colorWithRed:0.06 green:0.07 blue:0.08 alpha:1] setFill];
    UIRectFill(CGRectMake(0, 0, 64, H));

    // Status bar clock @0x1c028-0x1c0a8: "9:41" at (17, 8), bold 12.
    NSDictionary *clockAttrs = @{
        NSFontAttributeName: [UIFont boldSystemFontOfSize:12],
        NSForegroundColorAttributeName: [UIColor whiteColor],
    };
    [@"9:41" drawAtPoint:CGPointMake(17, 8) withAttributes:clockAttrs];

    // Left strip icons @0x1c0ac-0x1c168: one drawIcon:in: per element
    // of the constant collection at (11, 34 + 50*k, 42, 42). The
    // collection payload is UNRECOVERED — see OMCHSStripItems above.
    double stripY = 34;
    for (NSString *bid in OMCHSStripItems()) {
        [self drawIcon:bid in:CGRectMake(11, stripY, 42, 42)];
        stripY += 50;
    }

    // Bottom-left bars @0x1c168-0x1c1e4: 6 rects, white alpha 0.8;
    // rect i: x = 18 + (i mod 3)*10, y = (Hlog-30) + (i > 2 ? 9 : 0),
    // size 7x6.
    [[UIColor colorWithWhite:1 alpha:0.8] setFill];
    for (NSInteger i = 0; i < 6; i++) {
        double x = 18 + (i % 3) * 10;
        double y = (H - 30) + (i > 2 ? 9 : 0);
        UIRectFill(CGRectMake(x, y, 7, 6));
    }

    // Icon grid @0x1c1e8-0x1c4dc.
    NSInteger cols = self.cols > 0 ? self.cols : 5;
    NSInteger rows = self.rows >= 1 ? self.rows : 2;
    NSInteger capacity = rows * cols;
    NSInteger count = MIN((NSInteger)self.items.count, capacity);
    NSInteger pages = MAX(1, ((NSInteger)self.items.count + capacity - 1) / capacity);
    double cellW = 712.0 / cols;
    double cellH = (H - 30) / rows;
    double icon = round(64.0 * (double)self.size / 100.0);
    NSDictionary *nameAttrs = @{
        NSFontAttributeName: [UIFont systemFontOfSize:12 weight:UIFontWeightMedium],
        NSForegroundColorAttributeName: [UIColor whiteColor],
    };
    for (NSInteger i = 0; i < count; i++) {
        double cx = 76 + (i % cols) * cellW + cellW / 2;   // 64 + 12 + ...
        double cy = 6 + (i / cols) * cellH + cellH / 2 - (self.names ? 10 : 0);
        NSString *bid = self.items[i];
        [self drawIcon:bid in:CGRectMake(cx - icon / 2, cy - icon / 2, icon, icon)];
        if (self.names) {
            // Label @0x1c43c-0x1c494: localized name via sub_1c620,
            // font 12 Medium, width MIN(textWidth, cellW-6), height 16,
            // drawn with drawWithRect:options:0x20.
            NSString *text = OMCHSNameForBundleID(bid);
            double w = MIN([text sizeWithAttributes:nameAttrs].width, cellW - 6);
            [text drawWithRect:CGRectMake(cx - w / 2, cy + icon / 2 + 4, w, 16)
                       options:(NSStringDrawingOptions)0x20
                    attributes:nameAttrs
                       context:nil];
        }
    }

    // Page pills @0x1c4e0-0x1c5c0 (only when pages > 1): total width
    // pages*12+4 centred on x=432, y = Hlog-12; pill i is 16 wide for
    // i == 0 else 6, height 6, corner radius 3, white alpha 1.0 / 0.4;
    // advance x += width + 6.
    if (pages > 1) {
        double total = pages * 12 + 4;
        double px = 432 - total / 2;
        double py = H - 12;
        for (NSInteger i = 0; i < pages; i++) {
            double pw = (i == 0) ? 16 : 6;
            [[UIColor colorWithWhite:1 alpha:(i == 0) ? 1.0 : 0.4] setFill];
            [[UIBezierPath bezierPathWithRoundedRect:CGRectMake(px, py, pw, 6)
                                        cornerRadius:3] fill];
            px += pw + 6;
        }
    }
}

@end
