//
//  BYExpenseInputViewController.m
//  Apsiape
//
//  Created by Dario Lass on 30.03.13.
//  Copyright (c) 2013 Bytolution. All rights reserved.
//

#import "BYExpenseInputViewController.h"
#import "BYExpenseKeyboard.h"
#import "InterfaceConstants.h"

@interface BYExpenseInputViewController ()

@end

@implementation BYExpenseInputViewController

- (void)viewDidLoad {
    self.view.backgroundColor = [UIColor blueColor];
    
    
}

- (void)viewDidAppear:(BOOL)animated {
    BYExpenseKeyboard *kb = [[BYExpenseKeyboard alloc]initWithFrame:CGRectMake(0, self.view.bounds.size.height - KEYBOARD_HEIGHT, 320, KEYBOARD_HEIGHT)];
    [self.view addSubview:kb];
}

@end
