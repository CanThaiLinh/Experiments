#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>

@interface MyAnnotation : NSObject <MKAnnotation>

@property(nonatomic, copy) NSString *title;
@property(nonatomic, assign) CLLocationCoordinate2D coordinate;

- (instancetype)initWithTitle:(NSString *)title coordinate:(CLLocationCoordinate2D)coordinate;

+ (instancetype)annotationWithTitle:(NSString *)title coordinate:(CLLocationCoordinate2D)coordinate;

@end