//
//  BYExpenseKeyboard.h
//  Apsiape
//
//  Created by Dario Lass on 20.03.13.
//  Copyright (c) 2013 Bytolution. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BYExpenseKeyboardDelegate

- (void)numberKeyTapped:(NSString*)numberString;
- (void)deleteKeyTapped;

@end

@interface BYExpenseKeyboard : UIView

@property (nonatomic, strong) id <BYExpenseKeyboardDelegate> delegate;
@property (nonatomic, strong) UIColor *fontColor;

@end
