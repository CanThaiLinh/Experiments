#import <Foundation/Foundation.h>
#import "GClusterAlgorithm.h"
#import "GClusterRenderer.h"
#import "GQTPointQuadTreeItem.h"
#import <MapKit/MKMapView.h>

@class MKMapView;
@protocol MKClusterRenderer;
@protocol SpotSelectionDelegate;
@class Spot;

@interface MKClusterManager : NSObject <MKMapViewDelegate> {
}

@property(nonatomic, strong) MKMapView *mapView;
@property(nonatomic, strong) id <GClusterAlgorithm> algorithm;
@property(nonatomic, strong) id <MKClusterRenderer> renderer;
@property(nonatomic, weak) NSTimer *clusterTimer;

@property(nonatomic) BOOL initialLocationFound;

@property(nonatomic, strong) NSObject <SpotSelectionDelegate> *delegate;

@property(nonatomic, strong) NSObject <MKMapViewDelegate> *mapViewDelegate;

@property(nonatomic, strong) Spot *spotToSelectOnLoad;

- (instancetype)initWithMapView:(MKMapView *)mapView algorithm:(id <GClusterAlgorithm>)algorithm renderer:(id <MKClusterRenderer>)renderer;

- (void)addItem:(id <GClusterItem>)item;

- (void)cluster;

- (void)selectSpot:(Spot *)spot;

@end
