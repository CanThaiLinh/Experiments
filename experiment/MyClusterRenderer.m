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
    NSLog(@"Reclustering");
    [self.mapView removeAnnotations:self.markerCache];
    [self.markerCache removeAllObjects];

    for (id <GCluster> cluster in clusters) {
        if ([cluster count] > 1) {
            for (id unknown in [cluster getItems]) {
                [self addItem:unknown isBubble: NO];
            }
        }
        else {
            id unknownItem = [[cluster getItems] allObjects][0];
            [self addItem:unknownItem isBubble:YES];
        }
    }
}

- (void)addItem:(id)item isBubble:(BOOL)bubble {
    Spot *spot;
    if ([item isKindOfClass:Spot.class]) {
        spot = item;
    }
    else {
        GQuadItem *quadItem = item;
        spot = [quadItem.getItems allObjects][0];
    }

    MyMarker *marker = [[MyMarker alloc] initWithIsBubble:bubble text:spot.text];
    [self addMarker:marker atPosition:spot.position];
}

- (void)addMarker:(MyMarker *)marker atPosition:(CLLocationCoordinate2D)position {
    [marker setCoordinate:position];
    [self.markerCache addObject:marker];
    [self.mapView addAnnotation:marker];
}

- (void)unselectAll {
    for (MyMarker *marker in self.markerCache) {
//        [marker setIsSelected:NO];
    }
}
@end