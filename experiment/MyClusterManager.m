#import "MyClusterManager.h"
#import "MyClusterRenderer.h"
#import "MyMarker.h"

@implementation MyClusterManager

- (BOOL)mapView:(GMSMapView *)mapView didTapMarker:(GMSMarker *)marker {
    MyClusterRenderer *myClusterRenderer = renderer;
    [myClusterRenderer unselectAll];
    MyMarker *myMarker = (MyMarker *) marker;
    [myMarker setIsSelected:YES];
    return YES;
}


@end