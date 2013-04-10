//
//  BYExpenseViewController.m
//  Apsiape
//
//  Created by Dario Lass on 17.03.13.
//  Copyright (c) 2013 Bytolution. All rights reserved.
//

#import "BYExpenseViewController.h"
#import "BYExpenseInputViewController.h"
#import "BYExpenseKeyboard.h"
#import "Expense.h"
#import "InterfaceConstants.h"
#import "BYAddPhotoViewController.h"
#import "BYAddLocationViewController.h"

@interface BYExpenseViewController ()

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) Expense *expense;
@property (nonatomic, strong) BYExpenseInputViewController *expenseInputViewController;
@property (nonatomic, strong) BYAddPhotoViewController *addPhotoViewController;
@property (nonatomic, strong) BYAddLocationViewController *addLocationViewController;

@end

@implementation BYExpenseViewController

- (UIScrollView *)scrollView {
    if (!_scrollView) _scrollView = [[UIScrollView alloc]init];
    return _scrollView;
}

- (BYExpenseInputViewController*)expenseInputViewController {
    if (!_expenseInputViewController) _expenseInputViewController = [[BYExpenseInputViewController alloc] init];
    return _expenseInputViewController;
}

- (BYAddPhotoViewController *)addPhotoViewController {
    if (!_addPhotoViewController) _addPhotoViewController = [[BYAddPhotoViewController alloc] init];
    return _addPhotoViewController;
}

- (BYAddLocationViewController *)addLocationViewController {
    if (!_addLocationViewController) _addLocationViewController = [[BYAddLocationViewController alloc]init];
    return _addLocationViewController;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor clearColor];
	// Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    // Setup of the scrollView
    self.scrollView.backgroundColor = [UIColor colorWithWhite:0.2 alpha:1];
    self.scrollView.frame = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height);
    self.scrollView.contentSize = CGSizeMake(self.scrollView.bounds.size.width * 3, self.scrollView.bounds.size.height);
    self.scrollView.pagingEnabled = YES;
    self.scrollView.bounces = NO;
    [self.view addSubview:self.scrollView];
    
    // Adding view controller No 1
    self.expenseInputViewController.view.frame = self.scrollView.bounds;
    [self.expenseInputViewController viewWillAppear:NO];
    [self.scrollView addSubview:self.expenseInputViewController.view];
    [self.expenseInputViewController viewDidAppear:NO];
    // No 2
    CGRect secondPageRect = self.scrollView.bounds;
    secondPageRect.origin.x = self.scrollView.bounds.size.width;
    self.addPhotoViewController.view.frame = secondPageRect;
    [self.addPhotoViewController viewWillAppear:NO];
    [self.scrollView addSubview:self.addPhotoViewController.view];
    [self.addPhotoViewController viewDidAppear:NO];
    // No 3
    CGRect thirdPageRect = self.scrollView.bounds;
    thirdPageRect.origin.x = self.scrollView.bounds.size.width * 2;
    self.addLocationViewController.view.frame = thirdPageRect;
    [self.addLocationViewController viewWillAppear:NO];
    [self.scrollView addSubview:self.addLocationViewController.view];
    [self.addLocationViewController viewDidAppear:NO];
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
