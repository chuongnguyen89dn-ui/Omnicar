// HL26 -- iPhone configuration is a native UIKit app, not a Settings.app preference page.
// Preserve OmniCar shortcut deep-link handling in application:openURL:options: below.
#import "OMCAppDelegate.h"
#import "OMCNativeSettings.h"

@implementation OMCAppDelegate
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)options {
    self.window=[[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [self openSettings];
    [self.window makeKeyAndVisible];
    NSLog(@"[hl26-settings] gate=app-root-launched root=%@",
          NSStringFromClass([self.window.rootViewController class]));
    return YES;
}
- (void)openSettings {
    // Do not call prefs:root, PSRootController, PSListController or Settings.app.
    self.window.rootViewController=OMCNativeSettingsRootController();
}

// URL entry point (scheme "omnicar", declared in Info.plist CFBundleURLTypes).
// The app does NOT parse routes itself: any omnicar:// URL is forwarded
// verbatim (absoluteString) to the tweaks through
// NSDistributedNotificationCenter, notification "com.anlai.omnicar/url",
// userInfo @{ @"url": <absoluteString> }. Route handling (splitscreen/…)
// lives in the tweak processes that observe this notification.
// 0.3 s after ANY openURL call (handled or not) the app suspends itself
// via the private -[UIApplication suspend] so a Shortcut lands back where
// it started.
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey, id> *)options
{
    BOOL handled = NO;
    if ([[url scheme] isEqualToString:@"omnicar"]) {
        // Resolved dynamically: the app links no notification API itself.
        // The binary sends defaultCenter as a direct objc_msgSend to the
        // class object returned by NSClassFromString.
        Class centerClass = NSClassFromString(@"NSDistributedNotificationCenter");
        if (centerClass) {
            id center = [(id)centerClass defaultCenter];
            handled = YES;
            NSDictionary *userInfo = @{ @"url": [url absoluteString] };
            [center postNotificationName:@"com.anlai.omnicar/url" object:nil userInfo:userInfo];
        }
    }
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 300 * NSEC_PER_MSEC),
                   dispatch_get_main_queue(), ^{
        [[UIApplication sharedApplication] performSelector:@selector(suspend)];
    });
    return handled;
}

@end
