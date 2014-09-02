#import <XCTest/XCTest.h>
#import "Spot.h"
#import "DistanceComparator.h"

@interface DistanceComparatorTests : XCTestCase
@end

@implementation DistanceComparatorTests

- (void)testSortsSpotsByDistanceToCenter {
    Spot *center = [Spot new];
    center.location = CLLocationCoordinate2DMake(0, 0);

    Spot *first = [Spot new];
    first.location = CLLocationCoordinate2DMake(1, 1);

    Spot *second = [Spot new];
    second.location = CLLocationCoordinate2DMake(-2, -1);

    Spot *third = [Spot new];
    third.location = CLLocationCoordinate2DMake(3, -2);

    NSArray *unsorted = @[second, first, third];
    DistanceComparator *comparator = [[DistanceComparator alloc] initWithCenter:center.location];
    NSArray *sorted = [unsorted sortedArrayUsingComparator:[comparator generate]];

    NSArray *expected = @[first, second, third];
    XCTAssertEqualObjects(sorted, expected);
}

@end