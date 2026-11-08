// SCPCarSplit.h — OmniCarSplitScreen [CANONICAL merged header (phase 3): A's main interface
// (65 properties) + B's fine-grained categories, pruned of duplicates/conflicts;
// closure-corrected signatures (hostFrameInfo:/hostPassInsetsForPane:) kept from A]
// Original A header — OmniCarSplitScreen (agent A)
// The split-screen session controller (singleton via +shared). CALIBRATION
// CORRECTION (coordinator xref, LC_DYSYMTAB, delta=1): its superclass is
// NSObject, NOT UIViewController as wave-1 metadata claimed — the class is
// a plain coordinator object; view-controller containment is performed by
// the dashboard's root view controller (see adopt:slot:). All 65
// ivars/properties below are copied from the original objc metadata
// (offsets in the report). Methods are split by the wave-2
// partition: the main interface is agent A's domain (scene hosting, session
// lifecycle, pane/scene assignment, activation, disconnect cleanup); the
// category at the bottom is agent B's domain (geometry/zoom/divider/picker/
// tray UI) — declared here because A's code calls them, implemented in
// agent B's sources.

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "SCPCarPane.h"
#import "SCPCarSplitView.h" // [phase2; backported to src in phase 3] merge] B header imports (concrete types for categories)
#import "SCPCarDividerView.h"

NS_ASSUME_NONNULL_BEGIN

@class SCPCarSplitView;

@interface SCPCarSplit : NSObject <UIScrollViewDelegate> // [phase2; backported to src in phase 3]] delegate conformance: B TUs assign scroll.delegate = self (Panel/Picker)

// --- properties (verbatim from original metadata) -------------------------
@property (nonatomic) BOOL active;
@property (nonatomic, strong) NSMutableDictionary *cancelledLaunches; // bundleID -> NSDate of user cancel
@property (nonatomic, strong, nullable) UIView *soloCover;
@property (nonatomic, strong, nullable) UIView *trayCover;
@property (nonatomic, strong, nullable) UIWindow *trayWindow;
@property (nonatomic) BOOL trayOverlay;
@property (nonatomic, strong, nullable) NSNumber *zoomedSlot;
@property (nonatomic, copy, nullable) NSString *lastBridgeTapBundle;
@property (nonatomic) NSTimeInterval lastBridgeTapAt;
@property (nonatomic, strong, nullable) UIView *pickerSheet;
@property (nonatomic, strong, nullable) UIView *pickerShield;
@property (nonatomic, weak, nullable) SCPCarPane *pickerSheetPane;
@property (nonatomic, copy, nullable) NSString *pickerSheetKey;
@property (nonatomic) BOOL pickerSheetOverlay;
@property (nonatomic) BOOL pickerSheetQueued;
@property (nonatomic, weak, nullable) UIView *pickerDots;
@property (nonatomic, strong, nullable) SCPCarSplitView *container;
@property (nonatomic, strong) NSMutableArray<SCPCarPane *> *slots;    // the panes, index == slot (float pane excluded)
@property (nonatomic, strong) NSMutableArray<NSNumber *> *fractions;  // width fractions per slot
@property (nonatomic) NSInteger layoutKind;
@property (nonatomic, strong) NSMutableDictionary *pending;           // bundleID -> @[ @(slot), NSDate ]
@property (nonatomic) int focusedSlot;
@property (nonatomic) NSInteger allowBackground;  // counter (type q VERIFIED): >0 while a deliberate backgroundScene call is in flight
@property (nonatomic, strong) NSMutableArray<SCPCarDividerView *> *dividers; // [phase2; backported to src in phase 3] merge] element type from B header (ivar @192)
@property (nonatomic) BOOL loggedArea;
@property (nonatomic) NSTimeInterval nextLaunchAt;  // launch throttle clock
@property (nonatomic, copy, nullable) NSString *soloHostedBundle;
@property (nonatomic) CGRect soloHostedFrame;
@property (nonatomic) BOOL ignoreHomeOnce;
@property (nonatomic, weak, nullable) UIViewController *soloReturnedVC;
@property (nonatomic) BOOL dismissStuckPending;
@property (nonatomic) BOOL resizing;
@property (nonatomic, strong, nullable) UIView *dragGhost;
@property (nonatomic) int dragTarget;
@property (nonatomic, strong, nullable) UIView *ratioMenu;
@property (nonatomic, weak, nullable) UIView *ratioKnob;
@property (nonatomic, strong, nullable) NSTimer *ratioTimer;
@property (nonatomic) BOOL ratioOverlay;
@property (nonatomic) BOOL ratioHidesBridge;
@property (nonatomic, strong, nullable) SCPCarPane *floatPane;
@property (nonatomic) CGRect floatFrame;
@property (nonatomic) BOOL floatClosing;
@property (nonatomic) BOOL floatLarge;
@property (nonatomic) int floatReturnLayout;
@property (nonatomic) int floatReturnSlot;
@property (nonatomic, copy, nullable) NSArray *floatReturnFractions;
@property (nonatomic, strong, nullable) UIView *tray;
@property (nonatomic, strong, nullable) UIView *popupShield;
@property (nonatomic) BOOL shieldPosted;
@property (nonatomic) NSTimeInterval popupsClosedAt;
@property (nonatomic) BOOL trayHidesBridge;
@property (nonatomic, strong, nullable) NSTimer *trayTimer;
@property (nonatomic, copy, nullable) NSString *layoutApp;
@property (nonatomic, strong, nullable) NSArray *panelChoices;
@property (nonatomic) BOOL suppressReopen;
@property (nonatomic, strong, nullable) UIButton *homeButton;
@property (nonatomic, weak, nullable) UIView *launcherHost;
@property (nonatomic) BOOL dockTreeLogged;
@property (nonatomic, copy, nullable) NSString *launcherWhere;
@property (nonatomic, strong, nullable) UIColor *homeInk;
@property (nonatomic) CGRect homeGlyph;
@property (nonatomic) BOOL launcherBare;
@property (nonatomic) NSTimeInterval lastLauncherCalc;
@property (nonatomic) NSTimeInterval lastIconScan;
@property (nonatomic) BOOL autoLaunchDone;

// --- singleton / lifecycle (A) ---------------------------------------------
+ (instancetype)shared;
- (BOOL)activate;                                   // activateWithCount:2
- (BOOL)activateWithCount:(NSInteger)count;
- (BOOL)activateWithLayout:(NSInteger)layout;
- (void)carScreenAppeared;                          // car display up: posts splitscreen.ready, maybe auto-launch
- (void)rootDidLayout;                              // root VC laid out: track app-area changes
- (void)baseViewControllerPresented;                // a fullscreen base VC was presented over the split
- (void)dashboardInvalidated;                       // DBDashboard -invalidate: full session teardown
- (BOOL)ensureContainer;                            // create/attach the SCPCarSplitView in the dashboard

// --- pane bookkeeping (A) ----------------------------------------------------
- (NSArray<SCPCarPane *> *)allPanes;                // slots + floatPane
- (nullable SCPCarPane *)paneAtSlot:(NSInteger)slot;
- (BOOL)validSlot:(NSInteger)slot;                  // 0 <= slot < paneCount, or slot == 9 (float)
- (nullable SCPCarPane *)paneForBundle:(NSString *)bundleID;
- (nullable SCPCarPane *)paneForView:(UIView *)view;
- (NSInteger)pendingSlotForBundle:(NSString *)bundleID;  // -1/none when absent or older than 12 s
- (BOOL)slotOccupied:(NSInteger)slot;
- (NSInteger)paneCount;
- (NSInteger)autoSlot;                              // first free slot (9 = float when full)
- (void)purgePending;                               // drop pending entries older than 12 s
- (void)markDismissSlot:(NSInteger)slot;
- (SCPCarPane *)newPane;
- (SCPCarPane *)insertPaneAt:(NSInteger)slot; // [phase2; backported to src in phase 3] binary type @20@0:8i16 — returns the inserted pane (A had void)
- (void)reindexPanes;
- (void)setPaneCount:(NSInteger)count;
- (void)removePaneAt:(NSInteger)slot background:(BOOL)background;
- (void)closeSlot:(NSInteger)slot background:(BOOL)background;
- (void)afterPaneRemoved:(NSString *)bundle; // remediation: binary type v24@0:8@16 — the removed pane's bundle ID; the callee USES it (IMP 0x1db48, rem_afterPaneRemoved.txt). An earlier note claiming the callee ignores it was wrong.
- (void)swapSlot:(NSInteger)a with:(NSInteger)b;
- (void)switchToLayout:(NSInteger)layout;
- (NSInteger)layoutID;
- (void)layoutChosenID:(NSInteger)layout; // remediation: VOID in the binary (IMP 0x3c61c); A's earlier BOOL declaration was fabricated

// --- app identity (A) --------------------------------------------------------
- (BOOL)isCarPlayApp:(NSString *)bundleID;
- (NSString *)displayNameFor:(NSString *)bundleID;

// --- launch flow (A) ---------------------------------------------------------
- (void)openApp:(NSString *)bundleID slot:(NSInteger)slot;
- (void)sendLaunch:(id)launchInfo bundle:(NSString *)bundleID tries:(NSInteger)tries;
- (void)recoverPending:(NSString *)bundleID attempt:(NSInteger)attempt;
- (void)launchFailed:(NSString *)bundleID slot:(NSInteger)slot;
- (void)killAppSoon:(NSString *)bundleID;
- (void)openPairLeft:(nullable NSString *)left right:(nullable NSString *)right;
- (void)openAppsInOrder:(NSArray *)apps;           // NSString bundle IDs or NSNull for picker slots
- (void)openSetupLayout:(NSInteger)layout apps:(NSArray *)apps;
- (void)openFavorite:(NSInteger)index;
- (nullable NSArray *)favoriteApps:(NSDictionary *)fav;  // takes the +[SCPPrefs favorite:] DICTIONARY (IMP 0x3a86c — final closure)
- (void)rememberRecent;
- (void)rememberPair;
- (void)openRememberedPair;
- (void)openRememberedPairForConnect;               // reconnect/restore path
- (void)autoLaunchAttempt:(int)attempt;
- (BOOL)launchPhoneAppIfNeeded:(id)launchInfo;      // YES = consumed by AppBridge

// --- scene adoption / VC lifecycle (A) ---------------------------------------
- (BOOL)wantsViewController:(UIViewController *)vc;
- (BOOL)isAdoptableViewController:(UIViewController *)vc;
- (void)adoptViewController:(UIViewController *)vc;
- (void)adopt:(UIViewController *)vc slot:(NSInteger)slot;
- (void)repairPresentedViewController:(UIViewController *)vc;
- (void)detachVC:(UIViewController *)vc background:(BOOL)background;
- (BOOL)protectsViewController:(UIViewController *)vc;
- (nullable id)sceneOfViewController:(UIViewController *)vc;
- (void)scene:(id)scene destroyedForViewController:(UIViewController *)vc ownScene:(nullable id)ownScene;
- (void)verifySceneOfPane:(SCPCarPane *)pane expected:(CGSize)expected retry:(NSInteger)retry;
- (CGSize)paneSize:(CGRect)frame forBundle:(NSString *)bundleID;

// --- hosted (AppBridge) panes (A) ---------------------------------------------
- (NSArray<SCPCarPane *> *)hostedPanes;
- (nullable SCPCarPane *)bridgedPane;
- (void)hostPost:(NSString *)name info:(nullable NSDictionary *)info;
- (CGRect)hostFrameForPane:(SCPCarPane *)pane;
- (NSDictionary *)hostBarInfoForPane:(SCPCarPane *)pane;
- (BOOL)anyBarVisible;
- (UIEdgeInsets)hostPassInsetsForPane:(SCPCarPane *)pane;  // UIEdgeInsets per IMP 0x3d1e4 (final closure; B's header was right)
- (NSDictionary *)hostFrameInfo:(CGRect)frame pane:(SCPCarPane *)pane live:(BOOL)live handle:(BOOL)handle;
- (CGRect)holeForPane:(SCPCarPane *)pane;
- (void)sendHostFrameForPane:(SCPCarPane *)pane live:(BOOL)live;
- (void)pushHostFramesLive:(BOOL)live;
- (void)pushSceneSizes;
- (void)hostApp:(NSString *)bundleID inPane:(SCPCarPane *)pane;
- (void)hostClose:(NSString *)bundleID terminate:(BOOL)terminate;
- (void)hostCloseAll;
- (void)hostedApp:(NSString *)bundleID state:(NSString *)state;
- (void)hostSolo:(NSString *)bundleID;
- (void)endHostedSolo;
- (void)soloBundle:(NSString *)bundleID;  // void + bundle-ID string per IMP 0x1e33c (final closure)
- (void)showSoloCoverForBundle:(NSString *)bundleID;
- (void)hideSoloCover;
- (void)setFullscreenBridgeHidden:(BOOL)hidden bundle:(NSString *)bundleID;
- (void)bridgeBarAction:(NSString *)action forBundle:(NSString *)bundleID;
- (void)bridgeHandleTapped:(NSString *)bundle; // remediation: bundle string in the binary (IMP 0x3f65c), not a dictionary
- (void)bridgeOutsideTouched;
- (void)bridgeHandleDrag:(NSDictionary *)info;

// --- close / home (A) ----------------------------------------------------------
- (void)closeApp:(NSString *)bundleID;
- (void)closeGoingHome:(BOOL)goHome;
- (BOOL)homePressedDuringSplit:(id)event;
- (void)dismissStuckBaseSoon;
// [phase2; backported to src in phase 3]] three SCPCarSplit methods present in the binary (objc.json) and
// called from B's Panel.m — transcribed from A's own disasm dumps in
// SCPCarSplit.m (phase-2 transcriptions, backported with them).
- (nullable NSString *)exitKeepBundle; // @0x3ae10
- (void)exitTapped; // @0x3b138
- (BOOL)atHomeScreen; // @0x404fc

// --- state publishing (A) -------------------------------------------------------
- (void)publishBusy;
- (void)publishCarPlayApps;
- (void)publishShield;
- (void)publishKnobsSoon;
- (void)publishKnobsNow;

// --- home button / dock / launcher (A takes the lifecycle side) -----------------
- (void)homeButtonTapped;
- (void)homeButtonTappedUnsafe;
- (void)refreshHomeButton;
- (void)removeHomeButton;
- (void)raise;
- (void)raiseView:(UIView *)view;
- (BOOL)viewIsRaised:(UIView *)view;
- (void)raiseLauncher;
- (CGRect)dockClusterInParent:(UIView *)parent; // remediation: returns CGRect in the binary (IMP 0x405fc); the UIView* declaration was wrong-ABI
- (CGPoint)launcherCenterInParent:(UIView *)parent size:(double *)size shift:(double *)shift; // remediation: out-pointers in the binary (IMP 0x409b0)
- (void)setDockShift:(CGFloat)shift;
- (nullable UIView *)dockHostForRect:(CGRect)rect inParent:(UIView *)parent;
- (void)installIconLongPress;
- (void)installLongPressIn:(UIView *)view depth:(NSInteger)depth;
- (void)iconLongPressed:(id)gesture;
- (void)iconLongPressedUnsafe:(id)gesture;
- (nullable UIView *)tabParent;
- (nullable NSString *)fullscreenAppBundle;

// --- pane menu actions that change lifecycle state (A) --------------------------
- (void)paneSolo:(UIView *)view; // remediation: button-action entry points take the tapped VIEW and resolve the pane via paneForView: (IMPs 0x287b8/0x28a30/0x2a0e0)
- (void)runSoloForPane:(SCPCarPane *)pane;
- (void)paneBackground:(UIView *)view;
- (void)runBackgroundForPane:(SCPCarPane *)pane;
- (void)paneClose:(UIView *)view;
- (void)runCloseForPane:(SCPCarPane *)pane;

@end

// --- Module B categories (merged from B's SCPCarSplit.h, pruned) -------------
// Merge rules applied: (1) a selector A implements keeps ONLY A's declaration
// (main interface above); B's duplicate or conflicting cross-reference was
// dropped — conflicts dropped: layoutChosenID: (B void vs A BOOL impl —
// remediation RESOLVED: the binary is void (IMP 0x3c61c), B was right and
// A's declaration + implementation above are now void),
// paneSize:forBundle: (B NSInteger-slot vs A CGRect-frame impl),
// soloBundle: (B SCPCarPane* vs A BOOL impl), hostSolo: (B BOOL vs A
// NSString* impl), hostPassInsetsForPane: (B UIEdgeInsets vs A NSDictionary*
// impl — discrepancy flagged in the phase-2 log, A's live body kept).
// (2) The four divider tap declarations (dividerDoubleTapped:,
// dividerDoubleTapOn:, dividerTapped:, dividerTapOn:at:) were REMOVED in
// phase 2 under a refuted premise; phase 3 RESTORED them well-formed in
// the (Divider) category below — they ARE real 1.0.3 methods
// (@0x2e6e8/@0x2e73c/@0x2eb64/@0x2ebf0, implemented in
// SCPCarSplit+Divider.m; see SplitScreenA_REPORT micro-closure addendum).

@interface SCPCarSplit (Layout)
- (BOOL)vertical;
- (BOOL)mainStack;
- (BOOL)mainRight;
- (BOOL)dividerRunsHorizontally:(NSInteger)index;
- (double)fractionAt:(NSInteger)index;
- (CGRect)frameForSlot:(NSInteger)slot;
- (CGRect)mainStackFrameForSlot:(NSInteger)slot inArea:(CGRect)area;
- (CGRect)leftMainStackFrameForSlot:(NSInteger)slot inArea:(CGRect)area;
- (void)resetFractions;
- (void)normalizeFractions;
- (void)relayoutAnimated:(BOOL)animated;
- (void)relayoutAnimated:(BOOL)animated pushScenes:(BOOL)pushScenes;
- (CGRect)appAreaInParent:(UIView *)parent;
- (NSUInteger)innerCornersForSlot:(NSInteger)slot;
- (NSUInteger)neighbourCornersForSlot:(NSInteger)slot;
- (BOOL)dividersVisible;
- (CGRect)dividerFrameAt:(NSInteger)index;
- (void)rebuildDividers;
- (SCPCarDividerView *)newDividerAt:(NSInteger)index;
- (void)layoutKnobOf:(SCPCarDividerView *)divider;
- (void)flashFocusOnPane:(SCPCarPane *)pane;
- (BOOL)slotIsPinned:(NSInteger)slot;
@end

@interface SCPCarSplit (Zoom)
- (void)toggleZoomForPane:(SCPCarPane *)pane;
- (void)handleDoubleTapped:(UIGestureRecognizer *)recognizer;
- (void)handleTapped:(UIGestureRecognizer *)recognizer;
- (void)urlLayout:(NSInteger)layoutID;
- (void)urlRatio:(double)ratio;
- (void)urlSwap;
- (void)urlZoomPane:(int)n;
- (SCPCarPane *)ensureFloatPane;
- (CGSize)floatSizeLarge:(BOOL)large;
- (void)floatHandleDoubleTapped:(UIGestureRecognizer *)recognizer;
- (void)toggleFloatSize;
- (void)fitFloatFrame;
- (void)closeFloat:(BOOL)background;
- (void)floatDockBack;
- (BOOL)canPopOutPane:(SCPCarPane *)pane;
- (nullable NSString *)popOutBlockReason:(SCPCarPane *)pane;
- (void)popOutPane:(SCPCarPane *)pane;
- (void)panePopOut:(UIGestureRecognizer *)recognizer;
- (void)floatPanned:(UIPanGestureRecognizer *)recognizer;
- (void)floatDragPhase:(NSInteger)phase at:(CGPoint)point;
@end

@interface SCPCarSplit (Divider)
- (void)beginResize;
- (void)endResize;
- (void)dividerPanned:(UIPanGestureRecognizer *)recognizer;
- (void)dividerPan:(SCPCarDividerView *)divider
              state:(NSInteger)state
           location:(CGPoint)location
        translation:(CGPoint)translation;
- (void)mainStackDividerPan:(SCPCarDividerView *)divider
                      state:(NSInteger)state
               location:(CGPoint)location
            translation:(CGPoint)translation
                  ended:(BOOL)ended;
// [phase3 restore] The four tap handlers below ARE real SCPCarSplit
// methods in 1.0.3 (dividerDoubleTapped: @0x2e6e8, dividerDoubleTapOn:
// @0x2e73c, dividerTapped: @0x2eb64, dividerTapOn:at: @0x2ebf0),
// implemented in SCPCarSplit+Divider.m; restored well-formed from the
// implementations (see src/SplitScreenB/SCPCarSplit.h and the
// SplitScreenA_REPORT micro-closure addendum, item 3).
- (void)dividerDoubleTapped:(UITapGestureRecognizer *)gr;
- (void)dividerDoubleTapOn:(SCPCarDividerView *)divider;
- (void)dividerTapped:(UITapGestureRecognizer *)gr;
- (void)dividerTapOn:(SCPCarDividerView *)divider at:(CGPoint)point;
- (void)saveRatio;
- (NSArray *)ratioPresets;
- (BOOL)fractionsMatch:(NSArray *)fractions;
- (void)remoteKnobTouch:(NSDictionary *)info;
@end

@interface SCPCarSplit (RatioMenu)
- (void)showRatioMenuForDivider:(SCPCarDividerView *)divider;
- (void)hideRatioMenu;
- (void)ratioPresetTapped:(UIButton *)button;
@end

@interface SCPCarSplit (Drag)
- (void)handlePanned:(UIPanGestureRecognizer *)recognizer;
- (void)beginPaneDrag:(SCPCarPane *)pane at:(CGPoint)point;
- (void)movePaneDragTo:(CGPoint)point from:(SCPCarPane *)pane; // [phase2] signature per Drag.m impl (B header had CGPoint — impl/binary wins)
- (void)endPaneDrag:(SCPCarPane *)pane; // [phase2] signature per Drag.m impl @0x27a30
- (void)clearPaneDragMarks;
- (void)cancelPaneDrag;
@end

@interface SCPCarSplit (Chrome)
- (void)setupBarForPane:(SCPCarPane *)pane;
- (void)layoutBarForPane:(SCPCarPane *)pane;
- (void)setBarVisible:(BOOL)visible forPane:(SCPCarPane *)pane;
- (double)handleShiftForPane:(SCPCarPane *)pane; // [phase2] returns double per Chrome.m impl @0x23ab4 (B header had void)
- (void)hideBarsForTouchOn:(UIView *)view;
- (NSArray *)shieldExemptRects;
- (BOOL)shieldExemptPoint:(CGPoint)point;
- (void)refreshShieldHoles;
- (void)updatePopupShield;
- (BOOL)popupOpen;
- (void)closePopups;
- (BOOL)panelOpen;
@end

@interface SCPCarSplit (Panel)
- (void)showLayoutPanelForApp:(NSString *)bundleID;
// CLOSURE CORRECTION (B): the second argument is an OUT-POINTER receiving
// the section-kinds array (the binary never reads it as a string).
- (NSArray *)panelSections:(NSArray * _Nullable * _Nullable)titlesOut; // [phase2] out-pointer to NSArray (binary ^@); B spelled NSString** loosely
- (void)panelChoiceTapped:(UIView *)sender; // [phase2] type per Panel.m impl (binary @ arg)
- (void)panelChoiceTappedUnsafe:(UIView *)sender; // [phase2] type per Panel.m impl
@end

@interface SCPCarSplit (Picker)
- (void)addCoverToPane:(SCPCarPane *)pane;
- (void)removeCoverFromPane:(SCPCarPane *)pane;
- (void)removePickerFromPane:(SCPCarPane *)pane;
- (void)showLoaderInPane:(SCPCarPane *)pane bundle:(NSString *)bundleID;
- (void)removeLoaderFromPane:(SCPCarPane *)pane animated:(BOOL)animated;
- (void)showPickerForSlot:(int)slot; // [phase2] int per Picker.m impl
- (void)showPickerForFocusedPane;
- (void)showPickersForEmptySlots;
- (void)buildPickerSheetForPane:(SCPCarPane *)pane;
- (void)refreshPickerSheet;
- (void)refreshPickerSheetSoon;
- (void)removePickerSheet;
- (void)collapseAppTray;
- (void)removeAppTab;
- (void)refreshAppTab;
- (void)refreshAppTabSoon;
- (void)toast:(NSString *)text;
- (void)toast:(NSString *)text duration:(double)duration;
- (void)showTipSoon;
- (void)showBackgroundToastFor:(NSString *)name slot:(int)slot; // [phase2] types per Picker.m impl
- (void)markPickerPanes;
- (void)pickerCancel:(UIView *)sender; // [phase2] type per Picker.m impl
- (void)restartTrayTimer; // [phase2] Picker.m impl @0x31e00, called from Panel.m
- (UIWindow *)trayWindowForParent:(UIView *)parent; // [phase2] Picker.m impl, called from Drag.m
- (void)hideTrayWindowIfIdle; // [phase2] Picker.m impl, called from Drag.m
@end

NS_ASSUME_NONNULL_END
