//
//  BYLocalizer.m
//  Apsiape
//
//  Created by Dario Lass on 23.07.13.
//  Copyright (c) 2013 Bytolution. All rights reserved.
//

#import "BYLocalizer.h"
#import <CoreLocation/CoreLocation.h>
#import "Constants.h"

@implementation BYLocalizer

+ (NSLocale*)currentAppLocale
{
    NSString *geoAppLocaleIdentifier = [[NSUserDefaults standardUserDefaults] objectForKey:@"BYApsiapeGeoAppLocaleIdentifier"];
    NSString *userPreferredAppLocaleIdentifier = [[NSUserDefaults standardUserDefaults] objectForKey:BYApsiapeUserPreferredAppLocaleIdentifier];
    
    if (userPreferredAppLocaleIdentifier) {
        return [[NSLocale alloc]initWithLocaleIdentifier:userPreferredAppLocaleIdentifier];
    } else if (geoAppLocaleIdentifier) {
        return [[NSLocale alloc]initWithLocaleIdentifier:geoAppLocaleIdentifier];
    } else {
        return [NSLocale currentLocale];
    }
}

+ (void)determineCurrentLocaleWithLocation:(CLLocation *)location
{
    CLGeocoder *geocoder = [[CLGeocoder alloc]init];
    [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {
        if ([placemarks objectAtIndex:0]) {
            CLPlacemark *placemark = placemarks[0];
            NSLocale *locale = [[NSLocale alloc]initWithLocaleIdentifier:[NSLocale localeIdentifierFromComponents:@{NSLocaleCountryCode : placemark.addressDictionary[@"CountryCode"]}]];
            [[NSUserDefaults standardUserDefaults] setObject:locale.localeIdentifier forKey:@"BYApsiapeGeoAppLocaleIdentifier"];
        }
    }];
}

+ (void)geocodeInfoStringForLocation:(CLLocation *)location completion:(void (^)(NSString *))completionHandler
{
    CLGeocoder *geocoder = [[CLGeocoder alloc]init];
    [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {
        CLPlacemark *addressPlacemark = placemarks[0];
        if (addressPlacemark) {
            if (addressPlacemark.addressDictionary[@"City"]) {
                completionHandler(addressPlacemark.addressDictionary[@"City"]);
            } else {
                completionHandler(addressPlacemark.addressDictionary[@"Country"]);
            }
        } else {
//            NSLog(@"%@", error);
        }
    }];
}

@end
