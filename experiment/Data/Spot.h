#import "GClusterItem.h"

@class SpotData;

@interface Spot : NSObject <GClusterItem>

@property(nonatomic) CLLocationCoordinate2D location;

//some priority to choose which will bubble and which will collapse when near each other
@property(nonatomic) int priority;

@property(nonatomic) NSMutableArray *data;

- (void)addData:(SpotData *)data;
@end