// DuoCar HL29: first-party, offline-first *typed* voice command parser.
// This is a new implementation inspired by DuoNavi 1.0.4's modular design,
// NOT DuoNavi's proprietary binary or Objective-C implementation.
#import <Foundation/Foundation.h>
NS_ASSUME_NONNULL_BEGIN
/// Returns one validated command in the existing splitscreen.native schema,
/// or nil. No raw transcript or unapproved bundle identifier crosses IPC.
FOUNDATION_EXPORT NSDictionary<NSString *, id> * _Nullable
DCVoiceParseCommand(NSString *transcript, NSSet<NSString *> *approvedBundles);
NS_ASSUME_NONNULL_END
