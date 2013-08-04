//
//  BYMenuBar.m
//  Apsiape
//
//  Created by Dario Lass on 25.07.13.
//  Copyright (c) 2013 Bytolution. All rights reserved.
//

#import "BYMenuBar.h"
#import <QuartzCore/QuartzCore.h>

@interface BYMenuBar ()

@property (nonatomic, strong) UIButton *switchButton;
@property (nonatomic, strong) UIButton *addButton;
@property (nonatomic, strong) UIButton *settingsButton;

@end

@implementation BYMenuBar

#define NUMBER_OF_BUTTONS 3.0f

- (void)willMoveToSuperview:(UIView *)newSuperview
{
    self.backgroundColor = [UIColor whiteColor];
        
    self.switchButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.switchButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.switchButton = [UIButton buttonWithType:UIButtonTypeCustom];
    CGRect frame = CGRectMake(0, 0, (self.frame.size.width * (1.0f/NUMBER_OF_BUTTONS)), self.frame.size.height);
    self.switchButton.frame = CGRectInset(frame, 5, 5);
    frame = CGRectOffset(frame, self.frame.size.width * (1.0f/NUMBER_OF_BUTTONS), 0);
    self.addButton.frame = CGRectInset(frame, 0, 0);
    frame = CGRectOffset(frame, self.frame.size.width * (1.0f/NUMBER_OF_BUTTONS), 0);
    self.settingsButton.frame = CGRectInset(frame, 5, 5);
    self.switchButton.layer.borderColor = [UIColor blackColor].CGColor;
    self.switchButton.layer.borderWidth = 0.5;
    self.addButton.layer.borderColor = [UIColor blackColor].CGColor;
    self.addButton.layer.borderWidth = 0.5;
    self.settingsButton.layer.borderColor = [UIColor blackColor].CGColor;
    self.settingsButton.layer.borderWidth = 0.5;
    [self addSubview:self.switchButton];
    [self addSubview:self.addButton];
    [self addSubview:self.settingsButton];
}

@end
