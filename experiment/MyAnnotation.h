#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
#import <OCMapView/OCGrouping.h>

@interface MyAnnotation : NSObject <MKAnnotation, OCGrouping>

@property(nonatomic, copy) NSString *title;
@property(nonatomic, copy) NSString *groupTag;
@property(nonatomic, assign) CLLocationCoordinate2D coordinate;

- (instancetype)initWithTitle:(NSString *)title coordinate:(CLLocationCoordinate2D)coordinate;

+ (instancetype)annotationWithTitle:(NSString *)title coordinate:(CLLocationCoordinate2D)coordinate;

@end