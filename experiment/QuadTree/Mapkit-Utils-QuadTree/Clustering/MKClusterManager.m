#import <MapKit/MapKit.h>
#import <MKMapView-ZoomLevel/MKMapView+ZoomLevel.h>
#import "MKClusterManager.h"
#import "MyMarker.h"
#import "MKClusterRenderer.h"

@implementation MKClusterManager {
    float previousZoom;
}

- (void)setMapView:(MKMapView *)mapView {
    map = mapView;
}

- (void)setClusterAlgorithm:(id <GClusterAlgorithm>)clusterAlgorithm {
    algorithm = clusterAlgorithm;
}

- (void)setClusterRenderer:(id <MKClusterRenderer>)clusterRenderer {
    renderer = clusterRenderer;
}

- (void)addItem:(id <GClusterItem>)item {
    [algorithm addItem:item];
}

- (void)cluster {
    NSSet *clusters = [algorithm getClusters:[map zoomLevel]];
    [renderer clustersChanged:clusters atMaxZoom: [map zoomLevel] > 17.5];
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation {
    if (![annotation conformsToProtocol:@protocol(MKAnnotation)]) {
        return nil;
    }

    MKPinAnnotationView *pav = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:nil];
    MyMarker *marker = annotation;
    if (marker.isBubble) {
        pav.pinColor = MKPinAnnotationColorGreen;
    }
    else {
        pav.pinColor = MKPinAnnotationColorRed;
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
