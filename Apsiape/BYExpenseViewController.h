//
//  BYExpenseViewController.h
//  Apsiape
//
//  Created by Dario Lass on 17.03.13.
//  Copyright (c) 2013 Bytolution. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Expense;

@interface BYExpenseViewController : UIViewController

- (id)initWithExpense:(Expense*)expense;

@property (nonatomic, strong) UIViewController *containerViewController;

@end
