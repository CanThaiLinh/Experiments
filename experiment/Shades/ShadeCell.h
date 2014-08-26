@class SpotData;

@interface ShadeCell : UITableViewCell {}
@property (weak, nonatomic) IBOutlet UILabel *longName;
@property (weak, nonatomic) IBOutlet UILabel *shortName;
@property (weak, nonatomic) IBOutlet UILabel *fullAssociatedName;

@property (weak, nonatomic) IBOutlet UILabel *change;
@property (weak, nonatomic) IBOutlet UILabel *price;

@property(nonatomic, strong) SpotData *spotData;


@property(nonatomic, strong) NSNumberFormatter *formatter;
@end