#import "MyAnnotation.h"

@implementation MyAnnotation

- (instancetype)initWithTitle:(NSString *)title coordinate:(CLLocationCoordinate2D)coordinate {
    self = [super init];
    if (self) {
        self.title = title;
        self.coordinate = coordinate;
    }

    return self;
}

+ (instancetype)annotationWithTitle:(NSString *)title coordinate:(CLLocationCoordinate2D)coordinate {
    return [[self alloc] initWithTitle:title coordinate:coordinate];
}


@end