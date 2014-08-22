#import <MapKit/MapKit.h>
#import <MKMapView-ZoomLevel/MKMapView+ZoomLevel.h>
#import "MKClusterManager.h"
#import "MKClusterRenderer.h"

@implementation MKClusterManager {
    float previousZoom;
}

- (void)addItem:(id <GClusterItem>)item {
    [self.algorithm addItem:item];
}

- (void)cluster {
    NSSet *clusters = [self.algorithm getClusters:[self.mapView zoomLevel]];
    [self.renderer clustersChanged:clusters atMaxZoom:[self.mapView zoomLevel] >= 16.8];
}

- (void)mapView:(MKMapView *)mapView regionWillChangeAnimated:(BOOL)animated {
    self.clusterTimer = [NSTimer scheduledTimerWithTimeInterval:0.5
                                                         target:self
                                                       selector:@selector(regionChanged)
                                                       userInfo:nil
                                                        repeats:YES];
}

- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated {
    if ([mapView zoomLevel] < 14 && self.initialLocationFound) {
        [mapView setCenterCoordinate:mapView.centerCoordinate zoomLevel:15 animated:YES];
    }

    [self.clusterTimer invalidate];
    self.clusterTimer = nil;
    [self regionChanged];
}

- (void)regionChanged {
    if (previousZoom == [self.mapView zoomLevel]) {
        return;
    }
    previousZoom = [self.mapView zoomLevel];
    [self cluster];
}

@end
