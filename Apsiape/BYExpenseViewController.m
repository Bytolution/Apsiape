//
//  BYExpenseViewController.m
//  Apsiape
//
//  Created by Dario Lass on 17.03.13.
//  Copyright (c) 2013 Bytolution. All rights reserved.
//

#import "BYExpenseViewController.h"
#import "Expense.h"
#import "BYSnapshotView.h"
#import "BYExpenseKeyboardView.h"
#import "InterfaceConstants.h"

@interface BYExpenseViewController ()

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) Expense *expense;
@property (nonatomic, strong) BYSnapshotView *snapshotView;

@end

@implementation BYExpenseViewController

- (UIScrollView *)scrollView {
    if (!_scrollView) _scrollView = [[UIScrollView alloc]init];
    return _scrollView;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    return nil;
}

- (id)initWithExpense:(Expense *)expense
{
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        self.expense = expense;
        self.scrollView.contentSize = CGSizeMake(320, 1000);
        self.scrollView.backgroundColor = [UIColor blackColor];
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
    [self.view addSubview:self.scrollView];
    self.scrollView.frame = self.view.bounds;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
