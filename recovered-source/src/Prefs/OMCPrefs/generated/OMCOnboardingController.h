// OMCOnboardingController.h — reconstructed interface (evidence: metadata objc dump)
#import <UIKit/UIKit.h>
#import <Preferences/PSListController.h>
#import <Preferences/PSSpecifier.h>
#import <Preferences/PSTableCell.h>

@interface OMCOnboardingController : UIViewController <UIScrollViewDelegate, UIAdaptivePresentationControllerDelegate>
{
    B _closed;  // offset None
    @"UIScrollView" _pager;  // offset None
    @"UIPageControl" _dots;  // offset None
    @"UIButton" _skipButton;  // offset None
    @"UIButton" _nextButton;  // offset None
    q _page;  // offset None
    q _pageCount;  // offset None
    d _laidOutWidth;  // offset None
    @? _completion;  // offset None
}
@property (T@"UIScrollView",&,N,V_pager) id pager;
@property (T@"UIPageControl",&,N,V_dots) id dots;
@property (T@"UIButton",&,N,V_skipButton) id skipButton;
@property (T@"UIButton",&,N,V_nextButton) id nextButton;
@property (Tq,N,V_page) id page;
@property (Tq,N,V_pageCount) id pageCount;
@property (Td,N,V_laidOutWidth) id laidOutWidth;
@property (TB,N,V_closed) id closed;
@property (T@?,C,N,V_completion) id completion;
@property (TQ,R) id hash;
@property (T#,R) id superclass;
@property (T@"NSString",R,C) id description;
@property (T@"NSString",?,R,C) id debugDescription;
@end
