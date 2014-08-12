#import "GClusterRenderer.h"

@class GMSMapView;

@interface SingleDotRenderer : NSObject<GClusterRenderer>
@property(nonatomic, strong) GMSMapView *mapView;

@property(nonatomic, strong) NSMutableArray *markerCache;

- (instancetype)initWithMapView:(GMSMapView *)mapView;

@end