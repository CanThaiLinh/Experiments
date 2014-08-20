#import <Foundation/Foundation.h>

@protocol MKClusterRenderer <NSObject>

- (void)clustersChanged:(NSSet *)clusters atMaxZoom:(BOOL)zoom;

@end