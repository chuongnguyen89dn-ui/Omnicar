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
    // [hl16-settings] OmniCar iPhone app owns the actual preference controllers.
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [self openSettings];
    [self.window makeKeyAndVisible];
    return YES;
}

// [hl16-settings] The preference UI is linked into OmniCar.app, including
// OMCRootListController and every feature page. Do not load a dylib from
// /var/jb/Library/PreferenceBundles: sandbox/loader failure on HL15 device.
- (UIViewController *)omcEmbeddedSettingsController {
    Class cls = NSClassFromString(@"OMCRootListController");
    NSBundle *bundle = [NSBundle mainBundle];
    if (!cls || ![cls isSubclassOfClass:PSListController.class]) {
        NSLog(@"[hl16-settings] gate=root-class-failed class=%@ bundle=%@",
              cls, bundle.bundlePath);
        return nil;
    }
    @try {
        PSListController *page = [[cls alloc] init];
        page.bundle = bundle;
        PSRootController *nav =
            [[PSRootController alloc] initWithTitle:@"OmniCar"
                                        identifier:@"com.anlai.omnicar"];
        if (!page || !nav) {
            NSLog(@"[hl16-settings] gate=nav-init-failed");
            return nil;
        }
        [nav pushController:page];
        NSLog(@"[hl16-settings] gate=embedded-root pages=%lu bundle=%@ root=%@",
              (unsigned long)nav.viewControllers.count,
              bundle.bundlePath,
              [bundle pathForResource:@"Root" ofType:@"plist"] ?: @"missing");
        return nav;
    } @catch (NSException *exception) {
        NSLog(@"[hl16-settings] gate=exception reason=%@",
              exception.reason);
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
    NSLog(@"[hl16-settings] embedded controllers/resources unavailable");
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
