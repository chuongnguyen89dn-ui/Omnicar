// Native OWNED UI only: independently traced original class/method signatures.
// AppBridge ABHost builds the bar; Speed SPPBubbleView renders its native view;
// Startup SSStartupView builds its own scenes. No hooks to UIKit/global windows.
// COLOR ONLY. Dynamic alert thresholds and photos/video remain untouched.
#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import <Foundation/Foundation.h>
#import <objc/runtime.h>
#import <objc/message.h>
#import <math.h>
#import <stdlib.h>

typedef NS_ENUM(NSUInteger, OMTFeature){
 OMTFeatureAppBridge,OMTFeatureSpeedBubble,OMTFeatureStartup
};
typedef NS_ENUM(NSUInteger, OMTPaintRole){
 OMTPaintSurface,OMTPaintGradient,OMTPaintForeground,OMTPaintOutline,OMTPaintShadow
};
static UIColor *OMTFColor(int r,int g,int b,CGFloat a){
 return [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a];
}
static BOOL OMTFMatch(int r,int g,int b,int a,int d,int c){
 return abs(r-a)<=2 && abs(g-d)<=2 && abs(b-c)<=2;
}
static UIColor *OMTFTranslate(UIColor *original,OMTFeature feature,OMTPaintRole role){
 if(!original)return nil;
 CGFloat rf=0,gf=0,bf=0,alpha=0;
 if(![original getRed:&rf green:&gf blue:&bf alpha:&alpha]||alpha<=0)return nil;
 int r=(int)lround(rf*255),g=(int)lround(gf*255),b=(int)lround(bf*255);
 // Shared ORIGINAL OmniCar toolbar icon (74,79,128), accents, highlight.
 if(OMTFMatch(r,g,b,74,79,128))
  return role==OMTPaintSurface||role==OMTPaintGradient ?
    OMTFColor(53,61,70,alpha):OMTFColor(181,189,197,alpha);
 if(OMTFMatch(r,g,b,110,100,200)||OMTFMatch(r,g,b,93,180,246))
  return OMTFColor(120,185,200,alpha);
 if(OMTFMatch(r,g,b,155,135,248)||OMTFMatch(r,g,b,167,139,250))
  return role==OMTPaintGradient||role==OMTPaintSurface?
    OMTFColor(53,61,70,alpha):OMTFColor(181,189,197,alpha);
 if(OMTFMatch(r,g,b,96,197,250))
  return role==OMTPaintGradient?OMTFColor(23,27,34,alpha):
    OMTFColor(120,185,200,alpha);
 if(OMTFMatch(r,g,b,232,234,250)||OMTFMatch(r,g,b,238,240,251))
  return role==OMTPaintForeground?OMTFColor(243,245,245,alpha):
    OMTFColor(53,61,70,alpha);
 // SpeedBubble green is part of sign/state logic: NEVER neutralize it.
 // Native warning red, orange, gold and speed-limit semantic colors untouched.
 if(feature==OMTFeatureSpeedBubble)return nil;
 if(feature==OMTFeatureAppBridge){
  if(r>=248&&g>=248&&b>=248 &&
     (role==OMTPaintSurface||role==OMTPaintGradient))
   return OMTFColor(23,27,34,alpha);
  if(r>=248&&g>=248&&b>=248 && role==OMTPaintOutline)
   return OMTFColor(181,189,197,alpha);
 }
 if(feature==OMTFeatureStartup){
  // Original startup decorative sky/engine/HUD blue families.
  if(OMTFMatch(r,g,b,60,90,200)||OMTFMatch(r,g,b,40,60,110))
   return OMTFColor(53,61,70,alpha);
  if(OMTFMatch(r,g,b,160,210,255)||OMTFMatch(r,g,b,120,220,255))
   return OMTFColor(120,185,200,alpha);
  if(OMTFMatch(r,g,b,170,235,255))
   return OMTFColor(181,189,197,alpha);
  // Do NOT recolor white typography, gold decorative content, uploaded photos.
 }
 return nil;
}
static UIColor *OMTFCG(CGColorRef color,OMTFeature feature,OMTPaintRole role){
 return color?OMTFTranslate([UIColor colorWithCGColor:color],feature,role):nil;
}
static void OMTFPaintLayer(CALayer *layer,OMTFeature feature,NSUInteger depth,NSUInteger *limit){
 if(!layer||depth>6||!*limit)return;
 --*limit;
 UIColor *mapped=OMTFCG(layer.backgroundColor,feature,OMTPaintSurface);
 if(mapped)layer.backgroundColor=mapped.CGColor;
 mapped=OMTFCG(layer.borderColor,feature,OMTPaintOutline);
 if(mapped)layer.borderColor=mapped.CGColor;
 mapped=OMTFCG(layer.shadowColor,feature,OMTPaintShadow);
 if(mapped)layer.shadowColor=mapped.CGColor;
 if([layer isKindOfClass:[CAGradientLayer class]]){
  CAGradientLayer *grad=(CAGradientLayer *)layer;
  NSMutableArray *colors=[[grad colors] mutableCopy];
  BOOL changed=NO;
  for(NSUInteger i=0;i<colors.count;i++){
   mapped=OMTFCG((__bridge CGColorRef)colors[i],feature,OMTPaintGradient);
   if(mapped){colors[i]=(__bridge id)mapped.CGColor;changed=YES;}
  }
  if(changed)grad.colors=colors;
  // Native gradient type, location, geometry and compositing order untouched.
 }
 if([layer isKindOfClass:[CAShapeLayer class]]){
  CAShapeLayer *shape=(CAShapeLayer *)layer;
  mapped=OMTFCG(shape.fillColor,feature,OMTPaintSurface);
  if(mapped)shape.fillColor=mapped.CGColor;
  mapped=OMTFCG(shape.strokeColor,feature,OMTPaintForeground);
  if(mapped)shape.strokeColor=mapped.CGColor;
 }
 for(CALayer *sub in layer.sublayers)OMTFPaintLayer(sub,feature,depth+1,limit);
}
static void OMTFPaintView(UIView *view,OMTFeature feature,NSUInteger depth,NSUInteger *limit){
 if(!view||depth>5||!*limit)return;
 if([view isKindOfClass:[UIWindow class]] ||
    [view isKindOfClass:NSClassFromString(@"WKWebView")] ||
    [view isKindOfClass:NSClassFromString(@"SBSceneView")])return;
 // Hard exclusion: app preview content and native speed-limit sign itself.
 if([view isKindOfClass:[UIImageView class]])return;
 if(feature==OMTFeatureSpeedBubble &&
    [view isKindOfClass:NSClassFromString(@"SPPSignView")])return;
 --*limit;
 UIColor *mapped=OMTFTranslate(view.backgroundColor,feature,OMTPaintSurface);
 if(mapped)view.backgroundColor=mapped;
 mapped=OMTFTranslate(view.tintColor,feature,OMTPaintForeground);
 if(mapped)view.tintColor=mapped;
 if([view isKindOfClass:[UILabel class]]){
  UILabel *label=(UILabel *)view;
  mapped=OMTFTranslate(label.textColor,feature,OMTPaintForeground);
  if(mapped)label.textColor=mapped;
 }
 NSUInteger layers=100;
 OMTFPaintLayer(view.layer,feature,0,&layers);
 for(UIView *sub in view.subviews)OMTFPaintView(sub,feature,depth+1,limit);
}
static void OMTFPaint(id candidate,OMTFeature feature){
 if(![candidate isKindOfClass:[UIView class]])return;
 NSUInteger budget=180;
 OMTFPaintView((UIView *)candidate,feature,0,&budget);
}
static id OMTFGet(id obj,SEL sel){
 return obj&&[obj respondsToSelector:sel]?
     ((id(*)(id,SEL))objc_msgSend)(obj,sel):nil;
}
// Original ABHost -buildBarForPane: is ObjC '@24@0:8@16' (returns object).
%group OMTFeatureBridge
%hook ABHost
- (id)buildBarForPane:(id)pane{
 id bar=%orig;
 OMTFPaint(OMTFGet(pane,@selector(bar)),OMTFeatureAppBridge);
 OMTFPaint(bar,OMTFeatureAppBridge);
 return bar;
}
- (void)layoutBarForPane:(id)pane{
 %orig;
 OMTFPaint(OMTFGet(pane,@selector(bar)),OMTFeatureAppBridge);
}
- (void)setupHandleForPane:(id)pane{
 %orig;
 OMTFPaint(OMTFGet(pane,@selector(handle)),OMTFeatureAppBridge);
}
%end
%hook ABKeyboard
- (void)buildPanel{
 %orig;
 OMTFPaint(OMTFGet(self,@selector(panel)),OMTFeatureAppBridge);
 OMTFPaint(OMTFGet(self,@selector(glass)),OMTFeatureAppBridge);
}
%end
%end

// Original SPPBubbleView -buildStyle: uses ObjC 'v24@0:8q16'.
%group OMTFeatureSpeed
%hook SPPBubbleView
- (void)buildStyle:(long long)style{
 %orig;
 OMTFPaint(self,OMTFeatureSpeedBubble);
}
- (void)renderStyle{
 %orig;
 OMTFPaint(self,OMTFeatureSpeedBubble);
}
%end
%end

// Native startup owns splash/gauge/sky gradients, not Apple CarPlay content.
%group OMTFeatureStartupGroup
%hook SSStartupView
- (void)ss_buildScene{
 %orig;
 OMTFPaint(self,OMTFeatureStartup);
}
- (void)layoutSubviews{
 %orig;
 OMTFPaint(self,OMTFeatureStartup);
}
%end
%end

static BOOL OMTFBridgeInstalled=NO;
static BOOL OMTFSpeedInstalled=NO;
static BOOL OMTFStartupInstalled=NO;
static void OMTFInstall(NSUInteger tries){
 if(!OMTFBridgeInstalled && NSClassFromString(@"ABHost") &&
     NSClassFromString(@"ABKeyboard")){
  %init(OMTFeatureBridge);
  OMTFBridgeInstalled=YES;
  NSLog(@"[OmniCarTitanium] colors=AppBridge owners-found");
 }
 if(!OMTFSpeedInstalled && NSClassFromString(@"SPPBubbleView")){
  %init(OMTFeatureSpeed);
  OMTFSpeedInstalled=YES;
  NSLog(@"[OmniCarTitanium] colors=SpeedBubble owner-found");
 }
 if(!OMTFStartupInstalled && NSClassFromString(@"SSStartupView")){
  %init(OMTFeatureStartupGroup);
  OMTFStartupInstalled=YES;
  NSLog(@"[OmniCarTitanium] colors=StartupScreen owner-found");
 }
 if(tries<40 && (!OMTFBridgeInstalled||!OMTFSpeedInstalled||!OMTFStartupInstalled))
  dispatch_after(dispatch_time(DISPATCH_TIME_NOW,(int64_t)(0.5*NSEC_PER_SEC)),
    dispatch_get_main_queue(),^{OMTFInstall(tries+1);});
}
%ctor{
 @autoreleasepool{
  NSString *bundle=NSBundle.mainBundle.bundleIdentifier.lowercaseString?:@"";
  if([bundle isEqualToString:@"com.apple.carplayapp"]||
     [bundle isEqualToString:@"com.apple.springboard"])
   dispatch_async(dispatch_get_main_queue(),^{OMTFInstall(0);});
 }
}
