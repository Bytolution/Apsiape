//
//  BYSplitAnimationOverlayView.m
//  Apsiape
//
//  Created by Dario Lass on 04.05.13.
//  Copyright (c) 2013 Bytolution. All rights reserved.
//

#import "BYSplitAnimationOverlayView.h"
#import "UIImage+ImageFromView.h"

@interface BYSplitAnimationOverlayView ()

@property (nonatomic, strong) UIView *sourceView;
@property (nonatomic, strong) UIImageView *topImageView;
@property (nonatomic, strong) UIImageView *bottomImageView;
@property (nonatomic, strong) UIImageView *topShadowView;
@property (nonatomic, strong) UIImageView *bottomShadowView;

@end

@implementation BYSplitAnimationOverlayView

- (id)initWithFrame:(CGRect)frame
{
    self = [super  initWithFrame:frame];
    if (self) {
        self.userInteractionEnabled = NO;
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)splitView:(UIView *)sourceView
{
    UIImage *imageFromView = [UIImage imageFromView:sourceView];
    
    CGImageRef tmpImgRef = imageFromView.CGImage;
    CGImageRef topImgRef = CGImageCreateWithImageInRect(tmpImgRef, CGRectMake(0, 0, imageFromView.size.width, imageFromView.size.height / 2.0));
    UIImage *topImage = [UIImage imageWithCGImage:topImgRef];
    CGImageRelease(topImgRef);
    
    CGImageRef bottomImgRef = CGImageCreateWithImageInRect(tmpImgRef, CGRectMake(0, imageFromView.size.height / 2.0,  imageFromView.size.width, imageFromView.size.height / 2.0));
    UIImage *bottomImage = [UIImage imageWithCGImage:bottomImgRef];
    CGImageRelease(bottomImgRef);
    
    UIImageView *topImgView = [[UIImageView alloc]initWithImage:topImage];
    UIImageView *bottomImgView = [[UIImageView alloc]initWithImage:bottomImage];
    
    [self addSubview:topImgView];
    [self addSubview:bottomImgView];
    
    CGRect topHalf = self.bounds;
    topHalf.size.height = self.frame.size.height/2;
    topImgView.frame = topHalf;
    
    CGRect bottomHalf = self.bounds;
    bottomHalf.size.height = self.frame.size.height/2;
    bottomHalf.origin.y = CGRectGetMidY(self.bounds);
    bottomImgView.frame = bottomHalf;
    
    topHalf.origin.y -= 160;
    bottomHalf.origin.y += 160;
    
    self.sourceView = sourceView;
    self.sourceView.hidden = YES;
    
    [UIView animateWithDuration:0.6 animations:^{
        topImgView.frame = topHalf;
        bottomImgView.frame = bottomHalf;
    } completion:^(BOOL finished) {
        self.topImageView = topImgView;
        self.bottomImageView = bottomImgView;
        [self.delegate splitAnimationOverlayViewDidFinishOpeningAnimation];
    }];
}

- (void)slideBack
{
    CGRect topHalf = self.bounds;
    topHalf.size.height = self.frame.size.height/2;
    
    CGRect bottomHalf = self.bounds;
    bottomHalf.size.height = self.frame.size.height/2;
    bottomHalf.origin.y = CGRectGetMidY(self.bounds);

    [UIView animateWithDuration:0.6 animations:^{
        self.topImageView.frame = topHalf;
        self.bottomImageView.frame = bottomHalf;
    } completion:^(BOOL finished) {
        [self.delegate splitAnimationOverlayViewDidFinishClosingAnimation];
        self.sourceView.hidden = NO;
    }];
}

@end
