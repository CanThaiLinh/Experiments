#import "SpotData.h"

@implementation SpotData

- (instancetype)initWithShortName:(NSString *)shortName name:(NSString *)name price:(NSDecimalNumber *)price priority:(int)priority {
    self = [super init];
    if (self) {
        self.shortName = shortName;
        self.name = name;
        self.price = price;
        self.priority = priority;
    }

    return self;
}

@end