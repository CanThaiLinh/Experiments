#import "ShadeTableViewController.h"
#import "Spot.h"
#import "SpotData.h"
#import "ShadeCell.h"

@implementation ShadeTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self registerCellNib:ShadeCell.class];
}


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
    ShadeCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(ShadeCell.class)];
    if( cell == nil ){
        cell = [[ShadeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass(ShadeCell.class)];
    }
    SpotData *data = self.spot.data[[indexPath row]];
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