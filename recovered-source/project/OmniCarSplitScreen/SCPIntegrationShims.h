// SCPIntegrationShims.h — [integration phase 1] declarations for classes
// the iOS SDK's public headers do not export but the reconstructed
// sources use directly. Force-included into every TU of this subproject
// via -include in the Makefile. Contains no reconstructed logic.
#import <Foundation/Foundation.h>
#import <objc/message.h> // [integration phase 1] several TUs call objc_msgSend with only <objc/runtime.h> imported

// NSDistributedNotificationCenter exists in iOS's Foundation at runtime
// but is not declared in the iOS SDK headers (used in SCPHooks.m).
// Only NSNotificationCenter-inherited methods are sent to it.
@interface NSDistributedNotificationCenter : NSNotificationCenter
+ (instancetype)defaultCenter;
@end

// [integration phase 1] module A's shared guarded-send helper, defined in
// SCPShared.m and called from SCPSpringBoardHooks.m; SCPShared.h does not
// declare it.
id SCPGuardedSend(id obj, NSString *selName);

// [phase2] A's dispatch-after helper (SCPShared.h:92, defined in
// SCPShared.m); B's category TUs call it without importing SCPShared.h
// (whose OMC decls conflict with SCPCommon.h spellings).
void SCPDispatchAfter(double delaySeconds, void (^block)(void));

// [integration phase 1] -updatePlayback is SplitScreen-B's
// SCPHomeWallView method; module C sends it to an id (SCPHomeSettings.m)
// but no header in the A/C set declares the selector. Declared here on a
// category so the send compiles; B's real interface arrives in phase 2.
@interface NSObject (SCPBWallViewSelectors)
- (void)updatePlayback;
@end
