#import <MapKit/MapKit.h>
#import "MyClusterRenderer.h"
#import "MyMarker.h"
#import "Spot.h"

@implementation MyClusterRenderer

- (instancetype)initWithMapView:(MKMapView *)mapView {
    self = [super init];
    if (self) {
        self.mapView = mapView;
        self.markerCache = [[NSMutableArray alloc] init];
    }

    return self;
}

- (void)clustersChanged:(NSSet *)clusters {
    [self.mapView removeAnnotations:self.markerCache];
    [self.markerCache removeAllObjects];

    for (id <GCluster> cluster in clusters) {
        MyMarker *marker;
        if ([cluster count] > 1) {
            marker = [[MyMarker alloc] initWithIsCluster:YES text:nil];
        }
        else {
            id unknownItem = [[cluster getItems] allObjects][0];
            Spot *spot;
            if ([unknownItem isKindOfClass:Spot.class]) {
                spot = unknownItem;
            }
            else {
                GQuadItem *item = unknownItem;
                spot = [item.getItems allObjects][0];
            }

            marker = [[MyMarker alloc] initWithIsCluster:NO text:spot.text];
        }

        [marker setCoordinate:cluster.position];
        [self.markerCache addObject:marker];
        [self.mapView addAnnotation:marker];
    }
}

- (void)unselectAll {
    for (MyMarker *marker in self.markerCache) {
        [marker setIsSelected:NO];
    }
}
@end