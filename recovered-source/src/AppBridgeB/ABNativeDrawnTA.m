// HL40: a native-CarPlay drawn keyboard transport using the ORIGINAL
// ABKeyboard/ABKey/ABTelex UI. Unlike AppBridge hosted input this
// path is split across CarPlayApp (presenter) and the native app
// or CarPlayTemplateUIHost (the UIKeyInput first-responder owner).
// No native keyboard-window geometry or UIKeyboardLayoutStar writes.
#import "AppBridgeB.h"
#import "ABKeyboardDecl.h"
#import "ABHost.h" // [hl41-native-host] original SpringBoard CarPlay surface
#import <objc/runtime.h>
#import <math.h>
#import <stdlib.h>

extern NSInteger ABForcedOrientation; // original ABInApp.m hosted-assignment state

static NSString *const DC40Focus = @"com.anlai.omnicar/nativekb.focus.v1";
static NSString *const DC40Command = @"com.anlai.omnicar/nativekb.command.v1";
static NSString *const DC40Ack = @"com.anlai.omnicar/nativekb.ack.v1";
static NSString *DC40ClientBundle;
static __weak id DC40Responder;
static id DC40OwnedBlank;
static uint32_t DC40ClientNonce;
static uint64_t DC40ClientSeq;
static BOOL DC40ClientInstalled;
static NSTimer *DC40ClientScanTimer; // [hl40-native-drawn] first-responder poll fallback

static BOOL DC40CarScene(UIWindowScene *scene) {
    if (!scene) return NO;
    NSString *role = scene.session.role.lowercaseString ?: @"";
    BOOL external = scene.screen && scene.screen != [UIScreen mainScreen];
    return external || [role containsString:@"carplay"] ||
        [role containsString:@"cartemplate"] ||
        ([role containsString:@"car"] && [role containsString:@"template"]);
}
static BOOL DC40CarInput(id candidate) {
    if (ABForcedOrientation >= 1) return NO; // hosted is original ABKeyboard path
    if (![candidate isKindOfClass:[UIView class]]) return NO;
    UIWindow *window = ((UIView *)candidate).window;
    if (!window || ![candidate conformsToProtocol:@protocol(UIKeyInput)]) return NO;
    if (DC40CarScene(window.windowScene)) return YES;
    // CarPlayTemplateUIHost exists solely to serve a CarPlay template scene.
    return [DC40ClientBundle isEqualToString:@"com.apple.CarPlayTemplateUIHost"] &&
           window.windowScene != nil;
}
static void DC40FocusPost(BOOL active, NSUInteger keyboardType,
                          NSUInteger returnType, uint32_t nonce) {
    if (!DC40ClientBundle.length || !nonce) return;
    [[NSDistributedNotificationCenter defaultCenter]
        postNotificationName:DC40Focus object:DC40ClientBundle
                    userInfo:@{@"bundle":DC40ClientBundle,
                               @"active":@(active),@"nonce":@(nonce),
                               @"keyboardType":@(keyboardType),
                               @"returnType":@(returnType)}];
}
static void DC40ClientEnd(id candidate) {
    if (candidate != DC40Responder) return;
    uint32_t prior = DC40ClientNonce;
    DC40Responder = nil;
    DC40ClientNonce = 0;
    DC40ClientSeq = 0;
    if (DC40OwnedBlank && [candidate respondsToSelector:@selector(setInputView:)]) {
        // Ownership identity prevents overwriting a custom inputView.
        if ([candidate inputView] == DC40OwnedBlank)
            [candidate setInputView:nil];
        DC40OwnedBlank = nil;
    }
    DC40FocusPost(NO, 0, 0, prior);
    OMCLogWrite(@"AppBridge", @"[hl40-native-drawn] first responder ended");
}
static void DC40ClientBegin(id candidate) {
    if (!DC40CarInput(candidate) || ![candidate isFirstResponder]) return;
    if (candidate == DC40Responder && DC40ClientNonce) return;
    if (DC40Responder) DC40ClientEnd(DC40Responder);
    // Fail closed if a native app already owns a custom input surface:
    // do not stack a drawn keyboard on top of that surface.
    if (![candidate respondsToSelector:@selector(setInputView:)] ||
        [candidate inputView] != nil) return;
    UIView *blank = [[UIView alloc] initWithFrame:CGRectZero];
    [candidate setInputView:blank];
    DC40OwnedBlank = blank;
    if ([candidate respondsToSelector:@selector(reloadInputViews)])
        [candidate reloadInputViews];
    DC40Responder = candidate;
    DC40ClientNonce = arc4random();
    if (!DC40ClientNonce) DC40ClientNonce = 1;
    DC40ClientSeq = 0;
    NSUInteger type = [candidate respondsToSelector:@selector(keyboardType)]
        ? (NSUInteger)[candidate keyboardType] : 0;
    NSUInteger ret = [candidate respondsToSelector:@selector(returnKeyType)]
        ? (NSUInteger)[candidate returnKeyType] : 0;
    DC40FocusPost(YES, type, ret, DC40ClientNonce);
    OMCLogWrite(@"AppBridge",
        @"[hl40-native-drawn] CarPlay text focus reported; system inputView replaced");
}
static void DC40ClientAck(uint64_t seq, uint32_t nonce) {
    [[NSDistributedNotificationCenter defaultCenter]
        postNotificationName:DC40Ack object:DC40ClientBundle
                    userInfo:@{@"nonce":@(nonce),@"seq":@(seq)}];
}
static void DC40ClientReceive(NSNotification *note) {
    NSDictionary *message=note.userInfo;
    if (!DC40Responder || ![DC40Responder isFirstResponder] ||
        !DC40CarInput(DC40Responder)) return;
    uint32_t nonce=[message[@"nonce"] unsignedIntValue];
    uint64_t seq=[message[@"seq"] unsignedLongLongValue];
    if (!nonce || nonce!=DC40ClientNonce || !seq) return;
    if (seq==DC40ClientSeq) {
        DC40ClientAck(seq,nonce); // ACK retry without double-typing
        return;
    }
    if (seq!=DC40ClientSeq+1) return; // wait for expected sequence
    id<UIKeyInput> input=(id<UIKeyInput>)DC40Responder;
    NSString *action=message[@"action"];
    if ([action isEqualToString:@"type"]) {
        NSUInteger count=MIN((NSUInteger)[message[@"del"] unsignedIntegerValue], 64u);
        for (NSUInteger i=0;i<count;i++) [input deleteBackward];
        NSString *str=message[@"text"];
        if ([str isKindOfClass:[NSString class]] && str.length<=64)
            [input insertText:str];
    } else if ([action isEqualToString:@"return"]) {
        if ([DC40Responder isKindOfClass:[UITextField class]]) {
            UITextField *field=DC40Responder;
            id<UITextFieldDelegate> delegate=field.delegate;
            BOOL allowed=![delegate respondsToSelector:@selector(textFieldShouldReturn:)] ||
                [delegate textFieldShouldReturn:field];
            if (allowed) {
                [field sendActionsForControlEvents:UIControlEventEditingDidEndOnExit];
                [field resignFirstResponder];
            }
        } else {
            [input insertText:@"\n"];
        }
    } else if ([action isEqualToString:@"dismiss"]) {
        [DC40Responder resignFirstResponder];
    } else return;
    DC40ClientSeq=seq;
    DC40ClientAck(seq,nonce);
}
// MultiTA-style safety net: native search fields can become the first
// responder before or without standard begin-editing notifications.
static UIView *DC40FindResponder(UIView *root, NSUInteger depth) {
    if (!root || depth>24) return nil;
    if (root.isFirstResponder && [root conformsToProtocol:@protocol(UIKeyInput)])
        return root;
    for (UIView *child in root.subviews) {
        UIView *found=DC40FindResponder(child,depth+1);
        if (found) return found;
    }
    return nil;
}
static void DC40ClientScan(void) {
    if (ABForcedOrientation>=1) {
        if (DC40Responder) DC40ClientEnd(DC40Responder);
        return;
    }
    if (DC40ClientNonce && !DC40Responder) {
        uint32_t nonce=DC40ClientNonce;
        DC40ClientNonce=0;
        DC40ClientSeq=0;
        DC40OwnedBlank=nil;
        DC40FocusPost(NO,0,0,nonce);
    }
    if (DC40Responder &&
        (![DC40Responder isFirstResponder] || !DC40CarInput(DC40Responder)))
        DC40ClientEnd(DC40Responder);
    UIApplication *app=[UIApplication sharedApplication];
    for (UIScene *c in app.connectedScenes) {
        if (![c isKindOfClass:[UIWindowScene class]]) continue;
        UIWindowScene *scene=(UIWindowScene *)c;
        BOOL templateHost=[DC40ClientBundle isEqualToString:
                           @"com.apple.CarPlayTemplateUIHost"];
        if (!DC40CarScene(scene) && !templateHost) continue;
        if (scene.activationState!=UISceneActivationStateForegroundActive &&
            scene.activationState!=UISceneActivationStateForegroundInactive)
            continue;
        for (UIWindow *window in scene.windows) {
            UIView *responder=DC40FindResponder(window,0);
            if (responder && DC40CarInput(responder)) {
                DC40ClientBegin(responder);
                return;
            }
        }
    }
}

void DC40NativeClientStart(NSString *bundle) {
    if (DC40ClientInstalled || !bundle.length) return;
    DC40ClientInstalled=YES;
    DC40ClientBundle=[bundle copy];
    NSNotificationCenter *nc=[NSNotificationCenter defaultCenter];
    NSOperationQueue *q=[NSOperationQueue mainQueue];
    [nc addObserverForName:UITextFieldTextDidBeginEditingNotification object:nil queue:q
               usingBlock:^(NSNotification *n) { DC40ClientBegin(n.object); }];
    [nc addObserverForName:UITextViewTextDidBeginEditingNotification object:nil queue:q
               usingBlock:^(NSNotification *n) { DC40ClientBegin(n.object); }];
    [nc addObserverForName:UITextFieldTextDidEndEditingNotification object:nil queue:q
               usingBlock:^(NSNotification *n) { DC40ClientEnd(n.object); }];
    [nc addObserverForName:UITextViewTextDidEndEditingNotification object:nil queue:q
               usingBlock:^(NSNotification *n) { DC40ClientEnd(n.object); }];
    [[NSDistributedNotificationCenter defaultCenter]
        addObserverForName:DC40Command object:bundle queue:q
               usingBlock:^(NSNotification *n) { DC40ClientReceive(n); }];
    dispatch_async(dispatch_get_main_queue(), ^{
        DC40ClientScanTimer=[NSTimer scheduledTimerWithTimeInterval:0.20
            repeats:YES block:^(NSTimer *t) { (void)t; DC40ClientScan(); }];
        DC40ClientScan();
    });
    OMCLogWrite(@"AppBridge",
        @"[hl40-native-drawn] scene-only native responder client installed");
}

// The window is full-screen but is touch-transparent outside the
// original ABKeyboard panel, so native split app gestures still pass.
static uint32_t DC40CurrentNonce; // consulted by touch-through hitTest
@interface DC40OverlayWindow : UIWindow @end
@implementation DC40OverlayWindow
- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    UIView *panel=[ABKeyboard shared].panel;
    if (!DC40CurrentNonce || !panel || panel.superview!=self ||
        !CGRectContainsPoint(panel.frame,point)) return nil;
    return [super hitTest:point withEvent:event];
}
@end

static BOOL DC40PresenterInstalled;
static DC40OverlayWindow *DC40Window;
static NSString *DC40CurrentBundle;
static uint64_t DC40TxSeq;
static NSMutableArray<NSDictionary *> *DC40Queue;
static NSTimer *DC40RetryTimer;
static NSTimeInterval DC40LastPost;
static unsigned int DC40Retries;

static UIWindowScene *DC40PresentationScene(void) {
    UIApplication *app=[UIApplication sharedApplication];
    UIWindowScene *fallback=nil;
    for (UIScene *candidate in app.connectedScenes) {
        if (![candidate isKindOfClass:[UIWindowScene class]]) continue;
        UIWindowScene *s=(UIWindowScene *)candidate;
        if (!DC40CarScene(s)) continue;
        if (s.activationState==UISceneActivationStateForegroundActive) return s;
        if (!fallback && s.activationState==UISceneActivationStateForegroundInactive)
            fallback=s;
    }
    return fallback; // Never display over an iPhone-only scene.
}
UIWindow *DC40NativeKeyboardHostWindow(void) {
    // [hl41-native-host] Native uses the SAME SpringBoard carWindow
    // and carAppArea as hosted. Never allocate an extra native UIWindow.
    return nil;
}
static void DC40OverlayClose(void) {
    NSString *formerOwner=DC40CurrentBundle;
    [DC40Queue removeAllObjects];
    DC40CurrentBundle=nil;
    DC40CurrentNonce=0;
    DC40TxSeq=0;
    DC40Retries=0;
    if (formerOwner.length)
        [[ABKeyboard shared] hideForApp:formerOwner]; // never close hosted
    // Keep the transparent UIWindow alive for the hide animation.
    // Touches pass through immediately because the nonce is now zero.
}
static void DC40Pump(void) {
    if (!DC40CurrentNonce || !DC40Queue.count) return;
    NSTimeInterval now=[NSDate timeIntervalSinceReferenceDate];
    if (now-DC40LastPost<0.12) return;
    if (++DC40Retries>30) {
        OMCLogWrite(@"AppBridge",
            @"[hl40-native-drawn] command ACK stalled; native panel closed");
        DC40OverlayClose();
        return;
    }
    NSDictionary *head=DC40Queue.firstObject;
    [[NSDistributedNotificationCenter defaultCenter]
        postNotificationName:DC40Command object:DC40CurrentBundle userInfo:head];
    DC40LastPost=now;
}
BOOL DC40NativeKeyboardRouteKey(NSString *action, NSUInteger del, NSString *text) {
    if (!DC40CurrentNonce || !DC40CurrentBundle.length ||
        ![[ABKeyboard shared].app isEqualToString:DC40CurrentBundle])
        return NO; // hosted app still routes over appbridge.key
    if (DC40Queue.count>=128) {
        OMCLogWrite(@"AppBridge",
            @"[hl40-native-drawn] command queue saturated; closed");
        DC40OverlayClose();
        return YES;
    }
    NSMutableDictionary *item=[@{@"nonce":@(DC40CurrentNonce),
                                 @"seq":@(++DC40TxSeq),
                                 @"action":action ?: @"type",
                                 @"del":@(del)} mutableCopy];
    if (text) item[@"text"]=text;
    [DC40Queue addObject:item];
    if (DC40Queue.count==1) {
        DC40Retries=0;
        DC40LastPost=0;
        DC40Pump();
    }
    return YES;
}
static void DC40PresenterAck(NSNotification *note) {
    if (![note.object isEqual:DC40CurrentBundle] ||
        [note.userInfo[@"nonce"] unsignedIntValue]!=DC40CurrentNonce ||
        !DC40Queue.count) return;
    uint64_t head=[DC40Queue.firstObject[@"seq"] unsignedLongLongValue];
    if ([note.userInfo[@"seq"] unsignedLongLongValue]!=head) return;
    [DC40Queue removeObjectAtIndex:0];
    DC40Retries=0;
    DC40LastPost=0;
    DC40Pump();
}
static void DC40PresenterFocus(NSNotification *note) {
    NSString *bundle=note.userInfo[@"bundle"];
    if (![bundle isKindOfClass:[NSString class]] || !bundle.length ||
        ![bundle isEqualToString:note.object]) return;
    uint32_t nonce=[note.userInfo[@"nonce"] unsignedIntValue];
    if (!nonce) return;
    if (![note.userInfo[@"active"] boolValue]) {
        if ([bundle isEqualToString:DC40CurrentBundle] &&
            nonce==DC40CurrentNonce) DC40OverlayClose();
        return;
    }
    // [hl41-native-host] The native client is remote, but presentation
    // belongs to SpringBoard's original CarPlay surface and app area.
    UIWindow *host=[ABHost shared].carWindow;
    CGRect area=[ABHost shared].carAppArea;
    if (!host || CGRectIsNull(area) || CGRectIsEmpty(area) ||
        area.size.width < 200 || area.size.height < 200) {
        OMCLogWrite(@"AppBridge",
            @"[hl41-native-host] skip: no valid SpringBoard carWindow/appArea");
        return;
    }
    if (DC40CurrentNonce &&
        ![bundle isEqualToString:DC40CurrentBundle]) DC40OverlayClose();
    DC40CurrentBundle=[bundle copy];
    DC40CurrentNonce=nonce;
    DC40TxSeq=0;
    DC40Queue=[NSMutableArray array];
    NSInteger kind=[note.userInfo[@"keyboardType"] integerValue];
    NSInteger ret=[note.userInfo[@"returnType"] integerValue];
    [[ABKeyboard shared] showForApp:bundle keyboardType:kind returnType:ret];
    OMCLogWrite(@"AppBridge",[NSString stringWithFormat:
        @"[hl41-native-host] SpringBoard panel=%@ carArea=%@ carWindow=%@ nonce=%u",
        NSStringFromCGRect([ABKeyboard shared].panel.frame),
        NSStringFromCGRect(area),NSStringFromCGRect(host.bounds),nonce]);
}
void DC40NativePresenterStart(void) {
    if (![[[NSBundle mainBundle] bundleIdentifier]
          isEqualToString:@"com.apple.springboard"]) return;
    if (DC40PresenterInstalled) return;
    DC40PresenterInstalled=YES;
    NSDistributedNotificationCenter *dc=[NSDistributedNotificationCenter defaultCenter];
    NSOperationQueue *q=[NSOperationQueue mainQueue];
    [dc addObserverForName:DC40Focus object:nil queue:q
                usingBlock:^(NSNotification *n) { DC40PresenterFocus(n); }];
    [dc addObserverForName:DC40Ack object:nil queue:q
                usingBlock:^(NSNotification *n) { DC40PresenterAck(n); }];
    DC40RetryTimer=[NSTimer scheduledTimerWithTimeInterval:0.15 repeats:YES
            block:^(NSTimer *t) { (void)t; DC40Pump(); }];
    OMCLogWrite(@"AppBridge",
        @"[hl41-native-host] SpringBoard original-carWindow presenter armed");
}
