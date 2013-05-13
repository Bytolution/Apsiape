//  BYContainerViewController.m
//  Apsiape
//
//  Created by Dario Lass on 03.03.13.
//  Copyright (c) 2013 Bytolution. All rights reserved.

#import "BYContainerViewController.h"
#import "BYMainViewController.h"
#import "BYExpenseViewController.h"
#import "UIImage+ImageFromView.h"
#import <QuartzCore/QuartzCore.h>
#import <MapKit/MapKit.h>
#import "BYMapViewController.h"

@interface BYContainerViewController () 

@property (nonatomic, strong) BYMainViewController *mainViewController;
@property (nonatomic, strong) UINavigationBar *navBar;
@property (nonatomic, strong) UIToolbar *toolBar;
@property (nonatomic, strong) BYExpenseViewController *expenseViewController;
@property (nonatomic) BOOL mainViewControllerVisible;
@property (nonatomic, strong) BYMapViewController *mapViewController;

- (void)mapButtonTapped;

@end

@implementation BYContainerViewController 

#define HEADER_HEIGHT 44
#define FOOTER_HEIGHT 40
#define SHADOW_HEIGHT 30
#define MAP_HEIGHT 280

+ (BYContainerViewController *)sharedContainerViewController {
    static BYContainerViewController *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[BYContainerViewController alloc] initWithNibName:nil bundle:nil];
        NSLog(@"SINGLETON: BYContainerViewController now exists.");
    });
    
    return sharedInstance;
}

- (BYMainViewController *)mainViewController {
    if (!_mainViewController) _mainViewController = [[BYMainViewController alloc]init];
    return _mainViewController; 
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
        
    self.view.backgroundColor = [UIColor darkGrayColor];
    
    [self addChildViewController:self.mainViewController];
    self.mainViewController.view.frame = CGRectMake(0, HEADER_HEIGHT, self.view.bounds.size.width, self.view.bounds.size.height - (HEADER_HEIGHT/* + FOOTER_HEIGHT*/));
    [self.view addSubview:self.mainViewController.view];
    [self.mainViewController didMoveToParentViewController:self];
    self.mainViewControllerVisible = YES;
    
    self.navBar = [[UINavigationBar alloc]initWithFrame:CGRectMake(0, 0, 320, HEADER_HEIGHT)];
    [self.view insertSubview:self.navBar aboveSubview:self.mainViewController.view];
    [self.navBar setBackgroundImage:[UIImage imageNamed:@"1234.png"] forBarMetrics:UIBarMetricsDefault];
    
//    self.toolBar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height - FOOTER_HEIGHT, 320, FOOTER_HEIGHT)];
//    [self.toolBar setBackgroundImage:[UIImage imageNamed:@"1234.png"] forToolbarPosition:UIToolbarPositionAny barMetrics:UIBarMetricsDefault];
//    [self.view addSubview:self.toolBar];
    
    UIBarButtonItem *mapButton = [[UIBarButtonItem alloc]initWithTitle:@"Gnarl" style:UIBarButtonItemStyleBordered target:self action:@selector(mapButtonTapped)];
    UINavigationItem *navItem = [[UINavigationItem alloc]init];
    navItem.rightBarButtonItem = mapButton;
    [self.navBar pushNavigationItem:navItem animated:YES];
}


- (void)displayExpenseCreationViewController
{
    NSLog(@"bloerp");
    if (!self.expenseViewController) self.expenseViewController = [[BYExpenseViewController alloc]init];
    
    self.navBar.items = nil;
    
    UIBarButtonItem *dismissButton = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(dismissExpenseCreationViewController)];
    UINavigationItem *navItem = [[UINavigationItem alloc]init];
    navItem.rightBarButtonItem = dismissButton;
    [self.navBar pushNavigationItem:navItem animated:YES];
    
    self.expenseViewController.view.clipsToBounds = YES;
    [self addChildViewController:self.expenseViewController];
    self.expenseViewController.view.frame = CGRectMake(-self.view.bounds.size.width, HEADER_HEIGHT, self.view.bounds.size.width, self.view.bounds.size.height - HEADER_HEIGHT);
    [self.view addSubview:self.expenseViewController.view];
    [self.expenseViewController didMoveToParentViewController:self];
        
    [UIView animateWithDuration:0.4 animations:^{
        self.expenseViewController.view.frame = self.mainViewController.view.frame;
        
        CGRect postAnimMainViewFrame = self.expenseViewController.view.frame;
        postAnimMainViewFrame.origin.x += self.view.bounds.size.width;
        
        self.mainViewController.view.frame = postAnimMainViewFrame;
        self.toolBar.frame = CGRectMake(320, self.view.frame.size.height - FOOTER_HEIGHT, 320, FOOTER_HEIGHT);
    }];
}

- (void)dismissExpenseCreationViewController
{
    self.navBar.items = nil;
    [self.expenseViewController willMoveToParentViewController:nil];
    [self.expenseViewController viewWillDisappear:YES];
    [UIView animateWithDuration:0.6 animations:^{
        self.mainViewController.view.frame = self.expenseViewController.view.frame;
        
        CGRect postAnimMainViewFrame = self.expenseViewController.view.frame;
        postAnimMainViewFrame.origin.x -= self.view.bounds.size.width;
        
        self.expenseViewController.view.frame = postAnimMainViewFrame;
        
    } completion:^(BOOL finished) {
        [self.expenseViewController removeFromParentViewController];
        [self.expenseViewController.view removeFromSuperview];
        self.expenseViewController = nil;
        
        UIBarButtonItem *mapButton = [[UIBarButtonItem alloc]initWithTitle:@"Map" style:UIBarButtonItemStyleBordered target:self action:@selector(mapButtonTapped)];
        UINavigationItem *navItem = [[UINavigationItem alloc]init];
        navItem.rightBarButtonItem = mapButton;
        [self.navBar pushNavigationItem:navItem animated:YES];
    }];
}

- (void)mapButtonTapped
{
    if (self.mainViewControllerVisible) {
        [self displayMapView];
    } else {
        [self dismissMapView];
    }
}

- (void)displayMapView
{
    CGRect mainViewFrame = self.mainViewController.view.frame;
    mainViewFrame.size.height -= MAP_HEIGHT;
    
    if (!self.mapViewController) {
        self.mapViewController = [[BYMapViewController alloc]init];
        self.mapViewController.view.backgroundColor = [UIColor darkGrayColor];
        [self addChildViewController:self.mapViewController];
        self.mapViewController.view.frame = CGRectMake(0, CGRectGetMaxY(self.view.bounds), self.view.frame.size.width, MAP_HEIGHT);
        [self.view addSubview:self.mapViewController.view];
        [self.mapViewController didMoveToParentViewController:self];
    }
    
    [UIView animateWithDuration:1 animations:^{
        self.mainViewController.view.frame = mainViewFrame;
        self.mainViewController.collectionView.frame = self.mainViewController.view.bounds;
        self.mapViewController.view.frame = CGRectMake(0, CGRectGetMaxY(self.view.bounds) - MAP_HEIGHT, self.view.frame.size.width, MAP_HEIGHT);
        self.mainViewControllerVisible = NO;
    } completion:^(BOOL finished) {
        
    }];
}

- (void)dismissMapView
{
    CGRect mainViewFrame = self.mainViewController.view.frame;
    mainViewFrame.size.height += MAP_HEIGHT;
    
    [UIView animateWithDuration:1 animations:^{
        self.mainViewController.view.frame = mainViewFrame;
        self.mainViewController.collectionView.frame = self.mainViewController.view.bounds;
        self.mapViewController.view.frame = CGRectMake(0, CGRectGetMaxY(self.view.bounds), self.view.frame.size.width, MAP_HEIGHT);
        self.mainViewControllerVisible = YES;
    } completion:^(BOOL finished) {
        
    }];
}

- (void)splitAnimationOverlayViewDidFinishOpeningAnimation
{
    
}
- (void)splitAnimationOverlayViewDidFinishClosingAnimation
{
}

@end
