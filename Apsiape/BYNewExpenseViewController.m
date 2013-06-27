//
//  BYNewExpenseViewController.m
//  Apsiape
//
//  Created by Dario Lass on 28.05.13.
//  Copyright (c) 2013 Bytolution. All rights reserved.
//

#import "BYNewExpenseViewController.h"
#import "BYQuickShotView.h"
#import "BYExpenseKeyboard.h"
#import "Expense.h"
#import "BYStorage.h"

@interface BYNewExpenseViewController () <BYQuickShotViewDelegate>

@property (nonatomic, strong) UINavigationBar *headerBar;
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (nonatomic, strong) UIImage *capturedPhoto;
@property (nonatomic, strong) BYQuickShotView *quickShotView;

- (void)dismiss;

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
        self.view.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.view addSubview:self.headerBar];
    [self.headerBar setBackgroundImage:[UIImage imageNamed:@"Header_Bar.png"] forBarMetrics:UIBarMetricsDefault];
    UIBarButtonItem *mapButton = [[UIBarButtonItem alloc]initWithTitle:@"Gnarl" style:UIBarButtonItemStyleBordered target:self action:@selector(dismiss)];
    UINavigationItem *navItem = [[UINavigationItem alloc]init];
    navItem.rightBarButtonItem = mapButton;
    [self.headerBar pushNavigationItem:navItem animated:YES];
    self.quickShotView = [[BYQuickShotView alloc]initWithFrame:CGRectMake(0, 120, 320, 428)];
    self.quickShotView.delegate = self;
//    [self.view addSubview:self.quickShotView];
    self.textField.font = [UIFont fontWithName:@"Miso-Light" size:55];
    self.textField.textColor = [UIColor darkTextColor];
    BYExpenseKeyboard *keyboard = [[BYExpenseKeyboard alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height/2 + 40, 320, self.view.frame.size.height/2 - 40)];
    [self.view addSubview:keyboard];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    if (self.textField.text.length != 0) {
        Expense *newExpense = [NSEntityDescription insertNewObjectForEntityForName:@"Expense" inManagedObjectContext:[[BYStorage sharedStorage]managedObjectContext]];
        newExpense.value = self.textField.text;
        newExpense.image = self.capturedPhoto;
        [[BYStorage sharedStorage]saveDocument];
    }
}

- (void)didTakeSnapshot:(UIImage *)img
{
    self.capturedPhoto = img;
}
- (void)didDiscardLastImage
{
    self.capturedPhoto = nil;
}
- (void)quickShotViewDidFinishPreparation:(BYQuickShotView *)quickShotView
{
    
}

- (void)dismiss
{
    [self.view removeFromSuperview];
}

- (void)viewDidUnload {
    [self setTextField:nil];
    [super viewDidUnload];
}

@end
