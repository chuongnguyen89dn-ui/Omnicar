// OMCRootListController.h — reconstructed interface (principal class of the
// preference bundle). Evidence: disasm/classes.json (superclass
// PSListController; properties headerCard/supportState) +
// disasm/OMCRootListController.asm (30 methods).
#import <Preferences/PSListController.h>

@class OMCHeaderCard;

@interface OMCRootListController : PSListController {
    OMCHeaderCard *_headerCard;
    NSString *_supportState;
}
@property (nonatomic, strong) OMCHeaderCard *headerCard;
@property (nonatomic, copy) NSString *supportState;

// Actions referenced by Root.plist buttons (rescueRestore is also static there)
- (void)rescueRestore;
- (void)sendLog;
- (void)showGuide;
- (void)showWhatsNew;
- (void)respring;
@end
