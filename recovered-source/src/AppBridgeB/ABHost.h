// ABHost.h / ABPane.h — class layouts recovered from the ObjC metadata of
// OmniCarAppBridge.dylib (objc.json) and verified against method bodies.
//
// NOTE on superclass bindings — CORRECTED 2026-11-08 (coordinator
// calibration broadcast): the wave-1 metadata recorded surprising names
// (ABHost/ABPane/ABKeyboard: NSRunLoop, ABBoxView/ABShieldView/ABKnobView:
// UIWindowScene, ABBarButton/ABKey: NSNull). Those are WRONG — wave-1's
// chained-fixup ordinal decoding was off by one. Re-decoding each class
// struct's superclass bind slot with the LC_DYSYMTAB-calibrated scheme
// (validated 180/180 on __got slots) gives the true bindings, which match
// the semantics exactly: ABPane/ABHost/ABKeyboard : NSObject,
// ABBoxView/ABShieldView/ABKnobView : UIView, ABBarButton/ABKey :
// UIButton. The reconstruction below uses these proven bindings.

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class ABBoxView, ABShieldView, ABKeyboard;

// ---------------------------------------------------------------------------
// ABPane — one hosted app. 17 ivars (objc.json, verbatim order/types);
// all 35 methods are synthesized accessors (spot-verified: -frame/-setFrame:
// are single ivar load/store pairs at offsets 0x90/0xA0) plus +cxx_destruct.
// Superclass: NSObject (proven by calibrated bind decode — see note above;
// wave-1 metadata's "NSRunLoop" was the off-by-one error).
// ---------------------------------------------------------------------------
@interface ABPane : NSObject
@property (nonatomic) BOOL ready;
@property (nonatomic, copy) NSString *bundleID;
@property (nonatomic, strong) ABBoxView *box;
@property (nonatomic, strong) id application;        // SBApplication (private)
@property (nonatomic, strong) id appViewController;  // scene VC (private)
@property (nonatomic, strong) id sceneMonitor;       // FBSceneMonitor (private)
@property (nonatomic) NSInteger orientation;
@property (nonatomic) NSInteger requestedOrientation;
@property (nonatomic, strong) UIView *handle;
@property (nonatomic, strong) UIView *handleHit;
@property (nonatomic, strong) UIView *bar;
@property (nonatomic, strong) UIButton *popButton;
@property (nonatomic, strong) UIButton *soloButton;
@property (nonatomic) double handleOffset;
@property (nonatomic, strong) UIView *shield;        // ABShieldView when on
@property (nonatomic) CGSize sceneBox;               // on-screen (box) size of the scene
@property (nonatomic) CGRect frame;                  // pane frame in window coords
@end

// ---------------------------------------------------------------------------
// ABHost — SpringBoard-side registry + layout engine (shared singleton).
// Ivars (objc.json): _shieldOn, _window, _displayID, _panes, _knobViews,
// _carAppArea. 61 instance methods + shared. Methods implemented by module A
// (catalog/picker/launch/bar construction) are declared in the category at
// the bottom; module B implements the rest (ABHostBMethods.m).
// ---------------------------------------------------------------------------
@interface ABHost : NSObject
@property (nonatomic) BOOL shieldOn;
@property (nonatomic, strong, nullable) UIWindow *window;   // the car-display window
@property (nonatomic, copy, nullable) NSString *displayID;
@property (nonatomic, strong) NSMutableArray<ABPane *> *panes;
@property (nonatomic, strong) NSMutableArray *knobViews;
@property (nonatomic) CGRect carAppArea;

+ (instancetype)shared;
- (NSUInteger)count;
- (BOOL)hostsApp:(NSString *)bundleID;
- (nullable ABPane *)paneFor:(NSString *)bundleID;
- (nullable NSString *)bundleForHash:(uint64_t)hash; // FNV-1a-32 match over panes

// geometry / orientation (module B)
- (double)zoom; // clamp(pref appBridgeZoom / 100, 0.6, 1.0) — floor
// corrected in phase 2: the __const double at 0x2B210 is 0.6
// (bytes 33…E3 3F), not 0.3; see ABHostBMethods.m.
- (void)setFrame:(CGRect)frame forApp:(NSString *)app live:(BOOL)live
          handle:(BOOL)handle passInsets:(UIEdgeInsets)insets;
- (void)layoutPane:(ABPane *)pane;
- (void)nudgePane:(ABPane *)pane;
- (NSInteger)effectiveOrientation:(ABPane *)pane;
- (void)appWithHash:(uint64_t)hash changedOrientation:(NSInteger)orientation
    supportedMask:(NSUInteger)mask;
- (void)setHole:(CGRect)hole forApp:(NSString *)app;
- (void)setPassInsets:(UIEdgeInsets)insets forApp:(NSString *)app;

// shield / touch chrome (module B)
- (void)setShieldAll:(BOOL)on;
- (void)setShield:(BOOL)on forPane:(ABPane *)pane;
- (void)outsideTouched;
- (void)handlePanned:(UIPanGestureRecognizer *)gesture;
- (void)handleTapped:(UITapGestureRecognizer *)gesture;

// lifecycle (module B)
- (void)sceneMonitor:(id)monitor sceneWasDestroyed:(id)scene;
- (void)carDisconnected;
@end

// Module A surface (declared for cross-references; implemented by agent A):
@interface ABHost (ModuleA)
- (BOOL)ensureWindow;
- (void)dropWindowIfEmpty;
- (void)openApp:(NSString *)bundleID frame:(CGRect)frame;
- (void)revealPane:(ABPane *)pane;
- (void)setupLiveAppViewForPane:(ABPane *)pane;
- (nullable UIWindow *)carWindow;
- (CGRect)frameOfApp:(NSString *)bundleID;
- (UIView *)buildBarForPane:(ABPane *)pane;   // CLOSURE: return type from
        // objc.json (@24@0:8@16) + the 0x105B8 body's autoreleased return;
        // the earlier void typing was a transcription error
- (void)layoutBarForPane:(ABPane *)pane;
- (void)hideBarForPane:(ABPane *)pane;
- (void)setBarVisible:(BOOL)visible pop:(NSInteger)pop dim:(BOOL)dim
               single:(BOOL)single forApp:(NSString *)app;
- (void)setKnobs:(NSArray *)knobs;
- (void)setFront:(BOOL)front forApp:(NSString *)app;
- (void)setHandleOffset:(double)offset forApp:(NSString *)app;
- (void)setCornerRadius:(double)radius corners:(NSUInteger)corners forApp:(NSString *)app;
- (void)setHandleVisible:(BOOL)visible forPane:(ABPane *)pane;
- (void)setupHandleForPane:(ABPane *)pane;
- (void)raiseKnobs;
- (void)teardownPane:(ABPane *)pane;
- (void)closeApp:(NSString *)bundleID terminate:(BOOL)terminate;
- (void)closeAll;
- (void)closeAllExcept:(NSString *)bundleID;
- (void)postBarAction:(NSString *)action from:(id)sender;
- (nullable ABPane *)paneOfBarButton:(id)button;
// --- Integration union (phase 1; backported to src in phase 3): the five
// bar-action methods below are implemented by module A (ABHostLaunch.m)
// and were declared only in A's ABHost.h; added here so the merged header
// declares the full ABHost surface. See BUILD_PHASE1_LOG.md item 12.
- (void)barReplace:(id)sender;
- (void)barPop:(id)sender;
- (void)barFull:(id)sender;
- (void)barBackground:(id)sender;
- (void)barClose:(id)sender;
@end

NS_ASSUME_NONNULL_END

// --- Integration union (phase 1; backported to src in phase 3): C helpers
// implemented by module A in ABHostLaunch.m, declared only in A's ABHost.h.
void ABPostAppState(NSString *_Nonnull bundleID, NSString *_Nonnull state);
uint32_t ABBundleIDHash(NSString *_Nonnull bundleID);
