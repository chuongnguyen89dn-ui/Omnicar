// Graphite Titanium: real native COLOR-ONLY theme mapped to original OmniCar 1.0.3.
// Original ARM64 audit: colorWithRed:green:blue:alpha: -> tint, bar, picker
// and native conic CAGradientLayer / CAShapeLayer ownership.
// NEVER change frame, bounds, transform, cornerRadius, borderWidth, geometry,
// hit area, action, timer, original Home/logo, dock or any hosted app scene.
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>
#import <objc/runtime.h>
#import <objc/message.h>
#import <math.h>

typedef NS_ENUM(NSUInteger, OMTColorRole) {
    OMTColorRoleSurface, OMTColorRoleGradient, OMTColorRoleInk,
    OMTColorRoleOutline, OMTColorRoleShadow
};
static UIColor *OMTRGB(int r,int g,int b,CGFloat a) {
    return [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a];
}
static UIColor *OMTGraphite(CGFloat a){return OMTRGB(23,27,34,a);}    // #171B22
static UIColor *OMTGunmetal(CGFloat a){return OMTRGB(53,61,70,a);}   // #353D46
static UIColor *OMTTitanium(CGFloat a){return OMTRGB(181,189,197,a);} // #B5BDC5
static UIColor *OMTIce(CGFloat a){return OMTRGB(120,185,200,a);}     // #78B9C8
static UIColor *OMTText(CGFloat a){return OMTRGB(243,245,245,a);}    // #F3F5F5
static BOOL OMTMatch(int r,int g,int b,int R,int G,int B) {
    return abs(r-R)<=2 && abs(g-G)<=2 && abs(b-B)<=2;
}

// Source palette recovered from the ORIGINAL binary's UIKit constructors.
// This is an explicit per-color translation table, not a new gradient overlay.
// Unknown/native semantic colors (including red danger) are kept intact.
static UIColor *OMTTranslate(UIColor *original,OMTColorRole role){
    if(!original)return nil;
    CGFloat r=0,g=0,b=0,a=0;
    if(![original getRed:&r green:&g blue:&b alpha:&a] || a<=0)return nil;
    int R=(int)lround(r*255),G=(int)lround(g*255),B=(int)lround(b*255);
    // Original dark lavender RGB(74,79,128): native menu tint/pane bar.
    if(OMTMatch(R,G,B,74,79,128))
        return role==OMTColorRoleSurface||role==OMTColorRoleGradient
            ?OMTGunmetal(a):OMTTitanium(a);
    // Original purple RGB(110,100,200): divider/picker accents and shadows.
    if(OMTMatch(R,G,B,110,100,200))return OMTIce(a);
    // Original conic four-/five-stop selector gradient, traced at 0x3063c-0x30784.
    if(OMTMatch(R,G,B,167,139,250))return OMTGunmetal(a);
    if(OMTMatch(R,G,B,96,197,250))return OMTGraphite(a);
    if(OMTMatch(R,G,B,94,221,182))return OMTGunmetal(a);
    if(OMTMatch(R,G,B,245,154,192))return OMTGraphite(a);
    // Original violet border/shadow RGB(155,135,248).
    if(OMTMatch(R,G,B,155,135,248))return OMTTitanium(a);
    // Original pale control/background/label pigments.
    if(OMTMatch(R,G,B,238,240,251) || OMTMatch(R,G,B,232,234,250))
        return role==OMTColorRoleInk?OMTText(a):OMTGunmetal(a);
    if(OMTMatch(R,G,B,93,180,246)||OMTMatch(R,G,B,110,120,255))
        return OMTIce(a);
    // Native translucent white panel surfaces (white .35/.55/.95):
    // ONLY remap actual OmniCar-owned background/gradient, never white icons.
    if(R>=248&&G>=248&&B>=248) {
        if(role==OMTColorRoleSurface||role==OMTColorRoleGradient)
            return OMTGraphite(a);
        if(role==OMTColorRoleOutline)return OMTTitanium(a);
    }
    if(R<=12&&G<=12&&B<=12&&role==OMTColorRoleInk)
        return OMTText(a); // Legible native dark glyph on new dark menu.
    // Original safety/dismiss red RGB(255,90,95) intentionally unchanged.
    return nil;
}
static UIColor *OMTFromCG(CGColorRef color,OMTColorRole role){
    if(!color)return nil;
    return OMTTranslate([UIColor colorWithCGColor:color],role);
}
static BOOL OMTThemeLayer(CALayer *layer,NSUInteger depth,NSUInteger *budget){
    if(!layer||depth>6||!*budget)return NO;
    --*budget;
    BOOL changed=NO;
    UIColor *color=OMTFromCG(layer.backgroundColor,OMTColorRoleSurface);
    if(color){layer.backgroundColor=color.CGColor;changed=YES;}
    color=OMTFromCG(layer.borderColor,OMTColorRoleOutline);
    if(color){layer.borderColor=color.CGColor;changed=YES;}
    color=OMTFromCG(layer.shadowColor,OMTColorRoleShadow);
    if(color){layer.shadowColor=color.CGColor;changed=YES;}
    if([layer isKindOfClass:[CAGradientLayer class]]){
        CAGradientLayer *gradient=(CAGradientLayer *)layer;
        NSMutableArray *existing=[[gradient colors] mutableCopy];
        if(existing.count){
            BOOL stopChanged=NO;
            for(NSUInteger i=0;i<existing.count;i++){
                UIColor *mapped=OMTFromCG((__bridge CGColorRef)existing[i],
                                         OMTColorRoleGradient);
                if(mapped){
                    existing[i]=(__bridge id)mapped.CGColor;
                    stopChanged=YES;
                }
            }
            if(stopChanged){gradient.colors=existing;changed=YES;}
        }
        // Preserve gradient TYPE (including original CONIC), locations,
        // startPoint, endPoint, frame and original compositing order.
    }
    if([layer isKindOfClass:[CAShapeLayer class]]){
        CAShapeLayer *shape=(CAShapeLayer *)layer;
        color=OMTFromCG(shape.fillColor,OMTColorRoleSurface);
        if(color){shape.fillColor=color.CGColor;changed=YES;}
        color=OMTFromCG(shape.strokeColor,OMTColorRoleInk);
        if(color){shape.strokeColor=color.CGColor;changed=YES;}
        // Do not alter path, lineWidth, stroke alignment, or hit geometry.
    }
    for(CALayer *sub in layer.sublayers)
        changed=OMTThemeLayer(sub,depth+1,budget)||changed;
    return changed;
}
static BOOL OMTThemeView(UIView *view,NSUInteger depth,NSUInteger *viewBudget){
    if(!view||depth>6||!*viewBudget)return NO;
    --*viewBudget;
    // Do not descend into window, scene hosts or web/render surfaces.
    if([view isKindOfClass:[UIWindow class]] ||
       [view isKindOfClass:NSClassFromString(@"WKWebView")] ||
       [view isKindOfClass:NSClassFromString(@"SBSceneView")])return NO;
    BOOL changed=NO;
    UIColor *color=OMTTranslate(view.backgroundColor,OMTColorRoleSurface);
    if(color){view.backgroundColor=color;changed=YES;}
    color=OMTTranslate(view.tintColor,OMTColorRoleInk);
    if(color){view.tintColor=color;changed=YES;}
    if([view isKindOfClass:[UILabel class]]){
        UILabel *label=(UILabel *)view;
        color=OMTTranslate(label.textColor,OMTColorRoleInk);
        if(color){label.textColor=color;changed=YES;}
    } else if([view isKindOfClass:[UIButton class]]){
        UIButton *button=(UIButton *)view;
        for(NSUInteger state=UIControlStateNormal;state<=UIControlStateDisabled;state++){
            color=OMTTranslate([button titleColorForState:state],OMTColorRoleInk);
            if(color){[button setTitleColor:color forState:state];changed=YES;}
        }
        // Images themselves are NOT repainted, only existing native tint colors.
    }
    NSUInteger layerBudget=70;
    changed=OMTThemeLayer(view.layer,0,&layerBudget)||changed;
    for(UIView *sub in view.subviews){
        // Preserve native application icon and independently owned app content.
        if([sub isKindOfClass:[UIImageView class]])continue;
        changed=OMTThemeView(sub,depth+1,viewBudget)||changed;
    }
    return changed;
}
static UIView *OMTAsView(id object){
    return [object isKindOfClass:[UIView class]]?(UIView *)object:nil;
}
static id OMTGet(id obj,SEL selector){
    return obj && [obj respondsToSelector:selector]
        ?((id(*)(id,SEL))objc_msgSend)(obj,selector):nil;
}
static NSUInteger OMTColorNativeRoot(id value){
    UIView *root=OMTAsView(value);
    if(!root)return 0;
    NSUInteger budget=150;
    return OMTThemeView(root,0,&budget)?1:0;
}
static void OMTThemePane(id pane){
    OMTColorNativeRoot(OMTGet(pane,@selector(handle)));
    OMTColorNativeRoot(OMTGet(pane,@selector(bar)));
}
static void OMTThemeDivider(id divider){
    OMTColorNativeRoot(OMTGet(divider,@selector(knob)));
}
@interface SCPCarSplit : NSObject
- (UIView *)ratioMenu;
- (id)dividers;
- (id)pickerSheet;
- (id)paneAtSlot:(int)slot;
@end
static void OMTThemeSplit(SCPCarSplit *split){
    if(!split)return;
    // Exactly the native menu/pane UI owners confirmed by original method calls.
    NSUInteger changed=OMTColorNativeRoot([split ratioMenu]);
    id dividers=[split dividers];
    if([dividers isKindOfClass:[NSArray class]])
        for(id divider in (NSArray *)dividers)OMTThemeDivider(divider);
    for(int slot=0;slot<3;slot++)OMTThemePane([split paneAtSlot:slot]);
    OMTColorNativeRoot([split pickerSheet]);
    if(changed)NSLog(@"[OmniCarTitanium] colors=original-layers menu=changed");
}
%group OMTSplit
%hook SCPCarSplit
- (id)newDividerAt:(int)index{
    id divider=%orig;
    OMTThemeDivider(divider);
    return divider;
}
- (void)showRatioMenuForDivider:(id)divider{
    %orig;
    OMTThemeSplit((SCPCarSplit *)self);
    OMTThemeDivider(divider);
}
- (void)setupBarForPane:(id)pane{
    %orig;
    OMTThemePane(pane);
}
- (void)layoutBarForPane:(id)pane{
    %orig;
    OMTThemePane(pane);
}
- (void)setBarVisible:(BOOL)visible forPane:(id)pane{
    %orig;
    if(visible)OMTThemePane(pane);
}
- (void)refreshPickerSheet{
    %orig;
    OMTColorNativeRoot([(SCPCarSplit *)self pickerSheet]);
}
- (void)rootDidLayout{
    %orig;
    OMTThemeSplit((SCPCarSplit *)self);
}
%end
%end
static BOOL OMTInstalled=NO;
static void OMTInstall(NSUInteger retry){
    if(OMTInstalled)return;
    if(!NSClassFromString(@"SCPCarSplit")){
        if(retry<40)
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW,(int64_t)(0.5*NSEC_PER_SEC)),
            dispatch_get_main_queue(),^{OMTInstall(retry+1);});
        return;
    }
    %init(OMTSplit);
    OMTInstalled=YES;
    NSLog(@"[OmniCarTitanium] source-only original-palette scoped hooks installed");
}
%ctor{
    @autoreleasepool{
        NSString *bundle=NSBundle.mainBundle.bundleIdentifier.lowercaseString?:@"";
        if([bundle isEqualToString:@"com.apple.carplayapp"] ||
           [bundle isEqualToString:@"com.apple.springboard"])
            dispatch_async(dispatch_get_main_queue(),^{OMTInstall(0);});
    }
}
