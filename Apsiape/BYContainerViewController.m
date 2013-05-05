//  BYContainerViewController.m
//  Apsiape
//
//  Created by Dario Lass on 03.03.13.
//  Copyright (c) 2013 Bytolution. All rights reserved.

#import "BYContainerViewController.h"
#import "BYMainViewController.h"
#import "BYSplitAnimationOverlayView.h"
#import "BYExpenseViewController.h"
#import "UIImage+ImageFromView.h"
#import <QuartzCore/QuartzCore.h>

@interface BYContainerViewController ()

@property (nonatomic, strong) BYMainViewController *mainViewController;
@property (nonatomic, strong) UINavigationBar *navBar;
@property (nonatomic, strong) UIToolbar *toolBar;
@property (nonatomic) CGRect contentFrame;
@property (nonatomic, strong) BYExpenseViewController *expenseViewController;
@property (nonatomic, strong) UIImage *animationImage;
@property (nonatomic) BOOL mainViewControllerVisible;

@end

@implementation BYContainerViewController

#define HEADER_HEIGHT 44
#define FOOTER_HEIGHT 40
#define SHADOW_HEIGHT 30

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

- (CGRect)contentFrame {
    CGRect rect = CGRectMake(0, HEADER_HEIGHT, self.view.bounds.size.width, self.view.bounds.size.height - (HEADER_HEIGHT + FOOTER_HEIGHT));
    return rect;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
        
    self.view.backgroundColor = [UIColor darkGrayColor];
    
    [self addChildViewController:self.mainViewController];
    self.mainViewController.view.frame = CGRectMake(0, HEADER_HEIGHT, self.view.bounds.size.width, self.view.bounds.size.height - (HEADER_HEIGHT + FOOTER_HEIGHT));
    [self.view addSubview:self.mainViewController.view];
    [self.mainViewController didMoveToParentViewController:self];
    
    self.navBar = [[UINavigationBar alloc]initWithFrame:CGRectMake(0, 0, 320, HEADER_HEIGHT)];
    [self.view insertSubview:self.navBar aboveSubview:self.mainViewController.view];
    [self.navBar setBackgroundImage:[UIImage imageNamed:@"1234.png"] forBarMetrics:UIBarMetricsDefault];
    
    self.toolBar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height - FOOTER_HEIGHT, 320, FOOTER_HEIGHT)];
    [self.toolBar setBackgroundImage:[UIImage imageNamed:@"1234.png"] forToolbarPosition:UIToolbarPositionAny barMetrics:UIBarMetricsDefault];
    [self.view addSubview:self.toolBar];
    
    UIPinchGestureRecognizer *pgr = [[UIPinchGestureRecognizer alloc]initWithTarget:self action:@selector(displayMapView)];
    [self.view addGestureRecognizer:pgr];
}


- (void)displayExpenseCreationViewController
{
    if (!self.expenseViewController) self.expenseViewController = [[BYExpenseViewController alloc]init];
    
    UIBarButtonItem *dismissButton = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(dismissExpenseCreationViewController)];
    UINavigationItem *navItem = [[UINavigationItem alloc]init];
    navItem.rightBarButtonItem = dismissButton;
    
    self.expenseViewController.view.clipsToBounds = YES;
    [self.navBar pushNavigationItem:navItem animated:YES];
    [self addChildViewController:self.expenseViewController];
    self.expenseViewController.view.frame = CGRectMake(-self.contentFrame.size.width, self.contentFrame.origin.y, self.contentFrame.size.width, self.contentFrame.size.height + FOOTER_HEIGHT);
    [self.view addSubview:self.expenseViewController.view];
    [self.expenseViewController didMoveToParentViewController:self];
    
    [UIView animateWithDuration:0.4 animations:^{
        self.expenseViewController.view.frame = CGRectMake(0, self.contentFrame.origin.y, self.contentFrame.size.width, self.contentFrame.size.height + FOOTER_HEIGHT);
        self.mainViewController.view.frame = CGRectMake(self.contentFrame.size.width, self.contentFrame.origin.y, self.contentFrame.size.width, self.contentFrame.size.height);
        self.toolBar.frame = CGRectMake(320, self.view.frame.size.height - FOOTER_HEIGHT, 320, FOOTER_HEIGHT);
    }];
}

- (void)dismissExpenseCreationViewController
{
    self.navBar.items = nil;
    [self.expenseViewController willMoveToParentViewController:nil];
    [self.expenseViewController viewWillDisappear:YES];
    [UIView animateWithDuration:0.6 animations:^{
        CGRect rect = self.contentFrame;
        rect.origin.x = - self.contentFrame.size.width;
        self.expenseViewController.view.frame = rect;
        rect.origin.x = 0;
        self.mainViewController.view.frame = rect;
        self.toolBar.frame = CGRectMake(0, self.view.frame.size.height - FOOTER_HEIGHT, 320, FOOTER_HEIGHT);
    } completion:^(BOOL finished) {
        [self.expenseViewController removeFromParentViewController];
        [self.expenseViewController.view removeFromSuperview];
        self.expenseViewController = nil;
    }];
}

- (void)displayMapView
{
    BYSplitAnimationOverlayView *splitAnimOverlayView = [[BYSplitAnimationOverlayView alloc]initWithFrame:self.mainViewController.view.frame];
    [self.view insertSubview:splitAnimOverlayView aboveSubview:self.mainViewController.view];
    [splitAnimOverlayView splitView:self.mainViewController.view];
}

- (void)dismissMapView
{
    
}

@end
