// Real native controls from OmniCar 1.0.3. Independent Graphite Titanium addon.
// Change appearance only: never touch scene frames, callbacks, dock or app content.
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>
#import <objc/runtime.h>
#import <objc/message.h>
#import <math.h>
static UIColor *OMTC(int r,int g,int b,CGFloat a) {
 return [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a];
}
static UIColor *OMTGraphite(void){return OMTC(23,27,34,.96);} // #171B22
static UIColor *OMTGunmetal(void){return OMTC(53,61,70,.98);} // #353D46
static UIColor *OMTTitanium(void){return OMTC(181,189,197,1);} // #B5BDC5
static UIColor *OMTIce(void){return OMTC(120,185,200,1);} // #78B9C8
static UIColor *OMTText(void){return OMTC(243,245,245,1);} // #F3F5F5
static char kOMTLayerKey;
static UIView *OMTView(id o){return [o isKindOfClass:UIView.class]?(UIView*)o:nil;}
static id OMTGet(id o,SEL sel) {
 return o && [o respondsToSelector:sel] ? ((id(*)(id,SEL))objc_msgSend)(o,sel):nil;
}
static void OMTGradients(CALayer *l,NSUInteger depth) {
 if(!l || depth>3) return;
 for(CALayer *s in l.sublayers){
  if([s isKindOfClass:CAGradientLayer.class]){
   CAGradientLayer *g=(CAGradientLayer *)s;
   g.colors=@[(__bridge id)OMTGunmetal().CGColor,(__bridge id)OMTGraphite().CGColor];
   g.startPoint=CGPointMake(0,0);g.endPoint=CGPointMake(1,1);
  }
  OMTGradients(s,depth+1);
 }
}
static void OMTChildren(UIView *v,NSUInteger depth){
 if(!v || depth>4)return;
 for(UIView *s in v.subviews){
  if([s isKindOfClass:UILabel.class]) ((UILabel *)s).textColor=OMTText();
  if([s isKindOfClass:UIButton.class]){
   UIButton *b=(UIButton *)s;
   b.tintColor=b.selected?OMTIce():OMTTitanium();
   [b setTitleColor:b.selected?OMTIce():OMTText() forState:UIControlStateNormal];
  }
  // Do not tint UIImageViews: photos, app artwork and map/video remain original.
  OMTChildren(s,depth+1);
 }
}
static void OMTSurface(UIView *v,BOOL compact){
 if(!v)return;
 // Only views returned by OmniCar's verified UI properties reach here.
 v.backgroundColor=OMTGraphite();
 v.tintColor=OMTTitanium();
 CGFloat height=CGRectGetHeight(v.bounds);
 if(height>0) v.layer.cornerRadius=compact?MIN(height*.5,15):MIN(height*.28,18);
 v.layer.borderWidth=compact?.9:1.15;
 v.layer.borderColor=OMTTitanium().CGColor;
 CAGradientLayer *g=objc_getAssociatedObject(v,&kOMTLayerKey);
 if(!g){
  g=[CAGradientLayer layer];g.startPoint=CGPointMake(0,0);
  g.endPoint=CGPointMake(1,1);
  [v.layer insertSublayer:g atIndex:0];
  objc_setAssociatedObject(v,&kOMTLayerKey,g,OBJC_ASSOCIATION_RETAIN_NONATOMIC);
 }
 g.frame=v.layer.bounds;g.cornerRadius=v.layer.cornerRadius;
 g.colors=@[(__bridge id)OMTGunmetal().CGColor,(__bridge id)OMTGraphite().CGColor];
 OMTGradients(v.layer,0);
 OMTChildren(v,0);
 // No clip/hidden/gesture/frame/action/timer modifications.
}
static void OMTDivider(id divider) {
 if(!divider)return;
 OMTSurface(OMTView(OMTGet(divider,@selector(knob))),YES);
}
static void OMTPane(id pane){
 if(!pane)return;
 OMTSurface(OMTView(OMTGet(pane,@selector(handle))),YES);
 OMTSurface(OMTView(OMTGet(pane,@selector(bar))),YES);
}
@interface SCPCarSplit:NSObject
- (UIView *)ratioMenu;
- (id)ratioKnob;
- (id)dividers;
- (id)homeButton;
- (id)pickerSheet;
- (id)paneAtSlot:(int)slot;
@end
static void OMTUpdate(SCPCarSplit *s){
 if(!s)return;
 OMTSurface(OMTView([s ratioMenu]),NO);
 OMTSurface(OMTView([s ratioKnob]),YES);
 id ds=[s dividers];
 if([ds isKindOfClass:NSArray.class])for(id d in (NSArray*)ds)OMTDivider(d);
 for(int slot=0;slot<3;slot++)OMTPane([s paneAtSlot:slot]);
 OMTSurface(OMTView([s homeButton]),YES);
 OMTSurface(OMTView([s pickerSheet]),NO);
}
%group OMTSplit
%hook SCPCarSplit
- (id)newDividerAt:(int)index {
 id d=%orig;
 OMTDivider(d);
 return d;
}
- (void)showRatioMenuForDivider:(id)divider {
 %orig;
 OMTUpdate((SCPCarSplit *)self);
 OMTDivider(divider);
 NSLog(@"[OmniCarTitanium] native-ratio-menu-styled");
}
- (void)setupBarForPane:(id)pane {
 %orig;
 OMTPane(pane);
}
- (void)layoutBarForPane:(id)pane {
 %orig;
 OMTPane(pane);
}
- (void)setBarVisible:(BOOL)visible forPane:(id)pane {
 %orig;
 if(visible) OMTPane(pane);
}
- (void)refreshHomeButton {
 %orig;
 OMTSurface(OMTView([(SCPCarSplit *)self homeButton]),YES);
}
- (void)refreshPickerSheet {
 %orig;
 OMTSurface(OMTView([(SCPCarSplit *)self pickerSheet]),NO);
}
- (void)rootDidLayout {
 %orig;
 OMTUpdate((SCPCarSplit *)self);
}
%end
%end
static BOOL OMTInstalled=NO;
static void OMTInstall(NSUInteger n){
 if(OMTInstalled)return;
 if(!NSClassFromString(@"SCPCarSplit")){
  if(n<40)dispatch_after(dispatch_time(DISPATCH_TIME_NOW,500*NSEC_PER_MSEC),
     dispatch_get_main_queue(),^{OMTInstall(n+1);});
  else NSLog(@"[OmniCarTitanium] FAILED no-native-class");
  return;
 }
 %init(OMTSplit);
 OMTInstalled=YES;
 NSLog(@"[OmniCarTitanium] native-skin-installed palette=171B22-353D46-B5BDC5-78B9C8-F3F5F5");
}
%ctor {
 @autoreleasepool {
  NSString *bid=NSBundle.mainBundle.bundleIdentifier.lowercaseString?:@"";
  if([bid isEqualToString:@"com.apple.carplayapp"] ||
     [bid isEqualToString:@"com.apple.springboard"])
   dispatch_async(dispatch_get_main_queue(),^{OMTInstall(0);});
 }
}
