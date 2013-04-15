//
//  BYLocator.h
//  Apsiape
//
//  Created by Dario Lass on 07.04.13.
//  Copyright (c) 2013 Bytolution. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface BYLocator : NSObject

- (void)startLocatingWithTimeout:(float)timeoutInSeconds;

@property (nonatomic, readonly) BOOL runnning;

@property (nonatomic, strong) CLLocation *latestLocationMeasurement;

@end
