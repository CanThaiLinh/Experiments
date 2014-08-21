#import <MapKit/MapKit.h>

@interface BubbleAnnotation : MKAnnotationView

- (UIImage *)buildImage;

- (NSString *)getShortName;

- (void)drawRoundedRect:(CGRect)roundedRectangleRect;

- (CGRect)roundedRectangleRectFor:(CGSize)size bottomHeight:(int)bottomHeight;

- (UIColor *)currentColor;

@end