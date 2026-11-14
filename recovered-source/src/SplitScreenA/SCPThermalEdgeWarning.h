#ifndef SCP_THERMAL_EDGE_WARNING_H
#define SCP_THERMAL_EDGE_WARNING_H
#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import <math.h>

// HL61: our own UIKit rendition of a glowing edge warning, NOT vendor code.
// No full-screen red fill, no touch interception, no extra UIWindow.
static inline UIView *SCPThermalEdgeWarningCreate(CGRect bounds) {
    UIView *surface=[[UIView alloc]initWithFrame:bounds];
    surface.backgroundColor=UIColor.clearColor;
    surface.opaque=NO;
    surface.autoresizingMask=UIViewAutoresizingFlexibleWidth|
                              UIViewAutoresizingFlexibleHeight;
    surface.userInteractionEnabled=NO;

    UIView *outer=[[UIView alloc]initWithFrame:CGRectInset(surface.bounds,5.0,5.0)];
    outer.autoresizingMask=UIViewAutoresizingFlexibleWidth|
                            UIViewAutoresizingFlexibleHeight;
    outer.backgroundColor=UIColor.clearColor;
    outer.userInteractionEnabled=NO;
    outer.layer.cornerRadius=15.0;
    outer.layer.borderWidth=7.0;
    UIColor *red=[UIColor colorWithRed:1.0 green:0.025 blue:0.065 alpha:0.96];
    outer.layer.borderColor=red.CGColor;
    outer.layer.shadowColor=red.CGColor;
    outer.layer.shadowOpacity=0.94;
    outer.layer.shadowRadius=12.0;
    outer.layer.shadowOffset=CGSizeZero;
    [surface addSubview:outer];
    CABasicAnimation *pulse=[CABasicAnimation animationWithKeyPath:@"opacity"];
    pulse.fromValue=@0.45;
    pulse.toValue=@1.0;
    pulse.autoreverses=YES;
    pulse.duration=0.75;
    pulse.repeatCount=HUGE_VALF;
    [outer.layer addAnimation:pulse forKey:@"hl61-thermal-edge-glow"];

    UIView *inner=[[UIView alloc]initWithFrame:CGRectInset(surface.bounds,12.0,12.0)];
    inner.autoresizingMask=UIViewAutoresizingFlexibleWidth|
                            UIViewAutoresizingFlexibleHeight;
    inner.backgroundColor=UIColor.clearColor;
    inner.userInteractionEnabled=NO;
    inner.layer.cornerRadius=10.0;
    inner.layer.borderWidth=1.5;
    inner.layer.borderColor=[UIColor colorWithRed:1.0 green:0.1
                                         blue:0.14 alpha:0.65].CGColor;
    [surface addSubview:inner];

    UILabel *message=[[UILabel alloc]initWithFrame:
        CGRectMake(18.0,MAX(0.0,(CGRectGetHeight(bounds)-98.0)*0.5),
                   MAX(1.0,CGRectGetWidth(bounds)-36.0),98.0)];
    message.autoresizingMask=UIViewAutoresizingFlexibleWidth|
                              UIViewAutoresizingFlexibleTopMargin|
                              UIViewAutoresizingFlexibleBottomMargin;
    message.backgroundColor=UIColor.clearColor;
    message.userInteractionEnabled=NO;
    message.text=@"LÀM MÁT THIẾT BỊ CỦA BẠN";
    message.font=[UIFont boldSystemFontOfSize:28.0];
    message.textColor=UIColor.whiteColor;
    message.textAlignment=NSTextAlignmentCenter;
    message.numberOfLines=2;
    message.adjustsFontSizeToFitWidth=YES;
    message.minimumScaleFactor=0.68;
    message.shadowColor=[UIColor colorWithWhite:0.0 alpha:1.0];
    message.shadowOffset=CGSizeMake(0,2.0);
    [surface addSubview:message];
    return surface;
}
#endif
