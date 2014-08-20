#import <MapKit/MapKit.h>
#import "GMSMarker.h"

@interface MyMarker : NSObject<MKAnnotation>
@property (nonatomic) CLLocationCoordinate2D coordinate;

@property(nonatomic, copy) NSString *text;

@property(nonatomic) BOOL isBubble;

- (instancetype)initWithIsBubble:(BOOL)isBubble text:(NSString *)text;

@end