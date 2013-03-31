//
//  BYExpenseInputViewController.m
//  Apsiape
//
//  Created by Dario Lass on 30.03.13.
//  Copyright (c) 2013 Bytolution. All rights reserved.
//

#import "BYExpenseInputViewController.h"
#import "BYExpenseKeyboard.h"

@interface BYExpenseInputViewController ()

@end

@implementation BYExpenseInputViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	BYExpenseKeyboard *keyboard = [[BYExpenseKeyboard alloc]initWithFrame:CGRectMake(0, 0, 320, 300)];
    [self.view addSubview:keyboard];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
