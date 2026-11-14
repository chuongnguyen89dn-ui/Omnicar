// HL58: standalone Lề 0.2.4 OPTIONAL companion, NOT bundled in DuoCar.
// This is a DuoCar-only compatibility shim with EXACTLY two functions:
// (1) correct moving GPS speedText by DuoCar offset [-10,+10],
// (2) mask/unmask the original Lề bubble on DuoCar master ON/OFF.
// Never touch vendor pan, snap, layout, scene, windowLevel, source or limit.
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CoreFoundation/CoreFoundation.h>
#import <objc/runtime.h>
#import <objc/message.h>
#import <notify.h>
#import <math.h>
#include <string.h> // method encoding CGRect ABI check
#import "DCLLeConfigBridge.h"

static NSString *const DCLDomain=@"com.chuong.duocar";
static id (*DCLOriginalContent)(id,SEL,id)=NULL;
static void (*DCLOriginalOverlayPlace)(id,SEL)=NULL;
static void (*DCLOriginalCastPlace)(id,SEL,CGRect)=NULL;
static BOOL DCLContentInstalled=NO,DCLOverlayInstalled=NO,DCLCastInstalled=NO;
static __weak id DCLOverlayOwner=nil,DCLCastOwner=nil;
static char DCLHiddenKey,DCLInteractiveKey,DCLMaskKey;
static int DCLLastOffsetLogged=999;

static id DCLPref(NSString *name) {
    CFStringRef domain=(__bridge CFStringRef)DCLDomain;
    CFPreferencesAppSynchronize(domain);
    return CFBridgingRelease(CFPreferencesCopyAppValue(
        (__bridge CFStringRef)name,domain));
}
static int DCLGPSOffset(void) {
    id number=DCLPref(@"leTrafficGpsOffsetKph");
    NSInteger n=[number respondsToSelector:@selector(integerValue)]
        ?[number integerValue]:0;
    return (int)MAX(-10,MIN(10,n));
}
static BOOL DCLMasterEnabled(void) {
    id value=DCLPref(@"leBubbleMasterEnabled");
    // DuoCar is an optional visibility gate, not Lề's own enable switch.
    // Default YES means unmodified native Lề behavior if no DuoCar choice.
    return value?[value boolValue]:YES;
}
static void DCLMaskView(UIView *view,BOOL enabled) {
    if(!view)return;
    NSNumber *masked=objc_getAssociatedObject(view,&DCLMaskKey);
    if(!enabled) {
        if(!masked.boolValue) {
            objc_setAssociatedObject(view,&DCLHiddenKey,@(view.hidden),
                                     OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            objc_setAssociatedObject(view,&DCLInteractiveKey,
                                     @(view.userInteractionEnabled),
                                     OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            objc_setAssociatedObject(view,&DCLMaskKey,@YES,
                                     OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        }
        view.userInteractionEnabled=NO;
        view.hidden=YES;
    } else if(masked.boolValue) {
        NSNumber *oldHidden=objc_getAssociatedObject(view,&DCLHiddenKey);
        NSNumber *oldInteractive=objc_getAssociatedObject(view,&DCLInteractiveKey);
        if(oldHidden)view.hidden=oldHidden.boolValue;
        if(oldInteractive)view.userInteractionEnabled=oldInteractive.boolValue;
        objc_setAssociatedObject(view,&DCLMaskKey,nil,OBJC_ASSOCIATION_ASSIGN);
        objc_setAssociatedObject(view,&DCLHiddenKey,nil,OBJC_ASSOCIATION_ASSIGN);
        objc_setAssociatedObject(view,&DCLInteractiveKey,nil,OBJC_ASSOCIATION_ASSIGN);
    }
}
static UIView *DCLVendorBubble(id owner) {
    SEL selector=@selector(bubble);
    if(!owner || ![owner respondsToSelector:selector])return nil;
    id view=((id(*)(id,SEL))objc_msgSend)(owner,selector);
    return [view isKindOfClass:UIView.class]?(UIView *)view:nil;
}
static void DCLApplyVisibility(id owner) {
    UIView *bubble=DCLVendorBubble(owner);
    if(!bubble)return; // class not loaded or vendor not installed
    BOOL enabled=DCLMasterEnabled();
    DCLMaskView(bubble,enabled);
    // Only Lề's OWN compact CWTrafficWindow may be hidden.
    // Never hide UIWindow/scene of a hosted/native CarPlay application.
    UIWindow *window=bubble.window;
    if([NSStringFromClass(window.class) isEqualToString:@"CWTrafficWindow"])
        DCLMaskView(window,enabled);
    NSLog(@"[hl58-external-le] enabled=%d owner=%@ view=%@ vendorWindow=%@",
          enabled,NSStringFromClass([owner class]),
          NSStringFromClass(bubble.class),NSStringFromClass(window.class));
}
static id DCLCorrectSpeed(id cls,SEL sel,id snapshot) {
    id content=DCLOriginalContent?DCLOriginalContent(cls,sel,snapshot):nil;
    if(!content || ![content respondsToSelector:@selector(speedText)] ||
       ![content respondsToSelector:@selector(setSpeedText:)])return content;
    int offset=DCLGPSOffset();
    if(offset==0)return content;
    id raw=((id(*)(id,SEL))objc_msgSend)(content,@selector(speedText));
    if(![raw isKindOfClass:NSString.class])return content;
    // The separately installed UNPATCHED LeBubble.dylib may render either
    // "63" or "63 km/h". DC57 had stripped vendor km/h, so its former hook
    // could not handle the original independent package!
    NSString *string=(NSString *)raw;
    NSScanner *scanner=[NSScanner scannerWithString:string];
    scanner.charactersToBeSkipped=nil; // do not rewrite arbitrary text
    NSInteger n=0;
    if(![scanner scanInteger:&n] || n<0 || n>400)return content;
    NSString *tail=[string substringFromIndex:scanner.scanLocation];
    NSString *trim=[tail stringByTrimmingCharactersInSet:
                        NSCharacterSet.whitespaceAndNewlineCharacterSet];
    if(trim.length && ![[trim lowercaseString] isEqualToString:@"km/h"])
        return content; // no speed-limit text, no invented provider payload
    NSInteger corrected=MAX(0,MIN(400,n+offset));
    NSString *next=[NSString stringWithFormat:@"%ld%@",(long)corrected,tail];
    ((void(*)(id,SEL,id))objc_msgSend)(content,@selector(setSpeedText:),next);
    if(offset!=DCLLastOffsetLogged) {
        DCLLastOffsetLogged=offset;
        NSLog(@"[hl58-external-le] GPS offset=%d (moving speed only) original=%@ corrected=%@",
              offset,string,next);
    }
    return content;
}
static void DCLOverlayPlace(id owner,SEL sel) {
    if(DCLOriginalOverlayPlace)DCLOriginalOverlayPlace(owner,sel);
    DCLOverlayOwner=owner;
    DCLApplyVisibility(owner);
}
static void DCLCastPlace(id owner,SEL sel,CGRect rect) {
    if(DCLOriginalCastPlace)DCLOriginalCastPlace(owner,sel,rect);
    DCLCastOwner=owner;
    DCLApplyVisibility(owner);
}
static BOOL DCLInstall(Class cls,SEL selector,IMP replacement,IMP *original,
                       BOOL instance,unsigned args) {
    if(!cls||!original||*original)return *original!=NULL;
    Method method=instance?class_getInstanceMethod(cls,selector):
                           class_getClassMethod(cls,selector);
    if(!method || method_getNumberOfArguments(method)!=args)return NO;
    char result[16]={0};
    method_getReturnType(method,result,sizeof(result));
    if(result[0]!=(instance?'v':'@'))return NO;
    // -place: is genuinely (CGRect), not an Objective-C object argument.
    if(instance && selector==@selector(place:)) {
        const char *type=method_getTypeEncoding(method);
        if(!type||!strstr(type,"{CGRect="))return NO;
    }
    Class target=instance?cls:object_getClass(cls);
    IMP prev=method_getImplementation(method);
    if(!prev||prev==replacement)return NO;
    if(class_addMethod(target,selector,replacement,method_getTypeEncoding(method))) {
        *original=prev;return YES;
    }
    IMP replaced=method_setImplementation(method,replacement);
    if(replaced!=prev) {
        if(replaced)method_setImplementation(method,replaced);
        return NO;
    }
    *original=prev;
    return YES;
}
static void DCLInstallExternalLeHooks(void) {
    if(!DCLContentInstalled)
        DCLContentInstalled=DCLInstall(NSClassFromString(@"CWTrafficBubbleContent"),
            @selector(contentWithSnapshot:),(IMP)DCLCorrectSpeed,
            (IMP *)&DCLOriginalContent,NO,3);
    if(!DCLOverlayInstalled)
        DCLOverlayInstalled=DCLInstall(NSClassFromString(@"CWTrafficOverlayController"),
            @selector(place),(IMP)DCLOverlayPlace,
            (IMP *)&DCLOriginalOverlayPlace,YES,2);
    if(!DCLCastInstalled)
        DCLCastInstalled=DCLInstall(NSClassFromString(@"CWCastBubbleController"),
            @selector(place:),(IMP)DCLCastPlace,
            (IMP *)&DCLOriginalCastPlace,YES,3);
}
__attribute__((constructor)) static void DCLLeBootstrap(void) {
    NSString *bundle=NSBundle.mainBundle.bundleIdentifier;
    BOOL springboard=[bundle isEqualToString:@"com.apple.springboard"];
    BOOL car=[bundle isEqualToString:@"com.apple.CarPlayApp"];
    if(!springboard&&!car)return;
    dispatch_async(dispatch_get_main_queue(),^{
        if(springboard)DCLLeConfigStartBridge();
        // The original vendor package has its OWN injection filters and
        // classes. They may load after this OPTIONAL DuoCar extension.
        // Never dlopen / substitute vendor Mach-O or create a renderer.
        DCLInstallExternalLeHooks();
        static int changes=-1;
        notify_register_dispatch("com.chuong.duocar/le024.visibility",&changes,
             dispatch_get_main_queue(),^(int token) {
            (void)token;
            DCLApplyVisibility(DCLOverlayOwner);
            DCLApplyVisibility(DCLCastOwner);
        });
        static NSUInteger tries=0;
        NSTimer *timer=[NSTimer timerWithTimeInterval:1.0 repeats:YES
               block:^(NSTimer *t) {
            DCLInstallExternalLeHooks();
            if((DCLContentInstalled&&
               (DCLOverlayInstalled||DCLCastInstalled))||++tries>=180) {
                if(!DCLContentInstalled)
                    NSLog(@"[hl58-external-le] vendor class not loaded/installed: GPS inactive");
                [t invalidate];
            }
        }];
        [[NSRunLoop mainRunLoop]addTimer:timer forMode:NSRunLoopCommonModes];
        [[NSNotificationCenter defaultCenter]addObserverForName:NSBundleDidLoadNotification
          object:nil queue:NSOperationQueue.mainQueue usingBlock:^(NSNotification *n){
            (void)n;DCLInstallExternalLeHooks();
        }];
    });
}
