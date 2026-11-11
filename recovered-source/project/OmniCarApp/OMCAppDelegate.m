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
#import <objc/message.h>


 // [hl19-settings] Preferences.framework expects a concrete root owner
 // and a parent/root relationship before pushing child PSListControllers.
 // The old code directly instantiated its abstract PSRootController and
 // never performed this step. Keep the existing Prefs pages and keys.
 @interface OMCEmbeddedPrefsRootController : PSRootController {
     BOOL _omcPreparingRoot;
 }
 - (BOOL)omcInstallRootForSize:(CGSize)size;
 @end

 @implementation OMCEmbeddedPrefsRootController
 - (void)setupRootListForSize:(CGSize)size {
     (void)[self omcInstallRootForSize:size];
 }
 - (BOOL)omcInstallRootForSize:(CGSize)size {
     if (self.viewControllers.count > 0) return YES;
     if (_omcPreparingRoot) return NO;
     _omcPreparingRoot = YES;
     BOOL installed = NO;
     @try {
         NSBundle *bundle = [NSBundle mainBundle];
         NSString *rootPath = [bundle pathForResource:@"Root" ofType:@"plist"];
         Class cls = NSClassFromString(@"OMCRootListController");
         if (!rootPath || !cls ||
             ![cls isSubclassOfClass:PSListController.class]) {
             NSLog(@"[hl19-settings] gate=resources-or-class-missing root=%@ class=%@",
                   rootPath ?: @"missing", cls);
         } else {
             PSListController *root = [[cls alloc] initForContentSize:size];
             root.bundle = bundle;
             root.title = @"OmniCar";
             PSSpecifier *specifier = [PSSpecifier new];
             specifier.target = root;
             root.rootController = (id)self;
             root.parentController = (id)self;
             if ([root respondsToSelector:@selector(viewWillBecomeVisible:)]) {
                 // The selector belongs to Preferences.framework and is
                 // intentionally called only when this runtime has it.
                 ((void (*)(id, SEL, id))objc_msgSend)(
                     root, @selector(viewWillBecomeVisible:), specifier);
             }
             [self pushController:root];
             installed = self.viewControllers.count > 0;
             NSLog(@"[hl19-settings] gate=root-wired installed=%d pages=%lu bundle=%@",
                   (int)installed, (unsigned long)self.viewControllers.count,
                   bundle.bundlePath);
         }
     } @catch (NSException *exception) {
         NSLog(@"[hl19-settings] gate=root-exception name=%@ reason=%@",
               exception.name, exception.reason);
     } @finally {
         _omcPreparingRoot = NO;
     }
     return installed;
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
    // [hl19-settings] Real feature pages live in OmniCar.app, not a
    // PreferenceLoader pane or a dylib outside the app sandbox.
    NSBundle *bundle = [NSBundle mainBundle];
    NSArray<NSString *> *required = @[@"Root", @"FeatureSplitScreen",
                                      @"FeatureSpeedBubble", @"FeatureStartupScreen"];
    NSMutableArray<NSString *> *missing = [NSMutableArray array];
    for (NSString *name in required)
        if (![bundle pathForResource:name ofType:@"plist"])
            [missing addObject:name];
    if (missing.count) {
        NSLog(@"[hl19-settings] gate=missing-resources %@ bundle=%@",
              [missing componentsJoinedByString:@","], bundle.bundlePath);
        return nil;
    }
    @try {
        OMCEmbeddedPrefsRootController *nav =
            [[OMCEmbeddedPrefsRootController alloc]
                initWithTitle:@"OmniCar" identifier:@"com.anlai.omnicar"];
        // Older Preferences runtimes may call setupRootListForSize:
        // lazily. Explicitly prime it once if no root has been wired.
        if (!nav.viewControllers.count)
            [nav omcInstallRootForSize:[UIScreen mainScreen].bounds.size];
        if (!nav.viewControllers.count) {
            NSLog(@"[hl19-settings] gate=empty-navigation");
            return nil;
        }
        NSLog(@"[hl19-settings] gate=embedded-preferences-ready pages=%lu",
              (unsigned long)nav.viewControllers.count);
        return nav;
    } @catch (NSException *exception) {
        NSLog(@"[hl19-settings] gate=exception name=%@ reason=%@",
              exception.name, exception.reason);
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
