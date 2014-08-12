#import "MyMarker.h"

@implementation MyMarker

- (instancetype)initWithIsCluster:(BOOL)isCluster {
    self = [super init];
    if (self) {
        self.isCluster = isCluster;
        [self buildIcon];
    }

    return self;
}

- (void)buildIcon {
    if (self.isCluster) {
        self.icon = [self generateClusterIcon];
    }
    else {
        self.icon = [self generateSingleIcon];
    }
}

- (void)setIsSelected:(BOOL)selected {
    if (_isSelected != selected) {
        _isSelected = selected;
        [self buildIcon];
    }
}

- (UIImage *)generateSingleIcon {
    int height = 25;
    int width = 40;
    CGRect rect = CGRectMake(0, 0, width, height);
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0);
    CGContextRef ctx = UIGraphicsGetCurrentContext();

    CGRect roundedRectangleRect = CGRectMake(0, 0, width, height);
    roundedRectangleRect = CGRectInset(roundedRectangleRect, 1, 1);

    [self drawRoundedRect:roundedRectangleRect];

    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    return image;
}

- (void)drawRoundedRect:(CGRect)roundedRectangleRect {
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:roundedRectangleRect byRoundingCorners:UIRectCornerAllCorners cornerRadii:CGSizeMake(5, 5)];
    if( [self isSelected]){
        [[UIColor blueColor] setFill];
    }
    else {
        [[UIColor colorWithRed:18.0f / 255.0f green:204.0f / 255.0f blue:64.0f / 255.0f alpha:1.0] setFill];
    }
    [path fill];
    [[UIColor whiteColor] setStroke];
    [path stroke];
}

- (UIImage *)generateClusterIcon {
    int diameter = 17;
    float inset = 1;

    CGRect rect = CGRectMake(0, 0, diameter, diameter);
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0);

    CGContextRef ctx = UIGraphicsGetCurrentContext();

    CGRect circleRect = CGRectMake(0, 0, diameter, diameter);
    circleRect = CGRectInset(circleRect, inset * 3, inset * 3);

    [self drawCircle:ctx circleRect:circleRect];
    [self drawStroke:inset ctx:ctx circleRect:circleRect];

    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    return image;
}

- (void)drawStroke:(float)inset ctx:(CGContextRef)ctx circleRect:(CGRect)circleRect {
    [[UIColor whiteColor] setStroke];
    CGContextSetLineWidth(ctx, inset);
    CGContextSetShadowWithColor(ctx, CGSizeMake(0, 1), 3.0, [UIColor blackColor].CGColor);
    CGContextStrokeEllipseInRect(ctx, circleRect);
}

- (void)drawCircle:(CGContextRef)ctx circleRect:(CGRect)circleRect {
    CGContextSetShadowWithColor(ctx, CGSizeMake(0, 1), 3.0, [UIColor grayColor].CGColor);
    [[UIColor colorWithRed:1 green:0 blue:0 alpha:1] setFill];
    CGContextFillEllipseInRect(ctx, circleRect);
}

@end