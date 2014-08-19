#import <MapKit/MapKit.h>
#import "GMSMarker.h"

@interface MyMarker : NSObject<MKAnnotation>
@property (nonatomic) BOOL isCluster;
@property (nonatomic) BOOL isSelected;
@property (nonatomic) CLLocationCoordinate2D coordinate;

@property(nonatomic, copy) NSString *text;

- (instancetype)initWithIsCluster:(BOOL)isCluster text:(NSString *)text;

- (void)buildIcon;
@end