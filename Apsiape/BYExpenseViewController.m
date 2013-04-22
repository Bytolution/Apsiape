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
@property (nonatomic, strong) UIView *locatorView;
@property (nonatomic, strong) UIView *leftPullView;
@property (nonatomic) BOOL quickShotViewIsVisible;

- (void)setSubviewColors;

- (void)switchToQuickShotView;
- (void)switchToLocatorView;

- (void)dismissQuickShotView;
- (void)dismissLocatorView;

- (void)swipeDetected:(UISwipeGestureRecognizer*)pan;

@end

#define KEYBOARD_HEIGHT 240

@implementation BYExpenseViewController

//----------------------------------------------------------------------------------Creation getters-------------------------------------------------------------------------------//

- (BYExpenseKeyboard *)decimalKeyboard
{
    if (!_decimalKeyboard) _decimalKeyboard = [[BYExpenseKeyboard alloc]init];
    return _decimalKeyboard;
}
- (BYExpenseInputView *)expenseInputView
{
    if (!_expenseInputView) _expenseInputView = [[BYExpenseInputView alloc]init];
    return _expenseInputView;
}
- (BYQuickShotView *)quickShotView
{
    if (!_quickShotView) _quickShotView = [[BYQuickShotView alloc]init];
    return _quickShotView;
}
- (NSMutableString *)expenseValue
{
    if (!_expenseValue) _expenseValue = [[NSMutableString alloc]init];
    return _expenseValue;
}
- (UIView *)locatorView
{
    if (!_locatorView) _locatorView = [[UIView alloc]init];
    return _locatorView;
}
- (NSNumber *)valueString
{
    return [self.expenseValue copy];
}

//------------------------------------------------------------------------------------View setup------------------------------------------------------------------------------------//

- (void)viewDidAppear:(BOOL)animated
{
    // gesture recognizers
    UISwipeGestureRecognizer *sgr = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeDetected:)];
    [self.view addGestureRecognizer:sgr];
    UISwipeGestureRecognizer *ssgr = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeDetected:)];
    ssgr.direction = UISwipeGestureRecognizerDirectionLeft;
    [self.view addGestureRecognizer:ssgr];
    
    // adding subview 'expenseView'
    CGRect rect = self.view.bounds;
    rect.size.height -= KEYBOARD_HEIGHT;
    self.expenseInputView.frame = rect;
    [self.view addSubview:self.expenseInputView];
    
    // adding subview 'quickShotView'
    rect.origin.x -= self.view.frame.size.width;
    rect.size.height = rect.size.width;
    self.quickShotView.frame = rect;
    [self.view addSubview:self.quickShotView];
    
    // adding subview 'decimalKeyboard'
    self.decimalKeyboard.frame = CGRectMake(0, self.view.bounds.size.height - KEYBOARD_HEIGHT, 320, KEYBOARD_HEIGHT);
    [self.view addSubview:self.decimalKeyboard];
    
    // adding subview 'locatorView'
    self.locatorView.frame = CGRectMake(320, 0, 100, self.expenseInputView.bounds.size.height);
    [self.view addSubview:self.locatorView];
    
    // delegation
    self.decimalKeyboard.delegate = self;
    self.quickShotView.delegate = self;
    
    [self setSubviewColors];
    
    self.quickShotViewIsVisible = NO;
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

//-------------------------------------------------------------------------------------Gesture handling------------------------------------------------------------------------------------//

#define PULL_CONTROL_WIDTH 60
#define DURATION 0.6

- (void)swipeDetected:(UISwipeGestureRecognizer *)pan
{
    if (!self.quickShotViewIsVisible) {
        if (pan.direction == UISwipeGestureRecognizerDirectionLeft) {
            [self switchToLocatorView];
        } else {
            [self switchToQuickShotView];
        }
    } else {
        if (pan.direction == UISwipeGestureRecognizerDirectionLeft) {
            [self dismissQuickShotView];
        }
    }
}
- (void)switchToQuickShotView
{
    [UIView animateWithDuration:(DURATION/2) animations:^{
        self.decimalKeyboard.frame = CGRectMake(0, self.quickShotView.bounds.size.height, 320, KEYBOARD_HEIGHT);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:DURATION animations:^{
            self.quickShotView.frame = CGRectMake(0, 0, 320, 320);
            self.decimalKeyboard.backgroundColor = [UIColor grayColor];
            self.quickShotViewIsVisible = YES;
        }];
    }];
}

- (void)dismissQuickShotView
{
    [UIView animateWithDuration:DURATION animations:^{
        self.quickShotView.frame = CGRectMake(- 320, 0, 320, 320);
        self.decimalKeyboard.backgroundColor = [UIColor whiteColor];
        
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:(DURATION/2) animations:^{
            self.decimalKeyboard.frame = CGRectMake(0, self.view.bounds.size.height - KEYBOARD_HEIGHT, 320, KEYBOARD_HEIGHT);
            self.quickShotViewIsVisible = NO;
        }];
    }];
}

- (void)switchToLocatorView
{
    [UIView animateWithDuration:0.5 animations:^{
        self.locatorView.frame = CGRectMake(self.view.bounds.size.width - 100, 0, 100, self.expenseInputView.bounds.size.height);
    }];
    NSLog(@"%s", __PRETTY_FUNCTION__);
}

- (void)dismissLocatorView
{
    
}

//----------------------------------------------------------------------------QuickShotView delegate implementation--------------------------------------------------------------------------//

- (void)quickShotViewDidFinishPreparation:(BYQuickShotView *)quickShotView
{
    
}

- (void)didTakeSnapshot:(UIImage *)img
{
    
}

- (void)didDiscardLastImage
{
    
}

@end
