//
//  GDefaultClusterRenderer.h
//  Parkingmobility
//
//  Created by Colin Edwards on 1/18/14.
//  Copyright (c) 2014 Colin Edwards. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GoogleMaps/GoogleMaps.h>
#import "GClusterRenderer.h"

@class MKMapView;

@interface MKDefaultClusterRenderer : NSObject <GClusterRenderer> {
    MKMapView *map;
    NSMutableArray *markerCache;
}

- (id)initWithMap:(MKMapView*)mapView;

@end
