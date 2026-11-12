// ABKeyboard.m / ABKey — the SpringBoard-side on-car keyboard.
// Reconstructed from OmniCarAppBridge.dylib machine code (module B).
// Evidence: disasm/m_ABKeyboard_*.txt, disasm/m_ABKey_*.txt.
//
// The keyboard exists because the hosted app's own keyboard is suppressed
// in-app (see ABInApp.m, sub_698C blank inputView): when a text field in a
// hosted app becomes first responder, the app publishes the packed Darwin
// state on appbridge.keyboard; ABHostGeometry's consumer calls
// showForApp:/hideForApp: here; key taps are sent back over the
// NSDistributed appbridge.key channel and replayed in-app (sub_5908).
//
// Superclasses (proven by calibrated superclass-bind decode, see
// AppBridgeB_REPORT.md §7): ABKeyboard : NSObject, ABKey : UIButton.
// Wave-1 metadata's "NSRunLoop"/"NSNull" entries were the off-by-one error.

#import "AppBridgeB.h"
#import "ABHost.h"

// [hl40-native-drawn] Two tiny process-specific adapters; every original
// keycap, Telex, layout and preview method is kept byte-for-byte otherwise.
extern UIWindow *DC40NativeKeyboardHostWindow(void);
extern BOOL DC40NativeKeyboardRouteKey(NSString *action, NSUInteger del, NSString *text);

// OMC scaffold helpers used here (shared component, declared for
// self-consistency; implementations live in the Core module):
extern void OMCLogWrite(NSString *tag, NSString *message);
extern id OMCPref(NSString *key, id defaultValue);
extern void OMCPrefsSync(void);
extern NSString *OMCCurrentLanguage(void);
extern NSString *OMCTr(NSString *vi, NSString *en); // pick by current language
extern id OMCLogoMeshImage(int style); // shared unit (OMCCommon.h:188);
                                       // buildPanel calls it with 0

// ---------------------------------------------------------------------------
// ABKey — one key cap. Ivars (objc.json): _lit, _value, _command, _weight,
// _restColor, _restTint, _hint, _accent. All accessors are synthesized.
// ---------------------------------------------------------------------------
@interface ABKey : UIButton
@property (nonatomic) BOOL lit;
@property (nonatomic, copy) NSString *value;    // text typed by this key
@property (nonatomic, copy) NSString *command;  // nil | del|shift|mode|lang|ret|space
@property (nonatomic) double weight;            // row-layout width weight
@property (nonatomic, strong) UIColor *restColor;
@property (nonatomic, strong) UIColor *restTint;
@property (nonatomic, strong) UILabel *hint; // the hint LABEL view —
        // corrected in phase 2: rebuildKeys stores the UILabel it
        // creates via setHint: (m_ABKeyboard_rebuildKeys.txt @0x1B804)
        // and -setHint: @0x18C24 is a retain/store setter, not the
        // copy setter an NSString property would produce. The
        // original NSString typing here was a transcription error.
// CLOSURE (phase-2 follow-up): objc.json types this property
// @"CAGradientLayer" (T@"CAGradientLayer",&,N,V_accent) and -setAccent:
// @0x18C74 is a 64-byte retain/store object setter — the earlier BOOL
// typing was a transcription error. paint: below assigns
// [CAGradientLayer layer] to it and messages it as a layer; the
// disassembly settles the divergence (see phase2-appbridge.md closure §).
@property (nonatomic, strong) CAGradientLayer *accent;
@end

// -[ABKey paint:] @0x181DC — declared here for the key factory's
// [key paint:NO] call; the implementation is ABKey's own condensed
// body in the @implementation below (module B cosmetic scope).
@interface ABKey (ABKeyboardFactory)
- (void)paint:(BOOL)on;
@end


// ---------------------------------------------------------------------------
// ABKeyboard — singleton panel hosted in the CarPlay window.
// Ivars (objc.json): _app, _panel, _glass, _bubble, _field, _preview,
// _rows, _word (NSMutableString, current Telex word), _typed
// (NSMutableString, everything typed), _returnType, _numbers, _shift,
// _vietnamese, _langButton, _hideButton, _keysView.
// ---------------------------------------------------------------------------
@interface ABKeyboard : NSObject
@property (nonatomic, copy) NSString *app;
@property (nonatomic, strong) UIView *panel;
@property (nonatomic, strong) UIView *glass;
@property (nonatomic, strong) UILabel *bubble;
@property (nonatomic, strong) id field;
@property (nonatomic, strong) UILabel *preview;
@property (nonatomic, strong) NSArray *rows;
@property (nonatomic, strong) NSMutableString *word;
@property (nonatomic, strong) NSMutableString *typed;
@property (nonatomic) NSInteger returnType;
@property (nonatomic) BOOL numbers;
@property (nonatomic) BOOL shift;
@property (nonatomic) BOOL vietnamese;
@property (nonatomic, strong) UIButton *langButton;
@property (nonatomic, strong) UIButton *hideButton;
@property (nonatomic, strong) UIView *keysView;
+ (instancetype)shared;
- (void)showForApp:(NSString *)bundleID keyboardType:(NSInteger)keyboardType returnType:(NSInteger)returnType;
- (void)hideForApp:(NSString *)bundleID; // nil = force
- (void)send:(NSString *)action del:(NSUInteger)del text:(NSString *)text;
@end

// Internal methods, declared so this TU is warning-clean under
// -Werror (the original's private declarations are not recovered as a
// separate header; the set below is exactly the methods the
// @implementation defines and cross-calls).
@interface ABKeyboard ()
- (void)buildPanel;
- (void)layoutPanelIn:(UIView *)container;
- (void)rebuildKeys;
- (void)layoutKeys;
- (void)key:(ABKey *)key pressed:(BOOL)pressed;
- (ABKey *)key:(NSString *)label value:(NSString *)value command:(NSString *)command weight:(double)weight;
- (ABKey *)key:(NSString *)label symbol:(NSString *)symbol value:(NSString *)value command:(NSString *)command weight:(double)weight;
- (void)typeCharacter:(NSString *)ch;
- (void)keyTapped:(ABKey *)key;
- (void)hideTapped;
- (void)langTapped;
- (void)updatePreview;
@end

// ---------------------------------------------------------------------------
// Key-cap hint tables — contents VERIFIED in phase 2. In the binary
// these are two CONSTANT dictionaries (0x39630 = Vietnamese, 0x39658 =
// English) bound once into __bss slots 0x3EA70/0x3EA78 by the
// dispatch_once block @0x1D638 (helper sub_241E0, predicate 0x3EA80);
// rebuildKeys selects by self.vietnamese (csel @0x1B724) and looks up
// the lowercased character. Contents were resolved entry-by-entry
// from the constant-string pool (VI: keys @0x39020, values @0x39070;
// EN: keys @0x390C0, values @0x39190). The Vietnamese table maps the
// Telex tone keys (s/f/r/x/j) and vowel modifiers (a/d/e/o/w) to the
// character they produce; the English table maps each letter to its
// symbol partner. (The VI "s" value is U+00B4 ACUTE ACCENT, stored
// UTF-16 in the binary.)
// ---------------------------------------------------------------------------
static NSDictionary<NSString *, NSString *> *ABKeyHintTable(BOOL vietnamese) {
    static NSDictionary<NSString *, NSString *> *tableVI, *tableEN;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        tableVI = @{
            @"a": @"â", @"d": @"đ", @"e": @"ê", @"f": @"`", @"j": @".",
            @"o": @"ô", @"r": @"?", @"s": @"´", @"w": @"ư", @"x": @"~",
        };
        tableEN = @{
            @"a": @"@", @"b": @";", @"c": @"'", @"d": @"&", @"e": @"|",
            @"f": @"*", @"g": @"-", @"h": @"+", @"i": @">", @"j": @"(",
            @"k": @")", @"l": @"\"", @"m": @"?", @"n": @"!", @"o": @"{",
            @"p": @"}", @"q": @"%", @"r": @"=", @"s": @"#", @"t": @"[",
            @"u": @"<", @"v": @":", @"w": @"\\", @"x": @"$", @"y": @"]",
            @"z": @"_",
        };
    });
    return vietnamese ? tableVI : tableEN;
}

// ABKeyboard's full interface is below; ABKey's -setHighlighted: reports
// press edges to it. (In the original these are one translation unit.)
@interface ABKeyboard (ABKeyPressForward)
+ (instancetype)shared;
- (void)key:(ABKey *)key pressed:(BOOL)pressed;
@end

@implementation ABKey

// ---------------------------------------------------------------------------
// CLOSURE (phase-2 follow-up): the three bodies below were comment-only in
// module B's original delivery; they are reconstructed in full from
// disasm/m_ABKey_*.txt. Accent palette (raw __const doubles):
// colorA = (0.607843, 0.529412, 0.972549) @0x2B288..., colorB =
// (0.364706, 0.705882, 0.964706) @0x2B2A0... — the same palette as
// ABChromeViews' ABAccentColor1/2.
// ---------------------------------------------------------------------------

// -paint: @0x181DC (1528 B, disasm/m_ABKey_paint.txt) — VERIFIED.
// When lit and no gradient exists yet: build the accent gradient, insert
// it below everything, and give the key layer a colorA glow shadow.
// Then (always): gradient opacity follows `on`, background is clear when
// lit, pure white when on (unlit), restColor otherwise; tint is white
// when lit, restTint otherwise.
- (void)paint:(BOOL)on {
    if (self.lit && !self.accent) {
        CAGradientLayer *gradient = [CAGradientLayer layer];
        self.accent = gradient;
        gradient.colors = @[
            (id)[UIColor colorWithRed:0.6078431372549019 green:0.5294117647058824
                                 blue:0.9725490196078431 alpha:1.0].CGColor,
            (id)[UIColor colorWithRed:0.36470588235294116 green:0.7058823529411765
                                 blue:0.9647058823529412 alpha:1.0].CGColor];
        gradient.startPoint = CGPointMake(0, 0);
        gradient.endPoint = CGPointMake(1, 1);
        gradient.cornerRadius = 7;
        [self.layer insertSublayer:gradient atIndex:0];
        self.layer.shadowColor =
            [UIColor colorWithRed:0.6078431372549019 green:0.5294117647058824
                             blue:0.9725490196078431 alpha:1.0].CGColor;
        self.layer.shadowOpacity = 0.4f;   // float @0x2B3F8
        self.layer.shadowRadius = 6;
        self.layer.shadowOffset = CGSizeMake(0, 3);
    }
    self.accent.opacity = on ? 0.82f : 1.0f;   // 0.82f @0x2B3FC; nil-safe
    if (self.lit) {
        self.backgroundColor = [UIColor clearColor];
        self.tintColor = [UIColor whiteColor];
    } else {
        self.backgroundColor = on ? [UIColor colorWithRed:1 green:1 blue:1 alpha:1]
                                  : self.restColor;
        self.tintColor = self.restTint;
    }
}

// -setHighlighted: @0x187D4 (disasm/m_ABKey_setHighlighted.txt) — VERIFIED.
// No-op when the state is unchanged; otherwise super, repaint, springy
// scale animation (block @0x1894C sets the transform), and — for plain
// value keys only — report the press edge to the keyboard.
- (void)setHighlighted:(BOOL)highlighted {
    if (highlighted == self.isHighlighted) return;
    [super setHighlighted:highlighted];
    [self paint:highlighted];
    [UIView animateWithDuration:(highlighted ? 0.08 : 0.3) delay:0
         usingSpringWithDamping:(highlighted ? 1.0 : 0.6)
          initialSpringVelocity:0 options:6
                     animations:^{
        self.transform = highlighted ? CGAffineTransformMakeScale(0.96, 0.96)
                                     : CGAffineTransformIdentity;
    } completion:nil];
    if (!self.command && self.value.length)
        [[ABKeyboard shared] key:self pressed:highlighted];
}

// -layoutSubviews @0x189C8 (disasm/m_ABKey_layoutSubviews.txt) — VERIFIED.
// The gradient tracks the key bounds with actions disabled; the hint
// label sits in the top-right 11x11 corner (13 pt from the right edge).
- (void)layoutSubviews {
    [super layoutSubviews];
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    self.accent.frame = self.bounds;
    [CATransaction commit];
    if (self.hint)
        self.hint.frame = CGRectMake(self.bounds.size.width - 13, 0, 11, 11);
}

@end

@implementation ABKeyboard

// +shared (0x18D44): lazy singleton (once-token at 0x3EA58, instance slot
// 0x3EA50, compiler once-helper sub_241CC).
+ (instancetype)shared {
    static ABKeyboard *instance;
    static dispatch_once_t once;
    dispatch_once(&once, ^{ instance = [ABKeyboard new]; });
    return instance;
}

// -send:del:text: (0x1C81C) — producer of the NSDistributed key channel.
// Bails when no app is targeted. userInfo = {action, del: @(del)} plus
// text only when non-nil; object = self.app (per-app addressing).
- (void)send:(NSString *)action del:(NSUInteger)del text:(NSString *)text {
    if (!self.app) return;
    // [hl40-native-drawn] Native has a different authenticated ACK owner.
    // The original hosted appbridge.key route remains unchanged below.
    if (DC40NativeKeyboardRouteKey(action,del,text)) return;
    NSMutableDictionary *info = [@{@"action": action, @"del": @(del)} mutableCopy];
    if (text) info[@"text"] = text;
    [[NSDistributedNotificationCenter defaultCenter]
        postNotificationName:ABChanKey object:self.app userInfo:info];
}

// -showForApp:keyboardType:returnType: (0x18DB4, 1336 B) — proven flow:
//  * No CarPlay window ([ABHost shared].carWindow == nil) or nil bundleID
//    -> log "ban phim xe: khong co cua so (%@)" and return.
//  * "fresh" = (app differs) || (panel has no superview). Non-fresh shows
//    keep word/typed and skip the slide-in animation.
//  * vietnamese default: OMCPref(@"appBridgeKeyboardLang",
//    @([OMCCurrentLanguage() isEqualToString:@"vi"])); vietnamese =
//    (pref.intValue == 1). The writer side (keyTapped: "lang") stores
//    @(0/1) via CFPreferencesSetAppValue + OMCPrefsSync.
//  * numbers = keyboardType < 12 && ((0x934 >> keyboardType) & 1), i.e.
//    keyboardType in {2, 4, 5, 8, 11} starts on the numbers/symbols rows.
//  * shift reset to NO. Panel built lazily (buildPanel), added to the car
//    window if needed, layoutPanelIn: the window, brought to front,
//    rebuildKeys + updatePreview.
//  * Fresh shows animate: panel.transform starts at
//    translation(0, bounds.height + 12); a UIViewPropertyAnimator
//    (duration 0.35, UICubicTimingParameters control points (0.1, 0) and
//    (0.1, 1)) animates it to identity (animation block sub_192EC).
//  * Logs "ban phim xe: hien cho %@ (kieu %ld, phim enter %ld)".
- (void)showForApp:(NSString *)bundleID keyboardType:(NSInteger)keyboardType returnType:(NSInteger)returnType {
    UIWindow *carWindow = DC40NativeKeyboardHostWindow();
    if (!carWindow) carWindow = [[ABHost shared] carWindow];
    if (!bundleID || !carWindow) {
        OMCLogWrite(@"AppBridge", [NSString stringWithFormat:@"ban phim xe: khong co cua so (%@)", bundleID]);
        return;
    }
    BOOL fresh = ![bundleID isEqualToString:self.app] || self.panel.superview == nil;
    self.app = bundleID;
    self.returnType = returnType;
    NSNumber *langDefault = @([OMCCurrentLanguage() isEqualToString:@"vi"] ? 1 : 0);
    self.vietnamese = [OMCPref(@"appBridgeKeyboardLang", langDefault) intValue] == 1;
    self.numbers = (keyboardType < 12) && ((0x934 >> keyboardType) & 1);
    self.shift = NO;
    if (fresh) {
        self.word = [NSMutableString string];
        self.typed = [NSMutableString string];
    }
    if (!self.panel) [self buildPanel];
    if (self.panel.superview != carWindow) [carWindow addSubview:self.panel];
    [self layoutPanelIn:carWindow];
    [carWindow bringSubviewToFront:self.panel];
    [self rebuildKeys];
    [self updatePreview];
    if (fresh) {
        CGRect b = self.panel.bounds;
        self.panel.transform = CGAffineTransformMakeTranslation(0, b.size.height + 12);
        UICubicTimingParameters *timing = [[UICubicTimingParameters alloc]
            initWithControlPoint1:CGPointMake(0.1, 0) controlPoint2:CGPointMake(0.1, 1)];
        UIViewPropertyAnimator *anim = [[UIViewPropertyAnimator alloc]
            initWithDuration:0.35 timingParameters:timing];
        [anim addAnimations:^{ self.panel.transform = CGAffineTransformIdentity; }];
        [anim startAnimation];
    }
    OMCLogWrite(@"AppBridge", [NSString stringWithFormat:
        @"ban phim xe: hien cho %@ (kieu %ld, phim enter %ld)",
        bundleID, (long)keyboardType, (long)returnType]);
}

// -hideForApp: (0x1935C, 684 B) — proven flow:
//  * self.app == nil -> no-op. A non-nil argument that differs from
//    self.app -> no-op (another app's keyboard stays).
//  * Logs "ban phim xe: an (%@)" (with the CURRENT app), clears app,
//    clears any pressed-key bubble via key:nil pressed:NO, then animates
//    out with the mirror animator (duration 0.25, same timing curve):
//    animations block sub_19608 sets transform =
//    translation(0, bounds.height + 12); completion block sub_19664:
//    if self.app is still nil, removeFromSuperview and reset transform.
- (void)hideForApp:(NSString *)bundleID {
    if (!self.app) return;
    if (bundleID && ![bundleID isEqualToString:self.app]) return;
    OMCLogWrite(@"AppBridge", [NSString stringWithFormat:@"ban phim xe: an (%@)", self.app]);
    self.app = nil;
    [self key:nil pressed:NO];
    UIView *panel = self.panel;
    UICubicTimingParameters *timing = [[UICubicTimingParameters alloc]
        initWithControlPoint1:CGPointMake(0.1, 0) controlPoint2:CGPointMake(0.1, 1)];
    UIViewPropertyAnimator *anim = [[UIViewPropertyAnimator alloc]
        initWithDuration:0.25 timingParameters:timing];
    [anim addAnimations:^{
        panel.transform = CGAffineTransformMakeTranslation(0, panel.bounds.size.height + 12);
    }];
    [anim addCompletion:^(UIViewAnimatingPosition position) {
        if (!self.app) {
            [panel removeFromSuperview];
            panel.transform = CGAffineTransformIdentity;
        }
    }];
    [anim startAnimation];
}

// -typeCharacter: (0x1CA2C, 936 B) — proven flow:
//  * Telex: if vietnamese && word.length + 1 <= 11, result =
//    ABTelexApply(word, ch); else result = nil.
//  * isLetter = [letterCharacterSet characterIsMember:ch[0]] (computed in
//    both paths).
//  * If result: send:@"type" del:word.length text:result; if
//    typed.length >= word.length, delete the old word's tail range
//    {typed.length - word.length, word.length} from typed; typed += result;
//    word = result.
//  * Else: send:@"type" del:0 text:ch; typed += ch; if isLetter,
//    word += ch, else word = @"".
- (void)typeCharacter:(NSString *)ch {
    NSString *result = nil;
    if (self.vietnamese && self.word.length + 1 <= 11)
        result = ABTelexApply(self.word, ch);
    BOOL isLetter = [[NSCharacterSet letterCharacterSet]
        characterIsMember:[ch characterAtIndex:0]];
    if (result) {
        NSUInteger wordLen = self.word.length;
        [self send:@"type" del:wordLen text:result];
        if (self.typed.length >= wordLen)
            [self.typed deleteCharactersInRange:
                NSMakeRange(self.typed.length - wordLen, wordLen)];
        [self.typed appendString:result];
        [self.word setString:result];
    } else {
        [self send:@"type" del:0 text:ch];
        [self.typed appendString:ch];
        if (isLetter) [self.word appendString:ch];
        else [self.word setString:@""];
    }
}

// -keyTapped: (0x1CDD4, 1136 B) — proven dispatch on key.command, all
// inside @try/@catch that logs "ban phim xe: loi phim %@" (the exception):
//  * command == nil or @"space": typeCharacter:(key.value); if shift was
//    on, shift = NO + rebuildKeys; then the common tail.
//  * @"del": send:@"type" del:1 text:nil; delete last char of typed (if
//    any) and of word (if any); common tail.
//  * @"shift": shift = !shift; rebuildKeys; common tail.
//  * @"mode": numbers = !numbers; shift = NO; rebuildKeys; common tail.
//  * @"lang": vietnamese = !vietnamese; word = @""; persist
//    CFPreferencesSetAppValue(@"appBridgeKeyboardLang", @(vietnamese),
//    @"com.anlai.omnicar") + OMCPrefsSync(); rebuildKeys; common tail.
//  * @"ret": word = @""; send:@"return" del:0 text:nil; common tail.
//  Common tail: updatePreview; bring panel to front in its superview.
- (void)keyTapped:(ABKey *)key {
    @try {
        NSString *command = key.command;
        if (!command || [command isEqualToString:@"space"]) {
            [self typeCharacter:key.value];
            if (self.shift) {
                self.shift = NO;
                [self rebuildKeys];
            }
        } else if ([command isEqualToString:@"del"]) {
            [self send:@"type" del:1 text:nil];
            if (self.typed.length)
                [self.typed deleteCharactersInRange:NSMakeRange(self.typed.length - 1, 1)];
            if (self.word.length)
                [self.word deleteCharactersInRange:NSMakeRange(self.word.length - 1, 1)];
        } else if ([command isEqualToString:@"shift"]) {
            self.shift = !self.shift;
            [self rebuildKeys];
        } else if ([command isEqualToString:@"mode"]) {
            self.numbers = !self.numbers;
            self.shift = NO;
            [self rebuildKeys];
        } else if ([command isEqualToString:@"lang"]) {
            self.vietnamese = !self.vietnamese;
            [self.word setString:@""];
            CFPreferencesSetAppValue(CFSTR("appBridgeKeyboardLang"),
                (__bridge CFTypeRef)@(self.vietnamese), CFSTR("com.anlai.omnicar"));
            OMCPrefsSync();
            [self rebuildKeys];
        } else if ([command isEqualToString:@"ret"]) {
            [self.word setString:@""];
            [self send:@"return" del:0 text:nil];
        }
        [self updatePreview];
        [self.panel.superview bringSubviewToFront:self.panel];
    } @catch (NSException *exception) {
        OMCLogWrite(@"AppBridge",
            [NSString stringWithFormat:@"ban phim xe: loi phim %@", exception]);
    }
}

// -hideTapped (0x1D244): send:@"dismiss" del:0 text:nil, then
// hideForApp:nil (force hide).
- (void)hideTapped {
    [self send:@"dismiss" del:0 text:nil];
    [self hideForApp:nil];
}

// -langTapped (0x1C7B8): routes a synthetic lang key through keyTapped::
// [self keyTapped:[self key:nil value:nil command:@"lang" weight:1.0]].
- (void)langTapped {
    [self keyTapped:[self key:nil value:nil command:@"lang" weight:1.0]];
}

// -updatePreview (0x1C5C8) — proven:
//  * typed non-empty: preview.text = typed, textColor = the dark color
//    built from the constant components at 0x2B218/0x2B220/0x2B228, alpha 1.
//  * typed empty: preview.text = placeholder via OMCTr — vietnamese:
//    OMCTr(@"Gõ tiếng Việt kiểu Telex", @"Vietnamese (Telex)"); else
//    OMCTr(@"Gõ để nhập vào app", @"Type into the app"); same color at
//    alpha 0.6.
- (void)updatePreview {
    if (self.typed.length) {
        self.preview.text = self.typed;
        self.preview.textColor = [UIColor colorWithRed:0.16 green:0.24 blue:0.0625 alpha:1.0];
    } else {
        self.preview.text = self.vietnamese
            ? OMCTr(@"Gõ tiếng Việt kiểu Telex", @"Vietnamese (Telex)")
            : OMCTr(@"Gõ để nhập vào app", @"Type into the app");
        self.preview.textColor = [UIColor colorWithRed:0.16 green:0.24 blue:0.0625 alpha:0.6];
    }
}

// ---------------------------------------------------------------------------
// Panel construction & layout — phase 2 (2026-11-08): all five bodies
// below were reconstructed instruction-level from the dumps and
// replace the phase-1 condensed summaries. Palette constants recur
// across the keyboard: "slate" = (74, 79, 128)/255 (doubles at
// 0x2B218/0x2B220/0x2B228) and the shadow violet (110, 100, 200)/255
// (0x2B240/0x2B248/0x2B250), both read numerically from __const.
// ---------------------------------------------------------------------------

// -buildPanel (0x1A200, 2480 B, disasm/m_ABKeyboard_buildPanel.txt) —
// VERIFIED. Builds the whole panel tree; self.panel is stored LAST
// (@0x1A9D8), after every subview exists.
- (void)buildPanel {
    UIView *panel = [UIView new];
    panel.backgroundColor = [UIColor clearColor];
    panel.layer.shadowColor = [UIColor colorWithRed:110.0 / 255.0 green:100.0 / 255.0
                                                blue:200.0 / 255.0 alpha:1.0].CGColor;
    panel.layer.shadowOpacity = 0.3f; // float at 0x2B388
    panel.layer.shadowRadius = 20;
    panel.layer.shadowOffset = CGSizeMake(0, 6);
    panel.autoresizingMask = 0;

    UIVisualEffectView *glass = [[UIVisualEffectView alloc]
        initWithEffect:[UIBlurEffect effectWithStyle:11]]; // SystemUltraThinMaterialLight
    glass.contentView.backgroundColor = [UIColor clearColor];
    UIImageView *mesh = [[UIImageView alloc] initWithImage:OMCLogoMeshImage(0)];
    mesh.frame = glass.contentView.bounds;
    mesh.contentMode = UIViewContentModeScaleToFill; // 0
    mesh.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight; // 0x12
    [glass.contentView addSubview:mesh];
    glass.layer.cornerRadius = 20;
    glass.layer.cornerCurve = kCACornerCurveContinuous;
    glass.layer.borderWidth = 1;
    glass.layer.borderColor = [UIColor colorWithWhite:1.0 alpha:0.85].CGColor; // alpha at 0x2B258
    glass.clipsToBounds = YES;
    glass.userInteractionEnabled = NO;
    [panel addSubview:glass];
    self.glass = glass;

    UIView *field = [UIView new];
    field.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.85];
    field.layer.cornerRadius = 12;
    field.layer.cornerCurve = kCACornerCurveContinuous;
    field.layer.borderWidth = 1;
    field.layer.borderColor = [UIColor whiteColor].CGColor;
    [panel addSubview:field];
    self.field = field;

    UILabel *preview = [UILabel new];
    preview.font = [UIFont systemFontOfSize:13 weight:UIFontWeightMedium];
    preview.lineBreakMode = NSLineBreakByTruncatingHead; // 3
    [field addSubview:preview];
    self.preview = preview;

    UIButton *langButton = [UIButton buttonWithType:0];
    langButton.titleLabel.font = [UIFont systemFontOfSize:10.5 weight:UIFontWeightSemibold];
    [langButton setTitleColor:[UIColor colorWithRed:74.0 / 255.0 green:79.0 / 255.0
                                                blue:128.0 / 255.0 alpha:1.0]
                     forState:0];
    langButton.layer.borderWidth = 1;
    langButton.layer.borderColor = [[UIColor colorWithRed:74.0 / 255.0 green:79.0 / 255.0
                                                      blue:128.0 / 255.0 alpha:1.0]
        colorWithAlphaComponent:0.25].CGColor;
    langButton.layer.cornerRadius = 6;
    [langButton addTarget:self action:@selector(langTapped)
         forControlEvents:UIControlEventTouchUpInside]; // 0x40
    [panel addSubview:langButton];
    self.langButton = langButton;

    UIButton *hideButton = [UIButton buttonWithType:0];
    [hideButton setImage:[UIImage systemImageNamed:@"keyboard.chevron.compact.down"
        withConfiguration:[UIImageSymbolConfiguration configurationWithPointSize:16
                                                                           weight:UIImageSymbolWeightMedium]] // 5
                forState:0];
    hideButton.tintColor = [UIColor colorWithRed:74.0 / 255.0 green:79.0 / 255.0
                                            blue:128.0 / 255.0 alpha:1.0];
    [hideButton addTarget:self action:@selector(hideTapped)
         forControlEvents:UIControlEventTouchUpInside];
    [panel addSubview:hideButton];
    self.hideButton = hideButton;

    UIView *keysView = [UIView new];
    [panel addSubview:keysView];
    self.keysView = keysView;

    self.panel = panel;
}

// -layoutPanelIn: (0x196D0, 764 B, disasm/m_ABKeyboard_layoutPanelIn.txt)
// — VERIFIED. The usable rect is the car app area intersected with the
// container bounds (only when the area is wider than 100; an empty
// intersection falls back to the full bounds). Panel height derives
// from the CONTAINER height (0.78 factor at 0x2B3A8, capped at 280,
// 0x2B3B0); the x clamp's upper bound is the container width minus
// the panel width (fsub @0x1981C reads the bounds register, not the
// intersection's).
- (void)layoutPanelIn:(UIView *)container {
    CGRect bounds = container.bounds;
    CGRect area = (container == DC40NativeKeyboardHostWindow())
        ? CGRectZero : [ABHost shared].carAppArea;
    CGRect rect = bounds;
    if (area.size.width > 100.0) rect = CGRectIntersection(area, bounds);
    if (CGRectIsEmpty(rect)) rect = bounds;
    double panelW = MAX(rect.size.width - 12.0, 200.0);
    double panelH = MIN(floor(bounds.size.height * 0.78), 280.0);
    double x = MIN(MAX(CGRectGetMinX(rect) + 6.0, 0.0), bounds.size.width - panelW);
    double y = CGRectGetMaxY(bounds) - panelH - 6.0;
    self.panel.frame = CGRectMake(x, y, panelW, panelH);
    self.glass.frame = self.panel.bounds;
    self.panel.layer.shadowPath =
        [UIBezierPath bezierPathWithRoundedRect:self.panel.bounds cornerRadius:20].CGPath;
}

// -rebuildKeys (0x1B430, 2860 B, disasm/m_ABKeyboard_rebuildKeys.txt) —
// VERIFIED. Row strings are two constant arrays in the binary
// (numbers mode @0x39468, letters mode @0x39480), contents resolved
// from the constant-string pool in phase 2. The "plain" flag
// (csinc @0x1B628: plain = (rowIndex == 0) || numbers) suppresses
// both shift-casing and the hint label — row 0 is the digit row in
// BOTH modes, which is what makes the flag's shape sensible.
- (void)rebuildKeys {
    for (UIView *sub in [self.keysView.subviews copy]) [sub removeFromSuperview];
    NSMutableArray *rows = [NSMutableArray array];
    self.rows = rows;
    [self.langButton setTitle:(self.vietnamese ? @"VI" : @"EN") forState:0];
    NSArray<NSString *> *rowStrings = self.numbers
        ? @[@"1234567890", @"[]{}#%^*+=", @"-/:;()$&@\"", @".,?!'"]
        : @[@"1234567890", @"qwertyuiop", @"asdfghjkl", @"zxcvbnm"];
    NSUInteger rowCount = rowStrings.count;
    for (NSUInteger ri = 0; ri < rowCount; ri++) {
        NSString *rowString = rowStrings[ri];
        NSMutableArray *row = [NSMutableArray array];
        BOOL plain = (ri == 0) || self.numbers;
        for (NSUInteger ci = 0; ci < rowString.length; ci++) {
            NSString *ch = [rowString substringWithRange:NSMakeRange(ci, 1)];
            NSString *label = (!plain && self.shift) ? ch.uppercaseString : ch;
            ABKey *key = [self key:label value:label command:nil weight:1.0];
            if (!plain) {
                NSString *hintText = ABKeyHintTable(self.vietnamese)[[ch lowercaseString]];
                if (hintText) {
                    UILabel *hint = [UILabel new];
                    hint.text = hintText;
                    hint.font = [UIFont systemFontOfSize:8];
                    hint.textColor = [UIColor colorWithRed:74.0 / 255.0 green:79.0 / 255.0
                                                      blue:128.0 / 255.0 alpha:0.55]; // alpha at 0x2B2D0
                    hint.textAlignment = NSTextAlignmentCenter; // 1
                    hint.userInteractionEnabled = NO;
                    [key addSubview:hint];
                    key.hint = hint;
                }
            }
            [row addObject:key];
        }
        if (ri == rowCount - 1) {
            ABKey *first;
            if (self.numbers) {
                first = [self key:@"#" value:@"#" command:nil weight:1.5];
            } else {
                first = [self key:nil symbol:(self.shift ? @"shift.fill" : @"shift")
                            value:nil command:@"shift" weight:1.5];
            }
            [row insertObject:first atIndex:0];
            [row addObject:[self key:nil symbol:@"delete.left" value:nil
                             command:@"del" weight:1.5]];
        }
        [rows addObject:row];
    }
    // Bottom row (weights at 0x2B368/0x2B3D0/0x2B3D8/0x2B2F8, read
    // numerically: 1.4 / 1.1 / 4.2 / 1.8).
    ABKey *mode = [self key:(self.numbers ? @"ABC" : @"#+=") value:nil command:@"mode" weight:1.4];
    ABKey *lang = [self key:nil symbol:@"globe" value:nil command:@"lang" weight:1.1];
    ABKey *comma = [self key:@"," value:@"," command:nil weight:1.0];
    ABKey *space = [self key:(self.vietnamese ? @"Tiếng Việt" : @"space")
                       value:@" " command:@"space" weight:4.2];
    ABKey *period = [self key:@"." value:@"." command:nil weight:1.0];
    ABKey *ret = [self key:nil symbol:@"return" value:nil command:@"ret" weight:1.8];
    [rows addObject:@[mode, lang, comma, space, period, ret]];
    for (NSArray *row in rows)
        for (ABKey *key in row)
            [self.keysView addSubview:key];
    [self layoutKeys];
}

// -layoutKeys (0x1BF5C, 1644 B, disasm/m_ABKeyboard_layoutKeys.txt) —
// VERIFIED. Header chrome is framed from the panel bounds first
// (hide 34x24 at the top right, lang 26x16 left of it, field filling
// the rest of the header row, preview inset 10/0 inside the field),
// then keysView gets the remaining strip (y 33 at 0x2B2E8, height
// adjustment -33 at 0x2B3E0). Rows share the keysView height with
// 5 pt gaps; a row's unit width is avail/totalWeight, except the
// last two rows and any row of 10+ keys use the raw quotient —
// shorter letter rows are capped at (keysWidth - 45)/10 (addend at
// 0x2B3E8) so they keep the 10-key unit and stay centered. Keys with
// no command get the shared row font (rowH * 0.56 at 0x2B3F0,
// floored, minimum 14).
- (void)layoutKeys {
    CGRect pb = self.panel.bounds;
    double W = pb.size.width, H = pb.size.height;
    self.hideButton.frame = CGRectMake(W - 39.0, 5, 34, 24);
    double langX = CGRectGetMinX(self.hideButton.frame);
    self.langButton.frame = CGRectMake(langX - 30.0, 9, 26, 16);
    double fieldX = CGRectGetMinX(self.langButton.frame);
    UIView *field = self.field;
    field.frame = CGRectMake(fieldX - 8.0, 5, fieldX - 13.0, 24);
    self.preview.frame = CGRectInset(field.bounds, 10, 0);
    self.keysView.frame = CGRectMake(5, 33, W - 10, H - 38);
    CGRect kb = self.keysView.bounds;
    NSUInteger n = self.rows.count;
    double rowH = floor((kb.size.height - 5.0 * (double)(n - 1)) / (double)n);
    UIFont *font = [UIFont systemFontOfSize:MAX(floor(rowH * 0.56), 14.0)];
    if (n == 0) return; // the binary's cbz @0x1C22C sits here, after
                        // the font is built
    double unitCap = (kb.size.width - 45.0) / 10.0;
    for (NSUInteger r = 0; r < n; r++) {
        NSArray *row = self.rows[r];
        double totalW = 0;
        for (ABKey *key in row) totalW += key.weight;
        double avail = kb.size.width - 5.0 * (double)(row.count - 1);
        double unit;
        if (r >= n - 2 || row.count >= 10) unit = avail / totalW;
        else unit = MIN(unitCap, avail / totalW);
        double x = (kb.size.width - (unit * totalW + 5.0 * (double)(row.count - 1))) * 0.5;
        double y = (double)r * (rowH + 5.0);
        for (ABKey *key in row) {
            double w = unit * key.weight;
            key.frame = CGRectMake(x, y, w, rowH);
            if (!key.command) key.titleLabel.font = font;
            x += unit * key.weight + 5.0;
        }
    }
}

// -key:pressed: (0x199CC, 1964 B, disasm/m_ABKeyboard_key_pressed.txt)
// — VERIFIED. Purely visual: the bubble is a label floated above the
// pressed key (anchorPoint (0.5, 1) so the spring scale grows from
// the key). Any guard failure — not pressed, key not in a hierarchy,
// no panel — takes the hide path: a 0.12 s fade of the bubble to
// alpha 0 (duration at 0x2B1F8; block sub_1A178 touches only
// self.bubble.alpha). hideForApp: relies on this via key:nil.
- (void)key:(ABKey *)key pressed:(BOOL)pressed {
    if (!pressed || !key.superview || !self.panel) {
        [UIView animateWithDuration:0.12 animations:^{ self.bubble.alpha = 0; }];
        return;
    }
    if (!self.bubble) {
        UILabel *bubble = [UILabel new];
        bubble.backgroundColor = [UIColor whiteColor];
        bubble.textColor = [UIColor colorWithRed:74.0 / 255.0 green:79.0 / 255.0
                                            blue:128.0 / 255.0 alpha:1.0];
        bubble.textAlignment = NSTextAlignmentCenter; // 1
        bubble.layer.cornerRadius = 9;
        bubble.layer.cornerCurve = kCACornerCurveContinuous;
        bubble.layer.masksToBounds = NO;
        bubble.layer.shadowColor = [UIColor colorWithRed:110.0 / 255.0 green:100.0 / 255.0
                                                    blue:200.0 / 255.0 alpha:1.0].CGColor;
        bubble.layer.shadowOpacity = 0.3f; // float at 0x2B388
        bubble.layer.shadowRadius = 9;
        bubble.layer.shadowOffset = CGSizeMake(0, 6);
        bubble.userInteractionEnabled = NO;
        self.bubble = bubble;
    }
    if (self.bubble.superview != self.panel) [self.panel addSubview:self.bubble];
    CGRect rect = [self.panel convertRect:key.bounds fromView:key];
    double kw = key.bounds.size.width, kh = key.bounds.size.height;
    double bw = round(kw * 1.3);  // frinta, factor at 0x2B3B8
    double bh = round(kh * 1.45); // frinta, factor at 0x2B3C0
    double bx = MIN(MAX(CGRectGetMidX(rect) - bw * 0.5, 2.0),
                    self.panel.bounds.size.width - bw - 2.0);
    double by = (CGRectGetMidY(rect) - kh * 0.5) - bh + 2.0;
    self.bubble.transform = CGAffineTransformIdentity;
    self.bubble.layer.anchorPoint = CGPointMake(0.5, 1);
    self.bubble.frame = CGRectMake(bx, by, bw, bh);
    self.bubble.layer.shadowPath =
        [UIBezierPath bezierPathWithRoundedRect:self.bubble.bounds cornerRadius:9].CGPath;
    self.bubble.font = [UIFont systemFontOfSize:round(kh * 0.85)]; // factor at 0x2B258
    self.bubble.text = [key titleForState:0];
    [self.panel bringSubviewToFront:self.bubble];
    self.bubble.alpha = 1;
    self.bubble.transform = CGAffineTransformMakeScale(0.7, 0.7); // factor at 0x2B200
    [UIView animateWithDuration:0.18 delay:0 usingSpringWithDamping:0.62 // 0x2B2B8 / 0x2B3C8
          initialSpringVelocity:0.5
                        options:UIViewAnimationOptionBeginFromCurrentState // 4
                     animations:^{ self.bubble.transform = CGAffineTransformIdentity; } // block sub_1A1C4
                     completion:nil];
}

// -key:value:command:weight: (0x1B408): forwards to the 5-arg factory
// with symbol = nil (proven: 40-byte forwarder; argument shuffle
// x3->x4, x4->x5, x3=0). First argument is the key's display label
// (title), second its typed value — inferred from the 5-arg body, which
// sets the title from the first argument and the SF Symbol image when a
// symbol is given.
- (ABKey *)key:(NSString *)label value:(NSString *)v command:(NSString *)command weight:(double)weight {
    return [self key:label symbol:nil value:v command:command weight:weight];
}

// -key:symbol:value:command:weight: (0x1ABB0, 2136 B,
// disasm/m_ABKeyboard_key_symbol_value_command_weight.txt) —
// VERIFIED instruction-level in phase 2. Flag algebra from the dump:
//   isSpace = (command == "space"); isRet = (command == "ret");
//   special = (command == nil) || isSpace || isRet;
//   punct   = (command == nil) && (value == "," || value == ".")
//     (the value probes exist only on the nil-command path @0x1ACCC).
// restColor alpha is 0.9 (double at 0x2B208) when special && !punct,
// else 0.5. lit is YES for "ret", self.shift for "shift", else NO.
// The layer-styling block runs only when !lit; its borderWidth is
// (!special || punct) ? 1 : 0, and its borderColor reuses the same
// white/0.9. Title colour: space -> slate at alpha 0.55 (0x2B2D0);
// lit -> white; otherwise the key's restTint. Fonts: space -> 10 pt,
// special -> 17 pt, else 11 pt Semibold; adjustsFontSizeToFitWidth
// is set on ALL paths (the per-branch flags in the dump only steer
// ARC releases — every path converges on @0x1B224). The factory ends
// with [key paint:NO] and the keyTapped: target wiring.
- (ABKey *)key:(NSString *)label symbol:(NSString *)symbol value:(NSString *)value
       command:(NSString *)command weight:(double)weight {
    ABKey *key = [ABKey buttonWithType:0];
    key.value = value;
    key.command = command;
    key.weight = weight;
    BOOL isSpace = [command isEqualToString:@"space"];
    BOOL isRet = [command isEqualToString:@"ret"];
    BOOL special = (command == nil) || isSpace || isRet;
    BOOL punct = (command == nil) &&
        ([value isEqualToString:@","] || [value isEqualToString:@"."]);
    key.restColor = [UIColor colorWithRed:1 green:1 blue:1
                                    alpha:((special && !punct) ? 0.9 : 0.5)];
    if (isRet) key.lit = YES;
    else if ([command isEqualToString:@"shift"]) key.lit = self.shift;
    else key.lit = NO;
    key.restTint = [UIColor colorWithRed:74.0 / 255.0 green:79.0 / 255.0
                                    blue:128.0 / 255.0 alpha:1.0];
    if (!key.lit) {
        key.layer.cornerRadius = 7;
        key.layer.cornerCurve = kCACornerCurveContinuous;
        key.layer.borderWidth = (!special || punct) ? 1.0 : 0.0;
        key.layer.borderColor = [UIColor colorWithWhite:1.0 alpha:0.9].CGColor;
        key.layer.shadowColor = [UIColor colorWithRed:110.0 / 255.0 green:100.0 / 255.0
                                                  blue:200.0 / 255.0 alpha:1.0].CGColor;
        key.layer.shadowOpacity = 0.18f; // float at 0x2B400
        key.layer.shadowRadius = 1;
        key.layer.shadowOffset = CGSizeMake(0, 1);
    }
    if (symbol) {
        [key setImage:[UIImage systemImageNamed:symbol
            withConfiguration:[UIImageSymbolConfiguration configurationWithPointSize:15
                                                                               weight:UIImageSymbolWeightMedium]] // 5
                    forState:0];
    } else {
        [key setTitle:label forState:0];
    }
    if (isSpace) {
        [key setTitleColor:[UIColor colorWithRed:74.0 / 255.0 green:79.0 / 255.0
                                            blue:128.0 / 255.0 alpha:0.55] // alpha at 0x2B2D0
                  forState:0];
    } else if (key.lit) {
        [key setTitleColor:[UIColor whiteColor] forState:0];
    } else {
        [key setTitleColor:key.restTint forState:0];
    }
    if (isSpace) {
        key.titleLabel.font = [UIFont systemFontOfSize:10];
    } else if (special) {
        key.titleLabel.font = [UIFont systemFontOfSize:17];
    } else {
        key.titleLabel.font = [UIFont systemFontOfSize:11 weight:UIFontWeightSemibold];
    }
    key.titleLabel.adjustsFontSizeToFitWidth = YES;
    [key paint:NO];
    [key addTarget:self action:@selector(keyTapped:)
        forControlEvents:UIControlEventTouchUpInside]; // 0x40
    return key;
}

@end
