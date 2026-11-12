// HL31: clean-room CarPlay bubble presentation. Static source counterpart to
// DuoNavi CBAIBubbleView behavior: draggable, edge-snap, persisted normalized
// position, dim/wake, visual state, single tap callback; NOT its artwork.
#import "SCPVoiceBubbleView.h"
#import "SCPShared.h"
#import <QuartzCore/QuartzCore.h>
#import <math.h>

static NSString *const DCBubbleLeftKey=@"DuoCar.voiceBubble.left";
static NSString *const DCBubbleYKey=@"DuoCar.voiceBubble.normalizedY";
static const CGFloat DCBubbleSize=54.0;
static const CGFloat DCBubbleInset=10.0;
static CGFloat DCClamp(CGFloat v,CGFloat a,CGFloat b) {
    return fmin(fmax(isfinite(v)?v:a,a),b);
}
@interface SCPVoiceBubbleView ()
@property(nonatomic) CGRect boundaryBounds;
@property(nonatomic) BOOL leftEdge;
@property(nonatomic) CGFloat normalizedY;
@property(nonatomic) CGFloat lastTouchTime;
@property(nonatomic,strong) UIView *aura;
@property(nonatomic,strong) UIView *core;
@property(nonatomic,strong) UIImageView *glyph;
@property(nonatomic,strong) NSTimer *idleTimer;
@property(nonatomic,assign,readwrite) SCPVoiceBubbleState voiceState;
@end
@implementation SCPVoiceBubbleView
- (instancetype)initWithBoundaryBounds:(CGRect)boundary {
    if (!(self=[super initWithFrame:CGRectMake(0,0,DCBubbleSize,DCBubbleSize)])) return nil;
    self.accessibilityLabel=@"Bong bóng giọng nói DuoCar";
    self.isAccessibilityElement=YES;
    self.accessibilityTraits=UIAccessibilityTraitButton | UIAccessibilityTraitAdjustable;
    self.backgroundColor=UIColor.clearColor;
    self.clipsToBounds=NO;
    self.voiceState=SCPVoiceBubbleStateIdle;
    NSUserDefaults *store=NSUserDefaults.standardUserDefaults;
    self.leftEdge=[store objectForKey:DCBubbleLeftKey] ? [store boolForKey:DCBubbleLeftKey] : NO;
    self.normalizedY=[store objectForKey:DCBubbleYKey]
        ? DCClamp([store doubleForKey:DCBubbleYKey],0,1) : 0.78;
    self.aura=[[UIView alloc] initWithFrame:CGRectZero];
    self.aura.userInteractionEnabled=NO;
    self.aura.backgroundColor=UIColor.clearColor;
    self.aura.layer.borderWidth=2.0;
    self.aura.layer.borderColor=[UIColor colorWithRed:0.25 green:0.75 blue:0.98 alpha:0.55].CGColor;
    [self addSubview:self.aura];
    self.core=[[UIView alloc] initWithFrame:CGRectZero];
    self.core.userInteractionEnabled=NO;
    self.core.backgroundColor=[UIColor colorWithRed:0.12 green:0.19 blue:0.32 alpha:0.96];
    self.core.layer.borderWidth=1.0;
    self.core.layer.borderColor=[UIColor colorWithWhite:1 alpha:0.50].CGColor;
    self.core.layer.shadowColor=UIColor.blackColor.CGColor;
    self.core.layer.shadowOpacity=0.45;
    self.core.layer.shadowRadius=7.0;
    self.core.layer.shadowOffset=CGSizeMake(0,2);
    [self addSubview:self.core];
    self.glyph=[[UIImageView alloc] initWithImage:[UIImage systemImageNamed:@"waveform"]];
    self.glyph.contentMode=UIViewContentModeScaleAspectFit;
    self.glyph.tintColor=UIColor.whiteColor;
    self.glyph.userInteractionEnabled=NO;
    [self addSubview:self.glyph];
    UIPanGestureRecognizer *pan=[[UIPanGestureRecognizer alloc]
        initWithTarget:self action:@selector(handlePan:)];
    pan.delegate=self;
    pan.maximumNumberOfTouches=1;
    [self addGestureRecognizer:pan];
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]
        initWithTarget:self action:@selector(handleTap:)];
    tap.delegate=self;
    [tap requireGestureRecognizerToFail:pan];
    [self addGestureRecognizer:tap];
    self.boundaryBounds=boundary;
    [self layoutCore];
    [self placeStoredPosition];
    [self restartIdleTimer];
    return self;
}
- (void)dealloc {
    [self.idleTimer invalidate];
    [self.aura.layer removeAllAnimations];
}
- (void)layoutCore {
    CGRect b=self.bounds;
    self.aura.frame=CGRectInset(b,1.5,1.5);
    self.aura.layer.cornerRadius=CGRectGetWidth(self.aura.bounds)*0.5;
    self.core.frame=CGRectInset(b,6.0,6.0);
    self.core.layer.cornerRadius=CGRectGetWidth(self.core.bounds)*0.5;
    self.glyph.frame=CGRectInset(b,17.0,17.0);
}
- (void)layoutSubviews {
    [super layoutSubviews];
    [self layoutCore];
}
- (CGRect)safeBoundary {
    CGRect b=self.boundaryBounds;
    if (CGRectIsNull(b) || CGRectIsEmpty(b))
        b=self.superview ? self.superview.bounds : CGRectMake(0,0,744,428);
    return b;
}
- (CGPoint)boundedCenter:(CGPoint)point {
    CGRect b=[self safeBoundary];
    CGFloat half=DCBubbleSize*0.5;
    CGFloat minX=CGRectGetMinX(b)+half+DCBubbleInset;
    CGFloat maxX=CGRectGetMaxX(b)-half-DCBubbleInset;
    CGFloat minY=CGRectGetMinY(b)+half+DCBubbleInset;
    CGFloat maxY=CGRectGetMaxY(b)-half-DCBubbleInset;
    if (maxX<minX) maxX=minX;
    if (maxY<minY) maxY=minY;
    return CGPointMake(DCClamp(point.x,minX,maxX),DCClamp(point.y,minY,maxY));
}
- (void)placeStoredPosition {
    CGRect b=[self safeBoundary];
    CGFloat half=DCBubbleSize*0.5;
    CGFloat minY=CGRectGetMinY(b)+half+DCBubbleInset;
    CGFloat maxY=fmax(minY,CGRectGetMaxY(b)-half-DCBubbleInset);
    CGPoint point=CGPointMake(self.leftEdge ? CGRectGetMinX(b)+half+DCBubbleInset
                                           : CGRectGetMaxX(b)-half-DCBubbleInset,
        minY+self.normalizedY*(maxY-minY));
    self.center=[self boundedCenter:point];
}
- (void)updateBoundaryBounds:(CGRect)b {
    if (CGRectIsNull(b)||CGRectIsEmpty(b)) return;
    if (CGRectEqualToRect(b,self.boundaryBounds)) return;
    self.boundaryBounds=b;
    [self placeStoredPosition]; // side/Y survive split resize and reconnect
}
- (void)persistPosition {
    CGRect b=[self safeBoundary];
    CGFloat minY=CGRectGetMinY(b)+DCBubbleInset+DCBubbleSize*0.5;
    CGFloat maxY=fmax(minY,CGRectGetMaxY(b)-DCBubbleInset-DCBubbleSize*0.5);
    self.normalizedY=maxY>minY ? DCClamp((self.center.y-minY)/(maxY-minY),0,1) : 0.5;
    NSUserDefaults *store=NSUserDefaults.standardUserDefaults;
    [store setBool:self.leftEdge forKey:DCBubbleLeftKey];
    [store setDouble:self.normalizedY forKey:DCBubbleYKey];
    if (self.onPositionChanged) self.onPositionChanged(self.leftEdge,self.normalizedY);
    OMCLogWrite(@"SplitScreen",[NSString stringWithFormat:
        @"[hl31-bubble] event=snap edge=%@ normalizedY=%.3f",
        self.leftEdge ? @"left":@"right",self.normalizedY]);
}
- (void)snapToNearestEdgeAnimated:(BOOL)animated {
    CGRect b=[self safeBoundary];
    self.leftEdge=self.center.x<CGRectGetMidX(b);
    CGPoint target=[self boundedCenter:CGPointMake(
        self.leftEdge ? CGRectGetMinX(b)+DCBubbleInset+DCBubbleSize*0.5
                      : CGRectGetMaxX(b)-DCBubbleInset-DCBubbleSize*0.5,
        self.center.y)];
    void (^position)(void)=^{self.center=target; self.transform=CGAffineTransformIdentity;};
    if (animated) {
        [UIView animateWithDuration:0.32 delay:0 usingSpringWithDamping:0.82
            initialSpringVelocity:0 options:UIViewAnimationOptionBeginFromCurrentState
            animations:position completion:^(__unused BOOL finished){[self persistPosition];}];
    } else { position();[self persistPosition]; }
}
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)recognizer
       shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)other {
    (void)recognizer;(void)other;
    return NO;
}
- (void)handlePan:(UIPanGestureRecognizer *)pan {
    UIView *parent=self.superview;
    if (!parent) return;
    if (pan.state==UIGestureRecognizerStateBegan) {
        [self wakeBubble]; [self.idleTimer invalidate];
        [UIView animateWithDuration:0.12 animations:^{
            self.transform=CGAffineTransformMakeScale(1.08,1.08);
        }];
    } else if (pan.state==UIGestureRecognizerStateChanged) {
        CGPoint move=[pan translationInView:parent];
        self.center=[self boundedCenter:CGPointMake(self.center.x+move.x,self.center.y+move.y)];
        [pan setTranslation:CGPointZero inView:parent];
    } else if (pan.state==UIGestureRecognizerStateEnded ||
               pan.state==UIGestureRecognizerStateCancelled ||
               pan.state==UIGestureRecognizerStateFailed) {
        [self snapToNearestEdgeAnimated:YES];
        [self restartIdleTimer];
    }
}
- (void)handleTap:(UITapGestureRecognizer *)tap {
    if (tap.state!=UIGestureRecognizerStateEnded) return;
    CFTimeInterval now=CACurrentMediaTime();
    if (now-self.lastTouchTime<0.35) return;
    self.lastTouchTime=now;
    [self wakeBubble];
    OMCLogWrite(@"SplitScreen",@"[hl31-bubble] event=tap-callback");
    if (self.onBubbleTapped) self.onBubbleTapped();
}
- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    (void)event;
    CGRect hits=CGRectInset(self.bounds,-1,-1);
    return CGRectContainsPoint(hits,point);
}
- (void)restartIdleTimer {
    [self.idleTimer invalidate];
    self.idleTimer=nil;
    if (self.voiceState!=SCPVoiceBubbleStateIdle) return;
    __weak typeof(self) weakSelf=self;
    self.idleTimer=[NSTimer scheduledTimerWithTimeInterval:4.0 repeats:NO
        block:^(__unused NSTimer *timer) {[weakSelf dimBubble];}];
}
- (void)wakeBubble {
    [self.idleTimer invalidate];
    [UIView animateWithDuration:0.22 delay:0
        options:UIViewAnimationOptionBeginFromCurrentState animations:^{
        self.alpha=1.0;
        self.core.layer.shadowOpacity=0.46;
    } completion:nil];
    [self restartIdleTimer];
}
- (void)dimBubble {
    if (self.voiceState!=SCPVoiceBubbleStateIdle) return;
    [self.idleTimer invalidate];
    [UIView animateWithDuration:0.25 delay:0
        options:UIViewAnimationOptionBeginFromCurrentState animations:^{
        self.alpha=0.45;
        self.core.layer.shadowOpacity=0.14;
    } completion:nil];
}
- (void)setVoiceState:(SCPVoiceBubbleState)state animated:(BOOL)animated {
    if (state<0 || state>SCPVoiceBubbleStateError) state=SCPVoiceBubbleStateError;
    if (state==self.voiceState && animated) return;
    self.voiceState=state;
    [self.idleTimer invalidate];
    [self.aura.layer removeAnimationForKey:@"voicePulse"];
    UIColor *tone=nil;
    NSString *glyphName=nil;
    switch(state) {
        case SCPVoiceBubbleStateListening:
            tone=[UIColor colorWithRed:0.14 green:0.80 blue:0.68 alpha:1];
            glyphName=@"waveform";
            self.accessibilityLabel=@"DuoCar đang nghe, chạm để dừng";break;
        case SCPVoiceBubbleStateThinking:
            tone=[UIColor colorWithRed:0.99 green:0.72 blue:0.25 alpha:1];
            glyphName=@"ellipsis";
            self.accessibilityLabel=@"DuoCar đang xử lý";break;
        case SCPVoiceBubbleStateSpeaking:
            tone=[UIColor colorWithRed:0.51 green:0.61 blue:1 alpha:1];
            glyphName=@"speaker.wave.2.fill";
            self.accessibilityLabel=@"DuoCar đang trả lời";break;
        case SCPVoiceBubbleStateError:
            tone=[UIColor colorWithRed:1 green:0.32 blue:0.31 alpha:1];
            glyphName=@"exclamationmark";
            self.accessibilityLabel=@"DuoCar chưa thể nghe";break;
        default:
            tone=[UIColor colorWithRed:0.24 green:0.73 blue:0.99 alpha:1];
            glyphName=@"waveform";
            self.accessibilityLabel=@"Bong bóng giọng nói DuoCar";break;
    }
    self.glyph.image=[UIImage systemImageNamed:glyphName];
    void (^paint)(void)=^{
        self.alpha=1;
        self.aura.layer.borderColor=tone.CGColor;
        self.core.backgroundColor=[tone colorWithAlphaComponent:0.82];
    };
    if (animated) [UIView animateWithDuration:0.18 animations:paint];
    else paint();
    if (state==SCPVoiceBubbleStateListening || state==SCPVoiceBubbleStateSpeaking) {
        CABasicAnimation *pulse=[CABasicAnimation animationWithKeyPath:@"transform.scale"];
        pulse.fromValue=@(0.96); pulse.toValue=@(1.13);
        pulse.duration=0.72; pulse.autoreverses=YES;
        pulse.repeatCount=HUGE_VALF;
        [self.aura.layer addAnimation:pulse forKey:@"voicePulse"];
    }
    if (state==SCPVoiceBubbleStateIdle) [self restartIdleTimer];
    OMCLogWrite(@"SplitScreen",[NSString stringWithFormat:
        @"[hl31-bubble] event=visual-state state=%ld",(long)state]);
}
@end
