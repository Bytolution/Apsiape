//  BYContainerViewController.m
//  Apsiape
//
//  Created by Dario Lass on 03.03.13.
//  Copyright (c) 2013 Bytolution. All rights reserved.

#import "BYContainerViewController.h"
#import "BYCollectionViewController.h"
#import "UIImage+ImageFromView.h"
#import <QuartzCore/QuartzCore.h>
#import <MapKit/MapKit.h>
#import "BYNewExpenseWindow.h"
#import "BYStatsViewController.h"
#import "BYStatsView.h"

@interface BYContainerViewController () 

@property (nonatomic, strong) BYCollectionViewController *mainViewController;
@property (nonatomic, strong) BYNewExpenseWindow *expenseWindow;
@property (nonatomic, strong) UINavigationBar *navBar;
@property (nonatomic, strong) UIToolbar *toolBar;
@property (nonatomic) BOOL mainViewControllerVisible;
@property (nonatomic, strong) UIWindow *backgroundWindow;

@end

@implementation BYContainerViewController 

#pragma mark - initial

#define HEADER_HEIGHT 0

+ (BYContainerViewController *)sharedContainerViewController {
    static BYContainerViewController *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[BYContainerViewController alloc] initWithNibName:nil bundle:nil];
        NSLog(@"SINGLETON: BYContainerViewController now exists.");
    });
    
    return sharedInstance;
}
- (BYCollectionViewController *)mainViewController {
    if (!_mainViewController) _mainViewController = [[BYCollectionViewController alloc]init];
    return _mainViewController; 
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
        
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self addChildViewController:self.mainViewController];
    self.mainViewController.view.frame = CGRectMake(0, HEADER_HEIGHT, self.view.bounds.size.width, self.view.bounds.size.height - (HEADER_HEIGHT/* + FOOTER_HEIGHT*/));
    [self.view addSubview:self.mainViewController.view];
    [self.mainViewController didMoveToParentViewController:self];
    self.mainViewControllerVisible = YES;
    
    self.navBar = [[UINavigationBar alloc]initWithFrame:CGRectMake(0, 0, 320, HEADER_HEIGHT)];
    [self.view insertSubview:self.navBar aboveSubview:self.mainViewController.view];
    self.navBar.tintColor = [UIColor colorWithWhite:0.8 alpha:1];
}

#pragma mark - handling of window (dis-)appearing

- (void)displayExpenseCreationWindow
{
    if (!self.expenseWindow) self.expenseWindow = [[BYNewExpenseWindow alloc]initWithFrame:[[UIScreen mainScreen]bounds]];
    self.expenseWindow.alpha = 0;
    self.expenseWindow.windowLevel = UIWindowLevelAlert;
    [self.expenseWindow makeKeyAndVisible];
    [UIView animateWithDuration:0.5 animations:^{
        self.expenseWindow.alpha = 1;
    }];
}
- (void)dismissExpenseCreationWindow
{
    [UIView animateWithDuration:0.5 animations:^{
        [(UIWindow*)self.view.superview makeKeyWindow];
        self.expenseWindow.alpha = 0.0;
    } completion:^(BOOL finished) {
        self.expenseWindow = nil;
    }];
}

#pragma mark - Stats display handling

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    if (toInterfaceOrientation == UIInterfaceOrientationLandscapeLeft) {
        [UIView animateWithDuration:duration animations:^{
            self.mainViewController.view.frame = CGRectMake(0, 50, 568, 250);
            self.mainViewController.view.alpha = 0;
            self.navBar.alpha = 0;
        }];
    }
}
- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    [self.view insertSubview:[[BYStatsView alloc]initWithFrame:self.view.bounds] belowSubview:self.mainViewController.view];
}

@end
