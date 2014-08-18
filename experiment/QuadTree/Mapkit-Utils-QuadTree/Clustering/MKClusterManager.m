#import <MapKit/MapKit.h>
#import "MKClusterManager.h"

@implementation MKClusterManager

- (void)setMapView:(MKMapView *)mapView {
    map = mapView;
}

- (void)setClusterAlgorithm:(id <GClusterAlgorithm>)clusterAlgorithm {
    algorithm = clusterAlgorithm;
}

- (void)setClusterRenderer:(id <GClusterRenderer>)clusterRenderer {
    renderer = clusterRenderer;
}

- (void)addItem:(id <GClusterItem>) item {
    [algorithm addItem:item];
}

- (void)cluster {
    float zoom = 17;
    NSSet *clusters = [algorithm getClusters:zoom];
    [renderer clustersChanged:clusters];
}

//- (void)mapView:(GMSMapView *)mapView idleAtCameraPosition:(GMSCameraPosition *)cameraPosition {
//    // Don't re-compute clusters if the map has just been panned/tilted/rotated.
//    GMSCameraPosition *position = [mapView camera];
//    if (previousCameraPosition != nil && previousCameraPosition.zoom == position.zoom) {
//        return;
//    }
//    previousCameraPosition = [mapView camera];
//    [self cluster];
//}

@end
