// OMCFeatureListController.m — reconstructed from disasm/OMCFeatureListController.asm.
// Base class for plist-driven feature pages. The concrete page is chosen by
// the "plist" property that -[OMCRootListController insertFeatureSpecifiers]
// stamps on the link specifier (FeatureStartupScreen -> this class directly;
// SpeedBubble/SplitScreen use the OMCCardPage subclasses instead).

#import "OMCFeatureListController.h"
#import "OMCCommon.h"
#import <Preferences/PSSpecifier.h>

@implementation OMCFeatureListController

- (NSArray *)specifiers {
    // [W1] Bracket (W1 plan, OMCFeatureListController point 2):
    // synchronous [W1] logs with the plist name + resulting count.
    NSString *w1Plist = [self.specifier propertyForKey:@"plist"];
    OMCLogWriteSync(@"Prefs", [NSString stringWithFormat:
        @"[W1] OMCFeatureListController specifiers enter controller=%@ plist=%@",
        NSStringFromClass([self class]), w1Plist]);
    if (!_specifiers) {
        OMCLoadStrings();
        NSString *plist = [self.specifier propertyForKey:@"plist"];
        _specifiers = [self loadSpecifiersFromPlistName:plist target:self];
        OMCLocalizeSpecifiers(_specifiers);
        OMCLogWriteSync(@"Prefs", [NSString stringWithFormat:
            @"[W1] OMCFeatureListController specifiers after load plist=%@ count=%lu",
            plist, (unsigned long)_specifiers.count]);
    }
    OMCLogWriteSync(@"Prefs", [NSString stringWithFormat:
        @"[W1] OMCFeatureListController specifiers exit plist=%@ count=%lu",
        w1Plist, (unsigned long)_specifiers.count]);
    return _specifiers;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // [VERIFIED: appearance proxy scoped to the concrete subclass]
    [[UISwitch appearanceWhenContainedInInstancesOfClasses:@[[self class]]]
        setOnTintColor:OMCSwitchColor()];
    [[UISlider appearanceWhenContainedInInstancesOfClasses:@[[self class]]]
        setMinimumTrackTintColor:OMCAccentColor()];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    CFPreferencesAppSynchronize(OMC_PREFS_DOMAIN);
    // Order restored to the original (W1 audit row 7; Feature
    // 0x10f84-0x1107c): reloadSpecifiers FIRST (0x10fc8), then the
    // title, then OMCStyleTable (0x11060). Ours previously ran
    // StyleTable -> title -> reloadSpecifiers LAST.
    [self reloadSpecifiers];
    if (self.specifier.name.length) self.title = self.specifier.name;
    OMCStyleTable(self.table);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = nil;
    @try {
        cell = [super tableView:tableView cellForRowAtIndexPath:indexPath];
        OMCStyleCell(cell);
    } @catch (NSException *exception) {
        // [W1] Log-then-rethrow, exactly the GPT-F pattern in
        // OMCRootListController.m (this is the layer where the 18:12
        // exception surfaced in PSListController): log coordinates +
        // specifier identifier + exception, then @throw; — the
        // exception is NEVER swallowed.
        NSString *specifierID = nil;
        @try {
            PSSpecifier *spec = [self specifierAtIndexPath:indexPath];
            specifierID = [spec identifier] ?: [spec propertyForKey:@"plist"];
        } @catch (NSException *lookupException) {
            (void)lookupException;
            specifierID = nil;
        }
        OMCLogWriteSync(@"Prefs", [NSString stringWithFormat:
            @"[W1] cellForRow exception: controller=%@ section=%ld row=%ld specifier=%@ name=%@ reason=%@ stack=%@",
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

- (void)traitCollectionDidChange:(UITraitCollection *)previous {
    [super traitCollectionDidChange:previous];
    if (self.traitCollection.userInterfaceStyle != previous.userInterfaceStyle) {
        OMCStyleTable(self.table);
    }
}

- (void)showMessage:(NSString *)message {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"OmniCar"
                                                                   message:message
                                                            preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil]];
    [self presentViewController:alert animated:YES completion:nil];
}

@end
