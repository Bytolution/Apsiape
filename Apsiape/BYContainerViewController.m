//  BYContainerViewController.m
//  Apsiape
//
//  Created by Dario Lass on 03.03.13.
//  Copyright (c) 2013 Bytolution. All rights reserved.

#import "BYContainerViewController.h"
#import "BYMainViewController.h"
#import "UIImage+ImageFromView.h"
#import <QuartzCore/QuartzCore.h>
#import <MapKit/MapKit.h>
#import "BYNewExpenseViewController.h"

@interface BYContainerViewController () 

@property (nonatomic, strong) BYMainViewController *mainViewController;
@property (nonatomic, strong) BYNewExpenseViewController *expenseVC;
@property (nonatomic, strong) UINavigationBar *navBar;
@property (nonatomic, strong) UIToolbar *toolBar;
@property (nonatomic) BOOL mainViewControllerVisible;
@property (nonatomic, strong) UIWindow *backgroundWindow;

@end

@implementation BYContainerViewController 

#define HEADER_HEIGHT 50
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
        
    self.view.backgroundColor = [UIColor blackColor];
    
    [self addChildViewController:self.mainViewController];
    self.mainViewController.view.frame = CGRectMake(0, HEADER_HEIGHT, self.view.bounds.size.width, self.view.bounds.size.height - (HEADER_HEIGHT/* + FOOTER_HEIGHT*/));
    [self.view addSubview:self.mainViewController.view];
    [self.mainViewController didMoveToParentViewController:self];
    self.mainViewControllerVisible = YES;
    
    self.navBar = [[UINavigationBar alloc]initWithFrame:CGRectMake(0, 0, 320, HEADER_HEIGHT)];
    [self.view insertSubview:self.navBar aboveSubview:self.mainViewController.view];
    self.navBar.tintColor = [UIColor colorWithWhite:0.8 alpha:1];
}

- (void)displayExpenseCreationViewController
{
    self.expenseVC = [[BYNewExpenseViewController alloc]initWithNibName:nil bundle:nil];
    self.expenseVC.view.frame = self.view.bounds;
    [self.view addSubview:self.expenseVC.view];
    
}

- (void)dismissExpenseCreationViewController
{
    [self.expenseVC.view removeFromSuperview];
    [self.navBar pushNavigationItem:nil animated:YES];
}

- (void)splitAnimationOverlayViewDidFinishOpeningAnimation
{
    
}
- (void)splitAnimationOverlayViewDidFinishClosingAnimation
{
    
}

@end
