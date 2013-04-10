//
//  BYExpenseInputViewController.m
//  Apsiape
//
//  Created by Dario Lass on 30.03.13.
//  Copyright (c) 2013 Bytolution. All rights reserved.
//

#import "BYExpenseInputViewController.h"
#import "BYExpenseInputView.h"
#import "BYExpenseKeyboard.h"
#import "InterfaceConstants.h"
#import "BYStorage.h"

@interface BYExpenseInputViewController () <BYExpenseKeyboardDelegate>

@property (nonatomic, strong) NSMutableString *expenseValue;
@property (nonatomic, strong) BYExpenseInputView *expenseInputView;
@property (nonatomic, strong) BYExpenseKeyboard *decimalKeyboard;

- (void)setSubviewColors;

@end

@implementation BYExpenseInputViewController

- (BYExpenseInputView *)expenseInputView {
    if (!_expenseInputView) _expenseInputView = [[BYExpenseInputView alloc]initWithFrame:CGRectMake(0, 0, 320, self.view.bounds.size.height - KEYBOARD_HEIGHT)];
    return _expenseInputView;
}

- (BYExpenseKeyboard *)decimalKeyboard {
    if (!_decimalKeyboard) _decimalKeyboard = [[BYExpenseKeyboard alloc]initWithFrame:CGRectMake(0, self.view.bounds.size.height - KEYBOARD_HEIGHT, 320, KEYBOARD_HEIGHT)];
    return _decimalKeyboard;
}

- (NSMutableString *)expenseValue {
    if (!_expenseValue) _expenseValue = [[NSMutableString alloc]init];
    return _expenseValue;
}

- (void)viewDidLoad {
    //
}

- (void)viewDidAppear:(BOOL)animated {
    [self setSubviewColors];
    [self.view addSubview:self.decimalKeyboard];
    [self.view addSubview:self.expenseInputView];
    self.decimalKeyboard.delegate = self;
}

- (void)setSubviewColors {
    self.decimalKeyboard.backgroundColor = ColorSnow;
    self.expenseInputView.backgroundColor = ColorGhostWhite;
    self.expenseInputView.fontColor = ColorCharcoal;
    self.decimalKeyboard.fontColor = Color100PercentBlack;
}

- (void)numberKeyTapped:(NSString *)numberString {
    NSRange decSeparatorRange = [self.expenseValue rangeOfString:@"."];
    if (decSeparatorRange.length == 1) {
        if (decSeparatorRange.location < self.expenseValue.length - 2) return;
        
        if ([numberString isEqualToString:@"."]) return;
    }
    [self.expenseValue appendString:numberString];
    self.expenseInputView.text = self.expenseValue;
}

- (void)deleteKeyTapped {
    if (self.expenseValue.length < 1) {
        return;
    } else {
        NSRange range = NSMakeRange(self.expenseValue.length - 1, 1);
        [self.expenseValue deleteCharactersInRange:range];
    }
    self.expenseInputView.text = self.expenseValue;
}

@end
