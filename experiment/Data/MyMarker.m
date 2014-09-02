#import "MyMarker.h"
#import "Spot.h"

@implementation MyMarker

- (instancetype)initWithSpot:(Spot *)spot isBubble:(BOOL)isBubble {
    self = [super init];
    if (self) {
        self.spot = spot;
        self.isBubble = isBubble;
    }

    return self;
}

@end