// ABIntegrationShims.h — [integration phase 1] declarations for classes
// the iOS SDK's public headers do not export but the reconstructed
// sources use directly. Force-included into every TU of this subproject
// via -include in the Makefile. Contains no reconstructed logic.
#import <Foundation/Foundation.h>

// NSDistributedNotificationCenter exists in iOS's Foundation at runtime
// but is not declared in the iOS SDK headers. The reconstruction uses it
// as a concrete type (module A: ABChannels.m, ABHostLaunch.m). Only
// NSNotificationCenter-inherited methods are sent to it.
@interface NSDistributedNotificationCenter : NSNotificationCenter
+ (instancetype)defaultCenter;
@end

// [integration phase 1] ABHostGeometry.m calls these three module-B
// consumer functions from its registration blocks before their
// definitions later in the same file; no header declares them.
void ABAppOrientDispatch(int token);
void ABKeyboardDispatch(int token);
void ABCarPlayChanged(NSNotification *note);

// [integration phase 1] FBScene (FrontBoard) is a private class; the
// hook replacement ABHook_FBSceneUpdateSettings takes FBScene* and only
// sends it NSObject/KVC messages.
@interface FBScene : NSObject
@end
