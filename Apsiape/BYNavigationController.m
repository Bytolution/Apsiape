//
//  BYNavigationController.m
//  Apsiape
//
//  Created by Dario Lass on 05.08.13.
//  Copyright (c) 2013 Bytolution. All rights reserved.
//

#import "BYNavigationController.h"
#import "BYCollectionViewController.h"
#import "BYMapViewController.h"
#import "BYPreferencesViewController.h"
#import "InterfaceDefinitions.h"
#import "BYPopupVCTransitionController.h"

@interface BYNavigationController () <UIGestureRecognizerDelegate, UIViewControllerTransitioningDelegate, UINavigationControllerDelegate>

@property (nonatomic, strong) UIPanGestureRecognizer *panRecognizer;
@property (nonatomic, strong) BYCollectionViewController *collectionViewController;
@property (nonatomic, strong) BYPreferencesViewController *preferencesViewController;

@property (nonatomic, strong) NSMutableArray *viewControllerStack;

@property (nonatomic, readwrite) BOOL mapViewVisible;
@property (nonatomic, readwrite) BOOL preferencesViewVisible;
@property (nonatomic, readwrite) CGFloat lastHorizontalPanPosition;
@property (nonatomic, readwrite) BYEdgeType panGestureEdge;

- (void)displayMap;

@end

@implementation BYNavigationController

#pragma mark - Initialization

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        self.view.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    self.panRecognizer = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panRecognized:)];
    self.panRecognizer.delegate = self;
    [self.view addGestureRecognizer:self.panRecognizer];
//    UIBarButtonItem *bbi = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(displayMap)];
//    self.visibleViewController.navigationItem.leftBarButtonItem = bbi;
}

- (void)displayMap
{
    BYMapViewController *mVC = [[BYMapViewController alloc]initWithNibName:nil bundle:nil];
    mVC.transitioningDelegate = self;
    mVC.modalPresentationStyle = UIModalPresentationCustom;
    [self presentViewController:mVC animated:YES completion:^{
//        NSLog(@"complete");
    }];
}

#pragma mark - View Controller Transition delegates

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source
{
    BYPopupVCTransitionController *tController = [[BYPopupVCTransitionController alloc]init];
    tController.presentedVC = presented;
    tController.presentingVC = presenting;
    tController.parentVC = self;
    tController.duration = 5;
    return tController;
}
- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
    return nil;
}


#pragma mark - Gesture Handling

- (BOOL)gestureRecognizerShouldBegin:(UIPanGestureRecognizer*)gestureRecognizer
{
    CGFloat horizontalPanPosition = [gestureRecognizer locationInView:gestureRecognizer.view].x;
    BOOL panStartedOnLeftEdge = (horizontalPanPosition < 30) ? YES : NO;
    BOOL panStartedOnRightEdge = (horizontalPanPosition > 290) ? YES : NO;
    if (panStartedOnLeftEdge) {
        self.panGestureEdge = BYEdgeTypeLeft;
        return YES;
    } else if (panStartedOnRightEdge) {
        self.panGestureEdge = BYEdgeTypeRight;
        return YES;
    } else {
        self.panGestureEdge = BYEdgeTypeNone;
        return NO;
    }
}
- (void)panRecognized:(UIPanGestureRecognizer *)pan
{
    CGFloat xLocation = [pan locationInView:pan.view].x;
    
    // compute the delta value each time the method gets called
    CGFloat deltaX = 0.0;
    if (self.lastHorizontalPanPosition != 0) {
         deltaX = (xLocation - self.lastHorizontalPanPosition);
    }
    self.lastHorizontalPanPosition = xLocation;
}
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return NO;
}

@end
