#import <MapKit/MapKit.h>

@interface DummyAnnotations : NSObject

- (void)addAnnotations:(GClusterManager *)view around:(CLLocationCoordinate2D)around;

- (NSArray *)dummyCoordinatesFor:(CLLocationCoordinate2D)center;
@end