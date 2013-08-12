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

@interface BYNavigationController () <UIGestureRecognizerDelegate>

@property (nonatomic, strong) UIPanGestureRecognizer *panRecognizer;
@property (nonatomic, strong) BYCollectionViewController *collectionViewController;
@property (nonatomic, strong) BYMapViewController *mapViewController;
@property (nonatomic, strong) BYPreferencesViewController *preferencesViewController;
@property (nonatomic, strong) UIView *mapGestureOverlayView;

@property (nonatomic, strong) NSMutableArray *viewControllerStack;

@property (nonatomic, readwrite) BOOL mapViewVisible;
@property (nonatomic, readwrite) BOOL preferencesViewVisible;
@property (nonatomic, readwrite) CGFloat lastHorizontalPanPosition;
@property (nonatomic, readwrite) BYEdgeType panGestureEdge;

- (void)transitionWithLeftViewControllerWithHorizontalDelta:(CGFloat)deltaX velocity:(CGFloat)velocity state:(UIGestureRecognizerState)gState;
- (void)transitionWithRightViewControllerWithHorizontalDelta:(CGFloat)deltaX velocity:(CGFloat)velocity state:(UIGestureRecognizerState)gState;

- (BYViewController*)visibleViewController;
- (void)addViewControllerToStack:(BYViewController*)viewController;
- (void)removeLastViewControllerFromStack;
- (BYViewController*)rootViewController;
- (void)setRootViewController:(BYViewController*)visibleViewController;


@end

@implementation BYNavigationController

#pragma mark - Initialization

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        if (!self.collectionViewController) self.collectionViewController = [[BYCollectionViewController alloc]initWithNibName:nil bundle:nil];
        if (!self.mapViewController) self.mapViewController = [[BYMapViewController alloc]initWithNibName:nil bundle:nil];
        if (!self.preferencesViewController) self.preferencesViewController = [[BYPreferencesViewController alloc]initWithNibName:nil bundle:nil];
        
        if (!self.mapGestureOverlayView) self.mapGestureOverlayView = [[UIView alloc]initWithFrame:CGRectZero];
        
        if (!self.viewControllerStack) self.viewControllerStack = [[NSMutableArray alloc]init];
        
        self.view.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    self.panRecognizer = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panRecognized:)];
    self.panRecognizer.delegate = self;
    [self.view addGestureRecognizer:self.panRecognizer];
}

- (void)viewDidAppear:(BOOL)animated
{
//    [self.collectionViewController willMoveToParentViewController:self];
//    [self addChildViewController:self.collectionViewController];
//    self.collectionViewController.view.frame = CGRectOffset(self.view.bounds, 0, 0);
//    [self.view addSubview:self.collectionViewController.view];
//    [self.collectionViewController didMoveToParentViewController:self];
//    self.collectionViewController.navigationController = self;
//    [self setRootViewController:self.collectionViewController];
//    
//    [self.mapViewController willMoveToParentViewController:self];
//    [self addChildViewController:self.mapViewController];
//    self.mapViewController.view.frame = CGRectOffset(self.view.bounds, - 320, 0);
//    [self.view addSubview:self.mapViewController.view];
//    [self.mapViewController didMoveToParentViewController:self];
//    
//    [self.preferencesViewController willMoveToParentViewController:self];
//    [self addChildViewController:self.preferencesViewController];
//    self.preferencesViewController.view.frame = CGRectOffset(self.view.bounds, 320, 0);
//    [self.view addSubview:self.preferencesViewController.view];
//    [self.preferencesViewController didMoveToParentViewController:self];
//    
//    [self.view addSubview:self.mapGestureOverlayView];
//    self.mapGestureOverlayView.frame = CGRectMake(290, 0, 30, 568);
//    self.mapGestureOverlayView.backgroundColor = [UIColor clearColor];
    
//    [self.view addSubview:self.navigationBar];
//    self.navigationBar.backgroundColor = [UIColor colorWithWhite:1 alpha:0.9];
//    self.navigationBar.delegate = self;
   
}

#pragma mark - Custom Navigation controller

- (BYViewController *)rootViewController
{
    if ([[self.viewControllerStack objectAtIndex:0] isKindOfClass:[BYViewController class]]) {
        return [self.viewControllerStack objectAtIndex:0];
    } else {
        [NSException raise:@"BYNavigationControllerException" format:@"The view controller stack contains a view controller of the wrong class: %@", [self.viewControllerStack objectAtIndex:0]];
        return nil;
    }
}
- (void)setRootViewController:(BYViewController *)rootViewController
{
    if (self.viewControllerStack.count >= 1) {
        [self.viewControllerStack replaceObjectAtIndex:0 withObject:rootViewController];
    } else {
        [self.viewControllerStack addObject:rootViewController];
    }
//    NSLog(@"VC stack: %@", self.viewControllerStack);
}
- (void)addViewControllerToStack:(BYViewController *)viewController
{
    [self.viewControllerStack addObject:viewController];
//    NSLog(@"VC stack: %@", self.viewControllerStack);
}
- (void)removeLastViewControllerFromStack
{
    
    if (self.viewControllerStack.count > 0) {
        [self.viewControllerStack removeLastObject];
    } else {
        return;
    }
//    NSLog(@"VC stack: %@", self.viewControllerStack);
}
- (BYViewController *)visibleViewController
{
    return [self.viewControllerStack lastObject];
}

//- (void)pushViewController:(BYViewController *)viewController animated:(BOOL)animated
//{
//    [viewController willMoveToParentViewController:self];
//    [self addChildViewController:viewController];
//    viewController.view.frame = CGRectOffset(self.view.bounds, CGRectGetMaxX(self.view.frame), 0);
//    [self.view insertSubview:viewController.view belowSubview:self.navigationBar];
//    [UIView animateWithDuration:0.4 animations:^{
//        viewController.view.frame = self.view.bounds;
//    } completion:^(BOOL finished) {
//        [viewController didMoveToParentViewController:self];
//        BYViewController *belowVC = self.visibleViewController;
//        [belowVC willMoveToParentViewController:nil];
//        [belowVC.view removeFromSuperview];
//        [belowVC removeFromParentViewController];
//        viewController.navigationController = self;
//        [self addViewControllerToStack:viewController];
//    }];
//}

//- (void)popCurrentlyVisibleViewControllerAnimated:(BOOL)animated
//{
//    if (self.viewControllerStack.count >= 2) {
//        BYViewController *topVC = self.visibleViewController;
//        BYViewController *belowVC = [self.viewControllerStack objectAtIndex:self.viewControllerStack.count - 2];
//        
//        [belowVC willMoveToParentViewController:self];
//        [self addChildViewController:belowVC];
//        belowVC.view.frame = self.view.bounds;
//        [self.view insertSubview:belowVC.view belowSubview:topVC.view];
//        [belowVC didMoveToParentViewController:self];
//        
//        [UIView animateWithDuration:0.4 animations:^{
//            topVC.view.frame = CGRectOffset(self.view.bounds, CGRectGetMaxX(self.view.bounds), 0);
//        } completion:^(BOOL finished) {
//            [topVC willMoveToParentViewController:nil];
//            [topVC.view removeFromSuperview];
//            [topVC removeFromParentViewController];
//            [self removeLastViewControllerFromStack];
//        }];
//        
//    } else if (self.viewControllerStack.count == 1) {
//        return;
//    } else if (self.viewControllerStack.count == 0) {
//        [NSException raise:@"BYNavigationControllerException" format:@"The view controller stack should not be empty"];
//    }
//}

- (void)leftButtonTapped
{
    [self popCurrentlyVisibleViewControllerAnimated:YES];
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
    
    if (self.panGestureEdge == BYEdgeTypeLeft) {
        if (!self.mapViewVisible && !self.preferencesViewVisible) {
            // goto map
            [self transitionWithLeftViewControllerWithHorizontalDelta:deltaX velocity:[pan velocityInView:self.view].x state:pan.state];
        } else if (self.preferencesViewVisible) {
            [self transitionWithRightViewControllerWithHorizontalDelta:deltaX velocity:[pan velocityInView:self.view].x state:pan.state];
        } else if (self.mapViewVisible) {
            // you cannot go further rightwards ->
            return;
        }
    } else if (self.panGestureEdge == BYEdgeTypeRight) {
        if (!self.mapViewVisible && !self.preferencesViewVisible) {
            [self transitionWithRightViewControllerWithHorizontalDelta:deltaX velocity:[pan velocityInView:self.view].x state:pan.state];
        } else if (self.preferencesViewVisible) {
            [self transitionWithLeftViewControllerWithHorizontalDelta:deltaX velocity:[pan velocityInView:self.view].x state:pan.state];
        } else if (self.mapViewVisible) {
            [self transitionWithLeftViewControllerWithHorizontalDelta:deltaX velocity:[pan velocityInView:pan.view].x state:pan.state];
        }
    } else {
        // ???
    }
    if (pan.state == UIGestureRecognizerStateEnded) {
        self.lastHorizontalPanPosition = 0;
        self.panGestureEdge = BYEdgeTypeNone;
    }
}
- (void)transitionWithLeftViewControllerWithHorizontalDelta:(CGFloat)deltaX velocity:(CGFloat)velocity state:(UIGestureRecognizerState)gState
{
    self.mapViewController.view.frame = CGRectOffset(self.mapViewController.view.frame, deltaX, 0);
    self.collectionViewController.view.frame = CGRectOffset(self.collectionViewController.view.frame, deltaX, 0);
    
    if (gState == UIGestureRecognizerStateEnded && velocity > 0) {
        // GOTO maps
        [UIView animateWithDuration:.2 animations:^{
            self.mapViewController.view.frame = CGRectMake(0, 0, 320, 568);
            self.collectionViewController.view.frame = CGRectMake(320, 0, 320, 568);
        } completion:^(BOOL finished) {
            self.mapViewVisible = YES;
        }];
    } else if (gState == UIGestureRecognizerStateEnded && velocity < 0) {
        // GOTO collection view
        [UIView animateWithDuration:.2 animations:^{
            self.mapViewController.view.frame = CGRectMake(-320, 0, 320, 568);
            self.collectionViewController.view.frame = CGRectMake(0, 0, 320, 568);
        } completion:^(BOOL finished) {
            self.mapViewVisible = NO;
        }];
    }
}
- (void)transitionWithRightViewControllerWithHorizontalDelta:(CGFloat)deltaX velocity:(CGFloat)velocity state:(UIGestureRecognizerState)gState
{
    self.preferencesViewController.view.frame = CGRectOffset(self.preferencesViewController.view.frame, deltaX, 0);
    self.collectionViewController.view.frame = CGRectOffset(self.collectionViewController.view.frame, deltaX, 0);
    
    if (gState == UIGestureRecognizerStateEnded && velocity > 0) {
        // GOTO collection view
        [UIView animateWithDuration:.2 animations:^{
            self.preferencesViewController.view.frame = CGRectMake(320, 0, 320, 568);
            self.collectionViewController.view.frame = CGRectMake(0, 0, 320, 568);
        } completion:^(BOOL finished) {
            self.preferencesViewVisible = NO;
        }];
    } else if (gState == UIGestureRecognizerStateEnded && velocity < 0) {
        // GOTO pref view
        [UIView animateWithDuration:.2 animations:^{
            self.preferencesViewController.view.frame = CGRectMake(0, 0, 320, 568);
            self.collectionViewController.view.frame = CGRectMake(- 320, 0, 320, 568);
        } completion:^(BOOL finished) {
            self.preferencesViewVisible = YES;
        }];
    }
}
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return NO;
}
- (void)setMapViewVisible:(BOOL)mapViewVisible
{
    _mapViewVisible = mapViewVisible;
    self.mapGestureOverlayView.hidden = !mapViewVisible;
}

@end
