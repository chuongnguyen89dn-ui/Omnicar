// ABHost.h — ABHost/ABPane surfaces as recovered from objc metadata +
// disassembly. Superclasses below use the CORRECTED bind mapping
// (wave-1 metadata printed them shifted by one import):
//   ABHost : NSObject, ABPane : NSObject, ABBoxView : UIView,
//   ABShieldView : UIView, ABKnobView : UIView, ABBarButton : UIButton.
//
// Ownership (partition, see AppBridgeA_REPORT.md §1):
//   [A] = reconstructed by AppBridge agent A in this folder.
//   [B] = AppBridge agent B (scene hosting internals, bar/handle/knob
//         construction, layout). Declared here ONLY so A's code can call
//         them; no bodies are provided by A.

#import <UIKit/UIKit.h>

@class ABPane;

@interface ABPane : NSObject
@property (nonatomic, copy) NSString *bundleID;          // 0xa180
@property (nonatomic, strong) UIView *box;               // ABBoxView (B type)
@property (nonatomic, strong) id application;            // SBApplication
@property (nonatomic, strong) id appViewController;      // SBAppViewController [B]
@property (nonatomic, strong) id sceneMonitor;           // [B]
@property (nonatomic) long long orientation;
@property (nonatomic) long long requestedOrientation;
@property (nonatomic) CGRect frame;
@property (nonatomic) CGSize sceneBox;
@property (nonatomic) BOOL ready;
@property (nonatomic, strong) UIView *handle;            // [B]
@property (nonatomic, strong) UIView *handleHit;         // [B]
@property (nonatomic, strong) UIView *bar;               // [B]
@property (nonatomic, strong) UIButton *popButton;       // [B]
@property (nonatomic, strong) UIButton *soloButton;      // [B]
@property (nonatomic) double handleOffset;
@property (nonatomic, strong) UIView *shield;            // ABShieldView [B]
@end

@interface ABHost : NSObject
@property (nonatomic, strong) UIWindow *window;
@property (nonatomic, copy) NSString *displayID;
@property (nonatomic, strong) NSMutableArray<ABPane *> *panes;
@property (nonatomic, strong) NSMutableArray *knobViews; // [B]
@property (nonatomic) CGRect carAppArea;
@property (nonatomic) BOOL shieldOn;

+ (instancetype)shared;                                    // [A] 0xa9e8

// --- A: registry / routing ---------------------------------------------
- (NSUInteger)count;                                       // [A] 0xaaa0
- (BOOL)hostsApp:(NSString *)bundleID;                     // [A] 0xaaf0
- (ABPane *)paneFor:(NSString *)bundleID;                  // [A] 0xac84
- (double)zoom;                                            // [A] 0xae20
- (NSString *)bundleForHash:(unsigned long long)hash;      // [A] 0xf40c
- (CGRect)frameOfApp:(NSString *)bundleID;                 // [A] 0xf5ec
- (void)appWithHash:(unsigned long long)hash
    changedOrientation:(int)orientation
       supportedMask:(unsigned long long)mask;             // [A] 0xf6b0

// --- A: launch / close ---------------------------------------------------
- (void)openApp:(NSString *)bundleID frame:(CGRect)frame;  // [A] 0xb8a0
- (void)closeApp:(NSString *)bundleID terminate:(BOOL)terminate; // [A] 0x15ca0
- (void)closeAll;                                          // [A] 0x160ec
- (void)closeAllExcept:(NSString *)bundleID;               // [A] 0x160f4
- (void)carDisconnected;                                   // [A] 0x163e8

// --- A: bar actions (posted to the car-side controller) ------------------
- (void)postBarAction:(NSString *)action from:(id)sender;  // [A] 0x13148
- (void)barReplace:(id)sender;                             // [A] 0x13378 -> @"replace"
- (void)barPop:(id)sender;                                 // [A] 0x13388 -> @"pop"
- (void)barFull:(id)sender;                                // [A] 0x13398 -> @"full"
- (void)barBackground:(id)sender;                          // [A] 0x133a8 -> @"bg"
- (void)barClose:(id)sender;                               // [A] 0x133b8 -> @"close"

// --- A: command appliers invoked by the channel handlers -----------------
- (void)setFrame:(CGRect)frame forApp:(NSString *)bundleID
            live:(BOOL)live handle:(BOOL)handle
     passInsets:(UIEdgeInsets)insets;                      // 0xfe68 [B body, A calls]
- (void)setPassInsets:(UIEdgeInsets)insets forApp:(NSString *)bundleID; // 0x1038c
- (void)setCornerRadius:(double)r corners:(unsigned long long)corners
                 forApp:(NSString *)bundleID;              // 0x10438
- (void)setBarVisible:(BOOL)visible pop:(int)pop dim:(BOOL)dim
               single:(BOOL)single forApp:(NSString *)bundleID; // 0x11868
- (void)setHole:(CGRect)hole forApp:(NSString *)bundleID;  // 0x12ce4
- (void)setHandleOffset:(double)offset forApp:(NSString *)bundleID; // 0x14c7c
- (void)setFront:(BOOL)front forApp:(NSString *)bundleID;  // 0x151a8
- (void)setShieldAll:(BOOL)on;                             // 0x128a4
- (void)setKnobs:(NSArray *)knobs;                         // 0x13abc

// --- B: hosting internals (declarations only) -----------------------------
- (BOOL)ensureWindow;                                      // [B] 0xaea8
- (void)dropWindowIfEmpty;                                 // [B] 0xb89c
- (void)setupLiveAppViewForPane:(ABPane *)pane;            // [B] 0xc2bc
- (void)layoutPane:(ABPane *)pane;                         // [B] 0xec80
- (void)revealPane:(ABPane *)pane;                         // [B] 0xc178
- (void)teardownPane:(ABPane *)pane;                       // [B] 0x155b0
- (void)setupHandleForPane:(ABPane *)pane;                 // [B] 0x133c8
- (void)raiseKnobs;                                        // [B] 0x13918
- (void)setShield:(BOOL)on forPane:(ABPane *)pane;         // [B] 0x129d8
- (long long)effectiveOrientation:(ABPane *)pane;          // [B] 0xf364
- (ABPane *)paneOfBarButton:(id)button;                    // [B] 0x12f78
- (UIWindow *)carWindow;                                   // [B] 0xf3d0
@end

/// ABPostAppState(bundleID, state) — sub_bed4 @ 0xbed4 [A]:
/// posts NSDistributedNotificationCenter "com.anlai.omnicar/appbridge.state",
/// object nil, userInfo {identifier: bundleID, state: state}.
void ABPostAppState(NSString *bundleID, NSString *state);

/// ABBundleIDHash(bundleID) — FNV-1a 32-bit over the UTF-8 bytes
/// (offset basis 0x811C9DC5, prime 0x01000193). VERIFIED @ 0xf40c/0xf6b0.
uint32_t ABBundleIDHash(NSString *bundleID);
