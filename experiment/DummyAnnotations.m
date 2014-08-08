#import <MapKit/MapKit.h>
#import "DummyAnnotations.h"
#import "MyAnnotation.h"

@implementation DummyAnnotations

- (void)addAnnotations:(MKMapView *)view around:(CLLocationCoordinate2D)around {
    NSArray *dummyCoordinates = [self dummyCoordinatesFor:around];
    for (int i = 0; i < [dummyCoordinates count]; i++) {
        CLLocationCoordinate2D value;
        [dummyCoordinates[i] getValue:&value];
        [view addAnnotation:[MyAnnotation annotationWithTitle:@"Test" coordinate:value]];
    }
}

- (NSArray *)dummyCoordinatesFor:(CLLocationCoordinate2D)center {
    NSMutableArray *coordinates = [@[] mutableCopy];
    for (int i = 0; i < 5; i++) {
        CLLocationCoordinate2D value;
        int randomValueLongitude = arc4random() % 6;
        int randomValueLatitude = arc4random() % 6;
        int positiveNegativeLongitude = arc4random() % 2 == 0 ? -1 : 1;
        int positiveNegativeLatitude = arc4random() % 2 == 0 ? -1 : 1;

        value.longitude = center.longitude + 0.0001 * randomValueLongitude * positiveNegativeLongitude;
        value.latitude = center.latitude + 0.0001 * randomValueLatitude * positiveNegativeLatitude;
        [coordinates addObject:[NSValue value:&value withObjCType:@encode(CLLocationCoordinate2D)]];
    }
    return coordinates;
}

@end