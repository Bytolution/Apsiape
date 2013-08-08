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

@property (nonatomic, readwrite) BOOL mapViewVisible;
@property (nonatomic, readwrite) BOOL preferencesViewVisible;
@property (nonatomic, readwrite) CGFloat lastHorizontalPanPosition;
@property (nonatomic, readwrite) BYEdgeType panGestureEdge;

- (void)transitionWithLeftViewControllerWithHorizontalDelta:(CGFloat)deltaX velocity:(CGFloat)velocity state:(UIGestureRecognizerState)gState;
- (void)transitionWithRightViewControllerWithHorizontalDelta:(CGFloat)deltaX velocity:(CGFloat)velocity state:(UIGestureRecognizerState)gState;

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
    [self.mapViewController willMoveToParentViewController:self];
    [self addChildViewController:self.mapViewController];
    self.mapViewController.view.frame = CGRectOffset(self.view.bounds, - 320, 0);
    [self.view addSubview:self.mapViewController.view];
    [self.mapViewController didMoveToParentViewController:self];
    
    [self.preferencesViewController willMoveToParentViewController:self];
    [self addChildViewController:self.preferencesViewController];
    self.preferencesViewController.view.frame = CGRectOffset(self.view.bounds, 320, 0);
    [self.view addSubview:self.preferencesViewController.view];
    [self.preferencesViewController didMoveToParentViewController:self];
    
    [self.view addSubview:self.mapGestureOverlayView];
    self.mapGestureOverlayView.frame = CGRectMake(290, 0, 30, 568);
    self.mapGestureOverlayView.backgroundColor = [UIColor colorWithWhite:1 alpha:.5];
}

#pragma mark - Gesture Handlinge

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
    
    NSLog(@"%@, __ %f", pan, xLocation);
    
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
