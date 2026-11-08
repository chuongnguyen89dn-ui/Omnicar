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
    if (!_specifiers) {
        OMCLoadStrings();
        NSString *plist = [self.specifier propertyForKey:@"plist"];
        _specifiers = [self loadSpecifiersFromPlistName:plist target:self];
        OMCLocalizeSpecifiers(_specifiers);
    }
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
    OMCStyleTable(self.table);
    if (self.specifier.name.length) self.title = self.specifier.name;
    [self reloadSpecifiers];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [super tableView:tableView cellForRowAtIndexPath:indexPath];
    OMCStyleCell(cell);
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
