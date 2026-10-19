// OmniCar CarPlay native chrome owner — adapted from DuoFace's proven
// DFDashboardChrome design, not from its CBWindow geometry implementation.
// Never touch generic app windows. Restore exact prior hidden flags.
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <objc/runtime.h>

static NSString *const OMCChromeNotification=@"com.anlai.omnicar.zoom.chrome.v1";
@interface DBStatusBarWindow : UIWindow @end
@interface CARStatusBarWindow : UIWindow @end
@interface OMCDistributedCenter : NSObject
+ (instancetype)defaultCenter;
- (void)postNotificationName:(NSString *)name object:(id)object userInfo:(NSDictionary *)info;
- (void)addObserver:(id)observer selector:(SEL)selector name:(NSString *)name object:(id)object;
@end
static NSHashTable<UIWindow *> *OMCChromeObserved;
static NSMapTable<UIWindow *,NSNumber *> *OMCChromeOriginal;
static BOOL OMCChromeHidden;
static BOOL OMCChromeInitialized;

static void OMCRecordWindow(UIWindow *window) {
    if (!window) return;
    if (!OMCChromeObserved) OMCChromeObserved=[NSHashTable weakObjectsHashTable];
    if (!OMCChromeOriginal) OMCChromeOriginal=[NSMapTable weakToStrongObjectsMapTable];
    [OMCChromeObserved addObject:window];
    if (OMCChromeHidden) {
        if (![OMCChromeOriginal objectForKey:window])
            [OMCChromeOriginal setObject:@(window.hidden) forKey:window];
        window.hidden=YES;
    }
}
static void OMCApplyChromeVisibility(BOOL hidden) {
    if (!OMCChromeObserved) OMCChromeObserved=[NSHashTable weakObjectsHashTable];
    if (!OMCChromeOriginal) OMCChromeOriginal=[NSMapTable weakToStrongObjectsMapTable];
    if (hidden) {
        NSUInteger count=OMCChromeObserved.allObjects.count;
        if (!count) {
            NSLog(@"[OmniCarZoomChrome] FAILED: no native CarPlay statusbar window observed");
            return;
        }
        OMCChromeHidden=YES;
        for (UIWindow *window in OMCChromeObserved.allObjects) OMCRecordWindow(window);
        NSLog(@"[OmniCarZoomChrome] event=hide windows=%lu",(unsigned long)count);
    } else {
        OMCChromeHidden=NO;
        for (UIWindow *window in OMCChromeOriginal.keyEnumerator) {
            NSNumber *original=[OMCChromeOriginal objectForKey:window];
            if (original) window.hidden=original.boolValue;
        }
        [OMCChromeOriginal removeAllObjects];
        NSLog(@"[OmniCarZoomChrome] event=restore");
    }
}
@interface OMCChromeReceiver:NSObject
- (void)received:(NSNotification *)notification;
@end
@implementation OMCChromeReceiver
- (void)received:(NSNotification *)notification {
    NSDictionary *info=notification.userInfo;
    if (![info isKindOfClass:NSDictionary.class] ||
        ![info[@"version"] isEqual:@1] ||
        ![info[@"hidden"] isKindOfClass:NSNumber.class]) return;
    dispatch_async(dispatch_get_main_queue(),^{
        OMCApplyChromeVisibility([info[@"hidden"] boolValue]);
    });
}
@end
static OMCChromeReceiver *OMCReceiver;
void OMCChromeSetHidden(BOOL hidden) {
    NSCAssert(NSThread.isMainThread,@"Chrome changes must run on main thread");
    // Local direct path works when SCPCarSplit runs inside CarPlayApp.
    if (OMCChromeObserved.allObjects.count) OMCApplyChromeVisibility(hidden);
    Class cls=NSClassFromString(@"NSDistributedNotificationCenter");
    id center=[cls respondsToSelector:@selector(defaultCenter)]?[cls defaultCenter]:nil;
    if ([center respondsToSelector:@selector(postNotificationName:object:userInfo:)]) {
        [center postNotificationName:OMCChromeNotification object:nil
                           userInfo:@{@"version":@1,@"hidden":@(hidden)}];
        NSLog(@"[OmniCarZoomChrome] event=sent hidden=%d",hidden);
    } else {
        NSLog(@"[OmniCarZoomChrome] FAILED: distributed notification center unavailable");
    }
}
%group OMCChromeDB
%hook DBStatusBarWindow
- (void)layoutSubviews {
    %orig;
    OMCRecordWindow((UIWindow *)self);
}
%end
%end
%group OMCChromeCAR
%hook CARStatusBarWindow
- (void)layoutSubviews {
    %orig;
    OMCRecordWindow((UIWindow *)self);
}
%end
%end
static void OMCTryInstallChrome(NSUInteger attempt) {
    if (OMCChromeInitialized) return;
    if (NSClassFromString(@"DBStatusBarWindow")) {
        %init(OMCChromeDB);
        OMCChromeInitialized=YES;
    } else if (NSClassFromString(@"CARStatusBarWindow")) {
        %init(OMCChromeCAR);
        OMCChromeInitialized=YES;
    } else if (attempt<40) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW,500*NSEC_PER_MSEC),
                       dispatch_get_main_queue(),^{ OMCTryInstallChrome(attempt+1); });
        return;
    } else {
        NSLog(@"[OmniCarZoomChrome] FAILED: native statusbar class unavailable");
        return;
    }
    NSLog(@"[OmniCarZoomChrome] event=chrome-hook-installed class=%@",
          NSClassFromString(@"DBStatusBarWindow")?@"DBStatusBarWindow":@"CARStatusBarWindow");
}
__attribute__((constructor)) static void OMCChromeEntry(void) {
    @autoreleasepool {
        NSString *bundle=NSBundle.mainBundle.bundleIdentifier.lowercaseString ?: @"";
        if (![@[@"com.apple.carplayapp",@"com.apple.carplay",@"com.apple.dashboard"]
              containsObject:bundle]) return;
        dispatch_async(dispatch_get_main_queue(),^{
            Class cls=NSClassFromString(@"NSDistributedNotificationCenter");
            id center=[cls respondsToSelector:@selector(defaultCenter)]?[cls defaultCenter]:nil;
            if ([center respondsToSelector:@selector(addObserver:selector:name:object:)]) {
                OMCReceiver=[OMCChromeReceiver new];
                [center addObserver:OMCReceiver selector:@selector(received:)
                              name:OMCChromeNotification object:nil];
            }
            OMCTryInstallChrome(0);
        });
    }
}
