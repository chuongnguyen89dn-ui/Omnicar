// SCPSpringBoardHooks.m — OmniCarSplitScreen, agent A domain.
// The SpringBoard-side initializers: __init_2 (0x843c, the SpringBoard
// applicationDidFinishLaunching: hook) and __init_3 (0x52048, the deferred
// diag/bootstrap block), plus the distributed-notification handlers the
// SpringBoard side registers. Reconstructed from disassembly; statuses in
// SplitScreenA_REPORT.md.

#import "SCPHooks.h"
#import "SCPShared.h"
#import "SCPVoiceSpringAgent.h" // [hl31] first-party voice audio agent, SpringBoard only
#import "SCPPrefs.h"
#import <objc/message.h>
#import <notify.h>
#import <substrate.h>
#import <signal.h>
#import <unistd.h>
#import <math.h>

void *orig_SpringBoard_applicationDidFinishLaunching;

// ---------------------------------------------------------------------------
// State for the native-command relay (VERIFIED globals): the last
// splitscreen.native userInfo posted from a phone app (0x880a8) and when it
// was posted (0x880b8, CFAbsoluteTime). When the car screen reports ready,
// the request is re-sent (block sub_875c: "man xe san sang -> gui lai yeu
// cau %@").
// ---------------------------------------------------------------------------
static NSDictionary *SCPLastNativeRequest;
static CFAbsoluteTime SCPLastNativeRequestAt;

// sub_88d0 VERIFIED: post a native-split command from SpringBoard to the
// CarPlayApp side, remembering it for the ready-replay.
void SCPPostNativeSplitRequest(NSDictionary *userInfo) {
    OMCLogWrite(@"SplitScreen", [NSString stringWithFormat:@"-> split CarPlay: %@", userInfo]);
    SCPLastNativeRequest = userInfo;
    SCPLastNativeRequestAt = CFAbsoluteTimeGetCurrent();
    [[NSDistributedNotificationCenter defaultCenter]
        postNotificationName:SCPNoteNativeCommand object:nil userInfo:userInfo];
}

// block 0x874c VERIFIED minimal: the splitscreen.ack observer body is four
// instructions — it only records the acknowledgement (no user-visible
// effect in the binary).
static void SCPNativeAckBlock(NSNotification *note) { (void)note; }

// block 0x875c VERIFIED: car screen ready -> replay the pending request.
static void SCPScreenReadyBlock(NSNotification *note) {
    if (!SCPLastNativeRequest) return;
    OMCLogWrite(@"SplitScreen", [NSString stringWithFormat:
        @"man xe san sang -> gui lai yeu cau %@", SCPLastNativeRequest]);
    [[NSDistributedNotificationCenter defaultCenter]
        postNotificationName:SCPNoteNativeCommand object:nil userInfo:SCPLastNativeRequest];
}

// block 0x89d0 VERIFIED: splitscreen.kill — terminate an app from
// SpringBoard. Primary path: FBSSystemService sharedService
// -terminateApplication:forReason:andReport:withDescription:
// (description @"OmniCar Split Screen close"); fallback: SBApplication-
// Controller -> application -> processState.pid -> kill(pid, SIGKILL).
// Log lines (VERIFIED): "tat han %@ (FBSSystemService)",
// "tat han %@ (kill pid %d)", "tat han %@ loi %@".
static void SCPKillAppBlock(NSNotification *note) {
    NSString *bundleID = note.userInfo[@"identifier"];
    if (![bundleID isKindOfClass:[NSString class]] || !bundleID.length) return;
    @try {
        id service = nil;
        Class fbs = NSClassFromString(@"FBSSystemService");
        SEL sharedSel = NSSelectorFromString(@"sharedService");
        if ([fbs respondsToSelector:sharedSel])
            service = ((id (*)(id, SEL))objc_msgSend)(fbs, sharedSel);
        else
            SCPMissingSelector(fbs, NSStringFromSelector(sharedSel));
        SEL termSel = NSSelectorFromString(@"terminateApplication:forReason:andReport:withDescription:");
        if ([service respondsToSelector:termSel]) {
            ((void (*)(id, SEL, id, NSInteger, BOOL, id))objc_msgSend)(
                service, termSel, bundleID, 1, NO, @"OmniCar Split Screen close");
            OMCLogWrite(@"SplitScreen", [NSString stringWithFormat:@"tat han %@ (FBSSystemService)", bundleID]);
            return;
        }
        SCPMissingSelector(service, NSStringFromSelector(termSel));
    } @catch (NSException *ex) {
        OMCLogWrite(@"SplitScreen", [NSString stringWithFormat:@"tat han %@ loi %@", bundleID, ex]);
    }
    // Fallback: kill by pid.
    @try {
        id controller = nil;
        Class sba = NSClassFromString(@"SBApplicationController");
        SEL sharedSel = NSSelectorFromString(@"sharedInstance");
        if ([sba respondsToSelector:sharedSel])
            controller = ((id (*)(id, SEL))objc_msgSend)(sba, sharedSel);
        else
            SCPMissingSelector(sba, NSStringFromSelector(sharedSel));
        SEL appSel = NSSelectorFromString(@"applicationWithBundleIdentifier:");
        id app = nil;
        if ([controller respondsToSelector:appSel])
            app = ((id (*)(id, SEL, id))objc_msgSend)(controller, appSel, bundleID);
        else
            SCPMissingSelector(controller, NSStringFromSelector(appSel));
        id state = SCPGuardedSend(app, @"processState");
        // sub_89d0 @0x8cd8-0x8d10 VERIFIED: the `pid` send is guarded
        // inline (NSSelectorFromString + respondsToSelector:, with
        // SCPMissingSelector on failure) and its return is consumed as
        // a raw integer -- the original emits NO
        // objc_retainAutoreleasedReturnValue for it, unlike the
        // object-returning sends around it. It must NOT go through
        // SCPGuardedSend (which returns `id`): under ARC the pid would
        // be treated as an object pointer. Used when >= 1; signal is
        // 9 (SIGKILL).
        pid_t pid = 0;
        if (state) {
            SEL pidSel = NSSelectorFromString(@"pid");
            if ([state respondsToSelector:pidSel])
                pid = ((pid_t (*)(id, SEL))objc_msgSend)(state, pidSel);
            else
                SCPMissingSelector(state, @"pid");
        }
        if (pid >= 1) {
            kill(pid, SIGKILL);
            OMCLogWrite(@"SplitScreen", [NSString stringWithFormat:@"tat han %@ (kill pid %d)", bundleID, pid]);
        } else {
            OMCLogWrite(@"SplitScreen", [NSString stringWithFormat:@"tat han %@: khong thay process", bundleID]);
        }
    } @catch (NSException *ex) {
        OMCLogWrite(@"SplitScreen", [NSString stringWithFormat:@"tat han %@ loi %@", bundleID, ex]);
    }
}

// block 0x8f6c VERIFIED: com.anlai.omnicar/url — translate an omnicar://
// URL into a native-split command. Shape: scheme "omnicar", host
// "splitscreen", first path component = the action; query items are merged
// into the command dictionary; the feature must be enabled (else the log
// "URL %@ bo qua: tinh nang dang tat"); the merged dict is logged
// ("yeu cau tu URL: %@ %@") and posted through SCPPostNativeSplitRequest.
static void SCPURLBlock(NSNotification *note) {
    NSString *urlString = note.userInfo[@"url"];
    NSURL *url = [NSURL URLWithString:urlString];
    if (![[url scheme] isEqualToString:@"omnicar"]) return;
    if (![[url host] isEqualToString:@"splitscreen"]) return;
    if (![SCPPrefs enabled]) {
        OMCLogWrite(@"SplitScreen", [NSString stringWithFormat:@"URL %@ bo qua: tinh nang dang tat", url]);
        return;
    }
    NSArray *components = [url pathComponents];
    if (components.count < 2) return;
    NSMutableDictionary *command = [@{@"action": components[1]} mutableCopy];
    NSURLComponents *parsed = [NSURLComponents componentsWithURL:url resolvingAgainstBaseURL:NO];
    for (NSURLQueryItem *item in parsed.queryItems) {
        if (item.value) command[item.name] = item.value;
    }
    OMCLogWrite(@"SplitScreen", [NSString stringWithFormat:@"yeu cau tu URL: %@ %@", url, command]);
    SCPPostNativeSplitRequest(command);
}

// HL27: user-confirmed Respring belongs in SpringBoard, not the iPhone app.
// Previous HL26 sent SBSRelaunchAction from a sandboxed iPhone app and
// returned without observing execution. This route uses the existing
// SpringBoard-loaded split tweak and NSDistributedNotificationCenter.
// It is never invoked on startup: a fresh, timely, explicit request is required.
static CFAbsoluteTime SCP27RespringLastAt = 0;
static void SCP27RespringRequest(NSNotification *note) {
    if (![[NSBundle.mainBundle bundleIdentifier] isEqualToString:@"com.apple.springboard"])
        return;
    NSDictionary *payload=note.userInfo;
    NSString *nonce=[payload[@"nonce"] isKindOfClass:NSString.class]?payload[@"nonce"]:nil;
    NSNumber *stamp=[payload[@"issuedAt"] isKindOfClass:NSNumber.class]?payload[@"issuedAt"]:nil;
    CFAbsoluteTime now=CFAbsoluteTimeGetCurrent();
    BOOL valid=nonce.length==36 && stamp &&
        isfinite(stamp.doubleValue) && fabs(now-stamp.doubleValue)<12.0 &&
        now-SCP27RespringLastAt>=8.0;
    if (!valid) {
        OMCLogWrite(@"SplitScreen",@"[hl27-respring] stage=reject invalid-or-stale-request");
        return;
    }
    SCP27RespringLastAt=now;
    OMCLogWrite(@"SplitScreen",[NSString stringWithFormat:
        @"[hl27-respring] stage=accepted springboard-pid=%d", getpid()]);
    [[NSDistributedNotificationCenter defaultCenter]
        postNotificationName:@"com.anlai.omnicar/respring.ack" object:nil
                    userInfo:@{@"nonce":nonce,@"status":@"accepted"}];
    // Give the acknowledgement time to reach the app and the log relay
    // before terminating our own SpringBoard process. launchd owns restart.
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.75*NSEC_PER_SEC)),
                   dispatch_get_main_queue(), ^{
        OMCLogWrite(@"SplitScreen",[NSString stringWithFormat:
            @"[hl27-respring] stage=terminate-self springboard-pid=%d", getpid()]);
        // Match the original confirmed Respring fallback: terminate only
        // this SpringBoard PID. launchd will spawn a fresh instance.
        kill(getpid(),SIGKILL);
    });
}

// sub_8540 VERIFIED: replacement for -[SpringBoard
// applicationDidFinishLaunching:]: original first, then register the four
// distributed-notification observers (main queue).
static void Hook_applicationDidFinishLaunching(id self, SEL _cmd, id app) {
    ((void (*)(id, SEL, id))orig_SpringBoard_applicationDidFinishLaunching)(self, _cmd, app);
    OMCLogWrite(@"SplitScreen", @"SpringBoard ready, dang ky notification");
    NSDistributedNotificationCenter *center = [NSDistributedNotificationCenter defaultCenter];
    NSOperationQueue *mainQueue = [NSOperationQueue mainQueue];
    [center addObserverForName:SCPNoteNativeAck object:nil queue:mainQueue
                    usingBlock:^(NSNotification *n) { SCPNativeAckBlock(n); }];
    [center addObserverForName:SCPNoteScreenReady object:nil queue:mainQueue
                    usingBlock:^(NSNotification *n) { SCPScreenReadyBlock(n); }];
    [center addObserverForName:SCPNoteKillApp object:nil queue:mainQueue
                    usingBlock:^(NSNotification *n) { SCPKillAppBlock(n); }];
    [center addObserverForName:SCPNoteURL object:nil queue:mainQueue
                    usingBlock:^(NSNotification *n) { SCPURLBlock(n); }];
    [center addObserverForName:@"com.anlai.omnicar/respring.request"
                       object:nil queue:mainQueue
                   usingBlock:^(NSNotification *n) { SCP27RespringRequest(n); }];
    OMCLogWrite(@"SplitScreen",@"[hl27-respring] stage=observer-ready owner=SpringBoard");
    // [hl31] User-tapped CarPlay bubble -> existing SpringBoard observer.
    // No second launch/bootstrap hook, no recording without the tap.
    SCPVoiceSpringInstall();
}

// __init_2 (0x843c) VERIFIED end-to-end. Runs in SpringBoard only; the hook
// call is a TAIL call (b _MSHookMessageEx) at the end of the constructor.
__attribute__((constructor))
static void SCPInitSpringBoardHook(void) {
    if (![[[NSBundle mainBundle] bundleIdentifier] isEqualToString:@"com.apple.springboard"])
        return;
    OMCLogWrite(@"SplitScreen", @"loaded into SpringBoard");
    MSHookMessageEx(objc_getClass("SpringBoard"),
                    @selector(applicationDidFinishLaunching:),
                    (IMP)Hook_applicationDidFinishLaunching,
                    (IMP *)&orig_SpringBoard_applicationDidFinishLaunching);
}

// __init_3 (0x52048) VERIFIED: in processes named "SpringBoard" or
// "CarPlay" (processName check), defer to the main queue. The deferred
// block (sub_52118) logs the build fingerprint and writes a diag record
// into the shared prefs — VERIFIED contents: format
// "build %s (%s) loaded into %@", keys built from "diagLoaded." + process,
// dictionary {version: "1.0.3", build: "fbebb21", date: [NSDate date]}.
__attribute__((constructor))
static void SCPInitDiag(void) {
    NSString *process = [[NSProcessInfo processInfo] processName];
    if (![process isEqualToString:@"SpringBoard"] && ![process isEqualToString:@"CarPlay"])
        return;
    dispatch_async(dispatch_get_main_queue(), ^{
        OMCLogWrite(@"SplitScreen", [NSString stringWithFormat:
            @"build %s (%s) loaded into %@", "1.0.3", "fbebb21", process]);
        // VERIFIED write path: CFPreferencesSetAppValue directly on the
        // com.anlai.omnicar suite (not the OMC pref setters).
        NSString *key = [NSString stringWithFormat:@"%@%s@%@", @"diagLoaded.", "SplitScreen", process];
        CFPreferencesSetAppValue((__bridge CFStringRef)key,
            (__bridge CFPropertyListRef)@{@"version": @"1.0.3", @"build": @"fbebb21", @"date": [NSDate date]},
            CFSTR("com.anlai.omnicar"));
        CFPreferencesAppSynchronize(CFSTR("com.anlai.omnicar"));
    });
}
