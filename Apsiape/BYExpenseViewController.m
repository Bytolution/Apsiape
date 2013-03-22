//
//  BYExpenseViewController.m
//  Apsiape
//
//  Created by Dario Lass on 17.03.13.
//  Copyright (c) 2013 Bytolution. All rights reserved.
//

#import "BYExpenseViewController.h"
#import "BYExpenseInputView.h"
#import "Expense.h"
#import "BYSnapshotView.h"
#import "InterfaceConstants.h"

@interface BYExpenseViewController ()

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) Expense *expense;
@property (nonatomic, strong) BYSnapshotView *snapshotView;
@property (nonatomic, strong) BYExpenseInputView *expenseInputView;

@end

@implementation BYExpenseViewController

- (UIScrollView *)scrollView {
    CGFloat scrollViewHeight = self.view.frame.size.height - self.expenseInputView.frame.size.height;
    if (!_scrollView) _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, self.expenseInputView.frame.size.height, self.view.frame.size.width, scrollViewHeight)];
    return _scrollView;
}

- (BYExpenseInputView *)expenseInputView {
    if (!_expenseInputView) _expenseInputView = [[BYExpenseInputView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, EXPENSE_INPUT_VIEW_HEIGHT)];
    return _expenseInputView;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    return nil;
}

- (id)initWithExpense:(Expense *)expense
{
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        self.expense = expense;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.view addSubview:self.expenseInputView];
    [self.view addSubview:self.scrollView];
    
    self.scrollView.contentSize = CGSizeMake(320, 1000);
    self.scrollView.backgroundColor = [UIColor whiteColor];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
