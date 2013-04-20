//
//  BYExpenseViewController.m
//  Apsiape
//
//  Created by Dario Lass on 17.03.13.
//  Copyright (c) 2013 Bytolution. All rights reserved.
//

#import <CoreData/CoreData.h>
#import "BYExpenseViewController.h"
#import "BYExpenseInputViewController.h"
#import "Expense.h"
#import "BYStorage.h"

@interface BYExpenseViewController () <UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) BYExpenseInputViewController *expenseInputViewController;


- (void)scrollViewDidScrollToLastPage;


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

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
	// Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    // Setup of the scrollView
    self.scrollView.frame = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height);
    self.scrollView.contentSize = CGSizeMake(self.scrollView.bounds.size.width, self.scrollView.bounds.size.height);
    self.scrollView.pagingEnabled = YES;
    self.scrollView.bounces = NO;
    self.scrollView.delegate = self;
    [self.view addSubview:self.scrollView];
    
    // Adding view controller No 1
    self.expenseInputViewController.view.frame = self.scrollView.bounds;
    [self.expenseInputViewController viewWillAppear:NO];
    [self.scrollView addSubview:self.expenseInputViewController.view];
    [self.expenseInputViewController viewDidAppear:NO];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView.contentOffset.y == scrollView.contentSize.height * (3.0f/4.0f)) {
        [self scrollViewDidScrollToLastPage];
    }
}


@end
