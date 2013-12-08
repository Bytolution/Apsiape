//
//  BYPullScrollView.m
//  Apsiape
//
//  Created by Dario Lass on 02.07.13.
//  Copyright (c) 2013 Bytolution. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "Constants.h"
#import "BYPullScrollView.h"

@interface BYPullScrollView () <UIScrollViewDelegate>

@property (nonatomic, readwrite) BYEdgeType currentPullingEdge;

@property (nonatomic, strong) UIView *topPullView;
@property (nonatomic, strong) UIView *bottomPullView;
@property (nonatomic, strong) UIView *leftPullView;
@property (nonatomic, strong) UIView *rightPullView;

- (void)handleVerticalPullWithOffset:(CGFloat)offset;
- (void)handleHorizontalPullWithOffset:(CGFloat)offset;
- (void)pullingDetectedForEdge:(BYEdgeType)edge;

@end

@implementation BYPullScrollView

#define NUMBER_OF_PAGES 2.0f

- (void)willMoveToSuperview:(UIView *)newSuperview
{
    self.currentPullingEdge = 0;
    
    if (!self.childScrollView) self.childScrollView = [[UIScrollView alloc]initWithFrame:self.bounds];
    
    self.delegate = self;
    self.childScrollView.delegate = self;
    
    self.contentSize = self.frame.size;
    self.childScrollView.frame = self.bounds;
    self.childScrollView.pagingEnabled = YES;
    self.childScrollView.contentSize = CGSizeMake(self.frame.size.width * NUMBER_OF_PAGES, self.frame.size.height);
    self.childScrollView.showsHorizontalScrollIndicator = NO;
    self.alwaysBounceVertical = YES;
    self.childScrollView.bounces = NO;
    [self addSubview:self.childScrollView];
    self.layer.masksToBounds = YES;
    
    CGFloat pullViewHeight = 800;
    self.topPullView = [[UIView alloc]initWithFrame:CGRectMake(0, - pullViewHeight, self.frame.size.width, pullViewHeight)];
    self.topPullView.backgroundColor = [UIColor seafoamColor];
    [self addSubview:self.topPullView];
    
    self.bottomPullView = [[UIView alloc]initWithFrame:CGRectMake(0, self.contentSize.height, self.frame.size.width, pullViewHeight)];
    self.bottomPullView.backgroundColor = [UIColor salmonColor];
    [self addSubview:self.bottomPullView];
    
    self.rightPullView = [[UIView alloc]initWithFrame:CGRectMake(self.childScrollView.contentSize.width, 0, pullViewHeight, self.childScrollView.contentSize.height)];
    self.rightPullView.backgroundColor = [UIColor seafoamColor];
    [self.childScrollView addSubview:self.rightPullView];
    
    self.leftPullView = [[UIView alloc]initWithFrame:CGRectMake(- pullViewHeight, 0, pullViewHeight, self.childScrollView.contentSize.height)];
    self.leftPullView.backgroundColor = [UIColor salmonColor];
    [self.childScrollView addSubview:self.leftPullView];
    
    UIImageView *checkmarkView = [[UIImageView alloc]initWithFrame:CGRectInset(CGRectMake(0, pullViewHeight - PULL_THRESHOLD, CGRectGetWidth(self.frame), PULL_THRESHOLD), 15, 15)];
    checkmarkView.image = [[UIImage imageNamed:BYApsiapeCheckmarkImageName]imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    checkmarkView.contentMode = UIViewContentModeScaleAspectFit;
    checkmarkView.tintColor = [UIColor whiteColor];
    [self.topPullView addSubview:checkmarkView];
    
    UIImageView *crossView = [[UIImageView alloc]initWithFrame:CGRectInset(CGRectMake(0, 0, CGRectGetWidth(self.frame), PULL_THRESHOLD), 15, 15)];
    crossView.image = [[UIImage imageNamed:BYApsiapeCrossImageName]imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    crossView.contentMode = UIViewContentModeScaleAspectFit;
    crossView.tintColor = [UIColor whiteColor];
    [self.bottomPullView addSubview:crossView];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView == self) {
        [self handleVerticalPullWithOffset:scrollView.contentOffset.y];
    } else if (scrollView == self.childScrollView) {
        [self handleHorizontalPullWithOffset:scrollView.contentOffset.x];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (self.currentPullingEdge != BYEdgeTypeNone) {
        [self pullingDetectedForEdge:self.currentPullingEdge];
    }
}

#pragma mark - Pull gesture handling

- (void)handleVerticalPullWithOffset:(CGFloat)offset
{
    if (offset < - PULL_THRESHOLD) {
        if (self.currentPullingEdge == BYEdgeTypeNone) {
            self.currentPullingEdge = BYEdgeTypeTop;
        }
    } else if (offset > PULL_THRESHOLD) {
        if (self.currentPullingEdge == BYEdgeTypeNone) {
            self.currentPullingEdge = BYEdgeTypeBottom;
        }
    } else if ((offset < - PULL_THRESHOLD || offset < PULL_THRESHOLD)){
        self.currentPullingEdge = BYEdgeTypeNone;
    }
}

- (void)handleHorizontalPullWithOffset:(CGFloat)offset
{
    CGFloat lastPageOffset = self.childScrollView.contentSize.width * ((NUMBER_OF_PAGES - 1)/(NUMBER_OF_PAGES));
    
    if (offset < - PULL_THRESHOLD) {
        if (self.currentPullingEdge == BYEdgeTypeNone) {
            self.currentPullingEdge = BYEdgeTypeLeft;
        }
    } else if (offset > PULL_THRESHOLD + lastPageOffset) {
        if (self.currentPullingEdge == BYEdgeTypeNone) {
            self.currentPullingEdge = BYEdgeTypeRight;
        }
    } else if (offset < -PULL_THRESHOLD || offset < (PULL_THRESHOLD + lastPageOffset)){
        self.currentPullingEdge = BYEdgeTypeNone;
    }
}

- (void)pullingDetectedForEdge:(BYEdgeType)edge
{
    if ([self.pullScrollViewDelegate respondsToSelector:@selector(pullScrollView:didDetectPullingAtEdge:)]) {
        [self.pullScrollViewDelegate pullScrollView:self didDetectPullingAtEdge:self.currentPullingEdge];
    }
}

@end
