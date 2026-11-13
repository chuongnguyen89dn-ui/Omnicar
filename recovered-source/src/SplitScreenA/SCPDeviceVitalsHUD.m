// DuoCar CarPlay read-only battery/temperature presentation.
// No scene, picker, divider, native Dock model, or window-level modifications.
#import "SCPDeviceVitalsHUD.h"
#import "OMCDeviceVitals.h"
#import "SCPShared.h"
#import "SCPVitalsPlacement.h"
#import "SCPFullscreenController.h" // [hl47] hide dock HUD in fullscreen
#import <CoreGraphics/CoreGraphics.h>
#import <math.h>
#import <objc/message.h>

@interface SCPDeviceVitalsHUD ()
@property(nonatomic,weak) UIView *host;
@property(nonatomic,strong) UIView *panel;
@property(nonatomic,strong) UILabel *label;
@property(nonatomic,strong) NSTimer *timer;
@property(nonatomic) BOOL horizontal;
@property(nonatomic) BOOL noSpaceLogged;
@end

@implementation SCPDeviceVitalsHUD

+ (instancetype)shared {
    static SCPDeviceVitalsHUD *instance;
    static dispatch_once_t once;
    dispatch_once(&once, ^{ instance = [SCPDeviceVitalsHUD new]; });
    return instance;
}

// Untrusted UIKit geometry is converted only after validating that both
// Dock and app occupy the same actual CarPlay parent coordinate space.
static BOOL SCPVitalsFiniteRect(CGRect r) {
    return !CGRectIsNull(r) && !CGRectIsInfinite(r) && !CGRectIsEmpty(r) &&
        isfinite(r.origin.x) && isfinite(r.origin.y) &&
        isfinite(r.size.width) && isfinite(r.size.height);
}
static SCPVitalsRect SCPVitalsToRect(CGRect r) {
    return (SCPVitalsRect){r.origin.x,r.origin.y,r.size.width,r.size.height};
}

- (void)stop {
    if (![NSThread isMainThread]) {
        dispatch_async(dispatch_get_main_queue(), ^{ [self stop]; });
        return;
    }
    if (self.panel) OMCLogWrite(@"SplitScreen", @"[vitals] car HUD detached");
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
    OMCLogWrite(@"SplitScreen", [NSString stringWithFormat:
        @"[vitals] battery=%@ charging=%@ tempC=%@ kind=%@ source=%@ thermal=%@ unitsVerified=%@",
        battery ?: @"unknown", sample[@"batteryState"],
        temp ?: @"unknown", sample[@"temperatureKind"], sample[@"temperatureSource"],
        sample[@"thermalState"], sample[@"temperatureUnitsVerified"]]);
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

// [hl49-dock] In HL48 the badge was put in tabParent, which can be under
// Dashboard's own Dock UIWindow. Resolve the actual native Dock presentation
// surface rather than relying on the split container's z-order.
static UIWindow *SCPVitalsNativeDockWindow(UIView *parent) {
    id root=SCPDashboardRootViewController();
    SEL sel=NSSelectorFromString(@"appDockViewController");
    if (!root || ![root respondsToSelector:sel]) return nil;
    id dockVC=((id(*)(id,SEL))objc_msgSend)(root,sel);
    if (!dockVC || ![dockVC respondsToSelector:@selector(view)]) return nil;
    UIView *dock=((UIView *(*)(id,SEL))objc_msgSend)(dockVC,@selector(view));
    if (![dock isKindOfClass:UIView.class] || !dock.window ||
        !parent.window || dock.window.screen!=parent.window.screen ||
        dock.isHidden || dock.alpha<=0.01) return nil;
    return dock.window;
}

- (void)showForParent:(UIView *)parent
             appArea:(CGRect)appArea
           dockFrame:(CGRect)dock
           homeFrame:(CGRect)home
       launcherFrame:(CGRect)launcher {
    if (![NSThread isMainThread]) return;
    if (!parent || !parent.window ||
        ![OMCPref(@"duocarVitalsEnabled", @YES) boolValue] ||
        !SCPVitalsFiniteRect(parent.bounds) ||
        !SCPVitalsFiniteRect(appArea) ||
        !SCPVitalsFiniteRect(dock) ||
        [[SCPFullscreenController shared] fsCommittedState] == SCPFullscreenStateExpanded) {
        [self stop]; return;
    }

    // The host tests the same C routine. Do not assume that the native
    // Dock is unshifted, or that the whole rail is available for a badge.
    SCPVitalsLayoutInput in = {0};
    in.root = SCPVitalsToRect(parent.bounds);
    in.app = SCPVitalsToRect(appArea);
    in.dock = SCPVitalsToRect(dock);
    if (SCPVitalsFiniteRect(home)) in.exclusions[in.exclusionCount++] = SCPVitalsToRect(home);
    if (SCPVitalsFiniteRect(launcher)) in.exclusions[in.exclusionCount++] = SCPVitalsToRect(launcher);
    SCPVitalsLayoutResult result = SCPVitalsPlace(in);
    if (!result.valid) {
        if (!self.noSpaceLogged) {
            self.noSpaceLogged = YES;
            OMCLogWrite(@"SplitScreen", [NSString stringWithFormat:
                @"[vitals] rail-no-room root=%@ app=%@ dock=%@ home=%@ launcher=%@",
                NSStringFromCGRect(parent.bounds), NSStringFromCGRect(appArea),
                NSStringFromCGRect(dock), NSStringFromCGRect(home),
                NSStringFromCGRect(launcher)]);
        }
        [self stop]; return;
    }
    self.noSpaceLogged = NO;
    BOOL horizontal = result.horizontal != 0;
    CGRect railFrame = CGRectMake(result.frame.x,result.frame.y,
                                   result.frame.w,result.frame.h);
    UIWindow *dockWindow=SCPVitalsNativeDockWindow(parent);
    if (!dockWindow) {
        OMCLogWrite(@"SplitScreen",@"[vitals] dock-window-absent: no badge attached");
        [self stop];return;
    }
    // Match both windows through the external screen coordinate space. A
    // UIKit view in tabParent can render BELOW the native Dock UIWindow.
    UIScreen *screen=parent.window.screen;
    CGRect onScreen=[parent convertRect:railFrame
                    toCoordinateSpace:screen.coordinateSpace];
    CGRect frame=[dockWindow convertRect:onScreen
                    fromCoordinateSpace:screen.coordinateSpace];
    if (!SCPVitalsFiniteRect(frame) ||
        !CGRectContainsRect(CGRectInset(dockWindow.bounds,-0.5,-0.5),frame)) {
        OMCLogWrite(@"SplitScreen",[NSString stringWithFormat:
            @"[vitals] dock-window-frame-invalid window=%@ rail=%@ proposed=%@",
            NSStringFromCGRect(dockWindow.bounds),NSStringFromCGRect(railFrame),
            NSStringFromCGRect(frame)]);
        [self stop];return;
    }
    if (!self.panel || self.panel.superview != dockWindow) {
        [self stop]; // resets timer when the external display/session changes
        UIView *panel = [[UIView alloc] initWithFrame:frame];
        panel.backgroundColor = [UIColor colorWithWhite:0 alpha:0.72];
        panel.layer.cornerRadius = 8.0;
        panel.clipsToBounds = YES;
        panel.userInteractionEnabled = NO; // do NOT intercept native Dock touches
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectInset(panel.bounds, 2, 1)];
        label.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        label.numberOfLines = horizontal ? 1 : 2;
        label.font = [UIFont systemFontOfSize:horizontal?10.0:9.0 weight:UIFontWeightSemibold];
        label.textAlignment = NSTextAlignmentCenter;
        label.adjustsFontSizeToFitWidth = YES;
        label.minimumScaleFactor = horizontal?0.74:0.65;
        [panel addSubview:label];
        [dockWindow addSubview:panel];
        self.host = dockWindow;
        self.panel = panel;
        self.label = label;
        self.horizontal = horizontal;
        OMCLogWrite(@"SplitScreen", [NSString stringWithFormat:
            @"[vitals] native-dock-attached frame=%@ level=%.0f window=%@ app=%@ dock=%@",
            NSStringFromCGRect(frame),dockWindow.windowLevel,
            NSStringFromClass(dockWindow.class),NSStringFromCGRect(appArea),
            NSStringFromCGRect(dock)]);
        [self refresh];
        self.timer = [NSTimer timerWithTimeInterval:12.0 target:self
            selector:@selector(refresh) userInfo:nil repeats:YES];
        [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
    } else {
        [dockWindow bringSubviewToFront:self.panel];
        // Update only our own panel. Geometry is recalculated every root layout.
        BOOL changedOrientation = self.horizontal != horizontal;
        self.horizontal = horizontal;
        self.label.numberOfLines = horizontal ? 1 : 2;
        self.panel.frame = frame;
        if (changedOrientation) [self refresh];
    }
}

@end
