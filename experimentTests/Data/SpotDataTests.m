#import "SpotDataTests.h"
#import "SpotData.h"
#import "Spot.h"

@implementation SpotDataTests

- (void)testCalculatesPercentChange {
    XCTAssertEqualObjects([[[SpotData alloc] initWithShortName:@"" name:@""
                                                         price:[NSDecimalNumber decimalNumberWithString:@"0.96"]
                                                        change:[NSDecimalNumber decimalNumberWithString:@"-0.04"]
                                                      priority:0] percentChange],
            [NSDecimalNumber decimalNumberWithString:@"-0.04"]);

    XCTAssertEqualObjects([[[SpotData alloc] initWithShortName:@"" name:@""
                                                         price:[NSDecimalNumber decimalNumberWithString:@"2"]
                                                        change:[NSDecimalNumber decimalNumberWithString:@"0.05"]
                                                      priority:0] percentChange],
            [NSDecimalNumber decimalNumberWithString:@"0.026"]);
}

@end