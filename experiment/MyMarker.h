#import <MapKit/MapKit.h>
#import "GMSMarker.h"

@class SpotData;
@class Spot;

@interface MyMarker : NSObject <MKAnnotation>
@property(nonatomic) CLLocationCoordinate2D coordinate;

@property(nonatomic, strong) Spot *spot;

@property(nonatomic) BOOL isBubble;

@property(nonatomic) BOOL isSelected;

- (instancetype)initWithSpot:(Spot *)spot isBubble:(BOOL)isBubble;


@end