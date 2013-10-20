//
//  BYExpenseCreationViewController.m
//  Apsiape
//
//  Created by Dario Lass on 28.05.13.
//  Copyright (c) 2013 Bytolution. All rights reserved.
//
#import <QuartzCore/QuartzCore.h>
#import "BYExpenseCreationViewController.h"
#import "UIImage+Adjustments.h"
#import "BYQuickShotView.h"
#import "BYExpenseKeyboard.h"
#import "Expense.h"
#import "BYStorage.h"
#import "BYCursorLabel.h"
#import "BYPullScrollView.h"
#import "BYCollectionViewController.h"
#import "BYLocalizer.h"
#import "InterfaceDefinitions.h"

@interface BYExpenseCreationViewController () <BYQuickShotViewDelegate, BYExpenseKeyboardDelegate, BYPullScrollViewDelegate>

@property (nonatomic, strong) BYQuickShotView *quickShotView;
@property (nonatomic, strong) NSMutableString *expenseValueRawString;
@property (nonatomic, strong) BYCursorLabel *expenseValueLabel;

- (NSString*)expenseValueCurrencyFormattedString;
- (NSNumber*)expenseValueDecimalNumber;

@end

@implementation BYExpenseCreationViewController

#define KEYBOARD_HEIGHT 240

- (void)viewWillAppear:(BOOL)animated
{
    self.view.backgroundColor = [UIColor clearColor];
    
    BYPullScrollView *pullScrollView = [[BYPullScrollView alloc]initWithFrame:self.view.bounds];
    pullScrollView.pullScrollViewDelegate = self;
    
    [self.view addSubview:pullScrollView];
    
    self.expenseValueRawString = [[NSMutableString alloc]initWithCapacity:30];
    
    BYExpenseKeyboard *keyboard = [[BYExpenseKeyboard alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height - KEYBOARD_HEIGHT, self.view.frame.size.width, KEYBOARD_HEIGHT)];
    self.expenseValueLabel = [[BYCursorLabel alloc]initWithFrame:CGRectMake(10, 30, self.view.bounds.size.width - 20, 80)];
    self.expenseValueLabel.backgroundColor = [UIColor clearColor];
    self.expenseValueLabel.textColor = [UIColor whiteColor];
    [pullScrollView.childScrollView addSubview:self.expenseValueLabel];
    keyboard.delegate = self;
    [pullScrollView.childScrollView addSubview:keyboard];
    
    CGRect rect = CGRectInset(pullScrollView.bounds, 0, ((pullScrollView.frame.size.height - pullScrollView.frame.size.width) / 2));
    rect.origin.x = (pullScrollView.frame.size.width);
    
    self.quickShotView = [[BYQuickShotView alloc]initWithFrame:CGRectInset(rect, 10, 10)];
    self.quickShotView.delegate = self;
    [pullScrollView.childScrollView addSubview:self.quickShotView];
    pullScrollView.backgroundColor = [UIColor clearColor];
    pullScrollView.childScrollView.backgroundColor = [UIColor clearColor];
    rect.origin.x = (pullScrollView.frame.size.width * 2);
}

#pragma mark Text Input Handling

- (NSNumber*)expenseValueDecimalNumber
{
    return [NSNumber numberWithFloat:self.expenseValueRawString.floatValue];
}

- (NSString *)expenseValueCurrencyFormattedString
{
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc]init];
    [formatter setLocale:[BYLocalizer currentAppLocale]];
    formatter.numberStyle = NSNumberFormatterCurrencyStyle;
    return [formatter stringFromNumber:[NSNumber numberWithFloat:self.expenseValueRawString.floatValue]];
}

- (void)numberKeyTapped:(NSString *)numberString
{
    NSRange decSeparatorRange = [self.expenseValueRawString rangeOfString:@"."];
    if (decSeparatorRange.length == 1) {
        if (decSeparatorRange.location == self.expenseValueRawString.length - 3) return;
        if ([numberString isEqualToString:@"."]) return;
    }
    [self.expenseValueRawString appendString:numberString];
    self.expenseValueLabel.text = self.expenseValueCurrencyFormattedString;
}

- (void)deleteKeyTapped
{
    if (self.expenseValueRawString.length < 1) {
        return;
    } else {
        NSRange range = NSMakeRange(self.expenseValueRawString.length - 1, 1);
        [self.expenseValueRawString deleteCharactersInRange:range];
    }
    self.expenseValueLabel.text = self.expenseValueCurrencyFormattedString;
}

#pragma mark Delegation (PullScrollView)

- (void)pullScrollView:(UIScrollView *)pullScrollView didDetectPullingAtEdge:(BYEdgeType)edge
{
    if (edge == BYEdgeTypeBottom || edge == BYEdgeTypeLeft) {
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
        [self dismissViewControllerAnimated:NO completion:^{
            
        }];
    } else if ((edge == BYEdgeTypeRight || edge == BYEdgeTypeTop) && self.expenseValueRawString.length != 0){
        [[BYStorage sharedStorage] saveExpenseObjectWithStringValue:self.expenseValueCurrencyFormattedString
                                                        numberValue:self.expenseValueDecimalNumber
                                                       fullResImage:self.quickShotView.fullResCapturedImage
                                                         completion:^(BOOL success) {
//                                                             NSLog(@"Expense saving completion handler called");
                                                         }];
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
        [self dismissViewControllerAnimated:NO completion:^{
            
        }];
    }
}

#pragma mark Delegation (BYQuickShotView)

- (void)quickShotViewDidFinishPreparation:(BYQuickShotView *)quickShotView
{
    
}

- (void)quickShotView:(BYQuickShotView *)quickShotView didTakeSnapshot:(UIImage *)img
{
    
}

- (void)quickShotViewDidDiscardLastImage:(BYQuickShotView *)quickShotView
{
    
}

@end
