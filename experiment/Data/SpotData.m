#import "SpotData.h"

@implementation SpotData

- (instancetype)initWithShortName:(NSString *)shortName name:(NSString *)name price:(NSDecimalNumber *)price {
    self = [super init];
    if (self) {
        self.shortName = shortName;
        self.name = name;
        self.price = price;
    }

    return self;
}

@end