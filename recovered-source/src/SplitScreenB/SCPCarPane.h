//  SCPCarPane.h — [phase2 MERGED: B's copy kept; its 18-property set was
//  verified identical to A's (script compared), B's adds the ivar-offset
//  table. A's comments agreed on every property.]
//  SCPCarPane.h
//  OmniCar 1.0.3 — OmniCarSplitScreen.dylib
//
//  SCPCarPane is the per-slot pane record. The class is implemented by
//  module A (scene hosting); this header is the cross-module declaration
//  reconstructed from the binary's ivar/property tables so module B code
//  compiles against the exact same surface. Superclass NSObject is the
//  corrected value read from the raw class struct (wave-1 metadata said
//  UIViewController — a bind-name off-by-one in the scan tooling, see
//  SCPCommon.h).
//
//  Ivar layout (arm64, verified from __objc_ivar list):
//    @8   BOOL          _hostHandle
//    @9   BOOL          _hostBar
//    @12  int           _slot
//    @16  NSString     *_bundleID   (copy)
//    @24  UIViewController *_vc     (strong)
//    @32  UIView       *_view       (strong)
//    @40  UIView       *_host       (strong)
//    @48  UIView       *_handle     (strong)
//    @56  UIView       *_bar        (strong)
//    @64  UIView       *_cover      (strong)
//    @72  UIView       *_loader     (strong)
//    @80  UIButton     *_popButton  (strong)
//    @88  UIButton     *_soloButton (strong)
//    @96  NSTimer      *_barTimer   (strong)
//    @104 UIView       *_picker     (strong)
//    @112 CGSize        _sceneSize
//    @128 CGRect        _hostFrame
//    @160 CGRect        _hostHole

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SCPCarPane : NSObject

@property (nonatomic, assign) int slot;
@property (nonatomic, copy, nullable) NSString *bundleID;
@property (nonatomic, strong, nullable) UIViewController *vc;
@property (nonatomic, strong, nullable) UIView *view;
@property (nonatomic, strong, nullable) UIView *host;
@property (nonatomic, strong, nullable) UIView *handle;
@property (nonatomic, strong, nullable) UIView *bar;
@property (nonatomic, strong, nullable) UIView *cover;
@property (nonatomic, strong, nullable) UIView *loader;
@property (nonatomic, strong, nullable) UIButton *popButton;
@property (nonatomic, strong, nullable) UIButton *soloButton;
@property (nonatomic, strong, nullable) NSTimer *barTimer;
@property (nonatomic, strong, nullable) UIView *picker;
@property (nonatomic, assign) CGRect hostFrame;
@property (nonatomic, assign) BOOL hostHandle;
@property (nonatomic, assign) BOOL hostBar;
@property (nonatomic, assign) CGRect hostHole;
@property (nonatomic, assign) CGSize sceneSize;

@end

NS_ASSUME_NONNULL_END
