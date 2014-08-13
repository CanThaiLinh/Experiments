#import "ShadeTableViewController.h"

@implementation ShadeTableViewController

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSLog(@"Adking for rows");
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ShadeCell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ShadeCell"];
    }
//    [cell.textLabel setText:self.items[(NSUInteger) [indexPath row]]];
    [cell.textLabel setText:@"Bob"];
    return cell;
}

@end