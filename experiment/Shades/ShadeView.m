#import "ShadeView.h"
#import "ShadeScrollView.h"

@implementation ShadeView

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    UIView *hitView = [super hitTest:point withEvent:event];
    return hitView == self ? nil : hitView;
}

@end