// QA15 native scene reference-size + content orientation adapter.
// Owner: ABHost, not SCPCarSplit. Preserve native split, Solo, Zoom/Swap,
// 4-second timer, Chrome/Dock, gestures and non-YouTube AppBridge panes.
// The 0.50 scale is derived from DuoFace Native12 verified 2x native size.
// It is an unconfirmed device hypothesis, not a proven pixel-perfect fix.
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <objc/runtime.h>
#import <objc/message.h>
#import <math.h>
#import <string.h>

@interface ABHost : NSObject
- (double)zoom;
- (void)layoutPane:(id)pane;
- (NSInteger)effectiveOrientation:(id)pane;
@end

static NSString * const kOMCYTID=@"com.google.ios.youtube";
static __thread BOOL gOMCInYoutubeLayout=NO;
static __thread NSUInteger gOMCLayoutNesting=0;
static BOOL gOMCHooksInstalled=NO;
static const double kOMCYTNative12CandidateScale=0.50;
static const CGFloat kOMCMinPaneDimension=2.0;

// Avoid sending a guessed object-return message to a method whose return type
// is BOOL/CGRect/CGSize/void, which can corrupt arm64 registers or crash.
static id OMCReadObjectGetter(id object,NSString *name) {
    if(!object || ![object isKindOfClass:NSObject.class] || name.length==0)return nil;
    SEL sel=NSSelectorFromString(name);
    NSMethodSignature *sig=[object methodSignatureForSelector:sel];
    if(!sig || sig.numberOfArguments!=2 || !sig.methodReturnType ||
       sig.methodReturnType[0]!='@' || ![object respondsToSelector:sel])return nil;
    return ((id(*)(id,SEL))objc_msgSend)(object,sel);
}
static NSString *OMCYTFindBundle(id object,NSUInteger depth) {
    if(!object || depth>2)return nil;
    if([object isKindOfClass:NSString.class]) {
        NSString *s=(NSString *)object;
        return [s isEqualToString:kOMCYTID]?s:nil;
    }
    if(![object isKindOfClass:NSObject.class])return nil;
    // Only inspect explicitly named, object-returning properties.
    NSArray<NSString *> *properties=@[
        @"bundleIdentifier", @"bundleID", @"bundleId",
        @"appBundleIdentifier", @"appID", @"app",
        @"application", @"bundle", @"identifier"
    ];
    for(NSString *key in properties) {
        id value=OMCReadObjectGetter(object,key);
        if(value && value!=object) {
            NSString *found=OMCYTFindBundle(value,depth+1);
            if(found)return found;
        }
    }
    // Original ABPane may store its app as an object ivar, not a property.
    // Inspect only object-type ivars whose NAME denotes app/bundle; no KVC.
    unsigned int count=0;
    Ivar *fields=class_copyIvarList(object_getClass(object),&count);
    if(fields) {
        for(unsigned int i=0;i<count;i++) {
            const char *name=ivar_getName(fields[i]);
            const char *type=ivar_getTypeEncoding(fields[i]);
            if(!name || !type || type[0]!='@')continue;
            NSString *key=[[NSString stringWithUTF8String:name] lowercaseString];
            if(![key containsString:@"app"] && ![key containsString:@"bundle"])continue;
            id value=object_getIvar(object,fields[i]);
            if(value && value!=object) {
                NSString *found=OMCYTFindBundle(value,depth+1);
                if(found) {
                    free(fields);
                    return found;
                }
            }
        }
        free(fields);
    }
    return nil;
}

static BOOL OMCReadCGSize(id obj,SEL selector,CGSize *out) {
    if(!obj || !out || ![obj respondsToSelector:selector])return NO;
    NSMethodSignature *sig=[obj methodSignatureForSelector:selector];
    if(!sig || sig.numberOfArguments!=2 ||
       sig.methodReturnLength!=sizeof(CGSize) ||
       strncmp(sig.methodReturnType,"{CGSize=",8)!=0)return NO;
    CGSize value=((CGSize(*)(id,SEL))objc_msgSend)(obj,selector);
    if(!isfinite(value.width) || !isfinite(value.height))return NO;
    *out=value;
    return YES;
}
static BOOL OMCPaneSize(id pane,CGSize *size) {
    id controller=OMCReadObjectGetter(pane,@"appViewController");
    id view=OMCReadObjectGetter(controller,@"view");
    if(![view isKindOfClass:UIView.class]) {
        view=OMCReadObjectGetter(pane,@"view");
    }
    if(![view isKindOfClass:UIView.class])return NO;
    CGSize bounds=((UIView *)view).bounds.size;
    if(!isfinite(bounds.width)||!isfinite(bounds.height))return NO;
    *size=bounds;
    return YES;
}
static NSString *OMCSizeString(CGSize v,BOOL valid) {
    return valid?[NSString stringWithFormat:@"%.1fx%.1f",v.width,v.height]:@"unknown";
}
// QA15: DuoFace original controls native content reference size and BOTH
// content/container orientation domains. QA15 pin-native-reference was wrong;
// preserve OmniCar's native effectiveOrientation instead of arbitrary pinning.
static BOOL OMCYTSendReference(id receiver,CGSize nativeSize) {
    if(!receiver || ![receiver isKindOfClass:NSObject.class])return NO;
    if(!isfinite(nativeSize.width)||!isfinite(nativeSize.height)||
       nativeSize.width<4||nativeSize.height<4||
       nativeSize.width>8192||nativeSize.height>8192)return NO;
    BOOL dispatched=NO;
    for(NSUInteger index=0;index<2;index++) {
        SEL sel=NSSelectorFromString(index==0
             ?@"setContentReferenceSize:withInterfaceOrientation:"
             :@"setContentReferenceSize:withContentOrientation:andContainerOrientation:");
        if(![receiver respondsToSelector:sel])continue;
        NSMethodSignature *sig=[receiver methodSignatureForSelector:sel];
        if(!sig || sig.numberOfArguments!=(index==0?4:5) ||
           strcmp(sig.methodReturnType,"v")!=0 ||
           strncmp([sig getArgumentTypeAtIndex:2],"{CGSize=",8)!=0 ||
           sig.frameLength==0)continue;
        const char *t=[sig getArgumentTypeAtIndex:3];
        if(!t || (t[0]!='q'&&t[0]!='i'&&t[0]!='Q'))continue;
        if(index==1){
            const char *u=[sig getArgumentTypeAtIndex:4];
            if(!u||(u[0]!='q'&&u[0]!='i'&&u[0]!='Q'))continue;
        }
        // Same numeric orientation=1 observed at original DuoFace
        // 0xad6a4/0xad6dc and 0xacfcc/0xad004 (SHA-locked ARM64).
        if(index==0){
            ((void(*)(id,SEL,CGSize,NSInteger))objc_msgSend)(receiver,sel,nativeSize,1);
        }else{
            ((void(*)(id,SEL,CGSize,NSInteger,NSInteger))objc_msgSend)(receiver,sel,nativeSize,1,1);
        }
        dispatched=YES;
        NSLog(@"[OmniCarYTSceneQA15] event=reference-set selector=%lu size=%.1fx%.1f orientation=1",
              (unsigned long)index,nativeSize.width,nativeSize.height);
    }
    return dispatched;
}
static id OMCYTPrivateDeviceController(id appController) {
    if(!appController || ![appController isKindOfClass:NSObject.class])return nil;
    // Mirrors exact original DuoFace KVC _deviceAppViewController but
    // catches absence; private API may not exist under OmniCar's host.
    @try {
        id device=[appController valueForKey:@"_deviceAppViewController"];
        return [device isKindOfClass:NSObject.class]?device:nil;
    }@catch(NSException *exception) {
        return nil;
    }
}
%hook ABHost
- (NSInteger)effectiveOrientation:(id)pane {
    // QA15 pinned the first arbitrary landscape and could lock the WRONG
    // 180-degree direction. Do NOT override original orientation any more.
    return %orig;
}
- (double)zoom {
    double original=%orig;
    if(!gOMCInYoutubeLayout || gOMCLayoutNesting==0)return original;
    if(!isfinite(original)||original<=0)return original;
    // ABHost.layoutPane computes logical UIView frame=bounds/zoom AND applies
    // matching transform; it also sends UIKit scene setFrame/orientation.
    // Calling its ORIGINAL implementation keeps all three paths coherent.
    return kOMCYTNative12CandidateScale;
}
- (void)layoutPane:(id)pane {
    // Fail closed: unknown owner or app remains byte-identical original path.
    BOOL isYoutube=(OMCYTFindBundle(pane,0)!=nil);
    CGSize physical=CGSizeZero, sceneBefore=CGSizeZero,sceneAfter=CGSizeZero;
    BOOL measured=NO, beforeValid=NO, afterValid=NO;
    if(isYoutube){
        measured=OMCPaneSize(pane,&physical);
        beforeValid=OMCReadCGSize(pane,@selector(sceneBox),&sceneBefore);
        // Never apply an unmeasured transform. A foreign UIView owner or
        // a zero-sized pane must execute the original AppBridge path.
        if(!measured || physical.width<kOMCMinPaneDimension ||
           physical.height<kOMCMinPaneDimension)isYoutube=NO;
    }
    BOOL prior=gOMCInYoutubeLayout;
    NSUInteger priorDepth=gOMCLayoutNesting;
    gOMCInYoutubeLayout=isYoutube;
    gOMCLayoutNesting=priorDepth+1;
    @try {
        %orig;
    } @finally {
        gOMCInYoutubeLayout=prior;
        gOMCLayoutNesting=priorDepth;
    }
    if(isYoutube) {
        // Both DuoFace original layout and scene-refresh update the native
        // app content reference. This is the nearest safe owner-side point:
        // run AFTER original layout so view/scene dimensions are established.
        id appController=OMCReadObjectGetter(pane,@"appViewController");
        id device=OMCYTPrivateDeviceController(appController);
        CGSize native=CGSizeMake(round(physical.width*2.0),
                                 round(physical.height*2.0));
        BOOL deviceUpdated=OMCYTSendReference(device,native);
        BOOL rootUpdated=OMCYTSendReference(appController,native);
        NSLog(@"[OmniCarYTSceneQA15] event=native-ref target=%@ device=%d root=%d validPane=%d",
              device?@"available":@"unavailable",
              (int)deviceUpdated,(int)rootUpdated,(int)measured);
        afterValid=OMCReadCGSize(pane,@selector(sceneBox),&sceneAfter);
        // Numbers only: never log YouTube account, video title, URL or media.
        NSLog(@"[OmniCarYTSceneQA15] event=scene-layout app=youtube policy=native12-2x-candidate physical=%@ sceneBefore=%@ sceneAfter=%@ scale=0.50",
              OMCSizeString(physical,measured),
              OMCSizeString(sceneBefore,beforeValid),
              OMCSizeString(sceneAfter,afterValid));
    }
}
%end

static void OMCYTTryInstall(NSUInteger retries){
    if(gOMCHooksInstalled)return;
    if(!NSClassFromString(@"ABHost")){
        if(retries<25)dispatch_after(dispatch_time(DISPATCH_TIME_NOW,(int64_t)(0.4*NSEC_PER_SEC)),
            dispatch_get_main_queue(),^{ OMCYTTryInstall(retries+1); });
        return;
    }
    %init;
    gOMCHooksInstalled=YES;
    NSLog(@"[OmniCarYTSceneQA15] event=hook-ready exact-youtube-only orientation-guard=native-reference-size nativeSplit=untouched");
}
%ctor {
    @autoreleasepool {
        NSString *bundle=NSBundle.mainBundle.bundleIdentifier.lowercaseString?:@"";
        if([bundle isEqualToString:@"com.apple.carplayapp"] ||
           [bundle isEqualToString:@"com.apple.springboard"])
            dispatch_async(dispatch_get_main_queue(),^{ OMCYTTryInstall(0); });
    }
}
