#import "GClusterRenderer.h"

@class GMSMapView;

@interface MyClusterRenderer : NSObject <GClusterRenderer>
@property(nonatomic, strong) GMSMapView *mapView;

@property(nonatomic, strong) NSMutableArray *markerCache;

- (instancetype)initWithMapView:(GMSMapView *)mapView;

- (void)unselectAll;
@end