// OMCAppDelegate.m — reconstructed from OmniCar.app (arm64 slice) disassembly.
// Method IMPs: didFinishLaunching 0x100004000, openSettings 0x1000043F4,
// application:openURL:options: 0x100004468. ARC (objc_retain /
// objc_retainAutoreleasedReturnValue / objc_storeStrong in .cxx_destruct).
// There is no storyboard/nib and no scene delegate: the whole UI is built
// programmatically below, exactly as the binary does it.
#import "OMCAppDelegate.h"

@implementation OMCAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];

    UIViewController *rootViewController = [UIViewController new];
    rootViewController.view.backgroundColor = [UIColor colorWithRed:0.05 green:0.07 blue:0.15 alpha:1.0];

    // Binary: [[[NSLocale preferredLanguages] firstObject] hasPrefix:@"vi"]
    BOOL vietnamese = [[[NSLocale preferredLanguages] firstObject] hasPrefix:@"vi"];

    UILabel *label = [[UILabel alloc] initWithFrame:CGRectInset(rootViewController.view.bounds, 24.0, 0.0)];
    label.numberOfLines = 0;
    label.textColor = [UIColor whiteColor];
    label.font = [UIFont systemFontOfSize:15.0];
    label.textAlignment = NSTextAlignmentCenter; // 1
    label.text = [NSString stringWithFormat:@"OmniCar\n\n%@\n\n%@\n\nomnicar://splitscreen/open?left=com.apple.Maps&right=com.spotify.client\n\nomnicar://splitscreen/fav?n=1\n\nomnicar://splitscreen/close\n\n%@",
        vietnamese ? @"App này nhận lệnh từ Shortcuts / Siri." : @"This app receives commands from Shortcuts / Siri.",
        vietnamese ? @"Tạo Shortcut với hành động \"Mở URL\":" : @"Create a Shortcut with the \"Open URL\" action:",
        vietnamese ? @"Cài đặt chi tiết: Cài đặt > OmniCar" : @"Settings: Settings > OmniCar"];
    label.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight; // 0x12
    [rootViewController.view addSubview:label];

    UIButton *settingsButton = [UIButton buttonWithType:UIButtonTypeSystem]; // 1
    [settingsButton setTitle:(vietnamese ? @"Mở Cài đặt OmniCar" : @"Open OmniCar Settings")
                    forState:UIControlStateNormal];
    settingsButton.frame = CGRectMake(0.0,
                                      rootViewController.view.bounds.size.height - 90.0,
                                      rootViewController.view.bounds.size.width,
                                      44.0);
    settingsButton.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin; // 0xA
    [settingsButton addTarget:self action:@selector(openSettings) forControlEvents:UIControlEventTouchUpInside]; // 0x40
    [rootViewController.view addSubview:settingsButton];

    self.window.rootViewController = rootViewController;
    [self.window makeKeyAndVisible];
    return YES;
}

// Button action: deep-link into the OmniCar page of the Settings app.
// Binary: openURL:[NSURL URLWithString:@"prefs:root=OmniCar"] options:@{}
// (the ___NSDictionary0__ shared empty dictionary) completionHandler:nil.
- (void)openSettings
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"prefs:root=OmniCar"]
                                       options:@{}
                             completionHandler:nil];
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
