// OMCSplitScreenController.m — OmniCarPrefs reconstruction (Prefs-B)
// VERIFIED: model helpers (on 0x38370, stringForKey: 0x383bc, layoutOf:
// 0x3842c, boxCount: 0x384b4, appsOf: 0x384c4, nameOf: 0x38644, urls
// 0x38718, prefChanged: 0x3876c), section/row counts (6 sections; s3
// expands from 3 to 7 rows while editing), headers/footers, favRow
// mapping (0x38980), helpKind mapping (0x389e8), and the cell content
// (keys, icons, hex colors) from cellForRowAtIndexPath: (0x38cc0).
// chip:/chipTapped:/editorCell: and the editor handlers were restored
// verbatim from their dumps in fix-round3 (audit-D1D4): the section-4
// panel row is a horizontal stack of two chip: toggles (0x38d60-0x38f70),
// chip: styles itself from the bool pref (0x3a4d4), chipTapped: toggles
// it and reloads section 4 (0x3a820), and the favorite editor is
// name row / UISegmentedControl / app-icon buttons / Done button
// (editorCell: 0x3a8f0). No INFERRED frames remain in those paths.
#import "OMCSplitScreenController.h"
#import "OMCSplitScreenAppPickerController.h"
#import "OMCCommon.h"
#import <Preferences/PSSpecifier.h> // [integration phase 1; backported to src in phase 3] declares PSSpecifier used in this file
#import <objc/runtime.h>

static const char kSSChipKeyAssoc;

// Favorite part names, VERIFIED from the constant array at 0x7fc00.
static NSArray<NSString *> *SSFavParts(void) {
    return @[@"Left", @"Right", @"Third"];
}
static NSString *SSFavKey(NSInteger fav, NSString *part) {
    return [NSString stringWithFormat:@"splitScreenFav%ld%@", (long)fav, part];
}
// Layout codes in picker order, VERIFIED from the constant arrays at
// 0x7fc18 (editorCell:) and 0x7fc48 (layoutPicked:).
static NSArray<NSNumber *> *SSFavLayoutCodes(void) {
    return @[@2, @3, @13, @31];
}
@interface UIImage (SSFavPrivateIcon)
+ (UIImage *)_applicationIconImageForBundleIdentifier:(NSString *)bundleID
                                               format:(int)format scale:(double)scale;
@end
// App icon for a bundle id, rasterized at (points, points); nil for bad
// ids. Mirrors the shared helper at 0x380a4 in the binary (the same body
// the OMCSplitPreview translation unit carries); editorCell: part 2
// calls it with points = 34 (0x3b180-0x3b184).
static UIImage *SSFavIconForBundleID(NSString *bundleID, double points) {
    if (![bundleID isKindOfClass:[NSString class]] || bundleID.length == 0) return nil;
    SEL sel = NSSelectorFromString(@"_applicationIconImageForBundleIdentifier:format:scale:");
    if (![UIImage respondsToSelector:sel]) return nil;
    UIImage *icon = [UIImage _applicationIconImageForBundleIdentifier:bundleID
                                                                format:2
                                                                 scale:[UIScreen mainScreen].scale];
    if (!icon) return nil;
    UIGraphicsImageRenderer *renderer =
        [[UIGraphicsImageRenderer alloc] initWithSize:CGSizeMake(points, points)];
    return [renderer imageWithActions:^(UIGraphicsImageRendererContext *ctx) {
        (void)ctx;
        [icon drawInRect:CGRectMake(0, 0, points, points)];
    }];
}
// App display name via LaunchServices (same dynamic pattern as the
// App Bridge page); falls back to the bundle id.
static NSString *SSAppName(NSString *bundleID) {
    if (bundleID.length == 0) return nil;
    Class proxyClass = NSClassFromString(@"LSApplicationProxy");
    SEL sel = NSSelectorFromString(@"applicationProxyForIdentifier:");
    if (![proxyClass respondsToSelector:sel]) return bundleID;
    id proxy = [proxyClass performSelector:sel withObject:bundleID];
    SEL nameSel = NSSelectorFromString(@"localizedName");
    if ([proxy respondsToSelector:nameSel]) {
        id name = [proxy performSelector:nameSel];
        if ([name isKindOfClass:[NSString class]]) return name;
    }
    return bundleID;
}

@interface OMCSplitScreenController ()
- (void)favRow:(NSInteger)row fav:(NSInteger *)fav part:(NSInteger *)part;
- (NSInteger)helpKind:(NSInteger)row index:(NSInteger *)index;
- (UIButton *)chip:(NSString *)title key:(NSString *)key;
- (UITableViewCell *)editorCell:(NSInteger)part fav:(NSInteger)fav width:(double)width;
- (void)chipTapped:(UIButton *)sender;
- (void)layoutPicked:(UISegmentedControl *)sender;
- (void)nameEdited:(UITextField *)field;
- (void)pickAppForKey:(NSString *)key title:(NSString *)title;
- (void)boxTapped:(UIButton *)sender;
- (void)doneEditing;
- (void)copyURL:(UIButton *)sender;
@end

@implementation OMCSplitScreenController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (self.title.length == 0) self.title = L(@"SPLITSCREEN");
}

#pragma mark - Model

- (BOOL)on {
    return [[self prefForKey:@"splitScreenEnabled" def:@YES] boolValue];
}

- (NSString *)stringForKey:(NSString *)key {
    id value = [self prefForKey:key def:nil];
    if ([value isKindOfClass:[NSString class]] && [(NSString *)value length] > 0)
        return value;
    return nil;
}

- (NSInteger)layoutOf:(NSInteger)fav {
    NSInteger layout = [self intForKey:SSFavKey(fav, @"Layout") def:2];
    // Only 2 (default), 3, 13 and 31 are valid layout codes.
    if (layout != 2 && layout != 3 && layout != 13 && layout != 31) layout = 2;
    return layout;
}

- (NSInteger)boxCount:(NSInteger)layout {
    return layout == 2 ? 2 : 3;
}

- (NSArray *)appsOf:(NSInteger)fav {
    NSMutableArray *apps = [NSMutableArray array];
    for (NSString *part in SSFavParts())
        [apps addObject:[self stringForKey:SSFavKey(fav, part)] ?: @""];
    return apps;
}

- (NSString *)nameOf:(NSInteger)fav {
    NSString *name = [self stringForKey:SSFavKey(fav, @"Name")];
    if (name) return name;
    return L([NSString stringWithFormat:@"SPLITSCREEN_FAV%ld_PLACEHOLDER", (long)fav]);
}

- (NSArray *)urls {
    return [L(@"SPLITSCREEN_SHORTCUTS_FOOTER") componentsSeparatedByString:@"\n"];
}

- (void)prefChanged:(NSString *)key {
    if ([key isEqualToString:@"splitScreenEnabled"])
        [self.table reloadData];
}

#pragma mark - Table shape

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tv { return 6; }

- (NSInteger)tableView:(UITableView *)tv numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case 0: return 1;
        case 1: return 2;
        case 2: return 1;
        case 3: return self.editing != 0 ? 7 : 3;
        case 4: return 1;
        case 5: {
            NSInteger rows = 2;
            if (self.showGestures) rows += 1;
            if (self.showSiri) rows += (NSInteger)[self urls].count;
            return rows;
        }
        default: return 0;
    }
}

- (NSString *)tableView:(UITableView *)tv titleForHeaderInSection:(NSInteger)section {
    // Jump table at 0x74c90 in the binary (VERIFIED keys).
    if (section == 2) return L(@"SPLITSCREEN_LAYOUT_GROUP");
    if (section == 3) return L(@"SPLITSCREEN_FAV_GROUP");
    if (section == 4) return L(@"SPLITSCREEN_PANEL_GROUP");
    return nil;
}

- (NSString *)tableView:(UITableView *)tv titleForFooterInSection:(NSInteger)section {
    if (section == 2) return L(@"SPLITSCREEN_PINNED_FOOTER");
    if (section == 3) return L(@"SPLITSCREEN_FAV_FOOTER");
    if (section == 5) return L(@"SPLITSCREEN_CREDITS_FOOTER");
    return nil;
}

// Maps a section-3 row to (fav, part): part -1 = favorite summary row.
// While editing favorite E, its four editor rows (parts 0–3) are
// spliced in and the later favorites shift down. [VERIFIED arithmetic]
- (void)favRow:(NSInteger)row fav:(NSInteger *)fav part:(NSInteger *)part {
    NSInteger e = self.editing;
    if (e != 0 && row >= e && row < e + 4) {
        *fav = e;
        *part = row - e;
        return;
    }
    if (e != 0 && row >= e + 4) {
        *fav = row - 3;
        *part = -1;
        return;
    }
    *fav = row + 1;
    *part = -1;
}

// Section-5 row kinds: 0 = gestures toggle, 1 = gesture guide text,
// 2 = Siri fold row, 3 = shortcut URL row (index = URL index).
- (NSInteger)helpKind:(NSInteger)row index:(NSInteger *)index {
    if (row == 0) return 0;
    if (row == 1 && self.showGestures) return 1;
    NSInteger base = 1 + (self.showGestures ? 1 : 0);
    if (row == base) return 2;
    *index = row - base - 1;
    return 3;
}

- (double)tableView:(UITableView *)tv heightForRowAtIndexPath:(NSIndexPath *)ip {
    double width = tv.bounds.size.width - 30;
    if (ip.section == 0) return MAX(round((tv.bounds.size.width - 40) * 0.36), 118);
    if (ip.section == 1 || ip.section == 2) return 60;
    if (ip.section == 3) {
        NSInteger fav, part;
        [self favRow:ip.row fav:&fav part:&part];
        // Original @0x38b78-0x38ba4: part 2 -> 56; parts 1 and 3
        // ((part & ~2) == 1) -> 48; everything else (summary row and
        // the part-0 name row) -> 60.
        if (part == 2) return 56;
        if ((part & ~2) == 1) return 48;
        return 60;
    }
    if (ip.section == 5) {
        NSInteger index = 0;
        NSInteger kind = [self helpKind:ip.row index:&index];
        if (kind == 1) {
            NSString *text = L(@"SPLITSCREEN_GUIDE_CAR_TEXT");
            CGRect r = [text boundingRectWithSize:CGSizeMake(width - 30, CGFLOAT_MAX)
                                          options:NSStringDrawingUsesLineFragmentOrigin
                                       attributes:@{NSFontAttributeName:
                                                        [UIFont systemFontOfSize:12.5]}
                                          context:nil];
            return ceil(r.size.height) + 20;
        }
        if (kind == 3) return 40;
        return 52;
    }
    return 52;
}

#pragma mark - Cells

- (UITableViewCell *)tableView:(UITableView *)tv cellForRowAtIndexPath:(NSIndexPath *)ip {
    double width = tv.bounds.size.width - 32;
    BOOL on = [self on];
    UITableViewCell *cell = nil;
    if (ip.section == 0) {
        cell = [self cellWithId:@"preview"];
        // Original @0x392b0-0x39334: the preview is added DIRECTLY to
        // cell.contentView (no box) and its frame is recomputed from
        // the live section-0 row height on every cell pass:
        // (8, 8, tvW-56, rowH-16).
        if (!self.preview) self.preview = [[OMCSplitPreview alloc] initWithFrame:CGRectZero];
        if (self.preview.superview != cell.contentView) {
            [cell.contentView addSubview:self.preview];
        }
        self.preview.frame = CGRectMake(8, 8, tv.bounds.size.width - 56,
            [self tableView:tv heightForRowAtIndexPath:ip] - 16);
        self.preview.on = on;
        self.preview.offText = L(@"SPLITSCREEN_OFF");
        self.preview.left = [self stringForKey:@"splitScreenLastLeft"]
                            ?: [self stringForKey:@"splitScreenLastRight"] ?: @"com.apple.Music";
        self.preview.pinned = [self stringForKey:@"splitScreenPinnedApp"] ?: @"com.apple.Maps";
        [self.preview setNeedsDisplay];
    } else if (ip.section == 1) {
        BOOL aut = (ip.row == 1);
        cell = [self cellWithId:aut ? @"auto" : @"enable"];
        cell.textLabel.text = L(aut ? @"SPLITSCREEN_AUTO_LAUNCH" : @"SPLITSCREEN_ENABLE");
        cell.detailTextLabel.text = L(aut ? @"SPLITSCREEN_AUTO_LAUNCH_SUB" : @"SPLITSCREEN_ENABLE_SUB");
        cell.imageView.image = OMCIcon(aut ? @"bolt.fill" : @"rectangle.split.2x1.fill",
                                       OMCColorFromHex(aut ? @"#2BC79A" : @"#8B7CFF"));
        UISwitch *sw = [self switchForKey:aut ? @"splitScreenAutoLaunch" : @"splitScreenEnabled"
                                      def:aut ? NO : YES];
        [self setAccessory:sw onCell:cell];
    } else if (ip.section == 2) {
        cell = [self cellWithId:@"pinned"];
        cell.textLabel.text = L(@"SPLITSCREEN_PINNED");
        cell.imageView.image = OMCIcon(@"pin.fill", OMCColorFromHex(@"#FFB340"));
        NSString *pinned = [self stringForKey:@"splitScreenPinnedApp"];
        cell.detailTextLabel.text = pinned ? SSAppName(pinned) : L(@"SPLITSCREEN_PICKER_NONE");
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    } else if (ip.section == 3) {
        NSInteger fav, part;
        [self favRow:ip.row fav:&fav part:&part];
        if (part >= 0) {
            cell = [self editorCell:part fav:fav width:width];
        } else {
            cell = [self cellWithId:@"fav"];
            cell.textLabel.text = [self nameOf:fav];
            NSMutableArray *names = [NSMutableArray array];
            for (NSString *bid in [self appsOf:fav])
                if ([bid length]) [names addObject:SSAppName(bid)];
            NSString *apps = names.count ? [names componentsJoinedByString:@", "]
                                         : L(@"SPLITSCREEN_APP_NOT_SET");
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ · %@",
                L([NSString stringWithFormat:@"SPLITSCREEN_LAYOUT_%ld", (long)[self layoutOf:fav]]),
                apps];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
    } else if (ip.section == 4) {
        cell = [self cellWithId:@"panel"];
        cell.textLabel.text = L(@"SPLITSCREEN_PANEL_SHOW");
        cell.imageView.image = OMCIcon(@"list.bullet.rectangle.fill", OMCColorFromHex(@"#FF7FA8"));
        // Original @0x38e28-0x38f68: NO switches here — the accessory is
        // a single horizontal UIStackView holding the two chip: toggle
        // buttons (Recent / Favorites), spacing 6, sized by
        // systemLayoutSizeFittingSize: and framed (0, 0, fitWidth, 30).
        UIStackView *toggles = [[UIStackView alloc] initWithArrangedSubviews:@[
            [self chip:L(@"SPLITSCREEN_SHOW_RECENT") key:@"splitScreenShowRecent"],
            [self chip:L(@"SPLITSCREEN_SHOW_FAVORITES") key:@"splitScreenShowFavorites"]]];
        toggles.spacing = 6;
        CGSize fit = [toggles systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
        toggles.frame = CGRectMake(0, 0, fit.width, 30);
        [self setAccessory:toggles onCell:cell];
    } else if (ip.section == 5) {
        NSInteger index = 0;
        NSInteger kind = [self helpKind:ip.row index:&index];
        if (kind == 0) {
            cell = [self cellWithId:@"gestures"];
            cell.textLabel.text = L(@"SPLITSCREEN_GESTURES");
            cell.imageView.image = OMCIcon(@"hand.tap.fill", OMCColorFromHex(@"#5AB8FF"));
            UISwitch *sw = [UISwitch new];
            sw.tag = 1;
            sw.on = self.showGestures;
            [sw addTarget:self action:@selector(gestureSwitchChanged:)
         forControlEvents:UIControlEventValueChanged];
            [self setAccessory:sw onCell:cell];
        } else if (kind == 1) {
            cell = [self cellWithId:@"guidetext"];
            UILabel *label = [UILabel new];
            label.tag = 2;
            label.numberOfLines = 0;
            label.font = [UIFont systemFontOfSize:12.5];
            label.textColor = [UIColor secondaryLabelColor];
            label.text = L(@"SPLITSCREEN_GUIDE_CAR_TEXT");
            label.frame = CGRectMake(16, 10, width - 32, 40);
            [cell.contentView addSubview:label];
        } else if (kind == 2) {
            cell = [self cellWithId:@"fold"];
            cell.textLabel.text = L(@"SPLITSCREEN_SIRI");
            cell.imageView.image = OMCIcon(@"command", OMCColorFromHex(@"#4A4F80"));
            UIImageView *chev = [[UIImageView alloc]
                initWithImage:[UIImage systemImageNamed:self.showSiri ? @"chevron.down"
                                                                      : @"chevron.right"]];
            chev.tintColor = [UIColor tertiaryLabelColor];
            cell.accessoryView = chev;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        } else {
            cell = [self cellWithId:@"url"];
            cell.textLabel.text = [self urls][index];
            cell.textLabel.font = [UIFont systemFontOfSize:13];
            cell.textLabel.lineBreakMode = NSLineBreakByTruncatingMiddle;
            UIButton *copy = [UIButton buttonWithType:UIButtonTypeSystem];
            copy.tag = index;
            [copy setTitle:L(@"SPLITSCREEN_COPY") forState:UIControlStateNormal];
            [copy addTarget:self action:@selector(copyURL:) forControlEvents:UIControlEventTouchUpInside];
            copy.frame = CGRectMake(0, 0, 64, 30);   // [INFERRED frame]
            [self setAccessory:copy onCell:cell];
        }
    }
    if (cell && ip.section >= 2) {
        double alpha = on ? 1 : 0.4;
        cell.contentView.alpha = (CGFloat)alpha;
        cell.userInteractionEnabled = on;
    }
    return cell;
}

- (void)gestureSwitchChanged:(UISwitch *)sender {
    self.showGestures = sender.isOn;
    [self reloadSection:5];
}

#pragma mark - Favorite editor

- (UIButton *)chip:(NSString *)title key:(NSString *)key {
    // Original @0x3a4d4: the chip is a BOOL toggle — its state is read
    // from the pref named by key (default YES), never from key != nil.
    BOOL on = [[self prefForKey:key def:@YES] boolValue];
    UIButton *chip = [UIButton buttonWithType:UIButtonTypeCustom];
    [chip setTitle:title forState:UIControlStateNormal];
    chip.titleLabel.font = [UIFont systemFontOfSize:12.5 weight:UIFontWeightSemibold];
    if (on) {
        [chip setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        chip.backgroundColor = OMCColorFromHex(@"#8B7CFF");
    } else {
        [chip setTitleColor:[UIColor secondaryLabelColor] forState:UIControlStateNormal];
        // colorWithWhite level 0.14 read from the binary @0x65758.
        chip.backgroundColor = [UIColor colorWithWhite:0.14 alpha:0.5];
    }
    chip.layer.cornerRadius = 10;
    // Self-sizing @0x3a6f4-0x3a78c: width = ceil(title width) + 20,
    // height = 30, both as active anchor constraints.
    CGSize textSize = [title sizeWithAttributes:@{NSFontAttributeName: chip.titleLabel.font}];
    [chip.widthAnchor constraintEqualToConstant:ceil(textSize.width) + 20].active = YES;
    [chip.heightAnchor constraintEqualToConstant:30].active = YES;
    objc_setAssociatedObject(chip, &kSSChipKeyAssoc, key, OBJC_ASSOCIATION_COPY_NONATOMIC);
    [chip addTarget:self action:@selector(chipTapped:) forControlEvents:UIControlEventTouchUpInside];
    return chip;
}

- (void)chipTapped:(UIButton *)sender {
    // Original @0x3a820: haptic, toggle the bool pref under the chip's
    // key, reload SECTION 4 (the panel row that hosts the chips).
    NSString *key = objc_getAssociatedObject(sender, &kSSChipKeyAssoc);
    UISelectionFeedbackGenerator *gen = [UISelectionFeedbackGenerator new];
    [gen selectionChanged];
    BOOL on = [[self prefForKey:key def:@YES] boolValue];
    [self storeValue:@(on ? 0 : 1) forKey:key];
    [self reloadSection:4];
}

- (UITableViewCell *)editorCell:(NSInteger)part fav:(NSInteger)fav width:(double)width {
    // Restored verbatim from the dump @0x3a8f0 (fix-round3 audit-D1D4).
    UITableViewCell *cell = [self cellWithId:[NSString stringWithFormat:@"edit%ld", (long)part]];
    UIView *box = [self boxInCell:cell];
    for (UIView *v in [box.subviews copy]) [v removeFromSuperview];
    // Common preamble @0x3aa40: every editor cell is tinted with the
    // accent color at alpha 0.06 (constant read from the binary
    // @0x65760).
    cell.backgroundColor = [OMCAccentColor() colorWithAlphaComponent:0.06];
    if (part == 0) {
        // Name row @0x3aa98: label (16, 0, 80, 60); field
        // (96, 14, width-102, 32) with 8x8 left/right spacer views.
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(16, 0, 80, 60)];
        label.text = L(@"SPLITSCREEN_PAIR_NAME");
        [box addSubview:label];
        UITextField *field = [[UITextField alloc] initWithFrame:CGRectMake(96, 14, width - 102, 32)];
        field.text = [self stringForKey:SSFavKey(fav, @"Name")];
        field.placeholder = L([NSString stringWithFormat:@"SPLITSCREEN_FAV%ld_PLACEHOLDER", (long)fav]);
        field.textAlignment = NSTextAlignmentRight;
        field.borderStyle = UITextBorderStyleNone;
        // colorWithWhite level 0.12 read from the binary @0x655f0.
        field.backgroundColor = [UIColor colorWithWhite:0.12 alpha:0.5];
        field.layer.cornerRadius = 9;
        field.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 8, 8)];
        field.leftViewMode = UITextFieldViewModeAlways;
        field.rightView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 8, 8)];
        field.rightViewMode = UITextFieldViewModeAlways;
        field.returnKeyType = UIReturnKeyDone;
        field.delegate = self;
        field.tag = fav;
        [field addTarget:self action:@selector(nameEdited:) forControlEvents:UIControlEventEditingDidEnd];
        [box addSubview:field];
    } else if (part == 1) {
        // Layout row @0x3ad38: a UISegmentedControl (NOT chips) with the
        // four literal layout keys, frame (12, 8, width-24, 32).
        UISegmentedControl *seg = [[UISegmentedControl alloc] initWithItems:@[
            L(@"SPLITSCREEN_LAYOUT_2"), L(@"SPLITSCREEN_LAYOUT_3"),
            L(@"SPLITSCREEN_LAYOUT_13"), L(@"SPLITSCREEN_LAYOUT_31")]];
        seg.selectedSegmentIndex =
            [SSFavLayoutCodes() indexOfObject:@([self layoutOf:fav])];
        seg.frame = CGRectMake(12, 8, width - 24, 32);
        seg.tag = fav;
        [seg addTarget:self action:@selector(layoutPicked:)
      forControlEvents:UIControlEventValueChanged];
        [box addSubview:seg];
    } else if (part == 2) {
        // Apps row @0x3aea8: a two-line header label (16, 6, 140, 46)
        // — group title at 15pt over the hint at 11pt secondary — and
        // one 34x34 icon button per box, right-aligned in a row
        // (step 40, first x = width - 8 - 40*count, y = 12).
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(16, 6, 140, 46)];
        label.numberOfLines = 2;
        NSMutableAttributedString *text = [[NSMutableAttributedString alloc]
            initWithString:L(@"SPLITSCREEN_APPS_GROUP")
                attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:15]}];
        NSAttributedString *hint = [[NSAttributedString alloc]
            initWithString:[@"\n" stringByAppendingString:L(@"SPLITSCREEN_FAV_APPS_HINT")]
                attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:11],
                             NSForegroundColorAttributeName: [UIColor secondaryLabelColor]}];
        [text appendAttributedString:hint];
        label.attributedText = text;
        [box addSubview:label];
        NSArray *apps = [self appsOf:fav];
        NSInteger count = [self boxCount:[self layoutOf:fav]];
        double x = width - 8 - 40 * (double)count;
        for (NSInteger i = 0; i < count; i++) {
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.frame = CGRectMake(x, 12, 34, 34);
            UIImage *icon = SSFavIconForBundleID(apps[i], 34);
            if (icon) {
                [btn setImage:icon forState:UIControlStateNormal];
            } else {
                // colorWithWhite level 0.2 read from the binary @0x65728.
                btn.backgroundColor = [UIColor colorWithWhite:0.2 alpha:0.5];
                btn.layer.cornerRadius = 8;
                [btn setTitle:@"+" forState:UIControlStateNormal];
                [btn setTitleColor:[UIColor secondaryLabelColor] forState:UIControlStateNormal];
            }
            // The tap handler unpacks @[prefKey, boxTitle] (0x3b254).
            objc_setAssociatedObject(btn, &kSSChipKeyAssoc,
                @[SSFavKey(fav, SSFavParts()[i]),
                  L([NSString stringWithFormat:@"SPLITSCREEN_BOX_%ld", (long)(i + 1)])],
                OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            [btn addTarget:self action:@selector(boxTapped:) forControlEvents:UIControlEventTouchUpInside];
            [box addSubview:btn];
            x += 40;
        }
    } else {
        // Done row (part 3) @0x3b38c: a single left-aligned system
        // button, title SPLITSCREEN_FAV_DONE at 15pt Semibold,
        // frame (16, 4, width-32, 40).
        UIButton *done = [UIButton buttonWithType:UIButtonTypeSystem];
        [done setTitle:L(@"SPLITSCREEN_FAV_DONE") forState:UIControlStateNormal];
        done.titleLabel.font = [UIFont systemFontOfSize:15 weight:UIFontWeightSemibold];
        done.frame = CGRectMake(16, 4, width - 32, 40);
        done.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [done addTarget:self action:@selector(doneEditing) forControlEvents:UIControlEventTouchUpInside];
        [box addSubview:done];
    }
    return cell;
}

- (void)layoutPicked:(UISegmentedControl *)sender {
    // Original @0x3b610: the segment index selects the layout code
    // from the constant code array; the control's tag is the favorite.
    NSNumber *code = SSFavLayoutCodes()[sender.selectedSegmentIndex];
    [self storeValue:code forKey:SSFavKey(sender.tag, @"Layout")];
    [self reloadSection:3];
}

- (void)nameEdited:(UITextField *)field {
    // Original @0x3b4d8: the name is whitespace-trimmed; an empty
    // result stores nil (removing the pref).
    NSString *trimmed = [field.text stringByTrimmingCharactersInSet:
                         [NSCharacterSet whitespaceCharacterSet]];
    [self storeValue:trimmed.length ? trimmed : nil forKey:SSFavKey(field.tag, @"Name")];
}

- (BOOL)textFieldShouldReturn:(UITextField *)field {
    // Original @0x3b5dc: resign, reload section 3, return YES.
    [field resignFirstResponder];
    [self reloadSection:3];
    return YES;
}

- (void)pickAppForKey:(NSString *)key title:(NSString *)title {
    OMCSplitScreenAppPickerController *picker = [OMCSplitScreenAppPickerController new];
    PSSpecifier *spec = [PSSpecifier preferenceSpecifierNamed:title ?: @""
                                                       target:nil set:NULL get:NULL
                                                       detail:Nil cell:(PSCellType)0 edit:Nil];
    [spec setProperty:key forKey:@"key"];
    picker.specifier = spec;
    [self.navigationController pushViewController:picker animated:YES];
}

- (void)boxTapped:(UIButton *)sender {
    // Original @0x3b7dc: the associated object is the @[key, title]
    // pair editorCell: attached to the box button.
    NSArray *pair = objc_getAssociatedObject(sender, &kSSChipKeyAssoc);
    [self pickAppForKey:pair[0] title:pair[1]];
}

- (void)doneEditing {
    self.editing = 0;
    [self reloadSection:3];
}

- (void)copyURL:(UIButton *)sender {
    NSString *url = [self urls][sender.tag];
    [UIPasteboard generalPasteboard].string = url;
    [self toast:L(@"SPLITSCREEN_COPY")];
}

- (void)tableView:(UITableView *)tv didSelectRowAtIndexPath:(NSIndexPath *)ip {
    [tv deselectRowAtIndexPath:ip animated:YES];
    if (ip.section == 2) {
        [self pickAppForKey:@"splitScreenPinnedApp" title:L(@"SPLITSCREEN_PINNED")];
    } else if (ip.section == 3) {
        NSInteger fav, part;
        [self favRow:ip.row fav:&fav part:&part];
        if (part == -1)
            self.editing = (self.editing == fav) ? 0 : fav;
        [self reloadSection:3];
    } else if (ip.section == 5) {
        NSInteger index = 0;
        if ([self helpKind:ip.row index:&index] == 2) {
            self.showSiri = !self.showSiri;
            [self reloadSection:5];
        }
    }
}

@end
