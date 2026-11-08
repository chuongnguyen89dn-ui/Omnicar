// SPPBubbleView.h — reconstructed interface (evidence: metadata objc dump)
#import <UIKit/UIKit.h>
#import <Preferences/PSListController.h>
#import <Preferences/PSSpecifier.h>
#import <Preferences/PSTableCell.h>

@interface SPPBubbleView : UIView
{
    B _showIcon;  // offset None
    i _speed;  // offset None
    i _limit;  // offset None
    q _style;  // offset None
    @"UIImage" _iconImage;  // offset None
    q _color;  // offset None
    @? _log;  // offset None
    q _builtStyle;  // offset None
    d _outlineCorner;  // offset None
    @"UILabel" _speedLabel;  // offset None
    @"SPPGlassView" _glass;  // offset None
    @"SPPIconView" _iconView;  // offset None
    @"SPPSignView" _sign;  // offset None
    @"UILabel" _unitLabel;  // offset None
    @"UIView" _deco;  // offset None
    @"NSMutableDictionary" _parts;  // offset None
    @"NSMutableDictionary" _bits;  // offset None
    @"NSArray" _tickLabels;  // offset None
    @"UIView" _flashView;  // offset None
    {CGSize="width"d"height"d} _contentSize;  // offset None
    {CGRect="origin"{CGPoint="x"d"y"d}"size"{CGSize="width"d"height"d}} _outlineRect;  // offset None
}
@property (Tq,N,V_builtStyle) id builtStyle;
@property (T{CGRect={CGPoint=dd}{CGSize=dd}},N,V_outlineRect) id outlineRect;
@property (Td,N,V_outlineCorner) id outlineCorner;
@property (T{CGSize=dd},N,V_contentSize) id contentSize;
@property (T@"SPPGlassView",&,N,V_glass) id glass;
@property (T@"SPPIconView",&,N,V_iconView) id iconView;
@property (T@"SPPSignView",&,N,V_sign) id sign;
@property (T@"UILabel",&,N,V_speedLabel) id speedLabel;
@property (T@"UILabel",&,N,V_unitLabel) id unitLabel;
@property (T@"UIView",&,N,V_deco) id deco;
@property (T@"NSMutableDictionary",&,N,V_parts) id parts;
@property (T@"NSMutableDictionary",&,N,V_bits) id bits;
@property (T@"NSArray",&,N,V_tickLabels) id tickLabels;
@property (T@"UIView",&,N,V_flashView) id flashView;
@property (Tq,N,V_style) id style;
@property (Ti,N,V_speed) id speed;
@property (Ti,N,V_limit) id limit;
@property (TB,N,V_showIcon) id showIcon;
@property (T@"UIImage",&,N,V_iconImage) id iconImage;
@property (Tq,N,V_color) id color;
@property (T@?,C,N,V_log) id log;
@end
