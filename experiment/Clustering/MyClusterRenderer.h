#import "MKClusterRenderer.h"

@class GMSMapView;
@class MKMapView;

@interface MyClusterRenderer : NSObject <MKClusterRenderer>
@property(nonatomic, strong) MKMapView *mapView;

@property(nonatomic, strong) NSMutableArray *markerCache;

- (instancetype)initWithMapView:(MKMapView *)mapView;
@end