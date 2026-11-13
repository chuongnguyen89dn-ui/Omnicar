// DuoCar CarPlay read-only battery/temperature presentation.
// No scene, picker, divider, native Dock model, or window-level modifications.
#import "SCPDeviceVitalsHUD.h"
#import "OMCDeviceVitals.h"
#import "SCPShared.h"
#import <CoreGraphics/CoreGraphics.h>
#import <math.h>

@interface SCPDeviceVitalsHUD ()
@property(nonatomic,weak) UIView *host;
@property(nonatomic,strong) UIView *panel;
@property(nonatomic,strong) UILabel *label;
@property(nonatomic,strong) NSTimer *timer;
@property(nonatomic) BOOL horizontal;
@end

@implementation SCPDeviceVitalsHUD

+ (instancetype)shared {
    static SCPDeviceVitalsHUD *instance;
    static dispatch_once_t once;
    dispatch_once(&once, ^{ instance = [SCPDeviceVitalsHUD new]; });
    return instance;
}

static BOOL SCPVitalsFiniteRect(CGRect r) {
    return !CGRectIsNull(r) && !CGRectIsInfinite(r) && !CGRectIsEmpty(r) &&
        isfinite(r.origin.x) && isfinite(r.origin.y) &&
        isfinite(r.size.width) && isfinite(r.size.height);
}

// The candidate is contained COMPLETELY in the space outside the app area,
// and must not intersect the existing native Dock's actual frame. A dock
// filling the entire rail intentionally results in NO on-car HUD.
static CGRect SCPVitalsRailPlacement(CGRect rail, CGRect dock, BOOL vertical) {
    if (!SCPVitalsFiniteRect(rail) || !SCPVitalsFiniteRect(dock) ||
        !CGRectIntersectsRect(rail, dock)) return CGRectNull;
    const CGFloat margin = 7.0, separation = 8.0;
    CGRect frame = CGRectNull;
    if (vertical) {
        const CGFloat w = MIN(rail.size.width - 2 * margin, 65.0), h = 49.0;
        if (w < 39.0 || rail.size.height < h + 2 * margin) return CGRectNull;
        CGFloat x = floor(CGRectGetMidX(rail) - w / 2.0);
        CGFloat bottomY = MAX(CGRectGetMinY(rail) + margin,
                              CGRectGetMaxY(dock) + separation);
        CGFloat topY = MIN(CGRectGetMaxY(rail) - margin - h,
                          CGRectGetMinY(dock) - separation - h);
        if (bottomY + h <= CGRectGetMaxY(rail) - margin)
            frame = CGRectMake(x, bottomY, w, h);
        else if (topY >= CGRectGetMinY(rail) + margin)
            frame = CGRectMake(x, topY, w, h);
    } else {
        const CGFloat w = 128.0, h = MIN(rail.size.height - 2 * margin, 27.0);
        if (h < 22.0 || rail.size.width < w + 2 * margin) return CGRectNull;
        CGFloat y = floor(CGRectGetMidY(rail) - h / 2.0);
        CGFloat rightX = MAX(CGRectGetMinX(rail) + margin,
                             CGRectGetMaxX(dock) + separation);
        CGFloat leftX = MIN(CGRectGetMaxX(rail) - margin - w,
                            CGRectGetMinX(dock) - separation - w);
        if (rightX + w <= CGRectGetMaxX(rail) - margin)
            frame = CGRectMake(rightX, y, w, h);
        else if (leftX >= CGRectGetMinX(rail) + margin)
            frame = CGRectMake(leftX, y, w, h);
    }
    return SCPVitalsFiniteRect(frame) && !CGRectIntersectsRect(frame, dock)
        ? frame : CGRectNull;
}

- (void)stop {
    if (![NSThread isMainThread]) {
        dispatch_async(dispatch_get_main_queue(), ^{ [self stop]; });
        return;
    }
    [self.timer invalidate];
    self.timer = nil;
    [self.panel removeFromSuperview];
    self.panel = nil;
    self.label = nil;
    self.host = nil;
}

- (void)refresh {
    if (!self.panel || !self.host.window) { [self stop]; return; }
    if (![OMCPref(@"duocarVitalsEnabled", @YES) boolValue]) { [self stop]; return; }

    NSDictionary *sample = OMCDeviceVitalsSample();
    NSNumber *battery = [sample[@"batteryPercent"] isKindOfClass:NSNumber.class]
        ? sample[@"batteryPercent"] : nil;
    NSNumber *temp = [sample[@"temperatureCelsius"] isKindOfClass:NSNumber.class]
        ? sample[@"temperatureCelsius"] : nil;
    NSString *batteryText = battery
        ? [NSString stringWithFormat:@"%ld%%", (long)battery.integerValue] : @"—";
    NSString *heatText = temp
        ? [NSString stringWithFormat:@"~%.0f°C", temp.doubleValue]
        : OMCDeviceVitalsThermalDescription(sample[@"thermalState"]);
    NSString *kind = sample[@"temperatureKind"];
    // A leading tilde indicates decoded temperature scale is not device-calibrated.
    if (self.horizontal) {
        self.label.text = [NSString stringWithFormat:@"🔋 %@   🌡 %@", batteryText, heatText];
    } else {
        self.label.text = [NSString stringWithFormat:@"🔋 %@\n🌡 %@", batteryText, heatText];
    }
    self.panel.accessibilityLabel = [NSString stringWithFormat:
        @"Pin iPhone %@; nhiệt %@; nguồn %@. Không phải cảm biến GPU.",
        batteryText, heatText, sample[@"temperatureSource"]];
    if (temp) {
        self.label.textColor = [kind isEqualToString:@"battery"]
            ? UIColor.whiteColor : [UIColor colorWithRed:1 green:0.91 blue:0.65 alpha:1];
    } else {
        NSString *state = sample[@"thermalState"];
        self.label.textColor =
            ([state isEqualToString:@"serious"] || [state isEqualToString:@"critical"])
            ? [UIColor colorWithRed:1 green:0.71 blue:0.55 alpha:1] : UIColor.whiteColor;
    }
}

- (void)showForParent:(UIView *)parent appArea:(CGRect)appArea dockFrame:(CGRect)dock {
    if (![NSThread isMainThread]) return;
    if (!parent || !parent.window ||
        ![OMCPref(@"duocarVitalsEnabled", @YES) boolValue] ||
        !SCPVitalsFiniteRect(parent.bounds) ||
        !SCPVitalsFiniteRect(appArea) ||
        !SCPVitalsFiniteRect(dock)) {
        [self stop]; return;
    }

    // All four Dock orientations are considered. The native Dock must
    // actually intersect the corresponding rail (not just occupy a guessed
    // fixed-width margin). Only empty rail space can carry the badge.
    CGRect bounds = parent.bounds;
    CGRect area = CGRectIntersection(bounds, appArea);
    if (!SCPVitalsFiniteRect(area)) { [self stop]; return; }
    CGRect rails[4] = {
        CGRectMake(CGRectGetMinX(bounds), CGRectGetMinY(bounds),
                   MAX(0, CGRectGetMinX(area) - CGRectGetMinX(bounds)), bounds.size.height),
        CGRectMake(CGRectGetMaxX(area), CGRectGetMinY(bounds),
                   MAX(0, CGRectGetMaxX(bounds) - CGRectGetMaxX(area)), bounds.size.height),
        CGRectMake(CGRectGetMinX(bounds), CGRectGetMinY(bounds),
                   bounds.size.width, MAX(0, CGRectGetMinY(area) - CGRectGetMinY(bounds))),
        CGRectMake(CGRectGetMinX(bounds), CGRectGetMaxY(area),
                   bounds.size.width, MAX(0, CGRectGetMaxY(bounds) - CGRectGetMaxY(area)))
    };
    CGRect location = CGRectNull;
    BOOL horizontal = NO;
    for (NSInteger i = 0; i < 4; ++i) {
        CGRect candidate = SCPVitalsRailPlacement(rails[i], dock, i < 2);
        if (SCPVitalsFiniteRect(candidate)) {
            location = candidate;
            horizontal = i >= 2;
            break;
        }
    }
    if (!SCPVitalsFiniteRect(location)) { [self stop]; return; }
    if (!self.panel || self.panel.superview != parent) {
        [self stop]; // also invalidates the prior session timer
        UIView *panel = [[UIView alloc] initWithFrame:location];
        panel.backgroundColor = [UIColor colorWithWhite:0 alpha:0.72];
        panel.layer.cornerRadius = 8.0;
        panel.clipsToBounds = YES;
        panel.userInteractionEnabled = NO; // never block native Dock touches
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectInset(panel.bounds, 2, 1)];
        label.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        label.numberOfLines = horizontal ? 1 : 2;
        label.font = [UIFont systemFontOfSize:horizontal ? 10.0 : 10.0 weight:UIFontWeightSemibold];
        label.textAlignment = NSTextAlignmentCenter;
        label.adjustsFontSizeToFitWidth = YES;
        label.minimumScaleFactor = 0.74;
        [panel addSubview:label];
        [parent addSubview:panel];
        self.host = parent;
        self.panel = panel;
        self.label = label;
        self.horizontal = horizontal;
        [self refresh];
        self.timer = [NSTimer timerWithTimeInterval:12.0 target:self
            selector:@selector(refresh) userInfo:nil repeats:YES];
        [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
    } else {
        self.horizontal = horizontal;
        self.label.numberOfLines = horizontal ? 1 : 2;
        self.panel.frame = location;
        // Only its own panel moves. No native Dock, icon, picker or pane mutation.
    }
}
@end
