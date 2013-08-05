//
//  BYContainerViewController.m
//  Apsiape
//
//  Created by Dario Lass on 05.08.13.
//  Copyright (c) 2013 Bytolution. All rights reserved.
//

#import "BYContainerViewController.h"
#import "BYCollectionViewController.h"
#import "BYMapViewController.h"
#import "BYPreferencesViewController.h"

@interface BYContainerViewController () <UIGestureRecognizerDelegate>

@property (nonatomic, strong) UIPanGestureRecognizer *panRecognizer;
@property (nonatomic, strong) BYCollectionViewController *collectionViewController;
@property (nonatomic, strong) BYMapViewController *mapViewController;
@property (nonatomic, strong) BYPreferencesViewController *preferencesViewController;

@property (nonatomic, readwrite) BOOL mapViewVisible;
@property (nonatomic, readwrite) BOOL preferencesViewVisible;

@end

@implementation BYContainerViewController

#pragma mark - Initialization

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        if (!self.collectionViewController) self.collectionViewController = [[BYCollectionViewController alloc]initWithNibName:nil bundle:nil];
        if (!self.mapViewController) self.mapViewController = [[BYMapViewController alloc]initWithNibName:nil bundle:nil];
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
    // animate the collectionViewController's view fading in
    [self.collectionViewController willMoveToParentViewController:self];
    [self addChildViewController:self.collectionViewController];
    self.collectionViewController.view.frame = self.view.bounds;
    self.collectionViewController.view.alpha = 0;
    [self.view addSubview:self.collectionViewController.view];
    [UIView animateWithDuration:0.4 animations:^{
        self.collectionViewController.view.alpha = 1;
    } completion:^(BOOL finished) {
        [self.collectionViewController didMoveToParentViewController:self];
    }];
    // -- -- --
    
    
}

#pragma mark - Gesture Handling

- (BOOL)gestureRecognizerShouldBegin:(UIPanGestureRecognizer*)gestureRecognizer
{
    CGPoint translation = [gestureRecognizer translationInView:self.view.superview];
    BOOL panIsHorizontal = (fabs(translation.x) / fabs(translation.y) > 1) ? YES : NO;
    CGFloat horizontalPanPosition = [gestureRecognizer locationInView:gestureRecognizer.view].x;
    BOOL panStartedOnEdge = (horizontalPanPosition < 30 || horizontalPanPosition > 290) ? YES : NO;
    if (panIsHorizontal && panStartedOnEdge) {
        return YES;
    } else {
        return NO;
    }
}

- (void)panRecognized:(UIPanGestureRecognizer *)pan
{
    if (pan.state == UIGestureRecognizerStateBegan) {
        
    }
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    if (self.mapViewVisible) {
        return YES;
    } else {
        return NO;
    }
}

@end
