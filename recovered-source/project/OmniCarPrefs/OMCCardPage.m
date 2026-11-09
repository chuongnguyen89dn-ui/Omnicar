// OMCCardPage.m — reconstructed from disasm/OMCCardPage.asm (28 methods).
// OMCCardPage is a hand-rolled "card page": a PSViewController that hosts its
// own grouped UITableView instead of PSListController specifiers. The three
// feature controllers built on it (SpeedBubble, SplitScreen) assemble their
// rows in code; StartupScreen uses the PSListController subclass instead.

#import "OMCCardPage.h"
#import "OMCCommon.h"
#import <Preferences/PSSpecifier.h>
#import <objc/runtime.h>
#import <notify.h>

@implementation OMCCardPage

- (void)loadView {
    UITableView *table = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    table.dataSource = self;
    table.delegate = self;
    table.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    self.table = table;
    self.view = table;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    OMCLoadStrings();
    OMCStyleTable(self.table);
    self.view.tintColor = OMCAccentColor();
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    CFPreferencesAppSynchronize(OMC_PREFS_DOMAIN);
    // Title comes from the navigation specifier's name when pushed from Root.
    PSSpecifier *spec = self.specifier;
    if (spec.name.length) self.title = spec.name;
    [self.table reloadData];
}

- (void)traitCollectionDidChange:(UITraitCollection *)previous {
    [super traitCollectionDidChange:previous];
    if (self.traitCollection.userInterfaceStyle != previous.userInterfaceStyle) {
        OMCStyleTable(self.table);
    }
}

#pragma mark - Preference access [VERIFIED instruction-for-instruction]

- (id)prefForKey:(NSString *)key def:(id)def {
    id value = (__bridge_transfer id)CFPreferencesCopyAppValue((__bridge CFStringRef)key,
                                                               OMC_PREFS_DOMAIN);
    return value ?: def;
}

- (NSInteger)intForKey:(NSString *)key def:(NSInteger)def {
    return [[self prefForKey:key def:@(def)] integerValue];
}

- (void)storeValue:(id)value forKey:(NSString *)key {
    if (!key) return;
    CFPreferencesSetAppValue((__bridge CFStringRef)key, (__bridge CFTypeRef)value,
                             OMC_PREFS_DOMAIN);
    CFPreferencesAppSynchronize(OMC_PREFS_DOMAIN);
    notify_post(OMC_PREFS_CHANGED_NOTIFICATION);
}

- (void)prefChanged:(NSString *)key {}  // subclass hook [VERIFIED empty]
- (void)prefChanging:(NSString *)key {} // subclass hook [VERIFIED empty]

#pragma mark - Cells and controls
// Controls remember their preference key (and, for sliders, an
// @[key, format, label] config array) through objc_setAssociatedObject
// with a fixed private key pointer [VERIFIED: _objc_setAssociatedObject in
// switchForKey:/segmentForKey:/sliderForKey:... and _objc_getAssociatedObject
// in the three change handlers].

static const void *kOMCControlKeyAssoc = &kOMCControlKeyAssoc;

- (UITableViewCell *)cellWithId:(NSString *)identifier {
    UITableViewCell *cell = [self.table dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                      reuseIdentifier:identifier];
    }
    OMCStyleCell(cell);
    cell.accessoryView = nil;
    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.imageView.image = nil;
    cell.textLabel.text = nil;
    cell.detailTextLabel.text = nil;
    cell.textLabel.textColor = [UIColor labelColor];
    cell.textLabel.alpha = 1.0;
    cell.detailTextLabel.textColor = [UIColor secondaryLabelColor];
    cell.detailTextLabel.numberOfLines = 2;
    return cell;
}

- (UIView *)boxInCell:(UITableViewCell *)cell {
    UIView *box = [cell.contentView viewWithTag:0x4258]; // [VERIFIED constant]
    if (!box) {
        box = [[UIView alloc] initWithFrame:cell.contentView.bounds];
        box.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        box.tag = 0x4258;
        [cell.contentView addSubview:box];
    }
    return box;
}

- (void)setAccessory:(UIView *)view onCell:(UITableViewCell *)cell {
    cell.accessoryView = view;
}

- (UISwitch *)switchForKey:(NSString *)key def:(BOOL)def {
    UISwitch *sw = [UISwitch new];
    sw.onTintColor = OMCSwitchColor();
    sw.on = [[self prefForKey:key def:@(def)] boolValue];
    objc_setAssociatedObject(sw, kOMCControlKeyAssoc, key, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [sw addTarget:self action:@selector(omcSwitchChanged:) forControlEvents:UIControlEventValueChanged];
    return sw;
}

- (void)omcSwitchChanged:(UISwitch *)sender {
    NSString *key = objc_getAssociatedObject(sender, kOMCControlKeyAssoc);
    [self storeValue:@(sender.isOn) forKey:key];
    [self prefChanged:key];
}

- (UISegmentedControl *)segmentForKey:(NSString *)key titles:(NSArray<NSString *> *)titles def:(NSInteger)def {
    UISegmentedControl *seg = [[UISegmentedControl alloc] initWithItems:titles];
    seg.selectedSegmentIndex = [self intForKey:key def:def];
    objc_setAssociatedObject(seg, kOMCControlKeyAssoc, key, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [seg addTarget:self action:@selector(omcSegmentChanged:) forControlEvents:UIControlEventValueChanged];
    return seg;
}

- (void)omcSegmentChanged:(UISegmentedControl *)sender {
    NSString *key = objc_getAssociatedObject(sender, kOMCControlKeyAssoc);
    UISelectionFeedbackGenerator *gen = [UISelectionFeedbackGenerator new];
    [gen selectionChanged];
    [self storeValue:@(sender.selectedSegmentIndex) forKey:key];
    [self prefChanged:key];
}

// Slider row: a container view holding the UISlider and a monospaced value
// label; associated config = @[key, formatString, label]. During the drag
// (omcSliderMoved:) the value is written with CFPreferencesSetAppValue
// WITHOUT sync/notify and prefChanging: fires; on touch-up (omcSliderDone:)
// the value goes through storeValue:forKey: (sync + notify) and
// prefChanged: fires. Values are stored as integers (numberWithLong:).
- (UIView *)sliderForKey:(NSString *)key min:(NSInteger)min max:(NSInteger)max
                     def:(NSInteger)def format:(NSString *)format width:(double)width {
    UIView *box = [[UIView alloc] initWithFrame:CGRectMake(0, 0, width, 44)];
    UISlider *slider = [[UISlider alloc] initWithFrame:box.bounds];
    slider.minimumValue = (float)min;
    slider.maximumValue = (float)max;
    slider.minimumTrackTintColor = OMCAccentColor();
    slider.value = (float)[self intForKey:key def:def];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
    label.font = [UIFont monospacedDigitSystemFontOfSize:13 weight:UIFontWeightMedium];
    label.textColor = [UIColor secondaryLabelColor];
    label.text = [NSString stringWithFormat:format ?: @"%.0f", slider.value];
    [box addSubview:slider];
    [box addSubview:label];
    NSArray *config = @[key, format ?: @"", label];
    objc_setAssociatedObject(slider, kOMCControlKeyAssoc, config, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [slider addTarget:self action:@selector(omcSliderMoved:) forControlEvents:UIControlEventValueChanged];
    [slider addTarget:self action:@selector(omcSliderDone:) forControlEvents:UIControlEventTouchUpInside | UIControlEventTouchUpOutside];
    return box;
}

- (void)omcSliderMoved:(UISlider *)sender {
    NSArray *config = objc_getAssociatedObject(sender, kOMCControlKeyAssoc);
    NSString *key = config[0];
    NSString *format = config[1];
    UILabel *label = config[2];
    long value = lroundf(sender.value);
    label.text = [NSString stringWithFormat:format.length ? format : @"%.0f", (double)value];
    CFPreferencesSetAppValue((__bridge CFStringRef)key,
                             (__bridge CFTypeRef)@(value), OMC_PREFS_DOMAIN);
    [self prefChanging:key];
}

- (void)omcSliderDone:(UISlider *)sender {
    NSArray *config = objc_getAssociatedObject(sender, kOMCControlKeyAssoc);
    NSString *key = config[0];
    [self storeValue:@(lroundf(sender.value)) forKey:key];
    [self prefChanged:key];
}

- (void)toast:(NSString *)message {
    // Dark rounded label centred near the bottom of the view, faded in/out
    // with animateWithDuration:delay:options: [VERIFIED call set; geometry
    // constants are in disasm/OMCCardPage.asm]
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
    label.text = message;
    label.numberOfLines = 0;
    label.font = [UIFont systemFontOfSize:14 weight:UIFontWeightMedium];
    label.textColor = [UIColor whiteColor];
    label.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.82];
    label.clipsToBounds = YES;
    label.layer.cornerRadius = 12;
    label.textAlignment = NSTextAlignmentCenter;
    [label sizeToFit];
    CGRect bounds = self.view.bounds;
    UIEdgeInsets safe = self.view.safeAreaInsets;
    CGFloat w = MIN(label.bounds.size.width + 32, bounds.size.width - 40);
    label.frame = CGRectMake((bounds.size.width - w) / 2,
                             bounds.size.height - safe.bottom - 64, w, 40);
    label.alpha = 0;
    [self.view addSubview:label];
    [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveEaseOut
        animations:^{ label.alpha = 1; }
        completion:^(BOOL finished) {
            [UIView animateWithDuration:0.3 delay:1.6 options:UIViewAnimationOptionCurveEaseIn
                animations:^{ label.alpha = 0; }
                completion:^(BOOL f) { [label removeFromSuperview]; }];
        }];
}

- (void)reloadSection:(NSInteger)section {
    if (section < self.table.numberOfSections) {
        [self.table reloadSections:[NSIndexSet indexSetWithIndex:section]
                  withRowAnimation:UITableViewRowAnimationNone];
    }
}

#pragma mark - UITableViewDataSource (base: empty)

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [self cellWithId:@"empty"];
}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section {
    OMCStyleHeaderFooter(view);
}

- (void)tableView:(UITableView *)tableView willDisplayFooterView:(UIView *)view forSection:(NSInteger)section {
    OMCStyleHeaderFooter(view);
}

@end
