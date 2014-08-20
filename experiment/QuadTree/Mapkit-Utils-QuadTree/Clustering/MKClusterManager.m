#import <MapKit/MapKit.h>
#import <MKMapView-ZoomLevel/MKMapView+ZoomLevel.h>
#import "MKClusterManager.h"
#import "MyMarker.h"

@implementation MKClusterManager {
    NSUInteger previousZoom;
}

- (void)setMapView:(MKMapView *)mapView {
    map = mapView;
}

- (void)setClusterAlgorithm:(id <GClusterAlgorithm>)clusterAlgorithm {
    algorithm = clusterAlgorithm;
}

- (void)setClusterRenderer:(id <GClusterRenderer>)clusterRenderer {
    renderer = clusterRenderer;
}

- (void)addItem:(id <GClusterItem>)item {
    [algorithm addItem:item];
}

- (void)cluster {
    NSSet *clusters = [algorithm getClusters:[map zoomLevel]];
    [renderer clustersChanged:clusters];
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation {
    if (![annotation isKindOfClass:MyMarker.class]) {
        return nil;
    }

    MKPinAnnotationView *pav = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:nil];
    MyMarker *marker = annotation;
    if (marker.isCluster) {
        pav.pinColor = MKPinAnnotationColorRed;
    }
    else {
        pav.pinColor = MKPinAnnotationColorGreen;
    }
    return pav;
}


- (void)mapView:(MKMapView *)mapView regionWillChangeAnimated:(BOOL)animated {
    self.clusterTimer = [NSTimer scheduledTimerWithTimeInterval:0.5
                                                         target:self
                                                       selector:@selector(regionChanged)
                                                       userInfo:nil
                                                        repeats:YES];
}

- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated {
    [self.clusterTimer invalidate];
    self.clusterTimer = nil;
    [self regionChanged];
}

- (void)regionChanged {
    if (previousCameraPosition && previousZoom == [map zoomLevel]) {
        return;
    }
    previousCameraPosition = YES;
    previousZoom = [map zoomLevel];
    [self cluster];
}

@end