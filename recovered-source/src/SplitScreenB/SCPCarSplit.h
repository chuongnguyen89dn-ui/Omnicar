//  SCPCarSplit.h
//  OmniCar 1.0.3 — OmniCarSplitScreen.dylib (reconstructed)
//
//  SCPCarSplit is the split-screen controller object. Superclass NSObject
//  is the corrected value read from the raw class struct (wave-1 metadata
//  said UIViewController — a bind-name off-by-one in the scan tooling,
//  see SCPCommon.h); the controller owns a SCPCarSplitView container
//  instead of being a view controller. It conforms to the NSObject
//  protocol (hash/superclass/description/debugDescription appear in its
//  property list). 65 ivars, instance_size 464 — layout verified from
//  the binary's ivar list:
//
//    @8   B   _active                 @168 q   _layoutKind
//    @9   B   _trayOverlay            @176 NSDictionary _pending (NSMutable)
//    @10  B   _pickerSheetOverlay     @184 q   _allowBackground
//    @11  B   _pickerSheetQueued      @192 NSMutableArray _dividers
//    @12  B   _loggedArea             @200 d   _nextLaunchAt
//    @13  B   _ignoreHomeOnce         @208 NSString _soloHostedBundle (copy)
//    @14  B   _dismissStuckPending    @216 UIViewController _soloReturnedVC (weak)
//    @15  B   _resizing               @224 UIView _dragGhost
//    @16  B   _ratioOverlay           @232 UIView _ratioMenu
//    @17  B   _ratioHidesBridge       @240 UIView _ratioKnob (weak)
//    @18  B   _floatClosing           @248 NSTimer _ratioTimer
//    @19  B   _floatLarge             @256 SCPCarPane _floatPane
//    @20  B   _shieldPosted           @264 NSArray _floatReturnFractions (copy)
//    @21  B   _trayHidesBridge        @272 UIView _tray
//    @22  B   _suppressReopen         @280 UIView _popupShield
//    @23  B   _dockTreeLogged         @288 d   _popupsClosedAt
//    @24  B   _launcherBare           @296 NSTimer _trayTimer
//    @25  B   _autoLaunchDone         @304 NSString _layoutApp (copy)
//    @28  i   _focusedSlot            @312 NSArray _panelChoices
//    @32  i   _dragTarget             @320 UIButton _homeButton
//    @36  i   _floatReturnLayout      @328 UIView _launcherHost (weak)
//    @40  i   _floatReturnSlot        @336 NSString _launcherWhere (copy)
//    @48  NSMutableDictionary _cancelledLaunches
//    @56  UIView _soloCover           @344 UIColor _homeInk
//    @64  UIView _trayCover           @352 d   _lastLauncherCalc
//    @72  UIWindow _trayWindow        @360 d   _lastIconScan
//    @80  NSNumber _zoomedSlot        @368 CGRect _soloHostedFrame
//    @88  NSString _lastBridgeTapBundle (copy)
//    @96  d   _lastBridgeTapAt        @400 CGRect _floatFrame
//    @104 UIView _pickerSheet         @432 CGRect _homeGlyph
//    @112 UIView _pickerShield
//    @120 SCPCarPane _pickerSheetPane (weak)
//    @128 NSString _pickerSheetKey (copy)
//    @136 UIView _pickerDots (weak)
//    @144 SCPCarSplitView _container
//    @152 NSMutableArray _slots
//    @160 NSMutableArray _fractions
//
//  Method ownership: this header declares module B's categories in full.
//  Methods implemented by module A (scene hosting / session / hooks) that
//  module B calls are declared in the "Module A cross-reference" section
//  at the bottom, marked as such; their bodies are NOT in this module.

#import <UIKit/UIKit.h>
#import "SCPCarPane.h"
#import "SCPCarSplitView.h"
#import "SCPCarDividerView.h"

NS_ASSUME_NONNULL_BEGIN

@interface SCPCarSplit : NSObject

+ (instancetype)shared;

@property (nonatomic, assign) BOOL active;
@property (nonatomic, strong) NSMutableDictionary *cancelledLaunches;
@property (nonatomic, strong, nullable) UIView *soloCover;
@property (nonatomic, strong, nullable) UIView *trayCover;
@property (nonatomic, strong, nullable) UIWindow *trayWindow;
@property (nonatomic, assign) BOOL trayOverlay;
@property (nonatomic, strong, nullable) NSNumber *zoomedSlot;
@property (nonatomic, copy, nullable) NSString *lastBridgeTapBundle;
@property (nonatomic, assign) double lastBridgeTapAt;
@property (nonatomic, strong, nullable) UIView *pickerSheet;
@property (nonatomic, strong, nullable) UIView *pickerShield;
@property (nonatomic, weak, nullable) SCPCarPane *pickerSheetPane;
@property (nonatomic, copy, nullable) NSString *pickerSheetKey;
@property (nonatomic, assign) BOOL pickerSheetOverlay;
@property (nonatomic, assign) BOOL pickerSheetQueued;
@property (nonatomic, weak, nullable) UIView *pickerDots;
@property (nonatomic, strong, nullable) SCPCarSplitView *container;
@property (nonatomic, strong) NSMutableArray<SCPCarPane *> *slots;
@property (nonatomic, strong) NSMutableArray<NSNumber *> *fractions;
@property (nonatomic, assign) NSInteger layoutKind;
@property (nonatomic, strong) NSMutableDictionary *pending;
@property (nonatomic, assign) int focusedSlot;
@property (nonatomic, assign) NSInteger allowBackground;
@property (nonatomic, strong) NSMutableArray<SCPCarDividerView *> *dividers;
@property (nonatomic, assign) BOOL loggedArea;
@property (nonatomic, assign) double nextLaunchAt;
@property (nonatomic, copy, nullable) NSString *soloHostedBundle;
@property (nonatomic, assign) CGRect soloHostedFrame;
@property (nonatomic, assign) BOOL ignoreHomeOnce;
@property (nonatomic, weak, nullable) UIViewController *soloReturnedVC;
@property (nonatomic, assign) BOOL dismissStuckPending;
@property (nonatomic, assign) BOOL resizing;
@property (nonatomic, strong, nullable) UIView *dragGhost;
@property (nonatomic, assign) int dragTarget;
@property (nonatomic, strong, nullable) UIView *ratioMenu;
@property (nonatomic, weak, nullable) UIView *ratioKnob;
@property (nonatomic, strong, nullable) NSTimer *ratioTimer;
@property (nonatomic, assign) BOOL ratioOverlay;
@property (nonatomic, assign) BOOL ratioHidesBridge;
@property (nonatomic, strong, nullable) SCPCarPane *floatPane;
@property (nonatomic, assign) CGRect floatFrame;
@property (nonatomic, assign) BOOL floatClosing;
@property (nonatomic, assign) BOOL floatLarge;
@property (nonatomic, assign) int floatReturnLayout;
@property (nonatomic, assign) int floatReturnSlot;
@property (nonatomic, copy, nullable) NSArray *floatReturnFractions;
@property (nonatomic, strong, nullable) UIView *tray;
@property (nonatomic, strong, nullable) UIView *popupShield;
@property (nonatomic, assign) BOOL shieldPosted;
@property (nonatomic, assign) double popupsClosedAt;
@property (nonatomic, assign) BOOL trayHidesBridge;
@property (nonatomic, strong, nullable) NSTimer *trayTimer;
@property (nonatomic, copy, nullable) NSString *layoutApp;
@property (nonatomic, strong, nullable) NSArray *panelChoices;
@property (nonatomic, assign) BOOL suppressReopen;
@property (nonatomic, strong, nullable) UIButton *homeButton;
@property (nonatomic, weak, nullable) UIView *launcherHost;
@property (nonatomic, assign) BOOL dockTreeLogged;
@property (nonatomic, copy, nullable) NSString *launcherWhere;
@property (nonatomic, strong, nullable) UIColor *homeInk;
@property (nonatomic, assign) CGRect homeGlyph;
@property (nonatomic, assign) BOOL launcherBare;
@property (nonatomic, assign) double lastLauncherCalc;
@property (nonatomic, assign) double lastIconScan;
@property (nonatomic, assign) BOOL autoLaunchDone;

/// Number of split panes (1, 2 or 3 in practice). Computed method, not a
/// stored property (no ivar in the binary).
- (NSInteger)paneCount;

@end

// ---------------------------------------------------------------------------
// Module B — Layout (SCPCarSplit+Layout.m)
// ---------------------------------------------------------------------------
@interface SCPCarSplit (Layout)

/// YES when the effective split area is portrait (height > width > 1).
- (BOOL)vertical;
/// YES for the 3-pane "main + stack" layouts (layoutKind 1 or 2).
- (BOOL)mainStack;
/// YES for layoutKind 2 (main pane mirrored to the trailing side).
- (BOOL)mainRight;
/// 31 for mainRight, 13 for mainStack, otherwise the pane count.
- (NSInteger)layoutID;
/// Whether divider `index` is drawn horizontally.
- (BOOL)dividerRunsHorizontally:(NSInteger)index;
/// The split fraction for position `index`, with equal-split fallback.
- (double)fractionAt:(NSInteger)index;
/// Frame of slot `slot` inside the container (slot 9 = float pane).
- (CGRect)frameForSlot:(NSInteger)slot;
- (CGRect)mainStackFrameForSlot:(NSInteger)slot inArea:(CGRect)area;
- (CGRect)leftMainStackFrameForSlot:(NSInteger)slot inArea:(CGRect)area;
- (void)resetFractions;
- (void)normalizeFractions;
- (void)relayoutAnimated:(BOOL)animated;
- (void)relayoutAnimated:(BOOL)animated pushScenes:(BOOL)pushScenes;
- (void)rootDidLayout;
- (CGRect)appAreaInParent:(UIView *)parent;
- (NSUInteger)innerCornersForSlot:(NSInteger)slot;
- (NSUInteger)neighbourCornersForSlot:(NSInteger)slot;
- (BOOL)dividersVisible;
- (CGRect)dividerFrameAt:(NSInteger)index;
- (void)rebuildDividers;
- (SCPCarDividerView *)newDividerAt:(NSInteger)index;
- (void)layoutKnobOf:(SCPCarDividerView *)divider;
- (void)setPaneCount:(NSInteger)count;
- (void)switchToLayout:(NSInteger)layout;
- (void)layoutChosenID:(NSInteger)layoutID;
- (void)openSetupLayout:(NSInteger)layout apps:(NSArray *)apps;
- (CGSize)paneSize:(NSInteger)slot forBundle:(NSString *)bundleID;
- (void)swapSlot:(NSInteger)a with:(NSInteger)b;

@end

// ---------------------------------------------------------------------------
// Module B — Zoom / solo / float (SCPCarSplit+Zoom.m)
// ---------------------------------------------------------------------------
@interface SCPCarSplit (Zoom)

- (void)toggleZoomForPane:(SCPCarPane *)pane;
- (void)handleDoubleTapped:(UIGestureRecognizer *)recognizer;
- (void)handleTapped:(UIGestureRecognizer *)recognizer;
- (void)urlLayout:(NSInteger)layoutID;
- (void)urlRatio:(double)ratio;
- (void)urlSwap;
- (void)urlZoomPane:(int)n;
- (void)soloBundle:(NSString *)bundleID;  // corrected to the binary ABI (IMP 0x1e33c: void, NSString* bundle ID) — final closure
- (void)paneSolo:(UIView *)view; // remediation (A): button-action entry point takes the tapped VIEW (IMP 0x287b8)
- (void)runSoloForPane:(SCPCarPane *)pane;
- (void)showSoloCoverForBundle:(NSString *)bundleID;
- (void)hideSoloCover;
- (void)hostSolo:(BOOL)solo;
- (void)endHostedSolo;
- (void)setFullscreenBridgeHidden:(BOOL)hidden bundle:(NSString *)bundleID;
- (nullable NSString *)fullscreenAppBundle;
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

// ---------------------------------------------------------------------------
// Module B — Divider interaction (SCPCarSplit+Divider.m)
// ---------------------------------------------------------------------------
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
// methods in 1.0.3 (ObjC method list: dividerDoubleTapped: @0x2e6e8,
// dividerDoubleTapOn: @0x2e73c, dividerTapped: @0x2eb64,
// dividerTapOn:at: @0x2ebf0), implemented in SCPCarSplit+Divider.m and
// referenced via @selector in SCPCarSplit+Layout.m. They were removed
// in the micro-closure round under a premise the binary refutes (see
// src/SplitScreenA/SplitScreenA_REPORT.md micro-closure addendum,
// item 3); restored here well-formed, signatures taken from the
// implementations.
- (void)dividerDoubleTapped:(UITapGestureRecognizer *)gr;
- (void)dividerDoubleTapOn:(SCPCarDividerView *)divider;
- (void)dividerTapped:(UITapGestureRecognizer *)gr;
- (void)dividerTapOn:(SCPCarDividerView *)divider at:(CGPoint)point;
- (void)saveRatio;
- (NSArray *)ratioPresets;
- (BOOL)fractionsMatch:(NSArray *)fractions;
- (void)remoteKnobTouch:(NSDictionary *)info;
- (void)showRatioMenuForDivider:(SCPCarDividerView *)divider;
- (void)hideRatioMenu;
- (void)ratioPresetTapped:(UIButton *)button;

@end

// ---------------------------------------------------------------------------
// Module B — Pane drag (SCPCarSplit+Drag.m)
// ---------------------------------------------------------------------------
@interface SCPCarSplit (Drag)

- (void)handlePanned:(UIPanGestureRecognizer *)recognizer;
- (void)beginPaneDrag:(SCPCarPane *)pane at:(CGPoint)point;
- (void)movePaneDragTo:(CGPoint)point from:(CGPoint)from;
- (void)endPaneDrag:(CGPoint)point;
- (void)clearPaneDragMarks;
- (void)cancelPaneDrag;
- (void)bridgeHandleDrag:(NSDictionary *)info;

@end

// ---------------------------------------------------------------------------
// Module B — Chrome: bars, panels, shield, publishing (SCPCarSplit+Chrome.m)
// ---------------------------------------------------------------------------
@interface SCPCarSplit (Chrome)

- (void)setupBarForPane:(SCPCarPane *)pane;
- (void)layoutBarForPane:(SCPCarPane *)pane;
- (void)setBarVisible:(BOOL)visible forPane:(SCPCarPane *)pane;
- (void)handleShiftForPane:(SCPCarPane *)pane;
- (void)hideBarsForTouchOn:(UIView *)view;
- (void)bridgeOutsideTouched;
- (BOOL)anyBarVisible;
- (NSDictionary *)hostBarInfoForPane:(SCPCarPane *)pane;
- (void)bridgeHandleTapped:(NSString *)bundle; // remediation (A): bundle string in the binary (IMP 0x3f65c), not a dictionary
- (void)bridgeBarAction:(NSString *)action forBundle:(NSString *)bundleID;
- (void)publishKnobsSoon;
- (void)publishKnobsNow;
- (CGRect)holeForPane:(SCPCarPane *)pane;
- (UIEdgeInsets)hostPassInsetsForPane:(SCPCarPane *)pane;
- (NSArray *)shieldExemptRects;
- (BOOL)shieldExemptPoint:(CGPoint)point;
- (void)refreshShieldHoles;
- (void)updatePopupShield;
- (void)publishShield;
- (BOOL)popupOpen;
- (void)closePopups;
- (BOOL)panelOpen;
- (void)showLayoutPanelForApp:(NSString *)bundleID;
// CLOSURE CORRECTION: the second argument is an OUT-POINTER receiving
// the section-kinds array (the binary never reads it as a string).
- (NSArray *)panelSections:(NSString * _Nullable * _Nullable)titlesOut;
- (void)panelChoiceTapped:(UIButton *)button;
- (void)panelChoiceTappedUnsafe:(UIButton *)button;

@end

// ---------------------------------------------------------------------------
// Module A cross-reference — implemented by module A (scene hosting /
// session / IPC), declared here only because module B calls them.
// Bodies are NOT part of module B's deliverable.
// ---------------------------------------------------------------------------
@interface SCPCarSplit (ModuleACrossReference)

- (nullable SCPCarPane *)paneAtSlot:(NSInteger)slot;
- (nullable SCPCarPane *)paneForView:(UIView *)view;
- (nullable SCPCarPane *)paneForBundle:(NSString *)bundleID;
- (nullable UIView *)tabParent;
- (void)pushSceneSizes;
- (void)pushHostFramesLive:(BOOL)live;
- (void)refreshPickerSheetSoon;

@end

NS_ASSUME_NONNULL_END
