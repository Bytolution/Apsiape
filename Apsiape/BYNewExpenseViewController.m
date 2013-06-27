//
//  BYNewExpenseViewController.m
//  Apsiape
//
//  Created by Dario Lass on 28.05.13.
//  Copyright (c) 2013 Bytolution. All rights reserved.
//

#import "BYNewExpenseViewController.h"
#import "BYQuickShotView.h"

@interface BYNewExpenseViewController ()

@property (nonatomic, strong) UINavigationBar *headerBar;
@property (weak, nonatomic) IBOutlet UITextField *textField;

@end

@implementation BYNewExpenseViewController

- (UINavigationBar *)headerBar
{
    if (!_headerBar) {
        _headerBar = [[UINavigationBar alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 50)];
    }
    return _headerBar;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.view.backgroundColor = [UIColor blackColor];
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.view addSubview:self.headerBar];
    [self.headerBar setBackgroundImage:[UIImage imageNamed:@"Layout_0000_Header-Bar.png"] forBarMetrics:UIBarMetricsDefault];
    
    BYQuickShotView *quickShotView = [[BYQuickShotView alloc]initWithFrame:CGRectMake(16, 145, 288, 288)];
    [self.view addSubview:quickShotView];
    self.textField.font = [UIFont fontWithName:@"Miso-Light" size:55];
    self.textField.textColor = [UIColor darkTextColor];
}


- (void)viewDidUnload {
    [self setTextField:nil];
    [super viewDidUnload];
}
@end
