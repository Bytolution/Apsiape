//
//  BYDetailViewController.h
//  Apsiape
//
//  Created by Dario Lass on 26.10.13.
//  Copyright (c) 2013 Bytolution. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Expense;

@interface BYDetailViewController : UIViewController

@property (nonatomic, strong) Expense *expense;

@end
