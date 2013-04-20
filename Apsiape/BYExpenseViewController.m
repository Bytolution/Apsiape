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
#import "BYAddPhotoViewController.h"
#import "BYAddLocationViewController.h"
#import "BYConclusionViewController.h"

@interface BYExpenseViewController () <UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) BYExpenseInputViewController *expenseInputViewController;
@property (nonatomic, strong) BYAddPhotoViewController *addPhotoViewController;
@property (nonatomic, strong) BYAddLocationViewController *addLocationViewController;
@property (nonatomic, strong) BYConclusionViewController *conclusionViewController;


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

- (BYAddPhotoViewController *)addPhotoViewController {
    if (!_addPhotoViewController) _addPhotoViewController = [[BYAddPhotoViewController alloc] init];
    return _addPhotoViewController;
}

- (BYAddLocationViewController *)addLocationViewController {
    if (!_addLocationViewController) _addLocationViewController = [[BYAddLocationViewController alloc]init];
    return _addLocationViewController;
}

- (BYConclusionViewController *)conclusionViewController {
    if (!_conclusionViewController) _conclusionViewController = [[BYConclusionViewController alloc]init];
    return _conclusionViewController;
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
    self.scrollView.contentSize = CGSizeMake(self.scrollView.bounds.size.width, self.scrollView.bounds.size.height * 4);
    self.scrollView.pagingEnabled = YES;
    self.scrollView.bounces = NO;
    self.scrollView.delegate = self;
    [self.view addSubview:self.scrollView];
    
    // Adding view controller No 1
    self.expenseInputViewController.view.frame = self.scrollView.bounds;
    [self.expenseInputViewController viewWillAppear:NO];
    [self.scrollView addSubview:self.expenseInputViewController.view];
    [self.expenseInputViewController viewDidAppear:NO];
    // No 2
    CGRect secondPageRect = self.scrollView.bounds;
    secondPageRect.origin.y = self.scrollView.bounds.size.height;
    self.addPhotoViewController.view.frame = secondPageRect;
    [self.addPhotoViewController viewWillAppear:NO];
    [self.scrollView addSubview:self.addPhotoViewController.view];
    [self.addPhotoViewController viewDidAppear:NO];
    // No 3
    CGRect thirdPageRect = self.scrollView.bounds;
    thirdPageRect.origin.y = self.scrollView.bounds.size.height * 2;
    self.addLocationViewController.view.frame = thirdPageRect;
    [self.addLocationViewController viewWillAppear:NO];
    [self.scrollView addSubview:self.addLocationViewController.view];
    [self.addLocationViewController viewDidAppear:NO];
    // No 4
    CGRect fourthPageRect = self.scrollView.bounds;
    fourthPageRect.origin.y = self.scrollView.bounds.size.height * 3;
    self.conclusionViewController.view.frame = fourthPageRect;
    [self.conclusionViewController viewWillAppear:NO];
    [self.scrollView addSubview:self.conclusionViewController.view];
    [self.conclusionViewController viewDidAppear:NO];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView.contentOffset.y == scrollView.contentSize.height * (3.0f/4.0f)) {
        [self scrollViewDidScrollToLastPage];
    }
}

- (void)scrollViewDidScrollToLastPage {
    self.conclusionViewController.view.backgroundColor = [UIColor greenColor];
    if (![self.expenseInputViewController.valueString isEqualToString:@""]) {
        NSManagedObjectContext *context = [BYStorage sharedStorage].managedObjectContext;
        Expense *newExpense = [NSEntityDescription insertNewObjectForEntityForName:@"Expense" inManagedObjectContext:context];
        newExpense.value = self.expenseInputViewController.valueString;
        newExpense.image = self.addPhotoViewController.capturedPhoto;
        newExpense.location = self.addLocationViewController.locationData;
        [[BYStorage sharedStorage] saveDocument];
    }
    
    [self.view removeFromSuperview];
}


@end
