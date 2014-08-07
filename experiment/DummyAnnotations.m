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
    return nil;
}

@end