//
//  BYExpenseInputViewController.m
//  Apsiape
//
//  Created by Dario Lass on 26.05.13.
//  Copyright (c) 2013 Bytolution. All rights reserved.
//

#import "BYExpenseInputViewController.h"
#import "BYExpenseInputView.h"
#import "BYExpenseKeyboard.h"

@interface BYExpenseInputViewController () <BYExpenseKeyboardDelegate>

@property (nonatomic, strong) BYExpenseInputView *expenseInputView;
@property (nonatomic, strong) BYExpenseKeyboard *decimalKeyboard;

- (void)setSubviewColors;

@end

@implementation BYExpenseInputViewController

- (NSMutableString *)expenseValue
{
    if (!_expenseValue) _expenseValue = [[NSMutableString alloc]initWithCapacity:10];
    return _expenseValue;
}

#define KEYBOARD_HEIGHT 220

- (void)viewWillAppear:(BOOL)animated
{
    CGRect expenseInputViewFrame = self.view.bounds;
    expenseInputViewFrame.size.height = self.view.frame.size.height - KEYBOARD_HEIGHT;
    if (!self.expenseInputView) self.expenseInputView = [[BYExpenseInputView alloc]initWithFrame:expenseInputViewFrame];
    
    CGRect keyboardFrame = self.view.bounds;
    keyboardFrame.origin.y = expenseInputViewFrame.size.height;
    keyboardFrame.size.height = KEYBOARD_HEIGHT;
    if (!self.decimalKeyboard) self.decimalKeyboard = [[BYExpenseKeyboard alloc]initWithFrame:keyboardFrame];
    
    [self.view addSubview:self.expenseInputView];
    [self.view addSubview:self.decimalKeyboard];
    
    self.decimalKeyboard.delegate = self;
    [self setSubviewColors];
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
    NSLog(@"key tapped");
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


@end
