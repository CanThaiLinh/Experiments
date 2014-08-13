#import <CoreLocation/CoreLocation.h>
#import <XCTest/XCTest.h>
#import "EXViewController.h"

@interface EXViewControllerTests : XCTestCase
@end

@implementation EXViewControllerTests

- (void)testCreatesShadesWithDifferentTableViewControllers {
    UIStoryboard *board = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    EXViewController *controller = [board instantiateInitialViewController];

    [controller buildCards];
    UITableView *view1 = controller.cardViews[1];
    UITableView *view2 = controller.cardViews[2];
    XCTAssertNotEqual(view1, view2);
}

@end