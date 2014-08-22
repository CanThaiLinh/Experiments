#import <Foundation/Foundation.h>
#import "GClusterAlgorithm.h"
#import "GClusterRenderer.h"
#import "GQTPointQuadTreeItem.h"
#import <MapKit/MKMapView.h>

@class MKMapView;
@protocol MKClusterRenderer;

@interface MKClusterManager : NSObject <MKMapViewDelegate> {
}

@property(nonatomic, strong) MKMapView *mapView;
@property(nonatomic, strong) id <GClusterAlgorithm> algorithm;
@property(nonatomic, strong) id <MKClusterRenderer> renderer;
@property(nonatomic, weak) NSTimer *clusterTimer;

@property(nonatomic) BOOL initialLocationFound;


- (void)addItem:(id <GClusterItem>)item;

- (void)cluster;

@end
