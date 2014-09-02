#import "DistanceComparator.h"
#import "Spot.h"

@implementation DistanceComparator

- (instancetype)initWithCenter:(CLLocationCoordinate2D)center {
    self = [super init];
    if (self) {
        self.center = center;
    }

    return self;
}

- (NSComparator)generate {
    return ^NSComparisonResult(Spot *spot1, Spot *spot2) {
        double spot1Distance = [self distanceSquared:self.center :spot1.location];
        double spot2Distance = [self distanceSquared:self.center :spot2.location];
        return [@(spot1Distance) compare:@(spot2Distance)];
    };
}

- (double)distanceSquared:(CLLocationCoordinate2D)a :(CLLocationCoordinate2D)b {
    return (a.latitude - b.latitude) * (a.latitude - b.latitude) + (a.longitude - b.longitude) * (a.longitude - b.longitude);
}
@end