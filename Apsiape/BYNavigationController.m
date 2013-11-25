//
//  BYNavigationController.m
//  Apsiape
//
//  Created by Dario Lass on 05.08.13.
//  Copyright (c) 2013 Bytolution. All rights reserved.
//

#import "Constants.h"
#import "BYNavigationController.h"
#import "BYNavigationContainerController.h"
#import "BYExpenseCreationViewController.h"
#import "BYPopupVCTransitionController.h"

@interface BYNavigationController () <UIViewControllerTransitioningDelegate, UIApplicationDelegate>

@property (nonatomic, strong) BYExpenseCreationViewController *expenseCreationVC;
@property (nonatomic, strong) BYNavigationContainerController *navigationCC;
@property (nonatomic, strong) BYPopupVCTransitionController *transitionController;

- (void)displayPreferencesViewController;
- (void)displayExpenseCreationViewController;
- (void)dismissPreferencesViewController;
- (void)dismissExpenseCreationViewController;

@end

@implementation BYNavigationController

#pragma mark - Initialization

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.view.backgroundColor = [UIColor clearColor];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(displayExpenseCreationViewController) name:BYNavigationControllerShouldDisplayExpenseCreationVCNotificationName object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(displayPreferencesViewController) name:BYNavigationControllerShouldDisplayPreferenceVCNotificationName object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dismissExpenseCreationViewController) name:BYNavigationControllerShouldDismissExpenseCreationVCNotificationName object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dismissPreferencesViewController) name:BYNavigationControllerShouldDismissPreferencesVCNotificationName object:nil];
        
        if (!self.transitionController) self.transitionController = [[BYPopupVCTransitionController alloc]init];
        self.transitionController.duration = 0.8;
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.view becomeFirstResponder];
    self.view.backgroundColor = [UIColor colorWithWhite:0.8 alpha:1];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.view resignFirstResponder];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (BOOL)canBecomeFirstResponder { return YES; }

- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
    if (motion == UIEventSubtypeMotionShake && !self.navigationCC)
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:BYNavigationControllerShouldDisplayPreferenceVCNotificationName object:nil];
    } else if (motion == UIEventSubtypeMotionShake && self.navigationCC) {
        [[NSNotificationCenter defaultCenter] postNotificationName:BYNavigationControllerShouldDismissPreferencesVCNotificationName object:nil];
    }
}

- (void)displayExpenseCreationViewController
{
    if (!self.presentedViewController) {
        self.expenseCreationVC = [[BYExpenseCreationViewController alloc]initWithNibName:nil bundle:nil];
        self.expenseCreationVC.transitioningDelegate = self;
        self.expenseCreationVC.modalPresentationStyle = UIModalPresentationCustom;
        [self presentViewController:self.expenseCreationVC animated:YES completion:^{
            
        }];
    }
}

- (void)displayPreferencesViewController
{
    if (!self.presentedViewController) {
        self.navigationCC = [[BYNavigationContainerController alloc]initWithNibName:nil bundle:nil];
        self.navigationCC.transitioningDelegate = self;
        self.navigationCC.modalPresentationStyle = UIModalPresentationCustom;
        [self presentViewController:self.navigationCC animated:YES completion:^{
            
        }];
    }
}

- (void)dismissExpenseCreationViewController
{
    [self.presentedViewController dismissViewControllerAnimated:YES completion:^{
        self.expenseCreationVC = nil;
    }];
}

- (void)dismissPreferencesViewController
{
    [self.presentedViewController dismissViewControllerAnimated:YES completion:^{
        self.navigationCC = nil;
    }];
}

#pragma mark - View Controller Transition delegates

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source
{
    self.transitionController.isAppearing = YES;
    return self.transitionController;
}
- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed
{
    self.transitionController.isAppearing = NO;
    return self.transitionController;
}


@end
