//
//  BYMapAnnotation.h
//  Apsiape
//
//  Created by Dario Lass on 22.11.13.
//  Copyright (c) 2013 Bytolution. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BYMapAnnotation : NSObject <MKAnnotation>

@property (nonatomic, readwrite) CLLocationCoordinate2D coordinates;

@property (nonatomic, strong) NSString *annotationTitle;

@end
