#import "MyMarker.h"
#import "TextDrawer.h"

@implementation MyMarker

- (instancetype)initWithIsBubble:(BOOL)isBubble text:(NSString *)text {
    self = [super init];
    if (self) {
        self.isBubble = isBubble;
        self.text = text;
    }

    return self;
}

@end