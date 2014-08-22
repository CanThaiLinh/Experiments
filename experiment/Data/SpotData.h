@interface SpotData : NSObject
@property(nonatomic, strong) NSString *shortName;
@property(nonatomic, strong) NSString *name;
@property(nonatomic, strong) NSDecimalNumber *price;
@property(nonatomic, strong) NSDecimalNumber *change;
@property(nonatomic) int priority;

- (instancetype)initWithShortName:(NSString *)shortName name:(NSString *)name price:(NSDecimalNumber *)price change:(NSDecimalNumber *)change priority:(int)priority;

- (NSDecimalNumber *)percentChange;
@end