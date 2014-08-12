#import "SingleDotRenderer.h"

@implementation SingleDotRenderer

- (instancetype)initWithMapView:(GMSMapView *)mapView {
    self = [super init];
    if (self) {
        self.mapView = mapView;
        self.markerCache = [[NSMutableArray alloc] init];
    }

    return self;
}

- (void)clustersChanged:(NSSet *)clusters {
    for (GMSMarker *marker in self.markerCache) {
        marker.map = nil;
    }
    [self.markerCache removeAllObjects];

    for (id <GCluster> cluster in clusters) {
        GMSMarker *marker;
        marker = [[GMSMarker alloc] init];
        [self.markerCache addObject:marker];

        if ([cluster count] > 1) {
            marker.icon = [self generateClusterIconWithCount:[cluster count]];
        }
        else {
            marker.icon = [GMSMarker markerImageWithColor:[UIColor greenColor]];
        }
        marker.position = cluster.position;
        marker.map = self.mapView;
    }
}

- (UIImage *)generateClusterIconWithCount:(int)count {
    int diameter = 17;
    float inset = 1;

    CGRect rect = CGRectMake(0, 0, diameter, diameter);
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0);

    CGContextRef ctx = UIGraphicsGetCurrentContext();

    // make circle rect 5 px from border
    CGRect circleRect = CGRectMake(0, 0, diameter, diameter);
    circleRect = CGRectInset(circleRect, inset * 3, inset * 3);

    // draw circle
    CGContextSetShadowWithColor(ctx, CGSizeMake(0, 1), 3.0, [UIColor blackColor].CGColor);
    [[UIColor colorWithRed:1 green:0 blue:0 alpha:1] setFill];
    CGContextFillEllipseInRect(ctx, circleRect);

    //stroke
    [[UIColor whiteColor] setStroke];
    CGContextSetLineWidth(ctx, inset);
//    CGContextSetShadowWithColor(ctx, CGSizeMake(0, 1), 3.0, [UIColor blackColor].CGColor);
    CGContextStrokeEllipseInRect(ctx, circleRect);

    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    return image;
}


@end