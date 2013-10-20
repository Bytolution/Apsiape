//
//  BYPopupVCTransitionController.h
//  Apsiape
//
//  Created by Dario Lass on 19.08.13.
//  Copyright (c) 2013 Bytolution. All rights reserved.
//

@import Foundation;

@interface BYPopupVCTransitionController : NSObject <UIViewControllerAnimatedTransitioning>

@property (nonatomic, strong) UIViewController *presentingVC;
@property (nonatomic, strong) UIViewController *presentedVC;

@property (nonatomic, strong) UIViewController *parentVC;

@property (nonatomic, readwrite) NSTimeInterval duration;

@end
