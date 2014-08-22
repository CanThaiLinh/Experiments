#import <MapKit/MapKit.h>
#import <MKMapView-ZoomLevel/MKMapView+ZoomLevel.h>
#import "MKClusterManager.h"
#import "MKClusterRenderer.h"
#import "MyMarker.h"
#import "BubbleAnnotation.h"
#import "StackedBubbleAnnotation.h"
#import "DotAnnotationView.h"

@implementation MKClusterManager {
    float previousZoom;
}

- (instancetype)initWithMapView:(MKMapView *)mapView algorithm:(id <GClusterAlgorithm>)algorithm renderer:(id <MKClusterRenderer>)renderer {
    self = [super init];
    if (self) {
        self.mapView = mapView;
        self.algorithm = algorithm;
        self.renderer = renderer;
    }

    return self;
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

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view {
    MyMarker *marker = view.annotation;
    if (![marker isKindOfClass:MyMarker.class]) {
        return;
    }

    if (!marker.isSelected) {
        [self unselectAll];
        marker.isSelected = YES;
        [self redrawMarker:marker];
    }
}

- (void)unselectAll {
    for (MyMarker *marker in self.mapView.annotations) {
        if ([marker isKindOfClass:MyMarker.class]) {
            if (marker.isSelected) {
                marker.isSelected = NO;
                [self redrawMarker:marker];
            }
        }
    }
}

- (void)redrawMarker:(MyMarker *)marker {
    [self.renderer removeMarker:marker];
    [self.renderer addMarker:marker atPosition:marker.coordinate];
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation {
    if (![annotation isKindOfClass:MyMarker.class]) {
        return nil;
    }

    MKAnnotationView <MyAnnotationView> *view;
    MyMarker *marker = annotation;
    if ([marker.data count] > 1 && (marker.isBubble || marker.isSelected)) {
        view = (MKAnnotationView <MyAnnotationView> *) [mapView dequeueReusableAnnotationViewWithIdentifier:NSStringFromClass(StackedBubbleAnnotation.class)];
        if (view == nil) {
            view = [[StackedBubbleAnnotation alloc] initWithAnnotation:annotation reuseIdentifier:NSStringFromClass(StackedBubbleAnnotation.class)];
        }
    }
    else if (marker.isBubble || marker.isSelected) {
        view = (MKAnnotationView <MyAnnotationView> *) [mapView dequeueReusableAnnotationViewWithIdentifier:NSStringFromClass(BubbleAnnotation.class)];
        if (view == nil) {
            view = [[BubbleAnnotation alloc] initWithAnnotation:annotation reuseIdentifier:NSStringFromClass(BubbleAnnotation.class)];
        }
    }
    else {
        view = (MKAnnotationView <MyAnnotationView> *) [mapView dequeueReusableAnnotationViewWithIdentifier:NSStringFromClass(DotAnnotationView.class)];
        if (view == nil) {
            view = [[DotAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:NSStringFromClass(DotAnnotationView.class)];
        }
    }
    view.annotation = annotation;
    [view draw];
    return view;
}

@end
