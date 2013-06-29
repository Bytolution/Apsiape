//
//  BYNewExpenseViewController.m
//  Apsiape
//
//  Created by Dario Lass on 28.05.13.
//  Copyright (c) 2013 Bytolution. All rights reserved.
//
#import <QuartzCore/QuartzCore.h>
#import "BYNewExpenseViewController.h"
#import "BYQuickShotView.h"
#import "BYExpenseKeyboard.h"
#import "Expense.h"
#import "BYStorage.h"

@interface BYNewExpenseViewController () <BYQuickShotViewDelegate, BYExpenseKeyboardDelegate>

@property (nonatomic, strong) UINavigationBar *headerBar;
@property (nonatomic, strong) UIImage *capturedPhoto;
@property (nonatomic, strong) BYQuickShotView *quickShotView;
@property (nonatomic, strong) NSMutableString *expenseValue;
@property (nonatomic, strong) UILabel *expenseValueLabel;

- (void)dismiss;

@end

@implementation BYNewExpenseViewController

#define KEYBOARD_HEIGHT 240

- (UINavigationBar *)headerBar
{
    if (!_headerBar) {
        _headerBar = [[UINavigationBar alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 50)];
    }
    return _headerBar;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.expenseValue = [[NSMutableString alloc]initWithCapacity:30];
    
    self.expenseValueLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 60, 300, 80)];
    self.expenseValueLabel.textAlignment = NSTextAlignmentRight;
    NSAttributedString *attrString = [[NSAttributedString alloc]initWithString:@"Enter value" attributes:@{NSForegroundColorAttributeName : [UIColor grayColor]}];
    self.expenseValueLabel.attributedText = attrString;
    [self.view addSubview:self.expenseValueLabel];
    self.expenseValueLabel.font = [UIFont fontWithName:@"Miso-Light" size:60];
    
    CALayer *stripeLayer = [CALayer layer];
    CGSize labelSize = self.expenseValueLabel.bounds.size;
    stripeLayer.frame = CGRectMake(labelSize.width - 2, 0, 2, labelSize.height);
    stripeLayer.backgroundColor = [UIColor colorWithRed:0.2 green:0.2 blue:1 alpha:1].CGColor;
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    animation.fromValue = [NSNumber numberWithFloat:1.0];
    animation.fromValue = [NSNumber numberWithFloat:0.0];
    animation.autoreverses = YES;
    animation.repeatCount = 30;
    animation.duration = 0.5;
    
    [stripeLayer addAnimation:animation forKey:@"opacityAnimation"];
    [self.expenseValueLabel.layer addSublayer:stripeLayer];
    
    [self.view addSubview:self.headerBar];
    [self.headerBar setBackgroundImage:[UIImage imageNamed:@"Header_Bar.png"] forBarMetrics:UIBarMetricsDefault];
    self.headerBar.tintColor = [UIColor whiteColor];
    UIBarButtonItem *mapButton = [[UIBarButtonItem alloc]initWithTitle:@"Gnarl" style:UIBarButtonItemStyleBordered target:self action:@selector(dismiss)];
    UINavigationItem *navItem = [[UINavigationItem alloc]init];
    navItem.rightBarButtonItem = mapButton;
    [self.headerBar pushNavigationItem:navItem animated:YES];
    BYExpenseKeyboard *keyboard = [[BYExpenseKeyboard alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height - KEYBOARD_HEIGHT, 320, KEYBOARD_HEIGHT)];
    keyboard.delegate = self;
    [self.view addSubview:keyboard];
}

- (void)numberKeyTapped:(NSString *)numberString
{
    NSRange decSeparatorRange = [self.expenseValue rangeOfString:@"."];
    if (decSeparatorRange.length == 1) {
        if (decSeparatorRange.location < self.expenseValue.length - 2) return;
        if ([numberString isEqualToString:@"."]) return;
    }
    if (self.expenseValue.length == 7) return;
    
    [self.expenseValue appendString:numberString];
    self.expenseValueLabel.text = self.expenseValue;
}

- (void)deleteKeyTapped
{
    if (self.expenseValue.length < 1) {
        return;
    } else {
        NSRange range = NSMakeRange(self.expenseValue.length - 1, 1);
        [self.expenseValue deleteCharactersInRange:range];
    }
    self.expenseValueLabel.text = self.expenseValue;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    if (self.expenseValue.length != 0) {
        Expense *newExpense = [NSEntityDescription insertNewObjectForEntityForName:@"Expense" inManagedObjectContext:[[BYStorage sharedStorage]managedObjectContext]];
        newExpense.value = self.expenseValue;
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
    //Halleluja
}

- (void)dismiss
{
    [self.view removeFromSuperview];
}

- (void)viewDidUnload {
    [super viewDidUnload];
}

@end
