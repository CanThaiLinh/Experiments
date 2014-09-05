#import <Foundation/Foundation.h>

@class Spot;

@protocol SpotSelectionDelegate <NSObject>

- (void)didSelectSpot:(Spot *)spot;

- (void)didSwipeToSpot: (Spot *)spot;
@end