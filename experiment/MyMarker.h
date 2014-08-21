#import <MapKit/MapKit.h>
#import "GMSMarker.h"

@class SpotData;

@interface MyMarker : NSObject<MKAnnotation>
@property (nonatomic) CLLocationCoordinate2D coordinate;

@property(nonatomic, strong) NSArray *data;

@property(nonatomic) BOOL isBubble;

@property(nonatomic) BOOL isSelected;

@property(nonatomic, strong) UIImage *image;

- (instancetype)initWithData:(NSArray *)data isBubble:(BOOL)isBubble;


@end