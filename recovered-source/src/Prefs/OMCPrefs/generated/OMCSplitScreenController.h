// OMCSplitScreenController.h — reconstructed interface (evidence: metadata objc dump)
#import <UIKit/UIKit.h>
#import <Preferences/PSListController.h>
#import <Preferences/PSSpecifier.h>
#import <Preferences/PSTableCell.h>

@interface OMCSplitScreenController : OMCCardPage <UITextFieldDelegate>
{
    B _showGestures;  // offset None
    B _showSiri;  // offset None
    @"OMCSplitPreview" _preview;  // offset None
    q _editing;  // offset None
}
@property (T@"OMCSplitPreview",&,N,V_preview) id preview;
@property (Tq,N,V_editing) id editing;
@property (TB,N,V_showGestures) id showGestures;
@property (TB,N,V_showSiri) id showSiri;
@property (TQ,R) id hash;
@property (T#,R) id superclass;
@property (T@"NSString",R,C) id description;
@property (T@"NSString",?,R,C) id debugDescription;
@end
