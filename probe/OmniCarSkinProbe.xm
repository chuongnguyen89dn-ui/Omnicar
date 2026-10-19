// READ-ONLY native OmniCar UIView/CALayer inspector. Never modify UI.
#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import <Foundation/Foundation.h>
#import <objc/runtime.h>
#import <objc/message.h>
@interface SCPCarSplit:NSObject
- (UIView *)ratioMenu;
- (id)ratioKnob;
- (id)dividers;
- (id)pickerSheet;
- (id)paneAtSlot:(int)slot;
@end
static BOOL PROBEInstalled=NO;
static CFAbsoluteTime PROBELast=0;
static NSString *PROBEUIColor(UIColor *c){
 if(!c)return @"nil";
 CGFloat r=0,g=0,b=0,a=0;
 if([c getRed:&r green:&g blue:&b alpha:&a])
  return [NSString stringWithFormat:@"RGBA(%.6f %.6f %.6f %.6f)",r,g,b,a];
 CGFloat w=0;
 if([c getWhite:&w alpha:&a])
  return [NSString stringWithFormat:@"WHITE(%.6f %.6f)",w,a];
 return @"UNRESOLVED_COLORSPACE";
}
static NSString *PROBECG(CGColorRef c){
 if(!c)return @"nil";
 NSUInteger n=CGColorGetNumberOfComponents(c);
 const CGFloat *p=CGColorGetComponents(c);
 if(n==4&&p)return [NSString stringWithFormat:@"RGBA(%.6f %.6f %.6f %.6f)",p[0],p[1],p[2],p[3]];
 if(n==2&&p)return [NSString stringWithFormat:@"GRAY(%.6f %.6f)",p[0],p[1]];
 return [NSString stringWithFormat:@"COMPONENTS(%lu)",(unsigned long)n];
}
static void PROBELine(NSMutableString *out,NSString *fmt,...){
 va_list args;
 va_start(args,fmt);
 NSString *line=[[NSString alloc]initWithFormat:fmt arguments:args];
 va_end(args);
 [out appendFormat:@"%@\n",line];
}
static id PROBEGet(id obj,SEL sel){
 return obj && [obj respondsToSelector:sel]?((id(*)(id,SEL))objc_msgSend)(obj,sel):nil;
}
static void PROBELayer(CALayer *layer,NSMutableString *out,int depth,NSUInteger *budget){
 if(!layer||depth>5||!*budget)return;
 --*budget;
 PROBELine(out,@"LAYER depth=%d class=%@ frame=%@ bg=%@ border=%@ bw=%.3f radius=%.3f opacity=%.3f shadowOpacity=%.3f",
 depth,NSStringFromClass(layer.class),NSStringFromCGRect(layer.frame),
 PROBECG(layer.backgroundColor),PROBECG(layer.borderColor),
 layer.borderWidth,layer.cornerRadius,layer.opacity,layer.shadowOpacity);
 if([layer isKindOfClass:CAGradientLayer.class]){
  CAGradientLayer *gradient=(CAGradientLayer *)layer;
  NSMutableArray *stops=[NSMutableArray new];
  for(id item in gradient.colors)[stops addObject:PROBECG((__bridge CGColorRef)item)];
  PROBELine(out,@"GRADIENT colors=%@ positions=%@ start=%@ end=%@",
   stops,gradient.locations,NSStringFromCGPoint(gradient.startPoint),
   NSStringFromCGPoint(gradient.endPoint));
 }
 if([layer isKindOfClass:CAShapeLayer.class]){
  CAShapeLayer *shape=(CAShapeLayer *)layer;
  PROBELine(out,@"SHAPE fill=%@ stroke=%@ linewidth=%.3f",
   PROBECG(shape.fillColor),PROBECG(shape.strokeColor),shape.lineWidth);
 }
 for(CALayer *s in layer.sublayers)PROBELayer(s,out,depth+1,budget);
}
static void PROBEView(UIView *view,NSMutableString *out,int depth,NSUInteger *budget){
 if(!view||depth>5||!*budget)return;
 --*budget;
 CGRect f=view.window?[view convertRect:view.bounds toView:view.window]:CGRectNull;
 PROBELine(out,@"VIEW depth=%d class=%@ frame=%@ bounds=%@ windowRect=%@ bg=%@ tint=%@ alpha=%.3f hidden=%d",
 depth,NSStringFromClass(view.class),NSStringFromCGRect(view.frame),
 NSStringFromCGRect(view.bounds),NSStringFromCGRect(f),PROBEUIColor(view.backgroundColor),
 PROBEUIColor(view.tintColor),view.alpha,view.hidden);
 if([view isKindOfClass:UIButton.class]){
  UIButton *b=(UIButton *)view;
  PROBELine(out,@"BUTTON selected=%d enabled=%d highlighted=%d title=%@",
   b.selected,b.enabled,b.highlighted,
   PROBEUIColor([b titleColorForState:UIControlStateNormal]));
 }
 if([view isKindOfClass:UIVisualEffectView.class]){
  UIVisualEffectView *fx=(UIVisualEffectView *)view;
  PROBELine(out,@"BLUR effectClass=%@",fx.effect?NSStringFromClass(fx.effect.class):@"nil");
 }
 NSUInteger n=36;
 PROBELayer(view.layer,out,0,&n);
 for(UIView *child in view.subviews)PROBEView(child,out,depth+1,budget);
}
static void PROBERoot(NSString *name,id obj,NSMutableString *out){
 UIView *v=[obj isKindOfClass:UIView.class]?(UIView *)obj:nil;
 PROBELine(out,@"ROOT name=%@ class=%@",name,v?NSStringFromClass(v.class):@"nil");
 NSUInteger budget=70;
 PROBEView(v,out,0,&budget);
}
// Only inspect this known OmniCar addon hint, never log other app content.
static UIButton *PROBEFindZoom(UIView *v,NSUInteger *budget){
 if(!v||!*budget)return nil;
 --*budget;
 if([v isKindOfClass:UIButton.class] &&
 [((UIButton *)v).accessibilityHint isEqualToString:@"Chạm để phóng to hoặc thu nhỏ toàn bộ giao diện OmniCar"])
  return (UIButton *)v;
 for(UIView *s in v.subviews){
  UIButton *found=PROBEFindZoom(s,budget);
  if(found)return found;
 }
 return nil;
}
static void PROBECapture(SCPCarSplit *split,NSString *reason){
 if(!split)return;
 CFAbsoluteTime now=CFAbsoluteTimeGetCurrent();
 if(![reason isEqualToString:@"menu-open"]&&now-PROBELast<10.0)return;
 PROBELast=now;
 NSMutableString *out=[NSMutableString new];
 PROBELine(out,@"OmniCarSkinProbe START reason=%@ timestamp=%.3f",reason,now+978307200);
 UIView *menu=[split ratioMenu];
 PROBERoot(@"native.ratioMenu",menu,out);
 PROBERoot(@"native.ratioKnob",[split ratioKnob],out);
 id dividers=[split dividers];
 if([dividers isKindOfClass:NSArray.class]){
  NSUInteger n=0;
  for(id divider in (NSArray *)dividers){
   if(n>=4)break;
   PROBERoot([NSString stringWithFormat:@"native.divider%lu.knob",(unsigned long)n],
    PROBEGet(divider,@selector(knob)),out);
   n++;
  }
 }
 for(int i=0;i<3;i++){
  id pane=[split paneAtSlot:i];
  PROBERoot([NSString stringWithFormat:@"native.pane%d.handle",i],
   PROBEGet(pane,@selector(handle)),out);
  PROBERoot([NSString stringWithFormat:@"native.pane%d.bar",i],
   PROBEGet(pane,@selector(bar)),out);
 }
 PROBERoot(@"native.pickerSheet",[split pickerSheet],out);
 NSUInteger budget=1500;
 PROBERoot(@"addon.zoomButton",menu.window?PROBEFindZoom(menu.window,&budget):nil,out);
 PROBELine(out,@"OmniCarSkinProbe END");
 NSString *path=@"/var/mobile/Documents/OmniCarSkinProbe.txt";
 NSError *error=nil;
 BOOL saved=[out writeToFile:path atomically:YES encoding:NSUTF8StringEncoding error:&error];
 NSLog(@"[OmniCarSkinProbe] saved=%d path=%@ error=%@",saved,path,error);
 for(NSString *line in [out componentsSeparatedByString:@"\n"])
  if(line.length)NSLog(@"[OmniCarSkinProbe] %@",line);
}
static void PROBESchedule(SCPCarSplit *split,NSString *reason){
 __weak SCPCarSplit *weak=split;
 dispatch_after(dispatch_time(DISPATCH_TIME_NOW,(int64_t)(0.3*NSEC_PER_SEC)),
  dispatch_get_main_queue(),^{
   SCPCarSplit *strong=weak;
   if(strong)PROBECapture(strong,reason);
  });
}
%group ProbeNative
%hook SCPCarSplit
- (void)showRatioMenuForDivider:(id)divider{
 %orig;
 (void)divider;
 PROBESchedule((SCPCarSplit *)self,@"menu-open");
}
- (void)layoutBarForPane:(id)pane{
 %orig;
 (void)pane;
 PROBESchedule((SCPCarSplit *)self,@"pane-bar");
}
%end
%end
static void PROBEInstall(NSUInteger retry){
 if(PROBEInstalled)return;
 if(!NSClassFromString(@"SCPCarSplit")){
  if(retry<40)dispatch_after(dispatch_time(DISPATCH_TIME_NOW,(int64_t)(0.5*NSEC_PER_SEC)),
   dispatch_get_main_queue(),^{PROBEInstall(retry+1);});
  return;
 }
 %init(ProbeNative);
 PROBEInstalled=YES;
 NSLog(@"[OmniCarSkinProbe] READ_ONLY_HOOKS_INSTALLED");
}
%ctor{
 @autoreleasepool {
  NSString *bundle=NSBundle.mainBundle.bundleIdentifier.lowercaseString?:@"";
  if([bundle isEqualToString:@"com.apple.carplayapp"]||
     [bundle isEqualToString:@"com.apple.springboard"])
   dispatch_async(dispatch_get_main_queue(),^{PROBEInstall(0);});
 }
}
