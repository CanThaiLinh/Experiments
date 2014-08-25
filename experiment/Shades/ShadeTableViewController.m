#import "ShadeTableViewController.h"
#import "Spot.h"
#import "SpotData.h"

@implementation ShadeTableViewController

- (instancetype)initWithSpot:(Spot *)spot {
    self = [super init];
    if (self) {
        self.spot = spot;
    }

    return self;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.spot.data count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ShadeCell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ShadeCell"];
    }
    SpotData *data = self.spot.data[[indexPath row]];
    [cell.textLabel setText:[NSString stringWithFormat:@"%@: %@", data.shortName, data.name]];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}

@end