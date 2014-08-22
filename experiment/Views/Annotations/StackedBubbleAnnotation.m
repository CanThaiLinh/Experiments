#import "StackedBubbleAnnotation.h"
#import "TextDrawer.h"
#import "SpotData.h"
#import "MyMarker.h"
#import "SpotDataColors.h"

@implementation StackedBubbleAnnotation

- (UIImage *)buildImage {
    const int FONT_SIZE = 14;
    CGSize textFrame = [TextDrawer sizeOfText:[self getShortName] fontSize:FONT_SIZE];
    int offset = 2;
    int roundedRectangleHeight = (int) (textFrame.height * 1.5);
    int roundedRectangleWidth = (int) (textFrame.width + 12);

    CGRect rect = CGRectMake(0, 0, roundedRectangleWidth + 2 * offset, roundedRectangleHeight + 2 * offset + self.triangleHeight);
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0);

    CGRect roundedRectangleRect = CGRectMake(0, 0, roundedRectangleWidth, roundedRectangleHeight);
    CGRect finalRectangle = [self drawRectangleStack:roundedRectangleRect offset:offset];

    MyMarker *marker = self.annotation;
    [[SpotDataColors colorFor:marker.data[0]] setFill];
    [self drawBottomTriangle:finalRectangle withWidth:self.triangleWidth withHeight:self.triangleHeight];
    [TextDrawer writeText:[self getShortName] fontSize:FONT_SIZE inRect:finalRectangle];

    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

- (CGRect)drawRectangleStack:(CGRect)roundedRectangleRect offset:(int)offset {
    MyMarker *marker = self.annotation;
    for (int i = 0; i < 3; i++) {
        if (marker.data.count > i) {
            [[SpotDataColors colorFor:marker.data[(NSUInteger) i]] setFill];
        }
        if (i != 0) {
            roundedRectangleRect.origin = CGPointMake(roundedRectangleRect.origin.x + offset, roundedRectangleRect.origin.x + offset);
        }
        [self drawRoundedRect:roundedRectangleRect];
    }
    return roundedRectangleRect;
}

- (NSString *)getShortName {
    MyMarker *marker = self.annotation;
    SpotData *highestPriority = marker.data[0];
    return highestPriority.shortName;
}

@end