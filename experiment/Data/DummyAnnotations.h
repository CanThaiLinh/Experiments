#import <MapKit/MapKit.h>
#import "GClusterManager.h"

@class MKClusterManager;

@interface DummyAnnotations : NSObject

- (void)addAnnotations:(MKClusterManager *)manager around:(CLLocationCoordinate2D)around;

- (NSArray *)dummyCoordinatesFor:(CLLocationCoordinate2D)center;
@end