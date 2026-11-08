// OMCSplitScreenController.m — OmniCarPrefs reconstruction (Prefs-B)
// VERIFIED: model helpers (on 0x38370, stringForKey: 0x383bc, layoutOf:
// 0x3842c, boxCount: 0x384b4, appsOf: 0x384c4, nameOf: 0x38644, urls
// 0x38718, prefChanged: 0x3876c), section/row counts (6 sections; s3
// expands from 3 to 7 rows while editing), headers/footers, favRow
// mapping (0x38980), helpKind mapping (0x389e8), and the cell content
// (keys, icons, hex colors) from cellForRowAtIndexPath: (0x38cc0).
// chip:/editorCell: internals are reconstructed from their dumps at
// structural fidelity; exact frames are INFERRED where noted.
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
- (void)layoutPicked:(UIButton *)sender;
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
    if (ip.section == 0) return MAX(round(width * 0.375), 100);
    if (ip.section == 1 || ip.section == 2) return 60;
    if (ip.section == 3) {
        NSInteger fav, part;
        [self favRow:ip.row fav:&fav part:&part];
        if (part == -1) return 60;
        if (part == 2) return 56;
        return 48;
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
        UIView *box = [self boxInCell:cell];
        if (!self.preview) self.preview = [[OMCSplitPreview alloc] initWithFrame:CGRectZero];
        if (self.preview.superview != box) {
            [box addSubview:self.preview];
        }
        self.preview.frame = box.bounds;
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
                [NSString stringWithFormat:L(@"SPLITSCREEN_LAYOUT_%ld"), (long)[self layoutOf:fav]],
                apps];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
    } else if (ip.section == 4) {
        cell = [self cellWithId:@"panel"];
        cell.textLabel.text = L(@"SPLITSCREEN_PANEL_SHOW");
        cell.imageView.image = OMCIcon(@"list.bullet.rectangle.fill", OMCColorFromHex(@"#FF7FA8"));
        UIStackView *toggles = [UIStackView new];
        toggles.axis = UILayoutConstraintAxisVertical;
        toggles.spacing = 4;
        for (NSString *key in @[@"splitScreenShowRecent", @"splitScreenShowFavorites"]) {
            UILabel *label = [UILabel new];
            label.text = L([key isEqualToString:@"splitScreenShowRecent"]
                               ? @"SPLITSCREEN_SHOW_RECENT" : @"SPLITSCREEN_SHOW_FAVORITES");
            UIStackView *rowStack = [UIStackView new];
            rowStack.axis = UILayoutConstraintAxisHorizontal;
            [rowStack addArrangedSubview:label];
            [rowStack addArrangedSubview:[self switchForKey:key def:YES]];
            [toggles addArrangedSubview:rowStack];
        }
        toggles.frame = CGRectMake(0, 0, 190, 52);   // [INFERRED frame]
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
    UIButton *chip = [UIButton buttonWithType:UIButtonTypeCustom];
    [chip setTitle:title forState:UIControlStateNormal];
    chip.titleLabel.font = [UIFont systemFontOfSize:13 weight:UIFontWeightSemibold];
    BOOL active = key != nil;
    [chip setTitleColor:active ? [UIColor whiteColor] : OMCAccentColor()
               forState:UIControlStateNormal];
    chip.backgroundColor = active ? OMCColorFromHex(@"#8B7CFF") : OMCCardColor();
    chip.layer.cornerRadius = 12;
    chip.layer.cornerCurve = kCACornerCurveContinuous;
    objc_setAssociatedObject(chip, &kSSChipKeyAssoc, key, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [chip addTarget:self action:@selector(chipTapped:) forControlEvents:UIControlEventTouchUpInside];
    return chip;
}

- (void)chipTapped:(UIButton *)sender {
    (void)sender;
    [self reloadSection:3];
}

- (UITableViewCell *)editorCell:(NSInteger)part fav:(NSInteger)fav width:(double)width {
    UITableViewCell *cell = [self cellWithId:[NSString stringWithFormat:@"edit%ld", (long)part]];
    UIView *box = [self boxInCell:cell];
    for (UIView *v in [box.subviews copy]) [v removeFromSuperview];
    if (part == 0) {
        UILabel *label = [UILabel new];
        label.text = L(@"SPLITSCREEN_PAIR_NAME");
        label.frame = CGRectMake(16, 14, 90, 20);
        [box addSubview:label];
        UITextField *field = [UITextField new];
        field.text = [self stringForKey:SSFavKey(fav, @"Name")];
        field.placeholder = L([NSString stringWithFormat:@"SPLITSCREEN_FAV%ld_PLACEHOLDER", (long)fav]);
        field.textAlignment = NSTextAlignmentRight;
        field.borderStyle = UITextBorderStyleNone;
        field.backgroundColor = OMCCardColor();
        field.layer.cornerRadius = 8;
        field.delegate = self;
        field.tag = fav;
        [field addTarget:self action:@selector(nameEdited:) forControlEvents:UIControlEventEditingDidEnd];
        field.frame = CGRectMake(110, 6, width - 126, 36);   // [INFERRED frame]
        [box addSubview:field];
    } else if (part == 1) {
        // Layout chips: one per layout code (2 / 3 / 13 / 31).
        NSInteger current = [self layoutOf:fav];
        double x = 16;
        for (NSNumber *code in @[@2, @3, @13, @31]) {
            NSString *title = [NSString stringWithFormat:L(@"SPLITSCREEN_LAYOUT_%ld"),
                               (long)code.integerValue];
            UIButton *chip = [self chip:title key:code.integerValue == current ? SSFavKey(fav, @"Layout") : nil];
            chip.tag = code.integerValue;
            [chip addTarget:self action:@selector(layoutPicked:) forControlEvents:UIControlEventTouchUpInside];
            chip.frame = CGRectMake(x, 8, 64, 32);   // [INFERRED frame]
            [box addSubview:chip];
            x += 72;
        }
    } else {
        // App boxes for this favorite's parts (part 2 = first boxes row,
        // part 3 = remaining). Tapping a box opens the app picker.
        NSArray *parts = SSFavParts();
        NSInteger boxes = [self boxCount:[self layoutOf:fav]];
        NSInteger start = (part == 2) ? 0 : 2;
        double x = 16;
        for (NSInteger i = start; i < MIN(boxes, start + 2) && i < (NSInteger)parts.count; i++) {
            NSString *bid = [self stringForKey:SSFavKey(fav, parts[i])];
            UIButton *boxBtn = [self chip:bid ? SSAppName(bid) : L(@"SPLITSCREEN_PICKER_NONE")
                                      key:SSFavKey(fav, parts[i])];
            boxBtn.tag = i;
            [boxBtn addTarget:self action:@selector(boxTapped:) forControlEvents:UIControlEventTouchUpInside];
            boxBtn.frame = CGRectMake(x, 6, (width - 48) / 2, 36);   // [INFERRED frame]
            [box addSubview:boxBtn];
            x += (width - 48) / 2 + 16;
        }
    }
    return cell;
}

- (void)layoutPicked:(UIButton *)sender {
    // The favorite being edited is self.editing; the chip tag is the code.
    [self storeValue:@(sender.tag) forKey:SSFavKey(self.editing, @"Layout")];
    [self reloadSection:3];
}

- (void)nameEdited:(UITextField *)field {
    [self storeValue:field.text ?: @"" forKey:SSFavKey(field.tag, @"Name")];
}

- (BOOL)textFieldShouldReturn:(UITextField *)field {
    [field resignFirstResponder];
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
    NSString *key = objc_getAssociatedObject(sender, &kSSChipKeyAssoc);
    if (key) [self pickAppForKey:key title:[self nameOf:self.editing]];
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
