#import "SpotDataTests.h"
#import "SpotData.h"

@implementation SpotDataTests

- (void)testCalculatesPercentChange {
    XCTAssertEqualObjects([[[SpotData alloc] initWithShortName:@"" name:@""
                                                         price:[NSDecimalNumber decimalNumberWithString:@"0.96"]
                                                        change:[NSDecimalNumber decimalNumberWithString:@"-0.04"]
                                                      priority:0] percentChange],
            [NSDecimalNumber decimalNumberWithString:@"-4.00"]);

    NSDecimalNumber *percentChange = [[[SpotData alloc] initWithShortName:@"" name:@""
                                                                    price:[NSDecimalNumber decimalNumberWithString:@"2"]
                                                                   change:[NSDecimalNumber decimalNumberWithString:@"0.05"]
                                                                 priority:0] percentChange];
    XCTAssertEqualObjects(percentChange, [NSDecimalNumber decimalNumberWithString:@"2.6"]);
}

@end