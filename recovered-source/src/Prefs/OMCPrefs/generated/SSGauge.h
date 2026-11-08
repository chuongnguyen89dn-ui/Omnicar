// SSGauge.h — reconstructed interface (evidence: metadata objc dump)
#import <UIKit/UIKit.h>
#import <Preferences/PSListController.h>
#import <Preferences/PSSpecifier.h>
#import <Preferences/PSTableCell.h>

@interface SSGauge : NSObject
{
    B _hot;  // offset None
    @"CAShapeLayer" _arc;  // offset None
    @"CAGradientLayer" _fill;  // offset None
    @"CALayer" _needle;  // offset None
    @"UILabel" _number;  // offset None
    d _max;  // offset None
    d _red;  // offset None
    q _shown;  // offset None
}
@property (T@"CAShapeLayer",&,N,V_arc) id arc;
@property (T@"CAGradientLayer",&,N,V_fill) id fill;
@property (T@"CALayer",&,N,V_needle) id needle;
@property (T@"UILabel",&,N,V_number) id number;
@property (Td,N,V_max) id max;
@property (Td,N,V_red) id red;
@property (Tq,N,V_shown) id shown;
@property (TB,N,V_hot) id hot;
@end
