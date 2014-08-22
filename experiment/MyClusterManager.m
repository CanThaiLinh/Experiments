#import "MyMarker.h"
#import "MyClusterManager.h"
#import "MKClusterRenderer.h"
#import "DotAnnotationView.h"
#import "BubbleAnnotation.h"
#import "StackedBubbleAnnotation.h"

@implementation MyClusterManager

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view {
    MyMarker *annotation = view.annotation;
    if (![annotation isKindOfClass:MyMarker.class]) {
        return;
    }

    if (!annotation.isSelected) {
        [self unselectAll];

        annotation.isSelected = YES;
        [self.renderer removeMarker:annotation];
        [self.renderer addMarker:annotation atPosition:annotation.coordinate];
    }
}

- (void)unselectAll {
    for (MyMarker *marker in self.mapView.annotations) {
        if ([marker isKindOfClass:MyMarker.class]) {
            if (marker.isSelected) {
                marker.isSelected = NO;
                [self.renderer removeMarker:marker];
                [self.renderer addMarker:marker atPosition:marker.coordinate];
            }
        }
    }
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation {
    if (![annotation isKindOfClass:MyMarker.class]) {
        return nil;
    }

    MKAnnotationView *view;
    MyMarker *marker = annotation;
    if ([marker.data count] > 1 && marker.isBubble) {
        view = [mapView dequeueReusableAnnotationViewWithIdentifier:NSStringFromClass(StackedBubbleAnnotation.class)];
        if (view == nil) {
            view = [[StackedBubbleAnnotation alloc] initWithAnnotation:annotation reuseIdentifier:NSStringFromClass(StackedBubbleAnnotation.class)];
        }
    }
    else if (marker.isBubble) {
        view = [mapView dequeueReusableAnnotationViewWithIdentifier:NSStringFromClass(BubbleAnnotation.class)];
        if (view == nil) {
            view = [[BubbleAnnotation alloc] initWithAnnotation:annotation reuseIdentifier:NSStringFromClass(BubbleAnnotation.class)];
        }
    }
    else {
        view = [mapView dequeueReusableAnnotationViewWithIdentifier:NSStringFromClass(DotAnnotationView.class)];
        if (view == nil) {
            view = [[DotAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:NSStringFromClass(DotAnnotationView.class)];
        }
    }

    return view;
}

@end