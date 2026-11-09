// SSSplash.m
// OmniCar 1.0.3 — OmniCarStartupScreen.dylib — SSSplash reconstruction.
//
// One SSSplash = one splash session on one car UIScreen.
//   style 0    : JPEG frame-sequence player. Frames are %05lu.jpg files in
//                <Videos>/.frames/<name>/ with an info.plist {count, fps},
//                decoded ahead on a serial queue via ImageIO and shown from a
//                CADisplayLink tick at the recorded fps. (There is NO
//                AVPlayer anywhere in this module.)
//   styles 1-11: an SSStartupView animated scene in the same window.
//
// Fidelity tags: [VERIFIED] / [INFERRED] / [NOT-RECOVERED] — see the header
// and StartupScreen_REPORT.md. The init body in the binary is split by the
// compiler into sub_5458 (EventKit tail) and sub_5764 (window assembly);
// both are folded back into init here, as the call graph proves they belong.

#import "SSStartupScreen.h"
#import <EventKit/EventKit.h>
#import <objc/runtime.h>
#import <notify.h>

@implementation SSSplashWindow
@end

// Window level: UIWindowLevelAlert + 1000.0. [VERIFIED: __const double
// @0x28dc8, added to UIWindowLevelAlert in sub_5458 — resolved by
// verifier #6; originally a NOT-RECOVERED placeholder of 10.0.]
static const double kSSWindowLevelOffset = 1000.0;
// Fade-out duration in -dismissBecause: — [VERIFIED: __const double
// @0x28df0 = 0.4, loaded at 0x6fc0 into animateWithDuration: — resolved
// by verifier #6; originally a NOT-RECOVERED placeholder of 0.35. The
// same constant is the soundtrack stop-fade duration in sub_8f0c.]
static const double kSSDismissFadeDuration = 0.4;

extern SSSplash *SSSplashForScreen(UIScreen *screen);        // SSStartupScreen.m
extern void SSClearSplashAssociation(UIScreen *screen, SSSplash *splash);

@implementation SSSplash

- (instancetype)initWithScreen:(UIScreen *)screen scene:(UIWindowScene *)scene
                         style:(NSInteger)style occasion:(NSInteger)occasion
                     framesDir:(NSString *)framesDir frameCount:(NSUInteger)frameCount
                           fps:(double)fps {   // 0x46b4 [VERIFIED]
    self = [super init];
    if (!self) return nil;
    _screen = screen;
    _style = style;
    _framesDir = [framesDir copy];
    _frameCount = frameCount;
    _fps = fps;
    _loop = [OMCPref(@"startupScreenPlayFull", @NO) boolValue];
    _buffer = [NSMutableArray array];
    _decodeQueue = dispatch_queue_create("com.anlai.omnicar.startupscreen.decode",
                                         DISPATCH_QUEUE_SERIAL);   // [INFERRED: serial attr]
    BOOL tapToSkip = [OMCPref(@"startupScreenTapToSkip", @YES) boolValue];

    UIView *contentView = nil;
    if (style != 0) {
        SSStartupView *view = [[SSStartupView alloc] initWithFrame:screen.bounds];
        _startView = view;
        view.style = style;
        view.occasion = occasion;
        NSString *greetingName = OMCPref(@"startupScreenGreetingName", nil);
        if ([greetingName isKindOfClass:NSString.class]) view.name = greetingName;
        view.logoEffect = [OMCPref(@"startupScreenLogoEffect", @0) integerValue];
        NSString *carName = [OMCPref(@"startupScreenCarName", @"")
                             stringByTrimmingCharactersInSet:NSCharacterSet.whitespaceCharacterSet];
        if (!carName.length) {
            // Fall back to the car name the probe data collected: the first
            // usable string inside the nested diagCar pref dictionaries.
            id profiles = OMCPref(@"diagCar", nil);
            if ([profiles isKindOfClass:NSDictionary.class]) {
                for (id sub in [(NSDictionary *)profiles allValues]) {
                    if (![sub isKindOfClass:NSDictionary.class]) continue;
                    for (id value in [(NSDictionary *)sub allValues]) {
                        if (![value isKindOfClass:NSString.class]) continue;
                        NSString *trimmed = [(NSString *)value stringByTrimmingCharactersInSet:
                                             NSCharacterSet.whitespaceCharacterSet];
                        if (trimmed.length && ![trimmed isEqualToString:@"nil"] &&
                            ![trimmed isEqualToString:@"(null)"]) { carName = trimmed; break; }
                    }
                    if (carName.length) break;
                }
            }
        }
        view.carName = carName;
        view.tempo = [OMCPref(@"startupScreenTempo", @1) integerValue];
        view.duration = SSPlaybackSeconds();
        UIImage *logo = SSLoadImageAtPath(SSLogoPath());
        if (logo) view.image = logo;
        else OMCLogWrite(@"StartupScreen", [NSString stringWithFormat:@"no logo at %@, showing the car glyph", SSLogoPath()]);

        // Status checklist ("HUD") [VERIFIED lines and order]
        NSMutableArray *hud = [NSMutableArray array];
        [hud addObject:@{ @"text": OMCTr(@"Đã kết nối CarPlay", @"CarPlay connected"), @"ok": @YES }];
        BOOL charging = NO;
        NSInteger battery = SSBatteryPercent(&charging);
        [hud addObject:@{ @"text": [NSString stringWithFormat:
                                    OMCTr(@"Pin iPhone %ld%%", @"iPhone battery %ld%%"), (long)battery],
                          @"ok": @YES }];
        NSInteger thermal = NSProcessInfo.processInfo.thermalState;
        NSString *thermalWord = thermal == NSProcessInfoThermalStateNominal ? @"OK" :
                                thermal == NSProcessInfoThermalStateCritical ? @"very hot" : @"hot";
        [hud addObject:@{ @"text": [NSString stringWithFormat:@"%@%@",
                                    OMCTr(@"Nhiệt độ máy: ", @"Phone temperature: "), thermalWord],
                          @"ok": @YES }];   // [INFERRED assembly + state grouping; the three words are VERIFIED]
        NSInteger lite = [OMCPref(@"liteMode", @0) integerValue];
        [hud addObject:@{ @"text": [NSString stringWithFormat:@"Lite mode: %@",
                                    lite == 1 ? @"on" : lite == 2 ? @"auto" : @"off"],
                          @"ok": @YES }];   // [INFERRED value mapping; three labels VERIFIED]
        if ([OMCPref(@"carProfilesEnabled", @NO) boolValue]) {
            NSArray *profiles = OMCPref(@"carProfiles", nil);
            NSInteger current = [OMCPref(@"carProfileCurrent", @0) integerValue];
            NSString *profileName = nil;
            if ([profiles isKindOfClass:NSArray.class] && current >= 0 &&
                current < (NSInteger)profiles.count &&
                [profiles[current] isKindOfClass:NSDictionary.class])
                profileName = profiles[current][@"name"];
            if ([profileName isKindOfClass:NSString.class] && profileName.length)
                [hud addObject:@{ @"text": [NSString stringWithFormat:@"Car profile: %@", profileName],
                                  @"ok": @YES }];
        }
        view.hud = hud;
        view.batteryPercent = battery;
        contentView = view;
    } else {
        NSInteger scaleMode = [OMCPref(@"startupScreenScaleMode", @0) integerValue];
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:screen.bounds];
        imageView.backgroundColor = UIColor.blackColor;
        // [VERIFIED mapping: Settings declares 0 = STARTUPSCREEN_SCALE_FILL, 1 = SCALE_FIT]
        imageView.contentMode = (scaleMode == 1) ? UIViewContentModeScaleAspectFit
                                                 : UIViewContentModeScaleAspectFill;
        imageView.clipsToBounds = YES;
        _imageView = imageView;
        contentView = imageView;
    }

    // Next calendar event (EventKit) — compiler-outlined tail sub_5458. [VERIFIED flow]
    @try {
        EKAuthorizationStatus status = [EKEventStore authorizationStatusForEntityType:EKEntityTypeEvent];
        if (status == EKAuthorizationStatusAuthorized) {   // [INFERRED exact status set]
            EKEventStore *store = [EKEventStore new];
            NSDate *now = NSDate.date;
            NSDate *end = [now dateByAddingTimeInterval:86400];   // [INFERRED interval]
            NSPredicate *predicate = [store predicateForEventsWithStartDate:now endDate:end
                                                                   calendars:[store calendarsForEntityType:EKEntityTypeEvent]];
            NSArray<EKEvent *> *events = [[store eventsMatchingPredicate:predicate]
                                          sortedArrayUsingSelector:@selector(compareStartDateWithEvent:)];
            for (EKEvent *event in events) {
                if (event.allDay) continue;
                if ([event.startDate compare:now] == NSOrderedAscending) continue;
                _startView.nextEvent = @{ @"title": event.title ?: @"",
                                          @"date": event.startDate };
                break;
            }
        } else {
            OMCLogWrite(@"StartupScreen", [NSString stringWithFormat:@"calendar: no access (status %ld), no event card", (long)status]);
        }
    } @catch (NSException *exception) {
        OMCLogWrite(@"StartupScreen", [NSString stringWithFormat:@"calendar: %@", exception]);
    }

    [_startView setWeather:SSWeatherLoadCache(43200)];   // 12h, as @0x5774
    [_startView reload];

    // Window assembly — compiler-outlined tail sub_5764. [VERIFIED flow]
    contentView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight; // [INFERRED]
    contentView.userInteractionEnabled = NO;   // [INFERRED value]
    UIViewController *rootVC = [UIViewController new];
    rootVC.view = contentView;
    SSSplashWindow *window = scene ? [[SSSplashWindow alloc] initWithWindowScene:scene]
                                   : [[SSSplashWindow alloc] initWithFrame:screen.bounds];
    window.screen = screen;
    window.windowLevel = UIWindowLevelAlert + kSSWindowLevelOffset;
    window.backgroundColor = UIColor.blackColor;
    window.rootViewController = rootVC;
    _window = window;
    if (tapToSkip)
        [window addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self
                                                                              action:@selector(tapped:)]];
    return self;
}

- (void)start {   // 0x5c24 [VERIFIED]
    _shownAt = CACurrentMediaTime();
    [_window setHidden:NO];   // NOTE: this very call is what the trigger hook watches;
                              // the SSSplashWindow class check is what keeps it from recursing.
    OMCLogWrite(@"StartupScreen", [NSString stringWithFormat:@"splash window shown: style=%ld frame=%@ level=%.0f scene=%@ frames=%lu fps=%.0f loop=%d",
                (long)_style, NSStringFromCGRect(_window.frame), _window.windowLevel,
                NSStringFromClass(_window.windowScene.class),
                (unsigned long)_frameCount, _fps, _loop]);
    _displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(tick)];
    [_displayLink addToRunLoop:NSRunLoop.mainRunLoop forMode:NSRunLoopCommonModes];
    // dump 0x5e50-0x5e84 [VERIFIED]: at start, only style 0 decodes
    // frames and only styles 3 and 8 ask for a weather refresh; every
    // other style does nothing here. (Restored fix-round6 weather W8;
    // previously EVERY style != 0 refreshed, poking the weather path
    // from every splash.)
    if (_style == 0) [self decodeMore];
    else if (_style == 3 || _style == 8) [self refreshWeather];
    // No-frame watchdog: if nothing was shown within 10 s, give up. For the
    // scene styles shownFrames stays 0, but by then the countdown has usually
    // finished the splash and -dismissBecause: is finished-guarded.
    __weak SSSplash *weakSelf = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(10.0 * NSEC_PER_SEC)),
                   dispatch_get_main_queue(), ^{   // sub_5f30 [VERIFIED]
        SSSplash *splash = weakSelf;
        if (!splash || splash->_shownFrames != 0) return;
        OMCLogWrite(@"StartupScreen", [NSString stringWithFormat:@"no frame shown after 10s (failed=%lu), giving up",
                    (unsigned long)splash->_failedFrames]);
        [splash dismissBecause:@"no frame after 10s"];
    });
}

- (void)tick {   // 0x68fc [VERIFIED]
    if (_finished) return;
    if (_style != 0) {
        // First tick for a scene style: hand over to the view's own animation
        // clock and start the dismiss countdown.
        [_displayLink invalidate];
        _startTime = CACurrentMediaTime();
        _shownFrames = 0;
        [_startView playIntro];
        [self startCountdown];
        return;
    }
    if (!_buffer.count) return;   // decoder has not produced anything yet
    if (_shownFrames == 0) {
        _startTime = CACurrentMediaTime();
        [self startCountdown];
    }
    UIImage *frame = _buffer.firstObject;
    _imageView.image = frame;
    [_buffer removeObjectAtIndex:0];
    _shownFrames++;
    [self decodeMore];
    if (!_loop && _shownFrames >= _frameCount) {
        [_displayLink invalidate];
        __weak SSSplash *weakSelf = self;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)((1.0 / _fps) * NSEC_PER_SEC)),
                       dispatch_get_main_queue(), ^{   // [INFERRED delay/reason]
            [weakSelf dismissBecause:@"ended"];
        });
    }
}

- (void)decodeMore {   // 0x6030 [VERIFIED structure; batch arithmetic INFERRED]
    if (_frameCount == 0 || _decoding || _finished) return;
    // Keep a small window of frames in flight / buffered; the binary compares
    // the outstanding count against 3. Exact window arithmetic: [NOT-RECOVERED].
    NSUInteger outstanding = _queuedFrames - _shownFrames - _failedFrames;
    if (_buffer.count + outstanding >= 3) return;
    _decoding = YES;
    NSUInteger index = _queuedFrames++;
    NSString *path = [_framesDir stringByAppendingPathComponent:
                      [NSString stringWithFormat:@"%05lu.jpg", (unsigned long)index]];
    dispatch_async(_decodeQueue, ^{   // sub_61f8 [VERIFIED]
        UIImage *image = SSLoadImageAtPath(path);
        dispatch_async(dispatch_get_main_queue(), ^{
            if (image) [self->_buffer addObject:image];
            else self->_failedFrames++;
            self->_decoding = NO;
        });
    });
}

- (void)startCountdown {   // 0x6c18 [VERIFIED]
    NSTimeInterval duration = SSPlaybackSeconds();
    if (_style == 0 && !_loop)
        duration = 60.0;   // [VERIFIED: cold block @0x6d94 sets 60.0
                           // (0x404E000000000000) for style 0 non-loop —
                           // verifier #6; previously INFERRED frameCount/fps]
    OMCLogWrite(@"StartupScreen", [NSString stringWithFormat:@"first frame shown, playing for up to %.0fs", duration]);
    int token = 0;
    if (notify_register_check("com.anlai.omnicar/startupscreen.style", &token) == 0)
        notify_set_state(token, (uint64_t)(_style + 1));   // [VERIFIED: add x1, x20, #1
                           // @0x6ca8 — the published state is style+1; 0 is the
                           // consumer's "unset" sentinel and the consumer
                           // recovers the style with state-1 (@0x8f74)]
    CFNotificationCenterPostNotification(CFNotificationCenterGetDarwinNotifyCenter(),
        CFSTR("com.anlai.omnicar/startupscreen.audio.play"), NULL, NULL, true);
    __weak SSSplash *weakSelf = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(duration * NSEC_PER_SEC)),
                   dispatch_get_main_queue(), ^{   // sub_6da8 [VERIFIED reason format]
        [weakSelf dismissBecause:[NSString stringWithFormat:@"%.0fs timer", duration]];
    });
}

- (void)tapped:(UITapGestureRecognizer *)recognizer {   // 0x6e18 [VERIFIED]
    [self dismissBecause:recognizer.numberOfTouches > 0 ? @"tap" : @"press (knob / button)"];
}

- (void)dismiss {   // 0x6e58 [VERIFIED]
    [self dismissBecause:@"skip"];
}

- (void)dismissBecause:(NSString *)reason {   // 0x6e64 [VERIFIED]
    if (_finished) return;
    _finished = YES;
    _endReason = [NSString stringWithFormat:@"%@ after %.1fs", reason,
                  CACurrentMediaTime() - _shownAt];
    OMCLogWrite(@"StartupScreen", [NSString stringWithFormat:@"dismissing after %lu frames: %@",
                (unsigned long)_shownFrames, _endReason]);
    CFNotificationCenterPostNotification(CFNotificationCenterGetDarwinNotifyCenter(),
        CFSTR("com.anlai.omnicar/startupscreen.audio.stop"), NULL, NULL, true);
    [UIView animateWithDuration:kSSDismissFadeDuration animations:^{
        self->_window.alpha = 0;
    } completion:^(BOOL finished) {
        [self tearDown];
    }];
}

- (void)tearDown {   // 0x7034 [VERIFIED]
    if (!_finished && _shownFrames > 0)
        CFNotificationCenterPostNotification(CFNotificationCenterGetDarwinNotifyCenter(),
            CFSTR("com.anlai.omnicar/startupscreen.audio.stop"), NULL, NULL, true);
    if (!_finished) {
        _endReason = @"torn down";   // [INFERRED exact endReason text]
        OMCLogWrite(@"StartupScreen", [NSString stringWithFormat:@"torn down after %.1fs", CACurrentMediaTime() - _shownAt]);
        _finished = YES;
    }
    [_displayLink invalidate];
    _displayLink = nil;
    [_buffer removeAllObjects];
    [_window setHidden:YES];
    _window = nil;
    if (_screen) SSClearSplashAssociation(_screen, self);
}

// ===========================================================================
// Weather refresh (CarPlayApp side) — 0x6434 [VERIFIED flow]
// CarPlayApp has no location permission of its own in the common case, so the
// flow is: ask SpringBoard over Darwin notify, wait for weather.ready, then
// read the shared cache file SpringBoard just wrote.
// ===========================================================================

static void (^SSPendingWeatherCompletion)(NSDictionary *weather);   // consumed by sub_8aa4
static int SSWeatherReadyToken;
static BOOL SSWeatherReadyRegistered;
static int SSWeatherGeneration;   // @0x3b19c: bumped per SpringBoard ask (sub_8b74/sub_8bf0 guard on it)

- (void)refreshWeather {   // 0x6434 [VERIFIED structure]
    __weak SSSplash *weakSelf = self;
    void (^apply)(NSDictionary *) = ^(NSDictionary *weather) {   // sub_67d0
        SSSplash *splash = weakSelf;
        if (!splash || !weather) return;
        if (splash->_finished) return;   // @0x680c [VERIFIED]: a finished
                                         // splash keeps its current view
        SSStartupView *view = splash->_startView;
        view.weather = weather;
        // @0x6858-0x688c [VERIFIED]: the weather is applied through a
        // 0.35s CrossDissolve transition (options 0x500000), NOT by a
        // bare reload. (Restored fix-round6 weather W4c.)
        [UIView transitionWithView:view duration:0.35 options:0x500000
                        animations:^{   // sub_68c4 [VERIFIED: body read
                                        // from dump — reload, then
                                        // layoutIfNeeded, on the view]
                            [view reload];
                            [view layoutIfNeeded];
                        }
                        completion:nil];
    };
    CLLocationManager *manager = [CLLocationManager new];
    // @0x64c8 [VERIFIED]: (status - 5) + 3 unsigned > 0 takes the direct
    // branch — only status {3,4} (AuthorizedAlways / AuthorizedWhenInUse)
    // go direct; the SpringBoard ask below covers {0,1,2} =
    // NotDetermined, Restricted, Denied. (Restored fix-round6 weather
    // W4a; previously NotDetermined alone asked, so Denied/Restricted
    // fell into the direct branch with a usually-nil location.)
    CLAuthorizationStatus status = [manager authorizationStatus];
    if (status != kCLAuthorizationStatusAuthorizedAlways &&
        status != kCLAuthorizationStatusAuthorizedWhenInUse) {
        if (!SSWeatherReadyRegistered) {
            SSWeatherReadyRegistered = YES;
            notify_register_dispatch("com.anlai.omnicar/startupscreen.weather.ready",
                                     &SSWeatherReadyToken, dispatch_get_main_queue(),
                                     ^(int token) {   // sub_8aa4 [VERIFIED]
                void (^completion)(NSDictionary *) = SSPendingWeatherCompletion;
                SSPendingWeatherCompletion = nil;
                NSDictionary *cache = SSWeatherLoadCache(43200);   // 12h, as @0x8adc
                OMCLogWrite(@"StartupScreen", [NSString stringWithFormat:@"weather: SpringBoard answered (%@)",
                            cache ? @"cache loaded" : @"nothing usable in the cache"]);
                if (completion) completion(cache);
            });
        }
        int generation = ++SSWeatherGeneration;   // @0x6510-0x651c: bumped
                                                  // on every ask, before
                                                  // the pending store
        SSPendingWeatherCompletion = apply;
        OMCLogWrite(@"StartupScreen", @"weather: no location access here, asking SpringBoard");
        notify_post("com.anlai.omnicar/startupscreen.weather.request");
        // sub_8b74 [VERIFIED]: the original enumerates the static delay
        // array @[@2, @5] (@0x35488) and arms one dispatch_after per
        // entry; each retry block re-checks (generation still current
        // && a completion still pending) before logging + re-posting,
        // so a stale retry from an earlier ask can never post.
        // (Restored fix-round6 weather W4b; previously ONE retry at an
        // [INFERRED] 3s, no generation guard.)
        for (NSNumber *delay in @[@2, @5]) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay.doubleValue * NSEC_PER_SEC)),
                           dispatch_get_main_queue(), ^{
                if (SSWeatherGeneration == generation && SSPendingWeatherCompletion) {
                    OMCLogWrite(@"StartupScreen", @"weather: no answer yet, asking SpringBoard again");
                    notify_post("com.anlai.omnicar/startupscreen.weather.request");
                }
            });
        }
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(10.0 * NSEC_PER_SEC)),
                       dispatch_get_main_queue(), ^{   // sub_8bf0 [VERIFIED]
            if (SSWeatherGeneration != generation) return;
            void (^completion)(NSDictionary *) = SSPendingWeatherCompletion;
            if (!completion) return;
            SSPendingWeatherCompletion = nil;
            OMCLogWrite(@"StartupScreen", @"weather: SpringBoard did not answer in 10s");
            completion(nil);   // nil, NOT the cache: the apply block
                               // bails on nil and the view is unchanged
        });
        return;
    }
    CLLocation *fix = manager.location;
    if (fix) {
        SSWeatherFetch(fix.coordinate.latitude, fix.coordinate.longitude, apply);
    } else {
        OMCLogWrite(@"StartupScreen", @"weather: no last known location, using the cache");
        // @0x6724 [VERIFIED]: the original invokes the completion with
        // nil on this path — the apply block bails on nil, so the view
        // keeps the cache that -init already loaded. (W4c mechanism.)
        apply(nil);
    }
}

@end
