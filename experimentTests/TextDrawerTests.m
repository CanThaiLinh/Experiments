#import <XCTest/XCTest.h>
#import "TextDrawer.h"

@interface TextDrawerTests : XCTestCase
@end

@implementation TextDrawerTests

- (void)testSizesText {
    CGSize size = [TextDrawer sizeOfText:@"TEST" fontSize:12];
    XCTAssertTrue(size.width > 0);
    XCTAssertTrue(size.height > 0);
}

@end