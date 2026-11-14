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

static void (*DCLOriginalCastShowAt)(id,SEL,CGRect,double)=NULL;
static void (*DCLOriginalLauncherRaise)(id,SEL)=NULL;
static void (*DCLOriginalHostFront)(id,SEL,BOOL,id)=NULL;
static BOOL DCLCastShowInstalled=NO,DCLLauncherHookInstalled=NO,DCLHostFrontInstalled=NO;


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

// HL59: Lề owns its window/position/gestures. This shim only ensures that
// the already-visible original bubble is above DuoCar's visible chrome.
// Only compare windows in the SAME process and SAME UIScreen. Do not
// elevate against keyboards, alerts, or unrelated applications.
static id DCLShared(NSString *name) {
    Class cls=NSClassFromString(name);
    if(!cls || ![cls respondsToSelector:@selector(shared)])return nil;
    return ((id(*)(id,SEL))objc_msgSend)(cls,@selector(shared));
}
static UIWindow *DCLPeerWindow(UIWindow *vendor,BOOL car) {
    if(!vendor || !vendor.screen)return nil;
    UIWindow *peer=nil;
    if(car) {
        id split=DCLShared(@"SCPCarSplit");
        if(split && [split respondsToSelector:@selector(tabParent)]) {
            id parent=((id(*)(id,SEL))objc_msgSend)(split,@selector(tabParent));
            UIWindow *candidate=[parent isKindOfClass:UIView.class]
                ? ((UIView *)parent).window:nil;
            if(candidate && candidate!=vendor &&
               candidate.screen==vendor.screen &&
               !candidate.hidden && candidate.alpha>0.01)peer=candidate;
        }
        // Dock/Home may be separate native Dashboard windows from tabParent.
        for(UIScene *scene in UIApplication.sharedApplication.connectedScenes) {
            if(![scene isKindOfClass:UIWindowScene.class])continue;
            UIWindowScene *ws=(UIWindowScene *)scene;
            if(ws.screen!=vendor.screen)continue;
            for(UIWindow *w in ws.windows) {
                if(w==vendor || w.hidden || w.alpha<=0.01)continue;
                NSString *name=NSStringFromClass(w.class);
                BOOL chrome=[name rangeOfString:@"DBDashboard"].location!=NSNotFound ||
                    [name rangeOfString:@"DBDock"].location!=NSNotFound;
                if(chrome && (!peer || w.windowLevel>peer.windowLevel))peer=w;
            }
        }
    } else {
        id host=DCLShared(@"ABHost");
        if(host && [host respondsToSelector:@selector(window)]) {
            id item=((id(*)(id,SEL))objc_msgSend)(host,@selector(window));
            if([item isKindOfClass:UIWindow.class]) {
                UIWindow *candidate=item;
                if(candidate!=vendor && candidate.screen==vendor.screen &&
                   !candidate.hidden && candidate.alpha>0.01)peer=candidate;
            }
        }
    }
    return peer;
}
static void DCLRaiseOriginalBubble(id owner,NSString *reason) {
    if(!owner || !DCLMasterEnabled())return;
    UIView *bubble=DCLVendorBubble(owner);
    UIWindow *vendor=bubble.window;
    if(!vendor || vendor.hidden || bubble.hidden)return;
    BOOL car=[NSBundle.mainBundle.bundleIdentifier
                  isEqualToString:@"com.apple.CarPlayApp"];
    UIWindow *peer=DCLPeerWindow(vendor,car);
    if(!peer) {
        static CFAbsoluteTime lastBlind=0;
        CFAbsoluteTime now=CFAbsoluteTimeGetCurrent();
        if(now-lastBlind>=5.0) {
            lastBlind=now;
            NSLog(@"[hl59-layer] BLIND proc=%@ event=%@ vendor=%@ scene=%@",
                  NSBundle.mainBundle.bundleIdentifier,reason,
                  NSStringFromClass(vendor.class),vendor.windowScene);
        }
        return;
    }
    double prior=vendor.windowLevel;
    double wanted=peer.windowLevel+2.0;
    if(!isfinite(prior)||!isfinite(wanted)||
       wanted>=UIWindowLevelAlert-1.0)return;
    if(prior+0.01<wanted)vendor.windowLevel=wanted;
    static CFAbsoluteTime lastTrace=0;
    CFAbsoluteTime now=CFAbsoluteTimeGetCurrent();
    if(prior+0.01<wanted || now-lastTrace>=5.0) {
        lastTrace=now;
        NSLog(@"[hl59-layer] proc=%@ event=%@ bubble=%@ "
              "old=%.2f now=%.2f peer=%@ level=%.2f sameScene=%d",
              NSBundle.mainBundle.bundleIdentifier,reason,
              NSStringFromClass(vendor.class),prior,
              (double)vendor.windowLevel,NSStringFromClass(peer.class),
              (double)peer.windowLevel,
              (int)(vendor.windowScene==peer.windowScene));
    }
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
    DCLRaiseOriginalBubble(owner,@"native-place");
}
static void DCLCastPlace(id owner,SEL sel,CGRect rect) {
    if(DCLOriginalCastPlace)DCLOriginalCastPlace(owner,sel,rect);
    DCLCastOwner=owner;
    DCLApplyVisibility(owner);
    DCLRaiseOriginalBubble(owner,@"cast-place");
}

// Reorder after the original controller performs the only native placement.
static void DCLCastShowAt(id owner,SEL sel,CGRect rect,double level) {
    DCLCastOwner=owner;
    if(DCLOriginalCastShowAt)DCLOriginalCastShowAt(owner,sel,rect,level);
    DCLRaiseOriginalBubble(owner,@"cast-show");
}
static void DCLLauncherRaise(id split,SEL sel) {
    if(DCLOriginalLauncherRaise)DCLOriginalLauncherRaise(split,sel);
    DCLRaiseOriginalBubble(DCLOverlayOwner,@"logo-raise");
}
static void DCLHostFront(id host,SEL sel,BOOL front,id bundle) {
    if(DCLOriginalHostFront)DCLOriginalHostFront(host,sel,front,bundle);
    if(front)DCLRaiseOriginalBubble(DCLCastOwner,@"hosted-front");
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
    if(instance && selector==@selector(showAt:level:)) {
        char rect[128]={0},num[16]={0};
        method_getArgumentType(method,2,rect,sizeof(rect));
        method_getArgumentType(method,3,num,sizeof(num));
        if(!strstr(rect,"{CGRect=") || num[0]!='d')return NO;
    }
    if(instance && selector==@selector(setFront:forApp:)) {
        char active[16]={0},app[16]={0};
        method_getArgumentType(method,2,active,sizeof(active));
        method_getArgumentType(method,3,app,sizeof(app));
        if((active[0]!='B' && active[0]!='c') || app[0]!='@')return NO;
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
    NSString *proc=NSBundle.mainBundle.bundleIdentifier;
    if([proc isEqualToString:@"com.apple.CarPlayApp"] && !DCLLauncherHookInstalled)
        DCLLauncherHookInstalled=DCLInstall(NSClassFromString(@"SCPCarSplit"),
            @selector(raiseLauncher),(IMP)DCLLauncherRaise,
            (IMP *)&DCLOriginalLauncherRaise,YES,2);
    if([proc isEqualToString:@"com.apple.springboard"] && !DCLHostFrontInstalled)
        DCLHostFrontInstalled=DCLInstall(NSClassFromString(@"ABHost"),
            @selector(setFront:forApp:),(IMP)DCLHostFront,
            (IMP *)&DCLOriginalHostFront,YES,4);
    if([proc isEqualToString:@"com.apple.springboard"] && !DCLCastShowInstalled)
        DCLCastShowInstalled=DCLInstall(NSClassFromString(@"CWCastBubbleController"),
            @selector(showAt:level:),(IMP)DCLCastShowAt,
            (IMP *)&DCLOriginalCastShowAt,YES,4);
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
            DCLRaiseOriginalBubble(DCLOverlayOwner,@"master");
            DCLRaiseOriginalBubble(DCLCastOwner,@"master");
        });
        static NSUInteger tries=0;
        NSTimer *timer=[NSTimer timerWithTimeInterval:1.0 repeats:YES
               block:^(NSTimer *t) {
            DCLInstallExternalLeHooks();
            if((DCLContentInstalled&&
               (DCLOverlayInstalled||DCLCastInstalled) &&
               (springboard ? (DCLHostFrontInstalled && DCLCastShowInstalled)
                            : DCLLauncherHookInstalled))||++tries>=180) {
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
