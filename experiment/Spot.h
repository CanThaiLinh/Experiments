#import "GClusterItem.h"

@interface Spot : NSObject <GClusterItem>

@property(nonatomic) CLLocationCoordinate2D location;
@property(nonatomic) NSString *text;

//some priority to choose which will bubble and which will collapse when near each other
@property(nonatomic) int priority;
@end