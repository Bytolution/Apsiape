//
//  BYExpenseKeyboard.m
//  Apsiape
//
//  Created by Dario Lass on 20.03.13.
//  Copyright (c) 2013 Bytolution. All rights reserved.
//

#import "BYExpenseKeyboard.h"

@interface BYExpenseKeyboard ()

@property (nonatomic, strong) NSArray *buttons;

- (void)prepareButtons;

@end


@implementation BYExpenseKeyboard

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)prepareButtons {
    NSMutableArray *mButtonArray = [[NSMutableArray alloc]initWithCapacity:12];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.titleLabel.textColor = [UIColor whiteColor];
    
    for (int i = 1; i < 10; i++) {
        button.titleLabel.text = [NSString stringWithFormat:@"%d", i];
        [mButtonArray addObject:[button copy]];
    }
    
    button.titleLabel.text = @".";
    [mButtonArray addObject:[button copy]];
    button.titleLabel.text = @"00";
    [mButtonArray addObject:[button copy]];
    button.titleLabel.text = @"Del";
    [mButtonArray addObject:[button copy]];
    
    self.buttons = [mButtonArray copy];
    
    NSLog(@"%@", self.buttons);
}



@end
