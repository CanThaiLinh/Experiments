#import "Colors.h"

@implementation Colors

+ (UIColor *)randomColor {
    CGFloat hue = (CGFloat) (arc4random() % 256 / 256.0);
    CGFloat saturation = (CGFloat) ((arc4random() % 128 / 256.0) + 0.5);
    CGFloat brightness = (CGFloat) ((arc4random() % 128 / 256.0) + 0.5);
    UIColor *color = [UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:1];
    return color;
}

@end