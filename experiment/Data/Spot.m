#import "Spot.h"
#import "SpotData.h"

@implementation Spot

- (instancetype)init {
    self = [super init];
    if (self) {
        self.data = [@[] mutableCopy];
    }

    return self;
}

- (CLLocationCoordinate2D)position {
    return self.location;
}

- (void)addData:(SpotData *)data {
    [self.data addObject:data];
    [self.data sortUsingComparator:^NSComparisonResult(SpotData *obj1, SpotData *obj2) {
        return [@(obj1.priority) compare:@(obj2.priority)];
    }];
}

@end