#import "MyMarker.h"

@implementation MyMarker

- (instancetype)initWithData:(NSArray *)data isBubble:(BOOL)isBubble {
    self = [super init];
    if (self) {
        self.data = data;
        self.isBubble = isBubble;
    }

    return self;
}

@end