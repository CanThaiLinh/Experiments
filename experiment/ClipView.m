#import "ClipView.h"

@implementation ClipView

- (id)init {
    self = [super init];
    if (self) {
        self.clipsToBounds = NO;
    }

    return self;
}


- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    return [self pointInside:point withEvent:event] ? self.scrollView : nil;
}

@end