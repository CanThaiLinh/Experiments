#import "ShadeView.h"

@implementation ShadeView

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    return [self pointInside:point withEvent:event] ? self.scrollView : nil;
}

@end