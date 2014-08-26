@class ShadeTableViewController;
@class Spot;
@class EXViewController;
@protocol SpotSelectionDelegate;

@interface ShadeScrollView : UIScrollView <UIGestureRecognizerDelegate, UIScrollViewDelegate>
@property(nonatomic) BOOL swiping;
@property(nonatomic) BOOL cardRevealed;

@property(nonatomic, strong) NSMutableArray *cardViews;
@property(nonatomic, strong) NSMutableArray *viewControllers;

@property(nonatomic, strong) NSObject <SpotSelectionDelegate> *spotDelegate;

- (void)buildCards:(NSArray *)data;

- (void)selectSpot:(Spot *)spot;
@end