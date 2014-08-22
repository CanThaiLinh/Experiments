#import <MapKit/MapKit.h>
#import <Google-Maps-iOS-SDK/GoogleMaps/GMSMapView.h>
#import <Google-Maps-iOS-Utils-QuadTree/GClusterManager.h>
#import "MKClusterManager.h"
#import "DummyAnnotations.h"
#import "Spot.h"
#import "SpotData.h"

@implementation DummyAnnotations

- (void)addAnnotations:(MKClusterManager *)manager around:(CLLocationCoordinate2D)around {
    NSArray *dummyCoordinates = [self dummyCoordinatesFor:around];
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

        [manager addItem:spot];
    }
}

- (NSDecimalNumber *)randomChangeFromPrice:(NSDecimalNumber *)price {
    int change = arc4random() % ([[price decimalNumberByMultiplyingBy:[NSDecimalNumber decimalNumberWithString:@"100"]] intValue] * 5);
    NSDecimalNumber *changeDecimal = [NSDecimalNumber decimalNumberWithDecimal:[@(change / 100.0) decimalValue]];
    if (arc4random() % 2 == 0) {
        changeDecimal = [changeDecimal decimalNumberByMultiplyingBy:[NSDecimalNumber decimalNumberWithString:@"-1"]];
    }
    return changeDecimal;
}

- (NSString *)randomName {
    return [NSString stringWithFormat:@"%@ %@", [self randomStringOfLength:4 + arc4random() % 6], [self randomStringOfLength:4 + arc4random() % 6]];
}

- (NSDecimalNumber *)randomPrice {
    NSDecimalNumber *base = [NSDecimalNumber decimalNumberWithString:@"10"];
    int adjustment = arc4random() % 1000;
    int positiveOrNegative = arc4random() % 2 == 0 ? -1 : 1;
    NSNumber *numberAdjustment = @(adjustment * positiveOrNegative);
    return [base decimalNumberByAdding:[NSDecimalNumber decimalNumberWithDecimal:[numberAdjustment decimalValue]]];
}

- (NSArray *)dummyCoordinatesFor:(CLLocationCoordinate2D)center {
    NSMutableArray *coordinates = [@[] mutableCopy];
    for (int primaryLocation = 0; primaryLocation < 6; primaryLocation++) {
        CLLocationCoordinate2D primaryPoint = [self randomCoordinateNear:center withPrecision:0.0002];
        [coordinates addObject:[NSValue value:&primaryPoint withObjCType:@encode(CLLocationCoordinate2D)]];

        if (primaryLocation < 4) {
            for (int clusterLocation = 0; clusterLocation < 3; clusterLocation++) {
                CLLocationCoordinate2D clusterPoint = [self randomCoordinateNear:primaryPoint withPrecision:0.00005];
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