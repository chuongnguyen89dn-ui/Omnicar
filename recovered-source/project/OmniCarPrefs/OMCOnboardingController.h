// OMCOnboardingController.h — OmniCarPrefs reconstruction (Prefs-B)
// First-run guide: 4 pages (welcome / split screen / speed bubble /
// tips) in a paging scroll view with a page control, Skip and
// Next/Done buttons. Shown while the pref `onboardingDone` is false.
// Superclass: UIViewController (calibrated).
#import <UIKit/UIKit.h>

@interface OMCOnboardingController: UIViewController <UIScrollViewDelegate, UIAdaptivePresentationControllerDelegate>
@property (nonatomic, strong) UIScrollView *pager;
@property (nonatomic, strong) UIPageControl *dots;
@property (nonatomic, strong) UIButton *skipButton;
@property (nonatomic, strong) UIButton *nextButton;
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, assign) NSInteger pageCount;
@property (nonatomic, assign) double laidOutWidth;
@property (nonatomic, assign) BOOL closed;
@property (nonatomic, copy) void (^completion)(void);
+ (BOOL)shouldShow;
+ (UINavigationController *)guideNavigationControllerWithCompletion:(void (^)(void))completion;
- (void)finish;
- (void)markDone;
- (void)runCompletion;
@end
