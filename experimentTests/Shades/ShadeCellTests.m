#import <XCTest/XCTest.h>
#import "ShadeCell.h"
#import "SpotData.h"
#import "ShadeTableViewController.h"
#import "Spot.h"

@interface ShadeCellTests : XCTestCase
@end

@implementation ShadeCellTests

- (ShadeCell *)getCell: (SpotData *) data {
    Spot *spot = [Spot new];
    [spot.data addObject:data];
    ShadeTableViewController *controller = [[ShadeTableViewController alloc] initWithSpot:spot];
    return (ShadeCell *) [controller tableView:controller.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
}

- (void)testSetsFields {
    SpotData *data = [[SpotData alloc] initWithShortName:@"ABC"
                                                    name:@"ABC Stores"
                                                   price:[NSDecimalNumber decimalNumberWithString:@"100"]
                                                  change:[NSDecimalNumber decimalNumberWithString:@"5"]
                                                priority:0];
    ShadeCell *cell = [self getCell:data];
    XCTAssertEqualObjects([cell.shortName text], @"ABC");
    XCTAssertEqualObjects([cell.longName text], @"ABC Stores");
    XCTAssertEqualObjects([cell.price text], @"$100.00");
    XCTAssertEqualObjects([cell.change text], @"+$5.00 (+5.26%)");
}

- (void)testHandlesNegativeChange {
    SpotData *data = [[SpotData alloc] initWithShortName:@""
                                                    name:@""
                                                   price:[NSDecimalNumber decimalNumberWithString:@"100"]
                                                  change:[NSDecimalNumber decimalNumberWithString:@"-5"]
                                                priority:0];
    ShadeCell *cell = [self getCell:data];
    XCTAssertEqualObjects([cell.price text], @"$100.00");
    XCTAssertEqualObjects([cell.change text], @"-$5.00 (-4.76%)");
}

@end