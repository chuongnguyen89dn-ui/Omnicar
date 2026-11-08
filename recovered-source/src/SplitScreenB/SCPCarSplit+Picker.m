// SCPCarSplit+Picker.m — OmniCarSplitScreen reconstruction, module SplitScreenB.
// Pane covers (shown while resizing/dragging), the per-slot app picker,
// the picker sheet, the app tray window bookkeeping, loaders and toasts.
//
// CLOSURE (wave 3, finisher): every STUB-UNRECOVERED / PARTIAL body in this
// file was closed by line-by-line disassembly reading — see the "Closure
// addendum" in SplitScreenB_REPORT.md for per-item verdicts and evidence.

#import "SCPCarSplit.h"
#import "SCPCarPane.h"
#import "SCPCommon.h" // [phase2; backported to src in phase 3] OMC* declarations used in this TU
#import "SCPCButton.h" // [phase2; backported to src in phase 3] SCPCButton interface used in this TU

// App icon lookup (static helper @0xdec8; name INFERRED — shared with Drag).
extern UIImage *SCPAppIconForBundle(NSString *bundleID);
extern void SCPDispatchAfter(double delaySeconds, void (^block)(void)); // 0x12efc (A)
// Dashboard root view controller getter @0x12658 (A; name INFERRED).
extern UIViewController *SCPDashboardRootViewController(void);

// Shared visual helpers implemented in other SplitScreenB files:
extern UIVisualEffectView *SCPKnobFaceView(void);                     // 0x35c74 (Chrome) — [phase2; backported to src in phase 3] ONE name
extern void SCPApplyMeshBackdrop(UIVisualEffectView *effectView);       // 0x35d5c (Chrome)
extern UIColor *SCPColorSecondary(void);                                // 0x2b380 (Chrome)
extern void SCPStyleChip(UIView *view, double radius);                  // 0x35f70 (Chrome)
extern void SCPStyleDragGhost(UIView *view, double radius);             // 0x271e4 (Drag)
extern void SCPStyleGhostIcon(UIImageView *imageView);                  // 0x21158 (Drag)
extern void SCPStyleRatioMenu(UIView *view, double radius);             // 0x29b10 (RatioMenu)
extern void SCPPrepareRatioMenu(UIView *view);                          // 0x24a34 (RatioMenu)
extern UIImage *SCPSymbolImage(NSString *name, double pointSize);       // 0x2b474 (RatioMenu)
extern UIButton *SCPWrapRatioChip(UIImage *image, id target, SEL action); // 0x302f8 (RatioMenu)
extern UIButton *SCPMakeIconButton(UIImage *image, id target, SEL action, double size); // 0x2b404 (RatioMenu)

// App catalog builders (module C):
extern NSArray *SCPCarPlayAppInfos(void);                               // 0x21d4c
extern NSArray *SCPChosenPhoneAppInfos(void);                           // 0x22210
extern NSArray *SCPBridgedChosenApps(void);                             // 0x48864
extern BOOL SCPIsInjectedPhoneApp(NSString *bundleID);                  // name INFERRED (C)
// Proxy lookup helpers (shared; names INFERRED):
extern id SCPApplicationInfoForBundle(NSString *bundleID); // [phase2; backported to src in phase 3] 0xe324 — B's "SCPProxyForBundle" is A's SCPApplicationInfoForBundle (SCPShared.m)
extern BOOL SCPAppHasCarPlayUI(id appInfo); // [phase2; backported to src in phase 3] 0xffb4 — B's "SCPProxyIsValid" is SCPAppHasCarPlayUI (dump-verified)

// Accent gradient/shadow styler @0x293a0 (name INFERRED). Two callers in
// this file (picker map, background toast) plus one in sub_24794.
static void SCPApplyAccent(UIView *view, BOOL on) {
    CALayer *found = nil;
    for (CALayer *sub in view.layer.sublayers)
        if ([sub.name isEqualToString:@"omcAccent"]) { found = sub; break; }
    if (!on) {
        [found removeFromSuperlayer];
        view.layer.shadowColor = [UIColor colorWithRed:0.43137254901960786
                                                 green:0.39215686274509803
                                                  blue:0.7843137254901961
                                                 alpha:1.0].CGColor;
        view.layer.shadowOpacity = 0;
        return;
    }
    CAGradientLayer *grad = (CAGradientLayer *)found;
    if (grad == nil) {
        grad = [CAGradientLayer layer];
        grad.name = @"omcAccent";
        grad.colors = @[
            (id)[UIColor colorWithRed:0.6078431372549019 green:0.5294117647058824
                                 blue:0.9725490196078431 alpha:1.0].CGColor,
            (id)[UIColor colorWithRed:0.36470588235294116 green:0.7058823529411765
                                 blue:0.9647058823529412 alpha:1.0].CGColor];
        grad.startPoint = CGPointZero;
        grad.endPoint = CGPointMake(1, 1);
        [view.layer insertSublayer:grad atIndex:0];
    }
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    grad.frame = view.bounds;
    grad.cornerRadius = view.layer.cornerRadius;
    grad.cornerCurve = kCACornerCurveContinuous;
    [CATransaction commit];
    view.layer.shadowColor = [UIColor colorWithRed:0.43137254901960786
                                             green:0.47058823529411764
                                              blue:1.0
                                             alpha:1.0].CGColor;
    view.layer.shadowOpacity = 0.45f;
    view.layer.shadowRadius = 9;
    view.layer.shadowOffset = CGSizeMake(0, 4);
}

// Bridged-phone-app predicate @0x101bc (name INFERRED; also called from
// module A methods — dedupe at integration, A owns most call sites).
static BOOL SCPIsBridgedPhoneApp(NSString *bundleID) {
    if (bundleID.length == 0) return NO;
    if (!OMCFeatureEnabled(@"appBridge")) return NO; // [phase2; backported to src in phase 3] C name has no leading underscore
    if (SCPIsInjectedPhoneApp(bundleID)) return YES;
    id app = SCPApplicationInfoForBundle(bundleID); // [phase2; backported to src in phase 3] names unified to A/C
    if (!SCPAppHasCarPlayUI(app)) return NO;
    return [SCPBridgedChosenApps() containsObject:bundleID];
}

@implementation SCPCarSplit (Picker)

// MARK: - Covers (block touches on a pane while it is being resized)

- (void)addCoverToPane:(SCPCarPane *)pane {                               // (see report)
    // CLOSURE NOTE: the earlier draft annotated this method "@0x24a34+";
    // 0x24a34 is SCPPrepareRatioMenu (see RatioMenu) — the annotation was
    // wrong and has been removed.
    if (pane.cover != nil) return;
    UIView *cover = [[UIView alloc] initWithFrame:pane.view.bounds];
    cover.autoresizingMask = 0x12;
    cover.backgroundColor = [UIColor colorWithRed:0.9333333333333333
                                            green:0.9411764705882353
                                             blue:0.9843137254901961
                                            alpha:1.0];
    cover.userInteractionEnabled = YES;
    UIImageView *icon = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    icon.image = SCPAppIconForBundle(pane.bundleID);
    icon.center = CGPointMake(CGRectGetMidX(cover.bounds),
                              CGRectGetMidY(cover.bounds));
    icon.autoresizingMask = 0x3f;   // INFERRED mask value
    [cover addSubview:icon];
    pane.cover = cover;
    [pane.view insertSubview:cover aboveSubview:pane.host];
    if (pane.handle != nil)
        [pane.view bringSubviewToFront:pane.handle];
    if (pane.bar != nil)
        [pane.view bringSubviewToFront:pane.bar];
}

- (void)removeCoverFromPane:(SCPCarPane *)pane {                          // 0x24c60 (approx.)
    UIView *cover = pane.cover;
    if (cover == nil) return;
    pane.cover = nil;
    [UIView animateWithDuration:0.22
        animations:^{ cover.alpha = 0; }                                   // INFERRED body
        completion:^(BOOL finished) { [cover removeFromSuperview]; }];   // INFERRED body
}

// MARK: - Per-slot picker (empty-slot placeholder)

- (void)showPickerForSlot:(int)slot {                                     // 0x2fbc0 (approx.)
    if (!self.active) return;
    if (![self validSlot:slot]) slot = [self autoSlot];
    SCPCarPane *pane = [self paneAtSlot:slot];
    if (pane == nil) return;
    [self removePickerFromPane:pane];
    [self removeLoaderFromPane:pane animated:NO];
    UIView *picker = [[UIView alloc] initWithFrame:[self frameForSlot:slot]];
    picker.backgroundColor = [UIColor colorWithRed:0.9333333333333333
                                             green:0.9411764705882353
                                              blue:0.9843137254901961
                                             alpha:1.0];   // INFERRED colour reuse
    picker.autoresizingMask = 0x12;
    picker.layer.borderColor = [UIColor colorWithWhite:1.0 alpha:0.55].CGColor;
    UILabel *label = [[UILabel alloc] initWithFrame:picker.bounds];
    label.text = @"+";   // INFERRED text (setText: with a cfstring in the binary)
    label.textColor = [[UIColor whiteColor] colorWithAlphaComponent:0.85];
    label.font = [UIFont systemFontOfSize:40 weight:UIFontWeightBold];   // INFERRED metrics
    label.textAlignment = NSTextAlignmentCenter;
    label.autoresizingMask = 0x12;
    [picker addSubview:label];
    UITapGestureRecognizer *tap =
        [[UITapGestureRecognizer alloc] initWithTarget:self
                                                action:@selector(pickerPaneTapped:)];
    [picker addGestureRecognizer:tap];
    pane.picker = picker;
    [pane.view addSubview:picker];
}

- (void)removePickerFromPane:(SCPCarPane *)pane {                         // 0x24ef0 (approx.)
    UIView *picker = pane.picker;
    if (picker == nil) return;
    pane.picker = nil;
    [UIView animateWithDuration:0.15
        animations:^{ picker.alpha = 0; }                                 // INFERRED body
        completion:^(BOOL finished) { [picker removeFromSuperview]; }];  // INFERRED body
    [self refreshPickerSheetSoon];
}

- (void)showPickersForEmptySlots {                                       // 0x2fb40 (approx.)
    for (int i = 0; i < self.paneCount; i++)
        if (![self slotOccupied:i])
            [self showPickerForSlot:i];
}

- (void)pickerPaneTapped:(UITapGestureRecognizer *)gr {                   // 0x30010 (approx.)
    SCPCarPane *pane = [self paneForView:gr.view];
    if (pane != nil && pane.picker != nil) {
        self.pickerSheetPane = pane;
        [self refreshPickerSheetSoon];
    }
}

// MARK: - Picker sheet

- (void)refreshPickerSheetSoon {                                         // 0x30100 (approx.)
    if (self.pickerSheetQueued) return;
    self.pickerSheetQueued = YES;
    dispatch_async(dispatch_get_main_queue(), ^{
        self.pickerSheetQueued = NO;
        [self refreshPickerSheet];
    });
}

// Reading order = by frame origin (top-to-bottom, then left-to-right);
// the comparator block is @0x30218 (INFERRED axis order).
- (NSArray *)panesInReadingOrder {
    return [self.allPanes sortedArrayUsingComparator:
        ^NSComparisonResult(SCPCarPane *a, SCPCarPane *b) {
            CGRect fa = a.view.frame, fb = b.view.frame;
            if (fabs(CGRectGetMinY(fa) - CGRectGetMinY(fb)) > 1.0)
                return CGRectGetMinY(fa) < CGRectGetMinY(fb)
                    ? NSOrderedAscending : NSOrderedDescending;
            return CGRectGetMinX(fa) < CGRectGetMinX(fb)
                ? NSOrderedAscending : NSOrderedDescending;
        }];
}

// CLOSED (was PARTIAL): re-derives the sheet's pane (first pane in reading
// order that shows a picker; the stored pickerSheetPane is kept only while
// its picker is live and it is still in allPanes), rebuilds the sheet when
// the state key changed, and re-marks the panes. @0x31eac.
- (void)refreshPickerSheet {
    NSArray *panes = self.active ? self.allPanes : @[];
    SCPCarPane *sheetPane = self.pickerSheetPane;
    if (sheetPane.picker == nil || ![panes containsObject:sheetPane])
        sheetPane = nil;
    NSArray *order = self.active ? [self panesInReadingOrder] : @[];
    SCPCarPane *found = nil;
    for (SCPCarPane *pane in order) {
        if (found != nil) break;
        if (pane.picker != nil) found = pane;
    }
    self.pickerSheetPane = found;
    if (found == nil) {
        [self removePickerSheet];
        return;
    }
    if (self.container.window == nil) {
        [self removePickerSheet];
        return;
    }
    NSString *key = [NSString stringWithFormat:@"%p/%d/%lu/%d/%@",
        (void *)found, found.slot, (unsigned long)panes.count,
        (int)self.mainStack, NSStringFromCGSize(self.container.bounds.size)];
    if (self.pickerSheet == nil || ![key isEqualToString:self.pickerSheetKey]) {
        [self buildPickerSheetForPane:found];
        self.pickerSheetKey = key;
    }
    [self markPickerPanes];
}

// CLOSED (was STUB-UNRECOVERED): the app-grid sheet. Hosted in the tray
// window when one exists (frames converted to window coordinates), else
// directly in the container. Layout: a slot-map header, title/subtitle,
// then a paging scroll view of 62x56 app cells (SCPCButton) with a dot
// strip when more than one page. @0x334e4 (9,628 bytes).
- (void)buildPickerSheetForPane:(SCPCarPane *)pane {
    UIView *oldSheet = self.pickerSheet;
    UIView *oldShield = self.pickerShield;
    UIWindow *window = [self trayWindowForParent:self.container];
    CGRect area;
    UIView *host;
    if (window != nil) {
        area = [self.container convertRect:self.container.bounds toView:nil];
        host = window;
    } else {
        area = self.container.bounds;
        host = self.container;
    }
    [oldShield removeFromSuperview];

    // App list: native CarPlay apps + chosen phone apps; the float pane
    // only offers non-bridged apps.
    NSMutableArray *apps = [NSMutableArray array];
    NSArray *all = [SCPCarPlayAppInfos()
        arrayByAddingObjectsFromArray:SCPChosenPhoneAppInfos()];
    for (NSDictionary *info in all) {
        if (pane == self.floatPane && SCPIsBridgedPhoneApp(info[@"id"]))
            continue;
        [apps addObject:info];
    }

    double areaW = area.size.width, areaH = area.size.height;
    double scale = (areaW > 1) ? MIN(96.0 * areaH / areaW, 56.0) : 40.0;

    NSString *title = (pane != self.floatPane)
        ? [NSString stringWithFormat:
               OMCTr(@"Chọn app cho ô %d", @"Choose an app for pane %d"),
               pane.slot + 1]
        : OMCTr(@"Chọn app cho cửa sổ nổi",
                @"Choose an app for the floating window");
    NSString *subtitle = OMCTr(@"Chạm 1 app để mở vào ô này",
                               @"Tap an app to open it here");
    UIFont *titleFont = [UIFont systemFontOfSize:12.5 weight:UIFontWeightSemibold];
    UIFont *subFont = [UIFont systemFontOfSize:10.5];
    double titleH = ceil([title boundingRectWithSize:CGSizeMake(134, 40)
        options:1 attributes:@{NSFontAttributeName: titleFont} context:nil].size.height);
    double subH = ceil([subtitle boundingRectWithSize:CGSizeMake(134, 30)
        options:1 attributes:@{NSFontAttributeName: subFont} context:nil].size.height);

    NSInteger count = (NSInteger)apps.count;
    NSInteger t = (NSInteger)((areaW - 194.0) / 62.0);
    NSInteger cols = MAX(MIN(MAX(count, 4), t), 1);
    NSInteger rowsAvail = MAX((NSInteger)((areaH - 44.0) / 56.0), 1);
    NSInteger totalRows = (count + cols - 1) / cols;
    NSInteger rowsPerPage = MAX(MIN(rowsAvail, totalRows), 1);
    NSInteger perPage = rowsPerPage * cols;
    NSInteger pages = MAX((count + perPage - 1) / perPage, 1);
    double gridH = rowsPerPage * 56.0 + 4.0;
    double extra = (pages > 1) ? 16.0 : 0.0;   // INFERRED branch polarity
    double headerH = scale + 10.0 + 8.0 + titleH + 2.0 + subH;
    double sheetH = MIN(areaH - 16.0, MAX(headerH + 66.0, gridH + 18.0 + extra));
    double sheetW = cols * 62.0 + 20.0;

    UIView *sheet = [[UIView alloc] initWithFrame:CGRectMake(
        CGRectGetMidX(area) - (sheetW + 150.0) * 0.5,
        CGRectGetMidY(area) - sheetH * 0.5, sheetW + 150.0, sheetH)];
    sheet.layer.cornerRadius = 24;
    sheet.layer.cornerCurve = kCACornerCurveContinuous;
    sheet.layer.shadowColor = [UIColor colorWithRed:0.43137254901960786
                                              green:0.39215686274509803
                                               blue:0.7843137254901961
                                              alpha:1.0].CGColor;
    sheet.layer.shadowOpacity = 0.3f;
    sheet.layer.shadowRadius = 24;
    sheet.layer.shadowOffset = CGSizeMake(0, 8);

    UIVisualEffectView *effectView = SCPKnobFaceView(); // [phase2; backported to src in phase 3] name unified
    effectView.frame = sheet.bounds;
    SCPApplyMeshBackdrop(effectView);
    effectView.layer.cornerRadius = 24;
    effectView.layer.cornerCurve = kCACornerCurveContinuous;
    effectView.clipsToBounds = YES;
    [sheet addSubview:effectView];
    UIView *contentView = effectView.contentView;

    // Clear strip right of the grid carrying a vertical fade gradient.
    UIView *clearView = [[UIView alloc] initWithFrame:
        CGRectMake(sheetW, 0, areaW, sheetH)];
    clearView.backgroundColor = UIColor.clearColor;
    [contentView addSubview:clearView];
    CAGradientLayer *grad = [CAGradientLayer layer];
    grad.frame = CGRectMake(0, 10, 1, sheetH - 20);
    UIColor *navy = [UIColor colorWithRed:0.2901960784313726
                                    green:0.30980392156862746
                                     blue:0.5019607843137255 alpha:1.0];
    grad.colors = @[(id)[navy colorWithAlphaComponent:0].CGColor,
                    (id)[navy colorWithAlphaComponent:0.32].CGColor,
                    (id)[navy colorWithAlphaComponent:0.32].CGColor,
                    (id)[navy colorWithAlphaComponent:0].CGColor];
    grad.locations = @[@0.0, @0.2, @0.8, @1.0];
    [clearView.layer addSublayer:grad];

    // Slot-map header.
    UIView *map = [self pickerMapForPane:pane height:scale];
    double mapW = (map != nil) ? map.bounds.size.width + 10.0 : 106.0;
    UIView *wrapper = [[UIView alloc] initWithFrame:CGRectMake(
        (areaW - mapW) * 0.5,
        MAX((sheetH - 68.0 - headerH) * 0.5, 0) + 52.0, mapW, scale + 10.0)];
    wrapper.backgroundColor = [UIColor colorWithWhite:1 alpha:0.35];
    wrapper.layer.cornerRadius = 12;
    wrapper.layer.cornerCurve = kCACornerCurveContinuous;
    wrapper.layer.borderWidth = 1;
    wrapper.layer.borderColor = [UIColor colorWithWhite:1 alpha:0.7].CGColor;
    [contentView addSubview:wrapper];
    if (map != nil) {
        map.frame = CGRectMake(5, 5, map.bounds.size.width, scale);
        [wrapper addSubview:map];
    }

    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(
        8, CGRectGetMaxY(wrapper.frame) + 8, 134, titleH)];
    titleLabel.text = title;
    titleLabel.font = titleFont;
    titleLabel.textColor = navy;
    titleLabel.numberOfLines = 2;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [contentView addSubview:titleLabel];

    UILabel *subLabel = [[UILabel alloc] initWithFrame:CGRectMake(
        8, CGRectGetMaxY(titleLabel.frame) + 2, 134, subH)];
    subLabel.text = subtitle;
    subLabel.font = subFont;
    subLabel.textColor = SCPColorSecondary();
    subLabel.numberOfLines = 2;
    subLabel.textAlignment = NSTextAlignmentCenter;
    [contentView addSubview:subLabel];

    NSInteger otherPickers = 0;
    for (SCPCarPane *p in self.allPanes)
        if (p.picker != nil && p != pane) otherPickers++;

    // Cancel chip (top-left of the sheet's side column).
    UIView *cancel = SCPWrapRatioChip(SCPSymbolImage(@"close", 14.0),
                                      self, @selector(pickerCancel:));
    cancel.bounds = CGRectMake(0, 0, 32, 32);
    cancel.layer.cornerRadius = 16;
    SCPStyleChip(cancel, 16.0);
    cancel.tintColor = [UIColor colorWithRed:1.0 green:0.35294117647058826
                                        blue:0.37254901960784315 alpha:1.0];
    cancel.center = CGPointMake(30, 120);
    [contentView addSubview:cancel];

    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(
        0, MAX((sheetH - gridH - extra) * 0.5, 8), sheetW, gridH)];
    scrollView.pagingEnabled = YES;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.alwaysBounceHorizontal = (pages > 1);
    scrollView.delegate = self;
    [contentView addSubview:scrollView];
    scrollView.contentSize = CGSizeMake(pages * sheetW, gridH);

    NSMutableSet *used = [NSMutableSet set];
    for (SCPCarPane *p in self.allPanes)
        if (p.bundleID != nil) [used addObject:p.bundleID];
    [used addObjectsFromArray:self.pending.allKeys];

    NSMutableArray *shownCells = [NSMutableArray array];
    for (NSInteger i = 0; i < count; i++) {
        NSDictionary *info = apps[i];
        NSString *bundleID = info[@"id"];
        NSInteger col = i % cols;
        NSInteger page = i / perPage;
        NSInteger rowInPage = (i % perPage) / cols;
        SCPCButton *cell = [SCPCButton buttonWithType:0];
        cell.frame = CGRectMake(page * sheetW + 10 + col * 62,
                                rowInPage * 56 + 2, 62, 56);
        cell.accessibilityIdentifier = bundleID;
        [cell addTarget:self action:@selector(pickerAppTapped:)
               forControlEvents:UIControlEventTouchUpInside];
        cell.accessibilityLabel = info[@"name"];
        UIImageView *iconView = [[UIImageView alloc] initWithFrame:
            CGRectMake(12, 9, 38, 38)];
        iconView.image = SCPAppIconForBundle(bundleID);
        SCPStyleGhostIcon(iconView);
        iconView.userInteractionEnabled = NO;
        UIView *shadowView = [[UIView alloc] initWithFrame:iconView.frame];
        shadowView.userInteractionEnabled = NO;
        shadowView.layer.shadowColor = [UIColor colorWithRed:0.43137254901960786
                                                       green:0.39215686274509803
                                                        blue:0.7843137254901961
                                                       alpha:1.0].CGColor;
        shadowView.layer.shadowOpacity = 0.25f;
        shadowView.layer.shadowRadius = 5;
        shadowView.layer.shadowOffset = CGSizeMake(0, 4);
        shadowView.layer.shadowPath =
            [UIBezierPath bezierPathWithRoundedRect:iconView.bounds
                cornerRadius:iconView.layer.cornerRadius].CGPath;
        [cell addSubview:shadowView];
        [cell addSubview:iconView];
        if ([used containsObject:bundleID]) {
            UIImageView *badge = [[UIImageView alloc] initWithImage:
                SCPSymbolImage(@"check", 10.0)];
            badge.tintColor = UIColor.whiteColor;
            badge.backgroundColor = [UIColor colorWithRed:0.6078431372549019
                                                    green:0.5294117647058824
                                                     blue:0.9725490196078431
                                                    alpha:1.0];
            badge.frame = CGRectMake(CGRectGetMaxX(iconView.frame) - 10,
                                     CGRectGetMinY(iconView.frame) - 4, 14, 14);
            badge.contentMode = UIViewContentModeScaleAspectFit;
            badge.layer.cornerRadius = 7;
            badge.layer.borderWidth = 1;
            badge.layer.borderColor = UIColor.whiteColor.CGColor;
            badge.clipsToBounds = YES;
            badge.userInteractionEnabled = NO;
            [cell addSubview:badge];
            for (UIView *sub in cell.subviews) sub.alpha = 0.3;
            cell.userInteractionEnabled = NO;
            cell.accessibilityTraits |= UIAccessibilityTraitNotEnabled;
        }
        [scrollView addSubview:cell];
        if (i < perPage) [shownCells addObject:cell];
    }

    if (pages >= 2) {
        UIView *dotsView = [[UIView alloc] initWithFrame:
            CGRectMake(0, gridH + extra, sheetW, 16)];
        dotsView.userInteractionEnabled = NO;
        for (NSInteger i = 0; i < pages; i++) {
            UIView *dot = [[UIView alloc] init];
            dot.layer.cornerRadius = 3;
            [dotsView addSubview:dot];
        }
        self.pickerDots = dotsView;
        [contentView addSubview:dotsView];
        // The binary stores 1 in the dots view's tag at build time
        // (transcribed literally; scrollViewDidScroll: below uses the
        // same tag as the current page — see closure addendum).
        dotsView.tag = 1;
        [self layoutPickerDotsForPage:0];
    } else {
        self.pickerDots = nil;
    }

    if (count == 0) {
        UILabel *empty = [[UILabel alloc] initWithFrame:scrollView.bounds];
        empty.text = OMCTr(@"Không có app", @"No apps");
        empty.textColor = SCPColorSecondary();
        empty.textAlignment = NSTextAlignmentCenter;
        [scrollView addSubview:empty];
    }

    [host addSubview:sheet];
    if (self.tray != nil && self.tray.superview == host)
        [host bringSubviewToFront:self.tray];
    self.pickerSheet = sheet;
    self.pickerShield = nil;
    self.pickerSheetOverlay = (window != nil);
    [self updatePopupShield];
    [self publishBusy];

    // Entrance: cross-fade from an old sheet, spring up otherwise.
    if (oldSheet != nil) {
        [UIView animateWithDuration:0.15
            animations:^{ oldSheet.alpha = 0; }
            completion:^(BOOL finished) { [oldSheet removeFromSuperview]; }];
    }
    sheet.alpha = 0;
    sheet.transform = (oldSheet != nil)
        ? CGAffineTransformMakeTranslation(0, 14)
        : CGAffineTransformScale(CGAffineTransformMakeTranslation(0, 48),
                                 0.92, 0.92);
    [UIView animateWithDuration:(oldSheet != nil) ? 0.35 : 0.5
                          delay:0
         usingSpringWithDamping:0.86
          initialSpringVelocity:0.4
                        options:6
                     animations:^{
                         sheet.alpha = 1;
                         sheet.transform = CGAffineTransformIdentity;
                     } completion:nil];
    for (UIView *cell in shownCells) {
        cell.alpha = 0;
        cell.transform = CGAffineTransformMakeTranslation(0, 16);
        NSInteger row = (NSInteger)((cell.frame.origin.y - 2) / 56);
        NSInteger col = (NSInteger)((cell.frame.origin.x - 10) / 62);
        [UIView animateWithDuration:0.45
                              delay:row * 0.05 + col * 0.012
             usingSpringWithDamping:0.85
              initialSpringVelocity:0.3
                            options:2
                         animations:^{
                             cell.alpha = 1;
                             cell.transform = CGAffineTransformIdentity;
                         } completion:nil];
    }

    if (window == nil) [self pushHostFramesLive:NO];
    OMCLogWrite(@"SplitScreen",
        [NSString stringWithFormat:@"CarSplit: popup chon %ld app cho o %d (%s, %d o cho)",
            (long)count, pane.slot, window != nil ? "cua so rieng" : "container",
            (int)otherPickers]);
}

// CLOSED (was PARTIAL): the sheet's pane gets a 3 pt border on its picker
// placeholder; every other pane's picker border is cleared. @0x322cc.
- (void)markPickerPanes {
    for (SCPCarPane *pane in self.allPanes)
        pane.picker.layer.borderWidth = (pane == self.pickerSheetPane) ? 3.0 : 0.0;
}

// CLOSED (was PARTIAL): tears the sheet down with a 0.22 s fade/drop and
// hides the tray window once nothing else uses it. The binary does NOT
// clear pickerSheetPane here. @0x32498.
- (void)removePickerSheet {
    UIView *sheet = self.pickerSheet;
    UIView *shield = self.pickerShield;
    BOOL overlay = self.pickerSheetOverlay;
    self.pickerSheet = nil;
    self.pickerShield = nil;
    self.pickerSheetKey = nil;
    self.pickerSheetOverlay = NO;
    [self updatePopupShield];
    [self publishBusy];
    if (sheet != nil || shield != nil) {
        UIWindow *window = self.trayWindow;
        __weak SCPCarSplit *weakSelf = self;
        [UIView animateWithDuration:0.22 delay:0 options:UIViewAnimationOptionLayoutSubviews
            animations:^{
                sheet.alpha = 0;
                if ([shield isKindOfClass:UIVisualEffectView.class]) {
                    ((UIVisualEffectView *)shield).effect = nil;
                    ((UIVisualEffectView *)shield).contentView.alpha = 0;
                } else {
                    shield.alpha = 0;
                }
                sheet.transform = CGAffineTransformScale(
                    CGAffineTransformMakeTranslation(0, 24), 0.92, 0.92);
            } completion:^(BOOL finished) {
                [sheet removeFromSuperview];
                [shield removeFromSuperview];
                SCPCarSplit *s = weakSelf;
                if (window != nil && s != nil && s.tray == nil &&
                    s.ratioMenu == nil && s.pickerSheet == nil)
                    window.hidden = YES;
            }];
        if (!overlay && self.active)
            [self pushHostFramesLive:NO];
    }
}

// CLOSED (was STUB-UNRECOVERED): miniature map of the current split; one
// button per pane (icon when occupied, "+" when empty and picker-less).
// The target pane's button carries the accent gradient. @0x329a0.
- (UIView *)pickerMapForPane:(SCPCarPane *)pane height:(double)height {
    CGSize size = self.container.bounds.size;
    if (size.width <= 1 || size.height <= 1) return nil;
    double scale = height / size.height;
    UIView *map = [[UIView alloc] initWithFrame:
        CGRectMake(0, 0, size.width * scale, height)];
    for (SCPCarPane *p in self.allPanes) {
        CGRect frame = (p == self.floatPane)
            ? self.floatFrame : [self frameForSlot:p.slot];
        if (frame.size.width < 1 || frame.size.height < 1) continue;
        CGRect rect = CGRectInset(CGRectMake(frame.origin.x * scale,
                                             frame.origin.y * scale,
                                             frame.size.width * scale,
                                             frame.size.height * scale),
                                  1.5, 1.5);
        NSString *bundleID = nil;
        if (p.picker == nil) {
            bundleID = p.bundleID;
            if (bundleID == nil) {
                for (NSString *key in self.pending) {
                    NSArray *entry = self.pending[key];
                    if (((NSNumber *)entry[0]).intValue == p.slot) { bundleID = key; break; } // [phase2; backported to src in phase 3] untyped NSArray subscript yields id
                }
            }
        }
        SCPCButton *button = [SCPCButton buttonWithType:0];
        button.frame = rect;
        button.tag = p.slot;
        button.layer.cornerRadius = 5;
        button.layer.cornerCurve = kCACornerCurveContinuous;
        if (p == pane) {
            button.backgroundColor = UIColor.clearColor;
            SCPApplyAccent(button, YES);
        } else {
            button.backgroundColor = [UIColor colorWithWhite:1
                alpha:(p.picker != nil) ? 0.6 : 0.45];
            button.layer.borderWidth = 1.5;
            button.layer.borderColor =
                [UIColor colorWithWhite:1 alpha:0.8].CGColor;
        }
        if (bundleID != nil) {
            double iconSize = MIN(floor(MIN(rect.size.width, rect.size.height) * 0.7), 22);
            UIImageView *icon = [[UIImageView alloc] initWithFrame:CGRectMake(
                (rect.size.width - iconSize) / 2, (rect.size.height - iconSize) / 2,
                iconSize, iconSize)];
            icon.image = SCPAppIconForBundle(bundleID);
            SCPStyleGhostIcon(icon);
            icon.userInteractionEnabled = NO;
            [button addSubview:icon];
        } else if (p.picker == nil) {
            UILabel *plus = [[UILabel alloc] initWithFrame:button.bounds];
            plus.text = @"+";
            plus.textAlignment = NSTextAlignmentCenter;
            plus.textColor = (p == pane) ? UIColor.whiteColor : SCPColorSecondary();
            plus.font = [UIFont systemFontOfSize:
                MIN(floor(MIN(rect.size.width, rect.size.height) * 0.8), 22)
                weight:(p == pane) ? UIFontWeightBold : UIFontWeightRegular];
            plus.userInteractionEnabled = NO;
            [button addSubview:plus];
        }
        button.userInteractionEnabled = (p.picker != nil && p != pane);
        [button addTarget:self action:@selector(pickerMapTapped:)
                 forControlEvents:UIControlEventTouchUpInside];
        [map addSubview:button];
    }
    return map;
}

- (void)pickerMapTapped:(UIView *)sender {
    SCPCarPane *pane = [self paneAtSlot:(int)sender.tag];
    if (pane != nil && pane.picker != nil) {
        self.pickerSheetPane = pane;
        [self refreshPickerSheetSoon];
    }
}

// CLOSED (was PARTIAL): centres the dot strip; the current page's dot is
// a 16 pt accent pill, the rest 6 pt navy at 20% alpha. @0x3b630.
- (void)layoutPickerDotsForPage:(NSInteger)page {
    UIView *dots = self.pickerDots;
    if (dots == nil) return;
    NSArray *subviews = dots.subviews;
    NSInteger n = (NSInteger)subviews.count;
    double total = (n - 1) * 6.0;
    for (NSInteger i = 0; i < n; i++) total += (i == page) ? 16.0 : 6.0;
    double x = (dots.bounds.size.width - total) * 0.5;
    double y = dots.bounds.size.height * 0.5 - 3.0;
    for (NSInteger i = 0; i < n; i++) {
        UIView *dot = subviews[i];
        double width = (i == page) ? 16.0 : 6.0;
        dot.frame = CGRectMake(x, y, width, 6);
        dot.backgroundColor = (i == page)
            ? [UIColor colorWithRed:0.6078431372549019 green:0.5294117647058824
                               blue:0.9725490196078431 alpha:1.0]
            : [[UIColor colorWithRed:0.2901960784313726 green:0.30980392156862746
                                 blue:0.5019607843137255 alpha:1.0]
                  colorWithAlphaComponent:0.2];
        x += width + 6.0;
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (self.pickerDots == nil) return;
    if (![scrollView isDescendantOfView:self.pickerSheet]) return;
    double w = scrollView.bounds.size.width;
    if (w <= 0) return;
    NSInteger page = (NSInteger)lround(scrollView.contentOffset.x / w);
    if (page == self.pickerDots.tag) return;
    self.pickerDots.tag = page;
    [UIView animateWithDuration:0.25 animations:^{
        [self layoutPickerDotsForPage:page];   // INFERRED call target
    }];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    if ([scrollView isDescendantOfView:self.tray])
        [self restartTrayTimer];
}

// CLOSED (was PARTIAL): an app cell was tapped — open the app in the
// sheet's pane and refresh the sheet if that pane still shows a picker.
// @0x362a0 (560 bytes, @try/@catch with log).
- (void)pickerAppTapped:(UIView *)sender {
    @try {
        SCPCarPane *pane = self.pickerSheetPane;
        if (pane == nil) pane = [self paneForView:sender];
        if (pane == nil) return;
        NSString *bundle = sender.accessibilityIdentifier;
        OMCLogWrite(@"SplitScreen",
            [NSString stringWithFormat:@"CarSplit: chon %@ cho o %d",
                bundle, pane.slot]);
        [self openApp:bundle slot:pane.slot];
        if (pane.picker != nil)
            [self refreshPickerSheetSoon];
    } @catch (id exception) {
        OMCLogWrite(@"SplitScreen",
            [NSString stringWithFormat:@"CarSplit: loi chon app %@\n%@",
                exception, ((NSException *)exception).callStackSymbols]);
    }
}

// CLOSED (B's draft only called removePickerSheet — wrong): cancel removes
// the picker from its pane; an occupied slot just relayouts, an empty
// float pane closes, any other empty pane is removed. @0x364d0 (@try/@catch).
- (void)pickerCancel:(UIView *)sender {
    @try {
        SCPCarPane *pane = self.pickerSheetPane;
        if (pane == nil) pane = [self paneForView:sender];
        if (pane == nil) return;
        [self removePickerFromPane:pane];
        if (pane.vc != nil || [self slotOccupied:pane.slot]) {
            [self relayoutAnimated:YES];
        } else if (pane == self.floatPane) {
            [self closeFloat:NO];
        } else {
            [self removePaneAt:pane.slot background:NO];
            [self afterPaneRemoved:nil];
        }
    } @catch (id exception) {
        OMCLogWrite(@"SplitScreen",
            [NSString stringWithFormat:@"CarSplit: loi huy bang chon %@\n%@",
                exception, ((NSException *)exception).callStackSymbols]);
    }
}

// MARK: - Tray

// The shared overlay window for trays/menus/ghosts on the parent's
// screen. Created lazily; recreated when the screen changes. Its level is
// the parent window's level + 65 (INFERRED composition of the constants
// in the disassembly).
- (UIWindow *)trayWindowForParent:(UIView *)parent {                     // 0x31a00 (approx.)
    UIScreen *screen = parent.window.screen;
    UIWindow *window = self.trayWindow;
    if (window != nil && screen != nil && window.screen != screen) {
        window.hidden = YES;
        self.trayWindow = nil;
        window = nil;
    }
    if (window == nil) {
        window = [[UIWindow alloc] initWithFrame:screen.bounds];
        window.windowLevel = parent.window.windowLevel + 65.0;   // INFERRED
        window.backgroundColor = UIColor.clearColor;
        self.trayWindow = window;
    }
    window.hidden = NO;
    return window;
}

- (void)hideTrayWindowIfIdle {                                           // 0x31d00 (approx.)
    UIWindow *window = self.trayWindow;
    if (window == nil) return;
    if (self.tray == nil && self.ratioMenu == nil &&
        self.pickerSheet == nil && self.dragGhost == nil)
        window.hidden = YES;
}

- (void)restartTrayTimer {                                               // 0x31e00 (approx.)
    [self.trayTimer invalidate];
    __weak SCPCarSplit *weakSelf = self;
    self.trayTimer = [NSTimer scheduledTimerWithTimeInterval:4.0
        repeats:NO block:^(NSTimer *timer) {
            [weakSelf collapseAppTray];   // INFERRED block body
        }];
}

// CLOSED (was PARTIAL): collapses the app tray. The tray cover fades out
// over 0.2 s; the tray itself fades/shrinks over 0.22 s and the tray
// window is hidden once nothing else uses it. Covers are removed from
// hosted panes unless a resize or the ratio menu is in flight. @0x3bd78.
- (void)collapseAppTray {
    [self.trayTimer invalidate];
    self.trayTimer = nil;
    UIView *tray = self.tray;
    self.tray = nil;
    [self updatePopupShield];
    [self publishBusy];
    [self setFullscreenBridgeHidden:NO bundle:nil];
    [self pushHostFramesLive:NO];
    if (!self.resizing && self.ratioMenu == nil) {
        for (SCPCarPane *pane in [self hostedPanes])
            [self removeCoverFromPane:pane];
    }
    UIView *cover = self.trayCover;
    self.trayCover = nil;
    if (cover != nil) {
        [UIView animateWithDuration:0.2
            animations:^{ cover.alpha = 0; }
            completion:^(BOOL finished) { [cover removeFromSuperview]; }];
    }
    if (tray != nil) {
        UIWindow *window = self.trayWindow;
        __weak SCPCarSplit *weakSelf = self;
        [UIView animateWithDuration:0.22 delay:0
                            options:UIViewAnimationOptionLayoutSubviews
            animations:^{
                tray.alpha = 0;
                tray.transform = CGAffineTransformScale(
                    CGAffineTransformMakeTranslation(0, -14), 0.92, 0.92);
            } completion:^(BOOL finished) {
                [tray removeFromSuperview];
                SCPCarSplit *s = weakSelf;
                if (window != nil && s != nil && s.tray == nil &&
                    s.ratioMenu == nil && s.pickerSheet == nil)
                    window.hidden = YES;
            }];
    }
}

- (void)removeAppTab {                                                   // 0x36f04
    [self collapseAppTray];
}

- (void)refreshAppTabSoon {                                              // 0x36f08 (approx.)
    __weak SCPCarSplit *weakSelf = self;
    SCPDispatchAfter(0.35, ^{ [weakSelf refreshAppTab]; });
}

- (void)refreshAppTab {                                                  // 0x36f60 (approx.)
    [self refreshHomeButton];
    if (self.tray != nil && self.tabParent != nil &&
        ![self viewIsRaised:self.tray]) // [phase2; backported to src in phase 3] viewIsRaised:/raiseView: are SCPCarSplit methods (binary); src sent them to the UIView* tabParent
        [self raiseView:self.tray];
    if (self.popupShield != nil && self.tabParent != nil &&
        ![self viewIsRaised:self.popupShield])
        [self raiseView:self.popupShield];
}

- (void)showPickerForFocusedPane {                                       // 0x37000 (approx.)
    if (!self.active) return;
    NSInteger slot = self.focusedSlot;
    if (slot < 0 || slot >= self.paneCount) slot = [self autoSlot];
    [self showPickerForSlot:(int)slot];
    SCPCarPane *pane = [self paneAtSlot:slot];
    if (pane != nil && pane.picker != nil) {
        self.pickerSheetPane = pane;
        [self refreshPickerSheetSoon];
    }
}

// MARK: - Loader (launch-in-progress overlay)

- (void)loaderCancelTapped:(UIView *)sender {                            // 0x38000 (approx.)
    SCPCarPane *pane = [self paneForView:sender];
    NSString *bundle = pane.loader.accessibilityIdentifier;
    OMCLogWrite(@"SplitScreen",
        [NSString stringWithFormat:@"CarSplit: huy mo %@ o %d", bundle, pane.slot]); // INFERRED wording
    if (bundle != nil)
        self.cancelledLaunches[bundle] = [NSDate date];
    [self launchFailed:bundle slot:pane.slot];
}

// CLOSED (was STUB-UNRECOVERED): full-screen loader card — app icon,
// display name, an arc spinner (0.9 s rotation + 0.8 s pulse) and a
// cancel chip; a 20 s watchdog fails the launch if it never lands.
// @0x2a7e8 (3,016 bytes).
- (void)showLoaderInPane:(SCPCarPane *)pane bundle:(NSString *)bundle {
    if (pane.view == nil) return;
    [self removeLoaderFromPane:pane animated:NO];
    UIView *loader = [[UIView alloc] initWithFrame:pane.view.bounds];
    loader.autoresizingMask = 0x12;
    loader.backgroundColor = [UIColor colorWithRed:0.9333333333333333
                                             green:0.9411764705882353
                                              blue:0.984313725490196
                                             alpha:1.0];
    loader.userInteractionEnabled = NO;   // set twice in the binary (NO, then YES)
    loader.accessibilityIdentifier = bundle;
    loader.userInteractionEnabled = YES;

    UIView *card = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 120, 112)];
    card.center = CGPointMake(CGRectGetMidX(loader.bounds),
                              CGRectGetMidY(loader.bounds));
    card.autoresizingMask = 0x2d;
    [loader addSubview:card];

    UIImageView *icon = [[UIImageView alloc] initWithFrame:CGRectMake(32, 0, 56, 56)];
    icon.image = SCPAppIconForBundle(bundle);
    SCPStyleGhostIcon(icon);
    icon.tag = 0x4e;
    [card addSubview:icon];

    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 62, 120, 16)];
    label.text = [self displayNameFor:bundle];
    label.textColor = SCPColorSecondary();
    label.font = [UIFont systemFontOfSize:12 weight:UIFontWeightMedium];
    label.textAlignment = NSTextAlignmentCenter;
    [card addSubview:label];

    UIView *ringView = [[UIView alloc] initWithFrame:CGRectMake(50, 88, 20, 20)];
    CAShapeLayer *ring = [CAShapeLayer layer];
    ring.frame = ringView.bounds;
    ring.path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(10, 10)
        radius:8 startAngle:-M_PI_2 endAngle:M_PI clockwise:YES].CGPath;
    ring.fillColor = nil;
    ring.strokeColor = [UIColor colorWithRed:0.6078431372549019
                                       green:0.5294117647058824
                                        blue:0.9725490196078431
                                       alpha:1.0].CGColor;
    ring.lineWidth = 2;
    ring.lineCap = kCALineCapRound;
    [ringView.layer addSublayer:ring];
    CABasicAnimation *spin = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    spin.toValue = @6.283185307179586;
    spin.duration = 0.9;
    spin.repeatCount = HUGE_VALF;
    [ringView.layer addAnimation:spin forKey:@"spin"];
    [card addSubview:ringView];

    double s = MIN(pane.view.bounds.size.width / 130.0,
                   pane.view.bounds.size.height / 124.0);
    if (s > 1) s = 1;
    if (s > 0.2) card.transform = CGAffineTransformMakeScale(s, s);

    [pane.view insertSubview:loader aboveSubview:pane.host];
    [pane.view bringSubviewToFront:pane.handle];
    [pane.view bringSubviewToFront:pane.bar];
    pane.loader = loader;

    UIButton *cancel = SCPMakeIconButton(SCPSymbolImage(@"close", 16.0),
                                         self, @selector(loaderCancelTapped:), 32.0);
    cancel.tintColor = [UIColor colorWithRed:1.0 green:0.35294117647058826
                                        blue:0.37254901960784315 alpha:1.0];
    cancel.backgroundColor = [cancel.tintColor colorWithAlphaComponent:0.14];
    cancel.center = CGPointMake(loader.bounds.size.width - 22, 22);
    cancel.autoresizingMask = 0x21;
    cancel.accessibilityLabel = OMCTr(@"Huỷ mở app", @"Cancel opening");
    [loader addSubview:cancel];

    __weak SCPCarSplit *weakSelf = self;
    __weak SCPCarPane *weakPane = pane;
    __weak UIView *weakLoader = loader;
    SCPDispatchAfter(20.0, ^{
        SCPCarSplit *self = weakSelf;
        SCPCarPane *p = weakPane;
        UIView *l = weakLoader;
        if (self == nil || p == nil || l == nil) return;
        if (p.loader != l) return;
        if ([self pendingSlotForBundle:bundle] >= 0) return;
        OMCLogWrite(@"SplitScreen",
            [NSString stringWithFormat:@"CarSplit: the dang mo %@ con sot -> bo",
                bundle]);
        [self launchFailed:bundle slot:-1];
    });

    loader.alpha = 0;
    card.transform = CGAffineTransformMakeScale(0.6, 0.6);
    [UIView animateWithDuration:0.2
        animations:^{ loader.alpha = 1; }];
    [UIView animateWithDuration:0.5 delay:0
         usingSpringWithDamping:0.6 initialSpringVelocity:0.6 options:0
        animations:^{ card.transform = CGAffineTransformIdentity; }
        completion:^(BOOL finished) {
            CABasicAnimation *pulse =
                [CABasicAnimation animationWithKeyPath:@"transform.scale"];
            pulse.fromValue = @1.0;
            pulse.toValue = @0.93;
            pulse.duration = 0.8;
            pulse.autoreverses = YES;
            pulse.repeatCount = HUGE_VALF;
            pulse.timingFunction = [CAMediaTimingFunction
                functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
            [card.layer addAnimation:pulse forKey:@"pulse"];
        }];
}

- (void)removeLoaderFromPane:(SCPCarPane *)pane animated:(BOOL)animated {
    UIView *loader = pane.loader;
    if (loader == nil) return;
    pane.loader = nil;
    if (animated) {
        [UIView animateWithDuration:0.3 delay:0.2 options:0
            animations:^{ loader.alpha = 0; }                             // INFERRED body
            completion:^(BOOL finished) { [loader removeFromSuperview]; }];
    } else {
        [loader removeFromSuperview];
    }
}

// MARK: - Toasts & tips

- (void)toast:(NSString *)text {                                         // 0x39000 (approx.)
    [self toast:text duration:2.6];
}

// CLOSED (was STUB-UNRECOVERED): a pill label (navy on white 0.94, font
// 14 Medium) centred 50 pt above the bottom of the dashboard root view;
// when the bridged pane is live it dodges to the first other visible
// pane so it does not cover the toast point. Fades in 0.2 s, out 0.3 s
// after `duration`. @0x44f80 (1,816 bytes).
- (void)toast:(NSString *)text duration:(double)duration {
    UIView *host = SCPDashboardRootViewController().view;
    if (host == nil || text.length == 0) return;
    UILabel *label = [[UILabel alloc] init];
    label.text = text;
    label.textColor = [UIColor colorWithRed:0.2901960784313726
                                      green:0.30980392156862746
                                       blue:0.5019607843137255 alpha:1.0];
    label.font = [UIFont systemFontOfSize:14 weight:UIFontWeightMedium];
    label.textAlignment = NSTextAlignmentCenter;
    label.numberOfLines = 2;
    double maxW = MAX(host.bounds.size.width - 48, 160);
    CGSize fitted = [label sizeThatFits:CGSizeMake(maxW - 32, 60)];
    double width = MIN(maxW, fitted.width + 32);
    double height = MAX(fitted.height + 18, 38);
    label.bounds = CGRectMake(0, 0, width, height);
    SCPStyleDragGhost(label, 19.0);
    label.backgroundColor = [UIColor colorWithWhite:1 alpha:0.94];
    double cx = CGRectGetMidX(host.bounds);
    double cy = host.bounds.size.height - 50;
    if (self.bridgedPane != nil && self.active && self.container != nil) {
        CGRect rect = [host convertRect:self.bridgedPane.view.frame
                               fromView:self.container];
        if (CGRectContainsPoint(CGRectInset(rect, -width / 2, -height / 2),
                                CGPointMake(cx, cy))) {
            for (SCPCarPane *pane in self.allPanes) {
                if (pane == self.bridgedPane || pane.view.alpha < 0.5) continue;
                CGRect frame = [host convertRect:pane.view.frame
                                       fromView:self.container];
                cx = CGRectGetMidX(frame);
                cy = CGRectGetMaxY(frame) - height / 2 - 12;
                break;
            }
        }
    }
    label.center = CGPointMake(cx, cy);
    [host addSubview:label];
    label.alpha = 0;
    [UIView animateWithDuration:0.2
        animations:^{ label.alpha = 1; }
        completion:^(BOOL finished) {
            [UIView animateWithDuration:0.3 delay:duration options:0
                animations:^{ label.alpha = 0; }
                completion:^(BOOL finished2) { [label removeFromSuperview]; }];
        }];
}

// CLOSED (was STUB-UNRECOVERED): "app is running in the background" toast
// with the app's icon, name, and a Reopen button; auto-dismisses after
// 5 s. Hosted in the tray window when there is one. @0x28c68
// (1,880 bytes).
- (void)showBackgroundToastFor:(NSString *)name slot:(int)slot {
    UIView *host = SCPDashboardRootViewController().view;
    if (host == nil) return;
    UIWindow *window = [self trayWindowForParent:host];
    UIView *container = (window != nil) ? (UIView *)window : host;
    [[container viewWithTag:0x5c9b] removeFromSuperview];
    UIView *toast = [[UIView alloc] initWithFrame:CGRectZero];
    toast.tag = 0x5c9b;

    UIImageView *icon = [[UIImageView alloc] initWithFrame:CGRectMake(7, 6, 24, 24)];
    icon.image = SCPAppIconForBundle(name);
    SCPStyleGhostIcon(icon);
    [toast addSubview:icon];

    UILabel *label = [[UILabel alloc] init];
    label.text = [NSString stringWithFormat:
        OMCTr(@"%@ đang chạy nền", @"%@ is running in the background"),
        [self displayNameFor:name]];
    label.textColor = [UIColor colorWithRed:0.2901960784313726
                                      green:0.30980392156862746
                                       blue:0.5019607843137255 alpha:1.0];
    label.font = [UIFont systemFontOfSize:13 weight:UIFontWeightMedium];
    [label sizeToFit];
    double labelW = MIN(label.bounds.size.width,
                        MAX(container.bounds.size.width - 196, 84));
    label.frame = CGRectMake(39, 0, labelW, 34);
    [toast addSubview:label];

    UIButton *button = [UIButton buttonWithType:0];
    [button setTitle:OMCTr(@"Mở lại", @"Reopen") forState:0];
    [button setTitleColor:UIColor.whiteColor forState:0];
    button.titleLabel.font = [UIFont systemFontOfSize:13 weight:UIFontWeightSemibold];
    double fittedW = [button.titleLabel sizeThatFits:CGSizeZero].width;
    button.frame = CGRectMake(CGRectGetMaxX(label.frame) + 10, 5,
                              fittedW + 24, 26);
    button.layer.cornerRadius = 13;
    SCPApplyAccent(button, YES);
    __weak UIView *weakToast = toast;
    __weak SCPCarSplit *weakSelf = self;
    UIAction *action = [UIAction actionWithHandler:^(UIAction *a) {
        [weakToast removeFromSuperview];
        SCPCarSplit *s = weakSelf;
        if (s == nil) return;
        [s hideTrayWindowIfIdle];
        int target = s.active ? MIN(slot, s.paneCount) : 0;
        OMCLogWrite(@"SplitScreen",
            [NSString stringWithFormat:@"CarSplit: [mo lai] %@ vao o %d",
                name, target]);
        [s openApp:name slot:target];
    }];
    [button addAction:action forControlEvents:UIControlEventTouchUpInside];
    [toast addSubview:button];

    toast.bounds = CGRectMake(0, 0, CGRectGetMaxX(button.frame) + 5, 34);
    SCPStyleRatioMenu(toast, 18.0);
    toast.center = CGPointMake(CGRectGetMidX(container.bounds), 26);
    [container addSubview:toast];
    SCPPrepareRatioMenu(toast);

    SCPDispatchAfter(5.0, ^{
        UIView *t = weakToast;
        if (t == nil) return;
        [UIView animateWithDuration:0.25
            animations:^{ t.alpha = 0; }
            completion:^(BOOL finished) {
                [t removeFromSuperview];
                [weakSelf hideTrayWindowIfIdle];
            }];
    });
}

// CLOSED (was PARTIAL): rotating usage tips. At most three tips are ever
// shown (tipCount is a SCPPrefs counter); the tip fires 3 s later and
// only while the split is active. @0x3b374 + block @0x3b570.
- (void)showTipSoon {
    NSInteger count = [SCPPrefs tipCount];
    if (count > 2) return;
    NSArray *tips = @[
        OMCTr(@"Mẹo: chạm 2 lần vào vạch chia để đổi chỗ 2 ô",
              @"Tip: double-tap a divider to swap the two panes"),
        OMCTr(@"Mẹo: giữ và kéo ••• thả lên ô khác để đổi chỗ",
              @"Tip: drag ••• onto another pane to swap them"),
        OMCTr(@"Mẹo: kéo vạch chia sát mép để đóng ô đó",
              @"Tip: drag a divider to the edge to close that pane")];
    [SCPPrefs setTipCount:count + 1];
    __weak SCPCarSplit *weakSelf = self;
    SCPDispatchAfter(3.0, ^{
        SCPCarSplit *s = weakSelf;
        if (s == nil || !s.active) return;
        [s toast:tips[count] duration:4.5];
    });
}

@end
