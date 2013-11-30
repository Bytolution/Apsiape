//
//  BYCursorLabel.m
//  Apsiape
//
//  Created by Dario Lass on 30.06.13.
//  Copyright (c) 2013 Bytolution. All rights reserved.
//

#import "BYCursorLabel.h"
#import <QuartzCore/QuartzCore.h>

@interface BYCursorLabel ()


@end

@implementation BYCursorLabel

- (void)willMoveToSuperview:(UIView *)newSuperview
{
    [super willMoveToSuperview:newSuperview];
    
    self.textAlignment = NSTextAlignmentRight;
    NSAttributedString *attrString = [[NSAttributedString alloc]initWithString:@"Enter value" attributes:@{NSForegroundColorAttributeName : [UIColor darkTextColor]}];
    self.attributedText = attrString;
}

@end
