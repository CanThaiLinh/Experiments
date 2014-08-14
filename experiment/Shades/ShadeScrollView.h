@class ShadeTableViewController;

@interface ShadeScrollView : UIScrollView <UIGestureRecognizerDelegate, UIScrollViewDelegate>
@property(nonatomic) BOOL swiping;
@property(nonatomic) BOOL cardRevealed;

@property(nonatomic, strong) NSMutableArray *cardViews;
@property(nonatomic, strong) NSMutableArray *viewControllers;

- (void)buildCards;
@end