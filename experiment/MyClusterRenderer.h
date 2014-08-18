#import "GClusterRenderer.h"

@class GMSMapView;
@class MKMapView;

@interface MyClusterRenderer : NSObject <GClusterRenderer>
@property(nonatomic, strong) MKMapView *mapView;

@property(nonatomic, strong) NSMutableArray *markerCache;

- (instancetype)initWithMapView:(MKMapView *)mapView;

- (void)unselectAll;
@end