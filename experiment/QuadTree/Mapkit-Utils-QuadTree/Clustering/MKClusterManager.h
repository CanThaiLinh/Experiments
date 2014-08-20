#import <Foundation/Foundation.h>
#import "GClusterAlgorithm.h"
#import "GClusterRenderer.h"
#import "GQTPointQuadTreeItem.h"
#import <MapKit/MKMapView.h>

@class MKMapView;
@protocol MKClusterRenderer;

@interface MKClusterManager : NSObject <MKMapViewDelegate> {
    MKMapView *map;
    id <GClusterAlgorithm> algorithm;
    id <MKClusterRenderer> renderer;
    BOOL previousCameraPosition;
}

@property(nonatomic, weak) NSTimer *clusterTimer;

- (void)setMapView:(MKMapView *)mapView;

- (void)setClusterAlgorithm:(id <GClusterAlgorithm>)clusterAlgorithm;

- (void)setClusterRenderer:(id <MKClusterRenderer>)clusterRenderer;

- (void)addItem:(id <GClusterItem>)item;

- (void)cluster;

@end
