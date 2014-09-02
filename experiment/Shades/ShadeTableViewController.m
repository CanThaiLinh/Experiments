#import "ShadeTableViewController.h"
#import "Spot.h"
#import "SpotData.h"
#import "ShadeCell.h"
#import "ShadeTableView.h"

@implementation ShadeTableViewController

- (instancetype)initWithSpot:(Spot *)spot {
    self = [super init];
    if (self) {
        self.spot = spot;
        [self registerCellNib:ShadeCell.class];
    }

    return self;
}

- (void)loadView {
    ShadeTableView *tv = [[ShadeTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    tv.dataSource = self;
    tv.delegate = self;
    self.view = tv;
    self.tableView = tv;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.spot.data count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ShadeCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(ShadeCell.class)];
    [cell setSpotData:self.spot.data[[indexPath row]]];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 55;
}

- (void)registerCellNib:(Class)klass {
    UINib *nib = [UINib nibWithNibName:NSStringFromClass(klass) bundle:nil];
    [[self tableView] registerNib:nib forCellReuseIdentifier:NSStringFromClass(klass)];
}

@end