#import <Foundation/Foundation.h>

#import <MapKit/MKAnnotation.h>

@class MyMarker;

@protocol MKClusterRenderer <NSObject>

- (void)clustersChanged:(NSSet *)clusters atMaxZoom:(BOOL)zoom;

- (void)removeMarker:(NSObject <MKAnnotation> *)annotation;

- (void)addMarker:(MyMarker *)marker atPosition:(CLLocationCoordinate2D)position;

@end