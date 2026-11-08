// OMCCells.h — the three custom PSTableCell subclasses of the bundle.
// Evidence: disasm/classes.json (all -> PSTableCell, no ivars) +
// disasm/<Class>.asm (2 methods each: init + refreshCellContentsWithSpecifier:).
#import <Preferences/PSTableCell.h>

/// Root feature rows (assigned in code by -[OMCRootListController
/// insertFeatureSpecifiers] via the "cellClass" specifier property).
/// Shows the feature's on/off state in the detail label.
@interface OMCFeatureStatusCell : PSTableCell
@end

/// Root "APPS" link row (assigned statically in Root.plist via cellClass).
/// Shows how many apps are selected for App Bridge.
@interface OMCAppBridgeAppsLinkCell : PSTableCell
@end

/// Link row that shows the localized name of the app stored in a pref key
/// (used for app-valued rows; the key comes from the specifier's "key"
/// property).
@interface OMCSplitScreenAppLinkCell : PSTableCell
@end
