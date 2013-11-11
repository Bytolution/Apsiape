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

@interface BYNavigationController () <UIViewControllerTransitioningDelegate>

@property (nonatomic, strong) BYExpenseCreationViewController *expenseCreationVC;
@property (nonatomic, strong) BYNavigationContainerController *navigationCC;

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
        self.view.backgroundColor = [UIColor whiteColor];
        self.navigationBarHidden = YES;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(displayExpenseCreationViewController) name:BYNavigationControllerShouldDisplayExpenseCreationVCNotificationName object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(displayPreferencesViewController) name:BYNavigationControllerShouldDisplayPreferenceVCNotificationName object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dismissExpenseCreationViewController) name:BYNavigationControllerShouldDismissExpenseCreationVCNotificationName object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dismissPreferencesViewController) name:BYNavigationControllerShouldDismissPreferencesVCNotificationName object:nil];
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    
    
    [self.view becomeFirstResponder];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self.view resignFirstResponder];
}

- (BOOL)canBecomeFirstResponder
{
    return YES;
}

- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
    if (motion == UIEventSubtypeMotionShake)
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"BYNavigationControllerShouldDisplayPreferenceVCNotification" object:nil];
    }
}

- (void)displayExpenseCreationViewController
{
    if (!self.expenseCreationVC) {
        self.expenseCreationVC = [[BYExpenseCreationViewController alloc]initWithNibName:nil bundle:nil];
        self.expenseCreationVC.transitioningDelegate = self;
        self.expenseCreationVC.modalPresentationStyle = UIModalPresentationCustom;
        [self presentViewController:self.expenseCreationVC animated:YES completion:^{
            
        }];
    }
}

- (void)displayPreferencesViewController
{
    if (!self.navigationCC) {
        self.navigationCC = [[BYNavigationContainerController alloc]initWithNibName:nil bundle:nil];
        self.navigationCC.transitioningDelegate = self;
        self.navigationCC.modalPresentationStyle = UIModalPresentationCustom;
        [self presentViewController:self.navigationCC animated:YES completion:^{
            
        }];
    }
}

- (void)dismissExpenseCreationViewController
{
    [self.expenseCreationVC dismissViewControllerAnimated:NO completion:^{
        self.expenseCreationVC = nil;
    }];
}

- (void)dismissPreferencesViewController
{
    [self.navigationCC dismissViewControllerAnimated:NO completion:^{
        self.navigationCC = nil;
    }];
}

#pragma mark - View Controller Transition delegates

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source
{
    BYPopupVCTransitionController *tController = [[BYPopupVCTransitionController alloc]init];
    tController.duration = 1;
    return tController;
}
- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed
{
    // BYPopupVCTransitionController isAppearing = NO;
    return nil;
}


@end
