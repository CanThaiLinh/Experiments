#import <UIKit/UIKit.h>

@class ClipView;

@interface EXViewController : UIViewController <UIGestureRecognizerDelegate> {
}

@property(weak, nonatomic) IBOutlet ClipView *clipView;
@property(weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property(nonatomic, strong) NSMutableArray *cardViews;
@property(nonatomic) BOOL swiping;
@property(nonatomic) BOOL cardRevealed;
@end