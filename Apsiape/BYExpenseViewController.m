//
//  BYExpenseViewController.m
//  Apsiape
//
//  Created by Dario Lass on 17.03.13.
//  Copyright (c) 2013 Bytolution. All rights reserved.
//

#import <CoreData/CoreData.h>
#import "BYExpenseViewController.h"
#import "BYExpenseKeyboard.h"
#import "BYExpenseInputView.h"
#import "BYQuickShotView.h"
#import "Expense.h"
#import "BYStorage.h"

@interface BYExpenseViewController () <UIScrollViewDelegate, BYExpenseKeyboardDelegate, BYQuickShotViewDelegate, UIGestureRecognizerDelegate>

@property (nonatomic, strong) NSMutableString *expenseValue;
@property (nonatomic, strong) BYExpenseInputView *expenseInputView;
@property (nonatomic, strong) BYExpenseKeyboard *decimalKeyboard;
@property (nonatomic, strong) BYQuickShotView *quickShotView;
@property (nonatomic, strong) UIScrollView *mainScrollView;
@property (nonatomic, strong) UIScrollView *quickShotScrollView;
@property (nonatomic, strong) UIView *leftPullView;

- (void)setSubviewColors;
- (void)switchToQuickShotView;
- (void)switchToMainView;
- (void)swipeDetected:(UISwipeGestureRecognizer*)pan;

@end

@implementation BYExpenseViewController

#define KEYBOARD_HEIGHT 240


- (UIScrollView *)mainScrollView
{
    if (!_mainScrollView) _mainScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, 320, self.view.bounds.size.height - KEYBOARD_HEIGHT)];
    return _mainScrollView;
}

- (UIScrollView *)quickShotScrollView
{
    if (!_quickShotScrollView) _quickShotScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(- 320, 0, 320, self.view.bounds.size.height - KEYBOARD_HEIGHT)];
    return _quickShotScrollView;
}

- (BYExpenseInputView *)expenseInputView {
    if (!_expenseInputView) _expenseInputView = [[BYExpenseInputView alloc]initWithFrame:self.mainScrollView.bounds];
    return _expenseInputView;
}

- (BYExpenseKeyboard *)decimalKeyboard {
    if (!_decimalKeyboard) _decimalKeyboard = [[BYExpenseKeyboard alloc]initWithFrame:CGRectMake(0, self.view.bounds.size.height - KEYBOARD_HEIGHT, 320, KEYBOARD_HEIGHT)];
    return _decimalKeyboard;
}

- (NSNumber *)valueString {
    return [self.expenseValue copy];
}

- (NSMutableString *)expenseValue {
    if (!_expenseValue) _expenseValue = [[NSMutableString alloc]init];
    return _expenseValue;
}

- (void)viewDidAppear:(BOOL)animated
{
    UISwipeGestureRecognizer *sgr = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeDetected:)];
    [self.view addGestureRecognizer:sgr];
    UISwipeGestureRecognizer *ssgr = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeDetected:)];
    ssgr.direction = UISwipeGestureRecognizerDirectionLeft;
    [self.view addGestureRecognizer:ssgr];
    
    [self setSubviewColors];
    [self.view addSubview:self.mainScrollView];
    [self.view addSubview:self.decimalKeyboard];
    [self.view addSubview:self.quickShotScrollView];
    [self.mainScrollView addSubview:self.expenseInputView];
    self.mainScrollView.delegate = self;
    self.quickShotScrollView.delegate = self;
    self.decimalKeyboard.delegate = self;
    
    BYQuickShotView *qsv = [[BYQuickShotView alloc]initWithFrame:CGRectMake(0, 0, 320, self.quickShotScrollView.bounds.size.height)];
    [self.quickShotScrollView addSubview:qsv];
}

- (void)setSubviewColors
{
    self.decimalKeyboard.backgroundColor = [UIColor whiteColor];
    self.expenseInputView.backgroundColor = [UIColor whiteColor];
    self.expenseInputView.fontColor = [UIColor blackColor];
    self.decimalKeyboard.fontColor = [UIColor darkGrayColor];
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
    self.expenseInputView.text = self.expenseValue;
}

- (void)deleteKeyTapped
{
    if (self.expenseValue.length < 1) {
        return;
    } else {
        NSRange range = NSMakeRange(self.expenseValue.length - 1, 1);
        [self.expenseValue deleteCharactersInRange:range];
    }
    self.expenseInputView.text = self.expenseValue;
}

//----------------------------------------------------------------------------Scroll view implementation(pull control etc.)--------------------------------------------------------------------------//

#define PULL_CONTROL_WIDTH 60

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    //    if (scrollView.contentOffset.x > PULL_WIDTH && scrollView.contentOffset.x > 0) {
    //        // right
    //    } else if (scrollView.contentOffset.x < - PULL_WIDTH && scrollView.contentOffset.x < 0) {
    //
    //    }
}

//- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
//{
//    if (scrollView == self.mainScrollView) {
//        if (scrollView.contentOffset.x > PULL_CONTROL_WIDTH && scrollView.contentOffset.x > 0) {
//            NSLog(@"right");
//        } else if (scrollView.contentOffset.x < - PULL_CONTROL_WIDTH && scrollView.contentOffset.x < 0) {
//            NSLog(@"left");
//            [self switchToQuickShotView];
//        }
//    } else {
//        if (scrollView.contentOffset.x > PULL_CONTROL_WIDTH && scrollView.contentOffset.x > 0) {
//            [self switchToMainView];
//        } else if (scrollView.contentOffset.x < - PULL_CONTROL_WIDTH && scrollView.contentOffset.x < 0) {
//            NSLog(@"left");
//            
//        }
//    }
//}

- (void)swipeDetected:(UISwipeGestureRecognizer *)pan
{
    if (pan.direction == UISwipeGestureRecognizerDirectionRight) {
        [self switchToQuickShotView];
    } else {
        [self switchToMainView];
    }
}
- (void)switchToQuickShotView {
    [UIView animateWithDuration:0.4 animations:^{
        self.mainScrollView.frame = CGRectMake(320, 0, 320, self.view.frame.size.height - KEYBOARD_HEIGHT);
        self.quickShotScrollView.frame = CGRectMake(0, 0, 320, self.view.frame.size.height - KEYBOARD_HEIGHT);
    }];
}
- (void)switchToMainView {
    [UIView animateWithDuration:0.4 animations:^{
        self.mainScrollView.frame = CGRectMake(0, 0, 320, self.view.frame.size.height - KEYBOARD_HEIGHT);
        self.quickShotScrollView.frame = CGRectMake(- 320, 0, 320, self.view.frame.size.height - KEYBOARD_HEIGHT);
    }];
}

@end
