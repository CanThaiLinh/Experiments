#import "SpotDataColors.h"
#import "SpotData.h"

@implementation SpotDataColors

+ (UIColor *)colorFor:(SpotData *)data {
    if ([data.change compare:[NSDecimalNumber zero]] == NSOrderedAscending) {
        return [UIColor redColor];
    }
    else {
        return [UIColor colorWithRed:0 green:0.5 blue:0 alpha:1];
    }
}

+ (UIColor *)selectedColor {
    return [UIColor blueColor];
}

@end