//
//  BYExpenseViewController.m
//  Apsiape
//
//  Created by Dario Lass on 17.03.13.
//  Copyright (c) 2013 Bytolution. All rights reserved.
//

#import "BYExpenseViewController.h"
#import "BYExpenseView.h"
#import "Expense.h"
#import "BYSnapshotView.h"

@interface BYExpenseViewController ()

@property (nonatomic, strong) BYExpenseView *expenseView;
@property (nonatomic, strong) Expense *expense;
@property (nonatomic, strong) BYSnapshotView *snapshotView;

@end

@implementation BYExpenseViewController

- (BYExpenseView *)expenseView {
    if (!_expenseView) _expenseView = [[BYExpenseView alloc]init];
    return _expenseView;
}

- (id)initWithExpense:(Expense *)expense
{
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        self.view = self.expenseView;
        self.expense = expense;
        self.expenseView.contentSize = CGSizeMake(320, 1000);
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
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
