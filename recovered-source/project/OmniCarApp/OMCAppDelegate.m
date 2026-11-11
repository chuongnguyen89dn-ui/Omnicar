// OMCAppDelegate.m — reconstructed from OmniCar.app (arm64 slice) disassembly.
// Method IMPs: didFinishLaunching 0x100004000, openSettings 0x1000043F4,
// application:openURL:options: 0x100004468. ARC (objc_retain /
// objc_retainAutoreleasedReturnValue / objc_storeStrong in .cxx_destruct).
// There is no storyboard/nib and no scene delegate: the whole UI is built
// programmatically below, exactly as the binary does it.
#import "OMCAppDelegate.h"
#import <Preferences/PSListController.h>
#import <Preferences/PSRootController.h>
#import <Preferences/PSSpecifier.h>


// [hl20-settings] DuoFace uses an app-owned settings controller.
// OmniCar reuses its real restored PSListController pages but no longer
// instantiates PSRootController (a host owned by Apple's Settings app).
// Adapt only the Preferences push selector onto a UIKit navigation stack.
@interface OMCInAppSettingsNavigationController : UINavigationController
- (void)pushController:(UIViewController *)controller;
- (void)pushController:(UIViewController *)controller animate:(BOOL)animated;
- (UIViewController *)popController;
@end

@implementation OMCInAppSettingsNavigationController
- (void)pushController:(UIViewController *)controller {
    if (controller && controller != self.topViewController)
        [self pushViewController:controller animated:YES];
}
- (void)pushController:(UIViewController *)controller animate:(BOOL)animated {
    if (controller && controller != self.topViewController)
        [self pushViewController:controller animated:animated];
}
- (UIViewController *)popController {
    return [self popViewControllerAnimated:YES];
}
@end

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
    // [hl20-settings] The actual plist resources/controller implementations
    // are statically linked into OmniCar.app; no dylib loading, no
    // Settings.app deep link and no independent preference state.
    NSBundle *bundle = [NSBundle mainBundle];
    NSArray<NSString *> *required = @[@"Root", @"FeatureSplitScreen",
                                      @"FeatureSpeedBubble", @"FeatureStartupScreen"];
    NSMutableArray<NSString *> *missing = [NSMutableArray array];
    for (NSString *name in required)
        if (![bundle pathForResource:name ofType:@"plist"])
            [missing addObject:name];
    if (missing.count) {
        NSLog(@"[hl20-settings] gate=resources-missing names=%@ bundle=%@",
              [missing componentsJoinedByString:@","], bundle.bundlePath);
        return nil;
    }
    NSString *rootPath = [bundle pathForResource:@"Root" ofType:@"plist"];
    NSDictionary *rootPlist = [NSDictionary dictionaryWithContentsOfFile:rootPath];
    NSArray *items = [rootPlist isKindOfClass:NSDictionary.class]
        ? rootPlist[@"items"] : nil;
    if (![items isKindOfClass:NSArray.class] || items.count == 0) {
        NSLog(@"[hl20-settings] gate=root-items-invalid path=%@", rootPath);
        return nil;
    }
    @try {
        Class cls = NSClassFromString(@"OMCRootListController");
        if (!cls || ![cls isSubclassOfClass:PSListController.class]) {
            NSLog(@"[hl20-settings] gate=root-class-missing class=%@", cls);
            return nil;
        }
        PSListController *root = [[cls alloc] init];
        root.bundle = bundle;
        root.title = @"OmniCar";
        OMCInAppSettingsNavigationController *nav =
            [[OMCInAppSettingsNavigationController alloc]
                initWithRootViewController:root];
        // PSListController uses rootController for pushes; this UIKit
        // adapter implements the required pushController selectors.
        // Feature controllers and the original prefs domain remain intact.
        root.rootController = (id)nav;
        root.parentController = (id)nav;
        if (nav.topViewController != root) {
            NSLog(@"[hl20-settings] gate=root-not-installed");
            return nil;
        }
        NSLog(@"[hl20-settings] gate=app-navigation-ready root=%@ "
              "items=%lu controllers=%lu bundle=%@",
              NSStringFromClass(root.class), (unsigned long)items.count,
              (unsigned long)nav.viewControllers.count, bundle.bundlePath);
        return nav;
    } @catch (NSException *exception) {
        NSLog(@"[hl20-settings] gate=exception name=%@ reason=%@ stack=%@",
              exception.name, exception.reason, exception.callStackSymbols);
        return nil;
    }
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
