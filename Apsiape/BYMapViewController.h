//
//  BYMapViewController.h
//  Apsiape
//
//  Created by Dario Lass on 05.08.13.
//  Copyright (c) 2013 Bytolution. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MKMapView;
@class Expense;

@interface BYMapViewController : UIViewController

@property (nonatomic, strong) Expense *expense;

@end
