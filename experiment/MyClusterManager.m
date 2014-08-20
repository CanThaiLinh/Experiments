#import "MyMarker.h"
#import "MyClusterManager.h"
#import "MKClusterRenderer.h"

@implementation MyClusterManager

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view {
    MyMarker *annotation = view.annotation;
    if (![annotation isKindOfClass:MyMarker.class]) {
        return;
    }

    if (!annotation.isSelected) {
        [self unselectAll];

        annotation.isSelected = YES;
        [renderer removeMarker:annotation];
        [renderer addMarker:annotation atPosition:annotation.coordinate];
    }
}

- (void)unselectAll {
    for (MyMarker *marker in map.annotations) {
        if ([marker isKindOfClass:MyMarker.class]) {
            if (marker.isSelected) {
                marker.isSelected = NO;
                [renderer removeMarker:marker];
                [renderer addMarker:marker atPosition:marker.coordinate];
            }
        }
    }

}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation {
    if (![annotation isKindOfClass:MyMarker.class]) {
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

    if (marker.isSelected) {
        pav.pinColor = MKPinAnnotationColorPurple;
    }

    return pav;
}


@end