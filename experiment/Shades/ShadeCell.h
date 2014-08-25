@class SpotData;

@interface ShadeCell : UITableViewCell {}
@property (weak, nonatomic) IBOutlet UILabel *longNamle;
@property (weak, nonatomic) IBOutlet UILabel *shortName;
@property (weak, nonatomic) IBOutlet UILabel *fullAssociatedName;

@property (weak, nonatomic) IBOutlet UILabel *change;
@property (weak, nonatomic) IBOutlet UILabel *price;

@property(nonatomic, strong) SpotData *spotData;

@end