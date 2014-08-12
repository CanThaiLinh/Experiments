#import "MyClusterRenderer.h"
#import "MyMarker.h"

@implementation MyClusterRenderer

- (instancetype)initWithMapView:(GMSMapView *)mapView {
    self = [super init];
    if (self) {
        self.mapView = mapView;
        self.markerCache = [[NSMutableArray alloc] init];
    }

    return self;
}

- (void)clustersChanged:(NSSet *)clusters {
    for (GMSMarker *marker in self.markerCache) {
        marker.map = nil;
    }
    [self.markerCache removeAllObjects];

    for (id <GCluster> cluster in clusters) {
        MyMarker *marker = [[MyMarker alloc] initWithIsCluster:[cluster count] > 1];
        [self.markerCache addObject:marker];
        marker.position = cluster.position;
        marker.map = self.mapView;
    }

    for (MyMarker *marker in self.markerCache) {
        [marker buildIcon];
    }
}

- (void)unselectAll {
    for (MyMarker *marker in self.markerCache) {
        [marker setIsSelected:NO];
    }
}
@end