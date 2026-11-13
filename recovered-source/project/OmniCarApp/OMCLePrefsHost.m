// DuoCar -> original Lề 0.2.4 UIKit preferences bridge.
// No fake mirror of Le source/alert/module settings: load their actual page.
// The LePrefs bundle remains unmodified, using dev.bechou.le.* settings.
#import "OMCLePrefsHost.h"
#import <UIKit/UIKit.h>
#import <dlfcn.h>
#import <objc/runtime.h>

static NSBundle *OMCFindLePrefsBundle(void) {
    static NSBundle *cached;
    if (cached) return cached;
    NSArray<NSString *> *locations=@[
        @"/var/jb/Library/PreferenceBundles/LePrefs.bundle",
        @"/Library/PreferenceBundles/LePrefs.bundle"
    ];
    for (NSString *dir in locations) {
        NSBundle *bundle=[NSBundle bundleWithPath:dir];
        if (bundle && [bundle executablePath].length) {
            cached=bundle;
            return bundle;
        }
    }
    return nil;
}
static Class OMCLePrefsRootClass(void) {
    NSBundle *bundle=OMCFindLePrefsBundle();
    if (!bundle) return Nil;
    // A PreferenceBundle can link Apple's Preferences framework, which is
    // not necessarily present in our standalone UIKit configuration app.
    dlopen("/System/Library/PrivateFrameworks/Preferences.framework/Preferences",
           RTLD_NOW|RTLD_GLOBAL);
    @try {
        if (![bundle isLoaded] && ![bundle load]) return Nil;
    } @catch (NSException *exception) {
        NSLog(@"[le024-prefs] load exception=%@",exception.name);
        return Nil;
    }
    Class klass=[bundle principalClass];
    if (!klass) klass=NSClassFromString(@"CWTrafficBubblePrefsController");
    if (!klass || ![klass isSubclassOfClass:UIViewController.class]) {
        NSLog(@"[le024-prefs] unsupported root=%@",klass?NSStringFromClass(klass):@"missing");
        return Nil;
    }
    return klass;
}
BOOL OMCLeOriginalPreferencesAvailable(void) {
    return OMCFindLePrefsBundle()!=nil;
}
UIViewController *OMCLeOriginalPreferencesController(void) {
    Class klass=OMCLePrefsRootClass();
    if (klass) {
        @try {
            UIViewController *root=[[klass alloc] init];
            if ([root isKindOfClass:UIViewController.class]) {
                root.title=@"Lề 0.2.4";
                NSLog(@"[le024-prefs] using vendor preference controller=%@",
                      NSStringFromClass(klass));
                return root;
            }
        } @catch (NSException *exception) {
            NSLog(@"[le024-prefs] instantiate exception=%@",exception.name);
        }
    }
    UIViewController *fallback=[UIViewController new];
    fallback.title=@"Lề 0.2.4";
    fallback.view.backgroundColor=UIColor.systemBackgroundColor;
    UILabel *label=[UILabel new];
    label.translatesAutoresizingMaskIntoConstraints=NO;
    label.numberOfLines=0;
    label.textAlignment=NSTextAlignmentCenter;
    label.textColor=UIColor.secondaryLabelColor;
    label.text=@"Không nạp được giao diện Lề gốc.\nKiểm tra LePrefs.bundle và thư viện phụ thuộc.\nCài đặt Lề chưa được thay đổi.";
    [fallback.view addSubview:label];
    [NSLayoutConstraint activateConstraints:@[
        [label.leadingAnchor constraintEqualToAnchor:fallback.view.leadingAnchor constant:25],
        [label.trailingAnchor constraintEqualToAnchor:fallback.view.trailingAnchor constant:-25],
        [label.centerYAnchor constraintEqualToAnchor:fallback.view.centerYAnchor]
    ]];
    NSLog(@"[le024-prefs] unavailable; no fallback fake controls");
    return fallback;
}
