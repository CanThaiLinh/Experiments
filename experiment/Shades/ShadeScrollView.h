@class ShadeTableViewController;
@class Spot;
@class EXViewController;
@protocol SpotSelectionDelegate;

@interface ShadeScrollView : UIScrollView <UIGestureRecognizerDelegate, UIScrollViewDelegate>
@property(nonatomic, strong) NSMutableArray *cardViews;
@property(nonatomic, strong) NSMutableArray *viewControllers;

@property(nonatomic, strong) NSObject <SpotSelectionDelegate> *spotDelegate;

- (CGFloat)cardRowHeight;

- (void)buildCards:(NSArray *)data;

- (void)selectSpot:(Spot *)spot;
@end