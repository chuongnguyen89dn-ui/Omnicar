// OMCWhatsNewController.m — OmniCarPrefs reconstruction (Prefs-B)
// Class methods VERIFIED (+shouldShow 0x19808, +markSeen 0x19b8c,
// +whatsNewNavigationController 0x19bc8); view construction VERIFIED in
// structure (viewDidLoad 0x19e08, 3,220 B — full Auto Layout, written
// here with the same anchors/constants; labelWithFont:color: 0x1ab08,
// tileWithSymbol:side:pointSize:radius: 0x1ab94, rowForItem: 0x1af38,
// close 0x1b2b4).
// The two file-static helpers in the binary:
//   sub_19ab0 — loads WhatsNew.plist from the class bundle (dict or @{})
//   sub_198c4 — picks the version to present from the plist + a flag
//               (VERIFIED mechanics: looks up the current version's
//               entry and scans version keys with a numeric compare;
//               exact selection rule INFERRED as "newest key").
#import "OMCWhatsNewController.h"
#import "OMCCommon.h"
#import <QuartzCore/QuartzCore.h>

static NSString *const kOMCWhatsNewVersion = @"1.0.3";   // VERIFIED literal

static NSDictionary *OMCLoadWhatsNew(void) {              // sub_19ab0
    NSBundle *bundle = [NSBundle bundleForClass:[OMCWhatsNewController class]];
    NSString *path = [bundle pathForResource:@"WhatsNew" ofType:@"plist"];
    NSDictionary *dict = path ? [NSDictionary dictionaryWithContentsOfFile:path] : nil;
    return [dict isKindOfClass:[NSDictionary class]] ? dict : @{};
}

// Returns the version whose notes should be presented, or nil.
// [INFERRED selection rule; VERIFIED inputs: the plist dict, the
// current-version key lookup, and a numeric compare:options: scan.]
static NSString *OMCWhatsNewVersionToShow(NSDictionary *data, BOOL anyUnseen) {
    (void)anyUnseen;
    if ([data[kOMCWhatsNewVersion] isKindOfClass:[NSArray class]])
        return kOMCWhatsNewVersion;
    NSString *best = nil;
    for (NSString *key in data) {
        if (![key isKindOfClass:[NSString class]]) continue;
        if (![data[key] isKindOfClass:[NSArray class]]) continue;
        if (!best || [key compare:best options:NSNumericSearch] == NSOrderedDescending)
            best = key;
    }
    return best;
}

@implementation OMCWhatsNewController

+ (BOOL)shouldShow {
    CFPreferencesAppSynchronize(CFSTR("com.anlai.omnicar"));
    id seen = CFBridgingRelease(CFPreferencesCopyAppValue(CFSTR("whatsNewSeen"),
                                                          CFSTR("com.anlai.omnicar")));
    if ([seen isKindOfClass:[NSString class]] && [(NSString *)seen isEqualToString:kOMCWhatsNewVersion])
        return NO;
    NSDictionary *data = OMCLoadWhatsNew();
    return OMCWhatsNewVersionToShow(data, YES) != nil;
}

+ (void)markSeen {
    CFPreferencesSetAppValue(CFSTR("whatsNewSeen"), (__bridge CFStringRef)kOMCWhatsNewVersion,
                             CFSTR("com.anlai.omnicar"));
    CFPreferencesAppSynchronize(CFSTR("com.anlai.omnicar"));
}

+ (UINavigationController *)whatsNewNavigationController {
    [self markSeen];
    OMCWhatsNewController *vc = [self new];
    NSDictionary *data = OMCLoadWhatsNew();
    vc.version = OMCWhatsNewVersionToShow(data, NO) ?: kOMCWhatsNewVersion;
    NSMutableArray *items = [NSMutableArray array];
    id raw = data[vc.version];
    if ([raw isKindOfClass:[NSArray class]])
        for (id entry in (NSArray *)raw)
            if ([entry isKindOfClass:[NSDictionary class]]) [items addObject:entry];
    vc.items = items;
    UINavigationController *nav =
        [[UINavigationController alloc] initWithRootViewController:vc];
    nav.modalPresentationStyle = UIModalPresentationFormSheet;
    nav.navigationBar.tintColor = OMCAccentColor();
    return nav;
}

- (UILabel *)labelWithFont:(UIFont *)font color:(UIColor *)color {
    UILabel *label = [UILabel new];
    label.font = font;
    label.adjustsFontForContentSizeCategory = YES;
    label.textColor = color;
    label.numberOfLines = 0;
    return label;
}

- (UIView *)tileWithSymbol:(NSString *)symbol side:(double)side
               pointSize:(double)pointSize radius:(double)radius {
    UIImageSymbolConfiguration *cfg =
        [UIImageSymbolConfiguration configurationWithPointSize:pointSize
                                                          weight:UIImageSymbolWeightSemibold];
    UIImage *image = [UIImage systemImageNamed:symbol withConfiguration:cfg];
    if (!image) image = [UIImage systemImageNamed:@"sparkles" withConfiguration:cfg];
    UIImageView *iv = [[UIImageView alloc] initWithImage:image];
    iv.translatesAutoresizingMaskIntoConstraints = NO;
    iv.tintColor = [UIColor whiteColor];
    iv.contentMode = UIViewContentModeCenter;
    UIView *tile = [UIView new];
    tile.translatesAutoresizingMaskIntoConstraints = NO;
    tile.backgroundColor = OMCAccentColor();
    tile.layer.cornerRadius = (CGFloat)radius;
    tile.layer.cornerCurve = kCACornerCurveContinuous;
    [tile addSubview:iv];
    [NSLayoutConstraint activateConstraints:@[
        [tile.widthAnchor constraintEqualToConstant:side],
        [tile.heightAnchor constraintEqualToConstant:side],
        [iv.centerXAnchor constraintEqualToAnchor:tile.centerXAnchor],
        [iv.centerYAnchor constraintEqualToAnchor:tile.centerYAnchor],
    ]];
    return tile;
}

- (UIView *)rowForItem:(NSDictionary *)item {
    id sym = item[@"symbol"];
    NSString *symbol = [sym isKindOfClass:[NSString class]] ? sym : @"sparkles";
    UIView *tile = [self tileWithSymbol:symbol side:40 pointSize:18 radius:11];
    UILabel *title = [self labelWithFont:[UIFont preferredFontForTextStyle:UIFontTextStyleHeadline]
                                   color:[UIColor labelColor]];
    id titleKey = item[@"titleKey"];
    title.text = L(titleKey ?: @"");
    UILabel *body = [self labelWithFont:[UIFont preferredFontForTextStyle:UIFontTextStyleSubheadline]
                                  color:[UIColor secondaryLabelColor]];
    id textKey = item[@"textKey"];
    body.text = L(textKey ?: @"");
    UIStackView *texts = [[UIStackView alloc] initWithArrangedSubviews:@[title, body]];
    texts.axis = UILayoutConstraintAxisVertical;
    texts.spacing = 2;
    UIStackView *row = [[UIStackView alloc] initWithArrangedSubviews:@[tile, texts]];
    row.axis = UILayoutConstraintAxisHorizontal;
    row.alignment = UIStackViewAlignmentCenter;
    row.spacing = 14;
    return row;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    OMCLoadStrings();
    self.view.backgroundColor = OMCBackgroundColor();
    self.view.tintColor = OMCAccentColor();

    UIScrollView *scroll = [UIScrollView new];
    scroll.translatesAutoresizingMaskIntoConstraints = NO;
    scroll.showsVerticalScrollIndicator = NO;
    [self.view addSubview:scroll];

    UIStackView *stack = [UIStackView new];
    stack.translatesAutoresizingMaskIntoConstraints = NO;
    stack.axis = UILayoutConstraintAxisVertical;
    stack.alignment = UIStackViewAlignmentFill;
    stack.spacing = 18;
    [scroll addSubview:stack];

    // Hero tile, centered.
    UIView *hero = [self tileWithSymbol:@"sparkles" side:76 pointSize:32 radius:20];
    UIView *heroBox = [UIView new];
    [heroBox addSubview:hero];
    [NSLayoutConstraint activateConstraints:@[
        [hero.topAnchor constraintEqualToAnchor:heroBox.topAnchor],
        [hero.bottomAnchor constraintEqualToAnchor:heroBox.bottomAnchor],
        [hero.centerXAnchor constraintEqualToAnchor:heroBox.centerXAnchor],
    ]];
    [stack addArrangedSubview:heroBox];

    UIFont *titleFont = [[UIFontMetrics metricsForTextStyle:UIFontTextStyleTitle1]
        scaledFontForFont:[UIFont systemFontOfSize:26 weight:UIFontWeightBold]];
    UILabel *title = [self labelWithFont:titleFont color:[UIColor labelColor]];
    title.textAlignment = NSTextAlignmentCenter;
    title.text = [NSString stringWithFormat:L(@"WN_TITLE"), self.version];
    [stack addArrangedSubview:title];
    [stack setCustomSpacing:28 afterView:title];

    for (NSDictionary *item in self.items)
        [stack addArrangedSubview:[self rowForItem:item]];

    UIButtonConfiguration *cfg = [UIButtonConfiguration filledButtonConfiguration];
    cfg.title = L(@"WN_CONTINUE");
    cfg.cornerStyle = UIButtonConfigurationCornerStyleLarge;
    cfg.baseBackgroundColor = OMCAccentColor();
    cfg.baseForegroundColor = [UIColor whiteColor];
    cfg.contentInsets = NSDirectionalEdgeInsetsMake(12, 24, 12, 24);
    UIButton *go = [UIButton buttonWithType:UIButtonTypeSystem];
    go.translatesAutoresizingMaskIntoConstraints = NO;
    go.configuration = cfg;
    [go addTarget:self action:@selector(close) forControlEvents:UIControlEventTouchUpInside];
    [stack addArrangedSubview:go];

    UILayoutGuide *safe = self.view.safeAreaLayoutGuide;
    UILayoutGuide *content = scroll.contentLayoutGuide;
    UILayoutGuide *frame = scroll.frameLayoutGuide;
    [NSLayoutConstraint activateConstraints:@[
        [scroll.topAnchor constraintEqualToAnchor:safe.topAnchor],
        [scroll.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor],
        [scroll.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor],
        [scroll.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor],
        [stack.topAnchor constraintEqualToAnchor:content.topAnchor constant:36],
        [stack.bottomAnchor constraintEqualToAnchor:content.bottomAnchor constant:-20],
        [stack.leadingAnchor constraintEqualToAnchor:content.leadingAnchor constant:24],
        [stack.trailingAnchor constraintEqualToAnchor:content.trailingAnchor constant:-24],
        [stack.widthAnchor constraintEqualToAnchor:frame.widthAnchor constant:-48],
        [go.leadingAnchor constraintEqualToAnchor:stack.leadingAnchor constant:24],
        [go.trailingAnchor constraintEqualToAnchor:stack.trailingAnchor constant:-24],
        [go.bottomAnchor constraintEqualToAnchor:stack.bottomAnchor constant:-16],
    ]];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}

- (void)close {
    UIViewController *presenter = self.navigationController ?: self;
    [presenter dismissViewControllerAnimated:YES completion:nil];
}

@end
