#import "ShadeCell.h"
#import "SpotData.h"

@implementation ShadeCell

- (NSNumberFormatter *)formatter {
    if (_formatter == nil) {
        NSDecimalNumber *dn = [NSDecimalNumber decimalNumberWithString:@"1234.5"];
        NSNumberFormatter *nf = [[NSNumberFormatter alloc] init];
        [nf setMinimumFractionDigits:2];
        [nf setMaximumFractionDigits:2];
        _formatter = nf;
    }
    return _formatter;
}

- (void)setSpotData:(SpotData *)spotData {
    _spotData = spotData;

    [self.longName setText:self.spotData.name];
    [self.shortName setText:self.spotData.shortName];
    [self.fullAssociatedName setText:self.spotData.name];
    [self.price setText:[NSString stringWithFormat:@"$%@", [[self formatter] stringFromNumber:self.spotData.price]]];
    [self.change setText:[self changeText]];
}

- (NSString *)changeText {
    BOOL isChangeNegative = [self.spotData.change compare:[NSDecimalNumber zero]] == NSOrderedAscending;
    NSString *symbol = isChangeNegative ? @"-" : @"+";
    NSDecimalNumber *absoluteChange = isChangeNegative ?
            [self.spotData.change decimalNumberByMultiplyingBy:[NSDecimalNumber decimalNumberWithString:@"-1"]]
            : self.spotData.change;
    NSString *changeString = [NSString stringWithFormat:@"%@$%@", symbol, [[self formatter] stringFromNumber:absoluteChange]];

    NSDecimalNumber *absolutePercentChange = isChangeNegative ?
            [self.spotData.percentChange decimalNumberByMultiplyingBy:[NSDecimalNumber decimalNumberWithString:@"-1"]]
            : self.spotData.percentChange;
    NSString *percentChangeString = [NSString stringWithFormat:@"(%@%@%%)", symbol, [[self formatter] stringFromNumber:absolutePercentChange]];
    return [NSString stringWithFormat:@"%@ %@", changeString, percentChangeString];
}

@end