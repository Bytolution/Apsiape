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

@end


@implementation BYExpenseKeyboard

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
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
    
    CGSize buttonSize = CGSizeMake(keyboardSize.width/3, keyboardSize.height/4);
    
    
    for (int i = 0; i < 12; i++) {
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.backgroundColor = [UIColor blackColor];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        CGPoint buttonOrigin = CGPointMake(32, 13);
        
        switch (i) {
            case 0:
                [button setTitle:@"1" forState:UIControlStateNormal];
                buttonOrigin = CGPointMake(0, 0);
                break;
            case 1:
                [button setTitle:@"2" forState:UIControlStateNormal];
                buttonOrigin = CGPointMake(keyboardSize.width / 3, 0);
                break;
            case 2:
                [button setTitle:@"3" forState:UIControlStateNormal];
                buttonOrigin = CGPointMake(keyboardSize.width / 1.5, 0);
                break;
            case 3:
                [button setTitle:@"4" forState:UIControlStateNormal];
                buttonOrigin = CGPointMake(0, keyboardSize.height / 4);
                break;
            case 4:
                [button setTitle:@"5" forState:UIControlStateNormal];
                buttonOrigin = CGPointMake(keyboardSize.width / 3, keyboardSize.height / 4);
                break;
            case 5:
                [button setTitle:@"6" forState:UIControlStateNormal];
                buttonOrigin = CGPointMake(keyboardSize.width / 1.5, keyboardSize.height / 4);
                break;
            case 6:
                [button setTitle:@"7" forState:UIControlStateNormal];
                buttonOrigin = CGPointMake(0, keyboardSize.height / 2);
                break;
            case 7:
                [button setTitle:@"8" forState:UIControlStateNormal];
                buttonOrigin = CGPointMake(keyboardSize.width / 3, keyboardSize.height / 2);
                break;
            case 8:
                [button setTitle:@"9" forState:UIControlStateNormal];
                buttonOrigin = CGPointMake(keyboardSize.width / 1.5, keyboardSize.height / 2);
                break;
            case 9:
                [button setTitle:@"," forState:UIControlStateNormal];
                buttonOrigin = CGPointMake(0, keyboardSize.height * 0.75);
                break;
            case 10:
                [button setTitle:@"0" forState:UIControlStateNormal];
                buttonOrigin = CGPointMake(keyboardSize.width / 3, keyboardSize.height * 0.75);
                break;
            case 11:
                [button setTitle:@"Del" forState:UIControlStateNormal];
                buttonOrigin = CGPointMake(keyboardSize.width / 1.5, keyboardSize.height * 0.75);
                break;
        }
        button.frame = CGRectMake(buttonOrigin.x, buttonOrigin.y, buttonSize.width, buttonSize.height);
        [button addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchDown];
        [mButtonArray addObject:button];
    }
    
    self.buttonArray = [mButtonArray copy];
    
    NSLog(@"self.buttonArray: %@", self.buttonArray);
}

- (void)buttonPressed:(UIButton*)sender {
    NSLog(@"%@", sender);
}

@end
