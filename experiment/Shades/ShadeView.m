#import "ShadeView.h"
#import "ShadeScrollView.h"

@implementation ShadeView

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    return [self.scrollView pointInside:point withEvent:event];
}


@end