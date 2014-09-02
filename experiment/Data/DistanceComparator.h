#import <CoreLocation/CoreLocation.h>

@interface DistanceComparator : NSObject
@property(nonatomic) CLLocationCoordinate2D center;

- (instancetype)initWithCenter:(CLLocationCoordinate2D)center;

- (NSComparator)generate;
@end