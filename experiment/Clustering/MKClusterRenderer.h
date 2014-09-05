#import <Foundation/Foundation.h>

#import <MapKit/MKAnnotation.h>

@class MyMarker;
@class Spot;

@protocol MKClusterRenderer <NSObject>

- (void)clustersChanged:(NSSet *)clusters atMaxZoom:(BOOL)zoom;

- (void)removeMarker:(NSObject <MKAnnotation> *)annotation;

- (void)addMarker:(MyMarker *)marker atPosition:(CLLocationCoordinate2D)position;

- (id <MKAnnotation>)markerForSpot:(Spot *)spot;
@end