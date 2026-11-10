// OMCAppDelegate.m — reconstructed from OmniCar.app (arm64 slice) disassembly.
// Method IMPs: didFinishLaunching 0x100004000, openSettings 0x1000043F4,
// application:openURL:options: 0x100004468. ARC (objc_retain /
// objc_retainAutoreleasedReturnValue / objc_storeStrong in .cxx_destruct).
// There is no storyboard/nib and no scene delegate: the whole UI is built
// programmatically below, exactly as the binary does it.
#import "OMCAppDelegate.h"
#import <Preferences/PSListController.h>
#import <Preferences/PSRootController.h>

@implementation OMCAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)options {
    // [hl15-settings] iPhone OmniCar icon opens the actual preference pages.
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [self openSettings];
    [self.window makeKeyAndVisible];
    return YES;
}

// Load the SAME installed preference bundle: all Root/Feature plists,
// page classes, localisations and existing com.anlai.omnicar keys survive.
- (UIViewController *)omcEmbeddedSettingsController {
    NSArray<NSString *> *paths = @[
        @"/var/jb/Library/PreferenceBundles/OmniCarPrefs.bundle",
        @"/Library/PreferenceBundles/OmniCarPrefs.bundle"
    ];
    for (NSString *path in paths) {
        NSBundle *bundle = [NSBundle bundleWithPath:path];
        if (!bundle || ![bundle load]) continue;
        Class cls = NSClassFromString(@"OMCRootListController");
        if (!cls || ![cls isSubclassOfClass:PSListController.class]) continue;
        @try {
            PSListController *page = [[cls alloc] init];
            page.bundle = bundle;
            PSRootController *nav =
                [[PSRootController alloc] initWithTitle:@"OmniCar"
                                            identifier:@"com.anlai.omnicar"];
            if (!page || !nav) continue;
            [nav pushController:page];
            if (nav.viewControllers.count == 0) continue;
            nav.navigationBar.prefersLargeTitles = NO;
            NSLog(@"[hl15-settings] loaded %@ pages=%lu", path,
                  (unsigned long)nav.viewControllers.count);
            return nav;
        } @catch (NSException *e) {
            NSLog(@"[hl15-settings] load exception=%@", e.reason);
        }
    }
    return nil;
}

- (UIViewController *)omcUnavailableController {
    BOOL vi = [[[NSLocale preferredLanguages] firstObject] hasPrefix:@"vi"];
    UIViewController *vc = [UIViewController new];
    vc.view.backgroundColor = [UIColor systemBackgroundColor];
    UILabel *message = [UILabel new];
    message.numberOfLines = 0;
    message.textAlignment = NSTextAlignmentCenter;
    message.textColor = [UIColor labelColor];
    message.font = [UIFont systemFontOfSize:16 weight:UIFontWeightMedium];
    message.text = vi
        ? @"Không tải được cài đặt OmniCar. Vui lòng cài lại DEB đầy đủ rồi thử lại."
        : @"OmniCar settings could not be loaded. Reinstall the full DEB and retry.";
    UIButton *retry = [UIButton buttonWithType:UIButtonTypeSystem];
    [retry setTitle:(vi ? @"Thử lại" : @"Retry") forState:UIControlStateNormal];
    [retry addTarget:self action:@selector(openSettings)
        forControlEvents:UIControlEventTouchUpInside];
    message.translatesAutoresizingMaskIntoConstraints = NO;
    retry.translatesAutoresizingMaskIntoConstraints = NO;
    [vc.view addSubview:message];
    [vc.view addSubview:retry];
    UILayoutGuide *safe = vc.view.safeAreaLayoutGuide;
    [NSLayoutConstraint activateConstraints:@[
        [message.leadingAnchor constraintEqualToAnchor:safe.leadingAnchor constant:24],
        [message.trailingAnchor constraintEqualToAnchor:safe.trailingAnchor constant:-24],
        [message.centerYAnchor constraintEqualToAnchor:safe.centerYAnchor constant:-35],
        [retry.topAnchor constraintEqualToAnchor:message.bottomAnchor constant:20],
        [retry.centerXAnchor constraintEqualToAnchor:safe.centerXAnchor]
    ]];
    NSLog(@"[hl15-settings] bundle missing or unavailable");
    return vc;
}

// Keep the user in OmniCar: never open prefs:root in Settings.app.
- (void)openSettings {
    UIViewController *page = [self omcEmbeddedSettingsController];
    self.window.rootViewController = page ?: [self omcUnavailableController];
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
