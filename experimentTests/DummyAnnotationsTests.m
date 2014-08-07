#import <XCTest/XCTest.h>
#import <CoreLocation/CoreLocation.h>
#import "DummyAnnotations.h"

@interface DummyAnnotationsTests : XCTestCase
@end

@implementation DummyAnnotationsTests

- (void)testHasPoints {
    CLLocationCoordinate2D coordinate;
    coordinate.latitude = 170;
    coordinate.longitude = 100;
    XCTAssertTrue([[[DummyAnnotations new] dummyCoordinatesFor:coordinate] count] > 0);
}

@end