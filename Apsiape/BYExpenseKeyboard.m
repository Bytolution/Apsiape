//
//  BYExpenseKeyboard.m
//  Apsiape
//
//  Created by Dario Lass on 20.03.13.
//  Copyright (c) 2013 Bytolution. All rights reserved.
//

#import "BYExpenseKeyboard.h"

@interface BYExpenseKeyboard ()

@property (nonatomic, strong) NSArray *buttonArray;

- (void)prepareButtons;
- (void)buttonPressed:(UIButton*)sender;
- (void)buttonReleased:(UIButton*)sender;

@end


@implementation BYExpenseKeyboard

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor blackColor];
        self.fontColor = [UIColor colorWithWhite:0.3 alpha:1];
    }
    return self;
}

- (void)didMoveToSuperview {
    [super didMoveToSuperview];
    [self prepareButtons];
    
    for (UIButton *button in self.buttonArray) {
        [self addSubview:button];
    }
}

- (void)prepareButtons {
    NSMutableArray *mButtonArray = [[NSMutableArray alloc]initWithCapacity:12];
    
    CGSize keyboardSize = self.frame.size;
    
    CGSize buttonSize = CGSizeMake(keyboardSize.width/3 - 0.25, keyboardSize.height/4 - 0.5);
    
    
    for (int i = 0; i < 12; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.titleLabel.font = [UIFont fontWithName:@"Miso" size:30];
        
        button.backgroundColor = [UIColor colorWithWhite:0.95 alpha:1];
        
        [button setTitleColor:self.fontColor forState:UIControlStateNormal];
        
        CGPoint buttonOrigin = CGPointMake(32, 13);
        switch (i) {
            case 0:
                [button setTitle:@"1" forState:UIControlStateNormal];
                buttonOrigin = CGPointMake(0, 0);
                break;
            case 1:
                [button setTitle:@"2" forState:UIControlStateNormal];
                buttonOrigin = CGPointMake(keyboardSize.width/2 - buttonSize.width/2, 0);
                break;
            case 2:
                [button setTitle:@"3" forState:UIControlStateNormal];
                buttonOrigin = CGPointMake(keyboardSize.width - buttonSize.width, 0);
                break;
            case 3:
                [button setTitle:@"4" forState:UIControlStateNormal];
                buttonOrigin = CGPointMake(0, keyboardSize.height * (1.0f/4.0f));
                break;
            case 4:
                [button setTitle:@"5" forState:UIControlStateNormal];
                buttonOrigin = CGPointMake(keyboardSize.width/2 - buttonSize.width/2, keyboardSize.height * (1.0f/4.0f));
                break;
            case 5:
                [button setTitle:@"6" forState:UIControlStateNormal];
                buttonOrigin = CGPointMake(keyboardSize.width - buttonSize.width, keyboardSize.height * (1.0f/4.0f));
                break;
            case 6:
                [button setTitle:@"7" forState:UIControlStateNormal];
                buttonOrigin = CGPointMake(0, keyboardSize.height * (2.0f/4.0f));
                break;
            case 7:
                [button setTitle:@"8" forState:UIControlStateNormal];
                buttonOrigin = CGPointMake(keyboardSize.width/2 - buttonSize.width/2, keyboardSize.height * (2.0f/4.0f));
                break;
            case 8:
                [button setTitle:@"9" forState:UIControlStateNormal];
                buttonOrigin = CGPointMake(keyboardSize.width - buttonSize.width, keyboardSize.height * (2.0f/4.0f));
                break;
            case 9:
                [button setTitle:@"." forState:UIControlStateNormal];
                buttonOrigin = CGPointMake(0, keyboardSize.height * (3.0f/4.0f));
                break;
            case 10:
                [button setTitle:@"0" forState:UIControlStateNormal];
                buttonOrigin = CGPointMake(keyboardSize.width/2 - buttonSize.width/2, keyboardSize.height * (3.0f/4.0f));
                break;
            case 11:
                [button setTitle:@"Del" forState:UIControlStateNormal];
                buttonOrigin = CGPointMake(keyboardSize.width - buttonSize.width, keyboardSize.height * (3.0f/4.0f));
                break;
        }
        buttonOrigin.y += 0.5;
        button.frame = CGRectMake(buttonOrigin.x, buttonOrigin.y, buttonSize.width, buttonSize.height);
        [button addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchDown];
        [button addTarget:self action:@selector(buttonReleased:) forControlEvents:UIControlEventTouchUpInside];
        [mButtonArray addObject:button];
    }
    
    self.buttonArray = [mButtonArray copy];
}

- (void)buttonPressed:(UIButton*)sender
{
    sender.backgroundColor = [UIColor colorWithWhite:0.8 alpha:1];
    if ([sender.currentTitle isEqualToString:@"Del"]) {
        [self.delegate deleteKeyTapped];
    } else {
        [self.delegate numberKeyTapped:sender.currentTitle];
    }
}

- (void)buttonReleased:(UIButton *)sender
{
    [UIView animateWithDuration:0.3 animations:^{
        sender.backgroundColor = [UIColor colorWithWhite:0.95 alpha:1];
    }];
}

@end
