// OMCCardPage.h — reconstructed interface.
// Evidence: metadata objc dump (superclass PSViewController, protocols
// UITableViewDataSource/Delegate, ivar _table) + disasm/OMCCardPage.asm.
#import <UIKit/UIKit.h>
#import <Preferences/PSViewController.h>

@class PSSpecifier;

@interface OMCCardPage : PSViewController <UITableViewDataSource, UITableViewDelegate> {
    UITableView *_table;
}
@property (nonatomic, strong) UITableView *table;

// Preference access (domain com.anlai.omnicar) — all [VERIFIED]
- (id)prefForKey:(NSString *)key def:(id)def;
- (NSInteger)intForKey:(NSString *)key def:(NSInteger)def;
- (void)storeValue:(id)value forKey:(NSString *)key; // set + sync + notify_post

// Hooks for subclasses (empty in the base class) [VERIFIED: no calls in base]
- (void)prefChanged:(NSString *)key;
- (void)prefChanging:(NSString *)key;

// Cell/control factory (controls carry their key in an associated object)
- (UITableViewCell *)cellWithId:(NSString *)identifier;
- (UIView *)boxInCell:(UITableViewCell *)cell;
- (void)setAccessory:(UIView *)view onCell:(UITableViewCell *)cell;
- (UISwitch *)switchForKey:(NSString *)key def:(BOOL)def;
- (void)omcSwitchChanged:(UISwitch *)sender;
- (UISegmentedControl *)segmentForKey:(NSString *)key titles:(NSArray<NSString *> *)titles def:(NSInteger)def;
- (void)omcSegmentChanged:(UISegmentedControl *)sender;
- (UIView *)sliderForKey:(NSString *)key min:(NSInteger)min max:(NSInteger)max def:(NSInteger)def format:(NSString *)format width:(double)width;
- (void)omcSliderMoved:(UISlider *)sender;
- (void)omcSliderDone:(UISlider *)sender;
- (void)toast:(NSString *)message;
- (void)reloadSection:(NSInteger)section;
@end
