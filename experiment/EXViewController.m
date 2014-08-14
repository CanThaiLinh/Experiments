#import <MapKit/MapKit.h>
#import <Google-Maps-iOS-SDK/GoogleMaps/GMSMapView.h>
#import <Google-Maps-iOS-Utils-QuadTree/GClusterManager.h>
#import "EXViewController.h"
#import "ClipView.h"
#import "DummyAnnotations.h"
#import "NonHierarchicalDistanceBasedAlgorithm.h"
#import "MyClusterRenderer.h"
#import "MyClusterManager.h"
#import "ShadeTableViewController.h"
#import "ShadeScrollView.h"

@implementation EXViewController

const int MAX_ZOOM_LEVEL = 19;
const int MIN_ZOOM_LEVEL = 17;

- (void)viewDidLoad {
    self.clipView.scrollView = self.scrollView;

    [self.scrollView buildCards];

    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    self.locationManager.distanceFilter = kCLDistanceFilterNone;

    [self.locationManager startUpdatingLocation];

    self.clusterManager = [[MyClusterManager alloc] init];
    [self.clusterManager setMapView:self.mapView];
    [self.clusterManager setClusterAlgorithm:[[NonHierarchicalDistanceBasedAlgorithm alloc] init]];
    [self.clusterManager setClusterRenderer:[[MyClusterRenderer alloc] initWithMapView:self.mapView]];

    [self.mapView setMinZoom:MIN_ZOOM_LEVEL maxZoom:MAX_ZOOM_LEVEL];
    [self.mapView setMyLocationEnabled:YES];
    [self.mapView setBuildingsEnabled:NO];
    [self.mapView setIndoorEnabled:NO];
    [self.mapView setDelegate:self.clusterManager];
    [self.mapView bringSubviewToFront:self.clipView];
}

- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation {
    if (!self.hasFoundInitialLocation) {
        self.hasFoundInitialLocation = YES;
        [self.mapView setCamera:[GMSCameraPosition cameraWithLatitude:newLocation.coordinate.latitude
                                                            longitude:newLocation.coordinate.longitude
                                                                 zoom:MIN_ZOOM_LEVEL]];
        [[DummyAnnotations new] addAnnotations:self.clusterManager around:newLocation.coordinate];
        [[self clusterManager] cluster];
    }
}

@end