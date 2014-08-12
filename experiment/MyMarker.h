#import "GMSMarker.h"

@interface MyMarker : GMSMarker
@property (nonatomic) BOOL isCluster;
@property (nonatomic) BOOL isSelected;

- (instancetype)initWithIsCluster:(BOOL)isCluster;

- (void)buildIcon;
@end