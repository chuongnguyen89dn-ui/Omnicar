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
    if (!self.panel || !self.panel.window) { [self stop]; return; }
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
        // A real 45pt CarPlay Dock rail has at most 39pt for the badge.
        // Old spaced ~XX°C rows required >50pt and scaled down invisibly.
        NSString *compactTemp = temp ?
           [NSString stringWithFormat:@"%.0f°",temp.doubleValue] : @"--";
        self.label.text = [NSString stringWithFormat:@"🔋%@\n🌡%@",
                          batteryText,compactTemp];
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

// [hl50-dock] Native Dock own view and child icons are the only trusted
// reference. The former HL49 added a panel to dock.window and placed it
// OUTSIDE the Dock rectangle. It could float at top-left and obscure pinch.
// Do not open/move any UIWindow. Only an inert view inside the native Dock.
static UIView *SCPVitalsNativeDockView(UIView *parent) {
    id root=SCPDashboardRootViewController();
    SEL sel=NSSelectorFromString(@"appDockViewController");
    if(!root || ![root respondsToSelector:sel])return nil;
    id vc=((id(*)(id,SEL))objc_msgSend)(root,sel);
    if(!vc || ![vc respondsToSelector:@selector(view)])return nil;
    UIView *dock=((UIView *(*)(id,SEL))objc_msgSend)(vc,@selector(view));
    if(![dock isKindOfClass:UIView.class] || !dock.window || !parent.window ||
       dock.window.screen != parent.window.screen ||
       dock.hidden || dock.alpha <=0.01)return nil;
    return dock;
}
static void SCPVitalsCollectControls(UIView *view,UIView *dock,UIView *ignore,
                                    NSMutableArray<NSValue *> *rects,
                                    NSUInteger depth) {
    if(!view || depth>7)return;
    for(UIView *sub in view.subviews) {
        if(sub==ignore || sub.hidden || sub.alpha<=0.03)continue;
        CGRect rect=[sub convertRect:sub.bounds toView:dock];
        rect=CGRectIntersection(rect,dock.bounds);
        if(CGRectIsNull(rect) || CGRectIsEmpty(rect))continue;
        BOOL interactive=([sub isKindOfClass:UIControl.class] ||
            sub.gestureRecognizers.count>0 ||
            ((sub.accessibilityTraits & UIAccessibilityTraitButton)!=0));
        if(interactive && rect.size.width>12 && rect.size.height>12 &&
           rect.size.height < dock.bounds.size.height*0.80)
            [rects addObject:[NSValue valueWithCGRect:CGRectInset(rect,-3,-3)]];
        if(depth<7)SCPVitalsCollectControls(sub,dock,ignore,rects,depth+1);
    }
}
static CGRect SCPVitalsDockSlot(UIView *dock,UIView *ignore,UIView *parent,
                               CGRect home,CGRect launcher,BOOL *horizontal) {
    CGRect bounds=dock.bounds;
    if(!SCPVitalsFiniteRect(bounds))return CGRectNull;
    BOOL isHorizontal=bounds.size.width>bounds.size.height*1.5;
    if(horizontal)*horizontal=isHorizontal;
    CGFloat margin=3.0;
    CGFloat width=isHorizontal?112.0:MIN(39.0,bounds.size.width-2*margin);
    CGFloat height=isHorizontal?27.0:44.0;
    if(width<35 || (isHorizontal && width>bounds.size.width-6) ||
       height>bounds.size.height-6)return CGRectNull;
    NSMutableArray<NSValue *> *blocked=[NSMutableArray array];
    SCPVitalsCollectControls(dock,dock,ignore,blocked,0);
    for(NSValue *v in @[[NSValue valueWithCGRect:home],
                        [NSValue valueWithCGRect:launcher]]) {
        CGRect external=v.CGRectValue;
        if(!SCPVitalsFiniteRect(external))continue;
        CGRect location=[dock convertRect:external fromView:parent];
        location=CGRectIntersection(bounds,location);
        if(!CGRectIsNull(location) && !CGRectIsEmpty(location))
            [blocked addObject:[NSValue valueWithCGRect:CGRectInset(location,-4,-4)]];
    }
    UIEdgeInsets safe=dock.safeAreaInsets;
    CGFloat left=MAX(3,safe.left+2),top=MAX(3,safe.top+2);
    CGFloat right=bounds.size.width-MAX(3,safe.right+2);
    CGFloat bottom=bounds.size.height-MAX(3,safe.bottom+2);
    // Walk the real Dock itself from the end that contains its status
    // gap. Refuse occupied locations; never place in app pane's rail.
    CGFloat maxY=bottom-height,maxX=right-width;
    if(maxY<top||maxX<left)return CGRectNull;
    NSUInteger trials=0;
    for(CGFloat y=top;y<=maxY+0.2;y+=2.0) {
        for(CGFloat x=left;x<=maxX+0.2;x+=isHorizontal?3.0:2.0) {
            CGRect frame=CGRectMake(x,y,width,height);
            BOOL collision=NO;
            for(NSValue *v in blocked)
                if(CGRectIntersectsRect(frame,v.CGRectValue)) {
                    collision=YES;break;
                }
            if(!collision)return frame;
            if(++trials>=25000)return CGRectNull;
        }
    }
    return CGRectNull;
}
- (void)showForParent:(UIView *)parent
             appArea:(CGRect)appArea
           dockFrame:(CGRect)dockFrame
           homeFrame:(CGRect)home
       launcherFrame:(CGRect)launcher {
    if (![NSThread isMainThread]) return;
    if(!parent || !parent.window ||
       ![OMCPref(@"duocarVitalsEnabled",@YES) boolValue] ||
       [[SCPFullscreenController shared] fsCommittedState]==SCPFullscreenStateExpanded) {
        [self stop];return;
    }
    UIView *dock=SCPVitalsNativeDockView(parent);
    if(!dock) {
        OMCLogWrite(@"SplitScreen",@"[hl50-dock] MISSING native Dock UIView; no fallback to app/root UIWindow");
        [self stop];return;
    }
    BOOL horizontal=NO;
    CGRect frame=SCPVitalsDockSlot(dock,self.panel,parent,home,launcher,&horizontal);
    if(!SCPVitalsFiniteRect(frame)) {
        if(!self.noSpaceLogged)OMCLogWrite(@"SplitScreen",[NSString stringWithFormat:
           @"[hl50-dock] NO FREE SLOT dock=%@ host=%@ passedDock=%@ items=%lu",
           NSStringFromCGRect(dock.bounds),NSStringFromClass(dock.class),
           NSStringFromCGRect(dockFrame),(unsigned long)dock.subviews.count]);
        self.noSpaceLogged=YES;
        [self stop];return;
    }
    self.noSpaceLogged=NO;
    if(!self.panel || self.panel.superview!=dock) {
        [self stop];
        UIView *panel=[[UIView alloc]initWithFrame:frame];
        panel.backgroundColor=[UIColor colorWithWhite:0 alpha:0.28];
        panel.layer.cornerRadius=6.0;
        panel.clipsToBounds=YES;
        panel.userInteractionEnabled=NO; // fullscreen gestures remain untouched
        UILabel *label=[[UILabel alloc]initWithFrame:CGRectInset(panel.bounds,1,1)];
        label.autoresizingMask=UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        label.numberOfLines=horizontal?1:2;
        label.font=[UIFont systemFontOfSize:horizontal?10.0:9.0 weight:UIFontWeightSemibold];
        label.textAlignment=NSTextAlignmentCenter;
        label.adjustsFontSizeToFitWidth=YES;
        label.minimumScaleFactor=horizontal?0.74:0.65;
        [panel addSubview:label];
        [dock addSubview:panel];
        self.host=dock;self.panel=panel;self.label=label;
        self.horizontal=horizontal;
        [self refresh];
        self.timer=[NSTimer timerWithTimeInterval:12.0 target:self
                selector:@selector(refresh) userInfo:nil repeats:YES];
        [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
    } else {
        self.panel.frame=frame;
        if(self.horizontal!=horizontal) {
            self.horizontal=horizontal;
            self.label.numberOfLines=horizontal?1:2;
            [self refresh];
        }
        [dock bringSubviewToFront:self.panel];
    }
    OMCLogWrite(@"SplitScreen",[NSString stringWithFormat:
        @"[hl50-dock] IN NATIVE DOCK view=%@ frame=%@ dock=%@ window=%@ level=%.0f app=%@",
        NSStringFromClass(dock.class),NSStringFromCGRect(frame),
        NSStringFromCGRect(dock.bounds),NSStringFromClass(dock.window.class),
        dock.window.windowLevel,NSStringFromCGRect(appArea)]);
}

@end
