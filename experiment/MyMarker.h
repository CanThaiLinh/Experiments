#import "GMSMarker.h"

@interface MyMarker : GMSMarker
@property (nonatomic) BOOL isCluster;
@property (nonatomic) BOOL isSelected;

@property(nonatomic, copy) NSString *text;

- (instancetype)initWithIsCluster:(BOOL)isCluster;

- (instancetype)initWithIsCluster:(BOOL)isCluster text:(NSString *)text;

+ (instancetype)markerWithIsCluster:(BOOL)isCluster text:(NSString *)text;


- (void)buildIcon;
@end