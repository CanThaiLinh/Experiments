#import <MapKit/MapKit.h>
#import "DummyAnnotations.h"
#import "MyAnnotation.h"

@implementation DummyAnnotations

- (void)addAnnotations:(MKMapView *)view around:(CLLocationCoordinate2D)around {
    NSArray *dummyCoordinates = [self dummyCoordinatesFor:around];
    for (int i = 0; i < [dummyCoordinates count]; i++) {
        CLLocationCoordinate2D primaryPoint;
        [dummyCoordinates[i] getValue:&primaryPoint];

        NSUUID *UUID = [NSUUID UUID];
        NSString *uuid = [UUID UUIDString];

        MyAnnotation *primaryAnnotation = [MyAnnotation annotationWithTitle:@"Individual" coordinate:primaryPoint];
        primaryAnnotation.groupTag = uuid;
        [view addAnnotation:primaryAnnotation];

        for (int clusterLocation = 0; clusterLocation < 5; clusterLocation++) {
            CLLocationCoordinate2D clusterPoint = [self randomCoordinateNear:primaryPoint withPrecision:0.00001];
            MyAnnotation *annotation = [MyAnnotation annotationWithTitle:@"Individual" coordinate:clusterPoint];

            annotation.groupTag = uuid;
            [view addAnnotation:annotation];
        }
    }
}

- (NSArray *)dummyCoordinatesFor:(CLLocationCoordinate2D)center {
    NSMutableArray *coordinates = [@[] mutableCopy];
    for (int primaryLocation = 0; primaryLocation < 5; primaryLocation++) {
        CLLocationCoordinate2D primaryPoint = [self randomCoordinateNear:center withPrecision:0.0001];
        [coordinates addObject:[NSValue value:&primaryPoint withObjCType:@encode(CLLocationCoordinate2D)]];
    }
    return coordinates;
}

- (CLLocationCoordinate2D)randomCoordinateNear:(CLLocationCoordinate2D)nearPoint withPrecision:(double)precision {
    CLLocationCoordinate2D value;
    int randomValueLongitude = arc4random() % 6;
    int randomValueLatitude = arc4random() % 6;
    int positiveNegativeLongitude = arc4random() % 2 == 0 ? -1 : 1;
    int positiveNegativeLatitude = arc4random() % 2 == 0 ? -1 : 1;

    value.longitude = nearPoint.longitude + precision * randomValueLongitude * positiveNegativeLongitude;
    value.latitude = nearPoint.latitude + precision * randomValueLatitude * positiveNegativeLatitude;
    return value;
}

@end