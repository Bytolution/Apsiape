//
//  BYNavigationBar.m
//  Apsiape
//
//  Created by Dario Lass on 08.08.13.
//  Copyright (c) 2013 Bytolution. All rights reserved.
//

#import "BYNavigationBar.h"

@interface BYNavigationBar ()

@property (nonatomic, strong) UIButton *leftButton;

- (void)leftButtonTapped;

@end

@implementation BYNavigationBar

- (void)willMoveToSuperview:(UIView *)newSuperview
{
    self.leftButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    self.leftButton.frame = CGRectMake(5, 20, 60, 44);
    [self.leftButton setTitle:@"Back" forState:UIControlStateNormal];
    self.leftButton.titleLabel.textColor = [UIColor blueColor];
    [self.leftButton addTarget:self action:@selector(leftButtonTapped) forControlEvents:UIControlEventTouchDown];
    [self addSubview:self.leftButton];
}

- (void)leftButtonTapped
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
    [self.delegate leftButtonTapped];
}

@end
