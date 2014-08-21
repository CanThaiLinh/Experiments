@interface SpotData : NSObject
@property(nonatomic, assign) NSString *shortName;
@property(nonatomic, assign) NSString *name;
@property(nonatomic, strong) NSDecimalNumber *price;

- (instancetype)initWithShortName:(NSString *)shortName name:(NSString *)name price:(NSDecimalNumber *)price;

@end