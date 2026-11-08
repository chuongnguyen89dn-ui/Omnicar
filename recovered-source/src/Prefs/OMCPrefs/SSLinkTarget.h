// SSLinkTarget.h — OmniCarPrefs (reconstructed, Prefs-B)
// Weak-owner CADisplayLink target so SSStartupView's link does not retain
// it. [VERIFIED: owner stored via objc_storeWeak]
#import <Foundation/Foundation.h>

@class SSStartupView;

@interface SSLinkTarget : NSObject
@property (nonatomic, weak) SSStartupView *owner;
- (void)step:(id)link;
@end
