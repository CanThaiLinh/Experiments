#import "SpotData.h"

@implementation SpotData

- (instancetype)initWithShortName:(NSString *)shortName name:(NSString *)name price:(NSDecimalNumber *)price change:(NSDecimalNumber *)change priority:(int)priority {
    self = [super init];
    if (self) {
        self.shortName = shortName;
        self.name = name;
        self.price = price;
        self.change = change;
        self.priority = priority;
    }

    return self;
}

- (NSDecimalNumber *)percentChange {
    NSDecimalNumberHandler *scale = [NSDecimalNumberHandler decimalNumberHandlerWithRoundingMode:NSRoundPlain
                                                                                           scale:3
                                                                                raiseOnExactness:NO
                                                                                 raiseOnOverflow:NO
                                                                                raiseOnUnderflow:NO
                                                                             raiseOnDivideByZero:NO];
    NSDecimalNumber *percentChange = [[self.change decimalNumberByDividingBy:[self.price decimalNumberBySubtracting:self.change]]
            decimalNumberByMultiplyingBy:[NSDecimalNumber decimalNumberWithString:@"100"] withBehavior:scale];
    return percentChange;
}


@end