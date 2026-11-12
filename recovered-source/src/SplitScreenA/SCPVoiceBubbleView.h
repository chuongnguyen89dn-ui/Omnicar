// HL31: first-party stateful CarPlay bubble behavior, based on SHA-pinned
// static examination of DuoNavi 1.0.4; no vendor artwork/code is copied.
#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger, SCPVoiceBubbleState) {
    SCPVoiceBubbleStateIdle=0,
    SCPVoiceBubbleStateListening=1,
    SCPVoiceBubbleStateThinking=2,
    SCPVoiceBubbleStateSpeaking=3,
    SCPVoiceBubbleStateError=4
};
@interface SCPVoiceBubbleView : UIView <UIGestureRecognizerDelegate>
@property(nonatomic,copy) void (^onBubbleTapped)(void);
@property(nonatomic,copy) void (^onPositionChanged)(BOOL isLeft, CGFloat normalizedY);
@property(nonatomic,assign,readonly) SCPVoiceBubbleState voiceState;
- (instancetype)initWithBoundaryBounds:(CGRect)boundaryBounds;
- (void)updateBoundaryBounds:(CGRect)boundaryBounds;
- (void)setVoiceState:(SCPVoiceBubbleState)state animated:(BOOL)animated;
- (void)wakeBubble;
- (void)dimBubble;
@end
