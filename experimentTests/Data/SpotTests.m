#import "SpotTests.h"
#import "Spot.h"
#import "SpotData.h"

@implementation SpotTests

- (void)testSortsSpotData {
    Spot *spot = [Spot new];
    [spot addData:[[SpotData alloc] initWithShortName:@"" name:@"" price:nil change:nil priority:2]];
    SpotData *highestPriority = [[SpotData alloc] initWithShortName:@"" name:@"" price:nil change:nil priority:3];
    [spot addData:highestPriority];
    [spot addData:[[SpotData alloc] initWithShortName:@"" name:@"" price:nil change:nil priority:1]];
    XCTAssertEqual(spot.data[0], highestPriority);
}

@end