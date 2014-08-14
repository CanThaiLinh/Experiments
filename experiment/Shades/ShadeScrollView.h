@class ShadeTableViewController;

@interface ShadeScrollView : UIScrollView <UIGestureRecognizerDelegate>
@property(nonatomic) BOOL swiping;
@property(nonatomic) BOOL cardRevealed;

@property(nonatomic, strong) NSMutableArray *cardViews;
@property(nonatomic, strong) NSMutableArray *viewControllers;

- (void)buildCards;
@end