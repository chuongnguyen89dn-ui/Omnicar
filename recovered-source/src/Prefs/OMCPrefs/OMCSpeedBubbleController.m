// OMCSpeedBubbleController.m — OmniCarPrefs (reconstructed, Prefs-B)
// Evidence: src/Prefs/disasm/OMCSpeedBubbleController.asm (capstone,
// calibrated annotations). Preference keys/defaults are proven per getter
// below. The SPP* C helpers (SPPVoiceLine/SPPSpeak/SPPPlayTone/
// SPPVoiceIsFun) live in OMCCommon (Prefs-A) — see OMCCommon.h.
#import "OMCSpeedBubbleController.h"
#import "OMCCommon.h"
#import "SPPBubbleView.h"
#import <notify.h>
#import <objc/runtime.h>

static const char kSPPAssocKey;   // associated-object key for tile indices [VERIFIED: file-static key]

// The four speed sources. [VERIFIED: constant arrays decoded from the binary]
static NSArray<NSString *> *SPPSourceNames(void) {
    return @[@"Vietmap Live", @"GOFA", @"Waze", @"Wyn"];
}
static NSArray<NSString *> *SPPSourceBundleIDs(void) {
    return @[@"vn.vietmap.live", @"com.lumi.GOFA", @"com.waze.iphone", @"com.wynauto.wyn"];
}

// App icon for a source: private UIImage API when available, else a drawn
// glyph tile. Results cached per source. [VERIFIED: sub_2642c — cache dict,
// _applicationIconImageForBundleIdentifier:format:scale:, fallback colors
// #F07A12/#1AA260/#33CCFF/#E5322D and glyphs V/G/W/Y at 60pt]
static UIImage *SPPAppIconForSource(NSInteger source) {
    static NSMutableDictionary *cache;
    if (!cache) cache = [NSMutableDictionary dictionary];
    NSNumber *key = @(source);
    UIImage *cached = cache[key];
    if (cached) return cached;
    UIImage *img = nil;
    NSString *bid = (source >= 0 && source < 4) ? SPPSourceBundleIDs()[source] : nil;
    if (bid.length) {
        SEL sel = NSSelectorFromString(@"_applicationIconImageForBundleIdentifier:format:scale:");
        if ([UIImage respondsToSelector:sel]) {
            img = [UIImage _applicationIconImageForBundleIdentifier:bid
                                                              format:2
                                                               scale:[UIScreen mainScreen].scale];
        }
    }
    if (!img) {
        NSArray *colors = @[@"#F07A12", @"#1AA260", @"#33CCFF", @"#E5322D"];
        NSArray *glyphs = @[@"V", @"G", @"W", @"Y"];
        NSInteger i = MAX(0, MIN(3, source));
        UIGraphicsImageRenderer *renderer =
            [[UIGraphicsImageRenderer alloc] initWithSize:CGSizeMake(60, 60)];
        NSString *glyph = glyphs[i];
        img = [renderer imageWithActions:^(UIGraphicsImageRendererContext *ctx) {
            [OMCColorFromHex(colors[i]) setFill];
            UIRectFill(CGRectMake(0, 0, 60, 60));
            NSDictionary *attrs = @{NSFontAttributeName: [UIFont systemFontOfSize:28 weight:UIFontWeightHeavy],
                                    NSForegroundColorAttributeName: [UIColor whiteColor]};
            CGSize ts = [glyph sizeWithAttributes:attrs];
            [glyph drawAtPoint:CGPointMake((60 - ts.width) / 2, (60 - ts.height) / 2)
                withAttributes:attrs];
        }];
    }
    if (img) cache[key] = img;
    return img;
}

// Fake-map snapshot used behind the preview and the style cards.
// [VERIFIED palette: bg #EEF0EA, park ovals #CDECCF/#C8E4F7, roads
//  #FFE9A8 / white / #3D8BFF with round caps; road geometry INFERRED]
static UIImage *SPPMapImage(CGSize size) {
    UIGraphicsImageRendererFormat *fmt = [UIGraphicsImageRendererFormat preferredFormat];
    fmt.opaque = YES;
    UIGraphicsImageRenderer *renderer =
        [[UIGraphicsImageRenderer alloc] initWithSize:size format:fmt];
    return [renderer imageWithActions:^(UIGraphicsImageRendererContext *ctx) {
        CGFloat w = size.width, h = size.height;
        [OMCColorFromHex(@"#EEF0EA") setFill];
        UIRectFill(CGRectMake(0, 0, w, h));
        [OMCColorFromHex(@"#CDECCF") setFill];
        [[UIBezierPath bezierPathWithOvalInRect:CGRectMake(w * 0.62, h * 0.08, w * 0.3, h * 0.34)] fill];
        [OMCColorFromHex(@"#C8E4F7") setFill];
        [[UIBezierPath bezierPathWithOvalInRect:CGRectMake(w * 0.05, h * 0.6, w * 0.26, h * 0.3)] fill];
        CGContextSetLineCap(ctx.CGContext, kCGLineCapRound);
        [OMCColorFromHex(@"#FFE9A8") setStroke];
        UIBezierPath *r1 = [UIBezierPath bezierPath];
        r1.lineWidth = h * 0.09;
        [r1 moveToPoint:CGPointMake(-10, h * 0.68)];
        [r1 addLineToPoint:CGPointMake(w + 10, h * 0.4)];
        [r1 stroke];
        [[UIColor whiteColor] setStroke];
        UIBezierPath *r2 = [UIBezierPath bezierPath];
        r2.lineWidth = h * 0.06;
        [r2 moveToPoint:CGPointMake(w * 0.3, -10)];
        [r2 addLineToPoint:CGPointMake(w * 0.45, h + 10)];
        [r2 stroke];
        [OMCColorFromHex(@"#3D8BFF") setStroke];
        UIBezierPath *r3 = [UIBezierPath bezierPath];
        r3.lineWidth = h * 0.045;
        [r3 moveToPoint:CGPointMake(-10, h * 0.25)];
        [r3 addLineToPoint:CGPointMake(w + 10, h * 0.8)];
        [r3 stroke];
    }];
}

// Fits a bubble view into a frame: bounds = its render size, centered,
// uniformly scaled by min((fw-12)/rw, (fh-12)/rh) capped at maxScale.
// [VERIFIED: sub_26920]
static void SPPFitBubble(SPPBubbleView *bubble, CGRect frame, double maxScale) {
    CGSize rs = [bubble render];
    if (rs.width < 1 || rs.height < 1) return;
    double s = MIN((frame.size.width - 12) / rs.width, (frame.size.height - 12) / rs.height);
    s = MIN(s, maxScale);
    bubble.transform = CGAffineTransformIdentity;
    bubble.bounds = CGRectMake(0, 0, rs.width, rs.height);
    bubble.center = CGPointMake(CGRectGetMidX(frame), CGRectGetMidY(frame));
    bubble.transform = CGAffineTransformMakeScale((CGFloat)s, (CGFloat)s);
}

// Selection ring (conic gradient "omcRing") used by style/source tiles and
// color swatches. [VERIFIED: sub_2b2ec — removes any existing layer named
// "omcRing"; when on, adds a conic CAGradientLayer (frame = bounds inset
// -2.5, colors #A78BFA/#60C5FA/#5EDDB6/#F59AC0/#A78BFA, start (0.5,0.5),
// end (0,1)) masked by a CAShapeLayer rounded-rect (inset 1.25, stroke
// black, lineWidth 2.5)]
static void SPPSetRing(UIView *view, BOOL on) {
    CALayer *found = nil;
    for (CALayer *l in view.layer.sublayers) if ([l.name isEqualToString:@"omcRing"]) found = l;
    [found removeFromSuperlayer];
    if (!on) return;
    CAGradientLayer *ring = [CAGradientLayer layer];
    ring.name = @"omcRing";
    ring.type = kCAGradientLayerConic;
    ring.frame = CGRectInset(view.bounds, -2.5, -2.5);
    ring.startPoint = CGPointMake(0.5, 0.5);
    ring.endPoint = CGPointMake(0, 1);
    ring.colors = @[(id)OMCColorFromHex(@"#A78BFA").CGColor,
                    (id)OMCColorFromHex(@"#60C5FA").CGColor,
                    (id)OMCColorFromHex(@"#5EDDB6").CGColor,
                    (id)OMCColorFromHex(@"#F59AC0").CGColor,
                    (id)OMCColorFromHex(@"#A78BFA").CGColor];
    CAShapeLayer *mask = [CAShapeLayer layer];
    mask.path = [UIBezierPath bezierPathWithRoundedRect:CGRectInset(view.bounds, 1.25, 1.25)
                                           cornerRadius:12].CGPath;   // radius const 0x659f0 [INFERRED exact]
    mask.fillColor = NULL;
    mask.strokeColor = [UIColor blackColor].CGColor;
    mask.lineWidth = 2.5;
    ring.mask = mask;
    [view.layer addSublayer:ring];
}

@interface OMCSpeedBubbleController () <UITextFieldDelegate>
// Private helpers (all present in the binary; declared here for the compiler)
- (BOOL)on;
- (NSInteger)style;
- (NSInteger)source;
- (BOOL)showIcon;
- (NSInteger)warnMode;
- (NSInteger)ranged:(NSString *)key def:(NSInteger)def count:(NSInteger)count;
- (NSInteger)color;
- (NSInteger)warnFx;
- (BOOL)voiceSound;
- (NSInteger)tone;
- (NSInteger)voiceLine;
- (NSString *)voiceText;
- (int)shownLimit;
- (NSString *)sourceHint;
- (NSString *)sourceName:(NSInteger)i;
- (void)configure:(SPPBubbleView *)view style:(NSInteger)style speed:(int)speed limit:(int)limit;
- (void)tickLive;
- (NSArray *)buildWarnRows;
- (NSInteger)optionIndex:(NSString *)kind;
- (NSString *)optionText:(NSString *)kind;
- (BOOL)optionChosen:(NSString *)kind;
- (UIImageView *)playIcon:(BOOL)chosen;
- (UITableViewCell *)warnCell:(NSString *)kind width:(double)width;
- (void)layoutFxIn:(UIView *)box width:(double)width;
- (void)layoutColorsIn:(UIView *)box width:(double)width;
- (void)layoutStylesIn:(UIView *)box width:(double)width;
- (void)layoutSourcesIn:(UIView *)box width:(double)width;
- (void)fxTapped:(UIControl *)sender;
- (void)colorTapped:(UIControl *)sender;
- (void)styleTapped:(UIControl *)sender;
- (void)sourceTapped:(UIControl *)sender;
- (void)warnSwitchChanged:(UISwitch *)sender;
- (void)pickOption:(NSString *)kind;
- (void)playPreview;
- (void)customPlay;
- (void)tryOnCar;
- (void)resetLayout;
@end

@implementation OMCSpeedBubbleController

#pragma mark - Lifecycle

- (void)viewDidLoad {
    // One-time preference migrations, before super. [VERIFIED]
    CFPreferencesAppSynchronize(CFSTR("com.anlai.omnicar"));
    id src = [self prefForKey:@"speedBubbleSource" def:nil];
    if (src) {
        if (![[self prefForKey:@"speedBubbleSourceV2" def:(id)kCFBooleanFalse] boolValue]) {
            NSInteger v = [src integerValue];
            NSInteger nv = (v == 4) ? 2 : (v < 2 ? v : 0);
            CFPreferencesSetAppValue(CFSTR("speedBubbleSource"), (__bridge CFPropertyListRef)@(nv),
                                     CFSTR("com.anlai.omnicar"));
        }
    } else {
        id vm = [self prefForKey:@"speedBubbleAppVietmap" def:nil];
        id gf = [self prefForKey:@"speedBubbleAppGOFA" def:nil];
        NSInteger nv;
        if (!vm || [vm boolValue]) nv = 0;
        else if (!gf) nv = 1;
        else nv = [gf boolValue] ? 1 : 0;   // [INFERRED: boolValue moved into the int slot]
        CFPreferencesSetAppValue(CFSTR("speedBubbleSource"), (__bridge CFPropertyListRef)@(nv),
                                 CFSTR("com.anlai.omnicar"));
    }
    CFPreferencesSetAppValue(CFSTR("speedBubbleSourceV2"), kCFBooleanTrue,
                             CFSTR("com.anlai.omnicar"));
    if (![[self prefForKey:@"speedBubbleWarnModeV2" def:(id)kCFBooleanFalse] boolValue]) {
        if ([[self prefForKey:@"speedBubbleWarnMode" def:nil] integerValue] == 2)
            CFPreferencesSetAppValue(CFSTR("speedBubbleWarnMode"), (__bridge CFPropertyListRef)@3,
                                     CFSTR("com.anlai.omnicar"));
        CFPreferencesSetAppValue(CFSTR("speedBubbleWarnModeV2"), kCFBooleanTrue,
                                 CFSTR("com.anlai.omnicar"));
    }
    CFPreferencesAppSynchronize(CFSTR("com.anlai.omnicar"));
    [super viewDidLoad];
    if (!self.title.length) self.title = L(@"SPEEDBUBBLE");
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.liveTimer invalidate];
    self.liveStart = CACurrentMediaTime();
    __weak typeof(self) weakSelf = self;
    self.liveTimer = [NSTimer scheduledTimerWithTimeInterval:0.15 repeats:YES
                                                         block:^(NSTimer *t) {
        (void)t;
        [weakSelf tickLive];
    }];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.liveTimer invalidate];
    self.liveTimer = nil;
}

#pragma mark - Preference readers (domain com.anlai.omnicar; all VERIFIED)

- (BOOL)on         { return [[self prefForKey:@"speedBubbleEnabled" def:(id)kCFBooleanTrue] boolValue]; }
- (NSInteger)style {
    NSInteger v = [self intForKey:@"speedBubbleLook" def:0];
    return v < 9 ? v : 0;
}
- (NSInteger)source {
    NSInteger v = [self intForKey:@"speedBubbleSource" def:0];
    return (v >= 0 && v < (NSInteger)SPPSourceNames().count) ? v : 0;
}
- (BOOL)showIcon   { return [[self prefForKey:@"speedBubbleShowAppIcon" def:(id)kCFBooleanTrue] boolValue]; }
- (NSInteger)warnMode {
    NSInteger v = [self intForKey:@"speedBubbleWarnMode" def:3];
    return v < 3 ? v : 3;
}
- (NSInteger)ranged:(NSString *)key def:(NSInteger)def count:(NSInteger)count {
    NSInteger v = [self intForKey:key def:def];
    return (v < 0 || v >= count) ? def : v;
}
- (NSInteger)color     { return [self ranged:@"speedBubbleColor" def:0 count:7]; }
- (NSInteger)warnFx    { return [self ranged:@"speedBubbleWarnFx" def:0 count:4]; }
- (BOOL)voiceSound     { return [self ranged:@"speedBubbleWarnSound" def:0 count:2] == 1; }
- (NSInteger)tone      { return [self ranged:@"speedBubbleWarnTone" def:0 count:6]; }
- (NSInteger)voiceLine { return [self ranged:@"speedBubbleWarnVoice" def:0 count:9]; }
- (NSString *)voiceText {
    id v = [self prefForKey:@"speedBubbleWarnVoiceText" def:@""];
    return [v isKindOfClass:[NSString class]] ? v : @"";
}
- (int)shownLimit { return 60; }   // [VERIFIED: constant 0x3c]
- (NSString *)sourceHint {
    return [@"ⓘ  " stringByAppendingString:
            L([NSString stringWithFormat:@"SPEEDBUBBLE_SRC_HINT_%ld", (long)[self source]])];
}
- (NSString *)sourceName:(NSInteger)i { return SPPSourceNames()[i]; }

#pragma mark - Live preview

- (void)configure:(SPPBubbleView *)view style:(NSInteger)style speed:(int)speed limit:(int)limit {
    view.style = style;
    view.speed = speed;
    view.limit = limit;
    view.showIcon = [self showIcon];
    view.iconImage = SPPAppIconForSource([self source]);
    view.color = [self color];
}

- (void)tickLive {
    if (!self.live || !self.live.window) return;
    double elapsed = CACurrentMediaTime() - self.liveStart;
    double wave = 0.5 - 0.5 * cos(elapsed * 0.45);
    int speed = (int)(60 * (0.55 + 0.65 * wave));   // 33…72 km/h [VERIFIED formula]
    [self configure:self.live style:[self style] speed:speed limit:60];
    SPPFitBubble(self.live, self.liveMap.frame, 0.95);
}

- (void)prefChanged:(NSString *)key {
    if ([key isEqualToString:@"speedBubbleEnabled"]) {
        [self.table reloadData];
    } else if ([key isEqualToString:@"speedBubbleShowAppIcon"] ||
               [key isEqualToString:@"speedBubbleColor"]) {
        self.stripOffset = self.styleStrip.contentOffset.x;
        [self reloadSection:2];
    } else if ([@[@"speedBubbleWarnMode", @"speedBubbleWarnFx", @"speedBubbleWarnSound",
                  @"speedBubbleWarnTone", @"speedBubbleWarnVoice"] containsObject:key] ||
               [key isEqualToString:@"speedBubbleWarnOver"]) {
        [self reloadSection:5];
    }
    [self tickLive];
}

#pragma mark - Table structure

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tv { (void)tv; return 6; }

- (NSInteger)tableView:(UITableView *)tv numberOfRowsInSection:(NSInteger)section {
    (void)tv;
    if (section == 2 || section == 3) return 3;
    if (section == 4) return 2;
    if (section == 5) return (NSInteger)[self buildWarnRows].count;
    return 1;
}

- (NSString *)tableView:(UITableView *)tv titleForHeaderInSection:(NSInteger)section {
    (void)tv;
    // Jump table of localization keys for sections 2..5. [VERIFIED structure;
    // exact keys live in the table at 0x74ba0 — section 5's is the warn group.
    // INFERRED key names for 2..4]
    switch (section) {
        case 2: return L(@"SPEEDBUBBLE_STYLE");
        case 3: return L(@"SPEEDBUBBLE_SIZE");
        case 4: return L(@"SPEEDBUBBLE_SOURCE");
        case 5: return L(@"SPEEDBUBBLE_WARN");
        default: return nil;
    }
}

- (NSString *)tableView:(UITableView *)tv titleForFooterInSection:(NSInteger)section {
    (void)tv;
    if (section == 2) return L(@"SPEEDBUBBLE_COLOR_FOOTER");
    if (section == 3) return L(@"SPEEDBUBBLE_GESTURES_FOOTER");
    if (section != 5) return nil;
    NSInteger mode = [self warnMode];
    if (mode == 0) return L(@"SPEEDBUBBLE_WARN_OFF_FOOTER");
    NSInteger over = [self intForKey:@"speedBubbleWarnOver" def:5];
    NSString *head;
    NSString *mag = [NSString stringWithFormat:@"%ld km/h", (long)labs(over)];
    if (over > 0)      head = [NSString stringWithFormat:L(@"SPEEDBUBBLE_WARN_TH_OVER"), mag];
    else if (over < 0) head = [NSString stringWithFormat:L(@"SPEEDBUBBLE_WARN_TH_UNDER"), mag];
    else               head = [NSString stringWithFormat:L(@"SPEEDBUBBLE_WARN_TH_AT"), mag];
    NSMutableArray *parts = [NSMutableArray array];
    if (mode & 1) [parts addObject:L([NSString stringWithFormat:@"SPEEDBUBBLE_FX_DESC_%ld", (long)[self warnFx]])];
    if (mode & 2) {
        if ([self voiceSound])
            [parts addObject:[NSString stringWithFormat:L(@"SPEEDBUBBLE_VOICE_DESC"),
                              SPPVoiceLine([self voiceText], [self voiceLine], [self shownLimit])]];
        else
            [parts addObject:L([NSString stringWithFormat:@"SPEEDBUBBLE_TONE_DESC_%ld", (long)[self tone]])];
    }
    return [NSString stringWithFormat:L(@"SPEEDBUBBLE_WARN_FOOTER"),
            [parts componentsJoinedByString:@" + "], head];   // arg order [INFERRED]
}

- (CGFloat)tableView:(UITableView *)tv heightForRowAtIndexPath:(NSIndexPath *)ip {
    CGFloat width = tv.bounds.size.width - 32;
    NSInteger s = ip.section, r = ip.row;
    if (s == 0) return MAX(round(width * 0.4), 128);
    if (s == 1) return 60;
    if (s == 2) {
        if (r == 0) return 92;
        if (r == 1) return 86;
        return 52;
    }
    if (s == 4) {
        if (r == 0) return 102;
        NSString *hint = [self sourceHint];
        CGRect br = [hint boundingRectWithSize:CGSizeMake(width, 400)
                                       options:NSStringDrawingUsesLineFragmentOrigin
                                    attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:12.5]}
                                       context:nil];
        return ceil(br.size.height) + 20;
    }
    if (s == 5) {
        NSString *kind = [self buildWarnRows][r];
        if ([kind isEqualToString:@"fx"]) return 86;
        if ([kind isEqualToString:@"kind"]) return 44;
        if ([kind hasPrefix:@"h:"]) return 28;
        if ([kind hasPrefix:@"tone:"] || [kind hasPrefix:@"voice:"]) {
            NSString *text = [self optionText:kind];
            CGRect br = [text boundingRectWithSize:CGSizeMake(width - 62 - 50, 400)
                                            options:NSStringDrawingUsesLineFragmentOrigin
                                         attributes:@{NSFontAttributeName:
                                                      [UIFont systemFontOfSize:14 weight:UIFontWeightSemibold]}
                                            context:nil];
            return MAX(ceil(br.size.height) + 22, 42);
        }
        if ([kind isEqualToString:@"custom"]) return 45;
        return 52;
    }
    return 52;
}

#pragma mark - Cells

- (UITableViewCell *)tableView:(UITableView *)tv cellForRowAtIndexPath:(NSIndexPath *)ip {
    double width = tv.bounds.size.width - 32;
    BOOL on = [self on];
    NSInteger s = ip.section, r = ip.row;
    UITableViewCell *cell = nil;
    if (s == 5) {
        cell = [self warnCell:[self buildWarnRows][r] width:width];
    } else if (s == 0) {
        cell = [self cellWithId:@"preview"];
        UIView *box = [self boxInCell:cell];
        if (self.liveMap.superview != box) {
            for (UIView *v in [box.subviews copy]) [v removeFromSuperview];
            self.liveMap = [UIImageView new];
            self.liveMap.layer.cornerRadius = 14;
            self.liveMap.layer.cornerCurve = kCACornerCurveContinuous;
            self.liveMap.clipsToBounds = YES;
            [box addSubview:self.liveMap];
            self.live = [[SPPBubbleView alloc] initWithFrame:CGRectZero];
            [box addSubview:self.live];
            UIButton *tryBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            tryBtn.tag = 84;
            tryBtn.titleLabel.font = [UIFont systemFontOfSize:12.5 weight:UIFontWeightSemibold];
            [tryBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            tryBtn.layer.cornerRadius = 13;
            CAGradientLayer *grad = [CAGradientLayer layer];
            grad.startPoint = CGPointMake(0, 0);
            grad.endPoint = CGPointMake(1, 1);
            grad.colors = @[(id)OMCColorFromHex(@"#9B87F8").CGColor,
                            (id)OMCColorFromHex(@"#5DB4F6").CGColor];
            grad.cornerRadius = 13;
            [tryBtn.layer insertSublayer:grad atIndex:0];
            [tryBtn addTarget:self action:@selector(tryOnCar) forControlEvents:UIControlEventTouchUpInside];
            [box addSubview:tryBtn];
        }
        double rowH = [self tableView:tv heightForRowAtIndexPath:ip];
        self.liveMap.frame = CGRectMake(8, 8, width - 16, rowH - 16);
        self.liveMap.image = SPPMapImage(self.liveMap.bounds.size);
        self.liveMap.alpha = on ? 1 : 0.4;
        self.live.hidden = !on;
        UIButton *tryBtn = (UIButton *)[box viewWithTag:84];
        [tryBtn setTitle:L(@"SPEEDBUBBLE_TRY") forState:UIControlStateNormal];
        double btnW = ceil([L(@"SPEEDBUBBLE_TRY") sizeWithAttributes:
                            @{NSFontAttributeName: tryBtn.titleLabel.font}].width) + 24;
        tryBtn.frame = CGRectMake(CGRectGetMaxX(self.liveMap.frame) - btnW - 8,
                                  CGRectGetMaxY(self.liveMap.frame) - 26 - 8, btnW, 26);
        tryBtn.layer.sublayers.firstObject.frame = tryBtn.bounds;
        tryBtn.hidden = !on;
        [self tickLive];
    } else if (s == 1) {
        cell = [self cellWithId:@"enable"];
        cell.textLabel.text = L(@"SPEEDBUBBLE_ENABLE");
        cell.detailTextLabel.text = L(@"SPEEDBUBBLE_ENABLE_SUB");
        cell.imageView.image = OMCIcon(@"speedometer", OMCColorFromHex(@"#8B7CFF"));
        [self setAccessory:[self switchForKey:@"speedBubbleEnabled" def:YES] onCell:cell];
    } else if (s == 2) {
        if (r == 0) {
            cell = [self cellWithId:@"styles"];
            [self layoutStylesIn:[self boxInCell:cell] width:width];
        } else if (r == 1) {
            cell = [self cellWithId:@"color"];
            [self layoutColorsIn:[self boxInCell:cell] width:width];
        } else {
            cell = [self cellWithId:@"icon"];
            cell.textLabel.text = L(@"SPEEDBUBBLE_SHOW_APP_ICON");
            cell.imageView.image = OMCIcon(@"app.badge.fill", OMCColorFromHex(@"#FF7FA8"));
            [self setAccessory:[self switchForKey:@"speedBubbleShowAppIcon" def:YES] onCell:cell];
        }
    } else if (s == 3) {
        if (r == 2) {
            cell = [self cellWithId:@"reset"];
            cell.textLabel.text = L(@"SPEEDBUBBLE_RESET_LAYOUT");
            cell.textLabel.textColor = OMCAccentColor();
            cell.selectionStyle = UITableViewCellSelectionStyleGray;
        } else {
            BOOL car = (r == 1);
            cell = [self cellWithId:car ? @"sizecar" : @"sizephone"];
            cell.textLabel.text = L(car ? @"SPEEDBUBBLE_SIZE_CAR_SHORT" : @"SPEEDBUBBLE_SIZE_PHONE_SHORT");
            cell.imageView.image = OMCIcon(car ? @"car.fill" : @"iphone", OMCColorFromHex(@"#2BC79A"));
            UISlider *slider = [self sliderForKey:car ? @"speedBubbleSizeCar" : @"speedBubbleSizePhone"
                                              min:60 max:220 def:100 format:@"%ld%%"
                                            width:MIN(width - 140, 210)];
            [self setAccessory:slider onCell:cell];
        }
    } else if (s == 4) {
        if (r == 0) {
            cell = [self cellWithId:@"sources"];
            [self layoutSourcesIn:[self boxInCell:cell] width:width];
        } else {
            cell = [self cellWithId:@"hint"];
            UIView *box = [self boxInCell:cell];
            UILabel *hint = (UILabel *)[box viewWithTag:72];
            if (!hint) {
                hint = [UILabel new];
                hint.tag = 72;
                hint.numberOfLines = 0;
                hint.font = [UIFont systemFontOfSize:12.5];
                hint.textColor = [UIColor secondaryLabelColor];
                [box addSubview:hint];
            }
            hint.text = [self sourceHint];
            double rowH = [self tableView:tv heightForRowAtIndexPath:ip];
            hint.frame = CGRectMake(16, 8, width - 32, rowH - 16);
        }
    }
    if (cell) {
        double alpha = (s < 2 || on) ? 1 : 0.4;
        cell.contentView.alpha = (CGFloat)alpha;
        cell.accessoryView.alpha = (CGFloat)alpha;
        cell.userInteractionEnabled = (s < 2 || on);
    }
    return cell;
}

- (void)tableView:(UITableView *)tv didSelectRowAtIndexPath:(NSIndexPath *)ip {
    [tv deselectRowAtIndexPath:ip animated:YES];
    if (ip.section == 3 && ip.row == 2) [self resetLayout];
    if (ip.section == 5) {
        NSString *kind = [self buildWarnRows][ip.row];
        if ([kind hasPrefix:@"tone:"] || [kind hasPrefix:@"voice:"]) [self pickOption:kind];
        else if ([kind isEqualToString:@"custom"]) {
            UITableViewCell *cell = [tv cellForRowAtIndexPath:ip];
            [[cell viewWithTag:86] becomeFirstResponder];
        }
    }
}

#pragma mark - Warning section model

- (NSArray *)buildWarnRows {
    NSInteger mode = [self warnMode];
    NSMutableArray *rows = [NSMutableArray arrayWithObject:@"rim"];
    if (mode & 1) [rows addObject:@"fx"];
    [rows addObject:@"sound"];
    if (mode & 2) {
        [rows addObject:@"kind"];
        if ([self voiceSound]) {
            // Two groups in binary order: serious lines first
            // (SPPVoiceIsFun == NO), then fun lines, then the custom line.
            // [VERIFIED loop structure + header order]
            for (int pass = 0; pass < 2; pass++) {
                [rows addObject:pass == 0 ? @"h:serious" : @"h:fun"];
                for (NSInteger i = 0; i < 9; i++)
                    if ((SPPVoiceIsFun(i) != 0) == (pass == 1))
                        [rows addObject:[NSString stringWithFormat:@"voice:%ld", (long)i]];
            }
            [rows addObject:@"h:custom"];
            [rows addObject:@"custom"];
        } else {
            for (NSInteger i = 0; i < 6; i++)
                [rows addObject:[NSString stringWithFormat:@"tone:%ld", (long)i]];
        }
    }
    [rows addObject:@"over"];
    self.warnRows = rows;
    return rows;
}

- (NSInteger)optionIndex:(NSString *)kind {
    NSRange colon = [kind rangeOfString:@":"];
    if (colon.location == NSNotFound) return 0;
    return [[kind substringFromIndex:colon.location + 1] integerValue];
}

- (NSString *)optionText:(NSString *)kind {
    NSInteger i = [self optionIndex:kind];
    if ([kind hasPrefix:@"tone:"])
        return L([NSString stringWithFormat:@"SPEEDBUBBLE_TONE_%ld", (long)i]);
    return SPPVoiceLine([self voiceText], i, [self shownLimit]);
}

- (BOOL)optionChosen:(NSString *)kind {
    if ([kind isEqualToString:@"custom"]) return [self voiceLine] == 8;
    if ([kind hasPrefix:@"tone:"]) return [self tone] == [self optionIndex:kind];
    return [self voiceLine] == [self optionIndex:kind];
}

- (UIImageView *)playIcon:(BOOL)chosen {
    UIImageSymbolConfiguration *cfg =
        [UIImageSymbolConfiguration configurationWithPointSize:22 weight:UIImageSymbolWeightRegular];
    UIImageView *iv = [[UIImageView alloc]
        initWithImage:[UIImage systemImageNamed:chosen ? @"play.circle.fill" : @"play.circle"
                               withConfiguration:cfg]];
    iv.tintColor = chosen ? OMCAccentColor()
                          : [OMCAccentColor() colorWithAlphaComponent:0.55];
    return iv;
}

- (void)warnSwitchChanged:(UISwitch *)sw {
    NSInteger mode = [self warnMode];
    NSInteger bit = sw.tag;
    NSInteger nv = sw.isOn ? (mode | bit) : (mode & ~bit);
    [self storeValue:@(nv) forKey:@"speedBubbleWarnMode"];
    [self prefChanged:@"speedBubbleWarnMode"];
}

- (UITableViewCell *)warnCell:(NSString *)kind width:(double)width {
    if ([kind isEqualToString:@"rim"] || [kind isEqualToString:@"sound"]) {
        BOOL rim = [kind isEqualToString:@"rim"];
        UITableViewCell *cell = [self cellWithId:kind];
        cell.textLabel.text = L(rim ? @"SPEEDBUBBLE_WARN_SHORT_1" : @"SPEEDBUBBLE_WARN_SHORT_2");
        NSString *symbol; NSString *hex; NSInteger tag;
        if (rim) { symbol = @"rectangle.dashed"; hex = @"#FF5A5F"; tag = 1; }
        else {
            cell.detailTextLabel.text = L(@"SPEEDBUBBLE_SOUND_SUB");
            symbol = @"speaker.wave.2.fill"; hex = @"#5AB8FF"; tag = 2;
        }
        cell.imageView.image = OMCIcon(symbol, OMCColorFromHex(hex));
        UISwitch *sw = [UISwitch new];
        sw.onTintColor = OMCSwitchColor();
        sw.tag = tag;
        sw.on = ([self warnMode] & tag) != 0;
        [sw addTarget:self action:@selector(warnSwitchChanged:) forControlEvents:UIControlEventValueChanged];
        [self setAccessory:sw onCell:cell];
        return cell;
    }
    if ([kind isEqualToString:@"fx"]) {
        UITableViewCell *cell = [self cellWithId:@"fx"];
        [self layoutFxIn:[self boxInCell:cell] width:width];
        return cell;
    }
    if ([kind isEqualToString:@"kind"]) {
        UITableViewCell *cell = [self cellWithId:@"kind"];
        UIView *box = [self boxInCell:cell];
        for (UIView *v in [box.subviews copy]) [v removeFromSuperview];
        UISegmentedControl *seg = [self segmentForKey:@"speedBubbleWarnSound"
                                               titles:@[L(@"SPEEDBUBBLE_SOUND_TONE"),
                                                        L(@"SPEEDBUBBLE_SOUND_VOICE")] def:0];
        seg.frame = CGRectMake(width - 78, 4, 60, 32);   // [INFERRED exact x]
        [box addSubview:seg];
        return cell;
    }
    if ([kind hasPrefix:@"h:"]) {
        UITableViewCell *cell = [self cellWithId:@"head"];
        cell.indentationWidth = 44;
        cell.indentationLevel = 1;
        NSString *group = [[kind substringFromIndex:2] uppercaseString];
        cell.textLabel.text = [L([@"SPEEDBUBBLE_VOICE_GROUP_" stringByAppendingString:group]) uppercaseString];
        cell.textLabel.font = [UIFont systemFontOfSize:11.5 weight:UIFontWeightSemibold];
        cell.textLabel.textColor = [UIColor secondaryLabelColor];
        return cell;
    }
    if ([kind hasPrefix:@"tone:"] || [kind hasPrefix:@"voice:"]) {
        BOOL chosen = [self optionChosen:kind];
        UITableViewCell *cell = [self cellWithId:@"opt"];
        cell.indentationWidth = 44;
        cell.indentationLevel = 1;
        cell.textLabel.text = [self optionText:kind];
        cell.textLabel.numberOfLines = 0;
        cell.textLabel.font = [UIFont systemFontOfSize:14
                                               weight:chosen ? UIFontWeightSemibold : UIFontWeightRegular];
        cell.textLabel.textColor = chosen ? OMCAccentColor() : [UIColor labelColor];
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
        [self setAccessory:[self playIcon:chosen] onCell:cell];
        return cell;
    }
    if ([kind isEqualToString:@"custom"]) {
        UITableViewCell *cell = [self cellWithId:@"custom"];
        UIView *box = [self boxInCell:cell];
        UITextField *field = (UITextField *)[box viewWithTag:86];
        if (!field) {
            field = [UITextField new];
            field.tag = 86;
            field.font = [UIFont systemFontOfSize:14];
            field.returnKeyType = UIReturnKeyDone;
            field.clearButtonMode = UITextFieldViewModeWhileEditing;
            field.delegate = self;
            [field addTarget:self action:@selector(customBegan:) forControlEvents:UIControlEventEditingDidBegin];
            [field addTarget:self action:@selector(customEnded:) forControlEvents:UIControlEventEditingDidEnd];
            [box addSubview:field];
        }
        field.frame = CGRectMake(width - 112, 6, 60, 17);   // [INFERRED exact geometry]
        field.placeholder = L(@"SPEEDBUBBLE_VOICE_CUSTOM_PH");
        if (!field.isFirstResponder) field.text = [self voiceText];
        field.textColor = [self optionChosen:@"custom"] ? OMCAccentColor() : [UIColor labelColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        UIImageView *icon = [self playIcon:[self optionChosen:@"custom"]];
        icon.userInteractionEnabled = YES;
        [icon addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self
                                                                            action:@selector(customPlay)]];
        [self setAccessory:icon onCell:cell];
        return cell;
    }
    // @"over"
    UITableViewCell *cell = [self cellWithId:@"warnover"];
    cell.textLabel.text = L(@"SPEEDBUBBLE_WARN_WHEN");
    cell.imageView.image = OMCIcon(@"exclamationmark.triangle.fill", OMCColorFromHex(@"#FFB340"));
    UISlider *slider = [self sliderForKey:@"speedBubbleWarnOver" min:-10 max:10 def:5
                                   format:@"%+ld km/h" width:MIN(width - 140, 210)];
    [self setAccessory:slider onCell:cell];
    return cell;
}

#pragma mark - Tile layouts (fx / colors / styles / sources)

- (void)layoutFxIn:(UIView *)box width:(double)width {
    for (UIView *v in [box.subviews copy]) [v removeFromSuperview];
    double tileW = floor((width - 62 - 16 - 6) * 0.5);
    NSInteger current = [self warnFx];
    NSArray *icons = @[@"rectangle", @"sun.max.fill", @"rectangle.fill", @"circle.circle"];
    for (NSInteger i = 0; i < 4; i++) {
        UIControl *tile = [[UIControl alloc] initWithFrame:
            CGRectMake((i % 2) * (tileW + 6) + 60, (i / 2) * 40 + 2, tileW, 34)];
        tile.layer.cornerRadius = 11;
        tile.layer.cornerCurve = kCACornerCurveContinuous;
        BOOL selected = (i == current);
        tile.backgroundColor = selected ? [UIColor systemBackgroundColor]
                                        : [UIColor colorWithRed:0.55 green:0.56 blue:0.65 alpha:0.12];
        tile.layer.borderWidth = selected ? 1.5 : 0;
        tile.layer.borderColor = OMCColorFromHex(@"#8B7CFF").CGColor;
        objc_setAssociatedObject(tile, &kSPPAssocKey, @(i), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        [tile addTarget:self action:@selector(fxTapped:) forControlEvents:UIControlEventTouchUpInside];
        UIImageView *icon = [[UIImageView alloc] initWithFrame:CGRectMake(9, 9, 16, 16)];
        icon.image = [UIImage systemImageNamed:icons[i]
                             withConfiguration:[UIImageSymbolConfiguration
                                                configurationWithPointSize:12 weight:UIImageSymbolWeightSemibold]];
        icon.contentMode = UIViewContentModeCenter;
        icon.tintColor = selected ? OMCColorFromHex(@"#4B3FD0") : [UIColor secondaryLabelColor];
        [tile addSubview:icon];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(31, 0, tileW - 31, 34)];
        label.text = L([NSString stringWithFormat:@"SPEEDBUBBLE_FX_%ld", (long)i]);
        label.font = [UIFont systemFontOfSize:12.5 weight:UIFontWeightSemibold];
        label.textColor = selected ? OMCColorFromHex(@"#4B3FD0") : [UIColor secondaryLabelColor];
        label.adjustsFontSizeToFitWidth = YES;
        label.minimumScaleFactor = 0.75;
        [tile addSubview:label];
        for (UIView *v in tile.subviews) v.userInteractionEnabled = NO;
        [box addSubview:tile];
    }
}

- (void)fxTapped:(UIControl *)sender {
    [[UISelectionFeedbackGenerator new] selectionChanged];
    NSNumber *idx = objc_getAssociatedObject(sender, &kSPPAssocKey);
    [self storeValue:idx forKey:@"speedBubbleWarnFx"];
    [self prefChanged:@"speedBubbleWarnFx"];
}

- (void)layoutColorsIn:(UIView *)box width:(double)width {
    for (UIView *v in [box.subviews copy]) [v removeFromSuperview];
    UIImageView *icon = [[UIImageView alloc] initWithFrame:CGRectMake(16, 11, 29, 29)];
    icon.image = OMCIcon(@"paintpalette.fill", OMCColorFromHex(@"#A78BFA"));
    [box addSubview:icon];
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(62, 0, 60, 50)];
    title.text = L(@"SPEEDBUBBLE_COLOR");
    title.font = [UIFont systemFontOfSize:16 weight:UIFontWeightMedium];
    [box addSubview:title];
    UILabel *value = [[UILabel alloc] initWithFrame:CGRectMake(width - 116, 0, 100, 50)];
    value.text = L([NSString stringWithFormat:@"SPEEDBUBBLE_COLOR_%ld", (long)[self color]]);
    value.font = [UIFont systemFontOfSize:15];
    value.textColor = [UIColor secondaryLabelColor];
    value.textAlignment = NSTextAlignmentRight;
    [box addSubview:value];
    NSArray *hexes = @[@"", @"#FFFFFF", @"#16182A", @"#7C5CF0", @"#2F8FE0", @"#16A87F", @"#E8558C"];
    double avail = width - 20 - 26;
    double step = avail / 6.0;
    NSInteger current = [self color];
    for (NSInteger i = 0; i < 7; i++) {
        UIControl *sw = [[UIControl alloc] initWithFrame:CGRectMake(56 + i * step, 56, 26, 26)];
        sw.layer.cornerRadius = 13;
        sw.layer.borderWidth = 1;
        sw.layer.borderColor = [UIColor colorWithWhite:0.85 alpha:1].CGColor;
        sw.accessibilityLabel = L([NSString stringWithFormat:@"SPEEDBUBBLE_COLOR_%ld", (long)i]);
        if (i == 0) {
            CAGradientLayer *grad = [CAGradientLayer layer];
            grad.type = kCAGradientLayerConic;
            grad.frame = sw.bounds;
            grad.cornerRadius = 13;
            grad.startPoint = CGPointMake(0.5, 0.5);
            grad.endPoint = CGPointMake(0, 1);
            grad.colors = @[(id)OMCColorFromHex(@"#A78BFA").CGColor,
                            (id)OMCColorFromHex(@"#60C5FA").CGColor,
                            (id)OMCColorFromHex(@"#5EDDB6").CGColor,
                            (id)OMCColorFromHex(@"#F59AC0").CGColor,
                            (id)OMCColorFromHex(@"#A78BFA").CGColor];
            [sw.layer insertSublayer:grad atIndex:0];
        } else {
            sw.backgroundColor = OMCColorFromHex(hexes[i]);
        }
        if (i == current) {
            CAShapeLayer *ring = [CAShapeLayer layer];
            ring.path = [UIBezierPath bezierPathWithOvalInRect:CGRectInset(sw.bounds, -4, -4)].CGPath;
            ring.fillColor = NULL;
            ring.strokeColor = OMCColorFromHex(@"#6F62F2").CGColor;
            ring.lineWidth = 2;
            [sw.layer addSublayer:ring];
        }
        objc_setAssociatedObject(sw, &kSPPAssocKey, @(i), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        [sw addTarget:self action:@selector(colorTapped:) forControlEvents:UIControlEventTouchUpInside];
        [box addSubview:sw];
    }
}

- (void)colorTapped:(UIControl *)sender {
    [[UISelectionFeedbackGenerator new] selectionChanged];
    NSNumber *idx = objc_getAssociatedObject(sender, &kSPPAssocKey);
    [self storeValue:idx forKey:@"speedBubbleColor"];
    [self prefChanged:@"speedBubbleColor"];
}

- (void)layoutStylesIn:(UIView *)box width:(double)width {
    if (self.styleStrip && self.styleStrip.superview == box) {
        // already attached; fall through and rebuild contents
    } else {
        for (UIView *v in [box.subviews copy]) [v removeFromSuperview];
        self.styleStrip = [UIScrollView new];
        self.styleStrip.showsHorizontalScrollIndicator = NO;
        self.styleStrip.alwaysBounceHorizontal = YES;
        [box addSubview:self.styleStrip];
    }
    for (UIView *v in [self.styleStrip.subviews copy]) [v removeFromSuperview];
    self.styleStrip.frame = CGRectMake(0, 0, width, 92);
    UIImage *map = SPPMapImage(CGSizeMake(76, 76));
    NSInteger current = [self style];
    double x = 12;
    for (NSInteger i = 0; i < 9; i++) {
        UIControl *card = [[UIControl alloc] initWithFrame:CGRectMake(x, 10, 76, 62)];
        objc_setAssociatedObject(card, &kSPPAssocKey, @(i), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        [card addTarget:self action:@selector(styleTapped:) forControlEvents:UIControlEventTouchUpInside];
        UIImageView *thumb = [[UIImageView alloc] initWithFrame:card.bounds];
        thumb.image = map;
        thumb.layer.cornerRadius = 14;
        thumb.layer.cornerCurve = kCACornerCurveContinuous;
        thumb.clipsToBounds = YES;
        thumb.userInteractionEnabled = NO;
        [card addSubview:thumb];
        SPPBubbleView *bubble = [[SPPBubbleView alloc] initWithFrame:CGRectZero];
        [self configure:bubble style:i speed:52 limit:60];
        [card addSubview:bubble];
        SPPFitBubble(bubble, thumb.frame, 0.95);
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(-4, 62, 84, 16)];
        label.text = L([NSString stringWithFormat:@"SPEEDBUBBLE_LOOK_%ld", (long)i]);
        label.font = [UIFont systemFontOfSize:11.5 weight:UIFontWeightSemibold];
        label.textColor = (i == current) ? [UIColor labelColor] : [UIColor secondaryLabelColor];
        label.textAlignment = NSTextAlignmentCenter;
        label.adjustsFontSizeToFitWidth = YES;
        label.minimumScaleFactor = 0.75;
        [card addSubview:label];
        UIView *hit = [[UIView alloc] initWithFrame:thumb.frame];
        hit.userInteractionEnabled = NO;
        [card addSubview:hit];
        SPPSetRing(thumb, i == current);
        [self.styleStrip addSubview:card];
        x += 76 + 10;
    }
    self.styleStrip.contentSize = CGSizeMake(x + 4, 92);
    double off = self.stripOffset;
    if (off > 0) {
        double maxOff = MAX(0, self.styleStrip.contentSize.width - width);
        self.styleStrip.contentOffset = CGPointMake(MIN(off, maxOff), 0);
    }
}

- (void)styleTapped:(UIControl *)sender {
    NSNumber *idx = objc_getAssociatedObject(sender, &kSPPAssocKey);
    [[UISelectionFeedbackGenerator new] selectionChanged];
    self.stripOffset = self.styleStrip.contentOffset.x;
    [self storeValue:idx forKey:@"speedBubbleLook"];
    [self reloadSection:2];
    [self tickLive];
}

- (void)layoutSourcesIn:(UIView *)box width:(double)width {
    for (UIView *v in [box.subviews copy]) [v removeFromSuperview];
    NSInteger count = (NSInteger)SPPSourceNames().count;
    NSInteger current = [self source];
    double tileW = floor((width - 24 - (count - 1) * 8) / count);
    for (NSInteger i = 0; i < count; i++) {
        UIControl *tile = [[UIControl alloc] initWithFrame:
            CGRectMake(12 + i * (tileW + 8), 12, tileW, 78)];
        tile.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.14];   // [INFERRED exact]
        tile.layer.cornerRadius = 14;
        tile.layer.cornerCurve = kCACornerCurveContinuous;
        objc_setAssociatedObject(tile, &kSPPAssocKey, @(i), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        [tile addTarget:self action:@selector(sourceTapped:) forControlEvents:UIControlEventTouchUpInside];
        UIImageView *icon = [[UIImageView alloc] initWithFrame:
            CGRectMake((tileW - 30) / 2, 10, 30, 30)];
        UIImage *appIcon = SPPAppIconForSource(i);
        UIGraphicsImageRenderer *thumb = [[UIGraphicsImageRenderer alloc] initWithSize:CGSizeMake(30, 30)];
        icon.image = [thumb imageWithActions:^(UIGraphicsImageRendererContext *ctx) {
            (void)ctx;
            [appIcon drawInRect:CGRectMake(0, 0, 30, 30)];
        }];
        icon.userInteractionEnabled = NO;
        [tile addSubview:icon];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(4, 48, tileW - 8, 18)];
        label.text = [self sourceName:i];
        label.font = [UIFont systemFontOfSize:11.5 weight:UIFontWeightSemibold];
        label.textAlignment = NSTextAlignmentCenter;
        label.adjustsFontSizeToFitWidth = YES;
        label.minimumScaleFactor = 0.75;
        label.textColor = (i == current) ? [UIColor labelColor] : [UIColor secondaryLabelColor];
        [tile addSubview:label];
        SPPSetRing(tile, i == current);
        [box addSubview:tile];
    }
}

- (void)sourceTapped:(UIControl *)sender {
    NSNumber *idx = objc_getAssociatedObject(sender, &kSPPAssocKey);
    [[UISelectionFeedbackGenerator new] selectionChanged];
    [self storeValue:idx forKey:@"speedBubbleSource"];
    [self.table beginUpdates];
    [self reloadSection:4];
    [self.table endUpdates];
    self.stripOffset = self.styleStrip.contentOffset.x;
    [self reloadSection:2];
    [self tickLive];
}

#pragma mark - Actions

- (void)pickOption:(NSString *)kind {
    BOOL isTone = [kind hasPrefix:@"tone:"];
    [[UISelectionFeedbackGenerator new] selectionChanged];
    [self storeValue:@([self optionIndex:kind])
              forKey:isTone ? @"speedBubbleWarnTone" : @"speedBubbleWarnVoice"];
    [self playPreview];
    [self prefChanged:isTone ? @"speedBubbleWarnTone" : @"speedBubbleWarnVoice"];
}

- (void)playPreview {
    if ([self voiceSound])
        SPPSpeak(SPPVoiceLine([self voiceText], [self voiceLine], [self shownLimit]));
    else
        SPPPlayTone([self tone]);
}

- (void)customBegan:(UITextField *)field {
    (void)field;
    if ([self voiceLine] != 8)
        [self storeValue:@8 forKey:@"speedBubbleWarnVoice"];
}

- (void)customEnded:(UITextField *)field {
    [self storeValue:field.text ?: @"" forKey:@"speedBubbleWarnVoiceText"];
    [self reloadSection:5];
}

- (BOOL)textFieldShouldReturn:(UITextField *)field {
    [field resignFirstResponder];
    [self playPreview];
    return NO;
}

- (BOOL)textField:(UITextField *)field shouldChangeCharactersInRange:(NSRange)range
    replacementString:(NSString *)string {
    NSUInteger newLen = field.text.length - range.length + string.length;
    return newLen < 81;
}

- (void)customPlay {
    UITextField *field = (UITextField *)[self.table viewWithTag:86];
    if (field.isFirstResponder) {
        [field resignFirstResponder];
    } else if ([self voiceLine] != 8) {
        [self storeValue:@8 forKey:@"speedBubbleWarnVoice"];
        [self prefChanged:@"speedBubbleWarnVoice"];
    }
    [self playPreview];
}

- (void)tryOnCar {
    notify_post("com.anlai.omnicar/speedbubble.demo");
    [[[UIImpactFeedbackGenerator alloc] initWithStyle:UIImpactFeedbackStyleLight] impactOccurred];
    [self toast:L(@"SPEEDBUBBLE_TRY_SENT")];
}

- (void)resetLayout {
    notify_post("com.anlai.omnicar/speedbubble.resetlayout");
    [[[UIImpactFeedbackGenerator alloc] initWithStyle:UIImpactFeedbackStyleLight] impactOccurred];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 400 * NSEC_PER_MSEC),
                   dispatch_get_main_queue(), ^{
        CFPreferencesAppSynchronize(CFSTR("com.anlai.omnicar"));
        [self reloadSection:3];
    });
}

@end
