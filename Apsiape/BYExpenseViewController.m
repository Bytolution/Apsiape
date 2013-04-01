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
#import "BYQuickShotView.h"

@interface BYExpenseViewController ()

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) Expense *expense;
@property (nonatomic, strong) BYQuickShotView *quickShotView;
@property (nonatomic, strong) BYExpenseInputViewController *expenseInputViewController;

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

- (BYQuickShotView *)quickShotView {
    if (!_quickShotView) _quickShotView = [[BYQuickShotView alloc]init];
    return _quickShotView;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    return nil;
}

- (id)initWithExpense:(Expense *)expense
{
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        self.expense = expense;
        self.view.backgroundColor = [UIColor blackColor];
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
    
    self.scrollView.backgroundColor = [UIColor grayColor];
    self.scrollView.frame = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height);
    self.scrollView.contentSize = CGSizeMake(self.scrollView.bounds.size.width * 3, self.scrollView.bounds.size.height);
    [self.view addSubview:self.scrollView];
    
    BYExpenseInputViewController *eivc = [[BYExpenseInputViewController alloc]init];
    eivc.view.frame = self.scrollView.bounds;
    [eivc viewWillAppear:NO];
    [self.scrollView addSubview:eivc.view];
    [eivc viewDidAppear:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
