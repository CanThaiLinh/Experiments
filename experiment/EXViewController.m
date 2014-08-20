#import <MapKit/MapKit.h>
#import <Google-Maps-iOS-SDK/GoogleMaps/GMSMapView.h>
#import <Google-Maps-iOS-Utils-QuadTree/GClusterManager.h>
#import "EXViewController.h"
#import "ClipView.h"
#import "DummyAnnotations.h"
#import "NonHierarchicalDistanceBasedAlgorithm.h"
#import "MyClusterRenderer.h"
#import "MyClusterManager.h"
#import "ShadeScrollView.h"

#include "MKMapView+ZoomLevel.h"
#import "MKClusterManager.h"

@implementation EXViewController

const int MAX_ZOOM_LEVEL = 21;

- (void)viewDidLoad {
    self.clipView.scrollView = self.scrollView;
    self.clipView.heightConstraint = self.shadeHeightConstraint;

    [self.scrollView buildCards];

    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    self.locationManager.distanceFilter = kCLDistanceFilterNone;

    [self.locationManager requestWhenInUseAuthorization];
    [self.locationManager startUpdatingLocation];

    self.clusterManager = [[MyClusterManager alloc] init];
    [self.clusterManager setMapView:self.mapView];
    [self.clusterManager setClusterAlgorithm:[[NonHierarchicalDistanceBasedAlgorithm alloc] initWithMaxDistanceAtZoom:6000]];
    [self.clusterManager setClusterRenderer:[[MyClusterRenderer alloc] initWithMapView:self.mapView]];

    [self.mapView setDelegate:self.clusterManager];
    [self.mapView setShowsUserLocation:YES];
    self.mapView.userTrackingMode = MKUserTrackingModeFollow;
}

- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation {
    if (!self.hasFoundInitialLocation) {
        NSLog(@"Update location");
        self.hasFoundInitialLocation = YES;
        [self.mapView setCenterCoordinate:newLocation.coordinate zoomLevel:MAX_ZOOM_LEVEL animated:NO];
        [[DummyAnnotations new] addAnnotations:self.clusterManager around:newLocation.coordinate];
        [[self clusterManager] cluster];
    }
}

@end