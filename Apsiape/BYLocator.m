//
//  BYLocator.m
//  Apsiape
//
//  Created by Dario Lass on 07.04.13.
//  Copyright (c) 2013 Bytolution. All rights reserved.
//

#import "BYLocator.h"
#import <CoreLocation/CoreLocation.h>

@interface BYLocator () <CLLocationManagerDelegate>

@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic) BOOL locationManagerIsUpdatingPosition;

@end

@implementation BYLocator

- (BOOL)runnning {
    return self.locationManagerIsUpdatingPosition;
}

- (CLLocationManager *)locationManager {
    if (!_locationManager) {
        _locationManager = [[CLLocationManager alloc]init];
        _locationManager.delegate = self;
        _locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation;
    }
    return _locationManager;
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    NSLog(@"%@", manager.location);
}
- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    NSLog(@"authorization status: %u", status);
}


@end
