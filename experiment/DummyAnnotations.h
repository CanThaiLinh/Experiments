#import <MapKit/MapKit.h>

@interface DummyAnnotations : NSObject

- (void)addAnnotations:(GMSMapView *)view around:(CLLocationCoordinate2D)around;

- (NSArray *)dummyCoordinatesFor:(CLLocationCoordinate2D)center;
@end