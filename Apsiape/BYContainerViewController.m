//
//  BYContainerViewController.m
//  Apsiape
//
//  Created by Dario Lass on 03.03.13.
//  Copyright (c) 2013 Bytolution. All rights reserved.
//

#import "BYContainerViewController.h"
#import "InterfaceConstants.h"
#import "BYMainViewController.h"
#import "BYHeaderBar.h"

@interface BYContainerViewController ()

@property (nonatomic, strong) BYMainViewController *mainViewController;
@property (nonatomic, strong) BYHeaderBar *headerBar;

@end

@implementation BYContainerViewController

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

- (BYHeaderBar *)headerBar {
    if (!_headerBar) _headerBar = [[BYHeaderBar alloc]init];
    return _headerBar;
}

- (void)viewWillAppear:(BOOL)animated {
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self addChildViewController:self.headerBar];
    self.headerBar.view.frame = CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), HEADER_VIEW_HEIGHT);
    [self.view addSubview:self.headerBar.view];
    [self.headerBar didMoveToParentViewController:self];
    
    [self addChildViewController:self.mainViewController];
    self.mainViewController.view.frame = CGRectMake(0, HEADER_VIEW_HEIGHT, self.view.bounds.size.width, self.view.bounds.size.height - HEADER_VIEW_HEIGHT);
    [self.view addSubview:self.mainViewController.view];
    [self.mainViewController didMoveToParentViewController:self];
}

- (void)displayDetailViewController:(UIViewController*)detailViewController withAnimationParameters:(NSDictionary*)params {
    [self addChildViewController:detailViewController];
    detailViewController.view.frame = CGRectMake(0, HEADER_VIEW_HEIGHT, self.view.bounds.size.width, self.view.bounds.size.height - HEADER_VIEW_HEIGHT);
    detailViewController.view.alpha = 0;
//    [detailViewController viewWillAppear:YES];
    [self.view addSubview:detailViewController.view];
    [detailViewController didMoveToParentViewController:self];
    [UIView animateWithDuration:.2 animations:^{
        detailViewController.view.alpha = 1;
    } completion:^(BOOL finished) {
//        [detailViewController viewDidAppear:YES];
    }];
}

@end
