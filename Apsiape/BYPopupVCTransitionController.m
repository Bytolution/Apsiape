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
    
    UIGraphicsBeginImageContextWithOptions(fromView.bounds.size, YES, 0);
    [fromView drawViewHierarchyInRect:containerView.bounds afterScreenUpdates:NO];
    UIImage *snapshotForBlur = UIGraphicsGetImageFromCurrentImageContext();
    
    UIImageView *lightBlurredImageView = [[UIImageView alloc]initWithImage:[snapshotForBlur applyBlurWithRadius:6 tintColor:[UIColor colorWithWhite:0.6 alpha:0.6] saturationDeltaFactor:1.8 maskImage:nil]];
    lightBlurredImageView.frame = fromView.frame;
    lightBlurredImageView.alpha = 0;

//    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
    // 1.
    [containerView addSubview:lightBlurredImageView];
    // 2.
    [containerView addSubview:toView];
    
    toView.frame = CGRectInset(containerView.bounds, 20, 40);
    toView.frame = CGRectOffset(toView.frame, - 320, 0);
    
    [UIView animateWithDuration:self.duration delay:0 usingSpringWithDamping:0.7 initialSpringVelocity:1 options:kNilOptions animations:^{
        toView.frame = CGRectInset(containerView.bounds, 20, 40);
        lightBlurredImageView.alpha = 1;
    } completion:^(BOOL finished) {
        [transitionContext completeTransition:YES];
    }];
}


@end
