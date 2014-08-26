#import "DummyDataProvider.h"
#import "Spot.h"
#import "SpotData.h"

@implementation DummyDataProvider

- (instancetype)initWithOrigin:(CLLocationCoordinate2D)origin {
    self = [super init];
    if (self) {
        self.origin = origin;
    }

    return self;
}

- (void)retrieveData:(void (^)(NSArray *))callback count:(int)count {
    if (self.data == nil) {
        self.data = (NSMutableArray *) [@[] mutableCopy];
        NSArray *dummyCoordinates = [self dummyCoordinatesFor:self.origin count:count];
        for (int i = 0; i < [dummyCoordinates count]; i++) {
            CLLocationCoordinate2D value;
            [dummyCoordinates[i] getValue:&value];
            Spot *spot = [Spot new];
            spot.location = value;
            spot.priority = arc4random() % 50;

            BOOL hasStack = arc4random() % 4 == 0;
            int stackedAtThisPosition = hasStack ? arc4random() % 15 + 1 : 0;
            for (int stackedLocation = 0; stackedLocation <= stackedAtThisPosition; stackedLocation++) {
                int stackPriority = arc4random() % 50;
                NSDecimalNumber *price = [self randomPrice];
                [spot addData:[[SpotData alloc] initWithShortName:[self randomStringOfLength:arc4random() % 4 + 1]
                                                             name:[self randomName]
                                                            price:price
                                                           change:[self randomChangeFromPrice:price]
                                                         priority:stackPriority]];
                spot.priority = stackPriority > spot.priority ? stackPriority : spot.priority;
            }

            [self.data addObject:spot];
        }
    }

    callback(self.data);
}

- (NSDecimalNumber *)randomChangeFromPrice:(NSDecimalNumber *)price {
    int change = arc4random() % ([[price decimalNumberByMultiplyingBy:[NSDecimalNumber decimalNumberWithString:@"100"]] intValue] * 3);
    NSDecimalNumber *changeDecimal = [NSDecimalNumber decimalNumberWithDecimal:[@(change / 100.0) decimalValue]];
    if (arc4random() % 5 == 0) {
        changeDecimal = [changeDecimal decimalNumberByMultiplyingBy:[NSDecimalNumber decimalNumberWithString:@"-1"]];
    }

    if ([changeDecimal compare:price] == NSOrderedDescending) {
        changeDecimal = [changeDecimal decimalNumberByDividingBy:[NSDecimalNumber decimalNumberWithString:@"10"]];
    }
    return changeDecimal;
}

- (NSString *)randomName {
    return [NSString stringWithFormat:@"%@ %@", [self randomStringOfLength:4 + arc4random() % 6], [self randomStringOfLength:4 + arc4random() % 6]];
}

- (NSDecimalNumber *)randomPrice {
    NSNumber *pennies = @(arc4random() % 40000 + 1);
    return [[NSDecimalNumber decimalNumberWithDecimal:[pennies decimalValue]]
            decimalNumberByDividingBy:[NSDecimalNumber decimalNumberWithString:@"100"]];
}

- (NSArray *)dummyCoordinatesFor:(CLLocationCoordinate2D)center count:(int)count {
    NSMutableArray *coordinates = [@[] mutableCopy];
    for (int primaryLocation = 0; primaryLocation < count; primaryLocation++) {
        CLLocationCoordinate2D primaryPoint = [self randomCoordinateNear:center withPrecision:0.00015];
        [coordinates addObject:[NSValue value:&primaryPoint withObjCType:@encode(CLLocationCoordinate2D)]];

        if (primaryLocation < 4) {
            for (int clusterLocation = 0; clusterLocation < 3; clusterLocation++) {
                CLLocationCoordinate2D clusterPoint = [self randomCoordinateNear:primaryPoint withPrecision:0.00006];
                [coordinates addObject:[NSValue value:&clusterPoint withObjCType:@encode(CLLocationCoordinate2D)]];
            }
        }
    }
    return coordinates;
}

- (CLLocationCoordinate2D)randomCoordinateNear:(CLLocationCoordinate2D)nearPoint withPrecision:(double)precision {
    CLLocationCoordinate2D value;
    int randomValueLongitude = arc4random() % 6;
    int randomValueLatitude = arc4random() % 6;
    int positiveNegativeLongitude = arc4random() % 2 == 0 ? -1 : 1;
    int positiveNegativeLatitude = arc4random() % 2 == 0 ? -1 : 1;

    value.longitude = nearPoint.longitude + precision * randomValueLongitude * positiveNegativeLongitude;
    value.latitude = nearPoint.latitude + precision * randomValueLatitude * positiveNegativeLatitude;
    return value;
}

- (NSString *)randomStringOfLength:(int)length {
    NSString *alphabet = @"ABCDEFGHIJKLMNOPQRSTUVWXYZ";
    NSString *random = @"";
    for (int i = 0; i < length; i++) {
        random = [random stringByAppendingString:[alphabet substringWithRange:NSMakeRange(arc4random() % [alphabet length], 1)]];
    }
    return random;
}

@end