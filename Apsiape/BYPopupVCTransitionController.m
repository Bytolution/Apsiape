//
//  BYPopupVCTransitionController.m
//  Apsiape
//
//  Created by Dario Lass on 19.08.13.
//  Copyright (c) 2013 Bytolution. All rights reserved.
//

#import "BYPopupVCTransitionController.h"
#import "UIImage+ImageEffects.h"

@interface BYPopupVCTransitionController ()

@end

@implementation BYPopupVCTransitionController

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext
{
    return self.duration;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    UIView *containerView = [transitionContext containerView];
    UIView *fromView = [[transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey] view];
    UIView *toView = [[transitionContext viewControllerForKey:UITransitionContextToViewControllerKey] view];
    
    UIGraphicsBeginImageContextWithOptions(fromView.bounds.size, NO, 0);
    [fromView drawViewHierarchyInRect:containerView.bounds afterScreenUpdates:NO];
    UIImage *snapshotForBlur = UIGraphicsGetImageFromCurrentImageContext();
    
    UIImageView *lightBlurredImageView = [[UIImageView alloc]initWithImage:[snapshotForBlur applyTintEffectWithColor:[UIColor blackColor]]];
    lightBlurredImageView.frame = containerView.bounds;
    [containerView addSubview:lightBlurredImageView];
    
    toView.frame = CGRectInset(containerView.frame, 20, 40);
    toView.alpha = 0;
    toView.clipsToBounds = YES;
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
    [containerView addSubview:toView];
    
    [UIView animateWithDuration:self.duration animations:^{
        toView.alpha = 1;
    } completion:^(BOOL finished) {
        [transitionContext completeTransition:YES];
    }];
}

@end
