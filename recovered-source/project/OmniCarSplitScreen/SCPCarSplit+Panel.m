// SCPCarSplit+Panel.m — OmniCarSplitScreen reconstruction, module SplitScreenB.
// The layout panel: a tray-hosted sheet listing layout choices, recent
// layouts and favourite layouts for one app (the "choose layout" UI),
// plus paneChoose: (the pane bar's choose-app action that feeds it).
//
// CLOSURE (wave 3, finisher): showLayoutPanelForApp:, panelSections: and
// panelChoiceTappedUnsafe: were STUB-UNRECOVERED; all three are now
// reconstructed line-by-line from the disassembly — see the "Closure
// addendum" in SplitScreenB_REPORT.md. Two signature-level corrections
// to the earlier draft are flagged inline (panelSections: takes an
// out-pointer, and paneChoose: shows its bar with NO, not YES).

#import "SCPCarSplit.h"
#import "SCPCarPane.h"
#import "SCPCommon.h" // [phase2; backported to src in phase 3] OMC* declarations used in this TU
#import "SCPCButton.h" // [phase2; backported to src in phase 3] SCPCButton interface used in this TU

// Shared visual helpers implemented in other SplitScreenB files:
extern UIVisualEffectView *SCPKnobFaceView(void);                     // 0x35c74 (Chrome) — [phase2; backported to src in phase 3] ONE name (phase2 unification)
extern void SCPApplyMeshBackdrop(UIVisualEffectView *effectView);       // 0x35d5c (Chrome)
extern UIButton *SCPWrapRatioChip(UIImage *image, id target, SEL action); // 0x302f8 (RatioMenu)
extern UIImage *SCPSymbolImage(NSString *name, double pointSize);       // 0x2b474 (RatioMenu)
extern void SCPStyleChip(UIView *view, double radius);                  // 0x35f70 (Chrome)
extern void SCPMarkRatioChipSelected(UIView *chip);                     // 0x30450 (RatioMenu)
extern UIColor *SCPColorSecondary(void);                                // 0x2b380 (Chrome)
extern UIImage *SCPAppIconForBundle(NSString *bundleID);                // 0xdec8
extern void SCPStyleGhostIcon(UIImageView *imageView);                  // 0x21158 (Drag)

// MARK: - Layout glyph previews (choice buttons)
//
// Each choice button shows a miniature diagram of its layout, rendered
// with UIGraphicsImageRenderer. The rect list per layout is computed from
// the split fractions on a 2.5 pt gap grid (floor + remainder-to-last,
// the same rule as the real layout); layout 31 is layout 13 mirrored.
// The draw block @0x4829c fills each rect (white, alpha depending on
// selection), strokes it, and either clips the slot's app icon into it
// or draws a "+" when the slot is empty.
//
// Axis assignment of the 13/31 base rects and of the glyph totals is
// INFERRED from the constant pairs (36.5/35.5, 20.5/19.5); the 2/3
// enumeration, the mirror pass for 31 and all draw constants are
// VERIFIED from the dumps.

static NSArray<NSValue *> *SCPLayoutGlyphRects(NSInteger layoutID, BOOL vertical,
                                               double *outW, double *outH) {
    double total = vertical ? 40.0 : 73.0;   // split-axis extent @sp+0xf0
    double cross = vertical ? 73.0 : 40.0;   // INFERRED swap
    NSMutableArray<NSValue *> *rects = [NSMutableArray array];
    if (layoutID == 13 || layoutID == 31) {
        double halfA = vertical ? 36.5 : 35.5;
        double halfB = total - halfA;
        double crossA = vertical ? 20.5 : 19.5;
        double crossB = 40.0 - crossA;
        if (vertical) {
            [rects addObject:[NSValue valueWithCGRect:CGRectMake(0, 0, total, 18)]];
            [rects addObject:[NSValue valueWithCGRect:CGRectMake(0, crossA, halfA, crossB)]];
            [rects addObject:[NSValue valueWithCGRect:CGRectMake(halfA, crossA, halfB, crossB)]];
        } else {
            [rects addObject:[NSValue valueWithCGRect:CGRectMake(0, 0, 18, total)]];
            [rects addObject:[NSValue valueWithCGRect:CGRectMake(crossA, 0, crossB, halfA)]];
            [rects addObject:[NSValue valueWithCGRect:CGRectMake(crossA, halfA, crossB, halfB)]];
        }
        if (layoutID == 31) {
            // Mirror every rect along the split axis.
            for (NSUInteger i = 0; i < rects.count; i++) {
                CGRect r = rects[i].CGRectValue;
                if (vertical) r.origin.y = cross - CGRectGetMaxY(r);
                else          r.origin.x = total - CGRectGetMaxX(r);
                rects[i] = [NSValue valueWithCGRect:r];
            }
        }
        if (outW) *outW = vertical ? total : cross;
        if (outH) *outH = vertical ? cross : total;
        return rects;
    }
    NSInteger n = (layoutID == 3) ? 3 : 2;
    double inner = total - (n - 1) * 2.5;
    double each = floor(inner / n);
    double pos = 0;
    for (NSInteger i = 0; i < n; i++) {
        double size = (i == n - 1) ? (inner - each * (n - 1)) : each;
        CGRect r = vertical ? CGRectMake(0, pos, total, size)
                            : CGRectMake(pos, 0, size, total);
        [rects addObject:[NSValue valueWithCGRect:r]];
        pos += size + 2.5;
    }
    if (outW) *outW = vertical ? total : cross;
    if (outH) *outH = vertical ? cross : total;
    return rects;
}

// Draw block @0x4829c, transcribed: per rect, fill + stroke, then the
// slot's app icon (clipped to a rounded rect, corner radius = side*0.27)
// or a plus sign (arm = MIN(floor(min dimension * 0.25), 4), lineWidth
// 1.4, round caps, drawn in the secondary colour).
static UIImage *SCPRenderLayoutGlyph(CGSize size, NSArray<NSValue *> *rects,
                                     NSArray *apps, UIColor *fillColor,
                                     UIColor *borderColor, UIColor *plusColor) {
    UIGraphicsImageRenderer *renderer =
        [[UIGraphicsImageRenderer alloc] initWithSize:size];
    return [renderer imageWithActions:^(UIGraphicsImageRendererContext *ctx) {
        (void)ctx;
        for (NSUInteger i = 0; i < rects.count; i++) {
            CGRect rect = rects[i].CGRectValue;
            UIImage *icon = nil;
            if (i < apps.count && [apps[i] isKindOfClass:NSString.class])
                icon = SCPAppIconForBundle(apps[i]);
            [fillColor setFill];
            [[UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:5] fill];
            [borderColor setStroke];
            UIBezierPath *strokePath = [UIBezierPath
                bezierPathWithRoundedRect:CGRectInset(rect, 0.75, 0.75)
                             cornerRadius:4.4];
            strokePath.lineWidth = 1.5;
            [strokePath stroke];
            double minDim = MIN(rect.size.width, rect.size.height);
            if (icon != nil) {
                double side = floor(minDim - 4);
                CGRect iconRect = CGRectMake(CGRectGetMidX(rect) - side * 0.5,
                                             CGRectGetMidY(rect) - side * 0.5,
                                             side, side);
                CGContextSaveGState(UIGraphicsGetCurrentContext());
                [[UIBezierPath bezierPathWithRoundedRect:iconRect
                                            cornerRadius:side * 0.27] addClip];
                [icon drawInRect:iconRect];
                CGContextRestoreGState(UIGraphicsGetCurrentContext());
            } else {
                double arm = MIN(floor(minDim * 0.25), 4);
                UIBezierPath *plus = [UIBezierPath bezierPath];
                plus.lineWidth = 1.4;
                plus.lineCapStyle = kCGLineCapRound;
                double mx = CGRectGetMidX(rect), my = CGRectGetMidY(rect);
                [plus moveToPoint:CGPointMake(mx - arm, my)];
                [plus addLineToPoint:CGPointMake(mx + arm, my)];
                [plus moveToPoint:CGPointMake(mx, my - arm)];
                [plus addLineToPoint:CGPointMake(mx, my + arm)];
                [plusColor setStroke];
                [plus stroke];
            }
        }
    }];
}

@implementation SCPCarSplit (Panel)

// The pane bar's "choose" action. CLOSED against the dump @0x29f28:
// the bar is hidden (setBarVisible:NO), a pinned slot only toasts, and
// there is NO trailing log line (the earlier draft's log + YES were
// wrong; the toast key is the UTF-16 string 'Ô này đang ghim').
- (void)paneChoose:(UIView *)sender {
    SCPCarPane *pane = [self paneForView:sender];
    if (pane == nil) return;
    [self setBarVisible:NO forPane:pane];
    if ([self slotIsPinned:pane.slot]) {
        [self toast:OMCTr(@"Ô này đang ghim", @"This pane is pinned")];
        return;
    }
    [self showPickerForSlot:pane.slot];
    if (pane.picker != nil) {
        self.pickerSheetPane = pane;
        [self refreshPickerSheetSoon];
    }
}

// CLOSED (was STUB-UNRECOVERED): builds the layout panel in the app tray.
// Sections are rows (icon + title at the left), choices flow horizontally
// as 88 pt columns of glyph buttons. Below the first section: a divider
// and the exit/close chip. When the panel is not hosted in the tray
// window, hosted panes get covers and a solo app gets a placeholder
// cover. Entrance is a spring from alpha 0 / scale 0.92 / -18 pt, with
// the choice buttons staggered in. @0x37e8c (9,628 bytes region; the
// method spans 0x37e8c..0x3a428).
- (void)showLayoutPanelForApp:(NSString *)bundleID {
    [self collapseAppTray];
    UIView *parent = self.tabParent;
    if (parent == nil) return;
    if (![SCPPrefs enabled]) return;
    self.layoutApp = bundleID;

    CGRect area = [self appAreaInParent:parent];
    UIWindow *window = [self trayWindowForParent:parent];
    self.trayOverlay = (window != nil);
    [self publishBusy];
    if (window == nil && !self.active && self.soloHostedBundle != nil)
        [self setFullscreenBridgeHidden:YES bundle:self.soloHostedBundle];

    BOOL vertical = self.vertical;
    NSArray *kinds = nil;
    NSArray *sections = [self panelSections:&kinds];
    NSInteger currentLayoutID = self.active ? self.layoutID : 0;

    NSMutableArray *currentApps = [NSMutableArray array];
    if (self.active) {
        for (SCPCarPane *slot in self.slots)
            [currentApps addObject:(slot.vc != nil && slot.bundleID != nil)
                                        ? slot.bundleID : [NSNull null]];
    } else if (bundleID != nil) {
        [currentApps addObject:bundleID];
    }

    NSDictionary *titles = @{
        @"layouts":  OMCTr(@"Bố cục", @"Layouts"),
        @"recent":   OMCTr(@"Gần đây", @"Recent"),
        @"favorite": OMCTr(@"Yêu thích", @"Favorites")};

    NSInteger maxChoices = 1;
    for (NSArray *section in sections)
        maxChoices = MAX(maxChoices, (NSInteger)section.count);

    double frameW = MIN(104.0 + maxChoices * 88.0, area.size.width - 16.0);
    double frameH = MIN((double)sections.count * 56.0 + 20.0 +
                        (double)(sections.count - 1) * 6.0,
                        area.size.height - 12.0);
    CGRect frame = CGRectMake(CGRectGetMidX(area) - frameW * 0.5,
                              CGRectGetMinY(area) + 6.0, frameW, frameH);
    if (window != nil)
        frame = [parent convertRect:frame toView:nil];

    UIView *panel = [[UIView alloc] initWithFrame:frame];
    panel.layer.cornerRadius = 24;
    panel.layer.cornerCurve = kCACornerCurveContinuous;
    panel.layer.shadowColor = [UIColor colorWithRed:0.43137254901960786
                                              green:0.39215686274509803
                                               blue:0.7843137254901961
                                              alpha:1.0].CGColor;
    panel.layer.shadowOpacity = 0.3f;
    panel.layer.shadowRadius = 24;
    panel.layer.shadowOffset = CGSizeMake(0, 8);

    UIVisualEffectView *effectView = SCPKnobFaceView(); // [phase2; backported to src in phase 3] name unified
    effectView.frame = panel.bounds;
    SCPApplyMeshBackdrop(effectView);
    effectView.layer.cornerRadius = 24;
    effectView.layer.cornerCurve = kCACornerCurveContinuous;
    effectView.clipsToBounds = YES;
    [panel addSubview:effectView];

    UIScrollView *scroll = [[UIScrollView alloc]
        initWithFrame:effectView.contentView.bounds];
    scroll.showsVerticalScrollIndicator = NO;
    scroll.delegate = self;
    [effectView.contentView addSubview:scroll];

    NSMutableArray *choices = [NSMutableArray array];
    NSMutableArray *buttons = [NSMutableArray array];
    double colW = vertical ? 40.0 : 73.0;
    (void)colW;
    double runningY = 10.0;

    for (NSUInteger s = 0; s < sections.count; s++) {
        NSString *kind = kinds[s];
        UIImageView *iconView = [[UIImageView alloc]
            initWithImage:SCPSymbolImage(kind, 18.0)];
        iconView.tintColor = SCPColorSecondary();
        iconView.center = CGPointMake(26, runningY + 28);
        if (s == 0 && self.active)
            iconView.accessibilityLabel = OMCTr(@"Đổi bố cục", @"Change layout");
        else
            iconView.accessibilityLabel = titles[kind];
        [scroll addSubview:iconView];

        NSArray *section = sections[s];
        for (NSUInteger j = 0; j < section.count; j++) {
            NSDictionary *choice = section[j];
            NSInteger layoutID = [choice[@"layout"] intValue];
            SCPCButton *button = [SCPCButton buttonWithType:0];
            button.frame = CGRectMake(41.0 + (double)j * 88.0, runningY, 56, 41);
            button.tag = (NSInteger)choices.count;
            button.accessibilityLabel = choice[@"name"];
            [choices addObject:choice];
            [button addTarget:self action:@selector(panelChoiceTapped:)
                     forControlEvents:UIControlEventTouchUpInside];
            button.layer.cornerRadius = 14;
            button.layer.cornerCurve = kCACornerCurveContinuous;
            button.backgroundColor = UIColor.clearColor;
            button.layer.borderWidth = 1;
            button.layer.borderColor =
                [UIColor colorWithWhite:1 alpha:0.75].CGColor;
            BOOL selected = (s == 0 && layoutID == currentLayoutID);
            if (selected) SCPMarkRatioChipSelected(button);

            NSArray *apps = choice[@"apps"] ?: currentApps;
            double glyphW = 0, glyphH = 0;
            NSArray<NSValue *> *rects =
                SCPLayoutGlyphRects(layoutID, vertical, &glyphW, &glyphH);
            UIColor *fill = [UIColor colorWithWhite:1
                alpha:selected ? 0.75 : 0.45];
            UIColor *border = [UIColor colorWithWhite:1 alpha:0.95];
            UIImage *glyph = SCPRenderLayoutGlyph(
                CGSizeMake(glyphW, glyphH), rects, apps,
                fill, border, SCPColorSecondary());
            UIImageView *glyphView = [[UIImageView alloc] initWithImage:glyph];
            glyphView.center = CGPointMake(41, 28);
            glyphView.userInteractionEnabled = NO;
            [button addSubview:glyphView];
            [scroll addSubview:button];
            [buttons addObject:button];
        }

        if (section.count == 0) {
            // Empty section: a dashed placeholder row.
            UIView *placeholder = [[UIView alloc] initWithFrame:
                CGRectMake(8, runningY + 8, frameW, 48)];   // size INFERRED
            CAShapeLayer *dash = (CAShapeLayer *)placeholder.layer;
            dash.path = [UIBezierPath
                bezierPathWithRoundedRect:CGRectInset(placeholder.bounds, 0.5, 0.5)
                             cornerRadius:6].CGPath;
            dash.fillColor = nil;
            dash.strokeColor = [[UIColor colorWithRed:0.2901960784313726
                                                green:0.30980392156862746
                                                 blue:0.5019607843137255
                                                alpha:1.0]
                colorWithAlphaComponent:0.25].CGColor;
            dash.lineWidth = 1;
            dash.lineDashPattern = @[@4, @3];   // static array @0x800500, contents INFERRED
            placeholder.accessibilityLabel =
                OMCTr(@"Chia màn xong sẽ hiện ở đây",
                      @"Finished splits will appear here");
            [scroll addSubview:placeholder];
        }

        if (s == 0) {
            double innerW = 41.0 + maxChoices * 88.0 + 2.0;
            UIView *divider = [[UIView alloc] initWithFrame:
                CGRectMake(innerW, runningY + 10, 1, 33)];
            divider.backgroundColor = [UIColor colorWithWhite:1 alpha:0.95];
            [scroll addSubview:divider];

            UIButton *exitButton = SCPWrapRatioChip(
                SCPSymbolImage(@"exit", 20.0), self, @selector(exitTapped));
            exitButton.tintColor = [UIColor colorWithRed:1.0
                                                   green:0.35294117647058826
                                                    blue:0.37254901960784315
                                                   alpha:1.0];
            SCPStyleChip(exitButton, exitButton.bounds.size.width * 0.5);
            exitButton.center = CGPointMake(innerW + 28.0, 38);
            exitButton.accessibilityLabel = self.active
                ? OMCTr(@"Thoát chia màn", @"Exit split")
                : OMCTr(@"Đóng", @"Close");
            NSString *keep = self.exitKeepBundle;
            if (keep != nil) {
                UIImage *keepIcon = SCPAppIconForBundle(keep);
                if (keepIcon != nil) {
                    UIImageView *badge = [[UIImageView alloc] initWithFrame:
                        CGRectMake(exitButton.bounds.size.width - 15,
                                   exitButton.bounds.size.height - 15, 16, 16)];
                    badge.image = keepIcon;
                    SCPStyleGhostIcon(badge);
                    badge.layer.borderWidth = 1;
                    badge.layer.borderColor = UIColor.whiteColor.CGColor;
                    badge.userInteractionEnabled = NO;
                    [exitButton addSubview:badge];
                }
            }
            [scroll addSubview:exitButton];
            [buttons addObject:exitButton];
        }
        runningY += 62.0;
    }

    scroll.contentSize = CGSizeMake(104.0 + maxChoices * 88.0, runningY + 4.0);
    self.panelChoices = choices;

    UIView *host = (window != nil) ? (UIView *)window : parent;
    [host addSubview:panel];
    self.tray = panel;
    [self updatePopupShield];
    [self pushHostFramesLive:NO];

    if (window == nil) {
        for (SCPCarPane *pane in [self hostedPanes])
            [self addCoverToPane:pane];
        if (!self.active && self.soloHostedBundle != nil) {
            [self.trayCover removeFromSuperview];
            UIView *cover = [[UIView alloc] initWithFrame:area];
            cover.backgroundColor = [UIColor colorWithRed:0.9333333333333333
                                                    green:0.9411764705882353
                                                     blue:0.984313725490196
                                                    alpha:1.0];
            cover.userInteractionEnabled = NO;
            UIImageView *icon = [[UIImageView alloc]
                initWithFrame:CGRectMake(0, 0, 56, 56)];
            icon.image = SCPAppIconForBundle(self.soloHostedBundle);
            SCPStyleGhostIcon(icon);
            icon.center = CGPointMake(cover.bounds.size.width * 0.5,
                                      cover.bounds.size.height * 0.5);
            [cover addSubview:icon];
            [parent addSubview:cover];
            [self raiseView:cover];
            self.trayCover = cover;
        }
    }
    [self raiseView:panel];
    [self raiseView:self.popupShield];

    panel.alpha = 0;
    panel.transform = CGAffineTransformScale(
        CGAffineTransformMakeTranslation(0, -18), 0.92, 0.92);
    [UIView animateWithDuration:0.5 delay:0
         usingSpringWithDamping:0.86 initialSpringVelocity:0.4 options:2
        animations:^{
            panel.alpha = 1;
            panel.transform = CGAffineTransformIdentity;
        } completion:nil];
    NSInteger stagger = 0;
    for (UIView *button in buttons) {
        button.alpha = 0;
        button.transform = CGAffineTransformMakeTranslation(0, 12);
        [UIView animateWithDuration:0.45
                              delay:stagger * 0.025 + 0.06
             usingSpringWithDamping:0.85 initialSpringVelocity:0.3 options:2
            animations:^{
                button.alpha = 1;
                button.transform = CGAffineTransformIdentity;
            } completion:nil];
        stagger++;
    }
    [self restartTrayTimer];

    NSMutableArray *names = [NSMutableArray array];
    for (NSArray *section in sections)
        [names addObject:[[section valueForKey:@"name"]
            componentsJoinedByString:@","]];
    OMCLogWrite(@"SplitScreen",
        [NSString stringWithFormat:
            @"CarSplit: bang bo cuc cho %@ (%@, %lu lua chon: %@)",
            bundleID ?: (self.active ? @"doi bo cuc" : @"cap lan truoc"),
            [kinds componentsJoinedByString:@" / "],
            (unsigned long)choices.count,
            [names componentsJoinedByString:@" | "]]);
}

// CLOSED (was STUB-UNRECOVERED): the section model. SIGNATURE
// CORRECTION: the second argument is an OUT-POINTER for the section
// kinds array (the earlier draft declared it (NSString *)bundleID —
// the binary stores the argument, never reads it as a string, and
// writes the titles array through it at the end). Sections:
//   layouts  — the four layout choices (2, 3, 13, 31) with OMCTr names;
//   recent   — (showRecent) one choice per recent layout with >1 apps,
//              named by its CarPlay apps' display names joined " + ";
//   favorite — (showFavorites) favourites 1..3 that resolve to apps.
- (NSArray *)panelSections:(NSArray **)titlesOut { // [phase2; backported to src in phase 3] out-pointer type unified with header + caller (was NSString**)
    NSMutableArray *sections = [NSMutableArray array];
    NSMutableArray *titles = [NSMutableArray array];

    NSArray *layoutChoices = @[
        @{@"layout": @2,  @"name": OMCTr(@"2 ô", @"2 panes")},
        @{@"layout": @3,  @"name": OMCTr(@"3 ô", @"3 panes")},
        @{@"layout": @13, @"name": OMCTr(@"1 lớn + 2", @"1 large + 2")},
        @{@"layout": @31, @"name": OMCTr(@"2 + 1 lớn", @"2 + 1 large")}];
    [sections addObject:layoutChoices];
    [titles addObject:@"layouts"];

    NSMutableArray *recentChoices = [NSMutableArray array];
    if ([SCPPrefs showRecent]) {
        for (NSDictionary *entry in [SCPPrefs recentLayouts]) {
            NSArray *apps = entry[@"apps"];
            NSMutableArray *names = [NSMutableArray array];
            for (id app in apps)
                if ([app isKindOfClass:NSString.class] &&
                    [self isCarPlayApp:app])
                    [names addObject:[self displayNameFor:app]];
            if (apps.count > 1)
                [recentChoices addObject:@{
                    @"layout": entry[@"layout"],
                    @"apps": apps,
                    @"name": [names componentsJoinedByString:@" + "]}];
        }
        [sections addObject:recentChoices];
        [titles addObject:@"recent"];
    }

    NSMutableArray *favChoices = [NSMutableArray array];
    if ([SCPPrefs showFavorites]) {
        for (NSInteger i = 1; i < 4; i++) {
            NSDictionary *fav = [SCPPrefs favorite:i];
            NSArray *apps = [self favoriteApps:fav];
            if (apps != nil)
                [favChoices addObject:@{
                    @"layout": fav[@"layout"] ?: @2,
                    @"apps": apps,
                    @"name": fav[@"name"] ?: @""}];
        }
    }
    if (favChoices.count > 0) {
        [sections addObject:favChoices];
        [titles addObject:@"favorite"];
    }

    if (titlesOut != nil) *titlesOut = titles;
    return sections;
}

// CLOSED: the @try wrapper; the catch format is now exact.
- (void)panelChoiceTapped:(UIView *)sender {                             // 0x3a4d0
    @try {
        [self panelChoiceTappedUnsafe:sender];
    } @catch (id exception) {
        OMCLogWrite(@"SplitScreen",
            [NSString stringWithFormat:@"CarSplit: loi chon bo cuc %@\n%@",
                exception, ((NSException *)exception).callStackSymbols]);
    }
}

// CLOSED (was STUB-UNRECOVERED): choice dispatch. A choice carrying an
// app list re-opens the layout in setup mode (the current layoutApp is
// logged as replaced); a bare layout choice finishes through
// layoutChosenID:. @0x3a5e8 (644 bytes).
- (void)panelChoiceTappedUnsafe:(UIView *)sender {
    NSInteger tag = sender.tag;
    if (tag < 0 || tag >= (NSInteger)self.panelChoices.count) return;
    NSDictionary *choice = self.panelChoices[tag];
    if (choice == nil) return;
    int layoutID = [choice[@"layout"] intValue];
    NSArray *apps = choice[@"apps"];
    if (apps != nil) {
        NSString *app = self.layoutApp;
        self.layoutApp = nil;
        [self collapseAppTray];
        OMCLogWrite(@"SplitScreen",
            [NSString stringWithFormat:
                @"CarSplit: mo lai %@ (bo cuc %d, app %@, thay cho %@)",
                choice[@"name"], layoutID, apps, app ?: @"-"]);
        [self openSetupLayout:layoutID apps:apps];
    } else {
        [self layoutChosenID:layoutID];
    }
}

@end
