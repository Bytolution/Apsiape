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
#import "BYHeaderBarViewController.h"

@interface BYContainerViewController ()

@property (nonatomic, strong) BYMainViewController *mainViewController;
@property (nonatomic, strong) BYHeaderBarViewController *headerBarViewController;

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

- (BYHeaderBarViewController *)headerBarViewController {
    if (!_headerBarViewController) _headerBarViewController = [[BYHeaderBarViewController alloc]init];
    return _headerBarViewController;
}

- (void)viewWillAppear:(BOOL)animated {
    [self addChildViewController:self.headerBarViewController];
    self.headerBarViewController.view.frame = CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), HEADER_VIEW_HEIGHT);
    [self.view addSubview:self.headerBarViewController.view];
    [self.headerBarViewController didMoveToParentViewController:self];
    
    [self addChildViewController:self.mainViewController];
    self.mainViewController.view.frame = CGRectMake(0, HEADER_VIEW_HEIGHT, self.view.bounds.size.width, self.view.bounds.size.height - HEADER_VIEW_HEIGHT);
    [self.view addSubview:self.mainViewController.view];
    [self.mainViewController didMoveToParentViewController:self];
}

- (void)displayDetailViewController:(UIViewController*)detailViewController withAnimationParameters:(NSDictionary*)params {
    [self addChildViewController:detailViewController];
    detailViewController.view.frame = CGRectMake(0, HEADER_VIEW_HEIGHT, self.view.bounds.size.width, self.view.bounds.size.height - HEADER_VIEW_HEIGHT);
    detailViewController.view.alpha = 0;
    [self.view addSubview:detailViewController.view];
    [detailViewController didMoveToParentViewController:self];
    [UIView animateWithDuration:.2 animations:^{
        detailViewController.view.alpha = 1;
    }];
}

- (void)bringUpExpenseKeyboard:(BYExpenseKeyboard *)keyboard {
    [self.view addSubview:(UIView*)keyboard];
}

- (void)hideExpenseKeyboard {
    
}

@end
