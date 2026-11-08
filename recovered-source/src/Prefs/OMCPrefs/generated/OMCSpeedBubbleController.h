// OMCSpeedBubbleController.h — reconstructed interface (evidence: metadata objc dump)
#import <UIKit/UIKit.h>
#import <Preferences/PSListController.h>
#import <Preferences/PSSpecifier.h>
#import <Preferences/PSTableCell.h>

@interface OMCSpeedBubbleController : OMCCardPage <UITextFieldDelegate>
{
    @"SPPBubbleView" _live;  // offset None
    @"UIImageView" _liveMap;  // offset None
    @"NSTimer" _liveTimer;  // offset None
    d _liveStart;  // offset None
    @"UIScrollView" _styleStrip;  // offset None
    d _stripOffset;  // offset None
    @"NSArray" _warnRows;  // offset None
}
@property (T@"SPPBubbleView",&,N,V_live) id live;
@property (T@"UIImageView",&,N,V_liveMap) id liveMap;
@property (T@"NSTimer",&,N,V_liveTimer) id liveTimer;
@property (Td,N,V_liveStart) id liveStart;
@property (T@"UIScrollView",&,N,V_styleStrip) id styleStrip;
@property (Td,N,V_stripOffset) id stripOffset;
@property (T@"NSArray",&,N,V_warnRows) id warnRows;
@property (TQ,R) id hash;
@property (T#,R) id superclass;
@property (T@"NSString",R,C) id description;
@property (T@"NSString",?,R,C) id debugDescription;
@end
