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

@property (nonatomic, strong) UIImageView *blurBGView;

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
    
    if (self.isAppearing) {
        UIGraphicsBeginImageContextWithOptions(fromView.bounds.size, YES, 0);
        [fromView drawViewHierarchyInRect:containerView.bounds afterScreenUpdates:NO];
        UIImage *snapshotForBlur = UIGraphicsGetImageFromCurrentImageContext();
        
        self.blurBGView = [[UIImageView alloc]initWithImage:[snapshotForBlur applyBlurWithRadius:6 tintColor:[UIColor colorWithWhite:0.6 alpha:0.6] saturationDeltaFactor:1.8 maskImage:nil]];
        self.blurBGView.frame = fromView.frame;
        self.blurBGView.alpha = 0;
        
        // 1.
        [containerView addSubview:self.blurBGView];
        // 2.
        [containerView addSubview:toView];
        
        toView.frame = CGRectOffset(toView.frame, - 330, 0);
        
        [UIView animateWithDuration:self.duration delay:0 usingSpringWithDamping:0.7 initialSpringVelocity:1 options:kNilOptions animations:^{
            toView.frame = containerView.bounds;
            self.blurBGView.alpha = 1;
        } completion:^(BOOL finished) {
            [transitionContext completeTransition:YES];
        }];
    } else {
        [UIView animateWithDuration:self.duration delay:0 usingSpringWithDamping:0.7 initialSpringVelocity:1 options:kNilOptions animations:^{
            fromView.frame = CGRectOffset(toView.frame, - 320, 0);
            self.blurBGView.alpha = 0;
        } completion:^(BOOL finished) {
            [transitionContext completeTransition:YES];
            self.blurBGView = nil;
        }];
    }
}


@end
