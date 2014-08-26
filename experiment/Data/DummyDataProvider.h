#import <CoreLocation/CoreLocation.h>

@interface DummyDataProvider : NSObject

@property(nonatomic) CLLocationCoordinate2D origin;

@property(nonatomic) NSMutableArray *data;

- (instancetype)initWithOrigin:(CLLocationCoordinate2D)origin;

- (void)retrieveData:(void (^)(NSArray *))callback count:(int)count;

@end