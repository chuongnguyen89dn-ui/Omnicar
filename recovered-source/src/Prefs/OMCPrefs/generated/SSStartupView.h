// SSStartupView.h — reconstructed interface (evidence: metadata objc dump)
#import <UIKit/UIKit.h>
#import <Preferences/PSListController.h>
#import <Preferences/PSSpecifier.h>
#import <Preferences/PSTableCell.h>

@interface SSStartupView : UIView
{
    d _unit;  // offset None
    @"UIStackView" _stack;  // offset None
    @"UIImageView" _logoView;  // offset None
    @"UIImageView" _posterView;  // offset None
    @"UILabel" _timeLabel;  // offset None
    @"UILabel" _titleLabel;  // offset None
    @"UILabel" _dateLabel;  // offset None
    @"UILabel" _tempLabel;  // offset None
    @"UILabel" _condLabel;  // offset None
    @"UILabel" _rangeLabel;  // offset None
    @"UILabel" _rainLabel;  // offset None
    @"UILabel" _updatedLabel;  // offset None
    @"UIImageView" _iconView;  // offset None
    @"UIStackView" _row;  // offset None
    @"UIStackView" _cardStack;  // offset None
    @"UIVisualEffectView" _card;  // offset None
    @"NSLayoutConstraint" _iconW;  // offset None
    @"NSLayoutConstraint" _iconH;  // offset None
    @"NSLayoutConstraint" _stackMaxWidth;  // offset None
    @"NSArray" _cardInsets;  // offset None
    q _sceneStyle;  // offset None
    q _sky;  // offset None
    {CGSize="width"d"height"d} _sceneSize;  // offset None
    B _sceneBuilt;  // offset None
    d _k;  // offset None
    d _ox;  // offset None
    d _oy;  // offset None
    d _restTime;  // offset None
    d _linkEnd;  // offset None
    d _tempoScale;  // offset None
    d _t0;  // offset None
    B _playing;  // offset None
    @"CADisplayLink" _link;  // offset None
    @"UIView" _scene;  // offset None
    @"UIView" _glass;  // offset None
    @"SSCanvasView" _canvas;  // offset None
    @"NSMutableArray" _fades;  // offset None
    @"NSMutableData" _motes;  // offset None
    @"NSMutableArray" _moteLayers;  // offset None
    @"NSMutableArray" _gauges;  // offset None
    @"NSMutableData" _particles;  // offset None
    d _dot;  // offset None
    @"NSMutableData" _bursts;  // offset None
    @"CAShapeLayer" _outline;  // offset None
    @"CAShapeLayer" _wheels;  // offset None
    @"CALayer" _flash;  // offset None
    @"CALayer" _horizon;  // offset None
    @"CALayer" _rays;  // offset None
    @"CALayer" _wiper;  // offset None
    @"CALayer" _lightning;  // offset None
    @"CALayer" _radar;  // offset None
    @"CAShapeLayer" _wetMask;  // offset None
    d _wiperLength;  // offset None
    d _cleared;  // offset None
    {CGPoint="x"d"y"d} _wiperPivot;  // offset None
    @"NSMutableArray" _rings;  // offset None
    @"UILabel" _percentLabel;  // offset None
    q _percentShown;  // offset None
    B _imageFits;  // offset None
    q _style;  // offset None
    @"UIImage" _image;  // offset None
    q _logoEffect;  // offset None
    @"NSString" _name;  // offset None
    @"NSDictionary" _weather;  // offset None
    @"NSDate" _date;  // offset None
    @"NSString" _carName;  // offset None
    q _tempo;  // offset None
    q _occasion;  // offset None
    @"NSArray" _hud;  // offset None
    @"NSDictionary" _nextEvent;  // offset None
    q _batteryPercent;  // offset None
    d _duration;  // offset None
}
@property (Tq,N,V_style) id style;
@property (T@"UIImage",&,N,V_image) id image;
@property (TB,N,V_imageFits) id imageFits;
@property (Tq,N,V_logoEffect) id logoEffect;
@property (T@"NSString",C,N,V_name) id name;
@property (T@"NSDictionary",C,N,V_weather) id weather;
@property (T@"NSDate",&,N,V_date) id date;
@property (T@"NSString",C,N,V_carName) id carName;
@property (Tq,N,V_tempo) id tempo;
@property (Tq,N,V_occasion) id occasion;
@property (T@"NSArray",C,N,V_hud) id hud;
@property (T@"NSDictionary",C,N,V_nextEvent) id nextEvent;
@property (Tq,N,V_batteryPercent) id batteryPercent;
@property (Td,N,V_duration) id duration;
@end
