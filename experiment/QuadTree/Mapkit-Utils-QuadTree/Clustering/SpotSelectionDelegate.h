#import <Foundation/Foundation.h>

@class Spot;

@protocol SpotSelectionDelegate <NSObject>

- (void)didSelectSpot:(Spot *)spot;
@end