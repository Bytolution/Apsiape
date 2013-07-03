//
//  BYPullScrollView.m
//  Apsiape
//
//  Created by Dario Lass on 02.07.13.
//  Copyright (c) 2013 Bytolution. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "BYPullScrollView.h"


@interface BYPullScrollView () <UIScrollViewDelegate>



@end

@implementation BYPullScrollView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)willMoveToSuperview:(UIView *)newSuperview
{
    if (!self.childScrollView) self.childScrollView = [[UIScrollView alloc]initWithFrame:self.bounds];
    
    self.delegate = self;
    
    self.childScrollView.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:1];
    self.contentSize = self.frame.size;
    self.childScrollView.frame = self.bounds;
    self.childScrollView.pagingEnabled = YES;
    self.childScrollView.contentSize = CGSizeMake(self.frame.size.width * 3, self.frame.size.height);
    self.childScrollView.showsHorizontalScrollIndicator = NO;
    self.alwaysBounceVertical = YES;
    [self addSubview:self.childScrollView];
    self.layer.cornerRadius = 10;
    self.layer.masksToBounds = YES;
    
    UIColor *lightGreen = [UIColor colorWithRed:0.4 green:0.9 blue:0.4 alpha:1];
    UIColor *lightRed = [UIColor colorWithRed:0.9 green:0.4 blue:0.4 alpha:1];
    
    CGFloat pullViewHeight = 800;
    UIView *topPullView = [[UIView alloc]initWithFrame:CGRectMake(0, - pullViewHeight, self.frame.size.width, pullViewHeight)];
    topPullView.backgroundColor = lightGreen;
    CALayer *checkmarkLayer = [CALayer layer];
    checkmarkLayer.frame = CGRectMake(130, 720, 60, 60);
    checkmarkLayer.contents = (__bridge id)([[UIImage imageNamed:@"add.png"] CGImage]);
    CABasicAnimation* rotationAnimation;
    rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI * 2.0];
    rotationAnimation.duration = 1;
    rotationAnimation.cumulative = YES;
    rotationAnimation.repeatCount = HUGE_VALF;
    rotationAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    [checkmarkLayer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
    
    [topPullView.layer addSublayer:checkmarkLayer];
    [self addSubview:topPullView];
    UIView *bottomPullView = [[UIView alloc]initWithFrame:CGRectMake(0, self.contentSize.height, self.frame.size.width, pullViewHeight)];
    bottomPullView.backgroundColor = lightRed;
    [self addSubview:bottomPullView];
    UIView *rightPullView = [[UIView alloc]initWithFrame:CGRectMake(self.childScrollView.contentSize.width, 0, pullViewHeight, self.childScrollView.contentSize.height)];
    rightPullView.backgroundColor = lightGreen;
    [self.childScrollView addSubview:rightPullView];
    UIView *leftPullView = [[UIView alloc]initWithFrame:CGRectMake(- pullViewHeight, 0, pullViewHeight, self.childScrollView.contentSize.height)];
    leftPullView.backgroundColor = lightRed;
    [self.childScrollView addSubview:leftPullView];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    //check contentOffset for responsive pullView modification
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    //check contentOffset to determine current page
    //maybe start animation on pullview
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    //check position when finger lifts up to see if it was a a valid pull gesture
}

@end
