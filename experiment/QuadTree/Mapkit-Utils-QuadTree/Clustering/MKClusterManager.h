#import <Foundation/Foundation.h>
#import "GClusterAlgorithm.h"
#import "GClusterRenderer.h"
#import "GQTPointQuadTreeItem.h"
#import <MapKit/MKMapView.h>

@class MKMapView;

@interface MKClusterManager : NSObject <MKMapViewDelegate> {
    MKMapView *map;
    id <GClusterAlgorithm> algorithm;
    id <GClusterRenderer> renderer;
    BOOL previousCameraPosition;
}

- (void)setMapView:(MKMapView*)mapView;

- (void)setClusterAlgorithm:(id <GClusterAlgorithm>)clusterAlgorithm;

- (void)setClusterRenderer:(id <GClusterRenderer>)clusterRenderer;

- (void)addItem:(id <GClusterItem>) item;

- (void)cluster;

@end
