//
//  BYNewExpenseViewController.m
//  Apsiape
//
//  Created by Dario Lass on 28.05.13.
//  Copyright (c) 2013 Bytolution. All rights reserved.
//
#import <QuartzCore/QuartzCore.h>
#import "BYContainerViewController.h"
#import "BYNewExpenseViewController.h"
#import "UIImage+Adjustments.h"
#import "BYQuickShotView.h"
#import "BYExpenseKeyboard.h"
#import "Expense.h"
#import "BYStorage.h"
#import "BYCursorLabel.h"
#import "BYPullScrollView.h"

@interface BYNewExpenseViewController () <BYQuickShotViewDelegate, BYExpenseKeyboardDelegate, BYPullScrollViewDelegate>

@property (nonatomic, strong) UINavigationBar *headerBar;
@property (nonatomic, strong) BYQuickShotView *quickShotView;
@property (nonatomic, strong) NSMutableString *expenseValueRawString;
@property (nonatomic, strong) BYCursorLabel *expenseValueLabel;

- (NSString*)expenseValueCurrencyFormattedString;
- (NSNumber*)expenseValueDecimalNumber;

@end

@implementation BYNewExpenseViewController

#define KEYBOARD_HEIGHT 240

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.view.backgroundColor = [UIColor blackColor];
        
    BYPullScrollView *pullScrollView = [[BYPullScrollView alloc]initWithFrame:self.view.bounds];
    pullScrollView.pullScrollViewDelegate = self;
    
    [self.view addSubview:pullScrollView];
    
    self.expenseValueRawString = [[NSMutableString alloc]initWithCapacity:30];
    
    BYExpenseKeyboard *keyboard = [[BYExpenseKeyboard alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height - KEYBOARD_HEIGHT, 320, KEYBOARD_HEIGHT)];
    self.expenseValueLabel = [[BYCursorLabel alloc]initWithFrame:CGRectMake(10, 10, 300, 80)];
    [pullScrollView.childScrollView addSubview:self.expenseValueLabel];
    keyboard.delegate = self;
    [pullScrollView.childScrollView addSubview:keyboard];
    
    CGRect rect = CGRectInset(pullScrollView.bounds, 0, ((pullScrollView.frame.size.height - pullScrollView.frame.size.width) / 2));
    rect.origin.x = (pullScrollView.frame.size.width);
    
    self.quickShotView = [[BYQuickShotView alloc]initWithFrame:rect];
    self.quickShotView.delegate = self;
    [pullScrollView.childScrollView addSubview:self.quickShotView];
    
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
    formatter.decimalSeparator = @".";
    formatter.numberStyle = NSNumberFormatterCurrencyStyle;
    return [formatter stringFromNumber:[NSNumber numberWithFloat:self.expenseValueRawString.floatValue]];
}

- (void)numberKeyTapped:(NSString *)numberString
{
    NSRange decSeparatorRange = [self.expenseValueRawString rangeOfString:@"."];
    if (decSeparatorRange.length == 1) {
        if (decSeparatorRange.location < self.expenseValueRawString.length - 2) return;
        if ([numberString isEqualToString:@"."]) return;
    }
    if (self.expenseValueRawString.length == 9) return;
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

#pragma mark Cleanup methods

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    if (self.expenseValueRawString.length != 0) {
        [[BYStorage sharedStorage] saveExpenseObjectWithStringValue:self.expenseValueCurrencyFormattedString
                                                        numberValue:self.expenseValueDecimalNumber
                                                       fullResImage:self.quickShotView.fullResCapturedImage
                                                       locationData:nil
                                                         completion:nil];
    }
    self.expenseValueRawString = nil;
}

#pragma mark Delegation (QuickShotView)

- (void)didTakeSnapshot:(UIImage *)img
{
    
}
- (void)didDiscardLastImage
{
    
}
- (void)quickShotViewDidFinishPreparation:(BYQuickShotView *)quickShotView
{
    
}

#pragma mark Delegation (PullScrollView)

- (void)pullScrollView:(UIScrollView *)pullScrollView didDetectPullingAtEdge:(BYPullScrollViewEdgeType)edge
{
    [[BYContainerViewController sharedContainerViewController] dismissExpenseCreationViewController];
}
- (void)pullScrollView:(UIScrollView *)pullScrollView didScrollToPage:(NSInteger)page
{
    
}

@end
