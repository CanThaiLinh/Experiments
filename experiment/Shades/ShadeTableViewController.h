@class Spot;

@interface ShadeTableViewController : UITableViewController

@property(nonatomic, strong) Spot *spot;

- (instancetype)initWithSpot:(Spot *)spot;


@end