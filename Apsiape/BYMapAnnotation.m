//
//  BYMapAnnotation.m
//  Apsiape
//
//  Created by Dario Lass on 22.11.13.
//  Copyright (c) 2013 Bytolution. All rights reserved.
//

#import <MapKit/MapKit.h>
#import "BYMapAnnotation.h"

@implementation BYMapAnnotation 


- (CLLocationCoordinate2D)coordinate
{
    return self.coordinates;
}

- (NSString *)title
{
    return self.annotationTitle;
}

@end
