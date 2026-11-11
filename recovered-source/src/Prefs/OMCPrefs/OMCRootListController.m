// OMCRootListController.m — reconstructed from disasm/OMCRootListController.asm
// (30 methods). Principal class of OmniCarPrefs.bundle.
// Specifier sources: Root.plist (static, 15 items) + feature rows inserted
// in code from the bundle's Feature*.plist files.

#import "OMCRootListController.h"
#import "OMCCommon.h"
#import "OMCHeaderCard.h"
#import "OMCFeatureListController.h"
#import "OMCCells.h"
#import <Preferences/PSSpecifier.h>
#import <notify.h>

// Interfaces of controllers owned by other pages of this bundle
// (declared here to avoid cross-file coupling; selectors VERIFIED in asm).
@interface OMCOnboardingController : UIViewController
+ (BOOL)shouldShow;
+ (UINavigationController *)guideNavigationControllerWithCompletion:(void (^)(void))completion;
@end
@interface OMCWhatsNewController : UIViewController
+ (BOOL)shouldShow;
+ (void)markSeen;
+ (UINavigationController *)whatsNewNavigationController;
@end

@implementation OMCRootListController

#pragma mark - Specifiers

// [VERIFIED instruction-for-instruction]
- (NSArray *)specifiers {
    if (!_specifiers) {
        OMCLoadStrings();
        // Explicit resource bundle works both in the original Prefs bundle
        // and when this same class is compiled into OmniCar.app.
        NSBundle *resources = self.bundle ?: [NSBundle bundleForClass:[self class]];
        _specifiers = [self loadSpecifiersFromPlistName:@"Root"
                                               target:self bundle:resources];
        [self insertFeatureSpecifiers];
        OMCLocalizeSpecifiers(_specifiers);
        [self applySupportState];
        // [GPT-F] Candidate-only diagnostic (GPT consolidated fix §F; NOT a
        // restored behaviour — the original Prefs binary has no
        // OMCLogWrite). ONE emission per specifiers build: builds run per
        // pane presentation / reload, never per frame — that is the rate
        // limit. For every inserted feature specifier (identified by its
        // @"plist" property) this logs the plist name, the final index,
        // and the RUNTIME CLASS of the object stored under @"cellClass" —
        // the check that exposes a string stored where a Class belongs.
        {
            NSMutableArray<NSString *> *featureLines = [NSMutableArray array];
            for (NSUInteger i = 0; i < _specifiers.count; i++) {
                PSSpecifier *spec = _specifiers[i];
                NSString *plist = [spec propertyForKey:@"plist"];
                if (!plist) continue;
                [featureLines addObject:[NSString stringWithFormat:
                    @"%@ @%lu cellClass=%@", plist, (unsigned long)i,
                    NSStringFromClass([[spec propertyForKey:@"cellClass"] class])]];
            }
            OMCLogWrite(@"Prefs", [NSString stringWithFormat:
                @"[GPT-F] specifiers build [fixround7]: controller=%@ total=%lu features=[%@]",
                NSStringFromClass([self class]), (unsigned long)_specifiers.count,
                [featureLines componentsJoinedByString:@", "]]);
        }
    }
    return _specifiers;
}

// Builds one link row per Feature*.plist in the bundle and inserts them, in
// featureOrder, right after the empty "features" group of Root.plist.
// [VERIFIED: construction read from disassembly]
- (void)insertFeatureSpecifiers {
    NSBundle *bundle = self.bundle ?: [NSBundle bundleForClass:[self class]];
    NSMutableArray *found = [NSMutableArray array];
    for (NSString *path in [bundle pathsForResourcesOfType:@"plist" inDirectory:nil]) {
        NSString *name = [[path lastPathComponent] stringByDeletingPathExtension];
        if (![name hasPrefix:@"Feature"]) continue;
        NSDictionary *info = [NSDictionary dictionaryWithContentsOfFile:path];
        if (info) [found addObject:@{@"plist": name, @"info": info}];
    }
    [found sortUsingComparator:^NSComparisonResult(NSDictionary *a, NSDictionary *b) {
        return [a[@"info"][@"featureOrder"] compare:b[@"info"][@"featureOrder"]];
    }];

    NSUInteger insertAt = NSNotFound;
    for (NSUInteger i = 0; i < _specifiers.count; i++) {
        if ([_specifiers[i] identifier] && [[_specifiers[i] identifier] isEqualToString:@"features"]) {
            insertAt = i + 1;
            break;
        }
    }
    if (insertAt == NSNotFound) return;

    for (NSDictionary *entry in found) {
        NSDictionary *info = entry[@"info"];
        Class detail = NSClassFromString(info[@"featureController"]) ?: [OMCFeatureListController class];
        PSSpecifier *spec = [PSSpecifier preferenceSpecifierNamed:L(info[@"featureLabel"])
                                                           target:self
                                                              set:nil
                                                              get:nil
                                                           detail:detail
                                                             cell:PSLinkCell
                                                             edit:nil];
        [spec setProperty:entry[@"plist"] forKey:@"plist"];
        [spec setProperty:[OMCFeatureStatusCell class] forKey:@"cellClass"];
        if (info[@"featureIcon"]) [spec setProperty:info[@"featureIcon"] forKey:@"icon"];
        if (info[@"featureSymbol"]) [spec setProperty:info[@"featureSymbol"] forKey:@"symbol"];
        for (NSDictionary *item in info[@"items"]) {
            if ([item[@"cell"] isEqualToString:@"PSSwitchCell"]) {
                // [VERIFIED: original stamps both unconditionally
                // (asm 0x16328-0x16398); a missing "default" becomes
                // kCFBooleanTrue via csel, not an omitted property]
                [spec setProperty:item[@"key"] forKey:@"featureKey"];
                [spec setProperty:item[@"default"] ?: @YES forKey:@"featureDefault"];
            }
        }
        [_specifiers insertObject:spec atIndex:insertAt++];
    }
}

// "rescue1,rescue2|Active Conflict 1, Active Conflict 2" — a cheap change
// token for the two dynamic Root groups. [VERIFIED]
- (NSString *)currentSupportState {
    NSMutableArray *activeNames = [NSMutableArray array];
    for (NSDictionary *tweak in OMCConflictingTweaks()) {
        if ([tweak[@"active"] boolValue]) [activeNames addObject:tweak[@"name"]];
    }
    NSString *rescue = [OMCRescueFeatures() componentsJoinedByString:@","];
    NSString *conflicts = [activeNames componentsJoinedByString:@", "];
    return [NSString stringWithFormat:@"%@|%@", rescue, conflicts];
}

// Shows/hides the rescue + conflicts groups of Root.plist (both are stamped
// with an "omcGroup" property) and fills their text from the current state.
// [Reconstructed from the method's call graph; exact branch layout is in
// disasm/OMCRootListController.asm]
- (void)applySupportState {
    NSString *state = [self currentSupportState];
    self.supportState = state;
    NSArray *parts = [state componentsSeparatedByString:@"|"];
    NSString *rescuePart = parts.count > 0 ? parts[0] : @"";
    NSString *conflictPart = parts.count > 1 ? parts[1] : @"";

    for (PSSpecifier *spec in [_specifiers copy]) {
        NSString *group = [spec propertyForKey:@"omcGroup"];
        if ([group isEqualToString:@"rescue"]) {
            if (rescuePart.length == 0) {
                [_specifiers removeObject:spec];
            } else if ([[spec identifier] isEqualToString:@"rescueGroup"]) {
                NSArray *names = [rescuePart componentsSeparatedByString:@","];
                NSMutableArray *display = [NSMutableArray array];
                for (NSString *name in names) [display addObject:OMCFeatureDisplayName(name)];
                [spec setProperty:[NSString stringWithFormat:L(@"RESCUE_FOOTER"),
                                   [display componentsJoinedByString:@", "]]
                           forKey:@"footerText"];
            }
        } else if ([group isEqualToString:@"conflicts"]) {
            if (conflictPart.length == 0) {
                [_specifiers removeObject:spec];
            } else if ([[spec identifier] isEqualToString:@"conflictsGroup"]) {
                [spec setProperty:L(@"CONFLICTS_FOOTER") forKey:@"footerText"];
            } else if ([[spec identifier] isEqualToString:@"conflictsRow"]) {
                spec.name = conflictPart;
            }
        }
    }
}

#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [[UISwitch appearanceWhenContainedInInstancesOfClasses:@[[self class]]]
        setOnTintColor:OMCSwitchColor()];
    [[UISlider appearanceWhenContainedInInstancesOfClasses:@[[self class]]]
        setMinimumTrackTintColor:OMCAccentColor()];
    [self applyLanguage];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    CFPreferencesAppSynchronize(OMC_PREFS_DOMAIN);
    OMCStyleTable(self.table);
    if (![[self currentSupportState] isEqualToString:self.supportState]) {
        [self reloadSpecifiers];
    }
    [self updateHeaderStatus];
}

- (void)traitCollectionDidChange:(UITraitCollection *)previous {
    [super traitCollectionDidChange:previous];
    if (self.traitCollection.userInterfaceStyle != previous.userInterfaceStyle) {
        OMCStyleTable(self.table);
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (self.presentedViewController) return;
    if ([OMCOnboardingController shouldShow]) {
        [self showGuide];
    } else if ([OMCWhatsNewController shouldShow]) {
        [self showWhatsNew];
        [OMCWhatsNewController markSeen];
    }
}

#pragma mark - Header card / language / master switch

- (void)applyLanguage {
    self.navigationItem.title = @"OmniCar";
    UIBarButtonItem *respringButton =
        [[UIBarButtonItem alloc] initWithImage:[UIImage systemImageNamed:@"arrow.clockwise"]
                                         style:UIBarButtonItemStylePlain
                                        target:self
                                        action:@selector(respring)];
    respringButton.accessibilityLabel = L(@"RESPRING");
    respringButton.tintColor = [UIColor labelColor];
    self.navigationItem.rightBarButtonItems = @[respringButton, [self languageButton]];
    self.table.tableHeaderView = [self headerView];
}

- (UIBarButtonItem *)languageButton {
    NSMutableArray *actions = [NSMutableArray array];
    NSString *current = OMCLanguage();
    for (NSString *code in OMCLanguages()) {
        UIAction *action = [UIAction actionWithTitle:OMCLanguageName(code)
                                               image:nil
                                          identifier:code
                                             handler:^(__kindof UIAction *a) {
                                                 [self setLanguage:a.identifier];
                                             }];
        action.state = [code isEqualToString:current] ? UIMenuElementStateOn : UIMenuElementStateOff;
        [actions addObject:action];
    }
    UIBarButtonItem *button =
        [[UIBarButtonItem alloc] initWithImage:[UIImage systemImageNamed:@"globe"]
                                         style:UIBarButtonItemStylePlain
                                        target:self
                                        action:nil];
    button.menu = [UIMenu menuWithTitle:L(@"LANGUAGE") children:actions];
    button.tintColor = [UIColor labelColor];
    return button;
}

// [VERIFIED: writes the pref and refreshes UI; note — unlike other writes
// this one does NOT post com.anlai.omnicar/prefschanged]
- (void)setLanguage:(NSString *)code {
    CFPreferencesSetAppValue(CFSTR("language"), (__bridge CFTypeRef)code, OMC_PREFS_DOMAIN);
    CFPreferencesAppSynchronize(OMC_PREFS_DOMAIN);
    [self applyLanguage];
    [self reloadSpecifiers];
}

- (UIView *)headerView {
    if (!self.headerCard) {
        self.headerCard = [[OMCHeaderCard alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 118)];
        [self.headerCard.toggle addTarget:self
                                   action:@selector(masterToggled:)
                         forControlEvents:UIControlEventValueChanged];
    }
    UIView *container = [[UIView alloc] initWithFrame:self.headerCard.bounds];
    container.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    [container addSubview:self.headerCard];
    [self updateHeaderStatus];
    return container;
}

- (void)updateHeaderStatus {
    [self updateHeaderStatusEnabled:OMCEnabled()];
}

- (void)updateHeaderStatusEnabled:(BOOL)enabled {
    BOOL expired = OMCExpired();
    self.headerCard.toggle.enabled = !expired;
    [self.headerCard updateWithTagline:L(@"HEADER_TAGLINE")
                                status:expired ? L(@"STATUS_EXPIRED")
                                               : (enabled ? L(@"STATUS_ON") : L(@"STATUS_OFF"))
                               enabled:enabled];
}

// Master switch in the header card. [VERIFIED]
- (void)masterToggled:(UISwitch *)sender {
    BOOL on = sender.isOn;
    CFPreferencesSetAppValue(CFSTR("enabled"), (__bridge CFTypeRef)@(on), OMC_PREFS_DOMAIN);
    CFPreferencesAppSynchronize(OMC_PREFS_DOMAIN);
    notify_post(OMC_PREFS_CHANGED_NOTIFICATION);
    [self updateHeaderStatusEnabled:on];
}

#pragma mark - Table styling

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = nil;
    @try {
        cell = [super tableView:tableView cellForRowAtIndexPath:indexPath];
        OMCStyleCell(cell);
    } @catch (NSException *exception) {
        // [GPT-F] Candidate-only diagnostic (GPT consolidated fix §F; NOT a
        // restored behaviour): log the failing coordinates and the
        // exception, then RETHROW — behaviour is unchanged, nothing is
        // swallowed or continued past.
        NSString *specifierID = nil;
        @try {
            PSSpecifier *spec = [self specifierAtIndexPath:indexPath];
            specifierID = [spec identifier] ?: [spec propertyForKey:@"plist"];
        } @catch (NSException *lookupException) {
            (void)lookupException;
            specifierID = nil;
        }
        OMCLogWrite(@"Prefs", [NSString stringWithFormat:
            @"[GPT-F] cellForRow exception: controller=%@ section=%ld row=%ld specifier=%@ name=%@ reason=%@ stack=%@",
            NSStringFromClass([self class]), (long)indexPath.section,
            (long)indexPath.row, specifierID, exception.name, exception.reason,
            [exception.callStackSymbols componentsJoinedByString:@" | "]]);
        @throw;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section {
    if ([PSListController instancesRespondToSelector:@selector(tableView:willDisplayHeaderView:forSection:)]) {
        [super tableView:tableView willDisplayHeaderView:view forSection:section];
    }
    OMCStyleHeaderFooter(view);
}

- (void)tableView:(UITableView *)tableView willDisplayFooterView:(UIView *)view forSection:(NSInteger)section {
    if ([PSListController instancesRespondToSelector:@selector(tableView:willDisplayFooterView:forSection:)]) {
        [super tableView:tableView willDisplayFooterView:view forSection:section];
    }
    OMCStyleHeaderFooter(view);
}

#pragma mark - Actions (Root.plist buttons + header)

- (void)showMessage:(NSString *)message {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"OmniCar"
                                                                   message:message
                                                            preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil]];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)sendLog {
    OMCShareReport(self);
}

- (void)showGuide {
    UINavigationController *nav =
        [OMCOnboardingController guideNavigationControllerWithCompletion:^{
            [self reloadSpecifiers];
            [self updateHeaderStatus];
        }];
    if (!self.presentedViewController) {
        [self presentViewController:nav animated:YES completion:nil];
    }
}

- (void)showWhatsNew {
    UINavigationController *nav = [OMCWhatsNewController whatsNewNavigationController];
    if (!self.presentedViewController) {
        [self presentViewController:nav animated:YES completion:nil];
    }
}

- (void)rescueRestore {
    OMCRescueRestore();
    [self showMessage:L(@"RESCUE_RESTORED")];
    [self reloadSpecifiers];
}

- (void)respring {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:L(@"RESPRING")
                                                                   message:L(@"RESPRING_CONFIRM")
                                                            preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:L(@"CANCEL") style:UIAlertActionStyleCancel handler:nil]];
    [alert addAction:[UIAlertAction actionWithTitle:L(@"RESPRING") style:UIAlertActionStyleDestructive
                                            handler:^(UIAlertAction *a) { [self performRespring]; }]];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)performRespring {
    OMCRespring();
}

@end
