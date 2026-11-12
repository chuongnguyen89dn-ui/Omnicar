// HL40: a native-CarPlay drawn keyboard transport using the ORIGINAL
// ABKeyboard/ABKey/ABTelex UI. Unlike AppBridge hosted input this
// path is split across CarPlayApp (presenter) and the native app
// or CarPlayTemplateUIHost (the UIKeyInput first-responder owner).
// No native keyboard-window geometry or UIKeyboardLayoutStar writes.
#import "AppBridgeB.h"
#import "ABKeyboardDecl.h"
#import "ABHost.h" // [hl41-native-host] original SpringBoard CarPlay surface
#import <objc/runtime.h>
#import <substrate.h> // [hl41] pre-focus hooks limited to native CarPlay scene
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
static NSString *DC42VisibleKeyboardWindows(void);

static __weak UIView *DC41PrearmedResponder; // [hl41] non-owning native first responder
static UIView *DC41PrearmedBlank; // release on focus transition or failure

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
    OMCLogWrite(@"AppBridge",[NSString stringWithFormat:
        @"[hl42-native-plane] responder-ended nonce=%u stillFocused=%d windows=%@",
        prior,[candidate isFirstResponder],DC42VisibleKeyboardWindows()]);
}
static void DC40ClientBegin(id candidate) {
    if (!DC40CarInput(candidate) || ![candidate isFirstResponder]) return;
    if (candidate == DC40Responder && DC40ClientNonce) return;
    if (DC40Responder) DC40ClientEnd(DC40Responder);
    // [hl41] Prefer inputView installed BEFORE UIKit begins first-responder
    // presentation. Late replacement in HL40 triggered end/rebegin churn.
    if (![candidate respondsToSelector:@selector(setInputView:)]) return;
    UIView *blank=nil;
    if (candidate==DC41PrearmedResponder &&
        [candidate inputView]==DC41PrearmedBlank) {
        blank=DC41PrearmedBlank;
        DC41PrearmedResponder=nil;
        DC41PrearmedBlank=nil;
    } else {
        if ([candidate inputView]!=nil) return; // respect custom keyboard owners
        blank=[[UIView alloc] initWithFrame:CGRectZero];
        [candidate setInputView:blank];
        if ([candidate respondsToSelector:@selector(reloadInputViews)])
            [candidate reloadInputViews];
        OMCLogWrite(@"AppBridge",
            @"[hl41-native-key] fallback late focus; native keyplane UNKNOWN");
    }
    DC40OwnedBlank=blank;
    DC40Responder=candidate;
    DC40ClientNonce = arc4random();
    if (!DC40ClientNonce) DC40ClientNonce = 1;
    DC40ClientSeq = 0;
    NSUInteger type = [candidate respondsToSelector:@selector(keyboardType)]
        ? (NSUInteger)[candidate keyboardType] : 0;
    NSUInteger ret = [candidate respondsToSelector:@selector(returnKeyType)]
        ? (NSUInteger)[candidate returnKeyType] : 0;
    DC40FocusPost(YES, type, ret, DC40ClientNonce);
    OMCLogWrite(@"AppBridge",[NSString stringWithFormat:
        @"[hl41-native-key] focus nonce=%u prearmed=%d window=%@ responder=%@",
        DC40ClientNonce, blank!=nil,
        NSStringFromCGRect(((UIView *)candidate).window.bounds),
        NSStringFromClass([candidate class])]);
}
static void DC40ClientAck(uint64_t seq, uint32_t nonce) {
    [[NSDistributedNotificationCenter defaultCenter]
        postNotificationName:DC40Ack object:DC40ClientBundle
                    userInfo:@{@"nonce":@(nonce),@"seq":@(seq)}];
}
// [hl43-native-cancel] Invoke the real UISearchBar cancel control whenever
// the active CarPlay native first responder belongs to one. This is the
// programmatic equivalent of the user's successful Cancel button, not a
// window-level hide and not a substitute for measuring the Apple keyplane.
static UISearchBar *DC43OwningSearchBar(id candidate) {
    if (![candidate isKindOfClass:[UIView class]]) return nil;
    for (UIView *view=(UIView *)candidate; view; view=view.superview) {
        if ([view isKindOfClass:[UISearchBar class]]) return (UISearchBar *)view;
    }
    return nil;
}
static UIButton *DC43FindVisibleCancel(UIView *root, NSUInteger depth) {
    if (!root || depth>20 || root.hidden || root.alpha<0.1) return nil;
    if ([root isKindOfClass:[UIButton class]]) {
        UIButton *button=(UIButton *)root;
        NSString *name=NSStringFromClass([button class]).lowercaseString;
        NSString *label=(button.accessibilityLabel ?: @"").lowercaseString;
        NSString *title=([button titleForState:UIControlStateNormal] ?: @"").lowercaseString;
        BOOL named=[name containsString:@"cancel"] ||
            [label isEqualToString:@"cancel"] || [label isEqualToString:@"hủy"] ||
            [label isEqualToString:@"huỷ"] || [title isEqualToString:@"cancel"] ||
            [title isEqualToString:@"hủy"] || [title isEqualToString:@"huỷ"];
        if (named && button.enabled && button.window &&
            (button.allControlEvents & UIControlEventTouchUpInside))
            return button;
    }
    for (UIView *child in root.subviews) {
        UIButton *button=DC43FindVisibleCancel(child,depth+1);
        if (button) return button;
    }
    return nil;
}
static BOOL DC43TriggerRealSearchCancel(id responder) {
    UISearchBar *bar=DC43OwningSearchBar(responder);
    if (!bar) {
        OMCLogWrite(@"AppBridge",
            @"[hl43-cancel] path=no-owning-searchbar; fallback=resign");
        return NO;
    }
    UIButton *button=DC43FindVisibleCancel(bar,0);
    if (button) {
        [button sendActionsForControlEvents:UIControlEventTouchUpInside];
        OMCLogWrite(@"AppBridge",[NSString stringWithFormat:
            @"[hl43-cancel] path=visible-UISearchBar-cancel control=%@ focused=%d",
            NSStringFromClass([button class]),[responder isFirstResponder]]);
        return YES;
    }
    id<UISearchBarDelegate> delegate=bar.delegate;
    if ([delegate respondsToSelector:@selector(searchBarCancelButtonClicked:)]) {
        [delegate searchBarCancelButtonClicked:bar];
        OMCLogWrite(@"AppBridge",[NSString stringWithFormat:
            @"[hl43-cancel] path=UISearchBarDelegate focused=%d",
            [responder isFirstResponder]]);
        return YES;
    }
    OMCLogWrite(@"AppBridge",
        @"[hl43-cancel] path=no-button-or-delegate; fallback=resign");
    return NO;
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
        id candidate=DC40Responder;
        BOOL cancelFired=DC43TriggerRealSearchCancel(candidate);
        BOOL returned=cancelFired ? YES : [candidate resignFirstResponder];
        BOOL focused=[candidate isFirstResponder];
        OMCLogWrite(@"AppBridge",[NSString stringWithFormat:
            @"[hl43-cancel] dismiss nonce=%u cancelFired=%d returned=%d stillFocused=%d windows=%@",
            nonce,cancelFired,returned,focused,DC42VisibleKeyboardWindows()]);
        // IPC ACK acknowledges dispatch, not proof the Apple template
        // keyplane is absent. Track UIKit hide notifications independently.
    } else return;
    DC40ClientSeq=seq;
    OMCLogWrite(@"AppBridge",[NSString stringWithFormat:
        @"[hl41-native-key] delivered nonce=%u seq=%llu action=%@ (no text)",
        nonce,(unsigned long long)seq,action]);
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

// [hl41] Prearm only UIKit native-CarPlay fields; hosted/phone UIKit
// remains untouched because DC40CarInput checks the CarPlay scene role.
static BOOL (*DC41OrigTFBecome)(UITextField *,SEL);
static BOOL (*DC41OrigTVBecome)(UITextView *,SEL);
// [hl42] Mirror hosted hooks: end a native session on verified resign,
// not solely from UIKit editing notifications or a 200ms poll.
static BOOL (*DC42OrigTFResign)(UITextField *,SEL);
static BOOL (*DC42OrigTVResign)(UITextView *,SEL);
static BOOL DC42TFResign(UITextField *field,SEL cmd) {
    BOOL ok=DC42OrigTFResign(field,cmd);
    if (ok) DC40ClientEnd(field);
    return ok;
}
static BOOL DC42TVResign(UITextView *field,SEL cmd) {
    BOOL ok=DC42OrigTVResign(field,cmd);
    if (ok) DC40ClientEnd(field);
    return ok;
}
// Native UIKit window/keyplane observations only; never mutate windows.
static NSString *DC42VisibleKeyboardWindows(void) {
    NSMutableArray<NSString *> *matches=[NSMutableArray array];
    for (UIScene *candidate in [UIApplication sharedApplication].connectedScenes) {
        if (![candidate isKindOfClass:[UIWindowScene class]]) continue;
        UIWindowScene *scene=(UIWindowScene *)candidate;
        for (UIWindow *w in scene.windows) {
            NSString *cls=NSStringFromClass([w class]);
            if (w.hidden || ![cls.lowercaseString containsString:@"keyboard"]) continue;
            [matches addObject:[NSString stringWithFormat:@"%@ frame=%@ level=%.1f scene=%@",
                 cls,NSStringFromCGRect(w.frame),(double)w.windowLevel,scene.session.role]];
        }
    }
    return matches.count ? [matches componentsJoinedByString:@"; "] :
        @"BLIND-no-matching-owned-keyboard-window";
}
static void DC42KeyboardStateNote(NSNotification *note) {
    NSValue *v=note.userInfo[UIKeyboardFrameEndUserInfoKey];
    CGRect rect=[v isKindOfClass:[NSValue class]] ? [v CGRectValue] : CGRectNull;
    OMCLogWrite(@"AppBridge",[NSString stringWithFormat:
        @"[hl42-native-plane] note=%@ frame=%@ windows=%@",
        note.name,NSStringFromCGRect(rect),DC42VisibleKeyboardWindows()]);
}

static BOOL DC41PrearmInput(UIView *field) {
    if (!DC40CarInput(field) ||
        ![field respondsToSelector:@selector(setInputView:)] ||
        [(id)field inputView]!=nil) return NO;
    if (DC41PrearmedResponder && DC41PrearmedResponder!=field) {
        UIView *prior=DC41PrearmedResponder;
        if (prior && [(id)prior inputView]==DC41PrearmedBlank)
            [(id)prior setInputView:nil];
    }
    UIView *blank=[[UIView alloc] initWithFrame:CGRectZero];
    [(id)field setInputView:blank];
    DC41PrearmedResponder=field;
    DC41PrearmedBlank=blank;
    OMCLogWrite(@"AppBridge",[NSString stringWithFormat:
        @"[hl41-native-key] pre-focus inputView class=%@",
        NSStringFromClass([field class])]);
    return YES;
}
static void DC41PrearmCancel(id field) {
    if (field!=DC41PrearmedResponder) return;
    if ([field inputView]==DC41PrearmedBlank)
        [field setInputView:nil];
    DC41PrearmedResponder=nil;
    DC41PrearmedBlank=nil;
}
static BOOL DC41TFBecome(UITextField *field,SEL cmd) {
    BOOL armed=DC41PrearmInput(field);
    BOOL succeeded=DC41OrigTFBecome(field,cmd);
    if (succeeded) DC40ClientBegin(field);
    else if (armed) DC41PrearmCancel(field);
    return succeeded;
}
static BOOL DC41TVBecome(UITextView *field,SEL cmd) {
    BOOL armed=DC41PrearmInput(field);
    BOOL succeeded=DC41OrigTVBecome(field,cmd);
    if (succeeded) DC40ClientBegin(field);
    else if (armed) DC41PrearmCancel(field);
    return succeeded;
}
void DC40NativeClientStart(NSString *bundle) {
    if (DC40ClientInstalled || !bundle.length) return;
    DC40ClientInstalled=YES;
    DC40ClientBundle=[bundle copy];
    // Hooks run before system-keyboard presentation and avoid calling
    // reloadInputViews on a responder which is already editing.
    MSHookMessageEx(objc_getClass("UITextField"),@selector(becomeFirstResponder),
        (IMP)DC41TFBecome,(IMP *)&DC41OrigTFBecome);
    MSHookMessageEx(objc_getClass("UITextView"),@selector(becomeFirstResponder),
        (IMP)DC41TVBecome,(IMP *)&DC41OrigTVBecome);
    MSHookMessageEx(objc_getClass("UITextField"),@selector(resignFirstResponder),
        (IMP)DC42TFResign,(IMP *)&DC42OrigTFResign);
    MSHookMessageEx(objc_getClass("UITextView"),@selector(resignFirstResponder),
        (IMP)DC42TVResign,(IMP *)&DC42OrigTVResign);
    NSNotificationCenter *nc=[NSNotificationCenter defaultCenter];
    NSOperationQueue *q=[NSOperationQueue mainQueue];
    if ([bundle isEqualToString:@"com.apple.CarPlayTemplateUIHost"] ||
        [bundle isEqualToString:@"com.apple.CarPlayApp"]) {
        for (NSString *name in @[UIKeyboardWillShowNotification,
            UIKeyboardDidShowNotification,UIKeyboardWillHideNotification,
            UIKeyboardDidHideNotification]) {
            [nc addObserverForName:name object:nil queue:q
                usingBlock:^(NSNotification *n) { DC42KeyboardStateNote(n); }];
        }
    }
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

// [hl41] The old CarPlayApp full-scene DC40OverlayWindow was the source
// of native panel overlap with the Dock/hosted content; it is removed.
// The native presenter now uses the ORIGINAL SpringBoard ABHost.carWindow.
static uint32_t DC40CurrentNonce;
static BOOL DC40PresenterInstalled;
static NSString *DC40CurrentBundle;
static uint64_t DC40TxSeq;
static NSMutableArray<NSDictionary *> *DC40Queue;
static NSTimer *DC40RetryTimer;
static NSTimeInterval DC40LastPost;
static unsigned int DC40Retries;

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
// [hl42] ABKeyboard should wait for authenticated native focus-off before
// removing its drawn panel. Hosted uses its untouched original instant-hide.
BOOL DC42NativeHideWaitForFocusEnd(void) {
    NSString *app=[ABKeyboard shared].app;
    return DC40CurrentNonce && app.length &&
        [app isEqualToString:DC40CurrentBundle];
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
            nonce==DC40CurrentNonce) {
            // HL40 had native focus leave/reenter in 5 ms. Coalesce one
            // handoff before removing panel, with an exact nonce guard.
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW,
                (int64_t)(0.16*NSEC_PER_SEC)),dispatch_get_main_queue(),^{
                if (nonce==DC40CurrentNonce &&
                    [bundle isEqualToString:DC40CurrentBundle])
                    DC40OverlayClose();
            });
        }
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
    if (DC40CurrentNonce!=nonce) {
        DC40TxSeq=0;
        DC40Queue=[NSMutableArray array];
    }
    DC40CurrentBundle=[bundle copy];
    DC40CurrentNonce=nonce;
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
            block:^(NSTimer *t) {
                (void)t;
                if (DC40CurrentNonce && ![ABHost shared].carWindow)
                    DC40OverlayClose();
                DC40Pump();
            }];
    OMCLogWrite(@"AppBridge",
        @"[hl41-native-host] SpringBoard original-carWindow presenter armed");
}
