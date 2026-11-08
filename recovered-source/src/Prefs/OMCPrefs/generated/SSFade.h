// SSFade.h — reconstructed interface (evidence: metadata objc dump)
#import <UIKit/UIKit.h>
#import <Preferences/PSListController.h>
#import <Preferences/PSSpecifier.h>
#import <Preferences/PSTableCell.h>

@interface SSFade : NSObject
{
    B _outEase;  // offset None
    @"UIView" _view;  // offset None
    d _inA;  // offset None
    d _inB;  // offset None
    d _outA;  // offset None
    d _outB;  // offset None
    d _alpha;  // offset None
    d _rise;  // offset None
}
@property (T@"UIView",&,N,V_view) id view;
@property (Td,N,V_inA) id inA;
@property (Td,N,V_inB) id inB;
@property (Td,N,V_outA) id outA;
@property (Td,N,V_outB) id outB;
@property (Td,N,V_alpha) id alpha;
@property (Td,N,V_rise) id rise;
@property (TB,N,V_outEase) id outEase;
@end
