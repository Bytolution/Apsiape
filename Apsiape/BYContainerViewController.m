//
//  BYContainerViewController.m
//  Apsiape
//
//  Created by Dario Lass on 03.03.13.
//  Copyright (c) 2013 Bytolution. All rights reserved.
//

#import "BYContainerViewController.h"
#import "BYMainViewController.h"

@interface BYContainerViewController ()

@property (nonatomic, strong) BYMainViewController *mainViewController;

@end

@implementation BYContainerViewController

- (BYMainViewController *)mainViewController {
    if (!_mainViewController) _mainViewController = [[BYMainViewController alloc]init];
    return _mainViewController; 
}

- (void)viewWillAppear:(BOOL)animated {
    [self addChildViewController:self.mainViewController];
    self.mainViewController.view.frame = self.view.bounds;
    [self.view addSubview:self.mainViewController.view];
    [self.mainViewController didMoveToParentViewController:self];
}

- (void)displayDetailViewControllerWithSplittingPoint:(CGPoint)splittingPoint tableContentOffset:(CGPoint)offset {
    
}

@end
