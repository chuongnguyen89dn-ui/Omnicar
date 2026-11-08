// ABKeyboardDecl.h — [integration phase 1; backported to src in phase 3] ABKeyboard's @interface,
// copied VERBATIM from ABKeyboard.m (lines 63-84, where it remains,
// in-file). Repeated here so other AppBridge TUs that message the
// keyboard (ABHostGeometry.m) see the full interface instead of ABHost.h's
// @class forward. ABKeyboard.m itself does not import this header, so no
// TU sees a duplicate interface. NOTE: the interface declares only the
// public surface; ABKeyboard's private layout methods live in the class
// extension inside ABKeyboard.m (reconstructed in the phase-2 closure;
// the phase-1 BLOCKER-AB-KEYBOARD gap is closed).
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ABKeyboard : NSObject
@property (nonatomic, copy) NSString *app;
@property (nonatomic, strong) UIView *panel;
@property (nonatomic, strong) UIView *glass;
@property (nonatomic, strong) UILabel *bubble;
@property (nonatomic, strong) id field;
@property (nonatomic, strong) UILabel *preview;
@property (nonatomic, strong) NSArray *rows;
@property (nonatomic, strong) NSMutableString *word;
@property (nonatomic, strong) NSMutableString *typed;
@property (nonatomic) NSInteger returnType;
@property (nonatomic) BOOL numbers;
@property (nonatomic) BOOL shift;
@property (nonatomic) BOOL vietnamese;
@property (nonatomic, strong) UIButton *langButton;
@property (nonatomic, strong) UIButton *hideButton;
@property (nonatomic, strong) UIView *keysView;
+ (instancetype)shared;
- (void)showForApp:(NSString *)bundleID keyboardType:(NSInteger)keyboardType returnType:(NSInteger)returnType;
- (void)hideForApp:(NSString *)bundleID; // nil = force
- (void)send:(NSString *)action del:(NSUInteger)del text:(NSString *)text;
@end

NS_ASSUME_NONNULL_END
