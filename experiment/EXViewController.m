#import <MapKit/MapKit.h>
#import <Google-Maps-iOS-SDK/GoogleMaps/GMSMapView.h>
#import <Google-Maps-iOS-Utils-QuadTree/GClusterManager.h>
#import "EXViewController.h"
#import "ShadeView.h"
#import "NonHierarchicalDistanceBasedAlgorithm.h"
#import "MyClusterRenderer.h"
#import "ShadeScrollView.h"

#include "MKMapView+ZoomLevel.h"
#import "MKClusterManager.h"
#import "DummyDataProvider.h"
#import "Spot.h"

@implementation EXViewController {
}

const int ERROR_VIEW_TAG = 1;
const int MAX_ZOOM_LEVEL = 21;

- (void)viewDidLoad {
    self.clipView.scrollView = self.scrollView;
    self.scrollView.spotDelegate = self;

    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    self.locationManager.distanceFilter = kCLDistanceFilterNone;

    [self.locationManager requestWhenInUseAuthorization];
    [self.locationManager startUpdatingLocation];

    self.clusterManager = [[MKClusterManager alloc] initWithMapView:self.mapView
                                                          algorithm:[[NonHierarchicalDistanceBasedAlgorithm alloc] initWithMaxDistanceAtZoom:7000]
                                                           renderer:[[MyClusterRenderer alloc] initWithMapView:self.mapView]];
    self.clusterManager.delegate = self;
    self.clusterManager.mapViewDelegate = self;

    [self.mapView setDelegate:self.clusterManager];

    [self.mapView setShowsUserLocation:YES];
    self.mapView.userTrackingMode = MKUserTrackingModeFollow;
}

- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation {
    if (!self.hasFoundInitialLocation) {
        self.hasFoundInitialLocation = YES;
        [self.mapView setCenterCoordinate:newLocation.coordinate zoomLevel:MAX_ZOOM_LEVEL animated:NO];
        self.clusterManager.initialLocationFound = YES;
    }
}

- (void)didSelectSpot:(Spot *)spot {
    [self.scrollView selectSpot:spot];
}

- (void)didSwipeToSpot:(Spot *)spot {
    [self.clusterManager selectSpot:spot];
}

- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated {
    if (!self.hasFoundInitialLocation) {
        return;
    }

    [self getData];
}

- (void)getData {
    DummyDataProvider *provider = [[DummyDataProvider alloc] initWithOrigin:self.mapView.centerCoordinate];
    [provider retrieveData:^(NSArray *data) {
        [self removeErrorView];
        for (Spot *spot in data) {
            [self.clusterManager addItem:spot];
        }
        [[self clusterManager] cluster];
        [self.scrollView buildCards:data];
    }              failure:^{
        [self handleErrorResponse];
    }];
}

- (void)removeErrorView {
    UIView *errorView = [self.view viewWithTag:ERROR_VIEW_TAG];
    [errorView removeFromSuperview];
}

- (void)handleErrorResponse {
    if (![self.view viewWithTag:ERROR_VIEW_TAG]) {
        [self addErrorView];
        [self performSelector:@selector(getData) withObject:nil afterDelay:3.0];
    }
}

- (void)addErrorView {
    UIView *errorView = [[NSBundle mainBundle] loadNibNamed:@"ErrorView" owner:self options:nil][0];
    errorView.translatesAutoresizingMaskIntoConstraints = NO;
    errorView.tag = ERROR_VIEW_TAG;
    [self.view addSubview:errorView];
    [self.view addConstraint:
            [NSLayoutConstraint constraintWithItem:errorView
                                         attribute:NSLayoutAttributeCenterX
                                         relatedBy:NSLayoutRelationEqual
                                            toItem:self.view
                                         attribute:NSLayoutAttributeCenterX
                                        multiplier:1
                                          constant:0]];
    [self.view addConstraint:
            [NSLayoutConstraint constraintWithItem:errorView
                                         attribute:NSLayoutAttributeCenterY
                                         relatedBy:NSLayoutRelationEqual
                                            toItem:self.view
                                         attribute:NSLayoutAttributeCenterY
                                        multiplier:1
                                          constant:0]];
    [self.view addConstraint:
            [NSLayoutConstraint constraintWithItem:errorView
                                         attribute:NSLayoutAttributeWidth
                                         relatedBy:NSLayoutRelationEqual
                                            toItem:self.view
                                         attribute:NSLayoutAttributeWidth
                                        multiplier:1
                                          constant:0]];
    [self.view addConstraint:
            [NSLayoutConstraint constraintWithItem:errorView
                                         attribute:NSLayoutAttributeHeight
                                         relatedBy:NSLayoutRelationEqual
                                            toItem:self.view
                                         attribute:NSLayoutAttributeHeight
                                        multiplier:1
                                          constant:0]];
}

//Debug, show error
- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event {
    if (event.subtype == UIEventSubtypeMotionShake) {
        [self handleErrorResponse];
    }
}

@end