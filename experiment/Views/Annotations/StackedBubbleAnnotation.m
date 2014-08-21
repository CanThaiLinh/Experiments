#import "StackedBubbleAnnotation.h"
#import "TextDrawer.h"

@implementation StackedBubbleAnnotation

- (UIImage *)buildImage {
    const int FONT_SIZE = 14;
    CGSize textFrame = [TextDrawer sizeOfText:@"AAAA" fontSize:FONT_SIZE];
    int offset = 2;
    int roundedRectangleHeight = (int) (textFrame.height * 1.5);
    int roundedRectangleWidth = (int) (textFrame.width + 12);

    CGRect rect = CGRectMake(0, 0, roundedRectangleWidth + 2 * offset, roundedRectangleHeight + 2 * offset);
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0);

    CGRect roundedRectangleRect = CGRectMake(0, 0, roundedRectangleWidth, roundedRectangleHeight);
    [self drawRectangleStack:roundedRectangleRect offset:offset];

    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

- (void)drawRectangleStack:(CGRect)roundedRectangleRect offset:(int)offset {
    [self drawRoundedRect:roundedRectangleRect];
    for (int i = 1; i <= 2; i++) {
        roundedRectangleRect.origin = CGPointMake(roundedRectangleRect.origin.x + offset, roundedRectangleRect.origin.x + offset);
        [self drawRoundedRect:roundedRectangleRect];
    }
}

- (UIColor *)currentColor {
    return [UIColor purpleColor];
}

@end