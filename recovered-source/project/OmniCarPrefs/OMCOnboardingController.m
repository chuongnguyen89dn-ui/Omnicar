// OMCOnboardingController.m — OmniCarPrefs reconstruction (Prefs-B)
// VERIFIED: +shouldShow (0x113ac), +guideNavigationControllerWithCompletion:
// (0x11418), viewDidLoad structure (0x114f4 — paging scroll view + page
// stack, dots, Skip/Next), the four page builders' keys and symbols
// (welcomePage 0x13170, splitPage 0x13370, speedPage 0x13424, tipsPage
// 0x13800), updateControls (0x138b4), openApps (0x13b68),
// speedBubbleToggled: (0x13c98), finish (0x13cf8), markDone (0x13da4),
// runCompletion (0x13de4). Exact label fonts/spacings inside
// pageWithSymbol:title:body:extra:note: are condensed [INFERRED].
#import "OMCOnboardingController.h"
#import "OMCCommon.h"
#import <Preferences/PSSpecifier.h>
#import <notify.h>

@implementation OMCOnboardingController

+ (BOOL)shouldShow {
    CFPreferencesAppSynchronize(CFSTR("com.anlai.omnicar"));
    id done = CFBridgingRelease(CFPreferencesCopyAppValue(CFSTR("onboardingDone"),
                                                          CFSTR("com.anlai.omnicar")));
    return ![done boolValue];
}

+ (UINavigationController *)guideNavigationControllerWithCompletion:(void (^)(void))completion {
    OMCOnboardingController *vc = [self new];
    vc.completion = completion;
    UINavigationController *nav =
        [[UINavigationController alloc] initWithRootViewController:vc];
    nav.modalPresentationStyle = UIModalPresentationFormSheet;
    nav.navigationBar.tintColor = OMCAccentColor();
    nav.presentationController.delegate = vc;
    return nav;
}

#pragma mark - View construction

- (UILabel *)labelWithFont:(UIFont *)font color:(UIColor *)color
                 alignment:(NSTextAlignment)alignment {
    UILabel *label = [UILabel new];
    label.font = font;
    label.adjustsFontForContentSizeCategory = YES;
    label.textColor = color;
    label.textAlignment = alignment;
    label.numberOfLines = 0;
    return label;
}

// Bullet lines ("• …") get a hanging indent; other lines are plain.
- (UILabel *)bodyLabelWithText:(NSString *)text {
    NSMutableParagraphStyle *style = [NSMutableParagraphStyle new];
    style.alignment = NSTextAlignmentLeft;
    style.lineSpacing = 3;          // [INFERRED constants]
    style.paragraphSpacing = 6;
    style.headIndent = 14;
    NSMutableAttributedString *attr =
        [[NSMutableAttributedString alloc] initWithString:text ?: @""];
    [attr addAttribute:NSParagraphStyleAttributeName value:style
                 range:NSMakeRange(0, attr.length)];
    UILabel *label = [UILabel new];
    label.attributedText = attr;
    return label;
}

- (UIView *)pageWithSymbol:(NSString *)symbol title:(NSString *)title
                      body:(NSString *)body extra:(UIView *)extra note:(NSString *)note {
    UIScrollView *page = [UIScrollView new];
    page.showsVerticalScrollIndicator = NO;
    page.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    UIStackView *stack = [UIStackView new];
    stack.translatesAutoresizingMaskIntoConstraints = NO;
    stack.axis = UILayoutConstraintAxisVertical;
    stack.alignment = UIStackViewAlignmentFill;
    stack.spacing = 14;
    [page addSubview:stack];

    UIView *tile = [UIView new];
    tile.translatesAutoresizingMaskIntoConstraints = NO;
    tile.backgroundColor = OMCAccentColor();
    tile.layer.cornerRadius = 20;
    tile.layer.cornerCurve = kCACornerCurveContinuous;
    UIImageView *icon = [[UIImageView alloc] init];
    icon.translatesAutoresizingMaskIntoConstraints = NO;
    icon.tintColor = [UIColor whiteColor];
    icon.contentMode = UIViewContentModeCenter;
    icon.image = [UIImage systemImageNamed:symbol ?: @"car.fill"
                         withConfiguration:[UIImageSymbolConfiguration
                                            configurationWithPointSize:40
                                                                weight:UIImageSymbolWeightSemibold]];
    [tile addSubview:icon];
    [stack addArrangedSubview:tile];
    [stack setCustomSpacing:20 afterView:tile];

    UILabel *titleLabel = [self labelWithFont:[UIFont preferredFontForTextStyle:UIFontTextStyleTitle1]
                                        color:[UIColor labelColor]
                                    alignment:NSTextAlignmentCenter];
    titleLabel.text = title;
    [stack addArrangedSubview:titleLabel];

    [stack addArrangedSubview:[self bodyLabelWithText:body]];
    if (extra) {
        [stack addArrangedSubview:extra];
        [stack setCustomSpacing:20 afterView:extra];
    }
    if (note) {
        UILabel *noteLabel = [self labelWithFont:[UIFont preferredFontForTextStyle:UIFontTextStyleFootnote]
                                           color:[UIColor secondaryLabelColor]
                                       alignment:NSTextAlignmentCenter];
        noteLabel.text = note;
        [stack addArrangedSubview:noteLabel];
    }
    return page;
}

- (UIView *)welcomePage {
    UIButtonConfiguration *cfg = [UIButtonConfiguration filledButtonConfiguration];
    cfg.title = L(@"ONB_P1_BUTTON");
    cfg.image = [UIImage systemImageNamed:@"square.grid.2x2.fill"];
    cfg.imagePadding = 8;
    cfg.cornerStyle = UIButtonConfigurationCornerStyleLarge;
    cfg.baseBackgroundColor = OMCAccentColor();
    cfg.baseForegroundColor = [UIColor whiteColor];
    cfg.contentInsets = NSDirectionalEdgeInsetsMake(12, 20, 12, 20);
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    button.configuration = cfg;
    [button addTarget:self action:@selector(openApps) forControlEvents:UIControlEventTouchUpInside];
    return [self pageWithSymbol:@"car.fill" title:L(@"ONB_P1_TITLE")
                           body:L(@"ONB_P1_BODY") extra:button note:L(@"ONB_P1_NOTE")];
}

- (UIView *)splitPage {
    return [self pageWithSymbol:@"rectangle.split.2x1.fill" title:L(@"ONB_P2_TITLE")
                           body:L(@"ONB_P2_BODY") extra:nil note:L(@"ONB_P2_NOTE")];
}

- (UIView *)tipsPage {
    return [self pageWithSymbol:@"lifepreserver" title:L(@"ONB_P4_TITLE")
                           body:L(@"ONB_P4_BODY") extra:nil note:L(@"ONB_P4_NOTE")];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    OMCLoadStrings();
    self.view.backgroundColor = OMCBackgroundColor();
    self.view.tintColor = OMCAccentColor();

    // Old SpeedBubble setup is retired. Keep welcome/split/tips only.
    NSArray *pages = @[[self welcomePage], [self splitPage], [self tipsPage]];
    self.pageCount = (NSInteger)pages.count;

    self.pager = [UIScrollView new];
    self.pager.translatesAutoresizingMaskIntoConstraints = NO;
    self.pager.pagingEnabled = YES;
    self.pager.showsHorizontalScrollIndicator = NO;
    self.pager.showsVerticalScrollIndicator = NO;
    self.pager.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    self.pager.delegate = self;
    [self.view addSubview:self.pager];

    UIStackView *stack = [[UIStackView alloc] initWithArrangedSubviews:pages];
    stack.translatesAutoresizingMaskIntoConstraints = NO;
    stack.axis = UILayoutConstraintAxisHorizontal;
    stack.distribution = UIStackViewDistributionFillEqually;
    [self.pager addSubview:stack];
    for (UIView *page in pages)
        [page.widthAnchor constraintEqualToAnchor:self.pager.frameLayoutGuide.widthAnchor].active = YES;

    self.dots = [UIPageControl new];
    self.dots.translatesAutoresizingMaskIntoConstraints = NO;
    self.dots.numberOfPages = self.pageCount;
    self.dots.currentPageIndicatorTintColor = OMCAccentColor();
    self.dots.pageIndicatorTintColor = [UIColor tertiaryLabelColor];
    [self.dots addTarget:self action:@selector(dotsChanged:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:self.dots];

    UIButtonConfiguration *skipCfg = [UIButtonConfiguration plainButtonConfiguration];
    skipCfg.title = L(@"ONB_SKIP");
    skipCfg.baseForegroundColor = [UIColor secondaryLabelColor];
    self.skipButton = [UIButton buttonWithType:UIButtonTypeSystem];
    self.skipButton.translatesAutoresizingMaskIntoConstraints = NO;
    self.skipButton.configuration = skipCfg;
    [self.skipButton addTarget:self action:@selector(finish) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.skipButton];

    UIButtonConfiguration *nextCfg = [UIButtonConfiguration filledButtonConfiguration];
    nextCfg.title = L(@"ONB_NEXT");
    nextCfg.cornerStyle = UIButtonConfigurationCornerStyleLarge;
    nextCfg.baseBackgroundColor = OMCAccentColor();
    nextCfg.baseForegroundColor = [UIColor whiteColor];
    nextCfg.contentInsets = NSDirectionalEdgeInsetsMake(10, 24, 10, 24);
    self.nextButton = [UIButton buttonWithType:UIButtonTypeSystem];
    self.nextButton.translatesAutoresizingMaskIntoConstraints = NO;
    self.nextButton.configuration = nextCfg;
    [self.nextButton addTarget:self action:@selector(nextTapped) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.nextButton];

    UILayoutGuide *safe = self.view.safeAreaLayoutGuide;
    UILayoutGuide *content = self.pager.contentLayoutGuide;
    [NSLayoutConstraint activateConstraints:@[
        [self.pager.topAnchor constraintEqualToAnchor:safe.topAnchor],
        [self.pager.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor],
        [self.pager.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor],
        [self.pager.bottomAnchor constraintEqualToAnchor:self.nextButton.topAnchor constant:-12],
        [stack.topAnchor constraintEqualToAnchor:content.topAnchor],
        [stack.bottomAnchor constraintEqualToAnchor:content.bottomAnchor],
        [stack.leadingAnchor constraintEqualToAnchor:content.leadingAnchor],
        [stack.trailingAnchor constraintEqualToAnchor:content.trailingAnchor],
        [stack.heightAnchor constraintEqualToAnchor:self.pager.frameLayoutGuide.heightAnchor],
        [self.nextButton.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor constant:-20],
        [self.nextButton.bottomAnchor constraintEqualToAnchor:safe.bottomAnchor constant:-16],
        [self.skipButton.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor constant:12],
        [self.skipButton.centerYAnchor constraintEqualToAnchor:self.nextButton.centerYAnchor],
        [self.dots.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor],
        [self.dots.centerYAnchor constraintEqualToAnchor:self.nextButton.centerYAnchor],
    ]];
    [self updateControls];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    double w = self.pager.bounds.size.width;
    if (w > 0 && w != self.laidOutWidth) {
        self.laidOutWidth = w;
        self.pager.contentOffset = CGPointMake((double)self.page * w, 0);
    }
}

#pragma mark - Paging

- (void)updateControls {
    self.dots.currentPage = self.page;
    BOOL last = self.page >= self.pageCount - 1;
    self.skipButton.hidden = last;
    UIButtonConfiguration *cfg = self.nextButton.configuration;
    cfg.title = L(last ? @"ONB_DONE" : @"ONB_NEXT");
    self.nextButton.configuration = cfg;
}

- (void)showPage:(NSInteger)page animated:(BOOL)animated {
    self.page = page;
    [self.pager setContentOffset:CGPointMake((double)page * self.pager.bounds.size.width, 0)
                         animated:animated];
    [self updateControls];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    double w = scrollView.bounds.size.width;
    if (w <= 0) return;
    NSInteger page = (NSInteger)llround(scrollView.contentOffset.x / w);
    if (page != self.page) {
        self.page = page;
        [self updateControls];
    }
}

- (void)dotsChanged:(UIPageControl *)sender {
    [self showPage:sender.currentPage animated:YES];
}

- (void)nextTapped {
    if (self.page < self.pageCount - 1) [self showPage:self.page + 1 animated:YES];
    else [self finish];
}

#pragma mark - Actions

- (void)openApps {
    Class cls = NSClassFromString(@"OMCAppBridgeAppsController");
    UIViewController *vc = [cls new];
    if ([vc respondsToSelector:@selector(setSpecifier:)]) {
        PSSpecifier *spec = [PSSpecifier preferenceSpecifierNamed:L(@"APPS")
                                                           target:nil set:NULL get:NULL
                                                           detail:Nil cell:(PSCellType)0 edit:Nil];
        [vc performSelector:@selector(setSpecifier:) withObject:spec];
    }
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)finish {
    [self markDone];
    [self dismissViewControllerAnimated:YES completion:^{
        [self runCompletion];
    }];
}

- (void)markDone {
    CFPreferencesSetAppValue(CFSTR("onboardingDone"), kCFBooleanTrue,
                             CFSTR("com.anlai.omnicar"));
    CFPreferencesAppSynchronize(CFSTR("com.anlai.omnicar"));
}

- (void)runCompletion {
    if (self.closed) return;
    self.closed = YES;
    if (self.completion) self.completion();
}

- (void)presentationControllerDidDismiss:(UIPresentationController *)controller {
    [self markDone];
    [self runCompletion];
}

@end
