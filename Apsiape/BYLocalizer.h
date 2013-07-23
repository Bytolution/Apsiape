//
//  BYLocalizer.h
//  Apsiape
//
//  Created by Dario Lass on 23.07.13.
//  Copyright (c) 2013 Bytolution. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CLLocation;

@interface BYLocalizer : NSObject

+ (NSLocale*)currentLocaleBasedOnLocation:(CLLocation*)location;
+ (NSLocale*)defaultAppLocale;

@end
