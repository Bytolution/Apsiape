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

@property (nonatomic, strong) CABasicAnimation *fadeAnimation;

@end

@implementation BYCursorLabel

#warning Animation stops, when application reenters foreground

- (void)willMoveToSuperview:(UIView *)newSuperview
{
    [super willMoveToSuperview:newSuperview];
    
    self.textAlignment = NSTextAlignmentRight;
    NSAttributedString *attrString = [[NSAttributedString alloc]initWithString:@"Enter value" attributes:@{NSForegroundColorAttributeName : [UIColor grayColor]}];
    self.attributedText = attrString;
    self.font = [UIFont fontWithName:@"Miso-Light" size:60];
    
    CALayer *stripeLayer = [CALayer layer];
    CGSize labelSize = self.bounds.size;
    stripeLayer.frame = CGRectMake(labelSize.width - 2, 0, 2, labelSize.height);
    stripeLayer.backgroundColor = [UIColor colorWithRed:0.2 green:0.2 blue:1 alpha:1].CGColor;
    
    self.fadeAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    self.fadeAnimation.fromValue = [NSNumber numberWithFloat:1.0];
    self.fadeAnimation.fromValue = [NSNumber numberWithFloat:0.0];
    self.fadeAnimation.autoreverses = YES;
    self.fadeAnimation.repeatCount = HUGE_VALF;
    self.fadeAnimation.duration = 0.5;
    [stripeLayer addAnimation:self.fadeAnimation forKey:@"opacityAnimation"];
    
    [self.layer addSublayer:stripeLayer];
}

@end
