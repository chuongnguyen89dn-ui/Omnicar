// DuoCar CarPlay read-only battery/temperature presentation.
// No scene, picker, divider, native Dock model, or window-level modifications.
#import "SCPDeviceVitalsHUD.h"
#import "OMCDeviceVitals.h"
#import "SCPShared.h"
#import "SCPVitalsPlacement.h"
#import "SCPThermalAlarm.h" // [hl60] continuous 37C gate
#import "SCPThermalEdgeWarning.h" // [hl61] shared edge warning
#import "SCPFullscreenController.h" // [hl47] hide dock HUD in fullscreen
#import <CoreGraphics/CoreGraphics.h>
#import <math.h>
#import <objc/message.h>
#import <objc/runtime.h>
#import <notify.h>
#import <CoreFoundation/CoreFoundation.h>

@interface SCPDeviceVitalsHUD ()
@property(nonatomic,weak) UIView *host;
@property(nonatomic,strong) UIView *panel;
@property(nonatomic,strong) UILabel *label;
@property(nonatomic,strong) NSTimer *timer;
@property(nonatomic) BOOL horizontal;
@property(nonatomic) BOOL compactBattery;
@property(nonatomic) BOOL noSpaceLogged;
@property(nonatomic) SCPThermalAlarmState thermalGate;
@property(nonatomic,strong) UIWindow *thermalWarningWindow;
@property(nonatomic,weak) UIView *thermalParent;
@property(nonatomic,weak) UIWindow *thermalSourceWindow;
@property(nonatomic,strong) NSTimer *thermalTimer;
@end

@implementation SCPDeviceVitalsHUD

+ (instancetype)shared {
    static SCPDeviceVitalsHUD *instance;
    static dispatch_once_t once;
    dispatch_once(&once, ^{ instance = [SCPDeviceVitalsHUD new]; });
    return instance;
}

// [hl55-thermal] Independent split-mode alert uses a CarPlay display
// root window and PASS-THROUGH hit-test. The fullscreen branch uses the
// existing clock bubble window with the same edge warning.
- (instancetype)init {
    if((self=[super init])) {
        _thermalGate=(SCPThermalAlarmState){0};
        static int thermalTestToken=-1;
        __weak typeof(self) weakSelf=self;
        notify_register_dispatch("com.anlai.omnicar/thermaltest37.changed",
            &thermalTestToken,dispatch_get_main_queue(),^(int token) {
                (void)token;
                CFPreferencesAppSynchronize(CFSTR("com.anlai.omnicar"));
                [weakSelf checkThermalNow];
            });
    }
    return self;
}
static UIView *SCPRedAlertHitTest(UIWindow *window,SEL cmd,CGPoint point,UIEvent *event) {
    (void)window;(void)cmd;(void)point;(void)event;
    return nil; // cannot intercept app, picker, Dock or emergency controls
}
- (void)hideThermalWarning {
    if(self.thermalWarningWindow)
        OMCLogWrite(@"SplitScreen",@"[hl60-thermal] split HIDE");
    self.thermalWarningWindow.hidden=YES;
    self.thermalWarningWindow=nil;
}
- (void)showThermalWarningInParent:(UIView *)parent {
    UIScreen *screen=parent.window.screen;
    if(!screen)return;
    if(self.thermalWarningWindow && self.thermalWarningWindow.screen!=screen)
        [self hideThermalWarning];
    if(self.thermalWarningWindow)return;
    id config=nil;
    SEL displaySel=NSSelectorFromString(@"displayConfiguration");
    if([screen respondsToSelector:displaySel])
        config=((id (*)(id,SEL))objc_msgSend)(screen,displaySel);
    if(!config) {
        SEL sel=NSSelectorFromString(@"_display");
        id display=[screen respondsToSelector:sel]
            ? ((id (*)(id,SEL))objc_msgSend)(screen,sel):nil;
        Class c=objc_getClass("FBSDisplayConfiguration");
        SEL init=NSSelectorFromString(@"initWithCADisplay:isMainDisplay:");
        id fresh=c?[c alloc]:nil;
        if(display && [fresh respondsToSelector:init])
            config=((id (*)(id,SEL,id,BOOL))objc_msgSend)(fresh,init,display,NO);
    }
    Class root=objc_getClass("UIRootSceneWindow");
    SEL sel=NSSelectorFromString(@"initWithDisplayConfiguration:");
    id candidate=root?[root alloc]:nil;
    UIWindow *win=(config && [candidate respondsToSelector:sel])
        ? ((id (*)(id,SEL,id))objc_msgSend)(candidate,sel,config):nil;
    if(![win isKindOfClass:UIWindow.class]){
        OMCLogWrite(@"SplitScreen",@"[hl55-thermal] split alert window unavailable");
        return;
    }
    Class existing=object_getClass(win);
    Class pass=objc_getClass("SCPThermalPassThroughWindow");
    if(!pass) {
        pass=objc_allocateClassPair(existing,"SCPThermalPassThroughWindow",0);
        Method original=class_getInstanceMethod(existing,@selector(hitTest:withEvent:));
        if(!pass || !original || !class_addMethod(pass,@selector(hitTest:withEvent:),
                 (IMP)SCPRedAlertHitTest,method_getTypeEncoding(original))){
            OMCLogWrite(@"SplitScreen",@"[hl55-thermal] pass-through ABI unavailable");
            return;
        }
        objc_registerClassPair(pass);
    }
    object_setClass(win,pass);
    win.windowLevel=UIWindowLevelStatusBar+64.5;
    win.backgroundColor=UIColor.clearColor;
    win.userInteractionEnabled=NO;
    UIView *edgeWarning=SCPThermalEdgeWarningCreate(win.bounds);
    [win addSubview:edgeWarning];
    self.thermalWarningWindow=win;win.hidden=NO;
    OMCLogWrite(@"SplitScreen",@"[hl61-thermal-ui] split EDGE_GLOW_SHOW pass-through");
}

- (void)checkThermalNow {
    UIView *parent=self.thermalParent;
    if(!parent || !parent.window || parent.window!=self.thermalSourceWindow ||
       parent.hidden || parent.window.hidden || parent.alpha<=0.01 ||
       [[SCPFullscreenController shared] fsCommittedState]==SCPFullscreenStateExpanded) {
        [self hideThermalWarning];
        return;
    }
    NSDictionary *sample=OMCDeviceVitalsSample();
    NSNumber *temp=[sample[@"temperatureCelsius"] isKindOfClass:NSNumber.class]
        ?sample[@"temperatureCelsius"]:nil;
    BOOL simulated=[OMCPref(@"duocarThermalTest37Enabled",@NO) boolValue];
    BOOL before=_thermalGate.active,wasSimulated=_thermalGate.simulated;
    BOOL active=SCPThermalAlarmStep(&_thermalGate,
           temp?temp.doubleValue:NAN,temp!=nil,simulated,
           NSDate.date.timeIntervalSince1970);
    if(before!=active || wasSimulated!=simulated)
        OMCLogWrite(@"SplitScreen",[NSString stringWithFormat:
            @"[hl60-thermal] split active=%d simulated=%d raw=%@ source=%@",
            active,simulated,temp?:@"unavailable",
            sample[@"temperatureSource"]?:@"unknown"]);
    if(active)
        [self showThermalWarningInParent:parent];
    else
        [self hideThermalWarning];
}
- (void)startThermalForParent:(UIView *)parent {
    if(self.thermalParent!=parent || self.thermalSourceWindow!=parent.window) {
        [self hideThermalWarning];
        self.thermalParent=parent;
        self.thermalSourceWindow=parent.window;
        self.thermalGate=(SCPThermalAlarmState){0};
    }
    if(!self.thermalTimer) {
        [self checkThermalNow];
        self.thermalTimer=[NSTimer timerWithTimeInterval:3.0
            target:self selector:@selector(checkThermalNow) userInfo:nil repeats:YES];
        [[NSRunLoop mainRunLoop]addTimer:self.thermalTimer forMode:NSRunLoopCommonModes];
    }
}

// Untrusted UIKit geometry is converted only after validating that both
// Dock and app occupy the same actual CarPlay parent coordinate space.
static BOOL SCPVitalsFiniteRect(CGRect r) {
    return !CGRectIsNull(r) && !CGRectIsInfinite(r) && !CGRectIsEmpty(r) &&
        isfinite(r.origin.x) && isfinite(r.origin.y) &&
        isfinite(r.size.width) && isfinite(r.size.height);
}

- (void)stopDockOnly {
    if(self.panel)OMCLogWrite(@"SplitScreen",@"[vitals] car HUD detached");
    [self.timer invalidate];self.timer=nil;
    [self.panel removeFromSuperview];
    self.panel=nil;self.label=nil;self.host=nil;
}
- (void)stop {
    if(![NSThread isMainThread]) {
        dispatch_async(dispatch_get_main_queue(),^{ [self stop]; });
        return;
    }
    [self.thermalTimer invalidate];self.thermalTimer=nil;
    self.thermalParent=nil;self.thermalSourceWindow=nil;
    self.thermalGate=(SCPThermalAlarmState){0};
    [self hideThermalWarning];
    [self stopDockOnly];
}

- (void)refresh {
    if (!self.panel || !self.panel.window) { [self stopDockOnly]; return; }
    if (![OMCPref(@"duocarVitalsEnabled", @YES) boolValue]) { [self stopDockOnly]; return; }

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
    if (self.compactBattery) {
        // [hl51-dock] Collapsed native Dock monitor keeps the battery
        // readable when the remaining rail is too short for two rows.
        self.label.text = [NSString stringWithFormat:@"🔋%@",batteryText];
    } else if (self.horizontal) {
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
// [hl51-dock] A DBAppDockViewController.view bounds rect is the compact
// THREE-APP-ICON CLUSTER (45x111 on Nguyen's 427x240 CarPlay display), NOT
// the whole Dock rail. Do not search only inside it. Scan the actual free
// left/right/top/bottom rail in common parent coordinates, excluding the
// measured icon cluster, Home/launcher, status and native control children.
// Then convert the chosen frame into the genuine native Dock subtree.
static void SCPVitalsBlock(NSMutableArray<NSValue *> *blocked,
                           CGRect rect, CGRect rail,CGFloat pad) {
    if(!SCPVitalsFiniteRect(rect) || !CGRectIntersectsRect(rect,rail))return;
    CGRect grown=CGRectInset(rect,-pad,-pad);
    [blocked addObject:[NSValue valueWithCGRect:grown]];
}
// Explicit screen coordinate conversion is necessary because CarPlay
// split and the stock Dock can belong to DIFFERENT native UIWindows.
static CGRect SCPVitalsConvert(UIView *source,UIView *dest,CGRect rect) {
    if(!source || !dest || !source.window || !dest.window ||
       source.window.screen!=dest.window.screen)return CGRectNull;
    UIScreen *screen=source.window.screen;
    CGRect screenRect=[source convertRect:rect toCoordinateSpace:screen.coordinateSpace];
    if(!SCPVitalsFiniteRect(screenRect))return CGRectNull;
    return [dest convertRect:screenRect fromCoordinateSpace:screen.coordinateSpace];
}
static BOOL SCPVitalsCandidateVisible(UIView *host,UIView *parent,CGRect rect) {
    if(!host || !parent || !host.window || !parent.window ||
       host.window.screen!=parent.window.screen)return NO;
    for(UIView *v=host;v;v=v.superview) {
        if(v.clipsToBounds) {
            CGRect local=SCPVitalsConvert(parent,v,rect);
            if(!SCPVitalsFiniteRect(local) ||
               !CGRectContainsRect(CGRectInset(v.bounds,-0.5,-0.5),local))
                return NO;
        }
        if(v==host.window)break;
    }
    return YES;
}
static UIView *SCPVitalsNativeHostForTarget(UIView *dock,UIView *parent,CGRect target) {
    if(SCPVitalsCandidateVisible(dock,parent,target))return dock;
    // Some native Dock variants clip their tight icon-cluster UIView.
    // An immediate native Dock parent may own the outside-cluster rail.
    // Never create a new window or attach a badge to the split pane.
    UIView *nativeParent=dock.superview;
    if(nativeParent && nativeParent!=dock && nativeParent.window==dock.window &&
       SCPVitalsCandidateVisible(nativeParent,parent,target))
        return nativeParent;
    return nil;
}
static CGRect SCPVitalsDockSlot(UIView *dock,UIView *ignore,UIView *parent,
        CGRect appArea,CGRect cluster,CGRect home,CGRect launcher,
        UIView **hostOut,BOOL *horizontalOut,BOOL *compactOut,
        NSUInteger *obstacleCount) {
    if(hostOut)*hostOut=nil;
    if(horizontalOut)*horizontalOut=NO;
    if(compactOut)*compactOut=NO;
    if(obstacleCount)*obstacleCount=0;
    CGRect root=parent.bounds;
    if(!SCPVitalsFiniteRect(root) || !SCPVitalsFiniteRect(appArea) ||
       !SCPVitalsFiniteRect(cluster))return CGRectNull;
    CGRect overlap=CGRectIntersection(root,appArea);
    if(!SCPVitalsFiniteRect(overlap) ||
       fabs(overlap.size.width-appArea.size.width)>1.0 ||
       fabs(overlap.size.height-appArea.size.height)>1.0)return CGRectNull;
    CGFloat left=CGRectGetMinX(appArea)-CGRectGetMinX(root);
    CGFloat right=CGRectGetMaxX(root)-CGRectGetMaxX(appArea);
    CGFloat top=CGRectGetMinY(appArea)-CGRectGetMinY(root);
    CGFloat bottom=CGRectGetMaxY(root)-CGRectGetMaxY(appArea);
    CGRect rails[4]={
        CGRectMake(CGRectGetMinX(root),CGRectGetMinY(root),left,root.size.height),
        CGRectMake(CGRectGetMaxX(appArea),CGRectGetMinY(root),right,root.size.height),
        CGRectMake(CGRectGetMinX(root),CGRectGetMinY(root),root.size.width,top),
        CGRectMake(CGRectGetMinX(root),CGRectGetMaxY(appArea),root.size.width,bottom)
    };
    // Prefer the rail actually containing the stock Dock icon cluster.
    // This is not a spare 'fourth app' slot.
    // [hl52-dock] The status clock is at the TOP of the CarPlay Dock.
    // Scan BELOW the three recent apps first, never starting at top y=3.
    // If the gap is too short, use the compact battery-only fallback
    // instead of covering the native clock or Home button.
    for(int pass=0;pass<2;pass++) { // normal battery+temperature then compact battery
        for(int k=0;k<4;k++) {
            CGRect rail=rails[k];
            if(!SCPVitalsFiniteRect(rail) ||
               !CGRectIntersectsRect(cluster,rail))continue;
            BOOL horizontal=k>=2;
            CGFloat width=horizontal?MIN(116.0,rail.size.width-6.0)
                                    :MIN(39.0,rail.size.width-6.0);
            CGFloat height=horizontal?(pass?22.0:28.0):(pass?21.0:29.0);
            if(width<(horizontal?70.0:35.0) ||
               height>rail.size.height-6.0)continue;
            NSMutableArray<NSValue *> *blocked=[NSMutableArray array];
            SCPVitalsBlock(blocked,cluster,rail,4.0);
            SCPVitalsBlock(blocked,home,rail,4.0);
            SCPVitalsBlock(blocked,launcher,rail,4.0);
            NSMutableArray<NSValue *> *iconControls=[NSMutableArray array];
            SCPVitalsCollectControls(dock,dock,ignore,iconControls,0);
            for(NSValue *item in iconControls) {
                CGRect screenRect=SCPVitalsConvert(dock,parent,item.CGRectValue);
                SCPVitalsBlock(blocked,screenRect,rail,2.0);
            }
            // Protect a real status-bar view if its frame is a compact
            // control, not a full-screen UIWindow backing surface.
            id dashboard=SCPDashboardRootViewController();
            id statusVC=nil;
            // DuoNavi 1.0.4 resolves both public-ish and private Dock
            // status-bar controller selectors. Use only guarded reads.
            for(NSString *name in @[@"statusBarViewController",
                                    @"_statusBarViewController"]) {
                SEL s=NSSelectorFromString(name);
                if(dashboard && [dashboard respondsToSelector:s]) {
                    statusVC=((id(*)(id,SEL))objc_msgSend)(dashboard,s);
                    if(statusVC)break;
                }
            }
            UIView *status=statusVC && [statusVC respondsToSelector:@selector(view)]
                ? ((UIView*(*)(id,SEL))objc_msgSend)(statusVC,@selector(view)) : nil;
            if(status && status.window && status.window.screen==parent.window.screen) {
                CGRect rect=SCPVitalsConvert(status,parent,status.bounds);
                if(SCPVitalsFiniteRect(rect) &&
                   rect.size.width<=root.size.width*0.6 &&
                   rect.size.height<=root.size.height*0.5)
                    SCPVitalsBlock(blocked,rect,rail,3.0);
            }
            if(obstacleCount)*obstacleCount=blocked.count;
            CGFloat maxX=CGRectGetMaxX(rail)-width-3.0;
            CGFloat maxY=CGRectGetMaxY(rail)-height-3.0;
            // Only the LOWER free gap of a side-rail Dock may receive
            // vitals, never the top native status-clock strip. In the
            // verified 427x240 layout this starts below icon y=175.5.
            CGFloat startY=CGRectGetMinY(rail)+3.0;
            if(!horizontal) startY=MAX(startY,CGRectGetMaxY(cluster)+7.0);
            for(CGFloat y=startY;y<=maxY+0.1;y+=2.0) {
                for(CGFloat x=CGRectGetMinX(rail)+3.0;x<=maxX+0.1;x+=2.0) {
                    CGRect candidate=CGRectMake(x,y,width,height);
                    BOOL occupied=NO;
                    for(NSValue *v in blocked) {
                        if(CGRectIntersectsRect(candidate,v.CGRectValue)){
                            occupied=YES;break;
                        }
                    }
                    if(occupied || CGRectIntersectsRect(candidate,appArea))continue;
                    UIView *host=SCPVitalsNativeHostForTarget(dock,parent,candidate);
                    if(!host)continue;
                    if(horizontalOut)*horizontalOut=horizontal;
                    if(compactOut)*compactOut=(pass==1);
                    if(hostOut)*hostOut=host;
                    return SCPVitalsConvert(parent,host,candidate);
                }
            }
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
       [[SCPFullscreenController shared] fsCommittedState]==SCPFullscreenStateExpanded) {
        [self stop];return;
    }
    [self startThermalForParent:parent];
    if(![OMCPref(@"duocarVitalsEnabled",@YES) boolValue]) {
        [self stopDockOnly];return;
    }
    UIView *dock=SCPVitalsNativeDockView(parent);
    if(!dock) {
        OMCLogWrite(@"SplitScreen",@"[hl50-dock] MISSING native Dock UIView; no fallback to app/root UIWindow");
        [self stopDockOnly];return;
    }
    CGRect observed=SCPVitalsConvert(dock,parent,dock.bounds);
    // The native Dock VC is not always the tight Dock view. A full-screen
    // view with the same window must NEVER become a fake Dock host.
    if(!SCPVitalsFiniteRect(observed) ||
       !SCPVitalsFiniteRect(dockFrame) ||
       fabs(CGRectGetMinX(observed)-CGRectGetMinX(dockFrame))>3.0 ||
       fabs(CGRectGetMinY(observed)-CGRectGetMinY(dockFrame))>3.0 ||
       fabs(CGRectGetWidth(observed)-CGRectGetWidth(dockFrame))>3.0 ||
       fabs(CGRectGetHeight(observed)-CGRectGetHeight(dockFrame))>3.0) {
        OMCLogWrite(@"SplitScreen",[NSString stringWithFormat:
            @"[hl50-dock] dock-view-mismatch observed=%@ measured=%@; REFUSE fallback",
            NSStringFromCGRect(observed),NSStringFromCGRect(dockFrame)]);
        [self stopDockOnly];return;
    }
    BOOL horizontal=NO,compact=NO;
    NSUInteger blocked=0;
    UIView *nativeHost=nil;
    CGRect frame=SCPVitalsDockSlot(dock,self.panel,parent,appArea,observed,
                                  home,launcher,&nativeHost,&horizontal,
                                  &compact,&blocked);
    if(!SCPVitalsFiniteRect(frame) || !nativeHost) {
        if(!self.noSpaceLogged)OMCLogWrite(@"SplitScreen",[NSString stringWithFormat:
           @"[hl51-dock] NO SAFE RAIL screen=%@ app=%@ icons=%@ home=%@ launcher=%@ blockers=%lu clips=%d nativeSuperview=%@",
           NSStringFromCGRect(parent.bounds),NSStringFromCGRect(appArea),
           NSStringFromCGRect(observed),NSStringFromCGRect(home),
           NSStringFromCGRect(launcher),(unsigned long)blocked,
           (int)dock.clipsToBounds,NSStringFromClass(dock.superview.class)]);
        self.noSpaceLogged=YES;
        [self stopDockOnly];return;
    }
    self.noSpaceLogged=NO;
    if(!self.panel || self.panel.superview!=nativeHost) {
        [self stopDockOnly];
        UIView *panel=[[UIView alloc]initWithFrame:frame];
        // [hl52-dock] Native status text directly on Dock: no blurred,
        // grey, translucent or opaque container behind clock/pin/heat.
        panel.backgroundColor=UIColor.clearColor;
        panel.layer.cornerRadius=0.0;
        panel.clipsToBounds=NO;
        panel.userInteractionEnabled=NO; // fullscreen gestures remain untouched
        UILabel *label=[[UILabel alloc]initWithFrame:CGRectInset(panel.bounds,1,1)];
        label.autoresizingMask=UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        label.numberOfLines=(horizontal || compact)?1:2;
        label.font=[UIFont systemFontOfSize:compact?10.0:(horizontal?10.0:9.0) weight:UIFontWeightSemibold];
        label.textAlignment=NSTextAlignmentCenter;
        label.backgroundColor=UIColor.clearColor;
        // Small text shadow retains legibility on the stock dark Dock
        // without any filled rectangle or second overlay/window.
        label.shadowColor=[UIColor colorWithWhite:0 alpha:0.50];
        label.shadowOffset=CGSizeMake(0,0.5);
        label.adjustsFontSizeToFitWidth=YES;
        label.minimumScaleFactor=horizontal?0.74:0.65;
        [panel addSubview:label];
        [nativeHost addSubview:panel];
        self.host=nativeHost;self.panel=panel;self.label=label;
        self.horizontal=horizontal;self.compactBattery=compact;
        [self refresh];
        self.timer=[NSTimer timerWithTimeInterval:12.0 target:self
                selector:@selector(refresh) userInfo:nil repeats:YES];
        [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
    } else {
        self.panel.frame=frame;
        if(self.horizontal!=horizontal || self.compactBattery!=compact) {
            self.horizontal=horizontal;self.compactBattery=compact;
            self.label.numberOfLines=(horizontal || compact)?1:2;
            self.label.font=[UIFont systemFontOfSize:compact?10.0:(horizontal?10.0:9.0) weight:UIFontWeightSemibold];
            [self refresh];
        }
        [nativeHost bringSubviewToFront:self.panel];
    }
    OMCLogWrite(@"SplitScreen",[NSString stringWithFormat:
        @"[hl51-dock] IN NATIVE DOCK SUBTREE host=%@ frame=%@ screenFrame=%@ iconCluster=%@ compact=%d blockers=%lu clips=%d window=%@ level=%.0f app=%@",
        NSStringFromClass(nativeHost.class),NSStringFromCGRect(frame),
        NSStringFromCGRect(SCPVitalsConvert(nativeHost,parent,frame)),
        NSStringFromCGRect(observed),(int)compact,(unsigned long)blocked,
        (int)nativeHost.clipsToBounds,NSStringFromClass(nativeHost.window.class),
        nativeHost.window.windowLevel,NSStringFromCGRect(appArea)]);
}

@end
