#import <MapKit/MapKit.h>
#import "MyAnnotationView.h"

@interface BubbleAnnotation : MKAnnotationView<MyAnnotationView>

@property(nonatomic) int triangleWidth;

@property(nonatomic) int triangleHeight;

- (void)draw;

- (UIImage *)buildImage;

- (NSString *)getShortName;

- (void)drawRoundedRect:(CGRect)roundedRectangleRect;

- (void)drawBottomTriangle:(CGRect)fromRect withWidth:(int)width withHeight:(int)height;

- (CGRect)roundedRectangleRectFor:(CGSize)size bottomHeight:(int)bottomHeight;

- (UIColor *)currentColor;

@end