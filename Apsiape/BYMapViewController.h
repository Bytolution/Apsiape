//
//  BYMapViewController.h
//  Apsiape
//
//  Created by Dario Lass on 05.08.13.
//  Copyright (c) 2013 Bytolution. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BYViewController.h"

@class MKMapView;

@interface BYMapViewController : BYViewController

@property (nonatomic, strong) MKMapView *mapView;

@end
